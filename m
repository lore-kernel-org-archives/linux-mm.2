Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA53C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 20:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DC56B007B; Mon, 10 Aug 2026 16:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7FB6B008A; Mon, 10 Aug 2026 16:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5B26B008C; Mon, 10 Aug 2026 16:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE456B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:02:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD06C140283
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:02:17 +0000 (UTC)
X-FDA: 85086431514.10.20C590E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id B0143A000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:02:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UyYs6JpM;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786392136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yh4/X5pvcL1g5XfmsNkooR/puMOXNnCQI2y0I6XlIQg=;
	b=k4RsZLlceGkVNRKRfBVMXcgY58qOLp2KIhW9VMSPmXVkPaUdAavb4m3hQBX9jA+uuhs4U+
	xN6pVdkdCo948+LQbhl0RplTQiUxYFbrhMSSo49MP4a2o8rYu4DGvFYtVDggoefddIHr5k
	RCHEA4zu/Y00eV5MmSF44+EuZMs1xjo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UyYs6JpM;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786392136;
	b=nk8vaf65btwKXiyIj9yROIvhgqQHhRC58kQDBB8pzSPrsJT2rerHwAoZ3zaBpUVErXerYz
	ecHVhszMqoowUv3uxyofdC5ESZpnifEZqsQt3vuQutnFBxWgq3MzEmztOq//+WklNO/Bqv
	55qrxxoew+cP/Ir7ZZdK+QF+eO6ZE+Y=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e53581361so104366585a.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786392134; x=1786996934; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yh4/X5pvcL1g5XfmsNkooR/puMOXNnCQI2y0I6XlIQg=;
        b=UyYs6JpMZ4M4kO0KFDWLeEfnKZID+IIHmmHVyTM6jDIkQTeJqK6m9Ol92Kc/T3brn5
         p19zFy5LfkWDqWE15JZnZXBMoWk6Enkz+JF2RWKuaQle2QwuA5Pq5v6DhsgK41YIqqQH
         2GtJMXRoaEvoctb5uMnH4ADYmGtQ84DKBEZ4G81GHV9LHVEkDc0yz8FK92VWHCNsuaLw
         YZxJ7CeEQm+mU5QvnOS/0t5NQleC8R0ljaHcoFU3MfoQIdCTgjCPe8Y+Co4lZG0tGVUU
         m0r1mmTYLdxN6lSwNHR4UshsSC49iKliZgqj9MOPTB6ByhXgJ8lS7dHNxFSwqujP7ldE
         aSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786392134; x=1786996934;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yh4/X5pvcL1g5XfmsNkooR/puMOXNnCQI2y0I6XlIQg=;
        b=FElANR6BHewqfmUN3c/RghyKiIGEubAwWlveKqrqdwH/Q9SI7/fEon+mlZi5J2PFJ5
         YGNG80Ev+FHjvSyEbkk2HkjFFgk1WWt7KBtW0JB7NLyPD7XcQQRk/Ya1rpuMiLQ2pZtj
         fAgUhQsMb6ENtWtZcNDBKepkje2S84+I5gr3wFrq39v4OFD0uBr203l7dSKg8tZ+Srqe
         jU0JJQrh4d8RGYdU11jthLkTiNx6wRvd5w/IICQRD8vDBpEDlkodFjGP9hEPlT+9PDaB
         aC7SRSp899ycjY5GsTJ0R2lvN9iqzczgodNL3O92kwGIYAHNIVBzU2R+cd7VhCqrdurX
         ebtA==
X-Forwarded-Encrypted: i=1; AHgh+RrBBnd7hK6eH6s0GVVRkPDrfdDFdnYbwB9IpymPfrBV2QX+ohbKPp4rxL/gk1OXFV42ZujnHRpzEw==@kvack.org
X-Gm-Message-State: AOJu0YzbtajmXiJCl8NbV9m9kZINrMahZzTaWi03KN/KWcbwpSwUOxjq
	mkabVxqXmYnt72kgY76DyGHMElO2k40G7cbWfodpDl8Q1+0+xIthPmxBpmu9fcQX7RQ=
X-Gm-Gg: AR+sD1150Ch2vr8feHT/W4wFzFLrb0wDBQ7597MYTLXfAB6ajBkT2DuPOi7v2Jqqwak
	Yoxpr66xmNZmjJwPx2dONDyc17PAFv5davwQJ2AEal06Do+PSC1tJuPNdNjKlPa7qBaq4/fbA3G
	l9bAeg7aG+PP2KjsHxvu+9rpVJ7qp60NYjJxjGXBclEpQa9GOBJNeLZzJh3XQfZ961jlw44ixVf
	ZyvDzzPbiBGHca0t1Qec3eeZ6QVDLy0f1hb+IseAAgpvM7ilmgsxT4FjxgOQ98Y7jlVMjgdCzqv
	uO3rlcsDF2+M5ZGP8s+mnHtXFKO3BL7llWTelUIK88BH6d/OUyWLvIMmvcqMZN9MnLjBXI0R8mH
	CKaZoI9Dw0GZ9w8fkvRRL96QeWTEexnqHvKYnU8a9arewrD5CxAU4bGStdKGTn1z3IXKGFy9D4z
	8iuURQcuYiXTBa7iUFxvfHqkVmeNh3pYL85CEbyQHTViQI0IIdX0rReuUFugg=
X-Received: by 2002:a05:620a:450c:b0:932:fd59:3e57 with SMTP id af79cd13be357-9369d240172mr474598485a.41.1786392134192;
        Mon, 10 Aug 2026 13:02:14 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e229787sm861811585a.22.2026.08.10.13.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 13:02:13 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:02:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	paulmck@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <anouQR89Q-pDAfyt@cmpxchg.org>
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: gwkg7dha9zji1ap8z8jcr3fupq3i1fs7
X-Rspamd-Queue-Id: B0143A000E
X-HE-Tag: 1786392135-626277
X-HE-Meta: U2FsdGVkX1/pC2HwH01XWudjfJ9wpP9w+0Dyxc7KTPZf5AQSTolw+mOx/y6sySOEiApXA+IJMHmL18P+zc6eEnDYydUs/vHNg6Wvx7qKp+w9byukQ8rsbs274vs0Ap5huF0uO+lrDs0zxzNXYb0GWTvhly9rZGQDJ3CuQhZ4ctRbBXn0Dxh+JlSYYBDLIjdIEQ3IX1Cnr3mHlCCZ2Nhahw2d++wUlNMjblScawLQzCmtMd5TFphmwdFnmM+7kDCLpeajAZFBpCfwdJn0dlhcroEBBvWB9o5eNlnCi64Y/jCu0NGxjRWMDrNFvVPqv/vQDiMm4ejz7567pF+5bD2y7CklW9vBck5VbQmwGoy6XnVvPevCVzokJIFZ4G8vxg3W70KVnZGygCpNFGWltJDFDSnlvSC4ptAQ6zcvi1mXkTVpMIPL9qI99yVRZUSVO7LsYvXj4wjF3A8SNm+utJXwsQ9q+SdRT1dqEFacG+4xLLXo3sQeeI5HIo5djqNbn9EE42dYPtlJ5inT0WkkncoVadFfSECnafNqPxanmAS/rXlqJT1NfKDZqPPefDRNIHdHU/SLm45W2AixSwEHslQos6rJ8s3tNzPavdVa01QPatEWbqpOKfczbkroidzW3p84yKJ0Vt0Zqzs4mO+o00pLF6mIll1QdKN8I6HdmwLR/uzLC67UAJ2ttxEIT1D9e4xU0zmbOa7oT3LekxPBVWVDHW6qamTak5mGfmiuaDPwNcRKdkFNej9ycXh4/saCaJjvyAYPy15YCNW5aoeripTkZDMYJ57Shbn2icqAXZNCqADcMLHhZPVOltbCgxvk5dtgBkpHS0nArwG2x5wy/LRnC1w/fqxOEhJdc9B9Wf0MPx+aHeIvxBD2CotHOST3CGeb/L8Ax+iVIoTnnhZa/mqscavbuaDMwukgFnub/pwkXlAoeHiBFqO4dUw9rmf4aZ5j146C2U9IaMIvOIt4HwZ
 gvKdq4tD
 tGOY7JufLZAN8LEAXASou469CPVyZh4K/2WblBmd64Lb4UhhJnK28MZoQJgj3Mfr42zCjpX+1cjdCKM2pj9/9rjNhd6aocUx8uLSE7B6iZpVbNx7HatdL8gi5eJZvQAq1Fl/tk6BBIxhZZV1pruyAoe50+wC+t3OD2/7MRRWlReWslr6dvnzm1tq9CtFEKsqK3HnsrUxF42fvfBZ9LjQMzb5fYOA1gkg3N2Co7+YPEjXXS98kCtdIyuexn827FT7BiAJAUViBmL3s/el4bvVQUc3Vpobse0DmNWrtOccrkY/DSgqp2phnIyKDfK3XIKfn+a3+Dy+x+riltUDIgvtP58ODRW2D7CzzxDX6QLcqbCEnc0PQa+SWARyNyktrtwdjRpe44KtMO80tRMh3+sDbwTXlm9YaLI45dRirJGyb+4ueWy0qI4+EgJOvC9EUlwiD0YH8pUZkmQJvrlIrDY6MNMzJAG1hHZJgn1NIsuul88Mf7wjXIgd/9/QAWTmntkWHZyEP/xNQwwhEszuV1dXDSbdwEaki9wA3b0WOA50+3JnfGnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> 
>   INFO: rcu_tasks detected stalls on tasks:
> 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
>   Call Trace:
>    shrink_lruvec
>    mem_cgroup_iter
>    shrink_node
>    do_try_to_free_pages
>    try_to_free_pages
>    __alloc_frozen_pages_noprof
>    alloc_pages_noprof
>    pte_alloc_one
>    __pte_alloc
>    handle_mm_fault
> 
> Nothing promises direct reclaim returns in bounded time, and the scan
> loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> quiescent state, so the reclaiming task never reports one and becomes a
> holdout.
> 
> Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent
> state even when cond_resched() does nothing.
> 
> PS: This has been discussed in [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

