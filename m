Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05738606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=XMutx78q;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=w+C5MlwO
Received: by kanga.kvack.org (Postfix)
	id 1C61F6B05B0; Fri, 13 Nov 2026 06:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186336B0643; Fri, 13 Nov 2026 06:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C196B064A; Fri, 13 Nov 2026 06:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE1296B0643
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:37:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 645B3C0421
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:37:27 +0000 (UTC)
X-FDA: 85429895334.03.F1E1A28
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2AE81C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:37:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=XMutx78q;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="w +C5Mlw";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqDaFOXbn6o3S8HHZlHZu0Vt6yoGbjygKulRUdW7kQ4=;
	b=oaYSX9s/uoCYvOZSxGz29E6pteoizn05GE5ajKHb4fyYAWWasBQ7UFO+Fw6ab+Iha7vN0x
	nFBRX3S4eCVd8EL5SpnRfWc38gfFvKTCcvkv+uCSkFjVCh6uaEisymuMt1mvyj48i+Fpq9
	G4ta77SEolaCzdafNJUe8P15Cfqqq/0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=XMutx78q;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="w +C5Mlw";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569845;
	b=hZ4aAP6aPS8QbfwztCJmgGqnYXpBhqT/ZJVTPqr9Aj42TDoJbDvOeId7SKO25XVzuiCBkG
	hpWv+4vdFc6yP2xMvpQmFBG4qKGugyqG1cI/T99opSPnMcuyRQjE02O3eUZX2fVcPbi3Qr
	5F4F3nMtPII2U3BnIAZyUrvrJTpGkgw=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 27CAD1D0037D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:37:24 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 06:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794569837;
	 x=1794656237; bh=eqDaFOXbn6o3S8HHZlHZu0Vt6yoGbjygKulRUdW7kQ4=; b=
	XMutx78qZZJRLQBEXzsM8JfnagfBjawSSER4G2o/lHAG4GclepEtc397hOUipJMY
	z4lTMbAmk4ggZwaelA2gCoHXmjMR6dStPLtBXXMenhT0Ql2p0Xnv3507K231VCRF
	Oi1whI3yML1yqwmCTfvQMppSkY17Bonh1uOVmthFwcK3KUOgUh+UDz/DSeDQijnF
	28D+uS9reJr1SVbr+VUm0ZAx6RAxSfWvUmruo300gu0URXxLJFufHKBJ4iiR1PK5
	pxxfruk3XN8GHq8Pdz4iNh8WQc5W7N2HXhZHUbP3bOm/b6Ctg0DenyLnhcpBFOxT
	8s7E9/c7hf5EiS5Zdg/jMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794569837; x=
	1794656237; bh=eqDaFOXbn6o3S8HHZlHZu0Vt6yoGbjygKulRUdW7kQ4=; b=w
	+C5MlwOo/fDVHYBD0Yw3/zx5Jp25EhMJTgU0Jg8PC8Dpq5FP591YE5zfr0wOPv+a
	LDK7kDZadY35KqzMNxWkVF8MHPFANB+YlnnzxWVC97ej6J++HELDKvx8gN2V715N
	STm06619ceX5QsG5dNNFWzMAF1+5dGZ1UrBDRGbNbJENBWMIOm2BvaOHFK17oVCp
	hndemLShkyFAYMtJZ5UtUUs78YpfyIn/6nAZBlG7USgA2qewNVuU7scntIAIAVKF
	FEeOs3j4so5KYczmeJw052ZJmo4dYWhHO3Mfg1aZDWSEtDJbc1yD9hRYnSkRecxL
	Q9H21PMwSFVMaP15vv4Ag==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794569837; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:LkVMf7L4Bhp4S1H0trTdrSpj61H27wWIX64b1MK5Dr9iYns
	/4nSoMCUuu3t2ELBHDIjHqKWIoPL+0tFqOkna6QrNoCZTAvfMJ1MYrllfhKvlm32
	UFyBY/5vpocqvQBLf1gopHG3Qai6PMQJywmb6Gkaalwzi7MhHC18eZoYn8+8gGpc
	5FkuvWxg7yNeUQz/n6dqiUcii1LHww5h9FYTPrd9OsFQEb2VLIBiZZ/fomZlhFLd
	fYZRc/Qhb9//wqlVLJ5pnrW6pCWkO2155ElT7hKtmUmmCa9K7StNOlGpaBGt7LoQ
	w9iwkWZy+XyR95Wgj92UvHMbOMtez0mpZj9o+yw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:hcQpqBspszF/VCz1NmfPwhsfTCNQAReFRYNvZ9kSFUo=:hO/C540qRnhOl18EbccET9beT52alCAQHyu6g6Clb98=;
X-ME-Sender: <xms:Zfb2avCT-tojmG4Ikepw-p54Wlm9eUwu96QJgpS8e03i3ED6zqXKGQ>
    <xme:Zfb2agVxabpjuFZFE55yrfdaf9tLdiiaOi5g3IR8DfhCsw6E-85mYGPe-onXhwe-n
    NZLr0-AC6gAggAX9NGiRYjQYYR0yHI-bZTIK1kzqkGYEy-pPRAqTLNc>
X-ME-Proxy-Cause: dmFkZTEDiFGDLqF2H9+O9kclr9WMnCL6OtmFN7CRKWU2znaeciKnGD6T5j5ItjEVdHlbGD
    YqBOW+DNJB3dxdSQcDHRdnBA8Y7s/6uO3tiPJMyD4uWrj6XfbTOwNenN9IscialPmsIZTK
    0iXO6p/j6egEf168nQnX7Ck6iDbBV5k8fS1NCDx9srTPTp1fs71+kDyys9TsxsMrai3vEK
    +ri/I9u4ybluZLH5CI9YpmOiwlGpVMB4Y4GEpFea1kOP42w2C9SvPojFV8FOhqAVm34u82
    VKymHdXDCNJQNZsoaCTkpz9i0gZrK8MW0epDqLwnQl7FJ5LF1BzvR1o+nFKuQX8UZdb6IW
    vOonpJG+PF8aQuzJD8V+7aUD8HkmaFjkS3opKaRUMsNBqhGJataxqpCMThvDzXTwmxAXHz
    woFgxf15w7KvjgekxfLIoHkjn7nIBQg8vaHS/krIq2iahPBj4zymyaZrWQmE4zWSH034dX
    sK1RskPxfHErcP1SFbw32+61oRvnbATkD8cHsRr5EtKz8079tRU6jZV1uzy+hTrFmZBHN1
    rklbhmOOVcg1/Bz3kp1d+I+NtKAEHa34pfcAyYPJKNVPYQyb4eczQ9pzyVhHqytdgdCQXO
    0GSL4s2CbPUYh0tnyuKXggyeCYqA60zBxDp/vBqOH017HTQVKwjQYdZ7uyBg
X-ME-Proxy: <xmx:aPb2asthTUH2x8jA2KOwo1d3rh6en4ZcMR3WviUnQxNyoPSM1862vA>
    <xmx:aPb2an9DeWTknrfvXqc42PZmXbc0v-go1eebiGOYUyjyrJo5WOhSJg>
    <xmx:aPb2aunyVYsbVLl4cnBH2qPOM0Uf2YGHWWzaod_a0tT3Bar_JyQzQw>
    <xmx:aPb2avMOCFp0ldrdZ_SDhy2jWGzMP8RkeSQzvVn51CLQ7Ep9lYDaYw>
    <xmx:bfb2alyWeOT9UQF5g9D6se6HL21AL870fqnXN6bf27AtiRM2unC88dvf>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D0D2E32A0099; Fri, 13 Nov 2026 06:37:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: An903QizF2Ds
Date: Fri, 13 Nov 2026 12:36:49 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, x86@kernel.org
Message-Id: <2c9ad267-7908-4b62-940e-dc877dba5a75@app.fastmail.com>
In-Reply-To: <sashiko-outbox-212715@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-2-arnd@kernel.org> <sashiko-outbox-212715@kernel.org>
Subject: Re: [PATCH v2 1/6] ARM: remove support for highmem on VIVT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AE81C0004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: y5jqt7k8zfuzrq643gyiugy6yrrzhpnb
X-HE-Tag: 1794569845-965013
X-HE-Meta: U2FsdGVkX1/wGxtsqG55eOSvw9+YgZPhSO8PqzXAV85Tmauz5qXEnaZG/0ib/mr22ld6DcQ4DQtsAtKfms9Ek2tVypxiKDlM0K9EXwtdrGEBp2xYvhotkqTzJYSBDxsi4kh7F7dOTOp8xuYL7F5XFm7oKtXcgxFBIYfgwkVsTg31TwOYAqwhVY8YT6RqztzUqdx5lwYbcU11pamd82mn6nSikDlna6V3s1MZj4EccP91/RPhvcSPoodqf6SuVtcwJmk5ZECNTbkeUDeHophcCCbgB2WQcurESR2cJHIwT7xxeqxZ98PYTMf21iEf4LEXGWsGa6JS5lBAGqmIrNsdDUmlzg2covsLAphk7l+9eM73seY/u+aF5TQx33CwHTteYwztUXNoI2K3AWZK2RN1bDrAGg7otniWOX8WX5QTja8KkGuqWy/LiS3nxD4Ohsc6NbnUdI1z1XHT3Do8XBATohbHHF33ppiDdf3uEMHCjtM5IpuKZfClbHbu9cpYgttLtTmCyQd8nsKFsyh7OjVPNyX95V7/86ILqNRrgYOPU7FqCpFluJYgUfvWgmPL37Z1PztLPVodWrvmJ4WHXBy3g4nCPJZ8MDUSmYPUz+L/sKFNEuesRcCQSW2aRZEMPEmz9j56ArpEcElbwL11nHjmInQrT0FA4ODbE86MtK+QzcsLJQ/rvDzRSui1tE8O9bu4d5dD0R0uTtukI6aZX6BP1da3ZWT1V3Jdqtz3Qq6WZ8p+w48TwqSwIJvV+PjqggdTdSFykGL4NmMBvVMgjlO3YPO/3xlGV1VBykRuxHth+UgtdjUE/0DjdLE6iPH3IaWlcRb7cp7iKOkMT3xeUtLWjrFmNby1wHpv2uVIw93nYi5sOQ4m/yoQpcW3h/V7Cjb0dhkLqzbyEGyypgNJyD5InxVnWonkm96gELjOpa5bUFD4KFWcYE9E0PDBqxmLkyq9TmjFnojJqIKM7LVi8sW
 9dhqIW/q
 RDLz7XtDAB9TzGabsTTZ215Dx45sUvxXVhzjwFBYOm9roLpuX+mmibca3uC9cs3BBIdyhimLZ+8Q9WBGR5n1reZ5RkN3Ow+eTCrPGN/bnCwklZRnu7c17LLNGvqGLpcSth53n2m7EYFD61AZ5maAsET/cqWHU6gWg3c8xzfyqSA3oYhacxTvDK8c1jk00szAM0cgU0glzciVxrK6Ia0lYeTtry5YMECa46HeVgrGIf8qMdvWaGL9EwBkW4hIdYWWet+Ths/siTE7k2mC5SJUjbHTLgFoZqFBxYd6cgrNdgEUcX1TuVsZWV50yPy0JlvOTHOtt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, at 12:26, sashiko-bot@kernel.org wrote:

> [Severity: Low]
> Should arch/arm/configs/mv78xx0_defconfig also drop CONFIG_HIGHMEM=y?
> ARCH_MV78XX0 selects CPU_FEROCEON, which selects CPU_CACHE_VIVT, leaving
> CONFIG_HIGHMEM=y unreachable there as well.

I have already sent an unrelated  patch to remove that file, so
changing it here would only cause a merge conflict.

      Arnd

