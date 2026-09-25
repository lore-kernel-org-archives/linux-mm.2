Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0030C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 01:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A776B0088; Thu, 24 Sep 2026 21:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAA86B008A; Thu, 24 Sep 2026 21:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9656B008C; Thu, 24 Sep 2026 21:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709D46B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:16:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9442804C0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:16:04 +0000 (UTC)
X-FDA: 85250518248.30.0935E57
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7C5718000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:16:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="DTAILM l";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790298963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YJfF9vd+e/pP9rJpOLnapREzWNZdTk0hFkM9a4rgQM=;
	b=ohtW9cleA24vER46d+GVvLEyewMIXTIeeKkAXqzkwDxgWXLwlSmMLXTbkW/x5ircH/yLPX
	CcT4mfybCYiywwbg98pNMQ+lva/EXfZ0v8fQvs2mqTSJbQGF8xExLW7xj+4iTYUvQXDbHD
	4amVBNGabiINOZUF8/ZWZJ//zGwINjY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="DTAILM l";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790298963;
	b=TcculNXW9fg0u7qtcPz49clGSRcVKcp9Fn7wAKMXyzmD+Dbtw4preSg00BZhmhy5RmpLWV
	yJJJdFYmVYgMFhGg4WtpkAvYqRzPHULhR3qHU1Bcn4rkrGs7NQwD/rOmtOdd1kOV+8UXjs
	5TJCpD//zNV/RfqH8zSgp1vEc3s2kkc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=6YJfF9vd+e/pP9rJpOLnapREzWNZdTk0hFkM9a4rgQM=; b=DTAILM
	lz8JIy/3yZnOI9JunsSP2WWo/0fMdkdkqHNnZimRq1ZuzL99+5n3zCuRv7dDZYbThznXtJZ+FEgxk
	a37BntDlK6EKm/Fy7s1zN/A8QHV6Yd1qAo3wBWo/XL6s+P0luxTaFavSdW1hygyhp6I0qJU7L0A/t
	OU+EHx4bBD2VvHXm12CQQw7T9PLoEePGpDEeo4iZhjBcnqW9ddI0dce23c1fKoCIvNzzogIjL26f3
	K4Jar5iaXv+LdJli31C1ODL6hcCpP+/sLR64dbpq3mqjEh2Ig4j48vWIotoyrLgoLWHitsGn1g6/v
	ShMIKf+Yy7BnWuba8arT+jjmluWg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x9uWO-000000056sQ-1PxF;
	Fri, 25 Sep 2026 01:14:40 +0000
Message-ID: <12541da81f59db27af46096db8da5d425135a162.camel@surriel.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device
 infrastructure
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, gourry@gourry.net, haowenchao22@gmail.com,
 corbet@lwn.net, 	hughd@google.com, baolin.wang@linux.alibaba.com,
 tj@kernel.org, mkoutny@suse.com, 	skhan@linuxfoundation.org,
 kunwu.chan@linux.dev, kernel-team@meta.com, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Date: Thu, 24 Sep 2026 21:14:37 -0400
In-Reply-To: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
	 <20260918180241.3424851-2-nphamcs@gmail.com>
	 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
	 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
	 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
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
X-Stat-Signature: eytqxu1jfa8xocrd9595qjd36g9cam3w
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7C5718000B
X-HE-Tag: 1790298962-173214
X-HE-Meta: U2FsdGVkX1+fybyj8891NA/4U11DK3TysvhDnNXWkCKkMrJvSmwEbsHmerre/eHDBCePPgEOfe7qn4MoDiM5d41WIbGdb+Skh0W6DlqngbqKXRO2n1ee4e875nyJoVtv/Uj9hd4YFvENO+Um6jRUlranBIV5pNGg+MOwj0L5pNBxLchUl1EJLJUsIUhYdxz2ac6YC9i9WRkNFyvKvkU5rcdW+giO8fjloByAWMtI0vKD1vBjRu9o+Q6TgYfZsCo79k3iZcxlKgNhfzkVVmBzvYCrreejHlfUSUcr9pAL1eKPTcNAWunLz7FdzE1Ddd/dDx+T2KgHi9Nh2QSIH+zO7+4nKA8xEtUrOTMusq1ubAbrz05OqkJmyC4e3pZcth0Wa93qXuPqTRI9/qiQGXAoUT1UsUpGyk3yLvp0G1mpfwzIfQ4jUdowM9FbjIZeZVykmX0krjTB2kc+u86HJLlrvt624AvDtSFYJSQlcYsvxx8vzIoOzLsEo4CId72AM5mTMOlmSETP0xA5AaVFw6ggChEzMS7FfgbSauECTr1Aa/1ECUF2o2KXjmoP1EnmssX19sLGQZ1qivGSKRpfDbAx75RVnWAsvPGSuawtb5MtZCD3LSLEZnx9cLSreSzD0zeQsSgVbDCvmrZAdebw4E1o4QR1kocH1jXJWuESvIlLhzlOGB8jgAmLB8FNpl1jJi6/BCWxA6j8IMzCQ5uEuHUV0pK+KYMcq9nN23SXuMnxfs0Re4yHEk49CjLnP/Org9WXxzdj7mrNxz0fNOpfBoYX2pUivm1cHLfIKl2urMdfqhwdGVq++c9oeA05j2DYw5pdOu5ECR/nFITHufzRA+SeLl7E/O6BTXWNdrtY57plEUj1RfyZWd7D/SFhf4LZlhTcF9bnWtqhWKDSK1fe/znWtw1AlBnUglLdBysbVLYtsG+kdQr+uL9peKhHSAMRBqotFFMU1cQz5+kl/KmGix/
 Adh/a/L8
 gjoCys0pn99dW787mQ/a7db2BBVBFhYtc5PaR2IrEtOiJRLdsyPR7dpeFelJvHXVFx5/r74LOVDL/+3kYA2JavdGOc/kncUpT18DJ0T9+iBBhBp+z9AoUsLxzwaKovdGdsEkdY3vzWRJBlcRTmvsl6cd6kpewZI60CZ6nH6eEX8C/WVQw/VOHfLPD/PSPVALz4p278ydogGHwUx9hTdHGA8w/W+7f2m9+YgDfcaXPBSP4GFYpKpyG2K8k1t5JJlXbKv9zUU+grRUCwFMYorRaL3CbUEGvQb04YFcoG5mGxaxQeAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-24 at 14:43 -1000, Chris Li wrote:
> On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >=20
>=20
> > It is needed because vswap *is* a special device, with its own
> > requirements. If you don't special case-it, you'd get undesirable
> > behaviors.
>=20
> Ack, that is why I am against making it a special device. That is the
> whole idea behind xswap. It is just normal swap device implemented
> via
> swap_ops just like ext4 is a file system implemnet on top of VFS.

The filesystem layer is relatively clean because
it has a VFS.

Are you saying it is time we have a similar
abstraction layer on the swap side?

--=20
All Rights Reversed.

