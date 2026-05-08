Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28ECCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A556B0114; Fri,  8 May 2026 04:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1716C6B0116; Fri,  8 May 2026 04:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060886B0117; Fri,  8 May 2026 04:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E74DF6B0114
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:18:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89A5EA077F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:18:41 +0000 (UTC)
X-FDA: 84743551242.03.CDA36B9
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F9CB40002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:18:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=S984vw6T;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=5810c6ac2=itazur@amazon.co.uk" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=5810c6ac2=itazur@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778228319; a=rsa-sha256;
	cv=none;
	b=VVb64CMcXcgYln7AWBmxS4eaM41Pbp1xARejnbB4XPLqfMQnh/fsgn2nCCCqRlwUVgG3G3
	IX3nJSHBrJ8QlbLDRfSRk2GwEU1CsvZamWkUO/Md38wqNTK6sPr+DqU1wbdggP1831J+rt
	f0C+QJf42OntQJX3vauCgWaNHrZ4FcQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=S984vw6T;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=5810c6ac2=itazur@amazon.co.uk" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=5810c6ac2=itazur@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778228319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=he6DON9jfdhSLBt5e/vXn3CElWPL4k8qbH0NcK/2obw=;
	b=2ep8konoby2cW3+gO5b1tB98GWeNoHFOOEvAICcZaxd0SQfDveaOf6dm2r09Frp6S2r9A9
	GmNQhXf8govBjYjwU8z7r8aDZceIHr37QNS2u3YqY0Pmr3uDktho3324qRKupD1ml2PofT
	nwWKjUAbxF3WdeCLRyjyRCoZcB1UUxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1778228319; x=1809764319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=he6DON9jfdhSLBt5e/vXn3CElWPL4k8qbH0NcK/2obw=;
  b=S984vw6TQNKKVthIMJYM/1Bp4dXsMxb83StozGmgRFLd5ICKwmjGz5HB
   7jLumYMBG1YouSd8jsiLqJzCh5X7pYcNPeJ+USndQj+6rOIbW9AFTpgnG
   LRU24Ah3fV9lSS1kFeNhQh7+4AT9KPBIB2SwBZjxsrhOhBZpi7On9wcUR
   HmaJGaHK2VK7ouzYbeMrgd+iketzu9KtyNEgNUe0HI/00XoyjnfftXiM7
   Cd5IJZGxz0vLdHDTHcwL0wLIE9XhA/u6bVabFr04wFFCEGqRODxqUxOwx
   naXZBVvP+Ybcp0R4s564X+C6BZfvMD71zcSzFB+P33m+2XYRU1aO85wNb
   A==;
X-CSE-ConnectionGUID: T2XNpIqvShm0IOn66vQpwQ==
X-CSE-MsgGUID: K+8ujvsvQ+aWk2f8+1q5Sw==
X-IronPort-AV: E=Sophos;i="6.23,223,1770595200"; 
   d="scan'208";a="18948631"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 08:18:34 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:1235]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.77:2525] with esmtp (Farcaster)
 id 181a188e-b1e1-456f-b102-a9f2c8f54015; Fri, 8 May 2026 08:18:34 +0000 (UTC)
X-Farcaster-Flow-ID: 181a188e-b1e1-456f-b102-a9f2c8f54015
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 8 May 2026 08:18:31 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 8 May 2026 08:18:18 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <fvdl@google.com>, <seanjc@google.com>, <ljs@kernel.org>
CC: <Liam.Howlett@oracle.com>, <ackerleytng@google.com>,
	<agordeev@linux.ibm.com>, <ajones@ventanamicro.com>,
	<akpm@linux-foundation.org>, <alex@ghiti.fr>, <andrii@kernel.org>,
	<aou@eecs.berkeley.edu>, <ast@kernel.org>, <baolu.lu@linux.intel.com>,
	<borntraeger@linux.ibm.com>, <bp@alien8.de>, <bpf@vger.kernel.org>,
	<catalin.marinas@arm.com>, <chenhuacai@kernel.org>, <corbet@lwn.net>,
	<coxu@redhat.com>, <daniel@iogearbox.net>, <dave.hansen@linux.intel.com>,
	<david@kernel.org>, <derekmn@amazon.com>, <dev.jain@arm.com>,
	<eddyz87@gmail.com>, <gerald.schaefer@linux.ibm.com>, <gor@linux.ibm.com>,
	<haoluo@google.com>, <hca@linux.ibm.com>, <hpa@zytor.com>,
	<itazur@amazon.co.uk>, <jackabt@amazon.co.uk>, <jackmanb@google.com>,
	<jannh@google.com>, <jgg@ziepe.ca>, <jgross@suse.com>, <jhubbard@nvidia.com>,
	<jiayuan.chen@shopee.com>, <jmattson@google.com>, <joey.gouly@arm.com>,
	<john.fastabend@gmail.com>, <jolsa@kernel.org>, <jthoughton@google.com>,
	<kalyazin@amazon.co.uk>, <kas@kernel.org>, <kernel@xen0n.name>,
	<kpsingh@kernel.org>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<lenb@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <lorenzo.stoakes@oracle.com>, <luto@kernel.org>,
	<maobibo@loongson.cn>, <martin.lau@linux.dev>, <maz@kernel.org>,
	<mhocko@suse.com>, <mingo@redhat.com>, <mlevitsk@redhat.com>,
	<nikita.kalyazin@linux.dev>, <oupton@kernel.org>, <palmer@dabbelt.com>,
	<patrick.roy@linux.dev>, <pavel@kernel.org>, <pbonzini@redhat.com>,
	<peterx@redhat.com>, <peterz@infradead.org>, <pfalcato@suse.de>,
	<pjw@kernel.org>, <prsampat@amd.com>, <rafael@kernel.org>,
	<riel@surriel.com>, <rppt@kernel.org>, <ryan.roberts@arm.com>,
	<sdf@fomichev.me>, <shijie@os.amperecomputing.com>,
	<skhan@linuxfoundation.org>, <song@kernel.org>, <surenb@google.com>,
	<suzuki.poulose@arm.com>, <svens@linux.ibm.com>, <tabba@google.com>,
	<tglx@kernel.org>, <thuth@redhat.com>, <urezki@gmail.com>,
	<vannapurve@google.com>, <vbabka@kernel.org>, <will@kernel.org>,
	<willy@infradead.org>, <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
	<yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
	<yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
	<yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>, <zulinx86@gmai.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from direct map
Date: Fri, 8 May 2026 08:18:10 +0000
Message-ID: <20260508081812.12345-1-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.19.66.53]
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 5tmuftmnaf3rea157u5swdbx8944h7za
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F9CB40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778228319-360972
X-HE-Meta: U2FsdGVkX1/uaP/JQm/uNdUnscL3N7Iswz3WxO7ECFTABeE96vcAlVBcoW2KJo6ajlk5H7a6YDBY9NN2CIAsMxcs9YIL6kcnIvbbyftvkkQC6Cbi8Kh/6NbspDd8MlrlOIw6FMBTuPLt8xw5g303fIcuYqGc1XzxOPDP6AWRX/GdNr5NrwMgVjhytjz4T8RdhLUr79DxVXfrj1D7RXfgIG0WJJfLsx0w/us7B3AGUMztm8WCNUZRlvAbsNNm1pXX9YSMa3VdbcL6n7dqPMcUNZVfayeJY2AvlKcgV12QU5tDDNbE/3YfXQ9k1kJoQDpl5u4sS3SX1pMn01qPy8/25FOgAZOQnFLWsDgK0GJe16Q3IRLTyFx9QTOEBP1hHVSyQOgLkDZvyt8f7Wk8wK97FcUY6sxavde8KLfD+ebOOP/CFkmU8qDl/0oxRnNE7HAZWUzBnSIkDZfATaJQtb8T/s+uW8fIH4QyyWlv3R3bTjzqKKwuXNQUFXAXf6+lUcTnBiAEXrUwlcAf5oZmojR5eHULbyHHTT615aNicJkqWhtnZbwBpBbxRCCd5MAshLXrCfpwhL6Hq8m+izGUb/TZvEoeqfZi6ctBwsxYQFHQd2ZcvUlMu5Hx7LDc/YPZISSrgAiA3MbpheXAtLAerYVbmGPLhdrXo55g75bONGlRoWQessiiMD4+ot5pXlxkISg+Nf8qJale98Imp5XxdePvQYh5hB+TNOJfyE0j7aXKiOhNiIvmnPr0y3A2unEFFTNI7U+iuCm06w2rn/JvCq3OR9tDbNEhDZdVndf0IBeYZALyyApZdsIAjxH65shCc1bJ+MyAaWaZApYaXwrOC2vS1OoPIw/OQXFsPGanWdVzBzAd4tPFm3eDTRo4e0tUFFDUunvtmkQEbS9pFtFh7liQO3zIXGJ07sS+17Y/yiqovzf4ZCXc83xyWxCurvmK6e5diIzL4o9MhAHrxBKOm91
 4TnPWEI6
 wtadXu3TXPfQUPt1DUaOeA9tbeXGzXwyxxuaNDD50/5+KSZsuhAGNT3qATSX3sHPmAa+SCelbNWLqDr0N+jAGxnpGkiepXXDQG6jevSviTJqrAJUgEAHrtN83U00tnHJCofk3PJXMKiiwzvx42ywXTD09DTmeiR1OD+dwr22rA/BSoOe6CseZrqyVHIGI5NrM1fUbjjZC8S3N/fBnX6PqoIvrXVRKLxk6xFUCzJmX7Jka1+X2HjSwagCiLk4RI8BvSJP4iXkwSYYgh4wLjSG8Wjz3UaIyXuTeNkbcwDYVBkZfJzIVg5vIRtRdws/DDlpND7nX5HPTG0bSTJ6yjtvKhSP7IbP93CBUaiBoQyXcEMuXVCwlwVqVNwSLO7tX57kC6yOHhN4UZJiDuXB4ZkcnempHKDEwFsJT77dKWwr9ijyiOme4/uXjzwxk3J3t+D9d9/lZWKTY3qRYa7cv+hL+hjsPYc/c0/IRQ22rlIPk99Gg3IPaapinp8F7LU+RpI8YuW61qR5v8cSacyeWo5SUE/gtJ8vBR7qx+iZVVEPfyyOheQda1BlTLcAWcza59X2oWPRn6TpnCQ8BA0xdvD+QOA4dN/CW6RTsfs8pIBFSLNuD+oES2ZZgqVUby8XUQuQ7vE92JTlCPMHziPW1SckIJE72CS/KpwQsaEHeqOTSYcRRQdWgWwW+lNPb7QJ7bFmCIU/p7lWe1KSe1lXaU9o0xC0aoN2HV3Fn4YNG/rmxG/LTNECK+z3AVUCzr4ZAbjpSIBMpn91q58JiF7UhuFDYFWZPyMfrNQRdm27yn9nlYEL59sn4NrvkYYuginweNfoTJi6K7yYuNd1K3Zp+0iQdM98n+bYmQG6SWbuy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean, Frank, Lorenzo,

On Tue, Apr 21, 2026 at 10:08:48AM -0700, Frank van der Linden wrote:
> On Tue, Apr 21, 2026 at 9:31 AM Sean Christopherson <seanjc@google.com> w=
rote:
> > Making guest_memfd responsible for zapping and restoring the direct map=
 on a per-
> > folio basis feels wrong given the addition of AS_NO_DIRECT_MAP.  I espe=
cially don't
> > like that the "rules" for when an AS_NO_DIRECT_MAP folio has a direct m=
ap will vary
> > based on the owner, and even within an owner (e.g. guest_memfd) will be=
 ad hoc.
> >
> > E.g. as per the series to add guest_memfd write() support[*]:
> >
> >   When direct map removal is implemented [2]
> >    - write() will not be allowed to access pages that have already
> >      been removed from direct map
> >    - on completion, write() will remove the populated pages from
> >      direct map
> >
> > That's pretty gross ABI, because with KVM_GMEM_FOLIO_NO_DIRECT_MAP, use=
rspace can
> > write() exactly once.  To re-write memory, I assume userspace would nee=
d to do a
> > PUNCH_HOLE or truncate.
> >
> > What's preventing us from handling this automagically in e.g. filemap_a=
dd_folio()
> > and filemap_remove_folio()?  Then the usage rules are pretty straightfo=
rward: the
> > kernel must *always* assume the direct map is invalid for folios from
> > AS_NO_DIRECT_MAP mappings.
> >
> > Then if KVM needs to utilize a kernel mapping, e.g. in kvm_gmem_populat=
e(), KVM
> > could use dedicated variants of kmap_local_xxx() to deal with a local m=
apping for
> > a folio/page without a direct map.  Or, KVM could simply disallow the s=
pecific
> > sequence that would require KVM to do the memcpy (I'm pretty sure we ca=
n do that
> > with in-place shared=3D>private conversion support).
> >
> > I realize that could throw a big wrench into write() performance, but I=
MO, before
> > merging either series, we need a complete story for exactly how this wi=
ll all fit
> > together, in a maintainable fashion and with sane ABI.
>
> I agree with this - this approach would also allow for memory that was
> never in the direct map to begin with, or has been taken out already
> (for which I happen to have a use case :-)). guest_memfd and other
> code can then assume that AS_NO_DIRECT_MAP means they have to take
> explicit action to map it if needed. It's a clean, simple ABI.
>
> With the current set of patches, it seems like this couldn't be done
> in a clean manner.

Agreed with both of you.  I'll adopt the filemap-level approach:

- Move the zap/restore hooks from guest_memfd into filemap_add_folio()
  / filemap_remove_folio().
- Tighten AS_NO_DIRECT_MAP semantics so that, for folios in such a
  mapping, the direct map is invalid for the entire time the folio
  resides in the page cache.
- Drop the per-folio KVM_GMEM_FOLIO_NO_DIRECT_MAP bookkeeping in
  folio->private, since the existence of the folio in the mapping is
  itself the state.

On each guest memory population path,

- memcpy-based population from userspace goes through the userspace
  mapping of guest_memfd, not through the kernel direct map, so the
  filemap-level invariant doesn't affect it.  But this is slow, which
  is what motivated the write() syscall support.

- write(): meant to speed up the userspace-memcpy case above by doing
  the copy in the kernel.  I believe Brendan's __GFP_UNMAPPED/mermap
  work [1] would give us a low-overhead way to get temporary kernel
  access to an AS_NO_DIRECT_MAP.  Landing mermap may take a while, but
  this series does not introduce the write() path, so mermap is not a
  blocker for now.

- kvm_gmem_populate(): this is a TDX/SNP-only path, and NO_DIRECT_MAP
  is not available on those VM types =E2=80=94
  kvm_arch_gmem_supports_no_direct_map() returns false for
  KVM_X86_TDX_VM and KVM_X86_SNP_VM, which are its only callers
  today.  So it doesn't interact with the filemap invariant IIUC.

So, unless I'm missing any path, adopting the filemap-level approach in
this series should be fine.


I'd like to consult with you folks on how to proceed in advance.  In a
separate reply on the cover letter thread [2], Lorenzo and Sean
suggested that the mm pieces should go through the mm subsystem:

On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
> Yeah, when the time comes, the mm pieces definitely need to go through th=
e mm
> tree.  Ideally, I think this would be merged in two separate parts, with =
all mm
> changes going through the mm tree, and then the KVM changes through the K=
VM tree
> using a stable topic branch/tag from Andrew.

I see two reasonable paths to get there, and would appreciate your
input on which you prefer:

Path A =E2=80=94 validate on KVM side first, then split:
  - Post v13 as a single series on the KVM list, gather feedback and
    make sure the design is acceptable to KVM reviewers.
  - Once v13 looks good ("the time comes"), do the MM/KVM split,
    rebase the MM part onto the appropriate MM branch, and post the
    MM part to linux-mm to build consensus with MM maintainers.

Path B =E2=80=94 split early and seek MM consensus in parallel:
  - With the filemap rework already in place, do the MM/KVM split
    now and post the MM part to linux-mm directly.  The KVM part follows
    on top of a stable topic from MM.

Which of the two would you rather see?  Happy to go either way.


[1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54=
f41@google.com/
[2] https://lore.kernel.org/all/20260506080753.14517-1-itazur@amazon.com/

Takahiro


