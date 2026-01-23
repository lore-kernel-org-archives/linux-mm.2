Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DCBD72362
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA486B0486; Fri, 23 Jan 2026 04:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94B56B0488; Fri, 23 Jan 2026 04:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63456B0489; Fri, 23 Jan 2026 04:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADCF66B0486
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:19:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D47E160148
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:03 +0000 (UTC)
X-FDA: 84362679366.28.AAC08A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E37921C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=N5SCKLXy;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZlKlpSHCwLDlw5xSnqV9Gq0+CblMC7kHTtdvfgfoLk=;
	b=i0YVcrBAjIERZnvo6NHktMQ7QBhOjDtGWsgjdEOZzFqZVO5/md4j3A/FTOOokltq+pPtEo
	jtEBjzQu4abqJG19tCka/rocx2cyq1SWA3Gy7icSGPkpJ8UIZ9VVlFIvlIHNAkGOHKi9ih
	wJdiFicpXTQAzfu5K/iwcfOeQ+T7t10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159941; a=rsa-sha256;
	cv=none;
	b=22IkJtyDgylDBg85p5MkFLRIZ9yeB0wT/firF4T8YEy7zr65TJ7as7m4Mu82zXGMcBuF+b
	NWIzzufTm12YHw0AY+NygfUx0foYrDBkBeYlPo+fEUOlRDrNouIJVwWKPi61zGVgMcP2wK
	Q36xtZQO23d/Lml1euBYdYnzQpw5PDg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=N5SCKLXy;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 573F5600C3;
	Fri, 23 Jan 2026 09:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBFFC19422;
	Fri, 23 Jan 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159941;
	bh=lAPN0HhdMwPzTnR1YDIQgmBs7lFW2+TjNgBMANKYj8Y=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=N5SCKLXyAELrFNy+gkbgIPeqfEvjDDv6H9Nvceu5DlOURyvJQieEH89DsJoE871Lq
	 F2KUj/E1ZofIKSKhXCfShq5QIzhc1EcGMdvPIHwDrDBUa1pQuvRAG1+OsMTUnHte5F
	 /HOCWw4+OY36AeeDHJA09t7H3R1zVLSMM461NItNIhQ6QMp6xN2sNq9SBi/saCLzcy
	 k771BwY2DcyxlCXkJim6NjWEBd9Drwa3SKlUi9lSmE4oJ3fygQGYmlJiUQYGIRQT8m
	 uyRo+ni/Wa9GwHvAM16GSiQ3a4Klus5nCUx1cvz/JOXgUw6S8/ZUxtBxt3MQK0lzUf
	 mlUpBzxraCRvw==
Content-Type: multipart/mixed; boundary="===============6891829209060571098=="
MIME-Version: 1.0
Message-Id: <0031e5a293a89b42ac55e019d44bc9cf6ad0eca5ab75f07eb1f12b46a5ec560c@mail.kernel.org>
In-Reply-To: <e6ec046aab6205c6c381fdc4860decf6b8643ea8.1769157382.git.zhuhui@kylinos.cn>
References: <e6ec046aab6205c6c381fdc4860decf6b8643ea8.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 12/12] samples/bpf: Add memcg priority control example
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
Date: Fri, 23 Jan 2026 09:18:59 +0000 (UTC)
X-Rspamd-Queue-Id: E37921C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p4szgmko6adg3pdhtj4wsgcs4en7prw9
X-HE-Tag: 1769159941-511766
X-HE-Meta: U2FsdGVkX19zah5RaR7fLRfHyNA4OTwHCz6Ty2OOt6OSc94vY7wO52DXy0di7KSaWiBzSmP2rCDwlZXRisw77WF0iEMT28Gek99Fn7F9DDoN5pNkCvIx7sSOF5N80coPKmsPMmUUr41bkKCdbpFPALsSDf3TIJbLtCPDYIFg5XM7krWQ7CUG7B3TJWrz9aS46bGMfs2qkVibmPPvF/CiXDTad24USbDnnG8vin32vsl3Qb9bXFYSACzFgrc7okH1D6VCZzlvGItNCDng/LQxadO28sMsUM+BBkLOZWAQferWnazWtTIfcOFNn21TJGq1PlH6MUFAa1vD+YC+a+dpVv5HXKy/CrRmN8lsjsuak0TRSCD14myfhoFjUlyw5rpGgO1uT9wXyv7zYTvMKfrzd5naS847LTS8abrYQNhyManvNX0QmPkn0XCeUjvPd5ve/Euok83Vu1YzpZ6bMeO0hdS8VlbSi7r5fL1SWj3ts+YtBCo2FYihfuqwc+xS4RNGYINUkxjM8IMPRRXHMfimyXiJfmEq2qgfJukponw5V07JXxa/Z+OGXq6dC65MIv4p+s1z0/ZiIl/a+Xh0s3ZL/7IM8iDDZQYvw7qPYh0gcxFir3rzjXS7PJFX9m3uzwe4DIUm/U62JsmfykHcujKfVhvA0RLZU/HMUv7NCi3nShLJx8z1CnEg1zZWdkiOr69DbuAuzHMwQq0GCIkg+QxC+3xiv+AEsT+X5UR6CR4BpwiZn2XaCtV2upjhLVf2nF5eAftLAXPGbwIxDwBXn9G8PH0+x3QuH7K4wIvBh3db2V/7kXWihYNX3JBjaooNFSAq6IV/eNt0Lb4vxF7auGCv6xx7ujaUTZGjdcO/vQLyqkkm5jjVOETTNuw+z0AU4PtnF4DxO9E3Tzwq26goppo7V3fw9dLwkRbyVO3H47h0eMvm6xqNDUQVMilSpKPiUlkbxZWCqDfWYlz55x7PB5x
 Bfc8bW6I
 Vx76TcUL/rrsim/XbaaSZcmGyqGSW39C6RblIy4orYCwYIszqxdlRfWZlS1mCPnk7HeA/+jxKr6ARqQ5CsMtqnAlSR6VLWP0U/T9xinxeOantOjF5/kMV2mUNVtm3u7vPcy0kg0KHdcadEi+o+H0SmQP7zucIRV9zWcLJ2WwhvqNJYN8soVngbwaHv9894+Ik9AWccePQlcHe/5cfwCxe9qljy94qseyBgDCtMGAgTUsIS8CF0byHJ0g6bs9R7NX6L9BoycnviLMk+dvxM8fRzH7YHTRu70wRQi+cQVCLKPFFfZWRmJ0xKWbC+vh+7nSi73MlK0pd7DHXKoW8hEEgVtL0yQLbWASq3TOrgc3Z4GRz8X7kGJ075GcrioSZnDnqtyS5y9Ph+adfUniQU37PPwpkShta5JVOa3ZC9cpxh37v3G6qIVK1tRwuPNciENELOMtDik8FWBKucK6mKnsNBESu+T7vFQG99sXEkMM52PCMnKgG20AxFTyd7TIVPUXCVRdn8KqG9HEq9aPZW0MwwSKHF1WnTNqUflJIbuodutTwf/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6891829209060571098==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 95a4fa1f1e44..6416c8aa3034 100644

[ ... ]

> @@ -360,6 +366,7 @@ BPF_SKELS_LINKED := $(addprefix $(obj)/,$(LINKED_SKELS))
>
>  $(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
>  	@echo "  BPF GEN-OBJ " $(@:.skel.h=)
> +	echo $(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))
>  	$(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))

Was this debug echo intended to be left in? The line without the @ prefix
will print the unexpanded command during the build, which looks like
leftover debug output.

> diff --git a/samples/bpf/memcg.c b/samples/bpf/memcg.c
> new file mode 100644
> index 000000000000..85432cb01c27
> --- /dev/null
> +++ b/samples/bpf/memcg.c

[ ... ]

> +	high_cgroup_id = get_cgroup_id(high_path);
> +	if (!high_cgroup_id)
> +		goto out;
> +	high_cgroup_fd = open(high_path, O_RDONLY);
> +	if (high_cgroup_fd < 0) {
> +		fprintf(stderr,
> +			"ERROR: open high cgroup '%s' failed: %d\n",
> +			low_path, errno);
                        ^^^^^^^^

Should this be high_path instead of low_path? The error message says
"open high cgroup" but prints low_path.

[ ... ]

> +	struct bpf_link *link = NULL, *link_low = NULL, *link_high = NULL;

[ ... ]

> +	if (over_high_ms) {

[ ... ]

> +		link_low = bpf_map__attach_struct_ops_opts(map, &opts);

[ ... ]

> +	if (use_below_low || use_below_min) {
> +		map = bpf_object__find_map_by_name(obj, "high_mcg_ops");

[ ... ]

> +		link_low = bpf_map__attach_struct_ops_opts(map, &opts);
                ^^^^^^^^

This assigns to link_low again, overwriting the previous link if both
over_high_ms and (use_below_low || use_below_min) are set. Should this
be link_high instead? The link_high variable is declared but never
assigned, and the first bpf_link would be leaked in this scenario.

[ ... ]

> +out:
> +	bpf_link__destroy(link);
> +	bpf_link__destroy(link_low);
> +	bpf_link__destroy(link_high);

Here link_high is always NULL since it was never assigned above.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============6891829209060571098==--

