Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7B8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0D36B0092; Tue,  1 Sep 2026 16:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968926B0095; Tue,  1 Sep 2026 16:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850856B0096; Tue,  1 Sep 2026 16:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF4B6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B55E98053E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:44:57 +0000 (UTC)
X-FDA: 85166372634.15.EF5B2E8
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E2B44000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:44:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lFJZkDHm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788295495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EH/NfLg4aACwiLJhYAQ0D2cKDfAytCBjkGxmccPidO8=;
	b=SuLZ2cd56ptNsG0Fr/NuNXOzXdY6lEqV3zkTKBaf/bLAqU6+3uxx9Lvw39LDX5Nr/34i2d
	N5Gz2brBDqtjTDM7tteYskwL7fHymerlWB4/q9if0rUdAM9dApqR7Jj6y1bMNPQxA1mrvE
	FntvRG+07gc9/eRztd3EBc8e7tp8LeY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lFJZkDHm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788295495;
	b=606TGoypLZcXFLogkwArrodFjgZT8OBnxqNixAZ9LVqmsTKNgqkD2Zk/RrRg01FM/SU8iP
	1rmh5MM2OtxdcyR2CPmOhMm/wPhiS/+2TyoYTvQEUHRc+vQIcRTntJgfQAiUev3lvdBNAG
	K0RcsOSosS5WT3bnLX8rEY27tvwuWrs=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66e5d39cfe1so437428d50.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 13:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788295494; x=1788900294; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EH/NfLg4aACwiLJhYAQ0D2cKDfAytCBjkGxmccPidO8=;
        b=lFJZkDHmbLrPPE50vA2GQC9ysAzShcWKYZ0jOGBkfzi8U1ljmZVFvGNWY8mGs0DZvX
         vtHKKgnSKsH5ZaI5KyqFEKeIEcSv7vlGPtm2C2vNxA2nfeDBm4ovlL+hn7K4DQr0X45w
         gK3xDZpqLWuPUTznCb4ujYraC8BjXpXRwLQZs9jfwYK7Fg4qN13n/lBib2ecEvBF9N4s
         BtVa5iGDlrVVYsUBwXyqRf9XLtOomX2q2EqnzSYpz9itYfGmkpri/tLl8+AxzvjCK8JI
         98NAasA+jvmbWnsdrchSPx9JeCobMlgUCDkOyBSBU5r/evOz+uwvPzQZQlFPPee3MKCQ
         neqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788295494; x=1788900294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EH/NfLg4aACwiLJhYAQ0D2cKDfAytCBjkGxmccPidO8=;
        b=mj0mE/KCgiOilcmYPhAkLMBwbl+B38PxuYhDA1u1GFJ3rSYR0rjk80+IxmLkzspMSd
         rnxTZtGrjg3qIJxuCAM6M2DIfAEdk6NdHqAXDithYZXT0ICMPfVOVpxyECDIZSwd7iQh
         RkdJS0ChsPbXMQm3ZJGM95qp78aNoJGKA2AxjvsB+dB4CRUBgNLEbQcdPAZNg8sFWLPD
         TwgFLZh4yOKUuoW4TmknT92z4WApHc+8PcbeVJbrHo7bTMt/7+n2ex+BKYoh+GiloZ3c
         LsBxpbDmGmSzdRO0zPysQJsOD0cMrlYRa8ERcCxhbPRZCvsO9U5UgnN/SYb3Vo7Tg4nO
         ZuhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOvSZxGSqq5OReWzOP3smZoUEYod4FikSDF8jiSKNUbxvc8mu5WpYPa2t5pRTURSepwuDUngF3lg==@kvack.org
X-Gm-Message-State: AFuF++k+7uuP3CNq0LJVNZKegkCLswvQcYGnH4ks3Z5/o7wkGBe2OgT5
	CLnb7HSBgWciolsNazfK6bvoNrE4sqQqI/R7yFDTIq4vb919w4llKdFyIzlmlPPLO5A=
X-Gm-Gg: AYBFou3Lg+EBDUsH0x0w63QqNbVZ/0tEPsuzC2p+LWl4WdGVaw7wexAnCWe/IVX/9lf
	wt0hyuSA9e38d9weJPqbLSfmwsbQCVVPhCyiKhAgpANivXF1wEpwZPas7DB7bxofmcuk6L2i1Pu
	lLf8KS+cWVxmRShASZ0HUA1s+rHXRcQ7TtS3lSSAUn1R3TmUr8hnP9c7B8P2bXR8rygdCKOSa0K
	cm67qQYUgEiYf4uSuLDXh3WjEIueWNToerHZIvR18JObZKgwd9iBNSTeLIinQMqMs65004w4nbe
	GZDkErFs2cJWseHf8VBXg25zAb1QZXUWE4mBGOBI4k3SdOlX+zr20yMKl+v1GnXlk6Jt/XVAsxO
	gj+4JYPcCBBI3gQqfD/vfoUHLcdTr7GFF4k6fJtNYYvkd056JG8yqej4h8qilwh5hcsNo1IqlYj
	5TmWzHlZSAhU7HsxARYaoatOvrU7n4QwJ8dw/+8Dt1fUlbcU7V2T5gYZpXJGao
X-Received: by 2002:a53:a484:0:b0:66c:e472:c792 with SMTP id 956f58d0204a3-66f988480bbmr298480d50.31.1788295494303;
        Tue, 01 Sep 2026 13:44:54 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f98656dddsm432178d50.10.2026.09.01.13.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 13:44:53 -0700 (PDT)
Date: Tue, 1 Sep 2026 16:44:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260901204449.GK3004@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1sxmosipgdzgdsro48ch18owizox6zh5
X-Rspamd-Queue-Id: 8E2B44000E
X-HE-Tag: 1788295495-690825
X-HE-Meta: U2FsdGVkX18dxLD+YGhqtUwBEpqWAUPkqdB0RgyKh1QBPeZxPYEtVYC8jlduqNDVV1c+kUy9FNVBaQPxoDiwHdqc94P6RASLc3WmK5iDT/OapJ9wxcggIAFHNFw1M3fQ8G8lexUFX1OVi1lw379gRpn6jzGonjNuRfWEl0NVXMBdro5wYB7ZYL3dnaAgjkHJeg0n7EPCnF4aYAN+iaW+FqNTLv5UDItbrdiliNR9ccxQN1AayNTFJ6yidk3nuBcrh3Zsv8UukGxqPEbI81G07QDpmC+P7zjFtieu7omYrHiShO09s6ofFbgWIrnzjCsFNcgogva00U8VdrKgVjloRrVRgVoD2ku5pqIJ5GkTfjy2VZXP1dnBpQfFoJr25EB+b5RPvZM93E8+Fn0ZW/l/i2DLP/2HZfS/yV2uy4Yfavu9WLbWMBkKkIiWtgXxW5yPsIwnfBic84a2dvGBfQYh1IyyjIpkgVIVddYRxFtVQXm3zPuIno9anQn/8xSOGGbssTDfsNiAnqGYiBlTM2yTD4RD4EUh7pQRIfEqPHQWMDdImOtjQgFsPjg9MOFXVMz3Xuj1MWXGXKqs4JlCaq1uq0mExNHxS4XX5p+y03+2MeK4ETYO7pZOoEPxya+L40liCim5hUPDIKYUl+kPd60fhXppzJZ+UPoknyQEFbGYS9je9f8454qtx7oLmJqAaoOf81EF9G+UaemxkZehKtAEF6+lf40i9a4f3Cb0Enu3Nv1e4KzKO3o7VkKJ9zD21BJgA8hs3qh8cgU2UrM9QZYcvZ1ZUU64lFu1PPn/zDPF6qv35kT3bVig887ghX0qmTdfZE0J8hqHZRrz+wyTuSZVcqKiKqaKjVXyr6KBT/wU89CbJuqamVI1Dzev/VLcamD2K4pvVUYY72COcGJATSQwlEB6iEq+Jj8led7XJG2zznbLuxAWjeJpGEF1fMyR/TrFsC0VnG1rdvcwvEmmpCl
 UTF/lzc3
 Z9M7JOSBasKXBBdmW3fx1D7AmiKMDXvylCPgX7nRc9vU1XmIL98wHw1bb+b2YgdPxDppT1ALjMG/V21aTfFoEg1VSlIjLIcgl12sFoWrKjb764gcKfyppnrs6plvC1nHERdU9Vi9OU/EiZaVSxvc3WQaWmfvSFyv2zpX2VFGeXsJ5CG6ifOPTWIJ2xsyMSlVstpwQGmelskWmkZyZ46FvOwBlKJB+0dqzcrq9GCTrdVD/MF6zo7gmO7QOl3rZNxNjgBa5QpQGJdMXgRmtc3ioXKKyKYEOBjmLcGM40zavQqjL4YCqEH2HWQLmb0CJpg8uqO3XdZoj+LqR8P5m0HRxHFXdjWINb3yh8SA1WOHegj3Xg+lnwFxg7oJkivvyPbZ+ijuEqSyd21FSg2oce8M6NkKDBVMIplq4RiVZWsKWBd4N/CGpBSssFoFdmNlHu6mDmdqF0lggi9TZvpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.

We've had problems with compaction before when min_free_kbytes was too
small on large machines. Competing free space scanners do a lot of
work only to fight over a very small set of possible target pages.

So I'm a bit uneasy that you didn't include any benchmark numbers with
this that prove basic functionality on larger hosts isn't regressed.

> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone

I question whether pageblocks need to be 512M on those machines to
begin with. After this patch, you're still asking the page allocator
to optimize grouping such that 512M pages can be allocated at
runtime. Only now you took away part of the mechanism to do so.

If you're using 512M THPs, I would kind of assume it's on machines
with a memory size where 5.5G for defrag purposes isn't devastating.

And if you're not, it would make more sense to lower the pageblock
size to the mTHP size you're actually using. And that would fix the
"excessive" min_free_kbytes issue as well.

> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.

That's pretty handwavy. How would these changes specifically eliminate
the need for compaction scratch space and allocator fallback options
to stave off fragmentation during placement?

