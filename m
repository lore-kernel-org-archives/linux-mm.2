Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA18FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64A16B00F9; Tue, 28 Apr 2026 16:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C7F6B00FB; Tue, 28 Apr 2026 16:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79846B00FC; Tue, 28 Apr 2026 16:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5E286B00F9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95364A03FB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:29 +0000 (UTC)
X-FDA: 84709152738.23.A36394D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0ADA120010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fc5aWZvE;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCG/2vM/IofAbu8TL6vpUdbIQM5oPT7VHWdx+V4olVY=;
	b=8FFyxqfDfqe/04hGJ/h3vZjXlsgW0TBOFzHzuepfKbaLR8+hdC7mYHTjVGCCO1z1tlnvPt
	iA719jjuGT149ALzcbqzQUsekapl7EBtFkqZ8h49ocbGP3EhZXcCtGB6V3B1Fv82Lmt5R1
	xghMs0ouH7BPU+fkFf5tyb1RI4BM8Is=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fc5aWZvE;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409308; a=rsa-sha256;
	cv=none;
	b=o4EzX5v6a/wLaf9mFJC77SXSuV2nO4zHTBI7jK183WXH9VrVhQfIxp6/Pq7QjP0TKWah1U
	T+Iu0IdUa78REDO8ZQgL7I4iOwUAaWmhLyDkwM0W77nOObSskp15t9J5uMec+JbbSoJx7h
	0uuNDLe1xMCRvkz2OXRrvn8+MF4oVcw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68C1761119;
	Tue, 28 Apr 2026 20:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF6EC2BCB3;
	Tue, 28 Apr 2026 20:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409307;
	bh=n+ynKYOhHHd3fYSwNPmEpGp3HvFkvJ4/6qKKQftdCu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fc5aWZvEBk/mFdR7Qscyfqp2MKP5O8O75phTbP6wzsYUc4XJeyPFoPeYDDJY/ovNH
	 PxNoUCf8AG/OD97MlUQ9Qapk2W8FXPKjrMh9ZzMHkdqfk6wXXgPLyvByH2iOViry4M
	 zuRKDV2hmkZuHCZE4CwaGcEcleWX79mzw/7xr+Fyj5MrOsL/X+VybscVk0ZiDeanov
	 smGHfx38WNEPVfxCj88X8E/SV3pbjUFLo/5upRBsIGwKMScqIdvSS+S6zugAFy+nl+
	 5ZnmcWMBoQVxOUhs62w+kdrXpWvJ04nm5MdbfBV38XBVB0LIHlVkJQ8h1keSX5xYxI
	 n7NVEV3L5oQ0w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 51/54] selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:37 +0300
Message-ID: <20260428204240.1924129-52-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0ADA120010
X-Stat-Signature: qh8dsh6s141f69orxw69w69fmngxcoui
X-HE-Tag: 1777409307-63825
X-HE-Meta: U2FsdGVkX1/fNHlQb3y2ucI8xUxP3HBWm+N6rCnsU/B3LzAXLqQWKL1Z7UI5f1tMQaW1w6gl+9J1vLo/sQOpaIOHuIzov5Knvw3HEZR+vv8T7J21xsW3PmFapCMjxaiV+Y8v24S6ApD5RgF/9ANakZyIs7n6aY7sygW7Vbc5ao8inH54f+eht2YxrZRVysbBci4usJXnXvyLbhJ1dEGoKqeg+8xBxyONyRoIAnur+SG+El8Gw/uvzOK+eXXbVDiwyAK7PcHw3PNBQSbX1nMsnvZYs+4q913z0beF2Ynj4xR0oAxyN4e+OMoepllRU+NZg0I5yBPDOf605iVRUSinAm6a/CnYPiG09HZWYp2vCJqaXQP0OL3hTU/W0rWubeEe+DOVBJcsquviOpXWQMKWaWi81CN+CX8WnuWZGImBq8TX0PPwlnThvKsMV1bxch0JDuA9lY9R5QqZ9EwC4N9Kc5Srecr3VtB5z/wSjbQw51qg0OZ311Io+OSXGnYO8+Vl3EwZNM5Tqzt1El/q+7fvHegKnZSKaZhRRAvUIGr1gUCisJvYRbuV1hDY4kDiyrLc8OWN/TKbg50Au8ExteTfORL64NfPFGbvhtrvkTK5u0cBfCRCzl1DnSwsuTRJmcKDvwLoKCGrcJRbBxi3F9NrVWnszFoX3X1y5iTA1/s55bZpH6qNK45AwyCEEL6dcxar3D6oeqje38Ot//mCKXqDaObS+f3gBUYggWdFei1fqjwD94XMzlmXw+8Hc5+5JExe9tB1anTR1g2HKtTrZm4Sf8F32sTU4Luj+LhcqE2IYmLF99ND3P42C7MDO/gSFF4hwdBzCS9nTEQxTHd3UQeUFJ7K0ayJiLHmCDAGPubhFdnQ2TvWLaNoVyyRhUS2NBlYMwYRDO5XrH5b1UcEaHo0A7oIZX5g9Br79YNVRTcNoMLXQSQLcbCOg3wg0jJNDvVKvImo+orDSrjHrgg1FjA
 F8/3J5kQ
 mA+mRPCphFWtgiV9qSTckDXmxIkVbKpKQDQ/z17zPzCjxRTD/MBy3RAdL36ZnVExpSc6E1J4f4I+RbLFM6wZYYufgPePYITb11EOoHXIEQKEOhMgHcn2jr4zt/vPaAe7N0G8apnSCh1WR3+O1AuoOSrdqeCzEZ4HIYZZxzuEBT32dlpKSF/PGFOM3XISxgepBhQN06WqP6iFnQqEQrbmJVanXo0P80vKppktB9YXLfM/nagJ/fzvyUJXfOz5HrJOMjXPidmLsBSUW2El0N3lgQDJbw08ZqboZ8ESp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

va_high_addr_switch skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 0b69bd4b901d..e24d7ba00b44 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -325,7 +325,7 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		ksft_exit_skip("Architecture not supported\n");
 
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+	if (hugetlb_setup_default(6))
 		run_hugetlb = true;
 
 	testcases_init();
-- 
2.53.0


