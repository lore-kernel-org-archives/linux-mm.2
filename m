Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054EC606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlBYnBqf
Received: by kanga.kvack.org (Postfix)
	id 064DB6B05C3; Mon,  9 Nov 2026 12:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015D46B05CA; Mon,  9 Nov 2026 12:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49F16B05CB; Mon,  9 Nov 2026 12:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1C086B05C3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:56:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 437C61206D4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:56:57 +0000 (UTC)
X-FDA: 85416336474.18.9492EDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80915A0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:56:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlBYnBqf;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794247015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNhycM7i44D28IncIzykroZv4YkZR+2ZSE2Wf7GgLlw=;
	b=mGm83hyCJ1b+wzGEFEYmxk983tNiSYuY72j25L2El/Ficy/8F4PWWPKyYlJaxRT4fKSSA+
	mw9lJgsK9MaLToFRGrZuYYXA/pLMFztcGVn33mVPf5WxseOE7iqUiyZ+OZglH2UHZyEcGH
	IUzLcK9k5j6A84joge+Zeh3dHXMdfPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794247015;
	b=kd48aN5BZv6SdpfrLlOvne6KtQmiSXqMweAv+P+bZvnSH4ePCXeN9SsR5nL7LjT6PxkmGD
	X6XcFe41XYpSPwwKIWXz5aVrf6fNQnn1drVRTDFLrst1odcj5k6lCfQ8Bf3uPIaSQuGl/D
	q5x+z337dx3I9evzZzFlZscQ7+uZKU4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlBYnBqf;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B43A601EF;
	Mon,  9 Nov 2026 17:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508AC1F0089F;
	Mon,  9 Nov 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794247014;
	bh=YNhycM7i44D28IncIzykroZv4YkZR+2ZSE2Wf7GgLlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FlBYnBqfZpkSaqKkRTnAoc7afDQSDdvqCa9MUzI6cuF9mNMxqvr1IAKmNkcC6ai03
	 lrPBfh4FuKT18GoykGxO2NN3CBz0rfQgKfhVtGCk2GmpY29bmxyRHvEzrNI9qfHoWZ
	 WLj/rtNedM8B+hgbCKGsln1f8EmIWM5epY6UIh8hAnkqqkyRwL9fiordu85mVcjwsa
	 P5D0OoIYOvUCnRmv1tVXikRgx14ns1TMzFYUHUd/ugeOicyVNwWML4r0z5j3jSyL8v
	 Jz/EU+PReWuJaBROy647MQZz6o4Sq3cbSkdLBpX75Sf4QsP3wU7b0z4saRRrb720Jj
	 2kGTV0rgXr0eA==
Message-ID: <2199b816-e3b0-4f1f-aef4-e79ce71fd07a@kernel.org>
Date: Mon, 9 Nov 2026 18:56:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>, Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Chengming Zhou <chengming.zhou@linux.dev>,
 Lorenzo Stoakes <lstoakes@gmail.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
 Wang Xiao <xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
 <avEpskVC/NRPFt4d@dgvxl46587.localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avEpskVC/NRPFt4d@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ei16k9cypdadfgzcdpow1fb63aebm9yf
X-Rspamd-Queue-Id: 80915A0005
X-Rspam-User: 
X-HE-Tag: 1794247015-847837
X-HE-Meta: U2FsdGVkX1+nWrmDEAtq3wAC6gC4rYISKBQhoKWQ7cYV5ttt5CGFzWkNAkrv7HYy9FPRR0617EbO2ufNqwtZ6059oBymReb6hiwLHqIKNaIXPKXGgCDCBjO+k/XaBTcBMzo7hUokl52ExR1yeJMftgZhUmI20OooKEnQs5ANvRjTYfpcG2oy0G+vWGVsteVgPQ/i5XYPO9izPNuTaOgJDu8IZ4uXtWAffzNsWL9ZiNsNS4sjurtiVARNWV0uez0YQGZZ+I/LmpoSLG8OSwBmhK4Ff/rzJIXylV8x7XTto2YUnZQ62hlVjqp7qiKi+q7tUv5sbMj3dUOPRt1G2r/5NtA5QDJjj1Iyb0yoQabE6ioIB9LXUCBUp5rfStpa4TDcYWKCcoiGnBNHRLiW64QGtumYY7gO7RvKRofQL7aCrxAXe85p/8G3K3rXognW+kgpxTVRtmaeNppRgmRELiV7H6b2SKGTx1aMji+W9WAychC76pZSkpPgKznwgl2yPHIqRHYfNCdQ3I663qINXb5CKebitmVT/6HSCzd1Azhqg2yjW64a6Z1Kg96TGaQmZJl97F3DH2Qgw6QosahsKIzQ5cqsfSTN+uOm1rEnewzq9QLtHH15Il67bB2ud0sLsXDFUV73zINTxqiv8/KsscYxth3VYogoEZJU1pDpmy8SMvO+9Q9bVBUDrFvdBGq3RoDHnL7O9pI7OBfRDr+kEdvBi4mbILYObVKC3+mawA0zBNJQ1OmT8Ih6V1rCTmt+1VW74nks6ncMMZpnFLHXDL8tpYQcA2ipioMMX31OyqX315NBYIWhnD4i+TwpJ0J01v+E3CSne6uSJXeoNC+fVbgFHo+v1RMcHO8FbPx3/z8/HXzBEaQl6CRtiZC8v/4affBe1FJd+s91jjxRGWthxftipIGvNIn236vZG2PgVNMg9jGeUlpch3KYXLX1qphffNFGE/yRu8h1Ogwyj4Bb/K/
 jimlnLaE
 cPZ+vSB1ckuD3pKFbP9unAcdMyZNRrOXZRr5UvE79b7szsILGjUiaY4n1X7QoVXyaCCnBoodZi4SmuAKC0dgChobXROmxSBYqjPvv0eGcRNNNhdmqq1Ij8lv4y6wykXHpa/OTtoWriJGfvq3Tb6sDOq6eti95D4yXTRe3OVX/EQWj7mMJSJFc/Q22zaG3YdzJ60eLGFsnQU5F3EaNUrklYCoqMEaNOdNEHuszZclMz0YLqjcaF66bLTfJv9+lG6ygx5yYWoOu+DT+DGJ5JJyATNrwYhJWUjP6jQFiHPP4mpGK0ne1/bI0ZVjKusvmvYulzqB7bLWygPsw2ks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 03:02, Xu Xin (vivo) wrote:
> On Sat, Nov 07, 2026 at 04:13:40PM +0800, Jinjiang Tu wrote:
>>
>> 在 2026/11/6 11:48, xu.xin@linux.dev 写道:
>>> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
>>>
>>>    KSM side-channel exposure is desired. Many handset vendors may prefer
>>>    this knob, which can be used as a default fallback policy.
>>>
>>> - Not suitable for server and virtualization workloads containing many
>>>    non-zero duplicate pages, where vanilla KSM provides better memory
>>>    savings.
>>
>> It’s a coincidence that I’m also working on similar optimizations.
>> In our scenario, we have a MySQL instance with over 700 GB of anonymous
>> memory. Most of this memory belongs to the buffer pool, which caches
>> data from storage; these pages cannot be merged. Of the remaining memory,
>> around 15 GB is consumed by hashtables, which contain many zero-filled
>> pages that are eligible for merging to reduce memory footprint.
>>
>> When we enabled KSM for the entire MySQL instance, ksmd created rmap_item
>> metadata for each candidate page.The massive metadata overhead wiped out
>> any gains from page merging, and even resulted in a negative benefit.
>>
>> For this reason, I’m trying to make ksmd merge only zero pages. The goal
>> is to have ksmd skip scanning non-zero pages entirely, thereby avoiding
>> the rmap_item metadata cost introduced by scanning non-mergeable pages.
> 
> Skip generating ksm_rmap_item for non-zero pages ? That dose make sense to me.

Yes, we should avoid any such memory overhead in that case.

-- 
Cheers,

David

