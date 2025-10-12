Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710C2CCA476
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 02:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB118E000F; Sat, 11 Oct 2025 22:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B5D8E0002; Sat, 11 Oct 2025 22:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A448E000F; Sat, 11 Oct 2025 22:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 620778E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 22:09:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CF4511ADB9
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 02:09:00 +0000 (UTC)
X-FDA: 83987829240.12.853C05E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C9D6540004
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 02:08:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Sx5/04B2";
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760234938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYwW5kylGmaXKnmK0P7Fw+OgNfWxcAqI5580HTuaOhA=;
	b=BsFq4NUXn1t54eAjZsAJdBUrSn4KUwe45WtPy6MxRciQAKwl3+/jpS3/fdqJ9xv9FhFYpz
	/d63E+5wQRBSEUgTX8UHenhfXg6NrqUPY0B1pcD33O93smn0e1RSN9jCyW+ek9X/4jG0Kg
	Pe21JTRQGDfqrQ4TrNOlEOF6eyKCyN8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Sx5/04B2";
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760234938; a=rsa-sha256;
	cv=none;
	b=EnSgpt8d6JByjwa6T5IRYhJzjZiIetb5GhX65u9vT55+lo7wZMrGrFV43Jz9YMutnxwlsX
	F7q98yb9NAEJPoRdSUqDHpsip9mORDMEMkRxb0DAAwGCl32jQhTw4RS2SigBUz2Zize8vm
	uyZswHf2GpwPxLlHx5sl1w9nUU7qFFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760234937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pYwW5kylGmaXKnmK0P7Fw+OgNfWxcAqI5580HTuaOhA=;
	b=Sx5/04B20xzd5hTC44lZNeLLfss06JOKgTl9YYgYLrVtIJXdWniEWsQnc8cJ1pH4I5Cbt2
	Fljscg2mEOeYXQvZ0DmiLql61LoKpOwlAS1q5qI4Nf5UsGr08y5oMupZURyB8KTxEs7dtI
	30ij38PaF/2eH4rxLUvnBSBZVz54bO8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-fV6xpNoRMrGp8WJJFyoyEg-1; Sat,
 11 Oct 2025 22:08:55 -0400
X-MC-Unique: fV6xpNoRMrGp8WJJFyoyEg-1
X-Mimecast-MFC-AGG-ID: fV6xpNoRMrGp8WJJFyoyEg_1760234934
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 888FE18004D4;
	Sun, 12 Oct 2025 02:08:53 +0000 (UTC)
Received: from localhost (unknown [10.72.112.25])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A49D19560AB;
	Sun, 12 Oct 2025 02:08:51 +0000 (UTC)
Date: Sun, 12 Oct 2025 10:08:47 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, linux-mm@kvack.org,
	oe-kbuild-all@lists.linux.dev, chrisl@kernel.org,
	kasong@tencent.com, youngjun.park@lge.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
Message-ID: <aOsNrzBI8hSdnGQ1@MiWiFi-R3L-srv>
References: <20251011081624.224202-2-bhe@redhat.com>
 <202510120456.vTSygUXV-lkp@intel.com>
 <20251011150408.b865cffc3a8fb8bf834067f7@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20251011150408.b865cffc3a8fb8bf834067f7@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D_Hq8unIaJ89IUuLYLs5dvZHLS9Lcp-2m8z30SDr9Ic_1760234934
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9D6540004
X-Stat-Signature: 34ggfesibgqb7q36cj4jpe4swgbphjik
X-Rspam-User: 
X-HE-Tag: 1760234937-554496
X-HE-Meta: U2FsdGVkX1+++rKycGrqe82yuXgoemuC+cLHcD8H6ZhZQCu+kCfdiZzp5wnr0C7EH83ZowRFBfxazm5+LLTA1tzq7hkAazWPeSnSMIyqIEH4vd8wjKYH2slwcBD0044cH+10sIx5FGXwlHs+qB543YPgsHkMn7SvQ3ls380FkFB5SpfJappgUqm3Ucx8EHGrDjOdNi3A//MHKC6HNeUCzykBaFiCg8Ruty2loBbuQWwFbBCU5fkWqLd2jXJd3eEeKgBfZUWTJTzbmcViD7cieTdn51WAeiSSynKTEUTLPrEkHPuN4OWVghTi+5sTTWMCvXuHk6XCEiQLIBD8lk0dP2ZGyG6UBbOWqKXwKlAHA1DAXLUmKvOR0NWEG6nuG4CwY+OlrZ3X7D1/HVUVTTBlbp+B5nuzJurRBuekkGPLzElajPlkKyJwDEGzhyTTixVlGb+40zcAIdpzRPBzruX3sWTJtLgH35GQ765i6+Qq1SX7AtwyAYSjhcBvgtFIiwLvBdEPNkDKMbdD1tQAz6wRb+vhSHUxnfFI/jC76R/aAxU1ANPbiYhyoGqICd8VY6geDQNT4tsXFhSdHocsB/7YCmk1SsvH/LJzzvFclPZpdkSdb1EFjUfTDbTTuWkjHxMDmdntouA3mTgb7p0UN1F++fJbL1XjFpi5ALeOIgdzYUh13TJFdmXFcYZzxUuCbGrpi9PvKxu9VSxgEJ9jLaBd/gZqpGpylX0SkjSmrVHpEK9lnPGelFRRXU4n7ABmvaqjO598fZ73nka5zpIO60N2+iQ0FHW7FgBz4FNkCh3EQSUruKEzOkuRA4Wo29aKbpUQ75seJYbNAD0JUGjHfeHvpyNNGUPKYZqkeW6i0DMyMyg2Su6npo/QElonS2kbpZ19o6H177UXxiVsHF0VKG6mSwbreEAO9ArkItiOB37BjcaF42LDqfc0cbjYyW5kb/ohDF0rE19CagKwPK0NCqL
 EzFIrWNQ
 QGG+aiKZe9C58eMMmGYXoVxv44njhaaYse4olG82WMnzUUn01dbRDCuMd8neF6zZCIrTXCDYOsJQIrQLez4GxjbUrjQHPHhkUMu/iFVZ6vHA6Qz5TB+eIi+0Lh+iNcaActK2PmxLkFmJPy9+qDY9dldIo/NnoMep/aiDRO/6F1UHL6D9ZjXR3KnwH8WBOM3/oI5Wgv0Hc5/jZqTWRiwtILkliyBRo8oKyzhIAMAvNOKk8sTDufq+4MBoRYM0G8AXegM4cMnAmZ11Pe/KI+DXSzrxMQjEvNmHZmXY83oLAw/EIl1UVdp64lwY5YBCdcbRynoBrtv/HRMFSKihHEHOX09ApJ60/veRRwrTqz/EE4JjHSFqu0dUAbxj12UiJxPcNXBMA1ofUS44PEDs8I73kRj38KypEmml6WwjYrEbfQ+OXT/GPBxtbnJ5a8Kjssz4tfRI1Bw4naDFFnD/vYRVbut3F2ws9Ea/q79/yFDvdHYbe3aPjhTYpqXhpWMGCOQ7nXleOS9Xvwt6OfLhNSTvrjyaQjzSoMu69lvUrKZNchUSkj8ayb0NWTqaQJODhqIVi0Lq7DbHVVMOnTB7olCIHcbktrFwsdHCzZ+AY
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

The code change looks good to me, and I applied this on top of my
patches and build, the building passed, while the link failed. I haven't
got the reason. I will go outside now and will be back in the evening to
fix the linking error and test.

  SORTTAB vmlinux.unstripped
incomplete ORC unwind tables in file: vmlinux.unstripped
Failed to sort kernel tables
make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 1

Thanks
Baoquan
> _
> 


