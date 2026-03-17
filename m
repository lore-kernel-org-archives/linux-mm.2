Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78B8FD8748
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0536B0005; Tue, 17 Mar 2026 07:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178146B0089; Tue, 17 Mar 2026 07:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E306B008A; Tue, 17 Mar 2026 07:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB4C46B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:37:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C3BAAC875
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:37:07 +0000 (UTC)
X-FDA: 84555353694.13.A00458F
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id DAE0240007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:37:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773747425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VT6JrNxcCsv/pUv9JSpzMspyBPoJW48BC8MRzPMlqzA=;
	b=RWQoYEzobcGHejpx0wYMiVNRN+xSuv7hQwyYMqXF+8y+x+E4Ok+4P6BDAZx0jGF8NbGJ7i
	1SuIaFzIrPhe/AeBPkYA1IuKSU2qDYlBFuH4Y9U2AWBsWRKa9P4sCylqcFIHqUADTD53kn
	CuTmvOuLT5ue2i16bwwa515i+hBH5/Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773747425; a=rsa-sha256;
	cv=none;
	b=Kyl2YKYcvfqzqA5sDRBIXZ+c275qUVDaiikzmxrUkI0RrbP+x8yxJcSdphShA1klZB9tHL
	T7ri6TD2whzOZgzMUEdG8YC8IcQJimoD8EcVOaOJBbC/tff8ApTbETPvafnqPskgiJdMyH
	hz0KA6m+4nRg0AvCM0hEyCBnctCC1PA=
X-AuditID: a67dfc5b-c2dff70000001609-83-69b93cdaea53
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
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
	harry.yoo@oracle.com,
	lsf-pc@lists.linux-foundation.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Tue, 17 Mar 2026 20:36:53 +0900
Message-ID: <20260317113656.283-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260316151933.3093626-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsXC9ZZnoe5tm52ZBvfbmSzmrF/DZnH38QU2
	i103QiymT73AaHHiZiObxeqbaxgtnm/9xWjx8+5xdov7y56xWOx/+pzFYtXCa2wWx7fOY7fY
	3vCA3eL8rFMsFpd3zWGzuLfmP6vFyVkrWSz2vd7LbPGtT9rifp+DxZH125ksJl9awGYxu7GP
	0eLWhGNMFqvXZFjMPnqP3UHKY+esu+weCzaVenS3XWb3aDnyltVj8Z6XTB6bVnWyeWz6NInd
	48SM3yweOx9aeky+sZzRo7f5HZvHx6e3WDymzq73WL/lKovHmQVH2D0+b5ILEIjisklJzcks
	Sy3St0vgyli/OqBgglVFe2s/SwPje+0uRk4OCQETibm7LjPD2J+2L2LpYuTgYBNQkji2NwYk
	LCKgKXGidRJQCRcHs8AXVok3q/4xgiSEBTIkJiz/D9bLIqAqsXDXfDYQm1fAWOLm9b1sEDM1
	JdZtvMUCYnMK2Eu82HONCcQWEuCReLVhPyNEvaDEyZlPwGqYBeQlmrfOBlsmIdDIIdG9oYMJ
	YpCkxMEVN1gmMPLPQtIzC0nPAkamVYxCmXlluYmZOSZ6GZV5mRV6yfm5mxiBsbys9k/0DsZP
	F4IPMQpwMCrx8N5g3ZEpxJpYVlyZe4hRgoNZSYR32ZFtmUK8KYmVValF+fFFpTmpxYcYpTlY
	lMR5jb6VpwgJpCeWpGanphakFsFkmTg4pRoYuevSOg3v9i7h8mvS+ae2ZanMEs34hUWzzgpo
	TRVt+FydEBEswDvD3WWXTlphoYKyf2eGZ2dv7XSTzrRPFSfYXBcb3Zx29V7TLNPAxaFJa/pk
	Ts6oVeBcU5ZdEeQoPLmO1cbDoTV7WcC5Z5yLJE2OSPyM9/ij82C7qfvdskVTFujf19aavEOJ
	pTgj0VCLuag4EQCCgFZM4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+XbOzjkuJ8cldNAfwkDEIu1i9ilSkmUfQWBUJCboykM7ODfZ
	VJwUTU0zrTlvpJuZpmipZA3vaOY0ddFFG3mZqFnpNCuvCKZkLQn89/A+L++fl8JEPbgrxcnj
	WaVcIhMTAlxQ5Bmx3xrYyh1IyfCBJfV1BBz/MkDAtpEL8F2BgYD3CwcA7B9NIWDtaB2AtsZf
	AK6P95FwsmoGhysz8xjsnLbhsKZ8iIB9jaUk7H5g5sNmzScSvte/xqGlrYSAE3VbfGjWP8Hh
	i/kODK5p3eCkNgiahmx82FPfzIP5H8oIaEjRAmjV9fJgbZ0UbjQ9/hu9miCD3FGrfpxEZcYE
	lJ1hIdGtnh98VNE+x0PGmjsEMi7nkai/aANHrVP+KH+kGqB7aT8JtDRtxdHaGEIVs4s8VGi4
	ieobPuKhonBBYDQr4xJZpc+xKIG0vjY0TheQdDs9B9eAhX1ZwIFiaF9mufkRngUoiqDFTG9H
	hD12ob2Y/vQ8LAsIKIxe5TPfa34Du9hNSxld9RZmZ5z2YMrbHhJ2FtKHmdHhDmJ704t5+tyK
	29mBPs7Mtg/x7CyiHZlvzzrBdt+ZMRd//dfBaHcmrdGA6YCjfofS71BlgFcDXDh5YqyEkx3x
	VsVI1XIuyfuqItYI/n5bdWMztwWsWk6bAE0BsaNwhN/CifiSRJU61gQYChO7CKt6mjiRMFqi
	TmaVikhlgoxVmYAbhYv3CM9cYqNE9DVJPBvDsnGs8r/lUQ6uGjBd6mRQD3b5Sd9eL0DmFWVT
	uW+2YjmMKh22eWpONc8FOdGyQS/y5Ipoi/Wnhu5OZYQFbHavX4zp1p44ZBYe7epVLIWk+kV0
	2i43yINzXu7yP+thCd/KrFxIHSvMxFW6N5+LB3Sbi962qHNYS3J6UySVWxniXKq/sh5cIThv
	EOMqqeTgXkypkvwB51Ng4dcCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: DAE0240007
X-Stat-Signature: 98hwqimu35qyosw9rki3srfzriq8dtqn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773747424-246306
X-HE-Meta: U2FsdGVkX184TIxgVr8jsNjN6KUnh9uB2YnT7D58BIKpEiNhJbYOg+JklaQkiQfcMs7iy+YfQDIqRzHfpVZUfTCm45o3NYJF4D3NsDAXQoowXiAgIFPLKZzUUg8lRGRhl1LF3DUnrATRETSLrgxqSiq9ftJdChhsWb7htmujiMr9mxG1VRG4/wIhTaXn5rO8eAdSTzxXjW0hi7hg+q2tzJwU+1lcqp331xHYt5J+z/0iCYIW+CQIEektWL2ZUL6P9fv/uln8iWD7a0u1KdKy/a7caH4c4YkCnwsTtIIHcnT6dLfBdU7wKOyWFah9n4J47b/spCiu5MsSZQ+/nkj3LlL/OLdeWa36nw0WkA6fAf+opG8IiKwFs46ZzV3syppHKfyflbW/VNADElkNv0AXvEWS2WMVOPVqIxdIqfQhqCds8Q/9mjmO7rQxHQ8s3QRShn+2ldmY3FqfEZa6WNVMeFL4yfut2YnMFrAPBR/bAr7oFVvUQrxZbnqZjSHH4iPQUkUbSAVsg5H3R0svesHX5vPYK3C/0TXjylkTWWHPOJnURi/0NokfbJWo6QxJKHiOFDdwjtUUU0KWiDkIyokK8a1XV0MFOQqfeLUZ5DpXOGkCil33X0+R9HK5YRDSiQjyx25NeHVinEbK/YUBSiZi6k/QoBZuAtg9DTANzZwSjW+B3oTNtVX+3rHmXU7MP8UC0UzKhUKeHSAC0OzutfCk98jqSTO+4PcawTgBCzsc4CmAL32dyf/1aoB99vwznViXw1+jvbHvRIApGcBsJkY0lbp7C+XkXs3sFC3Aqks6qcNu/ZJVUkGfaawC1877PipPvTLHa8K0TPJT5pwdOYySdwT9/YLG0a1l96Do+i3eeXccSMp86DRqg8b0yWmbLeQt1jZ/VGwl1kTmQzEWYp1i6mqfTWTBmaPjQC787W/0P8UgWsKi1ZsJYUVvfz9eSeR+QYrbzGtvt55kudj2dTE
 X+iIz2ts
 5oMSTVoQuDnVWaHaMRW40TTxJImx2tOPP7j5X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 08:19:32 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> Hello Rakie! I hope you have been doing well. Thank you for this
> RFC, I think it is a very interesting idea. 

Hello Joshua,

I hope you are doing well. Thanks for your review and feedback on this RFC.

> 
> [...snip...]
> 
> > Consider a dual-socket system:
> > 
h >           node0             node1
> >         +-------+         +-------+
> >         | CPU 0 |---------| CPU 1 |
> >         +-------+         +-------+
> >         | DRAM0 |         | DRAM1 |
> >         +---+---+         +---+---+
> >             |                 |
> >         +---+---+         +---+---+
> >         | CXL 0 |         | CXL 1 |
> >         +-------+         +-------+
> >           node2             node3
> > 
> > Assuming local DRAM provides 300 GB/s and local CXL provides 100 GB/s,
> > the effective bandwidth varies significantly from the perspective of
> > each CPU due to inter-socket interconnect penalties.
> > 
> > Local device capabilities (GB/s) vs. cross-socket effective bandwidth:
> > 
> >          0     1     2     3
> > CPU 0  300   150   100    50
> > CPU 1  150   300    50   100
> > 
> > A reasonable global weight vector reflecting the base capabilities is:
> > 
> >      node0=3 node1=3 node2=1 node3=1
> > 
> > However, because these configured node weights do not account for
> > interconnect degradation between sockets, applying them flatly to all
> > sources yields the following effective map from each CPU's perspective:
> > 
> >          0     1     2     3
> > CPU 0    3     3     1     1
> > CPU 1    3     3     1     1
> > 
> > This does not account for the interconnect penalty (e.g., node0->node1
> > drops 300->150, node0->node3 drops 100->50) and thus forces allocations
> > that cause a mismatch with actual performance.
> > 
> > This patch makes weighted interleave socket-aware. Before weighting is
> > applied, the candidate nodes are restricted to the current socket; only
> > if no eligible local nodes remain does the policy fall back to the
> > wider set.
> 
> So when I saw this, I thought the idea was that we would attempt an
> allocation with these socket-aware weights, and upon failure, fall back
> to the global weights that are set so that we can try to fulfill the
> allocation from cross-socket nodes.
> 
> However, reading the implementation in 4/4, it seems like what is meant
> by "fallback" here is not in the sense of a fallback allocation, but
> in the sense of "if there is a misconfiguration and the intersection
> between policy nodes and the CPU's package is empty, use the global
> nodes instead". 
> 
> Am I understanding this correctly? 
> 
> And, it seems like what this also means is that under sane configurations,
> there is no more cross socket memory allocation, since it will always
> try to fulfill it from the local node. 
> 

Your analysis of the code in patch 4/4 is exactly correct. I apologize
for using the term "fallback" in the cover letter, which caused some
confusion. As you understood, the current implementation strictly
restricts allocations to the local socket to avoid cross-socket traffic.

> > Even if the configured global weights remain identically set:
> > 
> >      node0=3 node1=3 node2=1 node3=1
> > 
> > The resulting effective map from the perspective of each CPU becomes:
> > 
> >          0     1     2     3
> > CPU 0    3     0     1     0
> > CPU 1    0     3     0     1
> 
> > Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
> > node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
> > effective bandwidth, preserves NUMA locality, and reduces cross-socket
> > traffic.
> 
> In that sense I thought the word "prefer" was a bit confusing, since I
> thought it would mean that it would try to fulfill the alloactions
> from within a packet first, then fall back to remote packets if that
> failed. (Or maybe I am just misunderstanding your explanation. Please
> do let me know if that is the case : -) )
> 
> If what I understand is the case , I think this is the same thing as
> just restricting allocations to be socket-local. I also wonder if
> this idea applies to other mempolicies as well (i.e. unweighted interleave)

Again, I apologize for the confusion caused by words like "prefer" and
"fallback" in the commit message. Your understanding is correct; the
current code strictly restricts allocations to the socket-local nodes.

To determine where memory may be allocated within a socket, the code uses
a function named policy_resolve_package_nodes(). As described in the
comments, the logic works as follows:

1. Success case: It tries to use the intersection of the current CPU's
   package nodes and the user's preselected policy nodes. If the
   intersection is not empty, it uses these local nodes.
2. Failure case: If the intersection is empty (e.g., the user opted out
   of the current package), it finds the package of another node in the
   policy nodes and gets the intersection again. If this also yields an
   empty set, it completely falls back to the original global policy nodes.

In this early version, the consideration for handling various detailed
cases is insufficient. Also, as you pointed out, applying this strict
local restriction directly to other policies like unweighted interleave
might be difficult, as it could conflict with the original purpose of
interleaving. I plan to consider these aspects further and prepare a
more complemented design.

> 
> I think we should consider what the expected and desirable behavior is
> when one socket is fully saturated but the other socket is empty. In my
> mind this is no different from considering within-packet remote NUMA
> allocations; the tradeoff becomes between reclaiming locally and
> keeping allocations local, vs. skipping reclaiming and consuming
> free memory while eating the remote access latency, similar to
> zone_reclaim mode (packet_reclaim_mode? ; -) )

This is an issue I have been thinking about since the early design phase,
and it must be resolved to improve this patch series. The trade-off
between forcing local memory reclaim to stay local versus accepting the
latency penalty of using a remote socket is a point we need to address.
I will continue to think about how to handle this properly.

> 
> In my mind (without doing any benchmarking myself or looking at the numbers)
> I imagine that there are some scenarios where we actually do want cross
> socket allocations, like in the example above when we have very asymmetric
> saturations across sockets. Is this something that could be worth
> benchmarking as well?

Your suggestion is valid and worth considering. I am currently analyzing
the behavior of this feature under various workloads. I will also
consider the asymmetric saturation scenarios you suggested.

> 
> I will end by saying that in the normal case (sockets have similar saturation)
> I think this series is a definite win and improvement to weighted interleave.
> I just was curious whether we can handle the worst-case scenarios.
> 
> Thank you again for the series. Have a great day!
> Joshua

Thanks again for the review. I will prepare a more considered design
for the next version based on these points.

Rakie Kim


