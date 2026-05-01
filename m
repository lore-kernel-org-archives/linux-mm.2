Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C73CD3425
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 12:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04216B0005; Fri,  1 May 2026 08:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC2E6B008A; Fri,  1 May 2026 08:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18E36B008C; Fri,  1 May 2026 08:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0B2B6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:51:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13E76C0976
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:51:48 +0000 (UTC)
X-FDA: 84718837896.14.0F2722B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51B72100011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:51:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o8jc6gj8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777639906; a=rsa-sha256;
	cv=none;
	b=hvpY0LBBgvDsbAdkQZM3/FGk3O46S9EWa4u9Mdkkfuv7nz4Ir0yvy8b4Ruqa72l8CRuYkH
	dhi7aPsyAvqA0J+wgM0bpH5Yc+phOLLW2NSvEH0aAHxAb1Ww7bZoJyZXH8o+lhRV0CUowz
	i4fpMmpQn/8k7zwrBmMHGvyWXX/qgiY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o8jc6gj8;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777639906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPFFfjhV2CRawGpxlv4seU9cIGmXORviKLLK/lBN3Gg=;
	b=8jo0SQhvIQXNkpXqHHHd3N7U6u5VLXz1pDs69YffkomXu7RiEiR4jlXfKBaaDftqB8qXNh
	Xt+UF5eShEn+c5pyTorfCyNWQ5hTq6xpxAeEujr15cO6SFVsjajadc0BWmrO9tMSmlPYpW
	fKNgmfDhfA15jfA4ns5T9kDsOpdsMVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B4604096A;
	Fri,  1 May 2026 12:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAA7C2BCB4;
	Fri,  1 May 2026 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777639904;
	bh=DOM6sWaD8PUqkldfrKOzv5eRuIlc3YsbPu+i88S/hTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o8jc6gj8TcHOoVj0RXYs1etvUnfykl4CYFtwin7s2cBslS2NYaa4QP9VVTTjgUVaF
	 dw3Pv18etBP/aI4kCTc89CWnqLEcgPWVeblWq5nzm9iwJALFD6nL07J+5Ro0AClTtR
	 WPyrFW31W9IoDK+T8csAcWeg0sANsoEWXypbFcy4=
Date: Fri, 1 May 2026 05:51:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 "Dave Chinner" <david@fromorbit.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Tvrtko Ursulin
 <tvrtko.ursulin@igalia.com>, Thomas =?ISO-8859-1?Q?Hellstr=F6m?=
 <thomas.hellstrom@linux.intel.com>, Carlos Santa <carlos.santa@intel.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Daniel Colascione <dancol@dancol.org>,
 "David Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction
 loops under fragmentation
Message-Id: <20260501055143.b60c31287051a56295f10205@linux-foundation.org>
In-Reply-To: <afRH+KUNw9zap4sp@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
	<20260430160105.a3b74ec3bb316bbfbf8f9808@linux-foundation.org>
	<afRH+KUNw9zap4sp@gsse-cloud1.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1mn8zhj81is8os6wju13nd1w1gwbfxdo
X-Rspam-User: 
X-Rspamd-Queue-Id: 51B72100011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777639905-812894
X-HE-Meta: U2FsdGVkX1/ZoL8bewePlTWjmr40VMaI4Zh/sPEfjpYzLjWM+7tGzlRSjUqXkt97rb4grNMwGLu1bitVeaQB9aZmrwKU8oKGKHsRzacU2wfSvpUU62q8aTJo3PekDDi1sG19rIgYvvZ7iwtp6l+bozKscaHofO66WE5FBtiyNCdmLj1M/s1AKHW0GXrzu/EpQA21sUzyQaNayX1m6/Z48W5u1FeqEvwNYvv1FO5eTG9POL+qnev7RLPNwlgtN6Lcyvysp7cprg34Vfk6ugnh75Zks02JwT+laT80swRHXuRG4m7MSJ5efqABd4cCrXNPsn+GIYgH93bMNcF/w3aCN6PxJiXLDBuCqlnA+gDyFUCH2ZPHzJZXpRE3Q9lm9n6L6otWgFGoc5OV/u5Y+UF+S8npyqVhyNfG4V7BPxsw5uoJ3AJSSVH0pRjrn5LgdWkRGqD4pZ4llsKnZ8LKYuMbC+AJs8ucOn7rYqa2jmd1gEaBLdsgNIR0dieGD9m4votIDFTwHRjmVuxM8e821ACCXpqIZhVadoIKWnewhtqqMHeFucWcVuxpA5cXGE99yIYQ4gAJyESniV7+BP3lYFofGLBnVQ1Asr5yn+MjixCSij4KYNTYVB/1Zh0OlG2HiHpfilSRLIyzZf0z3cywClQU999+EO2FhuZnsOR/EclXQoyJ003NiZFb4q+xOObKqxA+aoCUJ9t4psq0DwO37u7zD/+B/LVBq4I187j6IHubgMLWrWHeA6iTS78n3JEkaL4Ehi/3NoyLn4lK4fJduR86zok129caJX13k3UqapdiAozs5EFUDJm31RXLMR9abnjYhvxdaRPPFMfX0n0lOXOdjmXaM67//ov4k42UA2bTKB72Lrheg32mhHtekBpSqA5hOrx/Z7oA5M14v9Enl/YkoQ7Cf2ETsknb/0X8CKIe5Yg45GQVSPaYX6GOW6lNkkIiQV8ACJOmsljenJmN4gs
 QV3C1Jw+
 DTdl+qo4T8NP1xhMzMiPerUDX8ylqhHdH1lpEskEWoK5r8lqmFPdJw8XtFpySIvxWDVQ8hejVjNj6mS2Jp7/mJyUbMxqMdPvJ0oZt3iPRAc6cPPhEGM/BK1eqiu7kIL7JJzN7B7tcijLIeMSMFPQZJuljfsUcF+ocFqUDhMRlZtQjOAaCVXbIASO9Ngk76UCVP7waGrQOfleX7f1J1eJpNNYvwTq1BBFRU47KUbbV9L5HeiNDYdRDTqSQpWuzt5sV1a83JmYnShi9cNbGwoGiua5lxBpRVli1lptfPn2C7eIu4/4odnvpLfQiHj5YeK1WWdvNcf9OZsLOIKVnatia1PxrTsrtBgYzCPrxbrJ+z8C3jVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 23:28:08 -0700 Matthew Brost <matthew.brost@intel.com> wrote:

> > AI review flagged a few possible issues:
> > 	https://sashiko.dev/#/patchset/20260430191809.2142544-1-matthew.brost@intel.com
> 
> Idk, who authors sashiko but what make it really nice if you could reply
> to it to talk things out.

It's a gemini 3 thing, based on prompts developed by Roman
Gushchin and Chris Mason and others.  Google is making this available
to kernel developers at a non-trivial expense.

And yes, it would be great if Sashiko were able to learn from our
replies and to fine-tune its checking based on the human corrections. 
I've asked for this a few times but didn't really understand the reply
;)

