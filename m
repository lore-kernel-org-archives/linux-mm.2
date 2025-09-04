Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E58CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590ED8E001D; Wed,  3 Sep 2025 20:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5414B8E0003; Wed,  3 Sep 2025 20:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408858E001D; Wed,  3 Sep 2025 20:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7278E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:24:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFFC15BD1A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:34 +0000 (UTC)
X-FDA: 83849671668.20.72E0E2B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A81AA0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nz44EYMH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945473; a=rsa-sha256;
	cv=none;
	b=D99UWx5r21hDtNOk9PGUzjFQ3snBA4gTE0D3231T/BqZeHRQXeUpGYZerEBCT4RekRprWa
	fHqWPhU5JhfF7Vi1PVxDKGPFgwug2INHfeYiG56Q9+9LDjcwi+qqhmP2cvE6opFC4xoNwl
	WzD9YJMr+ScXOsYSzCB/TdCdagZ/904=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nz44EYMH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
	b=Hy7S+ZmhS23F0uhmB7thAGT9y3K9LlFEpZVDIlFVppkZ1Dz9pjvOzEIkNeDTI+oOXvZk9N
	QfJ0ZXNqI+/nCz45zEHaGODqowZYq5kd/JkD8CJSPccagvEiF7dhgPZQlgzMXLpkTxT9si
	WxKaZnQaYAuxymQfhP9T1bCn4ibHF/Y=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so541361b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945472; x=1757550272; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
        b=Nz44EYMHRUEq1YDbm3R8HjXb6Kzs6JV0jnTNeUyxh+CbQmP4kVzWMSlvX02brGt0t3
         sFWPYJVz1Sc694gBOGTjzf8vsSPw7KMjRkTPXxgn5MuOic/W9HwNSw9FAxrEzprP5gRo
         dGdd+g1TnX2bGvtCR/scc0jT0ZXmkTIkaEbJwj/o0kWZegQ/vlnQzyE7RQnPWeWZVcjv
         6QXkEzM/mDvdBCOPOmkHRlddJnVn6U+D/GfAw1AE6rPr0iFDiXyVcB51ss6G2bkR4RTK
         P29d8amOov4vdfyt833QvKLsoyFTDqFjDvBWSZ86zky8WCVZMBRufsHmasgCFYw/MT8e
         Igxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945472; x=1757550272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP+OdhpAXeM3MeCoK1wrQ3GVDNoiOJzpSPwPKz/ThLg=;
        b=iUykqh2ZhLHJAXCdsNkFii+MXu4l+dgS9JScdOn3QTdyWa/vkAQuPHaVd8HTYPgFEd
         5SCaoleRzr4LN4nJRlCX3Dh+5QQ1kD5DlNTzNMnjWe+fga1IeTatMtcTx7jn7hqnZq28
         2mXPct/HChE1vvirK5bmJhVDu90xOW17fXK2u6aBZ7t/cRiQXV9Bul0hNyG3+IJFMaOm
         yvP0FMi1lx6y7wlUqAzqfIuzHoX5ORrcZdvcfw3NkGgPlA3kxsvB44S233kj3Vo4y4Mi
         hKWTUHrR9Cd2XcvVYpNrzA2/NIeBIWTrEvqAsFUkDSMZLpjPavtQA9S13WvtMiwpoqfe
         0lCw==
X-Forwarded-Encrypted: i=1; AJvYcCW5/HyBLs/qy/b02E0qyHNBvS10PcCuJleNsZ38sdAe28LnnVP9J9YEG7Tl5RswOTlhMKiIMh5xbQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1yEMMC4xABve+OKvMug5VIXzxIhgJ0LO2qFYqUtLEi9vaiqK4
	RQQGPFkXOyHiG5QGlLpU3wqIHesNefwvqsI48S3Nes4qti1/JH8lyJzc
X-Gm-Gg: ASbGncuckHuHYhhA5WF3Z/ZZcppmV8ZP3fziYrL6I+dQ3qxtdCTKb35lry7ATKzjxae
	HSZpNhnayv+6fKaZ65FfuaE2mh77eOG87wfNUWJoGQhd6yGHFeGmowF8lEHzB1aDqesMwHF441U
	mdxxoh4KNFM4vJauDMkU7brFVxZszSzlE+Gvo1RQ9QysCw7LM8kv0v5qrn+jh5L08tA+4rzJBai
	Qq61WpQTAMVbH4WZ70vE7aBLspMZg9A78de7cP+e3Mnqkj1d7QaNrOlGqYGFS8HL11ydyyDYDTP
	saR3GC0bt7wl6NwuODTjniOOsRcTyvKAif4oRQA/tVzevGpP+H4PCowjtvt70IZ9kjHB3ocpRqM
	wAFydBKNuZ8TJ4FgQ+N7RYKwNjj9/XnO3xJNpujjpLCRopdRCIISFMaKHyxoPpSM=
X-Google-Smtp-Source: AGHT+IFdiMNyAnu9UryWCSK1mcKi/kj3qV4ntRIkK3d5kpgJtmLY+vw0EOiis+3DxW1OxC/tcEOAxA==
X-Received: by 2002:a05:6a00:114e:b0:76b:ef44:1fa4 with SMTP id d2e1a72fcca58-7723e27d90fmr23784888b3a.14.1756945471815;
        Wed, 03 Sep 2025 17:24:31 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:24:31 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 18/18] MAINTAINERS: add entry for KStackWatch (Kernel Stack Watch)
Date: Thu,  4 Sep 2025 08:21:15 +0800
Message-ID: <20250904002126.1514566-19-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A81AA0002
X-Stat-Signature: 8zmnshdn8cni3pn1uimtxruepzetrgc4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756945472-277697
X-HE-Meta: U2FsdGVkX18YSBVHFlzpzCLCSYcuSQvZthqBPn80NBWTDBpzIg4TCkwgwtUt2JVGkMq7hmClyv6wb4Y/xtR7fFn2Fsil38LxhjhXYzWGeeUpMTNKzGpSbjr1BgValYu9DVh5oENyqDGcj5KxPBkKxdOVyFVRLFImTKSZ/ou9U17d64T6SgulR2UAsnE5KJI2o3Y2+PXYQR8ERaaPK7D0s7NGtbVsbILtQb0shGJGrDGgQn79AWPXURrWTR6Hjb5eJt1p5KcoNywMTGMIKo86zn7iYkvCP5/pJHpazZYZulVzv9nesEqaJtZ4PEcl+zzrDGHoy/mkV8p42BJrrRcUX/ELxA6a+zqf4WqJdAVJLQb2TBfZz9gdwjX4LnYsa6QhXTuj5iT3zJqVzdJjzm9geqvKeFq4ZnW74H6J3mbWA6NtMKumau4D4SssvNbGYv3NwIXFjVSDF/u/igdMTKK9PQvGklUHPavMrnMvKPdIdKgtzftO7Juls3lXM/CfAjZ5EabggIgvyQldcL3AdcCurGy42G+WF4HE/PKAITeXWB6LTH8E98pXOdIHEYwNcvaQzFYk7XzeC6mbcCHX3YlhbuUc6d9WRR6mTnHqUeJIwkKgmSjW6e/X3mG1ULGh1kCzYD699cSzFFPEzsuydaf2Yum9Z9Kov73gTH5CM1+P8+G6fafWKSsF3ptvgDHXkoiXfuQlB7L8Bb7HqnbZBXTEaTX2GE+4Paw7CvUAjyt/rPLUg6veRsNvJr2ZYQCJDuDzyxukUfVId/QrYHyb64k0ziH9RDO3J4tWqejrG1Tz+b5JOrJL8gZ5XaSkROp9ZnKubez9z+xK+qU3l7Vi9GmTBk8MGnSDztaKl8BjlpF7+LFbCoWL2DNoOlCanArOPQuzDpBMZsnZ7EG0mO6RXKCHIevS7a4SVClqJIBfhooc1xu5hD5hnXDEHzE9xQ6qzNPwOrak+YVlK48ixKTZT/I
 FSdNMAwm
 BFErOuXIj5JgTqLg39QwMcHCHGeYLzB/R4G7Kp21CuTzrzxoXKxUKgbtbjnKNbQbLTG1xfIYcrU8u84Cq/NoKRq0tODWggUme5ixYYNy9WqbOP4B6cIckzXRYb7jr+aC51Yr7xGhGdSgNR1VZvFM+Opbr+UAuwRr/iUwGNAlvP/9xy7+ulXX5E7scSiU3sn+x8Uh+W+vc7Ble3ZwlJ7wE4TRrZrbYqh/QVERTZP0U1fwmhcUVBMJvSzXB97v5kngmsAXbGz+2FgOyjxqvOebn+icoC7LeODFQ/mqxIOnvyGxyTmxRywHeAslnOdpB16IxX9bOdQrsRozZlzhHZmow9uwKC6G86PuH27AL5577JZjfeRwNI3aqJYcZTJMnD3O1q8LMjkaUAY6Z14TZFP9wJoZ7lmFggZnM/DrNKUzWmaLrZ6pLoe9JsCsUYQ+FFBbRRvCYByvrWjrQWQXH8fidWVwp8lPDG8/Wn/yPSaNvCLon5IOZvmX8iz/oUYjeaj5hGWF2uUymjWzqQ3U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Jinchao Wang as the maintainer for KStackWatch, including its kernel
module and test script.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d79..097a0462e604 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13354,6 +13354,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


