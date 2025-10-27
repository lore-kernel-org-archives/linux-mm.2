Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE23CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E508009B; Mon, 27 Oct 2025 19:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5F5800C9; Mon, 27 Oct 2025 19:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30AA8009B; Mon, 27 Oct 2025 19:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF8118009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90DEAB7C55
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:28 +0000 (UTC)
X-FDA: 84045535896.02.804EB14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03ABB4000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ip4AuaoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s19m8tgEhDYzZU/Il6ek5ULFR9AunFHrycMOW2w6B+I=;
	b=3TbV/q8Yzayl/tUg6MkUAcJh59aZWU9XSpmyez0TtKvBsFntDMWC0ve08r1JbZIeJaPjax
	jvuhAHvppRiLj/6l7N12LCoHpADfss9dX3GaFdyvoT/NM6skiA4FC2jk8kPOLKWVgpZjIU
	VetOwMDtAyN+2pE6A9z6Qw30URcUU70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608907; a=rsa-sha256;
	cv=none;
	b=k4vCLlf0vP3DEugOEypAEDXcRcqRAEn+l0VxaYgRvPvv3Ji8c/hfvMuWlF34ZiJwJM0xYj
	0Dkv5kzBiXs4PUYejboVWuFNMBQep4W2vE2P0f6l6TxJ6UEeUyFuHrjxInq6sx4G3JxlQp
	bzpvQ9FExDveQX2daktXByBhDYNiI2A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ip4AuaoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 897396058A;
	Mon, 27 Oct 2025 23:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E68C113D0;
	Mon, 27 Oct 2025 23:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608906;
	bh=Ymrk/bnWDm2vxd/nlsLHXR0AGQ17YZKwVmvB5bIG/UQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=ip4AuaoNa+2WWxf+izH396ZLhnsd/7XBE26w4xIzGTJgtZn8K932+c9sMUNuwAqkZ
	 vcMLNsWCbeZsH7HhNPpueq2Oxeum7lgdSqilydy4isaJN8WGoEuJBOuYXkndDByQMl
	 up/nvZDWqorYxBwD2lv4mmIeGOae/TQnDS8uzehub6NKnu+GTspISnZNiuYlyqRAN2
	 dI4bogd2tfpkKHRXbuMIaMgbf0aogoC/p/9CXCjdAFRSiI8VT6Rrfxux5RjRnJFiNU
	 +hU/AOHoinvhfn4LDK17radRPA8GQ1MzFt73YBFVND+Y2NxW6eRWtDjdLSdAgMD3jA
	 f8PWukPa8bvFQ==
Content-Type: multipart/mixed; boundary="===============7910205454797298679=="
MIME-Version: 1.0
Message-Id: <58dd6b759499f212f626e6d7658dd558b3e6a334e0780898002cb2cb84dbcb85@mail.kernel.org>
In-Reply-To: <20251027232206.473085-7-roman.gushchin@linux.dev>
References: <20251027232206.473085-7-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 17/23] bpf: selftests: introduce read_cgroup_file() helper
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:24 +0000 (UTC)
X-Rspamd-Server: rspam01
X-Stat-Signature: sgntf75a6maifwqk1g3gyozt5quajdgk
X-Rspam-User: 
X-Rspamd-Queue-Id: 03ABB4000A
X-HE-Tag: 1761608906-220279
X-HE-Meta: U2FsdGVkX18y0jT/SfgZDWTfdo/k++aizePmMsinl51tytrMlTJArb9ziM56Y03LomG83+sf/MOJ59PhgvXWUcjwWMwUnB2ZGwmtkXMGVtDxPtjTjZ1RryKwdIKTw4i4hip+WQ07z8ctq4pROAnVfHwS/3CrZz5XLI5e9A9Z4mlxjybdbdLO4CTcgqEGX84sLfuWuwsC5V6nqXtINCCZV7b0tWhxFDDH6BpOGzBlyNAAuO83brmIuU8XDEQ1nxCIO5cEvZRAwB720xbTJeJaoX4Pqo07+DIdgwlWiXE9+ptbozmETEXAkARDSStbgyOWdUWxIjzsiXWOWhKiP2x2Z2QUuEXl+JTi5fj530+VhhwxhVZtNPwzrgd86dt/Fyp6wnsWXc62cTHWJKzrp3iCIYj1UoXOYBTqDK474WWWnWUMlZljA40m78yOklobcA1+IGVY97jPe+fiOM8W62PXNNkxfvHYxpTWf/SaoDG4Tlp/vTn73+eZkM6KLTyI8wypmfdlQqRRrwg1Fca5S0YZMo/rJkMsuEYdPK3ed6qJiTvmMZu98bTxYzvOUCFz7PHlMJNGGC3iAymgkcnjczdUfOhuAWz8sE26QlLjc16TZbyl0bP3MCAFSOnOBjdL+Kt1FnLrFaEU1jqGZMA+Y+qKY/Ys+vTGpl1G74A+tphGpMcbw1AKmrtMwCw/MOjB5ZZ1nCueTaZm8b9/3edzmdAI/coRAY0WlK6+f4zQhc6K2GZNkAjD+yp6MCMmbt9JzOC/klWrlA/QPKgWX5oRLzjX2eyOMZo1uO9B/el5wIAPXHJxwpHX23KlzHIiYfNVuv3w+Q4qNL+zsODx79LEDXe7Tvc2LoaIzl/2pCXwhr9k8GUwj6GRjyFjeCSUc4MOc2c/b5dyydAR3kPw/3RmxlwCqYsH+ZaQvPICuMzB8N7FyAOR/76d1PqNZdE4WdA9YwjYW3Yh4TlA/U0ZN3RGNhm
 j620J639
 bOqDvGRYXeoM8UjltiW7Enp8tkoEcoBRUa1FAOulAU3RXlzttSsNt8hNUwuAHyL40sa5RFuOEJBy1D/Prz8zPBOjnnTVj6XcxqCOf4Dpm+Y/aywqX9Y5tEXu3SYlcJIdaX4MYmcenn7hbnQyrlbi4RQjFoRUpSy1aceBDuJb7zQNQFPFDdZ2SE+cEafavwiebfoQ8j5RDId3Gv/BQWcvfygny5H8vXGuihQ9sh2JdfipoXR3G9eSmGPsZdB8qJVNiZvKdUuaEERgsLhxKiUzjgVbrCnv5zXGsZgB1dO1KSmUYJgpNaqaNZkQmxqeRy/UF3wcDXpI+CV2WmXpmVdxejH6x890fd+wVhv1u4ofGS/1Ky/77aA3OniOpdFD+3NaTB8B+AygrxwBq8JLS5rk8yEkCA5+SASrTuMze07/Zz9bECPGamP8GXhT7LW56ivuRyskX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============7910205454797298679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 712137918bba1b0a9c7c670bab9200b0f0d6a7e8
Author: Roman Gushchin <roman.gushchin@linux.dev>

bpf: selftests: introduce read_cgroup_file() helper

This patch adds a new helper function read_cgroup_file() to read from
cgroup control files in BPF selftests. The function opens a file,
reads into a buffer, and returns the result.

> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
> index 20cede4db..8fb02fe4c 100644
> --- a/tools/testing/selftests/bpf/cgroup_helpers.c
> +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
> @@ -126,6 +126,45 @@ int enable_controllers(const char *relative_path, const char *controllers)
>  	return __enable_controllers(cgroup_path, controllers);
>  }
>
> +static size_t __read_cgroup_file(const char *cgroup_path, const char *file,
> +				 char *buf, size_t size)
> +{
> +	char file_path[PATH_MAX + 1];
> +	size_t ret;
> +	int fd;
> +
> +	snprintf(file_path, sizeof(file_path), "%s/%s", cgroup_path, file);
> +	fd = open(file_path, O_RDONLY);
> +	if (fd < 0) {
> +		log_err("Opening %s", file_path);
> +		return -1;

Can __read_cgroup_file() return -1 when its return type is size_t?

The function signature declares size_t (unsigned), but returns -1 here.
When -1 is implicitly converted to size_t, it becomes SIZE_MAX
(18446744073709551615 on 64-bit systems). Callers checking for errors
with "if (ret < 0)" will fail because size_t is unsigned, and callers
checking "if (ret == -1)" will also fail after the cast.

> +	}
> +
> +	ret = read(fd, buf, size);
> +	close(fd);
> +	return ret;

Does this handle read() errors correctly?

The read() syscall returns ssize_t which can be negative on error.
Assigning this to size_t (line 143) converts negative error codes into
large positive numbers. For example, read() returning -1 becomes SIZE_MAX
when stored in ret.

Should the return type be ssize_t instead of size_t to properly propagate
both success (byte count) and error (negative values) to callers?

> +}
> +
> +/**
> + * read_cgroup_file() - Read to a cgroup file
> + * @relative_path: The cgroup path, relative to the workdir
> + * @file: The name of the file in cgroupfs to read to
> + * @buf: Buffer to read from the file
> + * @size: Size of the buffer
> + *
> + * Read to a file in the given cgroup's directory.
> + *
> + * If successful, the number of read bytes is returned.
> + */
> +size_t read_cgroup_file(const char *relative_path, const char *file,
> +			char *buf, size_t size)
> +{
> +	char cgroup_path[PATH_MAX - 24];
> +
> +	format_cgroup_path(cgroup_path, relative_path);
> +	return __read_cgroup_file(cgroup_path, file, buf, size);
> +}
> +

[ ... ]

> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.h b/tools/testing/selftests/bpf/cgroup_helpers.h
> index 3857304be..9f9bb6b5d 100644
> --- a/tools/testing/selftests/bpf/cgroup_helpers.h
> +++ b/tools/testing/selftests/bpf/cgroup_helpers.h
> @@ -11,6 +11,8 @@
>
>  /* cgroupv2 related */
>  int enable_controllers(const char *relative_path, const char *controllers);
> +size_t read_cgroup_file(const char *relative_path, const char *file,
> +			char *buf, size_t size);
>  int write_cgroup_file(const char *relative_path, const char *file,
>  		      const char *buf);

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `bpf: selftests: introduce read_cgroup_file() helper`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============7910205454797298679==--

