Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9C9D29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1316B0005; Tue, 13 Jan 2026 05:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F606B0089; Tue, 13 Jan 2026 05:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B596B008A; Tue, 13 Jan 2026 05:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42126B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:07:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 494B6885E3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:07:40 +0000 (UTC)
X-FDA: 84326513880.27.172567D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id F259320011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:07:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vw6A2SOP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ecfeq0Qg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vw6A2SOP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ecfeq0Qg;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768298858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C93wmg6eCN5hmmgdPu4bnr1uHsyfsNRgV5wWcpmEgrI=;
	b=re1SaFQfbZBXIoi/X4MV/0iiw3/zIsnRigxf2yXuNJihrLJggPpf11T/gO8WE66qpDz39Y
	sK21kcfY4VEd0op9BOkr8cj4trdgE7oEaRcW/QqVzb9ss3tuoZZlKiaYvCmcWR4eOuH0k0
	m6j44ZsQAdk/wV+VlRhw7ntJkq0uQ7o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vw6A2SOP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ecfeq0Qg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vw6A2SOP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ecfeq0Qg;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768298858; a=rsa-sha256;
	cv=none;
	b=jNaPXsTvg3d+OFBNVZ7OQpWT0jaKvgijbVFJz+pO5ythKLzIbJBo0zXNvYagN2oIunNh3K
	sVhOsT7I9fhkVbGWvai7alwohE43ncjTT9pjla79NbQgWSjrEWm8AsJpj+KWObmeHi1zxJ
	vTIrm16ye32uNsh1E180IZL+HEU/A3c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1915133681;
	Tue, 13 Jan 2026 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768298856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C93wmg6eCN5hmmgdPu4bnr1uHsyfsNRgV5wWcpmEgrI=;
	b=vw6A2SOPDkY0Jvj3YUH0eHMLbhWtDAwqKwiQNP+q6c6beOX/GW9W4WOlNl8NyX7QGpAOUg
	dyJEm/nMIc2Da3MWNmlfdZG/Ov26MsHp+YAi5X4dBPzX6zyUg1hQ2nJ1Lm1qLoNq9hslDb
	YuvBOPesukc3vouUlkDnOgy0XFekBgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768298856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C93wmg6eCN5hmmgdPu4bnr1uHsyfsNRgV5wWcpmEgrI=;
	b=Ecfeq0Qg4rySySSqT1YR/j0k4V+iD2zWUAfwzMLA9olsRXpcK0cbJy3OajPQVW4p+im1kx
	S9ux8OceD0dsWXAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768298856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C93wmg6eCN5hmmgdPu4bnr1uHsyfsNRgV5wWcpmEgrI=;
	b=vw6A2SOPDkY0Jvj3YUH0eHMLbhWtDAwqKwiQNP+q6c6beOX/GW9W4WOlNl8NyX7QGpAOUg
	dyJEm/nMIc2Da3MWNmlfdZG/Ov26MsHp+YAi5X4dBPzX6zyUg1hQ2nJ1Lm1qLoNq9hslDb
	YuvBOPesukc3vouUlkDnOgy0XFekBgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768298856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C93wmg6eCN5hmmgdPu4bnr1uHsyfsNRgV5wWcpmEgrI=;
	b=Ecfeq0Qg4rySySSqT1YR/j0k4V+iD2zWUAfwzMLA9olsRXpcK0cbJy3OajPQVW4p+im1kx
	S9ux8OceD0dsWXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C3B43EA63;
	Tue, 13 Jan 2026 10:07:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5wd/AmgZZmkxRwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 10:07:36 +0000
Message-ID: <1602fcdc-7f3f-4483-9de8-02278a0598c0@suse.cz>
Date: Tue, 13 Jan 2026 11:07:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] 9b0317d1c2:
 xfstests.generic.629.fail
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
 Harry Yoo <harry.yoo@oracle.com>
References: <202601121022.41666cea-lkp@intel.com>
 <d7263d12-e6e5-48d9-85b5-0937f7c0dac9@suse.cz>
 <aWXnYab+ylpMAgQf@xsang-OptiPlex-9020>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aWXnYab+ylpMAgQf@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s5keq65s8a1fi5wiytqkjpiba3gk4z4q
X-Rspamd-Queue-Id: F259320011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768298857-490072
X-HE-Meta: U2FsdGVkX1/PqUYUwfC/1qFJsVfQ9z67Wsoy81+/2L0+PhY83RdnK4sLHomJcRP5xA30DILMQxvFKR+OC4lep2agqgKckdfxZRHN+76AlIeEzHSoNaAlLlMQljSoYvEJ/kJUwyTlZO4r9jbF0yWojzORuL3lQRsbecmqECuwnEMaYztvP4V+HocZrGjrYubhzeqabVWL5yZMOtXxYztLYk+BjwthhBjpQLwgUOT1CxNyiRxt93fcopBgz/dWslFXTqHt9h+PPcCJ8K45+ugFvhXIb7xu7ExxfBytF1a4GbhkXzHaBJi3OSj+xwtllhwYkU0jeIf7pjQUoz336UTerxTO0xIdEB0QyRPcanNJ8wC3xr+avnG7fnCHegzO6rprqgdBMGdnBvA2nNxitnK7wwsveGM1f5DcM1Dbymt8XNTQiyxXgC4RG2OOSukTJ4Zl7In514X0HvquaZ8CwhfU0ZFGVbTLA8hddeLzCCPL+nWZxI2m9KPRJrrfkYVONtTH5lF0In+oszKswXwhCqLHPojowgyoSbVFmo5rvZU4iVt5zgN/YsALluuRku6zijuJb2Nj9XhyQBXyQOl4Fw7g/Iw8vr7hYSitXGB1rP1gxHyO93/GTkg/quVTI6abjBaIMJ2hKsPcIjNT7XEtj6TqVT68/kg+T/AQ9ZB0ggaDFCyhDJAbBmQxYNX3PujOZ7s5EHGe/EI6BBDgDF8TQAwsEPOgok9Yv7tOHSZ1oK891cSp4HjtKxuxRZ2obPGOTLvSXRnvCfw9D7G3gxNmQxsENA1zWXq9NpAKU/Qg3BoOtjwFaVmRT9X5UvzGNeEDGebUtArlv8q1ja9Pbu6A72+VVzDR0O8XwZlLM2Wf8aOdJYlW7MmzByQR5F2MJFB6HiYW0qNnO6vOohWDyNs5dDeq3YTd4CHtqX5lByJFwVP/gPN9KaLCtbMmd1YOA2j8jSyHaOjf6dmWIj1lv2hIf7A
 mywz305B
 1vFLISKscJ3bYbCNte1UHVfvqf64cUNduOVxjH5m19yBw3c1Tyku5RQmMy36qJBfdXJlc8f9Bvyt57HbeMGZovMOvGBPAMcGQW+hh50RM8/P9SzwpPln9o2D/IVnNLvgSxk5qrSzHMkRIoEqjPu5eY0s/Au8J01G1NZDM+nRUm2wHiRxhrndkDvufCtOTE2EvoeURWxY/T+EceOdkaAKFz6jy/84b+N96nNEtiE/dvGPaqCbwBZEK7e6xITfECbemP2rN9RqmhPuJwC3i16V+AFCzMm350GBRIg/EG+6SzAvDqo175xETHxyDf1exEe0oOn9tTW2h771Sa4vYnpqaaTpkz1RnqiIwsIdVOp87osK6Qet3dJOCqbn0dJPLCLkQidizFkNl2v4NYwU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 7:34 AM, Oliver Sang wrote:
> hi, Vlastimil Babka,
>=20
> On Mon, Jan 12, 2026 at 09:34:20AM +0100, Vlastimil Babka wrote:
>> On 1/12/26 03:54, kernel test robot wrote:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed "xfstests.generic.629.fail" on:
>>>
>>> commit: 9b0317d1c2ed590d69d39eba701cd3eb082ecc31 ("slab: remove cpu (=
partial) slabs usage from allocation paths")
>>> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/shea=
ves-for-all-rebased
>>>
>>> in testcase: xfstests
>>> version: xfstests-x86_64-df16c93a-1_20260105
>>> with following parameters:
>>>
>>> 	disk: 4HDD
>>> 	fs: btrfs
>>> 	test: generic-629
>>>
>>>
>>>
>>> config: x86_64-rhel-9.4-func
>>> compiler: gcc-14
>>> test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skyl=
ake) with 32G memory
>>>
>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>
>>>
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>>> | Closes: https://lore.kernel.org/oe-lkp/202601121022.41666cea-lkp@in=
tel.com
>>>
>>> 2026-01-11 11:59:36 cd /lkp/benchmarks/xfstests
>>> 2026-01-11 11:59:37 export TEST_DIR=3D/fs/sdb1
>>> 2026-01-11 11:59:37 export TEST_DEV=3D/dev/sdb1
>>> 2026-01-11 11:59:37 export FSTYP=3Dbtrfs
>>> 2026-01-11 11:59:37 export SCRATCH_MNT=3D/fs/scratch
>>> 2026-01-11 11:59:37 mkdir /fs/scratch -p
>>> 2026-01-11 11:59:37 export SCRATCH_DEV_POOL=3D"/dev/sdb2 /dev/sdb3 /d=
ev/sdb4"
>>> 2026-01-11 11:59:37 echo generic/629
>>> 2026-01-11 11:59:37 ./check generic/629
>>> FSTYP         -- btrfs
>>> PLATFORM      -- Linux/x86_64 lkp-skl-d03 6.19.0-rc1-00010-g9b0317d1c=
2ed #1 SMP PREEMPT_DYNAMIC Sun Jan 11 19:50:05 CST 2026
>>> MKFS_OPTIONS  -- /dev/sdb2
>>> MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch
>>>
>>> generic/629        _check_dmesg: something found in dmesg (see /lkp/b=
enchmarks/xfstests/results//generic/629.dmesg)
>>
>> Hm I didn't notice anything suspicious in dmesg.xz - any idea what thi=
s
>> refers to?
>=20
> sorry, our bot has a bug to capture serial output fully in a consistent=
 way in
> this case.
> attached one which includes more information.

Thanks

> [   60.803765][ T5096] ------------[ cut here ]------------
> [   60.809075][ T5096] kmem_cache_destroy bio-240: Slab cache still has=
 objects when called from bioset_exit+0x307/0x490

Likely the same issue as was reported for the slub kunit tests and
hopefully fixed here:

https://lore.kernel.org/all/20260112-sheaves-for-all-v2-1-98225cfb50cf@su=
se.cz/

> [   60.809083][ T5096] WARNING: mm/slab_common.c:562 at kmem_cache_dest=
roy+0x14e/0x170, CPU#1: dmsetup/5096
> [   60.829092][ T5096] Modules linked in: dm_mod binfmt_misc snd_hda_co=
dec_intelhdmi snd_hda_codec_hdmi snd_ctl_led snd_hda_codec_alc269 snd_hda=
_scodec_component snd_hda_codec_realtek_lib snd_hda_codec_generic btrfs b=
lake2b libblake2b xor intel_rapl_msr intel_rapl_common zstd_compress raid=
6_pq x86_pkg_temp_thermal intel_powerclamp coretemp i915 sd_mod sg snd_hd=
a_intel snd_soc_avs kvm_intel intel_gtt snd_soc_hda_codec platform_profil=
e snd_hda_ext_core drm_buddy kvm dell_wmi snd_hda_codec ttm snd_hda_core =
snd_intel_dspcfg irqbypass snd_intel_sdw_acpi ghash_clmulni_intel dell_sm=
bios rfkill snd_hwdep rapl dcdbas drm_display_helper mei_wdt snd_soc_core=
 ahci snd_compress dell_wmi_descriptor intel_cstate wmi_bmof snd_pcm dell=
_smm_hwmon sparse_keymap cec libahci mei_me snd_timer intel_uncore mei dr=
m_client_lib i2c_i801 i2c_smbus snd libata drm_kms_helper pcspkr soundcor=
e intel_pch_thermal intel_pmc_core video pmt_telemetry pmt_discovery wmi =
pmt_class intel_pmc_ssram_telemetry intel_vsec acpi_pad fuse drm nfnetlin=
k
> [   60.917640][ T5096] CPU: 1 UID: 0 PID: 5096 Comm: dmsetup Tainted: G=
 S        I         6.19.0-rc1-00010-g9b0317d1c2ed #1 PREEMPT(voluntary) =

> [   60.930326][ T5096] Tainted: [S]=3DCPU_OUT_OF_SPEC, [I]=3DFIRMWARE_W=
ORKAROUND
> [   60.937097][ T5096] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, B=
IOS 1.1.1 10/07/2015
> [   60.945162][ T5096] RIP: 0010:kmem_cache_destroy+0x15e/0x170
> [   60.950802][ T5096] Code: 5b 5d e9 85 47 11 00 c3 cc cc cc cc e8 1b =
1e a2 ff eb 9b 48 8d 3d 42 87 64 04 48 8b 53 68 48 8b 4c 24 10 48 c7 c6 7=
0 09 3e 84 <67> 48 0f b9 3a e9 18 ff ff ff 0f 1f 84 00 00 00 00 00 90 90 =
90 90
> [   60.970186][ T5096] RSP: 0018:ffffc90004027818 EFLAGS: 00010202
> [   60.976081][ T5096] RAX: 0000000000000001 RBX: ffff888214f277c0 RCX:=
 ffffffff8271f597
> [   60.983898][ T5096] RDX: ffff888111b2d760 RSI: ffffffff843e0970 RDI:=
 ffffffff8633a210
> [   60.991688][ T5096] RBP: 0000000000000001 R08: 0000000000000000 R09:=
 ffffed10fbd98579
> [   60.999481][ T5096] R10: ffff8887decc2bcf R11: 0000000000002710 R12:=
 00000000000000f0
> [   61.007288][ T5096] R13: ffff888214f277c0 R14: ffff8881e393c0b8 R15:=
 ffff8881e393c050
> [   61.015110][ T5096] FS:  00007f8dbc0b7d80(0000) GS:ffff888857975000(=
0000) knlGS:0000000000000000
> [   61.023865][ T5096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> [   61.030275][ T5096] CR2: 00007f637994641c CR3: 0000000159b52006 CR4:=
 00000000003726f0
> [   61.038065][ T5096] Call Trace:
> [   61.041194][ T5096]  <TASK>
> [   61.043988][ T5096]  bioset_exit+0x307/0x490
> [   61.048245][ T5096]  cleanup_mapped_device+0x8b/0x480 [dm_mod]
> [   61.054102][ T5096]  __dm_destroy+0x322/0x550 [dm_mod]
> [   61.059258][ T5096]  ? __pfx_dev_remove+0x10/0x10 [dm_mod]
> [   61.064755][ T5096]  dev_remove+0x231/0x300 [dm_mod]
> [   61.069715][ T5096]  ctl_ioctl+0x380/0x710 [dm_mod]
> [   61.074590][ T5096]  ? __pfx_ctl_ioctl+0x10/0x10 [dm_mod]
> [   61.079981][ T5096]  ? _raw_spin_lock+0x80/0xe0
> [   61.084508][ T5096]  ? fdget+0x54/0x3b0
> [   61.088325][ T5096]  ? kmem_cache_free+0x294/0x510
> [   61.093097][ T5096]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
> [   61.097970][ T5096]  __x64_sys_ioctl+0x135/0x1c0
> [   61.102568][ T5096]  do_syscall_64+0x7b/0x6c0
> [   61.106933][ T5096]  ? do_semtimedop+0x228/0x2a0
> [   61.111533][ T5096]  ? __pfx_ksys_semctl+0x10/0x10
> [   61.117340][ T5096]  ? __pfx_ksys_semctl+0x10/0x10
> [   61.123145][ T5096]  ? __virt_addr_valid+0xc4/0x200
> [   61.128016][ T5096]  ? rcu_segcblist_enqueue+0x1d/0xe0
> [   61.133159][ T5096]  ? __call_rcu_common+0x341/0x950
> [   61.139137][ T5096]  ? kasan_unpoison+0x40/0x70
> [   61.143648][ T5096]  ? __pfx___call_rcu_common+0x10/0x10
> [   61.149973][ T5096]  ? __kasan_slab_alloc+0x2f/0x70
> [   61.154838][ T5096]  ? do_syscall_64+0xb2/0x6c0
> [   61.159353][ T5096]  ? kmem_cache_free+0x2a7/0x510
> [   61.164142][ T5096]  ? fput_close_sync+0xd8/0x190
> [   61.168831][ T5096]  ? fput_close_sync+0xd8/0x190
> [   61.173537][ T5096]  ? __x64_sys_semtimedop+0x153/0x1a0
> [   61.178749][ T5096]  ? __pfx___x64_sys_semtimedop+0x10/0x10
> [   61.184308][ T5096]  ? __x64_sys_close+0x79/0xd0
> [   61.188919][ T5096]  ? do_syscall_64+0xb2/0x6c0
> [   61.193429][ T5096]  ? do_syscall_64+0xb2/0x6c0
> [   61.197943][ T5096]  ? do_syscall_64+0xb2/0x6c0
> [   61.202453][ T5096]  ? irqentry_exit+0x76/0x4d0
> [   61.206963][ T5096]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   61.212686][ T5096] RIP: 0033:0x7f8dbc3eb8db
> [   61.216978][ T5096] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 =
04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 0=
0 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 =
00 00
> [   61.236339][ T5096] RSP: 002b:00007ffdb55284a0 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
> [   61.240308][  T259] 2026-01-11 12:02:14.799418 (+0000) -73855.722057=
 +/- 0.000324 internal-lkp-server 192.168.1.200 s5 no-leap
> [   61.244561][ T5096] RAX: ffffffffffffffda RBX: 00007f8dbc4e2bd6 RCX:=
 00007f8dbc3eb8db
> [   61.244563][ T5096] RDX: 000055c5ab615b30 RSI: 00000000c138fd04 RDI:=
 0000000000000004
> [   61.244588][  T259]=20
> [   61.255911][ T5096] RBP: 00007ffdb55285c0 R08: 00007f8dbc535968 R09:=
 00007ffdb5528350
> [   61.255926][ T5096] R10: 00007f8dbc534d18 R11: 0000000000000246 R12:=
 00007f8dbc534d18
> [   61.264411][  T259] INFO: lkp CACHE_DIR is /opt/rootfs/tmp
> [   61.271491][ T5096] R13: 00007f8dbc534d18 R14: 00007f8dbc534d18 R15:=
 00007f8dbc534d18
> [   61.271495][ T5096]  </TASK>
> [   61.273670][  T259]=20
> [   61.281448][ T5096] ---[ end trace 0000000000000000 ]---
>=20
>=20
>>
>>> Ran: generic/629
>>> Failures: generic/629
>>> Failed 1 of 1 tests
>>>
>>>
>>>
>>>
>>> The kernel config and materials to reproduce are available at:
>>> https://download.01.org/0day-ci/archive/20260112/202601121022.41666ce=
a-lkp@intel.com
>>>
>>>
>>>
>>


