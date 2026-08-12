Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3CFC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911626B00FE; Wed, 12 Aug 2026 06:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1926B00FF; Wed, 12 Aug 2026 06:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0CF6B0100; Wed, 12 Aug 2026 06:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 550356B00FE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:04:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE35DA1653
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:55 +0000 (UTC)
X-FDA: 85092183750.25.8EA7258
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20EEA18000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gi+SrLoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
	b=NR38vTOyZxFtBiPZTH7hhVICCX/exeQZ0ioZpt8fNaqxLDsNntei05AfnoDjF3thRFhwUD
	MvaRqcPzb/JUY3kx5ukTIdDTI5+LVfzUen4xgT2wuNCOhy10paUdTnD0OksbsbeyuyB2c5
	ss3SlM3OopBz3EJpPUXwd3K9gddRYtg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gi+SrLoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529094;
	b=3vHDzalk5j9kcLTDjsOI/lW3tdrf9oYA3KVnrsHoJJlfDGLr4k7/qHmlFkC0k5aH+972GL
	wTC+HpUoS6kfhzOiqLTpux3pPG80BK8zZ2bOuS8sruw//M2/gFgkusB/6Ih5YNan0KbKKm
	3gbLRRLBe3sdn1ubSXDepIBSrzQ1QOI=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so751938b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786529093; x=1787133893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=gi+SrLoYWsBj33Nst/9YsN9p3KZ1oAMoOjRnC6P6zpq+iaQ2G+6/CQLBFfsT7h/Qgt
         mWC/Dep4kIcrgP2mqMdpkeuRhDk5O+MQ235+Hb+UXh9OhW8jdFIFyycSNNR8f/8AfXLC
         6pE7HWXztQxs63h1/Oo54DD+bP2hIv60nVv3P+voraVvnwvshbrAb/jMDL5T7keZPKdR
         XDAUme1TqQNzzwlgQvOoUHllOGlU6BF6fXaXajSQ42gNKFBDV2EXDNimNCTvUN7ixNbU
         66I8QJzzdc0kgA773JAfVfpiDREYNF8iQXftBAuArNMhscdeGUDaTeNJRsQwbh9x5Gz3
         0pyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786529093; x=1787133893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=H0x5AF8CkGVff2a9R9pVCi1Hw63YZNEOuEHRqx475EQgjU08bF93Sq15B7muiK+SBy
         8BNfG53SaZVllqWmTLzMAB6koGjw7kTKAo8sGd3Y0dbRE7DyECSwKqyn5zlqdCe08JEt
         w9Meyz2qGr8rsl2wqJ1Rh6wMicVZk2NdAh1BsAsCThx+XTsetiqvgQCNnnvsGOEtZ4sZ
         cEHFu5c32/uEKIURP7Y7rhVy7ZrBp/TsR/C2uoE0zi8EXZ8JYxA68ySp0UxFdG+JjXp0
         MKCksI/D9AdyGY664MB3DGkZ5KZ/WYU+3Fknj695XIIECitKuEtKPJvu8cd6wJ13ejxY
         mGMg==
X-Forwarded-Encrypted: i=1; AHgh+RqNH4Wey/E7JiPVOOugB2Eg0DH4nGSKGamJLj/j1tJTVYpkq80+IhQ+rHOrsY/T4r+ykVra3VkQTQ==@kvack.org
X-Gm-Message-State: AOJu0YwNlSGgAH+RHlFcSYimkeoA7IoX1DaPCBHj6QV2K5L6I3/Anta8
	pVU4iQKb0OmI3imTCfRNj86gx8H4awzNQ6ISxCODTKGIStgGrZUWEP/y
X-Gm-Gg: AR+sD10+GOKqj1JGfWduL3ieFARUSwAvoUydCcua5TFQpWvc6blanh+fDRKo08PnZE+
	vnmGZSzRSsjuxon7PZBs08s8oibPNaLhDJDw+OAWwHao3yhdlBplEiBGF1uNjUYEzfO9axStfb6
	4gRNhC4LecwgF+mmxDSQkDKGt2S9tjo0msY5RY4kpFlhfTUtYAJ3asX/k4vJNZ1hn9FYJX+F0Yg
	vqC9Zi6FIHngZXnS14baOymgp/EaNPDtQtI1zw/r6UmL5xVaaWKWzQpw59p0aJGP5KqZrSMzG3p
	46pWaTojPv4iwI+lYFDJ32cw1F+Ip68nHUjKu1O52aCDPBJXwSIOTFHdoKYiJvphM3PWU88fCqV
	w7GtDwf8VG3zHwCW5wokbiIrGxUn4Iaf6b7hx9WtuvPJtsIe5x7wsbYyF3we7jiNz1M8E8j59Ed
	UT29ZbgB37BmpGfpFwrv4otQzhNGCCNptr7ExjclR1UPHpFHvg++nv5m0vlB6aykPhwP+h3NZfA
	dmhG+ewCE6WC0Y=
X-Received: by 2002:a05:6a21:4d07:b0:3c3:a20f:f729 with SMTP id adf61e73a8af0-3cc3f51e8camr4663363637.7.1786529092842;
        Wed, 12 Aug 2026 03:04:52 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14124454d3csm8821247c88.2.2026.08.12.03.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:04:52 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 2/3] docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Wed, 12 Aug 2026 18:04:32 +0800
Message-ID: <20260812100433.6288-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812100433.6288-1-aethernet65535@gmail.com>
References: <20260812100433.6288-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qqkgzhauwy1fqo4jdno79dwpeq4xi63j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20EEA18000B
X-HE-Tag: 1786529093-166040
X-HE-Meta: U2FsdGVkX1/4/Xg5dxOkwacBS4tmVrc/d8qk3mRfzOGdZlKMGQ1+VaZ4QqbfZjY9J7RmBPV/wuVLpNewonvQAbxhHYjev1jXo7EwtSCcVhkSnXy/Anh8rth5WqDtJXJwvwEG72yg0X0rr7PnAjq1+r0awDPuwHbCWbNVdypra02dv9DwbYffsxRHUnpkW9JUubElxLylvLCVon9GgLpNUDlugZUMTC879GwXTUEKOwfrRz47wRlFWxok3MFosoWaPjVxOA7YQwexK49dlAHwozJdobbQC+hggB9vHFOyoEt8aAiwtrLoOXbl6rzBmSL+CqZt1Q9qq/BVRioL9HSvsdf7z/0kBbrHVRX1CVMO22fF0x4YZFs8+zaOS6JPFipW0Jgoxt7pk0y1ML4/FMGcNyzGNPiIZ+722HaX4EUZocSU0SjpM51nSQw1TD5IwXi4bQgesvdd1NVwcNOlj5lszQNuyLeyoUgZuMzdqRszHHpx4kdu/nRx7NyGtYQx7j8ufE8pvr21N9ogdAezXvep60nXL+h/gFXKTVVB4YYNxFcf3oswy9JXaRh4K2Pfm7cEzoB5sxtWRujkNXII2H1hzdPb7Un8gVW/E3WCBbI+s9klJ3nknhFgybLfpbxU144aU43//xpmBL8Bbc6CTuXbY+nAHu8ppNX6ZgIhCJE1DlylLCqoPRR6koQSB2KsNwEE5vPjsa2Q/sMZqrNcZv8x01NL6yLK1s0krqmoloct1OJn7DyU7b4Laegzu1ziAfN/cEhi5FidcMWDgcV/YXNL1564yEEtWC6c6wAAhU21Io9FAKrWGeE2ILI/ES8fPsORsE1Nd+S+0dKS6L+5YvoYIwaBcZWGV8tyUZQ7kLQRx3xviDUqKvYVkod2oTHCpgAh22I+yKrPVrnV+R8SziN+EIx4Om1gQ+dVwTJ0JlRGfDb9pvHIv81SjZ3JaeffoWwA8WuUw1WUw4JLZ84Kai8
 YHWc8HDg
 gATmwY92SpPhAgSCIe7BTAF+U9erB8jRqktkRUW14Iaop8bM81fejcl5U45kWWx5roIXVyVVvTuskSeD5YdEafRjMNvU3Uj0/DyiKDiiWnBicvSEMwAJhbdEZKbP8tOnNGqLQM2KodKji/5dWQuoI/tvQ3xmb41/+ARq9e7FhMIDq+Wl7s1Gv6+N+t8vyLjkLjQygT0edc59mF8Hcj3luiRQc9Ccnx7CoqHdRVfXmaA0MMpOA8Mz4DCPBsTmDi6xMj+8ZpquiNiAb6exVWgwu9lseWo4rGhA5nbBB1yknoNgu83eC9iRxhrf4FW2spa9NZsNGRy5Dw6rFSCFc2+NzDckoFkWHZeWPJYSBljQJxCl5IwfTbY/2wk5RyFUAx7PCm3wwqb8Fq0IMGX6C+UYMyPWXwwPBzjTT8xZP6L3xabchlrucSKCpflIqoKjut59Qu+QqY0sGqA/DyX7cC5dkC/cseg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 939298f2a9b9..1fcf0b8c044b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -872,7 +872,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
-- 
2.55.0


