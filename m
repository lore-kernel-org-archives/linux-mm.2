Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BFCC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3056B0093; Wed, 15 Jul 2026 11:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C8B6B0095; Wed, 15 Jul 2026 11:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F46A6B0096; Wed, 15 Jul 2026 11:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7486B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:49:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2747A020B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:49:42 +0000 (UTC)
X-FDA: 84991446204.08.3FE0856
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BBBD140007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:49:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfStKliW;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784130581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dppU3jext8Cfhc/a4fcob/OWEauwlB4pCHse6dF5FfE=;
	b=lglh1Jin7EJRjbjHjxvg73tOVsIYKD+FWpCBshv7LJh8w3Y+/nIGG09x82xf/XONcTlLGU
	VuFV+TEDw8sDHwC44ExIFP9yuz5ZR5jst/vATFpFdekCtWCy8InrhaF1RIBo9IssULl3ea
	GbGzYmYhxma46kR2Xyf1M69wBR5n/+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784130581;
	b=4XQzqKHlHDDz8MtHtmMlGI6YR0B1QxGHuHpGcATcruiQzzr5IEuuIIQAnpU385LiyGdAT6
	2OMA4voo0+DTD421jbS/YB7T4RazaSm5/0k/sDhIGfbE+bMhykITxHWikJcuEnEReNN/OD
	rV2ivUzDgm12Rq0Amfww17iM8X6klB4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JfStKliW;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F3E041318;
	Wed, 15 Jul 2026 15:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E021F000E9;
	Wed, 15 Jul 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784130580;
	bh=dppU3jext8Cfhc/a4fcob/OWEauwlB4pCHse6dF5FfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JfStKliWix9MQgnZ5RZg9SJ72c2MTpasGugfWwP7+RJOvdJ96GK2cdQR/hyjOHt3N
	 PoICC3f/12tQsSjwwmrk4qdrpdx1oTc2w0cCF1zgOQtDB3SYTldCH7cLg9v+LTWwhz
	 ae8/7OsggPgfBKlm6DusfuBPm0vDTJvOIhJKlGSlqVZGP3XK5SlSJyzr1dntetduZK
	 QL307ELqTSxqUUyNDPoqjM2I4XRG1/wxlv+2MHaJ4ORE4CwT1irifJgiPl1kCjBUZy
	 qoHp+UfSipV3mdjpYbAVCBIMkI5oFsyDTv1YESKX7JKF2Logz1eO7y05C7pC1uVQ6a
	 D7LztoDurYkGA==
Date: Wed, 15 Jul 2026 18:49:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	abarnas@google.com
Subject: Re: [PATCH mm-hotfixes v3 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
Message-ID: <alesCtwXdIqH6bOP@kernel.org>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
 <alemS7vxeRB7NcBO@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alemS7vxeRB7NcBO@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BBBD140007
X-Stat-Signature: 9c6ifhgmfxp3djtqo5t15xg3i9w9skm3
X-HE-Tag: 1784130581-247520
X-HE-Meta: U2FsdGVkX1/3fUZ3KaVW+RQOxrN1GdgU7hDBAP4ujLTUHf02QkVJJgv/xkT+Xb4C2H+Z9q5sJOjfZdUg4vKz1fJvyKmg4YySL2GxRCM7G2X/YdCe2K7TZ90Sq0XJbSh0YVcAYpvYNu9got7cgZMBDzYzlgOcHiGULcH4v335yoOpubruSHMeQiPOmnO6r8ZsMHvM+awq4gNwNyu3wOPzcMKdj2OwRiAhZfSLWrV9cOemC/6SHsLFQAWsQDa/6UnIU3L25uVjs2rL+wl8JQpPFL5JzDG7byPd76FAovne3VAKMb9uJWukOLYWocJabUkp7c2NJJImJk/AfGBn7ji70nhqFk6/dZXgC2NAEtCm+bQq6ErxAv7zzGn/7mYczqAQc4fwEztcihQSbvgHwHAAhurkOz42gVdza/7BSyHkcgwVCoeDnNMBTzs16Q2ktWUwmJyLPDctg6rLDjFGyxLxEPfq+yZBa+aQIML0++UDn2J49No6sTY/+4KifK6bawUBupy4TxmIzCvTcUgSUp4zZCxtnGqu23uY1aU1srvC42qH045cDKzMs74/qI0t06MJvYyHXkmvovoTfjXvVY3xcZ1QYFHFCDNBff/PURbZOmSbCvo0r4TF8WueXHfs6KbE363FCtS7y8B+abwpCdfLWpklMKwW2yjcKqiE2Gysv1HK3Yb4FQSHFhy3/sx8FQf41hQresS8h30z6B9Lk9oN3wb6JVe9SxQ6OhnNDfcTd3Eo0ts1DwZctNL0YO4tHDEKBAWSa5wudGuf2uhUDGqFpF3YXjssbNPVOKOX20XslOG3GrgfOuuHlwH7cWRlfOZryzKWLlthaeueiZXO6Ujl0LavunB5eu/8hFFobT/r7IQctyLhAAN6dvZ874D4111tTuqMkXEHkXxp1jf8kqlBS5uPXZer0tkqBF/klGneynAPQXKxvQOhBozHdoKaR4aWzL+PCja6w0TVhXUFsm+
 ew3PqEgU
 Nso/VT76G9/2PvdRo9AclYoGSnJqVkaMse6bcNVgzl3piZ0cAlHGJx1tR+7HRIHSfWdn3dwS9QDljVhyBMCIEs4foCDBOCGunOtuSQLcguxj22klmOR4JcyTe/jw7b0P0mEUsPs2dKJQz6uZBIjlf649VAQD3vBRC4zZsOc17DlJ4pHkpnIGLKVRkAvXF8gMJGml0YJCpXwV62dIjzyhUJABCDh2GK93KOuxCSNcOnydiXQl5MiawMTiY6UBO3+1mtrIqsxqk3M0TfSqN8zJU+p/pJLapmPx4S7lvfsdQ9/Mtx5wW430iQZN//Fq5uPsXYEAW0jJd3WzQN16u6H6zpbEOBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Will,

On Wed, Jul 15, 2026 at 04:24:59PM +0100, Will Deacon wrote:
> Hi Lorenzo,
> 
> I'm certainly no x86 expert (quite the opposite!), but I was looking at
> this with Adrian and got myself confused. See below.
> 
> On Tue, Jul 14, 2026 at 06:24:24PM +0100, Lorenzo Stoakes wrote:
> > x86 implements page attribute modification using its Change Page
> > Attributes (CPA) mechanism.
> > 
> > This tracks properties of ranges such as cache mode through x86 page
> > attributes, and as part of that logic manipulates kernel page tables.
> > 
> > Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> > fragmentation") ranges of kernel page table entries can be collapsed into
> > huge page table entries as part of this logic.
> > 
> > As part of this collapse, it frees the page tables which the collapsed
> > entries previously pointed to, and it does so without any relevant locks
> > being held to preclude concurrent kernel page table walkers.
> > 
> > The only way this code can be reached is if CPA_COLLAPSE is specified, and
> > this is only set in set_memory_rox() via:
> > 
> > set_memory_rox()
> > -> change_page_attr_set_clr()
> > -> cpa_flush()
> > -> cpa_collapse_large_pages()
> > 
> > Notable users of this are execmem and bpf when manipulating executable
> > mappings.
> > 
> > However, this is problematic for ptdump as it walks ranges it does not own
> > and thus runs the risk of a use-after-free on page tables freed underneath
> > it.
> > 
> > Resolve the issue by acquiring the mmap read lock on init_mm which prevents
> > a concurrent ptdump as it acquires the write lock.
> > 
> > It is safe to acquire a sleeping lock as all the callers invoke
> > set_memory_rox() from process context and in any case,
> > change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
> > mutex, disallowing atomic context here.
> > 
> > Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  arch/x86/mm/pat/set_memory.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index d023a40a1e03..4c4b8244502f 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/cc_platform.h>
> >  #include <linux/set_memory.h>
> >  #include <linux/memregion.h>
> > +#include <linux/cleanup.h>
> >  
> >  #include <asm/e820/api.h>
> >  #include <asm/processor.h>
> > @@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
> >  
> >  	flush_tlb_all();
> >  
> > -	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > -		list_del(&ptdesc->pt_list);
> > -		pagetable_free(ptdesc);
> > +	/*
> > +	 * ptdump might read these page tables, so avoid a use-after-free by
> > +	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
> > +	 * write lock).
> > +	 */
> > +	scoped_guard(mmap_read_lock, &init_mm) {
> > +		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > +			list_del(&ptdesc->pt_list);
> > +			pagetable_free(ptdesc);
> > +		}
> 
> As I understand it, the argument for taking the read lock is that we're
> operating on a region that we "wholly own" and therefore we can happily
> run concurrently with CPUs walking distinct parts of the page-table.
> However, from what I can tell, the CPA collapse logic will operate on
> regions outside of the address range being manipulated by its caller
> because it rounds up to the PMD size.
> 
> As a made-up example, imagine I have a 2MiB aligned region where the
> first 1MiB is read-only and the second 1MiB is in the default r/w state.
> If one CPU calls set_memory_rw() on the first 1MiB while another CPU is
> walking the second 1MiB (via some other API that doesn't take cpa_lock),
> it looks to me like the first CPU can collapse the page-table and free
> the unused pages under the feet of the other CPU. What prevents that
> from happening?

Nothing, and there's a patch to fix that that synchronizes
cpa_collapse_large_pages() using cpa_lock:

https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org

This still won't be enough to sync with ptdump though.
 
> If all concurrent walkers have interrupts disabled, I guess the TLB
> invalidation logic would do it, but it would be good to call this out in
> the commit message because it's not clear to me why the read_lock is
> sufficient for the collapsing case.
> 
> Cheers,
> 
> Will

-- 
Sincerely yours,
Mike.

