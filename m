Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC34CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5206B00F8; Tue, 30 Jun 2026 10:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD576B00FB; Tue, 30 Jun 2026 10:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876066B00FC; Tue, 30 Jun 2026 10:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4A26B00F8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:40:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D68E74046C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:40:43 +0000 (UTC)
X-FDA: 84936840366.12.E8CB0ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F1D72000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:40:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaRdoyQZ;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782830442;
	b=r+SC17Q1V4/NWc7FnYbxdOW0OdN4OS3LspIRAbtQmu7On5Lo5gyyyzcdgw9CKBQg1qux6m
	ocZUGj/m1cyknz6CEnl7UobzYRrVQLvm0dv7pDv1UygilSN8QJi2749w/6TVWkjyvwR+Nf
	QWD4Pt12cJ1D0tSgx/VJWGOHFU3oO3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782830442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvgyW8X4QaOk9VN18ZFlTY30npYMh5LShKDCXGOsMxM=;
	b=NYqegZANQdDjnDKFuzIfw4wqAps4CM/2/lXsLC2Mv7TSD1uDNF6hiTMVrtBwJAPMuirtoV
	o4prnlIlc/9kHkkKgGZv5A4Ks5gIhSNH2wB24GCgByL/ZJ2nuKVNB410wCC+nXDmSudbmS
	k1C7yNiql2tk/TLOdA5PSU8TYDJfg4Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaRdoyQZ;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8F40601C1;
	Tue, 30 Jun 2026 14:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097601F000E9;
	Tue, 30 Jun 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782830441;
	bh=dvgyW8X4QaOk9VN18ZFlTY30npYMh5LShKDCXGOsMxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UaRdoyQZ1fTRKLAcvtRM8pCPos/hNLQhMFDTOXBDrPIVVOLNJRA7cU6ka14RHMRFR
	 qWpfgLvKeAkf3XDjCuN2u6VoExWRrn+k9PHdw1xwsfaFYRW6apiRDH/bzW3S/vPXox
	 NDxnR8QhAiI/zPphXPkt1KolvI83eq3Oxp7pH6P8fycRjVpGLO0mOiNQvzLLw+uZ8w
	 WRnUBYhp2jcwsX+8wxOOiEB4mT754vZ1T4aD/zr4L6UdrtAvPeJdD/EC+QwUvwBkRC
	 yr2g0tFvuReybfsvjS3lYxCtUKPjJPqHyXPEmCx9cYMHhnzg+aQfCesR1JnXw5Gekk
	 GQ0tpKu3Pqrmg==
Date: Tue, 30 Jun 2026 17:40:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Brian Norris <briannorris@chromium.org>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Manish Chopra <manishc@marvell.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	b43-dev@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-net-drivers@amd.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] drivers/net: replace __get_free_pages()
 with kmalloc()
Message-ID: <akPVYpzxwP8CIQxu@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
 <20260630072344.159b5d99@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630072344.159b5d99@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F1D72000E
X-Stat-Signature: 7tkpfj6m5ki9mgm8nzt1mdwbgs9sp7pn
X-HE-Tag: 1782830442-314451
X-HE-Meta: U2FsdGVkX1+5U6Snf70nzTL7AOzEdSx75gll+XJK4qHiQHfP4ni0YhPwBd8LIetR4N6zgoZGr3dHM2nOfBe1MWcaRYmqQUrkBwIuHnqz/L1gf15z8893UyWH1Q0WwPfZLfEmJ+T1+saq1pnvM0EtWM0YdbElUdwHpNQ9UK6hLhb8hcKH9ICGcoaoX6E+bVNvq4TqmNTuZsNIX3jla94leDPVgLrd/Yjbvcoz7Md3d3Eel3vhgObtqMnSoFdb3aLbiQgFyzbQ1DK5WsdRpJhju43gBzxsBemO9Lz9YaZl45pgVr/O/6wYgFpki++Gx2ZAQG8PiwduSOBRspSYve0jPf64CcDV3t9NpU4l/dMZN2d/hnsphaHhewLvVa9rtfp3lYaY9Bp3l80TdnP/uJPKNRyf4HdcvW1UZ6/dYn6dyFC7l60CqQs45WdeZuMj3OPq2wep8P7v8nueEMtfweApeGKMf5SUrgeQOpy+PDatNzARPhIHyybf5n4fkntHj4C2ypp4xO1RIG3cUpEaxNp8Yn5Atteo02zLgqvwyfZIsVKoqQPSjyba4aokqQhs0deCwnbpEIn50/K/yFrO6ZJHfiH7GoXVSIh74CAkKj2xNXsHd837UcfuZHoF4MYTB/e5oKb8klO3/YTkTrLuVIWoBpeLs5/Ew1XQrpN6ruJpIxZZqnv/fleIUUD8i6b82dBgTVrgpGxj35VK9zQbz9Qht+wXoSKi56FOpNNZUoIAwM8WWVtSUalbjNEmwr/z5IkWJRr3rV1uKAv0EzXTTrEBwUwu48x/u2OaIxaowtkPjXiWEJEI/LhtouNjHXUs9PkKlRlsBN+oE1AcXm+VlkCw7TPNy6Xajd9TQDqvth0avoPANPZEuznfvH/eG/50FsXaHkZG4r7fvkU6l4cftNuTd4wB/sh0d9y5LHGENh4i5WsMQuyBEOJqTNjN5aLS+rRZlhcjUnwwDtAolbCCns4
 PhYV4QEz
 hTCk5DHERnZ+4zXtRWbmnPgRCCMsq0+IzMk7s4wgeBocRhQ2GszhnW/SLdcQP3nED1Jz6bQojE6rZFn/m8v0zwTumSxC0zPhdOQ82SWCaWO94V1a5xfElnVpw49elljMFOju57xY8GBXAGAdhxdQZZHTJsThIIINr82KqvgFK5JM3h90p3CQvC8D2O/jDMLc7pIBOOTk52Qo9qUHnpOEc8c8lTOcsmp+v65d+dLZj6NC4B+yoPhz7reino+wAL6+93idgsdBthRQXG8Fer1CFvfZIT4a1SRlq7B1TXEy84l4xA+a3QxEPbY8p9FaTVLc2MJ0LmrU8N6pMsPw/21iosoW9k6bE5orFfkma+DkxxCPlRj+T+Fgs+BwsYgx1gWxRMdgNFMtYmAnPwWCvsgFoIlLLTgSwvQseQLrX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 07:23:44AM -0700, Jakub Kicinski wrote:
> On Tue, 30 Jun 2026 13:59:19 +0300 Mike Rapoport (Microsoft) wrote:
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  6 +--
> >  drivers/net/ethernet/intel/ice/ice_gnss.c         |  5 +-
> >  drivers/net/ethernet/sfc/mcdi.c                   |  7 +--
> >  drivers/net/ethernet/sfc/siena/mcdi.c             |  7 +--
> >  drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
> >  drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 ++--
> >  drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
> >  drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
> >  drivers/net/wireless/ti/wlcore/main.c             | 14 +++--
> 
> You gotta split this, wireless and ethernet go via separate trees.

Sure.

> BTW cocci also suggests folding in a memset, IDK if it's worth it.

Same churn, less lines :)
 
> drivers/net/wireless/broadcom/b43legacy/debugfs.c:217:8-15: WARNING: kzalloc should be used for buf, instead of kmalloc/memset
> -- 
> pw-bot: cr

-- 
Sincerely yours,
Mike.

