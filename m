Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C0B3E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30BB6B0005; Sun,  5 Apr 2026 15:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE17D6B0088; Sun,  5 Apr 2026 15:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7256B0089; Sun,  5 Apr 2026 15:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89DF36B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:27:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F2C2855E0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:27:53 +0000 (UTC)
X-FDA: 84625487226.29.425143A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 50D701A0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:27:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZBW/kaMI";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775417271; a=rsa-sha256;
	cv=none;
	b=aFot7geW9cCxkzqSnL88PQttFPq4NZJcQ6/m/haw/mTGjpziSe57q2YOPQd0SY7i6gWbTU
	cpYwzwQIB2Xxagb5WtQtqs6ugo4XlVpS1e0qWXTcQA/ZOILidxgXGqRm2C3D31vA0pUTyq
	F9Jk5DMgOy58doIskqdWFW3PaBb1icc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZBW/kaMI";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775417271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nv5HhmiXXFZbRFLM2tVlrCVZ9M41o7HB5iIyWXusd+Y=;
	b=TrapUtCrRZdS/1yNzWA2XzYMZ6wFoKNjVc35yLol9z380iEu9fLWQluNbN5Y0iuhT3TVIb
	TvX1xAhXoSdALxYyfazVgPdXUwiNXzMU2iahDDn2ixSuuGprkrGeqj2+2FyaEnq9qRpn9g
	RpkEmAWnBZ59tfmjaadN2PqTpeoODVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A62C40645;
	Sun,  5 Apr 2026 19:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC2C116C6;
	Sun,  5 Apr 2026 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775417270;
	bh=eApR5j33EcA0ROnNvMtAVR2IL7XWx8PPjfVWgVDkw7U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZBW/kaMIZYodImP2rvz2U3MWdLz3UZjguU5apiZzrxCb+D3viH20i4RbLJZFl4J+V
	 EhGq1PBvUnFaxmVmSNEg1Y2W486zt0PxRV8kL5Yg5DL8bnC3e51aGZwop3puzN371+
	 1jsu+/u04UAibLYftuFxqe5L8pXNlXCh1ZPr0Mqk=
Date: Sun, 5 Apr 2026 12:27:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Braha <julianbraha@gmail.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, vbabka@kernel.org,
 hannes@cmpxchg.org, mhocko@suse.com, surenb@google.com, rppt@kernel.org,
 Liam.Howlett@oracle.com, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
Message-Id: <20260405122749.4990dcb538d457769a3276e0@linux-foundation.org>
In-Reply-To: <3cf0c280-e5bd-4e5b-884e-6c734619b821@gmail.com>
References: <20260331070730.33915-1-julianbraha@gmail.com>
	<bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
	<20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
	<3cf0c280-e5bd-4e5b-884e-6c734619b821@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dxmfkj9amoz7uc7ybzfpwq69p1gioyz7
X-Rspamd-Queue-Id: 50D701A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775417271-773173
X-HE-Meta: U2FsdGVkX1/T01it1xwVTu8DMK1pEw98KHNZflWW8i4c2r0IIYgzyl/8fmGI1bdK1xO8zCSkqRpuyMUXZaGY7OqBREH1NsdETixrIDxwr17vzKgyF9u5HC9PD16qd89jAerIx8O2lsVRvMAZURlv1UmZd4wWGzWZP1giAjk6M8IX2HYIhpIH3SQWyrkx9IYDPL9qlQBSvElZrBIoyMtTNQpNUBm30AlOLpaVgvsOXXeg0QqTs2xMT4fLeJ6tEF/ydmhY+Ym6qcuWnkK8pv2y9cYqRHj03reQwU3BQPUhs1e5v5Khuy4GcEM3emymdB+5V4I3s1rK0v2yQLuPKjc0heA8Dn3uxaritPjQ8HDbLB4RKbdGV4IukAw9yC0xC3wwaFO+YSpRDT41dDZ61yH6NxCJFG/Zd7LQjOKwVNpYsJximJ7h4V8RX/DkwW9uzuP5z8vu/pbf1BGHXT9AAZn0CMy+oqkOVLV/s7PBAm5KiB/wf0oreEHkWrpnDLES7Oj1pSLYet0J96sK0AJYYoJGPZoE5eeTC7Ofk/ExLEwepZ1nTxYxAe4f6yQwaImhHf9nAdYnZhCqifVmy5M3jN1zn1VJyORojniMQqDRSwJzlqvyKasQ8IBxT9Dzq7CVpaJjWBJ540v10hTAuP7VvOcqnwB1LaUF60p295WxLDveIaCL3CGsTsbkIiob9QxEdSUYOVuaAUg5uZ+nbg1H9trBM+75dJR4KVPopU/PB5pRLEfAOEO7P7DPylItMie0Vz8bfsspaPN0fynkTPXtOO0VV4aJRKCzuf+Ek+mqv5LAjpV0xPh1lLeH4z3H8/jNydvHJL1498dv03ukC8mSah3JbNTnScjvwFa70oaWm8suPHz5s5ZKnEjYCoBKnaEa8JFv4tYtLfWv3iufNsY2KGHrpBrJ6X24F+xQt70I6chrQ5bTrku73raJdM8K4m1nybCRrHHBITZEjLf7XgJg+I4
 N2EM4a77
 RoE5P384/RCidUwvNfRivymHsiwnq8p+jyR5tkwtvVSOvUSKmRURvQuBp/4QtIn54AZ8PO26uNjS1VmWM6FNABTbPbeWE297gHt/Bz0iaw4338gzLshS961L4Qm0wbM26EN9xF7/5sEhuOfmOdO2AAyxBcEVfZRDWdSYYkV48lGrzCnTaokisrg6hnGr3JgBpZvYbuXQ9herS6buqKHBEBfsO4URl/ztEWJtgv1Idu4XuaJGRNU76F5oMF9XKILD56Ncike4NeMr1rUGjJErJ07nulCeMVSCgL4PPJ4ms/2Fim28ASaidgbkannTFS/Uk8nNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Apr 2026 18:18:14 +0100 Julian Braha <julianbraha@gmail.com> wrote:

> Hi Andrew,
> 
> I've just made a proper announcement of kconfirm on the mailing list:
> https://lore.kernel.org/all/6ec4df6d-1445-48ca-8f54-1d1a83c4716d@gmail.com/T/#u

Looks neat, thanks.  I don't know how much uptake you'll get from
others and I expect that addressing all those flaws yourself would be a
long project!  However...

> Additionally, the code is available here:
> https://github.com/julianbraha/kconfirm

Have you considered adding kconfirm to the tree?  A top-level `make
kconfirm' should help move things along?

