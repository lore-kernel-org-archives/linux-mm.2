Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E0EC4452C
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292C76B0093; Mon, 20 Jul 2026 08:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2433C6B0098; Mon, 20 Jul 2026 08:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A3C6B009D; Mon, 20 Jul 2026 08:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C96DC6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:43:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25F5716016A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:43:58 +0000 (UTC)
X-FDA: 85009122156.28.3E88E5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 879FF14000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:43:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUcfoo4I;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c6LTL5Is7h8D95ocgbXWlW7FM4nVTO6iup7BWbySR4=;
	b=tbhivVao8FlLtsM70XNc7hFhcNX6O6uhXZxN0/f/6wWRmSpeFESazhehGCACugBMTG44kf
	dusdFRZw674pr4lgSe6/qYT4p0nMA9HsDWloOejow92Ab/lLJxHLgtGcCGml+RbYc7XDdD
	bfUgM/9ulP6VioCYwd87rbfU+xVbbqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551436;
	b=zwUu/lJrXOUwbk6uqOWpSJQrvdCzVghc6JyKQHtzuOrZZ8Wx9RYdaCxXI/r1Silh/dlUbW
	62tUtxE/3TQ33KEjy6l+TRDDPvCgIXiZDLPXfNiSorskEYiCKFJD4QqLScUZLJfqlhK530
	frJ5bvVxetISRZfexcArU4XGDcIlIKA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUcfoo4I;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F2060A7E;
	Mon, 20 Jul 2026 12:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EA91F000E9;
	Mon, 20 Jul 2026 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551435;
	bh=1c6LTL5Is7h8D95ocgbXWlW7FM4nVTO6iup7BWbySR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oUcfoo4Icd3uA53Ct4ZXYsqZQsaE057RK+n9XKwQWhRB+hfI6GFRjMc8L+U+z5tUq
	 3KKP8uiWQhoA/yS7kogZzjr6+izJG3giyyIF0WkRSVdDowTa5ejo/0RPaXxjJNjceh
	 xdwFW12MQrQXiyeC/dozu/ErLqsu9hfqjEAvR2wlH3WySiOmRq9hXRmgro8DnX8Jf0
	 ygSdzdmIWdSqtYkSDcidG5waZghMUxQqxriWyl/v5sIg00jAM/BJhFx4YZFwRZh7hr
	 cTFOouuznp3AFoSSkxVukQhRtyvYKzLld+neAWQtXredy3IwWyHjAe3dVIG2qtDG95
	 G+ye2STy/aR5Q==
Date: Mon, 20 Jul 2026 15:43:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>,
	Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
Message-ID: <al4YBTQ-aUS9_DJJ@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
X-Rspamd-Queue-Id: 879FF14000C
X-Stat-Signature: ce7idttse1g8huuzwpbxw1ybq4q5upnm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784551436-201934
X-HE-Meta: U2FsdGVkX1/8avtTJwxzfOEVyNTmZ/iUXcNPD1/BN3O61p7phv6IXsa3pisOFRNGe2xRgEqr/o1SMV8VwLmkL1akVhgpjwDYPXJn9c1crfiXf2ALGnOuduNrwmL/pO4PwYtg+sK88NNwNJ+kZNNOw9gR2P+e0LdFhwzQvW4INPP3XLv2PqCdfIoBvC1q41z7F9UxUH+AGjK45Zcu00akbTIkUM69jdoC1MSdVIh5UzUKX/+YLV3HGe2bDy+SkpCp1rxOwxz+c7S0v7zzum4jV+1ih6jMpgR6Zgp7Obva2GjyZa3558uVYbepn0VfLPXb1EAjzdfBUW45AFcD/ICTOrdtD2PR1o7Fhtw1OvzcagyKkENowQshcIV7X8NLnC95GuIhm8tTWS4zl+vOVvXUWnqKWfXJIV73RPYjXdz0H0ko4m7v+s3pIYJBflAMiGG8l46uuU0xxB1b3co5gbNdDs9M/YDk24ofRNNjXtWijlnAgmwd7iquaHB88rvb7C3WUEqeRS0HNJd385DWOblklSzT7N4tRHnHn9W2HA1RIQZj5xmQR4/OhXvxU3JXwJZFrKzA2fG3ni6We+LM/dR4/RbTUKIcyfZz4GL1f/q16vNs1z7WG2pCEzpJFOWo31qzpEbR8XPkncg7n86sXsjTGyls+KuC/Pyfs65ZRdegHUciJIiFwmIV6jGuW2eUdbyrbB2YscdekUBDIzPt3QaiIiY1skRZOlBCr3RHuMRB+nQSWDa8SJgYJ4N7um+H5SR1NbRBqy9PGy6gYUonNBusQQ2Q79ZRd9cod5k6F1nHwvx/6al0Ejx7859xsWalT6+r9Y+bVGIz4/0ujUPaJnhnTB2Pa1h6dbe/0YHskKYMmmarwciOXmooXy8K3T6cwywuyq/llq4fzWDKBsoIRexxaX43o+ldPkBmV7mb69jIONEUjnSALq2+e4Pv6YxXi8U0yNvkIzRY9g8inUz9D3V
 M+FkuVFz
 PMVLrZhZj8J9cwvi+wy1rC/H4KBISqKt6/3VURaCOkjANMkfpU1C9Taa1WcVA0d14qRk72OFpSm8xknJT+LSIdHBNxbJzwFf03Bm5XCgijgGnAa/K4etybt8ZTCzQu9fgW1XVQJD77eiJxpUd8a+tYCFWj5W18U99ds5iFVWcoASt2DvE57HN1w7Qq81/4HbvSOmHd90B3QCmuhacbrAHB1OWXY47kZKECNNTrGi1OkSOfWE4ISEVs0dZm5Pjrokf5sPPMHBvQa0LXUUfTCLAdbMIArkbQy4+MNINRZsYnornOWPRLDU3nqszs+nHvDnHLdbOP0/OdpKVigef0YE9mf6PLSG0Fs4GtcUNKdbneZOg1xmixiQrUJbtavNW/7xRCFNjZYhG+SwjZMnHLtBfhb46WZidScz2mCp2gm065NmFcIm+3ZdBBHvXCaDRR0iAZhLedp8INE6pOqmMn0FEX8OgSFYyjraBHRnmE9nI0xHeXYaaesDjt7Z5ixerYE19Cmjt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping.

On Sat, Jul 04, 2026 at 09:13:33AM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> 
> ---
> v2 changes:
> * replace GFP_ATOMIC with GFP_NOIO in ipr driver
> 
> v1: https://patch.msgid.link/20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org
> 
> ---
> Mike Rapoport (Microsoft) (4):
>       scsi: target: file: use kmalloc() to allocate temporary protection buffer
>       scsi: proc: use kmalloc() in proc writers
>       scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
>       scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()
> 
>  drivers/scsi/ipr.c                  | 4 ++--
>  drivers/scsi/scsi_devinfo.c         | 5 +++--
>  drivers/scsi/scsi_proc.c            | 9 +++++----
>  drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>  drivers/target/target_core_file.c   | 4 ++--
>  5 files changed, 14 insertions(+), 12 deletions(-)
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260611-b4-scsi-d0b0eb4895f4
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

