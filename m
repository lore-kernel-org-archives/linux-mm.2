Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A490CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 11:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D73D6B0005; Fri, 29 May 2026 07:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687F26B0088; Fri, 29 May 2026 07:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576A16B008A; Fri, 29 May 2026 07:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 468B96B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:54:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1FB399D5A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:54:56 +0000 (UTC)
X-FDA: 84820300992.28.68B568E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 100DBC0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:54:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8VZz9V7;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780055695; a=rsa-sha256;
	cv=none;
	b=01ZdPvzaCuwUfdRHyxFBj8bFFyDHZW7vqeLYPnYhVlRc4xIswYWjtFiSAGph33kQceW7YN
	XA3gA32SowNJ09fdvr0T7rtHDK4Btwipw8R3W8ojzVZ9iG8JpNsLtVJYfpvPVmFa5t6jHo
	64V9IMNfJk9ctn6+7mafL/Z4Gj5xmsk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8VZz9V7;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780055695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDOsRW9HSX03yxtZDtOoclJqvTh9mPV1pfPcH0+q2no=;
	b=MsLXHhmdiIeNCl7YAo9VjUS10tGl942lHdg14xFaLAzAVHctHFaKFmy1UiiL2iiCgTDnpY
	dmwd2z2qKQTDNz9+7fjFcnFEs0LX/w86DHMj5+SeA3VppNcXcs/kJD5eZkMzjtVhHSWc5O
	2N5oInupCWF5CbMBnZL4uMoTBx2UNyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02F1F44438;
	Fri, 29 May 2026 11:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298511F00893;
	Fri, 29 May 2026 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780055693;
	bh=wDOsRW9HSX03yxtZDtOoclJqvTh9mPV1pfPcH0+q2no=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L8VZz9V7K1eN2jdYePACCXZ60MYUhFC1fOihSN+0H+7dhVQgUxdGJ9EQdJmCDTbwW
	 G+lY0xHDWzx6pTWX1lLWl/0EpNCsU5b9yHlXtO5sbBEMs7G5VmlF0dXcZ9v/DGu76f
	 /viJGQXlwamh7rHUkI0iAX99Shho8pimXeoM0y7KNHlU+cpwDo6MSIljUf43lop+B4
	 Y/IKFYrX4MCpwS9OMGK+k+HTotpqSCbAaZXWldCVwdTAjK0G+boxDWKQ2C5xXoy/Dg
	 Frr8k2GRRRiGohLe6GdGc+rFcv3VqLP0ZveFBiJjWHREuNVs5EyBZwfujpGuPitREW
	 03hx7I5WrTEiQ==
Message-ID: <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
Date: Fri, 29 May 2026 13:54:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260528093437.2519248-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 100DBC0005
X-Stat-Signature: nbba7joyb6kofcanuz1fde9kaqshpa5d
X-HE-Tag: 1780055694-913370
X-HE-Meta: U2FsdGVkX1/kZ9xYHivmz6+auToxwH55/w68zQe/xOUX3Z9f0oFLST47Rs382tVk830C4fSOj2Q+y30klEE7iC95RJap0Zbs0qxZYTFh8kIteUIpaP08TEJwgEZQ6ivuRLnIsd94cbzp8o1b/3Ika/EBxxDJKIMCzQlOWOcMibC9PQIqOAFJC4fONtPimvbF7lXTePZxZlKtY+KYFKfQJK174PAU8XSQM2CNjBCZGBX8NRy7+Ow1xS8Y9oJFtSDCKXNnYJwAwgU8UJ7YSVD5KDKB3UZ/8nAYXxVUA19Miqrhz5+Vb/UFjY9YZ8Pdhx9/CsL+XCNtlN0a6T5LPsx19vxsoO5RfoEzY5rBxxeh/koV+g+hFG9ds5ZnTTl52WFFp50UWSviFuj7dDUtxB0UrNZD3ub7U4NIplQUGbMaUx95/x5AOz0Qs/kOZNll/L2bACo890op+DlYPgjL7/lc+JeFdwLW8o9aNlWMpfvyRkcol+9iUPVwTNp9o49JYB41W9AczhcmUV/CJ4/ZtADOIV4N97ozDhD2Uy3hCFeqEsGrinkeBXM/ujqsfpqZrdiNoFagdl/aePp2JvfrY90mOYDR9/bhhnmGa1HTEcXqms3/nAJXHWytqQvc2+XRVWAa1pesaRERhGKEUEZZSKia4i+lGgAfLeeTJg6PaxxhIYHgYSjR2+caZsh0aWm+4LN57jXMjcHhhQJ6Oye46nZYKts8s6WHIxmLd/y/zjqSbJZd8pD64GdrhaGW1uTpA2ApYYClottU/okaxkEFRzDCsdCXOKBoDI4INDzeoM6QsEiJo5Gk+FAxV4Kq58Bx2K8g9KNT4g+hN2I6OwjafRfBckKSAOm8PQfwfWE2hCuvwW90Pz4GaCbUwH3AgzR7UInJirc0MnW1xTRgDNJW+85aCjFXEAgL9WVWxepN+BqQ1aiBw9EU+8lYoPFPbLhMJxgzCkjJUQDsFdJVAn2/L7G
 DnR8lkQm
 6Sz3Mrinomkv7VT37L89OWIPtSA8c1FlSTuuVU7GpSgtZhvnjF5Jnejv91khzPC/AiQwDkEmcd1loYldirYp5w4cSTetDkgW8dBHTCwYccMsuuiKCdhdn3qOGqMf6xXh3bI98YSjvSQSXJlJLmK8p+X9fw/FIRORgoGjLlRGQvPqrR9EvvemVQxvBMWH2nqh+0FCg+jyrfkMZT6mQYw/CQpj5+rIg+kzbQDHywAIxvwHqIRJ5w9lFMczOYOLnCMQ2Tlwe9fnlcH9AZDegSSqnyn+NqsHxahyNdlAy6xbMH+v5BHItL6UCZWgNNnAhzQGcOO1T5gSNV4QHppA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 11:34, Christoph Hellwig wrote:
> The kmem_cache_alloc_bulk return value is weird.  It returns the number
> of allocated objects, but that must always be 0 or the requested number
> based on the implementations and the handling in the callers, but that
> assumption is not actually documented anywhere, which confuses automated
> review tools.
> 
> Fix this by returning a bool if the allocation succeeded and adding a
> kerneldoc comment explaining the API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com> # skbuff
> ---
>  drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
>  drivers/gpu/drm/panthor/panthor_mmu.c | 13 +++---
>  include/linux/slab.h                  |  6 ++-
>  io_uring/io_uring.c                   | 23 ++++-------
>  lib/test_meminit.c                    | 23 +++++------
>  mm/kasan/kasan_test_c.c               |  5 +--
>  mm/kfence/kfence_test.c               |  9 ++--
>  mm/slub.c                             | 59 +++++++++++++++------------
>  net/bpf/test_run.c                    |  7 ++--
>  net/core/skbuff.c                     | 24 ++++++-----
>  tools/include/linux/slab.h            |  2 +-
>  tools/testing/shared/linux.c          | 19 ++++-----
>  12 files changed, 97 insertions(+), 99 deletions(-)

Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for-next
(it's still yankable in case of issues)

Did some fixups below (the comment was stale prior to the patch; restored
unlikely(), simplified one line).

A test merge into yesterday's -next found a conflict in drivers/gpu/drm/
panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the changed
codeto a new function panthor_vm_op_ctx_prealloc_pts().
But it's solvable so no need for a complicated coordination I think.

diff --git a/mm/slub.c b/mm/slub.c
index 6caf6f3ceeed..711df528c9a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7372,10 +7372,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
        }
 
 out:
-       /*
-        * memcg and kmem_cache debug support and memory initialization.
-        * Done outside of the IRQ disabled fastpath loop.
-        */
+       /* memcg and kmem_cache debug support and memory initialization */
        return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
                        slab_want_init_on_alloc(flags, s), s->object_size));
 }
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 99ab9ddb05e3..dbf0d8eae8d8 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -246,8 +246,8 @@ static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
        int i;
        LIST_HEAD(list);
 
-       if (!kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp, nframes,
-                                  (void **)skbs)) {
+       if (unlikely(!kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp,
+                                           nframes, (void **)skbs))) {
                for (i = 0; i < nframes; i++)
                        xdp_return_frame(frames[i]);
                return -ENOMEM;
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index e9c3bc9b3272..e0a0693df08f 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -301,7 +301,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
        if (!kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
                        &sheaf->objects[sheaf->size]))
                return -ENOMEM;
-       sheaf->size += (size - sheaf->size);
+       sheaf->size = size;
        return 0;
 }








