Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FB2D35154
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B168F6B0088; Wed,  1 Apr 2026 16:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC78F6B0089; Wed,  1 Apr 2026 16:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD366B008A; Wed,  1 Apr 2026 16:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA726B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:31:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 400B41B700F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:31:50 +0000 (UTC)
X-FDA: 84611133180.27.10DD18E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81C28180008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:31:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QFGj+Tqx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y197KJDP0dD4lqGDL7B1/1OW4ifcvDrgN5b1M60Uz2g=;
	b=y+gTTmfEunbVCU3J64Z6soiti1oygj5ir2uxVJtnFlthV+lVW3asbtfHQ8mavsO2G6l6zy
	UUGw4O7piEKf9NrhjzDYCWxoa17EHV35rusxWe7mpFTB9mVV6bbtFcXPZe99ph0L5kKto8
	63cmuYkVwrk3GQlaj2UsRJcE/5IAyx8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QFGj+Tqx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775075508; a=rsa-sha256;
	cv=none;
	b=3TtMRDFZDgInSLQFJOjW3inn+AsilwKfYrkUPd71g/CqGGYPudRpNRAL8wLeCX58bLzMAi
	il7h4ueQJ+D1G9ssAXims97dQKauzHFsAu3lzxn1YRtIkt9txsKgTx2hI478NjBjcNsB7K
	Thc2q7XB/fDZjX9Can9eRIHoLVfwWEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 731F844151;
	Wed,  1 Apr 2026 20:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D3C4CEF7;
	Wed,  1 Apr 2026 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775075507;
	bh=KCK2cUrZ/ubOAvnVxJj+KHP+CUfSw+QVN0xXkKOMlCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QFGj+TqxNjuAOC4xK35vi4qTlGzbma1asJSTBAuT62kreNNb7np8i7TmwsVRyg8UI
	 OxmukRYd2bxsaWBktv16rVLBFXvb3v2mFlvBM/kzUFyZ5F6sYRbWc0nREE341whOMe
	 ySXEQSYPpDmI2f9w8oB483hg9vRLQlz6VVIQCrhg=
Date: Wed, 1 Apr 2026 13:31:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-Id: <20260401133145.90b094a7b87bdceb0013b5af@linux-foundation.org>
In-Reply-To: <87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325114022.444081-6-npache@redhat.com>
	<7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
	<0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
	<fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
	<26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
	<440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
	<37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
	<9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
	<CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
	<87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81C28180008
X-Stat-Signature: hahun8cawuty6mqx3r93zm9swfbmrzx7
X-Rspam-User: 
X-HE-Tag: 1775075508-618076
X-HE-Meta: U2FsdGVkX1+EO5HhXOfxiLiDyFX/ETvc19X+U8SmKiigk69Srom4SIcRSEveK03t6xZYQBu6tOULSH08//Id81IXITDywOmMuuJ7tIPJFE/Zoq3rkkAFVFOntAOM29ZUFkMeGjoujt+ATM1DfjTVbzjasA+miufVAR3mWwMBwd2RqQB9i95HnJbSUKfx4R4li5+BQ6UFMZOwl8U9tQGH9VD51YEEcjUwzWjWFj2YaRatDlrixG7BVc6DfvqZK3aoXBtlgrkUSYK4VLmvUW4/s07TxKcH0hES3cZjijkRVdNoagGE4Zqv/yg71uuiMteEtoQ6sMq8d1765aTnjLXj/ON1sn9cJmOUeGPHnveql+uN+mz3V8f/PT5YUSEhO9lkmaa6//Xsw+4guLEUCFIG2pLjmowoGZXHgMPSLFbxNTMnM20dbPGbBHyisnbFnKNx1xEoYxrpcdAdlH5UIKNH7dPzSRikNpdFUBY9JMzr8e3Kwd0WWZQcTuYu7+3MCuegyJrFpr3ym0LRzjusMTiCSUmkZY9aCP7NQIBGdIUAQiu1oZ5HNs6U4SKD9lVvQ848RETbtv2nAEebSYLcIInyzhVU5XTT0U96sAvlOEmQbzmUPBTPKXUHFwop0shhXOGQ8sNfYLyJ35LWjA04xuUbMd+nsbyLWfWKsQTDng+UqBrsbK5ROXxzmCM0SmYny1APUoP1EAMjM+nWiJJG5kUB1cV/8w8UCObPHAOskdg1xlkpvWq8O6y7wJ96PnoQ3wTRbewEypTi1BCY4jijXdXyGlU9pBNMSTX87P+EPtzt0LLVmE+UpB7hsvHRqsHgdwQ8AErbLf/lJFbjpcQ2WMO0oDKZ50fGbNQIewlDz4IaIkJdIZKmU8OIame3r4DZAH2AtWeEHaQsbpxcsmhWYDxCD2vae+0JndhX8QIhYdzfiY8+eAMIsK3dxEkamkBsga12DHvBSH5HgoVQbKjcxuK
 cpLAajxK
 BClreDWf/c0WC7eN9IgnNZYxT1Lm9cqDLcIgkdiuH05WLc/xVojNtuYzRXhUSlvnFHunB/pRNEG0cWoW1jo5dIvrx86GWUJjUihY8yHAYIG9JJ5qy196arkCVqqezd41hTD4XccCXeT9m9k55S3/OJNYRefEmDM7rc68uYe7FFPgtAR/NUSs0bSYcz7UKfBxiy9NpH03cfBcgusumGXpqftzqNGZ/bPnSU0p9QlDULC6MGIlsUoCLmyljT93Wh7mSYRW/u3T0mdScLQEcuCmibGhSdJ6YDH0imiADTBTNm2fui9HoLKrD0o9XPeEWXerQF5+vQzoLcK1Vvpt1GpzT7Jg9XZeQTKJ/SbJ1fHZtMQsHup2WrsodF7zDKLApAwLAvSBcM/FEb0UE05ypTz0X/9JKdWGawg6TKyFG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 09:14:35 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Tue, 31 Mar 2026 13:11:18 +0100
> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> 
> We are incorrectly treating lock_dropped to track both whether the lock is
> currently held and whether or not the lock was ever dropped.
> 
> Update this change to account for this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Not sure if I should add this?

Should it have

Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse
with collapse_single_pmd()")?

