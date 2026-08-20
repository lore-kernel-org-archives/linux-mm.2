Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 126F9C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF126B009D; Thu, 20 Aug 2026 09:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096576B009F; Thu, 20 Aug 2026 09:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDBB6B00A0; Thu, 20 Aug 2026 09:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDD0D6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:18:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D26E1C0201
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:36 +0000 (UTC)
X-FDA: 85121702232.11.D1FF11A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9956714000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a6B4pKHv;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=apFi4Q/ckwbxAw8rS1lyMwC3AIg4V0MFK9+reDX/DIo=;
	b=cp4y1TSh4l7moqCFeZDYOBv7HOXrKM+ngeUdmADtk1knMWVHy89v6bnoZtArXn/SY0awcM
	Xalz/HtSPmqiOGvl6lPQjAxmRaTYyygEA6wFOym1fLW14qH0VwYSWFDNVOtnPO3k28/slO
	ETlImL+Oa5IF/7CfMeHkyug4VPHfcyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231914;
	b=SDbtGRuCz2sc3DZ9R5TJdJOdgb/kYv8UquiCUg/B9LhQvu6uVMhia4EWoqx+9CnrfOpudO
	z8sH7CI93rEFZx69tsqouQncN9eImI2NRE1icNFCyHGYjorKXWoICOsgQmIkJBjno3b0N3
	XpM/VSAzpNmbzY1XIQoOdi7ED9zGNjs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a6B4pKHv;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso23522405e9.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787231913; x=1787836713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=apFi4Q/ckwbxAw8rS1lyMwC3AIg4V0MFK9+reDX/DIo=;
        b=a6B4pKHvFdkvezwHrnAUWXC9qgWJEcWdxNqGT67onyonTOUuAUMt3dd9bknr35f7xa
         B8eyP8FDJ16brjESnQy42MIXdVJX3VkGz35kfBhc7Sr554slA29hX4Qsl3vhpVF90F2g
         U7laL1oKpCDS09WFSoxOz+3gkEd1wN7Ddg/qV7l50V443BFYoQEBycAGuL6dkJ1WYGYL
         R1ZXGQuT0PCUgUuWyL2JLVgjaHwzdJKegR+ekSokU4jH0lNVIKwIIfZwqp/jvqfp6vwf
         bP5JW8vw72hriWHocz/x8LqWdc2wJkQ+FbYf3FPqnX0Q+s6JxGY+YzECwzljP+0SfMcr
         WGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231913; x=1787836713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=apFi4Q/ckwbxAw8rS1lyMwC3AIg4V0MFK9+reDX/DIo=;
        b=Ak64dvr3oQTE9BlqglpuNvRiKSE15/l7x+MdRPAto7Z1hTuvqaUjogHYVtj2hE5Q5Y
         NqugqxVpnvt2fkTNRaNTgCQwy5xiKm2NbR+qTf1sM04vUB2G5S6xNwtTIeW21wo4cVt6
         dZVpTjoWuvpOpI+lbvTlVH7aL+MouDS+BjtwjlqSbVKH3/QDSvfPYW9IHvZKkdTF5uzY
         sobttj3n7tRuoDSpyOTn/lLECFYtpAeBVgIfz+D4vb+0dFZiSdf3comf5epV2CeAizGs
         e7qGdyi8wNj0lHPiJQ+wmI6+vkj2bHmPsX5RyOhv3yywmc8PGN7wYraaL/sTtNke3Rgk
         yFBA==
X-Forwarded-Encrypted: i=1; AHgh+RpXvB7/znbfUBcZfxJOft3TrqywfyCz9ghDIc2vTcm7k12KyU+qRDXu5C+pDvd44m2j7jJn34Ff1Q==@kvack.org
X-Gm-Message-State: AOJu0Yy127Tdrt2t7i0T2pIpjAlCK1hlQWU3l+olrFze1ghXEw8TL7DL
	9QpP5dkpqTwDonT9UXs6TfsQXCmYFWvvF3bU+sFNAd2gZpZuFGk/IqDF
X-Gm-Gg: AR+sD12TgfFM4h+57i29iZ2l0+gRK6Eb4V3CVM7/LoyyNxgpiYCaSp6HZBXFVplMfCK
	0aSYyldTMmHa+K3UFgcGWKrklzCtkr8RL/05Mfo7Xedd1hhK3BIe8H662d3YdU5wRh/sUuEtwQL
	8VkAHQrgoy58sX6gTLwkKg1hGr/NIdzoP+iIuhQVreG4nTfTeqeGoD1SbySFthzlTV7z2PjNo/j
	nOkYVXzZr7a9I9gW7HBpOv41e+DBD+wB7A1ekWL4mg6bpdFTfBZWAs1vAeHo73XLz+O/a9C1DMq
	0JdunxQTmzDHj08baSI/N6jd3e8Zkgct9Nd+phQyUXq1+FZ+0RWK38+6XBL3JW21gLdtvfRlDhg
	Ug4iPXzXKoY3zloyqv6AJzc6PP8FBsIyG5Ye0rtsvPYgZo10OAHdpDl/mTo6sOGIlpSllGvCwh0
	u0c2ap6i0NnoTs4M2cexxQITKPCwMUKXEdP1NgZL4v8In/iLGyzreG1AG/RlBoGu4130CHvfmkY
	SEZ
X-Received: by 2002:a05:600c:6610:b0:499:b402:6c0 with SMTP id 5b1f17b1804b1-499b4020c41mr41967885e9.3.1787231912946;
        Thu, 20 Aug 2026 06:18:32 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0e473dsm136027275e9.15.2026.08.20.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:18:32 -0700 (PDT)
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
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v2 0/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Thu, 20 Aug 2026 16:17:58 +0300
Message-ID: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s4ddkpk4fcf4q6kg4qn196g7n8ex9dxm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9956714000A
X-HE-Tag: 1787231914-489370
X-HE-Meta: U2FsdGVkX1/Nnt3XFNRoBrctcjtTaxANC1TiP8aIU2PbRNK5ddc93vrk3QtKR47kt8ohcp5EgLJ/p0/HA0B/BVF+3mFe4pi6l/T8OaYoL6QrCiR/AH2W3f3KrzKTJ1cprPyoKQIJrnHb8UtRO5f8qj6RQkvpKzbBZWlF7e+GTc/HC8Cki1qy3yMN040cJif4hUjbfmR5SSb258Ez6qy6T8isyAddMvT2MxG14cvFcoDI8ykWXWYPguiv4T1Q4xl39OdTViXgTRLCQoHQYyW3rkn05c3hVpZIusOaejF3JWCoCgxBSIGn4cm8Hj/Q56VdBxP1C0rHhdPNJhLu9pU/8KokjDoPO+8jIkXYfhb7MBEWBJtrt+SqiOxk10Upj8gWCjTxoD6muF0Z4Z8AJOgOi7oeej0PeUSZUJXxhdkN/oFiAIxvsf9eS2Ya+UFthhFReVN6Zjg3g+xosUIQiZ/+dstjdbd90z38vnLg3/k/xTx+GZ4KL8thuN4vuKXmyB7nr5zPsHfuel05UrghlK4se37VX8+J1zf4dtedZeT/Bc4Yb3DKwXWChQyzRCANzRZfLsDCrLD16DAi9eDa7P9I5LmOsX6kMtVZB7kdTK7F232ic77fM+vLUwwn+o4FRd9duoXYTajlKhUPFWPVLzWu4PabMJXO8n2o0sITVMSAxwEA6VdQaP1/1wTMhGrW28Bar0r9f4xeSMlZMKk6MigNnZDCv8RFDu11Q8E1qnFTYTjGz4t31xRkvlKcjgTtW9VIK7k0MmZ4841Mrs/n2A3UivIfmvnWCgU1/0dpqpBPw61pqpMh8z43jun6tVLjz8hY7noC902b6rgdnfqzW8AuKekgrOTqwgZP2Do9RNtvuHfrzZL/KFsy+LNblvvaaZ5ae9VXH6OpGiRszYkwN/rtB4tdeo3k241/HfBeSYGb7bNXDxq/LYwsRSJ+2qzpJv7cEEDi1CG4moPWs19/XvC
 Cbd/ZMv9
 //kTqgLjA788YksvxB1UJsK5hA/tFpQZk4QlWGwfCVt9kfRKP2DVtlHo7Ra6w0TnOGla9Wnf3KAOmT9HcjDTm1jC6cHrlUDBcBPxggfjE9Fo0cKzgdUqZ7lALMYsZCcQ1okLUGSzRRxM7MUWqOg5DfI9Imtiqe4851LZ4f63MEe15ZK62NpDcJr9PyIHMQIO3La6YydSdRv0I03HvC/MC+tUOr++xRIWD/2L0s+UVGT0b+ZEu7b6FkzBfqQelx6XUMEWVS6YL1MV80khErsvFZjPNhiizxGaoTPlpyGDdxIuEm2g57RCncOecPVzPq2sf2mggoPieM2366Td+kJxqB8novZv8ZimetUY2sndCUR0biIFVIa1MBI8xvZQNBQkJ41PBwYxpmfG0RQEwnX3gQSTYhMc7EZ+O+TMyDvBRsc19hcXl9z/1NPtX92vIOMK+4kT/UDtaVYSAYo6v2zfMEssMVxhngN530nwXba/uznbH/XRwZYeo15v/i8lzi2b10qH1MNnItdpHdKmBN+vIjPJZvFJTmNbBw8gYw7zlz1lF6nYD3wUTLdc2EZHtzOR38p5k
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

The series also adds selftests covering both kfuncs when reading argument
and environment strings.

Changes in v2:
- Register the kfuncs on NOMMU systems and return -EOPNOTSUPP when called,
  as suggested by Justin Suess.
- Add selftest coverage for reading environment strings, as suggested by
  Justin Suess.
- Clarify that copy_remote_mm_str() leaves the destination untouched when
  called with a zero-length buffer.
- Use sizeof() instead of hardcoded argument lengths in the selftests.
- Use ~0ULL for invalid-flags checks in the selftests.

v1:
https://lore.kernel.org/bpf/20260812111140.7762-1-tasos.papagiannnis@gmail.com/

Anastasios Papagiannis (3):
  mm: Add copy_remote_mm_str()
  bpf: Add user memory access kfuncs for linux_binprm
  selftests/bpf: Test linux_binprm user memory kfuncs

 fs/bpf_fs_kfuncs.c                            | 128 ++++++++++++++++++
 include/linux/mm.h                            |   2 +
 mm/memory.c                                   |  26 +++-
 mm/nommu.c                                    |  26 +++-
 .../bpf/prog_tests/copy_from_user_bprm.c      |  62 +++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 115 ++++++++++++++++
 6 files changed, 357 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: f79066c784022fda83f5936559a1af414e41b603
-- 
2.55.0


