Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6403D116E7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238526B000A; Wed, 26 Nov 2025 21:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FC86B0012; Wed, 26 Nov 2025 21:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CD66B0022; Wed, 26 Nov 2025 21:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 048E26B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:24:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93845131ABF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:24:32 +0000 (UTC)
X-FDA: 84154793184.23.8ED0597
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3858D40013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:24:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764210270; a=rsa-sha256;
	cv=none;
	b=1X2FdfXytYdEnnrsNit2Bee+Zsb3xSUPzGQStwhyuHh4B474qS5BPehG2oJNBsC7iUXkG2
	VT2s6BNAdoqNghatlyLAiXlxYvIUCISGmZv48hMYeoUVkou1oevU/GP495dgn0Oh93WXrx
	IwByu99qvLuT3PpGlOKNAaFCDhDjaSM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764210270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1O9IKzc4c6/mbu1blfNI5sH3F7thx+yy8ntXJTr2Dw4=;
	b=OCdCdlD28k5+ghDb8OESlkHBvwYq6Yy/Tyrh8Cu7AhXS1y3BpVTiUNnr/A+nujtZ06ZwZd
	jDG9LMeYVNMfAUgVsKZjbJMxQ0KsQwUp8tE6QrtfB9cTf4I8zKiSRX3fQum1/sJpHXlMpj
	VI63hm5ivm2FF9P0CmO7XDXQ988d/tE=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dH0bP3GnmzYQtjn
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:23:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 52EB91A14ED
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:24:22 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgAXdHpTtidpTkSaCA--.14138S3;
	Thu, 27 Nov 2025 10:24:22 +0800 (CST)
Message-ID: <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
Date: Thu, 27 Nov 2025 10:24:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Al Viro <viro@zeniv.linux.org.uk>, Zizhi Wo <wozizhi@huaweicloud.com>,
 torvalds@linux-foundation.org
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <20251126185545.GC3538@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAXdHpTtidpTkSaCA--.14138S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary7Kr18ur18uF48tr4xZwb_yoW8Wr1Dpr
	yxG3W5CF45Xw15twn7Aa92kryftan5KrWUGryfWwnYkw4YkFy09w4ftF4DW34agwn7Cr4k
	JF4j9w4qvrZYga7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUOv38UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3858D40013
X-Stat-Signature: txp1c3xfx5dr6cmejsn5mp66x8rnsfo6
X-Rspam-User: 
X-HE-Tag: 1764210266-895631
X-HE-Meta: U2FsdGVkX18FsoZjARt14KsU/xUFcXZk0imcd0gC/x3DVUk2fSmT5NvTfDe3VNRUq7pvJIGxPkbU24Y6eV7UFMJwSKiT7YxZw1l0XH5aUuftivFIeECvI//it8iMEmlbGEs3AeVwZCVbfXmvgCfch6DRXaMTV1kkWEuj/xZD5wgQzAHRG5nmOltfWBnESR03cNwCcpsPwV49py4ce9Xfy2OmrL40WcUsRHvlP2rsw7cCSU2/HVrGKlKP2d4Kq64KMZP+1zYUxEf9vm5X1iwTHSvYAcbijm2fXhca7rj1rfbECjnKKUnFj2QCg+YisqmB57N01uSNn4PBaV0ySfbYaLP/PNy33TEKFYUldGH/OcB5e8WkpCzKkbus3Wnk+gEu4YG5JEV1cN6fg8L0/Qu9cRGiX04kVwQORgB9feKB+Ugqjfp5TwOUGwzk+SsKfuWveSErR61Qc1zD8490B7oaVG0jWMhlh7AgU6Le6opbkRnCCaFtFdFvChKX2NKdi2sIHwvUrav4bY9fl0+xZpA1xZnzUp8K1kBssn3JxXRnk+EAhrwZzxKpe241ibRfUZOgG0nZ4wz5ivIyJ0byrgRdfVJHSabn4Ndbvp6ZsYuv+D64JmnLA1kpD3UsdpQ/QVXGboaa2g7uYascoOt/REYhBTg3/c+GJZJLC4gLzk+bY8Oc74qBWTR+s0iDDiefIWK4mRTSgFivsR/lr1+Qe+gLN10iQTz9DhzawOdqp9mwj7i30S3D5jedNH//B2w1/ZebV5TNI/xHbi+yUaimEIKWXDfdPKLVqYvyCSh5gwN1woSXfyoH7d3qHZ9zptorl66y2ucDoafherd85XGUsrt9T6ZOdQHXLH5Kyyza870tnDgF5D0YrKkFcucplHpT5HqtmMgfVCdHRncNXTdJAzJjZqQg9chFdiZnvMnkepaWWkNXdqIf6KBzmzFci7j3PYrlwV4wBHS/eQQ17MGC+YS
 EF9AARye
 i2DyZUX6J+KbMC8P1moy6Y9PttXVCPVt84ctMaudr9WNI8kySylpht8/xsWeNHTOIwYMcDEqdr1utxtkOzhk2Dh/wj0lrz2pQN72w0CZNE1I+8ciMr6YO/uzVV3z20KiTLJBYz6dBXM/gOm0hls5Xid9jAuu4gBpIBGgWbdltiaM9gMhX5O/BepSbWvm+R+zbilXx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/27 2:55, Al Viro 写道:
> On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
> 
>> under an RCU read-side critical section. In linux-mainline, arm/arm64
>> do_page_fault() still has this problem:
>>
>> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
> 
> 	arm64 shouldn't hit do_page_fault() in the first place, and
> do_translation_fault() there will see that address is beyond TASK_SIZE
> and go straight to do_bad_area() -> __do_kernel_fault() -> fixup_exception(),
> with no messing with mmap_lock.
> 
> 	Can anybody confirm that problem exists on arm64 (ideally - with
> reproducer)?
> 


Thank you all for the replies.

We did reproduce the issue on arm, and I mistakenly assumed the same
problem existed on arm64 after looking at the do_page_fault() code.
However, I just confirmed using the test program that, as everyone
pointed out, it goes through do_translation_fault() and reaches
do_bad_area() -> __do_kernel_fault(). So indeed, the issue does not
exist on arm64 — that was my oversight...

That said, I’d like to ask a follow-up question:

Why does x86 have special handling in do_kern_addr_fault(), including
logic for vmalloc faults? For example, on CONFIG_X86_32, it still takes
the vmalloc_fault path. As noted in the x86 comments, "We can fault-in 
kernel-space virtual memory on-demand"...

But on arm64, I don’t see similar logic — is there a specific reason
for this difference? Maybe x86's vmalloc area is mapped lazily, while
ARM maps it fully during early boot?

Thanks,
Zizhi Wo


