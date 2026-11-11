Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37056606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uu.se header.i=@uu.se header.a=rsa-sha256 header.s=centralsmtp2 header.b=X0fzAzJB;
	dkim=temperror header.d=it.uu.se header.i=@it.uu.se header.a=rsa-sha256 header.s=halon header.b=Qq5BqxLJ
Received: by kanga.kvack.org (Postfix)
	id 5B43F6B05BB; Wed, 11 Nov 2026 02:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5641E6B05BC; Wed, 11 Nov 2026 02:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454976B05BD; Wed, 11 Nov 2026 02:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 136426B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:44:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B23CDA75E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:44:03 +0000 (UTC)
X-FDA: 85422049566.25.140911A
Received: from smtp-out2.uu.se (smtp-out2.uu.se [130.238.7.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id E3AF51C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:44:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=uu.se header.s=centralsmtp2 header.b=X0fzAzJB;
	dkim=pass header.d=it.uu.se header.s=halon header.b=Qq5BqxLJ;
	spf=pass (imf21.hostedemail.com: domain of alireza.haddadi@it.uu.se designates 130.238.7.173 as permitted sender) smtp.mailfrom=alireza.haddadi@it.uu.se;
	dmarc=pass (policy=none) header.from=uu.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAdLzm0lC6RteZTIgPAPr9QVhABezDfRESoAcyYKOqc=;
	b=CmfFbyfe4/GHKMr0t51wWd8Kd5YU+xME/Azikq6WjlZ4QfoAnWBmL9+vvSAGiTPtyWE7i6
	TZxtwGBB6Ir3xev751g7xSWotJgm57bW1P2oF63tnkn3egY/Xx+4wmyzeFA5NnlwL4/XeE
	Bupn5q5VdMNIcHwfs+2u0pPbbvr2hXc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=uu.se header.s=centralsmtp2 header.b=X0fzAzJB;
	dkim=pass header.d=it.uu.se header.s=halon header.b=Qq5BqxLJ;
	spf=pass (imf21.hostedemail.com: domain of alireza.haddadi@it.uu.se designates 130.238.7.173 as permitted sender) smtp.mailfrom=alireza.haddadi@it.uu.se;
	dmarc=pass (policy=none) header.from=uu.se
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383041;
	b=zlLHM4axUYy1tC54c/9/LaC8sKrcq1WbFqc+xt6PmdHaJClabOjsePl3TghSucFdXWFMig
	c2+ov/Azazr8S55elzNn+RYxygsIVcKZWD3EJJMFfqs/ix0gaGP7Q161pOaqk7R4Wwt0Zs
	zyCEdcQ6/epiDy290vdiFtEv0nSL0lc=
Received: from mailfilter-ng-3.sunet.se (mailfilter-ng-3.sunet.se [192.36.171.200])
	by cursor.its.uu.se (Postfix) with ESMTP id 293DD680354
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:43:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uu.se;
	s=centralsmtp2; t=1794383038;
	bh=lAdLzm0lC6RteZTIgPAPr9QVhABezDfRESoAcyYKOqc=;
	h=From:To:CC:Subject:Date:References:In-Reply-To;
	b=X0fzAzJBxqmCcUWUW107VD4jNm2DEjgqwA/gfIoTMmfIb0Ig9bP4C65WSTohrXzRZ
	 GrdJPf5Bkh0ojEp18Nf8ytBBpx4hCNrisLz+Hx8v/BxIJvD/TyXHksHCY79GYA15fU
	 34nhygh0wRqDzx2SQcry5O2a4QHK34qgzoSYNhHz8zzwtCfo6kQrtaHy5f/PX/BQGK
	 AUE/qcr7thBH0JIfkT/MUZzCLEpVi1qnvLCiLASjdmEKMotjLrQObTz2Rjrv4FVDaQ
	 iKQW9FmFMenowBFQU0rAr6nHR+T6Oi0ZjnVYkILNuf8R0CYcnLhe/KGcFeyeEOCrm2
	 eKo+tyM53aQzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=it.uu.se; s=halon;
	h=mime-version:content-transfer-encoding:content-id:content-type:in-reply-to:
	 references:message-id:date:subject:cc:to:from:from;
	bh=lAdLzm0lC6RteZTIgPAPr9QVhABezDfRESoAcyYKOqc=;
	b=Qq5BqxLJ4oAo00iMNlrHTOpc9HvjRubpjClAEe5L3t+l2IozLY455YfG9pN9eHB5WO2RSNeUZ927l
	 ODci0EOU9b3Nd/DbKkSRhAhErAihDZxMg3Lhq+AdjG0MU9Hbp8r7I0GBYk9LeAdTOWIYuImLeLcluL
	 37j/LfZd1I8HaOXVQIXN1N2Xjj9LpFOrIMzJRcXHz226+VHP2fvZMJJ5IKwdMZ2jJMTlwYMsCyPkRi
	 re0nJPjknrXj5GpwEWyfSZiCQLgosSuMOsD3V510XmS06H++eryZDC4QyhuL24WRYi5N7F0jYgXVGa
	 0oxoLONhHEkhuwGJvT5DjsLbvZU4CIg==
X-Halon-ID: a67b696e-dda3-11f1-95df-0050569a1168
Received: from lyra.its.uu.se (lyra.its.uu.se [130.238.7.73])
	by mailfilter-ng-3.sunet.se (Halon) with ESMTPS
	id a67b696e-dda3-11f1-95df-0050569a1168;
	Wed, 11 Nov 2026 07:43:56 +0000 (UTC)
Received: from smtp.user.uu.se (uuc-epost016.user.uu.se [130.238.3.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lyra.its.uu.se (Postfix) with ESMTPS id B1301600088;
	Wed, 11 Nov 2026 08:43:54 +0100 (CET)
Received: from UUC-EPOST014.user.uu.se (130.238.3.24) by
 UUC-EPOST016.user.uu.se (130.238.3.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 08:43:54 +0100
Received: from UUC-EPOST014.user.uu.se ([130.238.3.24]) by
 UUC-EPOST014.user.uu.se ([130.238.3.24]) with mapi id 15.02.2562.056; Wed, 11
 Nov 2026 08:43:54 +0100
From: Alireza Haddadi <alireza.haddadi@it.uu.se>
To: Gopal Malaviya <gopalmalaviya53@gmail.com>
CC: "jack@suse.cz" <jack@suse.cz>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "vishal.moola@gmail.com"
	<vishal.moola@gmail.com>, "fujunjie1@qq.com" <fujunjie1@qq.com>,
	"roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "tracekotae@gmail.com" <tracekotae@gmail.com>
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Thread-Topic: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Thread-Index: AQHdcFXobp3vto+/eEuuawUN31FcZrcoN0gAgAA4CQA=
Date: Wed, 11 Nov 2026 07:43:54 +0000
Message-ID: <26E03EC6-F37C-4350-B2A9-1F354217F469@it.uu.se>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
 <20261111042310.191979-1-gopalmalaviya53@gmail.com>
In-Reply-To: <20261111042310.191979-1-gopalmalaviya53@gmail.com>
Accept-Language: en-GB, sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-uu-exchange-origin: Internal
Content-Type: text/plain; charset="utf-8"
Content-ID: <00E735D1736E5D4697FA838A52C10B56@user.uu.se>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: bc1ifugznqwrq3me85nx87pjggqraqez
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3AF51C0005
X-HE-Tag: 1794383040-976974
X-HE-Meta: U2FsdGVkX18YT/xvlEuIu/gSg9ZFxX5lJcP6z/gd0FMVvDuBkaq6UWkWGQPa4hGx7AvF/teHnEQVwmU5enozDVSP0QdQdyY/iopg15G1FvE0E96C0vxRtELNSpAiOdvs3y9+alq7EtvM0Apcrvmk2VtRYa0HWLs+NKBZkfEBEUWlXvctWj+LLGg2Zm3HK96tQHyRA54l7lxmmt5Lv0VCm9WhOaFRl+JidNO0d07MdqWrYD+ASLa+LAEnlE/sCEHZ5jTb98jUk1clVIXRlaLv2D2j2IUmSA3mLjj3+3XOs6E8XwbajhzdTPJv3ECR2XqMcvLVFu2hsNLwH+KBKBgkEyVd9RHnSqpbnDiVE30K4CROBEs4Dv0o/Kv9pjpaKc9HUE09uBrqn+l5hE8hGtRqeJ7chPBF6DOY5yiO4G6CMTF1fkgvBDPsdOkpfo6aUDHzh1mwBO3U/FfOQxKjNw4v9AH6/ddHTH6BmVLzP1U1lYf/J2XdjvRmjdSAB56TFx45LA3MNd6b8gxHEKVwGekTMIVF5qFblDtpGhNYaU6Aro8I3hrdzRWX3f04aYRUT4joZg0ZidH0+lNEexlmF2Q+DBXFSeKf3anupwNWurVzAQLyjkddpGACn/nvA/pZAsxsWCXYfrEu1zX8yWYpmtTmydgchRafeKk5xO83DRHWzfBdXIfpZNLYa5IIkuXF9wd5rarWTGB39AR8asqp0lfnSdfDiVhEiJY2Fu9YP07dPt2udqiykOsqDc2PsaOLBzYOZC4zbFmyb93Es4X5A7gTNISigczL7kOgBG9J5ZiUl4Fq51hQoxAzPB0sKxv+JIh7Ebcs+CNkgEW7KqPL7/hBuo71YgD7xFwJ37JXhN05nwYUBvZULPg2YolEe5vIoXmiwmOjS7xwHw9YxhBASnkvra2aL0eEtGt1aU5OKJ65HSdzKwN2125mLcC9xSZ5Drk7Y7nr5Urw8E3J8ElJx9U
 5oUEFJH9
 zlvqKgSw9DchWFj5sl3f+RbJniIjo+52aYWGwITf7laFxGH983Er5qiJGjGa1bcfeWneoncgwMcBBat5EO3HpZrq9uzVzAwPSapprqgmNTjvQwa+zuuwDT95ht0CZPFHvNni3MWgJKwtMPQc85HccahR5Yd7ZCIG5ko4RT6RZOsWyALiZMZeXXIL/0GW+g9C3vwuAQdt/JmpfvKRoEO6QXoT/OBSqWKLvLCSTuuM2N0hBLSEY3cxsnhtIVDMNSDB7AWuJMWQKi6nMgJiIRC+lUJp/+T2GwW5jb71UP5yw+4a6aVj5fYFBgl49kuqlhqgVEG9R5AGA4U/xtyIuaMxLEznAX3fd3xXdjxiyIWh97MNnLWqAF6h7ZZae2iNKEoTKAO5A9ysKksMmuL/YD2YHBSfP/njzhVs+u7YBwA9ny8OTrZqk4T+yRzkXReaZDIkm2qcc4H9jN3K+QLAbARVtWYvK/kIBVnuuSnjJuuWD4I1sB2VLiexRVlvohXoZbubuNIEd2syEwZh9dmrsnJ2evSSpCDPC8IDGa6pg0nqKYV/zzqEnfP2mWi66lcz2KDJx65mkp1q1D2/4vV3FwrLl4AZgV1gcThDm4dOcEhdKyh5n/nFl5Iz/9IrUl08zxu2rvXe9BdMQdiW5aMpLswCB6QGrtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DQoNCj4gT24gMTEgTm92IDIwMjYsIGF0IDA1OjIzLCBHb3BhbCBNYWxhdml5YSA8Z29wYWxtYWxh
dml5YTUzQGdtYWlsLmNvbT4gd3JvdGU6DQo+DQpIaSBHb3BhbCwNCg0KVGhhbmtzIGZvciB0ZXN0
aW5nIHRoaXMgc28gdGhvcm91Z2hseSwNCmFuZCBmb3IgcG9pbnRpbmcgbWUgdG8gVHJhY2XigJlz
IHJlcG9ydC4NCg0KPiBIaSBBbGlyZXphLA0KPg0KPiBJIGhhZCBzZW50IGEgZGlmZmVyZW50IGZp
eCBmb3IgdGhlIHNhbWUgcmVncmVzc2lvbiBbMV0sIHJlcG9ydGVkIGJ5DQo+IFRyYWNlIGluIFsy
XS4gSmFuIHByZWZlcnMgeW91cnMsIHNvIEkgaGF2ZSBkcm9wcGVkIG1pbmUuIEkgcmFuIHlvdXIN
Cj4gcGF0Y2gsIGFsc28gd2l0aCB0aGUgdjIgY2hhbmdlIHlvdSBkZXNjcmliZSB0byBKYW4sIHRo
cm91Z2ggdGhlIHRlc3RzDQo+IEkgaGFkOiBhIEtWTSBndWVzdCAoeDg2XzY0LCAyIHZDUFVzLCAz
IEdpQiksIG1tLWhvdGZpeGVzLXVuc3RhYmxlIGFzDQo+IG9mIDIwMjYtMTEtMDgsIGV4dDQgYW5k
IFhGUyB3aXRoIDE2IEtpQiBibG9ja3Mgb24gdmlydGlvLWJsaywNCj4gcmVhZF9haGVhZF9rYiAx
MjggdW5sZXNzIG5vdGVkLg0KPg0KPiBUaGUgcmVwcm9kdWNlciBmcm9tIFsyXSAoMjAwMCBzaW5n
bGUtcGFnZSBmYXVsdHMgMSBNaUIgYXBhcnQsIHRoZW4gYQ0KPiA2NCBNaUIgc2VxdWVudGlhbCBy
ZWFkKSwgbWFqb3IgZmF1bHRzIGluIHRoZSBzZXF1ZW50aWFsIHBhcnQ6DQo+DQo+ICAgICAgICAg
ICAgICAgICAgICAgICBiYXNlICAgYXMgcG9zdGVkICAgd2l0aCB2MiBjaGFuZ2UNCj4gIGV4dDQg
ICAgICAgICAgICAgICAgMTYzODQgICAgICAgICAgIDIgICAgICAgICAgICAgICAgMg0KPiAgWEZT
LCAxNiBLaUIgYmxvY2tzICAgNDA5NiAgICAgICAgNDA5NiAgICAgICAgICAgICAgICAyDQo+DQpU
aGF0IG1hdGNoZXMgd2hhdCBJIHNlZSBoZXJlOiBvbiBtbS1uZXcgd2l0aG91dCB0aGUgcGF0Y2gs
IFhGUyB3aXRoDQoxNmsgYmxvY2tzIHRha2Ugb25lIGZhdWx0IHBlciAxNiBLaUIgZm9saW8gaW4g
dGhlIGluLW9yZGVyIHJlYWQuDQo+IFRvdWNoaW5nIDElIG9mIHRoZSBwYWdlcyBvZiBhIGNvbGQg
MjAgR2lCIGZpbGUsIGxhcmdlciB0aGFuIG1lbW9yeSwgaW4NCj4gcmFuZG9tIHJ1bnMgb2YgMSwg
MiBvciA0IGFkamFjZW50IHBhZ2VzLCBNaUIgcmVhZCBmcm9tIGRpc2sgd2l0aCB0aGUNCj4gdjIg
Y2hhbmdlIChmaXJzdCBvZiB0d28gcnVuczsgdGhlIHNlY29uZCB3YXMgd2l0aGluIDEwJSk6DQo+
DQo+ICAgICAgICAgICAgICAgICAgICAgICByZWFkX2FoZWFkX2tiIDEyOCAgICAgcmVhZF9haGVh
ZF9rYiA4MTkyDQo+ICAgICAgICAgICAgICAgICAgICAgICAgYmFzZSAgIHdpdGggdjIgICAgICAg
IGJhc2UgICB3aXRoIHYyDQo+ICByYW5kb20gNC1wYWdlIHJ1bnMgICAgIDI0MCAgICAgIDExNDYg
ICAgICAgIDEyMDAgICAgIDU3NzQ4DQo+DQoNCj4gVGhlIDQtcGFnZSBydW5zIGF0IHJlYWRfYWhl
YWRfa2IgODE5Miwgd2hpY2ggaXMgd2hhdCB0aGlzIGd1ZXN0J3MNCj4gdmlydGlvLWJsayBkaXNr
IGdldHMgYnkgZGVmYXVsdCwgcmVhZCBhYm91dCA0OCB0aW1lcyBtb3JlLiBBcyBmYXIgYXMgSQ0K
PiBjYW4gdGVsbCwgZWFjaCBydW4gbm93IGhhcyB0d28gbWlzc2VzIGFuZCB1cCB0byB0d28gaGl0
cyBvbiB0aGUgbmV3DQo+IHdpbmRvdywgc28gbW1hcF9taXNzIHN0YXlzIGFyb3VuZCBNTUFQX0xP
VFNBTUlTUywgYW5kIGVhY2ggdGltZSBpdCBpcw0KPiBiYWNrIGF0IHRoZSBsaW1pdCB0aGUgbmV4
dCByYW5kb20gbWlzcyBnZXRzIHRoZSBmdWxsIDggTWlCDQo+IHJlYWQtYXJvdW5kLiBNeSBwYXRj
aCByYW4gaW50byB0aGUgc2FtZSBhbmQga2VwdCBtbWFwX21pc3MgYXQgaXRzIGNhcA0KPiBvbiB0
aGF0IHBhdGg7IHNvbWV0aGluZyBsaWtlIHRoYXQgbWF5IGhlbHAgaGVyZSwgYnV0IHlvdSBhbmQg
SmFuIGtub3cNCj4gdGhpcyBiZXR0ZXIuDQoNClRoaXMgaXMgYSByZWFsIHByb2JsZW0sIHRoYW5r
cyBmb3IgY2F0Y2hpbmcgaXQuIE5vbmUgb2YgbXkgdGVzdHMgaGFkDQpzaG9ydCBzZXF1ZW50aWFs
IHJ1bnMgYXQgcmFuZG9tIHBsYWNlcywgc28gSSBtaXNzZWQgaXQuIEnigJlsbCByZXByb2R1Y2UN
Cml0IGhlcmUgYW5kIHJld29yayB0aGUgcGF0Y2ggYmVmb3JlIHNlbmRpbmcgdjIuIEkgd2FudCB0
byBjb21wYXJlDQprZWVwaW5nIG1tYXBfbWlzcyBoaWdoIG9uIHRoYXQgcGF0aCwgYXMgeW91IGRp
ZCwgd2l0aCBvbmx5IHJlc3RhcnRpbmcNCnJlYWRhaGVhZCBvbmNlIHRoZSBmYXVsdCBjb250aW51
ZXMgYSBsb25nZXIgcnVuIG9mIGNhY2hlZCBwYWdlcy4NCg0KSmFuIHRoYW5rcyBmb3IgYmVpbmcg
T0sgd2l0aCB0aGUgbWluLW9yZGVyIGNoYW5nZS4gR2l2ZW4gdGhpcywgdjINCndpbGwgY2hhbmdl
IG1vcmUgdGhhbiwgc28gSSB3b27igJl0IGNhcnJ5IHlvdXIgUmV2aWV3ZWQtYnkgb3Zlci4NCkni
gJlkIGJlIGdsYWQgaWYgeW91IGNvdWxkIHRha2UgYW5vdGhlciBsb29rIGF0IHYyLg0KPg0KPiBP
biB0aGUgRml4ZXMgdGFnOiB3aXRoIHRoZSBjb21taXRzIG9mIHRoZSBzZXJpZXMgYnVpbHQgb25l
IGJ5IG9uZSwNCj4gY29tbWl0IDBiOWMwYWViYTkzOCAoIm1tL2ZpbGVtYXA6IGNvdW50IG9ubHkg
dGhlIGZhdWx0aW5nIGFkZHJlc3MgYXMNCj4gYSBtbWFwIGhpdCIpIGFsb25lIGRvZXMgbm90IHNo
b3cgdGhlIHByb2JsZW0gKDEgbWFqb3IgZmF1bHQgd2l0aCB0aGUNCj4gcmVwcm9kdWNlciksIGFu
ZCBjb21taXQgOWIwZmNhYzNjZmU3ICgibW0vZmlsZW1hcDogZG8gbm90IGNvdW50DQo+IEZBVUxU
X0ZMQUdfVFJJRUQgcmV0cmllcyBhcyBtbWFwIGhpdHMiKSBkb2VzICgxNjM4NCkuIFsyXSBpcyB0
aGUgc2FtZQ0KPiByZWdyZXNzaW9uLCBpbiBjYXNlIHlvdSB3YW50IHRvIGFkZCBSZXBvcnRlZC1i
eSBhbmQgQ2xvc2VzIHRhZ3MgZm9yDQo+IHJlZ3pib3QuDQo+DQpJIG9ubHkgdGVzdGVkIHJldmVy
dGluZyBib3RoIGNvbW1pdHMgdG9nZXRoZXIsIHNvIEnigJlsbCBjaGVjayB0aGlzIGFuZCBmaXgg
dGhlDQp0YWcgaW4gdjIsIGFuZCBhZGQgUmVwb3J0ZWQtYnkgYW5kIENsb3NlcyBmb3IgVHJhY2Xi
gJlzIHJlcG9ydC4NCg0KPiBJIGFtIGhhcHB5IHRvIHJ1biB0aGVzZSBhZ2FpbiBvbiB5b3VyIHYy
LiBUaGUgdGVzdHMgd2VyZSBzZXQgdXAgd2l0aA0KPiB0aGUgaGVscCBvZiBhbiBBSSBhc3Npc3Rh
bnQuDQoNClRoYXQgd291bGQgYmUgZ3JlYXQsIHRoYW5rIHlvdS4gQ291bGQgeW91IHNoYXJlIHRo
ZSBzaG9ydC1ydW4gdGVzdCwNClNvIEkgY2FuIHJ1biB0aGUgc2FtZSBoZXJlIHdoaWxlIHdvcmtp
bmcgb24gaXQ/DQoNCkJlc3QgUmVnYXJkcywNCkFsaXJlemENCg0KDQoNCg0KDQoNCg0KDQoNCk7D
pHIgZHUgaGFyIGtvbnRha3QgbWVkIG9zcyBww6UgVXBwc2FsYSB1bml2ZXJzaXRldCBtZWQgZS1w
b3N0IHPDpSBpbm5lYsOkciBkZXQgYXR0IHZpIGJlaGFuZGxhciBkaW5hIHBlcnNvbnVwcGdpZnRl
ci4gRsO2ciBhdHQgbMOkc2EgbWVyIG9tIGh1ciB2aSBnw7ZyIGRldCBrYW4gZHUgbMOkc2EgaMOk
cjogaHR0cDovL3d3dy51dS5zZS9vbS11dS9kYXRhc2t5ZGQtcGVyc29udXBwZ2lmdGVyLw0KDQpF
LW1haWxpbmcgVXBwc2FsYSBVbml2ZXJzaXR5IG1lYW5zIHRoYXQgd2Ugd2lsbCBwcm9jZXNzIHlv
dXIgcGVyc29uYWwgZGF0YS4gRm9yIG1vcmUgaW5mb3JtYXRpb24gb24gaG93IHRoaXMgaXMgcGVy
Zm9ybWVkLCBwbGVhc2UgcmVhZCBoZXJlOiBodHRwOi8vd3d3LnV1LnNlL2VuL2Fib3V0LXV1L2Rh
dGEtcHJvdGVjdGlvbi1wb2xpY3kNCg==

