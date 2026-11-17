Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF34606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=GmG+u3sX
Received: by kanga.kvack.org (Postfix)
	id 089596B05B0; Tue, 17 Nov 2026 17:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063986B05B1; Tue, 17 Nov 2026 17:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9076B05B3; Tue, 17 Nov 2026 17:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF1CA6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:54:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8703A05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:54:53 +0000 (UTC)
X-FDA: 85446117666.03.5BBBF8B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id D80F814000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:54:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=GmG+u3sX;
	spf=pass (imf09.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794956092;
	b=nqlm7bp9cXscpJkxBkDd3BZTbcqo7SC0u8I4ZUaEpxt2x7S2lUJPC3JASC5n6TrhlFUfhe
	+xMjTjpGfL4IyuP0WnG+Uytf8Big7ybJkVGAF5v9eg05XDkYmJX7jYRFvXdjl5Ak4jXJ6a
	M6jTnosmHFeWBM8sST24XaUgfrkZnz0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=GmG+u3sX;
	spf=pass (imf09.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794956092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7mnzARqVOnOj+KyQYPdVsGKtz9mrESSr8dwZPCPrb4=;
	b=RkAwaM8gfs3i5Zq2lMwh0TCYznj4oiN2756iHSkPtOddfXzRq54A6ZZ9EU6kRSjGS+j0hV
	VMrslTytNhL0wJW8PviSj1XR4fkcJ8ppb28P0RatTvF+SngDFJItZj+rPovwPaXeHAO4LK
	AT7dAJOQj9+TTbfraqK44Ee5PpFfQ44=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5365f9a04c5so4296161cf.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1794956091; x=1795560891; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x7mnzARqVOnOj+KyQYPdVsGKtz9mrESSr8dwZPCPrb4=;
        b=GmG+u3sXHvnv2Xrj2nucGhTNYrTlIdBgGOm28ND6dfxSSwm5GF9eFlst1TMVqWraen
         I0ykagGc2KDB5b+rZO7PqRq1LBkEs2Cu5yegXM1FClkN4fxHLuu9O7tglM25/GPkxNaE
         Bua560jHwhaPD3fyBo/RK3y9VAjwYyZcEbhigYG50pBM8GD8irs6eJ044lC1lNIQeD6Y
         1HLg9S8BjMWA1hGoSVAmWCPO+AtyacH/aMi2AvT0mCYIC5eVyWxWruJHB/0RwjVaLNqD
         CmmOlMhASSa64Ki8sUH20O9hjOiQZrIassbT5kisxJ8ceCdgfDjoSZwEgrtNW7v0LZhF
         RAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956091; x=1795560891;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x7mnzARqVOnOj+KyQYPdVsGKtz9mrESSr8dwZPCPrb4=;
        b=xqFb3GNtvTdsSdNlI+N3F1og86VuOzjJ/+UIDH/qS8XaTZAMmIGGt+NUsMuBdx9Coq
         YeM8HQlK38Z+6j+Du/mkJqYtWBXKrth1LXWncomS97Z6bg28rygbHKU0fjaLSdZYFtu4
         9Keszzt+ncHk1vHjDFod+llRoMxqMYcrp1+B79SQxybQSCfRsk4QIxzZNc0EIq7Ur3XJ
         9+y/LExp+aBRbW1PUWP7lZG3bT3vdO4SH4OcbvHZ5na6I55L6cwkb0CYihCJG9IJ90wX
         zfTKliBOLsKqWm86c6vmELAEt/6clRsEPzVvJGznYXGzTyZtPutfs9ewjt9HR68bifQ7
         pKzw==
X-Forwarded-Encrypted: i=1; AL+hErFqHP0W1ug4V9k5hcnOxxhggtc1+TWJYhLQz86Zv3PEyd7DJe6f0ch+DeFjTO63mA5BqCnqwaFSpQ==@kvack.org
X-Gm-Message-State: APuU4Z8OV1iqbw+lzrOESIYXzAhdcB1yLeDn26hhcEA+gFw5Tm736TFV
	7OP/pgvRIdCgnMekrr+3d9s8BeMU8NX5TuEjjzW+sCbhjpP7u5I7kk7SVidWdtoalg==
X-Gm-Gg: AYBFou1T/0AeiRIvcIjmuD7LR+D8OjMteCKsF8e0pGN4R95QONbPZp4sz0k6BDmEuDU
	Ucx9UE4Fg3oxQ07dm6uF64jQt5EP2mTXRDXW1uh/Z1+LYpCoQl6kF0TMLOvHPJuO8rNdxStkKgo
	3saMfxfM0fOrFOCgdpgOozBcy24GH5Wq7VBB4qjqsGBj4/4IfhkXYm4RPebCq1svZbeyBQHQlvt
	iGGVg5bQgUEzS3zGOxLyq5fM5RT7dH8vr2LGo+/6aOhO4zxBH7p9epYOhecvngNwS3oAF/idS+H
	gkJ1KlubSPvQiWCkSCT3T624/DWmeKZgoQ+z3OyCaqzEj6wf6rucCPZydDA0YYfgB8V+GP8tDhF
	tE56UoPQ7yquOQuAG7eiH0PcI9Zkd9bOgEaHgpC9yvRzzDjVuPVDZmcQ/Fiwf32yLn8KR63hup6
	iu4uDdSc/A3atNnYCB+Q5WSpCmBLVzJZgPKLTTtI8ac+3nGl1CSUbZDHA+2iHiJJYEnGhVAl8+c
	wYfM9RdrhdmxNHJIne1/A4JKiitF3o2r2U0+EZ/5e4R56BikZS7v4QkyuOPR2UFIn4tHchHlJBK
	moV6b0f6/L3wIjVk0uyczNyK4Y/LHBViYM1zfANpJA2KhZgDFyxpcfO2tkRvialz27d7n7nKLDt
	DXsioqbWasmP5VqRJGEQlmEVWu6p0CMKUmWGxwIsrALhytu4UdBw=
X-Received: by 2002:a05:622a:1647:b0:535:92a6:22db with SMTP id d75a77b69052e-55d5a36e150mr14373911cf.1.1794956090990;
        Tue, 17 Nov 2026 14:54:50 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d58fea01dsm7818061cf.8.2026.11.17.14.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 14:54:49 -0800 (PST)
Date: Tue, 17 Nov 2026 17:54:48 -0500
Message-ID: <44c0c45c0e2f47ed77bc45be47ebb3fb@paul-moore.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20261117_1552/pstg-lib:20261117_1552/pstg-pwork:20261117_1552
From: Paul Moore <paul@paul-moore.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, echanude@redhat.com, mripard@kernel.org
Subject: Re: [PATCH v5 4/8] lsm: Add memcg_charge_task LSM hook
References: <20261117-v2_20230123_tjmercier_google_com-v5-4-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-4-1ce975f2a9ad@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D80F814000B
X-Stat-Signature: 34mghnduchnncwwdw3tqzuwgpodoia8n
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794956091-672334
X-HE-Meta: U2FsdGVkX1+OqLvBItDRjWAVr+JJGQ9bHGJad+Pwsi0cXwZCcq9aAZbHZCjWjQzlM98u58qgRAprs9QjDniqvWnf4yfN78cQDTE4MI5GVehazK/o7GMQyhvzQrt0NZALk17YpZR4qD6D4g2FBwU6NmojipOPTfPSZdKDXMPSd20tEM6y5nyFWyOVE8JiwSoFTqUz5276DvqzYmSZ7dWhZNKNz737dk5TyLmpu2rOKmtbLHgPooQ1d9EqT/PcrztAnlaEePaFU+vegtwZHwqeSbfnN/aiA4D8yyMgp2HEYFCAvwfPc6XTFyyYXTacIKlKL00M13eZm/DVFpziRHy9mtIe4X5L9qEqpfhxCrTnQft0PoFJb/mKRDD9mKdjnbUV/z4bnDceuxCFXizLEh0jxLm8XIQCSrwUF+lTIkCaZXXyf32bNk0c1ONVS1CZstXMaRBeoi3NaSmy/OtcP+5Flx2GTW8q0lWjd6IO8SQQpJjkZQDCfRh73gsc0oX/4m5ElrBUCLlanzSsOGoCUnEHKXhIKYV9XA3s1xHPQ9ozME/zmRtRLnq6xkD4HvSnOu8bXjD+VZTdGaGqMWK1qKVCpwUgJokDEIdZCqD/0D6/A8LpW5DBfUfl5d/juJMRAuNFYvBSUqD6uPDoTYu3SQFo+QVTP1BZFmReBczL8Y50KoQmrFmoUb+HgpYQUbH/w7cjXpTsspx+YJEMK8gy1UDwtNSZxu4PeTrsgiVcZOaJ5E+BOJaZ8e6v17hQomGtRUcJ0a4CQ6lDHHqAUjoNux4D5sq2XzOqsYTEU++TzSVS2yP/44YFpXKr20wjNgS/T8ZOiAeX5B+r7rmVb2DUwNbQ8F5ZSnLHhLhSPBd9m4hWgOGAC2JnSDke/USsl7hrO0aQHN0hH+ZStAb3/EkbxrznFjTiu0TCawNpvFuhPyoWYfJYpgEhaKGLi6zzP5GZ2+wgLsb9K2DUJE074se+ru5
 3Qv8CLzz
 G0VKimV4hMCYkhGm0OGYq4gC7rxO/M4+p25cSUP590Pfr60m6JqFbuVnpe5lUCzbxOlpcCfrBCZxvSRxgfB7vH3i9GOGzGA74fC2jLK1RYukbjLhVfAvv/L5/6yokGT4qm0+Cyn6S8Cc98PMGm7mqxozI0Rzaa8LH/pxEhr+HmYFDSnkvTuWU5WrFJBBCI0Z2I5WHXh48FOBUy21Wor0u/6qSysY2ee3TbrtYO8itn6jtnDY20sVLkO84hgbiet79Uaf66LC3Sad22Xu263JpL/j7emCndtvg4ktdHete9jbdSmC32F1hssBQ3dUdD95TufYGr9ibcimLid2TfaqvDMkbFfbWKbGkhSPwxEbNEm+lKsbeAJF5EPDhZbTDgBaoeq8gubDnQlK/gCRgGi741X8di1D8BPJ5mfqQ4t4sCzl1i/VFm/iGd+BX4n+1qxNEGUE0YpEQEaWbwJIwTP6aI//KR6oJElGTIl6zOLmwTn5ixEEk2OjXuH99vGVdiP8jZ2kTmrLrkbWNH1BsTbtyisFIzxgAnLYQv8Z3qpYltHNPvMH2mE60IgNWHmNETqqdm0UO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> 
> Both DMA_HEAP_IOCTL_ALLOC and the new DMA_BUF_IOCTL_XFER_CHARGE ioctl
> accept a charge_fd field that, when set, causes the allocation to be
> charged to an arbitrary process's cgroup rather than the caller's.
> 
> Charging is currently limited to the caller's own memcg subtree unless
> the caller holds CAP_SYS_RESOURCE. But the capability is all-or-nothing.
> A process holding it, along with a dma-heap device node or a dma-buf
> fd can charge unlimited memory to any other process's cgroup, potentially
> exhausting that cgroup's limit and triggering OOM kills independent of
> the victim's own activity or privileges.
> 
> Add security_memcg_charge_task(), called in get_obj_cgroup_from_fd()
> when charge_fd refers to another process. The hook receives
> the credentials of the allocating process (from) and the credentials
> of the process whose cgroup will be charged (to), giving security
> modules a controlled enforcement point for cross-cgroup objcg
> attribution policy.
> 
> When CONFIG_SECURITY is not set the hook compiles to an inline
> returning 0, adding no overhead to the fast path.
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/security.h      |  7 +++++++
>  mm/memcontrol.c               | 11 +++++++++++
>  security/security.c           | 15 +++++++++++++++
>  4 files changed, 34 insertions(+)

...

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 03cd90d5e623..2e6fcbe14d43 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -60,6 +60,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/resume_user_mode.h>
>  #include <linux/psi.h>
> +#include <linux/security.h>
>  #include <linux/seq_buf.h>
>  #include <linux/sched/isolation.h>
>  #include <linux/kmemleak.h>
> @@ -3198,10 +3199,12 @@ static bool mem_cgroup_may_charge(struct mem_cgroup *memcg)
>  struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
>  {
>  	struct cgroup_subsys_state *css;
> +	const struct cred *tcred;
>  	struct obj_cgroup *objcg;
>  	struct mem_cgroup *memcg;
>  	struct task_struct *task;
>  	unsigned int pidfd_flags;
> +	int ret;
>  
>  	if (mem_cgroup_disabled())
>  		return ERR_PTR(-EOPNOTSUPP);
> @@ -3226,6 +3229,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
>  		if (IS_ERR(task))
>  			return ERR_CAST(task);
>  
> +		tcred = get_task_cred(task);
> +		ret = security_memcg_charge_task(current_cred(), tcred);

Do you ever envision this "from" cred being something other than
current_cred()?  If the answer is "no", we might want to consider changing
the LSM hook slightly to help prevent misuse in the future:

  int security_current_memcg_charge_task(const struct cred *tcred);

> +		put_cred(tcred);
> +		if (ret) {
> +			put_task_struct(task);
> +			return ERR_PTR(ret);
> +		}
> +
>  		rcu_read_lock();
>  		css = task_css(task, memory_cgrp_id);
>  		put_task_struct(task);

--
paul-moore.com

