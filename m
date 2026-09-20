Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC1E2C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CBB6B008A; Sun, 20 Sep 2026 08:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106086B008C; Sun, 20 Sep 2026 08:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36906B0098; Sun, 20 Sep 2026 08:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2286B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:41:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D49614040C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:41:52 +0000 (UTC)
X-FDA: 85234102464.17.C517B3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8858C1C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:41:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kjkyLS/5";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789908110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/Dk70iptIFqCkEBnGECypzC/zMXIi2EsKQC0fv3EME=;
	b=DuR0Y08KwDbALNSa81OBHVbyp4AdiA18+sNctCZvJ7C+7yv0yQV7xbYR51bkXV2vhtIEHk
	um+hBlDsz9x0iLdFnNIn43yxQ6gBWPsOmI0iZEDyTuoPluvvJYnQfVTP5LWkHG1gdHR1v2
	2mwQuVGsocRH+RRBz8Q21eCDgNGMR3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789908110;
	b=s/CnjwXWMJtnr+XVIKDy9h2g4N0g0tbBT1CAvyEE5/dFpwObWUArJXaljs4xNLY1JXla4k
	VPcjS8dK3gVC7MS4qp+oqWtnu3ywh4zDHxmykhcNEeETDhDypZ3GEoyL1WV2i5F07tCYQg
	dKJ1g4UQg7LblewEUi1MB0dgagkE7OI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kjkyLS/5";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEB10416D3;
	Sun, 20 Sep 2026 12:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D19B1F000FF;
	Sun, 20 Sep 2026 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789908109;
	bh=I/Dk70iptIFqCkEBnGECypzC/zMXIi2EsKQC0fv3EME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjkyLS/5/JHLbJPv+EukS/16muH2q6u0OQrZMYRAW94AZmscp67vMs7KMni3kBjDJ
	 vd7dWzm30EgYYIukL7yy6c9jc4/n8snyNsbhjAlYAlZmCRRADVB0hUOWg3fWAVRR4Q
	 sdi4wotxoP3jPRfR1zcq6BD3FfYYj3ooFi2tITbs0L4gd50dEGfvdV4KHSmupgGJeE
	 l7pEGbyI+wxUJIjvypOXRVbeaXz7sIY3IFGI2bZGEtV4e0mEkcFVJRFdAlY2b52rsG
	 i1603onwebZrZ9MnbpphV3GSDY6xXJBqNg8Hkz/1ciekkAq7Ta1vzj2aGV4715h0pN
	 xG3rLo11+mCyA==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Sun, 20 Sep 2026 05:41:45 -0700
Message-ID: <20260920124146.48423-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920122411.610213-1-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x7w4ryzwrs17xuqimn66jfofe6enxed6
X-Rspamd-Queue-Id: 8858C1C0002
X-HE-Tag: 1789908110-444722
X-HE-Meta: U2FsdGVkX1/76Fcvxy90gRiGzNhEVJDAsMYZ2UnoZoShzLgS8565zZ6rB8ZlsVh8l92PJr3WefRwdzDBfdxaufVbe3f1Av8PXDjOj29ohz8oo1HISIw2WlmFJm2IdSECcxPz6XGp0uxV55OqY0caNEIq813E3N9cP/cvzX2C9ICqJKXXvyaN+IXGzZGSEN/wJNOouxBYPea1V87MIxC6onm63DnEErHzXx10x2oEUV92KsDAmNje1vXqTZutL7JWx++jpTHe2x+r+0nc2CJ8URrlKEGfm0FEEk4Q7hivzZvbP0tMi3hJojrIa09OYKN9X7bh34Y0juNNaI6Q8xy1ffc4hX4Lh4FjmTazvEr3xm4lK2UOo+2aFLtP0jc2Q2ncNWfSqaiLV3yAZG6gSbjWWqyabJhpdH2aUxYiTeRV1zI0gF6HIjUdtTNybxMpgwda39ndzQnx7ae0na1APg0JlKPe9qovjW/yKNZ+2Z79Gzg0oa5Z1Mh55IW7ay1DC8olGe/RzyOXKX+m3Kg8rK6sLVvq2tL+sbWDANWpZojd8Xf0BNbleQ/avo37ZUEPbPNSMrttmLqmRHiQ3WvSes49uUoqDmd4FNEfcytrLUsTKJoibU5ypTAtXwpUU2sJyrybs2cKSL4gj84M9haCTKWw0sktYnkfqnJG+wxaPepn40Tels4UieE1VqbC+kvby0Aufb1vezWGNxvvR9d6rjdS7ETqf58ZbHMitAO1QWc460q0qaqLLRDSNudTkcXiKWLnfsbnud5FB4E0p0DHArEmWkVVMJik0spr40r806c3N5CPUhqWPIvykVD3+u5ob6PxFE63cmeUOkwDMvgPk32wJPN0K9ryxeqvlOGIjPJXRQfbSaEbwhlAlK8O4HzaHFjG5m4EuxH6XcobDQWeMlcywnhkSxOeGUFYiSvUfTzmBVSJG6I2siH1ROTw7sPxQO0HcG7rkxUvyoDGNXBkm1S
 HQ1CHJZi
 UYMVWxDZnZnH4gTXKeTVxaLdXJu3cP1RWH6C/+uq25r6BW4xd4qP0gnAiyw8S9b82i8tv2fVxSAWqJMqEk4douilAG3A0TknrE6z5sFTqfqEWWRELZJxFZ2VZhJSTzgfLvJoMLLYY5Y3Ccn54lrdfaggl5Y7rN2zG8ZdkAFXZHQ6VJjLFBqOl1B2qWspwT1EarzysZDQW0+9ZH9kTEROW497E0ZnlYXsUlIRtsHHvGcSkF51rOETwzGE8sqJ3R/+GRqTZEMe7zzTHhksMGui9QJjWFhBgQ5vdD/BlyRfQPNpqeR4CBvV8TyZI3KcmRLHSCfPWN44zmguSe2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As I commented [1] on v2 thread, this version is posted without ensuring the
discussion is done, and gave time for others to chime in.  I will skip
reviewing this version.

[1] https://lore.kernel.org/20260920123959.48279-1-sj@kernel.org


Thanks,
SJ

[...]

