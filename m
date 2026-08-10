Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCAAC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43066B007B; Mon, 10 Aug 2026 10:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19F96B008A; Mon, 10 Aug 2026 10:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C526B008C; Mon, 10 Aug 2026 10:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4D76B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:01:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D98DAC0188
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:01:45 +0000 (UTC)
X-FDA: 85085522970.09.A30E6AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 39E0240016
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:01:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fv8tCIz6;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786370504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShdhYTN7VXanrMxGBiRoKkMNiBC1EYaMKFKCBl48mZA=;
	b=Orfn/vfYAvOs7zwlrnIOfdKGO2mWcKg9Q1n+v3HnLWWiNmWSIPy1cEpxyIadrT06lLC6XG
	HbyR2ikYcgVDuJ1AIpNmRxR5KIQaRwFx70U1b8p8qODe66v6Y6W10YmLB8pMyVsQj4HNUU
	lyHM3WW2u7/QNZtlDLxmQfRzhTSvfR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786370504;
	b=ROcg9Wb3ds/ObaSyfzexOkAuCIwHk31SKvb36+XCvLd8HdOOsAfyMkFBicVkWQ7H9QpiYw
	mm9UevL57VVgvr88Ibwp8ZkecHguSFdXhtzGhRa8DC1ZhIOSiUkIX0yV3tSr2oT/NJ1ets
	WOQf1YiVU5oe3HHnglRFwZ1Vcu6t20s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fv8tCIz6;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 619F74047E;
	Mon, 10 Aug 2026 14:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359A41F000E9;
	Mon, 10 Aug 2026 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786370503;
	bh=ShdhYTN7VXanrMxGBiRoKkMNiBC1EYaMKFKCBl48mZA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fv8tCIz6OJ4rivSB8rzYXOymT6D5z8HgevUrzUBgndP114hVoydAIJZ5RiEUQclC5
	 CY/cpoNqYkeImQhm9rV+YKck4OP4+bBqvvZslb666+gYFAKLV0avGdI07hXNFBjPpS
	 T6rqzTqPQ2Xb2v5ojYrrVaEqr1ANgiKwfwZT2kxoUIrJuVsjxiVd5OF088IeYXsvR0
	 l63W9Jqfo6OTSyt6eeJ6E3iXbUZXChNoesClU/DlCqQnyRnnP62/QNpDgRARzk71VD
	 An9kUiw3IwQE5U1JO3Y9+byaVDjG2kHCGF8p0bWVTQsh0oRT+n4abIBXx6SIAmZkb/
	 VDklH4q5w70Zw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Baoquan He <baoquan.he@linux.dev>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Miaohe Lin <linmiaohe@huawei.com>,  Naoya Horiguchi
 <nao.horiguchi@gmail.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  rmikey@meta.com,  riel@surriel.com,  kernel-team@meta.com,  Kiryl
 Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned pages
In-Reply-To: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org> (Breno
	Leitao's message of "Mon, 10 Aug 2026 06:32:04 -0700")
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
Date: Mon, 10 Aug 2026 16:01:38 +0200
Message-ID: <2vxz7bly6pml.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39E0240016
X-Stat-Signature: rti771pkz7xgxtzjet4mpd41szsg3rik
X-Rspam-User: 
X-HE-Tag: 1786370504-176332
X-HE-Meta: U2FsdGVkX1+HArjQ6fKOUMdd+/MRxysAk/OmD3e979sDOVH0txgZKvTM+NluTNxSCaIVjI1notbYEmh96kJhml7LnmHnI62WtgApH5aCZT2SO5YnE+lra7o2DEx+ECIXet5TO3eui894fI2NE7pNTnWD7EfbnXZXvTwUzcX2xpPLSig18MhyMSSELVH5CF5MvAProifeFSiaVEMyfEYnZT8lmLPxWRDXVq2BPwP+xP787mOr9UoCuFm3kY3+WUoWWfdILHY4t6jBJ8MivAP0PMy79xaTb6zRHLyj60fYIjdAq7Pk+Ov1QF71UBKrMxxx2Daw8BbRDn0mWf+vmctAzG0t3/rpq5Y47VpbVWY/oZhLWkUuy/lRKYtuik/h5g/6ynCB1Dae/TM67PQAslH7jftYvrCEvdO806sZbbOvd6JwMdX4nIsYkH8WEMOVIYV0xdCI9ToCrlqiSBUPpMf7BzGp/hSryXw+2bgdt+65e3GhskiKzt2VX5quU1Ltk9bF6W+0UOUnXhqHrhlIZejIGXHUEsaCIZJwpFZVOEFLv6iPBBBlJXfU2gkzfYxTmVjTT7BZYOvlt96vRTHhypG1KaNbZggK/jg5Kr9dOl8MWg6YiPolrYK7Zz5jXgHMqmubY55LJf6VI5sQf/KFOJoQYVHZAX8bqB1CKGmCOl4UQDjQEET+g8w1TgldNK3pQeGwgYKniJZQRv24VfwBDu76bNHw2hwStfgFrWITyS5ZDIAP3/A9MveJwY/x2d3RmzRYL6l3PN4cEvxX7250Z1r/0vfQuCWxQX7FITuJJS21k7xKkzO4GW6+w9IMTThAQT4vfM6MKoj1RNJg+PB48R4FpOTu9OtAIcvI83y36Sy3wc9KTgf+2eBX9H/nNGaxL0N97zNpyO0foVBF0b68V/M7i4aF//3OfDc+vZB5nS4zvy/EkIr1qnUadfv5m5f757zGF10i+VNqfUs8UymfjRV
 VXVFgvJx
 ZxTMb5BK58zbwois2ZwFTMchBAzB+4ykIpJb0v//ixO+cH3zAzQ/ezWNDhIpaKp2l0kbRqAntF2DTHs1oSW3n3AWgDkP9t3ozzSDJHWuPVggsWiz/YbVrKQGZV0xjwMXvA5HvByYRlyd08nZI9WOrm+h+oiAChzQoRwigjQUpVa90JqXQoDgpxHMoQLD+uO6SG2AsQsbk4JAqmP5g95ueBh6iPz/SX9GE75mvhQdPZgQvy9WYaQreulNO8K8kk1lSbTyTkzJbW4tbBbisoRjm4IRzPR7UCaROo2t9T/pXspvsywYe9jW1z+S+eCsAvfTymrkKe0qo/qrzOv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10 2026, Breno Leitao wrote:

> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
>
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
>
> If the next kernel's image, initrd or purgatory lands on poisoned frame,
> the relocation copy writes to the bad memory and the machine checks
> during the kexec.
>
> Skip hardware-poisoned frames when placing segments: check them in the
> kexec_file hole finder so it lays the next kernel down on good memory,
> and reject a poisoned destination in sanity_check_segment_list() for
> the kexec_load path, which cannot relocate.
>
> The two hole finders walk in opposite directions, so each asks for the
> end of the poison it has to clear: the top-down walk for the first
> poisoned page in the window, the bottom-up walk for the last. A poisoned
> hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
> the poisoned subpages on its raw hwpoison list.
>
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

