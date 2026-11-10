Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C3E606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sar0iEFI
Received: by kanga.kvack.org (Postfix)
	id 2BC226B00EF; Tue, 10 Nov 2026 07:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D276B05B0; Tue, 10 Nov 2026 07:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135EE6B05B1; Tue, 10 Nov 2026 07:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D99CD6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:24:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 614CFC0602
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:24:21 +0000 (UTC)
X-FDA: 85419127122.09.AFD018F
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6E6280005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:24:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sar0iEFI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFsoXKUNoLIzCNi3+20fsHsU6snYYd20/d5yBhH4GW8=;
	b=GiRwxeWW0Y8GEU+GWlabrz5p9DeGAkWwQzJuXJF4UFZersAsNKSyBNwALcl6sdhNzEqvbA
	JJLBa2eExaQsSjOBwfh1S1/c6P2I23rzyUWitxOTI8x5zAg4hdc/9wBWFjR1JLnHVlUiyq
	5poMabE5PNMpIgy88pz/5H3bOwdLjiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313459;
	b=pE2XNhB7Kp1fFep7Ohv2XzVi8AU2A4tcZOFEy4jMveLK9XizEDBr87Nybpdta941rgzRZw
	jgkNfdAhnaSz9mk0hDOcwG2ietgbxN9id7C4M64Uuo+zr0n+2PQWdw1nklWfYZJBRLScVa
	if9QNejHt6UB0spfDoxDapAdZ/2Ou2M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sar0iEFI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wFsoXKUNoLIzCNi3+20fsHsU6snYYd20/d5yBhH4GW8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794313456; v=1; x=1794918256;
 b=Sar0iEFIZqsHzAtdjYGPNuyCRqFvqIn2it3z7bH+l9BjOjkW5+PCyUCWdOQ6csq00St53S39
 Kc1xwHCdzpVEL83DXwulcKTOtjTq/EMG7s7QXSsKXZFKPUa7s4xdY5oaymQ/l27MYTYsx9Je8vo
 QQJojvuvq7NDVna7e94mTiSg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8278f7709b2dd07a;
	Tue, 10 Nov 2026 12:24:16 +0000
X-Mizu-Trace-ID: 8278f7709b2dd07a
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 20:24:04 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: n3rd <18670333770@163.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	samarth.colleges@gmail.com,
	"security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] mm/ksm: replace_page() drops the uffd-wp/rwp PTE bit
Message-ID: <avMM5DqYIGo9z1u1@dgvxl46587.localhost.localdomain>
References: <276f8d85.bbe71.1a1c549b771.Coremail.18670333770@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <276f8d85.bbe71.1a1c549b771.Coremail.18670333770@163.com>
X-Stat-Signature: 885payibe5p9z6z644b9njx5mfur1t3i
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6E6280005
X-HE-Tag: 1794313458-34163
X-HE-Meta: U2FsdGVkX1+S8kbxb8v5ySS211dOIUkuJMKkwcF0FOOu3Z84cEw+MIQ8mis28fZYNnJnp5EP4eje8LYxzHj91TDfzeCcFO6qK8x9AxLx2tIOJB+uCw481894b+V7RQcpTJbybHcVTtL7SAaDzSeNlYq6/5maKAScHbLaJpADLw9gMd4moU4ac4ZekbHVvRdtv/ngjsM5qLxkYUm7/87M3gq05TAKumtvUVu+BvyzWWbhSXUYAlskYIn3VrM2lvUuWBuzkdr+hooFz4NiV68Cmp7thkzrU+Do9m/4faWFYvtZJx4grnpm7+egNGAnLK4DCD1H38eLqQOPqDnc5xVOyFyMoj4MYQ6OQKj4vzKtbTZSld+546bjaTc9w16hEzzo9kn3YcUmi38pGhiOq/PFVn8T2oXkGfzmTMuui/o8q8fIDLm62DF+/nhib12C8NxIZvi87/9akKjUan1lBPjDSkSqbh3qLbV2k4x27yR1WacfqAq61/cK8AQ8uj0u/CNle5hcnQAtxC5en3RDLNzCLFNsdHq7iKDLaBliwRDXQvYZlovumDi9kwJRLgHTqLEmSXgnPQ+HW9fpVkhH4Oyj2w+QYyohr0NxfYxHUzPb9mA+n06B7xB1CfwK64Dk1Bhs3+UfW2zpYMVuNstSaK25A/CB7K3ljjNIcU8MDjtOCQWctHwuloeo+XNSFgUEO8/ZLv3HtYe7CzlRxBJLVJtiTBYiDHb2lYMdMFbjww+pDnRMmLVzN/5EePk5Cnopyb3W9qSzMtQpus+GKDu0BE69leGoIKa9fbQG1MzXze0F//iUdwLEcB/qGpDer7z1RBKJPRXX4iLYNO/nU3xl4LobpxMT4amqMKHxXNaK4J2GvZjZeVNEfAJQ7HT6ky6qRX3/4xIIuTuMsw4rLU2jo9jvM8YAxrAia//8jWWJhoqx0skzXwJcZDXuse92T99hjNU5YsT8eNACYqmawyvBbSe
 d439qqKu
 FN02F+zg2bJ9+xfVvujLdAQm24vMWqOfXtBOqvEFBdHXrwAVCYQfRbXeh7/LCnRl5GtKWyakjgkjnZK5qpPorimMhlug/jhykXxJ9cTL4/9g7UFeNGT/KtowCfs260ULakzLoYBi6gx33/KP1EDo/wKiuMH37OThv/8c/r0/3gyRI/mTfuo4YUSFu2587fJchk92LI6PdnRq6S2MSFk6ibZt+biR/vllJfEcAwjP997aNQ8qnykSeROwUWZUIkyGF01QrHR64BG6DYFpwz6TGfAmDm/59ZVrDMUrVZlLJJMzj3mzkJqAz9Uy1uIkjbk2pqWh3VOtiMvZTtzL4IL574vBPcroYRM0K6TBPUMEWYg6A/B4wFirKbf040kiwurNM++COjeAuQZseb345P4daaDbW99nR0YjixkDFUEuWMXT/WRr8+wrm60fpGcdBuczdwLI1tZ2cpm8dIAyQjToqyJ3IyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:48:25PM +0800, n3rd wrote:
> Hello,
>=20
>=20
> I am reporting a security bug in the Linux kernel.

Repeat report: https://lore.kernel.org/all/20261020110758.960048-1-shawnq1@=
163.com/


We're wating for the final fix v3: https://lore.kernel.org/all/CAAbz3fTjWnZ=
mHaWT+zsycEvnEM-ZYXH0jG_XoV+yidYUquutVg@mail.gmail.com/

>=20
>=20
> 1. Affected kernel versions
> Linux v7.3-rc7 (mainline, built and tested as 7.3.0-rc7) is affected and =
was reproduced on two fresh boots. The same statement is byte-identical in =
the mm/ksm.c of v7.2.9 and v7.3-rc6 according to the static comparison reco=
rds of the workspace that produced this report, so both are affected as wel=
l; earlier releases were not compared one by one. There is no upstream fix =
as of v7.3-rc7 and no CVE has been assigned. Note that CONFIG_KSM is not pa=
rt of x86_64_defconfig, so the test kernel was built with CONFIG_KSM=3Dy ad=
ded explicitly by the preset in the reproducer bundle.
>=20
>=20
> 2. Problem description
> replace_page() in mm/ksm.c rebuilds the target PTE from scratch when KSM =
merges a page: newpte =3D mk_pte(kpage, vma->vm_page_prot), followed by set=
_pte_at(). mk_pte() only consults vma->vm_page_prot, which for a private an=
onymous VMA is PAGE_COPY, so the uffd enforcement state of the PTE being re=
placed is lost. For MODE_WP the _PAGE_UFFD_WP bit set by pte_mkuffd() disap=
pears, and for MODE_RWP both the protnone state and the uffd bit disappear.=
 mm/ksm.c contains no reference to uffd at all, and none of the guards excl=
ude a uffd armed VMA: ksm_compatible() only rejects VM_SHARED, VM_MAYSHARE,=
 VM_HUGETLB, VM_DROPPABLE, DAX and VMA_SPECIAL_FLAGS, and that mask is only=
 VMA_IO, VMA_DONTEXPAND, VMA_PFNMAP and VMA_MIXEDMAP, with no uffd flag in =
it; the reverse check vma_can_userfault() does not reject VM_MERGEABLE eith=
er; the KSM scanner only skips !pte_present(), and on x86 pte_present() ret=
urns true for _PAGE_PROTNONE, so uffd-rwp armed pages are scanned like any =
other; and write_protect_page() only calls pte_mkclean() and pte_wrprotect(=
), so the stable tree anchor twin keeps its armed PTE. The observable effec=
t is a selective, silent disarm. The page that went through replace_page() =
takes a normal copy-on-write fault on write in the WP case and reads straig=
ht through in the RWP case, in both cases with zero uffd events, while the =
anchor twin in the very same VMA and the very same uffd context still deliv=
ers UFFD_EVENT_PAGEFAULT. A monitor therefore cannot distinguish no access =
=66rom enforcement having been removed, and there is no global failure sign=
al. The practical impact is that QEMU live migration dirty page tracking si=
lently loses writes on the disarmed pages, so the migrated guest can end up=
 inconsistent; incremental checkpointing and in-process write watchdogs hav=
e the same problem. This is a policy and enforcement bypass only: there is =
no memory corruption, no out-of-bounds access, no use-after-free and no pri=
vilege escalation primitive, and KASAN stayed silent across both rounds. Ev=
ery other path in the same kernel that rewrites a PTE does preserve the bit=
, for example the fork PTE-copy helper in mm/memory.c, the fault paths, mig=
ration in mm/migrate.c, swapin in mm/swapfile.c, hugetlb, mremap and UFFDIO=
_MOVE; mm/ksm.c is the outlier.
>=20
>=20
> 3. Reproducer
> A single statically linked C program, mm05, with its source next to it, r=
uns as root inside a QEMU guest. It maps two three page anonymous VMAs: wp_=
area is registered with UFFDIO_REGISTER_MODE_WP and armed with UFFDIO_WRITE=
PROTECT, rwp_area is registered with MODE_RWP and armed with UFFDIO_RWPROTE=
CT. Pages 0 and 1 of each VMA hold identical content so ksmd can merge them=
, and page 2 holds unique content and serves as an in-VMA enforcement contr=
ol. The control page is written and read first: the write is blocked with a=
 PAGEFAULT carrying flags 0x3 and the read faults with flags 0x8, printed a=
s JUDGE BASELINE with the verdict ARMED. MADV_MERGEABLE is then called on b=
oth armed VMAs and returns 0, ksmd is enabled, and pagemap bit 57 (PM_UFFD_=
WP) is read for all four merge pages, all 1. ksmd merges within one second:=
 pages_shared goes from 0 to 2 and pages_sharing is 2. After the merge exac=
tly one page of each pair has bit 57 cleared while the other keeps it, and =
the roles are derived from that bit rather than assumed. Writing the cleare=
d WP page and reading the cleared RWP page both complete instantly with zer=
o uffd events, while the same operations on the retained anchor page in the=
 same VMA still deliver events; the program prints JUDGE KSM-WP with BUG-C =
CONFIRMED and JUDGE KSM-RWP with BUG-D CONFIRMED. Because replace_page() is=
 inlined into try_to_merge_one_page() there is no replace_page symbol in Sy=
stem.map and a kprobe on it is rejected with Invalid argument, so kprobes a=
re placed on try_to_merge_one_page and write_protect_page instead; they fir=
e four times each during the round and the trace lines show the ksmd thread=
 executing that merge path. The complete reproducer and the raw console log=
s are available on request; I am not posting them publicly.
>=20
>=20
> 4. Conditions
> The target VMA must already be registered and armed with UFFDIO_REGISTER_=
MODE_WP plus UFFDIO_WRITEPROTECT, or with UFFDIO_REGISTER_MODE_RWP plus UFF=
DIO_RWPROTECT. ksmd must be running on the host, which is a deployment deci=
sion the attacker cannot make alone. A page with identical content must exi=
st to pair with, which guest RAM zero pages and template pages provide natu=
rally. Triggering needs only MADV_MERGEABLE plus one ksmd scan period, so t=
he sequence is deterministic and has no race window, and it does not depend=
 on THP, SLUB layout or kernel randomisation. No capability is required on =
the attacker side: madvise(2) only acts on the caller's own mm, and althoug=
h userfaultfd(2) needs root or CAP_SYS_PTRACE unless vm.unprivileged_userfa=
ultfd is 1, the monitor in this threat model is the uffd holder itself, so =
the attacker never needs uffd access. The attacker is the monitored process=
 itself and the victim is the uffd manager. Tested on x86_64 with QEMU 6.2.=
0 in TCG mode, two vCPUs, 4096 MB of RAM and an initramfs, with CONFIG_KSM,=
 CONFIG_USERFAULTFD, CONFIG_USERFAULTFD_RWP and CONFIG_PTE_MARKER_UFFD_WP e=
nabled and KASAN on as a control.
>=20
>=20
> 5. Suspected location
> mm/ksm.c: replace_page(), specifically the newpte =3D mk_pte(kpage, vma->=
vm_page_prot) assignment and the following set_pte_at(). Supporting gaps: k=
sm_compatible() does not reject a uffd armed VMA, the scanner ksm_next_page=
_pmd_entry() only filters !pte_present(), get_mergeable_page() uses folio_w=
alk with the same pte_present() gate, and write_protect_page() only mkclean=
/wrprotects so the anchor keeps the bit. The reverse gate is vma_can_userfa=
ult() in mm/userfaultfd.c, which does not reject VM_MERGEABLE. Paths that d=
o preserve the bit and can serve as templates: the fork PTE-copy helper in =
mm/memory.c, the fault paths in the same file, mm/migrate.c, mm/swapfile.c,=
 mm/hugetlb.c, mm/mremap.c and UFFDIO_MOVE in mm/userfaultfd.c.
>=20
>=20
> 6. Suggested fix
> In replace_page(), after newpte is built, mirror the other PTE rewriting =
paths: if the VMA is VM_UFFD_WP and the source PTE carries the uffd bit, ap=
ply pte_mkuffd() to newpte; if the VMA is VM_UFFD_RWP and the source PTE ca=
rries the uffd bit, restore PAGE_NONE and apply pte_mkuffd() as well. Templ=
ates to copy are the fork PTE-copy helper in mm/memory.c, the migration pat=
h in mm/migrate.c, the swapin path in mm/swapfile.c and the hugetlb path in=
 mm/hugetlb.c. A more conservative alternative is to make ksm_compatible() =
refuse a VMA that userfaultfd has registered or armed, at the cost of losin=
g deduplication for those VMAs.
>=20
>=20
> 7. Mitigation
> Monitors should not rely on events alone: re-arm the range with UFFDIO_WR=
ITEPROTECT or UFFDIO_RWPROTECT periodically and cross-check pagemap bit 57 =
(PM_UFFD_WP), re-arming and warning when an armed page loses the bit withou=
t the monitor clearing it. For QEMU and KVM, memory merging can be turned o=
ff (-machine memory-merge=3Doff, or host /sys/kernel/mm/ksm/run set to 0) a=
t the cost of losing memory overcommit. Applications should avoid MADV_MERG=
EABLE on a range registered with userfaultfd, or keep deduplication on sepa=
rate, unregistered ranges.
>=20
>=20
> 8. Disclosure
> Public. This report is sent to the public linux-mm list and LKML and no e=
mbargo is requested. The reproducer is not posted publicly; it is available=
 on request.
>=20
>=20
> 9. AI-assistance note
> This report was prepared with the help of an AI coding assistant, which w=
as used for the source review, for building and running the test kernel, an=
d for drafting this text. Per the kernel security process I treat the issue=
 as public and I am not posting the reproducer publicly.
>=20

