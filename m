Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1201606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIWzwWnS
Received: by kanga.kvack.org (Postfix)
	id 13E196B0773; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C80B6B0775; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0A06B0776; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF1B36B0773
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CDD940BF7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
X-FDA: 85470415758.22.EE266ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6CE321C0002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIWzwWnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534617;
	b=jhyonCNTwyvbu+hKtEnnD5+Bm4TI6Y6qmiETDus2ImeAxMuS9UL2Kurr69SszXHhnujxV/
	RDPu9CbM5FezX1AfiUo2COmjtzR1BSlugnJ7yfVqhtg1pDKlGWQ3ayLI3bkOweWJh3g+yS
	9FWFWfbQd3ifVHMWJImeO5KyTngZSdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVB5moYYD0/ARci2kYFlEjA1B7l4e+j1avzj4BHQvUQ=;
	b=B85P4x0LpYlODBAGBApEgetmCMVYdUR+/0bB/ojebumLMF+xGkpr3bCpcY6bVue6DD280E
	WGe1wMi1oDjcDoJSnyIWvyWibOvsyCIXrQIcVRAH8EGH+6XGvCfvjwa/cM/SQ7Df3KKvIk
	rq39G50fMNreqnVzYEOMlCCNOcj1hdw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIWzwWnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B06D840166;
	Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A741F000D1;
	Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534616;
	bh=aVB5moYYD0/ARci2kYFlEjA1B7l4e+j1avzj4BHQvUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIWzwWnST2mFJ9q87F1y433mV9g1P5frkW0/lgnv5+vQLyKUzWJAstgRvZA+cJ6MK
	 eH12Tk5Gce2xJy/NzJb2SmUOvHQynWWgOH/OMb8z20Zj4qWg5YPCzHjD+oPNKnBbjd
	 0q1NCzsOpvvoFYsdrhbpMUzycfXW1OjN1A5YcqnkZOOsJcYfJ/J98LA/7jjRhFCJ38
	 ahlg6QT0f2ILf58YNKxUOf+tPrGts3IlLT/XX/3PvIpBchaT804gweSonasaB6nFXM
	 ljDgZzmmEJ/Orwx/IyRLngbX15GAqoC7VLrXUve3LKFKqQPr+brMOQSFT1pp0+bcRR
	 lsnXoQUl6oWrA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Tue, 24 Nov 2026 07:36:22 -0800
Message-ID: <20261124153636.91854-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CE321C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n19nscz6x6euejfxjha1gxbdiprbp886
X-HE-Tag: 1795534617-858031
X-HE-Meta: U2FsdGVkX1/70itLJx7VbEixrR7n6psrdOm/2rbmoJyIEWnXeLrbCWft/soN9H5X6qjbp3MH/nAJoZpJ8DOYz0YtineU2GgYGuVKi9nfDKoqDNrRXqOzcdLP/5YUTa9GdbBHEyvnD5lDlBtC3/R30Jh2uL8sMEfYmK0KWQpptwAfQJdx+l+8XzbPm/gVYonETSeYAYQubeLVPJIomllP05m4bn2QF00GbxXczzO+RL4KNUXfJH/CWO42lg91uopeC4MQwWWh7yZ3DWuHfmvEnO07Z6kL5CTDMfY+SjG9vMC9OTHdhMhckLSZFF2qB8LPTQhT3yOKdmaHbGKIotC1t53qFrMwaSJHVJK6v7EnF50LttzzKFYUMKTs5cLz8B7RYYJIfamKaHbj1JarATfHogfsFH2Q9I3BBjANtgTAgykMAwFfwhcSLfkebBPHeQZtWHshij9T0mFPHTzGtBh6lujIpRvvQYL2cXMSSRQzrd3tqVSSrjr1AMwa7hWC6PM4fMfFB6w6zmL4HgvPFDJw5EgBkqNUD/wOZCvHUb6nDv+qKJ9e2gbSgJ6FTK0w00M4jWWBYSN7U9zpUPy1w67QxlSa2jXBIjqSDzmqe3MMDFCREfOvX9Lp+6EPQZIIIseV4FvHq9b5eW4WKLrZnW7FsoaUc44+oudU9DwIzaZwD4D6PgXyGZXWEs5cQWgnXRpYBUdWXhxr1QG5zBepN34ABDMHiix3ho2FkRKqiNBkgPIveXDBLPfAvXJUvErjWk3ONVpxFU3vBZZk2k1E5eqglV6qBoTB31Cphcgeek764eonfdMBPQUSHzD3Jv+bR/3MdE26Jq9HxlSum3VmwoZzxTYRWBDWvWTp3fHJJR5OfBhhVoM3LoBbVgFQxrBKF1t1RyJafQZHP86VU9fqbaN9bbvIaY4WxUrFGvjatXmGRZdPn/EqJwljF11gw+qCZ+aIqcPEbtfdILNKcVoBDQI
 CQZTD2Uo
 LKO+xoFFfRjZYQUxwp/YnDFbF2GbBdq60qRt3ygCX3OcAGHWJijQ9lfBtrkvE0M8zRPxP/6cZyKCBEmuJBXFQ0HcB6kPxzULV8a1jwxKTYyd+r1KNSwR95vrj10zvMthmUF7JhqgkjHIaKPqG7YAODbh6Sxsgr+mV1GiYg++bYl0TGDdCeAFaAw/A69jhXUI0rv2UhTLq7LZfkOH67unKeetoGqlehskoojAusKldcGxGYG0vh8U5PHz/0XPjzpGgsGjLqw6y19qDKfhpy/u9AdhSyKcC+oo+En9FHynWOydm8svfwrrN5nRP6V+7AO7WPdAQtawMvJH7M7gwelI24XaLXstVm+W9G5nyRNFxYnpmwR9iSkRb4CDZbwrpayPccbViu4vqWAQ09XAHcpYI/pgngQz7PxZscIyTW7HPrcMnYSh4pJDN/oPJ0E2B0s3DMk/7MXYwl/1ZT+NNm2Vq7f4tVbOP+EM2jt7sBmzwrOy5mPvgy+qfulvT9nu1VOa8v6aIWJTnbHa97ERmP0fpAnjSbI7+vHw24MZngiGNSEaZwZXOimeZcgb8XZiTRuNZM8iNIPmbmVGuvSQfQUByZDT1rDXb6CmYBK8ruWiTjcN+0KadodTY/ADjOutL3xi1CwZV9/dFe1fQzkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Accept user keyword "report_made" to probe filter type file.  Set the
damon_filter->type as REPORT_MADE for the input.  Setup
damon_filter->report_type with the filter_report_type user input.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ca971cf1dcf6d..1c171af4590a8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1016,6 +1016,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ACTIVE,
 		.name = "active",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_REPORT_MADE,
+		.name = "report_made",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2336,6 +2340,8 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->range_min = sys_filter->range_min;
 			filter->range_max = sys_filter->range_max;
+		} else if (filter->type == DAMON_FILTER_TYPE_REPORT_MADE) {
+			filter->report_type = sys_filter->report_type;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

