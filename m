Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C10CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79BF8E002C; Mon, 17 Nov 2025 12:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51588E0002; Mon, 17 Nov 2025 12:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D670C8E002C; Mon, 17 Nov 2025 12:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C35548E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:37:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 796FF1A013E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:29 +0000 (UTC)
X-FDA: 84120805818.28.2455389
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id AADC31C0014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V2umBShg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401047; a=rsa-sha256;
	cv=none;
	b=xXktAh6y24u7IaHVUc1YHDyc1kDA5MfvXJ/+XPlqXGcN5R8LRLgfxfoANu3mJd5tN96D0q
	a0470havl98q/IoGlP8ux59eXvVhKHvObutonYlQLw4/C3iV34xzz8CgbvHws3tb8q/SKA
	G93BwxLIjB8QJ5s23gux2jPcUR2Il/I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V2umBShg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NyEbzk8z7xPPT1DseOSZ+zp56B2pNRV2BlLEcd5Pr+c=;
	b=aMjDoHLwj6CYxrx4a87xKd9O0irqBWpGUd75o7q17bxYKtNuG7baCjDyprCj07WJwf3Teb
	jTSCrE5wI7wBUl4KRDfkN9ItadAJ+doERKSwM4uQd7Qr/RqFst1NekXEJU46fplUGFO4Fz
	4c96n+fE2exGWImGHoGhPsVAGBgyYEA=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso2353485b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401046; x=1764005846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NyEbzk8z7xPPT1DseOSZ+zp56B2pNRV2BlLEcd5Pr+c=;
        b=V2umBShg3l5S30oA0AFjsANeGw5F8W3rKHD0PXK+BtkkIssoy7CpvRhFkCdEFuhRR6
         JRgm8YaYE0dUEe6a22yckt0M+WEEMYVfrj62Mu/RFlGbm+m4L9b3hEN9XtALPMEhAfrn
         Cf0PsHClKoGERbq8q8B1mcPb7fO7Oeaaha/61KNJjFUqTqcTXfYpiQoRs7rtuL/RwGWz
         GmvRUsAyk3GpGv4EjSh0mqt3pQA86p1XgA7k/FPZqZOF+VhhifpkIaruuIgFDMpxcXt9
         JCTJCQpGxfMmTZLl73/8Ixf7IAPrV57vw9LO9w2gQQoIlwNnJl5AXdm97i/pvb6iEObH
         YK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401046; x=1764005846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyEbzk8z7xPPT1DseOSZ+zp56B2pNRV2BlLEcd5Pr+c=;
        b=tXJdfrD5BNYhFZDkZDnNK+4lx2asE90dC1XQ5VBDcjEATM9UBJts5iws2Scd4qpdZE
         /2n0ZiOzrCiUgKkVJTY5FAYxSfTib6ILKQCYKDWXrk4IxVN7MK5mlnRUYaISHv4PDf+x
         xXR5TMpH5uNyc8/1sQHgyppd4amrXJ9GLhREHK1EXbFMQR5ZpqJRVAEDE6gKP57bvHDW
         uJjcP3NpNOwX8vR22oAUd9TCMYnyFrKNLuNTjXJel5KfqccVVVxr0J5D+S+fSCsTBiDD
         vFGpkXBomEwthrj6vyha3GKL2pR4+AaGdoSQZyhWmuF5zl0LtznrJWyPxElf3V1Q8mMr
         635w==
X-Forwarded-Encrypted: i=1; AJvYcCULvEYm2pkQZZ3mVug+6+1oH57guXA9f4hHxoIGBtk0kWkaxmtKbGDLgn0mU/AZCAxgTz0oRWNFnw==@kvack.org
X-Gm-Message-State: AOJu0Yx1hw2Uw/r3w85gl6aB2LCbkM9f7oxwVHUi4jBFVIrZBybbG5Wq
	+Eu8vqMyp71SyKiZKoONA+EHMmR0MGjJ16FgHgODMrMDRKswRTXjXf9O
X-Gm-Gg: ASbGncsQxYWzV3luxUFSYXcZAkukqb6rnxuSQiw6jkwEQJ4cNBIuhYjhJNTnrKh/7AO
	USp2gG++zVhR0gPrjHhiQFfMCPX2OhrabgdgpvdyQkx/Vu9m+S9lU0BO5lBTcYTMz+HcuhkDjGx
	S/4wxBndw8hJ5qoAW0MHNxKBZLYkaCOfS8kPNiPh3TTstOVOFdBCmhUde6z60Tx2b+GtynVeycv
	eq8AP/L/w6jou88mF+evdP2QJOwmuQMOqliMAfN0xcHZ8B33H4bEzsSUGH43xwMX21aei/GuDcW
	vX61XgEBJa4oQ2xraL/G/g/LWu9iK46avarOTetW4Ns1I6DW9SYXGL4DBA2uc6GzwFx35pCWtgX
	wKKmjaCsHZjpJLkXfMLyHPelRumSED56oHTSCEn/qIloljOpV2cLcYt69cuavMY50ug/2+SVAXL
	r/f4UBBIJzU/lnxirMrNIDgEEdvtbcn15eNaQf0tW6N54OQecoehRN+w==
X-Google-Smtp-Source: AGHT+IEK7YB6b5g9vRjs3QtpYVtsaA3O545xEkLIAQdMhsZCYtHsCYLz+LjhYU2gXqOD/FI0rh8ZgQ==
X-Received: by 2002:a05:7022:689e:b0:119:e56b:98be with SMTP id a92af1059eb24-11b41505914mr5960143c88.37.1763401046212;
        Mon, 17 Nov 2025 09:37:26 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11bf23d6967sm17190077c88.3.2025.11.17.09.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:37:24 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Date: Mon, 17 Nov 2025 09:35:26 -0800
Message-ID: <20251117173530.43293-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AADC31C0014
X-Stat-Signature: ssjsxgtzxxcnidn3xgyouuhf5h5grz4k
X-Rspam-User: 
X-HE-Tag: 1763401047-420406
X-HE-Meta: U2FsdGVkX18YaqO4PZqImXw9mYKxBxB5lNyb4tiJK969luQUgxEyUnMX5rIrWdOa/3s5PNQ7lh7W3DSm/m4HEHGoQydFUcyiKFzOTOL23yITD0SHc6U99GzH/fdzQgxaPzs7RptXwuTN/q+4frzYLDzxxFB3OLXcgUvqWqNhKynL3j1ulgLSKrrU0P0rzRnu4/DbD8gsENm8twL1HNyQdbMbEGX/l1+JZsja0ZLiYilyM/Bpis0J6bFLiRM99+r9uqJCRoXz7fcn3eaTKUGlGLZ5GkuGWP3PGLkAmvagF4Bp9TWJSyvxeKkyljz0Xb/2Vv7AOLoavoKFo7RBgKN5TMg1y9n6e3nJ+/K7K4N+YkOzMcaXPAEbIwPjb+oYFucrQsnxFDVIhCE9CFvH7skpfg6pVX65Iz1spKTnX7L/5GEbmNfSZEq2vljmvpfhTJhLTqnIhpjjxSpTU0PIwD1qsGtew5IGS/FtDTkKHEW40tD8aHMJM44mKNfsD6RSEKuq/KzFyYZQzI3IsNZvQg9VZgh9N7Uc210qSCfCWhJHaZJ73q3ihQtvir14mPmSqIUv1xWTScGpJRNrR5/q7Nm3Nt4bSWKamknk5TYuVsRx3iRL07oOk/oaKKCnML8+Wt4y1JEdwRye+2xNAYZnkeMEAYCd6r2T+/IR7u/7ErfixsQIlXWlNqADOVd1tmMuKCdnxYZ39oVov/vdroYjDTSxP2IoXeNdIVI+Kq2xs5Ry640ub0dbiakTTO58gWpk1MHbQZBvGGjLGWod8EQZ56rOtGDU4RbA7qDxP3vWlKi+qqwcBRkWKwnsx2/AGyGxRSBMQ2udekY84EgPclS0hAldgNxC/xzhUtWe7K55hsR2iGRApQi2Pijq+QOx0ScoLPe7k4pJaftdtIkV4Em5ljychB5g7t479rpP21oYdcTx5g2/JwQ7oAPH+8Ut7vuyACTVmt18EX9Rjz+I/S4CV3G
 3BtMdOGV
 +K2EKTAPahUbgAZNVVayXzmA9xu9QMQtBDvcKDtJO24HmJTHAUeCwHdTlUeFuDyTzZ7JS89fSHmOjVWcznnH60Ys9mhFU7PqiAuxTF82HTqdfgcifv+lY+joOqy8KlJ8kZQJx2Dt9vVxj2uFzk+cHXZsbxCnEfoIuCGJR1PlMqwkJeLcMeyjKE0jwsrVRhunTUHtKphKRt20ydb/DFNV98axjYm68S2vFTMHbLct0ARpUpbvJujQ9x6oKfuNaF37gEW9scgdEY7tfhjQ1fY4ArCoxfgSzNgKaemV/i3z4sX1atL/YtvaEYJnRctXWxtipKomjtVmG61C6U4CNFsGXEnVGWHoU24G38H6du+/6xMfizBs08/TmH5HAbOUJ71SKpKU0XA3ZhZL4di9N/Hb9SAhVeoEk/pvHGzY3snRr8puP7xfAa/mlKmQJLO472lo6BMkMHKC6B/OboYU2NEtLJO6TtIgPrFV6rauVOsm3s+WJlHQ3kvOfYIYbhS9Aae/M4Iy1/CyfXXLEEwQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.

---
Linked rfc [1] and rfc v2[2] for convenience.

Patch v2 -> v3:
  Only changes the whitelist mask and comment in patch 1:
  - Replace __GFP_HARDWALL with GFP_USER
  - Add GFP_KERNEL_ACCOUNT[4]
  - Add GFP_NOFS and GFP_NOIO just so all supported flags are explicitly
    listed in the mask.

v2:
  - Add __GFP_HARDWALL[3] for bpf and drm users.
  - cc BPF mailing list

RFC -> PATCH:
  - Collected review tags (Patches 1 & 4)
  - Add unlikely keyword to help the compiler
  - Replace pr_warn() with WARN(1)

RFC v2:
  - Whitelist supported gfp flags instead of blacklisting the unsupported
  - Move the flags check up to the only exported functions that accept
    flags:
	__vmalloc_noprof() and vmalloc_huge_node_prof()

[1] https://lore.kernel.org/linux-mm/20251030164330.44995-1-vishal.moola@gmail.com/
[2] https://lore.kernel.org/linux-mm/20251103190429.104747-1-vishal.moola@gmail.com/
[3] https://lore.kernel.org/linux-mm/20251110160457.61791-1-vishal.moola@gmail.com/T/#me8b548520ce9c81a5099c00abe53dd248c16eae7
[4] https://lore.kernel.org/linux-mm/69158bb1.a70a0220.3124cb.001e.GAE@google.com/

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

-- 
2.51.1


