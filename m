Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D39C0D2D8E3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490DA6B0093; Tue, 27 Jan 2026 05:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9946B0096; Tue, 27 Jan 2026 05:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266E86B0093; Tue, 27 Jan 2026 05:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12EDC6B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:08:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8579D40E6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:32 +0000 (UTC)
X-FDA: 84377319264.24.82E849E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8264140005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=Miit5XPl;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47QHZ5pc0q5xFkBsrfHtzB6AffOJUCsTsbjDL63EBtc=;
	b=FVkVn/t3K8Clo4Vby8wOz2+is5fGa3FkHtaLnJUGDmmMorTMtspBlPmSoXTyBkZKRQ/bi+
	wPpg9P4A9gTlxRomboDTMf29ZSsMHB3i7tDtvbVbpJvSHcpQ28UALr3NODuCzLOpPYarkS
	LaEipkApKdTMh7zBMbJd21T2I4PlYUI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=Miit5XPl;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769508511; a=rsa-sha256;
	cv=none;
	b=1DwccoP43gmH2VKvPCoxWOAzfqA5G9olk89Oxv9+20RKAW5Wyqq/Pg7DENgdY4mZ6pwipk
	oXa1gog1SE9v6aM/36vpd+zA/G4hRXMgGlXsBzmmEVW5x/TpuurecvT/B72mjjMwPciizR
	/wEVXUYRUs/FGdcamzHUzjGuML24XzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05D0560127;
	Tue, 27 Jan 2026 10:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A086EC116C6;
	Tue, 27 Jan 2026 10:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508510;
	bh=YzokodqmRv7baDmZfSZRrm1pBfaNJEn2jzrXGQM+254=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=Miit5XPld5MLyihi4exevpHeI+AjmN2+wmSrfG28Uw6DBocXcUTH5DWZNBbFNeuXj
	 yoHBAcucJ/42ARYyBUhwwVSn47ytuFHXJ/RlBtyCtWh/q/WBj3zzCmOA+h6riy191D
	 s6rS0C9mUgE0xPPu2NaUa5+vdCpDZGlzWT86CTkqgHL0Mih7pJLCUle1biVayEGoTS
	 YrZ2+fJ2Qxx2Ie3yEmAiilU9FI2AcfC7zG/Sq1bl5va3BmHOgu/iU7R4XUA7cZJwHc
	 bCJQtJgDYqyMO4lqWjnmlmVClDSorbh0lSUCQfVuIMZuhQjtQ6drF8+R5nBixvP3p3
	 QdQg8Q9FqpUfg==
Content-Type: multipart/mixed; boundary="===============2579571787754050133=="
MIME-Version: 1.0
Message-Id: <25d7b7ce5d8358f2d2dd9fc50e74596872b86aae1488b67cea6f85715e8f91de@mail.kernel.org>
In-Reply-To: <ef784786a2e38c2effca5f331f11658eeafd5f3e.1769506741.git.zhuhui@kylinos.cn>
References: <ef784786a2e38c2effca5f331f11658eeafd5f3e.1769506741.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v5 12/12] samples/bpf: Add memcg priority control example
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
Date: Tue, 27 Jan 2026 10:08:29 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8264140005
X-Rspamd-Server: rspam07
X-Stat-Signature: s6n5x8ouc4fdhhdfykch6d8m71ktyrtw
X-HE-Tag: 1769508511-499297
X-HE-Meta: U2FsdGVkX1829bDADg1F0PIjhKxoshGCTGXlvNEdGV+UzqDvtfNtLT8F3UPvq9rw3u0LmGXsL2G9iuW5Mpw2uEKmh667ywzrYi2YfImu3vLM4jDIQWiZYEi4tA1JInhDmxz91VRfBliE97XVYQcH8MRDCap/bcFvDfQXcXW8/+SfIUrugzR9H19a5p/ncd1aHGvkyIt6aTqyT+P4CfwfBDGSkOssN2DlagRqLuGs7oEHzvPjZqrOtOdrAFNGDfE+VCfyeCOjtnvAp6ryNGqtdBYNWmCXC3Q4wNbZulY/b77VmRwP1w15szEF7wUDrtK9RYjqmPYJjm438ZqlQFKHy1Ixhuw2B8NZvadJlhy4ahpsr5pRO/IpAGk/+H2nawTUEmvqM2AWoXLT3xYxhjJx1PU+EfXSGuewHd0fERhFU2jqe3O5oxmcYpB/VQlSP1Ny+sNfNdNP9V4ag4niHwASi3Eyzoy5BjkfRVLL0IBsn1tQIiUL99W6SSjsGJjUMBVdejAkSPVfqqJaTID51DWI4SML6i9NLzNnaRCgIdyusbDMiPzbuoxbjqeN/O3FX/62Xr1ciVDMjCaXWwaku6Rzm19xWXQ1emNvce5PNRcczYUtavGkfFrH+zTd6khQCk0cAUkHHX/EOQ0Ckd1ndmORraDlkeF8KOPJgtGduRtejF2blm9lVKe7lx4L/dMkxnqqGBRo/MPZ90H+3/nQOLztzIJxE2cT1ZsPVZSDH3QiFoyUK34zO3fzSIKZaGpfoGy0JIjAlotX1AVPDqoWmiC3qAH7RhXjjI2uzSu6L04rxCGXjcaiixRUwP5C9lI3AqE2bpsUy1uQ3qZ6+9yI7pnMbAL3ygCohzRmGmH8hJGdog4HAUu+Viyh2LdL4hEmASoV26K5EZ2fKRM3OkXodyY+vaoPFc1kqFS5XS6vrq7Fpe38G6MbU3V9pX/tz5TW6yeV67NQcTpeIbmQ5fARxef
 NTFV1yps
 IrPB0YDA9Zm5i+RrYedl1NldFAm42808/lBfdDWY9aZZ5wOb1EWzc8X8L93gGfRDGj73vbL1xOBUBWgOgAL6nqe6f0IELviXgorTaQGIswpZ3+qF8R5JRkUc2C/PVijXdbPGkn07row4mO0UvMRB0mOGzf9VebYOLBl4RTpSUzaBnMWJ5Bu9r4BDrTnvLVe7nS6E7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2579571787754050133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/samples/bpf/memcg.bpf.c b/samples/bpf/memcg.bpf.c
> new file mode 100644
> index 000000000000..e611ac0e641a
> --- /dev/null
> +++ b/samples/bpf/memcg.bpf.c

[ ... ]

> +SEC("tp/memcg/count_memcg_events")
> +int
> +handle_count_memcg_events(struct trace_event_raw_memcg_rstat_events *ctx)
> +{
> +	u32 key = 0;
> +	struct AggregationData *data;
> +	u64 current_ts;
> +
> +	if (ctx->id != local_config.high_cgroup_id ||
> +	    (ctx->item != PGFAULT))
                         ^^^^^^^

The BPF code monitors PGFAULT events here.

> diff --git a/samples/bpf/memcg.c b/samples/bpf/memcg.c
> new file mode 100644
> index 000000000000..0c47ed53f6ae
> --- /dev/null
> +++ b/samples/bpf/memcg.c

[ ... ]

> +static void usage(char *name)
> +{

[ ... ]

> +	fprintf(stderr,
> +		"  -t, --threshold=VALUE  The sum of 'val' PGSCAN of\n");
                                                     ^^^^^^

Should this say PGFAULT instead of PGSCAN? The commit message and the BPF
code in memcg.bpf.c both indicate that the program monitors PGFAULT events,
but the help text here mentions PGSCAN.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21392729810

AI-authorship-score: low
AI-authorship-explanation: Code is a straightforward adaptation of existing selftest code with standard kernel patterns; documentation error is more consistent with human copy-paste mistake than AI generation.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: Documentation mismatch in help text (PGSCAN vs PGFAULT) could cause user confusion but has no runtime impact.

--===============2579571787754050133==--

