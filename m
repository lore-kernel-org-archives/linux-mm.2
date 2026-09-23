Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BFFC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE5D6B008C; Tue, 22 Sep 2026 22:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6F76B0092; Tue, 22 Sep 2026 22:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3B36B0093; Tue, 22 Sep 2026 22:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4176B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:43:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 067D51206A1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:43:03 +0000 (UTC)
X-FDA: 85243479846.11.49555EF
Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id EEBC280006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:43:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJzc0IdQ;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790131381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxddes5Rp1moi+AnJWlvyitG794UjlkRI578Y0hMRLg=;
	b=T7J20V/hNP+9Z4OqU36JjwlwUxtR6RTfK8Hd83WSVPbyPHVr3ITgZ8UIE9lTgiGd1YgqcU
	fHZQgsdDKPRjG0k30a/HA22he2pStieadS+h08EsPA1LNASuKzUzEDvwkXQGGRuIE612K4
	TXCB9IQ1pMnXbHP1NkEyzlxmBvNFGQE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJzc0IdQ;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790131381;
	b=Y+kbqhFZZ3qgYEk+KC4fIvWm50jJigTt1pEc52E4jNN5kF9GXkaNdxiNgB8CrMcRYYWWC3
	ah+SPQNdDh2K9VGEz33dlefCxdD+CfQNa8SXgwF9i2XaBYrE6kgr/DfmpfrBjRX/CKXwi7
	XZh4ipnRRYZ5oaB1HOF12fB3bIE7Kkg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7DO70pOSnKfl2ZBvK6u/JIg2H0ORCq+ZJeqhlObG650=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790131378; v=1; x=1790736178;
 b=eJzc0IdQI2Gx9shnrH8ambz6QEno0qMBvK3H0qciolkTaUN3mKoaOTsN9A0B7TY4z7fbpu09
 s9sLa3DsrLUKKYOnnJ2wlRSCbmNUwOx3dRIay2UgAU+y9hMyeeFlbuf16n3D0zZiAJqmLOY1RlK
 Dp/a+EP5VKad0sBvdEbPT9nQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f8f061495026a087;
	Wed, 23 Sep 2026 02:42:58 +0000
X-Mizu-Trace-ID: f8f061495026a087
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] hugetlbfs: fix stale comment in hugetlbfs_file_mmap()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <tencent_AA61551D1F50E61F46C8542F5C8874512C05@qq.com>
Date: Wed, 23 Sep 2026 10:42:41 +0800
Cc: linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7BFA772C-FC76-4414-88D8-A0E77087C533@linux.dev>
References: <tencent_AA61551D1F50E61F46C8542F5C8874512C05@qq.com>
To: Zhenghui Hao <zhenghui.hao@qq.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: kczz8efayaktp7wrbcgsh88nyansnk99
X-Rspamd-Queue-Id: EEBC280006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790131380-219701
X-HE-Meta: U2FsdGVkX1/TAFM1lbsfM3cSGsRERsa6hun01lfN8e7BJwUhUQ9WCg+7yc20BGLnG9CWCco6/xDnA8gj5WFVYOmuerrWCMFER7wXvKGm8Cl9xfEuBPZS2I3s7aRZ/6xtfZlIaeBuyVX6P36/47lTJYFkL44x17EWoRvrIGPosj1VEyo1ZfCVoa0QhhBpbO9INr6wPYe8H50PbFlPaj51tsbdi/yNbQuw/ZoVQsa14eBO3met1PWt+fS7wg89DvpSab3y7SVQHjQP/rbNJdp+L3ToUvUjcWJ1wUO5w+TmYCLXQkgHSyuxZ82H3fdSor2qli9a0Cb+qnwfaIQq2E389DRAzt1vOoGh0Vsu6N2vlrTOAv36VBPlM4DpIzckr4v49m1vczuSm3oe+1LR2VALVzV95HQClFVsYm/AAURGw2RJk2ihgpoOAGTn0cc2wMlz+lH0DSJDyItvl8u22gwBfyOpr7Qq8yLSq46M8E4NObWhD08Mlghyqprt0hiuuXZlMGuYvH/1RR+BeDolliP1g6KbeSCL+qMaNGYs0UoMP0mkPbTsexvcIWJCstZCxRPMcYkmjRYaFcDcsXcOZZKS/a7k3u0W21cCx/ETkviviCGoCt+5OXj3FX0fTcLMlhzED1UPRu2xSUSSOUrBESH2JEIcQMwNRJ/HJhQS0sIm6XD/n6tc+xn0ggC62ziraT+TaT4O8Ezzk+veYZpvOpPa77p5snzPwUSi+W7GZkGj2Bj/8DZgrZ9uaXS8r+DXHVsJrCwrVPLP2qIpgC2fAZjQ3nzQQ3hFUnbFxOODnDjf5Ru6X0vqj0Ou9yXWAHdrlWjkBHOFEtXyJBKgmqowdufrOz7QtiC1I+u/BwVYc/Ga+tymr7F7dMo7wQGewV8+AzPo28VWSjq0861oDEMZtOXG5b+YnezkNjxz3gTkGTPMwdR400ySrH+nD+Wpuhgx96vyCLrJpnqX6eEToRaHKvs
 Eq8FFMgE
 GZJRcYlxFTtU3NNBFPdI/pE81iWzoYDURkhpg+33IaJ79huul15fOuu+4wP4j7MQIlCoVdognl3KinmUNHOlR3MKBcYT/ucIEZEsL25Scss+2kobHYF5j+lZeJkEFwfzXnMKCO4oGcFigHy6UakaQRUieOUzEf3MU96IEdloLxFCDYp+wjx9gUa5C/QFj+8krXobAfISe8gFTyqBKWC+pCqiux3lRmTNlAUzFBpnl6eCs8EPiywrV/BrotFTm/bwDS01f5QTYsUh3VIBYJBF0q0g5i338Nq5jT3/dHdSdTaEDyUVMWMnhTQik18EOffzsDvQ4cdrvvT5wCYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 23, 2026, at 10:28, Zhenghui Hao <zhenghui.hao@qq.com> wrote:
> 
> The comment above the VMA flag setup in hugetlbfs_file_mmap() says the VMA
> address alignment has already been checked by prepare_hugepage_range().
> That function no longer exists: it was removed by commit eff41389d824
> ("mm/hugetlb: remove prepare_hugepage_range()"), and the check now lives in
> hugetlb_get_unmapped_area().
> 
> The comment also mentions ia64, which was removed from the tree by commit
> cf8e8658100d ("arch: Remove Itanium (IA-64) architecture").
> 
> Point the comment at the current function and drop the ia64 reference.  The
> rest of the comment, which tells future edits to add any error return only
> after VM_HUGETLB has been set, is still accurate and is left untouched.
> 
> No functional change.
> 
> Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

THanks.


