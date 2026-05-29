Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478AECD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 00:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15F26B0088; Thu, 28 May 2026 20:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB426B0092; Thu, 28 May 2026 20:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854646B008A; Thu, 28 May 2026 20:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73EE86B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:01:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31478C34A8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:18 +0000 (UTC)
X-FDA: 84818502636.18.8848232
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A1AED40013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2ylaYJ7;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780012876; a=rsa-sha256;
	cv=none;
	b=iKp98v/cXO+gI3zrOLeGOLdZAAeKcgzq16kzczMDwFhOLiN/TmrW54jsfFwUOX90yJbHu4
	t/MLcL0e8ln1cQ9IuASPXMddMhMeRzz7iUbp9lVNuwt9srRER4uclsFcMU+Y283zSXMFly
	N/gSDFUjf/7BkcUph2tMZdeHkoiEKrg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2ylaYJ7;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780012876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vx8oJBN/wcV5EZq/agtzr1qbPBazCkEMU+Yp1WK1pgI=;
	b=3Vildq27kInv1SeRL4KvRgZBW+HH60fabGu/SntSuPM/tlBjThDV+6np9g3e+yQI0Ze4pi
	U4Uft1PPLN9kg3df/K3dq78vGu4ibPF9qUcuOZN23j54t7gVI/PbK0LQUl6e7YhMb9jqXN
	7/XBgEJJnAEuSDAcRTC5LBa+AisVBbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54AA3441A9;
	Fri, 29 May 2026 00:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACB51F00A3C;
	Fri, 29 May 2026 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780012875;
	bh=vx8oJBN/wcV5EZq/agtzr1qbPBazCkEMU+Yp1WK1pgI=;
	h=From:To:Cc:Subject:Date;
	b=Z2ylaYJ7M09cBU0Fuam7Bwi8DzsJOsHupO82ITB1zUpZFyTFLKslIxe92qEd+hhqs
	 IEBptpel1r45Ve0Xtiz2CK5c2GluXxHt9iWMmUeztnz1p7XU6mZndg497nExcuvl2o
	 0dJzHEDqPLPtN8Uan62+Es3pilQ2uw+I1PTCeuxegBQkXJIin0+XjcWz/3lGQIiXP0
	 elo5A+5/NmvD8Q7apgKuCtq53LcS4qsB6KWRtr08fYMOQvM3l4cSIGItO1dQbEinMk
	 CHyVJVttZGrBPxoYxFjSI2OGYjdWVS/sYBLrMYDGR0QtdRPu2kwodXtWQIaOVlcuwv
	 nwTxeBkiCI9yQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/{reclaim,lru_sort}: handle ctx allocation failures
Date: Thu, 28 May 2026 17:01:01 -0700
Message-ID: <20260529000104.7006-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1AED40013
X-Stat-Signature: amwgcc3kbzxzdfuczxfcdx7poewtum4n
X-HE-Tag: 1780012876-444964
X-HE-Meta: U2FsdGVkX19kM/4p4Ofu4Fan8J5g/lDooP9Tuw0tG4HXbxuIAvFUXOG2q/Ri1/oNM6pS4LkdqCPC7/8xTPZILZLz1nCJ0jciXL1kacjwLyAbwm7XmXeK1cHhVe6eMEdvm3QwLuET3x+X+JQKgxIgh7hxiqKTiwACyT5h3xD+FcDo7A398ofmnSf7y9d1pLgnm8F9QklEdQEs/QZk55uLOED9ageppAesx1Vqj3zrkS6IuGRYEldo2ZrT3RQXCKSlAAPwVm1J2RMjUvHj5YaPpkz8Qjkl9z7Bw+h5m2oy4MvJ3KNfGsqrcs1LZPLTd81EuZMvWglS6HLlh/ne4VoprEN6DpVReopt25p+LHH6Mghm3N8Ibx84KoMbHsb/Dx7dD8rcXtt6I+zkQn83W9h0LBL07PUOaaYbHgu9M/zgYKweGsSrXPJrYf0dAOS6LsDk99050913ZGEL5CNnhDrx0Hb+tqm1F/A2wPnyxbAHXpLeQmPXeaJd3Sn9GmHMyAklTlalNNSzKgFVaxnuRJsrLAUKYHN6IQ/J6c6VfSFb9H4aMNZak/eyQh+Pk0TCHw4wucUnNCqcXFHkse5eqE1DSwIG325E+XOd62ovKb9I1ffAbv9ryk8xVuyirRIp4tFXm1+UkwGsfdj3S4jZyjiQa+++iBzOC78xyi7z5/wOhyINaqwQwWFp5JRSu84p2h3FrffsFkK3ouDl0jZwgg5hmSUKaSzKbuHWvDqcyZvfBOtuGQ/wMxgMZpmYmaAjohLXSX55IIzDvWRHfsWMawAOYCrBjCZfLlAu2oFtVX559dZ7KBP/RU8x/aBGYYvxnEx4nCCd8MsnX3r+wV98oj1fcl/wL0QZ4L4Z684Jmldq9jZ5gNvz9DF8/0buhLYCrRgaJJSMkJcTVLy7cVLxPT6bCKcgvbd8ebpoYHqMYnMOmzQHg5/sKVZPKIGprRJH9cuew1A/wQZSUCawaII0zsN
 ipWKfqMZ
 7DBf3UbOPQRCGzdrdUMU/PZ51eDaPF6JdOvuPv0lKN2eZYqZFKbUgwkztqCCyirxrGiJdIC7RutWxHXTFwUWrr1Ojnr90/o3nQb00bksPTPU288alXNujOUYCoRq6SABWiAz1kIMdRYtnj5gQsYLpqeFXfKty77xGRgT/hS2FYgN3KslDbSeidEyvd3oL7JjY3UeFwvhasD4QcZkQFfsMCXTmT7iAE58q5PVdoCmbye/qUwTk6WMyJZYJmm1U5kdTAC6ZQL9zloCaK31B6lO/CjKYsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM and DAMON_LRU_SORT could dereference NULL pointers if
their damon_ctx object allocations fail.  The bug is expected to happen
not frequently,, because the allocation is arguably too small to fail on
common setup.  But theoretically it is possible and the consequence is
bad.  Fix those.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260419014800.877-1-sj@kernel.org

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260528061110.2172-1-sj@kernel.org
- Drop RFC tag.

SeongJae Park (2):
  mm/damon/reclaim: handle ctx allocation failure
  mm/damonn/lru_sort: handle ctx allocation failure

 mm/damon/lru_sort.c | 4 ++++
 mm/damon/reclaim.c  | 4 ++++
 2 files changed, 8 insertions(+)


base-commit: 62a58b8764d8e485eee4c12d24ee107ef11c98f5
-- 
2.47.3

