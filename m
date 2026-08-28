Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF6FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4356B009B; Fri, 28 Aug 2026 09:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACA36B009D; Fri, 28 Aug 2026 09:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276136B009E; Fri, 28 Aug 2026 09:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 049456B009B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:47:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93B3BA0361
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:47:50 +0000 (UTC)
X-FDA: 85150806300.30.48DD985
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E8C1140009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:47:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8OVBi4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0eNhqvMX0/iJyiBrToLKqr6Y2gSqCXGI85V9zCEwnI=;
	b=k33TrirAOkPCJvtMQO4Akdr2ASI4a7+9LGqQA0OKo5EVyVoSgkaTIWUAkvD+5OJkzvtTg/
	qjiWz96840bQq9Vz/g/Rgnsz3+oykutXuBsaWBzBpsag0Otvll1NMuXyxs1y4RsfmdRw0I
	0XUwZ7eVYrggMKsxnRQ2SQICdvD6PgI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8OVBi4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924868;
	b=TzE9bmghAz0KrMjArkgVTKPErEqlfgzVBzjzVA2lR09A0qB7qq24jFeOfzJBdZwcmNjISD
	s7UL/xsUNwZVZuiUhXX9BZtKiNwxz98ol2vlScKrk/2p3XyS1zlJ/m9ti7xSwgO4hCY9TF
	EBMY6Qy6QzSZkXNKIxj1C1lsR1RZgqg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FE9A60200;
	Fri, 28 Aug 2026 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9A71F000E9;
	Fri, 28 Aug 2026 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787924867;
	bh=q0eNhqvMX0/iJyiBrToLKqr6Y2gSqCXGI85V9zCEwnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B8OVBi4twqUHT/S7twyHkWKJvi0Xty50bWZLsgLdUjH3nHQVyiaBK1AsPVPty6GY3
	 CpLNAUUkFEyJ4+w/M1poxHibGE1QkZfvatu0qnlUkyLZ6sB5cRTVmGrT8v0XQDQITu
	 o7t7HCrfJFnRBBj0/q5rE0t6eS5wSCG83cu/ZDFcV2U7x4JtmHAL9mKoaktAxwvPaI
	 NYDwT5qjwRAZkfmmJP8yyRlSIRCkU31HEHBsdlYCRbUSD2/lsmL6OFuAYMqddqUtCz
	 9e4DAviAQYM8qfJvDF2KYmTB4Efky7gFx9GpzI6j0wCr4ltT6ZBU9rIarIEnjsNY8r
	 4KeEra8xa2S/Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 407C8198005A;
	Fri, 28 Aug 2026 09:47:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 28 Aug 2026 09:47:45 -0400
X-ME-Sender: <xms:fZGRajO8tbszWQe3PiKqVvkxLMsSZjlif2S9uYt-vjmJEpeOFvfHCw>
    <xme:fZGRahH2nr9VObEBXt262phMqxEp4YMB8N3cIZaF2OTvfKvZa1goN1Mt3jlO2MLhR
    XRBGh-yo1OqJZU_2scto5I2lWzjToiY8e-T_Jdwf5V-V1qBqKdNia54>
X-ME-Received: <xmr:fZGRavucriFI5JGLOyzGMK7DHAHpqFqJWaIRUP3Pm9cs-8ugBLWe2PJg7Ws>
X-ME-Proxy-Cause: dmFkZTGhuVEzINoxJX9iq+sBnTJn/YGfvUD4BbjHGtjEf0PAh/o/tXr2vuzbX9U8fMq0zF
    J5YoWoO47NsZs3vKY4l9KIcKbSS0+BRZwuTUJ9JEu04yQDq/7Q2T0DrqDQ14+GS1y4+Kii
    qbLumtOCdeF31VVkfQ15zMW49EJKPf9ai0w8NgPevT7/2tBdBdQF+5JevWefJ8gD9CFyC6
    vy8t6c7nt9Z81+VYeNx6xVt0oCjgXOQEQ8R1XTjNdsxXQezprFGSM7EVxQoC61FUFtMtjl
    j14I5/V5nIn5meZ617TWS99yg4QSmnCPaVaojmBd58z3obTWdBXUPQx6YOwdozC1RPkake
    b7CQo7h8uFUrdwxo+a+KEEZRo+rgnaAsXWTX3FZp40gpI88PBF5pdoEJQoYaVNDsOYdDLv
    nnOn00p8Mp1YDklKa5PNmImiyNBrjQq3pWispVkCYL/vHtE6rX0yKfGG/mSXj2CxL8wv4i
    r0y0+WYSXNM3YyKgzh/zanZGTQ8dGkGWLsvQDqq9bBRVJpv+ELs7/2/XXATJ4u91Jmv4mc
    tIbaJNv5r4NMz9B8LAhg6+b4cg8ASkvBonDuNoJuQ96vXhlmquzGIh0JUSLqN/uz6B0edi
    gEefM8IBWm9PYMz+eSfeOcqLTGPPyW08nMQUgJOuQmELSCPiO+sNgH26i5Kg
X-ME-Proxy: <xmx:fZGRasTX6KiaE4c_cg9PXtcf5lFwklOXMwCMJ8S4HpMKKGNHaatHcQ>
    <xmx:fZGRaqEkizgCxDrFfZWtyhjb-WQ1yjdKVnYNxlNWXltvS36zBr81og>
    <xmx:fZGRahciHnap5NePGxNCROZtKGgBB-XszR-01EHbjJXxOf2TXxTKDA>
    <xmx:fZGRaqrf2oas2ahHPRsmyNxb7N__Av5_rVQJm6K2AU3sMslJ7AlTcQ>
    <xmx:fZGRauGMdH0cmV4-9-yzqayTn6Pm4Cv2Uey5kNm71uwNCdeE6SiHXVPU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 09:47:40 -0400 (EDT)
Date: Fri, 28 Aug 2026 14:47:39 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Message-ID: <apGOr0BAFc1DMQe6@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-1-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-1-6f79c4b605bc@debian.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E8C1140009
X-Stat-Signature: k1drsextybsut3o9q8gshwnq6dakdbgq
X-Rspam-User: 
X-HE-Tag: 1787924868-807017
X-HE-Meta: U2FsdGVkX18z0r2vhtgPux/BqPR//UvtCUB7zu+gQRW/PzXUZJKDuo1z3GMUHBihZULiD0HWzVLg4uzreiw/Tc3ImJf0YdTkENenFt7me1yoJPnP43YEb/3Ys0CBfL0G6jxYB8orK5QG+j7tZW5o9dzWCKLKsOpUi9VAXvc52YWUqPYpvbswk4V+AJcsSzGRw1RL7ejOj25o0rpitA8dLbeu+1ti07jI3DdqvBZJ0asm5jPz7tXPiIvv9QvMgZfOLOKiw3HTTUK3vrFIiJwZs7lGahCbNIsiGSpBX1VB8F0oc4likKuX2V3uy5AB3Rh/a5VTzIV/cvaoFwLay6BVCkMOoJ7p+fYEsklZTo5GtUQl8FVB05rW6XnDi/sKQsn1JZckH04y8wEj6E59dIC49A7pz+03bA69Pcmhs7/YZS370mQq0I9tDmCcEY4cywO6LrkBIYG9dO8b/xIF6NnWHrdpOUazIarhaq6R2BfQIXdiOKRsCa+SBYVHMpyEjX8q0JtmoIQkWvE4M4LK7saXMUTSBzCv6VgzL21LZuuGxqBRoxcMFBZR8c6I0d/qRr01Smqsm3klj7HCV4MCjlsP0tHdrCZFtmKMB5KknPRBzuov7agnfo9usWHaO0mZC1EPJu4h2sMQPzatXnVjwCStfybKUnIdtL7jyhKMFodlJkIiDTDfkVSHu0LtrawlkQTjBdNM51ZAKefCywokQp0muny61SXSi1+L63WcLH05TFdHPK2E/W3rIa7E4Xs8hIqk1x+IAZb9w5bv09ztclvKMC3FuoT3zwdaS5IALzcB/sKwmClED95A2O9YEGfTOGjgnA1UbrbtMyqCaq5JodPXqm9lAER3Imq7QQ2RJW6rb/rUBeb0WFHUNoMlf+yn7opqqgiMhyIDm+KSPXGf45LObFR++iC1mvhssfp1o3NcePlbAC0PZuC5XGTdLo7ulGnjXVuo4SVFySG3cuV1DT1
 2I1qfxCR
 WX1qRN4b1cFg/SOGvZ3LsN9E63bBM6c+Lk6dStBBHBIfxMr1JJIdD6GKzW2LbfGYgiRvzUpzFxRA4PZPvUuGE6t2qDzR+hePi4rmgidCuymfKDlsgFUPFU+fwtfq38Zb+OarzQBGJGF5qTGX9CGnJsb7kdjv3cgYWGlvMKJ11JdvLxEi66H9b2rNJmzpsA1Z9OdlDmP4vP4eYgJMpPdJQJjVNHERhh23gOMjDf0/bcu5yroH8ulg0O+5yu64ZPE1M85Piz0Hj7nuB4I9fAKkurHvQ7Mrpj9tVL42x6k+va+abxLtWDITWGDFUtDr8Se71hWCnwtQyYPBz8crsqMBE37nWbE/AZWABDHfDX6nDD2c6u2EeChadEgOWjAC+9OzSWpFyMc7cMTa2jSiJtw3cYgfXrZ5hfPe/Vk3HSg66YxH06Y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:03:52AM -0700, Breno Leitao wrote:
> @@ -1271,6 +1274,16 @@ struct linux_efi_memreserve {
>  #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
>  	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
>  
> +/* Bit N covers unit N of physical address space, counting from address 0. */
> +struct linux_efi_poisoned_memory {
> +	u32		version;
> +	u32		unit_size;	/* bytes of phys space per bitmap bit */
> +	u64		size;		/* bitmap size in bytes */
> +	unsigned long	bitmap[];
> +};

struct efi_unaccepted_memory has 'phys_base'. Do we want it here too?

It can be helpful if physical memory starts very high for some reason.
I believe it is common for risc-v.

Tenstorrent Blackhole card has 4G of RAM based at 0x400030000000.
Counting from address 0 that is a 4M bitmap for 4G of RAM. :-/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

