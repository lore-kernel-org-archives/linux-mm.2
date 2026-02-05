Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B83ECD983
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083716B0089; Thu,  5 Feb 2026 10:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030D66B008A; Thu,  5 Feb 2026 10:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E751C6B0092; Thu,  5 Feb 2026 10:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D74436B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:32:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2782CC213B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:32:22 +0000 (UTC)
X-FDA: 84410794524.14.E37DB5A
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB5EAC0014
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:32:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J4kMAUbZ;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770305539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZCCu/D+A8/vQSICPy1kzHkrFU4nx4XMWizPhQHWKZE=;
	b=B5tpvr7q1MKBjJRm2X05vgKMts0ztCyFrCA6m2+/hvORDZw9yURLC1ydepKXEFv0LY9+/p
	x07P0KUARj769KEG6R6psdv6z8rEzRg/s3PcudzOwFlQx9JG4IAHBgr2XvSLjPP7CrWLGT
	zTfshZ5gzGujDYhwLic9eOP/7RS0dMs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J4kMAUbZ;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770305539; a=rsa-sha256;
	cv=none;
	b=eE9azTtBWNfFtww3k1xGTX6cxaVokiaQ247+v81KSOhsSQ1RbwxwvvF2AEEXOLfgOatulS
	CGCToYKIcWVDa9gYi4naGWsJ9ISWT/YRgLFG+YPw8gbIDd98cJDuV/58nlF0kW+sBbxj69
	n6j2tf9iOI8qY80o3dlTvNAKdvUzlN0=
Message-ID: <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770305536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nZCCu/D+A8/vQSICPy1kzHkrFU4nx4XMWizPhQHWKZE=;
	b=J4kMAUbZImqUoYGXnypA7JnwOQ6nbWXYNper/s+Ly1cCPQ7RG+AMBp08vyVNz/jHVoomLH
	peW91wvsv7DEEEi+N86L66kXjHcz1UF+GeftNiAXSBKVuphiyV+y27NFganbyWwBX5e5Xy
	01KUQfoTLHkARKXBEAIocUoDnlGa78k=
Date: Thu, 5 Feb 2026 23:31:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: tuwi64xsmqc8apx5h3gae7sceg8ygcdu
X-Rspam-User: 
X-Rspamd-Queue-Id: DB5EAC0014
X-HE-Tag: 1770305538-381677
X-HE-Meta: U2FsdGVkX1+wpGMA4QKYwmt4xEj3B4vJUo/e5GDHxtGSlNJaVHvM+AQFHRfA5ZYyIx6B9/xHzwgJ1b7ruihoo+rZQnlcwpHBY/3IKdYnKXHvqUarPw7IDf6TQXS1MHgm1wKnUC86qcoB9+a8nHeAH6dUx8qkreSDO0WQC2M87ERz0GkIX8Gb+7iXPsLz4bamRNI5S6SRzebJ6hX0dtLrYu+5PSridZn3tNOD+H+XVCZ0X2oSUfZoPNyzqHNO4YkI17ySmsyvUOuyBj4iEUUGPSZ4u9yztFiT8rpK/dTt6aYL7nBWuzfo7vg1TL29yxoRrWBRL6QUQV03t6nZYZQgRG9NK/Ksuf8HTodcSO0jytouXJWn18iMtxB8zh7O/OBOgVPdVbR2GZowsxpzIini8FIKb+U5Y4ZQT7L8lOsj5cxc0VgxufMZeABlOzEVYTcY1hDllhJNrH592v9m/8raTfqojK5123KCQbWC3cwW9rfob4QX+50xw9/GQwY+6IkRh7pXHVk4xml6KlqrG2Jz2xaTT/tWcNyTsNJFrmRMWCqu7965Q0tnkD9rz8g4eELuau52SadRPfDhuBjm7uIhY7ecIwBf5bjx+iT7V/0FBuZ9qJJ7ehGlgBqrJkUdyDEoa762gnTsQL1sQctNtreDqnZ7OrWjXMUX5Jp1uCbOggM0DTBhuWds65EqlEJGmP/eWSercEv86s35TIQNRqWA9/gMioC5zuduMu6RIz+s6FxQsw6kQ4bEfdeJPgs492OJkbSXSyQnmqR0VXidX/Ar6da15OQiIkqQKy5b5TeXzyFFGsYyTmeNFSNfriZwd9lS/jOclm5ROIGQW7gE0E6h6iASZ2SLBUk4ToVV/CA9o+HS9GLfIDGSfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/5 23:09, Dave Hansen wrote:
> On 2/5/26 07:01, Lance Yang wrote:
>> So for now, neither approach looks good: tracking on the read side adss
>> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
>> is too slow on large systems.
> 
> Which of the writers truly *need* synchronize_rcu()?
> 
> What are they doing with the memory that they can't move forward unless
> it's quiescent *now*?

Without IPIs or synchronize_rcu(), IIUC, we have no way to know if there
are ongoing concurrent lockless page-table walks — the walkers just disable
IRQs and walk.

