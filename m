Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B599ACA1014
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 03:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B9D8E0008; Wed,  3 Sep 2025 23:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33CF8E0001; Wed,  3 Sep 2025 23:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70A78E0008; Wed,  3 Sep 2025 23:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B63898E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:52:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5300FBC540
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:52:47 +0000 (UTC)
X-FDA: 83850196374.27.A2DECF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9427CC000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:52:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4SggvOd;
	spf=pass (imf28.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756957965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMVIz0Rq32t7Co+il06TcjOCX+8ADarlCsoswhk7B5c=;
	b=6X1Uya+onJN5fvI26m7Dcu3tf0LvTiQjXb5QgQTsobWdcW6fH+77dWegPiUhu4wfHy/Xop
	cxzlthgOOn9yXU5PG2Jr0kK/rH2Y2SG7+qhmVwhx9q5zyW1Y7QyFAjdr1KpLc4PUiLXq5E
	64jO4hN0t/b5htKFtKxVu/uG/gOKr6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756957965; a=rsa-sha256;
	cv=none;
	b=ja8BBE0IdGn00r3MK4tiXeM688XPToW6Fhewc1ESMZNUZgPIyB9+xI9i2JaepKFSe65L19
	zQLpBXMUYDNaqVjOfKXBwhYPkdBhu4imvJvwhpSjcArZdB1IV/1lvWNvW6rhQBQwc5Vaux
	LXp3GcvZRBiZk8F0JHgO89KgMNCdrjk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4SggvOd;
	spf=pass (imf28.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B6A044483;
	Thu,  4 Sep 2025 03:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7225AC4CEF0;
	Thu,  4 Sep 2025 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756957964;
	bh=dW3DY0tGbJhPve03HuDNPrD6QxC9sjo3oWoZbh4z3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4SggvOd4BbUbbGwaWFPdPRseaOkhRGGpexIV08g70d9iEWifpyMcHKg1LDKhagxb
	 X73aX3cyNra2YQJQYXiUrPpRXEjmEImKKuMFsLhD62OU6yN1wmci+wvDeF3PkMUota
	 NnzUIVAAyJ5GmDDpNPiAQvA2UKguSTveJwuqMti483XoZH4JtePjPcbk0fG8QozNWM
	 rfYDgshAh+BKzbWevQChmBmw8nuwjdklhR0lGWT53q7FGw3IjDG/pKVPiIzKATwmxI
	 WtyuT5A0cPe2iwRRD+02ucfirVq48nuR2WihTkaDccXlV3ixklm/IyUa94iEQo6mur
	 NMLqBhZPXxLMA==
From: Kees Cook <kees@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Svetlana Parfenova <svetlana.parfenova@syntacore.com>
Cc: Kees Cook <kees@kernel.org>,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.f,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Subject: Re: [RFC RESEND v3] binfmt_elf: preserve original ELF e_flags for core dumps
Date: Wed,  3 Sep 2025 20:52:40 -0700
Message-Id: <175695795639.3712216.15743949549231818751.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901135350.619485-1-svetlana.parfenova@syntacore.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com> <20250901135350.619485-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9427CC000F
X-Stat-Signature: 7t8soqsss49pixp74bsnnky51jt33cr6
X-Rspam-User: 
X-HE-Tag: 1756957965-853680
X-HE-Meta: U2FsdGVkX18dKagmB5AITWeUqci1b9vc5GV2K2sb8z6TiyzACQt0A6yJ+lek5ngdeIRP3qKxtnkEXpRGBxlYNDKmxgT/9ssS3Puwti1y1f2SCp8qQrq7fNLqYrDtTHgjjyQhbVE4EFNRs21HeuIJO+8d8Rnhrc4iJ2xICXemFh8rQPxAEmtKTT2q+Y5mITYBEzS4P93lYCdJPOACgsIeVZkoI+hCF7WMaZboZaKtMeBrEhEw4H6IadEOyESjRDJfjVhJbJi7ZdmVJ7kk8WL+VrSJ/0yzj4G2G6j6x13TqJczFM+t8l4iY0yluwP2MAr28wFBZImZ0Tfwi1G6ZUGIG1epBDrYAAwHCSggHfJUYQKfP8K1pdL0td1zW3sRGCmvl0T6dDlmfVuv+sd4un48aQAGmyIPZLr2/og6MW/bsVIWzwgCIl36UqjN2YxQ3lQIkaW350Cu6pbvc/HM82x24ddp0mH/UloF4Hl8su1Ds7S1uYHp9ESg6VqHw6x6ancQvRjMARgtoyuXpAESqmWM4kF1mTRAluhPSp8K0tO3PRjcYIf1F7X3PQV4t5iILc+qoobC5OA+P5Ko7aH4vFQfYxvJdXf3oPo9sCWTWfnikSvJnvF7gDUpp0r5P2EbmoxP0NkXOE3Iymu3ZJdO+imWA8WtYqqc3+c9zanOCLxk1n9+m8KC+QQFpaB9yhpc0V08LJhRDxU2bt8LQ6m50X9ekRTXydit3BHix6Em6a8YCw0lUnuGX1Hgbn4nyk3BaysyOBi93bKQrtSSzhjj/2R0KyckkBLwp+e5NmcE1tEL1ThiAgeE8+jsQsTIJcYCFb/Npl+ZKjusZ2Fzi/rNasSqSOeSj3rkYHxAy1bfD2Mrs8xSFjTi96DepYWzu2qhM+9V7KL4WH12y7CCRxBzrbU7+Xj4Idr9QhyHyax+qHehZHGJD6e5VxOOoFg/8/QVp0nJIB/+4S4R9kPHxcTKk6B
 3cbTCbh2
 NUg4Gu/MZ6nhV7XuCSs5cQrO6ilcNyTScHmvBjgL2rBNim4i6S8X7zbACb+HJRyN9ilhKHi2WjBFHiwLbm2UiZ5SejRcKZqfEs9Zy0PQBatqpSlwddVP9ouQF5hTdfAn8+n0S3x6hkk03YLWmZvyaD9CD1UmT9j0IuscPnc8zMTqCJyuBRCA9iIEZnfLsv9Y2ksAxPR8gnvv3qvgkkp7TnRHsx5lb/5axOe2t9wziCUgm+xcSnqZrMkgpp/0X92o1iCSu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Sep 2025 20:53:50 +0700, Svetlana Parfenova wrote:
> Some architectures, such as RISC-V, use the ELF e_flags field to encode
> ABI-specific information (e.g., ISA extensions, fpu support). Debuggers
> like GDB rely on these flags in core dumps to correctly interpret
> optional register sets. If the flags are missing or incorrect, GDB may
> warn and ignore valid data, for example:
> 
>     warning: Unexpected size of section '.reg2/213' in core file.
> 
> [...]

Applied to for-next/execve, thanks!

[1/1] binfmt_elf: preserve original ELF e_flags for core dumps
      https://git.kernel.org/kees/c/8c94db0ae97c

Take care,

-- 
Kees Cook


