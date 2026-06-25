Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A542DCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC486B0088; Thu, 25 Jun 2026 08:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B36E6B0092; Thu, 25 Jun 2026 08:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0536B0093; Thu, 25 Jun 2026 08:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF0A6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:57:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D950E1C348A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:57:40 +0000 (UTC)
X-FDA: 84918436680.21.EECE18E
Received: from mail-m82150.xmail.ntesmail.com (mail-m82150.xmail.ntesmail.com [156.224.82.150])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55707A000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:57:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.150 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782392258;
	b=emq5kOFBev78k9qAZdgiSinLnkUDqT2gMxDkBs/uuu1HxvgKZKCClKTrJLlEatxCtt9ON1
	83nGsnFSR2mgxdrqj1TWOSkj432VVRt5TadhW/NY9mLr0CrZ/xuVteWlkXpdCNjtcpVniO
	6Z9u9rGJUll5kOkkCvtCIwmN4C34Iz0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782392258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HD1RwL+WKH1hPekjUUh0pgKQ3WJzHgZT9Qua5YWPTYE=;
	b=x1F9xuJ/jmFFn6h8ijn9JmgkEMl7YzG/aQ4QMRxHMgRj1Q6SUPa4qqu7vsuR430m9+o7ob
	AXNnNBjq6K9nHQ3H97xACRCncyng8Rzy/LhPYmMoOsuLu14Wwhc5yJazNQnCYBsCn4nqzQ
	j44VBP61GA2AYHOcoliqV6fgwybIbBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.150 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1be5b093a;
	Thu, 25 Jun 2026 20:57:30 +0800 (GMT+08:00)
Message-ID: <577bcce8-7cdf-4fea-b895-04fa5bda13ea@easystack.cn>
Date: Thu, 25 Jun 2026 20:57:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Yichong Chen <chenyichong@uniontech.com>,
 Ye Liu <ye.liu@linux.dev>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260624215526.ed20169b440c62d71a3f9d90@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260624215526.ed20169b440c62d71a3f9d90@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9efedb5ec50229kunm26bbcc47af39f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaS0lCVkJOTU9NS09OSU5JHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	hKTkxPVUpLS1VKQktLWQY+
X-Stat-Signature: 9bbnugutzruimphyc89dzd86w83s959b
X-Rspamd-Queue-Id: 55707A000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782392256-961008
X-HE-Meta: U2FsdGVkX1+wi7f4g20dvim8JdQgspTdy5232L/OpUy+e594O7AOT5u/9qukrHb3vZpPgcHzVLx4WythIIvzMKsiFpA2SEZbOSc7niwXDugEn0oEmdHPzHnM97cYzd7uhPl0WNpZeuLaNG7lYvfJ71wzbvDdCdG/WRxUOFZJRKecKrcZFtfGVSnFaY0xd+Qfo58mjnOHdhDpPrifUpx8Vjgljy4FDhhs+1j/WCAQBHoa9TBVokBo3WfHWoA2k+5a4sDJ2iw44u0MLyEubHmjJ0bxW3Vw6pg1TlbjQbRDy3Qx1H4Y5i5Ga20TlHY5/kG7eFMfPzlagofIaes2r82JJ1GYSjB7CJdZ/AzaYnLA1UnxmixpGS9BJLEaR4kdFLG+CpcxjtYSWLS7umwa0j58ae7vD41WJOBcDLYsXTlxGQfOShoMd+9jcXEZhADL8t7Kz4sNo7ao7bOvut1jVj2/WfJiCX3o7sALDt1j5IU3EHMq50tShNV/Qz3HZ/kxcpA0A2k6ew33OtD4ob8grOwEzJ/YGyfMKw/X/6OZMTVX32YqbEACLl2eaBJqGzURzeuAJ9pVKBUdliCUEkKsqlNAwqKfUb7YN5bbe/hSxyKZZitapco1ZwEsBHBvpRtqQx97kUlOgnAr9ZQp6j6uVpZJhLEU1+U4FEWXw8pzEQCS9Hb987YdwFIROzk0IQVJsx+v1A6S6lsQ+VWrVQwLaMHqlUKLwEVAEE7O4HQtAgjt29atvKJXm8NlkjrN3kxZPbPw8gNjGIjtgKb3np7DvQVfyiF5b+rKlLxA9/7SR8032r2Tt2CK3y9fAjeLIQFC7fQ+wvt2aWyEYqTkKgLjhfK8EU5ZwzxFSRBIo23GgR3Wog/S7vzQQrowI9KX73ZQYKdUUUlfCze7bVLE0Gni+WXePtIT5bc9uXFV2NOOEr+5ZO2OKd6yKBI0BXQZhhWjBSzdswizLNWwtbo2LR+r97i
 YGoaS2K3
 mv7sEPYSkr9QQz+0e1pV1K3G1WR2uiBNulBgWWW3dnm+9vvYmNTRXWUlqkcl5+cldi7F4/cIWcmP8IewzKZywV+YWz2Qm2+2GVs2KZNyOWkLOVugUz7KCOopCztk79uzXmj/k+F0btBBnsQWTs7fmXEqPqfjaJ2hkbeX+Edv2FoABf++epl1hGRRB+wo6I2Df5+tO4ABgGYewy+qw72dv71gBGoKo6UT96Aybcj8TgFqcaHpmG87RjP6aTfBZCvDLW5sdurlE/4mXDojUMo9zfcOBGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/25 12:55, Andrew Morton 写道:
> On Thu, 25 Jun 2026 12:30:57 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series introduces per-file-descriptor filtering capabilities to the
>> page_owner feature.
> 
> Well, I assume this work was inspired by your own operational
> experience with page_owner.  There's no better inspiration than this!
> 
> Review is thin (absent) at v11.  This is typical with page_owner
> changes :(.  I'll add the series for testing while interested people
> check over it (please).
> 
> AI review might have found a few things which you might choose to
> address.  Please check it out:
> 
> 	https://sashiko.dev/#/patchset/20260625043101.338794-1-zhen.ni@easystack.cn
> 
> 
> 
> 
Hi,

Thanks for the review. Let me address the questions:

Q1: Can empty write silently revert concurrent filter changes?
Q3: Can concurrent writes clobber independent filter settings?

A1&3: Yes, this is theoretically possible when multiple threads share 
the same fd. The current implementation uses short-duration spinlocks as 
a practical trade-off rather than holding locks during the entire 
parsing process.

However, I believe the current design meets functional requirements:

1. Most users will use the page_owner_filter tool rather than 
programming against page_owner directly. For concurrent filtering needs, 
multiple processes can use independent file descriptors.

2. Even in the multi-threaded shared-fd case, the worst outcome is that
    filter settings get overwritten. Since page_owner is a debug feature,
    the impact is limited.

---

Q2: How can users disable/clear the NUMA node filter?

A2: Clearing the NUMA filter while holding the fd open is an edge case
without strong practical necessity. If users need to change filter 
behavior, they can simply:
- Apply a different filter in the next write operation, or
- Close and reopen the file descriptor

The filter is designed for targeted debugging sessions where the
configuration is set up front and used for the session.

If you believe that holding locks for the entire write process is
necessary, please let me know.


Thanks,
Zhen



