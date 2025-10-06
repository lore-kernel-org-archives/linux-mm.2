Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D19CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 21:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0B48E001A; Mon,  6 Oct 2025 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098718E0002; Mon,  6 Oct 2025 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFD28E001A; Mon,  6 Oct 2025 17:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC408E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:02:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F89FBABB1
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 21:02:40 +0000 (UTC)
X-FDA: 83968913280.14.328690C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B8991C0006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 21:02:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=etQo3ig1;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759784558; a=rsa-sha256;
	cv=none;
	b=6/0By/9zxHwVU7Sfue8Rv3CQxdr7luGb3fSw69ix4NR5p9+QgI4aT90XJaFNAqSSa6QI12
	bHNvHj0g+jATEaUpxiKLI3E+93H+go0ResRycCYHEShlgb5L8eEXdcrKrSUdw0O5QlpOM6
	/EF6kt6To72s5bhTgA/wjY+1uei217s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=etQo3ig1;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759784558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymk03Atrx/x0O99GjOXWpG6K/ZE8/FGkAGFxmtXS5cQ=;
	b=mcpvWWh1NWxeOzNDaZvFtkw7+/KqOhQrosOE2R+ahIEw7ZREJ/X+lb4+p/vaYiFSI4QByh
	dUkT2nViass9YcA0CFMWeAEknaKsGAR1Aj7ybYVH0lwUz6ZbtsCFJzzOvIm7sYQNziPCSU
	TeetLSCv5yHGUfEl/atPpUc2N7SwwEA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759784557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ymk03Atrx/x0O99GjOXWpG6K/ZE8/FGkAGFxmtXS5cQ=;
	b=etQo3ig1soEliSSZ0JikuQGsYy+owZiWBARz9/AnwTgnJkB3FJLTxzjjwHRKdwGsrwFvG3
	9+LY2odk9MYZ6CKmS3F/gNPk3/vkS+HgZuz5Qj48GxqI/0xyBp/qay73MhWw9b0SQ9q0Ud
	QkZoTPZV9RJbHBwq3MBqbrQBtWfycGY=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-i2y3vzypNB2HP6EwCgl8Jw-1; Mon, 06 Oct 2025 17:02:36 -0400
X-MC-Unique: i2y3vzypNB2HP6EwCgl8Jw-1
X-Mimecast-MFC-AGG-ID: i2y3vzypNB2HP6EwCgl8Jw_1759784556
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-8e35054fa3bso7326841241.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 14:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759784556; x=1760389356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ymk03Atrx/x0O99GjOXWpG6K/ZE8/FGkAGFxmtXS5cQ=;
        b=cS5RoDVIHwc1pEHLaDvEXCaVUtWH92RmK1IRXuNmULvlkHUxHqEY8VUQ55xq8gmnL2
         6HuzrnTlv6RTRf/YBxniBPf8kU3TwfQbZcTFFTYpPlJc4yakOf2sAE0VzYLmtyWwo45u
         GlzWI7G5qzJHpnH96xM6IsVyJumBfVZqfbtaCpsZDQq4Z44uFq7ItfyqyHC1X12oxjWD
         J1nMhIQpIUL6nFPCxEzB4wQJV0Rrc8liNNZmXg4r8iSUvPjdEU1GrKj2YJsEMwuGdl3+
         qPRs2ImtDIQ0SCaR60xtOODA8elNfc1RyFqJHtmW/qimYwV9wAkf1ZhEWrPWRKNqYLom
         E96w==
X-Forwarded-Encrypted: i=1; AJvYcCVDRED63RFz3JUIJ4uhg9IiT2aYtzWnCVOkjKJEQdkUfGXizlHeOXXwqMYkJmluJCM2Mzbdxln1ig==@kvack.org
X-Gm-Message-State: AOJu0YwVNcPl51/6vNWSy8mbUHqZhZgZ+ikWSvcd5Dz3KtoFXdaTAG8c
	+1Y/h2jypCM4AwrQi/euALlCdXrPRLqWDHLNWNxyhTGuXO7XZCE+oSoET0uyD9g5XWElC9+EJqx
	+yYxCAI6iDnERmNyNnS9hNOAmt7CWV5Wf7HyRTtqj3CpWucubCs1e
X-Gm-Gg: ASbGnctINvWYgllkwGoNPSJQudYYAEgQau3dxjOIkGUC0XYdyI+CEElUO6HTuhHmTZi
	WTaKIM69HlLdrMSE3BAZfv5048btNmd+P9ErEK8zcIrvGcP/kDWrQIg3xgRr09nvuLP3GfT6nk0
	USy03Qxt0CAfT9LnKusGwzvFp4xsLlvxE3bohuADbwkb6I3U7e7Pd/bFQ/pRwNnhmsnSuOs8fch
	jrdbYYb0qAJTbjem4Xy2QEgfdupagiAaEoikYv9eMo2AULgpFcPHcIQUtVzWarqaGL8oQrdgIGg
	ek0AOvU7dXMQkDPmYF7c3UFmU1E7novitz6r2g==
X-Received: by 2002:a05:6102:32c4:b0:519:f3b6:a1ae with SMTP id ada2fe7eead31-5d41d113720mr5161975137.22.1759784555823;
        Mon, 06 Oct 2025 14:02:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUIbyFy0bAXxq3hF6obawCdsm67GU+uNu9K0VYS4VwETotxyroLK2fz6RCNecsQisNvYCK5g==
X-Received: by 2002:a05:6102:32c4:b0:519:f3b6:a1ae with SMTP id ada2fe7eead31-5d41d113720mr5161917137.22.1759784555258;
        Mon, 06 Oct 2025 14:02:35 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bae60146sm130567276d6.11.2025.10.06.14.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 14:02:34 -0700 (PDT)
Date: Mon, 6 Oct 2025 17:02:31 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aOQuZy_Hpu1yyu29@x1.local>
References: <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
MIME-Version: 1.0
In-Reply-To: <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ovbFqCu6LqRi-skvvq50eaG_vYM5cVYXjT0cQ2O6qvQ_1759784556
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: c9x86bjaas1w3cjxz7ei6pf7g9r4kkz6
X-Rspamd-Queue-Id: 3B8991C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1759784558-293081
X-HE-Meta: U2FsdGVkX19FxoqawryScK79/q9Z5XWXmd+d0hPAG91H6L19n6LTRbGxM3FWk4n9ES6JRUltdQMglP4/bhZ6C8ULU4OPTcvlcmMedkfCs/eQPmLW/JNBrxB/navPA8UfayMAzH89MCaGkwnlenSfsaSkdDdV7/CE07NNwiAHjy3DqVaizZLUipKu+J2YcLFheQ6klo3GDS/a/8cFLyq8fVlgps3jEXDMEltp5qBHRZd41IrTIiwCXY4xsT7JJDZ7T36v7+jkJd1PbwsKjDZ0HTE5NRhMjT1MtvlOZaRQHE2K55+hD7CtumHynVbAE9fJsTm3rWntXfrAWAAGLE1+CDEb1C9hA7wrfYTZhcId90ABC3MO8Oia2vB2Dg6ILLAfci/HXni1hVKAFjgmV47dCyCgIZxRnNDm41yLjGBDtcycDVd2vpH9DgG8bm9x9pUpTj1Japiw6zEAWDBKMuw2+iwuHKeCUNZ0XJhHu8YgTY0CoVa72VyEM9yKulWG6SEnemjNilwJFwNP6+vODf8pkx+5lFh1GKdnWrclpJS7IYoF6XE6UwAShSIMi2vdr2nrKtoeGFW52ilM7V2OKUOpBXtCxB7NUJe63g4IieVQI2HD20H3LGsB6X/MNhcyn964GuQZKJOUdgLSPyTpru7rLtPjLSXGqMStJZnSrmahwXiQPHE336ijPw5Bgs81AqMX2qQPxWCJaD+rMoUNZU12i5lmGTpsFdmi9o9XwU9IELmchPVr0ydQ6jx1rfPKytQj48cwPxofpjOUgOJ+AtQ6I0nHGu12eoqm7ep9PklKTREipiGJ8+09/1oGJrYkEG+L46OLDSp9tcoVZ9pkqWVMqGRJyCDPlh3UxafVu1PQe4cMkJcpriQv5nxE7sLapsY+xsgBcymodm4FsgNarIAa8ropxBVHIy8Ovk+TUufKrtQhTvmiv8I0M3hP4fsrqBnMMF/x0PIfqPOP0w6qVr1
 SPg1jv3X
 xdKLHupbeZcgXLchAVktPKzymb/EKAUH85w2p9iuzJmjhJ+rnq5MQwDirvdKhQOo3F01/vR2HIl7p4Ae8gyJ4pSnXpbTqTyeYdcz8YEATRZNZXLQ/1wDSxyiK2Vz01N6bdLN4PipuSrIgoTKYNEBq7f+bSTapCca7gID3OEzM3/0zbNn0lrJGCzvwHimbuqP+ZBEKFuT4OhehgiONj6TRVAKNIIEKMWodhoACuB6aGk4tKLeRnmnyQDTWKppM4bUoM64f6s6dnBEP2tYUlteTW1Q4MBWXbg5xwLZc79amLroa6dcMP+gbvk/GA3rex3HcECKwLyNtRxzxNMAkznzjyyIDH9MMXAL/EjL0H45utADZp0OQY064fiF6Py17RANQ6M1ysAlOwzJcjG1UBZofqGPDaWkxmoXK9thWqYmOSocxnm0A3iA2Sxkg37Y3j+zkWNy6qgPa7TzGpx0eGQTzCCg5khsXq+pdPT+KP37Jqh4RmjD0sW2dGAtHf91Asr74+PNMD+nLrWd1+IzxuJKH6tSYruMO+Bd8+6qUKOU7qWg5U0jouYJ5kZKwIE33Rom1UozXN/ysY5PFSj8LClYAntatRhOMRVUA2B2q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 03:06:39PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251003 10:02]:
> > On Wed, Oct 01, 2025 at 04:39:50PM +0200, David Hildenbrand wrote:
> > > On 01.10.25 16:35, Peter Xu wrote:
> > > > On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > > > > > hugetlb support/shmem support etc).
> 
> I think this supports the need for a code clean up before applying an
> API that generalizes it?
> 
> I would expect the uffd code that needs the same uffd_feature would
> logically have the same uffd flags for the uffd_ops, but that's not the
> case here?
> 
> Is this because uffd_feature != UFFD_FEATURE_* ... or are the internal
> UFFD_FEATURE_* not the same thing?
> 
> > > > > > > > > 
> > > > > > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > > > > > the supported ioctls?
> > > > > > > > > 
> > > > > > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > > > > > 
> > > > > > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > > > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > > > > > supports.  Here, the modes should be the most straightforward way to
> > > > > > > > describe the capability of a memory type.
> > > > > > > 
> > > > > > > I rather dislike the current split approach between vm-flags and ioctls.
> > > > > > > 
> > > > > > > I briefly thought about abstracting it for internal purposes further and
> > > > > > > just have some internal backend ("memory type") flags.
> > > > > > > 
> > > > > > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > > > > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > > > > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > > > > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > > > > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > > > > > 
> > > > > > This layer of mapping can be helpful to some, but maybe confusing to
> > > > > > others.. who is familiar with existing userfaultfd definitions.
> > > > > > 
> > > > > 
> > > > > Just wondering, is this confusing to you, and if so, which part?
> > > > > 
> > > > > To me it makes perfect sense and cleans up this API and not have to sets of
> > > > > flags that are somehow interlinked.
> > > > 
> > > > It adds the extra layer of mapping that will only be used in vm_uffd_ops
> > > > and the helper that will consume it.
> > > 
> > > Agreed, while making the API cleaner. I don't easily see what's confusing
> > > about that, though.
> > 
> > It will introduce another set of userfaultfd features, making it hard to
> > say what is the difference between the new set and UFFD_FEATURE_*.
> 
> If it's not using UFFD_FEATURE_ defines, then please don't use
> uffd_feature for it in the uffd_ops.  That seems like a recipe for
> confusion.
> 
> > 
> > > 
> > > I think it can be done with a handful of LOC and avoid having to use VM_
> > > flags in this API.
> > 
> > I waited for a few days, unfortunately we didn't get a second opinion.
> 
> Sorry, been pretty busy here.
> 
> If we can avoid the flags/features, then I'd rather that (the derived
> from uffd_ops == NULL for support).  We can always add something else
> later.
> 
> If we have to have a feature/flag setting, then please avoid using
> uffd_feature unless we use it with UFFD_FEATURE_ - which I think, we've
> ruled out?

Yes, there was no plan to use UFFD_FEATURE_* in vm_uffd_ops.  It's because
UFFD_FEATURE_* was introduced to almost let userapp have a way to probe the
capability of the kernel, rather than the layer to describe what features
userfaultfd has.

For example, we have UFFD_FEATURE_MISSING_SHMEM declaring that "the current
kernel supports MISSING mode userfaultfd on shmem".  This feature flag is
essentially of no use for any other memory types, hence not applicable to
vm_uffd_ops.  OTOH, we don't have a feature flag to represent "userfaultfd
MISSING mode".

Thanks,

-- 
Peter Xu


