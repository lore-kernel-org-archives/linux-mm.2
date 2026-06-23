Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA86CCDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB20C6B008C; Mon, 22 Jun 2026 22:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63486B0092; Mon, 22 Jun 2026 22:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951F46B0093; Mon, 22 Jun 2026 22:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA686B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:49:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEE21120363
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:49:05 +0000 (UTC)
X-FDA: 84909645450.05.07524B2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48ACCA0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:49:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gsAoquKE;
	spf=pass (imf15.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782182943;
	b=E2GuU/RDUSUSjKLKaNJBMIEe05gmbX0hy9JOHGcOjCYz3gcpCNKSMTxEJROA+kaSMVXwbS
	RlGb1N0tbTNn1j5kfUjg6aZNsUBSNy1x66j+//T5FkDjEo7LJ2C10Ci2V8GOAmC5Qk0j0f
	xUS+Nfa1wcoNfY4iLnWQ1eWGbcjHkdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782182943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5glPhRdv6V52efTc0oro6Kq52Ms64agPxwuba/GrA0=;
	b=6lR3yhrSr3YU1ejDlEVb76tjUN6iy2GZPWVxGY+DK/1m2dlYF5PkSeNG6WQpACVXpDxu6/
	U8PsB/3Lsa0fxwinpaxhjrzZLvFtccGymdPxhjeFQzU30fyPWWHxh4zV7WfSRYcAu731k2
	wvT7hrf/WctbIi/kAmnNAkdr0RKmT/s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gsAoquKE;
	spf=pass (imf15.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782182943; x=1813718943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ArTZKS9r3TPMaQgQTYCYM5ecuBaoroMU8Bd1y5b6InM=;
  b=gsAoquKEoSxtQqIuPBA1KqqBy3d8OOkV5E8L148SkFZy57E/daXlQOzO
   jYFZJzvnMjvRH+dCFe1Ewge7dxrYHuPtGRMhf04+w6oCX6WqHJaT8pMg8
   +830DbdYOgt6Tca6T67EeniZrKcGfdPR6yFY1UQm9O98E9wIaG9TEJgvQ
   5MH55or04RncACuXYvA9IKSu4V7Rkz3Zf5w/yzHXQEoTxJHgt/L99FzbQ
   S8Py+oURuuruaOtdZwhPg5EcDJaYlP8Ijznj1fkRmzIR8X7ofj0ufETyQ
   1LOeBzHchvbuxG0SgaHWDcDX2cB5ZDFKKfou8JST9z/aIdTubCtOJI/MK
   w==;
X-CSE-ConnectionGUID: 5DXbpyUQSZmY248O9vGneA==
X-CSE-MsgGUID: YXXAT0OOTsyILBBhwxYbwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="108462688"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="108462688"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:49:02 -0700
X-CSE-ConnectionGUID: VyLcM+fpRMG4zA1uPD/clw==
X-CSE-MsgGUID: qZ1vfIQ/Rfi813vIpp5Oqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="249521046"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:48:48 -0700
Message-ID: <47e32f37-ba46-49d0-919b-8c0889afb0ff@linux.intel.com>
Date: Tue, 23 Jun 2026 10:48:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/46] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-3-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-3-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: icp6n4aoicgrobchtfot76xjmny4aknk
X-Rspamd-Queue-Id: 48ACCA0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782182943-51755
X-HE-Meta: U2FsdGVkX1861/GERQbVYHflqD8q+d9teZsbDLycNOvzJCt8om0hqkQf5uFhAfyRBZWF9MsviB6WS7zrjP+hcNNQ/06nO8kt4XUpsqUp7qvAZ+gFXrme7/+UPcuzoooCUFiVjmJOapeoU3RMGTbHnUzB4umZ9qYUhF+SNgiTPFnBGsBYoH78QKp8uvIvzkiLxjER7U8cZIYpIhEJ6qnmGieHuDFQXqhfYdqN6X6Elxa8FGs3vTogV6F3+xbsl/uADD/yoiUTA6kxJ0CnNLrXtWkbx28CJ0njDavs+gF2SrQ7KBpGTXCtZsR9HMp+AFuxiqFD51HHYGixN2ZqYGKHGFMDlFf0VFnUL4+QCvcs05evNKfSz6LsvOMM1XTtu72yvrxiDuFM+2U0EAdgH3EMTisJhsyF0fTmLQyXDQjSON2M0vjWxkdbO7r8NicoHhPDJRNKRh48hxBqX7YOWSWUZLoMslVBR49U+N40EqIb7D1SPtTgx9jlq1Uqhi0Ox6E3aR3A6n93cS6L9n3xvxVSKQexM7WcunMXR7p4aZlQ/+FKX80PAXtw322cVpTYbU1aLA64nvJt3UIrMg5NlMsbjzxjt8nLml2TtI0EaTTz65NmY9MfLe9XJhdFwPmde5fIK/Zt5LqKjm5iKjJSSXrq/YcXRYEveLbc7cFKfoGLv2+/n4o12R8nB1Un5k4ibPJiusoK/Yiw3qkDU+4jIh4ZB1spttlt/xFEipoNkXnoQ7mEQWvbrRYBMy681g2zsNekwDtEiTSOo9X42Wam0z52v5/nV89wE2ltit08KmJzOfSpApqQ+tH9248zgLEk1tIyWi3WH4xmDG3qgSNYr0stONMnNPwCfumN4Ev3+B83Bjl1lvBTApjMexjG7v6aIRJNa3HK4nOLz9gB5NoT/FFBH4OcP1F1kN2BMKzVyg0V3v0dyVtTBgS3aP92Dj+jIdeCyKcR1bdV/BuF4IKjAXi
 AYeWTQOI
 1PaYQxM3n4Ad5Nb1gP5bEUCvSqdbbTdohFgh+ULHO2EMheOY9a5mRDaGALF1YU/Ufa2tJLg6N5sYnchG1VpNawDp2B/eXUJxTy4pBn2fhJZRddPQV2hU3g+aDEQV9/xDCLG/3pmclNSKSsBYRhsuxozZDVcDPMQW8lDysWa0PnhLdTUgSspo5uF1Fy+qJXjc7fZi+HTkznq6iCncPt51ocmFsRdzDGxbv8sAVbbrK6jNDA8WEMaNVBCoVBJKhoL5K2TGNhXV9j/h/gAjKCNCSZ0mp1sSGhcyZYNHuZWsuwFdf50HWOY7Cf/oqcge4dib3dQuURlQELLlPYI8Yw5ObDlLmyOLFanzcwfV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
> from adding support for per-VM memory attributes, because tracking private
> vs. shared memory on a per-VM basis is now deprecated in favor of tracking
> on a per-guest_memfd basis, and while RWX memory attributes are on the
> horizon, they too are expected to be x86-only.
> 
> This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
> user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
> Now that guest_memfd supports in-place conversions, it's entirely possible
> to run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.
> 
> Leave the code itself in common KVM so that it's trivial to undo this
> change if new per-VM attributes do come along.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>  arch/x86/kvm/Kconfig | 3 +++
>  virt/kvm/Kconfig     | 3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 26f6afd51bbdc..24f96396cfa1c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -80,6 +80,9 @@ config KVM_WERROR
>  
>  	  If in doubt, say "N".
>  
> +config KVM_VM_MEMORY_ATTRIBUTES
> +	bool
> +
>  config KVM_SW_PROTECTED_VM
>  	bool "Enable support for KVM software-protected VMs"
>  	depends on EXPERT
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 5119cb37145fc..297e4399fbd49 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -100,9 +100,6 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
>  config KVM_MMU_LOCKLESS_AGING
>         bool
>  
> -config KVM_VM_MEMORY_ATTRIBUTES
> -       bool
> -
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
>         bool
> 


