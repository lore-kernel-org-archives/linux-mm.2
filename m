Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4C6CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878648E0005; Thu, 25 Sep 2025 05:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8503E8E0001; Thu, 25 Sep 2025 05:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765BB8E0005; Thu, 25 Sep 2025 05:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 653C78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:32:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BBA41DF5C7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:32:01 +0000 (UTC)
X-FDA: 83927256042.03.988FD0E
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5E3FA000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:31:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b /aB3D+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BcRz1qeR;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758792719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aERbHKCdQ96xhdh41Z7RoEt87xEaCiV0LCS3CvEY7do=;
	b=WqIakr9IAiP3s9n6GvEViKkGKcg/LgoaDwyNC2A86I15L16JOrz+xYH6ID5j3sFdFTi5a7
	asCXr/dntEkLPUVSeXNjA9yQUhlr+Y8W4kZDrDRhk65k1jcuDjxpDbjvpPd4IDPc9eeNoW
	vsSYqGY1YaKZFqSWGuI+fcKrdn/h46g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b /aB3D+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BcRz1qeR;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.147 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758792719; a=rsa-sha256;
	cv=none;
	b=1v5/9OgH6UKJH5b0uTpGnwTqewZlScBQu709cG+GPWAjnQUpx67q4qbN2ycAk+uGrvrgAA
	zRu244amxOXwq0c64PJ9CVzssQNDp4S9iHl0byJ8OWw5xQRf3+xJ2uRnTR5UmaJ5t7yPuS
	AJ2QKggVgk3EL7MlsNBNf2a1S2VyPjA=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 301B4EC0178;
	Thu, 25 Sep 2025 05:31:58 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 25 Sep 2025 05:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758792718; x=
	1758879118; bh=aERbHKCdQ96xhdh41Z7RoEt87xEaCiV0LCS3CvEY7do=; b=b
	/aB3D+B2g5DAsdAHllxoECukzc4Mxr5x5e4f0oLVKgMMPE68+cz5jJK47NPl4OPx
	cXNiqIsxOuD4ToAZUi7n4qAxpXYl2498cmFlJRzo6P4CTkLl5nuhQNTUNlneqwS1
	HmCudPf8ul6qnYovoxm4Hmvjj8psY8eolNXTwriiFutSXMgWxokllWDHsf17kz+r
	MjysJWO3ITjHiR6riM65DlH3lqt80koizhHpRsJUTNz8ODb50e67hpy7WhsuRsEw
	Y2s+/YD4RtOUfS/RcSWhRpR1AAnaTnRRwycdqnXKbCy7eszuZnAmZnIcVHjOW/B0
	7APl/EMdW8IEW0drZx4iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758792718; x=1758879118; bh=aERbHKCdQ96xhdh41Z7RoEt87xEaCiV0LCS
	3CvEY7do=; b=BcRz1qeRU/Ax0KI320C6UCXKHbjbPCkM2yE89cLwJ9ydjr0jQrz
	cG/5FRYt3/UIybLw8FjmzXKGut64bDi+FDFy5AZ07BT7ewoN4DFj+Y4gDGUEArWI
	lzSBnzTTJ8NwBcYzJ3nltXnSL+rKrSLjaJhDheP1dGE1Lh2KRHg5/lWCGUqk9IlV
	Tn/hNoOqCnbIvkD4oK/yID4vUmlDRoEvMN4mVpl0mkhQLAMxxi5IvyqMht+Xa0S4
	y4/zXUEiB1e1nHt+zyZvsatuM5b3YZrVWGSY3PR4mKrGBk4Nbr7+t0uWtmbQL4dj
	tWu+31W7UXyqjcSBfJQ5o7u+j57TY0iRSug==
X-ME-Sender: <xms:DQzVaEd-Wyk8ljKKXYAOa1c4KbkABfsckvhDFhmJVUwrl0SlbnTwCw>
    <xme:DQzVaHg_rmjwHNMrW24yTPudk_w8vYtJrYYlCUw5FxxIhXSDT6hvvyyUiagFGir4y
    UhNu8x0ji4MUi6OXeDhq_2Ger9-citMZluTizbo-hp9XlWoz8T0aEw>
X-ME-Received: <xmr:DQzVaKLaBU28rszoWr6_2Mi0RvmpJwlM66xDgIHqbR_Q34YjdDf7pZpYbU1eKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeiiedugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeetgeegffdvteeifeekheeigeetgfeltedttdeggeeuffeluedtteef
    vdeitedvffenucffohhmrghinhepphgrshhsrdhmmhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhn
    rghmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgtphhtth
    hopeguvghvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrg
    htrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
    dprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhpthes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomh
    dprhgtphhtthhopehmhhhotghkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:DQzVaMpK_8EL7mbK3YoASnDh0nVDpZM2-IzxUWCWq18Q07scZaH4mA>
    <xmx:DQzVaHrxQVuch9KFZf40FFYe-apLD-veYlmGbjtY1nhss52sVC2YJA>
    <xmx:DQzVaCE07J1rW1n5MfJ1XcQ3nb0czFw5tCogZQfR8ZejrpDBH4lv5g>
    <xmx:DQzVaJobkvW1bH52sIv3NRddghk7HQZwlQeSxp5dsftVRZ2kVyoNyg>
    <xmx:DgzVaC-dUut48GdOheQTcCgeHRF3l8msugJNgRVX1IxW8DLOKtpIKUJY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Sep 2025 05:31:56 -0400 (EDT)
Date: Thu, 25 Sep 2025 10:31:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
Message-ID: <427kxhljdcrn7thput727j6vpqvxtalistn6yoq6ykdpbe5435@sn7a4rh7zcdo>
References: <20250925085429.41607-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925085429.41607-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: E5E3FA000B
X-Stat-Signature: ezmeo38binh8meauen1ihrbmw5ojopcn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758792718-799048
X-HE-Meta: U2FsdGVkX1/OlrF5dDoCjHtYpJEdG9G+fDYZxql3CmtB4w/FwjUJhaQh2ww/ZCGOOxTRQeHQqO3wUoXG8JAQppW+c7zP3foVXDBuSjttgufPCqBUK/lEoBaO21v84QIWbrl72dD9BdbwmY3epCKR44C1uv4V9PJVW/gjh1e4qrkkyLc5JXiIRzfjakkmx4b9ahOhvxYMDTyDquAi2sCdt9bXOAyiNVlbTMcY9uzBtGbk6eSNaTGeJlHxgsSf+x0poqlmLjenNPHPr3q5nuwH90EwHJkO8Yxjm5sEfePWQM4RUxhsIug/Xy+39/DKsp4LOy9q+3SQo6kmiCqwvwEMnXyTIY4HtOLfLBS9Li0Av4y5XtJXtyuYS9C3BTk+Ird5JtHC1k+hxL3mdRkH/Xw25Y1EBXQ/Z1JpnC3zNDNvkjztCAR8Bt9SNDRFwNKw0vna35xgkagmAp/0mEHaj+uAP14Z8v/WGfFGZfjTvCSnIvmA/4HLgXGXqTzyfoXrPTXS37PnYebt4OfFEjjro5eNyoVGYOedwS7kTxaM9Tk0Th6kW+YWrXN+i8TsisKOKhRypMoYrFibE93LXB5G9Jh5LzpYeIiH0toBW+q4MucQXT4V+1l8jig3/TBPaV0L4a22XVLmu7fihx+myEL6RlI5yLJhE1V5qDkDV5DoYJCc8eLT1psKFJNc76VT2RDDdC/Dy2wTZzdlEcRlJQo1qeOvTTv0stxMDUU3d+hC9YKKv6hzIoWgDD6sY6anVFncOHQjhi7O2ackqPCG4InBhVzDxV4JlU279mHAD1c/ioy91qTpn6xjim8+guFFA3zW5FaPaQKvJ6Nyf5HJXes3qgw3fv5eLJ9mFf2gA5JMuAffVBNVUpC7EGfyOmYBerA4zcSpcG2szaCphQEeFMm4dJj0qAouo/YpaIRWqlAo3/8U7DT4icL86uRpAUmSggLhJnz5ydCTR5FN0TxPoKl3uWJ
 lFcLcKky
 yakgmjwEE3MD4qFunw8HfPAUJ8ZRXAWwe09UQJS8u26StH4XWgVZQFgwTYO2SNwPTzZBHwSNGygbBEHxiIECyeP61cCrHD/bApJyk23BmloKWpgbTeUuOZ4/yvZwu/31v/+/y5BAaFahLyAGwQf+/aCoVlFV0MmgcIHzmnqiyQKdcch7YXPsYOv50KifOrNgkvZXiKXlcZBxg7WEqBLByBQ4d6Psb2mzjdHF5Gdso52zSkYaWZfmp6DLqjorYXTrIX4Kfvk4zRpG4HKWTGYwZQpustKUgYLAKIAuh+iE1vCrMl6vJlX2oTyYd/+lmKjN9HclOk4NjZbyWnFQEIgVB/utGsYdfUOcjAQaWSNRXN/cGD7FEMIce9e7oSmXG4MS4VFymsS7k6CLSPgUniOuYtVczXamK2U9BDUxhfZLI5B9DMmdD3qG/dyt6jEQs6IOikhoDpxj5d/7wZyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 02:24:29PM +0530, Dev Jain wrote:
> At wp-fault time, when we find that a folio is exclusively mapped, we move
> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
> reduces. This is currently done for small folios (base pages) and
> PMD-mapped THPs. Do this for mTHP too.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> mm-selftests pass.
> 
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7e32eb79ba99..ec04d2cec6b1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4014,6 +4014,11 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>  	 * an additional folio reference and never ended up here.
>  	 */
>  	exclusive = true;
> +
> +	if (folio_trylock(folio)) {
> +		folio_move_anon_rmap(folio, vma);
> +		folio_unlock(folio);
> +	}

Maybe take the folio lock earlier in wp_can_reuse_anon_folio() to cover
large folio handling too and avoid trylock here.

Something like this (untest):

diff --git a/mm/memory.c b/mm/memory.c
index 812a7d9f6531..d95cf670b6a8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3843,6 +3843,7 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 	 * an additional folio reference and never ended up here.
 	 */
 	exclusive = true;
+	folio_move_anon_rmap(folio, vma);
 unlock:
 	folio_unlock_large_mapcount(folio);
 	return exclusive;
@@ -3858,8 +3859,15 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
-		return __wp_can_reuse_large_anon_folio(folio, vma);
+	bool exclusive = false;
+
+	if (!folio_trylock(folio))
+		return false;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio)) {
+		exclusive = __wp_can_reuse_large_anon_folio(folio, vma);
+		goto unlock;
+	}
 
 	/*
 	 * We have to verify under folio lock: these early checks are
@@ -3869,7 +3877,8 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
 	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
-		return false;
+		goto unlock;
+
 	if (!folio_test_lru(folio))
 		/*
 		 * We cannot easily detect+handle references from
@@ -3877,23 +3886,23 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 		 */
 		lru_add_drain();
 	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
-		return false;
-	if (!folio_trylock(folio))
-		return false;
+		goto unlock;
+
 	if (folio_test_swapcache(folio))
 		folio_free_swap(folio);
-	if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
-		folio_unlock(folio);
-		return false;
-	}
+	if (folio_test_ksm(folio) || folio_ref_count(folio) != 1)
+		goto unlock;
+
 	/*
 	 * Ok, we've got the only folio reference from our mapping
 	 * and the folio is locked, it's dark out, and we're wearing
 	 * sunglasses. Hit it.
 	 */
 	folio_move_anon_rmap(folio, vma);
+	exclusive = true;
+unlock:
 	folio_unlock(folio);
-	return true;
+	return ret;
 }
 
 /*
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

