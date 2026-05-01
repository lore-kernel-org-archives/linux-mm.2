Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113CBFF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511886B0088; Thu, 30 Apr 2026 20:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2526B008A; Thu, 30 Apr 2026 20:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D89A6B008C; Thu, 30 Apr 2026 20:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB206B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:53:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3240E140542
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:53:17 +0000 (UTC)
X-FDA: 84717027234.01.0A52837
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D9AA1C000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:53:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fKJV6/QH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777596795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J009uALaMNGkc1EoBMX1tkYlbX2OyU5ubo2x3SyVJy4=;
	b=oh1EhBNxG5vTH/2eVkdOyQdRGA4bTNFtSuFut24MCiKfh1WTLVJlGyzSLc/Pgf9vWI24l5
	/9m3Svh/oc3lvP0cbWtF4VLAU+iNwAa004Bmq0z43Zq9AFctPYWvg/RnnnHlLzTEnoOYvb
	A1pS8arrn4mqVEkxUF/X7wB0wabRL8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777596795; a=rsa-sha256;
	cv=none;
	b=Z9qDfvPXdMg0blYpJInOoyU8/04z/Y2MH7pONDYgFKhKzGoxUtS76+bBQk9dfm9uuCEI54
	bH6f+CWAebJeFd412U0dDEsHqj9uZbL5MajHqlwB+TDRpUv9SF9sYAqk4YR+U1Wjshyp/t
	04x0jMs/9bHlW8P5d5Xxa8XJi4zrAX0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fKJV6/QH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F81444208;
	Fri,  1 May 2026 00:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87313C2BCB3;
	Fri,  1 May 2026 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596794;
	bh=J009uALaMNGkc1EoBMX1tkYlbX2OyU5ubo2x3SyVJy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKJV6/QHp5wIkyq9r2SYDCUkNMNoQdp0lsKcg+1qtaa4iTq1f9hcPO3KLv1tGhPkV
	 7J2B3CoRFsTQw1WlGQZs57me7tCzlJT+BTWtOsXmYU6jisFE3n6RZKmxP57jHwVQFi
	 hYC9Raa89LvSa+vnYQCJkclbYhe1YTSM3YM6bmUNEymeHtcub52lW9zMVAsC4I1uFZ
	 HP1j8IUuBJAT7bv4wTdI9pXeK4B4fNWbSA90N6z9p49uLgt/rsoDue4rWbf3lNc9wI
	 RSFpaKpdW9MYYL0ruOhmp+Y8vdN+EzsQYj+F9ymdpSYjmOiFNZKA0MKHH5ss3XP9bw
	 q/aChTDWdaHfg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Pankaj Raghav <kernel@pankajraghav.com>
Subject: Re: [PATCH 6.12] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Thu, 30 Apr 2026 20:53:11 -0400
Message-ID: <20260430160000.item005-6.12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430113731.1227-1-adiupina@astralinux.ru>
References: <20260430113731.1227-1-adiupina@astralinux.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D9AA1C000A
X-Stat-Signature: yfk3i5m378fi6x66uh7s48kkw8t6giuy
X-Rspam-User: 
X-HE-Tag: 1777596795-308531
X-HE-Meta: U2FsdGVkX1/eE37woX2KCQp76GZMtyCKjTMIOeJyIjDjMTspEgvkL4a1hM8yJnaQu90GYQ9xCIxXe3pIfuBy4J86rYn5W1YEtl3g1tAMFdzUCqVoXQNONcjwtZbEJg8bB3xWiKvFZjNqJtSPjcx4dUqXDXQwxrM/EGc33u8sN3CEQ70vEr1m675cPic6cTDRf2N9lcgacYuw7+OnQ4fkQrtlSbY1v5zDopf759uEgAVjs8csgkKmMzA2QeG/6gWe68JWJVUowXk3CwexnI2bNimP+gxmbhFLU9apvl8ZhrLfaxFMFocSoVpPMN5KP1dGy6Yr6XPZrYqTRjJt2swmVt68V6hJjz6D0JsnFFCSE7GVFMGslsPUd+NIGaw9WjSQ1ugOD76tJoHmiJHd0xBHAqbUMeAnGOjPROFpD2ZvZwVUWGADe2wSt0m0hwOujoOzNVKW6k51SZyZhOPee+2CgI8gcbe0oNCtbnzbMVte/1ORx9rZiIwXuGyQ0renufMOwuhjbADGuXg52A6Yw7tvtfwTfCpxwc65zgQIvgiWAgC+bHrssmGC1lPCBsO1w50CxHUfCr6xUT9PBCzQ5Z5xAME1ISkGoW48z6NdDJ7BAlYUInY6luhtD+j7h776wEsGzVmbCPaAhbgHXXv4vfhTJFql+uNLKV3keLBs49+29Ov41PJfFIqCdEepi/jJvlhU783rsDdPFR6SFiSh+R2wwh7phmg8ePRZAdX0bEztXRG1Xj72d4ZFxlcxPuj/O3rC80Ldr5/AaIJFRybRqGqP8rZtACqDhQ/Ytgm2j6szcUA11QHr18zlk9ArmzqojfK8iqHYV2Hr+Bl4Tj80Y9Rbi/90PQgQ423WypVaCzmnkpUx631ID0Hw5thQih+Ncljm61QYL4j9I4/f39XQw6l/oeBG7Xe8HiQ9OFlM/BjO3KKDMBa3Gvlj9fSpSt8/wqUCboUJGXlwJUqTuOBhwBK
 NZKFdNGC
 HrZm2vLR4TT5t1ceQGRvFpsi/zOZkwQOPfXRuJNl0bxDHlldUBwS66J+o0b5+vqxbYX75kx+abbD66l1fVDRuipMCOjtPc0QYgxLml1d5jvOmkQwjmGUKkH/4Jbm1nTfjfdULipZ9ONHGysatl+jD9Bp3oz/qAI8wxOyzuUkesqtrRb0Pnp4ql5Ceddc0mvv1ruCJ5mavm1F8VQKDosLG46F5mZlDMoA/3sNEeM1Sdo8PtT97qZiYZ9DtD0FjEESejFHkhtH00xEXe/6lXjmrsTYs1iA5Y5Dy+c4qZlMtmsOwNebJb+4gU81JtxwrKSCC7q3ooZdYr7PH71ZZ5rAZwiF8CfoACC81xMsE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 02:37:31PM +0300, Alexandra Diupina wrote:
> From: Jinjiang Tu <tujinjiang@huawei.com>
>
> commit 397f6d14f9c370e4910e6885294c340f39dedbf5 upstream.
>
> In do_migrate_range(), the hwpoisoned folio may be large folio, which
> can't be handled by unmap_poisoned_folio().

Thanks, queued for 6.12.y.

--
Thanks,
Sasha

