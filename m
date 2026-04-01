Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F04D3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA9B6B0005; Wed,  1 Apr 2026 04:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91C16B0088; Wed,  1 Apr 2026 04:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF0F6B0089; Wed,  1 Apr 2026 04:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C681A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:44:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BF401A06E9
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:44:01 +0000 (UTC)
X-FDA: 84609349482.04.9260C09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1513160004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:43:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDRk7hWE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775033039; a=rsa-sha256;
	cv=none;
	b=c2ZrnKkoZhmd9DoX/eAAeZxbiSaaZEPb5q4XQU0kz/B7ZY/EiobCJqe0UDEXHdllkul99m
	FXVJPJXnoVFmCW2UKcQfDehQ1teIHE/0NVprGC+n4BEScDqqnfyIZwQNDT3/trlnuWkJBt
	0PXi2dAbCnHERxCiZd7gOpcqO+fN+UE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDRk7hWE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775033039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adSFWjWkUITUihSNQFkomZgD28H5k0L/e8TmUk0Jfbk=;
	b=1GMNIsWeJHGwILuSTShvHuMVlQrrtIhS8TJRWAJjt9dFaWsqmVk0lc5RcOJLDwwDW6pAEP
	TuNJrXSiwY8dJ4pQIoF6C8WV1kqDIG4nbVt4uWt5KkkVVunpFFbTWpkgZlcEI9xeWbJkVy
	7zSpi2ALKPA0RfJeFQ5CEN74e/u+cZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 011E9600C4;
	Wed,  1 Apr 2026 08:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C76C4CEF7;
	Wed,  1 Apr 2026 08:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775033038;
	bh=adSFWjWkUITUihSNQFkomZgD28H5k0L/e8TmUk0Jfbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDRk7hWEztWuldQx5rHfbElznScx6jP4iUi1l92FpDHNriqRCAQ6duHdfkGf6B0aH
	 W1um8Asb6/cDVV7n4ZyJlh9ZhXwm9MWiUzFxCbP42kebOQrFDUHBGRtnnMosYDI2VA
	 zt6cx8Yoz5fEswuU+q+LH1hxFVMf/EAD/KCb7a8tOBx4f5f17uf5My93Je+N2Z2/u8
	 OU7nSViELgn+uwaOEzVFN3hIKFZnpE/WkdZasZPA7Yg/e9jNH+UTwABEbt9EDKiDGs
	 da/Sq0MGvUnRLOskGaWEabyS/8mp1ZPbcETgqQDQgPiNmu1aB9ot61G8Cx+WN1v6uI
	 +Jv4kx5QXLPfA==
Date: Wed, 1 Apr 2026 09:43:54 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Chris Li <chriscli@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
X-Stat-Signature: ury816q7ac8z6nra67yp144cj859j7oi
X-Rspamd-Queue-Id: B1513160004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775033039-217612
X-HE-Meta: U2FsdGVkX1/K92lEFyPnBZvFuGAekBfZk8Klg3i4y1YIOpWCb2ELjuHKfevDlZQZhd2IN6j9+19rorRNOh8xQpmOPtiuiHJp37UKZEgsuh4gvFW7T8NelSwI4rD1+IRNTHJDNTjEWvrpeza1y5ESmIH7caULsrn/wo1KhP5ggcgs2zyU0ycqYpZorhWA3ej0UyUWXPfr/AzxxbPnRyOA5Ku4+Rmmc66qqxmyQXPfs3ewknG92VfTvOeflY+r8r80wtnRByaW5OcjP5J/FZHpvSuwhugHomer7OOAlTSN87pYqsq8YGqpJ6TqIATC3vogOu5ZZkK5fTlBCPCYY0O5Voo13Mijm4+2BDl0W0naLn5Mr5XGrCRD9IQGkQ7kXQoDRSgoKWrhN8KhjemG0eG7IZ+cXhXNhQ+4PXAHiyLNRk0Hojdvv+IA6lSEdOZriCzI0/Jg6aeRokh+nHxnwvZpp9ea7ULZtcsniXv+Iz4IK5Mkkq5tUXAuffD8KgAfD/lkGnwgzQUjQF80ZPkGlAkvH8V0RDaK95hAP6CGf/QyxxlcCj5ct0DmVN2TH/eeZpVodP3WrjDyMsNkpbRFxTF6QpnsF0GUO1+KOfDdJI4cf1cvT507ITm5leEZRzLmhBO/mEZ7KYu1VufakqQL52qVF/bOMA34nnjeiBYGmt46lcSPgpnw8OEspGD28quBJ4YAhjDrd9xuXePQVc4YBbxTyerpeP+Io5z0/8QEFg6Fl0tTTe5d7JG0ktAKAhOXcBeHbJz23caBwgHpVjinJ2ffcW+MC3ynZ69D7Fhf2tZViVcpa1mQsbVJ1H+Gd1bzY9qTPFJCS26jIrcT+E1SJKBiixlf5BevDUj/PMO+vgUfkjczgtcWz4MlIDqDSPnBjD1DU26rW3ZNIyLrkrpAFklv7s/eEZ4LLwNuPISLqlAItdL5x0NPOmXZSk6yxoSyhIqhSE3iqaz2MPrwoaPAyzX
 fP76lYcg
 LluayZQDgXOkUhJ5bi9Rq407ovFnjkMx38G9u//L752HN0M8Z88nHxF3hLK/lPtk878WXWUn4iMmOkHO6mPTFqUSpbJBQi+jcuu+HpBQ9u6f42xRiW0tJcdMymOfNh40ujIKuayXsG9PqrFN814wyQ+ys8knlYEibgJW8F34UURLTPZdPNYSkbmEPnYnK/hGNwLOEHbGc9yf+TflIpXnluGQPv11OY0vMlWqsadUAunqHFZ1yF6veNkYoghZRxngIakBMEG5yVkcAv3P06GiHk9gH+TpJ7ZiHPoC8fgMYvd3Wtw7wkAL9JOiE/Qbku2GorR87So/SzlExJsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 07:30:41AM +0800, Barry Song wrote:
> Hi Lorenzo,
>
> Thank you very much for bringing this up for discussion.
>
> On Tue, Mar 31, 2026 at 5:23 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > [sorry subject line was typo'd, resending with correct subject line for
> > visibility. Original at
> > https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local/]
> >
> > Currently we track the reverse mapping between folios and VMAs at a VMA level,
> > utilising a complicated and confusing combination of anon_vma objects and
> > anon_vma_chain's linking them, which must be updated when VMAs are split,
> > merged, remapped or forked.
> >
> > It's further complicated by various optimisations intended to avoid scalability
> > issues in locking and memory allocation.
> >
> > I have done recent work to improve the situation [0] which has also lead to a
> > reported improvement in lock scalability [1], but fundamentally the situation
> > remains the same.
> >
> > The logic is actually, when you think hard enough about it, is a fairly
> > reasonable means of implementing the reverse mapping at a VMA level.
> >
> > It is, however, a very broken abstraction as it stands. In order to work with
> > the logic, you have to essentially keep a broad understanding of the entire
> > implementation in your head at one time - that is, not much is really
> > abstracted.
> >
> > This results in confusion, mistakes, and bit rot. It's also very time-consuming
> > to work with - personally I've gone to the lengths of writing a private set of
> > slides for myself on the topic as a reminder each time I come back to it.
> >
> > There are also issues with lock scalability - the use of interval trees to
> > maintain a connection between an anon_vma and AVCs connected to VMAs requires
> > that a lock must be held across the entire 'CoW hierarchy' of parent and child
> > VMAs whenever performing an rmap walk or performing a merge, split, remap or
> > fork.
> >
> > This is because we tear down all interval tree mappings and reestablish them
> > each time we might see changes in VMA geometry. This is an issue Barry Song
> > identified as problematic in a real world use case [2].
> >
> > So what do we do to improve the situation?
> >
> > Recently I have been working on an experimental new approach to the anonymous
> > reverse mapping, in which we instead track anonymous remaps, and then use the
> > VMA's virtual page offset to locate VMAs from the folio.
>
> Please forgive my confusion. I’m still struggling to fully
> understand your approach of “tracking anonymous remaps.”
> Could you provide a concrete example to illustrate how it works?

I should really put this code somewhere :)

>
> For example, if A forks B, and then B forks C, how do we
> determine the VMAs for a folio from the original A that has
> not yet been COWed in B or C?

The folio references the cow_context associated with the mm in A.

So mm has a new cow_context field that points to cow_context, and the
cow_context can outlive the mm if it has children.

Each cow context tracks its forked children also, so an rmap search will
traverse A, B, C.

>
> Additionally, if B COWs and obtains a new folio before forking
> C, how do we determine its VMAs in B and C?

The new folio would point to B's cow context, and it'd traverse B and C to find
relevant folios.

Overall we pay a higher search price (though arguably, not too bad still) but
get to do it _all_ under RCU.

In exchange, we avoid the locking issues and use ~30x less memory.

(Of course I am yet to solve rmap lock stabilisation so got to try and do that
first :)

>
> Also, what happens if C performs a remap on the inherited VMA
> in the two cases described above?

Remaps are tracked within cow_context's via an extended maple tree (currently
maple tree -> dynamic arrays) that also handles multiple entries and overlaps.

>
> >
> > I have got the implementation working to the point where it tracks the exact
> > same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> > under RCU.
> >
> > It avoids the need to maintain expensive mappings at a VMA level, though it
> > incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> > (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> > pretty sub-optimal).
> >
> > I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> > work to avoid this issue, and will be developing tests to see how lock
> > scalability, throughput and memory usage compare to the anon_vma approach under
> > different workloads.
> >
> > This experiment may or may not work out, either way it will be interesting to
> > discuss it.
> >
> > By the time LSF/MM comes around I may even have already decided on a different
> > approach but that's what makes things interesting :)
> >
> > [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
> > [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> > [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
> >
> > Cheers, Lorenzo
>
> Thanks
> Barry

Cheers, Lorenzo

