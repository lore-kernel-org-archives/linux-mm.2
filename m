Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96657606A338
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=b/lVbaU/
Received: by kanga.kvack.org (Postfix)
	id E534D6B05BA; Sun, 22 Nov 2026 13:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03A76B05BB; Sun, 22 Nov 2026 13:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5536B05BC; Sun, 22 Nov 2026 13:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED7D6B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1199212071B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:09 +0000 (UTC)
X-FDA: 85463632338.21.114C19A
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F42D40005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="b/lVbaU/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3MTgDawoKCA4x7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3MTgDawoKCA4x7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373107;
	b=1NkLOvLGhaudiRneMpul8VbIE3bwkFdT4bUMNoFXAB9SCr0AaafkRpPmKv1fschP6hw1Mg
	vlWFIznkbA2McRJ2XXd6EVvoOUktvXhb/x8yDnx7ZIpRWsRG9RNLc9I0gO8WpVr9d9Syn+
	O1l/lFYfpTZgAUSJy3T8FqONSltPn7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXQPSKJVaqWfQL317csB6FAtCBOwMGNwoZ92NFySUdo=;
	b=4U/sGXM0wjBnb/vpEgpVtM4cYNsBIINZKc+bhYylZadyaPfw6YNMQy/SLZJun+5fkFSBnm
	ANzIsQBfMpmu+sMGTnD70S/YFyDzdoTPvu3GLEOw1aBaBwn8J5pQwYfBOfoMFrqXgxBN9b
	yhlOvkMqlcrzvP9wuzjJqoToG/Ew3NM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="b/lVbaU/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3MTgDawoKCA4x7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3MTgDawoKCA4x7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdb8e8bccdeso1213639a12.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373106; x=1795977906; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXQPSKJVaqWfQL317csB6FAtCBOwMGNwoZ92NFySUdo=;
        b=b/lVbaU/pYBAoyguwsOb7UmObvQbNndNFF0B3G5PviGZTN1+fo8xoF2WMQE0FPLEAa
         KXL7eLJokb/VhVXOg7wC4H20qVmCno5F+F9r1lNEVXZRT3WL/2V258DEU+umqx2JiQIq
         /Hl8GQ6DEKoobnujhMP/9enbBk/Irbhsh5k89pUXmXAt63Iot7rfWFxtkxrhQez75Kxh
         p6iyQRbS0GlNyY3Y5ywwL0R1tebCoObewIFeTTes7m83httsMd3qYIuc0dRbX2r6imxB
         XRJpvqkXraL+qgyEkFntIN4EnreU6oaJnPRMHI2FhGqOBd3ClKes1L0OpvREFGiKsXxz
         aUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373106; x=1795977906;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bXQPSKJVaqWfQL317csB6FAtCBOwMGNwoZ92NFySUdo=;
        b=nBDlIujph16TQBiwsZ5GgMXWARTiNd/Fxw1GwkEAXNaot5YgsvTYK9VXAO1//axWAi
         iHK0Nh895HTFtUigJNFiQxPYaDtI3pn9CAmh7bRlukJGX5e1IfNtfjFiA9ZDFhLTzAkt
         5QKlMH/SWkSBuu29CpCBTQQiRVrGojzF7ycvIfCGJ09eHfRu12fSH84R3GkRLnYmmoZ0
         lWN4rPhTonYUyNm6eOJnujTejvYLBsGRIzxRvucHRbnOfpId0rbxZQpGnmMh1tmKJKUD
         +SVPwjJGxV0xEA5BWdHA+MZXGL10QNxh3Utk0d/6yePCPWYWbv2ZBZhzVmg6iULZFtGW
         +3eA==
X-Forwarded-Encrypted: i=1; AL+hErE2hE8Q/gG2cZCdx7N3tItrttjKh68zZ6igNtz1uZY7PLfEv+hoCjvegyZIaZwmoOyVLIgtjRidIw==@kvack.org
X-Gm-Message-State: APuU4Z+mBe9sU2lVD1WvyaxnxeLK0COdYKPRqzdTLSiZ91RTSe2u9dPi
	3LjLpdBkzuMwc6sJdd9geIidLCUWRsLTKa08/NGbdAwJf2Sl5YIcZkC9/oA0K82weSvNPPBjPiW
	1lxgVv917Fzy6OI3FKrILLA==
X-Received: from pgjg24-n1.prod.google.com ([2002:a05:6a02:8158:10b0:cd8:b29d:d82a])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4eb2:b0:3e8:b7fd:6280 with SMTP id adf61e73a8af0-4014d85fbbbmr9915990637.27.1795373105686;
 Sun, 22 Nov 2026 10:45:05 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:40 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-7-jthoughton@google.com>
Subject: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not pre-HVOed
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F42D40005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: couge7em1wi43bgk5rrh8n6uj1wk4mi6
X-Rspam-User:
X-HE-Tag: 1795373107-70098
X-HE-Meta: U2FsdGVkX19X4s/4UDH/BPW0+rS/4rQJgqNb5oLLTgUI/98lZk6+OMShlcbd/F9R6CLW5aPnlI+3YmUmgrp//Qg5HXduHEwwFT29VdUnYUKmVfhH9X6wp15bPp+E4FqCQiGVM8h0TnKf0Sv54EGNJuqKHoqZTVHKn+S9o9fDj7EJuGORFx7rSJSOTSmnRhDr7XKkLdNk5qPYrcHyWI96UCVsfMkjr7+t25HRXGdjmHjdixaMVGse5fZAWEALTU5zMtxCY5MDZUY4MvUvjyeEUS4/XgmS2u51NTMzjcC7CVbytkGNS0c8Cym/gMUWb/W2/7H+0gnFSBOfNl35OOLmzHQBgV1pFPfhhgPRgd/vHsBBCXr4tz5jzxYg3tuM5GXoIkJKW9L4Jcq9ThCRdWjvoOUCIXWAi9NB1ZjCGQOa3hKPaN3xHOR0aRr9RnCvORIIzR6hnisDRlzFDV3q1vPEOiHftHcJeCq6t5aIs0/XfUBqUyVmJIyFj1aoTHaX3Xgq3+HKP0inOJVofjGIjzdmdX7qwJWEB9B9DNfjQNDLlDitRuOLIyBWAjKhJyIwGx3OqAh4pUw8XLGmqynnLWytdSTp/njy7c4a0Z4ZFurY5KxQ4xapVr3JoCTvmGubQr90L1b/cRANyytDkRMOO4zPh1Fobi+Ns0OpECouoQ6HvTxxb4Yjyu1ObTcyDLdypVs3P5H5V8BliKbwbzhM4grSPKbZ5doICs8F1E9WQmXYrtB/qRjz3Og6IWBCcZfC2/cmeh6OEVXZ19fynoIbZ2zlniI5oXv4u+YzuNH6/z2g2NyfTpHSie0s0rhgS2Dzl6yZCt/p5XrwOy6RuG10zBfSmV9yEaOM0AFwmSsNk102b1y55yTPRYnVaoz92ynZrIsjmhsyh4UaBkejfId7QrPcYIoDVs/9ViBj81KFnQm2c89dI4WkkUF4LG09/WGVCrlMRDKxNz8jeB7KGxiIZU8
 4V+Vbrdf
 xnJEV8322BcJmYhKeuXMXZas6zKuCcjdK0WbPa+CyC1gZk+/XEfHcr1AjNOY3bjVZ2pLovObaOqu+pCUpTWjFsdN0NKlhWUacTqoxuKR1QNdhKsIpY4NhIGvfEC4F990LPriEjkQkVNUuPSkvTkqGUwNOoiZ2z+Df8d6H5y0wXSwrae734X6RGLkS0zICSfG6DzcRy/xNaBbTmbsGzr2cpYhwcrtfeLlX91vNGT+ftoYhjr5OXD0f1/pwtwTrd/pB1EIQBTqrlGlzCUmNwjfhAnPG/6DvX0JbJ3aexUO5LMroLyhUhgoAeMNOUHLEmuI614AwGJ6oZmHJ7DcKXVLqnMv2mVpq/cu3n5BD/Ro5hADqG26r9mlGjIA1i44OMbKAdzLL58s1VoaeS00IFqTnLAo8OlicvbdHDzmRSZLiGhDW9KgCnoIL+Yjykdkute+mGS51o68EcEm40JhCQr1MejD/bS8WWsWIYt1yeWXGps2/xnqCBANTOaMtoNT2aMqUDbwVDQxgc8Tkgm8OaK+shckM8r9gG3Yi17c2h4mo27rVRqzh1MIjWa2on1+glpAZ7G54xQdsbvMVFjR1FIcd8ZaDKuO/7BFcXjZud6PG5RQtpQcOSYUYYQqjQZltLTB6I8YjLnyMy+aBBYu+8XDuH88DYzzQCtREM5sBtmqOm4OcdymH/ai71N9dLP/hMOZfaj7qHlQj0j9dLvz2WSI8wuOom/f49ZtDW1Msvm75mTIuZ1YGvco2QjxvORiSKmjVT7OSQ9IuFyeTny2hGkaZBBkUlX14vTn/oTpiFtst9D8EsiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic folios are expected to be pre-HVOed through the
section-based vmemmap optimization, so the bulk optimization pass for
bootmem folios was dropped.

However, arch_support_vmemmap_remap() may not yet
return true when bootmem folios are allocated (e.g. on arm64, where
support depends on a system-wide CPU capability), while it does return
true by the time the bootmem folios are gathered. Such architectures
disable the section-based vmemmap optimization in their vmemmap
population path (see section_vmemmap_optimization_disable()), so the
folios are not pre-HVOed and would never be optimized.

Optimize such folios when gathering bootmem folios. Their tail struct
pages have all been initialized by memmap_init_compound_page(),
as they were not pre-HVOed. Pre-HVOed folios are skipped by
vmemmap_should_optimize_folio().

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 72839e98f998..8756c0206922 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3325,6 +3325,17 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
 
+	/*
+	 * Bootmem folios are normally pre-HVOed through the section-based
+	 * vmemmap optimization. However, an architecture that can only
+	 * determine whether it supports HVO after bootmem allocation disables
+	 * the section-based optimization (see
+	 * section_vmemmap_optimization_disable()), in which case the folios
+	 * were not pre-HVOed and must be optimized now. Pre-HVOed folios are
+	 * skipped.
+	 */
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
+
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-- 
2.56.1.809.ga0b61035b5-goog


