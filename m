Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5EECA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C06A6B00AD; Tue, 19 Aug 2025 06:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098566B00AE; Tue, 19 Aug 2025 06:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17216B00AF; Tue, 19 Aug 2025 06:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0B256B00AD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:41:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96C4D16032D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:41:45 +0000 (UTC)
X-FDA: 83793166170.12.BD9D634
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 021FA40003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:41:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PFDpESJr;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755600104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzvg1Pi+VHGTKzpFPIULJBz/SehKfwooa4T827X6OWg=;
	b=oq+7xDRFvHcUAbzx3SYLElURGRO9oFgd72MlxTZbt5aVUyc9wa58xSN/4aSDj+W90FZ+v7
	ZBcToNytkZf1PLMeVUv3fl1v3TiJkhsZAGW/oICL3w3dUi50ZKkI3grLwHt7FLCfplDSPf
	j9DlxsAyZQ7vkuZgWqMXP1bGa7043Fc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755600104; a=rsa-sha256;
	cv=none;
	b=4dgWuxlOb/hqbccjiCb8LnIGVzbr7qKGgcTh4t1wbarFN/UZwLjjWjwcNibdYEBw84g3+h
	F822Us+IebCIIZm2UF9g1ZS5Gpte+vrjx29JXF44VvePlgQXXz3FQspyT1aJE6Ad5yOnB4
	pc+xtFkazgSWXArNTso3hKNmNxC2bdg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PFDpESJr;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 349815C5E1F;
	Tue, 19 Aug 2025 10:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBF8C4CEF1;
	Tue, 19 Aug 2025 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755600102;
	bh=UmXA3hH10zy8+VYUZwjfKTWE12C/YJb1FO+ttbcpVBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PFDpESJrYV8aSfcoHIx0slZQ6yB1VuBnKvpYI5NhuQTBF/BfpMAwkixOe9YjrC9OI
	 sMAcowjDQJ/vAi4v8aa2B0mTMB4anaZ7rhXDbF1yA+IWOOxSf/fkcO9l/RCboZmmwI
	 0Px46iqYWBa34+zCyOeXrJCLLFlPYAfR5zcTAIND9kR7BprPF9izBk7ghY8hsi/N7V
	 cMZ9gcsZiK7kZJICRHm3h7gllnrbN49CFz6DzTsTJDO84T+rdlQUYwxJz53OTihlfI
	 bY3lqRXjcAfpMioNHTh8yX8eYTEwaLWu+wg7UVX6JJxZXu+w7Ffk98HnRlTSogbvql
	 pnaPoY5j4nPBg==
Date: Tue, 19 Aug 2025 13:41:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 0/4] mm/mm_init: simplify deferred init of struct pages
Message-ID: <aKRU37wDTYYocsEh@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250819073941.esl7z5ibqqeabunh@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819073941.esl7z5ibqqeabunh@master>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 021FA40003
X-Stat-Signature: q71j7atjcp5os5o3s5ip8fa4mtyr5wwn
X-HE-Tag: 1755600103-177303
X-HE-Meta: U2FsdGVkX1+rvwiStMYapd+53hizdYrcU56fqgcDx59TUANy3rapwZIu3eWSvL/lZywvIXiietb5/g6O1nvN4AFXSSksSDX+x66q4bE0RWkjZNUAynY9kdQs5K3fAY/5x1c/OU3y9vYjinihV/cU0/JjK2EeuFyZ/lMghhOcUtIuvs1CS7Hb46A4n+uy2r7t066n8xu7yDBJQ8LT3kBqQMJlIhKXYKuj6dVkGdkfCMMJ/BGidTE0ZpMpx40Jl8aswHBZw2FVdF4bYTCD+aPGWG0BeNHCEwkHCfmJVVyq06NngOLy5qFWAjI2JjDQ19NhSZMacx+/AgRizE+dzmRz9ruqY+lSURz12apt9TKi04kIIGwva8WrjWb+mkRdTi1ZgGBEwEv1rJ39P//uKRD23WQZrcVFevg59m9CuN42tYVYub+D7zB7nePZNqqOk3cEsFbXG1cKW8AvFw8eDArPSiT1UhSV5U3Iaun5xQHYWxw2lvIeCd70hX/tUHdvUgcqeeDpijcHrtVBJGE1gHFVdcVH4wxzJiFvbl1uUbdx5kSExDL1xbnxbaCZTdwYqp/Abexac3QHiiLXFtCQYvPDE+4+6ksPZtg0ztHRR4g8eChJxI3AYlr0uPMXwy3bUSW6qcYJOF6jcC7DmtJ1iqwSJQmGOP6mjMhMxWOt+h9CYSsjhRwu2uUUkF+UP+NBbw4rbk4lQfVA0rglT+Bqg7bfQY2UUYGMzkQSrj/eDiqOFO/72AHkuI40nlgFc5EeGnTz90Inh/FnjmZxeU9kczqAaGkUpOwKTf0y3+8Y86+X8QLpuzU+ByjwKRhO64GYnuZpVrw9JVRcEp8HPjfFYcJkz9OMTc8K2jT3fLiNtpnNR946XOkuxf2kU4/2QUL58iZqDahbH0Vv3G1DAQHTpMfr3I07LOoEJtVkVsSmtzpjDW1qpqpeYTzD8F7XK4ZtN09vZk8D41FEDJMMRE+XKcz
 5mwjx5RH
 M6hiFmwcyCDNnLoHQ1XscuSd0TpYIR/4ve+2TRrn93hbQxUUi35EAvJUER8ymh9MW5XAwJZMki6XDPN+5vCDZlGG3nAdGL4ZLKSei18nHDh+axXII4PxwrBIJ1yULxbSKXYSFTpD3ff8McR9Z3ZsHLKiQ1tXQFP663xvOt5YD3JN1w1rk5rrAn50F/8uAQzE4gC6hXwmX7da+AmOiqagT+LwraM4sP/h5EikBByQRQwdSMM+qMRmdps3CynR7DakTh8M67BkVqMCuwR/iOcAQrmQLxy6Fr/EDwsY5L14cPlpWzLezGgXRhBj3WGiXWZuejG8KPURynikLg9w9pLC3xLOzAodz6CuDxbn8TEmIZKzEzwSZBBrooxjKhgIld4oIOjlNX8wQWJV+mbiZM4hwHx6AnotuqTy/lq6K4DBvPAKbdqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:39:41AM +0000, Wei Yang wrote:
> On Mon, Aug 18, 2025 at 09:46:11AM +0300, Mike Rapoport wrote:
> >From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> >Hi,
> >
> >These patches simplify deferred initialization of the memory map.
> >
> >Beside nice negative diffstat I measured 3ms reduction in the
> >initialization of deferred pages on single node system with 64GiB of RAM.
> 
> Nice cleanup.
> 
> For this series:
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Thanks!

> I guess the speed up is from "use a job per zone". So we do initialization per
> zone instead of per memblock range in the zone, right?
 
Yes, we run a job per zone instead of a job per memblock range in the zone.

> >I don't have access to large memory machines, so I'd really appreciate
> >testing of these patches on them to make sure there's no regression there.
> >
> >The patches are also available at git:
> >https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=deferred-memmap-init/v1
> >
> >Mike Rapoport (Microsoft) (4):
> >  mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
> >  mm/mm_init: deferred_init_memmap: use a job per zone
> >  mm/mm_init: drop deferred_init_maxorder()
> >  memblock: drop for_each_free_mem_pfn_range_in_zone_from()
> >
> > .clang-format            |   1 -
> > include/linux/memblock.h |  22 -----
> > mm/memblock.c            |  64 -------------
> > mm/mm_init.c             | 195 +++++++++++++--------------------------
> > 4 files changed, 62 insertions(+), 220 deletions(-)
> >
> >
> >base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> >-- 
> >2.50.1
> >
> 
> -- 
> Wei Yang
> Help you, Help me

-- 
Sincerely yours,
Mike.

