Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF2BCCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F5B6B0088; Fri, 16 Oct 2026 11:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1A76B008C; Fri, 16 Oct 2026 11:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF576B009B; Fri, 16 Oct 2026 11:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3906B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:18:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74795A807E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:18:44 +0000 (UTC)
X-FDA: 85328846568.05.50BF801
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id AE4EF180006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:18:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mNQiUgu1;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792163922;
	b=QY00B0FwbkIYsoYJOBkjvGW8+F0jLH0jOcHIlGaD0W/+wagpW7lZNMy/0PYJF79LZgvELd
	ibqKFAgOudjYXrC0COvGsSSu8JuiF6NlAk3g6gQhZj8oFLTb8A/yRs0Fag9d19dhiVGTHK
	o0PE3+cSFxZHMr98RvS8PfzGdaJc76Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mNQiUgu1;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792163922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTsOfT7qc4+y/R1b+Q3dOr5vhFSgpJC8pEs2pNorJ7A=;
	b=ByAImZ5J4m3i+U1rrJ9PyG/axZSdkFIjNyN6x6Vl05ogmCA0XeZCTwjjubvcSXxnuT+WLQ
	aEMZal3vJy6unAiQsWG/VykLIcvV+INefcFZCDob0AGVy7eoECJ2PR1y5hYf2PLm+Vn3/y
	dlk0oFzmQhu2P1i4UimNzojC7jX0B+0=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917a707f37eso1323606d6.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792163922; x=1792768722; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gTsOfT7qc4+y/R1b+Q3dOr5vhFSgpJC8pEs2pNorJ7A=;
        b=mNQiUgu1Cnu29+FFygktTgprXHbDCJVV1LTPVLGMCosu4+wMUIdnTD2UYebqqPL1hx
         4C8Bn66siuYWWwTBtIaoAiOXSrcSU4LbBJgHUhDQncBKFClJA73C2rhablzmXLeHhTJS
         zI+dHelyquPOujB/e9Mrtuk73ktH+rxqxdeyRUedlHluCP0TfdlL2VGAM43R+fjZwABr
         Z1JC0oJFLRN1GSRcTmVtrzT2ht0oeoxqYMqsE0/hbNvltqmlkira8UEincQ6pILXGk48
         kIj/344hUHyDDKO6i607FwIbotWVfiGcS2sU3kmCk+RlN85iLRYCqX7SAr04l5ETqhgY
         sbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163922; x=1792768722;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gTsOfT7qc4+y/R1b+Q3dOr5vhFSgpJC8pEs2pNorJ7A=;
        b=riGS+ZZinM105wsBLpkCuRfZj9zDMuH1mM8dUHlcHfY2iy3xO2SZI9sS7rOzCBkFfx
         v5bJrNcDNnBN5YdoXSXYfJyg9244WPf7WA5Pl3OiFqYiA8FsTd912jzlQnHRjl8dmWew
         1cO2OhBzK6xw8DKXglMBcOetsHFFUKMjf46qbqbG3QYjqacbJE2NF44nEFzdrRaDgy3j
         l8U55fpf3XB9MbHgSLgaVcuovXA2Lho98HuVc90I0RPwE2O0Fr6J0RFfc+TCxpsgeEUd
         cGSN5GYgUQtbmZlQ9j4U7bjsNdY0TtrEWn1OCMuKha9UCWrapybN06rrUaKqEvWkDHe0
         4KcQ==
X-Gm-Message-State: AFq9FYK1HEg7SPeYZGFH6qlE/iJTJrN9WmHJ2DZp/q7FX1zFl7FxI2qa
	/ElGIeOks0qw+K0OcNdyqZcVLfIDwmijo2b+eVGl4jblOJ+wSp/goCueC7MGihPqQPF3vdjVPUS
	sALmliuM=
X-Gm-Gg: AYBFou0a6rZOO5sXpxIzcY6VNEdtHdSYR0csg6MOkEhYA72z6fSYM2WDjxQz2daqAmQ
	x0jD0/9xsA63v+lfcNzbgdNr/k+6Bp5oRXFjnYjtAmVpk/xq6ENSgbgTlVpGRe6yt/WZQMPd9OJ
	iLQoSgk0H32M5V6LBJXQsbolKD5oIFSdkitL8A7JqVgGtsYHdEQs5YrXSuLKQuAuNv8rT8/MQdh
	oY3kZyT5z9ebD4smKopG/K86iohZbsFubB4xr2Ezejf3Nf/tMgfxNmG3HSyDpK/ssUS1eyTywK7
	fn0mAP/nRYzv4UV0Ra+nAncnayL5lNHGIHjsjtthkFPS5Hvb9cWoP9EeJ5tGW++h5lP9VgYbwrb
	EieWFjxxoYb7rAqh8Ir0TnjfQng51GdvOKy5bUAYJARsgxWA4J17eOz6w2fo7Zy8cH+RzTLiNZy
	yT2JKzSlTBRIiL6gu2k/ShUR2u/LxZJsqnr36tMx92gG/HQzJxe1vdvt8T+DF484xjApvchSOOS
	1B0q0hzxbCPIxl/GUsf7j0i1yiYnlWOaT5v+CZ4u5bAp8xZOiy07k4=
X-Received: by 2002:a05:6214:202c:b0:90c:b843:d679 with SMTP id 6a1803df08f44-91bdf063686mr5556436d6.29.1792163921793;
        Fri, 16 Oct 2026 08:18:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbade61csm24949136d6.26.2026.10.16.08.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:18:41 -0700 (PDT)
Date: Fri, 16 Oct 2026 11:18:39 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, mgorman@techsingularity.net, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
Message-ID: <atJAIfZ55x68Ft8p@gourry-fedora-PF4VCD3F>
References: <20261015210539.3243563-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015210539.3243563-1-gourry@gourry.net>
X-Stat-Signature: oz8naobtfadkmgqsxnf1iwjt7wsx435u
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AE4EF180006
X-HE-Tag: 1792163922-857737
X-HE-Meta: U2FsdGVkX1/bJsmlChe8BQ0LSv+nMo0TGX/k8qug+pgefj1jZjeDqG76EThJBWRz9oQzSQ2SCTts6etinTHZYoThTlWu/Qu/6xraETd5TB6gkFeg1U8Ss8ihUlaCBwnec4E70f+V5UB7Andjocu4KQBnjpWf7WhYJdLsIi2ORPLrzd8Z4+AqHQrPviMiC6yO1V1Sk4beVHEmyjpFxZLfJbI5MfyO4se0DxNwi553emkpeUXZOk95iq7mfZuI4o4Mjfs2JZSKoe6jmOMD/jGIEP46wYndP/CTlzE1ePH4DrPPU3bb9tCXIZ9xXjDAvAUchZLfuT30jdsTSBNtadgvtEsLY4gfZm4KbviDN4/6IZD6Qi6EHmdLzJLbX/Ieh8mCasAj0Qm9SkgQ3j6XfJ19Z711KJLPP7xYywFQiUhl5xtGP7abl9q3mbiTufAnSKar19ZwfTcbo0O+Wtrv71hFtSky3XYRhdBfKS3TyC/Vk3F9lRx+wx/7ceHQJbRUXn3JZJOsRpOdxHvcnoaf2m8OVXDPTgbvlID6XAz1MbGmbkGO/0Ebved6KRkO5ii2K9GG+0HsV5emRbDKOIJa9XVgoCv0G3EYZIbTQHVIVR8nQwnXygPdGNDbPWxgpi8t59NvWTHdBAul+Pa8hiCdJMAjMc3cD4LeXFa3/Rw4itlnVctXbQZFb2rMvKivFfXGETmXXZ7ZorSLk4LpG/PhNbqZONMbj8Kyf9wUIYcNYOdnK52dgaff/0+bHUd+at/csg5CJb9CepZXZnd0Fhd+wSKq8e4Sv4FPorUPH1egusF1bIQcblWERljvu/NuCcrbzV2jui26LLngZUb3WWtyogJ9djEekglJu4xHXpwdjNetWZo2XYKQ2XYlnKHQkR7I0HHiRF7Sxrw7+aJA+ia+BfiDJ8y2txDxsCqufOb7Za/fJertrArGJ2phOz8SnOXEm1RlSotKAgaWSInIY6mnIRc
 0gc7VM8g
 vigw7blzpqvXFoWXc1KwnVQbMNXteD5jNKl3xB/6aY+SVr5CWboEvhZpKTACOnmXuejxhZZ0gaM9z/mu45njhOyWMf/Qwt7JFNt9r8Dk+Ex38kbHGEOMRKzmstr297TotLD1SkzViYWvgQl9nXdRG2i62mHJ8Jzx5VPd0A7IJcodRwKWj/5NfO6GBH4xHna1ZNTTvwXpDicas6Zp97r0e1qb4RgDI2EpqXxwxJWHL7UquUKZJ2IaeREtYkCuxgK6emsQRSCW1a/VL2LKnd833aoP45s2WKLBO2602wTS6J3VzumPJd+J6zZSUKUNSjhbsaZ2wuWIJK9bQ6cpxLWMnF/MK3dusQlxfZDwIiqso2ybcLCdZ06t4GT8nrYmgV/ZrKlM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 05:05:39PM -0400, Gregory Price (Meta) wrote:
> Onlining the first block of a zone (e.g. via virtio-mem or a DIMM)
> rebuilds every node's zonelists in place. An allocation in flight can
> then be served from a zone it never asked for: a GFP_KERNEL allocation
> can get a page from ZONE_MOVABLE.
>

Sashiko pointed out some other race conditions (related, different),
i'm going to repackage this one with those fixes because they're likely
to conflict and they'll all want to be backported together.

~Gregory

