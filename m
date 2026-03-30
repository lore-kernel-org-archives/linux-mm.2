Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DA7FF4935
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 03:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6056B0092; Sun, 29 Mar 2026 23:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD3B6B0095; Sun, 29 Mar 2026 23:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA8B6B0096; Sun, 29 Mar 2026 23:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA4F6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:19:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 629C7BAB7F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:19:25 +0000 (UTC)
X-FDA: 84601273890.28.4CCF726
Received: from outbound.pv.icloud.com (pv-2001c-snip4-3.eps.apple.com [57.103.64.106])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D7A08000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:19:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=shkBljfs;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.106 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774840763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwTwDyTZGPftP+zCH5z2TXwgwXL/O8eRHIZbCI56mco=;
	b=YUBKYtBPrSUPG9uasq9eVgGjQcJk9S0nIWnUQXSOiWBngVl8A1Ut52jOEtTXnj6AeqDc5u
	+CfKVlZCcvqfo2JqlOJOf185uFI3jRjJ1OvoY3uQIkhp90iat7cHyJz+d2h0trSmhp4Xbo
	L9Z/vPJKgb+EcHnFei+1NMEc1du5pR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774840763; a=rsa-sha256;
	cv=none;
	b=uZxL50M8NTV8WknOvjhZ1U5a33EmnnBSA39IHGb89PYIpfG8VwCMFLLdXmp2w6/QvXlyVk
	UCPcQrk4pN2K455XxLDf93ERhpB5ALfccHE+KQd3MP/TsU6YZWM5iy/YoCG3MZLCVOWxTh
	D9X2ADXGdx+aldM4kXWHedaugo9Whgs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=shkBljfs;
	spf=pass (imf30.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.106 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-2 (Postfix) with ESMTPS id 3853A180009D;
	Mon, 30 Mar 2026 03:19:18 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774840762; x=1777432762; bh=CwTwDyTZGPftP+zCH5z2TXwgwXL/O8eRHIZbCI56mco=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=shkBljfsIcCrxtMp71wOyRIx9Ihf1z9zm/g+oQOb1aGtwEcIxRNBhG1KE8gibXU3abcMwEjRiUPHM6b74UNZgenMwnRuuwY103zNj8nJPnzCPCotzd/VJzBSB5wD1MjGPaAh8WHpWBCGcihQ8QI6a/AqxaD0GtuqkA/ty+vBBVBTKC5nsLMhzMqf7Vz1KddEGTbCDDHl+VgUTCbVbP9z7SjWCzgNAsOqoUuZBcGBaL3hSq245IoLEIWRO8pTaFL25EnDPmXhvcwKH+sNGdry+naralEp1Ss4OQXb1JD2ROEHpA6RkRQ7oJUOWcyF6FRZJZprKplnMRk/49nRlbn9Hg==
Received: from [192.168.255.10] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-2 (Postfix) with ESMTPSA id DFDE31800110;
	Mon, 30 Mar 2026 03:19:12 +0000 (UTC)
Message-ID: <74129cfb-a7f3-4f28-8242-813166616205@icloud.com>
Date: Mon, 30 Mar 2026 11:19:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: pfalcato@suse.de
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, bruzzhang@tencent.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zhengqi.arch@bytedance.com, zippermonkey@icloud.com
References: <tq5bx3gz2mzqyf3mylay22bcdo2sxt5urvpbblqej4v4sbk3q6@hwjqs4y3ghxf>
Subject: Re: [PATCH v2 5/5] mm/vmscan: flush TLB for every 31 folios evictions
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <tq5bx3gz2mzqyf3mylay22bcdo2sxt5urvpbblqej4v4sbk3q6@hwjqs4y3ghxf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=P7w3RyAu c=1 sm=1 tr=0 ts=69c9ebb8
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RFY0ytw3l_0wuHGi6ugA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=kKg27zqgtulLWh45kPDF:22
X-Proofpoint-ORIG-GUID: BkC8MiQEgdxrJo7wG2hapFUP-bR5btlb
X-Proofpoint-GUID: BkC8MiQEgdxrJo7wG2hapFUP-bR5btlb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDAyNCBTYWx0ZWRfXxHeujqNVHmC2
 Im/8BXqmnZl+AKUn0/VZ0QGwgU52ZsonD9ZWth9+4KR2kpNxP6Z+G64mHasn2zHLoId9N+dUk9i
 mPbV5GjMPX88vQzqi2+qKmdvj5qKhM830rfx82O8eywKscMSoYctUxdXpez2aYwCg6mXMRC/ukU
 3OyofBRXkMFHq68uTJewm934w6OgDpRMOHP4XdFWByKNs8QYdpbTtHCTIgLjqn6s7AvEH3PAWY1
 43hW7SYAdAJfmSytb/I9LaT9BDUSgecEVXC7Wl+QHC9Oy8hXBj08odLbXhS8Aqi3M/5a/s2mrmy
 wDVZYsWQPaEVjCYg1KauXhs93pXFeCaCNPIJ2Mws8xBo8JH6DmC9WKN/ROIIow=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 adultscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603300024
X-Rspamd-Server: rspam12
X-Stat-Signature: kh7sta1iisihepe6cemhdksfpqmtbgii
X-Rspamd-Queue-Id: 6D7A08000B
X-Rspam-User: 
X-HE-Tag: 1774840763-943813
X-HE-Meta: U2FsdGVkX18DfD1OvDdtCPmWFLM8l92KeNDXTNYqTShhuQxlKHIK9Nndr5fP/idAR+Ro5mC84ZE2dwGB9a+1HnW8agXYt7Um4aSHXlTbJBWZS4v41XEV+Sp9rzxqUw5Qf9THN6hhaoe4wzVdbERK9LtjSa0niGQ4QGnmSvX9joZz5BtVJCNXrNjbIlqOo9eqF9iYgZWoW+12PKNaRtD+ZMd9wzkWwFMYbS64vgBNfryq0JEkHe2AN5ziXiD9YneUsABttjk+ziHV0C6lmC34WRi/Ge2o2qdRNAliHdIesF6oM8niIkqcPP48uxfwtbLb2ipw74DJTwg9GJM1tmzD0LNiSW90NrJZ2HfW57TcAb6hC033noPPvYxpRgxrRBIDJsigyH/53oApo4t6swwYLkgErWXWVPlWo+dg8UhqrZ5CK/DwcCx8SNigkRonJ+b5hcggm3WjLD3EIcxtQWKDnjDyQPN2FS043YffUHAxKw/V3/tlnJL4cZm7INH9klgCPej1zwKU9MHd4o/PdFSgO761BBb/c+ExSpmWj+3UbSzzxdYoPKM9d03IeslEWGAPVY6O3dolIWaZXl/zbj85jSRbFTqH2XI5w4OmDgd9IqlZGEvGgmfNCdqRyYYx/Wk0X2D36VruLwyAMKOZ5W4ohKMI9S8Cv1Y7qmi+sl36B4jS+nFjtP4o2JUFXqxGadWO53/Y+ekk5wXXaJTyalGThlQfiTy3lYsD/lidyeVHcmJpdk0Nl57diFV0KxKlW+jEHBymnTUXIIWT4d/cJ2XJm2bl+4y56B+fOaV0C1m3TMEuuF9tJjSKfkBf2bx3c5qmtlC4aJzmHgE9/6ntcqsk5/jOP5eRRT46x1JgFvtMj8s8h+gmKktqKcAmz3aUpIBGBDBZbCY6mDCiERAu7dK6IJeUCrIXXsSC5JO5JiVOKcayl9GVwT+gstd/6VtJuW3csJ1p8X0GtGgLGdYpfaN
 CFf2clto
 /fN8sH8elRVDTPL2hybKD3Xj4sPwcqMR0p25mXSS5A+eFBQTT6i2Xk7erYrqs6HUVvTk72IpGE9GwGJQaaY/OjyZ1y/jeFUkyN3ienLBMZDPmQS0P4XeqpPMNIwvZizsfKfciDXz0K4SaUpknVhwBxC3NC3OAZ4a9R3ss9aIE9bQ5kaFhHL9crDh1MOArjoDyobf0fGjV1UnQMoQNxSk/BuuVUJbQYJ87GwhxlkmyL1ndSz0iqxQ0lI3KP+EphLOO6R552AVQAfxjda/S4chyDHYDyJZXpvUCZRzGoR1bI+1Qh3XH8ttztmDKpHeIT8qC75Muo/5AhQNIIbJgO7U1sgLKdb9h3qn0/RFt3Htly9pxHSAaFTxjCYHgLRJEe8BTyD4MNxa1Ty7ae++Lk5KKViP18c0CNQdBeYq5IdfjPCiLTMAiNKEiggh2sRiHqlIR4qlTcbQQSoCtZXSQfZFcaxJZqIMtwyCMxLc9Rs1NzR+qXWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 12:40:50PM +0000, Pedro Falcato wrote:
 > On Thu, Mar 26, 2026 at 04:36:21PM +0800, Zhang Peng wrote:
 > > +    folio_batch_reinit(fbatch);
 > > +    for (i = 0; i < count; ++i) {
 > > +        folio = fbatch->folios[i];
 > > +        if (!folio_trylock(folio)) {
 > > +            list_add(&folio->lru, ret_folios);
 > > +            continue;
 > > +        }
 > > +
 > > +        if (folio_test_writeback(folio) || folio_test_lru(folio) ||
 >
 > If PG_lru is set here, we're in a world of trouble as we're actively 
using
 > folio->lru. I don't think it's possible for it to be set, as 
isolating folios
 > clears lru, and refcount bump means the folio cannot be reused or 
reinserted
 > back on the LRU. So perhaps:
 >         VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);

Agreed. The folio was isolated from LRU in shrink_folio_list()'s caller
with PG_lru cleared, and we hold a reference throughout. There's no path
that can re-set PG_lru while we hold the folio. Will replace the
folio_test_lru() check with VM_WARN_ON_FOLIO.

 > > +            folio_mapped(folio) || folio_maybe_dma_pinned(folio)) {
 > > +            folio_unlock(folio);
 > > +            list_add(&folio->lru, ret_folios);
 > > +            continue;
 > > +        }
 > > +
 > > +        folio_batch_add(fbatch, folio);
 > > +    }
 > > +
 > > +    i = 0;
 > > +    count = folio_batch_count(fbatch);
 > > +    if (!count)
 > > +        return;
 > > +    /* One TLB flush for the batch */
 > > +    try_to_unmap_flush_dirty();
 > > +    for (i = 0; i < count; ++i) {
 > > +        folio = fbatch->folios[i];
 > > +        pageout_one(folio, ret_folios, free_folios, sc, stat, plug,
 > > +                folio_list);
 >
 > Would be lovely if we could pass the batch down to the swap layer.

Agreed, that would be the logical next step. For now I kept the scope
small to just batch the TLB flush, but submitting swap IO in batches
could further reduce per-folio overhead. Will look into that as a
follow-up.

 > > +    }
 > > +    folio_batch_reinit(fbatch);
 >
 > The way you keep reinitializing fbatch is a bit confusing.
 > Probably worth a comment or two (or kdocs for pageout_batch documenting
 > that the folio batch is reset, etc).

Will add kdocs. The first reinit saves the original folios into local
variables and resets the batch for reuse as a "still-valid" set. The
second reinit cleans up after pageout_one() has consumed them. Will make
this two-phase usage explicit in the documentation.

 > > +            folio_unlock(folio);
 >
 > Why is the folio unlocked? I don't see the need to take the lock trip 
twice.
 > Is there something I'm missing?

We should not hold the folio lock longer than necessary. The folio sits
in flush_folios while the main loop continues scanning the remaining
folios - accumulating a full batch means processing up to 31 more folios
through trylock, unmap, swap allocation etc.

During that window the folio is still in swap cache and findable by
other CPUs. For example, do_swap_page() can look it up via
swap_cache_get_folio() and then block at folio_lock_or_retry() waiting
for us to finish accumulating. That is a direct stall on a process
trying to fault in its own memory.

Unlocking here and relocking in pageout_batch() is the same pattern used
by the demote path a few lines above.


