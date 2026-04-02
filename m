Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF81D6AAEC
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7C86B0088; Thu,  2 Apr 2026 14:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468756B0089; Thu,  2 Apr 2026 14:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3576D6B008A; Thu,  2 Apr 2026 14:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21ABF6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:23:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5216C2B57
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:23:25 +0000 (UTC)
X-FDA: 84614438370.24.F035A66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33A37180004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:23:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XGkmHHOz;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775154204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wx2j3xbCZVXe6qxUMoDBdw9wzQloTD1sTKpJxjhI8Kg=;
	b=FRLHx5N5ekDw0syK6MM+kp0K2sptdy4T/E8di7MenG4SsZ+oOmUG3fRwlahzF01YuKMIrt
	JDXjK+QTeM4gsYSmgGGQiyeD0WpG9TDhxzdR2tVNMK6j68JEqoOSWqj8VIr7+IhfJ5gmak
	TDEyrGv5o3EETYs6tMmkHqD9f4sXg8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775154204; a=rsa-sha256;
	cv=none;
	b=8fceZIMP4sdPK25L52g78gQzyb7CTRp12ULLc9caWjMVv4QZfLzOZDy1X8rWk8n7+LdXhn
	fClXOJMDGbgr6HouD76I/WwR9a+5JNnzpcUZP/ux5PTMniriBHclEloBlVFxf78LfPIULE
	CwFgmB64N1ctebzwcPWpbTilq+9D8o0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XGkmHHOz;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9047760008;
	Thu,  2 Apr 2026 18:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838CCC116C6;
	Thu,  2 Apr 2026 18:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154203;
	bh=tT5VutlhwO4iM0thHkSEj6tGhIceZAxA8rLI/AMmxxM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XGkmHHOzYo7NXSvG/QGEDQpmEfdP3Wlln7IYjc5INODBo1a0TeANXmP6Pje1F3Tca
	 fSywnosUgFj4QgEcI7Hl4ej4d3lyC7m9AcbHzX+e72kJU/I1Vy8wiK2QiPKdzbC3ej
	 uo0VKWNtBy/X3DiG9ujk+UQDD6ZpDOIqQqYrHYxs=
Date: Thu, 2 Apr 2026 11:23:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin
 <avagin@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, James
 Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 11/15] userfaultfd: mfill_atomic(): remove retry
 logic
Message-Id: <20260402112321.65a46fe7be4708e180eb864d@linux-foundation.org>
In-Reply-To: <ac5zcDUY8CFHr6Lw@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
	<20260402041156.1377214-12-rppt@kernel.org>
	<ac5zcDUY8CFHr6Lw@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33A37180004
X-Stat-Signature: xyygcyxhhpo6yuemk6hzspxxreixgbu6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775154204-224997
X-HE-Meta: U2FsdGVkX18qoni9mUJiPyZ7l2IrrNHUysQKWax9ZwNrXZbpRj+OCbYmcSdnwiECdthjUx9OhwT3vkNt12r+U6/fsfL+gavHgDNP9I7P2GwX15X/nSL0ITHJtMCRCdB1V/8EJtr0gLXZ5lLvLczNk2ur5tUVK48AG/9lt8g+8QExeHD+NPsO1xW2ulNGxnaU6J0EoBB+O6ZG0znxG3AsW9BUSB9LwaWyDibLbHdpQOi1hNukz9BKsGJiS3BuUBXb/Ez4Sr0KCGY1q89PvQXeExpbYuurKsF6m+ZGBf5CSUp6Kb9aymsaPBu3rBRbFPpq/tSknQKSUWsSoK3V7Fu8Gx5mHcB2TR+MuZFva4DkvP6GE8h5FjKj8aQVZYjFQNeZyAi1Turgz+Iwfnqt3X6ISeAx90v8cMmoUsv9Wbn74HL9n0C5gP1UwCneFOgzQQmH/d/DCP6aaNhARtDDkBN6vUmo0kzsLvcYdePxg7GmDyOvxWlQ59092i8zhF3eKNDTv5L1ZwIkcr48kxMNn076eadNlhO+XSa0i0+M7jNo8vWv8trho5G3N8vV7jb6CEKDbb/QfkNNiwJmFj2Orj95n095+Z9yKT6oiJteW9ZuPCNO0OP3nts5uqcbnDhC1PSrhgrgrd+qC/gatbwHbkcplKzB46sDI5oIpIPw44Du69Fjho0I+lH4FAFqHRel8yzeLDrpTn8bPMju4GtKIf96LOqhPm247VJUz/reOk8vPaARwZVmQn7pQvMY+Am6nhjUUWgj6tpSCqgRCnkgx6WzarnO8wWz7lSGk0l6jSTLDgLs4Q+XUaK7dPGWJihmXsaJs8EYTK+uiLphVJoibUZmLGMYMr6+Ee3zxYU2QfieYM9CGVp5mxKzgCuXHHmSWEAA4nK+WxOdnfUvfPtnzLrmGL6hjChoEmFyai5UuFlLujW84rx9pG7rVEfAZ7rWNa0E4/ItF+IRiEy/EJHopQx
 YU5y6ySB
 P+xnV76wTg/CboYcIxRL/p+Pg/l6nPNDuJECY378n4/F8ILQnT3y8RAjlJLqQSZwHiAePwzXyVAfNt+qrPMaJNwBgdiAvxswnC33OtR7afkl+ZBOO2T85TPr0MFuqNIGakC052EQPRB65HvbSRA4KxVn0r/ChQ75WBq95UmsUoJ/tu1ghqbEeEPoq0HvfLVPq1JnQg6vohOmnleUkplDqxjgiGOaUae8ZX5k9YOsyS424R7gNHZAItMChuKpx6F2tljGrrw7DSGMbkgoxHMZsfwFIEEBO4kvKGwglnL2B7Lhzp6cQT0o29gQbOOMj21RtnU7Ab2ZIFj28duLKt0al8xW1VboSysfZuf+O69wsGlunLksENgoDiV52w3lpkenbYZBpIosq+80fJUQS88HVuj8veYEaPlgKwJH6rwJFfUQr1pvrWK8y0xxYHtYrnBZorH6goNxhqEaOzWbkv0dnD6L89rd1vHb6+xjOc+Oubrkdd/uVzihyX5DDjUqv0LFaG6QzS3e6TbewrtjgZbi4Y72JncTQJQfyeup2h/Ijimk0t4m3EXPdQVCvGHE44vZ2xTyXSyX3ESY6ivoyu0DrmLkyGmFVoFSXSf5UNUDlC2GXAas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Apr 2026 16:47:28 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> > Drop the retry logic from mfill_atomic().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 24 ------------------------
> >  1 file changed, 24 deletions(-)
> 
> After discussion with David Carlier about potential replacement of VMA in
> mfill_copy_folio_retry(), I looked again in the code and realized that
> after all the rebases I didn't remove the bit that temporarily prevented
> returning ENOENT from __mfill_atomic_pte().
> 
> Andrew, can you please fold this into "userfaultfd: mfill_atomic(): remove
> retry logic"?
> 
> For a change it applies cleanly :)

done.

> commit 5173c8f4fd32f314907b3804217ef57d4e3a2220
> Author: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Date:   Thu Apr 2 16:38:39 2026 +0300
> 
>     userfaultfd: remove safety mesaure of not returning ENOENT from _copy

s/mesaure/measure/

Was "_copy" intended?

>     
>     Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I instafolded this.  End result:


From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: mfill_atomic(): remove retry logic
Date: Thu, 2 Apr 2026 07:11:52 +0300

Since __mfill_atomic_pte() handles the retry for both anonymous and shmem,
there is no need to retry copying the date from the userspace in the loop
in mfill_atomic().

Drop the retry logic from mfill_atomic().

[rppt@kernel.org: remove safety measure of not returning ENOENT from _copy]
  Link: https://lkml.kernel.org/r/ac5zcDUY8CFHr6Lw@kernel.org
Link: https://lkml.kernel.org/r/20260402041156.1377214-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mfill_atomic-remove-retry-logic
+++ a/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -531,9 +530,6 @@ err_filemap_remove:
 		ops->filemap_remove(folio, state->vma);
 err_folio_put:
 	folio_put(folio);
-	/* Don't return -ENOENT so that our caller won't retry */
-	if (ret == -ENOENT)
-		ret = -EFAULT;
 	return ret;
 }
 
@@ -899,7 +895,6 @@ static __always_inline ssize_t mfill_ato
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -926,26 +921,6 @@ retry:
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -960,8 +935,6 @@ retry:
 
 	mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
_


