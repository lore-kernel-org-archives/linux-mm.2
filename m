Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E9EEE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527E16B0089; Fri,  6 Feb 2026 08:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D62D6B0098; Fri,  6 Feb 2026 08:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1D26B0099; Fri,  6 Feb 2026 08:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29BF56B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:40:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6BB9139064
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:40:30 +0000 (UTC)
X-FDA: 84414141420.03.2A43E1A
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6202100008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:40:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="SZs8A+/8";
	spf=pass (imf05.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.68 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770385229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=c6RP03fPs9VBCASY2WT450UV3Fh+vZb66DaShDBDiDw=;
	b=6wNJfiit+y/0U1uf/0LqpnDIeGoZ+LGn40+fHtZXSLSWRpe2lMTaYUJHi3zor4R9GXpv/V
	yNwefjXBR4bXNBrwCLh/dYvRo3NE3HM0HYTWy0pd5bLteD1KCpm+x+H3LtJIAiLP64+3Tq
	IEyLwLZ3PiCFd6TlDOhP4GKVezZdMQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="SZs8A+/8";
	spf=pass (imf05.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.68 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770385229; a=rsa-sha256;
	cv=none;
	b=E7IUKevwDAhtLFZAlLeahk/eoAQ/wo1QYI4+nCLcTCyREopIz5LMIaBCzW3cBGGQM60RI/
	B+fTdNT25tPnEgLJ6DshtRqr5jii5mhwPKQbitujNJ7Q83uK8Fmya6xVS382NhsSUI6XVm
	1c0QoPXIc7PEazJNzw8sGpOTrcsxV9U=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-48069a48629so19400805e9.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 05:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770385227; x=1770990027; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c6RP03fPs9VBCASY2WT450UV3Fh+vZb66DaShDBDiDw=;
        b=SZs8A+/8GwFBxqI4Ju7nzSddpJgzDXNWO0ybcJ2lX3jvklMvYJnAMLjYexzRhnUbuu
         v0FNsl4k+0WtdNfj9fvKmUYz+JEHOVJNgJ3i6x8DcFgGItc98zXg17lS4EV0nQCD/re5
         2JWJ0kB1gsgks+TZn+TwbOWqnYeMhXUawe19EoG3Y3uwjjtscj0j4ESD983p6HtbYbZo
         GTLiwg6HeP/tw7Fbxqej1a6vJ2trE5IBE3GSaq0Y5e2RhdKn23xzjl61a+03ei0CeJTc
         nB970Fw2xgDRUa/MIahl8H8u0dIV1YYcou7SL6IBIKR8A4wi9wEF3+3+xvoLf+IQwand
         vozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770385227; x=1770990027;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6RP03fPs9VBCASY2WT450UV3Fh+vZb66DaShDBDiDw=;
        b=U1hctnafBUPnT6OvKLA9gNMKiWLam87ImCgw8bKQnUXT5DkYmQZ2QWWvtwN4AoGI5w
         YKhxwP2PVCrAhL8ld4+FE8eOEAXxwnOM58rHy+VApRuRHftVVOMMfzySHr0gfcilBAvQ
         7LO7T5NzitoHd1pNnKVI9sX+Pf9Qw/p76LRxWOBHXCA26FZb7Fy9LsIdBvPonCqbkgoT
         pMo4HxKbGDcLPmY9eSKeNYzRC6WTn8e499nxucpCRntnC2qaiVFaEe1c2U0NZvm3m9VM
         pauaZvSkFoQApDzV7Tv+rgYaESwGr+sNN5201N3v7tbkeJvUhIR17q8zyyT6yZPJ1TA6
         1c3g==
X-Forwarded-Encrypted: i=1; AJvYcCWR9bUeJSSVACc8jcEKZJz6GEPKat8Cn4JT/JFUh/aN5Nl89DV9bOvGX6pAeZi8s3OYueEFI8D8UA==@kvack.org
X-Gm-Message-State: AOJu0YxxZtvpiUfnPg2skXwDA7Nwq6qwoU9win3BmsacgwxI2x7wp5PE
	J35Ljfqk+wD7vCZQqgQu2L6E+hl+Z+UyCB40qY8qDuxdBP940Bh2+LIL9nFs6W5Qpt8=
X-Gm-Gg: AZuq6aJymM3pKhUAHIjOSyCic7Sk8qJ0jb3OtZ5tYRcGvmJbCfLyj8sDHuiFV9bdm0A
	+nwOBnMtgXxT7GXK7v1mCNYbfr4SHA9Y5jzvOC61yqy9GrvB8ir2hjF92wGr6x2IrlRQ1uQMFG0
	vTqTgLpB3i3QH1GnHuUYiwxTJ6df35qCvNEyK1sHz+GhNkOv5LdGkuJWaqRKPSSyeLTgfWMM+pA
	LtXzIMr4zk+PWNfWuTC3EXDwIcjsv/wbOC6YOeyP3ccXP6Vout0dvd85yswsPuSxVcT9QMpIED/
	fO7p5eWaa0PKf4vCbGbzL2MkdlaIzT3eCBPK9PNF0yk0iERqwycCzmuu2qkkNDxG2HcjvGQvlrI
	Nk4yRSof+6lpB7UcHhUQ2SfXYC1b4vdzAOU5crjMTR4sixRGGQBLYoJ//EA5D/wrSugZpllqAiY
	zTB9zoE92uYyQxTE/2
X-Received: by 2002:a05:600c:34c7:b0:477:b0b9:3129 with SMTP id 5b1f17b1804b1-483201dc3ebmr40796345e9.3.1770385227046;
        Fri, 06 Feb 2026 05:40:27 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483206b8d9asm44916885e9.2.2026.02.06.05.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:40:26 -0800 (PST)
Date: Fri, 6 Feb 2026 16:40:23 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [bug report] io_uring: add task fork hook
Message-ID: <aYXvR4WQ0LEYxMPK@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa37f28-a2e8-4e0a-a9ce-a365ce805e4b@stanley.mountain>
X-Stat-Signature: sqfbh5tyxxa9cr4mmwct63ucfpwz5wx9
X-Rspamd-Queue-Id: C6202100008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770385228-634129
X-HE-Meta: U2FsdGVkX1+gkVlmkDFaQLleERTK6Mf3Kfb8EMM4myij7N0Dtn9dELDj0xPj0N5DI1F6cIk6Du3r633If05mnni8u3c64RineX3lwkdKglhtvEUG/7BcmdKkMRCZitikD6liiyDnPy3hkbavenEiRNXsls4A2m0CGp87cGiW5tiknB+Ha3BrjEwusGJwzs2o7T3l46EkhwWpQhebHEN6BMoD052ZRlYt7E9rENIMFgLuF6GjbzTKjQziyJdHuuEHzSl22uLUx7icTS2U/axo7YyKziQN4C/zq/QFBz2+Iy5d0M8EgPLkYpGM7l30K0T5a1vCwB3Ft9l/XJQkAGvoc2z7vlBnz0Cxb+OvS5RmmBGHowkqG4yCnoozllxHWCTv72haB0z0znmUFo/PpiU/1RZ8vuTBcVsOVX61kCvFYAiikS9wAv0D0reGsSFef0E8Jx9LubO23CSjFCP8QJFSTVdTgFizDuIi82Dl+6dyrMEL0xHnTXcUfSUARLKY+zMChqpur1wDvhWHp9zfI0Z8ocqzPz9cpS2jyGWvqiQNecmOgin8S5x806vyu42X/oTpZycb/OB4SuFmSXkAcqFLHJ/cKQlEFRa9EPB6/cdi5z2LmNN2rWXsBEgj028GzRC8lKH122zEmoO6dDAhUl0kk/c0IVnBZmgPv87Vt+Bid2qih8aYMxid0c63C5e/Hll0IdgeBzsrIbVQBSX1fEeSK3+3npCjRCX5X4n0DX8wK8mQDb60hvO9vMZLXCcn8rXVbJt2Faq4EhGubvH5tu7Mmb7RkSrIQuNrHyxxJu/zwmLXkuMQiSaVhMl2rM0+voW4FWwuxqbdQi7Y1x089u7yHMXHmLtlwOdPZI7DUN7rHwpDOHql11LsNwbMoIAdKY/nbYgR+MxRJSVPZO8TRi20AyKjPvO/+DbswWz3xm6FV3jLnpG0BjbXbsywC3N+qijZA81kw722LycctoWhBgu
 L3sEbREI
 cPX1i7jXX/1ANnIYXIcS5AAMY6i/bKWasIgk++qYd8GXh6rsG2LjiurbBourSmk0BJ90GkErCuADpBT3WwT0ojhSHIHAfPToLyQI4vzlCVTuXn31xoHFRqdIQR/XX0Mgv9XlkbZ1V7QjuxummRqZthJEtg2JXOi6uOb2wLZrSE7FjlaZTwErC1QG2udtnrpeGFc3V9rHGLdgV9KQ6kkeE6Fe+V1AznaDxwaK+l4xM/p49eMjLzj+mR+mp5KGR8xpZh4QvHvLtDNQUdEcWwS0RKte3lNFA+jlUQqIoHtYZl3krr85sscqMxDW2j6ThJCo0xuBuBeqwFgZNszci9kuaXmMOREak48dHoFUG5bfZBSgqftRNp+4DR+k6kXpY1qCJSkzJUOY8HKWQ76YEE1l5DNpj3+sH/rTbj9IDvSgadcntPAng8wCX9EaRLUW+IKS1uR/XXWklMwPqhhYmW1lfvwDjzCqQ6BZqtdAf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Smatch checking is paused while we raise funding.  #SadFace
  https://lore.kernel.org/all/aTaiGSbWZ9DJaGo7@stanley.mountain/ -dan ]

Hello Jens Axboe,

Commit 4f08520591a2 ("io_uring: add task fork hook") from Jan 16,
2026 (linux-next), leads to the following Smatch static checker
warning:

	kernel/fork.c:2544 copy_process()
	warn: passing zero to 'ERR_PTR'

kernel/fork.c
  2128  #ifdef CONFIG_IO_URING
  2129          p->io_uring = NULL;
  2130          retval = io_uring_fork(p);

The patch added this assignment.

  2131          if (unlikely(retval))
  2132                  goto bad_fork_cleanup_delayacct;
  2133  #endif
  2134  
  2135          p->default_timer_slack_ns = current->timer_slack_ns;
  2136  
  2137  #ifdef CONFIG_PSI
  2138          p->psi_flags = 0;
  2139  #endif
  2140  
  2141          task_io_accounting_init(&p->ioac);
  2142          acct_clear_integrals(p);
  2143  
  2144          posix_cputimers_init(&p->posix_cputimers);
  2145          tick_dep_init_task(p);
  2146  
  2147          p->io_context = NULL;
  2148          audit_set_context(p, NULL);
  2149          cgroup_fork(p);
  2150          if (args->kthread) {
  2151                  if (!set_kthread_struct(p))
  2152                          goto bad_fork_cleanup_delayacct;

So now retval is success where previously it had been -EAGAIN

  2153          }

regards,
dan carpenter

