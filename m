Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A29AE83EFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF08A6B00A9; Wed,  4 Feb 2026 04:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1486B00AB; Wed,  4 Feb 2026 04:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4FD6B00A9; Wed,  4 Feb 2026 04:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9611A6B00A9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:28:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64A7E1406AB
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:40 +0000 (UTC)
X-FDA: 84406249200.01.06C92BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C721F12000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=YCC37vWy;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfsAK5rP15A7joS1NAGjtJPolV12DjAvdfVmCtA+puU=;
	b=NfTIo5SwmL28P3oNC/nN8cL8ZXNveK/NNPFunYSy1QTL2Pwf0xTbLJhBFeGgD0+6YI/+BG
	rEdWCn9EkIaHcQkQTDYy5rNlbmnrUFiJ9wfSjv+PL4+NdU9GTyd1DGcA9snXh7pvEU81KT
	0s242iGpRY3K+bdfEEQBXh8XFoQmNXw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=YCC37vWy;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197318; a=rsa-sha256;
	cv=none;
	b=StwlQI+b/2EtrBuMnuAfc/Gz9/BdmS1LYNz8US9bZ8QUt3IXBD9a1ZL2Y28Q2oNc2/SqWz
	L/24YSppcdC059aGU5WpqhoDs5FzGc11T3jAe0UT9NYDqnh+xi7rDk7EPpJgqwvdsV/a2Y
	6A6ZMwiUrVoXRh+6XppOfKShoIHirgE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53DFF444FC;
	Wed,  4 Feb 2026 09:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F87C2BC86;
	Wed,  4 Feb 2026 09:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197317;
	bh=iLmLS/irenZofYvUMwo2u3+RQqPVVKJnWwXqNzruW7s=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=YCC37vWyvS6r6gFjTX1IJ1uJZEPpkgORKe21i5o2FhLGTx+qsSxzl+ZI7UMe4Aqac
	 SF1OqDIUZKjWDlfn6ZEBDZxJN61PQDo0aVn3rRL7t1BXHzsEnUa3n7lDybRUTh2zgA
	 XshKQijMriVAdh5TzjaI4Wpr6v2lHovO8y7v9H+5M7QCcxL+8x9TFjkgMOFRfkGP9U
	 OFGgjqqhO1K2HjJjnCACwc0DwFqMEUwkCZoxDb5XYpYwk0PVMdcF2xi6J4mhMJRs7W
	 GMSbWUWNpq2bz3evxVGgpQy+CBXYPUb5PeenIPnGFZuZCrhy2hOnDBjMUgJ9tF+PNO
	 KCvqTPHY1cOzg==
Content-Type: multipart/mixed; boundary="===============4976973485721389665=="
MIME-Version: 1.0
Message-Id: <a1f4a2908ada3a81838bdddc64907529c53a5be29de83c928a70f2b3736783da@mail.kernel.org>
In-Reply-To: <d3e3dba90cf47c7da97a8a4142e7e816c5c1ace5.1770194182.git.zhuhui@kylinos.cn>
References: <d3e3dba90cf47c7da97a8a4142e7e816c5c1ace5.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 12/12] samples/bpf: Add memcg priority control example
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  4 Feb 2026 09:28:36 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Stat-Signature: 3ez8fxur51nosxccd7o4okdhsnm6iidb
X-Rspamd-Queue-Id: C721F12000B
X-Rspam-User: 
X-HE-Tag: 1770197318-220719
X-HE-Meta: U2FsdGVkX1+PnewvUHYhHS7g5Ato+r0gn/sm2Ieja0YEumVAkxtuXzKi6lchBIN78BhjJL5zakQaMPBy44WRh7WmG9xw7Wwx80WyEZJ0eonhgIxOWhTY0uBchutQDOQTu/1s3ZCeXmYceER216oIH/DHJf/DJm4UlUvYYJ2jz+n/VDzCmozIUS2yprGYbh9rdgmwycNFb6qijgi5z6xFB534wjGQxwYkmxF8Rd1ADUV5zS3UWp4A5UEXBfKNUALgz206x7t9L6SeU9fAvR2ujA7bdeEZBKjeQyCEu0LmvPUcDUuuTxeaTIlvXhmpy10PBWAKIZ8y3gXOeTrtqbyYL7ZPz0oA5u3zt248i19K2iTZH4wi7o2YVB6NWx+4O3hC1EQ37LJ7czUpt5bUMMqGlZH5A11qI30dL0oz/1bXJLyaxp74SpckzcCMIPLuncdbAtigXsSso7U8vHKTSYy5Wbcgz+qHkgxZYf14hgV1T0UVrRL7SgKI7jp3lzkwvdUv+kasrWgcEMXVsSgnlqQfy8m7t3hz63o9+3H4KI5OHtPEEHqHnVXILqOgIVjIuoa0WhC/gfmtb3hw0MS2SG1sRFOQhEDBHRCwY/biupAqAHe7o4lBmDcii9TdXalABZmznvDDrV41TFZYS9lVpoJ911GMvajBJRQCNN99S2H87Sqswi/Qq7Y1mg4nBQyrEHUtaqLlsCwuSAQ2g9N32dthua8R34309i9PYA0PJRjLfF3qVboQJi5ASvIeu8iMXpaOVROu1N0+MJSuo307LBxPHwR6g1RxNSWvrS5cZeZqDh+mtK/DCGHPAihM/M3VdXkgP0l9ivtOCDvF1Kau+OeQiT6uJxqzwSn7YZe5NXubrDybS1C8Exi95MTMW3XkN40Ry8xhqYASBSxuWEtdHOraxA9FijSObYmelsFocjzxxJBUVOVj6U/S8MGQdKJlkW70+teSb8NKbFfG/QEvyoJ
 MHVhyuCy
 o+GgkgJGkoWgRyNtU2Xqypu3/m3iO6K7lc5E5zjruwaTcbz9W/mDy6StAaqaIyIVlvtvxogN4QkBP76Cp6XQ6fKIGnEawS0YC9qP855LsHX5C7XN8a85KEg2SOu6yD/qcXhTrmY+zstskzo+NCDagYoV283dd/1OvJ9lIggGIpwWZd1UzS3b3yG1NJeY6eX4PufS/TMWLagcwl3cu00eXMU7QPhOOFXTU8I70yZ3TIF/7P48p2OoEdhrzP6tQLD99jn+uSRhBgQFOjz7VDPY1aS2kLTsc3F8k6GPz7+mniIwvOVr5m0M7rIPdSOiLLHnTYNpQBfs9x+9a6kGtTv3BkU/vgI+r+/a00Tl7N0XlKua16LAdTaPOrV0pv1WyCG2F1f3z+oCtXeLqUYoH2lg6pxcRZLsr8YzSajfuPGJFrHV93bpYQDFtLR6/QQeEW2iAJ00LaP5CHXcpHrMMWVA/ZfpWvOask1vf5kt6v38Qm6l35fbJ1i1PoIWA4R/fLQA1duYUW7E1s27GlaVvj3Vtxof1nGV5bB7sNyvzv3AvX08/R4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4976973485721389665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> 1. memcg.bpf.c: A BPF program that monitors PGFAULT events on a
>    high-priority cgroup. When activity exceeds a threshold, it uses
>    the `get_high_delay_ms`, `below_low`, or `below_min` hooks to
>    apply pressure on a low-priority cgroup.

Is this description accurate? Looking at the code, below_low and
below_min are implemented in high_mcg_ops which is attached to the
high-priority cgroup:

    high_mcg_ops = {
        .below_low = (void *)below_low_impl,
        .below_min = (void *)below_min_impl,
    };

And in memcg.c, high_mcg_ops is attached via:

    .relative_fd = high_cgroup_fd,

According to the memcg_bpf_ops documentation, below_low and below_min
provide protection for a cgroup (returning true means the cgroup is
protected from reclaim), rather than applying pressure. Only
get_high_delay_ms (attached to the low-priority cgroup via low_mcg_ops)
actually throttles/applies pressure.

Could the commit message clarify that below_low/below_min protect the
high-priority cgroup, while get_high_delay_ms throttles the low-priority
one?

> diff --git a/samples/bpf/memcg.c b/samples/bpf/memcg.c
> new file mode 100644
> index 000000000..0ed174608
> --- /dev/null
> +++ b/samples/bpf/memcg.c

[ ... ]

> +	prog = bpf_object__find_program_by_name(obj,
> +						"handle_count_memcg_events");
> +	if (!prog) {
> +		fprintf(stderr,
> +			"ERROR: finding a prog in BPF object file failed\n");
> +		goto out;
> +	}

If bpf_object__find_program_by_name() fails here, should the err variable
be set to an error code before the goto? As written, err could be 0 (from
the previous successful bpf_map_update_elem() call), causing main() to
return 0 (success) even though the program failed.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: low
AI-authorship-explanation: The technical misunderstanding about hook purposes and dual authorship suggest human collaboration rather than AI generation.
issues-found: 2
issue-severity-score: low
issue-severity-explanation: The issues found are a misleading commit message description and a missing error code assignment in sample code, neither of which causes system instability.

--===============4976973485721389665==--

