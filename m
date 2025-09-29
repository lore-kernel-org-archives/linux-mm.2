Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03691CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526EA8E0027; Mon, 29 Sep 2025 06:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD328E0002; Mon, 29 Sep 2025 06:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43ACD8E0027; Mon, 29 Sep 2025 06:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31C208E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:08:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDAD51DE831
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:08:57 +0000 (UTC)
X-FDA: 83941864314.20.2DDA21D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F5B8180007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:08:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eFxL7fWA;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759140536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYJ7vI/1TYz5Uw1E53H+CnlgjhFFABb3WbBnKQy9Lbw=;
	b=KOQqgi6zjnBFYu/u1tB2VVDSa6Knuc0oNmjIzzWlk4HQA6JswUFs7rmznSQ5iDHnGRDLQ7
	Q1zAQJbd+icdUSPJz9yzStSUFZg2PpdbhGCywr3ex8Eo8DiOHZ/HkI1YP4/pItFYWo/PxG
	0KV9mLDevgQai/z4gD51Zr4NPAUF5sI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eFxL7fWA;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759140536; a=rsa-sha256;
	cv=none;
	b=j2tHxB0UoR144mfTGmeAfNhJUL6D7O5fHU213dCL1JRzwyRq1OYxNA6IRN0a3lOEFpRuHb
	7LIyabLxvX4Pf4DPHiz4BxYTS1THY51ryBIoAfyWiSIAU0sIFBOAKgJpZd2dJTOsNjmWxz
	qQw/weAnSSOlmJTUCdydR2QzlsUPuwo=
Message-ID: <8476e9be-3f80-4d7a-9a38-f910661e61c6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759140533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xYJ7vI/1TYz5Uw1E53H+CnlgjhFFABb3WbBnKQy9Lbw=;
	b=eFxL7fWAcyhj2PgQZOqIzGLta1t80dO6/q5Usg4R53hka8Q4injGQYOvcxpCUZj9rp8blS
	E967y+86idHhTfMXLuWLUnNMZYiXgc4bM+IG+gg6ASsiWAmR1KNNs0laQZN1mpTUbpn97+
	TDVohSELPVVQX25d4FNYJLy2szcZXIo=
Date: Mon, 29 Sep 2025 18:08:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/ksm: fix spurious soft-dirty bit on zero-filled
 page merging
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ran.xiaokai@zte.com.cn,
 yang.yang29@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, akpm@linux-foundation.org
References: <20250928045207.78546-1-lance.yang@linux.dev>
 <e74ae9da-9dfb-4673-ae9f-c0b27b796cf0@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e74ae9da-9dfb-4673-ae9f-c0b27b796cf0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9F5B8180007
X-Stat-Signature: iyxdjasj9uwgcwdnwsgaswzdy4odh9hd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759140535-623065
X-HE-Meta: U2FsdGVkX19rq4nxckHaKa04HEsuR8rE41dOYz5BeIQzZmZ3GuO4o4x85f5HvVxxQiJDOgG8kAgzgWk0RXJKXWWwe70Ar/bW5u8careOlteQ/+0J/3xM7HkxFtVfJ4JttdqLTbxr7DywK7oD5CCFsYvLIR9r66QdbNAOhWQYZpakC5LGzzFfYUe+AIsMTpqhnVvMBkvE7pKxwYwW4Ofqv95TlRjT+jRk0OIL8/EPUE09TKOnVqC/xFCngaGMKabBuZFvTOnWMikT+JHUWHGnDvZ3icyf7UfcNDWJ9d0AindJcXRqzi+mnbn+Pnbg2G9UxrTiKmABXaBLy/ndGTiHcnKt8HZENgWtO+ltYS5qlya9VaRIOZ9TG3CzSh8lws2AvTfiEfdtH2GJwFdLWwKz4i5i/iqZ/W/0jprp92sbj2RZFOruNMxTaMXC27Wslmda8v/ifngbG7lis0xIKWts9oarbFcIgOTliqcu9gAn6xJv3zJT/9UuHC7LJACq734qg7DUeAFh3y7qBBoupbY4ypvMZrsKGmuWHPhlkJ+StcYw/pWRldLAAsWtY2OGbSUOH5TYofzQLo7AWwfbRKTrB5+bFMuVFLWGbIyaGLJJaER6Q377ZL8TAno+dS6HDVmSbjVX3Kuboz7GP7Rn4HmTZ7+P7Ge2u2TMz4DVQ4akUp8HCWjnWv05ra7NDZJZyi65Vj4es7qjxGHJZVE/HNM9bc1Fi2Prb9Td/tcZJb9G9pIgT3r1zrlMFYK2W8IsiCuZ2nXo1G4nPeJxtvo7fmJCjZ/4thFG48g1KEoIWlQofEpcW1/G9nJ3xGD3VLYwcTqedg69xXDojpna6yfpjdWk8Aq1DAJkIPhKfBB4fREmwhgIRoq9sceCTqh2zukOyn+DwYCx3SXJ8lkthzEnFBUKXrXbRWwPaZHwPqHQ2dOJod6EQY7HSLXskZRed0IJ6XnXc8s56VyuaiLH1TnzbWT
 XkvJTFVJ
 9De+W9WrIYNvrL0P/chc4isa79eQL/kZY/fAP7tt0N304e5a0akQJhPqVPMzSd7R/jQijXsEUDuXWNa/ACqw9/t+mSrexyktaQ3lZK+as6boFxXp+eotDTlshjuZXwMyAiWed+8T3N0RfzjK9PvNt+2/rUwW01P4hXzm8v7087+mxygPcfrlA0wGbij7o1gLAMCzm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 16:25, David Hildenbrand wrote:
> On 28.09.25 06:52, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When KSM merges a zero-filled page with the shared zeropage, it uses
>> pte_mkdirty() to mark the new PTE for internal accounting. However,
>> pte_mkdirty() unconditionally sets both the hardware dirty bit and the
>> soft-dirty bit.
>>
> 
> Right, that's one think we should clean up at one point.

Got it. I’ll take a look when I get a chance ;)

> 
>> This behavior causes false positives in userspace tools like CRIU that
>> rely on the soft-dirty mechanism for tracking memory changes.
> 
> IIRC, false positives are not a problem. We get them all of the time 
> when merging VMAs etc.

Right, Indeed.

> So I am not sure if this here is really worth fixing. Soft-dirty is not, 
> and never will be false-positive free.

Makes sense to me. It doesn’t seem worth the trouble to fix. Let’s go 
ahead and drop it.

Thanks,
Lance


