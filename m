Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAE8D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 03:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACCF6B0005; Sat, 27 Dec 2025 22:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84BE6B0089; Sat, 27 Dec 2025 22:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE136B008A; Sat, 27 Dec 2025 22:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC7C56B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 22:43:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E75814053C
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 03:43:05 +0000 (UTC)
X-FDA: 84267483930.06.336BFC7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11C00C0008
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 03:43:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OVugtFUe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766893383; a=rsa-sha256;
	cv=none;
	b=zob4jPKKnWmtyGLJk2r+tDADk574viEul1ggWDuRjwo/a2hKHctz3080/bBm814MZi3I5V
	HwdUsAJdoL6Dmu5OlVJF0MQNRMutN4ypfQwIrmi55iMDkBu3SHzaYM2dsWGnlw04/TahXi
	Vo0fd67Zyli2nSVGkcMABS8hjZCdRxc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OVugtFUe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766893383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E1czr0P4bYeP4gGirjw5YdD3fjfTZRnF0cs94CurKM=;
	b=JYs2icTrjyLfZItJWQQ4IZnpA+W80N62ONEkTvwuupKZHQAV+thpNIityutHG3KIVRMzIh
	fK5aJ88nSL6cyn+kHAZjpBgbtqLNk3rq/jDxJ5epShuQEQD+XKLoc3RX1C5+Z9Ma2lDx1i
	jK8kcxWc8CQgD2uc1XJus5iOfc9TH2s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7E1czr0P4bYeP4gGirjw5YdD3fjfTZRnF0cs94CurKM=; b=OVugtFUeIzxtlINiiivlJQDWaD
	6t5oR/Ij0oueQkr69KPvNFnUxDbCQm28tVHsjOSR9H4yuACaa4aV9h0nPWHFAnJRsKqZVZHrfw7sa
	ZKBYd7w0g8nsjkI0aB5fKUsZ2m1DzOHwFrW5SODcxk6fj2gpflXD9Ir8O8cCGTcG4cyqRbmYnYDIS
	2nIHDRY1meTRPWr1b7PCfTKtDcHxogm2sPKnJObx73FLpOROP/X+Fea3v+nUITNUXhMuFojP5N1Cq
	d7rvH85M5S6OyK1njbZWHbN6H3XvuIq5Op8gv3+YYZWfVYcsoxWpkwMBP4KnHVV6mSJxBbcflKSnc
	eaTxdlWA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vZhg0-00000000PJF-30dK;
	Sun, 28 Dec 2025 03:42:40 +0000
Date: Sun, 28 Dec 2025 03:42:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	corbet@lwn.net, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, lianux.mm@gmail.com
Subject: Re: [PATCH next v2 0/2] THP COW support for private executable file
 mmap
Message-ID: <aVCnMI5gFLTB9UCe@casper.infradead.org>
References: <20251226100337.4171191-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251226100337.4171191-1-zhangqilong3@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11C00C0008
X-Stat-Signature: pc6ydhsadw1797pnnox7fow8cahngmj5
X-Rspam-User: 
X-HE-Tag: 1766893382-687177
X-HE-Meta: U2FsdGVkX1+igpcUWH0QjYEAIP10kzWMyqFA4ZJjYRLoP7xznbkcNX6uu/OfQrlKB2fYFQELkmB+Ja5PUFIyhiZhXujLUu5kVV+viA4c90BXIJKjS4r3r8FZuqSW0LBZC9AQ6VDvAbopMXyILWAX4LXc2Vbz2FSeHIWCMN0x8wYguaPFYAtW6djTpHRexjyH2RJfhuhNb81F+MBi52wRtaB11uNUF21Mh05P5yx5tVRQALsuh9+XO6CrH2DP23QahaWJVFNcJ5jnjerPin6DNZ+3dR5JBFvRtWWElGaEkm+vhfzGQBANe4hjqb5ZbmU0Et5aJ2bGW4M4mtyyuloTLrkML/BEkKuZ83SIOjEePNNL9SQw5Tr5Y9ATUwLOE6RTTphkSrme0vM9hBMM46fQoom//moTlfeizgYIahLcf0UNHJz7+mcGNNyRZjaNwb9r4qHbKyggiLPCObetMD93NqHQHSpwL44aOAtujfdATdQ5LViVVjUV6fhtExbDehxAbtiwGxwsFidNC0VuQlW9R6hwAMtvhZniXMYMdsvElK3i7fpOh+caPbD4PeQEo+3XydR/677gM5QCo/Icua/wNOyjlVtWijfJBFTHUrtK0jPiYr6Xiw1tEqZa6uG3ytJo0TPlrXAAyvhwxS+OBHPg3oFNJie6wPsbzacZuprFxrpp7+hsZ2LSjbyDOe64Kt059PB2sYE7wPORbIH+vKZZDbYs171E/skUIu7o2eel6qP8C2m/GxsgsWDrN8VddE09vkvSwWrNSkC/OrWZXvenU6oZ1Rm0RNCUoherAmvSkyOtmgSwgvx8jX4663j132CNpqZ+Iv5PX8PfX48OC5W5Vk67svJqcRQPAcnVXrnMSjSrLEhS+Yycix1fjTX37qNRBEHt4Mb+qLjPQEZSWZo34H3K3c64mVOIOuYRz1bhiauYqbKgyb3fKtw8TsrTfSLWUNItU9+auoO19nGoj0h
 g8VGTGda
 FykYr0pRfUiuuMn0BBdFE9CIiZ+n7YmXmAacJQixQ9GfpUj4MGAUKXiJ353SQrXDBvFLCsKEzllkpvZQDWFFPHUfrcSMDV34rSTGst8dhmJfryLGlsmwoTG1VQqdM6pPpAkayUxMjeUcjUUZrq0yrA6d7w4ScGLv4Q8HJwZWZpjCih9QdpSUGZK2FNT3ml6f9cs2Z1Hsdm+9/bT3euEXfdBtsROxihnYqKDXux8zJZao/vel4YaU+m/LwBhXhgSeFEQeRudXUHkrsQvzv1s1gunljC/TmjUxOwK/mIS8HNICsIDzEmAY5yTqaQ3VJXeo+yIPk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 06:03:35PM +0800, Zhang Qilong wrote:
> The MySQL (Ver 8.0.25) test results on AMD are as follows:
> 
> -------------------------------------------------------------------
>                  | Exec mmap Rss(kB)  | Measured tpmC (NewOrders) |
> -----------------|--------------------|---------------------------|
>  base(page COW)  |       32868        |        339686             |
> -----------------|--------------------|---------------------------|
>  exec THP COW    |       43516        |        371324             |
> -------------------------------------------------------------------
> 
> The MySQL using exec THP COW consumes an additional 10648 kB of memory
> but achieves 9.3% performance improvement in the scenario of hotpatch.
> Additionally, another our internal program achieves approximately a 5%
> performance improvement as well.
> 
> As result, using exec THP COW will consume additional memory. The
> additional memory consumption may be negligible for the current system.
> It's necessary to balance the memory consumption with the performance
> impact.

I mean ... you say "negligible", I saay "32% extra".  9% performance
gain is certainly nothing to sneer at (and is consistent with measured
performance gains from using large folios for, eg, kernel compiles).
But wow, that's a lot of extra memory.  My feeling is that we shouldn't
add this functionality, but I'd welcome other opinions.

