Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82908C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 03:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0CD6B007B; Tue,  4 Aug 2026 23:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772096B0088; Tue,  4 Aug 2026 23:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688696B008A; Tue,  4 Aug 2026 23:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455916B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:20:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C74EA1A0397
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:20:53 +0000 (UTC)
X-FDA: 85065763986.22.A2840C7
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92ADAA0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:20:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="p9bw/J/M";
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785900051;
	b=3TsPhkjxmFM/LLArK1OOiBZRzT4orj1pBCSd+o4wjaTlTCreKBHKKoaARKrZelDiH2RKB/
	jlXKWUMP4tAv4+rsk2/ZNr158ji3o0J1/E/7PVLwNgAkbqzoCE0KT1R1RBY4P8IyaSbQxY
	cmxYvGzqL3SzOGcpPOZcJVFaCWGCcMg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="p9bw/J/M";
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785900051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ4zAu9Mk3RCyEmBGHgbe0sr3WORbbBmO5hX6+6SKwg=;
	b=ZrgDEgslPtLv4IKUTO16QFBRxJpEWljmbrvLby12hyo7xTFeV837gCloclm3IvOWV3y4tk
	lBAdhLHlYS57WCRGrmu+6/Cx2eEI7biwda+juBu2F8EEt0hwXv15sn3EpkGBcyvuc+q6BJ
	Vu8ARskAX6xNkvtEwvm3E8zHWuvhV14=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785900045; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EQ4zAu9Mk3RCyEmBGHgbe0sr3WORbbBmO5hX6+6SKwg=;
	b=p9bw/J/Migv5d9U+0zJkMBHsAnqSqZbyZ9GPP3TVJN11xFNjxkQLltcUN8mOj1HoSXjTUBUaWsXryZ/c9c1GfvIDrodWN2Yn3BOr3wDc/XkHwl11/J94/97yAiHmKZpye5SG0wMhoEK/mH5ierMwGf7rnxaSQG93LPNtHmXq0vs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8PuU9P_1785900043;
Received: from 30.74.144.139(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8PuU9P_1785900043 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 11:20:44 +0800
Message-ID: <59c321e1-b58c-4531-bafc-5c1493d92309@linux.alibaba.com>
Date: Wed, 5 Aug 2026 11:20:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: shmem: move unused huge shrinklist queuing
 past the truncation check
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, usama.arif@linux.dev,
 brauner@kernel.org, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
 <e3d8eb0605eb8c4836fb1f376a0487328135b2c9.1785746588.git.zhengqi.arch@bytedance.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e3d8eb0605eb8c4836fb1f376a0487328135b2c9.1785746588.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 92ADAA0006
X-Stat-Signature: 1a83thsakz6u41ecnegd1jrfkadwqfzm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785900050-137441
X-HE-Meta: U2FsdGVkX19M3ehywVLjzFlY2xT5qfaXB3l2+SI1IrxUEX9bQjR7QoRQ70mPuJsRy6iGwOZ9QqKMdPR9gpDNCfyPY2s4mGOf5CrU8+FORBAPJZ87GwBV0XO/Gz1gXGsJUzy7VIC5VJ1sKj8b+/JwKNe7JuUhIomZa+Ykiw1omTZJWOnGTeUmOdNVegQr9s5ue+kT/ezH5zjcjgKV9JPFEjH21MHcxCzBTsMOOzJeNFGRYlmW2sy4L4Ls8mlzsNev6TETufK5w5zpshUoMoJ0rPis3zfVPMxbt1pj+z8XjDEA3Z13i0xAHNuU+UPxP/dmD01CMkdGcbYVB4E90yqxBEjnA3aBYqBVEzNz3rM47872XbwUGoAEJZ8iKsqM5dj7Kda7L3xVdfj+kHUDIVhxJWI8vFUSxYTWILkhJe8yhIvzNUIWt1flHlPfE8tbdKyR70VDrmN54MJrd+wnpOX1OZmAyp08SdFQLUaf6bUwH6a0O3ZWQ9yeazRlOYkKxArTcoSgjSYM/mSegeopWpnmdsIRrqy9nWZPiAigvfQJX88cozZiN32GHOk1enm+BrpdDw+0e8FCDRWJZj5RD6opYSbyb5mbbO3IsTgDjTY7WgodoENq1wDPQMSAqLzhXW0KWxJ76uON9AmzDxhkIZInYax0Yj6RWqkZJw4kfYaVgq2M1UzJJ2N+8Fc6CgSUIyl5204U1hMnf9liEbuVh1Njyq+kUTYqrruaFZ1bYw/6zrRhyDq2zSlpawvNoYqT7aXDJvqxhi1t6HYObz8mJFZHdkgOt8fqkfaw0KUp52P3bGwOLYb7m+55JoZwpOtC6W0S3azLuyLonabV/sTWOypszUF9oEjUaRLfTY911I+e5FluA2MLnorn9YebOfK6cgEqhV2EBQIKQAt07gt5DB1RDAgd50uhyX382+C1hG17zIMUm3sq2hDVqikuxZf57FjwyMYcbZiifchN9uclKG3
 S6Wd3kA1
 9atzLurKsbfiL4W748dDQVNZZAW/DAZZsUBZBIVzG7M6ZVzCogqyLLrRuk6cFfXyN02FtuzIDu3fjc0Pbl4/Wd323iB2cD3EuVPtfkE2AkP+6mWuPOkLcPLRP17oBXgs+kT3l5XU6Mvb7XTGpifaCajFLrp/ACGZl+BFEf0nuX2vbVBQ8U3VNVZhw58XrO8OwWWzY0S2xh7zWyMxXeNJm8SmLvTUkgM5pP/gISlg+TJebpm6mQlQdOJ4Op9uleuiVSNA4ONYd/hFpdJ778gRItjgQnFSMt5PptOuyRwCjU9lb0dW7KT1ToW0RN3/nyo606W0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/3/26 4:46 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The shmem_get_folio_gfp() adds the inode to the unused huge shrinker list
> at the alloced label, but a subsequent truncation check may still fail and
> remove the folio, leaving the inode on the list with a stale folio.
> 
> The original code works because the shrinker re-looks-up the folio and
> drops stale entries, but it is cleaner to queue the inode only after all
> checks that might remove the folio have passed.
> 
> So just make the pure structural move with no functional change, and it
> serves as preparation for the memcg-aware shrinker conversion.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

