Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E64EDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0137C6B0099; Tue,  3 Mar 2026 23:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00526B009B; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF356B009E; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4B626B0099
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C7FF140432
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:33 +0000 (UTC)
X-FDA: 84507132066.14.DA2B959
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B48781C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fADf3l+U;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUSquLS500T5Qa2yM5Tf2vpBnjnAIn+yIsPspZOsWas=;
	b=UKhTmfCpSOEXnyIGSTZoTGKa5J/LnrnTO1JOyn1YQK+7xsNbxoy2jnU7d/wcg5pdbvy/vS
	9PlTQUX3kfcFqsgmszh/gjhIKyaDYg7CwzqcawSvRraLVw49cIhsATdyjqTU7pbuGsB+aI
	geItmNG2qUl6YjCDfQTYOyLz34EsnvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599291; a=rsa-sha256;
	cv=none;
	b=0nyP9ky+e3ymMwP3sVwZk8KJlSdblKOM8F0PULJBBdtMcVzbd5RqHanLT8IBAvfmte6YrD
	oMnKUGUQFiFAF2c9W0c89mQ5j3f/jJf79EU3Y5r7ERumbLgrwmzGTMSb/jsaYo06Qek4E/
	nWHs/QJ46CqOPXVl/WkHVOzSGc1uzZE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fADf3l+U;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DCCC4473D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6A9C2BCB0;
	Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599290;
	bh=pVuHdsiSK2hSc3Y/sliHzMztEBUolq4unjdQPlB02FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fADf3l+U3piiHRary8J43NRu2XwjdMj3+DnQaO7Rwm8yWFNEOA4fe46nuP/BIK0TS
	 CHN5r7Boc62uCRf3YKpu1nBSXZoSGv9oddF0Pu5MhD1fMct4LrPia73VErPzHrQ1r+
	 0rgE9PYDrOb7UPehZ/sB1jAnp275O14idtv3ZDFnBgyb01JySP1FsI7xebl4YKbpOC
	 WxBBAxeMHsAlRo+7JrdCKCVUPagVPZ2PFpnZhonD20KhC+EyEXCx0+ekePzje8lIJE
	 G+TMUjMwhyaWRI2RqWY2UewFbmRZf3/1KL1OXaLBQYwTU0MASUT3IUE6Kqo9BShBSp
	 RtzOVQcKjebsQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/10] selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping
Date: Tue,  3 Mar 2026 20:41:18 -0800
Message-ID: <20260304044122.79394-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B48781C0002
X-Stat-Signature: s1dqac755jfwkdncyyriic5hf33dsncq
X-Rspam-User: 
X-HE-Tag: 1772599291-656090
X-HE-Meta: U2FsdGVkX18ka3OBtTDSM9L1usv6nUQn0xIObUPaab7cRJTb9F0kDn5IbrnHDoVbdmLv/N7rc0qEkwZrn4bJ8O4pKrr9Ae9Kpf5CYhGPnn99Lp+97fe/YtNqBxc8ojv7exdZ7nQlXJ3Wka1e6hQZ4PG8tXUTDvB6rw8KBDwxn+NsArRaDs0BiM5SxljH8sNb+w29v+V7YIK2UpkltNgx5OBILH8qcAjpk/tV/9/96PmgrxNkGZ7CAq6VMqkYjJO3C3NVtpjcpENaxPv/9sLVnv0ESqBswUXMgb11ia3HfKMRMAbjn0k4DosnybkYSN/iuvsPdsMAJ/roJPcP3RAvJb5du33Ex7RPIbYdEp5kW9OVZe9vMM0zqmHD1151Bro2pS0oY3p9MfZKA/6yltyeICeawtMSj2jQKWUfn/ZPTHsWFNobrKufJwaNBF7jPmid4J9khXnDfplZkx+4nAnIobQmK6uY/IW707wIemDS0mmlvplop2G6EOsA6fbf/Sn8Ac+v4zI0oa83h0hz6St3t08R42NYNFDimMwnKwpbRr0otPGlD2tKqbJrDz4oAdQ2axfENX1VXN6vbTC4uo/x5MqNks/2swFKWe2EBHmQBQC+fFZjc2D7vFoc1RdQIrj3OLkmTw8B0CT+nkBoX9c6oQuVKB9XEIsV53pKBUJSqYRtNpBFNeNNuqdOATpNrlWL75y3PiU/5/Lcf+fuUU8m6FQknoCKm6iH7McBitq3C1V/4QB4T+tM7TKMopvPtMLSGd8ED7ln9OVGyiZ+mQgV7ZZCUArN3/5zAYhitbUpoT6qd5Vb1bNo2dxPJbveRe+XQcbxhRmQPjHOPp3+6L5oNwigd+iHohmiTeNJt8VyzZ/rDp9eNI6QQfVN0mC0LXfVxcL4JTLOHe/KtS/iuzmMyEONUdpH89H6ZKGrZZAogvCwJ8R/TdhNaQNVY1LyboJ3pfRlwKGksAa6ro0UKI1
 RNhzvk9g
 tDvPBcHPLsfg5/ALoySvpsAszZgLr5lYjfp5uPrcRlxva4vjOpaBhwsjGZ518TpuA+ySqvWah9dqh0WIeDtwjre9NW9mGtxq8U2UPRJV5SbenwJ1/bLvXvwlXPlAsGgGcEEtT+nAfO2/fzKoOm7Ctk5SafZSjJIjRp8c5GW2eTk40H9lzl/btTpd/74fgAo8jOZqOB+tFQUv0j+HiY3XhOOm+9owByfgDzDEDAo0+3O/TkrzfNFQoMk875hhapyE4j6YPuOJjAT9QdDb+GyjUYRmOXvJGFLViO1+YJH2ZNKesU56006nKW125xfYc1N0SBQjCJac6r3mPJ1BPiEdJgETjbN8K2aJqIpCT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update drgn_dump_damon_status.py, which is being used to dump the
in-kernel DAMON status for tests, to dump goal_tuner setup status.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5374d18d1fa8d..af99b07a4f565 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -110,6 +110,7 @@ def damos_quota_to_dict(quota):
         ['reset_interval', int],
         ['ms', int], ['sz', int],
         ['goals', damos_quota_goals_to_list],
+        ['goal_tuner', int],
         ['esz', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
-- 
2.47.3

