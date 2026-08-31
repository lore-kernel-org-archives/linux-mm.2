Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F396FC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8F96B00A1; Mon, 31 Aug 2026 05:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979E86B00A2; Mon, 31 Aug 2026 05:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840C06B00A3; Mon, 31 Aug 2026 05:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60C686B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:24:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D20F11C1844
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:59 +0000 (UTC)
X-FDA: 85161027798.10.9B7F62A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 126B7120006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YzRHr+45;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+K9xBUZV2Jmd3T8roo1dKtbVqBUblSh726dOO5UJPI=;
	b=qEYRRMzHZAuPsTmIgIj1+a06bngpxUYHSfsYtfWzYPOVOGQ/UNkv0r9dqtf4RvssC9vfTx
	9aN50Il/AFj0sKPkwgp7LNpXE/CqJxPj8KNnIvHEiUKrIDMYzqHFqYDKM5ivVNQ8ePQXBt
	UQhhokZ14DVakWhlTE8z19/2+t5PFQ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168238;
	b=RSVD0iiMvt4iEH93OnNHyS8xUxwWN3b42Nc31axDQjb7PFuQQnVL1Mvq5MKxkFcs7aNzTU
	Z0n7dh9TKmqM18Xf+gxr95ekR/5XygLdSziwXX9pulYwsxCewJVM6lI20lYolGihwz6OZ6
	5tSy5yfBRLQNCCdlY2MuZmCJB+WuMc8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YzRHr+45;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so27373055e9.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168237; x=1788773037; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7+K9xBUZV2Jmd3T8roo1dKtbVqBUblSh726dOO5UJPI=;
        b=YzRHr+45S/E1FoC3mCoreU30idHK7PTEOcyXVtVzxg3FbvwFfe8xAc37qyg6diASpM
         h3x12csWuAdjxjHTZ78rWFUxARx7tE8vLPxgtXcBGEFG3a2oPgwuQ//wWRcHKXw9dj5k
         E2Syd7MnSY4ekkXIWavQ+eu5FrmhwiB8NA98ANOlt8qaaM7shuCziETrZ5KsqrLI8pw4
         GP09NMEcU2f01mPHqw1nXpbsKaNuAEGJ0+tIcE19o7YwtEWwDOcciKwDzUZDRPZi3Kyk
         e1afBmzWEPzESwwjJf0HA8k7N18f7sGtpiCJnS1N/v7Q0Lje8WcDDTrJTOf+avFwkWir
         MHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168237; x=1788773037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7+K9xBUZV2Jmd3T8roo1dKtbVqBUblSh726dOO5UJPI=;
        b=TA4zKs0NSygkXhHkWHXgDrD3u84viJfUeJsW98ZHkGfUKZz8mgSRYv7sBSkFFHK2Rc
         ZtuLInDUNvWVKzTlvU2w4r+qOhWMwdNmjkuIoWgCkTGDhnvYZL5UqR/3IXINXlIsJnIq
         QVu00WEVyVlcTrXCkorGJ2MT7FqSsToGfzYYpIWASkPIji/wyW4OH0zz5WtCbdpP0cVM
         VfTiD6JBK/w7lQm1peaDHkV8PzXzQekKuyNGHel5bgCkhzz3wVmAhRMlwswkta3nJ0Zm
         BLpPESLkFzuWJIfAdIR6sRB9uevEj+dzSrkJcgAAkyHtCEi4UUYyE6sHqe1SRnVHvIdF
         lHyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq5IIvPxz+D5qwpZ3qntWhrBJoM5cE5ZfQPf/Va3yjPY+9WzVgIgF9B1yZYZndqTudEAfKT5GAQUQ==@kvack.org
X-Gm-Message-State: AFuF++mY5yWBrMxzr8IodwiHpAC4kBa+QzU2lDrJj3kfuxgn8YdaZb+L
	hvy4yWedLi3xgaX2bx1lfuEXId4v06XIDcyA9vh2HBNrQCzh+S2GlIup
X-Gm-Gg: AR+sD10R4q1uN1/6L5nhFgS/ixJln0W7ZNrNTAAi9uYmpHEmN1KcHgzJuifiWc83FBh
	wkMTpj81zTTNHUphXo87Xrc8/tkQOv6ZDZWc2DpUOlZKJv91IELJEjWwQ6LAghpJPRR4QSaxIhK
	c4YNhCS/aiskNesygcxiCeV2AryveFolZX08AvISNC4jHzFzMdheO0SMu2hpzBVvuvsM78vQDov
	wjJ3WGq/pZfCsbpdz61ZG9N4wQIFqrGSlkCQG6ZqEef4Uvrwg09pyN084yqjQ7qYuheKahKGPdh
	dQlCY/zy4YokjvmDjee2lOseDJGwhwpq5XuMG9FWIC75a0Lbkxe62+AWVXWb/sU9Umeyscp7j9U
	u+J+4OiOH1SIaKQ1xMIGCbqK0xf11CVq+S54M9FtgZ/+PKdV8jwdSspQXm5O0A6S4auNplPst1P
	E7aWmjD28N6NQjkyuTiSeiEaL1yINIhRUZ1ynv4h4n7e87JawIdUStInYIlNVqvFf9yD1ICJ6tR
	w==
X-Received: by 2002:a05:600c:1d08:b0:499:bf0e:95c8 with SMTP id 5b1f17b1804b1-49b91c2e145mr372213505e9.1.1788168236596;
        Mon, 31 Aug 2026 02:23:56 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:56 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 6/7] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Mon, 31 Aug 2026 12:23:04 +0300
Message-ID: <20260831092305.42062-7-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 126B7120006
X-Stat-Signature: sb4kiu7cpodmo8trj8gezu6hg183fohe
X-Rspam-User: 
X-HE-Tag: 1788168237-459765
X-HE-Meta: U2FsdGVkX18TAAOyzAJpAY/x87+TpuWXK9FlnfUQ+MMRmYRKJiinffK6o3UHgSU+DXfEYOv21j9Tevxz9GNcAeWRwiCmUnIrfB1ZPmqIu23foozQIS5WCXsgEsIEALNkzn9eoMEX9Zx8uKAvZBZXcm9VwDT4m8OBlK25MrVhRK/UFQfMctW849NRY5VEflgCjJOMplhHpdznBPF7HPe7T3it/AxIyacGV6tkj2HKON7Dbr9CdFc9AsJxfJ2b/FmKWKLb6DdOoqg0F0G49oDD2m4/zDbj7xSebsz+nDlhCtlIotSzOaWfKN8F8Wf0LzeQSr9vQ4E2cLKuBy8wZr4GfiVr9lDIpiSirYN+FC1aKwS+XdMEgZMjURsKrRJwOcJ3ciHeOzE5cAASieIEAIAIF31UIKnD1whSxtDFZQJNEX7/LvZiJQ7OGg+pl1LazwaNryyhhhWlpxAepMYG894WwP0UFW9gTLH2df1NBpb5cc4X6t/1m8mEi/WPtmO1a1QHghsfdFEiVHJ2osMoolK+8ei4iQLVWnOa6hbDk2Dpczb/QzwJaHORIyE6Ad7lVqXpTFKGzxW0CRa4Kv+wpFuUXgW5xgbss0IukEwxKcPi3Z75eS1gh4I0chqPzlw054O8Gnri4ZlXVCPVhx+46D3DfSJSKUhiogvuPVSGOCYAww4jVWDmT+QmqZl7EGJuSEFcZWqCH7hYxl6BPsxMPSLMsdmRWYs5YQp18/ZKoVq+Cx0tAJ6tsSfNYqZK9TDhg9ndkA14UEEoD/GT2gjpMWBeCebCrAkobuIUlMjMl1OaDPgzekmN5JaYF47exph56EIL+Rk9ZEWju64oAJRWQtEvUaF9O13tLiK2SWnheSLCUz6iPBMxTagDXF14hB5iAtS10CpyzcS25y09Y63WUEsODcrK5VewBrxqLi62SipwhXSVZdTt+8w3t3Yort7zwq+AxT7C5GR4SMVvDk6r8cr
 b+wQHa7a
 iTLz0HbsobLkBV+ZhB7aoV8x/65lo7B0sL3LPGsEzUZciy+SkrOPQSmYV/16iv4e6dv3AHwP+7fBJpY4OCT+mp9T+0G07BK2tjQjOa/pTtv3ybBTMwwcrPnrdacHJU9Tg81N6KMpkbv86PjuBsfTv7+FVJvAT8cWRurY4Kv9oul3WcGJnqi0V9P6NBuH/eYYOaoGr7F4Yec4kk93SG0RmWwPGHBWX23Fn6dtiALWHai4YMKQvfye7u6JGJ/aFbetYyzSzm6dWGfjD/UQhksMPRftpLQwX920KL1KFLnJnAaA2Hefu4mR0xDGVWLgrXK/6mSorq4jo+ATnTPLJyolsh43bHxoGBM1ezhlri2fGCWRJ99CcOvHq04w4E1i7AhDFfuV7C3rZ5l0KcvpDX4POh2sEohxBPHkQggO8ma8ITZzOr7nQonxkF+53vugUz4T5PTTX7rEfTdRNFajlSaDO0MQdwcDOaQoy7pom3Z6xfCGilkHl8zXYTpgEkAghOuXyfLfVxRZS3oyd1oROuskYbJrCrVDqilGk/VJm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
can pass it to kfuncs after a NULL check. The linux_binprm owns this mm
throughout the bprm_check_security hook and clears the pointer only after
exec_mmap() installs the new address space.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 386401fe051d..584c79326b9c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5958,6 +5958,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -6012,6 +6016,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
-- 
2.55.0


