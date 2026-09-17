Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B63DC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536C56B00A0; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7A76B009E; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFD86B009F; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189F06B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61FCB14036F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:23 +0000 (UTC)
X-FDA: 85223469366.01.711ACF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B860C1C0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Il+Y6f5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Il+Y6f5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654941;
	b=LEaOJJk7ctA2cYY1odTNRMlQ1kwYegFc/524ifbzncewAYZKqBbQpV13yG3OTOUUm2hBkG
	GCfeBZtlcRZM1fx8V0XmJDVnunU5AZYhIazS9QWKfdoaQL6LwoJtxllKDkR9avByfw0iCz
	xNXC/rt0XKBCEONJWDJipEYyBrhtVrc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wlky4skHwDTF/HcxfK2+0jqoZPXhpLYEW64K0EJjYo0=;
	b=xe53ZALvGnWZWL/wNchvsuR3TeIklWGWR06PY5mCIS7TMg1mhVI6kbO2RHRuBM1pi9yNNp
	834E4xmedLdfm4AN8KXxESVQbaC5alQaxVe3OiibE0/pF6T5z8p3T30DuVytJkw9M8gkuG
	W+JoCgsJnaIgjq4BT37oQnN7K/jCpJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 413F760214;
	Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACFF1F0089B;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654941;
	bh=Wlky4skHwDTF/HcxfK2+0jqoZPXhpLYEW64K0EJjYo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Il+Y6f5QaMfp8RYw8AQOdX8mESp/ZegADh7Db9mBRkj6NKFyLyYsobOEuS1IXwOYy
	 GMytgLOgDE2zZ9+Xrm5+H5lYnaFfGfCw89EqFUITBdWUuOaq5PHEB19XLDKLsFGokS
	 pyMTlIvmXvoIu5vHLWB3RFxetcB2AeyHy8/qmcewoFJFMWVnjGem88aZmATDjFk9Ko
	 ZrGxj5+HdqZreGuuhPPj6TlpcYRqZhAAmZ/agJlBdxpPniF0VxpjhhT9Zzwxz99CSX
	 MVVpKsnp/mISeCRyJS2/83CtFFj21+dNMwRSJyb11pY8PSDmSDWAPN7lOYXHRw6jWZ
	 PEI+2wVpQJhCQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm/damon/tests/core-kunit: test eligible_mem_bp commitment
Date: Thu, 17 Sep 2026 07:22:05 -0700
Message-ID: <20260917142210.90829-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B860C1C0005
X-Stat-Signature: qph7gnspb83psgbiubbdd38b1k8m5pk5
X-Rspamd-Server: rspam01
X-HE-Tag: 1789654941-227409
X-HE-Meta: U2FsdGVkX1+jUvrmug76A46DLSF6Be10HzrmKP4aSU8s/4/oQ21Gx+IQkj5YOWWYZP7FHOu8Pisa5dnmpZJDpnw+wWBmdlM0wtJgJ8+mHgI2Tvc9F7vkLbU5yO+r2ca9Xu+ALgbFvU+0qzDmBCaugvBl07UkHTqUCyXEczlHunVlAKAJ+Dk+eR8Ae4T/pASkkeIz90z+OKQEO0h/a5HN5mRfk4AAHOO/hzZpNQIVYZeuqG08PjrkQ6LqzUsCaEQ1aw2qDTj1tlbyfoo6cFfCt+uF8synKzUj/hPBLQxiN8qs5tlB1ob3xZ16kQf3rWJSLEwnRa6Kt5JzjMDyi4lIfif56WjTT4n9Kbc/aVRghRI1em4U6bTXH1vpxi4uZzjdIRAu8zI3htHe0SGbKBJUo0RD49EGyuIyUIuQt5EH3GRsaEFuNb8YbLn4PZYu4TD4xfYB531FizL0t0bm/9GDpKEyqpdFPxQcz7TjMD01pNd59x5r+3LPqFAgTNZ0xE8E/rAuMLDHrVUnHdYIBuvWZgMcnVE0epvg1VN5ZGp6V4Wn895sBph5rRobu+v6A0LSDRO8bqNIIOEFcsPyuOMG69y1kHexZyFz9AP1wh50//FkkrJ+KQtarf97ne0nbRA95O6wr0TfQjXNPRTnpxXlmZpmVd/SuLSlf1RX66ZuyxVJTZSDJk/KO6uNILyP5d7dFhkXoLze0p8uUELfokgi1LZUD8gcNGK2F3vh6OT8GTMXDrhmHk4DHATftE0CDlPUYjOXJTop/hrepws5i1dDONdh7LQYq6zB1RUiVPIq9wNvGigopz0R69hXe2GINJ3vDPO5IT2A3GQcW675VsGpgCUw1idpvhSBrdgf84q+lvv/6Pyxy1exqB52Hlgr4bkSXwHhzt+WIffX1ZvfQlsctZ43NFFehD02+JcegAzxrOlRF7Ki/0ngtB47YxSkgV67/uqGfCr/hpCeZT9YKRL
 Sa4fXueg
 QPNzUREMh+1CIf8zfX9cEYCHMtyaZri8/DzscIh/Z6QDjsRs+ocFD2tDMh7qxmvZE9bh6hqalIE6pf5MP8X8zUEDb5tCUJfjrBQYxvEgCd99ml9Lu2M28GwjkJHGGLfLTKwPQJXiDEYoiY/ccdVIkc7S0dYK+d0ozFP8P07MKgzZhreFPDtARbgq+QWOsDM/VQtwJTQs+HZ4jnOlSXpLeJPlXRP9wQooBvt5sZQ+FgKpK+BVIWy2o7soCU9/k6Id+jZueltGnvM7EXVtcT7lEgAY/AbAvNzBSE7rzKebx25NIZHsLi9GxuP8r/T+hT3ACuSVg27Snu1uM9l5X4AiWaecIpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a DAMOS quota goal commit bug [1] that doesn't update the nid
field for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric goal.  Add a kunit
test case for confirming nid commitment.

[1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5da84caf4124d..1f19fefdd98c3 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -835,6 +835,9 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
 	default:
 		break;
 	}
@@ -898,6 +901,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			.current_value = 345,
 			.last_psi_total = 567,
 			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
 }
 
 static void damos_test_commit_quota_goals_for(struct kunit *test,
-- 
2.47.3

