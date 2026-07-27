Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBE2C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8157E6B00AF; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6665A6B00B2; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5076C6B00B3; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1610F6B00AF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87A5114076E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
X-FDA: 85034812590.26.755FA2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD9CB180004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvnecD8j;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9G+NjVl63rSPH9VnWm2f5oghlS13iCb5rZjc3IcuDc=;
	b=3v89jX3dHanEoCyD2nrF8miJkvJfsJzbnniyZ49FxoqDrTT1+URCOCzc75gT1eAiNxsdtH
	XeKOocHBV9z7IsvKlPYmZslc0nSSW2NfS0qybT5os4V0WnrLzv3uNLZNYNMrW4WOGe+8Wd
	bhgGiIxzlHV7C+U8O0r2zf0R0IWQOhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163113;
	b=tRBZDp7kZT1Rmb0TptARjVJMTHUVmFDzRSfv5luawakwYjUPbouHhvsDM3UL3k8jo4Jp4f
	HP0hynEgFHEPmtIUIMEI6cjiMIuQgfSgEZAqhN3Z2P8wT4jVKTXsp120o2yJYM3Jj8qXxI
	0mP0gopqvPBXz6eAoYaw16NOAO3B+gs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvnecD8j;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B2B34044C;
	Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED10A1F00A3D;
	Mon, 27 Jul 2026 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163113;
	bh=g9G+NjVl63rSPH9VnWm2f5oghlS13iCb5rZjc3IcuDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvnecD8jMTPG5fONQAI6m6r/a5uh8hfPwMCRQ0JpapBOJOQU8SLD7qYcx1FqqCQjo
	 HwsSTc4AYGmO0I8IQxL2z84PH8O0U0iyi4cQXxo+39d5ksIiejdNSyWFtN9tplCAbi
	 h/8tYiwgy+s3t2a2ijzbSZmtxR1FdS/hEjBasVXkQ1Fsg96q5+6HSYQY6w7h0KkACp
	 RLCXz/acniIZ0jobh894cS/qlXhkesq5cm1CWFV01EMAPT1ObYZ+baL3etEIaT3dpH
	 OqF6SPYN23SXVfkdYUGORUjiOR+C3UxZx1Q+esSKCS3hQPDZkgr75BMZSz/xWMR/Ej
	 9USRBVfXO5MVg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Mon, 27 Jul 2026 07:38:11 -0700
Message-ID: <20260727143829.86236-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qj5x7jaqhjnn5p1ydah84e8btomkdzmb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD9CB180004
X-HE-Tag: 1785163113-228852
X-HE-Meta: U2FsdGVkX188ov1zgxq/CJ4G/lHq/Eb10mUha+rjhEdA5l1mrTA6eiItqO6IMcHQnpkP28U3WOxeV4MSbcZWLCovs38atFJAPy7z0PxfKyDAlnQdGjQYNv3rSbPpR1+OuIA49tgh5XSIbKpo43O7N/i7RTvmxAUwBebGIr3mlMnCcrnQIGu/wrnAUfAV2g5F4LAbljkx4BUAKNkYO/KDiIccOFSdhxa749rj2LpfcFtaNx7fXWlIHc8BEMEZ3Ti9b6+I1EfjtHN3jAN99RgEVwaTaBzda08FQypMeUoiZiqx8J585Z43g1G8dShgQpL/zZ8a84dJ2LkhtQYy2s+9jyzCNNOgybXG0i+VdjWo6SDbfzhRc4EnXKxQIu2hhgIKrExI9yiHDC+sbE7V6aKXvnxvraCQj4su6z5Nj7LgvBDEanNHEzO/1iZWEUg8L/xV5x2rUhk2RRFk7f0owB9JehMa6wt2uWZ9Clvwczrcxy5hbLC7aLulH1jXpZxrHgVcIzEEZMPEB/Z3OYPFOwW1IzwZfBf4g5L+0g7SDG9f25WA1h52TweWdzIUOj4EelsbOYglFvRO7gWIt9pR67SnE7aD1WRQa+L6pfwZIha5yW9sSpGy4l2Jmlvs3Vk5P+C8f+gGHrt4aYpVVQRt7As70MJi2gG9/0bC0oKJNyEdhklteiad9E6u5FhVym8AAlPSycTIZjW5ePQ9A/0eT+dQTriRcOpRZv0nSCaEzDQYwoNnimxbTiYHpojrCA0jWBIqv3/2fqEI4Y3oGI3Vgc4VZwCxC1Qmu+L7cHnaUFOeFiRqE6/lx+TZvAc4TPM0AJDCqN9QZWaBllUM+nO2Aq77eIJr98H84FsDZJf42Y14+TEe9EyxdrHIfK2f/f/VTRfxKu1bC8cGepEF+vuqJxs8AIEiwvuI7YdWU1TjTbokIAHciCOgZo7PKQ04pqzq9/5PeUT8/eJTASVfl9r+JSw
 1k0ygXhw
 1o/kLuhWLXFfAXB1kmvanozyVH9Hzfo+wdzU8Up0sr5AVFBJwXgOISlKLh0tvAAJW575wc5eTMXnhkizmYtITGaslsD0SrTC7Q2E7luGtjaOTttq7AVqQaUxAEmKXukUQ5uq0FSxqkXB6O3InKU8xtft8fSvyciQPjCOyjBTSQDu0QGydXhsZIxZHJfwRKK7ujitIthbv7IVEJKAPUoaKiBagP0tCXEF+RglFQ3yrQTVOXvf4R90f5FoanryLHClIuei8drdsBkahoMJ/uWilVnQuieBKhe3fNhRncYXMz9LBDeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(),
which was being used for access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..5b307dcbb2a50 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

