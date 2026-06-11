Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF1ECD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 08:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD086B008C; Thu, 11 Jun 2026 04:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094926B0092; Thu, 11 Jun 2026 04:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5F96B0096; Thu, 11 Jun 2026 04:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBB456B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:01:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 701E01C20EF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:01:01 +0000 (UTC)
X-FDA: 84866885922.10.C935952
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCA23140004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:00:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUr23X7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgObY0uopxiKfi0MZaI8nGe2B46L7H/AW6iBLbSxpLk=;
	b=cZC0nRHdMU1MFFEe88w//D1rQaUYzTMvQDIt2r7GS1PgqR7iKChRtI9ZvCX4gYejSJeDbu
	EnFGybXUC0jgR+Y0QQ6lU1U1qHfBMPVC1s80xz4xl3yYrPu0LCeuFot58bC8ewXIpa9hmX
	k8naNzjSonGgIAuNyZL9hcIxm8g/0MI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUr23X7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164859;
	b=mqebS/xx9lgfIT9R76Bu3yA8R8t+aotL0OJznpExzadSDvJ7Va+IDF1e3/rT3pIXC42j+y
	7lPjWmJxuF3tLC1K3x3YwBdw1pquotCrjHIfgcEnXVBI34ylzAjkZNqxivuHu4uBfzjfVJ
	VNET47uYCKoJtVJL7r+p5AZXEP9s2po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1BBB4444C;
	Thu, 11 Jun 2026 08:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688601F00893;
	Thu, 11 Jun 2026 08:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781164858;
	bh=tgObY0uopxiKfi0MZaI8nGe2B46L7H/AW6iBLbSxpLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUr23X7PvT0So80MyuDxiJBlv4VRZKIHoQBDfbIiGtLbXYY8sRxVWUOCDhaV6HlN+
	 yQ0jaaXOLOOJ+jdHtdb+VPLpoQdupbswtYgliT9+C/VC7On0IXt44FryJ7YEWONApg
	 fMbJGIgbzwDvMpzCg3ewXe0U+o7ZRRGiKrXHx/dFJY93FgB75WMAIstDgs5+mQdeB3
	 DXh2beeMv7nLL/lbqOSaZNWZzaCZere8wpWbB4/2oPY+3NTyDb5XIqZ8314MZM2Zsw
	 Hgbixm2Cyo3E2dy+zE2E8uMJYcMorrSCFtSAK9NGPrZvadwfx1t+N7uGEzax4/fEwS
	 cojp+HDHhvt2g==
Date: Thu, 11 Jun 2026 10:00:51 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] mm/vma: remove mmap_action->success_hook
Message-ID: <aiprMy4_XyNt2CYO@localhost.localdomain>
References: <cover.1780397980.git.ljs@kernel.org>
 <f79434e6d30af6d92999be6b76e197f1847105fa.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f79434e6d30af6d92999be6b76e197f1847105fa.1780397980.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCA23140004
X-Stat-Signature: abmym7naxunkqgag3irmsjqo1c5faxr7
X-HE-Tag: 1781164859-109538
X-HE-Meta: U2FsdGVkX19go5PWthMreBOPqgqrrwO7u1SyKtO3QhQJigjcOlJBJnmbHsXi/lX4nT8t1u5XdsLlN9oVyqDkw9tGIFpD7eRjqfnv94qSCv3o6No1oM8SGu4LrilOvDmxZyeeXTA2J3RgfmTb5hQGaSAI3A9caWCqNem050RvXgba75R8nrvoD5pXpmOUICkXbVQc98O1O8iPjztD2GA8q8Ga84TYiui+f+o2EmH3pCvSZYAOJr8cVHajtmVucCkPYLYw4YYWGnBvm92P4TWgDZCTq8yADZ55OxEFSD7DqZhuSSwMvb2GADLAz6aIKSn3ZPEjHxFXyyb6LD937vdn6uumQFHpqTOZEJEZ7JZVkPR2RSEuL6RxOWM8Ew6x0rBnVYNQEln9maJ1emNMdBUOe4HaombG9B/20ApWw3qrsxYGeXGzTt6TBDnKfK7ux/VpTHt/rr7oOJIIiwSWJtlzb9+Vk5bEVVsn8LOmx61olojaPv2RlAVQc1+cmkqYLriWVXPrREfMC6uMqJ6y1A4+bowVUdYN3NKSfNxpDxUeoo7m6GJDe4Tvr3y32UASScDkL2mdiRiwiuvfT2WkMz2IN0t2smgweIo5omfD3ZT56nH+8ep4Hka/lZZRJeDZFkcGEYUSSlfpD7xqDN9hCR0X/zVzPZ3QWu6m/kEt/Ux7WaHkv7LabsTGV1TGawVtXR1u3/ecWQ8kse6qn+kgbFlVVp2WQjwZpElpVJ/CiCjcsFDvkRayxIsJT01fGCLBa9nMWl9pWz0+yGbit47svQjDh01NqJPK7BBQy0PfIC+6kdcswtaP1NRv0n0AXGwInWpTZMrLHqAq7475JNvG97bGgNx2wzfglGDVnnIyZtteRdPJQM1SJS3VaC7bZZmbgB4ixj8+ypBTB0c8XlM/XGIus0ensph34Q1B7xBCuxoTNk3Dqvnqn2BZGe00PmUHostGEx1ipaiisKjq2fyu4+t
 dPVmrYRU
 bpDM734cTHAODDI3vfWsQ2lNuFHMHuJqTkZUasAzPUIazBMEyUzTl1bMMJhGGgAmfPAmyEYHyzPye9/EiOYzn7FuaEFL2tv48QrU7bMt1/SyLGa+tbxIy/an2B28pe/EaXcWEHM40/lsZQ44reCAMlxlbY2Vq+7QDwc4ODx75JirRi9G1GqQk5CeQybE/lm2FLNaH7UtqdhajPEneYAJyCwENcFTXTz/xs6HhWzxup2JKM15BUu+S2Qh8o3Wd/hCXsfteUb0pQvf3LwV2hqa/OllX5f/iYmutOimWbscqtrlfe51FmC1sllLvcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:06:26PM +0100, Lorenzo Stoakes wrote:
> This hook was introduced to work around code that seemed to absolutely
> require access to a VMA pointer upon mmap().
> 
> However, providing this hook leaves a backdoor to drivers getting access
> to the very thing mmap_prepare eliminates - a pointer to the VMA.
> 
> Let's solve this contradiction by removing it.  The key intended user was
> hugetlb, however it seems that the best course now is to avoid allowing
> all drivers the ability to work around mmap_prepare, and find a different
> solution there.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reach out if I can be of any help with the hugetlb thing :-)

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

