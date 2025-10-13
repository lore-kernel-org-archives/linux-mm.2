Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BC3CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73098E003B; Mon, 13 Oct 2025 08:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22BE8E0037; Mon, 13 Oct 2025 08:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37FA8E003B; Mon, 13 Oct 2025 08:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB7DA8E0037
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:21:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8057DC03E9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:57 +0000 (UTC)
X-FDA: 83993002674.23.05C01E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D57BD140007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ck/fTjQA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8yyluaPsU64JiH8nx3doSlxtTxHqP7AkC2CtB26lS8=;
	b=fbpyvkv2QLzt1LqgYW5U+CoBMal2ESghi8HJf/RihqL6NVd33AnI8BLDdPmB2BI0rvRxhc
	6pBYP49b/8SqRIgO7dllmWXiQHHe4Lni2bRDbEm0VrKHR9iT0S+ky7ZVWg2z2Rz1s1NSup
	8Mj2BJf128BudnbdvW6fnJQXl6td6iY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358116; a=rsa-sha256;
	cv=none;
	b=iHvkjOTkRGuPCG/LJMVGtdzYR0cOApCo+ZUp7hU+5Avmv7PqDJFfkOkltLxQehKdhm87hF
	2kMH+WWwDw8wWQw2RuiteII/f4Vx1ktfGlLYvczfPcwbECpKkhL23rf7uRLnr0kbjy8eUI
	HIlt2eMmcrbiHHveBguKim4lDmJj4nU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ck/fTjQA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64DB946648;
	Mon, 13 Oct 2025 12:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8079FC4CEFE;
	Mon, 13 Oct 2025 12:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760358114;
	bh=8ayZzsM7Tg8a4hHEL+CcWLmAF179tgFq9958rKBp3So=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Ck/fTjQAuQ+K19R4lL88ECj/0Dyc4YPuuLzIxdGII9aY0b0oAfOapTL9ra3jPMwB0
	 5GutdlxKErtiv++SiF3f3P37du5dp0CmWfuZ01iSPpWGD6WHfnnKohye80p4l7LPgS
	 vKcpab6vl7FI3vR2UpDz0/3qSUxanHBybWUAfMMWCGgONnyOeT46qbB8HIvFO7Oj5A
	 TVRSniPUmM8nAZXEki4z7Uc5CiBf39hBlWyrTOpvIAzuswgWFKLhtPIy+VB26FhawF
	 TgtEiCVUsK8bacETgqDgUBAzCvXU7ex/NNuvkQbAd03pu7R08H1NWr65CrXRTKFC5s
	 LXcgciLEfD/9g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: graf@amazon.com,  rppt@kernel.org,  changyuanl@google.com,
  pasha.tatashin@soleen.com,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Abaci Robot
 <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] liveupdate: kho: remove unneeded semicolon
In-Reply-To: <20251013021836.944898-1-jiapeng.chong@linux.alibaba.com>
	(Jiapeng Chong's message of "Mon, 13 Oct 2025 10:18:36 +0800")
References: <20251013021836.944898-1-jiapeng.chong@linux.alibaba.com>
Date: Mon, 13 Oct 2025 14:21:50 +0200
Message-ID: <mafs05xcjm1pd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: D57BD140007
X-Rspamd-Server: rspam02
X-Stat-Signature: d7h8mht1thtfkegtjjcuhqnm8wk7sh3u
X-HE-Tag: 1760358115-899689
X-HE-Meta: U2FsdGVkX18vkHOxmtSuuEJksh2mfsPRKeb/yMBfjY8QXK6iik3EwOXuWPbNC8/4FCnX1obwesQArDmIFFioABVEDSkOno9QKPE+DoEj4c1PXybKWnA+14UbqdOR/WVyvvJWAavsAVOPpXwH7zko9i7ARoEZDcKykMiggb+LMPut/Az163kaRp4kd0VvR4mn+BTqB3oudiuP0dOvi8MhQ9U+1zXdaRmMo69ya91AfSwXXb7+SDBq0xoo0Q2t0/gfI0a2iSUWXyOTthgdsxz3tplqk0PQe8hBkFXasJNHm9kt/swgd/XaohFZ8LR39JVYUgeMgEG069NZNQXaVLp+xj+qTlNjT8+FphurgLfqxeywh1ow7T1MfLtWMaxJjNhtDVx+N54VL+MJTbMDV96vQ71TkfqhsLR69YKEyjerSG1D3G6xZzjKUYhy/O4SjP70qECcZ2zeP5d9HW17wlYWZUwKKyQcuXoyYeOn8ScRHmfcNXyeCAn1Jt2DE/1bauh0f76F1/YmCC3USbu926yUhDisZbovbdC+UV3IRJflsWJBybN8OmZ2KeR0xlXuEfO+G/0Nvgqc84Gd+Jea7Cr4J6XsXwejWGdTi66fpmtgfQIH5sVmIHpFSffPJmjlFFehc7pgnlIy5e5ucz4a1H3lsnidCjQOIqXPWfZHgl5Czu1H86JXBILE0+ofetZSCU0zfx8LXd3kh8yNbISlwrPr36rt6H5DIeIyHC4aAlsLqOD3mJHnS/o/iQxIOyfJwuT58xg7lb4LXAnWhaNE4C3r5CVzoyV+NSxuApr9/jOlgmpPdVrgZJH4T6PA5/Q65tl2oxzhuNNfxTilfJ//AYej+qP0DcDPjhAGuXnbDN2gmwYIpsi1bYSfv78ZPG3TlxPpKt6Mwfsrv16tiEyp/Al4ZvtQsGIDoagvLhBSe2MIKOSN+16Rgzz7mT5oJJtAajA8Sai5MzzeNaf7jXTIond
 SpHz0iYY
 O0mXSJkdYDLf7AGnII1z4OGzk/yxxtUsIa3RODojH2sLHQUWyKBLsMDl+/sO6nVWoYkUZzS5MDh0PuNf3i85vhbhN1Q74mjyGdyy66GMByK+Hmkh3FaPkWzlLXMBTR0SrumYLdEdNFNm3ZO6HZ/gi39jynyPWg9k3L8P5Pg7sfcVkBJt3LPFKbINULj/z3iQjagmoi/S4RpKqFwm34UFABlua0zszVxgvmIVxtldWLaWa9qGEaexzMTsv7KNgetpTB5nJAFWhPiPdGmUeHhR8cgRq9Z/ndO8GHf0GS83JdQAC90CxNOP7esIiMnXdQXkookHcVh+1tTNPHzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13 2025, Jiapeng Chong wrote:

> No functional modification involved.
>
> ./kernel/liveupdate/kexec_handover.c:1155:2-3: Unneeded semicolon.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=26158
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Looks like it comes from Pasha's series
https://lore.kernel.org/lkml/20251007033100.836886-4-pasha.tatashin@soleen.com/

I think this fix can be folded into the patch since it isn't merged yet.

> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5da21f1510cc..c87d00c40c82 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1152,7 +1152,7 @@ static int __kho_finalize(void)
>  		err |= fdt_begin_node(root, fdt->name);
>  		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
>  		err |= fdt_end_node(root);
> -	};
> +	}
>  	mutex_unlock(&kho_out.fdts_lock);
>  
>  	err |= fdt_end_node(root);

-- 
Regards,
Pratyush Yadav

