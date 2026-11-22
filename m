Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5C4606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TlB4NSKa
Received: by kanga.kvack.org (Postfix)
	id D97686B00EF; Sat, 21 Nov 2026 19:09:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47B96B05B0; Sat, 21 Nov 2026 19:09:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36966B05B1; Sat, 21 Nov 2026 19:09:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1E9C6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:09:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FF7DC0635
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:04 +0000 (UTC)
X-FDA: 85460819808.19.D79143C
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3697180002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TlB4NSKa;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306143;
	b=CgY3Ri+BWCRrEQjoFMoXISqWsbMpKqyKejQ/UAi+CKNI9Rk1JCbQRpbRhHhGA6CNDzuWEb
	AqAzvExnzhliEt2kEdDMMROcswYH+gfuS2wlH5pkgCCklpGQMS2VE2XmxgceDOyeY3fMIP
	BkkVs/6AQI79iEZVrRsY7wr861kGHIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cTiziDbYvBIexr1IGsni9s57LM2lqOe23xZ+5bZWnE8=;
	b=jj+Lkm5Pv/wa+k2M4uDFOzuHzrmAkjfJDtFLeBSfEMMC6SOKGF88cUHBxhEd8MLuR4WFUr
	cy2yC+2seHPzZXincRlFLgWQlxzKw/H30EPskmcYCQSCEJO0xgFTmoCLKPxmf0NX66V8Ty
	C3kTwj6bHY8w0HtL7oexb3bDxRegdeQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TlB4NSKa;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2f048bc09d7so49815ad.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795306141; x=1795910941; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cTiziDbYvBIexr1IGsni9s57LM2lqOe23xZ+5bZWnE8=;
        b=TlB4NSKa5pNP0UR50e+D05gqXyhYRAWmbQKCltRjPzug0ZI1qL3zk9h7LIGLBRXQGw
         q6Fg++8VhQesQf/fipgaI6gzSByF/F5rfgLUQJN6GrvgFmUXpuigf8amu5RbHz6ld2f4
         qxYoBDVHmCe/xv8qlDhwHSiqCEh1JW6tzku6nF85c9QHsEgyH2DfxZG8750y7FuCEZqs
         Dl7wsxmRt5ZBqRPdeAPhce7tFaBOYbZZafrBYkD2u5RJuPEOFcKy32XNWH7EDP+LQ3NY
         dRPvoMFV/+3kv+f3U3DHvloEKpEIuRoWiLGg3+dtS1AbQVUgLdalLhm0page/LWFoPy2
         xncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306141; x=1795910941;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cTiziDbYvBIexr1IGsni9s57LM2lqOe23xZ+5bZWnE8=;
        b=V1dOBoDkBNN00Z+8Egn/xD6h4qQGaqV9Obx4Uf0/frC6x7wRuNyOvaOcYMnWjjkdbI
         TiadGq8PzkRI7Ezocg4N+5MK8U4jA+rQRKrMB0czhFQX0NRRJf0Va2uvjcQWFRQ8lK33
         hyNL3jNE8HIi79p3DnZBXTJ/vIWVNMDmKuNfohgGeGoEWUBd4UkgXOjuNsg6Cqrr8Z9b
         RV/GubAEDgU5kx6t4+nP+e4E6vVITESXTrr/Xk4ISagiYeAq3i67YjnX5w5a7Fphm3AZ
         +SfyNCJdrGxljCkF21ChfeR1YKTBypvYfyPmXiTb+E50qaXW87TakqLwB9pv3PhFoyHj
         RsEQ==
X-Forwarded-Encrypted: i=1; AL+hErF8GoxpyiRNBhNOmFQKaSv5wIggCRsw7z6WPkT3K7loFSXgP7P5jSkAwNTV+TuOW3rvrUVZdIFbww==@kvack.org
X-Gm-Message-State: APuU4Z9mJ2mih2NQzB4Qqk+1NQIZv79cEwLIwou54s+LjKolyu4eggAr
	BFMbcRP3o8D1Wif/4tU3sPt/sZXIL8oPDyU6i2nIH3LGdTCBE1uxTTJ9PgwKFQ9m6A==
X-Gm-Gg: AZFdTZcghBcwr4Pp5X2nqUdYkVUbyRZ/HZ/WD5DZ1nt4SUcv0oWeyJSWlq0FckWGtLx
	CVJ7QCsYvi5+QsU44DBAlw3ICB0Pvz17E/T5nQJAlSFb0aQa8vhh1Vhz9iFb5xvqTz+Dh9xjsHw
	PlM7muFkXvZABIEeG3pbLjTbkVlYmlVx3fxdUJrCCTvjBsFTonPcOn1DB6z3yeFxtJ+hyGJtSi7
	U9xIwMbrJ+EoMu1oC2R+dhvRWv5fdhKNTKssjHcm9FBykSiCs1viGvA2/DAX4e1s20w/wwHfWKX
	x4+DAi+ZJg989PgVit23F9GRgapTEymhb7CdPCLU44eloV4L5yopv/L0bFvJy7x1q8bUH2rO7K0
	Vxq3+1x1RaWYrMtXQU6QqQM5GWw4luH/SR6UpVdrd0dqEzVM+/u6lZNrVx3YVpgglVicH+rVO3E
	ZIdCmGuSIIXMF/MnzC3YLpoENT36RZvgHJ1oSFLx2Qme+J/qNgnEC9kLmwECwzQoK0tyl8tvIFD
	08xE7F1p8nDuuLvbkkNTtHkXbk/Wb1o5WIG5TBicpTfOJQATWHWN2vRuZRbLSWiS12IqqxqlWOi
	x61i0cHz8O7bsLAg6iD7j2zYok0xtbjJf1VWx56hTDcYzE1cvRlml1uRVnzseKmKNO3VCkDEKJO
	hZ2JkJiDQfUwzOyICvXPm9X9U/IFgHvRYAYc/q6l+d7wsOObMXRM4TiteNYpQMbYNQTKaTzRwFy
	8evJ4xcgljDuQjQi2YtVU60f+o3BcSmxRfQkUUFeUJ9r01
X-Received: by 2002:a17:903:2ac6:b0:2ea:1fa0:8068 with SMTP id d9443c01a7336-2f066708e45mr2976855ad.16.1795306140790;
        Sat, 21 Nov 2026 16:09:00 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:575c:af4:36d9:d404] ([2a00:79e0:2eb4:9:575c:af4:36d9:d404])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cff4c1asm2958778a12.15.2026.11.21.16.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:08:59 -0800 (PST)
Date: Sat, 21 Nov 2026 16:08:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
    Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: kunit: complete the 2009 mm test suite trifecta
Message-ID: <0cf294b9-0ce1-dc6f-7cac-b589c9060271@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User:
X-Rspamd-Queue-Id: D3697180002
X-Stat-Signature: x4kh76unjsq6a5aydbwubqzaqzqd1qwh
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795306142-295997
X-HE-Meta: U2FsdGVkX1/4+DqZ2WZVYbTQUYpxRp1tvRtzyX0RD3q2R40yDRv1STHWDM1K5AFpSyC3xWHh10u4e44hYn2GSHzp1kE0b08RlrirVP3gTO11n/XEPgyMI4iO1QTkP1oYYQ+d2xYE5iR6iDQurhNT2XOQJgfT3ro6mT4iLEpbuxygQVrZg8QwuJ1O/kX98R4kQlufGtYvJMdjsKZ5jmbbo96LnQfB+V0ICsG2+/7FPzySp/yWRgXjJ6KXVDziSBTF3ueJnI+76NSuLGCur/phiQJkpPDFZ1FhMjYw8SA8UrZtOC02tJhsdLmkPF+AZWHPMe4XUxEToq9CBZZYgWAgoCEi/q/hX7jJnQ+lv9WdLDflAIajALooNC3h64to1ygEnDLjRKTv/k/GQQv7m3Nz+FbTGgHyYt1SE1VjCrrn1hdUNTlAfj+wuDmGFmSUPhK3V01Eww4dC1Dt22asaQ4RBwGsqG8cpZn/Im6HM7n3Sgx8JtsSnN2F507zDI6F7k/6cKWILVo5uF0KeLjeqjtORDPLdBfsUP1RTd3YZkfBt5rvUkHuV58RGfSYFahehJIvc583bhhc6WG2fnae/R0cpwfFJmnDmY2J1FX5Iqng23vMrvZiybdrsEhyIcp9jVLCkKHFIkwvWq4nVEO9Mit+KqCfMMOEC8Eae7Rsoltsup/ZBlbjodxYn47nmdVZz9dxqeC/8kOSBz6A0OSOPjtAwc9zNlgOrQw4lioRJiLO8M5cBYYmTfak6kMZw7VzkOkoPmPMbOC7MvFcCKADYKlAvNvpl12/RmW+w2U44hqheb9L3o4XmYxXI21MTx/rtyDvfiupyGl/+zBIxzzzNDQ56FS0OlCSZesL0yp08hOb5tp7hh1QWOhZB8iDsD9wsZp3Md8TwD2/wpg5VpgtotyxMyfxMUv0s+beltwpp0wEH9m+Oy+kf8VJt8NV7Tm3UnmHtxVsSrr07Er4H0Mw1ih
 +5/OhRK7
 TYLD/ScSNFuTv5C2ZjDqFJ1SNgFD3dc00DyFsFN/D4oik7oIXtWWIfLtb4a8O7gmmif/6QDGBBtUcJPtFjEWkIA+xCDR1q+fAvVGa54wcMVhsg7L8z6SMKoAIfbIDoXS6vDItM4QJL0mBCzRqAJQ1ya9VkW2la7QgnCUhtZ62GnP7Rmhpn7zFbwRf6GdWawFJ5dL2GsIdTAsWouVs9a7RXi8/AKkYFNrCTgqy2lw8KtOyVufizxJfLu66XGcq+eByaEeiu4S03AtsGwG3UZE6Utxxn/vG6R9/oFeI/UBF3c/yy4pUXbMSncaBrBs4L+cxNw5kVVyG9PiIuLVcvKTupJPgpUOdAjKH9EUizbbEcPSfhVBijND6tm3SWHWRn3Mwko3To1H8Y1NbxRkZj/b30Sbn8fCz764/1OuDtHAoc1y589amTUBs+OJuzS+n54lv9JYcrcs2kFyZpX/VzAITv6w5iAGjZAXkHNsFwnYLeCcgQoqpZrv967FrJYOo6YvmgCecg2cylcc4hSlngUJ1z4shShO7Uy8EIcjIeKlDrJyP3p4Gu6W8XRzX29WfARnUeSyl/wSTb3yLZXApLPeqdDZQ4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Follow-up to "mm: vmstat_kunit: add synthetic benchmark for mm stats"
staged in mm-unstable.

These are two additional tests from 2009 that we've been carrying
internally since then.  They were converted to use KUnit just like the
vmstat variant.
---
 MAINTAINERS                 |    2 
 mm/Kconfig                  |   26 ++++++
 mm/Makefile                 |    2 
 mm/tests/page_alloc_kunit.c |  490 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/tests/slab_kunit.c       |  614 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1134 insertions(+)

