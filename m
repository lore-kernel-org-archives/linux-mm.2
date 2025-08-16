Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A12CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0568E0020; Sat, 16 Aug 2025 10:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76F68E000A; Sat, 16 Aug 2025 10:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB40B8E0020; Sat, 16 Aug 2025 10:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BECC8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:07:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EA5A1DD5DF
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:07:59 +0000 (UTC)
X-FDA: 83782799478.02.2A4F57D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A8BD1C0002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:07:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X+1Q/0t4";
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755353277;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uaxDkrC90fmKFDmTr+OGwUc637UVz7/TValI+Y8iKI=;
	b=JbdMhZs/eCcKrqc4NFGKk/fq3dHEF+zYYhxlB4nSKt2tfHjZvgVU8HI/wVHsWEnwAmY/51
	tQTCx3PkED6bE3/F6xWscy6E8TdRXIvgGWb3dwQQ2/KgdyIRyExDjk3XsDfWxnqNLeWxDr
	0O7nHwnL4lIZIo5f2GlF1hOhIR5M5BA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X+1Q/0t4";
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755353277; a=rsa-sha256;
	cv=none;
	b=IL7Q+CdI2DPQJO5ScnxyndnMXKdobrg+biXpBeCCBEC09He0waDYgx13F4KpNtytBEDhs4
	DcWZe8ZToixBbOiiEqNolI/muoUiuWdGJZpns7Yb+laY2pTamwsn9ul1CRjoT/VxOyMcsa
	p13Bkrd1+3jvMKUyRREWd24Jdu55km4=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so3751429a12.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755353276; x=1755958076; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uaxDkrC90fmKFDmTr+OGwUc637UVz7/TValI+Y8iKI=;
        b=X+1Q/0t4kLY/j+ruhuqvegNKlJ99BCPv03Df04eeGUAZMB/2zH5kYw8YOgqmAOU0+s
         oqNjA7911N/rPnz66aOGaFRrsFUhjxqt0xVINkzQtONO2jWdB3uI/Bvd6ZnxPzGcZbNN
         8/7uvO3iK3YYbuqR41uIJqRpJ6RexFrvljGGsRmLpnvrSfmXT5nEBnTVoMbDARk9hJr1
         pEPaL4wkj3cwlWpJ+dtV1ISZm3/mV+zWik8gIanwnxid0mdkXIpGQ4ZBhbo+MNAI7cbz
         An95bciPIgXH8aB/raEdqy+QICs5al7kaWRVKjjyIAlyW4l95R99QDdie1fZfpszWfza
         4Ulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755353276; x=1755958076;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5uaxDkrC90fmKFDmTr+OGwUc637UVz7/TValI+Y8iKI=;
        b=JIzJJg/GNUlkvbHeKuKJMm/stWY/toPE4wv9S6jHfCHwf6ozWZAWGWJKN0L1uBPG+n
         ZqmmjPSs7MwSJ0HiKnQhNx1r+TIS9Cuf/OReIQACNwj2avoDyKMpkZyY0cUJ3HfdUCFA
         5EIeq3KXfufHTxwdPYtRYLN3FbpiMKZJoHs8vLsz1ik+A/ew3tl5gSwcF/vtZGGvm2mH
         T7hXTBQ07Xb7G/l5wzvXhIYJ0xMDTORiCP4svHaGJXzJS81SgPVXcBTWIbBIz4nzj2/G
         92+lkYTjsGgHraH3rh4RRhek8Z0J4HooWd/oMnd+J9EGFbO2YtJ0L5zAPdsN2yv3mIKn
         Wd+g==
X-Forwarded-Encrypted: i=1; AJvYcCUPvF9QRk9MjoZDghl7oVc/yYhXydANnry+iT7O8iFNdT2Yxboy05JFOcJcO0t5c8YeeDu/VvRMcw==@kvack.org
X-Gm-Message-State: AOJu0YzcHSBiEHmzDOoPGhtYnowihK50+9Lv8xTJrxM/nnqR/mcorLyg
	XApAPVay1niNfxlUQaPtXHEIa3qLU8EcFOcf4ZzpclIAiHzqebIJ5e40
X-Gm-Gg: ASbGncuhICoxinqjTuqyN2gc2zinYR/Hh2aYWGtP6Dt8uMIndbtuepqlUH4E/ft+W/+
	5DoX2R1vFuCIj/I6vWQdkTjzRBxdBTob08z0ey+7H7LZ/l7//aurb1JfOm1+mf0RWQ4bhCeFcAk
	67cLL+jT9vlaloDnYnfxzpiwfUsCiRoSl+lXFUqFSyrHQXmok8IHmQ2U4V8pbp1LjN7UTAg0yhR
	4GnYcp6qbCScvOU5f+4Odf+6dDzSU0U0miXj896z2+lV+uAyA608HKg/O+5kNWfheHzyKrB33L2
	ujG/N4u2vKPrqeh7hgqlT83ckJiB316WTPY1ybZ0o4YEllV6k9Xx5CQ90LYYr5Fvvkml2vk9EiZ
	xYTVfjJznVD977su3qJtNug==
X-Google-Smtp-Source: AGHT+IE1b/Pj74re6G/Q6vJ6st0rdkU7h9PGlQizm286SNk7tjVfBDAwwmFTOY+1Vb+2pSq1IfaDTw==
X-Received: by 2002:a05:6402:2681:b0:615:a201:df41 with SMTP id 4fb4d7f45d1cf-618b054fbb2mr4471169a12.22.1755353275548;
        Sat, 16 Aug 2025 07:07:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618b01ae4besm3499692a12.38.2025.08.16.07.07.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:07:55 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:07:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 3/7] selftest/mm: Fix ksm_funtional_test failures
Message-ID: <20250816140754.tgkn5kwf2i2oe7va@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-4-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-4-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A8BD1C0002
X-Stat-Signature: 3d6yhk9tzp4c66edrio9s9abzddikxcb
X-Rspam-User: 
X-HE-Tag: 1755353276-371410
X-HE-Meta: U2FsdGVkX19mcM25952/696/TWRdE0Bdb2ykQel6L9D7DWAruvA5QumH+2zWh2Y34HrbDJVu0t6YUHkSRaBb4Z7kN4/3Yrny3uypHNR87ywMYJbDHRvKuTUPiVjaBykWxLpvZBnc0p7+PHwzfJYP3OrjRWJrk1MGo6hUHZzPoZZgvn2X84JnBNaumyiQBbutmsaJGOUpUPkQATI2OzRt6Wboa07qfy1ZSRp7Ph/K7/pgUgsXhX+/RCoWOzUpRdiDJwQzS74O+jQpk6B7NKv5X9RT1wLcmOr87oXSNUCmmufgiLvb7kgdKYPpPzoHuFwZafn2WteVhn2G4BXRF6R9JySMC51P4PZyykNpt0VYOTMrOrDJJ28x3KAlcCQM4G6Gh5pC4bSnnTKJA/uKJ7I56RH3LPUw6sTgkuSwVeIw5Zxwd4gf0hgAA6E/LPml/u7tUi6zveyj+jgmWI2WlrKD6YSSYC9X/Lg4uBNIOzVZelAPeHwkY2U3yhLWdQd4ZGyHUuDIZ7TzljtTMoz+v9zzm308aq12Dpogd4kIvUUWpr/uE9OXka+nvDwpWIqLcI4f0y3yQGpJbjGT99oLa8GojotfjU9FqL944Kn8H3sfnNLsYlRAYq1184bsHb6IotC5jTa1dTxfm/gs1pxfTmadRkOeTGITulAZTrgQVUgGmZPkYv6G+YSWXmV43tn8ljbsQYk/+AOkD/y1ANbmj8e8lpytcn65IEBPMav5h4X3WfH9WsiLZHzf5mOCOX2uzn2KWhISHk54r7SJlEuaP9AkvGiqcm5KUovJlm/p4mTimaqb291uQtPkP+AWo6BAfma5y3ybyV3hx/mFgl+D2yMRSq43zApQ4Bg92htdA0724HNjb/Gh64FtN9w/Z5LtPyeN2rZJT9Eom12f9HqBE5dsA85S9zMLzaKNy/N6a4obTb//59gVU0QYCqCfvdFLscGu9lI2KDxVs4BrVdl15Zu
 9GY6X4JD
 Gm66zJJ4/odb3yaRV1MiS8ejzz3rVfhD2vzPRkeWpFixcQjn6xe0KZQUzGEHDNkP+v24YynvJ2EoJ0WPXKkepU32443OwYV9H4W9ewy+sKrvePQdq2pbzuhhBJi5rCnYpmCeOswBnRsEeAmMgUv5Qq8VS4tPt9H1o1ST5Wl44uGY+KmTLgLrJtWK8ZrL/wQdwwugtgTU0o4pxceG4EKFjtTZLrYbBT4Kb5gJLzoGs7EZURZW3j1IpdsF6O8yduqxsEF271gJ25KzUJNSrCrEklxPqNQcUylzSq7nQXoUkYaCzDH1mwa4cmtoQJUrVPkUDSQQmDTmP1P4OdVHP9IA52ESgmYngx1LK4jm5ie/4ZsWyQQWYI7ZbN25B7DCnHikTGncUdXfcqgx6V82EzZ6ND7hoUcZo9Ed4tqhr8MkgAp7u15FeHVjtFLg9IciuZQjyc5tS5VyFMmDf1ZnX/uX2m1NhshAq4AjvGVC0ZSz0oGEi2LjhPoNIqdIFl5h+K7gwHUu8sNsMdr4l4lavkUULrKYegoUK4QKt+uTEMTxy4uvrhrN7g6uC2lD0MZr4jNlhSXVn5PlCFTOBaC9Mr8CPH1lB8tCKkrrG9r6y55eS2hx3JJMf7s0Zg8OW7Ac1v7KBgQ4pB8gHAl59nRi7BXt9mIxfW3eFQvAsNWBRZMxa6Jo1XttxKBDarzpiMLftJH9gHGSQ8B5p7LIMTNsBh1kHUGnZFOOAphlX/YmROwKEBkXrs3i2J46GHwrjxJ+qDU0XaxYBDfqrwHqHHAu+gmoRlxGa84JHeH2YL9rQrhbFunRfGiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:09AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>This patch fixed 2 issues.
>
>1) After fork() in test_prctl_fork, the child process uses the file
>descriptors from the parent process to read ksm_stat and
>ksm_merging_pages. This results in incorrect values being read (parent
>process ksm_stat and ksm_merging_pages will be read in child), causing
>the test to fail.
>
>This patch calls init_global_file_handles() in the child process to
>ensure that the current process's file descriptors are used to read
>ksm_stat and ksm_merging_pages.
>
>2) All tests currently call ksm_merge to trigger page merging.
>To ensure the system remains in a consistent state for subsequent
>tests, it is better to call ksm_unmerge during the test cleanup phase
>
>In the test_prctl_fork test, after a fork(), reading ksm_merging_pages
>in the child process returns a non-zero value because a previous test
>performed a merge, and the child's memory state is inherited from the
>parent.
>
>Although the child process calls ksm_unmerge, the ksm_merging_pages
>counter in the parent is reset to zero, while the child's counter
>remains unchanged. This discrepancy causes the test to fail.
>
>To avoid this issue, each test should call ksm_unmerge during cleanup
>to ensure the counter is reset and the system is in a clean state for
>subsequent tests.
>
>execv argument is an array of pointers to null-terminated strings.
>In this patch we also added NULL in the execv argument.
>
>Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

