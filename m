Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69278C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400886B00B0; Tue, 11 Aug 2026 13:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C196B00B1; Tue, 11 Aug 2026 13:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2528F6B00C0; Tue, 11 Aug 2026 13:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0E3B6B00B0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:59:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0181A140170
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:59:35 +0000 (UTC)
X-FDA: 85089751152.26.9EE7DF4
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98CB5C000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:59:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JQ9gQAla;
	spf=none (imf22.hostedemail.com: domain of BATV+85c1afd1256684b71d4a+8388+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+85c1afd1256684b71d4a+8388+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786471174;
	b=VFV5izU+IPvvzU2l12ipLNTimV2+45XTK1DA5AfDz2BnjBE19/aQn0phWMhz6MEHeEksKh
	hdFLiRWdoRpT0rVv/bLlrXkyqwr+dTC8CofkVh6fVYXMjQFdubeETDdsuNmq0Wtlp0vKWL
	UR8HJznhqdQz9O+8RCyqcTwevH1l1Oc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JQ9gQAla;
	spf=none (imf22.hostedemail.com: domain of BATV+85c1afd1256684b71d4a+8388+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+85c1afd1256684b71d4a+8388+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786471174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRvfQO9cDNEHPUpYghEoRHI8U5YFrjYdfy5eDC31QM8=;
	b=lRVhwrdJypwY8eQGWEE1OvI2thS1s4HirO1KXnmMA1e+2aLXscKCPGEnk58LQa+misgHdA
	8OEwgUuP1iev2gKjNN59eOeWowJDr8Wqi6FqlS8UV6tPyf+LYTYUb96p7Ce7Wd/SfRA0ne
	AE/H3Cu9W7e0jYwu0wMzSIzOWHYGV2Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=oRvfQO9cDNEHPUpYghEoRHI8U5YFrjYdfy5eDC31QM8=; b=JQ9gQAla8I6tnTLbk3jn327tur
	rLcbskMcowhYir94h3SCFzHud0Jjt1adZbaN+pCNn3G1fiNBQ/1Qg+qkKLcDGERFs06dk5qd78//d
	6fD5+pidgQpg0ZXKN0PQWyxBED7KbJzaM7JhRHjJ0Csupm70s0q0dgQeLf3tyX706/uibY8AUQV6N
	FeIM3AZPcKspNtCP12unuRSix8bI1peGmFumGpCRevkecSd/ulouMoEsa+XBXCoPSIgaru+4Wik3+
	lD3/TqX53NgO2RJT1llhhfSAhVg2tcLQilflaOSKq1Gj58q+JTeiI6upavSD2Qu5P63xchOiSW8sN
	9eXVBT0A==;
Received: from [2a02:8013:6d1:1:1427:d5db:df17:4279] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wtql3-0000000EpgO-2Qy3;
	Tue, 11 Aug 2026 17:59:25 +0000
Date: Tue, 11 Aug 2026 18:59:24 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
 rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch,
 jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260811172627.GN544626@ziepe.ca>
References: <20260811162423.GL544626@ziepe.ca> <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org> <20260811172627.GN544626@ziepe.ca>
Message-ID: <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 98CB5C000D
X-Rspam-User: 
X-Stat-Signature: yir5r9h8wex9ofqm95nudkt15rnfc11j
X-Rspamd-Server: rspam06
X-HE-Tag: 1786471173-56521
X-HE-Meta: U2FsdGVkX19mlaf6C/pz2h/kvI2V7e6DpB973bTMR1xgh1LT3KT+LnQM+bNfCE0ampMGUhAKB63wEm+YmvRHyFcL3qw83IpJUK+8tcTl0CN5hcz+u4DNWKXlZGaWUlca9pFChnMr3herBlezjO1/Sr5UR1L2B1IiCLpy4sQwnIK8W3atCARrmedUijAQTh7Vf8zcH84Q23dx5CKefSVyRcMEvprYZFk9IxPkSX6Ek/sWgUhNRh3vcO1oUeV5hVmHoDIalxfZ49n0Iwq62ROAHIJdK2t4ButTulfSEdRCS9FW8P5Lzo4p2xCv0bpG0O4MC+nz6snlGqDlIq0g9i/O9Rg0Y6mYg00CQJcHWkeIVwNVnJ1KCUl7zTFoN0yv4Sn3y+B1LjAcpH46MMbG2UhLl35tZX8XxcNLuocWBtqt4heO6uyeKhgr90wYd+0V2V2xCdViKLNdxTGE3Z1JqnfLNCNpBUrQq/wJOw3cjbPYcUahBO/mcOLhLbjoDjuclmFXCtCEIN7E2uklmH3i0IBSHrDwFlQwjXhIl8A/503ddUWeSTFIo+CglaT5zNaaj35Lo8qWnl0Uucyr9Zjf0axKFKDbKucP8+uSl+2cXZKSzyLD4RerPIsVd/8uKv0xD4G4IRo6iQKlXj1YsPCtmU3dfd6cks5IZlw/+GfCSl8ae26BqkEFKq1iOZGk5J4OnlvYA3hESyRAghO8B38m7V7qlFMk4BPuBb4D2nDBcXzwY+4EfmbDZHwf2+TRDjlPiMClaOfXttnoCAifG6RAD5X/4CrtUd5+JusaIFS/VfpCQyWUClr1hGfRzuMWhXQqCZVVvkzkxAIrzmrMDhhogBkdT65DdTQ4w1I4jMc/HvTOGXvyZaFjre5KgEe1XLtPWCqyHwJRL3tbkk7CmtJthap9/lBVB6uS+kAz+BwLUwWWVXoETv/JNNJgWeJy8YEEn07Ry2706OwE9rLn100TaPh
 y+54Z2SS
 xrel6px3aLNk1+mfD9uiFhD93fLX6kqlKqehZApmv92TiZd6gtLuvnyE86xh5CY4rslxPzoAdyJI6GejFEDMMMCRaxInXTR/mIBxrEZ6oqgfskzFdxqbpvsfKn3zfmAlxlm9agwa9Kqej+PY/FpSqizN0kYPdmvD87kgNJqluNELhkx9eVkQ1/fpwCzVFbUSELMwng7eXSw/OwAlRhRpWU9Fqh0ReDfKMkuCASbwa6z4Nd2Nu2ZFOK6lGaOuQ78AIfXKPKKUmlAW05drvyE+0jy5Z2lxf5voGz2pMCv++ZKmEC2qshT1KI176Rx3wVxIU+NZK7fAvKLzsscv+21zFYoq8CC0mEZpsgcS/UtlKTxWgKRHHXwQVRKVHCgNM8Bhmt3XDJA/h67GERKJ8pNefwf1vjRX7UHxeaDSF33YFnPlSz9L1fegYdDk5F/WZ+iuxK1w8D4JmYUKo1JPOlbDIXK00pXNuR3d1vwB/8iG4L5L/HiQpljWNyi6omHMWn2503fpRabZZbBwbksxZkYiAOt5yhM9VUJWIr6W3axxvmVLyPqznNISAe+5h2o3lrT9Q2CwoGetcpEdNgwijKdc55pjr+MDxEYaG9YPY0ADRHRVDzzMX02sMGQgCFKo2Z68BdRVGz9sNM9WGe8Y4olWHAotJGexr1FoXnSLWo0nQYeq1TxJNXwWpcF67IYheuDI4emkb/b/yHOdxrn2+VLwq4rOe2SJuJFWoiEKN7dxygHMovUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 August 2026 18:26:27 BST, Jason Gunthorpe <jgg@ziepe=2Eca> wrote:
>On Tue, Aug 11, 2026 at 06:22:12PM +0100, David Woodhouse wrote:
>> On Tue, 2026-08-11 at 13:24 -0300, Jason Gunthorpe wrote:
>> > To be clear you should not be using any synchronize_[s]rcu() primitiv=
e
>> > inside the invalidation callbacks=2E These are well known to have
>> > multi-second delays on loaded systems which are a completely
>> > inappropriate performance characteristic for these mm callbacks=2E
>> >=20
>> > This statement has nothing to do with deadlock=2E
>> >=20
>> > RCU is always a trade off, you can make the read side run really fast
>> > and the write side is ghastly slow=2E If you can't handle the slow wr=
ite
>> > you shouldn't use RCU techniques=2E
>>=20
>> The multi-second horror stories are about the *global* RCU/SRCU
>> domains, where the grace period has to wait out arbitrary readers all
>> over the kernel=2E
>>=20
>> This is not that=2E It is a dedicated srcu_struct, private to one VM,
>> and its entire reader population is a handful of KVM fast paths that
>> until now were under irqsave rwlocks=2E
>
>Are you sure? I've never heard that srcu has those kinds of properties=2E
>
>If its so fast you should just propose a non-sleeping version and
>leave the notifiers out of it
>
>Jason

I've got torture tests running for correctness on the GPC RCU conversion=
=2E I'll throw in some metrics on how often even in that pathological case =
we hit the wait case, and how long it actually takes=2E

And I can prototype the extra-expedited case that never even falls back to=
 the WQ, but frankly I don't know if it's even worth it=2E

