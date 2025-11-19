Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0E4CEE35E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290816B0023; Tue, 18 Nov 2025 21:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA936B00A0; Tue, 18 Nov 2025 21:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D6B6B0023; Tue, 18 Nov 2025 21:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02EDE6B0023
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:19:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B27D6C027D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:19:42 +0000 (UTC)
X-FDA: 84125750604.26.2B2001B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13C1C140008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:19:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DCPAIoOJ;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763518781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iujaOHFGk2gJNtOu5MorcnJC9lNAWP4sJdbJ9WiCs0w=;
	b=YGH80gWYNaoiQp277eJllZ8VLsIzPLbjDkeZvOS1/486pmNDJQn6o5+agFzNaYWbk7slLj
	wR+HH8Us2sHqsldVlMvdZ97LpOO1jT39Rv7Q2qaVCVWfOjX4OZagv038trUf283OVy4Y3+
	F82rfHAFq/4SxDJR3B0wQ+gNNssvyuM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DCPAIoOJ;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763518781; a=rsa-sha256;
	cv=none;
	b=RoGTqqFFZLtRCc7as40iwCwLibqabRjJlSVjlbFdh9CZk8b6Nwg9nMxa4CKDJzlFl57CP4
	OjN6ov2VX67B0plR4CPGGN6gkpUew2iV1wkEO8k3s4aJOR/t1/QfNYvKNMW+HVJW4v78eJ
	SuRDBVm8bk6IrMsKVY7TJh7HRExr96I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4280408ED;
	Wed, 19 Nov 2025 02:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA15C4CEFB;
	Wed, 19 Nov 2025 02:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763518779;
	bh=r5L1/Q/k/uedwluJ5VJgAYCi+wmAM6JWFGKQTIjpSUY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=DCPAIoOJSLMi4FmnMqskKe8EdyEYbJIB9hGyWz2qiCrTwgkT7zdJ30VHLCukc++BA
	 onD6w/3UT5zSVato/En8ON6C5sgBD8KvgJMapI1W6qq4kw73xEblN69oSbXa3EKoNX
	 JHXkV/7Ark080xqGyoKkC6eXQq6J4I5rH1jbN8DzeiPLrfyPZ/cuDZGFYHX8L4EO4i
	 ytxF8nSdpVCUgszzZ5e4Zr3q3kzRBJKjbNlGAnzdyQUl9oHK/FIx1JXLQJ4aozRSAy
	 pQCBd7ypxiUAvwUuoTha2tMAOOBfp1DKIZnsd8FlDP/nBOHQSFft2cWdJmHxJVUbUw
	 BHgwM6F26X3TQ==
Content-Type: multipart/mixed; boundary="===============8277338526258858474=="
MIME-Version: 1.0
Message-Id: <cb8b9352ae1c7174e7be81d16fb8cb880b72cb48c76f11c634aade79a601d176@mail.kernel.org>
In-Reply-To: <0017945a4297a296c87a65d62cc4bd9948f6c20c.1763457705.git.zhuhui@kylinos.cn>
References: <0017945a4297a296c87a65d62cc4bd9948f6c20c.1763457705.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 2/3] selftests/bpf: add memcg eBPF struct ops test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 19 Nov 2025 02:19:36 +0000 (UTC)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13C1C140008
X-Stat-Signature: yx98tfh4hrp3qhub56cejk5i8xx9b76o
X-Rspam-User: 
X-HE-Tag: 1763518780-380487
X-HE-Meta: U2FsdGVkX18oh9hhFycStTVbYEY/X7NLaNNMvC2rWMSgRzaooHEzKH1XH+001p9mnj1AR0aeuikh21/Rgmv6qJzIfNuCL7sWI3/xoJAm/d7JEXV3aaAES3Zy9Bz9NqmIzQ/Mg2HVvzmzTLF7AFXxvfXSzakFfpspc40XSx4SRZy6L/C/dSGD1iHWd2MY9/8j+405C8nY4r3hOIPul3OVuKFicj+o/T+fhtSaVlfnwVKUoOyF5xu2UB5KX43kZye2HZ2/Cz+HaESMKvHeyKbqs95//gPvSGmp4n+p3AWV0qLgZ2r0bqlnAZ5m5jFJk/xFr54ghigyZHbs8/n+XAAXRvVyJK8HE08sERL1a/p2MrtJwl8ifpzX0Dqj+BHbJtfmJX+SFdYQMOTkQZoKdbhAyMmluID+ztPolelztq0xid4IhVFZi778EEzM4rZ/LnYU3nY1BDkjFzKanHwalcsbFAkxvnQalaL+DR0Tsmyh6xeFhmKG0UGwfsa6B1h8lh1EZ/o4J5y/p2/1p9LX5Lys2jaguJdLuytlK0JFhX4toAneyZM/142rEOPnT/5lpPKcVBMYaGkd86nyERCOVPwOMJ7H9azH6GMRPDNrzs16WVIJci1+jcKX3QzFjQC9vFzafcLOGfMJ7tNpOFT2WEDUNomW+eulQvCFwsK15QvXoSPKwruvIeKRA4Def8vmpdqnKPQ2B2UGkECF1146PTfQX7CCH2wXS1J45IflcqEfnpncY8GRbHAzfWxsrHv8Ix6+fpprhXeXGYFpLdWFjCnkwVWqbyoU32Eut1QyJTeniHD5GfxvTSukYVfU93CeqQkPSvoIvSLzulkz5mqA0CUp8P6hQVuF6EbX4eH1kF+NOQzguQzGlROW72wUHG9vc0Z7uTogsHFFw9GLBWdtrGQMKzLQbXuX4YLpk9/afcuEbGfCyJbzk6+kmfd2mS2wt6ltnrkiJou3gvGx9VIC3U4
 coBmNWWl
 GloTtA3KAs2YVK30QKEj640fEZ+IfPl4Ta6SUQ8K5zc/1BA0nfY3YRL8a2B1luFLB1ojzc2E/HqT/LUaucgKgpRueKfj5vNPmSgnjfeMOM3hXtVk32NEcZF4jzZUAssz5C/X3LfEjnHXrgrG2SraIL8Bs8vvmQmNskJiAhF/5Bh+Tkb73rDJwBUzqrshavOzBi1dp+vT7f9VeRJjNT9+yl458efr9VUNF3B2P7Kp3UpNvZfmqB8sUhMg5QccN6pdO/YZ5ZOqmHIPGcFwIY7oyqVJuFhputnMWoqACp/W3ZNtmmbrPq0KQkG8vh9U7PaA0jQ9kRMxf3jCsbaXw+9NcpYIk1vXzVbGfI2wjwomEaSk0pTaee0XYdFDh398IR4PKxMlhQUJophCYucdbzgrEUL9qTzJpPXsUpCDnFL6lSPBHNFTuTXpmk3rJj/rDM/8IkSBzuPZcE4ODHrJnnpWdBzOdljZ3+EVnNHCjEHwmGYosVDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8277338526258858474==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> new file mode 100644
> index 000000000..3f989bcfb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +void test_memcg_ops_double_attach(void)
> +{
> +	struct bpf_object *obj, *obj2;
> +	struct bpf_map *map, *map2;
> +	struct bpf_link *link = NULL, *link2 = NULL;
> +	int err;
> +
> +	obj = bpf_object__open_file("memcg_ops.bpf.o", NULL);
> +	err = libbpf_get_error(obj);
> +	if (CHECK_FAIL(err)) {
> +		obj = NULL;
> +		goto out;
> +	}
> +
> +	err = bpf_object__load(obj);
> +	if (CHECK_FAIL(err))
> +		goto out;
> +
> +	map = bpf_object__find_map_by_name(obj, "mcg_ops");
> +	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
> +		goto out;
> +
> +	link = bpf_map__attach_struct_ops(map);
> +	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
> +		goto out;
> +
> +	obj2 = bpf_object__open_file("memcg_ops.bpf.o", NULL);
> +	err = libbpf_get_error(obj2);
> +	if (CHECK_FAIL(err)) {
> +		obj2 = NULL;
> +		goto out;
> +	}
> +
> +	err = bpf_object__load(obj2);
> +	if (CHECK_FAIL(err))
> +		goto out;
> +
> +	map2 = bpf_object__find_map_by_name(obj2, "mcg_ops");
> +	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
                         ^^^

In test_memcg_ops_double_attach(), the NULL check is validating the wrong
variable. The code retrieves map2 from obj2, but then checks map (from the
first object) instead of map2. This means if bpf_object__find_map_by_name()
returns NULL for map2, the test won't catch it and will proceed to use the
potentially NULL map2 pointer in the subsequent attach call.

Should this be checking map2 instead?

> +		goto out;
> +
> +	link2 = bpf_map__attach_struct_ops(map2);
> +	if (!ASSERT_ERR_PTR(link2, "bpf_map__attach_struct_ops")) {
> +		bpf_link__destroy(link2);
> +		goto out;
> +	}
> +
> +out:
> +	if (link)
> +		bpf_link__destroy(link);
> +	if (obj)
> +		bpf_object__close(obj);
> +	if (obj2)
> +		bpf_object__close(obj2);
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/19486904708

--===============8277338526258858474==--

