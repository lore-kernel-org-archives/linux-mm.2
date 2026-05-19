Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACA1CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BDA6B0005; Mon, 18 May 2026 21:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E936B0088; Mon, 18 May 2026 21:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1332B6B008C; Mon, 18 May 2026 21:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F33986B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:54:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C325160265
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:54:56 +0000 (UTC)
X-FDA: 84782500992.22.E2EF014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDA7040009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:54:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ctBNp6J/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779155695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdya2dLwhM2WAohEjUCFEIR8O1Ubl2lr0zLyIZ7mE4U=;
	b=2sahIaqESwsf8sLATx/qGG2V/BppDqJBsDiaCzuNfHNuuoNqwNGiev3eLolfztqMxSKNwp
	pD2v5yLzMADUYFpCdEEpy0mNeHpfZrCBvCctrapSzLgC+5YDJ8Ssn9VUSeyQW/6XfzTgjP
	0vZ2vpwjW4DHU8QBAQtUn1EaCzw5sHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ctBNp6J/";
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779155695; a=rsa-sha256;
	cv=none;
	b=pbhilOSD/N3i4geztAIRdkudatkH37gsXPu2WXrn74WOpOykq0DU6ksXw7XXmdE5Naw580
	FTCcmrWqNmE+g2an+iK9D36naAHJOOcSvbPc6Jz9lZ9Dj1w2YhvLHeWhJ8tRwJ9fWlIz7o
	Yrcql6nYLSKiX88I6UC8teTWyuMHPy0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E25704401F;
	Tue, 19 May 2026 01:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC57C2BCB7;
	Tue, 19 May 2026 01:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779155693;
	bh=qdya2dLwhM2WAohEjUCFEIR8O1Ubl2lr0zLyIZ7mE4U=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ctBNp6J/rYDWV5x71fHPPzmDRRdDA7dNH1rC8ypmnLlmLvbUgfjZ0VF7Zw93vQRSJ
	 Ug9HgsZVYQjXmRRFEWl2wiJvj0G4N7QeCDZI+S5H3+kA5t+TLR3ZeNybrzs83m/7lG
	 nxhEha0Q8bVTQ4+BpXSLeof9UGoYdUpG2x3gqH4UtXevAXeDRdMal2XiBuFnGguTYL
	 Hvxazy5qQPzBPdU+nndQcNhFbNhRUMCxQUQqHc/2FxkiJX1TT5m3XIjyB2VtnCuXFx
	 BNF6i9NqIsQiaF3uQgMEUsGENajHByve3Jz0YaDGSNvibxK9rjQiLFQcNssAX44iHc
	 jqBI8WGmbLU7Q==
Message-ID: <f3ea1493-3447-4510-b33b-4b27c148b657@kernel.org>
Date: Tue, 19 May 2026 10:54:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
From: Harry Yoo <harry@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
 <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>
Content-Language: en-US
In-Reply-To: <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------DZW1iybG3d9lAfW2Dg8Q1r8m"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDA7040009
X-Stat-Signature: e9mnexque776kkfz56jmf81mxspqbcqn
X-HE-Tag: 1779155694-901887
X-HE-Meta: U2FsdGVkX188zh3kI4/zHGHp0vxKCLK7EbibnoKt4w3GiPis5S588cBC4TAqBKS8MPH48NHaIfsjCIAcR5OvvSN8uWmQG16sXsS1parI1gKM0MbM1kgBUqyDhpIuEGSfCJPf0y+pYUPX/+7T2Pdazxw2tQgqA2MQVOAHp4DoNRGslBX5okllYfwux1h9HDf5rKSJW8dLSH9DCTJgkO/kahwMWkDtcs3dLoKcqAi32hO7lVnaq47+3X9tolr8dISNxVmGoUejODGg0NCHRIFD6ROMHbV56IsXMB9hLk65M7NP4a1httjMbZt60//VnTf8l1x1sFXAgOn+AZB7m7tnbgnVXdu2kaInSKP2AsuvC9ZLkkyQPDDmx3YHcQfaKCbtBKCx5ZJ1C3fpXvvwmhccPxSD/ZRNrO7/ytTYbRkYsiaggIwlVby9PgHw1rlydHrMTO5CgRkYrYhSsdKe1V6vI56l4zB4Es/Z2oeAt7skH3h8ORsoKcVCJggdPEwEcvNzwFcAoYrEVuW1SeAQqK0JHkDEhM4+bLqpJ6dldXJdtrO2b8Zu3d+YNT3euqKWF6Wk1VddHtiXjzhjD+57ORFM8FgcwV0Wo5lvcSqtQrtgzXXZ6aF0zOCFf3+fOAM1HJaZ67fBngwvKY0SLz5ZqL7xSzt9bS8H23YSkpfxKmnX7BSA5S++pclq1uCdjb6ZAhxtTwZuuGZwxO/QBeC8Vx6rh85uGeSIt4tz1osKfeyvHFoPf+Dw59R8PEvLUwCWq7g2KyIU88WnEc1EiCQY7UX+RXQjRcgCdab0Q0d7PYrI4l6nPOcy+v9hJpLlWKCepr+kHyOwKXTXgKCD3e6fc6FTLbEEOC68eWQOhfn1XlaHEhmR+/hxhtiWjBN8Zfi7xg3GWRVT6hIha00GLJc9sIROHTIkfV2B43oX57K4D5CFQkm6TKDI6lHApoO7C24E45Y6xIAs+GOjKnDGEvu9hxg
 w2YFCD7N
 0B66j25Qwob+QrZADYr5dXo4py1U6P3Lweh464ZJJ8IXmRxG9LYFsCKmavE+QP21rl4O89du9YMG0sbixGTv/0l9r3fit01Q/h5k9+9P3vBKsDqFVCGIAj0Q+gOIX/Us4EU2y82LmpPBzE6PxjVpG3u2ejKG7zM1xKuR5YUygCRWAd1p8CpHEV5u76fjIaTFV+wtH3X6jw5StKO5k/8nXNKAsuOfCMfHtmB2ROVeZkGKalf745e8wD98PAXO3T1D1bDeDZbBJJ6kqzsr7Xs+ef4UM/M9dSVOYHJEd1UoEm4LxEdzVPwDfPVzzTiO81MycJzBSF1Md42CCNr/PsPghVuFLhI7h9QPy9CobsW35A9P3MuP9i7VSgz+w9y8pYaAzGXiuQ+U4jlBsclH0c56nZDHPHmIjZAdo7qCT4MqoZ/zlAMOEGxW6jB96O2iiuG2bRnUHqMSc9XAx/+Yx+y+ZJAv6GDU88XJE/T10zvAX9/HLJhwC1T8EWIV2hu7xvxyW8PsQ2nppTlUb1DUJV3oLXzLHM4O02JwmOnbxLhlnnjho4VYDvTx1L4iIpaCJ3uwN4kGXOwrrw/EMSxS0s5CWIHDPm3YRVT5r6AVQcKlDqFEZwIHqxigZdJ8g4uuHWJIxI4k9kexPiRp06Qj8er1CUnLHIRs9FklTGgJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------DZW1iybG3d9lAfW2Dg8Q1r8m
Content-Type: multipart/mixed; boundary="------------WofN1prgKtAIDDBNNfPXSXIf";
 protected-headers="v1"; hp="clear"
Message-ID: <f3ea1493-3447-4510-b33b-4b27c148b657@kernel.org>
Date: Tue, 19 May 2026 10:54:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
From: Harry Yoo <harry@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
 <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>
Content-Language: en-US
In-Reply-To: <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>

--------------WofN1prgKtAIDDBNNfPXSXIf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCk9uIDUvMTcvMjYgOTo0OSBQTSwgSGFycnkgWW9vIHdyb3RlOg0KPiANCj4gT24gNS8x
NS8yNiA2OjE5IFBNLCBaaGVuIE5pIHdyb3RlOg0KPj4gVGhpcyBwYXRjaCBzZXJpZXMgaW50
cm9kdWNlcyBwZXItZmlsZS1kZXNjcmlwdG9yIGZpbHRlcmluZyBjYXBhYmlsaXRpZXMgdG8g
dGhlDQo+PiBwYWdlX293bmVyIGZlYXR1cmUuDQo+Pg0KPj4NCj4+IFByb2JsZW0gU3RhdGVt
ZW50DQo+PiA9PT09PT09PT09PT09PT09PQ0KPj4NCj4+IEluIHByb2R1Y3Rpb24gZW52aXJv
bm1lbnRzIHdpdGggbGFyZ2UgbWVtb3J5IGNvbmZpZ3VyYXRpb25zIChlLmcuLCAyNTBHQisp
LA0KPj4gY29sbGVjdGluZyBwYWdlX293bmVyIGluZm9ybWF0aW9uIG9mdGVuIHJlc3VsdHMg
aW4gZmlsZXMgcmFuZ2luZyBmcm9tDQo+PiBzZXZlcmFsIGdpZ2FieXRlcyB0byBvdmVyIDEw
R0IuIFRoaXMgY3JlYXRlcyBzaWduaWZpY2FudCBjaGFsbGVuZ2VzOg0KPiANCj4gDQo+IEp1
c3Qgb3V0IG9mIGN1cmlvc2l0eS4uLg0KPiANCj4gV2hhdCBhcmUgeW91IHRyeWluZyB0byBk
byB3aXRoIHRoaXMgZGF0YSBvbiBwcm9kdWN0aW9uIHNlcnZlcnMsYW5kIHdoeSANCj4gdGhl
IGV4aXN0aW5nDQo+IA0KPiBwZXItTlVNQSBzdGF0aXN0aWNzIGRvbid0IHdvcmsgZm9yIHlv
dT8NCg0KSWYgd2hhdCB5b3Ugd2FudCB0byBkbyBpcyBkdW1wIHdoaWNoIGNvZGUgbG9jYXRp
b25zIGFsbG9jYXRlZCBob3cgbXVjaCANCm1lbW9yeSBmb3IgZWFjaCBOVU1BIG5vZGUgb24g
dGhlIGV2ZW50IG9mIE9PTSwgeW91IHByb2JhYmx5IHdhbnQgdG8gDQppbXByb3ZlIG1lbW9y
eSBhbGxvY2F0aW9uIHByb2ZpbGluZyBpbnN0ZWFkIG9mIGltcHJvdmluZyBwYWdlX293bmVy
IA0KZnVuY3Rpb25hbGl0eS4NCg0KSUlSQyB0aGVyZSB3YXMgZGlzY3Vzc2lvbiBbMV0gb24g
c3VwcG9ydGluZyBtZW1jZyBhbmQgbnVtYSBhd2FyZW5lc3MNCmFuZCBxdWVyeWluZyB1c2lu
ZyBpb2N0bCgpLg0KDQpbMV0gTWVtb3J5IEFsbG9jYXRpb24gUHJvZmlsaW5nIHVwY29taW5n
IGZlYXR1cmVzLCBMUEMgMjAyNSwNCiAgICAgaHR0cHM6Ly9scGMuZXZlbnRzL2V2ZW50LzE5
L2NvbnRyaWJ1dGlvbnMvMjE0Ng0KDQotLSANCkNoZWVycywNCkhhcnJ5IC8gSHllb25nZ29u
DQoNCg==

--------------WofN1prgKtAIDDBNNfPXSXIf--

--------------DZW1iybG3d9lAfW2Dg8Q1r8m
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEARYKADkWIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCagvC5BsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwwLDMACgkQhlwTeq3OUtbPgwD+OeZXcjnMgSFixBEC6ZPv
17ZTYfJ49hFfkS0hDJNr5LcBAMobyZPtxh9IB/rSX4vRzDzOeEM3xVgZgZeGEL4t
QWMP
=MK6M
-----END PGP SIGNATURE-----

--------------DZW1iybG3d9lAfW2Dg8Q1r8m--

