Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A766ACDB471
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2E66B008C; Wed, 24 Jun 2026 08:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7945F6B0092; Wed, 24 Jun 2026 08:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA176B0093; Wed, 24 Jun 2026 08:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 458E46B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:35:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB49C14034E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:35:33 +0000 (UTC)
X-FDA: 84914752146.23.1A7ADFF
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id DFA308000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:35:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fH4rj74o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782304531;
	b=3lpOJHZ8qZsX7Qv/tw/m51wPLq98s+sENgiHAuCeWewPmwlTtN7gprO3NPVGP8wLPpmFL8
	WIRh6PcPixw0Q7AQ+rwW6JDeFdrEnvKHKFl0yAdIFC6gopLNcgNeRjFVbw8Ux9VI8pOgVi
	kZ+5YdrZbFxLyseL0mbwdREzssiSk4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782304531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xPDpBmKtPUywZjFdZYdiGW+cb6iQbByKydMzv17TTi4=;
	b=YpAP7Ly6/mrZ13+TBKz0OKmxdrf3eaxAzqoCmnX1aRz2WtAopbM7fYWef8drsiLNtw2SGt
	kjF677Wzex7YgfRgWRRCx9u4fVIVmowhGs3p46DSYp93yjVHF3QJq/cEEF9jRCmMO62ORx
	WFI+Wxr2M4BnMMPxMKypa765pyuOK9k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fH4rj74o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-806449d108aso11735277b3.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782304531; x=1782909331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xPDpBmKtPUywZjFdZYdiGW+cb6iQbByKydMzv17TTi4=;
        b=fH4rj74orjAnYT9VJaaa/ywYtQrXmBwdFvaqs5i0I6Tvb2WFCPPDz4tv/uNNQZb6m5
         llrW3t3wMBwvRMevz+HjpYs1dRV7sySejh5o1m01MDuKC94O+YvkKdPoeyDoMqoQ+Duk
         ulHJA+9J1pJjFJFm254o8K+jxwlUe5Nrqf2T6UE1Twvl5WyjKeBv6hgZMy9HGJ1NeoZl
         O5uiQooPBp2/ZSRq03Uh1Hsee9+hmoEyvXCIAMHm7gnbVcj1CB9mXyzNvgxvBkoMZm+J
         C/JlVMJCt5D2Nec30A9Mwzl4vxWO/I6VaxksustHlZs1DD4sRF0DusT7krt7JGsNdOSo
         KpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782304531; x=1782909331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPDpBmKtPUywZjFdZYdiGW+cb6iQbByKydMzv17TTi4=;
        b=Dp+4TuO6DTcezoBsHlSVWV1TTKfU2ZQZBSmM8rfo6MEHRmZIo3C8u/fPwGEpo5+j9j
         PuqHv9W+WpSnYwgPhDRW7SJX90oDBWcgP4AS+t7XcPMf2DpLlUistbnkzHTfurT9QlMw
         Fjah/quzfiwBIqm8dP8IeVTfkf82khqdcQtOckaAhg1eXsvV/lE0foJQkqTJvGCRBHt4
         yVUOj49Qnrz6xjCm2iDHFJHpS0Fmw4Ze3q8frHZrozNQV8oeCdoEl2RQM2/6gtd0Xh1S
         8m0AjKkT+trQjJe4kZwXWgldOr5iQTkWEpLnouBw5HS1lxQHsVJJTFVH9ApSXj2KcD2Z
         I2hA==
X-Forwarded-Encrypted: i=1; AHgh+RqRNW6yvYXFE44z3k3ENwnkTdd4eipUCbsLz7QsXmUSOOudTxvuAnLA92rdaxqQXFosw2dPSXzJTw==@kvack.org
X-Gm-Message-State: AOJu0YwT1S+rITzay+6osZwTOc5As4qEG4T5zulsQuQ2pQGgQoZm0fyf
	tJ6JedXiw9ywDmRhE1J+dCWgjQMWR7NoDe2xgt72U5pBn+01/c0pnE37
X-Gm-Gg: AfdE7cnEmwftngDwb0IaHZLnBK0+aTJmx8TGrzMBhAG1w3987jrjbRKwll9m0sV7DeN
	1XRdPWktKXfosiUdggBmG3OGJXF1G++INS4AQmjUZ9wpaoi9NdH6zxN9T3Zg5+d5X8vIYD0S/Ir
	ZXl5h/r2re6grByrzVRj/O98uoDI6oz0kEoCeZhwKGjphmRQLUIL3QaJgki43cX6BLrkNJVaI+M
	/P47OAkhGb6387SR+VGbLUlyU5MeJnmo2lS1WraY47kwHGgFMg1DfDtS6t+oHekJCqRroppfa0g
	dMLU7NBsr7sj6y9LVFKJPyzLW6H5tm0J27+sREZDuktOI4/R5wNcCbKGG+FHFxa7GnsHQaMxbd8
	T+Xn+7m9OtC/X7W4I1aGEZbNK9CI5pBJAYdLYxza9PaV+Bmbf+m5h3mzniLFP1Q7pkKRJqMzFLN
	PEr/cXGvwR8GxQmEGc2QNWNlB/eg==
X-Received: by 2002:a05:690c:3341:b0:806:5a1c:d892 with SMTP id 00721157ae682-807f5633ca1mr28141257b3.47.1782304530790;
        Wed, 24 Jun 2026 05:35:30 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025c97032esm58728607b3.10.2026.06.24.05.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 05:35:30 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: willy@infradead.org,
	jack@suse.cz
Cc: shikemeng@huaweicloud.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] tools/writeback: parse help before importing drgn
Date: Wed, 24 Jun 2026 14:35:14 +0200
Message-ID: <20260624123514.7822-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFA308000D
X-Rspam-User: 
X-Stat-Signature: jbwt849bcphwk1u4z9yz46iytcup3b1z
X-HE-Tag: 1782304531-131372
X-HE-Meta: U2FsdGVkX18TyLiZZa72kdfaWrp21wArEA7HZVmNEYBBWcs2uM813NoOsiLE8UES3g6nWeRRElgMzTBAashk0wPjx8yawU0S2mpDNXhPFrwVLMdOt+o4d2HLDRVML7RdbQJPEJQfYhHhH9A70Ni8QnKjzy+kbIGJpwV63USmWJFXB287VdXbw313nePPj3umL3gV95h/8O49QJhdOU+mU3NMvLdhNNRr0wQBH+vdx543Tt5yGHK92sbP9Ikavkz2McsNE5imVf/ghm8MaA+qD3wKAwCjUdMfq0LJLbj8bDpJWkDRcwtcDNq0ArZ+pF/XYG3c6GTcCyyxQy8r+JxVEPrebxSrzYuZAL73madUY3EdXKZiKXDHqjWZgMbfGshCFM3LLuo9SDZepxMqk3kdU+6yyo6AExTrYqxb9/967CwD0Q8iiGBbM2Q+3SjsS4TBzfoZqMBDa2G+VYh0zlolRnLA5hr0ezmaIVc9riw13GNLe4tOy9WwrPuUfFfAotlzCGuK/wmxrAQ0tvq4B5LjeRr02HIc/lq7/Hga9/ey/rMbEvi92AGXci1Cf/rMZGPkjCowbYgqTx1YdWAHw8sKm+OsjscO4M29EW7u72TtoFcceshmIZC82Uz+EAJl7MnL53g26HLEbSnYSgm2MlJji9+UAW+mfuBKHG11FjJTL2Ot/co+BpU38A2YxhrlRRRFTBTzvwChjdmZcV3BZpGerQtqxoTa3LFdWm1rlX2t38xrKzwkQCKIXmRlj6GMCgxCN0tCQRBr902GSTZds0TIlnl0kflqn/S4jt75gDG8FbeNtzjRwyMgO6LTAF/6EidlCKn7P0m68bk5OMaWZr7Fm5KIUNyTk79SRPtshNeb6MF/jksDIJIkr0eqKbPPhCDDGFKdgCH31oUKqcfCFKgseZEnzTuLrkhyWUz63CXxnnEQXLQa75rVsP5RI7XbpGfAiRJEY4U3C/DrGQXhS0b
 VKX49QY6
 +xu+lS3Q64culmcmVnG6JqzsrSybbPiDUJvgk4C6+IPPk2K+DChmrnAFsrRaUw7ZUbZe2N94V683g0Dm3CdHxmOY/SJb0DbZOH82NPUki021idADliYUQlDl6jL1Pj/yZZqqNKJ0RMc4cuW7tPuVuXCDUo1eoIjgd7xrM9WaXhgTT9EjobJyyEQbNXG7KIJxg+UQb1G84LDbLxPkVzZAYo5y3vqhCRvNJyjzgUq8KOTE7m/CToZW7DYIyJd+s5tAG2x+sr9rfF9n5JBU5euwdC4rs0CIhhdGCydvgv4IQtIWdAbWibjgAmTCj9HSQrAZiT17tOHtEUEyoMm1IAPOoHYRlgQvMEwF22p+h9n8lg/4ewnOw6mSNnLKTUMXCu/S9FxPqobAhdbXMfY8pfyeauNMp99vnwLOMYQapJm7oC4sI6IJnq4Bq2rq77ADUjvfwGgHpqnI08F1girllHVDaAwfpbk+ZKYXeV6qfS433zs/hAy5k/s0VZfiP5egMN7nFdDd22y4qEplbLMAJMC2phKilHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wb_monitor.py imports drgn before argparse can handle "-h". That makes
help fail on systems where drgn is not installed, even though the script
does not need drgn to print usage text.

Parse arguments before importing drgn so the help path works without the
runtime debugging dependency. While there, fix a typo in the help text.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 tools/writeback/wb_monitor.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/writeback/wb_monitor.py b/tools/writeback/wb_monitor.py
index 5e3591f1f..e09e00ee2 100644
--- a/tools/writeback/wb_monitor.py
+++ b/tools/writeback/wb_monitor.py
@@ -14,7 +14,7 @@ backing dev. For more info on drgn, visit https://github.com/osandov/drgn.
 
   dirtied(kB)       Amount of pages have been dirtied.
 
-  wrttien(kB)       Amount of dirty pages have been written back to disk.
+  written(kB)       Amount of dirty pages have been written back to disk.
 
   avg_wb(kBps)      Smoothly estimated write bandwidth of writing dirty pages
                     back to disk.
@@ -25,9 +25,6 @@ import re
 import time
 import json
 
-import drgn
-from drgn.helpers.linux.list import list_for_each_entry
-
 import argparse
 parser = argparse.ArgumentParser(description=desc,
                                  formatter_class=argparse.RawTextHelpFormatter)
@@ -41,6 +38,9 @@ parser.add_argument('-c', '--cgroup', action='store_true',
                     help='show writeback of bdi in cgroup')
 args = parser.parse_args()
 
+import drgn
+from drgn.helpers.linux.list import list_for_each_entry
+
 bdi_list                = prog['bdi_list']
 
 WB_RECLAIMABLE          = prog['WB_RECLAIMABLE']
-- 
2.54.0


