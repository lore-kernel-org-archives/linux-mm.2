Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0E9CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A3B6B0088; Sun, 18 Oct 2026 04:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4886B008C; Sun, 18 Oct 2026 04:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7A56B0092; Sun, 18 Oct 2026 04:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 874BC6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:57:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE55A1604C2
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:57:38 +0000 (UTC)
X-FDA: 85335143796.22.42F718B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id C85E4100003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:57:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=ItiloNFm;
	spf=pass (imf14.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792313857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRpMKu16Q/46x/JCsK9hFw+qY2y44myLhR4+B4ycuBg=;
	b=cyZGENk0vmre4JUmLJFc+fJ8NxdYNgsl2xJ5e8HRejAuPtqkx2+F2PpK+sPeVPjsAx4T/c
	tEzdR6zvS64VBtfWGRdv462elZKNIR0A1tP0wZQbCUq8e6VH0CnnNHwxHZ5RJ7h6WOVa0I
	E18qbMpfus4lOLs5xvO1EOxexDDLmrI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.s=20251104 header.b=ItiloNFm;
	spf=pass (imf14.hostedemail.com: domain of manfred@colorfullife.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=manfred@colorfullife.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792313857;
	b=eAJDA0iXsTuzfZC4F5O+cujbJc82vqOSoUQH1mrtHoCOF1oErRQ8dIE5alKKRGPrPPo05i
	P9gUTCBBkH06fNdWHxbjOBaWMQhbpVPPJtcQck4KR3CpwjSXFwgLYxZYg9R/Jmdcs6eik1
	Giy+XPyihwlWd1wmCtdHgdXHOZrEZko=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso9576995e9.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20251104.gappssmtp.com; s=20251104; t=1792313855; x=1792918655; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pRpMKu16Q/46x/JCsK9hFw+qY2y44myLhR4+B4ycuBg=;
        b=ItiloNFm82JArPJfTp6KT8PHG5Ple4ngz01e7YiPtnyfLWQ4kxcIc58P0x1z8eAWlk
         MI3ozGfQQfUPX6i57DzTtaLjp7+Eh52kPyH014sWOPsLAVk0gdzLkpl0jxrWSpcxTCeD
         7JeyTYSc3+hdkGbefKq1c3A8Vhw7DmABBqtnE9lQCFQguWWltuA262cz8gxuyakxaSMi
         nd4LMaxQaVQ7AFo8+ZnvTodGiQto4WITHJgphFa5MdOJvDOQZ2AQ5eGo7KwsQOCk4xut
         UOjvOdJPfwY6nuvhcLLH0tZirwvgiWSu8x0P+R8wXsR4zRQbwDquF9cXsuxDRGzzIG3L
         aGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792313855; x=1792918655;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pRpMKu16Q/46x/JCsK9hFw+qY2y44myLhR4+B4ycuBg=;
        b=HNSUI5XtBJg5qc40hp7z41oCaxrvIpVgjhgl7uv5vB5a4e691tFm5UErvqTzT11mJ8
         1ObZBR51Gh+4hljQoP8GXI4LS1IJaq8bpwi5Iv7SozCUoEsxRJO5JsqMxBCIQCxU07m8
         GQY07vyeEcCYXbCIIxYar7my9ejszEUh3Ug9b8RiFlZUTZBAVIiHFDS0cJozipdQwgoH
         o64ctQm2mrjW8dPUMiQqqj9J/8zYkpBIM+qysobnWpTeYpuTaHE7l4spdDmX994SsWIo
         bmXmfXi5vyi+5vuzjjinqaKxWhn7AnxXcAsH+C55n/D3dqR+Maq+nF10gIq5H72/TwQz
         l0gg==
X-Forwarded-Encrypted: i=1; AKwUvBwdz9VH9Xg6XUycv4w7+Tc0qgc0JiXuzUhUceJr2Q7MslQCY2/psvrU87mP9rU9mK9D3/MQ0KdESQ==@kvack.org
X-Gm-Message-State: AFq9FYL1ilVX2C83lmUErGzhh8ymdEFQ3Px5Lb+UngkOyz5lOx6/64jA
	avQF54daJdGjaCzbcb0Szxfw1RpUbQYIHOWbhjgacBbfnrd2qfCZP0EfOF86fhSQWw==
X-Gm-Gg: AYBFou20ou0LbNaFE7G92XmnPZv+DMWNdUyTXhhJ+RmTRGiTsw1T6YBWOnvlAZbQT4s
	wZeapdzIRnXCtxpASZRxcpaRAj7RIWCOweq01uCpHA0TGy5nQWPg/Lp/xcBzi/b1qUCXbvvfzBa
	ji9xpQEtAKO1j7a4FazGV+Hwe/LWokyjDbkIjDWll4RvjjPpDh/LM5d+4lBGM9zr2XQnoK9/gWv
	SJDbDhTpXkAMHlWZVK/OPUyCP18l99fq8+9yiLCUMGpUGZZ30c6A24wxjm4lefKDG0uCmVJerFK
	heHROVvAIyBEOKVCBuHO8o76Nx/hIk2uJFQwXJurae6cXQt8K103m/U9gCAvc6/bdyMlhRTyXZn
	zGiY+BHa9jsN0C1QmYtO9sDipd65utRUUHZdx7/Dl1+arYxrQep6W0eJOMX35UGEgekDtq2mOw/
	OrrlSV4365IFdQ0G3shb6PuflqdH5c6uPLrtci7FrBxzVzUYxLl63r65MOW2d/1tjKy/RbX/0X1
	OHTuZ+GMTlKyNONH8+GVDacWQsWxytnfTZUryvriz9fdHTHoLZ55MQUw0TFqQYoa93v/RxJ9kz4
	dMcQ4vMAdtpeOEavy2h9+LEkhooSSa7nJKz60A==
X-Received: by 2002:a05:600c:8219:b0:4a1:85d9:13be with SMTP id 5b1f17b1804b1-4a1d76031bfmr97737755e9.20.1792313855253;
        Sun, 18 Oct 2026 01:57:35 -0700 (PDT)
Received: from ?IPV6:2003:d9:9733:4d00:46a9:a5ac:4915:e68f? (p200300d997334d0046a9a5ac4915e68f.dip0.t-ipconnect.de. [2003:d9:9733:4d00:46a9:a5ac:4915:e68f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9a88bbsm282747915e9.3.2026.10.18.01.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 01:57:34 -0700 (PDT)
Message-ID: <51c93c19-f1dd-455f-8698-6b1ee30eb630@colorfullife.com>
Date: Sun, 18 Oct 2026 12:46:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ipc/sem: account enlarged sops arrays to memcg
To: Andrew Morton <akpm@linux-foundation.org>,
 Wang Yingjie <x-professor@outlook.com>
Cc: Alexey Gladkov <legion@kernel.org>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Vasily Averin <vasily.averin@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
References: <20261016152609.2528805-1-x-professor@outlook.com>
 <20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org>
Content-Language: en-US
From: Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ttwgbt9rc67u9yaipxzz3cnn3tg3yu8s
X-Rspamd-Queue-Id: C85E4100003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792313856-227948
X-HE-Meta: U2FsdGVkX1+p62SHWFTgigHt8Df4mXcCznn52IpTdV8BeR7hIDD5lPMDUd0LYtZpwwCTv/RMTThwseYBsyTYSYyMNMA0RaM+iiBTUawb4Or+8dCba0SgFnc2s/A6S06r6GTC3yZejWf4S3zYoySpFR3quHLHaHz7HDyThE2JBEpkyixlh00cHgpd6Mo3+NDCGeDweD4ge3RoSKpdn4vXgSEwBGOjNHmnx6QHbRgL+WSRcpe81zlxJnFFTjt9MJOn3TgfzRoIMajzx3vdlRGkT+h86BHxvUaMW0vlBlgPGZ+sjkXbdk62DGT3Acc1F827gy+cVhL3XcVUwrT5sOKiowP72LYevNpiO33p7owdmD49qN+j1C47CGmYTKfzx573RO8TzbA8sumZPYwDT0o3Esa2FiGQuoT/mUSvflGUeLRFzSa1P+wBeeVF1sNU6i2eb1q0LmpbUkN97SEM+EWDhK6uP20x4U9Hqlto7mec7sOw3YQHOPUxrfHS02roeqMJwUc2ApIba5NeUrgg3Mo84S3KBO3N6V/EDMwRN2QF+jcVJIEIJOhCh9VPsfTSXMTugfcu8jbEGhTM/NcITkdiLgvWNfReT1zqvYxCQBQxYnUJTQ2NQ0UyCfycAsjtujyqL2x7RpFUA7M3NWJ0QB7mTcxnhEOtgmJ/x5iQjYw/bhNFbzIj/lPj0giIPkZ/eAKwbSIT5aBII4wstowWZeauIyPL4qt8GTWFkGI2OoTOC8K8WaO4kj4nPjE9YDajA+P1+KScUu0yJUHheSySwP4T8vm4YE+Lmci1Jjf94bwvCsGhDMKaVDqX0AA2C9+SCMKadrhh2R2uNo0jRjcUQHMVKO6AHQF05yUDtn5Z91tEd5XwfQaXrSs7XxITajEye/IsAMCD5Cq11fW7meHBDrxIPGPKAxBGkr6wzctN9Ow7MbZP/8PVM+UTTFPuDINGuzIOMvK2PJJcXtIRhGP5/AG
 Yepj9LFz
 97C33VwHu7P1ItApxX648J7LPbATN1MOUHlXyKSYXberrH+i4C9Eqv27oSdmXnJ3BtZAAjLeefUYg9SlpQZ3r11GVElglmcpK6zG7Gl+Jj51Ohcttihx5hoHAJRav2OOvPtmbj8bAOH3fkdjiT0fyEauS3ePzltvCaLoYUpa+quvu87hjU4hBKHZzJyjZsjcJGUczAHFKFbJ+k8GLWh4kGhutcJePARxyBHskYF9klP1oNOKr5Q2AUK8WyEI5ZJ7taoG7yAsmTJJ7tDYRm1DhUD+PoIMO8/x7QAsqlG/hrQKN3Fa26yAMa3YSErIzC02rPLzM0Q5o3m7BLE/ht70DMdz8Kz7kblxO/KVaYssTwrXDIUla1AqNlh2SyB6I9YPBPzN6qSQno6y6UEogxGl9DcNLcjdV0Dbc6y2f8FJAXoJ3rgzTBxB2JRIonqkSvlAbpQgMSXal1DxYn6bYPQwI/9W536Qn84sovnHEIMODx4/vCDigVUVBJuR0OgHC5ZZaRfrb24c9yAHEvSmNHhKRkVDs4qldIWT42MkRRZYPv1FyQZ+tf51IKJd0BqorlK96D8+kKEDUotLEEfMD2Z9OMno0xPYB0qpxuV+ORYi2Tc+lncjvouO3iOuVKRTdiqT0NNFeP0IxSX854nL0dzh53vmoApMDbDqAPAHCuLtCL9K/1Nfi8fTQMQBavN2huWlsGL8d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 10/17/26 12:59 AM, Andrew Morton wrote:
> (Alexey, Eric, others: please weigh in)
>
> On Fri, 16 Oct 2026 15:26:11 +0000 Wang Yingjie <x-professor@outlook.com> wrote:
>
>> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls
>> inside ipc namespace") lets an IPC namespace owner change kernel.sem.
>> The SEMOPM field defaults to 500 but has no semantic range check.
>>
>> do_semtimedop() allocates nsops * sizeof(struct sembuf) with
>> GFP_KERNEL. A blocking operation retains that buffer, so a user can
>> raise SEMOPM and hold large attacker-selected amounts of host kernel
>> memory without charging the calling task memcg.
>>
>> On the current mainline base, one 10,000,000-operation call retained
>> 60,936,448 bytes while a 32 MiB cgroup peaked at 909,312 bytes and
>> reported no limit event. Sixteen 1,000,000-operation calls retained
>> 100,860,416 bytes while the cgroup peaked at 1,310,720 bytes.

Just for understanding:

Each sleeping thread (within do_semtimedop()) can use 60 MB, assuming it 
triggers a 10 mio semop() call.

It could be a bogus 5 mio times "increase by 1, decrease by 1" semop(), 
or a valid semop() on a suitably large array.

>> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
>> do_semtimedop()") removed accounting on the premise that the buffer was
>> at most two pages. Preserve that default-sized path, but account arrays
>> larger than the default SEMOPM value.
> OK, I think. But...
>
>> With this change, both test configurations reach the 32 MiB cgroup
>> limit and the caller is terminated by the memcg OOM killer before it
>> can retain the enlarged arrays.
> Only if memcg is enabled and the task's memory cgroup has an effective
> limit.  Otherwise we can end up handing out idiotic amounts of kernel
> memory.  Memcg accounting isn't a substitute for limiting the
> allocation size.

The previous assumption was the other way around:

ipc is full of legacy users.

Thus any hard limit risks to break existing setups.

If I remember it right, either SHM or MSG had code that tried to split 
the permitted allocation, i.e. if someone creates a new namespace, then 
each name space inherits half of the limit.

This was removed, since memcg would be the better substitute.

Old discussion: https://marc.info/?l=linux-mm&m=139639755705736&w=2

But I can't find right now the code that tried to split the limits.

>> The sysctl also accepts negative SEMOPM values. Since nsops is unsigned,
>> SEMOPM=-1 bypasses the intended operation-count check.
> Let's fix this first. nsops is unsigned int, whereas ns->sc_semopm is
> int. In the comparison nsops > ns->sc_semopm, a negative SEMOPM is
> converted to unsigned, so SEMOPM=-1 effectively sets the limit to
> UINT_MAX.
>
> I'm thinking:
>
> - Permit init_ipc_ns.sc_semopm to be set to any value from 1 to INT_MAX.
>    This preserves the existing ability of host root to configure larger
>    limits.
> - For all other IPC namespaces, permit values from 1 to 1000. The
>    documentation has long recommended 1000 as an upper limit, although
>    it hasn't been enforced. This would be a new restriction, so the
>    changelog should explain why we're introducing it.

This would mean workloads with higher SEMOPM values cannot run in 
containers, correct?

According to commit e4243b8062c1 "ipc/sem: play nicer with large nsops 
allocations", values up to 1000 are recommended.

And 
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-An_Example_of_Semaphore_Settings.html 
recommends to set it to SEMMSL, i.e. 5000 in the given example.

> - Validate the new values before installing any of them.  The current
>    proc_ipc_sem_dointvec() updates the live array directly, and
>    rejecting an invalid value afterward would leave a window in which
>    other tasks could observe it.
>
> - Update the comment in include/uapi/linux/sem.h. The warning about
>    physical memory fragmentation is outdated now that the allocation
>    uses kvmalloc(). Document the new 1000 limit for non-initial IPC
>    namespaces instead.
>
> Ideally, a new IPC namespace would inherit its parent's configured
> limit, but currently every new namespace starts at SEMOPM=500. I don't
> think we need to change that as part of this fix.
>
> Then please redo your memcg-accounting patch as a separate followup,
> with suitably adjusted changelogging. That would provide additional
> protection for legitimately enlarged allocations in the initial IPC
> namespace and for allocations between 501 and 1000 operations elsewhere.
>
> Thanks.



