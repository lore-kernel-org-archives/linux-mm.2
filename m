Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63DBC88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBC56B0088; Tue, 15 Sep 2026 12:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9C06B008C; Tue, 15 Sep 2026 12:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A010A6B0093; Tue, 15 Sep 2026 12:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82CA16B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:37:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B23EB1C2738
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:37:34 +0000 (UTC)
X-FDA: 85216552428.18.0C42400
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3F20A0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:37:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BPbsF2wO;
	spf=pass (imf25.hostedemail.com: domain of error27@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789490253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iPVDtoQIiKo7Xq5jgNyBXX+8rd+sPKBP6LHpCTgUfCY=;
	b=vbOZArrGZmerbA8gR9vfUP6PhFuzIYBbYhr09a3mmkHALwbz4WURIPTssmhMbmx/TfVwJe
	bK4aeiRJf+c6I72J+KoHf7yekXGQk0r3N6Z/8x1ddKhddo9G+LRjHMP7kG/d2Ps81Ahs9S
	wZA6PbKR7GTvpuLK2plqfmwGSIZUeq0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BPbsF2wO;
	spf=pass (imf25.hostedemail.com: domain of error27@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789490253;
	b=EYS5GSUZWm7PKkf9kw7PhR5xfJkSZoeHToe7ndHj+frLoSARnUHwG8uzZIMdMBZX81rbSv
	c4rbyFALOyKYNiBMB8o8ApoPz+gWApXAIeKPaKCKlOCiE95TlKA+5FH+1RzvtAW/Cbskwf
	DILHKJNKMJLxTTWWSNJJ1RPCCVUjq1U=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c3so437086f8f.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789490251; x=1790095051; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iPVDtoQIiKo7Xq5jgNyBXX+8rd+sPKBP6LHpCTgUfCY=;
        b=BPbsF2wOVYQhFoS3pJI9rYIkY17qBCiLjlj+DiRAoVEBRizZYSXD7J2a2pwfe+zmPY
         UHk8UnB1Wu8im5Rg/4bkcE7YgDIknVANsw87JtqJzwGUkYTADVT7mXkDUd3tHV1+ycIS
         oguOzDalt7PfmscDiEJeSkuYi0jzD0WK9GgjirHbTX6zYC5n4TL/GRyr9p3tRjBcqZ9l
         XMlMhv3M9vIy0eY4ngftfjPAdXQqEyLkhGeHN1C+0WfVzCMdyU804pz/qYF1gx7JQ4N6
         kxTdTPYNAc9yzrYxrRhXPgoz6vVIVQhctOotzvv6lp8v2CaeMNGw0AD5vgV7vZGZ8gpi
         y42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789490251; x=1790095051;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iPVDtoQIiKo7Xq5jgNyBXX+8rd+sPKBP6LHpCTgUfCY=;
        b=h3rZ3xkoIyUmq6JPmrQF5MyolkZoGOh+5dTemuURt+iCVE0/oEOPrgc41KIC7y4nGd
         a9Dtdn2MiR4dF4TtZms2GZcIjMWMuSt8UH4M7nhYPkhth3RuNjmIr4n5HT9RokYXAVi0
         S/ipVQnGhvzBS7hdjCMrJdMUzdw9ulTx3sRAm5rOd7WIu2zvIdhtGR0Lj7QbaW1gF+3h
         J4gF0cZvQHZPySE2R673ixhQUdZ5gSAhrhQvd21y2stDTNKWgKHzat8OLHaztJMc6LjP
         HUe9xEKGLvDfyl2nJUyL6x63yo6LAc1wfFRVcgDZrqffkvS7H8uHii9dWnv9ybBoqT/H
         6+0w==
X-Forwarded-Encrypted: i=1; AKwUvBzGp8GRanBQJlg0f7cZSI8tbsyGafk+PqacnpcAUUjE8Kl20uHszzh3huj7y0K8FGuT6I0USFSaFA==@kvack.org
X-Gm-Message-State: AFuF++n90PWreIZp+T4IK3bAF/OAjGvBdeMw5TeRg3tlz++C4HPPhX5p
	yV4TGBJs4jnaNxPnEORz8SmmCrPUq2KCuJ6OAq0qelZdmGFWeKzbg6wr
X-Gm-Gg: AYBFou0Fr/GVIt/Mi/Fm07Z2h51J5Y8K66pn1D1E1EvEx5OzvEdfw1A8XpDOFekMEi4
	+AVhd5cJODKm6DERY+qDqNeB5851+QB8UeGz7vNjpWY4l2jY05UcqvfJZ55cQB6zJ1NcBGrs4y8
	/agGKwxcILjCUy0f6e87bWAxa2TdlenxClsqiXqWfG0SB7cU+Z4ujLQTCrl/jrwV9HymKkTk7VR
	cp4Qx7i7PU1Pi7MBRaD/jwhNMCnBBoC6iPw9dieNIIzDQzSm2GUwjMA8ZPCvyUhgxeS3jIkLn4n
	mUgvLOWKGn1fpgLicwSIgMKk+h1NvfvVon4/Lo31HDO+Qm/EdrH+U9rv5nwno+dlu0lnHvLe2am
	+gqsPUlh5pd+kBCKnEgu3AzdiFjiIl39lX4Xfo86Dd8koyOG+5fJbA5o/MRv1plc25aTYRq7M3h
	k7hae2654ajK6Ygf+u+Cuw6D5iAB58Pha2tGRv4gz/Ua7+XgdQACFD0jjE1jNEeTAZ0zA=
X-Received: by 2002:a05:6000:188b:b0:487:999:7119 with SMTP id ffacd0b85a97d-4870a8d4169mr2232089f8f.0.1789490251328;
        Tue, 15 Sep 2026 09:37:31 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bef7687sm310609f8f.1.2026.09.15.09.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 09:37:30 -0700 (PDT)
Date: Tue, 15 Sep 2026 19:37:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm/hmm/test: Reject overflowing page counts
Message-ID: <6f0d39089e938d4f53dc72632eb84aca34de7015.1789457465.git.error27@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: ri9id39qpszny5ji8nq43y133rbwd6tr
X-Rspamd-Queue-Id: F3F20A0010
X-Rspamd-Server: rspam07
X-HE-Tag: 1789490252-665013
X-HE-Meta: U2FsdGVkX19Zd/M905m51gJ2VtuxiiMiIomRbfg37T6FHTLgFYEbR42edFg+8tp9/r/UkU4FDHI20pEoMpWxVMwiVliZQKdeB1AOD+3wE+OE2mL/MJIgPXdjVAtAawr4/TncN3RHozDZU78k11B1ck5K0iLBsamxIPe1dttiof4GfqJgTV5Y7Tc+P0cV6DqFAHg30cwS5FPODbL2CPS4dGpsbRWpjjsY0r5GGe1IxIFLB+mAz00GqQShOSekFSpY859vnyJNqmGy5q6IO9sDZnP161D0HGPJ2WkIRthNIsHVZNC3mT/sgLHm8W46pTsnaTkBymTiooDf/9VnRMtbNKlzrDnMHeIwPEyf/+2kC/n5qD5Z/GNmWoSap7TrAZ0VWJA6QdLrtKVhSQtr45190PRhz6MtJqPHxy3s0NqygybY3NsElACuK0zCRZ+ana/CsQI283FwYBZTjT/73Q97LTkeUvEF5YCv2cXvzLfTItueSH7yHe4dcvdEu3IbqngFMCc53XizQallJ8qaNaYHoj4v5o7+0O1/vwhvyfXKCoE/n2V0CqL2UhW02t3DlcmmMSYUtzNWXuXibusNBF282kv35QrPCC1opERPSqc7JAgkWiDqOj2Bn8F7uMM+MkYAGcEwPJ8ikb7CLE3OWTJWZSWb5BEAOC7icurTPeh/RL//6PsAp2w/NbTxXWznELDLPv6toXIwzYlBSVSclBf7FyGl0ODuqxz6CKYUulYxGjWXMYI//L60qKQPzST8G99sz1FxmLrDef3Rims3VGXXkO/EmGvT0Yiu9LDzkcwj1hbt3w0XbrEFGKHLbyEdEySs2nTd4jGkVxzRqpDDb3dBOcXlJ8pXzwYs0vxJmWaVUDTQqc4AQl1lBAFGmdgr5Yce9jDap8+YK8Q+MtbQgnMp4bI0wcCR6RacC5H1rDYSEdJAL7vVT2UzD4NRogo9bTEVT1dF3TcO6QtqO7aICGm
 7dOM7c68
 C7xXszOtVUmMfg5f8TbHECBtYZ52Fqxi6kJ26ky4uANdTK+GgJE2ThNoU3KlwC1JerDKjFt6l3BLABPzdDg1vqfiKrNCkChOUnlWgXyCCxHWnYCtWLSqcbVyYj8JnfdZlbrw8p+DoyEttMsv7OSEMAy/2tOeoBSts7L6xOEyTsXw7afVoxwZOd6elGcdURzXstV1D7rDtyIs16nP6G4JudxcwQ9hZ3TOGCahKSdv5xiT+HJjzba3sBV8mq0YCWmSPnN6Z/Dgg1+w4hDTEAx066nOA557mZdR+NuzIL2FASuigzDi6F0yTuaiVfOnO3pAOkznQOnkxF0IhAqYPed8XvskqApI54a/wf23bG/71js+BxsnWRhDARICd7kGXX2wgBzqv8SUEIoYM1oaO33c3qoMIwdK78Kmg9NCjdI0BrBcQOr5x8iCQi/TJK4yj6/s5wRa0exQzfdPZV7ghr3aApzqYhRKqHvz9Hm2TOEOs1RS/3YonDyqd3H+rNTEnjyz/ffc2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The number of pages comes directly from userspace.  Shifting a value
larger than ULONG_MAX >> PAGE_SHIFT discards its high bits before the
existing end-address check.  A request for a huge number of pages can
therefore be accepted and processed as a much smaller request.

Reject page counts that cannot be represented as a byte size before
performing the shift.

So far as ChatGPT and I can tell this doesn't cause an issue in
practice but preventing this integer overflow is the correct thing to
do.

Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Assisted-by: ChatGPT:gpt-5
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 lib/test_hmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6911daa9f854..b409c42bfe6f 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1624,6 +1624,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0


