Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E302CFED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC886B0005; Fri, 24 Apr 2026 14:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE7C6B008A; Fri, 24 Apr 2026 14:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C816B008C; Fri, 24 Apr 2026 14:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E90C06B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:12:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C60CC1624
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:12:28 +0000 (UTC)
X-FDA: 84694244376.08.96D2C9B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 89A5F20003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:12:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rq6ktctu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777054346; a=rsa-sha256;
	cv=pass;
	b=i/aF6OWORH7lg+3poiQy+jbfz+MXYFE/6BgFqwL1EHddhuW8XKZS2XKCyLauJRRqy4k3Xc
	g6WJG9SILQWCFlcXdEVgbtwA9T9FG+rlpLclM399+k9qampiEX8ghOEWXz0ySVKZcpk1Jc
	0Ns29T+muPXFzLJoOCOyAecTOtgqSNU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rq6ktctu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777054346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnhjUMS+7vRGMqxTPSDvZGQVsqKK9m9gvsqnQgN63xg=;
	b=ECfA2EpulAeJNCSVmscj4nA3evrc0mMdfWUSEZ5R4N+SO33pRkmUa0Rjmsw7VexYcnqYkA
	xiDwJucbB8RStScqKqniTNZkFJWR5zKz8FWGEm1QRVmKqZyExk+GgvrnbLs3h2UFDuvAGj
	hhrJzVcIcOA1sn6U0PuyA+0VyUNSIs0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-baa8c78ac7fso616051166b.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777054345; cv=none;
        d=google.com; s=arc-20240605;
        b=PMzMU7UJNFgOXpsEO9xtEH5/HCYw0/k4rc9qZOKzyjm1h548CSldiPLv0ffQlLuciJ
         W/6Dz/rb1pv9Kgyj6ekX5SsWHQlf1G2fnaCQdVHn2vpkD6R2ROLPUPxlK2Ga5JZiETuh
         wljoHwOwGuKowjFav1infDVyuzP7UWx5LqIoHxt3EGONBxepnHRjASSzRL9xEoznFMjL
         wsIKuA7V7jrCYWaFAXf3/ynoxxQa4cgGWHliah4CMuOyQmXqzXnOJsvfNP5KtGA05YxA
         l0pEKFgfuVJ/PCzq0uteReG96MgEGjcJjITjv3Zm0nLsrul1po8AfQHI7Eyzvg1e7Kml
         b3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RnhjUMS+7vRGMqxTPSDvZGQVsqKK9m9gvsqnQgN63xg=;
        fh=hJt4vPX9BOZJrhgXfGhzwyLWA7BbAhiyRZZY4oegudw=;
        b=QMhtHf39Jv3dvt2IQRc1va4RT+4ecmyWB5wON0+0kKzLo8gM+Z/K4WGTR5cO5vj7z1
         DSPfZ/V21F2i120Rf4ZqZD771BXRiJ9hm5ruEo+cOtQxiGQTJNC59iRHZFgTL2Q3+eMk
         bne7tkEpA6B4Y9mzqkCuY32JqIjW5QZ4HeNlvQMgu/01YDWs1NU0MRX7zvszZ6Bczc+2
         jPTCorfBXXPbY8FQWPmhPBHKrYJGFodwb/x/IMd14g5Ab8F3cE7jqSGSaw2vWpAEwcLd
         /mznUAzgbII0FIqnYtnQfHNN6YnuJSqiBxX5xlrnY/lPL3X1rWLQZ/4HmkcYemfTaJ0I
         GuWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777054345; x=1777659145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RnhjUMS+7vRGMqxTPSDvZGQVsqKK9m9gvsqnQgN63xg=;
        b=rq6ktctuIx/DBc+b5pjl+a4dmfLv4o9TzEDoDxNwxaDOf/bYXvF7jbkttwFuRFIZ63
         etzmm0QcYTkmlxelwTa+gzsNDsZsH6Eo40cSI/t19lm5A2rL6rLIAXTCjrrptFiUjNPA
         N75o+Kc0zclcAPLS4W9bQIawgnpWJAOAIK326TII9SFk42JmRS0xHtU9ZzWKG7I+85M6
         S+wZ+8u3thwsAbGioo4hTfcDaTh44WgkDydbcgIO3QcsG7EEbHHQpPrTwVUhdT08e/Xr
         QB9HQk9M8pCNXmR07JpXTntJjMmMNFCt7quG8r2iZCUlb8B3Rbvwm0EZHm3oQ4869/Pz
         aFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777054345; x=1777659145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RnhjUMS+7vRGMqxTPSDvZGQVsqKK9m9gvsqnQgN63xg=;
        b=sZgrNZ9Nxrd+lj0+KICM1L4yL0AipUqMc/O8hFgwFq6XJjoNxXGE9+G7ZZUEsJfnf0
         pzX4+0BdSW2wIW/b2tzXhztzOemcJ5zIGMNbKqEXOk0FJyfHtFDwEiISu9rxrz5EQpkU
         O6wWSTQKb/X1CNWlDK/7GBYDar5KLQjmPcXLxc0b92tYmzPp9Qdl+7x/X6yaKYagx58z
         Lua5maMBAoZLNHzNIx2UIljby/pNdDbpoHYya7hoVrubTtEtbFVCNzKzhCq69XAuHh45
         TeH/veQ5IxdJGZ2hPfAa4/NTEVktrOq8rXl0GNPDxfKk8Ogw+iGRjm1azB3pt0ZjrP5g
         c7AA==
X-Gm-Message-State: AOJu0Yy+/8K41IQw0wPYMU2bUt2IInapv5wMYyZc3w07mi4BuhkOqEeS
	ejdRQbO7oHIKfKSaVpYZRP9/sO90XySZOKkjPFsCvJbvXKZZcxEOF7gcF0hegmWpyAtwtc3oe8I
	h9z3oFmEE2OILTJHW203Dc3noI8WVZbo=
X-Gm-Gg: AeBDietzsrQy7vf8T3xzpbynJ8K3AgamRWf2dRT+VDTdkBJkoFcnLJinJwYXjQ3a00o
	A2Q/Zah6N94QhwDaH3mleBvvmrE9bERtR2vepnYofVaQL3f5ZdICeQqKaAJkXpCeXEvob7w/R8p
	GQtsAqtv1FVkuYdHBVd2xD9lYa10DdXJd6Ycmp/7khcfPYfwrm1Q24XU30CHpOz7TdgYEQ4oyNY
	VHCG7UUHvJYLPkpVG7MpdzHinmR5Nl6TBuR38ws5/sNNGdkHti5p47vL0Qbx+b62Gc5079ytNFk
	IKH7F16agudU4CGVyTxnjFLj8XpBWjf6tYgJDL1njAPTUC1HUZdjUP2jDN3piQ==
X-Received: by 2002:a17:907:7213:b0:bae:5939:e5c8 with SMTP id
 a640c23a62f3a-bae5939e60cmr130631466b.36.1777054344590; Fri, 24 Apr 2026
 11:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 25 Apr 2026 02:11:47 +0800
X-Gm-Features: AQROBzCwwQUz70l1uZVIPaiDZja0dRtNfD-VSwBzxKUwowi_lCo6xqP0LRdDB3k
Message-ID: <CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fhkyigyyu39k3hxx7im73f95xkcjg1ia
X-Rspam-User: 
X-Rspamd-Queue-Id: 89A5F20003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777054346-321446
X-HE-Meta: U2FsdGVkX18353FuyUTWyt64Ow16oFqQViJg95qLv8dSjikPwVykzLx1ex1Y2jaRLfHFvybQEONDAbRmN9gZ+1Nw0ahy5M+G8KR14uTJ5wNP+Cr3lJ7joOcZt+uD5gFAIQ3mjn0d2Bwb9GOqxpsbMMWyFi+F3/ONV4T51IemvhYfMhDyNrQXTSZlLdah8XAT1jg9p0k+VA5bvRvASByV0pGm9JWD/Mz/NaG2UmT0Dwezww9JgfVnRK83kyWlVn2UWc4XpSP4ezYXAbxbnM8dpuKoDtY+LhIt4sxywBuAPDSuxsLYNIMN80v6wzASsLD4yG47n6jTPUTb2u1SQ+Z/vAtogyvU/PwR9+eVMKT97zc9m6yCt2WM/cWTd83ZciBEddQPBX1t12Nul3Ojlf/YlzSIq+YcDb8wuvpxW1olZYjhCaTTWz3fkHplEyHCmfBis1eekwlYNGfEKTQZDKL7VobkaUHtDQYUye8oPy1H19vP3WREe9QnvbrWvbWRe6C7O+an74ggMZ8G55nPzL0b/Fcrm3PGhHLmLl9k18lS2VErTnx81xvvCKETvYHWupsVz7X4Jqe4yn7DxTvVmYvaet/JFULqjA/UVKWOomPUSMPLiubjusLqjdIjKMHI+CcjhgsFXnG4ewMAdeDWvuhMbyTE/Ozt65DZPLkwgKDRtYHfoQnSbTIXrduzHylpkpG4hzYDqSgIDPDBZ7/f3oR7vF6eO7x+9EP3HZTwt4c6gtmcHDMd8QbE6FKSCdoNtHj0Bazvdu2vnfd7wFmSFK1GswVGEKLrJjQCHCvyTIzZiYlfdTgp677WomjNLu/rZB+hmhImliSrnXpdWoygWYu+gm57Ho2BOwc/Pch/7jFJbshe6V+bUWI1EdwMYJDicvo7nWfnui/DZFou5kGyq5EJHtI89cg1eba+U/5j8fYACrW5pB7NlnCNBtbgDPKh/4whHIkN/zRMZ284vtTT0Ho
 r3oBlLC0
 LHFI9Myo2Nvi0zPfQh9zKMmVqRpMZCYBtts8fxGIJX0pSz15DwaxBgDu1MYYQ33TMGvL3pBHV0BESBpJs99n7UYjYHeq2saTUVB/bivSWaAgeGfI/AlYdPxuUHkCbJmDgmDWX1Je5MTbbm3+rz52Iut68aPpChTT4YcfJr4D3P1TDICqq015j1TD79BgE0oXEfexGAKg1HkIqbnFCQs0WyokPcYyX31uPl3c4TbQEqkOEQBeg2ir7LTNUUUpS6CHSS03SB8b4eTgiYWyfkmSP+SkuKDyLUcmpsnbOAWyHOA8hTgXDG1DvWTnQcdI+tMQUqOBnr/kRV1Ci/5Wdyn3Lb/s3uGipimP9jHyd92SmZ54h31mO1SL28AzweY0rkkwet6eVSHNnTZxb/c49tZRFl7jFB18VWbZsr/FkO51vgHm2aMvACvmbetliZyT2b93FL0YjZ7UZWQyKaH28o3ZRhudbI+5DJP8uSwVRm3ALE12mk5ndVpD5NBAlu5OsOViUFhEKfPRJbPenxq3YZ2zVnotkbWPpDCOVtjGHKhhu5eZ28nQlHYgaYKRW483p/mU5p60d0bqZmRxYdFMAD6246PfQ9hZrxK7/gc8IjWAJ3jXsBaGwroObO91wbV8raT33LtC78/akxzROF83V/wblsLpV3C8pORHug9u/yPQttX4hEb81z7XocLu4kLqXWsEBfMyk6abA9XURWwtQjnKifnuzaEew75WCFlXGUE32ln5jXuXQtWHtVme8Uh1AI0MlVUx0D3yn0ucrd5lnRYtCw+br6L1vebnoSaai9R9P3p9q0AdtkzVDm5EnxssDWpX+vELspeWQm8L0YzIUnY8nSxhXnDLRBpt3FWQro9s58UD9QepiKm8EOmrb5wHjvky3RTIcNcf/YvtVrza9gGi5t8p+hu5KowrM1Jo1fqKQSCzylumT79q1Bb7U37GWTGwkBN0Lm0EjhbWUnL5nN4WwMfT6RB5o
 xV6XREw2
 LF4P5oYOooTbkl6FmAFN0V4L09IgOPf3WWe6LiF5S4DXwhCukAue8eU8TcWRAXj1TRFWQKm665r0I0A1v2Ax/dHzyhVodjK2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 2:17=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> This series unifies the allocation and charging of anon and shmem swap
> in folios, provides better synchronization, consolidates the metadata
> management, hence dropping the static array and map, and improves the
> performance. The static metadata overhead is now close to zero, and
> workload performance is slightly improved.
>
> For example, mounting a 1TB swap device saves about 512MB of memory:
>
> Before:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    805       346        1          382         658
> Swap:   1048575      0   1048575
>
> After:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    277       899         1         356        1187
> Swap:   1048575      0   1048575
>
> Memory usage is ~512M lower, and we now have a close to 0 static
> overhead. It was about 2 bytes per slot before, now roughly 0.09375
> bytes per slot (48 bytes ci info per cluster, which is 512 slots).
>
> Performance test is also looking good, testing Redis in a 1.5G VM using
> 5G ZRAM as swap:
>
> valkey-server --maxmemory 2560M
> redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
> Before: 3289011.918750 RPS
> After:  3312087.142241 RPS (0.99% better)
>
> Testing with build kernel under global pressure on a 48c96t system,
> limiting the total memory to 8G, using 12G ZRAM, 24 test runs,
> enabling THP:
>
> make -j96, using defconfig
>
> Before: user time 2904.59s system time 4773.99s
> After:  user time 2909.38s system time 4641.55s (2.77% better)
>
> Testing with usemem on a 32c machine using 48G brd ramdisk and 16G
> RAM, 12 test run:
>
> usemem --init-time -O -y -x -n 48 1G
>
> Before: Throughput (Sum): 6482.58 MB/s Free Latency: 371371.67us
> After:  Throughput (Sum): 6539.28 MB/s Free Latency: 363059.88us
>
> Seems similar, or slightly better.
>
> This series also reduces memory thrashing, I no longer see any:
> "Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF", it was
> shown several times during stress testing before this series when under
> great pressure:
>
> Before: grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 18
> After:  grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 0
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v3:
> - This is based on mm-unstable, also applies to mm-new, and has no
>   conflict with YoungJun's tier series, and only trivial conflict with
>   Baoquan's swapops due to filename change.
> - Fix zero map build issue on 32 bit archs [ YoungJun Park ]
> - Cleanup memcg table allocation helpers [ YoungJun Park ]
> - Fix WARN for non NUMA build:
>   https://lore.kernel.org/linux-mm/CAMgjq7ANih7u7SJB8uWcQHS8XRJySNRc3ti9V=
-SVey0nGE3gLQ@mail.gmail.com/
> - Improve of commit messages.
> - Re-test several tests, the conclusion is the same as v2.
> - Link to v2: https://patch.msgid.link/20260417-swap-table-p4-v2-0-17f5d1=
015428@tencent.com
>
> Changes in v2:
> - Drop the RFC prefix and also the RFC part.
> - Now there is zero change to cgroup or refault tracking, RFC v1 changed
>   some cgroup behavior. To archive that v2 use a standalone memcg_table
>   for each cluster. It can be dropped or better optimized later if we
>   have a better solution. The performance gain is partly cancelled
>   compared to RFC v1 since we now need an extra allocation for free clust=
er
>   isolation and peak memory usage is 2 bytes higher. But still looking
>   good. That table size is accetable (1024 bytes), no RCU needed, and
>   fits for kmalloc. Even if we keep it as it is in the future,
>   it's still accetable.
> - Link to v1: https://lore.kernel.org/r/20260220-swap-table-p4-v1-0-10479=
5d19815@tencent.com
>
> To: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Yosry Ahmed <yosry@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
>
> ---
> Kairui Song (12):
>       mm, swap: simplify swap cache allocation helper
>       mm, swap: move common swap cache operations into standalone helpers
>       mm/huge_memory: move THP gfp limit helper into header
>       mm, swap: add support for stable large allocation in swap cache dir=
ectly
>       mm, swap: unify large folio allocation
>       mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
>       mm, swap: support flexible batch freeing of slots in different memc=
gs
>       mm, swap: delay and unify memcg lookup and charging for swapin
>       mm, swap: consolidate cluster allocation helpers
>       mm/memcg, swap: store cgroup id in cluster table directly
>       mm/memcg: remove no longer used swap cgroup array
>       mm, swap: merge zeromap into swap table
>
>  MAINTAINERS                 |   1 -
>  include/linux/huge_mm.h     |  30 +++
>  include/linux/memcontrol.h  |  16 +-
>  include/linux/swap.h        |  19 +-
>  include/linux/swap_cgroup.h |  47 ----
>  mm/Makefile                 |   3 -
>  mm/huge_memory.c            |   2 +-
>  mm/internal.h               |  11 +-
>  mm/memcontrol-v1.c          |  66 +++---
>  mm/memcontrol.c             |  32 +--
>  mm/memory.c                 |  88 ++------
>  mm/page_io.c                |  58 ++++-
>  mm/shmem.c                  | 122 +++--------
>  mm/swap.h                   |  91 +++-----
>  mm/swap_cgroup.c            | 172 ---------------
>  mm/swap_state.c             | 516 +++++++++++++++++++++++++-------------=
------
>  mm/swap_table.h             | 169 ++++++++++++---
>  mm/swapfile.c               | 212 +++++++++---------
>  mm/vmscan.c                 |   2 +-
>  mm/zswap.c                  |  25 +--
>  20 files changed, 783 insertions(+), 899 deletions(-)
> ---
> base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
> change-id: 20260111-swap-table-p4-98ee92baa7c4
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>
>

I checked sashiko's review, it seems sashiko itself is bugged or
something wrong, Most patched end up with:
Tool error: Review tool timed out (active time exceeded)

The rest of the results are all false positives, maybe I can add a few
more comments in the code or commit so it can understand the code
better.

And checking V2's review:
https://sashiko.dev/#/patchset/20260417-swap-table-p4-v2-0-17f5d1015428%40t=
encent.com

Which are mostly false positives and I've fixed the two real but
trivial issues already. Things should be fine.

