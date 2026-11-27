Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F05D606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 00:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AbAp4Ibh
Received: by kanga.kvack.org (Postfix)
	id 9423D6B05B0; Thu, 26 Nov 2026 19:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAA06B05B1; Thu, 26 Nov 2026 19:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBD46B05B2; Thu, 26 Nov 2026 19:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 429B16B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:14:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E61C14018E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:14:12 +0000 (UTC)
X-FDA: 85478976744.10.FA206CD
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D96E18000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:14:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AbAp4Ibh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795738450;
	b=Gf612btaJd/wPw7Ns+DkGfzVIo20pm/ZKUIR6w29qLgPtQUlVB3CYLpJc/xMFSfgBkoIyB
	O91qHjjckkPDi7iKqGm2ST/1fgE1pUFwaHQlLOpPe2+7s4i+VHgvYWbQ6XOXDtHwXdhq/w
	Z8f1jEnTfY0v7ZQywf3arqzNqGpnjUw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795738450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7W1ie3m2NPGIZiB/tNvKaLuy4Fpgr1mdDIko48ejOhw=;
	b=xlRuNt/64JwS73rGkPCliQmZKXLTQkAMwdWyfv3F2T3HQ1nTyJ5dViNXJhZh5PySWqLIW0
	3D7kGn2U5Yfl4s47n3O1wl4X4ejosajxEzLfA/BKIWyc2Hb5T9EKRvvPgQ8Qg6+VZaI2uO
	wRl/+nyZ087clH1R7xILPZ9MIfAbDA8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AbAp4Ibh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zcliangcn@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=zcliangcn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3863db981d4so10534394eec.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:14:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795738449; cv=none;
        d=google.com; s=arc-20260327;
        b=CCxYuoqaBu+hSB7tsChUJZmv6YPAR/H4K/kQGpvUx3KsYJO4WKJNFeSdza8k7/h+TK
         ps+MJgtO0hjh0gcynfp4URhPz9Lqk60n/ao4e3pVAtWikAmx5L1h+QfTvk5IATVENg/l
         PwKCVkWCcQwAHAEvDMebaskrcniiU+aQePy2Vwy6ik2YxQ8b8lUkkffoKNWbI1Y6zWDV
         n1fiXmkuoOBwjP5i9QYBOsyJiYRZnoflcP+1j4PW2q/QI33SmxVA6JV4lDRQ1dex53ZT
         I+U+X+SMxZkeHElncJcOVU9SuH879wUdAiGzzEtIa7HjgEjr97YTVelu8BU4EBATUJYT
         0kiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7W1ie3m2NPGIZiB/tNvKaLuy4Fpgr1mdDIko48ejOhw=;
        fh=F9Q3AT8wZHhOuEfZ4EbtcuxTybDAvhf+6ZdaGWuZwSU=;
        b=Kd7RYyhW3lJq74OB2eewxjn7UO+dM06jl8w8QsnKACUl9AVdnqgOHSee8rH+qhCTuc
         bVmCzTd4X0anCLws/o4wG+hYLe47MWihHQQB7kdWd2fmpSwJe9Yo7FpP+G1jtBdz/nwO
         29DnS8S+b8WIBholpe1FWL+3ZiKWZcITN96U46K43rdnv868ByB+sI3DBHmqXd7+Uxyu
         ebfOlQwjdaXG8ad6whdZm7Gugz5ug66TBINHDixRd6lrp0o0q3LWj21k45EgSWITa1o5
         UB9BamXDFreRanRx3WFP2gwH3ai56CoMSNF6Ja0pEVrow/BKfUB/ziuscJfiBBG1H5+C
         dZHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795738449; x=1796343249; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7W1ie3m2NPGIZiB/tNvKaLuy4Fpgr1mdDIko48ejOhw=;
        b=AbAp4IbhomhCcgmjr4MYbI0xEagOveO2R8JSoYF1so9+JCJHKK8vCvVTxlCr76mOwX
         /adm7Hftsx5jb0sseNhabNdCR0Jq0zrNwBNqtEnj8jeKL8ybcy42jzR2oSOU0Kz0LNhb
         NyFd90QPcqepbgSTHiAyGEPqdUSeX9gJ99bK4HOoo59ZjRSuwjMIYBi2RQowZVoGpoX9
         HYuNKK6y8agTqOIYGzJ0eEKsSMUN12LHkvRzw3rG4qv6YSvfOa4g4Hw6Q91z+DgeOy5/
         Q3jPoyYFziSps76dTLMYfpEeDS+fCb+gqwZ8FP2leWSKGb8hoYBd6rmh+D3YTomr/0Ko
         BeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795738449; x=1796343249;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7W1ie3m2NPGIZiB/tNvKaLuy4Fpgr1mdDIko48ejOhw=;
        b=LniF++u6a0627gMgajUNfdAXwD4S8JHFxppGO+f9FgexXG1SoxCCKvDOOyF6s6cnyG
         Ktnj7wWyOXrc8N6g96SikZI/3/Jht0OQG0Nm/3tXTziftz4tBvAK31PO8R6bFUJF9z//
         WdbR2tAmoVo7jceKcSnJ5dVJQo0w/XMOtx927oxQ2+2jVRf/NMGYe6i3uRbAdzwdy4ar
         nR2Zf5vPMSX9nknY7cpXnSKmlmqW26YWbvIU3DmGdBYxYxC9aFz8/iixmUckxrG5PKlb
         WTXvoVdJ4Ul0tweIT4eOnjtaTWg6gcQnSyv7jR+6DKcHwcypqrSYqk/FAYgspe5DI68p
         3AWw==
X-Forwarded-Encrypted: i=1; AL+hErGu3jXm7MCVGbxIihVKGVdD+5PrLRKK5Ar0T8rqp6KD3jVLYi0UVvmo9i+2c1F7ggM0GsUMXZOmfA==@kvack.org
X-Gm-Message-State: APuU4Z8/d0dbB9QFy6/EAAYyZya6FST0Kg6KrYSz4Q7Y7nnLp+5+1K23
	knbMJIxGRwnDqEn90Vp6Xc02PgdOa5tWVy6HIliAT/aB9F3bVOXMYz43s/ZQRkRGiGNKg1mFmff
	4SLjV/HONoy7eua+T57OC4NtYtVD2Ctc=
X-Gm-Gg: AZFdTZckhy0eOy3sAPaVgUq6dz6i0gRHIDL0HWrxDLPZf4hkmE0go9Akfr9BkmSwRY6
	v3BNwHv7D7Osl9uSuKk8JDT7MOh1AZzxCFAhJMzsXgU+44VLmjSQLRhluhcc5pHNfxYsIYf0zdN
	L1ayHzrwxeANzFAiLK6/FZxMWUCrWago4XMAuvyuK/JFtgDg/rGeCeBcdAOvuUUVZNYniQgNd2A
	23R6GXE9qOzXztp0GmdOwdYXsCZygWxxh8p6JKPZdUG2e+7I6ud3924jWIplBDl01deXz1GN8m/
	Q/8QsOokiCYgRdMz87KVZ2wq2UlpmtQFmFQAqQyntFj5cJI/OOoLM01V1gC3gSGnd5Aj7nxoLfK
	zOusPdEKxakBxDSbOItxGkLpfYmtnETTRY07zoA4=
X-Received: by 2002:a05:7301:6181:10b0:386:b2ac:1f17 with SMTP id
 5a478bee46e88-386b2ac2832mr13850733eec.7.1795738449192; Thu, 26 Nov 2026
 16:14:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
 <4ffa6613-119b-4eae-abbf-26134bd60177@kernel.org> <CAOny8psx408zqVv1xt7DHN8yYkQksjKZFDQCJ+AGFB-CDN9SmA@mail.gmail.com>
 <3ee0f274-0089-4450-9888-7be659af9d63@kernel.org>
In-Reply-To: <3ee0f274-0089-4450-9888-7be659af9d63@kernel.org>
From: Zhengchuan Liang <zcliangcn@gmail.com>
Date: Thu, 26 Nov 2026 16:13:58 -0800
X-Gm-Features: Aa3M54oNeJXp-qLCgoFIGjayWZczBL3897rPIbXQX6titnmlYvM4Yq43L2upceM
Message-ID: <CAOny8puwHRsnFabwkMMfgkRVHBFbXFYC3ANweN5Odr2wFdvrxQ@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault mutexes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D96E18000B
X-Rspam-User:
X-Stat-Signature: y3isy9njgyggeno1tnn6f7yryja3qiig
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795738450-78751
X-HE-Meta: U2FsdGVkX1/9VV6LYJzI5b1RrbEQqTr+EvA2eeof4qs5VJCIeSq0x72136C3+FHC2ScJpuDJDlCO1Isq7je4o/xi1gp7pPsX4OCH5Mcn7ib4XPch+T3sPLJ4ahO39l0yWaaXXrHFATBiMPB1Gbx1e3M7FuVFH4LTp4ZvcrV/0h0BIw/v6LrZsLnz7R3lfqYhylOPm9pII06P1rQhrCvJIX/5uxD396YlM9gAWhe03nFWNJqnlbiDvJrRDuxCz6sKOcL0z2tfw7rMMrnnMlE5lYqF9+aUueexPIFuAty342qt6/IW1BQrd6XZyweTzGYR1SrmgH/0Bm9aq4hXJoHEk/KERsztGeq0bVZ7g3WAL+ppxqOLGN8WACzsjS9exzYuTxlLC1HSgNn2XCiGfPe6OePF4yitiTS/Q/voOwux36OKg7KL4BQt0Z2ICtOC5sxugtRYT9M7wkOdmX16LeaKPdhUmYcgMGhyX/Nnqwl5Y07JwgpoLmd4OaeBx76kwjnBAkhV1VTZodcOJ3K1I+UH21NG2H3fk4U3dchnwBvbOx/gmW31mI8nshmcxO4YePXFj/sTnS2n4th9Ju38IfOPyd1l5XXaJImCH3u6093TmOK55M9+lOC+VqkiPuMIgnEUt3I+oDXB+5H/5h0ikDCEmhjOb64qSiRHR6Ys8ECBUpaC5iW5b7Gc+VyIonRF5AMSzMAunC1pCVzGCR3IJnd0npZItF0BrspcO/Hk5GxNjQHSMXI0XZU6ASmNFyeiBmvfrBoqiW3U1Jexqwp5xH87HYJYVzD7lWbauYM/oREm+t/Z+zRU0gzfyr+q7C4Dmrddvj5du0MKJAh3qFWsaxAVACwLHwinK4xJMYh64OPPJpvmiaFiGjHc98cM3iGR5sy9gsi0+btYBeKHvH6IBpjEz2rEdSqYsihb2G+jSXJcOj6jVc/wvkmsnXp0T4fClDUHLtROAJjl1EvFv9iM6X4
 NhWWj1Al
 y9tVa4RI9jUt3nsomHS/T4wKRekuyfLX2YoiqUAlfzJDHMbxiukZvNGfcApJjCuQ56BDw6xYz4oqMz+W1DFcLFLQH/zuT6YJVuzhCMacKwGNDWq4R33uK7Bv2TG2agBB1Qv00nmXV+1b9IabrzH70FuWnTBwd6F179PJvIZFwSodKaBVkrwHAzcqBEiUUegqFphiQezf47Js2T8ObQIytynCUZLX3FJr5OMi1v73qnOHEMAHomQN8FCh4dRtpGSJBnyiPwRv65u7Kv0NME2T4pO3DQAtASsZfPqyK1MrypfKwLbIr0uhEnLy9ySmfi3Jd1bxAT4jnpFua9lU/aL/wjUe8D1dLplEBt06atTxAcfRq3Tdk42auzVP8rMTBj4hxQUwne2mZeXYEae2IzyZRevpeBayoRv3CzTL2lTFzbmx1bpNgGP0tAPd9GKV6gnWur7X35EVm3bpEOADwjYLEvxyvA0vbP5yebGqZZBJ6x9nS9NSC/rgurZ+HILkbq7IrheXW7xxmKvLPXsnceMe5FsgRb7++gdCapQLBfwiSkV56aJUyuIxqnV5bLMhWkxxpGpdf4uDMJ+2Apv36IAcXwOoR80RA7hDejBSI1EIMRm/WPFAnVyC5HjKddY6X9S0tE7zejfoE5cOb3nz+Jl/536jwGGbviiqkA0+QXmTqh32trqvTd0rLQc8P9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 3:17=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> > KernelSnitch (NDSS 2025) demonstrated why the address of an
> > attacker-created object can be useful. It recovered an mm_struct addres=
s,
> > freed all objects in the corresponding slab, reclaimed the slab pages
> > with msg_msg objects, and thereby learned the addresses of those
> > replacement objects. Here an attacker can similarly allocate and releas=
e
> > hugetlbfs_inode_cache objects by creating and closing HugeTLB memfds. I
> > have not demonstrated full-slab reclamation or cross-cache reuse for th=
is
> > case.
>
> Right. Do we have any gut feeling how exploitable this is?

Thanks. I tested the cross-cache reuse step. An unprivileged process can
release the relevant hugetlbfs_inode_cache slab and reclaim the exact page
with msg_msg allocations containing attacker-controlled data.

Thus, the recovered address can identify live replacement objects after
the inode is freed. This is not a corruption primitive by itself, but it
provides a concrete heap-layout primitive for a subsequent attack.

Best,
Zhengchuan

