Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9551094481
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 02:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D866B6B00B1; Sat, 21 Mar 2026 22:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37A76B00B4; Sat, 21 Mar 2026 22:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EEF6B00B5; Sat, 21 Mar 2026 22:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3DBB6B00B1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:19:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54B381B8585
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:19:09 +0000 (UTC)
X-FDA: 84572091618.06.BA7B80C
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id A4AC51A0007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:19:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CT9c+ixX;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774145947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dSaIRMuVhMrUs54qbaoxf4Mz2+8KV+v/+TX/3wx/Lc=;
	b=1cRQPJaGagAnTQx+yrtcci6nZwltiCe267QWZVZT5FnDwnR8ZlnYiB0Oom+miraBTncPlC
	vdjDQnDGBqjTOL61np7EskuYK3D5j8laf8ga9kCdFEo/b05GGJE+9J4TuLOLO8iHELK6zg
	1O8KKFfnYhpBcAEXZAy1a5HM6BhM7e0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CT9c+ixX;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774145947; a=rsa-sha256;
	cv=none;
	b=Yc410HCe+LYGmgfPSD0DUAnHdiiERRJxm/2nvrL0GueSGLNL9GQnNJz7Aw9P5ilFplpLHr
	ETlWlOqbkyrcqcWgCKYy2QLnU8CpSdvJa+DDOyPPqLcZG1yAXbb6n5z10K9fnkgj9jjdMf
	4bVTjvwDu/SdfjnOevuFu+gAr2Ktr48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774145945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8dSaIRMuVhMrUs54qbaoxf4Mz2+8KV+v/+TX/3wx/Lc=;
	b=CT9c+ixXjHb5VtwyDbprVHIreuwtN97fIwVMaaXEMzNpKtPYSnSY4StGDWxh6n3TH0+6xa
	VQCzOBsDue6qm2M7m6w/nHNLxpY4blLtTRnKpOhT3HVUHUHkyqKuX+Z6bo0FF4jIYysmc0
	Fovcn7H+NgcySMe8Pb1DLf8jnug9AN4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,  kasong@tencent.com,
  Liam.Howlett@oracle.com,  apopple@nvidia.com,  axelrasmussen@google.com,
  baohua@kernel.org,  baolin.wang@linux.alibaba.com,  bhe@redhat.com,
  byungchul@sk.com,  cgroups@vger.kernel.org,  chengming.zhou@linux.dev,
  chrisl@kernel.org,  corbet@lwn.net,  david@kernel.org,  dev.jain@arm.com,
  gourry@gourry.net,  hannes@cmpxchg.org,  hughd@google.com,
  jannh@google.com,  joshua.hahnjy@gmail.com,  lance.yang@linux.dev,
  lenb@kernel.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-pm@vger.kernel.org,  lorenzo.stoakes@oracle.com,
  matthew.brost@intel.com,  mhocko@suse.com,  muchun.song@linux.dev,
  npache@redhat.com,  pavel@kernel.org,  peterx@redhat.com,
  peterz@infradead.org,  pfalcato@suse.de,  rafael@kernel.org,
  rakie.kim@sk.com,  rppt@kernel.org,  ryan.roberts@arm.com,
  shakeel.butt@linux.dev,  shikemeng@huaweicloud.com,  surenb@google.com,
  tglx@kernel.org,  vbabka@suse.cz,  weixugc@google.com,
  ying.huang@linux.alibaba.com,  yosry.ahmed@linux.dev,
  yuanchu@google.com,  zhengqi.arch@bytedance.com,  ziy@nvidia.com,
  kernel-team@meta.com,  riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
In-Reply-To: <20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
	(Andrew Morton's message of "Sat, 21 Mar 2026 11:22:27 -0700")
References: <20260320192735.748051-1-nphamcs@gmail.com>
	<20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
Date: Sat, 21 Mar 2026 19:18:50 -0700
Message-ID: <87cy0wip2t.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A4AC51A0007
X-Stat-Signature: mry735zx64twor9m7zfxr555a6mu8tme
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774145947-826828
X-HE-Meta: U2FsdGVkX1/iF8R3C6Uod6whs+oF3gDjmhV1LA9FpmfxStxuImvNNd27c99pYV9Fq5eLxds5GEdVCp/K801tlW9ESxI3nUcUJqEyMWukDnKxSY4Ri3Gm4wFR8zA2G+iGUFoR94g64ZnDeqKQERPMZeLP0/Xn05ivSAH/FIGp1jIkhT0zd8Oyw4O/k413m70mNQqoNPvcto34KvKEnxgCL6wJQpfKuwEDHC/a6uqNKxa5B2TPqs+km11qsj/IMLBRYItZTorjxcgGlPzbok9F09Fu6P39tHLv7KESRMJPNfyRgVxaLQa1+cw0PF1x+XYWRsAv58p3myLULig0fveYR41VGengczy78ms7Ki9b6G0MUD9GyjI5JacYnxq62z/X6hvVAw5RIgBprUh2cNmmQKw8cqrhcpvyYQlmZsQFZMW6ivmohZHwhDvCoIVGUpoyOp2AtO1+t78Gz3zEElOgAbW5on7ULNsi2jdtKgsFHG+VCLS5AmSQd7YA8GgldsHiOA7I5xQMPY03UpDutPLmsFcZgRjIEw4hsDykTZkVxPvVZQ6zhRVEA58IOt1IWLiv3o6vHF5DaYTfwzuvHVkHplfhDUwAtbmnjRhBujo7xc9zzOCNuIrjC7UBvvESVLkIBDaujXPPztIV9YzSywOYR8g5aGNSbEAEUvLJGLeJVZg6lsbG09a7xQdQLBo4SqIJKAutEXrZnwnORo7p1VeJS2HuvYBZNZryDb7uh/bZLY707sbNm7Tc3OCs521dt5At7VBciMJHP8863P77oExiMun++E8ZRqdiTWtrH3FPYDBBxOwXYwoseHAzFv8f6p83SFBaxtjsyoypS80DeLDHE2161e0Y6dhBljAM5YqPiIAcrT+irbw9zUzrkP4M+ZWjOQi19GioxCMApL4hKVeJwlcFCZTv4ug6yWTvZ/NgjyfFuIysX0ecLqf5XG5U97Es
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 20 Mar 2026 12:27:14 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
>> This patch series implements the virtual swap space idea, based on Yosry's
>> proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
>> inputs from Johannes Weiner. The same idea (with different
>> implementation details) has been floated by Rik van Riel since at least
>> 2011 (see [8]).
>
> AI review got partway through then decided it couldn't apply patches.  So
> a partial result: https://sashiko.dev/#/patchset/20260320192735.748051-1-nphamcs@gmail.com

It's a bug in the error handling. I've already fixed it, but haven't
deployed the new version yet. In the reality, the review failed for some
other reason (the most popular one now is backend/llm api transient errors).

Sashiko applies the entire patchset first and if it fails, it's not
reviewing anything.

