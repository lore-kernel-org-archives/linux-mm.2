Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F00C5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6FB6B0089; Fri, 20 Feb 2026 18:54:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB20D6B008A; Fri, 20 Feb 2026 18:54:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35B56B008C; Fri, 20 Feb 2026 18:54:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4146B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:54:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 531AD140347
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:47 +0000 (UTC)
X-FDA: 84466492614.10.8315CCA
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98C09100003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=seCl7CPI;
	spf=pass (imf05.hostedemail.com: domain of 3RPSYaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3RPSYaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771631685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsOcE+q9g9Rn3X6/odlnCkM6qqA9vgkvaxtReZc0KH0=;
	b=7oCvYxu9TZQREtfhW86lIODzVtxGJxvA/by2qKKbax4fAQ8sSig3MWVT08AxJmtjZ/LBfP
	bt7+GArXIZ5x6PaklX5iBga3CT4aixvkKkeyM3tj4SAFBLulTWj0WJLKgrmsYeVJ6zCBRS
	9VQgK6Dnfy7qXqix3YWeYdDbPtOMQXc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=seCl7CPI;
	spf=pass (imf05.hostedemail.com: domain of 3RPSYaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3RPSYaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771631685; a=rsa-sha256;
	cv=none;
	b=5W6Ba8bpvHeQByu6OCmDjYEsZdYnatphp3MTKjaeEqm3ecNgtrfWP994P31FIq5+m+s8UC
	mFvISbDGe3IQTDCMOg5p1tyR863X3CjpsyTYijoSSrJSAUPi4Ahwykj6ITS/dvP4Eu6o3u
	A2B7uvKnavTr14XNz08lUpgJ5+Hhqww=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c709551ec08so13784218a12.3
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631684; x=1772236484; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AsOcE+q9g9Rn3X6/odlnCkM6qqA9vgkvaxtReZc0KH0=;
        b=seCl7CPIMpUiAXqsx6BVDZLh21HWYwsAK1xKqBSIjgKXSwa10DpSwnJ4qkuUR5EUPY
         e9rgsfl8vxw3c5P9CnVuPnav2DoaphHypAsAQgy2bqx+KQvFzoEmIMvOem8DP1O2X0N3
         kLJa+yDCCh4iCOws8D9iI/YgtSF6qiuCc7un+LOjjXh6AqLeypu3/uS+RDEuW5N2mXEL
         Kp7tDi91B8oib4a7PVDcqsBkYKVvCcwXldGH7RVtKczM0mh3q1VBjZHL+Yl15DTPvwbH
         mdG2++xe8wF0dilvrWk0p49H9/u8XwpcqiTFazxOM+9Uw4k0JeVq+Sb4Fe0Af9DYK1SK
         ZRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631684; x=1772236484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AsOcE+q9g9Rn3X6/odlnCkM6qqA9vgkvaxtReZc0KH0=;
        b=VOh9IZHeo1e4w09o3z1tewTHYYidaAcrcC6eoiJ0fegl2Jsca9OTENv5mNQBGCCjra
         9YkltsfGXkYMktdUcPTJAmPZ3ItMJq12cwEgEYzwjJSiInR/YDfFEEVKASVuPacZNgAn
         7EXWOHszlbQ+iDQfJ/y5qtesze1jyq3r5ZJytUvuoPnLdRNPLPtO6hlq/3W/NICgVEFM
         a5L+WkGOvkHWx5EDqTmXMoR7kFtckDMlgYcQQCxc+653Sw6k7aYk/bP02N2WlCbI5pL4
         ZMCBxUJ88OYuRoi4Iv21FH2mUI7PQDdNTQAEiEpZ5/AYJ//ZGHwb+/UnZ6aPUN1hh37p
         tsYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXqqfxdEzalo7VWCQ7po8J1Bc3kI8tzuIWEUhRS7OIpZwU4tUldafloU4W8IkxWKVZ8b30Gw3ZkA==@kvack.org
X-Gm-Message-State: AOJu0YzhC14yDWVvhIxIhxUQTW8D06M5OoAwwczStNfILaeEvQ3biAPe
	+YS11D+96KGDbPp9hpEqRF1B7YZbOAeCDsrP0RC/r61wz5O48cStMc/cde1FZ+Yd9xqq2rlDy4P
	bJGoGeWwEpnpySubLck5FzuqBvg==
X-Received: from pgig4.prod.google.com ([2002:a63:f404:0:b0:c6e:1b27:7693])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:734d:b0:38c:792:56af with SMTP id adf61e73a8af0-39545dbf3afmr1066001637.2.1771631684094;
 Fri, 20 Feb 2026 15:54:44 -0800 (PST)
Date: Fri, 20 Feb 2026 23:54:35 +0000
In-Reply-To: <cover.1771630983.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771630983.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <455483ca29a3a3042efee0cf3bbd0e2548cbeb1c.1771630983.git.ackerleytng@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Wrap madvise() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: kartikey406@gmail.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 98C09100003
X-Rspamd-Server: rspam02
X-Stat-Signature: 1w7ko3oee3serycfsknisjf9pba5wwn4
X-HE-Tag: 1771631685-290743
X-HE-Meta: U2FsdGVkX1/e2jh4xVrIXqQ02Q9mC7gZHF23pzvrqIkOM6y1UvRR2qfziEVsy0Fx57WXvtwUaKLdMU/BNUjdWk/GYDAK5NyFFyjXjECF19HNqbmtSbpeyHc7ZwqexUiajFHA30P9TBYcLP94ntrB7V/vffhI0PYbb8WDGjLhN19sFPYGhIfzlRcliI98db4ERgkdhTV+v8TcEXc0gAYp7U/RwALBUnY85jfzUOb6+SRaXCaUPN3Q2rEpdlyllZpcpuih+04/udpShcgn1dPQYAtO5poZJ62rpA+x1O/STIzfMde/gaWIaBaRF/JpHU2xVdXlkeue1gxglrDmaR7wMuSOwj+eVVQYdmAnuLXPw9sD03uDIyJ+8piE4oa7UiCCx47IYAJRHCMDQkYzSopOUoToEPhmvzZ8Kp1BW/hrgAdaxb/aN/HoH4FCQ3F8wUGHgO0eO+XrkX2gXjFiKPYyXvPjd3/WTp5GY3WLel7PZBrMqiWVGMplJrl7FjREaisldj4mVbiPHN7pBrJrrr9Dxi0EhIS/jnm+97YorJDaCeVDpbTpggOM1izlkrUI1oDuLbF88Vc4DD0KVsXtDFtWqiz4O+XmqP7iYl4CtU6Sah6bi9WL/iN3kQF3rWY+7r1wP3n5QIvGh7Dolq9oWhqHFN4hiZ8bNap18ZroswRdG/APQHjKzCZ+VxzdsK4TNlpNDk62C4QfcA8sBbKpIWjtnkIBSv8Rw5XBhqIL3UEoY1TDOysHG72a/Ojjo9MuLVTXhiqkUfjYP7Dwbqv41wX+zTBI4JdeIWCfgK5edYKI+UnwQFOE1+0e5EK9A2zYMDG8aFCJpiDyBDn8DRgTdc/SEPEfUFZwGMNJy5vHi2chKW2OaHTIoqx5nqzoGWkPuAAiTg9/e0Ia0MW8KC2pPAOStdeBIt2BL6/SreaAPUiYEQniadh5ylZIrJ9YRF89YkdauvtmUC53OcaldWIX239
 MYAfMS7k
 Ct5hbwMQIzveEh02sXedMS2e8avFMcuV/T6XIRR6+TuLOnuypu4UDVp7G8EquemRrXvaKde0PUDd6iE2s+/KFEeDBafbta4XyNLgZ08DgUi/qAdlZmXFYF7AcCZUoUJO2JckZG0jOi69Dlomm3bcqsjwCUxKa334WNyUWxm4uLkYrqVOPSUOQr4TYqpR1JPV+4vK0GA0BslYVmUXMQMCZJks6p+XWN/t+JL7lV6mCXiFms62RFJYq1pOlQ+DLtuWrO83Y3Gqu371qIYF/DDyqvZfxsu9V80SdogbESVUk2Sz+QtbbkUBCbPQ6ScxDaLAZqm7HhrG5kNCcw0ycS+ZTZH4vxc8I5H70zHfda/eCgiYD+geSYkMxOAPZd5oI6wI26nPwSgtKd0aADkUDeqLzNCcbd2sQwiscDKBJtoBszSR9euuOh8VUFG8bgu3k6gLFNf5IGM6/p7IQFpsTSmMSuC1KYA0AByo85GJYv3zTmlhosmI/x6/TwF24SRqCj3AZMtgzwfrYKsJHMGXyiH3qwX7vdhGl8LKK1yD3kuIpucoZ3XdPs13i5jEJXrZ8Dt+aO6DYqUFURRUu5hhI0aDlDCMezyu0YTrkKLobiqz71y14g0BX0U0sdxDbuqMTYW3uL0iJinlPpM69hwPKxuRUleYzAZS1PLGqveN/saDamFlIJ6gXWrlkh3Pv/VL8Ut6ecOeKNhNO9lAdvACpDW1S6/pmPjM61M5XJ0d+WW2nXqDGJnjKwiTAl9cSpzIA/qkw2WNFVFKs40dmt6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend kvm_syscalls.h to wrap madvise() to assert success. This will be
used in the next patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_syscalls.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index d4e613162bba9..843c9904c46f6 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -77,5 +77,6 @@ __KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
 __KVM_SYSCALL_DEFINE(close, 1, int, fd);
 __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
 __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
+__KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
 
 #endif /* SELFTEST_KVM_SYSCALLS_H */
-- 
2.53.0.345.g96ddfc5eaa-goog


