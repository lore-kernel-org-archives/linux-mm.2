Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D08CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2116B008C; Wed,  3 Jun 2026 08:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072666B0092; Wed,  3 Jun 2026 08:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECABD6B0095; Wed,  3 Jun 2026 08:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDD2C6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:35:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5AE314033B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:35:53 +0000 (UTC)
X-FDA: 84838548186.23.1AAC367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01CE31A000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:35:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKDfMWcx;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490152;
	b=bmeY3zTrfzsZA+13YWepoIN10B6nID/BGzm1dGbUUHHI0DejtYQobmTIhT5sfVgWE+NDm/
	BIOoJQvQCpEU40wa5JpQnGhvcMMRySNIMYj6tlrRNIwH0X/1J1IO+1dDfANG9LgdFTYRaE
	JnfN2ofKcdZ4iMQ0+JVQZ0fJfO2n98s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKDfMWcx;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbzStD6JF1CVBiCJzS07Yx88ycASZSaAr8mU89zlpzw=;
	b=o5aCrpdDb3uvIvae4zqtK1SykJwwGJDJ9Ah+gI/UaLIpiHk735sxjaPuEthw+m6DEKLVoH
	bXVsZPUNKHqVRG5fTeN3xziLeyrmJA0fazoNtU811E1RHWz7s1I1GG5BNFN/BkjaihYDPL
	kcqj+nrrTqRpmJOZ6g15eUuD739B8W8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0472D403B7;
	Wed,  3 Jun 2026 12:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8508D1F00893;
	Wed,  3 Jun 2026 12:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780490150;
	bh=zbzStD6JF1CVBiCJzS07Yx88ycASZSaAr8mU89zlpzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LKDfMWcxrynE0rXIrrwYN/aoUZ2Rgr+E7/lykSCJqfQ+90yFbvcrUGEy2YLi+LqgX
	 TFbKhd/5Mt+uOUtmr7Kc0ZKGKFy9lneoTjtb3jPxdvb///0N2nDi8hJi99ka4rG+3Z
	 cLRADL++t8XhL5W+ATn8P9mdV4q4hhiAsy6jRkfMGD7YZ776ni+p5SUzHZp1Y0ZuA8
	 3YZSpJieKtAFSAA2VE8sMMJuuCUA66UpgOzL0kpZaZZlTIR71c8o3zvhMwx8LjrJXa
	 YheH+bQMYE/8eoFTvvjGWVtxEC5hoXpPZKvh5aZyJUiIHzbzlHQZuy2hDYPySoGqHX
	 j9vQbes5fpEdg==
Date: Wed, 3 Jun 2026 15:35:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings
 in direct map
Message-ID: <aiAfnw088f3ZT3va@kernel.org>
References: <aiAJG7gdey4oNr4a@kernel.org>
 <20260603114134.3010-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603114134.3010-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 01CE31A000B
X-Stat-Signature: ri38ut9seehyx4pgc6gy4y399ptqxtep
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780490151-719314
X-HE-Meta: U2FsdGVkX188uxoU0QGcoYG5k38jQCRx24CHbriJDcOpdeDOKFfOoZpcbSt/n4eZBuXaWKu+NTFzMEQ6QL7VsErvZIBetrK2nrBukYR/X5bIGlop+Dm/xyJ8NlqdP49JG+TCa5zR5wuSgem/ElB8GhWgq6QHT+CYZWLQwfdxFm6fxAR6OUVbHuvkNErEGzPtfcBExQVEVl3CQPdB5oveSdDMB69PA1u/eyW43wjQ3A1cbwFYR6SzUis27k9+wk2hbBitSYkc3u5wDs3Osy3NtM9JbsMJhPUSb3Ih1MRoH+XVlQ7WER5y3B3TvhUTvhqPq6i9dUJ7FJWOeYdqBwsF2qIVTdPraVsGAqjC/wYJjidgrkmV6+YfP2Eq3LTN+iqvri8mKb1jE43sR49z4Qz1IsaIi7Dotn8XqjMnrcH+mz5+2iyHT//cnlTZv5nXBuKjCDE5NEGir6Wpr7p0RhkQQ7XoAhDApo5GEdbuATl2OyvbXCnasJI4sexWFv5gB3iFnNXLEHzP1sZg3C4kQBcPzbA9QcZT3kyzLSXtrFNFo6tiw68/SiLXdgSOGNC/+3/tboytcq+DyCCTSXt3PR9f+mNqL1rc2oUK6PIa3c1oruPo/Hy5SMsFGMKqrQ5WZ9YC4z9f9qIKTaOvc1YAxCkxQisw1NCxgEvStsNhvrATCubIFMQvQytDRLRBlsmAklKfnEmjUMbBo1GuiMekgJTAOsodBWbazdzNQNHD0vVYPC628GhaWz4eDQdt/X6q9dyMABwFvKPzmE1wSYeQiTX+Wh3SDSXcDaPXSEMQ/KZbJ8+p5UGeN2ajDhc9nThJ+LuBIE5x1OdaOYS/WdYHlMqBEmvdREghoLjW2bVSm233otOa9KtjwQprkk9V0AB/qhcRY6Le7vqYyJh1gbegPoCc/6+BL2uZ/Bo4aHgvcKgt2r5+R6kaZr5qEbTef5qY+arvErV3ZcBo/U3ePkH6snf
 H7/IlQvC
 qteN+2vcCUaMJ/7W95pmrOA5XxnAPwccjfZuyLVBkUti7E57icz3E581peNbHTCohLhCxWtpW3evnZWwLuV69vNcUKBR9+NF4WOxWZ8qNXQ2F42Gyt/rIfMv4daSP85oVxg7yG+V6zBaXC6YfjdsyHuPdi5p+lLN5kMJv7b6/1jOnArQNGvBb5XkAshQXoJIyeRu9+z0ro8vCSHT+h6JkcRkvYd9qRwBU7iKHB8TSyC6oK3EJWQ60+wY684XJ7jmGqiF8p31psrTnfMTbvac7qMTgxBqBVeZDRI5SL8wul3dHu7mZttD4lYcllQxVpRK8aHOZ6AGZu9xx4jLY4lRaYFL9KpfJQ7mAgji0yNgUmPM1D1or6ckp0abZgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 07:41:34PM +0800, Lance Yang wrote:
> On Wed, Jun 03, 2026 at 01:59:39PM +0300, Mike Rapoport wrote:
> >On Wed, Jun 03, 2026 at 06:46:23PM +0800, Lance Yang wrote:
> >> From: Lance Yang <lance.yang@linux.dev>
> >> 
> >> secretmem removes the pages backing secretmem mappings from the direct map.
> >> 
> >> Removing one base page from the direct map can split the covering large
> >> mapping down to PTE mappings. Repeated splits can leave more of the direct
> >> map mapped with PTEs, meaning more TLB entries for the same range and
> >> potentially more TLB pressure.
> >> 
> >> So let's try to restore large page mappings whenever secretmem restores a
> >> folio to the direct map.
> >> 
> >> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >> ---
> >>  include/linux/set_memory.h |  6 ++++++
> >>  mm/secretmem.c             | 12 ++++++++++--
> >>  2 files changed, 16 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> >> index 3030d9245f5a..ad2fa414a22d 100644
> >> --- a/include/linux/set_memory.h
> >> +++ b/include/linux/set_memory.h
> >> @@ -58,6 +58,12 @@ static inline bool can_set_direct_map(void)
> >>  #endif
> >>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >>  
> >> +#ifndef arch_try_collapse_direct_map
> >> +static inline void arch_try_collapse_direct_map(struct page *page)
> >> +{
> >> +}
> >> +#endif
> >
> >Did you explore what would it mean to hook collapse_large_pages() into
> >set_direct_map_default_noflush()?
> 
> Good point, I kept it separate on purpose :)
> 
> Putting collapse into set_direct_map_default_noflush() would change the
> semantics of that helper a bit, IMHO.

For x86 default means present + rw + PSE, so yuu can look at it as actually
better enforcing the semantics :)
 
> I would expect arch_try_collapse_direct_map() to also be useful for cases
> where a direct-map permission change could split a large maping first,
> and the user wants to try restoring the large mapping after changing it
> back. One example[1] is making a direct-map range read-only for security,
> which I am also working on :)

I don't think users should care. The users care for particular permissions
of a range in the direct map. It should be up to the architecture to select
most suitable mapping size. The splits are implicit, I don't see why
collapses can't be implicit as well.
 
> [1] https://lore.kernel.org/linux-mm/9979fa87-88ef-4baf-8592-502ff4888085@kernel.org/
> 
> Cheers, Lance
> 

-- 
Sincerely yours,
Mike.

