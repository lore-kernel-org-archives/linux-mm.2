Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608E2D35159
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4E46B0092; Wed,  1 Apr 2026 04:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C546B0093; Wed,  1 Apr 2026 04:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1F66B0095; Wed,  1 Apr 2026 04:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88FA16B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:34:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 257AF13AD6F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:34:49 +0000 (UTC)
X-FDA: 84609326298.02.967B688
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B567C0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:34:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxGG+u2r;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775032487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VyOjMYQj8D5f/V6M/4ZUVqXB8132k/WCQ/uNHTB4Ow=;
	b=i8pjSHV+KqT6BJQbWZ0aCZZJQmfJzlcSNj+949G/5+h/3K5LSsxShk6VUrF7Y6IqeT/rx8
	XPDFXxVyHKSXPSvHxk0kaMWImTuXKhEgimZTLJgKBd8/ygZG/J7KiMBHcD6LPGdZOkMIBc
	kJlEQVFzOkhbOBQEuW1hD0iQtmtvoRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775032487; a=rsa-sha256;
	cv=none;
	b=cN+XKFw3MrH6ugLvDRB6OoL5UcvWrgqRLxXdOrXWT+nSAgKUJSUGhyr73tL9czsdK3Yrsy
	b6ljowciQiHo1uglM8u+LTFzXUiBXahjDr8VYgIO6pdhvc2jhWTbNJHFbqGmmfvrRePCiY
	89j/7GS5kVGv9hRte1yqqBoCj0/XW6A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IxGG+u2r;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 407974067F;
	Wed,  1 Apr 2026 08:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2575C4CEF7;
	Wed,  1 Apr 2026 08:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775032486;
	bh=1w0/GG5qdyXghEHkrjmckecNc+tGwP/YtCUkolWuqHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IxGG+u2rr/ad4XEBZBnd/tb5GmMxRtkBZKF5Xo4+ciDnYGUZAn0l83cG2WqTxe/yC
	 pVfAkeHlfCuCJ1VsvHWr2eeYRPSO2ik65KmqZqUBbV8DXa3RqZ1kFbK3VVVaiOdHPK
	 BtDmlV9goLrIH55wF0WTxAF2GJiqjg6GutIBSfahEFfMqiWTQijXTw617+F+89vkyh
	 kLSlc2aCOzWg6Y2fvyY6aXSIO/Mj5iwJ2hFMcMDGicCrtFxyPLTx6ZeLSASwR5Czky
	 QEnCS2JRwBBHVe3OgggeLHBpTfFLNr+hBsDLG2vfwdpuQms3gu9H9vXSs6slkRKjMm
	 2Oa0Ubztz0KIQ==
Message-ID: <b9625c60-2b1a-4890-a703-49e31aaaa168@kernel.org>
Date: Wed, 1 Apr 2026 10:34:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260330125307.98581-1-liwang@redhat.com>
 <96d14f27-ca0f-413d-8b61-768933ee70ba@kernel.org>
 <acxpVd5hQUuGPQCF@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acxpVd5hQUuGPQCF@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B567C0008
X-Stat-Signature: idfeohrdmeztm5t1yn4mpccxc3o168k9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775032487-59187
X-HE-Meta: U2FsdGVkX1/z8JbpIiUF5dbtArXWvzr89cKtuBICdDfeEqjFMI0sdb33TRrAWCnbN1Jhy7K/sOa7wErpXhmKALPE3o/YBlaAySdwKrczhWijDU3bsPBf6//9heTDRg84mfRZUvQ9blBupP58Swpc84sUF3dNYf+3u8JEuq0ldUMd2zn2OOrup8vU4/9Us0qG5EIyGFQllhy1Oz1xlDpKqqMfZ8nYyqXm4f+rBk61aiJWbSUudTZmKF10TXN0bp6uOAM04Zu5YJu6Al/oEI9xgl0Gi7hWVkM+ozG03QVTXmYjQAyoTYA/ybqjOZVa3P3WiSkS6liPe2nEpy6YE58fDddzzw+KBoI0ljd2uA0pDnqlaFHNx91tqsviFP9g4STQwmkAzj2WvrNbS+bo1IDfMJNZsju9TyM4Hay4HDmKd6/ZWMacWJ2ONlH5gLXYFvcsBklLkcX4t6z/G1+FDK2MQoNVnsXTkkAYO2mmtl/ZcZ9FveMmFUF43O5d3jSkNr0gwX1Er0Mq9CaIPkw58WznGBgfMdGPcK4yxGwfjBAQ3MZvfMBHzSAmT5RlvVyxTfAJxa77HfkDOHBdrw1dRBB5Kf39bBTU1bLDGxA8pUb+1ehwJW+eTN77rE5oiOPlhiJ6bx+5rqF3kfSLAnjXIxDaQWsBvtvjBPMi6vC9LAZL1U5B+97FGLgdgVUgQwkipGiJP7h5rnbgPuyqNZ6kTbwv+lFq0o7uJqqrdZ72xpOV3n/1jQl0LDO/L9IsvvtVhLzHVTNbmMMkwEMXUixrvZxtMtsvl4emWa09lXd8LUoGYO0YGRRn12g70Vd76Lz0mlaRQ1E53af3AJvCJSYf1FvM4urDSBF6lSMu8A0RL+UpNM733iTi7cj9AC0wWqcBTjK0FB7sl/UTRtzytQZiHjvz9+asQM85KDslgCo8vTZfLs+fNzWcYNChMSXnJ5NY2Jy7hxI3STvVx/5xwwk1oYI
 3DE8v01W
 5/PNUcR9VRoPGIPTUncINOmmTLjsit7WfUnm5evmNYSzAaU0zayZOs3Ke7Ol9nLIh2Yi4EJH/8D+DATyGPTACZMf2x3zJRoBS4UywnxwBBkJPq1Ta8ufgsj8uzlJ1y+f3FJExSfsY0okMwoeHoN37Zp51Zzg8TlntmeORZ+PeIdar/4EOgsB0caUaBpg2XdtUq9aEpzMVaMK8T5tyDcGJhTUwZa4eNKfAuqg89W5akYxLPHgwRZUDvGXJaRtGf86UkQ9Fi4f6DEVndM1WQ2TbvVMRkMYPW51UhofbD9fpXSvnUNTBIiZqMAE6iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 02:39, Li Wang wrote:
>>> +static void run_test(int fd, unsigned int start_off,
>>> +		     unsigned int end_off, unsigned int align)
>>
>> Nit: prefer to-tab alignment in MM land.
> 
> Yes, I noticed Andrew (thanks!) corrected it and added to -mm mm-new branch.
> 
>>> +{
>>> +	if (!check_dio_alignment(start_off, end_off, align))
>>> +		return;
>>
>> Is there a reason we just perform that at the beginning of
>> run_dio_using_hugetlb(), avoiding run_test() entirely?
> 
> That will make the run_dio_using_hugetlb() have too many args and
> uncomfortable to read, yes, it's more likely personal preference.

Nah, just squash it. There is no need for this separate function, really.

-- 
Cheers,

David

