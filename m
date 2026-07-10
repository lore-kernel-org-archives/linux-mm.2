Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE870C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D89A6B00A0; Fri, 10 Jul 2026 06:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615936B00A1; Fri, 10 Jul 2026 06:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490156B00A2; Fri, 10 Jul 2026 06:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1433F6B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:42:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81E6C8DDF2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:44 +0000 (UTC)
X-FDA: 84972528648.25.F2C5D19
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id CE4331C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8tphxIM;
	spf=pass (imf18.hostedemail.com: domain of 3ocxQaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ocxQaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680162;
	b=CSEdPwg0vfStBCBkgEfEC7QG83vc9uQyenuc7e3JEze2APZxC742NxwAknjx+yekPJKSMX
	E5bNLalj6skzq9jOYkwy3gNFGbfadqiI8JiuUNxDgm9iPEEQv+l5eMOf0nABSl/6sZ54b+
	s6sU+yU3T6uxvZL8tWlEW2x2z2v0ic4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8tphxIM;
	spf=pass (imf18.hostedemail.com: domain of 3ocxQaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3ocxQaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIBOMMuJQhrTdV+Tjmcx1KZT+n3b2t8dDXgjQ/32pgM=;
	b=Z8Q0vlLa/c8eCKXURGhLpUxVwZqxVO75vr9MHlkroM3qR48NWUyiUfEpPibDFv0iCVHbdh
	xIirXPjp5QoARt08zVn5Z1yREXQwC41w+Fqxwoj0/lHPNQQrG5lyccujeuNfUv/hi9w912
	DtZ6vAD3rZ3vXRDOeWzmheuHRB6ytl4=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-472bdd6f529so502980f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783680161; x=1784284961; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fIBOMMuJQhrTdV+Tjmcx1KZT+n3b2t8dDXgjQ/32pgM=;
        b=R8tphxIMeA9qzjVync715i3I4NKnZ+yUVA3+0sGSjvrJ2TfkT8+xinnRvb/XaUezKF
         NVyUMGpbKe6SVjaZYhCERcQzWPbZu6+QTJX0nRGDl1VRPrZxbmhNTbGHJnNvJBiRsvR4
         WBllqj0cC/s+eCaPvTzNW8CVG1Gm8HUozQiOkSzgq3gjH5MEIn5g+2KnHyyk0+VQHRFX
         CS1uGLucNCpW/+hT7iO55TMTNcSMvo4pyiWOZimun1k5J5lltik3SoZusSkOHzILERHF
         bMRtJHeRXGKRbD4YBVU4lu06F65im8CdOw0Qdn3vKGELsbDOHpzNj4VYF/0ooFBZKyQL
         SYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783680161; x=1784284961;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fIBOMMuJQhrTdV+Tjmcx1KZT+n3b2t8dDXgjQ/32pgM=;
        b=cbXzw0Gz1gxUyFDTeEzIabM9UPPrCBgb60+iiAhvPBErzUDJyh+jLX7gsvnrs4u1Zz
         b14YckZOXPMtrdYy19qcACP5oVrewkp0GTBU3bl1/D/o2uZTU4zkA6ZNuKgT2/mnivRR
         RK9W8zIedK3TTtV1W1QWNZs1MIPM/ZKwNilhjYHtlIk6325CTlQ2w5Hx1Ss0czPvBY04
         Qq9WoKljcOMWC1vODf64eiVKUdeao6vuW6XE3lizGAUW38elJQ+zv9vXvhWJcb1gRVJz
         PhLiEPNld+RXu0sFyC/bAZvAktxkApAE4qIRaz1JciY9s9dyUSn5txJcY+v2SIXc59j6
         7lWA==
X-Gm-Message-State: AOJu0YywM/Y1QiTAA/1DJT56TiH2wMIHNjDbIsue0UK/Ks3kdcCnlv9G
	GfbPjwrFkPCbNxcZiq+bz5AQNgKPxse3af9/A/nj32HDgmn3RIdt60IynZ5J5ssPe7oZdR/Ev6Z
	Vfj/R90HTt8HlLg==
X-Received: from wmlz4.prod.google.com ([2002:a05:600c:2204:b0:492:1eeb:6111])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:528e:b0:492:4363:e7eb with SMTP id 5b1f17b1804b1-493e68f03damr112833265e9.32.1783680161137;
 Fri, 10 Jul 2026 03:42:41 -0700 (PDT)
Date: Fri, 10 Jul 2026 10:42:20 +0000
In-Reply-To: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
Mime-Version: 1.0
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
Subject: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	sashiko-bot@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE4331C0004
X-Stat-Signature: zebjfuqcua63mje9bma3kzj9stut6qem
X-HE-Tag: 1783680162-671990
X-HE-Meta: U2FsdGVkX1/eNh3Yo/Irj5xfAkFfcMsS+9XKYfnJuIXCaYoAM8V+tODqgALwA6rgWfLSemYm6iGS5X7fq4dSc0YO0FOcINzEU/MdrxUaBSq4nAGgNhlMc6n0MxvxTeibD2S2B5mVTRl//6k7yJTgTmjme/23umbdRTpkim+GR2kHJwtvxJdnA83R7WPYeq5pJsgM044r65+yTtvLVXeUptlUjFvEEGB2w2AtUxFzZrEchuBof7vmrXEB2DD/IeIOZdeg1UxamgNkbko9FrD5vlrQfQ/KlMgAoB4mf9X0DilTsDb3y279ltgNSJ4itYSCJ1xAeBL0++x98w8bKzrbSGlDJL/Z10LBUeViTrMbvOhPZevWyg6dwVJj2hk7YwULWPENoS23sURL0Zv31kMoh4Li2UFay9T/tm4z1+/TIK2lRM2zonsVO42BsqGKGimOUoRzITTjHba0dJhmCcFSZQoIMsNbnUR2EpB3TF6qyufkoSPtnX9OUsBldMcRdjLSoDaEtMt+0HntBp/lLBmB4ea6lSN5GUswiQ90MYstii/QMCmEroA3X/8x12BrEX+gp30ezKMbhelLcL0WC8x3SOBbbSNemYietMPIWFe7vSq4vPELNC21tdiZVD919eBdnqw0ntKOKYNInwvtddQhaix+sCskN41cWbgKmA1VvbFhDEoB0dzj6XQm78Va+74YBJzeY3hhntAhDl97VA+QAp9xzjYvdjcaaUlSBhbT2HuBfQ7U5zeuV2/XLbi8YHBqR6SCfIulhL2FWvsivw5pkocGkNNsGo6H8z/UGrgMbamz6ohArPiH5mdJ2rLPAdmBDlL3UvJoa9bJ91k6WJgOmNdLNCr4NXdQ3pvMY4UBzNQqIWQuPkV2TDvojLHSE/c9TMUfQV6hrmbGKld/aYsRCGADEGy67fa+pCEQ2T9Qr9+WhquZ7QyfNo4KImUrq+ONA6RmRCzk29/8Bzm2G+c
 NLBzW/KS
 lxYZ8OcigG0fjebXidzcrfY6Y0XmJ48/XtaStgw9bHQnZRW6oHdHEXuPxnjGQBAXlWi1MzFEGoL6D8m4NFtRSbmYLCI/xHrV7OUl5OcAFUWQQv01V1BlRSYoMKirX12Dv+9du6hoz7+3ve9jO55wv5Sv16K0VVq2oRXX36szcPbx9DF+Bnk/bOZNeixD6MxR7NhPsE6ErPFG3U9GXCcD0Okhe/7T6+oa0PoY/oAMc+vIBc0LemizHViTcTs70NAQ55M9hLRv657eLlUQt6ECtNBxesYp+lPnqkAS/6VcUXkWITGGILWQe3DlRkoKJU9NSIwlLQU2cNhFiXCaW6aOX4u3pvnzHNW90knuv/0YJhXX/Y36E3rwWL3/dN4BajHgaet1HfPeHBJ1ddOLSHKMR+Mup37yZG1T7hWsvBup2NnU0pqWhcGM/ViLrl5+BQhTB9d7pTO5X+hgp9PYYfO6/+rdL6b5IdaSyDAlCPPfkAsAgY94myaR0rD5g/9e1qx4wYGy8HKdY50Rz5rdfipVfqBWCPZuoMncI/OJIGvtQ3ZCdShtf+HAjnFeG7M1MovsSdsLigS88b/iRG6dVecKKQuFLly3mLcN2baV9I20vdRbgooXS2GpbNRn05ZDVvKpahWuYCmEpxbxYWIXieRIvnx48kRMfzNJad4A42s3unGnUXJhP2Ms1gl296NQfMOIrVIjBoArzVyM4TBmyLjX5sQ79tJBzr6kJ5yzy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As noted in can_spin_trylock(), using this is unsafe in this context.
commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side
but missed the free side.

Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com
Cc: stable@vger.kernel.org
Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c97a86da2b9f..5fe1c11f919d7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
-		     && (in_nmi() || in_hardirq()))) {
+	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}

-- 
2.54.0


