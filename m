Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59297CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 04:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516FE6B0092; Sat, 23 May 2026 00:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C76C6B0095; Sat, 23 May 2026 00:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDB36B0096; Sat, 23 May 2026 00:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4646B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:13:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 945221C0688
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:13:14 +0000 (UTC)
X-FDA: 84797364708.01.F9FE0CB
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3DEC160009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:13:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779509592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJgzOyXn3SUk4ySntxtM4XBfep9G6VR19ogyY1ZNrRY=;
	b=LGVAul7UnWqzvFz9UFwgW+C0Hsj8qNlnecH27l4vR4FZrc5w3muwNVo9aVm9R0aBQ9ql1u
	KGxWzITl+ZzdDhSIt9kY0KcJyLRvjNMXUFQ5vV1VKEHrK0AzszPxbL5cO05fvppTy1YNC0
	YVuP0fsvSWR+IY4E+RukuDSzNXiHtrA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779509592; a=rsa-sha256;
	cv=none;
	b=HErI9jD5SHGT6StFLXSwudKEX2FhPLxx472KJaYuyXtoQuqp8sSlTAmfYlGFjcedogOLHs
	ld2GlGAcfU5ZQy25qZiPFvm+oVmgz9mkgXINxW3/17Ym9ZPwEdfU1Sxx+XpNkehq+jEccO
	RJ1GvPS/nGTKsabKKz/vr1LfyR6W1Lc=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gMpfB35Xwz51Sm5;
	Sat, 23 May 2026 12:13:06 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 64N4D59C081328;
	Sat, 23 May 2026 12:13:05 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 23 May 2026 12:13:06 +0800 (CST)
X-Zmail-TransId: 2af96a1129520c8-70fdf
X-Mailer: Zmail v1.0
Message-ID: <2026052312130693566Qs1d0jDFuyl8QRUXBL0@zte.com.cn>
In-Reply-To: <20260522202824.fccba46554fb6223e63d685c@linux-foundation.org>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn,20260522202824.fccba46554fb6223e63d685c@linux-foundation.org
Date: Sat, 23 May 2026 12:13:06 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?562U5aSNOiBbUEFUQ0ggdjYgMC82XSBLU006IHBlcmZvcm1hbmNlIG9wdGltaXphdGlvbnMgZm9yIHJtYXBfd2Fsa19rc20=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64N4D59C081328
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 23 May 2026 12:13:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A112952.000/4gMpfB35Xwz51Sm5
X-Rspamd-Queue-Id: F3DEC160009
X-Stat-Signature: edg5mkoioumayo533i81djcjbsjcircr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779509591-42923
X-HE-Meta: U2FsdGVkX1+PPbj2pKA/OKWRmWXEMH9Fh4n5YY3LdBkPyVaVegMLAq/i4Id0se9U3pEXLA3GGJdWs8H3Ia8p+6NvmJd+K2p8PlJuMwL6cDTJdqwOtpP9nQL/tpPOgkQG165Lk2n7QupHD6eYgGSu37IPI6B1bN+N8XyDdDw0LkbucZMIg898bBCZmfyLiZRDCvSWxuwyVt/RezUq5x1EqZJr6GaKEuSza7w4H8qtd3MO2z2XBpaxM6uf0JdSnatstllWre3uej/lwxMqrSyWW+1VdUqNMQZCurj2ZkibH7BRcE/xuVRMi2cHlMogjHSNF9V+DmiUQLKBR7CelZQZIIlXIhwvicOkk4ckgK4VWnuwwJf4uXVcXBDDJw9PDn97eeqnYaj2Mf6uzviAVrtn31YKrM6QogvFzSVEJadraYS77Ms8qQ30+Z/8hbwq98s5kWheo2H60aC8kFTWc4VW07mkNBsK2ayAqM/0ndSXlxJ48ICd1PmijindD16bQzHpkLlTU9lae4GC1g8A9WGRbbk61uah0bhsU9fzMVOZVdZFaV4wgJFsY5mccngQNPyrUW+Q64GEWMrluLZsdSFtDuOXEaqQQUKG+bRGRWaEqxE1cm3gZ9s/Vn72BFFIaJXdAnzpNmj5bnYGnDDJqS3JyC9nJ+tsqLYOT8eKHihV6nhlVZfelngRvRsY/xVJRHeCXsnE0P4qfOa2S4aivhiTJrBK6UoScaXZv0Qs0Mv8WNK1iHOgAHKuZQxKB7qS41J75JLzjEE8M6RaL1kGT1+MP9iadYa00nneg2kUAF+vScfVhwcb+OTtxRIcmf4bnGVFcmlcuG/Eszi/1tIR0XO0kq8/SZXYLUPbKHv3ArCiqtZEoJaiLzOH8xF8cYHaaeKrLfesuyt+feZvWPnMtj75z3hggzyop/knHwmgMC+oLhdNAzQKF86JifXzQFMTdASThA/bDjwj2MqRjQR5tHa
 jhsuB1r1
 oOeW6KlKu/9Ikl76ZNxVCfSVSxPdmcZVjZM5Vqx7ngI/KUpM218ohIkWrd0TxXmLbEp2PJ8HTOEg45G7KA/AVjGgNQDm3PdGL6jSPxPIrF+4xLWEuCDDy+LtCzTGQE5pdPlexwHlvaBt/E2mBnZBpSkemWHMnhxQ8XNCtaiFwx7x3FX+znwzJrNVJ1Ov+FMKHeLGiw9j8dN2oe9fElf/gEzpp2SA+R+jUXYCdzxmEn62Y8yENQtDuNIEWEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> This series fixes a severe KSM reverse-mapping performance problem
>> that can freeze applications for hundreds of milliseconds under
>> memory pressure especially when a lot of unrelated VMAs sharing a
>> single anon_vma.
>
>Thanks.  I agree that this behaviour is quite obnoxious and getting it
>addressed is quite desirable.
>
>So I'd normally merge this in its present unreviewed state in order to
>push things along a bit, but the AI review gives me pause:
>
>    https://sashiko.dev/#/patchset/20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
>
>Can you please take a look, decide what (if any) changes are needed?

Yes

