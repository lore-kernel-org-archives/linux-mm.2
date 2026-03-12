Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DF3106ACD0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CCD6B0093; Thu, 12 Mar 2026 12:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DAD6B0095; Thu, 12 Mar 2026 12:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039DC6B0096; Thu, 12 Mar 2026 12:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA8D66B0093
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:56:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B025D160314
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:56:20 +0000 (UTC)
X-FDA: 84538014120.09.9D9E415
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8200C000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:56:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcEexXyj;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773334578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18JIT3O6zukphcEe6SxTxh/vhMczaM3dIFncm+AHYYE=;
	b=blmu2FsqoV9JCJTkWJRaOemq9KkKua5MfDEMA0rr9QpK9mebl5rKnHY6OtLf4NJfzLo24f
	L92stu3Yfi+jhA6RCYCM8S2hgAbGlBlIRLl4b1Gjj9N8vpFyavtc8EY7+CcBC1P6I2lYsh
	uvygZD0BnRdpcmhp1lrreqlGqrhn5OM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcEexXyj;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773334578; a=rsa-sha256;
	cv=none;
	b=c1nOKrBP7vrP9Bmr5DbQmjlyyEbkMI5qVi79+gmDFO+O6RPSqFiifI7iLqoQx+fy14hBRC
	8C5sZGJh5w0ARSGU/zEGt4UFfWDG8AGvGxT/d/nZcyoFUEx6KgClPUxdq6iLgUjaGUWbWs
	K73zr+OknYioekRfZ47XYKJqsn/74Rc=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d55b97f358so977229a34.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773334578; x=1773939378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18JIT3O6zukphcEe6SxTxh/vhMczaM3dIFncm+AHYYE=;
        b=OcEexXyj56TdoBauFJ9KSyBE2KPmobbM2Lwa67S5ooesA5IEYMIXBGdqQBB3WJlXcd
         OpJwIpBPJTQoqjr4nJSkMd6sSPTLopJA68trzUWRhSTf57WAWHI3MpqEVGFoWpV3bmmq
         JeQjLjywgkQXmuRW3J6JIa6UyXph5sT3ickRCbFFb1WsC3ZR3LQDXp17YoegvzVMJE/V
         EZgLDXsdo4/qZZGGvVpKEjKmphNdNfkOyrXkEjFKa3yESd7mn18YYWWymnpUIWTQzvjJ
         6sIDvn89dBAbVaeQHY6b9OILWQfyVrCobp0NdpkQauGrQ7W54jA0rihrHZ6lNficxzjR
         U2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334578; x=1773939378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=18JIT3O6zukphcEe6SxTxh/vhMczaM3dIFncm+AHYYE=;
        b=uLE7uzdjWStXuJt5eJEzegs4Vjqd1stKP2yiuh7mpgDmrLF2bNfeWpmKaJSIuKgz6F
         uBdbOAAwdSiG/WnULnd8KdFAFj6RqXwXDicS9OS8yk/zXPMGaFp3uq3RFJD8Vxr8cD3Z
         6QHLXSFFIksFN0OVVcEo978gNbFhGfu/fVnuFe9pX6YUcvHgORrNt6AZg+nT4Qoz/0Ct
         ExDKdyN+NFbhQUyVARj79HQ44smih/rru16XGQwMK1TC4PlGfTI7lydID3vOzDdyXb5a
         yWtrvkprpyOcbOj1GUhzgyqak6c/gfDOfS+1jmn6jcGXVitd/BgOd+0C18iIDaPKb10l
         5ZbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+0q6pGQ4kevKk02awg0iOWsdIg5eUqfU7pFXcNG+s72LFBHqcQHn4fzcFrD7Z8O/Z8WZVVky7Gw==@kvack.org
X-Gm-Message-State: AOJu0YwgP3a2BfYxn7irV5gl8Sa/rFBuMgOHb3wzMKEfhzWJS8BkbIlJ
	Or2kwCNanBwxlmuTZNM4ThuuHp9+9XAdR4w2X0JidoBtWyYj3Vseu+2s
X-Gm-Gg: ATEYQzwBxsgs/+cTJbe/VEnNOFYIRtt7/i/eB1TPguMlXTxudV2HHziydWwIzG5+wm3
	J2apqN/7iZOcXem6PCd0L3FS1gE88z03xeC4tGYe7IaZqjytUAzbhEvvWlwlh7E8p5v03CCKgVW
	c8hKMNdnmZznarCKPbEtjWf0AmHG0PvvvofzmsQ7LCB2nNeUBz4hi9RqWDBvj2wt+w4S4yc3Qh3
	dlCthTqOezxObN3Ht9izoBmP8b+Oil/UA0K6LVUV8zBe3/hlSzM8sfyM0tC1IFb65VeJ8b7o+uv
	sN9R8G5b1ldiAjfcwYb4uhElJ33Q2tzDY1DFwXduB5DfkYDmy273iZM/dCbARFvlnyX1Ffle6Qk
	Xu3A4ezVTcObfXn2Ry2JtFg95zDJ10CbYRnEngdcXaoOEvWuHOXLSwty8Hjf8IJMef3bWZ4hwl9
	ckk7xIRAy18i8ivrBueOW4DQ==
X-Received: by 2002:a05:6830:64c8:b0:7d7:5b20:16ec with SMTP id 46e09a7af769-7d782466df9mr59235a34.11.1773334577663;
        Thu, 12 Mar 2026 09:56:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:57::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aa5dcc7sm4596873a34.0.2026.03.12.09.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:56:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration in migrate_zspage
Date: Thu, 12 Mar 2026 09:56:14 -0700
Message-ID: <20260312165615.3800716-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <202603121158.g93vlc2U-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8200C000B
X-Stat-Signature: tfj9fsnr5dhez17idksotxza548ot9jy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773334578-217464
X-HE-Meta: U2FsdGVkX1+1BnQafUCBhEFLA4dd+6b32UgJ4RRu6ipgQXsfMarFsZ39hGdzG8rW5BSrIoOc3T6yoLnSl8VIB5pXWav//aMKonY2RTC0YvguZB+PAehRGTfbOEWV+Dh2h1o0vTsXDy9eOnUVivY9kR9xrTHKkE9Uxua4JLmqSKTm6lSM8IcmLn2JmqmLRU6XggQT0YWql8X8wA0D+Czmc0032ZpLln2+vIBX1rXQDeUQfkfGDr/2zqNvvDURnb1Jo0neRwqKX2me5HlV1YLxyoK24Z5Oi4ElGcSg1/c9lmE0TDOd3tMkw+NggbnJqFltUBi7rOG+jytHw6oNK4jICuoyQr549KUza9ABppSQ/tbArF+2H6gxmTfrIWBVsHc45oai/DvWUV06eCKtasPULtUzV7RZzQZy1hURhB0pOiAoqudkVm5TA4eu3mNSmFv9NLy05qqz5XCs+jpfBPz7Nmgo0ikPuoxlpylN2VFVdpwg/pv+dF/LCCtweLkg2Xbd2rrLhu8NiHLlRj9cvKTuEIm2dGzs8IozYgLZAp6oEVmFlB6WDISJ6OnAKgVwpL7LFmSdDwbqBXRlitNtw++/E3Gzp5v0h28sdlG6laOFVWHHZAcZHABy9AYcPc532pwVfuKICZaScZ2Q7klPy9xgzMz/EPHiwsGDs0r6t5pEW0kHAmXCIPVJWkbNORGzHJVEJIazEY0K0nLe7mcvRRGz+/WQf/hf+TROd3VhHDf7QtMWcOwWOs71oWEAlXcv8z7+2MYBxizmrjXGNav9DsKeXLAY19WUGqRD0cecLtXkRwaOwvkxVKS4fw6cE7K6K4uBasNaaow9PXhmm91zkBJTcfmOd7eRLjlugRxpk+HsCXlRJ0iDivLdxB+At6hgRPchsso/wiMK3XjK5TtGl3LQ3A5w99tqT0IvEY63EiPwDaQrvLiZHD8kunKtHTlYM3a01ldFDUoGf5END1Kcyoo
 hZ4m0Q5/
 VV0NY7WOi4JRmCiAWiEZqoKlCH5L+2e53XbcGViD+QXIFFt4cARjxg1F8UZ4/7U+4j3lqgYgRQ4SwDdEl/lzsyEe4Ch8inHabetoXe0Lst6psdIxz+nwRB6HaS0UlMsEYMwXAZ9QBErvsnVDN37r6AztM1JopCMMCv4jrLRzWaBWKEQ7SVS5KfF5uagkQc2r02BWHd8AGv4Qx1Yd1n2ur1ET0hs/ovr7V7IYmpKKGNMKIvD6cnQ0tTqZTT/FnLDaDZU+TjnI5mP2Z4pKAb4LyMgQhyENjzTrWak+WLXqHuGz1LgXBpmsWRYnu6oNNKMTMU5dSLkliowbqdTgJ/GyP5ZYcHaC9MxC1hcMJxOsZ7b6O4LxK3WXo+A5cUnQTp/i2zRziOwIEyV4BiN3A+f5a0A/lrTYDIxZOUP/zthUbglRGNZd0ZsgK4qM7grSKeUCMRSgrBpFSD7nTC6GZVq6TivxzwWcNCHpX9yLXLMd5zXR1pg9EBDCSQ5SdL6Uoh6nmE9EKwdj04hqg7P5jExEHobIxS8OdVWXBl9c01c6ZCTKr0OJEzsda3U0EjG2XFFsAV7L2nVNy1qki1MqkToXoykpzNQyZH0BktdccfkjE/UiyRuiS9i8nsH8CiT7JgqXCOE6LU9I4JRG/CSGtujsaUHv4iPHxIfrz9dsF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 11:51:59 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Joshua,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on axboe/for-next]
> [also build test WARNING on linus/master v7.0-rc3]
> [cannot apply to akpm-mm/mm-everything next-20260311]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260312-035531
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
> patch link:    https://lore.kernel.org/r/20260311195153.4013476-11-joshua.hahnjy%40gmail.com
> patch subject: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration in migrate_zspage
> config: x86_64-randconfig-001-20260312 (https://download.01.org/0day-ci/archive/20260312/202603121158.g93vlc2U-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603121158.g93vlc2U-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603121158.g93vlc2U-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/zsmalloc.c:1702:6: warning: variable 's_idx' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>     1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    mm/zsmalloc.c:1752:45: note: uninitialized use occurs here
>     1752 |         d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
>          |                                                    ^~~~~
>    mm/zsmalloc.c:1702:2: note: remove the 'if' if its condition is always false
>     1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     1703 |                 goto out;
>          |                 ~~~~~~~~
>    mm/zsmalloc.c:1696:20: note: initialize the variable 's_idx' to silence this warning
>     1696 |         unsigned int s_idx, d_idx;
>          |                           ^
>          |                            = 0
> >> mm/zsmalloc.c:1702:6: warning: variable 'd_idx' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>     1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    mm/zsmalloc.c:1752:19: note: uninitialized use occurs here
>     1752 |         d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
>          |                          ^~~~~
>    mm/zsmalloc.c:1702:2: note: remove the 'if' if its condition is always false
>     1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     1703 |                 goto out;
>          |                 ~~~~~~~~
>    mm/zsmalloc.c:1696:27: note: initialize the variable 'd_idx' to silence this warning
>     1696 |         unsigned int s_idx, d_idx;
>          |                                  ^
>          |                                   = 0
>    2 warnings generated.

Hello kernel test robot,

Thank you for catching this issue! Yes, the MEMCG v1 check should be
done after I use obj_to_location to initialize the indices, so that
the objcg pointer swap works at the end.

Will make the change in the next version!
Joshua

