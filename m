Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8C0C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFBD6B008A; Thu,  6 Aug 2026 13:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7306B0093; Thu,  6 Aug 2026 13:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECA86B0096; Thu,  6 Aug 2026 13:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDD76B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:19:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEDF0140160
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:09 +0000 (UTC)
X-FDA: 85071505218.04.46E6D20
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8875F100011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:19:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NOHtkX6M;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oRZ7bVSXyuafN/Una/b4mH0BdxkEb9tpDXSUb5X6ns=;
	b=y32ycqLJLGp9U8vHm3IDEwf0hDxcsnT41obrBBMCqrS5yp7J7aNbK2Q+Vq9ipfXLKqsXuV
	EAm6O6yqiIuCyM+IVmQclDougNhx05XplK6W4OMQ9w/FoaEMQ5H4O+tu3qXLnb8n+l0pdA
	te9Ij5nvnqCqg4gSo5jJ7R37/LH0SJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036747;
	b=D/S+JcTdeZCo20yEVXLg4PllFrPxfne3GzBWHv2a5h/EqqtHG66krD9VczuVz1SXygQQSr
	6EW/pXfLxhMS4BSVFSvm5XDWR4Hc61jSncaz7dSureXYwOm2tHlozeU3yn3qCtghRztIgu
	8v8iQhLA9ybh7B+9nEoFKqqURjqyvuI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NOHtkX6M;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6oRZ7bVSXyuafN/Una/b4mH0BdxkEb9tpDXSUb5X6ns=; b=NOHtkX6MmsJFk0WyudbePHVb+Z
	ifpcELU49/bxvCXnPyti3zMDsf3vrEU1uxAk5TYIm/D1FmsoElU2FUYaQQhQ4LoovHo3rp7Vne63J
	YaH62vM9cItZaSIxWJvPMTb1bbL31lHBb0Cf1CDgA8fCz7g0C5l3D9Iv+z7K/HEZOk3iw5NNU2Q5w
	XWkjd05TJgdOjBOzSepKpZBB9dAo9D9Tq9Btj3KmOmB3/bcy+aFEvpv1v4RfKmy2Y8w71xUI4dBbm
	aLBAQDqgpuzc2KJRh2DXEL8L92qWHYySh/ECP6u6w7N7KhG1J+RoXQcK8AMm7hkIB1Cn6XNWew/k9
	8Zw2AsQg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1ws1Mg-0000000CA8T-02wp;
	Thu, 06 Aug 2026 16:54:42 +0000
Date: Thu, 6 Aug 2026 17:54:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anS8UbQF1aE70gus@casper.infradead.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
 <anBqV9z6hVLIqoIn@lucifer>
 <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
 <anL7eZcHnM5mPr_T@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anL7eZcHnM5mPr_T@lucifer>
X-Rspamd-Queue-Id: 8875F100011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zmuhhyxg1bh18yidj6ozfhxfnh6oxsjw
X-HE-Tag: 1786036747-657854
X-HE-Meta: U2FsdGVkX1+//KD1guau4mtgLZMYwVHuZQOUO+gZ2dlMFYesS/iBzGpTbZUH6zK23fxkgfRjT/wvd8ItcdebYNz58en3jv6TITYfDLUIiaFYzSYxOtmoslkS5YXo7E/RazaNZ2Cl9hKljmVaRdW2s8iVh1+cyK/6GyKL0WCb4eCHchR5V4Ez0YMGAr/8UlbCH/zxXyxXSz6++0fI7b1LXZVQacvSNXvtN0I8ru25djNi9qrjsVDdPCn0aACqhPngew97aqpz5V5RyejMIDI0BiIH9fKt9d+cCL0yizhVSK9m/ai4fT5yqBghb4VfVdsgf6ajFjMgPjj5djSNZfZv648JAd5z7Da+EvJPjqPmh5g9bju64sjppkmZaqJg0y+YmNl2ui4aCHk/rnMKgumXNA8v6Bkq+3F7hgcZMRx4jhYgeF9jxa+TOqXI6mmfg0dzpoatKNFNUTBbfVmN4yOTPcgUdK+bdie7hiWWOibY9yR8d/t+al3uXP7T9A/XP6WZRsRwi/JwuVaMM1/oBvi6VYF9uQGN4R7uFbWiCBscJdFFFRFBT3OgtBkqf1ZUozlQoROkJCSZ0W3Y7XnPfteq6sfEoY5Xi3Wyx6bklvUGSZ3OgFlzXNlwQahX3Fir67EJ6DwdUIeIPXJ62cvN3hApH3LkpMobgXF6nDHnAXuMEl5YnOvqCRi7wQWxQhLRbIw60CdOLc8y8Fi00Wc/iJj5m2tksH6nFOJkCBqMJNNct0jkelkioG63qLgu1Fv9BjOPGXeS4Hrtu5HqLNiLlHDq6bq1byda6W2rFF+mzlPO8Iz9KBZjZ6TszHUNz2hIjM/00aksZW945ehbdhk85NHZm1Osq7EX7CaxBP5aWQFnOG4+Z3YPlfSau8mnX2WxYpdyjkZBwKBYFYdcqtG9z9a0q8w5RqeptR3OUpcWVRaTBMT+vQqnhVxWX0NlTZSDBO3kTJ9CeHCDc6p/QuFCR5f
 hSYZZR5w
 87KXIpkrvuWhjB+IimbL5y5Nya6ROXZiMKOX0MCPr8e77frQdjOc3z5kZ+f6i/xMUc8L6diBS7WGs81EqDSZMjPN5veqED6rdMVnRTcQg+kSxwcJZ9a3wUI6t+TMYG0SUwRYJNmbVHUPeC9DvzqYt+zeuCN4NVrQPF94QdpCCvt2YZSIst9ruCDSCdYJBslvn5V8AjRxEOWoZS2eJgPMJ58XMfJp5/seHSHux6iB1wtjtdN61BK8ZrA5CYSf9gE781hxnD3XHEz2h54kXlPmUTa4/U5Gg1/GI7b5K50Ab7tyWSBf8GwBrmOkojVLxaUebrACQPopxLgMFmMx6Px2uluLi51ijQ7GnkOVX0FGMqgUnTIH0yf7KrVBo14WXS9ppCS06XWna+dTLilQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:01:43AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 05, 2026 at 04:30:18AM -0400, Gregory Price wrote:
> > Yeah just an F/A in the print I suppose.  Sorry if that was unclear.
> >
> > If it saves someone the head-scratch of whether some bug is because it's
> > "file" or "true anon", given the ambiguity here, seems like maybe useful
> > debug information.
> 
> Yeah will do on respin I think actually!
> 
> I do think not providing that could result in some confusion like 'hm I
> thought this was file-backed'.

not sure it would.  Look at the whole thing:

        pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
                 pgtable_level_to_str(level), entry);
        __print_bad_page_map_pgtable(vma->vm_mm, addr);
        if (page)
                dump_page(page, "bad page map");
        pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
                 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
        pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
                 vma->vm_file,
                 vma->vm_ops ? vma->vm_ops->fault : NULL,
                 vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
                 vma->vm_file ? vma->vm_file->f_op->mmap_prepare : NULL,
                 mapping ? mapping->a_ops->read_folio : NULL);

even if we don't have 'page' and thus dump_page() won't tell us
anything, we look at mapping (NULL means true-anon, non-NULL means
file, possibly COW).

> (We've made our lives hard with varying definitions of 'anon'
> also... [shmem being 'anon in page cache' is especially lol] so it's
> already confusing but there we go :)

Woah, woah, woah.  Do *not* think of shmem as being anon-in-page-cache.
shmem is a filesystem that happens to use swap to store its backing
file.  I dislike a number of things about how it's implemented, but
describing it as anon-in-page-cache is furthering the confusion.


