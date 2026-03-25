Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D5BFC72DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 00:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2976B0088; Tue, 24 Mar 2026 20:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52276B0089; Tue, 24 Mar 2026 20:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67C86B008A; Tue, 24 Mar 2026 20:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7C1D6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:03:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A3E316053B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:03:15 +0000 (UTC)
X-FDA: 84582635550.28.54D68B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7804120013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:03:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TRskfX5O;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774396993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s08sc4kAFvTO4YbdnNzQGMrAXZSnpdqvAu72Ux9zhnw=;
	b=5LKR+YVpkvaE2WliPUret1rj189zd+TEAHU4in/qmFB9p5Bidy2BTbRA0MLMVRbNLmC5NY
	VxmcooJoVKyO8YJS9/nq2BPuw/tmJFN/qoxuQF9tskgavBlq223Sfl+L5g05s8MZH86trt
	3gpTi5XsSsxv76BPKxenkck/4Cu2vbs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TRskfX5O;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774396993; a=rsa-sha256;
	cv=none;
	b=CHc5mw0G44t0RyXXzctp6j8eh4nt89HzNukSKaHuS27dTIKY6mOOW/DSUYzk8BbuZ6Ja9z
	VQmhYAPnsrWOIDbPm/GD7vz3pIfvhmP4Yy9ixZcZ4qgJSmynQz87lZC60nXBnnIrAn+wQt
	lW6aFQgj8oLa6XhkDXrIQUAfN4A9Z+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13BF360103;
	Wed, 25 Mar 2026 00:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AD0C19424;
	Wed, 25 Mar 2026 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774396992;
	bh=9f1wmmDRQ/xST5bhgNGmjzcn3IciZmk6Nk6ssBF2BL4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TRskfX5O3wTobE3L7tFsGmIeqmyMGpwrGJ6xjnepIeXmhMkDOQdMYtdjnoFJwU3WR
	 W0OO14ZyvCUXs267Rh00QnZGAhBMu6OpK/4ZU9l5xnCNiZ9Ar4VCWqu+FK4qFI48qu
	 qNWx8LsYrHLs4HTwFcfXlIKbWkn/VM2pqHBTquF4=
Date: Tue, 24 Mar 2026 17:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: jane.chu@oracle.com, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand
 <david@kernel.org>, Peter Xu <peterx@redhat.com>, Andrea Arcangeli
 <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, SeongJae
 Park <sj@kernel.org>, Hugh Dickins <hughd@google.com>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Jonas Zhou <jonaszhou@zhaoxin.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
Message-Id: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
In-Reply-To: <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
	<20260310110526.335749-1-jianhuizzzzz@gmail.com>
	<12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
	<CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7804120013
X-Stat-Signature: n3qsus85scsdy95paiyoi8tegayyyf4c
X-Rspam-User: 
X-HE-Tag: 1774396993-537955
X-HE-Meta: U2FsdGVkX1+cyKbztavam37J34IS7XYW/HHeux6VKds8kp+5Z1xJPQGoXwOqkLnOUw6QFhntWjMx+DTt4FTxLIy6B2TKvMx+y7AGdg21hAb208G5fp+fH4nCNqJAViJJ+IaFFLvyX6TgQIjx6SHFHZEkXs7EBBfEt8VnObu9Ggk2V8e7DyWw+B1O+8j6TWHfFLJP7xtdnFhqNplb5KzAs9cI7uwZYhos6Emfk4ys8akDDLcpoR7cXMK6Uye7YEZmr9WVlapEsPHogRNjFe9xvoZ0aWuzpBpf1zd6fFkv+D0lpoFQ1ezwiDZ5rQ2uP67kJh01EUSWYIkIVMzivA6ha8Ne8Pp8CWXP6c/NPZ9QUQpPlpqqb3a/MqoVSEyDrSd5454uSiC2zMoCnHcQmTTD0v0hWESzax9UgGd3b/qJak/hAqAQoigmUT0uoovdHSwmloWzmw8jZMDiAPAK+Vv7nnWSJFfvofGoX6MP0q4/C2Axgf3m5FMNDqtXjrQ9Lj5cNdhY9EyjE3OvnhBH3zl960OUAeliDcRz7LrJ6CPUIw7xb7fStqu7yDKm3NyQeCAeL8XlVuiBsFLaIRtpb9w4T7OU+RTHefvN+UriHcbyU9+ac3soQe+7aRYwmfPDtpWkNy/QLjUBP3JY1v/Dji9Cp9BBfXpS62ld9w1vK95DJ6CL8pMQ+bX9Uf3+uIXiJ0nppd/Xkybf4bPsNn5pH+KBV/5mbKzMzBwRAQhOjR1kvwjekJ7x9OP6m4fB58sZzeeH00GnoQZrt00VFyqOyGo3lokJy2AHhZxKfXsH0+tUF71PqJTNgs3QKX2/MZbfm0CcHt86uzY6O0X/RzzpCaFhrIENsxJTAVeo2QJC7ohdu1M1G0/Pf2Cojb/ZLIKamVUuXmuTgymdljEva5XKw4dcD9/qDJB4sysf4HfxKHarDVMQ7lUqU/tnBVNrT8qEuRZbJt5a8llNTUkAe/NW6ps
 rAnN/vfQ
 4lJQZ+qneN7QHzo+1MCwzD0hws9HNNZXVC6uDltGEnY4eyg7Ly+hB0dpwLk4K7HNLOPNqIjXQ5HAxCsPawVbKm2ID9IkFEyr1yEfV+BUnUl0o3GmNE6wnzjd8FkKvBJUGm/AQXKa2VqEQc3uPz6OOG612MF0ce18cO6p8R4tSJsIPS54UCl0Q3CXHQsGLRG0ZMcnOlWE26bBLj9p9+oL4MfpgOZgtd6NIRHwF/r/McBOu5cHwMabWI4VbRZVJFNh8oFZVKpZ/Qa5gwQUlw0ugQXpDsIiQDZioLVQxoAMACz7fMJvjOXMDl08/VF0UOKo2iZd9VyyRBp3OOFNfgoGBbIrIK0DISkLL2/1rKybPAl0kDr9zJHegpg5P79aZ22HUgtkp2kj2hZuux6ZG077rhbRMf5bEODLULQIe6OUEVOYjxbM5zE/GplVCmWISCFLpZqYYLhT+EBGQgmugeNAbWuj5yfTA8I6Qp0SvGa0ZD3G661UJBTVcDHl0lJHtkSFhaZ/ZKnSTygSJyGLT4HKSY+m6NDS4AJaPEAI+LAkR3sx7sMFxgQ8Wx7eLeWNqT4ndUCaXBO4R5YfgSzDvgQ1IkXrztiWjyV4fl1MAJAapKtY2dQ0zt9qmuVwKmP+QBIuusB4f1lH6XSlCkqgCYKxGyu0tj4eoWSlmZgPnxpma2ZVHUvxvfCOER4dEoyHELek1SwBS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 18:54:26 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:

> On Tue, Mar 10, 2026 at 12:47:07PM -0700, jane.chu@oracle.com wrote:
> > Just wondering whether making the shift explicit here instead of
> > introducing another hugetlb helper might be sufficient?
> >
> >      idx >>= huge_page_order(hstate_vma(vma));
> 
> That would work for hugetlb VMAs since both (address - vm_start) and
> vm_pgoff are guaranteed to be huge page aligned. However, David
> suggested introducing hugetlb_linear_page_index() to provide a cleaner
> API that mirrors linear_page_index(), so I kept this approach.
> 

Thanks.

Would anyone like to review this cc:stable patch for us?


From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Tue, 10 Mar 2026 19:05:26 +0800

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units.  This mismatch means that different
addresses within the same huge page can produce different hash values,
leading to the use of different mutexes for the same huge page.  This can
cause races between faulting threads, which can corrupt the reservation
map and trigger the BUG_ON in resv_map_release().

Fix this by introducing hugetlb_linear_page_index(), which returns the
page index in huge page granularity, and using it in place of
linear_page_index().

Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   17 +++++++++++++++++
 mm/userfaultfd.c        |    2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/include/linux/hugetlb.h
@@ -796,6 +796,23 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+/**
+ * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
+ *				 page size granularity.
+ * @vma: the hugetlb VMA
+ * @address: the virtual address within the VMA
+ *
+ * Return: the page offset within the mapping in huge page units.
+ */
+static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	struct hstate *h = hstate_vma(vma);
+
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
--- a/mm/userfaultfd.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/mm/userfaultfd.c
@@ -573,7 +573,7 @@ retry:
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
_


