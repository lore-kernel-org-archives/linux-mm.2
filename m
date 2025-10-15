Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA453CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2228E000C; Wed, 15 Oct 2025 01:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C1C8E0003; Wed, 15 Oct 2025 01:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C1A8E000C; Wed, 15 Oct 2025 01:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 10E7C8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:31:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4B091A0AFA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:26 +0000 (UTC)
X-FDA: 83999225772.12.539D72B
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id F3A1914000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BQ4Opt0u;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760506285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ks0TQAnc2WQfMRFVV4u+78N4hNnTBxLoURgsapwl7yY=;
	b=XQMXx6p0XOV6Uba2HBzcIxUH1whoWLSQ35nuBxeij9N9nnk41SgJMQJlxvOPMj/dRZAdcX
	4zvwqwsr/RBlx4zOsKJLXKr9n6mae7f2PJtiVTjR9+7YVoxd9aLJ3FDseHwJDSaYj/w6cH
	ca/I2sv6zXPj1YkFpu4jDVdpp+pb/Co=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BQ4Opt0u;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760506285; a=rsa-sha256;
	cv=none;
	b=ozT5jx0xNRqLMcuffOhR0NbyuKK6Dss4QPLbM621TYiZgdrEqZIe5qEd7rmTjHbW522jYY
	Q9l6vYvqZR94FrlB3LAFTWqjoTle6oPibkagWDsV1UaNh3C4PoseBKaohLIJn4RfgR521g
	kI23scBCmV4MrcM7jpv8y0TsFe99eT4=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-879b99b7ca8so93811676d6.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760506284; x=1761111084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ks0TQAnc2WQfMRFVV4u+78N4hNnTBxLoURgsapwl7yY=;
        b=BQ4Opt0ugGLzoE9F5RtQ2vsuRVpSmgilf/dTK3OYu/NTFrfHcowhifJvoUq+ml58CR
         p9Zr6NLk0OFSSGOAsCjYlBw+5XY02SDWY5rqpIjklPN9Fxaj3APDdorRhZl4ewIVxlbd
         R5E8wD5CKrzBWJVZ1qi4S3Iy4zDEMGWhd1vu4lrQaVY+OsAlt3j+YLAfZ8SBhPfPnLOC
         +WJl1+aq48tCDhYow8iTKpPnyeYLbr10V1Y++GG6TRTFQgPEbkSd0MzlwAiL7TrUTZlL
         JYyWzwSALsRfkLQ8buBZFEKJOcRtc6AoSET8d5KbO3bD5X0aam9kaDKDXn6YzJ6+J1za
         Hedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760506284; x=1761111084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ks0TQAnc2WQfMRFVV4u+78N4hNnTBxLoURgsapwl7yY=;
        b=JEKXGilBo7ea8F0+YDhWhuwnDGK/lKh3FZT/UJz5cmHnU2moL518RR9ULyE4xI/VsO
         c3XU1KqucRv5YD49dfo09bmSVOy1r4+KveavfahCr+hADL9m6BDwfg3y7wk7eBfEWmnO
         PTH29pKFLbgP/1WmpLaCsesgASYNWa7N7f38EgVvdKqvPpeAt/xPSkJf+y4JIoNVeJms
         KPXrsxl3ubp+aDHJ8cwa0CTQIr/0fKohP9ck7prbaoOJeNCzgr+L0mMlCu34vTOa1z3f
         Rl8w9ZHkq3+tOM00cgilxCZaZ377yvUAyeCI7RXHHKq9jTabj1HTmuE5K3LAwcHSjpex
         a+XA==
X-Forwarded-Encrypted: i=1; AJvYcCXjJGJIocsbXzdBo43yU+pTJY2cgKiQo2HvF+gnZ364lmHf3QVrOVJsyrqeSaAICRWZ0vPGbNISLQ==@kvack.org
X-Gm-Message-State: AOJu0YweYRGYd9P1HbHzK1lG/HNNPncPxkNntb+3K3cMc2lm1okcufQm
	IHKtevrW5GcPk9FgZ+lo0K/Qw/WgELGG8Jfzt01NSERDyfYXT80kfAT4YDat12sdIxw=
X-Gm-Gg: ASbGncsJ69RM2Jj5oapfORJfcqH5CfrvQpiPHxj8lphg9bXv+R+MzndTAfzkWTN94rl
	1YTDpcKHFaDpmYy8t5adfMNlRVIVTsANV673Pg6yQ4QtsZcOkesi+eOYFAgIhBL+o98YWAiJt8o
	s9K6/SZ01+OrR2fsRv2mkk4yxUM/oFjKBT31TMPXwSiIo+RLRKm+FDzfBDaU5FnOgIuadaCns0H
	ffJPCTKY9ma9+cDqFFEXIs/qx0JA4/bKlcMPGeFIpCAz80qGw1Ww3mkfXC4Gow863yDlrE0e4gh
	U6t9t/TUw+tswIhxrIV/LhNg+aq1bTDZe1XDn5v74Tg1no5d90BzFqCLTtZsfcngPwRchePlABN
	LV25e4gr7gvBDMTF59RyMxmNc5B4rF+j79WDPcMRD5f0EVpNSxObim0he3qY6PPhHkekosildlH
	Zc40dd3IHEHTw0gy6cNpw2PYZDnTZD1VSnIIktCOhGJYqEo1LspR7pUh96C9M=
X-Google-Smtp-Source: AGHT+IFFjRfzxETp9modlQvk46r/Xd97DWmwBK2yN4Skk/yXeTLEsqZNHWkGihrbcaSsTXWHRc93BQ==
X-Received: by 2002:a05:622a:1a9d:b0:4e3:25d7:57d4 with SMTP id d75a77b69052e-4e6ead754ebmr314014531cf.80.1760506283865;
        Tue, 14 Oct 2025 22:31:23 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881d01f5asm12572661cf.27.2025.10.14.22.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 22:31:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH 0/2] KHO: Fix metadata allocation in scratch area
Date: Wed, 15 Oct 2025 01:31:19 -0400
Message-ID: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zcbm11rqwup8hspuqn1saxz65oc4f5ir
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3A1914000A
X-HE-Tag: 1760506284-169816
X-HE-Meta: U2FsdGVkX19yTdNBV5VO9hEGATdcU9ENjmxOCLPdbLWZQJBBnM80ZQu2eQ/QN+9rqPXWH6yCU5aZluO0bHs1oe0Oi245KchOBbp3LnCNsn+xvTZN607DLjeM/9hL+H7j3ru8uZvb6per9Q9jfH83XRDvWbS3mTv71N8RaXUkYh5+AEH+1HEDo7R5tboq6+0dC4igAnxIiMCrwkEkhUeeIbN1xkCEp5PhqtvzoFNlVf6K+Iq5BtlBfDyemtx//C4IbDCTOLPQDzunfxNd8kZPgtI/azXZITXWVB8BqNsAvZ4CvdFdO0eT2L6zVHRQECvM2b/RkQGQMj7IQrqa/oL8ksuZ6VUyLP8nvfychF8NzohAI+LXIXceT+LemSzYaAw8OC7i/a/0FiD9iUAn+agef0+9G/Jt17CGTfCOU/2iPfxzJpr29uUa6pFSciog/1/UasLw2ZbeIWchAVcGn1G76yWC+uQDtIHKfh+91rNI7CZne4UawnRehW/dd4f6Zx/TE9NX4FTtEHsIHg16C16OjAUZYOn5IcoHcegowMREJmjleVvggLrn8qMsEflBKqDdGZ1vvnv4/fy7xbik/50EdqvwoAydlqr4GZ72A6bHqQt5iacVvMWcg93+99riQ2ra4xq6RQeonMV20PmLDblTpK3QZRqwR3x1RE3kFEW3AJkNF6bcMHJ4XQqHW3iNJb8JGFPjE50x85YoXL4jjJAtlG2Mwn9RVAqrYUxWZiEqkRaH5WeHaOxnv8S+9AD75ZW9U6w9eXSw41Nm/eA3nJ1VyijexIgqFBxGZZl8rftm3dPA5aqre58PL6aQmGKsPmtfNcPraIl/wO2T/6BFGL/bjJY74dpa/Phuqqmz+8HNMZITcceVTCrdqRd/eOlUc527dgqYDlnN7icxQDu2/hh9AvLAyfEUBySqUhv/O00Vr2MfiGoahNtElSPHrliViyWL2U1THuRMzMiD3ks0Z11
 os+1Uvq0
 DKIodkELElRfF6CB8VX29WaI/lBjY9RRXX8dNExUGBpjJpre2ap9AMAZk2g5J+l2xYYcv5yEk9XO2XMBdGKh02/vhyIUozpfO0EihKz9cCXfPEg4d1Z7VHguyyi3Y1CvQc0UOCBxIvcMpyWsFmn4UbCZvJPbXMEptCly8SoCOojyHjxs91dowTYroriSewh7ZPuK3/7Mcunjbe11cJ+SurBGFcU/famgLc+9hV87AZaZTaGgmWYRi7xsXixqLM+q3unwK8wnD3UzZbhcdVBvg13k286MIatuzhNR+ue1Vyv+HSqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a memory corruption bug in KHO that occurs when KFENCE
is enabled.

The root cause is that KHO metadata, allocated via kzalloc(), can be
randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
early memblock allocator is restricted to a "scratch area". This forces
the KFENCE pool to be allocated within this scratch area, creating a
conflict. If KHO metadata is subsequently placed in this pool, it gets
corrupted during the next kexec operation.

The series is structured in two parts:
Patch 1/2 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
that adds checks to detect and fail any operation that attempts to place
KHO metadata or preserved memory within the scratch area. This serves as
a validation and diagnostic tool to confirm the problem without
affecting production builds.

Patch 2/2 provides the fix by modifying KHO to allocate its metadata
directly from the buddy allocator instead of SLUB. This bypasses the
KFENCE interception entirely.

Pasha Tatashin (2):
  liveupdate: kho: warn and fail on metadata or preserved memory in
    scratch area
  liveupdate: kho: allocate metadata directly from the buddy allocator

 kernel/liveupdate/Kconfig                   | 15 ++++++
 kernel/liveupdate/kexec_handover.c          | 51 ++++++++++++++++-----
 kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++
 kernel/liveupdate/kexec_handover_internal.h |  9 ++++
 4 files changed, 81 insertions(+), 12 deletions(-)


base-commit: 0b2f041c47acb45db82b4e847af6e17eb66cd32d
-- 
2.51.0.788.g6d19910ace-goog


