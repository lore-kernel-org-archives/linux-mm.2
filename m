Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87811CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE738E0005; Wed, 22 Oct 2025 04:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD59D8E0002; Wed, 22 Oct 2025 04:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11F78E0005; Wed, 22 Oct 2025 04:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C12438E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:28:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C9BF13BA81
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:28:11 +0000 (UTC)
X-FDA: 84025072782.14.1CD8F50
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 69E8C10000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:28:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=GLezp4tR;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0owC0yjeYFWq5hM4a8PLkbslQ/Mn0NfnuO6/15Z7lAY=;
	b=WJSvwexQYhp8x61U+lXndwZnavOE/84oqZKed/EkT5qdfA/118l6wYItUnLFZuzEqW+QMA
	MNH1+8EyGWxKsy38JUldTkTf+ttX//+Knhg5QxjWQ3hhTF/qC8T0BDVW0kNKCoDATkHAks
	NDyng0VEKQJ+5g65rufry7l9Ba+eceM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=GLezp4tR;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121689; a=rsa-sha256;
	cv=none;
	b=YI70mR9hyYfkG9RSS1A3iw0oJL7By7HCMqjST2+Qm8nEUt7BFJdqqjgmdpoffF/ZqN5G6d
	eI8wQtY2m5ilTb/TJpdOSpt7/hr61GgHoHOBBIE9Zh1PtY/ApkWcNtaLQ30jWTuIu03xJl
	P2z4ft7POCob1+f422rtRnFiuLMAJm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761121686;
	bh=+qDTriJL1I8TlNCkThOTTjYJGjDQws6OfKtI9VmLqYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GLezp4tR0VrbO4ufLefY9gSD9aFklgbAX1ncNafEdBljwnmLzVoZ/n2P6arETT3yx
	 BhDYxIDpnFVx0OuZ4Mxenaamq9C93PodBccJx9kPbcbs1V8jdmH0gqROMaU4VCMCjR
	 y2TXGUxy8dzqtvY+WuuJrFW0L+TS1ayxAghS1NF8GVPnZn2xA9Nc+haDd+RSGiwDuM
	 LZnycgx5dmSetFT4S7nnM1Ej8gVvXyoIvRWgFP66pzUQpRKN/JumjSzNayA8tQBl4r
	 MQ/R99lq4mQaQ2a2JC+feu3/QSC+AVCkC6LCBRyTA//kwxaRPMb1uVCtAod8qf2zA0
	 zYZIzAL/bm0Ag==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A862E17E00B0;
	Wed, 22 Oct 2025 10:28:05 +0200 (CEST)
Message-ID: <64040015-2840-4210-8019-a39e605d87a0@collabora.com>
Date: Wed, 22 Oct 2025 10:28:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
To: Boris Brezillon <boris.brezillon@collabora.com>,
 kernel test robot <lkp@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <bbrezillon@kernel.org>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org
References: <20251021113049.17242-7-loic.molinari@collabora.com>
 <202510221301.wU3TSqMg-lkp@intel.com> <20251022100548.4dee241e@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251022100548.4dee241e@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 69E8C10000D
X-Rspamd-Server: rspam03
X-Stat-Signature: irzi7119o5asoyzfiwo5njaxyi1mzdim
X-HE-Tag: 1761121689-287200
X-HE-Meta: U2FsdGVkX1/i1BUBauY/m5SwMg0kuUzgFstDcg6LZovxxZYT04INvff5X+52esdEaOvmO1yK0UysQR+um+xoAsf61eVAM/kXIXqYNIfOs0D56xw2uVz901YV4nIOGde+1r/MKWE5LxNr8g1fSxN8gRECAgwNo3SnRGzgUfWbGadkEfQyX02+VDsY3usUQ0priIhAUxjyD5sgcEQDzgRCyDUi2MFSWgf6hDcZOze5b3CGadc+uAlYaI6Ma9h5BrRZI+a/MQ/URlsncTdHkZXMKcQN+9hOIsPHzsYoWINbHjH4kjgWP/M9rWf57B/jffnvX183JRZkGeyu/d7H13Y8cvR1mKvDX/N7vRWhuK4jULjPcSEZKkpWiqaR7gMlcGOCu1+4yXOwjAr6sLc4XXF6mEArdsqSrrCA0LdI4hS+C0jSZOa6LPEsfaQfDaFymNRGSZCi3hPvLrdquH54T1wD7YTbZtIss7AMqFoM6qfPYIad2X1S2m9h227gj2ayvcIUD5gAt8qbOrSjBRIiOw5QbHBf03kA3uvsldGatg4oIU7cl15VXgObdYv1qrBLPzoodiwE1voTOR9mPwneU2+ISk8YLBo9SnOIuBQfBuIT0+QCVaVx9/qvSz1cCx9vukGn8fKMorCP/sgS8UYaHYwmDglUaKIKQYIHFPpSfZnnCtU6Enuf2iTnJbVEqVOOJoC9KdPE6AgOgDf8cH0bM/neYJVlXJ3jUj+1Sbp/qzs9IeNzdvB/jLlG7j3qX27wjp6Uvwew/oXDB1gvA2myp1q619HtboxGR+44WYQnu4RSFZrSZH3z65XmOQ8UgI5vQKBat6+Bbpwl3F8nigzxVj/y4TqCXPbWIiGEeynaV4iIOX8idj9TZycRyGYKM4oBUeAyKh+FbfLlC/F3/BaHtKnfT5z/5soIYsddgRKGcWLowzQCFLklyz6RPXq6hk5SH/o75IZ/YyzinOGLgUYP92M
 4vIAXQ5t
 djoem6CggtVSvYB1Dlrd70FAlvcgkAfXIBItb79Ygm4FSTK2WJhssiUev6SjB3zkM2usRBRuNF+rQhOcsQmcy7o9IWrzejWrxUDk+PuF2XuahbqskNtZXjkJMkjG2xrysPZO7GAjyw/8/Mns6li0MuZFFliEwDMeHa1wLnNiLbGp9U8Mf+dunAx031RNXoFiGkbag3db8c4MpkbecC1BgSSfNBUkr24l3sQCBWZD2D3z9/Txv0oLwsgq2ZKuH5mf5KMQvXIxOuGnvVHROS7PlCb/0Lzgo9Zn4MnYb7TU8lhwOvPK94KxX6QlGDJ0P8fE6tr2I4ClzvTkGvRyc0JDHSZVVM731l4aEGuqH+EA9Po8y54E4rP/4tUAq+URkBGhqnK04F6pWt4JSeqcC44pmzgZ9T/dpdZLkmeBSFSodl87MDpuy//KnYmu/0vpxDV/xMRV+Aa9uRHCyhoguMeTW5/9ReFHtCM4PYAh4WblwTXwhsuWRPyR/ARhuihrQIwOJD5h4lynwrzLIUMfFnyAcAOYA4y8MP2MVJ8xkE+WvBAe1Pf2NyNQrJLsZX2P8MyFTeNpKK1G3WCMO3/HnoV4Rfbqctk4v/44czThQcTY7qI2YSbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

On 22/10/2025 10:05, Boris Brezillon wrote:
> On Wed, 22 Oct 2025 11:25:10 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
>> Hi Loïc,
>>
>> kernel test robot noticed the following build errors:
>>
>> [auto build test ERROR on next-20251021]
>> [also build test ERROR on v6.18-rc2]
>> [cannot apply to akpm-mm/mm-everything drm-misc/drm-misc-next linus/master v6.18-rc2 v6.18-rc1 v6.17]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-shmem-helper-Simplify-page-offset-calculation-in-fault-handler/20251021-193355
>> base:   next-20251021
>> patch link:    https://lore.kernel.org/r/20251021113049.17242-7-loic.molinari%40collabora.com
>> patch subject: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
>> config: x86_64-randconfig-003-20251022 (https://download.01.org/0day-ci/archive/20251022/202510221301.wU3TSqMg-lkp@intel.com/config)
>> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251022/202510221301.wU3TSqMg-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202510221301.wU3TSqMg-lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>     drivers/gpu/drm/i915/gem/i915_gem_shmem.c: In function '__create_shmem':
>>>> drivers/gpu/drm/i915/gem/i915_gem_shmem.c:511:59: error: 'struct drm_device' has no member named 'huge_mnt'
>>       511 |                 filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
>>           |                                                           ^
>>
>>
>> vim +511 drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>>
>>     486	
>>     487	static int __create_shmem(struct drm_i915_private *i915,
>>     488				  struct drm_gem_object *obj,
>>     489				  resource_size_t size)
>>     490	{
>>     491		unsigned long flags = VM_NORESERVE;
>>     492		struct file *filp;
>>     493	
>>     494		drm_gem_private_object_init(&i915->drm, obj, size);
>>     495	
>>     496		/* XXX: The __shmem_file_setup() function returns -EINVAL if size is
>>     497		 * greater than MAX_LFS_FILESIZE.
>>     498		 * To handle the same error as other code that returns -E2BIG when
>>     499		 * the size is too large, we add a code that returns -E2BIG when the
>>     500		 * size is larger than the size that can be handled.
>>     501		 * If BITS_PER_LONG is 32, size > MAX_LFS_FILESIZE is always false,
>>     502		 * so we only needs to check when BITS_PER_LONG is 64.
>>     503		 * If BITS_PER_LONG is 32, E2BIG checks are processed when
>>     504		 * i915_gem_object_size_2big() is called before init_object() callback
>>     505		 * is called.
>>     506		 */
>>     507		if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
>>     508			return -E2BIG;
>>     509	
>>     510		if (drm_gem_has_huge_mnt(&i915->drm))
>>   > 511			filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
>>     512							 size, flags);
> 
> Maybe instead of this drm_gem_has_huge_mnt() (or in addition to), we
> should have a drm_gem_get_huge_mnt() helper, so we don't have drivers
> dereferencing drm_device::huge_mnt directly and we can get rid of it on
> non THP configs.

Yes, drm_gem_get_huge_mnt() should be enough. This would prevent build 
errors like that for builds with CONFIG_TRANSPARENT_PAGE=n without 
having to insert ifdefs and would also just compile to a single 
shmem_file_setup() here. The few places which actually need a boolean 
value can simply do !!drm_gem_get_huge_mnt(dev).

> 
>>     513		else
>>     514			filp = shmem_file_setup("i915", size, flags);
>>     515		if (IS_ERR(filp))
>>     516			return PTR_ERR(filp);
>>     517	
>>     518		/*
>>     519		 * Prevent -EFBIG by allowing large writes beyond MAX_NON_LFS on shmem
>>     520		 * objects by setting O_LARGEFILE.
>>     521		 */
>>     522		if (force_o_largefile())
>>     523			filp->f_flags |= O_LARGEFILE;
>>     524	
>>     525		obj->filp = filp;
>>     526		return 0;
>>     527	}
>>     528	
>>
> 

Regards,
Loïc

