Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374D0C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432466B00E2; Wed, 12 Aug 2026 07:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2E96B00EC; Wed, 12 Aug 2026 07:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD6D6B00ED; Wed, 12 Aug 2026 07:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08F096B00E2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:12:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 882D91A0324
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:10 +0000 (UTC)
X-FDA: 85092353220.30.7ED2E36
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCEE1140003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eBu/3y/c";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OLpqRHzThXr7YoPCHJa6pbt4R/oii9J/OGrNuRU8D5k=;
	b=PX1gYeBDpptNUrZuqGdvyeEIj/pZ1liqPx7l+alOcs58kmSbtc0rzVLotDg3jsdsMmZ+D6
	9aBFmqR3ue0cRw73H0l7Z7H1HEQ80fXyVlX/KSIY9Y43U7iWZR4zQqYpynbaTQbjdc0Qdw
	16uJ+omy6g9AqpaHvps5JxZYJOSiMiE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eBu/3y/c";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533128;
	b=WDmh+Cd1G5P0605TQ2GdOUyjdvJEA+0HVAYTsqD6CzVmvXz4ExHJvwD3rYFoUZDcuAMzRv
	P4vUeWUVeSskd4qucXMpDKb/faM2bK65EqwLlTuHnTb3o1dgSqz1toKsOOiTjl/3Z9/aq/
	q0xAc/N2S+XCePMDgyZxuGgek2IRLgI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954dff6536so6321635e9.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786533127; x=1787137927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OLpqRHzThXr7YoPCHJa6pbt4R/oii9J/OGrNuRU8D5k=;
        b=eBu/3y/cOaHDmT1oFhajIzDI2yDVdeQACrlncPDTb9JuAb1mOmiNP1LppLkuhR0e+R
         C+QEk/+f5NDV3HX30rWbsxayD5pgtQw66+ceX1EO79CGdKZV19bW2a5J9XiMPoIhNCJs
         9ihAQSrOgdtH0X0PDu//7S3b/yx3rCO0ltg5HYAwgM9tcIaHktQLzfJHjpqCjuC+vQ/i
         TxQ3TdmI40FZcttaYsUyh5+KtZPR0z2BeBVLMF7AzwbL8C58/P1IIJ1Q67Mm2tEOJL4e
         6PaZAXjGD8BKzTtwFD6zys1C7g+BtYY4ZOMgtK7DCH9t+fVid86rgzFEQAyodJxIrbDy
         B34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786533127; x=1787137927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OLpqRHzThXr7YoPCHJa6pbt4R/oii9J/OGrNuRU8D5k=;
        b=sEWCATy1dFrgpR9iu51vufepHZeorfDwYSV1BL/E+ye10+9dEdOo0mACOXnye71k6c
         +CFkM4xNbiojFiECFvLVEu81CPvRE3fX2RsNW2ZubfldkS4yMfRz5qftwpG/QWmr7+8L
         V2AnCmAL++akY+gEP//VnKwghNPEZYSM9nUryYvb+VLCh22D3lbTINyEYFHbtHrzmiTK
         VW988X5q96RFJXCUYAmp6L/FsIS2h8q8er5P7QUmhrYDPW8VjxLkNHEAOnibF2VA6Ayj
         RuGlmPMxYc3dUdDyzIINXlfjK8gr+3EscujyDmb/+BduzmDm8OEOK40rvz7qW+/SpGy4
         Ow9A==
X-Forwarded-Encrypted: i=1; AHgh+Rq4Z1deJyt7zlwvdEafGFVIV8fzW8F4gVyUyaXb62PAk/jW+vVrp1hAbziq82oyTNauj/TQjt1tog==@kvack.org
X-Gm-Message-State: AOJu0YzCFqw07Fu2Qvzx0ffQr+bxbeUsZaxHJ3yeYjDgL3nDWDU/6Tcj
	5hmigBW47GYAFX+SzLlLoFL7cU2jsIgsnsBYLmd3qwUqIriC6o6ewDTV
X-Gm-Gg: AR+sD12qGu4587QqvKEyDBw27GQ+RhOzI5+qQ/jkYv6iz/pDG6tQdARiaLi+R0zf7DV
	KHCAzxoZaXNGtRI9BfqeKfHeoTpjms/9NhpWUUm514T98ezgdZ20F5LDCR98JCEqEOUVAXxVNeT
	UaEs3gvTzzjICXzeFV7vMrEIWJBBAx47uvdUiNgM1sXCNpYho93+4y8L322w996wbWgUjnMnxex
	5AAM//DkcblBRhdBRZVblBkKRJBxUFE5JwBKSlJIWYw/Zz0L/TQsURkhvt/cJoxi56b0iUlX3oc
	GdDz5zbGqVpYH9mSgmmsdsFseKx99GBtv5IqIBqmbu3vp6PVGMODbjVZCSczepChOiPui/gKVaD
	NwVF+mXiwm4RLgokv4an5IEgVEtG4HEFH/vars6d37wOyctcNvBWJn8koUYC+P9HNJMqGWPsLvd
	+PRSJmVlIxo2IrBmS8K6+CoWv/g8QskAMXgofAFxxXcFPXJ0FRvQpQ3SAFy7XWBw5CIfulM1J0E
	NKF
X-Received: by 2002:a05:600c:4fc5:b0:499:76c5:5855 with SMTP id 5b1f17b1804b1-4997c15fc13mr42107915e9.16.1786533127011;
        Wed, 12 Aug 2026 04:12:07 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c9417bcsm54830855e9.4.2026.08.12.04.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 04:12:06 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 0/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Wed, 12 Aug 2026 14:11:37 +0300
Message-ID: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCEE1140003
X-Stat-Signature: 35377j9bq89b47sndc6k3tbz7o8o5o4d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786533128-609623
X-HE-Meta: U2FsdGVkX1+8d54PNR2+QURMkHMa+OIRHAXRNC1DFU+OztgFB1D67me1KZxBFp/67Vtx0ZaKI5lvQizyuc1+QumFeVywgwcVXlCnb9AZ3BZb1KxAIcgYcwdD3/aMFzJg+jI6c8NsHnPNYIQrx3S3pNL8FcQk7y6ZPclidg38H0osu6hWOgeN1zPlfqDgiy2512FU8Ohk6qwpXfnHAknLcbHzlFMWEcihvNxqvdGxL4vlmKuA5illsJCnmmc9R907gumnZ/cvy6Jr7uv0s2stEt3riDhatrV6oTQ67oNNMLjAD/I/zqc594elrEwgna1Y1Uu/m9sYYcjudZgUe+E9bDCQQ+V0JhQKVhuza51ehRjGKRKPmXm1GFo60+tbt1IAKRmwkHokYLFnO08wboGxPSn6hnlzDRx4QXt9T2Q6SrF4L9LcSZfZSV6SHx8Ybruw8AdlhW76qCc/2vpRuajxZ9Y7QgNQGraUwyYBLFsU2tuzlZ7za0TCR9hNQT5JWnD555eUFQvz7RPuiUtiqdg2Vt40E7/UUYtOldLRrgifV7kfBo3WvsOLRScbhPjHSxSTUdSlAdFPl8Ydn525OzxooeXwREYL2X1atIiDfm3ji4u+JtvivWU9uNmIpg345+zzAe7Yb+Tz1KKzovTLV8qkK7F7us2zB8UGC3nm77kuXk61LzCx5C3ttjnJ1ueN70BNcA56W9aljBW9QROvK5Z/nO6oQV64l3kXbabxpsqVC5lINqTlatvren5l8D16CcpRJehK3hjSJBNYGfqgzjTR6jY8FwPHNCmn7n72kdy9u8rfcAmpi4aW5dJ0fRKBHTlr/hUO9CJyqL/c/ikBDYKCs2FG+SPjNiuoT6o3+BtO8az3Rjo2biAkuqLcIg8fAnjDK/YCU/2n7JNnoLrUBygiAibO5W7U2g6L63Z4PnvNYXlA5UPMtJF2XpSlqxhRrnNTb3J2lnWttXVwQwkznsD
 XrQHIlJY
 7D+HXy0As9hawgRdieEith1ktY8fEbDQnpuNIYMPpWNfPzg8YcXhrLKbsUbdWEGYrjyQ6ebiO8ado6UNQTjrosMLHPhPQQIaB911mhVOt7K3fV7kY2fad6JWlUX+hxx0D2tGNwfJHLiDStLHrAEMCWhLtDgS0lWcywr7dYThWA8syE9mRZ2OfeTa6CB7WH5+iOiWIRweQf4MVKAGP3GxxyUl5/HFjW6YKuTYMvB7ZOsB6UzXRGzsvR9T61atAGYsFNHqOy/zZTgdh3gcemF1Ej8/SBKf7fhmSR7p7hlzFH8AJe8lL6ahor6fwSqbRhFg3EVW+991Eof32pYuR2KeHYltTITJAZ7o8PJrLg33XXACz0a3I0H2nlW2S0aoOHR1WWLd4WPnnw3fZufr6k7VoVVXbyaB7wYL1ZM/sKFSZwWNq3qARdWsTflOKDyebASIrEUBAeO9jhHHEyLKaOXviyY2x6kpgCzq1XA42J8Cpg/Z9lIhiH1e8VrE2FfbbixJhwRk9DuoK0VvRZ5KsZYCPyNNcxVuNag047nOl+9Yf9ny+X5j10TBa+teocQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During exec, argument and environment strings are copied into the new
address space held by struct linux_binprm before that address space is
installed on the task_struct. Existing eBPF user memory helpers only
support reading from the old address space (i.e. current process)
and for this reason programs cannot access these strings from the
bprm_check_security LSM hook.

This series adds two sleepable BPF kfuncs for copying bytes or
NUL-terminated strings from the address space held by struct linux_binprm.
This allows BPF LSM programs to inspect exec arguments before allowing
the exec to continue.

The series also adds selftests covering both kfuncs.

Anastasios Papagiannis (3):
  mm: Add copy_remote_mm_str()
  bpf: Add user memory access kfuncs for linux_binprm
  selftests/bpf: Test linux_binprm user memory kfuncs

 fs/bpf_fs_kfuncs.c                            | 112 ++++++++++++++++++
 include/linux/mm.h                            |   2 +
 mm/memory.c                                   |  25 +++-
 mm/nommu.c                                    |  25 +++-
 .../bpf/prog_tests/copy_from_user_bprm.c      |  52 ++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c |  74 ++++++++++++
 6 files changed, 288 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: 07cb86aa50816b070b99c89bf948762ef035a1f2
-- 
2.55.0


