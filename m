Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44C0CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5EB96B0005; Mon, 18 May 2026 07:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8676B0088; Mon, 18 May 2026 07:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8426B008C; Mon, 18 May 2026 07:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 965CE6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:42:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 379711C01B1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:42:26 +0000 (UTC)
X-FDA: 84780352692.25.81BC09D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C55DC0006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:42:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XQ1/izm1";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779104544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J17lvD2KpaBJSFUnjyJGMpES4yeC2qYJUys9nrVcNvg=;
	b=Iw6YtGyz33M4npLjgQEpo32HPWzUCuxJLOFTkJuLPyhHvlGko0spoJVOHrxtbDDNBDzi0R
	ESFC27bjOTack72d3ngvzatYWLGehZDlnktD+yrLsE6q6yHVGV5/ip2jialsIQJWwengYZ
	RTfyvpbfT5/oZu0adCGb0uY3ZcyfjPI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XQ1/izm1";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779104544; a=rsa-sha256;
	cv=none;
	b=6J3L++w5BuB97HeJTdqJpfcxZluAq1fsJZ8PHQY1fgZLp4xTKAFEEbdh7+QfUUuaiDHPun
	DhgVmn3JgdSW0VhK80DkOIwLHZoEFWV8HDfqKJxq76rvkkDSCGUnHXwPnC0Ua1K+yGPxqL
	JNyqiqG5L/plNSpVPIcH9gXG77EfWj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD41D60141;
	Mon, 18 May 2026 11:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E891FC2BCB7;
	Mon, 18 May 2026 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104543;
	bh=5fVr8irT34fLgAlGFHPkcaFG+MtRNl5XhMDgmimc7fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQ1/izm1hgJXImuxiobG3wAHuX9JKjLpfaX1Z0WwRbF/7nXtNRnqjt96r7ECUy8rd
	 c0wEUStWikSffbaAHDHTqBycKU5YrGxAVYmtpLrTH3CxwAODnXCod5+LRL0laWga5C
	 yEV8CY8a+NZw7LRD+7J5lIgl9q2WT5F6d5LhuDVqN0mhFaKw3MJtG506J2otNOQ4v5
	 RKaFFOq2fDY0NIp8I5+ovDtY92ZERuB3Y2hydIFgCUBMvVwLQFn3LHXSclTg7mRzge
	 P2/jRcs1iYoyVLPf+ocX4VY8GtJZLZTOHxFykMKwhb447HXs0B1kjEv1jP6unL5js/
	 meVWHu1uubNJw==
Date: Mon, 18 May 2026 14:42:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
	dave.hansen@linux.intel.com, david@kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mingo@redhat.com, tglx@kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 2/4] mm: add a template-based fast path for zone-device
 page init
Message-ID: <agr7GIZOjzr5HZMt@kernel.org>
References: <agq29raPaAPlM8kV@kernel.org>
 <20260518095405.76367-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518095405.76367-1-lizhe.67@bytedance.com>
X-Stat-Signature: 9rikdmx4d65yz5hr36jx734bx51wrh6q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C55DC0006
X-Rspam-User: 
X-HE-Tag: 1779104544-201456
X-HE-Meta: U2FsdGVkX1/4yKOO7WHv4YLdCwmC3vx6M+zPyaQ/j1L7SYIRy80zGPYjH9zGMV9mceoIZ5i4Mk+CMl8FOwhq3FZWPAEwU3zn5xujEaMyGdGGDHUIzUJq9+UgcbsBC0OBrlEpNvYMFdgAJsNiJN2ClGEbTXqBEObVVjzPoST4BZW4XfMxx68VShe1TLYIp9igHzS5bEWWmKLnHwxVm4KsAG+95+kMDr8Uii+KrHCZN5ZqN9OckBTSs4VGNWESb+IKgBSjTkdVweN8j5sgtaQSRnP2eAGHcjiQq0ucHZhLuF5ueIg6uJSVXPSfJ9fV/PB8/vkLvgYlwDhVkBJiYlEPPY1TpBI5f47BRCYjGu49hj8/0lFp38CYPhoo0WXHCWhqVuQQP11j9D3U7khR+DJ8opHTx2uXuBCQObKd2OmSbuoNBEw7Ae/4O5b4Bo9uY43HXmYj/Qg6qL2NXsdDPVKVsQpm53atfiAf7uGahNCVPt7RB6WlrNRbxcbOf0ToEOcVVcZzTELEdIoBI/GbHGM04E5/3n7UkZktCCbho6EGs9mYYIBqk4Zf2HAxRL3Fe3VA0CcjYfgV9v9Q9/cnIDo+QJzgxd3H6AG7AJFvUC7YJ7BYYYhOM6lcdvT033RRVi+/niPGZDWmOWgXcXeqLs2OXRXYr7/AiLVUbYXa22DB//Igd72nnyje4H/W1FiGl24cZYvlhGD+BcyeJvxSTsaf3eSuE6TyLFpgK5UCfUdoNMI/B/6wBPQ3VkwshGczS+gvIQBX4xjf8c+IfPLCkJ6hhMSNRN+QM8nB77yjddgpz8TV1LPViSz0w43Q1yHsG0/z0/zECqUEdjOJ7+xdXKZJAEpFddXXF4xfk2g0sfXWRrzZlkaPJ1alyswoer4wetXSLkExmmOe63mvcOMdPoLp0yo4Ncz4bwBTOp5sY4R9SysesrKeGFfWBVV7j4boV4LO5K6iQ7KYFK1YU6EJHLi
 7PQlhs3i
 4elFmQrT7Rk+5ArP3s6aqt7kBOMxYYcImnXy3kAGGcDxv3qomccwHPwTt7UtollRuEuOiv0jg9hmjTVwCwB5zUDxvaseq8gLNTJlluefk22t2ZEnl10A1S1W891Pu5O8FwrUMeXEug4vi8ZHOPlkqMJws6p8IEQ03cx1nXeh1Ps/Tmn6ToOMUlU0B+Foo2LOMrFa4UQ41VF1LG4VA2/l8avszilOKTtZXXhuNL398XT4G4dWDqlE14JZJMqWARe/fm+8YvaEYXViE9y1mtws7dP3TXuyjOreg2noFmyfDRwHQrwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 05:54:05PM +0800, Li Zhe wrote:
> On Mon, 18 May 2026 09:51:34 +0300, rppt@kernel.org wrote:
>
> > > +#ifdef WANT_PAGE_VIRTUAL
> > > +	if (!is_highmem_idx(ZONE_DEVICE))
> > > +		set_page_address(page, __va(pfn << PAGE_SHIFT));
> > 
> > set_page_address() is a not when WANT_PAGE_VIRTUAL, you can drop the ifdef.
> 
> Upon checking the implementation, set_page_address() also has another
> implementation for HASHED_PAGE_VIRTUAL
> 
> Following the style of __init_single_page(), we only want to call
> set_page_address() under WANT_PAGE_VIRTUAL for ZONE_DEVICE initialization,
> so would it be acceptable to keep the #ifdef guard here?

Since there's no other option, keep the ifdef.

-- 
Sincerely yours,
Mike.

