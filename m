Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D2BEA4FB7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29186B008A; Mon, 23 Feb 2026 07:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3C66B008C; Mon, 23 Feb 2026 07:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03BA6B0092; Mon, 23 Feb 2026 07:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEA746B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:32:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46551140142
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:56 +0000 (UTC)
X-FDA: 84475660752.10.20EF723
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf01.hostedemail.com (Postfix) with ESMTP id 75DA940004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bXxcG4Cf;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRjDZcOUW3p8fFG0+tNWgPy65ed/dP2/X89AKu5rG9U=;
	b=QFFClGJGagsukMgTJZw2yITPZqCEyi1w3I4fchZiqgIUEWkkoRs0cOBBW46YlIEg1rswev
	XPxhmC901QJ+YWzCZ9SpheHuM/i1YjJWxMWrHxSQT7BL/gewRJyPlt+acN2OMwbMXA8ynH
	nEyH7JJsx7KzjxxGAQ/n2ZuQDxDQJIc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bXxcG4Cf;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849974; a=rsa-sha256;
	cv=none;
	b=bHC8tPCfJ6gJ4vT9asEHXU90870n/3Cc1VrSjQkNsNLeNQduxU5TLG2u9T2XjbVcNUIZqM
	NDkDaiV3beeGYGfmmJFvA9858uGIXDddnEstdXV8lWtyDX7oo5kSZvLxXJ2idAznJAPnpa
	zj/NCTWfVggqIzByu7ZxwCYMG8kKhq0=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c2af7d09533so2869780a12.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771849973; x=1772454773; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRjDZcOUW3p8fFG0+tNWgPy65ed/dP2/X89AKu5rG9U=;
        b=bXxcG4CflOUjpAG190eBTo+Rsp5R3wnciE+YnZjgSXksxzUEqfhQgZ3EKD8a73Tyqa
         wL9VA7NIUoKMapjD+WYcnamjGQr8k6Du7PHDwgYrau8HYd8MI/XRjmRtebPwytINTvHt
         W/MNH8rsOOzNY10RtHEfSGJk1LT8b63G2XieWo4U6WHK0uLph42OfGz3BGQDV7AggJKx
         GSx3TjZkzw3wK0L4TewH8ZybFGr3d3UJGKzsC2yDB7PHPBqFrG5tnS6zmHe2Ard0OkX5
         P+Wm+QhsRyMhLyTymaJu3hOZN7iwqHCP1awG3E291hT5XNQUHcnb/z6XcHJKvqFoqEXp
         c3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771849973; x=1772454773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yRjDZcOUW3p8fFG0+tNWgPy65ed/dP2/X89AKu5rG9U=;
        b=mmz8+3jJn4HtT5d52H0TOYXSEG9TmwbKhLlqp5Pb5d+SnoLxcePtwTc9GHEtIHTG0Q
         z6Q1QKP5NC4kmD4J0+rLGWbUvf/kHlt26b4D4ijKR9ObdFXqNbKegEzYGL2srI2p/TJ0
         WCAOgd0G/1JV/k6vuoVT6IpxMMzJjZzUWMfaaiF1nHOD5rbzch04TT88GNLF7lg96BmE
         TcHkhsQAYxTjgdl95aV6fUrVd6VBEgkEGTP4449x/8givL1w5S7hnyD+ROYQWNBw8hS9
         DgDI5DmVe0dM+WbW1vT+I2Sne2limGK+DPEAQ9JDkfV6NHy/wVqpJe2hRbbt30HJ23+M
         TzeA==
X-Forwarded-Encrypted: i=1; AJvYcCUY/4HYx3kdvrYRRo8plVG4RVz6O38n/NDydwN4w98vHCD1CQIy8uwt5tx/NK3XNU/OnSq3dv5yxg==@kvack.org
X-Gm-Message-State: AOJu0YwVj3cNVERyogW5QURm0vxJfaCq0RHJWpUnhNwa7WvrVB5vxFPw
	1pUCh+wTbLZQ7USDNjH/ctVVypekiPh4ZBoZhH4FngG99xXbX5KD/qQ=
X-Gm-Gg: AZuq6aK0Ymgz/apGZDeBZvJYLm4FTvOyRHrTFkTese/Z9u7nYb3aF4deZKAyIhIYPYW
	E5M/4+RNw3i7NavVR6w4jbb9kUe/BKLgVzIJ3mTKmaA7E6d3g1Aqby73UknFJytbhJGxdHKuN1x
	//Vt1vo+jUIjIzaO2UsX0RgyuObw0vN7CYG+3R3sfLna3z/ayLZeYGJ7pME2acIPahtAmzfnaVQ
	+jkQdCgYI4TYizIlTyeRwt/GsASEe5GTrECgCX2y+3dxifPmDjcnJaO8HA6qw365Zuwp6nUb8Y2
	BrOb6DOMS6bsJChnSeYl+UkLhbZC8TkLiNiO8xO/AtW9k1QMZogbfp7Em7EEIJBIQK7O/s/T5gP
	tz6VyKQIBXJjdklAbd1VaRI6omuagWL7LRgkjiW85YlDDyrxCCc7QPSre+2K5ytnj/LIIgYEH+P
	JTKDx8MnbvuSmfEouu6lGcMRZjOI4Wn9Igx65CSUS9GEjF
X-Received: by 2002:a05:6a20:d80f:b0:395:291b:f555 with SMTP id adf61e73a8af0-395460224e4mr6425517637.69.1771849973278;
        Mon, 23 Feb 2026 04:32:53 -0800 (PST)
Received: from LAPTOP-FDBL0TVI.localdomain ([49.37.157.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a73e1sm7454739a12.13.2026.02.23.04.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 04:32:52 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v3 1/4] mm/damon/sysfs: set goal_tuner after scheme creation
Date: Mon, 23 Feb 2026 12:32:29 +0000
Message-ID: <20260223123232.12851-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260223123232.12851-1-ravis.opensrc@gmail.com>
References: <20260223123232.12851-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75DA940004
X-Stat-Signature: tst16fig5ez7nqbbim94jhma6kxf96nz
X-HE-Tag: 1771849974-363504
X-HE-Meta: U2FsdGVkX18lS50AafCoYHxw68ZGL/QktGeuPYhWUdGYm0Lf2iUWHhM7I/2f2LPE/zjO8sxWwiM3tlvKUdhMD8OyXghNNJFcV7JQWW1guuyyz4dHmp7DLMzN0tLoVdCFFpEwKKyJdtcfwflQcmcj/eofKYGPtdkMCXa9lNkH9I/b3TC9l6Xa0/hJoPtz6hhXbl9etp9trRjyp9ZCK0LIbhqim4oNYua107Cl4MXXrpj+6UldzkdQiG4rAfTjXaBo7c8faDjLIUmoD5dkc70VqFSzoY18IEIn0NiwYh4Vbk5uap4HhAi2NJI0+4mGsL81iw/acqUCI84brSbqnZpBIP0fT6M+jvcHzYH5CsE2syqYHFnTNxzC1oCU8ppiBX/7k3iJgufrOanvbevZkK1+Z8grZeRs+UL6NDeJGABG43cFsqP9u9i1JxexNyG8Z3fV70dcnV8evdV5v8lvL+ETld8vCaDDCtcX1Woo/QJgATMrWWLKBL9kk9tDPLUrKgXrKd/pRiiHZmlBMVOJvAY6KeElRoE3wlS038sq3QjqJhZPWMbSy9OJ0KXhsNogeTaXbB/o/zSogzPjldxCFW/0KIcUfIh8gkv5NWVo8q4Ha8GvwlzCP9rF8VoNlciEvRql239IKBoQ45IUFcGspoz/y6NBeRJ+xYLxsp/wzw2WOiCvsI4xtFTKbf3ARGpJCS0mQfz+JawmgNeUWuR87VEaitdxrBVvWh874GuTL0VyHlkxEGrIAnn5oKUpMIHif0wyiRvq1jC7mT+nR6wuUMQCwnfm6CyuxLytItR1Qk8tpSSSxnNaATnVkCt8oOU7m/5Rhx+YHaV5HZFqU5aOOue0eNi0UT/zUinXpTNvBhlPXa8PvDm4len0PDgV8ByLy9BKGcEL1rh0NIDhzUdX1sEA/o2OMZfF8+SOwGJrox1eov9jV2tg3HyzPc2rpQTX1eNSU3W3K0TCPQx1wPQMQTV
 wFbX/frp
 7KDHdRw3vIDdUU4kDYBCTzE9y8NcxD/pcmJ3yLgB6qudSJ8TCSMqsRl23xefIOkaODNfgOUEVqMftbNnXPnR5DahvYbRNaFzpki2kYTV1UPp/V/dRS8HqVNwcbHPHHlLN6i1P3RAYlwUQBBruyICCOuumPzAyI9Lr/uQggQR9vIPiDpFVwSV5PC6VdKwf6YXOX+Sufue8zOI2vza+079jwcNIf2UQMXAv7YlKU5cWAqlTvWV8iDKE+GBgOAJEi5v2oI/bHfR4YLqVFALuBxErHpZ+0PNKLr0vXiXMjkwqbMJG8HhEdwcsQhuSjc55ZpJ1zu78bvP2ngBNaPC0Vr1RU91xMjoS0orZo7JLvpq8sAMCKhidjcbmR2xT4i2sHAD2zdnoUS/7UKPHkl6AlR86BFyOi+jTv9qJgPYYzGrQaNXOFR/Q3cvb1Zr6rAWyi4uMAt1RG0yJYf6H5OUY9giCLO1FEovnDDpZHk24s5KVa1YQR/5NxLud5OxXl4GICzbx+UzzB4rwtx2Ff9lAqy0TbRCjW2ZRdQcvY3Najf7R26jYP/J3twxBAW8rAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_scheme() always sets quota.goal_tuner to CONSIST (the default)
regardless of what was passed in the quota struct. This caused the sysfs
goal_tuner setting to be ignored.

The comment in damon_new_scheme() says "quota.goals and .goal_tuner
should be separately set by caller", but the sysfs code wasn't doing
this. Add explicit assignment of goal_tuner after damon_new_scheme()
returns to properly apply the user's setting.

Without this fix, setting goal_tuner to "temporal" via sysfs has no
effect - the scheme always uses the CONSIST (feed loop) tuner, causing
overshoot when the goal is reached instead of immediate stop.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/sysfs-schemes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index bbea908074bb..fe2e3b2db9e1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2809,6 +2809,9 @@ static struct damos *damon_sysfs_mk_scheme(
 	if (!scheme)
 		return NULL;
 
+	/* Set goal_tuner after damon_new_scheme() as it defaults to CONSIST */
+	scheme->quota.goal_tuner = sysfs_quotas->goal_tuner;
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
-- 
2.43.0


