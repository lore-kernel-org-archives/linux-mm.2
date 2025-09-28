Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2619FCAC5BD
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8134B8E0006; Sat, 27 Sep 2025 22:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB7B8E0001; Sat, 27 Sep 2025 22:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9DF8E0006; Sat, 27 Sep 2025 22:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2918E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:22:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10B2344224
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:22:45 +0000 (UTC)
X-FDA: 83937060690.21.F43C252
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E45C5A0002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:22:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3m4zRGd;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759026163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4l33LFaBlP7W725XV6EhCal5Ct1v4pxHGZqU1d/s068=;
	b=XLYCH3B4D4g5aBmVsgS4aW/322ju5cUrZTMGrqe3qFXKrMGzlFy0A/9wlTKElLFuTBHi3m
	Btzev8uqq77h4dSJ8ADmqm8MyFD3UR+jhDfJl4xdIout3Gd4W4LatBNse8FlsSPSmb3BaN
	+guCiS3y3VqT1SS6jQook0DKmeQp1IA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759026163; a=rsa-sha256;
	cv=none;
	b=m4l15fn+mmj6PxpQMM4Es1xnf6XgKP4eSG7yFwFAG8eMJPE0hL0adY6BeukpE0hum+WCL0
	5RLibasuIc/rybNRtLJQXLCbLUBr3gPQQAG5+HhyaTYV9jBx2D+8C5uACD84D9FTV16o8r
	xc3wKlWbvLyTfCDcQsJnf6CNdUptpU4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3m4zRGd;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759026162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4l33LFaBlP7W725XV6EhCal5Ct1v4pxHGZqU1d/s068=;
	b=i3m4zRGdpq1/ph6PWtMuo0kFR8tnEDWp7011dpTgWWG3rs2B/jqH8yDG7rdf+zoxp5KOBK
	MKrow33b1eijj7uQz2Gzb+ulopvZnC3Q4z4rwjU05oVr540mJrJ1S+JgKzAczY6O8w0Z0z
	OcZA3HiLmXUnHn0NknS15lEO+bZl33s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-UM5FlzYWPwGc3XX-OFD-XA-1; Sat,
 27 Sep 2025 22:22:39 -0400
X-MC-Unique: UM5FlzYWPwGc3XX-OFD-XA-1
X-Mimecast-MFC-AGG-ID: UM5FlzYWPwGc3XX-OFD-XA_1759026157
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC40E1800576;
	Sun, 28 Sep 2025 02:22:35 +0000 (UTC)
Received: from localhost (unknown [10.72.112.162])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81D7E1800576;
	Sun, 28 Sep 2025 02:22:32 +0000 (UTC)
Date: Sun, 28 Sep 2025 10:22:28 +0800
From: Baoquan He <bhe@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v2 1/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <aNib5FROJYwjcsa1@fedora>
References: <20250926155504.5122-2-bhe@redhat.com>
 <202509280002.NWLixh90-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202509280002.NWLixh90-lkp@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1WZdCgxqL6BG-4BjRy60GZvXKHWpvfV6S0xHyWRMSVE_1759026157
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E45C5A0002
X-Stat-Signature: woro1b7z1a6jgztbsmqrb1xj8bt6hig9
X-Rspam-User: 
X-HE-Tag: 1759026162-603468
X-HE-Meta: U2FsdGVkX1+ievRKN8BNoY9J5CTjlQGKgfjr86nQmzhWqinGriXHvt9LKo29TsZUVKj37PGmVokaZ9jsceUYAR3tTs3CsJXkICn4N2cM037ZrAzfX96NBTG7Ddyz97G7dQXfUc9Y8/4j+D3pBIXB9NaVN2wblu44IGaKH2sGcc+OG1A8HU93gQd3t+lFDut6FF7YoUPifBuF5NhPpKfD57gwtjbhHEWb7d66UhH4W/FWnYH5UDwDbC19sbWU+yzCpiPN6obd890KRL1bOjEwUis2D6GI21q+wPEMh4dj81mwW7y9KLAC4yLlK1op6DuhuWLGXUoRUOBbX3EW2w26qhIePjCKOlCZMKtiQXFUBs8FJjiTnmvxDtuSHYYaPMqQEYHWB2yeHAF1DgbrNlw63ooUPC0cwRRMHmCGT24Ypt3tlpKg8SfnPCY0gsPHVipW8C8cdGk2ycLFnJifxnXOluoXfjKTvrPtxXYwH7ywXO1ydakY/eatb/d9zHwyIZmcKuD+YTfTmYVoIRenspXBsca4I8HQ5Bgpa5d8MflAnPZ2MaDk9Pyzgu+fB4iDK5Ka6EeUZsbhb8Brv7vcEPTFgoNdqbCkl4vjs5lfEIQ7dndBedig4nHLhst58MkWTg/1DwqGmPZ9haBh366c3c90s7C0JYbXi8KEV56diBwdYgpTXaYoWCtJjPlUlU2b93WMOSZ1H8Yob899na/ncZt7CIHWrtOhOu8RIYT4So+qblf1+4YH2hehKM7Amjp6kpaAenC6qjduFJJW6/PUEOJi0Cc2esUV/Mmj2AAJ9mPXRJpG4k+GBQ0BfrDEYn8MPp6w4zlTaxswBLfqkvpAQWHnVHUTbb8jytHVZaJv3ho3mCRlDZCPvaanbcHsGUgHHlmJJ7J3t1d2+xRri4W7qStBFwprOScQprfHeIX2XYpWNsCd9QN6pwkSR/dfnUH8CyM7PArLlch8tusuVW/9GAy
 vwi6tXrx
 +PGGn7iYKRlARerwBL93GztDWAkhHfO8POu/If+ei0uKESp30ITU4QA2nm/RO+vpFA4obkmELZCqTKmR51sUlgueFBrdO3WDxwhC2Q5MVM8JjwXZTbjnoyNnbEQtzJVEi7HU+5bdAW3qnq1r47SUjjcuyGSAGgQ0realU5otYY2qGXm/jjliCsxaLCaj/7aMHWPYKANM3YEW1DfO5qRkmfHE1/1xccVna3tgv33dP1bDES0M24lPYgec7/+c+ZJzw1QUZevnSFieCbYBdaFHKU3NtIoQwxrRHpBpXE4QurfSHHUDkYbFSoFMWqCJUoAQm9KdiLRgbgxOAE4zkhExxqD0JFH8k3dwOexn8qQv2YE6oz3Z2TRDmJ2Mu6f6muGC4mDrKkXOHFO95Z8fuhx/jvDStWrCswIzANrYn76cnZBHI5NP4yT4Uads6pkLqFalLvyCcaoNuW5JbO+kf3cM19G5y3JPVL3Gypng07k5RIMLSIacFeR4LWQiTWD89aP88dIFv6DvfFVbm0d10UaTZn7dC5BwgOj3w2GPInJKG/ZOHNZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/28/25 at 01:14am, kernel test robot wrote:
> Hi Baoquan,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v6.17-rc7 next-20250926]
> [cannot apply to akpm-mm/mm-everything]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swapfile-c-select-the-swap-device-with-default-priority-round-robin/20250926-235740
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20250926155504.5122-2-bhe%40redhat.com
> patch subject: [PATCH v2 1/1] mm/swapfile.c: select the swap device with default priority round robin
> config: sparc-randconfig-001-20250927 (https://download.01.org/0day-ci/archive/20250928/202509280002.NWLixh90-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250928/202509280002.NWLixh90-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509280002.NWLixh90-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/swapfile.c: In function '_enable_swap_info':
>    mm/swapfile.c:2550:31: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
>     2550 |         plist_add(&si->list, &swap_active_head);
>          |                               ^~~~~~~~~~~~~~~~
>          |                               swap_avail_head

Sorry, I mistakenly removed the definition of swap_avail_head. I planned
to remove swap_avail_head in later work, but mixed the draft code to
this patch. I will post v3 to split patch as Chris suggested, will fix
it this at the same time. Thanks for reporting this, please drop this v2
patch from testing.

>    mm/swapfile.c:2550:31: note: each undeclared identifier is reported only once for each function it appears in
>    In file included from include/linux/list.h:5,
>                     from include/linux/wait.h:7,
>                     from include/linux/wait_bit.h:8,
>                     from include/linux/fs.h:7,
>                     from include/linux/highmem.h:5,
>                     from include/linux/bvec.h:10,
>                     from include/linux/blk_types.h:10,
>                     from include/linux/blkdev.h:9,
>                     from mm/swapfile.c:9:
>    mm/swapfile.c: In function '__do_sys_swapoff':
>    mm/swapfile.c:2655:34: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
>     2655 |         plist_for_each_entry(p, &swap_active_head, list) {
>          |                                  ^~~~~~~~~~~~~~~~
>    include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
>       20 |         void *__mptr = (void *)(ptr);                                   \
>          |                                 ^~~
>    include/linux/list.h:612:9: note: in expansion of macro 'list_entry'
>      612 |         list_entry((ptr)->next, type, member)
>          |         ^~~~~~~~~~
>    include/linux/list.h:770:20: note: in expansion of macro 'list_first_entry'
>      770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
>          |                    ^~~~~~~~~~~~~~~~
>    include/linux/plist.h:173:10: note: in expansion of macro 'list_for_each_entry'
>      173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
>          |          ^~~~~~~~~~~~~~~~~~~
>    mm/swapfile.c:2655:9: note: in expansion of macro 'plist_for_each_entry'
>     2655 |         plist_for_each_entry(p, &swap_active_head, list) {
>          |         ^~~~~~~~~~~~~~~~~~~~
>    In file included from include/linux/init.h:5,
>                     from include/linux/printk.h:6,
>                     from include/asm-generic/bug.h:22,
>                     from arch/sparc/include/asm/bug.h:25,
>                     from include/linux/bug.h:5,
>                     from include/linux/vfsdebug.h:5,
>                     from include/linux/fs.h:5,
>                     from include/linux/highmem.h:5,
>                     from include/linux/bvec.h:10,
>                     from include/linux/blk_types.h:10,
>                     from include/linux/blkdev.h:9,
>                     from mm/swapfile.c:9:
>    include/linux/compiler_types.h:507:27: error: expression in static assertion is not an integer
>      507 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
>          |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                                        ^~~~
>    include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
>       21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |         ^~~~~~~~~~~~~
>    include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
>       21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                       ^~~~~~~~~~~
>    include/linux/list.h:601:9: note: in expansion of macro 'container_of'
>      601 |         container_of(ptr, type, member)
>          |         ^~~~~~~~~~~~
>    include/linux/list.h:612:9: note: in expansion of macro 'list_entry'
>      612 |         list_entry((ptr)->next, type, member)
>          |         ^~~~~~~~~~
>    include/linux/list.h:770:20: note: in expansion of macro 'list_first_entry'
>      770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
>          |                    ^~~~~~~~~~~~~~~~
>    include/linux/plist.h:173:10: note: in expansion of macro 'list_for_each_entry'
>      173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
>          |          ^~~~~~~~~~~~~~~~~~~
>    mm/swapfile.c:2655:9: note: in expansion of macro 'plist_for_each_entry'
>     2655 |         plist_for_each_entry(p, &swap_active_head, list) {
>          |         ^~~~~~~~~~~~~~~~~~~~
>    mm/swapfile.c: In function '__has_usable_swap':
>    mm/swapfile.c:3835:35: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
>     3835 |         return !plist_head_empty(&swap_active_head);
>          |                                   ^~~~~~~~~~~~~~~~
>          |                                   swap_avail_head
> >> mm/swapfile.c:3836:1: warning: control reaches end of non-void function [-Wreturn-type]
>     3836 | }
>          | ^
> 
> 
> vim +3836 mm/swapfile.c
> 
> a2468cc9bfdff6 Aaron Lu    2017-09-06  3831  
> 2cf855837b89d9 Tejun Heo   2018-07-03  3832  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
> 0ff67f990bd457 Kairui Song 2025-03-14  3833  static bool __has_usable_swap(void)
> 0ff67f990bd457 Kairui Song 2025-03-14  3834  {
> 0ff67f990bd457 Kairui Song 2025-03-14  3835  	return !plist_head_empty(&swap_active_head);
> 0ff67f990bd457 Kairui Song 2025-03-14 @3836  }
> 0ff67f990bd457 Kairui Song 2025-03-14  3837  
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 


