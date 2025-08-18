Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9B6CA0EC6
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CFE8E002E; Mon, 18 Aug 2025 06:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425058E0007; Mon, 18 Aug 2025 06:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362588E002E; Mon, 18 Aug 2025 06:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224F88E0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:43:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDCF213916D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:42:59 +0000 (UTC)
X-FDA: 83789540478.27.A584323
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id E6DB61A0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:42:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TWB7ZqA/";
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755513778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JE4IP0xudja5BlNOujM7gUm5gN03tzBb6HO3+FrlBKg=;
	b=VvQW9TRGV7OcIffbJ37Ot/16xzhqjarjYx8m/DQs2DbIJDKGlMBR8/AmELexxG6NLoMxIh
	wQ8clt9BzODKJ/LUJuH0sPSeBLPZ/Eo6A9vqFRJUC+JRd4oLtloooq22tIBGmrrxX6nIdF
	6EnKJLPpxSZS0RmjcpAH94sRuy9B53g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TWB7ZqA/";
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755513778; a=rsa-sha256;
	cv=none;
	b=ZTfkxvwXzReNi9BPEW4s3dUxvFmEoSZQ4Xx+85Vj+Id5RVy0X5z/J65wYdIYzuXG4YSfww
	2zw4KqfuI5zs7ZekifTTEDlZk5qgjzy/MR3zdgmxuPgDcW6+lQB1I91eRHFLPZ9J0c4TUG
	ZY6/GbM4D2YCox3xXHc8oGMWbBlm/AI=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3bea24519c0so442804f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755513776; x=1756118576; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JE4IP0xudja5BlNOujM7gUm5gN03tzBb6HO3+FrlBKg=;
        b=TWB7ZqA/oTpr1bJlqgxAPwuzf08CuIxf1p8FzEgq/EjdNyiQfgJ8jS0dDqBiveNYvX
         JsOUM1H6GPIKfzX9exFtWZg4vnebiPwpRDqlztXDr/DwOqc8XwE6RBPskOkXOc5CJJj8
         eV4RU4wiWYwso0F+PhicGD8W6QMaLWye6fRGqmVK49f4QTc66pkwq9tYEcTl7cVQJweL
         G94yRxkH/1Fu9cKKDCKVSg5QxX+/gKzX37xsHmqpDiABeoHCP8T7ykqWmqyI1Vftq6yA
         Abi0zeGzTq4xzpqYOizFoThhZn+Fumqb+zs88BN7oBRsL+8Ffy1yQJLPtYBi3jQOUCGH
         iRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755513776; x=1756118576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JE4IP0xudja5BlNOujM7gUm5gN03tzBb6HO3+FrlBKg=;
        b=vmi8kjVSyUzyChbo+UdWLo5nFe4SjLdqpPUsrKt8zZSz9cRJBPQ9k+6f5V93LSHmIY
         beQsA7rkzQn0zzhTtde6ZfyUXN6KJnNuYOPR3CxWLrw3Pfi+PePRae69AO/xnSPn2U30
         yWcPKXnyb6zTGpbU7cIjYUx5FV21Mvh4BQmjBxA4x69VSnNgvqzoGPXMz/Af6kd5+i+4
         2/is2/YBxvJQQifgSgqzhrQwCQiXjGMW7jPG3Q+h7CqdSBcvxE2xnTKKZe2nd5pOkEYw
         eUksM+PkBZkUJWQxwXDHik8GKFT9BWxiazXaES65cEFrujT3y2frYKAKjsiiuq08ntEp
         h0ig==
X-Forwarded-Encrypted: i=1; AJvYcCUlve2vsJtcyj7nNEHcZXnd1R8JlpiHGF97NPgUjYQRn7zyU6SmsNzaIz2iGgZhPvZmZT7hQ7hXlg==@kvack.org
X-Gm-Message-State: AOJu0YyYX4+S6lc6etYwEA85JSY8Jw1OFoHc7PsHSuHPHsVfKaGlfUVu
	Iriy78lehTCXXUzEF5M01ykQpuSeJJQOsCTmkXwRShiIcbWpWi0JWpIv
X-Gm-Gg: ASbGncvS/MmvStWKdTM4PDytOUuAICLuoaSR9350opWmIseE9wJQvyWFhect5YKeu6y
	GZSYRzJwpmnPogAsI9iE1+3d6lybEBBTVQ6bz0OoiYIv2NKNjo/C26zhzaTJGaVvmmIpWOX9KRk
	buiyQzbQbJcPIq91d9OGQIXfzpgjeaCtWicPHMHK+ERdcwBgfzk6Je39M/x6z78tlICH3+f4t16
	pTsZ9hxdBJ+ucVQZ7OfQxVkBG9LNe1itC2qX9OrCRXxx6NwtAlCrYheAj0VTjWbsaUyAZV7OOgC
	IE7NdHDUGPAFr69HbUdDwM+dGAaNkMzAaXHRRN98verjtYSN65U+9qR7XpUZuIpk1zZin/2AZLt
	oYackT+duxQNO7XveGFNiOZzDJ6hFTaMZhGXJXtZYR82e89Jyl6x1nncB5Y6uG/e0k7BWoon313
	J1gDPgIw==
X-Google-Smtp-Source: AGHT+IFKP9QZ1thEf493w6nDqLQbZYUy0PPDE6aSEoN/rO80+JpNoZTVzO4HbHsDTllsrSB3lskQsQ==
X-Received: by 2002:a05:6000:2287:b0:3b8:d25e:f480 with SMTP id ffacd0b85a97d-3bb4d619c81mr9565589f8f.29.1755513776385;
        Mon, 18 Aug 2025 03:42:56 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:7223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb680798fasm12417323f8f.52.2025.08.18.03.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 03:42:55 -0700 (PDT)
Message-ID: <3dca2de4-9a6a-4efe-a86c-83f9509831fc@gmail.com>
Date: Mon, 18 Aug 2025 11:42:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-8-usamaarif642@gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250815135549.130506-8-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E6DB61A0003
X-Stat-Signature: dptr69fpg7i3yzp9brrgyujjda7o8ekb
X-Rspam-User: 
X-HE-Tag: 1755513777-3609
X-HE-Meta: U2FsdGVkX1+sh87btUtuwfIXCMRXYvkXNcbzgnwSPQqIsfdGGAk742ffdKVgC7yd8hVr2vDV3IYfq5m8ijySX3cP95AAlIDBrleqxnHaSp+NPRWqzKUsKorako83xkr4C9ZVG3JfHlPl5ZsBy0sCLu6lOxRnix5FDsx3/Me0J2TlgA8UioOneV61r0A4B55/TAwDUllVgfviz/VKTeWy+++iNmTC977wjtTCVJ2shbdCFjdfEiCV/vrK/4Bo1Dzzw9USN20qLpUGTanTRycKuoXLHI/pvcu9V+oLlhYguADsfbfuAwGxJjc4iha6wkTkoUuVYIPVx/YbPelzpvCWDT6vfUywvLvOJgdK2NnDUJ90QM+hjY1C2Sd4hX6ThJFsoCqpaRwPY1S+R/O596OX+Uog0n/N2O813ZRWqhWRaB18TZp7E5iMb2HjiWMEGi/b44NBzDlc9jRc/MbjbtQo2WHvDltWUQwqyUzfEeIM4phoQVG+zdqACPcYYDzDLCXvPbZ6FLJmYsnFeIAhes1Zr41mTimt6YkGtkUlco0zQ/4BhaEbZumXrzt5QvjPKmjwxf3JqbGzb7tf9PxPRsRK/H26AcqGj8DNZ+AaBNpZbsHzXeZ403tMqxvlvgLqk+X0us/Gbxnjs0VGMXKwpPdkukBOzk3kf05kWP2lfk8kdnTUdAGqdUiRy/kfCj9ffn1xnutEhWkfrm/bzQ+xXiQDnuASz9dRoYf7dCJtgxhkMRrjA2XGNRQKgcUuqeAcksObSRJKcclElmrPUEYYRNE1cc5I4tJrC9vzwpUZJnIILMoZfSvW0MOnTk3DBkafhPF5YrX1Cxvg74M8qyiS02bSb5Y07s+hLYvrAa8a1+CdUd82yYIMh6bXAUBZ06CbAKy38kvMs2rw+yTLuP/HZsoHKgNjQDxk6ChiEWCMmaPKp599HvTtsd508cdhy+aeiaQhuXg2c4prgEXT4jFOF1z
 7m29z4ef
 OyjBQv05j6gcZT948FG9gvA4/C2uGbt1rYODX24cG5DkKytxNfmvFN+n+24DWOKPG3O5hxmfmB6FSX7Ah/1v+gKqWGFulSw5GpzT7s0NwAMmjrOTjoY9k8W2MGdnbfb0P7nKN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/08/2025 14:54, Usama Arif wrote:
> The test will set the global system THP setting to never, madvise
> or always depending on the fixture variant and the 2M setting to
> inherit before it starts (and reset to original at teardown).
> The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
> be made with PR_THP_DISABLE_EXCEPT_ADVISED and skip if it fails.
> 
> This tests if the process can:
> - successfully get the policy to disable THPs expect for madvise.
> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>   is madvise/always and only with MADV_COLLAPSE if the global policy is
>   never.
> - successfully reset the policy of the process.
> - after reset, only get hugepages with:
>   - MADV_COLLAPSE when policy is set to never.
>   - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>   - always when policy is set to "always".
> - never get a THP with MADV_NOHUGEPAGE.
> - repeat the above tests in a forked process to make sure  the policy is
>   carried across forks.
> 
> Test results:
> ./prctl_thp_disable
> TAP version 13
> 1..12
> ok 1 prctl_thp_disable_completely.never.nofork
> ok 2 prctl_thp_disable_completely.never.fork
> ok 3 prctl_thp_disable_completely.madvise.nofork
> ok 4 prctl_thp_disable_completely.madvise.fork
> ok 5 prctl_thp_disable_completely.always.nofork
> ok 6 prctl_thp_disable_completely.always.fork
> ok 7 prctl_thp_disable_except_madvise.never.nofork
> ok 8 prctl_thp_disable_except_madvise.never.fork
> ok 9 prctl_thp_disable_except_madvise.madvise.nofork
> ok 10 prctl_thp_disable_except_madvise.madvise.fork
> ok 11 prctl_thp_disable_except_madvise.always.nofork
> ok 12 prctl_thp_disable_except_madvise.always.fork
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---


Andrew could you please help apply the below fixlet on top of this patch?

Thanks!

From 85908068c15fee0b9e5796fbc552e38239c2765a Mon Sep 17 00:00:00 2001
From: Usama Arif <usamaarif642@gmail.com>
Date: Mon, 18 Aug 2025 11:37:10 +0100
Subject: [PATCH 4/4] [fixlet] selftests: prctl: return after executing test in
 child process

The next step after executing the test is a wait, but there is
nothing to wait for in the child, so just return.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/prctl_thp_disable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 21d181ab599a2..feb711dca3a1d 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -273,9 +273,11 @@ TEST_F(prctl_thp_disable_except_madvise, fork)
 	pid = fork();
 	ASSERT_GE(pid, 0);
 
-	if (!pid)
+	if (!pid) {
 		prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize,
 						      variant->thp_policy);
+		return;
+	}
 
 	wait(&ret);
 	if (WIFEXITED(ret))
-- 
2.47.3



