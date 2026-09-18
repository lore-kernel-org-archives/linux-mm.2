Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF336C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97BBA6B0093; Fri, 18 Sep 2026 09:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDD26B0095; Fri, 18 Sep 2026 09:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3936B0096; Fri, 18 Sep 2026 09:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA516B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD7F8406C2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:27 +0000 (UTC)
X-FDA: 85226937054.16.0920C39
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0261740006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kulWN9Zh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737506;
	b=uCjoYpCXz1daAE52upD7BN4K82WpGM+Y+zC4iq8lc1jtSysf5/Nj53EMwRecIkRfii67qB
	3QZrD7A8fYzPg3vRq8vCAIw9bwyvF6sI3BhbucKGqi6PfvSLkIt26m2NEEQn5X75QeSjJU
	cfCOyiMzInsrFMQQZ3Dp7ARtCSR6meM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kulWN9Zh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
	b=ovVp8qJqumPI9FoaXFxpLJHy8ayOKVZgLsjZu02hbnRpsLbwIbF0Sr3gfDN4xRAV03vyVw
	CIDhI2SYLxtVK0QSnwXBWor7m8ZSgJflIAtgkt9nESszDr9nCV6iY8HzFAuz70dZkDX3TS
	c2PlQGzpHrmOkHI69DwG2rCUrjpqjns=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843172bff4so392971f8f.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737505; x=1790342305; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=kulWN9ZhK6+tQXCUOVJw0pxk7RSngv0CY7RPbLqAU0WDeoGYbcJEUM68qCGpjpJDys
         T8emRkjgECdaRJZX9zPLXn4mjg4ilqYAP6is/jG8k31q1bossht3HRTdahQXLSYV2zSv
         GcshWl4fzLlpgfjcvQrA+B7FvqN81yzmNLZbi8l6BhZDmH4Sr385wsZLghK7K9CzEgWJ
         Qal+G9so3/qXEC65fuRWEhNNxyT5L/G+33U/n97ray5x2jzeL535Nxkni4YXmUI/yB2I
         gZjblHlJHicZWL8TUvZyqlo8poEHbeIZAkZKS8Wx7AeeELLEayVq9wPTd5elLMJvUmrq
         qhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737505; x=1790342305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BcITG13Gvl8i0HA4g724jWVmnWns/ceZ5ECxTEaQlok=;
        b=cWMqlvzMQ0b5EbN0TQfMJJ1i1EHR1IkDSP4fDxdI3MSwQssqXZ+xScXju2/NFUsOUY
         WOcmAcWEYV1JsUBF9128BFVgm0iLtGaVA89byerUugyCOzLyCkvjI3iaoQsRvcip8uKs
         69ifyTq+LRE5h6RIDMYNTb/F1WxnG/2XTjjO6OcZsS0Mq+sq+PulTxHygFtaFYg5jmjh
         KN7kVOh1JrE+//q4RxOqdwgNnGzVGlvZa3O1x+Q+f0+2KbfAhjQe03v4T4D7Li8ARj2u
         XvpaEbcJkHPhAwJQ8VWAkwHAl78JG77uiWil4Xt37+5hAn2YTi/Id5be8GdrMkt8O2Bi
         8lTw==
X-Forwarded-Encrypted: i=1; AKwUvBxt/bXJcXVXQ8JuqXN4rCmJ0ub2iEwvKkC/MA5y/DpOuh/Z7Iwm0hQud/BJ46YD20gSgVzoY5xBeg==@kvack.org
X-Gm-Message-State: AFuF++k2Ci7+JFQDgt8OTwcR3PR0f4pK7SUFbTqDvGE09Sw9ptcItOKt
	i/XEq0M/CLE3Lgr7KicYd/c4maq5mSa5Qq9tQY5Q6QS7Vi4E9Luu1DZU
X-Gm-Gg: AYBFou1y5qLQ25vRrISBsvW4ogl9WLYBWFenH6XE+1zesolMdjOCN5gn15IN0Skp8wp
	oxHM6rNvOVInj++RGJ+ntOQHXmTYxwlQi/KlJoKVl4G0wZaqJqoLRajH+n3r9uXxy9hPBXFz56c
	qNgNclGbYIBUDDW6OymeNKJosl9P5IDuTzeh9mz484i4Nw8AHTaUEqA8DPoWRbPOvPitCkCAVxC
	DdGMFBeIIGtNlNZXlIZYTuoo/tbqcd0bbEK0O4KuZJNTAuklfvZ07eK45gp7R02gaYv1dcONUhf
	cceJiCKNCoeBO6HOw5BZD0+6YajzxPcBfD2VLeJO0wbSlBzKiwiL+R3z2h7PQzCeQUaXGznICG5
	ImQlXMZ17zSPQdD3AuyJ0oUD/MjQ/Q9An/7nCDtD1dNiohjLF0kB+CqGWr8FB/xWcDLdphxyg71
	2ud08+zv78aMqPqZqDjJLH1s39BeQu9u/04k/i04UYYaO43iqgf42Z1LGneDrgv2Icf2U6YqJPc
	gLOObDCDEM8TLzX0otBqI3bRg==
X-Received: by 2002:a05:6000:490d:b0:485:8a47:5b91 with SMTP id ffacd0b85a97d-4871e36cb87mr3143383f8f.46.1789737504555;
        Fri, 18 Sep 2026 06:18:24 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:23 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v9 2/5] exec: Clear bprm->mm before dropping its reference
Date: Fri, 18 Sep 2026 16:17:54 +0300
Message-ID: <20260918131757.42802-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0261740006
X-Stat-Signature: epi3ion16xixznnrrumihoyyafu94761
X-HE-Tag: 1789737505-999813
X-HE-Meta: U2FsdGVkX1+FERf76yQ4YnOKu0zpDRQNjFSuKZzFt8Vunq+amW8+vT4X/ny+C8mg6YEo0WIhD7ZGd3cvgGVJ9OmuKO5DcZC5yCreNBdH5NcN9d7UGVw2eIrQHsQraemEqBquJymuRCnvFYD7v+zlRBqtbt+XAEp6ajMXfPxKoCcFETW6Izm4JRKDGVFWQt/uLS8/j/VLtw6SkLd25OlhCwubWEdE7r6Zb4tQvtKJ2HBkncWOTIoXLXWBb4/Z8KcDcx2CGBoKtrdp275fHRLFaCGsNffXqah/U4EblgYu+u+fB53Y60lxVQ2wBp1wdtLWtQ0ccEnJ+XRISt5dFz9bSSYTvV4Oy1hzkINg0XHYFqxRjb1lHgKThNIOSsn5QY5I37CP8+crdf18Tmmt0dLvisB6yRKV6m32b9U0M0mk1JKLeUip2zbK2Zns0HqKKlQ4mXlarIoa81LB4UrhERid8U8jx0kn9fZ+3hBpSfN53o3dyK3kSMZt/TBP4M5oQXLuGGQdUROFKtqnR5EAqaqgyNR80gWBTbjXUrpaGTyDxfeF5H3i5bIPP1zULdF0NP/5fYnA3lGRI/UK9wo5imnyF6pDjvIrwpN9/u4bjWyeYzoEb05ukeTgR5mZQYJN+r3A+BjLyOFt8GcO/KUtkzEp7Z+gqOCPyibrrztPaXtgWD8KRWCyUnF0p8RaedFQWWEli9vKo8iKDZHIEv4FqDSrOfutBYFOp/yJvAFXHWoaZ085JDsl82se97KOblfP5qcKHu6Kbn0BW9jiMUf6Q9GYq8N3IG0hkLnQiOQ78q886b+nw8xYBsNxq4pP1yanqak8cAyFGBB1ijG+FM0JOOpX0wp3RmjHuFIU3vgnwAB533ZyonVVTvL4htPAFg1dZn/AlWJFjGlO53RSXpfQPWIf2yspCDDyQCPRUnbLCeEjfAtcNV9GelTHp7mzxvU+epEtnpjD3tbgQjCuWBHSf5W
 G8dv5whz
 bH4UFx4v9HxG3t0+SD4ce9zu1uz/xK2Thuu2CyQFT6pnB9xyZG94ZdFf8itJYZqIM9+s2syMPnZXGU7t4SQBmQyNd3RCJ+XffhDN9RoLcgGJs1OFpdWTX4jYdBOa8Vt1ErZoNjZ3GeNsgnbMAWVJFuUG+Wo2KGY2enYVz8HwzkXJrrDmwLYXpq6o4iatF6Ky4RMJAg+bfTn6WVAiLCylWsx17h+KE8Z1GqnLyk4gYrUvdHxhbxXiZfiwlpDy2t3FlrjY+fzM/c4eM8k6oNT0WyxH/JKFUw1VLmmBJ+ks5h4qiiP270/x5Wt2w9uLFeEp3DMaV37I9Jgq49cSo+0Z8nbpXXgbSmqn8SCK/FrMKsG1T0w6tXtlP7W3Q5/oxixrUmZOFVlAcHyn8MVbS3+vrc92/9YwXeDKYqOpZ7jKDYpviws19610lJ0XyOMNLR6ps+9CMaQZc1EOVdnXV07p12NC/fLVjthzI1uCp/tz+KUdp7Y2tCTJzdKVdrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once mmput() drops the final reference to bprm->mm, the pointer must no
longer remain accessible through struct linux_binprm.

The successful exec path and the bprm initialization error path already
clear bprm->mm when ownership is transferred or released. Do the same in
free_bprm() before calling mmput().

This is required for BPF kfuncs where bprm->mm is either NULL or points
to a live mm_struct to ensure safe access.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 fs/exec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e..4ddd403fd91c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1456,9 +1456,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
 
 static void free_bprm(struct linux_binprm *bprm)
 {
-	if (bprm->mm) {
+	struct mm_struct *mm = bprm->mm;
+
+	if (mm) {
 		acct_arg_size(bprm, 0);
-		mmput(bprm->mm);
+		bprm->mm = NULL;
+		mmput(mm);
 	}
 	if (bprm->user_ns)
 		put_user_ns(bprm->user_ns);
-- 
2.55.0


