Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DA9E67A96
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675A76B0092; Tue,  3 Mar 2026 03:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649D56B0093; Tue,  3 Mar 2026 03:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C576B0095; Tue,  3 Mar 2026 03:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 412EA6B0092
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:28:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAAC8137F39
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:28:33 +0000 (UTC)
X-FDA: 84504075306.22.8FD2152
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A932C0011
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:28:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXGVRPaB;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772526511;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvQ9ogjqY7GpWZR0jhfLALG/vdl5wh/KcgbqbjmLgoM=;
	b=uhxnLSP7zkSCiuEjDSelRbhyZ5fuSJfq3whBncasbZqExsmkHGyJlYJcbb3h3Qiy3F4hM8
	rjm7yEL1wZO4FdXq9UcroR1YwtA+L71zttF4U/2PZqaIrxaJKB6EFBcZcVx1SweQKtNWbj
	9HJ5bO6tIbhHp33G+iWh7W5LLpMKu3A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXGVRPaB;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772526511; a=rsa-sha256;
	cv=none;
	b=2Zarkl3KEn5cixXyOzxf6gqXNYRRq3CS+Af+/MqE0lPWUmP3QU3uLn1ug7bPWjJkQGmKxv
	G53+SuLMM0sSNB/qH1XdcIx2XC6IcmGptOVd4utA6bDliiTIdzNg64qxo3ztxyzDsX7dsU
	QPjp7XvZAetjh162tkfTJtGXZak7sFs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b936331786dso581845666b.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772526510; x=1773131310; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvQ9ogjqY7GpWZR0jhfLALG/vdl5wh/KcgbqbjmLgoM=;
        b=cXGVRPaBjCAawnu03Xaj25L2BNhU5VM/qNYWTfWXe1d++BfGz1/AgQN02VmV+Tjb23
         xZ70qlHIZA2s3Ci7s4OC+yDeqGO+1gV50R7LXE7s2wizwJmYYJDQMcZAsqOQJbKyqJiH
         HR6BBlIuglIhQAPXA80eHKG6bykTQCGCwf00SYGbJqA7VAFxYuEJNoo2O5WJybMKg+qu
         WUjkZj9c38cmbZeOyNYDJ+uJ9WYvsqByqjPA61mBIUpIpTHoSGyGycrers5MYfjky415
         k8vdOZtQSxs5JKrxGsbOMXv7QPqtUp3XmmgWwmtXwLvEPRT5SaAYXEjrTocJk75+AGOp
         GZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526510; x=1773131310;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvQ9ogjqY7GpWZR0jhfLALG/vdl5wh/KcgbqbjmLgoM=;
        b=vkgPzbwLKv1OsfQmueCBxqI8ylW6lYa3EivxGlHz0N3+FAMOSWQ1unE/iBC7HXLGvP
         DbfnU7vxgvBdozwUfvXsOLptIxctAhq8/ThAXZ05khEPfKpFi1jhxnfj0hDv247+ubwH
         fei7yNPpXgOABTFnADuQmVc8YqeSKI9hxv3R1e1f/IIqNNC+51ookhHL93bjv0UiBPBH
         wTRriTrpYaLHyEUmFBnyCOzWyBGxSqwc5Re9yrlRHa4c8k4tAbJ8jZO9JR9SH/woTaEl
         ESJ5pVBhOcvR/ub7gvHpit4Kg2oLZOZGTHcv9ZUxXC0RSYZ6vFd5q6OJVWEDJG2eaa0A
         c/lw==
X-Forwarded-Encrypted: i=1; AJvYcCVWAe3eKqPafNXn5slh0fLbQTrRO0XOIugK4vRM19TZ8a64HfiHKa5RWvDq32GHbavXpOBECaK1YQ==@kvack.org
X-Gm-Message-State: AOJu0Yxzsa/l4usQcG61Ns9fMAfixtr+/W2qjibeNUzOKcojazvgnewy
	uU8IyD3xAOJPhKfzzJu5rH4NTphvdjJpW6iqEAZXgzEoVkolJ4iPrLfs
X-Gm-Gg: ATEYQzxx5qCMyWydxZa3pyDKMdYocBIoWOyvWE1kdt30DaM07Ty8I+2VhE8NRBW5t2r
	WLPpmp8ABKOVBtL69cIAKO8j/NS5hlpoeIR8uNX8/vUtEooOdSELhgX76WhOXBJYdf/nF8vciVC
	lLCYgYKpy6UH9+e/jkTN9fBbqwuFkmaJQxkJ10jr2w+FAmflunniE1jrDqyCo/vj6eU2/vYi/pN
	88ruwpOjumKHgI/DRmXe0I/ePDuN2K062v/MnT5I/8C5XRLLOnMtybXCVZnPAEHprMUp/lBQWVy
	TAxMAy+2I0JT7XljAWVi4L3JVqZB8q5Zs6vcvuw19iYgTS9lHfMN5y21tDPKwG9dmf/msieOUW0
	KvdIQ+B0qfT2xkusMyijUjGAZ32Kpidh3czNw+ypMNk5WIt63unRibKjBT/dsT1aGEfnfMPaLrB
	XR7kUDUzNnwgE/yG6LUuHK9Q==
X-Received: by 2002:a17:907:9492:b0:b93:94b9:26fe with SMTP id a640c23a62f3a-b9394b98ceamr771288166b.52.1772526509327;
        Tue, 03 Mar 2026 00:28:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac70b01sm559271466b.23.2026.03.03.00.28.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Mar 2026 00:28:28 -0800 (PST)
Date: Tue, 3 Mar 2026 08:28:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Bas van Dijk <bas@dfinity.org>, Eero Kelly <eero.kelly@dfinity.org>,
	Andrew Battat <andrew.battat@dfinity.org>,
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/huge_memory: fix a folio_split() race condition
 with folio_try_get()
Message-ID: <20260303082828.x2gypytceqn6pb6x@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260302203159.3208341-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302203159.3208341-1-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A932C0011
X-Rspamd-Server: rspam08
X-Stat-Signature: yn7iaxpt4d7ex8afa7tnqhetet6n4ch4
X-HE-Tag: 1772526511-554092
X-HE-Meta: U2FsdGVkX18Pzw8sN3Lde6T3uwKuvfftTWzcWaa1+zmdvLYQ5U5geTyuannBF/yg+YbQ3CgW7ZvzPFSybnkfAoJO3no4Mu1OJc0AUpURiG4fHPx4RqibIkKSZOr0JPQb0ryQlvGdHQGTHsmtGDle2QsT2rvrYgbSZEMvvmXDE3DuiH0vhoum0XVPLviPerkgO5fvXfvlMcjFj4o1FA5sKjBEhZxkl3eKtwwBcApT1sA3z4/JZSlMG6e6Tnce919RH4wcJiQu/CtGoFv0nGaGETOk+DgHY0/2OwHedX2+bHzQC2s5d3uzwt1bG/Z4K2JgwKH4QePPtI6Ey+dOtENDPOfgQ1f8v7IS4yLbckWtAnCAWbmd/BpceN88Lwt2lPEU/pX2olfJNlpea+BgqqavS3ZqXKnlhZSlS+SH9DAUvO6WozxRInC0yksiSli0fDt7orX7A2Wq+tJ6Jy8LhqFY/YmSVLdsTNh6W7/ECbMweap18r67/DsgGH0toYQj/yGv2TAqYcjdu+f8OsPgX+5SY1TPb0gALhvesOlswVWN7cBihMWSpLCG4+GiySEur+WswTBArRr9uHt/ROS4dOsuxYZChFaCMGCvatRfuNgM4dzKZsJak5pl5i3PVGvst01QgCWBmFMz1CHdd4IiDwKM1RMswyNE3orDIsSPRjPsP8FmVLsBqmPAtW4FRZ4M+876hz2LH2063GVhQ0aVBxP6geWG+g2m6TD9zwQtmerVVS/ZUeI7h2sYCnjmalmUz2KGW0Upd/M/mkn7xbZT5B3TihV4ZNpnjaZcobP5ouOqT9veEsuqRqpZbGmPV9cshs4sCZj+PmxArCzl7AsuxwtVNqGV4xS9A7WuprzRW4FnhuuNx4f7Y7AObwpFMuhEksJrkUP0z+6+tLj1yna37deiazSfdI4c+j5QgI8e5fGAMnM/J0F7i9UK1pR0Bffl/jm0RaEqPzb4t2h23kZ/8vn
 y48hwVC+
 4IFj68tww1LEmD1GfwEHOc9X2NYW6X/nTWfqiVT+EdbFUIGmhTDFVpZHXMZ8KzKsKuKX1voWjjSyDWt2QG81flxWIFmMYHscGDh2Lc6ZO3gHtNt4uZGkuxpV/wSmpcm1IJyC50EarFRhXDB23yCnJNogksFIgzBkPn+ERBg3prI//MV0/nPq00FWWxBUVpF2Xpq4Fniul46aK8V7xsgcFpqlhbDT78S9s1lhtxqtLHFTWGKQhj5obM8ovpzMb7Olu5Z542es7m7+2Ie+1gsISocuuvvr/w0lb56uQJnm1zISavZsobJFG1oVDJMSwn7qmfYU85R1/+9TCMJq3IcUP0PZayXEuwcv1Fb6rL3Og6CiTTwvoZciRa3RzMxIFuPKBZKZcCq3E6xIu8Z5dvHFjBsecQ5g0FSiRVR25MAj4KXTIstRvl0xvgcLQHyAqgCD3aozhNi3M7P7x46lCVt760JYz+zUi694hiiqYciIDk62RUMiGDJuUZds7fP2F/qEJKHuBacWbDnXokAUR3/kmTtbh+px317hsrZvQ8mrxwNXLZ05nkB7CwGjJluTifqRfNeOybJoXdZ5XS6jJGV69c7quTJqTuxOUwZX6bwa3/d+m2L7cE6LxyrRpm2jPemxu1KsfK03UeWDtVxnnRyMBDTJNCEj/gVx5swz4/GPXwiFAvQ1XelAXx8T5INGKLhDkyNoPuO0Bthj4oAvYzQ9798i/ctkbhjviEpvWikMVTw1nxIIak/7TeMKH3rLew+59fqMQIDiurSL2mkxLwA4KJSQxKbRkEN9xW/nT0hM0NrGJfCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 03:31:59PM -0500, Zi Yan wrote:
>During a pagecache folio split, the values in the related xarray should not
>be changed from the original folio at xarray split time until all
>after-split folios are well formed and stored in the xarray. Current use
>of xas_try_split() in __split_unmapped_folio() lets some after-split folios
>show up at wrong indices in the xarray. When these misplaced after-split
>folios are unfrozen, before correct folios are stored via __xa_store(), and
>grabbed by folio_try_get(), they are returned to userspace at wrong file
>indices, causing data corruption. More detailed explanation is at the
>bottom.
>
>The reproducer is at: https://github.com/dfinity/thp-madv-remove-test
>It
>1. creates a memfd,
>2. forks,
>3. in the child process, maps the file with large folios (via shmem code
>   path) and reads the mapped file continuously with 16 threads,
>4. in the parent process, uses madvise(MADV_REMOVE) to punch poles in the
>   large folio.
>
>Data corruption can be observed without the fix. Basically, data from a
>wrong page->index is returned.
>
>Fix it by using the original folio in xas_try_split() calls, so that
>folio_try_get() can get the right after-split folios after the original
>folio is unfrozen.
>
>Uniform split, split_huge_page*(), is not affected, since it uses
>xas_split_alloc() and xas_split() only once and stores the original folio
>in the xarray. Change xas_split() used in uniform split branch to use
>the original folio to avoid confusion.
>
>Fixes below points to the commit introduces the code, but folio_split() is
>used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
>truncate operation").
>
>More details:
>
>For example, a folio f is split non-uniformly into f, f2, f3, f4 like
>below:
>+----------------+---------+----+----+
>|       f        |    f2   | f3 | f4 |
>+----------------+---------+----+----+
>but the xarray would look like below after __split_unmapped_folio() is
>done:
>+----------------+---------+----+----+
>|       f        |    f2   | f3 | f3 |
>+----------------+---------+----+----+
>

Thanks for the detailed explanation, I finally realized it behaves like this.

>After __split_unmapped_folio(), the code changes the xarray and unfreezes
>after-split folios:
>
>1. unfreezes f2, __xa_store(f2)
>2. unfreezes f3, __xa_store(f3)
>3. unfreezes f4, __xa_store(f4), which overwrites the second f3 to f4.
>4. unfreezes f.
>
>Meanwhile, a parallel filemap_get_entry() can read the second f3 from the
>xarray and use folio_try_get() on it at step 2 when f3 is unfrozen. Then,
>f3 is wrongly returned to user.
>
>After the fix, the xarray looks like below after __split_unmapped_folio():
>+----------------+---------+----+----+
>|       f        |    f    | f  | f  |
>+----------------+---------+----+----+
>so that the race window no longer exists.

Since we unfreeze f at last.

>
>Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reported-by: Bas van Dijk <bas@dfinity.org>
>Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
>Tested-by: Lance Yang <lance.yang@linux.dev>
>Cc: <stable@vger.kernel.org>

So thanks for the fix.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

