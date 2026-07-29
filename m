Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6380C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342B66B0109; Wed, 29 Jul 2026 10:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321046B010B; Wed, 29 Jul 2026 10:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FF46B010C; Wed, 29 Jul 2026 10:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB0536B0109
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:39:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 861111405DD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:24 +0000 (UTC)
X-FDA: 85041172608.21.E02B5DD
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id CEC40C0004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:42:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dy95/G7r";
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qWC4cJlWYFKlCjFYJ8Sm1JeDbDYVJfA5kqL88tKZQqg=;
	b=pllZnUueV8WHjaawyxaKoTT3wzB8AlSf96WF8fMC55TQR+jssgntKURrq9okngyzlitCjd
	Ig2qCCwE83gmZIF/WpxopiuZt2tGHXDrLtQI5mhNAV+iMqF9ezfdpNx42Qh/cdMETKNx/j
	ZbGFzjlBv5O0TTrO+X0f2FqA9VZG+2c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785314542;
	b=XqqMNPYOapzzsYvkwFyGNGnNQ4I+j6KJR19uIGrkXUtCR/ZOyyi1x3Ww+EnGL933KRDEer
	FBlSPui/DZyQsb8VPC6jPtrcwqEdcL/og5n/XULx0RHKeaCjtmqbMTlPF/xB7q7sJuVY1z
	Yh75xGyttN1qsRSnOdavigLpbw+n12g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dy95/G7r";
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so671685a91.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785314542; x=1785919342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qWC4cJlWYFKlCjFYJ8Sm1JeDbDYVJfA5kqL88tKZQqg=;
        b=dy95/G7rv68w9vV0oLwYZJkH4eJUg4R3+vWmuzTm5+/TKBqHvWj9RwLV/ufvz8zmxG
         B68b12kl50CHOZJ8pDwoNUVjy83fc0BbT+hgw7kyDB3kq0WYRExbojbFQaROdgL941UX
         XuaMlcIg8i6GpDNLkECkQMxRV3T7PfzwFA4KEQmfp0hLtpprmVu1LkzEqHV2RlY8O841
         Gbve2l1Pce1I73ylEfpZ6dCj4C0IvqsdUSP1fLLuCVU+7wFFb33f6UmG/2+bMyOQ5ggz
         Z3yvTQGNvERScuoz+KW9+ON+DE2II5FC+iocmA6Wnpq1C9uhJSyGBxyDBaIBraOPFd9n
         noXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314542; x=1785919342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qWC4cJlWYFKlCjFYJ8Sm1JeDbDYVJfA5kqL88tKZQqg=;
        b=awpdV+WjoaPyzsYt09X2Zv7CJ2VhGNwyG5W2YfT32s0sEfZc24ixezJHHU5t5NSE4I
         wA4N4J5slGGPuGv+sHiY+1UJ5BoK8G1HjP4CsOwDe5feBIX+c/f32cWAEfkhv5Ajm2fe
         g/hQbm0JF11bkp34ta+liQXgr/yOrS3+qKVxL2eRDwWwzBfRqrkSCk2JH/VdN6AGAnrU
         aJwisOZqTzRnVL5aqCGB6xNw1cHYgBkNg4tLsoePXVzc2fPX1d+YilC6yEixSuAUFWbN
         uNCzrQy0EKignYaPUeKqxgIFJg5jR8HmnHpNlvwg2FVCjAH6OK1LxMr+PIJdXias326M
         y1/A==
X-Gm-Message-State: AOJu0YyToXja8ZzfGNkdIyMY0Trduw6pDsXSg9UznrWoBmUzCkWb67Mp
	e/U6NOiY/UTOBED8by0sDaT4cKcSI7Twf907LnX5Ct1hnOy7EzJQ5Adg
X-Gm-Gg: AR+sD1205aRrk1HxiJExIT4BPivvt9QDjzJ49pNaE1SAyuNLjNsF+tFt83c5VXoLcKK
	+oIntlTOQAEDp+dYWF4A4tsXxgKm+f9vnzrElCem0vQtFeendWFMz8aZByBLMHH6MViscmkH/tA
	V2shvbvy7gdcm5K5QZM9WGXPeSPeSbe3Mpv85Ojzq8flXfkRfLYKP7zL1BY9mRtr96iB6hgvMH0
	azTzcpkelhb61BrqOWSCa9y8bCJh4gJrqextFo15YK5i9/n1YYnPBlqfbmW0l7695OKWd4PNljQ
	xzT1e4co8BE+ShhUfaS6qLdAzt4+Z85Ya0VPf1BkLAlGvrJa2Uo3AfrJgZ9ObYN9E6iXPxpBL05
	oyxwhAzLreqAvSPNgvs6xuzw3/c8WYArepPVWDK9nQLKDynKu5XcVFKRcPC1YTKo4EzGP6IfOrB
	l1toaUAo2rmqQYZN/yrUVz6kTgMpNd6pjFxJZES7XJrgUsdRa6Yl+Z1ZZ2wHV3myZBR8DPKpx7Z
	iPDtubPFYwuDlKC
X-Received: by 2002:a17:90b:51c5:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-38f6a37e87fmr6475462a91.15.1785314541543;
        Wed, 29 Jul 2026 01:42:21 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642fbf74sm2447744a91.17.2026.07.29.01.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 01:42:21 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v3 0/2] mm/zswap: Fixes and improves the zswap shrink
Date: Wed, 29 Jul 2026 16:42:04 +0800
Message-Id: <20260729084206.77793-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 89fgfhutdmzkjter8jaqb3i37dtxz7d1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEC40C0004
X-HE-Tag: 1785314542-676303
X-HE-Meta: U2FsdGVkX1/x4CNJ4L6DypI4+BbDQYJ1eQHrbWnlNvfdBe7K+CGeF4UWcbWw9c2nL4S0P3UqlMLeNY0I4NXVhiTUEWXOQFuntLGOwfn0swknlc+Z86pXUFV/8k19tgelLgaeWt/54OHhfzby/5jjrbIj0FX7BNiWhFDfFSzlOM1aaXj7l5+bUtAuUYdvX9F3Jh7laf8Ck13t/v31oICT3IIJx23lBqrjE8AS0tTWbPqvAlzckKbOfd0D4ruUctaqMReCGuFkillaMlGHUlk+gJoYoLfjgH+ZZRW2uGI1HF7EdwhYeVX/T8zz0+lX5+NGEQP/VVHhhuIKPOeZcbIdOV9FI/dmTh06GxWkC56bUBDsY9FjK1Din/E5PDUVDRiaBJSKC4WQ/ti/ETznOWdFOL9h+gAH5EdMZGyxgb9HWjyIQCFP5SkopJoFdO5O+HFIMJY4p2TCSSJWy9+gHe+UIRPa0qia7wJyiBJ1INsrvRYyRZWRGGe001C9nmwyc6mbCqBOobRP5giQ+29/AdV5Y/lh/fJDZMQVsdBOlJ1h/xhgIeQ7PU5Gry3j4j0hhUQookIDcGEUZTi4PIDCLk6HRciHVqP0RfkRmupVlrLxXfBmcXFPqcPxtWl8RvHi1WCZqJiCD6MEvkchs07Tc/JyfIJPOIkbEm4w2GqBGuU82WhivfBDQEnfYNxnKp5L9uQCofr9uTzfjGsLKDSjRgPGMc96xwNbyGR9hzLDGGRuN3yj+HVjAt0FIVgMMwXj6q6ZLFz8NYKBkOc1eQMKJHIxF6w9+GYiR1Tz3OtvQrKWY+uek5yqJ7plXd+GXwKd0CcATzzlS1EorZcvV36A8S+A5fHLhKN9Tx3vMvPYTadS/9qab+XlRgmLzERp7u6YPND4eCXTU8Rwp1m+9xqoi1XUxP0ESOoplct6lPj1OFzZaFOfpkWbX/5xw1Jcg9j5mR7QZffgpGqJnjVnzC0MV1R
 xm2c+C3x
 9j4a+tWOcZ/665B4WynPCURQX1zp8D4adkswsUR7H+CKvg+Hv5TAu8NgkpBVCVrh1ntTsfd7wYbrdrcggljGIemSA2ozR2VgLJ5DLQM/g5GDr18DBTxmJoBdcOXJ4sI05qO1XGYdOC3zAM8o1OsmpDmbU34ew/88EPgRDDvKdhXEtfNwN5BKzUn512ZTSKOQM7G0KJGdCkEoGAGXvHUypf8RIi8dQkVhO+q9k49zk7CESIjQeXj68qPxBcWN48ttqCflTA60rDGIXoghGsvRhBszGUsTgsbEb/9pE9FEAhI2YUIBRHcw0DRZ8WNja+viodB74YufiviPzzVZVtsgEONRYtbw42Ez2r8DlQgKJ+8ZP0W8KPg439XaH4oDP3osxnUrmlUeOzgaDCPXxk46vJYCMiHNqW+dLQfcCYeMuEYPAFmSWCWIRJI5l64KPfIuYY6T5xc962zWm+/SFHnx0vHDuwBGUwbPzk5ZzjysehrA5jZ/G9xTarW2fpXZ2if7vvlixdqekznKDy03XL/kh9fXHZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

This series fixes and improves the zswap global shrinker (shrink_worker()):
Patch 1: Fix missing global shrinker when memory cgroup is disabled.
Patch 2: Extend shrink_memcg() to support batch writeback and thereby improving
         the writeback efficiency in the shrink_worker() and zswap_store() paths.

v2->v3:
    - Added user impact to the commit 1 message.
    - Updated writeback batch size to SWAP_CLUSTER_MAX to avoid introducing new
      magic macros. And enabled batched shrinking in the zswap_store() path as well.
    - Re-benchmarked performance data with the updated patch.
v1->v2:
    - Add a reschedule check to the -ENOENT return path in shrink_memcg() to
      handle the theoretical issue of prolonged heavy concurrent zswap stores.
    - Remove the shrink_memcg() return value changes part, and include a more
       detailed test report in the commit message.


[v2] https://lore.kernel.org/all/20260717085151.22822-1-jiahao.kernel@gmail.com
[v1] https://lore.kernel.org/all/20260714081510.16895-1-jiahao.kernel@gmail.com

Hao Jia (2):
  mm/zswap: Fix global shrinker when memory cgroup is disabled
  mm/zswap: Support batch writeback in shrink_memcg()

 mm/zswap.c | 58 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 13 deletions(-)

-- 
2.34.1


