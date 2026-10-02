Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F054CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2404E6B0088; Fri,  2 Oct 2026 12:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0FF6B008A; Fri,  2 Oct 2026 12:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107D16B008C; Fri,  2 Oct 2026 12:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6FF66B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:05:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 755C1C07E4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:54 +0000 (UTC)
X-FDA: 85278162228.13.F3D54B5
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8D26C0014
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U6ZpAReI;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dYBcniAkRiKcrPB14o92qA/kWKzbO5nnV3tEc+XkJmc=;
	b=3f3kIHlBtt0H2NU+T+40RdrdpANhcESf715dbLmiPURb5rQkTwZtvGKyGvtda3i4+q3ch8
	EHI5tFK3Wz+AHgfvrM7xtxu+BO4hKqufDeTNdG6Qk0GxPwoMwfXFe2uf1oQMAGQn3/bVAI
	M92zDvwswubgCVjO9NVrf/6hffjf6Ew=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U6ZpAReI;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957152;
	b=zyBpspUxXS4nxORMhK1Nrz08fj6NzESyKCIt8cvRU6DwoxCejuhJq5cHklSKuXhc2t5rMO
	Dw1wwpmFIChmvwrPNdQsaDjb0Z+nRVy0CluTGT6qG5N5ZHARV0FghkI0zPEqqpQFtOyeDB
	qlYR9ufB+KtVv64clY96p9zuBeTtjNU=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a494638445so87618a91.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957152; x=1791561952; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dYBcniAkRiKcrPB14o92qA/kWKzbO5nnV3tEc+XkJmc=;
        b=U6ZpAReIoiBlN1xg64pDgDeHGVa6LWaNiBqYy7ckH2lHbR/8RVRHWnKWGmvkmU9qSn
         0wW0hfISlbK1PM5TXNMztyz9qbtkb1qC9e8gmb68YSlDG/x7zrUawrQUKFLwq8G+yNk2
         ekiX5fLSbZ1e7DNzkUYLtVTp57PvGbNY2ew8hf62SJROZSGSRljJkCC1EO/QkjkYEJgq
         OCtJBBepPHV5Tf+9tu/eVbLGnSEJz68kY67yhpDeKmhIVRswQtQOPJtAvSpxwFgtuaSv
         UUpYneXoY0H1d3SJ7+dUoHmulAjOT2GvYgfcQ2ppvwds4y0RGlEz6IQgEx3Y9PgM4x5m
         shLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957152; x=1791561952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dYBcniAkRiKcrPB14o92qA/kWKzbO5nnV3tEc+XkJmc=;
        b=Z3zpw0CyMsBThCVWEoe8olje1Ja35gbdObh3f8Sl8CexxmZinFh18I6kpIxj9IXsDW
         ECVVQAc+Mygs7JNCxjzFo2+YOX5LzBUZaxepK+4uIOwIvipyailtDeWMGYKTtBdPHRki
         UZHFcZZlDbdWkfmMhJglha9ifz7TEMpIRlR271CUAQxKiImGF31EJ9Uy0vzGpo37RloD
         L02FT/tQbUY+BuD0y90P6O5BbfEXTnp3QKjaEsGVLfc2jhnby+gTcWMr0UvmtI2N8qWu
         C0hPB4GjWWPuJcjV2gHIy6TJMN8t0RE68vr5z5jgATxc/WmnG8o4zrUYTslQbOmGg5TC
         iISA==
X-Forwarded-Encrypted: i=1; AKwUvBwunjNIofO1G0PV9yFWC72q2A2Hh8/4DyfUObHjr4IsPARBfBvUe0PuhT7uEotCMeS16yHU7WBZxA==@kvack.org
X-Gm-Message-State: AFq9FYL5gZ45x0Mpxu8+W2DAoDp6TM2AVVOCNLDjZWPjHYBegM1Xq2Au
	xHEzjYswroMPbIDvVtjjZxI8y36NwcpEMmugjb0O2X3cJXDy7Ixll0qe
X-Gm-Gg: AYBFou0uP2AvnpyUAGHu7QpecJnlVOTvuSQ8dBsbzsLYz1HlZ0koDekVNQ7sZt4pRDU
	PpIA7u8TKvkZcr1u/9VlydN0rkVADFmF5Unz0QNdbTC5vropaJ7mgs4hFBSOAbALg9mUvTdQhGD
	sTEkcFcyqTAWraoqzepgcO1n+Ro1NPAD8F0fFMmP5f29+wfSX8fO73xdEhVPrSDwFdx5VBrkQYD
	hvTuG0RJT3u5EbKJHGpFOHlwsFXPnRQ3gMy+FGCIzTbwnIi+LTV98+is58BB6YXcKtldH+Ea1BU
	ejDhBVXz14yrx88F53Qv5SaSDENau9UYGSoVTdcVJcvB0D2nu0nIY1d5IkWfi4PSFxy6z8IEVKc
	xDXyLHsi8XJSyK7HsdIxZ375NEj7OCqXU4GMpyuxFIw/sOqU7nLPl5O69QEaUE8AdawBh+mEwx2
	MXeOzxP+q/MNTuYEwsfgHkPoiB0JMwZ37h6fQ7T4o3EnM9XNEl88zDW7McPlTdmL67MsmnY7V7R
	KQBTO6mgarKkDbQp+S3knQM
X-Received: by 2002:a17:90b:4b0d:b0:3a2:b0a1:456b with SMTP id 98e67ed59e1d1-3a6cecb1b3bmr1893453a91.47.1790957151371;
        Fri, 02 Oct 2026 09:05:51 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f47cb357sm9375672a91.17.2026.10.02.09.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:05:50 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH v2 0/3] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Sat,  3 Oct 2026 01:05:31 +0900
Message-ID: <20261002160535.661399-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8D26C0014
X-Stat-Signature: 8ot8m9e94jodmtcw19c7o8wjgdejqb7e
X-HE-Tag: 1790957152-463408
X-HE-Meta: U2FsdGVkX18d5JpIqM27A3jnAzuEB8hRcTjVX7DgdQp9BbwbXcpMSC4ppBZ3HL8BhbNSPs625A2PkduRSwIwciYDXdOt9Ux2sHwbmKrFHKZhFfy6goqij+gqN2zT5dN7dPmdn5yA9h3CfzLNksT3EDNub8LTM0Na6WQQmBu17wdJaH7wa5f0fOzFotT0aUrmouVoNKYc/r4p8mw6L8rBXeIA+pV8LIUo+e7aON8KWMdTbFz8HJ2L7EYUrZuTU0Cs9Fte9CzmgZ/pBc85D8lMI+OhtHHBL8zZnJ4hTz0hnjgkXmSHc4ieZ0KidsqrlJpurGcT/lbSLyyekUjlj88d6+DR9YfpMuIBjnaPMtOIUGGjFyZN10wl0UCjCdQ/bJ77S9sCLoDmrgUYvqv2GvgWaz6KJwG9sCrNt4HyaYYZBfIWleEq0XZt+gZtoyAa4RddYGt6/E0LIIZSMqRW/wQ3Hwh6dQE6HNjv31AZMU1lGYfzeRFZPRSmtkVBEpYqgfqIhIh1M60lCW3B02zSptlva2DtL8LrwoDaUM67W0gfddvTJLznrO+3vNWn61b1OnHVOgF4Qa1jjAcTUB3qyNdkyamwZK/EFvtkEE7oLhHKprUYaAm7dV4Bcq2No5jZlfl+3osN9M5NAP1xPAFuQ14S8LNj1IXfjWdZq/t1taSkfTSPdT0U66sR8kRNBt/CoZXfJXFblHnLykmcIxpqzPjEp6oTa/r4XoRHVCFKbk7F5IokmWXF6ACYlNlfsu0rN5boSb7WGwzLuIU5Y2oFdCDfSOxXfwH8Dn75cjGGRlkwgfE/lS/o9cz2kMojNQgLBIUrU2wRPWvkJgNIkpv6tsy2yRR3wlmnVfMPdztUbN44tOby7veCVTjbVcnwXFDXc0UfHiVB55cx1+A9OaDkK9U1RAb9tDPl/haJcvlrCvmk51UyBJUnrS4WfA3RnuCd9oPT0CUU6npdaHUrJBR4aqf
 Jx1FjiFb
 i1jtbsvmUmNKYktH21c4srKyrGYKLzZVU9p2m/l1+X8k9xPMP+5vKABOIrtFsLVo8baDo3zlhGcnqUbf4u3Wy/ipCKnz8cb5aYJmIDo3BYAgQV/iQTWIwiAErfEk7/WcdTj1kilgCS3I7KKYgoLl9WHVIX2dl4MhHQ0aY0IyzcaqjPTukncpDlaponLBEysakNqT4cARus8bSEWClGuGIEMoTsBPenTTjXuSVYBedSkzGu+FsXUsRNjG+ziI3nxR61l7V0L3mN296hV2gdfM5A5OjJdX52cvaURab+LmBsel8okAjhowiRKXa/fhbe05ehlHhH6oTl/fe+ooDTDfWyZnXZk9nMHbaOVPUUeK0+l6pG/O5j8LBT+yekckm7VMtq5AEH6X/ptA4ymOMS3bPOBXUHWvAxGpvqljW+ukhJ5I2EzOY906h6ApRNPBjuRMqVN8VMCe/z7eHJqVo7Sj8zjzSnd+IakUjwhu+4UnlSzCMFCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers. This series removes it and
the mkwrite handling that only it used.

Patch 1 removes the function.

Patch 2 removes the mkwrite argument, which is then always false. It
also removes the unreachable code in insert_pfn().

Patch 3 merges __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

---
Changes from v1 [1]
- Split into three patches for easier review
- Move the comment about -EBUSY handling above the check in
  __vm_insert_mixed()

[1] https://lore.kernel.org/all/20260929143707.450805-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (3):
  mm/memory: remove unused vmf_insert_mixed_mkwrite()
  mm/memory: remove the mkwrite argument from __vm_insert_mixed()
  mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()

 include/linux/mm.h |  2 --
 mm/memory.c        | 81 ++++++++++++++--------------------------------
 2 files changed, 24 insertions(+), 59 deletions(-)


base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
-- 
2.43.0


