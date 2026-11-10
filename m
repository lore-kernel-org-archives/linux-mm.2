Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F022606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oiJ6P8LF
Received: by kanga.kvack.org (Postfix)
	id 893996B00EF; Tue, 10 Nov 2026 16:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CF66B05B0; Tue, 10 Nov 2026 16:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE1B6B05B1; Tue, 10 Nov 2026 16:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 431D46B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:35:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB98A120133
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:35:03 +0000 (UTC)
X-FDA: 85420514886.13.3A99BA4
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id D7E804000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:35:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oiJ6P8LF;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794346502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOqbf5f8IOrYsXobBY3T9L29gUMiYe3oysuU/ey3bJU=;
	b=uk0Oql40/zR9NMGgb/JSaIh/xE+XwWTJnxf+gYiicZ+PcRmpWwstYGkssYmAxk2aMsp8b6
	YRclbP7KRT33UB5Iq0tn+jMtsYbx7/JvPHwpx/Ay3m+nofPOj6M6CfmHpCsBwHgxsuHKrs
	4JFTTJO75sWVCoFkvjaAqptJFkm/P88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794346502;
	b=rn4dmGvCm031UTDq2UimmeE27QfdDrqeXewKIuOaDG1l644lpbAIZhz/lgFNdt3EYhO/e5
	CXrZAB+mg+nG36lPMZg7rc2hydYWEoK5Xfx5zrIIIjejKJSNWd6LCmNPAY7tnMAPhR/KEi
	gj+zH1PPeW26RwhvGEDCK71pohU475c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oiJ6P8LF;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso1705381f8f.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794346500; x=1794951300; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mOqbf5f8IOrYsXobBY3T9L29gUMiYe3oysuU/ey3bJU=;
        b=oiJ6P8LF0WEqmpaSlkb23eZe3cmAmu9oeO8R/gfcK0BSLXie6wQPQ7YV6AMrp9gDG+
         yOqFM9tF2OQfSYSpDwi4oLuqzCa55DH8CK7jCu328F+1vns8+pu/WpUTOFDa9zojqeqT
         8JK8ahTWWvucrKZTS4CumE5ZfemVthbTyjk3vfOkk+dil9InZvBD6Un7eid0nxNNYxAx
         TjuVY8eELaDWHCu+6MVnmh4XAShrEKzfY/F1tk/BMnL0ruLZauPc11H8wHOBRd+z8joc
         FMEm7dUE2uYyoTDWPGeLZy848fqM5IC4b0oRl1jB8/aK+M2UobnGiMi6qh7k8cKvRAcq
         MSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794346500; x=1794951300;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mOqbf5f8IOrYsXobBY3T9L29gUMiYe3oysuU/ey3bJU=;
        b=kVdb375ztK6btk8/7wL/K3b+THsKBC3xXUsaVH1DpuXNO2Z1oL4dFEA2yfZwUOf9XP
         kobNW4kdq7sC85SRkW17awdOmH/FmfNzswKx+Owf6QJBjU53ckEvDtTdVsaf2ZkMlduZ
         vSKTiAtfcOeGI7FByBobM3nypLmOlAJ+8wrbnLvDnGHcGDnzoGtRCcqInSo2iqAGgUcJ
         1sz0PbjdUQwcmeEnxzYVYi7USNf+1Ptq950EEw31c9zzJgVSdHKu0604Nf4eR/G3aQK8
         1YAvU+P+tKNzscfLBDNUWqhQwppYhDlVmWEMSJk04Ue3LKo6JQ63Hml4/bZdxCnTb9OH
         rGCQ==
X-Gm-Message-State: APuU4Z/HTxHhb+Cog7PlEieJOEucfE8bPn7BsFEy1JfD1Tf5nbsZ7/HN
	NM/FEIta2omasLbXkFFWdPeY3yCFrRFMdD2XmuCf8JUZzuG9I51QwNCf
X-Gm-Gg: AYBFou2chRYo/D5lJ6UHms642hZhSdMmuzvIe3Fno+Abiodjl/AvQyj1IIwNKMnZlcn
	ldvciDwtWeuW8lKo0LkSfWpKeAnKPAC3nNOuOalKuCRLmm1WTUgzN4xXgP268BgVYz964tUCjic
	y2tkkyfYp9+uOxfKBc8ZYYcGIbVFB5Y0dJd+IP/LwksKs8iwFNB9IJJWeCa2tN+reU00X9qS5AS
	InrYUnHbT/r06I2NToZXP9wzTjDsaRK9kyDyOh0NtbF81GOCVTalz4rburA5NzvWTyeiwTYMmo/
	f3BxUujTdWHiz+ndzeGyrv/RScQeLaGlv5vmEu2VNhFQ5+kpLa43BHe9/znb8Ymb+mC5NhJLZBY
	Rl1kzqQ09flWyOl3mb0Gq28SCBx2QMVcPT5G4/HbBDPkFnjpo6kWvXfuXKMXJBZE6dKZP6EnspD
	R9CAYlYrFJyptaAgHlw9yWxKezZF/zkGMIpFbu0bBRWivYfGKObq+8LXmcDij+G8ijHLRNqivuP
	6SYAiolEfLvKMLJ5vupFFhsc4JDgKZHSrywQdeaIcsSZBhNb+jVyA9AvNzrugC9qDXQzxsxvgNw
	yOrkNj/oHJx72ohsQi/mR2ry
X-Received: by 2002:a05:600c:364b:b0:4a1:d766:758 with SMTP id 5b1f17b1804b1-4ba08e1f572mr8423245e9.16.1794346500171;
        Tue, 10 Nov 2026 13:35:00 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498369a3fd2sm7670526f8f.52.2026.11.10.13.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 13:34:59 -0800 (PST)
Message-ID: <cbcd04e6-b0c6-4a8b-9f89-4f57a4c50864@gmail.com>
Date: Tue, 10 Nov 2026 22:34:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, netdev@vger.kernel.org,
 stable@vger.kernel.org
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4brqzo8xa9wjfqbop9otufyikonoq9gy
X-Rspamd-Queue-Id: D7E804000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794346501-275260
X-HE-Meta: U2FsdGVkX19nmzOQ2fLTgnIrkqY+KWZF29r6G11FPLUjMK5vqICrkLPPijVir+ZPZqCYfPwUzgRjvZgUfVeq4wfXeSz65/sWPa8UYH+ctPuLBDeHOXRjBV33VEoONwOLEeRD8gaPU/XhPGQXEEYkaf4gmWNibGyIujgHhE1UA8J3CeCyGS5bV7eO1vGvrG867LsvWP7d1zB212kPPanw+zoiCFie91xKn1m3+oHhmdi8R/ayQJhUfGK0b6DjIhLWM0xAgQYzirWj8cC23q5Tcv6yuXHoZoOXt+/koRv1Jm9k10rLRXABmW9stwes0B6dPqQBCoZ/P6Lsh94k85eyekZxRDUSs9ZbV/BVawonI7kLftF9kiaY3Qyx1YW075+7diEF4J5JaDI278EjIofC7TRamu5Cr8iamux2dc3XRJLptPHOCbsirBM9DQ/TmwLA3hw8Ak7rg4sUi3IIW/aSt3wfbVdPecQ7qb956FlOJlNhw4VjWyuEoVlkqifWyEFm/vE7J4/rndsyJzopd88I6IzZuNxI8UQVGvUbY+/+LhoZy/lDAt6g2jb5bbcpl3l6/bVGMgj9+FHCog2orDeEmMrJoWjiJbMgn11TliKZEcj6NiWuAOgKUdW6uHQH22qze4bLew11E6no9CQrAQvHmGUtDP2H2FL7YOxSPbsS7xKDeuqCh8yxU+qUPRZdn8YEQbq7A1PdjHGvvGS6ehNJpXs0cOilfoQ6asDmW/aB5Lv9QDfXG63RkDgjIdzE6ejmtOtxlmkoSBFDupcZSNQvVBW6sMAcukSPLBPCR3sOq+dXd1ODny3OA6WcG45VK9rRcrPDgPsGC/EYaWLFYjzQzhTzbpIehUE4kwZwkcTk6C1TBsFtH+6K+LsKYL248C22Z/eCCCIkr/XTH1NAfquZBuCYnZeMxWpFUw+MSDLUNiNdHZl/Z6eIbPHZClb2gdCnkaLH6ppMbpI7bzCH628
 qPkY1d1c
 EtBTuE7h+ghZ/sMeiVEOONvqoZDn3i5ZXbJCVXenqkOnxbMuEQFDyKyK5cOdEAVa/6FomJ32EAPr64kfCUaesVK7xJt2j+XPtWbEJGPBq4IoOvBBkCYq/3aDSjMFrJW/x7/V3qUGIk7KTnXDvH4uAkiW+qrXhCrbqhv2I2FrzbpZ1TXZo93XtxVRl9yt3+vcWpQ4o4eOsEapn89KngxEiZkIsSY3DPzATBxvzMLjJFBuwxzJ4LsZKlZm2wKtE9OhlDKrk1H3WSQAhG0flTFklj66aEIGHNTidVCpcd3WzpYCjdYa4z+6bJXR1Cje1u4hJI+Djp4kRJxdvIKhdZq5LHinAI/vfhMp+Uztx2vlW3hyA/YsXdbYDoKlusy+Px0gE+lbgoPIBdNZo9mSX3EwcH3jtmj8sDlRAs+V5QTUmMIbbmJsdpfFflhx0oL3YknZbxsncbP0DrYWDjO1jnGofTQkllwzme/8peEGAzdYxiOIIkrtRGuje7lvr89tnYODTIfJl8xXQhdsQm6wv8Te20bBC/X9H3xRf+KMODEHSB7zUiCdx1lT8UJG/Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 9:35 PM, David Hildenbrand (Arm) wrote:
> Similar to mapping pagecache folios into page tables, let's reject
> additional references when splicing folios into a pipe if the refcount
> is at its limit, similar to how we handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Introduce folio_get_checked() for checked reference acquisition when
> the caller already holds a reference. It warns and fails on a non-positive
> refcount and rejects additional references at the limit.
> 
> Use folio_get_checked() in splice_folio_into_pipe() and
> fuse_ref_folio(), returning -EFAULT on failure, like we already do for
> pipe-buffer duplication. Similarly, make try_get_page() use it instead.
> 
> Likely try_get_page() should be renamed (or removed) later, as it doesn't
> match the folio_try_get() semantics and is confusing.
> 
> If we hit the limit after splicing some data, return the number of bytes
> already spliced. Teach the callers to handle errors, and stop
> filemap_splice_read() if we only spliced part of a folio, so we don't
> skip ahead to the next folio.
> 
> The check in try_get_page() also covers pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Note that we deliberately will not fall back to the slow path of copying
> the folio, particularly as the folio might have an invalid refcount. If
> it is ever really required, we can revisit.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM :)

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

