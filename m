Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293EE606E4AD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kraXw5OE
Received: by kanga.kvack.org (Postfix)
	id 3C3F66B05B5; Mon, 16 Nov 2026 06:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B0E6B05D9; Mon, 16 Nov 2026 06:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8B36B05DA; Mon, 16 Nov 2026 06:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4FE6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94D2C80929
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
X-FDA: 85440704580.01.0B7D6C8
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7158440004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=kraXw5OE;
	spf=pass (imf17.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.54 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0PD2Hoi/mUsCD35EYP/4JLQ1DrGCC56gn3UV4l4u8Yo=;
	b=KpA0QSr92bL69hBUwGSwn+sM/4Yc/zyvMYENe+um6bt6Vt4vHWUmwsygKdvBwdd3V1k66N
	zuIiKEJCYUSx+dX+ZV6Q6I71TF55c5YA7XSufWH/OlSf4Xw9LesRYiJslRZYNQIqd2rm8K
	lMTOYgBkm/eaa1AxcIG7xcz8MH1/Oik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827208;
	b=SdaIS9EAR+4bQWebiyCAJoH2FFBuTDTivAg3QRlaePPGXi3vI+s8mee09Es6hf9vSiBnAy
	MKHkZNVgKlV2+B73qRiT+WrLCDu+FuEajsYs+b6k6O3fRNOkXvhEEHzjq0/zLviW0RS5X7
	cMa5arncWtREu1Plip1ZnKv9krNp3b0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=kraXw5OE;
	spf=pass (imf17.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.54 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b3b4944a0eso1340414c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794827207; x=1795432007; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0PD2Hoi/mUsCD35EYP/4JLQ1DrGCC56gn3UV4l4u8Yo=;
        b=kraXw5OEGKFqK8FXO0glwkRtvcj/PVPUnRRJSKQQFMm5sD4dXwPEMA8ACIEgXnSHq0
         GwaK/Fwq9AAFMJdZHSE9T74qTdejCmoqiBOe4/GB2058wn+9iQ+E3qU+EBsPc7VyernL
         Q1snAy4OO7bk3tWZGizzSGT0XAv/QNHqImYdpLQAYyFPaiRUtC7JCc2WWw1k2enNrNPK
         JB0HbULsX6L5w60JGPMa9UpLu3Rb1cILCu4DMkGGvzQYF9HvJ/Od+UCxqIgc8+2ErURd
         eXKbcaoUp5v5GZhUE2kFCHxGBDqve8fcx38LPwiFOwGHasFcIQyWhu7rLmJY64iaxM/Z
         754Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827207; x=1795432007;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0PD2Hoi/mUsCD35EYP/4JLQ1DrGCC56gn3UV4l4u8Yo=;
        b=MqLqK724mfi5NKALUDY8KTDYpoLC7Y0uQjdhB/7PCXMsDEBtIQjXxYp7MPo2HbubOj
         d+UfbY3t4T4awTIWPie2ixeeRobUcFkZwQ/2WKww9fqATZOKI11oKHFZd2KE0PO4NBs4
         KAXDG0+7n0vLD6198KO+ueMMgUAnVNf7l2YwyW1atkvGkV3nj3k2Zq8eScKAVWLbYWeg
         WOv1TAsFt53G2ZqjiriMtrZAo/9hkM9ODm2BcPK20ynBj4812XW/F5JJcHBTvDDlPFhn
         I3iJW649oeiStipFuKoIeE5PpeYfafz+rrOfsWErU73BG+b82O+pxPJsmbcoCS3k+MOt
         OgPQ==
X-Forwarded-Encrypted: i=1; AL+hErEMy2Z5xr5vOhvz/1lut5vOhT/BXlni3pi1lm+g3/HT19uisLNry+quJv+FA8l5Kj7gOM1UdH5Fjg==@kvack.org
X-Gm-Message-State: APuU4Z/YoYIAZhXqOYDLAMHYsRZwEj5nVeVVDqTgscsBWQ7Q+ZmiCsLp
	yHgjU0DgME1+HcoK0Ku3/QoDR1XUB4odhELrccM2MFoytptJWJaHHYz38yn0kLiniOI=
X-Gm-Gg: AYBFou2YtIKiLh1f8N39DEuzP12PH8j05ZPeqMBSYeUgEseNFYO7zU+D4PMPRUhuZWT
	DvOVSPCK84NiG3Ipl1XBFfH/fw9FSMfeMbNLR+htB4CS2/8W8oV+GBB80vl2opNzx7x1IR5Hnb9
	ma595dtjhneMTWxtD3kYwu/iTR/AyfPzVQ7s3gy/e3PEhCigOZ754o/gEoOlIZ9/1nuYT4iCgne
	FZC+Geam66l3FNOR6wRLUOF7H+u1ziRCwsuaH3gH/jbPQfJ/ZIZkUAceNtdcJnuzgkyj2tSPTMA
	KoobTcNQROBifZ0OFJ00rKs4WB0UvgoaVyhyvRsXHWPc1lvZVGZmywRFRjRZOhXt0o24u5nEZsl
	3Nn7jpsb7Ba4EUpSFYG3lQeW6IDO+H9d6pLt14D66t4fIPgaIrCtsnjh+H+lDnwqiy5QcpdcZrk
	SGIvAJt6ooi/XwqwfkJxWgKNf2VkPi2jcaJpRU3yxsjR8i9LoeZtdobE48wCwsTP3t2pAR6p1Cc
	GD4r8v1TOuxiBprHElrNHKj17sp7yZm+gRyp6U48QEDYBjeZ1KIEJh31PYg5LXYBhMQof+pCHXm
	VcY05wOXt0SRbwHCD805k9x2w2c24lbhVaetNJB4u9tmPWt2TaI=
X-Received: by 2002:a05:701b:4648:b0:144:fb31:a597 with SMTP id a92af1059eb24-1b5031695c8mr10468807c88.47.1794827206938;
        Mon, 16 Nov 2026 03:06:46 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b524049e0asm12522103c88.4.2026.11.16.03.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:06:45 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: [PATCH v2 0/3] mm/damon/tests: add KUnit coverage for age_ms
 filters
Date: Mon, 16 Nov 2026 03:06:20 -0800
Message-Id: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NQQ6CMBBFr0Jm7RjaolhX3sOwaGEqkyCQthAN6
 d2tJO5cvpf89zcI5JkCXIsNPK0ceBozyEMBbW/GByF3mUGW8iyEkBgpRDTZPwM6HiJ51PqkLpW
 iWpYV5OHsyfFrj96bzD2HOPn3/rGKr/3l1L/cKrBEqzUZK10trL0t7WCO1C3QpJQ+MX4QerMAA
 AA=
X-Change-ID: 20261112-test-age-ms-filter-9953843e7204
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Stat-Signature: pdp4eagq9h9q4e7ruhcbydqkodbfdfps
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7158440004
X-Rspam-User: 
X-HE-Tag: 1794827208-331459
X-HE-Meta: U2FsdGVkX18uBuYRoeB2VzPvXNjY7FATd1OCeK9pRtLRRDfxCJZ+2pP3xN43/X48eVj31KGcsaAholLj9NtCEAPeu2Rl6o6xx4MjwqT1MglG2wvN3c8KwI165pdZ97D6A/KHso3bC8PBTFV2s8/SFPIIyocL1x0z2e8i7Mgk+EXL0SFV3OOAOTrKAdfUEaM4PZ9Vg9gjrRNUzJNN437fA+pnQKOP0zbDraaQhqlmGYCPut87AhyOsQG5BVMPRd7EhBmLVKjEOlEd6I86f5527Y+EUIZQLdAQicNi5CAGM42jG4g7GXoDozS+SE/DKwm+4LDg0pweXPDEZVDfIvBJHOvEEhOO+/H48lR56rZXlnflIwWc1Bp3LYNPIo8oe1VADLZcDIoh7pwvrfogvcMe1oaQ+v8Yp8qGgweNCcduH9g3CfjImpHa+nvs7+gBGZbG3U6ynTqBe7sZWZZ3eWvIps07RcDT+CRums3R7l5DNQDN8BQEfKx9Gn30CE+9UPJAFQVVwOW5Br7wCc4HPRQ+jFW4vgys1+835Fp9DNcO+bixOYEhtCrZ370Z0UxvC6YIGzDi4/DQP5jOw0u22Uhl9PkK9DodUjCC7MSRz3vfWy41anVBXDufucMqXd5jrr1zYc5CslsI3G53lp4vLr/8+XFOBNKZ8iUCxT/ojweeFvbNVQTViIs/CZ/CbGqXegJyaRjS4/Q56VHYY5tPTEC5xcTQyjG7DkrUzmIuYz2XCw08xOx5yz1O8OpSnUbtTL/SI4qvYTq0ujhYaThk3jb9vIyWqpNgVndpKEfbDKu0nP82zvy5aUDRxU4Km16KNtMi6+wZSxUDPuBjkpJy1DiHmFW6sVrjW1CmHJY8rsiDo+kkrCLhg4z14BHaEFtq8+Q1Xzxp+Z/dxhPEWeiTRlSzF6be3Nh4qNmGZkAJOdWgvpZzet6OWdJr7SDNJj9AkW6cld6Zzxtkys+8ZOfBysT
 GBwFF0TJ
 Xv/FtfMNWeXtQqwssU/2obVFItTLkn0W6CTNqIig9UDEuuRTDCSA8eYbC0kIV1BRqBX0YHdZrb2Rs7LacIsJZYG8+yu5UhhxZAXxyrJJKour2o7nDCOd4Hh8gdGNGSsWn+BaGZc9juBA7sFlvF9zCBbr5Jbp4Nf7c/gCeti24siTP0cPdxPs2iUObKB71hO/rHHUZYunsoDQbKJF5aYu7RZRLO0ajFTayqEyKUZGpQ3tCaN5A8aHEVVAAgNffktw3UkGzjihOcgiz1CkOeDYiFOLuYC7TJXH7Jt7CzV1OjeJV0sfHITht14wV6ncp18jVjrALT7xcP8ZuUdNHoq2FxzqxEVmzweOj4goGrmitDgxm7gjnIDdLKJ3hzElnUGuUgb3ZKEALFo1/agHkAGbdFD27bkJR1OGLeCnIP4Z7JANuf/QEZ49yNYGmbzdMSTxThHvYeMgLViKKklnS22RiWVH5Duqfs81WxFagfHeQCyoll8YulMHpCQuW0ti/MqNyK/QnQgp6ALFYPfEsSWelYVP6t0bUEGsMvdXAMcUquJlr5aUpQ+Tr30PlJ6dE7zpgHEckgFO+XFPOrnmSyievjxJqBdGW0MgUyNNACzmLNZjKDkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
committing valid and invalid age ranges, identifying the filter as
core-handled, and matching ages at and outside the range boundaries.

Region age is counted in aggregation intervals, but age_ms filter bounds
are in milliseconds. The interval-change test checks filter matching
after both increasing and decreasing the aggregation interval.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
Changes in v2:
- Fix commit-message formatting, line wrapping, and comments.
- Set age and interval inputs directly in patch 3.
- Add SJ's Reviewed-by tags to patches 1 and 2.
- Link to v1: https://lore.kernel.org/r/20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu

---
Jason Angelov (3):
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
      mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes

 mm/damon/tests/core-kunit.h | 93 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
---
base-commit: daed51c9105158768a3949395135aa6e0a04bb7e
change-id: 20261112-test-age-ms-filter-9953843e7204

Best regards,
-- 
Jason Angelov <jasonangelov@ucla.edu>


