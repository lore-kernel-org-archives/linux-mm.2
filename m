Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FB8D1039D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5CF6B0028; Wed, 26 Nov 2025 05:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D4D6B0062; Wed, 26 Nov 2025 05:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBCC6B007B; Wed, 26 Nov 2025 05:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27B486B0028
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:27:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5A14B9998
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:27:30 +0000 (UTC)
X-FDA: 84152381460.13.207D37C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3FF5B1C0009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:27:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hsxVht4tUlNSpx96uvLTVdGsr7Bsu+NkiRatDCwiX2c=;
	b=CkLawOQUCLO7IIP+iduoWyO/fYuP9SWIAfDpKT2DzXt0CeIlOWD2XeDMU0rOT9d/iBjH8Y
	adVCB/bSsBQwJwE+58SqhfNjdJvDS5ver+FwVa91+sCt3DIZnbaRIa5TrKnS2oTMc7F/z9
	g38BK/RfxqpMW8N4FPoOaH2Br8DUYCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152849; a=rsa-sha256;
	cv=none;
	b=ryJzSz6Dw7cBHYKFnoG8KCa/42WWX+To8zNsJ1Ta2oDygorCOtaBQGTf/dRWGPHZfyBeLO
	ZEsXtVp7U+kHUw7T5p/T1eRG9JzxCcKGVwSAynKSZgZdUBA9Bhqt7wjxIeCVwRdUxWzRsN
	yWb6czbPzBRXOosXHRx3G8Xh1psY/bs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dGbMP5mD0zKHMgr
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:26:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 696011A0D59
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:27:20 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP1 (Coremail) with SMTP id cCh0CgC3PkgH1iZpi0Q3CA--.23367S3;
	Wed, 26 Nov 2025 18:27:20 +0800 (CST)
Message-ID: <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
Date: Wed, 26 Nov 2025 18:27:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Zizhi Wo <wozizhi@huaweicloud.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Zizhi Wo <wozizhi@huaweicloud.com>, jack@suse.com, brauner@kernel.org,
 hch@lst.de, akpm@linux-foundation.org, linux@armlinux.org.uk,
 torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 yangerkun@huawei.com, wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
 xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
In-Reply-To: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3PkgH1iZpi0Q3CA--.23367S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArWDWFyxKr45XryxGr43GFg_yoW5XFW5pr
	4rCryYkrsxZry5Aw109a9IgFy5Jw4UGr43GrnagryUuw45WF12vF4UKry09F9xW3WDWayx
	Wr1qgwn7uas0gFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUL0edUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 3FF5B1C0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: o7y5k5tneoy7y5j9t9jdk3kyds989ywo
X-HE-Tag: 1764152844-860420
X-HE-Meta: U2FsdGVkX19vC8ol4Vo5MMj6JB5LBZ5OKuk9Wxpbql0oikKVoTqF06fB0b9pFq6T2h8Diil2alHu8izPA5IT4qgLfR01CNNQgou261qkW/OSn3XdC73hnNI9lU1cKfMNKKioBZEHfPRGjNRvQnvREyOAucxSVCPNfdG7AvlzTsKFv9/dreDk5/jazxB7AfEAGcGPFC59rRHsf+68v4W/vpCimtYY9sLNp5sr0rE0KgQX4tUS8zGBalYu93aan7W10SC4HQ347AVOqMuj0aXX5woogBbsdb86UUJL6dnu0L2YjYJyfHqo2++grTGVylVnQctj+ZxD9c0D+huibAANcsTtVdbVKRP10ESMZSjSaKCY095B91yNCENaDyTWA4+l3P3tPBkdv+Gy6EniCHCXv0oLZgDcmaAilpPyrGFbNzVv5zVE7zOx0Tu62aao7p5USyoxdlK+dFbX32kZvMjUKiplUvQ8AQmULFNCC6YMYLrFXEYPakucpg6QfMLUenE74JbshCINMHRzhKig0Fc/F0k9qzAP5Jiou6hGKjlG8wd9lGDR19WU60ZxgNo6DHfDbd1RePIJv8Ui46/Swp+tj8Ba0/Qa9qCV4iw+IC4egKLQdEpIJqIAYlc+4F7hoYAcDY7UTHKujK0tWBcok1zrOj6OMG9Tpw2S6Hnm5G4/MR+KRLEF89tS2BccGaxQTJA2+8GrwiZZLEt3VUzOpCXM67titlAkdEp0l1BkHV574qlxkkBHf2WD1xDbaUWLP11Mdyqj7tdiTlPWcDHtsHGixlCbaZEoCfr+DeB/noQh8ReSur/5BREDi46yLbWEYgvFX/2m6/X/gePeAqm8gl6uISObdV2jg+xIMigunCYK3/A6dhBd2ENp4axY/a4s3GPl/EPfpQh7NuFAd6Gn7YMGsjakgohF6D5wFDFxz5b6MDPTW55zMf/9wJlXxKinWBtBkOwAtvs0TtVZ+N8eHut
 mthiwJS/
 YhWrU4GpQOuVi5+1Gj5taGtYigbZmCHjISa2i+YA7PD81wq2N8b4dLx3s+dOsnyKFTTlmEVXbYLVoI5BsKDlFsJxfdrabSwW67fAhS+msNulLGCOKpk2LNjt6ekXy+BeCPWcttWQgxefgTYugxRvuFE5ivvhrnpsq2aGhEcoOsUvEFE+f5C33YcE57J4BRi/ptb1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/26 17:05, Zizhi Wo 写道:
> We're running into the following issue on an ARM32 platform with the linux
> 5.10 kernel:
> 
> [<c0300b78>] (__dabt_svc) from [<c0529cb8>] (link_path_walk.part.7+0x108/0x45c)
> [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>] (path_openat+0xc4/0x10ec)
> [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
> [<c052cf90>] (do_filp_open) from [<c0511e4c>] (do_sys_openat2+0x418/0x528)
> [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
> [<c0513d98>] (do_sys_open) from [<c03000c0>] (ret_fast_syscall+0x0/0x58)
> ...
> [<c0315e34>] (unwind_backtrace) from [<c030f2b0>] (show_stack+0x20/0x24)
> [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
> [<c14239f4>] (dump_stack) from [<c038d188>] (___might_sleep+0x19c/0x1e4)
> [<c038d188>] (___might_sleep) from [<c031b6fc>] (do_page_fault+0x2f8/0x51c)
> [<c031b6fc>] (do_page_fault) from [<c031bb44>] (do_DataAbort+0x90/0x118)
> [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
> ...
> 
> During the execution of hash_name()->load_unaligned_zeropad(), a potential
> memory access beyond the PAGE boundary may occur. For example, when the
> filename length is near the PAGE_SIZE boundary. This triggers a page fault,
> which leads to a call to do_page_fault()->mmap_read_trylock(). If we can't
> acquire the lock, we have to fall back to the mmap_read_lock() path, which
> calls might_sleep(). This breaks RCU semantics because path lookup occurs
> under an RCU read-side critical section. In linux-mainline, arm/arm64
> do_page_fault() still has this problem:
> 
> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
> 
> And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
> dcache name comparison and hashing"), hash_name accessed the name byte by
> byte.
> 
> To prevent load_unaligned_zeropad() from accessing beyond the valid memory
> region, we would need to intercept such cases beforehand? But doing so
> would require replicating the internal logic of load_unaligned_zeropad(),
> including handling endianness and constructing the correct value manually.
> Given that load_unaligned_zeropad() is used in many places across the
> kernel, we currently haven't found a good solution to address this cleanly.
> 
> What would be the recommended way to handle this situation? Would
> appreciate any feedback and guidance from the community. Thanks!
> 

As a detail, we enabled CONFIG_DEBUG_PREEMPT and CONFIG_KFENCE, which
allowed us to catch the potential out-of-bounds access.

Thanks,
Zizhi Wo


