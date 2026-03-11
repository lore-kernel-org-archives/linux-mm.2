Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7598F1125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC916B0005; Wed, 11 Mar 2026 13:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A926B0089; Wed, 11 Mar 2026 13:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9914C6B008A; Wed, 11 Mar 2026 13:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8719A6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:25:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 300FA1B747A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:25:58 +0000 (UTC)
X-FDA: 84534459996.25.41F4AF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A7D611C0007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:25:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPLPa2CU;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BJFe0x//KxSzwLsu3xStya7OhlWi59dNRqczuhy856s=;
	b=0HxSosEir3khMrW/k19u8KKPf/Oy9wx7NwU6iuIDmnoVbIVywUBpvj9EzGI+bBCwDMi5Ls
	BZSualK8ZoC3LpCl852NXcXMpMXA/T/jjoFXS6itW8wKUpoibcgnPoweMDkqs6f3HGeqor
	ymL1G0avpqNxLLLz7cYaqFxUVCDFFvk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPLPa2CU;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249956; a=rsa-sha256;
	cv=none;
	b=wyYHi6ukDceVLNrYmGbQoHfINYi1Tt5WORCt8r6yleCqb95zHIqqyuLtQJ0cll7YRsFEiO
	IKVU70nuMhkHsMWrMMZ+KkDzShGxwjR30u6OhzQryMOLs11lbylr/TwsK/kYtX3HnQNeMj
	9Lp+JGQ/WueC0p2GDtubjpCdhNOo04U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A9F960142;
	Wed, 11 Mar 2026 17:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5183BC4CEF7;
	Wed, 11 Mar 2026 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249955;
	bh=aUye9KyAnijpM8t7yxcnEfZ0jMtzTOhR9HCsDeyezjc=;
	h=From:To:Cc:Subject:Date:From;
	b=KPLPa2CUmTcJ/Xw/KOnEKshZF90ialrN0hcYgGIHwwPmnG2WGPys4IwEaqv4HMYRP
	 rQ6CIc9ptLaXS/hYCQ2XygZzluExwhRygmY12nXriHv8p1DcNkhW5ti799gmA65dnd
	 KENAG2CeJPzUGE7mSbe6Jo1yO17mZQv2cHTyYeLkbTZChwBlEOjVV1XiCrgOtfNxL7
	 7Fnb7Mxl3ypSh3jyCq22Kw3IyyZ/OnjwjPvKCwmcWt8rzgDoskQ+u3n0+pP+WR8HLm
	 I1snb6c4rVJ5zSh8HOp8b8Xp1s2ZeaN5i2LV8Gb2OdDlHR2aJIT7b9OE2Y7VKJ8R1y
	 kdnWdbkYa7hIg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jianzhou Zhao <luckd0g@163.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 0/3] mm: improve map count checks
Date: Wed, 11 Mar 2026 17:24:35 +0000
Message-ID: <cover.1773249037.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7D611C0007
X-Stat-Signature: r9j373774upbno56a6qwwmuwuy931a99
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773249956-332337
X-HE-Meta: U2FsdGVkX1+ojYpYvaMtVzfhARRCKIXjzKoGGaxsDggTHXvD2hAi4z/sWbiLgeFBLRR3o4GBwDeQST+BbnXlJ/v7MCdCa41jKoCU1IgwlGfUjAbLD17mgZ0r5g0pcBBQfnyRBngZxnackVYAvThEs/xUbsarXY1+kdlVouVLLT2WEnYxCm/QdSXzlixmPyv/j7VCL9KRCbxpgx4URUVbmespa/w2IM2akJLezGDN7fFog31hecZwKJJPwSgt2xBa67WE2lMk0XWDQiNe3KCh2pNcfDoKa9vtf9E3Qtw7W7v4mG0MfAPccm2H7Gm06/vGCmBaCLkmEyfY7xUV4RXSyc2aTL10unQjVz9o7Qh/Opmvbe2ea2TA3C8wJDj8tMpFVhFQ+7FATqbPZjKmfIplQaTPIkC3QeBHgJ5eOqCM7wMelbIwEM+Qc83hq1FDq1C/72CcWidI8CjRLsvpULzEUkZ3IX05L0PvN085c9aV9BaTF+KgePjh8P6u1fTBm3U3mfifBqlMITwMACpyLOhq9T0beOCAujl1h9WbpVqv/fu+lBmHGB5SBXpPEXtPCYWCBkXTfaJed0wg0aKVcUmQXcRKXKC1qvm/wAw/TtG/cILOUdngmUoN2FpdiD3tLIOCmAPqL2QTQzhbyFydDbeq4hIpoQKMkpQyfvvr522xgh80TwiNGIVjqsV4Z5/58dC3dkG9yRN9h/FgXfBXqsit7ZOoegr1TStEuhotz0qqAh7UFs9IuH09r+pc+LGoGkbFueoI0jk1h4Y56YINbJ6vALgOIkqA62SeOIFPurTgoXhgGAbUhKRZyA4Sw0Hkis7hffa3kQyhUwrsROLFi6Rc/+b2krMUPuFn96WwFl7bImc9oqPFbTX7bzgo0IF2puTQkcwfAfU2oJQG5h+5//ToTK44UU9xpAN2Ewj0bBhzdSPVtVCvQ1OE6QYJLUCAO/nBF7RldiPqFNc6QtFhF6D
 pcitih50
 fV7JXqP0US39KJkA+lcBM5npo9iKNa6RhV29uJschJWtNBsWDU9dhEAa1v2x3N7Q2n5IuEtkQn7e8xwtzPY+Y/ZjqZ0AKnEvKMVOLCHvub5yDHCo8DtZ9ofsB8vW55OPyLGuZ/1pVE0n+eZeXUd9f7tGjkges52x25MU4f3fAennhYMRhu7o2F/h1Gko9IToWkyqA5xn7CvbYsnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Firstly, in mremap(), it appears that our map count checks have been overly
conservative - there is simply no reason to require that we have headroom
of 4 mappings prior to moving the VMA, we only need headroom of 2 VMAs
since commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()").

Likely the original headroom of 4 mappings was a mistake, and 3 was
actually intended.

Next, we access sysctl_max_map_count in a number of places without being
all that careful about how we do so.

We introduces a simple helper that READ_ONCE()'s the field
(get_sysctl_max_map_count()) to ensure that the field is accessed
correctly. The WRITE_ONCE() side is already handled by the sysctl procfs
code in proc_int_conv().

We also move this field to internal.h as there's no reason for anybody else
to access it outside of mm. Unfortunately we have to maintain the extern
variable, as mmap.c implements the procfs code.

Finally, we are accessing current->mm->map_count without holding the mmap
write lock, which is also not correct, so this series ensures the lock is
head before we access it.

We also abstract the check to a helper function, and add ASCII diagrams to
explain why we're doing what we're doing.

Lorenzo Stoakes (Oracle) (3):
  mm/mremap: correct invalid map count check
  mm: abstract reading sysctl_max_map_count, and READ_ONCE()
  mm/mremap: check map count under mmap write lock and abstract

 include/linux/mm.h                 |  2 -
 mm/internal.h                      |  6 ++
 mm/mmap.c                          |  2 +-
 mm/mremap.c                        | 98 ++++++++++++++++++++++++------
 mm/nommu.c                         |  2 +-
 mm/vma.c                           |  6 +-
 tools/testing/vma/include/custom.h |  3 -
 tools/testing/vma/include/dup.h    |  9 +++
 tools/testing/vma/main.c           |  2 +
 9 files changed, 100 insertions(+), 30 deletions(-)

--
2.53.0

