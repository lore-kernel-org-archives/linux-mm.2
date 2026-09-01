Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF99C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11AD6B00EF; Tue,  1 Sep 2026 05:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE96F6B00F0; Tue,  1 Sep 2026 05:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02B96B00F2; Tue,  1 Sep 2026 05:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADD056B00EF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:01:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BC451C1EA2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:01:33 +0000 (UTC)
X-FDA: 85164600066.28.31FEEE2
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 24A2140003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:01:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GH8879Y8;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+LEIYE5PWt99c9Epwbbxxc+5qMjox+XTmb4JVx+Xew=;
	b=2So5gL4OLOry5klRPJvDQCGDLPcGYdaCsR+nWPqDw3TuvFguvu6i0Nmz6MtEJjRFXIjKDc
	P///qUf74+Zly4QEpdAL4IV4tU0gRwlOph+pDmgQh+dGBqWMJE2mrMNySJYYjvvnJrmZED
	Hxyvr6szjLnTCY61D6z4Ylg4kLGB4ss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253291;
	b=0CaVo1+v0NBc0S54MgE10iP6zFT7xvpfifCuvrG0rk+t3I3v83yeG93+QM8/wcxDj9DsQb
	sKSJfyq5y0yQeCeINwocbKIG0mkcugA8HtFlnc4bR+SnMilynIyVkn246zl/P08eewotaZ
	CCeQqT/2+jK9yi8IBKlNd9sqdAZCpvE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GH8879Y8;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/98Lx4TS3E3kYGDS5L20jZGNtHv6ocMq1GkZIw07U60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788253289; v=1; x=1788858089;
 b=GH8879Y89mbLKycbpRcyCEcukj8kZ9fqMLngEnQ/biKbBhp9o+L+WOkRvDptiiTyz5RVxI7e
 kH9riEgVVlqlNIzxV7nP3GTTFXOoX3Amfprj7MgquCHj6xNZsGJ3tTwhzqMG9DJ4vJpBanUPe3B
 ODR6g00OnoY/uu8ARlIR/asE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce5e7722b69386e3;
	Tue, 01 Sep 2026 09:01:29 +0000
X-Mizu-Trace-ID: ce5e7722b69386e3
X-Migadu-Flow: FLOW_OUT
Message-ID: <017b391d-2687-48f4-938f-b23a5b116690@linux.dev>
Date: Tue, 1 Sep 2026 17:01:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memfd: don't unreserve hugetlb pages on -EEXIST in
 error path
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260831090631.29227-1-hongfu.li@linux.dev>
 <20260831173513.41184f1d27cd83f2c8f9b935@linux-foundation.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20260831173513.41184f1d27cd83f2c8f9b935@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24A2140003
X-Stat-Signature: ycad6de4iirodx15cmrxcwwur1izrid4
X-HE-Tag: 1788253290-906496
X-HE-Meta: U2FsdGVkX18bvREFBMh17hmTRTCBHYOV5EmCxYXwyYHKM04GAVkbFuN/r+2ctcbyAzHqFOzmJRfjxLSkc1hvq6r44MYddmSecZBOFd7Uhmv+NF/llvFJbD+PcseUBrDUjybF2cgAIpq+efaGT7aIc6v5exdtxwSJd6Zvpe8iGTYDFhvlByTuraLXUypa+JWhuIi2orhL9ntVDBN5iA8xDCHrVYdpQr3Kj7e31EVhZo+FHe7q3hcRg/GO0SPaKdrll6Md6OamNV76yNlMpR/8VH10GX2HyrZVrRbKKHUfgnE+Bauzo0JJhuvOe3kIFE+mAO5dcfs7BvPFko0MNurZX2Ctw3RcTPvDNdFJlVrtiUOOOAET3aLslsSk6IRi3wKc31rCYqNUCg9tZV0NGyRrihkdiAI5GOaPeeszaoUsUnQNO0jae7yz8VSmJvvUjUtUHrd/gz3vk2kwFrTLaRuiL3cTiy9Q1M6hal8jQslTGSgUYeA7yTlnUK49zKho0LCB8vKod+nd0ukxQhKP9IlwVSy/xlw9Col8fOvE4FxmeyRM+QUvl2WFl167+VYadr6+tTTGvXf5ZBiXNEsRpQAnzQbS6SlpoZ2oUzn9tJpGkCjYVjIKt+Oj3j9FvV5b3kdqNubVBE7NxW2I/fEmECtsfxGuQ+CsD2X+/S+7DTasK6iiVtN93VQuQO+tFT/hrLlutCTODamFRlPSP0O8AISILNdZdWW8wn72vsW1/LdTMYgJnVy7hOdGh2WfqlGgj4tNtk6k52AXm4fm9s+vaj++n/4ufCMhPv5Brs5yQQECb7G1Miqa34wPwf5Z8ZRWQFDKWGQTwcOqVJ7kBOvGFGQDXYFKWt+XoBNy7IS2+k3d18WSVCqIuF2CGGOcH0RWIgOtYflMYdPxc7dR38+oP1RHMlbOzWxSjgoWL3lKhCvRnLpUIZpmeIHwXxMftoZ4b2+W+Y2INZcjLMic7+zQzpb
 X9mR7OhQ
 DXF9bgxCHOzj6Ob9Jda6CDkUkYvEA6GQRm7S6MGMHqYiLzW8rq5CgaUPdYQB+nvLB5k9TGoJB0A+lR9G1VV3TumpaH5U4ztg4gzuk35YPr/6zJikBo004t/HkD8oLSEnXgSscXPqYixK3MtyRh6I1vZtJpyCy/hxN3QOpqQ61tY/ji9cakTOlFTBwcTPtxeuhxxzAfoII3p8VH++E4KCoyKGKTIiN0z+7uoyv0Z70ymAMoKjuTAETcgqT1FpDG6gfAYZTm6UJVDuGbz+pghgJXG00f00AQINBltrrK4XPNMPWks4AGcA55vF+wJcOW1YS/bcR/5JREy883rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/1/26 8:35 AM, Andrew Morton wrote:
> On Mon, 31 Aug 2026 17:06:31 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> If hugetlb_add_to_page_cache() fails with -EEXIST, a concurrent fault has
>> already instantiated the folio in the page cache, and the reservation now
>> belongs to that folio. Calling hugetlb_unreserve_pages() in that case
>> incorrectly removes the region backing the cached folio, and a later
>> truncate or inode eviction passes a negative (chg - freed) into
>> hugepage_subpool_put_pages(), corrupting subpool and resv_huge_pages
>> accounting.
>>
>> Skip the unreserve on -EEXIST; failures other than -EEXIST leave the
>> reservation unconsumed and still unreserve it.
> Thanks.
>
> AI review might have found another bug and it suggests that your
> proposal only partially fixes this bug:
>
> 	https://sashiko.dev/#/patchset/20260831090631.29227-1-hongfu.li@linux.dev

Thank you for the reminder.

I have carefully gone through the Sashiko review report.
The issue it pointed out is valid. I will address this
remaining problem and send out a v2 patch shortly.

-- 
Best regards,
Hongfu


