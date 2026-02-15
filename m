Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0891FEF5870
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 10:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE396B0005; Sun, 15 Feb 2026 05:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BBA6B0088; Sun, 15 Feb 2026 05:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AC66B008A; Sun, 15 Feb 2026 05:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2F286B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 05:25:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E995140A56
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:25:32 +0000 (UTC)
X-FDA: 84446309304.02.0CEB245
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DFFD180006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:25:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yk9ThLvm;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771151130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d7lqDo2NqhO3vqudm4FoktJz4U05rX2reLP4IjhP7Pk=;
	b=OTwi7GNPCHaKHzYgB20U2Px5U+nKsKa+7hOsqptjWDT3Ky0ITJB4ZdKEgynsO7M76t+gbu
	9Sf9VqG1sl3ClI5xJS1gxtTpga0ioyIXXkHavHrUhZMbFJl8uewWaBdxUZT7KoDGhnWX1M
	0V84lgReDcaQR6tGY0SIcTtcnsa+8MU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771151130; a=rsa-sha256;
	cv=none;
	b=PVrvLk7eT2mQq1ELY9CZCb54GbCjfQ1p0cApOp/oXsoshs/+WjsVko4O5P5qgE1SVyYhY1
	V8UXC69cE9U6qAcPKdKrrOK5KoaD2MUzVNVYbBFoq5GI8tceX0rhrAyshR881RfUygH9RV
	WgSftAQa431AlpO+4EFlRjiqtR6ItiM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yk9ThLvm;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2aadc18f230so15891335ad.3
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 02:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771151129; x=1771755929; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d7lqDo2NqhO3vqudm4FoktJz4U05rX2reLP4IjhP7Pk=;
        b=Yk9ThLvmL9zy9BCVOCUCZUcDCa2z6B/vxyrZsM9vihtUC2nwXwqSgP4SfQw72nMajh
         i3Y9jZ4EU9KAY/6qN/lq+j1oY0DuJ1B/guhLVotYs8KdPdus4kMJNgHDpongZGp5AUPy
         8xZ+NnHurotVbkcdxK+pQ02ryRqObJDhTOnNPlQfGsDKzUrmpHhRexbt2naNUHyOa6PW
         22z54tB3z/8OwZi/5pzegPDjyhgdoxaPSHM4CsLUmujrn/r2yIC5oc+QwLyv04Y9jTHt
         vXXJfqEKz8BG5Z7IyupMUFxxtTYAnXZcLp4hmhffB/liPy+5slEGl+tvoZH4ayX4th0L
         ySHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771151129; x=1771755929;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7lqDo2NqhO3vqudm4FoktJz4U05rX2reLP4IjhP7Pk=;
        b=N/4gpv8XQad0pmQgnbZCF1XiTMtucXtgqzM1jEBAZxaHy96Zgblp2GS8n7lBRCZZPc
         o7nqY5iuIra+HsruE55ovEGSs65yK6mXm++YOLuw40ZJ36YZINe+XyQ/QAYugVn4do4U
         Es8YnPZWiJYuAZnax/g+mWZKcIeArM7AJQ25fmQB3D22HjwRmJwYyTN5f36fr3VhVENH
         PaGU8CocnrA+oZOtNeOZFLVXR3NIVNLnJNHDCWil5eON76KBFnOhBCs+T/nrkwmaF9zi
         jDFZnM/kvlNmbb/oBGAj/G55bAZHWu2HORilblikoPSratkxkaLzcLOSGJtYr5kBlAkn
         811g==
X-Gm-Message-State: AOJu0YxdpzFlljXGWoz9Xo3hWoc5SGV7B+pUn6B1BXG75F2RHv6HWF+x
	2gm1303AvdODoRFxam8S1b63wyFnbe7A/WZHgRTP2Z8qRtfJRGvY/iJe
X-Gm-Gg: AZuq6aKiuO8/9YqYMN9Kh+fV9fDWumN7m75akN9BPzOv+hl87uWVVHEYTE10EFo8++9
	rA+CPjZhTlvd7nzqzvtLeziXecNEey8f4ULCQDkBAUNWVXHuT038WlUXuaDla+EmxaOnOLs0NOK
	gt8nfC5VMAT+glCoXE94udzrCVT62BJTwLvVejOJ5oExNdKtu267vNTrLd8I8b1NsZwTyhDAm3S
	Rngiy0U0iV5JkHSBIKJv3A26qG++dOqzDxwsWTzkxGDuYPQBm+qvVKP8ttQrmnD/VBT1UNwZudy
	fuL67iqoPF9rEuw8EyLaewyXeRC5mWkjC02bpY2V8vvfFIpGgRe0qFV9IJSXWo29UPdOB45eefE
	sREuEotXgQEQbM8JnyT7ip5vU7SeiOKmwc0HqdpZS90DQf+I7mJJq4UDPK1VMaTFR/eqJSify/T
	sn4pXqxHAT2K/OUdYV9oRAm2WTks8grmAV4khBTVUZCbDiu9vfcAZfE31iZYhF
X-Received: by 2002:a17:903:1447:b0:2aa:dbf7:7449 with SMTP id d9443c01a7336-2ad17501fbemr57945775ad.37.1771151128948;
        Sun, 15 Feb 2026 02:25:28 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a714786sm41862045ad.31.2026.02.15.02.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 02:25:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH 0/2] mm/swap: hibernate: improve hibernate performance with
 new allocator
Date: Sun, 15 Feb 2026 18:25:08 +0800
Message-Id: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MPQqAMAxA4atIZgs24g9eRRyMppqlllREKL27x
 fEb3ksQWYUjTFUC5UeiXL7A1hVs5+oPNrIXAzbYN2jRnEKsfr3ZBFZnHA3D2BISdgglCspO3n8
 4Lzl/q/tiIGAAAAA=
X-Change-ID: 20260212-hibernate-perf-fb7783b2b252
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771151125; l=2198;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zsPaUwrv0Ep8jMwtrRvaCSXD2/IbtK73bkP0ZVnB72g=;
 b=t5wPF9nPCJVtgwv9frP/KZqIAiCCzBg34C0hj0d2KRli973tstEbTbBUcT4gb2we2fqfqoLs7
 6n+nChJM20iBRFwsZIZm65VL0C0FeviTGTDiuYlASCM6gNFyK/KXuvm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 4DFFD180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: enphpybwitbkis46ezprq431594tt5c3
X-HE-Tag: 1771151130-200963
X-HE-Meta: U2FsdGVkX18ZttCiBOCQs3rJHI22JOOKed0abWrDDC1gYymj3PsunrAPvMFShEhDwU4LxOUZkAypN1nuW+JVHFpzhe+enpj4QOU2quEd53M2MnyYkZKWtVmzmt2TyiH8PEi2Q7RZM5Z43jpeCsxpd7SNjmS14va8AupC5W9w946X1bIVvEqU57vi6zscYvODVj/SJ95EuFJzx3EpJiziniD4pjGzwwam0rIXaDDztlaYyk3ZhHjOTzpi36ynZFGmPS12lJfEL6ybfhXevhP2eXs4/h4QmlXW8j65zcqQe4VhMi4/e4nbng+WOtJbtDKSg6skO77qpvHEabW+Z0Ax+vVABugyKV1VBxrkxbWXk5KORXP9trz7SndkDO423QaK+MZD7TFW64rbasVqezbsRCsu2RRdblvZDCGunbBUvJUCOW5KDKz7vo777+bEWvF01VUyyCi+CmanIQjaQnYz1Y9ErYzSYGiNNjJy21biqKnL1QfZ9FjJJDIiR6aY8dYSUHfk3fy8FYz9lRu1x/VU7bAxZ7JQj4LtVLxSAsv24MsFESMi9S+41pcjs8z3leKzav6PKqUC3XvK4iQquOfDdCVYZAQPDkGtY5mhznRLw7NHVHggMATE8SxiXhUBHIZl7wS6Bm5iEJvDbPp5p0enaRoG4f+SFkV+iAOo2njrzg604lQ2eoNuRdrX2ONtMAV/AQwQZd3tR5y5Zma1DFTr9vs+F4GvNCVAOAT4J3PoyV27jpMPyxjpJWuxJ94QiddVuhFjs7fubmo4q46fVIAAMRgsWFVc9Kzt41a9UJtAGxrko45MyBwSqnkGOhzIV6o4mQ2C4vzk/mu/0zn+4DonV+1RnWo4PIKEJh90cRpye8E+POIrzTxafk8NShJsKKtjyn/a8AsHn8hs1aBXA9g/YCI7pebvr+Ur6PnUkw9uhHrqewKEmCuQ9BrpzyL68FqG1PXVBgv86ciMNCFFabM
 qVq4mVUt
 GIz2LqAxkHKtqeME6pSSiqDxnyArQoXgt55PwfJrsR3tcm7P+eGF8NVWF+BRVNTeChy3KNR7aMhGwchZFyFgKuAXcGz+0GEd/hQafQXt7zdtIdeQ6KYaMJk4ys5KLjJ8DjmhkDdJg2LkSi0kaAJf3ImdScIM2l8T1M5cFYQHEgZUXJ/7e99JQpseL0lhm2tXjgoIlTH49ryyvYbDLpDFlb0Un9OaXYiFrUtGTSeQTAxWlv/zAnbHE1BmSM9p6QSYvE4kkk8QSN50WTnv2KlIOLzORqkuHc/3Ax2Bht7lex+IiIxWte0EcLbCBL7deofZ10QbkGVFbDEpr6iGnEeWcsKqcYQ4qjS+rOsJTY6Eyw1DHQGI/nPHwKdVjoNydaWgTK8IYO/DLsKhR2/vtIJHIBoyti6ThuTWrPIX0lCQwg/sFzlLrx+Nf68qUOD81OGZmyuF9wi4a55Ya/gg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new swap allocator didn't provide a high-performance allocation
method for hibernate, and just left it using the easy slow path. As a
result, hibernate performance is quite bad on some devices

Fix it by implementing hibernate support for the fast allocation path.

This regression seems only happen with SSD devices with poor 4k
performance. I've tested on several different NVME and SSD setups, the
performance diff is tiny on them, but testing on a Samsung SSD 830
Series (SATA II, 3.0 Gbps) showed a big difference [1]:

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) thanks
to Carsten Grohman [1]:
6.19:               324 seconds
After this series:  35 seconds

Test result with SAMSUNG MZ7LH480HAHQ-00005 (SATA 3.2, 6.0 Gb/s):
Before 0ff67f990bd4: Wrote 2230700 kbytes in 4.47 seconds (499.03 MB/s)
After 0ff67f990bd4: Wrote 2215472 kbytes in 4.44 seconds (498.98 MB/s)
After this series: Wrote 2038748 kbytes in 4.04 seconds (504.64 MB/s)

Test result with Memblaze P5910DT0384M00:
Before 0ff67f990bd4: Wrote 2222772 kbytes in 0.84 seconds (2646.15 MB/s)
After 0ff67f990bd4: Wrote 2224184 kbytes in 0.90 seconds (2471.31 MB/s)
After this series: Wrote 1559088 kbytes in 0.55 seconds (2834.70 MB/s)

The performance is almost the same for blazing fast SSDs, but for some
SSDs, the performance is several times better.

Patch 1 improves the hibernate performance by using the fast path, and
patch 2 cleans up the code a bit since there are now multiple fast path
users using similar conventions.

Signed-off-by: Kairui Song <kasong@tencent.com>
Tested-by: Carsten Grohmann <carstengrohmann@gmx.de>
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
---
Kairui Song (2):
      mm, swap: speed up hibernation allocation and writeout
      mm, swap: merge common convention and simplify allocation helper

 mm/swapfile.c | 56 ++++++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)
---
base-commit: 53f061047924205138ad9bc315885255f7cc4944
change-id: 20260212-hibernate-perf-fb7783b2b252

Best regards,
-- 
Kairui Song <kasong@tencent.com>


