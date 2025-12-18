Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7301D68BD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6926B0088; Wed, 17 Dec 2025 22:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93716B0089; Wed, 17 Dec 2025 22:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0B16B008A; Wed, 17 Dec 2025 22:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4D7E6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:23:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 761DE60BB9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:23:37 +0000 (UTC)
X-FDA: 84231146874.07.1C2A525
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2550C000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:23:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jWTNaIFC;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766028215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UG7pfV58XRZ1xvXhlyO6OK4zqz4Y181lJscZD1whg/U=;
	b=q3HqyOCB6v5Sm1SNxwZJzK5p7PlnbgdlTKLo0RZtO1CdsbLpfRSPlb089I5OlGvb3TafJW
	N2RrJr2ieUaTV5ggHPxI3WiZjBzjHh8hq/6JoTULOR3QNxqjLsQzCdEoKraAEQIy25do0N
	rXH/WoRzZlcsgpx6nQsRKdkiJwgXbD0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jWTNaIFC;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766028215; a=rsa-sha256;
	cv=none;
	b=nYnJpOeV+p3gKFXuAo7mby3rlNaQwJn9iRAp6fim7WMmqk6tBx/XZlDZywunLRF/Yzwqgd
	CHobG8jD1uVByyrDzTKP+cjGWjhx09D5wyTse/CxLRMufENx4P0cvWj5sffVDqscBxr/BM
	8im4eV0clPwDpLM7PDiBhiDMFyLL9sk=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ba55660769so174977b3a.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766028214; x=1766633014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UG7pfV58XRZ1xvXhlyO6OK4zqz4Y181lJscZD1whg/U=;
        b=jWTNaIFCmErwm/1M65Hu0MX/KTtdQltbUEECGfJDSThYBKPP9WG7HFDkIpTuBm1aS6
         K30nQTYvWASvuflE6PWBc4mrGbdrtKhG3ZmUKgWormcCaGuFdOauySun2NROnG1WJt4/
         EmVgstoyblYqAby2xZY9BJFpRTZa769/VLLi4PhTI+mnI/ZmsSHijZU7m7ybCFor8k6v
         6EiHCzzqPdoe2PV+6uFiNxzbe/E1bdDaIX3Cjg1pqt9FNVpbflfjMfrfTe5/IJoGJPF2
         SUWap8n7Yq/ne9fVdhImcZ2JjYSu9LUO5bQc6jDLIRR5lhOa/kZQtHKVAXHIor56Yza4
         Zayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766028214; x=1766633014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UG7pfV58XRZ1xvXhlyO6OK4zqz4Y181lJscZD1whg/U=;
        b=jPZ2JDdYUT70r2X4gQN9nGvxAbf4UqqWlKLNq+6j08ibXWBQTyMLCpkHwX4Bv7D0WH
         oXxgpbAXh1JutVpNzra9Dtuz0Zy5GHxg/WpUkpf8DDGze9TcfZQloS2HyM0AkIXBs2iO
         B9waGS9ZE8QnItjxMp7UspLQeSakGjJst0Tf/du4TJdmVkYSLE7q7DPopopQJOC8jQox
         ZWZqtqTsQpnU1oMvE+7sAKbynsyXi/1MVWnl54zQoseX/Gzs1/7JZeBqdoXdm81W9bs4
         L/zCMdKSxzHUKn3JBOO8p92wup9xCxfNbY+6mxSGzpa+snMzfgD79uJrCbqnvBJzAvV+
         UTVg==
X-Forwarded-Encrypted: i=1; AJvYcCVAN2GX6ZXBXUh7BXI4x0l6WKx1ziAg/wXpN/QqrMMPjgmDJIamM/VBdKYzW0Toi2UiCNDgtufNVA==@kvack.org
X-Gm-Message-State: AOJu0YxiDy+WkEI8MsrbtuziQTOCVclqEC8f395/YSHOraCugUFluVKc
	hXUT9VmKiNvUF5IDveoxHAG5Fpc9McfzKOzz1lIH2o/ooUMe78Q9r6ar
X-Gm-Gg: AY/fxX65Mn1LrIm5RR6ojsM0SvBqYkDJKcmwtVhCDycozXnNhrJE0V7D1lzZtIGqNbU
	iutr44E8U79HFOXkhP9TVKFXB0T3p+nsC0PIKPmnBy3onw2Qg0OarlV0+qKsV2LUn+02y1evT6j
	q9+VxuO5AojfVJf+s872GTydO6NwJup/Y3SqRgSv7tYIrooNe8buzBbcSRZEFblK7U2eSAfqMpQ
	kI61V/2VZC8bLksCxNBHZO14TAFVPHlg1ClykjT8eLTmmPX0iwPbRRc1he7B839xsNImU41OHR7
	+evjqJBiWFHxSq1c2Udl0XhEvej3dq9XXk+B6fbA7aPBnpdBsWh/c8UV8ZdwkhiiqulR5sBFkoQ
	Mj6EkdQ6wML5gagZlNiv81rV1VSiZ+dJDxbtnTCGXazI059iJLdnUH0gzXOsgSpVJW5s61z+YUS
	EoIfA=
X-Google-Smtp-Source: AGHT+IGQvq/DdZI6Fp9wfMB+YHKDour/ZpI/dwBFNByAuJ3jrP5gtK30k5BaErSIpjYma/as4s6gNg==
X-Received: by 2002:a05:6a00:bb84:b0:7e8:4471:8e4 with SMTP id d2e1a72fcca58-7f66a470cd1mr18789906b3a.69.1766028214396;
        Wed, 17 Dec 2025 19:23:34 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe12125b0fsm884992b3a.20.2025.12.17.19.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 19:23:33 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>,
	stable@vger.kernel.org,
	syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com
Subject: [PATCH] exec: do not call sched_mm_cid_after_execve() on exec fail
Date: Thu, 18 Dec 2025 11:23:23 +0800
Message-ID: <20251218032327.199721-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2550C000A
X-Stat-Signature: 3oh1tuwteqant9dm8es3rzef99hupz4b
X-HE-Tag: 1766028215-510058
X-HE-Meta: U2FsdGVkX1/bHxpfQujN+oVxEE0fCvRGHZaOanTL1KBrJRPMjA+31zgz/Rm4qWVsMVbR57v6ukSOYLnrHYfDOECEPQ3ecalASkxPOIjxA6s7JDkvwnHug1iX29XXUZca1wN7npjSVLNuLivd3To/3Om0hkqM66jDsXYt0Fzx2vqa3/3QbJCFrxFxPII3BmFj9S8kFRE896j060Y0+m7lDPBqvx8ffR+QENKO6ddcA1gnIVRKcA0L+9attUANKe+xcs/tqYcGRw5l0E/eMqmQrWRiyceKyAy4PCTEgpkfjTbRDZqqVLd4LERRmm2wq54bRQkOivaZ0pRhfZiTgNHhMRrtRMIXP53rvnnykcJzAXMjGXAhqJjpwND0mSnqCPFxW1GguuIMIAKvXHptarXWU9j0rDiqgRR9JjZ1khZQliO1kpKOloodsIaHtg3qMwXwMLU8focHvGvUj1rNn2KIJxtrx5SVhaZwn8xxDSaCl5GLTaerzRpTS2HeIyA/SeZ3/txPscTr4wKI33O3IcWroGxsIhKlGtPoGTgev8hUE+pxP/5712VzHk8L3emyuhpzygx38y4LD1ueryOTuN1fqbpaNdNF3haKOkr8BI1fxnUjPJ5sVzSDUPh5xun+wkGmq9Tz44H6lrxlAInBj6l3MEkNINAxSCTNH25Mg6OEREMjH8cFESVRDjkZQOGLEAn7WFyvmsmD7PFRSQLAzvcm/qKPCZufSkILeefI2MgOJRtQdgpewux/qABF09yop0WRYQOF825bABTGNk2q5mszd72WgJ666mgZrjtcgCo2qJ9DkBWbntdpbxmn6b6duwesEJsUKIHNdTt1TLvYXGfi07UXlCC2tD6PzqKxkOAnkoQ2tNAjMEeszMqFamGLHqFYC38/wehqB4b7x6eTlEoH6e1xYSHlipiTdfNsYsbmhVsy2mJqmoXHLdU9RyxQvRDY3fT3CpdNjfpPz8c2nKK
 S9sIX++A
 tDJUXK9KCghA9ifkAgf1iZjsXP41pp2y9ob62lGfrG060g2LZF6wOeB63pUNo2hc5BUpqO3yVCDhL9jcZedn36ahHUHjNdRxlqAFYO2dbvcuxnji0uw8BV5AGWaP1zsb3YUPz30M/MrCUAsXK0oVA4Z56s9nf5bAS2pR7BkIIber4aqpJDrqbPvvPFxh/sKvMwc1CohXacftYCvAw/2VCbJ5pynPeocXow5ka1FWcK8lTXEVoZKB96x/IJlcchDmb0bKzL6HfK+TgmFxwvVTmR8e7Cl1ZdU+9ZkVSK8SBRyhZojC8Tj4r/5Jo6ZJqiDj7L6RlaLsCoQZ7UhcE4siCwkYiyjA/2HSAd2yKg/k/3YG85VXzM8NgaMBxXGD+1faJqhQQfN47bDVNpLFzOwilaxco6AKqnwc2ZCBl+0FWlFZVm4qdoogMUM91k4Qdq0SXEdXEdL7QPht6Q8PFpWewIZUVz65D+mihqhkB/4VjZ9OK1HCrKM0qH7Wa2t/Zf9q61i0K3YqPBiNynmBcYkjjoscFcmVqezVjlguLHumH7rN7+d6PQIAkL19mfpR31AyAFslGZkYI3O4AE6tL1VjN40SmWo7zTH20OJVHDaKOCw09gmPMTiRPj6sZMVfYfVO6IHEONYVj+6PyejVc+KR0BPiIRQK14nx4QSZPyj/WwligcIUG07avcR1hKQ2HtGSzcBPLH8NZzspCHkRl0ZkO9OSk4LEyx4VvwRRNudJFprkfFntFF56oROyNy25Z7dWwTtm5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sched_mm_cid_after_execve() is called from the failure path
of bprm_execve(). At that point exec has not completed successfully,
so updating the mm CID state is incorrect and can trigger a panic,
as reported by syzbot.

Remove the call from the exec failure path.

Cc: stable@vger.kernel.org
Reported-by: syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 fs/exec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9d5ebc9d15b0..9044a75d26ab 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1773,7 +1773,6 @@ static int bprm_execve(struct linux_binprm *bprm)
 	if (bprm->point_of_no_return && !fatal_signal_pending(current))
 		force_fatal_sig(SIGSEGV);
 
-	sched_mm_cid_after_execve(current);
 	rseq_force_update();
 	current->in_execve = 0;
 
-- 
2.43.0


