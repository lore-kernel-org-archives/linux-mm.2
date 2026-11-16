Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF751606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjG0ezQZ
Received: by kanga.kvack.org (Postfix)
	id 2E3516B05B5; Mon, 16 Nov 2026 14:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BAF16B05B6; Mon, 16 Nov 2026 14:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0636B05B7; Mon, 16 Nov 2026 14:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 007C56B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72B0FC01AC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:27 +0000 (UTC)
X-FDA: 85441923294.30.FCFA49E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5412A10000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjG0ezQZ;
	spf=pass (imf14.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856225;
	b=subMiNORyOkiihljyqrChuvdLMdrojtoo1PwIUQAiPw2yqQeWaVooFuw2CbdtmnzjUYvF6
	hWncKViWypN81klZIU0g5UW/bmZWoQOvkXx11kUYENGt4zOnCxBpHRJM1q7Yaj3NDuzzT/
	Kdga3UYA2xiRV9+yOg23liRIIGUOEyg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856225;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	b=20Yhfr70vJsrHSBO5pMar7nYrxsNpaULsumhhlEDc5BpzKX6fnu8xTkFpj5yrNnsQaol+W
	NM05uF1xgGNVnHZw29JgW7AOP8d3Z9VcoL9vBGnO+fKYtzl3LMzQmu21n2GwZczQeZxfG1
	6g84h2Hhn/n9HcRtLZ6Rc3jKcN8qOa4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjG0ezQZ;
	spf=pass (imf14.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A30F546750;
	Mon, 16 Nov 2026 19:10:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856224;
	b=qULEkZaU5EZ4gCL0jcBG1du68dm/Zj+llvss1dyvXrtsvPIl7z5EK+w7SPY2iIVCYImI
	 oAy0zAQ8th1fMZey5YTLvamcckHJFy78AIVEzvdVFwXsvd9B63HuZqEBRrL2UweOYNln7
	 AwIrhvw1yjOjzao3zaQuQRzITh1umewYZ8lBj8TmKFKxfp+Z+QIWtHbtfnvkL91BeSYtv
	 5baQQstGdeey3z50kLGx7LuGBlcXds2xPRwJ+UYjaE+RxPZuNxYlUzIz6Lv0BCOqz5Dbm
	 +JvwQYHTS4UQDhirZsDB2EDR7j7uoLwVqH+rhjkCM+HoI8ikqpx+sFqOP6wbYUEnNxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856224;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	b=WCR0tHxqCbdsOgi6nM6eL+GVxCoP0GG5VFnc2bDwTgjArIq1s8C+kBkIxhrzu1pxkbgK
	 juDd23skSRDmbinkId380IXd0nOwb/RfShuWnH249lCyTPkS91C2lvXei1gUhX2BdONrW
	 gruFC9hqiqBTIUdaDvZN2NSIUTmfqcnM4HKsRE/TxqumtLIJwGaPirI9owKzLZdWwXUHp
	 n40ENBqOUt6V7YrXMEdDG+/az1ujZcYq17ELYmgoleeBrsVmumKhRNUekttqwyZkuL8c/
	 dVVt4WECwgehXs81corz0L9gLfiAWcfs32u8m/etHxveZEGs5YI0snmw7p8pCY18J/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 222E61F000CF;
	Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856224;
	bh=5ymyID5yWGQWOMH6t/cr1gAlkP/MvA7c8+VMex67FU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bjG0ezQZ+fnVbyojelDEgz9QF/RbN+Yvuh+moB7bWehPFGvQav/M1aSWiOVb6aa7T
	 Jt2RkbSVdU4/NwYpwtqI7jizCRHdG8/C7k7KFsMQjfPgVyG42R55pw8SLAynV/wN3M
	 kLji8rzA1sg9eYV1eLaH7/L6R3SXxmrTOe3FhejTWK7eygJWzMDSnoS5R3wNGm0Dxn
	 XdXCSQw6Tom9dwmIcxIerhEtv4VojIOKt4Ah6oSQp0hyGI/gwKhtW4Ae+Dr5tup3fr
	 IIwoAREYzAmrkH0Ra3PQO57MQ8MZiQep63l5nurq5iLJIQ/o0keqqvck/1rbMV6Sfu
	 bhEAiFfrfnKXg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C02F14A5A9;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Mon, 16 Nov 2026 19:10:09 +0000
Subject: [PATCH 6/6] Docs/ABI/damon: update for sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261116-damon-sz-ops-b4-v1-6-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=1281;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=90a1wbT2PC+F+rhsnr9WMD8Unb+N/GP+Z2kT1pcYBmY=;
 b=hi4tgZIxtxR6RtG6s3uQhhJYxlS2HNzATbhpnuiqcnw5erFek5+RS0MAPJiH9qov+piDgHtK6
 oCziTYlozDbCijoYbcVkeCIhYexh+1IIvvma8bp8NvnmpRTf9a0dgFu
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5412A10000B
X-Rspam-User:
X-Stat-Signature: ajz5gou6nk3zkbkax51qtnjnf1m8kn63
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794856225-840381
X-HE-Meta: U2FsdGVkX1+REEjJV7sfG9Jwf1XvYMD2xRviW5puKM+ogYjMYlW3p3Y0yVzY4pK2gDOkNS+dAOdX7fvqQr7IAIEVYxzb6Ucppm3GZQHOzzbWLOCdzpgGQWQBFUQbjWxvQRr/s5rRPD1r9GwvDiE1563ya+W3TRaaPZsH0HNvu4PHtBZdk0h/2sS2utFnySx8Fdp5/q9qxCWF2CTnLPyZUkIFRxldTJllgiLHTrBeo/KUi9NslatL0M/MZJOp/yE54IWI1wjldviEOgPY3KpZzthyQwlzqjHZ2g3sLbc0OTYTqKlaeWE3reN+A1nXXhrX0KslVzg2WJfIrlhUxX1wbmhl09avXydhVMd4n0rN5M7Fgs5Ldf11UHhJuXSn8ALrt8xerK+KnEn2HjPN58g9+SvrlhY4iJtwLGdPNDK+RNIgutbPAXQ+8H7EX4W2tvefL1ymhplN/ZAAWZs4eHemBrOTQ96JMwqrUlSnkXaXJl2d8kx50giBRSU3Y9wTzs8eoFpwjhfHWLtxL2xA4qsWjHb6izfDM6vrePnlwhXVYFavdWLHxvPtkehSkGzCe+4T7EkTXgRFtIU7GK4tmM3biG8spiZVHUApfagfU2OrZmY3UJNcWJVykOWfYuRn53LlgdoHcEba8iZ8CqKQbE3nVkJr/x1+0H5SCXenTiR7kqC+sujUqDop1APohZJh0WYjsfD/rUyzsvUO4PaujxEGmqCsx7IthV3/FUqtb8yCkG59OJy9X+kUpxiFN5DJH4L6oEaWVJKiAGPMWAa8doxyieGv9fO/jHUk1uYbOuparpPYQ2tTafd7T7QcKMLKSMKNkzB8XlRKOGUm7g07q8dVdlYhMtTc7fgrEaLjOay6wIX7oqLpYh63+i4toXcEMeS7Yob35LJ8GZDd6vg21UHbIviaXMm2ISsn4+6oeVPzTQYsIggpBAA93TwOF0Fy7ohpS2QBUDeCToDQqWEp64H
 83skzSRI
 f4WLRqj9YmctpZzzcxZmb+c2D2KtPwYWkBQjMf5mrAOne/KbKluPdPxbMMND901PH7b967bojNoCT6//UUIaK4QpCYtc3N+ePqK83m5udT+u0q95chK9pSgyidiAfWmYBXqpA1SD7y17gIf8wC533q0zRVkFGFVJq7R4b9rDCqTpfAxFoJDn5bNf/a7FPNPDwYtZDIZMqbt1CwcgkosaUzTsKU+Qs158mmp3pfxtyWwfGnK2o+JBORBBTojYogsFyIvSmiPpnyyGbdn34+aWhussHCuHqy34CpKQTAQn4L+e7WBA1URdYn7O+p8wRP6MrS5Or3+2NyZh6ZTcVt8tb5JYU2FbVMn9ksxIgSxzlsoaTBdKZ0nHorK/sXtO1kZqs0gRtm4E7KYv19+yznQRWDL9YC60Cw/KY+Fz/dxOrbRbqsRtSwiVOfF5H8IxsvVIhi0w5lRryNFQ5wF7oZ2dblmbfKK4EgXOtaWtackU6/XDWlxEGwZDAR7zbAXefZigOtbV9UJQfcAOlv/9Lt0O3aP/X0hNLP0eNctuC9elrpdwCCgpWun08t9jSDubc6PIYNeRstpO1q/+fMgZzlC1RwUP6Ya0rrE06B8BkLNX1Qgrynhn9QldCRWs9n3yufRZ3aFeGHiUZyufExf0vZYOYPNRGItcoqHTm3hnN52rlQkDzAoRcLTv21ng2CEKH742C9iRA+C69kRhtG3E4Rv01kvuS4+4/lsd2RZtN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON ABI document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4..92348178e48a 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -623,6 +623,13 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of memory that passed
 		DAMON operations layer-handled filters of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed_last
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the size of memory that passed DAMON
+		operations layer-handled filters of the scheme in bytes, in the
+		last apply interval of the scheme.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>

-- 
2.54.0-uber3



