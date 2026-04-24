Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA8CFED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E30F6B008A; Fri, 24 Apr 2026 16:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA6C6B008C; Fri, 24 Apr 2026 16:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8526B0092; Fri, 24 Apr 2026 16:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 719F36B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:04:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CE5212030C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:04:02 +0000 (UTC)
X-FDA: 84694525524.02.6169CA8
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B5CE4000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:03:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUmPo52b;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777061040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gm9Vc9zCNOE3P/GhlVsvS6tFwN/kYtHjyT1Zy2zlkMY=;
	b=mOTVKwsmcZjNxjbI0BNJ4IY5LHNLffba5o8b3lnnzAXCCnDnlXmAqND6G6gOK5DJCff5UF
	n58JLHLDGy3VE/RdlOD9bIOvgQvQQZKVBwQhmeARbTqCnhPkQ+hPKdu4zI7w2lFyYfFwi2
	eKNeiiT5PZ+YpxKQEsFlN4m3bAr2W2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777061040; a=rsa-sha256;
	cv=none;
	b=lBgxK/xqU9WmEdRRvPZeRZ4e9cIaaP7P1KTA89kuUdO+0CqdZr+pUgawq370Hi+RMh3Okt
	4EtdyWUD0/9OzgpTLx9K7IC+grkt2ADxJy3UR2F9ZtunQTxUSFuayzVCbqdxVUOKkuWnRV
	Po1a6zvZvaMW6D93nOh6ZcHHX+gFiFU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUmPo52b;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777061037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gm9Vc9zCNOE3P/GhlVsvS6tFwN/kYtHjyT1Zy2zlkMY=;
	b=PUmPo52bP6GIdc3Tj/NyeQSPGZeASWCb676HK4WXkQSumqGrBWHkmUhZlVe5P8x4a9eNHx
	CtLEeBySRLbPG3w+MZ6QN+EHrswAmxH3Ly3l9w71PMs7OToMEATUPzY5gcEH0cbU3HX9Qv
	XKC1HNDXJguPEYb4A6ikM4nNvQYZBKM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>,  Yosry Ahmed <yosry@kernel.org>,  "David
 Hildenbrand (Arm)" <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Lance Yang <lance.yang@linux.dev>,  dave.hansen@intel.com,
  dave.hansen@linux.intel.com,  ypodemsk@redhat.com,  hughd@google.com,
  will@kernel.org,  aneesh.kumar@kernel.org,  npiggin@gmail.com,
  tglx@linutronix.de,  mingo@redhat.com,  bp@alien8.de,  x86@kernel.org,
  hpa@zytor.com,  arnd@arndb.de,  ljs@kernel.org,
  baolin.wang@linux.alibaba.com,  Liam.Howlett@oracle.com,
  npache@redhat.com,  ryan.roberts@arm.com,  dev.jain@arm.com,
  baohua@kernel.org,  shy828301@gmail.com,  riel@surriel.com,
  jannh@google.com,  jgross@suse.com,  seanjc@google.com,
  pbonzini@redhat.com,  boris.ostrovsky@oracle.com,
  virtualization@lists.linux.dev,  kvm@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
In-Reply-To: <20260424193529.GA3853824@noisy.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Fri, 24 Apr 2026 21:35:29 +0200")
References: <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
	<aetw4aoABYj3keMh@plex>
	<20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
	<80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
	<20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
	<644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
	<CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
	<20260424190141.GA3783056@noisy.programming.kicks-ass.net>
	<E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
	<20260424192250.GC3783056@noisy.programming.kicks-ass.net>
	<20260424193529.GA3853824@noisy.programming.kicks-ass.net>
Date: Fri, 24 Apr 2026 20:03:14 +0000
Message-ID: <7ia45x5gktx9.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B5CE4000B
X-Rspam-User: 
X-Stat-Signature: t91n5ikfkrck3ao46oqn991174aohe9h
X-HE-Tag: 1777061039-579047
X-HE-Meta: U2FsdGVkX18yIjNpdFQOuBpfCVGxGzR6WsTXJhqNrIMrGsDaDW7WIcwJNCYuDGL9fTMVCbZiXsJ3vzkwaP1SO8PzzSOFO3BuH2dF2Va+UFkYg7rW5SWd+mgHLKZdAfDvqOQsx59gGmAHM9HqmfqeYTqziSvO/Nui5nyHnmufGiIo2lXaiH08Z0RINnRr5AruzwIbfRF85zP5B9jNXeULsZ10JlOtFUB4AVlCIJY+8Ny6S9v93LsxmSMG4iyFyUgI2DOIONClhbjf0PEVjDuvhTY+Vv3V2XM4BsolVL0eWJvP64m5oQLAaJuqtd+JG04oC8cOn1QQ7OQRYbesTEQD+efZwkq+BGX/2+BxhI9DHA13ANNxIotL04QtWcRuRrgIKkD0c9Q7Rk6Pl93jDXlg7zqTCsyAn/UcMvUI9pdxd+L9dvHuxu5FqvmDH4gJgMvPl4juJoaI2r+c2e53Qg6Vl1qdITto6MK9tpZqX35iAYPW5XGoax2kWFzeIoBCmyPPnsIRvQBwnzHKFAC1/VesJb3c1fhgUchlWztJhoJON+paXkQCxk2f8yw6bZ2PcsXlPgfPTqnJolRyiA9KkaPU4jdexm23umwvclSj7S6mRJnPzgwlpPTUOizuKHxuEV4DC2Vlqk6pmMOPoNPDEzrq3kZA8ulOfb1Yy8jsqy+3MlpGs4Q7ye7ouMAb/atNJBhvKee8FKHkd6TgoV/TCG3hhtgl37247JoQF0oROByrfxsAXoKQHS+kASABK1IlfS2o45d2bPZRhxz+/GYCkhFF8nkjTU1IejD8OCVBYWDsjNGrtUBwMyn8wj0v3B1amWv5i9l83eWZ3b+lOzDyTBH559xWmxVH4G9Ms8kGT62wyCee8W8E0jkG8nHPRcd03Dim7kW84ZHBASzGJ86+8w2DLo5SIjCgEMV2wZlcv9R6eEYMYTy2EKc/7WkmrZP+92AlLBGP/FlDMmgefu0l6FK
 9ncd4GnS
 nxAersXD+S744FZUfUOsbr0fXBq/gRcKJ1Qhmbsx3YK9ALIDKmwZkvpAGOvKvS+IFOp2JdYQPX0p+7s6Yw8gp8y5rV75zEqWoJJ5UOgYp79/9gZN2PxAdI76qbUwI8hb8TSgnGI2aGajlPd5xmknrj77qEWR4vdhvn/Kh3Vt+DyY1O7hMTpMWAHEL9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Apr 24, 2026 at 09:22:51PM +0200, Peter Zijlstra wrote:
>
>>     mdir = mailbox.Maildir('~/Maildir/');
>> 
>>     for i, r in enumerate(reviews):
>>         inline = r.get('inline_review', '') or ''
>>         if not inline:
>>             continue
>> 
>>         author_name = r.get('author_name', 'Sashiko Reviewer')
>>         author_email = r.get('author_email', 'noreply@sashiko.dev')
>> 
>>         msgid = msgids[r['patch_id']]
>>         subject = subjects[r['patch_id']]
>> 
>>         # Create the Email object
>>         msg = EmailMessage()
>>         msg['Subject'] = f"Re: {subject}"
>>         msg['From'] = f"{author_name} <{author_email}>"
>>         msg['To'] = "peterz@infradead.org"
>>         msg['Date'] = formatdate(localtime=True)
>> 
>>         # The critical threading headers
>>         msg['Message-ID'] = f"<review-{i}-{msgid}>"
>>         msg['References'] = f"<{msgid}>"
>>         msg['In-Reply-To'] = f"<{msgid}>"
>> 
>>         msg.set_content(inline)
>> 
>>         mdir.add(msg)
>> 
>>     mdir.flush()
>
> So Ideally I would have 'Reply-to' header set to the original sender and
> added 'Cc' like the original email. However, AFAICT the JSON does not
> contain this information, and while I could use the mdir object to find
> the original message in my Inbox, this is incredibly slow.
>
> I have a TODO to use python-notmuch to do this, but haven't gotten
> around to doing this yet.
>
> With that 'fixed' I could actually reply to these messages and it would
> all 'just' work. For now I copy/paste when needed.

I can add an api to return a json with the review and all
meta-information by the original msgid, will it be useful?

