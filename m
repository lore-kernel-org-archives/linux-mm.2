Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F38EF41808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06436B0089; Mon,  9 Mar 2026 12:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992FB6B008A; Mon,  9 Mar 2026 12:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCD46B008C; Mon,  9 Mar 2026 12:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDE06B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:00:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A37C1A025F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:00:01 +0000 (UTC)
X-FDA: 84526985802.07.7DA4E8C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63A3DC0017
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:59:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tx5jv2N3;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdgCe2J3lvudY3Ri4RUwnY+/LSuwRgctaurAZvpEmI4=;
	b=uyKnHvOTTMNWOF1aL99ozD3Ucp4s/ChssZfg9TiojJ7k28E+0ElDMtSTDI1bp40Xl5vm9D
	GFV0dDok0iPbd3HZfkxVhdYA+w0unBKWLoxW/bSq1J7S0mZOz0eqSLXMsHYvJaTL5ofjv3
	MhrAHEWIfueZFkR3Rm+ampV/vbTZvy8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tx5jv2N3;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773071999; a=rsa-sha256;
	cv=none;
	b=WgSQ89xMdMEcruHWYnDJ22BM47BzP1ZnBFnu0DqJGS05fXsemJvVrKVAryw2Jj9m+RvKqD
	241WRnfesviNCTelJb4bRaeMT5IJcF7nK7qIkH6kt6Y7WFmIilv5prbwVqinrqvRtxYaK3
	PRoC8AfhRV58ChObIoF96W96bRA102c=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ae49120e97so157115ad.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773071998; x=1773676798; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TdgCe2J3lvudY3Ri4RUwnY+/LSuwRgctaurAZvpEmI4=;
        b=tx5jv2N3MeaXGD4NShLPTEHtc+jfCDzeWENQD9FUgUz7NDWEEgJba/1uOnA0KxDxVs
         6KM6pMKSq9YE08T2iIYEU4a5Heh26gH7GWnSzxdN5GGGS6fxeqmD78s0TI5mYzHM1rLF
         Cd3mvP0VotlVdORGrjzh/Lr0Yyf8ZKOigUjoOG8huMEByw8VzDWsMieHDXa2/mGk4OWR
         xzSm/qeMZI3kyqm0dy/hAk2ci9ix7RZXMWZLwHS3zBa83DHgfrVmvv4ZrjIoj8X0qPXh
         n5Fse11zHceun0Ei3/MfDko/XIqycb2rAWVOjpCXQry7o5DI20l3ZIb7sVwI4/M5rZC2
         t+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071998; x=1773676798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TdgCe2J3lvudY3Ri4RUwnY+/LSuwRgctaurAZvpEmI4=;
        b=iePpJiu2ZOXnA/El3qWPoQfntAjj3IMRF11LKT1jVfZorIFRBuyRu+u6aOQhwvMnED
         n0/cJe/Qxu3f8NYMfiXRcfz5h4KuxqOP4Zb4rmWBnDCL6+Zm1RcqqHTz8b/KDgUL/da9
         Hf8fwXEzbYtzTQP/KNlaxS+RLVxz3wEs2fd+WEN4eA7LIccf73yzTGBoo2c+hJCvEJu9
         1KZZdtTSMGQeCsWZ6oDsebJbRL7ITqIhvoL6xYve8xHtkudBZ7pDe3E93L1+ERtm9FUf
         ZSDsxueu2msPm0aWzmKtR5Ba7rMxvkGZ5MgQZYwmweKleJhUnSVo7FpT+v4jkLwSu7dT
         g3sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAuO93UBLs7gnitSU5yo8HoLtEHvNKuTO/KeeLY4kaK5tzVVhFiqahlNq0NyJL4Fzxem+THG9IxA==@kvack.org
X-Gm-Message-State: AOJu0Yz3SrUJnqin7YmlZz0zI6rVYM0oL5YshaoLz2nDh9aJukNO2iH7
	zuoQbb9LF6mbggyYb210LyfcI4Zh9RqsULbpXcRjJjQulzHsgTiRYrCicJaEnC8aCRI0LB8VsFZ
	gvucGMQ==
X-Gm-Gg: ATEYQzwc9Gj/AUOG4E9BK6D5cZO/klOgdKbcRXcIVp2u2EUD5YIpgoqaS0rqSs1BNva
	HgGWN9S/q7aqU0jA7KlSw8K/Wj2WCtDT/ExE3tim6HczQ0o7sfFm5Q5lBKpC5IGG6Ru1Qk+yc2m
	6V/44XX5v4HNsFYVDAj8+em2mt9vR37U2198cl/axlbWtxd04YMpUL4yvwgdg4rzmdCQ6sZkI9/
	at/TNeFkkGOPltK6cNMPiVD+9zHbsxVy2jfgURH81wx3DvLAokMYCra5AAWyjudjJmLFbDfBvv5
	jNm+QzD8dT5J/HDqLFftffg0v6MZ55zEt2hIAm2hY0SX217Je+TG+f5b0vs6/H6hjKhW2ekdRXp
	wDBMlSXDeC6nid8rg+HF+wI/hmKu3eZFHRXKJDzwFaExDqsf3D0xJXa1CGiyrcebybdn8OeZZrq
	fBFuHJiaHO9B2eSzrP677SFeDS3c6iG7ISHw6ZP7HmO6IH82cUssLhGAk6d3uKMA==
X-Received: by 2002:a17:903:98c:b0:2ae:6432:8f77 with SMTP id d9443c01a7336-2ae8ba59672mr3148705ad.17.1773071997647;
        Mon, 09 Mar 2026 08:59:57 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840ad894sm162231525ad.80.2026.03.09.08.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:59:56 -0700 (PDT)
Date: Mon, 9 Mar 2026 15:59:52 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: make sure preservations do not span multiple
 NUMA nodes
Message-ID: <aa7uXzkRCHuY2jA6@google.com>
References: <20260309123410.382308-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260309123410.382308-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 63A3DC0017
X-Rspamd-Server: rspam08
X-Stat-Signature: dbrek98e3srcdmy7eox8grmzpy37pqk3
X-HE-Tag: 1773071999-255037
X-HE-Meta: U2FsdGVkX18ImfsGg4ULAWqxl4nCuS2WVYFZdpDZk+xrjOkvGCCV/5WDp5i0ezDT0jvYq3MOiAH7K9tFEJMfjczzIOJFdiiQyVyhPxCOBSvmVVaz4bd+rgyd67yqzKuRNuaCUbn+u41pVHTNW+oo2upd9F/j6vtUAQ6FmvjU+0HRpm/KmNKrIifdUTOe6Q2tLm0bqUkb7fZ48r+GxjTCIK/gR1+6h+9ynanPrJhdHecLR6d5RStpFeanmMqgYS3qP9UVNWFXf2YKOSO4cZyo/e/kvxyuETrnbr7/lY2ZRjxXH2iBlZFHO2DYpUEt0zwsLUW6xgIjPuAcASOLsWxWR06iHyNeSym+4DIW0ZD2wpJBAzNyYqaUiUwvZoQEfxU9R4qN5dXu58WXFEAkIVIRMlnR0EHzG/9dU5XnEWJ40zIVLDThZY75KZ3jh2LL4oxmlJ+2JOppW5AkiWVK6pEU4P/oS02K2X6uIOa8/8gpAC4S8XvByGwGG16mfUkD3eju5F3hnFMxSai8vtUZ3zasCDZ7D3npdzSReu6cA7QmzaMzh5uDUF6x+HZVve96WITJRVjDYlV6AoQxIFkrNlcsD+0Ulio4mJQKtshYWv8fCHavvwIZsm6YZ/gMCowp37P2emKv9t/o2goCeerHL5Z4okC5M7Gl/92vs8QYflTNTPdUxshPNs1X5/wcYS27a3/LNg5gp9tu2GcDyyEO+upBmEBxeAHhaMOzmwH9yx264FCsEnhbb6lRIhfD3pd4JImLRX7TF1ZQClcc/F8Mwbo7Cu593R+2KoewWmdQAVCnun8EutCxvS7jV8YtQl1lZWT+u2JObQTTP6uaiVJE/KSBZ6re3Jnlph84mlbPIwNLX7vz+WvVtzzkdqZD4/qFyOUptHwSdG4pra6gkNyzSA61mwxWXfN36ClxX8VPzPU2DvqakK/T2OPz2NhN9kog3GHDGKbqsGFOwfZLNxhAMuW
 TqKaUQPt
 CnlEMhFDZNenDFP9xV9Iw6JNj544uOGsF6FJsAauIkcr7Cnik8EyhTt15+BK+tvqMQmorXggFolH3D7Tne5KGaXC71wEsn03QoOXooD0yR5BUGFdZjTWLja+hvPc8fApwN8Umnvs0MAD+M+9RPVkcD/Q8vPJps3b8U94Y+fS2PDC9c6AG5jl/MB7mcvipBaf2R9U1mINIQpVhwQMCW5t0jndbvhGqyuNEh9nANfexO6ELsqWI/v5Jb1HupHHPGytzSAWf9p5JCj7GiLECGzEmkj9NSG8Rz6uM0MJpd1tYxPHAAFcwt+/Tr33MWdpBtr6GKe0B4GAiqDyzjHPFhymKYhGuBrECgs1P2HY5FM9VUu0LcYh2EVngadapCgqEWw/5gvu0r7d+OmXgggqbS59XE8/x0pIs80f2NaREeVihDzqAhjzgLe1Cv2eMEDTnQusK/PegcMA9NZzJqgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 12:34:06PM +0000, Pratyush Yadav wrote:
>From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
>The KHO restoration machinery is not capable of dealing with
>preservations that span multiple NUMA nodes. kho_preserve_folio()
>guarantees the preservation will only span one NUMA node since folios
>can't span multiple nodes.
>
>This leaves kho_preserve_pages(). While semantically
>kho_preserve_pages() only deals with 0-order pages, so all preservations
>should be single page only, in practice it combines preservations to
>higher orders for efficiency. This can result in a preservation spanning
>multiple nodes. Break up the preservations into a smaller order if that
>happens.
>
>Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>---
>
>Notes:
>    Ref: https://lore.kernel.org/linux-mm/CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com/
>
> kernel/liveupdate/kexec_handover.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
>diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>index cc68a3692905..bc9bd18294ee 100644
>--- a/kernel/liveupdate/kexec_handover.c
>+++ b/kernel/liveupdate/kexec_handover.c
>@@ -869,9 +869,17 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
> 	}
>
> 	while (pfn < end_pfn) {
>-		const unsigned int order =
>+		unsigned int order =
> 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>
>+		/*
>+		 * Make sure all the pages in a single preservation are in the
>+		 * same NUMA node. The restore machinery can not cope with a
>+		 * preservation spanning multiple NUMA nodes.
>+		 */
>+		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
>+			order--;
>+
> 		err = __kho_preserve_order(track, pfn, order);
> 		if (err) {
> 			failed_pfn = pfn;
>-- 
>2.53.0.473.g4a7958ca14-goog
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

