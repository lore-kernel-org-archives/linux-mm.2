Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE8B7C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEBF56B00A3; Fri, 21 Aug 2026 13:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B666B00A4; Fri, 21 Aug 2026 13:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B1D6B00A5; Fri, 21 Aug 2026 13:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88E486B00A3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:10:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E90312017B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:10:35 +0000 (UTC)
X-FDA: 85125915630.04.035FED9
Received: from outbound.pv.icloud.com (pv-2002k-snip4-3.eps.apple.com [57.103.64.154])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2383C20002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:10:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=gEYoKaMJ;
	spf=pass (imf13.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.64.154 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787332233;
	b=n5eiBP+YCszpu1ySdmh15pNT41W4+p/LSZtuPGDnyqaogANKGh6etS936HcgztAoaCL+zM
	InV1NdKwZj4vGjXCCWNNdkTOQQz8sZttE1uD2BKvX31dA7EKM5/2zWcZ7qE5C+3NfdoJHt
	oQIZNP0Pjx7eTjuqp+YOpEwf2i2GNN8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=gEYoKaMJ;
	spf=pass (imf13.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.64.154 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787332233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7vmQEH+EXJnCGy6NDM0LcFuCB9ULXv4xHDAVnQjTbw=;
	b=5TEkRFfvpiVZFEE95Xo/vWX6uyVVs1sKK4oKGKnDmazcnsdzfNntJH/nzbK4N4t9pMVMBy
	t87OL4LFe6jyEj8zGQAOVdxkT2fsyt/g9S/zsNsuEPbFbWDJIJgFPDLcVMmkyD4D4xWvfT
	egEgxbW4guLxOOZ5zmwf46IVnjl4NBU=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-2 (Postfix) with ESMTPS id 4D654180035B;
	Fri, 21 Aug 2026 17:10:26 +0000 (UTC)
X-ICL-RepId: 01a0254d-6cb4-7d74-aa23-6d7ba8a8508a
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwVaEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFAGWxIYXBRcUFgeRhJWDV0JGRtEXlAbXwJCDxwTVhUTHUMZDysISgRDB0UCXgslEwlTVl8VFxtcABcGWxQERAFdBV0CSAtJAloGWwNJF00AXQVSAl0IVVUIRRlTHhccRgxFGVswVB0dDlgGDFBNAUMICgJRHFYNVw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787332232; x=1789924232; bh=y7vmQEH+EXJnCGy6NDM0LcFuCB9ULXv4xHDAVnQjTbw=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=gEYoKaMJPVootcGsoImNWYqlHnP6cRmimFHOK4FBH1CWqeOM+7gVH9HLKHihCLNOZKWLGvD9kuyhJMYaIMt8ZLU8oElqTkAmhwMC4qrE9pHj2wrLLEYuTcPXNGMeCixS0t86lOntAOHVdEiLV9MYcs09iOIfGK8Bh+eOp5cTQ9NWnTegkwnF4YJ4lBfJbkdk6Z2q3HEzMS4rCUbnO/GbIiVRtLRw5jP4Xm5JHFEXaGkf98inQPUlI3oyQ6PJJQTBKqoMW5D3D7p0/NVFaV30T2j5czxSOKsyUlqS3DdGBODyGkyNUP08FEF4PqPGxI652+DKCepoVM3MJd0ntXR5og==
Received: from ncore (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-2 (Postfix) with ESMTPSA id 7AA1A1802180;
	Fri, 21 Aug 2026 17:10:23 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
Date: Fri, 21 Aug 2026 19:10:17 +0200
Message-ID: <20260821171019.530290-1-ferran.duarri@me.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <06f5eea7-c6e7-49ed-8f45-0c6c86a04c26@kernel.org>
References: <20260820190825.221308-1-ferran.duarri@me.com> <06f5eea7-c6e7-49ed-8f45-0c6c86a04c26@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: g5bQ3r4UL7hR7-uJueVRq5EREg00XwRO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDEzNSBTYWx0ZWRfXylG5i1v7Ltdi
 IxkNdAL6kaSEBiFVLG4wWz0Scay4VsqGnB6BbsczPKOvJz3gTovt5xMd92HVohIF8Ow2kr7DkDA
 PJjthsNo+n4CjvKGlQJk0czcJ0Nq+oSruT3vZ2C1H0UlW/JEPSNIYM3REHC1dfyjhziUGYEULSh
 hiU5tkYaBI3rSmNArOAA59d41JGcoUsCAbwSLlIPW04tjcudzcD6dbCj1QRKmhQvjBvDdWmGysY
 3b34EFyRRzm1IO0jey8JTXusXIR6TlkPQgNwx8YGaBs7xI6xpH/+sWil7/0xUtmj7ER5lC77A9V
 eALVKzXVBr3L21l0RsNYrvE8ObNB1EglOn8ohyIvo9rF6ClajOxiAmPyQ7A8H8=
X-Proofpoint-GUID: g5bQ3r4UL7hR7-uJueVRq5EREg00XwRO
X-Authority-Info-Out: v=2.4 cv=VMPQXtPX c=1 sm=1 tr=0 ts=6a888683
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=x7bEGLp0ZPQA:10 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=PCHdVTuO9_M3hTcQpgcA:9 a=QEXdDO2ut3YA:10
X-JNJ: AAAAAAAB7+eZj6DEaCgCBjELS8/Km6w2M1nLXrEPw5dfxgis1/HffaeQBMdKktdOnwp7+H9hQMSdhB46/YOEOqIoOtVAT0svE8vKMdvXqXjSpouOm6R01Gm/ml+BEZaug7P+NAviyzKYyiy+lVrOfh7nIA32rpnK7FpBifiiBz66+LlGXN2n2Ye5Sd1coL+sJ4ZESehT1UQI5jcy9mSX2Wdib0h2tt01JHRCBpPCqb++o8KoVLYQ8kqTBJ+XnLocMA+aQqhNkOA3EtinYQMjDnFAfqgaJRK50suxX4XDeB9QA3mlbyxI0J9Tpb+yOlwYODiOPpragrVyVFQjw/chL6eIBQPM/7EI3rI149ZE60eXAwxt7IW4D6h2QXvWi74AxODQlJ12TcCu22kV+9AIFEeCpwaJENwXl4lMaSpbMBezSPbBTXHmgAFs9xTeyt//majrxxW75P7lJSQLrybsaP4ez3fSE/rcrwoqXzmBilr2V6DauLPPazKYdUj/kn0FVuHlYgDO6vCmmId3Ze10hfjHFSpPEjM5oFuanSKf7Ol863AlQT2ww+iK+OvzGLY429Cx73jR07wa3jJcDQDoMMT2NE4EO5gyBUAAAs8sX0HgVRkI/HbjqMQH8fCpmLlc/pRtN2IC0nDhVO7kKLnAL7GNwFmREf0ktDdalkRj3dwJsGZkC6pBasSeJ1IYr9Y9kjf6yzv3WGy5WqM8m2QoEpD1/lDZGYjNJikbU8rPAmortUPKFIdGXLXGddkophdaPBsvG1sdFxriOfwSiShVUialnbRxoqe2CQ+v7HstH8TSCxTn6upXoHGLYEcnXBmSdT1XLITy5uOPB2QlajkBlTRGpxpalSfrAVM3PoQ+pc0Z9jE7ZXkFEmi222UZuLG04dFZM1PYxl4jlqlnFNGzOrzejYKBPivp47KcLPzrrElqwKZWwqvkrPZt49vhMPxRmOdYjiyXjxZLMMrWL+4yCM+
 09gK+rAJ
 tkYsJ7A09OaI5ze+sS+m+8uKlSk+WB5J6jeJeZcBJ1sgmvvjTMI1lCKLr3rw6jBv72C+ofMfquHPTdR4MZxupcS/bSV6/GB/nQuymcvxYBlbreXlGag/OYLKkFdM6pk3BC4iGwTXvj/PEKWx5yKzJCL5200KDzVJBnVBNf5Y2pB1GRhhaGZqVox6N42rLfjs2UIm6Fmzdss9bGlUuxNPVCbGkRs+FcxuFK0NEVTf8OkHtPqrXIEZdyK98Ic5lhVwxznXyS6Dt1w==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2383C20002
X-Stat-Signature: obi967s6go7ea769yk696um5465jp6hs
X-HE-Tag: 1787332232-805549
X-HE-Meta: U2FsdGVkX1/YKU7ImVLakZgFvCol3u6cRnXjjg/QaGPutKzwZt7IvD+33RyZmP2VMUNt/QLdyLXWH+7FjKdBke0EEUVrMac4z7sq2+XqbvOrt1xhG/vgHz5qlGQ4RofpVwkfNUq8/yfBP+YcG7jHfrJPXgavRkDBc3qJQU0L1G+UAbMw6Ojcl4Lz6sec5xqQ9CZQvfMeWzBQRe0/630H3HokjnQN26rgOIR2tj0PyZs0hoagkCnd2tH6Es21qg5L5bMvd+NIotugIWp9I8eTCB4D/091eQeosjjQJ3h4JkNpmaeyYXRC+gDQ0qHV+BekzMsN70zVpKLmipZ1sqSTyGEeoxznoC/HrXgQLracI3MJ7w9Dmds0773v8dl6cyPCtTIPnhwHmLbks+lfPm6zTnpb/x/Jm3ZNpU3nQ4AOEs01Pqd/MeGjJRI0UQcD76ppGjDukeVn5htpLavZOhzaGEnzSPNnyEVDHZMETSmccKwxF0hmNfz9Men1a0Vne9BHRHgmGk092aEvYspSo+7whk8ds8/nlgGXxOBTbGpCBb/imELk5uTDHTu+83NypTTd0srLMIgtYPZTH65trRJYB2v1yRsDWVNrPmv7RYpMtbI3Nh43sQuLoqEd62bJ/UoDWWtGOHPnwT3DHnpMh6krwVJcmrWndCHxtIQM8aT5kJzVuQWwHwfBrVTzLIvUSSJCHATuo9nMNMbUqaqPaegSbkjqQfZrQyHfeNuJhiSkBYVlf+TLtgoiwXzsh1vzLGittBGQ5sY+wM9/6ABxx7f3ePARRUppd9Gls1/Y7cMLlY1U01kzGyOVwtqaKBd1l5518bqHHc3DR4F5uANsMSwhk+YgJf27FWT0iUj1QoR6RfJIoD5/a3NLnxI42XQdSgD7zPqg1XkNk4299+vnjnqtatgei+dNApj3gb7HuZA/6IirR/DDcAU2mhQPDaJZMSu+XHWfbb0ResF+GddUjok
 VpsZrcCk
 FByFrFWxtuCvJriAVdcIRcLSBulauvqU0Xej7Mrkg5w4biLjd1lVezkTH+IefKwwAUyN3FHGlv4IUEDTgjVoCGu49gneSMDMn0PAkS+2vQf1+0GsrVpwkQnNcDa2oz8Y4bfnZ1y9PvVAQUtkphKIvqfeLjOd7Y5Jd+ip3oHQMHUNmqkHK6R8fGpdNowQVZXDFgzCcBi1TZSdSXpsT3AOFl80louppz+cytAdSXZqjh5zpS9TefNEWmGiltMdHig6jwmVO1SxXJ/2/Vd8besqCLtSmoW6RbCcCpBEV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please drop this one, and not for the reason you asked about. Your mail
sent me back to read the code properly, and my commit message has the
mechanism backwards.

I claimed:

> Paired with transparent_hugepage=always every anonymous fault
> becomes eligible, and under memory pressure the faulting thread can
> stall in compaction.

That doesn't happen. In vma_thp_gfp_mask(), the current default:

	/* Only do synchronous compaction if madvised */
	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, ...))
		return GFP_TRANSHUGE_LIGHT |
		       (vma_madvised ? __GFP_DIRECT_RECLAIM : 0);

A non-madvised fault gets GFP_TRANSHUGE_LIGHT with no reclaim flag at all,
so it fails fast and cannot stall in direct compaction. The stall I
described is only reachable from a MADV_HUGEPAGE region, and defer+madvise
keeps __GFP_DIRECT_RECLAIM for exactly those regions:

	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, ...))
		return GFP_TRANSHUGE_LIGHT |
			(vma_madvised ? __GFP_DIRECT_RECLAIM :
					__GFP_KSWAPD_RECLAIM);

So the patch removes no stall. What it actually changes is the other
branch: non-madvised faults gain __GFP_KSWAPD_RECLAIM, which they did not
have. That is strictly more background work, waking kswapd and kcompactd
on failed THP allocations across every anonymous fault under THP=always.
The patch does close to the opposite of what it claims, and on a
fragmented machine it is a plausible regression rather than an
improvement.

transhuge.rst says the same thing I should have read before writing the
commit message: madvise "will enter direct reclaim like always but only
for regions that are have used madvise(MADV_HUGEPAGE)".

Zi Yan, that also answers your question, and you were right to ask it: the
extra kswapd and kcompactd work you identified is the real effect of the
patch, not a side cost of it.

One correction to my own patch while I am here. I wrote that the machine
could not testify: thp_fault_fallback 0 across 60682 faults, compact_stall
0. That was true when I sent it and is not true now. Same box, THP=always,
64 GB, after a few hours with a 27B model resident:

	thp_fault_alloc     213690
	thp_fault_fallback   22145
	compact_stall         3762
	compact_fail          1926

So it does reach the fallback path, it just had not yet. I am not offering
that as evidence for anything: it was collected with defer+madvise already
in effect, so it says nothing about what madvise would have done, and
defrag is writable at runtime, so the A/B costs nothing. If I get
something worth showing, it will be a fresh patch with numbers in it, not
this one.

Lorenzo, no argument on the patch. It is wrong for the reason above and I
would rather have found that before sending than after.

On "distros can set as needed", that is the one part I would push back on,
and it is the same thing David asked. They cannot, other than by writing
to sysfs after boot. There is no Kconfig symbol for defrag; mm/Kconfig
offers only the ALWAYS/MADVISE/NEVER enablement axis. There is no boot
parameter either: setup_transparent_hugepage() sets
TRANSPARENT_HUGEPAGE_FLAG and TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG only, and
thp_anon= is a different axis again. Grepping for what sets the DEFRAG
bits at all outside the initialiser, it is defrag_store() and nothing
else. So a distro that wants a different defrag default ships a sysfs
unit, and anything faulting between subsys_initcall(hugepage_init) and
that unit gets the compiled-in value.

That may well be deliberate and sufficient. If it is not, a boot parameter
is the cheap fix and I am happy to write it. Either answer is useful to
me, and I would rather be told it is a non-problem than guess.

Some context, offered as an explanation and not as an excuse. These
patches come out of running large models locally: I maintain a custom
kernel tree for my own inference workstation, and the changes in it
accumulated there first, against a real workload rather than as ideas. I
have started sending them upstream to put that pile in order and to find
out which of them are actually correct rather than merely useful to me.
This one is a fair sample of why that is worth doing, and of why the order
I did it in was wrong: I posted while still testing, instead of testing
and then posting. I am slowing the pace down and the rest stays local
until it has had more than this one got.

Thanks for the review. It caught a real error.

Ferran

