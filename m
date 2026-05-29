Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD71CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B906B0088; Fri, 29 May 2026 01:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB51E6B0092; Fri, 29 May 2026 01:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA49E6B0095; Fri, 29 May 2026 01:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA6386B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:36:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50DD79B7E4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:36:50 +0000 (UTC)
X-FDA: 84819348180.23.0E725D8
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 708CA1A0003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:36:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xqOG5kXU;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780033008; a=rsa-sha256;
	cv=none;
	b=IWds0ki3jju/+YyoNY5QSXk7OP0rKL6ewLUpg5tAkJZlxashWE7O0+5vmTotxOJSZW+Syt
	UDo5fw9O2ayTPu+/zLbtuzR0+hnYBiyINTPV1XCVj5QUlELRakyjnBwQczCflWw7M8N8N+
	J30G9/9GC7apY8I99aiHae06wFXMtLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xqOG5kXU;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780033008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MwGmArfXyP/zPLMRZPXwscMyFYlmjrr/pMjvdbtZZ1Y=;
	b=qjWyAaHcn6/rCHNa4aHc/fLaiutsuLfg7iqVpK0z0f2/XhRmIM09L8Mr1H8PqqPuW+ymVd
	XudYwC89CqK8fDd5HSN7/wj8x9d1ETKq37LT6IbyuhJWhDafYA2nVfNTSXk3j5muDSX0V5
	aBg3AcwJB80CcyhSJe+1VpzfPgOjF/g=
Date: Thu, 28 May 2026 22:36:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780033006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MwGmArfXyP/zPLMRZPXwscMyFYlmjrr/pMjvdbtZZ1Y=;
	b=xqOG5kXUMqhUfDjhh10O4x865465aXvQZNQygbSMapm+kfmcM5Onf1Wq7n0ZsFQJdmSLPP
	ZBRtFi1EL8WTkTSxmLLaooUHVpxzm+caaKT7xjQ0ULXp0RAPGNbvtMS6rTo9PJD2Rj2jTC
	Mp0Xrk46QGk3tIjwSquNG4ktjDvTNBQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 01/15] mm/mglru: consolidate common code for
 retrieving evictable size
Message-ID: <ahklEbzZn3HQgS9f@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-1-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mglru-reclaim-v7-1-02fabb92dc43@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 708CA1A0003
X-Stat-Signature: 9ns9n53dudfm419nmfdciox4r4qkbh47
X-HE-Tag: 1780033008-78620
X-HE-Meta: U2FsdGVkX18o1W5ESzgSLnkDWgw5GI+f5dmxVt0IlOS6ae3RoL73l/F+I+Kw6oWxmQsmP8Fq2ojqPr+5+5e+k+4Ezje+GkEp6WaybbHV3uyREtaFy6hFsLSofIf3+M49KCPUPQOHhxEKjsl4GUSoFvXiU2e++xxydZ4C2V9vCWzdA5Pptr0AyfoQLlArisIhcW5Mecxskrb5sTQYjUo8MQ2S5aTO/COMajCEOAaOzeW3uclthUHpR6UNuYkqs5yCM1RxouFlSK4XphV1sNH7g6O+5JpQionLovYyO/+akmhOI+Aru4xS2bmfOHYulOGFV4hBnUEFrUOzZUaFTAz6dHh99/UedxmBVowOMM5R0WRnDkuSlk8cFA85fQi5Zf+77SQnz+rLHiqOF717bSA8bPwSW/jPwkZaXS7MuhfTUb1XDVRB/RQE5kyvWi/aM/sPNiwZVqEmrAKc1FbDsKaZgIELRBK5g7Sj85Mo7bnYCkBnlXUksQPxAbmpD4SPwSnIipcoyEkVGaXCAsFE++iOL3Dknl4hJQk/EEMe7ANx/vY+XKt6mH3lbfQwwu/46Bs/RS4BKnOeWJ1Fq8CRztEVYMaWCY5KBhlBKLifrWL1quBc9pZ5lheYw5vuOgka1nvuJJv8YlJTKaowAQItexNVBV/s+OhdVtnKlqZkvUtmEm2R+i2T6cr+lqrVu0zikm4sRb5u5iw+W07CflV3UQHseOyiFZfyktrwkQ1RZImNeFqBuezdVz0CUveATYkw6A7NfnMj4BQSKAZdkyLZaig/PHXTyNU8D78IIGeh3142ZEFNUbh9Q9uJWz6i0JYQhjHuxU+W8a+7Y9filZKv7wxLZEXwPT2QTzqgdwwRMGrcZqM6KVcLNP64uebDCtS0pAjXbyKiW882+mjmiL4ggYTEIkrwYBW5IeY2YZqOdNIp7g/c4jRrqrEMZTrubwu7QKWEURtw6KvmOXJflCAg7PR
 izDxN0L/
 K1sqoQitJ0ArbkjxZI7QJVjVITRILak7CwFZ5WwaCAj0S2BAG26Fv6FNytqKgWDsRlR4FdKyw5J40ovcNJKpcsdzNYLp+x9X12T7Z9O49DlWLNzIUU2FkCuBb0Lb8Ydt0yDl+r7E0TZR383S1OASM+eIS6owzDsj5mP0L29A1rbxlo0Z9VkLmqVtdKGri3nn/4Z3tV7GkFL2IAIzQcB+LY6sYHsZUy2FSq95C8PIG+PIqTFUOj8PCZhAyZMz30fNo5HMi6sbckZGmRnh8D8HSMQIm+LambPOYHOUtisrBxHveCYGdDVMIQ+sXq5eil2wL+wuYNqtyBghMmSpZpV3YR6dhLMNGcifkf4dKM5Gcndf9lV/v5ZXu3l7C0gbqcTzjIgoRM91FWboLKgCAJLizcHquDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 02:06:52AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Merge commonly used code for counting evictable folios in a lruvec.
> 
> No behavior change.
> 
> Acked-by: Yuanchu Xie <yuanchu@google.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

