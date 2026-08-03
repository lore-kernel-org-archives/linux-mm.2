Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321FCC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2936B0098; Mon,  3 Aug 2026 15:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CA96B0099; Mon,  3 Aug 2026 15:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AA56B009B; Mon,  3 Aug 2026 15:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97EF36B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:14:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13A54140539
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:14:44 +0000 (UTC)
X-FDA: 85060910088.29.8FE5E8F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id A3F8320007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:14:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aWksjmbZ;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785784481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXxSiWzPd5q4+tE4Go+M+sEFvuFdyjKmZYx3+a0dZSY=;
	b=hd2P4vba92EMRCgy0InZPXTn/d7KwbYuslgwZvBD4ef1PTbhDpdRVf6DBV7KATNaRAcQvq
	Xg5zKAVNi4S8yHbgnuUF5JGdzMtEaQ0O8hcIv/F2qPLotwfJN3hN+himDY0Ai7yyGMf4A3
	i8wBw2sXVyy9s2GaB8kuHfKHuYvQJq4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785784481;
	b=LYm3dQDaqchKTLLj/8IDoGqIbdo/Vj5TWtbxpSBmW1pMgzaeIV+PjtNbHP329OaDaGfDM6
	ppQ8a42NM3ZGjo7kXeYgkn1U2xc8BVxmUYARtlPoou01kwZUn+cr/0F/jyC3EI4hi8VBKL
	V5ozCzEnKBxv0AzZSDpk5+r7EECnJKk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aWksjmbZ;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785784481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXxSiWzPd5q4+tE4Go+M+sEFvuFdyjKmZYx3+a0dZSY=;
	b=aWksjmbZRWEZQN4WuoXbIE0fupc0wO1kv5BOsgU9wmpE50/4GblbTCQMV7rZmDT3wcfrhO
	HFHvpi65HoqlAXr0iAYv84ebbrDFG7xYRfI7KLPFI9TEv1WO30id0bRhj12gjUFTJQP6nU
	tDwhiqTPw2m6aQRi12W++beaky4blM8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-bLZr7EKSOoeil6p9NkCyEw-1; Mon, 03 Aug 2026 15:14:39 -0400
X-MC-Unique: bLZr7EKSOoeil6p9NkCyEw-1
X-Mimecast-MFC-AGG-ID: bLZr7EKSOoeil6p9NkCyEw_1785784478
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39f65da4a4aso13083231fa.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785784478; x=1786389278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DXxSiWzPd5q4+tE4Go+M+sEFvuFdyjKmZYx3+a0dZSY=;
        b=WCvKL+B5sTq1X+6LOjC0FL8oxMsWCJBIf5nNXqp18taf1noePxBkdBTBzqBdU3fjLk
         mlSdrJMlPKqgnYYDRKSB69jI52xKVJOCf1pp36Gm6aFMbsNaDXvBkCRFQ0geLq9UWAqm
         y4sGjmSpz4IwHJ8oKB4Jx3wVmY2fsq/2f5Nw43/u1HX9JWs0Codxb0LtAYc8ryQ19MMk
         61te7qhmlSXcfcp0HEdFT9YKK/W1WmlRYOmpD1JXWswGJp8LTKR/NHuhTcsWHc4TZEte
         V5UR6SBcoZiEZlMabccKYdvzOknsMsGTOGC2PgMsChH2fuv5yEk/yxkopIJtvy/omr/j
         T9ZQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro38uvqeLP+tWNL/XjMXALRvNtLhGf29VJFh7KQkh6+92GZ+FmG9fMMzyGHJupqDNc+f9sJrcEXxw==@kvack.org
X-Gm-Message-State: AOJu0Yw95KYROhfe32p6mUTX6nnhX6MiYkdmgEobEWk7T7IBVNbQp7Rd
	cZ/qJjuZEOC5eHDdmku22lqK0YIWwMMaOTvAgW/Yp9ylQ5bQT2+yJ9dwjBeDiXt6FcoTCONN2mk
	L92mTpnPIUqUzNGNj9Mwu2Wb/gIsuefdv7cCwe7q8uDpu+mqJQ4TbinTINayEA7z3dAAlD/8N1k
	7LJFwDS2LP9meknVhqAxEmj7lKpXo=
X-Gm-Gg: AR+sD1204P6dLS4vjifsOem25ZhGJ8KnaW4EuW810yf3YamVbqxgUXFIBpYmz3Yq29d
	jd0oQ8DCaRr9lqM1MpC2XTmzWcVI32m/H3KfGbz2ze+XnBg31lDW9CSg6V9/J9r2iIrY/WuB/+d
	6BNaGI8MOcBcxn9Ty9zVUu2/tQLZXCsNlWjek+HiML99EViGymyBqj6BJItw==
X-Received: by 2002:a05:651c:a34b:b0:39d:9dec:2494 with SMTP id 38308e7fff4ca-39f864623c8mr20316881fa.36.1785784478349;
        Mon, 03 Aug 2026 12:14:38 -0700 (PDT)
X-Received: by 2002:a05:651c:a34b:b0:39d:9dec:2494 with SMTP id
 38308e7fff4ca-39f864623c8mr20316691fa.36.1785784477930; Mon, 03 Aug 2026
 12:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260715025941.1571316-1-npache@redhat.com> <20260715025941.1571316-5-npache@redhat.com>
 <1e2e464b-07db-4fa2-8e38-2d73a9eaea07@kernel.org>
In-Reply-To: <1e2e464b-07db-4fa2-8e38-2d73a9eaea07@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 3 Aug 2026 13:14:09 -0600
X-Gm-Features: AUfX_mzpgeololY3myjbblsVFbE08PdKDlfo-6olNhWKvA246eL8HAmCelZ7BnU
Message-ID: <CAA1CXcAsh4hOSsNbAM8MKcg1k2q_XZ3kxqiE6TpWddrSbj_soA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] mm/khugepaged: fix outdated comments
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s3snrZUf0WtTy8XeOIxONpSiQ2PdY26C96g8dUu0lCk_1785784478
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pa8w16ahje7oaruw6qrchse5qru9opyh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3F8320007
X-HE-Tag: 1785784481-112239
X-HE-Meta: U2FsdGVkX1+2IfRGCGZ8KCkYBtnHaNsUG8poxxxHCkqOhwc33ZyId4f/W/zp2kNzYxT6B6Q/PWBM9SW2Nj/mRw5SWD//lgXvZbLs+UnmWLTBT+dmCoOyx+aCiWkzZ7RhC9uHk1o+K/Jogw/r5RzvYjvGgyGkr9jYZuTO4EcmxDgMgccXIsKvA71ONpk4P7va7HVopfmgwvLWf+qsCyJzrC8T/2pQs6Q0djj58htAsXhsXLBwf2a+y3ZNsD6sapwAcNuyhvR41NUFkraC6esmrTLcyohzTQdkQn9VhSXnSzr6kVheVAG6CW8jI0ubiFAu/3NdfTR1EA9Nbrsue73PpVNLWtaSRj63+Q967wC0ogDA+TeHHHyO8clJ1H8LjK5gx1R+PFwwWlHjXZ9qPgiKZ3+gTP7bOBeeChqXJ/DfWPMmm8vtc4U4OK6UVBjhfM47H8UsZAupZ+8g0E/S2PbG2DZ+K2qgUJeKAbOi/I1actoaSAifQgga9TcsRFMI4x4wvJKFx0oexcKgCv0mY+N0HnYmPb2mHxMy8mWTKVXqQlMIiXlt7spIUWBwDoGHQc1CaTtpyLR7TTIy5P+uVHKahv2E5Vv8vW2wQpJpEufAuAuUpRv/nJpUeosg7vffYqzGFU1vYvnTLt/sIXzLyu6WW/EHE0+JsLgG9GuR7+9fs7+nZxTs72lPzjdWcL1sAgK/rEs/3+vL0OYVWGttb+H8qesq3ukglpX/961aV/+MpdRMGoetEL5vnRfhjoXSLy4BvwSppq9jrecgUBcIFLTP350wTwo7uLxB9VRzCBTOUfyppGClMW9VdZDiwEzj01bGbgdd8XHoDIWgqbLRUsTeGYVQS3UKxyetS+8R4cRs3/BpQXJ604SEeMOOa8P5NWR/cjnYDuuL605i9wmUmLxXuH3xO/l/mUESNdBnPg5tSopGExiBU8geLP13SSLYU1A+0ATjiqYw5ggfe8qg3vs
 I6rUFUfJ
 ESfC/63evpfgNoGxpaTKFSidZ/ALNS0Rc+0dNzKAI0+4iKXIeAVD6CuYi8ZGH+4bE2EOJwmi4ZactrwajZyjTt0WGOFcYIq/7U5AyQDALdbKHc0Ek2+hofibw1N/1KzI+rHjdykln2QdKX4+Sw3KIxNrB9mYf/aZg2V/sUhTiLwdkHxmgcxTaPJQ6VV2jXWjPAr5jdMhDA6T6EnTy7LAm1A6WiZ4YFDIQ14j71f4TmhIjuH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 3:45=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
>
> >        * UFFDIO_MOVE is prevented to race as well thanks to the
> >        * mmap_lock.
> > @@ -1643,7 +1643,8 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >
> >       /*
> >        * If PMD is the only enabled order, enforce max_ptes_none, other=
wise
> > -      * scan all pages to populate the bitmap for mTHP collapse.
> > +      * scan all pages to populate the bitmap for mTHP collapse. The b=
itmap
> > +      * is then checked again in mthp_collapse() for each attempted or=
der.
>
> Why use () here but not in the other cases above? (e.g., collapse_scan_pm=
d)

Ack, I'll update that! Thanks

>
> --
> Cheers,
>
> David
>


