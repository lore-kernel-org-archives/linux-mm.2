Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09BAF44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00896B00BC; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D445D6B00B5; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B967E6B00BF; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA336B00BD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DCB0BA09B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:51 +0000 (UTC)
X-FDA: 84642857502.01.070AD6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 975002000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VuGsGZkb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830849; a=rsa-sha256;
	cv=none;
	b=wrJWckVd/h1kaOL9U7D6RJcJRyTloKSReEZ2c6UXriLamztSfqBdJV2788wpk9pWhaoRXm
	ymCGb+17riUrPVgqFqgWM6ATpxPV1q8iRrHjJbwIDY/AkyhDj6w+coVDWKs89NeLqkSnBu
	/CfIjSfyqNo8VXqOa4Cf9uADDvl3J8c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VuGsGZkb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=v09K9NlmTHtHNeMkZJjUDvMBRPZ9SAi37weQW/T1/oo5P2rClMR+frW0V/Ni4hnKA8Wyz+
	Ia9hRmIzdhDKCHwr0bE+k2mn+LqIF1z8lAwfWlbfvB86wFjeLDprdDV1udfW1cGV3Gx159
	Dx/V8Y9x16zsF8WGpWlLnU8rEHOz2VA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE154445BF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74922C4AF0B;
	Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830848;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuGsGZkbe1hyR3qzbqlU38ZYoXwXJoT4kYB4ZCGYtauU1lIdqm80Tjr1DWCcZcd7T
	 fHwb4PVQO+JW+f2fNJbJjlnHTQuyd0RbQONudS7qTdZgo7hc3fr3j+ak6bYW/iSpE0
	 5V0/Xo1KEAvRTyJHbU0yMQpF0A9qXDIZT0+9Ix2kvTk7nhbas0bVUh9/IVmHxs1c+Y
	 l0b6txmImREDfHCT6qd7r1lBz20A5Thoflf2H15FPLG6ZC9PWxU95tcuFEC7Skflv0
	 t6T2oaJtGZ896sgU51fhPYMiwoE2oOM18UQPSMY7FuAd46rZSmXUevqvdVbYOb4nm3
	 wTn77/XW68ZYQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Fri, 10 Apr 2026 07:20:31 -0700
Message-ID: <20260410142034.83798-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 975002000D
X-Stat-Signature: uay1he7pnzf4dydb93xk19f4mc6acj6e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775830849-69076
X-HE-Meta: U2FsdGVkX18+FDQ8y7j1vTaSu79X+jiaPwmshwJqYiBgs/km0BMx80/qEOUx59YrIWlsTAUTathO75RUhkwICqyRIapLsiDaHkRbB2IhWmvCqotu8oKiOluDQ2LZtVX5/fE0mw/fZfmhnjdIFL+FpD5tCFvu2TLfjMefTQmu36kZpR+RAcTUuuQiBdhncJELaFqeBQJMel1Pfn8OcnSNlBMkpA+3dR0YLfqhBfPGGoDafyWKdknjeD4gS01YvIu37cv+/MQg9f/bQN1Ff9r5do/JWVX8YOncq9m9UiGrRVFCbPiHjvN18Yx55nfyFzxjPcU5LU3SZ5cfizSQ81e6LxzXX12NOLa9LcRMdOfjFBz78RUv4xfktqno5691StILm37vZvG6wZ61s9DPkOR17iYtac4w/ombksTH1UnRxw6fm5//uy0ADtawlrXCi+qVOMQ74oWPzsEyFwlAKP5QAPR/xihSEVbG18PBgFIz0BcBSaJd+VicXGLTfqM+jFtvHT9cBLJrkSYx6f1aewj9sG8G3aLF0YfPCaY6RSkWrjF16yifQMhV/+tz9fvyO0e00ZJh3NQ56uoK1B8qHBSKlUKNS+mL4WaDOu/G12jd28JUUjSI8Vn7/lp6UvSeHUaSjlJqLLxos5Fp8uwgFtrvRKNCQ7E4AzAUV5grSmjiS93U1bs+25L9vd0TgsnJxu8SUm/zngcxf67v80kMaTn3FMBRUH/NbniywyOehGbjyo792KtANvf+Wix0OJlRydK9QBprB85oOJNYS1DqqtuPfP9HaAkO+/KF8ULt52g3/SSyzYhp5OxXAHlOtqwsJX8ORbwIcPXGLx9XbNef1gqBFlQrHBO1YDB464OyOMTYr1fS7K1PzRFo9NDhmMJqcwPxXPKpPr3b/NUm18JZK0gBMAV+Npjin6Cycac9oOyVlICxbC9heV79krQKAFHbWebCIa2ahpKFGzp2BQH/xkx
 AAMpynE8
 YCQY5f4UoLChAHwwVUwMilTrK/H9y8cBY7lMBzCn9pPaVjlWHUk6RGkHmDMrb5J8I24nAbyxy1mnx87SDw6O8Ce1jllMF3Fa8xYiocDke5wpVU145XNmxBQ3kliUzmSKGp9BAQql5lD4KuUdSQzTBiu0qqMTTnOaK75YKB2OanMOPJQ0CKP05NCTRfWv3wwjq5Ul0lJV4tR9s68oPsfitYMHXBbymzmqPDI5YT5Q4ViN8WekbMQ5CVyn5i+gJ2UFSKFHpHTdkA+bKYScG7Gz5JSb3IiHZzvGUeEBoTgCYDWMlGrsX0cCtVqB8+sJ/jHP3UNdz7P163Z6jGnJbyuIy5z7yef4wAmY/Mfh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump DAMON internal state for DAMOS
action failed regions quota charge ratio, to be able to show if the
internal state for the feature is working, with future DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5b90eb8e7ef88..972948e6215f1 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -112,6 +112,8 @@ def damos_quota_to_dict(quota):
         ['goals', damos_quota_goals_to_list],
         ['goal_tuner', int],
         ['esz', int],
+        ['fail_charge_num', int],
+        ['fail_charge_denom', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
         ['weight_age', int],
-- 
2.47.3

