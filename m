Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35B3C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C208E003B; Mon, 11 Aug 2025 07:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3716B014E; Mon, 11 Aug 2025 07:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9FB8E003B; Mon, 11 Aug 2025 07:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3526B014D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 735A5140138
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:40 +0000 (UTC)
X-FDA: 83764248960.10.53DE719
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 093AF1C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9N4yw0q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911598; a=rsa-sha256;
	cv=none;
	b=v4MfiqAa8FUAq/x1YNVewiMYcykgXrwL6wcTTBLidiHHpbMr8qSQ1ENrqB/9+OgprxKMq1
	Lma5fJKc47cvj31Bub7Oi0z4qNlCrP37y+NSDZPO+98A9UN+/2nx3/PWmgUyVZ0Awu2QNI
	2vg+m0mjvnlv19+PbXP0idSxIZOjvbI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9N4yw0q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gjYKWewbFPIH0RV/ky7WxO7hTalH23xVuPMUQKkA/fk=;
	b=Cemr2v9B3oCFVQTzoCVk9L7XxRlzL1Feqx/ZFNxPgk1tpWu2Rm4sijb7iz49eW4Wot4n8l
	aoVMj5J12Wed3XhlvrVsxLAJ7vtOe4zzT+8Ly77Qp3dN2mFl03S2rPlk5MK9A0ozMD0zc8
	GKRsQb+pIDknkyECnBTFpHgKUoB5zmE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gjYKWewbFPIH0RV/ky7WxO7hTalH23xVuPMUQKkA/fk=;
	b=b9N4yw0qMi0C8VmE0T8CzhuELAtoRudiBaBzoe2QxuU0jGyQZeVcsguuEgSKWiNTzYZlmD
	Qqbex8QzN7gqvjsJMa1MbWNJJr0hHw1MEWUxVgVlR8Fn/+nFpClSj6NhO3CuAgGkWx+0UA
	FR0tB7Bn/9Vw2hKooJuAhpDPIVgwpUo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-W4D17VTRPu-cpkIyHOtdcw-1; Mon, 11 Aug 2025 07:26:36 -0400
X-MC-Unique: W4D17VTRPu-cpkIyHOtdcw-1
X-Mimecast-MFC-AGG-ID: W4D17VTRPu-cpkIyHOtdcw_1754911595
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b78329f180so2068218f8f.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911595; x=1755516395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjYKWewbFPIH0RV/ky7WxO7hTalH23xVuPMUQKkA/fk=;
        b=KgplusmH8QVX2BJ0Ddd4eq887UvBzRi/ISXSZ1xYIRP4raQ0So+PhGcAlORwTYr9th
         YBY7E4SFFu+tTVZyaWAkYZKTBTiw4mUxu7K93hOlVjydVMZJ8K7xJlBKV98GoSu7X1dr
         LF6sdQY9zr00tTre4KYeXXifqCQcnNsp0KvDABTMNbuTZsNqlejLsoGKFnVAk9wZZDh3
         jIhVfGJioj1F8eNTzaVs6uD/8UuqqpmJqbSp+P/tIkq1ts7XBHHkK9NEp+vTeS/TIm6N
         WeWTWpw1uSR3w4biH38XRWhgMl3THDvEANnc4Cluq4cyv0j9t12ugYfrWELVx0UeKFKM
         ZnZQ==
X-Gm-Message-State: AOJu0YxyECIujLBcMdMgAA+IxmjY271miRKJAQnnZ5fwfNJL4mkS6Et9
	V9OqDKlTEmYLBWnqNv0/Bv3alrepH1oT5jdLahKnaOgKVVUUzwRDN5VzZwDfGaaxMilGBlIWOA+
	NuS2jsWbt5QpOSPGN/3hiYirLyEWYbAeaJfXnZUUN7W5O7PY2p8uC
X-Gm-Gg: ASbGncvlvX7IXx9mt5yPhUEuFP2zaj4SuNs26j7itKRkvAunjAENNZHvfRV0T0OY9RH
	TKjrGcTW6yiINIkVFMNZG/9U5TW9SOK+x0ctOnpm+YAHKtw8sPxJ/X/2g9Z8dgdEbx16eHLO7q6
	Dqrq99i+teow7tTtVjlgq08W0eFRduSxQgpRCX0oz/3+J2BIMv/gwj8aOlkRWioao4ExiVHvVH1
	A97v01wNdFEv/GVA0SO0BI66IsKiW4dNxvOL15EF5rBXLeRUVb9lpjfc3NJo5VPyj5V5keoMa3N
	ttmvsuYIWaoGfFhOY7ZhBj37SBWu6PsWdbUE4S5MusNFlNkEmPZvarllIXpCYztfT1iwTM8NYwH
	zErWwNqZhRGfn6hGdwk2rw8il
X-Received: by 2002:a05:6000:2f85:b0:3b7:8d70:e0ad with SMTP id ffacd0b85a97d-3b900b4d8c1mr8490203f8f.32.1754911594925;
        Mon, 11 Aug 2025 04:26:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdQyxmL2k0hEit4q6ggWaLK63vDyy/XYp/bptTEvLLiDZ4Kssrq6afY7SHtzCWpxX9HX5tXQ==
X-Received: by 2002:a05:6000:2f85:b0:3b7:8d70:e0ad with SMTP id ffacd0b85a97d-3b900b4d8c1mr8490151f8f.32.1754911594303;
        Mon, 11 Aug 2025 04:26:34 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3c4beasm39217323f8f.30.2025.08.11.04.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:33 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 00/11] mm: vm_normal_page*() improvements
Date: Mon, 11 Aug 2025 13:26:20 +0200
Message-ID: <20250811112631.759341-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5anFRTM_Dy_4_GUB9AiHaEyMuim26VXqrz2lcF8jDUY_1754911595
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 093AF1C0003
X-Stat-Signature: zkmhjqbf8hojotzugn4keqxrnuj4o9dz
X-HE-Tag: 1754911597-508324
X-HE-Meta: U2FsdGVkX1/OuhNsUGLbWvtSduvfLGKT2K1qMGKXyMUlmjG+aLSPs85tfD5coHr/dKw2itZzYvOLwfFSGSECHh6pnY+5LI73oY9Hul3lhl55zfL2YQ0DrRjKiVeBwgVYgPzxVGoIWU5/NKM7ti1sJs/AZ28F+XhrCUNgrTJpPuYSnv90xCsdFnrKPCsZKzKJOuveId6NeoDOWTkpVbg5NI3Wk6mxpa5IuA6S9avcbpPnav7hvNmvUxTmACa9z0/uMmLQ7IEljc0dJb545R4F1kNPYYZku2adTdDuBJfbI1/tQZLwsyC85NTIBPKNfmF1XyEc4rG63TjctX2tgjOST8BjOSL+6IDCSlbAjp9+ICcQtaLX78B47IU0jwdwFIsyAxU7HeNWru/CJd22B7jdA+/8B9zs/9WKriT+bKVmlCuF8BlSc13YxNyfWh2JJm4RNGh/42rq0yU2yPUEMJxdgBZKTyKYjwAhD6UAQXV0eh7RfbflMvmQLxJTOz6PF/UqS4BrbeOer+5H1ljtuLjSI7FwgUYoNwmouHDYuGE94jwuZldtvEHbtBoIvbRXZcJ0QBbepMZvBYpkvcpVDhCJYbbk1atpicp6q5KtofKJaaCWyXfJpFMmoDTvhm4zt1B6i+ITzrzBMpFvYG2Bj81Bh3i/zykbR0kNIAvBMedT5wEXXys4Ntp7xeIoFoBApxB7+OB2De0p6SHdvYkh5wlJEnxzMqogj04kOBL3qUGCyPVbdmhjjDiEfiB6M1RE4qEwTw6Iwoh5b8tjiSjVubPa77T22KF34ElukDs/w277A/0Nx4yB/oLGIxzlS5WcxTiF5jgXnruFCKVIxtkXQknzX4VrAaaJarikKVm960MEoZOxUHdM/aCmZxVz5Bj4+djlE+WqLZRb8MlRLWZtrMjWRh/qhwYgW2elTSI8225jQObRGAifyW1Sf7Yfw0aDNtc4yf3iM9nIeGZAis4cLtA
 jkRShFLP
 mjvsK/VzJ5dO0FFrWgTkwYl9s1nbFjx1bHvUwPx6ENXg/UG61tBst4is3mgDY37CZ9d94SXGqUiaFTZOx8O8AFMVjRvdutBi+yB8UD2PIuvxLG54PxQJ6cco4WQXY6uV4EPaAKqvDd01dJLJuduFZ2APU9bgevh7bQBbE6pKiJp0XO5NTKtLpoZZn06LEq/Sr5UZ4bbYawpJEYhMvsY/rhwjnvZbeBTGNglc5ktgQFXs4InCXR6c83+DIFfqe6ibSUoweLKf66k4pPHnAMGMRxlhNJsLvybae3hDqbxcUjz/5GKPL/wGfattLQBPOH/8M2Wn+6o1uvqvLpxFeDxbfBvsO/FYaVTai2b7mspMxMwjH6DBgO/VRb4sdWFn3D6yLFbyoN5Llydmms68IQs2i7N4wFiDq3f+ojZm0/7QY8YeRrvFusjOuEaLl1qDtgeH6BvGCyOv5BDUtUOzZdYFe5IOwpOI/0qzA0qGJTqA3I5J67fXBn3fG+XzaK89/TUXUu/oNZPZv9MN98gvIhwpnyXobz0SJMBHTVwt7tFh8BlhyJZdImkD0y8tvY37WSP1Z13AyyjRXBB0zan8nRv0CBQibPZKVD0CwWa8A022HINb4QvRBQ2zACUWOqhqqQUeWiobQKcftnk8YnHddCppR6Y1TuSDwOYqkrhVM3Ket68e+rSg/waiibyhZY7V9qaj5qARNG9+XHgJT/OzNtiEMZCGcc4dMZ23rrlS+wWbsEJnPDknt9LlUn9eMm1yXpP0il6HIofWxyccMBaHu95nDG0kS9B0GWcYRh9ds0sPdyzPR0W90gyETXJWMuLR/kUsd/pTKDPehrcARUr7iMN/jLYIWDs/eMvh+r2JEaJfo/DHBN6KGr7JUxdkMuFUezrUg9pjJzOlu+MC+3DqQkOb8YyvgTo0Uhx7u1LDaODSpalPm/f6TI5mK4IOKPQlfM+cXtb3trK3sR+qO26uzaoXInUbq2RpX
 1f7IDdbW
 /fsXATZVwnf1dwXmT0pYwI8Z7l3JbjlB5T4KN9u/vxMNnVuC7L64YkRGhPK1TU/FTFPBBYyhP/XAFKnByAZSTE2clMWOzmHiqA6N+Aq1UgifyubMMFl6JTH3k9Ly6pRVRFu4fdPJCbLD5P8cy17MxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm/mm-new from today.

Cleanup and unify vm_normal_page_*() handling, also marking the
huge zerofolio as special in the PMD. Add+use vm_normal_page_pud() and
cleanup that XEN vm_ops->find_special_page thingy.

There are plans of using vm_normal_page_*() more widely soon.

Briefly tested on UML (making sure vm_normal_page() still works as expected
without pte_special() support) and on x86-64 with a bunch of tests.
Cross-compiled for a variety of weird archs.

v2 -> v3:
* "mm/huge_memory: mark PMD mappings of the huge zero folio special"
 -> Extend vm_normal_page_pmd() comment + patch description
 -> Take care of copy_huge_pmd() checking for pmd_special().
* "powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel""
 -> Added
* "mm/rmap: convert "enum rmap_level" to "enum pgtable_level""
 -> Added
* "mm/memory: convert print_bad_pte() to print_bad_page_map()"
 -> Consume level so we can keep the level indication through
    pgtable_level_to_str().
 -> Improve locking comments
* "mm/memory: factor out common code from vm_normal_page_*()"
 -> Factor everything out into __vm_normal_page() and let it consume the
    special bit + pfn (and the value+level for error reporting purposes)
 -> Improve function docs
 -> Improve patch description

v1 -> v2:
* "mm/memory: convert print_bad_pte() to print_bad_page_map()"
 -> Don't use pgdp_get(), because it's broken on some arm configs
 -> Extend patch description
 -> Don't use pmd_val(pmdp_get()), because that doesn't work on some
    m68k configs
* Added RBs

RFC -> v1:
* Dropped the highest_memmap_pfn removal stuff and instead added
  "mm/memory: convert print_bad_pte() to print_bad_page_map()"
* Dropped "mm: compare pfns only if the entry is present when inserting
  pfns/pages" for now, will probably clean that up separately.
* Dropped "mm: remove "horrible special case to handle copy-on-write
  behaviour"", and "mm: drop addr parameter from vm_normal_*_pmd()" will
  require more thought
* "mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()"
 -> Extend patch description.
* "fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio"
 -> Extend patch description.
* "mm/huge_memory: mark PMD mappings of the huge zero folio special"
 -> Remove comment from vm_normal_page_pmd().
* "mm/memory: factor out common code from vm_normal_page_*()"
 -> Adjust to print_bad_page_map()/highest_memmap_pfn changes.
 -> Add proper kernel doc to all involved functions
* "mm: introduce and use vm_normal_page_pud()"
 -> Adjust to print_bad_page_map() changes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>

David Hildenbrand (11):
  mm/huge_memory: move more common code into insert_pmd()
  mm/huge_memory: move more common code into insert_pud()
  mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
  fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
  mm/huge_memory: mark PMD mappings of the huge zero folio special
  powerpc/ptdump: rename "struct pgtable_level" to "struct
    ptdump_pglevel"
  mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
  mm/memory: convert print_bad_pte() to print_bad_page_map()
  mm/memory: factor out common code from vm_normal_page_*()
  mm: introduce and use vm_normal_page_pud()
  mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()

 arch/powerpc/mm/ptdump/8xx.c      |   2 +-
 arch/powerpc/mm/ptdump/book3s64.c |   2 +-
 arch/powerpc/mm/ptdump/ptdump.h   |   4 +-
 arch/powerpc/mm/ptdump/shared.c   |   2 +-
 drivers/xen/Kconfig               |   1 +
 drivers/xen/gntdev.c              |   5 +-
 fs/dax.c                          |  47 +----
 include/linux/mm.h                |  20 +-
 include/linux/pgtable.h           |  27 +++
 include/linux/rmap.h              |  60 +++---
 mm/Kconfig                        |   2 +
 mm/huge_memory.c                  | 122 +++++------
 mm/memory.c                       | 332 +++++++++++++++++++++---------
 mm/pagewalk.c                     |  20 +-
 mm/rmap.c                         |  56 ++---
 tools/testing/vma/vma_internal.h  |  18 +-
 16 files changed, 421 insertions(+), 299 deletions(-)


base-commit: 53c448023185717d0ed56b5546dc2be405da92ff
-- 
2.50.1


