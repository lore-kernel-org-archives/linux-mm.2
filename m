Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82C0CD8C90
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 02:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41656B0088; Sun,  7 Jun 2026 22:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2A76B008A; Sun,  7 Jun 2026 22:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE11D6B008C; Sun,  7 Jun 2026 22:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD98C6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 22:51:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AE9D1C2727
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:51:07 +0000 (UTC)
X-FDA: 84855218574.22.20AC0ED
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id E763E160002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:51:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BUWAbdgT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780887065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=y6pATA/q2zOEosF2pnrG8syYg/IBJ1PmeGXJDn1SU0Q=;
	b=JrDycqQCYaIoAqhGFIjp9e5GpCrHSSR9Xv5ILvo7h+UgSV5VhmdtYmC8FonR38rTwpw6KF
	38R9FfqW8Ts9HONXgDu1u6CpHnlXJmNXwb259DQQFPFX03DqhDSV/tBaCgVaeud0ggTuGd
	syAp16+Q7kBI56USisiHf7xbTSAl8Vw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BUWAbdgT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780887065;
	b=WB9q/U1DdLHE5V4J1DvQKbhCwh+3Xw8vLy8zUsnJgSv4rry+HiudzLcJRylpaxnNxfRp8f
	lp7oRl2A7VMEo/lQa4GlFHHsF5UMSc4m2LbaGiEQpTNCQTIQX9SEMcMF17EUF8NnQBypf1
	JdejMpdi0L/4xas/ejP6dr1xPnSZ0Kk=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842338c18e0so2660050b3a.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 19:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780887063; x=1781491863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y6pATA/q2zOEosF2pnrG8syYg/IBJ1PmeGXJDn1SU0Q=;
        b=BUWAbdgT+ieZT+/BLmy+mSknyy+hPkeLWlIswEIhJruwwaudhExz83Z1RylIS3IFaM
         52N+LLZAzZ7Y2MfhR8Dgffr+YMjJ0GZUwsKKpIDLKEGa5/lTzk6SifQpTNHYyMWq7T7W
         6HgMDL7vx6P/fG/x0uvYSM2S/GnA+Sw+nMOKL10DMoNrDLlmRnw1yOZhjVkqmNCtU6pI
         r9JR230Ua3Nb4hnVXH/Rec8gVEJKdPrVXPgqgeTVUBwURfBt8JeR+A1t9uJvAzJXt63i
         EGJ4FzMNghiRF7cf9l/QAZDoHPgWmcBFbRSwJlWLdysv54OSTdjGS9AGcmpbOu13KbXZ
         TXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780887063; x=1781491863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6pATA/q2zOEosF2pnrG8syYg/IBJ1PmeGXJDn1SU0Q=;
        b=FYp6CBKTah85XzkmRcw7dtnUh/6d0zTrzlylOH+pJIF2Oipyr6KUMl0D7+AErQQJVl
         ZwEouWgEHpbnADGG/2crtdZ2fnLbvCKM1tELZFXhBE5OsUhyGDvI8HcuL6/+/8QZzqRU
         hqPQYssphHExvEIAjWDRiXfqcvJlGTmGqZ87wLN+nKgp5JYsLYCSQOfWVQEE97JMbaNk
         hYSa4bGjCoDR5pInBYOQC75K3NhykZHuZ7vdkZcvtuHnqYZ2RLFKBoZMGFE9DXub4IsI
         hBNRDyiMDv9gmwTJYCKFO9eSE72RGU5eeOmiLvkHSNDSlL3Ojzriw5eGUHcW3o+GqEN4
         0pSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+SMaFAdoNHAdD8s0BHbzYJeFBReFkB9X+wSRNLndiqNGHk/OICoh5UEOkw+48pzfkQLQDepmiIXw==@kvack.org
X-Gm-Message-State: AOJu0Yyi524Z7Sk4nyr3VhX2AAFQQ1oo8EukCDmst4RXuyvSq29pgbPi
	WOm7V37D+T6PmIyFuEbR1GLM9UZrjYcupRJxrU1L7e821t3pKfEdkGHcA+lhF3dxJR4=
X-Gm-Gg: Acq92OE1xr2XR6/MJm3OPUIKb4vkShTDefeTd+W5PtM3AysRDBY2biJpeGYueeAuwMp
	mNIJlvr1tEqCy07TjNA49j7vSuQWuOhRoO6nREL6UOsOaXOwrBbINi4eY20ravjENVjZtm4zyRM
	vNknhI9ly9UQnBHfNWfWWhJ5uP95lqiVnovr80S12tBwpaW1qf8Iw+8KrmrVUgBJoZuZSnleP9z
	yXIMEVwU+ygZMvcEP0c/6QiewrgZfT9KVZ/AJplBlYhuU17Ue0DP1JInt/3BYODnS/Zjr3giKnq
	fJTlyDM01nOhh7jjBR7FQ06wEyQuI3myFBt1Q3F1Hd8tsIzWTNupLk2Y2FdCJKh1vvDVwiri5jr
	XeFtbbbPFuluhClrnmebjc1bsKr7Mn797tAnJM/iKCOLuSHd6D8onK0l9X60szcdJJ7cgnCH/Co
	b9zpOZqNfjpSeMm9SoxZJVnafOCxmTXSwA9fwgk5+rIJ6fYYad24GlBW7vehmgeGCcVxE=
X-Received: by 2002:a05:6a00:1942:b0:842:623b:38a9 with SMTP id d2e1a72fcca58-842b0e1e761mr13215260b3a.4.1780887063320;
        Sun, 07 Jun 2026 19:51:03 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm16033532b3a.28.2026.06.07.19.50.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Jun 2026 19:51:02 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	yang.lee@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
Date: Mon,  8 Jun 2026 10:50:42 +0800
Message-Id: <20260608025043.88087-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E763E160002
X-Stat-Signature: fzh6smcn4be14sms5x4rsohhiey3eot3
X-HE-Tag: 1780887064-732377
X-HE-Meta: U2FsdGVkX182BAWdZsLjAiSyArogumPpyhK+p5pSgteOrU0nYi0BLOaqnEdZETHZJ6aduKNYYXOpcm/1VLAEN/bpoRONIHQl3XhlCzOqQxMWqkFRz7AfuaaoWAtSgVLmzdIqXlLhVxKDaB+knh8WjwEdlH7qTONIo0kx4NWsMXh2iSZ5/7WErYquU5dagnQyQjAr9xjB/sSzkb35wzBlimJnRNUURCwOe+u9hKc9zD15t49RLp1jAEJPS6hEB8PPT2SMtGwoqlMxE/pDL7rIwnsrCPma55u4VhY5Lf4RfVqYSfyWsxOidayXrTAzelRSAP3MW4ktBS+l3XUf42ayHrssW2E+9JTZzcO2vH9P9RIVg+ojdgi21tEnClfkRySCCL9Bzl858ipIdvybaoW2/t5xTn2SzrNH6RWXmpu0VEaZYbmhMG3cT9z7y919JmA33F8uyOa4FsgBFYBUinlF/RlppOr6D+jo/8jTrbE/bw1WJpkEfnJ8nWiiwF6TTbcN8RPpToFLddBgtiremkvvhmWmE82BppVaFmujiGcVtiIxXWotUxxJkVEyZWZLQ2AXW1o9uyYbbf+ixWdd6hqqsCO+9yE54Uj4HPzrTTby+yHRf5ewnyF2fGoLJKjmrOgx9mb2W/HVqZAedJgzfubB1qlQcjGKqAk/jcwmElLfrX81UOZ4tliCCbWo7MdEWzQsCYVpLXVv62XHkh0x4epX+l+Jjtk9rQxgLybS4fQdvrZTtSy+OSONAt6D7zAqh/FMcg94Y9So4yYBbW4hkF7Iwn4InWD9qKEp8j+HTS43cCikiiFnPzjvWAWYx3Hs1yC6Hd5kLco8ccR0y/OgAqXAjAvNUhqaFpWc+H9/xvbO8m4T3AikGddMXVfkX5VbKypUgvuXmnUigA8QLOej5oGULn/46vM2baRom7lRU75dupg9VhDSmeilpWI4aQ6kgyHVlTdYnFJMCktD8lkn1yi
 Bxh2C4p0
 enJtqx36PQRbp3ocy18VwtPLuNudsg3nSIZ7C/GTppUeRL5VbaZB6GE0NWGfusyPD1VApFAsjAe4bTzujgRdx1AaKFDXz9p/dHuDFBnUBWFA+ScSIDOroE475x0QzqiYmSdpXEPSu9VNTjiQjHzdqBmNgjfhVDobVbmVp9TK8VM0LuPwzsx287MJo5kzvvyu22A4LTN0ttYKo2c7sDxCm6BMNaG/VdH5jyuHCWigLABqjwqOGxkaFKIrpmFQu+5yigQEmuCrbS0Mf/X4hvJpaxCW5DcHpOTTSrRoxuTR8j9zE5lxPXo8Dk4ExYVSBaAYjxYRnyteXNdbYeZVNiz99RZXe99qCe0oyUcMUkI7KtaNlGIeoGaiHi6dVRWBQchkWwAlyetvI0WMMQjOkqqnFAr+QIgB3pe29I2rD4HDumuSjpBHAXSSAZ/FDwZBXAu8B6WL4AWRtuWSr/XiakEPEPlAv5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PIN_LONGTERM_TEST helpers keep their state in global variables that
are protected by pin_longterm_test_mutex when accessed from ioctl().
However, gup_test_release() calls pin_longterm_test_stop() without
holding that mutex.

This can race with PIN_LONGTERM_TEST_STOP and let two callers operate on
the same pages array concurrently, corrupting the test state and possibly
freeing it twice:

 CPU 0                              CPU 1
 -----                              -----
 ioctl(PIN_LONGTERM_TEST_STOP)
   mutex_lock(&pin_longterm_test_mutex)
   pin_longterm_test_stop()
     if (pin_longterm_test_pages)
       kvfree(pin_longterm_test_pages)

                                    close()
                                      gup_test_release()
                                        pin_longterm_test_stop()
                                          if (pin_longterm_test_pages)
                                            kvfree(pin_longterm_test_pages)

     pin_longterm_test_pages = NULL
   mutex_unlock(&pin_longterm_test_mutex)

Protect the release path with the same mutex so that stop and release
cannot run pin_longterm_test_stop() concurrently.

Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Cc: stable@vger.kernel.org
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 mm/gup_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 9dd48db897b95..d1c2b1014f0ef 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -373,7 +373,9 @@ static long gup_test_ioctl(struct file *filep, unsigned int cmd,
 
 static int gup_test_release(struct inode *inode, struct file *file)
 {
+	mutex_lock(&pin_longterm_test_mutex);
 	pin_longterm_test_stop();
+	mutex_unlock(&pin_longterm_test_mutex);
 
 	return 0;
 }
-- 
2.39.5


