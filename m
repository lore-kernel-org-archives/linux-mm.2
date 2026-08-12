Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B039FC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA056B00FD; Wed, 12 Aug 2026 06:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1B56B00FE; Wed, 12 Aug 2026 06:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1106B00FF; Wed, 12 Aug 2026 06:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 475306B00FD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:04:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6FCBC016B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:50 +0000 (UTC)
X-FDA: 85092183540.18.289D227
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3C06160004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UZECJJCs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlE/rwBm4Ajsne+/ftC1sXbsOIllDwyjWRq3dt4Owgg=;
	b=SQbbnK24r4HKyYIlPfLLAFn/pwrG7ahSiK5//csv3IqiZLRy+5tmoWvPPpsy32+zG6MMQ6
	45yQ2meNbYwEHa3OPS6S5yfGBjJmOQosAW/ZZuJAl7HPLpUy5hRMlE0WViBDXzBLAhlC8z
	VNNZISoXkHHpbe0Ttjy59duQlJlq+b4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UZECJJCs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529089;
	b=Cc8OEmYAtHKn4Asd+HW9HovXIyy9TekUAQhNVlHVLACtU/6ZtNIceJqSF8+NHRS/AbybSR
	AG5A5WXI22fUTG1A4RoguJQG/fk7A4XhcDJ4IHDL1JnZT6B+SqEL+vTwmDmisvNwXId/Y4
	JbQeYqVDJUdsf+UUN+tTpQLgdF8soK4=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso820120a91.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786529088; x=1787133888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlE/rwBm4Ajsne+/ftC1sXbsOIllDwyjWRq3dt4Owgg=;
        b=UZECJJCsCV1YjSke/f8y06zT0hUmsA+nDr2YvtBNLcN1P805nwKNKPotMhE559nuxl
         Q/z4F1q0nDF4F117VXUS6aia6JvVXoKCrQ8Ytfld52ut2V+92nAue9DOx30U2K/vdAHy
         Furi1Ef+QiRa2RJkGqJWAiElqhVz+AETvZ9DR2UGMVjWusWAp2UaabwgiTLa/+eMIOMO
         K884klyiviQYPiuPMCd60wnQ8izVJ8FhwdgPoAvZuDaARbNcCkDsg2nIH7U1M9Za5v46
         BTfFZcRQE6bKUPvYXJDTXjpVlsqpZsi+R7N7pM/qfKkX3fgJF2S7fs9R8mMU7YdSWvwa
         rCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786529088; x=1787133888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IlE/rwBm4Ajsne+/ftC1sXbsOIllDwyjWRq3dt4Owgg=;
        b=eYcXV4rY87wa6cM6q8hY2FkkBsx8UairSv8mwrgcrpb9VPv0H1XyuPGdqR0IgcKMtK
         1DpZhTdN9BGp1c1JPXwFJsM9LBBVnQOdh3M9ZdUwQ5BN601V43MX4qaiXaYrEMJQ+Om5
         AlsMKfdeRfsrN/ZYU/6buqEeYe+3ywgSTJex59Y9DScdt+SWd3UFGPP/rQz7BWx39ERo
         HM77Pwdn/Us5bJNlp2PQUe3yjtOuw3TxsO/Onp3IYkF9H2WH33TnShhhkRVIY3vJAjim
         u76pNH3BZfu+BmABJSpECZGfTi1Z4NqcBTvEDxfrQK2Q9246U0+CkgJwLQqxd9BxzzuU
         XNmQ==
X-Forwarded-Encrypted: i=1; AHgh+RpqWOCRjaT8jFDtLZrXv9M9BLAaqdMQJ9db5D3Z0JjsbsDOU3lKAMFPA92JibdF/EU4jMdWi+7Vdw==@kvack.org
X-Gm-Message-State: AOJu0YxEAT97dRY/a5FP/DrhmbQLqpqsZJUs2p2Ce9H7HmEsie1/qDrf
	FaLHeIVUnGF2suLenrK3O2odFDPnK+NPDtg0Uv8au8RedBf9DSHCFf2G
X-Gm-Gg: AR+sD10fW13hOzjEFu0Z6QZ65EqiyOcpJmU+clANW+YtTOYfTh0/wMxN6e3Kf6ogWUV
	NQsz04NV+XMrkvS65kmvUYkFmPyrDYUXoE33KRlp6eiJ6EPdZdqaFhrBMCI3zA8I5wGzmmsOQyz
	OPQC/LjfbE/nkupv2O7HptljOftGvKtnXZ2ecgCecmIwsTzITqtkewTwvEX38r3pryrDOZa9cJ1
	vXJ1lE+Wn4k1jca+3odbYDdjpQEusmiKHKp71hwpc3HbBRDTbDH+gxVUYqQv0kJTqZQMSUii3DS
	XPDOPrptw9emIX5xM5arg8DBKWeDd4cLLPv55OM/uIccFxYvdH1ATcRgLdDaSQoWWaueyqLyESf
	FPbgpNMS/lBpo8ZeGKX2tJP2qSo49E6XrSohZQ4mpp8KAOiBFDlmCRFfgJryOfi6fQUMd9e0bKR
	njOa6TDhy0qF7YL1FxRbfy2P79yiR6g+FDLjolCQG/e5letseugluRYCWtHKZrXpfIavES7A0HK
	y/y6ZZQHpYWTcVsWp7ZqkjZKg==
X-Received: by 2002:a17:90b:5443:b0:37f:f4ae:5f25 with SMTP id 98e67ed59e1d1-393014b4064mr4301528a91.20.1786529087671;
        Wed, 12 Aug 2026 03:04:47 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14124454d3csm8821247c88.2.2026.08.12.03.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:04:46 -0700 (PDT)
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
Subject: [PATCH 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Wed, 12 Aug 2026 18:04:31 +0800
Message-ID: <20260812100433.6288-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812100433.6288-1-aethernet65535@gmail.com>
References: <20260812100433.6288-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3C06160004
X-Stat-Signature: ixrsd6ms56wj76ddrmrbbkm1wd1numcq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786529088-630013
X-HE-Meta: U2FsdGVkX18J+ihFRhnILZYe58MCfyO0NEpafGojIFbhCLQNH14dO4WnY+qFzRhaNbfcIC59KozTMOCBcFPI9i9E6a5oMuSliNNqKh3VFpLE1piSicsDWCYJBhTOZtoFxx9YX+q067Xw4GV6srllq+K4gOzy/Wt6eNmFhm4MpBkkA0Iwf5E6jxFGlpIevKrZXb4nU6q9C5wd8J2UoWKhr0WUBljw+8pnIRlhoLWitMLObNBAiT927HLkUYq5Y9vg8/fsEL02kk5QWyl0GErbs4kh+bIY9kl8urQYY0HVtjnOi2wcF/cAR4vZjgwPjjbEKU0gEUuH3lyp7d85Ks7Nh69qMk58/6IdtKYjLEoFnHxyqm36oCnWAH1s4fmkRyKKDY0Mok90dfpmXyLyFC1+M8tT3I0hc0Ah12wGNhA3fP3G7566r8/UObUqnBg7hQjRIKPaZvVLZCY4ceXMPi6EjMzyqFGvTmuyTSTFmS9vik8m2ErCmH8oAAL/byh0Ogtk4FDE5QlrXaioOMv9HX6Zmj9V9jvrlexiUBaZZ5y1wwxJk5Hc/w2kJapOqZa/pVSwFzs6AIyRGiiE3TmxHWR54juripvD4a8Mgoehx4hGUFLTNx3u7upM3eQqfeBsgIJTK+Y86yNIkIp5DQCNylSVc0CacxCBOqqsXalGsgnVK2b/mFIYM5UF6CZxc5IJpr8xPFMyb1A+BpGAw3U0XTBc6QamtPockF/h858ikKZahKRBrOq2Y6DYIafvWmy1URMjPzQiNUMYhif8CZ+uZeoxK7X37Y/LSl2nbWnv0T6FswsBbpgL3KXoo+UQ2/mZWRwWhZEdOCpxvnaYSOYEFb8XZPlUtVdB5OSad8v8CxFuoP9S55AyDVVbHIqkx+ootJSSj8AiTLCbxauW4Bi6/4K7ENCM/bFFRWCFB2yxwWvQV/k5476B//ZzKFzpWADIBaHVVUw7CbD8YQ9hvrp/3hy
 zgHx6fp7
 Ipa2bGoxgmhbC3RgYjLxIqi2WatHbm6chce53xvczddksZLOzNdffPeZeVg3iENXsij20fOjA4D3LYPNkGq4IZWgGrPUYVOMgQs7XKvjoo8e00vnomQML560PxVZUfgndviowBvCLwq28hHALKGYPJgfK5qV0FdyojmJ3Z0wfmaZU+F8Jx+xUKVn6yOhNKJ/ICK58DRn/Egyns4UeKqLX8HaKoB/EIYao4gPytMjTA/w/gDj18RpgCfjqDCr3wO49iCgpvu57PjSt90EeqYZc0jPYk6KAFSe2qzgIFN0nDTq2h43+2Fz5CkFJZQBbmcR++aFTAs20c3fBsbMXmw6ewG7e7ME42gC1dD5qgIuF45zWSZCz7MPBZ8PNPkoK+KZw7C09vEgDnGbHfmRk+FarIpkr7KAmhRge1J+e5Oouk+CePsK4/OT1X5UgFDsz5ck/x8NpspWach6w5yYlATFPgRPmzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change "tried to be applied" -> "tried to be completely applied" to
maintain consistency between the documentation and the code.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..1739aeec6eb9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -846,8 +846,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is
+  completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..33914594fb48 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -357,7 +357,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is completely
+ *		tried to be completely applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
-- 
2.55.0


