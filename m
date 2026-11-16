Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEA4606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cyQR5Y1u
Received: by kanga.kvack.org (Postfix)
	id 6E76A6B00EF; Mon, 16 Nov 2026 13:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697E06B05B0; Mon, 16 Nov 2026 13:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586BE6B05B1; Mon, 16 Nov 2026 13:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4E06B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:13:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B28B1601DB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:13:58 +0000 (UTC)
X-FDA: 85441780956.01.F5E2B6B
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF451180010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cyQR5Y1u;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794852836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB8RDKJrvT0rNRs0LLoWAJXFuxhaQ7Mxjj9sT6tzin0=;
	b=Qz0sBURo+qCuZ2RToZI8jZiqPSqYyz8UWmi4VkwQfeUkaiKJ3EVPF8/T2t8nLcT8N9MxrH
	66IbOhiCe3++vQThpV7r9oM2lE9WhfM5LnStEf7vbYoLree3WPwS+6p21mMmhkgmH+NN9S
	5s60lrTGbWzLjLRiUzFI3ELWBnk3dko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794852836;
	b=nSbryzn8UOlK3gYQssArjEWdNzzvOB/OKqwxKpwgJQwcHYEXaICxW0WcU9M9ULA801b807
	tZAzKNVysfEyVMV23g3tNCjnGUjrJ1uikMDejDM61HDNOy2zIjU802niyMR/zgwYsBOQCt
	Xh752mlar0NkCjarBQyEpKopCDHm98M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cyQR5Y1u;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-949680e6d82so189789985a.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794852836; x=1795457636; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mB8RDKJrvT0rNRs0LLoWAJXFuxhaQ7Mxjj9sT6tzin0=;
        b=cyQR5Y1uinmx3xs7dkaHHDykuaBfLygWfrz/CnlSVXJ641+G0EJvbVAbgzamJnmNnM
         5a0ysLpkBehuo1UrRTQbFflGHBNmJUVh0IZyoePzl1F0XuLt4FNKAYDMQaCpOR6s8UXC
         AlvAR4m9y+oQadGZBUFLfGwS0vrpRtW0TwRELYgieLXU/B4boLNzRPq2BXEv+pIS+isX
         BpxxgarD527oO4VJduxOmVZCbro3NNXIpmRgdp3TqEVqA82o0PcEvwi6v+sl4xx/zS9a
         p/C7FoZu9T7A18xPqDF4lJE2BCgxDxtdBot16lDt8syb4RANBHufY672QtoFxXYw7NIu
         3oUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794852836; x=1795457636;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mB8RDKJrvT0rNRs0LLoWAJXFuxhaQ7Mxjj9sT6tzin0=;
        b=BLKVWNz/Sw8X7AV+W6XIzRyynnxnyCi5Nr4hZcsDq/qtJ2hE7IhYdS0tpoIVVgqFX0
         95GEbko5SXuM6QLX4E0d1JqQPhn9qhqRatvggoSJ7XmHuuRnNdoFwyYy0+lnbwcC/dTu
         8B812KmWUgcS4j9HTuBeVr8NZQNfF++JGKAUJ/k02x5wl3IO+EeiSA+eB07YMg321W98
         n59TXfgq3WutpZTVTWcDvLQYBL/SuhTwOF6fSGZ5LAbO2doQ5B9TQPKdHgn/72IXbVHA
         UioZsaPMt9p/A2SVNuGEFtYz65h0VlhVCWESSoSKp1Ie3IktR/JytNcj80gSzLHQN4NP
         W5AA==
X-Forwarded-Encrypted: i=1; AL+hErHBAtqmJU9pgvGSxRZyZUoHFRRQtPqurhhbnqjKa5harVfoxVkhARSyTQXNdzlRT09QntNeJxmusQ==@kvack.org
X-Gm-Message-State: APuU4Z+Z1yoPYgyocRKltshtOKlaQQa5mdE/50+iJjAhcM5e+6OwDsHZ
	qUV2GdI+VapSy8avuMwvL9dYYb52tVP5n8qCPXzDCVix3r7yz0hX2+czknbdsH2lzIU=
X-Gm-Gg: AYBFou3CgtBlMghTm0DBLdNbTxjupsOkgTPb6gNXhFxMVsF+ckGQ2fFE/SkYn1CT3Vl
	7qwOLJfx/WL8je37PMpN0u1iodLdcmjB3/dhdpr/qJHekXAJs0ACYFbJ0boi202uqjWb16jSMmr
	g9rQF9JHtW8rirEF+FC83l3uisqQ448v+XSVpOKIxUNOZr0ylwz5Sfk4U2A50DQA1e3+SAYstYD
	jJ9+6sab2xZksMyB+ySVgz1ftryFljwZkIPfjrS4zVI1KUNlKoyiBSJVyr0WGNfBnxefeXkbJEE
	/cDd/ZulAsuqCLsG8PPspOuoHdzarvpStVYHNH5pV/vCuPDysuQq0qA81ZAGGSPM6PylKcwpbbQ
	THw+QIVDPPLxV7bVQDzguSKUOHO1IZstI0G9N5gyNizvnaM4t3UPNVno78Ex24yJBb4/54fl4yx
	jdJXOYhO7WU1dDRPZ8ak6ovBDPxIYbiANZ1QnUjZ2kok5shZdKfTKGfs/FIrCuJTteBQEBg405m
	G06Imm5nf+Pa9vE2Y7MZgTk+8GZDiGvJ7gcmvota1bH5jiHXaS14p1j+60Tf2S7ZFoCbpMfSaSU
	WVGTle5bIQPxB65Lfy5TPHuC+q27Fk/bu/i6MpWxL7nbWUh26+XlzGcKAuUOTJtl34U3FX+fYv7
	rGfdRatI=
X-Received: by 2002:a05:620a:6c8b:b0:947:7f5e:2b63 with SMTP id af79cd13be357-9494bad303dmr1772432685a.34.1794852835505;
        Mon, 16 Nov 2026 10:13:55 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d70918sm90840106d6.22.2026.11.16.10.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 10:13:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/3] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
Date: Mon, 16 Nov 2026 13:13:53 -0500
Message-Id: <179485283354.482102.2633605640287961592.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: AF451180010
X-Stat-Signature: 6i1t6enb6nbqg9c6h7w3gzwipdhoeqya
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794852836-970164
X-HE-Meta: U2FsdGVkX1+jS8jIQ96zA6rCfaNYF/Nnqv1o1Rxx4KhaBp9e9Vl41S5jmqY9PGEyp4PssG7fsgm1A8TBGCsAfwF897UqMmzl0ShIfWQkdx4MiUpqsZrDQBlUkxhDe1xKy9rObX1NkD/SFSdjo97bWnIlUSU2zhKZ3qGVYPSbdx1HcLd450WedpVs8n1DSWSPWWQvKbutAcsLJ1XyAdudyUU0Dbm0JddcZePB3OFrJlEDgMH5QY07jJe3FG0XGbsVwW8LRD7uul2BUv2T+vTs+/O6vK4hbS+vX2rR7Ooi0BnnSmnVYYwZJR5DY1Vv13pFw0iFwpe//qgCF7hBX8mFOsUzyiVJWotml5p++scRpS+U4bQUwPpUu5QH8ufuQv4fN9XP6jVdIr0+++bY/CPMxXbRfx95nNrdZRONFaY1Fz3NIvkq4z6FjyRKHjvMf9gjm0tF/OMzV+XPtPe1cHzP15MwJUs5f/+7h+umbtw+fb/q783uSgpS3R91jqqI/GuyCbAZTD8pJ+KHClXmz13FfaSkk35PM2gsejAn/gfKDrsYQVAXCANBuxAnpZMYwnPOUDYsQCrOQU9mfgZF21o1vOmROuI1GDCu9v5sqRVZcjJqRkSFqz1l3Z6SYrnUQLk1BY+qVmmX35s/X+CeyXKgGZcT/BCIGMpSKLtqPkkGc2N7YJi7K5KiRRXEKc59j0Qh5XvS2TFWs09dD3IkeddxWGiTsaGja4GQC2NTE+en37gGzJ6P12HfUXMAILw29JlrxKYJ9jccVaG5YLPYukgKjuV+j/BoSWs70akhbSx3PmsRtOfTiw/IqB0oHTJoHDVxq+rqTeiqpV9BO6ZAdon6vx2CLTIdr0m8jl7Dou3spCGARwiI1OhvH2Mc51bXEBw9+MKWndL9EUGsCDa4JkEGt/b5rPzwN10bPy1D/aqw39kah7Z0njap0xIIKFXPUjbT7Kz40MgTNCNQ4ZvkqdC
 W1jGqB+6
 oOtPWGpolV2bfK5NX4cXqDITh2NgnlGsHlbIUKE8cIxn+yKCGNR54bX+sQXVb9vCjSKX2yNBngUNIrDwB0eZDcC2nSEIFJuwoV134+a8K+qSKK5DCuNIReDh90DWtawxZfhnsfX9CjxVK5UTuJxThPggwVpSM94MnX1TqF/QQghrsxUyoivJniG7pT6ybjYC2Ks7Muv/237kixW5tIhHK8vpgmC6dz63gVN+vdeM7a85GMXyZHPnZHKtB+nLWvBXxJE/ii71j8+rBkXklEkzXSv6z9Znq2V5PnIF7CKneP0HwW3atbqkOQ2MDsMzpupyzfqhUJXw4LsqTxaBBi1oTNneCAhO7K2fB7ndEUDMNc5JfekDZRrRQkSztERytrF16q5Fb3xsmvfV8f8q1XGF9PGyvldMaBkmhJnSNQovwbJeAsmP0ECx+2GfECA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 20:58 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> This is not currently safely handled by insert_pfn(), however, which
> obtains its PTE entry via get_locked_pte(), and treats a NULL return value
> as an allocation failure, returning VM_FAULT_OOM.
> 
> The issue is that get_locked_pte() also returns NULL if the PMD entry is
> not a page table which can happen if a concurrent huge fault installs a
> huge PMD entry between __handle_mm_fault() observing the PMD entry to be
> empty and insert_pfn() being invoked.
> 
> This can result in VM_FAULT_OOM being reported incorrectly.
> 
> Address this by proactively checking whether a page table allocation
> actually failed, and returning VM_FAULT_NOPAGE if the NULL indicates that
> we were raced instead.
> 
> The same assumption is made in insert_page(), however only DAX implements
> ->huge_fault and can reach it, and it serialises faults of different orders
> with its own mapping entry lock, so it does not require a change.
> 
> Target the commit introducing the first driver able to do this.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message, trimmed comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested with the same test from patch 1, observed the leaked OOM faults
and this patch resolves it.

Makes me wonder whether patch 1 and 2 should just be a single patch to
avoid bad backports.

Either way:

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


