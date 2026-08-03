Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A8DC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B246B00B1; Mon,  3 Aug 2026 09:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2E76B00B2; Mon,  3 Aug 2026 09:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FB56B00B3; Mon,  3 Aug 2026 09:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8CF6B00B1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:14:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 922528067A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:55:03 +0000 (UTC)
X-FDA: 85059802086.09.44921B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B73D5140004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:55:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQXmk3Kn;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785758101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFi+EA9EOv5ZOt8q1SqzBGAoG8UY4elQgS2T1OsiJu4=;
	b=jfx89dLLyT2oEso6AmUsC+EsRSk1sR0TUnxsWZGJr1eO86kN2IZ8KiZkISDcH4OvMEq7+9
	IRnlhhrsYaNILZ4A1DTHVjakqxjHzP0Vw1EgLopXlsO8ZV0jHapVzWU1OlSVxDCayjBWhN
	7PoZFbE9cXGPK9ihNSnvWRgYq/GCKDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785758101;
	b=ksMsZu3i9wEoz5WcRNrX8vwZpt3wrEnd0IKrEAthQ3P1IFXzYT1MEYjb0GAiu2+1+QsuY8
	eRwYTx7UsHU2iP1zn9wWGXR3fxF4FLW1mx6/ydT5D6owL+yr1xd0MtQKkSo3jNdsZ69OZd
	7Y8dEOISlTPKfwVJu70tnvnEG88POzE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQXmk3Kn;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DACA41B18;
	Mon,  3 Aug 2026 11:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B81F000E9;
	Mon,  3 Aug 2026 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785758099;
	bh=JFi+EA9EOv5ZOt8q1SqzBGAoG8UY4elQgS2T1OsiJu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cQXmk3Knvg7dM/zcDgDPmpTPAliR8g428C/ZeCCRqCHRD7/0zZaATfRYXIafsOIzJ
	 v8Y1ds4rE7OyDP+Th0j1Q/K9EYDZHAjVOdhQEa8LX8XzqN9eiEy2B3e+1kpLpsKbPy
	 v2SNYPvCk+QvxRGpZKHNRkzhvkXVT+NYNCNPTMmP6JRzDgeErtSD7mgMkrJp3xOxPQ
	 ZpRzfKgTS8Lepastwp3BkcxVPafPBQqFOI3IKvlR7C0HD/ZiSPTKQBhxVy0G6E/Cg9
	 V4v0G3TVy8x8r1wYLm13toU6vqeEMNKwHJPMFl+IejDzzi57fsLc02iUcIgpwaLgJ2
	 BlxjkdChydpVg==
Message-ID: <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
Date: Mon, 3 Aug 2026 13:54:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731164341.1109827-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xy5b5zr4x1e1d4yiagq5kqjq64q68q3f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B73D5140004
X-HE-Tag: 1785758101-335380
X-HE-Meta: U2FsdGVkX1+4pS71OL2yQuWBiuPm6wHo/yPNR6GWPcyOv+yJDLj7X8Zf/u+hfchfMNxM1XEE1SLp4eXd0GiIc4Wpe6vxWfK5pZRzU1UOHPHteznoSmPJ2ISHoMxK4verOq/txs/QnhCtsnU/Drg85p6+vH4R80eLXOPXvxViOPV0RgY1bH0thIkL2eNuYa47zjt25c7Dovt5L9dsrCr+cgMkwMZFCg6nhxyzKkd9Jtg8YNVP1bT/uIjmLdh7YDgJLu1L9ZpLWPNN5yDyVaisHkEhhDZjMZ0a40/W6crq/hUtDCeekdOfZcQVY/TAxEe0BbIByOP3/+cKabLVelROsAei2V0p2/fJ1RGc7oSkBqmHKSl5UlfMrtEUryeNNH3Xwz4l/Zsy/lSmOLy07yUnPk2OxCWn/rF+Ud0dLpNsOkKkSbzTzOPz53uMe7OCsuLc2xnwmgxQ2vhyiv684YdYbzA5rOrQbqk+YAGO79+9QdZT1mCwLvtHRfg1GLHcFDP2dm5mx2gXhtG7m0KrEVXuymgXTXhAqc8hDKAFOoeB1v4GTTXFuXeTiu5iNb43pV+KidBlRRjVwIfGzzTAQyiDUdweX9ncTjhGKfmfGn2rMfsP+mv9mNTYk++HTlrhn9P67SEgr8eqs1E2ciVE/5akoFNOt3NT/2veR+gDJ8/0A+6petz2XwAPESbM9Zu32eIEon0FQVOIMwIVI0SkCtwn8asxabUrvas9KfFpUzaU321rUdU/1GUl7QGXWN5Bue0L9qgQJF2HidOzQpNRpkbGMosIzNhdjAlwBE/naElauMI0NehHCP3ayX5g5nXQ4gocHCdF4v2TOS2pSf8jSulwBj4mkX6XsE9YQVhrmN/8WjF3lVD4MmXu8T3EXW+lL2o8Al1olcaKQlbwnNnkVFjt2a4K294ndGQ8W/4vBX3RRxOZZzoZDiZCXOHF/tPn2XBF7YSDr0Pb7qiKQL3Gfl4
 Vb2V6ujD
 TTui/IS9lyObg0ibHKoCwrVjlx+Hdxbx6mgXUMgqEksJb9r2QIm2xrg5hxcemuTYcZsd8xDT5R6fm0IgFNAFbbstAjEHFpul+mErMsTD/l6FYao06JRmMm4NMGMNN+aJJKmB5cUTTHCShTSlvlgxAwO+woOyKe86JTpsVY31RGAiNt8ufJevwFB5Sisdn4evuTdxidur0OL4QF48aV03GGFhnwqMFEPJBbdZutckn8YEmgzTb5aArbWmI/fnoEUKGxw94229ZQC6wXmLbMApuNvjYvx4Pig4kdT4rMJkQtPM3EXx5jmxqoNfG0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:43, Paolo Bonzini wrote:
> Warning - DRM parts (i.e. most of the patches) untested; I have Cc'd
> the reporter to help with testing these patches.
> 
> Right now, users of .pfn_mkwrite() have no way to create a PTE
> that has gone through maybe_mkwrite().  Because vma_set_page_prot()
> will have cleared the writable PTE bit, users of fixup_user_fault()
> will see a read-only PTE and have no clue that the page needs
> a *second* fault to reach its final status.
> 
> Handling this in fixup_user_fault() is problematic: the information
> about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
> which is an opaque pgprot_t, therefore only follow_pfnmap_start()
> knows how to retrieve it.

How is mprotect() supposed to work in that case?

-- 
Cheers,

David

