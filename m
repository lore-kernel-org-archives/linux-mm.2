Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ED3FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 22:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A056B0088; Sat, 25 Apr 2026 18:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB226B008A; Sat, 25 Apr 2026 18:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E11F6B008C; Sat, 25 Apr 2026 18:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7316B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:01:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B0FA1B7E4D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:01:35 +0000 (UTC)
X-FDA: 84698450550.15.EDAAE87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9589C000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:01:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qWwiMSnu;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777154494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4ZyFSJewBdT/Qacww+YVMvNuE01OJQh0jvK7iyNtnY=;
	b=gHMtz6N3xizYZ9Gg4t/E36sVVAU4J7jsWS4SR/9ktXFfQ+ZYfcEU0FFpfv4tN3sHvbgZOA
	z1tC86rr3t3ggD1tDwmhyTjVO9tC0Q+j2tydfyWp+uFLfZ2PGjmaR93/lCOZp7Dbv37z2y
	n4ctpJsSoe/kSBkAcwl6E01s/8v459g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qWwiMSnu;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777154494; a=rsa-sha256;
	cv=none;
	b=8H3g21vmC83myrmwYFlqOQRcIUEEoBV/Z7jQBt4fEivrFesD5gJcxNB3l4yGlbM9IkA6F2
	EzVLKzG8XeReszSWHJoMQBXdVjIe6SXIyGX8zARCjZo9A7nosSxFetjk21MsWEM29lzH7E
	8A6+1WtcQVvm1TgLN5B7LwuxOGi4KA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C58940DFC;
	Sat, 25 Apr 2026 22:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94764C2BCB3;
	Sat, 25 Apr 2026 22:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154492;
	bh=0NuIDsEyNQ/Ifatv/CQaE7y12IP9xQxKHtJQ4WrtH/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qWwiMSnupHPl2CqJmPf5mv5cppTi87sHIgN8pIR1OUU5pCHxR6Hc+Oek1h/58ER7s
	 lIxgZPW9kw83+47mMnBo+ffv2OfnZlPugTdXzLSWW3ze7+vEtzognUMoc2P1bhJb6q
	 pyfFW6pYNWDsZj+NRecEwCULFziFnLmWvOW5PlxM=
Date: Sat, 25 Apr 2026 15:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu
 <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
In-Reply-To: <20260424024915.28758-2-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
	<20260424024915.28758-2-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9589C000D
X-Rspam-User: 
X-Stat-Signature: uayge7gxjxq1ws35ba8oymr16dc5yw5r
X-HE-Tag: 1777154493-854203
X-HE-Meta: U2FsdGVkX18sTb14Cs3a7mkObDmPIUa4BpZrHggtI14EeJ9hVnI8sEyxc64DqBuG/oJBirVol05Ub3T/J6sJMps5/42EZMSsI7b7NO3nwoTDmHrivw32FOaX6vYgVEOkq5wPpOdZhzccw0cn+1KUcwxt5S9JQT6KpwiLSLM7HMa8GF9yBvQH6np9AyDWkGXrynaOW5qMQitjDQ3axGEFrvWJUs4gcBjmrkHlisMoNSwXRk6Fn84IgpB+vJagUkZ2XUxQhaLsuB0CV4Z9QmBzf4SgrCVplCT5O73TVN5M7xUglqeq9jZl8YEvSk1+4WcpASynBa7o9oncLkk6S738ycMzY8nQssV0S754FBesK8XWJNl15mFMkdEfQy9VuEe+U9H01N8GJIBKayLLCMW2F7VbXv6IqFhzUgmFZeCXZseasbJfxll3Qs991UE5UuA88wKAsw9FL/d7p+LUBr5cJTpCpDBhd5sqb9UqsetrH5GpptT9TRT0C9E1BjZ4rNDlTEFwtRwK/K/atDIv0HZrq/+AcVb1ynzFCVk/AZyKgULuqLKoAgAblbl8iYidtWsq/P1O/3FfsHYg+vtkZh4jXLlvbeaKt/92gJ1b+hDPx1rCCYfhkxd/aPm+JCalNscgDIuw6qZOt+y0VdCJsY5pTKP1wmFf822s6Wt+39VGgdDJ+k13ffC3HMnkrTqiRqU93g5jaAGRrY0VmTa79rI/mCNvq0hHHWmtDT+KmwKPAiT3lSDRkyPgwEzFznmqCXSvHQo5NVUUQMaqYag9oYY47Q6e2Trn4f2mDmuG7SZTj/r+Qxaeu1tEaMRUqZfrvfnC48jQpZ76RKTdKxHCVFBjRnBayjJn+oel9QYrXsujGVgoukU3zQaKBE3qNB5sI8iuutcszzd40v6fbyXGkNgFuaiKoDFxo28Di+iydK6CAS+9ZCD40ut1Wq4kSa5Qsy17eYBeOj1zeKYECn+ZONY
 QzcldCN9
 ng9qOwn2i4Yu965dzKD9qJjBdsGa1htmP8dnpsqivv1lnstBZ9QjaSmnvN7iswSe8MMj5L6ohPtNnUj+NUhRd9sEkOCpyoKAKL/pYl649VixlZxZpENR8O3+X6zK+VLDPEcwzzVj/E09fw0pfT4Nrf1YXZ9vbHXugkXemyS3ZLJNSbwM6BQTmtliWWlzC2iLd1KPnklVjFjyc6TgBUlVvSnfr+/aR4qS1Q6q8qigaw822XNqaPFEL6ZAeUwsI9pqELLnGkfDOfyGRa0qjmPlOkw82y6nB11vm08+detv1M7yRSl8Pd+WqlvHP1LYucRJXWslOAXkE3VLRvx1MOehtMNfhXh1HeIycwREDwDxjIySE2vboZd/08txhfK1EO6bTEAT/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 22:49:04 -0400 Zi Yan <ziy@nvidia.com> wrote:

> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> Add a helper function mapping_pmd_thp_support() for FSes supporting large
> folio with at least PMD_ORDER.

My arm allnoconfig blew up.

> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -513,6 +513,15 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>  	return mapping_max_folio_order(mapping) > 0;
>  }
>  
> +static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
> +{
> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
> +
> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
> +}
> +
> +

- Should it be named "mapping_pmd_thp_supported"?

- What does it actually *do*?  A little comment explaining this would
  be appropriate.

- Is it appropriate that this be inlined?

I added the below.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
Date: Sat Apr 25 02:54:04 PM PDT 2026

fix arm64 allnoconfig by uninlining mapping_pmd_thp_support()

In file included from ./include/linux/mm.h:31,
                 from fs/inode.c:9:
./include/linux/pagemap.h: In function 'mapping_pmd_thp_support':
./include/linux/pgtable.h:8:26: error: 'PMD_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
./include/linux/pgtable.h:8:26: note: each undeclared identifier is reported only once for each function it appears in
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:289: fs/inode.o] Error 1
make[2]: *** [scripts/Makefile.build:548: fs] Error 2
make[1]: *** [/usr/src/25/Makefile:2139: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +--------
 mm/filemap.c            |    8 ++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -513,14 +513,7 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
-static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
-{
-	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
-
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
-}
-
+bool mapping_pmd_thp_support(const struct address_space *mapping);
 
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
--- a/mm/filemap.c~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/mm/filemap.c
@@ -126,6 +126,14 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
+bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
_


