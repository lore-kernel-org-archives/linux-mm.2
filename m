Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D9C7D4660D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875DB6B0005; Thu, 15 Jan 2026 14:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D206B0088; Thu, 15 Jan 2026 14:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4C06B008A; Thu, 15 Jan 2026 14:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688486B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:01:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DE9CB998F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:01:58 +0000 (UTC)
X-FDA: 84335117916.12.7C509EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 543DD80022
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:01:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ezGyhA96;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768503716; a=rsa-sha256;
	cv=none;
	b=0wQpNSS/UCn6xzPG6oEc2H6Kme6bdSa1eKzskmJk7rYC7qBjHs/ns6SQ/r7duMO4e8PTN3
	vYkTTcoHE5uEUxXR49KQBGR7gBstqoX8HGLiOMTBtjKWsW93nNUSnB0917qbsIYTSiEBAk
	FkCzS3utXwdHXO758X+mkV+1Cc11xe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ezGyhA96;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768503716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0cSjcJiWhM80BWp/5XM4y02k6aOrMrBCRU6AzVKWcQ=;
	b=69Zz16ZfACkhHN7tkFsTrjRu+0zlbAiaJGA3cS7kqjkXKLIo/OLbDOBrLqAsL0UJgqjeFQ
	OKV4SiTjDeoXZ3Tb5S8p2u/pGw2RbaeYbigR3qQfHW5jPAuIF32sesTvqs5xygslouMcsr
	LUV+cthJFTokvDy0nydLHsKZ/tTYyB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A91643CE5;
	Thu, 15 Jan 2026 19:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1927C116D0;
	Thu, 15 Jan 2026 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768503715;
	bh=LHcYX+Z+d/gwODkx5g8AACAS429Tx2260kehahsLLk4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ezGyhA96PzgQpjxFSnd5n9IRmgI6kK4PszDio9VL5LHGwB3tKwtHaHyBfAKsl4V/F
	 vee3wJ5q8lg6BQeOODY4LiYvzGftz5EL1cVs6rh5IJypQxORLfuPSEJXDcWa5MpM7T
	 PQESeetoWGQZjBQ4hDLXs3nxa3VyaS2ZCiFJ/Fv8=
Date: Thu, 15 Jan 2026 11:01:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 00/10] Remove XA_ZERO from error recovery of
 dup_mmap()
Message-Id: <20260115110153.bbbce63a68df01d8cd4e6eaa@linux-foundation.org>
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 543DD80022
X-Rspamd-Server: rspam06
X-Stat-Signature: ijdqxuo89ykyt61qdhdeo5x8e1gnqth7
X-Rspam-User: 
X-HE-Tag: 1768503716-277422
X-HE-Meta: U2FsdGVkX1+DDzTOPMO8tGvlWJlIuwXnpIlrdspA7nxk6flUnBOxnWkZHIExBtxwtfBBRfYJou62Hf9x58sXvyt354AWoY8kIEYHFn2B6JVV882nQqcKGPreqroyVaDTj42TSP/EJ3q80sMIrOlDV9yM9/lUROQLAuo0xaEvSLNNVpxqvZZkLdjlH353IdEWUKBWSFj5Zdr0wUGxJakL0hyleKng+1WIg8R1pTGY3o8KUiNS4S19DoxnHa2JBI/gGw/NYjyUJ/SpKtW8RV+pIuVS+gyW/Dv214bsE4of/KZW0qSSw7npCUcI00oLF1Vq40ewVweVUl+FHsoxIlGW2bMz19eaKyXPCCKCH2XBc8j6VAe47Cw5mLSq9JWx/nWbF0uhWX8a8WUecTCz4Ri2qtjMZ9ztqeRB1m7HKOW7AAKoZoBAyQNnRQVRKfWz9d8e6IPlluHNuwMMQZPmSuDq/w0PMHunvdxI8qvyI8FNUy6Dry/EpUQpkmGFlZgW4mywmtI1CGAl0u++LTmeGglQ6PdRbQiWcoGV3gPPCyVLbjGVD7zHdz/U/PklYOLqKBKwV+g7qhKhXTx6gVNs3AJn7D6V74ly4ZDr1qGctJifhtRpSUJBIdunMduf7XAT1oJ1me4YNJPTOSnbYkzQ7VYzst+KZ/f6JqntBLXGPnvast5ISPw6q5QcCGMDR84FRJ3IytI+aS2brBzOdPxrZHcr3K9z3ZTWXKrEbSAHrX8aR7+47eQNTZwwu3lXO/2yySXJLukEn65+gCgS8UHW9xYIfpruKSeIiWNJYY0alT5XqWtEp1uwDdX14a1bT7Y9Hr2eTRYRTacwCnzQNhA1IkJ2Pjexhrz9HYNBNYWY6tjQVTU9bZ6K+Z07M1N5fMxmC9OF1ZgK9V0ZFTrsxt9ZOZgZDsHgis/zTStXMKdjfTAoAlDkwYmFFWWTWITGcX2nnNj14xnY/6Zgkqf2lHAIxir
 O/Mp5DYB
 xp7AtDhDjk/aCJkFt1TjoEdPXyLbxFjeAVGCpZzZtEmYcvxehgysbLSJUeHFi2EGN0+D8IqlNG6zU5hWjOfTxv8htZ04Bhp2+7Sm2aEVfrYOUVxA8baihAd242HXR13h+dPAEwtLbij6F1K7OOOEtpG1a1HoKgazb+/GYYES+PkFg8Rl7yjDlAyoJKtnFbKV13f43SSLMZ+odpFBHiodDCJgxP8O+vRBfxy5YtqJZ0J+71Qed+r5wixcekPYA4u/Uy8nQtBtbmjSohHuoHyj4oWHQ1KluJ7B90uvJOvnde/bAQq9XwTRHe5yr/j9Po61v/8RT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 13:27:10 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> It is possible that the dup_mmap() call fails on allocating or setting
> up a vma after the maple tree of the oldmm is copied.  Today, that
> failure point is marked by inserting an XA_ZERO entry over the failure
> point so that the exact location does not need to be communicated
> through to exit_mmap().
> 
> However, a race exists in the tear down process because the dup_mmap()
> drops the mmap lock before exit_mmap() can remove the partially set up
> vma tree.  This means that other tasks may get to the mm tree and find
> the invalid vma pointer (since it's an XA_ZERO entry), even though the
> mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> 
> To remove the race fully, the tree must be cleaned up before dropping
> the lock.  This is accomplished by extracting the vma cleanup in
> exit_mmap() and changing the required functions to pass through the vma
> search limit.  Any other tree modifications would require extra cycles
> which should be spent on freeing memory.
> 
> This does run the risk of increasing the possibility of finding no vmas
> (which is already possible!) in code that isn't careful.
> 
> The final four patches are to address the excessive argument lists being
> passed between the functions.  Using the struct unmap_desc also allows
> some special-case code to be removed in favour of the struct setup
> differences.

Thanks, all.  I quietly added this series to mm.git's mm-new branch. 
All being well I shall move it into mm.git's mm-unstable branch (and
hence into linux-next) a few days from now.


