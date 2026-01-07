Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89831D0D177
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0666B0005; Wed,  7 Jan 2026 17:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7B46B0093; Wed,  7 Jan 2026 17:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDBD6B0095; Wed,  7 Jan 2026 17:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCBD16B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:06:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 646CD13AC33
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:06:48 +0000 (UTC)
X-FDA: 84306553296.20.B2D8E7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id ACB1C120004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:06:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFf6Jqxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767823606; a=rsa-sha256;
	cv=none;
	b=E5EGmG3AnO6dzlZY43T7BtzAlMMe+057pn9gj8vnn7mEoIiBZG23IVkxUeGhLK83OSrvqY
	25erR7yLq32nZPPc6lPsdYnp2vofWNCmn1RikN/2Vm3Ezd8IE4zYT3sDlIERTgDUkC5EAG
	tpu1sLVbM3MV8cCc1/7iNik42N9qQ0I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFf6Jqxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767823606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozm9MQ8/GpOglg6lLvQsQe1sICFhCN9FKM8IHVaBqUc=;
	b=6/QnKlJwxS+S1jMHo9WTBp4oc8zYxoEi29yyCSXhQ9/csgys37/hwbyWADJeRAYnIdRE9A
	1pcCBDY/0aQtjO+fNBLXk5L/nTNp7BquaS7LKYN0EHgJjidsa8FwabMu+qHYXSdcUEl8bw
	bbRCdiykWusnSMfOehPKRPzE1GQjKhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 257B560018;
	Wed,  7 Jan 2026 22:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83138C4CEF1;
	Wed,  7 Jan 2026 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767823605;
	bh=Nfvy1yrUUqnBfdePUv1Ij6X9WO9cx0Jz8V0B4zlU5/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jFf6Jqxfric7rq6Q0NSYHZRHYcLnVM6W3Dy+iI1nnKMzxsAWBrGlUGCviBaI20rCw
	 ysMFLuMEJ8KORtuB4b0ZFz33sWzLyEGbVuPhsgZKJisyI0OiQgm+kdo0tYJ8cPvKnU
	 EwpEeDDl9twx1bJRu3WNd9E+6rcHum42NNe8kjkGEb/P0UDVrGgKTlCO58W1WQh+Uk
	 NMwUZzTpKrgYQHTzBBNdYNX4dPJ1fp4iX55bhghSFV8funYyafzlZ3ag5gje1puIPk
	 Jw1rWC+th7/Io9FbYJmcMfwbCa5IkhfHCR6VFDUM9dQ6nQsF8Fh+uJR7RTBK+yGGSb
	 auvJVdOvWlcdg==
Message-ID: <563a6f8f-7a8b-40a8-a553-a51c3e4b9a28@kernel.org>
Date: Wed, 7 Jan 2026 23:06:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/8] mm: introduce clear_pages() and
 clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-3-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107072009.1615991-3-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ACB1C120004
X-Rspamd-Server: rspam03
X-Stat-Signature: hmotsi941ks9pauirsoftyh9tp4pnj5o
X-Rspam-User: 
X-HE-Tag: 1767823606-121710
X-HE-Meta: U2FsdGVkX18bZw0fHrXE0TM5Xdmky+lmQZ6tqhdwLuUTVTyBkWPFbh9QGLUTH8/+zFwD9X1bBQaKScs7iEaM+OUHPyDDwHlI6eXGf/niBJxGcAbGCy3l8098UBPXoPh+sTw2TzQfpWeF38ogJqeuv6x0Js254dcJLrfUeU05wzpZlrbXezVO8WzihiKkuDr+cG+kes7Fxtns38RJzLNI4f5h3h4uy9oR/mrvNVG8gBbm8FgBBkul505KxUdaLzE4xPL8RPZXz5TM9P8b/tgqZOj43yFJkgHWNey9SQ8a7/gUcNBBsh2SoWQxnTE1GQmVTZ2qByZc++80WwgkWxEodbTb4Qpp4GU1sX8P2PsRN0rqnajYFnSj0MOxki76ZaC7ReNcpaEAW07DO/2N4veUhMHKs6x9/Wv5R5Nme7H0suVfPhzMxBlm9oloEq4jw483uzIyKhlpMzwufCzgNpgzivWjlHI+wOISxBSMxFi7e5RL7eFRuO3thCkl4ghhloGPBVSOAp1E0u4iPrNpmaXWJ7gj8Lf7B0o+fLC647PC4+8ZswPOL6JQd4zTDjK6vK8pn1goV+0YvjeobZBLIv9ZOJwkxbgACv7dmnwl4pqA7yUZb6sALabeDKDiIxLtx3nE5DqiQsGSzsZ38+DiGNpRGc8V8kdHcIQCtuQCB4I0+bmh1gBfMKFiU2Vyquyh81CMwKEUklD92Akzr2eAsu/KirAZIegvHCVXCsvOOXWn8jNpopEcJNcV8GKo1UzOtvIRX7SSTfRFMAaOJFhXR3po4e6Y34W4TU4pGI7EM1hMa0RdjfST3Kntw3ulrSPpfCflSm6XAmewv/JDbOGFruzeqNOM4IxwyPRj/+DH8fa1+HV35tWsFhBcp52BzgOg5TW31jY7nqKqJsXSNPAnD08PTaGgwsn+RlzZunNq+VRt6Q9AVmU2fSJOTwGbGZYdKX2X6q9n0nu60yO+xHZ0bKZ
 B672G5YG
 xAGRLJRXwIgaM7cJOkB6nKKvlfxNCf2SyyTsmFj9QGi1yIgb/krZwXZ6VbjzUiEdfWcJxYmA+p7Bb3szQ0x9TxVCAKVY+vxyuYYes1nVODv87OHF1VQN+a+D61Mae07Z/zy3z5pdm8yHcq0LXWBA7/W5GWC6n2FrNbDPSb1hsLsmxikYWM8KlMUY3Uj4oNJuJohW23uSHAVwQ0/wIBB+WlU8mcJ68nh9LJo/Dpr1Ppn/4X3Z+BHhLsw3UsA3v7NS8x9rm/WkuMkDbo6fmqMWr/zvkHlDcBXn381Uwpt5qR8DQpDkxfxLQyUEw+TlgeT8fI+AJGJylOQLRt/T16t5zFrdftrqYlcHvs3Vp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 08:20, Ankur Arora wrote:
> Introduce clear_pages(), to be overridden by architectures that
> support more efficient clearing of consecutive pages.
> 
> Also introduce clear_user_pages(), however, we will not expect this
> function to be overridden anytime soon.
> 
> As we do for clear_user_page(), define clear_user_pages() only if the
> architecture does not define clear_user_highpage().
> 
> That is because if the architecture does define clear_user_highpage(),
> then it likely needs some flushing magic when clearing user pages or
> highpages. This means we can get away without defining clear_user_pages(),
> since, much like its single page sibling, its only potential user is the
> generic clear_user_highpages() which should instead be using
> clear_user_highpage().
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

