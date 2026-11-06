Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A45B606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWJXqG4g
Received: by kanga.kvack.org (Postfix)
	id D6D326B05B0; Fri,  6 Nov 2026 18:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E746B05B1; Fri,  6 Nov 2026 18:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C349E6B05B2; Fri,  6 Nov 2026 18:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95FB86B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:51:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D31A8160143
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:20 +0000 (UTC)
X-FDA: 85406343120.06.40E7F52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1662C40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TWJXqG4g;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794009079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=htFkXyUAg99+8mwg8DQwhnbl55aL2EnLvZlSJCSC81E=;
	b=IxQiJoZ5raZlj3eJW3edmxVFh5MOrJM1AfcUaHNLhjs8xwDUAQKFiO9MJWLkolmVdFnKrh
	Ntbv4rO1kH7xaBiKr6np9v8IYa6RaMo6AweySbj+CGtYNRzRWZTyI3PpRS5QQyxrpMJHh9
	ThgfV6te43vOwWWKBJKmqrjjwnJ8SEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794009079;
	b=iOcRLPb+q5Mpib6I0bNvYUV12a35ERVOKspgLEskG6NzXUD+SwyTQsfSSFugEahSFttWUT
	pVVZyp+1nXhTDh0gPTWjvPZ8+Wl28hKrk3YG2K5vznMZVkan3EIpLJRpJ0bAKYQZGkAtYz
	PdNDn0YZKebpFvX6WsDVOR3vNNZhgpg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TWJXqG4g;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E32C437AF;
	Fri,  6 Nov 2026 23:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D01F0089F;
	Fri,  6 Nov 2026 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794009078;
	bh=htFkXyUAg99+8mwg8DQwhnbl55aL2EnLvZlSJCSC81E=;
	h=From:Subject:Date:To:Cc;
	b=TWJXqG4gIBCeMZf/jPz6qGQyGhibhtlw2l6DAWV3+YLJa4wrkzZCIsrM2Hf5iKHOs
	 QTlkAGX5XF2cFmbBaHLxDihed8xcFGq7IvMkIKsYDHj5enrAiii57x3BUrI+nVkpdp
	 VOqh40QqQsDT6+1/RhnHVGmb1g2aD8dhUvAfccTmZtcfrHIywboGLqNbaQJ3EPSP3D
	 xf79xDYg4B7nJly7UqpkFrSLBz7HDP3mO6JlkJhJ01doS9hykZ+cA9e2Q6iru5ey0M
	 1IO6uOiGMDfwriPSehthK0uX5z6sUo+pOnzJ1swjWTzLCAeNH/m1ZOu33Gh4ojCbZo
	 vvikzXAmsbZCg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm/userfaultfd: prevent poison marker loss
Date: Sat, 07 Nov 2026 00:51:04 +0100
Message-Id: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOln7moC/yXMQQ6CMBBG4auQWdukbbQLrmIMgfIPDCqYGTEmh
 Ltbdfkt3tvIoAKjutpI8RKTZS4Ih4ry2M4DnPTFFH1MIfjkuqNbmfvm3uoV2twWM8eeTwk5xIx
 EpXwoWN6/6/nyt63dhPz8rmjfP5kX66B3AAAA
X-Change-ID: 20261106-b4-uffd_marker_loss-f0f56ec12ce6
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1675; i=david@kernel.org;
 h=from:subject:message-id; bh=yRPv7tjSRkmwFOuXv6HEv2HTp/IOs38MxUyLIMLVLl4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLepb9hOqd57p7K1jih09ufpB+5pN7m+uxPZWqp8u/W+
 +f+yuY96ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiK9cy/A9VP3mNb8PPqpaz
 hllHBa++/211Mb8u9Fj71X2Lmt7nno1gZDgyVy3nf9L0gmXLPy19FsM5W3ha9v2w5BvZxZkhYoc
 DN/ADAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Stat-Signature: ngmtj4kmrpr7wsdsz76oituti1xtdpr9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1662C40002
X-Rspam-User: 
X-HE-Tag: 1794009078-723663
X-HE-Meta: U2FsdGVkX19s9d3UQRS1zl4XZHUNbPo5BRFlR1KP72cZWO48j2rVEG5IhvHLfzR56dMgBTUkWIwUcz3FAxXlryrxZhnAZk7389L1Eb/9j4qQ+eg2HxWj+PY0Ip6WDFHL1NpZrovAekTDaetbfuOmTwjKab0YSgBvxKxUsR+0D/36LaUfjvOMAHCWcthlktfPHewbkVxbKtTawvTsFS64fSgDxbSJq8nn8a7BiDyftc/H7HwEHEEjuOLkjdFo8si5o0Hbe5qyHN0Ipm+Bkd+4Fxov6+w2jtUs8VIpbe8LBC+ZNIiYmoCmuEZRinHs1Vfm2kTmmhe0AYQJubmR+FjyQEKvX5BrtPjUnetIuSSU2jV28WfpFvFk4VXsGKK1k3IsGdZcSdlnNUs6GX+9k2QwV488AktMOzjei0ZJ4QdJ7We0kAO9X0adWHW0/SKiY8iFHBH7GBIG9k+754SfiIDpwx2UtzZsSFVZfiyoEUS/qVxxc90okylngWGLnZTZnOQkeTOczU3RyS1CBraURHA51bGlGGUEWx9sojSXjJTqrG0YtPcVwpr6cKMUDA+2mDggm1w3EQbvjYmrY5zO9oWT+AN2QsodxUh2McAZTId+XZzEqt8ZloGZBMZX/5QhBSBpTd1Uu7A/Ls++VDn5d+aE4x37KJ+X5AXCe24OCFiEFYjOxVp9ptrGKUggPgQW6x29cA3ZA00M65W0zgDOlFiQ5Wb7uW3lF8V+rF41snM8yuuq/hhIZO08sXIxzFklr/z3UbiL7+QXXalpJXfeQ18rFSdj1InnPvMw+XIFoL3LDWISI9fkV0AW5AOUwZfLn+BMEainx3rr8rQC/Ckm87RB9y6yEqANJs1S4TCzkXEvwYCichUVHDu2a9f3dJ16vYfPB0fbyWpURzIEUx8dlw6XXm+gKYxxwcHwAYfdbqXkYMiuzCjSmpBpA8HO27XGt+PJaNqW+e8PYrTXlVaI/3P
 2u9XiSV5
 vvXep8CTmP5o2aTyNPA1t1a5afJ2ALxNu1rBkvchHgYC/V911ezf/dDo8HYwCmn/XSvjVr6TUrpXfhjyxivQDYrLrDfY8mN/nHizEoagZ3SS4S8rXU/RGNfWvvQXB2N5aagT065bEQhXOdbDIZEi75NRlwDiYSC+lo8lpOyGOp+oR1FdtK3TV+57Mbq1jROxF1X7N8IGl2e5JxaunR9bRgSRhf0QfcodSRF3ZAx5XMcI6jKWzzejvecKT5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that Lorenzo's atomic vma flag fixes are in, we can also use it
for userfaultfd POISON markers.

In patch #1, we use a new VM_MAYBE_UFFD_POISON to remember that we had
POISON markers installed by uffd. We then use that to fix marker
handling during fork(), during hugetlb PMD table sharing, and during
retract_page_tables().

In patch #2, we perform a similar rework to retract_page_tables()[1] that
we did to try_collapse_pte_mapped_thp(), to make the code simpler and
less error-prone.

Once review finished, I will take this through core.git, where it
depends on a related try_collapse_pte_mapped_thp() cleanup/fix.

This is not urgent, just something that should be fixed properly.

[1] https://lore.kernel.org/linux-mm/20261031-fixes_core-v3-18-d6437171ecc3@kernel.org/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/userfaultfd: prevent poison marker loss
      mm/khugepaged: check for empty PTE tables before retracting

 Documentation/filesystems/proc.rst |   1 +
 fs/proc/task_mmu.c                 |   3 +
 include/linux/mm.h                 |  45 ++++++++-----
 include/linux/userfaultfd_k.h      |   7 ++-
 include/trace/events/mmflags.h     |   9 ++-
 mm/Kconfig                         |   1 +
 mm/khugepaged.c                    | 126 +++++++++++++------------------------
 mm/userfaultfd.c                   |   3 +
 tools/testing/vma/include/dup.h    |  20 ++++--
 9 files changed, 110 insertions(+), 105 deletions(-)

---

base-commit: df3c65887715e66e2cba69116924020c37996cd8

change-id: 20261106-b4-uffd_marker_loss-f0f56ec12ce6

--

Cheers,

David


