Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A65D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C661C6B0022; Thu, 27 Nov 2025 07:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16C66B0023; Thu, 27 Nov 2025 07:59:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05A16B002B; Thu, 27 Nov 2025 07:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCA76B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:59:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4281F138529
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:59:31 +0000 (UTC)
X-FDA: 84156393342.21.381C117
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6980100012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:59:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI4FSWoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764248369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXWxOyVDhhNuII6gzr2ZqIIKMYZWzjDs2IKIrhfkpow=;
	b=ZniP/fwwjnVpOA34/bW0fmaXdu/93tZpN7lOytNnZxoGZd7dBQd9/PWJVT2x722grouwVZ
	9Uqhik/IRE2aRvzVwOY6FxZ/t06ECBq+R30rHDC5PXT4N8QLffENz4bmjwIaUkU47cm2y8
	aSBAPxVdVQC1iOGlEfa+L6PJaDUsUxo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI4FSWoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764248369; a=rsa-sha256;
	cv=none;
	b=I+QyeJ8ew3b9M03dN7+UqMm1rJ0ZAJWaFnRoFfsGGjuXrEc0jlR1QKoZrkMQ4NpWWIS0FI
	EvO9DJfe7vtuJRPIOtDPlVyTufXSUiSoWwL0fCOJ0zkNZTi3XDhiNg0ON1YWfpYJrWFwO6
	HB8jBmv51jCnWlwYqAON0+Rif42xaTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2628F60141;
	Thu, 27 Nov 2025 12:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21B8C4CEF8;
	Thu, 27 Nov 2025 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764248368;
	bh=9FAZ+a3Saa3K2w/qcM5YJymiW3fVjUChcc0PgFLP3kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fI4FSWoNziNxUPbDB6JkgJO1Yjnf6Bti878Qij6lf/sDn7w/gHEsxCWtwUKbfzIC7
	 1qXgeeNkfSyJhRfPo/0VWdYXYX4XMehPWqREme+oOWuyDGHPw8cDGW7ToctKEVSehA
	 ui5RCOiknFcesTzXJ2Ca6+7A1XjGiV6XEAGWE3VL9D8J+DKMcpJ1Z6B9X3diNElvPw
	 qwN9QiVjiXoWMzyQg5SknYsw+Gd2nxZApTimNOLjRHI5fhnt7oOZWcydR97/QNxkz7
	 +PgzdNbs94jarrIsGJ+qTzv5SBvS+hsNRz7eC90oioecBC1ZZaQmSWaMBECtd/ovl+
	 GIp6SjbV/s45w==
Date: Thu, 27 Nov 2025 12:59:22 +0000
From: Will Deacon <will@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de,
	akpm@linux-foundation.org, linux@armlinux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	wozizhi@huawei.com, yangerkun@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
	xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aShLKpTBr9akSuUG@willie-the-truck>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B6980100012
X-Rspamd-Server: rspam11
X-Stat-Signature: zdakmityxrujgf64t7jkcee1esyoi74d
X-HE-Tag: 1764248369-944861
X-HE-Meta: U2FsdGVkX18bz1ktRqA0kKKiKFOQ3LbiZi5L114n2ohGajU5LXlwwxqZhSak8dMsU2iV6eeY24yGndgaRnaS5XVesMRo53sdOnZqaG5PixN3iZYsrSTo5wXt7UpmgaEw5Khe2CbXj1tc7ja57b3r99tQrhHEt35i+cbELWTEv8uEOy+iVWli/L9WcriB5EZIvZS13BgYRgu7aYxmqQ4VpTDQv+/CV2NXCfRhjmSQdxjSQOCJUXi/kIiSP0/ZxUu3r5t3p9mznb5Q3isYGr4SEy9V7IFKU2AcYheSCeajH7jBParU27dOfY4GJpEJdpG70Y0OPrKyMTxL/onLwDk4d3Hq+eNrR0NgmAESIG6SgtueBGshTUira0Q9a4jkd0SW8kFslARjmjwZymZqJhI+rkdaojRCClFg9dPQknJd8Zt1JQ0NJFby2XyFN4TpjSquG/R3At94m5ka7VjQ8ZQ+tZzYyqTpjvbiPlJfKH32LPVWpW8+yIlxjWGNSVlqN/byoTMRJioqUDq+IUU379JZzQAZAXN+Zi/z+oQWm2Ef7hmA4xuHru5dLr05Rg2tq2KiacfuZyviH+YKi1WIfE+guVn+WRNVSTmAXKPHPND1/khXbsXjbPFa9Gs7ydCgvJIL6i/Qqu8wMaysPfweVYuI/qcc0BcfBOpbzf2ixHMtMXTMS8kb2NYwrq4NiB1LJdbT2imzPzkjk6eMYtotLpLH1wumL9biYpq7baYtf9zZHELAB+F3HoUmsIiZCvkMxv6tcoSQySDAfzVqefE+ofq9+OyosJY8aGorrSlcUVvpJR3s51zyXQxywcxdgD7Wyolgwr6qae2TbWajBo4OZU69RykNWBBreY1L9gcdzpqrsUbzZzppC5ixVhjJxpeLw3X7yNqWJem7oWv9gmXCBvLiox2rJy9cNLihdQzVqi/Ep+TX0umMKpBzJejZExs/Dw+PSvEeFcrqBU93/dbF4vJ
 x7xXlnss
 Qif3gXifMO9CKFiLp/C9b0f4jXwQp681nWQeN3T1LqupmyKUxFtmsCyHFQTYP7qTHCFuTtNVlM/G/uie1+l1wUr1upmjrlLi663kXZFcBb/+yTZOKRzVg3VPcGgPA4S8vU7/w3wyLBRv7KnkPM6eH2v2qfoGbw8qB6R+q27r+jHocsZLnZXLKMfoNVEOiASLpVIRqD0rmzqS6SzykJGAgS4rTqq90I71iTttBO5nW7AUtMRFDRQd0I4e2Ec1Za8Pjozz12GzB+4f2w7FruYv5HG/xqatEXDKX0+GhO/b12MA9QXc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
> We're running into the following issue on an ARM32 platform with the linux
> 5.10 kernel:
> 
> [<c0300b78>] (__dabt_svc) from [<c0529cb8>] (link_path_walk.part.7+0x108/0x45c)
> [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>] (path_openat+0xc4/0x10ec)
> [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
> [<c052cf90>] (do_filp_open) from [<c0511e4c>] (do_sys_openat2+0x418/0x528)
> [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
> [<c0513d98>] (do_sys_open) from [<c03000c0>] (ret_fast_syscall+0x0/0x58)
> ...
> [<c0315e34>] (unwind_backtrace) from [<c030f2b0>] (show_stack+0x20/0x24)
> [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
> [<c14239f4>] (dump_stack) from [<c038d188>] (___might_sleep+0x19c/0x1e4)
> [<c038d188>] (___might_sleep) from [<c031b6fc>] (do_page_fault+0x2f8/0x51c)
> [<c031b6fc>] (do_page_fault) from [<c031bb44>] (do_DataAbort+0x90/0x118)
> [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
> ...
> 
> During the execution of hash_name()->load_unaligned_zeropad(), a potential
> memory access beyond the PAGE boundary may occur. For example, when the
> filename length is near the PAGE_SIZE boundary. This triggers a page fault,
> which leads to a call to do_page_fault()->mmap_read_trylock(). If we can't
> acquire the lock, we have to fall back to the mmap_read_lock() path, which
> calls might_sleep(). This breaks RCU semantics because path lookup occurs
> under an RCU read-side critical section. In linux-mainline, arm/arm64
> do_page_fault() still has this problem:
> 
> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
> 
> And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
> dcache name comparison and hashing"), hash_name accessed the name byte by
> byte.
> 
> To prevent load_unaligned_zeropad() from accessing beyond the valid memory
> region, we would need to intercept such cases beforehand? But doing so
> would require replicating the internal logic of load_unaligned_zeropad(),
> including handling endianness and constructing the correct value manually.
> Given that load_unaligned_zeropad() is used in many places across the
> kernel, we currently haven't found a good solution to address this cleanly.
> 
> What would be the recommended way to handle this situation? Would
> appreciate any feedback and guidance from the community. Thanks!

Does it help if you bodge the translation fault handler along the lines
of the untested diff below?

Will

--->8

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bf1577216ffa..b3c81e448798 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -407,7 +407,7 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
        if (addr < TASK_SIZE)
                return do_page_fault(addr, fsr, regs);
 
-       if (user_mode(regs))
+       if (user_mode(regs) || fsr_fs(fsr) == FSR_FS_INVALID_PAGE)
                goto bad_area;
 
        index = pgd_index(addr);
diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index 9ecc2097a87a..8fb26f85e361 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -12,6 +12,8 @@
 #define FSR_FS3_0              (15)
 #define FSR_FS5_0              (0x3f)
 
+#define FSR_FS_INVALID_PAGE    7
+
 #ifdef CONFIG_ARM_LPAE
 #define FSR_FS_AEA             17
 
diff --git a/arch/arm/mm/fsr-2level.c b/arch/arm/mm/fsr-2level.c
index f2be95197265..c7060da345df 100644
--- a/arch/arm/mm/fsr-2level.c
+++ b/arch/arm/mm/fsr-2level.c
@@ -11,7 +11,7 @@ static struct fsr_info fsr_info[] = {
        { do_bad,               SIGBUS,  0,             "external abort on linefetch"      },
        { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "section translation fault"        },
        { do_bad,               SIGBUS,  0,             "external abort on linefetch"      },
-       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page translation fault"           },
+       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page translation fault"           },
        { do_bad,               SIGBUS,  0,             "external abort on non-linefetch"  },
        { do_bad,               SIGSEGV, SEGV_ACCERR,   "section domain fault"             },
        { do_bad,               SIGBUS,  0,             "external abort on non-linefetch"  },
diff --git a/arch/arm/mm/fsr-3level.c b/arch/arm/mm/fsr-3level.c
index d0ae2963656a..19df4af828bd 100644
--- a/arch/arm/mm/fsr-3level.c
+++ b/arch/arm/mm/fsr-3level.c
@@ -7,7 +7,7 @@ static struct fsr_info fsr_info[] = {
        { do_bad,               SIGBUS,  0,             "reserved translation fault"    },
        { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 1 translation fault"     },
        { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 2 translation fault"     },
-       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "level 3 translation fault"     },
+       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 3 translation fault"     },
        { do_bad,               SIGBUS,  0,             "reserved access flag fault"    },
        { do_bad,               SIGSEGV, SEGV_ACCERR,   "level 1 access flag fault"     },
        { do_page_fault,        SIGSEGV, SEGV_ACCERR,   "level 2 access flag fault"     },


