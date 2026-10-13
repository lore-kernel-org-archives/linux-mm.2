Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87E8CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 08:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C716B0088; Tue, 13 Oct 2026 04:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444286B008A; Tue, 13 Oct 2026 04:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333146B008C; Tue, 13 Oct 2026 04:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D62A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:22:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77A331A0A6F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:22:38 +0000 (UTC)
X-FDA: 85316911596.28.6A15E25
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6AC77100005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:22:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fYY3NxGt;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791879756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0o16lOHfFj6vVRWcNjQS9Yl6CwcGXYm//tE7X4074jE=;
	b=7PJmmY+8KI7CzL1LvgWf1efT7OeNFGKzanlqCcdlKSN8OV1GXuOydn1VlsSgaXr0C0fhTK
	tyyWR5hMiU5kKsJ1khMqF4Pbw+aHznLpo2fq+VkSHP6gmphXts8X80lP4+FUTt0Cz9xaW6
	EVJirjr+9INRbulxWC9M0V2sdOnXJ/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791879756;
	b=HvVPLGbt4eWkfSy8goTxYULmWi3ymDtd27GUbSUo0wAaPmwaxSEDY2s6VgyHKefNlML1CC
	A+XBJyGHxUVHGamcHD2kTBifKoFcceZazYqUsOKIeh19k3zQowMaBSIG0Jq+0lZij8I9P0
	CnkerZQQ9SFTPJffkrP1JayzkgIVMPo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fYY3NxGt;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4d870d54so1547069f8f.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791879755; x=1792484555; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0o16lOHfFj6vVRWcNjQS9Yl6CwcGXYm//tE7X4074jE=;
        b=fYY3NxGtL7j8S7y5zlZCZvoTGKF7TsDoi8jVi9/ftY+NwwYe5a0iFF5n/2L4E4XADL
         AvV9kGSZenPSv/WqfFaruStNUo0U3ER+daIjEljbBZR/lvCmfs5REPGxHuGxkS3VJDw4
         S5D6x9afC9R3rRmbkyxI17EgeoTGQ//zTHdn278gOYskayf9MYs7BxwKGZmoFBHNdRTs
         plGSHu01uwGae0zO3j0CW5YmToD2IJ3SO3qygV9eCNTUTfDxsyjwhrVnJTSFMsUiYrjx
         XtjO+0HKI1X2mpjmC2Z8ihSJYgJczgXL4haYF/dM7JthZLun7N8DHfI4KKFIDUyYgVQl
         QcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791879755; x=1792484555;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0o16lOHfFj6vVRWcNjQS9Yl6CwcGXYm//tE7X4074jE=;
        b=JKIGEW11BHDgPK5zMMNQ7cwIqfgNi6ihOLhGI78/Dm4Za0Td06E1hSnLO2oWkzhrIA
         uBvLI0gfWBq8zSR8i9oieVlrxh1tlGh+pGe45VnJsJiIPl3Koo6WX3hivZvXyOlSp1gT
         ACxAKCQ577pxYqTFF1WsQ4RttDms7+YOMnEL7BlDGMZEGreOGuGiABhY7rsmIPuqGwZc
         8upSA3f2l8RDgRPX4+Z5YZF9KIqpSp5D5gd9jQSPGqkPwjidPkf+qA9OIB4OoDEvVpTX
         l3yF6kMqKXVBAe6D10fUsrwSgJAoAUXH2TKI0Wk520+Mg6q+iJwk6G3HUgix32OBsO3l
         ZOIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzGzrvWUB8SRojSzSXDtvm6vj4BjThPF5RszrWNsIv3kNg+vtiwLgY7zCoAu2ExzmuScOpva375Uw==@kvack.org
X-Gm-Message-State: AFq9FYJCFNnJxxTVRr6mfb+p9zXTxRgzdFz7Bg6YoyNQwUNhNTSg5ZX/
	aXk4TlR434Z6CJEN6Hy808ERfDa2eWdDHvbU0QhiC9Hurx08YqAcHDoJ1Q32BkkUdH8=
X-Gm-Gg: AYBFou2wO67GvURyK2vDJbUfV3ur1Rszys1PicEhiSWWGcRFut0l8+9MYKMZi8k/Omk
	j8ZIWHASHqf867/qZ3bjdfJwTvAXiU00OHwnjzFsekgKhXcJI9bTJ//fpx1dHsqEv7IJ2b+pncy
	psXyQNNm0DEXm8BKbLrR2XAldcb5WLFEUuxR40gmnZfBk424Wkn63dqKmyat6ia+D445O+LJGbS
	BiL/6EDkgygt/oYgF2YIPAsZH0noVnkqnCI9LAEKyNE73mkP8jZ8QVkjCBmKwCxVPNvpPVrtiWr
	h/JAcm2pfLdtSjoyRAfQCDOAqhteGRfk6F1tpPQfDulK5edRt6GixAmyVZxC0mg0DqwW+FlciDO
	kNsatJrQqD1djpdxUzA/Wqzq+9DGtwYi0e5bzGmRcEQ7B7zYTaWZYjcsWwfT4WQHmhU5KZNm7xP
	+v3pd12af8JwoQfPZlS0JxtR7B+goNYjrAw1Q/yEP2BEhTFyQSrsio2VAS3nn42st6jzRoIvN0G
	FUsxhQxfOcP
X-Received: by 2002:a05:6000:2388:b0:48b:26b:7f8b with SMTP id ffacd0b85a97d-48dbacfbd3amr21310103f8f.57.1791879754824;
        Tue, 13 Oct 2026 01:22:34 -0700 (PDT)
Received: from localhost (109-81-32-161.rct.o2.cz. [109.81.32.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaabc3sm3951815f8f.16.2026.10.13.01.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:22:34 -0700 (PDT)
Date: Tue, 13 Oct 2026 10:22:33 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rohit Ner <rohitner@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: log userspace OOM wait entry and
 completion
Message-ID: <as3qSdvoU2dESCsR@tiehlicka>
References: <20261013040034.3919469-1-rohitner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013040034.3919469-1-rohitner@google.com>
X-Rspamd-Queue-Id: 6AC77100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hf3rdcg7uazg4f4w3jr6kja8psbci465
X-HE-Tag: 1791879756-197475
X-HE-Meta: U2FsdGVkX19Yp/ILjBn1QsvqB4V0xO1alajq0TldQBhuuY5zy6tDvdrZJax2mJWyiivw/ohazPir4+WFxm0C+LBwZq9uLCFTBaBK+AWevHCxRZPnFXqD+3noRW64DyQt1YDlMWx7wfLXj+QTHR7wdkGtHvLHQS9mncA1nNrvN8CK3W/q9JV29kQGM9Q5/fSMpP4tiIGBFQeZpuExGb1a5ZKfOLuR8Uav0sQ/Ac7LuN3A4wKk6Bb1c+xy/cR/9YJH1FlgGSiUW0WheYkyBbw4Wgs9+sbn5nR0WWRCVsIQqdQebs25W+NFnipakuRUFOundU6s3vtbct+RvVWh6BNsGx54VTuJnxDUUx+hr4MxwYAs43hZmMV0WhXrzKtDz4h23rKHwRzcrCMtJ2xPYc9A36RZkIOICljm/jNrWAGmZoN2m4EvuE0DbnL8NQN6tzySRUB4cBAtbinqPjO7ZOBWG/KCqn7Gk3mx0E++9zsM2HH0rCSZRoNwtBUkCcn6cHo+UjFaIDF5yOmOvOAs5LeHmr4tbT95bZOcnsCxR6rPY1s53B5JwDUlTjzFGYDLLvKg8RLSpoqElqimFxyVdqhNyYiWDQujzgr4xob8YvIj7ID/jROo2NgRu83hR6jgqKQiZiXyWTO/83yOKD1n7xp/H+PoI8zbay8CXnoeMNrndhrfWJNoBr4Hl3r0yDadC/GHb1OiR9T/S14Z6QnK4qWUizv1HRetoddPVlPB8E0a6+GTh4aeO8sO6TfeOrqDANAJquuefOpfinst83qYGciOxOG5apuLzQr9WGvQE1p0eqzg2sVt369C1Qrnhv3tk1gdCha0kZ3cs4L3u2F54T+/crWS+C0EpBkLoEyuDTbTVl3xQIDc42AdnZ07yLJphgZ0nd1WVxtVvy64QWr+8Eq3uzfg3iaTAKqjX9Jfupjq9Nr5FRh39d5bMa7+0TqCp6RQIZvTESxZM9lAfK9F1st
 FH4S79Mq
 2RB0mdTyVzK5lQMCbs6nh+FO3+elba9Yhejuukr0csYUL0RlR8qRnA/4aSEmUu2GucoVO6eEmXbE177QRIJzDJp9PNaCdUutfp2Ew3MG+guaWxTBU5YmYHOeosPRsPGC+kLLQwbeigUndyIiOV3zolzjT3abTyTO0+UXzSSlxqP8UzbYTtt0VFC1Y0PO1HOsWcfyffH68S2DScBlP5LEV8zpRfkdCS6cu04j+CrOIKiu/fLTk6JAOITR26wFJXtwcOetWgWneiaOVBf6Uppm5Q5ASiyBuJiEL1brLlCLtT1+C6Ohb6hu7JfPhw3ZJEodzpnRplrto7I0VCp/Yc3YMHwSjrM3hoFlvc+PS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-10-26 04:00:34, Rohit Ner wrote:
> When a memory cgroup hits its limit with memory.oom_control
> oom_kill_disable configured, mem_cgroup_oom_synchronize() puts the
> faulting task to sleep on memcg_oom_waitq and notifies userspace OOM
> handlers to reclaim memory, enlarge limits, or terminate tasks. On
> platforms where userspace is severely stalled under memory pressure
> before a hardware or software watchdog reset, no kernel breadcrumb is
> currently emitted when a memcg enters or exits this userspace OOM wait.

Correct, this is an inherent limitation of the feature. You rely that
the userspace OOM killer implementation is correct and memory pressure
aware.

> Log rate-limited KERN_ERR messages (pr_err_ratelimited) upon entering
> and completing the userspace OOM wait in mem_cgroup_oom_synchronize(),
> including the memcg path, memory usage/limit/unevictable stats, elapsed
> waited_ms, and whether the task exited due to a fatal signal.

Isn't this something you can achieve by adding dynamic tracepoints, bpf
progs etc.? Why do we need that for all users?

-- 
Michal Hocko
SUSE Labs

