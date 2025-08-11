Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB32C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7070F8E0019; Mon, 11 Aug 2025 04:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF048E000A; Mon, 11 Aug 2025 04:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4BF8E0019; Mon, 11 Aug 2025 04:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBA48E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:52:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6A781DBAE6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:52:42 +0000 (UTC)
X-FDA: 83763860964.06.6055822
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 588FAC0008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:52:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKswWXSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754902361; a=rsa-sha256;
	cv=none;
	b=EiW5KniPIGKysVLy/e24Lkevq14P4RMS9VajVLKHp0+lVolrKpR9gE0tHqdTr9rWezlebZ
	Rl62yFGuhvxdrhUBRzKnQC44UE7cXeOJpfJFo0pAxgzfbR02tLgTNPxNU8tTAzdvSeWGmA
	ewX9MWsVz94QDMI+ZX/4wJlQHZ5LuO8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKswWXSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754902361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oe2VKxHHBnv9GjgWLsKN6Ezb3lZiI1aA5YJ7TN1WMOM=;
	b=18DvHkVHgcauUBnnrors5t7rQBdUW2BdwEsUBCW3RVC6xRTk4Klsmrbr9iZ7FiyU1GtGaG
	2Y6lswr/jKAg5JQsre9wWUa9Y8nYsTH36SZ23puMl0cpKq0uv8x8FFKut8iK9MBOtjmddC
	eakB7hFYTJHkIrRbjXce+N5cn0eVOsE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F54861133;
	Mon, 11 Aug 2025 08:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B104C4CEED;
	Mon, 11 Aug 2025 08:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754902360;
	bh=3W7y2DSI+b+/NU/9fMvMcZ7Git3/YhU7rwsTKEuKhak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKswWXSDs8HligSv6I7X8TlRBaJTUYhj/n7fHdG1oe59j5so4v1z+qlk8ZCDJb4ud
	 NCWPA/ImWhMlfbMQ9eRX2/DISkTjV7vnmjihTP9atKiP0wPf4RsGvcszZ5od76OhgO
	 Scx4BYZWgcbI8ikoVLb5QZsRdd9nz6qRZXO/99WPYxnwgrNgvJMQOb56vJhUE3hCs3
	 xKaUqK1Ys+FCYEQ9k7jCV9uY1waWLHTRugMVYYKFfeMjbpoJn2j0ARIeWnBEPqDZVS
	 gXNPey55jmq0CWrZEL3jHhweH3xtUr+QegSdaQZe1gk4lyTS/L1JrEQdHlXOpG/Umn
	 mQHBS+oPTamRw==
Date: Mon, 11 Aug 2025 11:52:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Huth <thuth@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Alistair Popple <apopple@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	linux-arch@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 1/3] mm: move page table sync declarations
 to linux/pgtable.h
Message-ID: <aJmvR5mRJ2htKoss@kernel.org>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-2-harry.yoo@oracle.com>
 <aJmkX3JBhH3F0PEC@kernel.org>
 <aJmrpaeKKeNCV3G_@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJmrpaeKKeNCV3G_@hyeyoo>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 588FAC0008
X-Stat-Signature: 9e86gtw7zywcbsjnaxoxtxy9zc6waci1
X-Rspam-User: 
X-HE-Tag: 1754902361-364848
X-HE-Meta: U2FsdGVkX1/0Qrs+V2HgNWfuyDJ0Fu68Ghb9YLf+D0fEo3rLTuX1fCDoUzCDOD8Buyoh56f11YNrBDHDfcKIqPr43rvCDjMEmiNpAq8Fme90EgRioSl8zqoA6P/1GTgxBzjF9fDgaX4T5Lo2aI4qE5cGMlyahLIvN5Pe18LkMgQ0NcdZIocTTIr0bk1ziWS+7oiFzoMtC5vs3Ak1w3Eh0S04vSkweLefK6zd9ZzdEB/8/56eye2juC2nvG0dW6MNMVNqg2guh/a8F38Jc8ht9cQYCvLPSIbVM9LID3+tYNDL3wEryooLZlMeC6425SBAN10SNww+lNTq+du4QVKn4vUJHRqLnLfjXaRnOjANhLRsagQzQkbxVaXacPAbn8khXOfpSFUkjXKpxptIps9RMI8eImnstw9Lv4gWBWEHa0326GCEQOdGYK/zpbJvuHEHQLbSeElI5napti39NBh1C0e/O5c5arRETtGJprzqdkthMVKyHramXbvaEH1b5nTWdhkoZhQdcy8WvYRan9VWbUOzrHvc736p3DdlPCEu0tyCIFQfRAcWn+PoAAsXxwW0QxoO+mJKD5B7rXADzH04EEAdM9qbpY8jpT7wecunbs8LBTXWajaHkM6E7fCM96AtIofnq2T1miNgbSk85tm82QtaWHXhLmqfphYbMqc4y2ajSRm2dIlxkkcFiVzYDiscmq52hzgpUe1Z8XZjn7ZZXMdIaU3wn3e7rrwpxlhCoBaxQbpztyY0/yakh55Ixr6PSDqvMafjERruF7zPyZRCYGDn9/Ps7cXhh5VNk/ojI7mWw+HAC1AdiEgRLD8eyG6hSK2kwKjghbGOpkOTdBU7yc5wf4ZxetLP6JsaYd8oVY5BHZ4p9/J41f9LxJJU9bLFuwYta+Ze/JkenXVu2Vno6puRn9yoxp32pVj6xGuWyVFJ5NSbkjvOYM/u47Q1sgiOAEW+0o43HaszEEXnlao
 Rim1Dj5h
 dz9mGMRYKEp+Pp809WceV+Wn7SSan41cdUQnE+MeFFuc70d3IS7+aWG0klgXieulBD3DSP27nmXWvv2fwo6JHs4dX4eaftEIBsn+0nZaYNmb9WjvystPY4nw3aq2RqPzyIYP8Y2lsIRS36ROzEmjEx7hZNapNMc6ZaJoTwjqu2F8BCbINYN3/f1aO8MNHYcuX7XJr+8CPHXs0YN3aZFgFpH2Yt5p09baU3CKcBvqzaUf+PTrnTJ1x0Ke7STGtxK+C4X1KetXkcDUWcPwIJeZ0VXjuqY/TwqrHP1xsc+zn/4fDA9SwKVOjzUGiHJsr16yJcyKYDSBJ9NLL7MfqEQrb4Fi07+DE6MRBzTYXQwwe2TQ6xE59vr3J1kSTmAh9sUr0qdS5EQA7A1bZAKcBWXprdpgWbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 05:36:53PM +0900, Harry Yoo wrote:
> On Mon, Aug 11, 2025 at 11:05:51AM +0300, Mike Rapoport wrote:
> > On Mon, Aug 11, 2025 at 02:34:18PM +0900, Harry Yoo wrote:
> > > Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
> > > linux/pgtable.h so that they can be used outside of vmalloc and ioremap.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  include/linux/pgtable.h | 16 ++++++++++++++++
> > >  include/linux/vmalloc.h | 16 ----------------
> > >  2 files changed, 16 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > > index 4c035637eeb7..ba699df6ef69 100644
> > > --- a/include/linux/pgtable.h
> > > +++ b/include/linux/pgtable.h
> > > @@ -1467,6 +1467,22 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
> > >  }
> > >  #endif
> > >  
> > > +/*
> > > + * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> > > + * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> > 
> > If ARCH_PAGE_TABLE_SYNC_MASK can be used outside vmalloc(), the comment
> > needs an update, maybe
> > 
> > ... and let the generic code that modifies kernel page tables
> 
> Right, and patch 2 updates the comment as it uses it outside vmalloc():
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index ba699df6ef69..0cf5c6c3e483 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1469,8 +1469,8 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
> 
>  /*
>   * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> - * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> - * needs to be called.
> + * and let generic vmalloc, ioremap and page table update code know when
> + * arch_sync_kernel_mappings() needs to be called.
>   */
>  #ifndef ARCH_PAGE_TABLE_SYNC_MASK
>  #define ARCH_PAGE_TABLE_SYNC_MASK 0
> 
> Or if you think "page table update code" is unclear, please let me know.

It's fine :)
 
> > Other than that
> > 
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks a lot for all the reviews, Mike!
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Sincerely yours,
Mike.

