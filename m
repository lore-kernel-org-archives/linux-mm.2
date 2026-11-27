Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9C1606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cJOpl0D5
Received: by kanga.kvack.org (Postfix)
	id 894E56B05B2; Fri, 27 Nov 2026 10:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845506B05B3; Fri, 27 Nov 2026 10:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B1C6B05B4; Fri, 27 Nov 2026 10:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9356B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:41:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C95081403E5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:41:05 +0000 (UTC)
X-FDA: 85481312490.12.3B22558
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id B08CAC0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:41:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJOpl0D5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795794064;
	b=Pv/x39la94/gtHNaQbg3vwImiohVukUf/Uc/Hf47gk06LTO3xIrE8/OlZu/asJ/YN2XLnw
	o+LzttMcpCwil7eOWsg7TSHNeEykrUoS0z9s74zrPGpS71OeNsrRPRZEuOku81CIFS7xgO
	6RDUUDdZ/9Gwcgh09k6y9MYrYgEyTeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795794064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTeGEeYubIuGfiie/NnBel4Xijl6Dj7t6gEULam6Lc8=;
	b=62IM4z5TaNjy27mY4/ZHfWoyJYVBaJ6IMO/mCJePkLA0/KwVpcT2RoLd27BfxyOin13m4q
	K1FyjZioYaUqj2ntWvy+b+dAgcZhbn0gvbyDksa4R3kQHBddApiEMaIhK3uSy2xsLSft51
	bqm/q4yxNhXHrAMZOEeH0YtQU6zJ0BQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJOpl0D5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D7LzFkhrlPQer8Lrs7O6LLemqF5OXFeGJoFOpPJ4gPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795794062; v=1; x=1796398862;
 b=cJOpl0D5OSfcQqez6bcfCZyocvBCdviNPMu7xXzrW3rxCi7bGixjVd73vMe5JMKb3B+H+luq
 W5mo8RtX8Cg6oQ5YDJre4nAUcjgffv4gqoHS+0UQAqQd3i1s594vnGrVvLROCT//DI3K3N6MCGM
 3zX7oZhRG9SWzVc7yRHgi3kQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 944c59f8ed2ff705;
	Fri, 27 Nov 2026 15:41:01 +0000
X-Mizu-Trace-ID: 944c59f8ed2ff705
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: mpilaniy@redhat.com
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Fri, 27 Nov 2026 07:40:54 -0800
Message-ID: <20261127154054.43755-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <99670aa8-a33c-4a36-b8dd-66b02c6b6159@redhat.com>
References: <99670aa8-a33c-4a36-b8dd-66b02c6b6159@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m8eennd4rfgg1d8zcg68mg9db8xbeida
X-Rspamd-Queue-Id: B08CAC0003
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795794063-193164
X-HE-Meta: U2FsdGVkX18UhtUDBgeSnj/TFApxaAUkEUEuxu9g1qKnlTtpMhAiJUVQm+XfWfKZMWYPMGKSEXhmKnQyEyCeRtgfIWt2rQaTm4X2G/c1QbWZ22E4oOvss48ohuyndQvnwCqIO236dV57oFNKdBY71a0gG77xpAB7SxIW5vJ2qOQUGLulp1SH8AlWmI22HKvy+w/u9OKmUpPZMjtYoaE3+qQf65LhuwWJCQUFJpq8vW/kDjhpZEdjQAHZGfYf7Tp97d81Q+6b6HgXTZFCdl28TcW/+zdF6jSSRymGAD3h2SNstuxxdXMtC0U6kTfuvIOkSiNn2wE5HE2k57D/w6wxyluRHgBE6KpaH83c19wuoG+q3svfBzBkrN2D2nOXMPr1r13O82gxkELTTHiLWeCUM/v0mZQxll8ZYcy4rtOwvXDTxv6xsuMS75Jtti5YPGKB2i0G2cMUfUG8I4Lm04At+Q3NQIgNW5ODsMiy5SRk631akutTbCTNcRe3DrNoO5VuuZQDeTveKFcWX3xnlenXq3/dwsUsP1mb+ERlpdFD0QxMb0ppNIPXs9qI6tV4lUkpah/4xCPXWGbnGcE1CdNAm//lwRedllYfNdwxa65DaW2fw5rMU9vR+glJcPNoWZkWGu7VmOziR/FyGeVQkAJqklRxCRtCJ1CxirDAdAt5ddULeCJO9D1iez51sRmzGU1rtYwfgBSPyFBKGMLoTDy7zuyt6tv5vGBkmm9j85gSAmnlvZ83hM6C5qt60ednn/T4RTdjreUWpfgVnghgJp22H3JV+5Iy9P+yKDQxKkC7DzA82Qd3pobZrOWfuKDaaU6RamLiav9uU7B2WNHagYUy4HkLtBg8cMLx+NUUx9pcHMDLNi5DC9dSxQfFABUelmt/ajyf1hnC4EryfvpFzLQUUTUIUMyhm42ytHb4y/E6cGXquqJHkZWUb32AN7OqVNyTxZTFuMTAjDXcgQpYAAh
 hUilGBij
 3bn3RVTiKdqPMyVPWCT0XiE+inA3XFoTVNVwChZ1PN1oRnYQwnQDY2ggXR7kD4PP65m0fGcphqPPmADpvVCOB8+GxDxxDUIg6+PIMvdbvZ2Jfq5HF75knKxTsJTQpTbGiaKAN9uY9KPNgRWI2Db5rXBJzz3n+M8vTnOPRNOD7ztJmzsz9wGQS9emntSU6oG0OAiDI8pF/FNa8qoYtaNVHIWJovkMRqw+xaQ6KGuX/qRacdSUFIA1wbgxdczFB/txtOL1EpqhOv3seZ/vCtYhXaDAMavR3n0fzb+TAkBx6glN5NaneTwbJCbPdokB8Q66FkkGCc5bWbzw2rNxJGSj2vGP0/gEy+ZzheI6Rw+hr0zezulNnzPYCRa52yCiw3eIyFEQi93bM+7WEUqN6jubUk3gFUl+R7rssNuoR+BF34WyBlN+idSBy5X6Nc2Uodx31kHhVF9f4bkm3o/CHhqI2JGU5kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mukesh,

Thanks for the review, and sorry for the slow reply.

On 2026/11/4 20:24, Mukesh Pilaniya wrote:
>> +			pr_warn("Could not map UEFI KHO table!\n");
> This is a Linux EFI configuration table, not a __UEFI KHO table__, so
> IMHO; UEFI wording is wrong here.

Agreed. v7 changes it to:

	pr_warn("Could not map KHO config table!\n");

>> +	if (status != EFI_SUCCESS)
>> +		efi_err("Failed to install KHO config table!\n");
> When install_configuration_table fails, the pool allocation made
> just above using efi_bs_callis never freed, so a page of
> EFI_LOADER_DATA is leaked until ExitBootServices, This is a minor leak
> so mentioned here for review completeness.

Will fix in v7. The pool is freed when the install fails:

	if (status != EFI_SUCCESS) {
		efi_err("Failed to install KHO config table!\n");
		efi_bs_call(free_pool, kho);
	}

>> + * The EFI stub installs this table zeroed on a cold boot. It stays
>> + * in place across kexec; the running kernel rewrites it just before
>> + * each kexec, and the next kernel reads it during early boot.
> This statement is only true for the LoongArch and on arm64/riscv/x86 no
> table exists, so the comment describes a kernel-wide invariant that does
> not hold.

Right. I don't want to name only LoongArch here, because x86 is
expected to use the same table in a follow-up series. v7 rewords it
as:

 * Only installed by the EFI stub of architectures that pass KHO state
 * this way (currently LoongArch); elsewhere the table does not exist.
 * The stub installs it zeroed on a cold boot. It stays in place across
 * kexec; the running kernel rewrites it just before each kexec, and the
 * next kernel reads it during early boot.

Thanks,
George

