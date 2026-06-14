Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8B9CD98D6
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 10:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B346B00A7; Sun, 14 Jun 2026 06:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BFB6B00A8; Sun, 14 Jun 2026 06:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61986B00A9; Sun, 14 Jun 2026 06:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5A476B00A7
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:23:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C718B1C299E
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:23:14 +0000 (UTC)
X-FDA: 84878130708.30.70C2C1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C0031C000C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:23:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ealqgkai;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781432593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kqt2PsjkTRNbqmgv01YobweDN9fkjlj+b394Tb6Uu0=;
	b=by6VOsP2GluohEvP8DBl4C6Qd78MgVE9ihnWEDUAZbOJEl4oZOyHvugooDnXXzpiqX6pre
	pLzRZLbIzKEZEWFpMAzcStszf/Z01gLJbZERVI3otMjdgpi3usB0TtZqR+Z2m6PvhMf8IE
	taJCQFLl655igT9MnUxOchZyZjfsEZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781432593;
	b=O361vJ8G1b2e7sA0h1XJvs9/WaMwMloy9/0nqj0xheLR+nCGfMuU/VRWhhksRsN0slRwF3
	Q7TwgQJhzK11xs+lkvUGAt4tOenBBnZHvsxBgYpUP+XejuNCFDwF/xwB8x0R3yhcuGlSfF
	JGqYASH+wlEo2Eg6XnKaN2e/4yP6z5I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ealqgkai;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB0D24431C;
	Sun, 14 Jun 2026 10:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315241F000E9;
	Sun, 14 Jun 2026 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781432591;
	bh=3kqt2PsjkTRNbqmgv01YobweDN9fkjlj+b394Tb6Uu0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Ealqgkai4qqTif1CDYIGqpuXKEUkZpWX1rrlTJZYqn4Gk8Nh8DDN3ub6KB02kVvZN
	 x4CAJMfzUv7VEeOzFAB3PtoQc3yYUD3HTwf4SHDYxCOPZiw39hIFVIG2P3LduzPW1O
	 pYj58K3ewGrckUmR6B+zCng2vz4C8k9AXgGN1kirbidHcnCW6EYXEC2qG151+cN8Q9
	 Eo4X70VM1fItupStDRQjHyA44R5N/eHuCNoMhHyDUFO5cGpMx5FaT15HKm76d04nK2
	 ab5dFLosIzV4tt0xcUzjbzAcIhNkjI2iCb2nblLkldnpZhYU+ABp9SfjlyB5tjMQwm
	 NbmQbN8BkBe5Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 3/3] selftests/kho: add LoongArch vmtest support
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 George Guo <guodongtai@kylinos.cn>, WANG Xuerui <kernel@xen0n.name>, 
 Alexander Graf <graf@amazon.com>, loongarch@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Kexin Liu <liukexin@kylinos.cn>
In-Reply-To: <20260601093930.112758-3-dongtai.guo@linux.dev>
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
 <20260601093930.112758-1-dongtai.guo@linux.dev>
 <20260601093930.112758-3-dongtai.guo@linux.dev>
Date: Sun, 14 Jun 2026 13:23:03 +0300
Message-Id: <178143258399.2123877.4049283498071192411.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C0031C000C
X-Stat-Signature: 6hzoxf3ndsebgnk64s1j1tb8x6g4gans
X-HE-Tag: 1781432592-217553
X-HE-Meta: U2FsdGVkX1/p2oRw5Pks+isEetxv9WHOrrBOrBlY7R0u8/RTPzlJn3qro1dVA+kxlKyiBA7MAqMKox40rk1LmmfvwJfXTowV/Gn0VfuGQiWIjYMnIHJ+T8nDiXC0C8Z4E55H3gSPlNw9sY/Cm+dx0IOD+xf/DoLU+2g0NVqBthjDx0qA3sHsXIatevrOpN1T/S4vNw5/xdF7dIIvPbXF0sctadGklwqzRuXnlb6ufYnxNBNDQmNq7eo7G7sWiARCfikLaVSjdyuEGpTxhbAYWH0ylC4FlTrRUdGSraiHS0i5qluqXhcCsBzk6sHKhjdtA3G6lKR2x5H7YPz9DRaWdvZ7HBnlN6SAngxfBVlSDlljXftC3OPRdg6/55NPyW2mtB9X7jvcuwy0Ij48XAEayTpyT/iwyW3DgsliSlPBRIXD1EBTqQaeKtlw048PghClpjV+Brxb3+OkTrtcpB7ZA2WsK1LhGSzcrIVwZunS1Iwwh8sG9t4CI4LzzMtdfE7Zx9pt9kHWSo0rSldPyEtgc9LaBstMeda2ksUfW/IDLH5ktq5KETGh+1ISx0pMOnakF5avL1JVGEa/5pPnLKPMkEXf1Ug8oSqWDJuoyXEGgCbisgCiRMDlbMmzMcU9d7WrpcKKBvA5ohx2OS8Ir0C21F8FZktIOeKmp8WC0D7VM9qKTqNHASXi/K1FD04m9Q0rEzmgxAsx8YlxWNCDlIMh91Lls0XXhrqzR9EXW9AUq9H+gfHMW8PDhBcPXBeAYAk0GvdH3F8E7N5Oval1559gzkya5K724y/Emu5l+bdlMMvT6r6RUK0ZQHbHnawXctvwJow8mXbr0lo8ya1h16pMKT+nDXow3W7bn9DdCWg1Q3OF1buaJsQLnoDJcEVL77eUnU01IbjJDon0MCaoJNAAFMTOhe/CAt5KFlPzCb8FXFVYIvMgibGoor1lOGdtpOn0C4wAPDb+KTPn6+wPHQ/
 NAMj9evp
 oLOfrn5BUn/jQWEUoTOl7cI8RA3ofoouXMaaugGjTWvxuc9CoFsFyruI0/yjoTXrt0wfkxFFUkG0UpcRR+BJU/G7jMDmya04dvw1GhKcld25hLqGB+yPNXQ7gWS6D/im9YZujDdudDRB0Ol0t2bgpeisMxQIA+hJwkVgm8SCa7QiJdfX47z4qmFskvX64hArkm/8qDswphB/XiBVjggzO7P20eWywpFiLFt2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Jun 2026 17:39:30 +0800, George Guo <dongtai.guo@linux.dev> wrote:

Hi,

> Add loongarch.conf to configure QEMU's LoongArch virt machine with a

Please spell out "virtual machine" here and below or use VM abbrevation.

>
>
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> index 49fdac8e8b15..918698b6dd2a 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -107,12 +107,20 @@ function run_qemu() {
> [ ... skip 14 lines ... ]
> +		-kernel "$kernel"
> +		-initrd "$initrd"
> +	)
> +
> +	if [[ -n "${QEMU_TIMEOUT:-}" ]]; then
> +		timeout "$QEMU_TIMEOUT" $qemu_cmd "${qemu_args[@]}" || true

Runnig with timeout can be actually useful for other architecures. Let's
make a local variable for timeout of 120 seconds and always run qemu with timeout.

-- 
Sincerely yours,
Mike.


