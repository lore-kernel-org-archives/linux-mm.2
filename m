Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF33CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DBE6B0005; Mon,  4 May 2026 09:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E796B008A; Mon,  4 May 2026 09:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50506B008C; Mon,  4 May 2026 09:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3FB06B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:21:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 728D6893D7
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:25 +0000 (UTC)
X-FDA: 84729798930.22.1426C20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1EBC18000B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7l0O4kJ;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777900883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h7ZIk6zvX/AmTbn6HVWhaXdl1p5ppbRiCCZCXMOjzQ4=;
	b=b6LMQlCUq+49OWbtm1R1qg/DZZwNANbUo07Be0R/DKZ/j0seNstDTwpebY8UOFA1Fdbhp7
	rH21zMDghxlz1w/VOn6vc9GKsENLStkDp/Qa85t5+8lm7Dde6EB2vwuUAiEIv/1+XlclQJ
	ckYZxS+nIR5OQSzVoSbwWxoB30PTVvc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7l0O4kJ;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777900883; a=rsa-sha256;
	cv=none;
	b=DoeUTSf9R65Rqd9B69dmM5BfEZiw/PL6TGAic6Az95u/WItCrx1AGkdi9HgFLky1bbtl0o
	l1bln0JSwVWAmIexjfBLlDeDif9HS8t6DrAzs5di/XttAqH1fnwf2fvDReNdS2gCznM/CL
	2VH7EbxO4fedXBtIA2q4D6/wLXth2fk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E1C3601EE;
	Mon,  4 May 2026 13:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28826C2BCF4;
	Mon,  4 May 2026 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777900882;
	bh=SsHtuEPvGC3kyViuoLWSWyShZ8L4lLLvmBTowmvnfOw=;
	h=From:Subject:Date:To:Cc:From;
	b=K7l0O4kJZCLYDWotuijxec7A/xwyoCOvwmYYi2PUdgjRgJuZ/MEWmBcUX26fMOPR5
	 mxPju0yWy8px3fAJY6DdiMKgG8ZF0udYivMlcMlfpi1TKJxgUq7wO44Sldqw4GiUae
	 5yPw/Ds40wfJN/DD4r1xeK+wNjD6ncvH19tpnLMjKTqSxmZWTZ0y9vYuRxYCFRY4IA
	 dBGoZtFpLZRuGT8naRyxh8X/nlm7SsNXp7HhVt5dbHRKDEXjOVAmhTPDVoONzFkN4Y
	 wWuRzLi7SW+VnzteRKKW5N+jHVwFI29B2lzkVoyrnOTJi+Whk7hxabDnWB3zgIiqHk
	 aRJR6j0rXWk1g==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v5 0/2] mm: improve write performance with RWF_DONTCACHE
Date: Mon, 04 May 2026 15:20:48 +0200
Message-Id: <20260504-dontcache-v5-0-4103e58bb377@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OTQ6CMBRG0a2Qjq3pf8GR+zAOSvsKjQZMIURD2
 LuFiSU4/F56bjqjAWKAAV2KGUWYwhD6Lg15KpBtTdcADi5txAhTRBCKXd+N1tgWsCwpBe80GM9
 Rev+K4MN7a93uabdhGPv42dITXa//KhPFBFMvtVDe1EKb6wNiB89zHxu0ZiaW0zKnLNFKlA4sB
 S1VfaA8o0zllCeqK6i5dqaSQh+o+FG5/7BIVDoJyllNbc13dFmWL0iLHUlUAQAA
X-Change-ID: 20260401-dontcache-5811efd7eaf3
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2206; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SsHtuEPvGC3kyViuoLWSWyShZ8L4lLLvmBTowmvnfOw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+J1HUxBqaLQjgCmtV9FQgaX1q7xykjnH1MdED
 XG4LdEnZ5yJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafidRwAKCRAADmhBGVaC
 FT1ID/4v6frEoJvAxeSGYv6e9p/nY2D3grfvnZonYLx/8O6bEEXepiGYt87s15VkD16BKBrAU1a
 ZUz8YMo3qulYi9Z3jAbLKr+1/gRvZN8nB/IguyYH/uYnosVnG7Srrcr4s+E//zmCQAAu2xItU69
 jeLIH/hTGVxMWYoBOMIrjr9137jt0n8ryEGEgdU6B4GoT9kyjM+PJ/wGPaKXK8SouVlLi6P2mHE
 yLcy1EcId1bXp+jRJ+68otJOL8FJAt7HaF4v3vKA8hRJ/j2A8giDbdAWxgdV8ahJKkzVSVvmSPd
 ZxQSusSneZtCMsq37ksFn7zVrjz3Gd+53PVhvoh8JUHzKMNyStomcghTJbqNUcxAGZxrsr/koTz
 f1eg+s5bzEgOrm2x0EXYf5ZUr7avZGzBFS79fzv1DaXgMmZMTOuXT2R48pJrLLH6B0272iCuaq+
 PTagZ5jWGf33t5+6iOHLmlkkBj/CH8TVgHppY3quZK4XRcm9vPkhLITPrJFropMVt8g+U6lXNdZ
 LWl9YWSZ1AC05upca4sFeg1cCE79f0tUiO0kvqnQSVnTUTAvzkO4pwTTKUHk1RjuPAUQWH+QqXf
 taQ1YsGMF2Ry4zp3fuz+tEarwDz1M7kN3CmgK0jPL0RU6ZQOAWNdKV1TdCAuX1TfMRpAy68hfXK
 e33FyYtpAWTdxzA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1EBC18000B
X-Stat-Signature: 16qwfk4qah879w64uwfwp5g7xapxnktw
X-HE-Tag: 1777900883-241619
X-HE-Meta: U2FsdGVkX1/dOKmzDHYbk1fTlHeMLlaKvmW5VD0xUtQ1MrNWR0uyKojVPVXMEH8440jB1dGDf0kwPWUKdmAEOOB4L4KuyohHywpCFjlRONur6lvcHo4+NgyU3BS31tgbaAGPRuWTdInz+WPd0HiXi6AXcVXA558vyJX42qM0+/6FsbOnRgAvFU8EuLRKAB0hqZyVmIfuswUDffYRF2ywgCkhNCSYvvuBXKE3SxBZT8WmFz411Yb4qyvqcAt4CHncD7o58EOhJ1jRO4BW95EpHYURKzq/vS7BXTNL94OWvubV9AL9PTDhnTisiRgiwxjU2FQ0TKp89UN13LBdToRQzKfKlm5vpdUPkcsSf5/2sCSkYrKpkamTsCyGgtjEYOYn9diiZMUxi+mA4lqB3X7Ww0aTrTUFkZNhq5DRNdl0ybHhlBbD0crV2Z8+4Pc3Y6eJMxNaX2qlIzNanjAZH3KXC/ZXYpmPvD4GMHh5a2OH+8KLCG7zRvkntY9M9RHwJXBw71ZPg8Ce/Sy30WQv/p7RAlgCU/N/kz7Gru3CKhvZ8bRgiGGViOZ0WQR+vY7OYkRYO66MECBaqQ7hBUV6HXnhZjCfH+vkjfzljWugfNTP3HClOhJD+xev0LeryCaGhMD9Sfatb9USOGNHGFDgsP7APLbZwlYE/8WA/3id3lehg7UB4Tht3ThR1swB7gVtBRFk3XLeOTEMh1foFYd1IMsWnFt/Xar/3E9gkSu4az9hcvkrurOxGZm1mtjJ/zOIWEiOLBXt5MVnv6OT/wB/ePXPAh0HVq8Rv1axc1/hmuu5tgOP5QasiKD2g+ld1gGeQqybNRDjrXWCQMGy3Dad7AcSHKu9ZApSSyrJk67jsNHT+WVoKK0pkvIkhuJM1NeaLNbQ9ZPIkppXrcXCFu8Z7mB7alI0WQslTDF3y1HpIl3UH2VVxuwn+/q+UHy7k9Z0fexC2fJMLEYtyHPMVcl1NC/
 EtiieRxs
 unYSi7hhU5rD2S+CJT8Us1nn2YhP8V3IbG9L7ITHd8sqZdSo0nUWIxw4L3i1WKZgKU49PrudeasDTuVt7L4v1d/b/HAE6ERHVlvgNDsRDKV/AlZYzczpUCIt1uhVfRyAhXe4u8FgNOTTu/rimlHmeW0T70vNuRISdDYzYniq2/q/f0aE/DjZgz57ty5nVBUi16nYiUAKoGTjxrLxoiNkAr4IHRhv8b7Pk+stSOfbQJiDHZbDRdeOdmWJdA5m1ts4Symaj17kJsmWH60iJDW2rCIFoTaR8ygBAyVdP53oyA71NYMf+LM78Icg81qrJFFTitUpCgeQMSs99C5AvejqGGFem1YhgruxcjXbneTrAQRyJZIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is intended to improve write performce with
RWF_DONTCACHE. The main difference in this version is an updated comment
over filemap_dontcache_kick_writeback(), using the verbiage suggested
by Jan.

I've also dropped the two patches that add the benchmarks that I was
using for testing. I don't think they're appropriate for inclusion here,
though we could consider cleaning them up and adding them to xfstests or
something if there is interest.

Christian, please consider these for v7.2.

Thanks,

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v5:
- Flesh out comment over filemap_dontcache_kick_writeback()
- Drop testcases from posting
- Link to v4: https://lore.kernel.org/r/20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org

Changes in v4:
- Track DONTCACHE dirty pages per bdi_writeback
- New benchmark for competing buffered and dontcache writers
- New benchmark replicating Jens' original 32 concurrent writer test
- Link to v3: https://lore.kernel.org/r/20260426-dontcache-v3-0-79eb37da9547@kernel.org

Changes in v3:
- Track dirty DONTCACHE pages in the VM
- Have flusher write back a proportional number of pages after DONTCACHE write
- Link to v2: https://lore.kernel.org/r/20260408-dontcache-v2-0-948dec1e756b@kernel.org

Changes in v2:
- kick flusher thread instead of initiating writeback inline
- add mechanism to run 'perf lock' around the testcases
- Link to v1: https://lore.kernel.org/r/20260401-dontcache-v1-0-1f5746fab47a@kernel.org

---
Jeff Layton (2):
      mm: track DONTCACHE dirty pages per bdi_writeback
      mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking

 fs/fs-writeback.c                | 65 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  3 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 mm/filemap.c                     | 13 +++++++-
 mm/page-writeback.c              |  6 ++++
 6 files changed, 90 insertions(+), 6 deletions(-)
---
base-commit: 7e2326f4275c11652e1fdaae11de06159fef1d90
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


