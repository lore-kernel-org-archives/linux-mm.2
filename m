Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A42BC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6E26B0088; Fri,  4 Sep 2026 08:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577C96B008A; Fri,  4 Sep 2026 08:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A096B0095; Fri,  4 Sep 2026 08:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 008586B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:42:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655311A0BED
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:42:45 +0000 (UTC)
X-FDA: 85176043890.20.741B108
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7A1E140005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:42:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HHJErrsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788525763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NvEAvFmRQ4KOLpVzS9bkFTsS1KS/yh22uq2NVZ+PR8=;
	b=XHS6z5CxTU4S1UaEYZo3xopZuerXN0t4EwmSQKuMVznlT2pcm1cMLaAnY9uszU75jkDQiJ
	ElJ0/QhMmFIGIvxj05DIW9fhGS169LVpCxWD8Mt+uyNAr4q+f9ASpngKrvENDUr+YKNPAF
	xurK6DkCQut7tmnWnckELej19Wgonbw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HHJErrsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788525763;
	b=8jIUheZ8SFnIFerZo/MOls+NBchpcomUvs4+nrF31bNTuExBnnmXbC1C57OPtBVpK3k8YO
	Ci9+IdqdIykTvbtD8AHgYVGIS9q6xO5xCczsS2G581yu7JMx3DgvLktAZF+P/JMsJT7ZK1
	RfTk7uDyxSRK+6cdGV4LMM+JO1ZBIpI=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c252e703fa3so141014866b.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 05:42:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788525762; cv=none;
        d=google.com; s=arc-20260327;
        b=ViZB5gcbU+QYmbuUfq2YSrYuXH14MFWt7reIeSDxbqgpdL3cMOfj+Q2hYeQq6mKT/P
         ClcbleUPNWLSX0EZKeJOB9EaOGK31mNx6Pm5Vosk0IIqyEQ3BgIBei+AYQ9l8o+KBHUl
         h5MGvpEfjCOv//pGHDUbkx4XAX7dv1JyTk21VxNlU8WkSvISXbuGhZx9zR6yZbqMsXaz
         1FCHXaztZLiaBQZW1RTAh37FLErdzA4jCKx7Bg9Fm6+MdOe4EcpmVwNkkGUXzA717WeI
         FGrE9+mu8jwEattOIscBpawxWpLrpFlMM3Oza+2Xc8JzveCkp6clrXmkdeWtpEBB+LK8
         n31A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9NvEAvFmRQ4KOLpVzS9bkFTsS1KS/yh22uq2NVZ+PR8=;
        fh=2CLRqMDUA/JIh0pBObtVY/F/VAUVfLm9gbnHxQTsKc0=;
        b=gjEKt6aZDNHyq4N2OTn4Gy+PNS0ATMtdt/iQlzwl+7oLTebAnWjXZsdcaShMjZkTXq
         S0e+iBiwlYZn2nmg7kslc+/RjsJjtNvEFagT2A/hk8FGVvCVc3sQQxkM5Gb3DEWHQhc4
         vmFc5bLGR2WhrgqD9UcZE6DXDtc4/UFNca+Q+6c7FskgLcvCULQS+6K+CdW9GuQl32+g
         Y9tFKfXv80LtdEAwO3T8gK+0mRSSAetu8I4ZfCPnasmjVxR9/nWvFg3aItp+SURtBjUT
         5XVGM3BSqixMYjea9RbLyWqbARDOdb51z3sbv4jUn4kFU1NdPQ84MEe2uNRm3qfwqCDM
         ZBsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788525762; x=1789130562; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9NvEAvFmRQ4KOLpVzS9bkFTsS1KS/yh22uq2NVZ+PR8=;
        b=HHJErrsYP4LyPYMBBrSVRUrk0qfZRuwB8lIAKcBdyFxHXi/L+kiOPznbsZXhakwo0a
         HzLmvvJrvFWgYBKfKiF5czq0bY+pnmAkbXq8sWOP2QUdgZUfI8X6r+nhOPb3S0MjPjva
         tlPqU1JAwjKNIP9E5z/l2uwUkgduHlamYaaFKvR7MxMK46CRSRJeZvMsvU0zxFoHZ+RT
         Va8BQDYOBK0LH5uFFKICzZsvRVLnPWIFtVmnjY3jmrH6VX82WP+iIqHuS5Q3Jhu8uGUl
         VH4uCJvQK2y/ssctFPAfAdomC56JzNd89FCtRRlsmq+3F6PIswxXbLOrDo9t6xWy0Gs9
         yvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788525762; x=1789130562;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9NvEAvFmRQ4KOLpVzS9bkFTsS1KS/yh22uq2NVZ+PR8=;
        b=e6l/WzWYgYSFnPg48fa26sp4HskwgTQUGMAxfCeMCbp2rpa6V86cjfVYJJoc72vjV4
         imO9gK/iQSv2b55h5jCyI5PsSDOKxgzOEcUX9GuX2paYC9awFI0CZC+IDrsKz0E9sau3
         anFm/D3vgilAgiEc3VakfkpO8+G11Xxu6vQ0Mkmmo4WWygvoE4F7UpqeJNTfSem2QSeU
         nUmHnJJJQupo4kRpJZajU/Yka7XyB4VZiiU7UsTMtLSJO2NlIMVr/XwsWs4ay+qu1zzR
         RMY/U16irrZyoNFO/RbUcNqNnZv5VD/6VU4CNmNZd4brs6qLCMDmL3oEMuHM9D42/WjN
         1XGA==
X-Forwarded-Encrypted: i=1; AKwUvBwEDTuC1p5DdAprgrOtzAb/MPgfJ/HsIWESi8S2sXYFOWP/KMPmP7P5TfUg4fuiLHyJyXLBrh4Pyw==@kvack.org
X-Gm-Message-State: AFuF++mqtkdiPHl8pwoUdkiLWDJ4dJxSt3WfWL/OsWG1959VEtTtGOsA
	t0ataOp5lJvZxuyyCw0ewO6ru25chMVkdEpxu7JB+qjhvt7L74S+O0DsZLdEyhSSdx8CpgMVcdU
	NLNTAuOm0V6cZ3Gl9YKyxNOomqsqVvy8=
X-Gm-Gg: AYBFou1UEB/T2BegYB7o6YZOX1OnZ3fWlxGK7hALgJEMmxfpoJtvg4BWm7w/Rc/Uvcx
	ZWOw0IP0uNVfmgTJLMwL+D3UYPrR9hxw0b3QA1ka78YgsBxp06Fs+zZfNFA07WTG3C5MDXUX2WB
	Fd2MADkYJQreSGlNA4hIuvs9Mjoy9fYM+RoXcyUiWJsK19mJ0QYASwniM7FBsahcnsF8F7douzH
	WzgFlCVSaHVIFzHw+mspKNZVo1q37HCBblwPAfkZ92SASceo4tMakCLdcozg8hMP921MR/BIlUL
	62kL4UQw0wddXF0VR/1yNrjffNDByRURzShElWOzRXsMBSx85EYR4rMI7dRCc6z27z49ZL+JZf/
	UMg==
X-Received: by 2002:a17:907:3c8f:b0:c25:4b9c:5ed1 with SMTP id
 a640c23a62f3a-c260c9ab80emr257426666b.12.1788525761715; Fri, 04 Sep 2026
 05:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com>
In-Reply-To: <20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 4 Sep 2026 20:42:05 +0800
X-Gm-Features: AcwNN1VHGK44NPRvYuy__k5IFafFsHEdaZnGRcRo-ytY5YzYC93mhmnvSLdmfxw
Message-ID: <CAMgjq7BNk004x_zQM3k4QuCLmqMx0BVvd4HLxHq5+XvZ0fTk2Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm/memcg: clear folio memcg after changing per memcg stats
To: bingfangguo@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A1E140005
X-Stat-Signature: 4ascwid3junq4jqndmd3f78yejhp51i9
X-Rspam-User: 
X-HE-Tag: 1788525763-272786
X-HE-Meta: U2FsdGVkX1+evwHr81YUx31SN2aNQ1WIhw0s6ngoO/8PWSWbzhTZ35roVoBqC2+XTFjxq+Uj6dtr6YJG1Qk5f7emWeCG1+b0VupTm18j8nDaoxLg2Cjo9IBvB9kbftmt/FFPzzP65FXg9Es0fHBcqFTIjNLrwVP6jZ5JOvrv+YysKzm+W/qxw/C9UBgvN9Pq2n3jTLobua+LwBVbYkK9ESKGEtPeUK3H5avwBaDgaICd4FrJ/wiKaLsJ+QALRnf7F4XSuZFZtrVk/IUklwKj5YVv2BwnXSP2kdv+St5ot5P/G4nBY1gU23ULlrd+8b0mmSabzleXzlqM76VOeMAJLTLE2ku/1M1Wv3qcftbxY/IsFML//93+OTI8wGVNDfH8TVEzyHHHc7RJ0IOu4cAarXmmEhdVUtQyUxJjJdGd/NXwdSTvUVoKdKJsH2++BJpFtKpJDHrusp9XqLcvDgs2utLhOFeL+pLEjCai6s+7DkinPszyj4lnUBqqmn5NClpzIKnn7f8t26lpkrBXyb/sL7Z/fxDGayTl5U9Dq3aKuV9VYP0MROpMLsMHXxVJIvlwErFEMgbtEwWNoueHKkH33/oGwzQsVI5zH6RPlRZGgPo9aC9CTnjQy3AbtSidFQ25tBrctRYCJNGJt/QsrbbAPuN6c6pMM7lfO4KxhxXuAFdphI+cQqCwVFmXQxLhopkrMoWaOy+bDPwS1VWRWcZqsFjuap8XqetsJn3EOQnLUO2mBsU3sITMvtIJoAVSynBLV+nYVFH+54z/527YEx04VGmOPR26HRDWxeFWXpspr1j/HNKiyix/TcoGMS1z0rbEttZuzRXpWc91BN3Ovo11O9M1TZXkCP7SyuutDA4bII4UuljcyQJDpD4t0APO/QNWd82qQSPXav1NHSwpMq58K51N6RBaLTvtp539MiBNXJy5d4RJpw3TOUYZ8Nq1OOAr5c0mgsGTItfF0Gmn0KM
 1emOOUym
 wLti3tZGXQdcVbrRyJmhYYBHj2T0bnfleZS1+AnKhekIIMNs3HNnTaxd6ECBpivchKOq4aXvFqd/mYWE6C6NLif/dkx4gCsv3xQ1yyl4efBPEpOV9iSMOEgIQpLHJPuiJ7KH/79W4uxBm8XeP0NKZD7lIrtsJ19gV4lqbmGrSpwmajXFiJ0Gv9wwzpScbkeRxcB1JsvxsDxLv+mfkA5ujapuf7tX4NwuQRa1XkJQ1ArKm1awU8HRjRTLo9Ix2iS8gUyCPdev6xQ3FA4IweuRJHa4wDRtT+96EEsaCV7DaK+WjAjkaTdmpJU6Pb4oOGTP8cLXHafK5kIY1RZaaRjOSogu++lQDxWobzHFYIJ+oxUXet1eG6+QBeS5yaKZzTGBr2xN/EHw2AMDsovDoc+/UXeNhqYaMkgiff/+ek5trk6qie0fJCVNznGcTpPs2OxmnjKtfXSNFpzDWDXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 10:07=E2=80=AFAM Bingfang Guo via B4 Relay
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> I notice extremely high swapcached count in the per memcg level
> memory.stat when running tests with cgroupv1 setup by swapping pages in
> and out.  It seems that the counter never gets decreased so the value is
> rather useless and confusing to users reading it. So I think fixing it
> so that the value can reflect the actual swapcache usage correctly could
> be helpful.

Thanks! Good catch, I missed the V1 case.

> __memcg1_swapout() transfers the memsw charge of a folio to its swap
> entry and clears folio->memcg_data as part of that.  In the vmscan
> swapout path it runs before __swap_cache_del_folio(), which then
> decrements the swapcache stats through lruvec_stat_mod_folio().  Since
> folio->memcg_data has already been cleared, folio_memcg() returns NULL
> and the NR_SWAPCACHE decrement only updates the node-level counter
> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
>
> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
> __swap_cache_do_del_folio() removes the folio from the swap cache.  This
> keeps the stats attributed to the folio's memcg while still recording
> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
> the plain swap_cache_del_folio() path is left unchanged.
>
> Fixes: b197d41462c20 ("mm/memcg, swap: store cgroup id in cluster table d=
irectly")

Is this the right Fixes? I think the problem could be introduced by
2732acda82c9?

> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
> The problem is reproducible using the following script and program:
>
> ```
> #!/bin/bash
> set -e
>
> CG=3D/sys/fs/cgroup/memory/swapcache-leak-test
> SIZE=3D$((256 * 1024 * 1024))   # 256 MiB of anon memory
>
> [ "$(id -u)" -eq 0 ] || { echo "must run as root"; exit 1; }
> grep -q . /proc/swaps <<<"$(tail -n +2 /proc/swaps)" || { echo "no swap a=
ctive; run: swapon <dev>"; exit 1; }
>
> cleanup() { rmdir "$CG" 2>/dev/null || true; }
> trap cleanup EXIT
>
> cc -O2 swapout.c -o swapout
>
> mkdir -p "$CG"
> echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || tru=
e
>
> echo "=3D=3D before reclaim =3D=3D"
> grep -E '^(swapcached|anon) ' "$CG/memory.stat"
>
> # Put ourselves in the cgroup, allocate & touch anon memory, then wait to=
 be reclaimed.
> (
>         echo $BASHPID > "$CG/cgroup.procs"
>         # Allocate and dirty SIZE bytes of anonymous memory.
>         ./swapout
> ) &
> WORKER=3D$!
> sleep 2
>
> echo "=3D=3D after reclaim (swap cache should drain to ~0) =3D=3D"
> grep -E '^(swapcached|anon) ' "$CG/memory.stat"
>
> SWAPCACHED=3D$(awk '/^swapcached /{print $2}' "$CG/memory.stat")
> echo
> if [ "$SWAPCACHED" -gt $((1024 * 1024)) ]; then
>         echo "LEAK DETECTED: swapcached =3D $SWAPCACHED bytes (expected ~=
0)  [BUGGY kernel]"
>         RC=3D1
> else
>         echo "OK: swapcached =3D $SWAPCACHED bytes  [FIXED kernel]"
>         RC=3D0
> fi
>
> kill "$WORKER" 2>/dev/null || true
> wait "$WORKER" 2>/dev/null || true
> exit $RC
> ```
>
> swapout.c:
> ```
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/mman.h>
>
> int main(int argc, char **argv)
> {
>         size_t mib =3D (argc > 1) ? strtoul(argv[1], NULL, 10) : 256;
>         size_t size =3D mib * 1024UL * 1024UL;
>         long page =3D sysconf(_SC_PAGESIZE);
>         char *buf;
>         size_t i;
>
>         buf =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
>                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (buf =3D=3D MAP_FAILED) {
>                 perror("mmap");
>                 return 1;
>         }
>
>         /* Fault in and dirty every page so it becomes reclaimable anon. =
*/
>         for (i =3D 0; i < size; i +=3D page)
>                 buf[i] =3D 1;
>
>         printf("allocated and dirtied %zu MiB, paging out...\n", mib);
>
>         /* Force the whole range out to swap. */
>         if (madvise(buf, size, MADV_PAGEOUT)) {
>                 perror("madvise(MADV_PAGEOUT)");
>                 return 1;
>         }
>
>         /* Give reclaim a moment, then stay alive so the cgroup can be in=
spected. */
>         printf("paged out; sleeping so memory.stat can be read. pid=3D%d\=
n", getpid());
>         sleep(30);
>
>         munmap(buf, size);
>         return 0;
> }
> ```
>
> Test result:
>
> before:
> ```
> =3D=3D before reclaim =3D=3D
> swapcached 0
> allocated and dirtied 256 MiB, paging out...
> paged out; sleeping so memory.stat can be read. pid=3D4778
> =3D=3D after reclaim (swap cache should drain to ~0) =3D=3D
> swapcached 268435456
>
> LEAK DETECTED: swapcached =3D 268435456 bytes (expected ~0)  [BUGGY kerne=
l]
> ```
>
> after the patch:
> ```
> =3D=3D before reclaim =3D=3D
> swapcached 0
> allocated and dirtied 256 MiB, paging out...
> paged out; sleeping so memory.stat can be read. pid=3D2601
> =3D=3D after reclaim (swap cache should drain to ~0) =3D=3D
> swapcached 0
>
> OK: swapcached =3D 0 bytes  [FIXED kernel]
> ```

Nice, the reproducer is under "---" so won't be included in the commit
message but anyone can find it on lore.

> ---
> Changes in v3:
> - Add doc for the new parameter.
> - Link to v2: https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fi=
x-v2-1-9caad330459b@tencent.com
>
> Changes in v2:
> - Update the commit message to describe the problem in the beginnning.
> - Change function declaration for !CONFIG_SWAP as well.
> - Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fi=
x-v1-1-1c0819ebdb86@tencent.com
> ---
>  mm/swap.h       |  6 ++++--
>  mm/swap_state.c | 11 ++++++++---
>  mm/vmscan.c     |  3 +--
>  3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 0b5d507739bcb..b3b54c28929a1 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -319,7 +319,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ=
et_entry, gfp_t gfp_mask,
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
>                             struct folio *folio, swp_entry_t entry);
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
> -                           struct folio *folio, swp_entry_t entry, void =
*shadow);
> +                           struct folio *folio, swp_entry_t entry, void =
*shadow,
> +                           bool swapout);
>  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>                                 struct folio *old, struct folio *new);
>
> @@ -452,7 +453,8 @@ static inline void swap_cache_del_folio(struct folio =
*folio)
>  }
>
>  static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
> -               struct folio *folio, swp_entry_t entry, void *shadow)
> +               struct folio *folio, swp_entry_t entry, void *shadow,
> +               bool swapout)
>  {
>  }
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 305877e1f4d7b..99985208b529b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -306,6 +306,7 @@ static void __swap_cache_do_del_folio(struct swap_clu=
ster_info *ci,
>   * @folio: The folio.
>   * @entry: The first swap entry that the folio corresponds to.
>   * @shadow: shadow value to be filled in the swap cache.
> + * @swapout: whether this operation swaps out the folio.
>   *
>   * Removes a folio from the swap cache and fills a shadow in place.
>   * This won't put the folio's refcount. The caller has to do that.
> @@ -314,13 +315,17 @@ static void __swap_cache_do_del_folio(struct swap_c=
luster_info *ci,
>   * using the index of @entry, and lock the cluster that holds the entrie=
s.
>   */

Perhaps the Context: part of kdoc could briefly mention that for
"swapout =3D true" case, the folio should be a reclaiming one?

