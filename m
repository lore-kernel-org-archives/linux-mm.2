Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70AAFCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 21:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23588E001A; Thu,  2 Oct 2025 17:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB178E0005; Thu,  2 Oct 2025 17:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937A88E001A; Thu,  2 Oct 2025 17:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82C3F8E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:19:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31CFE1A064C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:19:29 +0000 (UTC)
X-FDA: 83954440458.19.DD310F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 768BE1C0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:19:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SvZCz6sh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759439967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwfvF8yUrlH2GCCnn2uVFlJnkEr2tlUIPjVgx15uZVk=;
	b=jexrm+x619JX/l+CyO2PPKCgnf/ge5zb2uJPMXxnyCDk9XbGv0vfJ0z1gFCiUND1a1VIR1
	ozqp4lKyyX6iity5JpN1OtCQHpsnwzba6hTpW7RHFQ461vofYqaDyQ6OoAJ5qwez9NKawc
	snUQnBKm+JSCIvqtExkO34s195khwPs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SvZCz6sh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759439967; a=rsa-sha256;
	cv=none;
	b=jwwk5JWrevQvk1JWARSQJlWWxQmGJLpK4LMO11ZfykWEePUwoI2VWBkNAyoJRBmfTYKkiD
	1i+YnpYXinQ1LAiC30SwgfB3MA9lLi7T84OsLumBfjD+4RJxj/MJlqzCzSDh34rQdAx9QO
	Lgi+Rtlvw4PoC49x6XD3yFUGbVKAO60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CBDB40BF8;
	Thu,  2 Oct 2025 21:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD54C4CEF4;
	Thu,  2 Oct 2025 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759439965;
	bh=sROaSKwcO+5g1n7Ya+Dliv6C7a5EP/gyBulHIGWNSvI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SvZCz6shkwOtL+0TWDSpPW7H2mn8cdM8MjmpPjCZRJJnuy/uhDl5u/s7FhDxjTUbV
	 /n5o4mUZzkSZOQe2mP4Xam9ugOMbJNw2R725r4IEV4kZ+vz+NgJbl5URTg1fGvtTMQ
	 pVCabNOsuRlt7NqITWp8AdZJaveFb7VnyK4lO5tA=
Date: Thu, 2 Oct 2025 14:19:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
Message-Id: <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
In-Reply-To: <202510030449.VfSaAjvd-lkp@intel.com>
References: <202510030449.VfSaAjvd-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 768BE1C0004
X-Stat-Signature: 8txw1cku6rr8tpz88aktu7e8rifu1yub
X-HE-Tag: 1759439967-418574
X-HE-Meta: U2FsdGVkX19obU8m009Br/MElm7KW7sY/cSof/BZ7WiHNxMxEW+UjJJp/9igY7dQvtda6RD5SwEwdw4fHHjAsJaofCKwfsLr3Pp7fr4FIJ+VE/13fLujxUsMaPPGp+8S4SFt5YLuBFnW3bKVvBNVnd5Yon1T3fWgqVdXSAkomtYo/xZnawT9YPHnBbb0NqAVSQy9cCx/1ZKBGkHFNMap49Y6EQoRWuuiFcrFBzR2F7yiE7L7OWm2wDyzX3NQ8RBSm9b6yXbLweFQ+OEjaQuy+9TH3rOc2YSPWDoJ5vUd/aMcvuieNXhHcblswfzNdMMYXWaMHPv3sOMmqKNksLXaEtSngY5Cb6/xFx8w75prWqgK4PYFM45HVOndsDCjJpWLD6PfXB/gavWIJzgvt3WJe+GCkkISyTtq1ocDwQmB+Ol0TCIOoKVN21drzaB/fyUNNnUpGQfR0C46iZ8hoY3Jq7XnPWcwEXMn5/Yanbp5nc4hi4cHp6Na6tqRmHj3qdfntqvc8s2OrJvZ0eOdDkTR+Om/pEn9jsmzslPd52RYIJn8NW6xX+wYwV82/bdoWBuRAnqlevQIriAH4JHoPEIHp5ssMtFyfAxkoAOvMMwgCjNM87unjOrIaC+YIxXNPBgXBmNZACwH8Akm7VN8Stkf1ISYLEbocrAvlF8A3RvR1DFM8xHZc8xvPgsVkbQ1ttf8QZKb8a5ZUeYjwTBwr0XYRgxGm42kq8Z0I69g6hLHJuZmtjm1OgpqlpPaXGJBOL240CbW+h3Elh51GljwA0qf3mI0fPkRRWEh/cWnZ8PRDp2fMUHhx8k9CS2HucTADKYfu8WP8GzERIqRDfhQMNRRK8lmLRXg+Wpp2HXg2+zdr6FeWv+ye8yGoMT522I5v10vknOuWcx0EWLaUvz4B1wHL1f7L47naA5iCNR8DsyzyrYfmwV91frCu7gAbuueH3qWh8KksUVxoRylzZNYu4M
 judVGbuS
 KlNCsrXgFRbVQHZsiYLdChLtpk2p4JCY1q/tGF48+q+QIlEtlB1G8CHfJBTaBC5Ylge91W95swYkTKs1wkX3z573ea4k67Lf99JSPC6hLnpxNK0dI3lJNi4O0AblPSDYpxE1CjygFhCu7Aos272GMpXdJCdB68EO1Nw5Hrgmw7Z4qLVbHTGjKZj3YNSm1DyewqfwCDBmmnrLxV7GU2e06PurXGQ9dKnauWPJmq0Dm/a8q9eE1l302lu41AcGTHlEE3hAYrMLPebBi4f+91kZZKD1nECC5jJ51c6vCPFNtUkAhYqk54YZMFy6paOdG3uXx8kRf4SobDLp4qZbW15wuyjxE9a8XYgRGwpmUOWfqVA4y/oOUpy9FtGGY2/61kAQALcvIIhtkEsD3YfVX+7jjdt3QlaAZaUg/0NbO5W5kHkrk0vK0zpl2g7TCrvDE3r2p/o4ziEpSxzIvoqA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 04:52:48 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   7396732143a22b42bb97710173d598aaf50daa89
> commit: 8355c2312fdfe590a296b8abf9414ab7ecb49d1d [13069/13300] mm/ksm: fix flag-dropping behavior in ksm_madvise
> config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20251003/202510030449.VfSaAjvd-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251003/202510030449.VfSaAjvd-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> error[E0425]: cannot find value `VM_MERGEABLE` in crate `bindings`
>    --> rust/kernel/mm/virt.rs:471:49
>    |
>    471  |     pub const MERGEABLE: vm_flags_t = bindings::VM_MERGEABLE as vm_flags_t;
>    |                                                 ^^^^^^^^^^^^ help: a constant with a similar name exists: `MMF_VM_MERGEABLE`
>    |
>    ::: rust/bindings/bindings_generated.rs:7936:1
>    |
>    7936 | pub const MMF_VM_MERGEABLE: u32 = 16;
>    | ------------------------------- similarly named constant `MMF_VM_MERGEABLE` defined here

No idea.  Let me cc rust-for-linux.

It's a one-line patch:

--- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
+++ a/include/linux/mm.h
@@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
_


