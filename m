Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED810CA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 06:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0097E8E0003; Mon, 15 Sep 2025 02:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC5B8E0001; Mon, 15 Sep 2025 02:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3C28E0003; Mon, 15 Sep 2025 02:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C24B28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:20:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 498861404C5
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:20:19 +0000 (UTC)
X-FDA: 83890484958.28.0572726
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 13F8220009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:20:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qk5FjaMF;
	spf=pass (imf13.hostedemail.com: domain of coxu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757917217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cBtHKBe6RRB8Snk7hpO1mjWCGkijKsQ31tvgy2vEzE=;
	b=55MP8Azlgc+ICaJprP90mzOMZczkW6IvJNpI8xMLsoaULCYnW9/vg3Wv6wncoOOvHWVApC
	nPOUOEamV2kJseXGufDdzxp7pWiKx6936zUQIwilRrasCPr26FjzIxriFxFrABvbEQXuWi
	HOAFfq0Z9MohipF253JB3bOZRBXJ+iA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qk5FjaMF;
	spf=pass (imf13.hostedemail.com: domain of coxu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757917217; a=rsa-sha256;
	cv=none;
	b=ZgKUBWeZRI5mCLlbgGgmU9RVpZ8+Gle94K4XaNJTbox1yzTY/+XMyNsiMLzIq/1zX9Num4
	IW1MNTimuXnzlHFV7PSkBu37h9Fw2APNXchCkvMSXWDZqccycvpy1CYVxZ1R0mXgYjKYOr
	lpRLAxwlt+CLvDRU42jR/UeW0eiDBik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757917216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9cBtHKBe6RRB8Snk7hpO1mjWCGkijKsQ31tvgy2vEzE=;
	b=Qk5FjaMFFz47s8zMcazcG+eLpj9pOno6+YtjDmQODpFIWTUtB/0wZEyin9bCQfMtGtcc/o
	5PgRzSAmyNx9JfpK2zd5lCnUVzWXRkjM0GIqFCivnPw36OX85VRalyVgNBSrJaCTAglwbF
	bHFm/oPOYddyZxAErZLB7RcwPzdNfto=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-K68UhoBpNXK52Oldy9h9Zw-1; Mon, 15 Sep 2025 02:20:15 -0400
X-MC-Unique: K68UhoBpNXK52Oldy9h9Zw-1
X-Mimecast-MFC-AGG-ID: K68UhoBpNXK52Oldy9h9Zw_1757917214
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b54d0ffd172so363528a12.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757917214; x=1758522014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cBtHKBe6RRB8Snk7hpO1mjWCGkijKsQ31tvgy2vEzE=;
        b=Ha6naREqRlZAf4gY9pfN1nXoBvgtGzv7K9OlA5PS/HVoe6Ha+CbuPWHZAb397V+xAW
         nJJ2xC1xJN2TUWCT9jk76GeZ8dPyIYGV054FHssHCDU0o6sEeD+gj3QtlTqMlBUnyK5o
         rtEM/vE5Qj4jar5WiT7cUBKpjCcx9126iGsMjJlg6M/GOQvswialOnTHiTMquICcp3jL
         5YKCMjKgTWV8FUAzaoYXnOk985Wj52Pxkpxk6RSxkp9AsV816hsqHvDUidhdC6jT0kXN
         1dg08utRyCGVi5xBzhiOFNIGSKWaAt7ZaWrop6wI7wrgnXAPmH70SBHwUKDe4TelfgUP
         m28A==
X-Forwarded-Encrypted: i=1; AJvYcCVrLDqiK0lW+vS6AzAXZ7nRIPqm78vGjoUvf0rkmFH2a6gnx7Rc/Z9lQZzo1mOsSoZ0x1ePwiooWg==@kvack.org
X-Gm-Message-State: AOJu0YzPMhPi1cY070pGpbWx4opRSyCnD9kVohiseQr3EYkXo2rmnL6q
	H6sVrTdxB1APLI1dplHqbRn4u1GELSrZC31Obv272TxomOl29Npdvbq7jEFb1m1e8ihnj4L2dDr
	C0k6FiHFhVdGW2iF8FuHerE2D0/IZ4gjGAcqG9P1HLhc+7TLsdX5r
X-Gm-Gg: ASbGnctPJdR2I1d/Jq/fMJpOU1d3Sb6UhV5LktsquC7kcFppGtkHqeG6S+IoDbvHV2Y
	gqi99aJAj6PeM+v0u8Xj+hU6Jt1EolZ0G9wbQNMvGqSQKXIAV7WF9FWtOSvzubXOJhATzrhy/XX
	C2wjcJ9ywW0V4n2/oFOsrscTDOstZNM8EMzex81i/HkV9vagMfOx8IzplnZvghD2FHBILTxCusH
	KKCLgwH4PbbYk8PU6beHy+8zP1t5qCNuDJlgA3XckqJn33Iw41BymBmnVH569qXwpecKikqZj66
	+WA7PKwfUc0fmy6ZuJRLrrcuglzVT7s=
X-Received: by 2002:a05:6a20:7d86:b0:243:b92d:72c1 with SMTP id adf61e73a8af0-25cdefc7abbmr21753633637.0.1757917214012;
        Sun, 14 Sep 2025 23:20:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErivlYOqYNMD1uzOOLvIYOeSFyGjheTCp4Vv8Fmhsfn/ts4DA9nnO0VA6qrA0q8hxFLJc/yg==
X-Received: by 2002:a05:6a20:7d86:b0:243:b92d:72c1 with SMTP id adf61e73a8af0-25cdefc7abbmr21753609637.0.1757917213616;
        Sun, 14 Sep 2025 23:20:13 -0700 (PDT)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54b169f2edsm7546506a12.19.2025.09.14.23.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 23:20:13 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:17:51 +0800
From: Coiby Xu <coxu@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: kexec@lists.infradead.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, fuqiang wang <fuqiang.wang@easystack.cn>, x86@kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] crash: Add KUnit tests for crash_exclude_mem_range
Message-ID: <x33mpzp6bhnx2awnszjymuyfhgmtvq5hhfs6aoyvuoo6opsbqr@tkegmqv3lucp>
References: <20250904093855.1180154-2-coxu@redhat.com>
 <202509090415.cOytgte4-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202509090415.cOytgte4-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zB2cho5PSCksimBzgSayeOV8oxL1CN1cZUXD9QAanpE_1757917214
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13F8220009
X-Stat-Signature: mdhot39abcca4ujexw9i9wt4gfkmrs5j
X-HE-Tag: 1757917216-110338
X-HE-Meta: U2FsdGVkX18L+tFg7BK6YUTP8Juiyzoz/C0STvcmKZ3ifLksZPicc+vlbDahDSh1Zsf4SroEIsfdIuFah/NytpZa6y93q4FYHLmsaOnntis7nJGe080o7j+O14e4p2Bv6VrqxsfdzW5C7jB1f9vwFVTaHg8a7kvXkxnB4QpCN5LiS5BSkpLJugRZ/O6842t5OMWDR2JFKgLW3dquJFaeflX+a7YJnnPlZNectd0xUXo0OaYMURB4SIIU8ER8zTGswSKKk1vMkfkJ9r0Vf+yIeQCBvj0w4Mq1rGiw0qfPthXCibt6lQE0P+R0FifDc/AiaYVXjR4G1AnQllGp82r9hBU6IZao/pHvADIYd0tJuiw/2Gz9iCTJ0P8Fuf2WP0NZo5C9DPxUu89qyZbrcyhjP2mKikykvjYvm09U1FhlhGNAZ2mPIxFxbvY8ItsR77zyE+8rAvH2g5b6Yt1Hg+3SCeNRLgiiaC7iaVG1HedoV0gKN+OGAXu7LWKMLTVVYmcJYE1IJcZRIfDGVmSB8H/ehkf7zeLuuu052UlEKwJ78iIECdPDXYTb52e9LD/U3KOLJtPXcuV+ZjrJ4Cc7Mg98fxkmTCeMz93gv20WI8/fGv7EjAItEZmdwBjvs72Nakhes836CH9uDtqp6a0kFuoynTjDFW/CYVfx3OOpAyD2fuZYSMz/x6Rq0pbQZyJJwtwTAE1xz6fMTj19Z6tqj4Gl/JhSbw0rEnL9GLUZHUgJPB0LS/AgQ65E8IuaDXySWvRoqEFHy4MxsiB/0KE6L2Z7P372iHSBufZ7Mr9KxOasQSkJHt0GQxa41p6hWLEN9Nh2WOJlgI8cxlAwRlwGv6L9j1FTiPkMpX4UbrFwaTT5xkfE8gRnDcNnyruWfNWd5MOR59GtWJv1o582HyguDUqUTrpEpKIYar9Dt++7QbujWVSI38FvTVyHVKpvlW/edOidTHaCFULU0IH8UARsSEu
 wijF4qqM
 ce35kNogMXTOfKT4rpQ5jyHxGfl7iDxAng7j86TRLGlaYLszZfiUj4JcaZ/0GwLbMo/43CiniSVSD4g4fC+zAdEKVBYNwKOU7L5ssOx7FNBIvWpB7lLHAx7rt1ktfjq+Lt6sh0M/QA0fY/ufMHudQjsfWGqVy9dCZOcSv8I8mq+WSqWKL3WOS36mpKKGx3Dl3aqTcD92zBLJI4eFiSXzCwID/pcZle5k9TTn/3/mHI6HqHdaquwMvS9Nw/KhDQhDASgyzmE4GGEVpB8sXFrf6FepB81LMPS6TJQRXyverTTXcd9hNthLLr2FZaZFTdIL8Ug0P6p/cambihMTyP90UK/KuK4yzcsZYSZdhApIW8PeLNQIO+vwjpEYM3m9GVEn/UV4odom5GM15RldWcG8Zj4kb0Uz4TeDrxe4dBZZWr+nUnbYpHbs82dAjHN4VplCbJ+Xn4LyIdXot9qN4mG2v6bWre9zdI3YqRL3LEI4GMhFzrx4hUF6QWZA5ZFIZEZePwKgqQXI1wIb+avqF9ULQFXqVpV9ZO+p4TZ+jm1BPqKRvNXHETbFbzMKclQ2PWx4UPuU97iOXtZan8E0rPoxWVHIFHcibJZLj3pWOWdk0Q1fSWckj5OjgzbXJ3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 05:25:17AM +0800, kernel test robot wrote:
>Hi Coiby,

Hi,

>
>kernel test robot noticed the following build errors:
>
>[auto build test ERROR on b320789d6883cc00ac78ce83bccbfe7ed58afcf0]
>
>url:    https://github.com/intel-lab-lkp/linux/commits/Coiby-Xu/crash-Add-KUnit-tests-for-crash_exclude_mem_range/20250904-174105
>base:   b320789d6883cc00ac78ce83bccbfe7ed58afcf0
>patch link:    https://lore.kernel.org/r/20250904093855.1180154-2-coxu%40redhat.com
>patch subject: [PATCH v6 2/2] crash: Add KUnit tests for crash_exclude_mem_range
>config: x86_64-randconfig-073-20250908 (https://download.01.org/0day-ci/archive/20250909/202509090415.cOytgte4-lkp@intel.com/config)
>compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509090415.cOytgte4-lkp@intel.com/reproduce)
>
>If you fix the issue in a separate patch/commit (i.e. not just a new version of
>the same patch/commit), kindly add following tags
>| Reported-by: kernel test robot <lkp@intel.com>
>| Closes: https://lore.kernel.org/oe-kbuild-all/202509090415.cOytgte4-lkp@intel.com/
>
>All errors (new ones prefixed by >>, old ones prefixed by <<):
>
>>> ERROR: modpost: "crash_exclude_mem_range" [kernel/crash_core_test.ko] undefined!

Thanks for reporting this problem. This issue has already been fixed by
Andrew [1][2] earlier.

This issue happens because the KUnit tests can be built and run as a
kernel module. 

[1] https://lore.kernel.org/mm-commits/20250905031921.E0A26C4CEF0@smtp.kernel.org/
[2] https://lore.kernel.org/mm-commits/20250914001748.77104C4CEEB@smtp.kernel.org/

>
>-- 
>0-DAY CI Kernel Test Service
>https://github.com/intel/lkp-tests/wiki
>

-- 
Best regards,
Coiby


