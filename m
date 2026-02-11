Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F601E81BD2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAC86B0005; Wed, 11 Feb 2026 04:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99206B0089; Wed, 11 Feb 2026 04:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A306B008A; Wed, 11 Feb 2026 04:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 965DE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:28:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 522F713A13E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:28:39 +0000 (UTC)
X-FDA: 84431650758.19.C695B49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7928E4000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:28:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qZVXYvqU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770802117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7c5vh71thlyay7cNKJKDYQ9pnXHyz94LTTNgoVfOF4=;
	b=RpW7LpTHPeBza0kf1eNg1PmNp3e2XvUtdT7rAbZEpLuhqLXQ75CdWmT5nYWCkW3iXstrVr
	sT+ZhKo0XYvSgCE/L3RPaWhQThhrN9imlGxs1NapaITUiZkJiLAD5uDXgp1Ofet8ph73ZC
	QO+AhwZd3sYvNPGYiWvqJcUwIBknI/w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qZVXYvqU;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770802117; a=rsa-sha256;
	cv=none;
	b=14jcL1zgbQYhr49DmZPuPpru04TZe88p7RhbZKytXQjJ/bYXlNtGYdh1SLkJYvcmRPda8t
	o5mA3ojCPi8+uo4DCUv3dahg94l1ft08LVr7B7jUeVtQc1ZgTKZx+z07htCesaEdUw1isV
	RM7Jwp+Lujlmce4dDsDjOFZNdz3nj1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C06C40BD6;
	Wed, 11 Feb 2026 09:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB15C4CEF7;
	Wed, 11 Feb 2026 09:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770802116;
	bh=pOY9HpZc4cB550PofSf69VKd4oFcGg+ZGQ9glPc/n7w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qZVXYvqUVMAUSYIwLAk/cf3Wu9vMlZicQ6LPzFPuA9V/7EpX5AL9sGet580dOCPom
	 ihDG0C0ROWQLZ1SbhAMn/JFLDf119UKmA3N6MLgIZ49ijOVl0YMAoXAtkPEkx2xLCj
	 Bs0jfRkyyFJmqxUmmInMf6yjah4js0nnZBRyLfT4iJDkdslrcAZJKRnfFRzcNw6NwX
	 uz0Wt8++Kt1+mjG7pbeCi94DuNuTKkeN65M69JqO6r03joQLfyXNKlrrs0jiL9IyhA
	 cvoPltyeWbvFPIJdUZXxrpdRyNzh/CvemjMQrbCFmL8puUHydjrWZ04VtSvNCdhkxl
	 2KqNkxFEMnluw==
Message-ID: <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
Date: Wed, 11 Feb 2026 10:28:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
 Fangrui Song <i@maskray.me>
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xrt38z1upcdgjuhxw8iowqibprkj7epe
X-Rspamd-Queue-Id: 7928E4000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770802117-158564
X-HE-Meta: U2FsdGVkX19nJQEp4RsC0gCV9qzQu2R4lgLw7VKBUkw2UVx+mqXDgGB5MKg+gf8UKTXVS1nQ56K0qaXgKWINsp/p0TGgmQ3qzt5jC7nbn1tdEVB5t3JKmp6RXptBFPjrk6ktqu8nrOeECHJZfF96M7C43J1zQRrZ6yeHN2jdQeMfOm9XBcG+96mxC43XB890BTG3mAyeFJb5gKcCRtzH5Vi8DWlyhE+Txums61H8AxtVVILokxdWUFbRN4LD6bUkg7wQN2PS1CWdap4L8Y39tHHOyCcW/bzoyUFaUjuSwzTDHJfU7XUvn3PNDxdeXxipozFhEtYfozVTI4EUFIfulUjeHYCEL7VnEbUVrBhC6G4+gvyIFmpERw/oCHj1Zvf9yJXxbqOPPq4W+G+BQq884fQo0TIEccmjqxIaTOTALF6t9a//6nE6TL68T0fFxiklrbfAilg4T9A9Wzq4RCnfetMFBvo7HqHFdE54rvpy0UeIlQ6bf5ZnfFeQIYNB8ba63ZDddFj2PSX0gHZf3c6OETZEfd72Rd7QbOzKIwlKOvKMshAEaXuCZ8E1SAmD18PeYJxZ5XwlNYsfNZFRINfS7A8Ct7Fge/U12aGy135JSjfhk7OOIKdbKUrPCtFpa4Y7nzA/jtakbyhugxsX5aWmTF8NJghe5Ik7UXdnOLl2CqmxLIXiKrVOGNU6qB+kqlgsKPQ3L8Fek58nzEuWcGI0ZH7WNfHuWdYfBia3HMZwzP2ikJj+dzosl+QPlTRnb6IQQDu13RQkm87JDeailmRHdK0a3UQiQ/YO8nGK7pw/feFhUuIu3Fxiqc/QXp95V2jhjaUJiOUpvDiD1Fyszd6OZbwil2OBeeje9tPrq6u1UolFOnuQHU95OvPoGjffV5eIxA+Sy8Jjpytl3mHjGLSMs2bq2yqEH9GcV1VGeLJ+c/ZQfH1qS77/wrR+yY0Wlv+xua6XcsnhLSO1di9FMBc
 ga9Em32K
 Hazd40Ee5XXC6lbn52CVnczpYX5jOndLRuh+4qmqDQul37m++QiHfpnxem4SApqWXVodJ+gb3rAyX9IGyGO2P/tmlG+QTiNXFbwLKOyL3HQu7norThcPgTCEi1rSmd1XvkMEbDa4792OphtpkxTdci3t5dqbwSxdIVRVpLqkCkuIcm3TH9S9XgpC9l626GQ5bqXY/rp3qTjvwbWMnxoIY4zn+qt4n/qQy1xR1ccKKL+QJRYeK4tHzmpA3BGaiZxeCivnTJgowdgouaKIBzDi+m9loHHdxTtmWXpR42+o1lVbhY6Iri3tr9v0XxNFtgPQ4X7wKTZToV7Sdq4P7K9KxxucZBIEGyCFlgxIXjvLJIaMRKRofFku/sPgGfz3gGffHeEZk48hCTM6+ToT9L0qTXFmgfk0K4RIo9sT0BF6zQyOJ8u0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 00:00, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>>>
>>> I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
>>> we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
>>> special-casing secretmem like you suggested below?
>>
>> Yes. If there is no guest_memfd we wouldn't need it.
>>
> 
> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
> skipped.

Are you sure? We check for CONFIG_READ_ONLY_THP_FOR_FS before that:

	/* Only regular file is valid */
	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
	    (vm_flags & VM_EXEC)) {
		struct inode *inode = vma->vm_file->f_inode;

		return !inode_is_open_for_write(inode) &&
			S_ISREG(inode->i_mode);
	}


So if you have VM_EXEC on the VMA (mmaped with PROT_EXEC), it would work.
I think secretmem sets SB_I_NOEXEC, which prevents that. Same for guest_memfd.

v6.6.123 still has that VM_EXEC check in file_thp_enabled().

The check was dropped in commit:

commit 7fbb5e188248c50f737720825da1864ce42536d1
Author: Fangrui Song <i@maskray.me>
Date:   Tue Dec 19 21:41:23 2023 -0800

     mm: remove VM_EXEC requirement for THP eligibility
     
     Commit e6be37b2e7bd ("mm/huge_memory.c: add missing read-only THP checking
     in transparent_hugepage_enabled()") introduced the VM_EXEC requirement,
     which is not strictly needed.
     
     lld's default --rosegment option and GNU ld's -z separate-code option
     (default on Linux/x86 since binutils 2.31) create a read-only PT_LOAD
     segment without the PF_X flag, which should be eligible for THP.


So that one broke secretmem.


So when we fix it, we should

Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")


What about the following:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd..9fbe5c28a6bc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
  
         inode = file_inode(vma->vm_file);
  
+       if (IS_ANON_FILE(inode))
+               return false;
+
         return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
  }
  


-- 
Cheers,

David

