Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBCCC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5C06B00AE; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DF56B00B1; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882496B00AE; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51E546B00AE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C17AB1C03DE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
X-FDA: 84996387630.21.7903C78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E278A000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CqisgCPZ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	b=fvzxIMPTJ/mv4f4I3pN/NXPhYEOL1SctefzqmflFrb8bViTTQ3ie30xB/A78HOhRg/Y/Si
	Qxip0F4wR7P2YNZvMVfyIkUFuzMGZButzDwQ50xjOBNZf2G9lj25DR7GJU8KzadL645zLM
	MC1TFHKhjCOrvBTc4JgTwYkiULfyd5k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CqisgCPZ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248234;
	b=bS3k4Ii8G/a1yS8D0RnFzaOxhTsnJWKVaXSERfwrrg9AOVF+nmawqBCZYQ2/e8K3rMOJyY
	U+nusvpjhHLRmJTlY0Z7gC2DRMtxQ0WTzumnUtb4Jue2KWwjQPVeTfRpfdOg4VoLfFBtuU
	RAq1UZHLZIRrc3QTCaW0vcnMymmRq90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3389F41951;
	Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50681F00A3E;
	Fri, 17 Jul 2026 00:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248233;
	bh=BYUt77gOaLnD9RIh57O9y6iLCV8DgyWvyhX78FkqqnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqisgCPZUl48Ou9z48ijZHhC5VH6czNR2JUuXEuTjLYfK+ABnTZ1WYUSJBBEaJViq
	 8rcL20cpZE6eakFxXsNYDoCnNmbsUQuBDPFL5BJBrKsm1n9bNaN+QMZc39NeuAQ6Q9
	 t86qtkDK9Az16D6N8+psM/fNs2WLzHfhND0FtkqFUfUTq7RdNMJlHpKguDa/Qiwrih
	 Timl+MUwRCOrDdUSg1dIKaGW8mDwEGssjBW7epSJimjnAvHa0yuFAZDKkBgDfpAQ+P
	 nRzjhDyTymsNH1CqxnykxkbQbZE9DGveByiWJjSIMkjP6TNkAAu0mBTeIJ6jMXO3DO
	 w4dwIU8QJYudw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/vaddr-kunit: check region count in three_regions test
Date: Thu, 16 Jul 2026 17:30:17 -0700
Message-ID: <20260717003022.119437-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E278A000D
X-Stat-Signature: 73oyw34oy3c7xyc5fx9d6rhk1s845cpe
X-HE-Tag: 1784248234-885226
X-HE-Meta: U2FsdGVkX18TR/CAjvNdRyV9ZvXz9hGCTYzDAG8z3Atfy+2VeNjN9SidBmZhG76HmHgpv3CqEBdZ1WdILqtdddPVP/ukOwKUDuVGQujzAB5Mt5C1ZsuD4ZsugszGmSd0hM1lRtoe3SZKh+30/Qi7B7IvX/l9tkR7d7gUTwoERVOv2EP/2TOjVYsIF3kHc9ieU8WQgb4QRmM08smVXOdvF0gkLbPXUW/lGnKr+FiamrxFNRb6+e0jyCnpe2gavAOpA9xWZqcDFskcuG8sosI3h85xjj+XEQljvqzA21WeujIG+yCnpzQ5R1HDc4TP8hribvLZR1f0Ve2GXTQCnHHDYopfPkZG+miuXluRkgYYG5uMCaD5OMPwtBb9xCosZvz0uNEClo+84NrdlHI1g+qtsW5lA6kkTL9v6gFoMfb9iXKkmiTyjQcRuw6uSolmkDqXEvOwEGVZyx3pCjVtwLdk9GkH8KYluib7qheBapopeIUnQAzfwchp1aHkM8Anb2Un9m8FB/94kwTd003rwhcopDmoniSs1DnZlfUA2Jtj594DGz4yJMM+q1a80VBNUG3A563yQdxMnmEhXcScjOrhcZDu9f5mY44MWjBCICE/etHbipVCM7ssQ6s2/dm4QNcdLQWdaqr5DO63cemljF56El06R1Dbt+WYlsjH5RCl/N0mr+Cy9ptunK0Cb06V4cm0Lz57gE9VFUWDDi2QLfBnNZWKaDheYyDGaoj7gn9s+W8JVjl3LzNJIzB8lWu3WRavt+dwCSLYzJhYvY+XpLEAZfsyX124gVmifJdxN9YpowfBbaQbWZyp2+qMyvPJLE/0PKj58cUzmWKu2Pqvkud6p8N6hErD4WuwLgKjXO00JcM3qIqsX8QfTMhJYiitntg3sTH16eWaqmD96wzT8ndGtK3UlRDEc23D8+uSv1ZVAruiAb6ZjpJwnal6fT1SftEM5FSmt82zhGh71Eg8C+i
 JyZX2AXU
 km+e5rEt3jwbERKNAs5cw201eCaVCtceV4AF5S3ia2ac/9vAmZmfdFFu3WSSAg133vzcGgBH4mT7mTcXFeR9qVVOB/pIJlLi35mATaF/l6VIRa4LjSshLAsF3/ZGAajARuhp711mneON96nCVQaG/Byv+f04PlDqJOzYlKVbmMIlgUMcfP3WV6FrIN2D4ElMjfOyhc+ZfhYuwTSjrZJS2aQtmVweSBHMySzFeWlV+IrJIuMiCR7j0y+PLXIofway13m3+kCZb/feT54U0u2A9b5XvlbPmiOuAX3qobgoUx6LLYG+YNhca3f69jpW0ZJJGMXne
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_do_test_apply_three_regions() iterates regions after
damon_set_regions() call assuming the function would succeed at setting
the number of regions the same to the expected one.  It might have
failed.  In this case, __nth_region_of() in the iteration could return
NULL and NULL dereference can happen in the test.

The consequent user impact (NULL dereference) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 61f844336ffb5..6a95441d193ae 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -158,12 +158,17 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 		kunit_skip(test, "second damon_set_regions() fail");
 	}
 
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_expected / 2);
+	if (damon_nr_regions(t) != nr_expected / 2)
+		goto out;
+
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
+out:
 	damon_destroy_target(t, NULL);
 }
 
-- 
2.47.3

