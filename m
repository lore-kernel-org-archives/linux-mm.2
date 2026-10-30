Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DBF606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 01:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=oLrkjQz5
Received: by kanga.kvack.org (Postfix)
	id 030956B00EF; Thu, 29 Oct 2026 21:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F241B6B05B1; Thu, 29 Oct 2026 21:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13036B05B2; Thu, 29 Oct 2026 21:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A4C6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:37:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38CDEA81E8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:37:12 +0000 (UTC)
X-FDA: 85377579504.06.A39A0CF
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 458E88000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:37:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oLrkjQz5;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793324230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcy8/R0qg4/tLGENoHwYrpvlh1ufL01JT/JeD2hu+48=;
	b=P2Qv8vbu8cceKZk1Inn1HfXCwMnFdIsYCw+VU7TH5WFfcCheaGky3w6KJreTQ0SkvHDRq7
	T58/zYwj0CT4an4oBUUgtJOrhj+sTV6Ka4bCKce0kvZRUjm3Zin8W1H9Hc6GB8ZZAr4v51
	/nZUsRspBeTA6VXoJvj53RH036eXKZc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oLrkjQz5;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793324230;
	b=NTolCGj2sL++wrXYmoDp148FtzZlIiEtb/OY0C0uxUlousBQg5YDEI2kazROMLqxCMao+n
	VlvMUPetedceGTTNDETjzOxz2zDlH0yfJ67Zh2r/0kPf2NfXNbBYgFTrqrCL1+LwaciWLq
	Ykod75cjakkCBRBvZvhM3IrwbhvK+DU=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f560af6aeso19698985a.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793324229; x=1793929029; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zcy8/R0qg4/tLGENoHwYrpvlh1ufL01JT/JeD2hu+48=;
        b=oLrkjQz5JoYvchsWV+96QC3/lGLqSswK0i1t4KVv4h16oQ1I/I5X5MJtNe/ccdjc8H
         spB/vZUrmXo7WViia1oRPtqds7XaLaFHcbHWoF1fg8tCp7idhYYnUShaw19mxpf9h/+h
         E6CYgmJ9TKsmYgKASMTu+LnIvAgZoMKswnmjYoJI8TZd5416Cg7JLsd/Tlyar2HhUauT
         Kz0qesuVsgZaMnnxqfoM6gavSTb8AJ+6txUAJqntu6hCid9I2l/wtu0819NTPDlKmQxr
         0xJ3CHwApPqR3YpELXzSLuOYo7xcYc2fRvRvkngdTUvCoDXTT+DO+hhg9y0lOCmzx8jC
         xxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324229; x=1793929029;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zcy8/R0qg4/tLGENoHwYrpvlh1ufL01JT/JeD2hu+48=;
        b=zUvcXLeMkq9FHY4/saqVXT7VeswzlTR9SDHvNURIlIqfzi14h/Tzsav5y8MXahawyY
         wrF1yjOtOTwKbngX6M4wyWc9DwVi0H5ExJAwuHuZUKns+aO3OHgRTHBgvW8D141oO0UM
         d6NzcksbFEslxZnsrJIEfKZFla7UYn6NW7E6Vyyoe2dca64Z6Ljq9lppfpEdrR+HqtwW
         bvpL6/SJku1rtfDwJbXP58qy+k4pnC8vQkrV7GhAKjIn2YZ7tERpFha43tPB/PgDJryC
         VuLQnggeV5/DGna2dXgbbEaJL0f00mpm1YwrRBUF+58XhI8qHtk3Px1zGrAMC0HFuOL5
         bUmw==
X-Forwarded-Encrypted: i=1; AKwUvBxyoF0MjyUSwlup+pkmbBqbX6pij55ky86ArMy3Xb031L3wuMybHW3mSjQdt8H9CN9dZNisjDe4CA==@kvack.org
X-Gm-Message-State: AFq9FYJU3CphD0qFDoZA2Y3IBbhTetv0r4EcKr6xVLTbgZEWT/4COV+K
	HpipF7FDHzh1kG0zQkazXolickyyZ8GuHq97kiVvFMdUlYiOW83marfu0ZPJNE58Jc4=
X-Gm-Gg: AYBFou10s8Dg3vqxNWfecyo++ov8Jy4KlZMbDRXido8euUatLUJOkKpK7WKdl7WxXtb
	2DbvyndtfopcS2XW7FHJ1m35gUsORjUUzXOKPv+iy5b6sWZm9C2MzBt5Hmjay2JI3g8j+duq+Bu
	f2/lF2gHW1KcrL44i7q2GCan5zF9J9pWZLlnw2FVPy8QZSiTzfRqUd5da3282A4Bc8uKEvSlP+m
	71d76IAEpIuym9GZER8kmx7K10H8+8E/5f1DIMdpiT4dWDQDeiB9PGyrFYseo45bNV6OKDkGGa8
	V8Rdbo1xrUQE5AvtPt/Xd1vDInXVfLQKKfAL2mKDkqKvuIQ35GAfdZpZCg7oqsx2KAweTGXVpki
	T2hbsdTi7Tvzbca2BkNzHZyGlArDF7cV8Mt0z9DqsUMO+Yz5bX+rX/dfigGvgug2fZT6zkhEJkU
	PSw6vUk9GimwH14G3OLc/uSppKShmDTkSsCu93cZWW7MNhyDY3RLzduJ9zvuLQy/pJG5on7u2Cj
	pOM/ZVsqdbm3yKuO8eSz4YP08HrabXs4E25XZr1DlE7XXJrr5/gFDTlC0XLQIsefygccmJMe9hP
	EfFQtei7OR0gWikuJDnYcVXx6H3Ro7YZVHrt/rzGjAj9TOsj3TnBBd9WkEPHmUF8VqdYEYmdoL8
	d
X-Received: by 2002:a05:620a:800a:b0:93f:43a4:a47e with SMTP id af79cd13be357-94421759f60mr164999285a.43.1793324229423;
        Thu, 29 Oct 2026 18:37:09 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca806aeeasm1672456d6.35.2026.10.29.18.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:37:08 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 6/8] mm/hugetlb: retry the pool walk when the
 zonelist is rebuilt
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, muchun.song@linux.dev, 
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, 
 ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
 ying.huang@linux.alibaba.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
 brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net, 
 anshuman.khandual@arm.com, stable@vger.kernel.org
In-Reply-To: <fe658b1b-4011-4197-b228-fd4bb6c412bc@kernel.org>
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-7-gourry@gourry.net>
 <fe658b1b-4011-4197-b228-fd4bb6c412bc@kernel.org>
Date: Thu, 29 Oct 2026 21:37:07 -0400
Message-Id: <179332422799.1311000.12794841959006150077.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 458E88000C
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7oajjqddt3ecnooq7rzmdybp5aptecaw
X-HE-Tag: 1793324230-360858
X-HE-Meta: U2FsdGVkX18kmaDJUI67vMKWOWmF/8Qic9pM9PelPyBrMjPr4y+rYU2ImVjNWQ1XV1sVi0IB+KXvBMrJ+2Dk+lF7pl9YqWygAkzwiBJ4Zu3l7HlYJt/brs2wQrymS39xEMhMLcUtDBbcSRiv7YoYHt95k4jYWRObPDvS8wIqDWTP9E9+4rSDmj/OKWjfsj9FZhPEoYNLRIjglwI4jmVgt+Trd/eQS44SuNKYzESa5t6aMAYVJkIO610MCXFK7EQBLhV83IHKhkzB1SYDRthRT7FZmRijJLPKPd3ulmtDUqWgUy501SdZ8RS5Sg4uQM7C3gjoTHydmYhf3MvseWLVCNAaZRID402Iv80mhF8/eOFcy01sJhPkKP6WqlbmJAT5BFGOjyYBxFLrkukcBLhBhmKp8LT+97Lx1LhSzaAmzPte59Upby924U5F4byffvaT9C2SmW5PP0Gn7jtF+tL72YZ4PhMJC7quebe5C2pL9IeBvJ5yzur6A75QEGBQs7SV32h5yyTxp8uV3Wa4pmhvSiHiX0cvyVhCf18D1/L1n9UIaV9W7B0ZnEI+m6W+LcExUZaO7GWwfBNm++P1k1eBnrDiPPgayQvZM2137v/0dNDFX64V3FHX/TabSKJPP+srT0QA4G8JGWWKtjLmf7aPmxR1xO0o2qnEzJ27aebo16h7ObOVyk6Np+Z9POOfwHwzUTPXKYDvbuOgiXpWPdpJ0WtDdrBbOs8iAFrYblDdvgWlGgmZLObi2LZIgS12mpaq7WBHk3WAWzDMkynviekcoSs6cLqeuiN3ZEkD/KmmMK6NA+ND8tdipT8HhhlncyyzGw7idbnc14D8gf6Rd1wqZpC6CZNDJo42NGKCaLw906WOenHJugJMA7xX7FxxEasUyt8SBXDUWLiY7n6Iv2oBpuI5QW+PPKEVSPcl5yYWtelqG9CYxh99L95kubS03OGynZulIjGoPt1aQ5uRVar
 BJyuoqnd
 hsVvf1Zaicf5uQ4AiOUgjjhE9VSNKOHObIq2qRAzW8y6w05nqo0fGcDloOynnMGZdDuvTblzi3U0JtyU4eE+ScbB387O6DM1SYtdR3vkimFM3JwoPYTG48FGJMK9YPUAFwcuhE0gT9F+rW/TbVEm3xtDlzH9vwFUs3MWa/W60R5w5d2nw7zN6rX9LVUdbAUKsbc5f78OLoWmVaw31wVeJjENf0VZxECHdb+kwg8PjvMnuaws+w6eB313haPD1IwFuZF77Fx9Fj11zzE7gy6zWmPUThhO0st1ijijFsSj8Ssf7pi3hjotSWcMdIzxPuN8ll+APT1kG6HrZ5No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 19:08 +0100, Vlastimil Babka (SUSE) wrote:
> >  
> > +unsigned int zonelist_iter_begin(void);
> > +unsigned int check_retry_zonelist(unsigned int seq);
> 
> ... is it possible to inline these here instead?
> 

Reasonable, let me take a look.

-- 
~Gregory


