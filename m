Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06497CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497168E00ED; Fri, 24 Oct 2025 14:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446D28E00C9; Fri, 24 Oct 2025 14:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30EB68E00ED; Fri, 24 Oct 2025 14:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE668E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:41:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A148B892D6
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:41:08 +0000 (UTC)
X-FDA: 84033875016.16.620543B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id B9656180004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:41:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RbrqiRtb;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761331266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKqOWG1gpzHwxwYl3SQC/dTHK3GeimTlZWo8wLiUVXY=;
	b=Ukbp54+AL19JvYqnBZpQBaY2olkCISTGdDx1Mdx+8onA2uu7mLm+MKosjVksxetj9gdm2A
	DKX6RKfJNuu6Kx6wl1qFRPL9zs6gLlhppf1yRf4ck5qGXUXmPHgUvkEM3t4d3yWoW5vsOi
	mVrL+rVlmuPGzyZUuaJDY7FhLvefJ9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761331266; a=rsa-sha256;
	cv=none;
	b=pvRtEbk8Gl8Lu2FWJT7VtFZchuh2Qc64gm8ier7CbCqIjBWl6/eC0jsvbKuZJY0nRA5G3W
	99xOiePM0HfGO3/RKK9vTz93E6OJTxpHYDOtGKv0VcZPmDt6u6pA+1Q2YDEJks+gfC5Nhs
	GIMHvMUbyuymIEjAnAq4Qv+RjiUgGLo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RbrqiRtb;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-88e51cf965dso315735285a.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761331266; x=1761936066; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pKqOWG1gpzHwxwYl3SQC/dTHK3GeimTlZWo8wLiUVXY=;
        b=RbrqiRtb1jlQLqAryYM7s54xVPigcvgLQ1Hn5uaK3NVRf+RMm9aUsiH9RvPfCebhX6
         h8YXZ//STzLkuUZPR9gOoj5LeuCzpXEE8rC6m25ompJCIY0KwYe87kRYne1AFpiI83fn
         XCDYxfE8+FWeN5UrTDY6wIx8B3V6V/M7f/xxszDy5oJ++z5svDjcGnGop/vNEnNjx5ND
         2YtFI6/BD0rXWBXUaV8DMRWqE8F1ftel3YmJnU3eUSPFBbRugsqUUXQtX14oTJi6pYlw
         zYbDTNfk41FHowlsNrcITRdJqldOhv8epWg1b5sWayY2j/WbWquvLIba8OMVzHiFuAF/
         Bp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761331266; x=1761936066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKqOWG1gpzHwxwYl3SQC/dTHK3GeimTlZWo8wLiUVXY=;
        b=AwDf9In0oHISUjIzOxIeG7LM6whOpaZ6Kz1QDFxyx+Vl2gZCkm9oNwM8Jj1dtlqyiM
         C+FeaTv695cx5YmQgDaugI4t2i/+qvQqaJz98hD484jzZCveqebMYfwGysmzY5ZqCoIo
         uIgg3wdcMFwrsbOOYOGAj5pBznFEcf+v56GKRjqjAT3lCvzpfV1/wF0qxF7QET54XXlR
         T9vEukk9Y8yYGu7ZGRBdlcdmMnXIUjCF1+T73Cs5ENOVc6Kj7dV/+VKrM4uOhqI+CG1b
         kVHFcV9lv+ScGGBYhnw4C9v7t5viVDgtFP5T9YT2eTkc5by61/8APnZ2dZiEQwtxwgiu
         W6Hw==
X-Forwarded-Encrypted: i=1; AJvYcCV+crUcTwbzW9esReybbSlzs7l5eivkV3YaMZsR6y0y8JIg4eOTM5ZwJusKIvnv1kPcqTPyGAPQ+g==@kvack.org
X-Gm-Message-State: AOJu0YxmAWUb948cuvhIDeKvkfevd2YF6xV6XE3egQdjNdmUG/GsRDhJ
	ds5x0xIu6viw5n3LI8xIB0GaEX0zqgtHK87pesoACzE1FrKpC88tQIzFzWfLiNOs/60=
X-Gm-Gg: ASbGncvhCSMt2nMUFwZjL3HNO83UnMF84zk+mv2bPoakAEnp3+pMnE2dpFOpNSemvZy
	bFfIJqIlEE22KfiBO6HVdn9my92NtoznDMlq/wYZrEFimfnncIiwHlHarTGqr6PJOHzfaUsehrR
	s3qG6tlz1PqixlN7uV4+2a9DDYGGIjYodjmH1pY41nwuzu56YaQbB/6quSaB7YUXIBqtLHhAYLF
	pLLhMBWYcfNN0DYEJlux7eSeEzblel60W62TTOFtgX0yL6Wl5Xw3xa5TgnREjJTvUDRfARJfTA2
	+ijg9JFAM0fpvvKLliqQWRZLB6H0d+lT7sMDYWfcxY+UqweFx2WFD3zkfGxISwMJYKuuu82Esoc
	kHVyf8IOYgfxTW/JYIca5HTPuWFv80m2gQzSSNDHZYnVGyKqmRsZbyEGQfH8BtXWZ4Bd/qiFuon
	Q2NuUVyYwEGVSczRbVTBq8iW1U15m03eNT7rjm035D6/awvfKlZ4TdIusKtUKib530cC/MzNVwx
	cw185/Q
X-Google-Smtp-Source: AGHT+IGnY4R12t5EHq14eSTeJNU2ADxULRmUNWe43hSkC8AnH74fLNRTNtzJmefk6NfxewScJ3xiIw==
X-Received: by 2002:a05:620a:190e:b0:883:5640:b0da with SMTP id af79cd13be357-8906e2cf39dmr3403918985a.3.1761331265598;
        Fri, 24 Oct 2025 11:41:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c0dbcd225sm441582885a.12.2025.10.24.11.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 11:41:05 -0700 (PDT)
Date: Fri, 24 Oct 2025 14:41:02 -0400
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
Subject: Re: [RFC PATCH 09/12] mm/huge_memory: refactor change_huge_pmd()
 non-present logic
Message-ID: <aPvIPqEfnxxQ7duJ@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: dn88dwbf6m5nu3j3kbwe58ikfazsh6jx
X-Rspam-User: 
X-Rspamd-Queue-Id: B9656180004
X-HE-Tag: 1761331266-990612
X-HE-Meta: U2FsdGVkX19zhU5/JWv0lhRzt5B2vxTVz9p7VDkylfV8dMFaTqVIdytVrnJaYtGs2T+gIRykItQJEMBulY/iTdrHlR/GOBbfSrEy92lTg+gn6qxMCgk+MzP9zhAS0u1D9tv5B++Wxv5RLSgTCPbh9008RdOoRmC4aOt6M/MHxrR8as8/mxA6oO56JkfDZsqMR+4LENE7NwTIFxxHFertLuT0Sx7tsTu1HH3JmO3Doz2eeoZBS5Un38xPWQO+3a8jdu19iDtdjchwvU1p9IHuScUvFLVC7CQyXt1z/iXwscKQ2BTTlueTzq2E1FoRh8ZvmUrdujlGwvwFd3g1UpwkHvmvh/F5NHTkCaxHaqMZJNa4UTKk7waQ7LgcT6Uh6a/y9fb/yn+oaq1ppvDWIx8KGXteVL/LB+r4w5jCOYgyP5cVgfHe8sSLrpjYzU0PB5lSg0D31VN+fohBMJqoqvmjQaJ3aSfUS+UYIDW534HEGZl67TaTYgfeZOOhqOmfB0AS+rECvdunm1oB480+/MufvUC3Fno1RjnoupmW38vFzMwywuhcvDHecUd63TrBvw3tWjBjz1EplOAhrqLPEIEKFNhzVOzvIKzW7T6Q7kwPe6Tr7Rx7RfwUZoqeSeubdAKDeguYFjMmJW29ioCqFZxUxLHn+BtW8zCUKgTQCpR1JKE1bmQUEuRUp37dXRHzCMemT8Fk0kVLfzNNLcpwCOH4H5+zprc/Y2HUVZgVccbURxbObK/PQ68ZRhMrdEowTDtsKTNd31rcRUklTDHUz0DJlFdQT6hYEdx4sUy75ZWJuLwQMqZgsJoGyd0Oe7iZ++eE+k+JNY426jxPUjax7Ja15vVJ9QiZ9eeNoEX4sbida6XpM+1X3SwVwUiXb6O7/0CjrcJJaQLT2to5lN1AM1FCUcE318r7Htwcp0/ith+vJmOPdbUv/Bxt9oKuyw3zgiDZGrEyHsUsaxFRK978sX+
 3jImtq9p
 TFHfQycEPzVTFLaMcYUEW5iYXxKG3JVyJqjmc7kwr0rOeT0ZA237ng9yh050Cp4dB1T+7uB599J7611CI2r+q+BLiLEPxZ/pv8cK4Aw8L6XqzZWzz+UKWy3Cg2dpcLJ1Z9tV6wa5NQS09ZtsmLVH4dFCFc0+pqZjeuzsYpN69j1Ib0jOHyJpD2aHrZoJb8v+5N0/Oek3MmqlKqp3INQKz/aEZo6i/BWLamgCEeriHPwwM9Bk7mYStdjPAHK92oSiIZmc4jML9xoLo8K/JlBfRT4JjGSPw282Xow+LeoPtBqXDBAQelVuRzDLkx7SQmk+aL5i9GflHkTFWQViE7AOqimIkNWNgoXdAPQZHgiFWZbciEmRdCmLGHII/ohXurmtLG9Ad2Tutket2clDT7bi08YrK+kpiYH5CVu7N3amWfdHfTJ99nJvDnDwga+vSn8nvKIWQgBDuXa1+2LxbUBs5V5C7Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:41:25AM +0100, Lorenzo Stoakes wrote:
> Similar to copy_huge_pmd(), there is a large mass of open-coded logic for
> the CONFIG_ARCH_ENABLE_THP_MIGRATION non-present entry case that does not
> use thp_migration_supported() consistently.
> 
> Resolve this by separating out this logic and introduce
> change_non_present_huge_pmd().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
--- >8

> +	if (thp_migration_supported() && is_swap_pmd(*pmd)) {
> +		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
> +					    uffd_wp_resolve);

You point out the original code doesn't have thp_migration_supported()

is this a bug? or is it benign and just leads to it failing (nicely)
deeper in the stack?

If it's a bug, maybe this patch should be pulled out ahead of the rest?

~Gregory

