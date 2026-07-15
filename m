Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E62C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11606B0005; Tue, 14 Jul 2026 20:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73556B0088; Tue, 14 Jul 2026 20:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90946B008C; Tue, 14 Jul 2026 20:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACEF36B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:12:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C54EC0459
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:12:49 +0000 (UTC)
X-FDA: 84989085258.13.5954253
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8767D140004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:12:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWnx+NYf;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784074367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozXR1slcn31dh4aPRCoJtnpI58JF0zu6o/7FlOEgDic=;
	b=oiJu6mXGdAtvKaih30d4hUPuldnahck7Mpm1PzjzgNb9LdVOFcznGvUMuO4rAiaktchBfk
	2+HkyPkt/9k8tvrg7orTpME2jYoSzHwDLRIUmUBCXb2BkstD09KwqHFBB1IlYBMKZ5wLdv
	lgoYW0Jjh49y9CDUO1mI+F8MJkiL/UQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWnx+NYf;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784074367;
	b=2YcgcvbvGQIabRLYbMvleaiYCFd5rrkWwUPgANiwfn4vW4HqXCjM445NMbh5EDayD1AkqL
	eKpzzjUWS62W/DGYQjYCv1pjtWNHZ1xe0KDCixzvwFWOq0di1GUbjxOGiueIS063Fwy/Jh
	ffvZRchlEpwicmTFiRMgI3Rz09u546o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF642600BB;
	Wed, 15 Jul 2026 00:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E4C1F000E9;
	Wed, 15 Jul 2026 00:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784074366;
	bh=ozXR1slcn31dh4aPRCoJtnpI58JF0zu6o/7FlOEgDic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWnx+NYfb5FwvhodlMCqyYy9nh3ePVb+3EJrWivJxXTvWSGs82XAB8VIaNaCfAPy5
	 Q3FbGZplUvSxCvjPSZ40TLOAypiEZz5xFWI+WM6pCfzbJW1LhKI0A/KR+Dq/KhaWGJ
	 UIYEWddX9euan+TWsq3cmbfVlR8oHSU5WMHgea3BtfH03wg865U2kX+cMugDjJE8dA
	 4LKczmP/eTHCNC/VDIiU6AmvcTsS/ViXEgkzzE0ibsfX4uVzg05YnwTmKphqJo7i1e
	 R7yBSHNUnUsL+QRgQAC404+8LwGj69OaCPOqrMejp4sh+ZDO78lAppi/M+kafGSqD6
	 O21DeDJrhipZg==
From: Sasha Levin <sashal@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hughd@google.com" <hughd@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
	"baohua@kernel.org" <baohua@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?UTF-8?q?=E7=94=B0=E5=AD=9D=E6=96=8C?= <tianxiaobin@xiaomi.com>,
	=?UTF-8?q?=E4=BF=9E=E4=B8=9C=E6=96=8C?= <yudongbin@xiaomi.com>,
	=?UTF-8?q?=E6=9D=8E=E9=B9=8F=E7=A8=8B?= <xiaoyaoli@xiaomi.com>,
	=?UTF-8?q?=E9=A9=AC=E8=B6=85?= <machao26@xiaomi.com>
Subject: =?UTF-8?q?Re=3A=20=E5=9B=9E=E5=A4=8D=3A=20=E5=9B=9E=E5=A4=8D=3A=20=5BExternal=20Mail=5D=5BPATCH=206=2E18=2Ey=20v2=5D=20mm=3A=20shmem=3A=20fix=20potential=20livelock=20issue=20for=20shmem=20direct=20swapin?=
Date: Tue, 14 Jul 2026 20:12:30 -0400
Message-ID: <20260714200600.stable0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <777ee2cd231642c682560b41b29798fb@xiaomi.com>
References: <777ee2cd231642c682560b41b29798fb@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8767D140004
X-Stat-Signature: dfrb84xmrinat3brmi5iyf9nfqekxdom
X-HE-Tag: 1784074367-823351
X-HE-Meta: U2FsdGVkX1+G3li3WgColePy//bVZwvwrHVtDPrFcBzTmYjpwvq59QfAX+m8iVmoN2htQJnEcvfglldHhxNuGMImDx0Gk85chHNFzElLm/FHLrCh8ltZyYgABmZaOMOtgWSfT5ppYPkAYAnqX+azxFg1a+rbsd4tmqDDF1Q2Fj1gBe7NMQQq3eHYODfMrIbgqAACHf/A/12Cg1fpcVSFkh8EUettZFlhxHc6bUyjoqK/pxkv5nr4mL6gMyAxmV1zEO7IAOWQHraf3FnkLBXk/ZqImXaqqeKh62dR7wvNZgQggNf1I7EWGiq3dZLKmL2gFj2R1KNrqmZzuDR8oeCPyF+D0JRYPXrEZ9iNJRhlZFeJgjjV1glnuwKkfqdSruqLEHj2I3m6JyLCegVUuCbAHcAWCmgWH4ptpXJn7YMqn+CjjQuhFvkO0OBxEbs1xyDEEB5UY117MxGEUHtIsqQtASWPgrURRbl0wYPvsc60FNUOnzGWfgEPkq9jF9QGyPr98RDqjqTUp9aY3hLkL/gWhUaJKROFK7pRlOZxTTfmcAXawISMc8zR8hck1NdyCH72k69L9csUX0L7FEJFqqITMDevU2e2GGHYwsNfSVSKRrnTk5n5OO+89He2SxNMgO3gR4+pcsjEuvdiIN9nIRYBXn/yOnQaUJO4qo+Gdx+6WlU+a7i6g6bXkf6R+wGGaoZUvA6inIikQCXMWmmjW1tRsjWuoExnhRo5m1eJyxiDChZQittuKwszduGmB0tVO2fAU2uvaVwlU8ilQ97XW5/N9wS0kyWGfJNHHnegTD7EsGLPVPa2yBEbKG05cBiLW1wtbcjjDY7lF5QifdB1UKm5xsUV5b6ZLp+hztc28YFMkM7DLa9J+1cy3sLYnyzzVocqKaF9hoBey8pbHno2yAHul03LR4cTpXcGK3+F0R6AeYDpBksoY4rbMDcL+UdJmNFTe9uGrNEI/CTkd1nEjdB
 nI1MR3Y8
 65QWLevA8sm7+tI5YX2nGeVP+H5kEOizc/DKW3Ha0D+OPaidlYQzGIhknKXdwZHverINeWfZA+RMBbrgtdwWh9Gup0TkFuCXtt20dQPT1yodH/morSj31hZYbgqZgv/9FtltbSVYdUkeBRdCkpm8yP2mkgoIhFsICQ34X90O/7AS6iWPguGXZUrv4iOFdKeooyRHlLGT+KGUpWv5+VV4XN42HUg9ax4RZBXS8DBt49o8iqTm52L6DSWIT39bfqqmiqgk4Bw8iGCkwhkV1E3JYupQLKcXvakpn+0TirTEuS6NEL6MxK6HVZ0fgdOKRVHSmfLpO0KsPDt/v1FkAkMTVMSEuPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We have conducted stress tests on over 10 pcs for 40 hours each, and no
> relevant issues have been reproduced.
> Tested-by: Ma Chao <machao26@xiaomi.com>

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

