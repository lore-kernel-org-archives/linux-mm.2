Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63E7F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C156B0088; Mon, 23 Mar 2026 17:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D506B0089; Mon, 23 Mar 2026 17:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62A56B008A; Mon, 23 Mar 2026 17:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95FAA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:02:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53E02BDF27
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:02:53 +0000 (UTC)
X-FDA: 84578552226.10.505C230
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19BBF180011
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:02:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hMFNFZka;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774299771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AOsenzNPAeVFjUaTF+EAsvLlXdttCRQbifAIz71hTA=;
	b=Guk8wXJnOl9hzDhfwWUXD3wxcUidxi2Pne59Euf7iOJWGgD9w0IMFx0DV68WZgCQ2s6FDC
	Bwv+K0pwBf0CY0Md8Yvu2RcNRe7VbNKrFPyXVsFHb71vHIQ/T5u+UB4ZJhf7ExSrDnvJnP
	n01C0xiMhzmYoPUz7Nycyuw0/bZQHcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774299771; a=rsa-sha256;
	cv=none;
	b=t/8DKf5XMuK+9hI5Y7WOBwE5y5UkwGUyEbmNc1P4Alc0C4DpQ5F5E290f4RWOy/ZllWvci
	fV/KXynodgSzKCpkxvoC5Lc7feoX8KccKdgrSN7+HSWGTPYKkYGGF4n3DVqsWdZFwBFfow
	vWci3tBABRI+NSlWfSd+57M+fBjZ5aM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hMFNFZka;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3AOsenzNPAeVFjUaTF+EAsvLlXdttCRQbifAIz71hTA=; b=hMFNFZka51FeDea+aaAXkA2sMF
	Xw1RTmW14PACkldpXstX1oEG7V17NRMgrH1Qhur8aqWusYInZoN03g2Z6340NcVy2mw4TpwjSBezp
	WaNtfFjPeEzZsvs7EvK7QeT5a9JJUOI92MC9ntRqcpID+pqBqOGJIdR10b0nYjZyqHAQiusU/oenP
	J2Jp2DwPzXYy1NYC5ZruGx2qP6kHRhpGbcb3oMRJ+g6uzyWnMs79pAWiFeLP1v7l4/1O4wtoq0CZs
	h6eg3GZYjQsVZBVlAvJfHnW1SitoXoTr3Ri9pJLyzCIhAOKJOBWXY/5xfXaOMqSG3p0ynbuZzSNbF
	YTSxQfbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4mQ1-0000000CsDl-3RRd;
	Mon, 23 Mar 2026 21:02:37 +0000
Date: Mon, 23 Mar 2026 21:02:37 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 code in collapse_file()
Message-ID: <acGqbeSjktT4biku@casper.infradead.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
X-Rspamd-Queue-Id: 19BBF180011
X-Stat-Signature: jdu1m5w41tiypqwj5gre71sr58cyp6aw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774299770-277859
X-HE-Meta: U2FsdGVkX1+OlB0FvFzecJI2EBPIxxV0W0TOaVCoU/m9x8ZOKj6rrNxeI5ZjpDd7GjlN5EANCfbrD+SfJaVlzH+6RXQWpG6KuFmW29WEv2Pjwm7p+wZNlP0P8uM5MsSPVlq5zUrdeCLC9kyfez2+tznRRXPYiuijNuzuz9ovy8unHO8UMEbjvAMQ3VJG48F2KftgOU2nnULMM0jZ5ftUu+Eod+i21YcDhUZCjCt13bmI1lFhPDnenVR4pu2Ix7U4UWkaZzmXPjnwBNWivlmsR6yUT3D4ZHMLEaksiaKB3cNgvdzfeHpgy4T+n8ccejt6RnaOlekEMvt/1rv64pT2DxKDlhv5x69RcVgcMG3NizENMwI+ESlgDJhJI9YlzqjDql1awJr8WZpkyy0tb0v5gQ/90SrQvZR6yNDN5JUVYGkd1SOa0Eodxhhw3LS6bgVGffZ5UGQjQXs3z3xN8cGzMF+1d78opB5j224pl0TRUsYvIs8ZfflG3wHLCl7J7sZLuEzuQxtQsZLCU074qN/BVwFovXKQxXfxPlq9GX8nhajiUwIWY9S2pVhqEbP1q3njK/D6oZV3eZb2tmXPmFpGPhdVCrFC720JMkxcJd//OhRWTFy1hNg+eLydubr4HacJyrlMSYkUx2Yld5cQCh3J66nXEhYAy/cSoID2sDba5cDcDE9vVrTb1ecgZON2PJQ5QhF3rDOtHXRh5kQBoROgtoiGCMX2LifnbNt7SwRjrtQRowmtnwwfXlablf5pXCM7tnMx0WGzGls8EgEZIJS7qRVjsG3tMhvXsGuKHPxmg7nR2bbcY9Ru3BU3UZd9rAmvL7hqybdBNlfH16afXUl+L0aJuxQoec2DYgIKfrSiiWf3Hv0ueCWz3gklMDl6dsQvQjd3sPgo1pAZIkfx/mWo61qMhYcyb5DMdZBVaZbG0BywCQ6E+y3jKCRl0WFJakXyFu3cLdq2Vnip8TLPv45
 CbqqcVDA
 pzqMovUwp8rp+dbSCzf+QakCSfEHi9DkHjinY4NPWBwOg1uD5zyDs/4WdQbEH9dbMGtgI2xJ3kSI19Ms8WFA+yd8R3NZ8jqvlCCb0moTvjEPWBvoQIhZk0s1JU3ulwzVsCfBgmzg+i55SpWqu/MKxH9rralsmV6zpNC7dRstrcZ2rzmLJrpmZ4zT5dggACbCYvL7rUDtsR+X7yxXBPnsWndMzk1ri9GMGZtFfMPS+QMfhrOljFl86AxbzpCx0j5WjpfzZtCgcQSCwqM7wrXXYcsxWV+Ni43+lvF1TLfGsZ4pd3dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:24:26PM -0400, Zi Yan wrote:
> On 23 Mar 2026, at 16:13, David Hildenbrand (Arm) wrote:
> > I assume so, because for executables you would have to be lucky to get a
> > PMD THP? So I don't see the non-khugepaged large folio support on par
> > with khugepaged support.

Not necessarily that lucky; if you set VM_HUGEPAGE,
do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
On busy database servers (and is there any other kind?), khugepaged
takes too long to run and find opportunities to collapse text pages.
Like, days.

> It is more like turning on READ_ONLY_THP_FOR_FS by default for
> FS with large folio support instead of removing it.
> 
> OK, I will give it another try.

I think the test needs to be:

	if (mapping_max_folio_order(mapping) >= PMD_ORDER)

as there can be cases of filesystems which support up to, say, 64KiB,
but not all the way up to 2MiB.  I disapprove of this situation, but
this is where we are right now.

