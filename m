Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031E8C98312
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 07:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089616B0089; Sat, 17 Jan 2026 02:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036DD6B008A; Sat, 17 Jan 2026 02:07:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26B76B008C; Sat, 17 Jan 2026 02:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD8716B0089
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65AF5D1BE1
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 07:07:46 +0000 (UTC)
X-FDA: 84340575732.22.73E9C7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id DA22C180003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 07:07:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PG0DyWOu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768633664; a=rsa-sha256;
	cv=none;
	b=xSP2AX92sCwnMpeLzvZoNs2yQ1F7MdZnxO7OEumR+yGoic9Q3q5YwXJzHDsgJ+D4xxKUgF
	uSuvKoIr/UfuaAyQcB+qKyM1GBB2j3HofMsmH59sgaxnrInCTTobUWfmmkxI7iv6wUC6/Q
	Ne5cYsjm4MCvJAEyCoMMBsZdW3AzMLE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PG0DyWOu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768633664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIt2PwqsDWxdbi0uupLOdJsyyNe4MNZYWjMMenWlZo0=;
	b=juDyhxX5jzdv/CJoBFKhke4VckdnVAEFp02sacAzj+svCFnlsqunYxTUUONKuOTCp7XFJ8
	/veeVYsSUsI9/8CrFVKPehjZ0Zn5A52wLH2+RlxLv8fkn/rpDmklG8R7HY8mwgYnjGsGe1
	0iHQXelLiT4jVndI9gINGf/LbkBrIe0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768633663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XIt2PwqsDWxdbi0uupLOdJsyyNe4MNZYWjMMenWlZo0=;
	b=PG0DyWOu/yM8aXIOiT+v3pxHZLpxw4pSOs+iNIp41WskvQbmnN+qU3iHz0qk0+2I4Th4GQ
	d8Tygw6GitJWNshKGaXmV1wgBDvpgc3mNjhn0yJC7S5sjeAqRR26bJaFWjbaUrgrinlf3L
	h8dfcvO+IXYUhYUqqwjgcPgJ9Kul1IY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-f4St6qoXNHKTH_Q8ZNEkVg-1; Sat, 17 Jan 2026 02:07:39 -0500
X-MC-Unique: f4St6qoXNHKTH_Q8ZNEkVg-1
X-Mimecast-MFC-AGG-ID: f4St6qoXNHKTH_Q8ZNEkVg_1768633658
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-382fbcb5077so14650911fa.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:07:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768633658; x=1769238458;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIt2PwqsDWxdbi0uupLOdJsyyNe4MNZYWjMMenWlZo0=;
        b=UJmugmQGMMGFfwwE4JNrUrdmiob0KlqypghdmaiGx3dcoWoLnZOR+c0ipsega7gCsQ
         itYjm3I28PSUsZRnfYxXPMxqQR72qFyLnyz8hPAgRvTYYvE2d40kGxEdXHyejGjsgEzO
         nOPEiku16wa+RCiGV806vvMDxj7bLqtMGgebLg+o4cqSceXrlCiSstoC7GwqaPOQ81Hm
         Uyg3MkspNJAy0K/f318JDv3gevwcmIlQxiEWNnu3HtKClh62aklFblJzDlylfo55OIVa
         RpqOqZ95IOgnEvc/GHvdNu1xi1QyKSGD3ffZbTThHixuJxzL/TyH1ufPNIETCS1Bmk3U
         uPfA==
X-Gm-Message-State: AOJu0Yyvnxzh7zut4RZEV0mAmDEHel1wfWExWPuOi4UJlyJiJXBEXmDe
	twSsw4nBwCxvNOe7cikduaJJ5rvI1TfvRK3jO3ag9WmWiIy947nV5VAcYlHte1DGB5dNO6ow9jS
	YUd7XEUxdKMpZfb8ocaLAI6DelEVAxvrbWtcWCdym0o47CNya2s0=
X-Gm-Gg: AY/fxX450h/AUPqelwZtKOi3G45kQbks9rFEsxwlr5F+1jXRwyRSUxp/sibxBbdjirz
	lZud1l6z3rVGcsOMriOYDBQFY7ArkvT89rwX+k5gFjU3ABoyxTN5RdPlBamwu0NKMlU39ZcknYj
	1HUB4rS9NlmKMdtVaVEgHSxK8L99O4UH2fc9CxUoCMzPJxsv9Zr22DNSG/7ijXxo5eKxbzCM+tM
	k06T9mgSo4BI3WmbxIYPsoRu5uv8Kmra1c70oScSVMQDtNH/CEfRJ9wlKPzPtDyxMoOJ1yTyUSh
	Xb86HHmf0DsJoLRI+IfHe0UQttJU+TuP+syAJSwXFxaofZj99bK3YdDatog2ZrZeUDgJd3dK5es
	E+sIbsaCfWt53cd+Zyiw3NTtBTiydt83Zqgw=
X-Received: by 2002:a2e:bc86:0:b0:37b:965e:c149 with SMTP id 38308e7fff4ca-383842a240emr14608431fa.24.1768633657637;
        Fri, 16 Jan 2026 23:07:37 -0800 (PST)
X-Received: by 2002:a2e:bc86:0:b0:37b:965e:c149 with SMTP id 38308e7fff4ca-383842a240emr14608341fa.24.1768633657057;
        Fri, 16 Jan 2026 23:07:37 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384e79042sm13608431fa.25.2026.01.16.23.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 23:07:36 -0800 (PST)
Message-ID: <d6324f13-7e03-4c95-bc4c-4fa0c1dd6334@redhat.com>
Date: Sat, 17 Jan 2026 09:07:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
 <20260114091923.3950465-2-mpenttil@redhat.com>
 <aWmdOMOYomnJrJWQ@lstrano-desk.jf.intel.com>
 <151ee03d-423b-4ac2-9dd4-11b1ceaadbaf@redhat.com>
 <aWqaBe+JVL3sz9bS@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aWqaBe+JVL3sz9bS@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MocJtqIQZ68tp9cdtbSoXd5HFn_YRIwovR6FQY4BZcU_1768633658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h1ch853fzzo1a1zd77hfdmrdijq8p7dz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA22C180003
X-HE-Tag: 1768633663-22816
X-HE-Meta: U2FsdGVkX1/ecx5JFq62mgPZQzARNUCD6i3w8J1c71pc/bsQgkAGddlNoz/wCzmo68ZK5mDN9y/hDUzJoHpHtFCqhAZqQuyhu5oTjys5D1NcbYPBc72xLvMVU4WkjX3Fr3CAadq7yhjCMfucg8Pu0E3iN/L5A2PjPVNCM+xBk4sXmViVi4eFu/LsanyMJmfDm7e3jjpCaYk1slsKC3s2T1/ON4t3C32EV7fzMkcVLssWVJZk296eWLxvKPYKc+jFOtSCHYroD0aYsjVbnrEHTXLD7TtGkO3trRxHcCtuwH+VV2EXe09B6p48gjujLP++YRiuRhOUJB/Ni1vYq9QPiEyAQNY1NZB9YmQUnILuoQYJQJ6/lNTZmPBRydK4r5s/LrdVXw9+/+4geMIQDL6Wo2N7aCGsqrPYBKC2kQJgb63OXTJQbJ7nRNsetPgeMnGAGJP961W8VEJvl31N6a8ExFk1aDVHctbojPulnhRmrv6ezm7p4S4xTZv1TqzEsthThDCOpmbgWWXQJboNebTOso408aSWMDEIkwpBzbvAVKRPIWCwKmvdxsIBwCa3/jX3RehsftZ8mUhMcOymHGkJsdF89ywYVtrdJZmtb/0UZr2XATD1dD+ETq8LIvDSmyBGB6MfJlczTFgGMrV9O+FgScj9n7rqMjipyfnA856BiLWu6ipOd6kBtgBz+CS5tuW2YV16sa40Qb80SwPYl7NISFAdUK+YiOii/PnA5GIuHvb7BAguXYYI+4yTuq4lcW10qBMwbEvecLu7NZhvVNdUKtTCGa9YnDwo+LrRVFxRHFHftJ257CPT4+GQu0NhUUtKWUNmAmSYViZ3aympvElppNTmKEPt8f2oZiTg4khObAC3jRfmpEQMskj6m+h7z0lnxNd+qcWknKyX1qvLVq7LGTot/Clwws24OHJtXFMzyY60z6QuOx3z/NxH0xKT42VOjLZYsAMfw4Mnyyq00SJ
 DCVA2a0d
 2f/Jtjb2Ke9wPOXCBwp6AdVMaRVHNLv9vsIZnpYTbHaRKVm1xsSrwsFVq9pn4Hyx+5X6wcJ4mmpmZ3HXXHb78KWvUOZBJj/T0rE1qtMY4xoVsVptgmrzIUUT1emmI3f63tc6vo+ND91tzAa88wXxa2W2b2LCuiY5jIeRyT/SZ7HDbLLd3RRdfrt/p7Mc+xU+joIv8Cat9OUumaUghMBJ/n7Fl7+TVUKE4KpElYAcR26FwmccbSa7KEFSrDKI2cNreY2A4u+ATwD3Hwmv0qpFx6eQ3l+/LAuGYAQTUMJ7/19kGnNJcHOlk4alH7gjr+JSUc4pesPTW7/yj6IUN+WNNVx8VXIMqfBR32VS7zajDR1TtDIo6ST8WTCqgz3pHj5xwiiSHiX3K5CiOQph/rDw206a9sjLaa7CP0DnlLUqWBz5PPEIlecRjj4UG0hpY3h2QRcew9eQdRv42yiPCArPrBq/RmkpkSbZWgpDr+ARifNFcaDER28rvuo+n60lpyAw3o7/LIZV5pILa+Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 22:05, Matthew Brost wrote:

> On Fri, Jan 16, 2026 at 12:39:30PM +0200, Mika Penttilä wrote:
>> Hi,
>>
>> On 1/16/26 04:06, Matthew Brost wrote:
>>
>>> On Wed, Jan 14, 2026 at 11:19:21AM +0200, mpenttil@redhat.com wrote:
>>>> From: Mika Penttilä <mpenttil@redhat.com>
>>>>
>>>> Currently, the way device page faulting and migration works
>>>> is not optimal, if you want to do both fault handling and
>>>> migration at once.
>>>>
>>>> Being able to migrate not present pages (or pages mapped with incorrect
>>>> permissions, eg. COW) to the GPU requires doing either of the
>>>> following sequences:
>>>>
>>>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>>>> 2. migrate_vma_*() - migrate the pages
>>>>
>>>> Or:
>>>>
>>>> 1. migrate_vma_*() - migrate present pages
>>>> 2. If non-present pages detected by migrate_vma_*():
>>>>    a) call hmm_range_fault() to fault pages in
>>>>    b) call migrate_vma_*() again to migrate now present pages
>>>>
>>>> The problem with the first sequence is that you always have to do two
>>>> page walks even when most of the time the pages are present or zero page
>>>> mappings so the common case takes a performance hit.
>>>>
>>>> The second sequence is better for the common case, but far worse if
>>>> pages aren't present because now you have to walk the page tables three
>>>> times (once to find the page is not present, once so hmm_range_fault()
>>>> can find a non-present page to fault in and once again to setup the
>>>> migration). It is also tricky to code correctly.
>>>>
>>>> We should be able to walk the page table once, faulting
>>>> pages in as required and replacing them with migration entries if
>>>> requested.
>>>>
>>>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>>>> which tells to prepare for migration also during fault handling.
>>>> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
>>>> is added to tell to add fault handling to migrate.
>>>>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>>> Cc: Leon Romanovsky <leonro@nvidia.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> I'll try to test this when I can but horribly behind at the moment.
>>>
>>> You can use Intel's CI system to test SVM too. I can get you authorized
>>> to use this. The list to trigger is intel-xe@lists.freedesktop.org and
>>> patches must apply to drm-tip. I'll let you know when you are
>>> authorized.
>> Thanks, appreciate, will do that also!
>>
> Working on enabling this for you in CI.
>
> I did a quick test by running our complete test suite and got a kernel
> hang in this section:
>
> xe_exec_system_allocator.threads-shared-vm-many-stride-malloc-prefetch
>
> Stack trace:
>
> [  182.915763] INFO: task xe_exec_system_:5357 blocked for more than 30 seconds.
> [  182.922866]       Tainted: G     U  W           6.19.0-rc4-xe+ #2549
> [  182.929183] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  182.936912] task:xe_exec_system_ state:D stack:0     pid:5357  tgid:1862  ppid:1853   task_flags:0x400040 flags:0x00080000
> [  182.936916] Call Trace:
> [  182.936918]  <TASK>
> [  182.936919]  __schedule+0x4df/0xc20
> [  182.936924]  schedule+0x22/0xd0
> [  182.936925]  io_schedule+0x41/0x60
> [  182.936926]  migration_entry_wait_on_locked+0x21c/0x2a0
> [  182.936929]  ? __pfx_wake_page_function+0x10/0x10
> [  182.936931]  migration_entry_wait+0xad/0xf0
> [  182.936933]  hmm_vma_walk_pmd+0xd5f/0x19b0
> [  182.936935]  walk_pgd_range+0x51d/0xa60
> [  182.936938]  __walk_page_range+0x75/0x1e0
> [  182.936940]  walk_page_range_mm_unsafe+0x138/0x1f0
> [  182.936941]  hmm_range_fault+0x8f/0x160
> [  182.936945]  drm_gpusvm_get_pages+0x1ae/0x8a0 [drm_gpusvm_helper]
> [  182.936949]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
> [  182.936951]  xe_svm_range_get_pages+0x1b/0x50 [xe]
> [  182.936979]  xe_vm_bind_ioctl+0x15c3/0x17e0 [xe]
> [  182.937001]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
> [  182.937021]  ? drm_ioctl_kernel+0xa3/0x100
> [  182.937024]  drm_ioctl_kernel+0xa3/0x100
> [  182.937026]  drm_ioctl+0x213/0x440
> [  182.937028]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
> [  182.937061]  xe_drm_ioctl+0x5a/0xa0 [xe]
> [  182.937083]  __x64_sys_ioctl+0x7f/0xd0
> [  182.937085]  do_syscall_64+0x50/0x290
> [  182.937088]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  182.937091] RIP: 0033:0x7ff00f724ded
> [  182.937092] RSP: 002b:00007ff00b9fa640 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  182.937094] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ff00f724ded
> [  182.937095] RDX: 00007ff00b9fa6d0 RSI: 0000000040886445 RDI: 0000000000000003
> [  182.937096] RBP: 00007ff00b9fa690 R08: 0000000000000000 R09: 0000000000000000
> [  182.937097] R10: 0000000000000001 R11: 0000000000000246 R12: 00007ff00b9fa6d0
> [  182.937098] R13: 0000000040886445 R14: 0000000000000003 R15: 00007ff00f8a9000
> [  182.937099]  </TASK>
>
> This section is a racy test with parallel CPU and device access that is
> likely causing the migration process to abort and retry. From the stack
> trace, it looks like a migration PMD didn’t get properly removed, and a
> subsequent call to hmm_range_fault hangs on a migration entry that was
> not removed during the migration abort.
>
> IIRC, some of the last bits in Balbir’s large device pages series had a
> similar bug, which I sent to Andrew with fixup patches. I suspect you
> have a similar bug. If I can find the time, I’ll see if I can track it
> down.

Thanks for your efforts Matthew!

I remember those discussions, and looks similar. If recall correctly, it was
about failed splits and continuation after that. The code bails out the
pmd loop in this case but maybe this part is missing and is equivalent to
collect skip:

diff --git a/mm/hmm.c b/mm/hmm.c
index 39a07d895043..c7a7bb923a37 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -988,8 +988,12 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
                }
 
                r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
-               if (r)
+               if (r) {
+                       /*  Split has failed, skip to end. */
+                       for (i = 0; addr < end; addr += PAGE_SIZE, i++)
+                               hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
                        break;
+               }
        }
        pte_unmap(ptep - 1);

With that is should be quite similar to current flow (for effects).

>
>>>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>>>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>>>> ---
>>>>  include/linux/hmm.h     |  17 +-
>>>>  include/linux/migrate.h |   6 +-
>>>>  mm/hmm.c                | 657 +++++++++++++++++++++++++++++++++++++---
>>>>  mm/migrate_device.c     |  81 ++++-
>>>>  4 files changed, 706 insertions(+), 55 deletions(-)
>>>>
>>>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>>>> index db75ffc949a7..7b7294ad0f62 100644
>>>> --- a/include/linux/hmm.h
>>>> +++ b/include/linux/hmm.h
>>>> @@ -12,7 +12,7 @@
>>>>  #include <linux/mm.h>
>>>>  
>>>>  struct mmu_interval_notifier;
>>>> -
>>>> +struct migrate_vma;
>>>>  /*
>>>>   * On output:
>>>>   * 0             - The page is faultable and a future call with 
>>>> @@ -48,15 +48,25 @@ enum hmm_pfn_flags {
>>>>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>>>>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>>>>  
>>>> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
>>>> +	/* Migrate request */
>>>> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
>>>> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
>>>> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>>>>  
>>>>  	/* Input flags */
>>>>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>>>>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
>>>> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>>> I believe you are missing kernel for HMM_PFN_MIGRATE.
>> I explain below the HMM_PFN_MIGRATE usage.
>>
> I had a typo here: s/missing kernel/missing doc kernel/

ack

>
>>>>  
>>>>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>>>>  };
>>>>  
>>>> +enum {
>>>> +	/* These flags are carried from input-to-output */
>>>> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>>>> +		HMM_PFN_P2PDMA_BUS,
>>>> +};
>>>> +
>>>>  /*
>>>>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>>>>   *
>>>> @@ -107,6 +117,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>>>>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>>>>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>>>>   * @dev_private_owner: owner of device private pages
>>>> + * @migrate: structure for migrating the associated vma
>>>>   */
>>>>  struct hmm_range {
>>>>  	struct mmu_interval_notifier *notifier;
>>>> @@ -117,12 +128,14 @@ struct hmm_range {
>>>>  	unsigned long		default_flags;
>>>>  	unsigned long		pfn_flags_mask;
>>>>  	void			*dev_private_owner;
>>>> +	struct migrate_vma      *migrate;
>>>>  };
>>>>  
>>>>  /*
>>>>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>>>>   */
>>>>  int hmm_range_fault(struct hmm_range *range);
>>>> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>>>>  
>>>>  /*
>>>>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
>>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>>> index 26ca00c325d9..0889309a9d21 100644
>>>> --- a/include/linux/migrate.h
>>>> +++ b/include/linux/migrate.h
>>>> @@ -3,6 +3,7 @@
>>>>  #define _LINUX_MIGRATE_H
>>>>  
>>>>  #include <linux/mm.h>
>>>> +#include <linux/hmm.h>
>>>>  #include <linux/mempolicy.h>
>>>>  #include <linux/migrate_mode.h>
>>>>  #include <linux/hugetlb.h>
>>>> @@ -140,11 +141,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>>>>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>>>>  }
>>>>  
>>>> -enum migrate_vma_direction {
>>>> +enum migrate_vma_info {
>>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>>>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>> +	MIGRATE_VMA_FAULT = 1 << 4,
>>>>  };
>>>>  
>>>>  struct migrate_vma {
>>>> @@ -192,7 +194,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>>>>  			unsigned long npages);
>>>>  void migrate_device_finalize(unsigned long *src_pfns,
>>>>  			unsigned long *dst_pfns, unsigned long npages);
>>>> -
>>>> +void migrate_hmm_range_setup(struct hmm_range *range);
>>>>  #endif /* CONFIG_MIGRATION */
>>>>  
>>>>  #endif /* _LINUX_MIGRATE_H */
>>>> diff --git a/mm/hmm.c b/mm/hmm.c
>>>> index 4ec74c18bef6..39a07d895043 100644
>>>> --- a/mm/hmm.c
>>>> +++ b/mm/hmm.c
>>>> @@ -20,6 +20,7 @@
>>>>  #include <linux/pagemap.h>
>>>>  #include <linux/leafops.h>
>>>>  #include <linux/hugetlb.h>
>>>> +#include <linux/migrate.h>
>>>>  #include <linux/memremap.h>
>>>>  #include <linux/sched/mm.h>
>>>>  #include <linux/jump_label.h>
>>>> @@ -31,8 +32,12 @@
>>>>  #include "internal.h"
>>>>  
>>>>  struct hmm_vma_walk {
>>>> -	struct hmm_range	*range;
>>>> -	unsigned long		last;
>>>> +	struct mmu_notifier_range	mmu_range;
>>>> +	struct vm_area_struct		*vma;
>>>> +	struct hmm_range		*range;
>>>> +	unsigned long			start;
>>>> +	unsigned long			end;
>>>> +	unsigned long			last;
>>>>  };
>>>>  
>>>>  enum {
>>>> @@ -41,21 +46,49 @@ enum {
>>>>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>>>>  };
>>>>  
>>>> -enum {
>>>> -	/* These flags are carried from input-to-output */
>>>> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>>>> -			      HMM_PFN_P2PDMA_BUS,
>>>> -};
>>>> +static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>>>> +{
>>>> +	enum migrate_vma_info minfo;
>>>> +
>>>> +	minfo = range->migrate ? range->migrate->flags : 0;
>>>> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
>>>> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
>>> I'm trying to make sense of HMM_PFN_REQ_MIGRATE and why it sets
>>> MIGRATE_VMA_SELECT_SYSTEM?
>>>
>>> Also the just the general usage - would range->migrate be NULL in the
>>> expected usage.
>>>
>>> Maybe an example of how hmm_range_fault would be called with this flag
>>> and subsequent expected migrate calls would clear this up.
>> hmm_select_migrate() figures out the migration type (or none) that's going
>> to happen based on the caller (of hmm_range_fault() or migrate_vma_setup()).
>>
>> HMM_PFN_REQ_MIGRATE is hmm_range_fault() user's way to say it wants
>> migrate on fault (with default_flags, the whole range) and for that
>> direction is system->device.
> Can’t range->migrate->flags just set MIGRATE_VMA_SELECT_SYSTEM?
>
> As far as I can tell, HMM_PFN_REQ_MIGRATE doesn’t really do anything if
> range->migrate is NULL or range->migrate->flags is 0.

Yes currently HMM_PFN_REQ_MIGRATE requires range->migrate set but not 
range->migrate->flags. But yes, setting range->migrate->flags directly would
work also.

>  
>> migrate_vma_setup() users (the current device migration) express their
>> migration intention with migrate_vma.flags (direction being which ever).
>>
>>>> +
>>>> +	return minfo;
>>>> +}
>>>>  
>>>>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>>>> -			 struct hmm_range *range, unsigned long cpu_flags)
>>>> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>>>>  {
>>>> +	struct hmm_range *range = hmm_vma_walk->range;
>>>>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
>>>> +	enum migrate_vma_info minfo;
>>>> +	bool migrate = false;
>>>> +
>>>> +	minfo = hmm_select_migrate(range);
>>>> +	if (cpu_flags != HMM_PFN_ERROR) {
>>>> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
>>>> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
>>>> +			migrate = true;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (migrate && thp_migration_supported() &&
>>>> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
>>>> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
>>>> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
>>>> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>>> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
>>>> +		addr += PAGE_SIZE;
>>>> +		i++;
>>>> +		cpu_flags = 0;
>>>> +	}
>>>>  
>>>>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>>>>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>>>  		range->hmm_pfns[i] |= cpu_flags;
>>>>  	}
>>>> +
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -171,11 +204,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>>>>  	if (!walk->vma) {
>>>>  		if (required_fault)
>>>>  			return -EFAULT;
>>>> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
>>>> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>>  	}
>>>>  	if (required_fault)
>>>>  		return hmm_vma_fault(addr, end, required_fault, walk);
>>>> -	return hmm_pfns_fill(addr, end, range, 0);
>>>> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>>>>  }
>>>>  
>>>>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
>>>> @@ -289,10 +322,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>>>  			goto fault;
>>>>  
>>>>  		if (softleaf_is_migration(entry)) {
>>>> -			pte_unmap(ptep);
>>>> -			hmm_vma_walk->last = addr;
>>>> -			migration_entry_wait(walk->mm, pmdp, addr);
>>>> -			return -EBUSY;
>>>> +			if (!hmm_select_migrate(range)) {
>>>> +				pte_unmap(ptep);
>>>> +				hmm_vma_walk->last = addr;
>>>> +				migration_entry_wait(walk->mm, pmdp, addr);
>>>> +				return -EBUSY;
>>>> +			} else
>>>> +				goto out;
>>>>  		}
>>>>  
>>>>  		/* Report error for everything else */
>>>> @@ -376,7 +412,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>>>  			return -EFAULT;
>>>>  	}
>>>>  
>>>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>>  }
>>>>  #else
>>>>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>>> @@ -389,10 +425,448 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>>>  
>>>>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>>>  		return -EFAULT;
>>>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>>  }
>>>>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>>  
>>>> +/**
>>>> + * migrate_vma_split_folio() - Helper function to split a THP folio
>>>> + * @folio: the folio to split
>>>> + * @fault_page: struct page associated with the fault if any
>>>> + *
>>>> + * Returns 0 on success
>>>> + */
>>>> +static int migrate_vma_split_folio(struct folio *folio,
>>>> +				   struct page *fault_page)
>>>> +{
>>>> +	int ret;
>>>> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
>>>> +	struct folio *new_fault_folio = NULL;
>>>> +
>>>> +	if (folio != fault_folio) {
>>>> +		folio_get(folio);
>>>> +		folio_lock(folio);
>>>> +	}
>>>> +
>>>> +	ret = split_folio(folio);
>>>> +	if (ret) {
>>>> +		if (folio != fault_folio) {
>>>> +			folio_unlock(folio);
>>>> +			folio_put(folio);
>>>> +		}
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
>>>> +
>>>> +	/*
>>>> +	 * Ensure the lock is held on the correct
>>>> +	 * folio after the split
>>>> +	 */
>>>> +	if (!new_fault_folio) {
>>>> +		folio_unlock(folio);
>>>> +		folio_put(folio);
>>>> +	} else if (folio != new_fault_folio) {
>>>> +		if (new_fault_folio != fault_folio) {
>>>> +			folio_get(new_fault_folio);
>>>> +			folio_lock(new_fault_folio);
>>>> +		}
>>>> +		folio_unlock(folio);
>>>> +		folio_put(folio);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>>>> +					      pmd_t *pmdp,
>>>> +					      unsigned long start,
>>>> +					      unsigned long end,
>>>> +					      unsigned long *hmm_pfn)
>>>> +{
>>>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>>> +	struct hmm_range *range = hmm_vma_walk->range;
>>>> +	struct migrate_vma *migrate = range->migrate;
>>>> +	struct mm_struct *mm = walk->vma->vm_mm;
>>>> +	struct folio *fault_folio = NULL;
>>>> +	struct folio *folio;
>>>> +	enum migrate_vma_info minfo;
>>>> +	spinlock_t *ptl;
>>>> +	unsigned long i;
>>>> +	int r = 0;
>>>> +
>>>> +	minfo = hmm_select_migrate(range);
>>>> +	if (!minfo)
>>>> +		return r;
>>>> +
>>>> +	fault_folio = (migrate && migrate->fault_page) ?
>>>> +		page_folio(migrate->fault_page) : NULL;
>>>> +
>>>> +	ptl = pmd_lock(mm, pmdp);
>>>> +	if (pmd_none(*pmdp)) {
>>>> +		spin_unlock(ptl);
>>>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>>>> +	}
>>>> +
>>>> +	if (pmd_trans_huge(*pmdp)) {
>>>> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
>>>> +			goto out;
>>>> +
>>>> +		folio = pmd_folio(*pmdp);
>>>> +		if (is_huge_zero_folio(folio)) {
>>>> +			spin_unlock(ptl);
>>>> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>>>> +		}
>>>> +
>>>> +	} else if (!pmd_present(*pmdp)) {
>>>> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
>>>> +
>>>> +		folio = softleaf_to_folio(entry);
>>>> +
>>>> +		if (!softleaf_is_device_private(entry))
>>>> +			goto out;
>>>> +
>>>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>>>> +			goto out;
>>>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>>>> +			goto out;
>>>> +
>>>> +	} else {
>>>> +		spin_unlock(ptl);
>>>> +		return -EBUSY;
>>>> +	}
>>>> +
>>>> +	folio_get(folio);
>>>> +
>>>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>>>> +		spin_unlock(ptl);
>>>> +		folio_put(folio);
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	if (thp_migration_supported() &&
>>>> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>>> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>>> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>>> +
>>>> +		struct page_vma_mapped_walk pvmw = {
>>>> +			.ptl = ptl,
>>>> +			.address = start,
>>>> +			.pmd = pmdp,
>>>> +			.vma = walk->vma,
>>>> +		};
>>>> +
>>>> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
>>>> +
>>>> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>>>> +		if (r) {
>>>> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
>>>> +			r = -ENOENT;  // fallback
>>>> +			goto unlock_out;
>>>> +		}
>>>> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
>>>> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
>>>> +
>>>> +	} else {
>>>> +		r = -ENOENT;  // fallback
>>>> +		goto unlock_out;
>>>> +	}
>>>> +
>>>> +
>>>> +out:
>>>> +	spin_unlock(ptl);
>>>> +	return r;
>>>> +
>>>> +unlock_out:
>>>> +	if (folio != fault_folio)
>>>> +		folio_unlock(folio);
>>>> +	folio_put(folio);
>>>> +	goto out;
>>>> +
>>>> +}
>>>> +
>>>> +/*
>>>> + * Install migration entries if migration requested, either from fault
>>>> + * or migrate paths.
>>>> + *
>>>> + */
>>>> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>>>> +					  pmd_t *pmdp,
>>>> +					  unsigned long addr,
>>>> +					  unsigned long *hmm_pfn)
>>>> +{
>>>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>>> +	struct hmm_range *range = hmm_vma_walk->range;
>>>> +	struct migrate_vma *migrate = range->migrate;
>>>> +	struct mm_struct *mm = walk->vma->vm_mm;
>>>> +	struct folio *fault_folio = NULL;
>>>> +	enum migrate_vma_info minfo;
>>>> +	struct dev_pagemap *pgmap;
>>>> +	bool anon_exclusive;
>>>> +	struct folio *folio;
>>>> +	unsigned long pfn;
>>>> +	struct page *page;
>>>> +	softleaf_t entry;
>>>> +	pte_t pte, swp_pte;
>>>> +	spinlock_t *ptl;
>>>> +	bool writable = false;
>>>> +	pte_t *ptep;
>>>> +
>>>> +	// Do we want to migrate at all?
>>>> +	minfo = hmm_select_migrate(range);
>>>> +	if (!minfo)
>>>> +		return 0;
>>>> +
>>>> +	fault_folio = (migrate && migrate->fault_page) ?
>>>> +		page_folio(migrate->fault_page) : NULL;
>>>> +
>>>> +again:
>>>> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>> +	if (!ptep)
>>>> +		return 0;
>>>> +
>>>> +	pte = ptep_get(ptep);
>>>> +
>>>> +	if (pte_none(pte)) {
>>>> +		// migrate without faulting case
>>>> +		if (vma_is_anonymous(walk->vma)) {
>>>> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
>>>> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
>>>> +			goto out;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (!pte_present(pte)) {
>>>> +		/*
>>>> +		 * Only care about unaddressable device page special
>>>> +		 * page table entry. Other special swap entries are not
>>>> +		 * migratable, and we ignore regular swapped page.
>>>> +		 */
>>>> +		entry = softleaf_from_pte(pte);
>>>> +		if (!softleaf_is_device_private(entry))
>>>> +			goto out;
>>>> +
>>>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>>>> +			goto out;
>>>> +
>>>> +		page = softleaf_to_page(entry);
>>>> +		folio = page_folio(page);
>>>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>>>> +			goto out;
>>>> +
>>>> +		if (folio_test_large(folio)) {
>>>> +			int ret;
>>>> +
>>>> +			pte_unmap_unlock(ptep, ptl);
>>>> +			ret = migrate_vma_split_folio(folio,
>>>> +						      migrate->fault_page);
>>>> +			if (ret)
>>>> +				goto out_unlocked;
>>>> +			goto again;
>>>> +		}
>>>> +
>>>> +		pfn = page_to_pfn(page);
>>>> +		if (softleaf_is_device_private_write(entry))
>>>> +			writable = true;
>>>> +	} else {
>>>> +		pfn = pte_pfn(pte);
>>>> +		if (is_zero_pfn(pfn) &&
>>>> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>>>> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
>>>> +			goto out;
>>>> +		}
>>>> +		page = vm_normal_page(walk->vma, addr, pte);
>>>> +		if (page && !is_zone_device_page(page) &&
>>>> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>>>> +			goto out;
>>>> +		} else if (page && is_device_coherent_page(page)) {
>>>> +			pgmap = page_pgmap(page);
>>>> +
>>>> +			if (!(minfo &
>>>> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
>>>> +			    pgmap->owner != migrate->pgmap_owner)
>>>> +				goto out;
>>>> +		}
>>>> +
>>>> +		folio = page_folio(page);
>>>> +		if (folio_test_large(folio)) {
>>>> +			int ret;
>>>> +
>>>> +			pte_unmap_unlock(ptep, ptl);
>>>> +			ret = migrate_vma_split_folio(folio,
>>>> +						      migrate->fault_page);
>>>> +			if (ret)
>>>> +				goto out_unlocked;
>>>> +
>>>> +			goto again;
>>>> +		}
>>>> +
>>>> +		writable = pte_write(pte);
>>>> +	}
>>>> +
>>>> +	if (!page || !page->mapping)
>>>> +		goto out;
>>>> +
>>>> +	/*
>>>> +	 * By getting a reference on the folio we pin it and that blocks
>>>> +	 * any kind of migration. Side effect is that it "freezes" the
>>>> +	 * pte.
>>>> +	 *
>>>> +	 * We drop this reference after isolating the folio from the lru
>>>> +	 * for non device folio (device folio are not on the lru and thus
>>>> +	 * can't be dropped from it).
>>>> +	 */
>>>> +	folio = page_folio(page);
>>>> +	folio_get(folio);
>>>> +
>>>> +	/*
>>>> +	 * We rely on folio_trylock() to avoid deadlock between
>>>> +	 * concurrent migrations where each is waiting on the others
>>>> +	 * folio lock. If we can't immediately lock the folio we fail this
>>>> +	 * migration as it is only best effort anyway.
>>>> +	 *
>>>> +	 * If we can lock the folio it's safe to set up a migration entry
>>>> +	 * now. In the common case where the folio is mapped once in a
>>>> +	 * single process setting up the migration entry now is an
>>>> +	 * optimisation to avoid walking the rmap later with
>>>> +	 * try_to_migrate().
>>>> +	 */
>>>> +
>>>> +	if (fault_folio == folio || folio_trylock(folio)) {
>>>> +		anon_exclusive = folio_test_anon(folio) &&
>>>> +			PageAnonExclusive(page);
>>>> +
>>>> +		flush_cache_page(walk->vma, addr, pfn);
>>>> +
>>>> +		if (anon_exclusive) {
>>>> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
>>>> +
>>>> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
>>>> +				set_pte_at(mm, addr, ptep, pte);
>>>> +				folio_unlock(folio);
>>>> +				folio_put(folio);
>>>> +				goto out;
>>>> +			}
>>>> +		} else {
>>>> +			pte = ptep_get_and_clear(mm, addr, ptep);
>>>> +		}
>>>> +
>>>> +		/* Setup special migration page table entry */
>>>> +		if (writable)
>>>> +			entry = make_writable_migration_entry(pfn);
>>>> +		else if (anon_exclusive)
>>>> +			entry = make_readable_exclusive_migration_entry(pfn);
>>>> +		else
>>>> +			entry = make_readable_migration_entry(pfn);
>>>> +
>>>> +		swp_pte = swp_entry_to_pte(entry);
>>>> +		if (pte_present(pte)) {
>>>> +			if (pte_soft_dirty(pte))
>>>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>>>> +			if (pte_uffd_wp(pte))
>>>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>>>> +		} else {
>>>> +			if (pte_swp_soft_dirty(pte))
>>>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>>>> +			if (pte_swp_uffd_wp(pte))
>>>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>>>> +		}
>>>> +
>>>> +		set_pte_at(mm, addr, ptep, swp_pte);
>>>> +		folio_remove_rmap_pte(folio, page, walk->vma);
>>>> +		folio_put(folio);
>>>> +		*hmm_pfn |= HMM_PFN_MIGRATE;
>>>> +
>>>> +		if (pte_present(pte))
>>>> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
>>>> +	} else
>>>> +		folio_put(folio);
>>>> +out:
>>>> +	pte_unmap_unlock(ptep, ptl);
>>>> +	return 0;
>>>> +out_unlocked:
>>>> +	return -1;
>>>> +
>>>> +}
>>>> +
>>>> +static int hmm_vma_walk_split(pmd_t *pmdp,
>>>> +			      unsigned long addr,
>>>> +			      struct mm_walk *walk)
>>>> +{
>>>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>>> +	struct hmm_range *range = hmm_vma_walk->range;
>>>> +	struct migrate_vma *migrate = range->migrate;
>>>> +	struct folio *folio, *fault_folio;
>>>> +	spinlock_t *ptl;
>>>> +	int ret = 0;
>>>> +
>>>> +	fault_folio = (migrate && migrate->fault_page) ?
>>>> +		page_folio(migrate->fault_page) : NULL;
>>>> +
>>>> +	ptl = pmd_lock(walk->mm, pmdp);
>>>> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
>>>> +		spin_unlock(ptl);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	folio = pmd_folio(*pmdp);
>>>> +	if (is_huge_zero_folio(folio)) {
>>>> +		spin_unlock(ptl);
>>>> +		split_huge_pmd(walk->vma, pmdp, addr);
>>>> +	} else {
>>>> +		folio_get(folio);
>>>> +		spin_unlock(ptl);
>>>> +
>>>> +		if (folio != fault_folio) {
>>>> +			if (unlikely(!folio_trylock(folio))) {
>>>> +				folio_put(folio);
>>>> +				ret = -EBUSY;
>>>> +				goto out;
>>>> +			}
>>>> +		}  else
>>>> +			folio_put(folio);
>>>> +
>>>> +		ret = split_folio(folio);
>>>> +		if (fault_folio != folio) {
>>>> +			folio_unlock(folio);
>>>> +			folio_put(folio);
>>>> +		}
>>>> +
>>>> +	}
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int hmm_vma_capture_migrate_range(unsigned long start,
>>>> +					 unsigned long end,
>>>> +					 struct mm_walk *walk)
>>>> +{
>>>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>>> +	struct hmm_range *range = hmm_vma_walk->range;
>>>> +
>>>> +	if (!hmm_select_migrate(range))
>>>> +		return 0;
>>>> +
>>>> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
>>>> +		return -ERANGE;
>>>> +
>>>> +	hmm_vma_walk->vma = walk->vma;
>>>> +	hmm_vma_walk->start = start;
>>>> +	hmm_vma_walk->end = end;
>>>> +
>>>> +	if (end - start > range->end - range->start)
>>>> +		return -ERANGE;
>>>> +
>>>> +	if (!hmm_vma_walk->mmu_range.owner) {
>>>> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
>>>> +					      walk->vma->vm_mm, start, end,
>>>> +					      range->dev_private_owner);
>>>> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>>>  			    unsigned long start,
>>>>  			    unsigned long end,
>>>> @@ -404,42 +878,90 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>>>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>>>>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>>>>  	unsigned long addr = start;
>>>> +	enum migrate_vma_info minfo;
>>>> +	unsigned long i;
>>>> +	spinlock_t *ptl;
>>>>  	pte_t *ptep;
>>>>  	pmd_t pmd;
>>>> +	int r;
>>>>  
>>>> +	minfo = hmm_select_migrate(range);
>>>>  again:
>>>> +
>>>>  	pmd = pmdp_get_lockless(pmdp);
>>>> -	if (pmd_none(pmd))
>>>> -		return hmm_vma_walk_hole(start, end, -1, walk);
>>>> +	if (pmd_none(pmd)) {
>>>> +		r = hmm_vma_walk_hole(start, end, -1, walk);
>>>> +		if (r || !minfo)
>>>> +			return r;
>>>> +
>>>> +		ptl = pmd_lock(walk->mm, pmdp);
>>>> +		if (pmd_none(*pmdp)) {
>>>> +			// hmm_vma_walk_hole() filled migration needs
>>>> +			spin_unlock(ptl);
>>>> +			return r;
>>>> +		}
>>>> +		spin_unlock(ptl);
>>>> +	}
>>>>  
>>>>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
>>>> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>>>> -			hmm_vma_walk->last = addr;
>>>> -			pmd_migration_entry_wait(walk->mm, pmdp);
>>>> -			return -EBUSY;
>>>> +		if (!minfo) {
>>>> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>>>> +				hmm_vma_walk->last = addr;
>>>> +				pmd_migration_entry_wait(walk->mm, pmdp);
>>>> +				return -EBUSY;
>>>> +			}
>>>>  		}
>>>> -		return hmm_pfns_fill(start, end, range, 0);
>>>> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
>>>> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>>> +
>>>> +		return 0;
>>>>  	}
>>>>  
>>>> -	if (!pmd_present(pmd))
>>>> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>>>> -						 pmd);
>>>> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
>>>> +
>>>> +		if (!pmd_present(pmd)) {
>>>> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>>>> +						      pmd);
>>>> +			if (r || !minfo)
>>>> +				return r;
>>>> +		} else {
>>>> +
>>>> +			/*
>>>> +			 * No need to take pmd_lock here, even if some other thread
>>>> +			 * is splitting the huge pmd we will get that event through
>>>> +			 * mmu_notifier callback.
>>>> +			 *
>>>> +			 * So just read pmd value and check again it's a transparent
>>>> +			 * huge or device mapping one and compute corresponding pfn
>>>> +			 * values.
>>>> +			 */
>>>> +
>>>> +			pmd = pmdp_get_lockless(pmdp);
>>>> +			if (!pmd_trans_huge(pmd))
>>>> +				goto again;
>>>> +
>>>> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>>>> +
>>>> +			if (r || !minfo)
>>>> +				return r;
>>>> +		}
>>>>  
>>>> -	if (pmd_trans_huge(pmd)) {
>>>> -		/*
>>>> -		 * No need to take pmd_lock here, even if some other thread
>>>> -		 * is splitting the huge pmd we will get that event through
>>>> -		 * mmu_notifier callback.
>>>> -		 *
>>>> -		 * So just read pmd value and check again it's a transparent
>>>> -		 * huge or device mapping one and compute corresponding pfn
>>>> -		 * values.
>>>> -		 */
>>>> -		pmd = pmdp_get_lockless(pmdp);
>>>> -		if (!pmd_trans_huge(pmd))
>>>> -			goto again;
>>>> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
>>>> +
>>>> +		if (r == -ENOENT) {
>>>> +			r = hmm_vma_walk_split(pmdp, addr, walk);
>>>> +			if (r) {
>>>> +				/* Split not successful, skip */
>>>> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>> +			}
>>>> +
>>>> +			/* Split successful or "again", reloop */
>>>> +			hmm_vma_walk->last = addr;
>>>> +			return -EBUSY;
>>>> +		}
>>>> +
>>>> +		return r;
>>>>  
>>>> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>>>>  	}
>>>>  
>>>>  	/*
>>>> @@ -451,22 +973,26 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>>>  	if (pmd_bad(pmd)) {
>>>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>>>  			return -EFAULT;
>>>> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>>  	}
>>>>  
>>>>  	ptep = pte_offset_map(pmdp, addr);
>>>>  	if (!ptep)
>>>>  		goto again;
>>>>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
>>>> -		int r;
>>>>  
>>>>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>>>>  		if (r) {
>>>>  			/* hmm_vma_handle_pte() did pte_unmap() */
>>>>  			return r;
>>>>  		}
>>>> +
>>>> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
>>>> +		if (r)
>>>> +			break;
>>>>  	}
>>>>  	pte_unmap(ptep - 1);
>>>> +
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -600,6 +1126,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>>>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>>>  	struct hmm_range *range = hmm_vma_walk->range;
>>>>  	struct vm_area_struct *vma = walk->vma;
>>>> +	int r;
>>>> +
>>>> +	r = hmm_vma_capture_migrate_range(start, end, walk);
>>>> +	if (r)
>>>> +		return r;
>>>>  
>>>>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>>>>  	    vma->vm_flags & VM_READ)
>>>> @@ -622,7 +1153,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>>>  				 (end - start) >> PAGE_SHIFT, 0))
>>>>  		return -EFAULT;
>>>>  
>>>> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>>> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>>>  
>>>>  	/* Skip this vma and continue processing the next vma. */
>>>>  	return 1;
>>>> @@ -652,9 +1183,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>>>>   *		the invalidation to finish.
>>>>   * -EFAULT:     A page was requested to be valid and could not be made valid
>>>>   *              ie it has no backing VMA or it is illegal to access
>>>> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
>>>> + *              is too low.
>>>>   *
>>>>   * This is similar to get_user_pages(), except that it can read the page tables
>>>>   * without mutating them (ie causing faults).
>>>> + *
>>>> + * If want to do migrate after faultin, call hmm_rangem_fault() with
>>> s/faultin/faulting
>>>
>>> s/hmm_rangem_fault/hmm_range_fault
>> Will fix, thanks!
>>
>>>> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
>>> I'm not following the HMM_PFN_REQ_MIGRATE usage.
>>>
>>>> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
>>>> + * migrate_vma_setup() and after that follow normal migrate calls path.
>>>> + *
>>> Also since migrate_vma_setup calls hmm_range_fault then
>>> migrate_hmm_range_setup what would the use case for not just calling
>>> migrate_vma_setup be?
>> It's the call context that matters. When resolving device faults and based on a policy,
>> some regions you mirror, some migrate, you start with
>> call(s) to hmm_range_fault() (+HMM_PFN_REQ_MIGRATE optionally),
>> and explicitly call migrate_hmm_range_setup() + other migrate_vma* when migrating.
>> For resolving device faults it's just the hmm_range_fault() part like before.
>> For current migration users, migrate_vma_setup() keeps the current behavior calling
>> hmm_range_fault() under the hood for installing migration ptes 
>> after optionally bringing in swapped pages (with MIGRATE_VMA_FAULT).
>> I think we get better understanding how the entrypoints should look like when used for a real device.
>> For now I have tried to keep the current behavior and entry points, refactoring under the hood
>> for code reuse.
>>
> I’m not completely following the above, but I did think of a case where
> hmm_range_fault + migrate_hmm_range_setup is better than using
> migrate_vma_setup() alone. Previously, before calling
> migrate_vma_setup(), we had to look up the VMA. If hmm_range_fault
> populates the migrate_vma arguments (include the VMA,) that’s better
> than the current flow.

Yes that's true, and actually something I forgot to mention in the cover letter:
We get the VMAs populated now.

>
>>>>   */
>>>>  int hmm_range_fault(struct hmm_range *range)
>>>>  {
>>>> @@ -662,16 +1201,28 @@ int hmm_range_fault(struct hmm_range *range)
>>>>  		.range = range,
>>>>  		.last = range->start,
>>>>  	};
>>>> -	struct mm_struct *mm = range->notifier->mm;
>>>> +	bool is_fault_path = !!range->notifier;
>>>> +	struct mm_struct *mm;
>>>>  	int ret;
>>>>  
>>>> +	/*
>>>> +	 *
>>>> +	 *  Could be serving a device fault or come from migrate
>>>> +	 *  entry point. For the former we have not resolved the vma
>>>> +	 *  yet, and the latter we don't have a notifier (but have a vma).
>>>> +	 *
>>>> +	 */
>>>> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
>>>>  	mmap_assert_locked(mm);
>>>>  
>>>>  	do {
>>>>  		/* If range is no longer valid force retry. */
>>>> -		if (mmu_interval_check_retry(range->notifier,
>>>> -					     range->notifier_seq))
>>>> -			return -EBUSY;
>>>> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
>>>> +					     range->notifier_seq)) {
>>>> +			ret = -EBUSY;
>>>> +			break;
>>>> +		}
>>>> +
>>>>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>>>>  				      &hmm_walk_ops, &hmm_vma_walk);
>>>>  		/*
>>>> @@ -681,6 +1232,18 @@ int hmm_range_fault(struct hmm_range *range)
>>>>  		 * output, and all >= are still at their input values.
>>>>  		 */
>>>>  	} while (ret == -EBUSY);
>>>> +
>>>> +	if (hmm_select_migrate(range) && range->migrate &&
>>>> +	    hmm_vma_walk.mmu_range.owner) {
>>>> +		// The migrate_vma path has the following initialized
>>>> +		if (is_fault_path) {
>>>> +			range->migrate->vma   = hmm_vma_walk.vma;
>>>> +			range->migrate->start = range->start;
>>>> +			range->migrate->end   = hmm_vma_walk.end;
>>>> +		}
>>>> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
>>>> +	}
>>>> +
>>>>  	return ret;
>>>>  }
>>>>  EXPORT_SYMBOL(hmm_range_fault);
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 23379663b1e1..d89efdfca8f6 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -734,7 +734,17 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>>>>   */
>>>>  int migrate_vma_setup(struct migrate_vma *args)
>>>>  {
>>>> +	int ret;
>>>>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>>>> +	struct hmm_range range = {
>>>> +		.notifier = NULL,
>>>> +		.start = args->start,
>>>> +		.end = args->end,
>>>> +		.migrate = args,
>>>> +		.hmm_pfns = args->src,
>>>> +		.dev_private_owner = args->pgmap_owner,
>>>> +		.migrate = args
>>>> +	};
>>>>  
>>>>  	args->start &= PAGE_MASK;
>>>>  	args->end &= PAGE_MASK;
>>>> @@ -759,17 +769,19 @@ int migrate_vma_setup(struct migrate_vma *args)
>>>>  	args->cpages = 0;
>>>>  	args->npages = 0;
>>>>  
>>>> -	migrate_vma_collect(args);
>>>> +	if (args->flags & MIGRATE_VMA_FAULT)
>>>> +		range.default_flags |= HMM_PFN_REQ_FAULT;
>>> Next level here might be skip faulting pte_none() in hmm_range_fault
>>> too?
>> That would be a possible optimization!
>>
> Yes, I think that would make this really useful, and we (Xe’s SVM
> implementation) would likely always want to set the flag that says
> ‘fault in !pte_present() && !pte_none’. I’m not 100% sure on this, but
> that’s my initial feeling.

Yes I will look into this.

> Matt

--Mika



