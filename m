Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F546C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC4A6B00F8; Mon, 13 Jul 2026 14:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D286B00F9; Mon, 13 Jul 2026 14:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B4B6B0101; Mon, 13 Jul 2026 14:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1693E6B00F8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97868A006D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:03:53 +0000 (UTC)
X-FDA: 84984526746.12.7E3390B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1840CA0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:03:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESOKP2rZ;
	spf=pass (imf25.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0R1cR7bKh7ixS3Ep3XrpKwenEOmJrkdIxyoKz6OerB0=;
	b=fTp2WQFhTHo2ChQOJctivaQuAqY+Lzzm4Mkzn10FZtSZdHwq7zgC0tOR2zQT/myKfaBFFs
	Mo4nbaTRaao6cx7oygDVRmQ73ymchf1el9TUuBilMuJc9IIDmgf0y4nxaHLvjeTxjaKsLJ
	l2b2GLNaVtCGYfzScmvBzS+UA9RjRNI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESOKP2rZ;
	spf=pass (imf25.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965832;
	b=XbjdUwhvpTqwRUtm4acZXEYy3A0Glf/6vJPqaTqDQt9dscITDj/xGsYKbJL+PyBIetM8ib
	oCpimKOzKVeiCsO77n4tTHinhCxjGiSx9NmNgBj1kC//UsERdHKkm0QFEoWsDh7FBX1Ze3
	RufbRLSeJcprIsBabPpZ1FfOqI0Qavk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A656C60103;
	Mon, 13 Jul 2026 18:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A7E1F000E9;
	Mon, 13 Jul 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783965831;
	bh=0R1cR7bKh7ixS3Ep3XrpKwenEOmJrkdIxyoKz6OerB0=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=ESOKP2rZPyACXFW/kfBTOgmI3+3qmraqLbjJMYdrj3rjM8G8wl+2yrsV7SboHyQbQ
	 cBQkXKgK008NzCXQZBYUI1VDd6+5Mm6vuxOTstiYXXI/Q3pDB2tCojuKfgnSuCvzjM
	 mN9qDvnOrt37OWH8edLykRMnH6QeT13rxLkBs8tWhSHW0bDEv2Ir070kOlNO1UcyVh
	 f6rkxiqi58tXvghJ0k6P9qzrj/Dwdz3FJfy2KGLkNvzJXlFaRJ3mvnyhXloQv8wM33
	 XLg8vWZPxDV6NMnxwRU0qLkg+LHyAJ8SoA/7d8IkuYuaefHVETGtQdaIk/CCXPTt4L
	 6ZeGlodc0aoBg==
Date: Mon, 13 Jul 2026 12:03:47 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
    dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
    daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
    eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, 
    yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org, 
    pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com, 
    ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
    rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
    conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, 
    seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, 
    cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, 
    apatel@ventanamicro.com, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
    arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, 
    morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, 
    linux-arch@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v8 1/3] riscv: io: avoid null-pointer arithmetic in PIO
 helpers
In-Reply-To: <20260703122832.15984-2-cuiyunhui@bytedance.com>
Message-ID: <74ffb0c5-4edd-7b64-3d3f-be76c2aec4c2@kernel.org>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com> <20260703122832.15984-2-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1840CA0009
X-Stat-Signature: rqjfimu46sk5jyse5n8fukf9z5f8yn4o
X-HE-Tag: 1783965831-991931
X-HE-Meta: U2FsdGVkX1+zSZUuYHPWylo2VwvXn5klR1qfZPMWgJUIR+oAOPrCpDhuNAUHGroSUt8MhCZvTk9XkxsZCVmdngB//ATtkUScFo3L/deYlTQ1SQIBwuOFrGUP9NScXRP22K0UQlkbGV/L8RQ5iLZmaVZBKOjCwO27KGMEAd3HLbmxvwidbxNUgznseuMFASjCQLtzL4MBD7Bq9z6eVVGzNT88oqZdLVOjxi0Rn+ehHSvz4Y0KO3A0JIIRiaGRVZnjWSDvAJFMHMAyqghio7tliKNbW5cyfzXIRWgVkWAzgB8Vznw1dZC8gZDu90qwR301+ONsz8fCxXrP6+mtcEyCQOx8H2ko8VMZnqZP46nRllY9dP6DLGrcp1slslU1E+p/j4SEsNmoSOajasAZRNqcq30VwZaLPFuD91A2j64vdjcgK5O7xd4jJ0job/eYD//ZqFI3r1+5G6FRpLXYddnFeXOzUJJVJYwiNW8yCnRjbodNb3EUUWLP1gybjdr0BhB9uoIUzr5dym8NfaELYVuq09vKM5bDceBl0edeGftLwiq7qBa+LNyfG5LiyL77c19umi43GTVPI2bniivN5t/NtXx8U7z6nPGKwNUvRQx7AhXIO92gl2+JrwGz0eNmsPJtQqV2ouYcbYyY3Vf2oqMflP5zzgy+6EVTlhsKzQ1MFavQ02JyKWwC77kaJ4TTMaLK3sHvYPq1iC0PnyDz/h9oHK4lzT9NobYMgjEwrK93/TltoeMG5iy0il/AC0SVKe+WcX+F4mJGd7d8tmewcV+BPL9nRbcg4lSbYO2s3pKuO6Ok2mSCEQ6BiEFP/ip+b1qKriMEJkqBNWIw7b9q1xLgCsfzBoNI+gJeYtTk5kV3LYzHAaFdwB9ru70x03CeOAi0BFt2E3J9mt0Yena/hfhyEDotKXww7y210AWPrWZNZL1dKsgW0Jj6m9bSjiL2l2EHi2KG9jlFA02pq99Qs7X
 oCFP6wdw
 VfZ4jFgzEVHgUAJ1BbtDWKufx/bTNxIbb5FN28vLGcQhB1Jwi+E0yfWIyFbBFjLqLLM3vVMqwKmDdrtnBrp+FMXQX59bL/uYHWf0AvF0GhHECDCaCCKtZZQVRWE/VroKHQNYHlfr9KVBy+gwAwdirRmn2+mKq+beiFk5LgkJ8E6OH6CW3EN+aF4IijBwHX0m3QXanBP1hggDoP5sFw/7SqqB/NVW4CMiw+6M8OODPiPDmL04lC0h6WbyiRz+nJAburC/kj/l+TyZHMgYbypg06BUdCBE3wRWpg8j4kFXlKVdSC9OMFoX5Hs4+gX8oJC7jE9Rm9UQ4+Q0sojnkB8dCXw38pfJLQOrAFWUgtZxqiXj37ijKW2EkqJdZM0CYQJ8cFMaR+LBY0j9owZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026, Yunhui Cui wrote:

> When port I/O is not supported, exposing the port-string helpers is both
> unnecessary and can make clang diagnose null-pointer arithmetic from the
> PCI_IOBASE based address expression.  Keep the MMIO string helpers
> available as before, but only provide the port I/O variants when
> CONFIG_HAS_IOPORT is enabled.
> 
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks, queued for v7.2-rc.


- Paul

