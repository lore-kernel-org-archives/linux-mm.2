Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CCCC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ABEF6B00BD; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383206B00BE; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299A26B00BF; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 078866B00BE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F2301402F2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:29 +0000 (UTC)
X-FDA: 84940488738.02.B61919C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00B3A14000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3kI/k7A";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917308;
	b=wpqaC2ytwcmcN9g3nGfT+m/TA9x2qafhqdZKyqLM5Ee5vvvjAQNyKqVXgL5BpTF7Gzvvp4
	ycd5lFM642XYY5RKEbYQ0C7bmwBfqqHx83kWv/OxEhGlODeIbn5/wqgGM6hzLzXj87ir+s
	pt8wizyMaEv8q5B9987oGQExSENJMXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	b=C/jIoCpYB6r2FVZ+3RQ9R29AUtOxCpWjbS/8OXEzZ2C9A7jILFKK18mEzs2FZpmuqTUfAC
	pn2dkfTBLUE4p4B6YpEWFauiwGivCSN9gU4dFLGYs63RW2Gdw2KPw5wcQCo+kmrtAA5PL6
	g8OsgRLbDyETnXgNaJQeI3+IVZCO5Vc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3kI/k7A";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 969A5601E3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABA51F00A3A;
	Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917307;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3kI/k7AFBW4j4KYZTivaA5kkmRq4j7EuNzBwhzm1ciJBHV8ckGmRFSiYxyH9meGV
	 EfLJLZ6TwrHO6WltIcpEK0VwQAlB+hmHoHR98MuW42ilBz7k2q+UPHxESD9ieCdK4i
	 tySqDivp+Zi6BeOpL1CWyVTXv8UqSk5V61RgWPL0Ctn0xYslC9vrpVpTuSDD/aIOct
	 CZ9Jwo9nosYcClfQr8cguC6h+gYQNuy2ttxvtqNzngtb3orNx9oqD1ELlLCHQn60LB
	 7ZlUJN9JwAFCAYEUATeUM26wzU902KCsV+knaUPCHefRAqnorenxlSELJy5qr0z0qz
	 Wmajxk9m8+PXw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/8] mm/damon: document region size validation in damon_set_regions()
Date: Wed,  1 Jul 2026 07:48:08 -0700
Message-ID: <20260701144815.113325-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00B3A14000C
X-Stat-Signature: k9sdsegfc5t1e3mfby7wizfzmxipdf7x
X-HE-Tag: 1782917307-450931
X-HE-Meta: U2FsdGVkX194aeBgtc9cdBd7dVo1SyrWenvzqACOGVuV0QMSTBG/wA8Rlr3tjBiLoeMxSHh0rk6SH9ZhIBsEE5DY3533YS/R6d2lPG5sfKGSkV/FvSUfw4WhvSaWDuA8XRi538KsloeRR/i70U2dLY34kTIVqcZ7J63v4L6xG0IR+8VdI8ErWNNh4LobyL6lIALHbpTL/F09BM23xQfZ5fN7oLsQIddbtu+S5janDnF9tOS7tHSS78CVL9Sh2Jk8Gn5BR26WeOJPzLIJ35Y/7d419fOF73Sr95yur1liT5BdyBoK7xw2QliPdghAIO2KXQM/fFtFVcEvIq2kpiLJqysXTsiEmw6MDLVmKJgw6Vn53tCvWX4WorwS6yaCzvQgpFGC7DHtFGDyrxquwcFY4ckmSaBTBI5gzEwLnUCmeAg3dsRXaJxQAd6Uam8BrizKhmdHfmxEk5pd3GAku4uslYMF3tPHSghZyRyK0wqKaZhcNC0Lj0VhRGhkpGN+LpP6n3aB+1O8q2vaeCyBhBZEQSKbDqQ2ykfflprEGltUitWaM5dSDqVCpGrz9AK3TNhmTSvUMRS/jht+IOL8S87XK31mZpjSY9NESVFW3fStdQBxbHzderAewwOcxfjZEL7wrK66Nt4iTVX5xbf3DT/dtWh7S/rS7g7PvlSeFow6lsglOLB4kkWWAHXoMsP2ExCkQHH2nD/E/gK9ENccKXUQMCQuwiHLzzoMSrPSe9/Cw5AkflOtio/FyK6C52V6UjoAdoQlX9ARa/VplDO2PHEPJd0wPYQoutAL6R/ETkNk714EY+pX+PA/te1xl4EijO+3npZk9qi4PNZhZxJrOQcFjVtwXZj0ZNq9SbT8CDijt8ALeQFlGCxeSw0LGkw42J4l0nwB/30JLJQZD34lYjJqRIn+htM9h1QHLLFZGybJwgoPEKIBs7tLStcQjX9uDBgdZ4RgwLrMf005KxtvbSy
 ciJKoFlo
 Xo0yK+Fxkz55DZlMYtNHi+GgjprGtWq2X2poe+HWaj6P5N/K1XG66BFCvlnpUqW6KAP8ep7a3ir6qIB0hqa/2rk3OznKHHPyQq//TTkJZ/UVA7ikJLvvJbs/IukP2/063kv8e7SN0fzfese0G3EXhtboSTqqNGTC+xgmKtT8UNfmSX0BQC5E+4Y5/Q8umQNhlNxWfV24gn6QV/eTwuegZHccBn91kYumc/cjbBO7dA1xlaC96zvbOFZcoP/jjdhCoDwd4YuiG3d2g8v6xbJaWSG96oa19UmUlWL4m7l48N91TEnaGbrkcQD62ZcamFL8yndtzeN+CEhB/Ov0VSWqPLq8+27D/xvo/2Bpq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel doc comment of damon_region clearly specifies every region
should have positive size.  But it is unclear who should verify it.
damon_set_regions() is the recommended DAMON core function for setting
regions from the callers, and has the verification.  Update the comment
to clarify the callers should be ok to pass any values for region
addresses, as long as they use damon_set_regions().

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 616bdf0954b52..2661231c0ae82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -49,7 +49,8 @@ struct damon_size_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
- * For any use case, @ar should be non-zero positive size.
+ * For any use case, @ar should be non-zero positive size.  damon_set_regions()
+ * does the validation.
  *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
-- 
2.47.3

