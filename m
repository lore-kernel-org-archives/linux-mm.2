Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ABCEC1113
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4AD6B0005; Mon, 23 Feb 2026 12:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCE66B0089; Mon, 23 Feb 2026 12:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413EB6B008A; Mon, 23 Feb 2026 12:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFF56B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:39:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2673C1382
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:45 +0000 (UTC)
X-FDA: 84476433930.19.5A41F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6178820005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUv4S4TD;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771868384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0yyVS3OZcTZbAz6bBfGWyMJG4inPI9BuGVo6g165Ous=;
	b=lRXAb1H6Ifu8+02Fx0MlLiD3uqQ8Xsc9BbrV93PnjPeAIwSf+2QehP0BT9+ObfN+jcnS3X
	Jcj0jXDJWhhKUIXlehXOQbxTKaJ7if4dtp4Xv5wphwmptZfNQYXwRZJiwhnT5DCDtN4eph
	TcgpqE930/8zc5f8lIXvBzIntJvVl40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771868384; a=rsa-sha256;
	cv=none;
	b=3fynvYUrIEg/+LtHXPsqrXt41cEeygwB5pnK1VmK+XXn0E03MesPsNlcm500OAIzBq5Yax
	gEyH4PXVbMRdH7tsPJr2SKV7oknC3+K+ms2pzGxDAuHgy9w5ekpe+83mLwq2RTG/1dGjTX
	5BRURex/kp6qV0xb0Hi+HPaJChS97Lc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUv4S4TD;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD48C6013F;
	Mon, 23 Feb 2026 17:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7A9C116C6;
	Mon, 23 Feb 2026 17:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771868383;
	bh=1609qBNCFT64/6Ur2waJiWhfmIJVYp2lmLTA0HMQLO8=;
	h=From:To:Cc:Subject:Date:From;
	b=qUv4S4TD/2QP47A0z2Zydcj7HQU9+B22YONNft7F8OPmrXfoWTEwHRFFSfjn0A6bG
	 5lN62eNjaSx71rwo0ri3px8bClLxdKrvNsPedRYg983bW2pHIJxqBIydZpBfPhFujE
	 JmJ0Yq+xUPfvQ2+Nl1eTBc2lR8Hlj4s3+sp8BPz+IbaXYE+PqlZW3BG1viokZL6JeE
	 VON1XoeCR21pQUBMvVsAhAZ6OB5sjpDow2zQLZB5ElcO3qjZrYQ8a3upfVarnwCNMK
	 gNA6J+SoopfwExe07mWlYgVqpt8PzXfqhCr0JlZvEaQJOpIlTgqDRE1cJ2k7rxHlt4
	 /VpZ06rebBg7w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm: memfd_luo: fixes for folio flag preservation
Date: Mon, 23 Feb 2026 18:39:27 +0100
Message-ID: <20260223173931.2221759-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9kjykdojsrnjjw865iy9gmtq47gauosa
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6178820005
X-HE-Tag: 1771868384-432670
X-HE-Meta: U2FsdGVkX1+z/AJYmN4t70tVkHSMrzvdludnv5lxH/AwTT7yQxd32UveSrHKZDFpLwJPOAraaF/OjGVzHzOrimPZVSsuyn1Y5jidyeHjKGYKpDVGkFQ8DFvxmtcceeEgj0IRdVRw7KmDNV0Wq7RmuDnHqEPBpDGjfmxFadRhQ8Ye8B7s8cXWRjSeCMIoOh/fIOVseyURhWjKTxDFbGPKU4BuYp40LkBToRhQaHhENSZj3Elqt1rbRBkNrzpoPxmXHnb00RMw36NhhcPar0/ZIJ65CvsX6HFVutiRBMqvIo8YFtAjopWuII6qAYLP5p8+6K1HHjOD/x5YUJ9rB4FQaSAjOVDZwUPMFKK31PwuhYKqsa/jiJsgoUofTk0LpuNxssc/KqwgsWhIW6LyfWxCs1+D6XGvMS1qIMpEQZMoHb321sReHf7sP8pmfs4f+kQnOFfrKgdDv8pv9KrWIlkoJZuLtAiK+gSAltNPutViAfpbhy8CCrRdL1iDU3HbSR5EdTo+kaMOxxgwO50iu7SAx5/ULj//qa3/FmUX656Pxb7beB1LRPgTNJkxGhqP3ORNhro66n8GWgBi8sNk0mqj7aSkYEidADJtQfbL0D1LJkF5oH6WbAzlRrwMuz87ixdH0h8RbBk2z0pOMIBshB2zSnhlHq6KGayfzY5kQLc+1wgGK/QVbZXM//wRGbXGpCxl7cZisaeBSgmqEH+vgUE72gdfs8E8Onzplk5M8sGC7JfQMg9FD3ML/JWqRQG31PKZnD9jQiSsznPclYwaWacj8I1JO+76OIOUvaD4R4dBc7dVJKoxZWs77WBa44KauOhKSPxwJloJCWbIDlzmHRRYRA5C3m2GWA0bQblXpf97mQu2QFXNfqAeHgXwNqkudZ3h39ehZjAP5iuuvlmqaXYkogCTU66brDq0RW+8f0hyPXV2KPpjly1trsnBxDttCpCN8x3tsz3DcFCGw0fK4Eh
 5woBazCx
 mfZ6c0HedbIX2I8hKvDaBT7Bh4yoD2zB/RrYg8RR1Zv4HBH98dSTSPDz6ty7ZdjliWkXmW77RUkUJ28YcNLD2C6/mlLv6g5EQKDtUKzSTaCXL34hOPaT/mAHjhIMhk/7Gq99Yv21hbSOmjv5MyQtkUxIachBUISkA9yXJW363D5hwTEuchfbPQGKJ56lk2K+3fxEweFhI+8gKmzhc/vzf0BvH139dWYEPcHXnr//zEAhkMahpee0dgcGiOFjsFOLCulpCHpJjtwoxgNHg+iA1Z3494w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series contains a couple fixes for flag preservation for memfd live
update.

The first patch fixes memfd preservation when fallocate() was used to
pre-allocate some pages. For these memfds, all the writes to fallocated
pages touched after preserve were lost.

The second patch fixes dirty flag tracking. If the dirty flag is not
tracked correctly, the next kernel might incorrectly reclaim some folios
under memory pressure, losing user data. This is a theoretical bug that
I observed when reading the code, and haven't been able to reproduce it.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  mm: memfd_luo: always make all folios uptodate
  mm: memfd_luo: always dirty all folios

 mm/memfd_luo.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)


base-commit: 8bf22c33e7a172fbc72464f4cc484d23a6b412ba
-- 
2.53.0.371.g1d285c8824-goog


