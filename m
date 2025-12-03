Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AE2D12D71
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0206B000D; Wed,  3 Dec 2025 10:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7CF6B0012; Wed,  3 Dec 2025 10:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE2E6B0022; Wed,  3 Dec 2025 10:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6786B000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:00:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0E521A06CD
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:00:47 +0000 (UTC)
X-FDA: 84178471734.18.017AB03
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68F7D1C0013
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:00:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JKUqRZvD;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764774046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/WIQWuL+F++EVegTtlfllwMXbPuGlR48JJCbbuyV6o=;
	b=orSRvL8gBUe7o9xXcrxZKF898BFNg2S34+uppbh+66b4wYfL6nR5A+cP56e98YSokTESs9
	3tvbRnvFEIFY+V+6gtslKkS6aMRghulbnOJXSGQx1eUybTEYFBJIpVB/U8LpSyOrmBGAnm
	vr20WgKiVx/fXLWTXk2mq4WH216Gpt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764774046; a=rsa-sha256;
	cv=none;
	b=qS5DcdCzJ8vaddUbhNKlQCJjWMCEw/4NuwDcLf3FFWgp4MnYC+n9I8GYFiai4kUJ7etGWV
	b//qcZsZuv0Ds/TJqLhzNUye3PAljyoXdInSSls/YVlEo/N9WV0jU89AxWdF9SGAJqDmSH
	yNCdBDC60kF9Hz2D4m91g1aXHXVOp9A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JKUqRZvD;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H/WIQWuL+F++EVegTtlfllwMXbPuGlR48JJCbbuyV6o=; b=JKUqRZvDE6idiWZ6soqKKUQHqQ
	LJw3VsdEKREWDGD61D7hk3h8S93N7sdvvotBzWUMHyuzigoeJ3wf5XgApT+YNNMbudBRPC+OgalNl
	o3ZxcIsxZ8qLQBD4s/ptz/u6O3GbR4gsiLPIPl9+UC5wNs0Ipf97PIqP/izl6IlvbOBZAWal9rQJo
	mkOd6dVI0rUfMmiiDc4Ss5aTFImUhHLqCZ9kkPpl/luCvoOlpSwaVLopvA4qJ6xlZCRZX0uR48thF
	2dUVLlwkhhvz9kIYrjChlDwxIjUpZ0YGaBPBHZAkXc39JyqJ1C5g4l7O6qNaP826R4L2bVAWpzND0
	vk1hT7Kw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vQoKo-000000006tS-0aPE;
	Wed, 03 Dec 2025 10:00:03 -0500
Message-ID: <ed2fd8ed5d3c64e0e57e0d38fe6e3d712f22d13f.camel@surriel.com>
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Borislav Petkov
	 <bp@alien8.de>, Kiryl Shutsemau <kas@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Date: Wed, 03 Dec 2025 10:00:03 -0500
In-Reply-To: <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
References: <20251125175753.1428857-1-prsampat@amd.com>
	 <20251125175753.1428857-3-prsampat@amd.com>
	 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
	 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
	 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
	 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
	 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
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
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68F7D1C0013
X-Stat-Signature: ypxcso7wxe13ba1qkjiyond3nwhko48d
X-Rspam-User: 
X-HE-Tag: 1764774044-79255
X-HE-Meta: U2FsdGVkX19q4/BGJxODtdwpRbStE6OvRqJ0vapaP/inRxkd6Ch6rJIGwSQm5Hpy3t7xw7w7oidonmFso7PjDyJ/vRzQ+5T6PlVUuUVd8ILPKLPlnmH05pRD5d0Ie+Nz6NVbgCqVPPf9q1MN9xEdLMA+H3FkuDTPHXmz+O16oHxvYtDVWOnPalKXQ/qIgKxnYrIaW0yYvtSCNJi9vC0pHBNvajo5Q56OJ2+1iJZ0TfpSm8bByITQ4phDad2m0ewRDb3fjRnjZpnkFtehpAC028xBSm9DYYU5Dyo2qqntvjm6z+eanYg0+8FoLV2XEVIH5o6lSZBOaFmyy2x9OdqPl31gou1izfMCWoRbAgH0TJvkbT8X/Tmr2R+WiVT6XDcG7U6rBKKDpzn595P4V1V5bA7wFXnVc8lHbiimiFCfoijk2iAovFOEBUMIPM9RS4HL+TbfgleD9HR30wOy1vwMFUmGq4+5TUch78hv3t3eXsoG2Zfxl5LmfhTLhlIN3OAROaJtwPk06noIiA/bQqQ/vF0VBpAzFjni6P1J9NxMVCp696O3A4X4suM2dr+wjB4acz7oy77bZQvC6hHsTzLu5pjVS5vH96mM43sn2YE8HGprfO2nXtKMi7pnQYhuHdbBxScWeltI/Zfvb1kZowmW5wcTOeCK6w37pqzcxUKjsjY0ZhUYcoqTZEDNx1k4kafp6P9VvfR7eqQweSxi0HxJpTSWLj4ey/rQb4VRPGdWY6K6xjUUmESGBkw+Vv1CDJztcMqxKFPmF2CiCG88thQR8PNHBKzDthnQMTl49GnGGC5U6UhSEl3IV62/JMfBweeIBSUjEs6nj7mcry0jmSK77SvlAAB79G6uPzrZ/+GTJbmaxa7YTi1+iLtz6IJbgzjCZ+voKIqusrmYMX1+o4+B9skvqAFyLC1bEvKHmDyI4hUtegG30byF9/1yfO+IE5lARorzfvPHL0MQSh7kFKU
 JxA2IVsr
 4Y0wajlxYIyP8mOPxwUCyG6iGXaLTdm1PkMZvhLsJMxNpU2P1+XrfVu42pN/AJHuljXJDwPyjkHV+xeJSgef3Hh3BMVD26D+3F160GsofwConjabyAHH30HLx3HgE5fKCbz56uwTHsRMEg6pCnolNebg4OT3qjKjZi+qaPQy4YCsrSdy9fzbyjC/UU8y9ZSoHrPC/W9SngUXbqg0IBIjTYCdMgJr50hxiKadSZBPnpOgtmoJbgUlleq5p9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-11-28 at 10:30 +0100, David Hildenbrand (Red Hat) wrote:
> On 11/27/25 19:12, Borislav Petkov wrote:
> >=20
> > None of that matters if you kexec the same kernels.
> >=20
> > IOW, for some reason you want to be able to kexec different
> > kernels. The
> > question is why do we care?
>=20
> kexecing the same kernel is typically used for kdump purposes.
>=20
> kexecing different kernels is used for all sorts of things=20
> (live-upgrade, grub-emu come to mind). It's quite common to kexec=20
> different kernels, or maybe I misunderstood the question here?
>=20

Even for kdump it is not unusual to use a different
kernel.

When working on kernel code, getting a proper crash
dump can really help figure out where my code went
wrong.

It helps if the kdump kernel doesn't have the same
broken code that my test kernel does :)

--=20
All Rights Reversed.

