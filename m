Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E2DCA1017
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CC48E000D; Thu,  4 Sep 2025 02:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED688E0002; Thu,  4 Sep 2025 02:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03D48E000D; Thu,  4 Sep 2025 02:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0BAB8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:23:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59E4ABC969
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:39 +0000 (UTC)
X-FDA: 83850576558.20.1989957
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7CDB3C000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=esKt04t7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpJy0SmFfEmeoeaFkzFs+WVa2Vc5JdK+bPJTBjQhA74=;
	b=FNBI4YCUUz6G5fBlESwyiCg0JydMRSn7gndlC4sV9LKvqzCfzBFYXTGGbOSTbsaYoT9xDL
	Ews3HexTcMGLSAnDusPPDru2A1wdFs1wUFGlHMd40F1bprLTVLKOPw9+ctusZldf231DEf
	Yb3+aLls76zedPZG4lwc4X4+EoW7478=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=esKt04t7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967017; a=rsa-sha256;
	cv=none;
	b=paU9Yn31SCbYZga+EPgSzorL8JXOsnn3TiEM5oIf9A112z+to+LWUJhZtE1FPwSJDynWu5
	IXgv4HTV8fH8dG+Rw6quxcMgal8ANQsDWXBIsxxj144Nu8cqkAFHLuBa7gqntS5Waro8qK
	VkUsUrFQzmY6Btyl4T97K04kDBwB1GA=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4f8050e031so33993a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756967016; x=1757571816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpJy0SmFfEmeoeaFkzFs+WVa2Vc5JdK+bPJTBjQhA74=;
        b=esKt04t7lt4xZ52EiMkG1igYrfsg2GLjQ/KlpV8ibf9Zz/j2Ge8Ib5eWTN1lNFOda+
         AFp1PrNliUN5ryp4x5oETIf8mhi3vKEvywEF5eGNascCO3VmSyP1MIuobcGthg79B4tC
         zLSPYbbnQWJSerEY7TwF/bDXHOBfVXDvxsX0sYEZA4O4KDt/8T/B6yYBmZHO9ZVmwgA6
         0/YHLSojFueiQBcONdWa1T0XojVsCQ3wSgt6XhpgcXbyNl7Ad6l0KPA6s1junE78dr/1
         MHfYTskaKGNNsRXIFZQcMyJGaO2pMibHYZLm8ShA+jEZzYGgIgKUmy+PqjligLUpncPK
         qL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967016; x=1757571816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpJy0SmFfEmeoeaFkzFs+WVa2Vc5JdK+bPJTBjQhA74=;
        b=sUIZMaJxsoh8KfeznMJbLOXGDuRJwzWiOvFk/osGJr5A3lVi1KbN+UlwtsZek/fsQ3
         i1ZyWtfrzQvkfbzR2ksmibGy/zZf6YmIkYxva2DzvHz0OxDnnNoIk6uFqdqyIQMRwOwO
         1y5m86zh0/Q9m7SdiPE9e6tzmWz3ztMKmKneTrYT7BG3EAtrmE42db2ZwpYKz+QqOO8y
         4jW7WG/qgRsGVMZ7daLodCJVvpNN1zDaYJDzho55mn194uTRNhswrxjQPguIbLo3e9iW
         UMW2ZwsoyJM+vmYi7UtJpH0yik6P9v4hYW4Q3QTQO1OIMJhbokI7CtQkGloZeLMpJ2q8
         Qfxg==
X-Forwarded-Encrypted: i=1; AJvYcCXueJo55JelOR9ll4bFQdKhU7KhJHfyZKpZS+9JnN3qBuOwNlNSKcE4IZKBEaMEvzF/gab0F4STIQ==@kvack.org
X-Gm-Message-State: AOJu0YxC01YK4Q3tNraU3MCAtnJWARsWrsX6A2MMfi9CMy48JuG/bvtc
	39FjqMcAixpJMM8Rh2CBs9bL5bB2lzAUwjMnHBwv7/jJDiZNF6iW/rop
X-Gm-Gg: ASbGncs5Vb+5zFPz8BYIFvFq0qoBrHBzeCs6WfQeaV/+ciq5hvg+ql+Tyc/dfQUDh6Y
	YXNMFS1FFOy/HiyTz6nOaH+O1/WIV4T79cyIdyQeyjdEozJxUtKjgNDE0yLS2AbJl80K47zcjeU
	hIPRK2Gq+iJFaFOV2v2JE5CDwwmYNrUyLJd2mqB1oTX6PXNXESSxMw1mAryKcL3hjKeRDzeeoYG
	gwES9iZqg3TbXWLBRMTMNSKV8QTwQ+sKDP1JO2M9nQt9pmbjO5Ag+rvjftFiAKP0g3IQw5u3x0u
	99fVxXT3SU0WNBI4VWK0FxVBLvsKpYaO9rho2lue4lm0AwSRLTLx2eoXNYQEFPkBHyEPF4NQ+9f
	a1U5Aq4AB3dYlepMk7h79il5OAqahq3vohUqYHRXkr66HDere
X-Google-Smtp-Source: AGHT+IEBJZvQVehY2sHFoniuE6A9P1WB/bX16Yql21Kl7/uCiWvYj5gVnHq0ENPDwr3ALXi69eZlZA==
X-Received: by 2002:a05:6a00:1c:b0:772:39db:fa09 with SMTP id d2e1a72fcca58-77239dbfb77mr9444420b3a.5.1756967016264;
        Wed, 03 Sep 2025 23:23:36 -0700 (PDT)
Received: from hobbes.T-mobile.com ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7725f0c4008sm10198397b3a.35.2025.09.03.23.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:23:35 -0700 (PDT)
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-hexagon@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Cain <bcain@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH 2/2] fork: change "a mm_struct" to "an mm_struct" in comment
Date: Wed,  3 Sep 2025 20:23:26 -1000
Message-ID: <1c468cd846ba6839fea08df36d8d6e9718625661.1756966290.git.joeypabalinas@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1756966290.git.joeypabalinas@gmail.com>
References: <cover.1756966290.git.joeypabalinas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7CDB3C000F
X-Stat-Signature: 7adoy8qhgzx6qerfbm7bchao5ukcmc19
X-Rspam-User: 
X-HE-Tag: 1756967017-446368
X-HE-Meta: U2FsdGVkX1/ALFHPXBHhHqhZOmKn29Z6Vv4iwfcEUuFcdnatApkfHJKt2ir44OEd5pX/waxN+gi2QGDpA4dT0fTlIEPX1yTCfAZqE52S8kb2Lek9TWcVmJvMQcdfuw6/6i9Tgcacal93GCurwIVtzr73aaziLp2gJ/MEHWcqvVbxSJjGMy3uu0l71/nCYU1SjuAkE7Ter9J//aRgv1vv2jL73fN32Lq2Q4zYfIdyHieMgdYnbgOZ38dIm7mUKtNvPyqXdmZj1HnPYB6GvbBZVzz1GPTkf0GQp9/GejtWighshPPXb5TmmrpvOix0FdXTyZg7POTPqseeiXJ8jJAUn/QOui1957sVjn6HdnrhhrY53Q8QAec9baBt7zVAwB+7dsmzpvYzDbcFKzmmd9aAI5h61vIDHx2lxC9/ZSm0+x4RfecXuprfAYh0v5QhkjuYX4dL/fK/A+c4xvP+fs8r137jKJeyxHkiEdObPt9QTErHmTywqWz2ILRyMwId+iiTTDCabjRyLPc0ybQECzQLEsicuSbjio9tyh30BctPUX1kwGvcGhb82FDt9xFYDxpiLcyeqBhcAwShU5jRvlAzSSqj7HeSYVBoSNUMrGbatgRoYxdRzcd9IY3taplXlNnse447gy/vcIfqAmNM2Bj1HjLIOuTJxaZ5np55JlmC2Y9H7zOFCCzvKZ+lbTOiKwtBPiVUXlXHFuSQ+BnncQuwZjBWLb0gxO4hYCZLA9ulTuR3WNTktNRbXDS/pKFuTPvsuLMQlB9Oa8d/QUtiuk220xUz4wiuHtWzeaUH1Aus6YwxhDa3TpkwYPd2kASAR4EZZn1p4RrR+PHxRg5TrL6V37WnCo2hTLg0XNjzhmAL1X6a5gzGclrOV2sEGeEPro1JvRQII0niSoBE60kk/YKD2N9YBf1kSsn2RFA4O69x33agBptpqsZ7P8gkOC2rsZve7Ywc1r10gJzTdfOZgsE
 wih4+UT/
 uT5cYS9kX/VsRrWoMs6NNIwIeA2h1G+km/DFEuNIO4l9LmEvZ10DefDX0Y5KWTEv8z/lNFoYdFI7HMfCmQ4rRS2plCm92cPpDqsHvgTkyUF/u+BLroMtaoVxTQhcZSQcNd06NE31DKTtUxy9KHq0HNYVviUr9AQAQzPQUHPH48Pk3ZjeC3GsD0HVFSfEd1UaGjycyLlFc6olJ+lhdduNa6JuWkzAB+4CWDhSD5HlP5CLnmm/nQp6UtzvbBt26nRAVl4/XVfcWo0cUeWs5VoDQNK/c+aZC9vLEHo84bVKBMTcPgiFu6mEuf+XPRQ7jxE6aJPNmvmE+dwUMRDhpjrYtm26ic7iNSqLV96149EABP7rBuHlleiaDFXgkEE02hnKJ3G1bevgG6bqJj+PqDgwyCSAhDfOk9lpiGp9llVgH7JjDXkjsBDDB7gTIsbOfodB1leHc96pXhBPzUl33vzPMBxEJvMUin7hJs/aTBC+QDfqcy3jZIFthvKcwzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The correct english is "an mm_struct" which is used everywhere else
in the kernel.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 kernel/fork.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index af673856499dcaa35e..9a783cd46d097a2d68 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1397,18 +1397,18 @@ static int wait_for_vfork_done(struct task_struct *child,
 	put_task_struct(child);
 	return killed;
 }
 
 /* Please note the differences between mmput and mm_release.
- * mmput is called whenever we stop holding onto a mm_struct,
+ * mmput is called whenever we stop holding onto an mm_struct,
  * error success whatever.
  *
- * mm_release is called after a mm_struct has been removed
+ * mm_release is called after an mm_struct has been removed
  * from the current process.
  *
  * This difference is important for error handling, when we
- * only half set up a mm_struct for a new process and need to restore
+ * only half set up an mm_struct for a new process and need to restore
  * the old one.  Because we mmput the new mm_struct before
  * restoring the old one. . .
  * Eric Biederman 10 January 1998
  */
 static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
-- 
Cheers,
Joey Pabalinas


