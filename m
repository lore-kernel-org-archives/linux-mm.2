Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4049B60A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0yl27VA
Received: by kanga.kvack.org (Postfix)
	id 2BF656B05B0; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249FA6B05B2; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139D06B05B1; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9D5F6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:06:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79CAB40852
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:08 +0000 (UTC)
X-FDA: 85417418016.14.0FA9766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3DE4180009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0yl27VA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794272767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=svcdg7pOCEwVyv3Iw1ihpH3E5YTHskd9wIRcOX+vFpg=;
	b=s/Mw2cUqObf61QBvkFvsqNbcFHkDtLfMFrfAuUgsE7DXmYwYF+TAwkKCo0ILF9U9/CMqzT
	8OyzK32KtjevEy+mVhjJ5s1AV9MHJrDDzGx4K9/6P7rUonITgnROyWgqYnpYGz3l71wqb1
	6V4/Qg4LgY2gAFN0LBs0GO13MnlAtz4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0yl27VA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794272767;
	b=A59/dom65Jk2xfxaGlEmn4n7MHO2NSlNG+RJUqjyJwECQRNiZ+iEUEIZKmuZZQUSSdKCez
	eIoeyC2EDbRpEkQhua+kqIYtNqNMSEHR2Xx2sW5qa6oCG8cDIUIL5pBRtB3/blTIWdjXf3
	P1o5z+qJDCGIXuNuCSyyrjRSLykX78I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D669945C04;
	Tue, 10 Nov 2026 01:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673801F0089F;
	Tue, 10 Nov 2026 01:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272765;
	bh=svcdg7pOCEwVyv3Iw1ihpH3E5YTHskd9wIRcOX+vFpg=;
	h=From:To:Cc:Subject:Date;
	b=k0yl27VAI1cV8UUWay7UD6tBKAG9upe0pA3a9yev6uGADzdj2zfshNuizFmmokQYX
	 /jNPOLFIS+ww7R64X14VP2EEAiL/bJ33Mfvg6jYkvWN7zp/R3bdGRV57XouMuvMxaw
	 cLVr71mADLHgKb4RNLkA5CMkYrsckKBIZ43RhglzYilRCJIjQ7gzgd4UP16i22ygiY
	 rQx04fHJs8bMWr7vZcTAHCjiaXrH6k+mSIxuSHGoraJ+eKI5g5c/4waQyAjBo5Ezib
	 XW7fpvvrno2zJy980Lb/Cb0A4qRNZGP6JmKGQDdwjUBBuHJDkUYgvy4YFUtxOb5jYY
	 75DCFhP2fkj6g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: cleanup region iterator and damon_reclaim user doc
Date: Mon,  9 Nov 2026 17:05:55 -0800
Message-ID: <20261110010558.104905-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d81kgizhepc5qd1qoouutc8sah5mm4h4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3DE4180009
X-HE-Tag: 1794272766-820511
X-HE-Meta: U2FsdGVkX1/p4qA9eFmIfzSfmd7TNjPEWtR2VggCgAu76uJqyhMoQ9oy+aFqsv3lGHkQgTbd31AYJr6EZt5J0ufx8u3Qf2dCMlztdnTIGF/DRgUyGJnddyBtPtu8JJBTL6jeO0aFzsTX0bhuu+XVCrMt9Y3VCwiTQmb4+7M3ARre7SLthIMfK3GLNKLnO0/XO9hRUxVKZPPpFVNWQfED0Wy1NBxE0K/Z62XzXcZFgfW899ufVIfUY994vgl3KLtSQrAxxg0jW38ZI2E3S7Uv0+XwJFx0/rA/bKXIUDHetxjU40D32xEID99ZpUG0l5ZdbRlYNErWxA7DtEhJJrv+WTX9f469ghQ5/BSdTIXWLj61DsxmUlyJPzxZMEyLOdVelfd9VBca3SnKqVrMRukHPlZj5tiNTU5Clw5nfcuPNU1tXv90gNH7GBnTuRWCCXbVZnV7KFBSLEuRQgnFzJXs+NRu7tkEgHgzv+H+xX+3lF+BhIR+WqtmfobL/LqFpGxKgZDMhimqnu3jB4tVboP8NJYmxapy0BvQSUlNZHNIceoupn0FA9bLVptqApQldiNQ0KScIUXRgOGHEAclpsDrEuAfnpZ8efQFVETv6PZ1pjLt5VGZZIl7RksHg/OuQUT7EF7JYA1BngiVEifccq05XgkLzY6CmPScEIMwX7GBqF3sXEK93haZAkVUJcMNRhBlSOHWNXOCr9SiuuUQyiExpnKlzTz4BMcXP/Qf+0Yc3Wv3wmPknarE4n10szzTJoKOs5Xq9Dwg2h82/8i5WbOrMdS7uFsPsER1cvbfRy2hX9mTlATNuTiwTjF3o0iP3/swBhGKQKRePFsreWxVWBrLjirxLT7rKC+TQmHcKMkR5Ok/lb2nZQen+iSeUjLJfWeUqRKJrnSOlzmhWKDEEHV9oEL68sPMr4Ah9KCzR24zyh7OQBCoKDEIdAON+nTBMX3e4Qkeh/YZIuZi8AvPsvd
 ay5lDz6p
 JYmb373sLh7XtzskaO5DuA25uoLKfIPnKXaZUzUhq384PPUNjqH6sE2C5klKsQg4O8cgQGA5Rfv3mjo1tD1vWib7pnAUT9ZFAIFPZRsW8dqqheIxdh5YJkcxpLO1CxLnZphrhR9TP/OjUQkXusuK4H2TzMzSURceVtAFmFVjejijNURWqf6LtGi9gF82GRqju1I4looT/yZ0pFR/6H6XMxpnut98K5+/njgrJadF5UMFA/PUDJ/OY4sjvcslCWuWUsi9B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two simple cleanups.  Use dedicated next/prev list entry accessors in
damon_{next,prev}_region() for code maintainability (patch 1, Enze Li).
Fix typos, grammars and improve overall readability of DAMON_RECLAIM
user document (patch 2, Manuel Ebner).

Reviewer notes.  This is a batched mm.git merge request-purpose repost
of DAMON patches that was sent by individual contributors.  For
changelog, refer to those in each patch.

Enze Li (1):
  mm/damon/core: use list_{next,prev}_entry() in
    damon_{next,prev}_region()

Manuel Ebner (1):
  Docs/admin-guide/mm/damon/reclaim: improve language

 .../admin-guide/mm/damon/reclaim.rst          | 45 ++++++++++---------
 include/linux/damon.h                         |  4 +-
 2 files changed, 25 insertions(+), 24 deletions(-)


base-commit: 7564fa11d57d7be37aaf791ff683099098dd2e39
-- 
2.47.3

