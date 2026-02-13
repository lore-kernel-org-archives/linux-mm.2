Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405A0EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE136B0005; Fri, 13 Feb 2026 02:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5286B0089; Fri, 13 Feb 2026 02:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8D86B008A; Fri, 13 Feb 2026 02:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D53E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:56:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C240B1A043F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:56:58 +0000 (UTC)
X-FDA: 84438677316.28.10EE286
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E8FB20005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:56:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ES4O2rdX;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770969417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PyBxn7K43tB262vRN787nIuR5PwFQP146kux0JGPIU=;
	b=R5SGLzeKcFI/E9qs4eKxfxy/oF2keQQVwz0df/xyvxP1XtVNtrl8PjL7eCBMWwqFFaG0PK
	b9V7OqhZIrWEfLRB+zUZmapfJgSWFE6bpemfM7PvdGRZXfKtoebKJtEJqhgeWhUnc77VS3
	Et2Ol+e270ZuCxpdRPV+QqeKExtib2M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ES4O2rdX;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770969417; a=rsa-sha256;
	cv=none;
	b=GC3jOa73Z1PvOQfRkRLlwsbZSfMSBfwoGG1od4f91R0f9TCwZQ2XprKrusDxFtWU7XLE1y
	YnTyaAx79aGJvwwNBDRatEjBsVIE1uJFSbI4qwPwpbG8U0bDjRSHBl/gdAfiedA2eRTeL5
	IdYszbTvNbQdxTGlBOVRzbbkVT+Zaak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B353843A07;
	Fri, 13 Feb 2026 07:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D032C116C6;
	Fri, 13 Feb 2026 07:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770969415;
	bh=Ksw0hqi4Ayhwf33M+Hk7rydODnGoE7z6sHemjEQ9aP8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=ES4O2rdXCJS9AyDu3Ot580ALW9FC0Yn5MyYq8xtyxsKCrh+icFHLqS081duHsE0dr
	 xRgmys72IN5z4IA37aw5wzPzvpyqn2CSP1qEafGOqYF/FNC7/dCxrO1Xpz99bSWq66
	 ZTgkjOo9s+sgMHBoxMkgIg6w9+4PeVSVrYWyNt6P8QEYP774ahcPylmRUiZCQ41i3a
	 pLKQtF5ObvDQqD1PpR5MsT1t9dE6V1y3axPYsuo6qJr9QTHnElAJhwv0IPNUlrT7fi
	 5r91DiMbxYeua+uX+fYobQJKmXo/cRAwzIvcfkiz5c9I9qPJCZJAdrcjn974sVckd8
	 +kT5ihcL3jwng==
Content-Type: multipart/mixed; boundary="===============0586976686014415741=="
MIME-Version: 1.0
Message-Id: <9e26a97b0019726973b42c668185a64f588ecc2a0773dd683fd930eeef243470@mail.kernel.org>
In-Reply-To: <447797edc394ab8a8b2484bb6c92b56115254e27.1770965805.git.zhuhui@kylinos.cn>
References: <447797edc394ab8a8b2484bb6c92b56115254e27.1770965805.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v2 3/3] bpf: selftests: Skip kmem test when cgroup.memory=nokmem is set
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,zhuhui@kylinos.cn,inwardvessel@gmail.com,cgroups@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 13 Feb 2026 07:56:55 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E8FB20005
X-Stat-Signature: 83ewagrczg6obqnsudpkfawqb6neyso7
X-Rspam-User: 
X-HE-Tag: 1770969416-801000
X-HE-Meta: U2FsdGVkX19siuYj4WvC7RP+bjU1ssL/Xd3YYbjp8wfe9DewGJ4EmADsHNsUSYTRfGt4qc1cHb7a6O0GRMJoVpeNLce4a2Hlk05hcXG5dos2tlSGabzUL2J+yjtxzDu2/Rc2HqhGFk+tEoAB/tac5iHUVyiHxd3CDxVEy/6+zG+qzna9QRNamxFpiX8xNn55uv6T41yE2GYdkagXudfqVq+XkBcLtl+rtGBq0+Ujau08UdWGbwwsSV5H8hA+PrhivlHLLSIi44OK5OFoFffJVhLtO+rnZbgOYglJlCDkU3dofZVgPEanhTaFfDVgx21nERpmWw2otyS70VmEa33fZlduvcz8HWEtgIdR0c0045j55Lx8M27U2Q9bBXlob/1d77WYlEP9E6eirhfSPYrrmhRymsDbZTKJnLhw3j4+foY2LevuCjMohThLppwZ333TbWKSXCUWtGi2T2FA6xprzm0o8JCPehTC8UdYLmOqadVvFPC79ldamhLScyr3eEpop/BUrtJEae5uIhvJxCoaUFoxV40yu6vKF+ufByFYJ56Pf6p7CWC+y3x2gPxnlwXUAmkBlmm/sjT+P5eA0t0WLnDzovGBhE8SqsHIidQokXaKlbKoPD5FtDxqNwZKymTwRQZIfu/MJb0RUdGtyQj4TtyYEv0FOBtytgHmEGzi82w6fJffWVztgwnP9TwN8XsNBRvneI46Pl20PmFInx9JSygdxPhBhWUVVWYHZGy/1c/bMfgOB1CR+vl7VuyscNuBLoNKiHbH0Nog7DOO5zuIKkiRi53qtV/jQp5s3OaqdUkqiAfzauGD00YSENVPGL9WsjsdhqkowORHjagIWt6xJMNG1i30u/A69U6oQ61KIBs/PhmYhsi4Y/fWpFaaZhe3FEKIntcGziPr+4muXTqoNl4HumkaY5wCrXEFpmsG2sVtfVw1BO6Zl680ocrE+dn+s9Q1BedIGYc880UNltA
 RVzHKD6p
 HyGLPXffxBqKNLbazFD4KT09wpvTwJ6osDL8N39Tupq+mtYTu61ajc5yuLjni7Yh6rdQgMocBL95CQQSb9gW0SWV0j7eZka0gRCCSWR2KH9fNlunKQ9fr2h320t2Wyvt/XQBz/HDQfiCXGDfkbZzCMkCrE1r5kPNcxfOyZN2mi+lkTrXz0dNzozCmI/e4qTGgYGDoIIvUOPXp8UOpAAMikxV16GYiuq+Z5646+V6+bofS6bIoFlbmTOLm893UhaWc4B240n91JTwLErQMDgIj6AvaOIS8xoAmaV4j/FkF80U3h0TLdMWJdyjGyK13bM30ieL4tT4z8YnsqJ4ilOY/wdjJU1o5TDZbJ5AibL5s9Zd2PqcxTzHY62Ggn7da77yPZyo+/w4s+cCflVFbrqg3S0Be3qo1i5IJdjDMnO+masaIlyubHGOnhpQgZByPitDWZVuovtxU+DtGYYd2VQG80Pjqap0pHZw92G06n1g1FulFd5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0586976686014415741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c

[ ... ]

> +static bool cmdline_has(const char *arg)
> +{

[ ... ]

> +	cmdline[len] = '\0';
> +	if (strstr(cmdline, arg))
> +		ret = true;
> +
> +	return ret;
> +}

[ ... ]

> +	if (cmdline_has("cgroup.memory=nokmem")) {

The kernel's cgroup.memory= parameter accepts a comma-separated list
of options.  The parser in mm/memcontrol.c cgroup_memory() splits the
value on commas with strsep():

mm/memcontrol.c:cgroup_memory() {
    while ((token = strsep(&s, ",")) != NULL) {
        ...
        if (!strcmp(token, "nokmem"))
            cgroup_memory_nokmem = true;
        ...
    }
}

This means valid command lines include configurations like
"cgroup.memory=nosocket,nokmem" or "cgroup.memory=nobpf,nokmem".

Since cmdline_has() uses strstr() to match the full literal string
"cgroup.memory=nokmem", it only matches when nokmem is the first (or
only) option.  For "cgroup.memory=nosocket,nokmem", strstr() won't
find "cgroup.memory=nokmem" as a substring, so the check returns
false even though nokmem is active.

Would it be more robust to search for just "nokmem" within the
cgroup.memory= value, or to split on commas similar to how the kernel
parses it?

> +		if (!ASSERT_OK(read_stats(link), "read stats"))
> +			return;
> +		ASSERT_EQ(memcg_query->memcg_kmem, 0, "kmem value");
> +		return;
> +	}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21978734425

AI-authorship-score: low
AI-authorship-explanation: The patch addresses a specific real-world back-porting issue, shows iterative development across versions in response to human reviewer feedback, and uses standard kernel C patterns with no hallmarks of AI generation.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The strstr-based cmdline check misses nokmem when it is not the first option in a comma-separated cgroup.memory= value, causing the test to fail on those configurations instead of being skipped.

--===============0586976686014415741==--

