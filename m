Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15AC4C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E7F6B007B; Mon, 27 Jul 2026 18:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A216B0088; Mon, 27 Jul 2026 18:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30216B008A; Mon, 27 Jul 2026 18:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7B206B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:43:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43799A0218
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:43:34 +0000 (UTC)
X-FDA: 85036034748.09.6144461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83E2C40006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:43:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cgbeVCLT;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785192212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3noW5ZYUlE/zDzyfrBegKr4xtPlTc1PQVGAQCuLqpQ=;
	b=HMnJA6cCnx094H6oKot/hyE/mpTPNueMvdPK404AJSkcFekLcbZEF3kJSqrAu1Ljgmr7lS
	w8W7Yj2FXV5PaE5CHEY04VMIvdBzdKxi40CWOcPVM8Vg8UOUCxyz55r0hjpCt19aF2HFDX
	gvmogRWyYlAZOx38ghyFxzbU8vRBKg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785192212;
	b=THEQcjVPWDIj8NjlKdW9J2u1XChvv25Zgy1bAlhqPzq7D8rIygOS9rT/VoTafjHbBKaUXI
	jFgyStkdWmFw+fe2b70oI4Es6/4y4taNEbRR5unl2ioEgq/wMFfPOx2NJivzwPOrn/IROp
	6arAu9UYRm76rmOeMNETti7PbBgSyEI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cgbeVCLT;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D8A5600FC;
	Mon, 27 Jul 2026 22:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD00C1F000E9;
	Mon, 27 Jul 2026 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785192211;
	bh=Y3noW5ZYUlE/zDzyfrBegKr4xtPlTc1PQVGAQCuLqpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cgbeVCLTSq+7AMno+cyMEI4Wwt72sfI+qGJWUytMOyTKAJSGiGS6VsE8uwInfWs7K
	 ebfFb5OZhctkcRpg3BpCU8yIW8Hmc/qxevBQT8ZPpcyCHqfLK7pNYcpohZAO2uyME4
	 EV/YOrsSRbZqbsC1Se0YNbxhrbzPFrSRxUsckY/I=
Date: Mon, 27 Jul 2026 15:43:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yadav, Arvind" <arvind.yadav@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <david@kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>,
 <rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
 <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>
Subject: Re: [PATCH v3] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Message-Id: <20260727154330.cbe743a0a9518ccfe2437aac@linux-foundation.org>
In-Reply-To: <439924d5-b51a-40f7-bd96-42fa43eef0e0@intel.com>
References: <20260727053920.3494211-1-arvind.yadav@intel.com>
	<0ea36640-36bc-47a9-8d57-edc886e13aeb@nvidia.com>
	<439924d5-b51a-40f7-bd96-42fa43eef0e0@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 83E2C40006
X-Stat-Signature: deogaez1w6nn3mos3ajs4cmxd57kz4gi
X-Rspam-User: 
X-HE-Tag: 1785192212-735697
X-HE-Meta: U2FsdGVkX18D21HUeYT7lNGdRnKw9CKfdkwD6TAK8ANU85fRHL7DNsPPMnFYuPEPj4zWsTGYEZf+pbSyBCJm2XLeTDm/StDuZCZHGX6rG9zNRvpYFuZzQjWgrOKnQNROrL0zb0Fq0J9ekTTRyFJ6/eEwjeDBudbc5Pxi121ZoXocOyZn4vmq8UCSDrVwMtGoOJzRSFytH76ebadQeLlfX1HhdJYr+U0b69Bikxgv2SiotRFim/17Lk1DUnOPhzuJSNOClMJRYjPbETVHptRLtnkHRbixbb5/z7gOCDAOfmAgmOgOwyj+6LIZ4YNPNmhTzrESEaG2y2kDvPPWqAKeFmhmE1ZdJkH6Qz+c+ML2Y9eEwe6AmlARV00imMbmqIv44GQrrPp7a+64M4Wtc1yx64PHanOkt2zHXTPuPjzmacvRMw84qFnTHkMcGv7xJA+NWHuXEC4tMq0cjIipDM3rjimqrSfMP3JvwgEngHbduEc1y6iNLJz7LA61DwDNPXI/6LxESij4jRwleaGQp+iozWivWwCyY/UugQUXVwZ3i/YEH0T8HrDmtroFSwiF+PR2CrLmeo6qKnjN4ol+dNj1Re7b5T2OnDbJ9QsWwP5hnb1fvnzMAVLohTjTOhcGWGXqguTrGFQNBbz8AFn+WrM3rTI0Qq83QqeaSkqDUXuqdzdlJmRs9CMfWN5jYB44rjRYXK0KhQIluhsWMkxX+/Aw3sYRi22v0OdOBsV0AdCefX4zNg8HwQP6irDTcrDmLAU0YF0PW3UdE7RdlX2tUz4iUI3hO9YgdIMxvcHlvBA2lE0bOg+kG6fnHLhL6HpSfUrGSeMathiZnTkCLn3bCM/bFrSoE0qCppYKSoAJZjTpoYSove2Cy2a5zZbYXlg4QAWqv2TRLudNv1LPMuLJsYISoiK/FV4U/LAXTZjfui4ym7JFET0CQ8pNTkgna1Rr1keIt3glsmDpg17qUkzxrux
 QBNAaxdL
 n0XSoKg305sEW1ZwGb1dUyoFesSuZgNWE4T8qd25igemmCmQ9qVmGMLaWtu+bg5SETZquox1CWU1qk48nY0v289G/C+jIxx0OCy8LEyipxp/3m7fT5QZjJUb8qURf6K1F9NKUHboZ1i/1WgdvjbFCsf8YDmfw8AdO54edYzMWi5z+w8yXr0gIilj9JGg4eiYl5PDxFzt52aW5gEktdB3EFRIVRH7B8XN3R8ihP8klRn3iz2RYo+IZ5DFX2ByuQgBrR5F82a3B/yATXLCJTwkcScE+XwCfSCUARxmTAWxcSa9dBFVtOdWQCeHzF5cL3w5CLX9qRm7w8+31DTXZenY7BP6fGHEks/xLaVXkPFeiAPtcFeLx1aOnBfVCUK+CG8jgphRnenrIS1XuQI6AR1lJJwPhYD+k2Oo9Fd1PiN3QoUNmz0YwNmwwkBWg4/xv9hXKhu/XIH7rZJqTff10RG1QMrhtF5wBh78jzT2R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 16:28:42 +0530 "Yadav, Arvind" <arvind.yadav@intel.com> wrote:

> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -1182,6 +1182,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
> >>   							 MIGRATE_PFN_COMPOUND);
> >>   					goto next;
> >>   				}
> >> +				/*
> >> +				 * reset nr so that only first after-split folio
> >> +				 * is processed below
> >> +				 */
> >> +				nr = 1;
> > We should also add a VM_WARN_ON_ONCE(folio_test_swapcache(folio))
> 
> 
> Agreed , but folio_test_swapcache()  is not valid immediately after the 
> split, as the order-0 folios may still be in swapcache.
> I’ll use just before nr = 1

AI review suggest there might be another bug in here:
	https://sashiko.dev/#/patchset/20260727053920.3494211-1-arvind.yadav@intel.com

