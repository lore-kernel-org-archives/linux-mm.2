Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF9DC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5438A6B0096; Mon, 28 Sep 2026 05:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DF76B0098; Mon, 28 Sep 2026 05:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344DA6B0099; Mon, 28 Sep 2026 05:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA336B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:34:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96DCA80156
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:01 +0000 (UTC)
X-FDA: 85262659482.17.B79D0BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B70A20006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBYTnntk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvxZAPrh873tByEC/VSENyOCS06X7bQblLdWzpYhHiM=;
	b=DB7KpKIsdUJgC/wCA9nPeolL1h+JjLTIcJI+xP4uI5fFHKkZjWvCTBte91Dwk5DofFXk5v
	VQPkwgStvpwXlcKdQW9hi/5U9T96179joF9dWjVsu12GttEUC7rpvRfdntMUxovhL8Xak1
	ulLfjjRq2/ZNhFcl+PGX+ue1TurXP3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588040;
	b=vB8h8lHA9wxlmtk2lYW24fRuQrfqn08WTBDPK9vnizaGO3THDNDyubTH2OvPRpGdwPVdiT
	p2OgEoeVG+Z0hZVIvQFd/AVqOV8x9n8AvFXm7gMO1ik8ip6kUv2NOgZgiE7R0cvAOWjBFX
	oGK+tiJOVWeU1DoN2sh2maH3LY8S8io=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBYTnntk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2944600D1;
	Mon, 28 Sep 2026 09:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C291F00893;
	Mon, 28 Sep 2026 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588039;
	bh=bvxZAPrh873tByEC/VSENyOCS06X7bQblLdWzpYhHiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBYTnntkncMsChVyMJu37KR6cC45yYnLGJ16rQWkS0H11rc7ApcXxyQeC1g05Vm4h
	 2O8AOpqSLg3yXcuThqKfymMbpru2pSBdnlfZZhOh/LciGiFE/urZErF2O6Xiba3Ob4
	 hOrF5btSePr+E2Us3ViLVWgUCYR1bFxessGdeAIbQsxsWEC0Ow/SIxNU3bZPUJ627M
	 mgIiCflTx8vx8jPKM4WFBjfSX9N7EAlR5WXYywdonfWJj7Z/aDb96nwf+bbohPLI6K
	 spm2IHi1ncYXUEi6DmeR88Sxrp5ZWgyLhiSgOMUwLU/DEHDq6rytfaZqySrlaXGpuK
	 N3eVpkMPvZR9Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 4/8] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Mon, 28 Sep 2026 02:33:36 -0700
Message-ID: <20260928093342.16584-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B70A20006
X-Stat-Signature: kd3npj3t4g6rggbnbiqccz7nzycxgqfb
X-Rspam-User: 
X-HE-Tag: 1790588039-697121
X-HE-Meta: U2FsdGVkX1+hOE8U5ZoBDbEKveST5UGKyIgen/pXlY9ZVqxM8+gfA6rRGI7NX3grQJI3IfXbxUUhAKY9689+imRicHN5hWY3+Iz3SrMUab8USDxekiEekodV8CQ7N1JJ7+/suVvYOVde4jx2nDWglOpsbe7BEgukY5+a5B9xhEHQFNO+1U1X87TwEUQsBXWjgLqEcndo7VgzJJJGMrlpuXjFLO9g55bdKVHxMGMr3XgNiHyOrsaMaNZsMpCn0NeKnh9+v2oGF0Cfnut8GeSs9sy1xzod1tq7pSnSX7qWODkvMaBpRiy4ykGqpQuhAQTaYSVNE+ZbrJRZTuEMTSz1whhYmqkLc8SefufU7rDTZL1zzPwkvR5ZT65gIzjMRQEO6qwg3QKDvPBTLgkYDG0u0I54g5SYlBKCNMtxSSQisElxHXqe/9xOgvvWsvLG0xeSAYOwSZ+6tZNPnjMGIGQdymkUYFVuEm15QOrLG9HbNIe2OlvjwFP7XxcRDRV6h1crLoVNcRvSKm8lGadKct0kMac8g/XiC1bLZgj27Ses1VxcCxDzxce5j9lZU0NZ03JLWBvkYk0ulRoKZyQxQFjkg/eyjX/7ac8gSA/5WezSNpuXem6sf5NgiUg6q2bXeQtQRvUkPs0pHRoNaqA7hKK2r7oF31sz8MtbBCZoaUw++EzaF4wyNRZidjUGqKKAhG26McKMs9ZzkhSENcVz7TKHaqE2+Bgvdp6BNwXZWfKKTw/eYRr4e8aMkqD7lCYvnAI35qycrJ5ulQjaRhRQsyqUNHmIapJfynTIl0skq3F+bVyIunGeeEiC9T9Qimc0i2DMaBbZkW89RROzCQhy2XLoLGh8RucyOUYd5EngNboM26QRFiAVLbX/eurEU8cnst8ze/KeovhkF2S6O0Ivq2ghqINPob8WqO4B/tzPNK0OJ/LqN1c4Q92lxiSOluZzhcUubva+BAJW5uCq7hHiNR0
 Eld886b6
 W9ROw7e1dnChCY3TrcNKNoOLondHFSmPQg/1dUGM+b0GnjTelZat7KMA8sR4H3HeuXJ3qC6leolD9vpgKi5CVrWOi9AK7U+A8W+UZDnObbuHMmwFNtTEiYrpMtMZ7etkUIE5jSsXkM0P2AzDPOboM/7+5JNYOYr+f4jzcWpcx2Yov4BfawrxO97+go5dtRgTc/K+1B6GI6h8OdyHET+nct4yt7cg5aeMGx1IxA99UDcn7+LsV5dgbOAHkS55ifTDI8hIpAkPni7x3G1k9/IGL2AR/QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 945037fe4be9..251b300eaa50 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -819,6 +819,7 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -862,6 +863,7 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
-- 
2.47.3

