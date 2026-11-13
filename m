Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F07F606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ueLo58mU
Received: by kanga.kvack.org (Postfix)
	id 74D146B0681; Fri, 13 Nov 2026 00:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725636B0682; Fri, 13 Nov 2026 00:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B1F6B0683; Fri, 13 Nov 2026 00:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B00D6B0681
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:19:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C4E31207E0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:19:07 +0000 (UTC)
X-FDA: 85428941934.07.4F73946
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 53F851C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:19:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ueLo58mU;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547145;
	b=HNKDsUlMjLOKRG+xGPrEwulNcBci0kWSppD13boumPw9wz4yqH5ehlUh7CoCsbooSEsao4
	RonaW8J5K/uVuQ9GkLzAB8mLzQwvsg7bIP0MId6qYbcT0aq5nDF0svfvJsm0KXne2sTkvS
	7+nqV1PFxPFKC8IWUMGrJEC7zTV7RYA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ueLo58mU;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZ/WoExpnJ8hrgM/hl6NJJrxD86AhGkO6OAXDjbXUhM=;
	b=R7Qf/1SMrZpNP+g6Jy6qGbPjiRTncqPml/DvXt2NnvFw6LO9nMgt7xGvs36s+RrFHYF0Ca
	pzSUAqsjEKdiVyhaA/D8g0BthMIv45btsaiwfn369jIVyZcP6vBGeiRcYVNEs6H1GI+9aJ
	JGbxvHnA2fMRVoK2o5VAjb93LHWA1Cw=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91f0274f88cso8372526d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794547144; x=1795151944; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SZ/WoExpnJ8hrgM/hl6NJJrxD86AhGkO6OAXDjbXUhM=;
        b=ueLo58mUXSE8tQ/me+YNTPUhnjyKFafYY8lmX70EEBTvfvMWSJKf4vQLJ9j3hOr+NN
         OdvAq9uYdL9PmuVMi8m6gXKyxsljhqG8VpiLsjdUzzJut/U/otleH1iVYiM2yJrdoCdz
         MI6zll5R/2TBdOB+GqE9F+KujpQfCIGu1WZw0bMbxExY7y4oxHWd+u8ZVG+4TRw3QURp
         rGeg8zJ82+egxPw5HglqEulYU9hw+oX/XRt7yf9dhtfOjmlCC1ikvG8eL3hzU7xJoWI8
         tdy9XLunesaCspWPdjHwO0CdSj5S8GAA0EhLYSQUq/rt0uNj4lrRkj8I5mlU/d/ha3R1
         BXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794547144; x=1795151944;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZ/WoExpnJ8hrgM/hl6NJJrxD86AhGkO6OAXDjbXUhM=;
        b=nvcCMH3dVRwTn/q4OjGncf4yZA52zOecmiwM3ez+tV1BoYi+5TdINoBrippgkZ/Hcf
         ssCcV4L9AWWB1Fgn8t2pJWphbuLASmdmwS2ls9YwBLm/Lm+mIiUCNnvzQ1/k0jDIrLgS
         SCCsKI8LUSHpSrZr1gbT6pZLzggWpQoOqi1KNmQoet0HiKfttUAikZWUbfDLJ8nX0iKA
         DEkKyO7rrxDJx2/C3h59aF1fAgQ3mLiPdnlvZWCj5FoTtaRbx9rKzpkrIf9ncAgghcGk
         +FfIA60cwazzAhAuYGRuYb532SWjHvA/qmjSaq9L9VPkCJzFi2mywjel5+stL4bMNZem
         Qt0Q==
X-Forwarded-Encrypted: i=1; AL+hErHOPZ6N+UbCZti1489WPkH7g7Hg0pCckoGv8hRbRFw2faWTXQpitPdhdMPMbG5i29t2JyUV5CLaow==@kvack.org
X-Gm-Message-State: APuU4Z9jyVIa/NbM2OJ7swq4Su7bPU5HWgE5jn5iBcTYttXe/ETthA5n
	MVh2+zK9eGVlTrhzsEPyUB9LcuxrO9sTq1Hzz0/Szdsax5tFmDQAA7dwiYlDQwrjFlc=
X-Gm-Gg: AYBFou3eme+qehqBfpYtuupNUN/fm6jXP/2XzI5vnsJ+mGLIFGDmXw0+muwFKioEf2e
	RsndcTcXGBA5WGiQQWgZAfM7dvMaR4GB7QKlr19eMA14i/Fduy2YUmqmVBqaO9I9T/Jt3lcj8kT
	xhnegd75guROAniHAlDNUWCZUleqIa/900+XGNwZNYViE8qznxjocYMl+cT4kSYFUOAnjD8ImM3
	lvTCYq8CEQyO+PYbBK5TAIPuGw/kBUjAhgqKmZNGqddD6gOpWHqnUHZyRdWCQ/ctdtbPiqgcPg0
	WcswHP9PMSR9VyUJxjH40dhsZnkzSoZIxP2nhES1J8wpWE5P2UGPg58RTHwwY7mQTXeUspT4BFC
	KLLkagKAwOO94ncCyqd8Dty+5Df80MltXXRlm6K4XbvN8PKbnWphfY9f4CsFjj64I08kVE4Nw9P
	moaFwheN6hWfmc4AArleL7YNfo8saYHYtv3C8DpUBu/C62XUKVuNwkbE8HC7yH6MUvOSnxxE5YB
	L33gT7m3gE745NvhrN6XmHuY70Yn5N9Z12clLftmVoxE5/6ww7eSSmtn8jK5WGuSnA2gx3KCf3n
	1v8IXL+11/dc8R7Qh5xZx+dKPJ72a5t2PIdcUrcCY4S3ndiXlGHHtrf/+UkgCG1Us8q7fem9Hf+
	1rb3JNpg=
X-Received: by 2002:a05:620a:4713:b0:93e:646c:9133 with SMTP id af79cd13be357-9494bc53dd7mr281919185a.64.1794547144420;
        Thu, 12 Nov 2026 21:19:04 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c6025f5sm106509685a.5.2026.11.12.21.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 21:19:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/12] mm/huge_memory: build the moved huge zero PMD
 from the destination VMA
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
Date: Fri, 13 Nov 2026 00:19:02 -0500
Message-Id: <179454714288.482102.7776276516691241493.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53F851C0004
X-Stat-Signature: kqxf5sf5pmhs8edkduqhefcbf7ybdq39
X-Rspam-User: 
X-HE-Tag: 1794547145-801634
X-HE-Meta: U2FsdGVkX1932IakBqFN/2+W07bqB3wUwdmnXRBI8JPVfG+AIuFmu4knvxrOIDBKxg4yfDYLHY/DFTo4qIq07/sqRBNPoo66z4JkF6aIAtEovxyWnhCz+3C2mLKnCuHx+R2scztVtH6FMEcGrmq+67RXBHG1hHUpcx3R6c5ssmUJuxMiEsePIlFJyxxgeUZymGlYMcpSt/rxtTHnqg/2qtL5bf+VoUDiao+bM7DRk14YWu7uSW8IEieUdJEhSSFPnJ4SCAKD3AjEaI+xwR1WqmZqBXBe6ssJw9gKlDKISX7LOF820Lc1qawZ5357I7Ygo9jiXqz2PEPNKQWnIMitesG0au757I+hBgke02YIdIpYyoag9UqKG0d6KolaKU+nf4PHHaOWe/+qnJAn62+u/jVTvu+9X3mS1SIQoJimkTsYqYtQupRuQu+KGhzKa6JezPkxgxQ8fowx3msIvOo6y9af+Y28CIEyzp8Fz+CFvlrXsGwlwiEevIHlmbMmqsFciO9Ty3xHEtSNiRdl/fO2U/F4iSCcHBK6a/nUwi7h4BT7iy+Ttom9BiElMFJ+LqOuips6oX6CicW1NNARMeiQ2kTN7drM0zkG6itp4zWy+6SnZIoYCVhDnVXk+fPFkV50pemp5yMlAodAHLfes6VF6Xi+mvz5OZ/8Aq8XBKm2hslLH3gnDH0Yfo+yxFbBkWfEKa+1qR9XvYwra32ARzNo/gYxdG6WaFuGRftOfD2Ad97CzCOVLlgr1mEytFeesT5Fp/P+VuJIwoUw0ncTNlQkG/czfjVUu95ZobkGUrpT17Jm564Sr0BQULtjjyB2J3sHrznf3TlnhgbF55JNheTkR4ubAj2OjbTVu4/HXRPKOSUpLF//gKZZcqIKzjfKwAFcQIdx6msQdMAA7pmuPu2vFZPlzxkvLqi3C9AMnElbKiQK2w/9yQPI2kwzMpeLByoMmstXi0LIMuieW5X2oSZ
 sweMhhgW
 OiprHzoFAKeIdcGjXwxMqEh6DeO98OtsFBVmdvO0ndIr6nJKgD9RNz/a+HqONm4KNio5QnCZhy7w8z827uxNT/QFdHwf/JXz3lidtBIheIYuPpdigLG8x+SKsx/JMtugl7VmthZPdkIKgTieWisLn86pgglfaSL4P6BSwD7l14xnUdnfRIfTtFX9QDbzEP7+v6NK4A3OK9Z7wTfupIyEmtMQCmYf7ndZHuruNhsagpVak9s/t12ERvtwgEkiYCVU0t9K51tP3HPjl6EQqwD3hzgBeAFX2Im6W5RkC4d8jBsONLLLUxNHwYkCBBlFFNxEjjG2quDaA/7Y5Y7Puu1C0eVFkE31QwPm1j28YaLS0Rdavr9J1Wuin4tc/bF92a+xT6SyiGWkx5c2z0yc4ms+4YhbstDofnFbM7iJWXIBsVnIV9odcStdFbTxhhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> move_pages_huge_pmd() builds the destination PMD for the huge zero page
> by copying the source PMD and clearing its uffd bit, so the destination
> keeps the protection of the source.
> 
> A source VMA registered for RWP can map the huge zero page with a
> PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
> registered. The destination then gets a PAGE_NONE PMD without the uffd
> bit, although nothing asked for that in the destination VMA.
> 
> The next access fixes it up through the NUMA hinting fault path. Until
> then, the first access to the destination takes a spurious fault and GUP
> has to take the fault path. The impact on userspace is small.
> 
> The moved entry must have the protection of the destination VMA. To fix
> it, build the entry from the vm_page_prot of the destination VMA, as
> move_zeropage_pte() does for the small zero page, and keep marking it
> soft-dirty. A destination VMA registered for RWP still gets its PMD
> re-armed afterwards.
> 
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reproduced the spurious fault.  Change looks reasonable.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


