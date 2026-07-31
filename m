Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A4EC55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F406B008C; Fri, 31 Jul 2026 17:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6101F6B0092; Fri, 31 Jul 2026 17:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF936B0093; Fri, 31 Jul 2026 17:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0A76B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:37:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACB14120110
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:37:37 +0000 (UTC)
X-FDA: 85050383754.02.9E2946E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03B2E40002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:37:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bsu9prvl;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785533856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1+5FJ+vsFbhTS3uy6QvGBbTfrl8nRF61DS//Z1gGs8=;
	b=MYQRK/Cw+wposXH+ri2ag+fhHKmQOCUM/Z9T/udBd0DEhaO7KVFwgkKZFl8RB9YbuVegrD
	0M6ZYJTlpg0b2F8/I4xdpaVBoGHdn5vQQDf6X+fYtHGYZI3xY/P1yHoJuDNjhoGRcd3v+R
	hfT7+3/aOS7JI0e80KLBMBZZkaRfdMo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785533856;
	b=UktJQTP2vYmxo7t7B2cQym/wBgZgMZNMBDAxH5Jt6YTYQnUEIoEU0uCVZr1em+HVokLBN3
	W+qAiMR37bAU3X25/z1Ep/4SyiBeOusFcoHfvMhxgFmN/YJAiOrn2qe4EUYDHAnf6vYZu1
	kf8MRnSI/6U8vn5QzB7pAMXfq2GS9H8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bsu9prvl;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E2F7600C3;
	Fri, 31 Jul 2026 21:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FB1F00AC4;
	Fri, 31 Jul 2026 21:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785533855;
	bh=O1+5FJ+vsFbhTS3uy6QvGBbTfrl8nRF61DS//Z1gGs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bsu9prvliEAtWl9141QWG8ktEUrv3SrzZW0TRFfh52pvi18ypE6LALcgP5+/3tl5p
	 chd7Y8huQ3OCgGlD/A9nlhMZoYfi1Iu1y6/OkpTPWSKlaEZNueaXh2uQfIC1pvoBtY
	 SewvgNsJYjVN6u7HfHbW+4sjXANpuiXr+fCVombQ=
Date: Fri, 31 Jul 2026 14:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Liu <wei.liu@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li
 <longli@microsoft.com>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Min Ma <mamin506@gmail.com>, Lizhi Hou
 <lizhi.hou@amd.com>, Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
 dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260731143733.6f74ec9b9023f898c3c260e1@linux-foundation.org>
In-Reply-To: <20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
	<20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
	<20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03B2E40002
X-Stat-Signature: p7eb3wypjqwck8wks53kueohuchd3z8e
X-Rspam-User: 
X-HE-Tag: 1785533855-568159
X-HE-Meta: U2FsdGVkX1/Rj3DZD1higFHbdbuGjIOikC6W2v8j4C+nic5y3ZttbyODKS9EY1FBwfWHC491rTFgEEMFcArLqsjCvXI68Z4brDp/LsvJZtGFsPtQLjinhPch1sC2PB3m6Oq6UfU5rx0MJ8SoT9QctYSQfELYu5HDadOK6LG2wL9Ogc2mBqBAymDZmrh4ZnEXGRv6W5Egr2oGieZSNzdWkY0T3l4URJyClNd8JJS8hjh0p87pw6q8VyaWOGhgLWS70sdG8TDXfCeZvZFOV16txebbE+QujTh7Pfkyk15fGrvV/vI/XUeirGPE+4eP+GTl5qe3giNZUETnTHn5dF5qY/6MuDyizGGcsnWaKJY7OxryUBn3AHybINPS0no/axRudEi3OSpqp1GAjXbdEZZLZtDIst9jyz6HO3Ln+kSmHoCjMWd8B/PDsja3+3J3lQpcxker4NpJKE/sTxhjl8UX7/Rrttz6CHkmwbkjlfGqA6ysUWWaakbI1NqBonDG/gjr80qiaFfYl9XpymKWyXycnYDnw4fIadq49b1uVSqoYNt23HIefq8YIMcRWEtHgAT3w8/9SPZVvIDjhpneBIwwxCU/YSFyI9+AYzsC+MZt0+hET+LmA8N7SHZCAxBTkLYvEZyhnpwnO26XNqtVifhHY2vBs1oUl3TKw9g4J9qV3M23XKfVNtvsSZIG6+PZeeUviTyOxLLehvqWutMLivsBYtZ2jjCp7Q9OQpHxO/svVP7pDxZwJvyz1+Cg7ZsJkEQ8DvrVb+7MtoyXMIgVP931CjnAyDR2RuwUek0cXI0QlN5Aqj73HLxErsmwi6o9IPXMb3zlnwvDZlsTaj4W3SVLZvA252vbk9J9F2bkq/9KQMBiYh52GTN4SDyLfY+ODooNVFTeogqldgtWI2qZ0/lx6QF6DMhZ67/Y18IfeQvLlBd7mzYv1yQEDmv9xKJYE2ClCrazzwmQutiO0oQ2hmL
 Mrd7Io8y
 8iZrz0LlHAY0+6fWNWXMxRZ96rfwVHKCdMVxOl5wWG9h1BsvdDVE1zhgtxFCqxvtVtSotgxGkeJU7sSLJpXkoiJYjHGdrgLgA+WMBsVxzm7LvY73kig0yVY804pdamMG+co3KhHjnK30gaasJsu5pTmkg+Aa3DfrJiJcXHAsXSHUpufY4rHQj69XBEX6Ov/lP/EzpKNo4XctM1xDvSHzuWDyBh96TXtQDN0rAopWjmYz+XwW+vdwcptKeNMX62jBP49UrVeHPSszcKnpFjP6RelTj2SUnrCuC4t6TGNNVk8XL8nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 14:17:28 -0700 Wei Liu <wei.liu@kernel.org> wrote:

> On Thu, Jul 23, 2026 at 02:22:42PM -0700, Andrew Morton wrote:
> > On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > This series extends the HMM framework to support userfaultfd-backed memory
> > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > > 
> > 
> > Thanks, I've updated mm.git to this version.
> 
> Hi Andrew,
> 
> I see this series in linux-next now.
> 
> I'm curious to know if these patches are going to make 7.3.

Probably.  The series is incompletely reviewed at this time.  Perhaps
you can assist with this?

> We have some work that's dependent on this so would like to plan
> accordingly.
> 
> Thank you Stanislav for continue pushing this.

