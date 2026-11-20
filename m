Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A17606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ksLK+jnY
Received: by kanga.kvack.org (Postfix)
	id 523656B071A; Fri, 20 Nov 2026 00:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD026B075E; Fri, 20 Nov 2026 00:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9E76B0768; Fri, 20 Nov 2026 00:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDE16B071A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:14:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 942DC120D22
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:14:24 +0000 (UTC)
X-FDA: 85454331648.17.2353B42
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id B91BA1C0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:14:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ksLK+jnY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of dingf3ng@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795151662;
	b=unAD5kUOhWfxJ55bA9sF5VBNMNflp7AGBiDKHRTX0KA0KcH52YOjoR8VQZy9oPEMukWghi
	TI1c2yekLNNhHIkfJRmxXa6vfw56WNRBxA61gTtbISW2Lh0hBOD42W7JsIyyA+r4JNoxOV
	VYhC9A4fc3UvlpOZXGN5y9nTpoO9//U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795151662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nt5EZs18M4zZiQfV3aUfiyS5m61HCPh6kyVQE3PZq3g=;
	b=0pPL7HyTqmiO6Bidh69cMJ3MAntUmtOsEbIU8AcghihivxVOGk1Us1GBb0Jh59bNKUzXFe
	0SHzi90X4WzbkKMDHfsO8X3XmytELvY898y9p3GRwPTqUDXbiML/d3oJECFwv19CzY0IxK
	N8039P0mJS1XdU1Xybh0X6vLxtangJU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ksLK+jnY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of dingf3ng@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f037bc348dso4183715ad.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795151661; x=1795756461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nt5EZs18M4zZiQfV3aUfiyS5m61HCPh6kyVQE3PZq3g=;
        b=ksLK+jnYATVCo9Bgu0CC4zboEun/gPWEebhyYdCuwm/L1ul9q3psgZ54y43y+L2khZ
         qhp6GT873PNqIv4F3bIj8KVi3EXT7/t33dXgzyq9M1/0jPcbQ1ALTNPd7EIN+20s/xsF
         bLZc2buVrBx6DpfqnCKZy6rzLqIxqFdGLcAbr2zHN1Uqk16DQwv+bO5CJEeKj0LJSyo4
         NGQOdSvMm4FrvSHvuDCOFa1gGAXdtZE0fotAJPRXN3gmXo4IaQhmvzG/TFb9l9nWS9P8
         l5E7j7VYCVywBDRMH1FNVOns2tqCTFTJbp8RyJaBQk7L5gYjzCCE6nLfItZ/K8Rg6sH4
         LQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795151661; x=1795756461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nt5EZs18M4zZiQfV3aUfiyS5m61HCPh6kyVQE3PZq3g=;
        b=Xk/fJFahqF+TBAaIH8uKRAZuUsQoYHBAToJ7Vminar3F8Am7TgrGoyeuIRD7rNeSBa
         i4owxwN8YicmPKciUn7bdPzoMmh4gPFw/bIVv67sODhsfYqpWpO9QU5a19CjcjFo3Itz
         NtLDzhZh8pGbdUbj2Hdas5dAuaUb3hEYmqixv8IlMvOkb1gPnGdu5k5K2FFvy3a86HUH
         7g+9iCwXomalwAFXe/pRw5UDPMSCz08z0cPBZuAwBrv+RB/Ijxgqk+mKIYGiBY3e/m+t
         CrcITuZlM/HMAep5/kksU4oGwQ66YsQxfcdu/7FNB6HJpGkhD4Mi0ONHQ69UY6fYVnZO
         OmSA==
X-Forwarded-Encrypted: i=1; AL+hErHl9E6MwO/h9OpIJEEG4VBcVT3QmgDcA8NO6IOscd5nHqcc5m8yHNbOTvnsBmw11GqFYIJFl7ca+Q==@kvack.org
X-Gm-Message-State: APuU4Z9U+sFU5SWQ3CgkdWuxw81wuRmHTPqrsMFdyT/B3ZqdGsOeqORH
	Cxs/WtiOrl8/6SmpwgWO455tNyxUXsNMjbZwufvj3eVakZ1KECqFmNMM
X-Gm-Gg: AZFdTZfYINqpy8RALF7tnQLvoB87+SWyAie2cBmoa3Oa+KRxIsajK8IzZf+NtxeRSlc
	KW57x9oAfmHaTIX69gDZZ9glk4mvRC2V7LaiQcCtpxYB7H653QO2PLGDD7hLNW65Lt1IZKKaM0R
	cAJsYrSNqmZgjA6VVDIddd5lCBsHk2j1uYld4+9m1bBDARDlbiNJoR81O6yDFui+YdgtXPmIB0F
	hu9UV0HLA8P1dGH7XGUiq4o+Dv5xUN2Sh/gcCTRvH1Pwmj+PuChG5yLI9N5LHrd4KaqG63rArqc
	WQ273bS1ps7GvX7UYn76gP4v6l72NoO3W7NrRtmJhps7L8O5QpDIzHUkOlKoEt8Gq11VjtcsvnV
	lGrXeuxq4w7I8SwZCKk6QBvK29FVWEYgEOWDSFWhEKFSO3qW08GZSXXrb23Oha6/ZwpE7yFSBvd
	dFrCxr4i2AahFpoe+MPytVMxzcuKd+adfupJRQnFk0Sa+dxeaIxjgEZHe/eCn1XLLqoIKtDJMXS
	y9KrdtGXkUUta4MHJWsOkq+hgj7paxTpS2jBhUZjZqrrQHsftDPG4zNbNALemL15btfeAXiUaD7
	7PpeI6iXSS2kIU6CCzrAKClWlRUXhD7N7onQHjz5Il91N8N2oI6Hn95CdjbdElcbaTc/XBM=
X-Received: by 2002:a17:902:e802:b0:2e9:a16b:c251 with SMTP id d9443c01a7336-2f03efb1099mr22074575ad.3.1795151661365;
        Thu, 19 Nov 2026 21:14:21 -0800 (PST)
Received: from MacBook-Pro-8.lan ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120016sm8432675ad.58.2026.11.19.21.14.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 21:14:20 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: Ma Wupeng <mawupeng1@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ding Feng <dingf3ng@gmail.com>
Subject: Re: [PATCH v5 4/4] mm/msync: return ENOMEM if len overflows for msync
Date: Fri, 20 Nov 2026 13:14:13 +0800
Message-ID: <20261120051413.46167-1-dingf3ng@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20230321074035.1526157-5-mawupeng1@huawei.com>
References: <20230321074035.1526157-5-mawupeng1@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B91BA1C0009
X-Stat-Signature: qj8ey61caz7ebhgwd5k7iyb161m4taah
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795151662-411924
X-HE-Meta: U2FsdGVkX19ossDix6MkJp/UMdEXmcYhykgQZqSSc9ryrKXvkgaaKDDAWLDbBsprWJKGYTgrDD+lxsIkiWHY1RHwsniOBYoI35ruyvDFTrLqLSP2e6HwpqbvRvNiQAkpRY0Sw9ppR3jheXVCAkTiuCqCzD6YDzQPXkJQmb4N4PQp5aAM9Rg9C6Sf8/jEbJ2D3Cvy8gy+PEakRT0l0H+Jgpb24uZdXEd2TrsQwnJd/qxdSaonLdFyStZExSeAI3eDaW5K1tScSPG0aL9HpSaLBVmTR+dCkYJ66kpUGlahsVOxQ6trHiQdq9pXSCx9H5Wk6AG6jdsB0fOVVLIY2UELMidG7BNQZ/npvorQUo42iBu4aSPhrnVC2v2ydASyXGO598r8VcbYhr601hhhCPs7RhDPd00Kk8P4TpQBaTi+bbUKYInRzEXMMnjRcV/DpAkHHCpllM8kHDq6OgASCNzbqRjKdTpcTQptGzn+22lJGVOm9zJuIFg6IWWg4W2X9c47l9z0UmzXH8T5qXQk9KOtg+IzT6h5ZYTeR4/e6488fNgUgOUXFoGldnHswHv990IT3zecGnbsiqur3Yu5GzbM2UP1GiSfWYImLdf4vQ0qb3qoOHlSi3tjBf7x8p0a0wB87jo8gtYGP0MN3GZKWkT+p+z8SA+vQkwa8OqJxIIZyEQscOnDSuhJ8qj6tZP5pr3hFiBXUgQ1+NN8lqXn94QdmCxMFKAyuNWJO395D13M6Sn+vA2yATCh4rNq+vVq1IV+XbSTfMYrMjB6GBPWidIPrQghQKgq8xORV+C5/KTth14ZpctVdOtpDZyUV867a/9MIbJZh7HjPSc92x9UiNHpoK8zfFfOPLaQOo877ZzcxNWV7EhkJePUwCZAqFkWgbcIsdueE8R1OBEv+hneuo9hZnLpherI2NSWLw47PINreM8h9HuV/SpD4QKnftil8JRWY6hnUXOHAKRPhesVWeL
 qFG1CpVL
 k44rkz/y6ut0zP9nJHmmD5G9V7rxVTxta4MN20hsTx2cjzJzIuk+G6dUWiz06b6eRLhGFMJofW+AWH8rx7H8WjyL5hudpQdD9vIbb7Yh6QSpnO1TqQDmci78pIn8nuO3QO8n+7gTHZl+5S5koqgQjPZRqxWbxUbdbLFd+qyXgNRZBWdJPL3p2Ce9mdVH3pEgeEDrFuFvObwnNLoRZkQKW5VbGZJU5LCGnnlrk979Yc8eYw2fd93dYGHWiCJ39ygs+7AQjEQpp5/ONSeLjMUsWyCGY73fdj3DVnkSCiU23YoD4o3h8flsAJ/wRZNcFYJCY/DOCzYXKvt5Sw6qJEpRtTJ5rCi5gNo8tVXRDIoq8H/HLHWjT98AsHfRW1CtSeJSzxnn0+8SATHhbtzSUQJiwgGfYNZCw/d2atnTZIi8VUyPoCt65uxX7cqPD0+J+ejvcNLUx0stFjM+i9zowm5JEY5opxIcY6jW2TgYrGJzN0ag+pKrVoJPi4RoH8PjkMniewWk3Ei4WCobjj5lTWdkiheIPgkxj5SioVMetrTLDTRwhL0xYKCVD4PCYqnHPg/z8TmpNfMKRGHZtELUIwQG//ac94u0Fau4zkQu+NojDt4AV6DI6o8UioBg3xGPHJzpeJag4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This patch seems to have stalled with the mlock discussion on v4, but
the msync part does not depend on it: a range whose page-aligned length
wraps to 0 always covers unmapped addresses, so msync(2)'s "ENOMEM The
indicated memory (or part of it) was not mapped" applies.

It is still reproducible on v7.4-rc3 (65e4fd942), and the patch applies
cleanly there. On a one-page anonymous mapping p (arm64, QEMU):

  call                              unpatched   patched
  msync(p, SIZE_MAX - 4094, MS_SYNC)   0           ENOMEM
  msync(p, 1UL << 40, MS_SYNC)         ENOMEM      ENOMEM
  msync(p, 4096, MS_SYNC)              0           0
  msync(p, 0, MS_SYNC)                 0           0

Tested-by: Ding Feng <dingf3ng@gmail.com>

Andrew, could this one go in on its own?

Thanks,
Ding Feng

