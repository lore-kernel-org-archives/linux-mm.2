Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942F3606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S38rpy+c
Received: by kanga.kvack.org (Postfix)
	id BB6546B05B6; Tue, 17 Nov 2026 12:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66D86B05B7; Tue, 17 Nov 2026 12:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56BF6B05B8; Tue, 17 Nov 2026 12:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDF46B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:22:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F39040532
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:22:28 +0000 (UTC)
X-FDA: 85445279976.05.AD1D79D
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53C63C0009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:22:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S38rpy+c;
	spf=pass (imf28.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794936146;
	b=FLPHr95M2a0A1PtYZhUr/aJtBbORafhXCLSThyPShKK2KT8gy4Olld+okq9lKSIeAUmc6W
	RgyB9QCSSLFGGIbroK0Sbk8s84OXI2hpql36S7dltiRuIKrFTaRkqm+D+pfjqBxRUSaKu6
	twclQ8Lxc4LC4/shOJ6pIXgwNBcqYIo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S38rpy+c;
	spf=pass (imf28.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794936146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BuMdsy7WLDJTbG/fzLpGZSQEU36QGPKXqBoedqSItWQ=;
	b=JImS787RFcP7fbuAy7L2HU/cb6eeGGheOunKKOg4EXnsijFJ4V2/eiZTngI+MIW9UWNCLc
	EwTJB90NScM3mVSSkDvf6JuDxMBMEson91ASCwcd8cb3vkCK+MIabX63xI/KgHTALoTreD
	OKnydNszSZYYRssM6zle5rQBqQlOmlg=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33c10faf6easo21909eec.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794936145; x=1795540945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BuMdsy7WLDJTbG/fzLpGZSQEU36QGPKXqBoedqSItWQ=;
        b=S38rpy+chuQovkyj4tCwI0AZOpLMcCzQQG5ibamV+odq/d38vgrM4rHI14EtvL8B4m
         C/XgrTIQwqGqLqZdv18LOu7a+EPC5w2STxhM5Qd+OcHSCkBUMLW0C08q1rcOqEPkyt4J
         zZxtkm8A5EsZ3BLRDjwh/xbBIZt8fLbZSuXtsl9+Bd1Y39NanuScTooQetDaQae1C1oF
         cb5UcNhpo8eudnxrrSez6ZvKHHzlpR6cjk6KcXJetrJ3iQhbmdp5VK9+2lVZ+VdiKa+8
         mv0HkMxwXjNVq2i1pW2lb3uC3tUdvSNlgMReoKA5cm1bJQBh+5I8kTFmzyb2XI7jtr5r
         K6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794936145; x=1795540945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BuMdsy7WLDJTbG/fzLpGZSQEU36QGPKXqBoedqSItWQ=;
        b=H6YwXipYEPHcmAv7LZf/EZic6CZRszDGcThWq2x35aYvanNB1i+Adr97zyiqj2SUb5
         7jV6H6IHxdXnNUfEjV0IBVZ/iNXr8BxM5j98mbeSxs/TTnr8XPAtuLJtToNmoA+6AoSO
         egPcYFIntH57A/ufck8JchmtroVc0MBhPMGkPRtiyZkvDGc57l422JHndbhcmztoYHr3
         /3gEvk+9puGaM5ZtbmM550ywCaQgQqretMy112qHmB6HO6/39KUkrjbT0skeMsKOoy9e
         +WJUdXf5JuqNVOXazxKWAXiSApCT/OKdi8RDRJAupEgeJviturVR5QfnVF4CJrhOj6zJ
         HQTg==
X-Forwarded-Encrypted: i=1; AL+hErE8Srw8o9qcd4XO7UOPGJWvHOOCjja/kbkXfQh9DCRGEp69myEIfS/+8QGqcYt8p1jCzI60eB69AA==@kvack.org
X-Gm-Message-State: APuU4Z9kYg4j9o68NSCzmKqNFuofqkbivsIOYKYWt4qVfHrCNC8ViGHe
	5oOR6VghvlcYs/2FKLGw7n2oxa9OIFnMidpF7B6Ffo+AFwJVyKDYdmIg
X-Gm-Gg: AZFdTZf+MtusnQs6jE77l0P8LnwushcZvDQ6/gdl92WGvg3La8gE/Uoo2KIAjdCdJO/
	Gkgz3sZYG7Dt5uPz43s+Q8qJxMlaqNXsWdUotpYBTBiKXFAVLbECsX6FLt6T0RgPiHXfjRQGO+z
	xFy0vDJNksESmAuu+6C3smzh8rUNXQUidN6LcJd2Lk3BaJUf7e9hZuyxHolilNtJjvEft1Ek8WM
	VA82AUtxHpnpax+gkXkTOMvDMZm6lNkk1mwYf4biHCTJxi3LZAerWivBIur0MBaG/79WikKbRyw
	VIxKGvk1+cAXPUNB3DAidmd5Gq2DFHY+xCydctvp2ZxS0j293KHGG0oN0t2FeM1qsIr2WtakQv3
	RV4R2eqgaGUx26EtK3p49/GbT3DrAnINBUxdXy6xfWVByUiKPdSWN6kQ63/eih4VlRf0aET3Y2U
	qLuenLbWagPgtQVfuNjCLymCD7j00irvMuHnfFXg8uO2VanaWJQ1+M4pr7JLeBvH6rxCJ8RQpWB
	0UnoNpBqIBD0Or3Yx5bNenAOeN9WS//85QTBQynbAzX0Bwh7enqwdmAoPqeRPDmx08pmuq643RC
	WciDHuODkSIr3rx9UBh5VvjWV0Xua/mXdS8d2lNe9nr+Q7aGA29Go2c=
X-Received: by 2002:a05:693c:2113:b0:372:c0ee:875b with SMTP id 5a478bee46e88-3827aed1f65mr225022eec.0.1794936144774;
        Tue, 17 Nov 2026 09:22:24 -0800 (PST)
Received: from localhost.localdomain ([38.254.175.116])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316f2sm45963480eec.9.2026.11.17.09.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:22:24 -0800 (PST)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH] mm/damon/tests/core-kunit: add test for damon_call() on obsolete ctx
Date: Tue, 17 Nov 2026 22:52:19 +0530
Message-Id: <20261117172219.26725-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 53C63C0009
X-Stat-Signature: 7a9n3uj3pmgdymahxppt89a7ihy1y1g9
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794936146-198734
X-HE-Meta: U2FsdGVkX19N9UBYqAV3TlKt2aLDSwNGIFxoYKbCbe+22BSim2X3bQL23yrUcYmfkJ1x3iuww9NFbH+34q4TbPlJg5hG6Z9RUZsn/hzeX0R99S08sG45LdDGRrXCmO9+JQVmvCOg8jOMBU46sk3kRfHi1w3JnEe/U/cvpsaUzNFrJsx63bX1edgd8YUYrLrZowBXb/IUp7O5i226azgiBXYQvqhRG0heFxwcdH21MePl379d7Q4z1HixU0VX233MZD97hX+F2TlAoeCoC7+fK4tHNC4d8nW7yJdJ+EG/fAv3B/DDKjPx/kt4B5uvMJmTSlmV3wDzVYY/8XWMtW1p9CNiXZwuB1HapJFGdf/zJqUGs+BPbn1NlYOMzPdskdnhVduuq5AVcxhKkR/nL0NzHrFkOeHZ4fbZAoxh78x15n0iV7qaa/6JHxh/wqsKj4oZ5px/U6BiuVgGSTSMLae0FBkGqpF1yBYWJhUtcS6nQ79VqRXlpXytfunpVWrGYODtrDHLpXWn3ulc4r9WnEenox2baAa1mQBxCQewRYtrq3glgYnLlsKgU4dFIH6yc81N2yFEk3LotZMwLlIgi8i9JouaswE62acbW8Ese+MTpzmChBJFXZyi4Jhh7P4BVRHrZs24LbLqb21IpZqV1mC747av8z0HyJAVWOWyb9VEIttOSNxFBwOT57SWT1JALBCugZUIUyfnEJEEzWyCyJNFUASfjA/OPZPfzNYCeNiKl24X8NGPKI1LMpiF+bFehHVSamh7joCohWTURg89TV7KWx2KKLAMqvvPrlGNDyj2yC/ZDAeDsEFhD8fffYE1BMEWDyYFKI6P+5uqiv9kyVKW/1rf8Knqf5zFamsnlvvxCwl7FirzRsSyzce88KZfHXqEV90rxCVWkZpaI1LLzVljmqaEq2IK5ADVIS9A9Q6oqXl4qxHe/QrVeoIThTG9LUnkRLrq/spCq/N7etQQxth
 QtztvbjY
 em1fp82KfwD8P+F7Yp4HPLF1V54YfwsaQTnAcZYW9RwZQyPrqxpxDnqnAlaixodCJOdJ0k0ZrbGEHKi+Vds4ui2y6uBQgwpVsAHK/wMceNJchGNlpmyUwJjj8tF2X6Vycrj42llU4niIwVTT74PxWsIagtvJxqz01d4mIXmsRi0HCME8jfia6WscUkJ2dzjqUcqu/6E/FrONgIqi8JuJC7ArP5m+FqvKFKeDhGOSXYa7J44vDu7sMi7inyhikftIiDeDSdX7AZd3w9Lg7xM8LqchmQaf7wvGcRABiB0g9+c8ITkLBxv6V8jHJJEqb1Ip2HFBnnN5JD7M8afIT4EhUIIaxAzRKKJamGBM7wakCrZbhVMsvoaILph7Hg/9+Urt2t/lJ3uDWVZXDTPKizbJZ5rTdBhRYM9zFiG8ni7B+V8ben+AlKU8OFt6+0ICoBXO1RanfT6mGKONVhg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A newly allocated damon_ctx has call_controls_obsolete set, meaning no
kdamond is available to handle call requests.  damon_call() should
return -ECANCELED in that case instead of queueing the request and
waiting forever.  Add a kunit test for that.

Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---
 mm/damon/tests/core-kunit.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 43e2f950f8ff..13315291f69f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2481,6 +2481,24 @@ static void damon_test_last_region_quota_reset(struct kunit *test)
 	damon_free_target(t);
 }
 
+static void damon_test_call_controls_obsolete(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_call_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	ret = damon_call(ctx, &control);
+
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2525,6 +2543,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
+	KUNIT_CASE(damon_test_call_controls_obsolete),
 	{},
 };
 

base-commit: 72e1cd73734bc4d52affbf7896389bf3814bcf9d
-- 
2.34.1


