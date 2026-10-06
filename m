Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4941CCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699726B00B0; Tue,  6 Oct 2026 05:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6497A6B00B1; Tue,  6 Oct 2026 05:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FDA6B00B2; Tue,  6 Oct 2026 05:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 388456B00B0
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:26:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C338C1205DA
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:26:01 +0000 (UTC)
X-FDA: 85291669722.02.F3857FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1A06080008
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+5nLD2+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278760;
	b=HDRSFeJAFbBCfd+ggknJ/Mf468KdEDhOlYNB06wKKP1q4gP2MPE5mldnYPSv+MPvaKxijl
	kcm08mUMffi6bee5IZOoUq71+nWCqx+KapeHiqp2B3IHylIZFtRySbhAUPfFWTyh+iJsRu
	9nod7rz+p6sq02vx79eIFX8BKHr0+SE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q+5nLD2+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjGCXz855ZB39pZK6vllE0mJC/JFNEoyOl0hP28evaw=;
	b=VSrTU9+sBh/1VvMhPvv/D88J4j+vhGZnRBE10N+RWNeDJyOKbN+v6g/dxvpQUPoofOIkVz
	1aztRQ5UfRWUkZvoqwTaO1psXEqaiAEOXrZC+TvnVB+4cERobXFj6JMW+TWbtOuATAegq/
	hyXs9ew2cuuE0QE3mVPYhlsZvUdqRgc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D83F71477;
	Tue,  6 Oct 2026 02:25:55 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E9E133F763;
	Tue,  6 Oct 2026 02:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278759; bh=TqLTLymmXqYCd3I/aSuR0jmggCPMmQLFXTRnUZ8RzAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+5nLD2+CaHswKy8Q0jkFjHFatSH5ixPnA4F+mduwMe3/DMzDMxUK09CHotGG+eaE
	 ewhENlYHW2Wx7lnSVWEYiZYH9hcCaqM7tRcLJEUixUylaW/XXtN0GAHoV3JBrVxv+g
	 zqig60IaUN9quG0EYc92SFWhRPhHVDhHu/SLpO8k=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 07/12] selftests/mm: mremap_test: fail on data corruption
Date: Tue,  6 Oct 2026 14:55:06 +0530
Message-ID: <20261006092511.145776-8-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pddyckuxuwwaayqm9y4zq7sxfikr9fn3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A06080008
X-HE-Tag: 1791278759-840229
X-HE-Meta: U2FsdGVkX19OEU1QQk+x0Lt9mB/Sj76PtaHOsYqCTVTfXTv3ZAbZjRC/F2Fi2vr0yhDncf2akSneisokjP5RVI/xBywRl84Jb5LaUKg5sAXt1xK5FjO2VJUbkjvKpLbFZ1Qve9NJQshkDnQp7wQtuTwwV4ZgrNa0cHjpT/QNA9uGwFWuSTgdPGmDJhXJ9akAOzPz0v+XMHFk3MP02kM39V2u0hNeO7XykdjpRIA5Dn672M/ATPlsLGtpTdcycO14VZyCMEQ+HZzLpAl0ojxvVJMzPbeSX//6iMjWUNAZ2XVhON21+LeGMhV0JmK87CkWQa64hWucF6FXJ0v7Uy/HSCx0lYwaJI0Q8v/ja+La9aBsMcUipkkJ5IS9fVm9L2PrH69F7DQcOzeP6HD3NDdx8Aotrunjjj8AGVwUs+HexcBkTE3xscSWvYx6cJVU7TBTdfvDwcbaSoqDCZ2aR/uFQlBH8btsu29nu2CJLfGtXjZ0/lfiJM3TRCoYyvkr/WaILTpDrn+HleW0a/1xDedRQWFcl+SvUnZWVsBkaIvbXReQUwZvrATMfa++5KD+fIa3yGyW9VyRQyRd+NnehvgQ+Pe+NoYM+8/c7+WwD56IAz1aVJjgc307eSBLjLNR/4EdlsRejHdPXdruUbVsGW+derHWj2cloIvdgrbYhC/9M88Zvd9hGGirzpPCxUPZh767R+kPvvFXCH5yXyumDMair20LFc0QCSmCu/cVG1GajcoibZ0iKb3NJ8ne//HfSUQengH2uHmGOsg5ZfNHO9RHRgdkpAtnC6AKHmsaN4Ql7D0YVvkmxUh1PT6Sor6s6G8qBdqiLb8dTtBrS6mt+KR7/izChUuZ53UnyDQ64OQQO+ATXGy8CzBPWWl1i1Ri7nFq12YPH6pMuV/3he4Gquld6yeYciZzwGzS0OGXXRwJ5q9XPqAbuH7zYBU4EKXD+gtpL3mriIMpsIRsUq2tmRW
 3K+lMkhy
 U/jDTtrgkXO4IbjPiow0VsxoVr1Xuw1tCRj4+6SIZTJaANmMDO11yOoE3Qval061+0DpDNulN3kNDK6qU0gnk+HuQ/cUVOw/6UDp7a8yhFOb0TXfoOUFPgmeNnzqazW56L//bXFcXr5M0IAf8hdU/jBM1O1oZqj9w12LbobMYCsMGUljrzzMNbZzJkpVJDZX8uQLU9xGLC9Gf5m83wxliyji7DgDTzpvVbZ6oXpnMWkB9HZ8J5uAsxwNs4XtJWMjl1wcwENTc7FEUJtyOMtq28ALrK7fWO+8fmLIX9i1VY5+btYJCP3ixgeeGnvtatbpd/zg3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mremap_move_multiple_vmas_split(), if data is corrupted
after mremap, the control jumps to cleanup without marking
the test as failed.

Set success to false before moving to cleanup.

Fixes: 7d6597dfef11 ("tools/testing/selftests: explicitly test split multi VMA mremap move")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 1baf6374ec67..833efa85e5c6 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -682,6 +682,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 			if (chr != buf[j]) {
 				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
 					       i, j, chr, buf[j]);
+				success = false;
 				goto out_unmap;
 			}
 		}
-- 
2.53.0


