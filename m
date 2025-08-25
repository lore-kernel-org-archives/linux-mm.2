Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97FECA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 01:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2C76B0093; Sun, 24 Aug 2025 21:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A756B009E; Sun, 24 Aug 2025 21:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB04E6B009F; Sun, 24 Aug 2025 21:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9556C6B0093
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 21:34:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B0271DA6F1
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:28 +0000 (UTC)
X-FDA: 83813559816.27.6BDF2C0
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E49840008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpTCvkmZ;
	spf=pass (imf27.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756085666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4ruxANvCNocw1N+b5yop4AxWitum7HXSiuMUa0R3Qfc=;
	b=EahkVUmhjoSybD9IUxKwEnnvpThG9zSqc7DceT7ldNo+wUzUQZg635vUK2thKc8gwY2/g/
	YbyWPoGM6EvyA7xs8ZaUAGODR6Gu/jd85Jx5TllndvvF3a5qj4tDF/Wa4FlttiRmO+Cxed
	xx8D06ImrT+r+TMnSI5jFXQf3MAwXvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756085666; a=rsa-sha256;
	cv=none;
	b=xd5M4rk6fxz7ErBvWZwxmTgKNVc7B8UuxeDXsq3c/KTfIBXGb674q52vtrE+PdXAutYRi5
	oGDq6ZTzkGgxfmy/Lr8bq4JA8KwAv4mda/1z/lgZhotGKb9FbWb3pkSsGfuU8Ppik1fjJ0
	uh7nxPoTnsm4FItmG0e7uaf66RpNXVs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpTCvkmZ;
	spf=pass (imf27.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b47174c8e45so3779211a12.2
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 18:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756085665; x=1756690465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ruxANvCNocw1N+b5yop4AxWitum7HXSiuMUa0R3Qfc=;
        b=IpTCvkmZqEoP3kr2Lan8VqbSH1pos9rtJkMocbU5pNvgsFkTePE2Ws+JLce1M29MD5
         KSwdJovyKtPyM+Vhc9ZJA6MQxmWpC0o2C5fnrNvCpaHKKXFI5NUq011njZf4wEmBsfk4
         wvNGhQBK99rJk4bHiTEg1JMi5LtL4uezbk6TxeblQNC/Krd8QAJcS6ng9G4pZstic15P
         aJV+4ue+UIBRWDeANBjlg9Rvhm2uf27FOtceSsnaX6Jg9ZtIJzQLramHr/CZnm9tEK1R
         7IQEngP3W4nS5qHak/jkCUtngicHdNiYtUm/FEGkFI2os1AXptzzjGsqvVe7al+1l0eI
         uqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756085665; x=1756690465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ruxANvCNocw1N+b5yop4AxWitum7HXSiuMUa0R3Qfc=;
        b=IvaHAwVBOfGCmS0F9bMXIYqKHBaH8dz9YlJXJmXm9gcKhp10Mq79A2WTWD8nk1kgHU
         VTBmMRh5JsweKlDwjGJuHGWzscNGvNA7/10VpEhoSXpqRn0f32w8/J+lI5frPbr+MZvW
         foFKJnD2g81r5QrlgH5/XauSSwbYQ2rsnAZjX7I/s0zJ+cuvYBy16I5zuq0srxNVus+F
         TbHzdcWs/YhLzrRbeMjmZxMt7W3pmGMgx4N6UGl2nMbdFhHU/5fGBKNMvFPhmLmj+BAA
         m5jywooDm7wRZhLGCRVkHq3mClPrMUCw74cpFp2eIuPZlxT13ZO4GlQEBRtgTMuO0Xzp
         ZDUg==
X-Forwarded-Encrypted: i=1; AJvYcCXJhXgVXtvw/O5smXMvYkTC9JCa4CnaBx93anzx5JBnioI58RSEN/Z6/OdR6nuwT1zyCol0E8qx5w==@kvack.org
X-Gm-Message-State: AOJu0Yzz55BvUJCabaR3sf1ukVePyAYnQ5jdSHHbytYA+y+HCC2E8p0V
	s2clTwlFbPVZ85INZZwHCZyrNvg73KXa/zIsL1turBPocPtHmJRB7Nfg
X-Gm-Gg: ASbGnctsRkr8R3W2bvaeW1Zik7O+fu1fxMz5wxRWGVNo1JRvsGtqEM78Obar9qsgOiK
	uQDHZoItFC5iEwObRW0+BmIbRsfRfqgkuSJ/eZ92x9LmdxtdlCAQCkhPxBI/2PV6ive8JETSPfI
	/bm8tWImYygtaIS3f6n8tOmPqYcYcyDbnxznS8VdvZc0CtdzAsEIYkJgo+Y09vrzNx4Xb/ri+ub
	8LEGSAn6h2BouaUgDLLvJDY2a4sL19s6RQNs4efIMCJCY8LPWOcSYwPqpUbb5eY8KF136AClcx9
	BxXDXGBCvMTQpLhLVJbNmHdRQGad2xuA0pC+8b8xQ4u5HJ2l6G76xVo/IuL/bdrVjMB2QHR6CJ3
	QJYbCMcg+XsJKOT9Jsbz9pAfbjVs6KqHHemv91+xcUAxoGLEZnDcRHokXglaJSl8=
X-Google-Smtp-Source: AGHT+IGKOMZYl0RBxqjG9OkcEUaYyVXjoKwhdUdnGkOmzEDzDDuznhxZ65Ay5hqrJSncjK/q9K8gyA==
X-Received: by 2002:a17:902:ce01:b0:245:f2c2:650b with SMTP id d9443c01a7336-2462ef1d1bamr131430785ad.30.1756085665123;
        Sun, 24 Aug 2025 18:34:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668880a99sm52425995ad.121.2025.08.24.18.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 18:34:24 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 0/2] mm/slub: Fix debugfs stack trace sorting and simplify sort call
Date: Mon, 25 Aug 2025 09:34:17 +0800
Message-Id: <20250825013419.240278-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E49840008
X-Stat-Signature: juntc7dzdo3ksbi78np6eoh4a9hesufw
X-Rspam-User: 
X-HE-Tag: 1756085666-374675
X-HE-Meta: U2FsdGVkX18ucoHCirioX+FJtSele2a2x3zcvqmrqxWUfi3+LtBkaNM6cK3f9QIdHZVQiq8UF99XCIjvQFCP/EhJaJwhFWrvTpupcA9NxzOS3vB7arIoD8AIATfDuYz7QAaXciye3+QGYyBjwv7FZjJRprXWB5qhFlhHa8Z3HtTJIZGyfgmANGIGiOfL2hLVBPpDTltl/bjPHUMb7vqZQCzO99Atcnp87dgi2xypOWbcuxyDnMq4iHtLdJTKXR4vM4MS6z790m6b6p4q3k06+3kLa7cU0/86xDHTMqoCde07rrZiFj7coMjSdwMyeJIh2NfqlP2jcjRkFTQjWrVRYqZOd5+JIojoynAA9udAeWrp7/zMhJnb2FyY8eQHxxUF+0QQMkZNCtX/wG/ZSn34qo+IUNkVMWALqo6aGgSofTkKrPCWiZJpGgYmTMPWwJpI7L0846DrKcK6bXYPvXcNClV8P3f1qo5NtMZoYP2kTzDQN7D4IM1r/RdvpjDDZI0ARvY1OakLx0WEqLlrH0ow7LpvIjlNDWXk9qyl8yt3gVBLfi6p0ACzvAqwdoq8WaWma/25dxztMuFf/jqT5Tf1QNHGR36jcr4RirNJqfBx982OgblG+kOQ7PW7yOmv/S+hyvlQnIUcr3RnOvTlL5M/0cMJT5CpQHPRnHRhEWLXo2VHpiRbF7IJ0hVxxLDnS9f/nDZSH8TBFqKUcE6aWZJg2k0S6cIRDzkgjdJfnYCJGNrWLJOEIYiFcTAvAW81HwDS1gJOs0ovS3H6n99xi/UialbCchCgXmBff2HLFAx5OAezGxQ+2hjIr+jkMf2SXr3fhnjemExbdVNstLWc7s6GGrdXGmKWSDw2Tmos37zkveV9grek0llitn0n4QjV1DgoZ6xZroMeEdO0k6c4cGCz4Z024NqZNhII4wGi+cohr8B/3mpUHC5yfBfKEaizW9Eo8U6MhKomikecZE7YiCm
 QPr6Esen
 AU2cQeZWjDhtge6IUUTMfGx3VF6ci+pkNX+CfDRovVnvCvt4hw5qmvgX/3BxK0GhHEJ0s5Wa7+93xiaBr0QYeaX/K/1X25eS68gVstNpQg7AzBs36F2HYb4ci3jhAn/Az1OwQaGpp/TYWog8XdDhl18a8HJDMdRdvBCJbR08Nc3PBUmazuTxPENyMLPVyhoIPXEgpLRC/Ds8c1UpLAT6nrGTIb1d07CO0d27hBTSVTWJ5u12UWzsVcJsh+eHVGFqD0iBHPABn2IelwO0QhKgu+dILIFm6R5c00W1ADichJ3JLRiMMe277J4dB0pYKgmKdsGOcIJxScpoIBNkYEp5zXKViupfms+h9bNU7t62gEFXCMHGzOuSVrkt0qknwIbNd3N5b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the comparison function used for sorting stack trace locations in
the slub debugfs interface. The original implementation violated the
antisymmetry property required by sort(), which could lead to
unreliable ordering of the output. The patches correct the comparison
function to return 0 when counts are equal and replace the unnecessary
use of sort_r() with the simpler sort().

Kuan-Wei Chiu (2):
  mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
  mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting

 mm/slub.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.34.1


