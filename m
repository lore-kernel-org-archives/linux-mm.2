Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1464FCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2078E004A; Fri, 10 Oct 2025 14:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689F48E000A; Fri, 10 Oct 2025 14:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6A68E004A; Fri, 10 Oct 2025 14:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA898E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:05:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C56FA13AEA7
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:05:43 +0000 (UTC)
X-FDA: 83982982566.23.94A09F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 20B6640017
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:05:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k2Db1sDw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of mcgrof@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760119542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFQnRq75O6hFgaOQaSTP3rqTuOiLz78g29oWZzoZQss=;
	b=OB0/Oc+YmuzymZEZJlBKIFjKxhGS7FEG1snUUYL4ZjREVTjPzGt5Fm7ULOQjlY/uv6Bzaf
	R3gkjdyar+NUh8KlPOycMn/DDKn1KkHA8AE5EIrTq4oaiHr0NzyZJDQrF42J1fe7uMH5q0
	xuUBgl1MDF1Tib2swVYa4RmSrpn2Bz8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k2Db1sDw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of mcgrof@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760119542; a=rsa-sha256;
	cv=none;
	b=pR1W2kBBVMMrTqFgp89H5dDe1/RjGaqRXBDZIbp8RcuYpIp884HNxOOgahzpiwUd9FD2RX
	g+2BxdgUAD0fJeFr+4demALL0u+52+XDqBG3Pp+YE8K+dhZ5GOniJYoFZbB5lKppvKHVQI
	HEjkgpFY5VpEgpkLW/Mipptcmfh5/6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15928419B6;
	Fri, 10 Oct 2025 18:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C6BC4CEF1;
	Fri, 10 Oct 2025 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760119540;
	bh=bXaAtd0ZAtT3g66t4s1DrZe7nl/S25MHh/OuCmnvSnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k2Db1sDwNDpgB00o01QYKVNREYyMnv61ip//HC1HGaWSaZ5p97cKFfQn23vZ5NwHX
	 pPvaMi3oITNCQIOihRHjgzxjl9z5ANOQK2d2vJTgKAC1+uiCrq5Nkf96s6UGdKB68X
	 ssljcFmuLsUQ0s9OQkNYZ0zkV+QDoua++XRffKP2YTble2bOGzGPU/0XZbQb7zkGkW
	 UzSq2crCL4CGfofdYxiFC1Ja2+DlXPwpllL77bQ45xutQ0tYL26zeatdPQBipEDR3Z
	 Y0rQEvQWjtDNAMY96oBh1Iznk8UIJ0R9eI11CCl8OL7ephE5IGIzQlDITZcLQz8Puy
	 Wgum2S2XB+I/A==
Date: Fri, 10 Oct 2025 11:05:39 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/memory-failure: improve large block size folio
 handling.
Message-ID: <aOlK89Kd0V4xt5J-@bombadil.infradead.org>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-3-ziy@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 20B6640017
X-Rspamd-Server: rspam03
X-Stat-Signature: bjyknsdwyktndueckswram8moqcanxtk
X-HE-Tag: 1760119541-355385
X-HE-Meta: U2FsdGVkX1/FOIe2+OTw6O9KA9dn5gRWqbxx1rkzPrCWhIvpfQAYCJscCogSuHv5e9UcxPAr7bggscGmrasT461FqOmUdwNDysh38DF+8352IYIyH0p/hL09VnsFChjN6vapgJwtm5y2fs8k9Pj702HUgYO+O5wt9HrZTWkIKn7SmPU1yAwfETpWFO6srlcCOFJcLp4CrCCxswBxHMTE6DIvvcglCQJ7JZ5/AL0xODuWduE9VjxRwPYtWEMp6VGNm52Ib49ELGJIPBf8m0qRL5W96qGRdVUUvriVZ+To6h7tTzsctOtd/RARg4EV8aICpk6QeZCbmOmZSFN72sRxhHgrwFel4daW6M2AMJPTaS5ag0aoOQfAfl4THogDD6cKu2oJZEUDUaPs/RcRasAfl2yL9v4OgY07k1fEDzDqb60EqqDSok+sFgDkCFriZXpYKgNxcrApO2tJcK5abF33bXamhluLPhCRwNtfp2JRXDIlEdgK75WZog3S5NQ2vu//5GPyJefKyXTXTtGuNZ5beqZsHrC4mIau1f+s2rpmy/WlYqYYobBhODvR+2d/wfWJyCNgWIMKH2CuBs4lfLlILtuBpqDDscsm0HYkngBM8ikTeVyv3AHosDrlUoT1qO2qnZ9EH/g/TpjQ84Ev1sKxeecKHkenab8usrFl6RucOkzyHDF3NA2nsvXNNL9t/F1Y6xGqwxPhSMwuw1zY7+A3XT5V/r+ZSm0bbfaB9RxbOENRyym105ecezPO89b1SysW9uQ78P1nxWrcHXvoM8ExKXIpVMAxqAdNyxLb1XMxwtdHQQ7r8RNW/g+R7erou/I/LA+mS3u/+eLklI5R7xgSqJwjmvNS/H1D6/U2MJSd2btBCilwphC/DNMvtWT8nCTtuu3fnH75ALTT6S2fa4w08n2mRZNZavcsMDvAkCYFr2M4YpnIqKBzT+iVhVK5C4iF0bxTAHE+ummXRu/tnEb
 V5XYCom9
 0Y4J3BSVBIjWHjomd90KeUeKLvUe9C3EflLVQHscEdgKmhEZyPlWZq2EAvcDrNcYs1lLcwbh/hpH/g+8PM0Bf7sGGocMpBzhPMxHRofv4Ae9VKk92u3fPA6XTrERFM/gIOyN+rRwXye8KauRkCDBWUG2Ghe5tUrfGgi2HuXULHRmvZqHrarqzQ1cSr7p9N2qdbcGDKeUq6731n7yHaRMLohoiUwnZKg6ue1ncjyPIvi4wcf7/ZK91n0kvW1gy7FQEtdQ3PY27ETTqWts5QyOVNtw/Rq0hR1QT5sThv/cYH7Fq0YGonHjih0Svh16l8y1HYVsQS1iaKf298EgvKRM+3i399h3lQVHJfTBzXLQKjyYpIl9MQ2xJWUwY1/XHqp+lfvWP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:39:06PM -0400, Zi Yan wrote:
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
> 
> For soft offline, do not split the large folio if it cannot be split to
> order-0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

