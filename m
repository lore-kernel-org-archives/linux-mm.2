Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86652CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F244A6B0095; Mon, 25 May 2026 03:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBC76B0096; Mon, 25 May 2026 03:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39756B0098; Mon, 25 May 2026 03:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D33BD6B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:48:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A10E6A01A2
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:48:27 +0000 (UTC)
X-FDA: 84805164654.26.8A4152C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 058CA180008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:48:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VgFiOYr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779695306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjY9MInIrdeSdVKHsoHljcvbmHUlFL7f0hkiG9rqDjI=;
	b=GwFnGLRU7XfA4Ax4yuqOu9yUFAS5aofWBr4RCyVLSL5D+1fuo0GlMtc5Arndkkwksobz2B
	jV/utlkgoP8w3NULexQpouOUaI0WRV6rynj3v6EHIkIlZanNfkM8GQDHAXG3+HLND+yZyn
	HP/gaUaE2lQbOyCY4eKgtp/QWomnyHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VgFiOYr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779695306; a=rsa-sha256;
	cv=none;
	b=x3EydpQScIfNBlIHxv9nrZw+13ChC/jBygzl883ZFYLzfLh/w26TsXNpbe6UacbUNtU02U
	+wl4igH8gNsB9HSaya+W4elesQaQF7SWyUx8zhxHmNUWfUjFmNwAAJslICzSXbHcZ2Dm3N
	w//AohCtU3tPToYeCkGpDKarqiRpAuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87430601FC;
	Mon, 25 May 2026 07:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D4C1F00A3A;
	Mon, 25 May 2026 07:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779695305;
	bh=wjY9MInIrdeSdVKHsoHljcvbmHUlFL7f0hkiG9rqDjI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VgFiOYr6S0DjulovWK0ttkMDGLLywevPI+YoML7qLCufLrKNwD3HggOMvcwOvMZaq
	 ZUXcaANqTQn6CBaR2TxSV7UQP9sudD33jQ+3G3cXfeZzHr1P0J7uDno03Tjf/m3Brd
	 dZLaEJgrFCwqUxTxcgRgmtxmdGPU8kx6GdhoMcVFWnjdW9KkXlDIDReZbfy+uJSznU
	 Zc49VqyBE/QJwZ3fKbhtsyqEFRw9kgbLPbmv1uYAd9/3rO+6jdvqzz9V7Khxhqa59D
	 QgRJB8XB7KoTHf5deafYNRqiLNNXUxfR2fStlLk4NhXKHFpMLmACTdxGgBRtAwAs2r
	 I2EekSJyNzmow==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/7] selftests/kho: handle QEMU not exiting after kexec
 on LoongArch
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org, rppt@kernel.org, pasha.tatashin@soleen.com, 
 pratyush@kernel.org, kernel@xen0n.name, graf@amazon.com, shuah@kernel.org, 
 loongarch@lists.linux.dev, kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 George Guo <guodongtai@kylinos.cn>
In-Reply-To: <20260525062810.103367-8-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
 <20260525062810.103367-8-dongtai.guo@linux.dev>
Date: Mon, 25 May 2026 10:48:14 +0300
Message-Id: <177969529482.4047269.8837009779600841681.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 058CA180008
X-Stat-Signature: f51cjp1adf9ibfspertxeitornkn6j47
X-Rspam-User: 
X-HE-Tag: 1779695305-330936
X-HE-Meta: U2FsdGVkX18RmkN6u4sGf7AimLKp2p5qRiYWHWUi7K+yub3HUJXVHlHOF/3wqVwM4McEQMm/rvn6kRuXNfTNIRxd3NvIiP553WGOG1XNdhPBsqSfonvD2wIzQ0BMuryMmFE5Cq0e70QFw/OTywqdw7kLZfHegTDlgQteQw7TwyOTaUiEynmTEBeLzLOyxc9Ab/9Cb1APAqC2UhYlnDietaHb6SdGIqdmNJ5IGZ+IKSVYimpqDFTtMnIjYnJIVm/wTXCJjvxOLB6Araid7Q5CA3QY3wGOW41xSP7duEnlxwvpGE2yiTPe0NP2ot9fB70NiftsOrXaO1zKtRPsw+ZTXzrKE9iMme0+TCMqZRLhFCrAHD3xGWCfF7AbBGs5ApRNnruqmlMKHiVBrc1UI+5Tz7MikT9TCAQdoPMvwlMq2wXHn54eNrdV40YvO8+G3rhgV3BouX8m9Zl2/6nv5RAl8NoUGDyPGPolyMwDfKZwA2HfsJjfit7/Ohr0mN3E05DTYOvksVA7Oe/8KoXsPsR3OXcfSE22T/nqYVQsnn3ZZtM9VFTzLwJPkbGrg8l3ZtCQCqishnEEjlF5x6WdgnHQ0kCE6V3Kdolv+1APfd0IbcLN/efEd/JTiNcxQJRicmEFz3z4+SHVw3VT5ZguuiOGSisGW0454iOc3WJxv8TFBIElkgNQmKUQ/B2RmDMSd4rD35YqbTYnlLmElWUkwF/w8FGTr5d5tu2JCoOY3r4+d4PUKreAGAqMzKYr5/9glg9GuU6zQvTlKwDYaM+if6GW8sryvXKL6Q7+LZWsKOmFrdLIOpPeEtkIQ9m7zIcUwTzDe1EwBFwRiPeZklP1ARsHlZk3e/nyWsj71Lvax/jBITYiC/IxPiKpGM3zT2N/Yfnl0fWo6+5E+d/ZWY7uiu9eFg4PPbhzRWYohW2WS6qPCHUuPW3+EzeYGTOo0MwuzpA7xXXxct85c2qrFKlyObF
 rAJ1DPSx
 uOHzHuWBt5Wo/s9FkcVQnqpINhKRsobbVw0GDuZv7u6bknijjw8Gp+7JAGhuwFi75aK4F7vpP8mtHjbyK7l4vAc/C263HELSNOQooZpU3ManXvQUay7bv2PFTpxYcVbBMfceJcTsihYyhRIrwokq978dSrhZJRmcAOs2Kvcw1IQ77CWOOxEHh9tnLifG0qO1AtW4eqMclmSi0NbtNvGETw+JjWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 14:28:10 +0800, George Guo <dongtai.guo@linux.dev> wrote:
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> index a6ae9ac09595..3cb9674e4475 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -103,16 +103,37 @@ function run_qemu() {
>  	local qemu_cmd=$1
>  	local cmdline=$2
>  	local kernel=$3
> +	local arch=$4
>  	local serial="$tmp_dir/qemu.serial"
>  
>  	cmdline="$cmdline kho=on panic=-1"
>  
> -	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \

Just make it 

	timeout 100 $qemu_cmd ...

for all architectures.

-- 
Sincerely yours,
Mike.


