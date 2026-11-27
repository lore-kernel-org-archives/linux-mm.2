Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A89606A32F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtlNuFsS
Received: by kanga.kvack.org (Postfix)
	id 1D9D66B05B2; Fri, 27 Nov 2026 15:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113076B05B3; Fri, 27 Nov 2026 15:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20D26B05B4; Fri, 27 Nov 2026 15:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3FDD6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:12:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04E01C04D5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:42 +0000 (UTC)
X-FDA: 85481997006.10.DADB9D7
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf18.hostedemail.com (Postfix) with ESMTP id 060361C000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795810361;
	b=0W7YqkjQMbonRUNovplrXdv8XqCa0jzIKLyxT60nDben7Q57FBp6GRDsYhT3ATYJLo0qvg
	NSVpcvz+/ln03jSLTjtypLUHLNAu+uTkb3Zg0hFaZjLXDqxva54MRWFl7KMBVXF+k2BhJR
	FH4aDUbv68k7TM6OIs0Xyw9xDRxWyiI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxAv8m4xlT0NV0P+L6VwGoxOklVbBhq/IGLIKJdDPJ0=;
	b=ZyZQ9LIt71rhQbIRuGJ3ksNkEblSDJz8L94noRpNuYxKq+2hMWFTXCgiwQsUa3NoH71MMu
	rDOojfj4tvQg3Al7eHiLEhizIpTrCCwHNyy5NRJdoM5VofRVh082pybgKBW0ECRHSRADSp
	24J086WjQPXUGRMxkzl+u+xAqDZb6YM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 908211C3C43
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:40 +0000 (UTC)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63D8D1C3BED
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:40 +0000 (UTC)
X-FDA: 85481996880.07.B9D75BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFCD840002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810358;
	b=oetmiM8Wh0Nk4IrH+Uq3vztm7/4Ec7bL/RVCRQ//LpX2lvcrMC2BYM9EHtCeKQQJRlttk7
	7eAKaoJlC0ccaKThMOflj+0IAG3FOnSdq3n/+2H/rqOERktTBZGM7Fv5qRj3NZXmYZ3ymv
	CnW1gfhdBdkBRhYJ4dtPvTuiOIfJ+wg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxAv8m4xlT0NV0P+L6VwGoxOklVbBhq/IGLIKJdDPJ0=;
	b=d4TRBQjW9V1FUW5t4SGG2UWDuX+Rt/7lcbamkcpJlHaxglY7NPJAkuD2a3Sl7519KGNnIY
	kMSdvX2UAmhg74acgf2R4vHIsqDeScMJZzo5F6a2HF76VCTK4i+pEOfDahltRP9KZz94Uh
	QrpsjKVvSN+JDqYINRpRPrrQ9xlQP3s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtlNuFsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E37461DA3;
	Fri, 27 Nov 2026 20:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5BB1F00919;
	Fri, 27 Nov 2026 20:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810358;
	bh=yxAv8m4xlT0NV0P+L6VwGoxOklVbBhq/IGLIKJdDPJ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AtlNuFsS+61hcU8iYFLe5x5yo8BAekU0rhq6ges+SlGqz6I7AxpETp93XrLMwwpRM
	 xre/dOMdGTHaX8/2Hb+3vt2KaO3XGnHeRzYmBDggVMNLYNtsgXt9t9tLdahJyTByFp
	 dfN6wUWhUBw2Zlz6XeHN/LYYAGAAqBDFI/bjhsNw9shM0jVBtK3ivRNzT/YwCBxAYf
	 NUsy5g6AEuknhjAiobzKLIV8ZducAdjsw+v6iufQMYmekSVqY3826Y/W2c527TerO3
	 /uFrlGyalDVMtA/9NdiHtIc2NrBnX7svVGGL8AB455mC1YsFBoXE9lHfqcgh5GPPwA
	 szKUatzk0EYiQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 27 Nov 2026 21:12:30 +0100
Subject: [PATCH 1/4] mm/slab: drop __GFP_NOFAIL when refilling sheaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-slab-ai-fixes-v1-1-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-HE-Meta: U2FsdGVkX19oFaikatgMl7xeIADC/CEtRPB0SxnvU0kOWyLsS4XB/fnXDaSq3qB9m2bSh5QIpS5+v+Qq4/1E0DpKne/nuBmigLzbkG+0z8vVNKaqrTrVppspXV0LXsBG2gYI9QkxQ2SkNYidRL+eYSxX5U2gJUm/3gTkCznGgNSwrcOg/ybYUNGMlp8spg1O3lUcWwREX+UEODU2qF28LemqL8PJWCj8xWvZZV/onvyHnRPjtiIQyfWovqqk788euQQEnbqvW0QKG0V7UibqNO1qb7U4M+EXZNXG6MTfQTWXAq+Fkb+A3NXdNK93B/nsP9eTJpx9oYibuO+hPlw/lH95/BmdeAfBoVjJiA3y/6LNysWvnSyddQMHqCZKlIAHYl95VfywQmho01OF1OEO65m3YsI/kEGpzYPdvZEFTXmNdt5WU5pbWeOeB/3zsWAIYJAlHSOyRvcVofgWvhHo+sZGAjV+XLqVtviGF7kRj6o6zoAYjl3HjrWzo/82nukvbueyEr6QRbBmKM65VEds7zkfEhfZIslkkfcZM6lYty/abRF7qb5i29OI8xPTKqJ8kUO71RfRLbr/Gw7YOoCY4fUlG0ilgQctmdIljsqQhsr4Q+45YJc5VJsHQTcj1XciyGsOGFpt8BJ5m2U8d8HveSQe8DtEbFkKfEsf8sIw4PAwSGvKAfbwYE8ImhI6U+1MidQ2d6ET3YpPAJjwbAeZyc/hkrDL6Eb+uMAiuoXIyes+Q9JWtCFA5U1tH17NIIiqH8lWiOkm4iSuSBJL3QfQTz2xmWZP4/bWUtf4wEvbfOxWlubIY7mEWzu6hinVTZlDV19YBflFhRlzwuJ8o7NSjyRnEI4EP0tt8NoT/ksprApD2sJWhGKUG8snirvg2h8WuOGzVwkWFnZJyrEFpmsgaWAQ/PaAl5cmXgbwmja6M/QGsBswApo+lM5hbl3tiEJpWcnQNyn9K2Z7+oNhfX8
 CSURSMHE
 ALI7MQ7q5p+urBsq+V6y21mtT9fyeZfN/Y1GcZYdgHUFOXKpoDSNdPGdCgeOZ35f+lwrA3V1KpH2gAukZxAfRuNYTXahayE/mnzCTLGAdtb4jltBGuR1F2rA6QhfsBaKBhwJOTTeCV4KKLWPYJR1KsDlFLW9Ys4KbbvD5sdzM8gJcb1KsfTnHdk2+kmysbqzfZqR9WDrfRtK/+OSx2hKdjS5Fn9vtw3hLcsz1TsQJgxy/RW559RQ/fMkwv3haP9DNvUFMWO8RAmjnYhOHiurkFfL8PHbxPpmVdMTdiXrYTiMFXMMfeiRI0/itM7cLIH4FnRg0sUqrBlbt9DH5KAhN6lOyTtj9hJsvpPVQbiRQkRW6oE/6pap0HTZMQKwafaBSh+7jy0r+kzajrohvyKATHS/THPkTXJQATMyiDEc3DJlb+CyynVKA6SyVnhFbkVM5hY7+gUSzVWn23HahRsb7BEhmRu5Hwk5WSgdUBPkbtqiLqdJTijCQZ5LaoYIyahlAA47GaIoOHM1Q0yI=
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 060361C000A
X-Rspam-User:
X-Stat-Signature: 7aoq3mgtzb9onen4etawfeq5aez5m4kb
X-HE-Tag-Orig: 1795810358-499402
X-HE-Tag: 1795810360-748433
X-HE-Meta: U2FsdGVkX1/w31C0R6yYHq62VyOSoqk6cysQB+tusDvElMQphhHKuVTQWr+zkz9+C410nbKamOZuqJCGNhkFdXv05lAZku4sxKS7L1Aq7o0U2kC85Tr2T0cYOVL1UVrLCr3mZD1fLRY0YWeQj8attMSSLH5clEHup4McEp9oM2GVbjnmvJon3SxWH7kj8BkGwPqdbCf2dc+HWVU6egiN7g3fFhav01ep95UMYDIW2LgiRk7H3Qmcbo1UtFd22vVlos6+1hMtqpqB1Q2Wg3XI3fLEOGwbQ6VNx8uQt/RAQqK7sEGt8/8fI23/L5U/Mnxxc+ufunv/44zTA5Brzu4ln1e6nSNP4/TiATrZ1Wnvbbh9Cxy3vFYiKAiT2KTfK5Kz1Tx6FRlTCWrWW2mTqWlwcTTNEQhg8vPRZe50NmHj4quSFCsksmaTrPdsJA1L7dtAS4fYmWAUhL0Njw4cuuHo4KzTmcPtHSUrpZ2gDoHp5PODNu4FeFvple6izVWPMi+kkC+JzhIzzWluOe6DrWnn02b8coDTDNBy5j6FqEiQj7tl0AlXW0kBa13XxRmzzqJ5uqqfiuLj2INjS/fwRp6mm5KJeNN1eUTdjCpRFH7Be/rLZXBTtAAQE8N5dujFdqixHyIoqVcbDHppNeouNmh++nJRp7441y4q6k1NqNmz10nuq2YQZ088WIDwnQsg694wVR8O9109m3tnKVh5oAlFCLf4/gSz6iHZzFHBggfJQGQZktJ63/JKPjuIYDnsJ/pQnf7dBOrTe+rGkoMlcr5z0FxU+zpiXyNw/eCBRcv9vHRIJdMJL64HDOsRVEdpJj/Ef/uXNQM3/hYOS3MP1P3CAsjphejnWe0T5gl6vLeZwk3W+4m+Z3sjW+c7F8iBTFcMMtJ7AStbUe7ix6EIOc52mGuWq+9u9tcA/tOz6uxb6gl7KQfTQouTzcxr+/YF5vtBjpmYMdIFFNAS0wg/yKa
 Cs7w3P4A
 gm+IVs1TEsAuZyWnu3hSmRUCkAK1WCYdnn2TXjnyYSINFkgOhGKLVpJG5T6QF0b50dE8lpmtbIbevh+zw5v7HEzPo9DQfIUFVQy5a2X6aba8/ghkCelnTJ+ze5N2pEXRF3OPMXHAtm6wIWjCFbqdHCwgxHFr8ibj8nTSPw73O7HAdLj9qZHBjGScawRcJ/NTblFLjosdAOc5rWKyDLw0mIXYnH55DBguGoCe2o9aZDH8ASQV4k3Tu8kgDiN2tTZ3tQ+nAAOMIU0CI7gbJ00ukRmUcAm8lORaJx0qh/KfxtJNmgt2676tc+ZERV6GeB737NqZVeHUTm0fMzlmOjpPIYCQvW+kXCNJdpeG8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A __GFP_NOFAIL slab allocation in a low memory situation may end up
refilling a whole sheaf from slabs (possibly newly allocated), passing
the __GFP_NOFAIL to all underlying allocations. This can make the low
memory condition worse and it's unnecessary, given there's a fallback.

Given how we use __GFP_MEMALLOC for the refill, there are also some
undesirable corner cases, as reported by Chris Mason. If the allocation
happens in a PF_MEMALLOC task (which it should not in the first place,
but there's no guarantee), the following can occur:

    refill_sheaf(gfp | __GFP_NOMEMALLOC)
      __alloc_pages_slowpath()
	WARN_ON_ONCE(nofail && PF_MEMALLOC)
        retry:
        reserve_flags = 0           /* __GFP_NOMEMALLOC */
        goto nopage                 /* PF_MEMALLOC */
        goto retry                  /* __GFP_NOFAIL */

The allocation will loop without reclaim and no access to memory
reserves.

Additionally the slab page may be marked pfmemalloc, which the sheaf
refill does not expect and handle:

    refill_objects()              __GFP_NOFAIL | __GFP_NOMEMALLOC
      new_slab()
        __alloc_pages_may_oom()
          if (gfp_mask & __GFP_NOFAIL)
            ALLOC_NO_WATERMARKS   the slab is then pfmemalloc
      alloc_from_new_slab()       its objects go into the sheaf

Improve or prevent all of the above by dropping __GFP_NOFAIL for the
sheaf refill. Also perform all adjustments before potentially calling
alloc_empty_sheaf(). While that one already clears __GFP_NOFAIL, it
should also get the __GFP_NOMEMALLOC | __GFP_NOWARN flags, since a
fallback exists.

One consequence is that the WARN_ON_ONCE(nofail && PF_MEMALLOC) in the
page allocator will now only be reachable from the fallback and thus in
case such a caller is introduced, might lurk undetected for a while. If
people think it's an issue, we can duplicate the warning here as well.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 145a32c334cb..5fd148f11efd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4807,13 +4807,20 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!allow_spin)
 		return NULL;
 
+	/*
+	 * We don't want refills to rely on __GFP_NOFAIL or memalloc reserves to
+	 * succeed, nor to warn on failure. Leave that to the fallback.
+	 */
+	gfp &= ~__GFP_NOFAIL;
+	gfp |= __GFP_NOMEMALLOC | __GFP_NOWARN;
+
 	if (!empty) {
 		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 		if (!empty)
 			return NULL;
 	}
 
-	if (refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	if (refill_sheaf(s, empty, gfp)) {
 		/*
 		 * we must be very low on memory so don't bother
 		 * with the barn

-- 
2.56.1



