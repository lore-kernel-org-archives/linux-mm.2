Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DCC606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Y+XJe0mD
Received: by kanga.kvack.org (Postfix)
	id 6B6166B05B3; Mon,  2 Nov 2026 16:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666556B05B4; Mon,  2 Nov 2026 16:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A166B05B5; Mon,  2 Nov 2026 16:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 144916B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:12:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44DFBC022A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:12:54 +0000 (UTC)
X-FDA: 85391428668.14.D8A6D02
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id 988F1180007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:12:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y+XJe0mD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793653972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nANEZQK4xFg0YD+zRGerMysOHTqpeA01mG81DDXi2mM=;
	b=SIDT95MqID0fidBPSAjRDgg1V/aOs755S9ayKbjvA7R4wd5dhIAGpRB4/ZSFf8qnUFOsa/
	q3iEKIy4TYcoImdUZMNS4Rn9N4CJC97KgLOS1r8NYHfmPhc+c0PcjNyzhwt0odHeIzqeaj
	FcBzQtA7k8jOieXHqRpHmnZwxRwN3d0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y+XJe0mD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793653972;
	b=X4ueuydnnFFWaqH3WO48YVSUiWOUyvyFMbGGNCsyDG3eJtS+WStax5Dwfj6IjomNNTWn3O
	ctIAT0ZfFXwyFoqxDDFmxn2Ic0asGHNNVXxphuRiCGj9FsT882tIglinWLs/lzw86VKdL4
	L7XtSE8bUwEZXjQWDAq5Eg4qseO+QWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793653972; x=1825189972;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KZ1eoil6cKojL/iy28bE0qs5/GsfjCqRR3qOHe3n9FY=;
  b=Y+XJe0mDl2wOhZVE3OBTzQ8IxBGLktnRImbivM7Ye8T2Zq2j08K/UXDJ
   7XjRetpCIhQhbhlcEDl6ICSmlwzd5bPcnemgeTZ9gwPGdWLrnKRXmrQRP
   wQ8sufTfpSF6DewLriHuAIBnx6qkFOo4/ySBHG9DDg63YeIHehKzMOErP
   f7k4NaJRFGGn7TOpS5tLlv4FxEaju8vO4esDP/NPR8Zg+eFGieVzuFdpD
   kTT97Mqi8TezRwNh+FNx/iy5j9l8i2wxQNtnWIKJrDHUg8afdyng/XMZH
   GNDdFUYFKR99KyZ684oF19wZUBWB4YR8JQVtDKz8WM1SPQy0kqlZ/reSI
   Q==;
X-CSE-ConnectionGUID: oEmYo0LAS7yTD4qjGIhagA==
X-CSE-MsgGUID: XD5im2TbTTmc+r2uVr6M5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2467927"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2467927"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 13:12:51 -0800
X-CSE-ConnectionGUID: lrKfum/8RyeFUoUbBdp+FA==
X-CSE-MsgGUID: HE9JCVcEQyOEzT79fmOazA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6562758"
Received: from ray2.jf.intel.com (HELO [10.24.80.220]) ([10.24.80.220])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 13:12:49 -0800
Message-ID: <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
Date: Mon, 2 Nov 2026 13:12:47 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Xu <peterx@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102144001.342837-1-kas@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261102144001.342837-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 988F1180007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wiiep859ucgi3hu3s71nm78c5gx4dngz
X-HE-Tag: 1793653971-820399
X-HE-Meta: U2FsdGVkX19pl/CASzpKz0WGvjeCdGBHlFyksyri9w6ptqSYzSnpY1xTrqYFFkIPAtseTAOOHCSjwF8hAgjwZ4AsRg5GNaXyTxleagHI3QEzOavBfB3aGPXZ6C6Fei/cJNAfHIuYD7fS1xw4glaFsPBmzobK8/bPWTDB4JzVATT3BsVk6hG1hnq/z+9LIBiUoYCKxggVF/mivl1FigUqllvP3bgdQhG5G/MWhylQAvm/nz6c7fXsjc1VkgP/hadjnfrx/vRYvKez9Wu6P4XJZrr5ysmIWoX9lT5/8WMgz7HDk6Zvv/p77P2WcC9lTCQvjJZfIRVLEwasOAir7aGDmfEyyenG4uU/4xrIi/T3tLsmPWSqD4Ndcah2Kv8FU/V5+x2JqNNamaWIh7lv3/Hd3fLytxhg0iheG+XJEod9dJJFLgrpLVgbiewe8a1y5RG2RcSr+3108H/WLulDPxPFeDdf/FWF0H+hxJM/TRNwsU+LZYMK+9+/gUX3l3WU+yL/230V5YPYIM2gtSyBGt1i6U2w61BVc/knX6Xliq4RHyeoiJGzlH7qK/7YP3slh1Rxj8qPZ0UXs6eV7whIWEyx7Ol4p468xgjtckXbI62pznL/C5tPQwiZMVC4cR/2XQ5QaUcA6ml4nWxWOpmYTu5utZ55/yNkCf3WPuNN11Qi4r8Gae/jitCFnyXjQ8qxhx3OpjhMzeebwoXF1SB1XiqnqIceS0u56L3YXcyXTXh0uFmN5KPviDaKSlOmg2JZcedImDhcLjG5Cng44k9MAouXiCPQmbdziv4diw0yO46qewZZFGbwWCmov4TFYGQecGjNrSDG+kKF1AiIAQ1ePUaz2h4WwimWFOM3DePMv5T9iR/WxhPIYiSYM/ojwasL5CKMwSejINHYJjU17eLG6bNDCYYldG6cMtx3vQsYtGM95sjYtC5rY61VixfFqBvXO5sJN6qt66xwinubcrErqE/
 01RnIHgr
 5UtWC2bYLST9dwb686jkWi3tf4G8R9X5GdKX38ismBBWtEQ1xMffBxv4m02/xvRXe/nGPETqivmReJLGgM1f4M+boTtu6NXYsv/R4UWxltUhWUsNeaZfYIzL61BgY9RH3uwlrlmZ78phbGsZUvHkj1Znw6rSFmFfzG0cDf5vIST7A7EeZSZNowx3MBnpVfVJbo2pgoqF2Ru9ElAPWP37W4cNw1AIP4eNSPlRi/zwZAnWH26mnEyxxqGziIWawaqTk1tViqgMAOxkkaYfeO/YqfFE0DNFCL3GxYKE9xoJCeAWK6pnRAOnMYutHOShgE2e4ZJszIeBG0LE+B8BmlN3ektvYLTt2KISIdYy7e8Nua6YJqEfVDRV4tQzZow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 06:39, Kiryl Shutsemau (Meta) wrote:
...
> +#ifdef CONFIG_DEBUG_VM
>  void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte)
>  {
>  	/*
> @@ -823,3 +824,4 @@ void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
>  	/* See note in arch_check_zapped_pte() */
>  	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
>  }
> +#endif

So all these #ifdefs are because VM_SHADOW_STACK, a *constant* is not
available? That's unfortunate.

I dislike doing this gunk with macros, but I'd take that over new
#ifdefs. Or, settle the "does the arch provide these debug functions?"
at Kconfig time with an ARCH_HAS_FOO option. That could even be driven
from the x86 side with:

	select ARCH_HAS_CHECK_ZAPPED_PTE if DEBUG_VM

Or, put them in a new header. They're only used in memory.c, so what's
keeping them in pgtable.h? Another header could reference
VM_SHADOW_STACK. No?

Or, heck, I'm not that attached to these checks. Let's just kill them.

But I really don't like the new #ifdefs. It would be about my fifth
favorite way to fix this.

