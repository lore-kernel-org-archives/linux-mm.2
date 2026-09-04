Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB01C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F426B008A; Fri,  4 Sep 2026 04:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67176B008C; Fri,  4 Sep 2026 04:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CA66B0092; Fri,  4 Sep 2026 04:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4F746B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:01:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B8AAC08BF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:01:50 +0000 (UTC)
X-FDA: 85175335980.22.652FE60
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FCD1100002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:01:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf14.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788508908;
	b=hXWVhEKkpHkiK8n78ffrPdQyfsZTOhHn+KAJt5OlRHQe7Ok8OqNLMUf0SB+palBy9BPskM
	pV9VL8Hh1gor7HYiZb+6sPb3xaJ5h1DV8KcfnEQfT4TywfocKL6ZTaSkOsw4Y96W17H99f
	3/Ax06+oUx2hddkF8nQX6tYXCgexCNY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788508908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LrsCeQXFwniDDOs24DEYD86hpQVWso7CyprcketDD4=;
	b=rtKhLMRlsIhw6gmS4BBjuqhUAzKTDtf7fyPBXlm1sXssoWYyZVv4TWnxuCDUA7v5ssemLT
	5QJdrzLdk+bICecwlf1oxU1tJiySpH1/r9zcTUSEhRZN6TU1THygbqX5l53wvoBuP6Hv34
	VAWge87oATmmAqeVweqdwHatZjCxc/0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf14.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-5a-6a9a7ae7aa81
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	urezki@gmail.com,
	chenwandun@huawei.com,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the interleave paths
Date: Fri,  4 Sep 2026 17:01:37 +0900
Message-ID: <20260904080140.1992-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <apgzMZQPTxS9QtDy@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsXC9ZZnke6LqllZBjOLLeasX8NmsetGiMWX
	d6uYLJ5v/cVo8fPucXaL41vnsVvsuwiUvLxrDpvFvTX/WS2+9UlbrL7IYrF6TYbF7KP32B14
	PXbOusvu0d12md2j5chbVo/Fe14yeWxa1cnmsenTJHaPEzN+s3jsfGjpce5ihUdv8zs2j8+b
	5AK4o7hsUlJzMstSi/TtErgyJkzcy1jQI1Gx/Ox2xgbGdUJdjJwcEgImEgv/PWOBsWeufcXU
	xcjBwSagJHFsbwyIKSKgKtF2xR2kglngJ5PEqhl6ILawQITEr+19YJ0sQCUvPrUygti8QFPe
	PpjPBDFRU2LdxltgNZwCZhIfny9jB7GFBHgkXm3YD1UvKHFy5hMWiPnyEs1bZzN3MXIB9X5n
	k/h98hvUIEmJgytusExg5J+FpGcWkp4FjEyrGIUy88pyEzNzTPQyKvMyK/SS83M3MQKjYlnt
	n+gdjJ8uBB9iFOBgVOLhvSA7I0uINbGsuDL3EKMEB7OSCK/1wulZQrwpiZVVqUX58UWlOanF
	hxilOViUxHmNvpWnCAmkJ5akZqemFqQWwWSZODilGhiTlRM77kb97aifw53+z+B51ZTXOwO0
	zR37ppbOmfL7ltHTjRHrhH70ROzO3VLZN7vTPOLWBLPWsDTxK3c3WMVM8Vk1o3PzZ7W/Ev0f
	uFmMQ3KVVOvPVzc3Bom0FUZ6ulgylMTOEdmxYK3ztz8fdHa5cu6f5yx3X2H7bIm4p407ZhTy
	qdmbvFZiKc5INNRiLipOBAD97pcYhgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsXCNUM9Rvd51awsg9U/9C3mrF/DZrHrRojF
	uSmz2Sy+vFvFZPF86y9Gi593j7NbHN86j91i30WgisNzT7JaXN41h83i3pr/rBbf+qQtDl17
	zmqx+iKLxeo1GRazj95jdxDw2DnrLrtHd9tldo+WI29ZPRbvecnksWlVJ5vHpk+T2D1OzPjN
	4rHzoaXHuYsVHr3N79g8vt328Fj84gOTx+dNcgG8UVw2Kak5mWWpRfp2CVwZEybuZSzokahY
	fnY7YwPjOqEuRk4OCQETiZlrXzF1MXJwsAkoSRzbGwNiigioSrRdcQepYBb4ySSxaoYeiC0s
	ECHxa3sfC4jNAlTy4lMrI4jNCzTl7YP5TBATNSXWbbwFVsMpYCbx8fkydhBbSIBH4tWG/VD1
	ghInZz5hgZgvL9G8dTbzBEaeWUhSs5CkFjAyrWIUycwry03MzDHVK87OqMzLrNBLzs/dxAiM
	gGW1fybuYPxy2f0QowAHoxIP7wXZGVlCrIllxZW5hxglOJiVRHitF07PEuJNSaysSi3Kjy8q
	zUktPsQozcGiJM7rFZ6aICSQnliSmp2aWpBaBJNl4uCUamCcdP57uuqcIDNOU7Ubd7++2fMk
	+fyCuY9Wtt2+v9ixN3iju/aTkxw3dR9c/bp3mv8ilpaI0KblMocWbWQT8dWe6RO4+FCxSvXG
	UIZU3oAT/0UL/L6ejujveeg917dfZm7Mz2beSz/PrfUV+p/XvVD6q7HEVq+TYtd/7Hq9ykVt
	UrUJU1nvtWc6SizFGYmGWsxFxYkAWumk2XwCAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FCD1100002
X-Stat-Signature: am61p4963bpid8jozp5y9r9ws6hb8haf
X-HE-Tag: 1788508907-47582
X-HE-Meta: U2FsdGVkX183LGZeG0pNrLL8NnLpDW1OzyZsOHK0H1bKqtteH0ecDJpJWP19dD3FdHQix264+oa8KWczxYklamV+CqxHY+Ul370SrI2lwDWl+e6ziOKMxVdJstoFPF3c/k9w2lgY2/9Gzx0XZSnfVYfRtZbspzIaIpbWiiU/lr+5G55gI6p99Qv8tpaECCmCKHB8vXsosvBocaQTDyHLXk5Yhw1Q4OETJv1351SdEhGti/6SyG8kJ8TP8lfEVcLS4CFPVhDZ8phi7/k/XVZ/OvBFLA6hE3vylTnWrU13dFFbuZNQh3wzNidVoh8ULau3ZXSz16mNZiI2TNKYB9B4sNrC7eBYjEqBnI9OTBcdSvVMVXRJ6l9xu2DADAh2FwqDcRZkeKiQ6OcLWL1whPA8XfKlPSxd/585scuga26A2uyPyxVgCYqwPUvx9aW9H/Fn9fbAPSvjGE5gBs+4XkCn200dWkIuiw4C+KzGXnjWbZCqE+ScgBwgFu7zWbjSGtatEOIQ71lrXBjHVpuGFukL9hEMs+psDHT7IeesFkwDz7VD/iXaP0Cnptn29Zq0M7ncDMSKLJA6SM6HXbClCW46+b2mS+fRwVboEnHKzqw9Un8TcLAaeV3IJTQRy46r8T7iO5WL0Go3orsfHx6w6yfe2QMJXU0pb0Fnr5h3mRAlyNr2ujq8bG33DH1waaAytsP2JGRo7ySeb2kA59m15Ls9rlERnh344fuIGaJaThADBNwsPa8dvhRELD8il8M4YCcftpfcP6c4e6Q+Db++3vBDNwj9T0963coJxEL6qOGLTC6hiQ4JsqIEvanNyf0sv7fQ87TqQEoLE1daL3td+pW3PhR6vZyCclDN3OKTSCpShg+5InUjmJlRwnlsSgwoo3o+LjlH5/JsuBXDmT3dHi3R6Ik3XpjXbQAX0BfmT6SmAWobE+kRl4Sg9ZbZjaBcwHwwLanvW/GKkjIJjzJL6oq
 YUxJMLrq
 L9DlXNobJtNlKCVCZv7YmeEScsGO0r3FvuexG364YkC9WAU40gPPGbm/PKVqrEF1+gwID3JecMqEnz+6Fft5K/tps2zQ2Ldp8KvoxX2nb2m3d7MUIu0GHGTOK/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 10:52:45 -0400 Gregory Price <gourry@gourry.net> wrote:

> I don't think this actually fixes anything?
>
> But basically the proposal is to widen the SRCU() window further to
> include the cpuset cookie entirely.
>
> e.g.
>
> SRCU() {
> 	cpuset_cookie() {
> 		for_each_node_mask(node, pol->nodes)
> 			weight_total += ...
> 			nnodes++;
> 	}
>
> 	/* ... snip - single node quick-exit ... */
>
>         /* ... actual multi-node bulk allocation ... */
> 	for_each_node_mask(node, pol->nodes) {
> 		nr_allocated = __alloc_pages_bulk(gfp, node, ...);
>
> 		/*
>                  * At this point, due to a torn read from pol->nodes
> 		 * we can visit a node that wasn't present previously
> 		 * or we can skip a node that was present previously.
> 		 *
> 		 * In either case, weight_total is the wrong value for
> 		 * the set of nodes being walked anyway - we are going
> 		 * to skew in the distribution no matter what.
> 		 */
> 	}
> }
>
> I'm not sure widening the SRCU window is worth it here, it doesn't
> actually buy us anything.
>
> Also we'd be calculating the weight total every time even when there's a
> scenario where we quick-exit because the entire allocation fits in the
> first node in the mask.

Sorry, I did not explain that well. I was not suggesting moving the
sum into the cookie loop or widening the SRCU section - only adding
the counter to the sum loop where it already is:

	/* calculate total, detect system default usage */
	nnodes = 0;
	for_each_node_mask(node, pol->nodes) {
		weight_total += table ? table[node] : 1;
		nnodes++;
	}

The order of the function does not change, so the quick-exit path
still returns before this loop runs - the sum is not computed in
that case either way.

What I had in mind is the gap between the two reads. Say the policy
starts with two nodes, every weight is 10, and 100 pages are
requested:

	/* the mask is {0,1} here */
	do {
		cpuset_mems_cookie = read_mems_allowed_begin();
		nnodes = nodes_weight(pol->nodes);	/* nnodes = 2 */
	} while (read_mems_allowed_retry(cpuset_mems_cookie));

	/* a rebind grows the mask to {0,1,2,3} at this point */

	/* calculate total, detect system default usage */
	for_each_node_mask(node, pol->nodes)
		weight_total += ...;			/* 10 * 4 = 40 */

	rounds = rem_pages / weight_total;		/* 100 / 40 = 2 */

	for (i = 0; i < nnodes; i++)			/* bounded by 2 */
		...

The distribution is planned from a total of 40, which spreads the
100 pages over four nodes, but the walk is still bounded by the two
nodes counted earlier. It places 60 pages and returns, and the
caller allocates the remaining 40 one page at a time. The mask does
not have to change again during the walk for this to happen.

You are right that a torn read during the walk still skews the
distribution, and this does not change that. It only removes the
case where the bound and the total start out inconsistent. If that
is not worth the extra line, I am fine either way.

Thanks for looking at it.

Rakie Kim

