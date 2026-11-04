Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7398E606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MD8HHl2V
Received: by kanga.kvack.org (Postfix)
	id 358816B05B2; Tue,  3 Nov 2026 22:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E5B6B05B3; Tue,  3 Nov 2026 22:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221766B05B4; Tue,  3 Nov 2026 22:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F24C26B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:59:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB300A05E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:59:32 +0000 (UTC)
X-FDA: 85396082184.10.B759B38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3EB4B20003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:59:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MD8HHl2V;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793764771;
	b=TLQiVyclgF09mWAWLj98feuf9D9ktiGoXxUR+/73rE2Au6jfr22vEAEdXy2OfNzr9726Qk
	B9OyPHvGKLQuja+ac0Jz4V0/B8GM5yHGjFP57bEE4gSWLgM5cg9IoLKvMvjJ/FmUWYXsGc
	RUCoITOV4YNnnyZUvtBLdmVIDSDWiS4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MD8HHl2V;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793764771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVD57Vyoa++azfiqBAhfzngOl8QvU9DsGw/NobLJvHM=;
	b=MgA23aT8qu9kBe3xejqzZDtq1gkDXtNtPIHM7nngWPIIAQjxEfaRAm9uBMYIyEE7yI2CL8
	apzcoSNhH9AUN8KFNlz5bsPE9iv9XtBhZN+hwozDf3MqVrgt1tleED3jNdnmXatRRfgSzG
	z7JRmUcZRV29AoZs8Jl/ddbSsAUzTW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 496E842E42
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232D21F00A16
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793764770;
	bh=aVD57Vyoa++azfiqBAhfzngOl8QvU9DsGw/NobLJvHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MD8HHl2V9nd3qEjuMbvRrBTZH2bsLxioMX7oFVjfHv6Tesnt0q7hLLNSr/m+49jT8
	 lSaMljX+4CfG6xelFsRF1fxldkH8GVcb5JOkwpvBTB6C904Npj4yaJEsjO6nsYj8ky
	 PiTyHb3iLt9aZhE4hj5wbXMfIg2RSBp5ev3N2fC5Zj1mxwDiJy86cQwRZb4AVliw3Q
	 RwP5uHM1C6vmwTxZCfbm+Pbg1xxqSdX9YQI/nAp+Zkv4z5kDyaFy/li/WcsfKzh4sk
	 2fq9e0+Qa+LlcBpy/2sOS5dBim+3SbmMjvx243pGgrt4PUVTbroGo+xDHS+eYE2LqK
	 T53xBvgdG3ILQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so297125a12.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 19:59:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxKQVfCfEitZS3qi7Q94kVYHi2s6P5dn+R+CPCxax/F0uFMnQvAUWElNDdrNXI7/TwkOB3a5THKIw==@kvack.org
X-Gm-Message-State: APuU4Z9RASRveFxhTwvHKbBcAhbcbcWo5IizP94XsC31UNO9rbmeKwxR
	hWaW3mJcQh0RcbDauhSfvEBmZV6utMq5gvW9oMhDJWDHd3k9eiyX6XNP2xSgXnNpTWk8hZSRu4Z
	Ixh1kUWY/ouFGzyZLLSE6O8u9lDO1adA=
X-Received: by 2002:a05:6402:270f:b0:6ac:934e:a9ca with SMTP id
 4fb4d7f45d1cf-6b4d3289b13mr10634683a12.0.1793764768813; Tue, 03 Nov 2026
 19:59:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com> <20261103102941.11087-1-dongtai.guo@linux.dev>
In-Reply-To: <20261103102941.11087-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 4 Nov 2026 11:59:14 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
X-Gm-Features: AclHuK_D5CUCusV0Gl1o9MYw2oMRSISAj8jwmHzHqtDwF9y7DdV5NfyDMepEVEM
Message-ID: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
To: George Guo <dongtai.guo@linux.dev>
Cc: ardb@kernel.org, pratyush@kernel.org, rppt@kernel.org, 
	pasha.tatashin@soleen.com, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m5xgk9oke7dgiffy6kgxebufu66aa5sb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3EB4B20003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793764772-588200
X-HE-Meta: U2FsdGVkX1+mlCzvebT+VrxMuWSlSDRHSXyw/jBpESr23rJ1Nl0bhDlDv4uXgjbY6wl7WGl3g/5Bh8teiZNLXkf30E2Im+Aojqk1a6tRAMYVpthEpscFXCmJIu7sq9VQMzHT3x4nh8IO2ogfnJxFvnAVeCVZQ0s22PdKMldE6qL6rTzgzql6l34X/qcWrckg6wc/N0Z6YY4soYyX+t7nOjl4M9GvduHuU8CoVIdkXUpFyD784J+AVAVUnUYFZxyL5NGVi3tM0LMr99CqrJKhrh0SD589VMqfO15cUt+eNfm7yKs1RRqCuJ2rSqvDn5clOSer/2XDYHM+ADkDjUHOxoWYQeDywkXswjAlGxt80Tz4ybe3UH3qYSpDAZxvPt9MW5HZWV4jUwiJTWrpxmr2UpGbGeDMijK+b4dSmkDRmPacNLxS03jvQWZTIsAafLTQv1/04E9tboJzFGrvAbYaWFnR7qkPAIr6arT3Gpp3go+xJ2ScwvSyNm558Ipvqq8JEl0Xc7TB9B7zJzLgF/SnugINSDk4cT7UGuxd/J+qAaRuMYekqa0Urr8/N4tFchFIOmTbaKX82ct0kPHOXnoD1ExeM63VPqQ3AZ4E4z5T74w8VliJ4aVE+R+QWq/XQyKKXgNNmp/PlAlaC2P3TiyX9flmU0D9vIz46ljzsODwzSkLIGhqp6VHgyPsoz+Q2oopfGtK1wQzYPNiPS+wbnT4D/yXfzW2k6wrijW1bG5nq9Lq8DsI5lKor/ZLiZgltRaSxCam6GnnuO08lfeVgmrF8zvLMloqUxu1e+jfMmze81hsuy3+nru9dC5XtpgJJwHotlfl/xhx1pc+37FHIvI0xqZt8jT7SjLlm5CrKTiPiL3Nosw4L9o2hhArVRQ9ifgvCi/NTBCLC1N+FNvSIgWkXpgrzP0TKjtH+QTJX7LcBxaUqUm3IpHshY6jGa4xZ7OG3waLvfkIoB9pj56iC+4
 o8OjHj2l
 66brh61ISfkkY6wcM/WU0b5IW4s+RjRdGVO0nIcdAPiaziznNYuUYGrTtxK4EgWPLXsSWgraW9ud98kp2tn+ub3cl/HmU2bOVVn2GK9YBPpCrWNjvOGW5NhTqZrj/gz3IBIgpQoEHVjmbRRjSdeF5k0qNRCEk+0geTIEgp6pekxCpYaQ50B51wvAXpLKb3xmaBUa7ryoUlP7Tg4fwabm+eArv4JSWdq7ajVP4ZHrzLin++YCndfJUNEBSrrTBG8bPEgFNmnaSSuFhH27zrs6gDH8kLnNqZxmZGJ7/NaCEYZKXmaDMbE6Fy8JwsKfIfPRTW9fd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 6:29=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> Hi Ard, Pratyush,
>
> On Thu, Oct 29 2026, Ard Biesheuvel wrote:
> > Can we handle this as an arch table then, and handle everything in
> > the LoongArch arch code?
>
> Ard, LoongArch is currently the only user, so I understand the suggestion
> to keep the handling in the architecture code.
>
> My preference is to keep the table definition and handling common, given
> the potential for x86 to use it as Pratyush described in his reply, to
> replace setup_data once x86 gains EFI support. The table contains no
> LoongArch-specific fields, and only the LoongArch stub installs it. On
> systems without the table, the common code does nothing.
>
> Would that be acceptable, or would you prefer to keep the handling in
> LoongArch until a second architecture adopts it?
I prefer to keep it in LoongArch until a second architecture, and I
think Ard is the same. But this is not a strong objection to Pratyush.

Huacai

>
> Thanks,
> George

