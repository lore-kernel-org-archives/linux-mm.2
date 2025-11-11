Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5379CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE9B8E0024; Tue, 11 Nov 2025 05:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F598E0002; Tue, 11 Nov 2025 05:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027348E0024; Tue, 11 Nov 2025 05:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE94A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:05:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8DE91A04C4
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:05:18 +0000 (UTC)
X-FDA: 84097893516.05.963C4D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1ABCC120015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:05:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZinXmRZQ;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw01WpZHnZnNghi4nzRuevPnhz/lHQoMbtS3uJwZLMk=;
	b=ZjzSCkprMy2DnRXc1qMhY1Jx1jeIbO39nSC2SzZFA2pndrMa4uYfEYhqUTfY/gO3Wq0OD/
	2xmpuPPdqfMVQxQ5ywbJXVR9dzmcq9qcD3jg+2hVyFfi7YaxAs9mKMSwEVfvvNMf1n1RYJ
	C1diM4hIldcI/buTj7oYCz3dlYn6i4c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZinXmRZQ;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855517; a=rsa-sha256;
	cv=none;
	b=6KFF9SY1sbBrkUnmGpDdx4KYYlGydqxaWMaxhPZq5e+qqd8beHnSer0NDg4jInHFSrptV6
	eN60smRKfwAQLxISNRG78RIayNm/J9KPKviZUkX1tHYEWnZ9nfY4hcOFg/+EhshiHayGnI
	MhrY3XP2U36dn5UCX/A+mIhi9+JkyAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59EB561903;
	Tue, 11 Nov 2025 10:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E745C116B1;
	Tue, 11 Nov 2025 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855516;
	bh=SwY69HX5+VyJGypqI9OgmzagGzzfnjk24hRcW5iGh84=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ZinXmRZQK3QA863duST9CN8mQG/mCA8r6mYuOdmlL6KZ7dld0KrJ9fwEMzM2nc6tJ
	 v0KemDEcB4Ng5aonY3wcZ3kIseZOeIaxndeuS6j2qkqPuK9RollPoXh+2ZD0aavIeQ
	 wzcX1wyiP/EPerloWZJwQ0dwuhNHqWSTWqMLZFDj17+SWm9tNLK3YfDy0psKJDV0bu
	 UMXS9G6IN9b3jUYQGQOefsNxSYaiKfGXspdEKFB6AkSXnUYseUZ3INd88RBXLHoh/I
	 bX/ZMR1HnxHTlXewIiBRYs0EJ+API7Q+RzJ7TnSd6l5fAjblN1ElSUsjJr+FaWqJHo
	 yomewFZj8FEGQ==
Date: Tue, 11 Nov 2025 12:05:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aRMKUoB/nc5A8ZMf@kernel.org>
References: <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQmplrpNjvCVjWb_@kernel.org>
 <mnjrtg62qh2rd353mbudryvs3neukt26xtovyddm5uosxurmfi@lldnrp7a3666>
 <aRA-se6hJPzHD3mA@kernel.org>
 <ulpftgdk6hgorwsrbtv2tv47b7usn3cow362knuxlzq2az2cl2@krwo6e3zxryn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ulpftgdk6hgorwsrbtv2tv47b7usn3cow362knuxlzq2az2cl2@krwo6e3zxryn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1ABCC120015
X-Stat-Signature: 1xiz886ot4ap34yzxy9faifa1xj43dwe
X-Rspam-User: 
X-HE-Tag: 1762855516-183515
X-HE-Meta: U2FsdGVkX19bMKhdCPCP6OOYlfBq31iY5smpMAFIeY1++b9MgADCCdf/BQmyPWPG2zxPsQ7y6ZDXgwcIlnfvtQDTMtik1NXZ7B1QkzHbDOM06DNi+y0YQZpYg1IYI49bbwqz7cSne44SY4bkBJABZcNIxr6q2TqQMtGzbJ5H2knR49BORjTHAPz1L3g/NpCabBka7/fNzpKWneppjGMc8+ld0+4/w5vXY1aJrC/73Jc4+SFr7leDioit9fGgYqot6djU/ilWT1mAuViBfZ8z5AE5j26m1zdAdXMkhCqirCb4LD18s9v19YnTiad1ZD+qPtUal2gmkHtb1qTFjAD9tQCSzQZpNYK5OJxtrV8T9H9Opi1lb+wbcB7D0s8KPZEsnxXcenDTbWd2jz/knScnX8adEuVgehUXiQZwW1Kx8xAkz0JeI1gUzHJSA/lZdvc7yCPXPXJ9JghVqY/UGhd2j+n7zCqbTsejB6idxqFsVu0rVnXoW5MyCqriP25qKQmgMstqEklajH0yVJdo6qJsDnT4fSmp3M1vtyPBAPXcW0zUto65LjiHnUs85C7RoDGOso1hHwIdlBLIMdDLMRWdePHEcysOwdOGQWiXbjSTRbcqYdYcrI4F3bYAB2YQpwlwP8ysEx8RR6EwdFwDQ1KhnKw7IcJgaJbLLInMNFhPslSgkdvVCe8YTrGjKyqOVlw8xv3E3ONYO6H5W7jzAVRzyld1q8qZS2c2qpiIt2CjuqwD5gFmqtLw9P5AZ8zNcVhWLzfCyOWasehnsQHwRdRuVG2J0ljC0Noy4Q6SiASxGtUnaitxG3ccd/xmMk/cqUgYCU+hhn4cV9PyA2kR8F2E+oe5+oeNTNuu9AjB+txtcOn/HZ/FmJttALJeF/EY2MILDjFURfqIzkiutve0wWmdlAmmnWeca08aPgb5+NZfqjt/qYQo7haZUXhSqeuHd8yT+l8qH6DNU5ujaX0u4ah
 26STci0W
 tLDK4/pzQp2DFNjq9/u4nDU0HWfjQRyRN12BoITkWOlHv6pgeG1G17F4cooI47OwZJ4E0lYWDqoL4Y84t6RE3n52LAj1eWp0bh3YNsGRsKxjZ8Y/0RDe4DNmkEkZUxgm5l0Kut0o+yKSSKGjwVmcRg++VFJnn0om5mPFxA5NH/luFhdRiw9St9Nm4FRX9ATn8OVl9JsrXRCRZUc/Cl+RW4MM/r0oQIjh2p+IsYP/wyQwMiIkx0s7RzDlTFKfyTOIFxsW5tifpBmrpM8O70yQQcOewCYeEXeN6OQjjubNa24os6jdpgJfnoRGn785I7spNmzt8xvCHXkzg3A2+8IQb6pjEqgg0bwFMaXvT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 11:34:59AM -0500, Liam R. Howlett wrote:
> * Mike Rapoport <rppt@kernel.org> [251109 02:12]:
> > On Thu, Nov 06, 2025 at 11:32:46AM -0500, Liam R. Howlett wrote:
> > > * Mike Rapoport <rppt@kernel.org> [251104 02:22]:
> > > > 
> > > > It seems that "as simple as possible" can even avoid data members in struct
> > > > vm_uffd_ops, e.g something along these lines:
> > > 
> > > I like this because it removes the flag.
> > > 
> > > If we don't want to return the folio, we could modify the
> > > mfill_atomic_pte_continue() to __mfill_atomic_pte_continue() which takes
> > > a function pointer and have the callers pass a different get_folio() by
> > > memory type.  Each memory type (anon, shmem, and guest_memfd) would have
> > > a small stub that would be set in the vm_ops.
> > 
> > I'm not sure I follow you here.
> > What do you mean by "don't want to return the folio"? 
> 
> I didn't get this far in my prototyping, but if we have a way to service
> the minor fault for the memory types then we could use the function
> pointer as the way to change how to get the folio vs passing in a
> pointer to get/set the folio.
> 
> > 
> > Isn't ->minor_get_folio() is already a different get_folio() by memory
> > type?
> 
> Yes.  If you are dead set with handing the folio to the module, then
> this is what you do.

uffd does not hand the folio to the module, it gets it from there.
We can make it even clearer by changing minor_get_folio() declaration to 

	struct folio *minor_get_folio(struct inode *inode, pgoff_t pgoff);

-- 
Sincerely yours,
Mike.

