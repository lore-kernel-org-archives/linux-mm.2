Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71555C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFC36B00B4; Mon, 27 Jul 2026 06:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1936B00B5; Mon, 27 Jul 2026 06:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192B86B00B6; Mon, 27 Jul 2026 06:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E12576B00B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:54:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48DBE1206BE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:54:28 +0000 (UTC)
X-FDA: 85034247816.20.2873B55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AEAA1100002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:54:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCoB5Urq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785149666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uF4vHPdSBdfo7lQhDfOgMHZhCy1lSFDq/I/z2A8IyXo=;
	b=MI8172QiQRFihfznEQ8o10q/O0smgwZMnVyqfieqsUdpXmwAhSjXkUrQL4q2x3T/jLN8jn
	nGSwwEU2NH3esKam9T1Yp0bO1PEYmaXOyieOdjY7WHXQPz1DrGZ+a7rdUZmnjylhu1LWq+
	I3lO6lP4M2PhHlTr+nKiwlHLIq/QjEc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCoB5Urq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785149666;
	b=8f9H1OMpchG+a+Qy1BIz170R1NohYTgXIPSOQARcmm6ZU+eMfea6ku40xSWuPo4Vksky0w
	R4x8IPB6B1D8HhcEPB+muE2Hpz18ZMphYvHkKuvCdGIoRHSpkDkqB9pt7CPkeQw4XWzGRG
	t4slkf3wbr9IKYR1zOsoMUFk0m0g1hU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6F46436BD;
	Mon, 27 Jul 2026 10:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CC01F000E9;
	Mon, 27 Jul 2026 10:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785149665;
	bh=uF4vHPdSBdfo7lQhDfOgMHZhCy1lSFDq/I/z2A8IyXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GCoB5UrqSCFvUjKRygvutVMZhQhF9SV7CavFKIHlTE4iWj/ZSlruoQ7Mn9UBMUUM6
	 H/hC22g5iRyL/t7Pyhavb3b5sVkfID+08xwdx/At6uoz5JNVDC+Ol7SZh6/Elh2x+1
	 1KZ6vpySu1VWtIFlcyer0DyS+D+fcvk9bOe0J/5ck1fVPb/d2bcaGMrWLCslLobGnS
	 O9ndtlEeOoNmrUIHTFZWmrcj4iCWLFsiLsEi/OxXd7HUhqW7S+R3MfWS4ABsyD4OEk
	 oDuSFozpt7c9Qfm1j2FFxKAFOo9uczFSRsyJGfISBiSRm6oKSOw6jrDGJ1GPK0jUQ5
	 EBNZCnZA+ZCVA==
Date: Mon, 27 Jul 2026 11:54:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Liu Song <liusong@linux.alibaba.com>, Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
Message-ID: <amc4ZPJRqiKRaupd@lucifer>
References: <20260716173504.760369-1-noren@nvidia.com>
 <alopMtyPYdn7vDoC@lucifer>
 <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
 <f6316415-4918-4484-a241-0254efb4aa17@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6316415-4918-4484-a241-0254efb4aa17@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEAA1100002
X-Rspam-User: 
X-Stat-Signature: 191wsqyeygf1gjqwqub374q9rdh8s35p
X-HE-Tag: 1785149666-781957
X-HE-Meta: U2FsdGVkX18/vV2NSOAe6Sdq6ogfo18XAtD3n7VprSlC6ikkXXmd+rVcv7F5lo7kP17OimdYG7EMmaboV/hby9FY2qPu3UiZ5VVRGSFOYK+HhSBMtE7FPBLwFkZAWLx+3SLdSp//Svy6DQ02xMicFQ3vo1+L7hxqb+z4DEv5FAeBWIihtCcVuEkPM+bnZB3VJdtRE0GXIiWcvX+n9iyP5N44vpGOglevzycE6RnBaarnymezb8vguXnGmIZCwvr16OWIhCwA4kdG/7rKpalHdsq2anqXUGpEWmORmP4tuPp2kEPwe134C9Px7XOXkci3hSdRa58wxEcVGR4JFHoA3mivIg9Jcy9iCPcNL3MmIRJtH5L6rMaNI7L9bWAQcJeb0vN+mPVcp/+n2omG0GWeICRJag+JC8wHKZMEriQs03CBv2WAJnr6Yz8O6XJ2xoj24KoQWO5gyCQXkyZ9slqk8Nzn3fvDnCB5KIJ48ELH6Ey+vvxAXJBhgJcxL5n/djc/pyVDECz6LFQMKxWHb4/+jRE/gaMijG1LtCxUG8UmdCUE/fB0PjGBpms3vMMYEwIn/PJjxti9q3RsvKbZ+To3x/3ePdYctRlFliGDgwOs9oFfuY50jcuVkz2rs3T8Wk/0Q0itRAa4v6lBh2P/dBNRv0bpU72IG0CPUu6j0t9hnWSkdfkIlko/dFuVG9k1NkgysvJupVCq4abNH4U0G3t9Xn6aZpwxdCOixU/xpTqXUaOKekCwPuRvVuHlB2av2D7SCj1jKsz4cZhNqdkV0Ou2e5Zb27FXNVy52x7pGFU6DW3ZQdPRLFYvpVtpvbuGLb/x6Z+hoyUENBLlVA821mP2o6oqpEKYxgPiIMiE7IXPiTdchMV16M+pNdS3Pu5z1Y5ehGtvVbbQs/6HcHS+nm/w2Mt2VyNm7arKzjQRCcG0aYIHVGgfSsJVE73BjyACOWOp/47b03CJBztUWHwtO6f
 JKPnkrHM
 VZKhy1uBvJibNNgNeCdFKtOZnP25Ozj0le9Iz/mSvn71N4UZlEmPIGZlbfmyabZZGdSfz2IRsC7fY5Q2g/H2meuVa4pKjNowg2+Bj+WNtuP/WirlysKINOj5YNf46Ov+ROgDkSHC4/yOqcLomT5uIYyuHwntrDwF6/CugEQt0cYPjqmHu4uMDHYFwOtdt3WclljBnqd9AZ2FqcQ/qGlZYXVt5c5cwB84zSpUd7YAalDoTygMYIMHoGcYFt86eJZQGHIevbVZQsWIxgwIkbAW7z60vzq/GuGkc1lg471I0I9uLqYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 10:28:21AM +0300, Nimrod Oren wrote:
> On 17/07/2026 17:58, Zi Yan wrote:
> > On 17 Jul 2026, at 9:36, Lorenzo Stoakes (ARM) wrote:
> >> Maybe a simpler version would be to just attack the issue we actually have
> >> with it - it uses too much damn memory :)
> >>
> >> So maybe something like the attached? (you'd probably want to make this a
> >> sysctl or at least a defined value of course)
> >
> > The approach below makes sense to me. In terms of the actual cap size,
> > I asked Codex to check what possible pageblock_size and their reserved
> > sizes:
> >
> > 1. 1MB pageblock size (s390) and 11MB per zone,
> > 2. 2MB pageblock size and 22MB per zone,
> > 3. 8MB pageblock size and 88MB per zone,
> > 4. 16MB pageblock size and 176MB per zone,
> > 5. 32MB pageblock size and 352MB per zone,
> > 6. 128MB pageblock size and 1.375GB per zone,
> > 7. 512MB pageblock size and 5.5GB per zone.
> >
> > 1GB makes sense to me. 512MB might also work.
> >
>
> Assuming three eligible zones, my original proposal would have been
> equivalent to a much lower cap of 66MB:
>
>   2MB * 11 pageblocks per zone * 3 zones = 66MB
>
> Using a more conservative value also sounds reasonable to me.
>
> >> General idea is - if we're going to cap, let's just cap instead of
> >> pretending that page blocks are of a different size.
> >>
> >
> > Sounds good to me. Thank you for the suggestion.
> >
> Thanks Lorenzo and Zi for the review.
> Capping the final recommendation directly sounds good to me.

OK, feel free to respin with that! A Suggested-by is fine for me.

>
>

Cheers, Lorenzo

