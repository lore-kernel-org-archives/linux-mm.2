Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931F2606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lC6uMZzr
Received: by kanga.kvack.org (Postfix)
	id A65EF6B063C; Thu, 19 Nov 2026 07:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFF86B063D; Thu, 19 Nov 2026 07:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEE16B063E; Thu, 19 Nov 2026 07:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB226B063C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:36:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3F8E1C453B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:36:42 +0000 (UTC)
X-FDA: 85451817486.06.7197A60
Received: from mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC5B040005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:36:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lC6uMZzr;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795091801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3UaETqrvFfA005xDH3cLACWIQAJP32vQKwKRzUivqI=;
	b=aC0WmFcGyvjQSxDi7FCfArBQCK+oHCPYoqbEP/hHZlKNO5Ck45d5rrjJ4yawsQXC4pJiiM
	0LAsm0RckY02/Lt/2VR/9+o0ozOU6YNIEFbjYeEfbQamsVd6/oIg0YButQXx/8kPwUbXpU
	/Yx3GteNRx/qyVE+B1ohZ5yl/iQubG4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lC6uMZzr;
	spf=pass (imf12.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.42 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795091801;
	b=q+7SXjAhyIQoh/sfYKowViA2Xv/w80mbGXV+NsvcD53zWed227aMnDSfI5btpqHicwLNaE
	PDmWTL7UItOagD8Hd41xky/HqVHAZPs4qaFBh8zhWfw62Tm39nNPSYSoEEJ8X4Dhm4clL7
	lXnmxSqPJKwHnzWj/cBm5+a+ddOAD0U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z3UaETqrvFfA005xDH3cLACWIQAJP32vQKwKRzUivqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795091797; v=1; x=1795696597;
 b=lC6uMZzr3ePKQeAmTHxIhjRO54prPfHzsGIGlwdxiRYK/x13orsA38lW/OKGvJ2UJwbnLaGu
 IJaqHUFanrC7+JPI1DpsvL2OT+FfjO6qijHirmQdj3INbUcFwvjLFj1Rdau0Gt/Mp99dF9OE8i1
 8w25qsNQUOiPVzeU3R/Bc0xs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 22a63bec1e9ad1bd;
	Thu, 19 Nov 2026 12:36:37 +0000
X-Mizu-Trace-ID: 22a63bec1e9ad1bd
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org,
	ardb@kernel.org
Cc: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
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
Date: Thu, 19 Nov 2026 21:36:31 +0900
Message-ID: <20261119123631.11165-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxzecch3x6k.fsf@kernel.org>
References: <2vxzecch3x6k.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e79drmgxmfj7c8zk5zz5pwa4otcfxq14
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC5B040005
X-HE-Tag: 1795091799-345598
X-HE-Meta: U2FsdGVkX19JMc3L9aB4jpafSxpJDHvluVro6aq8vLUl3JWEjj255egdxm4GbZMbMKbAvpkEe+wYA60YHKzdQqpmrpWL3w/8ISsroVkcUSoz/KmU5CPcLwbemetJGd9vG/9Wi8U41MTA9Bs3Q9shDCSk3Anzl5NiG3ea1ykZ196H0S+6+J2pxNGVADel1Yg5wcVzkUKBWByQLJQyvFoyGRRGbFABr5H1iPSrpbGFXoAjY+XZCm/NTZYJd4nKPy1Wv0aNYpzG0+zwvqtJfsghPBve9uftaYttl2c11Oi9ghXBuDiZUpNIQo22hpgBrXTru1lWk9RTwoGAA+oLpxhShX/W7TXFfaje8FjdxUnEUKSa4n8ImhyrlDaVmre9baZg0BfNzlI1Pi3naR4nTIiamtHOajz8lu65OkEXDN8m6qyKJEdpVnvKpxCvHEiMCilU8LR3TdFMhfBRr/QS2HL7qKvgJTKrvZKIwFBixYsyR7m7+NKzVkGAh9gzpMFMi4Ij42c9l0BHX/5RFDybpdoUA/kZuYjjMte3vNjrACw3wkCk+f5RrhCyZhcxXrm4fjMyNW2tb67I1+4FpvLmlH5185bpzanwnd5aCdz/x4wKNrQPZ2LUmRVPWCRlXSbjasN+h+ZQkxNo9H1dlzDdhjMqdxigA0VcgBlahONJvR8szJYnWk5c3S2AFGrEDmU3SHxnAglW0ZlDGvzoFao1jE7fX9kumxLN4wxJhYNlakmg+XsGsA1YM5mC3MjDN7yWl+Xv3V1CLvOevsuNFN2GVqi3uns5SfWmj0W/NhzCYrODwlY1NsqwQEh36q+Urk07D1kkmqoK9lRQqIhjnR3yyRQj8ka6dB2rrvzroh43W3ZwkxiVgs4akvjNztHNMhhgpsRSEsuQjwmGaoyUNz6fdIPtndUHwUgiZr87EFmaf26ZH3FrZSnsnXvz+LG43YkGe0Dh5tkyklNm4J5eF7wJ2An
 jQdQfGHs
 hWtwR7iWL9dtdVIJofQyUNAGBeKasIDMKma6eEvinJY0I6AEvwSISlvmEYLO+La+BD1iF0QlHe8ilMvam/zBCQuPdkL5ZZA1OZ0NeIaCP6Xc4p1EHQibecTtMpw8w4XyVryYCFT+/siM7GrEAk1tceMN7LOjiqNZWEfaKq347MaoXNg7MX3ALfedH3SDvRUSuzF77HpNrSpPddik4qYCg88wzLikZ1q7BxC+zi7QUDM19Hs15JgiA8E0tnZr8vZhdXWqV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

On Thu, Nov 19 2026, Pratyush Yadav wrote:
> Do we even care about non-EFI boot? I'd say ignore that for now until
> someone comes with a real use case for KHO on such systems.

OK. The fallback is only the existing setup_data path, kept when the
table is missing. I won't spend more effort on non-EFI boot, and
whether to remove setup_data can be decided in the x86 series.

> This should be a follow up series. Don't get your series get caught up
> in x86 changes.

Will do. v7 will keep the table common with LoongArch as the only
user, and the x86 patches will follow as a separate series.

> Sounds good to me. You will still need to chase Ard for an ACK on the
> generic EFI table though.

Ard, you asked whether this could be an arch table handled in the
LoongArch code. Pratyush would like a common table that x86 can move to
later, and the x86 prototype above used the same table without changing
its layout. Would you be OK with keeping it in drivers/firmware/efi/
for v7? If you would still rather have it in arch/loongarch/ until the
x86 series lands, I will move it there for v7.

Thanks,
George

