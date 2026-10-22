Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8745606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AtGBu3xD
Received: by kanga.kvack.org (Postfix)
	id 15F966B02D7; Thu, 22 Oct 2026 09:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137096B02D9; Thu, 22 Oct 2026 09:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B236B02DB; Thu, 22 Oct 2026 09:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC9966B02D7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:55:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C6511407DF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:55:13 +0000 (UTC)
X-FDA: 85350408906.02.6689E20
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C780100005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:55:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AtGBu3xD;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoNJWcYKe2EdW+Tn88m1TkIGzLa8lfMQNPaKC7oyglo=;
	b=RoaBx5RJSVVEXZZE5Q2ZN4kfxqBQJZBcqCoqRUrnMk8zFwpKGiaz8TGRywJ/9GV8D3ti0U
	g22DeEib/xnpniR0PkIyrPlAe1IDRzsE0MnT+LMOIHm7OXeRKE8Tc7ogO96AZujhyzPKsG
	QWjYFQEVJ6/J1u1SK+SMqeojAL0NSHs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AtGBu3xD;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677311;
	b=BsRfaH+QM4J21ah+f1K289s4eAcR178XyLQ/JskydYNZLGEMEjIdy8bSdX6achPtU8w/pV
	DszTBrqr9IFgsSPP4xQ8jZ4V/3UqCetDjUdKULPBfqtOg00SDm9kiZPBFwOzWPUmJjRzN6
	YFkErb+ZEUaXYM8QjZdUKJCRlbYpxtY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R+oE4roM4QVYigPw8/tQ8lEohznLJkC3Wn+fBwSMYi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792677309; v=1; x=1793282109;
 b=AtGBu3xDL7qBtlgkbQ+hNV6+lK0Z+8VfpDaoL62LGuik7kDK15QvNQcOouyxJC229ynBjbmj
 9xrSa5kQ9Yrbe663NxeSCVDClYFyL7RQ+x9LBSf4Zl3ACk/EKuiOsuHtEl9BhUBW6wY69IoPnfT
 0fNTi3QHe8aYDIpj03NsZzXQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 96abd4a0ca655602;
	Thu, 22 Oct 2026 13:55:05 +0000
X-Mizu-Trace-ID: 96abd4a0ca655602
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Thu, 22 Oct 2026 21:54:55 +0800
Message-ID: <20261022135455.90168-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-3-songmuchun@bytedance.com>
References: <20261020115824.823278-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C780100005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ysbrjwwbr3hpqx3z9ud569hkrpwy3qkt
X-HE-Tag: 1792677310-200228
X-HE-Meta: U2FsdGVkX1835godUoMyuyypDivqOKgQo3DeLVY2mjSgoP254v47tb6/MZQmTnx60k1UduhNqWmysCjgFiwDlx3ScTMDyTcuMrW817HnoHz82YD4wE0SzY2lE7DdZYpSa9U8+mWRBbouwm2H5ok+279O5jzhNx5QRluM2ovBGloRB0LM5OCJxjD1K0kXx3gr4tf98o/nEOIB/k+hNe7KSQce1Eyd7QSmXjYhuAbVxZe5lwny2HMH/HRzmM8xfu/jFH3+gW8S0s2xc5Rc1MehnJe/rEtEYBFNPrAOHGzlVAgCCFABxCBS3jzDfVcRFzB4xFIyG+q5CQ7HzYWRKHA52UCdCOE+lo6nL7hNpiGS4mjva3mmJ0g3RWnIStuvnUGVIciNW7PbXleqHvyiV0UWCerLJDx9EzvM+pTHL0csFalaUk9Abe4QDdAULjnY9Coh/jtGCA5ETPigKzvyiUGxX6Fe8YrkYAZC0KVgviL2iJgGPGsmKNMJn0gtVH8lIxiklJm3lTRhufH37iDIimEEu6kKrfc2NHKM41GmEFr3FcEmULg7NuRwKRyHv2uOYCH26fAfxASA9GI9EfuTuWRjYprMn8sBjdPc9mpOmkvTm5Du0pCV04C5t3a9PfNmIFhA3lzW42JEbmo/uUBtrIA5Fe0drgZa9OEp2urqSez5H+c+9bMD5Jbegz5ttYhWBxCRbUcQBFbYQrWqR+aawH5MNMBJsk6aROWiREtYzRa9OoWHl4azKoJ+pPNh10mMITF+c0c0btT/igas0X7Zt5d9YvnhyQPjPVzum1oP9/tU4jYv5EKTCKxLHOofp4qydAWMRVj26LfAw5n9Yb8NyfTwHy1M70wd/9JYuyMn8kpbvyUmT64dJcvOkfHli0TxHu58naHTeZR1jQF+sH5Tqgifv2QHUxpJytuq0SA5NNUZhdOrsO83bTe5warIDI0sjyam+4tBzHPs54MFg031/h6
 /4LZoWzY
 6pv+I4dlZXTon350Ya41hjb9UfMbGJXZCGldiFiQV0MtDCfHhD4ygUVdSbF37G4aC6yCD1bkQa6rIGyZWvQDB8jxO2srqYp55RB6xBbQz3buwv8kuUPHXXMuPqpUV1vF0bT6h91YVWrFTsDi5dNEf+qGxLkFfG02uimxrzcicuozOQQcfqXh7Iup+/NT6Z0bpQB2gL8pg0DIcIBlVo9VMWzuwcJ690DGyNluEv35K6a2THtU6r2PL6LtWrfW94SqZF508MXeQXvnVOPH5kPD0MifB12yDn1U4DTpCrHH13p3MboXhvS50sNnVkFv7mWZII4siYGEMCqXHdEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:16PM +0800, Muchun Song wrote:
>Vmemmap page allocation is currently tied to restoring a virtual range
>and assumes an empty destination list.  These constraints prevent it from
>being reused when pages are requested independently of a vmemmap range or
>appended to an existing list.

Yeah, the local list makes sense to me :)

>Generalize the allocator and give it an all-or-nothing list contract so
>the restore and optimization paths can share the same allocation policy.
>This also allows HVO head-page allocation to fail gracefully under memory
>pressure without triggering the OOM killer.

And __GFP_RETRY_MAYFAIL for the head page seems reasonable too. Just skip
the optimization if we can't allocate it.

>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

