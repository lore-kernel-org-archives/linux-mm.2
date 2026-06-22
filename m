Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8E2CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E716B00B0; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEB86B00B1; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B6F6B00B3; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEA16B00B0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEABF1201B6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:05 +0000 (UTC)
X-FDA: 84907763010.03.B46F707
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 460A940004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1GeE3Ri;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138124;
	b=k29B7rsb3sUtSbzvekNBSIZG98L88L6QBeUVyIJKAgQdrjyKceJoIDkd5A53YANtENS06I
	QIkFXDBxwXapsxYHPx5vOGdMX51Qh29LvoJmI9qnGANNu6eK9h1wziS0xeXIu/Il31vKR6
	HPl94QZqbutP7m80KRQ6h0DYglg00DM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1GeE3Ri;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	b=A3m/nvolJj2y2c9Hk0QyN6wkYFHO0/C8qhHKihr0WijIJApqrmNECWwMPnddzTYvgqrK4s
	FrmmCYKR9JD6z4XqLXHuYR59vPxg5XnUh6Krfnm64CJ0/ETB/C+BUVCaa3bn8A8/ljLN4m
	3DIS0RvUUTnJrr95jjjY//a0DYHdpjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D69B3601F8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C085E1F00A3D;
	Mon, 22 Jun 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138123;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1GeE3Rimhm90PTpmyBYjuH0I+UeI83Zq1rxWm6kga1EygE/D68j1xB+g72I5aPxB
	 f9WrqoyHHcxDOqkLKyKr8sVwLglum9wY2C6XlpbPxRSf9pzydo621hII/VCJVqLoq6
	 +iZmKeNu02F/RnRw1l8k1oDliYBNlcjTod07ZfX4nWtgVpkJeSlG0Ivqk5xKtPx3Fj
	 k6Cm1rKnqyd0AWggYoQzWt0HAEc9hp10YPVX0jtbacROTpGTGDixlsOdyxuWlzd/X+
	 kuCPfvZ9BePdyamSw/KzSkEZ9RjveN3pe+Ytb0qMMG2FP5i+596pqsWQ4zQ++4QTmw
	 nCjD3Pun6sIiQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 12/18] selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
Date: Mon, 22 Jun 2026 07:21:32 -0700
Message-ID: <20260622142139.30269-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 460A940004
X-Stat-Signature: edpzspbda1y31dpernzruambmmsmhfn3
X-HE-Tag: 1782138124-111086
X-HE-Meta: U2FsdGVkX1+ofjunZdx2lrSqjAgHB46FUyVfLSmOFRUeibHGpLF4P6Oq6XHm9PKg1OLHwmEfEnvjsty1LbG2+HYROsIJxzuiQap9S/xTz9+E8ISlmf8E+piVFP+LGQPo59pfD+yvukJXZCDqB12cU3u8RB49VTp4bo32w1HLWtFWKn2Jawb8+LevRHA0rhRzHrLkDNBDIrveDMF9G090EWwtMc3DlycG6UymQS28TGga6hPB5F6Ksmapu2OfXO5JXQR4q6rkvwvvm16ywEEXX1fgdyo4ADSxOHHE20TfycYE9Tx649l1jIoEZxQO81tbol7T8RBiP8pjH8YswMr/6Uht5yzrhZWX9ElmMZBgh5lYpd3bj3vrhwgBpaWOhtuBRu+nMbwCO39LtG0DtPxux40OSYyHTn0DWK9KxX2Ix+uWsgdDnjF64KMlsOw/mNJstSnIAQ+UYE3BqjvfeWGpHf/hu/s4YiK/QOf5ndMMrzBi4n5U830sN5w3qUcCvrlowoeuvlMQzf4OScl4O14wOu2L0STTr0o6z1kbmkA9sMZ9S6Hc8WYAK7Oz/IIjiBG0mAyrfg+3T6IBYVoXxqEvH5JENgxidDG3ALJoFlM2LeleXZ9CqB8k3wW9WFAaPxlyJqJXJewtVwQ9XRTCjArTDTdzj/NIejrZeTTMFBYHJHfQ0mPSOlQLh1U3dDBitAQyJE3p13HgCitzTn0slAPx113dVuKVjLXzbay/4b+jjJY7vcnIQX+cgmPvNvHeDZcT/Mgn4JCCEwTklRzdx59/vD4ahBq1936HYXQFrhK4cGth1CN5ObMcMysc9dtiNgOuPkbrq5zBYNbcnP0vlrj0dmpHSNb9QmyVax5BpxSzDmGVudQQSmflRSuikgpMn6z6IwWj45v7S2DFuWEsVI6Dn1e/znSEMjKetZGus0bsGf0fXY+szOoHua8YftexOyvk6T5vhWqKAW5oQi7F45z
 wH2n4R47
 ftKfFkiEKYipckK6wCH2FzOKIG0+Kvfh/qqWFDEDqVNTw4DM0DD33SyjPBH0cdDF6X4nwe/qpzyHDIRrDu2QUh0C9fmkewqn0WH85KGHElQkH2C2tQcvjiJjfDZgTL5KRCP7VS3Q8HAbjgiLCa8vmcrNHElwoazS4CCl/PkXePhNt1SW80sNuWrKNlZ12OnYqEwfRvbjT7Npjxrsns2/twXHN9Efr/+1yQBUQOrTNWfbP4gNAObP+nu94yBDqNz5nTGRqJex4hvEIFLP/bAmevZ21acHonu83k4xYVR/I8q3U1yVUedItsTfaANYVBZ6l9LZp58fbxOX5D7NipGNXo2ksBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is dumping nr_accesses_bp field for future use
case.  nr_accesses_bp is not being used for a real purpose, though.
Hence there will be no future test for it.  Do not dump it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 26b207e44268d..09552e91bc782 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -59,7 +59,6 @@ def region_to_dict(region):
         ['ar', addr_range_to_dict],
         ['sampling_addr', int],
         ['nr_accesses', int],
-        ['nr_accesses_bp', int],
         ['age', int],
         ])
 
-- 
2.47.3

