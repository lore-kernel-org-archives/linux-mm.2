Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8286EC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C106B00EF; Tue, 30 Jun 2026 10:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763ED6B00F1; Tue, 30 Jun 2026 10:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0746B00F2; Tue, 30 Jun 2026 10:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3A26B00EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:23:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4D15A0526
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:23:47 +0000 (UTC)
X-FDA: 84936797694.25.66B0A67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3F5274000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:23:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FAKx/t6u";
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829426;
	b=TlI5+9xCgikzi/6skuEbRmqLySO1QM2WamNWQaYRKjNYsVETkauw8lh4UKL4lCc3V+7PDw
	C3WE9V7YKEuFBhiRCwDrtPmklfX1+cP5sEpbnzJSPOPQqFSnD95vawba4E+a+kRi9wNXJ3
	ZJgPOMPKRPL5X7q42hZ7ic+FvC4BK0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Hhhr2XcfubTUcrvTbwWhwLy7CUCWTZEVOLPtuGC1E4=;
	b=pQJXjB1GtIRoETXrhNKdgvAoa/24S+ftF8EOG0+9oXVK+dsCJPMZ3CTTA1AZuwtRoyMS0f
	b402nGJaSbGW6rWjr+txg63NunuKzNPd82tY4viJkNg8TlHL6D3fh8vTe0y0sR4e2SAa9U
	02hjkaK3I3Z4ruKpIf5qW5Q6XlPBRfQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FAKx/t6u";
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B217B601DC;
	Tue, 30 Jun 2026 14:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E91F000E9;
	Tue, 30 Jun 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829425;
	bh=4Hhhr2XcfubTUcrvTbwWhwLy7CUCWTZEVOLPtuGC1E4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FAKx/t6uR6e0YnXhUD4OAIvzCSGSFQqB0vFZUhEgy2dgiJnluy0duaFK6NLRYiwtu
	 fVDfi6acLZR+l3CUXlY5hftQWt/eE24AJXi/lvEcSdMFqXuJ4frYnZ0itSCqWXgRpl
	 NkxGX/Z1g2YgctN43YDAMXODPkhFFnXpPr67j43JUyr96RZ4YBioADsYLsm1iFUxvL
	 kodoBEkjnvidKLPf8W0IWgLBeeikaJ/MwZ32d9NW2RcMvE5Z8DmTV/IfxrRD1LrLCw
	 CIGyHDS/uvzs9a2YLUoQJ/+oG9AWfESzK2/RaL5bmBD/3DuJWQPM2GV+9y8JozF2SR
	 aMsyqYRgaYGUQ==
Date: Tue, 30 Jun 2026 07:23:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Brian Norris <briannorris@chromium.org>, Edward Cree
 <ecree.xilinx@gmail.com>, Francesco Dolcini <francesco@dolcini.it>, Manish
 Chopra <manishc@marvell.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org,
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-net-drivers@amd.com, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] drivers/net: replace __get_free_pages()
 with kmalloc()
Message-ID: <20260630072344.159b5d99@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: isngbns79qcc1hq5enwj8gh98dmhkjg9
X-Rspamd-Queue-Id: 3F5274000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782829426-877367
X-HE-Meta: U2FsdGVkX1/Mo/9my6ZKZNqT5w2c2aoEvDEPOT0j2hz8248gfVjILzRoLFG0uZw/j1iutDFdNTrXEisKyKwOo2mgBJ/51zoqYCkAV46XHQZ6IqXlKHEQ8upM3ZWV8lkPasgZN4BnuYIXy4W6yxqQMt9vqRZ6YVF4KBKsEGr9JQdJTyqQLrbIMrhxQt5HqZMeIN8Ac9Bw+0KPLTouWRDl2VOjs3jfaKF4NxC2Cv0P5SIdgVOkbnfj/ixpsKb3+EngLzU/P2cZxFtW6wCDvgB4BKG64FQwE/NIlKjcyQ966TFUGQVkIAVDB6ji2+qIhh0ieihoyTnraWFP4Oyevg159atOXh55zh/8tOT+TtcmH0QCKcF+mrRWv8ltrj2eWQNvWHA4NYDolAhwqngLb06S/jj27HZGDPuOpNRLT82hE2Zha9jN1DMKBOE77sXa1GDPd0RA//qsRNXWj7B9wHKajPhCUR7iofHoJXrf3yj6WQO1XttqgA7tVW13DPCTZ1vjfnrXaG3NJfXsWq+UbYHAm6mc88uNIsmpmmJufpBs+cm37eiR8HyILSk1vbtZdo0lu3IwgtJIY6BzGN6HlXIEgSi1seDqduytZi4N9ofU7tV6tDk0JCLEwuDamKugM1GWQuJtvOGs9Pgc0CtssBZzrFlp1mlTggxQbxiX7FrjyJQMZB7EVgFqY1BhjEwcmmg9Plcq3Ovf642DkBmuH8NVgI/EEPVZ2P0bx6+XUE0OqQQX1CY3mqqTxgiXCYGsy56KdwS964tFrwRrn+BsJ2VaI5206Ua+cfVGN6JYoBAXLLqRJhyLvti0GJsoj+yxFK67P3bIIoVWzlbfx/w+VwhdM4rDcNi2BCU+bXtIzLExx2OfeMjrKu5Aeglm6BpMjAqxtmoeueCmCEPkEr1tn9HzrAS2HwG0SH4lX+W+ZG+LTZ02vWKWUAGz59Fn/UvAvvX/AXE4p8GF6XG91RQMpDt
 5Om7zXoQ
 /GaKz1jOheMxUg6CU75dOpI7ilO8nudWJiG2C7gCpCKAeE5Mul70A6j/6XetTMPxuqibfQox8WddjZPcizv86TMf5DFt8LYF1RegkSzvxp+Ayz0+hMltGUSZTTqtSfQEfZ4J3VQFiRbar34nYtyfd8jXjJv9qzO6bDhQt9STThm7c3E8a8EqAbCaiwS4LK+JqlTxDJry3cjbGfdliWWEkP4JfsLMA8m6oEid7hRGTEWBQvpV7FYnHvIHrbYpcMP4IcF7Z6Eur0MTdbCSZk8E0fLXQ+meEoOYZTMLCVORcLMLVz7HSlXWMpWVB+nxXa016c5vpp9rwmBTA4kzHus9C43MkklcBYyCqRfPIQSp0hF9EUlMHEK4D5Qka4Q3TUSEOmp43ZHB6Z02OR0EVuwoo+ibMC7KskWFPiRkn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 13:59:19 +0300 Mike Rapoport (Microsoft) wrote:
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  6 +--
>  drivers/net/ethernet/intel/ice/ice_gnss.c         |  5 +-
>  drivers/net/ethernet/sfc/mcdi.c                   |  7 +--
>  drivers/net/ethernet/sfc/siena/mcdi.c             |  7 +--
>  drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
>  drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 ++--
>  drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
>  drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
>  drivers/net/wireless/ti/wlcore/main.c             | 14 +++--

You gotta split this, wireless and ethernet go via separate trees.
BTW cocci also suggests folding in a memset, IDK if it's worth it.

drivers/net/wireless/broadcom/b43legacy/debugfs.c:217:8-15: WARNING: kzalloc should be used for buf, instead of kmalloc/memset
-- 
pw-bot: cr

