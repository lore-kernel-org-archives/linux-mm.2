Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99F4606A339
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ekkmc0iv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=meBZKaxc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=euVkA99P;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=pJldxYkT
Received: by kanga.kvack.org (Postfix)
	id D75346B05B9; Fri, 30 Oct 2026 07:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DBE6B05BA; Fri, 30 Oct 2026 07:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B376B05BB; Fri, 30 Oct 2026 07:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4AE6B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:11:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FE0E1405FD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:11:17 +0000 (UTC)
X-FDA: 85379026194.17.D910C11
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id CBD14120006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:11:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ekkmc0iv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=meBZKaxc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=euVkA99P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pJldxYkT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793358675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nszrMrMC8JlryWKVnrpBXd9LzP9yZlaTn4MSY8r3MBU=;
	b=HzvdcJKuBYH/J5O/p9XlQ6ZF/QDcHaZJvW3efERmZoZXKk4Zud6eyKBnxl4ptTu5GXE4rD
	+PhaqNh4m+QFBEoNWMR6qcUn+ule/vA9CSon7ook+UXvzb461W0Dp1VbALiQmz6LISMVnZ
	0jhMwxkxHjPafDgNHrassjMpnnohdTY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ekkmc0iv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=meBZKaxc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=euVkA99P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pJldxYkT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793358675;
	b=MSSdThCjBefiDuSFO6Q8jd8P6pc9NuIjdJFZTn72VLoIkNPMMZPoMfMb2tldfksC+1YfLr
	rNPLTDHa47r4IuO3F3FSC601ZgaoZvOCnR4L4/6jyrj3LSrT/ariY+qtPf4KJB1XdIB31w
	S1DfmBfw+rI6VSgkPseH37/edsCAmkc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 35D83221DB;
	Fri, 30 Oct 2026 11:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793358673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nszrMrMC8JlryWKVnrpBXd9LzP9yZlaTn4MSY8r3MBU=;
	b=ekkmc0ivszyK/vAY6lBPUE6qzElfnru/iUuzfCgKurIOdUPfpTcZe4CQ5WdHK6uL3HpPe+
	ivAE/pEXQy7dDGEFw+qX3s0Z84oKfI3yKDuaJBvFZLVbH9Dkd8KiHbWtIywrqaQlvaQFUc
	JKeBzBRaWoSBGTLsp7OUQf30CTmgbgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793358673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nszrMrMC8JlryWKVnrpBXd9LzP9yZlaTn4MSY8r3MBU=;
	b=meBZKaxcQdo5M64Civ0W8Qi/p8wiRzpNc0CNoDYaq1bku7e9AvD+TUTvwGMpyXcIQ/SeL8
	wvr3F55IIX8v5dDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793358672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nszrMrMC8JlryWKVnrpBXd9LzP9yZlaTn4MSY8r3MBU=;
	b=euVkA99P02W0HOtNgkwVGJU0eZPovuI7Z5vIQKYRCLeaKtnfmcUQBmK3vxdh6dKKmhhli2
	7VmJSetuGoiMj9Tt+ITO9lvykXuyB5MampsGDXUfJZJXuFRdpQsw/WiPiRkNlPyyF9QkVr
	T3K6swpXqDdQnzSF0lLDFSeJgKqgcXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793358672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nszrMrMC8JlryWKVnrpBXd9LzP9yZlaTn4MSY8r3MBU=;
	b=pJldxYkTA1CYZE9/K7+AqoHKGny9M0DH5G+YPoB8VymsOdj36c0gEmwgZx6L4ggLfJsNAW
	vXLPyJhRAoJlUZCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7654132C9;
	Fri, 30 Oct 2026 11:11:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nEf3HE975GrwSAAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 30 Oct 2026 11:11:11 +0000
Message-ID: <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de>
Date: Fri, 30 Oct 2026 12:11:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
 pbonzini@redhat.com, linux-s390@vger.kernel.org
References: <20261029143336.390231-3-clopez@suse.de>
 <20261029175203.5bdd51d7@p-imbrenda>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <20261029175203.5bdd51d7@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: CBD14120006
X-Stat-Signature: 1st5n3o8kzwmfac1nat6r76dn3ug51mx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793358674-602532
X-HE-Meta: U2FsdGVkX1+sDSDWaaqE1WjgLL/cdvHWOiu//2doYlP5axzbGWKnENPqK5wloXW2t6yJb2+kt8O8810Ewap35OLQ0i13kJZ+Bjr39pyWYMmw5vNFP+lEyqC7EJblMxgFvwmE7QB3hO/0bY1wvYJp3jxrH5V89/fnzXGZLdVfE2EcWS+AdGP3vApF3daJbuOaK+L3tjhKlccC3anj2RMNS/uXyUlRV+9VvwPIO8uH3MdFhCl5wM9m5kASYzi/jXjHjhxaMIJZYIsNQrOQOc0aXNawBWn2IUENC+O7de/KlbjyNfZNKyGpAfzooAGHgBnaT1mRgKd/dxJb3dQ5kFmBCdy61mYt3MNuVGwjggjZjyGaSYlJ1DaFmNXsnLQ/iCmrfD65aZ9E3w93v47KihaBFFmS1gTDz+1OAF94lCsNOrhplVv7DNqDL4Zu9w+wX2I5NeOxS2vMW9xa9QZ/PC6mjidimUpZvYBWuHi2OBdOqzGt69bwIh/gfHFPJ/Vac/UVuq50MmtkEiFFY3WAd6SWCkjEjeXV8+D6prGE4fM/x7xjamobuOmsTy/uu+rlsxeRpoxWr91xs2ytMlXnxFzbd2WZiSweYlv4cC01MQkFweQKv7+18T1LIcwT2LqtW+orB/3efDdfo6Eo5fcEXsPT6uU9VYOOIld+5J9/WnUOw7IkNuf1CvYAh4ydgzRklXEpu91kvLeqfoUi7WK8sHQZ686F5tby9HUhaYZS4/E7MFQMk2wnmK+l7shUFmKs+Piyrsk6+VWF2kMI3ujT7knWktuqAoToP/E7VEZ6wf76wRKTnk/XPNQTiwzxLFjd5EVntbtCaRlw30waLO1G7TtcT+qlPk2m+M8lyUMdJvqGK5QYFknfvRnph9k5OHJ8EglBWwaD1mO0pJ2lhDFe+wLzi3lj1diiWeLf+39FbloYysVjfao6FmLWOXxyztfD5ArZ7yyf4YK7mjt+QDbJ92u
 G5pBi0ip
 0SR9XMetJWot62jgyL/HmJKJBX41q5jmO6CAWkUgrz5Ak5CZLdvTzLhlJqmOl4tDSBor4Zn/THIGFV4hOWiKQ2tnAAQrq3W5EaBJn135PKq61MwU/UP4f3w3CXsY2B6dYZAxe7w1IklniuPA2ol8CwMZaenzUddNDP6LWTlPQcCuhQQ07eP7ZoaGqxXOVLfDQkqlPfqJ45rcBKTvsbotFh0Qi63Ksj4C3nZtTaSq2PkYEEn+23P3B7fRte3/KSGud1Aj1IynLLz0cN5GvsbwXIo55jBueMx8EqJrt8+rXXOzvGjNKLmGDbfFniuFIl+c79h2QlO+/jSpmTbWy6yMLX5RN3LMWQvREJzIbzFPCf0v9yihlnnjFS3YcgkIYbkMfT0rvjod6bIVD335kxu9/QFb4fB0KDCga7m9gEPxyApeBKytDfcdHcmBHODOgztbmdd8luxAYtdgYq9cfF/7Y56+vTaxeQZco169UDm2HRsowZoGpMigAokcDch36NdfVwv6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 5:52 PM, Claudio Imbrenda wrote:
> On Thu, 29 Oct 2026 15:33:33 +0100
> Carlos López <clopez@suse.de> wrote:
> 
>> Prevent x86 KVM from over-zapping its secondary MMU on PTE permission
>> upgrades, which leave the PFNs unchanged and do not revoke access.
>> Permissions for SPTEs that KVM holds are updated on the next fault, so
>> dropping them early gains nothing.
>>
>> Do this by adding a new MMU notifier flag to signal that a
>> MMU_NOTIFY_PROTECTION_VMA strictly upgrades (loosens) permissions on a
>> particular range.
>>
>> See below for benchmark results.
>>
>> Background
>> ==========
>>
>> change_protection() pairs every protection change with an
>> MMU_NOTIFY_PROTECTION_VMA invalidation, and KVM zaps its SPTEs in
>> response, as it cannot tell whether permissions widened or narrowed.
>> This is costly e.g. during a QEMU background snapshot, which relies on
>> uffd-wp to write-protect guest RAM and then restore permissions as each
>> page is saved. Without this series, the permission restore causes the
>> guest to re-fault read-only memory needlessly.
>>
>> Note, the reverse situation is already handled for secondary MMUs
>> that reuse the CPU page tables (e.g. ARM SMMU, IOMMU/ATS). They cannot
>> refault, so they are notified of a permission upgrade on the CPU
>> TLB-flush path [1].
>>
>> KVM, however, owns separate page tables and faults permissions on demand,
>> so it needs no such notification (as Sean noted when that signalling
>> was first proposed on the fault path [2]). This series applies the same
>> principle to the change_protection() path, signalling the permission
>> upgrade so KVM can avoid the unnecessary zap.
>>
>> RFC Considerations
>> ==================
>>
>> 1. Having the zap skip in KVM's arch-independent code does not seem
>>    obviously correct, as s390 caches additional translation state
>>    that may not be rebuilt by refaults. Maybe an expert can correct
>>    me. The skip could be extended to arm64 and RISC-V, but I have not
>>    benchmarked the benefits and I'd like to get feedback first. Hence,
>>    x86-only for now.
>>
>> 2. change_protection() could simply not emit the invalidation at all
>>    for a pure permission upgrade (shared-page-table MMUs invalidate
>>    on the CPU TLB-flush path, as noted above, so they do not need it).
>>    But again, the s390 case could be broken, and even then, that would
>>    seem too much intrusion for KVM's benefit.
>>
>> 3. The flag reaches KVM as a bool on struct kvm_gfn_range.
>>    Alternatively, KVM could forward the notifier event, as Claudio
>>    Imbrenda suggested at LPC [3] and others have proposed in the past
>>    for different purposes [4] [5]. That, along with the event flags,
>>    could serve the same purpose. I'd be happy to take that approach if
>>    there is agreement that other consumers would want it.
>>
>>    (The LPC talk recording has some audio issues so I am not too sure
>>    on what the final agreement was)
> 
> AFAIR the consensus was:
> - adding the reason to the kvm kvm_gfn_range is fine.
> - having a return value from the notifier to pass information back is
>   _not_ fine; I should add a new callback instead.
> 
> regarding this series:
> 
> on x86 you don't care what the new permissions are, because you're
> updating when re-faulting (if I understood correctly).

Correct.

> for s390 it might be beneficial to know what the new permissions are;
> of course we could look up the vma and find out, but since you are
> already checking the permissions, maybe you can find a way to also
> convey the new permission bits?
> 
> that would make our life on s390 easier :)

Right, getting the new bits from vma->flags should be trivially done
from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users in
this series though. The rest of architectures still need the notifier to
tell them if the change is an upgrade, since they don't have an easy way
to grab the old RWX bits. Passing the old RWX bits from the MMU notifier
does not seem trivial to me either.

So what I can do is to plumb down the event and flags into KVM, and
leave it open for you to come back and forward the permission bits you
need via the range flags, if the MM maintainers are okay with it.

However, I tried to understand the s390 code better with AI, and it
seems to think that skipping the zap is also safe there (and an
improvement). It could be further optimized by passing down the new W
bit to eagerly fix the gmap when restoring write permissions.

>>
>> Benchmarks
>> ==========
>>
>> AMD EPYC 9654 96-Core Processor host running a recent Linux kernel
>> (6b4b543fa187), with a 64GB, 64-vCPU guest running stress-ng --vm while
>> the host takes a QEMU background snapshot. All results are aggregated
>> over 5 runs, and compared between the stock kernel and one with this
>> patch series. Guest is rebooted across each individual run, and NUMA
>> balancing is disabled.
>>
>> pf/s and tlb/s (per-second deltas of KVM's pf_taken and remote_tlb_flush
>> debugfs stats) clearly improve:
>>
>>   guest pattern          baseline                    patched
>>   -----------------------------------------------------------------------
>>   read64   (read)        pf/s=950,015   tlb/s=1,440  pf/s=2,503 tlb/s=0.1
>>   rand-set (read+write)  pf/s=1,004,353 tlb/s=862    pf/s=4,073 tlb/s=0.3
>>   write64  (write)       pf/s=968,018   tlb/s=94     pf/s=2,292 tlb/s=0.3
>>
>> Guest read latency was sampled with a paced probe thread in the
>> guest, reading one byte per page with an idle gap between reads, while
>> stress-ng ran with read64. Each figure is the median across 5 runs, with
>> the run-to-run min and max, in ns:
>>
>>   metric           baseline             patched
>>   ------------------------------------------------------
>>   p50 (min max)      340     (270 380)   260   (250 260)
>>   p99 (min max)    19789 (16885 20200)  5207 (4076 5638)
>>   p99.9 (min max)  23445 (22845 24036)  6850 (6259 7110)
>>
>> The median improves modestly and the refault cost shows in the tail,
>> where p99 drops ~3.8x.
>>
>> A separate stress-ng run with write64 and --verify showed no data
>> corruption and no livelocks.
>>
>> References
>> ==========
>>
>> [1] https://lore.kernel.org/linux-mm/cover.1eca029b8603ef4eebe5b41eae51facfc5920c41.1690292440.git-series.apopple@nvidia.com/
>> [2] https://lore.kernel.org/linux-mm/ZGu1vsbscdO48V6h@google.com/
>> [3] https://lpc.events/event/20/contributions/2552/
>> [4] https://lore.kernel.org/all/20240801183453.57199-1-seanjc@google.com
>> [5] https://lore.kernel.org/all/20231110003734.1014084-1-jackyli@google.com
>>
>> Carlos López (4):
>>   mm/mprotect: add MM_CP_PERM_UPGRADE
>>   mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE
>>   KVM: plumb MMU_NOTIFIER_RANGE_PERM_UPGRADE into kvm_gfn_range
>>   KVM: x86/mmu: don't zap the secondary MMU on permission upgrade
>>
>>  arch/x86/kvm/mmu/mmu.c       |  7 +++++++
>>  include/linux/kvm_host.h     |  1 +
>>  include/linux/mm.h           |  8 ++++++++
>>  include/linux/mmu_notifier.h |  5 +++++
>>  mm/hugetlb.c                 |  6 +++++-
>>  mm/mprotect.c                | 20 +++++++++++++++++++-
>>  virt/kvm/kvm_main.c          |  4 ++++
>>  7 files changed, 49 insertions(+), 2 deletions(-)
>>
> 


