Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF5DCCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B258E000F; Tue,  7 Oct 2025 08:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2F18E0005; Tue,  7 Oct 2025 08:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAAA8E000F; Tue,  7 Oct 2025 08:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26E6F8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA58C1A0135
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:42 +0000 (UTC)
X-FDA: 83971226724.15.C7D13CA
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CF5320002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cQ7bFHfO;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LFRKWTVlTuhPzrNfR0Xp0MHmBgacGLDW+osVwfP54fY=;
	b=QSF5c09jya46rOrSxBQ0TCmKBoYd/KYBfNlVzWi/0dIep8QEtJpFvi+PlZLn/P/g8lic4a
	UHV8jkFyFPaH2Gf/yxzqO5s10Nhf5vwE8SArmcCz0IoL0lcrRS91liRfC2O2GTQhEFvezQ
	ZH5n9cjHAz5Or1f/y0oI0fGO+NTLlTs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cQ7bFHfO;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839641; a=rsa-sha256;
	cv=none;
	b=LOANRhSLuwJ8+BsXKhWYhCdH38jLttgdeIXfXjlkqE1i9iAd9yKJQD0VFbAnbq9gYOez3O
	YtZBfxqal2OYAm8wwtK2mizf5y/rouSoylhTr4nWPHtnpWGzyA2UxTqhmqFach3eu3YjnA
	toCqJvTi4mYYRIbFL4LEHJbm/GfaEGQ=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso8183270e87.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839639; x=1760444439; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LFRKWTVlTuhPzrNfR0Xp0MHmBgacGLDW+osVwfP54fY=;
        b=cQ7bFHfOt4iFxmIXAl0XbBCI520sUH7AFuP1Z1aogVdfAPYrggU4t2qwTi6vZ09LaF
         qmRY9IOLmAr9LwYXM7c6YDCDd3mNNA1iYWmWkByqAcJtOVWj2U4om8oynRYZVz2L0Tch
         egNY5B3FhDQ5KJqqouPIbSTfcdQh1Vu0K651+M9jsLOUIpX8lHqsQwT55jFIVB3mhXyV
         ycm49JAV/UyR8tc2orjDfsvgrAivliRqOrMM3cHs79am3yR+9J3B2Mb90HQcoXf4b9tg
         huzNrORHyh57iPnqXew2JZQnVAeZh6zGpsk27E//Z9ENG6wfbIBZnQs9T1qXIccX2TqV
         dW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839639; x=1760444439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFRKWTVlTuhPzrNfR0Xp0MHmBgacGLDW+osVwfP54fY=;
        b=EpN6Hf8dWtT5i9kOvdNTIJH4KxTWHP/p3jgf18SU8SmDZoyU3eWLX5wsNoRGvPJThk
         STLZf9vXSUaFPB8GxoLih9fPcwFvibqWuwbK4MWSG/2SfeGIktFTT7E74HyPQqzGzaWq
         4bczkRK3j3EfS9K8xfQ8EyA2HY6hkENpfwKgrCFWWkjICF9Ox50s0nUf2GZ4pNd1n7uD
         FSTEk1osGbEfsrmN6d7b3JHfoorIMcBJ4TeYMQtzfhvzetK2PKpl90pp8rG3lfPI78uz
         ruoblWuvo8q73wB6jXP88D09gyh28sNc7KGpmyM2xjMUM0n5XHF0f6Ox6gWhWyWi8ePa
         UNtg==
X-Gm-Message-State: AOJu0Yzvo+Fdrvo0sl2UezqFp0IzElTFfTaSaLrze7i8ajqugMFyKgC5
	zlxLGADuFMZI3FOfkmsei0lI2uAfcJr8Tsnk0ZhXQphBj0LWu0NXA5xlYQWjY+2g
X-Gm-Gg: ASbGnctErgBf3Atb4MYkeoBW+O9DnAoQQdT/jkvseSfKa+dxxmOToNSQHsoy+/hPrvi
	/BxZXHtz7CCPGZpZ5JPmei/yQKvdznVWuq659mZGPIs0WBoS9UXFvcxy/N0onxigk//zMcYD390
	Z5mBrjFdIFOa77U/dr2CiUZdce955gZqxniv2omApVHt8O68/TYDjHZOqJcPeobp+FcAeDcMDSi
	S9d6HLEEU2FptrD0PjQMZrc0XN4Zj1nUamNxOJNnIjRPe8ZWO0Qg7V5IFTPeUTncHWwaNd8qeQB
	7gOZeKruqV/gYykArlq6VktNiuIinTZSgLt/JnFdP9Co+7m9RqKmrQxoz5uVyU9tZOXP627nNJC
	YQG1oWs9dNItqVYHE5qe3waAoObEhHJjRcAT4nmSF
X-Google-Smtp-Source: AGHT+IFwtSa+eQfehlnRS+uCd0yLNJFhqNO8SZB3I1D1kA7dISH062qlxuqUPKXkOnZ37xH5DrcuUw==
X-Received: by 2002:a05:6512:b29:b0:55f:486b:7e5b with SMTP id 2adb3069b0e04-58cbba02367mr5221127e87.41.1759839638991;
        Tue, 07 Oct 2025 05:20:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:37 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v4 00/10] __vmalloc()/kvmalloc() and no-block support(v4)
Date: Tue,  7 Oct 2025 14:20:25 +0200
Message-ID: <20251007122035.56347-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CF5320002
X-Stat-Signature: bmg1371akgn9yitz6f446x1jhbyhe3rn
X-Rspam-User: 
X-HE-Tag: 1759839640-122172
X-HE-Meta: U2FsdGVkX1/r7BSQMpbp2f9/ANGGh9m+KyaA77lv1X3a31Tp/VCxC3LWzRt3yjyCMb3rHayR0Kj7FDmcfMCi3ytRWlb6SFCvhkB0VhpbpOFKYYDdLobT21ycnAuCdDVEmM/2LIX+72dLq3jX1SG4QWdKEjR0hxP12+8Ro3uSoAKVDXzBS8H8cxBjyeTIS+b38otHCXh5X2VAbDndGXTzbabXA/Ag/BpzNuWoKCQGzNGxzsiNrQo+VqpBBURso0Id0QrPqsXr3PEsXqkNWEJUNnhKX5J8cL5d26RFhcg7OggoKRgQ+lzE6WIltfN5yJlWxi7KgN8Yrt7zb1x+V4p51BRlvXZVzaJXwINPXMhOISMOFQnvCQvTOPzyUoQOGo0JoCQVDgmPYpvnzFggl3p/U4AcS15vnIbzU19TpM0p5lpH2uaAg8piGYThg1DakkK0QJ0jYH/k9ZPnKTkKxGd31PTyyYHn26cfgzuh2GuAdUxLgoOd6Co2/cdmwst6QRvYoJNkLuFGT16ACI9xb4ZjC0KfaU+KH3rCK9ztWc3+Ibmo80TG3ryOvGUsqCNW05kLWu9DBkVOTcFlmbSjkMOyq/guX3rE6czN6jN8CTT+zbqtRuZwfG3ujDNZBSGp0Y4f0s8Vhp0uIkb+HH3PYtn1FzdiRsukrPAlh2WQvzkcxhXQVFcj5ya0ZAcTjmphnb8itA2rapDMpf+qaHh/HRZKkWZWcDtD0smsH7rm/JPIEqJNo/LjA06Yap79kmmuIknFRRtmK44oWvO2Z320QBUrMc6233ZwMVTJhVXYfSVXEt9TgAjPSt9euSKKoJ36AAYDKpnKIhlqkfN9Oi6VQv/U74QIOlFnubGBNtQg/We7vkvBWXF6RJRI7bfvLb3M4d7EctQWmZWWxA4YA4bZxY/iRvXao1pOcJDyv5bQXmK25N3+QlXxaHzOLPw9UytkMTDvS00SuWbXpxMpW6un9Yp
 IMDgVYJR
 8tsFyQez4gjQv2tp8gZcG4n8c3XT5el7Pf9r03hqFboyY5cN/70BYlLC8DYsBH7vilCMvLdUEZw7DS8ff+8Q26m+ef+Hvq5kimJrunyydAms1ocj8dt/CLJUUDnrvVpbimiUWawKM3VC/ywM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v4. It is based on the next-20250929 branch. I am pretty done
with it, if no objections, appreciate if it is taken.

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
https://lkml.org/lkml/2025/8/7/332
https://lore.kernel.org/all/20251001192647.195204-1-urezki@gmail.com/

v3 -> v4:
 - collected Acked-by/Reviewed-by tags;
 - Fixed "Warning: mm/vmalloc.c:3889 bad line:" reported by robot.

Uladzislau Rezki (Sony) (10):
  lib/test_vmalloc: add no_block_alloc_test case
  lib/test_vmalloc: Remove xfail condition check
  mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
  mm/vmalloc: Defer freeing partly initialized vm_struct
  mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
  mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
  kmsan: Remove hard-coded GFP_KERNEL flags
  mm: Skip might_alloc() warnings when PF_MEMALLOC is set
  mm/vmalloc: Update __vmalloc_node_range() documentation
  mm: kvmalloc: Add non-blocking support for vmalloc

 include/linux/kmsan.h    |   6 +-
 include/linux/sched/mm.h |   3 +
 include/linux/vmalloc.h  |   8 +-
 lib/test_vmalloc.c       |  28 ++++++-
 mm/internal.h            |   4 +-
 mm/kasan/shadow.c        |  12 +--
 mm/kmsan/shadow.c        |   6 +-
 mm/percpu-vm.c           |   2 +-
 mm/slub.c                |  19 +++--
 mm/vmalloc.c             | 153 ++++++++++++++++++++++++++++++---------
 10 files changed, 179 insertions(+), 62 deletions(-)

-- 
2.47.3


