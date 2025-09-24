Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403E9CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7E18E0021; Wed, 24 Sep 2025 08:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958B28E0001; Wed, 24 Sep 2025 08:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EBE8E0021; Wed, 24 Sep 2025 08:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 744818E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:01:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36F61876FD
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:01:05 +0000 (UTC)
X-FDA: 83924002890.25.325C8EA
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51B1414000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:01:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gXYncs+v;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
	b=zhJJToR+yZ+XoJJZpyUWBFQeKUX0vhqjiq6K3qk0B/RCT/ezHcd8MAFRTwilkjJDeuyTWo
	B6IDh5cMsGSkXkaJCNDuk5/cX8y988WQOITtzBV38HYK+cqdJU0+XAW3bsCMfqxs4hjDqg
	hFGreAxevENWLepxQhPFCu6TfZGhlls=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gXYncs+v;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715263; a=rsa-sha256;
	cv=none;
	b=zB41JBeDyuRFN1wVB8uN3kZaqS4007q9POv75jY1LO27XV//cuUTHdJYAsY7+PHtpy2H5x
	2LSifLShdboH+pL3o8ogbqaoay3jHT7nROInb0CKRVNc3lwPk8DvRjapOFoDh6Zk6C+j+s
	k+SpVElT0k9273kIN3kStpLpB9O1NTw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2570bf6058aso90468315ad.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715262; x=1759320062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
        b=gXYncs+vkmx9n+PUGsc13a/06mJxlbgEHLlgtVy99tmireDKJTSzNakPpaF6RDcUyU
         WbIwMC6rUFX4XAsbBL+17k5LjgFX3M62Vwndd0wWW19Zc8ApU/SDYrHsxFQbrRibXKp+
         UFseJlHDs2VMiYYEA6WbNZQQRjc8KsmlJ3d8vj98XmBGjGG0SXAAVd6R2pTegLx/0bu/
         teehmrNTKP4a+kGlhzCXYyqOVsjDOPqCIUjiJr6yQtzVry6WlsZQDX9Vmqm5/jCmli4x
         quEfwyLbau4D2fPgq1KLzqLcllBqVuYKgVuQBkodVxbNBMNC+DzDw6ax44LDGNEtZ4gR
         15qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715262; x=1759320062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
        b=R+ti1GeHijhY9ew4zY/lVZstGbxGVaWTGoVdzkjE8gDwcErDH2ykzXmN+1LLNOLAQP
         H/Y8mY+iqnocSVaL2iqGIDlfi6oSrvRgnCTdqZocUkKsXctyta2ilfXo6jbGzYf5S6gX
         gxXyV0vHkpDN9hOuIVL6dPul399viILUomvQVnizpgtXx0U4wHzg1Rxv4Usry5mAWdMA
         grdOelzKlDAaxivXlo0YFSDitC2jAV41IdsSCHDsyMZxL37M2CAmoZTs4TH9X7hOtHWz
         WUKx+OuH7OwAiL0//8trEmBo0JNgAGjJFdVrrFyq8SE97VEtgFLRR8X1r7UuYnJ6PE/9
         G+CA==
X-Forwarded-Encrypted: i=1; AJvYcCUhchlxaur6ZV4C9aLahcDANC2idqzi8h9E8os0Xir9f/WPNfvYUb/Wgj/UlrVBIIya/So2/2u0tw==@kvack.org
X-Gm-Message-State: AOJu0YxwMmtEtFYj/kdcxpnpC6y6cXNZY0ItUT1aOPOsmPqyserVSGR2
	LRwNRp0AZ40sMgNDYKlU5Ts2RMVcMblmLLsL0A/j/wXy3n5l7dXOzmvB
X-Gm-Gg: ASbGncv+++6MHMMjtp18oe0gEYUwrzzpJqe8nvA48i7aftCUOKg9Vw7pbChdCHdvCce
	eNYk7WDGu2PlfsZbQLcux7Qd9DP01oAejT80ZJBlSmnKCiq4/73UNkg90c+GZ9y1H4KwFOk62FH
	oFbdTzPitJ7HYI9h93iNH5IgYnG/cY7eiBRx1IpDmuNiYV7Crm+JjGlUMWHeBY3amgUliBx7y3x
	htfhTv3ljCxAK9n8U2uJelIxbdjhjKOrb5tlwzTTEF4/SD2pDcWq3DloLvW2Aht6Db6YC9HutEK
	8uPQE2/l7uvI0exCyALtzncTGdrMEgCTbsrKdXn9G1fCq0cjnC03bx86Dp0LmrUluVsYYTi4Xk6
	T3ArtyjBBmxm3kqLCoEQUgGE=
X-Google-Smtp-Source: AGHT+IGVP919XNHolLvfLc++BjiI5XDU3e+i/BPRLdij8Ir9EMWggkhD6kjR2mYU+aqH5NAU4i53wQ==
X-Received: by 2002:a17:903:2450:b0:268:f83a:835a with SMTP id d9443c01a7336-27cc9a91248mr60333305ad.60.1758715261649;
        Wed, 24 Sep 2025 05:01:01 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980053d25sm191276975ad.12.2025.09.24.05.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:01:01 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v5 23/23] MAINTAINERS: add entry for KStackWatch
Date: Wed, 24 Sep 2025 19:59:29 +0800
Message-ID: <20250924115931.197077-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ybgqbg131a1h91e9zsd6xnwdi37753i9
X-Rspam-User: 
X-Rspamd-Queue-Id: 51B1414000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758715263-18490
X-HE-Meta: U2FsdGVkX18hHJIK5265QnEXIKJ7qf++/uSTt4/MGidygTzGM+nkgGiTVfvF6VvtKDmR46L1gLwQZly3OjhzKE0MduKIgLYFOXBUtW5pKDeP36dLmAGXrgkPLQDh+4mBOkucKLUrUnO/+D9j4XzMTfoG20AZ9X9w+rScXs8kSpOEY2BXXx8y22IPrKU56PwvQKGwFc5UpnwEnA2H1iky3r46wQaCSslmQnuwn22zx0Kk40slbffacbfF4gg/4lGuq3J8h4WL5bO/3fgldsdAKll+a90y+qjOlovUki7BzwLxztyNwyM+mta82UajMHDFh+lLEMqUXTBVPCMOSJNLWab2+19I4/iyyKvXg56sQZKyfa2vP3QUj5MvHAHrTqWqN8MFdpcNv2+dsavRwL9aiFuDzvPfautyd5FCaAvCifp1RfglGd/bS1fkt1GQTjS4mN4QuVPrbSwXt07bmoe/Cy71/Ncq4mHXyG3jvDnwITqHsq3AtWNRGhFkktgDz+9Ijy1yEoF5syfo/zn4t3Dr7Nj5/TDKHl9n0TrPb7oVU/b1excjpE43tjFhIcsaRPeli94xJpL8UphtCrDEeWz4ajx1fH2QLCPkwoU7ejZStF7IVx+07KO6jobdMwLg/Fwq7MbQSe8o9r7aDpwA/P7tMOg52cZTks3/bRhArBo43+bn6ZCVj8GYk/MUjCR/+7+nzB/efKug2r0pm91AXBRkRdcm5QqhvyghZJ7b3ZoIdbITP2ky2f8zJmmWw68npKOG3fFdhWOaslpXZO3aM0wrDic9+qTR/8J6l080vro6TiRc29SEL9wj5FIuSvyCfdBK9r7Kw2lP4WwN9zD+lp0PxnkD6jKMcqCC0VaFc3DNEYTht7gTT7LL+v36V1z6qqWS2bvh5C6d+v4TNpx9ODUwnPWqL7rRAyT9KWQRKKqIbtK30XuaL6aLl304y387N5RSxCwS8amoyuwQ17btp/B
 46IDjhQS
 MmRArZleKNmeZqrDFyAus1EhrBscGDZ5ApZ7cCTBcq2VxutbGnZzRaD6trdfi8NQEqqDipKy0Iy6LX4lDr9Xxdcwrrmr+MBGo2EOf7redFk0TrLGoy73LLAi1b7GA5HZeLBXuVj1s6xbm4Gp0pe70xtFW4azmU7PsT2LLp7QteUnWYiRQ1SnFC746mf5SK1Iy9wEk07AQjauaqYObCA9gkm748IRYTC4X/E1ioPz8uvfWma0G9iFZlgBsrB2gwRYNBumol8WUHuZIGzgxWipGqJbQbpuxk1sgs1qsuYZqMYGmG/tweG9dOgeD5vzJS9cuNhPPwnl7INC9mZ7kPMLGrGNZ1MhgriLwVG5RQn+ro/e1DOjexRGutWSmAtfWsNHF0Lo+uyyNI+Nsz2471i6NkLMZpAVbPVQIOeE8udK7VihU0brXGiOIzKedk1wCe/iiMuy87no528on5A2x2PEJB1MOWHER5skoM5CFdss5f8VXnbDZWXEevmOpdlCteeYSscnzCjl1kHC3KcttKqJ9HYZrw5gmwKm8U5jqQRjrA6G3HyzIIM6dulxjHUuxMToF7t/Dp1tIiSLepbK927yQK2wkHIO3Wl7Pb85N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a maintainer entry for Kernel Stack Watch.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 520fb4e379a3..3d4811ff3631 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13362,6 +13362,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	include/linux/kstackwatch_types.h
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


