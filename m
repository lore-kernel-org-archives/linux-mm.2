Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C8CCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330DE6B00A1; Tue, 13 Oct 2026 09:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2236B00A2; Tue, 13 Oct 2026 09:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F86D6B00A3; Tue, 13 Oct 2026 09:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F07956B00A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:17:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 860931A0CD5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:17:54 +0000 (UTC)
X-FDA: 85317655668.27.7E2AB96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C8A540002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:17:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0JfCusr;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPrWbjd6nlCGQgcl4vkfUhJWd2/tw6kriYkWa0oA5aA=;
	b=rVFZQUpm2kOWLv0C2FF4m7ibmRhx6RsgzYcTf1c01EUQtUA4fP65uJxiv1x2WdpuQPQU4/
	l/4hKnDCZ0mGa7Tva9ERR5oYbTaraSKrtwh57za4TaqaS8WK1LhR6MH0fgGR0+5bX4zdlj
	8VvPsxBzSB0Y7tWC/Lctxdzue9OSbDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897472;
	b=n/hwvZs1JVH8LFiYr2NKA+DZvsyfVFL1NNcjWOgiQlAID522HiBlWWvrQXEm9VG4Pi/jLL
	sqLKybRh/Mcp3XERynjjEcGyYlgOJRZyEwZcuKAlfL8/TZOmMYPbYkFzQk2npX21UD+ThD
	9bBtWe2LkwHJv670G/mXBxZ6BeB2Grs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0JfCusr;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF9B643CE6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5E01F008A0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791897471;
	bh=IPrWbjd6nlCGQgcl4vkfUhJWd2/tw6kriYkWa0oA5aA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i0JfCusrums781dzuimaRkDiw69YSLDenNcPkMtStbdprggrX8A0gZmpFPim6Kx3r
	 nyWF5cYYX3aiwI2UJ5hpkmXW2KRzNQ+StdA7uf1L2Zh8GgxpMWjzZQHkWxcYajVV7g
	 9vuvFCLqItpCWOSFPxBXdw/fqbRRC5N/OGYBIeRJpAM//sSzhSc4CCiQywUwI36qNI
	 YRdTVuWG+BQHpWsu5r+yQqP54nZlVAzUR4wzfS4A7shpCmGLkiBfU78RNy8iNa1sci
	 giCVODBBZe371VXgAk+qdMIByl2x0sKuxXfwi7OJxsA8zl+cky6p4G+ajlioLl1846
	 ysGRiJEjz7cSw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93e5f819884so189370985a.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:17:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByO5zNc8zXQUqyNs50H93TwmQbDcLX0t9eWDzc+55ssEF+5vc4NtBDH9ctnh+nwL8mhhjHfJmNUTw==@kvack.org
X-Gm-Message-State: AFq9FYIZ6k1N04LheeASeQoIo6RZPUAVriczrr669IWveJ1fVW+EJt48
	iBdLGCDc7xA2/sE+K3y3eJZkCaxWJ6sJZkqgpyraUrUsZhmVp0g8xAybauOvMMI9DmB8XLv1A7Z
	uqztMRg3/24GoRK6IyydoUW1zT+tviXg=
X-Received: by 2002:a05:620a:6487:b0:93e:4c1b:a06d with SMTP id
 af79cd13be357-93ebd1bac2bmr2200083985a.20.1791897470973; Tue, 13 Oct 2026
 06:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org> <as4qKLx_XwQ6qY3p@thinkstation>
In-Reply-To: <as4qKLx_XwQ6qY3p@thinkstation>
From: Barry Song <baohua@kernel.org>
Date: Tue, 13 Oct 2026 21:17:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y5j+p0-VdEzpnS-Q31vhvBZRa96VJtA6+HyNj=+r+Ufg@mail.gmail.com>
X-Gm-Features: AclHuK9MQ_S043rSI_HtPCWrZsAEX4W_aIKduLBdZpTWuX0GQiW4Y22oKWiSD_0
Message-ID: <CAGsJ_4y5j+p0-VdEzpnS-Q31vhvBZRa96VJtA6+HyNj=+r+Ufg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ying Huang <huang.ying.caritas@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C8A540002
X-Stat-Signature: 6ia9cfc16cnb9uoxy5fyst76urdykbm8
X-HE-Tag: 1791897472-660736
X-HE-Meta: U2FsdGVkX1+Y/Wmyf7kAVRcSh0RlQUYacrJ3pjSHcWq1L3xi1UG53sIthnJqqw2GKJ9/Osw/p+IYajGPoDxNHmdeuaRo2MKnmN51lvOfcfIKqhLeYOQRi6lxuesT0tJ0ayNUraoXnXJpe9txDQJsoVVbQZo5FQQezjdd3NA4gVFgKD2yzQfHsP2IM0joI59/MkcwOulYENBI+I+u8+bJcS6hHylYCNbfUsjm+VDLBLsq30zzbFRY8g/ITYyWZ9vFYaSje470F6P6Ha4jXK11A4tkZl1DZLyWrrTCe1d5LfMPW3JbQRFozYcxdc369wWfTVHIMVcfZ4Vg0K+ED563KNaOJGeg4FrMmyepQCVCS6uyQgKwEzyp9eVYAoEAC1se+tX9Cj7bdLLTkkHdCrP7l8V1NOco/qcsRanIsXd/VQa3ynj/lp1hGAtvUTj8mJrZaJLXTPqqsbp4WBY+wePFlu+RGhb5HKRS1GXkUnouJHvD/wda6aDmSzb97ZKvGQMJyeDV8dpG67+8UWCkDZ0ASMUekg/VX6obMzhcniriMX8SDaVuQEu/F8DCmeiwAEsZcjIFOLs05wjgFiUs6lI9C3M35dBsWzh/L6BfQ2GstLxO7qNEqWN7/fGV+F6aUNTypKtgOOc80i/wWQTqi0AoJpVIW/f7y89X28FL+xueyzFoZZRCk47+zY8hFgBqjjyLcGTX74U1Pdb2eXzVZIqIJ/1fdUWPTuvzASFtZEmfvqs82ntUaNQ7D4MB4tKgJVGJXGnP6A32BEAn9yhBxsPrljPG7ohn9dnO2rpo0z4ScsjTwf+bsdoPIwE95Xz8+BUeJn0vnDaj/WrLZHiv2EKqr329wtT0flnufZ2nsEsDG57zky0qXGwLEAPu7AogS6Mcpr0jtvl6QxWD1rc0NxI0ZwbmKdGbHdzBLmWjsOyxiRhPXlmnvKXFnIUuLttqV9dmHALgZVpC8YGD13OK4ZL
 RI23eHY2
 Kcmk7WhvveQRD6XT0BQ0Z6H92O2GvRLy6O0VxS4EBP4p39pg5M65eUKTwqo99o/+W6CsLzltGnStjyBdqtTeiSZtd56LQQJpstFbf9OfA5DhzL5b0Rs+hCqe1rFf+xWataZu5tFcRqAvE2yGm4aiEEEaOuH6l4pE9Hdx09ENPfqeO+lOJlKSCA5s6cJJ7pcZaOGShP5YeJen5VuL1hoMo2klHBh5N9FRCQO0Rp6k6grO5AJ9iQzEB5wAfnRXtAFaxKYs20giTDdVq1iFRMF2gvJzoj+oVAbr277/opWZDThNQrEP9Xav6oN1Xxn7YlIM0HVoRpaztnWcouJLrUiFhROsVU4pFzwKB9Cs3C4ZvUZozqeIh8jbe18H0hfNX49FoPBOmO8cmft56FB5AJe9vFbU8+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 8:57=E2=80=AFPM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> On Tue, Oct 13, 2026 at 02:30:37PM +0200, David Hildenbrand (Arm) wrote:
> > numa_rebuild_large_mapping() and do_swap_page() can be tricked into
> > generating an address wraparound, crashing the kernel. All that's requi=
red
> > is to map a tail page of a large folio close enough to the start/end of
> > the address space to e.g., make
> >
> >       unsigned long addr_start =3D addr - (nr << PAGE_SHIFT);
> >
> > to wrap around.
> >
> > Let's fix it by providing a better helper, folio_pte_scan_range(), that
> > takes care of staying within VMA and page table boundaries while
> > handling possible wraparounds.
> >
> > Reported-by: Kyle Zeng <kylebot@openai.com>
> > Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
> > Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swap=
cache")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
> >  1 file changed, 29 insertions(+), 14 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 1f5d5f7d39cd2..a3823010aa981 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *f=
olio, swp_entry_t entry,
> >       } while (--nr_pages);
> >  }
> >
> > +/*
> > + * Get the address range in which a folio might be mapped, assuming it=
s pages
> > + * are mapped consecutively and the folio page at the given idx is map=
ped at
> > + * the given address.
> > + */
> > +static void folio_pte_scan_range(const struct folio *folio,
> > +             const struct vm_area_struct *vma, unsigned long addr,
> > +             unsigned long idx, unsigned long *start, unsigned long *e=
nd)
> > +{
> > +     /* Stay within the page table and VMA boundaries. */
> > +     const unsigned long pmd_start =3D addr & PMD_MASK;
> > +     const unsigned long pmd_end =3D pmd_start + PMD_SIZE;
> > +     const unsigned long lower =3D max(pmd_start, vma->vm_start);
> > +     const unsigned long upper =3D min(pmd_end - 1, vma->vm_end - 1) +=
 1;
>
> These -1/+1 gave me a pause. I guess it is for pmd_end wrapping to 0 in
> the top PMD? A comment would be nice.

Will pmd_addr_end() make it better? I mean

upper =3D pmd_addr_end(address, vma->vm_end);

nop?

Thanks
Barry

