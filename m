Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC42C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7361E6B0093; Sun, 28 Jun 2026 12:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DCE6B0096; Sun, 28 Jun 2026 12:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C146B0098; Sun, 28 Jun 2026 12:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5796B0093
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:11:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B83C11C1F49
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:11:45 +0000 (UTC)
X-FDA: 84929812170.19.8F77855
Received: from outbound.ci.icloud.com (ci-2003j-snip4-2.eps.apple.com [57.103.91.223])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA7421C0004
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:11:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HeyiQOSb;
	spf=pass (imf21.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.223 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782663103;
	b=V94Nln1uWO3Zpq8LFX5/SS9GeO1kKD3ebdj1IX/U5w+QOtVhoUgFAsPryJWLPS4FomQsXI
	SJ7FqZM9bwJ0wWTQgV1nhAhTQdLR0KTOA2ue1piIwuf514JpLuvZNNNkhaVTO1FCONGrGV
	T91/vVB6o+TYGQ8nkjUmPDSmifNw/gg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782663103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cma98jfyNJJ+NDh7rTXdRBnQFZGxAUrRnQqNFIayISw=;
	b=ygcPAxCUbVEzZFF1hIP7o+BOVPis3Zqf2B0E3Fvb9ikAkvcYhLEz4hMoIPrfKtS2gvWm6k
	8Os91Itz6Z11jmXHGQJpzG6c7uoSIdSURN+iJ3RJZIJFEby7lavz4383l35VOqrjSa1eUY
	d6WYn+UOGbhFWqDwRu52X6Rs/NecFNA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HeyiQOSb;
	spf=pass (imf21.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.223 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-1 (Postfix) with ESMTPS id 3CE60180018E;
	Sun, 28 Jun 2026 16:11:41 +0000 (UTC)
X-ICL-RepId: 019f0f00-3b0a-78f2-9202-d93478becd28
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsLQwZcBlBcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAVaEhhcFFxQWB5GElYNXQkZCFteUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwdHCEkDDAQIH0haSApAAw0DQxQaBQtWRgtACkkGWFYNABEOTHMEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1782663103; x=1785255103; bh=Cma98jfyNJJ+NDh7rTXdRBnQFZGxAUrRnQqNFIayISw=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=HeyiQOSblPh7u9R+o6RVQEas7dyHOfZ1H7b5HW5u3y+0lTcUuNuuEcqYmdC7ijndyb4ck8IKZYHK7C+QbJytQ6JMraIr2iacXjZZFfkPAewOIcFyNjSRkH/6gbPBVoJmC0S+0hDdrgjKDheAb+ysCvdwrqoVFa0onODfYX1o6XqfSrFGIuv5VaBIB6o/sYWKjyemPijuDTt7FrIJV0HcbXMZkV2yizP2kgiUb86E+4Wcb8/f7rlA0MyGTpmed9gwfaSebbGtebv5uFAlpEHJEi1aJwthKvYrcxPqyiVtw4bEgA5mMTgry9CGqAluK6MfhoMChgoeX5K1bJ9EMcHeAA==
Received: from [192.168.255.10] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-1 (Postfix) with ESMTPSA id C1AF818004C5;
	Sun, 28 Jun 2026 16:11:31 +0000 (UTC)
Message-ID: <57110a3c-8c09-4f13-b6fa-903155af2a74@icloud.com>
Date: Mon, 29 Jun 2026 00:11:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 bruzzhang@tencent.com, hannes@cmpxchg.org, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zippermonkey@icloud.com
References: <0ea1abc4-ff2c-4070-8bfa-67f6892aaca7@kernel.org>
Subject: Re: [PATCH v4 5/5] mm/vmscan: flush TLB for every 31 folios evictions
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <0ea1abc4-ff2c-4070-8bfa-67f6892aaca7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: sf7DZHFsN1vpqzlqxoeyITrRmTYWK-n8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDE0NCBTYWx0ZWRfX2ThNs/SDP+v8
 TXUHqM2ojuyyNy8n+nO5o2teq4BIvXs+0/Rmu+4K4x7MMBtYW2lo6Gdqs2ixkGT93SJmXgzn3KZ
 rzxLP4hfcGfyAiPn7j2MVHfXo/c+7rusf1R4Y2TxR1BN7dQLInHQvxIBhX+rQm9ll3gPQ9xV5vt
 GsWT168Qa1gYAmxykFNgrPDPamOrUb2ySQNoApFOHY7NRs1QeaZ3nLOJxr+8fSzfQwJPZbFOKqM
 bzt/A3SjS1cjktJh5d3hKQoMmIriEegykDyDpHkBUBDin3IZaVPSKiYe6x9A5HZCPqhZ0UCxWXs
 eIecOrlizeVVW/sazN6
X-Proofpoint-GUID: sf7DZHFsN1vpqzlqxoeyITrRmTYWK-n8
X-Rspam-User: 
X-Stat-Signature: 5q3jtajx1cau5eha4m1zywf5e991618k
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA7421C0004
X-HE-Tag: 1782663103-11783
X-HE-Meta: U2FsdGVkX18PUPuCysUQkXZVhbeZCNXnlypNo+ZPzMZHuD2r6Y5TCA0PJJgN8nxYKB7OpwU72aHckDLaTszroZBSIy3+Ci7YWlZI2FtiUEOQjdJlbiohaqSQFbZFwUUsfRd3k9TGdNSK6MF2A4/oedO8t2DXP2aNqKq/PhMqAeu1VFzk2+Ee40gafA8nMyy+Lbtxt8rkmmJx9CY+O1UQhzZk2vDqTPzoAA6wbojB3CghR87HVRkHGI4R98Xeupbt76b7rDVfBuU5WOjWWcXfFNkGJOVRBGrubKY28SdK8/QSY3M44zfaPoYjqVauUp74taskKAZ9kFDvQg6MZtLMsNtdVYQLudqOIfBIgeEGNH1IkMBzRgy25zZ/DlwA/OyuoXFJLGGpG/IjjLgO+UlHJfcCqr6K1iq+AE4bw8dHQTDT/vMsTW/A9fV8yw8/+g4ifl52IehaqKyYPBiM6GItLEF1crhOIHLHhr9wSMulL3e+G5dtFpNFthnb22J8xS6D+mfOnqRh+JObxcxemRz9v5Oa336cGwDY2v/Xkqsz9cFKD2/fW669XMvlouJErPXwnnfI2wSOgMOid2PXj0e0+ieIQxmw4roWMHkL3VEzo+ZVWQmWn1rJS6bPhEno7ecYQxkVjbqcmJMvnnImseCYMbRu6Y2lU4hfFRLyQoaFxqrCUvsno4hmeadyGP4r60IQr99wdVM3gARifoLWJXwHvaruSDWy4lGmtIrk1JHty6HT8mackug3PciavQQ8zwraPVh7ZuAm22M0f8ZVjZuOx/B3kYCUeggDOJKEgpLZUQmde2Wfp8cWau4fd50GQm4F+3QVcr3o0LTsNbjkOGVpZic7VDBJKYST4GhGbBimDHoo2x+0L7DjoP+QBtHQ5sv0W0QFg/q0iZs9KiwO6gRqvnnqqTDZv/CuM4hIGkCK2riOtCHKqzje0NrZvkP57UGrZux122vbMNEV6YXdDfB
 6ldZECWf
 wBc/BiF8zfN7pgk7bdh9GkSHYaY2CdHMbCFDMzezmm9omeNtelVLthW8Ra2CqwF8xV8heFgWyN8c46v3ZxzRjVTBhcWfvrymBhnWs5+bnkoTRzqUWE/Qn6zAyzcnvVT8dkGdoZ+Bih1YKpQ0hZAHNT2QfWCIVnwfI6ICr2UQJCE7aSmz//k6AZfWeDADIizxMq07IYVdmYQQgV2ht/MMSU+QzGBUiLPUkQKKrfaEHx699s+9pFVAsWywQiFQmE7iSpJb0bpsnU55U1GFboEQwb+n3vxP26TAME8aldluTHf+R4bmPxGGLWe6x/8OKlAhKbDrMlhgMXc/na7zSzia/YBb6dDJ/FqpPdIaFeZLLt8/ArV+XydjrGqe6zM0iSlkH6GRdTzu9kEUO8TUgvY7Zel4Kkso62llhpLCEM6SdDfek4BN9+os/wJZjLQiOOnmjJy/k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 02:47:36PM +0200, David Hildenbrand wrote:
 > Two tabs. But this is starting to look a bit messy. Could a helper
 > struct be used to reduce the parameter count to something readable?

Yeah, 7 args is too many.  For v5 I'll bundle the plumbing into a
small struct.

 > That looks rather hacky. You reinit the batch to then traverse the
 > batch? There must be a cleaner way.

It works because reinit only zeros ->nr and ->i, the folios[] array
stays intact — saved count lets you walk it while folio_batch_add()
rebuilds.  But I agree it's too subtle. Maybe I will use a local temp
array insteand.

 > Took me a second to understand why exactly you test for these
 > properties. Can you add a comment how these check here mimic what
 > we checked earlier, before dropping the lock?

Will do.  The three checks correspond to what shrink_folio_list() did
before the unlock: writeback may have started, swapin may have
remapped the folio, a GUP may have pinned it.  Anything that fails
goes back via ret_folios.

 > So, IIUC, what could have happened after dropping the folio lock is
 > that someone would have remapped the folio to user space?
 >
 > Either from the pagecache or from the swap PTE -> swapcache.
 >
 > From there, it could have gotten pinned through the page tables.
 >
 > Is that correct?

Yes, exactly.  A swapin (or a page cache lookup for file-backed)
can find the folio while it's unlocked, remap it into some process's
page tables, and from there a GUP — O_DIRECT, vmsplice, RDMA, etc. —
can pin it.  That's precisely why pageout_batch() rechecks mapped
and dma_pinned before doing the TLB flush and writeout.  Any folio
that got remapped or pinned in the window goes back via ret_folios
instead.

 > What would happen if page migration finds the folio, locks it and
 > wants to migrate it?

Migration can't find it.  The folio is off the LRU (isolated) and
out of page tables (unmapped) — migration's two entry points.
Compaction walks PFNs but skips !PageLRU pages.NUMA hinting faults
walk page tables and won't find a folio with no PTEs.


