Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D222C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 09:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C106B00B5; Sat,  4 Jul 2026 05:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6B96B00B6; Sat,  4 Jul 2026 05:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD306B00B7; Sat,  4 Jul 2026 05:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABDD6B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:20:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAAF61C7D88
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:27 +0000 (UTC)
X-FDA: 84950548494.24.6B9D607
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CCE8C0003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gk/xZcfc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783156826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n6qLdYGOALiuk2ImwIzx63KLz++z+3etwYWDzOs4XTQ=;
	b=DRQHHvQ9bcTSGfdLqLvxIJEArc7xlqoPiUSsg2G1+Nmu9dV/UWUTpAa2QbvQxvYZxRPO7r
	pibSrC43+3Pzg7rhiXnopwjM3nGGEx66Tb7LJboya2vWMHr9OJp2brzse58SEuHy8KfhHx
	KGzqb9LPVzzrEY2z7YY14/trPsR7YKQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gk/xZcfc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783156826;
	b=HlKB5zy3fecK1X0i/HI2sCN04ahmnl863DRzEid11rEL+iMo06VKGKMHG1ivEOBaMTC/ZI
	eS6FmZhzEb3G9RNXEN9/cQe5KHUYzBvkzBhnXDC5qJDs+yTrPia8C++xfEhZK6oqX71TdU
	NFRjtoy2oJZhnold3I5xynYBRP8dyhw=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aec5675c46so1295373e87.1
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 02:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783156824; x=1783761624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n6qLdYGOALiuk2ImwIzx63KLz++z+3etwYWDzOs4XTQ=;
        b=gk/xZcfcw9ed9+yf7p24LWQ5nqZfZ9T4cd+nNqgZhmf2xKf0coQ0yEDf6LmNm4a3va
         DhIW80Sgu3xsKzguDGLCpj3Ru1xFacD6+jZ2yxyYXi2kGttv+0RWSCZaJ/R9If+JVLyc
         y1CVebcVvEytJqp6IslzU6Vp/0pRPDyVwBwuQ0xJcuU5jNpQxDD3Vub1k36SK+bqndiw
         qdfsHIWMe5nEEDc9aLjXXEFIhAvbdfZC6eAxEIQOaqGHRNBU7etPBvAEGZwCnMoZ5M44
         BK5b5fpa7BMs0ps5bF6WgqMWJ0RMH6eZTZe1/giihmNklpBM3JxRQyDtWqjBFSZZ7W5v
         CSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783156824; x=1783761624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6qLdYGOALiuk2ImwIzx63KLz++z+3etwYWDzOs4XTQ=;
        b=V03HBvaSnGPSFMEAE+RjsSn2/qEpVO+NCu5WtEjbF8/MBqK7V41qm6VafC0pKW0nkk
         IjusAvjXjlIZ0vU3wY3f3tB3WKI5my4qed2gSx17hZzuNHMT2+hnmOMze+eF6ZBdYDyR
         iwpGMVwzEDgtxr4WzHvmN6fOzCGdvnPE63/+dIWu7wqrQrc634liQb39BBY3i6bEomTN
         l/xvuyVlvh1CVsfWw8flzQw6jFbD7BFjd8MEAHxS94VSBkunPPhBXCdk1idE5JHa4NTY
         17GNBJ8EQDaxl8ET8GnJTB16PZFTjgb8XKnYsSnBG8CfWDnvW5fwvLNJO2UJXIyToudS
         N0xQ==
X-Forwarded-Encrypted: i=1; AHgh+RphT1eNQEsgiSNdEXAng283UVo2HcjYU77PKOK4NvHVMfD8Y+CXskxG7BJiXVhGQAvOt1HRlEGMkQ==@kvack.org
X-Gm-Message-State: AOJu0Yxno96z5w4eGIbyhZmJdpKb5Kxi0FUOn56OiqsyrFH58+JJzxDw
	BWp4+npZPiu43WZnDQ35u7DBImx9NL7kUpbg3c9WfdO83l+k8xlHgh+/
X-Gm-Gg: AfdE7cmmGPIWDRmKSPdQL4z8QRzcY+mmuU87+PcCiSwMW0wrpYNH2xImS84ByUOHfzO
	J26HCib5inwaeR+8QGTmU8SoRpMpI5+EaTJ521kcQvyJRwPuPDllhsWQ26XAu1EHi+g2dvejeJH
	/OihQQAn+WTf+UILsFVjr/qNLA+Os8HJtLspxFRDD6h+h0n28Y0X9bR8snm6zbKbpXXU9/Db9av
	aaEnL3TqpT12Dt3LHURUYN+MrXlhgRQVZ/SJUb3SfuDJSjiPv9owj94mf8lGD9NyYqay/qOgFjx
	q99KcP7esvgHAcPNmdunBxXBtEj4gqvgMGotQgCAXt9MorvN+FMTyLfMSz42qyHeFg/kwaxzWA2
	fz1WqCqMuQfBz+cxigSTu1+r0BTW8yACWQN+QA31bVs5lZlmiVi+7NXAaS0MznJOM+Oci4Udf2F
	51ksrHhfAswv5lPPA5v7c5ZJQc5YTPsdhwyiJMy8Tz41+j38kKE5rynJCD9QMAWtzFypxmOngUc
	14zVzM=
X-Received: by 2002:a05:6512:6419:b0:5ae:be4b:675e with SMTP id 2adb3069b0e04-5aed50957fcmr366661e87.52.1783156824192;
        Sat, 04 Jul 2026 02:20:24 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aed13770fbsm1149063e87.30.2026.07.04.02.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 02:20:23 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 0/3] kasan: common: cleanups and deduplication
Date: Sat,  4 Jul 2026 12:20:04 +0300
Message-ID: <20260704092007.3483-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CCE8C0003
X-Stat-Signature: tztjwng7uoajwpp7a85fk6ech43gjq4x
X-HE-Tag: 1783156826-920799
X-HE-Meta: U2FsdGVkX1+RHJLCQRn/notesM3MQjcOBFAgl/ffhmME/RBAyPH9olxkTy1aHGGuZ6uXTcvrV7U2LQt8WXEC5Dm65VQYI+IEvQz90i41MzndmWdkT4cWbRSAY4jVEivDxZltpgLwMTwvfT4xwB7Hw7GGaUnJNRjsebDbN60zyqLib6VTaqfYAx9/IXeyISTd+1okH6XZ1A6ikexDyXVsH+IuX4X3bwyxuvg32x2VYnB2qocXgHhA6n9q2eguvr3Mi0I1tR2XTFUDElO5NGsCYUDq+m7CKL/eJPeRMLf7oK8LA0TlVt63NibPQB72i29GFzs+c8X/QEsNZhwoa2Feigv5s+AuGCpyO/6ZP+4Sz1n3WBLN0jRHQkOR9vspGJ2jE51FzXnn2NB8poXG3YxiLjxU7XiqxoDB/MCNnMeP3dduusiGPgPAc90pA+taYrg5KYUjLuKtvnBVP0EkjbrCbP370x06KL9LQ2imKNdRGua6Yfwce5yAm2Acr5EILv2eVFAPldCjMuTJJJ3za6edOYVEcz0M3O/ju4mGorZ8jCncScBUZl95rl3xbqOLkgTuHF6B6UI5TKBomgFL/FM4EnZsFeEeQWQ3x3x0Gk4t3CF3t679zv770ym0B1066fc9rxrh2b53zmBC78ZeJvt9vOJ4ToOFj7YC1+JC7aHr0e6exvzy9pGDh1sraefBlx4ufJ4FEPPYyuNl/k1J1hIpW9d/Wy/Y2M0KINDebhVcD8zN3ghW+nWfrlXcVyyaGw5folCtKVoDcHnDoPEDvXw6K69TI9/VcrvZj/C0UtQQKTb0fyfiU4TjjqtN65wGsjRveOWGOZOkE9GFE7Nq9zKyFblxf1ax/sLRtv+w4xqx3cwlVN1wjVydeODgZm/EGOQ4wNlwJrFtRsXy05MUGhGuTYawtX61LU7dIXxQF27UqngA27Pi0S5RB1umpp2V2IokX4qWGPXz/Xhe2QlE14X
 0VSU3qS/
 5aSBwu1bnG2ej1vIRFZmFj7Ya/ZpCNdimH8//vybqedKKKjGYOhZ6iYBdZtzWe49QRG3rY5f6eeiFOlkKhtIaYyB+k9t2f6XTGqJcDhrz3ZKQg3UW0uDiacxlOsMQtJl6iN3KrXgkEf7fSrkV7XRm6MhTbKraTSKVu7wNEfrNeK2RVLz9LmzxYYLFhkY/Vi57UkH/3PnAC9Fu/fkWw9pk7TqvqNKy9Z5kiJWZB0g+QeUBNyrVh2cBin73MkqPr9Hi43q+/fRaPnxFtIkwpgLlYMycjcb3tlISLZkEgErWKohD9Gitpog1rrO+8k2wQp1aalerxlIx4lT+JsSKW0iiJkD/M3rE+4sivOOZdZHKGnzuNIidkK8tIIl7dX+lQmQZIkVQeDxjDgQxo0hM9sYEbqSsBNHS7hSsHrkon+R/fUjs3iRePo4wKara4CF2aKQPi7zNbExY2+7M1zY2EZpjLgNAuU5w5FiMoMyQQAFc1TQZ5wO/DRE9DzjzBDbTJOmuiBz+1H+hlprkZLPQp03eI1XCdSFyqq0YNtWYGRUZ2kWrC1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series refactors KASAN common code to improve readability 
and maintainability.

Specifically, it:
- Introduces a helper for quarantine reduction to eliminate boilerplate.
- Utilizes the standard ALIGN_DOWN macro instead of manual bitwise logic.
- Replaces a magic number with the KASAN_TAG_KERNEL definition.

Igor Putko (3):
  kasan: deduplicate quarantine reduction logic
  kasan: common: use ALIGN_DOWN macro for stack alignment
  kasan: common: replace magic number with KASAN_TAG_KERNEL

 mm/kasan/common.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

-- 
2.47.3


