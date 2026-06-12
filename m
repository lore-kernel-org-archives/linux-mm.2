Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BE2CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B87A6B0005; Fri, 12 Jun 2026 06:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868DE6B0088; Fri, 12 Jun 2026 06:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77ED76B008C; Fri, 12 Jun 2026 06:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64B1B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:37:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D08BC1AC7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:37:05 +0000 (UTC)
X-FDA: 84870908010.28.3C8EAA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68453160002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:37:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PA4IkpSs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781260623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3f46ToGEV0rWd/D1F2Ouo2ymqlnTMfvv1MJeYenFUX0=;
	b=n0p0TGRJGxPPHfmixq2BlwbDkux+d6ig1sHj9pLpzozMuVb7WWVKsqH1uXJGhceu9838Kj
	h2wpQxKkw8XIUW+gJiKVRJuU+xWxCO/ifddVWBU3/g3feroIGAAePpOvn1SMvnwiyTrYEg
	iu0ofQlQlCr0w1rPqiFSxj7Nhf24T3U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PA4IkpSs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781260623;
	b=TVYBs5IQW1OFHV9NTUY4C40+T/+nGRkKbtMykEhvlD4yGmk/hrzTa6CowQeVuGNRWzcqsc
	3HRBzWQT5SZQNpGLx0Vjigg009R21sGOES+5e8oNsEFy+EN8KX4b4rF/2FcamRRUnUQmvE
	aR3RSB8SEpVBx/ABN1bhYJ1gchCVnpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 674C044357;
	Fri, 12 Jun 2026 10:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32DB1F000E9;
	Fri, 12 Jun 2026 10:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260622;
	bh=3f46ToGEV0rWd/D1F2Ouo2ymqlnTMfvv1MJeYenFUX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PA4IkpSsU7xTumiuZKJOGlx0o0zzR1myfODYEV7YPikgOgSdwOhKX+frfvzGSBjAZ
	 oDndS8zEvEl8kexzDReLLnIUHi4nQTxC/Et948M3vasLcp619cDMY47mq3co9fUrqT
	 lnMG0pTS9cdiaqYpJ91rVkxXzy9bdN4ue6SHtFaO7ldgNlFvZ8rNb2FQOjpkE6muU+
	 chKQFOyiLncoDwKLTprQ+ygBzXefozD4NQ0AdB7DVV9E47OBnF1WiLNJW7TT+eW+YV
	 1WFEdBOC6ZzGnkDjPf76u52FmLDRtl2dmhR/A1MxxxtBU5pcmDX1JQBPWPiPDJ0i69
	 fBL6BlQ2lrMLA==
Date: Fri, 12 Jun 2026 12:36:55 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: cleanup clear_not_present_full_ptes() and rename
 to clear_non_present_ptes()
Message-ID: <aivhRywnNOOCjhTD@localhost.localdomain>
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-3-49865fc82629@kernel.org>
 <aiq_3rp9fwFHyLwl@localhost.localdomain>
 <e9412b6c-ed3c-4c0c-977f-fc019297d875@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9412b6c-ed3c-4c0c-977f-fc019297d875@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68453160002
X-Stat-Signature: exxipx158atr6fcg49qujexrfty41yfs
X-HE-Tag: 1781260623-242578
X-HE-Meta: U2FsdGVkX19z0ukEJi71A84zJ9EGugyNQOv9daH2KXz3/3UREvtu6GJbLtLMAiVqDygUH+O8eYQwZ2+nOBre9uMrwU0RefoBx0rj5J8kVTmV23QqddAmyllUIqHNGpsR8rZkMq0ZILVFXW0MckflMv8AI5/fMMzcuz7zTGAD/04RF1Cub57TNSOsmePm3piNXe8i69WyYlXr7eG3JDIcGOdVylCpmRxqIbaLeZwWVr0TPViZn/Q5EhSJY98XeKW0S5Zc0Ue2ERRU+TyBNW4GmeRvaKcLWC5rnDlN3HB9tPaXxBYLUT7xa5Mhua0kGp1x9Duz6mntCwdjJffzSZOxB9giiGY8jYNXuffNT3XEdmix8PuRWiNcnWUobAmWIzNmOF1wkAYtDdeAM41P8TFByCZ+X+GVuynFnyelU0LprDpJmwqkox7cLmxqynp5dqkvE4p3GV/EMDCKDMmyoPlunSnaaXIbghtHYAETBzAuhjbBfrFrsBrgdE0pesXe6iAPr0IuaPwJfmsFFPhtqUKgWx3nket9auSJovwqmaMWr3pnO6EtnISZ/y3ojlpLZJmmL40Gp80otNI/5r5blp3czh8OhThdigc+Zew685IndfFzgUSEnoDYgevChx8rVCZhSV/dnIv3qWPG5hCV+Ko1iC2VHCGNtSVXNRKRsEaQBNqCo5McsnlhhGUvvPM3TNOApnjtev3+WTk4NVc5DD14xvnW9JeCYatoaRhIBkFFQq/0OB7zpBtwxqnxma0OqgG2oXCniNw2+fbJSWYqo8isX7A+b8X278sUJ+I89hhk/YUzbSS6GxW275tfBpDaUi/38LulfvAmxRDl4Zyyg6ls9qC8o56eHkhZc9I31GlTXZLs/1UMSJruiTdleXzhnRruPEwybQ2M5B/DSBnmNdBi87h3gDkvTofPeVrWuoIa85c2tae0vs1usoEcE+Zvb9gTcByeilhoUAYMGMGsXlK
 I0olCcui
 bisr4zykLlL3HqjNU8S9ZAGrkoIu40p2hmS2cJyCL9KORNwreTC3o5aPqCT3Ny4SW0GEPF4ynumohWsE+IU9HN55Y7aSei4rKPRwv5NdtiOOBt4Jz0VSNL87SqMVG+GoMW3EOCZWD/H/8z1nPrnTYN6fICPkKgZnJeaWwCsFbJUv0n7dDz6mF6Y2/1pGYpEVT0cypSbfqF9sQ3OPOTPSi+ixsM+POhCZREiwtZU6smhgz9Ra5AR+W7nPmIOBMRx/D3zqzTUnuimkIzzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:14:34PM +0200, David Hildenbrand (Arm) wrote:
> Usually, you want to get access and dirty bits, and that requires get_and_clear
> semantics. I suspect there are some more details to the low-level helpers.
> 
> > 
> > I guess that such a renaming would have to first audit that all current
> > users obey that? Othen than that, is there anything else stopping us
> > from doing so?
> 
> When I last skimmed over some users, they were all dealing with non-present
> entries. (mremap.c, rmap.c, mpreotect.c, memory.c, madvise.c)
> 
> But yes, we would have to audit and make sure that's the case.

So, I quickly checked some users.

As you mentioned, users from rmap.c, mremap.c, memory.c and madvise.c
deal with non-present ptes.
Hugetlb via huge_pte_clear does it for uffd markers or explicit !pte_present, so
that is fine as well.
That is wrt. generic code.

Now, moving to arch-specific code, things look a bit funny.

E.g: bpf:

arena_free_pages()-> apply_range_clear_cb()

apply_range_clear_cb() only calls pte_clear for present ptes.

Then, e.g: remove_pagetable() from powerpc and and x86 end up calling pte_clear
(for present ptes), but that is fine because we are just nuking it.
And s390 has the same in modify_pte_table()



-- 
Oscar Salvador
SUSE Labs

