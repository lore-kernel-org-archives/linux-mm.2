Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA27FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4286B007B; Fri,  1 Aug 2025 05:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E346B0088; Fri,  1 Aug 2025 05:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C7E6B008A; Fri,  1 Aug 2025 05:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432606B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:27:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8B27BED4D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:27:47 +0000 (UTC)
X-FDA: 83727661374.06.FCC4C6E
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3FBE1A0011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:27:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=mjTQDnR5;
	spf=pass (imf19.hostedemail.com: domain of wangyuli@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754040465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh8xkW+ufhMGgv7blqxjQLVMUq0GO1Fv91E3kx6M6o8=;
	b=wrPKMXhdPKCD0N8oUqpUZGqUqWHagWkAErcSc7CD26RMZydf7tAJdLDPc/HjsC2BCnO8g/
	C3qI/YHkCmTo3U/ZiZ0l45yHMc4pLrxyda6B2UUyxHwt2PSpN/bcE+ApH+xBpCVNPcivK3
	fBuAsNtwva1hY9s1LdR65Rz3gqYGK1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754040465; a=rsa-sha256;
	cv=none;
	b=dCh6uTMk0hPDp7EUrsfSNLbb7ouPacgbCnz9VN1l4YLNVD1QvsS6f4AGAoL1A1qb/2yUQ/
	xKv++9eozpXcAjUf25LuFhzZzFwEu2fAIFple7LChN2TmJel8CoLSgV/yj4cYDAe5tjiG6
	oQLo/YxL5amIvKvYy6ORi9Id8FogxKY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=mjTQDnR5;
	spf=pass (imf19.hostedemail.com: domain of wangyuli@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1754040451;
	bh=Rh8xkW+ufhMGgv7blqxjQLVMUq0GO1Fv91E3kx6M6o8=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=mjTQDnR5Wd73WK2BjIn/+vjnzIDVKEWab2txTcxfV/a6qis5J5MGSdB1E5ToeG1dX
	 XPp4CZ2j0hQV66BAh4XJ8svJsNmy/07lAB/0gQMzwS/WLlZB4oxem4LPEW08h5ZZmi
	 WJ1OfqzjEesq6Qmdc1E3alz2vUxfNXAhuP64f/Cc=
X-QQ-mid: zesmtpip2t1754040412t009af24f
X-QQ-Originating-IP: 2jgu5Ybud9JkDWmV6wAJSyrKtDhCEzc3RzZEawk0UlQ=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 01 Aug 2025 17:26:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5954868880669564702
EX-QQ-RecipientCnt: 12
Message-ID: <E6DF1F491EEF7B1E+9ce0f7cf-7463-48cd-b80f-1fe0cb1ea70d@uniontech.com>
Date: Fri, 1 Aug 2025 17:26:50 +0800
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
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
 <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
 <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
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
In-Reply-To: <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tqVatPxkL60d1StyO0S0iNcS"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: Ocs76G12hfvkA1KylAFpcsJUgAXi1YDRyj44Vpme7fK3udH72Amx79RH
	Gu6Xkzt7doIb3W0B+UJigxYD+F+i42J+d1eiq9Dv1jKhEYu/Smo/TKGkPS9bw8445mgVvFC
	HNOkPDdptfgx/5o+HS/VAqhGj2XMbMHd3MOaSJVVTbLG6Erh0Neyfr5SmUXE/KVGD8QEQaG
	bU7tJo2hyIDFtdUGRD2COXWEb4Cx6KOIU76pVQcQVTLRvt2zC9LEXwmAZUfDD8rn3eYUuar
	ss+xBOPF7FRFmALyyaUOxUN6EbUU9toXfavCZY8dszlcRwgZ4fAOkfmAYzLbDObZbLNMHWa
	QyIGSNM0OwdmYmsthg8dG/ZMSxe23KKiO+M2Z46a/QufCZWkDGPs52qR6PB/J5cJmND4ssc
	TWkwSY0lsdZRDaxadBMAVtbCOIbFUglvrUYKVxpweCJRg2cLG800GiumSE0ELnTOLUFvLWI
	IoelorGIYKUqcz8iQH7PG5GrSYnF/H0Slr0rnz/c0X7oWZgaDOwfnZq+9lgQ4Q2tPaxyw1T
	yM13Lti8EpjEpCaeKFFt7A/ZGC6LylWWQnKuYHqPYFOqCflkBsg1z9qG8xoYDEqpMHeFGUR
	ztt/n5g1OcXvPRUaazXBoWqZjhwK7SmEEXf6vkAjudYKhNjlZPP9AsHPlaotQTBQXXVAeKE
	M4jGfWhwW+ylC0JnGgRHS9iqJ5MHNfYRli1GyrWGtiSIl85D3pVMwgK6IHJieosueHEYGII
	ggPpis5ZhYnnuiTjgaPEo3k2bqCyYjv1+IxgoBnwiGY8qhLxDSXEu+TwEn06jpD/mJ+8W8F
	W1gscR2cFphyWg87kQiAoZlPUfS2hYsMktokaqaFbaD26Ioi6BdLYUmpbdqzIXYOMI2C5H+
	A9jWdvCUpH7s8OlXg/SNRFRMPcJ0Z2Gb19NfbkOa4eXpISza6mQMqTmF9El4Vyt3n6yk6hb
	xk1WJr1PpU096nOsL4ZhScaDsKnEOtfgmqw4mnvtfQQEFHCWlnDOJ/9edxEMYZ60jJ05TSQ
	y0dh7+PQJ2Uz+S8gavrL+4nJ2rrXXuLMEAvAn1yH9dugy6yxqv27FBSwcOgEbxv59FtXOzl
	KAATgotIQ5HUBavmJiVNN6RmDQKP3OoGgOvVDqDMSYZNFVdrjRsVpktPdRyidX+aQ==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: A3FBE1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: i51bjsd6n91ewzx47kxja4cs18ojzh5w
X-HE-Tag: 1754040464-244105
X-HE-Meta: U2FsdGVkX184hVVGVvHboZ58AIRybYp4Zf4kmOsBv8olIuaLTwqxTtfduSlEzePscJr03SzAuYE+2CnshUIlQilTBcmruyQk4MhzEAy8PTaVXcLD0nz5HhKNWZ7D/UFjWu6lLXkBUYwE/jx27sL7n5+B+vFZ7GaFw74+CmAM3mV6IRhigSxUCN9SRxuCsj+pTjUUlHKaQQXG9AZ58Nj5n0a7C3W7AmXUwe/qX5SqrBugvXhno0A6ERRFh1Lhh2AVP5obtnY2IZWSWEy2hxrGI4wmn5p0JrcHnQhaKG9AJLekXj8B/vtdvCvDpq5Adyh8qKLvHWb7wvWmwx/i6oeagm/TuWpIa54MH6jaLmTJyYE9QUarhFk4XzTgmajl0FSHtmAuO1CeWHFNBakpuAwQMamsC/81UAm9tXqmqPPV2JayJI1REfgA1jaPS0NLdYJE/tyW0gPI2ivCUJ3Ssvoupo1TaZz3gih2NwLnrCDCRwvPVrYTbEnu7kHUhLP0Hne046IQIvCogX8IOIu/93hBVTbEg371QKdueVGSrKq8S6V3Ydlh7iz1PUF1GbRtcxcW43g4i/Rl2O8pPeZfbqafeiE6OZuzPsvzxzgfBSeDGP4E/SF2v36XF/NkBdVUzP4a4Hb2n0b+r2cJIYpH0tX7xUuYFs8fKKY/AE8/cfiap6FcVhR6oY/xNnHKdtbtDfjteAyFWG9JTs7syq+g0tsUWI7cub75TXQ3W4pQACfm1lfLk//RbhGiPzqGgBxLkOnFjEdW7EAIUZvtLZcufTUDsRTvRrNMDE140tIgL19nzehNj5YmrxFscWy+UFFCxffYn+n4LT/bGe9fWjqMJ9QrMCauxp1YwIJN9+ZNqKeb1Z1t8aQSuDElNCimT7TYa3mE2wqIBhx9ZDQyTxmxZJiLr0Z0bDU5v03CBz9ldLmajBE2+QY68scI8lO84C21qVW5h/bUNuuq0sLpvgFYtEj
 KzixEhaW
 Ut5i2eJIbAq352JYZA0U+Xl2tWCLqE8xi+Dmjhs0xm3QUMOWQrjQKX88O/poa5jTiJsgnX3LvFpon4fjgEfX7743y+DMVXD0C9JzXl9hnKm9fReAoxXurGGagSNNtd0yA+iqQ39Eofob8ekx1eevAW1BbZA9FcQIXA8ECBEscOdKNq4GN1acP0WZYhGwTmcL6b8AiJRkC+Bku+NI1hGsibmjKC/x6JTLdp64FqtAb3JKF7GoqtlPhRvxBQvZK16uXcCwcmMfUrCIcIfRTGhsCl1H5mRcCeIKjDGR2Xg6mvYQhDt0BOWfbwQ9RMVtlrQIgcI+UW5z1fX0NQWguwY70aq5kvdjMT0RVBI+HgrofHHZ91ttgTYxKlkm3SiFThmJmVPaFhkJgUIhuFdP50qy69dHFe+X7WXk0HIfyEjgGN7hSDgPfbDPr0XWcuSo9WsHwyitOytW34OkbRZ7o/6+KXudcXR3Yl3OZZxXHwbSwpBZX+oEEyImkMw3CXSEL/Bmy4EOs+b0y2BrR2iNzWY2Q5adwQkbGXc81QAcQhk3+N3negDvlJzRbGbtrARxM5qsBd1GgvzpvD4uN0E1GjSA0r4wg2lVNCNbpm84nWv6u1jTig0AsxChg7M/sGdQ+Biqe6FeiLn2SS3lsQg95lrB6efCRr10ra+hnJBudWxzzqMoVtFb3+Hbq6mT27N6lDbjWHrFkt94l7JjPDbkeGONf7KhCIiO9cfkUxNNWhNwFDkUjfhUxBKtbhpu0pKd488QMQOYxPNCsaPMG/t7fR/Yq/ZZxDSrGyusd7hs/DKSlUhHT+Qg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tqVatPxkL60d1StyO0S0iNcS
Content-Type: multipart/mixed; boundary="------------TQ0K7J2nc88Gt4fgir3x1kEm";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
Message-ID: <9ce0f7cf-7463-48cd-b80f-1fe0cb1ea70d@uniontech.com>
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
 <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
 <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
In-Reply-To: <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>

--------------TQ0K7J2nc88Gt4fgir3x1kEm
Content-Type: multipart/mixed; boundary="------------NJ0Ouas1UcZlNeN45oWbpBos"

--------------NJ0Ouas1UcZlNeN45oWbpBos
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTG9yZW56bywNCg0KU2hvdWxkIEkgc3BsaXQgdGhpcyBpbnRvIHR3byBjb21taXRzPw0K
DQpBcyBWbGFzdGltaWwgQmFia2Egc3VnZ2VzdGVkLCBwZXJoYXBzIGl0IHdvdWxkIGJlIGJl
dHRlciB0byBhZGQgYm90aCB0aGUgDQp8LXN0ZD1nbnUxMXwgYW5kIHwtV25vLXVudXNlZC1w
YXJhbWV0ZXJ8IGZsYWdzIHRvIA0KfHRvb2xzL3Rlc3Rpbmcvc2hhcmVkL3NoYXJlZC5ta3wu
DQoNClRoYW5rcywNCg0KLS0gDQpXYW5nWXVsaQ0K
--------------NJ0Ouas1UcZlNeN45oWbpBos
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

--------------NJ0Ouas1UcZlNeN45oWbpBos--

--------------TQ0K7J2nc88Gt4fgir3x1kEm--

--------------tqVatPxkL60d1StyO0S0iNcS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnoEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaIyIWgUDAAAAAAAKCRDF2h8wRvQL7lPQ
AQDXdQzg8+lpn6zUmbt70QKi1AuoG5+Usxc/NbXtyfPcZwD3Rk0Ti1tWRPUGhMHS/yj+RufLJ2RF
mImA1H6MIilWCw==
=W2yw
-----END PGP SIGNATURE-----

--------------tqVatPxkL60d1StyO0S0iNcS--

