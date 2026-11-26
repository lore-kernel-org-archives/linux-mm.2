Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8346606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTy4ljNH
Received: by kanga.kvack.org (Postfix)
	id EFBDF6B05B3; Thu, 26 Nov 2026 16:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED35E6B05B4; Thu, 26 Nov 2026 16:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAC16B05B5; Thu, 26 Nov 2026 16:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40AA6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:06:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67150140112
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:29 +0000 (UTC)
X-FDA: 85478503698.09.C50BC63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6122180003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTy4ljNH;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727188;
	b=wY4fuZKgs+dm1dEzvBfMig2QLQ1Aclz+yk/Fhnasx4zRrhce2wEW5+Ect3L/DdkZQuQgBa
	04e8WZjZ8OWcO4KGTvjDlJ63rI8yc2zAte26WHVBeVxHTmVGIm1Wph/XsRyC9/E7kuPMyI
	NUE28p1GycH+D8OR5zQFhpmOI9zRSMs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SmsKR5t+Y2D3Q8kD5C96vxFY1u4bAkMjmbBuKnE7WFc=;
	b=xzCr1kdpqkunWHR2Q7cII1QwWuugAnWtr3vWWqIKQk1Ot2Ofy4ABQwlDpav6La8dTbow5J
	zNIvN0xgZdnhudEo+aYpDL7NgR3mwzqhpjp+gSRydOVvwcDPGt7rTchN0p1h8vUNRd93AF
	AMYIZC6gcZYhZIQalRVCPnl3ukZ9Rmg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTy4ljNH;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E08D6110D;
	Thu, 26 Nov 2026 21:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B911F00893;
	Thu, 26 Nov 2026 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727187;
	bh=SmsKR5t+Y2D3Q8kD5C96vxFY1u4bAkMjmbBuKnE7WFc=;
	h=From:To:Cc:Subject:Date;
	b=CTy4ljNHSQBNULlk7r1Rue8XR9LB3QbWm2NPo6GAYi5eKdum8znNEBLBvhyucFZIG
	 7iQspPA6uDGGSlceUeKxvb5/SnGSmwYnquOzL9HrVjDIwCREaOWRbH/MsdlkTBQe1b
	 rJPdEOIDOggKuOgigUu6TwZB0xuzgnbesIOL7Ue8eeiOv5sgecRwr6uhspm4cyExDF
	 Fz8+7vzovkqea/dKNtGvsr44qCkI2zBpWdHhvNzT7rcafgFZ5rrwhCN8aQCeLm+DAd
	 rqyBgE9dwYjwFTwrns+ciIunWZUXH3v8UrrWdqjcs2itzVOxNqwgpFxAP79Kzm2cq1
	 ooOP45NKXzi5Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] mm/damon/sysfs: refactor state input matching
Date: Thu, 26 Nov 2026 13:06:13 -0800
Message-ID: <20261126210619.97634-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: E6122180003
X-Stat-Signature: hqi1hq6c7r1afceqp9h58qydrkf6947j
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795727187-202669
X-HE-Meta: U2FsdGVkX19HP85UnbVxbNyGmIMKj4B6KH9SO0KI/+I28a10UGZyv1EwP0xZNnMtbYfYoiKBtccrfEsIQzZgOl4qExHaXLQxz9mfxlEykS8lo3zJuqb3uToRylGv/KqLgBIG+mgzSPpAO8qMoJ5LtbrSz7HSFdNoBI6/c5c4IzU7f3QCE08B8SkG3hsheUojxAi/0DfzWotutfsD+TRinFjD8imgGjSp8HQhUHaSFFuQDeBtIceh0bSFteAwIJ8k+SkzEAFnL2q/UUKhmAyOaCCmVGEMIsMEBhBNXS4Of7z2fiOjkstFENZJIHtoDOPh/bNaFXCp3WSSQ0g9GorGmkmAl0ovpc2cPdMFQ/7hXmVQgBMRolDfmtNCkncQ8W45uWbBW+ErFvpSHzoR5NB0JHqmsTXmUR2uv/YBuPDgMT0683MadiIMDmP9DQCieTPry90gilCGrsWiuuW+qkO2FRKiatyxQiPkX/j9sov5a+Srapbko30lUD7WdN7vsjse4v/QwO7GQTLlD5AKZhkpTnBOJw2svL6kyAogWiiwPNosRrtEwmrqxWMwEIHrSWJEiuirwl8Z2zviiCFjnzpFGgSmKLrv0beJaSnNyml93CD7CBgGtUfzbXZg9nVj4ou7ww9LCteb0laRWg5WWrLRqgA/BZGGolD85nllEU/9U4/4gKuTG2E8/ZTDs8ckB2zBH7rDpUIEv/E2GuqgCWNoAANuQQA5UcnVHzGP3Z0GHg10F6iyMftL4/fS5EZvV/NrHqZ1M7gGiog1aO1MQPqPE9xv+ZWNPRWgSOer8rPMBWp8iIg5ltournexvcR5K2t8Y3ZM+RWqz1s4QJlJ6x8+6NhWzlx1AsXw0r1/ukmTXKQg0Va+fbCqdY9TNkVH/Bjaq5QPHxVRfD6ufivcTV51QBqGU0LcbxJ03D40XFksKdytfxFBKvJvqDawKceiCUez7Tf1BiyRMrWDEKXJygi
 cFWiShNl
 I2VBSRYbHYuLG8HskTdSJ8QkHtZwKpSZ+mg7L+QHSGnoQLGEuHe+ZAE/nHc6qbMMSfaIbeutLyl9e60O/S6frC3sHYWqlMNP3VA4ED9/lEHVESuj5kTpuxvziI9991/k0yWcy+u6tqdme/tiTGM/9PcJ3xH67waN38INbncLbw2EWEW0flk3mvL48bmPfOWG0pelpY+mNkH+jEWIXYjT6VN2Lo7wK4ju2UpBgNDWrsJ3PK0X69YfpecYSur/qJ5SV3KeA86viv6jEDl5XgGlBgV3jNA+Yn9jQAEjXHQ8q0cCMH9MdTjFIdZ/gIVd9ydg+ky3Ph7ZiL+v1LbeJK+3LT+cFqgczH/1oYDOyIEy9pznh2E931SjSvhj8BlI2OcCgk9M5Ifs9fFTGUIYqtrxxsnUNKm1TIjj8jk4ufOYoNMHeJAr35gf2bCfHBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface uses an array of strings, damon_sysfs_cmd_strs,
for kdamond state file input matching.  The array has expected input
strings in an order that matches that of enum damon_sysfs_cmd.

It is easy to mistakenly make the order broken.  Other file input
handling functions use dedicated structs for such matching.  Use the
pattern for kdamond state file.

Define a dedicated struct for the matching, and an array of the structs
for the existing inputs, via patch 1.  Change kdamond state file write
and read handling functions to use the array of the new struct, via
patches 2 and 3.  Finally, remove the input string array,
damon_sysfs_cmd_strs, which is no more being used, via patch 4.

SJ Park (4):
  mm/damon/sysfs: define damon_sysfs_cmd_name type and array
  mm/damon/sysfs: use damon_sysfs_cmd_names in state_store()
  mm/damon/sysfs: use damon_sysfs_cmd_names in state_show()
  mm/damon/sysfs: remove damon_sysfs_cmd_strs

 mm/damon/sysfs.c | 83 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 19 deletions(-)


base-commit: 4aaac77f3cfbdce8de54359c1db84b5322ee5e1b
-- 
2.47.3

