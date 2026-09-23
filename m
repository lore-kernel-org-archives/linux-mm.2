Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3D8C982FE
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C0D6B0088; Tue, 22 Sep 2026 20:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD0A6B008A; Tue, 22 Sep 2026 20:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC586B008C; Tue, 22 Sep 2026 20:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0F1E6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:26:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 551344063C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:08 +0000 (UTC)
X-FDA: 85243134816.14.2ECCEC1
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FFC1180004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OO9g25k3;
	spf=pass (imf16.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790123166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yLteDfPUx3uF6M02dhFfxPuSSO1R7kydwzqevjI1MZM=;
	b=a1lss14BvvAlM7nAe1ZYOs+MlJOH1M1fHgDRhuEH+fTDyoOeX0+/qiGe0j+Yb9GchsL+OI
	7/iws6fh70q6iG6UH5vzdcEesKeNTJz292L6QS2DW6aFs1/5UPGuEuJ7V0aKk/b6qIAjnl
	rYzYDN+ek6mTvOoim1Q90OzNnR2TFeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790123166;
	b=i7f68oKjsxXZA/+7JcpBsIzLF1IYexZ5JbnL2NDnenkrRWe95mUAbKeIK5WBW8FCCiFoN4
	phi3r7Nz7YE/EeWtne1ozvRXu9gQJnhrX/RQ45gOkNe6NXeiR6YXL5AhAs/JiRCJc8f8Xh
	j2tLbcXHQNr4T06lwAtyG91WkeEqQVY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OO9g25k3;
	spf=pass (imf16.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ed1368so2484055ad.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790123165; x=1790727965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yLteDfPUx3uF6M02dhFfxPuSSO1R7kydwzqevjI1MZM=;
        b=OO9g25k3OmvUv4nFwPdz+PJFwjCErCUqgGk+9t1mEmg5kHXoP2DUq+sQHRP4QcmI0h
         bmKdfzXjCrPUEG3mxbxoNPYu6DnhT4Eh50ZLnPMyJs1S9Yh3YDycWlmgAqgD8/eizUxh
         pLgD4CwyMnrR/eDmnYMUhBJJFvl6l7zTf4g+jyLudxATwXaK4Uc8xz2LPpzn67MtyZbm
         oI+SmE4DauOOUZnidFMycEudIt+dfWo986o0dXTbwjqbd2MGqujfCksJC6KLSQLTmBdK
         17HPfPCGJ8HTHOoC+fgEa8PobJDn3tAbG9xRqS++wnxmOH6IqBUNSYliuL5VIJZHmipJ
         EIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790123165; x=1790727965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yLteDfPUx3uF6M02dhFfxPuSSO1R7kydwzqevjI1MZM=;
        b=Ksjn6Sx+EM9RVeOV5cVzDJfsjh1iv5iTvL7Bmync1SZLtLXoRNhQDiov6bEacS/0tk
         KK+TdKXoq/OLulkpwwsfAAF2AZsGzAm/pY5nmv8ouKQ9zAbBqLhKXh8NMPm0MUc2wUPe
         gvXk9f+l30V4uyymTJGdUr5FX5wRfreaUPxBe3oww9PUfCgccehYkCy5QcZW+7pMIPxj
         /yhzjtY7GrWhiy1rHW8AkBS2DIcvTeZGwNf6snZf2UQkgGJWgZIBHzm7p7AqDhWFpKAv
         70eZHQrPOmf2g36BUSRKkjvQGu1NjyppflpVzoJT8WQ55tK9Lf2+j3PaCjESEvckAus9
         j4oA==
X-Forwarded-Encrypted: i=1; AKwUvBxf9bjRLEZt7uI/XvdalStdHvggsshWL5a9hCwR0DoOM3DET90vtYaxGmSsxTZy8hXQnu4eLnbvTg==@kvack.org
X-Gm-Message-State: AFuF++lqrCZvkWRxfxa+Gl+oQq1/kTxlRiK5DSxrZqZJrzxDPihGKNQr
	mu5uJehkoVJF8XkTF4e5l1Ilr2mCjbRTjntzDPjEA+bsctUnkbtZ/G50i7a0sUD35g==
X-Gm-Gg: AYBFou1SiwnVdkHHt1i6PE+Aoy+V2Gl9wRgQvLk2HtZcK2S9DFk14ekGDb3IlHGklje
	OEmG4QIZrWPXjXE9qGhXnaRtrQIPQDHME0Kq4fVQ7zRvu5jdxkgOhvleeYRtvbt6SJdzHV60e4f
	8R3ko+vH+HpkeSc3cVXfYACyC6yR7ngUKquvqKAKqGBAvZ8QY5Wd5aH+XUGjhwGoCLcCV37XdXw
	ktNybYw017eTKtnzC4oxY3VPYA2Fz7bg41MNHxO4p51ZdtFfUBrR2bXNMeDZDXhiyhIq0cJaszE
	L/FZPAQn9aVNc9MLGaJcN6sTo41lsXxxvwx3/MjvVa1yNT851Zt36RKNp1dXkKAviyHqj96om1f
	dU3HFpM+mobvkudP/fhufAUtQICpZmvI3m2P0XPM/04kXjp/DciwolSdzcx+hsvtQb2ILCoPwqS
	mBaatqjoRwgSIN2uY/lw3MtiMHl8Un99YuZd9v5cbEC/vfuWOp0iSJyryWSap86vwf2U/t3BTj1
	WJssIyMWeenEeVNYToujK9h2ldo64/d/3Kpeg==
X-Received: by 2002:a17:902:e552:b0:2d9:3850:2741 with SMTP id d9443c01a7336-2df69be125cmr8314255ad.0.1790123165341;
        Tue, 22 Sep 2026 17:26:05 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:2466:805a:e198:cde8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a7b76sm2176595ad.20.2026.09.22.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 17:26:04 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v4 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Wed, 23 Sep 2026 09:25:57 +0900
Message-ID: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9FFC1180004
X-Stat-Signature: az5fm1heez65gbbtsfshcktbdbysed5x
X-HE-Tag: 1790123166-655008
X-HE-Meta: U2FsdGVkX1+ILaAiPblYmNbt58vP9TDacvM3WiWHz2Ew+arlj6/gwN6V+9MtAKKpk+qP5W0YTzobMXJ7CHu4dvWoQf83yQK83YWmYAgy4DfTPVqjVyzxi4/t1IFNO6i9+kB93QSG21WrpvQWjv2DMEIWZeU4OLXZikT/sU0Vj87yEQyacfaWaSJA92V2sZmBzfJub6vGA0guuBM2wF1vFbN8+F6FMmmpDL9bl5SYZXnde0edNnrCrzC5kuFPGXdlAckf8Zq3ECIbcogPHSr9kXmdXJffh3Umzdax9WmR3SJCXNjBN/zIEKTdHiEKUa5eBCpnKgmjL53hokAVo7uJGKmouFlIs9RybvIH8/o//LmK3MCQrabng/LW9la709EUCJAXnOAwvIU+ffh06nm/SGqT3CXkJafz8iuwget4X6FCONKXFWGtIcXyvFxarhJjPyuh+8egFHi6BtZHBpSYqRrVmzJEhatFy0zZNmZ5DIeUObkhlj8A5KmYaWplzxxlCni1xNDPp1UWBhC5/M/Kdlrn8i8aMwfPO1dhEBqKcMLI9CANtxrUA6DDYU87gqUEKPDplXwkVaumYovLDkxQ6UihK5gOARkEGmLv2Go5hxlveFIDrd/F4CfSnLsHl7jtMa8EdIYSd0xKjBGHy4CS8qonjqcfEAGC6k9KRh1daFw4TV1YdnUQnOzciY1LOrFYRYeviOlHMgUurXhVQwVZpmgUj4lJpRasNFYOzFoWpykXWaF1clvtspnkvOA5doqTulhdyuVXQP6TVjz5WjElNZHu2EoV8MV41dtZi7DNEssv9Bdor39Ul0R/RaP9iLGYoVGfDS0im4g8epZX6xe5UZOoYl+zMKkQ4VIsopmrUSNPGxEHcDN4r4MRuUtuDNv2HhYZXNxSe4MLDkNkpjOUat/d4HScmYF7aKJxE1LQIUbnLh9mFkR5il1CvTq+uKL9NxgdotqqqTcUM7vTlqz
 mAs9rXUO
 D7KiP8F5sX6+41dldjIDiPQ6/t3L/PlhTONma8IxgYyfd+h70J84dCEf5ErRdPyBKLyBAvNP+H/xiGHRATzZe3i78QxW9//td0Ia+lJbTOdNuBXMxM1k7OAZdUZ899deynUGvecNrvb19E8eMn60jlYTwOPfBdoiIQmwdmOgvF2Y3IVVT+WkuKvVXrc6QLvQBRctO9lgT3XGwlijAHAMsb/53QXQMkiuqf9OwmqxeVqMjmkrOX6+2q/QEvxj83QrhGe/KnDL8HE8/NJoMWjqkwgDShHgN2kIF52Z/mfGkBuz/rh7LwqhAiu4GYmpJkKFtcVrcUPfzrlXowUX+d062MPpPN0X1l0FRGAea9vNGn29I71d+0wWPmt5MKaiqdbZb4o3jEwi2iJycmAdkvIJyo480ywaHDzlyOCKDUKHa+UmZdw/JzrUHeemmmgUgi+9Dd8JcHiDWbJmSAEsVtH0RBmDOrrzVMN5uzKp8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and
the multiply that gets it there is unchecked.  On 32-bit it wraps above
429496 bytes, and a wrapped product below 10000 divides to a zero
effective quota.  damos_quota_is_full() is then true on the first test
of every charge window, so the scheme makes no progress for as long as
the goal is unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
kunit suite, where the new test would fail without patch 1 on any word
size.

v2: https://lore.kernel.org/damon/20260920023111.2466265-1-donggeunyoo.kernel@gmail.com/
v3: https://lore.kernel.org/damon/20260920122411.610213-1-donggeunyoo.kernel@gmail.com/

v3 was posted before the discussion on v2 had finished.  My mistake;
this version was held until the thread settled.

Changes in v4, from SJ Park's review of v2; the code is unchanged:
- patch 1: drop the 256 MiB mention
- patch 1: say what the user sees before saying the setup is unlikely
- patch 1: cut the closing paragraph to "Bound the multiply."
- patch 2: unchanged, and carries the Reviewed-by

Rebased onto mm-new 8d29b5365d52.

DAMON kunit on x86_64: 39 tests, all passing with both patches; 38
passing and damos_test_esz_goal_temporal failing with patch 2 alone.

Donggeun Yoo (2):
  mm/damon/core: prevent size quota overflow in the temporal goal tuner
  mm/damon/tests/core-kunit: test the temporal tuner's size quota
    conversion

 mm/damon/core.c             |  2 +-
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

-- 
2.53.0


