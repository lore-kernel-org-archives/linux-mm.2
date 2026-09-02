Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3541C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662DF6B00A2; Wed,  2 Sep 2026 11:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613DD6B00A4; Wed,  2 Sep 2026 11:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551886B00A5; Wed,  2 Sep 2026 11:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F76B6B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:34:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7826140244
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:34:58 +0000 (UTC)
X-FDA: 85169220276.19.8A47145
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf22.hostedemail.com (Postfix) with ESMTP id C5097C0012
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:34:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ge+HIIGq;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzSmaUt8Li7YawIgRqOCmX5TNRd2UVPmqb0BnmMdAMc=;
	b=frcntXtkacayV7g9XvM4xc3eGFomXKM/719lItSg3GRTZfDa6wkHSn+bNJE5hjGo1yfeto
	6ywfKL7PlmebkBOft4Q66sxipGtqQ3IPuhUg+trXzb7l3zogb5bJtJawv1B9Jik1WJxxMU
	RMwaq2AhEV/qPgf3/yMuHpK8fn2G+yQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363297;
	b=B1NRu6+rRCiAto+cWE0O1UVNiAdTUMckIbN1ZSaX1p/370Pzecm69NryOLYGlRNiLFhdff
	z67jFJWTFw4h2eHeE8U9+GP/LpEuP+dfLnlo/DxXu9I4jLaIn5NwxGq0WF1hUaBy1bhA9M
	CcrzJ84Cs06vlySpOlTGJpqQmSKUO7U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ge+HIIGq;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YcWOLss1tLHPyUMwSuqRHic7aNDGFCFnwIVK2MaoRw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363295; v=1; x=1788968095;
 b=ge+HIIGqk+eTvCGIGbneI0yIx5epzInrh3ZNwgw3LwBijyGv0B0kwELBGw8VH5kln9Jkk6FI
 aWEYb8YQEP0IGHtkGyIjJ0RP5xwxWA0S7AUPaW1PlqeX07fdGCHuiOMwAD+VmQmfw7BHNMcP8WC
 RLN7oPYevk8U1ZE32pe30PT0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id efcc2935034d3f1b;
	Wed, 02 Sep 2026 15:34:54 +0000
X-Mizu-Trace-ID: efcc2935034d3f1b
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:34:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
Message-ID: <aphCBeqTnKEpTCuF@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
X-Stat-Signature: 8n8k534tgij15pm68qcqme399bn7fef6
X-Rspamd-Queue-Id: C5097C0012
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788363296-107646
X-HE-Meta: U2FsdGVkX18Fga/KoOguPLiOQmCtBlKv4OcUT0xDRCi63bSC2ApFQ4Go9FF+q6pNic2zLrwcL96JDZSJvV6dyo8lZt3aKUOccjPEqqsH6v0oBbQc2mEKxoZ36YujWsi9MCoYFyJaldaak3mDrF0Ky4UcKVu0GYaFYUJzPMVVUCnU6cQgbzMyZ/K2SoOixZnGuw2q78PjIlmwGdHpn8NtUuPxtLnrayXTrpxEKSBT52xe5ydVS7aDFwPPzz3rwdS85S6HhK+/mMaMcXi9O70lw862KJrAtnwdqReWob1IzCggHCXgdbziheHfmz39zExuz/wGZEMavRoI/FAHdo+qolQbJrMqvdriZUmyIr3fFNKT0kEGxCnAdgMx78zySnXXMQVIE91X645igj9mTXBKNgPHEA6dU3eHNWvVvAQsCBG6LvYBpwzI3wPw7gZdsOrPc75q1EYbSEuNl1GwPT3gzdXYU7QfY2bbqIle2QOe9LzIYwkgq9Bm4gMQwIwa4pJZzKoqSlZrQNlDRvFDLxFQNpvgIfce6PE2TIjSZSsxotwp3zpRBqEykHTHKIr68tWmhmq/diFFMIPsuZAtxaAfU0Jp9076Q3zsK8rORXkukQwR6y1WtuTQ3uqJ6EKbBdwZKRycOj5AUS8dieklRWCwKQjpCwgdRhxXRotur2htYqyfHbjDUNsHcniku/Tjyot/EaL7XmDZFQ36F+Jdf1EmxF+3a9uOiHtUADCd0bkNFMe91GEF5npkp9D2yX4IfgkumestNivYn/vOTAmFeW+xO31MMJjlIlT7fUyV8zVdgMhAXm+y/xYYPKh/RsPEMxZL09dnwf1zxN+Braz18BBoa61D6upx4cnE5TZPoyorX+gvRopbPkzswwF8LWWo6W8LYyQlsX8UpU8eh+3QxUFu4Z3rqjH2lLtnDh8DrOwIU6kZRBqRKUMN4vZiWhVhww8UB4k6houK5S+3tSpWNU4
 Ajb9Owx9
 KkmGw8VRDnWSIW5Ao7fwZCBjQoG5hmix95HFfmB/OMKobzVzvEW5a+TiUgkOR904WuXgyyACa0U8Z5malNfvZLXZ0HEDzzE+g7nf6pmDbE3SvJ+Ab/CflrCnPZI18pYWWvBmOwGx/yeX/+IZJFCRApPtYoIZI70A3nBxvKyz7nX05KvZKybqWiwUWF7ngTsCgqQfwgEdm0dub5xRzHPKElg8urp1xA8v9wyTwZwAnSWVXjz1AIcX7zWsATlhf9DPWvYtI87sse/ydFBO5cOSicj22MwCwCB2XWE9OxX4ctLYvvmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
> Now that kswapd can no longer reach filesystem writeback (pageout()
> returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
> context in iomap_writepages() indicates a VM regression, simplify
> the check by removing PF_KSWAPD.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

