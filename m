Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A19ECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E673B8E0005; Thu, 23 Oct 2025 04:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EDB8E0002; Thu, 23 Oct 2025 04:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7BE48E0005; Thu, 23 Oct 2025 04:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C21E68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:59:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C0C0C0A02
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:59:08 +0000 (UTC)
X-FDA: 84028779576.13.0F47719
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	by imf20.hostedemail.com (Postfix) with ESMTP id 54E8D1C0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:59:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=i9mBzOfn;
	spf=pass (imf20.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761209946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WdLCwMfglx2dxXIMaVQpbo0Sd8kcw8OyPwQ2cch7rP8=;
	b=r9Me4Vfa7jebXp0GBNvPaoIgWKXnKfTpRtpd+VeQEIVLDKieOT72BqdLlPQLfOnPqlDsoL
	RIRRDmRCELd6A7aa8zmDaUJwOp3llAjbU+EvTqMq/YWD/QQJIhu/sffbPFL4WtEEm5lhTS
	losl4RII4KY2MnjTMqWezy6mnlr3LHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761209946; a=rsa-sha256;
	cv=none;
	b=ZpRFw1Bhbfr8V2eU05Ndb9c7J7f1XHUY81gvJAtbGvhoK3azCQ2UAtBNZ5NQV4AHkoJ9uP
	37IzXm+/8BlmnjEKQn2FouBhb3PVXzWjpr7NcWEk5uce9CMLG70yO14qPM01EGVExhxSrx
	QqEY5j+hsroPP704DcxwkJFBfEWzuGs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=i9mBzOfn;
	spf=pass (imf20.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=WdLCwMfglx2dxXIMaVQpbo0Sd8kcw8OyPwQ2cch7rP8=;
  b=i9mBzOfnbmcQH2CLbM+o+8kEbRzFKagoWLCZgO6dZfgw9U7ysTo0oL7q
   iF0oUIQHer+9lj2655cy+nPNfqxbS72VhDfXtPzQ+OALi1KhJEzNUMHKk
   ud3CuZm5l8R/IERu7q/RsaPZYX2hx6UqjL+PihWRED0q/aL8YGJj3V9EP
   Q=;
X-CSE-ConnectionGUID: VO+lkm7PTwubYxkqNVE1eQ==
X-CSE-MsgGUID: qnUrElcZRAS4dBDknhml4A==
X-IronPort-AV: E=Sophos;i="6.19,249,1754949600"; 
   d="scan'208";a="128944836"
Received: from unknown (HELO hadrien) ([202.51.247.22])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:58:59 +0200
Date: Thu, 23 Oct 2025 16:58:56 +0800 (+08)
From: Julia Lawall <julia.lawall@inria.fr>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
    linux-kernel@vger.kernel.org
Subject: fs/proc/base.c:3279:4-39: opportunity for str_yes_no(mm_flags_test
 ( MMF_VM_MERGE_ANY , mm )) (fwd)
Message-ID: <a6e8f771-3934-61fa-ee3c-585dc6531da@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Stat-Signature: e5hmwkam7hhmg8bcz1yu7chrjxizj9oq
X-Rspam-User: 
X-Rspamd-Queue-Id: 54E8D1C0002
X-HE-Tag: 1761209946-624348
X-HE-Meta: U2FsdGVkX19NoGNGHszA5+2l0+R9LtoGXn1nlHaq5/ChMsSIE4o99cSU/equHQfqtMAYae7WnWvhkWuD4ZHHIgXRNrPEpHmrznwsfXhLB/fDNFAMNxTqHQsWUx6c0VHJtiE5/VZMh2LHrKtuncW0zS3ZYgofBWWg8H9bGSYntTRJqCdt0wJsRS516PksbGgZyXUOrt2SZ6kybfo4IJd8y6yk2EzKXzmqM+z1ZRtjHheVyPoX4KZJGNYtkMxKWWsMikF+Yp+5gHjc2bLxORPB2B+ZMzQGK05GqyMmsIQnyYUwYiY0Cylvp2i5WITCLAAnzIfS84U/zejZ39FPpBweH1H5mQ9tT7gn1Jilz9KXUHOyWkk39sQX/Lo/aXL31ByFAeicqbKJ7jrkHySx7dSEy4JDnnQsal2i5SBAwf4TG3zd8r8mYCJpQffVy0tUk0xmWyWjV/h2eu/Dwwewvv9yVkQAUkiaavYIQkmlQDc73St4G7tO88/IO7i8WjB2v3TKFMrCpnJgEHky5xCBBkonNwPJnCrwC386RRXtpzmEQyCqyRy+xeZdypS81WXSBU8wdYlpDgyfWwKhvQTVs1NRipjjk5UwfiA8op8r/vVsmVHms9Kdj5gBCLnMMBmfxIZ1dAoQxzJx+yRy5frPTnYYGMVVZK3iXiILbFvLolMabo00bSpD2mNFCdgzM2OOBzzYMHfVjNYz+VqXV4aN9iomLBQ7kJHUBpyaOmK7M3tUrBF5uKmhXXAqZwRl8gtbHewpuuqO7RJJ+YjRNv22K5lvOLMPPvSKWquZCD5O/SgWdkbhieAfumUWxUCeZN2HOUAvokzB4TeMqER7GSBBHrsWVWjSd9lP39m3pg7uCrKKWari5vvvGBth+wRTX8ankUq8pLNgAMaZR8OPcU4pLn1/WKECjAF/vBp9CBmCXlsVVKCUzDNGggv7TcJW79jaP+6r480T0j5VHzaIUnTpKSa
 YMJq7T6O
 4H87bZTEBYiI/Js8/rxnmwHnCEawpLiC9qXXdaLlHvmpcoJN0zs42Oa3FJMX7t9RCYyE2kqBlCr/UByT0tYLyvv7piVlzDuFHR/RcSxJpivqe9Tdh+KWrRXirvybzW3aoz0+lF5iErGGg2hJorIgSQj07g6cRhy/fAXXrDxeQBWmvO9zWj05jKBNQ2yZxINc6xBlv2g/TPZ6p4lFzKhx6+Hdd07MS2RnabVUcA2f++gzcmy94t7kSvjkAN8W1RlSsXsbaTJLH2pZf8RTOIW/3sAy9KbAU0SMViduCHWap4McjAzkx1qReS0iYEBeuDtwh8vugHqj3y7HIxl9Gy8Q8Xt4Bn1wyJgVmGvNTimXHSQpMRbHWdIOmpaMiFJ6cnjNOyTAfPrNOBf13BnTvO0ebUG53q/aZPOvSL28dnzqw9WhO2d03bMs41HXSxX53SRz8lLnRyOl5gbGc8hPbFsA+piLKDWiCOTkmdpHD1haJ2XgQUlcD12NBrNtSHo1JOrmILFqYv6X7DQ7j06hM9qM1uSR5ASLKNrLG57Vw5eNmqCpSr43WtqYAPLG3t+RWNHG5B8O1XrxJqDXBLfM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



---------- Forwarded message ----------
Date: Thu, 23 Oct 2025 15:29:09 +0800
From: kernel test robot <lkp@intel.com>
To: oe-kbuild@lists.linux.dev
Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
Subject: fs/proc/base.c:3279:4-39: opportunity for str_yes_no(mm_flags_test (
    MMF_VM_MERGE_ANY , mm ))

BCC: lkp@intel.com
CC: oe-kbuild-all@lists.linux.dev
CC: linux-kernel@vger.kernel.org
TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management List <linux-mm@kvack.org>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>
CC: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi Lorenzo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   43e9ad0c55a369ecc84a4788d06a8a6bfa634f1c
commit: d14d3f535e13ff0661b9a74133a8d6b9f9950712 mm: convert remaining users to mm_flags_*() accessors
date:   6 weeks ago
:::::: branch date: 6 hours ago
:::::: commit date: 6 weeks ago
config: m68k-randconfig-r063-20251023 (https://download.01.org/0day-ci/archive/20251023/202510231541.uVpbrSce-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Julia Lawall <julia.lawall@inria.fr>
| Closes: https://lore.kernel.org/r/202510231541.uVpbrSce-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
   fs/proc/base.c:3286:4-29: opportunity for str_yes_no(ksm_process_mergeable ( mm ))
>> fs/proc/base.c:3279:4-39: opportunity for str_yes_no(mm_flags_test ( MMF_VM_MERGE_ANY , mm ))

vim +3279 fs/proc/base.c

7c23b3300116907 Josh Poimboeuf  2017-02-13  3251
7609385337a4feb xu xin          2022-04-28  3252  #ifdef CONFIG_KSM
7609385337a4feb xu xin          2022-04-28  3253  static int proc_pid_ksm_merging_pages(struct seq_file *m, struct pid_namespace *ns,
7609385337a4feb xu xin          2022-04-28  3254  				struct pid *pid, struct task_struct *task)
7609385337a4feb xu xin          2022-04-28  3255  {
7609385337a4feb xu xin          2022-04-28  3256  	struct mm_struct *mm;
7609385337a4feb xu xin          2022-04-28  3257
7609385337a4feb xu xin          2022-04-28  3258  	mm = get_task_mm(task);
7609385337a4feb xu xin          2022-04-28  3259  	if (mm) {
7609385337a4feb xu xin          2022-04-28  3260  		seq_printf(m, "%lu\n", mm->ksm_merging_pages);
7609385337a4feb xu xin          2022-04-28  3261  		mmput(mm);
7609385337a4feb xu xin          2022-04-28  3262  	}
7609385337a4feb xu xin          2022-04-28  3263
7609385337a4feb xu xin          2022-04-28  3264  	return 0;
7609385337a4feb xu xin          2022-04-28  3265  }
cb4df4cae4f2bd8 xu xin          2022-08-30  3266  static int proc_pid_ksm_stat(struct seq_file *m, struct pid_namespace *ns,
cb4df4cae4f2bd8 xu xin          2022-08-30  3267  				struct pid *pid, struct task_struct *task)
cb4df4cae4f2bd8 xu xin          2022-08-30  3268  {
cb4df4cae4f2bd8 xu xin          2022-08-30  3269  	struct mm_struct *mm;
3ab76c767bc783c xu xin          2025-01-10  3270  	int ret = 0;
cb4df4cae4f2bd8 xu xin          2022-08-30  3271
cb4df4cae4f2bd8 xu xin          2022-08-30  3272  	mm = get_task_mm(task);
cb4df4cae4f2bd8 xu xin          2022-08-30  3273  	if (mm) {
cb4df4cae4f2bd8 xu xin          2022-08-30  3274  		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
c2dc78b86e0821e Chengming Zhou  2024-05-28  3275  		seq_printf(m, "ksm_zero_pages %ld\n", mm_ksm_zero_pages(mm));
d21077fbc2fc987 Stefan Roesch   2023-04-17  3276  		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
d21077fbc2fc987 Stefan Roesch   2023-04-17  3277  		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
3ab76c767bc783c xu xin          2025-01-10  3278  		seq_printf(m, "ksm_merge_any: %s\n",
d14d3f535e13ff0 Lorenzo Stoakes 2025-08-12 @3279  				mm_flags_test(MMF_VM_MERGE_ANY, mm) ? "yes" : "no");
3ab76c767bc783c xu xin          2025-01-10  3280  		ret = mmap_read_lock_killable(mm);
3ab76c767bc783c xu xin          2025-01-10  3281  		if (ret) {
3ab76c767bc783c xu xin          2025-01-10  3282  			mmput(mm);
3ab76c767bc783c xu xin          2025-01-10  3283  			return ret;
3ab76c767bc783c xu xin          2025-01-10  3284  		}
3ab76c767bc783c xu xin          2025-01-10  3285  		seq_printf(m, "ksm_mergeable: %s\n",
3ab76c767bc783c xu xin          2025-01-10  3286  				ksm_process_mergeable(mm) ? "yes" : "no");
3ab76c767bc783c xu xin          2025-01-10  3287  		mmap_read_unlock(mm);
cb4df4cae4f2bd8 xu xin          2022-08-30  3288  		mmput(mm);
cb4df4cae4f2bd8 xu xin          2022-08-30  3289  	}
cb4df4cae4f2bd8 xu xin          2022-08-30  3290
cb4df4cae4f2bd8 xu xin          2022-08-30  3291  	return 0;
cb4df4cae4f2bd8 xu xin          2022-08-30  3292  }
7609385337a4feb xu xin          2022-04-28  3293  #endif /* CONFIG_KSM */
7609385337a4feb xu xin          2022-04-28  3294

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

