Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178E5E7C6FB
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 08:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD53C6B0005; Sun,  1 Feb 2026 03:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58476B0089; Sun,  1 Feb 2026 03:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B394A6B008A; Sun,  1 Feb 2026 03:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1FFD6B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 03:07:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDBD5C2DA2
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:07:18 +0000 (UTC)
X-FDA: 84395157756.04.0755891
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43F4710000A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:07:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mIDYiIOe;
	spf=pass (imf05.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769933237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6eutNLEmldLaIWi2QOrKdJ7W1VjSKq79ja0CoQ+cj7Y=;
	b=Gbsz21BkTTohVyQ7cR+EhBF6ofmGaX0F5/nVq7eZyaF0DTaY4H6EY3mWoUQlXo8TbU/9of
	kmlkSKmmUZye71XVjJZ/iQVHO8+v1fZ+hV/aFWWFijYDpDYqosz8CS7zUdRER8vaqz7UaP
	Q/fHP/Q1Id35v/PnAS/6yIYy97AVgr8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mIDYiIOe;
	spf=pass (imf05.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769933237; a=rsa-sha256;
	cv=none;
	b=eyUtyBRC2i6InHuTmVgd3WeV3asmUN4fW/ZCi2h8CWMA0zCC5sj6efN7tvcAqAG/uyAeTi
	VarqE0+xPKoAi7YWSIKApIv9Un7KuGWRNgcLJKz0otU+SVr048zZu/VoPYadtBo2CkvfwK
	BaM8Gch+SUzPx0WwbFHdhMlIrVc5wwU=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5029901389dso27463721cf.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 00:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769933236; x=1770538036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6eutNLEmldLaIWi2QOrKdJ7W1VjSKq79ja0CoQ+cj7Y=;
        b=mIDYiIOeb3eHgrcDUio1V5LO0TeNKhdt8T+fQfLmMVzLY5R6CrJrkfLgmxJHo4g+8g
         WdCi8I6ms9ZdZAn09f3iBXYC4rXHwFL5KerlRas2FHrd4Z21moxN8jdgWGWPFa8s56KS
         T/mVtNjeQydDYSIXHeP5ZjspZE54+1MvxLkvuAPDfni4n5XxMdbjEd71RGyKAbHKVmHR
         YEW7j8+2DNkpjoKzv0lrpFR4S5B7sNHIeiO93zM+dWpJyJBdOrdcAFSKClpWnZmSrB5P
         K4g6It8hXJfy9OvRefptgHkbkxeb/S33hn67MymejBMbMt2plG87j3V5nTxgHmVmDPjG
         oj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769933236; x=1770538036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6eutNLEmldLaIWi2QOrKdJ7W1VjSKq79ja0CoQ+cj7Y=;
        b=A7qGkigBqoXvD41wTEj1yIpDfp4iKwHUC4xESeXAULwp8RU0gY479jUDXV5mS6wiC3
         nPRJseu31BiIhDkQyA0z7DpNZXD90GUl7YSwq/JVbmTR1emAVBRh087kvKGFCRF7dIEy
         ae5KdVr0pv9aKXYQGwPrD9DLmmriVYireYblgjSv/niEhbaISZfdJAMK/2cTm2AJrJ4W
         s8qGsVt5sxqVX0zckufUFVpwSy9kGzpOB98ZUEOu+6Tv8ST5uzkiHMPWBEyJZCi/+SjH
         89Ns+wMk1HFvjFtukYOntP90j4wZavmytOfrMI0LSc17u/4kwyk6SBRWtRkYTVKam4K3
         8Pnw==
X-Forwarded-Encrypted: i=1; AJvYcCWXxe6EbsMQG25Sh5OBM1yxf7HcClCoc8xDXbQrGMLl6Nyj7sCACxSq+iL3UCDmBP9oAL9g8XSfnw==@kvack.org
X-Gm-Message-State: AOJu0YxTe6czQDeOOFGQqdAGR+3tExPbCsSQv/tOgsdbpoP7k4ZM+m84
	/kXEn1Jx0LGY6obOirv74wbs6hTiOjdwYI/6fXzSmG1hJgOml8PzVfuMTLVKBw==
X-Gm-Gg: AZuq6aKr9USv6ZaQI3r2fBDfDTBRFiC0ux5RYySiVRIvJUgMu9KJuWFbXXhiaWJ1lOt
	G41s/MlqfYPrRou/KpoMWixiG4NCSg0nDyF1ar4ZqmTp68phgB71PhRd7hZgzqh78JM1b8SBn4e
	wyx7nYEuROLlyj6HgT97Zw7GTsBI0RBhi2drqz8gT0Fh451+qJCccIrjX8Mo7wZf2nIadPU7l+9
	0CmZVtHu3Dd5rcv2el7+yvnSjCKGiNk4xUZ9HuM64hzwRmXcDy7lloGfT7WqfYWzzgWJP5en7/c
	hI0Gp3H8IxdR8mKpcNAku7qEy2Gyq5nn1eef4LcukGobGZSFHC8pgNu4N7L9A3zNqOYOr6MvCLS
	zEYlXOvCw0hCiKylt/rcwcqZa2+apdoRr2RDs7HmP3zIXjLlxIg3cUEMFwFvhZiVT6A9pJy7REQ
	xnGXVNnRL35gyrGqdIpDVx2NbKbhHQUSstVe8X5Rn+qA==
X-Received: by 2002:a05:6a00:21c3:b0:821:7d75:f42d with SMTP id d2e1a72fcca58-823aa710b20mr7502550b3a.42.1769927743937;
        Sat, 31 Jan 2026 22:35:43 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm12149294b3a.30.2026.01.31.22.35.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 22:35:43 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	chengkaitao <pilgrimtao@gmail.com>
Subject: [PATCH v6 0/2] Generalize vmemmap_populate_hugepages to sparc
Date: Sun,  1 Feb 2026 14:35:30 +0800
Message-ID: <20260201063532.44807-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gap66uhodzkfgbitohy6djsskjsq41sr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43F4710000A
X-HE-Tag: 1769933237-444881
X-HE-Meta: U2FsdGVkX1859mmYIpD6tBkj+gqr77rqhp2PQiR8yn7U2wwuVf7MihB/OFdoc+jp2ZSaIWtXO2lPZdHjm5/wWXQV3bMVdn6G3BvrmDPQ5PTASwnzyuaXdt5aqc20iFpW2Uf9ZiwZWw5F0iXKO+yIRxx7DA2vMYk8BOITtEAKX5ooNq2YUa5hNFQSpafHKAZ+GEtdwsOy1jHtZpJepxC5lEOIZBqYZQE+i56ewsZyv6Ykxmd/8vkZig6ts9K3BZi1ZbIqgo+wgiaFHiGq1PUBWxV69tkiP9UaaESFBc1oPyv9CCqFSA7YlP7ofs7g7dpo9fFMiLx59pgo2B781g3tzWt3hYytxjp+LqvXY7ypEBM8R6BaqWXa6KbkEA5GDQyrFvK366V06UWJkAmvRA6Q/JGWqXjQB7WV0Ey4LGbeoLH03hTOARWjVVorX+98kxMfzUhPBZYeOpugT/34mfMF/CAZf32Vg96pY2RBSmB3zWDP40OizKKfx2zO+B/FjkFWJSoNKX3XyIWqLPsy/vZaIaJY36XzuVQduHdAXVUJO51CLnwpjEm3LooZt2jx0xPN9LW96ACGM9Hh91gbeJb8ih2Y7qt5T0jvjm5CzLDj8dM9ZlKkaVp0/TIjMtf3un+gJFbFctzEoQjAFtopUuc3eN4mnx+UquZPLZbiz7mD3VBtXBibv7u1mhZff0yi/gnG+P7p08MB6D3lSw5NtyRyG4rpf+qsfz+vPIyr4P/k1pvxMOzcFG1GKeFXrtRPCFWefURAhh8H6TpOs1BbaGsyFi8FUzbWPFTMyiFM573BswGIEhFBUgMa4K8fVWhscFYJwjEc6grVATE+hKuba0kEU+/Ab4/WraGXr4rl+ii/ef25J0Nt6+XkxZ/PWDWaJNm9bjDm6aPDWpzzXNt1Q0TW6d/IOPMmzxgaSYhX4ezQABW3EyBRRtVF8IH3dFAYPzh+OKkNnhEdZIUkvxwKNla
 WxYjh35A
 f6GFlNvM4IiuLhYHWG2WoHeVBVhD1NLjXdEKCSkTnQ5pgBbFUXMGQdWTPykY4xnxsPS9KAMiROY8X/q25oGkz7twhv1GBp0NOoZJZxND/mkUKXu4oJ7hfGDDHTejFoHOgTPi2r1d9vX+lhUExrjasq2yOyzptXhL1cRX21XnuSrNmRrXXa8icfwJ8vJrsW6LfVt/l2aPrrm3/DX1DzXzoeUM1fh3xExlsGITKIHuynwREyeGGGciR5Et4TlEyVzg5yDC0izO9j4LJk+rR1pz6dpm5CYINjclvZTPxQ6zYVIlPIKNEBp1qmL+Nax+1xxdm85W7K1Qjaq8x9/64v/uosLOpzsvyBcfBNG0LkOEcJ1NUMLzEdSlV3vx0eUuq5OlXO3F8ECHuwq8v58dzwUeO4dMnk4b/qG7TTgFpML/hEHM2fPQ8D439kbcD6Z1qswi2ks/MB697xBjgSIFFGP0c5GcKxvZ1OtI3ZbRiKD4WTUtcl+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change sparc's implementation of vmemmap_populate() using
vmemmap_populate_hugepages() to streamline the code. Another
benefit is that it allows us to eliminate the external declarations
of vmemmap_p?d_populate functions and convert them to static functions.

Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
_basepages, which differs from sparc's original implementation.
During the v1 discussion with Mike Rapoport, sparc uses base pages
in the kernel page tables, so it should be able to use them in
vmemmap as well. Consequently, no additional special handling is
required.

Changes in v6:
- Ignore handling of altmap

Changes in v5:
- Remove [PATCH v4 3/3] sparc: Remove unnecessary whitespace

Changes in v4:
- Add commit message
- Add verification that pmd actually maps a large page in the
vmemmap_check_pmd function

Changes in v3:
- Allow sparc to fallback to vmemmap_populate_basepages
- Convert vmemmap_p?d_populate() to static functions
- Split the v1 patch

Changes in v2:
- Revert the whitespace deletions
- Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed

Link to V5:
https://lore.kernel.org/all/20260111074453.66728-1-pilgrimtao@gmail.com/
Link to V4:
https://lore.kernel.org/all/20251219115812.65855-1-pilgrimtao@gmail.com/
Link to V3:
https://lore.kernel.org/all/20251218174749.45965-1-pilgrimtao@gmail.com/
Link to V2:
https://lore.kernel.org/all/20251218130957.36892-1-pilgrimtao@gmail.com/
Link to V1:
https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/

Chengkaitao (2):
  sparc: Use vmemmap_populate_hugepages for vmemmap_populate
  mm: Convert vmemmap_p?d_populate() to static functions

 arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
 include/linux/mm.h      |  7 ------
 mm/sparse-vmemmap.c     | 10 ++++-----
 3 files changed, 21 insertions(+), 43 deletions(-)

-- 
2.50.1 (Apple Git-155)


