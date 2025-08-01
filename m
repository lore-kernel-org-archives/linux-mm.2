Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37478C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 05:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89778E0005; Fri,  1 Aug 2025 01:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A2B8E0001; Fri,  1 Aug 2025 01:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02238E0005; Fri,  1 Aug 2025 01:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1528E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:58:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 150BC1610BD
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:58:15 +0000 (UTC)
X-FDA: 83727133350.21.98B9368
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6C04140008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:58:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=fWRPRYa4;
	spf=pass (imf09.hostedemail.com: domain of wangyuli@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754027892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFvqmtcImAqa5Bexq4o48IS0BaB9Rj36ckv1GO81Z5o=;
	b=X1/LTTnG52EffpFSli8PTXi0Xax/7N18oBEfgxP10uVrdnrqudU6NCTlJAN9w6QBj1E8d8
	kv6fJLUY6blvtZ5d87zjvxv3ZzSZJl8+d0tUrzT7Bi6Jb9eYaW7TQtjNm3M/2xpvRkp3B5
	smp5ElHNpl/PyYfCQZsAC2OuD69IcAI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=fWRPRYa4;
	spf=pass (imf09.hostedemail.com: domain of wangyuli@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754027892; a=rsa-sha256;
	cv=none;
	b=D4SeWgq7A3/onSA7t/L23M8bg8VqN8yjGPEjBvJanMp6x2dysVsrDluj9ipCgA6yb2h8NU
	YKjI9auRZMm4LQBWd7xQhUg4SuEfYr93zAla0usNU5xFo+RGcpTE9JfQ/ZnHIS59AnslIa
	o6mLp6IoPgGaMb4OB9sZaURQilfKg60=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1754027882;
	bh=TFvqmtcImAqa5Bexq4o48IS0BaB9Rj36ckv1GO81Z5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=fWRPRYa4YH5M17CP0vKphcUSxPDADbXqDPwB+dS51ALiK3toxcal36P9Ae5tco8uX
	 AW3kq8WNGu40+i3D56oG2xWuepCnhbbwiq0U6W8G0vNoUKfGcImhb1pdB9Z6oZdaXL
	 2ezR3bqL0vAdQmN6odX32jObTOMZdKGnWVnDpz7g=
X-QQ-mid: zesmtpip2t1754027843tc5d9a561
X-QQ-Originating-IP: 9polwzB6wHNRa9OZhoNU/nu10Gz2XWZDq7AVf6MVhxY=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 01 Aug 2025 13:57:21 +0800 (CST)
X-QQ-SSF: 0001000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17402468212891621763
EX-QQ-RecipientCnt: 12
Message-ID: <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
Date: Fri, 1 Aug 2025 13:57:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
Content-Language: en-US
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------omK4SvbleiFzIO0VTu0P9FLk"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: OMR9O8S7q+mY8et+CsmlYSqHfvVwmvOfhnZp+ZDSGvA3vYpdluyr7ht7
	GTHdF9gx2J2RVobMkzyfZ6NFDL3pUWZPJ3vq3koJ3WTM8wPiOoWrE6t/MX478poeNkSCnzL
	T6SQHsGMlxLtxEuQ5CbZgqnTiS9FaFCsmykRn8VsJM7+HRJIjF6knrfN93tHVUu3CCoUHmN
	PvTPy0fz1g8m/MhPWiOZqvIxB0rPr8sYYyLl0teJUEsjVMvNvW/+HssFOsUQttrO7qpl7GH
	RgbW4bFwNP9PeIqNzi3dxEo0yiKjy5+puNud6q2wko8kduwMZPf9LBVefQcGAe2x0yxYR9+
	urKzOdq7X2GK+pJPVeykBK7SLCcjgaaLn+eI/XZo/nJVWWJHqDtqI36d2DAEFMpWn8GjyMl
	s3VKU/AdFQuXwh+xU/kuUxwPgSMd6rqdLnRep+iXWTimRFLgmnELDl2pmbLzjAPfPln8j3M
	Eh5DLmiVdlJkTTV36rDFYS88xKQoGokNxfVCEXKlQSbfcqcuAJ0Q0/uuYZJeWA93lanBn3e
	Ad4eu3cPMM9kAzDnazFxpSJLS73UrDzbdg80F28SG6x670DulaXMOQvJaTUBlqd9LStDKlE
	a4gQrSWbB3HjSXPjd+rw2bok+7wjD85kDe2DaJdkOOA9C44oXJN+Ky49SKoQxcgOQLiXYOY
	J+1eN5AYyrIlBt08Q1QjoXLB2LA0gPXMP2d8ouegj4SloPjgoaOE5mOh6I4I9+SNmq3+dh3
	dd4DFA4kF7CYS0jY5mNEDqWReIL4IfRxKZ/42p3VeuqGhdNT55O0CG3+aIhBtg/CepzO0n4
	NYmZy4S2h0fsBXaY9BSe8N/9C9bFV2DiD8YgiZo6vSS6HbfmDWl38ORzotjIbt8kidUedSL
	bGSqOBVZ29yg5AmIPGGZ4NZ+dISgprKbrkMvHLUl6jEaiJ8Xt32d5FNtb/1ym2JnahM6jYE
	GP4FpGGLBLpFWwMKuF26WWMzTEDtgs44pFDugH3bZsmmdciFMtZ7umeVKXAHbYq8nmL4DTs
	DgnoGiehIMX7GedS6eL2fRFqr9lCx7rrpf4sM1QXrwlCeXq9j13MayXXZKfS3EGuHExNnf2
	deAAJFzQ+TuseJ3WgZbghAkMJjKixH75irijOdmHFK6w/BbeMxnFCb55zmaVEzded8Wxux8
	i4mlQC37canccuY=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0
X-Stat-Signature: key1fkadkyg7ybbhjok5as6xkku8cakj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6C04140008
X-Rspam-User: 
X-HE-Tag: 1754027891-867244
X-HE-Meta: U2FsdGVkX18315RTAR3Ia+QhICpsDtcvP0l3OkRE+GhGSvlVW6Sap5+tYRp7b0kg42kccOU5jREVunwkJXL4R8DBQ5y7cOymDyLopRTX43QLHqWXR5k1MYFHeW4rr2jFMkBq01QN6pgc9J1C+TZ+ceBDSIgYTRZC5j51hHWZU2gqKMNd+g0XCs+fc2XL40QVh7M64fuii2FsfO+EW9uDoB+j8J6CMz7pocTM9zk9B3w6O3zMlD9Q9iNS/kXmOscgcgAE48Dqo3xTY8TXVBPP+hBMN0TlZ9FUp0bAF3gOKKGhUg2LF9BXK3iPSX3HsdMABB6DB1BGbg7J84dyDcgmKmL2qTdQhyBdrCN2aEsxVUzP1LCUJ2nXa8AUsiP3Untm78fh36//uOn5poj+cKk1gRhYKwGe3HyMohFtCp3NCUyuBDGhvgG3OjeTsaK1rziEcaXLgzek1vWeQab4EkBD/nghMJ46sQxwzomgM6yjhWSts/UO7pUM4/PSAmRTorgIBHc0PHleM89jseoaQQOfxuk1v3CuOrQf/mKT+OO/7oI3Lj9siIaV0LpvNwUT30QIGViqcBwLUXF+wLmzld3TQ9bE9jrtXmZERSsm1ovfxBnE8hHmtlYhedRirxpB5LvKVj9g9TieaBLHT8WIHmm4fUPAE/weO0GRh+D0OpMbrXtTd2SW/MS5xA6ICTmwhl2j34Qra7Wx3YHaqKKwiJwkVzGj4F3bDicmdKqV7A1OcOsCpr0ZFr2kCxqIqLIzMNoJFNwVUxrhxeVkxPXv7hlQOCCHqtBh4kKHv1kSgFmLtQstIhjs1J9Pwe7OUnvDH29mRa6kp/kE9PhD35yPasZbmqY3PgIDelYW2zDUjb/IjO99yk7cV+rCarSapFMa0UmkZY1mx5aLRozA6H/jnrBwUTd7hVipNB/Qjdvf55vmLSdJempBAWaOC+TPKv+vsaht/UQ0TAlS+A7v1JuyZbu
 qPX3ffMC
 Sss/wFYhKZWdvw/raGIlSe+gJTb5U1Umy6uDNkO15zkzx1kdIoec+5Rp2iR5OXpnrviq67pkWseqXEwlz0sw+PWevdJAIR7LSApGnrN5Ke7Zj4L5MmFeD4nndibOuUIceztzcGvO+JqBAovsBBmKpqIxd7rT92A6yP7lrteefSgAH6Cbn3J+NMoQCUieDC9e0IWLKMKbQ1KYSrvBAKTbK2ycv5DXMkVlA31XbNqaWWED+qiRi1NOhCqg35sRmu7xlZ+kxxN8noJVt2U/dRVGJ8V/yvCRq3+SfCGwyb989IWR+DxT7UpE8V+r0FYoVqwRRXDwaX4yTD64dBMl0qOqPjARK4ON43UvkYW0dKWqXB16q8hs4GSAF2t3F+S99OETC/+aXB3HmJ0ZkdFftqkz6MTfsPv9vVo5JzeHLwf1nf2jZXFios8C9Fi/VbYPjEs4LyOlRYauTU3gxP5fS1l5OycmhbCGlvQq+9DhhkjwkNYusmmZXVwJQyIrLkrQ6WlgdA+2DyIsvMvRqL6ymoVFAaFdD/fXsACkVLixCwXt9yEiuexL/VZJ9SzregWwj9vkx9Uk/CiN6csZ1xlKJ+IkkwhjY3RvZqqrpLCCSnKNSXmLpVUFWNB8BnrdE2L+dq8F2O3gODfrT7yrKdVyH7W9Jq62q6PQLmscyW8gSzmRdf83UvSfzCdnDA8FsuaZvOZf/z4s8Vhcb3lBxDYAcuRqTbTj4qbmIVx2uW6RhDIIZybvdpAYMbEew48a/FRyOSU0TSLvwqSWYJp5ueL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------omK4SvbleiFzIO0VTu0P9FLk
Content-Type: multipart/mixed; boundary="------------n0lrM6oL0crQJSHrsvvooW83";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
Message-ID: <34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
In-Reply-To: <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>

--------------n0lrM6oL0crQJSHrsvvooW83
Content-Type: multipart/mixed; boundary="------------jeVl055xXeAO1sWb0pOt76Sp"

--------------jeVl055xXeAO1sWb0pOt76Sp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgYWxsLA0KDQpPbiAyMDI1LzgvMSAxMzoxNCwgTG9yZW56byBTdG9ha2VzIHdyb3RlOg0K
PiBXYW5nWXVsaSAtIGNvdWxkIHlvdSBjaGVjaz8gSWYgaXQncyBhcyBzaW1wbGUgYXMgdGhp
cywgZmVlbCBmcmVlIHRvIHNlbmQgYSBwYXRjaA0KPiBtYWtpbmcgdGhpcyBjaGFuZ2UuDQo+
DQo+IFRoYW5rcywgTG9yZW56bw0KPg0KSXQncyBub3QgdGhhdCBzaW1wbGUsIG9mIGNvdXJz
ZS4uLiBUaGF0IGRpZG4ndCB3b3JrLg0KDQpJJ2xsIHRha2UgYW5vdGhlciBsb29rLg0KDQpU
aGFua3MsDQoNCi0tIA0KV2FuZ1l1bGkNCg==
--------------jeVl055xXeAO1sWb0pOt76Sp
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------jeVl055xXeAO1sWb0pOt76Sp--

--------------n0lrM6oL0crQJSHrsvvooW83--

--------------omK4SvbleiFzIO0VTu0P9FLk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaIxXQQUDAAAAAAAKCRDF2h8wRvQL7oYM
AP9lRoFGnWOM70vOjy0/9CONc4lAMiPiucvTz6WV5iX+DgD8C6fBaLmgn5oomfV0WYsliayofzpb
aDIrjD4Qd8AVMQs=
=ChJs
-----END PGP SIGNATURE-----

--------------omK4SvbleiFzIO0VTu0P9FLk--

