Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673C8C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C2D6B0096; Mon, 31 Aug 2026 05:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9126B0098; Mon, 31 Aug 2026 05:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572896B0099; Mon, 31 Aug 2026 05:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 216626B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:15:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C439160429
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:15:27 +0000 (UTC)
X-FDA: 85161006294.17.F80296C
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7A578140006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:15:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I klFHn+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iGxsEpi3;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcSC8O/moZEOV/IBCrJoRWIk1sJaW3eAtyBK3gzLgK0=;
	b=pDNx18GxxEhMPZbcdJEpUYq9i7+evfOrjuQEcs7nQz2oNoVpi03K6k+jkyf8zufLZC8+nx
	CEh/L0lDNBCNCyTJi3hsyzaF2TwrUngvFesfwjXbDjYUApOgFrdDXJcx8SIFIJH9ItaSQg
	zFboF9iO1SARG5ChgOU3E+quXxl2CkU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I klFHn+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iGxsEpi3;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167725;
	b=1VYah9yf27LUtnx3KqJ1hxccJ+PIClLYN2SzC/VMCdBWSwn0aP2CgSGONS/aMctTXBvEIY
	gvmwsNcQYYexxEC5rxyZxn/09cmUIWdkBKaHs5ISe5rpsP2M0SoXUkZiaM4LcfkHVaMQoB
	mUp12cqqRUUCXLwcbtT7w2qkvQklLl0=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5FB6D7A0189;
	Mon, 31 Aug 2026 05:15:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 31 Aug 2026 05:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788167724; x=
	1788254124; bh=xcSC8O/moZEOV/IBCrJoRWIk1sJaW3eAtyBK3gzLgK0=; b=I
	klFHn+qzP9FHWc7JQo3QEQAyPiSY44gm1yWfzhUDZMBHtgOKGYOkEjcEMLwdy1zM
	MJPTgtWj6wv8bOBpTKfurvXeISDwJmuMC51lU+LN8u66nBebsNmL6juzG80nOwEd
	iSNxErqgrVC+t6cgO9Uorbwzx6j3LKm//JezTRYiNdYN60KFWJwVFQxVCEaYWdAs
	8fykZwHbvC0flc+1CeRhIxtrTmHQvc2iFs6wEkECouJp0whiWnEKanR3i9FOyr+O
	APeT8hv/Qyxgy1BSd0L/Bi/CVXbHeQD9xKusvS0JQ8QBmX4+PzANC1t8H42ojbhR
	th9bgFPIaGjSlE+8+Dtqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1788167724; x=1788254124; bh=x
	cSC8O/moZEOV/IBCrJoRWIk1sJaW3eAtyBK3gzLgK0=; b=iGxsEpi3+41OBnJA2
	46R9jTDsc22wWqIw2EKSXpz0hQSQYaQBAe4r30/UoTELMmR6f23nfEqikjPzZJ1j
	fyC3RzswypepySRSySFIRjdWiQGY3rf1IfHw0nZx/GveNTIrflAFmx0wHiOFYwNa
	MSoEzr+Ak0CNr4gD8GCfqojmNEnl97QPUZ98+1dWfi4NTBgVSq8pzSBGW+a7K7sZ
	yzJokIXD/j2I5MJ+FkLWyT6QecUzJrm1QKkinFUfpoC7ADsIil3wRF0i1foBeRR/
	NaYEPEWQCyPOfgHLX3J9eVxNtc8GMxs6xTuwTuoBrGz1EFyiQfZAA63Hl+hDS5Y2
	oly0w==
X-ME-Sender: <xms:LEaVaqN26qlQ4EyuPVoTSkrC5E24nAFdIOEc0axQs-w5V4f8qWUWxg>
    <xme:LEaVaqWMyRk2aIekO2_hAxXSkzwmDs7USWCNvFvitowFPQ4IQ2JPp7v5vaPbeC4x0
    TQxIwhEd5Nuv6mk9V0D3BhuWHKWxWFIjFsDYNdnx6z1rG95n7-b6PY>
X-ME-Received: <xmr:LEaVaqjf_2jbuS9R9kaNm4H1lBgzKU-LfMPo7EdabowocjUMwkZN3kSoRDI>
X-ME-Proxy-Cause: dmFkZTElGHzZXOzRI/9NIbzc7ym+V5oK/V4P2VoNYRqs6Th5b5h+DvBAIIu3zH8q+lN0yo
    H2vQeS8d6rToUzcLNvWew1vKGaeUzV3a7p18Bx8L+Qohr9uBRowisapZPSCSDRtM3GtC8y
    ZURjdwZEwJ4LMOrmpWhh9wc4BPdajb8dN6I6jNll2FaMe/Z86AFT0cI/vtl0wpOFAg1sMt
    cFGj8IrKy0Z4YDXozBQ2tFLLe2dJN9TawYFZ/1czPfloihuYjUN+3xx3pd2P3MuECG86WL
    H+VzqRhMeUhxhH5iwF+MmguGBplxiKYHHIj7ZdHv36TDJbcwz7IjOJY93tBQ+iYR9aH1ST
    Gu6+nWmQ7pyfMuDz5SfoO60zxnM+KfVrHMmw/KRBAFQeBg6hsogdSQwsZXSpLjiQMCivIL
    b6oqYAuxtIc71IMhHeW32zVEo6n+0k/QlQ2JTnsH/tpw2xt4XtIw/d+BiBxLclaXg7INJi
    7udjy7RF0u+KQnOGYZS3uWvDf5HAnYbrwxIb80GxfagvECMy44eX9VD0W5oAI1soR/QXXy
    wCdjGjYhvjySPSrBu3hItElv18Wh17GeoTFdMSSxvucuyqPptz4tZDU9W+KoBwRUyoIW0F
    T/XscHVlmjhxwnv4JNuKfAf4GLT2rb5J1x5SfPiJmJmS2lKVoBhDdJnFZs4w
X-ME-Proxy: <xmx:LEaVai_huXoAhYJ_A58Ae4LsihOPTzeYDIM2P9qkfukJa_5xPCTDuA>
    <xmx:LEaVapQkb7BwG3hPYCzcpu5ce9UjcM8ZD3k688ok4gkfzkD_-qLQXw>
    <xmx:LEaVapvogh-YfBRYbm9v39eFtNHooLSAo6bhBr6tKGNzquio4RarGg>
    <xmx:LEaVaj6ei5LWKTB5v6MVx_JOFDJjtYDTnQyqQ1sCf11atPlUlN2ehw>
    <xmx:LEaVapRgpkXYYMpM3PCXRoewS3aREWiT2FZ4MjMk0Od1Y0HITg7tP3OV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 05:15:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	kasong@tencent.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Mon, 31 Aug 2026 10:15:13 +0100
Message-ID: <20260831091514.1879786-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831091514.1879786-1-kirill@shutemov.name>
References: <20260831091514.1879786-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: enew9osxrn6mfwpcihgp5c1en77tm4zw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A578140006
X-Rspam-User: 
X-HE-Tag: 1788167725-494789
X-HE-Meta: U2FsdGVkX1+MY/eqLq169ae5tOTAt0O4RVekL+DLECeGDln9/sZj6kaYfVRar6PQZi+lTV8XLfDRrOgmSpYALea5bKBYhHD9l54sjoX0PuSJATzaonXopgoYDlle2/LegWRUUnUBCB5TyS4ojXMDkN5B3NT2LqV62q8+impxAHp7QDNIIPKt2ngSD8YwDe8OFuY3VT1c4SINTSgMLDaeYmZ6wRQD5U8NRWg7peBKmv2l6aG/LK1zUxCf72K0BkTLmZBXTgttoYbcwKP1GKR/rkDqobnI8zYYN8SQHQ1uGan+xXxufIx/conCycvIJvoSzxt7Qh6HCjllaa2MlAa2hQTFkDlRHHnueUmQv9Gs4/qGBL1AbItuBlONZjQ0oX23pqzlkSGHI++5QSQ4Z7NKDnfRWN/AlWqzDZiLH4n63E/v6JwWFW/uXUkirZWi4tMsZ/EdqD4miA5WX2XnSAXrxPOEjwVRJcPGmPAzdECERh0/uNhtO8WaKglbku1kvMyu1LqGRWqWUypRSHMsoM4lvF7RmADOsCTg3TvGjuoevZ1oCSW7OVIp9B+pHowyo6PSiD/OQEokN5zJRZ74jqNeXdx6+j3D12x0vwM+21ipLBVlxMRlNScfm+XObWBwTfwJn1T1lF7QfVk5tqMURNYsE0RvlaHkUqE9QjZdUYCVv94fIoHeBZv0gGnEK8qNpfgrWmFG1Fi/hr6rtdpcf1FitIXSpEXQRyG9dp/16k+PUvNL2md/EjSboot8rEQh+MdRhpPu8trLMqagG3KOiBsM9V4OY/1cM6GjSx3GlSJvhoeETfAhL1Qk0k3UKJXFn5l4/mXJBOgwhpHiObfSzc0iSIpgvz74V2/JFFCyIqOyrs4FsAZKzrc+Eiby6tGrqe/V6g5Z1l38jOHWTTqFMMpEVAA00d7aLd8atyGHr9iQ1JmXlnXwhvozkDmn/zH7rKU1ob7HoAMDAuBL2yaG1+N
 oRoio/2O
 lVSap2xUD8DwYHVoA3p4FDa+rGtsXSfkMpuCM5IKcth7cJQ8ObTpREOsKmiOFXvR0pbzTyfJnakjF320zaODvhqkSNK77mfTmVqKCjBHh/5r5vh/2FPSvgnPHiDbB0WFZBIDKK98J+F6yXoJ0IOV66p5Ruq3aQ8L/PocUUXuo+R1dsQJpXFV5tW++yukbAxp3Dz90Gsem55uO1FgYQ6TtcNDyBOGl2xrMTmPfoOBK61+l6rRg3qYr+U+y7VTgUVBsxWIR3ob94GZuOsopn/Ur7BUqUV/22uP+yNQD4lRq2iO0db2rHq1EGT6geNuN+kLvCYU55ls7/zBqHuEV1JeciOX9GRKPrLazuloBvjUwnuNRE9puL9vkTuB6Ahq5xuTtZjI73WLdCfUmgju90n/wSsZq+duwJFIg0WmQhpTCzvQmegEH33hTb0LEuoARZzCMUEaZfYYm8UoN7YyhqIsd/6PAZk3dc8cnJQeFWIikp2+KUTFvyIoBJGwUSmodOWvxByV7m071eCM6IeUaOjAbHjcxDrICvouaNttMysLNzksYaFfZ1g8ygXDp49FLsY/nrR/qzmZYfOic+4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

deferred_split_isolate() probes each queued folio with folio_try_get().
folio_try_get() failure is treated as a lost race with folio_put(): clear
PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
the folio off the queue.

The folio_put() race is the most common case for !folio_try_get(), but
it is not the only option. Another scenario is folio_ref_freeze().

A zero refcount in such cases does not mean the folio is going away.  It
means "don't touch me" and current deferred_split_isolate() doesn't
respect it. It can lead to unqueueing folios from the deferred list for
no reason:

    CPU 0                            CPU 1
    ---------------------------      ------------------------------
    freeze a mapped folio            deferred_split_scan()
      folio_ref_freeze()               folio_try_get() fails
                                       folio_clear_partially_mapped()
                                       NR_ANON_PARTIALLY_MAPPED--
                                       folio off the queue
    give up, put it back
      folio_ref_unfreeze()

The folio is still partially mapped, but it is no longer a split candidate.
Nothing queues it again until part of it is unmapped once more.

Skip the folio instead: whoever freezes the folio, owns it and owner is
responsible for its fate. It also covers the folio_put() case:
__folio_put() unqueues the folio via folio_unqueue_deferred_split().

Nothing is lost by skipping.  Everything that frees a queued folio
unqueues it first, and folio_unqueue_deferred_split() clears
PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down
on the way:

    __folio_put(), folios_put_refs()   mm/folio.c
    __folio_migrate_mapping()          mm/migrate.c
    shrink_folio_list()                mm/vmscan.c

__folio_freeze_and_split_unmapped() does the same by hand, under the
list_lru lock it holds across the freeze.  A freeze that ends in
folio_ref_unfreeze() leaves a folio that is still partially mapped and
still belongs on the queue.

Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/huge_memory.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..6281ed993243 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
 
-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
+	if (!folio_try_get(folio))
+		return LRU_SKIP;
 
-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
 }
 
-- 
2.54.0


