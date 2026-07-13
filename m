Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E92C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BBF6B008A; Mon, 13 Jul 2026 08:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003276B0093; Mon, 13 Jul 2026 08:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AF66B0095; Mon, 13 Jul 2026 08:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB6456B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:34:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65E7B1C0CD5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:53 +0000 (UTC)
X-FDA: 84983697666.02.EF11066
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A4C81C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XqnxdyNS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783946091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBpjdqtbb2rhGpETSozc/NsckdAfaonoUVSLNlrevv0=;
	b=apgtbZlcD8XIKQtDDwcffj9o5WdDJtmBm0FTCj2JsnO9Z5scMWjdd7y4hFI+9cMhXrELPK
	2K6YjCTEAttSgtOGikape0xdsR3m+lLrBbFbie/SeHhRFt8+vg8Dbpt9LvjM3oYaWMLxFd
	AHX1OniOgPikSHCOHyeNXY5Q9R/vwvA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XqnxdyNS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783946091;
	b=sd0hZCpEtUsyiAvjlntvYcpomp6U6yqreckiqGEyqykFNEPvaWbJs2din6j8CK3RdtnoBe
	i6tBpdPAXGDNl8UpwKaddvLL2Cwk3RXMtwJVtflJ2y8bd7w7MrONAu0RQQvQKiZLDuH5hF
	n2sd9LJRNVy8KZIm6pN37Adf3JGiTS4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783946087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBpjdqtbb2rhGpETSozc/NsckdAfaonoUVSLNlrevv0=;
	b=XqnxdyNSZIzgO8zwA2kFyBgmgkh2Jcw+ncWitZMoz3Kw0IQLXn+O2Kxb0/6pD5GPT+lROt
	jnJ63+rKvyE7k0cLuTpcwGZUw+3gYRhEkWVVz7qfhSEFnPT+XdPxF9pt59LBblAkqiKkjT
	T1Zf0m79HVLADdHQMtAbfzDk0vsIvTw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:33:54 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <5012E3D9-0989-4115-A17B-FE0050DFE25F@linux.dev>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ieo8sjwixht9649yq5431cotqnkhuhse
X-Rspamd-Queue-Id: 4A4C81C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783946091-436076
X-HE-Meta: U2FsdGVkX191tjUjfdNYdTCyOdKTrpYWT7AX/hgAG1vBGUVnTJSGqZnAYipjcMWHOSMG2O0hj9bRJ0Jh3oOCcRKAwn7vjDKinid2iZIYj15mDfJTBLUsNnARLgWiFCV8szzrkbifM79lSKbI99PZF/fn/CkjuzRNGMY9AJqLJHsfY4otsnQb4DHy1A4+CDgV8ujMi0KkoaSqc/tq2IC9VnHyjeqLjMQ8KyDGOF6aH7jHsWnUoiRzsJynVro3ycN12JG7TGQt5lq7bxJknF3YUcO8x899HLAGRlf09rPj5mabaViYUohcnMollLWWyDHzKo58z2nMU0BM8uHLAi4grv66j67dksGvC7et4VN73K4gAod6IUa1DdTGgiLAzhG1+d5lAHdoa2kjV1Lb2MR6+4IrafriVFZhW6wTahw+FK6jY1Wg5Alp7lMvw7p5DRVdkguzldVxl0qZYgoUrkRH5mtt2mOTHjYd/3dNFICm3+gqJwAIgm6yo9Hx6Lmtu0igaFTUz20/lpz0F3RGZcVVR7RJGMvSb+Yvq1H/k3x0cbEpkGXW2cyskDDMuH9D5f3jXVA3tSZTsYcsY0aj618wFUIZ+b14wJ7OZeKJY99sf+ni1vwPIiWbzYlQS0h5eiLEdkEc+hP7JpcwWOVsI5asOa1B/E0+mqgm/qtOF0SYOK9eO0Vtdi0ST7i+VH2N3hYYBYjuz7wjpQqzM3dSmQLG4HzClMM5yN9KvBBtyJWLsBJHQix11Sn96ZwQK6IDzye3h0jAWDnwKDFk/frwbtThvEfdMCFYwpDuTR50gWhgbHpMswL670ZWC/tTfiS2UY95Bp57mE1NOQTsWTrFyORPbk7exsieejkDGmfvRzquyHiQ7cDQ5BXueukIi5t4fgoBxsh3mmOZcerzVWFVlFy5ndPZow/vmTLAVbFGSrbMYRS3uTzTw3xL2ufTPgz5Pcv48FauePEPm1vHUdATCYH
 rmcG4cQw
 qW1mv1NRX4amnEWaN8BJ2hRALZ44PkjLOiYb/c/3rrpk3Tf6TIqQ6qx5DS6Ytj1XIUp0bdVwKYwvn1apr3Wyy6o+JHOkwFLsjXwlxrBCLKOhpAdDLkqIU79csecabnSWxFvhpxLrg6wqdTy+Q/0PcNCa5otJ30sccs+jS6ER0j4ntHAWp6W2BYguxFe0ERrwmakJVgPRV80G+nBfvFIu8rUTjtCO+ypisRaR3SPOcfhoIEIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 17:03, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



