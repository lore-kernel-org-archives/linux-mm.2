Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC16710D14A6
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2C36B009D; Mon, 30 Mar 2026 07:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA406B009E; Mon, 30 Mar 2026 07:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0536B009F; Mon, 30 Mar 2026 07:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBD876B009D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 883E6140682
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:19 +0000 (UTC)
X-FDA: 84602546238.06.7FCABE7
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id A746040002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WNTBjzs0;
	spf=pass (imf04.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871057; a=rsa-sha256;
	cv=none;
	b=cHNgrR7kiwRhVc/l40hsSxLEs+oOPdI9lTpkvgO7612hhzpFeP3drj8hcicN5Jm7tfRwaT
	eaahlYCbJmzBTn8ksk513Or+/9tYkb0hLyEYz9+i+5nR26BClJK+JhSkd6svGofoHLffll
	YHRcjBDTPLm+5SvFwMvNDRfQUMR1dOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+Q88Kl0GUitZCzEyHgGQvEVgC1GtxxYgxFmpIs5N6Y=;
	b=K9nipTfn0I76aXZbXTpL/Nkh/cgXSwdk60Hzq77qBKMH/3AdFUSLgfqiuAiD12zNGjhdfZ
	zS4ke20z3x47BF4zYtM8y+QeMkWxVXB/xku4hN2VxByOVdNboexq75gK9BMu+2K5nIw1a4
	dRUQUOkyUy6/SvqXZ79D8jhxsV6DPfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WNTBjzs0;
	spf=pass (imf04.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-126ea4e9694so676095c88.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871056; x=1775475856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+Q88Kl0GUitZCzEyHgGQvEVgC1GtxxYgxFmpIs5N6Y=;
        b=WNTBjzs0Mcqzh6VDkuQClCNdkpoWKT4OprfkEAJ1eUe2zKLVwUaS6XtbR58qKY8uJ6
         xj51pNNoh+6MNSGFcsqvKG6FIm5vYpxrXYUg2Mxq4JfrPahNT15Ar44VsEQ2IKLHhmeI
         k2s9B+eLhsDyktwMCjLCDS1dGHz1AIvMfb9uUoCpBoYSs0e+UeqwqtcilAWn1NPekt7Q
         xNG5w04J8SPOMIyAxjneW3nmvtFrXyImSUsfXXN4hxBNXF26mMH6KDlK2nRva6LZch6S
         c7S+73/luIupxEzGe8zT58grhGGm3BRs5fuFrCQFlrn2xOS3GIRCEUdYF4sMLzHm4BCm
         U/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871056; x=1775475856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y+Q88Kl0GUitZCzEyHgGQvEVgC1GtxxYgxFmpIs5N6Y=;
        b=NiA8QS6nONZ3pZPdCy93mN9OOopmLK/lSt8R2u/tzoRct1ORqF/bqDbPVvGX1BQFcY
         5NMflnLcGRZ07xiSSqpuofiJ96ieU1ye7dScz79KDPiMIvuR5bdSUDRvU48aoCJNL+Og
         BjrQMzt9wHUZVqUIK9i13UpXkPcvBZ/1uWKqqtHz4z9QEIrO8Mld1oQZXfiEaQdW71Qh
         Z+lrVv+IsQx6v/GIGYlvj0YuAdnpnW80Zn9uTkw7cstpPQceBRFDzPy8ueKhqP+zM+6g
         +iIN4p2Bhct0J1Y0W9JH0aIucs9Ts2SP1QI6HVUvjjTKbEWyixs82DeB0PAS+v7fY8BD
         3Cpw==
X-Forwarded-Encrypted: i=1; AJvYcCXiRKUNoR0R+91fGB3StXMMCRysxUqWxxQx4dmMHFT5y8NwHogjj6X7S2pGnY+YuH9yUxF3BGdx/A==@kvack.org
X-Gm-Message-State: AOJu0Yz3lBbV8+5kNkWCExgRQ7+6xZ4hkmyRAYXNZy5hQbNVoLNNhHOv
	YTN3jBSWcwspKVvAat3WdUjV4lxP14C1ktsuAPAJGpEfnb74YXZJAbt/
X-Gm-Gg: ATEYQzzFbR1FTH7xMn4PWPkRxm/9NwgSp2Y6tLY4o8UZHxa2cTgyo+c5YRhXMmzDGqp
	xYg98YTGrdXwvnt2Nzd1TxOWc9/llBOJiKGnfbefnIIWhvfdeKKT0kxsw4I/XbwsaSRudzeHrFu
	kg+Aqny3/AzxS43fojYdQygwZZ3J7f3Er5tBGwCGH9vEI36pbhM/Q6ZLe4cf2mrBJtwjke/QUWD
	uDtp1vznN1BMFm3tYRkpiUwFiWbptumGUYw7KlZhVQBKtZ/cPQ6E7rojoCQ/U/k3HtGCFj4NHGh
	soCTK0ERJP9CvlQ8j4NJO1Ap4XwRk+LS25cVdFAKK4NNH6+QLxQkVekUGWeLaBXaMTOf2FH4epT
	BROazfojsaX6RATxUvt4HMADWzZrXtMDutnGNCzuQYwM35yQIPHSnlo2Qi2y5hq0dmXxWrkRfLL
	8uDAIfZf2qnI/mzL1dlFqvq2HVIqXJ1qT8l4U=
X-Received: by 2002:a05:7022:f005:b0:128:cf5c:5362 with SMTP id a92af1059eb24-12ab2884d8fmr7157614c88.12.1774871056408;
        Mon, 30 Mar 2026 04:44:16 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97ca83bsm7083511c88.2.2026.03.30.04.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:44:16 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 01/15] sched/isolation: Support dynamic allocation for housekeeping masks
Date: Mon, 30 Mar 2026 19:43:21 +0800
Message-ID: <20260330114348.102265-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325135707.GZ3738786@noisy.programming.kicks-ass.net>
References: <20260325135707.GZ3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A746040002
X-Stat-Signature: 4m4x94e9zzcbyywhwsxcje4bgtayb89p
X-HE-Tag: 1774871057-734595
X-HE-Meta: U2FsdGVkX1+4L272DNmn578MvrY/zNhLjd95jUWPgmeDf1us7/5NPgHNsUJhRAwrT/7orSSdKFfLb0cpfzpyv2U0TCzo8gtc7Yad6KNWJIA5h+0DfZyG4cNQHGflP0EfhUkGObq87FZmhkxoAoAJ3Eh9hcu3V640CRJEYyoYH1osVQTiWOcob/ttezKzJJCaVZOpIk7yryuSIpbs4wZS37XZZBfAWJjaON7Qb81r72PLbWudEIMLaH8aPH33GDgN2nQJVQtJDBCyxod+RQj73oK5E06UIfsyHyQ3T3t16XPmk0uUj2aR5C7kT9MS9glG3ecqsf1z//LxqrtDjojc4EGgsy2uYn3AlSRPhV/gU94PBGuX7NiVodu8Vmq5XnSnSwxswhr9cnrwPOkVuP3wV2inu1SEPO4gIphzU4J2RKhfjAcDeLNS+3eShbLqib5auqV5xm5spEZ3vNGzmWYYH9qwlObCLrrehwFBTjZVF5IrDI4hH2hpbaumX44yDLUhBFByQ9g6FpKlHQHciEDt5+AgbYjh3QCaOTOaB/onlP40Bv+Q7+OXVyRBY6EVd6fEZ7INlCJIrcdZJKp9wOX0qNuPab96YIQgQa8QiId+nFRKiVIWv8QiBglJ3eKFPFOjYMtCY+FkwYA3/qPL5nnf/gvb7fpD7xaeymS0VdwxGNIEOwnvgORyZMG1msFnuX8/cyKLOCVEvAA8YULPoNKaGhekc2cBKthK2r1i/bobphLcBXKsNXlSX9+dztaVnzFCWEctNgOdaezcToI6KdpxuAd8mMHXPJdbUg56USogKDU7gLSBf5Zr32Z2cVb8pm8iqbngh6eQcH66BGhIIy9yLj01fteA3NEo2d6RxqO9tTT7v/V/ED7UG4McvMeLM0i95GeOXKjGH4IuEfRNs77jk9hBM8PFjoiNoVxpXaLi0xFJ5j2lcbWjUVtcNttyhzpLlQMWsf4R51NYrdkV68k
 TsW9tO1y
 AlcK2WPLDkytrP1kiqufMNu1b2ZM7IfU/TVHl0/cSz4yNL6wqKm7pmLiKFE/9iOTmbREyuynK8crJ1J9P9UO2BL0yfTD2JnISKjIO52RAmV7SA8JPpY0rybHG/7KwqOvJfJdVpzg6MJmHwVMA43zUo59y9y0lZmppu0/ghGqgs+rD48zIWqmRct26V/blwY2XMifHFnPbfL7aq0qgVg970VH0xwkyL9R3hdBxWA/nbBIYTsBr2gwKx/VosnvOIgbzO4MdyPKzMVBhYHNq2GbBxoFipIp8UvDm/6SE6SjYIxPhQLTO2GXiaaS1vxaGa0Iz8KISjQKObQecMy6M1lbpINi+yOVi/n1MQWPpr6BNFQsaWN+T5VH4dqFXQ50AIXUzDxWnEhEAz7+Hfks9tZKBlt9cnYl3TsBHYBe+lNvC6Rm/lgdcPuP0Wc9zhE0/c82j9rZTTn5sRWneuwX4pa7LY0a3vGLtyThEc3rk67fn4NGE6mFjKrTxM7zHAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On Wed, Mar 25, 2026 at 02:57:07PM +0100, Peter Zijlstra wrote:
> I think I asked this a while ago; why do we have more than one mask? 
> What is the actual purpose of being able to separate RCU from Timers?

That's a fair point. For the vast majority of use cases (like NOHZ_FULL), 
these masks are indeed identical and should be updated as a single unit. 

The original motivation for separation was to allow extreme fine-tuning in 
HFT environments—for example, offloading RCU callbacks to keep a core 
mostly clean but allowing pinned timers for specific localized 
telemetry/monitoring. 

However, I acknowledge this adds significant complexity. In V13, I will 
unify these into a single "Global Housekeeping Mask" by default to 
simplify the configuration space, while keeping the underlying notifier 
infrastructure flexible enough for future specialized needs.

