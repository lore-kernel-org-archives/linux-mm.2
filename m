Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D235ED0EE14
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5C76B00A9; Tue, 25 Nov 2025 13:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3560D6B00B0; Tue, 25 Nov 2025 13:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C226B00B1; Tue, 25 Nov 2025 13:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 14D236B00A9
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:59:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACA13C03B0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:59:51 +0000 (UTC)
X-FDA: 84150043782.03.8126666
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA0A320007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:59:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fEuvQ9/8";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764097189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oI7QpqsgaAXNs5fSsmWrP7RbB0gr/S8a3fF7phT8EA=;
	b=bQCgP3lP+FnITnMyXRv6w8l4n3zN2jnLF+ds1bAXXOX7JOH7Ua0hVzxUeevy7EdJ46p59g
	2UimqXB8i7QEqgvCn+PU6V57K10W7nqip1sWBMYTAiaPUfWkp6ZfvBLLXqARGRejRUYnj6
	6iLERfbLLOtQsGv2Vlfx1JszB9Gio1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764097189; a=rsa-sha256;
	cv=none;
	b=ta75tQ11uRtaDVbdxhE3jE/HsSgBEhbfErGL+fHUbMmLp5dyhpAwvpXk2PhdabRhClV/VP
	DE3VwWkWFFwuZJ63m6S8490oodGlcIQaVx+yoIxkqp6f4IOtbrF1sHFOPNn0cVqlfYj4Ll
	+O5pzVwWSxMw56Q+hFwNvHh9IbgizA0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fEuvQ9/8";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-787e35ab178so56515117b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764097189; x=1764701989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oI7QpqsgaAXNs5fSsmWrP7RbB0gr/S8a3fF7phT8EA=;
        b=fEuvQ9/8ZU9QCjZW2BhYH5nDaYYET7uaqkmY0jVJn0ygyu5VpRHbNKLqPFdDT6acrF
         VjaN5Osd/BXL1AQBdNzCPZMPCyMFddUXSdPFS7rkNhOE3qDoQL3Ip1glf/NRNMfSIg2/
         3OeDQR8d2LAQrV/BkXVADtLHsAEvm7dKXpRMXa157sAxgNz65wDQj548zMwEuWtb5oix
         Z/CXHSU3BSZ6n3ys3SWc4tPRUYM1UOXFIgd6qGml/Y9y3+qAb228tLTaD5Rc0frdEJE4
         fOsP/ch9IGr0Fp2Znx5cUtFcaP/13GCYiJbwPJuCpxqsym7LCwcDL/L5PyRbR62GwyXS
         WGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097189; x=1764701989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/oI7QpqsgaAXNs5fSsmWrP7RbB0gr/S8a3fF7phT8EA=;
        b=kEE2pbCHdGNruz2PUaBOiDSXvAZT+/1Nz2aQi5agfwotZ7BNfc/OrH9pkRZ8+whWy/
         6VW5qXoikvHxnGyvMfxFw3DNrUmUcEFdjawdzxPg28Z9e77HJ5Hh9RJ0rLRLCvxHLfNe
         O7YnULtZLvCAPfbxWjb9+B9jQd/lih5n2HZFE5Gv292rAXKTteO50g4Ll1Egz9SYDIZo
         7KEU40p2OvAALeZzjmHANfUcow/07Mlr7Z8JzbMMVNVILkPog62WWdTte4U9hOGcgZq/
         cspEBky644QIeDFoLTk9XGQM3zQQl59eDBI2CG4KsFtl9v+X8qyqbkxSZ/ifRhwc5/76
         CotQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh5BaonuNem+AtbaCjABY0MRSMzlOn7qWkVJax+J5rqM1X71lcRyLYdW/CErmJpR0B9ww/WWHMPQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9LYHRmqLyuofukX/rrm64J3G7zXbxHojD/tQmVpbRpPq882kX
	DthVEm4bFb+RxbXDuqAsoLdRmCKgyO52GgXzxCu3p62dUNTIIg244+P0
X-Gm-Gg: ASbGnctrk8D/gF4Z0UTZpMrC2XF3F8IbLmUYT79m4yBhmZaRFfIlNgycdoHZyj6Jvzz
	pEaoJmCFXOcKwaCLVRHXxZxkqLwD07gEd9uXB286QqaNh3jJ2twV0skbRyxNR/jzYgG05amd/e2
	lMmKsBwmTk8uL8A3FNvPA3+NG07aRA0dRSvsZ5jb7Wag3vTvRnSOdYiQyETHLfInmjAvTgFXcz8
	8kUpxv6zzpt2+Sjg4MxaETnuZrDdKtRnn4nScX87UpSf2Fs3kW/cRGO02P0RUYoBvY8nzr1SPh1
	wJd08bBu20rFYGTXExpOPwxIwLjEcX3G91OhbOYE51Hf5jTvJiscZpVE/qMAimi4bTnLmW/ajuf
	T4NbFruz+UlvxO+6kODxFH2fqcQaWJxn6zHJ9+f42UH/iEdmeH5+HjlOyrN8BmBR16XvMWNW80W
	pp69UH8dZ75GiNNHDLA42D
X-Google-Smtp-Source: AGHT+IHGLpobFCCVSZKqPY04RjJR07WAsM7OXs7pd/4CTGsptjrFAqFqJFCLIqBED/AluToEt9wC6w==
X-Received: by 2002:a05:690c:9c08:b0:787:ab13:eedd with SMTP id 00721157ae682-78a8b528950mr139917977b3.40.1764097188861;
        Tue, 25 Nov 2025 10:59:48 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:7::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79925c85sm58762887b3.37.2025.11.25.10.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:59:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/mm_init: decouple page checking and init_on_{alloc, free}
Date: Tue, 25 Nov 2025 10:59:46 -0800
Message-ID: <20251125185947.1593647-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125011808.74845-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA0A320007
X-Stat-Signature: inzd8kpq185mrjredt5qtpxoabq8f6bq
X-HE-Tag: 1764097189-862410
X-HE-Meta: U2FsdGVkX18XOBJo3+9mex2L4S7kZLZoBp4Dkd+mbPt9matTqGVTX/Q4s9S+AW0Kal3sMTgxhF8LMU0u6iW0g8paK7aF+ueo2lUDZfAneX4WVMRUSHU4oHuRfiOHb3xY2Pt5pVE8Uyqgtrp+UA+gAiapCDpoDwZQFk14q8MU4kV38lpiKFZv/qL7jMcpkyMStztxiY74ViwN96Tb5vMdeMe4AquXcokl3U3Kd6qogiZujKLA1mhGlwBoqBU8Xxv3Yu3dKbx1V2/WMb8INyiGM3BS4R+9sairc44ls8+52X7ZA025EoT4ESH6UtgedpOPmED5IkBqltklaVrwrHU22kslW9KV9bAjMH+ae6f2hKVHpfLmReoozt02b6OU82Lii0dgyrKC3uNx8DRRL5KJmp2yG0g24E2dLzXRyutF3jcssAuKl0iHdSvUWSs59XvS6C40DZdmFrSRHa2Stik0QvJVeHwzL60GC8xzdOMpo0xgVOAiFf0kKp2A/AkDvtIKRcNdIhkZofckuzbt48Xt4Bd5CoYtDOraW8Xce1K1QkKUDjX3nYlIMBgFUhNYw/fQmKFx9QfMfJdP4xiPFi5QtufLfXPpjcbLR7GP9Qc9QMAYrCmUpSyAPJPr7JZGA25G61JUxy3eZSPd+mtnrCqA2Rc1JoH2jSUgvr5c0kfk/XG+OcgbljoYUS+BZ8trjMrs60f/TB4HYeWYopuYHkaDlBswfSDUCRwnysOfkM+rp3welXv0vBuaoXpzg/gRQJAoLaQEolHiszq06UsQv9ml6b/2LvJPhUmqp7vveTAbKLMNz/LAb3B4RKdfPbuPlJRwH4o76ABqqucaCXYAnposogxNiAD3v0YDPcMYVAzudrv4fuUipZuBeEvFulnWo9eYg19d0N1/TISw7q/TA45Z9hjJWl8K/btwfF1RG0nQlGmShKOrsYNQxdFegYzhwtQFOJj6utA5G9njvcbVyap
 WtlsCY1v
 Tp5ak3cKId4rTzatpOX9ny+2Sbeii5g9hoA7Ff5ImlabQx+0G1KXl1uLgpo6sof4ETpPffvisInqxfntVSWOCo/y183Dg52k2MzM1sMtbqPMYnLBODLyWs0G4xWiZYVDikPM9GbVSQFKNjO4PImP/1LrOE//7iITi3N2hATPAtidtUsA/JRP9+NEyyJbdPoXb198V7lM5RCJt9KEG3whq0dLUsRUGv9Aztye4bmDddSNGduBvJ3gly3aQDCOJ2RMtOwVO9PRQxh+2PkTTBpEZna0eJ8ybJrNEMcZlue6o/b3sxzAGrPHEXQDo0Pxq+GXZkEwlAGBMFvBBG2c57lVPDA5irUjledVzFU9mIqaWIZDghZFM2heVQLHMS7F8Tj0Z6HkRDPE0OmLv+2xZocf17rzm+YnbC/jo2zxDdCl3W479iFy11L5G7Xy3K14iCop8Hc4RsunC0lY07by0utuCk2Pj9TCsYt1KQTnV2Pl3MEegNa2zoblFxoQ1fIVyAGYefPoryDIaCZQyElFYynDfEJ4SNj1/Dw2maXk0ynygb7y/yTuSC3ZhjY+ablVA7ltol7Ue
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 17:18:07 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 24 Nov 2025 14:54:07 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > init_on_alloc and init_on_free protect the kernel by initializing
> > allocated and freed pages to 0 on allocation time / deletion.
> > Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce
 
Hello SJ, thank you for your review on both of these patches!!

> I think 12 digits for commit hash id is enough.

Sounds good, I'll shrink the hash id in the next version ; -)

[...snip...]

> Acked-by: SeongJae Park <sj@kernel.org>

Thanks again, I hope you have a great day!
Joshua

> 
> Thanks,
> SJ
> 
> [...]

