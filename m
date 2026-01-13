Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5FAD2D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34886B0005; Tue, 13 Jan 2026 07:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C096B0089; Tue, 13 Jan 2026 07:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918386B008A; Tue, 13 Jan 2026 07:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDD06B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:56:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F2081AA443
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:56:39 +0000 (UTC)
X-FDA: 84326939718.12.A47183E
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A5FB4000A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:56:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vvxXFcmf;
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.66 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvh70Q1yDkMCMI+G/1qICpaiox12c57+ZdVdd7SsuGQ=;
	b=N6rcMCndqK3+8tIZJDgdjlIHjNZxyqZYfcvR19uAIXf59L8DgSqUVarWBCPXhA78SCJ0Ox
	9+gS3ey6ne9flKWCJai2AhFidRCLvvNlgxUVDK87M/G5VHp5cB7Tv1oi02qs2/hokFtOMa
	iMbN3X2nYKFw39gbaIdC9zjPnoXXDbY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vvxXFcmf;
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.66 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308997; a=rsa-sha256;
	cv=none;
	b=zImPh2udOaG4Z8pNJDZNJXHWdgV+Hw3gkw4gYP5jhnOjI9XPAhrA260RArTib3sVKeF9Bn
	4UeoHt7XfJJqxzfR/jOGSbuNVMXfvYhIqKNVrrAZwJD/CQreulUbPmr86+ssUazGVmlsEg
	qHIGLpusPsykQYQ1UhxFzV+MsClBkbY=
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-42fbc305552so5575843f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768308995; x=1768913795; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wvh70Q1yDkMCMI+G/1qICpaiox12c57+ZdVdd7SsuGQ=;
        b=vvxXFcmfck0Tgh5aGQ0XEaxsoQ7HnoTnUpsOq7N6GboCF/aT86/z2PqT/enVJNLS23
         n0SltNyla216mLZrPnhPB7o5Rn+nT0iy48yM3inEkYzalSet48af9+Gl3Y8PHWTWsi5M
         SW5SfJD1qBzKzBqxR5TcO9U2GjfCwP94oSyWXSHCEsjJKyOkLbTQe/gPXdhY7ANGaosc
         k5Y7dVinP6tmbEjgkPyodSu4+op6FG6jsOcaSEsYV2A5+lpUDwuXLaEsK0DI9KOzU3e2
         HoFRXDM/zZD7GMf49pVRFnFARmDhsM7wysiJ/I9pSx7mgftQu6s1Ghzxfoq8Ht14LT9z
         YsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768308995; x=1768913795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wvh70Q1yDkMCMI+G/1qICpaiox12c57+ZdVdd7SsuGQ=;
        b=uyKGUNrscKNwHpd3s/iTbXQ86SnGjU1jxeRbsfRE6T6Bb69LdDtYLFgg14HA30s2JZ
         zIcIAPKhRuch5ej1o7m5BNK++hcxZDqasYsFWwzufxWrzEIdEKviVcAuUmUYJkdjJ/7g
         PHF1QPZzT/V1nro00K5OlEPgkO1FoN3Q0Hnc9QJ+j950t9GN/QzQxLpUlDidjLEoTKQt
         msejRheVoMiYyyWFL7qP9oeWj3RjpQO8MpEefAlb6FL+B6AjdGh6/E5aB6hscLbmWnZc
         4IklFWQQQ/ORoGVNAP3Q0Qbdtcdg1fTs/OKdiLhyLwdmUqGUELhCoH6eHs1Qfla8rm4H
         fciQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS3NEhv5IQShXhcqnZ70PLGVEuT37KC5WKlfbKm76UVHKRXMUDxmeSke/8gquO8Slf3qYxMk3OLg==@kvack.org
X-Gm-Message-State: AOJu0Yz7JbGeBF1cSFEKQYOLqNTSbk3th4QEreXm3m5PJzg2KeVDLBqZ
	ZhAE+ktHhz2zswfw1g8yfxURJlLiQPinFCFCsaa+8gUzqWazVCvKVPUe7RSqu8XRXlc=
X-Gm-Gg: AY/fxX6u5jxfhmHg+Mv7XQAGb50Fb3DuvONHTPNM9YbTogHwbzdKaxb7d4WOPUwtRPD
	SswcQNcy8sq+Ejr8E8J1IfYCDMoxmPN4lAZVCm0mdh1cy9DiwXljU6AV84G+xAj0KHlRHKr2i6m
	8+Hb/zT0jnomslLFWrYPb0BOTW6NAD8dRasH4CLWFT5gNfJvmVVIaoNE8SFgKlS7uOtYnBpPE3/
	R7d9x6OIvKVW41LlKthmy/gbQLgjrn9k3zqoEhVvBG+JU5fucCHUlusmQJM2yiXsukv863Llpoo
	aM9qU0G5x0d9QwPNKMNYjg68u5lOmoHij9mOKAeYTTT7uSVJbbb5Kvdwk5Aj1vAuIFMkfKJunRc
	T44sdOGFcvmos0ISPZWRD7h2u4g7tEYvudAFJWVaSw6C42vXX9iXKxOYwR6lLRynpbJF5WmVIQH
	/QX4DLMgtkeMQCCfk/
X-Google-Smtp-Source: AGHT+IHgpWXybRkczvtnKd3NbBUIKjOlWu0IsIakI5sIPTmCI2xKZl/AEbekx6IbShd24xTNaLfCag==
X-Received: by 2002:a05:6000:4287:b0:430:f41f:bd5d with SMTP id ffacd0b85a97d-432c37a300emr23162223f8f.55.1768308995441;
        Tue, 13 Jan 2026 04:56:35 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e180csm42970728f8f.10.2026.01.13.04.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:56:35 -0800 (PST)
Date: Tue, 13 Jan 2026 15:56:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jan Kara <jack@suse.cz>
Cc: oe-kbuild@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Dev Jain <dev.jain@arm.com>
Subject: Re: mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12)
 to unsigned variable 'ra->order'
Message-ID: <aWZA_rfBLWa9eCnr@stanley.mountain>
References: <202601131311.g3lyUAks-lkp@intel.com>
 <s47y6ysj4c2z5c5axtxbeset4divigctg4s3p7gbgmvfkoizeu@malcpodvrm46>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s47y6ysj4c2z5c5axtxbeset4divigctg4s3p7gbgmvfkoizeu@malcpodvrm46>
X-Rspamd-Queue-Id: 2A5FB4000A
X-Stat-Signature: 7r5jj3js63mmg19xg9qfk9sad3pat6sb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768308996-409234
X-HE-Meta: U2FsdGVkX1/ddb16iMhPv7Lyh5M7jgjEfxhZ+LwhGtcYO2A7c7P9kmHS3WfN9mV/+fKKu/16PNWXYno/iMPD3Z0Tyg7H/H2IECF+w7bQlYS3/uO7NhPglRjNJsEj+yYvIEyJ4Uo8ZYwgpSuMTNWvHHp6pYjCA3rtOhz+7840rzqK7Qs817Dr04HdjvKeuOHc8MWniZ2WFWDHNGJ4RJzWJCpNVyedniEBD1+1vLNTqQKDcMav4sAHBm8mwbffOnLViphjPm0VRBOX4fGyvYr3tMNhOKksDFxy5xcLdsi8RVkPUPNlzZlWPril5eZz0tVIIuU7dhCn/A8undj4X8i8q6iVvOVQcY+OVXNK8T9uzkVeSFkNCWEjuRdc0Swim233dVmi5N2qKCLKRfMa5z44x3HdgBI6BJLqNV8Uz5bmbv5/ORjeGBuzEDPWZL4rvS006dw2z9hLXBhpsVfpKRb0FHOQVdMDv4S0e0gpCoyfL26G7ITVtW1bB5YGKBjwJVOzEC7xmNdptd4Gn0PIRpvdjdPi8XG/5sB3gkfLPXCtutCzgN2hCidxy8J3MEFBRUuur5rX2qk84gogZmV50CbjEEyALsS7koTz/10qHDnFMNhO2YXZP/LfUrBGtH80twRGsA2lc1wX3BD1D61bPzyKLEPA1JJ82f2hf4yoZl5gybyMSGZJKvsPrFMG9xcDrEhhsBD9A1XhWmxmch+UTtMYqQKdo4S2X1MQrYuRQS/5xBSi8uwdlCXViEhwN598A8ddxzHxNMmNGRzutCd36Fx7nSmRDUHXtbuGjzb9alGvV1lRW2z/h71naonNLEwSHORvPtiJh2aUDh6TNNJzlJF+/4fhVgUG/MjOAf7xY6p8JM+An1pHKsmqOIC5FTuESNrBcpGc7c27aUYDogOlxSoiSOwB1hcaNepmQcA5ci59lUfHoIqhiD6q4aPZxKeYnpuXTmVfObxw/nHVRtoJtgd
 c86U6IZP
 lp4SI/1UnD7EeE5bDskcn8/oEpV6N5dhbmU3zbk3thw1fHAdpvDltT4zyn4gHKZAnCSQ+fYNzPiNkjkMnxC8mA7846phz+xC4pyjzEpPVdDUmFT7Y9XSN3eiW8SuQCFZDwIKOReJ3cwl8fZX03UgOEYfUPn17yoY3dUZJKtv9oLBZ4+vLGuJJslaJGBHk3JTCgz5PqO6TJ/ZIYBAEVJgZTlYi9DOqTvoP4O4Xyhc0y4981MthF51fLdRJOkLoGV2ZBI2z3RzLgM+9YQ1A9CgK78plfbW0382JiYulXTcOloVDOXl+7Vsjw0JJ5M+2OMsL3o4Ct73bKc4+1sZ2bH7mii+PdL0Oy1yg27ODioHfcmjKXmto4tAdYbpadRPTyc8VijYDDLmOJyVQWVVHdHJgO/KWgdcGM26QaAQPtIl28dJ3sGnOEGoFGUgDeJ6bjkdeLFA9cCtL1iCowcFx9E1i4ub+Z2eeGu99etKL3h8NPA79loDAJ83esFaW75lPIQq3KvX1i1QFIei5OVrH5Qlzie71auXr/VAjcgKTNVwVmxskUTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 01:24:20PM +0100, Jan Kara wrote:
> On Tue 13-01-26 14:12:28, Dan Carpenter wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   b71e635feefc852405b14620a7fc58c4c80c0f73
> > commit: 9f1edf1aedac1b287355f63f768ba4275de72dca mm: readahead: make thp readahead conditional to mmap_miss logic
> > config: x86_64-randconfig-161-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131311.g3lyUAks-lkp@intel.com/config)
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > smatch version: v0.5.0-8985-g2614ff1a
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > | Closes: https://lore.kernel.org/r/202601131311.g3lyUAks-lkp@intel.com/
> > 
> > smatch warnings:
> > mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12) to unsigned variable 'ra->order'
> ...
> > 9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3306  		ra->async_size = HPAGE_PMD_NR;
> > 9f1edf1aedac1b2 Roman Gushchin          2025-10-06 @3307  		ra->order = HPAGE_PMD_ORDER;
> > 
> > HPAGE_PMD_SHIFT is zero in this config?
> > ra->order is a u16.
> 
> What's the config exactly? I suppose CONFIG_TRANSPARENT_HUGEPAGE is
> disabled in this case, isn't it? In that case force_thp_readahead will
> never be true and thus the branch with the assignment can never be reached
> AFAICT...
> 

Ah, yes.  You are right.  force_thp_readahead is false in this
config.

The truth is, I could easily disable these kinds of warnings in smatch
because this is marked as an impossible path.  if (is_impossible_path())
return...  I've done that on a case by case basis in the past but maybe I
should just do it globally.

regards,
dan carpenter


