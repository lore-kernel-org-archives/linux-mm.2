Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB39DC87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 00:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8516B007B; Tue, 29 Jul 2025 20:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198236B0089; Tue, 29 Jul 2025 20:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086896B008A; Tue, 29 Jul 2025 20:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E49526B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:58:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E6031D9914
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:31 +0000 (UTC)
X-FDA: 83719120422.07.8F7CFC3
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 942F440005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sD8s8UFD;
	spf=pass (imf12.hostedemail.com: domain of 3NG6JaA4KCIEnxffhrfsofwwjxlttlqj.htrqnsz2-rrp0fhp.twl@flex--isaacmanjarres.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3NG6JaA4KCIEnxffhrfsofwwjxlttlqj.htrqnsz2-rrp0fhp.twl@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753837109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BvzOHnKibLB3ltRouRfCtD2c5Lgi+zp48cQKPXu7/xE=;
	b=POvJpxrDBdZxphRZiZiY/BdvDyc5vZSF0K50LkNCnc9BfhZTCaNwnsL5g980aFTkKzeLpf
	5TUogOQVgci7NegwFLwovjGSETqX58TYq/eYn0hj3S1bfIhHVVxguru0r6rkgj03DH9P4L
	tgaURdnL3rLoEDY6yufyzMkPboqBdmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753837109; a=rsa-sha256;
	cv=none;
	b=XktFZaVSffw7MBdn2w/7l1DQJYJp0WzCYnzM58WObxFbqt4PNf6vlAtiDVmF1JAws3RtPf
	GIDoukHbqCVRLFawfuNON2IJ+SLiXB/+BgfQFK5/D5Wn2s/d7j2nlTNAI6m86pCHVtI6ML
	uWR14oqRz/oYTYeL26X18xQGwCieDjM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sD8s8UFD;
	spf=pass (imf12.hostedemail.com: domain of 3NG6JaA4KCIEnxffhrfsofwwjxlttlqj.htrqnsz2-rrp0fhp.twl@flex--isaacmanjarres.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3NG6JaA4KCIEnxffhrfsofwwjxlttlqj.htrqnsz2-rrp0fhp.twl@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23ff6e5c131so3253465ad.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753837108; x=1754441908; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BvzOHnKibLB3ltRouRfCtD2c5Lgi+zp48cQKPXu7/xE=;
        b=sD8s8UFD7ZtyQ0/tFLPXZT1SQcNImVxNXWSd+e7WdYdpO6m9Ap90728K9VFgCVqtT7
         NK3rYz6nySZdBgxGx3t4cxPDKfHJ8bfNWW0OwCx9R28CGDmQQjx9VG6YQzipmaG4q3NX
         FuI1csIHO5rpqiTcTrxmwJ9LJ7wfiNQpU2mhTaVyK183dM98sNluBNcNdi3RBRKQ0gWY
         K7EUQHjBIJi84+tDeoXsIHuwNBy4KC8Rmy3HIuR9DcMsYQ1Yo1EEIS6sF9RjygFQQRHF
         Hw4XEQNk02oIg5md3cihId5R7F6JYsPP101x8dJgf9iAsCZyBMt9sCVDjLXl5faR59to
         dyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753837108; x=1754441908;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BvzOHnKibLB3ltRouRfCtD2c5Lgi+zp48cQKPXu7/xE=;
        b=wkhLTLEVKa/dajOhuPptZ9wMjgzYnxBBlXCprpNzSVkZnTKy9Kk0I+GTaZku7jT1d6
         1Fn+MgGvnBeaXuhfvcEK3kDt+jZSiKPrlksvAW3ExkPLD7DvyTaZf8liUReJIGD9JXdD
         Yb5dFybdFrb9JS2IEzZBzgwwu4iGmffj1TBfcnml86k3k0xl6U0emAzOcwJ8pkTFitVc
         Pboz+1zMiB3ZEMuRKTXE9rGTfQhjLeT1UaNsG/pGaiZil7wCDAvSE56yEXQLJwwK3L7s
         bRYWiEqGUdeHd+OrPDQzH7rV1EKyngeYdXa5JBR4FrcdB8rhgY0y6+/wHUq7ibjDbw3L
         8wsA==
X-Forwarded-Encrypted: i=1; AJvYcCV4opSrd6fRkYJK2hln9BGZhLybMH0M1g19TT94XGIvZp1w8k4XntX6vHECa2YAGJk+mY9ba6wOfw==@kvack.org
X-Gm-Message-State: AOJu0Yw6Q+u7wWVmoPyOb3K3dk+j6kdbwzyfggXyxae1UeUc13Vd6LBc
	cLicbuwzrBidW2wSV33BlLlzbPAu3fx2doxhh0IVDZzppOJwnsG0gbRVI+MZf+dlG6a5ZvsPZ8X
	HPbj1K/tIkCNrazr8gcOoRHksr9BUTjRpweYNMw==
X-Google-Smtp-Source: AGHT+IEE1T/Er3sKrygau3w97VIOA/QCJAiAB2wozTO9pbOU/DTR6qrzKjpzklTM5AEwRfki5E7dO/OqrMcPg2dtONxW4w==
X-Received: from pjbsz11.prod.google.com ([2002:a17:90b:2d4b:b0:315:b7f8:7ff])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f145:b0:240:721e:a406 with SMTP id d9443c01a7336-24096b06962mr15696795ad.35.1753837108130;
 Tue, 29 Jul 2025 17:58:28 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:58:05 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730005818.2793577-1-isaacmanjarres@google.com>
Subject: [PATCH 5.4.y 0/3] Backport series: "permit write-sealed memfd
 read-only shared mappings"
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 942F440005
X-Stat-Signature: y8rf36rgoydidw5yc1oowgk4qwzsqj3u
X-Rspam-User: 
X-HE-Tag: 1753837109-375909
X-HE-Meta: U2FsdGVkX1+9feLc9cz0u+7dDdBgROJNY427PKgXmD0qgUUoF7eLKbqUGOlRyN/jB1bG8UWM+X3J6RlsPZWHvbe4+U5ZE2v7Bmck3OK3zoa6xd+0H9miiBYxtwPJZSdl1azIPQS1IilQx/zpm9fyo7Re/wyf7euLanRsIDb7Q3ktVwQT4UtuM6J+JdiS6w944IibRyvXeomFFTDZC//A4AXFm9Sz2cuKAefK51bbVnre6b1zMywBYJwRgeBD8ZGn0B1ArRZztg2XoXElsMl+NzFNhxrc7uNX2ozSnJdc8fxg5JI64WIhHAuMZJqAcMMBsUn+I3+KCmnKlSIQ/SawA/m/2GkFgtzHYhuKpxDjafjJmailQVu65Dw8oMyLI1j3dW+ptHXFcNLIc2MSz5SivehgIsvBC7IiF+RYysLSM/tH2SmBrT+9k1nsAOVcLieA/ux9XJKrdFgWOQITArWrIM741MLrakfZCOoktSCXmX6JTVzgwa6s0Gcm360pK7PhvwS3JYjp19LvU0iBCZgFxnWf2lhNHkeY2n65qkrt8uTMOgf6zgT/PtbtekhZGrvOoW/2kN7e5qb3992vb+Zcdl7yIWfMiup+qYs7SQv5cNEuLCkuEkxiAH0xNUpVQGd+MxS/7QmbJHjvujPk2jfqZjPzAAOX9SC9nmKDvFP0guXJ6/H1mFQUVVRRLzlZG7BtoIi51L7JeltkNAhZUnbKNfL+pjlHjODoTUj6ZeJ+pOMXTnBgUqFnpnPNc4fJ9aI1nb+OCUU+AhFrG439Ntu4nidZf1/K2cBuaadbnU6s4CbF39zJpYaH0rICa3DT5rMS742l5v0nGA+BYiTxBtM8KjcWMb+luI8kty9wZ/327WMtqjifQee2UPag4juoebMTWUm1xty1xVwGlAOB/VIKokA+sV25DNWAxOO8hKRJ6miPv1ZRiPQpt0i3r5kJl2BbYKv5S6Ecd93Mt5LZRFo
 l4uNe38v
 bJ57CpSY2AGJKG+vXPiN1krBA8NGZFbg50L3yreyQU24t/FyM0KQr7zvyR6+4Q/WLqUR0PZba/I3ddnFzxQleOAkypQR8sS9ZUNX4p8RRrmBWwPHf23e2DjZe4aox1TzAvKIfxDePX0XdbPavY9aYUMRxFDGnqvLfgp6YBafsu77FtTB6szEvjWVSYB3cBAOIfRIkD4SL03Tfpidqb1EwPohr18uCwZsBCeueK0fmxoViasBJItIpqwYM7kwuR7o5IgMevkwVps696IaFYf7XModOYuBObqxJZmztXAq2wynqlMKS9EbjOpe2ASsC45LmseGtLdC2s4m+hEDzdzQ09PE2LKSAcp8+82N8KWrenxzrZ5wAulTRGGRjnj1ZldPa3Hw/SAzHd9rFWRo+xy8saRKlQYf7JwmsJWutx4zm2U3mtAadBygCVL7OwOS1dIllgNtEnePSy6l1ky4DTS4Msk+hIL5UEIWSFlG+vP8eji9Sp/oDymIMlhNvVUafiALK0D/lseOcimtfLSq3xDbjKCXrq1VOSbe+8MVAU1mdE89vkw6U9/dogUrpjEuhOWWowwo1ZZM36odMYCMLcM0U7EOtNzaIJUGn9ZTow2a0+cTBeOw9eJxaQrItvJJPuF3r7lQ4D2gHNdTDldE0RNgu+PNxCZI3/xI/c2KYB21lYBphXtCPgCL3nSRgccptfwYTVMAtEebJss2CAx6+tgoZGyh/fPWf2ePGWbCCyFF8DROmKjJK1ZGVVuJh3NFU8PdBDbfCWii7+mPn5euUqh1eE2AOVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Until kernel version 6.7, a write-sealed memfd could not be mapped as
shared and read-only. This was clearly a bug, and was not inline with
the description of F_SEAL_WRITE in the man page for fcntl()[1].

Lorenzo's series [2] fixed that issue and was merged in kernel version
6.7, but was not backported to older kernels. So, this issue is still
present on kernels 5.4, 5.10, 5.15, 6.1, and 6.6.

This series backports Lorenzo's series to the 5.4 kernel.

[1] https://man7.org/linux/man-pages/man2/fcntl.2.html
[2] https://lore.kernel.org/all/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com/T/#m28fbfb0d5727e5693e54a7fb2e0c9ac30e95eca5

Lorenzo Stoakes (3):
  mm: drop the assumption that VM_SHARED always implies writable
  mm: update memfd seal write check to include F_SEAL_WRITE
  mm: perform the mapping_map_writable() check after call_mmap()

 fs/hugetlbfs/inode.c |  2 +-
 include/linux/fs.h   |  4 ++--
 include/linux/mm.h   | 26 +++++++++++++++++++-------
 kernel/fork.c        |  2 +-
 mm/filemap.c         |  2 +-
 mm/madvise.c         |  2 +-
 mm/mmap.c            | 26 ++++++++++++++++----------
 mm/shmem.c           |  2 +-
 8 files changed, 42 insertions(+), 24 deletions(-)

-- 
2.50.1.552.g942d659e1b-goog


