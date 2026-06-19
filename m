Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A42CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B751F6B008C; Fri, 19 Jun 2026 09:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BE56B0092; Fri, 19 Jun 2026 09:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88276B0093; Fri, 19 Jun 2026 09:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 812706B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:19:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 077A4C2032
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:19:15 +0000 (UTC)
X-FDA: 84896718270.07.E6CE297
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2EA1240006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:19:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HNSAIoqR;
	spf=pass (imf07.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781875153;
	b=2LtWWc0OHMCl30g3/wxwinqSxa8+EcGjUorb62+KkD0lNYOqQihMkHHKs44LSAn4ZpJl5E
	GETtjZUqrl3yzxkdLjZadVUdJgm7G/PfHBH/kplMgEbtE0DLF81mKlAlPyd+1MaTbP3f/S
	YTj3bqLhaDRUuJACPtaTlOB3xE+6U2E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HNSAIoqR;
	spf=pass (imf07.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781875153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8RDT23gkMNXguGXL5C2X5G/nYVTX72HdDgIRNjQMbk=;
	b=3NH5BNCe7inn3Ne57xu/SSVAVUlWCSeU6wVwPf8VDzebJa8AVQ34hsA/PzYyouGfJP8Fvi
	HREQYx9E7hup7+YgAeyC0wv3WEk4CQ2buuWIVYfguXTHzITwVn2IDfXMKhQki8AUdj+rUv
	Gc5u6JWih9eqgKOB0olzPzVD3WnDmY8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5382A2972;
	Fri, 19 Jun 2026 06:19:07 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D522D3F763;
	Fri, 19 Jun 2026 06:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781875151; bh=IXPRMUIPVIuAYINomf/QT3LL4Z4pishbHkKoEcIwfTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNSAIoqRQuhLmKaaQOBEoRus9h3+8kB2v4jzvU25WorCkv6IPC04GdKMbynmzdPmX
	 DzfveUneQIpjba7UBaNnGBlL/gXeyBGteVAH8BUgPzcfSv6gfkCHHXbtnopRfJIed3
	 Ug4A/BUWCKr8G1v5YI4VM633WANr8cElnPDPi2O0=
Date: Fri, 19 Jun 2026 14:19:05 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Harry Yoo <harry@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kaleshsingh@google.com,
	21cnbao@gmail.com, david@kernel.org, will@kernel.org
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <ajVByfkLbetzA8bB@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EA1240006
X-Stat-Signature: jm956e7sy15ikwbh86b6h6jmez9nfskt
X-HE-Tag: 1781875153-3915
X-HE-Meta: U2FsdGVkX18YhD6TYLUEjLOaBLQHY3UU/YTCtzGDq9fsMeuXbTFIUB0TLC1QwuFiuqzphOOtOm1bO70zeEQURsOlrdrlAWyPY1Df5dlMxZygfQsyGrZkblNlBAkko684lw9/qGeOFh0pms+FNs3Q5gkZKg+aYsPzw9HKSRgB3PxkK7gGPhxFRoPP64aeaf5Ie60jN1/txZA8TnWmAwbplW67i6JCMKnoSiIggRjTxie/f2sF0QY51wZNRE9Ud1jM5smL/qsfhnbxRoY9GDX2CaEnpdKvnF8iG5IZXXEcAZ/NZVlmo86eb3zBHLaJfSEdaXX85FSIqAmyllYyOXOONDk/+xffH3J9B/wq06hAweB++iloIuRHdR03F92AV0mBqWblMNUbS1puzoCw00k8v8tSzMdcj5Tp4ns0+NE/5MxNVv4bsceJ8sJYLAtwRyG4HaqomvuGsoBMcnt8avq1iS6XrSSly88ogLNmhT0beQcUFLpXECLFClswqYKc39rbyuKAvoMhcdWfsoHlOPv65WktlAJCF6FJ0/a0jw2TuuQt4T0vWDP89SfFgoDxPeJUFU6F/HL8U2YP99NN49WA3RBMV2TrnUYjhRQKd6Q00iu459V8JvXhQn03LcFEX4aCW8K+Y6HEa2hu3lXWfqhjN4wxHNNypLIyatimkISst12/bhgjRzkfHC7Bmd9pSp1mVzgIzxr3SnW/g0zfl6IxgFpAL4sldZLee5xWTvs0lfVIbNpNGiNNFmd/F/L3c2ajY8Bbqh7er+uFcAZtM2JMSVMWDwJnW3V0lYNEYUZGoSJkWqhB4K65kIKPZOdxWKdvST+8d7kI15qGS6qXcMWZU05ZHNCiZd1iOk6AzbixnETqMVbV8W0otmyvP2Rjs8hJ/q8kiKTdPxrtM3giXo7jD1Akty4JhSAmD5NZDHJT45YBKDvIvysMbebBYNjIqER2MQ4EyIVjQSRGlEu4irn
 V4DyLy7Q
 0TlPyINlvLlUmKooZP/6BaY6P0udyX2Ho3FzbIQrjc+XkmzC98WpEZ0da1DgLSDYbMMUpZCjN/CDVR1y7Y7ssm+gS2S94y3wMtuKPdcRkcjoKs6onVJOZRaF6R2EvaTJQ1RHbmdyssL/ZdKaUn5159F27BYLFDcCLysEFZImfZDkc0/q/0w+jMmgLU7IFmfKYZs50if5acoj1vDSQXk0hw9BZAsDaIdcj69+4+GlIWKYJyr4LlxXWuHH1bIdCDSBya2UjR06fqNO7iMe+a6R30qadlysj82crszNG4ohJf/UK0vfhZ7zjz92i8RUm++SAqaTKR7270IJXCy8w517zgBAnfKWszv/AvKIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
> On 6/12/26 1:44 PM, Dev Jain wrote:
> > Introduce a boot option to tag only at allocation time of the objects. This
> > reduces KASAN MTE overhead, the tradeoff being reduced ability of
> > catching bugs.
> 
> I think most of overhead when enabling MTE comes from loading and
> validing tags for every memory access (either in SYNC or ASYNC mode),
> rather than from storing tags.

I guess it depends on the workload. Lots of allocations for short-lived
buffers (e.g. network traffic) may notice the additional tagging more
than the actual tag checking.

Of course, it would be nice to get some numbers from those who have
access to MTE capable hardware.

> > Now, when a memory object will be freed, it will retain the random tag it
> > had at allocation time. This compromises on catching UAF bugs, till the
> > time the object is not reallocated, at which point it will have a new
> > random tag.
> > 
> > Hence, not catching "use-after-free-before-reallocation" and not catching
> > "double-free" will be the compromise for reduced KASAN overhead.
> 
> I doubt users who care about security enough to enable HW_TAGS KASAN
> are willing to compromise on security just to save a few instructions
> to store tags in the free path.
> 
> To me, it looks like too much of a compromise on security for little
> performance gain.

I don't think there's much compromise on security for use-after-free.
The buffer will be re-tagged later so use-after-realloc should be
caught, especially if we ensure that a different tag will be used (I
don't think Dev's patches do this).

Of course, if you want MTE as a debug/bug-finding feature, tagging on
both allocation and freeing is highly recommended. This patchset is
aimed for those wanting to run MTE in production and squeeze a bit more
performance out of it (with the compromise of not detecting
use-after-free, only prevent access after re-allocation).

-- 
Catalin

