Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988FD606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZvTTz6I8
Received: by kanga.kvack.org (Postfix)
	id 4739F6B05B0; Fri, 13 Nov 2026 15:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433926B05B2; Fri, 13 Nov 2026 15:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322976B05B3; Fri, 13 Nov 2026 15:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0797E6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:35:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F2CA1C25B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:35:22 +0000 (UTC)
X-FDA: 85431250884.01.A03ABEC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id A585D1C0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:35:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZvTTz6I8;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602120;
	b=Ci3kc0jdn9cHRw3qeeD0BDsdISRjhWDY6k3bwXghFF+PFO9R3FjVXrsvPbv8GHygz8WDNH
	0XYIzMdd1wZr/nX7/n2hDAbCD77ND8udDMPPjG+sjm1Cj7HyIgNiA0KjMIPV7wJaywHHtT
	IkDTDDba0hqnrp3IZXcJ7YNEyx/JD3k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZvTTz6I8;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBde9T5yIFhUbpSEt2N9ofmNUnd2o7eVYR1t4ml25Cg=;
	b=QdkyAeN5jORxj669Mkb8gF5vsmFdyXIc7q3MZzLZOQpbALXT/ZQSgvPg8mB/ZFnDf8BX+T
	U/+NfviB++ctai/PdhqkSAaaRyopDPhlENHbKu1Y0a7mr7r7P/t7f2sur0/GxET49GGBLz
	q+VBl6HzHwdXaiSyqiwarBIFIAnQ1/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794602120; x=1826138120;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZBde9T5yIFhUbpSEt2N9ofmNUnd2o7eVYR1t4ml25Cg=;
  b=ZvTTz6I8fE1ihCzED+Tl1Ja7BqksIOrchr06bMIAhyT/aGBp1gOKcHOo
   4E292YTOm2gi1KUh9G/vKk0lIENS7OC93KvLJ863t8SECEUFXF7bvYXqz
   c8WFNRbkTidYBMwD/4AYwU8K5efhOaP0Q0Xnr8MOB/iFWEis8UWHFfGtr
   Pk280sju6MGFiOOCWK8G1h8tK1t5eod0pe45U/7RcI64WaSdjQEvpFMle
   fcYzmpx6yKpfG3inKEFMruaPeOQWS9Sl+gusNWuhv5rf1U3lrpLCWbDRr
   XRhBA0PvNMppKw+1HJ9AAsP2idx4V0HGKq5twvgllZSl8xziHukYzDskT
   w==;
X-CSE-ConnectionGUID: M+OzehiuSUiOS/LEwBYeOA==
X-CSE-MsgGUID: tBmJ3FziRHSCr+LfjbVmDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3292334"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3292334"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 12:35:18 -0800
X-CSE-ConnectionGUID: YYV4gveNSTKUjR6e+yjzZQ==
X-CSE-MsgGUID: 4Lc0Si74RiO2z2bAenVV4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="8822926"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO [10.245.244.252]) ([10.245.244.252])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 12:35:12 -0800
Message-ID: <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Auld
	 <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Mika =?ISO-8859-1?Q?Penttil=E4?=
 <mpenttil@redhat.com>,  Leon Romanovsky	 <leon@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>
Date: Fri, 13 Nov 2026 21:34:43 +0100
In-Reply-To: <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
	 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A585D1C0002
X-Stat-Signature: rwqp55azhga6eq4qrikornboteurw8wz
X-Rspam-User: 
X-HE-Tag: 1794602119-877549
X-HE-Meta: U2FsdGVkX19nO/cUQ6+G5UhmYUs+l9ByQiURimVdSyWRCw5pb/I6lZSU4laJGU4sW9feAQYZDdZpDV4y/8Jjh0NwP/DhEKFBWI61lSd3kGiSX2MBr7QBSRhXR+5nOYMKpSFgMSqZ59KjdZASHdio76AqCKPxQNtXfrQNsg4tQbjekVoKB+JxMyDsDj6MqWIcKoPssD6Tdbn/rgAQ93SJtyYIck+/oWR5Pjp5LhgLt6fOOlytETvryLNCk20vOfb2C2y1lDTT3fYQS2I8cdvTITQYsp+vq9D0O0ci0on4KWbKOe/WuyTzL5Pe92IpQ0ojONVxs7/TJfN4oO+y3J55N03cRRhCSzkSRNyatZVg2PvgD6KVQVE0pLzaN/yn9IuODJ7kfGmNXoHYOAZL6JNVrOs4zDDJXyzVy2jtaRIsciBhcslqQKcUiLnUi7jL6TPVRMH4LVjTTvxZHxQIyZzZmEOehFEKShEJf4+mqdn3hCVQtkbzXIlUTzyxFqOLnE0WcwnDmYBWfJoYF1Copra5yd8KWyiOMiPK0/YocI2zcC20+VErtsbN0g13ogbZF/YDO/xvKQIV1QaFUXXA4OEKqgNqzEsrMgs3+oAGOMxVuBoIIpOsOsCBZn+jRHCOFN3IZpIr/AmWXHgmeiuZ1mPhr8OB7FeidAY9KiC/gpKLsbPKTcz1xYjx2XGHgYKTeIomUwn7fIKXafsPGWz8Y17n764K/7KUCaPoqsGdjYL0yg5scn91ryf1McaQJDeG/0SbF89rp1ElBzSzmM70Oif+bYUVAqwQB+H+M7LGqrZg9z6hHxhXZHkSMcClF24ykVVGAVVgJmF9v5z6A7UDt6Vo1VWDoanRsw5HbTVTOWW9NURGPHQw09z7zBBHHoTr1NW9VwZvImOqM6nJqu0FgpTGVX32IMXrF4JeDthttJ0j9DdWoSaky1tkCUku23m5Ph00ajVOwlp/j+a1GRidahV
 PEx2MeMN
 NbNMLq+E4kPU5HUl/ka+NpwXPeDI1oDa2InEe+STIeyzs7glUeN28G3Dcih/rUJxQehWVEcInW7pTWZF0ap+2fTi6yuDKvSvmdnOLNcP0H0qaRXiQROnoSFnwmRi9u/kQuUm/ccc6ap8A2pj3qOFy2s8YdjFxfXpZHaQ1lqomQI+aQf1m8zccdA3Kfd/OM7QQiEr3GmiW/K4cssr6bREw7dN6/quQTTW756q49iiDcH5AxZiih9nhXT5t9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, David

On Fri, 2026-11-13 at 19:27 +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 17:25, Matthew Auld wrote:
> > When automatic NUMA balancing marks a PTE or PMD as protnone
> > (PAGE_NONE), hmm_pte_need_fault() requests a fault to restore
> > access
> > permissions, including _PAGE_RW when write access is needed.
> >=20
> > Calling handle_mm_fault() from hmm_do_fault() currently triggers
> > NUMA
> > balancing in do_numa_page() and do_huge_pmd_numa_page(). When
> > hmm_range_fault() runs from a device driver or kworker context
> > (such as
> > a GPU SVM or userptr rebind worker), folios get migrated toward the
> > CPU
> > node executing the remote fault.
> >=20
> > Also, each folio migration invokes try_to_migrate_one() ->
> > mmu_notifier_invalidate_range_start(), which invalidates the
> > caller's mmu_interval_notifier while holding mmap_lock. That causes
> > hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD and
> > exhaust
> > its retry timeout on large buffers, which has been observed with
> > large
> > imported Xe userptr buffers.
> >=20
> > Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone
> > entries
> > restore PTE/PMD permissions in-place without performing NUMA
> > balancing,
> > matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.
>=20
> Ehm, that's not how it works.
>=20
> GUP will not trigger a "special" fault and will try not triggering a
> fault and
> not restore permissions.
>=20
> It will try continuing, leaving the protnone pte as it is.
>=20
> See gup_can_follow_protnone().
>=20
> For read-only access that should always work.
>=20
> For write-access we always trigger an ordinary fault and do NUMA
> migration etc.
>=20
>=20
> So FAULT_FLAG_NO_NUMA is doing something completely different and I
> don't agree
> with it.
>=20

There are two major problems with the current behaviour.

1) The work item executing hmm_range_fault() might have no affinity at
all to the GPU about to access the memory.

2) If migration happens, then hmm_range_fault() will stop and retry
leading to excessive execution time.

While perhaps Matt's commit message doesn't correctly describe the GUP
behaviour, do you have any alternative suggestion than to avoid
migration in this case? I think it's a reasonable idea given the
problems with the current code?

Thanks,
Thomas
=20


