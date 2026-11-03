Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE25606A337
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5T2k1U8
Received: by kanga.kvack.org (Postfix)
	id 846BF6B05CC; Tue,  3 Nov 2026 03:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BA26B05CD; Tue,  3 Nov 2026 03:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758D96B05CE; Tue,  3 Nov 2026 03:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8A46B05CC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:39:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E12DD12033E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:39:49 +0000 (UTC)
X-FDA: 85393159698.06.3C0F121
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55028100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:39:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5T2k1U8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1Qq20HbOq3rcG+W44qN/ITtiwiepD/zoxsaXvI4zBg=;
	b=ZcNWxv+9AhbuCvB6Ge2KVuO4VoMXi2eMVAQE+ppdcG8OLYqoG7tlHCrajjdFvcmx+aRcik
	D6kTXigNDQr0zuIA63y2GHRuVX+n3w438IWBV8WLMwZMeYDZ/PPHhn53SlUmVOp0Qt533o
	TLoAOOuyqivhA+Z2InEeGYj9fqZE3wc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5T2k1U8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695188;
	b=gfjUN6KI1+q+doAbH9ODu1R08KOHCt92C37OSwMPW/SeUh0nhd8JeJsj5fL1XwixE+7W6P
	9Yqjbk9VvbFces0NU7mguZXIugq5DRIqOUdj6bvgOPG0WdV475dfX4ttSCQT2w51w9F6pf
	M0GOBsPPXoCwV/yvC6DHk2Nh0lKi/8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F443404AF;
	Tue,  3 Nov 2026 08:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2111A1F000C1;
	Tue,  3 Nov 2026 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695187;
	bh=P1Qq20HbOq3rcG+W44qN/ITtiwiepD/zoxsaXvI4zBg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=m5T2k1U8PNPjEgmq3Y2NTT8s3l+K9pUXOtfVuxx3tAftAdsG8GPTO8MVi2YAqQGhG
	 JUwM10P9d7QtfmvOWBCs6BjJTGg6CZU+qwmcPf+LJ6r/ns0oY3mO1fdUX71+8cNCoP
	 2FlIwyt5zmfkCCVaO1j3KD3wU/bDlkIzhkyDRQdvUZAzACvjqpZUISjlMhSMA0zbrT
	 yAY/7J6kxZS9j00UG26rm72DNadEOoGLjQAoCXz5hqpS9uUqVXYAytPfa4W5AAJ+0S
	 jCrc7hBdsTLCYdLqQg7Z2Bk2pSmQPoG4Q5D8hR3BSVpNlJl/3vNr3uZWnDU2paTI3N
	 cmUBzknDIEVUA==
Content-Type: multipart/mixed; boundary="===============6944307499286553141=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <f140cba1c8d3bbefc759df505554da49c4ffea61ed0684ddb9f1d3c6effa529e@mail.kernel.org>
In-Reply-To: <20261103075916.100050-7-jolsa@kernel.org>
References: <20261103075916.100050-7-jolsa@kernel.org>
Subject: Re: [PATCHv2 bpf-next 6/8] selftests/bpf: Test user memory page exec
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 08:39:47 +0000 (UTC)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55028100005
X-Stat-Signature: yq4sxegk8h4hum5qf4ng3ech7cjzwuot
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793695188-169111
X-HE-Meta: U2FsdGVkX1+FZvqfOOXo+5ctaMcRoR+gvwGYVJYA5extfMmlgpUY440KUzaNJUE9C14OW5+p+ekBTF6W6U3Jhfg5O/inJVYO/wpr51ZaRziSTGWOZm7v3EGAtezNvRgb0ZFbdrNR6MHm8qgng9K+rISoAVFtcN1c6mgST2RRJ198ZKjKlqMSBvXguq61hciBYkhP4p7KKeZWYwU4C7LKsCPSg6AwxkQhgb3kMDeBYCfl0GY5wJUNNjGIGLGSbQ2aGr37WJUpoUBGFL8vlvJT+tIviTxmKnyLFEyowgFXpjMyw88h2zaxk6xEVSONX76z9o/x8viaqVjE9Nl6amifuWZFDELVuFq/Q+rOycuD3L3V1pe4RPSoZNNfqOfVLcv7xloI88zbF3qGAMYOzg4M/lD3360lf4e5wC2IBPfeK3K5uoauzEeMily68b/ePq2bcNqidm+ONQt7zxQMNaBg41Z2b/VZ9T69VFA5LeKlWtIRuPThtgg6W+P8uDlGQuBhqj1eubjgrmeuYcN/EcnrWqjDA3+h/yEDlPjrBgRDogy4p//a0UI1s3Xgjx/A+Rxi1KM0tlTMD4DjczqQEzEuJyib/iL2B25IM+mfRRjBsIyba9v5tp0CYAieFxhRwohruLrR8mhUpoQwB4bnKc4OdV9SAawfckcYNjdGtVPqHUHY9gnf4RV55uziJAdg14celjTEx5HsVBumKZcDKZutrt7Hz7rs1tTo8IdBfqQHbnHPbjz0l9SFMW+tpOcxtlqJCsi798dSLLSAwStGUb5SiowLkMDcA7aJEVmUfKP17Xbl5YIjGHVhMDXnEmS9CiM0T/fh1lln+98c0dHmqt72ixw6RkAXmUjukUotZ07sYwCnbNSGf0GXLtH06rytNR3/2TZhVyliraovkqX9z1xz+gbbfUDC9KzcevM/A7SyzHKCR+mU7PY/TCI8c1v6RUd+NWcOO056aynSRnXCA0P
 6tf1vdrN
 U5iUssTswbb6snLl6MQBYMvVEdZRuYFTE5wfbUE0nmVzStZazVvvLYwNSY4Wck4WXjd7nnMSHqnQUPndCZAJHgVsx/GhqbM/2h+oDu5pLnJNyuZ8Gqr7uVCvrKo68A4+tKHT3SNq/V5MZ/Wl/0CHN4oCfGu04vq16EJVUjc8VNJ0nc1OfVrz9X7eYjcbtGC/0pUiX0h8PVxG2L1CTQDklA+uyzvewqstKToCto7/0RPI3zyAYutaqLClKry2GbTxXGVW6Rhf6YuwT6QKNhuEBKLLraakORKS/piCq/fVSSICoXMeqSSRyyLA8K3bFl81L16B57qN73eBShUOz3HYi3SkrRw+FxBpFTmv0PC7XmxLhN+yCyKq+1sJPZlQElVpJylqwpoYJmUVqvCuKsa98Iz7i5yYw/8Jw3+kIFouFgB0HbfD2ogy2L1eIWNGkfc7KsGBbrHqiQ6+9p9NBz6ze+QBsQvMSR4NMyh7Xb3bautMFXNYdhwc40/oNmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6944307499286553141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test user memory page exec

TL;DR: Nit only: in user_mem.c selftest, the bpf_copy_to_user() ksym
declaration names its second parameter src__srcptr, which may not match the
kernel prototype's src and isn't a recognised verifier suffix.

> diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
> --- a/tools/testing/selftests/bpf/progs/user_mem.c
> +++ b/tools/testing/selftests/bpf/progs/user_mem.c

[ ... ]

> @@ -10,10 +10,13 @@ char _license[] SEC("license") = "GPL";
>  
>  extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
>  extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
> +extern int bpf_copy_to_user(void *unsafe_ptr__ign, const void *src__srcptr,
> +			    u32 src__sz, u64 flags) __ksym;

This isn't a bug, but should the second parameter be named src, as in the
kernel prototype of bpf_copy_to_user()?

The __srcptr suffix looks like a verifier annotation, but the verifier does
not recognise it, and it sits between unsafe_ptr__ign and src__sz, which are
real suffixes.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41602296728
--===============6944307499286553141==--

