Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612BFCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B15E6B0283; Wed, 27 Aug 2025 08:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961D46B0284; Wed, 27 Aug 2025 08:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8508D6B0285; Wed, 27 Aug 2025 08:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFEC6B0283
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:09:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFBAE84C12
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:09:04 +0000 (UTC)
X-FDA: 83822416608.28.8DED3F7
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9C4D80014
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:09:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UzRJLNBo;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756296543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vX8WnxRhim6a/G891Mxzmq6M4cjiItYNLRPlcq6KrU8=;
	b=Dvuvus5ac/BXo/GKSeIGFz5qtHsO2xaQf3Kq86wcEXw6wt2wQR8da4LNbDEjlKAL9EfnZF
	g6reqW0zU26ovdVvJN1mju+xNipercFNlKdGyCZfuPZ8eof7RK/+1L1fC0GjhccM2/bzb+
	h5iyz8o1I+bj/Xzek04vxrTZNDCK5Is=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UzRJLNBo;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756296543; a=rsa-sha256;
	cv=none;
	b=KAOG98gdUArUsMvE+rq/7SZsapJs8SGC1iHVrQiYwKHbOZIR617MrAAH16yO2gPD94W1bx
	xxujNd7pMS5qI2B3bBUujh4+99UoQfKzkmp/1pFiZ3+bNDw0wTKkLid/QiqgwkH7dLE1Q/
	8i9q5Wepf+Mjz7aTJEboPCQXx4/fO3E=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so895407366b.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756296541; x=1756901341; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vX8WnxRhim6a/G891Mxzmq6M4cjiItYNLRPlcq6KrU8=;
        b=UzRJLNBoqHVCrzFFI3ciPvsJUWQ2Is3bgwNQOrIn6DtK3iUkUEp74VbqHvYOfnNptZ
         3vdOykGAiOO6BYTjUTtj4+jfcCM9jbLUhEbAG5Xqcn49kd/4qNqFG2TbkNrRPu5Y2XTU
         vKILKuXCb3UImNhcFng+fLt92nimIzvmGxD5HOz9U9886gL/sl6WAh/A+FO72NENV+uH
         S5vpRtU/zvJ3XzG9HWJi9w6Ea+CXUrHwIGKECzHf4OGwG6xPvn+rq6UyRD1+BqTLBewF
         vTKdHKAaMwKUqqbTYVUIuQs21GqzJtsUaBlWAIc1BeK5qcKId6WkJnpsYaUM5gSLGyeD
         /DUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756296541; x=1756901341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vX8WnxRhim6a/G891Mxzmq6M4cjiItYNLRPlcq6KrU8=;
        b=jQG/BQVxfpSkgMQ5POH07bbwkqmb3TN2dbBeNE3HGTTu2NRZJUWAwe1aeGwvyRAGbZ
         vCyBuNvNL18dBGYWOYr5Rb0pWy+1ipwZeYd/WzQIBUX3r/70vOardB1JMFRqJ1QHF95o
         BZ2W0up5pjTCEBV5DLU0Ywieo5PgShOzkjlF1UM+eptbZ0v3Hqlf5coPEibwP0mryJNS
         EByEKa/QG4gqzWJumjE4P1NR30Ode4TjMiMXZkXyTXiXRyzjqxFAB6jhmU1aPsI4wrjz
         /ju0l02Y3sZIB7Rk+5IVHMkAbxfj1aUhr0lFZnZhYA8k6NaZeutehoghQV0O/yZXr+AI
         0few==
X-Forwarded-Encrypted: i=1; AJvYcCXkAAQvHCrb9x1YDrWKKlo0FN9rqyFTHNRZF/Z9dq71m020+ZN0J8bt2+4CrXqX4SV/BErG9BMYIw==@kvack.org
X-Gm-Message-State: AOJu0YycMDDHZ+jdFYP7XUjnZ+zm8LIX92iUjZ0BqlERBFzLmj+QASBB
	MntiEbwizTk4N7m+Xs1Otr3XHAtq8NuffwgSG7qBD2KCAmc/lFC/8Hn6voVSBDZMzvU=
X-Gm-Gg: ASbGncuqNNA+vHbD1kWDvhvAXbwX6ooD8ck+0VaZK9Cno4pV+wEVfwwhGqfWZO4VTX/
	JfRUsF1kSRIrARD1p+zO2vBxXoexJPbcfg41tiVucmMZ6pf4N+vTcCxWT0DDeQ3PwZbuIzSdPqk
	QtZ+wwLRTGM7KObgCnCNmgj9QSYHWUhqqGbv9nwFwHqrawGIP/REMoTw5T+Loo1tErQXmV+BLkX
	2722zeRsHDjFQFw1/MagOV6H+hUgaNzx2+3BHFCgmb0d7NXZd0X510ZFpMhvCs4KLnjq1c0u9ls
	ynNjwSievrrSYv4WxDmVUXDF2Bb7xOvh2FIgeA7vyil534ereoRAG+Uz4qtyCJO99x5EVIPoCnT
	gBaMGtwP+l8JzwhiOZ5GJvg2TlYa9hXpA
X-Google-Smtp-Source: AGHT+IFkV6Q0CKt4qC6zznsx4y1Vd+1Uv+hwAtPFJ4LUzI7MVdaA7UgPt9OrIwzGQLCbth5PUkMCkQ==
X-Received: by 2002:a17:907:94cd:b0:afe:c767:2ad8 with SMTP id a640c23a62f3a-afec7672c80mr139290666b.31.1756296540875;
        Wed, 27 Aug 2025 05:09:00 -0700 (PDT)
Received: from localhost (109-81-18-37.rct.o2.cz. [109.81.18.37])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-afeb049133dsm321386166b.75.2025.08.27.05.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 05:09:00 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:08:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <aK71W1ITmC_4I_RY@tiehlicka>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825133855.30229-2-zhongjinji@honor.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9C4D80014
X-Stat-Signature: jwaw8mm3wu399mac4h1bydahm9dtekn3
X-Rspam-User: 
X-HE-Tag: 1756296542-838711
X-HE-Meta: U2FsdGVkX18/Tf9dN4m+XSI0/n6IuG+ZdVP79dYwykivDgBo/OQFsVNyrhVPm1pTcbQORJ4ZG8KavlQlQvjvgpy4VMd0s3VxDvf5zuHxCiWItMcM/wVF+o6KRK5tOWPlCkZ59Y1aYPxirDZG+VuWgQTxsa0pZwhMMn9MRqSj9aT+1nsYgOBNDYp9WkhuII5PcwC2Sw4wfjKowWrlEnUTf+f4Vt8d94XeNJS7isoJNEwQgrDdCzVO34HTIXWTtg97BPdXqOlNUiIJy0ZsWCN/yiUjIZ6CzKGsJgdBVQ7odTk3KClJtFT2TxpJ5f4bZj5t7eSR9icMBN2FdLEcSOx4QOh16db1rX8F7i+BUp8/a2BsB84/n6diU6HeahswC2QIFS0rAjGCoWoUtp5Ioer4eAop/J8yIzLshNsP55/zNHa+bG2DD1RTfWDY0WiGURi9ir/E2o7rjT6ADPSuKFR++wngbB77VX6Js0DXOeIC4Eit6+/ScCTXGfEfhHZWNwvw0SOkmh+Vx/f3kW7CTjDxKqBB9uRifSauZ1hDrVZSLktpKlReLIgHNk6qymfVwFaVnnA+pktiaNcWMkgtfgElNG5Voou1kiqLDurLGiBntrm3nCVSmZgKY8L1YqnDVGItWke255ahCEjh5SEv/238c9vuB9dCMvilhij/X5EczzHmGFJgik9SbY9u7aDAXxU1FfN294xkA2Yu953MyIlz2uBAbM3JSIwDX70UAuouXnBkaYYDmHIjtYUQPVmFmWILzpZiAURuaZYSe0+wYDf1UFZYIbifkaC3oB9ImhHjyWaVBTTAKtAttwGirxwnv8tErOMRVoEuGNF3/ttaGISjzQ85P3Oyh9up4vnP9fgplAS4TBIvN1Jjccfzp1GBaqZx0C4RyQWskDyYTPcAOc5cc5HOaZRHxGaec6W5fdUsn4Q5cLLHn6j1Ofo+Iql1JMiTM9Hq5ahMjrTAfNI6rWh
 6gKE+2xT
 s0iDE2ePGYx9zOEbsRPItteMxDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 25-08-25 21:38:54, zhongjinji wrote:
> The OOM reaper can quickly reap a process's memory when the system
> encounters OOM, helping the system recover. If the victim process is
> frozen and cannot be unfrozen in time, the reaper delayed by two seconds
> will cause the system to fail to recover quickly from the OOM state.
> 
> When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
> will keep the system in a bad state for two seconds. Before scheduling the
> oom_reaper task, check whether the victim is in a frozen state. If the
> victim is frozen, do not delay the OOM reaper.

I do not think this changelog captures the essence of the change really
well and it suggests that this might be a performance optimization. As I
have explained on several occasions the oom reaper is not meant to be a
performance optimization but rather a forward progress guarantee. I
would suggest this wording instead.

"
The oom reaper is a mechanism to guarantee a forward process during OOM
situation when the oom victim cannot terminate on its own (e.g. being
blocked in uninterruptible state or frozen by cgroup freezer). In order
to give the victim some time to terminate properly the oom reaper is
delayed in its invocation. This is particularly beneficial when the oom
victim is holding robust futex resources as the anonymous memory tear
down can break those.

On the other hand deliberately frozen tasks by the freezer cgroup will
not wake up until they are thawed in the userspace and delay is
effectively pointless. Therefore opt out from the delay for cgroup
frozen oom victims.
"

Thanks!
-- 
Michal Hocko
SUSE Labs

