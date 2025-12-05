Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE626D2CDF2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1E46B00DB; Thu,  4 Dec 2025 19:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9534D6B00DE; Thu,  4 Dec 2025 19:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4EA6B00DF; Thu,  4 Dec 2025 19:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61E766B00DB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:58:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28E9E1331EB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:52 +0000 (UTC)
X-FDA: 84183607704.10.3C256AE
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 656B440004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZWYoQZEs;
	spf=pass (imf27.hostedemail.com: domain of 3SS4yaQYKCL4ezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3SS4yaQYKCL4ezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVE0N0KUpY0wO1fMUhmyg8I9ioeDz1sYwcQ5NNPx/VI=;
	b=lbFMkOBSWXHCReEOtXoj1mam/tnybujFDyYO8c6BPJZYd8Wvx4p2S+/DvEpjjzEhXjly6A
	IIP4daLiIf4QCMoCZasZfL1dlKdy48pPjxDU3YIXLEhevSdPux2PuH2tmxtrUXgOTDYQ9z
	qFMQrCT8AtnDFrPVw938QHGxs2hE1n8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896330; a=rsa-sha256;
	cv=none;
	b=p4wZpZ3s26x40gCWcOeROBab/lAVYEPtbpc5bXOtAl6KF0zNSz/IurUWEYehyhXAstJzud
	W7u1FsnyGDgXNfYG/iYVuAoDUh2EzOs5zIx99XyCCPDneZR5a2/D4qn0x4J4JOhGfJE2Wv
	+dQXwoaOE3wYoiq0oPKZxVFUo3gbrKg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZWYoQZEs;
	spf=pass (imf27.hostedemail.com: domain of 3SS4yaQYKCL4ezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3SS4yaQYKCL4ezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-450b8303c1cso2153395b6e.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764896329; x=1765501129; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bVE0N0KUpY0wO1fMUhmyg8I9ioeDz1sYwcQ5NNPx/VI=;
        b=ZWYoQZEsbUbpGvDOG9vWIBN+lKyUjjUtWQ/mWxiPYEc0L6ZQkuTVrHIrilzG+KMz8/
         Ldy3mGWvaJSSU6GJJOk+3KBplRcErkb2TIQ+gpf7Or/tyabhBEJTEk+KUEgkw8s8gdin
         Sz7etf+6N0OaO5EtQAum3gy0VsJAWTb/Jd41xvLdUEhWLagZdUTvAAD7GP5rJQWaKf1K
         ymfm+OGcJ2Cv4KbmURTnllFF+yI6F6OMQGT3N4zhtYp5aovo8f1HeEafeyoRYRFlFI9O
         5P6mG8qQGYI4ZyhUYSF44Xs4IIrFgdp8NTBkrYV/mPCcWHlHhOvWLXBhWzvAd8e1vAV2
         j8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896329; x=1765501129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVE0N0KUpY0wO1fMUhmyg8I9ioeDz1sYwcQ5NNPx/VI=;
        b=vyGKxRxA3CYOjUyqdTihp+ebvurHM7xbfj+LK/U/bG3QjHylFAJ/gkaMaQ0AtgJ4Xm
         mxLMiJMIj40ppyebcQ0z9AfKkFrSX+vRogJ1NaE6750QaZaOG/1rFu0b/tp2idqDRWQ+
         hXVPKh/sGezsdFOsumTHr8qCddq82xRtv6nV2ylfFQoObqeKorDxl9M56452ah3Caa/N
         XdwTTH+agehif94LIgLPRF4R17Zg00HgCTxL87K4oqByUkPMBITiX26ln4+BkGLx6mfq
         3Fs5i2Cz/n7yZRtuv7eNG3kEjQBaoBheLh42g/UdnJbzvfvf/2jXLx3/msFIgg9AQqUC
         lb2A==
X-Forwarded-Encrypted: i=1; AJvYcCU/0Mh4IYEWBbQxAm19gnhGi9x5IRPQWC8HQCAMPrx1jWqfRjOtXLQyKFlGbsKWbL7u+DR6pmGVqA==@kvack.org
X-Gm-Message-State: AOJu0YwNK5NVBxi0UD9O7MWx7LhCqL9pujhI7xWJBxRTsD/UMWWptWwW
	w3r81wzPsaBqFYm7XZ9PnPBcqWWHxmOf6EQ+tYqkm+cYUJTsRcHKvzfgGIaaha9o/M1g9WSsiK2
	yeCiLGQ==
X-Google-Smtp-Source: AGHT+IFifApyQ81uqcVNp3ozqjh2VV5F+exYOtd6RAsz1O9td1lhZ/L2nTazk9kUzTzPa/vDQgHRCZrkH4g=
X-Received: from iobfb16.prod.google.com ([2002:a05:6602:3f90:b0:949:11f9:31f7])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:11c4:b0:450:b3ec:c154
 with SMTP id 5614622812f47-4536e3de299mr4587772b6e.25.1764896329505; Thu, 04
 Dec 2025 16:58:49 -0800 (PST)
Date: Fri,  5 Dec 2025 00:58:32 +0000
In-Reply-To: <20251205005841.3942668-1-avagin@google.com>
Mime-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205005841.3942668-5-avagin@google.com>
Subject: [PATCH 3/3] Documentation: cgroup-v2: Document misc.mask interface
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 656B440004
X-Stat-Signature: mpxpiskuaakxkdjjqw3718u5xdfgbgsw
X-HE-Tag: 1764896330-149488
X-HE-Meta: U2FsdGVkX18RE/KIKHDu0UspIfUJlj1WaIjk2TJ/Z/98ldPS8pbpghz088aAfDhoR0HtDOHmMnNQE8ZUd+RrqmfZAHoO1D2yRiareEri2PGhc+IGxrXISg12+c88ibNEx+kUp8LG4NiZ/FI6D1LoWlRAKjlkXdgg2l047KKixjXrn/pXLvZx9ACpDy0bzFfn/NNJ7cn6vKpKR1EXW0UkyTS/FhEE3ff8/6TDeAthB1mFYtP7FZfIaAD0GOlekY5uI0XTuC/xYXQLhgsf7uaW7FLqa1a7Bn1Gytm0yQV+MJjTex+RyU+eBK7IiWJ/rf84lCZldfJtZthT9HLkDShEmqdgSa2QDV8EyeyCUhx4ZnWFndOqdPig0ZvA41izGmLmG1EL7IJhdyYaZePfWV8XJxWguUcPc8GD6hu+4EvE6mWtyZKgeVL3RcZUwFChz1sPkWP4w5hp7yE0UZiIXVbsVRXQgbRTKUi961ZD7neb46x2dBlPVPdzKT+4/MN7UxSRoESQVeVOrd/MRxk5g/WWL+yZbOOXhSfO6+paSmyb+JzUanOAvNS3OniEND18/niWEPUKoY4l6opcLFLwbkiYI9r+EdbjiLsccNke7I+kBzREzSlQf5Y08eiGMbWiqTbJz/XgYK8ZvdyMmpebJLo1aVFpawaySGUhLgTBef6HCmJBpI3NcIbDS5ikwspXmqmHWq2KouHpVU08KN+HV3b47lYdC9nsGeepCCMoL2rDu/TzP/oEISSjNM1YClOk7dCCaZiNwp0hZhg2NJuSS3oyH/NvQg1VcsPjGFRo6VUr/ixO/hJuy6gNKRf50QQg3rEc9tunW6Lgxc8dXR0Es4HYYWVA4fgDn/LBty9o0PxgaSNQlZa7Vke5ZgXK3MbZdQf0YvDDjL/5YckMU4TFr+jZVu0yY5HQmnSMt0vWbkEO7RZa8Bdq30ukaQUJXCozJbnSkcQ1XMIlyT7/0T+QKVq
 oMsFgEBc
 BwDa+cesfhvxJl47RsG2UF4iFdtNNzE/Vx4/Lby242Lfi8LGLHqoYL0JCMUTTRAz7p0lSh4akrHY25SW6MLB/lWbe9Q4u5C1Q5yyVY/EweeGnW+aQ+DokvbKwCumJNjlfxiOhMAc1JiIuovnieLxQ/FLFgvPyc7/LfsWlkQaLDntJb/2AypUVQPDkB0Bt1ihqJum49Y/TCngZq58vNigxXmSJCp6aswhpHt16YEcQZcZ5tiwUuLVsdP8xGaizkkQaffM11x4yXsPuti2pS37bqciP6A+xsyZXg92GCvCyVAB/FtNe7GyykC6VyKMFw+JwHgnjAa4WqCCmrPibXSKDSCQna8EfFI0vjaG1q2gJlVMzu0phCaHSnwzxGu5w+bh65mAbTS8uKoILtbO359Jg1fAFc8kdoGkxvKq8yEoCZBqE0BWor5RWj8K+NewsU1ca48rORn7Jjb34CV3OinAgDX39pleEnKARFLnDV2IbmUl0I8yrx7VN5h9XnisTBoDZmjRBtPlD5QtZ1CwuDSOrcyQv9mKldmCLCd5fSUMs0zmm4Sg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updates the cgroup-v2 documentation to include details about the newly
introduced 'misc.mask' interface. This interface, part of the 'misc'
cgroup controller, allows masking out hardware capabilities (AT_HWCAP,
AT_HWCAP2, AT_HWCAP3, AT_HWCAP4) reported to user-space processes within
a cgroup.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 25 +++++++++++++++++++++++++
 Documentation/arch/arm64/elf_hwcaps.rst | 21 +++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 4c072e85acdf..9d9d923e0d4e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2924,6 +2924,31 @@ Miscellaneous controller provides 3 interface files. If two misc resources (res_
         cgroup i.e. not hierarchical. The file modified event generated on
         this file reflects only the local events.
 
+Miscellaneous controller provides one interface file to control masks.
+
+  misc.mask
+	A read-write flat-keyed file shown in all cgroups. It allows
+	setting/reading the masks.  The file format is a series of lines, each
+	describing a mask of a specific mask type.
+
+	The file has the following format for each line::
+
+	  $NAME\t$LOCAL_MASK\t$EFFECTIVE_MASK
+
+	Where $NAME is the mask type name, $LOCAL_MASK is the mask for the
+	current cgroup, and $EFFECTIVE_MASK is the effective mask for the
+	current cgroup, which is a combination of the masks from the current
+	cgroup and all its ancestors.
+
+	To set a mask, write a string in the following format to the file::
+
+	  $NAME $MASK
+
+	For example, to set a mask for the mask_a type, you would write the
+	following to the file::
+
+	  # echo "mask_a 0x3000" > misc.mask
+
 Migration and Ownership
 ~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/arch/arm64/elf_hwcaps.rst b/Documentation/arch/arm64/elf_hwcaps.rst
index a15df4956849..5526daff5d30 100644
--- a/Documentation/arch/arm64/elf_hwcaps.rst
+++ b/Documentation/arch/arm64/elf_hwcaps.rst
@@ -450,3 +450,24 @@ HWCAP3_LSFE
 
 For interoperation with userspace, the kernel guarantees that bits 62
 and 63 of AT_HWCAP will always be returned as 0.
+
+5. Masking hwcaps for a group of processes
+--------------------------------
+
+The misc cgroup controller provides a mechanism to mask hwcaps for a specific
+workload. This can be useful for limiting the features available to a
+containerized application.
+
+To mask hwcaps, you can write a mask to the ``misc.mask`` file in the cgroup
+directory. The mask is specified per AT_HWCAP entry (AT_HWCAP, AT_HWCAP2,
+AT_HWCAP3) in the format ``<HWCAP_ENTRY_NAME> <BITMASK>``.
+
+For example, to mask ``HWCAP_FP`` and ``HWCAP_ASIMD`` (which are represented by
+bits 0 and 1 of AT_HWCAP, so a mask of 0x3) for a workload, you would write the
+mask for AT_HWCAP to the ``misc.mask`` file in the new cgroup directory::
+
+    # echo "AT_HWCAP 0x3" > /sys/fs/cgroup/misc/my-workload/misc.mask
+
+Any new processes started in this cgroup will have the specified hwcaps
+masked. You can verify this by reading the ``misc.mask`` file, which will
+show the effective mask for the cgroup.
-- 
2.52.0.223.gf5cc29aaa4-goog


