Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31468CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619766B008C; Thu, 28 May 2026 10:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9FB6B0092; Thu, 28 May 2026 10:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF556B0093; Thu, 28 May 2026 10:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9C76B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:14:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0F4E120848
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:14:11 +0000 (UTC)
X-FDA: 84817023102.03.F66FD8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C915100016
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:14:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwXIR2ne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779977650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekle48cxY3BXDJBVeyxwCTDse2Cq0o5JDJn8AmmX8a4=;
	b=FR/Wh8EOm/sK2ChBE1sh3xQfsP61JgxVuWM9XzDrcxocotx4FfL3is6CSeahzb4eeMUb8M
	mXktYlrPZqqmyxxjQWMGaR4WkNkQ0h/FF0xDLgvdPdbAMyHgk8XWWOnEnnMAOZCHdjQqZr
	p23DY7q5CzPRWvMxeCcU8f2Ql9HK7O0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UwXIR2ne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779977650; a=rsa-sha256;
	cv=none;
	b=vJcnAN1wyMV3g4gnxskWF4ifUSOzuG2vtfRqm7eZCWKiIx6sgeWX+v4BHHMPyVh1Hiziyn
	YDF4yzW25vzKGuh4g5R6tCwmHHqh/XJWC+NAI3yY7B3FUVlO9DlEhzuSnTIUyaSXZuuT59
	gwLeF66SSxVmhO8GKcLWzr1nWRhYHoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BC2443F8;
	Thu, 28 May 2026 14:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AB51F000E9;
	Thu, 28 May 2026 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779977649;
	bh=ekle48cxY3BXDJBVeyxwCTDse2Cq0o5JDJn8AmmX8a4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UwXIR2ne7qIEdQieKjg2fk0ArW6TCOdBh6pDCicZUiTQMTn8zUfuwKpyzz79+ZAOc
	 J5LNaa8pycGGpXjpb8vmu9SrBxYpeJVvQwETKbMlVpou2QDvaG0pr+52oOBCA3Uj1q
	 aIBysXOesDEjZp/tW2gzNZtRskQpwGH/pcvII8QIOwcRLKo8BaXtvod3NtgOwEtNhf
	 YoD7cKL98m7iqwH1GgvEE40WcgNZKFFY+azFmtztq27kw0BKnop75mmhEtMoJOz1s6
	 YxDUIacv9uC2uD0qaU3PIPNQdB8pQNn9XiDnmgKhhhUrteIEnctGScyokHsN/HkZ+3
	 AhqvdH+EN9bBQ==
Date: Thu, 28 May 2026 16:14:03 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <ahhNq0pFKvSKZQbR@localhost.localdomain>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
 <ahglqif-I4TjFK9X@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahglqif-I4TjFK9X@lucifer>
X-Stat-Signature: sf14ai3rk4d7j5z45ms6chpz1rbdsi46
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C915100016
X-Rspam-User: 
X-HE-Tag: 1779977649-202249
X-HE-Meta: U2FsdGVkX1/uLEqULryV4P3j0M4Qd4EyVF3RDKXVg5Erh/XZUytqZtzKGhMW9T/xm7Q/5vycHCf7TrJhkn11HwG71YgnV2nv28ZqPTJQFFkgNp/M3bm/fNPxd13BPBAikoJLWIjIAcCk9JvhN2n5T5MhiYI6IQ+t3byxRZIIXxUp7Gqa0bibTd4z2If2maAC3Doh8wNSX685FrdlLjDDEoPUoehDZVdZ3XykBWoI+TqYrY7awJGTHX0v08967W4Ep5CsSgERJj2+WLQnd+3Qz1I5fMv5nNLHmPwe0wLtVqi+8kQsZsnQz4LIYf8cFjJpN1AVYwBqatQfDI2ci/a/932qqaJkQxlcUsiipCiGANdTH49mbwz08M9L22av/o/zxzU1DI/liib8+7hlEpcAl+tVjOE3/m0B3RXU6onMDm0I/DHpAmMoIyCo5Z2oLY+G6Jdfq7gR4STBYMU3fniLUcuEiXsN+PCiZuwpw3BBsoFpx2HofVHn5RCXfEsmvC+Vwjslyz97vVuaHmCp+RXvI2+X7Y9gpbTfvX5nWhnyXJH0sShgT7MkMLY8HD0ixsxdKsNKxwvoP49aLf46bI/1pqZQWT18v4Lc/6vuIdZH59ht3lfKyxXVwXHnX4tA7nkBbk3iiKpeuIpw/eR5UCltl7s3XSmGuIU94L0kAs9IpmSvh21XCle9q83rx783mED/7End7eZ1SImmK/xfbtF6QQBzYwCNVbopvFKn6Xxjk9xjpHc79OlWcqAC8eLyAoK8u3zE4pnBeCYmEosoRuq9GbNIRDPEchmjSnE42zlEgWh7D70L8/fVx9t/wDE5TiaHL7TzMZ+XZrgKJgmCpBWUzsVKLpvTEANsoWFYRukcSXE8XLdSVhPb3tgrkTsrW8g2yNOsO4eGYTNoiEsTUQqZXWbcBvkrJp1fOOkwfzfPOiXdFdhpQtXyuOxWEkY7fUP0tfPk9kckMaJml6WGc4i
 S8v9R8P6
 kq78Iy7MJl0M5/Ymb+IbHrCkPiIwhdRw2G1qVu6WpLJ0AWLUUa855jC/cPMPOh/qUutGsXOdFRFEVewyp2xJZwyPhZF/IHdBjDGiTAg+YkKX2vXhhSfn1PslabH/jK4Mx32tp0IqiGeUPuIpP9ZYCobzYafl13R+SCgYRfGy6bYBIP8UBnPWmBJspr0oo83UlR2fNCtFpFQs8nFdieaHzUlBhP53jBes5Lxqk4qtf0K5f8bcTBUo/dTK29pjG/EIcKZ6MozbWTHAJONNYTjlCTy4oM8HzJhXN9mwF21VZ11gg/ntUMpp2VR8QeyzYsLsBd2SjzCJkkiI+dvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 12:24:35PM +0100, Lorenzo Stoakes wrote:
> On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
> > Switch from ptep_get() to ptep_get_lockless() accessor for
> > PTE reads when no lock is taken.
> 
> This is an insufficient commit message that's just saying what you're doing,
> which isn't very useful.
> 
> Please explain why you're doing this and what the benefit is please.

Maybe something like

"When not holding the lock, there is a chance that the pte gets modified
 under our feet, so we need to use the lockless API to make sure that
 the entries remain consistent during the read."

Only arm64 makes use of it though, due to the contpte stuff and being
unable to do it atomically.



-- 
Oscar Salvador
SUSE Labs

