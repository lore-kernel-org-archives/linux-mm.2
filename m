Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535D1FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EF96B0092; Mon, 30 Mar 2026 06:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816F66B0095; Mon, 30 Mar 2026 06:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753876B0096; Mon, 30 Mar 2026 06:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67E5E6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:08:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 197401A0578
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:08:11 +0000 (UTC)
X-FDA: 84602303982.27.2F5EE07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8743F120010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:08:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uZzBIToK;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kicT6F8WpHZ0Qc54gk5+rcnNzFEe5JY9i1JEzxfuPDw=;
	b=zGrKeWXM6xUW1bbb+ielZzhsgPE5ULbmKAMWeKdzRRzXKxu1O47GmbHBCckdx/0EcnvUw7
	fcr6oyCnpVaHkTnMYcyCmeg9dXVwWc4Mn6lrYGspT2orWc07hUffmBZTK4urZCh5Rzl0gD
	NDst/FiC4ickWt6zWROJ0ibzA9HhSSY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uZzBIToK;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865289; a=rsa-sha256;
	cv=none;
	b=ZkvdGEw/GIayJ8eqYTYWIJlGJNhkZvi/oWgqpHiN0D+JWrPDV+csBOxEeNzn+vyRC2SG3K
	xvKFv/HIMzHxAJ7/Wl455IGWdbQRbH4EIDKTgp0/A2v120ScjEDQypUFJEekEKHLyto+xd
	Cz6g1IsZwzs1j8quJOKpyehQJfV1OdU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E569160121;
	Mon, 30 Mar 2026 10:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC87AC2BC9E;
	Mon, 30 Mar 2026 10:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865288;
	bh=zSuk3YAaNeoWA1+jafoCnRALi+4LW8X0F4l7zk/vIdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uZzBIToKXeQigJM8i1OsF+igq7IET4IErXdbLhvYE+FfHmcnV4Hhxw7mgurSKMGhS
	 pHW/2ShcyHg+HYJJeWb2WaJGTLoZzwT6jYqB5BfM/oKExvqqmCSdk1cGics8iRFyWn
	 n1IHvYOAKDChsT2Zdh+e0tk1uP6gGGcflNibyHm6g9lwPMDQOpoZmwAoHfb/1Lzwq8
	 TcV29cqHcxV6WqCDkfX+xGI06Z6CuJNZ61ro6OYAKD+bNsCsdE3ChNflvtJYnbOMtN
	 mabZPAwnSoVs+L9fSr9+d1LULt/04ijBf9E9vLuO2hUwAB3k5omN62JHNgoO9MrJ0c
	 437As3WiQj0fg==
Date: Mon, 30 Mar 2026 11:08:02 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mm/huge_memory: handle buggy PMD entry in
 zap_huge_pmd()
Message-ID: <21d21f2f-addf-417b-a9f6-6458340761d9@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <fcf1f6de84a2ace188b6bf103fa15dde695f1ed8.1774029655.git.ljs@kernel.org>
 <CAJuCfpHQj+-nfkDA+kH8_KhCtrPixLvHnJcTK2KtWLD4wXeeyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHQj+-nfkDA+kH8_KhCtrPixLvHnJcTK2KtWLD4wXeeyA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8743F120010
X-Stat-Signature: fxaew77wjqyokbsp4rt5tzzsaxwccxpi
X-Rspamd-Server: rspam06
X-HE-Tag: 1774865289-128046
X-HE-Meta: U2FsdGVkX18scZAWbkVSbe8fMFwpda2gLjUkI2lgMxSsdO+wEV4c0e2bhYZAo1oJCDitXuusEnWY6cdCurHixJb3i8gUOCuo/Z49O8h9TuYyvHNSxjWymwUI8MTRdZ8nTHoKcdVfhJWhYrwGIR+U6WzHuUinNHbWHl6DDUch+6T4PahRQeY1qkNZ81OpBekiZ5J4s2wTcbFHDFYnSq+BV5pcYhD88oSrVKn912NHxtC80HUkkmbbbgzUJuybfDjInHYu1/nmMGcu/wLCjW0Arv24Rrz9XYtHxfVHBDVA8gu25Rk/iXVdEHN0x9LiKL7RtNOvfNG5PYriFSb+AmtvJEBCG7t04JHK4GLKPUTc6a30634MATZJNLMr0EQRz+sCVREfdIUVgbl4NZiZ/JO8nL8sN0A6lSuQkqLByAslWs6eODachBFltYCT0aQf0mRHz5M78MLAJKJSOusxo8mvZUYb0QR+HXbM6FYN1IVxGVzv+3Igmzzg9tmyNSFlUwUh0qC0znRCm+aiiciVfNgaGokNGaifKn7xIpyTBQccD2to7nNg4NALYjtnoXWNtCJ9ymDaspSYIkUQ0ZAH0XX5b1seT8H+79zF6zpx3oWDyJ7jw+gX7Q8I3XqJui0BLs/8w1XRp6SGOZNDfRXItlJQWnGnGkzOloJBaMeor91Pdok8UKO8R5J47SZJlDtbEu+FPqPI5Y+w9v3lRRO3OAgpdLOEWNzVUk1WV+8neO2JVCv+Ahq+P/cq2jTFGlV0SAi5OPwSmg6gqstkO/4Cop6NfB4AayoJgeCZ2VuV5hThhn49csWtmErtl915X1EhzikH7Z2Gc5/d3mwEigYTsw17hfN3C/7lKeuINzjRBGD70Fj6MecJf+MiUQ+Qj5hgaKv/XyBCwPMEVVHM9JG3asYHzoVlaEUrvpDAN00mn08IAh3OjT911uPkcuEe4jfXu6T3rVHHjRDI4q57gjBfsfQ
 HVTbNnCs
 /FV4hNyestpAeWvi8rqHgN5UI9LcY8G5wbZfxQ0xb6F8cbzHR2Y2rMhfi9J7Kb+/FcCjrid2bjS7ksIRQkfaOZlc5eO6Lz/LTvvXmwF+xDYj6wobHwKjjilS2GolWA4vbicUv98ZYTzVsj1UQ5AsLxXBxqjC9/6pI9e1q6HDJExAmmK2W57ZsSyTAq4HpgmXvtIa7I7zTg67grzKAkdYu28LCgRPwLBozKF+F6W98tfPOTF9a9JHbN1/GWYlmRQ9KIVdXJjGrMuuCiDf6hHU/UYvF4Y1/rajXbVma3C1mKq3bEcC6pmzfGs4IjQC2UpRTwRFlUN8noRpxUR/A4gJynWWXXVC/j93nnxXnq89z8Ds41mM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 12:05:08PM -0700, Suren Baghdasaryan wrote:
> On Fri, Mar 20, 2026 at 11:07 AM Lorenzo Stoakes (Oracle)
> <ljs@kernel.org> wrote:
> >
> > A recent bug I analysed managed to, through a bug in the userfaultfd
> > implementation, reach an invalid point in the zap_huge_pmd() code where
> > the PMD was none of:
> >
> > - A non-DAX, PFN or mixed map.
> > - The huge zero folio
> > - A present PMD entry
> > - A softleaf entry
> >
> > The code at this point calls folio_test_anon() on a known-NULL folio.
> > Having logic like this explicitly NULL dereference in the code is hard to
> > understand, and makes debugging potentially more difficult.
> >
> > Add an else branch to handle this case and WARN().
> >
> > No functional change intended.
> >
> > Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Overall LGTM, just a question below.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/huge_memory.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 3c9e2ebaacfa..0056ac27ec9a 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2385,6 +2385,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >
> >                 if (!thp_migration_supported())
> >                         WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> > +       } else {
> > +               WARN_ON_ONCE(true);
> > +               spin_unlock(ptl);
> > +               return true;
>
> Apologies if this was already discussed in earlier versions but why do
> we return "true" for this case which would be interpreted as
> "success"? Perhaps because we still managed to do
> tlb_remove_pmd_tlb_entry()?

If we return false it can result in a potential loop in the caller I
believe. Basically the caller won't handle this case properly. It was raised on
review, previously I was returning false :)

>
> >         }
> >
> >         if (folio_test_anon(folio)) {
> > --
> > 2.53.0
> >

Cheers, Lorenzo

