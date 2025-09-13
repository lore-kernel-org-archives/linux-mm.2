Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D77ACAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 06:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB69F6B000C; Sat, 13 Sep 2025 02:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E673E6B000D; Sat, 13 Sep 2025 02:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C8E6B000E; Sat, 13 Sep 2025 02:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C651D6B000C
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 02:03:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B0C8160A2D
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 06:03:17 +0000 (UTC)
X-FDA: 83883184434.19.5D9631B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91AD41C0007
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 06:03:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QlIoFsxk;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757743395; a=rsa-sha256;
	cv=none;
	b=HRT0NSotGUuCAvSIMHHlXaZ0HrSBHb9AXo5gi1liJ6vRE+L0MZPp9gl09TNLMVH3p/bEUt
	jfnMctS0AhrTUq7Ejbhl9ZXlreeHg9U8h6LzEyoNsn3b5zBaSDRHr/KdCVb5A0F8L+ir7N
	K1ypcGRD9QEK1wd9aETIzy0Nt3MmDR4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QlIoFsxk;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757743395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODn/RaQ7HllzgLWgKG1lLWRUxF9cs+Qtzd2RPVVjvtw=;
	b=pwkYfgexfG8bnxwJ+jRlvrgifJHogKCCzxUoV/ArENcekw6yWQRwC322NEkBDE8jUf6HIF
	I+P1VLH01nt01nmeOMyi3DYkyztIzbocKMl7JKajK6Lj6oydNH/fQYGc5FYYpshpcjOlIO
	EIIcCRNnAeltcThM0I6CJVVRO5ymZzE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 224FD44437;
	Sat, 13 Sep 2025 06:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD6AC4CEEB;
	Sat, 13 Sep 2025 06:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757743394;
	bh=OPDGHPzQlXuajBD01izlcWwSw/TlqiRzn+DG2j9F9IU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QlIoFsxkv9E57eNIZrt3izyxqL5/+yb257rlCI+y7Vgf+G7+kZ9at8LrO9kNavjos
	 mRdMOy1ruxCK3N0+DP0pCJPgEaTItisd4p44dzAiHvToFFF6NCNV4jkZaxjT5XhTrd
	 21HGTdew+wfD/lLmrkJ525HRKxecw8Rj7C/yZLDQ=
Date: Fri, 12 Sep 2025 23:03:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-unstable 39/428] include/linux/pgtable.h:235:36:
 error: expected expression before 'do'
Message-Id: <20250912230313.117341d5491a3145e7bcf311@linux-foundation.org>
In-Reply-To: <202509131255.x9EfvIGt-lkp@intel.com>
References: <202509131255.x9EfvIGt-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91AD41C0007
X-Stat-Signature: 8yttaaysdaftrhab8gnseh3xaw6myjfw
X-Rspam-User: 
X-HE-Tag: 1757743395-499313
X-HE-Meta: U2FsdGVkX18daLdnt2VyDMcntlcwUF0iWeef9d8o3SdxXw6xrDhSmkjV/VxuwZmb4oYWxhM+S+OyGRwH4klHd2FtcVp9L/l7wFiQKBdRrZchYcJ6FOc6h0r/ou2NGRk4d+zMbKYVvODWE2Qo0W3cET7gQQlZevGSrZ2F7RgLHg55supWQ30ahc91FK3jL+d+NmpPk6cIaIGvni9S6whzu7sI6lq+HkdNrJr8LAyMVVMCbdRE6NOq2cTrXZ6jahhcIS5n8mToKVa4FWc9p2LJEKeq4Ke0okT3htrV82hnbKDBmTSuDA8uJPEEn3jV6cQezabAO+VWABjOzUduIUtgm4TslClOpbOtPJ8n4AILF2MtaHVyseq7TsbQZ0j4KX9MQ+rdmWgAlocl7Epr+cXZyt0GxvV8EgCLO3qaf14wi7YouOwjOLkkNIOYSE05avFOhGssWyq3TbnMlXN2cUAjGr1P6Csn1J6vw5duCkCJUib04HYRR5VVqYzloP6Q7yn3PE1I7QCX9vYB94pgTxcJTaPI29ChAMzC1bO7LdcmieXnHSWIble4LMAyJ2grQ7DjDjnT4EM468ojPnrxOyhaVzAV/zHcIlpEGQTlAgw6+qN3Ee58X9opMxbwEoQ8NwV7iUzQgv75lqW8YHeTvj7ZQansuJpsz9FQ4qIVerQHGcyQJXKpGid09AR2iJ5AQTHpWm7itQTAM8cIdD2Cv4DYi8ty17TGAzRlepf14mExsEZFAnZYGqNooCJENc+3dXVlRPKxM1B4Dk83p9T/YJzmKbI5VWp2RCrdUTmCbyoK+k6KczljS95FqWsg3BIHE8C+7iyZl6Sz6StJaE5Xiob26zGGGSW906CrH6jbYq3rrEnjAWnrCm0a4bzg96zEmyUgfj8lBG7xINAtN0ikbEfau0by0oHv0S+N7ZZMiaUHAnU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Sep 2025 12:53:27 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   8ded915c4409a5190b1c9c57c172d62ab5534274
> commit: f6748cc302fdca7c486c6098f315bd4174f5c614 [39/428] kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
> config: s390-randconfig-002-20250913 (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509131255.x9EfvIGt-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/kasan.h:37,
>                     from mm/kasan/shadow.c:14:
>    mm/kasan/shadow.c: In function 'kasan_populate_vmalloc_pte':
> >> include/linux/pgtable.h:235:36: error: expected expression before 'do'
>     #define arch_enter_lazy_mmu_mode() do {} while (0)
>                                        ^~
>    mm/kasan/shadow.c:322:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
>      (void)arch_enter_lazy_mmu_mode();
>            ^~~~~~~~~~~~~~~~~~~~~~~~
>    mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
> >> include/linux/pgtable.h:235:36: error: expected expression before 'do'
>     #define arch_enter_lazy_mmu_mode() do {} while (0)
>                                     ^~

Huh, thanks.  Another reason why static inlines are better than macros.

>    mm/kasan/shadow.c:497:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
>      (void)arch_enter_lazy_mmu_mode();
>            ^~~~~~~~~~~~~~~~~~~~~~~~

You can't do that with them!

I'll add this.

--- a/mm/kasan/shadow.c~kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
+++ a/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
_


