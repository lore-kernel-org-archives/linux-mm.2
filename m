Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B189F10ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2533C6B00A1; Fri, 27 Mar 2026 10:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22AD86B00A3; Fri, 27 Mar 2026 10:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168636B00A4; Fri, 27 Mar 2026 10:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 037EC6B00A1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:27:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5592A8C769
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:27:53 +0000 (UTC)
X-FDA: 84592072026.20.6E4EB08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98BD71A0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:27:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYXIObf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JXIm2Xj2qLm/gvO2PDhrQxl68dUCWae7ALoM5+URVc=;
	b=Ppqt/bSSs4MyEh9ZKE9Y30IkiN0a61o8xN4lYewnl47yBwNNpEB37qPnZazHG0HjT6ve4o
	D2AWWUbvMTwzBlK6ma3Ly+JfyXGoTUthH/bKp3dQ2CSl/FOS2etbK5T/xKtJGIrB3F0yzW
	K0nAqoY7qGum3bS/lF8rnPB22kwHkGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621671; a=rsa-sha256;
	cv=none;
	b=F0wT42KUsH+WJ0Tp0xAxdbuQCS9LTf8SZaGJyUSp/rqtIlw4N8cbJavdA36IelvFBOWNe3
	T1yRh7zkjoZwOgE/0+a7Ekp1WUP/uOpLXQdGBtk1qGfIQeOFt7+zd2pyIxb1eaU3qNuGWi
	/W7GowQD4CJqwGQkX9QbWpe4SixR93A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYXIObf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F75640514;
	Fri, 27 Mar 2026 14:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85B4C19423;
	Fri, 27 Mar 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621670;
	bh=uMjc7wPnY72/FTyi9HtqnZvAKSirFVCXJFk12jkfT0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYXIObf7u8E4inwhzei0ZhB54zhLmqaQJW2Mgn82vk3W8OqKFIGgrWF/voGXxD701
	 iLe5EZtBwbCZ8dVYYHyH4eFg4i9J/28LoZXCw/5KhY8bkJz58uhDxgwrkmyDkvZFYP
	 4PlSOYXOB8vPpr4ZlXBWvmAy7PaEuAJo4hTnqvf7eBb2OcuiOV/594dQ81X6wEpRS4
	 pK4VFeuspmdvPdzQ8hUm7gHqRECSdl8K9R4XF6aa0JK/mPF7vpaiN6bRBkOoSW8fKO
	 8rPObuyN+KIaXZ963D5Vd64yLKJLRPByatVodri9aSPYQbIVQskYwegWRWGjyXEbfg
	 Gl3WCR+Vg9QaA==
Date: Fri, 27 Mar 2026 14:27:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Message-ID: <4007802e-f87c-41a4-8dcd-9af867eb3fac@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
X-Rspamd-Queue-Id: 98BD71A0008
X-Stat-Signature: enx7y981b7gnet5ha1jddro1irtxqfpe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774621671-590931
X-HE-Meta: U2FsdGVkX18hmqpJLXNPiEopZlhY6SXhD23MBsfKF/Yx1JLoKDvNHEJNdEq3lgekx4VBU9KyLBGMXEgRVWUpOkC5FBRDPM1X3TdQSJE39pqh/ygyQ1sfrSh2C2dOQdnDOgeYxK7MRCLSY7CLuZu5DRPgie2a/bG9nxBeOZLXh1Z+2h4a7xzFXfmrqZS8z+x10vSTxDqsJWgaV0a9rkxPxxvEHzgQZ1q/4RyLHBumGU6tioR1IdjaaocfcCq7OgmUuzwWqPE0TKwTvUdrJJfeNRvM8Dhh+nNUbZdf3O+Cj+uJNaN7dbCKoaQvJbG2qe3uC+tGlh+Vya+4bP9pGIUTgqmaCObGPCslkSdxLjnYwEgOyItMn5XzHozeQU8IHBD6CsOh7UUia7S0wVxTrmShLx9VUKbCUrvL+lg7Twz+WTEMjyt8bQrNLwVSvppMgle1Ht/DSWZCV/rNCf7EPzXLAfEBqGU1+igGbpQx1AW3x/VrlUdhzTAZB1sezAphhPnhKriWx4lxNsxzrE+cFpeiLrraQF6hav11Jw/r6mTaQ/HyC4z8Lq6X1gDrCXNqE/u7xn8/oqhd1du0Xr6PK1ls6bl0WFKIlVgWdcebhkH9KYCtdrllNphASXgg2pGMn474gILUpNMuq8vQRPD8+KX+n6dXbABO9oWFe1FvhaJc/2gymP+bWa+bhMIJ9yPiNs7drmmdLrM3ObbDZqjb0YqDvEFmcw9JPWm5hUjDVzK4DzgWl9lG6XVJ6O+oP/VZz/IHR8hhZZajhgSugcSB4SLlb5pmwDEKIc9XztspjLvHD14qp0GvLFEgerFIPeqiSfSvOQuCi1pSxmveDd1u2MfIgTn22BJlkmp7dESZgeGsWRpIvlmBiL7R2b0hynASJ1gqmkXAYNZANFOn1g0/xtGaYoMSHheYDkCOS8o5xySvW331a7cv2BT5dDzJDO0ae2nug61rHuIIIHNiTBSprW6
 CCbPjM/5
 A8/s41xD8H8REh8sNRXbgEC8JR+MiGYz3slS5yIdqs1RFfhH5MbmBw/2mnTjtnYJ5xlVSVAallQLnX1BWSMikruGku0rpuYQC5KIDIT38JTGyWFmLmPmaWcCTitDbfa15FlgS572eoaUyascY+aE+k9nzmW3nHz8C7ykPn/UOW1Jq9l/kfQcLDcOYa+UUY5v7crHf45YOTnxbdDvWlvgDAdUu1NyxFbj/l+UALlojg2Vj2yg7AWap0JLpB3GmSeiHy36LNNIyuX3SVWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 02:46:43PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 02:42, Zi Yan wrote:
> > Hi all,
> >
> > This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> > read-only THPs for FSes with large folio support (the supported orders
> > need to include PMD_ORDER) by default.
> >
> > The changes are:
> > 1. collapse_file() from mm/khugepaged.c, instead of checking
> >    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
> >    of struct address_space of the file is at least PMD_ORDER.
> > 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> > 3. truncate_inode_partial_folio() calls folio_split() directly instead
> >    of the removed try_folio_split_to_order(), since large folios can
> >    only show up on a FS with large folio support.
> > 4. nr_thps is removed from struct address_space, since it is no longer
> >    needed to drop all read-only THPs from a FS without large folio
> >    support when the fd becomes writable. Its related filemap_nr_thps*()
> >    are removed too.
> > 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> > 6. Updated comments in various places.
> >
> > Changelog
> > ===
> > From RFC[1]:
> > 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
> >    on by default for all FSes with large folio support and the supported
> >    orders includes PMD_ORDER.
> >
> > Suggestions and comments are welcome.
>
> Hi! :)
>
> The patch set might be better structured by
>
> 1) Teaching code paths to not only respect READ_ONLY_THP_FOR_FS but also
> filesystems with large folios. At that point, READ_ONLY_THP_FOR_FS would
> have no effect.

And also please do some cleaning up of the mess we have in the code base if at
all possible :) I feel like we're constantly building on sand with this, and
should treat every major change as a chance to do this.

Or otherwise we constantly keep leaving this mess around to deal with...

>
> 2) Removing READ_ONLY_THP_FOR_FS along with all the old cruft that is no
> longer required
>
> MADV_COLLAPSE will keep working the whole time.

Obviously everything should keep working throughout any version of this series.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

