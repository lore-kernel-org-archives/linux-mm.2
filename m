Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D472FCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEF16B00A8; Mon, 11 May 2026 18:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A00E6B00A9; Mon, 11 May 2026 18:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6666B00AA; Mon, 11 May 2026 18:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23DF6B00A8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:20:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E47C140262
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:20:56 +0000 (UTC)
X-FDA: 84756560112.22.731FC23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F3D8100004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:20:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gJyM/w9C";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778538054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oiwpgl+VCz9Paf0wOi3IzQ/CHbQ5AsjS3aRR3ZpnoTM=;
	b=SqFFPAityvBjR3HurVwQaVL28OF0HFrsztTjonT+Yu3zEEOr0U+lKvhw0YMsADcfgl6bIx
	RHPNey4+oGrioCR/gUqFz6oo+7Mxx7VpIrVZfj87cENMrs5Blm0zb+SvG4IAELvzATdzLP
	ABdfQxl1jifXNgGlOS+A0T29tKUEoyw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gJyM/w9C";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778538054; a=rsa-sha256;
	cv=none;
	b=oe0NdkSv1rDzQV8KJNX2B/PXhDC4fGtVlR3fXDxLsE+pC9i3YNPUdE7nx+6m+l3qqEQmln
	YoNsNZlLfHi+3DqCy2gkbypGatvBi8tTqt9B5H4nKfNRLIEV2LBVgMh7anT694UYStAgl2
	8j0NDbkWFAf/Imkki702/9Nuz1SmX/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DDB3600CB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62F0C2BCB0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538053;
	bh=mtBhNss9EfolcqMiT2F2MTnOHZvBn/vb+FfL4z91DYw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gJyM/w9CH0fPuDAE/EHSvsftkHP3fqNr6BM7x/31B5qhK1So9L5Eqq/1mqol6Jzyd
	 LOcoeSk553p1sOsMv7tZx8kEqBNlqEgdieonefE1vP9c2P6hM62EC2nlH4F774Vsm0
	 qkamcwFwEXCjxJlDfSi7ZE0jvVn4YTTM+Zdk1lwtgSeVTfg9ro2068fKkbhmJuHgdk
	 7tnXrPDAvg3tR1JV+zCePSiTkE+NayrZ5NeJ6Pfb7m0sj5ZLhllzm9rUWiyeEvWZh7
	 L7TUqGbYXhloWn3qsEcj1HmZvqWV5YZp6bdftaSIHVVqPCho71MUg3GCX20oARUO7u
	 z+CXkWWtcVUyw==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8b4298d271fso82821396d6.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 15:20:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ91F3unSHFHJAZdf2px1tzknXrmI5zxqevOBgFLNBvvw61bM0DCWQiFihNP9QwHfXEfo3OvLyLxmg==@kvack.org
X-Gm-Message-State: AOJu0Yxla8524TKkll9ceOrDEealCO6AUKlqqHji7ummua6R9cOblw4/
	NH9JgZEq4sHX/XwMTLZCY2681lbe43qvJtYafCetMaYQ42OHhJb43hbyNcusHQm3gPD+1pZrVNe
	CUJzI/ucJoT3dTVfPoo8bDVTGTpd7bXc=
X-Received: by 2002:a05:6214:5e03:b0:8c6:1ee2:217e with SMTP id
 6a1803df08f44-8c6616d0bf9mr9406266d6.18.1778538053141; Mon, 11 May 2026
 15:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260506094504.2588857-1-dev.jain@arm.com> <20260506094504.2588857-3-dev.jain@arm.com>
 <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
In-Reply-To: <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 12 May 2026 06:20:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wJ3pr0+s3+a5fd3vBpqbu0zDOE4RN2Lf1DkUcupHXw0Q@mail.gmail.com>
X-Gm-Features: AVHnY4LvXEZBeVHYqfIBx4IWLykQnjY2hO9yVlzCGr3vB4Cx5sRlcT2l7VxnrCY
Message-ID: <CAGsJ_4wJ3pr0+s3+a5fd3vBpqbu0zDOE4RN2Lf1DkUcupHXw0Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F3D8100004
X-Stat-Signature: hwjapfh45kiwpkz54smzb8d54qxxbnnb
X-HE-Tag: 1778538054-869435
X-HE-Meta: U2FsdGVkX1/rRmqEPc8e+k0ScztrhKf+Mnhu+pv2Cf24rnmshwl2YZX8W5PJgDtbhXz74ZJzu/LB0WC35doc9d6aEfQyHnztZYMC3uKVOiwOPh9Qp9s63Pm3X+bguga6OD69SDdZAPPygaKv7m9Vwta8JyqGAi5agUeJ0tSy/2rywzQkncOWtgr6vKt77rHW9sISPcxvWGNgqgPx5ktrTkzs515BO4ePO4xDUleIKBwBDdmrJeqFZ/DnKi4fQ922HqbGH4wZ/ncoIg8XAj/L1xiS+8EOjdMN7UAgXBkOAHoPBDlrnQLVcjsLjEXWifjVriASp1Oc6cPO64+Kp+XVwm/ldxFrk3XpxiypVPdgA8KjT5z8mq83+uKE99g48QVE6Ixe64ge2LLQ4n/US3E8W5+gMi0Rn38MNxVvD3iaDxzDpp2wH2tx65sIKwD+3vFakw2aSEvKjdwPV7WckaFrCf6fIdenl0JYxR0k4eEy23bz09PW6yyzpN5Ns+yrrgyxaP6Uz2bU75/PXmpRLReeNw43dKZ1krKzGWLpOe7sdAJjoWWCvKX0hIqlaaa8pvOhYPUNhcvP9TMq/Cn7rGD/wcPszQg/Go+/US9NR5TLx5Zp0rXHJVzDWd00QcCthEltbBHxGG3+skXOBEQjicWvLafy1962OXpL3/zhafyqJjckGf/l9RsbocQH3dKDRrqcRZTipNd2OXkO5G33NuUi3zQsyWnWBQm5wziA5zEsFkg1RwFKSuEbGfhedKLC+8V/ZMIjffQgZTgaBay+4IUqB+JO0h+wnrNkHlv98FLGU0rbftp460EwBoIpXByL677oYk0q7cRpXk9gaW4ni1NbJ+3wKLN59eClwyboMpG9h+8aXIrqN6vvIkISai1LcYi3lglrRNH/O9DlIiILDRxihB4ZezOAuXa3NQLqbp9tE5utKYciOHwWmFNTv8h5zceTu4KYvX9Cy/k4PlkQ2X3
 za+UO0Z+
 SQaS8mNS+EZBFDn0VLsAJBUlJNsUKmCp3UOkPjd4JfxL0uqReRgugeyBI3M9OQmppU99YamzhzdjRx6MUVqs/JRpU4BNvKJDNkRpW8Ak7hgdH0oQoYtgiOdfCuTgKRXCmphmuPb17XVEcV/3OkeGWTwNl4Qjfi2EZap4V3nRoi8cKit23/DPkdLWDzkKppp3bAZWaWUun2mS3OvKGAFxFhGq9Zr/VJsq8zyzDWqD00cQWycY8F/X9jdAQyWZxFINOYvZc2o0KPm1ul/e4AsyqxLp6WGh8m+KFfCjI8oW7Io9IB6t9iqOPaY067KBM5JcZxd3zDypolV91A3FCa+4hF+9VTjLLZUamOFu4J+Q78TFPed+NhsIZFiUHBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:10=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
[...]
> > +     *pteval =3D huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
> > +     if (pte_dirty(*pteval))
> > +             folio_mark_dirty(folio);
> > +
> > +     *exit_walk =3D false;
> > +     return true;
>
>
> Can we instead introduce some enum that tells the caller how to proceed?
>
> I assume we have
>
> (a) Abort walk (ret =3D false + page_vma_mapped_walk_done())
>
> (b) Walk done (ret =3D true + page_vma_mapped_walk_done())
>
> (c) Continue walk (call page_vma_mapped_walk())
>
> enum ttu_walk_result {
>         TTU_WALK_CONTINUE,
>         TTU_WALK_ABORT,
>         TTU_WALK_DONE
> }
>
[...]
>
> In the old walk_abort case you wouldn't set ret =3D false?
>
> When returning the enum you could simply do something like
>
> switch (ret) {
> case TTU_WALK_ABORT:
>         goto walk_abort;
> case TTU_WALK_DONE:
>         goto walk_done;
> default:
>         break;
> }
>

I believe I suggested the exact same approach in v2[1], but Dev didn=E2=80=
=99t agree :-)

[1] https://lore.kernel.org/linux-mm/CAGsJ_4zK1W71iSP14gi=3D8yWSg80EjgYiBXq=
LChB2i+X+RSTWcw@mail.gmail.com/

