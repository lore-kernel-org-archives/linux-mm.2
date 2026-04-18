Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645B5F99C96
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 20:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622836B02E2; Sat, 18 Apr 2026 16:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB016B02E4; Sat, 18 Apr 2026 16:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5387F6B02E5; Sat, 18 Apr 2026 16:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1C66B02E2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:50:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD7251B8192
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:50:00 +0000 (UTC)
X-FDA: 84672868560.27.631FC30
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4199A100002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:49:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tjzsURev;
	spf=pass (imf05.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776545399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4L33Wj1KyOAapV3b78nB1Cu6gps+wM0aFpKs3eM2ec=;
	b=n+ALSLsUT85cyvgbsQRMBSsOtAUofMamQjz0n72tdSItlQber7UGteK3VQWMz2bkBZb9Cs
	uviUpzRX0Fg5ZKl1XlMSJbxCHDRmdpz9HzfbxGFVKGGEPtXi5QktQ8IjZeabWjPYvmJ556
	5aHiFsTfSdAibTNtFGXK/J/KO/gYvvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776545399; a=rsa-sha256;
	cv=none;
	b=sT3dcQRkaK53kTN9IT3GmdmXxogIVHgBfY9kuYpV/B1aZt3032iSoT9icGw/Bz784L9UeW
	nOZz7Z900/jyWAeQ6/3jrVh6fmY6wjL7m5R+z67TnFxVWYOeHywz1en/RnzAx7zAOh6qSU
	VILsIBegzFzrQwIpl4Y3SUnzo3PueAI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tjzsURev;
	spf=pass (imf05.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2B79176B;
	Sat, 18 Apr 2026 13:49:52 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D2F53F7D8;
	Sat, 18 Apr 2026 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776545398; bh=xqilpVqLK6IYITkPGi7y1Vzf8kCa1LEGL+36lgbutug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjzsURevw38siKINXzxI6ayboyU46S4o5GYu4Gdp8Qa1/s3JyBj3jx8Tg3SjTjpRp
	 Rsu3emwxCXROn8BnmKVPkvBOteW77h5brADlX8INLFE08/8RpwdOOTQnJjRtrAm7nS
	 wUnRjdb0HUb5JEgl7+4KCcnosumWyA3LO9ldXFgI=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [RFC PATCH 2/2] Documentation: maple_tree: Clarify behavior when using reserved values
Date: Sat, 18 Apr 2026 21:47:54 +0100
Message-ID: <20260418204754.120405-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418204754.120405-1-weilin.chang@arm.com>
References: <20260418204754.120405-1-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4199A100002
X-Rspamd-Server: rspam07
X-Stat-Signature: jo51c441tide5kc9676a8gptcuzq43mp
X-Rspam-User: 
X-HE-Tag: 1776545399-123728
X-HE-Meta: U2FsdGVkX18NJdOiYOnJmEFpIcX7E8LRp5TwcTK8ruyVgk+PGBydrbpWoroA7Kk2vZK9gSSTnaSJmxKhDuCxamcG5S1fc3/ni6VsNytQV89gyjgPNju2omWl+gcB77Fs5PthpthGNTWaOHV34IzZZsSKBZWSk357Jb39IDJZ/GxQgLXeBHfon+eSBjhcp0oJaboLZrXfjgPFR+RNQ6lvz7tPk9XuzG5Kfv1wH+XEBobtrY7ARqrau7zhNYPxDAcQqy2VsB07LamKdK1X89l6z9R+fEfQvFMYRee1vOS2BpPH5le0wo29B5v8LE5Cj52cm9iEWq3QZYbt3QCEMDBp+LNJUOE0vbHRzQZ28uN5HrUvr7LTTxUZM+HAUJ70LqW5UbgisK0vmFs4CP6TbRQRK8SIsacGv/mSoZTAT6vMIK3SuaUZuiBjub2zwrxZVoBDFCksFNq6qNq2vi/5w3H2WQ2+7PS3QVmWq/C2lJ7qY+SaBMZoSNkjSsMc/7VWtV0wiXsudqDn3l//DtTfMdH8OKTibfFvsC1WGusKK+iNmsT+L8Uj6sGBdgCpekUniqRhJAfk/TQiqUfas3M+jrXkdL+z6oNHy+E3ex5ZmTrbgKZShw71o6PcdZeQ0FwBMe7IAykY/qZOvOtEzUypT1tT8rs0QmypHB8Vi+EIa2atauUuihP0Vgpmzf0LQTCxfgLQxndtzxXZ7crtcjKurMUEsTQecyF1XtgJhLPCN3YUBA9hJwSoVj+nCnOEBlA+gJowipX2ZCUpcgExhP9LzuGn9Gvui8G4/KNb5sCj/Zs8sIywiGb75G3leoHg3seAerDlNQZrgnaWUroymNn949rpzCgWWO/QJbEKvQ5fgDp0bv6vS32s0D0OrhtdbTGBzs5KNWUEO+taTuR/DVrCEs9E2t3khRTeipAkNr1UoLAz9QpuwG8IZPNNFzuY7uKXkZyJUTIEPEzPEbwTdNbMTg+
 rtdJ+00w
 5sXkNGMipwk+xcz/0QngPYqUty6NgNCT6bugRLSgKJrrbyxc0iNYWHqwH+xlEUOmAdpZdJ4ZFncE43A/jijaeRJMvl0ZkxRFnzxKjPZirizapbbhszClBPJ6tx4D0OCmt5DE1pwTCead8Gtpxs+JehwOpKJye/qUAk2/UMGSg3ddOIxT7N+fYBGihXZ92r2XxvVcLbkh/fTKE7WEmc68uOh+hf8Lqs169aPSYu7DJmIfHgmq2kXk1yaE+IqIdly0ii5yvJK6oJn5Lb57fbK4bMI8yNxynPWhzoH8C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't matter whether the normal or the advanced API is used if the
user uses xa_{mk, to}_value when storing and retrieving the values. Just
specify that the normal API blocks usages of reserved values while the
advanced API does not.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 Documentation/core-api/maple_tree.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index 15eda6742af8..54ea99c7bca7 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -30,9 +30,8 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
 (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
 entries under the condition that their top bits are never 1, then the user can
 convert the entries using xa_mk_value() and convert them back by calling
-xa_to_value().  If the user needs to use a reserved value, then the user can
-convert the value when using the :ref:`maple-tree-advanced-api`, but are blocked
-by the normal API.
+xa_to_value().  Usage of reserved values is blocked by the normal API, and will
+cause undefined behavior if used with the :ref:`maple-tree-advanced-api`.
 
 The Maple Tree can also be configured to support searching for a gap of a given
 size (or larger).
-- 
2.43.0


