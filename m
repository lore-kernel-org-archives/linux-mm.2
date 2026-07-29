Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250E3C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 18:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46286B0088; Wed, 29 Jul 2026 14:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7916B008A; Wed, 29 Jul 2026 14:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0AD6B008C; Wed, 29 Jul 2026 14:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82CEB6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:51:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6460B1A07B4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:51:16 +0000 (UTC)
X-FDA: 85042706952.03.18B82A1
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 28F691A000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:51:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=keoBenwZ;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785351074;
	b=anIbzBuvUJNYjeQmoNCMDUbZ0WXl1E2y5BhYm/6xq1+9cD3OqwLCwYBcfCRXVrJ/iwWXG+
	uyXM/Wq9kfRkedmsBRD7SMb2gMNQSkUSxyWiShGsCLWCLvw3AwunYllYtq+OvY6+XnOiYX
	NBMfPKoqrE+sOpCyb/X5IZXXLqG8lfk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=keoBenwZ;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785351074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WT5HxsFSsFe8e43NEMOLV2lbYxngwkQWFWlRMgNk5So=;
	b=VbVbIR5LK/B7bIaDlXbAOF6vaELE0CDv1wlg8GAGZKOArUqNcNZ69PNL15KcURPfH9qwSL
	UcmewABBR7B/4s9T91FSA5YRZ9Vv8/RNo/lEq21jUFSMX+r9gdwuJz4CEGLLT+4JZADc6t
	/T5wrRQfFg4MPHpk8oqye10ZFMOXWKc=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e85499ffbso112274085a.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785351073; x=1785955873; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WT5HxsFSsFe8e43NEMOLV2lbYxngwkQWFWlRMgNk5So=;
        b=keoBenwZJzH5J7+bdYllmAR7rFVuXdfiAlZKDWI04Cpn8RlrEbXw+Oovl4xHjwuy8D
         Mssk79ValMuI6CHxJ5pkjlLaBx8lC7TPqsPhSPjcrv61na3wOaJAEnfQxLjv0aOIf11p
         yF+B0ubkFxWeCd7lZ/HnekfQh8q1HtETGj00J0fH55OpX+JIic3hncH8wniN4pAKQdD8
         SbzsQp/h9vEz/jUFBOo2pfLTDlDf+8MSQEg0WkbtJenAn562qTL61qsnKehmSUhSMHTi
         gOuevDF+yo1T1Uc/nGEe6j9SPEhUzP0/N5lLja+Nf7EYexePmJbdeekRsnaAgIkt9sU7
         +gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351073; x=1785955873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WT5HxsFSsFe8e43NEMOLV2lbYxngwkQWFWlRMgNk5So=;
        b=ZMcsATYWPQM56oct/56GJNHAiSPgJtqwMbQ4F8gNJc+xt/KSPTYtS61U0Rf8Wp1RLm
         KmJZ4d6JFXqrweSX+zCFDqHTy+wygxHnkNxJ53Qe6LiLOcWeolwZHh3H3/sa4EXrZe5Q
         m2uVjd7tT+/YgsNucwNk7Tz0/uVSjNWQU04FeJ+0hiQHuR+STN9Uu0iQ9uVZnBApVPqn
         aW8ltQxlfU0m86wwQUiO6Mlw8rDMy5o9CkeA/F0G1Ccr1oyj1BdeVWEQtpq3sJZnN6VO
         V9dh51iqKwCOaSbzExxFe+koKXKcTIuUUMFPXkU8v7xCAnb97QhBG8W6D88FFfilolhY
         9orw==
X-Forwarded-Encrypted: i=1; AHgh+Rrc+hkZz2hB1O9u+g7MYs+R1Vw5oAGpJIdaT8C0NhTgTrYpOq37GaJ0YZ4Ctf5fk8iAPmGrEOkV/Q==@kvack.org
X-Gm-Message-State: AOJu0YwE1QsSoD7MBe+7Ip7MOIgM7GExfDlC2bAl/n3BCovUeoQrFx0l
	PptbxBHMuFvLf9EfV0nBltnQ/QzfYbMK6nKXfEP1eyMIkVm4PAEQxxXjfWr3zxDF4qo=
X-Gm-Gg: AR+sD13p4Ow6GzIAkjjgAoc0fnu64OrpdejvIYB+mAH2OciivNFgBBGSsJgoZTgFEqQ
	ruIIt1sznVEHN1aTP90mBvycw8EZ237Vf95wH0daxrnyFHU5ZMVypupjA7szv/P1bbCmzD2LMBa
	tkm8kF/PNFLIgY32jzVHfx0+LYHHzIuiTc65XJrG/pfJHYq98hdCEefyVDYkQsgMY54FlHqg1fy
	tFcEVtCGuVQnn8ysncUXE6kk3FHAmxaI4ukeC4pDs+VqDAiqoGJUD/uuu8P1C8lA7LWD3dBs3+/
	WfyPgqRvDatG/4RmSwLZlP4JbSv5o1TYI0RLCpZgcayj1CKBpzkoG4fmqK7R96TyQ6mfrfjmWFw
	9TCa/U4B8xsxVHWuvCresOvIaPXWW/vG+IqwdaTNzID1xFw87QNEphOjoTH6InIc+JpZXSAslov
	3rPhqzHJb8l+8nfVCjGKnQMfN/khnVbWgR3sYsg2VKY+3uWS3XH5doD6i+TEmB
X-Received: by 2002:a05:620a:25ce:b0:91c:ac0a:690b with SMTP id af79cd13be357-93483dd5620mr11089285a.17.1785351073008;
        Wed, 29 Jul 2026 11:51:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3227707sm233230485a.6.2026.07.29.11.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 11:51:12 -0700 (PDT)
Date: Wed, 29 Jul 2026 14:51:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <ampLn-xkHnBVNHJ9@cmpxchg.org>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729024612.3369005-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 28F691A000B
X-Stat-Signature: 4hm8yek39pgp3h16i34idtoze4qzpgy1
X-Rspam-User: 
X-HE-Tag: 1785351073-643056
X-HE-Meta: U2FsdGVkX18vjzEdoHtBoYcFveo0hhDcNTp+soqy3C/CkyPNitHdXzxfYXdWeZ7kkPOM1X2oWZvrX+GBteIO7I2ZcL6vUtFuuOKCEf3pIAGuIzS9Uj9p7X4AZfbWTpETDp34z2ti3C2e+I40izv4eSh20wwOeQAlivsRVJ2Ne0WVmJL3nj7hXzfkcYAlTJjApFMQvtL1rty9sY9/YACgudc2HlgVN3BXW8zPmIllOVtloOJIPkNJNw5XMQkbBOMvW2+/+bEMUNlmJdtPY0S5q3dcHcilgqmg/8lTiywT+tMa0CH1mKBysnJYR/exgA3B5IIBX2sHMOD65CN7diW3j38tigEOoltePU1ejQHMc2KiAAt3oqVINb85W4GmNiOXPe1KACPaS8qCsx5QoypVhpLX05zBsD/OI7D5UFVc/lZle8PwJ/5UkUIC3gfoo9DU7E6cX2OkScPltPYYWNXFXEdYGQaagbDU5c0qZMLGkD03kAcS35KtU6zZr7av8RkS4I1x6JMKRfTwXjJuB1rs65lGi9moAUGgXcnxwfCYJ9wBAkrVT04/z8FhAtC9n8VJEap8r+1qd1l18/GIcFRKnfGZms6X2Ite6kNsM68gnygh/0IWZRFK+MgnSNleSuGSSBU1ZeMQRM3AsxkroiSDLfJ3lYUTFC2v1D26RFf73a9WIoTS7yOdqXxOAXh0VwOkzih0fzs0LUjNFeVgQvKalQGhd3ZCxunr3r0Vd12d7ri0iPKbhOemOncHr329+qQDPoMNOFcHkAY5vr61/migIe6clbrDWFxvpFr8AF0X3XP1tbeSW5795bD+IvBiTvu7Q7YSBprjwXdNsLjYmbLjIURU0iOQzhdiQQ2NMbuhgxQ858R3Xxmp/CzJGv+BhI5Uus6vvFojARWoJWUBqa98DnerAoe092Xq8paMCW+nzTvQW4J91jnMqvG475+GiIhcowjCZFIKXsSUNQ0GrAZ
 +b8qQUbc
 3aGUv4vQK1zMBIBisWMBVH1aFbuIKx2MR25YRCBenDeXdTJpUd8UhErAx41uqiheKu9TVbEF0uhX6GZZ/W4uU62IGGd+4komacxrwkO4GkBoxZHa/YjRLR4ZPSp6kWQgej7wygWdPa6Xzql7OyZ9Xq0k+ejwfAEohRenoyRYLd0qlMaLDTebH2ZJOSD4ocFjHZxE6YGnROR73FV8WkHnIuzD7bvFhh+c0etI5rmgzsff7h9wbLw2RTAuxkCwKHzUM2tAsiP0M3+iU3gFuonWEB+iPt6Rrbx2zVOcgAVkOSpGhev6kTGPKok5D8M7zqWwjUZ0+m23BF+r0iR4HgPAwWuoAUr0nqOsHBXFEBx50MvifjQht72hmfZU5M4OoU+LbospNRs9iwhOHIYoCN/UU0mD0/5UhS22QpggueyhbNwcNqE8ALRz5ACZxoxab0czoQMrQCXEjZnJ4+i3wY92AhWtw9uB5HYB69JtwiTFAgvPCKPM4Z7HJaYtuYC5o9U2LXJt3V4T0bHh5Gyn/4kyGgopd+FuhI/IeQFqv284fiXUYFUYbt6FlRB7QWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 07:46:12PM -0700, Shakeel Butt wrote:
> At Meta, we are seeing instances where an OOM killed job is stuck in the
> exit path for several hours. In one particular case, the job was stuck
> for more than 8 hours and I had to manually remove the memory.max limits
> to allow the process to exit.
> 
> The job was a single process job and had ~55 GiB memory.max and zswap
> enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
> to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
> Nothing was left on the LRUs to reclaim.
> 
> On further inspection, I observed ~20k threads of that process stuck
> with the following stack:
> 
> [<0>] mem_cgroup_out_of_memory+0x4e/0xa0
> [<0>] charge_memcg+0x8bf/0x990
> [<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
> [<0>] __read_swap_cache_async+0x10c/0x260
> [<0>] swapin_readahead+0x116/0x3f0
> [<0>] do_swap_page+0x13c/0x1ce0
> [<0>] handle_mm_fault+0x61d/0x11f0
> [<0>] do_user_addr_fault+0x3e7/0x6d0
> [<0>] exc_page_fault+0x8f/0x110
> [<0>] asm_exc_page_fault+0x22/0x30
> [<0>] __get_user_8+0x14/0x20
> [<0>] futex_cleanup+0x27/0x1c0
> [<0>] futex_exit_release+0x47/0x60
> [<0>] do_exit+0x107/0x940
> [<0>] do_group_exit+0x81/0xa0
> [<0>] get_signal+0x2b1/0x6e0
> [<0>] arch_do_signal_or_restart+0x1a/0x1c0
> [<0>] exit_to_user_mode_loop+0xa8/0x1c0
> [<0>] do_syscall_64+0x152/0x250
> [<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> In addition the dmesg was filled with "Out of memory and no killable
> processes..." messages.
> 
> I have no idea why oom reaper was not able to reap/unmap the process. My
> guess is that since oom reaper tries to acquire mmap_lock in read mode
> limited number of times and then gives up, there might be a thread of
> that process which had mmap_lock in write mode at that time.
> 
> My initial suspicion was the futex_cleanup and kernel page fault causing
> infinite fault and charge retries but that was put to rest in previous
> discussions happened on similar problem [1].
> 
> My current theory is that it is just a simple slow serialization behind
> the oom_lock. Unlike page allocator, memcg charge code takes the
> oom_lock without the "try". Though memcg oom code uses
> mutex_lock_killable(), note that in the call stack get_signal() consumes
> SIGKILL (or sigdelset(SIGKILL)) before calling do_group_exit(). So this
> mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
> thousands of threads are waiting on oom_lock and one by one they get
> -EFAULT from get_user() in the futex cleanup code and bails out.
> 
> Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
> bypass oom killer for dying tasks") which routes dying tasks into the OOM
> path precisely so the oom_reaper can reap their mm and free the memory
> asynchronously. But the reaper is best-effort and one-shot: if it cannot
> take mmap_lock for read (e.g. a sibling thread holds it for write) it
> sets MMF_OOM_SKIP and never retries, leaving only the glacial
> oom_lock-serialized synchronous drain.
> 
> Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
> the mm, so a dying task charging against it has nothing left to wait for:
> it frees its memory only once it finishes exiting. Running reclaim and the
> (no-victim) OOM killer for it is then pointless, and doing it for 10s of
> thousands of exiting threads is what serializes them behind oom_lock. So
> before reclaim, if current is an OOM victim whose reaper is done, fail the
> charge.
> 
> Reproduced with 20k threads, each parking a robust futex head on
> its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> next-20260728 and baseline show ~90 seconds exit time while with the
> patch the exit time reduced to ~3 seconds.
> 
> Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

