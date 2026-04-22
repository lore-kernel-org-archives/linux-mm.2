Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA353F94CBA
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC4A6B0005; Tue, 21 Apr 2026 20:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D5F6B0088; Tue, 21 Apr 2026 20:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5EC6B0089; Tue, 21 Apr 2026 20:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE30E6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:34:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8899416146D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:34:14 +0000 (UTC)
X-FDA: 84684320028.05.0E48B0D
Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by imf19.hostedemail.com (Postfix) with SMTP id 8E5BD1A000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:34:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=NyoCETLu;
	spf=pass (imf19.hostedemail.com: domain of "prvs=md1566FE5EBB=lirongqing@baidu.com" designates 111.202.115.100 as permitted sender) smtp.mailfrom="prvs=md1566FE5EBB=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776818052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1YnZDXM8ZdkVqdMf5R+9TKGz9uGHadQlJqwwH2++Fw=;
	b=hFol9Xj6arVXb84EkeIZXi/nJTeWdgEg0vN1NH4w+wS7j7uWfOrvKXhSdb8ygP7vaERE6/
	rVb0TxjsnSXEDmH1DXlN6LGJA+9+kww5LH4WJfMkAxwrlOgUc4qdTAjlmLjDx9+z4vV/Cc
	yuHHxahJM8ZraNJApDZCdLjIC16nHpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776818052; a=rsa-sha256;
	cv=none;
	b=rNw/IqDhtyowDPwViJ/DBhpeXvf/VGAjM2p8C2TmuSZBjPPuwdQIvVqAWXraxXX3V6mWik
	ebkekyDxQQ2MTMtRPioPk/+SxLAaftyIfGmI6jpzU4TTgxkvKe/9kfsiTzvPeqZssHcqjB
	JNDARsdcpl0yH+Wl81j4TsNEIqmvoiw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=NyoCETLu;
	spf=pass (imf19.hostedemail.com: domain of "prvs=md1566FE5EBB=lirongqing@baidu.com" designates 111.202.115.100 as permitted sender) smtp.mailfrom="prvs=md1566FE5EBB=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.3.14
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBmcy9jb3JlZHVtcDogcmVkdWNlIHJlZHVuZGFudCBs?=
 =?gb2312?B?b2cgbm9pc2UgaW4gdmFsaWRhdGVfY29yZWR1bXBfc2FmZXR5?=
Thread-Topic: [PATCH] fs/coredump: reduce redundant log noise in
 validate_coredump_safety
Thread-Index: AQHcyMFY/cw3SV8CfU6IGStSPD3DzrXqTV4g
Date: Wed, 22 Apr 2026 00:34:03 +0000
Message-ID: <7cb39b3d208649fa984ce5c9b4f7f5b4@baidu.com>
References: <20260410080918.2319-1-lirongqing@baidu.com>
In-Reply-To: <20260410080918.2319-1-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.31.62.13]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1776818046;
	bh=D1YnZDXM8ZdkVqdMf5R+9TKGz9uGHadQlJqwwH2++Fw=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=NyoCETLuw40NJbDLJZUAXcCzw3idY4usI39LwM9KcgoupYN8OMdEi9q5b15LK6Zbt
	 OQQCRorqQ6Zmpwh9H/sMQJYNzRRq2ifDnC+ARiDwZzQ1uBLQ0rI23i63UM5C/MLiDD
	 lcHZ0IVuKs25dQm2kw8wEmcu3FH9IeFmIERR9dDrIKKY3DYkBraPYfRFTg+I6w8u+e
	 P6gWPpEaHgbjKhgdSB0ZFftaucxbkhGkFRQGgSYWoGvahVh6X3xQavjSV/rcSEEWlj
	 c2rkZLGsanByZYCV/0toOKq6Pp27pO1sjV2PGbSQOC5pc35B8S4eaKu3kGcCTpUUvt
	 DQTdZg9aeN0Lg==
X-Rspamd-Queue-Id: 8E5BD1A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: fmrr7647esze8tu5bz4fykst9t31oc7z
X-Rspam-User: 
X-HE-Tag: 1776818049-819934
X-HE-Meta: U2FsdGVkX1/+OUXm8rwA0mHBiZruh2pljNLX0REV4CkvhxFcibjmir0XrAHyXnZLQ4FJR4+biGSBqCUdqV7VfSLsMMcb+frqEh7qhEOA0GzR1d2Z+BNuW39oyxl/JF1hnJuTu8wFv2Tv2m8KS68svdNLcOJUTmQTd8RbXn1P25HE7K0Oov34j1/Gu77iecAsohhXL6WOh8bdhY0iCKzpOUBrUyzeqHHbAFCRZ1N33z9X08WM8QIX0RG+3RgljIsEW7UNmn9pwrlqQzvaOW+0F7RZD0RQZG4ba9NalSK9g0GgCraF/lRQ0uM0Z9SrfWYu8/0ZTYndiZJuV/80xZF3J8Lt7Vc45AfPodTo8fE92ytNdMPgTHvo53BDJMJtvObXisPZfGVFcfCD2+su04TBxx91pSTtwcHrBD9f8JSbTy6ESvPCmwPSYKyjNZoFKsKsCvQfkpBdqu77iAmn3s2jqi5kMjaiDtzTF4fzBIFAOvQLSyARxf87fVLa0uAF1ghr2aV6xHhbN7jF54LKWkQpFg58YjeLiPVORBX0sCUMUKdhxTKsZ8b4buCdfQTkrmvE9WO0fEb+j1eCX+VVKOD/FL4f8tpj6s83IaSJ99VkAZs1sjlWPtjCBFaJqE8YY8jWiIld1cfnNhsveW8DB7PoaK/N1RVrJLrtQFxHJst3egnep0zRRVfLtIRGxsI5H62wVxjC6KDvhHux/rlR+kZptB2dtzHq2YPh0y6tQOZH02M89EkL6axO5uEzpY06NpsZp/VovZxtw28x6cDKSX4Sa+wqQU06ZPS4EZs8bp4gZuXuAIVEyX09RrObo7aaDo9wiPSu6pue0ggUWja0ACU+/oJ2B2igVEvasGS7URRfAq+zoCefiNPCaYCunL77lJm6IS++BkjYTxsIBjSiNrL2rKHrDve/YQDl7ILca2sTiPz8jeKTphK+aUMf1+VlSAofRK7WHA7AcsBmaZMF9jk
 JFvvob+x
 FyFBTM8Vxu5fHa6Bk3i/BruA5EgJNCLhiaoHkIkI0JDlnmt4gYQOV93UzRN1M6P3amfGhO1P0GqP+p0rIqUnSmPr7kbNEWsR/pVN/LQRxZSzk5iY0GBKcPsF4PeK0QQVc5ULN1/F1suHxDbjDMkxK7GRC6gOXq2Rwg630Tcqy7kLcXFD7kgKql/qb0aLMYa/3TjahaNhpIYVAtsSXJT4lDHomsxq7kKeCNeF8F2/ukWFJJUt7KCd8pY4h0/ILVM8e99gq24pTxgEhOfKk0V9RfIYuW4oO6/tnXeZutESQ4jaZ4lo4X9QAi7dHOlHj5UUAMDpLhrIkB3yDycZf9taDk0vUCvCkoCdMlchzBzE01Bf+j5KNebr/lqij49p9QemyH2Cgcucs2nhhyvGKVhISOaccNmIdmok9H5OyTO2huNsCziFR03Qq9LEWomuS43z9Xymvxda3jAJTJlpVUEyC1fmeEk+k4FJ0vtjVQeihLBceEVaqGiJm3ZzqNqVC3Q1tLTEXWSlna4zkwkZcJ4P1wd1fsXGCVbClrNEUlqhYpMqCK5rgOdqBOySMpXpiPLjdh59UGmCivNsy/olPRBUty9EXHLh9lJg9SEa72PteyWL2n/tdeT3LeYmRCzX2G7ciHkaLyh7rM68hDAZ16TKVU6ZXWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gDQo+IEN1cnJl
bnRseSwgd3JpdGluZyB0byAnY29yZV9wYXR0ZXJuJyBvciAnc3VpZF9kdW1wYWJsZScgc3lzY3Rs
IG5vZGVzIGFsd2F5cw0KPiB0cmlnZ2VycyB2YWxpZGF0ZV9jb3JlZHVtcF9zYWZldHkoKSwgZXZl
biBpZiB0aGUgdmFsdWVzIGhhdmUgbm90IGNoYW5nZWQuIFRoaXMNCj4gcmVzdWx0cyBpbiByZWR1
bmRhbnQgd2FybmluZyBtZXNzYWdlcyBpbiBkbWVzZzoNCj4gDQo+ICJVbnNhZmUgY29yZV9wYXR0
ZXJuIHVzZWQgd2l0aCBmcy5zdWlkX2R1bXBhYmxlPTIuLi4iDQo+IA0KPiBUaGlzIHBhdGNoIG9w
dGltaXplcyB0aGUgcHJvY2ZzIGhhbmRsZXJzIHRvIG9ubHkgaW52b2tlIHRoZSBzYWZldHkgdmFs
aWRhdGlvbg0KPiB3aGVuIGFuIGFjdHVhbCBjaGFuZ2UgaW4gdGhlIGNvbmZpZ3VyYXRpb24gaXMg
ZGV0ZWN0ZWQ6DQo+IA0KPiAxLiBJbiBwcm9jX2Rvc3RyaW5nX2NvcmVkdW1wKCksIGNvbXBhcmUg
dGhlIG5ldyBjb3JlX3BhdHRlcm4gc3RyaW5nDQo+ICAgIHdpdGggdGhlIGV4aXN0aW5nIG9uZSB1
c2luZyBzdHJuY21wKCkuDQo+IDIuIEluIHByb2NfZG9pbnR2ZWNfbWlubWF4X2NvcmVkdW1wKCks
IGNoZWNrIGlmIHRoZSBuZXcgc3VpZF9kdW1wYWJsZQ0KPiAgICB2YWx1ZSBkaWZmZXJzIGZyb20g
dGhlIHByZXZpb3VzIG9uZS4NCj4gDQo+IFRoaXMga2VlcHMgdGhlIGtlcm5lbCBsb2cgY2xlYW4g
ZnJvbSByZXBldGl0aXZlIHdhcm5pbmdzIHdoZW4gcmUtYXBwbHlpbmcgdGhlDQo+IHNhbWUgc3lz
Y3RsIHNldHRpbmdzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3Fp
bmdAYmFpZHUuY29tPg0KPiAtLS0NCj4gIGZzL2NvcmVkdW1wLmMgfCAzICsrLQ0KPiAgZnMvZXhl
Yy5jICAgICB8IDYgKysrKy0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jb3JlZHVtcC5jIGIvZnMvY29y
ZWR1bXAuYyBpbmRleCAyOWRmOGFhLi45YjM1N2QyIDEwMDY0NA0KPiAtLS0gYS9mcy9jb3JlZHVt
cC5jDQo+ICsrKyBiL2ZzL2NvcmVkdW1wLmMNCj4gQEAgLTE0ODMsNyArMTQ4Myw4IEBAIHN0YXRp
YyBpbnQgcHJvY19kb3N0cmluZ19jb3JlZHVtcChjb25zdCBzdHJ1Y3QNCj4gY3RsX3RhYmxlICp0
YWJsZSwgaW50IHdyaXRlLA0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gIAl9DQo+IA0KPiAtCXZh
bGlkYXRlX2NvcmVkdW1wX3NhZmV0eSgpOw0KPiArCWlmIChzdHJuY21wKG9sZF9jb3JlX3BhdHRl
cm4sIGNvcmVfcGF0dGVybiwgQ09SRU5BTUVfTUFYX1NJWkUpKQ0KPiArCQl2YWxpZGF0ZV9jb3Jl
ZHVtcF9zYWZldHkoKTsNCj4gIAlyZXR1cm4gZXJyb3I7DQo+ICB9DQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZnMvZXhlYy5jIGIvZnMvZXhlYy5jDQo+IGluZGV4IDllYTNhNzcuLjMyYjQ2ZTQgMTAwNjQ0
DQo+IC0tLSBhL2ZzL2V4ZWMuYw0KPiArKysgYi9mcy9leGVjLmMNCj4gQEAgLTE5NzUsOSArMTk3
NSwxMSBAQCBDT01QQVRfU1lTQ0FMTF9ERUZJTkU1KGV4ZWN2ZWF0LCBpbnQsIGZkLA0KPiBzdGF0
aWMgaW50IHByb2NfZG9pbnR2ZWNfbWlubWF4X2NvcmVkdW1wKGNvbnN0IHN0cnVjdCBjdGxfdGFi
bGUgKnRhYmxlLCBpbnQNCj4gd3JpdGUsDQo+ICAJCXZvaWQgKmJ1ZmZlciwgc2l6ZV90ICpsZW5w
LCBsb2ZmX3QgKnBwb3MpICB7DQo+IC0JaW50IGVycm9yID0gcHJvY19kb2ludHZlY19taW5tYXgo
dGFibGUsIHdyaXRlLCBidWZmZXIsIGxlbnAsIHBwb3MpOw0KPiArCWludCBlcnJvciwgb2xkID0g
UkVBRF9PTkNFKHN1aWRfZHVtcGFibGUpOw0KPiANCj4gLQlpZiAoIWVycm9yICYmIHdyaXRlKQ0K
PiArCWVycm9yID0gcHJvY19kb2ludHZlY19taW5tYXgodGFibGUsIHdyaXRlLCBidWZmZXIsIGxl
bnAsIHBwb3MpOw0KPiArDQo+ICsJaWYgKCFlcnJvciAmJiB3cml0ZSAmJiAob2xkICE9IFJFQURf
T05DRShzdWlkX2R1bXBhYmxlKSkpDQo+ICAJCXZhbGlkYXRlX2NvcmVkdW1wX3NhZmV0eSgpOw0K
PiAgCXJldHVybiBlcnJvcjsNCj4gIH0NCj4gLS0NCj4gMi45LjQNCg0KUGluZyANClRoYW5rcw0K
DQpbTGksUm9uZ3FpbmddIA0KDQo=

