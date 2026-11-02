Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEDF606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uyENRyRq
Received: by kanga.kvack.org (Postfix)
	id 7449D6B05B6; Mon,  2 Nov 2026 05:41:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C986B05BA; Mon,  2 Nov 2026 05:41:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6320F6B05BC; Mon,  2 Nov 2026 05:41:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEF76B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:41:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA981A0C4B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:09 +0000 (UTC)
X-FDA: 85389836658.04.1A4D95D
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 232F01C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uyENRyRq;
	spf=pass (imf20.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793616068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cBjUGHG8kbdoyzZbGr/iLJi2HGc+aHIvJeTBRuTSpM8=;
	b=WvRS3auFja0cLK3YzOcBvvXo43CxRJF0gTKuOEYMR+h0xN7t8TjMI6YDi+XikBZnrhudbn
	Yxa+cMRlG3Ujkj+hvAMuYIZ0inoJgtIiyxzo9A7JLJAHXXFOa6EKZ6dfQYHN2XqQopxBgL
	fe5PcpBvJvQA2pKafgt4CRtKI6JXpfU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uyENRyRq;
	spf=pass (imf20.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793616068;
	b=WQ8xPCFkZpPPdtL4FpAjdnwSbaIyz4sNaKuc1577u4RunJU6K+YU3qYPqvHSEVuuMH6p49
	uEHlab5pp2O8/nfEZHE0JT55qtaHquZb4GLnhGYPqPIkgSLLOA4KLzO4Zrl1X9oMvvfPot
	Hz3lCtmvm1eC3zYPxPjTn+odhTju730=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso17039565ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 02:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793616067; x=1794220867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cBjUGHG8kbdoyzZbGr/iLJi2HGc+aHIvJeTBRuTSpM8=;
        b=uyENRyRq6UhnC4xpYkC95x+AQU9ZI1fhrfkU+DSx62nE986cT3gIM2hX++jp2PV84M
         nhnLE3phZg4yrOPGKpv90x4TX+sCO5BloVXwWd32gpU3YeDn6E0bzBx17RZUhEZCqKjN
         AfiSsfrOvpksoE6neZawP9hLK5pIsz3CW5YrSuEaDSA7Uu3S/Gj/NrCqJ7FQOp32iYOC
         1R5MuMspIXkzebUqx5OyPtUW2XkNn0ABTJkhCUJ2wO6Sys2rvk5y/HQU8AF8ymmmCQqy
         OXgpT7QiSlSdsIk9i4yIQBLl3SPrSrXsnpIY7AC3qKj5XIBtsCy+UxO0CLA9D0TBJ/yb
         F0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616067; x=1794220867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cBjUGHG8kbdoyzZbGr/iLJi2HGc+aHIvJeTBRuTSpM8=;
        b=2uOyFKRU0/HMvE4ZLUMzd9sPSQj+PyzT3Er7UeruReYEBqQiadmaTAIArgXDPcg/bv
         +RjOEzB5ftLLO0Ml7/2GVDbSOix5GcPo1jKPLAdyY0JQ31uLjVzl4pOBWgEz2mH4GorK
         OH/E8Gvhh288witXPnNnlDjji0aMsFHj5djVJP78b1kneznYtWGVz+nIeyW0e7GN2OGP
         dQ5TnxpKOdBrA1D4Qx93qN3Dhn7U7kvM4TYkByGkSn1/5iBoPjRZztKYY/ao9h8IQ2n5
         v/c5rVF1nOXodDL2NVp10Ink1hR6EpB0p9noToQna+abGXAHsISDnBcjm2VYSkm4SnGc
         AQCw==
X-Forwarded-Encrypted: i=1; AKwUvByJR5MpoVnN5lcnQ2ZFSg6nLGm+Aoui7ZotW2IuzcxEb2GKeafy5v0O3EteWnVy9nsCh9AxQ2BJ5w==@kvack.org
X-Gm-Message-State: APuU4Z8mSsLrVI6FgEvcBwEh6/1stya2OZkf1kzjU9V3heuc5IcotmIF
	+OD8k6YR3lu2lpYCUhxxlWWdJZry3RZj6Tj3pl4Ey75NnIIOpdE2O0OL
X-Gm-Gg: AYBFou3oGTLg5Kaf+X6a/LVdZCCHES+jPPFlj+kadMaUMAu3wyZGVt6KaBHqIVqCDBO
	re20augzzlYrhjqMctIhn55pOx7oqr08RzY7RXGasiXwjIJPZTGf4VvWKpc3bYqWVc4COKC28ox
	oRT7QlQ1EYKsGWxzrQ7/U2SHfMEikN8G8YoMw3ssZM/FbWWnhIPj/wWBmCt1lr44mbz5xe7aax1
	P2zHF4VrLx4mnHEWNKYx3YQWO8sdtzaZkm3Xw3jLhA1wlgvFSnZNAywknO+mHT9a3iKOMtC6BVE
	9lIzV7fO41cYBmB7+Zc8ey2iEf+3Gxn/8hCjfLgLeWxvANKxnL6HiBrL+VuF5INsJAvozTEl/T0
	U/2Xun5WerkJFJIzXJ+fqPqvYZIQUGipzhEIVTOEwxDm2PHOs2cEaLtRVleuB5LjBJOW2vlYawJ
	PSCNF1uwqO8sh2cg2Lmd6MZ3won4dtbe74ws3QhJD7YDS+VELTdKLZfjsN3+qeHU/l+m28m74UL
	itW4j3zPjXvgdb96tD+47qza9djgLmN8SuSbEMevayz+i86IgPZ3hGXpatv0CuAtI2l+gdB7uOd
	8caw5o5irjANVhj0KN5f6FfFg0vG5v+7DzR09JxoEPJWqnc6msthzA8WSWRYOvO4mNgY2kUdkw=
	=
X-Received: by 2002:a17:902:f607:b0:2e9:4b32:fc66 with SMTP id d9443c01a7336-2eb3649be71mr94161175ad.10.1793616066876;
        Mon, 02 Nov 2026 02:41:06 -0800 (PST)
Received: from umang-Inspiron-3501 ([2401:4900:1f3a:7c59:eeec:de7d:b077:9b9f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3925ff38sm25195465ad.36.2026.11.02.02.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:41:06 -0800 (PST)
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Umang Pokhriyal <umangpokhriyall@gmail.com>
Subject: [PATCH 0/2] userfaultfd: validate the whole range before changing write protection
Date: Mon,  2 Nov 2026 16:06:19 +0530
Message-ID: <20261102103621.156928-1-umangpokhriyall@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 232F01C0004
X-Stat-Signature: qcenywcz8rpopimi7p5tt1ke5usn7sc5
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793616067-599059
X-HE-Meta: U2FsdGVkX1/55U//i6UAMRn2T7SfvL3tKmNiV5lBQWbKBrhHB6W4sVmh+WdRCZSeDin9iY7OymqCI3d4ODYk3oYUYnhvTNBvynwFwY+Lg2lYYcAthliUsRFkSeK5mtfBJVfArNOgb3lKkkSWHR2LuqkbzCzyzklS50lBBnGcZeLx6K7O7pAQoGN8JewNZmGk4+kbGIP6ha3tLu7j7jYyd60Fhg3cVt5/wyOI1FNRR12yfiVXk09orqH1QDzBrcgiCJWzx8IweMhiJhPhChmFUrUfaiZFDUYB6hoiNniDeHzPXjUNZh89y5xH2ybTIkz/v1cbVu9PJvz5ejVoNR3FAk/E31ai4JxvanbSyEOJvKR4lE+fLGq2iDhhKU8S0bHJfZ98MAs0IeIYn6AMlxiO/0MvLXY0gkFBwPpUf9mXaVRVwl7q4GxBes2UFFmt1MGg6vFvWaLkA/2r7jTZ6q4G83goVxGmNFyiTtOSiDotTL8gYjPZzVw3rJaLTTdrgjEsHf45TajMm8z5l8mntvep2aaYxDf3FF8/KcYzYyxDyUeaG7vRwaXF577OvZnJPv4bz5SLf0zePHO95OOJFKpPVxNFZxws31ukesD3l9H4m3OjzYpZGr7mvUC0IQS1XV9KzhDFTdkqcLzQc1dC6Bqib6WBTr24LR5TtNGst+Zs3Q7SHSWYBBuSskRaaS9yUokYjMTRGC6d3UXWDrLGxwdV4wPWzntTEj2xuZ3nmtkzMOvARM8zwkz7ykDt0jJdlIfimYD6hY11lTspyMInEXFJge0VHaZ0wXuwKrj1OEKY3esc3jNcWg2O/fsP5SGGALAPbWnimPNAc4UH34amZt//b4T6X6Fj8joOslRHcvrQHqWNi8HDotRO3otQKCyJXdjuHrJG1hC6W6MovVVtE9sNvIa4ycKqpMOP1GHVqQtioeP8br+jReO15muUnK+UZGHq5WMp4DaQJ+vPRPmqUVZ
 QYzYXgt2
 ohy9g/SwS1tgmYsNxozbu6YR0xjJNs5MVY3g6a47qu0mBvyAJYN65LvqYUUOpAwcW6nAxOUXOsfyywaR1kPLgP0RdAw1UYU5M06RkMCU93Kktp3ZqIy2inLbY5x7JWGEYU2IQwhEsYU0Faymu8XdQbozjEqgyxsZHlCu81fHrD3DhaYYXP4Ou6b21zWifDpizwSLnIoGf+kqNKuM2QJapSLru2voEuX6ba0zB7XLUWp3q3cVaP9tpOGjR0pMm/dxS1FwCz5YI67gvMWoykUBTi6n09v8wJIPPxsgI3ZEk1ZmM49ipTd/RPkRGXBmIgj1PHyJrmvaLbo6hadmNOwYDEVUox3HerNCt+W8lGuJ3HJZyY9XZKLA1sdk9+3Dt+zZQ+i/yaPQiofz7DvdORB3rSSu+9FeF5Ct/sYnSqNgEpQzpHGL+y65h4+W3hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A UFFDIO_WRITEPROTECT range that spans an unregistered VMA fails, but
the VMAs before it are already (un)protected, and on unprotect no waiter
is woken.  Patch 1 validates the whole range first, as
mrwprotect_range() does; it is open-coded rather than shared with it so
that it applies to stable kernels without RWP.  Patch 2 adds a uffd
selftest.

The problem was found while reviewing the userfaultfd range ioctls with
an LLM, which also helped write the patches.  Tested on mm-new in a VM:
the new selftest and a standalone reproducer (both directions, and a
misaligned hugetlb range) fail without patch 1 and pass with it, and the
rest of uffd-unit-tests gives the same results with and without it.

Umang Pokhriyal (2):
  userfaultfd: validate the whole range before changing write protection
  selftests/mm: test a uffd write-protect range with an unregistered
    page

 mm/userfaultfd.c                             | 20 +++++--
 tools/testing/selftests/mm/uffd-unit-tests.c | 56 ++++++++++++++++++++
 2 files changed, 71 insertions(+), 5 deletions(-)


base-commit: d42dfde37af766d1c272467352c0a56d3169ee58
-- 
2.53.0


