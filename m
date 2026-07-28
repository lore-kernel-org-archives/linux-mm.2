Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 349C1C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6E26B008A; Tue, 28 Jul 2026 09:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABF36B0093; Tue, 28 Jul 2026 09:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2C26B0095; Tue, 28 Jul 2026 09:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1EB56B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:41:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45A11A152D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:41:09 +0000 (UTC)
X-FDA: 85038296658.23.604B6F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 909FCC0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:41:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6rCQrh5;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785246067;
	b=Woqy0sQWd96xzexGXvz6tj/GE6dP3HQi7QL5liWPWk6p0fMJcN70+kWglni5dW51lBCvxn
	TLxT2N7BTTptvF164oEs6F9FaX3wujMZlfIbK/9TvjYTmOrOkp/HIwKzcC5djTgT0xnq3f
	m/AOMGlkvl4YUkuR3XHycsDq31G68YM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6rCQrh5;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785246067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEMU2TmSwsqrUTy8ZEKYu9Ae0PHGeT+f/ud0LSQJwt8=;
	b=2cp/lv3Bf2OQiwLJYSys6UTKLYbXUGKWK5uYz92bU+FuJ9v0CUgKRef5sQnqsL1cvR0KrO
	JUdQKtT0ihWLU6CDXFUiPCdhjxr6ZAacE1JbbAiUoP+ti9JiDdhZV39ZPZFcIVeMub3uVA
	454zWvjhgow0bn6tGgFl9biC4CJn49o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CFE341337;
	Tue, 28 Jul 2026 13:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50981F000E9;
	Tue, 28 Jul 2026 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785246066;
	bh=HEMU2TmSwsqrUTy8ZEKYu9Ae0PHGeT+f/ud0LSQJwt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U6rCQrh5cCM83BFeZR9/Qvz6ZbhtwuYWaehIe+rVPnqsrpeoZxZ7B10TBBl8W6i2v
	 bNl8xdz3N7EGPECsNHEUwcq7V6eXM065C3EsgL84YXJLnqzq6/63+lR4ajgwFmWjia
	 JkPs+1kKRodOHGdKHGtsSMAqqnX55EzHnTzrwhr6R+NPj/XCwR1rYWbkoP2dlqZOty
	 fHKBsYlxdrZfaBsgyDoTQfTbzFICpH6JzdT1q8XsyCZQSIbVk30IicsnJBR+9DqOCg
	 GcNUnIcJVMkBfM1LBlYvBh6QQsY2EOWD4OvET/dMUu0/DjKekDYnPntoQpf0AZbORa
	 tMd75YGtaicKw==
Date: Tue, 28 Jul 2026 14:40:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
Message-ID: <amiwjyQr5l6O96Hk@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <880981b5-ef79-4c9a-a8bd-7540002fcd15@kernel.org>
 <amd9QR75eLNdgNU7@lucifer>
 <ameAekveMOcP7ffQ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ameAekveMOcP7ffQ@casper.infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 909FCC0006
X-Stat-Signature: hue5dib3z5rrjjgm9fqyzqc6af9kwxwp
X-Rspam-User: 
X-HE-Tag: 1785246067-539208
X-HE-Meta: U2FsdGVkX1/+16Um9VbIiGI4t72evK1whknJSEqkmFQQG8ugUDUTg1Lmv7oUO5t2xhIxS5V2p6HK5r/IIIb3jkDi9EzFjCD6Qk1bnIzhImE4tN+sQo3NPVWb4riokHHMOyFrdhgVLFJGhTTU95eCPtjN8hHh8VgQw7Z4YUMJk2v6uz5L+AXhEGUnZgTFQGxDv3G3YYzAkN3wDyPw3MvDzl3LyZcovVjuKkM5z0azlQnmSp9YDNBNLaAHTmt9IpyY52vbA/wzLtKityU7acgiPGiPGKBMRJAz1Nt3niz0GAh1WMzE60YiW7R0EP/O0lmZ7YD0S8T2RTRGx5j8KCn9rN+rL8k/BJyRcYnjHfAmH57Y7O9vhBNsqPfkvkvlN8hylqUwvw+VTQbiA6YqaTMoZILDwgRiWtnz50x9kgWVLvGhPNsztjOUzH/GMNCsbFy2KHUVCB3sut52qKmW1GZVSgCkIOczX2jnd5HTLnTGi9w8qIL2GWWJjM8d6Vd+oOZgLBzNhiTHI8WPK2bysZVBTSvFxifYCZAoE/UH6JKFRlWmnNkR/+LkHD5rZIQnllbIOxF6JUx6vBc3+XNy3Wmz9Lnhz3MjKkRthZmUcxpSKHZ2FOnif1cLFhnbTedYmyedUEDjFvsFk/9OeMIr6dKrls6vFbviqUdRJgdUB+6D+RBwcUGbg6l7P/VPurMvH5fGwcJw2kuQC7CaqboNcNrnXT5HH+v1C8bLDljbD5uA6eM9+nqjQ0vQ5LoRzxoqxuvPvDdTwn29iOv7enGLS1MMZ6D6uQruJ8dOHusIsR0avcYJ9BEQaZOzNGukBlTiAu5vUm245xr4+otdedNV4iBEciL3fb7VsGwFvtW1NlUBcHVDTGNpXYrE4E8+0IUJMnkmLPkaAEVzOWhYeGotlc3QPh7Jv2wNTRLq0F/QILwz5n143hEtzIFJTlWtD9hUXcP1wusEntpX3dTBdpG4Bn2
 CRotKnm8
 0hD99eXSw0PQBwycJO99kbhlLOjLqIt2jebsFJHF3VPLB/jm8hlIPElgo2rp9NV9qoi8isCdHrTjSZHMh2fPHB19kdO3QqL2xUS/lbT0A4L0Ln9krwG7Q8nT3YwL3UUkCocnhSeJojNVOpJvrwGE770iY6RYnaGawegTQ8xxOz8TDWJUNtcyjtdQaoUwabmH/9285/XmpuyQqM8nnfBRQKHCy3DumrgeizoUaHZZuBkEqg7arPPGQS8iidlQjWnc4qJZEpNd2eEOHYSJaeWpnTzw7heWV3++6q4obs2t7kT4XYkPMkP5Z8R9VN9c/tv84E1pqV3cDP6MMSmoQLBU0l5BEMxCa1mzYBNE/zN4KE5ivSRjZCQ6AwgAnguCUJltwWPi2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 04:59:54PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 27, 2026 at 04:57:01PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Jul 27, 2026 at 04:44:06PM +0200, David Hildenbrand (Arm) wrote:
> > > On 7/20/26 16:38, Lorenzo Stoakes (ARM) wrote:
> > > > In memory management we've managed to manufacture a great deal of confusion
> > > > around the concept of anonymous memory. We have:
> > > >
> > > > 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
> > > >    swap-backed (thus for reclaim purposes, treated as anonymous). These are
> > > >    simple enough.
> > > >
> > > > 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
> > > >    present in the page cache and mapped by an address_space object, but
> > > >    whose folios are also swap-backed (thus treated as anonymous for reclaim
> > > >    purposes).
> > > >
> > > > 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
> > > >    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
> > > >    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
> > > >    referencing a file, but are in every other sense anonymous, including the
> > > >    folios.
> > > >
> > > > 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
> > > >    and have file-backed folios until CoW'd, at which point those CoW'd
> > > >    folios are anonymous.
> > > >
> > > > This series fixes issues 3 and 4.
> > > >
> > > > In order for us to traverse VMAs using the reverse mapping, we require two
> > > > fields - folio->mapping and folio->index. The first tells the rmap code
> > > > where to look for VMAs, and the second tells it at which offset the folio
> > > > starts within the referenced object.
> > > >
> > > > For anonymous folios, folio->mapping points at an anon_vma object. For
> > > > file-backed folios, it points at an address_space. And:
> > > >
> > > > * For file-backed folios folio->index is simply the page offset of the start
> > > >   of the folio within the file.
> > > >
> > > > * For anonymous folios belonging to pure anon mappings, folio->index is
> > > >   equal to the virtual page offset of the folio.
> > > >
> > > > * For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
> > > >   of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
> > > >   page offset.
> > > >
> > > > This series establishes a new virtual page offset property of VMAs to
> > > > allow us to map anonymous folios at their virtual page offset, consistent
> > > > with pure anon.
> > >
> > > As raised off-list, I consider the "virtual page offset" concept hard to grasp.
> > >
> > > Maybe it's just me :)
> > >
> > > Skimming over the code, I read "vmg->anon_pgoff", which is pretty intuitive to
> > > me. Similarly vma_start_anon_pgoff() / vmg_end_anon_pgoff().
> > >
> > > Could we similarly just call this "anon_pgoff" /  "(linear) anon page index"
> > > even on the VMA level.
> >
> > Yeah, I had originally done this.
> >
> > I renamed it because I worried that people might be confused by references to
> > anon for file-backed VMA mappings.
> >
> > But I think probably you're right that referring to it as virtual page offset
> > adds even more confusion vs. simply calling it anon. Will respin accordingly.
>
> Would the term "logical page offset" be helpful?
>
> I already use this in my description of folios:
>
>  * A folio is a physically, virtually and logically contiguous set
>  * of bytes.  It is a power-of-two in size, and it is aligned to that
>  * same power-of-two.  It is at least as large as %PAGE_SIZE.  If it is
>  * in the page cache, it is at a file offset which is a multiple of that
>  * power-of-two.  It may be mapped into userspace at an address which is
>  * at an arbitrary page offset, but its kernel virtual address is aligned
>  * to its size.
>

Thanks, I was kinda getting at this sort of thing, and I did think 'virtual page
offset' was a fairly common term of art, but as often with these things you go
and look to check later and realise that maybe it's not :P

I think overall it's probably easier to go to anon everywhere, I'll eyeball it
when done and make sure it's sane though!

Cheers, Lorenzo

