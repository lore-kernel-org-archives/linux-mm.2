Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55D2CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24F18E0007; Thu, 25 Sep 2025 04:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC468E0001; Thu, 25 Sep 2025 04:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B395D8E0007; Thu, 25 Sep 2025 04:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A405D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:20:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 532731A0399
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:20:02 +0000 (UTC)
X-FDA: 83927074644.26.E76B453
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C085100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:19:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdiurNCX;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1t0bS/zAY9iopE80cgTjwXzkA8jYIY/Q7GpXwMjltYo=;
	b=55IEm/fgz8i9GT0ARtjEOS0knbOzZ0Cprcln/znvf1Q9bGbp2SJ1597Rz0tEOr+3ymsGTy
	EmI8H8ZrudTVcaUGxGMIe3n+KOmjeu4/nyJgR81koj4qR6PfZUUshj3en5+AwEtyk2aZFi
	1GQQ0PlytiZbt5gaa4Y2ulc581H616g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdiurNCX;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788400; a=rsa-sha256;
	cv=none;
	b=VQ0aQc+JyBbvHeDzFBA6LBq7NpGkCN0H8sh87hKnta+gmF/s2WP1xLSpTZZBczBrlZFNdr
	iLbkHFtNh9VF+aY7vtv1dihtxpwfLobOFlZX7uIZPFEFJ9W61IYMfXVmXBPaz+ZMuUz+LB
	mMPNsYQCukZc5/E6QnlJzpM2dY4oEKw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1t0bS/zAY9iopE80cgTjwXzkA8jYIY/Q7GpXwMjltYo=;
	b=QdiurNCXaYLrJPnmNfiSZTicERWWhKkPjQH1gYyP0s8Kt080gTBawPmwFwyiJVO161N1Vi
	8cPOygCZ4Hy3C9QW9i8s1kmRMGyqNxubpbaVdTl4C7Qf0O3046ZRlQjplVa+IQ5/qS01qX
	cKRJQvv/AspYrcc3BgdtCWq9ckIrrc0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-sLmW9wR5N6a09nCfuuiX2A-1; Thu, 25 Sep 2025 04:19:57 -0400
X-MC-Unique: sLmW9wR5N6a09nCfuuiX2A-1
X-Mimecast-MFC-AGG-ID: sLmW9wR5N6a09nCfuuiX2A_1758788396
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2b9b99f0so3745305e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788396; x=1759393196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1t0bS/zAY9iopE80cgTjwXzkA8jYIY/Q7GpXwMjltYo=;
        b=T9ODb2Mi71tsaCjSEaWtCT3s6Tv/65uIubvJc2+D8dBOiEXryzdxDpEzN3CecZeLeX
         bxxf2Op34Qiwov6Vpy2YHEnn2YI3HoA0u9fkQYqxZ7mIb5n8Ycc3ERc/tGLsCyaiASFZ
         niRMF5cPJRHiD2i7DYrOWHW+S195bFnHoi09mB50e6q5EeFnBNVBIHD3amvZrRz3LfM6
         dTOb0tEWxss8KuNkES8RKFXfHGh/2la8cgRq+FjFDT2xd+F+OmzEKo1hvCLqUWa3EjRz
         nX3iw0uLTaZj25671pN3gGCkswmnz0Kw6SFhk/dZcSPfP4gTXVmLFr21EiegnDxsnFda
         zpYQ==
X-Gm-Message-State: AOJu0Ywd7MRTHQGnpN+7wGdh+opaNnen5JmrKy2MFeDr112EAwJMjrj4
	0DBuQCvfJZDKctYe0Ql698o+CIFoOyn/OGOecpjuAaI/2VxyKhpFrb+wCiCkxP+Gxx/2lYTGvEX
	frDiwQmjHq7z0zrIbO8Yi1CNzBNV866EBO1irG40yWLJqJrJUnLHj
X-Gm-Gg: ASbGncvYDfKG+LJ40fyT/zN38nyOfkVyQZKjX9KK72mcTVSp16Y6pQBz474DVH25VUA
	kx2sii6/nwPxGLVn+OBDvkfgU3pABx0FLFFFxEhFd6vRPB4spZNrQv8OW2XSXYzk3A35tozsfQF
	3+ByFU3i3p/OP4HkQWbHwk93hCr0NzeNbiwEuiyTqT+0ASisOeith3dsYgSpMuW7kBNcPB//qiF
	oL6uWb7lWYaMmIH7DsZUwktkLxj2fwH9j4LJNjzZ2C4Cie3YMRo3kYPtsPQlef0fv0pCOvjkqgg
	vAaecR7+jxlVJ+nfNJ6K6dXwp5olKldoSgli0yVnz5uP85r9VzxHndV9r6stlESAFmtZgzQGCkF
	2fdm5x9Chm8wVX8QdEBpfugEGMw==
X-Received: by 2002:a05:600c:2d08:b0:46d:c045:d2bd with SMTP id 5b1f17b1804b1-46e33c3f06fmr11491945e9.8.1758788396217;
        Thu, 25 Sep 2025 01:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9p3zKaofr2Jjf8QTeBuQTz1glQCxqmdRM6Crbu83X0gj3w72xS1Iufz10mbgLqExIlQHWcA==
X-Received: by 2002:a05:600c:2d08:b0:46d:c045:d2bd with SMTP id 5b1f17b1804b1-46e33c3f06fmr11491685e9.8.1758788395797;
        Thu, 25 Sep 2025 01:19:55 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e33bf701dsm22324085e9.24.2025.09.25.01.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:19:55 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.6.y 0/2] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:19:51 +0200
Message-ID: <20250925081953.3752830-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025022401-batting-december-cf51@gregkh>
References: <2025022401-batting-december-cf51@gregkh>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rtBWt9uR8JTCN0OVS2NE3fQLgB6H6Egmv71KPgTCM50_1758788396
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C085100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jyfh96hu3mysid4m99nt8usmraoay6e7
X-HE-Tag: 1758788399-48420
X-HE-Meta: U2FsdGVkX1/qiSkDEMqpcrDWo+8qI/E6z/BoRYo26fNbs6YQfpOj+lp5sa4sjAm57pufufh07Pi3apRsBwbsa32r6QMbOXPpEJENedx1deIOaLSPrNxtAMdInm+m5BDU+CS/BBG/lNIQTlLgdNGC6e0Yj22rJ1ZXZAVhqXJaAkemr6oCC3NDJDb8nvJxU7j7Rc2TbeGN6yKP27g4yfpwqsPJEWG4KeqEWO23FuTRXNY1JxY0lCkEroYh/ty+O4colksSQITpGj1i4tLDfqCyF/1G9L16bhYsMYVJs+fo8I0MCRiFheQZWQEpMyUsyWwD/PjnJqhrSx/BJxOm4KHyKT6gQOlhc2jAV76KF5h7UXL3AHXV79qT+oh+XgKMNH3Ylhi9sRdD4ev02Mf9rzbwEUUcVGJAy9qa0fbLJL4EzozhVbB8zuFERAY5gA/tkQ7xTyF5mRt7IqTyByJjpwa/bmDorNH/QW2TA7iaKxWiAb1CMYHaZnlQeIZbphAG84/3NNvhBYV4cL6n3fhw9WheDbEj9jKw+udysKU1e/hWoQ0t+fl3EeoErdAAtZvUV4a6CMpNvhh9LhzyeBDl+PDpw3SYvacK54KjDb4KZTDqNstSWlG6OTT+yvK7H17vu46WoR3L8B0RvbqIuXjgH/hCtR7J0F/1OFMv8RPDEcr+8dlS0K5Omhpm5HgN+Xd+LvPgt4VXTFEz9xNBAD149lBIaXVY7HU7e0rZxvrJbR+dJ1YggXKwbHaMuV9bZqENrIiAZNozz6+fPb7+GXWgLdVtv7jojWdFDfvQ2vnFceOf+wjligs7JoVKO1k5piEvaxhWR3Yvjjtl7n3N2smgORcr0cnEC2vEyyjF0NWYStU/y3QE6nKq855sUH9P3xFY//Z5Mv8u9Si5n9N1vBnyPW6ajlpdxjdwpG/YGJUB2iIOk9zUw5a8qNN2CsgOxRAIUQIuzvIji0VWsJa/gTWtI/F
 bxJv3Opm
 B3rWUh8edZtkJ9+Wug5VR2PxdkzP+HFIQtwx0w2Q/xY0l3o1L+nR7ZwbpNTTwJKxFe9O+A/dj8yae5Smq0uMrO6ydrYm8S/X3p2Np6ABBX7bPsza+oFvq/iYaTaIHP5xKX5Il6aEu141cmCjzMf0XllpHV0O+4kfiPN5qWKcuI6lQsQbv8nZ+64ADWPe8vnBfNJVl+FaLf5B958t4vW0zIrevLn9hm/VjhKIukkGHKlqtEuXnojdsJn4+UGaPjoBPwW0BywQhWQNHbdrN9gFIosnDuph4ah5weIRtV/l9bDbtzmUxBz3dGkoz8LuDEd/yx978a5eTEv/41rtY38al2Nq3yzWL5j/dQyy5G+8GkycCvRbAtuWb+Sgek7S59YYZiYFHZFuCW/jFtnbl5zPIijy9/MtbxI/CjsJ/VbMl9YQKseSYJMX7wRaO2fYqVe1+zmQdYIHAkE+Jt8DBYRhFfsopv3Qm4S+MskCVwQYiGqQbNehxNazhRwbG3j+gsU7ZcFhNhjU95Bso7lsKrlR1xiNDMEriJmgeS3w/8CTI1rlyvOKHbh8kvPRo/lDGW1JKbyfaN7jp4Q12jgWlL/copWFjQV4/bGFmunVlcCzua8U6VNjo/apccZCNNaDgYY8YlVzwVynfMvSkEPQgZhAmpiWLMfLPv0phThbzqHcnCBu0ZYNVj4QqkczMs5zEumoA7AzBWOaO9R/va5Jl72MgjSCJDSF6kfJDZagYyUtB/zlUbNNILIpD6Xn1gfXfvJkYsHO3dMfdt1EEwHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just got reminded that I never did these backports.

Patch #1 is a clean cherry pick to make the fix in patch #2 easier to
backport. One minor context conflict.

David Hildenbrand (1):
  mm/migrate_device: don't add folio to be freed to LRU in
    migrate_device_finalize()

Kefeng Wang (1):
  mm: migrate_device: use more folio in migrate_device_finalize()

 mm/migrate_device.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)


base-commit: af1544b5d072514b219695b0a9fba0b1e0d5e289
-- 
2.51.0


