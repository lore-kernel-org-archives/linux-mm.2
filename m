Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC1DE67A92
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58766B008C; Tue,  3 Mar 2026 03:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10576B0092; Tue,  3 Mar 2026 03:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CE36B0093; Tue,  3 Mar 2026 03:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2A9D6B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:04:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23172B6A78
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:04:50 +0000 (UTC)
X-FDA: 84504015540.24.9819FC3
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C8D84000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:04:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGN2w0xo;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772525088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1olKPwJrw0HPqha0pGqwBcGovlFv0ViSzNeBpR5uKw=;
	b=A/AXAW9BiAKtKO/NULDtXm8kkrxPbCka/ThaOuVunYNvQzIpCS/OuyFuoSo0N8r3fp1eiB
	XG7nIabVjW8J0rpP80+9xXLG3FJiIlalV68msUCb0tjnf1bJtVFGL/brCbu6yBXmdOtUH5
	RbFCQA/jbK3fBaMAcGaX+cW9WFfg0dw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGN2w0xo;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772525088; a=rsa-sha256;
	cv=none;
	b=DbUvghN7wLZPNhC60GzoHQiM6vPS/j6W9KoEqQwxcrdB+65OIryiVmYym771TWcgREmnDd
	XFuvvUR5NizbcSpQHzZrhQgcZjQ+6rUlFmRrd33N7frj1sPupDSprxbMJ+8k7RH7SgCwDg
	THDqVdBi8LYp8RyDxDPpk0H88QzmloA=
Date: Tue, 3 Mar 2026 16:04:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772525083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B1olKPwJrw0HPqha0pGqwBcGovlFv0ViSzNeBpR5uKw=;
	b=qGN2w0xoPIQkHpmB23EbWQhs+9z8HadV+MAkC2eb+04L2gzSqE7RAH3UQHQiRvAIWNXF4A
	1xn0BdO+A9kz+F4sGF6sSP5hL5R7HUMgT/WExEg6Jt+IMZK30mTOQG5VjGnwlPDd2oFQzG
	9JVhfOFi2ZfbZ4q/7ahHWwuRpbgPEoA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: memcontrol: split out __obj_cgroup_charge()
Message-ID: <vcsu7qnouykstvezcmhrqp3spl47nxb4uc6plriena33qrqarf@bitgnusw22cq>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-4-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C8D84000B
X-Rspamd-Server: rspam08
X-Stat-Signature: m8hpk8n97zuuog9fhcbprs49qprtane8
X-HE-Tag: 1772525087-240074
X-HE-Meta: U2FsdGVkX1+XoRolgt6R0YxCky3qQKRiPhi2lH9Fvm7/GQSRoYJKRg2cxCi5+l16eTP/CuUjLG/X6h0n+AF+kyoH95Ve7GtWdMHAxnNvM6hpy3v+6PiMUuwgd4fROW3E2LPvHpbwc6JYrUnHZUWPjrIdTHb0vQ8n3Fzyg1pOxRYGdy9STb4NYzCHjuvJbZUlD4bY2X6eMtFNn9UBlMLmnoWYDg+FVBl489LmE70Je2dqgpE96eImztO2kmiPoGV6vi53El++M9It2yv+HaunyhSaeYNrpPlf7hLYUjooED4x+am82tWCDS3s2CQAUX2cstu600m9nyUx06Tzr1CFpal946ZNhsDEUIn1MIqnn5DzEbFGGhayEC0ybLnLXJ8xvvtPaaANUbMLHoK09lBN2bB9yi/ixyFw1/aljleWdKqs6lHFnGu2dMHYCxRwXKuWlfAoKyt92vWlTltS5NOJYu3DHtAv4EjyEgGSgvr0wVwRXaklTeF64tkKj+OctKPoq0hiD0+1H/8AZOqjzWNSaRjuGt58imT1ZlEXrA3HQxIUmZ/VQlmUl3My2R7TMTk7KVv27oH0GeuHEYQ0wio8VICtj1lN6yXhLUrRFSllZFDFJB5oTjiPIb/+/1CeVaZsn16ebksC4EU4BUNineEAux+zxiHxmlN79VFLk6r1q+ReA/SjvfJoISNoHiAyYuYXA1288BNFMNE4rm87v/D0U3puPFhsOTHT7PmBBpwVCTWwTWsi4fHuHoq8I04fX1QM4pYvmi2dRoQax/PxvHSfS4ztsfyJTYvAGhSel+7Y9tO4aKudUj9SU9Rr7EuvXEl8I/PJGAjEeuGghzIkULtgmVS5SgJdQ29b0mIhmdW+n8aHzs1ZJ3B7rR1Q3tnbc0PwH/sM97xN3UDFoJCBPlRNbMMJu7Qrsa2l7xA8RKpvv8eAPEeu3yXP/yycBUXXDdxxUOGq5TYb65u0mAxctE0
 czLdUUc8
 eCW8ehtSSRh0hZLW2HQhAkkqZx0sQJhXcG6uowKgBLNI1O+l2lmsr/tUBuR5U95gC74JI4rnwFpLng3Fa7kRnOcoWQSNdBTDc4hEL+Ws6IP3ly8VyUn7P7Tp4SQsPp3MWBaH+z1b0rK84Tsk8YJrdVm7p69fMJLXN7wE5okHM9juiGW50stch523Ca2yCu1n2Qw7OME0ksz+nVS5KCNHrj+PGyFvzBs3LX9J1Y2Z8Z/GjIvVb+n2OF2ztPrTLlVX+mjFMBjv6RrV8R+SYY0PUtPVU/pMDLFFOoSXTKxjjjiCzX/SjgX+heDUcqG+3S1cAFJbM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:16PM -0500, Johannes Weiner wrote:
> Move the page charge and remainder calculation into its own
> function. It will make the slab stat refactor easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 

Looks good to me.

Reviewed-by: Hao Li <hao.li@linux.dev>

