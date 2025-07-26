Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74F4C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 02:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4566B007B; Fri, 25 Jul 2025 22:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBE46B0089; Fri, 25 Jul 2025 22:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08EA6B008A; Fri, 25 Jul 2025 22:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1FF96B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:52:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B5885C03A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:33 +0000 (UTC)
X-FDA: 83704892586.21.97CBB96
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 82B9640002
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J+X65k9j;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753498351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lrzISzvbRKv0RnWes36UwzU4Nkiy1QDsvftuzZlNP9Q=;
	b=fgX8CGRFkpSZu5QzjHtvIbTJlHglB3Kqzw9j/8nQHMiSsUV7Oq54KHSXItrNn7gsoh44sh
	ShadNPUQhZsB88II6SdXF4q2/kpCfseSmqA3ghY81agnOuvLzs0s0iHRpxK/RFU8lBJ5Bz
	p1nI5ADkhxy6xorLeAuF/Dd0bTPzX9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753498351; a=rsa-sha256;
	cv=none;
	b=71I+YicWro0hEFlYWsIzMkspIbdI7Jh6RyCbhRUVMGGQxg1yZOMC5/kjX2FDoHeGe72/uQ
	AFOAJ4ZxaenUhg2nlKYDkCXkwHUlMcabN7RG3HXeLqGAwdG2vxgtMigfxCyp8edHs+wIOz
	4ECfQzFZflEa967ztVtsvyTm4NwZ7hw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J+X65k9j;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-af2a2a54a95so425983666b.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753498350; x=1754103150; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrzISzvbRKv0RnWes36UwzU4Nkiy1QDsvftuzZlNP9Q=;
        b=J+X65k9jjrCN23Iva1Qq0BhaYmQkNZC5sJGzo1rBcNYiue0J1iuX/3Y9HNHVk84JLe
         m6cDdz8rNvUFnSrROvM6WvW8bS18KFWHL6RSxwTp6pjV33IZHsfCJHIVUF7W18VzjPBd
         9RH49pTsLQfLq5Q05/F5ScEBASoW2n50Oc2GpG7CmpPm97k58pkHU9uCgyIqNqTJ/w0V
         DpvgUoIwgFit4r1oil7HqYll4xMqzq3ahH7NSMcXTbqlaGYL1IQBuVEJOfGAGVNszXw/
         DCbC1zNqLwPo+wl+mq96TxHOVrlswOy8Iu4lx8inO7eOzCk6YcxNG6QFgbFqjlgJ+5ra
         x2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753498350; x=1754103150;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrzISzvbRKv0RnWes36UwzU4Nkiy1QDsvftuzZlNP9Q=;
        b=QxRvL1CDluuyrhFRBEZ9kGBGWrX9uzw+ExPEfMIhlZwtSrItOXZlVW0zNWGsmnZsKq
         pfkY+CbuGTWfx8QexgoKR+fe47TRD2e/tSZnTRsc40qfjwkYOm0PAholKY5C/Ms/IjFZ
         fhWqOqgcHQuYZWEax42ZlEBwE1Lgev5q0GMVFhN0VJ8oIe8hBNhl0GO7oy2fRqsKMPI7
         a2/irv3NL024V++Ttp4qq4p5k7MeCGRa5ZTzN8/BjexR8w3VTRkBZ8F/ZSEhRaPnIsVC
         wGfjEYiUrQkcI0oX/EKOKP5sFZO0lSknOoraLORUDl1K9v/m1P900DGtknlAJFFBRpTq
         YQ4w==
X-Gm-Message-State: AOJu0YzceeI38zxZ0MmwkY+S/mD3Cnrf2gwHdScqQ+C3GaR8bpqZu4IA
	BXP74YETn8t51K4ounH6/18sEN6Th6gYOVWwvN7+YN09kHaTC3b7BibR
X-Gm-Gg: ASbGncv2dD6CXuG9RaHOA9mi4bd8e3V6rlOw9K7/ehMcXCOHy5Co1Ankq4pI7yeHZvn
	FFk54YbwwYKWcfPN03vREdmUaWvDjJMtA4y026gc0gpHE0l4HvP3Rw0rgdLP2ri896KuQnXlGlZ
	M9YLC+Wycmw+pBUfHVoBMGAOfpYvvUAgkKRGQfCjz14NKCy1hLHwUw8JnEckDo/XgKdrv9Bz7r3
	OrHyXJU+R9uko2QL3ZW+Ix2YtnjnFKhNhvFcCuZe57wGbFGlg1WqS0OigaMkKs86NUz3TalBq25
	E+HifCu4V9VCfKS2vmJMWOI7mC7VfFt49dVLmXkyv0zLsRVRSdmRZlR16RNiTNWnwa2WADHEvq0
	+wVtCRbpAeV7R31ygETa5oA==
X-Google-Smtp-Source: AGHT+IHUFa052b2FkWypAMsiXHSBgwLdB9kzIAS8K/uuN+DVBbCyC8ia5oprM/ptGxCBvNymSxs9jg==
X-Received: by 2002:a17:907:9406:b0:aec:578e:caf2 with SMTP id a640c23a62f3a-af61dd62c2dmr569546066b.29.1753498349682;
        Fri, 25 Jul 2025 19:52:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61500a57296sm554793a12.15.2025.07.25.19.52.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jul 2025 19:52:28 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] assert rmap behaves as expected
Date: Sat, 26 Jul 2025 02:52:21 +0000
Message-Id: <20250726025223.350-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82B9640002
X-Stat-Signature: 7hzbxxpgx7dzpkq8rh7zdrd4me4ph65f
X-Rspam-User: 
X-HE-Tag: 1753498351-967480
X-HE-Meta: U2FsdGVkX1/IKr+vfTm1+zxAvlRSrvUcDPl7+eT12gy+sl49sOICDF6YO9qAnxtDBYYiIQXEqm10ogSXn6D/x0/mNlzWYENk4rumb+vM51sCqsrKkYtktMOSmJYkHGdaaIYtFagWqFkT4bRYeDfwJAN9/YVh8nAfsnU9PvsJIkJ5yEkY2+jTOJQHdQJ/gKV2D7ldPCXEXHlZatB0ml5S/qDwV169Xv+Ec2fmV9FKDDHGWHnYaMWTHUsUIbc7fosJwBJJfNtybh/dsZ71T0qeGziXAbHV81XA5Qm2BPFgkpLIZISePfH1oulle8JTro/Q5jMhMNctUx0ufXj9YxefGmgjv16pqJ8Qe1PJs2DMwJC2wwozyIuTJ4oWiz5+YMkUov/lv0S9Rq9e9j0zOVL35S6tI9ItF34nVlavkoVMkKE6Eoju0c9aqDJCBdhmFlQNJq1Q523xpY6xIMhErRGsy/RiF1V1gHpGKgTRGJGBe/ddCbqlQxNCsRwt5m2MDNdGiK1qpLnyocehM4nfHMgnKYRcal/v2c6qdeAz5upHK3rWGWu0Xj5m+5EY6kGqxINkZP6SghVct0PgZP5gOjtM5TwyKin2e7iVU9GVBfQ930CELj2NKLsDyg+TiyNQPfjjAbM49O1co13I1w0bv0hqX+yvPQEEpMiUCARol51+hRao0XoYR1ATS8vNGVKm8qtF/K5muMiOpJF1TfY17sP/oMiuk4X23mmHHTdDYGZxoMuiLl1SD3uuqXSqZ4UvRVNkKXc4zZplZLM3dQwAbE3D3MtJyg2aVx1SmzfnshwVw8aamBWS6WAfi1yYaS6E1GLnYzcG5v6bL7FWTZRzTkvyRGDRSpGW3gLB0FVFXX+tsN+r7Js91N1VgujpJ0avksqN0NpKIRDLJLrMuxPmq7SJFzULhzvkdt9OIZI71e05gaEuEjm4jXaN54zQ+O6Ce1weHA4ClKKzgh4wVdXCXdV
 WWWd6bEP
 MFTHSIbslTNs3/a/0xxiViH139QJBGr4yFcmmo2iBxWbgMEuVcaIL+nBJqZchD2+r8KUT4mBCXdjEjEqrWM1b3bBIMe/iPabZGDsbcff62t+Y1C7dhh/A9jHynuSNsTOPlZU1wJZKBoBtbSJPIiW+WAR3hWJrMCuvUw9pOT1KwJcoSszzxtUot5x7Oawx6thKwm+GzkXfpNGcP/Ez60IWwUX4PrE05cXu8F+tISdLUl2wxNMq4f/QSvJ2eFihT8mNeyiOfwfPBPPS4L3SzbLbro73H549JsPJhwgOIzkh49yoxlLAdFrCza/xlWfdWnMTAa4xOynWj+9FeaLTHUZbs9UMgeSe8TjRSlfB+NI2FSZA3K3f+CszjsZvBdgVeQmEP1Xu1rxz8YWqUsQET/lkIYs4VaUOwXosxGjPjJ2ddk9cKOyl6sQ/7P7xvgEZP04N2IeCTwRwA+IPxzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As David suggested, currently we don't have a high level test case to
verify the behavior of rmap. This patch set introduce the verification
on rmap by migration.

Patch 1 is a preparation to move ksm related operation into vm_util.
Patch 2 is the new test case for rmap.

Currently it covers following four scenarios:

  * anonymous page
  * shmem page
  * pagecache page
  * ksm page

v1->v2:
  * do check on file opening in init_global_file_handlers()
  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
  * align the return value of helpers: 0 on success, -errno on error
  * skip instead of assert if numa not available
  * check ksm sys file before continue
  * use private anonymous map instead of shared map
  * check pfn instead of content
  * retry migrate
  * fault in region for each process by FORCE_READ()

RFC->v1:
  * open file in function itself instead of pass fd as parameter
  * fault in the region by accessing it instead of print content

Wei Yang (2):
  selftests/mm: put general ksm operation into vm_util
  selftests/mm: assert rmap behave as expected

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   3 +
 .../selftests/mm/ksm_functional_tests.c       | 128 +-----
 tools/testing/selftests/mm/rmap.c             | 432 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 tools/testing/selftests/mm/vm_util.c          | 123 +++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 8 files changed, 588 insertions(+), 111 deletions(-)
 create mode 100644 tools/testing/selftests/mm/rmap.c

-- 
2.34.1


