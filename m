Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B955606A68E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E6F51KPP
Received: by kanga.kvack.org (Postfix)
	id 17D786B05B6; Sat, 28 Nov 2026 01:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107D96B05B7; Sat, 28 Nov 2026 01:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38CA6B05B8; Sat, 28 Nov 2026 01:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FB86B05B6
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53CE91A05B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:04 +0000 (UTC)
X-FDA: 85483608168.30.C76FF33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0C91100002
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E6F51KPP;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848723;
	b=NgAI3mI13nqPzQPFfaBlqshlvlacp7YZ5y92rQDysVGOIc/zbEHyEozDhMItxltYzTNqEn
	WSU/QixZKTGIvpCbquAVg1cJeVimjV96ejsJBLijFyuXGH+uq5178Ofpe1vUAgM+phgNVH
	HcKPWeQ51nn/k69l+ZzOIKsfottdpUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=+ygcF74eE9l0FKuFG7U4RE2ooBLeTPEzUBCXgX2+lAY=;
	b=MdkaGVjKPWItHbsW4Z3K/WVlRQrgHlodmzlPJqliOh2OByGf10d0QYkGAdq7qbPcrSU5YD
	tow3C/ryKqG90I6kH42HKclNtFUu4tauPFveccUMm9BNaCKytZY0b6eLmZlQK0lYgtzYom
	pE64rlTmTnG4PXkCaegNLDBRVjCw/gc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E6F51KPP;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44FC944641;
	Sat, 28 Nov 2026 06:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181831F000C1;
	Sat, 28 Nov 2026 06:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848722;
	bh=+ygcF74eE9l0FKuFG7U4RE2ooBLeTPEzUBCXgX2+lAY=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=E6F51KPPdACnsTwFDZB5MePL6vhfkbUhiJ4c+jHVn/oX1/zJ70QO+bnGINZqYMply
	 DZuOI1ovSIP4XvSKMBAvlc03MUY8Y3NqTxyN87KSvES1R6BCH0JRUOUXjNBdv2Zk5A
	 3qiqK9ON5cZ/pw8DVhbDVHBWs4loQTTwxIiFbxto=
Date: Fri, 27 Nov 2026 22:52:01 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Amir Goldstein <amir73il@gmail.com>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.3@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 3/9] selftests/mm/memory-failure: skip poisoned dirty page-cache on NILFS2
X-Rspamd-Queue-Id: D0C91100002
X-Stat-Signature: xkbbbkhibf575dqe7dfp8ra6eutyzekr
X-Rspam-User:
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795848722-227771
X-HE-Meta: U2FsdGVkX1/b+bybVqb1KMJOJNvXOI31+pzfVl0TsPO9BtWR7Cti5dV/N7r3PppBGgYo6cPQZ2NqzpJK6qmhi2tXWrwlZ07Y2XhSN184iDxOxwh815xeOIjBFMRl7Lroo3V3tYFpAk2ssFVL79muvxrXIVg6AcchuYMFDhj2zFHSaqEOOyYUj4U/nYAVbuZsd5tcJ0ZCzPfxGTwoHbWXoWoSl5uPdlV3XH/UjsFWX3irWk2xPB7m/kjd5BdS0WYz8x5W3LAhx7peHtyfM0/Y1iUGvMDrZ1Ly0fS+O179mmj+wHZ30EPcdANzF4BDz37RvJdn3On2j+wVE28sGBPpXVZ+TieI0uYTF4UqO7ROEgeUFvNdnHwsH3K3jFvdXGx7Wgiw94zwd2IXr6Ah3lNrKQ3JIMJ9t1FWkRe28c6fGTDOEsmu4lRLDTi31KIZOfxarm4sJyQyiUcKs7JvbnbHtsShYeCi2FOYS60gHYFPNE3PR7g86J6f2PsPUzeN9vPpqduygZwSWI0J/ha2c+DRtC5Rz4twGuTXORYh3TrpA1j+hseI9mDz43Zax4bLT8vx7kbKUXOSqx9oy3aIvoxnC665RqKY6hynHafiW1ZrTzbuYdKxuDsCmPN/qNAN3buyZ2Y4bkKpB8bkxRbx3lr1xFcB/OZSDOF2XnMKGExhltnEoTtgCKeQVTU4UEm+EgpWW/Jd50SJqoaYiyg5CTWExTDZmXf1kQ+RG4a9/cZgo4aoOrU0LCRmFaNmAmrrmO6p2oqbwENBEPbZx/LXM3zKOppDyhVc6gpQLcrqpAATGqaXD+hX/4sz36ccij0+vAlDBSjNcyU4od187T5yVK/xwiT9A13H7qNNW9JxL7ZphJJKOhyHnExlF/kcUoQbMuGhFekITp01EA+S4jQ+efkvgCKWChRpXzum20lUxjMNXfLqL0Rqc9KKlKYvYLpcq95vYh7vHkj7DbpOamhIr+9
 tjPKQBaC
 9l/yAOV6AxUQcTXATRsA1t9RD+mBZlq1ApGX4tdIteRGhO42nctHPumYu4aRvpuqZaRKQt5iB++FQfw9K5FbSh4jOK4STnpzWTspZHpW7oovSnEhFniz6qtP9ZUXl5wsOFy21oxAS4mE84M6gYpRtHDZFGJmaA3UXUnMMufKExf3lhwiWtJA8UvXOvDTt0lcgTbGp2jgrZqAHopMLy+Tt8Rtzpi0M3Xt5mpkOqB97J3raVriJqNBZmlwwNuvJJfIm1GAJb2mH9L2b0onHlbG+iodzvo+UfhmoLk9YbzbIjnklWlTYP48SJgegoHwqRVYdzJ8hUiAz7IzSqUtDZ2hYdga5O1ZCv6IC7GQhioWJki34jQ5UC2lislgnXWmmLM5ToDMw4HjFGJg+aUuHdjp5LCl2FE75/rapYsxms610Q5ylJalZHJ5/HfF1DFtL2syIjobyyZW0TAxLS4SW4tYIO4ZfpLHoaXydp59/Cca5IpA4ehZ3MPUVqiinv5KZuVRlVHfSb1bcb27ljGBw0OOr1DVsirTb7KxlcL73tUVdEoX39NGCIMqpQ/uEWl0N8CmOcBWqYE8b2K1MpqA+YSgTRm1wAMq8pgUoJ7OOnCgdsjHay+A+jLo2eHKIBUfMK/b3Qdor98VrhwrnIIGmuUqu8dhAA/WkbVxefajHDTkbhruDAbndtziz0xxXHhQt6VNzVIWbNc5o+S0JeCc75uitvxIcy0RYwpBGMc2XB2bqk2Ac2s4QSW9iq2jeZJHXqdOWO2F4MbRtbePrJy1V05YHgAG/Q+Av8GZ9wzLkHeFLxhl38i06BzjBMa33HxPYzw3CfhBnfiAs9f3dIl2jEMxpphn6k/VqTQEhaJh/SjoWE2wglqeLYBZftsjVWMkU3VPETeV32HpIXBz1iEyDDpdsU9niyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: skip poisoned dirty page-cache on NILFS2
Date: Mon, 23 Nov 2026 23:18:44 -0800

nilfs_sync_file() does not check the mapping error recorded when a dirty
page-cache page is hard-poisoned, so fsync() returns 0.  Skip only this
NILFS2 case until fsync() reports EIO.  The other NILFS2 page-cache tests
still run.  On NILFS2 under x86_64 QEMU, the combined selftest reported 9
passes and 1 skip.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

 tools/testing/selftests/mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -380,6 +380,14 @@ TEST_F(memory_failure, dirty_pagecache)
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}
+	/*
+	 * nilfs2 does not check the mapping error in nilfs_sync_file().
+	 * Remove this skip when its fsync() reports poisoned dirty data.
+	 */
+	if (fs_type == NILFS_SUPER_MAGIC && variant->type == MADV_HARD) {
+		close(fd);
+		SKIP(return, "nilfs2 fsync() does not report poisoned dirty data\n");
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
_

