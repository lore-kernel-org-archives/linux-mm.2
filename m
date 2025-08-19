Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082CDCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2D96B00EF; Tue, 19 Aug 2025 06:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA4D6B00F1; Tue, 19 Aug 2025 06:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7786B00F3; Tue, 19 Aug 2025 06:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8566B00EF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:49:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30300B82BB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:49:31 +0000 (UTC)
X-FDA: 83793185742.17.9878584
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35C23A0012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:49:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dzeKBYoU;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755600569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kw0AigTamlrq/x9wS+Jeg8FeZZrKAMN0R69vqKKk/+0=;
	b=eI+U7Fmt1KFduCVGxEuJCPx+CjjRAmxDhBI9vOecxGygfSJwPuY55v3/b0Y5fwSogRZESo
	+NqTnSDjOI+qY0Tw/KqsdvVNPve4k676lN5OYLg4zvFlpsX/NdOog18fs/qyOcNo/qu81+
	K36WejUNKqE9SCtFeFX3EbBxldKspjs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dzeKBYoU;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755600569; a=rsa-sha256;
	cv=none;
	b=JRo5rlE3QrHNea5DmaAdGxqipSInZmFjzqNN7wA60EthH4zrKatvg3dFCelXSzP5B8rmFs
	njNp9fJjBsF7a/fvei4V6B7IkyrgNzsIbuI4qIdVP6L2a1RsrbXBTTbFAwsZAhsdI4e/R1
	SHgV8RhvyxGl7YXqmxE9uaDXJ30tyzE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b004954so37834785e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755600568; x=1756205368; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kw0AigTamlrq/x9wS+Jeg8FeZZrKAMN0R69vqKKk/+0=;
        b=dzeKBYoU9yvfkxSR3ffJlOJldk092EnTka4IamN1I6ZR1K4BbJuhzyIa8XVYxmE0E7
         VY3+Z7y119PbhD2Zm+kC9dHemhOPVZ5klARtJldVaDjCEE8z/SwZuy0nYjbZ2P+ga+JA
         h48f1jOOn70+GRetPShsR5GzD5BRswe3IhJgBk5konxVZQSRvfrcKo8HrJyG94lL24FS
         a74vwSITdPWAQI0gyWFinyzbTzQMIOtiLP0SyEEnh7N484K9tPUVdQkOFAf938xfbN70
         z7BEioJcwc70L8FnGk8lOvapk145Hu/jxJPBveZXo7fisgo8aQblCBNOnUKxnwcHnZU4
         kN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755600568; x=1756205368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kw0AigTamlrq/x9wS+Jeg8FeZZrKAMN0R69vqKKk/+0=;
        b=EGqYBW298WrC0ztT0G5Wj8OWZPAMfqMHPaa+MPqVFfV8wLdnf2dmq7j/i1uSeLQCBM
         KGB8/GV2bJHvtS+LUkmOD+B36asc8ogk7H1ugahaGauB3fWVOy/csuegGUAI1ku+H6b6
         KHwmjgPmnN0awko/bJZRJ+bH9kS1pc3m3xkdkBZO1VPDfN/Q+26d4g8SHyKnLBGYqOCB
         ooipTWiDzGUB1lli6DaV0jt58q+arht+gjj3Q8bIRC9SZ9b8GF7Y6XpgbR3glLULykyk
         tq681lAQqegI5q0ScVUXAS0PCdpSyKMa/n0FjSNSYcmr12iSOdyqKbhuhhknwmBrTHPC
         wANg==
X-Forwarded-Encrypted: i=1; AJvYcCUIPhy7z2YWHtHDhNkYeYj8/wWfQYwpBsWqpi+Om8aKg6Fv77cZftQUNDY3fD4WNQZ+TPltzefjXA==@kvack.org
X-Gm-Message-State: AOJu0Yx5MjluKT+vlb7BZWKGwhjzD3bP8iK8QDkm/BYYLA4VoFznMIsL
	WHAqes8J1MfEtFWtrWiZ3IBNgp0VaUK+suEfXAUQM5jXbbFMvF79ux5z4xD8RDV5AMI=
X-Gm-Gg: ASbGncu3AyeR7nibDG+pgkAeNzto/opu5bIEtMv0PtJrxW/sct8Z0aS3ONQnLEBvdW/
	nUcTStee5wQC5PcJLiX3c0IJtTuDhzS6BiusYgfvabPv3CjfNboabDKSMOVapfnow8b3ogIWt+3
	ZPiXSDBAORvPxlmNgTzVQh9yFGJzaj2dO2dQ2hJc+u6aIl5QC7fApJubH+xLb/+lup2koshqkWQ
	SoPDzP7qvgqbNWPhtpi19IsUqaXIqFWLY+BoTnVfRkHgpqd2CW52HS5h0s5qEhLszsJSFUkkv8U
	/JKoGQrz/u279bcXSrXM709n2JFnFckb528TLBD75yVnCGhQTVTFrIKvDnyfpJA8vZy/XDcnA+t
	YEQtx+kYIL4y1rkAOkK6DiikZY16lu8xifqnFAZbx4Yv06A==
X-Google-Smtp-Source: AGHT+IFEJAOMpK3HNFJFB1w6V8jRKSHtdv/ffV+gbTyLvIoryN2RHZyfIsrWRIVB58VwFaamjUbVjQ==
X-Received: by 2002:a05:600c:3b91:b0:459:d709:e5d4 with SMTP id 5b1f17b1804b1-45b4425ed17mr18178075e9.0.1755600567490;
        Tue, 19 Aug 2025 03:49:27 -0700 (PDT)
Received: from localhost (109-81-28-101.rct.o2.cz. [109.81.28.101])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07496f432sm3197891f8f.6.2025.08.19.03.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 03:49:27 -0700 (PDT)
Date: Tue, 19 Aug 2025 12:49:26 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, andrealmeid@igalia.com, dave@stgolabs.net,
	dvhart@infradead.org, feng.han@honor.com, liam.howlett@oracle.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liulu.liu@honor.com, mingo@redhat.com, npache@redhat.com,
	peterz@infradead.org, rientjes@google.com, shakeel.butt@linux.dev,
	tglx@linutronix.de
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <aKRWtjRhE_HgFlp2@tiehlicka>
References: <aKIvd4ZCdWUEpBT_@tiehlicka>
 <20250818120819.26709-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818120819.26709-1-zhongjinji@honor.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35C23A0012
X-Stat-Signature: cbi3wkcsyamiyf5pchcct6zg1k7weyj3
X-Rspam-User: 
X-HE-Tag: 1755600568-209100
X-HE-Meta: U2FsdGVkX190dhGKSZ5ZkGho46kZn+YvJHg/7vzR75/0uavs32Av5OEBKxBAg/KaJy85FQdTc14F0pI1CCj0mUKjqImJUkHW9cQmMFVTYZly7Y991Ugzc8lGg76FmVsdAEwfba71GHCNyC5C1ReRKUeq3cd6LohU787B7r68a7AcAnMF2YUn0mzYXUf1QHMRkML5/Be1ZhpnIJ3f4I/eVWPvxX7nShLGFvY0LbOADNvSQfNwyO1UV1rnQ6pabnOOlogCyutC9+918kSzkpduKzdnGiFgJnApPI0OQJVUNaNFM9pjZRTn7uLmJwAnForxMx7S1zk9TuwUHZ1IVNG0YhiHmkVDmeVCNvZNQR6ZK2EtUrlXVAunGc/W9/KO+uF9SBNk3bG7OpeunyZOfk6Y7indm061WWvojeVSYdKGlN9Q4X0S9JYYwZDcOWivHevRh87RLtHCNb7l8wQnJbDMofVFggEF5HkbLrVX7Iz9nn6JfhHFFgVGnKXwg7ClSB7/gDVtf0y9Pd1uZfVvIrYSs7C34Hw/m2hQW6XLwJCeMQ3tUCDdg8+56aMzUhiBfU9g1/6s2+3QT0mYL5/XzhNvAqLSby9U9d1ohLaaScPqwzrStgqeTkxl55LVW3ETKRK9Km2KU8SWWu6WbNROBl5tp1uR+DT9JgZHQGd62Au0xNRABFzpW/Ue6Yj98EnSsVpWZif+sDJ98MR9n+Se/9x9gqJ45zZu4uRPuCzm8GsFSAPN2xRJt49x4hEWRktEVrewOhkkeM0XYPMJut9mkNwWjT5CSaNQc6lC64Tfot5Pub+U8wMQUUoMQ5qi59RysTQ9UGVAXFItEHZ+a0q7J7qbP7wDf0Lx8OgBhSPxcKP4r/ZCR0HBz0Wh/U3gux253woO/7qGaC/13t7W1Dj2YriDRkJdz5J+wCnQ54gxhDHBblTpJUs6eTWCppHRgfo6wradz3zPGbdcMgEYgMPb+I2
 n34EC6q3
 B2Bcw2Kcnrt3KsfQrSLsG8toQq+VHnbaaFrkZz5Sqw7WgiW/VTq4yLMYuGxXWRMspL15F/6qpaGs1WJZZJSb3iiEtNlffYVmYeAL07hV1Ok3oDDtQjUSkCjp9YhHAuKpdyAlS1wpcPwMI2vPV5nM3Jy0EIBqxHaPVgEehCBcpNqfyMe9pQe1A0rHSNpIqXUM43/WsJdglRT+qrpeh0tmYgbMbvdfFB13eGdw/eeMIa8B+0wW6VnVdGLneMUadL8sBCURtcVkVNuXUoq64UqvZaio+6lg6JriiRxquPgiVQHoHvpKDXenfffzym/0PwsJ3ShXUAvsHc1bozrZB0fLK6sxSflx+iD/JgqtiOJkiWglDIysh5z48QqRCfhSFd2iuoPBwv7qBCOQezk0oStPnGkNwB8/nGR6yDRKL9FFE3pK6wTMM3mH05jGvlMjDV0puZn7WxAw1TGWCiLtuLcVSJ9fCHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 18-08-25 20:08:19, zhongjinji wrote:
> > On Thu 14-08-25 21:55:54, zhongjinji@honor.com wrote:
> > > From: zhongjinji <zhongjinji@honor.com>
> > > 
> > > The OOM reaper can quickly reap a process's memory when the system encounters
> > > OOM, helping the system recover. Without the OOM reaper, if a process frozen
> > > by cgroup v1 is OOM killed, the victims' memory cannot be freed, and the
> > > system stays in a poor state. Even if the process is not frozen by cgroup v1,
> > > reaping victims' memory is still meaningful, because having one more process
> > > working speeds up memory release.
> > > 
> > > When processes holding robust futexes are OOM killed but waiters on those
> > > futexes remain alive, the robust futexes might be reaped before
> > > futex_cleanup() runs. It would cause the waiters to block indefinitely.
> > > To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
> > > The OOM reaper now rarely runs since many killed processes exit within 2
> > > seconds.
> > > 
> > > Because robust futex users are few, it is unreasonable to delay OOM reap for
> > > all victims. For processes that do not hold robust futexes, the OOM reaper
> > > should not be delayed and for processes holding robust futexes, the OOM
> > > reaper must still be delayed to prevent the waiters to block indefinitely [1].
> > > 
> > > Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]
> > 
> > What has happened to
> > https://lore.kernel.org/all/aJGiHyTXS_BqxoK2@tiehlicka/T/#u ?
> 
> If a process holding robust futexes gets frozen, robust futexes might be reaped before
> futex_cleanup() runs when an OOM occurs. I am not sure if this will actually happen.

Yes, and 2s delay will never rule that out. Especially for frozen tasks
which could be frozen undefinitely. That is not the point I have tried
to make. I was suggesting not treating futex specially because no matter
what we do this will always be racy and a hack to reduce the risk. We
simply cannot deal with that case more gracefully without a major
surgery to the futex implementation which is not desirable for this
specific reason.

So instead to checking for futex which Thomas was not happy about too
let's just reap _frozen_/_freezing_ tasks right away as that makes at
least some sense and it also handles your primary problem AFAIU.

> > Generally speaking it would be great to provide a link to previous
> > versions of the patchset. I do not see v3 in my inbox (which is quite
> > messy ATM so I might have easily missed it).
> 
> This is version v3, where I mainly fixed the error in the Subject prefix,
> changing it from futex to mm/oom_kill.
> 
> https://lore.kernel.org/all/20250804030341.18619-1-zhongjinji@honor.com/
> https://lore.kernel.org/all/20250804030341.18619-2-zhongjinji@honor.com/

please always mention that in the cover letter.

Thanks.
-- 
Michal Hocko
SUSE Labs

