Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E6ECCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E34F8E002B; Mon, 13 Oct 2025 05:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA6C8E0007; Mon, 13 Oct 2025 05:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9948E002B; Mon, 13 Oct 2025 05:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 241718E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:54:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAFC61DE1A5
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:54:58 +0000 (UTC)
X-FDA: 83992632276.26.EAD68F8
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE8631A0010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:54:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZaFOxtNL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of madhurkumar004@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=madhurkumar004@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760349296; a=rsa-sha256;
	cv=none;
	b=oqHRoPytUM4ZGzaJ2xjjAMXG9Fi2wtvPZDQ/K9a6vHYJzBonypeU4mYCOk7P+daNZ5Mt6n
	OoKlh32PcHguypAZQ+hg0/1Fc5ArOq6Vm+Qg4+qHjNKzo4f6aQmQJGvnLVi1jBwdrvD/MJ
	hq/qyH4kcvEnv4HzUqg2+ctEC/kwTl0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZaFOxtNL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of madhurkumar004@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=madhurkumar004@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760349296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
	b=NfxIzM43Lt5t+ZP/CM4i5sK9cpDJDkBY+qem8mIhCc8MUpD0tjfHYQdqfUZ3miyO+avUQi
	thjiUsnFNFmIu54XXfjDiH0IpTisIDi1TSU12kHtGwdukqqfB48ghRChXYmHEWI4UQ3DL9
	uzpXp4ILy2T3/0hObUrPG6uHb9SScxE=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7810289cd4bso3889739b3a.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760349296; x=1760954096; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
        b=ZaFOxtNLtwdR9hKJw9iyZue9nxzdKzR0hDtLF+As8NXQ7DxcRRwOOIK30QAIJR47jI
         bvq36V+xtbwGMhQ/lxYfwOHEmvOMQyfpU0hA4TgcGMxakK8qNOtQDmUOzcKTYaO8Y4bE
         /13M+5o/0AKeiVPjp4C1zAKbuSRe/KZB97vmv3dKfRp8zLkSUnV2qa304GQEOF8PE2Pk
         JKJf+poxBImM41wE5pGYb0IX/nRd/vJL7tskucNWadrqOFi1d84EQwYfs38xTfCXI2xG
         tIDmAMz3SmTx5QApqxZmJ7RV2UjmZFZzkQCfAARtO6BkpTu0n+UsqNoJrz+4EaQoWVDv
         326Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349296; x=1760954096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XBTCn0qOLXBNC2zwAF6b8+Yyipiu86tjZBownPcTO0=;
        b=fk6GAjGO4kT7J9D3+oxpkaBgp6V84cVY+YOU32weJoLMRW02PLlP9/AoVZMdnDHwe/
         Mf6LO+aD2Uwre5uEQbUjuiyIcbvueFEUKmSo3g2cFr4xyjSPHq9eOic8ZOQVQKQOmcaF
         HgX9ie5CLC6ZJnZF05og1cXGP/0ckIyRI9dZ/2tx2IYIlM1e0dvL8Sb5LYhkdhVS4fxi
         wyXInf7whfkMvoT7TwZ4rP9TcayKvCMA1En+7l3y6g98Y1gL04whIeqlLPNlafjSaF4y
         OMQNdc19NjFdOKmG/q4AkDZ3UuJnhc8N+OU0kDscSdv+OU5Tp/jMhjD7z4fpd6fzDZIX
         uc/A==
X-Forwarded-Encrypted: i=1; AJvYcCVTCAsuxLrP83JwsvIag0z3Mu8R5QibiqknEImWzRBRXeRj7p03e1GlRgYImIazu9D9/w4DAbwOUA==@kvack.org
X-Gm-Message-State: AOJu0YzbyThH7Lee9bbG5Zqtoch8n6oZeuB6jAJDJm0f093uWXJfUhWX
	oUxM6c4Mv/XE1Eo9HX7e2rbs5KD7nKgTeFXawJod9owp5E61BGyfCxKN
X-Gm-Gg: ASbGncv5CU2cYrdr75NGweULx8eCxWlVHGbEHb30acRlj5lUj6SHr1N2eXjwTVuDxo6
	23oIQHE/276xtHntHWVpyq/U7BxCXGL7reELFQbWitJMlGfuSo6Z0qcwdZH4J8Ng+DTtux9oHhH
	1SodbcUjUqLLikREcNG/MUrGEUFeJOLbwp+/EWoTWvyAfpXAwC46YPux7l8n/63XeW8C60gc9TE
	k+ioMgXbrlBHjLNHPzliHavSoZqyOpIEeuFu1a4I5uozY8LZjA5Zo/SYpe00YgFHzLeg/weUrFp
	6M1Cz49IhMFqEF911IDghbjNE9m/pMCzirHEgpBfJ+x5FKMjUXibNNI5HEJfZFFh6eVJCZ9IA3o
	Xb+dzqPjkeZK/tr2aqHq+W8ZFPfs3BlcqsfrfazRWUaAJF9pTptWfYgUg6TzbdRyP
X-Google-Smtp-Source: AGHT+IHCOC2UNw504vBDm8gMi8seqOaSIpg2GtFp/hPeTYk7Ed41YoQAxobGkgEagxM0zCsu3LNgjQ==
X-Received: by 2002:a05:6a20:3d1c:b0:245:ff00:5332 with SMTP id adf61e73a8af0-32da80da55dmr25664345637.7.1760349295737;
        Mon, 13 Oct 2025 02:54:55 -0700 (PDT)
Received: from archlinux ([36.255.84.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678ddfeb7fsm8975030a12.19.2025.10.13.02.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 02:54:55 -0700 (PDT)
From: Madhur Kumar <madhurkumar004@gmail.com>
To: nphamcs@gmail.com,
	hannes@cmpxchg.org,
	shuah@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhur Kumar <madhurkumar004@gmail.com>
Subject: [PATCH RESEND] selftests/cachestat: add tmpshmcstat file to .gitignore
Date: Mon, 13 Oct 2025 15:21:49 +0530
Message-ID: <20251013095149.1386628-1-madhurkumar004@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE8631A0010
X-Stat-Signature: hsxupqpi3nas783jys7mykahugm5r4xd
X-HE-Tag: 1760349296-603006
X-HE-Meta: U2FsdGVkX1/pr2siUNZg+Obp3z1IdvjS8bqZCkSbLZgG5fi3edLwoWmm4YFcJAwIJYqwlcjiWC86Z41udjlO3riuEcRKZq05hbGFppQAqrd1YgmBrfdWOxjFhVl4GEwoqfNfEgGu3pzNpS/GsD7a8o9IOwQEpEFnJ+jNRb37QSQeUyAf7yFsYQ8BCe1UzmclylyKvfkXU4tN0dCoDCSXqxdZBUnSex12nfpU0V9hw56JQfR0xL68Ob2hnWnRmLpj8QjyGmQJE4nocD+HzdSa/vP82W4o08zf82XXLzhnNHA9TZ9fW8w5qG/OdGi7kdP+Wor1FuqODaBPFAgAITbl0fxaGyc9HVs1hTKZtwgkinLsojPzplD7rq3iQSUpVB5q2Mqr5BVeZEilbNcEMm3r7rLsHre2rKP2S1cc+HpzRzkjd0FIaa+VZG8gXSnKu5o6jcyjr0BdMOmG7b5CrHH4+hhX9y7saToMNjo0lHen++G8TAGOOqBDAS6LeZ3rmfBfCdvMYByYhwjX5xswSkZo2Cq13BNKDV1t4ZWDsJ3fGy64cJ/eFn5vjoIakEZyiQbFov8Bz0nJPsL678xJUu7xX+SF80LaOd0or+DRqCgTxYtufm2Axx5DCQ9XHWwv4GlqeXR1AT3g7JPaaEH1lFV2TN4+6e4uIkjSitERnWfri1nIiNbSuQS+6PHYMdXJOdIkgl6buTZDibcqDAVb6/IHQoT1Xwf/O/yUwdBCCmIf+WNp6jE5CZOxyuypasClQhwgynyTsfgZTMDhuoqkQpca/dppebEZzzRfJLce0NAmOhxYFRgTIR7aJiDSR7DK2ySzwSF8bKIdhZIF8HgYgxtS70uqACsMh89jDcfzYUANfu9jZnXrL4o030/iJwch6AN8STxh0XAnR/APp1QWtrGLxO8NKLixlH3K/siJXrpreYa0GWV114jNtcku/C5kPMooOryfnenCmGGRzs3f4gX
 KTroBke4
 ukV7z3egOVbZ54VgO58uoVWWItKV+6Uw0Gt8y7qG++iLRYcgIKHzTLQQ0fJg4TsYKaViqYJdwRvpIAKj4o6FH4AExyS3k66oZiLe2eLQ1Ptb6A/y8T8i42XChCNPTSgD9qJ626BhkAKyLA9O7Cq8o5wWfb/1eCfD4nBA2tB/q2QjQ8f+v+yiWD1UY1ilEhbb7jAbT11miqH2fmcyhxpwfEQhRDSUFoOuwb9TkxWUdl0D9ISKMEnvXvLOi+OWYGoYdkeAIb3pnaftihaArN0IzdVqnnzg7MEH8VGbj17AEAyfH809NJuCJF0S0Kzwew3C56DLl7wSFDmFSWNdy4NplxG5YvVM0H8S+QJIvizMk3Vx4CYKlPaLq1Qms/vyIq/d0KGnhJgnqxBgEveZHt04rgW5Ya6k9BRaMSoNUTvrtGEognROhgwLtH0L3Lsm0YlAywwXNFnuVh9Mg8BlAZq75rGlHeCAGt+1HR/dTnmBxKj7F1Es=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the tmpshmcstat file to .gitignore to avoid
accidentally staging the build artifact

Signed-off-by: Madhur Kumar <madhurkumar004@gmail.com>
---
 tools/testing/selftests/cachestat/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cachestat/.gitignore b/tools/testing/selftests/cachestat/.gitignore
index d6c30b43a4bb..abbb13b6e96b 100644
--- a/tools/testing/selftests/cachestat/.gitignore
+++ b/tools/testing/selftests/cachestat/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_cachestat
+tmpshmcstat
-- 
2.51.0


