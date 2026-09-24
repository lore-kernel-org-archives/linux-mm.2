Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BB1C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223116B009D; Thu, 24 Sep 2026 08:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D45D6B009E; Thu, 24 Sep 2026 08:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9EF6B009F; Thu, 24 Sep 2026 08:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D80EE6B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:17:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52EA480321
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:17:16 +0000 (UTC)
X-FDA: 85248555672.29.517F8A9
Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D435100002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:17:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=byHjJOda;
	spf=pass (imf14.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.230.99 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790252234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fLqkUxSlx8uolgDoKpAxL34sTOVF8362oTAKQ+RbfY=;
	b=wSqsS9Jjl1bUy/fJliUZzAFfj2eNbYOH+Hjg1MxyRRY+EDSmlZ6cDmtM6OxvlU/9RjejLN
	sqd8iehN1fCjn/23l2hHeJm6bOtR0mbcmQ2DFn+bqU4y7MDytsCDCQOdir1/iz18loTd3f
	OqXKV36lOi6yzpnwBv02qEsb+giuQzU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=byHjJOda;
	spf=pass (imf14.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.230.99 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790252234;
	b=bFFwd3kQU+e2JtJAsYxaUmsKj0V8aOAH5ISfmpsU+Jcsxb1llZSwkznlCnp+ZTBtxzYiD5
	838Q0Mq7qXxIYm0LTQQY7O+aNJhunCI1rVkPLhq2Fi3jicQxOwKiPzSFKcDuaobc2vr6an
	2Tk2kIp/AF5UpiXaXq6Z9mG9X1a4lNg=
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a61240473fso19939151fa.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790252233; x=1790857033; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9fLqkUxSlx8uolgDoKpAxL34sTOVF8362oTAKQ+RbfY=;
        b=byHjJOdaMkQ+Rg7LPoQtyeANcMvyxMm6VwOX/32LBWRkj3AL7lnkljfWbBD4CEJimt
         eEB1ppNGqD8VgVpQqNrlzNmK1s4DZzIImmHRS2kDu+/GcKc6EJ+xxpEf/kPvOYcuQRZ0
         FjkEG9cQ8ymQeYrZitqTzH18J5uY3tQNM102bl30/LBEhQVAUxtPT/lF6VEHsI83Nlef
         +OnniaS/gwXHRZMqguh3l/b+mtIrY9KrLvxhsEHwtOPKjs0q1/D7c/5gDJTXEUNPQAzw
         OaqXBF0CzajfMrOS1c9Trvo20Di72VC7jLYBDbvOE+kWDaTcffi8t3oK+QSTJPKBy0Tl
         Jb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790252233; x=1790857033;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9fLqkUxSlx8uolgDoKpAxL34sTOVF8362oTAKQ+RbfY=;
        b=iHbqg8DQHQZT4YsFE7lBMdeauga1QIEqrkO1tjCAyQf734ZfkUBvEKRDsnqwlpFXCt
         j3ilQf0Ekh1XRIcMQr2K32cJ4eonVqzL9n/dQmo4bKCfEgXfv2ulw1ZPyVACwFh9ueKq
         XDdpUG9wHUUXUPZ3QegmqewXyr71VhbW9Z5wzlXpNt+kjaPDEMAXcj7zuRgeTnsFU9/v
         2S55952Dm5KjsQBFSnMEGeSJc7ifawMOiCb+aAiFSRoL9Aet1HlvaycBrnBH1jtWeBmN
         L3Zv7poWpQ8ttdb5JDEPAiqhilSsRcmimSX4AhqOkuLp5ATgUUqc0XBPWTz63nTK7DuY
         v26g==
X-Gm-Message-State: AFuF++nyvjjzOsZTgfrHDsmzIC44sO+RspNtybDMhNS14Goi8FMu16nH
	i/pe1NrRG90rglEflJzr5SgRwm9lCOy4WTHmUp2q8dx+9PVQAHc9VxlU
X-Gm-Gg: AYBFou1fB4YPGUWdtr/1zSDeKx2Vu/inoc3ss9omcxCfVOX8iRx1AL23jOHyr3deEJa
	QD7Q/7i1EDK0QPBYJMQwz8rPMzeTDw4Gud+70CNOiTUD3Pkr6N8wyVAN5b8tOY02HwuSmkuHVeJ
	DHxhqZ9ahkFN+mB5k6aWNn2G4x2/QgAPdNEJ4u2c2iFWMd1gLVCcy5BzIlxd8uZf4njCRHrQBVt
	Wcd9eubqXGf7xMDOknKXrnJRMNT2xdWN1QLZ9POmlwdt/Z0akVnNMGl32z9q2n0nPBDsPuTHODm
	QOd1xm7fyTmIYl9J6BFa/ficGGMp3zNrdu41QgKZBtAzwtzzSQ1Os2MZl7Ht0ij7nqmmP1/Unk9
	qGjlQUsSt0jLAVJ3xSB71TWMgPXnrollo/kqsHnLX7Ez4cWp6IRixhqOTkOtUKCqkwXXH2SJ7Ql
	b2sF3AQ6id37AtbhY3mtoOnWLU37eN/w8m3kKhi+3fn1O5atTFRebpFD2PwNqDMhnQFBee/owA2
	ZfBziNmhZ/A8c91zBkwJ279OaCr
X-Received: by 2002:a2e:bea6:0:b0:3a3:74b9:8a78 with SMTP id 38308e7fff4ca-3a63c30cd55mr6118521fa.17.1790252232318;
        Thu, 24 Sep 2026 05:17:12 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf2b384sm7599161fa.10.2026.09.24.05.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 05:17:11 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:17:10 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com, baoquan.he@linux.dev, 
	gourry@gourry.net, riel@surriel.com, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
Message-ID: <arUKSOVFzPF-iHxU@parmesan.int.kasm.eu>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
X-Stat-Signature: hnds9nn1abnj7yffq44fe6xqnujsj13m
X-Rspamd-Queue-Id: 7D435100002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790252234-933249
X-HE-Meta: U2FsdGVkX1+ZQJCSiSzMjfzSvEcDWfAnN/cqBv2i4uwrrBFzdpRYmgT28/8SmDDzP8FFTzt/sIY+iBvdGv89WRhXrB2Ab6UFX8dy0hOpVC1c3cMU10tcnrA2f5//+pfumWIl8dHc5h8U83MwJnW4xwd7fd/I8BsrrhPgQiYwBBJ1OQr8DIhWiE/eYq5CSberUzMyoasoAqr3hSRBIWrXvGJ3tpGFM6tQXmkzO03OPK5X3pbV6anCDKrUaUQE11DBLLxjp5CL96B6iq3J30WYyJAJ+lphpnuMouEOHAI5rHIw7n8eyL7j0UV1bw7jUB9b4z07BjEv7g+haVadAEQohVxAOVQnVn+JNkkZbHiFFwsPorMLIvQYb7fp+iYeHGxukyMkkRviSdcMKNYD17nKSdzk5Byx6l1dWg5D017UsTGeW0FSH3KYzOci/RPe2W3kkNYvB9Gq2r9tVXPGC3oQwnE6ocYja8ko+SXJX4dgSm8/2UDQLRTxC/CYUzcvhBW6Gaj6hxRljDFJe68JDNK5o0kdxFSEYgfcpnDy97Qs8goyKoVFcje3gPronLkqJy8x5H3g+iDUJd8O20R6iKNi49KbiOxNEdVNVLWJ0nguvwfk5ssHkscq4UzD62DOmWCuaka9igrVBn1Y1/Yzxsm2h3oVr5eoGFIJncS9cbOe7jdiEpzSh7USLpjB6HnxTrIK/ErJ7kaLrd8KdbJkFXxy8rXvSADLSm8eo1RVPvK89o0d7eO7EhglmJh56EuQc4Vd9RXqKfoh7bYdHOTl2rP3A2/3WcjCJQzGZ6AyTRCGCT6K+tAV7tPFm7ljJrBVSfrLplpKFBgtm5Rj2N+uKXc0WwbiDfucaHd1XR9mVzvuFKW79bz2KoyNKh+7SYbT1q+SpSpM1s/5n+zQq0/3Xz38L+UXDcfer//W5IXtOklX6Td5cPbc4w+eK0nFWkPagACHKx3b/eTuJgZuIcxKFbM
 bimOu1bR
 nDLAqe6NKle36Et0nMQjOe2n5CW6SsLbNS71rb0nVYuajqGlt4tM3fP54i6/AisAPbnW6F9pHTf3A0h29uS5s57u0r9NFsMULR3gjlDB+ILgejnx8qAZ4PVP5e1OxmcNZv+pYPg4iqMFVfkiKziBTJRZ95kW04O8M9wyC8ioq0II86VSEpmvnmV1F03TBtfNnun9zSusOhuyD1Nx2PRt2LvoPnzkjLWnEPiLuvMAF8rde3blB4hWNWbsNKYE9P1Lhyc72UVb0MGKsdMBKfPCz6WMrEHqEhh7l/QezaY5t0nIfXOHamfKUZbWGsp60CgzFdFY6p25kEiOuJFLEntEJyHFuIEHGkbnYK0a1W6tBKCPFfuFf4oQZp8mS85h30kTQcrVtIfndyNf9OpE/9EZw4kuXYvMlgiTBF61WEHvbhDz92JEqdjte4tvHEb4TrfGp5b/vCgXNQpfSO1rL0k4Im85CqemyoAS+6IEC9u+pAHpjsbGtbHc8mFjJDrfhirkohHd9i+9jcTuNgr8/AO/uP+TX26XkdU0c8KaC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-20 15:20:26 +0800, Baoquan He wrote:
> This is the writeback layer for xswap, on top of the base series. Post it
> as RFC for discussion.
> 
> The base series keeps every swapped-out page in zswap. So the pool must
> refuse new pages once it's full. This series gives an xswap slot a
> backend to go, and charge it only when it really goes to real disk
> space.

There is some weird trailing whitespace in this email for some sections.

> 
> Design                                                                                                
> ------                                                                                                
> - Backend: when zswap refuses a page, take a slot on the real swap                                    
>   device with the highest priority and write the page there. One IO per                               
>   slot.                                                                                               
> - Ownership: that slot has no swap cache folio, so record its owner in                                
>   the swap table entry. 0b100 in the low bits marks a backend slot, and                               
>   the xswap type/offset go above. The physical side then does not treat                               
>   it as free, and readahead skips it.                                                                 
> - Per-slot record: ci->xs_table[], one unsigned long per slot, allocated                              
>   the first time a cluster takes a backend. Zero means no backend.                                    
> - Read: a written-out slot has no zswap copy, so swap_read_folio()                                    
>   follows the pointer and reads from the backend.                                                     
> - Release: verify the slot still points back to the xswap entry first;                                
>   the record can go stale.                                                                            
> - swapoff: try_to_unuse() used to skip these slots. It now reads them                                 
>   back, marks the folio dirty so reclaim re-stores it in zswap, then                                  
>   drops the backend.                                                                                  
> - Reclaim: an xswap entry's count can reach 0 while its folio is still                                
>   in the swap cache; the physical scanner reclaims the redundant slot                                 
>   through __try_to_reclaim_swap().                                                                    
> - Large folios: a read starts at the first physical slot, so the run is                               
>   reserved whole and must be backed contiguously; otherwise the fault                                 
>   retries at a smaller order. xswap is SWP_SYNCHRONOUS_IO, which also                                 
>   skips readahead.                                                                                    
> - Charging: Record the owner at allocation but do not charge. Take the
>   charge when the entry gets a physical backend slot, and give it back
>   with that slot.memory.swap.current then counts only real on-disk swap
>   usage, and a cgroup with memory.swap.max at 0 can still swap out through
>   zswap.

> 
> Note                                                                                                  
> ----                                                                                                  
> The base series is sereis of xswap foundation. This one depends on it.
> So if anyone wants to apply this patchset, the order is base-commit
> as below, then xswap foundation, finally this patchset.
> 
> [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
> https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/T/#u
> 
> base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
> 
> This partially refers to Nhat's vswap-v4 series. E.g patch 1 is
> consistent with his patch 3, patch 12/13/14/15 are from his patch 8.
> 
> And the last 2 patches are fixing bugs when charging patches are added.
> Since the charging of xswap is still under discussion, I dind't merge
> them into commits. Will squash them or take them off once decision is
> made.
> 
> Testing
> -------
> qemu KVM guest, 8G RAM.    
>    
> A 4G swap disk /dev/vdb is added as the physical backend, and zswap is
> turned off so that every page has to reach a backend slot. Note that it
> need create xswap device firstly then disable zswap, so every page has
> to reach backend slot.
> 
> The workload is memhog, as in the base series. Every page is filled with
> a fixed pattern, so the data can be checked after a readback.
> 
>   # echo 1 > /sys/module/zswap/parameters/enabled                                                     
>   # echo 100 > /sys/kernel/mm/xswap/create                                                            
>   # mkswap /dev/vdb && swapon -p 0 /dev/vdb                                                           
>   # echo 0 > /sys/module/zswap/parameters/enabled                                                     
>   # mkdir -p /sys/fs/cgroup/xswap_limit                                                               
>   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max                                             
>   # MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 ./memhog

You did not include e.g. cgexec here, so is memhog really running in the
cgroup you created?

> 
> 1. Swapout to the backend
> 
>    Run the workload with 5G of memory in a cgroup capped at 4G:
> 
>    # awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
>    Filename                Type        Size      Used      Priority
>    xswap0                  xswap       8155132   2392176   100
>    /dev/vdb                partition   4194300   2392176   0
> 
>    The two Used values are equal, so the pages reached the backend and
>    the xswap side accounted for them.

This is a bit confusing to me. If I now run free, the written back data
will be represented twice in the sum? Since the written back data is
still presented as used in the xswap device, does it still consume space
there, i.e. does it prevent that amount of new data being stored in the
xswap device? If this is the case, it would make it even harder to
dimension the xswap size since one would also have to take into account
all the other swap devices which are present in the system.

> 
> 2. Pages are read back from the device
> 
>    Lifting memory.max and touching the pages again reads them back. The
>    pages-swapped-in counter went up by 265642, so the read did reach the
>    device. 1010 of the folios read back were 1M, each read with one IO:
> 
>    # echo max > /sys/fs/cgroup/xswap_limit/memory.max
>    # cat /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/stats/swpin
>    1010
> 
>    hugepages-2048kB/stats/swpin stays at 0, because the swapin order is
>    capped below the PMD order.
> 
> 3. verifies data correctness
> 
>    After the readback the data is compared byte for byte against the
>    pattern, one time with zswap on and one time with zswap off, so the
>    pages come from zswap in one time and from the backend in the other
>    time.  All bytes matched.
> 
> 4. Destroying a device returns its backend slots
> 
>    The device was filled, then destroyed with no readback first:
> 
>    # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
>    3157220
>    # echo 0 > /sys/kernel/mm/xswap/destroy
>    # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
>    0
> 
> 5. verifies the charge is correct
> 
>    An xswap entry is charged only when it holds a backend slot, so the
>    two counters have to show the same number of pages:
> 
>    # echo $(( $(cat /sys/fs/cgroup/xswap_limit/memory.swap.current) / 4096 ))
>    526852
>    # awk '$1 == "/dev/vdb" { print $4 / 4 }' /proc/swaps
>    526852
> 
>    Nothing is charged while the pages stay in zswap: with the pool holding
>    them and the backend untouched, memory.swap.current stays 0.
> 
> 6. A cgroup with no swap room can still reclaim its anon memory
> 
>    With memory.swap.max at 0 and no xswap device, the cgroup ran out of
>    room and the workload was killed. With an xswap device and zswap on,
>    it swapped out through zswap, was charged nothing, and was not killed.
> 
>    E.g if memory.swap.max is set at 100M, the cgroup will be killed when
>    the cap was reached.

Disregarding my comments and opinons on the interface, it seems to be
working so far and I can see writeback happen during a GCC 17 build on
my BPI-F3, but the entire thing takes roughly 18 hours and is not done
yet.

> 
> Baoquan He (12):
>   mm, swap: tag a swap table entry with its owning xswap entry
>   mm, swap: prepare the folio-less allocation path for xswap
>   mm, swap: add a physical backend for xswap slots
>   mm, swap: use the xswap physical backend
>   mm, swap: fall back to disk when zswap refuses an xswap page
>   mm, swap: support swapoff of an xswap physical backend
>   mm, swap: reclaim physical slots backing cache-only xswap entries
>   mm, swap: back a large xswap folio with a contiguous physical run
>   mm, swap: enable THP swapin for xswap entries
>   mm, swap: drop swap_folio_sector()
>   mm, swap: do not retake the cluster lock when uncharging an xswap slot
>   mm, swap: drop a refused xswap backend run directly
> 
> Nhat Pham (5):
>   mm, swap: prepare the swap IO path for xswap backends
>   mm, swap: split the swap memcg charge helpers
>   mm, swap: do not charge zswap-backed xswap entries
>   mm, swap: charge an xswap entry when it gets physical backing
>   mm, swap: don't gate xswap on the physical swap free count
> 
>  .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
>  include/linux/memcontrol.h                    |   6 +
>  include/linux/swap.h                          |  69 +-
>  include/linux/swap_ops.h                      |   9 +-
>  mm/memcontrol-v1.c                            |  10 +-
>  mm/memcontrol.c                               | 147 ++--
>  mm/memory.c                                   |   7 +-
>  mm/page_io.c                                  |  95 ++-
>  mm/swap.h                                     |  35 +-
>  mm/swap_state.c                               |  12 +-
>  mm/swap_table.h                               |  53 ++
>  mm/swapfile.c                                 | 742 ++++++++++++++++--
>  mm/zswap.c                                    |  20 +-
>  13 files changed, 1026 insertions(+), 181 deletions(-)
> 
> -- 
> 2.54.0
> 
> 

