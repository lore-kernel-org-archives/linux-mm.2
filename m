Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2380A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRD/+NsH
Received: by kanga.kvack.org (Postfix)
	id 0A4386B0929; Wed, 25 Nov 2026 03:06:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054D46B092B; Wed, 25 Nov 2026 03:06:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACA76B092C; Wed, 25 Nov 2026 03:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C752E6B0929
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:06:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50B08140DEC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:06:40 +0000 (UTC)
X-FDA: 85472909760.05.B106B85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3D7C140009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:06:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GRD/+NsH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795593998;
	b=wPzzQOhrvJ4MiCQrPZMwJkvQYnI20P+QEJ5VHz3i6U8ur0QRpf4FmP8yLqb0pP0HZ5lCAa
	q1eD/DKatW+nQpvpiPlDFuJ4yBXac9tHTGu2MynCaE596dLwxgSMB9bxVgf/yZoGbi4xbK
	/GBg1cQb62rAp+8/dosVea9DjXsREOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795593998;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAwq7jVcLMl/hLMdJ0fnOZZ65k1NfDaUFFJddAugcLg=;
	b=10Wb9MSlWKB4KOsX8NyqwUGt7sE01Wp+QFEYjDZSsK6tU2rc3DBBHWjVfk89EZp5eeHjLc
	mhQiImB34CdI5XHovC1WXWMUeRI4gLDPPyKbXldq0ezfsYKe4Q5HYMayYvLp5Q5ezSQSXn
	obRIWeObpbPp1bZxCD2zjnmB5yyVuTI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GRD/+NsH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9049A44654;
	Wed, 25 Nov 2026 08:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13E71F000CA;
	Wed, 25 Nov 2026 08:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593997;
	bh=rAwq7jVcLMl/hLMdJ0fnOZZ65k1NfDaUFFJddAugcLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GRD/+NsHjndkl4ur9cEbDV8Pi5pmB2bEfZxfI4kiI0akM1arVAI40KStuWjlZ4r0i
	 IP8V7+XVWYPeccHy+GsoCMm69Wt9JP125cczBGlSn4fvRCf3D04b8MSHP4g6ZB6fOE
	 FGk6RYts5BBfj1YtgASKq47Q39R6485tMZg4xITA0uX6m2S7xg+C11L5ok3b2KCdno
	 N4jHw5g1FMFBFGIUy4JT0J/VyfQOl38epDIHPapMXqt3UnKWHtWbT3hZ92wTnv0z/w
	 JnBHPaAnBZ5Fgjjtot7rWZjPSbSymboLuGt6uG70DTluVnJQdyiEnyIc7OnVUdsJdN
	 Xv48BE74a9haw==
Message-ID: <sashiko-outbox-232863@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] riscv: mm: make pud_leaf() only care about the leaf
 bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jingyi Sun" <1045704958@qq.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "David Hildenbrand" <david@kernel.org>, linux-mm@kvack.org
In-Reply-To: <tencent_9D774595101D7C0F5A46CBCE69817B8A6E06@qq.com>
References: <tencent_9D774595101D7C0F5A46CBCE69817B8A6E06@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 08:06:36 +0000
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A3D7C140009
X-Stat-Signature: untd354kuw8h1oxicakfr7ue9qd84g4c
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795593998-991086
X-HE-Meta: U2FsdGVkX18Wk9watmTuXblH3C6NaK8F4KsNDabc6PGfDx+3jwxLL8A6kVlNXHouJFcDlDFdiLSPjvUVxwclBJxKAW6IDoFZ9jezX1K4ckNlWUSh27NvtSoJ3/RQVQCmGG4RP+Wf8bb4KMblRzKaQ2O8gWGfUzijU04fbQf50E9dz/1nZjvUvTSeTXkhguBW143p/drAtIGK4QXeCxnOE3wIbrqT1NbW6J5+k2Y+NCKYv7IdGqMU6TfUDYAvljM8w2j9b0eyj+IYeXPKVzARHmj0t18WoxMrdGZ4o24VJYc3vGL+dCD+MVP4Ib+yYXEGLM1Tu1Hj40BqOKv+aJ74/yi7afNUh+fFMGaTn1wsPh2cVdfotQLyCgtvtrTuTEUwC1OJ3F77BJNFLPPC8FvTq5HTwN9zpoKl+otNbOASgegsP5sotJccI9JXGJ6jMmGOmNhykwbnmu8vxS8I68OrT8B22+c5sdGLx3KYKcge6ZQCz+8rdCAzkpLbdmf6tlxCIxnoEK7zdBdCMt2kuFvZz3p7iu2brheR6MhTHhaRC8l9U/oe4NbNA1mz+rzh0mx7MMhUfkPI7DejWwslBngshOofRRbFTSPn/nlA0y7AVhSrJDGv/1RtwNzVOwB8Knq68wzLPR8dVhyyeit/w5/Rd0URLjz++2mxd7y9vX7SN3CwSfdBtewZEol4vZaSN1V/2YB0KfaMm6qw5YoIvr0GGthmbDYR8Usgv9Cr8OIMuvIDGs2xcLMoUVEO1uOJbfzKtEXqhXbC61R9q53nUOr+IbyoiHnigxmADOZy6WsYQjG3/r6lxacYDPd5EIyUACkbRyecUw8+weWn2a1IMG+MU0qnKhrbPoBKxdzUALs8vPAFrCl/Ap7ksQgh7WDbblyNlGDCf3M7e2MymnF6gZ3soUgYeSuOjEEmVr4eZYZFnACV2m1J4joCbhggfQf7o/W5EdYmbr7IlkZDRBpnYVd
 blNN9clQ
 ALWUr0S34XyO79eojhaQD1oBTz+eLN1A/mPAds8JlTVCg4WfT7gOIAvkLzut57ETuhrIcR0/a9F0xBnEiUbeZ21sTA3IknsMQAVkAJh5hcq/aGR6OYrNU7dgHOBvo93sM2BDNfm28AM9hrgjtwypFbbv2w5Ore/4QmSP5239bcAyCuYppZEPtHWnPoS3z+vabY6/BWOTgUR8OkLsq0vaoizYjzbx9fKJZihagA97D6P+k4mYvMfhj2qga/8fl8mO8dKTC+EI5TptEZ3Ie1nH/JxeTD/imMr4VGZ5B+ysbqQL3HzJ+KFi/yfhqq3/piebQfTgE9pDGLWWLNgHGJO+Vj+IuJbjB4nbBcxGbpfgoGKHe6tHPU9JdHSy00iDlHPvO6B1Kv3Mk3KgwBuWA9b+waeEcpyIJuffH1FXYEMXMSfdsbbhl5E5sX9+h5m96EHHuwWrU8mYCxlrdYhzQZ0Xcjcg8vbIauJ8fVvh0BSytA6XpHw4DGBi8FeHNfyGO4Uco4NRJ1ewzpx8sURBRT99JfAuMkeC924P84LQSwSh3a/8a47GVBNF/X72A9HHlQXqO2bDErW4SvUGl9GTvt+2kDudaX0XJhDPTsslARS8rCK3H7pcgpaG8U5xGFg0gKhcmjr4jIMg74nBb63blHEdE8tOhLq/YNQcITcqCPFUZ5SsbO4MJzo2yE1B2MBU70Qpr00dIsVmlNPrp3nG1YPveDWZ828JGncZ2mudQvO526PhGAbqLYIzRFIzDP1MzRYG/VD6wcO1hH/P6Sjt8PjMkvMe4gSE21Z8F9EPBCAHGAS6G0xkW2QF3yxmLEQqn4vv/AgJHaLHvG8zZBvnZuidmHg/dpiHvlKGtbz5Tu0qcXnTz8I4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] riscv: mm: missing present check in pud_user_accessible_page()
--

commit d68f5d3a880f9ce9b41f596dae6d5013013582b2
Author: Jingyi Sun <1045704958@qq.com>

riscv: mm: make pud_leaf() only care about the leaf bits

This commit drops the pud_present() check from pud_leaf() so that
PROT_NONE huge PUD mappings are still recognized as leaf entries.

> diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm=
/pgtable-64.h
> index eb7708e35cf92..1f45ebce8a750 100644
> --- a/arch/riscv/include/asm/pgtable-64.h
> +++ b/arch/riscv/include/asm/pgtable-64.h
> @@ -226,7 +226,7 @@ static inline int pud_bad(pud_t pud)
>  #define pud_leaf	pud_leaf
>  static inline bool pud_leaf(pud_t pud)
>  {
> -	return pud_present(pud) && (pud_val(pud) & _PAGE_LEAF);
> +	return pud_val(pud) & _PAGE_LEAF;
>  }
> =20
>  static inline int pud_user(pud_t pud)

[Severity: Low]
Does dropping pud_present() here cause pud_user_accessible_page() to
return true for invalidated PUDs created by pud_mkinvalid()?

arch/riscv/include/asm/pgtable.h:pud_user_accessible_page() {
	return pud_leaf(pud) && pud_user(pud);
}

pud_mkinvalid() clears _PAGE_PRESENT and _PAGE_PROT_NONE while leaving
_PAGE_LEAF and _PAGE_USER set.  During change_huge_pud(),
pudp_invalidate() installs pud_mkinvalid(*pudp) via pudp_establish() ->
page_table_check_pud_set().  Because pud_user_accessible_page() no longer
checks whether the PUD is present, page_table_check accounts the
invalidated intermediate PUD as a live user mapping and performs
262,144 redundant page_ext counter increments and decrements across the
1G range before set_pud_at() installs the modified PUD.

Should pud_user_accessible_page() check for _PAGE_PRESENT (or
_PAGE_PRESENT | _PAGE_PROT_NONE), matching pmd_user_accessible_page() from
commit bdda2887cbf3 ("riscv: mm: exclude invalid THP PMDs from page table
check")?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_9D774595101=
D7C0F5A46CBCE69817B8A6E06@qq.com?part=3D1

