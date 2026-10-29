Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C61606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UmCabo/D
Received: by kanga.kvack.org (Postfix)
	id 56EBC6B00EF; Wed, 28 Oct 2026 22:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545BB6B05B3; Wed, 28 Oct 2026 22:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483E86B05B6; Wed, 28 Oct 2026 22:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28DAB6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:05:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE1B11201C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:05:08 +0000 (UTC)
X-FDA: 85374021096.07.5998FF2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECD47180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:05:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="UmCabo/D";
	spf=pass (imf24.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793239506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
	b=LV85u6p79kUWT+cGTDYtZYQ2iID2HKC/W6CCwxcgxRAhCla76rpqZJ+FRb/u0pp72nYLMn
	aZ0OWORHcHheOUHQR2/1xBlSMs7ZQ7v1chcUNHF0SqwXANZboGGwEwy1a5a5YBbTkMvmTe
	/LQEsVz7S2Xi7s1+0YvZrsuHOmMXsPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793239506;
	b=3i8sjtrmZisVuPZRAylvWvCCMk7/syj1/EvrlrVs13/lixWCCk/rolZUmFAMUxZcmBykkL
	nKzyfM6p82XqJ7xQ8WzI9S+3rMrxnakCtDEjHCHMmFrKRzu0ma/fZaaow5iENQHZEvgD98
	y0jCAm/gk6Jc8gRi3AF+11Zu0zKJkrI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="UmCabo/D";
	spf=pass (imf24.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ea138a3497so9451035ad.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793239506; x=1793844306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
        b=UmCabo/DFpj7tkDyOdomAhCr3/Jlj96IdhH+C/viLPbFe0+gQADyzO7i7ctEBvThC0
         1jXk0ST9ishzl9alvIhLzL8JMTXCaK/iwmI3PZOc3b8NMOp+iEeLToSbrb8wlRiqx9Xb
         F++Wn0O4sEVGDniH0ZzE0pH7Yfz1sq9cPauQkRU1QK63XJiIo+xGA1OEH1/e3xzcwV5x
         nuZQToGvzoxw4MRlC+xeFxG1L8ebc0THpMQACZfrzlMY3UiqgsgHevEfMKkQYtyf10tB
         4lQfWcIxWCyDtfAELzvQPnhn4O5uYvsPj4F/mCGS4nZIIeNCNNGC+pTyRzFyDGfySyTH
         /dtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793239506; x=1793844306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rK99wOe5YgzPR+1j3EODIxuynwC2Z4XRQXrPwpcj2BU=;
        b=SeZWGHhKHC7iJhg0nrGJWhbo+QUw8CniVHXcf4AdLLmfG7DVwnL9+7cV4KmqmwFFeY
         rFPXNcgO0vV+mbriAyNzAm7Tuguz+aRP0BqfI23fn6re7ypUhCZXz2EQjvRCbHjvx9YS
         xUgEKSwpvxiMe2CT+EzEZ0FREa1xV+GSjUKORWpAi9g1VBT/jYsNjoJlAeTLAIjSQY4I
         uY/4ZVfcoF/s7JW10OgxGq69uL8Q/Va3qzwVs7zOlAffEpaa2uPUuI+BYn36LEmN2z5Q
         Mc8kF1OtK8gCsFHbobQ3aEcHJPFh5Gk0TmQwC/36hpa4WdgIBeDlmjVX1r8nKqa2QU+p
         OFGw==
X-Forwarded-Encrypted: i=1; AKwUvBwKh57ijPrvLzqwRUOlPXnQzQzVtGmURZDDx/H5DgJ+cnhVpz0O+Yz7uR1Zm4/JEsmnDrQBBedtBA==@kvack.org
X-Gm-Message-State: AFq9FYJ+F3CmmEmlySU/q3TFWVPZxPmmMTK9KBY5K/droZpuKyUztZlh
	kDWu+BNBaxC6vlhHVgjGmoBszomC8mlm6x1aV0sUwWYTs29XHdTL25Fd
X-Gm-Gg: AYBFou2AqgIZ3PoDayMlb2bnyIm+CGLQ2i4QeZYQ+mTfSBeq9L8xsQ6tRvb+npsC68z
	k8lMqf28HXJqVUngsUtxB0allduGEnGeFhYvOOyieBlUJ7YRC1ZOuaOqP+9vQRaADjXePOIbtxe
	Ip5CZHtgiATZ9tX13aLs/aqeR/TDIz3tcZ6OWSAplR0ZdACYsWMxDNTSnTAX01ctzhQxtU/fENf
	U5mAYXZoHGcgBcfJMEhmPLRMrbTCQQy/a9J4gfSjnowRRD9bIuDnnnSnN3uzSOJ7Z6CuwAltAFe
	3Y8C0WpIBP+8FDX3ajHd9mJg3WLvshIGV4VSlFuaoIvCJvujVYNdh5///IcS+I9zryzTi1kORdZ
	wCJNHmjtlTcW5bmc6EXGkiakgPh8CkGySaGeffr+n5gOV7N44MCcFz4NImRIEh2VybA/4PPhsvN
	NHXBAyGqMHEF8KzjQd8DGC50CMkG+VZsrbsxXtBOOmaeBcYmGlpbveyVCpwJk6xmAbeJoGmJnFu
	VNNfa1wJ90pG4H4lT4MGtFucx5ILt54Zq9gmgeUMenZBKzndOFzVRqJgDQ7hZkcAuoKh/MDJSqQ
	+G+bhcXxMiOO+IxD1zDatGncwYFX29elZ+NynVdOc97xa0E=
X-Received: by 2002:a17:90b:574b:b0:3ab:be66:ddc7 with SMTP id 98e67ed59e1d1-3ae580a82f3mr3038446a91.10.1793239505712;
        Wed, 28 Oct 2026 19:05:05 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae55d1650csm2351887a91.1.2026.10.28.19.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 19:05:05 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH v2] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Thu, 29 Oct 2026 10:04:59 +0800
Message-ID: <20261029020459.3335597-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-188003@kernel.org>
References: <sashiko-outbox-188003@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECD47180003
X-Stat-Signature: 7rgfhin35hfijsrhaacr5yjo6dwewhb6
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793239506-861178
X-HE-Meta: U2FsdGVkX19KXuna8TCNEGH3KyAYMjQWbd+JOwfq+87dLgCY1IbZD5ns+wXR2KGcRpVUzbUtg/iMSlbdT6Wc3uDkQ20biDjCYbsH1LfUzlnw3mMAvinrdFyoKSC/k9BlHjXxCl5IFsPNLxFS+MJudrXqQRt0Zp6miuoOYT8Fry53sULRnvjTZtfcP/lNf5KflfFuFYDg92SLnZnOwRjjLTv7uCNhbijC/TShGbIaL5Cc8Gyz59fLhE1TpyUXGMCkCMrOGErydf6/sWsVeawg3miTI50FEhgdRq1bQSoSPpMgAeYqiPvdyyHb8yY2gaCuDDntQJV8uUmYYLcXk5cZhQFuYPqKJcH5bVnhKaAEhfoFAyDJsdIKTiFnjrjbSHG2YLDU6RpCepGVah4Q7OgkXois0reMB/ep0YyfCpGFCXAFHvoJTWYcNsY8yiSb0WRoXthL85ZyhxQf4gLcD12jMMA8dZZUFux8E71pRGmziUCpWKZ377LfnSrNITnNYgRu5Rzk3aRw6nbawc9MMPK1O/bIlZvS5VgQb1WljFVVhwVr8aMeZvup749XFdaKzVIJ6ix56QorOf6uJX/kDn9Y/5Wz9VoiGdjIzGykaVMddyOFjeBTNCZXJlfzwszF7cd0TT1rkMtz6XzOqkGnLoxbBcbFW1WOQIT5gg8Ag2Htd9UKAqpUlWlGTqA32YnSQJtVo3ifqEdtcseLvtoBrz1CwkzUv5B+xHrWBAZYM0sDisTJVlTEkOE8evCQ8WrYsJdoYwr910xzKiKnBFWWRuRAfC51aRfP1DRe8snGuYkilTztabtYuHGe5q+8WtA6ucA6lp8LeFPt7LLwiAMl3ZwQ/jKrwsynHufC96Uob+rkn5YoHuzEe+WTVtF8SIutzixnObGVwGdcZpErkC3Fz3CAm4THFAom/3jsnhaQEjz88uMRUsnu5ZgKCNNQBmvh5Zv4pqNqZicoNV6ZjdsvKVv
 zKY/EEoB
 /QGHpib7S+NDf8HiOxx1T90XTJBdob9wvSlwpXD89x220qW8MvuAx+CsoNm7Y2ANEyQE06Ld63QzKQtE7/E4L8ys4nd6nAJDM4nMbOFV811LbFXUs0Qzm1mKyE+HHCagZ7axMLr91y0s0k8aetBMc7RxZLWgBchBUqR0FjTbwfm4/81oGw6debG6INmjzd6o2hcUJbzJn4UQcmJa/UxZnHWwtZiKSidXeYU/GHB13K7/yP37CV7kFwTXEDkVmJE9APyfdmBj2xdNXI4/KpzRu0UCOKtUOSCMX0deTWB/6pTtWYHqWaYz2vT+LFqOe3CYp6QO1GniGgn/OvzT9utmXhD62srs2cmBrbOhPQmahFoRD6cIs1ZOBH+JgfynAdo4ry8/aAxp4/l31WcSOaH5bsXKaLgS16TpSYclVYzG8HJ/kDaRPJCuASA2JVxOT0OgY4NEdTSuHZDtCRNA6c/Z6qHUBfxTSnh7aOdTmkt+Yhn1MZ6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 02:40:35PM +0000, sashiko-bot@kernel.org wrote:
> - [High] mm: memcontrol: missing CSS_TASK_ITER_WITH_DEAD in mem_cgroup_scan_tasks()

css_task_iter_advance() drops PF_EXITING tasks with !signal->live before
it looks at CSS_TASK_ITER_PROCS, so the current code doesn't see such a
victim either.  The patch keeps that.  The changelog's "until it is
gone" should read "while signal->live is non-zero"; I'll fix it if there
is a v3.

> - [Medium] mm: memcontrol: mem_cgroup_scan_skip() exposes left-behind exiting threads

That needs every remaining thread to be past exit_signals() while
signal->live is still non-zero; once it drops to zero the iterator hides
the left-behind thread too.  Without the patch, the left-behind leader
exposes the moved process to the source memcg's scans until then.

Thanks,
Zhan Xusheng

