Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B499F1093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012EA6B0420; Thu, 19 Mar 2026 23:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2CCD6B0429; Thu, 19 Mar 2026 23:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A4D6B042D; Thu, 19 Mar 2026 23:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D738C6B0420
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:21:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F85F5B400
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:21:45 +0000 (UTC)
X-FDA: 84564991770.02.576C96E
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54244140013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:21:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WNeekJYP;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euot9GX9Psoi1WN6TxY1zgk1VpiBJA8QKwf2sKbBPeo=;
	b=nL8jbOAI+UQhXLJbXudZLSAOZSKpmyKomYX15r6ittAcya4SHe9DDIerxeVyUpROt1ktjt
	XhGjfCPc9u51ChKeTwkJL0/Iiz7/9xTxTgsUTkwqlewdvySN6IGgXUkF3E6UFLbvn57txS
	q9EvsvPJrHsS6m2p9t8O4qosYefP64E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976903; a=rsa-sha256;
	cv=none;
	b=TaXiu+0pv4BcdkX25gU+1lgHBwEAp+83U9havR5oZnjKEujH7yBDw6I0HGtfjvRV3zCkPS
	9+g/yJpTB8VVu31dpT8vdYd2R2/V/FZzUd8lD+xzmD5omifsjNv/hgq1ra92VmaQwIyX+7
	SxEGPlTNGlK45/Va1uYPImX4JSZ1ZQY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WNeekJYP;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773976900; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=euot9GX9Psoi1WN6TxY1zgk1VpiBJA8QKwf2sKbBPeo=;
	b=WNeekJYPe0LKc7+v9ue9xJzoy/1iNkg2xnRG8rycFRmOAcDCvEQsAQ0CQzS/6+oaUiTxpExgwKSfnvwdGZZ7Zujav7KNpIgreUqDVFsK83f+cN6ibGRGv0kroILGiMJ3Rlf+IWeJEPdTXoW5vdep2pM2PeNuTGNN2LbbZGrkbxs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.K7P-S_1773976899;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K7P-S_1773976899 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:21:40 +0800
Message-ID: <ab7ea070-47c8-447a-8e9e-ac471063cf8d@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:21:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] change young flag check functions to return bool
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <20260319201839.2dfa704041b8f13d8dbbfd3b@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260319201839.2dfa704041b8f13d8dbbfd3b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54244140013
X-Stat-Signature: s4q9h6yagjuo99bokn9doe36kd4opxr3
X-HE-Tag: 1773976902-14306
X-HE-Meta: U2FsdGVkX18N78VDI/F8qBIXVqaZ0wc/2UwAYNl946fBCfOkbsRVCkjkg/ML84UYnZkxjx6tRqev6V9GCXPdTLwWiqBzc49NXfU3PsedKvX5RT0dnZJKoG8MNa0/4JLT0CC7eac2KyAzHqhNJFM+bnGFqnHZdr5iEzOeVZfT9Zdl/ZzI612v2fAsv4eTpt7diSL2k/CI9LytsrLplLdTcO74Its+LxTya81CGjqozVxFqBzGmk0H/pBGrm8uYxAvL/W+AavX/crwfCiNbxVgQW1HWc59zzKxpDntrwcPJfig0Y49lb/7sQdHzsjDWzrEl+1+N5Do9xeZl9wC/6B33ijLS2BFTZRVdJVSZRwyVrq5af2cskySgcX2GdtOyb2ytwnc2vwSHCQZXFQhkD5PcxyjlDjMC7R3W8sk0DHv6P7gJW3MTE7XMkZkZE+wua4WOx3++/2mf1m/J67ldgHkwmXjJamZslWKh0J1SaJ8jIWQ12Mcs/h5Rxd+hcl0s84GhjO/EpdbnRN04AyJqTQG3r0gqJWKYk6oRTVFAc/A9tdS6fXCRzWahfPQvrZgss2KFlCoV4HNvi1PrKtZ6WbMlYjjqIMGc/0LYIwr2Noldj9tIWU+LphNz6mKdWz9dxkVoWdr4yAHXnyPkAmdF46Q9wLNc6kLijvuIvxj17AP/Zo6Z6aYVvvdQFGgw/+VRiJfYrHutdW2qSYtjhWknWxkbLmakX11RGdpnAphw7jFwnSSvJ6tvdXGfFAqbP5obYz+fLo1Hl2bg5TvXV5mSAnnnDDfgMPlmM7rBzaSd1bwGBcAIdQvYhpjGSWI7YfM7zhlR7Fx4agVxLUtJKX06zebyxiQNz2PgBVffkbm5bX//8TGsgZt2a49FxMFDT6E0J1zJ9U2pNdwy7cJ1M72hepuHj08eFuc9pjSETAkG2smrgpwZnPnVuwDOHAw8cGHqFh9B4vpRcEq17H0wQJklq0
 7hD8eMMf
 H0R/1xEoyBaMobMFyH7KArnTq0TuiVPjPAJ9TjJHzKoliUKZswkAoPLiWwiqmXjf+cWrqCk6BX2KPxXMNrIUh1C5Qawp+4Id+Pz9wJhWgIH1A6CpFL3uQHIeJKMTJyOeppsMfxRxDmISx8UcGhWAkS6i+5MNUqDxvJfM6LDwKmlMiIn6CVgmZ4LATf1LmhgYj0sOwtbgPtOYqxAatmXX+ougyBEj9SkDiL/ulOW8P2qamtDrU/yR0dh60DuS1qQyciPd6LY+ctP/+p/+TUyIIfV68+LIeFwGYj8SngR0wRdhBL1Cmq6FUw7goQvMcWummA1qXW2s2oUw8alVS6XCW1nZDFDLD6CWwbgg1iBkCPJnzAWChbd6BlkzTX32Hkv9OiLDrHDFDw45pL9SC07z9fXALKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/20/26 11:18 AM, Andrew Morton wrote:
> On Thu, 19 Mar 2026 11:23:59 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> This is a cleanup patchset to change all young flag check functions to
>> return bool, as discussed with David in the previous thread[1]. Since
>> callers only care about whether the young flag was set, returning bool
>> makes the intention clearer. No functional changes intended.
> 
> One observation from Sashiko.  Minorish, worth addressing:
> 	https://sashiko.dev/#/patchset/cover.1773890510.git.baolin.wang%40linux.alibaba.com

Yes, good catch. Will fix in next version. Thanks.

