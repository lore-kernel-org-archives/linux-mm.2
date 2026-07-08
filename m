Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C64F4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08CD6B009D; Wed,  8 Jul 2026 05:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9476B00A0; Wed,  8 Jul 2026 05:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8476B00A1; Wed,  8 Jul 2026 05:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0556B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:16:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7DA11A06E7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:16:11 +0000 (UTC)
X-FDA: 84965052942.17.BAA10A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E58220008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:16:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGjEPZee;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783502169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4K/HdwkKVaSF1+rIVNyQiESO9vsDqggAz/6RtbS1nI=;
	b=ZxJ3wfMq8g5jSsvOwt95uBFCV3bPj8dTeiD8ajI7JYAXvYC+P4f0VnuBiev6JVp8CBePJ8
	Sj2eqcoHo/MjkwWJqJwvHjBhK+dkPsGqrrWtdTwEIZgBHYHE3znM31IeGr7G317UVTecGS
	vRgn41Xio8RrigWuBzA3JdmJdYYpV08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783502169;
	b=BEjckh+BoafcK5qksxPRcVJn4/kpxbnj8frTz/qDrJwFXr8SnvDVPCgZk1fUnk62eUdTbR
	sL/CF1Ur65L/4CClm0zSSBGxdzmnA/8yk2CcSbzqUHs1OIhYOUs4yNHY4U4h7ziyDFQ2kT
	7sQRN5xoFLIPHMdl+tOPGp+2uIW1N3U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGjEPZee;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783502168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4K/HdwkKVaSF1+rIVNyQiESO9vsDqggAz/6RtbS1nI=;
	b=LGjEPZeemMuviSF8/bhZlfMQTgmkFE+YUdZqkODW5rQPn7C84+mM+ybu9UAzNSmVdnMRv9
	XpuK55P/d2vf4Ku14X/yVVtM10YwR/GVrqogheNr2YMNq4EepfAfu99AbrLaI3VI6J5Cfv
	O6oT1mSLsB6LyChaqjF0HflLVFJY+2E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-RD_EajTGP1SqWQ4n66rkrA-1; Wed, 08 Jul 2026 05:16:07 -0400
X-MC-Unique: RD_EajTGP1SqWQ4n66rkrA-1
X-Mimecast-MFC-AGG-ID: RD_EajTGP1SqWQ4n66rkrA_1783502166
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69841da1946so603832a12.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 02:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783502166; x=1784106966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b4K/HdwkKVaSF1+rIVNyQiESO9vsDqggAz/6RtbS1nI=;
        b=lHra9/XhlwU5WK6nPlb68p2eYyzwYdtZXQtnQlvNAalN/CgcRKGSPa/T/vD/E3JCmS
         aeZx0uKYyypXfn/ivfXOHN07ZqlNVmUE9Cpl8nODq5oowF+oH2zabpD5NvuujaHpQ7LA
         v5X8Ys0cd1Pb2Yv94fUMMELK31ByM9Equ/+nOPxfdBnc+YsyvAx8f3PuphP312SkQvcd
         3ZFp6BUVpgzfhRMv9VqTtN+za7cH5xeYD+61AvAGwUFhsAGHTjkLIe3WzRVnvYIkbe3V
         yRMQ9PqKjyWocH5GMUC6Q0pZQSeTdAZNuII/GBfE7THQyY5b3XgFBa8H5BXbXLvzjsjL
         E3PQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5uJmAEy/Kn2Jl4qBfXV9ij0L+Y4e2f5evkyuJ3jUV9o4tCgc/mjnr7KNJrzyIlvbAQXRbaXMdIA==@kvack.org
X-Gm-Message-State: AOJu0YzsiVwUjCJBu0JsTh6F4OnLYCFClJqmJlMs6R8nvSPE6eI+mAdG
	BU9Sh0W+uriYM/JoesDhXpcN+hDcUyicJvcsPmeXwY7d3dk6K5ZnBXoZjY2QJe/r85pAa8BqgrO
	UNT7Bg+ulPTp/QVqHntO5zDPAdg6k5jJ+hL4D9/TZ7ZGROkpiA14Q
X-Gm-Gg: AfdE7clztGV5VnUw2y8gjK0RLbdH+MGNzy9+5Iz9w+SxHMB+//xoGSGaLDltjeMb/uE
	7xy1RYE4JcBuhjvuPN/HaEzDdD+OdxEQ2ew9bz90fLAe6XR93VXXIfCWxFlBdz89zQioV8qSYXO
	9v8MCEFrsxKqrXv1YL+u6kjJvtJgyrX+jBJlne5LG5ECF2AhTAT6VGp58ahE2QG7oThpgai3CuS
	vdZwGd82V1UsK/U4/JJ0NUxoq9+6Mz+LhWjhD5MhFTd38wg/vaperuUyTmmGnvCpPymLB2WArqS
	6It/hNjO/HWGh4/rywxgxlv+B9gtHJsEssoEjafiEu96/HPp7iK8CDqxr2X5xDd5Y68OTnStzcP
	alDEG+aVsM3WA8/AyqdRuZy/1zdrzoX+/
X-Received: by 2002:a17:907:1003:b0:c15:9709:fb9b with SMTP id a640c23a62f3a-c15ce0f880emr64100466b.44.1783502166143;
        Wed, 08 Jul 2026 02:16:06 -0700 (PDT)
X-Received: by 2002:a17:907:1003:b0:c15:9709:fb9b with SMTP id a640c23a62f3a-c15ce0f880emr64098866b.44.1783502165600;
        Wed, 08 Jul 2026 02:16:05 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ad9bca25sm286808266b.35.2026.07.08.02.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 02:16:04 -0700 (PDT)
Date: Wed, 8 Jul 2026 05:16:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <20260708050547-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
 <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org>
 <ak0xWgpJPSaNWPsl@lucifer>
 <20260707152755-mutt-send-email-mst@kernel.org>
 <f9bad4b3-93ee-4daf-84d5-97f6ca305240@kernel.org>
 <ak4JiBcvi29sYx0v@lucifer>
MIME-Version: 1.0
In-Reply-To: <ak4JiBcvi29sYx0v@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0kjqyo7zHvqI9aDN-8qZ2md8Ltr37kZccuhicXM2aBQ_1783502166
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E58220008
X-Stat-Signature: ogkzbkgwndrfkya1qojd65jz9ts5mupz
X-HE-Tag: 1783502169-238245
X-HE-Meta: U2FsdGVkX1+K3tbH7hSXxg1hIu5P1ZUujm4+29EwuhpjLfkFcDWitcgEua77+t0OAp9EzZ5Q5BZPmwkH7BGysgS8TsicBD7ueuErC7u9uyzBtrpk1PflwGYpARxaA1KWQ7Ksa1FOAJSx2NJK7nBVARrgQBZNKtThvRHcGLUnl1w570jdfK8QLXLsqdQvJ5q0w/CZ6OSMW22uLI9o+GLzFdGc3MY1JhkYRbJTzW5D8iCMZNyqFbn75HKqwlQ358W+psfAKK5681iyyFb5KefhtxEdP5kpoXup9jWOHcStXM2OKFKu4/Nv29e0zmiaQBDphCpqxLFfBd76MuprBpEOFBONoAD/xyyFXlVLe5kyaHc8ClH/kycMXs6/S2qwUqiGG3Zc0Irm9YmhHp/SOqXyi/vRLADE/OPnKXv9Z4QWGT1ETf4sbrVn6H5Q9D90XLFIHqiEQVjAcJv02SFBBPVl6gqsCp78NhaSuuEJBVXrVdLHG3h4FZ/NTfzVv8dWxosNnqwY6bR3ZKHF6v1sIKOGqusCk4t8cCQsB52MT9bRshcWlxKdjw9hguN8KgqmVKFMkmOMDG8QmIbwSp18PWiWaIAPqv5GrK6azGN/zEWN+HoG/CDn+vPahAVnmuPXtaTzhk+h9fT0gDIEedGRI+L3qvy/4v89PQCmsuO44q9vi5ECUB6c/mTzSJZZg5X33Owc6hdzkK4kISvc3KR99zAcl7vsOnd0THCCsC0kPzBYNnlzrl6YdPJvJV5pivwAD4YB1un3Rlxf7LtHc5aUClwKCZSvkrEIc2+Zr9ekCUisryvJWqWRYF+z5NM+iPcxR9WNHsVKE7csHe4X3wVCBwStwpH3EnL2TaI3cN+S/dOiD/FFw684wcqpsix6vkwZ7I+rVX1dMAMFyRMhvdVycojH9SSLADOuWSn9aT4F+mf/rtG5JDUsKzlRXB9bLctiHO5E/09KXhyWhokrDPaTM9T
 cUyqDYKu
 ujWrhbIXWGoR1VCXVnxc/KmpE5h34oo07fXyeeTlGIfdaNWHCcGk2Kzd0ev+aVkrr6saazrOGTUHshuRs3TR6GI2WGYZUJjVKwjkjIN2+S5tDOAf5k/L6W048vfBfiuFSsIyZls2Mp+msqICDuhweQt9adMkz1wXgwjSY7U5lM3g0AkWJnctMWuOPmhk9RVXP7XXTOV9IcpZO5+0qGapD3fCcNqlLzZ15KW7yduI0CkdAnwAf8mv46qaKJz92GgdrsfXtPB73OoMy8iDw/xPAoccqiidRoqiyXLUgO6EjViwrSBRESWCYAS7cIfI2x64u4uV45hjAkjAO6QPn1aWZeVmNaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 09:26:18AM +0100, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 09:46:14PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/7/26 21:32, Michael S. Tsirkin wrote:
> > > On Tue, Jul 07, 2026 at 07:46:28PM +0100, Lorenzo Stoakes wrote:
> > >> On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote:
> > >>>
> > >>> Fair enough.
> > >>>
> > >>>
> > >>> Lorenzo, do you know *how* you want it reworked? Could you write it up
> > >>> at a high level?
> > >>> Because if not, it's not really practical to make it the asking price.
> > >>
> > >> Michael, you're an experienced maintainer, I'm surprised I have to tell you that
> > >> the burden for that lands on the submitter.
> > >
> > > Oh sure, "fix bugs A,B,C before you add to this mess" is a classic way
> > > to actually not end up with even more of a mess.  But I usually do try
> > > to be explicit of what are specific issues I want submitter to address.
> > > I don't really feel figuring that out lands on the submitter.
> >
> > Sometimes it's certainly easier. With things like hugetlb there often just isn't
> > a feasible way to integrate it nicely into core-mm. It's just too special.
> 
> Yeah exactly :) once you reach a certain level of 'specialness' it is more like
> pointing at a flaming trash pile and crying ;)
> 
> >
> > --
> > Cheers,
> >
> > David
> 
> Cheers, Lorenzo

Well as long as I'm not the one being asked to put it out ... it is just
hard for me to get motivated to do cleanups if there's no actual bug to
fix, or a feature to develop somewhat proportional in size to the
cleanup.  But for example, and without calling anything trash, after poking
at memory-failure.c, *I* want to cry, because either there's multiple
races, or I just don't understand the code.  Some of these we discussed
here already.

It seems to boil down to the fact that when people start getting lots of
these errors they rush out and buy a new system, so hey. But maybe with
RAM prices spiking it will become less practical. I'll put together an
email with a list later, maybe.

-- 
MST


