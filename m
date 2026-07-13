Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211DCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087F16B008A; Mon, 13 Jul 2026 05:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0390E6B008C; Mon, 13 Jul 2026 05:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93266B0092; Mon, 13 Jul 2026 05:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3F3F6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:28:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 450FC40A7F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:28:30 +0000 (UTC)
X-FDA: 84983227980.07.A7E6D9C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 939B140006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:28:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H31MrJds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of injaeryou@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=injaeryou@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783934908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4623BPbRgjIujmWqWQj6M4QygEbpjJiFDAO4rapy8N4=;
	b=cDbXPP3WqZPt4fBvZYS1ko8m/Dj/VP+g/2+ROkUb+au3yKkItEwsJh1u9TTbdGBaCXu5zi
	SkFVjB00txxj8aIeSlYoYNlZad3II9NcAaS1utaxD0AjjzkaubaEYy55l+2SzfwjV/L3et
	mnkJP3efPgydIyFtF/TmJ5aTqPCnurQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H31MrJds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of injaeryou@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=injaeryou@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783934908;
	b=KBuoCme975mW101LMHIUdFA4RLotvBBJttt2dAT9Xdf/JoM3MTuxMtNJ+5rHEE4m7TDtwD
	zt5zMfuK9VWbnRFyiTxUqARsDaBlr5rB83XpXbJ29/sUJegM8rvJTadoSjaZyD42V+5msY
	LWXizs6Hq1Vo9gMhzs9MhlbrxTn1Z0g=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38759bcd877so2339203a91.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783934907; x=1784539707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4623BPbRgjIujmWqWQj6M4QygEbpjJiFDAO4rapy8N4=;
        b=H31MrJdsyMV44CjhJ34CUJ3CXbRr/Lac1C29zxseNOjOVJhxas7LQAwnzmeiCBf4qd
         nFyeQP5Y0RSSt4/+ZH9a38OE3pF49G40zPVTKYWTZ/0YvozB8eIjNXktx58dkXet95Pg
         nPM1e55eqSwRNOExzrR3WyLC6V3D+NuDwutALmVHmZIWzoZyU8hwvK3/l0iTS0jiPgJO
         SosA3isCwgjq/H3rviQsL06VAG7wyfJJd2ywcxcU5DwdCuh27hAinKSqh6EvfnQR8X7X
         7Roktd7nXKDu5oq4V+CqQAMMOhYaYgflSlA+7+BobkWMCU0pScux1raeYGITTFDqENMF
         /4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783934907; x=1784539707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4623BPbRgjIujmWqWQj6M4QygEbpjJiFDAO4rapy8N4=;
        b=COVYKcP12AUj1mlr0prit1Z0/AcnAMRRjIjVWmIXC8IfcbqExZpKOFQayPtebMud5y
         hR8G/NhGUMN1J9fNeyhA+Ik2LJagcdsRjmEAfu5fMKo0hstMcVKZKShyRMjLLw+aUoWP
         AFsvrbFzha0o/IhKDVGNGApZ5xSiXrVHoyVnxAbhFEsRuZyZM/Jyra10cNG1/ONKy2PE
         3MgmPFkBr0R6pHDLgMuq8IGrv1F2pcOQNjbo9LM1YjypBvm/JULdwq2hxpG0piYJOy2D
         gIa6p2nHE/MeaJ57BKDhRm3yCdeL9gbxpIHEkGPyrhv7mYnr/JoQhfYVu2X8rdBIznYS
         buxw==
X-Forwarded-Encrypted: i=1; AHgh+Rpw0Rf9TAKs4+epan9LoXTjFK9guEKnu4BgyWI73yK690hiKvVLDQjJSYo57DvWNK4s05/ilsQhYA==@kvack.org
X-Gm-Message-State: AOJu0YyBDGKoIQTk1zs8t3OiHiLpzHiYaSX6HQ4otkSZkgfATfuSIvTf
	If2sBrclBLRd7jiA5EFwLlt/ZM+3JFtIvznGVzKJbVM7REfeIBNe623c
X-Gm-Gg: AfdE7clN+CMO1VCJBUOkgM7PdD8dfoXoXbaKgeRNFthHWClyzdbtKFxaYkDOnY1h+w6
	M6rvgS9koi1J7mwm492qKgJxiunVRRwislg9qwY0k5fn3pP7ILv2FCdUA8pYSVuaci8bq+riXv7
	pLtrmvuVKsv9w9W6ZdYswHZpZQnEu/dVrIJsFf/BojztbUj3YvROPj1eQ1Kvtb+Pdl674MVcFQD
	ANsdzDbxR6drk053jJSJ4wAz5C0E3m3EUHKNpiO2A66RI7qKAMVOnQV52Kd2cc3es9q9PHZiK4u
	kQNyC94VUHlKIH5gGYG7cS6Ug6gv4AtHC7WE/7kzPQjxey385XQ0WWZgVPteCteOKvIaQgoEESZ
	5Th6pVnNVsS0+LFTAZdWDcdivE171OWtrsRSq0h9lspb2PqC+1hxBIK7b0GoWQIYaT87R0/xzBh
	6hu06WEeQcOrs=
X-Received: by 2002:a17:90b:1c91:b0:380:534f:58c2 with SMTP id 98e67ed59e1d1-38dc7b81c27mr7444738a91.30.1783934907345;
        Mon, 13 Jul 2026 02:28:27 -0700 (PDT)
Received: from lima-kernel ([104.28.160.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a5564f58csm6293039a91.8.2026.07.13.02.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 02:28:27 -0700 (PDT)
From: Injae Ryou <injaeryou@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Injae Ryou <injaeryou@gmail.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH] selftests/mm: fix on-fault-limit false failure under sudo-rs
Date: Mon, 13 Jul 2026 18:27:00 +0900
Message-ID: <20260713092700.464376-1-injaeryou@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uh3u6pns94o5k1deo9uzizgd34ppogj9
X-Rspamd-Queue-Id: 939B140006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783934908-88260
X-HE-Meta: U2FsdGVkX19QFA6RsBMWZh6KQND0/eZbNgweYPa2bk1avAXiwWhBM72Tgl47kS229BUuwKqfsJpdCPhWhKADbL/PGIUyHpBzYcxciOUTkBQ2cWB/WF2sPr4FJgNz0J8gd6r8bA0nnVd+LWL9uxKfeuWFVcS8cbF7EhCD1ixhnAGXs3NI6bjn55bKrrWa+t7eBH2sO9d6ukux7HBpawP514fNGvmOa7cGn7Z7XaIdFsyQVLhGqPQu83O4ddZqYtBKjgUWZWPFV1AVqDzG+wC8p7BxcfMxZsC3c32lozaH7YVJsS3u5wY972Yq5GcdYnoATvgki5P+x3EpZ6QaUJBNB/10GljXUDbQC4wM30yYRiXU8/99GpD99azNgwz2TEYBCRDTiB7rCkTO5g9ot+FSqXZSQRLFaa1mdhS5gak1kfK5YA/3dmaLn3jeTT8rWX1PCbBWoiV5sk7Xu/h1i/PjvXj7epU0GugQVZKQnhhZbXmV7WmY4ttC+HYKLXlcX9xeQN4uo2m2YqWCZcyNnffSUUdQMrJ+36VwYvptPKJ+/Pw+XId3pVdZGTzPjFHpo53VgZTKZGJH0BIrePmNJPXO4hLTo2b5LFQhtMEo9h8pwA/++yW7Dyyx4Q+JCbEyHHX08azK09jOSdNsXppXIti7yL8hA4cZck4vVPw0sJUcDdwhBzWZWVMPIL8Dye/3Ed9XwN/SaAOOxBmoqJtmPKNyIAoqomXCVZFAEuv1EyzoAXGp5uNsLa1DBOTupvUaBAzZX16Qmb+eFKwdcUwCXgHxxgnZ2Mf3pfGRAmzm2PEyniWGgzdARtCsjtcGHkgVD3EtCRo7wPwRFjR934kqIvGBz0B6tZTNvM9cqDARsONMr8r8/Kn56nad9PqFRcl7egSEVkMeWG6TferH65mpxo//ReT/+hiqBIT9SunQl9m6Gs0UTsb8IGy6gTGfAl6cYRrZSxM+yP8dzey+m5J0oXl
 GGTtzRut
 hpWSQoAS3CJ8AVn9mYGI06czZiXxSeVONgIxA0brTME8gFcdY4HmgPkWDzIIz6RZfPO/xenCtrRLYQX0pa+1QzQ7MUNCLAGoyU2481/8ucuBU3FC9ZYc6fP6xczSmdpAIXgVRw5fwyoUp9GrbVYfuTTNJEz4QTo8WMQ90R3b497inqKFVqr3nX8cnxE0X0+yyROQ+ud+TBT4tggDC8wZSOvZjkC1EGJZuvP39Mojp3T5Qq3Lru043Mlc0UtI2usU9al9K+opPRCwS3U17q+CQ0w3W2n9N0im/87nffcvlzRjaZM7ZuuDAGkSLK9/kj642AfSsI3qjXwsqcYp9uqnF6UlEfj9n5xN8Ch2yHT6H6/xDD8J5AHvdxmyq0vtIrBo4gOM3Iy84rB6PxIR4vC7yAbKYAyzSCtRsVS6g5zTnedyy1X0KPpCEAaFyLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh runs on-fault-limit as the nobody user via
"sudo -u nobody ./on-fault-limit", guarded by a check that nobody
can access the binary ("sudo -u nobody ls ./on-fault-limit").

The guard resolves the relative path from the inherited working
directory, which only requires search permission on the test
directory itself. Classic sudo passes the relative path through to
execve() the same way, so the two agree. However, sudo-rs (the
default sudo implementation since Ubuntu 25.10) canonicalizes the
command to an absolute path before executing it, which requires
search permission on every ancestor directory. When the kernel tree
lives under a private home directory (mode 0750, the Ubuntu default
for new users since 21.04), the guard passes but the execution fails
with "command not found", and the test is reported as a false FAIL:

  # running sudo -u nobody ./on-fault-limit
  sudo: './on-fault-limit': command not found
  # [FAIL]

Wrap the command in "sh -c" so that sudo only resolves the shell
binary, and the relative path is resolved by nobody's shell from the
inherited working directory, matching what the guard checks. This is
the only "sudo -u nobody" invocation in the script; uid, cwd,
rlimits (including RLIMIT_MEMLOCK, which this test exercises) and
the exit status are unchanged through sh.

Verified on Ubuntu 26.04 (sudo-rs 0.2.13): the test now runs and
passes instead of failing. Verified on Ubuntu 24.04 (sudo 1.9.15p5):
behavior is unchanged.

Fixes: 5d2146a3354f ("selftests/mm: skip mlock tests if nobody user can't read it")
Cc: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Injae Ryou <injaeryou@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a60b9f9f16e..687d115e3bd 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -302,7 +302,7 @@ CATEGORY="compaction" run_test ./compaction_test
 
 if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
-	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+	CATEGORY="mlock" run_test sudo -u nobody sh -c ./on-fault-limit
 else
 	echo "# SKIP ./on-fault-limit"
 fi
-- 
2.53.0


