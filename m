Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E63CEB2C9
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5148E0007; Sat, 15 Nov 2025 04:15:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495768E0005; Sat, 15 Nov 2025 04:15:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384C38E0007; Sat, 15 Nov 2025 04:15:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 204A88E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:15:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CD0E13BA20
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:09:41 +0000 (UTC)
X-FDA: 84112268562.24.F4833FA
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id AFF0F40008
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:09:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/YUuAH3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763197779; a=rsa-sha256;
	cv=none;
	b=axuJGvcNKarQqwcJG4z5s5U65g4DF2AWmAsf1paPPd+zbRpeU9cADENjIvEB1wDxe2Ptfg
	EEkRL7L55vN+u6U7vKSIUcDsgwgCK1hPRCWxJkiga3nkH+V8dPKklCm54957sjVHT6q9PU
	YxEE8EgK8jBjlhH4gB+Z10noBfbdmY8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/YUuAH3";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763197779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfm+MQXULvTpw1aaUw2GJFWd+i9+TwJ4lZKozAzdhws=;
	b=NurpbOqLmDNeQCVXrgssWQfG+3G+nqxWiUq11lZaCPbhLabWfUDEbS74/755wp8jHenSsI
	0c/Tkm0q/CCqWF+ReGSBfhqGyrItLDuyKti636hoO1+kFp7Yno6KX1EGwrMOjlhDBwCEek
	hPNvUpnR4bUobYCMC0u3reYZ+qqfbpw=
Message-ID: <f7bd2dc1-e7a5-4e80-9cad-2acac8065876@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763197777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qfm+MQXULvTpw1aaUw2GJFWd+i9+TwJ4lZKozAzdhws=;
	b=M/YUuAH3IyWhHYn5ZNYhvN1s6M7xHKp63PCRpmUrEKXu53qQ1HuLBjIKdBsHH7i0tHGrO2
	MjXPtZjS13xHfyK5QioHDDtwAUCXkyGqTgTAJkTaZnWGxD0YWfwq7kF4quaoj4fCBUjoDA
	i6LWMMM3rWw68vjk72a2dDN7mW73xXw=
Date: Sat, 15 Nov 2025 17:08:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] arc: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Vineet Gupta <vgupta@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, david@redhat.com,
 ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <6a4192f5cef3049f123f08cb04ef5cd0179c3281.1763117269.git.zhengqi.arch@bytedance.com>
 <5199c367-aabb-43e7-951e-452657dcdddc@linux.dev>
 <4e120357-6fa3-436a-8474-b07b473381b6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <4e120357-6fa3-436a-8474-b07b473381b6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFF0F40008
X-Stat-Signature: g7a33n58kbgeyysyojsy93nqan7euq7t
X-HE-Tag: 1763197779-418029
X-HE-Meta: U2FsdGVkX19TSzwD5cLXWAf7O2UkZ8ie6rGFkhnw2SGWZbmG1fmL3bo9OE++7EfuhkuLlLbWH1jwIzj9qBwZcXbEdN0mG+kbFYLlroIgp/a3w+JQTbrWzvwagbKXs9NQ8Hmr7Ltl2L2rAutx60drODh3788ynOHJZtEyWRagwvdz1MJDuwqBqIw7gBkBHYUR8DImSfe8GoQoCkeUttezgTij0iBBZdq51KvosCB7ZXGYekeTDhZ7QX7wldSfMFNihlvBInniTqEeSP4nta23sI0r+NkQ//HtNNwiilazswaey4kY4kzdA5lC1Sq8ekMeS2DOaiUjJ5mYLsE+5UsIec0ZvMBm4aimIyfnoYAfoL1IQfnwATqFZ5U9JErG0/9pO41qBib6UpehuUeV8BHxcIrH0Fcg52rtJsnYnhwCu/GKqC6HXW5AgXcMrcQ9A1g/OdAiYmZo+buHiTXGoVE7FnFbwfmYbEH8CkjVUw4P5qFSi1Rq2V4tttsUp6bcruQVBImy5d2hsBMWNPP9K3R3BmENz941FGksOzO1NbSxheS6PJIOACWhtZcLNM6U3fiDl735yb/2b+4dzzBPGtvEaJnAEsR7Zk7tmbv7hAIj1YJggj4R4gGCy1BHJ88+fM3HqBUXfze0vdHyPLBiXKZjAkelXqCJPiZuAni84d7c4Mj04i3RtQNL3Hbn7sacy9zvpW9Er5xNBmse0F4cifEvlPeCrrK4qb5l8CYipEz3KjZXuCeRLlEDYaFVtOlX48XjYkVXfzRNfliUEEIoYui4lk7bF5qOOZzEBmi/V6lVrGVre3SO4SEboz+gQkakztJAfiJfELxYQjABLuPJ5gvrj6tLRzQhvSmctfYvNWS8l8d+MWnqRHhL/MOIXclICL48fJ5RIW8fnSRcjPtgWrsLA2pux4274j+mOLnHxl1/40JXnW4rfgv3PMb7mfTvkC19NeN6ycFtfs24cVORbBU
 gpGB/5ox
 scUStDgzjbgBjhM17kTY0fElc3ADMHcVVrWaldpYyyLDNmNkwkmVHkL7uYtsfOeSFDKH9mu4GGRep9adnWxK5nthFlpbTGTn3zmBL+NQVsRKCYVEiwIAFn94K/oqpkKVAzBAjY+Y6573c+6OH60DNeZqq7HQRNt6RT7yKVtz5E+IVkfNHcS6ogdhR3AaTf800dvyxqbZdgX2FzVYYB4V1JOdyK/AwlmoAcp46AAp/NR9kFdmyvTtJBexLsSW94XN8QLZ6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/15/25 7:10 AM, Vineet Gupta wrote:
> On 11/14/25 03:20, Qi Zheng wrote:
>> Strangely, it seems that only ARC does not define CONFIG_64BIT?
>>
>> Does the ARC architecture support 64-bit? Did I miss something?
> 
> ARC is 32-bit only !

Got it! Will drop this patch in the next version.

Thanks!

> 
> -Vineet


