Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF76DF53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1034E6B02DA; Mon, 16 Mar 2026 11:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0A36B02DC; Mon, 16 Mar 2026 11:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4296B02DE; Mon, 16 Mar 2026 11:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DABD06B02DA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:19:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8011E160215
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:19:38 +0000 (UTC)
X-FDA: 84552285636.13.B027BA1
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id CDE7C40011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:19:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WJ4SKPFS;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773674376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2chYU1ux6ZQIx4otnZe8opROVQFDtOWN8KCrqkEk7A=;
	b=r+8RLjsUIC4zt/1sk1iQa3ouR4TzWK8eTEksjOml39IKmYTTtkAyvy3q5Ri6x1PX2U4jVC
	feF3TxAc3jdnzcLCoF+OJetJmMl8Ry0C5qXvN6td0f+T/mLJFwyZkpqN6fSTquH5wAJSfc
	C1XG1ocgWtDnQCLzueIDmcwS6o11XOA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WJ4SKPFS;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773674376; a=rsa-sha256;
	cv=none;
	b=MNbXgNSORe2WXcfCoEClgVNZrEaOFqK2gHj3ApvJ3Yb7zHwaHZjrIwYlPAmlN6XwdonOfJ
	kWp5Cid6P7v17hPTEpYEy6vlOhZDVZ3PLcOAROAsoCjnqfXXoBe9Cn/wLPJZuD009fZj0l
	ycwjWC21PARmxwqrIri1ScPyl4VJG0c=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d7447778b9so2331907a34.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773674376; x=1774279176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2chYU1ux6ZQIx4otnZe8opROVQFDtOWN8KCrqkEk7A=;
        b=WJ4SKPFS7ulUIfpCSGl+/h0zGwlm0/4qUcM6lpAPnXNYyisynoG9jeCPczxtZZQrUL
         rWXhanAGs28n9WjOHbIn/VHz+1pDIoxRloUPZpcNFmM3JeIHSU6ZGWaWYxAj/Of8shri
         YqphX1CRhatc3vbZnDBV5ze4y6V58MQdVh31tuCMPmZJ5S86PpUHacpvos+BodkcIHQw
         bYACPAR+t/nkYhEha8WLumH00uHYrAZ6GPvn2FztZV339Dm1JSi2to990O9Um/ulHseI
         5JCDAz+PWgSrVW6Z6y4+KubCKkFbWa0h8rtUfqEuJwOlI4Lx1pz4ZVolaYi1puPv4TxZ
         j2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773674376; x=1774279176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m2chYU1ux6ZQIx4otnZe8opROVQFDtOWN8KCrqkEk7A=;
        b=npIKnc6eQjMEkIm3yOuaAb0VUejP07VK8B5rYOJh6VBHs7xIj0yuH44cd32KIe5HhO
         bOPNbY0akpKHoY0l6z8CBHNh52MMDhhswlJ4rZK9H0NwzIWve+QyBkjIbRQgpqpuGVgZ
         bJRT9fnG0Z1XNslbefGwYew4zC3HiEupyqRpAOOpa/JOXpbHNdX2+WCvLX9ADAebyEHP
         j2rIcyx7qOQtQyBSPHj7b1+jv8vQZ6r0CvKNdKPz56FtdfVLTSrIITfIKbM0lA3uuPwF
         duupi0Oj+ywkJTSC+Fgr3jT/ETYu6B5C4ptw4qS+GAJUUXlQ+n1X5hKrB+aH30ZT0yqS
         JnhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtFmMUEWu+OGE5R+zV8OHg/ON6dN/auwCQm5YsGE/Hi/JvteDCcySRPJ41wyIeb7jFPuV7K0AfPg==@kvack.org
X-Gm-Message-State: AOJu0YzntyGuYTVvD9/weYGql8u1oMbAniW8Fe/g5QfQ1Kz5ivJG+rSA
	38Xs1qTQPPiov9R4H5F5QpOqOAy1svf3J6zp9gtJv8X8d8HEgdzPp4kM
X-Gm-Gg: ATEYQzzqs/mfcbXUa/oM3mUmlU4VZLgvtTJugot0k056vVuBwfSRwf62C1Ax1dJ7r0w
	ci+eeT3rFqNO5lrUbDtlqkibgyq/AGT+6tRKciJcB5/10p2nSv3x6xt1cmgKL1IYIaH3WB6zE7a
	LEkaDO2To+swK4LxpkgppNcn7/4eJazRuE84eqDGyXsreBCwYt0/euoh68NYSVHmywpA9z4hgWD
	FNAltky6vYyH9LFcdD11AadwYJ4xy+S00yk57ZW8Xi4gJiZB59gvnbW+Q7r8qXUFKyOTqTOkuYL
	9BuLiyiD3+4z4F3gh+cWJ/ppLSxBug4K4/2logWa0x4vm+9LHuvkfW2BCrjjSQp7EWKqMTAB4ly
	9/wEA7RCXIBXHBieuEQfnSdTePmQgzk73bKPJKgFZtNaByw4KUyvZ3wVv4sO1hYR3xHkfFBwy7O
	SeZ+MXtQlPt7gXhEvCBdl+QQ==
X-Received: by 2002:a05:6830:648b:b0:7d7:4074:3382 with SMTP id 46e09a7af769-7d78248b731mr8382454a34.10.1773674375662;
        Mon, 16 Mar 2026 08:19:35 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ac8ce73sm13670944a34.11.2026.03.16.08.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:19:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 16 Mar 2026 08:19:32 -0700
Message-ID: <20260316151933.3093626-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDE7C40011
X-Stat-Signature: zxnscuyx1xmbanpnsimxwzpoqq9sjhxg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773674376-610660
X-HE-Meta: U2FsdGVkX197FCUavyRvnOYttbhsomJnLkhd+aQb/XLIj36D+kk2Rxnl7LzWZeILPHkE4tnZyg/hRKtgrEJxJ9njnujTlEn5/gNqJS5XKETBg0qEFwfniZpBlri7aGj1LGHI1I4gvy6wpNzxoZLeBEwDgdwjaxo0/76TxBBoGo2yvIO5/7SI1fj9BNQK/47arCIFIM+MG+qS8HGxjs/YtjRzB1uTF66UCP0gOZgxGUh/jPGjw5MCx7463bes5HAVnjFM61HHv0MQW7yAUJGOIrMZiickPpDQJgwqk4ukwqByu8eYsHH8FX2o/7mvN+yLs1fx4J6LRgCRsexAPgx1txSRHiOclX6IPNrJ2pNPpi+3hgaDnCcfwTwbk7WRlPA+JPFehQzpDh2YCIC9l49DGaqHJa7WI349AZNtOQbjpMEBLy+/gmZRPrKNlAw8bGKOX9YFeIySxqzKl8C/30VruDWQ2LugBM6PztSrJEnp4ojVmzzHOecTUtCypeSfybDZxGQIUXNQxevSfshlzHbSaObZr1k/2jZskTQGzZzUoRRaT0+ERG2IhNYN2GhfytY8wTnLwhYCFgdyNmAvgZiU02YXtoqk/9NKYa/vzOD8+1ARodzCMTdcItZoiQ+a9U1xr0Isqov5/Z56tzArSRpyLOM4vbi6RhX/cCoXwcci1K3dd5Uo83jNhJLmFcFHufs9RW8BugLQb8zG6rFhKfslUaD2KstaZrhzLBc1M6rlkBCH7sSV/1u2R+djQTxjbi+PEeSpvMOjpyan5F+C0bwZFPmmMsa22O6NZkZlYf2z1xu2GAXpALPBwSfB5ilDW3tm7X1XckgGDOvL2fMefZ7HbZbmSVDB7sEfV44Jvf1mdJ05kpaWXYR9wcrHTZgcrRlgeSAVTL7cSUbSEftatRxCF6D9udR8Q0NJhU7VYWdeyoxpOnYOuv/MG6FEBb9yk0cmBcpeZsK+QOtF/O4LvLN
 oz1SrVw5
 KXB71yWozD9erOFVzQXNQvY65ewPbFi50XR8jwS+4IzO5ebokPgVv1lQye3zXLKMcSfKlM+eE1V3WeHw93pZY6b3Sp6rgEnLqX2yHFuTgeNJpjFeDCVtIl2J25euSQd12w9mjnNmETIihn+r0vRRPO67ro8giCCcolgXiGTRbru6TnBiWYedCB/+Tp+/XEsX9lDnosorf3dbdbMWzZbZytd999w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Rakie! I hope you have been doing well. Thank you for this
RFC, I think it is a very interesting idea. 

[...snip...]

> Consider a dual-socket system:
> 
>           node0             node1
>         +-------+         +-------+
>         | CPU 0 |---------| CPU 1 |
>         +-------+         +-------+
>         | DRAM0 |         | DRAM1 |
>         +---+---+         +---+---+
>             |                 |
>         +---+---+         +---+---+
>         | CXL 0 |         | CXL 1 |
>         +-------+         +-------+
>           node2             node3
> 
> Assuming local DRAM provides 300 GB/s and local CXL provides 100 GB/s,
> the effective bandwidth varies significantly from the perspective of
> each CPU due to inter-socket interconnect penalties.
> 
> Local device capabilities (GB/s) vs. cross-socket effective bandwidth:
> 
>          0     1     2     3
> CPU 0  300   150   100    50
> CPU 1  150   300    50   100
> 
> A reasonable global weight vector reflecting the base capabilities is:
> 
>      node0=3 node1=3 node2=1 node3=1
> 
> However, because these configured node weights do not account for
> interconnect degradation between sockets, applying them flatly to all
> sources yields the following effective map from each CPU's perspective:
> 
>          0     1     2     3
> CPU 0    3     3     1     1
> CPU 1    3     3     1     1
> 
> This does not account for the interconnect penalty (e.g., node0->node1
> drops 300->150, node0->node3 drops 100->50) and thus forces allocations
> that cause a mismatch with actual performance.
> 
> This patch makes weighted interleave socket-aware. Before weighting is
> applied, the candidate nodes are restricted to the current socket; only
> if no eligible local nodes remain does the policy fall back to the
> wider set.

So when I saw this, I thought the idea was that we would attempt an
allocation with these socket-aware weights, and upon failure, fall back
to the global weights that are set so that we can try to fulfill the
allocation from cross-socket nodes.

However, reading the implementation in 4/4, it seems like what is meant
by "fallback" here is not in the sense of a fallback allocation, but
in the sense of "if there is a misconfiguration and the intersection
between policy nodes and the CPU's package is empty, use the global
nodes instead". 

Am I understanding this correctly? 

And, it seems like what this also means is that under sane configurations,
there is no more cross socket memory allocation, since it will always
try to fulfill it from the local node. 

> Even if the configured global weights remain identically set:
> 
>      node0=3 node1=3 node2=1 node3=1
> 
> The resulting effective map from the perspective of each CPU becomes:
> 
>          0     1     2     3
> CPU 0    3     0     1     0
> CPU 1    0     3     0     1

> Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
> node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
> effective bandwidth, preserves NUMA locality, and reduces cross-socket
> traffic.

In that sense I thought the word "prefer" was a bit confusing, since I
thought it would mean that it would try to fulfill the alloactions
from within a packet first, then fall back to remote packets if that
failed. (Or maybe I am just misunderstanding your explanation. Please
do let me know if that is the case : -) )

If what I understand is the case , I think this is the same thing as
just restricting allocations to be socket-local. I also wonder if
this idea applies to other mempolicies as well (i.e. unweighted interleave)

I think we should consider what the expected and desirable behavior is
when one socket is fully saturated but the other socket is empty. In my
mind this is no different from considering within-packet remote NUMA
allocations; the tradeoff becomes between reclaiming locally and
keeping allocations local, vs. skipping reclaiming and consuming
free memory while eating the remote access latency, similar to
zone_reclaim mode (packet_reclaim_mode? ; -) )

In my mind (without doing any benchmarking myself or looking at the numbers)
I imagine that there are some scenarios where we actually do want cross
socket allocations, like in the example above when we have very asymmetric
saturations across sockets. Is this something that could be worth
benchmarking as well?

I will end by saying that in the normal case (sockets have similar saturation)
I think this series is a definite win and improvement to weighted interleave.
I just was curious whether we can handle the worst-case scenarios.

Thank you again for the series. Have a great day!
Joshua

