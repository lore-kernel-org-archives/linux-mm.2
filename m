Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADC3606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThrwtBHp
Received: by kanga.kvack.org (Postfix)
	id 52F066B05B4; Tue, 17 Nov 2026 20:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF9F6B05B5; Tue, 17 Nov 2026 20:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5196B05B6; Tue, 17 Nov 2026 20:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 126DD6B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:51:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C5851A060C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:51:11 +0000 (UTC)
X-FDA: 85446561942.19.8AD0879
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA2861C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:51:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThrwtBHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794966670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OszsEJToNze6tnzlcvPsV51oFOJRwGBjy9Ri823e+68=;
	b=Cg0jYC3AHo0DdUVPyvqQvKJ4Y3YUK7yWrbuhJSkJsd8SItFy73GblVrWakc7XTyX+VaXUh
	db/NUZFES4fq2UxD1prbCdBj28pMf1PthFaESkBm0sWnUGtfuo4Tk0aZx3jGSFbO633GIJ
	anEqvXucS3g71o9vAmIC+l+F1rjnGH4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThrwtBHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794966670;
	b=Jst3Ofj3u14ot6OG3GIIXZWln0ZX8l+p2aTaw86tm6/t0O67+V9tJIU8DfddqDMi2UT+zw
	A/x5mrIF1d+CaVjeVagUrTzOlSzsXx5ksa6q/kjNUIeqazZAWK7+3I+ahi/Xxej8y1WcNv
	GIvY0+hMA7AIXjoC6f0gE5NtSYyN1fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10E2840DFA;
	Wed, 18 Nov 2026 01:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAB61F000C4;
	Wed, 18 Nov 2026 01:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966668;
	bh=OszsEJToNze6tnzlcvPsV51oFOJRwGBjy9Ri823e+68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThrwtBHpTaXzf7hassKaKBcUyzwDmGgefOFtf6hJdkgZJjnMXGIbtvBZXQKoyZCtt
	 +MJdcR5DkVpwEGdqNthqxNFo2bYfiMBufYpH5otviGB5eMPoBtMjfBjl+ujAR8Q6pK
	 FWfnPfqU4c7QakERFWloJeY+amgH+ep80Y7wd8DBEfvSKmAXBLfeDNXVCcohp/5nWT
	 z+aTBNVIkh3dCQnbkh1sCSuEnFv3HkTIic3D6yUyw0ifyHcuMsXFEVzmhu2oVVQyKd
	 CJbjQ+p2Lz50jjITHtZyV3EKFBgn7EsdQ33RUrpoqGrd++kbjzVGUOlt/WxQHe0a6/
	 0tdEykQIgFjRw==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] selftests/ftrace: add uprobe tests on overlayfs
Date: Wed, 18 Nov 2026 10:51:04 +0900
Message-ID: <undine-1794966664951744079-93786e4e480023ea@undined.local>
X-Mailer: UndineD 0.1
In-Reply-To: <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org> <20261116-work-ovl-d_real-v2-12-90564c4ae347@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA2861C0009
X-Stat-Signature: pz9dsbphqx889ma3gk1kh3iuzoeh78no
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794966669-398059
X-HE-Meta: U2FsdGVkX1+xqBdUMmsX3/Xxtl8AlW474riGEUF5CywnPk9MK4uxz67ywPnn8IJIJ6FWJgLj04qwxcr5wQIGLXlMrLdExpboDChCQ5JVve3Qnew8u44AQDchx27MK9QuZe2h7UUJBOn5iZLnV3NMml902kZSypXzoRnUV8vbAI+HRHzBQ/Z0D6H+3BOl2kJnCkevnYppY2/av1JnlqtPcujJM+dTrlvmcASlzONz4fn9v99otNTYFxzN7od+gd5Axnf71/kevUYv/Ug3wy/nrJJhUiJHFe6c8cpVGh12JWpun6w5wdtukh26DbVjklxKWEw+y6RPU3FHlNWbWGaDuYqEgbyHFQqC4FbTUDMuam8KUDzLiqPtBgW4trbBjo8PA1BI3dtzwBOqgPf+VZZpNuEUu/Oy5QWqAFN1YugueTG3epyDTQF8g8RHjAqhPw8YVaE/fVYYHlWLFX/f7CASV2r2aHGiZ2lkOZhRmQY+CvXsjbT+qu3WmzY2lQ6/t0X/9O4J1yxmdqOafbIH5cdqQdjDaE5XS+1+oy8zh1pWv60rS+Ye5RHhM/HlAaxMLY57l6paq/co2Nfdr9X068PGzH+/bQuo8rp+81YZx1sfkwyiqPvvQIj7XiCrXiRHUBjlJAlQ1q0NyHBrLrombogF7EAh3pm1V7RCfW2OD9UacQPX6tT7nEYD+XGwBiLqRQXW781K3r721Wh0WWVivobEk6BQZ0Jm4zN2MOSSt+EPtjDlqUSoCEyNrhnfyfSFGRFv2DDgkpj7hMTE841yUCM3o/Me9mnuyhFezmIlayFQdnIudY4Yp6lpNwqJwyq16jQNjCleMzkKI3AG6PWksn2qSSu7bYkQudHeWo5pRlilL386E9y3Bh2sEtI5aXK2wxL2F3q1ApmTAjmjzN3ySzBCJWeUBdRePP+PnVODWRxVbFSoHcf9lY5PxZoY1F38t21HI4rNFTTQk4hwjo9ZZnD
 bD2X6wpE
 fRXn5sGRqgTcOf69j9LFtEV8xWp7DuVHIoO+CBTrsiY4gNUgyYJuXLSBi3qN6w++ymfugpNn32rpJPzZtaIV0+u2KuABhurKWhUL0iYo4frYbK8NJP5c164meDzyz4JPQUueasess0Y/3M6p2bVUNCnXrt6GuxnE1qxiZp5EbjGJwMJMNWDQ/5TmE2mf3IsLbzPK8tGRtA3+9/wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 10:44:09 +0100, Christian Brauner <brauner@kernel.org> wrote:

> diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> --- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> +++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_overlayfs.tc
> @@ -0,0 +1,96 @@
> +
> +OVL=$TMPDIR/ovl
> +mkdir $OVL
> +mount -t tmpfs tmpfs $OVL

nit: If `CONFIG_TMPFS` is not enabled in the running kernel, `mount -t
tmpfs` will fail under `set -e` and report `[FAIL]` instead of
`[UNSUPPORTED]`.

Maybe you need to check tmpfs support in /proc/filesystems too?

> +
> +cleanup() {
> +  echo 0 > events/enable
> [...]
> +setfattr -n trusted.overlay.metacopy $OVL/lower/broken
> +setfattr -n trusted.overlay.redirect -v /missing $OVL/lower/broken
> +
> +mount -t overlay overlay -o lowerdir=$OVL/lower::$OVL/data $OVL/merged

Similarly to `test_attach_api_fails_ovl_no_data()` in patch 13/13, if
mounting overlayfs with data-only lower layers
(`lowerdir=$OVL/lower::$OVL/data`) fails (e.g., on an older kernel that
lacks data-only layer support), it would be better to skip with
`exit_unsupported` rather than failing the test.

(Note that this selftest can be ran on older stable kernels.)

Thank you,

> +
> +TAINT_WARN=512
> +TAINTED=`cat /proc/sys/kernel/tainted`

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

