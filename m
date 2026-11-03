Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EB0606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huWd5l+4
Received: by kanga.kvack.org (Postfix)
	id E9CA66B05B4; Tue,  3 Nov 2026 03:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E740A6B05B5; Tue,  3 Nov 2026 03:52:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E776B05B9; Tue,  3 Nov 2026 03:52:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE7256B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:52:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48B7114031A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:52:36 +0000 (UTC)
X-FDA: 85393191912.13.F9094EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE5DF40002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:52:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=huWd5l+4;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695954;
	b=jxbOpArgajiMFZlCZ9h3aoQRHKrFMFtxfRZkpIDycaE5Va2IHav/u2Um/VoRwZWyKgw+/i
	nb8hrBKRspnHi1vDVMKM66+Tmsuob3hxrIAecx+Jj+U/IeXZINr5ameOEZAJmldZQ6mt1B
	dWKJvP3aK9O/bKrOmvrc3VLgqDkvuIg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=huWd5l+4;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOsQgTVGIr/Tgep+NhW4hFbLq1/HBMqauRz/MX5hys0=;
	b=q8PaaOviOzQrTCVf5Fav9PpzLCiYMui9ZUyAznS/j+ByTCuKwEuDJCZMSIncVOjzpT6DEU
	9ODAfXO2C98aTJ29zC6idvpPJPtaByHGU6GHF1nRO6Mdv/z2ZP18XcgCtn+AbXeJPPjOJK
	oXJxsyVDfo+y0EiCkEq++RzLolSkfnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 586E26021A;
	Tue,  3 Nov 2026 08:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD3C1F000C1;
	Tue,  3 Nov 2026 08:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695954;
	bh=kOsQgTVGIr/Tgep+NhW4hFbLq1/HBMqauRz/MX5hys0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=huWd5l+4F1p+J0e/58VInghO7CNSTaaGVdbo5FineQFBFdmf24vmWLFN79iG31zWp
	 CIoe1TPdP5xOq9rQEM4AwCOCC27U7hVXBuwqvb/uJG7PXNuUIjb7Qvv1+odSMnI0VE
	 gcTCo+nv9IAI8fIdYrYqGxh89ujO1h6ZLZMsg4BTF86q2d3LfApttRJ1Av4gf7AV10
	 GbzaX1t7dTzXLTvaS9Bd/seH4No5BR1nUhUWOa/TLtZiIO/bXqDLzit7aG88HgiQUO
	 VKNL27/sUq/WjFFAbm2gK4o6+tvorDsU8BTMQzBukjtY3KitCvGSV8WDUYnd56gy8Y
	 1fMW+OJVd52dA==
Content-Type: multipart/mixed; boundary="===============4326115560903711698=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <777e38238bae7c9eed41283cbb64940b49db57f67f10be75346de2051fac6dce@mail.kernel.org>
In-Reply-To: <20261103075916.100050-3-jolsa@kernel.org>
References: <20261103075916.100050-3-jolsa@kernel.org>
Subject: Re: [PATCHv2 bpf-next 2/8] bpf: Add user memory kfuncs
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 08:52:33 +0000 (UTC)
X-Stat-Signature: ujapk7gjrz9wp43zohuzm64jdac7uzrq
X-Rspamd-Queue-Id: BE5DF40002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793695954-44120
X-HE-Meta: U2FsdGVkX19W4Z4IzqccRJgR9LkmMnSMVNo8tNKOQf2fi/XbfUOIJKyrQnE6NBbafNpaX2Kovg0gEH85e/Ov5h/WqDNRb8rFW6OfAuc6iHDCeimO60x19/PzIIjAJJBaIzuGxTfZ4nghYFvjcpbJSKkjCWECg909gouB0Kv/2Di4r3skwKAoHRUTiOfT2IwqAFciiCPOv9DWVPIfzGyLNlwqhrNV38uj5JETbpl9jrdYQ3KKqLhFhpf+8cmpLYUQ+TWiqm4QNVlpqWNdnZdi2f7PIbGuY5DfXlurd2DuEpKolzEtqj8w/J3rLAGmfmKX82T2X6EVauwzAjVbdeR2h0X/IV+agB6OeCc3ZbdI6HElAuj4qkOc7kJ08jKFJjy3kyThL2iXs6JTSLbPJ7EYBhXG6LkkNbEN+VTkhSa5Oo9UGiGDWy7hqxm/FguZPrqwg2UhJVJz8nLARuqWn6dLRK79wZeiC/7blO8KVRy3HwJ7to3jayec7eu1zlfSgSn5SVZ0J+36aTRv7LTKrM2nPgqwXM6thpi0rHqcOWUOEAufaf8XF99YU5h/uBAyDX/i2dmzcAwQI8jCdCgJvhNIlkgR39wcIOcF7S3pQfBS2NmXca90jyaM9u5ks/oM6B1Svhbt9fvXFsenPR8SfQzBozMvgs4ZysagsS7LnTlAcUtlT1xwAxKncLuAQIQXNMk2zIbnrWSbR952XXlH3pgqBIebuQtx9FPYt+0PhYoOu2tlatrB43dWwAXedab159oQPBPfb7yJo6eWN/A9EzEPL+hIadngf36WbazZpaHVMfCq5lSZV3HHfLc2FoiY2/euKJiCEORUR1XNcEQoz/KOfKnep7LShWJZxDvE4YvDmDKEWOaisftwZ05j9oyDDQ42DujD0h+foQamDEnPvJ6bA2mnszqUdkvVWdzeIOB1FV1CPivnUvBMmEmEX/WN3cd9UxSwpt8aGecR7nSSlNY
 7ioXwuIo
 kFXDE5LTv8n52mAOwcAzpgqGukAgG7v2xnv4SpTCugWTF7zLySvtyreh1WVCufCsC+WIRy5AThVwsHFOLxD/OYHNQr7plo/xFaVWikqKswR77scbwL2QzrlxHo03NT1Mq3h/mrKQ16Ljr6TsTeAqkCj8fiB4ljhXgoiBrl8QQHP8S+Q5TIxyANAMCEaizEjKtb+iRIJ7MDsx6eQpxadhTnaDo0U6UCCsLGYxcDHLdOqj8PTs99DHdrqGSGZVUtIrMkYVi4cpLEY4EmaXX49+aW2KeS2vj0XI0cCgeJAY6I/mddlmp+hvpvPRob7AnwhtwEfyavV1yveh5Fq16SxSxjdfcGz86rGF9TUWghgDurpm6sMebRtkCYMOOZf9gb4g2C8fRKPe5/SI6HlqVlucC4EFYG2vByGiCW9I04YtusBXyTmzx5ot2bnP6dPe6Y589Q48+E3/30+ccNIxTZh3CsocJ1c9xznf8SKqe9ORRAyzxnZhWU8opfj7BaBcjfOEl4uQNpvU5Yr4NwWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4326115560903711698==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Add user memory kfuncs

TL;DR: Commit message only: it lists what the diff does; could it describe the
use case and why FOLL_FORCE writes and PROT_EXEC anonymous mappings are
needed? No code bug reported.

>     bpf: Add user memory kfuncs
>
>     Add sleepable kfuncs to copy data into a task's address space and to map
>     or unmap private anonymous memory in the current process.
>
>     Require a usable user mm for mmap and munmap. Register the kfuncs for
>     KPROBE programs and gate them on CAP_SYS_ADMIN BPF token capability and
>     the BPF_WRITE_USER lockdown check.
>
>     Use FOLL_FORCE | FOLL_WRITE for task memory copies and return -EFAULT
>     when a copy is incomplete.
>
>     Rename the syscall info-copy helper to bpf_copy_to_user_buf to avoid
>     the name collision.
>
>     Assisted-by: Codex:GPT-6
>     Signed-off-by: Jiri Olsa <jolsa@kernel.org>

this isn't a bug, but could the changelog describe the use case for these
kfuncs, and why FOLL_FORCE writes and PROT_EXEC anonymous mappings are
needed, instead of listing what the diff does?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41602296728
--===============4326115560903711698==--

