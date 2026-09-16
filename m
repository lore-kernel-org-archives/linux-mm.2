Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD7CDC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461C56B0088; Wed, 16 Sep 2026 12:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4127D6B008C; Wed, 16 Sep 2026 12:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC306B0092; Wed, 16 Sep 2026 12:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07D756B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:45:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5020D16076C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:45:14 +0000 (UTC)
X-FDA: 85220200548.19.7123C92
Received: from mail-qk2-f9.google.com (mail-qk2-f9.google.com [74.125.230.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F18BC0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:45:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hbHF2Q8j;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.201 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789577112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iWsFYau6hdKKYllHkE77M362FfzZpy87SNp9ei3mzo=;
	b=DlflWIPxFon4UE+oJoHYfjg0zBCF6yb8t0mNbfOwm0oVUlltgmjlBgknrFWsZfI9IfDfN0
	mBDlZeYWopfKjqTffUhDYw9pdkNQVw83ctDrkg7gIwXroUAltcpP4x4cV8r0+vFsKQD3YX
	affjT0rlzaiE2cPn23SdzWp0jie6BF8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hbHF2Q8j;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.201 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789577112;
	b=eCeQf23Y4w4FS56oEnC+ZJFr7Pt7dZKe0PI5sfhCybn+Y68aTZZmDHPQa34Ly/hr4KQDpY
	FltwZ37ltcLlJ3oFgIHSBNuROQ4Ks3eSvsls8o0TC79ELlgxGfvAjdRu2JCVVmI//ABDNa
	BAXn6O4YrfgCAiwx+Xgvp3k1BzGDbOc=
Received: by mail-qk2-f9.google.com with SMTP id af79cd13be357-934956d1044so341855485a.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789577111; x=1790181911; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2iWsFYau6hdKKYllHkE77M362FfzZpy87SNp9ei3mzo=;
        b=hbHF2Q8jJy+qLp7XaQxyfO1fno0oebibrRNzbgF0EfdENJhNsojpNNc1t+k20+BJ2Q
         DfyYpt6+Zl4JcRpIOD0f9SZIpdm7YedJ2i+kchPJ8rrPjp8HZtt7yom1IbmDPLAOZNxP
         e/6vggP3yFoQzazWKtLxzrii8LQnKKstDIzr7Gg4VBxWm9WmYt9U6I51jXFuXbcWTY4Q
         PYGrQd677DWoDFuL+u0DtOi9NoMyEQXr+Sfzs20kyHiTLBXKVGZK1UhzkatJ7NhZfxnm
         rebUJAh4c0jgc5vqClBTBiiS886XEln3+Y5f/V6qGsfKXK3Txh9HLdMBxkTGc1gcxo+/
         TCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789577111; x=1790181911;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2iWsFYau6hdKKYllHkE77M362FfzZpy87SNp9ei3mzo=;
        b=SJmkrapRjmpRG9i5xEy8SF+Vq5M7ABX6bH05ma/KjT/BaW5v6xYY8dcqTaw5qggdcF
         tTzPHyKsokNTwqG4IrBr2fwqL/3NslIEC7kMfSr1ocHu78I8bA8GKdct7B0VULSQ/9sk
         /qSzmdTf0Ygrehq5aO2E3IAanBnDM0BuqL9xZ28/BL+YmhJ6CKDY/lUfa+WHl9JitRmn
         ClF2u0eSPaeBYbjATy1ootdhZYapBQ82JkkIz2FtFjWJuJvu0E7DLd8Yd6p1SHY9/wvz
         KU+6Psw+yjuuZF2xvwMKZJWnqIIDTchYG0lJRlrvqMKpsgAqygSKUtALIRbP4DI2cmaz
         xkKw==
X-Gm-Message-State: AFuF++mhbDqP1MqHWyOLRn/nS4JR1MU4EIqXgBaSncLs/0cpXxLnq99d
	AKAicbIJ8M8JpovRnMBa4aq6y5jO7+r/DM1nHTEmWqTttxIU83Cy3VRcrqDg430jHgs=
X-Gm-Gg: AYBFou2PjSs8k8PkMczwrE/ppyZZjskANlKOBjNAgicjvqN+lcsZ3Bln/F5d5vAPdjO
	y0+o/Ihxw8/I4LkfclEmdNsR5ZnMkausVhFo917wLfrzcpYgt/Jt/91lzJ2MvPKHXOlZVhH/kEm
	5tFPopuQZxp7gcAgqET2C8R3YU3AlaMkLEtHqsIuY2w3P5aXZlOtUJqxVHH959Q6Y8PUrjLN/80
	uE4VeVzPORz27zBrh5T/V0PX70fwNn8/SzkwGrZWdQsdLHZTBwcIQlKEg4lj8cXZ1fX+1LbchI7
	COoZ34HQh7mr7JDMHf2413jm4Ehp6E5K2fnWJZqUoT/HEVxSOnp8VVZ6j2delOG71RVr94Dx6yw
	yYwHj2lnIIKrXS/Mg2TTUPOWXlUs8qusx/P5UuWVwkY/6zXykg/gC2zvaMSqBjW02sbkQMgUn1R
	PmFu1OWhv3t9pj2xXSv5McL1AV7bsK1r/QgR61ogAoRxY/CWLGWHZxKQVw207ciNtyqEsgJA==
X-Received: by 2002:a05:620a:4889:b0:939:922b:3de1 with SMTP id af79cd13be357-93bb7907f9bmr535994985a.44.1789577110417;
        Wed, 16 Sep 2026 09:45:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b7821d3b0sm260394085a.17.2026.09.16.09.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:45:09 -0700 (PDT)
Date: Wed, 16 Sep 2026 12:45:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <aqrHjfHwyEtRIr5S@cmpxchg.org>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: tc4hn15uahb1bpd65ssd7dquqrw7fs98
X-Rspamd-Queue-Id: 4F18BC0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789577112-842185
X-HE-Meta: U2FsdGVkX18JXHdQuy7UAKV29aIC7vD4co8Kj69kEfhaZEnauPI5R6uEW24LMGy2U8vv29ruVaSx5z5/dC9ewy/AOxjq6jVsJppoeTbY8qlH+OraJ22WI9sRTqzdO9k+3fHAlHJrUB7dx+GgdPpFl+0q8oE+USrPRTgaWKmcQBAToBEP1d6bLkwltx0nxcMtqetxJFaAzGqAc/z2X54dZnb4mMb10yaPzBTwN//1sgpTDIBeJp8ZOP4J4g8pM5RrdVsctyGISLVrODf4kPc6/PIaofLv2oAFCfGS+DWydblbW1+e5GohUmu7VJa7gS4E2zFofW5/6+aMBpYvrWohFXUfewPRWIYLCNdOSRyoeQkbj/DGqpa/HctCUt7LZIkx23D98+KyE0n7BhJgBfJg8mPkEY7h59KA66WIZI/0He3puIH/s9BTB4m/XrWL7T/Dr8fAt3ImpgEo7gl0sd6VInyXck4jqVaJO+uOwVw0rK/IWKH6yF5h1wpWCMryVbQRsy2D09watzvP0o1XqQ0ZVZXFOTT7DJfDl2e0FxuR69j7yHtAWouPzOJdR7mLrF6HHLOk0VR+XSY5iskuecjS//kvBSZLC4/nixuJya0F7oRtG/uuelCl6KenUvCSu1XArRoxB1qszBe5LiYO3JPnQ4aaLpN/Ig21mw3EsLr5mmLH8bUzmogsiQ+5VY97quOE1qRotLZB4kinl7yVJJDdgb2hnzlPhjhMx3lSZ7U+iwcDQ/2vY8OFLGoGzI7gm9I1ylQWKU5/pq4jhQVmb1n6ETNktBbCkJq7sJOuTV6ltkOLFdQd2svAwqJ/MdmZOfSeCc+swwwH4euyHzj5MpKWbQf0otg+bCAPdXR0Tcau7ahkdIZSI1WqHaOmljaBDPTuZQ6OxAc/8KH0BVHddTska9fTnNk2knzguDv72iAYlWlRCy6NmfbAS3Uss56DIEvAFHErEGYfHircXCRofQq
 /pKevKus
 BBTqXFQAxkOhlYCbvNZenuQRYuh1Ygbj9KpcYxOTRaGITexRFYX/L9phCuloQIYxDCHErty34CnkAU+7O7bf6fG75QF4G6W5HoeZ26ZCA5kAJUsqGHgriCPLc1Xgyn5/0ynq0GTlAeyiYyoaxv5sWrsD0jIN6hqPuhkOOMbOTH+y/6tDZTMgW06aDakb0UbSX9Zmo2HG7BXsLcxb6l/PdXGvuz6KV5e2SgTK+dFWetqwNhztQeYxat8geRW3+zCZB0tXbL0z4IadJjeosFgDGR2yVNRv9liHO4QCSKKrpSrftPThD0Zx5oFUSbkEW5lyMX4CsM+3ITRfcNrrJYvQ3meiGxXNEC0vanxz3KjXnGsZH5XJ8Az07a9N0TaB9Sy0GPlt6Ot7UeQ1AvonJzqV62nO5xrhFRMfYSfKlVWjk/Nw9p6pr/RvNf3DftK9q8iRQ3K4BJ9YHCmQ24cuiBRuJH6QVhbgwkauSSv7P77GjSd1fgEAJgaQ7xXVoIwXCk2+GCT35WCmbWI/OHTTZmfhSjdE6zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 06:19:07PM +0800, Baoquan He wrote:
> xswap is a swap device with no backing storage. Swapped-out pages live                                
> in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,                                 
> and the area is grown and shrunk on demand as swap usage changes.                                     
>                                                                                                       
> The problem being solved is the static size of compressed swap. Both   
> zram and zswap need the size fixed in advance, and neither gives memory 
> back when the workload shrinks. The solution should be a device whose
> size can scale up/down as per usage. xswap does that by mapping the
> metadata lazily instead of reserving it for the whole range.
> 
> Design   
> ------                           
> - si->cluster_info[] stays a plain array. Access is still
>   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no 
>   RCU discipline, no tear-down state machine, no NULL return.              
> - Only an initial chunk is mapped at creation. The rest of the address     
>   space is reserved, not allocated, so an idle device costs nothing.
> - Growth is driven by allocation. When no free cluster is left and the       
>   address space has room, the next chunk is mapped and added to the free  
>   list. No userspace involvement.
> - Shrink is driven by frees. The free tail is scanned, and whole chunks
>   are unmapped once the mapped range is at most half in use and several
>   chunks can go. One chunk is left mapped as slack, so the next                                       
>   allocation does not map it straight back. A ceiling lowered below the                               
>   mapped range skips the half-in-use rule and is enforced at once.

If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
to them on that.

However, from the cgroup and zswap camp, two stipulations that I
reasoned out in the other thread[1]:

1. You must not charge compression space as swap space to the cgroup.

2. You must make the compression space large enough to be outside the
   range where users can hit space limits before hitting memory limits.

   That also means not allowing setups where this is possible.

   I'm fine with fixing the zeroed page flood issue separately, as
   Kairui proposed.

So if you're willing to fix the cgroup charging, and if you're willing
to drop the sizing interface for a statically sized space that is
sufficiently large, I think we can find common ground.

[1] https://lore.kernel.org/linux-mm/aqLi6cIjD2wJwk0B@cmpxchg.org/

