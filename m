Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A65F36C5C
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F1D6B009E; Mon, 20 Apr 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740846B009F; Mon, 20 Apr 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655DA6B00A1; Mon, 20 Apr 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56EEF6B009E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:55:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0637C5BB1A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:55:32 +0000 (UTC)
X-FDA: 84678779304.13.FBD0E5E
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76494180004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0E94qoA;
	spf=pass (imf16.hostedemail.com: domain of jamesjoseph9795@gmail.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=jamesjoseph9795@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776686130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tJ51D+oqKsra3ITvMX34uEK0amEfKreSNeQ+Y7huTyc=;
	b=rNAhxWPl+o3YX9iyn1ARuNuiWhW+Tph+6Y8RxuKgphjYhfbZXk4PPpZsXeHRFR1A81C3pW
	GiYi/D3UqTQPQ331P7o8WQFX7T4XlSTihOYlyarlYwp4cYC495R6vN5G21x5Rf8/pXxGoQ
	r3Ykc3uItrv8rtzSLIqFOVpkspI/LEU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0E94qoA;
	spf=pass (imf16.hostedemail.com: domain of jamesjoseph9795@gmail.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=jamesjoseph9795@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776686130; a=rsa-sha256;
	cv=none;
	b=HFD+dk9YZzvRe6BvU8Kjq3OLlsbXzN3GXDaUOlIV5gIu6YwA+P09AjkBxXP11lkzj21xsK
	QJqptDj9s8dSYgVQer5ABuBRGu3GvmcmDx754pYZo1WtYWbVuXvkA0hSWkh7AClDHtHA2k
	zdj+mC3c9Da0RKR0/oT7441EeguA4DA=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-354c44bf176so3481860a91.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776686129; x=1777290929; darn=kvack.org;
        h=content-transfer-encoding:to:from:subject:date:message-id
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ51D+oqKsra3ITvMX34uEK0amEfKreSNeQ+Y7huTyc=;
        b=i0E94qoA5W9hSGqFROD5yJ8kjIAy0wBFaTact6xEK4uLkOu8K190Iv3vDs2yTxPaZg
         JRVOvoz5oxXgqkTDceEduL9YARYP21F+EEKgc+ZhRmYkgZG+W5+lPQqw+z66gDRpILLq
         tpaNPPLbFOGqE24rjQfD7HNE2Ktq6zoqJZW8i4uJtWFBmsZnLX/JoI3WsoTlKQngf4wy
         vS7Sw2lgUfXWyO+AV4Vn5RczujlmKg8jw0/Bpkw2C2vCkV1L0l0HIa/2puFgKfTWrPu7
         mzPovnV7G0WwdGfdpqzx7ijj2pu56A4QSJJ1PgEKTV52ySMt4Tbj/rRe1CdzRd5fB7jU
         rolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776686129; x=1777290929;
        h=content-transfer-encoding:to:from:subject:date:message-id
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ51D+oqKsra3ITvMX34uEK0amEfKreSNeQ+Y7huTyc=;
        b=ErEYJPsG/dIFOHs9tjOTSSfZS8HzPqTgHOouXimFmbKQuIg+8q2B4dQyw9DXLTVpec
         CnaKUjKcGox3yZERsfoBDKr49LId3wbud/aYq81eTwMuLBsj9pXIxVH5Wif9lKAkt+pw
         1i7ZkM3nrOphOjHdRcm4PFoSkyDVVbKR5jP8jMJPb8er2ZdsprNnHA/GqwuFw3ARy/U8
         wDp0ojJJPWf+xsymJZ092duU7ayo4qPTtbU9vGkO7q587O0D3e5gy5EGVHpP58E/kVty
         LfrrrqWb/Fkt84QKDsZXh4dknhd4eN3GvcUySfMb01RoIPTHie98Ic9fn0Us8PaLjamI
         sz4Q==
X-Gm-Message-State: AOJu0YxOYkD9XTvw9h4ERyxEtLnSPSJyDYgSOYHPrKYG2QGzAqNbKBdT
	BoF76tWgsKEZWEdpWkicP4zCpJJIj/Ayz54AEtqSK1gi8EpIfjvFOHG20HyOvNYDpeRFhSVUSz6
	3fxRfKA==
MIME-Version: 1.0
X-Received: by 2002:a17:90a:ec8b:b0:35e:5b19:234d with SMTP id
 98e67ed59e1d1-361403f0aefmr13656956a91.7.1776686129444; Mon, 20 Apr 2026
 04:55:29 -0700 (PDT)
Message-ID: <autogen-java-337c61d2-93a9-424c-9bc9-d523ab1ea4b9@google.com>
Date: Mon, 20 Apr 2026 11:55:29 +0000
Subject: linux-mm@kvack.org
From: jamesjoseph9795@gmail.com
To: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Stat-Signature: 7kmm8uxymoyunx8yn8s4jr5dduae895h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76494180004
X-HE-Tag: 1776686130-370214
X-HE-Meta: U2FsdGVkX18pbB9JPLSSw5HcuiXI4+eX56V/KCDQi3TTIC1zCnNerBgdT5Z3t5mFXz0os4aldte20pG6Ep8RDJHo/DDnu+NMoYPAxc6knnuQD98aVSHLN5mk4IoMHJmXkEErhPTENJTU+Wfl5hMHM3AlW74CXxTmqe/8rZEGSNFDTFsOAkU2MGudUnvIAqi0ZTEAhOCDWlCGIqB4JRGSJiOux5qHZJTN8NOav46n1JG71h0f97jE770JqCH6sTRpLa1xMxF9MdrG55UnVWkjLe0ACoUhKdq3EJUc8XKyy+zOD3Da6DpHRWwWH2ECflcFt5qME4aJq020lotrkofpAdzauf+2et9trar4BCZvgNjdc5wdjmkyv4jMvoMIhbqaVQ6914xa3s7I6Jb1qY9SRSBcgiZX8uqsChg2NLqLLZ1Ydw+c4+cHUsmQ+dhMXCEfQodbUwB0CIQdTXREHESZ5YoGmgGiAUUIo5pIoCe8lMWpFNmRxsd/YPRuJJC7p/A6KKQl7dLulSAFiHGuaDn2SNroxZ1Q5QuwqeJrNBFGOwsFWjmRifjuua5zjooIzy9f/I2HDYBBfLiTjkjxZdZLpJXRMBo+nPDWgrN3i8NAvAgjLjGxq4XaZuYtuiLOtjkT9UlU0fJB00wFMfL4AEfARI4Pjn9Vxc+Tx2HeGn2BnwYyBoQ5Zsky0f5j+sebbyxQzkLQ5zUExxc3UNG283mSunKbrmHbj8XtIzzsj4nHRLQBXjGMcgsZIavPI5pW+djuAwb0YDU2oCl6N/V6yklSS2sxbF1gzJfs2HY5xE0tP0I5UUoRQ6Zdn7oKritq1A1DDru+LRQ3p+w9I5g7zt+ZrHvMxrsoy5fjft2GiGKo94JPfIvd4oMiwBl4fl0yKDvAF0jOrf6SqTkoZYTrLNamhd2ERrNmQ2EwtnYU3BW2ARkBINeIDVlpdXoDwdiecNKRnCmy92Tz6SqMGjVT4ei
 LRhqD5zF
 UWflvIjkjPeN2PjpZnoqOdGORG9fEb5IICwjIWb/mI/BLEtLH4MYv1/AjvSCnSFY0ZG5rr4r+IA95d03kkaFi26wY/wELm9Z7wf3BIUEsj3l+vOgyb7E3ZgVjf427K4oPo6GODfpVRXRPt8twRYq6Q0cBNQmPLPtYaX2Y7XGggjI2P+2/6p7PO+lryW1Zym0/tII3FZBTbDkUbts8WVCbkGMuQL/ZOXKb8BNUtHkCDOgpVXVuDEeizyzszuIkp16TRm1uXkyayLgRk2/nuDBudkH+7DERpCQ7orfcLNjqsTL2tHiCM0k0mn/TfX6xPXLJ5KO82gnZT5hBJRlYZfin5zczIbwF6cN2CQw63s0HAl62bmJgKCl5dzIb4/zn9PzC9o8wLuhD8WYsZ3P0e87ua8IvaiCe5QcMhxT8OBGw2VeH864DiUfh69I84BhE6KmvvAJ0ewJcnw/cGXPNo3D3zpIyP/Ng0bkabu33sDEixn+YQPZDZQZzjryh72jFgahiy5DyOu3SxbBwunyKRcPFIgW1tn5X5kXU+wrn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgU2lyLA0KDQpZb3VyIHNpdGUgbG9va3MgZ29vZCwgYnV0IGl04oCZcyBub3QgcmFua2luZy4N
Cg0KSSBjYW4gZml4IHRoaXMgYW5kIHBsYWNlIGl0IG9uIEdvb2dsZeKAmXMgMXN0IHBhZ2UuDQoN
ClNoYWxsIEkgc2VuZCBwcm9wb3NhbCBhbmQgcHJpY2luZz8NCg0KVGhhbmtzLA0KDQpWaXNhbA0K

