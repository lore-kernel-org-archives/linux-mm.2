Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446CA606A334
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p8FVxTEx
Received: by kanga.kvack.org (Postfix)
	id 11C976B0683; Fri, 13 Nov 2026 06:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD996B068B; Fri, 13 Nov 2026 06:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE776B06BB; Fri, 13 Nov 2026 06:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDD8A6B0683
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:22:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F91FA0885
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:22:29 +0000 (UTC)
X-FDA: 85429857618.09.514CAE6
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 62392140005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:22:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p8FVxTEx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhZJPwyqkT2jXkPI1fAXCUzZovCR8gpp0OeWDLPOIpE=;
	b=Z3rRDP3X/sdUMd44rvXM4sNI2SLBX0HgL6b6LEdK1sEyu22Y699Du3jqppaXlnvUmE7ymI
	plyPK3+RrdSuMwrERbsf2Pwra/DRMmUllDWp7bjg9X22N9sTdb6gQMXXBzkTqT+2eTlVSD
	SrcUPB9sCY71RZjj0Wrf8tRu3PdnS+o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p8FVxTEx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568947;
	b=CiCFOAbtjce0nr1zt9zHN3XC/yo/Yq+60wX4zLlbIJSfQe8jj8fPMXLcX3H/8P60INeAHt
	SnG/7aLV2R2wWNqU1idPwgqDb+cxE9/3WDJ1NRepg5XcNYEr7a/fRU7UJ9JB+twNS9KMmg
	sRwyvzZFu3VHmacsNdiyJeMuB6+Xifg=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35159e0092aso94791eec.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794568946; x=1795173746; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jhZJPwyqkT2jXkPI1fAXCUzZovCR8gpp0OeWDLPOIpE=;
        b=p8FVxTExB890LKJaDAqZRkEWS59QaFnvkjGp/6G+0XiS38ZJ3i4eN/w9Zz2UlzsmkX
         3zKtb/2LldL7IB/HknSwOLsGgsKZ+n4T3N8Sf7ASicPEjDb3Fv+ZqhKU24rLszZLaJBh
         Z/y1jXIIzeq0ndB8ZTqM4RNOGq9oZvKHjxJzRzRAPQHLqp+jIDJXxZSAEvyL01SiTH3N
         wlhWbFgvZ+4n40alWDNXgEuZGOU56YyuVasqxYJRDsGkcWrJQ2N4bsUnwNwDjMMWn93o
         TAHiLlA3neBeLEU3U+hnn+urT0kXNoE2oOdnDNkDSPc6JDngFz9SquUIiVqsvr5T01TZ
         jtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794568946; x=1795173746;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jhZJPwyqkT2jXkPI1fAXCUzZovCR8gpp0OeWDLPOIpE=;
        b=tG52iS4QeVJFx491M0nLWpJ2QJYLb0JjV/NqxG0th/0GGSmoM6vAq0rAyPQcvz+6Ed
         rSV/QClctemyJrv9w3O+vV2WbrN1MWL5+MHW4NA3wGsTgf2Upbp0s855Lf6Oepdtd0uk
         IItZqPWmX+asdjKCyiAOZmCmyQ8/e+KfNCXHYV1Tvhy6o4unSJnNeSi0C7QY4mc3MYRt
         +HkSR+glwY1IPbz5tR8aCTfiNihliHrerBS50exoCo7IFm/Tv6e05piOA6+f0f/N8L+w
         Cn1QnIefd3J+WoJWmV9QwjyQNbWALIq1+GuQrQ808HDPClo7HVmSCMfjWExqNBG1+Rsx
         3tsg==
X-Forwarded-Encrypted: i=1; AL+hErG0JHUkbl0Ti8DZmaz1Ljfa5PeUJwbf6Xk0dc1gG6/MwxrIOI0Dm13gF5I0kJyR0JPCvVvIUu3zlA==@kvack.org
X-Gm-Message-State: APuU4Z+G73wOdFNiagEfS3vaJccA35FOfSh/N1E/axwFCYZDf9NB3l3a
	atj2ZjzxBEBlrovPpMNUkX4FUqxS94ISd8uIUKCm1M7H1n9sDiGqMO4X
X-Gm-Gg: AYBFou0siwA4nzUUoe++erUDvVKRCWYmSpeG5RVlsnn5Mcvd6T8RRfn4pYuZjPPxLsg
	+7BYz6VlkDbEgni5gR2X0IZ8PKwio9FtZ2gSGFBqySfhn2fosJr9071A7m8gPRVvsw1dsYpmjM7
	Iluz3E8N5bJiPUxDqFD+yVWCZhjT5GzChXjf+aX5RobJaVDt8fWDJEFN2buWSpMrwvbvFldsYwI
	lH9N+RFxB3dN0AwI9Ui4J5PQAKRV0k9RoyKBY+HNxUy8SZpayK5FcUcyPGD4pMxGdsxmv15Dt3D
	so9fFHZxTzfo6Oa6xEEIdFQucS+Qin/2RT4TJftMmdVCEy9gSAyohfjqgDEj+W9MBmbFFI/Z0rv
	txN6Rnjmb6udFgkBp5IUAXBWK6+8ZaCxXO9SixW9XmTtEx82goYsobO8bWcgGbx3Z1j9hhNZAst
	s+U08RbK3UaVKAbXNEatSKU1z+6/7WhvZDilMzCBDeBGPE3lsFOgMzcMa1hLWSX2gEQxsCjVWdD
	1h5tSsuv7SdgTTywgbnmb+pxVBWjwEPZ+JYeMomXEhD7LLimAZ85PtSFlCDr5uZw1FxDO9zT0Ys
	R4ZW/ErXcKSzGsySIXn7Oi3ux+4Ct4r2JOzbfg1MYCCXdvAp3/r2U6dhM6J2MbmKSvI=
X-Received: by 2002:a05:7301:a0a:b0:36c:a1bc:6114 with SMTP id 5a478bee46e88-3796038259fmr2893772eec.0.1794568945402;
        Fri, 13 Nov 2026 03:22:25 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795378c2fesm7133252eec.1.2026.11.13.03.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:22:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Nhat Pham <nphamcs@gmail.com>
In-Reply-To: <f9ee662a-4da0-4204-89ce-33704044c88c@hust.edu.cn>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <f9ee662a-4da0-4204-89ce-33704044c88c@hust.edu.cn>
Date: Fri, 13 Nov 2026 19:22:13 +0800
Message-Id: <179456893350.2142163.5558519210108805249.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62392140005
X-Stat-Signature: s7g5hwwget6szqsdbmxk3i94fok981aw
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794568947-707835
X-HE-Meta: U2FsdGVkX19ndroE/z2iX57VVecA5kBtY+aqlZE38YQU+ye7y2fZw+D6YG4OM4o4CGNKeIJo0DY+5LtCzDeyHqgIfDQhCFafTtGxJvyeW23Lve/FztDHD0lbgC5hZlxCFxd9KUIUevL7/l2Q1gZ+UXeq1PR94X4c4OYq9pqYbWcLlk1PZjJW+/Dvqlr2qu79RaOrBbL9Sg8CmPt28TvCQAMCtDijI59KOo//sNxFNdi860HIDjDz9ffd2dHis1Zq7VIvhOG//O74pHQgXIcwIkKD7LABy4iE32sbtKGOAScBhoAc9Ey2C6/Fz9SaYkMmoNwiRjZwk5Osy0UH4lr3MuV7+6QYpgOwSX6PCbXgZfcT5GdtkF7MwOZ9H4Oc8V++gOugUSpX0S4cAC4QHQcS3JMGqo3A0JTfvWZCH71E/MusdJx9MGAiCGThC1166E0HnDLS8no3V9/fixbHJvD9mp5f/Iu5r0YFFufvFEF2hI+k6w6c/W+G53wIEehbd7IgEoenNIRrS9NaxB8uK2FcpYNEhLzuVj3yTH8qJpNeSiq7nO+NSdtqWYg17Fvc+c4Y1TOGFJ7Ahw4c5X8Xc66Q1XH0JIwkfcy5KEQUhNbXx6JOK0EZYKIsNzSu7eoIVmhYw/8bh5+PP/JCEmkIwEKNTnAl7A/D1qb0ONYNeXun/qURWfRaXiy1HnLje96dbDomv0SD1yCC+jLDp0l/6rxzcbBb0isTzw2nZx1I2CwVqFuaIgwdL8ZslecjwilP6pAsHW87TUfZL78vyQ2/Q9uOi/z93lYc9M1D24jF19dalGrmcGDiXmJqrZG5HCxgrYSh5vlpk1oMpWl6lp7m7FV2Jy/bn4dTLNXqfaC/401roNyrdVfqxFE7FpucvOOWt337WfIP9V+xLChZiL6pjFAVomFRamd8ge+7JSk62OoauSM7ZlPqtCGB+xu/VZGz5ypb9p0l7ZTzs1c074lTv1P
 ej36aPlD
 xKuHSPkDPmTnEyIwLndAx9AExoszFcKGsRbYVC5TudilMM8GUmBT6Kkui33eoX071PSa985iIhUVc3TiHcCAvVEV8G0DLOzRfhM3Pq3MBesAxW1pEIdP5yqACvvLn3Qd919nriTvjBQZDhLhPFeZDU4yFF+EMCGyEO7G7Ouah3quTpXSgiHLy1UDaYf8sSd5YWKuhtjwut+nUB6Go6gWUk/pjzal6vPnHo13pyp9Qa3KZFR1Tq6xaq5MawfI47OJjfOg/BY/GVZs/n2EZXMXEa1Tj3eYMZUMYCEQelvD5UMbJVD0ECJPfgnBNeoPpQyrG30adI8pa2TgaDCfcCrfpo082UO3XX5Ktzjcdi0BHaZWMPIucd6WfWWJXCrbBik1Jcn0sbDbZWso1FfglLx2y0vbpCEys/+fvW0RK/2XvEPBBtT2daizb6VXAbqRf/syxo2fPfwI0+Z1CQq0S/g7ki6mNwxrtJMYEGDKCUhBbSpYfuziLv1nmFCw8E+3XNyn/921dM/8k6W7ecMl9yFlzH4me1oLybiDA5c70wqq4jBFcdZ/0jhrJ2l+fR6yjydV5+5aFdWsV3qOifmgmJdXVxVIU4Btc2xmv7v5vrMc44MaKyyrRwaxhFo60YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 10:12 +0800, Dongliang Mu wrote:
> 
> On 11/11/26 8:41 PM, Xueyuan Chen wrote:
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> >
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> >
> > Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> > documentation to match, and clarify the pool name in the debugfs path.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> |The documentation changes look good to me. Acked-by: Dongliang Mu 
> <dzm91@hust.edu.cn> # Documentation|
thanks!
> 
> > ---
> > Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
> > option only controls the debugfs interface, while the class counters are
> > updated unconditionally. Removing it simplifies the code.
> >
> > Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
> > the existing debugfs API stubs when CONFIG_DEBUG_FS=n.
> > ---
> > Changes in v3:
> > - Squash the three patches into one (Nhat, Sergey).
> > - Add Nhat's Reviewed-by.
> > - Update the documentation wording.
> > - Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com
> >
> > Changes in v2:
> > - Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
> > - Update configuration files and documentation.
> > - Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
> > ---
> >   Documentation/mm/zsmalloc.rst                    |  4 +--
> >   Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
> >   arch/s390/configs/debug_defconfig                |  2 +-
> >   arch/s390/configs/defconfig                      |  2 +-
> >   drivers/gpu/drm/ci/arm.config                    |  2 +-
> >   drivers/gpu/drm/ci/arm64.config                  |  2 +-
> >   drivers/gpu/drm/ci/x86_64.config                 |  2 +-
> >   mm/Kconfig                                       |  9 -------
> >   mm/zsmalloc.c                                    | 33 ++----------------------
> >   9 files changed, 10 insertions(+), 48 deletions(-)
> >
> > diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> > index d2bbecd78e14..4c0786378dc3 100644
> > --- a/Documentation/mm/zsmalloc.rst
> > +++ b/Documentation/mm/zsmalloc.rst
> > @@ -33,8 +33,8 @@ proper handle-based APIs.
> >   stat
> >   ====
> >   
> > -With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
> > -``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
> > +With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
> > +``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
> >   
> >    # cat /sys/kernel/debug/zsmalloc/zram0/classes
> >   
> > diff --git a/Documentation/translations/zh_CN/mm/zsmalloc.rst b/Documentation/translations/zh_CN/mm/zsmalloc.rst
> > index 4c8c9b1006a9..b555a07ac871 100644
> > --- a/Documentation/translations/zh_CN/mm/zsmalloc.rst
> > +++ b/Documentation/translations/zh_CN/mm/zsmalloc.rst
> > @@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
> >   stat
> >   ====
> >   
> > -通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
> > +启用CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<pool-name>``
> >   看到zsmalloc内部信息。下面是一个统计输出的例子。::
> >   
> >    # cat /sys/kernel/debug/zsmalloc/zram0/classes
> > diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> > index d44674b63715..83193ef8efb9 100644
> > --- a/arch/s390/configs/debug_defconfig
> > +++ b/arch/s390/configs/debug_defconfig
> > @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >   CONFIG_IOSCHED_BFQ=y
> >   CONFIG_BINFMT_MISC=m
> >   CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >   CONFIG_SLAB_BUCKETS=y
> >   CONFIG_SLUB_STATS=y
> >   # CONFIG_COMPAT_BRK is not set
> > diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> > index e00e252d4694..694a309377d5 100644
> > --- a/arch/s390/configs/defconfig
> > +++ b/arch/s390/configs/defconfig
> > @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >   CONFIG_IOSCHED_BFQ=y
> >   CONFIG_BINFMT_MISC=m
> >   CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >   CONFIG_SLAB_BUCKETS=y
> >   # CONFIG_COMPAT_BRK is not set
> >   CONFIG_MEMORY_HOTPLUG=y
> > diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
> > index d7c51670da2f..fc0a8a4bfb18 100644
> > --- a/drivers/gpu/drm/ci/arm.config
> > +++ b/drivers/gpu/drm/ci/arm.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >   CONFIG_ZRAM_MEMORY_TRACKING=y
> >   CONFIG_ZRAM_WRITEBACK=y
> >   CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >   
> >   # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
> >   CONFIG_BLK_DEV_INITRD=n
> > diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
> > index c46125c1f80f..10b01b55a66d 100644
> > --- a/drivers/gpu/drm/ci/arm64.config
> > +++ b/drivers/gpu/drm/ci/arm64.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >   CONFIG_ZRAM_MEMORY_TRACKING=y
> >   CONFIG_ZRAM_WRITEBACK=y
> >   CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >   
> >   # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
> >   CONFIG_BLK_DEV_INITRD=n
> > diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
> > index 7ac98a78691e..8225b806dad8 100644
> > --- a/drivers/gpu/drm/ci/x86_64.config
> > +++ b/drivers/gpu/drm/ci/x86_64.config
> > @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
> >   CONFIG_ZRAM_MEMORY_TRACKING=y
> >   CONFIG_ZRAM_WRITEBACK=y
> >   CONFIG_ZRAM=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >   
> >   CONFIG_PWM=y
> >   CONFIG_PM_DEVFREQ=y
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index afff1b25b543..4a77cda7f1d7 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
> >   
> >   comment "Zsmalloc is a common backend allocator for zswap & zram"
> >   
> > -config ZSMALLOC_STAT
> > -	bool "Export zsmalloc statistics"
> > -	select DEBUG_FS
> > -	help
> > -	  This option enables code in the zsmalloc to collect various
> > -	  statistics about what's happening in zsmalloc and exports that
> > -	  information to userspace via debugfs.
> > -	  If unsure, say N.
> > -
> >   config ZSMALLOC_CHAIN_SIZE
> >   	int "Maximum number of physical pages per-zspage"
> >   	default 8
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 7ef80e0da626..104ccf3aa170 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -222,9 +222,7 @@ struct zs_size_stat {
> >   	unsigned long objs[NR_CLASS_STAT_TYPES];
> >   };
> >   
> > -#ifdef CONFIG_ZSMALLOC_STAT
> >   static struct dentry *zs_stat_root;
> > -#endif
> >   
> >   static size_t huge_class_size;
> >   
> > @@ -279,9 +277,7 @@ struct zs_pool {
> >   	/* Compact classes */
> >   	struct shrinker *shrinker;
> >   
> > -#ifdef CONFIG_ZSMALLOC_STAT
> >   	struct dentry *stat_dentry;
> > -#endif
> >   #ifdef CONFIG_COMPACTION
> >   	struct work_struct free_work;
> >   #endif
> > @@ -565,14 +561,10 @@ static inline unsigned long class_stat_read(struct size_class *class, int type)
> >   	return class->stats.objs[type];
> >   }
> >   
> > -#ifdef CONFIG_ZSMALLOC_STAT
> > -
> >   static void __init zs_stat_init(void)
> >   {
> > -	if (!debugfs_initialized()) {
> > -		pr_warn("debugfs not available, stat dir not created\n");
> > +	if (!debugfs_initialized())
> >   		return;
> > -	}
> >   
> >   	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
> >   }
> > @@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
> >   
> >   static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
> >   {
> > -	if (!zs_stat_root) {
> > -		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
> > +	if (IS_ERR_OR_NULL(zs_stat_root))
> >   		return;
> > -	}
> >   
> >   	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
> >   
> > @@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct zs_pool *pool)
> >   	debugfs_remove_recursive(pool->stat_dentry);
> >   }
> >   
> > -#else /* CONFIG_ZSMALLOC_STAT */
> > -static void __init zs_stat_init(void)
> > -{
> > -}
> > -
> > -static void __exit zs_stat_exit(void)
> > -{
> > -}
> > -
> > -static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
> > -{
> > -}
> > -
> > -static inline void zs_pool_stat_destroy(struct zs_pool *pool)
> > -{
> > -}
> > -#endif
> > -
> > -
> >   /*
> >    * For each size class, zspages are divided into different groups
> >    * depending on their usage ratio. This function returns fullness
> >
> > ---
> > base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
> >
> > --
> > Best regards,
> > Xueyuan
> 
> 



