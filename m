Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C94AC61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5946B0092; Tue,  1 Sep 2026 23:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F7F6B0096; Tue,  1 Sep 2026 23:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A696B0098; Tue,  1 Sep 2026 23:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2DB26B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:27:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FE41A469F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:27:23 +0000 (UTC)
X-FDA: 85167386766.16.402F0D5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49C85180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:27:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kZI5kPyk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v2pL6B5TRGM5v13WI+H6IYvJpdytNXJVEbp9UKzoi4=;
	b=0n6smSVCs4CdZKsoqHjAE+t8pb9+r1TjiDwmN3W0k5W20R0X0zpPxh7gi93BD/iMnhKvVC
	hBBcVTZrwRx7kmbj/rqUSpMNPO3C2beo7jjoTlEC4gWS9JX1T6pXDzuAKPDAh5jXbSRlnO
	94BZsBrWdpyIjla/U945PNeoxuS71ng=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kZI5kPyk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319640;
	b=MaQ1WgWnvZoXFQ4BY8RO3y+ETq3p40TZNOgsTP/y13cAaHFb9qAO9ddxSiakpmJMq9a7PY
	eIMopNg+YbbChyQ4Cwk/Y8SiYhiQGZnjtFWFogt7rJ7x32v/jLrQBrfrxV08VQeOVVun7A
	Kpbm3gvjUMmnMV7n8KLxpvFIGi5EtCM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788319639; x=1819855639;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TUJHEOBl3U7XWWW3kQmwva+BBRdNdtlcHkUtD6k5bq4=;
  b=kZI5kPykEsGy+8P0A11yINzZeuTaSxSbdA05TOKIpaxOjFm88AcZGhpl
   l6fk3bm7CmSGZkpVoirtkuj76quEcQ8nN51PvAwX++Camdzl3N1qPO6gT
   K+GL1zdZe8sqA3CIJn6XSFwiBV9ZGE/u2pHGgSkqcCKnMIhxMIPzBv/Iv
   Bof4S+dQNH1xdP1iRZhFCudsV0AkA7Prrh0mva0v9qtvqC8Cr3G3kJxrH
   mEIPRpN7gPUHUgECJ2iL0Ub4QJKhrjoU7YWof7B04HK54ZiiJLzz36Xnx
   zSPUnW8KdMUi+IILNKiCg2Na9fXqEUM3lRgu5RExYUC8wTRhXGJj9DBJQ
   w==;
X-CSE-ConnectionGUID: sAyiVUxXRJe4zOtir7xqvA==
X-CSE-MsgGUID: Ucz5TJ/vQv2Lc+cNOn5c8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="76317682"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="76317682"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 20:27:17 -0700
X-CSE-ConnectionGUID: AGeB1hPEQT+hgLB03500lw==
X-CSE-MsgGUID: TM+113I7RAS5hRz8VK5CNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="266677621"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 20:27:03 -0700
Message-ID: <cb2705d4-8494-41b3-b018-1a1e3d776e17@linux.intel.com>
Date: Wed, 2 Sep 2026 11:27:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/45] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-11-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d1sqz8mb8h8orgo3w3o5c4bqxcg3htxj
X-Rspamd-Queue-Id: 49C85180003
X-HE-Tag: 1788319639-360996
X-HE-Meta: U2FsdGVkX18NPHTzCkFUG/FXmDm7+zcPtbIQb4UscmEYSyQjNoErya+89Oa4WGA1IGLg23+WI6f1wdHQ8sDcqFICq1eWbW9KljCHfVjV2QZNGYADda2YIxNhpwRthxFUZQJjDF1ovmy/DkRSmh7BG03mbI2+N/LqUX+a8K+W4csJKK9H7TsEXnuuFbIGVQb8DSuRufM8Fwq3sOKKvo47HFET1zrhsaDrVTNLgKIUlGdxoyCWO5QOzfMIyz8Yh7Sx99i1pVX72LJ5ey6me6yo5EjXIbdoDmdM+0GwyxCSRqU6lGEiFvDv/bHUjDO6mizr4KtidZ/hX1QRpH5GXtvGTSHvhE5hvJnTAu2oHh07EmIwJc5FjNOLs0KFd9WzGvFRD8btO0bnFBk8H4+DcNmkbDnpVRdNVIOgiqHlVoYyWgBAjFnot1KodCU+b9I0Vqd6fFgs4Dng3DP9dVcKsEeHgbH9EwFp8jJTIS5mbhCzzLHPNYeVJ8WAezvBuZWNK+djyn0cefmgjsI7rU+o0xLLh5x99TrMrZlv7NnKZQnmDI4pKI53bnkVW0rIwS2p4BXr2Ux1Pa9EN2xMNwW3BIQo/cg28FhU3PwhTZLVFOHUiSYWr499IhwZCZBg4aY+80vc6mGFTK12D1vkb7Yy+60Qc9ayTnvwq8/9wc907L2/yVtlPsQ1SyT38Chw8L+lEPKD9PnR/jjW6/hZMN4b6ORQXFwksSVfjIPa1/rDLtOCJ4AlWMHR/ariF43IPJH6aYfEy7NSHAZ3/5e7hcU0rRdM+abSq/M5CnnSzL72lW+ttbzMCY8f6SHKONiDLEv82WBtV7/2jdBf6L4Yp5a8+QZhfn08hWryDH0KIAY839hLX+q6LpbEAvamaGb88/zfsljwc2uzQDFqOEIpQdy7T0RjAnKS5uiZfaEFlLF2kM3ctTDvPUaVPy9nZPClmsMx9ZWEu+AOljJETzHeuaNeVOv
 GCWz2DhC
 C0/khj6bDqKVRNU4Wyu5cOhHSp3u/w/iDb+TxgynnE2AzY1dWwFB0jWNSfhGCMK8+XokVb3NrYR09U79St9Nfat9yuni5FpLvgwOetp51YBkIwx65Vgm8XDj/LOd2+suCvKy+uS+/KRr2A1L73EOYpXCl+MAKZjeb4oSPLg+8UNNz15BNTka27Uyqga8VXEZ+v86OFKX985zGlu4+Ycc34MR6erM1SBtH0u2nhDzsW17F+TUG1DfkjMLws74h6jdN13ZIFf6q5gGrVMuiS75HDG/2Rhr5J+lAEZxGE49IBiURhpTvMtqjPLsbPjJl/I0m1IFxZ3pZX/HvpkG7lkjXRNap7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When removing one or more folios from a guest_memfd instance, invalidate
> both SHARED and PRIVATE mappings if in-place conversion is enabled, because
> stating the obvious, KVM needs to ensure that all mappings to the folio(s)
> are dropped.
> 
> Opportunistically rename the helper to capture that it returns a filter for
> all gfns in anticipation of zapping only the previous mapping types on
> conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
> mappings need to be zapped (ignoring that KVM would ideally not invalidate
> ranges whose attributes aren't changing in the first place).
> 
> Note, precisely zapping only the possible mapping types when in-place
> conversion is disabled is important for functional correctness, not just
> for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
> tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
> incorrectly zap SHARED mappings that have nothing to do with that gmem
> instance (because they're mapped via a VMA, not a gmem fd).
> 
> The incorrect over-zapping of SHARED memory that doesn't belong to the gmem
> fd requesting the zapping will be resolved in a later patch, where, if
> in-place conversion is enabled, KVM will use both shared and private memory
> from the guest_memfd. If both shared and private memory are from the
> guest_memfd, invalidation will only zap memory belonging to the given gmem
> instance.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


