Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688F0C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F866B007B; Mon, 27 Jul 2026 12:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF466B0099; Mon, 27 Jul 2026 12:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9466B009B; Mon, 27 Jul 2026 12:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A73576B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:00:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EC72120124
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:00:28 +0000 (UTC)
X-FDA: 85035018936.22.154C601
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B406100015
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:00:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nCMJxn0c;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB30wN8yjdXgq6NYs2kUjzKRcyWTmpmx3GjdzFD9/WE=;
	b=KBVEfY0a9gUKLtlupnLWeKjAb91vzFe6lUDQ3QSlzp7w8T2BMN3Mi/Nl7hgSFkFLPEmSat
	T/3cg850XHs4Ov4sJe5d7IGP98gKH8KqEprhpFtCQputOpA1zOao/OUy0eTgQUOY7E2mfF
	W05ss7ok8CDoTJBeDef0mppJVk8zjYI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nCMJxn0c;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168026;
	b=clUjBNgKk+KsNn5WkuBDoa28tBpJle42oNVrkXSuTtHNIGi82JHCo/7hnTGJcbUj30VaAO
	IbFGuGvanPakkm4sAbwF080IwX239ebiovE/i4ovFoAYzo0qC0tFm1movQb6j/+rhyONEF
	zwjXQYwEW6QvrQSnn8QEzS6VcaOihdo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jB30wN8yjdXgq6NYs2kUjzKRcyWTmpmx3GjdzFD9/WE=; b=nCMJxn0cSZC7nJ47yk+Tys45BS
	XjZkO8CDf8Pn1DcEDz3p2HE4Rm3d7OBKfKKEd8ZnDJ4MGf6OtIGkjAtJxDY7zaDOTSu3mt6eB+nD7
	U1ifAgA5iSYkFzjtg0fpmuHkyxgdYThwBu8Q3OIXA3v0ukbFKfiBjLzrL6C71Sl1/cpvDq7ILyMtG
	AwSTkFCwFUtuc5DYtegdIbkRU6G/ybzswTJcUbNarGqvDxTQfuiajtHYURdr6h2hJWN6SPOwGMyWR
	u0HmsfjwnYAEOCiD/wj+VYPeuObhiX99FYbvclygFxO2rIUWAAQVo+j5z6TJZbHPr52oBFMDK167e
	W2RI3k6g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woNkA-0000000AzfK-3C7g;
	Mon, 27 Jul 2026 15:59:54 +0000
Date: Mon, 27 Jul 2026 16:59:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Jan Kara <jack@suse.cz>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
Message-ID: <ameAekveMOcP7ffQ@casper.infradead.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <880981b5-ef79-4c9a-a8bd-7540002fcd15@kernel.org>
 <amd9QR75eLNdgNU7@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amd9QR75eLNdgNU7@lucifer>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B406100015
X-Rspamd-Server: rspam01
X-Stat-Signature: wxkiz18m48fyp7zacqutk4q5njsca7ys
X-HE-Tag: 1785168026-545034
X-HE-Meta: U2FsdGVkX19Kh3QM6h01bjGB1/tY4gankzcYuyLDOS2w1D+CHEyDj9mulIQlxeF8KMCn666MhqpSKGlSN/WIIn+SHecl0jBSL+B4y7uRJC9OKzs8D1vPuNjJyJA2wvEobrXKidz3R3MZxYnvHWMh85Sh/kU0lLJSoZIaqbNDUgzhNLPS22ASViBI068yhfSgUiIPfjyqe9xzYzJjZlZTxbEIemnA/zm0ZHPsTqlLt+nit9ydBoOvvdAjkyeHGarIxeh3pYe1V9n84DzOX3U177a5SEpgp2pIdQmv6g9+KYCEUCeGzU6W8+O+JnbcOE+ylIcz7fIziQBGdguGTcoHHg12VA6Z3L31L4CKOWLZDFwOttadH1ikIFN4OdT4yzKRwg9sJ94nbfY7GLUN1tKssdB9vANg7vN2UyI5OaOzZl32v7Vs6+xht9rzCSQA/vBCPOUXfC4rnFSM2PfvppI/anT0hg7kYNOMi7q1gcDXgDm38PbtJTc/MlCfFJwQL+uSddjoVwVQA2P25dhk7rAlVqmVBLrz0SuvRl0al/ZYgaq5difMXnmxXu6vbCTDM7HIu7T+qxwc3POK5Ns7gsI5Rmrc/Qo2v12GUGfO/0ftnJxfepzlye8VG/XE6PUMh+7AMu1QvhBKIMRU2Jj8K7+x0Vp0p2VNgxhkW7Ane5ht4KBN6alopq2MlZa6/bx+jDSjICxc2iiPizwUckhLhpi1YM3NVlIJAbOS28oCqTKmzC188XIoc3pWuZX4J6ddaXP2NS75Lx0105cBY3ljQUhzOWUj7b/Njd6TQ3ArVpZ2cymlu+RBQ7AnHBurJ/P+G08QAhIyAcGvx3tvoaIKhuM+Bf4+dknnd0uUPzlVMwGWFISf3npXtvQkj3+t2f9jPP7llH/W34sMh7BfyanunOX8OYpfosJJfsTey/gF4kDoUJvrIf33FohDHWXNffxIF+0uEfJ8BNdiDOnAywNlHin
 MPyqCTgN
 32yemGtSlT1yhERRIydMBUapQ0fjM3qq1qMH4/kAHZm5QblE3UDWTGXcM0PUfqC3tqDeBdppE2TPhQ03Rrw2ikS5TMgkHKp4GxWapIJ0whdYrQsIlpV2evNPrWIP8UpOLSdk+jL8EWtnNi4SEvRkxK+QOuGjvhDtK/LePVdnyGrQpyxb+SfX/i3g59nEWxkCce4rps3uZ/A2pIPJcGqzflqFfpBxrxnisM5ziagzPSnZq6JZjk9P6q6s7jT4MXPebQtCr2xr7EwEo8ucOEvbiYpwIIYoNjVLBFuOT+dht5w4Tmz9DVsBphoSiF2S0ir6dZfIAR9A31ZNYar30im4iRUZljzlRRNFQZA+L8dRp2sqqJlWqd1LHwSIS5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 04:57:01PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 27, 2026 at 04:44:06PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/20/26 16:38, Lorenzo Stoakes (ARM) wrote:
> > > In memory management we've managed to manufacture a great deal of confusion
> > > around the concept of anonymous memory. We have:
> > >
> > > 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
> > >    swap-backed (thus for reclaim purposes, treated as anonymous). These are
> > >    simple enough.
> > >
> > > 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
> > >    present in the page cache and mapped by an address_space object, but
> > >    whose folios are also swap-backed (thus treated as anonymous for reclaim
> > >    purposes).
> > >
> > > 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
> > >    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
> > >    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
> > >    referencing a file, but are in every other sense anonymous, including the
> > >    folios.
> > >
> > > 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
> > >    and have file-backed folios until CoW'd, at which point those CoW'd
> > >    folios are anonymous.
> > >
> > > This series fixes issues 3 and 4.
> > >
> > > In order for us to traverse VMAs using the reverse mapping, we require two
> > > fields - folio->mapping and folio->index. The first tells the rmap code
> > > where to look for VMAs, and the second tells it at which offset the folio
> > > starts within the referenced object.
> > >
> > > For anonymous folios, folio->mapping points at an anon_vma object. For
> > > file-backed folios, it points at an address_space. And:
> > >
> > > * For file-backed folios folio->index is simply the page offset of the start
> > >   of the folio within the file.
> > >
> > > * For anonymous folios belonging to pure anon mappings, folio->index is
> > >   equal to the virtual page offset of the folio.
> > >
> > > * For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
> > >   of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
> > >   page offset.
> > >
> > > This series establishes a new virtual page offset property of VMAs to
> > > allow us to map anonymous folios at their virtual page offset, consistent
> > > with pure anon.
> >
> > As raised off-list, I consider the "virtual page offset" concept hard to grasp.
> >
> > Maybe it's just me :)
> >
> > Skimming over the code, I read "vmg->anon_pgoff", which is pretty intuitive to
> > me. Similarly vma_start_anon_pgoff() / vmg_end_anon_pgoff().
> >
> > Could we similarly just call this "anon_pgoff" /  "(linear) anon page index"
> > even on the VMA level.
> 
> Yeah, I had originally done this.
> 
> I renamed it because I worried that people might be confused by references to
> anon for file-backed VMA mappings.
> 
> But I think probably you're right that referring to it as virtual page offset
> adds even more confusion vs. simply calling it anon. Will respin accordingly.

Would the term "logical page offset" be helpful?

I already use this in my description of folios:

 * A folio is a physically, virtually and logically contiguous set
 * of bytes.  It is a power-of-two in size, and it is aligned to that
 * same power-of-two.  It is at least as large as %PAGE_SIZE.  If it is
 * in the page cache, it is at a file offset which is a multiple of that
 * power-of-two.  It may be mapped into userspace at an address which is
 * at an arbitrary page offset, but its kernel virtual address is aligned
 * to its size.


