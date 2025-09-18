Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2D8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555678E00AD; Thu, 18 Sep 2025 00:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CAA8E0093; Thu, 18 Sep 2025 00:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469758E00AD; Thu, 18 Sep 2025 00:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 380F38E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:51:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DF0414024C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:51:09 +0000 (UTC)
X-FDA: 83901146658.06.7594A74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0FD0140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:51:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvi6M7kP;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSCbFYdol4gwU++b+q+6eG54SBwRB29n9V4ZoQ3yoqw=;
	b=Nf4/n5g2y18UK1uRGOL4jIMx44jp0NN0sZ9NNH3EqZ8Q7u4ipGSAWdX23ULObT7N5cMnO9
	2/1TBpA8O+hULx+xOkIKr7GJhvCpkajZuAO1AeMcNZ41dK61/bB0sWPyko9ASsuByk2L+Y
	E2EiBcqER41xFcCZC3vQcaPFOvMpSMw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvi6M7kP;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171067; a=rsa-sha256;
	cv=none;
	b=8L6eumfnFDs2NKfrLAO2yiBeZdGkjekyMOn/ESIOtiwj3ro7awWdEbCTUEDFUNS0952OGX
	fsog6arwZSL4LiX5WvEr/Om5i7Mibm9niEVHYIu5kBv7OnXCGYm8KDJkq8TuxRy/rPLGmf
	t0QAFmIXXDtTSzQgm+zj1VDBoo6AW7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 142EA601F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3CEC113CF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758171066;
	bh=hSCbFYdol4gwU++b+q+6eG54SBwRB29n9V4ZoQ3yoqw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rvi6M7kPzwgDwjRR+dHs6GZB2dtkrFpkcxSA6qk76jbky4SiLIY4pLQVCJPXuY1/Y
	 GHG8b+x7L4NAIjfZ9t5HDBcW9XRV1GA8pM7nBa0ipTV8J+/Ksk4VOavSbOrFjczFAB
	 PUtZywW+ZEohs4JPkXmLMA6TnDBnMCjvzdBuxYPDp49HBKKMxEQP852MR2NW22mw7W
	 kqN6ssGE1ynd5z7Ju0732sLq1Dd52OqW/3W29MrKGn2YR2M4MVnvb6o0hagQiweTou
	 htPgAzW7z73LZTXqtcfOi8HwfQ61ApdJSuZ0aAW4iqao2Jn6CBLxuVUieR3Y0JLNg/
	 +QaJAfSGT6gFw==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5607a240c75so570197e87.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:51:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUrFoKTpSRK5mu56c8Zspckmql/9i6+S+GvcjQXeUTyUbLhg6XewdBCoV9x97ERP3klYBo5V3nxVQ==@kvack.org
X-Gm-Message-State: AOJu0YzKyhS++KbPfOONIKZ+ex57G0LC7tvO8innIsQA5/rSj/8UCM/e
	gAUK8ZNHWHKsSB1xY8NR7UCUjTliQy2XD22eoXMAr167EeMVwadPBAq20FCNY2T7sjIbNhImfBE
	RoyZLK59ARP2ilMtFKjxVhpfu/l8HaQ==
X-Google-Smtp-Source: AGHT+IGgmr35+M05vhNol35FnfvJZhXDPXXRR6AIoJkQcdnzfAX1KrKgvXwk0v6y57+pEk1zXQlQA9r/6aTx3Dz3NtE=
X-Received: by 2002:a05:6512:2903:b0:55f:486b:7e5b with SMTP id
 2adb3069b0e04-57799405777mr1451888e87.41.1758171065295; Wed, 17 Sep 2025
 21:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com> <CAGsJ_4xTPJo7+kCkkiZhn8b7xjH7yXeJ2XPoXeoJm+XwJB_o9A@mail.gmail.com>
In-Reply-To: <CAGsJ_4xTPJo7+kCkkiZhn8b7xjH7yXeJ2XPoXeoJm+XwJB_o9A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 17 Sep 2025 21:50:53 -0700
X-Gmail-Original-Message-ID: <CANeU7QkKS+1TvCRkJUcWQo_emyDJ-q261SfjKoPuEfPG3Pbifw@mail.gmail.com>
X-Gm-Features: AS18NWBUHzf4JRxxpGz4NBNi-ZdFJXllMYmFHXL-HaEBN1mSBaZpw2RCXXPZ-ak
Message-ID: <CANeU7QkKS+1TvCRkJUcWQo_emyDJ-q261SfjKoPuEfPG3Pbifw@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A0FD0140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t8rrno7fi5cx9hwfxcmf7x5sbg511qnq
X-HE-Tag: 1758171067-407554
X-HE-Meta: U2FsdGVkX190VSjenCAVNYaTo9P5BOBupWvXmuOmOQ7zcRAEAXcnLFL0FhuOZoLB56DvKaJG4Edbk9VOIEs88N3zDU+FrAV3upuicj3ANqCK7gCo8ju6RIAKk10WzRYg/eAHpVSrEitzMdKcpC2FIw+S1+x3/XbLPFOvpEJQUCy63cj8rQhwVG8Kxhfi2D+xehVUWMIVrKoDEjWqsxA6LJkQDdm7YgETlSNL05bgfNKuMFf2UWM31sBajnuOBS2BzO/WI3Yr4obQQGmUkqVaDk5QeBDxYanFqCDW729yX5vWeMV8LqqWLDyBMdyIzcdDaBftVu4yhxOWA1ZarMB8wpfS/WEh3rcY5N7XwAEoJ8y4DHqiUMnGIEJfmXSgDmQcFhwJYJhA2aAnzTLrXvpwplcTw9zL5ng3okaG38RaBQWUhzDtO6M+Mm4asSdOmRyeBwt5tVRN6Eh/Stqt/Hudo9TsZzm1Vd303DC8cBKMLTA1FCPuIQZYHBL8hV/gEcVURL58DYiYMUtjH9rk4dVY4u3k1xHx+VglO4nREl9TAQF6iO4xCGaBfnnBMxMRaljLgmEKtzYZBvi4M06pVGNcONMKRDfGBAGpH2/rbIsO2ldeeV0WKGX9tNDlhixjg1mY1L9Hjb1QP/d9XYTG/E29DPrK9Qjv5y6zjytNN/XLbH3d1Kt+tA/HMpiDoVdzUtJGpqSNA6ed9ci+pRZFKY+R/cjuXjwiZ70aUKNISyaii+Di89NbNqYLiIZviBXl+sosfJC0bBq0YLNNgocJMt7bW7GaJOJUkWOIEAVoKgfaEoMXQR+gEP0hDdYBiqEugVxGtTTDbNCGvdURd7MFrQHmTLgMx6BZvtNHq3vkX2CSlgZikniygDxGWY6iIZSmX8fBden66NFK8ZoQsxGkUDuNfLjSCtB4fSX72g81GBSOPc2X4duNirg+59qftdTS4dMjQAeTEogd8K83O4N1zJe
 VWEh4tzs
 p5T0aDvQWrSeYBgvVzmyE+GDPkhXfXF3hb+JVuRjCPWtj+a6IUUHXfCdhymjaEcyqaUbQyYpvkPM6Ab6W0Z91VknNeotkkoJVSdxM6TTPt/Qe0O6O2ZC2MGgeaN4w1qzmLylT+BlmFvum3Rs/niMEBpSd5qRhung8kcCG+TfO+a8RUBlCW/1mZUerI/FI9zbq61PCK/5hjW8XezP7qwBDka594eCONRt4O4EkukJCxQdCdGbHCqpBUK3gpGwMKZ4X6sTRTS6C7r/kizyxCs23A/EkZLHjRobwfWhuEQT+hdCZqNrMguQw3yJJkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 4:50=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > Perhaps you could describe the swap table as similar to a PTE page tabl=
e
> > representing the swap cache mapping.
> > That is correct for most 32-bit and 64-bit systems,
> > but not for every machine.
> >
> > The only exception is a 32-bit system with a 64-bit physical address
> > (Large Physical Address Extension, LPAE), which uses a 4 KB PTE table
> > but a 2 KB swap table because the pointer is 32 bit while each page
> > table entry is 64 bit.
> >
> > Maybe we can simply say that the number of entries in the swap table
> > is the same as in a PTE page table?
>
> BTW, as Kairui mentioned, you plan to store the PFN instead of a
> pointer in phase 2.

Yes, let's update the document then and only then. Otherwise the
document will be mismatching the code and confuse the reader.

>
> I wonder whether we need to switch to atomic64_t on systems where the
> physical address is 64 bit but the virtual address is 32 bit :-)

It is possible we need 64 bit for the swap cache anyway for other
reasons when we get into the later phases. Again, let's deal with it
later.

Chris

