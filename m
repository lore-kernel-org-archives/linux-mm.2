Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 039DDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9136B00B5; Fri,  3 Jul 2026 13:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A256B00B6; Fri,  3 Jul 2026 13:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59256B00B7; Fri,  3 Jul 2026 13:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 753E76B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:25:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5D558C6BB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:25:29 +0000 (UTC)
X-FDA: 84948141978.01.F3D6E81
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id CAA81C0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:25:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYznoPqW;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783099528;
	b=hXWxrYurdCO/VIaA+VSVnpnOECZQVNlUuLl+V0hzh/8AJ8UZxxn4hDrjwLpMazl2Zq97UD
	5BzI87DSYasccTQCLZB+HN7NLNfnht1j0qT3mz8DD0HpKBxoXeD2f6EKBq0ppMR6zEhGan
	u5MIh7Lk7KaaqgUD9sQUgfPD/+2DrY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783099528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c+BwctnAiSkjgibvob0C2umzrsPqTSL2zXU9guYRPk=;
	b=Z/UXbpa7IkN+IwIiY55LvntXUSjEDIvHbwuhRh1KONNan70dF39hXG/p9pYKfhqMacI1oR
	D279h/s9L5GFtSpYv4K+I5On/Od/WOtltvKZUHNQ/GvE/SUb5Z+lphVZiaeUO8yqG1ec3n
	O9h3TKnaTGrLVlMJbAExG/siadlK3XM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYznoPqW;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783099524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7c+BwctnAiSkjgibvob0C2umzrsPqTSL2zXU9guYRPk=;
	b=CYznoPqWdw0CRsvPl73Fdj0quuNiWfoS4JfqFJ8fAPK90vSYLkfVpgEBGUyoXtSrRmUOfM
	PFI0eHoTNJ9dqTa0opR59Ik5IVneaa0i+/XuadEdB2jZAf8ArNMschfFSp5BxC2kpe4dUZ
	gPH2E663vmIM348sp9LwngXeXSuIzPA=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 17:25:05 +0000
Message-Id: <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Ackerley Tng" <ackerleytng@google.com>, "Takahiro Itazuri"
 <itazur@amazon.com>, <fvdl@google.com>, <seanjc@google.com>,
 <ljs@kernel.org>
Cc: <Liam.Howlett@oracle.com>, <agordeev@linux.ibm.com>,
 <ajones@ventanamicro.com>, <akpm@linux-foundation.org>, <alex@ghiti.fr>,
 <andrii@kernel.org>, <aou@eecs.berkeley.edu>, <ast@kernel.org>,
 <baolu.lu@linux.intel.com>, <bp@alien8.de>, <chenhuacai@kernel.org>,
 <corbet@lwn.net>, <coxu@redhat.com>, <daniel@iogearbox.net>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <derekmn@amazon.com>,
 <dev.jain@arm.com>, <eddyz87@gmail.com>, <gerald.schaefer@linux.ibm.com>,
 <gor@linux.ibm.com>, <haoluo@google.com>, <hca@linux.ibm.com>,
 <hpa@zytor.com>, <itazur@amazon.co.uk>, <jackabt@amazon.co.uk>,
 <jackmanb@google.com>, <jannh@google.com>, <jgg@ziepe.ca>,
 <jgross@suse.com>, <jhubbard@nvidia.com>, <jiayuan.chen@shopee.com>,
 <jmattson@google.com>, <joey.gouly@arm.com>, <john.fastabend@gmail.com>,
 <jolsa@kernel.org>, <jthoughton@google.com>, <kpsingh@kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <lenb@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <maobibo@loongson.cn>,
 <martin.lau@linux.dev>, <maz@kernel.org>, <mhocko@suse.com>,
 <mingo@redhat.com>, <mlevitsk@redhat.com>, <nikita.kalyazin@linux.dev>,
 <oupton@kernel.org>, <palmer@dabbelt.com>, <patrick.roy@linux.dev>,
 <pavel@kernel.org>, <pbonzini@redhat.com>, <peterx@redhat.com>,
 <peterz@infradead.org>, <pfalcato@suse.de>, <pjw@kernel.org>,
 <prsampat@amd.com>, <rafael@kernel.org>, <riel@surriel.com>,
 <rppt@kernel.org>, <ryan.roberts@arm.com>, <sdf@fomichev.me>,
 <shijie@os.amperecomputing.com>, <skhan@linuxfoundation.org>,
 <song@kernel.org>, <surenb@google.com>, <suzuki.poulose@arm.com>,
 <svens@linux.ibm.com>, <tabba@google.com>, <tglx@kernel.org>,
 <thuth@redhat.com>, <urezki@gmail.com>, <vannapurve@google.com>,
 <vbabka@kernel.org>, <will@kernel.org>, <willy@infradead.org>,
 <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
 <yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
 <yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
 <yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>, <zulinx86@gmai.com>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com> <20260508081812.12345-1-itazur@amazon.com> <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
In-Reply-To: <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAA81C0003
X-Stat-Signature: 799h4d8haxw4bhyjhoj7yapjf5bfbft6
X-HE-Tag: 1783099527-419271
X-HE-Meta: U2FsdGVkX1++xSs7eQ65ngfBTUC31kmN2aFJg9zjUlLtVkmEG08U0Eq0DDoiMkivpvgKYtOjj95QwmO7HdgMYw3YKHBr56SYpwIjOlJfzxI721caUq/oJqgBmBkQNLPzX01aT3CiNEOPcnvFMUdPcGG6IR9haI9t465WeT4gRmqDNt0lzo2H2xN2rNDnGQrjT+Ew3evBxcp3F9JChXPqXbgA3GTJ3dg44eaUq8pcNLonOKTQHtWFmkPAMdzYdO9qSaaRw4FEWkoZj/HSJIVqJgh1VxFeVSDjAxVQWa+gNTYWSRx/5C7Bc0UuzhvMeYpNGAYwMR+ciUXUGKNR9aeLDvbhV53IHL/w2DF2zkHN4wzpOHVb/n2kxjByu2Ht9xMPwSyrzLiCZiFUbecV/NcH/TPe4FXjG3b6YrDUvOuA7bRUS+ISmrZlQ/dVsX5uGMucKWF0CBVPtPcwBlJ/sUWpjOvE1geB/ZuxWFkvTzbIybrYXr4xq47ppFz9o0xWRXqe4RL3oZ4kYAprq1bxZvL36h8/FVKnkFPtwsRPsIl5AQfPt7L//Bot+6nyyHfc+rM3mFq/e9H2EA+DSSuXie12bdL11gBwV7kcAWXfbcxTFam2QhH30bstCw70U3cZEqjzIumZYg8cTUziJlncNLHldjlEqf4wtRPI+RCxsKOe9f9/IPVt8bEsw8oBX33UwCGas6bs36FgY/h4TU3O3z9RJvyq2WkUkm6aGTd3Bx9IWLbsNyuZvhbN7EDUphy7SdCiwHRvuoRVejAYAz+uWhpqZYGm5PiTqfoBdMOccxPBTZ8r/hmP2PbIWkQGg9rmUlu9m0UEHqZwpIvOJ2FpdMVnHsXPmYWRwbUckBh4YYbGiOPb1U49c7Fc9JyG9ElBhy54L/LVoaIRmHkf2n1U9YCqV8i/56JQEdNuJzzTDbtx7c9zD8D7oXcWMB2KoEjyXyLAhE9KCwGCriCh1szqiDp
 cAY4jWas
 eE4ijMBVTKS8RucnSGzV2RJDtVm/8PAPn5AWfsbJSDSnlXrdQcRQ2wI6fkGeEtH+jY1K3uroB/9j+CffnGh59UT9OAMnzYRTGo/xJl/yZ4Gvl597Nym+pZJqlQw6lQ5Ef+ci1rGK9DnkeTeEmJ+1LVKvSH9wkhqrSjVm/UxT60NXULf816SGr+0Y55m3IQ9TngqzieTdGM7RFQWBQGXj/MxXGof+LXlRRzS0FjmXrETnBY3IgM9V9irkKSIyWwDmlER4v35tfBr7wBy6Ww0bYKoq+cTEuQIgrcv7/1HNsMTF1icBbsAOi3jRpU7rxABim1cia2tWFvfWz28jrckUGH6WQmQNYcL16SejkRHKvYWk2qUgm+gJTY+vtEzXRQLKKfkcr/wSWYJ1IR7ZW3dru4VssqTBKBn5SZh1OSrlt9zwjGRv3c6FeXWlbxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alright I think I'm finally getting a bit more up to speed on the
important questions here.

On Thu May 14, 2026 at 4:45 PM UTC, Ackerley Tng wrote:
> Takahiro Itazuri <itazur@amazon.com> writes:
>
>>
>> [...snip...]
>>
>
> Brought this topic up on the guest_memfd biweekly today!
>
>>
>> Agreed with both of you.  I'll adopt the filemap-level approach:
>>
>> - Move the zap/restore hooks from guest_memfd into filemap_add_folio()
>>   / filemap_remove_folio().
>> - Tighten AS_NO_DIRECT_MAP semantics so that, for folios in such a
>>   mapping, the direct map is invalid for the entire time the folio
>>   resides in the page cache.
>> - Drop the per-folio KVM_GMEM_FOLIO_NO_DIRECT_MAP bookkeeping in
>>   folio->private, since the existence of the folio in the mapping is
>>   itself the state.

Yeah so I protoyped this and I think it's fine.. except for zeroing.

>> On each guest memory population path,
>>
>> - memcpy-based population from userspace goes through the userspace
>>   mapping of guest_memfd, not through the kernel direct map, so the
>>   filemap-level invariant doesn't affect it.  But this is slow, which
>>   is what motivated the write() syscall support.
>>
>> - write(): meant to speed up the userspace-memcpy case above by doing
>>   the copy in the kernel.  I believe Brendan's __GFP_UNMAPPED/mermap
>>   work [1] would give us a low-overhead way to get temporary kernel
>>   access to an AS_NO_DIRECT_MAP.  Landing mermap may take a while, but
>>   this series does not introduce the write() path, so mermap is not a
>>   blocker for now.
>>
>> - kvm_gmem_populate(): this is a TDX/SNP-only path, and NO_DIRECT_MAP
>>   is not available on those VM types =E2=80=94
>>   kvm_arch_gmem_supports_no_direct_map() returns false for
>>   KVM_X86_TDX_VM and KVM_X86_SNP_VM, which are its only callers
>>   today.  So it doesn't interact with the filemap invariant IIUC.

There are also the fault paths though; if the pages are nonpresent in
the direct map for the duration of their life in the page cache (and I
think they should be) then by the time we get to
kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
ability to zero them.

My original answer for this was "that's fine, we'll use __GFP_ZERO
(which will probably use the mermap under the hood)", but now I've
realised there's a good reason we don't set __GFP_ZERO at the moment,
namely that it's wasted if we end up doing kvm_gmem_populate()

(Continued below...)

> I'm a little bit uncomfortable this statement since it seems to say TDX
> and SNP aren't taken care of. Would just like to discuss (for
> a line of sight to SNP and TDX support):

Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
would be doable but what's the value? So that we can get a #PF instead
of #MCE if we screw up?

> For non-in-place population where the source physical page is different
> from the destination physical page,
>
> + TDX: the TDX module does the population and works with physical
>   addresses, so no issue with populate? Other parts of TDX may have
>   trouble though, but that can be handled later.
> + SNP: sev_gmem_post_populate() does a memcpy() after using
>   kmap_local_page()
>
> Would mermap be a drop in replacement for kmap_local_page() here?=20

Yeah basically.

> Would guest_memfd need to force a TLB flush after mermap+memcpy?

It's not required for correctness, no (mermap does those flushes
internally). For security, I dunno, this comes back to my confusion
above about why we'd want NO_DIRECT_MAP for TDX at all, maybe best to
chat face-to-face about that and then follow up here with a summary.

=3D=3D=3D=3D=20

ANYWAY, here is how I would ultimately see all of this working, at least
for non-CoCo cases:

- AS_NO_DIRECT_MAP causes filemap.c to set ALLOC_UNMAPPED (that's what
  the next iteration of __GFP_UNMAPPED will be called) so you get pages
  directly from the page allocator that are already fully zapped.

- Where guest_memfd.c currently does clear_highpage(), it now isntead
  does something a bit like clear_page_mermap() from
  https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-20-28bf1bd54f=
41@google.com/

- The write() path does something similar with the mermap.

- Those mermap operations would leave behind stale TLB entries that
  could be exploited by the VMM for CPU vulns. To prevent that we need
  to force a TLB flush before freeing the physical pages they point to.
  Luckily now that all the folio allocations are pushed into
  mm/filemap.c we can just do that in kvm_gmem_free_folio(), preventing
  bugs like the one I had here (bottom of the mail):
  https://lore.kernel.org/all/DHH1NTVNTA8W.2313NYMA29J42@google.com/

Note there's no need for the page allocator to suport ALLOC_UNMAPPED
with __GFP_ZERO in this design, which is nice.

=3D=3D=3D=3D

NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
the parts we need, with dependencies indented:

0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
  1. AS_NO_DIRECT_MAP
    2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
      3. alloc_flags arg to the page allocator (I'm sneakily introducing th=
is
         in [1])
      4. freetype_t=20
  5. The mermap
    6. The mm-local region

I originally posted all of those in [0], except part 3. Doing all of
that together in one series would be a bit too much though. Approaches I
can see to avoid that:

Approach X:
- Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
  AS_NO_DIRECT_MAP would be secretmem.=20
- Then another series that fills in 0, 5 and 6.

Approach Y:
- One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
  implemented by having filemap.c itself call folio_zap_direct_map(),
  then guest_memfd.c zeroes it via the mermap. It works but it's really
  slow.
- Then another series that fills in parts 2 and 4, switches filemap.c
  over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
  things fast.

Approach X seems natural from a code progression perspective but leaves
us with an interim phase where we have a bunch of complexity just to
"optimise secretmem" which nobody cares about.

Approach Y seems natural from a feature progression perspective but
leaves us with an interim phase where we expensively zap a page, only to
then immediately do this complex mermap dance to access it right
afterwards.

Any thoughts / other ideas? Personally I think I prefer X.

[0] https://lore.kernel.org/all/DHH1NTVNTA8W.2313NYMA29J42@google.com/
[1] https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@go=
ogle.com/

Apologies for the Friday night essay :D

Brendan

