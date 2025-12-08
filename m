Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA2CD3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02CE6B0006; Mon,  8 Dec 2025 09:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3A96B0007; Mon,  8 Dec 2025 09:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9986B0008; Mon,  8 Dec 2025 09:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9316B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3208886C37
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:36 +0000 (UTC)
X-FDA: 84196554792.07.7820601
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C86F140006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgBISZmH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204594; a=rsa-sha256;
	cv=none;
	b=ZhKsI9TyU8KeW4OJpyuTsgWSrbkmYQZJ1QhkZ2dKth6ESu39fPPpulN/8u1vDph30MKCop
	zNcvjZVt6nA6V5oKR0CtmopHGC9MBz2I9LMAWq+/o0FZgpcZvUbNNLaW0RXJpiaVHFvJ/K
	4rsLPL7VxPuMDlQ9v0cu3rKsh1R2sJE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgBISZmH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9p5QUci8O4FC0w+okpI2qpZqmhejRWVaq/F737u7QNY=;
	b=vIcSH786+iPF5kw4aFYOsoPmGNf38VWgiUWO8hXWGRdts26qwjVPaoRBo3FtrtAwPqX2oI
	O872jTO0rU1twpUaHwW+dAM1XQmIatS/7Im610wfDb/zNBraTW6cQvGsBakV7aIlzp3lPk
	KyQjN7c2pdokg16K/LOlFIjP6++CijE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so7683161a12.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204593; x=1765809393; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9p5QUci8O4FC0w+okpI2qpZqmhejRWVaq/F737u7QNY=;
        b=VgBISZmHAZnGhoM9eFIb3KiWH8AKGWxtXOqTFNjiSpg1gRInVTa8FlI7S9cl0uWjNi
         tgCsycR7OK7nnPtq37hVyZB9tAPzUeV2EoTkPiH/H8vjT2wYOh7/GKI8J1hYl8We1bIl
         aUlRefkew+cwtDY76sgtRM5RkCtoeWlQIBSZZUD6ZVCKHfd/9UJh5p3HpFnHuflSky8f
         P7GYuxzZ/AppSQqVNRBznjyoU7+lL2N5qhEPRIwhAY28QCwEo3CT9gubBqEKURwnIHdM
         4z8IeXEsrhciGOCaSD1pobga8ufPWhdswjZWrkG1K3BSa04ouFVskFQeLcexx4EcI8t0
         l2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204593; x=1765809393;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9p5QUci8O4FC0w+okpI2qpZqmhejRWVaq/F737u7QNY=;
        b=CtcF0ilKUPuaGjD/R4MrWeW3ufxp8ENlFoeZYhYxISSrTU9C7Mw5cFqrGY5sHWCG1F
         xRkr2C5qQqCVzmkk/kFZpynoAKpk548IrFfQr96WgVBg2mIXGB3AvXI3KE8Hi3rRpODv
         sNCAC+hu82ufUNzIhVfbdLqssQgmGxY+vscQUYQ3FDBwcEn91tnXs9py9UbVYIRjSu7K
         SlJnJgSPfgGewCmlroC2SLn4xG5WyUZfUG3PbCJYASMdicijVbYzgrCPu+Fo6Tex2qcf
         LBl0JaOL9a1euFxBijekPJ0V0jOfzTLE8u9jrScDeCadelHxwh9DFeI5sZ+mlR852f+w
         CchA==
X-Gm-Message-State: AOJu0Yxk1WqpeCi071LM4Ngb6ylK5frKxf6zMO0FXIubll8MV+hM1HWg
	yo5tnQnYDndiMSwtvo/nRAb3B8oyP9SdtMmPU8UsE/JZ6v7Z4InOc78F
X-Gm-Gg: ASbGnctLtacCnoE6lH0Dg0BqRjtiWQAtPBq7ABWPn+LF8n1r8s10sZ1qbaQPiKp151F
	NQoRHQbb4J+vEqN2Z1f+nQv39K5HbmzKhaKUVFaW8sbvlVEnfpINXwn0Ees9PYzUKZwtWhrja74
	JPCb2lglD8w+G1vSTFNo5f4rGuEvuSpAbq1/lkBLfx3Zd5Rq0HHOso4vzYdQoZ+7ezh4fFGxjSE
	4CYsH3R+NBsv1GyHNrDtfeI0YGJ4rQnAWkEp+VqEOa2sgG+yg+cXsItZ9NJCf6+066WmGbnERuj
	IT69Hj1+yNWn9SqdJxkdEQNfJU9GJvst8h8t7HcqtIlXeH0/h2g2vxaNpCbsNyrq4bAHfKIR+88
	vA4u6/iiGselQaOG1KS1545yo0KXp9c39dO1zTfk3YNruXs9P2S1/7fnL22JiLPabQOH4w9/SKu
	mYm1Skxr+Rlw==
X-Google-Smtp-Source: AGHT+IHeV/K5NZfgKmuHzSRuLPIFTPYNz6UP1D/O4ofaYouzMUeLivypaHLuDlsaZggpXF/XfQEvGw==
X-Received: by 2002:a05:6402:4315:b0:646:66f:86e9 with SMTP id 4fb4d7f45d1cf-6491a43294fmr6930613a12.19.1765204592722;
        Mon, 08 Dec 2025 06:36:32 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2ec3019sm11109333a12.4.2025.12.08.06.36.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:32 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch 00/11] Convert huge page split API to folio-style
Date: Mon,  8 Dec 2025 14:36:05 +0000
Message-Id: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C86F140006
X-Stat-Signature: te365ra95ieman6gh6iuu8ws1ituq9e5
X-Rspam-User: 
X-HE-Tag: 1765204594-363019
X-HE-Meta: U2FsdGVkX19IfE0Of4OSc5UqNw4mI/wcFINk+mKb27vm0FOlDJ6QpSyc4FVOEkMPkswSHRckZVGmqQ0zay2IUfAtzCAe6ifD371hZtcyP0hZuqDyuTEWczQZ7cWMSDi+Etifmw9IKrmYIHlF2NG7upqKrqMoZXqG2PTWk89JH3sEXr+mf3SfWyFnCkFC2inP2yeGTVozLXdIjBU5tnwxejdw1O+Grw2m4BDwsHQgujPO2hMAI2MfrC/X396wsthbZ7WxiVvuqapaVWlN8cbJeMRlpKpqEERbIAf7Cyv49QNZ1Ajzk9qikgogWdPn1K0y/9V8UatXZo2BfOZn60gxKvNr60IV48CxVpNAxyd8JCuS6zIiXF/hm9DV5VeVaZb9bSY96H/2bhoYy5wt7OWo0XsJlGMlH/8HSQ5Nm0i7WBpM6tnreTjGYD88VM7AEa3JYTUt3ub4tSFqjMFNXhSD3rp1cXRX5jOI8yREe5rmkC8YxLRaGHgryMQZgttH9bOnyk416tCGXo0vOpG+JjEg+oGKjbdHNTSC3sygnHDuNyNu3TTR00P49uzKnHlZMH7zPKdpYEmACSHlgDOBggqlm4NzwTo7atJd23ql5Coavdt7vuvYV1JVCyc8MT3dUW3tyJ+IyZLB1MnF3YVzLnRyfPxiWv4AYduIFzYysWCGSFuUFHMZbGfgMQ53Mw9Sh1mEGN1Fv4SoHrF2hfGsIX7Wc2vXNZOU059smunz+S3w9SET5HAIr6VImzrCYVYtr/MEuPUdrt/8l1v7+y+QGwn7i2LmLsyMRupB8hrhZHQWk3UAi1mKDLX4l/vcJ0l8A0na8h2iD85y2Kx3o8iw9K5UsyZLn6GILClvN/Ml5PgLtLJuf/LOF7sSrKYqkU8pZ93N3qOLiEq0/DGzsJ01uupct2CqD4NpUJL7ApLWhJHBDwJMvYTMufhgMmNfUzRuIdmurUMEj9baFKH8lhdiKhz
 YOBMRQX+
 +eN5vDMKMfoHmNiwhMztNwrMDNKRu1jn5vdmnpFetIZ3b+Z8E/RMX2LW5sy/gSkorQ90RZSM6lYAWsdN4egPV6Aq4qnocR1YULhVFfsKNL0blj8VMFyHRjj70mBT+/UVCLUbo4ZY4TRRmMiWse5/3IgiKCghVJWqvghLcLlmaMHTPsjqTjyXWtpy0hSqKPGlLzSrImsxWhdfN/wjnBNQVoMD2mFmBVnASR8pV7rVCd5C7TJwhW6A/svImAuaOHe9fgGjhh8z7w9gT4Sr3gGF4sQwQWLov/Niw/HB5kY16qKIyAzQjWLiSCq/GdJD1e5a28TQnsDEzYXV9ClNpXXLuLtJRjxz2KyzpXyYlixrkx3ME7cM6jMdKpUSFt/+BkmqNTvvA/2qIhjdLXWC/Bgd4CJSMANjNHmIQdyR87Oya0KeS8F1tWnQcCgOsNBrVK4HWPzUTk+iTwD3YGHO+WC14hRIs3w/YSct6884OYg1yzEs4TNaC1q10XOhHJudIHM+2ItXNlfok3u1NGT+8XIZU10BYdm+VCX5LoD4o0lQNJiIgihzZFbIrHWi7B+rdSZbh2gI8EX00u5a2VDfl6OG6UJ1CsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series continues the effort to modernize the huge page
management layer by converting internal users to the folio-style API
and eliminating redundant, older page-style interfaces.

Currently, the code maintains two parallel sets of APIs for huge page
splitting, which adds unnecessary complexity and maintenance burden:

page-style APIs:

    __split_huge_page_to_list_to_order
    split_huge_page_to_list_to_order
    split_huge_page_to_order
    split_huge_page

folio-style APIs:

    try_folio_split_to_order
    folio_split_unmapped
    folio_split
    split_folio
    split_folio_to_list
    split_folio_to_order
    split_folio_to_list_to_order

After cleanup, we would have:

page-style:

    split_huge_page

folio-style:

    try_folio_split_to_order
    folio_split_unmapped
    folio_split
    folio_split_uniform
    split_folio
    split_folio_to_list
    split_folio_to_order

The only page-style API left is split_huge_page() which requires a 
specified page to be locked after split. It is possible to rename and 
convert it to folio-style. Currently it is left to get some comment.

Wei Yang (11):
  mm/huge_memory: relocate fundamental folio split comment to
    __folio_split()
  mm/huge_memory: remove split_folio_to_list_to_order() helper
  mm/huge_memory: convert try_folio_split_to_order() to use
    split_folio_to_order()
  mm/memory-failure: convert try_to_split_thp_page() to use
    split_folio_to_order()
  mm/huge_memory: remove unused function split_huge_page_to_order()
  mm/huge_memory: introduce __split_folio_and_update_stats() to
    consolidate split task
  mm/huge_memory: separate uniform/non uniform split logic in
    __split_unmapped_folio()
  mm/huge_memory: restrict @split_at check to non-uniform splits
  mm/huge_memory: introduce folio_split_uniform() helper for uniform
    splitting
  mm/huge_memory: convert folio split helpers to use
    folio_split_uniform()
  mm/huge_memory: simplify split_huge_page() by calling __folio_split()
    directly

 include/linux/huge_mm.h |  48 +++--------
 mm/huge_memory.c        | 181 ++++++++++++++++++++++------------------
 mm/memory-failure.c     |   7 +-
 3 files changed, 116 insertions(+), 120 deletions(-)

-- 
2.34.1


