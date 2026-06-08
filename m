Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C59ACD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8AE6B0005; Mon,  8 Jun 2026 12:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A99F6B0088; Mon,  8 Jun 2026 12:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498176B008A; Mon,  8 Jun 2026 12:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 359546B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:48:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCC80C0A9A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:48:19 +0000 (UTC)
X-FDA: 84857328318.12.7CBFAC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D1581C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:48:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNFl4nbi;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780937298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+1aT7JV1mm9b1js3VgiqFC8zPbQnRMTHWbScZDq/ik=;
	b=gVez55GWCVlLfMtzgHx4n7o+ajv4ZYbbswXfDIrqt326FqcT+xZ3mHOo20GCQwNbfGRKjO
	kXjnJjVANOQNXFssIXiQ8tanN94aJEmRvt7OJDUsrMeDYZ3Q5f+PRaGOpieE9cM8+f/AAz
	JDoSSPQWgsM2JGWudlM9afaoZDQJx2A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNFl4nbi;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780937298;
	b=P4TSBJNn6kVPzbx+ew1sToK/AjHOuGGKWMYzic3GhrstjPinfZHkuY0hTJaJ9C4jk9ajjI
	n3jyy6vV8meJtfyj0nC67NteWAZ/7MWbn43N07ik5+/7DWOOyPX0gkxZ1lmy5IAFAWa4q3
	EzC4SzRi5Pc9lNgtf+4P5SJ3jzHCaxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EC0960098
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CE11F00899
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780937297;
	bh=r+1aT7JV1mm9b1js3VgiqFC8zPbQnRMTHWbScZDq/ik=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gNFl4nbioyUbS6BJnQJHKF5QVe2+IOnv4urftYscKD/Ynp8ZqY+uyzuPjUQcBPikZ
	 UmBbJ4vXk/1Q6RysVfuW7H+mMIjRUShk8S7S+xrtGBiW6SMTHxD79GA4+jbCkJaGQM
	 HYlRe5jCiCDwhqLMKIeEixgrKlU4tE71VyGMan6XOl/kFmuY8w1WN4f+mK0pDQo/Wa
	 uzpPvpmdz6bBzz0ZPESbXzEO8zxV8fpiqTA6bYOtZsSjcQ+zppsLY0D+Fg2dNUBhky
	 esSDPU3/X4JBUSzLW3ux34eejv4w6lkczMheMMOx4F/2PXILOXa0v5e0+7Yo4zgJYm
	 pAt5j/yDoQbuw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-68c19f1f3ceso7080362a12.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:48:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ83PNCHDq0eIXreXch1MWXY2kiAx7yNmkzZ2aRfJdmmvHwTYYWV/F04z0zauavzL+TYy0uO+vsYyw==@kvack.org
X-Gm-Message-State: AOJu0YzAqBADEIKg469Y4e4NtUVo0QD+eECXDHmrymYz5Ek5um4iknVb
	ejf8qCHAiih4IimTHy5yAdeznP2uBd18mRntgGlCG8euhWXWPUHm1ql9vnKe+rvwXTJjPRQRdQV
	etKeog/ZdkM1uPdKFZXWOW5E/PffUl14=
X-Received: by 2002:a17:907:c247:b0:bed:6e53:bb16 with SMTP id
 a640c23a62f3a-bf3743e5c7dmr827142166b.43.1780937296187; Mon, 08 Jun 2026
 09:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com> <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
In-Reply-To: <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 09:48:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
X-Gm-Features: AVVi8CeeTbVJuFLU_KkBwyY-XLqJGYP-jt-HrmqRJi6DEDHgaMpdFvhUoRLKrPE
Message-ID: <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0D1581C0008
X-Stat-Signature: em6t9398tzmfij11xaqg34pu56f49qe7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780937297-285622
X-HE-Meta: U2FsdGVkX189XU03XA4m4ZLx7dcGpvHi1zljbyKzF/Wk6XqJxqb31x/BqRPlxTG8JaOo0I2XEKKkOeI3FoLHDj5UtJXIt9as6DXV0yH1eNxTJjJgOU3MK48+kIezfinKsDkY8xGEgwe2QZwtUsMP+MDZ640DvKWN8c451N1Age/noQV9LK9eivfepUS+lLZckQbOQ4LXwz/THZwwL2Ktn0hWOQD9MwqVCEeh9LcZXzkoBmftgB77DcOHAbdMbV3lUvSLReLsXxWp/gQiUQKTh1YE422LCsUJggba1Lkd0k/JTa56kK6Yi+4+Pog5Ycn67M4JEYV41GS41VPqkLUNQbStCHSMnzINnGZcl+2ELc1EXEcD/UQ5ZopeqZJqxJ9fylJM3AhH+GfbY0gtmr9OPukZMOC5XvD6fQAinWjOM/EPHk6JcuMShLTtz0D2UZA85Oc8uICRHh3BhiIMvSQJo79P4nf4OZvCZ00flhZpsVSlhqW2BFjNvrj5jLyjdnVKQSegO3lsT1Hyn4f8B8aJ9/AcHMqqvCy/vazeeX9rbogJ8ZOA8TWDk1KkWjsVpGTzZVA5YCu06qMm5woT8H+ubGyGjKZ4BopLfYKzyvrMtlgfbyBQySDEY9mA2z8Mm0mWCetToq/g8qsxbcBnZpm5d8ATIG/pwHvuoXqsAnjSf55T87HWTsTIfdu4K3uSEsJNAsUuzoGtIMPvrQGzXU6R6SIFqCTcm70Vgt+tJNuaLun2o2cKXJLsIsSF6yt1U3dqbLzMnug9GHoE4LUbmlumTBq9brEEF/bgEQ6Zlnffeay+gxEb7EeoEOK6F3jyo141RrNIqcdfxcePwLuvPACiJy3m5h5yRHuj9FcED4dp7xB3+sqalNDSPXau+rGsUxo9d1vA+bJpPcUKIs2mkoLSW8C6uM73QOYtpuNjhAXQbven13e+25P6Z5tiDqXpKj8jTXpaM9cip2BUAbMHyif
 HOl0k7DE
 Lk6gQ/rCgmDEj4xnd7Lo1uQg2dswBmVpSPgiDisyQL4D8NVlvmmpqUlwG0DlN3c/chzLTQWJlRu2mZMAbxU57xSFcrdsMIIIITt+o6SKj+m2EVk1zaktj8FB+JeO4Rg2fkj/K/L/htFX5+PKgNmo2hxQMmJ5fjduI0NXzuW7dufiJS7jRAp2fpafo3RiZm25mJGOO/cG3VmWBgZQYbAqYc0BDxfeH9fL9f96YYjrFJAyk6grEhXWy4rVhhaRLh13LW2qRjrJPvbCrQvLAg84fDSr2zDdPw0L+57lHkEFWaQTOyOFECSSpQH8lTE6kRcIslCFm8Ap9q1UGjbCE0ZhaC6Zk3NMnJyqhga+v/mfai34UaBWA450fbsLMa0cg80ULJM7Iv3R/H4yLIKq5mFFLE0ERfHP3cGHvIV8h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> But OTOH, this does seem like a recipe for inefficient reclaim. We
> might exhaust hotter memory of a cgroup while sparing colder memory of
> another cgroup... But maybe if they're all cold anyway, then who
> cares, and eventually you'll get to the cold stuff of other child?

Forgot to respond to this part, the unfairness is limited to the batch
size per-invocation, so it should be fine as long as you don't divide
the amount over 100 iterations for some reason. Also yes, all memory
in zswap is cold, the relative coldness is not that important (e.g.
compared to relative coldness during reclaim).

