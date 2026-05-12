Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B704CD4F37
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B576B0092; Tue, 12 May 2026 04:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC436B0093; Tue, 12 May 2026 04:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9E36B0095; Tue, 12 May 2026 04:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54F06B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:59:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 506321C0304
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:40 +0000 (UTC)
X-FDA: 84758169720.13.1FD59C1
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE697100004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=A159a+Qh;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmV7EhV35CsKQajYcbhb6mrhovbhrjlSKM4zYuqyZ90=;
	b=DjhlYTVeiCcmLcoW3Ws6IQk+7W+v/YP/321p8LoGVkHck8t7WFj7FwqlkRHp2f+Iz3eMc8
	1iE6TxbIUBLovG3YGCnWpdkBqKLlFSvw/hEGLwXBDFekH0/GRtd1blKxwMzT1TbdlRw4K0
	8Sp+jkNTnVhxsHMJRtguo+r8xV37i2A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=A159a+Qh;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576378; a=rsa-sha256;
	cv=none;
	b=5eNIhMgZUbi5rw8Uo7o5MDc6lUg7Akbj4tS5LHl4YKTzj3wUONWmSTWk0V9msIHwCf9Xmq
	5izo39tXahEtU4ReB5DsQeAtHlcAPhrsiIzDymguwdlmNLc09NK04ANt0xkZb5XpnMrQTi
	J55qVSOg2loyS+LP1DrPwgzAaBN+AOE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 238DA40E0140;
	Tue, 12 May 2026 08:59:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zbnA3-FYneSq; Tue, 12 May 2026 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1778576363; bh=CmV7EhV35CsKQajYcbhb6mrhovbhrjlSKM4zYuqyZ90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A159a+QhkXH6ityHUYTuOkZs8OIJXjtgvBR/jcvys/rzHuzs+JCQ3wReSAbrkg8E3
	 MZ3lVpaiQcJ3iwmChVdNaFW58Aob4FuZciclo7vsnWPReh9hpzhqlpNaiznpygvxEu
	 eOF3wZwHyfO3XsPyac13i+Ecg+BnlsBDAf6agqvPltBuCP5EmXlffHV1A4cqD4st9Z
	 wAISiwGmhlXo8Xb5Dl+Hy/nnFtxftcbEA/UPwvyc+RtWf3fDFEw9TkUxJEgBGL7mqi
	 j4jxOCB0UItdsLOOb1gs41kEsNT3D0jA+peAqFdKz5dcGT4iWG8ze91S4/TacJMBVE
	 glDf8WiAt5j7zDUzIUBvMY3ZanbxGsDadjJWu0uFKn1G1wKt0KXJp6qT19/YdUp5B9
	 fn4/4niVcseaBL0z+eT0FuXyx5TKVm1WxMCZqBcnczvz0EYPTcU4kMGsTXRpbh774t
	 /UvPLUVk7A0LwIjuujoLvTDoALfBfwFINQQX7q12rCTSC8ZGNF/FaAJscR0bb5hYW0
	 k4y+WdKspSrzBJIGoPMvWPIkv4KjLNw85Eb22tOQHu+2zQXkXj7uo4hsi9mQlhdner
	 BPOnQU1kcQ1YRyM4XmeJoNhczK75VlABTCdv+729GaVL3QmwuX5h7guGwmnuYfZsc/
	 Tmv8G1a1d1BZYKDGzK+6FQ9I=
Received: from zn.tnic (pd953014d.dip0.t-ipconnect.de [217.83.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B72BB40E00C2;
	Tue, 12 May 2026 08:58:45 +0000 (UTC)
Date: Tue, 12 May 2026 10:58:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com, shijujose2008@gmail.com
Subject: Re: [PATCH v19 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260512085840.GBagLrwPXIom3JWEbG@fat_crate.local>
References: <20260408172850.183-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260408172850.183-1-shiju.jose@huawei.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE697100004
X-Rspam-User: 
X-Stat-Signature: u73inqdq9uaxj1cj6y3bdf6isbjx66ct
X-HE-Tag: 1778576377-194029
X-HE-Meta: U2FsdGVkX1+DlczIwNuxxb8NjG8EXPBJ7I/dVNMwGRm1w5OdLbBYNKuxgLr6tdJmVAlpBcRAF0cNOwd5/Psje53sfcIRE2aq0vtTiOCpf9zl9P7QFf1gCqs/v2dkiWp4yf5TR/5i2rL/heLpgUHkxoHhLs0055jWIMsgmrKQrmH2ancPz2YsHlm8PjudfRq7vG8ikH5WxyXanImIbmz3KgoQjYEbSyEEb40Wvik09OPXWzTGtbe6Esv+7o6D3a8zEjIEmmFMP5SUMm1USSy1Gn/WnfiSAzb1109VT/17KEtiBsLxO0PUl+QlXOhCaVH7Cm1OCXoaQKifeBY5LyL8ORmkmI3CXTCgeVnYg7Eb/hRyFUCWF+o+wf88jaCOWxJaypTf+f9yP/rv0UKe25cpe5Sr9Inse8YEfgvb1VmFqHMpJDDBM23OaT1sv5uQk9C9Yo+OR7WNPtQ0BaOJnjWlJSo9KjGNecJQeZhdM3i2IkSCB6+nDfYkvHe+hzwd3fM1xc/0GCVaQzeEKQ0W/UX+6WmqvA/Z8c8D/q+bTxMm5pE8UQekG5DUMXFQ/BKozNMooWViwjxwQV2mQ7kXrzVH/myv/mdD7/yBPVXGDNr4Q7t4RIs9nU+COYn26TLFMAXQk/i8aNaxcnOPyJiyvE09t005llVU4+Y0iSXj6TTM8FVUsh9RQSBqVnX2/9sBauKU3RP/vT55IDSEiYvcn4CPeDn+HCrUWq4aGS5vhcIkh2tSQLi6ROlymH/9I/IBcE573SVJHbbddFfQMOkD3gZADbb5qP9P3aX4ECbSGqZSqHQC7jtcB4RUIYNlrjD/3tuvck3EvaklHXNsD7iAQfZOsS5rywVH41mx32B6HZb/PYc6nAZuQYf4dvdBn40s2HcQ/nR+HXw6hJI8dUEWA0rQV9J2qaAkHlkQLEsozIrJIHQyKSLSNa+JA6XmWr373xgSSyMiIqixeICHhsq6a42
 cxd2BDv3
 27hIi3Tdvv+Qs4T1MW/donnGx29CPtPCgs7KpMAamxWrShOOUH8wiwxXQ+1zpw/c2CWMUVYGxMlNbUWc7c8FChJvMYXxb/exBO7pLNbGzyRpr2k7SUGngb9B/v7bpUSnVqu/7erMnx2hf30kayWf2YOb+ElSTqoyaLavCJEOVQo3ZNZnJ9jHPR/DHkkM2MlhfYreYRHl9/YGlxdYmdtV1efTuRFUJtJagKPQxSvnFW+3IJESH8HbBa0MuGsbs0CGJwMUW4nvRfVgihhPHC3oVtRt2EQiIBZ/ISdZT+Ty0wfeC30r4B6eiDvuG5z0igyiOXw14o053wmHgC794jpSWIi88YAXkJcmqJiVeEulbeQm+b5KKyBic6lf741cQ/gLwggGS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 06:28:47PM +0100, shiju.jose@huawei.com wrote:
> Changes
> =======
> v18 -> v19:
> 1. Fixed gemini tool reported issues sent by Borislav. Thanks.
> https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com

I can still see outstanding issues there:

https://sashiko.dev/#/patchset/20260408172850.183-1-shiju.jose%40huawei.com

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

