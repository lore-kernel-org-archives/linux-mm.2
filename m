Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A562BD25051
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E396B008A; Mon, 12 Jan 2026 03:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BCD6B008C; Mon, 12 Jan 2026 03:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1ABF6B0092; Mon, 12 Jan 2026 03:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF8D06B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:34:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E8EC1AD43A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:34:27 +0000 (UTC)
X-FDA: 84322650174.16.B1F1361
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC6A52000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:34:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jeESO6WA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cta12H05;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="o9X/K+4h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="e23VvG/9";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768206864; a=rsa-sha256;
	cv=none;
	b=HLOCgWjXBBKjkCL80aUIIa4csbNM3azNW8bMSeW7Z+thLWTn15rWeKkuPXKyVNgufOVWMu
	GGkE/01ZHGcEUqtsVrVfs9Dros7UVnp78CbvX751f7qmiC3+97AMTkEy8qQY7JA3RzxPfw
	im7c1+MqXpC26hO7w3gerdHYpazWu0c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jeESO6WA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cta12H05;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="o9X/K+4h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="e23VvG/9";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768206864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwD4kApjFPZsXwhiMrMbTKQ84/M6yc6WaUVtiHu4Pmc=;
	b=dKwDuSzfGu6Fbuwjq4rh71w2KAh9BaAGCvc2REMtbcWhhYVBij5hHrwkP2K9kyDmJXXR7x
	jYupmiD7Wv2jbn0Je+eyHfkVSB4QM42Hw2IJUmvUoGSgnuqUjnad+rm5Ie3zzaMrbYEm01
	qIVbj+AhW00G15UGJCt9iN2Q35Hyg7A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BB555BD5A;
	Mon, 12 Jan 2026 08:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768206862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OwD4kApjFPZsXwhiMrMbTKQ84/M6yc6WaUVtiHu4Pmc=;
	b=jeESO6WADv9AgSVoHcn6NAB7ObtrcAKb4tPO7avnvaj94x60Zp9nhVg9zHzYXEhF8t23GD
	Nh4w4VMiQGWBGvL37cfbvOwCH9X3FG5HLwLKBtCYQIyyZRVGVavoaS98s8bFv121foYmxS
	3MCjKPEKdDXvsdw23araazugZr7Es5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768206862;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OwD4kApjFPZsXwhiMrMbTKQ84/M6yc6WaUVtiHu4Pmc=;
	b=cta12H05c5tqmPmhFF6z/nGqjln4lfmp2uZkQ2wZx5j3RcdvQtHVK/eAmQ234LV8t0p6RY
	HgcfFhavB36cxgCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768206860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OwD4kApjFPZsXwhiMrMbTKQ84/M6yc6WaUVtiHu4Pmc=;
	b=o9X/K+4hg12a6N7Y4kXs7qpGVHcX8XxNnSz99lhiDK2wXTUqCsI8KLn1i5rnl/Sd/R8OQQ
	BrGKxRmb0qexMZGb0mZ92kxjcm4SCYqDjXVQ1AUnXhB2L4fIJ7hThoAQK2wNNte1QaUmNx
	SpuNPT4J+uQay72D/vTbswxKjDQflEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768206860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OwD4kApjFPZsXwhiMrMbTKQ84/M6yc6WaUVtiHu4Pmc=;
	b=e23VvG/9+lixfeBZyT6ecLDPoYmSBMLD/62W/v6JBWvQ7nO2+zsJHm2bDCsYX5JmgzxACo
	CzygbK1AguftL6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 805303EA63;
	Mon, 12 Jan 2026 08:34:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uCIGHwyyZGlRBgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 08:34:20 +0000
Message-ID: <d7263d12-e6e5-48d9-85b5-0937f7c0dac9@suse.cz>
Date: Mon, 12 Jan 2026 09:34:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] 9b0317d1c2:
 xfstests.generic.629.fail
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org
References: <202601121022.41666cea-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202601121022.41666cea-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC6A52000B
X-Stat-Signature: a3ji1rtdmgqutbsbfzf4obc6cx4bjwjb
X-Rspam-User: 
X-HE-Tag: 1768206863-231103
X-HE-Meta: U2FsdGVkX19Qst28gDBrH4FqsR4jxiPxvuDVGK6piENnds6Zm7Mtm/YBFzU5ZH4teD94HFhnRXFeKLqMXqhtdWMQrGJqWs3yJIydFRrvYiSzL7UycdiPgt412tqU4vtyOGM4D0rknC3fPDHS/PQW8uiJDNK1Lo3sepEXGLi1Z8r11v8YCIw4KjaN1OdhCl+HxuZvtMVH6RDtNuGPmccI+K8lJs3bVtf9XqxOW7jzIArre5qEwnFTZMg7jw6LrnhQSa3IEL7InNxpeQPWsxdtxn8jpuCmS0Y7H17oIEJPMOFv42ycYVq0RDV8NpO/XadFHJBY7ceoE18fj3UP+sAg2iFuuQRvWjuzN7i71z4MfUZkXhsjMGzyTDLlfRZNBDF7fcTnNCRqtDrfeXQDmZ3YJuUHP8NpvX4kO7W2VC+3B9fVc55J+CdNk/TLNkV+noQeql4XikCuc2at76nrxZAVZAJc/RbDjFcV1BMy9WqKnf8wquVFVgOAZlBiZYZmPYXd/OtnQtU9ARVFszpjtUidnHisgFFkVFROGBxC6YdNd9QV2AqzVa7UEDfjDrdqkOmovve51o5uYHOxOD57e5SGMtbbcjsDmTsmtl8R3oBPRZ5MNy2eubERBzl++2cd+UVLypBiuLg2lQjlV/V/97XaGJKRwBZ29jsaxPqlJYdV57tyDOJce8jvWm1ljWHFjW5FpSNHhBmQrPcEfV90j7rI0fH8jxvK7MPdP19unqy07C4lqgkhn/G7jmXT+8hAlLjN2vx/a2kwLOyRzMC6zgTJ3yjO+V75IL1LFjPEILLBi9enAwpcjQWxez9zwMXfDYC3hjG0QsMF+sNx9jZ/dWnJClGPRCqS+eSeJmOzyMG/TB7NRlhLZ3FQLVJuIYyT50lTrDDb7KoZxOEcMhD63RUWVHRtiEY/kExHDPP/AlZ8eoGu3Thy7pHJfFQhZzQX/ZX8AvUmOSDUW/ewjXjDUKZ
 3vmyP4o7
 8MufeYDgrpMzkDWDLwPDppFBLjpWZhWro2X8uRL+cUaZFO0X1lphMxhdGbYxmXhFRr9GHTDB3DgZuvRnLALglNDIy1XhCIaouQIhBMSybmqqv0QkMWZgxNm/nD7z7NnW2hbma3f/UTb+l7aERD2U9tIfIZtOsnncJH7rL1p0uH4r+k+Acus/VLSldt0rdd6vyDweZTcrdhqYj13df7W04uvZ062piHPdBbWEEGRSsqnibfvj8KE7GlpXo4DEkHDb33pGGwtodwVmxZDar8JOcm5BLVhsF5+RgASy4dEveWh4XAdGW5UqYKRhaPJaVNt9dwltZbQGhOUNOS+9FM4s7bYODL+IJUUnBCalIP2LJJeEddgf4rKfcQ6Bww60HSVLwlJuZAr5EzzDVkCM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 03:54, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "xfstests.generic.629.fail" on:
> 
> commit: 9b0317d1c2ed590d69d39eba701cd3eb082ecc31 ("slab: remove cpu (partial) slabs usage from allocation paths")
> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased
> 
> in testcase: xfstests
> version: xfstests-x86_64-df16c93a-1_20260105
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: btrfs
> 	test: generic-629
> 
> 
> 
> config: x86_64-rhel-9.4-func
> compiler: gcc-14
> test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202601121022.41666cea-lkp@intel.com
> 
> 2026-01-11 11:59:36 cd /lkp/benchmarks/xfstests
> 2026-01-11 11:59:37 export TEST_DIR=/fs/sdb1
> 2026-01-11 11:59:37 export TEST_DEV=/dev/sdb1
> 2026-01-11 11:59:37 export FSTYP=btrfs
> 2026-01-11 11:59:37 export SCRATCH_MNT=/fs/scratch
> 2026-01-11 11:59:37 mkdir /fs/scratch -p
> 2026-01-11 11:59:37 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4"
> 2026-01-11 11:59:37 echo generic/629
> 2026-01-11 11:59:37 ./check generic/629
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 lkp-skl-d03 6.19.0-rc1-00010-g9b0317d1c2ed #1 SMP PREEMPT_DYNAMIC Sun Jan 11 19:50:05 CST 2026
> MKFS_OPTIONS  -- /dev/sdb2
> MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch
> 
> generic/629        _check_dmesg: something found in dmesg (see /lkp/benchmarks/xfstests/results//generic/629.dmesg)

Hm I didn't notice anything suspicious in dmesg.xz - any idea what this
refers to?

> Ran: generic/629
> Failures: generic/629
> Failed 1 of 1 tests
> 
> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260112/202601121022.41666cea-lkp@intel.com
> 
> 
> 


