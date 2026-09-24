Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE837C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E7B6B0096; Thu, 24 Sep 2026 05:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05876B0098; Thu, 24 Sep 2026 05:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C856B0099; Thu, 24 Sep 2026 05:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B77536B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:29:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA36AA5841
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:29:38 +0000 (UTC)
X-FDA: 85248133236.13.16C8B78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B5621A0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:29:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm+Fwa7r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790242177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ks0w1rHPiDMbqqG99fpjPwGGuK/nceQ8BW9BfzFj+fc=;
	b=5mSXA/IbMNZgteDwOMsmg9p49C5MsNLUF1UbITxG2n9OCdmqneKZuTxPN5kdH/9Jf2mCYW
	ESa2hUhvkIi/rtwNde0v2U/BxmqnLoPNNaQJhntw/7xsYaruZHSp/aw/5n5QnE+6TsVsKD
	wF1yi6e1ubSOmygeqc9OJ391KOGOE+c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm+Fwa7r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790242177;
	b=1/ghOBxj+DnUsgMte8enJGO9JV09skjvAB7A91VSGXCdGlstBW1mHVxnYJFQS9ckbQOUpt
	NR0EkslUgUGipEnznZ+XvHjjqWBE/v2jb8ec20Z3sboZnLTWaEgUTuRIbVejU1DghHAFSF
	8f3kZWNtVmEZ7rfQjIftfCHl+L5OMqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7151600AA;
	Thu, 24 Sep 2026 09:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0B71F000FF;
	Thu, 24 Sep 2026 09:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790242176;
	bh=ks0w1rHPiDMbqqG99fpjPwGGuK/nceQ8BW9BfzFj+fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lm+Fwa7rBukjDdQpzJDEQf80YAJJBMO9WT/Y84Z6zBCDoesGJ6lMYoymrAxpvRA/S
	 5qZID6fZ7FitJC+kX5Yc34J7MOKOWr96hil/eb6D9lTLKqrInm0p79sHbtkEB828/F
	 +t0EmQwm9flvR3SQlv69+Ls75YyUsCPM4rdoCQtuLS/2vMtiafQ1zltIhEjmQaFBlF
	 PssluRWFi1r0lqm4805PJMCr4h2mnQDIPNhHUascXIyWR7R5mdO0N6q4NAGoT/nKcT
	 /LQgTaA583h5uLTLE+y/lA89MG+G1gz9Vkxi9WBl2ocBXPekK5O7Ehciij3CxQUwUd
	 JdaGuBdtP21Bg==
Date: Thu, 24 Sep 2026 10:29:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
Message-ID: <arTq_8FGRj7a85kw@gremlin>
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
 <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
 <65b94694-d503-46c5-9f13-f0f7f8bba8d8@kernel.org>
 <arTl5Cc1B-2_BoHP@gremlin>
 <arTmLiTLnxhwohH1@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTmLiTLnxhwohH1@gremlin>
X-Rspamd-Queue-Id: 3B5621A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gy7rujz4exuxb61q9ia75ypnzn4m4pps
X-HE-Tag: 1790242177-791317
X-HE-Meta: U2FsdGVkX1/Cf/NnUiBOL6mH7OCrzoU9ET9OY/xT92Ktxp+4QUHI4Zy5jWLEQgS+yVvknYq9j5aParFJMCpqoqaln63AUd8QE8BkB3fL6BLq8mAgMVZo8v/CkbPBm8pA7KiislU2c/XlN4AWCH2tqrSYGYCCPX41P6aC6jJVd3UFa2aveQrXk1VFeLZZe9N8IQgyFywCPEQ5HrbjWRxDQ8L+ypKiGW3cnjWqRJJH0HDhlZ8ZPVT4S1k9G9uMIRJofvklcCW+rreDjTMyGQBc8HF8b2CRTNILdN5KzMS4WfW1w+oAGaneKVfrr3bk5M85F7PdyJtpJZWkjZQu9nM5TWGwM4gWjQC3vu1A77BOPfLQ7JHDeb/PbKL5ewq6UrI2PbQ9xLa6IHwV4/9Vn0RZHJB9cjgrAFLCf/1CYmk3g39xzOzTjYqMgnNzSUORZsDtSYnUcSaO2Y9tLcowq3M5FQTmsqJf6qpXTaSR7n7DYJfofVyJDZSn7s/T2c4doyNlHCr5WeeXtweWtTSUkZWo/LU0CccAfWvszUAWEElGdOozPTP/Veoys8tjtrbNLMK1TQrzc8TXOgiRlpfll/waA0LPs3x12Kkk/i7puv8CmRxxI4xYlTKqV/3mujYKbOaUk13TONazVe80kFBw47vRcF/ejXuY9QMNF1VVqHm0F80C3t8833CG4oxmw7ftYEtJhQz1gqDNSK3Bwyx+7pJkbWg4w3oooew8XThaRFKVjvAbiI7v8iRfHvo5AtwzgNVGJZNrzUep/xNfv7+g3V0An1ATvYAwTbajNJO4Bd1GKPSS4LAt2YWNVRVaLzPYcHBOtHb2UnI/qjHRIwgpu9ol8KOWBInMECgPC9YlCSe1k9Fedg2phNaq/UtArbnQpIWTLvBrWooyNVabAr4d80r26LygonArqEFvPrBbrDPaI8RL6M6r87VIOGZFIbC6imcuNN+4CCU8rD5t5aAdJbV
 yVEJPg28
 U+DMPxXdYZ3tVrSz8f0DyIdaF1uh/wiGYmLanaWc6Zm6SXeSCJqmEb4+ok0Skb9s3ijS4YD0B66vNh3A9S5kk0BGmVqxfY+1uz0Fw9K06qKNToo0waNfr233xgMZcqT5Qp8A7N4NAX3UUHX82bvsI+oz/l9qOK5dUbYyEaMPUPiVnTQrj0XIbKVsY0djLmTNxQkkLQIhnw+C7bAWTkMY4mGxDFz1Ls45EiU2bDikOQbheDy9qFutyEFxYzVG4Hrc25bRHp4LCiaYU6jka4lM+d8BecaTQmMGR+A/U1Nh5dAH9I/mbzNtbUC1BEfyGB/e4E1MJWV8GcEKpDTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:59:36AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 24, 2026 at 09:57:57AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 24, 2026 at 09:31:40AM +0200, David Hildenbrand (Arm) wrote:
> > > On 9/24/26 09:28, Mikhail Gavrilov wrote:
> > > > On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
> > > >> Should we instead simply skip the
> > > >>
> > > >> 	schedule_work(&kernel_pgtable_work.work);
> > > >>
> > > >> and rely on anybody freeing stuff later to just free that one alongside?
> > > >>
> > > >> That avoids throwing in more freeing handling.
> > > >
> > > > Yes, that is simpler, and the early table then goes through the same
> > > > IOMMU flush as every other one, so there is no need to reason about
> > > > what an IOMMU can see during boot.  The only cost is that it waits on
> > > > the list until the next kernel page table is freed after boot.
> > >
> > > If we're worried about that actually causing problems we could drain the list at
> > > a later part during the boot stage. I'd suspect we free something else later
> > > already and simply drain the list ...
>
> And on that, yes, I don't think there's anything to worry about there.

Though maybe it's worth ensuring the drain? Shouldn't be hard, so like:

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index f3754cefb19e..67f286169632 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -457,12 +457,29 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 		__pagetable_free(pt);
 }

+static void schedule_kernel_pgtable_free(void)
+{
+	schedule_work(&kernel_pgtable_work.work);
+}
+
 void pagetable_free_kernel(struct ptdesc *pt)
 {
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);

-	schedule_work(&kernel_pgtable_work.work);
+	/* No workqueues exist yet. */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_kernel_pgtable_free();
 }
+
+static int kernel_pgtable_drain_early(void)
+{
+	/* Drain any early kernel page table frees. */
+	schedule_kernel_pgtable_free();
+	return 0;
+}
+
+core_initcall(kernel_pgtable_drain_early);
+
 #endif
--
Cheers, Lorenzo

