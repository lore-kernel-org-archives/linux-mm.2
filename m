Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66C7C87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834716B0098; Sun, 27 Jul 2025 16:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4C66B009A; Sun, 27 Jul 2025 16:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA1B6B009B; Sun, 27 Jul 2025 16:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B60A6B0098
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D744134FE3
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:28 +0000 (UTC)
X-FDA: 83711157096.15.97C66C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86302A0003
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SnVyd1ia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647506; a=rsa-sha256;
	cv=none;
	b=Wx/lyulCcZJZqUdF0uqZpetBwLDp57nqqxkRH5k17Tn6gYON96PdgRVprr2/7yJ0AYV8dH
	p897vA/K8Km7a6FaZKteqcdkSj77QGrAr0exc/sQikTZ0cnv4T2rewD48MkOBOg93HnTDi
	Tbda//LxHPhQXXIotpuhxDJJLbi8GVU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SnVyd1ia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+NEmqA4oRkdRp3XwcJS+hceyIABkS2aC0m+wthB0c8=;
	b=vuvKInPfY1NMGWm1oF9VVckE7RtjofayMb7iJnDE21/0n5oJKYXEnjdtFIV1a+UPylxjCo
	/o9dlAdNtu/uGvRsvVcjHt+bhfIflTrozvuaROahCgAtX+s8Bf0xLekWkSziRUsleUKtl7
	o8y4GdsSbiOMGLoGCd0difXiPX9AWpQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0746B601FE;
	Sun, 27 Jul 2025 20:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97EFC4CEFA;
	Sun, 27 Jul 2025 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647505;
	bh=lIN23oNIZq4gvn+3V74kVsfgrx2Y6wNkq7FOywUP7e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnVyd1iaZ6FIKe2TiI2z0l2MSfELTCCZol2515DoHHFYOTm0vguEMRVfekcMdFrp4
	 MNz8vg9AOMJ7/Xqirrg14z4v2WJN2K65r4ZAFP5hbx9xAGDq2ATFA0cAnMX6IfPOVw
	 mlc0Qs1JzsL/QIC79ERmWTZXEV1h3DwFk0Ey2tXFExsnhZfRxdz7IbWqD3x0kH9JD1
	 9BdqkLbs2YX56yNk/wnj4ajUI5nDWfujZUyUnbmu4a8p+HDkMFS2rCxHuU3I+ZSuWO
	 UHg/beRd0Lky+HxbcqIqt1JAVD2VyTiZpFGVweSJzFmIYKmLCz8NZywx+vcQIjThj3
	 U3avO1s/Otxag==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 7/7] mm/damon/sysfs: support paddr_fault
Date: Sun, 27 Jul 2025 13:18:13 -0700
Message-Id: <20250727201813.53858-8-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86302A0003
X-Stat-Signature: uaqqoqseags9wkdmiiqnq9gfumy4w9a7
X-Rspam-User: 
X-HE-Tag: 1753647506-969564
X-HE-Meta: U2FsdGVkX18bNnO0Dd2hSlShIYAN6SWAHYY7Pqbf7WaC7zS5yt+yG11EXiFM3obP4nYqMkEOxD7Vc7ml3Hkk3rDajz6otBMT3w11fg8lsZFQK555/SS60LoUnoQGCsDLXkslYBxdOULlKfmGfzKejZr5posDwieU0st8vBrOVQLImjc8Q3MXx3gVTXI7IcKjNgksnDHWH08XAddlgCjYH1xtC/5gTf2MWSwPks3hoYh4CKxmoMGbBmvHH0WzYTPoDyCALayLsjY4GZ8dIG1IKq2vBUZA+inv+Is/1LQErO3/0pUMlNVeKw7MA0infw+tCd2mHzqAovzlOTRnSlwFtIHkwBerDEeas1oWMlbbbl5PJdxCWy5wqecMs+GAzXRpMvEy6dpa2h5K4SA8fui8CP9vYtUbtwjhm6w3p+3eQAJEWRJTXWN/1bz0T4RErtnb50U28SgwBf2uk/RzZVpPGVEWUk5C5m26GbWVfL+b9fxcTvUIbmsrxZl6lm01aRbmM1TY8jCJ7Hv7lND8qvukd8oN/Kp5QfEekGjM2Dt/Mds7h5MiF2cMOsWSG4+vOairv+BNUxawx4yI3l935GS3WsZRj8o9+76ku0Pgxr+BRth1fZCdjzEUnv78fmTOHaYLuSuHwT199V/8TwIIl9i5Tqmkoiij2h9rEfQEX3uwyitaNj2gwpDE9GxDlZ1sok3BHVZzsj1Lc2KIPE4PMeXphcBSfGsBI6lep114As3q3J4ExGpGebHcC7l6PllUv2FFlczbv+/KMjPeDdppqXeEbaUaioPbbG1W0MoZYQVvrSHK69I43Veg28d+fd3/C0Yj85l+p9DcB7PWHIyacp6eI6sxhoPSGoL6db5ULocawqsT1M6/HDYP5vG4hvFQjh7eRW0fg1nxp0ElnfhSREIljCdz5DEIlG3kZqWo91bAMEpLlguh0FoeQfk221EelcQR3GvA+OECx4FdRpvfooX
 zjv3mNOQ
 N/g9H+ORV5PFSX0WI3EEpiTkvuAS1Kw+OV/rN4/NlSTlng900SHn/+tr04gq8iiYPYIdMj+bQv7jZbDvmjj0iPBwo1re9ukWnPjKQXlPBID6WOVgzVqsjuLhVkWVL82WKnbbVzRE02c0B/Z1KO8dUfvYPfIcU1zY7ZDTUvRjY0HYx83S9ZTiia4tOVOZe3zgzNcu3RvofIHuAi4zPZMPtHwDlU1To+brd5Zy+FmxlQComrNhqGhss11Yz9PEIo2VhebRbwNERFqk1+CRzoa9WeFkViw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support the page faults based physical
address space access monitoring.  Users can use it by writing
paddr_fault to the ops file.  For simple testing, the DAMON user-space
tool can be used as below, after applying below hack.

    $ git diff
    --- a/src/_damon_sysfs.py
    +++ b/src/_damon_sysfs.py
    @@ -548,7 +548,7 @@ def write_monitoring_attrs_dir(dir_path, context):

     def write_context_dir(dir_path, context):
         err = _damo_fs.write_file(os.path.join(dir_path, 'operations'),
    -                              context.ops)
    +                              'paddr_fault')
         if err is not None:
             return err

    $ sudo ./damo start
    $ sudo ./damo report access

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..b1bf43972491 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -829,6 +829,10 @@ static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
 		.ops_id = DAMON_OPS_PADDR,
 		.name = "paddr",
 	},
+	{
+		.ops_id = DAMON_OPS_PADDR_FAULT,
+		.name = "paddr_fault",
+	},
 };
 
 struct damon_sysfs_context {
-- 
2.39.5

