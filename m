Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 261AACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD976B0092; Mon, 22 Jun 2026 04:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E466B0093; Mon, 22 Jun 2026 04:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A62A6B0095; Mon, 22 Jun 2026 04:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8D486B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:32:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C72F1C3125
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:32:13 +0000 (UTC)
X-FDA: 84906881346.29.4C65C3A
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 95E4F1C000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:32:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPfb0Qlk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782117131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XMCUdWNUTNxQ+9ZHfsfx1rhff+sOJFnxDlJ/S/dO+Q=;
	b=M7YRDQAcjWqgfL2ntYIuYxc99PWCLOZEgnSL9nBvqYqN8vEEaKL7hFFvLu+y3XcoUqIY2k
	crWT5zx0ZS3QCLX76FP3WIJ688qKQVV7lOXaXMOiv16KGckVY6ZV765Gn01ZsCsvtXHoix
	nbrbb2BdhpwHLHw7P02saaec8j9KyVA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPfb0Qlk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782117131;
	b=3/YXWThj5c1/4Jp8Awe17HhvzUBmJ+AKZUEeMM5/dvV5991OLdX3l3Jhn6dUTnXdsUbce5
	QomSgETz3KRPn3xlVxL6k/LYUq2QYK4kJRHYlfZMGFmpIBM3a18JyzHGsMCANeaGMo7B4b
	Jd3uOOxb7s3zLPvLRYswl3ADOQfrIDA=
Message-ID: <ae54f2e2-c53e-40ae-8016-bf8302236c88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782117129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3XMCUdWNUTNxQ+9ZHfsfx1rhff+sOJFnxDlJ/S/dO+Q=;
	b=KPfb0QlkKAZcla/m1msSiD/Q3b06hIc5jEUOmF+RO2/tSrKJxZbuq4hvqnOM+U5bwS9nVL
	GNby/UkJZ564BXhs/sDkhvG0gxcthGULbOPT7lkeIlBp+vwUEe2VqRLkcCchM+4khUamlY
	91m+a8VjMqhp4fFF2bjIHTcdz4ORzkQ=
Date: Mon, 22 Jun 2026 16:31:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Peiyang He <peiyang_he@smail.nju.edu.cn>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev>
 <F5EBCFC495955241+61489c47-c792-43de-a8f8-4b1030f4ab6a@smail.nju.edu.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <F5EBCFC495955241+61489c47-c792-43de-a8f8-4b1030f4ab6a@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g36srw5rdnwt41y8853ft3esm7pytifj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95E4F1C000B
X-Rspam-User: 
X-HE-Tag: 1782117131-901622
X-HE-Meta: U2FsdGVkX1/4TDWMDxwGuV6qc0CetcZwxipfCYTecx5BItbPGm8v7g+5Zhrjb7j+HdcgkHD/Phl6D3CneD6AqD40dsbVdX5TofdS81aH4DJaJTebRWz6/10FyUJ1g0lz0Hx/xcxMbhtMpQelnIcP6BQUsncgan5cP7UMUFiBZxRokz8aRInBeKaXzDbXDChkFGMrKJ+x5dqZDaxnQnskCnOYsnPlPLwpB2N8U7KEC1L79fQexS8bfsHdeaPjHHZS4FScGVEyfEvWX0I6wGND+XT6bE8+gBeaPLIEFGkO6gFMPQ2m0tha5AH3l37KIbVcDxrJT4gV4QRdYGGN4yjExwkH8Y2Cv5tDUTWmboYldv43pbH+O8qQNeG7bqx2Smmz0ZCLYof0FJTz2vxO+IX0cDgBY6+n/gwTyGfqrkpFpXAvMWwOZwSGiwHyPh5A/l0ejRIYnMP2nXwAlQjUnP3VgjsicwJiEEyTCHerT/zgaCVwEfDR3j8edA8n45L1J4mWQme61WNlHDlv9lSYky/d9VW/9tA5YzaaQi/+JUyUbbj4CT2EfnKGWAVZMEeJ4a0PfES2vXQKj1Cu/f4Q+XQnl1bu3fR8dczopTClR2BbHKN+6NXlJyIIDRxbSLUwyM/nLFd+hI6nzmP5JFZcKiLwNS96ML2nddP+6OyonJuM/F/MkMU7RL7QMV4FbBAmMu7rzPhEeln1WRkGD5EILNzOb7gtcIq9dF4XVVEL8oz2HB6i4k5xXpcBuLSV3MQm0A7ufJhaGF4XOEABYvDnSR9iahgMGgUN13DnA0icSbeBWtLuakmXYEGJQupAln51pHUhOGRW60jxRveL6tuxZZAls9/IJ/DRdYVEL8ONzuvoR44MNZcQWUq6GPBCPqnD3KNlpcm6J08KmJpNI0DfC9t7dw7Dc9WYMvP7nRbleJwDzMzscq2vM+k5luPSfsRYP9u4npPBOaMfsH+qGHFPKsq
 J1B0hUeT
 D+1Iws7iaE2768Q44ZK4lnOd7BjSqaexUHfBMnuWe4cKO2+MCLNZug5M9wT345VtAKu5A2tT154rktvtQx0+XPJrNAqy+SO5hQ4BXtD5PjsuRN6bLa3Vx/3NaTwxzbs/mWLKDNO0GNUD9I4geoQZ11gvWTLn069iYeimfrQe3QwJMduf4q5gKmotOEcl320T9ecjRX3nxUxDmu9HTUeAyAK/RTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/22/26 4:24 PM, Peiyang He wrote:
> Hi Qi,
> 
> Thanks for confirming this bug and proposing the patch. The fix I previously proposed was indeed incorrect. I have applied your patch and tested it using the PoC script that previously triggered the warning; no warning is observed anymore.

Good news.

Thanks for testing this!



