Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC5DD111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 16:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42FA6B0024; Thu, 27 Nov 2025 11:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3026B002F; Thu, 27 Nov 2025 11:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAF16B0030; Thu, 27 Nov 2025 11:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5D316B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:26:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5741E87B63
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:26:40 +0000 (UTC)
X-FDA: 84156915360.14.ABCC7AA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 154C8A000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:26:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZHiiaKMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfppcghB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zEaMcsMO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i378ebTy;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764260798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuMiS1EJ+aLGYrc/rNjM/OAOkdGlczkOx6GMs+RJ+u0=;
	b=cIoflxBPEoqlDtS9pCoVqFGeZS6icFeqCN7xOjXzUDqNHNj7WY7Hu4vlIpzQnwYofga7Lm
	3ClwsGy4Fh4VMnOtHEkQIUTKfrvxV2cXR5ZNzy0RWCOR95/W1zG+72sTZIE+EEH2r/1cCq
	ZOIiHxk06M1o1qZ6MZ+43rwOC+rQ+yg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZHiiaKMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfppcghB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zEaMcsMO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i378ebTy;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764260798; a=rsa-sha256;
	cv=none;
	b=oE9NftccsRrjXZm5z3RqX7Ow00HRSsukrcFNVlNnIRyoIzYI7RllCzSpTLh7cF8WSemuVT
	cFhoawaFtLC8PRGqjj/8/j5j4cS5R2se5w0AQFYNKw6YHe77i0xxT+xcUIDsws26JaLy/Y
	ifvHYvAkARvicqhjWHH9Z3hvfNGJVi8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DBDA35BCD0;
	Thu, 27 Nov 2025 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764260796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuMiS1EJ+aLGYrc/rNjM/OAOkdGlczkOx6GMs+RJ+u0=;
	b=ZHiiaKMUmjNdWcVAx8mYcgTlMl1TOlhTMWZHQjR+94hOuoktlCF9vmt31KXPM4+AcFl+pM
	EQgq43Z+eyMXp1+L5gFoiJEpmRbbniA6s9GdZ1rmPu04VKmEjGTUMyqxUcB4zAZ5XtFJgp
	RojEOrR6fk/DRDLpX/+/5ENN40+0B+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764260796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuMiS1EJ+aLGYrc/rNjM/OAOkdGlczkOx6GMs+RJ+u0=;
	b=yfppcghBR1WbD5x+jBg3untex+AQq3wnFzjWFxXVpWHFw2mYcqeYp/H38fj1sxNVgS1Tt/
	LQjfOIwvDgidrnBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764260795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuMiS1EJ+aLGYrc/rNjM/OAOkdGlczkOx6GMs+RJ+u0=;
	b=zEaMcsMO1K/qzdMAPBBEFSsamoUnY7luJn2W4Su9EbhFLsy+LsjJb4eG4bRMTQ+zsek9le
	+0DPoFYxdw+c3R1+NwqBJZQXT1fWUIabhWrbGMgK5bu7ot2yykBkgkoPQpaDgCf7dNM0g2
	SM/dRSvFRjf6UO1K0wHfczBMDnnbqmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764260795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuMiS1EJ+aLGYrc/rNjM/OAOkdGlczkOx6GMs+RJ+u0=;
	b=i378ebTyzO87EOksHlUeGilkDnovXrO3fX9hNSy4tcFTkNCwjal395WIRU7eDS7gb4PIcX
	CKMGNmDhxrj2L1Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DDE43EA63;
	Thu, 27 Nov 2025 16:26:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pdD/A7h7KGnRfwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 27 Nov 2025 16:26:32 +0000
Date: Thu, 27 Nov 2025 16:26:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	Oven Liyang <liyangouwen1@oppo.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ada Couprie Diaz <ada.coupriediaz@arm.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Wentao Guan <guanwentao@uniontech.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>, 
	Nam Cao <namcao@linutronix.de>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <v-songbaohua@oppo.com>
Subject: Re: [RFC PATCH 1/2] mm/filemap: Retry fault by VMA lock if the lock
 was released for I/O
Message-ID: <kzwpwntmta4bpt27stif2hs5cwlu54kayfi34o562jpr2mjbew@h3ddkbxibxhf>
References: <20251127011438.6918-1-21cnbao@gmail.com>
 <20251127011438.6918-2-21cnbao@gmail.com>
 <5by7tko4v3kqvvpu4fdsgpw42yl5ed5qisbaz3la4an52hq4j2@v75fagey6gva>
 <CAGsJ_4xQKARuEuhrVuV+WmBC7+NCNd==Zi9nGmze5mfSjF1kdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xQKARuEuhrVuV+WmBC7+NCNd==Zi9nGmze5mfSjF1kdw@mail.gmail.com>
X-Rspamd-Queue-Id: 154C8A000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 46oomwb3obyzaj6yump6e6rzrhnansj9
X-HE-Tag: 1764260797-833174
X-HE-Meta: U2FsdGVkX1/7JjRjrmIB83QXlxqflA+OydiDoV1na+/FjB0dqMlHUX012qNl/Pa430/e2DVkV3BtBOBg2g6y0+/5p9qLf7+jp+yhrdiBElWX1hkI00dOZc9DX1rFpUTfkvjZsOg5EWCQ3LRkoX5al0/dp/Iqv3dwvz20TvvrBOEzNapVnzz1FoNOLXni3KCIRp+c1UXgaHH8nMKTwPGahyVrxXE8zyS66wJ73DwiDwT3XLUKlcE/gPVHudwdAZU06pGV5veAy3Jq8tA/xrG1wmXmMiGwfaWP6nNfugVopdXV3CGgvP2GpFZk5r6qoigGNNEscKnkI6dsFUvUDL9XzFOUh4pEmvNJw06IJVGn2UR35nhxE/+afXwvoLHsmqzjkdrnqjwbsZ3LCYA2oOOzOTWmERbPSvOr+giR1Pf7XUgb7pRIsHUwoARQU9ebgJ5IjguaKXKJ+G0mOIo2IeQFw4EUxWDv9RudQB6KO1b0HcEexnH+YK7OVlRXtGa/ACziBTfoxNTzffRxhZYhot4OMc4oJLUtdnPE8oMy2oL6SrMIXMGL3rUz1idujWa1wu4KZhRDXbp+I17M80q2OU4WtCFPoDhfg3d/tbrO8rTdJ40ql4Pl9MJN9PakBIF1RqqkugJiXhIkarUT8in2VTjpKL90YhG98RUwH1dI/Gvex3wY/6j4b4SmEoR4NscQQ40NRP3kLgeQyO2r0CQi20Zk7gI4bUapELqlyst013ZVAL35HAfNupDAj3kCasuF6PQZWnfOnGq3ouWSMCEDzp9o6X1G/FOLUIwRCAjjE0qDuD+0tmkdqD5/jLwbdB4IGpPHYFhJoG4/qfBDpE0Hrcu8jtRDbpsxZkUxaeorSKnKkiA/9t41S6/Q4aUA6rU97uvb+vBTBo7ZqouUfF3vW8ZQfmen6YaYBDhgYZRvpQ1HDazWeJoXKibNzid5dlmDqfmGEjqAhzyhJB4Ts9eWLZB
 F25BK1D/
 XN83ICJ87fR2qQWBsh0BAx7AMO9WujEYajXgmDJlFR6nz2FaVzgMpDcjsWBGDkAIXtKEqOCfiIxBAhVjsW4kTC4Gh5MelImHv5qSJjIXRP8bjp0cLoFxMwyK/mmU05TVPuRL1WqH+rNAFsg+ORoFt8od/jTWjygjdma+utuEtbUoJ0iWPgi6NDXnNcUKEkeP5Oa344jHXwEh98qTqU8ZDtsTc5Vbv1tqekCwc4g+h3h78HiwHz+p8l9+wgyBXdZN2JbV0C9iTfz/hVFWTFzPkuxrfLh+63wA4SdYXWS2IJZHN4ecnBHFWbrgwVwILTX4ds+bsZ7kRQxalNf8mQ1BARpq/CJ+0i1V6/cWKbcczpGveWT2b4AYcHEAL7aXEMyXNv4z6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 07:39:11PM +0800, Barry Song wrote:
> On Thu, Nov 27, 2025 at 6:52 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Thu, Nov 27, 2025 at 09:14:37AM +0800, Barry Song wrote:
> > > From: Oven Liyang <liyangouwen1@oppo.com>
> > >
> > > If the current page fault is using the per-VMA lock, and we only released
> > > the lock to wait for I/O completion (e.g., using folio_lock()), then when
> > > the fault is retried after the I/O completes, it should still qualify for
> > > the per-VMA-lock path.
> > >
> > <snip>
> > > Signed-off-by: Oven Liyang <liyangouwen1@oppo.com>
> > > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > > ---
> > >  arch/arm/mm/fault.c       | 5 +++++
> > >  arch/arm64/mm/fault.c     | 5 +++++
> > >  arch/loongarch/mm/fault.c | 4 ++++
> > >  arch/powerpc/mm/fault.c   | 5 ++++-
> > >  arch/riscv/mm/fault.c     | 4 ++++
> > >  arch/s390/mm/fault.c      | 4 ++++
> > >  arch/x86/mm/fault.c       | 4 ++++
> >
> > If only we could unify all these paths :(
> 
> Right, it’s a pain, but we do have bots for that?
> And it’s basically just copy-and-paste across different architectures.
> 
> >
> > >  include/linux/mm_types.h  | 9 +++++----
> > >  mm/filemap.c              | 5 ++++-
> > >  9 files changed, 39 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > index b71625378ce3..12b2d65ef1b9 100644
> > > --- a/include/linux/mm_types.h
> > > +++ b/include/linux/mm_types.h
> > > @@ -1670,10 +1670,11 @@ enum vm_fault_reason {
> > >       VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
> > >       VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
> > >       VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
> > > -     VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
> > > -     VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
> > > -     VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
> > > -     VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> > > +     VM_FAULT_RETRY_VMA      = (__force vm_fault_t)0x000800,
> >
> > So, what I am wondering here is why we need one more fault flag versus
> > just blindly doing this on a plain-old RETRY. Is there any particular
> > reason why? I can't think of one.
> 
> Because in some cases we retry simply due to needing to take mmap_lock.
> For example:
> 
> /**
>  * __vmf_anon_prepare - Prepare to handle an anonymous fault.
>  * @vmf: The vm_fault descriptor passed from the fault handler.
>  *
>  * When preparing to insert an anonymous page into a VMA from a
>  * fault handler, call this function rather than anon_vma_prepare().
>  * If this vma does not already have an associated anon_vma and we are
>  * only protected by the per-VMA lock, the caller must retry with the
>  * mmap_lock held.  __anon_vma_prepare() will look at adjacent VMAs to
>  * determine if this VMA can share its anon_vma, and that's not safe to
>  * do with only the per-VMA lock held for this VMA.
>  *
>  * Return: 0 if fault handling can proceed.  Any other value should be
>  * returned to the caller.
>  */
> vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> {
> ...
> }
> 
> Thus, we have to check each branch one by one, but I/O wait is the most
> frequent path, so we handle it first.
>

Hmm, right, good point. I think this is the safest option then.

FWIW:
Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

