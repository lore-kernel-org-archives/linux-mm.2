Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E83FBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE486B0422; Thu, 13 Aug 2026 04:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E0E6B0423; Thu, 13 Aug 2026 04:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38706B0424; Thu, 13 Aug 2026 04:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7478F6B0422
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:55:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 030D040284
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:55:27 +0000 (UTC)
X-FDA: 85095637536.22.DFB1866
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28E90140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:55:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FUk91wIf;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of pankaj.gupta.linux@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=pankaj.gupta.linux@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
	b=gKwbgYRnM+7YksyLFWhyFtr+FcYh21ZVwNtZ5zQySZUgy0scJZEdUmKwX7infzXWsYpOiy
	ycBTzzSxBdJQmLdEvzjG0eNtOkbbnTLo5yPhH2sMr0Nbdw7vPRi5tgUW1mAy6vEZfjiYQ6
	ApfWzWqmKGSO4D7XarOgNu75dj8K3+w=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FUk91wIf;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of pankaj.gupta.linux@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=pankaj.gupta.linux@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786611326;
	b=TegI4LpKQn+WIDzRN8IhxqnH6tLkZI/t5Y8A5Mgwi8Mevj3iEcLBDRJPsZ1pxP+y4MPwJ/
	lb+ItkuSitEaa85SEru7/RHRY2pyMg1GKBybnZs6uN8K8AN9V1eCJmaIzw565OF4kbDKTy
	4QnuhpCgIAJFFFuPEFIlHtyxS/av+g4=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbedb88aa34so447930a12.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786611325; cv=none;
        d=google.com; s=arc-20260327;
        b=PjFdGjWXYcCxrfHjFOWAqgJ13lxdJrqS30L2SfQxhEbFvEnYAsYNUnR76OaMpGs1+Y
         G9f9WZ06bA1B82lJpOvVNSwyXL8l0vjjLFBX5cVYNyVG2fryxi+QIGPEF+CKF8NEDFj7
         kKziXWxDA/00LfIfloxEbH2t66qNe2EL5cEauIVJIhGIP+/HubCY9BA/NMtrGfFU/Inn
         tC5zLq3UMvYxgDg+lXCDzRatVFopwqtFX6fHv96ptebdeXBwek5i7//zZefJkJkD4Y8V
         6ylwo/MuxCVzY1b4LJMzPAuDe88jm0ufTz/vohq1lrkjOw5f1m+bCZ1RjBZKYcw/doto
         fc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        fh=2khvZPSg6lWIrrUAYmXTeSEzypg02JA6A1PbMfy4ZSA=;
        b=szFieJiaAsuPxp4vT2QelSwyEJXWAtKWcrNONo4OGiXxYtHsP4xwtAQbOxdAAi0rlB
         +ITTlAutAPCZ9xNHk00PNG93aXAEccZ4idRoMvZEA29EJzH5sgEKUHj5lo2TJvQbZFxP
         MZMOLwHB5+TOOvL+1SntI+u3wvdEVHoH53UZ59an7PXVs+rICmTzNdKPRWmPhPmXcbSg
         +GbKdr8KUvrfW1XN1GS102FqV+e1ZQXsORfDc4YyIB9/DdurVTvGGnNi4T41KRwDRozG
         dQ0ePzpIXAY2Jr8FtHwNxZW8bOZ15xFgpWPzAnuQiEmXwMUOcVgrZrPWEtbpR6qZ4d5Z
         KRhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786611325; x=1787216125; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=FUk91wIf09BypcgySyHm7lK5UvYL69mWjLs2qujnsIPsh5qi5rJHGJ0lX+8CMgCGVn
         jHuJqLlFQfF3qZUh8a7o4fXdmSmJGO5ZEJp6HBBEKVb6162VpxrjKM3QseB5LAu+gQzc
         gT/uLoWzD+rXqALjuWemW7Jd1PVueIncAvaUXYJHltwpSlhjd8+LYgzu/Jkbf7kRTLeD
         XHB7HTTLSPiJuo0Rw/HGUa6ATo8X4NHdspzFg5jL6kU+2+DWpLvIkDt/pkdzDdUkrtag
         aJa/W7ytcOC79PsEIvMokzHcA32V2bG9PoAUFQf2/SFygL228Ok6d6koEJ6jvEJba0Hs
         XU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786611325; x=1787216125;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=N3MYd7Kbwxh0xK+zCkbtkG4hraILyePGi59w2tVQQCVQCxzhlpgnhrkQtG30+NzjoI
         u7B82+KCKg+1P/PoSLYE1Ri27cmzVRTy51bVkMLNZcGaaKJvuEepXU9gwh16234td1UJ
         Oam3/SHt2uszW+7+Efj86vEBLhz/SqEc+8Qc2Howds4GQKMpqUWOYCp6erw0RfkZhC9P
         RetWQRdmThIAjaENs1Zi/chSOyS7WQDsdbWR9wdbPSy9LaVSnzannDN/3b2xPYVVuCJD
         SXuffmAXuYvHfTQe1w6xBFTTab33DzpUSXw7LnNmK7iNZHIIDxxkNpFwkTJQQnvwMELX
         aF5Q==
X-Gm-Message-State: AOJu0YwwaeyqiHzQNG/29BqK5W2gS60IWGpIxDJUudlAFQtjwJNl7yGu
	9NVeszbRy5Hm6ZMPrR7VwElMvoQmdFsa0uxk3QZHtXdFeISXW/I3TIFkGx804VpCNN2gUaazZq2
	LPJp8A454GkimZQNLa69kZSAFlyXXssU=
X-Gm-Gg: AR+sD13IvxYIG4WrWAo5j6CMpmoYUSW7Hpg+Pi2bbjKXmXb7ddwWyBGwdqRCRhQ/o5X
	ZCU2gza/+A2tGzieBY6cENA6AWjM3wxMH5Hq9SomriRCZTUa16GLRS3BnuQEu4MrZaBVd8H/Tq9
	cqPFK6BAOrx5aKfSyUjR8XGVHKvk2sQ8dzc7368yk1MZV/6lSNi8KyK1VVJi7L1Yhy2bCT+TbOO
	8JZ7JKN08b+8EH0qLF7Ml+KinGgEYb8FA/2dkv7av0TCbWjPrC+ajnvgW840cGlYYB3m3CiWIn9
	Peg68Gdw0f/VM7iLLTOHITfw7fiemY4zUeUsds4ZEqOfVcA=
X-Received: by 2002:a05:6a21:150b:b0:3bf:8604:9a3c with SMTP id
 adf61e73a8af0-3cc553f513emr5787899637.28.1786611324791; Thu, 13 Aug 2026
 01:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260720193431.3841992-1-gourry@gourry.net> <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
 <an0cAMh_m8ZhGIm2@fedora>
In-Reply-To: <an0cAMh_m8ZhGIm2@fedora>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 13 Aug 2026 10:55:13 +0200
X-Gm-Features: AUfX_mx5aRT_GeBsew982Oll4m1v2zeTSERp4DtDb2YI-VK1slYjLWUFWPkF2ZE
Message-ID: <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	djbw@kernel.org, "Gupta, Pankaj" <pankaj.gupta@amd.com>, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 28E90140003
X-Stat-Signature: 7rt6je9cdqxidxtbmebdn7qmck1pgbxs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786611326-564577
X-HE-Meta: U2FsdGVkX1+Kq5ZLSmzs05kJgxySVE2z68g3ArRDsZesO+DKv27DHKAFV2n3xfhfGtcNGj2FBvvxnnlNwC7HPDxtZAth1Eqi5/pNUMSE7FYypX+lipIVjC5V6ZEyHta4MmRZwh0qTrAa7ShBoYBDLiMz6VzeClwI0u3WW/nk9+IVjVthzEMeKq0mvZrpnKB6C+x2/+Mcd0uvRV9mmG7LY2KGV4eWiEUAmKxL62BKjZ0Wa21li6L+Egpz3o41Goo5Qk/KBessrm4jesfQlfZqDSwv8pR7axKna6lLBEFkWnhcJa3LOX1jqv/4YEmct6gCIwEBTqAYf6CkHF1oGiN26cyPi4tK153lTcKIIzqJZwHkaykolqHUCQKARGhb4zmDgq7k5vx6OAHcUfNh4dzWuwuENCbghLYGyVyfWj3FOzP9b2utJ0/FzVYPaTewlDZx4jMCLANsDBU+zSOrbfG4g0xyOeSqvmbYiHKoUjF1LG8zSxM4R4zXFR90NkL6ZMCeAo8vK+AXbJQ1IU25FNahgNFNHAq+2GNUYyXuecnh0S3mvIO/xI1yyezcsS3P4EaYEni4w2NbmULRt1HNNFQ+S8b2nzL/4E/IKOtj/9eGUXvfFGVnHKQ9rtEm9MB/MTl6dqVW3eFAvIQiZru3XVDa2WwvyN6XCvmSmAlA/czrdmD9X6sH1wPllH729uMKzB9Jw/Hy2Qx/39+cKpbHBEnyttrB+dCmptKqzetLVKSstFzwaBH35uTOvJjtq06ZTUMi6WYr47p4cwGm7fcW1Be34f3Mepq+AOU6akLotpB42mmw6mt0/pRRMn1ZqaccSsjKuoPVlTvNp31HFDdxoKj4eftQ2Aoz+YSeR+sEUckJRAuqtZm6Uuv7tPCcsmV3f8a0ibQ27kKu2BZvmhP8mQbvwykhVmPG1i2zT5osYRS/PzuKQGsUNS2yRp+FVYycxKzy68N0D6MfLBPVIdCDdvc
 aqacwlTq
 czn+1vCVEXM7vbPV8Pk60z8Zs3/KkKsAxtldXkR5ir3YCcyf0hmxGlSHTBUExDUUFtwAOqwVQroGkDMITuEGMN0Lcpy9phHdHoITSVP0xTzRn8sabYAmWcCGFu5P0Vb2NQ5ourEPkxeb+vH01dovyAFcDDtX17e1ZEG2icshM7J7Skjkm2+Pm9uXWF7+dVQIWljYZhSHOD62uTGc4+y+08XhrDV0adGukfjsjs5JD0spLestWTIKVIcNcCCUFvgRv1fqtQhcqdfgiBU7bHnCpxeKpBqh1rb1SZc0zz7egxOh/CbwZDOVCfoxJQOcej8YwL7Xf4xhAegk0JVpPS3J5O+bcm0hvSVLPZsQc3SivrIANa/VJlpl+BRlUSA5CmxiYXRr2R61lTAKk6dnnbxouoi2scQdpDtClRuceoBBsE/uvDh5PcfEX+JpIYydJiNOU+uSeP72oH2m2LJmDBxTaS0o8IRoQOqtqyvqQY7gIWsOhgHtQJcSG1xrz+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Bonus Configuration: HBM device memory tiering
> > > ==============================================
> > > echo 1 > dax0.0/private       # make the node private
> > > echo 0 > dax0.0/adistance     # highest tier
> > > echo 1 > dax0.0/reclaim       # reclaim active
> > > echo 1 > dax0.0/demotion      # may demote from the node
> > > echo 1 > dax0.0/user_numa     # mbind()
> > > echo online_movable > dax0.0/state
> > > echo 1 > numa/demotion_enabled
> >
> > I am bit confused by the HBM device example being discovered as a DAX
> > device. Is it to
> > only to showcase the use-case? Or we see HBM device is actually
> > expected to be discovered as
> > DAX device with N_MEMORY_PRIVATE?
> >
>
> "actually expected to be" -> no.  there's no requirement HBM be
> discovered and boudn to DAX, DAX is simply a convenient intermediary
> to memory-hotplug.  This is at best a demonstration.
>
> A device driver could very well just call memory-hotplug directly,
> or its memory could be brought up as a private node via a boot
> paremeter (which I have sculpted for v7).  The former is preferred,
> but there's a bit of a chicken/egg scenario for bootstrapping.

I find this interesting as this appears to be evolving towards a vendor
agnostic framework for hotplugging memory directly to private nodes.

How you see this working? In particular, How would the kernel know which
memory ranges correspond to HBM or other device memory?

Please also CC me when you post v7: pankaj.gupta@amd.com

Thanks,
Pankaj
>
> Most of these UAPI extensions are going to be consolidated into a
> debugfs interface for testing purposes only in v7.  I've been working
> on aggressive Linux Test Project test expansion to ensure there is no
> UAPI regressions.
>
> ~Gregory

