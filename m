Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5500EC43602
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326BA6B0088; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7836B008A; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A6E6B0092; Sat, 27 Jun 2026 20:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4A4D6B0088
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:11:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 306F51C5EB6
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:20 +0000 (UTC)
X-FDA: 84927391920.08.1164248
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 801D1160011
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h1pBFGZQ;
	spf=pass (imf08.hostedemail.com: domain of 3pGZAagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pGZAagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782605478;
	b=ZdbiYAttnK5/jcU+UAUYSvkQxpMlJCF1nPf2nkYM9h80Qa2bqX2GU/toaqk13TSqQgbXvc
	65XP4zpM1/vbqBM9CuTxYioR2JlgDCUcErvNlabyCNxZZtcOSjxmS8jTmYvgD8drz5XqUG
	g4wM2oH7b48ndDoZhrNAsph3lzHv9SU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782605478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hgM2C+2tmAHXCXi1Erw+RqOrmUTdjS2vF4qNTQXjKRc=;
	b=j7bTDULoKocoevH0LssoGftoWKZQJpPTx9En0bABQr+8m54XSEM4OdP5qQ0mJu1RweFEoc
	xs9Wx/LHCvamRLuf+zvGFU1j9fPEZhoaOBpRA6d7LwCVcsA9A42cOdhXHSEyvouetAHDiJ
	NCGSf03LbybHk8wQTSXz1eEq2nkRUP8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h1pBFGZQ;
	spf=pass (imf08.hostedemail.com: domain of 3pGZAagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3pGZAagkKCMsAr8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-697e82fe603so2260846a12.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782605477; x=1783210277; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hgM2C+2tmAHXCXi1Erw+RqOrmUTdjS2vF4qNTQXjKRc=;
        b=h1pBFGZQyDvW6pYKU+Ql1f4GBuyu8Jz4ext1m3JkSCn3jTlPhMqXIlzX+8OfmVnfEF
         nFBfXoyh71/+fdRf2avoWpYpA1o0N0KZlZcvW0ZJ2qNCGO5InyM/Wz14EyeSvmqV7L9Z
         LjnXEDeb0nVPEun3TEx6N//3uokDaN2vZ87c+CNtKszlEhSziXZ/+LGBJ2LFAvpFFaVd
         qIwuGhhbqlNjsZkaeZHR+FhE1xtKcqseT69BFmC6scfR4q0tBDjXdhGKhh1nqTFe4X1I
         MRZ4iikK54wCA8JbUBtf/Cw/nH4z7hV52Xsoll1gnhiaHFcHAUycKzZ6xvNWHA7NeAHy
         sxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782605477; x=1783210277;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgM2C+2tmAHXCXi1Erw+RqOrmUTdjS2vF4qNTQXjKRc=;
        b=EOU4igaz0u4ldGD/7G2AAX73H/RMxclFbD1sbQ2zTPTjrYHVrD2IgkZQp5l7xW+BqE
         MAekeCNJ3mc1XJx5Ha0FfI5oGNkAw/hT9AHaauOqmAV2d7ye4F1unCpo0W1CEQ41qkqL
         QkHoCzf/QUUm7pnQj/TF/kJesS/0q9EtcxItM3ECOj6l1ihwKSlYQDPNzNr4t8+iV4Kj
         NK9akF1oDS4gEuUjIcx8wcZhXn8NkG9Swyol83QaRNY7TMuyD+LgL+CrrtR56WRRwMqz
         9uukBl3nmeetwu0yPdBI5z9FrJjoNv9MuMp/DWGMZjdafy10unaibvlwXGUZTO22H9Rp
         KqXw==
X-Forwarded-Encrypted: i=1; AHgh+RpTEqP5KdDk5qcY9eiY45682GiIQ/zID/z9mVIP2eeZVUravRtafR7IHIAfwgZIVTtq47GXRFr6aQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7I65ZRA0PcdmQeD0/bkjugRVpqmmzbnxBHAdOuYmBHR0zpT53
	8qL0zjjbmjs2bcxtooM6OwgETIf16Ec84FMl+ejV4pdeOJnVvHx6jSXSVei622x/i1lqBK8sdvo
	Jqki+5oY/eBMvSaQnyg==
X-Received: from edsk16.prod.google.com ([2002:aa7:d8d0:0:b0:698:4825:edc9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:22cb:b0:698:3b7c:be67 with SMTP id 4fb4d7f45d1cf-6983b7cc7e5mr1598424a12.35.1782605476512;
 Sat, 27 Jun 2026 17:11:16 -0700 (PDT)
Date: Sun, 28 Jun 2026 00:11:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260628001114.1869564-1-tarunsahu@google.com>
Subject: [PATCH v6 0/3] luo: convert serialized ptr to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ccbjyiq6jqop69d4s81w5ec8fwcwyjze
X-Rspam-User: 
X-Rspamd-Queue-Id: 801D1160011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782605478-360657
X-HE-Meta: U2FsdGVkX184AZjuSIMczCqp9PaQqNpv11Uyjun+p8yWxoR1feIgxrjC5qJ22yAhAm6yIK8pBvhjX+mA/eXyAOFx/h8yVSsGqxL3bjcjsgQgQOJwIfVlrLDlNdS0WLDYnMJUguve83b5Mvi9st0AlhaHHjgiD8TwsNMTpdeuIUd7LBDruxnnrDU1lR9FgkMij4qBGxoI+5qC36EKjN8aHk0D6X9hL0KviQkRbKNQheFk9fRkioL79vTEInSn7oDs+b/QFdY+PQ25i/mN1gJnVzgs3pREXcP3aKQz2YgDWi833lQ1yczhDLSDhAI4UqN56/Maedxr3z4uNUtXgTPc3cgXa4yeqOIQ8jtVlBZ2FBxGGZgTGRaSaAZ86JeN2sHXOKMZHKeK35UdqizvtDVTAn5FEVuEAPlLRSDpt5xw6i8lLjRuZO+iukJU6qnkTOHMpfzePlleF1WdSCa1cuAp4rut2xB3GSgc2kY+BbrQbE0n7Ha2uWvyCH3CkKd25qekT8vaVYjEM+V+i/ApTbP+ws+uNfMgTHXN0XKy3Yjpv8qrn92M5pW/HCbsdezDzAfrwjeDnxxt0NLTj8jM8d+QOegCVjYctNA379FyyC0O27/vSLhYMXIb1/+oc9iJreHxbBpY1s79ycA7oPOb1fvvbxniWKe+P9xjldoSzRHNi1thZr8IYJ9+3+f0oztTvsT53rCTpeEPPVvvrOCXqeegrLJGmUAhSAa/K3zAWmNC4mrRgViUQx2nCBa0XEdjqdhiJzkYPh3H/ByW5YNDMXWXJfQAlj+gu5ze2ChhF24RRUialXcHadhfmx445ROV8qZaP2sM/sepbjYQ9Q1XDBgKmZ3LmNkoJ/MSF26A6fMl4TtpXcSshIwfmYYoMAZA9zoFwoOBMAjNXt1/bgAO08sMY+Pzai5YvEDqpl3BVFD/uia4k9I1NcxBSCITuqNAHL9ISO67eDaujmqEeVlpvxf
 LR85BwCb
 Lo4Ozvx3sW++MAnggyxSe32frqhQsFpjlcniO59QxIss7kcdDQk/tFtALmN+AuWUh026zc6YzIY5ozvaOhX8NMZLVye1LMklKbz461Bmcvbs1pKjZLG6IdsJT7iAZyChutzdLKJQ/kdqC4Pxmprygq6eUDppnbD94CdgbPhhhSpfhs23jQr2ugRWrKbnKj3ch7cB2Mq6aBFYWlfZ9zZvUj5pdCqh2Et1ck1PI6qdWLpgX8y4juUzSfM7m1Yb2qAc9jnVa/uPPTCFbK3X9m7ghRGIl9lWXKMO2XchO9nvjdcWLHcJNGRZFO8PS5iXGwXAYaDh7yFjjT+YgKD1Xp2DrYMj/owOpfau3PIgQolb9dhZL1oFYCCFZDySAjbDy6PZMo9bwAnkytO2xPCzf24/4DomZUO5PtIEawE5t8ajqTrYLdRPxJZgfpEXXgKaBMXcp81N5EMDyasBD8DMP19wGNI7hAToS1rVUaHPStM2SdOvWMN/X77PRrCHVJG4InpysHWzHqL2h2vFKMu/uueMrwBRIniOkxkApMfAnqqaJeUUwTewMXkKpolhN/wr4/cUEGgbWrZy6jJZsstpbTBHAVBR6yWfMakMtvR1nQ91HUWnk4Dw/y+q1X91Q6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

Tested ./luo_kexec_simple --stage 1 && 2

v6 <- v5
	-Compilation error fix
	-Nit comment fixes
v5 <- v4
	-separate the memfd_luo fix in a new commit to allow backport if
	needed.

v4 <- RESEND V3
	-use only KHOSER_COPY_PTR and have compiler time check for type
	excluding void * types. Remove TYPE(UN)SAFE variants.
RESEND V3:
	-Sent incorrect thread format earlier, this one is with correct
	one.
v3 <- v2
	-Rebased on top of liveupdate/next
v2 <- v1
	-Use KHOSER_PTR across liveupdate files instead of only memfd_luo

Tarun Sahu (3):
  mm/memfd_luo: validate serialized_data before conversion
  kho: add KHOSER_COPY_PTR to allow phys copy of serialized ptr
  luo: Update serialized data to use KHOSER_PTR

 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 include/linux/kho/abi/luo.h            |  5 +++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 16 +++++++---------
 5 files changed, 35 insertions(+), 25 deletions(-)


base-commit: e98a9c61721c14bcd29f11f4802e52e908701f7a
-- 
2.55.0.rc0.799.gd6f94ed593-goog


