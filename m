Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751BFD767EE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95756B008A; Fri, 19 Dec 2025 06:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43926B008C; Fri, 19 Dec 2025 06:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45616B0092; Fri, 19 Dec 2025 06:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A13D76B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:58:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AB18136E50
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:31 +0000 (UTC)
X-FDA: 84236073222.28.0CE050E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CA8F140003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZzOiXNK2;
	spf=pass (imf09.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M982etOTK0HIgjHmN9suIouTW3J7DDmDwah1Juiharc=;
	b=2ItYThINB04tnwJvMu665PFNThe5GqoFNiizmQD/XYeF/Bdlfeou3YGhudRkz+703aQ46/
	scl9H7aHAjcoBpFiJhhn51K1Suk+X096eUm6c5ZmpXSn9hE9AU6bfFYcINJEn1PqdxJB94
	yG0G4ve06F9jFyHGVeq4rwi4l33XW/Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZzOiXNK2;
	spf=pass (imf09.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766145509; a=rsa-sha256;
	cv=none;
	b=qWd30c7af8oOI2fEp9TQ9jA9EAw5hvnQ2ahtNxP2wPE63uodex2L21Cl28LKlMw+YU/qKb
	aahKuNtGo7OZzzqDYM3ZHiz3wkrVANeUYFscr/SIJCNCvCJkR+/vgpUdJdoonEcbrlCYYh
	FiraImpB2wR83TQlArWObxWaUXTWrf4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7f0db5700b2so1559974b3a.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766145508; x=1766750308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M982etOTK0HIgjHmN9suIouTW3J7DDmDwah1Juiharc=;
        b=ZzOiXNK2sDRAuFkXkJc1STvNxX1+Km7CZ5tmiltfV4M8WMA2lNC69h18zPrrKyzXPl
         Rpc/uryPn3SXcqnDVdYreXtX36cvbmbHUiGJFjQrtfruz3VAcOcCotdKBVYMWF3QvbwT
         QKfoYeo3jNBO4WT4Ktb66Y6rIvm7GvyxLZGBJJM/8+joSSHIIYuKqBUTDjMuK4RnkJ0j
         +ZU6HwhRTZLHzNXI4c9QV7D8gosVPXeXZ4LBvRtLw4Z+mEhoroze/4gMMZGM+YM8EINU
         BDflT1UkdaP3a5Iwp3NZO9ek4IABts20IHz3aLQEJ4vgPpjEh7nLGeNR4aTCqC4PiQ+P
         LMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766145508; x=1766750308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M982etOTK0HIgjHmN9suIouTW3J7DDmDwah1Juiharc=;
        b=MMuYw1jHa+09sjzEBmitmyK+Z9sRIfMegsvBko5PNCqn+wZ6GYCjLZI5X2fa1HWykr
         SY/urXsZXiQ1X6SvZ8swBNnrsKJ/E7nv2arcROYgD1HmAUMDmlpNi0GQz0wXjqRtY4pb
         dWYm4ah/02tCYYlCYwS2DlpPO4tVXx77wEY2ngbSzlpr16AX7WXa6l+s5Oy4bte70w1f
         Yd1/CKEh3XzJ+P+BKyN6GrT10vSEB3kSDzNi7ftrb+W4e0ilYflRfmx/JH8QhZClaP83
         hWuQQHRixMEl8/ZQuSbao5AHbcY8QFimomi00NBu+TtK0FF8sYts7YKmOcw+l4fHC6fu
         f/SQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7oedldj2yGhHBto7avQ6DCyExIswdRcoxr6NMvhH3IRr23SHHfs0I8zVVJiDkh68wtNjz90XuAw==@kvack.org
X-Gm-Message-State: AOJu0Yx0uk5wSbRovnnLq+Ap4cosC/cin0PpuKd7fPaz9IIEr5o7iFTN
	0OUcWbrTUdPKvwyGYR0oooBrcwElxt8GDvQr23gkBNMNplS34uB6PdBE
X-Gm-Gg: AY/fxX5pl83jUU9aX6GfW4Mlo+3PzKdAhOZxqW7ikoIPSe0BsV7HkjzpBlwvDr+88WN
	b1qSvaBPduH1r5mWBfad7DKkyB6htEto7eG7TKt+VDIgViBOl4s+H6sYRXoxmHHsAAhke1IN8IR
	fgn7gq73cra6yWfRcQVk8xyi/LWgoQZKQZyiGPcdr27ggwl3od219R5Jqib1VaAxKi+vaGMMy+b
	JSZlAxJGZF7VJ03IqK+eC0a5fd/bsr7qUnHw1KuAH7yqiL65aOAh1iZFKCTQ3cV1D/XvIsByBWh
	zH/9tJ3/NfL2xRCQgQ4Au71xAqPsatw+nlSekLGs9g/0Zc9iNMnXQot91bLF416459yWBzEKdYf
	AuNWKzxwcgXKg4W8Yv7jssSXNqfcFxnb2TcwlF0JDN83v0EZaPK/ADRqprsm+gV8efMChwAWOaV
	gRUAdZeFgXfvkKms9l8GlmALXyoezcWhxUZCEN8IW70Q==
X-Google-Smtp-Source: AGHT+IEgMBfun3xWsqk3fBKYqgWJUFSdZSnFF+VmVblUrbz1oZvITOpgUCt5kp+9ojxYz1Jr4XV3Nw==
X-Received: by 2002:a05:6a00:4295:b0:781:17fb:d3ca with SMTP id d2e1a72fcca58-7ff648e71c8mr2512389b3a.15.1766145508304;
        Fri, 19 Dec 2025 03:58:28 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b127b00sm2258560b3a.21.2025.12.19.03.58.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 03:58:27 -0800 (PST)
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
Subject: [PATCH v4 0/3] Generalize vmemmap_populate_hugepages to sparc
Date: Fri, 19 Dec 2025 19:58:09 +0800
Message-ID: <20251219115812.65855-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: hohmqjze65oh5sxzpjd7sjhebtrmqcp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CA8F140003
X-HE-Tag: 1766145509-29066
X-HE-Meta: U2FsdGVkX1/SjmmCkgsYMuBeQ96XStZgs2jh/cL9pXSXsBi8+EJTBujpMGgobS+nF2pAOpbK3HHGwlMyLlUYK8ZpDacT1NzYcIg7b+aHmCUv+SPDbRB0meWFWNJlZ/ARpMKY1XBQ6Fjw4xmtOfoddjjYOo7BMPp8gkJbRHlSOpMfUqV0MOhLXM/gsWH+C7/wTN2qlpzOkTdYk6fNWl+kEx5mRKb1ahmDzFtXKo1X86TS2o35WpwwMb99G+Dhwags2FLEL5HeGp0oM3IvmT8MRdDsNaBbJ+Pra8ZkUjiOG5PGmvqYMZb9WYkkNNQGnczC30+RR7OBg7feyoNQj9eMgysEfb5U4XEA77HJS2ua9vd8+BobSgsu0eO2MwRNBdQazyygBrVq/NhbZdo4Z3spbsjRZWSkGiWdAPuwhZvP8Kh8JuFrvk9zN/p2554Hiz9rX8LhCaoQ/gzEvHMzFFal4m6GnTMogpgWRNjdj//x8Zqa2SAkwVCpITc5fnE0owEC0BNkVYxBJ3JSSqwmDrKuWyM+j+hgl9HAOv+fn8n595LQQV3hgjY2AeZKROabLW25YMvPJ3sqwJBB5dTylDUsXwsBWBuKjzDVlQlXo4J7t3KqEkkr2QntreFUTVzRB2aPAoyncKFyvLlUh05dY8wZoHghn3JCkyfQgci2x4GHb1aUTbG3UFrCQYluQwBSySFFpPKS0jfAa521oi3Oe4OGlqh8DteSuqi11sG8BcuDiWszT2S1aQtbHuAvYw7AyaVh/bgCoAr1GcybUQOrM0mpDt3uTs3z5Snylm7v3s/eP0/Bp3eXxTXms8xHDgQckyEi5XUHNZ6iwCOaRTC3vWdRmvGL2VEcW8J4WsAOKxCCPyhHptRHPr2EmCtg2Qr1h4Q280z4+unUTLNiQHgQQYSGRf6wwpPDPsZoxWE9RfSb+itaIdHe5VvFPVlJWMHB15UZxV1R3frqEUT9JeTAvEv
 KJ2nMF7I
 dCK/Q217j8KeNocq0sek6SLsksj8GTqNTBmNxu9AfpBdJy3Ue8VpVHQhwtZPLbbcJwS6vH40ApogrioW6Sw1okObU1rsJk3W2cDkYEzMZPIVhx0xOWdrYxDLcI1uIQ8WBH+TYzZF5i8mJB8zkAN4FvJvI9gjJtRSPEMX0BFYzAtwtSryMEx1mmjk9wLNJq4x6FY7lI7Nhy+dddogSBdP9ZP/kbRSLcq2T3lYeZ43fXvoJH1UwU6sepLZ/sToUu3JOV1gQAIrzs4IHe6cnilWZa9cmY2V5yaqGmxL8h6IE3Oh/w7Ol6NwTX5pql4zph34lmykXtg8tawq5Y7TT9cWTtStccER0AJyio2ms9SqBp+O6FHJZfv4TDahWR7X0ZFrlug/QoURwU06leK1/23YlqeQ4gRQvHWOP77sqOkp2NOloX3eyUhFDm7SrSsKkPpCGsLcR384ZgZQowVgIhNwAyIFEbYzUE7IBHPZiedc4NQlO6po=
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

Remove unnecessary whitespace from sparc.

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

Link to V3:
https://lore.kernel.org/all/20251218174749.45965-1-pilgrimtao@gmail.com/
Link to V2:
https://lore.kernel.org/all/20251218130957.36892-1-pilgrimtao@gmail.com/
Link to V1:
https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/

Chengkaitao (3):
  sparc: Use vmemmap_populate_hugepages for vmemmap_populate
  mm: Convert vmemmap_p?d_populate() to static functions
  sparc: Remove unnecessary whitespace

 arch/sparc/mm/fault_64.c   |  4 +--
 arch/sparc/mm/hypersparc.S |  4 +--
 arch/sparc/mm/init_64.c    | 53 ++++++++++++++------------------------
 arch/sparc/mm/io-unit.c    | 12 ++++-----
 arch/sparc/mm/iommu.c      |  2 +-
 arch/sparc/mm/swift.S      |  2 +-
 arch/sparc/mm/ultra.S      |  4 +--
 include/linux/mm.h         |  7 -----
 mm/sparse-vmemmap.c        | 10 +++----
 9 files changed, 38 insertions(+), 60 deletions(-)

-- 
2.50.1 (Apple Git-155)


