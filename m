Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF6ACD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 02:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0DE6B0005; Wed, 27 May 2026 22:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682236B0088; Wed, 27 May 2026 22:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570C86B008A; Wed, 27 May 2026 22:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44F166B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:48:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE532120709
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:48:56 +0000 (UTC)
X-FDA: 84815296272.22.F339789
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4381C0008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:48:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G5XA2iCM;
	spf=pass (imf28.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779936534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2mHoOLXw1ORyK+bjLW8SaA8gqA96ImAqk4cz+WkSseo=;
	b=l1H4nlPTqecfgullO3h0crPeleP8+RHOu4ZFdb9BGZppaYVXY5w1MPl1EdXiaFzfIRT3Dc
	gTrcKFrYzORfuetBsd92OjHnbxWNnbLRm0UZxiLxFq9VnuXnKJnG0z/WyNpCNMlBN7cbRf
	wUHxf79fDlNLhMRujq4OkxmbZ/Zt+ds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779936534; a=rsa-sha256;
	cv=none;
	b=NFq5pmyWrf2jsLrFMG7EU8cQnhSy1Mb6+JUL70GHIK33TTulwjjJqIQ6JGzQ9luR2EUNtB
	byzHvubeN1DTOxG/7l7ViQLx595c6K1OoTXjnObBQG9NBDNj5Y8U5CeFWZX3LNPACADG2D
	53lAtYUthG8b//L9csGy87glIyjuSHQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G5XA2iCM;
	spf=pass (imf28.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-838d0b7c950so8755246b3a.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 19:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779936533; x=1780541333; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2mHoOLXw1ORyK+bjLW8SaA8gqA96ImAqk4cz+WkSseo=;
        b=G5XA2iCM4/LEbE4qpjZgUMzOH8EJ7oMY9BCr28kkr7eyLjr5xdplrayMbUQEAQkvND
         Tvk+yn0AsGd9nucwwCE1kC4JQh/sgror/PZDUKkZCBW74MPMd22j+rVIDuUOFMdQ3/nJ
         H6WQaJ+3mV5o2zHZYpn6R/fBtpIMDEkbCb259gGUklkIcO+c3+3PrYgON0lhHctVJp6+
         o20yFQB/qJM4oeJstKO+11rS8OXULmR3eSggrLSrCx75IQAdDvVcIR2z1Xc4RY9vFRCS
         dcTmqwPevUWaTSlZSrzE6u2zI4A5crYtunHf0oz+xyFaPaSxjTSgAw9dRKW+ySBKR4wf
         zQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779936533; x=1780541333;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mHoOLXw1ORyK+bjLW8SaA8gqA96ImAqk4cz+WkSseo=;
        b=SV9n/pxjYWjxrKfcwwjed54oCb1aNAncWxXe5K06Nr6AR029bfTpsv7EEIwLBdL+6V
         Hrr3Ibu1g7hLkoYQaqNiHCIueX7y3kkS+nfOWRa6CN0RHmzZvvs1Yfcjq26Jk1uXOC3f
         yHqNmUch5eI0SNEOG5sfnOeTj/zk0jws8GI21LHtoNaOZs7PAtOxxFCFM0eokWZUWU+8
         FaOwPsPP9dZcVzIy/Af6fNZntO1UlmeaaJ9A0A8ybXQCuXG7JwmEoG55ca2IVA1mh1HU
         49tzwlFWvPqLnZh4lS1fD+xrfRb69Il/J4taXqFRehIXPqKqXkiZSoiFH+ZVDGo+GdaG
         6MhQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Oae7HpPj3JUrmtKHjtzgIXOCyJXa56r8SZvBuD7dQNO5BLYB/8aZYCIbYi33fJBRwQpag5V/k4w==@kvack.org
X-Gm-Message-State: AOJu0YzKlkShUQhA0FGKvlaYSMSeRChjNZvYD9Mbk31kWDDgD/MO4Bf9
	elqWoNLxqVzE+/TPpk/zDUBV/rSWVpy1fTgAL3Ea7Z7TrRwoKMNzMNs4
X-Gm-Gg: Acq92OGQ59/6jocSHJjp0YD3QM6qgllWOtYClPHGN8bbNEaoHxQKoFLXCEwfJHoDZhI
	T2YfqT+m7Fs7DC4Pdtq8wINzmA0E/EjqW2dYkzV4z9K2bTKPSCOjoqbTYo9KdEGnotclvnlkXg5
	nqI/7F/y1LKGLQ7b74UHsbYuqr9fybE794xiU2XiDjTGjtyFTUqPtHHu1DtdAD3bB9wYOc+wUjh
	9YJ8kX3bz8Tuy1pjv/r+/FMbAlZqYQdImfuJr9MPeSvhyCa5URlEa7Gu96eK3XRro9dGQ3F/2yV
	lpQG/3B99ieeoJaolSXHB/MmLIOpYh6Ww9CQ4v6w8KVw2BWmXQNI0QWQwrhOnaXYOZ8dSI6N8nL
	ac03XYPPW/YUGSIJDRKfb/GEzRIHl1KhTL1Gv3ORTxKL0JyNoDGpOmkxPvgVK+FKJvvDbJYZ/vL
	udGiPghVXuYMKVFqFYsXwcpuutdmvGcT7Jyw==
X-Received: by 2002:a05:6a00:91c1:b0:841:dc7e:6adc with SMTP id d2e1a72fcca58-841dc7e7888mr4287582b3a.19.1779936533561;
        Wed, 27 May 2026 19:48:53 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841f3cbcddbsm366877b3a.4.2026.05.27.19.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 19:48:53 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Subject: [PATCH v3 0/2] zram: fix UAF in zram_bvec_write_partial() and drop
 dead bio plumbing
Date: Thu, 28 May 2026 10:48:43 +0800
Message-Id: <20260528-zram-v3-0-cab86eef8764@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAytF2oC/23MQQrCMBCF4auUrB1JxiZVV95DXGTipA1YK4kEt
 fTuphXBhct/mPeNInEMnMS+GkXkHFIYriU2q0q4zl5bhnAuLVCikRoNvKLtgaSqUVPDxhlRXm+
 RfXgszPFUugvpPsTnomY1X79A8wGyAgWOlXWE5K3fHdrehsvaDb2YgYz/RggS0NO2Jqlr0u53N
 E3TG7bTpUPNAAAA
X-Change-ID: 20260526-zram-b01425b7e6c6
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yisheng Xie <xieyisheng1@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779936530; l=1246;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=hEMiF3S5n7GD3rgFs1MSCMOijiI81jrIRmqCj3tGYEk=;
 b=b0BDviFETroiomMLL7jl4q+mx7Zxj3oBLg5d53SGnqIPES4wURls/SzkCaj/bSMVLu7RDu0Nh
 FQNi/cpR0KuDbjHlHbFkwfXLikSkTIE9UCFOw+gYAtjyOvG21yJL0pA
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspam-User: 
X-Rspamd-Queue-Id: B4381C0008
X-Stat-Signature: wfb61hasu7ibt6gs9focmj8z365p845r
X-Rspamd-Server: rspam06
X-HE-Tag: 1779936534-160533
X-HE-Meta: U2FsdGVkX1+94+HPDuYJrCBqip03uxiEqpsZr6GwEw1Ye2IsHN712Uf35K4MouyjkHryHGKGDi3nO1sCAwi5nPY3zVqDydNGraaKhnhIXz1w/aQCv+iD2DwMlHEvkOaiQXwODlPeUbby22VGR1ZCz5wMxvN9A50beFmMLCv+yxXtI99VSpLPECvNKRuar3Y0+99sSw60jgki2rDgMSpGp7kYQK+ds2B2nhfGUHsZYBzDCdDYlqYF6I6dSnqlZhSMDKNGOZe1x+Goteu4dzXrwbeVzzVO9oRl6ZLz64izR9rruELAZhP0DhRIRPijKJArjEYWF1FRRmXlKZ6yomAozlgNttuQ5EksQi+O8gptKKOKpg9cGgPKUbElszQunFD5WzCbfSKp3io0RmFJNa/cUzROwIApqCaUNaukBehJHTC9P1Bds9XiTSN/wlAyCZBJ077EGNzBFU1cUIX3MLXHgkQRPKXqlXz+oLQxyGfU+O8CedfXu7mgwehmCP4OKwInOdgZ9tBP+qurrj+h7Hi1HiouhDyEanhs4rPYz53lpHqv9GOsqjuIanMMITZa7SWLzBNGRFKQvwKuj4MGhRYNlUAnfpyf5orqMpeBIiR+t3jYl/vn68zZ81BMXW9DawX0uoMoBcO1wuhQH/F3Amm2OJ7DJxnLK8EA/Hul/hChc0uqc0VDUfv/EUc0NON17JUEDrqjffVKLf7XVpJZgFV2yk4OOBPtCjZzbF7Qgk6rZ2t0LJYCsY47MXpQYJHtYJgf7XGs9SbzzBT70ltppdwwF0WKzAQ8R9BqEOYoSzqvny+5DG6nSXkZuK6SUJtQnjt1LjQgDVALL0oShxYiX08a+sJ/Kt2GVHpLKOcpOy4nOhyNjxROQVvSyeLXzmk2ng2vMdQxVygeDalPyA+vXBU0aeOEC8LKOHdpdcWNUWNmyzSNMtXYltdbBaaluUSy9W8y34+1Sl5SsV4ZzsgRw/C
 UtZ9DIkV
 L1AUfVEGksDhrnF42VaxzmupFUbXx+3Fpd8mUDtlCXrxEmdu1t2b6QPUHaB1xTPEOAC0Ohf7Mm7WvCL09Gu5Vv6LT1FQjSbFUyfH+GL/IKdaS1N+jw29ruUwouESNTgEn3SB++XUuNL0f2TQ6dXjoij8vtID1eYn0B9dtsxZ7EJXlrcHnuK0/il/26OCZC5zjhin7BlLfMM9smawFnyAnk5vEi5TQNTzenrGPaDn5sdyfHYXh84Lc1k59OZ1ryuCnneO+/zC8eBYKlBEjvUeoHzrFmRKVH8rEseDOk6acWSbeWTtJqfUkQy5xmh4s4MeyB2+/Ss0vS5ORwpgG6WfKsMHxu2QBcic26WIxSlxt9iT8zPxI4NE2fvI5MQFkoY8wk12TfWOol4c07G1Rgob8eDmFeroru4+Gfsz8lHVygyAgnWZ7iwxO6HcnF0Y146gCIH5QO/XJsZEyRpGJIExrc1sgnu1dcWMMgeHGLkL0fxTaCQJ0Vx/vqSnU1X3egVfCdd9IIbrKaHWOJqtQ6ioQ++XqlAIVch20h/Q+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a use-after-free in zram_bvec_write_partial() that
happens on PAGE_SIZE > 4K configurations when a partial write hits a
ZRAM_WB slot.

Patch 2 is a follow-up cleanup that drops the now-unused bio parameter
from zram_bvec_write_partial() and zram_bvec_write(), no functional
change.

Patch 1 is tagged for stable; patch 2 is not.

Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
Changes in v3:
- Update Fixes: tag to 8e654f8fbff5 ("zram: read page from backing
  device") per Christoph.
- Link to v2: https://lore.kernel.org/r/20260527-zram-v2-0-2fb84b054b5c@gmail.com

Changes in v2:
- Add patch 2: drop the now-unused bio parameter from
  zram_bvec_write_partial() and zram_bvec_write(), per Sergey's
  suggestion on v1.
- Link to v1: https://lore.kernel.org/r/20260527-zram-v1-1-ce1acb2bfaf9@gmail.com

---
Cunlong Li (2):
      zram: fix use-after-free in zram_bvec_write_partial()
      zram: drop unused bio parameter from write helpers

 drivers/block/zram/zram_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)
---
base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
change-id: 20260526-zram-b01425b7e6c6

Best regards,
-- 
Cunlong Li <shenxiaogll@gmail.com>


