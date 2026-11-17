Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9599606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGl0PMKr
Received: by kanga.kvack.org (Postfix)
	id ED5CC6B05B5; Tue, 17 Nov 2026 05:29:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD1E6B05B6; Tue, 17 Nov 2026 05:29:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA246B05B7; Tue, 17 Nov 2026 05:29:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC4106B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:29:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50E821603B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:29:43 +0000 (UTC)
X-FDA: 85444239846.01.47A9CC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 961B4180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGl0PMKr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794911381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xd4kH02h2/RHBixGr9Rh7KR37RCKshv/F2OBniMhWQ=;
	b=XarRKS1VV94Gr9WT+bWwuWPc0QRj8hTKVCd5k1Fczihn3/HqK82Vuk/MKz42+RtRgoI8MV
	bUVUEMhLkxflcpWFUbKTb/7SDylGN8lXPEwDwhuKfABWw5MkRTMWxBMoiJQGgt38AdcMmr
	O+6I00eAM+wkfTW8iHs9HrihUbEzlt8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGl0PMKr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794911381;
	b=SZhz/YgXZJjORlM+zk7Ur9i9xAQF6oloc9gTZ5XtMc/0S1QoA+vImXBFBu9J0HNb5/hWQK
	kBKeSmBns5jb3WyM82lMLpIh3cbBkZAX6wzq0yMfGN1Rq6OrxaiYQ6r+W54wcuuj6tR54B
	hSPDtftDe/4QzbYiCxn/5eMqFLIG0qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C49E645929;
	Tue, 17 Nov 2026 10:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFEB1F000C4;
	Tue, 17 Nov 2026 10:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911380;
	bh=5xd4kH02h2/RHBixGr9Rh7KR37RCKshv/F2OBniMhWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nGl0PMKrFNzmEF2BOR91pPrc/W8Z37D0KlbhQz16W2M5WXKx0P28v6EFJFsxZjHdP
	 WzoR40aWQ7oFNbp3kQpkcI3S9JG4kxjcvWPr8vQGSifi4qQ7BLznI3WQDnvx27V7XP
	 UuiNMSAP++eI3vrHz0Vvo7cP55LwH1GIH5xt7nGwL1qeluQSMdfGr3heGCbUaHij5l
	 ILtcQjiosvjoqfGiSlbuEuRkENr2+1iJjcdTueyLNfE4CcEWCJ8/zuQ19dc5xP07Js
	 Mz9nJdkqUVU+uguT/oouZnicCApxQw8uk/85KA7kTJ916TYYiv/9cKjQ+G5xXvYxyU
	 lqIh1/NsdIG8g==
Date: Tue, 17 Nov 2026 10:29:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <avwsiDm5bM0OCNIg@gremlin>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
 <8092de9e-3146-4fe7-a235-01ea8efab08c@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8092de9e-3146-4fe7-a235-01ea8efab08c@columbia.edu>
X-Rspamd-Queue-Id: 961B4180007
X-Rspam-User: 
X-Stat-Signature: hb1aqunyxizmwwxqimiy8bm6155e944f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794911381-655040
X-HE-Meta: U2FsdGVkX18f487+dWiK9y8GLHk6fCmPZlD5E6BgoOLlnvZxB6hMMLZGH/8PBberW+NqDejF70pPj242OhEJG0Hy6wwtYj39F6tXRISyCTJJVDAsASeDBNQe2y7gx+pWiV8F2Iei57XWlhZ+t7iz2/v1aZ5Ij80LtuvK65G8qPjRVtyNKW+sWC6qdRYFp0/8QhVqBMvclqQjn3MbB4C6YqqOVSAyiDbahZdUnCpMLJN5CWoNuZjDnH/eLchuu/Omnf6tSbjy/APTQ2HFc4q+9B2NG0NbGYY3xjh4sfJZK9gGyzijVrpusddp/6WyZRfXHp1IPHGVLUrjqa3PLTR65rcN9Zbfw6oH/X9Ab6FVvoD+luh8ZibdSawOS4MGfAuLRbTrt+hR6OddbKwL5r6YRIzT35FBNMaS+IdXVviHOhzMF72cPN0BrNpKgzRRDwShnVpbqfa2YSt7gZclTf7atFImmKBgW2zJnJCXCxxORvXnIoKluF5qlqfixxYoJQqVTyiTeQ/fVSFRRCM3ox1TulQegelw+fiET0wmKq40IYeRX9fOqiC8UAd7KFUWxKSZ6iDl69EqeExTD6/Y3atFgMGOf7s6NjuilsvVVA65GUhzQQu+7LQVMeRMEcGGVnafGclkOutmSpXgmhDay1RqKvDm6mgKLBRFGei9nwcQfdL55OayXKEDAzv+yoEx1C+afF9MwzELH5t0igkC3Ef2b06vg8Ja4wlH/ln5FnRq2TbT0QeXeLqDMyJkhSLAabe5fqEkjwEAhV86/mwQdnwT1Bpeyo2wrA3CFlCArVd+rlBEloGuqhzvOFLkeEnVCyixKGruOLxT6XMkKwcpicPTBQ0GvSy1QyDKKHcfS1vFOIBdLXRVVaqClfX6UfLLjhI+/USbyrngkYWl1LYZ59kAiq3qLq5gXJnwPIa89FKxiFq1PtVmqZ80vGcT8AykfYJshfAFbE3XXsgqKNHIL5Z
 c50mfYfL
 ryefK9as9dFOO5gURq3BMRkYaHsIIZB6MZbUKC2avCiPAAzinhYayyfwCfGVHc+sngNAlBzgr5jp/ypE+AH1gtbvasY5GjtlL1nhZ8F1z8BjSK9HqADuTOFppVk/M0eFpk6YLOqtfhc+RdnABkni+lzF155bUBsE5pibMIrTJXPcYJCBHsWIEWm2FvaScf7RyozGUmfa+5Gm5H+nFH1Ahdgjg0Dw+vvAW0a8oxXu+oFb+6JDpEaZiG+n74HHCeCAhBhQN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 01:37:06AM -0500, Tal Zussman wrote:
> On 11/13/26 4:04 PM, Lorenzo Stoakes (ARM) wrote:
> > In order to establish guard regions, guard markers are installed in the
> > page tables of a mapped VMA.
> >
> > However, problems arise when one tries to combine this with registering a
> > VMA for userfaultfd, as such operations may themselves need to install page
> > table markers such as uffd-wp.
> >
> > When the installation is attempted the guard marker prevents these markers
> > being applied, which can lead to unexpected results (especially if the
> > guard regions are later removed.)
> >
> > This is especially problematic because guard region installation causes the
> > regions to be zapped first, meaning that the removal of userfaultfd-tracked
> > ranges will not be logged in this case.
> >
> > Additionally, the uffd-wp page table marker will be propagated regardless
> > for file-backed mappings as the zap being performed does not clear these
> > markers.
> >
> > This is problematic, as it can cause repeated failure to install guard
> > markers resulting in an infinite loop.
> >
> > Therefore, update guard region installation to invoke the zap with the
> > ZAP_FLAG_DROP_MARKER flag applied.
> >
> > Both before and after this change, uffd remove events will not trigger on
> > guard region installation, nor will write protect state be propagated after
> > guard region removal.
> >
> > This makes sense as conceptually, guard regions mark a part of a VMA as
> > effectively unmapped at the page table level, and removing the markers is
> > like mapping the VMA again, over which operation uffd markers would in any
> > case be lost.
> >
> > A survey of open source users indicates nobody is relying on installing
> > guard regions in uffd-armed VMAs. Software including glibc, android,
> > tcmalloc and CRIU were checked.
> >
> > This change means that any already established guard regions are removed on
> > zap. These will be overwritten with the newly installed guard markers on
> > success.
> >
> > However, if this fails for some reason (fatal signal likely the only
> > reasonable cause), guard regions may remain removed, and concurrent faults
> > may succeed in the interim in the range.
> >
> > Since the installation failing guarantees nothing about the range being
> > installed into, and since success overwrites with guard markers, this isn't
> > an issue.
> >
> > Since MADV_DONTNEED does something similar, abstract the zapping to
> > zap_range() and call it from both places.
> >
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> Tested-by: Tal Zussman <tz2294@columbia.edu>

Thanks! :)


--
Cheers, Lorenzo

