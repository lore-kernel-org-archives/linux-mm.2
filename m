Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81A3FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 05:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166646B0088; Thu, 30 Apr 2026 01:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117A26B008A; Thu, 30 Apr 2026 01:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005EE6B008C; Thu, 30 Apr 2026 01:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E40556B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:18:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 886DCA044E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:18:51 +0000 (UTC)
X-FDA: 84714067662.26.4065AD4
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F66FA0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:18:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jevEiTgO;
	spf=pass (imf15.hostedemail.com: domain of lgs201920130244@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777526329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ai9guCpibXPXFjFZdk1+jpyO2wT0iDbSyZIBVstbTwg=;
	b=55Bp0f45n6KOhvBy5ifb1DYdzl8EF/18m3j6o4hKEV1NIYEXwJwGa/OBB3iwKhVllhbPTY
	NWrLBlZIMrFgJ139JOJ2R6swttwuBQ7PeCXe0v/MDHrOhLrd1vRJaRC2XzZoiG+FB0wi27
	KcRriH3VgJSmgjrtQGy3Q2tfcTQNzLo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jevEiTgO;
	spf=pass (imf15.hostedemail.com: domain of lgs201920130244@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777526329; a=rsa-sha256;
	cv=pass;
	b=eWqcpPq2oHgccIypaQnvG5WQgMs5fHQS/6tKk4Gn4fDtOfOG3dF8LL0y1sXbczkCJ2d2df
	B7CP49jGUOtNWU4JHqBRfM6yyVQHvQkv9g4VIAkC74bxwtriRwY7RnIPCErZx0q9yU/TnA
	YDoAtSJVMJ++u+oZe97UToJQfwwzjsg=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6563f83ae9fso562910d50.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777526328; cv=none;
        d=google.com; s=arc-20240605;
        b=YgqR11xdHWhSDMZXCwQQVMOIk6RmTQ7I6C1N5Gp9dKwgMH4Q4Hejf/Sd4bsKNG6P0R
         7iyyLQItZJ+9mDwWSE/yt7eImClGX9c9UES8Gvf4g1+L/3vqG8TYm+9stl3Z+m5dq//t
         zIa+sv4jX7VJrK32Wxwh5SHD3R0but3ejcBKbtGGqpMKokvzewQaScPyRJyVFkWDrtrq
         cinZUdPgwx1OUtH5AjIYRqe34v0q+xPEa7XgrEnDnnHaCeD96PaD/aiEYVia9aFtAI5c
         acxiJqcHnDrToJaFA/cmrt+eyTk86qEKiz/Vnjc+TuH8x1+VUw2yz6Yx3BxVjf50yuyr
         YcNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ai9guCpibXPXFjFZdk1+jpyO2wT0iDbSyZIBVstbTwg=;
        fh=gtYaqgy6kiaP6GmMmymIwZQukru4UVdlLkGzhskRzVM=;
        b=eeaBtc28hx0w+1OX6B50yhHPH7VfltnOfTRc3g3riiQVY7gip6oLSfO+Z1HjVV80vI
         jAR3zOYxCjK4SuWwkZRhKAjPFBIrnqVp+iXCWZauE/9slzbGK9xO19J+72+Z1XhUAg+4
         1CB2udA542k7VpRb/cX+fTtaZrGqXCvl/X/7PvK0snL4sqCrh2AhfrFtrh0jGI9o5yGD
         M+ypK/k0G94juPlj/momUR1nfGdIcy5J19ACKyVyhyk5Xvza6M/qT0R2jcweudFIgcMl
         vWPTc0K2jJlrRwU0Pks4PuXgPJt3FTCCDxey5zPBrwqoCrc9KIPUfJLd1Q2hgMe4xGaO
         kjdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777526328; x=1778131128; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ai9guCpibXPXFjFZdk1+jpyO2wT0iDbSyZIBVstbTwg=;
        b=jevEiTgO0DfObrc0P3QxzVBR1Q7eH1RGKSnp/dcHRRVaLFocLmtZzQ0Dv4aqbg5u4B
         TCSq+HLTkKc9yatVrIkl6kYztrQjBcIx/DO/eqjH+hVI8xyXVHGRV8jeytAENoI8iR4m
         Jvo+W0gebCgy41SPaicLVlj/MjuPd5UHyYYzvo73X0wqS/Uly1Zk5XQaXSv4BsyDWg72
         jz/nHQXV6p57GVmZ+m2NQyiUVO5XLRXO0QfM3rtw9QcvKS/4amzKiX5ETptIkD72IXsB
         qP5n4lcP93h8BoEvRr6Ap5hYMZN3XADCKRn6rxtWr8ItkV5BsOVdFzFAYaODJO67vMsG
         ZX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777526328; x=1778131128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ai9guCpibXPXFjFZdk1+jpyO2wT0iDbSyZIBVstbTwg=;
        b=hzZ0n1yL2KfhLoJnI0K3vwQl/M5PmFFKtJWC8WWNmeUlkPyx0K2U0O/v7gtmQiAaBT
         NSYwWXHkjE6uyor+Ku1tkZkgRjKETSFQIRW1NHZF+qkTXau2lAxM9yCYpKYV1lD95OE+
         rodzTFTXe62wAfTK5Iy0S1tLi10nhh6cU/cpxoPQxFOc+eTWASok5qdB/uCbXQUTS8HI
         wyhjDbSc7ZnFENVoCyaODJXMzuBcmjZJUmyPK+u5hHurDBOto3JktuFcVtfkIFH/yAsr
         MrAypUqEhi5++iPyIPLqKQhRGsw3hEg/fjU04dMeRF2OCo+dVLGK7Da14j92NJdTq1LR
         4liw==
X-Forwarded-Encrypted: i=1; AFNElJ9dqT5GvsJ/IBUf3XQXls+bxTtYLlJLTxK0Ww+jwrKaL9ychpKGy2KbNrOLjRGUedD6Zy+1KnFiMw==@kvack.org
X-Gm-Message-State: AOJu0YyBfNiYRIJqkvQ4xwNauLrDiyg4Gi3M31zB2mfCBgS96JFQ6P/1
	4pSwArKHJoyxANhD1KjJbZa3Ecba6Pt1NTZrRFS0wnrAD0W1QhAwr3zECLSHge+nmZBTFq1RhUK
	phA2HveCN5SfC5WihEcAMwgW0jMUZpJU=
X-Gm-Gg: AeBDietPqR+u9FXVUQgpLD3ed10aHWwyD5BQ7cjotT46Pa+HfgytZvzhH/55K6YG9yY
	phSXLWHQK99DJfs/CU1vN9whMC71t9dpHfFdYka+LN0GeqOnLzi+f7X/Tk0kH939I7i7Hpqv2FW
	dOVE1L9EPyIkX4rL+zLKJH5r889igHQPw3wXmd5HoxQGWTSK8j3gHJM2iVkowSSqIVRAuzplF5w
	w6t/iLZmuag+5cmbb6xSPAVmADSniJsO4b8dqkej9bxk7u8NWrsnsQ6IwTaMTJu1zSUThVEWoD7
	/mYub8OI5aGx/7qeLCM=
X-Received: by 2002:a53:ca02:0:b0:650:2257:e085 with SMTP id
 956f58d0204a3-65c18ddff59mr682510d50.30.1777526328567; Wed, 29 Apr 2026
 22:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260415193455.3869807-1-lgs201920130244@gmail.com> <202604300638.5ysk7jy1-lkp@intel.com>
In-Reply-To: <202604300638.5ysk7jy1-lkp@intel.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Thu, 30 Apr 2026 13:18:39 +0800
X-Gm-Features: AVHnY4KTWVjqmwRu5uzb2FBcih9ICZ6wwRPGHbQW1XPPHW286ml2iZ9APHrv-3Y
Message-ID: <CANUHTR90BbRGDwpK398AAW5V_ZqoCcuWbmuwk7P2-HuZE3M5uQ@mail.gmail.com>
Subject: Re: [PATCH] x86/rtc: fix failed fallback RTC device registration handling
To: kernel test robot <lkp@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Stas Sergeev <stsp@aknet.ru>, linux-kernel@vger.kernel.org, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F66FA0002
X-Stat-Signature: 5oepx889yhix6amhtoqsgi6c8pa39hh9
X-HE-Tag: 1777526329-343548
X-HE-Meta: U2FsdGVkX1+2mdsnmRf2syLp28J+GHOgVAui+2rztozUnX6W1G8hwa4NKGavGSbylpJW0klZrFoBn+JUB+x589cIa0zPVMZFoWN0dF7wmvN7LR22LepLy1OMUCS8plLa/wQU6BQ89yTKk04ci+WP6mwvo7sNQVxIFN6Kn3mQmGeWI3+fAwDdZKI4ShdyWZlJRUE3NfDqNbDQvc7eJ/lo92KNNNgk7ibALAKoR7eg+oWaeaWb9ui85HYbwxcEPRxXnpBJnMYhI5D3CRyDOyHRM9cVg8MwPU0HLY1bJSceeErVB58eLJJaFkPWiS3RPJoCSTIOfcfBp/1oBvQ8J7GTwJYtDqxXIWpQiFTP6AtSGXmqO8/TxoA/bSNQy0d06Xfq/204t9TFBVCKEFP3NXEfcCVDOYvDC2kX5U96NmJM1I+vOv9YSpBiyYJavz/kfi1f56mWKdlZYwYt8UrWI6n1PsyUfIWm9SpS95HSQBKKHEbnpsB90A25rnCV+jGzcOUw09B5xCh2Rf2/rc+u7xZqovMgn1vZBdp1jwCSs/JI8czL4fob6Qu5Lc+RdQqvMnnZM+H/lyR3BTWTrgktBGV1j/GIsQ0drSNvJw0TdoKPZBrAS4eoDwQ8AcBksUw/AWpY+Tz4DcZWZZR70aYR/iPuh0tabK9X4rN33x9fL09Z3kVvuiLzxeRmmnKFvcUUmeTpc71k+tvLagkKZOlnLTIaKEXo8vmWMD56vPZUoLaKuoZgWAGCg34EaFZnKGXfjfnN4wM4jTK3nPDTqV30lU0f+ez0GRuhQ/bRKx9KQI+/AbhY32XGLJ7Y9mKEz1aKyuIVH9SpkAve/8KJx/bXGSbyqPtb1BUL+glG8OPpxKTfrmYq4o33vj8AA0mNmufus104zMU9AmS0MK7coFM6lQofw0xUw11UjgfzGS3/e2YU8+dS7YA2eXZK+mToeWTczhPxcC+cNAVEzrpugSZzo1h
 aM7O2uv+
 i/6Eog4aF3H94TEhAJcv0+sHGAwkzRGVSbaMqSsHG3d0lrdFNgLKfaHUZbVpWxj9PvCD8+jzPKthsP89eIDFnIc9fiRaRFi0b6MOUvvs+98M0wajS4YwPgZaPly8pBJ2F70igLbSoXgNrHGv0h4HBJmtP4m6TN+r5gd5KNyeP8h6avL4e3vPz13fdPJt8us00VveEhNFgWFrVTcHeGAbI2yPFdqntNo4gU/Kkf+7v4Off5gdCG4rggyzVnQbRDKEIjI0VSyOuhCyRPnCObF6E9Vz6AxsrE10HX23/yxykpWHmvPN1qqMSZdffuMGZMnkE2Q9mAdaX/k+HPR2Id+cIP+IhNbXUWUKFTTyI3w1cO/Oc3+W1Q/sQhkMYPpyR4yWGSROfFmMtZoT208tVNljecsi4829wY4Aa2rgYgHx5xx1Svj7y2gYnAkciCcXi3q6CgWJlGxkWmMAWqOthOVG1/XJpqvCnRgLIxi9vOZ628JxSHuuQtpSpQXAFxMszUxyhhToj1IQu3bJQF+aeq3hCsJy+Ozjq37C3xtEIEaXj9lR3/Mt4Hz2cdiEVobvjuVLPW6Y6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please drop this patch.

On Thu, 30 Apr 2026 at 06:41, kernel test robot <lkp@intel.com> wrote:
>
> Hi Guangshuo,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on tip/master]
> [also build test ERROR on linus/master v7.1-rc1 next-20260429]
> [cannot apply to tip/auto-latest tip/x86/core bp/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/x86-rtc-fix-failed-fallback-RTC-device-registration-handling/20260416-130623
> base:   tip/master
> patch link:    https://lore.kernel.org/r/20260415193455.3869807-1-lgs201920130244%40gmail.com
> patch subject: [PATCH] x86/rtc: fix failed fallback RTC device registration handling
> config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20260430/202604300638.5ysk7jy1-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300638.5ysk7jy1-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202604300638.5ysk7jy1-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    arch/x86/kernel/rtc.c: In function 'add_rtc_cmos':
> >> arch/x86/kernel/rtc.c:142:9: error: 'ret' undeclared (first use in this function); did you mean 'net'?
>      142 |         ret = platform_device_register(&rtc_device);
>          |         ^~~
>          |         net
>    arch/x86/kernel/rtc.c:142:9: note: each undeclared identifier is reported only once for each function it appears in
>
>
> vim +142 arch/x86/kernel/rtc.c
>
>    133
>    134  static __init int add_rtc_cmos(void)
>    135  {
>    136          if (cmos_rtc_platform_device_present)
>    137                  return 0;
>    138
>    139          if (!x86_platform.legacy.rtc)
>    140                  return -ENODEV;
>    141
>  > 142          ret = platform_device_register(&rtc_device);
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

After re-checking the code, rtc_device is a static platform_device and it
does not provide a dev.release callback. Therefore calling
platform_device_put() on the platform_device_register() failure path is
not appropriate here and can trigger the missing release callback warning.

The build failure reported by the kernel test robot is only due to the
missing ret declaration, but the patch itself is not correct because of
the static platform_device lifetime issue.

Sorry for the noise.

Thanks,
Guangshuo

