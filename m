Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1923BC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 03:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5E86B008C; Sun,  9 Aug 2026 23:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D763C6B0092; Sun,  9 Aug 2026 23:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D896B0093; Sun,  9 Aug 2026 23:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98BDB6B008C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 23:16:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89F8B1404CD
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:16:41 +0000 (UTC)
X-FDA: 85083897402.01.59D8C31
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB6DB40004
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:16:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=aoI+iny3;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786331800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPDbH0uDy9khnXmwsHeDwlaELQ6SwGd2GWPEwSHHQbI=;
	b=jf1Hf9O/mH/CJIsLp/CKGflSvjTrwrDoE56azvbas9xxr/I3PivurQXfG9e8InSYvgj/fP
	ovk56LY83XSauHUTUQPD+miMK90xvmwjR+kDT9L6OukoFiezSdRF6bj/BptVOP7IbS3sex
	P0pQUb+WJ/bRQxUSs5jqn64SN6tJLWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786331800;
	b=oPLnsCxZ0CENhHnbjzGmwdStuqUC9i/tD1BJZPet9QmRm8OGsdhytWKS5xL6HRFTc+ugau
	xbtuJ03ET4+Z7KhQ/UFy81VrU0t5GPJuX80EUPaQgkcyq+PqmNglLVzuULJiHhWpXVq/Q6
	kOVifSuIx8+mZBBUptgoSCaOrMU84Tw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=aoI+iny3;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DPDbH0uDy9khnXmwsHeDwlaELQ6SwGd2GWPEwSHHQbI=; b=aoI+iny3FaGb3bAaDsa0/UBRlL
	O+VeMxmEN3Y7AStBqsGmtlZufMKqDGHw1GDrO+5YH78pdQTtig+r+YyoejMiAWy7hvOVH1GDOOHTZ
	r8dI/ON94AHdZ4wXn8r7ThiGGajXB1aFKLG9C1kIcLQmIHW46tSx09L198TGJ4vvUfTwbOUXH5C7H
	9DZqZTat5WE+QjFhSRd811f47Y1n8lYUtwkVQxd7qGKH5gRJ1Iobfnvty7XbjPAMKycTUikFngCTl
	qNRfVaGaPlFjESwxpsUgqftbLTMrHYLdRTMI+WnwuHRAOiHtoMEVScLG7N4setaYuGr+Hl1n8PvSR
	Hu46WO2g==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtGUx-000000002vh-25s0;
	Sun, 09 Aug 2026 23:16:23 -0400
Message-ID: <705e54c4cd6f49c930208e450cdf488e8e75cc21.camel@surriel.com>
Subject: Re: [RFC PATCH] mm/cma: don't release CMA pages still in use
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett"
	 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Date: Sun, 09 Aug 2026 23:16:23 -0400
In-Reply-To: <20260809210608.06b5ccb9@fangorn>
References: <20260809210608.06b5ccb9@fangorn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB6DB40004
X-Stat-Signature: 77s7wo5mb46cm1pnns1xfg97ztrd4yi8
X-Rspam-User: 
X-HE-Tag: 1786331799-940278
X-HE-Meta: U2FsdGVkX19xuMCCo5M9horBjRfeqks5M7oceJZIzCczZ5lgy1vaiGHwaDqB3PoPif1iypldI1o49qHP4vg//gJyVOpLgEljhvL4R24TU0N7PL0AWm/fbA7wDuAThS2ZRFOtDR3utJ22KNXxjBBjBMXJPAl4/hzsLu2JGi72QvGrPWT5bpMoah4Q5mNEstJwqWPygx0j1ePZve3cLonRBDeHjP0a2QPnfVC0tPzUrVAN8st3rQH0fKLkaj5tt6i/KBEMMCgsyiPBHPG7kRrF4p4+kyU+R7vxz3nhlZQbUjdfaEYF/S4UTgwAQz/jfuYai1Nm8bej9MUDgyNcN/su5PDlfm65wprIjqbeiGa2iiD+bAEq/SOjTQOL0A+U1cxUeBBwdbPFqV7AmfbugUpHo3xc5FiI+YOq+WEoS08E77jVv1HWYbjmmFImrFjeIk6DMtBIkIfZBqjfL//r4OSJ7SMRbbviYaAiJfKVYtDwAOcjGKqEqb/hguFqck+tVjtzZXfTSHvKpNKx4dZD5dCU5KRUEb+PtJ4EO/+J1JdUUJeIZrAGrqvwQK3PAlcL+m7e+qafMbYZEPqXoSqSQqubyluuAPOs/OuB6nkYKRyEoRdlY1y93iUnbiSTwcPk20lIgSJVoLZFrhd4qmrUIHqY8Xuq0W7wTiEKrlh/D+c4lP/U4/GdAgMfnQZoa1N7kWF+rRtG10+v9r9/KF8AgHXlbuOf0rb9QAkqiuuFDhmaqEsui84+tIjta/hqPHgu0AU4ixXylRItXoVwgV/C8IvDTbDel5G7o8Yc9TPxelXwoMacGXwr/xfS1AAk+YBiPGFXGxdZ0exY0Upemq6mzZQhrJ9Nb2cticSNq1A5VkApJckIVXIW67UTdXjyoigeUUZsSAeNoHkL4Bjh1zDaB8Q2XWNKuD5jG/AafiYs776hHpYLK6UAsTezKTIOJ3EB4eApsxV677XW525dptJTdle
 h11RkZln
 tOPLjkOj2tOJ8LarsHi133MSK5AGrHxHHgTswtNBLf65Qk2EEISlNFS1+IrfcezYPEwD+OUX3qNwv6hFBujpsR7TNCf+2tBDaB6cXEuEHGdA/0dG7aLlW+5JfAUpxixi2KT9WfcnR/8D+OzoHqwAPAOpXsU/q/U+S6XobQYH0wIWu5j7+B6hw/7Z/+NJvF6pq8PBkH4fsuIvB3hC/gj6/d7nr/zLVK1c2iE8e1MiyAb/HeoucDI6GAVLJjp1IXn/gRzoJjZxmkGkAss8L/eE/Y/zu6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-08-09 at 21:06 -0400, Rik van Riel wrote:
>=20
> This change should be safe because nothing can get reallocated while
> it
> is still in use.

And of course Sashiko found something I overlooked.

I'll spin a v2 tomorrow.

https://sashiko.dev/#/patchset/20260809210608.06b5ccb9@fangorn

The hugetlb CMA code uses order 9 as the smallest
size that may be returned to the CMA allocator,
which I suppose works because when mTHPs, THPs,
and other movable large folios end up in the hugetlb
CMA area, those do not go through the CMA allocator,
and never touch the bitmap?

That additional bitmap alongside of the pages and
page blocks looks like trouble.

