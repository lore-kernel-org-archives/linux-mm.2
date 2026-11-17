Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447FA606A89E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=kPTkcJUi
Received: by kanga.kvack.org (Postfix)
	id 5E1196B05BE; Tue, 17 Nov 2026 03:34:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591F66B05BF; Tue, 17 Nov 2026 03:34:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432F86B05C0; Tue, 17 Nov 2026 03:34:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12CEC6B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:34:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97FFE16036A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:34:14 +0000 (UTC)
X-FDA: 85443948828.10.4592B43
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD5DB1C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:34:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kPTkcJUi;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlfPsRE+i3fF5U75sAmCvXCcdyZhOwjsZrTZwssWtpI=;
	b=o9r2m+hM09ZNN0uLciSnTSQoejjvxTqbAKV3REQ+7x91wxxD2vOPFndHjLwricxCD4W6Fx
	u3QeAvCROwZ7ZlvSbCGTSjffv7F7hYGin5xkEo1DztyTkdMpZXTSU1Py620eeNu3C/h8kk
	ID5rzBGFQTWuyJ2RW5NbRu1r2eEWDwg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kPTkcJUi;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904452;
	b=L2otsayimH6oUqlX91z1j4o9qski5Xgvsq15EAG8z/NXT85hcc0oFsgMzuB2eFrwDezoZ+
	qlN1FsvguU70xdz84kb7OvlhKgmry0xvIkWMlvbZRBNbOsSF6ifKHfm9AakCkgBim6c6u/
	kEkuVjKF0Ajg4O/N2fJhN0gfdZWS8fM=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5363c8de563so55807531cf.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794904452; x=1795509252; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GlfPsRE+i3fF5U75sAmCvXCcdyZhOwjsZrTZwssWtpI=;
        b=kPTkcJUiJowYfvwg80rWPj26It6o45wUcCv4hTdHk9XQFdrwT9OYAHfmFFHo7wfnbW
         3hKZbEq7Ucju4yZhBuXlhZW8rGCWPQeIEw19TAtA33AU1mlIva91eLLFoVtk187Ow7mE
         HuvNusmalJfN2SzSDoaf8XB3GnxASsDj3YakeWDTmk3++c2wB/86tG7cBLyj3PB7MJy5
         bYgFG9y51so217v8Co/ZfZwfuBn2uU4/Xqgb1vB3R10TBoyQ+95RukYCGf9pNZasRhss
         Np8tHxRFwcG4RfsSHG3epEs6/8CDIZhSS5M8GYp1RvJhORz2I2eoJf0XNQ+tuR7A9iHG
         45Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904452; x=1795509252;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GlfPsRE+i3fF5U75sAmCvXCcdyZhOwjsZrTZwssWtpI=;
        b=vuL4QCBKYPXSwoPmyuJ/5aItn1frrANHMs0PzyqK71uPtdjcmD3/nPG9o7ZTNHU61t
         KjlCJaUt9URbgyTmDkK+Q5BUSmc3/obHo/MKjTI2mttg8TPNkSX9QjeWX6q9IZgKe9hg
         tVM2nCo6kKN/eXVxbvxfyCfN2QSIIldqBVc/YfZWhoRjnlTP5WIk5jsT7SoW9Az31fMM
         7gTa7o09qpKL6xjHu/cgAZOcE0hhy7k4jygpjWlIM/FVLQyrXgeZxllxgTd4r5yGmNIx
         Zxb+OGYx/9hzkr2Q3qMWTmi6mU/SSFQ4GIsPci2Sx/B4lyWayKhPp/c9pm32SRJC/Rfq
         kBlg==
X-Forwarded-Encrypted: i=1; AL+hErEkXIjfvgty15wqEg9utsOGYl+xY0SPoT6rOfjM3srJDFOIGforQtutTTNmzj7Fs93rVnV/GqjBqg==@kvack.org
X-Gm-Message-State: APuU4Z9RKY2/0VV45z+p8HHKyagOXtbMYY0gttOUSmYAvfst/pu+R9VV
	IuMwB4sO+OK/nUujHMrV7q9nmqGxh0pFzgOQCxcIXD56uJWtcR2SI3UgJMHQ+Jacdrw=
X-Gm-Gg: AYBFou2+pFK1ZXZQGRClMf8P/rnRtjfxi65KnOcbnuVjs2k32iXBWWl0dIV6tcwOm6l
	a4XGr4SY3/YczeToJghLVeR+TaEYXdXk/tmZMay8Xr0WEZSiGInXTw9+6JFfl270ZNG+1eRyLhP
	KL7uiCTB9jCnMgC+b7EazHWYEdf7QGM7SWDIkaOWSI6u+v9Pm3BtAvzcwV/rOe+Q06htku69SgY
	WCTgmjYAo+TPZOzhgCfAV6a50UFzgBhxPoxkflpSa4zgD6F9U3lJ4DNXzobcs9PXd7eD11PN6rf
	XEhxiStWGxSarpZbxw3voVJP+B3BuG6AhYeyFjbWAB4529TL1NcYxhVr5i11axxl9RQcrkTeDHx
	AILaqLmvkQAE/cNO0c/C9EAO9wIcU7YbM4uR/MXraN1fpcTFNXXACGvVnltK3fV0kD48Th6d1Lt
	PQFwmcdyAMp0eRvhVPu5+HpF5w4LFy4AaRNd3nPrR7P0y5NvyCV2rEvUNyS+Q3qF5vtTAWU3c7K
	+wbSULeaZnvuu2psPdlh/TXGU9MI0VZWuhoMUWz4FnPPmych4ZBF+HK9JfIOaVzziDLWS2UQ+d5
	iTi84kA+xwvCm41Il5BUiUCVv2PlTQTXMqEGnHSSaU/vSt6QmAm7cxKSYETN6gKAWAQkXskRsq9
	aLgR/Xag=
X-Received: by 2002:a05:622a:654:b0:55c:b6e8:bb92 with SMTP id d75a77b69052e-55cb6e8c1e8mr144922231cf.61.1794904451796;
        Tue, 17 Nov 2026 00:34:11 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ace15ce7csm100171991cf.1.2026.11.17.00.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:34:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 09/15] mm/memfd: recheck the page cache before
 allocating a hugetlb folio
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261116-fixes_hugetlb-v2-9-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-9-4dd9e94ea9ac@kernel.org>
Date: Tue, 17 Nov 2026 03:34:09 -0500
Message-Id: <179490444979.482102.6690559604747930966.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: AD5DB1C0008
X-Stat-Signature: srkups1p3o11djqj6ctxey8xeucf81pk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794904452-321946
X-HE-Meta: U2FsdGVkX1/9UjPuYnARkqKKht6gBBp29+T1w2HLcSN2v11gtkkpL8KzsH3f8OntmKVbamagygfQahECJq4FmA6BnLrNuydzvMUQpgFTNRN9PRyGwen23T2UODh3RkxLJ3yt39ZaYJPrsvoGIXTVfmDS9efZNY838isPWwuS5W4Y03NnPTekMLbhIaijnh2pc61oMuTakdmWage+oofpTfIhfSnvXqN5w+1FPg87WUK0C3H0XtYiXjHjsrXmu8GueG5Kg+Bt26McJ/mwmSGzbN3dKRfxjC0qB+e6MaViRUkhPDYRXeAZ2wE5eTFe/fXRuTP7CJkCQ79rgHz06IaF3vdXzbUomRZo10B3YyOOyPQB9ta5iMq9QhN6D1U7/zkiucVv6b5P5u1L/gWLj36BhoqC9U8nRO8STEzbf2ygOhkFbcwErFmlXvTP1pSaBbq872DYI4m+2iKfe+kT/bNJDLQIXkDH4yFk339LxM7S8bNoSNZlywvhWDxx+N/prX+GKAh9g9oKyOb7fJwbVT99TJjCj3S8vQg75sOU9VtNemyS5tKXMyxuoJDIvwH4XUkL1epr4gzJO5HgnjDKyAogMNuOeqtcxeY0K7FvenyqvBzN+8oqlQs7A1taGMZOwGG3mcfWUcqlY2SpFEZlZF/eQxlz65GzsT+nNBfFR3/6+zDkLv2bi1KNNSH1s6pjRJnu6AAwb50WBNvwO178/G6vEA9Psn9zWXQNrBuY761FlnSQJjsMjrbJs6sweHwb5HemvljH7gXPcHosAZMrjEseJvGch9Yt7ZL1Cnlybop3eRU9K4QE+veFK7Luh8OPkG/wOVvs45+0jWY5cA3y+Cyi5atBiZROmJ6VbG8B7dax7dTARi53VryoUyDKixoMy9Yb/T/tn2jQgn5ngrvL24IqgJ7w67UwXouAWT2ufXRP9KmD5alRtRAy1oOoVZ337tZxcm5sps/Tnp6Igktujwm
 6vsBHsL9
 DwtWjC3kQuRdfGlHWFOAZ/Vpw0uUiYv/+cftdjVKSOzIivRGp7VVnLkooOKSKqvnEFp8X2EczpC2deC2XLGUrVdTQoi02MCqgmofRzX9HZuURplLgjnPaxXElMLmwOBe9RQhtcuimJ3QbhOL6Mm4g8uIXjVzD6gPdlLZNcES1n7BJkEQuLtRSbOxEkZQ0zPPBgw7fEUI9QxuN1tnF6eVQsFYYCqKxoKvXFgl/FmGXcEHTt0hVhbOBlotIbWbTgLXKgunlKA71HamBLNnkU9KloaoGg8fk3zjTg2fU74OK/k1+CYZEeNwgqP+lTPJ2voCYxFBAHfcK8vPpnPfciy11YdgSzMRG7uMX6q2PxvvI1vtDkWXeOOLPfTmfEHBXQE2OgR9s4z6ugN/UN4vjAk+T1NuQ4hH1P/FD6Ivqv7rWCceVji1mREYqWgxprLs+xt26J/RuLRgN2U978k5uIfzmfuq2ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 19:29 +0100, David Hildenbrand (Arm) wrote:
> A concurrent fault or PIN request can populate the page cache
> after memfd_pin_folios() misses it in the page cache but before
> memfd_alloc_folio() takes the fault mutex. The latter still tries to
> allocate another folio and can return -ENOMEM even though the requested
> folio is already cached.
> 
> In particular, hugetlb_reserve_pages() finds the existing reservation-map
> entry and reserves nothing. If no global reservations remain,
> alloc_hugetlb_folio_reserve() fails even when the pool has free pages,
> effectively failing memfd_pin_folios().
> 
> Recheck the page cache before reserving or allocating. If the folio is
> present, drop the lookup reference and return -EEXIST so
> memfd_pin_folios() retries its lookup.
> 
> This is probably not worth backporting to stable.
> 
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced using udmabuf to race and generated very consistent failures.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


