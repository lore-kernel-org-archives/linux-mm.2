Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E62CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661C26B0005; Fri,  1 May 2026 14:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6130C6B0092; Fri,  1 May 2026 14:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501AB6B0093; Fri,  1 May 2026 14:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4936B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:06:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C018DC0976
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:04 +0000 (UTC)
X-FDA: 84719629848.10.A9A3E45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 11AFB80003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:06:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKpbfCPo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFJO3kncGTLksH7oA9LcPI2XxoKPymWsz0S2X0yQsCY=;
	b=cTW64IbRNqmHwKX21RVkIVBtxaLfZJ//qKy3iTnuYezzlLbOWxMxSLAG7SXttdXlmnJLBp
	B6Swsi+26SYxDQKc/0d4WOT1lZX701wlKWmDPUSddeE6LOoOgRyRI0om/hlE6yoFWYGv/I
	TtaiK+PAiR2HaZkRDDWsqRzLZ57+7Nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658763; a=rsa-sha256;
	cv=none;
	b=N5bQrdMgKdMSEUigG7TZrnlAAdGz0iH0Ahk0PCZWd2xlqrL0mdhjBE4Kd330hQBxgZnQK+
	ZSdlH/FJ5HMBDd4NvvmAvHAx/8Z/xPCfV5G4jUGeMSjFmRdZMTDy/iO0d8x3kcJdOg0r2x
	CUuQsuZ9QHjw5hrARgFzEdFjhEte5ms=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKpbfCPo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B8A5600CB;
	Fri,  1 May 2026 18:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED93C2BCB4;
	Fri,  1 May 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777658762;
	bh=fPmJ2/Qb7QpFKxM1j5fPVHDJeKRS6/mwonl0EZ5/tEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VKpbfCPoBuOY0D6cQgJaK30uRMoPNJJ8fXi/i2N+ED9hzWASMbBbgfLQfbkBjQczB
	 mvadihsrsFi6vquYmNxB7GHpR0aG56bBaPVtgOvRbLZ0Es2OOAh81/hMrmUAhI3cal
	 PNA/UiUBzoor39onccj2SY7jtXS3CqLLwknXD9JfdEqax6nk0oKRXu2etncA0zFTFg
	 oaDKApOYtj0q7iC7p9oFXS4NsgnDx7nU3ZZsVu6s36pF943OertFMvMP3fFCwLmbab
	 A7Y+MQo7wTAjVXmphxN/18Nkt75YxPhsdsh77DXVmfj3ZOxDMxQyOFKNK88lQ30Wen
	 sgznQQa/BIpwQ==
Message-ID: <3a599186-6ae5-4175-8de0-1826a045222c@kernel.org>
Date: Fri, 1 May 2026 20:05:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <afIYFtL6KrBs38rT@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afIYFtL6KrBs38rT@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11AFB80003
X-Stat-Signature: kw6g6rinumb6j8z8r61fkbiypshm8oc3
X-Rspam-User: 
X-HE-Tag: 1777658762-699476
X-HE-Meta: U2FsdGVkX18JAY2NCaEndB/g6eMAzgnh2mGiaG/rIPXkNzQsEzzhSeOaOtjkLzf7PtMuc6cQzj2RpT5I9NrDq93ZPUAM+C/mwLbL5tKCfvaa1hugUmW6onj1IoMmMnKsZsYnccLsY3tgb38Ig41yr7nEG3/Fmo+u0SVV2pdQc3l2CZccQN3iueON+Gm1lU4kcj6ztAeNkf8Gp3c77PRjU+G1DvM5j1NZFoyyAC79rJ1pJ4BYcdFZ9Yp6jK186w8OcveJp4w+uYX9pE1o2NaHywfCBWkYM0yj7w6JEANSdgvkAG+ARFyZgWHSaZ/NGjor+Ws3RuIxJcOApVN9SFmu2gFmybSbV77qCsRxCEavxN2TooYzlbHiGBzjDFWOHpcHcjHOivyslxDUCgYY29I9W9B1WkxMMTq8hIx1/7pNpgtzbWunok0PbBgiCLs8f3BIxFHf14Q6adJRST8VKAFx4XJVsES8iJbuymL1YRca3YZaQZe7rVslAyx4y1WUviTswcfx0ubPYFNkTQdh4fPsRJh9HCEXu4TSwqWuw6KrRg8x5jdSKL6pvTsgqEtigfB1zKLzjojJbXESHX2a/KNLWbkcRNYSkRPB6la9O6NSE7qopcUlVWyCtO7N7WpiMexue8bjwOS9vU02oKwQPzxpkPZrObW6dDDt7XVoEOCzgB/HT06rxCP47uQC+ee7iD0FIFPqKJ9RCqB2LHKfZgcHNTZhoR6ERXCm1QzW94YeRE69iJTnQ6r6NJTA89cVU+lN6X6ZkzFoYvzXXBwiNazaODdhEqRc7ZWvSyI2diRS0fdGUIfYSaanRGAcTcMZ15rWopnxJtDRWV41RMQ/QXAMhSiLzh6NY60SdevGa9Gg5n2W5YMVejWTPT1D9z9/EtoQGZIQb3WL/NLYdYvx9pF76EimwJDkALqy+EDovup3M6rTfswgvOgAYRSRzAGa5a3yZSKaTh9/80oweq8ijMu
 uGqwhpMt
 dKDdSrfB810MCIwF9tmLT3sK8qGXI6Mqh/YQYusL6W2J18WtMy2vOSV+RLFq8H9oDdN0eKTOFArIyMcSovIzOqukdymUFBz4acaAEhPRaM331Um1xgEwZjopipvKMpZIdTTE+AX7wkzqXXsW1DlI9FaU4GPnUUGZnJzp5S2PNgZJHUm8U2PQOP157GzeB1vfzFN+gF1NSClJnTvPf5H14vjSnRin+bRjIM94fk5n9feOd73kBPOSwNC4K/B9Eho1mIoMG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Fourth, we change the unit of the lookup in the maple tree from being
> a PFN to being address / 512 (or whatever size we want to use as our
> minimum).
> 
> Now we can have memdescs for an arbitrary power of two which means we
> can ditch all the awful code from ppc/s390 page table handling where
> they try to share one memdesc between several different page tables.

Having a memdesc describe a smaller piece than a page sounds like the way to
approach this cleanly. A lot of work, but sounds like the right long-term vision
also when it comes to having folios that are smaller than a page.

-- 
Cheers,

David

