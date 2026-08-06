Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA51C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B766B007B; Thu,  6 Aug 2026 13:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C116B0088; Thu,  6 Aug 2026 13:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB6B6B008A; Thu,  6 Aug 2026 13:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB276B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:32:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DEFA12018B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:32:18 +0000 (UTC)
X-FDA: 85071538356.25.733461A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E92D040007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:32:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqKGBGIc;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786037536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7J5Tb1/e7+0o2iMfnVQiLZsqKhQzq+Tx+/PZqWQZOR4=;
	b=ZTS9EcsgxmEIQmXTNifyRbQrqmbkU8G1ypYBDpGSEfCOXgsEl7CorKqIrtkdbqn0INIu9P
	gTEWCqRAYAeUnavhkBZO9I+UbJOpba+ZlCEiwqwLWPASANwfTgpzWlfhkGUuUjNnSChBR9
	bD98JvPm1Xd04tbW0UqGnci1Cie6eVs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqKGBGIc;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786037536;
	b=lPHTHAYVTvo1L68sk1Q9zbMF+RtcinmoEc4bAVVMiuIFLX0cvwI/76JwUn6P9Bx0vyyPT9
	NLy1XiD6yOz87nbeLoelEzsKIENb1LRoyIVO8NSmUvi/gceOn21dOJV5jRnvSy875T3EOO
	qmI04YuR6ndSV1KcHAlKjZm46hp51wg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C24C60AB0;
	Thu,  6 Aug 2026 17:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1B81F000E9;
	Thu,  6 Aug 2026 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786037536;
	bh=7J5Tb1/e7+0o2iMfnVQiLZsqKhQzq+Tx+/PZqWQZOR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HqKGBGIcEZ/+U514vL1iPOo9QBRMCr2ok62HCPSwILHjFBf/AR08b6mSqHDEjaeFN
	 KutUxL79UxG002+LReaU0p1yGFhFC7M+yh/1MiQaeXZdBlS7PYjI0H9tHz+pQiATs5
	 4NoJXbGzZ7yUsQOYaynFGTV4ABINw+XLGwBubFYe2XKsem9mQPQWlIPZT1GdujLy5t
	 7sHUYsGGPpe20Hy4TMB7iE0OeCoue33lT9XHHBFBGyEYLevj+gtt3a0KpySvREVXv9
	 EayAToVMPG7VDJ1NUebZQUOCdl8yYL3evrEWKLlclZumx0v+dIeuzQS1yy4ri8AhTN
	 P9P8EQTM+ATwg==
Date: Thu, 6 Aug 2026 18:31:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anTCM94KoxY2nRaf@lucifer>
References: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
 <anTBN7WzVZukl26p@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTBN7WzVZukl26p@willie-the-truck>
X-Stat-Signature: k448yzs9zwyp74rhiz479jjj44fjhnhj
X-Rspamd-Queue-Id: E92D040007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786037536-294330
X-HE-Meta: U2FsdGVkX19UJB5jrHTSTAIrPCEiqWGuuPthyfp0BRO6X43WVdDxp3NutgavhwGD1WZXGcBHlKpAObmHQ0n3ct3s3yqeiBvhJDJtAmi3wl7GkASEmBTDyfD/k8jwKQXBu+TnWppJ/URUHhgjdO7Po2WfNeXSRR8z4yDbj7smBynCfBrsICs2Cri1WLyT6DQRnnsUShhpCPJPFgyEPvwy3sUyIzeeiu/n5Ld09tcTHk/hTdrKV/z16+8S7cjTo3Qjbf8VrlG494VnITbOGgb2hbrSRstD4XmBjHoRoOyEOpyCFhtC0uqFT/tb9rXHWLh42KQfjCZ5WqV04Xk29jK+kK0rGvCepXt4Lvi5JBQRcOimfvXMT9TBHozLnQzPGlluxJ0QuhI98GeAkJ9nh6FBO4NDQuzTYPT/HLrbQMOb7regq3mhNQa7aAvIOQuJuK0cht+IuWDFCL5TTyw1wO2R2x5Kp21AdLnFhdaiKQ343G6YQXGlmWVGWNZrrQdIJcSkxxTB3WhZSdSR4e+EHwkE62YQXuq1vcbrXCKQlHrk7uTbYZOngSOhB8kHRHdA4fkIKdejEj/GGyxbzIu/3GGzoITUuTu2RVtiOxs9d9Ykul+aFTEe9Cf5cFYbsRjOPzWTYQ0mhqLKjGVyqUJp/WICWNdaxRGzLUdlj+VNmpb1DU6rxpGL6L6Wwl8MSSRj9Smybo79HQiiJxd9uXlZPDmI5L1VFUQGR758MgPiA/0WSxeECTbJi/PsHNhyzlizC3hd9TAeVRmmI26glfVTXEziSaEKn3SQIoD0+B3fljQFndmubo0na4IqRN48nRO7zrL0kfsxMFuCCzN9mDsvyZwm7ggJsGE63NyhiEGeKGHyV03Q0PaZx5sDnSW1vFc3CqEsJ69ijtxKCVkpN4YP0OXyt4/VZd528L9c7BPGazr2JkTrB/M+Rqr7tD09PZrKL9xjL6jZ8P1p8p8z4F464FF
 c6EYAAl5
 kwvlsjrv2FFTPmYs2vd6hB5C02mO6gWy/VRExoixAp1LyWlYXS4X3gpaGcqiQfwjzyQ9GxsKipB56ni8Le/qzR5XYngQAxYRnhOkZ45wzeb4gQGicx0k2L60O5sxJYN6VRbB2nLTZ7BA8kFygChHORCAeP23PW5c9D0kEee5vYSvm8fftsDNHc5DXv96F1+cXYLFl4IG/5R0RmAYUc11ZXdGaCh32N1Cwn8u8M+dDTGSbdD5KiRApZnv9aWedBus+/15EgpMjArXon+OC5H7T9ObD7o/gYPSnQY6Eow2Xwl4JlvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:15:35PM +0100, Will Deacon wrote:
> So the nice thing about having two implementations (i.e. the per-cpu
> page-tables *and* the preemption stuff from Mark) is that we can pitch
> them against each other to help us make a decision.

Yes exactly :)

This point has been put to the submitters a number of times so I hope that
an additional repetition from an arm64 maintainer helps underline it.

>
> However, I don't see how anybody could argue that Mark's series isn't
> cleaner and easier to maintain.

I completely agree.

> I've seen it described as "hacky" but I
> can't tell whether or not that's supposed to be a criticism. If we

Allow me to translate: 'I want to ignore this' :)

Similarly the comment about mm maintainers wanting maintainable not-broken
code being a 'foggy' position. Translation: 'I want to ignore this'.

Since maintainers decide what gets merged the translation gets flipped
if the submitters fail to address the feedback.

Let's hope sanity prevails.

> seriously want to consider the per-cpu page-table approach on arm64, the
> numbers need to be _really_ good and across a variety of hardware, not
> just the stuff with a memory system made of baling twine. That extends
> to the kernel text replication efforts too.

Thanks, and equally so for the core mm changes that are required by the
page table approach (that requirement being attested to by the diffstat).

>
> Will

--
Cheers, Lorenzo

