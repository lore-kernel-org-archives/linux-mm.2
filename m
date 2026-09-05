Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88CFC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 13:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7956B0092; Sat,  5 Sep 2026 09:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71976B0095; Sat,  5 Sep 2026 09:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BA46B0096; Sat,  5 Sep 2026 09:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE8A6B0092
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:24:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17C97A447F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:24:06 +0000 (UTC)
X-FDA: 85179776892.24.5C251A8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id E094B20004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:24:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Y6T7wk E";
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788614643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xdX3u19Dwb6Bpywq5kWM1LOmEoefXtOBB0aNulunYA=;
	b=Idh2ZG87AsDQYktQWMoOro0mJjmGwfEYjY9zMYCYiho13a+6bjwn9RwzrvAkDwNAkUqfdt
	sZG+Gs/h0C97HZXx6u+BEJkr7RVPLCODAZiTm8a+U2wk6FsthjWA/G4M/8tT31kectWB8z
	Ja/TQVqnAYlJeJTn3hWHlQ9gGgukr6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788614643;
	b=IkIPaWyEAd+mksOWZmt6fj+gHll8SIDkJ61gZSBVK4nBEfwUrOLkgldRfTZV1zZPV3F7kk
	shKk6qJG93PsPX8NNFQWT+hNgMZ0EScIPSL9ZqrElDXAOPyV57ikuAtU/vwp4XRIoj0IjO
	CuA91y70mxqzLrH8a3IPnl7J6qB1br0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Y6T7wk E";
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+xdX3u19Dwb6Bpywq5kWM1LOmEoefXtOBB0aNulunYA=; b=Y6T7wk
	ECusJx5+FAWTrbWTYpRs2KnCXc7xlgPi9QnR84brPpnGqghG2BCyhkSl3uOY5D/yRp4ewBFpn1Xrn
	LOzm5dfgEzfH7wIsJJC9Wv356rd6RNYmX3UutZqJeHPu1Us1g7ljNCqjciOdRH2IeqBC3sRa+5KjS
	bivDBRAy+i04LY1wL0NisWZZU5aV439bxVHMFp9hsxIwhGyN3Ks0eP3x1iFt7gZLmdG1OUYyePGGh
	vldG1gOoCrrxQtv0WJkhvsULxkKkv13QwephDwn4zXbv/cQ1coX4Tqrgoo00aYgp3rwjbgz5w9TDq
	4rO2pJboQdI2iOszAk3yF/T2xYzA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x2qME-00000000tPx-0DNo;
	Sat, 05 Sep 2026 13:22:58 +0000
Message-ID: <5cb70d43baa959b4c0d1552d67ac5d4b4a17cd37.camel@surriel.com>
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
From: Rik van Riel <riel@surriel.com>
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 minchan.kim@gmail.com, 	lwoodman@redhat.com,
 kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, 	linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Date: Sat, 05 Sep 2026 09:22:55 -0400
In-Reply-To: <20260905061820.642437-1-tujinjiang@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E094B20004
X-Stat-Signature: 73hepy6gd6n76ddm1cfkd6bn4z7uccsg
X-HE-Tag: 1788614642-952287
X-HE-Meta: U2FsdGVkX18am7gjtVSZ13iYlT829ebrD4Mdyi+fPQ+9kz73F69m8v9VxYs2xwlwo5Rz5D0Iob4OHQAO79bEsI/f+oIBPVWG5UZ0zuuPnAScXZpRlprYuh7eagB5h1f8ne95gEqizB2cCOA0NG40KchVxgD55cWmZtrY0fsnfgdcxSb2yKvNt6LBfNxR8cTg+AhmRfQ4GcCDavQJqmvjIG8IyAMiBqy7yqmQ76PDaCcQP9x00LFfTJIn1ANWdmSofSyj3zD2C6bwBltUjy2JKA3PNfjSJxotX6jXIdaTRNJQU6E9l0yIbJo+Jfw4mzusr2M4JUcIggP23ZxjxzYCjSGUTqNq0nKqfEL1Mro0PkO8sew/jIiJEMG8RSb/zr7p9w0lDJkSgyhefIqfLkR22j7eV3jdd7I069pKZEwgmXyXuYNRFwslrDDS7HJNMdhsNTt3gbBrwmPVjM/5yGGyUttvdt4rF6P1B+5BFBzBgWb/hU6rbe1tJ5owC5JvWA1h865S4gcXjRGSVwaH2qqq+OsGMphmh33eXsiX+ckdIBnNbNenSLxFuiRj8Y1yEWdnwG6kxL6NyObkhi7MIrP/oTDhy7Yx9EHCf/JTbfzPMdRlLzezaJ5DMToBm3UxJOmBvS9RoapF85qoBae/p5Kd+IATM3QQQEP98Rc8KJRqUlbZomRbwhIojnhCcHH4Txqe/UbZL16Kf+tn6zlD0gQedq1Ffrv8qDH9v361LoqJaMX4bShp6QKhQrgjxtpDfVOQFbquiN/jPHDjpA44oWfTIa8H/edGFBzPlEygrI4/XwO463yQsVg4/zijL+RWsYVDfPHIYF677KoCGj6g88f4hMTx7U5uW0qZ5uWjKw5/3Gk8G9y7an8nOhulOJcXoxe7pZp3PopECtDpdTDcsbr0dbIgooEHuesUtOQXIAixKG1LaNRgVph/zzALprupEid5EKObVY0pRW9+Q3b7roX
 GqrsAyAH
 YJPVQgTUNFjluNufbkTDlGa4QpFaAgQd6RJAGN2QzcZbwlJJ/nMJhVby5ZO1OMqcBQeyCeMlh+MGrBGOO7fz8hbnyVoLJkAyQiWDHwPvjg66PnBuM8GGq3NSOPyHfgm2gSGNwksGgTSz9MRhiOLJUoY7UKeD2ZJl9msDJEeEz81xpsBABNRqjzNHumTjakzquWw1D09z7BifgBxLpPygNDLH5jXwT4HwTY2mms70qB6iwgNyg3q1OX7ETfqDtWOmk0nAgtxJUcLkNseYWn3+5vycQRU9FmmjkT5qvyT+q36z29h8EHqTbE7Qm0eUzkKW33xX/BYH/Z0gvYKKejuoaPmISKseV761k2n6Gl22oZEl523bWOmo7gOJ7U5WCrMBXpPUEQJEUOmhr8+icpAhQFb3B6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-05 at 14:18 +0800, Jinjiang Tu wrote:
>=20
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..a868e835eadb 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct
> *vma)
> =C2=A0	/* page_table_lock to protect against threads */
> =C2=A0	spin_lock(&mm->page_table_lock);
> =C2=A0	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma =3D anon_vma;
> +		/*
> +		 * The fields of anon_vma must be visible before
> anon_vma
> +		 * is published to vma->anon_vma.
> +		 */
> +		smp_store_release(&vma->anon_vma, anon_vma);
> =C2=A0		anon_vma_chain_assign(vma, avc, anon_vma);
> =C2=A0		anon_rmap_tree_insert(avc, anon_vma);
> =C2=A0		anon_vma->num_active_vmas++;

Nice catch on this bug!

This is perhaps a dumb question, but does this
write side barrier need to pair with a read
side barrier, to ensure the reads are also
correctly ordered?

--=20
All Rights Reversed.

