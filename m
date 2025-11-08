Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2252CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 16:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33248E000A; Sat,  8 Nov 2025 11:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4458E0003; Sat,  8 Nov 2025 11:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9B18E000A; Sat,  8 Nov 2025 11:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBE9D8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:43:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A7AB5B49F
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:43:12 +0000 (UTC)
X-FDA: 84088009824.08.1088E25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90CA0C000B
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:43:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=drWTCoHz;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762620190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/SYIBvYsiWdLUmQ7gHQUgUlR2Dtru8IbvZizyK/sjU=;
	b=2wwvbu4GpmjN+HKFHeLmSKcVHnoFq7ocfQW3HbZvFjrITkMbCmO6B/1xqSkYFQAs+AChga
	5QEKU4K9ymkcPJDm5h2dSzh+Fqr8+tBcJUjxUA8iIvtZ5HhPVlfx/SRK19kkRW9p1tbY+H
	SP0mPfb6RQcOyD2Wb+UOzDRP4inAxUQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=drWTCoHz;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762620190; a=rsa-sha256;
	cv=none;
	b=3eS8XeMeudO9mgIlccK3/K76c/IIKL7d2Ce4hiBTXeGeNtuVpmQ2oJzn+Ncv2P6kPWghFO
	U404hAYd5rRKMCc35rFWQU2t9t1Q8kb6ILJ18t04wwAGNBivwK4vJ09Vpp/lRBFqFDHrS0
	a7GDhbMYu66BquFfH9MsAXl3AqvJB0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 518A644595;
	Sat,  8 Nov 2025 16:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3BAC113D0;
	Sat,  8 Nov 2025 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762620189;
	bh=XUVkFx72QpXYBR1BpK+jTHmcdZIEAoxO4YDddfxFpMY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=drWTCoHzvWrk72zxaF48gJSVEjnyYzFUvrTo1GaG3Q6NN7yaqI4C78yjSoPXOQBg9
	 kWhefy+AmNTp62/XiR037JnE/y85bO6+7oh6GO1mfy1w33ZiuknwaVCl46qpzjBRZC
	 aZz0/iNBNGOjvzF+QBmd3na67bMzcfGJgDL6vbek=
Date: Sat, 8 Nov 2025 08:43:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>
Subject: Re: [akpm-mm:mm-nonmm-unstable 129/139] mm/shmem.c:5811:23:
 warning: unused variable 'flags'
Message-Id: <20251108084308.8640699dc4f737c520841391@linux-foundation.org>
In-Reply-To: <202511081101.9sXNBrzT-lkp@intel.com>
References: <202511081101.9sXNBrzT-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90CA0C000B
X-Stat-Signature: ogaxt31nqrcetizbspj5eamyfotdatjr
X-Rspam-User: 
X-HE-Tag: 1762620190-704284
X-HE-Meta: U2FsdGVkX1+/X6HVO41EB3k1Yvsyuk7Zgg7nBpXqDsT6OhMj/M745a/oCVIdcvzy7VHbv0Uz/OhinQ4qZTEp9o1Yqg0dMm2CkFHKwQC2xb3V4Hwy0hkrmMD+1sN/REWkVclsd4r5SRxalRp7k6840RQ/rFxwX66VshKAXWZpBK2ziWYt3LEt2UI85dIaNWqB290w6/8CI+Vi7EiT9F1OjUnaz8eKurQKSUyd2VMwdrOPFVLj+oO7ekCIABIdfijaSjLFFACdZXqhu7rlTX8BcA+wDI74QNeBC0rFexjJW1GNZ8qkOi0uXWm2B+9rvFAtJSTcTjXnIBg7qRshsXK0FmLS90zf1ryvSoTHhtJ52yrzCk0/WpRNoFWiaFnRqM2MgIxG6wea6S9z3RMhcacJ1Fk727AjDP5K6rMljzclYdZcUgM9GPgZUn3T7yVRK3EnHy2BWBpYdMo49vUKPOYZo7L27lduRVrE7cHHo0bROxauovURZ6HD0OkGj8MAQ/ujDHi/jOXsVEz/OYvn/n0tVQDP42iYVQ9RGcnSmf/onKQHcdnI/2UleyUtZ7ytz3RRMlJMkZlKizOiewbSivzJ8etH4uKuDKcq+2rh/0+a1ETKWQQL9g/JzMzEG7oaS6Ku33jQjk0LS1Y/9Ae7yMOq/ygjjhXew3dcgsTcz++beO1yb+7xuAMCuo+qsXze3R/4KI+/KAE7iG/iZprJjgDl77DCnRCJ9MHaoNViS9awlqyNvZuVv8IAEj+jRFdjTtB7jyUPT8cbwy1FbFw1mfEnYOznZXpHiqkrNvOvFrbNqOHi89GOOxO8EDyeq/glu+DI+v1UOxqKdpoFb234XfGaNoAA57fv1l+xokCFoZHjBNTHEeu3S2aayFGi45XlPSnuQrmxxYo/H6RDZ1zA/Mi3zGRib/ws0DTbscPSpBDS3qYqJKla5QAJ7b1AyNsq3xFcvH07lx+rxtWhN6kdRta
 YHu8jZ4Q
 AvZmdC75NqsiGRHbEGmrfqbfzkMsQx8c1gXwH5HDbqE2Jr4mhzUknKw2kThDMXDBet/F0iKFh55ozge8lq2UbCFptTePcz3eTTouHB6VyjscolZbDqcPX5EeGJODakQxBwjisHQJgRdwPF5n2QQcqBAzv27EfOm1Jx4PFcLgR0V8IcJs+z0uEOmkkP+KOjN24a92mHrXLvhwMTieWzAJzJzEXGLR5OBBbazrDUCp3xldClcFbCWv1RFDXEPDx+kX9ptD/24OzSnWKldbG0OMydXBShbyBm23eeMfUx/YOrKBlgCioBYuI0rtKu0p7AlTKkJ5Mo13muEKObDI9PW7Z4D1KDstnsOBwegetI9xtUzizzibw+ALxJc8rPBmasNJi5+RsOHc6m0WpNJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 8 Nov 2025 11:51:06 +0800 kernel test robot <lkp@intel.com> wrote:

> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   2fa523fd0829356881811ce9553b707102f55bd3
> commit: 730fb8720d1ba209cd74692ece9766101e1fdb56 [129/139] mm: shmem: use SHMEM_F_* flags instead of VM_* flags
> config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251108/202511081101.9sXNBrzT-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251108/202511081101.9sXNBrzT-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511081101.9sXNBrzT-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/shmem.c: In function '__shmem_file_setup':
> >> mm/shmem.c:5811:23: warning: unused variable 'flags' [-Wunused-variable]
>     5811 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>          |                       ^~~~~

Yeah, thanks, that's reason #47 for using C instead of CPP.

--- a/mm/shmem.c~mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix
+++ a/mm/shmem.c
@@ -5818,8 +5818,15 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_anon_vm_ops			generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
-#define shmem_acct_size(flags, size)		0
-#define shmem_unacct_size(flags, size)		do {} while (0)
+
+static inline int shmem_acct_size(unsigned long flags, loff_t size)
+{
+	return 0;
+}
+
+static inline void shmem_unacct_size(unsigned long flags, loff_t size)
+{
+}
 
 static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 				struct super_block *sb, struct inode *dir,
_


