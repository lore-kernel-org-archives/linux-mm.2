Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77E2C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 05:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605346B0088; Sun, 19 Jul 2026 01:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB5C6B008A; Sun, 19 Jul 2026 01:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAD26B008C; Sun, 19 Jul 2026 01:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21DAC6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 01:23:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FB601C007D
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 05:23:34 +0000 (UTC)
X-FDA: 85004383548.02.B6C8E8D
Received: from smtp153-162.sina.com.cn (smtp153-162.sina.com.cn [61.135.153.162])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0EDDD140008
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 05:23:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=HWmpuY8B;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf26.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784438612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pj1x/Gu8hhKfJ4DG1WLYHJmEM8/FpoAfuVBP2v5Ucs=;
	b=ASVKhoq3syB67gtf6wb/qTWuFeIh9AZIn8x7K0rpqnDoMD91wBd0i3IJdt+ilaX+LwLD0W
	PRXLSn99bIHEdAEtVcPtCuTAJwR9y5QqFyjA5MtSjxIt9wmErvZ0qsrJf+YHNN2Sy5CGmD
	3DrTXkesUeKDjuo18Oe6BuPHphc2C7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=HWmpuY8B;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf26.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.162 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784438612;
	b=0a1jHBkqPC7womxyJb3IDJQ/e/yBh7lJAhhQG/IKeFXGWAevu2zfxqSZzKwoil+r/irPmK
	Xl6Dohcvn3uKIRyVQnZjNfTHR2I+/Ds5I695I/wJ7ngce/tbgckCqubLpQ4DmpF3GjvYQa
	wPdfAY+3Y4A+pBeG0SP2F5uyOqiA1sU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1784438609;
	bh=/pj1x/Gu8hhKfJ4DG1WLYHJmEM8/FpoAfuVBP2v5Ucs=;
	h=From:Subject:Date:Message-ID;
	b=HWmpuY8BhhmdiMkkUTMzFuC3s/a4JU54BrmNTGJygVsZtNC9UfGcaO7DC0/2pXNNJ
	 acATEwXO4OOFb79s3n0nr1zSshtZEkeNVbB4rNDiSRpPV31QT0CUrX2ULsPQFci9Mr
	 0+M8USOdzd3VPLeEUEO3oq756k8lITeFfQJ75Y/U=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([221.216.152.105])
	by sina.com (10.54.253.31) with ESMTP
	id 6A5C5F4700005C92; Sun, 19 Jul 2026 13:23:22 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7737516815953
X-SMAIL-UIID: 80D67AB24EEE4240B4F7F121E5F036BC-20260719-132322-1
From: Hillf Danton <hdanton@sina.com>
To: Nadia Chambers <nadia.yvette.chambers@ik.me>
Cc: lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Date: Sun, 19 Jul 2026 13:23:08 +0800
Message-ID: <20260719052309.576-1-hdanton@sina.com>
In-Reply-To: <alw7RLxxmeT-moTk@ik.me>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0EDDD140008
X-Stat-Signature: 5riftupkq8z5q1d9uukjpd14bmjzwez1
X-Rspam-User: 
X-HE-Tag: 1784438608-234623
X-HE-Meta: U2FsdGVkX18+jvjltK81cyaYmzEXP0TrmeC0WXQ9fW5QuAf2PcukOOmiWF2XiznDU96RJJ+IWEdE8/gt80OtQ4As+2aisT6uBlTAQyW3viBFWn1uI9Ye3H4aPfTg0wRp+EnoPyUJcuu1eT3bJSxQ830xLCZBYbXzERoHWOtbeiVKDoBaK1asURrVTxsg98rhQrFY3spLvv0mmM3eyWaXmQd1Hpzwv4NumXm82HH8LJIb+GeXZnDHkRdwXEMRXBdnAZKcRa5caAaUHRjGz5rPJ0+OhwFEB/YjYprDfmmkau7wCkE9GfXSG79cfZRiXEVneRifIv3jMGGfxisDSo89AbyjapgpiYtX+685VSh7aAM5+2CBrgto7ZIIxKjxaEUkzUgUPCChjuKJtfge+yk4sw/ZCU63xtjcx4rh2bGvTO/goS7iYZVQ5k2I9FTW/puDfUj2GJRqZE9kANXGlhhm6Lv8pGXJ95pLYmBi8vVtoxFLXVZSDPBeW1OpFSVYexHfgguQWb+DE90Hf76H8PmZ7F5I0T57w1/mGLNl6pXcE2GZsLnKoeKmXCZ/+O+DNcdGDD9G4qxr5asBtjtXvjz3gW9veCSNQJJugewAx7ENQ7I1FVYqvruEF/smAuCGizQAKp58UCNqLGfF5U4A8sxq9jQY30XhfSQrP2/n/Tv8vJvZO5ikLGOSyb0NT7kBE9GkdatrzLjCZHFtV7hG5O8LoxkdQ9O0T/R7U9UbGCYBEH2VFQh/BBdlv/aTgAg6jtuSuyu5ESiCgNIgVcdFxqP3zagHt/e4bJquU+uh+VEtVh3QQGpHmD+03v7W54o4RGAmfb3BLaAkZ4J1Kb5vuUTQSNemwAtGYJtllS1XDhOJRLC9AThlzTQ7VPeG8wxRC/1HpO5MLbfARDxQR/sIM1p+D11zkaQBSs1itgNBPXfZX/ZML37tbT5Qpk8hZT1eAxplkfzFHBystCMWvFohpU5
 b+TzM1io
 U3R2mlbopcDK4QNaE0R8sak5OxscLGbXMrEpd9uoF5p6xfETaIG7em/AvkaqaBJnt/5L7Vk5++wzq92EGFkf72Q5gcWPC0uP0GNuzVoMaxldqmJ60UdfbbVbWNon0bPRHFmrc5A91hDgBo4AjIAKtbEJOzshOxKe1sn3v0SGxtjnsfGMeP+EzQ90LMvFUlrgzSLJwWcpc8hydCOxdHrE/kG9x8vqG2nD+o5Vo31vxPFHYYfH8h75yCQHWzUw1lBqnzWfN/bk+06oIMVwsoveWwp2BMPV1au9Wp4OYXeoUOKiuAAKEQAi3xAYpYrc4vAunTQl9lpS163VK1uO2JRpPH9X1kyPkp2mmmCu/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Jul 2026 02:51:08 +0200 Nadia Chambers wrote:
>On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
>> So a 64k page cache eats ~5GB of extra memory for a kernel tree (well,
>> _my_ kernel tree). In other words, if you are looking for memory savings
>> on my laptop, you'll need ~300GB of RAM before 'struct page' overhead
>> overwhelms the page cache bloat from a single kernel tree.
>> The whole kernel obviously isn't in the page cache all at the same time.
>> The page cache across the system is also obviously different than a
>> kernel tree, but you get the point.
>> That's not to diminish how useful something like this might be,
>> especially for folks that are sensitive to 'struct page' overhead or
>> allocator performance.
>> But, it will mostly be getting better performance at the _cost_ of
>> consuming more RAM, not saving RAM.
>
> Given that you don't remember the project at all, I can assume the
> IBM-internal whitepaper where I described doing tail packing for small
> files in the pagecache as part of an array of strategies to mitigate
> internal fragmentation and latency issues expected to arise for large
> values of PAGE_MMUSHIFT is also forgotten. I wrote some things I thought
> worthwhile there and I was hoping you'd be able to at least corroborate
> the one-time, now-former existence of the thing and maybe some
> smatterings of its contents since it's no longer extant.
>
I dont think this discussion could make forward progress without clearly
drawing the rule of thumb that which page size is supposed to match what
RAM size, with the supported page size put aside now, because I dont know
why 128K page is needed in the xbc/yz environment.

	RAM size	page size
	32G		4K
	512G		128K
	4T		2M

