Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0917CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3432F6B0093; Mon, 25 May 2026 05:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A636B0095; Mon, 25 May 2026 05:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230496B0096; Mon, 25 May 2026 05:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 133386B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:10:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96263120205
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:10:47 +0000 (UTC)
X-FDA: 84805372134.19.FA035A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D33A5A0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:10:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsE9I3xg;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779700246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHY4Mju6gSNz8Xq7WxvyvCoWtG1tOj/KYmCDtzG+zrY=;
	b=cvB7gzrTeHa3x+AvNGPTxTkYuPVzYN1f+Ku6aydpO3Epms12Ro07aDeNtIVE7mPDKxLaWg
	KSg+FbuRRPbrv6Whm7sTK+FJkRb9qs+OXRNaEtdxoDYTLzPLIgSIVK/csdZeBUj1QFlG7p
	Qs2jLX35hn18bU9O2MdCf7YcXIWMMng=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsE9I3xg;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779700246; a=rsa-sha256;
	cv=none;
	b=TM7E/70F2RqaKx0H3Nwr3Zopunspk2qSTJMD0oRVxWc3Id2U3RUIiAi8BmuA15b/genC9G
	q0B8FHgtGzYXejDuVxDIEC2XgeHdIYrgbUKMqX4V3jfHm9BJ5cvXD+AKcHnT/DdN9dot+G
	aW/fxV3DCilo6+qr2QYWNbmtDxEt1Jw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCCA34071A;
	Mon, 25 May 2026 09:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235CE1F000E9;
	Mon, 25 May 2026 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779700244;
	bh=oHY4Mju6gSNz8Xq7WxvyvCoWtG1tOj/KYmCDtzG+zrY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jsE9I3xg5NvteR4g9AaTyudbVWZ7M0v7yxb0t5BT//SPqtOFejlK0KIRgWmpxwdpO
	 6SbuVPcMdr2CxaQlf1HiMginxVXXG/tT4imWQ2PoVgJqQ7UyPKpVh5yOJxKogtTktj
	 GybiZtYn574yyxkNQJdhhOawYrwlYjqoIJxaxIRQ68CHdPVYD02qpQ0HxbsslWWuEg
	 +9R4eXKe4wvqPJitQDI6CjKCwYDBOYZkmiuuxlMmNJ4uOneJh5jgWQzlhHczG+ZvRv
	 mqPcH3aumazneBCzHbCuhZ5SIfh9/EcA+uxYDZc6UMnYlrDQvQliTkm65gk4CBb96n
	 ZDpWt9WRVGxAA==
Message-ID: <e1738d98-a063-4bfd-8c98-ad4b449669bd@kernel.org>
Date: Mon, 25 May 2026 18:10:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] MAINTAINERS: add slab-related scripts and tools to
 SLAB ALLOCATOR
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------pfIEG57vyIaxR6akVdPquPFO"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D33A5A0007
X-Rspam-User: 
X-Stat-Signature: 5apk348kntsd1qc83nrbuitc5sepq9zb
X-HE-Tag: 1779700245-667812
X-HE-Meta: U2FsdGVkX1/p9eRIeeC0fhfdCvL/sOyzAV+fMUhZJQqPOAV5prEp6aaYQhrLOdbL+aY4xEXIbnCyqQFWAiPnD3MPZBCW/zcGkD/A2xn/38MDB9CWoFaFaCULJjejpHGEDUB68IWydEoccae7DZ1bBuoldvAUI2xQOUCFpLfGin7kdzP53+gShd4uFxWNCdJNZEe0zYlmlN6BnNvPdeqBjYAfW01HfXIjYnWBfzjVi8TW4PBjxTOgK71zEEBcP2A7roXu/dzOeyoqu+YeLPxmTip4Rcw9ORrZSkNKEyM4ZL6mBB4Et+8FLoWBKL5lRVMMjJ8UeEAyfzSCPXYwRB18+tcEqPEV13ycU29kMJvojYeSvdeoGahGCGZ4D+u9MgxiZ3shJoW3YYkwMztLKlLbVEglQGdQ1grdxqvS2NvlLm/0gBAWlDGtN1s+OX27kPBC39i3DDrnFNRQzfHAMZvK6Uq7Yc96MZ14SwIxpaXwUK+SklNQHa+3STB/TyvZ5GHp9kWHaI0DsUtQzrRLWejDVdEKheIeKQ3uSfo/ELUp9Zz63zHv0EA9S1kvkyol0AMewdQg2A5GydLM33RQv/S1DpmOsJMo9kQr/qNd5Hn8sAg3XN7nxNATPf7N61oSQx7aX4sfoYzDgO61zTkhgZvzz2vtxFv4NPlGqzQpxdoYrjwppfTEZq5EqjJhCPlC3ximfM9iBemUZDYwiAwF6+7CQHpy4th6btgskz3s/WBUCxLcOfSaMzJW98F9Hwk6fPJQ7D0en8U/PmCwt693vkwaIFJCAAjkaxctQ5FEVteAqR2iI+E3tk8eOGTCQfv6i3YrDngb1vrNhJg27uYJL+/ijGu9uohMFbznKXcCXjzxTFvvcNw6E5+ELazIG9an/jMionTUZ2MkO7xazrBFhdj/vyb56zV/YDxQrE1sp0+wSrmqWkMhEB76BMFAjkL40QqsGiBx+yWQIzFkx+sfSHm
 uRC0d562
 mGCaQymOCLsvwof7lih7x5JFyPmyfMvLZdig7iBZszpkFlDMET1XcAtVdswahLvWBaq0sDXevPwwTPRC3ImIjc3Wh8kHKn/rpMQZ5DOeURue+00DVt4Tplv1w26JNntFfVjaWujsfG3p3ehIKm4vfzFQvsiUbrzCnSj35+dVva/AqX3cFDLn6rQVYx+pXYa/ndkXCJoPW3psuBMf1a/WLlQOdsRiHC+r0HnR6w9x8qfIXaQiyBeMfyVsWs6I6fn60/NcZQTU03vHEOeNksOpCmFGM5Oc4WqKCpoA4TXZTVEKUeL6IipwVnpZxVdFyKzcsmSQnqjSwjmcnNh5WZ3ecKsW1IUFXB3U8AXtWZTXMBNRBc+UaJS6zsWdI2IQRceVMCs3qKXABnRCbegY9Ox6lUTdOWU1SY02QRkIGrYfkCRRKUmzOJ/ya2kGl7yLfyVYdjx0mTDn+ZdHTAtS4r4FO3FuAx4Cj0TQ769geS7juGXmUdq9t7Tb+43Itw8xtzmQxhCH2n4NUZdkCDpvdb9yLahdeFBmk8/cfymqko4bTx9z3YDIYsxQztnRU+AbQOooiZZ1SA9Mz4NJHgmcHKo0dbYAWOiNd0MV9xv4IbYQ2gI/7W6exUfECBE4EmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------pfIEG57vyIaxR6akVdPquPFO
Content-Type: multipart/mixed; boundary="------------jbhj9BAySmpyiYoUsW11rp0I";
 protected-headers="v1"; hp="clear"
Message-ID: <e1738d98-a063-4bfd-8c98-ad4b449669bd@kernel.org>
Date: Mon, 25 May 2026 18:10:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab] MAINTAINERS: add slab-related scripts and tools to
 SLAB ALLOCATOR
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>

--------------jbhj9BAySmpyiYoUsW11rp0I
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCk9uIDUvMjUvMjYgNDoyNiBQTSwgVmxhc3RpbWlsIEJhYmthIChTVVNFKSB3cm90ZToN
Cj4gTWFrZSBzdXJlIHRoZSBtYWludGFpbmVycyBhbmQgcmV2aWV3ZXJzIGFyZSBDQydkIG9u
IGNoYW5nZXMgdG8gdGhlDQo+IHNjcmlwdHMgYW5kIHRvb2xzIHRoYXQgZGVwZW5kIG9uIHNs
YWIgaW50ZXJuYWxzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVmxhc3RpbWlsIEJhYmthIChT
VVNFKSA8dmJhYmthQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIE1BSU5UQUlORVJTIHwgNiAr
KysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUw0KPiBpbmRleCAyODg4NjZjMzJh
ZGUuLjllZTA2Y2QzNTc5MyAxMDA2NDQNCj4gLS0tIGEvTUFJTlRBSU5FUlMNCj4gKysrIGIv
TUFJTlRBSU5FUlMNCj4gQEAgLTI0NTU1LDYgKzI0NTU1LDEyIEBAIEY6CW1tL21lbXBvb2wu
Yw0KPiAgIEY6CW1tL3NsYWIuaA0KPiAgIEY6CW1tL3NsYWJfY29tbW9uLmMNCj4gICBGOglt
bS9zbHViLmMNCj4gK0Y6CXNjcmlwdHMvZ2RiL2xpbnV4L3NsYWIucHkNCj4gK0Y6CXRvb2xz
L2Nncm91cC9tZW1jZ19zbGFiaW5mby5weQ0KPiArRjoJdG9vbHMvaW5jbHVkZS9saW51eC9z
bGFiLmgNCj4gK0Y6CXRvb2xzL2xpYi9zbGFiLmMNCj4gK0Y6CXRvb2xzL21tL3NsYWJpbmZv
LWdudXBsb3Quc2gNCj4gK0Y6CXRvb2xzL21tL3NsYWJpbmZvLmMNCj4gICANCj4gICBTTENB
TiBDQU4gTkVUV09SSyBEUklWRVINCj4gICBNOglEYXJpbyBCaW5hY2NoaSA8ZGFyaW8uYmlu
YWNjaGlAYW1hcnVsYXNvbHV0aW9ucy5jb20+DQo+IA0KPiAtLS0NCkFja2VkLWJ5OiBIYXJy
eSBZb28gKE9yYWNsZSkgPGhhcnJ5QGtlcm5lbC5vcmc+DQoNCi0tIA0KQ2hlZXJzLA0KSGFy
cnkgLyBIeWVvbmdnb24NCg0K

--------------jbhj9BAySmpyiYoUsW11rp0I--

--------------pfIEG57vyIaxR6akVdPquPFO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEARYKADkWIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahQSDBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwwLDMACgkQhlwTeq3OUta2iAEAn9j8AFeKwS7/g2VyK51t
M8LJmzaDphWTflpI4SzoR3sBALgl1Mba0axhpTeaBBI9nt9ZwLXfbpQpOD5ZTr34
LnkO
=VPDt
-----END PGP SIGNATURE-----

--------------pfIEG57vyIaxR6akVdPquPFO--

