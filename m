Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8165A606D83A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ADCv9FzK
Received: by kanga.kvack.org (Postfix)
	id AD0006B05B2; Tue,  3 Nov 2026 04:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A791D6B05B3; Tue,  3 Nov 2026 04:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E466B05B4; Tue,  3 Nov 2026 04:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 713B36B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:29:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E836140321
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:29:08 +0000 (UTC)
X-FDA: 85393283976.28.1606D86
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 445691A000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:29:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ADCv9FzK;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793698146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC4ATzK3IxZRvi3Ei+hKSqTD4en8xH1y2tp0UQprNBM=;
	b=bas09nM8LAEz7N12drQRLO2Ak5QXEkAyGZ7KmjaJkfMB02qdRFrZ/I/Ml7kq5Q3oWtxL53
	pQClL41e/mpYX7bDXz/GXTSuNQWJYuGgeJ7capqRpseapaWgF6gLezWwmfU8MWmjQl5JMI
	jt3IqqapNnOo9AZwLX7Bca0+BUnd1rY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ADCv9FzK;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793698146;
	b=KSwtFcGvGJSzoLmL/+dxJ4Y+Vrq9lr2box+utdKifd1iM230OMHL6sgpsQo6QTxKfQA3Xt
	+zNbJdP/PvkkmS/KmNPE0wANq2gimmkHFUSXhENaulCZ4miPq6f+Tck995ZsBMPdlXudvY
	7SFkKo4GbhbdZx6BJSlkC0jbaRsTJeI=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c4d870d54so2341587f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793698145; x=1794302945; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GC4ATzK3IxZRvi3Ei+hKSqTD4en8xH1y2tp0UQprNBM=;
        b=ADCv9FzKw/SwAxWJY5VG2lHM5a44BVTvOyegarqg0+3EwsMbt0V0IRGE8JPBnM1SGL
         J/HDEwrickPx0TUefHCNVnre0/Puxlu43ivBwImZvEsA/PQC2/icn1ed3auaiF0DJBUi
         bw5QxiWbSpNAu9KlwMdgs/6iXreFtgf2FUl07RdxFWhKEJgCtrndlvkaY/5K+eVo57j7
         imvyjsFFTR8NltW4n2ufgGQJ//lzy7wmBRQpC9+jM24jsuxojjif+B+AyLKFRCcnrwkv
         HRJ1r5S3wAvGs/ftmGpvg400gHHqHIMz4/ub9NhzHknZ8BJmyUkQlOpI88XayTlaNAXD
         zNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793698145; x=1794302945;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GC4ATzK3IxZRvi3Ei+hKSqTD4en8xH1y2tp0UQprNBM=;
        b=0FFPHwXyksFh954dbr3JksBp5q0AeBd/dBxlKX0FJtNU0mCEmRjzTFQFdjvVgj8Cr1
         68g8BpqKBuJLa1B4lfm5nDlAGtQt8dx1duubE8V188/2fzotb3L0vTBBmILVeQOTLGzL
         AW28e2bA2C+g6BxYmsarJ915dL4cs1+xVSZ+dhmtlicWnocDKr7oh9wjTewI56M4eyoO
         RqYNP+GyE0jwzna0OHerw3qlEzBBcbi+h46CXtxOaWHsr4SfS6xfke8ElXQv01a7COkh
         qi1EVvSQ+US9bZ/F0kBNebpYtiQU0P8sTnz4p5zEEuJg72mJ81oKvZlpSZ5zehlFNHaC
         v39A==
X-Forwarded-Encrypted: i=1; AKwUvBwLDN9RTm9zpeJQjznnP5lQoaYuyqKWGWw5dERjAGnQZ1TmcOGZvJ64TAoWXSVrAOWjgH8YX8rpGQ==@kvack.org
X-Gm-Message-State: APuU4Z8rjC1DIn3f+257bgXtfj1PooqQySngzDKbQTH7ZCQEPnIdeQ4R
	sLE/YxyABJR84/h+5Frld08RV0byY/T6xsdOb1GRRcjzz1pdVdh2kMqb
X-Gm-Gg: AYBFou0Tmns73gOJRThNOHrpmbpfFgh3h1ne4picn2rbLMZ43PXp1HrO0E3MS0t1mhz
	01t+Wv/AHBg+1i5c2FFgGcm31ahzbzt9CyUz3vey9Cb+1TIyELw7zRcBf5qPwXixHU4iDYn4SCL
	EcOpKAvtf7/JOIjQpPl1zH28KPrCDq0bmDLehqe6k8xlbDsjROBWnaQBlLJ/rnFhU/wl0Qf19AO
	0YAjDS8EOgHtVR73epOystwScUOUp1AAYKD7L2Fc8yk9zd+6RVBWSmnyn3Jm5A8yJ2kV338HdVE
	sX9/Mb7gmKRSvnwReTwy7APw3T3SSdeoyuWiJBt8fh4PulJoVr2utu3Ajk3rGW/AdhH/SVJRt5k
	Qk7f8m4Ow174KPCCUu9AP8kcAj7+ukXh9ExvTORCzMxOa3HCUG8mfkQDbbeVsw62j5IvabGiIeB
	yyfPpf86CQi0vLMhyyYEB/hiPDyYF4k4Gwy+SZXhCEeSBKtMmcIWHDDMZNLDkphlVFES9H1SgAE
	RxZ8rccXnhVamXp7Hy5crjrguDzczlsyPX01kyCeLGjZvMlJ42B6cxbbfk5iLOtwFzEC6jeh+gP
	AtUoVh69Btu45q8eDYmIQzfer8AI1CNfpwcX5X6LoceTdgTU1tuOkzgw58m7prYI6cR78KFIVhd
	FUP6gvnYlsWQ=
X-Received: by 2002:a05:6000:4014:b0:48e:5071:420 with SMTP id ffacd0b85a97d-48e6e2bc75fmr27335389f8f.2.1793698144786;
        Tue, 03 Nov 2026 01:29:04 -0800 (PST)
Received: from C422HJQPQG-Fractile ([150.251.170.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b727c6sm26134262f8f.16.2026.11.03.01.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:29:04 -0800 (PST)
Date: Tue, 3 Nov 2026 09:29:02 +0000
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tal Zussman <tz2294@columbia.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Message-ID: <aumpXjTMlZhV0PSh@C422HJQPQG-Fractile>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
 <aumjF5peb2vyuncA@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumjF5peb2vyuncA@infradead.org>
X-Stat-Signature: pzq9jsawtaafsiqttsgy81cky4nu85p7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 445691A000A
X-HE-Tag: 1793698146-601591
X-HE-Meta: U2FsdGVkX188aSRU7f1fQuN+ADE+kLF5I20UEvNzdfcHotKdmWmqrYE2v4h9485AS1+wM4ekG1ljop3VEWATB5aKw3scRcA8IYdj4cKE2By+ARr5xXE7VUtGGRosOKoogL7Wict9f5b3P6Fs23TleA3BPkSgs9Qb0p/l39CIm32j8PHQrZ4DSDwk9c+s547AaJiBz1b0pA9HfwB+H4rgDUrxBWitSzf6hINbPs0Q2AXUiMlBJlfCbzq2DkQ33ft7Hvkzf4H62hP+Xg4eMugA84c8bzJNOzCzOJjbzXVh7fGzpELMbp7yywcu3v7g5eewUKrNZkmHLinNKZY2gTZSPVf8PEez+uozWiYzb7cwIoBDz9g44WadOW23rDUnvsMcbdlTYFAO44Tv2wTmt9ONrYV+DRkN9/nbKen0YkG+8dbiUgtLk9kPlxdho5oEzGWUw6EBs52WeRuPpRzukUBk9urvXp+hwzXE99Z9x1gzhHKD/DKNBkqGD0CbsVJt/EPwdzacLdnUU59FrD14vuUb85ztSQJ//bc2qTErxcPSruN+Cd2ZQlnqjoQc46K/R/8vLeJG25RDyeAepA1Jj3ggM9PJfZQVqCi9AXfvzgF3vzo+GofNswxRatJuTarbzVQK6VM9Ucp/ATAGGb/7UqcZV47UFrBhsN5O57lYf530Bo3CiYV4wnPGETKN7C5IvUql9fMiUTstEn5f20pI17AspY5Fc4bB3mpHP/JqaFG1i5h6YZXUOOcKtifQjoXxUzI58Y1cW84us+kXMHCZ5C+TqmGKSJQD+NyLpq6O3VTN8qqxzfJbhH4tcuKUwQHldjD9v8Ze6X6GprOrIHXoFa5XiwqTOjzbxa9iV1uYgrtg/m8bFg7PI6II/UWvL1EBO8974j97dg+75ngAOsLM/B6jtkGIw/4PuE1pAmKwyczKa5AEKidOyDzyCPM2H7C+A92pmPrR6318ktfh3zO3yFY
 zPiNSskh
 mcroPIRLlaOpUZqKapB4VOyQB+9glf+tAfzWoFnWmrcir6JBvIR7SYbxgJ7K0RpL1fukejXZEdWhzp+UoRDogZFBj9gDQ4cPNRVPJlwnez3IVfeHDKDl+tiPXPS8NLvBCJjt9BRqoVkXkQjOdes2wxmU6luMk0XKHl3L4plByawUh+tXLsiRyDsshHxNTql5WZwr0r3F5g/SgUGfTfikX20cLzF0fcHWc2vt8SfYQaCKYnh2Hxu2HLMtcDQbAIkTDXzC8638b/GqKs3mJb+fvkE6hvpEjFsxVMWhVnRG6uhtFlENRUcj8OeV+q3CFCKk33rqN6YGe0gZrbUQTOtnZ6v1oED/YB2rxWee3HBppBw8RMeJRxxE+pQQu+C4ToFGBqG7dV7Wb3gDcnI00pdpkGub68NyeHd1tPeX3PBjGdGJBBdhmIOPzoKgAvkLdVVYlK58XMAcK3ULuvQhhVBZboa05+rjDBml3bA00x8FUqsppnpxSf4d6eeRUv22gIVYPpaem7ozBcqV1b9vQ4oe97Rkwj68LbO/BTaGKtAcfAw11piQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:02:15AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 02, 2026 at 05:56:05PM -0800, Andrew Morton wrote:
> > >  9 files changed, 8 insertions(+), 110 deletions(-)
> > 
> > Tal, you obviously haven't been following along ;)
> > 
> > 
> > This development cycle is not the one for cleanups and new features,
> > but this one sneaks through!
> 
> Given that this is purely dead code removal I'd actually vote for
> fast tracking this into 7.3-rc.  Unused API better be removed ASAP
> before people start using them again.

I agree with this sentiment.

Although given how long the folio equivalents have existed, I don't
think it should be too much of an issue. AI is decent at catching
this sort of usage of "legacy" apis. I'm not sure if sashiko checks
though.

