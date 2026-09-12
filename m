Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E98C88E64
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC636B00B5; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C576B00B4; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C1B6B00B7; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA5B6B00B4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A37114052C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
X-FDA: 85206197370.06.5692A9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2FA9C0007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwJ38vZj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEdT1Tx29QJewgZvxzEFx+LhCVGEN67F9XSIdtQFFFc=;
	b=ORpzcTtdkWnrH/PswG/+ObJHO4hZdFWrxiP5jd/EM8hSC/KIPzqY8nVWCGvPrjzOXJoatk
	j9m4iY6wdfQANRleQfWjSt0UQpw2QPZKnzJhXv8pbzOTWEFHN1is2VNV2E7mIxgWIHnTOg
	VTAyUDl/MuIljzp6mXuDwqBTMHq7XoI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LwJ38vZj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243703;
	b=QD6F9A1NIpynUPZEmSO4cV2+EZdiMu3Qk9BmSpPW8GYspQnQYdAtluUTclFuTKqN2Qo/Sw
	SOv0IQna8/wuHI597/WMWBllPhdzcnIwCtXKP+VrcmXjBxMvDHf/HFksnjFUSt+TqjdxSO
	9sRTrjKqYHLGRRlpmMJI7q9z2VzIX0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F1944197A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E871F0089D;
	Sat, 12 Sep 2026 20:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243702;
	bh=jEdT1Tx29QJewgZvxzEFx+LhCVGEN67F9XSIdtQFFFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwJ38vZj+WJ+Sh0eZvH/h2N5n01NFFFCBdQqBk1X8PFWginfJnDCkpbraBEWkKQ8r
	 NM7czumnfsJL2eVYh3S4vojLSwu4ttQlsd9BH5bxKqJxRWc/a6ZJTwcxMJ1xyYYqei
	 oxr80FF4dCjnOnIB3gDcGzLUsIs2m7j06LOW8Ef8J3taXpYZNn3pl8ZEG04Fdjq3KJ
	 DDI/JipUvSw7AkX79xtRaDhIqIFK77oU94qWM7UBNyyqmHVWuA3TDxaiXL15l09u8O
	 WZ/kiDMso543xeQe7526fb74O7ozTz9ydDzbHSs3Iq1IhrjPIi3rA9LS3XohqRHvZg
	 zQjsr6WsDtjPQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/9] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
Date: Sat, 12 Sep 2026 13:08:02 -0700
Message-ID: <20260912200814.145612-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wwsf5fcanzwqdg65cowqyf9trkwo1n1i
X-Rspamd-Queue-Id: E2FA9C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789243703-365889
X-HE-Meta: U2FsdGVkX1/BlMmQxW8jtYfIYyV5sMUusSujo5XJqB0sZ0wy7xOK3bH6EUv54sgaDGTwtGKkMIL8CIvdO9q4OEbjzuOSVOzpotyCiNOEv+6TU/roFHsoKvmof85/owzT33RSjNhp/JLB44dZSZRfjuv82ER8jC745HQjdi4yDivS+KDNSfcR0QBOfwWlaQhUE2TfbPm13LnbbiRXZbnKiBhc699V02itWxF884TDAGN/1/KrqzLNR1YXkGcpEu4h7mqg060Vm+KYTioDFE93HXtSskLgQtC0ggJDkVMwc2y879NbzgK94GrwXvQnzkYqhCeBS/dJiH4U7o/RVtGcaQnW/fRp+aYbeVxnEF34AuTLw/lDZyypojpeBACiP+MKuDmzzK2FA6qCdyS+4O/PsluijMUM6zP9h7sH2aamsD5EYQhpq3yPXBdzWfJMjT+FpxkAdFk4Q8ImqtwtTZGmYoBaDvBUX5acvuzKfMILndKB4pLURTin1Sqf37nqriluy9S6UshPIYAH8+PAEjsR3P6s4bT4NsVJUHoVREWBHLX+eqtkahYy3FOMYWne21iRU4mawvsgtbpal7KHg9xGML9F7OJNdtse6nmfNEH5YrfuXgnrSjH5c8cCW0Y8fkvlGIMMfIDglIAclJh/6lET05+97YIxFFJf3F4KuCtYrq4M1vfw9teYhhry7DHBUF7IAuPbnifXtG4KEshkkGfIVg2d2/eHDY1bBd6fjYFpBfeahD7r+hJ3MT5xAZIwAQuClrTRd/PJt2jmn4GhFG3yBc9PsWY3aSmtJ/w85b8Wugw54tB/LMBmLvYbk1MV2bM8JMtdDXcK6SKMxbtzNuQSXewwGiqYWRebPu076bmCPYX09ZMCfgYGWdBhC7afYv7AfUhA9/jAfOpVse569sH8lhvvORbZWrNJNUoqSJeu/Ndsw/ZTG7+3Qz+4Xdl583CwARoFst8+6s6pIjaZoNx
 pi913z1p
 A0w7ug+wnGIhqDumZzLpnZ+VHiMbBAXupr5QMTw0vHQvmbHzxfYj1T5yTzmmTQ2QfZqyQJ/7o2liWzIvO1dFE+EswPeI1wvxn8qmC3X+6j7of/VHmfLRkWJ2TdUPvWidZpJrgGPWQLXpcBJWls2f2UFGRGFcS4aauJt6IAmRX2dthpmQVHr09YNwTPFLYinujJ3QkIz9LbjPQSqrhrGvWO4/JU/jwEL/Kb+tFMLkkncw5WS6CaDtjCnmZS6vr35fHvxAvovgETfpf2c7+IdCazUmzpNSteSn/piyCugpinS7ly2e7fbpsYSTn0AMjPKeLUAO1vYXr7mYJVgZWPsIqvcqAV5aWfoUwp/DTeya8HNRq42L9j+r2Bqf4aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1606edace52e4..754752d891ca2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -402,7 +402,6 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
- * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
@@ -424,7 +423,6 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
-	NR_DAMOS_FILTER_TYPES,
 };
 
 /**
-- 
2.47.3

