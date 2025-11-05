Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBB6CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C018E000D; Wed,  5 Nov 2025 12:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CC18E0002; Wed,  5 Nov 2025 12:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523008E000D; Wed,  5 Nov 2025 12:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB6F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:37:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3DE51403D1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:37:21 +0000 (UTC)
X-FDA: 84077259882.06.42BE769
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37A78C0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:37:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwssDAbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762364240; a=rsa-sha256;
	cv=none;
	b=GbLEKCdtSbK17bbvvXgTMkKilQgH2Slty14LuEBPs7w4eKQ7IdiVZCg6pyliOHynFWc9c/
	W76OgLpncfr6ClFJ2etR5KWbgz6mVYZ91T4DCXwiX9HqlzdZV5ct+YUWN613RrHVQ7An8q
	6hNePbPJ0aHB12fdMKclMeXwgHjARqg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwssDAbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762364240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oRX6H93K+8sdo8cLCGPw0zH57ZwvITwM9e6I+WIaDs=;
	b=k+u4ORriGXWEx1GdjtcPIE/NpRhnCqastXrpalTVAKSqL3L/QxTH9AJGFkrMtSnxk4ryIz
	SyIHEIUvZBgHjJG26IV/DMWS9wtmPOV6i4qQ5WOyXVutAN1mVjqy4ThHUKz6Hfmpte22PH
	eEU2yTVARjzoV30h4oDkioiawxmxz+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0542440C4A;
	Wed,  5 Nov 2025 17:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C02C4CEF5;
	Wed,  5 Nov 2025 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762364238;
	bh=oikeBsTkXESg/zQM0VeX21fpP5BX4NjeQ4ImkTAOD5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FwssDAbz9953tgEm10JYoi4KJCfP6SA6HAnQavrw7zTCAAxZbffzhzNi1qIUHFtYB
	 wktfURi/o17LfLNLdryKQcTkeufo9Aa+Yt+Z1np3CrMVo321ZTgvxxCWVfmLki1ioB
	 ChNFrzDkmWVMpPJbteshSWo352Oe8lIzVbH+Q0ePF02kVWIzYfzquMgYJYdu88LS4k
	 +CXAY85sr37wiOCTIs8Uugg5lhkgSTPGGGIzyqgOSWZoqE1sbFC7xnD6zrTXKn6zxg
	 IHoTiDci/Ni/aU+QDZVvHJ71CB3OFl9+zb8hevZBjPFcpWNvWPXC4agZJQDi2Q9t2P
	 XLtb2qGWIgoQQ==
Date: Wed, 5 Nov 2025 19:37:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add myself as a reviewer for KHO
Message-ID: <aQuLSAAy-hfxLVsJ@kernel.org>
References: <20251105102022.18798-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105102022.18798-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: 37A78C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: o4aq19x4o87b3mhy9m731cr764to5738
X-Rspam-User: 
X-HE-Tag: 1762364240-356012
X-HE-Meta: U2FsdGVkX195OyAt05ZeIoTY42MAjrVflUOxzkpU6/FRyqGgNfCrMkxK1FQ6tt3DBOZ9dpu3Xa247g1wuC/JZ9nWMaKF2H3HFhC6pvQy3RiMGux8Xvm4HXKJnNr9kcr+a/x7c06Qn3CKid1qF5UeFGNTTqAkkPkx+cjCpmvm3XCGeC6NOZtP9Ne0M2i/JwPbZtc9qSPAJBc18rNlAHkNfQlBGBKx/Bg0YTXCwXZ4pmP1rNzNGf3wcIi305WafjcQJQYL7o2PC7Nj590KDSbBWK8Kz5xfznhToV9JIuJWu2lsfheHibAD9k/zaHvDx/+WCZwFHhKFN6SR9uw/7KMRoNB/4EldZPSFol1prMIdc+/3heeSi87t4lcNk6oj6zKsU23i0mgTblSAIJ+93Fq0v1IjDDm+ZUPQ5yfdKyQbI+hXsOFMgzezhCPTaZ5k+v0Uc8/tJBd4D+Ti/Oyne0zqFRkEM0YrmFcZchPdsm2HQIkZJukRLfQXtM0X8mOdSybOKXIpt0WRNtEsYMA+S3bYzEX9d0NY2iS9CeZDvKH3IKn//eH215h08rEpbvMQEl0XG2Qk8SaZLc8pgxzyNCua0peWHj5ACJb64Ba9ie8u8ZSx0c/K5RHYoe1KlW232qNJoshGQBQM7qi6agy5BMxgARBvywXkP//qiFDh1PSR5OEsfyLh0+V105v+FdcSDJwK7nqIJMDhOYCmXd9dZ9lh0So6CaUs/e4hYEVqROZ6/8zozyx2PSzXcNUkBObVr+/7hxrigU5uoGeZzLx47DfwtAwtO7fN2XXmRXaax+ryRDh32UorX3akObt/PLQeoYDDeCMSgfk2GDJzduvz7CyvoDi72buUB7gj4/xQQF47iOrnTPAvP10eMhISRfJam0YXqxG4G815N/Elzff8/ueQnEHY6ioxR+1TDXL84jNMbpsrkBYAFjjbOS16SlH2sEvD2ihnivXgzYDYVnFES5v
 LzjBSaYR
 OwYns+q1CS+lhy7yMhRH/OQTofWcOx7wEU+W1gJuQQ56bZjcUSAgsNGkZ0S45Wmzgq0Zpo3KbpMXCkqridZkhiakxIFGbHY+AhbKcvd1XWxYwg3jlP2mGBh7Oes7AULL6o6pV7HfRuj2PY5bJ5r+BoElJluYznSNFXiZEN778xp+kMBWconrvEnp2mOqBi0mJ2njf8xFM15RfRn+IFcCa7Ugsk7xsHuPjJ/ptGpuxkZXK83Fq+lXbRZ1VcxQV72ob0rein/kukDh4ISJ0gi9puwat5uJ5WHYap8zgv6NG5S3eb9qKNYKBMr2UlR3gO1AhX8x2IV1+4UZ+/+Md0cPnxbEeq5S+rx1OqNNt6BBK82qb+0yxy+34suXAPU/mifwAzXUBKTOtBTFO8J4xgErCeC/caIjQBiKXgNkBhnUuhwY9aCDQk+lVqENEDw+iqmwfw3mACJrnPwzN3ZYH/ADFYJbH5CIPf8bw0aOe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 11:20:19AM +0100, Pratyush Yadav wrote:
> I have been reviewing most patches for KHO already, and it is easier to
> spot them if I am directly in Cc.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8ee7cb5fe838f..3c85bb0e381fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13789,6 +13789,7 @@ KEXEC HANDOVER (KHO)
>  M:	Alexander Graf <graf@amazon.com>
>  M:	Mike Rapoport <rppt@kernel.org>
>  M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> +R:	Pratyush Yadav <pratyush@kernel.org>
>  L:	kexec@lists.infradead.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
> 
> base-commit: d25eefc46daf21bd1ebbc699f0ffd7fe11d92296
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

