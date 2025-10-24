Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642D9CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57EB8E00F3; Fri, 24 Oct 2025 15:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08B18E00C9; Fri, 24 Oct 2025 15:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD04F8E00F3; Fri, 24 Oct 2025 15:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 957208E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:12:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3901BBB534
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:12:17 +0000 (UTC)
X-FDA: 84033953514.06.C2E9631
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EB66120010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:12:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M2yioQ+B;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761333135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCR40IXSwb8+XBgjln+OQr+nWcDb8wZGch2v8uE7uTg=;
	b=1n1cvr1Y5SrpvQMj1S2uPi1w5bqUQfFhiMW957nHn8DG3YAf5krAAYvDjZvQfMgFSHbVFC
	Ly2gWXF0KyHiEBJLez8bHdXsTUcLmItfGsnxuVXyaukH4OXbl3wjZAfWk24tGgVvZfmyN2
	FtuHBNJIIc/Kil3Pc7XDj3sCJbF6Olo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M2yioQ+B;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761333135; a=rsa-sha256;
	cv=none;
	b=F7X0fiZovE1uglHaKukQyu33tJi4X7cB5GczIoK80UcJY5tn2oHxp0uemOiWQWli9htmS+
	gPDnXGOgYpmJRkJVx9J9LxZSOtATltQPTgEIZebr6Q2ld294oHosVahLpVV0K2nTdb0Bea
	LuV7ll+E6CzP/Ka9jJhON9WKE3Obov4=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8901a7d171bso237680385a.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761333134; x=1761937934; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BCR40IXSwb8+XBgjln+OQr+nWcDb8wZGch2v8uE7uTg=;
        b=M2yioQ+B9nKXC4T8Sd8Px2bzk3tpDuXElHqlLoH9PLuqwyx4re1yKupCZ8orint7Tu
         Z5DL7dPZ0CMDiGq1PTf2MX7YKqi+lBGELx0kw+ICMxpRJ8/1G6Oo/rUJFL1IjWZq1ax/
         E9pqpiBiEvNBGogHqHebmp6eViw9VkD+QK3mCX+M7Hr+uRwPfB/Ho0S+NoijpbrY3YlY
         5w3yRulWOl327fSr6b2ACkuF7VLxfX0nJlJVAhS1p7+b6/d0GF6U+MP75KI3yBuxXLCp
         Mhd25/d9BM/MayVNko1t99bZxqnbrJyhSGAUe65ESewQFoJ4KO29JOvlHsCZB5yjMCs0
         0gDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761333134; x=1761937934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCR40IXSwb8+XBgjln+OQr+nWcDb8wZGch2v8uE7uTg=;
        b=PdVItDgd4LAi7kn2r5xAHpzLxvEcKwEMMA8sdslL+TG0TSwHZ7XKX8i/3W/jdAosrd
         EzTRZlBFYTfT25hqS+i+dSnYITT0pc4ifhrymtIVUdR38AApihdBIytIwXQO1lv8eJsI
         JhnZpmokmV0IO3S6pvOdU2gXW5gBXp0pIe36qN19DTWxACbk6j9vp87e5PH2NXIIgby4
         qmooxF2d0Ob0WnJVTW1azWvvBbB0SX2xPPG89rctGD8qa+yeMOvRWsA9mrIZXswje06a
         By2Ue/aQWz5OrLisd6Ufn8qApJx5vJ0WwtB/PaactzjiJWFGUbHl9R29YHaYB27Bt7VC
         3KWw==
X-Forwarded-Encrypted: i=1; AJvYcCWLCC7Ly3VVb2WfXt8Zu1PMU30myVTFPwt5Yo10gUWpaHtVyGCdKDqkKHmdB+ZWDZAvN9HgImeJRA==@kvack.org
X-Gm-Message-State: AOJu0Yz2bC2d4FZ+DS2u890BGMRokh2G4rYdwTEV+LtOlzDtD3IQ9ADc
	Uj+NyDTSVM/xe8mOZy4DFiyYRsNu9Q1JgUIHlVJR+RvGD3QXoYGoj0S/NYkHDJwwJ3U=
X-Gm-Gg: ASbGncvaNAtswcype33EH8LQbk5R50RZ31YjYQUPC+JMZgcwulG6Fjo4QfCivCFwjBd
	oneFX7vLlTYkJKjuIiSVQUiDzCJBlljbnPStfnh7lQ5o+o+cmgXnWdkoFsb58pplVarv8/kNlKG
	HBVhKcdWFaRdEr3l6RcFqnp2kBSHfvM2SRvbNVDVx6OLSNLO80pDvskX8oPkAb2NV+Fm67PL/w8
	WfS5bMJ2sScujkwFWJqyKscSBHK1WWvdNV/LbAqN1uaHTXnftonvWsRiP5HgGdT3O6xgesTaAoW
	9BaKSLt3opHVmrcDZwi35bitUPnwBb0MgWkVEZ6KccPjgDRzzqpmw3f82VqruLkiVYseaQdYWnz
	4UBdX/BTZs8uUvR/Q6H86LZfOSa8m/dDTZxSrhP290ryLhlXbiZhT0tUOfQSCHRY0XXKD89oaVN
	CF4m7JhRLoA6p4RbrMP8OxTheGp4jQ4xrBD8RuVKhGuc5jf524m7adZ0NnRzg=
X-Google-Smtp-Source: AGHT+IE/iLPq0l1+7yrz/BbyhVyC9k5N0OQCI/Q9HFSHISzKMdQEsDIOj6nKXRkCdZrjDczCxThRnw==
X-Received: by 2002:a05:620a:178c:b0:892:eb85:53cd with SMTP id af79cd13be357-892eb855743mr2482012485a.42.1761333131934;
        Fri, 24 Oct 2025 12:12:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eb805e0869sm40330861cf.1.2025.10.24.12.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:12:11 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:12:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EB66120010
X-Rspamd-Server: rspam03
X-Stat-Signature: izxtttjhci6jtk5zohhjq9ca489ad4pa
X-HE-Tag: 1761333135-902854
X-HE-Meta: U2FsdGVkX18JpLsmvUqcI7D26gimykDfsq/6E1oqU7xqNQMv4pMGPP9EAFWvrJ8ijD0noCJrZ4W6kvFd+s0Q8uQIySpdjVXvc5Q3gca2T7SZvzjo01BuNfIVdFJ8P2FdmURGYoE2dbSk4I4GIbSFTGUABJSaFVhDbFKsY1+MuHdVIE5TVCPCg7lrVLAJ1jTOF+3q2KXF7Vp51axUp+qG9uBfboz2EB+fxJMRA7zIssA/bqtC9/fFPHpSxlZB9uf75FuPMMpS2vXlCGH+DH2T5h6CzfFR4rL7n/Orb8/EW+zhilY5aIWOrrWu2xLVpKu2KmreBSaHokD3fSC1CC/DY3XQt9g0S0x7CSof9rNRQd7D4RNWf02U9CNvIM/lfMA+RU8morRXesNbFqLFEvNA72cawfDoSObbdTlWs7fc51ObOchovs9WHxOiQviL60/My067owLUQdtZaosX0pIEzzHai04ksLegaLwcJfQyaIInNT0xhgUfu+a9fRhHrkUMkbTKCIBUW6aM3kDExj0TVcNYMdaOZp8CybiU9td/bOd/9ar5vXbXvYCy/y/XwAUGu7D9d8QD2siRLijGG1P7UXaGSmdhcFTpSkr2KzU+QDriY8qi0eJua0lpd8kwBLEs4BDHSg0tBrQzj9wc1PioRJqOAGL5Md7oP5ozBZOvOwtXVozpj0NsRLBjA+ihuIogsBLeKGrXX2APoOsjKcW+wZk9nl3O/qoUbkGDuGEPvhbv3b32LhLfG+NTEetdqUZDCyMJjeKwizXnxWnx4KxAM1zikTcWvckCNc62S4bQxCXVfe3tyHqpxxIvHMI3+V0bxb2N2iP2O64Mgp8jc71XFEEZz610/xlpo2W8lFPxAhe4Z7hmo/dDQz6mmnZ8ohvxybnL0MOV7OLsAqtbCZUjhk1b+37yCLs8sYRbY4CBcG0eEeWQTuQfDG9kGHI3kimshWC2Prc9AMygTN2+SPs
 hshzd3Qo
 bF9L3iwf6XpWRh5KpdxCWeZV7J5uUGvt/0eB8n09WzZRKNxQZYSi/a35EzbofDG4jQKkdrpiGLzYBWXr5VsF+VibV8t9roRnzNmKmwbdmFUw0x++kKfqcWtXg215/e4vpK6d6813o76FqKrMUNhhB7JFzWXrQZh4aEInRAJD+AsN1Ro+2b9qpFdAsFKprcJDFEL+cA6ZA6vJQnhaMMCZ+WdErpcAxLHp46DfT9YmtMofGO+7cL5dyo9YHpkcA0jBczBTeoZGhaXzD1g4S5JoSVuw27ES3aohz19shkURSt9XgAkEuq32ZWLmJ/hFgBOQP/p1/OCVH8JdBCsNCjAI8v2CRjiXfsJrTFVTbbW3m/NRwPdaif1wJCYJXNohOprlHQfgkVg+R44rKvCOZoAh8GPyY92BY3ALviBsenQiH7RzTHXPmQ1L7YyAqNFM/I0Ha6X9I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 07:19:11PM +0100, Lorenzo Stoakes wrote:
> On Fri, Oct 24, 2025 at 01:32:29PM -0400, Gregory Price wrote:
> 
> A next step will be to at least rename swp_entry_t to something else, because
> every last remnant of this 'swap entries but not really' needs to be dealt
> with...
>

hah, was just complaining about this on the other patch.

ptleaf_entry_t?

:shrug:

keep fighting the good fight
~Gregory

