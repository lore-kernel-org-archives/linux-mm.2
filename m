Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E3AC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B8A6B00A9; Tue, 28 Jul 2026 12:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E33A6B00AA; Tue, 28 Jul 2026 12:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA396B00AB; Tue, 28 Jul 2026 12:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC1A16B00A9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:02:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B9531A043F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:02:07 +0000 (UTC)
X-FDA: 85038651894.26.C57F8A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B265712001D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:02:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evolvZWz;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53Tcc2FrcqM5RSe5+P9Xw7NVIdmOkwy3TvduRaDIlPk=;
	b=Ci0B6KSPb2gM/SVF7mA/N0LhSbmWhV6DdpLa8hLyP642srLdWcqOmu8ZFEc7YU6jwqykpv
	x3i+fiEWy9Kspl0fFM1PcY6l/wCQiZXHsafCtliXn6eJTGwXOBmTehEJayHp8DCy7fCziX
	pCsN1GmqJ97BuU6pdnlDWcYaMfrrEHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254525;
	b=JtCcljAXaSbg7Z8lCGqfsZZWyU6R/7jA6b9yGLJOX+/CTiZVAxCeO1XaT6WR1MxZgwZGIq
	vPu308TSYdgF/1sH33OVlJOF75K9uAiXsIHoY+KQQYtozUHFoGKImuG76nnZrpvwKKn7No
	JDnhJKFPiMG+yKZeoz/kjwU7z3C7g5U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evolvZWz;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD479600FC;
	Tue, 28 Jul 2026 16:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B96E1F00A3A;
	Tue, 28 Jul 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785254524;
	bh=53Tcc2FrcqM5RSe5+P9Xw7NVIdmOkwy3TvduRaDIlPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=evolvZWzbLE9VSD/7i9PnT0FIdFupRwT0Mtfs26PCh7vXA5e8Qi5Avx6mA6hXc5gn
	 9dzMC6/9hvhDXBBph7w84dXFeyP9431U+p8OymcD4vyXshZ9y5ZxuBh9told/YZseK
	 ORkIAEWFaqWshK6K+c/Xl2aycQmRerOqFv5695xJAmEP0UwUfuHk9zhHDKSBtZV2c0
	 NJaWL3gEKEjw/HDp9099I36KKPuGLcZ7uAmrvc0tcDuNZgafMyMr3kU+UcWwlE4/rW
	 wzWFDVcyos5BMdnJOiU5I86f5OlHsoNPY4Ouw83HeukpZOW3BnzIo2C7q0nFZ7Fj6f
	 kaROK/scBxTOw==
Date: Tue, 28 Jul 2026 19:01:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjScICeRPqDzskV@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728151633.GX751831@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728151633.GX751831@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B265712001D
X-Stat-Signature: s9s45yuuxgafge59x74xjcdj3esfgtt9
X-Rspam-User: 
X-HE-Tag: 1785254525-665470
X-HE-Meta: U2FsdGVkX184BmAmE5fx6//09h5DkOLIBdEy7vTClWPtNlipS5TkUUaqagCMbmb1WctbH2MpTffXmEDqo1KvO3/BiIwxm9HGnYi02j5W/I5L9z5YgvTjRV4A+6c/4R46T3FNwIhJ4ry3RKS3haU+HLN1vJdzdNR+0nLxG9A6eMKEGPUhIJZ/G0UmFwQZB9UmxeUWOuAigGLoKrkphx8zJkYQ1c2YQlR4MBXHvihAMEGjExGswUFEl8w7MJ8lCe9OvrxUXc9tg18grtGtUL5j7tSuNDC2urFLaReZsYBHah/26Tco/sj++7iO60NXGnSm2pv+oAmktq7TguArzZH8IhQiZ7Wrpzv00LqS4Cd+FLMzkfxPPXDyv9cccHGAv5Pc67iM4huMGIWwPGOzq4qrTTGrh0L8+9he9zA6ko2EXr8Nm6PLGyle3F4jAcAvFMuZZOp7PtGqE2Z7qbzzBglL46VliIfy95WxU27vDtd4TXmrjXLgEJA6X2LeHTscvjIGbFztRpymvWMLjJ32av3oVMpOBUJz/IluWWhi8w5pTXv0ZLFtwXj1VeslhEBjLLrE/cILHVEHA0174u9a4HO4yhzf3cslU9zQ0kRzqoA6F1+XAbSxzdNTMeJ1BWllFne/koCYY0Ypw9vdX82R4LvBAy0HaMUJqPw5CYw35BnWSri/IpJMEZHqjnf60SI23l9Zm07ccdusDv/jA6m0S5CErpeNF3pyvXhQKTMPSX+NgMkhVhgNbc5O0nBpcx4npXBcbEoySa43HpnBXM0m737NhL59HBwhMfmVl+oiJN0NsMmAaI0NdFJf3KloSyeFHmqRgvawmJnV5+hpMGe861rDwvFzuqOANu35g1G/FF2ZuiUZIStbRoAiMbRzGWwgswG5wMgywQuvyaWYB3FVxqN9B4gO9t77aSJ4JP63zrwPk8cbxL505Hd+Tnmw6SGvsDrAKs/n5Hui0tm8n7hbruo
 Z6psFuzn
 NXscNwMyYvzUSnf2SwIWs4d0e96d6rgdO0rZ5EVjV68dL9trc9kphxUMUL40gsnMXp9qyOQBTxOrVKsFPBoV5KAsyhOzTpyeX5y0rzwKuaS95E+6XUKFgdGdcvbS336Q1NrwrM44lTyGAfjrQxTUq9AJ+tKxx8DeFgG8+WqWv8LSx+fFRRlz9IP5kDz5Le0Zlly4KvWpIY7IZuN/qXoz/nBFokppf6NNI1viFStt+p+G97zrzlS0e9IyPF4cQ+2geyxkhLhqZDzRBgIZgzOGpHBDJhOS9mEnysF6a6FN+rQSgbLb/1wKQKvVoTTixbC3EqZ3TfuX40lLcvH9VbkKrAV0zSx8OA77XRmpHj/kwBRuEL8yH3ZTiNh5BmKwuEh6UbBGU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:16:33PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 04:07:44PM +0300, Mike Rapoport (Microsoft) wrote:
> 
> >  arch/x86/mm/pat/set_memory.c | 33 +++++++++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index b1e780a465b5..4c8922695fd3 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -65,8 +65,25 @@ static const int cpa_warn_level = CPA_PROTECT;
> >   * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
> >   * stale large tlb entries, to change the page attribute in parallel to some
> >   * other cpu splitting a large page entry along with changing the attribute.
> > + *
> > + * When debug_pagealloc_enabled(), page attributes could be changed in atomic
> > + * context that would warrant disabling IRQs. But since debug_pagealloc always
> > + * uses 4k pages in the direct map there are no races for splits and collapses
> > + * and locking can be just skipped altogether.
> >   */
> > -static DEFINE_SPINLOCK(cpa_lock);
> > +static DEFINE_SPINLOCK(_cpa_lock);
> > +
> > +static inline void cpa_lock(void)
> > +{
> > +	if (!debug_pagealloc_enabled())
> > +		spin_lock(&_cpa_lock);
> > +}
> > +
> > +static inline void cpa_unlock(void)
> > +{
> > +	if (!debug_pagealloc_enabled())
> > +		spin_unlock(&_cpa_lock);
> > +}
> 
> If this lives, we should probably stick an assertion in both the split
> and alloc cases for holding _cpa_lock. That debug thing seems to rely on
> never hitting those, but having that be implicit is asking for pain.

I'd rather stick an assert for !debug_pagealloc_enabled() there.

-- 
Sincerely yours,
Mike.

