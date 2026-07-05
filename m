Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BF2C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97BCF6B00A4; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9068D6B00A5; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842C76B00A6; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 520E86B00A4
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C44A5A013E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:08 +0000 (UTC)
X-FDA: 84955174416.04.6531C17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39481100007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyU5VDAg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	b=Dw+YBpAnGKeMu/FfQLW7Pr51mGlQIAOce6kEU6/cdKiZXpmYT43xdfs6m3EU8UaQV5Okih
	BXWZ0kx9mlkKwAlAgbblhPT3T0s0MimT2VPR3pvtfex1p9RfOYM3UwB9aBr1mkW/GCpvi+
	N1iXhIhNYqNiG8utwYbRTm7U/YGKddQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyU5VDAg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266967;
	b=q5lZvSSz2GrD0mh+F5vxeIi8lkl+cuUMwAJ8Dw85J/JkJxaKPy+JGuU+++2oGR0WKyP8R4
	h3DKbMG0LlXuqgjwZIo+oK7BXmMrxbzdfSKBiJWvkcDXRM/aSDNYeE36R137bp5S/+ERHp
	fZq2bZb51vw0J+dtmPiU1O2KsE75QJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A614432AD;
	Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481431F00ACA;
	Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266966;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyU5VDAgbj6X0xmO8Ww0U9SrLl/+mHk8nardPbOQj6cBbpov7tXmK4BDbbXN3F3Cm
	 N+8BXHVjXey3E9TLVBVotXAc8gChnSlWskt8ykip1tqjIHDKJDvJ5U5TpHFnETw0OG
	 MH9Jyq2gu9jseqXZhe1s5nnsG1rRa2KuJuUhDsNMgiPyuTTMTPl3pGs16gsqVJ8ws0
	 oxonGWPdRivdExL62/qcJfLFP3BpHBcBDUnDfKbTqpKYIBKywxqpeB9akDsVQZvU+8
	 MHSHWObmwbpjJ6WSk5eUyfilJ7PJgvUpKOZVp+Y2FOkcmXucYzRh+IRcBp4rVjfYuy
	 aqtxltz67PP2Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check
Date: Sun,  5 Jul 2026 08:55:56 -0700
Message-ID: <20260705155600.96555-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 39481100007
X-Stat-Signature: 38s5hmhcebghc7ye8q6dxnfnkthdg5ex
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783266967-203481
X-HE-Meta: U2FsdGVkX18MyvuwrmIvkAASYeLfmD4gxA6Y/9POiYhtFXXi8RjFatJ/RDQvkCmLIhkcBr0XclDp5D5DPtnZrf4t6Nv4h5uMK7aT+DM7zFMU4D6ayhnTgtgVYWYP86+NPYzCezGB8esb2w/cjI6vaS5FmjAxKha0m8EbCFHurgcrJDgXvBMC77psdHKo6rKeGt/2xmbqkjS0A5zWVRbkYyJnaQSUa1BTHsc9LXJIHf5iBh3lAkFag9vCRTvb2U5Wv5OqppYzdR4XGSwApTqNMqOWpLnNHsr5ems7TiTUvRfczdt9luE4+aH2OBr0J1cPgdhHE8Q2nLpcqACSmUgmSn/MUPSnc0IxgNc183wuY5I1/y1FMZWWqEChhbVlIPdta+abCxp3Lww7MgzIy5QRkw3iMnnGmaMelSKY6JWtbhQJgQ/Xv6z2H0RN9rGy2T29wUacmwic7yXMPxkucxOc5qvqPug2BgYjDo3OoDFqKIYD+dv2uTp8BeHfCCsxAfzioLBgI24EYAWrXSicV66ArgUwHmjRsV+0UE/RmGWdGPbczmlj+KlbmC9M73WptFWjJXHDv6gVjfSXKkrl9+vlRtqQxQvvmhM2SPq8dqZ2qH+DE8eoLs1i/qwmtOgRE2zNp5mnA/EeyPpp3/39Jv+gsRljYvQo+tAGueEUYwItuJncwU5Z49J/duQ7nOhoAa7+P1KnKQwrtG2RuI79Xe1RUJvOUfDhXde6aFlyu1JNBglymN+00MYvxCUNMIxYeBu2THpEF+g6ZIiDygzPUWcZz2m1rU+ycgIJxhSygFNwxVIANh54iuWeUdhN0COcaZVM0M1LnaPT6aE5r6mNjRYvna/Wtk5Ic0x6RJ/FIBJmFUR1SmhOSUW9meu1an/UYQ22yebQniuT1vOUnmdqnMLksbEneSlOXr4DEhDgNwXqLGza2AxF+XgKcRgSUzw1tkn0dGDtd7rJu/W69rtHE7k
 c986AgzV
 yvJxZFkk5KpYzP8REcW6XNeOSPOy9DSrYKPBIMSb80/6U5m5bhH2Iz6yATvO/rU4DiKXqwVq+v+1Ird80A5ON/VpnVa3pxQP44J3INXdAwgUdM9IbVqr4VdKF1oZjyYMOeEXw2rNEOc9lCT6Q5CpGApLBowzWFOqwQoP6VrKA9SwIS4F5fH1L5MxmN4e+/HivigPtYf4fzIzc/f7AVDE+aFAKaGhdwzjhG7s8ude0Zq6WtQC7oSraqKP+CqKvOGNNN0MP9CT/vwGwUqsnImW8i/9u2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the unnecessary duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 32f41491b726b..2dd0cd0d26273 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -284,11 +284,6 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

