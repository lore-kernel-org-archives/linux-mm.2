Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B75BF9D0CC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E166B0092; Tue, 14 Apr 2026 08:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4FE6B0093; Tue, 14 Apr 2026 08:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26446B0095; Tue, 14 Apr 2026 08:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E28E26B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:38:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8A9D1A0328
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:38:16 +0000 (UTC)
X-FDA: 84657114192.15.20A43F8
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 896BA4000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:38:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="XMcP3K/6";
	spf=pass (imf01.hostedemail.com: domain of "prvs=557f67e71=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=557f67e71=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776170294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mscJTrff+wQfdwB3mlX8JtQE8/2Ht+mJQARI/Gk4Z8=;
	b=JWEvOr4bfooWzd50KkCdewUPieS2z+cKG7HTH2xZBZR17pF/1PXO9roFilX56LPo3Ej8Vv
	+HvHJ3pTFggYaOruwUx4SY/ipm2gVq3gTQbPR5VCzgqbOfMguWnrsU0jZ2NIiwnFXMzyiI
	/oETjB25EPxHMKaCIegLSCR+u/YJXjI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="XMcP3K/6";
	spf=pass (imf01.hostedemail.com: domain of "prvs=557f67e71=graf@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=557f67e71=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776170294; a=rsa-sha256;
	cv=none;
	b=rwwWWRVIawfjcEKhtxhPstDnrsbDgDZM/LctFryuctORApJtS7Cvn0v9pDIcjiHVdLOolk
	aYHBZO2TAHONJNzqzodVEBs1hBcMMARgSB1R86sbNuMGrTQlcfHIrQ0QynkAZtITrDrSTB
	jqKJspEdvIRqc1neWl1FmxGp5n0sD9Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776170294; x=1807706294;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2mscJTrff+wQfdwB3mlX8JtQE8/2Ht+mJQARI/Gk4Z8=;
  b=XMcP3K/63q1TMX70Jgb7yVyPZEhusGnsbE7DU+hVguoi+GJ33UibIHM2
   ETrbVP+qpLmnDBINeWpOSSnfwG3htAsLaYMr+sqejL6GcK1jF7XzmzQay
   tnXgc+2FHRESD3783oQgHQHKnrZYc7lIqpFfHbNktUrW1j/Ib/ZAMV64F
   UEXLOaMn+kLQgKwlPYRiJKuzEI4/0G3eSmf1DW1XFKGxrvDkvMeBUu5L3
   zrCB9PyvpLw/7DF5TSpWjXHfbOneOu2YltRXhjvtCoHmBdOqsJPBzvCZP
   8qYmbDPlSvCLPWOhShNJMsK12+lRb4eieJ5PgmmvFkfqFzo6Gpz8krKaT
   Q==;
X-CSE-ConnectionGUID: cfEeLPAyTd2vlaZgOWPhtA==
X-CSE-MsgGUID: NSmikFhRQwSOZPY/Sesf+g==
X-IronPort-AV: E=Sophos;i="6.23,179,1770595200"; 
   d="scan'208";a="17248928"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 12:38:11 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:1933]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.173:2525] with esmtp (Farcaster)
 id b6cb576a-944f-4948-b49f-225317c145e3; Tue, 14 Apr 2026 12:38:10 +0000 (UTC)
X-Farcaster-Flow-ID: b6cb576a-944f-4948-b49f-225317c145e3
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 14 Apr 2026 12:38:10 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 14 Apr 2026
 12:38:08 +0000
Message-ID: <45617e3d-59c5-4c2a-9c2d-b7bfad805d78@amazon.com>
Date: Tue, 14 Apr 2026 14:38:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] MAINTAINERS: update KHO and LIVE UPDATE maintainers
To: Pratyush Yadav <pratyush@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, "David
 Hildenbrand (Arm)" <david@kernel.org>
CC: <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260414121752.1912847-1-pratyush@kernel.org>
 <20260414121752.1912847-2-pratyush@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20260414121752.1912847-2-pratyush@kernel.org>
X-Originating-IP: [172.19.99.218]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 896BA4000D
X-Stat-Signature: tkaogma6uzfcrw3rmzx9fzajhw99xpji
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776170294-500161
X-HE-Meta: U2FsdGVkX1/0+9K/w2F4dS4I/l33vaJujzYpOXTBi8QfldGXsnFzeL8NMdYvKJVArnz9LfK3q8qCXey4e/g/s+BHWQN90hCrmGyUpKf1pPJHAytpJBFIVc97Nv2GcQLpjup0iye5rAQ/kTT0y0vMe/H8PJo+HwkI9wyChzSUCylJUws72jJ8Sjzx95xDvB3B4BB26tF+G+o3Hstq6SWXi/h/AOnxUdy5Dd1oHjRLJut+by48UgqC85pBML2RvtEVHIPrJLeKHDzWNWj+f/czXu89mdkFzpmSB5My/YYD/gKEv7Z63wtqSDnRo1mRoi4vVuDyxPXZQ6YK4EGzDfHV3FWbR/12wJs+cojUrco/forczkEMgWZ1AxvDq1SvvlHnamOBiA9YHptUEh2fQLM4pJ87+aeSYRYaSGSCxoQOK24r/Jt9bF8THPQ2CyIJKwd4ICzvTh7wcTX1CzVI6OJSD6jEILKaoPCZYKY245PtEeIa/27lESW97MOtVkZ1zx0UYs2pi1tsPV+cCC9ShmecBEx87L//DyccgeXZ87DDlm+nno9FLLEwgjPuijQvyl/N9h76jx/PzdRSE5pQtFsZvCL0xcPiikQJALM7KPafLmOruIUGE/SDyQe97Uuu1zgh255xX423Ackhz45YbvT3YyIHqYQvdIQm911eY86vN/TlM5Q1MS3YgSP7E2poBVKaIURTl+EK6H3thV15JtZIu2304gcTU1WY3+3Z6ClSPvqy6wXdWz9gq0AdMbnFNmQnf3UyeVLTEXtfVGhXFKfa6Kh5xXL+LMrOS8sj7XN9j5OHXh4g2fq6Jg4A+al6R/BROLxwanGpzGV/hnNYOaTcoBHJVAzAU8J6Ovfs5B1bEKNm5w8+t4qWYkBeWEVC2BcTEW0CZuz5eScXCKCx14n7YaAwc0fkJndLYHaTKQ7q8P3cC9kPGEf3pSAkAeG4v6oNmuXd4OdXigi/vfEZSuk
 zbWzt6q/
 x3uP/i21pdbdyxbCsywWImXS/gsBgVNJCzdHSqsdic8arGHYF2OHneR5QLZ23r+pQuI2CGoFMkhT9nl7HSp//HdUOeZYb2Qepx2tSc+Y4BrT7hujwn2WM9urUOolPuVXgtJ3h7LUrhheipm4eJ9/CS66UIe/GiWsJz6cDCigBASdhFpZw6FeEjlHsnKOybUrdvOjA4P+k9v0wX9YWeAAm98p+OkUNDC7rvAxUZsus3xdJnL+5livtmG0smmzBSM+kY4sNyuzCUpQhyanckfTyluuRQf2VOORz8RDZ7ML6LWfY4IGTt1S1CMuV1XDVLZYF2uhwHsgevq5zr9/D6gtQt7xg3YFPS+XFZG7gvwiFoQxQO852FlBqAgqfVoKN4qT04rcE2a0IIJt3mrPT8xsOUkoRuRo1hAODcUPTzpvcFaZUuicCD8bYAV0d5cu3xrcPU5tNLcrVyxq9thm7hcFLBPF4BFYE4c626zOaZGPTrZCz/DMXnQNoD/4FXY3K0DUhqNg/ttBxnYXgtTRt0Yv3Et8u7v3Lx6Ltrm+/8RHVRfdu51sFZtFoxOosrBK8cTFU8UvvC9H6xFykUllUbHLaeMK3ZV0iDl/AHQcrJN2mNWJiNpKNluxZPH3zi7Ghw1NlbXS05up8cj4ByrOvXf8hsuYXAPnN4yoHtpzsn5BwoNSlI/XSAoxbRN09PjU+qUaa9z5pfo7TlTNw37ltFjuAxh1R7NDJx5cb5TeFsQ6BUadV/pbuNvACAOkhO61th6/HYnbyGHIhoBJNl/CySEmmu7WSmHU41BVu6Ae9rn7bxH6YOgtH+DBmQWBDBywsDzGgI0c9vl7+FT5ZtEjLLQjgSaHxhSzJ36QOO3U72DToTGGcsVz2YgbmIcXF2R+VYiU53tAopFDZCIWu3HyCQr4UqreiwlZn4hJaknkaB87ewKzuoAyTuRTcoQy75Ty97uZW8acCfOAdlfCgs0zuPyo1VF7c/3yR
 xxTSZegN
 BcduB/gMgl+YS7NDvhCU3/lyAZelFhNVrD0NyK6zEKzsPx3fsnsHHFhkky5+FzI1mEvlYciWxgZifBvhh/pwSdaSXHFEyYOxsHhw8vu1xCk6GcbI1Lm5Imi3VxH7bQmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ck9uIDE0LjA0LjI2IDE0OjE3LCBQcmF0eXVzaCBZYWRhdiB3cm90ZToKPiBGcm9tOiAiUHJhdHl1
c2ggWWFkYXYgKEdvb2dsZSkiIDxwcmF0eXVzaEBrZXJuZWwub3JnPgo+Cj4gSSBoYXZlIGJlZW4g
aGVscGluZyBvdXQgd2l0aCByZXZpZXdpbmcgYW5kIGRldmVsb3BpbmcgS0hPLiBJIHdvdWxkIGFs
c28KPiBsaWtlIHRvIGhlbHAgbWFpbnRhaW4gaXQuIENoYW5nZSBteSBlbnRyeSBmcm9tIFIgdG8g
TSBmb3IgS0hPIGFuZCBsaXZlCj4gdXBkYXRlLiBBbGV4IGhhcyBiZWVuIGluYWN0aXZlIGZvciBh
IHdoaWxlLCBzbyB0byBhdm9pZCBvdmVyLWNyb3dkaW5nCj4gdGhlIEtITyBlbnRyeSBhbmQgdG8g
a2VlcCB0aGUgaW5mb3JtYXRpb24gdXAtdG8tZGF0ZSwgbW92ZSBoaXMgZW50cnkKPiBmcm9tIE0g
dG8gUi4KPgo+IFdlIGFsc28gbm93IGhhdmUgYSB0cmVlIGZvciBLSE8gYW5kIGxpdmUgdXBkYXRl
IGF0IGxpdmV1cGRhdGUvbGludXguZ2l0Cj4gd2hlcmUgd2UgcGxhbiB0byBzdGFydCBtYWludGFp
bmluZyB0aG9zZSBzdWJzeXN0ZW1zIGFuZCBzdGFydCBxdWV1aW5nCj4gdGhlIHBhdGNoZXMuIExp
c3QgdGhhdCBpbiB0aGUgZW50cmllcyBhcyB3ZWxsLgo+Cj4gU2lnbmVkLW9mZi1ieTogUHJhdHl1
c2ggWWFkYXYgKEdvb2dsZSkgPHByYXR5dXNoQGtlcm5lbC5vcmc+CgoKUmV2aWV3ZWQtYnk6IEFs
ZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+CgoKQWxleAoKCj4gLS0tCj4gICBDUkVESVRT
ICAgICB8IDQgKysrKwo+ICAgTUFJTlRBSU5FUlMgfCA4ICsrKysrLS0tCj4gICAyIGZpbGVzIGNo
YW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9D
UkVESVRTIGIvQ1JFRElUUwo+IGluZGV4IDkwOTFiYWMzZDJkYS4uOTE3MzUwOGI0ZTAzIDEwMDY0
NAo+IC0tLSBhL0NSRURJVFMKPiArKysgYi9DUkVESVRTCj4gQEAgLTE0NTYsNiArMTQ1NiwxMCBA
QCBOOiBBbmR5IEdvc3BvZGFyZWsKPiAgIEU6IGFuZHlAZ3JleWhvdXNlLm5ldAo+ICAgRDogTWFp
bnRlbmFuY2UgYW5kIGNvbnRyaWJ1dGlvbnMgdG8gdGhlIG5ldHdvcmsgaW50ZXJmYWNlIGJvbmRp
bmcgZHJpdmVyLgo+Cj4gK046IEFsZXhhbmRlciBHcmFmCj4gK0U6IGdyYWZAYW1hem9uLmNvbQo+
ICtEOiBLZXhlYyBIYW5kb3ZlciAoS0hPKQo+ICsKPiAgIE46IFdvbGZnYW5nIEdyYW5kZWdnZXIK
PiAgIEU6IHdnQGdyYW5kZWdnZXIuY29tCj4gICBEOiBDb250cm9sbGVyIEFyZWEgTmV0d29yayAo
ZGV2aWNlIGRyaXZlcnMpCj4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMK
PiBpbmRleCA5MTVmMDc0YzM1NzcuLjk3ODIwMTg4YTYwMCAxMDA2NDQKPiAtLS0gYS9NQUlOVEFJ
TkVSUwo+ICsrKyBiL01BSU5UQUlORVJTCj4gQEAgLTE0MTA5LDEzICsxNDEwOSwxNCBAQCBGOiAg
ICBpbmNsdWRlL3VhcGkvbGludXgva2V4ZWMuaAo+ICAgRjogICAgIGtlcm5lbC9rZXhlYyoKPgo+
ICAgS0VYRUMgSEFORE9WRVIgKEtITykKPiAtTTogICAgIEFsZXhhbmRlciBHcmFmIDxncmFmQGFt
YXpvbi5jb20+Cj4gICBNOiAgICAgTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJuZWwub3JnPgo+ICAg
TTogICAgIFBhc2hhIFRhdGFzaGluIDxwYXNoYS50YXRhc2hpbkBzb2xlZW4uY29tPgo+IC1SOiAg
ICAgUHJhdHl1c2ggWWFkYXYgPHByYXR5dXNoQGtlcm5lbC5vcmc+Cj4gK006ICAgICBQcmF0eXVz
aCBZYWRhdiA8cHJhdHl1c2hAa2VybmVsLm9yZz4KPiArUjogICAgIEFsZXhhbmRlciBHcmFmIDxn
cmFmQGFtYXpvbi5jb20+Cj4gICBMOiAgICAga2V4ZWNAbGlzdHMuaW5mcmFkZWFkLm9yZwo+ICAg
TDogICAgIGxpbnV4LW1tQGt2YWNrLm9yZwo+ICAgUzogICAgIE1haW50YWluZWQKPiArVDogICAg
IGdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGl2ZXVw
ZGF0ZS9saW51eC5naXQKPiAgIEY6ICAgICBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL21tL2to
by5yc3QKPiAgIEY6ICAgICBEb2N1bWVudGF0aW9uL2NvcmUtYXBpL2toby8qCj4gICBGOiAgICAg
aW5jbHVkZS9saW51eC9rZXhlY19oYW5kb3Zlci5oCj4gQEAgLTE0ODAyLDkgKzE0ODAzLDEwIEBA
IEY6ICAgICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9saXZlcGF0Y2gvCj4gICBMSVZFIFVQREFU
RQo+ICAgTTogICAgIFBhc2hhIFRhdGFzaGluIDxwYXNoYS50YXRhc2hpbkBzb2xlZW4uY29tPgo+
ICAgTTogICAgIE1pa2UgUmFwb3BvcnQgPHJwcHRAa2VybmVsLm9yZz4KPiAtUjogICAgIFByYXR5
dXNoIFlhZGF2IDxwcmF0eXVzaEBrZXJuZWwub3JnPgo+ICtNOiAgICAgUHJhdHl1c2ggWWFkYXYg
PHByYXR5dXNoQGtlcm5lbC5vcmc+Cj4gICBMOiAgICAgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZwo+ICAgUzogICAgIE1haW50YWluZWQKPiArVDogICAgIGdpdCBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGl2ZXVwZGF0ZS9saW51eC5naXQKPiAgIEY6
ICAgICBEb2N1bWVudGF0aW9uL2NvcmUtYXBpL2xpdmV1cGRhdGUucnN0Cj4gICBGOiAgICAgRG9j
dW1lbnRhdGlvbi9tbS9tZW1mZF9wcmVzZXJ2YXRpb24ucnN0Cj4gICBGOiAgICAgRG9jdW1lbnRh
dGlvbi91c2Vyc3BhY2UtYXBpL2xpdmV1cGRhdGUucnN0Cj4gLS0KPiAyLjU0LjAucmMwLjYwNS5n
NTk4YTI3M2IwMy1nb29nCj4KCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50
ZXIgR2VybWFueSBHbWJIClRhbWFyYS1EYW56LVN0ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVm
dHNmdWVocnVuZzogQ2hyaXN0b2YgSGVsbG1pcywgQW5kcmVhcyBTdGllZ2VyCkVpbmdldHJhZ2Vu
IGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBC
ZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


