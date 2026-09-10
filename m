Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B814CC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DDB6B00A7; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163976B00A4; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81126B00A6; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B35426B00A4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34983804B5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:04 +0000 (UTC)
X-FDA: 85198059408.25.4711682
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91D5BC0015
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm3EsfxR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	b=pESkfaroIaNZINL0IRJSio4jsAtSx1MgCYv9C0jErymF+k+n0N9ACQdNCXxerCvjZVsO3I
	lV+cZVA1GE8oES+pDqCY+kyt6GlGhVgkFfBjrpk3L+vE1Gnz8g/RB9DmZhfYlkNHOFUIqp
	r6nSouEOWcbkP3wtbHI81bzOF4e7ojo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049942;
	b=4OhNrfmzuCPM+27x4qfWQBXvBUA9/J5+oDdQ6IcrtB+Sl1BFXw8amt3LU0sFzbqFXgmWWO
	QNkqlmYAtYtnc93EBzILSMZ+W5uGUmFOyROdC3CdSmSNWBhjvL6wqeAz8d+lMvQGfODo1s
	CgNMHKnXaM8cA5Zfqg5pFV0zd+2vHEA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm3EsfxR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35F6660218;
	Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95461F0089B;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049941;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm3EsfxRZoU0lrrLqxjyApoQiSRatL1idYHPbQGIEl8uNjhrLF/RP27YMUMr8j8/G
	 4RO1iEujHLWj7a8HIAiVurO0Dy32FJSaaaQ4H3L6dVep+eATQaYWJnJeLz0rgmCTLn
	 uBIhCBcm8yT0mEDInANzKqhUbLg5RbKHbOp/3HGkDTksIDufWrKeO51y5P7uf5ECgU
	 NX43/YyiqFPhc/qPNmCKjk28yg5zynFSbRaZMAD051+67dDwezVGCPN9yZybnkR/bw
	 bBEwqaiUP4yJbznelQs3id1dXhIH/9HTxujLeQO+H8lv0eum/VUd6I9BQYrF66H61M
	 oVNWN0iW4xROg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
Date: Thu, 10 Sep 2026 07:18:45 -0700
Message-ID: <20260910141849.170896-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kqsqn1irzg94tious714i3hmg7dofg8g
X-Rspamd-Queue-Id: 91D5BC0015
X-HE-Tag: 1789049942-494170
X-HE-Meta: U2FsdGVkX180dwO3Bc+oUSd+p0cBIRf1MFlJT6yUCAniEaJsLQXC8oaJIg+v2MrXP92EihBBWGcUzygDatxqrEUPfvcTeBK5LbeFCNCDbHFRNibeZYOGZr1A1DBpVLrCtzOMQRBWk/R7CK5YKA6vs/9f+bjCwdhIRx4exdWayvfGXPFU7yz3E7kERgiddEeQhSGrlpLEIPfUVQFmzRQBKChzr6KoB4QIEecACG7LqkdM7WaAOCPpWVrwwSV8ZOddm5wiVwmQONUrOLmwQvzCd6kICob8nq3ZNIAwh4k7Kx6jD+n/U6cGtTNR9ZsvtvU0f1IsQBj0gwIPpFVGCFVHZqgAhruuSlwtmKWs9a0C1WJyBduQTktj+DJdpKrSEVf9HbQ8JriCZzcqrd+l9dGgnbBxrFCyftT+78pMhcSwz6NWDXwGhb3HeNMk2UInvvULGICe32DzhNxYQGuJj0KdQVpYEF++2pniWpfU1scX0ff9J7ErFNyzLpoUhupdX6wyAklpsAFLI6+QBhi44pCNqnA5H9MGz4wzp+AVDkS55QonR7f3EPsu1tzJ6M4kdTpPRfeh/IoqTmtB0OWGLMZKKMPXd/MvzJQ9VN18Qd9be19MqOF8lnDLzDY8xsXCJoAACI1kVASBsYbHC/PblrzhjbwblXkcqEu15HYX84rdXKqxShZAzIb5Jkoxc4fBeh/oR2gR7sg2fIlSke47OSq0g0BhiGJ8b+3cEDb0okzpDNVKqlj7OdMDeJXG/vbmZutOKWwymgzkfTpJWi/J95NFLnT7Pv+B5sp9ChaWuCkWmIWWklSUcan0fW5kbJf2U3c7yCUch+7Kx2NogAmdZzRyvadCs6ceEi0bmk2QGtHU52lLF7tL/Jenh104L/NKiz8p4y0u8pwTewJenSLcCTLnRR/fElIt/Bdb4B6au5FMpbZlKBMnGrcRq7sQFRUBWE+fI/K/DgG6bnj+Xpq4Lax
 /1tJqgTQ
 BNKoUzE74QV5hLRPLm5i/qnLLBoxLP7egSaVHo+tB0YcdOK8YDmWWj9YVgwXndk3l6KOEoYM6YYSpBkxSYSsJRkjCNFtmyMJEtPRKRk8W9GagGMIrCOgWnNPVXxMXmWD7fWnuGNhoP71dEIO8QQFApSFeFiJpiOrAS3uwZMxBVpNB+0tL4gkvtwyShIBtalQWX9BH/Z0lLnid7TCreL0feCFJB41gBuoZrgRhefMEdZ/SmoVT1NAS5IuvvjzvW/EN4+unkoSURe4Ujw8PobxhpLg9CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support probe_hits_wsum input.  Also
update sysfs input based scheme build logic to setup the min/max probe
hits weighted sum range as user provided.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d9147d2a269e..d9dd4ee0442c7 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -589,7 +589,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
-
+	{
+		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+		.name = "probe_hits_wsum",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2844,6 +2847,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
+		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
+			filter->range_min = sysfs_filter->range_min;
+			filter->range_max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

