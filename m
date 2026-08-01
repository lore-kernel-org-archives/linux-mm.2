Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3693CC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26E96B007B; Sat,  1 Aug 2026 08:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0006B0088; Sat,  1 Aug 2026 08:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8770F6B008A; Sat,  1 Aug 2026 08:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62F4D6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:25:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57943A140B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:41 +0000 (UTC)
X-FDA: 85052621682.14.FA62457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B511740004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="grZG658/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PD2Ei2+8ZcRVLYaWR53BggaFC4sYxGX7KYSUUWTxUwY=;
	b=ATS0Csgj4wAczqza4wdzXYQcQ+k1Ak43ODDJ9dD0nYyxvSR5Zyxkf40FYQRu0Wpib/CXX0
	jMGoPsRJN8QyX0Em0Sryv2aRC7dNYZkaRQm4zzKd6TQjN5mKE20kJV3hnDE89aqcy4XAnE
	BBsq1juAhZyCgGZD/2gwJ0mD4AXk1Wk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="grZG658/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587139;
	b=cXAY/xG3BbCviPVuzULQ/6yzSMo2vpqxhoPiM/TtqNQgG9Ifnnw2eCQ69jXumsN2tOjbzt
	KOLjnRw7Xi3lJEWhV+AWjEgJxa6iK9ukeQZKQsFDX1SuKv3nzCN8IO3RQsJQ4Dmnz88NtR
	wZtWPreEy6vI5luFDbvycFLZSmUof6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F22643587;
	Sat,  1 Aug 2026 12:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1291F00AC4;
	Sat,  1 Aug 2026 12:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785587138;
	bh=PD2Ei2+8ZcRVLYaWR53BggaFC4sYxGX7KYSUUWTxUwY=;
	h=From:To:Cc:Subject:Date;
	b=grZG658/Jsc0+VSH9kZVTG/rifLiIzTDCAM6GXUdikVf+U91KKt8zBWiG1SZaspJT
	 rQ5e3K5kOj2T8PMJbEaW1Ym/LYsdrW2/TMtyuFPDKCjJawxwEnb5pISycvHb7m8KEY
	 nAWff0bRo+H6a7W6/rNr3fTl5pqEwW2+Lur4osJWFPRz4uYtX4Wv7LmMc1qfeTlnf9
	 /Mb2JO67/jtHUikhKxDcjjFDKwLM4Pod4S4rLXL069dCMXLCQzLY+tKLlXdcLcIGuc
	 CoApczKR8kMa1XgVyQRC/ypbjpUJhnf6PA/YwOGeTJ3vpXr7ihyE0XY1k1GJ6Ydfzm
	 2LnFsaq0rKDnQ==
From: Harry Yoo <harry@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [7.1.y 0/3] mm/slab: fix unbounded recursion in free path with memalloc profiling 
Date: Sat,  1 Aug 2026 12:25:30 +0000
Message-ID: <20260801122533.319272-1-harry@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B511740004
X-Rspamd-Server: rspam01
X-Stat-Signature: 1dckjtyxpqbxf3jddwcd51zdghbr63eq
X-HE-Tag: 1785587139-423846
X-HE-Meta: U2FsdGVkX1/JBicb3FLV7341ZZTK3xLzWkdk0iE0rD5rwp+QUpV3nY65H+BXYQ0bUbBOGwrPWqacFJtVJvmA/X2Qg39DP9i7C/kyiTg9HZ2WXs3Vn3ePC9cnh0m8azqxGQIZFw+UQ709E3t4IsgioNnkeyLiCgf9tNjx2O/bLhj4V8JO9tlRNKkz2/AzflegsuTa9E9iIQwhfhiLh30clorTSQIW5pCTmEaF2NY6FjN11VIhfkHMeke3HrqD0joLcMDQ/jl1Eaes695EFu4gYBelDR6pr4ApRN6317TW+LMaJUtefJttcLMtbg26JmmKudxRZrz1IYVB/+AGQvyOjHZcMWHcji9lxDEnJm0FnaKlb5a9oW2eNP5RqIBf4SvhC6tvHLUprVQC8sRLp3HdkdEg4dEjD1pxkh2PM6BJVGvbYYQAdU8ZjeqfXE29BNeb+Z0tkYJVmGj9kJwTIPKYzs+5RgAvhb9NzSKvtyKOJK/PHynyet4EEpmhcnjT8S01othD3S0iC8F/v+G2xj3ZOi7pnduz7nGUJgMOOEo8e1xTzz0eOn/IMLVJufeXETktklW2jYIjgDdL7DyRt35drNnkXjOJC4AQ6z3C/4qazrt8WkS7thzu6H922ZmFfFeEsH95w+PCD+nkfWHY9iRyDCdn1iCLzZBOAY+OAUzJinsSSmNL7eM4gtVY7Kuut4+7rB3b+BpGYbcgaq3DWXHdRYzxkiaAXHRlKhLhtshujQzXwrmdNBbRLm5R9ziPL2R093oub4Jvd3MM9Pz6/7C47+zUwwda6amoAF5BozLT2SK8YQcpe0zivoS3k3VW1uwj1GixLZN9sxZhinAkI1uAQXCsq+nqX29J5hKniN7p4JdOrSBrQwfTRfkNXOX17AbQDxOStLjKOaE9riM+5SgyxrM68PcBv7jEJyyKoBBzgTs/EYUZ06gQr/O6M3qaqfiulzDlL3gkOyFhZ7PNvkI
 jv3ZGr4m
 nLaXakzXmytppNZ3ao3P2DBi+2vINv9dyVE5ZCcN/o9mGS82wjIZjc+5LViw7uHIfXAF1gaqOE45CVc6mMAVG8+fNE77yVBs8Hxah2PNP1ZFZ6FNgajwzxiJQgLM+r14Vo+5Bq3N21iXxAK3nrHqaB9DTWdoyrCMsymbQiuDc5/PEMy1/4Iz2EnKWSTrIPcTmgaOJx9foPYgw0L4zB9av3eKCSrX6VEBF+/mYJVg4mIBFmS8sv5kB/BGVzQdFnChmExi/RVFYLUtgWR7+kOUj1yRUOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Harry Yoo" <harry@kernel.org>

This is backport of "mm/slab: fix unbounded recursion in free path with
memalloc profiling" series [1] for 7.1.

The last patch has a slight functional difference compared to mainline
due to lack of SLAB_ALLOC_* flags. I described those subtlties in the
backporting notes in detail.

[1] https://lore.kernel.org/all/20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org

Harry Yoo (Oracle) (3):
  mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
  lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
  mm/slab: prevent unbounded recursion in free path with new kmalloc
    type

 include/linux/alloc_tag.h |  3 ++
 include/linux/slab.h      | 19 +++++++-
 lib/alloc_tag.c           |  9 ++++
 mm/slab.h                 | 28 ++++++++++-
 mm/slab_common.c          | 13 ++++++
 mm/slub.c                 | 97 +++++++++++++++------------------------
 6 files changed, 104 insertions(+), 65 deletions(-)

-- 
2.53.0


