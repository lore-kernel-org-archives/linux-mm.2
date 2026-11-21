Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39B9606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqASXeKu
Received: by kanga.kvack.org (Postfix)
	id 35B4E6B05CD; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C2A6B05CF; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4696B05CE; Sat, 21 Nov 2026 16:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D92686B05CC
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D1FB1205BE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:32 +0000 (UTC)
X-FDA: 85460344704.07.259F15D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1B3514000D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqASXeKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294830;
	b=nF1yeYwjQ4eCW0rfkS5HDPlaITq15KZJ6wbTyr16UGrXXda/HlQAubOdmunNENrxi/uYXL
	TUosFD6kgGoA/B9Ru2jRTTaLV7hTKxgI1TIWMFIHZIgsxkZkFa9e3krkVWDtS/pLFa88X0
	nN7FCJ9DuPkej9WTTpVMGgYbM9jvvp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	b=M9ittdu0Hf7qgghAcziolG4WAlcV9suPK8FQluli8UyZ/prMLeflrKzqB9bjaRRHeX4Du0
	aRECRETYxUdSWaAoWwbGS9B1aUkuVUETqHELDR3IxqKXezCD7/xfAE02LlaBjlFy4BNMZE
	OyOA89QdHUYIJ/SncVzVX1+TInfA2iM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqASXeKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8310361CE5;
	Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E5E1F000C4;
	Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294830;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqASXeKu+Dq+WbuRnw1WxH4z7XTnbThZ8SRYZ/5+YPOCxXSLmd4QBijLeiYUGOScj
	 I7ZmK0r+ZABwEUXZOhJOlbKo0MtScJ1oiIHQPP6OGFxSI0gcci0w82jltlJEax8khX
	 dJC7BpPqY1+OGy3RDYH4AlCm59SIsOjMmX+h3/JQRVgtTMVXcYiK92+70HPJMJPL6k
	 VgdffUVZnfSADWyUpw41PxqRnEP5prj2OzNOsEm/HsI3Ps1U4EbZptYEdytHqN64FG
	 2unObWA72qmQsv15qGPgjDb8olmIccGh9mAgOGWRpkVm7h0sl+D//N9g7sR8I4w2o9
	 s1//u6YtN+WcA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 26/27] Docs/admin-guide/mm/damon/usage: update for user_report report support
Date: Sat, 21 Nov 2026 13:00:10 -0800
Message-ID: <20261121210013.130397-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B1B3514000D
X-Stat-Signature: hqdqq3wsd94as5hic8hbx9pokopjpwok
X-HE-Tag: 1795294830-378147
X-HE-Meta: U2FsdGVkX1+vtMSeOKXLbMisQqxT+qcN6+/dY1yRTXo0T1ByIu+fyK4N5ZSeDVX/xvk7pSCfJl0XEi/4saifCxxq5nvr7vq+Y3xsWQzawhEnYN3jEf1Ww+1csPoiPClgIxiltAeZcZJkPILMPlL4RWqr0NgmInZcE3bO2LYP88HwqsdDhfNMmP0B0Yy4ElyrFwyQpgMeq1GAqH2I02GU8mdzvdfruLMBQTZHVWmmGF1C28UcoMZB6Y9CZLm/7XneLkBscTzPTsEzodcYvPD28uyFCMBwz55vduCUGhDHr2yehZGMM1hjWsJoLQlaE6jweI6py2N4rGmYrkpTZodos3BZhbzNxb+UTz9nNxCcVIb2QF45J1zskFBAYkuYvbNxQSOQwXAlBweK9MXqzN+Yikkm7dBYBBOohx4ZvzarulAY3fU4HUK/eN8l+bj/cmSqRt3ymxN9uln6MdheiI9bXpGewNGYTT3jlyhJdADmwEILJE0iJaxRpRV+d1FXLLS/kfvtjaxHbhFPHfd+TqH0r2f91gqyZVzKb7Hl+Gs0UDQHaO05WBfiQLKg7N58Jm4JWP0tOQGf9PClFqRuGPqABmyLYoT6I1UTMbQ1ue72G1TQ4yghNvBQe3AT3ERJBodnlpMjRLcQTgaKSRs74BghuyTLjxi1+Dxm5/hqeBhI1P42DjNlyc2wqk/iigg98i91/igZsoJkvr6JCgysGQSYKMzErIyWORKBt692itIfhOotTraS0YbDb2zVAD+ufQXo4qZ91DNGJIGnCzufyeOthIQZA3vvCQOHofu8N7MTxA0FSL5QX0EuIOIXXyw/9BU36UVUvUCzhszmvbrPC9nptK7WLnqawuiYp/h9FJ8T9kFEThfaa41BBKhfCGD7BtKq1md0NWcdlHG0fxHQCsH7WAv6KO1+1RoEVKbUHhO8+AN1XSMG28aM8NF34XJ4if6FBf0lEeTET2Z/+m/OvLz
 tbnUvrU4
 qblpSO24amIGpSEiqPr4J/9I/c84QtJgUiJd1PKyKTDEdpq59eKKyl2I3UqZniPyaqLoMKqMGiQMm6RTYCxxRjwe0mW40IR3+IGpUOFcN4w2IVSd3TMOifaHhqgmmxXtVmaA/xeDiHKd/TQANsoUk1hYDoXTlcarX6Y3QTuM+7AU83UqL8gCDPf8MM1cGh8goV2yc1f+cq4i4OtkdfFZ0J61j+dIXheUnyjtzDjCuwIP2t1JdNmAS1iHmCZ6M1IEtYMLvPjDft6+2dtp7oy3p6lVea9176r2r5VdygAkUpLZTNJRLg+zeKVyCa9rdFOLz63w2PVt47v1MRyluHCdrnX5GZDwnx5zLl9uRCN+IBlTcaAcVBRyodWrsXvDoOb8kLZbAleljpRW1nPvM5koEtZhCpHYKMd9QoKCSOtAGZ9wY3efYsqgIm+9xjAwXmNeDjWDfVL8Jcvv+0zIYFhi2H21qzywD7uzwKGI5TxL/k2Lynosc6un1DIyPYbbSx11IvPZ2W97c5Lf7+PqGmCqmkMy4C9OGtytSyZ6C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ce4e9e4c13276..4024dd4e92979 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -117,7 +117,7 @@ comma (",").
     │ │ ...
     │ reports/
     │ │ producers/nr_producers
-    │ │ │ 0/report_type,producer_state
+    │ │ │ 0/report_type,producer_state,addr_start,addr_end
     │ │ │ ...
 
 .. _sysfs_root:
@@ -767,6 +767,15 @@ Users can write below keywords for the producer to the file.
 
 - ``on``: Enable the producer.
 - ``off``: Disable the producer.
+- ``submit``: Generate and submit a new ``user_report`` type report, if
+  ``report_type`` is ``user_report``, and the producer is enabled.
+
+``addr_start`` and ``addr_end`` files are used only for ``user_report`` report
+type.  Those set the address range of memory to manually report .  Users can
+set the start and end address of the address range by writing the addresses to
+the files.  Note that it is open-end range (``[addr_start,addr_end)``) and
+therefore the end address is exclusive.  Reading the files shows the last
+successfully written input.
 
 .. _tracepoint:
 
-- 
2.47.3

