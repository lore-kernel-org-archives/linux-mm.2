Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517ADCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B3A6B0093; Fri, 22 May 2026 04:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844076B0095; Fri, 22 May 2026 04:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731546B0096; Fri, 22 May 2026 04:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619756B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:32:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01E2EC2E24
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:32:02 +0000 (UTC)
X-FDA: 84794388126.20.8B8DA7E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id D61EF20012
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:32:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z80jbL3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SKdp4Ts6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z3ze6DAC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wtw6p+pw;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779438721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tuilf5LwW21gUh1UoZd/CNtYlcutL76vyc+BqjvsY1Q=;
	b=keIcckQ8Iy0zFKRpJ/d7QDU6P20ZX+GquQFmLKAGJM7u34PA7J9ugljyL5Vr5xE0uQ6QKi
	8Y6Ye+zZFXVzhfCjL7JWFMEBzAnkHZqVZFpsfgyExxnOJRiHkKYJ8idsZWYaoPGjt6ByDv
	uPsHpZ0RVweZLLItpruzyB/XuO+dxb0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z80jbL3U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SKdp4Ts6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z3ze6DAC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wtw6p+pw;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779438721; a=rsa-sha256;
	cv=none;
	b=z8BkE9d86nFfspT/xJPY2oa1iZdcAdBZI7ZvuGw45BUp8t2mUzTbkWoCo6byC0lLSdPDjd
	xYwy20y/PpGN4dMixRkka54d9TSnGhlwAQnfM5WnBFIrxsZso6jYUuXn9MFcHAYeYqD7z7
	gBFfEOdwmYcId4ApwF5yqMyXOFte4fo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C999F67A2C;
	Fri, 22 May 2026 08:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779438718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tuilf5LwW21gUh1UoZd/CNtYlcutL76vyc+BqjvsY1Q=;
	b=Z80jbL3Ue/0WTcHBfgVascboUScMgNJjmeFDrViG69txxXK9Ez7uhASmfG60tPHIwPU7eT
	tTMgjemkivJWX1v1AZDFSq9ytb7BQNz9ilAt1S8frA+KRlenPJ4fCdwjVmJenxELEKzkAA
	Iw/ztzybRYgZQzPwHz2kQslSWAhmTIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779438718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tuilf5LwW21gUh1UoZd/CNtYlcutL76vyc+BqjvsY1Q=;
	b=SKdp4Ts6vRhRKkqk60MxCFQdbXhgUVizQJCENHgm3jk55jB0U047mOVEJES9a+iPajS8k1
	T0YMwsj0upKcQLCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779438717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tuilf5LwW21gUh1UoZd/CNtYlcutL76vyc+BqjvsY1Q=;
	b=z3ze6DACR2PVML4l5JBKYPjyZ3Fi42x80sAiUY7JZP5ZByXnmYLSmptSQud2gC3F2TIHK4
	aG+wtDr920BCWehs+Nt6wI8GP5MOFpnw0lgzF7M+rsNA0myVuu/E2B6mavK9o58adocGqx
	XKtm9UJoUVZ5IbtfdiFmKIrDQ4QKGsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779438717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tuilf5LwW21gUh1UoZd/CNtYlcutL76vyc+BqjvsY1Q=;
	b=Wtw6p+pw5tQU+Qhogpl82mczhslVgx+mjPeXTHICdn/DdBTe+Odvn+h4RIg1IryP9RwEwW
	TzixNv/kBLA6x7Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCFEE593A8;
	Fri, 22 May 2026 08:31:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6iZ5K3wUEGreCwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 22 May 2026 08:31:56 +0000
Message-ID: <428aa165-c193-47ff-b3d7-26618595c3be@suse.de>
Date: Fri, 22 May 2026 10:31:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Boris Brezillon <boris.brezillon@collabora.com>,
 Igor Torrente <igor.torrente@collabora.com>
Cc: loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
 <20260520164412.3a73d85a@fedora>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20260520164412.3a73d85a@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D61EF20012
X-Rspam-User: 
X-Stat-Signature: x4n91cahrqzqn65e6wgh6a9d3yw3oohm
X-HE-Tag: 1779438720-928599
X-HE-Meta: U2FsdGVkX1/i63MM9Yn9JvVGWZGC1d2cTHguAKgjZPynybpan/Kfd3iXe96Ncamq3EKK+esNA7pOVFVvu0dF1zlTpNzLmBL/tZKNl47bM1M1WK+/pyPdUNWpdK1EpA12sB+L00v+OErtr5SjMiZNwBYhJZhCgHiAKVtlkMOzMOMS4wMtMJEZaZeiB4q0K765rrHv9RV+Dn2xQcCevAF1LSmst4C1CgknDqsBVZzCG28dQwY3BevcvFmp9T05gLkeqB/KGb/GEJpZZPSM6vop8K1LS+QHwsJEM6FpyJc7qNBJ/pmJ+JvGcRM6wdAQTw4DhaMC+OSbzgkqLgZY4qjSM0ug1ustyxHjROuNb68TZ5LwP5V4XmvPYQvtAyfX1v9/ISPhgIkXy3Z9t1xZRW421IkD0g36cpOjC9DOexItVeNEd8Sm1yp6NFqID8TOuBTv6JIfZ8IPkHSIgQFJk/pnCOi3vTwhb7pUhmanT60/WHhOAAQ5Praw4inpqh8oPToCyjP8/Yy9vkJrmCjWbFU2LOw6ftA4NrUSSEEgi2BhuokRVWjNrwT99MXXeyoEzYW8cYIzT0H0CnCdt/SNx/VFJGxl7NUo/Y7nrISPZPqZPtAAV5MpoblXvrzu1snSPPWcLs73SeOXZXqammwat2a63ReTKHNK3vFKYBiQe5ZOhr1Gc6ZCq9Nkk4p1pKgJsfVjljHFfXW3+WQUrD5Hy9sjhkqeuGraptk009GflD8uT+u0QmJ828CcP4DNy5efCQRducUrWPozz/SFoF3NVpH7lk2O0xV44UUOcU14Fx9BSHMNiA5rYptrVC0LL0sYPKTyIEfhoTtdr0HJEB4Judm189efWtJ8DBxhMn3Tn7rFCpwofCaac1aJLFh0KsQ+iUlZr5efWfmARsXt+odHIj/qZSU0EbJROy3XpjkcedVVwlCg/wO1Gle259TMLQVIaMz3le7xDFbaFQnsL2m5rqw
 4VHgqQiZ
 HK5x2GaMcTU1BO0LKByaBa6d1MPC7gl9KH69dDupT88tC5HAAt7PL+vMEuIGs0S8v246dNJ6BoQnAWteVc8OQUpGOQV0Y5HVSzNuWjCVpeVioa1Mcoks1UxRk6YG77hw82+czA/xnykdiUiBkYPzFzeyXfYv7aOZ7xBYs0TEw9Ht4aScZGtHNsNl1KrArnJQDjPKcWfloE77srFCqQfhRckTX5MeZwO7fpyO3ykUUSXwDRHZy/n8qLi/3cGkkd5MCk6NAvnDVywyEkc1LNK92wfUs8M4NVZEd9Xx4BZLKfWkZ5XMZlZzpPTHAX4OnYuWhrIdAAubSXueopK4vuc591js6kqeUqSJFZMk4igWxItrG+cYA/Sn4V+dQgI79/mM0q1aHXG4JzAx2d/zZJGTDmP7A7px5jzFoT9Y6dN0DQTOkmwDAU9J3iHUe0SV+Xz0WfJ3rgcqgBYrCdPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 20.05.26 um 16:44 schrieb Boris Brezillon:
> On Wed, 20 May 2026 10:11:03 -0300
> Igor Torrente <igor.torrente@collabora.com> wrote:
>
>> On 2/9/26 10:27, Thomas Zimmermann wrote:
>>> Invoke folio_mark_accessed() in mmap page faults to add the folio to
>>> the memory manager's LRU list. Userspace invokes mmap to get the memory
>>> for software rendering. Compositors do the same when creating the final
>>> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
>>> out graphics buffers when under memory pressure.
>>>
>>> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
>>> for writeback should the underlying file be paged out from system memory.
>>> This rarely happens in practice, yet it would corrupt the buffer content.
>>>
>>> This has little effect on a system's hardware-accelerated rendering, which
>>> only mmaps for an initial setup of textures, meshes, shaders, etc.
>>>
>>> v3:
>>> - rewrite for VM_PFNMAP
>>> v2:
>>> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>> Hi Thomas,
>>
>> I have and Radxa ROCK 5B+ with Mali-G610 GPU and I'm developing the VDRM
>> (native context) driver
>> for panthor.ko.
>>
>> Recently I update my kernel from 7.0 to the 7.1-rc3, and qemu started
>> freezing with KVM error below
>> when running any graphical application with Venus or Panthor VDRM. For
>> some reason Virgl is not affected.
>>
>> ```
>> error: kvm run failed Bad address
>> PC=0000ffffb4a86d70 X00=0000ffffb4be5000 X01=0000ffffb2279bb0
>> X02=0000000000000600 X03=0000ffffb4be5000 X04=0000ffffb227a1b0
>> X05=0000ffffb4be5600 X06=0000000000000001 X07=0000aaaaf384fd80
>> X08=dcc58d0daf897753 X09=0000000000000002 X10=0000ffffb4b96758
>> X11=000000002533f84b X12=0000000000001060 X13=0000000000000000
>> X14=0000000000000000 X15=0000000000000010 X16=0000ffffb3880128
>> X17=0000ffffb4a86c80 X18=0000000000000000 X19=0000aaaaf384f8a0
>> X20=0000aaaaf37cec80 X21=0000aaaaf37c7210 X22=0000aaaaf37c9550
>> X23=0000aaaaf37c74e0 X24=0000ffffb3b47fc8 X25=0000ffffb3b47fc8
>> X26=0000ffffb3b43c78 X27=0000aaaaf37e1840 X28=0000aaaaf37cee50
>> X29=0000ffffecbf1a60 X30=0000ffffb364b530  SP=0000ffffecbf1a60
>> PSTATE=0000000020001000 --C- EL0t
>> ```
>>
>> After bisecting I reach to your commit.
>>
>> ```
>> 28e3918179aa75cfd4490b3b0281496ed91d829a  drm/gem-shmem:
>> Track folio accessed/dirty status in mmap
>> ```
>>
>> It still reproducible in the 7.1-rc4 (ab5fce87a778).
>>
>> Appling the following patch (Boris suggestion) fixes the issue for me.
>>
>> ```
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index 545933c7f712..1e036f69c1ce 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -696,7 +696,7 @@ const struct vm_operations_struct
>> drm_gem_shmem_vm_ops = {
>>    #endif
>>           .open = drm_gem_shmem_vm_open,
>>           .close = drm_gem_shmem_vm_close,
>> -       .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>> +//     .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>    };
>>    EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>> ```
>>
>> I'm not familiar with the drm_gem, code so I don't any more insightful
>> information
>> to share.  But hopefully we can find a better fix for this.
> Hm, given how close we are from the end of the release cycle, it might
> be safer to revert those .pfn_mkwrite changes and consider them again
> once all the details have been sorted out (it's the second time around
> we hit issues on this patch, and the lack of reviews from MM devs is
> scaring me bit to be honest).
>
> Thomas, any opinion?

Sure, please go ahead. The mmap change in this series seems rather fragile.

Best regards
Thomas

>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



