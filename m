Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790A6E7AD43
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 11:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3659E6B0088; Thu, 25 Dec 2025 06:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3134F6B0089; Thu, 25 Dec 2025 06:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215686B008A; Thu, 25 Dec 2025 06:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 110986B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 06:48:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B038C1B3F
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 11:48:14 +0000 (UTC)
X-FDA: 84257820108.10.C92AE3D
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FC2940006
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 11:48:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EUL5L0cc;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766663292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJNXgeUnmBlVzib85vhCp/zOF7QDvNN+6JzrDWT84Ew=;
	b=1+B+RhKUkW9NVNuIwoED57HHfwM1sTSAECO3ojcR9GXBhjGhhC92Ad5w232qee84zXdVu4
	p8I7PhF8e1moWhONeRsEFAcstQ7Owx/P9lzfcinUUA6nqYw/SCW1UF1QAd5kzthZirZM6x
	NKlBf9NRqfUSD0MoFbD5MC9GptqXNFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EUL5L0cc;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766663292; a=rsa-sha256;
	cv=none;
	b=xJNPTnKE+gPXU65RtMzpErgU3ytdC9kyJF1a2nXEIx88E2VBjA93MgK85jV6v1Ax0xxBrg
	zqRL+58laOa1PviykKgIP8joPoWm0AB2wOlY2edS/i3e1gZK8uLUbiD9yQ+t8gUCfGaOL4
	xTwC4I+hkjxKUw3gl7ngO2wpKqnXBmE=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so6991582e87.1
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766663291; x=1767268091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJNXgeUnmBlVzib85vhCp/zOF7QDvNN+6JzrDWT84Ew=;
        b=EUL5L0ccmbwZkgmfVN4o/Iagupt6lIpZnOegOXFB0RF5qtzRABdv4+ztpjWtnLeCCT
         mS6joHXBQczG8wzC3zzLm1pnvhTrlWqzEX1EMQbMTA+ExvB5IkFd8f0KmV/bqVMyI/gd
         /99mTQocrlolmgqFPiXZ+MRv5EI1ji288mneA/El7sGhbgtaVaywNM4AoYizBoEqtZoX
         bxbwUGXpGoEaJRql1WinJg85hJdahbPoVXYLheF+xo7QHfdJpjgw9igb3l/BKYwFKwa5
         VeYHj4tYvDPYJBMHg/WR058/TIrxRFfscdg2LNIklMZtouwpO2vdayFTZJ/r0FKhws3I
         xYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766663291; x=1767268091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bJNXgeUnmBlVzib85vhCp/zOF7QDvNN+6JzrDWT84Ew=;
        b=EGcBA/Mlsau0TEXJ/SJHuTkyjiRPKa5B5gj5otexQF6fZmK7OmHvd7P2JaWIipF8rZ
         oUkOC0s4E8pukGOMF2B3eA8TXdFAMaddOu8pWL9w8KjrdTcfFA8e1SAgfguxGW0elhxJ
         JhuTdkTMEn4ZpAcNFT9xi1lpknWXdxxDU/xRsgg6i5cQyw1DWjwKqg5jx5bXsBoh4fq0
         FsLVEZ6QFPJqsS98uUaxNG6P3ZH5UJ7dK9V4QdIh6vvU+XblHn9fXjbX4fzflaEXMB6K
         9lDX83/1ieO9585CJYKv+pFVpZrs9032qi8TjjMwxFxRA2hP4Te29nosLidZ0bP0l3nA
         84Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWvoWPuWGh5OtkTVbU5gsw/SUZThw3LLKFvEm4DcLR752x45cVKR1SxOFAQRJiY5nZXtRV9Z25Aaw==@kvack.org
X-Gm-Message-State: AOJu0YybbQuMjzb2nA7uRorw/J8H/iz83iLkUkKOmmoCjp+0ehOeFoaJ
	82SZyF+Kt3ZHlza3uI/Bx1lMMZm9Ai7uUqmz2mytT04YFiCrP/mJLLuDEVBZ7g==
X-Gm-Gg: AY/fxX7Du6OYdr9aip3kxIcuIaZzIrZwkhy9+RY24v9T4yLWRuMxSNLdzZgh4ulJWl1
	IT/jdHyPkn+SwalDledyl2U7yYkH7Z5292TPTw0UvIQmEjJjIc+2YfPm6h11OQvI/sLFbkelVlr
	agllyo8HTzV8GCcGftOCVxtN+Ut6cBwVPKo1nxGy5LwlxFoWfh3BtfG2jmpzq5hKOnutP3qQ1qF
	uMUzSdw/JGaHpsPKKuDcymh3gb11lox9vqrS/TR5bUYf3FfhFSgMDbyiIXIwhSc1StXLOYvIj4v
	Y0jdfV+KUQY5h+X5mQ8zIsOg+W5JadxpETSkWBbOQXajT147Lb4Vp0w55eEzp0hXKuSVtCIQkIH
	/e0WudraaWLqE+eGtauinf25+nK0Ox10iZ2eLqEfATVKrBM6iqlfkyGgZjKD8+jdRmHHCVhDdqe
	F2b4lY6ueUT7/G7+Q3cv1G0u9KzdaTs6TcvJ9uVv1cECSYFXoinT4=
X-Google-Smtp-Source: AGHT+IHOom56Z1I9znTT8GQOWzOtEMMo18aa48rdUzp7lDUJXyKKxD9GjcmJyzFsWfIZQUseGnf7Zg==
X-Received: by 2002:a05:600c:6299:b0:477:73e9:dbe7 with SMTP id 5b1f17b1804b1-47d1959ae49mr234180245e9.35.1766656869005;
        Thu, 25 Dec 2025 02:01:09 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27c2260sm380489825e9.15.2025.12.25.02.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 02:01:08 -0800 (PST)
Date: Thu, 25 Dec 2025 10:01:06 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Lance Yang <ioworker0@gmail.com>,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, axelrasmussen@google.com,
 chandna.sahil@gmail.com, chengming.zhou@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, nphamcs@gmail.com,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
 weixugc@google.com, yosry.ahmed@linux.dev, yuanchu@google.com,
 zhengqi.arch@bytedance.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Message-ID: <20251225100106.53e03519@pumpkin>
In-Reply-To: <b65297e0-0ea7-4ac4-88be-fa89d6749d7a@kernel.org>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
	<20251224092332.53214-1-ioworker0@gmail.com>
	<20251224140829.2ec7bbae@pumpkin>
	<aUwruMji4MCNaOPi@casper.infradead.org>
	<b65297e0-0ea7-4ac4-88be-fa89d6749d7a@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: hkbnpab1igu3by54npp7d7pcpxdhbjy4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FC2940006
X-HE-Tag: 1766663292-581950
X-HE-Meta: U2FsdGVkX18xFKRDm0kAOc4t3u0KZ1urQO/5fPaOs7VBegVUkqTgXg4CRm/K4kcf+M77TdgHW4aq8RflxN6hugTDG39wwBkh00oDSrAmolwKt+2KfXHqdq49Mf1EFoHiM4XgMhF7H5RW+S7Bh7zxWkU6omLcWSpAwiFjE700xHxdNraW+1UMkFUoiz0+oyZMYU8yP2oJhnPxccdE4dBkmVsydZA48CDLikbwHCSxUadNESdFXVOUgEUffB1nRHOQFFgzDIXRUCTMrIfhfhr4HWopbTPO7b/ohAWbldJGfaYWi73SLMPJNCB4rAa9aKfKQm2jNsVJFD9oF/jSE1X5ZAqiSSsVwGOAwk+wV8j8bAWFE9J5RXze02Ngy11nPmum0z8Nu6ScPIfjfsLGKhPw1R8jmfy+JL7vfkUm/JFNZ/BfTKPiXb+g9wk//bLsNObgGiM2WcQ1UuFjbmueDbwraiemDWO2AelsIQZUiUVrMQn0c55P/Eknox1qMBmGN9aWGNcKf9UCIogLQM+lzDBd94H7XcDqMb6iaeRMkwIahpWwaXrpO/doEHWiHLR6q6lfUDVEutwYO0gYcVpj6TS4gXHhHPGTZZLHSJW40IUGasUFeCvSUJcpl+80VvfGVz5t4JtF9kEmQ5KC7rYzTU6tdUKjtK7fMjdqxOAYN5fdzJ41+7KfBoCv4o7Cm0yj4JRnIUmShSEKMmIHD7PSDeLDjZ2B1T3iiRs53nvAkcs8/03bpiB1RLodYpNPdE3s7/bnrgW/43LxNJ2SNqLdeaGnaDbu9krkWshxgLCc0F9cGM9+JmaziI1rRHtOa2qMBcC2aNTJUPAT+tCjgwKm2FRVk7OOxBQENNk20tHWPMLzdE5Se8Z04dNLeSlVB9kPkhyIm67L+AVy03iFJyB+fPImcLiQUPGlSQNUiMjfoVr/CEq44SVIKzIDHJSsRNDNX4O4ZGPQ31xspxLCrUYXUkq
 Aiw0a2OM
 hkZOIeNZ6nCD9OmRvzjXm3teFlsOXRGiPc1EFgP25fp41QG+Jdk30UrfOFY1ULUFOpiT0uOHCmGI42A8gYifMKYSNCRYh7dH2jhaGV/xpvHxkC1jSsvXlEHUiH9VgjwqEvqr29DpMgMXFjggTr2M9MF1lDuDbRJ3cTQ7vUP6fuIVMgBIRRHFa+k0MG3IjALo+WfLBzCxVv2oeZgPg5PYI39BmR4P45NYIr1wxhs6bTbbFalE6mDqBM5+IeDFx4iW5gCUxF3BzFkxDuYyDusKOISFHgqrlQ8VhJkZbewksr7Ni0cVROY51A3dSIONhrBtu9r0qaatKxhmqbD3iJz5Gl+JvR/E0/BPZCg0LMPLYS73kKgwHDJSZbEidC1EfACq0BrQ0rc7ET/UvRw8E9irjuwuYZzaDSJVVsqMFlrcLXKNLuMw1cFRH/5iFIvLyy5/S007fK8p7g+JyR0ZkR9LIiKk9zj+qUMnnC4QVnX6mgwLBGD4qo5A0OzoY9TQOn//2MTBXlLER6y6gxnqW7L0jMrGCVNu/SLnQJ31x+szG03hQD0wXRnpvnJrYJxiBNE5GvjWw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 10:32:46 +0100
"David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 12/24/25 19:06, Matthew Wilcox wrote:
> > On Wed, Dec 24, 2025 at 02:08:29PM +0000, David Laight wrote:  
> >>>>> +++ b/mm/pagewalk.c
> >>>>> @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
> >>>>>    static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> >>>>>    				       unsigned long end)
> >>>>>    {
> >>>>> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> >>>>> -	return boundary < end ? boundary : end;
> >>>>> +	return min(ALIGN(addr, huge_page_size(h)), end);
> >>>>>    }  
> >>>>
> >>>> Please drop this patch from the mm-new branch, as it causes
> >>>> 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging
> >>>> when executing hugepage-vmemmap test, because the program falls into an
> >>>> infinite loop in walk_hugetlb_range() and cannot break out.  
> >>>
> >>> Good catch! The problem is that ALIGN() returns addr itself when already
> >>> aligned, causing the infinite loop ...  
> >>
> >> Using ALIGN(addr + 1, huge_page_size(h)) would work.
> >> Although it could be (addr + 1) & ~huge_page_mask(h) which is probably
> >> the easiest to understand.
> >> Some of the 'helper' macros don't really make the code easier to read.
> >> (And that includes a lot of uses of min().)  
> > 
> > Or we could go back to my original suggestion.
> > 
> > https://lore.kernel.org/linux-mm/aRyOWrARRlUCeEz6@casper.infradead.org/
> > 
> > which was in v2:
> > 
> > https://lore.kernel.org/linux-mm/f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com/  
> 
> I'm starting to wonder whether we should just leave that code alone :)
> 

Maybe 'we' should stop checkpatch (etc) suggesting min() in trivial
cases. It doesn't really make the code better.

	David

