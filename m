Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02061CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472E68E00EF; Tue, 14 Oct 2025 07:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423E48E000D; Tue, 14 Oct 2025 07:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0A28E00EF; Tue, 14 Oct 2025 07:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16ECE8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:56:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5B9B11B054
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:56:51 +0000 (UTC)
X-FDA: 83996568222.06.9081F7C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BBA181C000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:56:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S4VqcUVq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLOR5+q/p7S4YJmEE2l0yvCfrYwsvBgNGhwGHJ8ptQs=;
	b=KU6uGqoIU7c+5Upik2U1esgdOdNsyCdz2POgu3RydBgLQd9lTCPMgluy9OAGEpGbrLYOZG
	PkkYt46l299oCvytVZv0s9P0AwsnhfUIzRNHsKI70n/ErMYF2qABpab0WkDmlUTvPvAPCq
	vntpimlYU9PZmPAV+PNICi00cBGtkfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443009; a=rsa-sha256;
	cv=none;
	b=WNW9GsbCgI8eZWmMIwtgleAY+QDvVBcZeErQC8Rt4JKpLrUTdI2UomkarHmr+7+1ppop/w
	Itb+PwC91llirLlQaITnBjFhCyACtpTB2f3IZEy1gnE/o4Fm5MxJ6rb+cEvEf4K948BBke
	mM7rTH7VQKeOAo8bq2G1+wuNhWn8hfM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S4VqcUVq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760443009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLOR5+q/p7S4YJmEE2l0yvCfrYwsvBgNGhwGHJ8ptQs=;
	b=S4VqcUVqZfxFycABqtryGhvQja0EV05X5/U6xn+uY4IFwPzqxuyXRNQaepcC4XuKsQh2dR
	yFre7yoFxg3gvoayhpdsFr3WiKsaFvsBndagNTabjKjwpksjg0St4zPrzU/Faunv7mOUrw
	G8leLuDqUVaqNlHk2hgefUHXHwBSxRE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-CSGadO48OCOAK5cqKlzTgQ-1; Tue,
 14 Oct 2025 07:56:44 -0400
X-MC-Unique: CSGadO48OCOAK5cqKlzTgQ-1
X-Mimecast-MFC-AGG-ID: CSGadO48OCOAK5cqKlzTgQ_1760443003
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F12E18004D8;
	Tue, 14 Oct 2025 11:56:42 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0A881955F21;
	Tue, 14 Oct 2025 11:56:39 +0000 (UTC)
Date: Tue, 14 Oct 2025 19:56:35 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, linux-mm@kvack.org,
	oe-kbuild-all@lists.linux.dev, chrisl@kernel.org,
	kasong@tencent.com, youngjun.park@lge.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
Message-ID: <aO46c6v/arlyo/nG@MiWiFi-R3L-srv>
References: <20251011081624.224202-2-bhe@redhat.com>
 <202510120456.vTSygUXV-lkp@intel.com>
 <20251011150408.b865cffc3a8fb8bf834067f7@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20251011150408.b865cffc3a8fb8bf834067f7@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kLwgu6_tzrX7U7pG7DRR4dFT6aMdAVygqValHWTpS8M_1760443003
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Stat-Signature: 135woi94r3oeeki55hnxgttg15onezp3
X-Rspam-User: 
X-Rspamd-Queue-Id: BBA181C000A
X-HE-Tag: 1760443009-434741
X-HE-Meta: U2FsdGVkX1+3CMkNQYvcT5XH6N2V8JLWVmsOfjdG6ARlG4HQWEtzrm8Cl3ibq/W2wzZ7YmCGgagXvoV1hEFKEH2BflhGHin7YSGuELx0GfyNc2dy8akbhbz0kAeFZtWByQ2Xlz9jkAhMALn8YITWpq31LbOoheZq3QvHt2koiObGSHuODOaeEsR6e4Uw57n18QvPncIyTnrjll4MvBIE8XbIjDlht/uuib5+k/POAPdzUIvm0eESsfvP4com9kPiYEpLxMlPPoaexoJINzem4H+D72yTgKMmRsLGsrbFAcLUxtrrlIIPUM6CN1UG+UxxTpRpEh7UdYHu2nIG7Ht38C3YHwzA0dv33j6wcjOi244HlKMPVmyOTiQ3ZNjPlhX7WJW37lX0A8In2FwFlFy7vxEjYOyrSme9ZQyDWMce5bmlv+kKXDJ9+TIg0yPJkvZARNEYPVv6X20YgDVdii3NGQjQiW5MxgJSvW9e73xmdp4NHaBzGNrRkhedTKP+bpBOgrOflmr2MEx8TviM2Zr0YJfQ9k9ZkELzxvQw0m5S8y2e9ROhUvuHJgdvblYvfYqsX0stYNGKXL78YSLd8uWWrw9NZGcCBsR4LylXN4H9JwbZ2nwhIip/RxtHDkjwluTHXZTJ7nYFejrckfon+ZlPGhpObGdk2F5KAqgDHDXzF4840dOKjY4K1Wt/IyHAdhj9cQmixEFAmadOUpXeivIHkDq/CNsJJJKssNuFXGXKVCI3jyvECFY9n600YoMrCXk9jjVle1HmHn44YIbjaUCAQreX01AYtcVVoBVhnbNIXue9W7JKs2X+LcKb9vaPpc3+YxVOQ2Mx22zdPJkoqYCm48bhG0OoqxQ0/8XuEmnUC0etpBBq/UpTRdWFaZe+xa0YUAO06bx0qrxgo7K0K11cf3Dqapcurd5uj2qXA8VR3ppsr0pd4F7VeRtPGDmkrZyzmkAGK5ueJEJ4ltX6dLL
 JhyYHW2a
 OWOOfxdlTf7w11NGGJZ9JhOBMCrWkn9y+2Q5eRR6q5GhvlOJHLwtC6bcmcfNqXynoxPm16oq8ZRWltE/cg5KCN91s1RXwbxUug0zLFwrcHCIDTL0+2UdCBN1h9kDTy0FUVP95vpZUHixNAyIgNA2e6xaJHsQGdmAVw/YrI4sm8xCSmNSGqIk/aBZKmvLvxrPgu8rpl35n+OBv+JvUJ0kJkrjy5xP3zXxN0FOlhtERR6LAAbWU4UXP+oew231dRcj5m03bc9mUOEGU+QjayQHTkfLDOa8QCSKyNH9aPY/OrS+jDS+uKegJhzIzXOV2qkebpmpEbKqIHsjxWassM3l5T9TSPkIevV1aaWlZ7IaxxcrQFfy/QwWEBJ7Js1ztvAn+4TSR22poVJoDQ0WZawUawzL3MJBh/irWWILHbMxqaJ2C3rBkdSDijxiY8UF8LAFlNkr4HoizG9sx4mpg2r4RBW2xv2GnhrGQTDTaHt7CU9UzNe1xHHqFu/mPD0ZxxZywVr8jUr8jV/2wAPP9aiuzgDUqUPKPFdTyjZ7LNePr5tlJYvZTDf4fyOWf9xz2kUNCpDcBUodYCMWuZNicu50uiYqCjLZAm6yd8ndE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/25 at 03:04pm, Andrew Morton wrote:
> On Sun, 12 Oct 2025 04:45:07 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Baoquan,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on akpm-mm/mm-everything]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swap-do-not-choose-swap-device-according-to-numa-node/20251011-161743
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20251011081624.224202-2-bhe%40redhat.com
> > patch subject: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device according to numa node
> > config: i386-buildonly-randconfig-003-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/config)
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202510120456.vTSygUXV-lkp@intel.com/
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    In file included from include/linux/list.h:5,
> >                     from include/linux/wait.h:7,
> >                     from include/linux/wait_bit.h:8,
> >                     from include/linux/fs.h:7,
> >                     from include/linux/highmem.h:5,
> >                     from include/linux/bvec.h:10,
> >                     from include/linux/blk_types.h:10,
> >                     from include/linux/blkdev.h:9,
> >                     from mm/swapfile.c:9:
> 
> Thanks.  I did this.  Baoquan, please review and retest?

I finally got a system, retest this patchset + the appended fix, all
works well. Sorry for my mistake, and thanks a lot for the fix.

> 
> 
> --- a/mm/swapfile.c~mm-swap-do-not-choose-swap-device-according-to-numa-node-fix
> +++ a/mm/swapfile.c
> @@ -1388,11 +1388,10 @@ start_over:
>  static bool swap_sync_discard(void)
>  {
>  	bool ret = false;
> -	int nid = numa_node_id();
>  	struct swap_info_struct *si, *next;
>  
>  	spin_lock(&swap_avail_lock);
> -	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
> +	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
>  		spin_unlock(&swap_avail_lock);
>  		if (get_swap_device_info(si)) {
>  			if (si->flags & SWP_PAGE_DISCARD)
> @@ -2890,7 +2889,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
>  	del_from_avail_list(p, true);
>  	if (p->prio < 0) {
>  		struct swap_info_struct *si = p;
> -		int nid;
>  
>  		plist_for_each_entry_continue(si, &swap_active_head, list) {
>  			si->prio++;
> _
> 


