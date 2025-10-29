Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0039DCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270F58E0105; Wed, 29 Oct 2025 17:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2211F8E00B2; Wed, 29 Oct 2025 17:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9638E0105; Wed, 29 Oct 2025 17:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE5BF8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:23:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C24C12AFED
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:23:45 +0000 (UTC)
X-FDA: 84052428810.29.E0AF3ED
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9ED432000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:23:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gFe8y3QW;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761773023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRjtLU1r2HfZv4PRAYf6oYIopT/Rmxw6gRmhQBXOWjA=;
	b=7pRGn1Jl+6lYb4HtyTVSIn1HtdCQlLfZQyvK+mWhxrfUQ/H1FEw2RZKHWPtXE1Q97DVYvr
	V8eXkIdhX0e5I6FFUXHrnyIeHB2mdNflAul0rgQolEoPm7s2pUt0O8ZXbKAeNqaamOsMiw
	3KA6BAiEd1zErEdROf0j1CbkBOdNXKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761773023; a=rsa-sha256;
	cv=none;
	b=cf8cl467bDe8r8aLkyk+bIPqTlUOlkf3N01XXhMMhns2m0UpAZnNevNokHXoY7jC7Xm8si
	vzpdz2f23FPuFaCYFUo8ElerEwyFL07NA/Zo1TswM6YbQNWuH84fwewc/a/uJzeHeZSb70
	6SQjIAswTAN65dAnzl1t6RyVwu85FuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gFe8y3QW;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-89f54569415so31776385a.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761773023; x=1762377823; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRjtLU1r2HfZv4PRAYf6oYIopT/Rmxw6gRmhQBXOWjA=;
        b=gFe8y3QWfrGyOM/xORkNuc7Ft8sdpQa34moe33x299hnMqXPzk+vcHd3J6ZILSdx51
         LiWm8D/9b9oL1N9w2pX0Zrnjf+QjUMFscff7SPxM+jxnjsUgelWUMwp8QiCXoB5+NXQq
         zN1foVWNYHCHbNUnD8cKMJQg87lvfJEGsEEI19Lr+AfW66Y9NPEuqztp6m7v5HdNXjeU
         t8RDnfGB3trW8jeQBOyaZcLeFaMIWLv36GSq3rsh2Pt/olpYny3deqllWeQT8ZrNPFOt
         mPaUzJ2owMSGCekKfCMohj9nhoPQVT2gMqHU2GAI8XbfFh6+EHZE3IDGc8IEd9fok70t
         g06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761773023; x=1762377823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRjtLU1r2HfZv4PRAYf6oYIopT/Rmxw6gRmhQBXOWjA=;
        b=Dsp+C/MhU/nJSeCZgxVToqTRw08grcRg7JiJbRkipjDthjdC5zfUohi/M8T1RVVLMy
         XxXNetSXgqOkMPpt33987sdelhEkcWl8RVVOKygEjTfvExM0G1fyNAM+gQe1RcbX459c
         tU3ZYQwhcXwnicsqLmPRd8A/U9PzC6XCpBAOf+2sMR6NFVvtEz/CowWuIkkDsC8WU2D6
         GX83DBGS+7f7yRe+XCM5xEE2u///HymHsWyonRmIMrHq930h0hjwAmvyiEg1v9AgqLPB
         SwUWPdBlq2mZjlBn9efEvbKBDCDJ0+EebiVc48TnLCR9q1LBw7NxKyagtHVyrBCsZizq
         mPWw==
X-Forwarded-Encrypted: i=1; AJvYcCXil8MfB7wj2o7EKNyclTko98kJMNaq1ED4CakKOU3VvLD3KHKUEAcqOh9zM1Wcq4JNiJxsvsJG2Q==@kvack.org
X-Gm-Message-State: AOJu0YxhZnjXrrdk6Yat4pn4p1U8RTLJFdxnV+Ft2XbhGncRtflD9bkN
	uapaqI8wH4nO/pAMV3gdBIjovHBIJWXaAVYtBV0Kzr9WiTEmqkWRysFVCYPPV8u/hbU=
X-Gm-Gg: ASbGncuFqb6G7W+sMnR/bqzgEn//GhxXFUkPhQAGbdJDKLkqbx6co6PyAqIaWeJnV32
	plTc+fdq8vAuCySKSUBve9i6TI2+lnapuG2iVcOTl/htFPfxelYOG720sGXPOs8c7QM+uveca4g
	39aova2Pe4uSNodDrbsTdGSaTmKrZLhuYkDBNfcNBI2GR4NaHF69b4ticsfwpQVtPwJaA6fYJ0O
	HCJyzs++u/rkOQlzNNjVUY5AzLLbYxVlhKeHzIGzGvIUIb3QNlSFQMPOZYTFyrTT3R7yCQXC9n6
	djmXpPzFUDLfM0KVh6PAfe75Vv2DJNqK2m8bD6ar1YLJXTo5D4qtxsXd25eeGJdn/BZlPsWwjvx
	8TJWjVhipqtH/8dmpzEX99pyfTYFqdaXjFjdzxJHMCoyWu2pXme1/yTq6HjmT3n/fIQwavD166s
	MBM3WYPEh2LDn4nuhEU0SrXurNDvHAMiDCehv64J8q2jCWWxhCKH5BaF06ZfQ=
X-Google-Smtp-Source: AGHT+IHIvemppeW4VU2bcQtfcjjrB/a+ZhJ9fpfDcYpqh7YEbBY+IwMLRkdQTC8NbNXnWXScRwyJQw==
X-Received: by 2002:a05:620a:29c4:b0:82e:ce61:f840 with SMTP id af79cd13be357-8aa2ea07948mr164184685a.84.1761773022583;
        Wed, 29 Oct 2025 14:23:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421fc6fsm1114391785a.9.2025.10.29.14.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 14:23:42 -0700 (PDT)
Date: Wed, 29 Oct 2025 17:23:39 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <aQKF2y7YI9SUBLKo@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
 <20251028124817.GH760669@ziepe.ca>
 <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
 <20251029141048.GN760669@ziepe.ca>
 <4fd565b5-1540-40bc-9cbb-29724f93a4d2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd565b5-1540-40bc-9cbb-29724f93a4d2@lucifer.local>
X-Rspamd-Server: rspam05
X-Stat-Signature: krz4uagbmqf1exs8knc1ewpsoasoosie
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ED432000C
X-HE-Tag: 1761773023-674712
X-HE-Meta: U2FsdGVkX1/GA1fbpXwh6uhKpSJKGkAJzexr3jTUUusPLp0aq4k8gHAmoC0zIMitxEIOWC4eOG9V++MBHyfg6R0UUe+UZr3EbqWTl0V6h3FVf4BoUONM60nyNYcnHSn6JR6hIqB5ghDHm1Kq6a11qcyj1rEAkUYKBMDncw5PAVziCQzCLRYuJbHKkpd6tlc5CBD+x0hNzeuekl4yuKLlfbsiWgjUTE8rZPZ7nbxFGCYIzB1PLMR9lmREcZ3iQ0XXOiKfi2C5Y7Fh7uf5DSGzBhrTCKJMI1DO6mRqMYOwMiVrS/goryDPaI4QNllChLyiDDT9Dm/TWyHrDS0cpBI2szqI4yYGAq5s8MfBiVxI674Y+yF0nF81pz9LjJUATcammhcO+0kBQ4HHBVO3nHVs0Kzl7J4rJfeaS2TbWEAFO9Zdp8sARq518w7j5Y6JPExFG5nxlNcxsJI9lUmgcDMfeZUnYlYVaJQ1hcB4ZewMxEToxDHQ9zpSB5WCgg1x+EVUULc9lMUngsG7IV1b062+g0gD5TbwxPKKRHKk7XWAownaKGGwkMfobW08ZtraB7RHbtv8mSszbJUujxPNWkKwPsY6ThClOdGIjiHm/MqIC+pkm+be5DLoQW+DXuJQT6D5N8K1V8Ju71ApDHE1qe9ZlgToYfk9z0qYpPhAx/lE2ovtnni9In81+QQgMAqJ3BxrJuU87/jTjRFcWlRFJnR87PJvnpHPXTaK8rX/Ab7I1M8H/hExwRXMX/NrCu3ECdASIbC7nP5PuYjP+2Y68c2t7DrQR1JSnlOUOkuDv8EFrh1EbaASDAUMBnSFLprN1Dy20Pgwd4DZbc1IQlhloM0HGbS+Xa03+VcCzhiiBwZknAYScviZMvAMWREL0psvbGP+/nkdwO6OPtwvfv5UNmUSEAUTpnoSr67QLRITrltHm4BYt6SUZjhkgSQ2PLaSbKJfA3zFGK26JeHstrsVeON
 P+8AfQOW
 5HBfQFFiEkK/hYvO5Vkz5VsMiDDsEEu2EI2ahMU0RSsNyXjR7A5NYWaJG8bPSLchDPdYsbjlbnDqN0T/tMIiyC3jJ94rEmxCkSUHiQ46xjVN70Bv97PzdS7xqeLdr2cg5kePURKcPOvdMsX24ijbV7Aj5UwX/FEPeQeG1a5/MEHML7JyLdWFIYNAa2QQ2bCFx/560YwIa2KZz8/3WgyOKctaASAM/eT5wSJOevBHoesbaC3UI4hUaCfRpVQu1g1/HO6lTCE5ofkaeb4k2fAqSswh8cnK+J1W2AtecEZ/6YYCYca/eIbJlXwI/lv4z4UTuBR1NyS46ONgg9/w01EnmgrSsMho+3AEJ8k9y6q0ambkOxbxU0ftJW8VgLahZjsuHr5LktJae0XRL8zwU/rW1zYmgTT03P89faJQfQBNKl06pafHcV9LYEe9GelDYWD6bPYMR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:09:59PM +0000, Lorenzo Stoakes wrote:
> >
> > pmd_is_leaf_or_leafent()
> >
> > In the PTE API we are calling present entries that are address, not
> > tables, leafs.
> 
> Hmm I think pmd_is_present_or_leafent() is clearer actually on second
> thoughts :)
> 

apologies if misunderstanding, but I like short names :]

#define pmd_exists(entry) (pmd_is_present() || pmd_is_leafent())

If you care about what that entry is, you'll have to spell out these
checks in your code anyway, so no need to explode the naming to include
everything that might be there.

~Gregory

