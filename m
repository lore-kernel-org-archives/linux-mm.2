Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85BCE85389
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 20:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71736B0005; Fri,  3 Apr 2026 16:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22456B0088; Fri,  3 Apr 2026 16:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37FE6B008A; Fri,  3 Apr 2026 16:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94E746B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:49:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B36D416030D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 20:49:54 +0000 (UTC)
X-FDA: 84618436308.02.38B495B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16F2DC0006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 20:49:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DtTvGZNL;
	spf=pass (imf10.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775249393; a=rsa-sha256;
	cv=none;
	b=HOZYlrr1YqZevSLW4N0v3dyoiXj75tj9cbQtORBGicSo037Q/7omNJ3PCBQNMP6mkhDOdt
	uWZtkXiP6nhFalqSmZbCoG2xbXY2BXrZaot3+R3OC33d3yOz60VEahvMcBSP7T0dqDWx4b
	9pzx8cyOQE1knviJ4k6P9fzpeEegSh8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775249393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmZzkESRnT12PAhb2AwLxpLGFZNAdHzaUW68ueoXBgA=;
	b=rDSFZPsrWAmvXMfimOnR+vhtWT7mwCKH82BrA8dyAUBoehQp2bhtFEPkuE7kHNAz+WT67U
	D8YS15GVXi4WkgFSEZyPalbQnVkBr4WfRLahyefAyk1v6T1VWSksfia6/dvoMlAzFOcwDj
	fXLt9Kv2sTO+FXLZ87bLm7CItTB+BnA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DtTvGZNL;
	spf=pass (imf10.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44CBB60008;
	Fri,  3 Apr 2026 20:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5B0C4CEF7;
	Fri,  3 Apr 2026 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775249391;
	bh=sMnhRk4H7vsQFKJHv1FLVHxi/sSwbRHHpcNnnYwCO84=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DtTvGZNLaaVcGJ7CqYXJdkcLABrxmaouQKpPQ7NvFPJm3ClWqz2fv+4C5VmW45wKk
	 o48p+PWxpBuuwrvAGk/xIb//Ecztd6FXj767haIoAzIUXxQ1VAFpZaPVKIdzoHBh0r
	 6HEc0P0qBJxx3hO4Wi8S8GsvVFZZtAZMhL8307OHFnZZ6ro/5+ABtZiJer6Dew5Si/
	 n4IGzeK0Ym3HCm26fgntGYCVHxLhhnOYHLzuA77T+R+KbQZca05KFhn5c6R2+nw/lA
	 A+a1WxbI9IilwIzkYvEqzV7QE2wYEOZnJkYInHLWU9XTj8ZhMEBhc27KNDMmorW0D6
	 pJaEY30em6g+A==
Date: Fri, 3 Apr 2026 13:49:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, riel@surriel.com,
 edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmpressure: skip socket pressure for costly order
 reclaim
Message-ID: <20260403134950.3af8b4f5@kernel.org>
In-Reply-To: <20260402232511.17246-1-jp.kobryn@linux.dev>
References: <20260402232511.17246-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16F2DC0006
X-Stat-Signature: kcn6i4dz1kk9jth7w8n1zp6371ccza1r
X-HE-Tag: 1775249392-292251
X-HE-Meta: U2FsdGVkX1+EsB8pL9eNdCYwSnHaOu4p2eBBYJOrPpz642Hf36aPsjkE9pGTpaCTiP96/0abWzg9KE0ZXPCRl4xh/xAv+spHZdlddKvvmy16pkbiVbJuX1DVp/jCpQRy+GpYhcFUql40qCvnv9A7R8fiEA1wE0D4E/Sm3y4KswPaypQwY2Br+3jxN4HvzTa8/ERrCj6LjYVZbsisLrawlXypDqMunkcqhmhAd9aGlJMua5hQUr8fAkb/lxH13xhbc2n5Em6aR4QCYa+WDoXTL/lesBbGvGIWbwnwX7goKot1C/T5/SZx8vM5s/B17aJ4HHnhhBxRI1ABr6/KtIVEtQC0PcN2frhV30KfVP1FlLAaynzlhal8GWE6j3057NomSP70/8KZ+lZGJHuJfsmcOCDHTMhk4UD73KnF6u/bpsPmBjzHc6PwVi8FGYrzpdrUQOnHE6NRE33n6IhtcLI+N00+sYrl1ix8iv7kTmzTYhSgbVqt5NspYcPCq5x1w1VMXgB9Ez+dl4xD3hwxMS0hOFw3WW+IP0EDihDylwccqgNzeXzN/8xqMhshpYvDP5wj65Fk9BxdJ7RKwSSeWiTwmqp3LW0VPp3MXCpnqHzyhp1G89/tV1IXC9nHPmTC77vwW3sbCrorIdoDKjkt4fkiJV/d2pRxyETnXmDfNPSmc597fW1DvRQiAlIprP1iHq3o4r74q+w194EP6Z8MGRVIRY9EOybNr4uaLjK8lg0CdHw4RnxZqBBuDZtPp9TbyodsVqvoMlbbxAk5/9f3LNSiIiJ9uN8VKOiHU1MWdXr6BI3a131NKH/nTqPcv/jkMwWqgL3o0WtfeM2J5rHOcOEnKOdcGI46tA5uZ01ZZBZxE/WvdljnmRabd97M5E60FaYzc8cfFLazUeEnXWtgv5vdyuMcTM4rsQU9TKsLkaP+xS8mwER1+qz1UilXK76vvvpKDiic0osNNuy5pJ/j9UN
 k2PviJdJ
 qCQuIjmdJ0rl8QTZVKn5GK236JqGu2SSePFz0+C4RRaa5ruEBjQyuIHh8Ex/+YcV97EX1gQyDZ0QsXK/bl+kfFzflGSgrkbUf6WGAnpzx+cWzYx4w10uAPh77AbgoxHIQM+dabNx4nKFWSdsLT//RVxyfvHP+m+D9JXmlLGo/Xtx9Lo8+8p5iPWrLYg+r4VjikY7gz1MSy0Eqk9X1wFgag2pd8Tw94l1mYOrFb/58dFDfMANX4fCCoY43Zwtzvb5itDibS8rpg6ZIh28LBWOHHqENig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 16:25:11 -0700 JP Kobryn (Meta) wrote:
> When kswapd reclaims at high order due to fragmentation, vmpressure() can
> report poor reclaim efficiency even though the system has plenty of free
> memory. This is because kswapd scans many pages but finds little to reclaim
> - the pages are actively in use and don't need to be freed. The resulting
> scan:reclaim ratio triggers socket pressure, throttling TCP throughput
> unnecessarily.

Acked-by: Jakub Kicinski <kuba@kernel.org>

FWIW

