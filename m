Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4914C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA02F6B00DA; Mon, 20 Jul 2026 05:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C025D6B00DB; Mon, 20 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2D96B00DC; Mon, 20 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA3E6B00DA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 034721207CA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:49 +0000 (UTC)
X-FDA: 85008645540.10.4B91C63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38F5C1C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HnHZ///A";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAAiNP5sbEBPejy0XpW4wgSJa4O4wifezU7doCgFL3A=;
	b=oX8G2ODlDPpgbH8U8thM13ljo5cWoBS0ap+hhaZeCqzndJNpUGfkJtRAtHD3tpDW0tRTZ/
	gttMl/0QsMpbDYw4MmmVT+gYMcU1rt5MaX4Yv6TkDVayAyp+vPlk57CR2tBVR+1Ss6VpUi
	wINbHbpcT5lPZ1zvq1N1H4hgxQ6ItOw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540088;
	b=bomllOP75FMjIn2PEUO9QVYvMiYYKfRdFshjN2NU79a05lHyr55o3M65y/G1NWrVmf+JZD
	MW05uFXh2OdtKcxxU2rWSPvi4iVr+INy0C8Mb2mAptQmf0RmSHWMyrzU+X7d9kOKV+1QEf
	5yQGycr8BOuaffnx+rF4rjRkoXJiSho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HnHZ///A";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8880343BA4;
	Mon, 20 Jul 2026 09:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DC1F00A3A;
	Mon, 20 Jul 2026 09:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540087;
	bh=FAAiNP5sbEBPejy0XpW4wgSJa4O4wifezU7doCgFL3A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HnHZ///AFPSNwS4w0n015817chaT6GIyVDdfBMt+eiGmKS7fzL0fwjE9p0zkgIWW7
	 KxQwji0T8qbw/Hka0wWqZnAVB4kQZldXtl7RxyJgHY06hTxejp2AToH9b5Na2RtlB+
	 1yFMMdrEDjBd81bJKLZl6xL6jrDTA3AWPsMnbqiYhebbtTVjqfHOJWTVoX4YDG6BTt
	 zA8Wr/Pt2WfS2F3dMVaxoxoi13zGVS+7GK7cNLUA+WfFSjimV1eUH+wyKjIIWwPy5c
	 WbCgK7GvkACgLASBdDYLrloFJTbL2TD+EizCuJOt+wkMQxQtGd8mgqC1w4f2n8cuK7
	 5q1ua8Dcx4o/A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:38 +0200
Subject: [PATCH 15/21] binfmt_misc: document the transparent identity
 contract
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-15-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2352; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2cz/Uon2cc1y44sOqIk8MHfFBV5eE11DUXnjL3cZ21o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm7qtK9MuPohZQm/d6czw3yHUAeXT6+ac/aJWtz/d
 kQz8LBtRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETCvjD8U74v7+K6S+FQhuKd
 XScZZt7UeZms2T7byENUfGNG1xHGjYwMvwxmma9iut0fJ6/FdzFjB3P3lVe3G9c5vagX9zgrUST
 JCAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38F5C1C0003
X-Stat-Signature: pu4iybicw8xbtmi4m5h1t61ahxogc4yt
X-HE-Tag: 1784540088-300159
X-HE-Meta: U2FsdGVkX1/NcZ/56YIzZ7aJBF1Y/CBw8/WZfdCYNnIco3bqfLh/nEmAYtpdj70RTQ7nCl/8E4sh6PAE0FY3/zBxbXS22fpZwZBqXCx6fULTBQ3czYjrXsET5yUnnEqiZDDmyJcgmZZzko+NVl9e5kffy5UXE4scHKhtao74EfFAZP1/3U+q48jKdZw+cfLuGC2izhNKs7B5flezgA7G6cj5hZZXDihe8OogLxyLk2TlvKuFmgiaDpxQPNEAQS0RgSI6VsNKYwe/qR+hgPg0D6v+WMAs5ljWFFxG77rtSdSECnnHILqoA6Bi20tErXX0V581ZXT95Tkrlvu223bOhe/k4l5AMhW8VLeJmDze7GCYjjUigVe/9kWWi5Kq4a64cWPC3OwgxACQGSP+17xIUlt5VVPZ6R+vCPehsDBzuqmRFvVZfo0HniKRAa7m4cUw+epsQ/XgsI2HMo8POzrQ8ZltOxoS2GeMpSWoeoXFTEt9OyAwo/6ztrrWHa7HzUJAQS/weX8GCkal39hJZAe16r1kvtkeIW+ZanWnMjXGu3v3EG+Wslgyncn0oDuUFULMoZE3/SwLCmLOk2w82qGlAooZk0jVgy5hj6BRbK9zkqeY8jkqBFzadYFESt6XUkEUCP88dftDQzlDye7+PTe+QKc3j5p3zBRFX5HExvqOLhuEPtMYZRpgxysTfmpcsgKykH++N44cs8biL+jZEl0mxCh5w/V03uUiWNQ+6QeSMicmPJIylmopKuUe2CNsqBOqckjqougjeO8oUDAXuBq/VRCE/YW+BdXkc6K9FXM5bulovM1ZflzibIMgDkulhC3VzzTYqX6anEpdoGS1mF6iJnePEQoCTS9OhEujCVynpZBgG89jITLdQWqdtWMx2T1s+x7NmIt+cZiSBFcQToQDhY04pKP4640mTt3qOdjSc3rffV3Uy4BH2aJ0Uc1QP7YRlxg3vHZA1wCl/VNZPf0
 P3eHLl9c
 dpwxEYLgU/035lcL58A1cGz2KPMWk7VzvnYqcmwqy1cPjZ1F2Qw/fdrK9h6hNZihq+9d/D1TyhQLOwnJxkOlBbeR2GPno9L3KsKikaHP5W7mirxO5+YfOoenMUrNkkOewv9VdVjscRo3HaJCdRevtGy8UXePjj7Bq/5VyLDk1Jl5Vuv8cEAPAA9ZeDfYKQebuhOSvfJMyUreT7QZDpdvTzM2ZDaFsCNLXp2dZp6LHvIjeCJYvkfQ7eoeEuxGI9kkXKRlBaFn/iLrlf+w6fw0esRAU05aauoDpavsZvukTDLuLPj8NRbZYeFTl27vLB2BvLkBq3HqYC3RmSCtJlfyuW4Kfzn6ClK7Z8EyJP7Q9VIwKm+fjbFKvpXTFOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe what a transparent dispatch constructs and the loader contract
behind AT_FLAGS_TRANSPARENT_INTERP. Also note what deliberately stays
different (the address space layout) and what stays unchanged
(credential derivation without 'C').

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index b27ad31847ab..0946ca1923f2 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -218,6 +218,31 @@ binfmt_misc instances themselves are looked up. The entry keeps the handler
 alive; deleting the struct_ops map only prevents new activations.
 
 
+Transparent interpreters
+------------------------
+
+With the ``T`` flag or ``BPF_BINPRM_TRANSPARENT`` the dispatch is invisible
+to the resulting process. The argument vector is left exactly as the caller
+built it. The binary is passed through ``AT_EXECFD``. The kernel also labels
+``/proc/pid/exe`` correctly. The binary's file is write-denied while the
+process runs while the interpreter is not, exactly as if it had been executed
+directly. A transparent entry does not change how credentials are derived. As
+with any other entry, set*id bits of the binary are only honored with ``C`` (or
+``BPF_BINPRM_CREDENTIALS``).
+
+The interpreter has to be built for this contract. The kernel announces it
+with ``AT_FLAGS_TRANSPARENT_INTERP`` in the ``AT_FLAGS`` aux vector entry
+next to ``AT_EXECFD``. The argument vector belongs entirely to the program,
+nothing was spliced in, so the interpreter doesn't consume arguments and
+simply loads the program from the descriptor. The bit is also the loader's
+license to finish the identity. After mapping the program it may retarget the
+``AT_PHDR``/``AT_ENTRY``/``AT_BASE`` entries of ``/proc/pid/auxv`` and the
+code/data statistics markers via one ``PR_SET_MM_MAP`` which completes
+what attaching debuggers observe. What remains visibly different from a direct
+execution is the address space layout. The interpreter occupies the main-image
+position and the program lives in the mmap region.
+
+
 Hints
 -----
 

-- 
2.53.0


