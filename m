Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA5310AB82F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42606B0005; Thu, 26 Mar 2026 20:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF32B6B0089; Thu, 26 Mar 2026 20:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C313A6B008C; Thu, 26 Mar 2026 20:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4CDF6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:26:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53873160F42
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:26:38 +0000 (UTC)
X-FDA: 84589952076.01.06B1FB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C6FD10000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:26:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uweo7ewx;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774571196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0LFL5nbj1gz/4bB/JnJYRG52JeozrpUF1rmRUFRiCQ=;
	b=kZLKxY+3M7yTqP7aPdQde/2jit8UPZpRD+6CrfMg/QV7vIfQKzOZYOzQb0HpKauh7Mn54x
	IW6aO55sCvhjK1OViaXkG7gyGBRI/gRDB8a7ukTIg6CdMqvU8BCnlpyHe6LiS2svWz8SMY
	+Dn4TjxihdefFZuPo9au95/GMqSf28Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774571196; a=rsa-sha256;
	cv=none;
	b=Tua1mw9m0PeKFwrkPxjRBX4nsYLoH7DXUDfu3xLVWsBU0zWc4EVRh1GLLag2rK4S28J7NV
	owe1lh4rY6OgVgR3AsryK3Qu0X6gjXhx2X3skJnNlGiOGt2KLlaIc4+zx1akhGjF9TOJHU
	gG3tosoxyyiCRuIsAgn3Z466LKA9MKo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uweo7ewx;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E196F60054;
	Fri, 27 Mar 2026 00:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0709C116C6;
	Fri, 27 Mar 2026 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774571195;
	bh=DmnxU7Wn50/b1W1iUaXZMK/22QeVR6KQ3xAre+v1FVk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uweo7ewxvIAb/XfhHkku7Y7z/JEQW5F3fnuxI2Y360uEmlAgFOL7e/1MTNPXbqSZ0
	 rHl32t2/ymETPBIh2E4oSHsrneCeq1kkB8GmzBiAY1s5mtbrTJa2QyD/Wyr/s7V4q2
	 dO4xQck9r2/UJxjzihuCa5x44nLmo8+vEotrCMyY=
Date: Thu, 26 Mar 2026 17:26:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, Hugh
 Dickins <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Muchun Song
 <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, Oscar
 Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
 <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
 <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 08/15] shmem, userfaultfd: use a VMA callback to
 handle UFFDIO_CONTINUE
Message-Id: <20260326172634.11ee1b67cedfc5984bc9db6c@linux-foundation.org>
In-Reply-To: <CADrL8HWLnuQHEPFN9SZbAd_Lq1USJDV=Di4fsQuztwp4v5oXOg@mail.gmail.com>
References: <20260306171815.3160826-1-rppt@kernel.org>
	<20260306171815.3160826-9-rppt@kernel.org>
	<CADrL8HWLnuQHEPFN9SZbAd_Lq1USJDV=Di4fsQuztwp4v5oXOg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ofwu8khuwe3re4ah3yw4g9k68h366gx8
X-Rspamd-Queue-Id: 9C6FD10000F
X-Rspam-User: 
X-HE-Tag: 1774571196-457497
X-HE-Meta: U2FsdGVkX180WJN49EDRtPlDzPnouqCuWfAjhosnwlAN3uhgPq//ZaHxy1Mp3Yl8ktqDgZ9o6dZLcEMxbhdgcrmxDnBW3OdnbzhJIECsT4MI5AL4SN+4qCGfFyP0wXYs28haiI82MXISYqMgWvS3g+JrzjfQpw0p+UV09D9NpGvi9goAImNODAab/EcobkER4bUELW42IN7hGppUoYHRVmvYR3ovrHgRJl16mZ4gA9yJ+fTOeyHNdEjL5sHnbrPYS/mArJrdXs7vhbN0K67yoWx7h28ZdEqo2TH5+AZwsiYG5xVnHBljNEy7bUMxfgzgiXpQHvuM196nIkXYFYMh5CPDC/lHdde/LFcweoZJLyZ7yy62/fHztUnmNORZpD29B3bZFI9HA8lpvq+TrXVMhJBXuaLIC5aVHs7qqfFSzXyHe2jtwm6b4E3gvV3GuWqHlLtkBNAOQWKRzjdYFadHTWxlj6TF9CGVJ0pVLPe3EZWlj95sL+CoV8Ye9ilgmehp4Ix6Ap/g2ps7RsWOOHsPXqYA5M599OgyQBfeBdjlFHLeIv/lfUw8g6Tnw/gL15JbTs7bkHhGkOUoexUbOmwV3t/XHTpemRMhNxQAYu6qUGLbItnDt/b+H6q4kuSLbr9sbr92Y1LDAm60+NWtFsJV4jKxj+bGsHQ1CtGS9ccJes90JYPqaU5g9IlLjIZkAS5+kIeixacZRraWkhlOyOosuCzwFzmeIgaIFga2VpgZJJVp1Pig99ov7VOwFiz47AdABIuYF1R0cJOfkWCpqIOgccQq7ciqohfIPgQ/IiJUextgRUW3fyZlihlomcNqEuTa3s7DZoQdRDZxByXkDBQBE6I8J3/T6S89TqmlnFX8JZ5tw1+c/4UK0hDdNvnWX9Caz2guBZTGy4g5nhPHmy9IMzfGc0UapIJeMDS9tOD2FgsIIky/+GAdL3V7g4gLJFP4Hxk+i4Ml/BRiMQaoOJd
 tM/MwLBi
 Oi1lnK1f8gsmhK8+y7fGavODMla0yV6MwhWDHoG1Nu2PWB4Q67ZrAzmBq3r9hE6Rzt19dAaJkEBt/xK/1ffdB+ysSB+Wq5ekJtBQqJITvANtNRigFWrDlJ75IDBf33gR9HJ5fuycDBNmt3XsTxgK97sQR+QGkmoFe+mi29qz6oJ1evyVwG4ZdcWh6JF0c3+6w4/4NYPOcTcR3DiVNDrBJAGfrSvuof+cXJWLB3s4QI0VBFxbdlcnnQu+c6OR0sFefs5Qo2p134LZmuaEeZ0v24EZdEKEtlrpDEsyQ+ByJpMmDDL+GQp9pfjNQ8UcfdmBQs3ogDc4q7SiXjAkzQE/B+hjZIqadltWg9dTruRsvOlGGHQLWoz8zz+ZNgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 16:43:27 -0700 James Houghton <jthoughton@google.com> wrote:

> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> > it needs to get a folio that already exists in the pagecache backing
> > that VMA.
> >
> > Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
> > method to 'struct vm_uffd_ops' that will return a folio if it exists in
> > the VMA's pagecache at given pgoff.
> >
> > Implement get_folio_noalloc() method for shmem and slightly refactor
> > userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
> > this new API.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> I found myself asking why HugeTLB wasn't included here; it's because
> we call into hugetlb_mfill_atomic_pte() pretty early. It would be nice
> to have HugeTLB implement get_folio_noalloc() and use the same path as
> shmem, but we don't have to do that now.
> 
> Feel free to add:
> 
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks.

> >  static int mfill_atomic_pte_continue(struct mfill_state *state)
> >  {
> >         struct vm_area_struct *dst_vma = state->vma;
> > +       const struct vm_uffd_ops *ops = vma_uffd_ops(dst_vma);
> >         unsigned long dst_addr = state->dst_addr;
> >         pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
> >         struct inode *inode = file_inode(dst_vma->vm_file);
> > @@ -586,16 +590,13 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
> >         struct page *page;
> >         int ret;
> >
> > -       ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> > +       if (!ops)
> > +               return -EOPNOTSUPP;
> 
> Perhaps WARN_ON_ONCE(!ops)?
> 

fyi, I (and I expect many others) tend to consider a "Reviewed-by:" as
end-of-message, So if you have additional comments then add something
like "comments below" so we know to keep scrolling!

If there are no additional comments, simply zap all quoted material after the
R-b to remove all doubt.

