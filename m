Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710E0FB44B2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95BE6B009F; Fri, 24 Apr 2026 08:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FE56B00A0; Fri, 24 Apr 2026 08:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D7B6B00A1; Fri, 24 Apr 2026 08:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A93036B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:34:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74971A0117
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:34:30 +0000 (UTC)
X-FDA: 84693392700.03.95A5468
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C7F02A0013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:34:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShC8yNEb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAWNUOXPwh3V/JtwO/fiz2Bu8Y5mxhyrvgsra8QXoFU=;
	b=h50HNFqe1dYpOF4FwGU1Dt+Nq6IsuYReiuvaMn0ooHYUAZHsSTLYfZurKdt7b4oGzznYoe
	5GHjkrC+1qi9qQBx43hM1L647eHxzuVaBk27oMiEaQqgHVapsWerSEjBnUPR+i4e+o4HOl
	HbI4Oxm7cueSK5sany4gb1RqSpIIGwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034068; a=rsa-sha256;
	cv=none;
	b=v9fCTzZrO03agkoNnexo84m+oQPiZrAZIYGSU16rK8zJRUFR9uz8oKp7sBhyDTLPlkapV+
	QLyb/kOaxEx5GF7zE/Q1dy5sUfuTv5sqk2f82x1Olf83LddaAXeChh5EyUcY8FQ+5vM1Vs
	217IdXRqjY0qKOskf3rtKXM80YpXb0E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShC8yNEb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E6D560132;
	Fri, 24 Apr 2026 12:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1A2C19425;
	Fri, 24 Apr 2026 12:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034068;
	bh=pg3/saucyxrs3hRhxEU1mCMtPQYXPKzf8hqS6rUeCH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ShC8yNEbSqbNNaZN4bY4pN+MALe6bPdUrpfqj63TY8KSDuLwlRU72grzAyEdQwtA4
	 XIa9hwHjJI8s1ctritRWrhVVOnir2N2X6pdbXj97aCK9S6tYpPAkn+28kOdk1qjNZI
	 /KA0xRfdsnp2CNIeNJVj52x9O4ehsUDpMjpAQf1vk/+5J/wV2mom8SJrmSnjR5829T
	 dWUz1pFXBKPZ73j2COktPBXOD+cwzOyEZmRF7G5R2ISKepVeQJP8QHbUhcnrERIg6u
	 wqJnZ8Ph+77i3/yjWQ+kMorsB1ZrPAHPZZdOfBfZhkT6GPk+KQOXF2qugmgeBImSfv
	 j5ZSsrHrISQ5Q==
Message-ID: <60cd723d-82f0-410a-9a7b-c4d75a5c94e4@kernel.org>
Date: Fri, 24 Apr 2026 14:34:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via
 debugfs
To: Juan Yescas <jyescas@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>,
 android-mm <android-mm@google.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 lsf-pc@lists.linux-foundation.org
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
 <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
 <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org>
 <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
 <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org>
 <CAJDx_rjgyi-L-1j2kpi1NeKj+Huynd6ZFqJDmYqN8i8L3KyBfw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJDx_rjgyi-L-1j2kpi1NeKj+Huynd6ZFqJDmYqN8i8L3KyBfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C7F02A0013
X-Rspamd-Server: rspam07
X-Stat-Signature: nxxaes6gpqyycj4zytaxfo8hyz3ynkoh
X-Rspam-User: 
X-HE-Tag: 1777034068-656676
X-HE-Meta: U2FsdGVkX18VuOJw2chVPdA+5NYKGVz63A5a3dRtNsceRMcVI+yHjChzStAw+ZDad7InK2Noh2C9hTzfWllHh90ECZfy7IPL/3h3XwEmh2xAbsiOpIVKJjD6esgjvahv3AdeDIiSp8hNRudNcmP5v1CtqBDZfYJwo+OwinwtYSPoNeoZ/duzRCYyBrjOMXAhWfllGw5Ezv+39AtT1CO7DJJbK1PnIP7oymIi2nsWNfF32xv8jYIKBNcUS455jFawLUmMuzLTlZXeF8CnbceH0Hl3IsX0l/8pXjlto5jqCmmQaq83SvpUpDR2tcMG671+Hzddf7fH//5GlBsPjn3D9BqnPyMxkzlJWW3Yg5Xldohyo+WJRVnUwSUNRrqmysB3yuPd/cEZ7/MojUWNgjfuthOXAIo6qfYZTsFVtBk2gFrOBTSmbuwtDg/P8zmEJp0r8a7OyGuTX451Kdv0SRi0/9ZZQniUwjiSfROfhF4aKIw1I53uLPypaIQnV8VeEw0A2D1DML7OWUZJMis4ZLK64d49fVtcrglmauPwxNeqK8q/R4RwnHwKiJpxa9091+USpeVapSkvkhw6jK+I/lth/298JBLLWMFOT+Yb/Xtr4qlnA3iH+3FY+XAeuBWHBFAanKokna8K9P7/t2TBDGGVqMPzCogXnytEdcG6IoGlOk6okbVTiTn5MV/dIRAEOC2aC0L7Zj2VwnrEzious0KXMPWgy5tPepPwtrEYId8RDvCJ7Uqhs6OAe/ekIQYPe2zrPgIzFgzL5L560a4WLE0IrzRbIrTpyL4+EVvBdKp71lcGGDK0p0V+mNT+ILFGcPTXuSFqAZiGEdT3odamxzKtRkLMIy4HACI3NN1ZijHTWM2BqpxTUCSDAj74C/aRf4hTaYqfYExcL6Rb1K0/5KKBgHEpm+7vPw6HaXUx7siWg7SJme0HtUCthCAwLbMJsVb7U7Rk2MNWR9poDRxQh4+
 4oq54qz1
 M7J9GBLgkGa06HeHCGCbCwfsQgasR2m9/17GPu3BMxfimTK/lVLyqJ2tLi4wVOJNP4lhO1jr/zfQdZ/pfV7gZz3J33i5lOeZsfuUYizOhriCo+GfoE8crV+uILJvMmKMrQRc/S7tRzCf7A27ZLNnQcYRc2VXcllttfo8tv05eerrTjn5VWO29rC/nY3h0lLtypECQTEHciIzutCVoQFtcN45Rp9gXcf/2KkfeYPkvF0vIyt8+vmj6D+rq2tPkYbMQ4GmT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> So maybe you really want a debug mechanism to migrate a (movable) user
>> space page into a CMA area?
>>
> One intent of this driver is to debug CMA issues (pinned MOVABLE pages). This
> The driver will allow easy reproduction of the case you just
> mentioned. For example,
> I will allocate most of the MOVABLE pages and then trigger a CMA
> allocation, that might trigger a migration.
> 
> However, the driver's main goal is to put the system into low-memory conditions.
> so we can reproduce OOO, kswad, lmkd issues seeing in the devices.

(Late reply ...)

But there are other ways to trigger low-memory conditions, no?

So I think the real missing piece you are looking for is getting a movable
userspace page allocated on CMA memory, to then try allocating from CMA to see
if migration works.

And you can do a bunch of things to make CMA's life has hard as possible.
O_DIRECT the userspace page, trigger low-memory conditions etc.

-- 
Cheers,

David

