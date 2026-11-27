Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669C5606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1IJVo42
Received: by kanga.kvack.org (Postfix)
	id 100D66B05B2; Fri, 27 Nov 2026 14:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B3F6B05B3; Fri, 27 Nov 2026 14:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE26D6B05B4; Fri, 27 Nov 2026 14:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE20E6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:45:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 124AD1404B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:45:56 +0000 (UTC)
X-FDA: 85481929512.13.BB3E34B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B2E440010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:45:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1IJVo42;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808754;
	b=aS+iSwQYH7jYXqxcltdzv8K5xayKesPss9sSJhvBy0YAZYChGKEnIIBDo8pNEB+G4fNGAS
	7+yzdYclI4ni/8GBMEicu6+4zhXDXVaxur2TnP/0sDtiHVmk8ozwapTPP9HtEero75ADHS
	PL4LUXn7oeGGev6w2FVMp59wF2ZZtxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ccqqo8bkY7xL+HYcO0JWuLLFtKCJUhxP0ky2YEXw5Wc=;
	b=l9NsfYsvrafyXDfxGHSaDnDs1DAgljbh1NLBmPiRBAhDlbAwSVengsq5p1x8apjV1tP591
	/emCRvCGyuuGMdR4dgJRqWrrpQAZvbZkLLowAiosXhKBLrRqyd9lWAMMvdZpSKCRYeyARD
	3Jc0BI7QNGrCcjCJp6uf2sABJjE5Eus=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1IJVo42;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B0B8611D7;
	Fri, 27 Nov 2026 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E441F00898;
	Fri, 27 Nov 2026 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795808752;
	bh=Ccqqo8bkY7xL+HYcO0JWuLLFtKCJUhxP0ky2YEXw5Wc=;
	h=From:Subject:Date:To:Cc;
	b=U1IJVo42+yjUoLPOMPFgOCbISQ+dYclpD5Wc8wo+oDtr3dO/WJ0X5NJGF6QfhT5zC
	 afVN8BrYB2sSCkOLwhh6NVXWXeNFW9uj8RepxTvndcHK+8bTDEAB5hEIKKjE/lVW0D
	 NfoV6+saJtZsP/ssWkugYBjUH6nmTB2iXjgZzJIF/m295J0HQ+vwvUxOI/xifuNzsT
	 YRkRvKMFg004fYOQNepBRYO0icOTiiJyimCc6Sbl5zqFATngKBNAoObE6KKxCRZW8X
	 UAxa9ZacZGlg4NI2y18B/hYfUEL0eUCMIJe0J+Ln5SN1X3aSHIfMLdUXaP48MDKir/
	 z9IOtQ4GVGyFA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/4] mm: AI-generated fixes for coda, madvise, mprotect and
 PAGEMAP_SCAN
Date: Fri, 27 Nov 2026 19:45:39 +0000
Message-Id: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3JQQqDMBAF0KsMs3agyaLFXKV0kcSfOtgYyYgUx
 LsX+rbvZENXGAc6ueNQ07ZyIDcQ5zmub4hOHIj9zd+d8w+pn5YXqXE61CB1621H3iWqFP3CBAU
 plZgwjpkH4q3jHxzo+bquHzj3+N9xAAAA
X-Change-ID: 20261127-mlock-madvise-mprotect-ai-fixes-efebbfabe99c
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Hugh Dickins <hughd@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
 Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
 Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1860; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aeycByJuRD6O/7hAo/Q3yNzTpVZuppfVH7qRNkz4Ftk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5777YO2/KyWkxJqtOXjlWKXDuh/yZT2k1C7boac97V
 as+89ftjR2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYSPAsRoYHQa4OVmuFvZn0
 /19aL/LFm2f2mwfX2xfJzV+3apHTozV7Gf6nt08vEvR/eG1pxdxnq7SsRVZEabRkrzRtifyakB0
 TacAOAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B2E440010
X-Stat-Signature: gmxexurqx9mjforufutjdwxxkm9xnufk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795808754-464193
X-HE-Meta: U2FsdGVkX18wJvhd+nlF3SLnUmpLgqMIMccNdOsolShihQ5lbIFksAsrfF1qUtnh+YjCMj43dyWOuTK5kbuL3E8U3yfZpvzNw+c02yIxkefJEREb8DxyFrPK4l/rqdre/HNt/3HaMIh4dBb1e7p9DlQ3vMD8dnUuSkT9N68MYKk1eiVIfKQNoFOdjjMToGT8ljFlYsWSFIrONFarJUcq1KLhU1r/ZZ/CPCxi2pLZ1RSyILQOgZtcDLLts3dIZJX6Qclpap6fop+TMpYAE3bpm+VWxKlIRx+qbGu1aMBky/PDFMhV7uwwA1AtIhRfzmWmmcJMhdsZSTbNnttBdukOcmnjXXGSCV71Zqu5K6I46vl/RLEGuOmBrr5+5wNpPhojRH8X7eTW8vAQw8BiIhWVy4/bMkRiFhEuUG2BzBYaJCD+/FIt6QbiRXj8fsW9yeW1IMCySnbciega/bSbrLq5897+0W71Xll0ZymKohozpxxkHHZpP4O3H9s5zWBcSQLjSsSHYUQ7axcjQIvwdJ4x90qvnY80ROOV0c85wlYpZy0GE0D4o/RZcZTJX8uZFrrJDe+jEDWfmvW1CuHvrMVubLOhENbVG4g6/14LVqbuzoiHLcbW5U5CKGxRFUiln8k1od8Pyr/txSII1LPTFyYN9GeJBqo2dtxPnDJnXT12WrOKLaO1iEl6D6bnkeupwaVp0Yr9/hqPEeeLx59S6PrN5nDVQdjZODpWEkNnrWQ1NaKeroab0nB1BSOJbDFGB77+RjtaslzkacCT6OJ++2uw2pNehCh/zMm4n5B5zU5vL0C2YqeDo2HF0GlviyHnwaLk28i/zU/jLfoMUKP/SF+iShvXD4evEMCRXzBDteZVTAqp0p4YOHE7ztyuwawsmX4uXs1LyeH8l7wyP/G5i4o+PnAc4OQT5kdr0Z5QyUVmq8DKHWwMF53ZTvMTa0BdA/K4kWtzrWagPg0RUNf9ZZp
 4ByOB+qy
 wyeKxNcQxZykrLl7/IrwHAVbCdl2bYIupEffyjYmMTAzXwGmGPB4tmQ8BBhs1TDaHt/e7Re24q3u4cjSz06gRj6q5iy4K0Tv6PeTOrjsdautbrvoWtfivyS6hgVmyqdT8OIUFBAcbGy2mC5MzgSja79tZskw9t9Nw2W+5R3sQJs/Y0unZgqUeivsm9Wjnq1WRqmiDgjMqiUlcnSvcvrkE3Ju2NUe2D2RmubE2TSyhEMAFfeaMczAZZcp3p1yarmBve/mSxy9nS64DBnTuLWs/EMR232K3qbSMZbpAv8i8P1c3o7yqq3tKumx2kKTc+pdRX58XjOtYv7fL3I7C9EMXvFvgF1g72T1VsttyiEgSzJsVJwx+MXYcwCZTWDPJQqpAME6se3tCwg7M8XblFqrM6/CwgdmoPQ6yQbNJ6x5CacUsbqgdv7Uc5CkJdb3D/zcaRWaNTWz3kv0fOcwcowhaBNKy54Z1PUdQC+qGUqWTOfM7Gf9XtRx2bUdcbzLig2mQ0rebprhiC68fXI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The usual stuff - glorious gifts of AI goodness transmuted into a smoother
form by your's truly.

Please check for any insanity. OK wait, let me clarify - in the patches.

The only one that needs a backport is the first coda fixup, whereupon, in
the unlikely scenario of a container manager doing something rather silly,
we might end up with a dangling pointer.

Whilst unlikely, that one might be worth sending out sooner rather than
later.

The rest are the usual edge case stuff, one involving the truly cursed
'guess what it's possible to map at address 0 if you're crazy enough!' type
thing.

I shan't talk about the evils contained in the last patch. PAGEMAP_SCAN
deep inside your soul ye masses to find salvation from PM_SCAN_WP_MATCHING!

Anyway, as usual, please review! Thanks.

(Also note that a lack of Cc: stable is not a mistake, rather it means that
 I think the fix doesn't warrant any back port shenanigans.)

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Chris Mason (2):
      mm/madvise: don't declare OOM for MADV_WILLNEED swapin
      mm/mprotect: fix unpaired notifier start at address 0

Lorenzo Stoakes (ARM) (2):
      coda: never point a file's f_mapping at a container's mapping
      fs/proc/task_mmu: write-protect only with ptrace attach

 Documentation/admin-guide/mm/pagemap.rst |  4 ++-
 fs/coda/file.c                           | 14 +++++++++-
 fs/proc/task_mmu.c                       | 47 ++++++++++++++++++++++++++++----
 mm/madvise.c                             | 19 +++++++++----
 mm/mprotect.c                            |  8 +++---
 5 files changed, 75 insertions(+), 17 deletions(-)
---
base-commit: c6f53520f32302ea64cbcfd7cc25a31081e34548
change-id: 20261127-mlock-madvise-mprotect-ai-fixes-efebbfabe99c

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


