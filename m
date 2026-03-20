Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E93A10987A2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94866B0117; Fri, 20 Mar 2026 12:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C0B6B0119; Fri, 20 Mar 2026 12:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8DA6B011A; Fri, 20 Mar 2026 12:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91F496B0117
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:06:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32EC38A979
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:22 +0000 (UTC)
X-FDA: 84566918604.20.7F677CD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4741B80018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bNYp0mZl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pGpNwDo+f1ausatMeb9NVGgU/g8VF/Bac4ooJHeFm+k=;
	b=cZOHf6FnfANFk+uyZrsIShREbPZ1CDiHAUzn4O4s0ZR3GTtBPP1CSU2U+rYyeASydYAiKH
	jvKH0GSj7y2/ixuo1GnhrSgv/FpuHT/rGl/qipnr0RsW1QVj0YzUWFbCpoIrxoW5tbZVdD
	pzGBRGwuEqGuf1GzUjE9oJnnGxkgCdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022780; a=rsa-sha256;
	cv=none;
	b=yqqDihUuIfeSu2uozLPUkFW698td+48pWEM+RcInL+nRcd0EvJ3IZz+mEcbvgpb22pNZYa
	25PYrfxpk7F8+4QtMka9KaY1u8tVvKuHIcGZKWf8qluxAaOIITvTHRORktyiRzw5KAp11p
	mPtHY/s5BpNifzqTUmhSawnj/UfBssA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bNYp0mZl;
	spf=none (imf30.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pGpNwDo+f1ausatMeb9NVGgU/g8VF/Bac4ooJHeFm+k=; b=bNYp0mZlRsTWoWlEWxvt7ymdDT
	XbGsJ6fFDWHu/4zmFFnpSpoo155CcIttoKcCNcGa70B1cd7n15qzeIEu8uClLJZltkfRwnr5lTQW9
	3li50gw378Zkglr+2P8HUOq0GbXEDF3P2Lijxo7w/vC6RW863j1S9qC0gygKI8w2Da3Qt4LenTl82
	lfxm3OHs/U2Gm8vjldNB6ViLT2r/k/6hcrwaPnoqLmNXQM/UzgfIOqjLCbJHtRADxEiIHuzUz+gfU
	Ne9/nZZa7ROrSn9Dcat/UOcGgO7Ysp1e62qXfwBrhIw0EKCVWkm8mJIDaG6ddVRxisfFXiF203yEj
	OY/i2bgA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3cMM-005Jzm-Ex; Fri, 20 Mar 2026 16:06:01 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm: huge_memory: clean up defrag sysfs with shared
 data tables
Date: Fri, 20 Mar 2026 09:05:23 -0700
Message-Id: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAERwvWkC/yXMQQqDMBAF0KsMf20gRusiVymlpMmMjgsriYog3
 r1ol2/zDhTOygWeDmTetOh3gqe6IsQhTD0bTfAEZ11nG2fNMszvxJJDbx6tldhKLaFJqAhzZtH
 9zp6vv8v6GTku14Dz/AFGyVK4bgAAAA==
X-Change-ID: 20260320-thp_defrag-540fc4f1fa3d
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1274; i=leitao@debian.org;
 h=from:subject:message-id; bh=UGsJnKeScicwgBdocc9aajUpugkBYpAy3Js1cC2djLU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvXBjRMwsF8ICE7/H7S7/LmmV0dP1A9rv1VPfn
 aRd58RANK+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab1wYwAKCRA1o5Of/Hh3
 bR9qD/0bg8cG1ks2LE9vrdmVytx8BjhPmeOC/6BgKO3lP8KeSRghWVGYwTih7CVDThWcUq4KICZ
 UGwT9M7OsRzb7QnJIMPRHmiyjhlZJduxe8gVoX2XeMUZ5XU+MG3hyY6xXyajKmNI9oZIShsqKFO
 t6R8TZpNuQPvv6So7M6tLwjQYT7lx9djnWIVBs1SAUUx+F7KHaeh2VdKChUUk3yji0iA2rRBzZ5
 5CpDzWOUPFz4FMU3jq5/HIUlR1wJOhf5L6rVwba/G8hC/njTxJsz18PKHcTPFjTbXWIZCgxTtrk
 PieGOjhsWFqjTgBXxkw/3eZ0MtK8xZfQoUXkEt5KTxnxpfexhxhrOkaAbroudJxfZd4P7Crf2Mt
 Nc97Nb5IZxC8UCUZxUhMgPVEV+qqjHxpFUcezyJrYVuu5drx5pF/wt7oH5J6RmKwQkKDL+5AzO2
 VANeo3IRJ9OZZpIAwrpQnfly1ev+6M2YYHuPP+1D3iTQiAzehtBYf/3sr0z899OVyUqdLkBJ2G+
 qgciZKlWFxQYLEv+ImPmIkweC/WolMsOHeJ4AfTI/YIRei34lPjSa8DBtPbVzikEbTtDrkbKdBY
 SoYlWECu2JgqQJC+VSaNEo/v0BLCbnh+khwIuc1kSW8lohTxA1uK9Nvthbe6LFlEw1yT6GFP7MO
 mMs5dMX9tW04ZDg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 9kyjwgc56ctmgu8fz94nnznqp95798y4
X-Rspamd-Queue-Id: 4741B80018
X-Rspamd-Server: rspam03
X-HE-Tag: 1774022779-887571
X-HE-Meta: U2FsdGVkX1+9Yj/NNYsNvjrVf2PRhaqiY5Jmy3W98p4m0vJNDcHmL1BEBTcICs3KlcKT1leksz5p5C4aG/V2m2816SZ5zUyzbrqNrHbRtZLnO4KMstJPzDh0D96PUdMC2+iCm0DyMiLTx9Jhylb4BBTJLuaV9ZzD3Q/xLK4BoYUbWnIhqHgVOcDaS7nM/FiE3cwvuvcCdGIvOzHnILUDaRgmSOezoQpfeiFdC/bHOVe6Kd8/RHFSVNOTzOamWKvp5jDrdLoVWDvTMXYyFDrgHTr6DZTF1IrhxgjqAsE8wMzuHeppOev/D5ALobvIumOcJ8N+BIJxDr6O6qBAeqskEyp3IkSh2oI2We+7up5LxjZTicR9KM6IH0fR3YUiV2hCr9Vj1gEDlcfR82Zq5O9UHe+n5a5rM3NKHrV6w7R41Ybq/7Uub+iApQioZGrzK87Hwbzo8AhsokBNoJ0whZ9FUFX0+8IbRo6VLvPpNSNb634DTdjJsBVt85wCU/fH6jD89x4iPi05b0BsB2DCVZskVs3tdWUTc1stjMgNLJ+N5v1cqP2Ygq6GZ+hah8U4LaZQx2YxLrMJjQV/bqUW/WEU3InBXCl/FMhqrFHpmk+ciVWLdApgHMHxHIidyMSp6oWU6pT4CzeymOe/xcdzL1NLxKT9WuwKijgjoE8jODHjvFGeExWd8MHZk7+fvMHPZzKwQUHSAEFJ0P38VAEx3o0C0XakdzLiaO4M9BzfFScjhas/wetW32WEFdz1XP8k1Yf1L6r0eG3R97QHg6SB6BIn2DJU6ow/5YXyaKhz69BLSFT5UvIZIsoC3rCmyzvJxdh4ZJQY1DWPERIb6O71b2V27HvbTCF1zHMCo7dE9wcbCvm89oCswcterPxF3jGLTzn3mdr3GPkl1rZdVbjvQ2G9N+TQoHZxE8j9oT1azQF5/hppWT3fyQJ1qYCTp1g9O5SYQq4BKgYBLn0XWOqDdyc
 l97j3S/T
 gEJIhyuRRCumAyGdUqXDeiSVCnFcklf+zyJMhmClMcu3Ou9ajuDPydpP2Dt4eFOBoWtSvzuXLHCYl2DZRbGegNfnyeYqELJZ1z0MNVF65Ajm/5XBnOOzTfpV2O22cIxuVni5fs6hk8R5HviuLAV80I1G4XPnXLcW43aRHpFY/yKH2nH174sW8HiL3FvjqzShiSATZJ8OcEfLPcu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor defrag_store() and defrag_show() to use shared data tables
instead of duplicated if/else chains.

Patch 1 introduces an enum defrag_mode, a defrag_mode_strings[] table,
and a defrag_flags[] mapping array, then rewrites defrag_store() to use
sysfs_match_string() with a loop over defrag_flags[].

Patch 2 refactors defrag_show() to use the same arrays, replacing its
hardcoded if/else chain of test_bit() calls and string literals.

This follows the same pattern applied to anon_enabled_store() in commit
522dfb4ba71f ("mm: huge_memory: refactor anon_enabled_store() with
change_anon_orders()").

Breno Leitao (2):
  mm: huge_memory: use sysfs_match_string() in defrag_store()
  mm: huge_memory: refactor defrag_show() to use defrag_flags[]

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      mm: huge_memory: use sysfs_match_string() in defrag_store()
      mm: huge_memory: refactor defrag_show() to use defrag_flags[]

 mm/huge_memory.c | 98 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 42 deletions(-)
---
base-commit: 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
change-id: 20260320-thp_defrag-540fc4f1fa3d

Best regards,
--  
Breno Leitao <leitao@debian.org>


