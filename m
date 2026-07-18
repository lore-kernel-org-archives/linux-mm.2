Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8096C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 15:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0A36B007B; Sat, 18 Jul 2026 11:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A20B6B0092; Sat, 18 Jul 2026 11:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7726B0093; Sat, 18 Jul 2026 11:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3926B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 11:13:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7C3D140360
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:13:20 +0000 (UTC)
X-FDA: 85002240960.28.FB01C81
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 749FC160004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:13:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MdDV8tCy;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784387599;
	b=LBbdz8Ma38ixOqytq++zvLPL/PV6T5yYbuhDKtIt1DOqanQU1IXxU2gidMqhC/xL6wvcDd
	TxyyFMFswbvebyPCg6I+1IafvQlOAiMnacIk6K4aGpPnE9Hb1FpGzIAqoaOmKNwfj+u+/X
	XMgrr1gygOKV5xT1Cewft12UKfWrwtU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MdDV8tCy;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784387599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOrxs76HcHbX8sKHP7kCOZuuDQ6BQh8pFNy4vBZ32ZM=;
	b=zbB0w+b+XDAIfB3bCNXK3qnpASjdbxgm/1gHxoV+0Z93Bxg0gm5GLiTeM81GNXI6qw0vuZ
	6j1jkr83JKtcBNL1KeuMuoZYlSE1f4h/letYk885nZolW4klf4EVOeIbg9Sr1DlmKU9eg8
	072HPibgQaoIj8M49haq98Es6Q9SrY4=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1205140E019F;
	Sat, 18 Jul 2026 15:13:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id etNWueav3Hj4; Sat, 18 Jul 2026 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784387584; bh=mOrxs76HcHbX8sKHP7kCOZuuDQ6BQh8pFNy4vBZ32ZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MdDV8tCyIrc/n6jaUatPzyTzBWQb/RKhtI/z1mMo06tAhtU4MkgzC6B8YquVw6I+H
	 z518171qYK6Zjwj+onG0as18Xhc0FaslgvaJbxErGrLBYApCInYLK/OIJL4jnvEUVb
	 Nn2QRqIT2pamoM5rOgcVmDkkKHeJ0TCQt8zxvkf40ekYWHKdime9ymWPxXXcVuzGCx
	 W5Omqwg1CjPBj7dkxlpfXrU7U6hqpw+ytGnx4urDmAAdc1VCkiJmeZJ1fAgNUIbfEU
	 EyKcL7+0mqmdmud0Kb64RzDsoXtcH3rG8Z8AT5OGyi201Xt/gIki85KUIkS97MOCir
	 FgaBn8slnshBli7b6cMqh61yveSHqrpUeo5WCnXpP1a0r7q/x61c299XI6TjI8HeAk
	 DoGHMgqHKymHsI+n/6RMsZ374zeyh/BoCtrRbviSNzl+oEhcTjrADjQgQc6Qg/NNou
	 BJu+dNWvJseO3QFqnDjv2wLzmmTU6y4StMoh7ckJ3KysahDXIv1omEoEyX192pHZqr
	 fY+yHHag31RP26tqLT6qHp0p/luRc++rsWfWTTo5j45CfHZGOOr/DoBEsmXrT3d3lB
	 OtSZqKuylz1TkUtTlrkasuuFija5i2PnWEoafXU8lUt+S1bzIIgYoveqM7iLdoiu0/
	 1t5eJeRkq1y36ZoLqcwW2vT8=
Received: from stx.tnic (unknown [12.110.208.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 53F9440E0031;
	Sat, 18 Jul 2026 15:12:27 +0000 (UTC)
Date: Sat, 18 Jul 2026 08:12:24 -0700
From: Borislav Petkov <bp@alien8.de>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
	jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
Subject: Re: [PATCH v21 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260718151224.GBaluX2N0kM11Wb11C@fat_crate.local>
References: <20260706000338.362421-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260706000338.362421-1-shijujose2008@gmail.com>
X-Rspamd-Queue-Id: 749FC160004
X-Rspam-User: 
X-Stat-Signature: 36ikzbatjjohgik5ijnm4cis3gnxi16y
X-Rspamd-Server: rspam03
X-HE-Tag: 1784387598-967316
X-HE-Meta: U2FsdGVkX1+BMyTT74IqhLQeNiY29Im4LCvVSIFe70u9tXBr8yYgC282DJZ1jXVpcNMOcZIEIi0ehtOkyyEd8tkFDdbqySAioUS0JbH2+biKMQD5RL/ccyvElsr+hpsfM1M9GScb154oLPNyU/FoSNqEHWplbP3v35fe07ny2HgqXTkvxeethBfGBcI/q9nT3Mn6ESH6RDmQtkWG7naGsckMvLeWa1SRtp5RtquRyGiKcBFVAXkv8FON1RRMnyQxxKP7J3ggTG6EtazCCoqUp1fXBiZ1rTCJET3MEbd3A/jvNYAtuZYwJypWGt5DNfvForxNC1qXkFTtuHT6TA5zqrZeT4S/B5nGVSqXrjnBVjyhxqJdGgXuFVKujVhrzSY8FNuI1C4IjNRnuA2bMalS7fPJd+OJLZy/MM6eMplChtO66RdCj/Xa3Lo9JdQZcCxgSsmdTjZ30RCahjyfFQBVstNzsyDC8a27cPK1lF2VtPnRPNs1d+R8hk+Vzxi3iYdWoW3R1bMKkWpDcN3ZmRzn4DIbzD4cl1xLcJtmN//qZ2VFWyTLH1FQOX8BK6OhWGZuXYo0PMMuH/B+WLdeKoVWeHcb44L6Hdfs1Z40qoVDSpeTNEK5IhazF0sYoeTdHijZxm7gM4QketFUWN9ECQIuPa0/r1umMihybrO/uthkNHULAbF15N4WnLQ2Jd1YryVWFRx0dOT/dWzifVlv/AV7ltQ7R79/yhCqMDSu3vG3DgCWU7rMTnAAxMCeyS4G7ZqwFYxSbXgqMBeiUAq9A+/LATyv6crQgl30mGwaGrkCDobrLlUxor9vKAueKQHZEYR/buXcxRM/dp8zLJs0zPNRW5/9I+4k5zeohSiTAfrM3jhT2iZLWqhQAOyILwoXsiIP3I1SqeJjW1gFAjPc61336J3YyOmM57CmV2cwT5cWhnFCE0y1JtET3QrxO3XX5MrsioWgl39RDn7OrqbUHL7
 851XAZ1L
 QzlOfmfXFrMIv8ceSV3LggyAA3EiEEkBmzlEhhqiPB46jnlD8u1d1XsM/H3BfZMyZ9lqTB5+WvOOCi2Q+bI3yoEevgZBd/Ysn21nz9SyZsZjm4IOFrTpsOhoZb0VWRUFA8dsnGnIMPkbyoKYIVv6i6FtuQizlaLGl4wHCluvzTaCiyB6CUl8efBonQJNOf/AkyRIYp+GM68/h81uPb5byn3EngPBCHjodTP0W3nLkeKi6ixSrQxk/S+iHt4law0bt3yB0NPlMNLkgzaHAAb/8wtdlF4yC6ZM1o9pY7Y8gKb7Xydor/Rn1OCJSREAODXAgDjW3GEiH8zlKbtwPqRSDRN2ZCk/bNMQy8pV6J5OPIRl3Ancy1diRfVJeUm1eIsOvj4l8OzGNYIUYowv8p/qE0Lf9YuDLrbT/k8HVr+jqIAVIjBet1OaM9rXxkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 01:03:36AM +0100, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 
> Add support for ACPI RAS2 feature table (RAS2) defined in the
> ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> scrubbing feature.

Sashiko is asking more questions:

https://sashiko.dev/#/patchset/20260706000338.362421-1-shijujose2008%40gmail.com

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

