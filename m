Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADDBF9D0C8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00D46B008A; Tue, 14 Apr 2026 08:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7F76B0092; Tue, 14 Apr 2026 08:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9152F6B0093; Tue, 14 Apr 2026 08:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81EA36B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:18:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EAFA14056D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:06 +0000 (UTC)
X-FDA: 84657063372.17.CF102B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A669C40008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXQ8pWQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169084; a=rsa-sha256;
	cv=none;
	b=ey7AzCQmtBXHhnvJzO7G4hyiDDH717He7eiU+pI5FsCR7+4K6fdZSHqeDyxrX81qSyEM71
	9y8vPCbgu7KnEIYwkUOGed2ruUu5gC6SwQyvLo3oey1y3003vLAnDCgM5wb+Jo1E/kApdu
	NT2sLJsj2fPrcz+WOiiNijSYfvLW6Jc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXQ8pWQf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K8w0UbPsKgFPntpJSDcyPSMGyXgpJ9VXRNUC32rQB2s=;
	b=v7BTHxW+2LxLcotcCkiJSKYguxehZOXTsxSv7U0vfZNHCJozKPlK1twavn4yisoYAKeBS9
	iSi/3TOv2dP0hza0FKx4XIQWDPdS7U3s2qDNGcK4JS3nZdGe6g3zSUe5Q45K7NKrRTJnAl
	1ZINvS8lLYxrfq27j5gYo7mZ3cYHvCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A63C7600AD;
	Tue, 14 Apr 2026 12:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4659DC19425;
	Tue, 14 Apr 2026 12:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776169083;
	bh=CEduHNMB+bD8CU8dbS+YH2K40akHOotLIUiWGX/S4PM=;
	h=From:To:Cc:Subject:Date:From;
	b=VXQ8pWQfTRkHQEgHdDFbC/k4+PBPqOYgALtjJABuAKg7aZ8MEKcFmPs7o45HoD8Nx
	 y5c/gH2ENkCnmUsym6nrpHPMJF5aZQuFGbgYlB1XZC/cDWmVo5GBiJXvJ2zugYa2Qz
	 EkS3dHrmDbWQAtyTFQwkr6K3dcXt2z4wIBfDXRTdDWWop99PWAfiehUtbR7UUCL9/i
	 sBPoAFeJEF6vGkAqLbMFoUKevcmfY/yvsN7c9ijiBwmuYB/6iRIlT5CkD24Bnt5sMJ
	 qhDEfLZbQmAp4KFZyccsFTSfFER2VSa2+U1RhQJOvD68uOYrGlUu24x9LT2mGx4H5F
	 LAuD2RPNtbzKQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] MAINTAINERS: update KHO and LIVE UPDATE entries
Date: Tue, 14 Apr 2026 12:17:17 +0000
Message-ID: <20260414121752.1912847-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ny5ayekfg4gowxpq5k344xswhxgzhdi4
X-Rspamd-Queue-Id: A669C40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776169084-968939
X-HE-Meta: U2FsdGVkX1/GQtolw702fM1lNuQbDyWNJDms3gjqRGJF/q91rSOcTu4m3kBqeMaHX1IvjRQTV1ZTpiNYkAfqcrRxVGUA3VQaJ/kaGandlc+w6wwJAo6zCmt6jK4Ikw8EgKkZdmqcQtMBC3kbmYEEfoi/KiUu0THqpvj5qktSmznBGzxQAOReToPuKdH95N9DQ8ahaEx/eBrD0R7iopoh0wLMpeQXfd+P2/M23V0rkovVqCw4H+2ZY+5yuI30jaS10EtZe5truItIWqTkJHvF01Mt0Fms8sJBOkzgWQAaPdHwGPWlYg05EFrlThJppPH9WHJ7rMQ+hzkldFZayOoS0BjhdelSrOAZOp5hoG2SYXHgn72kuZ7oya7S577NhLgvRZjUHOtdQedGZZxtGZd1Kb0t34lZg30EvjVcket28rQeYG4bZ8QyFQERpxlbBg7ECn5B4MN4PDEJocJ2Z5FPzLAqLsnyVc3JopRkYt9hfBcpkFjmH2vi0Hf7EMZN2FL348wLJDsAlevNS9fqGfLJhBjqWwDWgM13kLVzNhpODJo65cNUhl3j77uJxmKQDXP35hKFCm3PTCCRbfh5nZQzUVz+yEBdFYvIoTpjhGUawCbAPHuiggCLz42JHRbrRWCyoTaaDK//+K/Sugs7vX57dQ4TsxGpjSp/+c4bXejEeVIu7d82SLHWhcBjPRQgtf6p48vylUft0lMm17Gr38IeFHhDgO//bXU4ShuYxiGnzT9rffKsJQT+79MSZGLFzxbGVdqfdZa/U59H1LeirunJ9tcFvSB3dOYEplPiOZ7EjkV/xi+us1YM1psBWn9JfTEPTklqrrSwzA5JjgmYWC84KfUOb7METIFg7xd2M2/wt5Yt9AhBtSZtNWtJFoBt+xuEMVOrwdHsW2QhFFET4eUi8n5LupaGtyJCbTrWMy2LEAwROBBAhHdwecnZtaHpwaaIVOUxHSHrgA3Jb3Rk+hk
 sTK75nUL
 FN8EFmMgFKmPwVctv1bYgsLyd29M4AWqh+Z7bBcJ2bHl0Gk3bnkWZyeGxBNGbU/vWnesSi6BQZlJCtYcTIjqc+w6ewIZNTgNrjbcpKpfXtSVlyNCE7xvxf0IzMJJLS2pAM+2WuW24ZlEgDneNzLNhf+m4poKZRjQFFN7Io8QrKtpa9pAHalCm2Cl/FCqAIj2Aw8j2vrVog7M/hrSerEv6f0KxDEdJaCip9HL4mJLgMe6x6Ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series contains some updates for the Kexec Handover (KHO) and Live
update entries. Patch 1 updates the maintainers list and adds the
liveupdate tree. Patches 2 and 3 clean up stale files in the list.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (3):
  MAINTAINERS: update KHO and LIVE UPDATE maintainers
  MAINTAINERS: drop include/linux/kho/abi/ from KHO
  MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE

 CREDITS     |  4 ++++
 MAINTAINERS | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)


base-commit: 57a117e7a3b3b47ee89b4b937b999a21a2c6134b
-- 
2.54.0.rc0.605.g598a273b03-goog


