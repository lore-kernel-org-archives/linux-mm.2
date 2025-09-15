Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A799CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932358E0017; Mon, 15 Sep 2025 07:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A098E0001; Mon, 15 Sep 2025 07:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F9B8E0017; Mon, 15 Sep 2025 07:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2D08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:50:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7F3013B5DF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:50:22 +0000 (UTC)
X-FDA: 83891316684.17.14616FD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2D09140007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:50:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757937020; a=rsa-sha256;
	cv=none;
	b=EukSi2WbMWJ65jU9Q9xl49fOedf79zBiGeU5lm81Q3gtlxjhp9Nr1LbJfHT/bq9rESLo/q
	veLoqCRENyrYqcNoFyfs7XwIHipfB43h9abSYFPGDIAEzZZyDTRb5je2HEwWpvVGH03+aN
	El8/jlY5w5xUefeAFA8aNC7WkFZtlWQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757937020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbEac92sEXrJ/qwkFNWDdO6MpAz8n0Z/6Y4xoea3Djk=;
	b=KlZl7CpstmLvJXg85wddCxusLK/IqV/erE9uBfIZDWWnMcYUq+dc6jYrEv63637sHYVHdN
	LIYBaQCDanCi+y45LANyKlt3Nr6886DIe4V65L+slvEOKmpDYwrwZpvHOMAPLBtUycPFAm
	lgSsr0JcxABCXbp6aKWpjHDGrvh2E00=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cQNYv20tTz6M4w8;
	Mon, 15 Sep 2025 19:47:31 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id C6FBC1400DC;
	Mon, 15 Sep 2025 19:50:16 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Sep 2025 13:50:16 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Mon, 15 Sep 2025 13:50:16 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Borislav Petkov <bp@alien8.de>
CC: "rafael@kernel.org" <rafael@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>, "rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>, "Jon.Grimm@amd.com"
	<Jon.Grimm@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "naoya.horiguchi@nec.com"
	<naoya.horiguchi@nec.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "somasundaram.a@hpe.com"
	<somasundaram.a@hpe.com>, "erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "duenwen@google.com"
	<duenwen@google.com>, "gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>, tanxiaofei
	<tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>, "Roberto
 Sassu" <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: RE: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Topic: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Index: AQHcHC9WuMPoKRXbY02Oy+WxUZ/jerSMt+SAgAK0t2CAABfigIAEdNLA
Date: Mon, 15 Sep 2025 11:50:16 +0000
Message-ID: <9433067c142b45d583eb96587b929878@huawei.com>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
In-Reply-To: <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.126.175.244]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2D09140007
X-Stat-Signature: 8c47jfsb4xaeqwqr3xtb9y6he9guznrm
X-Rspam-User: 
X-HE-Tag: 1757937019-127924
X-HE-Meta: U2FsdGVkX1+2t8g7ZnUn83Ok+wkQlSmm3O2RNZZBRszca8Svecsnzr4NLmNmBP1JZ0S1NstMjLDNRkHwkCli0DXC/qCXsVs0oAsiXjTW+BVN6yxzYerMBK/p0OSgD81NpegEAz9iNXUBkb+q/QpQw/Qohk+GehrYfpuUlJTQUwBVOi04H6hXGCz92yAvTXIcp2skDGitNrYZnlz+F1fKZH/peEby5kL43UsrWC6azZ7UytzjMGHnksqNk7lB6Esi2lY6UAxzJrX0nv6aUaOoBPj5Qu2VofJGSJY1DURyJJK4iAHAfUK5MMkrTdVTt2/ld7i86HGk/itoDOw6YbaaF1tx9FFgILVomAPU8RlBNNDBVfs7wS6P7+O2UsBuNesk0uzCMRxXDrGk1qZhJ0kN4KuT48XXTnJ2FGVSnVnhpuqPQ1Yefn6dp8IzjqCDI/2maaHicbkoaa1qoLBbXeAppiTTOsGbMfOKGS3AnjXiUG4+cxTBW8cRtLKlKA2kXYHTXsyEn+UPf3SM2U/dGTe2LuY70dcqgaqpH7jLJbzZDFtQMEdCROgeoZjjhFs2gnMhbnuFeLynitCWzZiUHJBAN5PUW6trcdpfZ0zQVi+S1wGMCC9oJprY931hTN7LVXVSRM6yS3c3vfcSHRvddP11fsba4p8Pv2Kr1K8UmBnROGom3ce4+NadKy00oii3qOXMl60ftq77LPGt0pArwZ4ckVCBE5cxK14JbKPsCosEdVmB2XOcelZoQvEs3zekNqr/z9z024r9dyW0X+zX4GUqznjcKpiBzX+7bn0bI6z63jplCYdKkmc7nm1BTjE7XJGERzO65udWoKvjNSBQ9JqaEbsLWne5KIFRReqvnj6w3s82fV5/zUvAWEHlgHxNuE/UXZ6scX8EWBVRIAit6t4vAnrIkUmmNVgwXZjh3kccphleO6xX+CiuuM5FmzK/TTCN5v/pBVrOuDioumKSIFl
 YJzzR4i0
 KAEOl+N4cnsm4Y9AB9MgLRHqAV3Om62q1aY92tesGbukwR4h8mG0vK83oUb0e9E7+ORUzYHjLc0rtcy/yWHh7seSBMKK+XKy6NXdE4F4WZPE/E0cacpqj6SMiL+MRd5Xj+E/+y1rVshv1u9+sr5eubk7IrbtjoDe8R36oLI1Z7VIV+upsLGc1d89Rf9y9cM6t+sgH7aqxH8CK3vILhu9pSBCxWgUTlP55BBLNt9BKUAVzULJYu+S5mRf8XuGD9mS2Ndkvus7kPK7ywiDBkNv+SnC/rEddyUk0USexswRtJAkz6xJh0nH5iT8lFroplAv9E7WcLHNfHgSvHTsz4i4asM2GiDevE27m4wYqXuM3GRIMtwjTeruHGIe+DP68k0r9EtQbwwvRuue1VTr3NuFFUDWdsYCElqU8HlT7YOLKY9WuyfmINa6mq3gV/E4Qts28Ypfr3CHaThp5c9oWLbm8tBB4IlxU5ccb1+XGVkr1QmEJK92S8YzNwYfrIB/wFsXWXXthPO1Qqr+Z0HQivo+wkZ17My7DB+veZ+DZg5lWXdoBrhITUhr46OaZw9WA40gqvnQ5LbPfYUq1UHiNY+I/AI4bfZ4prcwzGKzg3BZYvbeyXS25JyVxeRYlLXPKsf+UfQudKSzsRjK0Z02CXaQJQ8YFyojoummOHRGPzGBGpRFgMRPMUGJFVukuWq7lnil5K6ptQMEdAzvCQ2JslhMNDVFof7qqPCkOydcnmrxLBAuFydg8xOSQqB07KLpJeDDRfhNJEF9uP967HROGSVeUWjyxv/ZKRIg47vbpcXRWELfuOl0sxbGGzPWcoj0aRi5D1oFtBInKZBCUQwisKiW7IG5hxYMDCvs6SDdLEDI1neBFKCyKOKCUNXopIQcWP0qvwv4PLLX2L/kEcj9gr28gIBl/qUdrMPgeC7dfc4w2Jx4PPPc0sTHSHsHZJSxbSAc/6Nhn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+DQo+U2VudDogMTIgU2VwdGVtYmVyIDIwMjUgMTU6MTINCj5UbzogU2hpanUgSm9z
ZSA8c2hpanUuam9zZUBodWF3ZWkuY29tPg0KPkNjOiByYWZhZWxAa2VybmVsLm9yZzsgYWtwbUBs
aW51eC1mb3VuZGF0aW9uLm9yZzsgcnBwdEBrZXJuZWwub3JnOw0KPmRmZXJndXNvbkBhbXBlcmVj
b21wdXRpbmcuY29tOyBsaW51eC1lZGFjQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+YWNwaUB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgtZG9jQHZnZXIua2VybmVs
Lm9yZzsNCj50b255Lmx1Y2tAaW50ZWwuY29tOyBsZW5iQGtlcm5lbC5vcmc7IGxlby5kdXJhbkBh
bWQuY29tOw0KPllhemVuLkdoYW5uYW1AYW1kLmNvbTsgbWNoZWhhYkBrZXJuZWwub3JnOyBKb25h
dGhhbiBDYW1lcm9uDQo+PGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IExpbnV4YXJtIDxs
aW51eGFybUBodWF3ZWkuY29tPjsNCj5yaWVudGplc0Bnb29nbGUuY29tOyBqaWFxaXlhbkBnb29n
bGUuY29tOyBKb24uR3JpbW1AYW1kLmNvbTsNCj5kYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207
IG5hb3lhLmhvcmlndWNoaUBuZWMuY29tOw0KPmphbWVzLm1vcnNlQGFybS5jb207IGp0aG91Z2h0
b25AZ29vZ2xlLmNvbTsgc29tYXN1bmRhcmFtLmFAaHBlLmNvbTsNCj5lcmRlbWFrdGFzQGdvb2ds
ZS5jb207IHBnb25kYUBnb29nbGUuY29tOyBkdWVud2VuQGdvb2dsZS5jb207DQo+Z3RoZWxlbkBn
b29nbGUuY29tOyB3c2Nod2FydHpAYW1wZXJlY29tcHV0aW5nLmNvbTsNCj53YnNAb3MuYW1wZXJl
Y29tcHV0aW5nLmNvbTsgbmlmYW4uY3hsQGdtYWlsLmNvbTsgdGFueGlhb2ZlaQ0KPjx0YW54aWFv
ZmVpQGh1YXdlaS5jb20+OyBaZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsg
Um9iZXJ0bw0KPlNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+OyBrYW5na2FuZy5zaGVu
QGZ1dHVyZXdlaS5jb207DQo+d2FuZ2h1aXFpYW5nIDx3YW5naHVpcWlhbmdAaHVhd2VpLmNvbT4N
Cj5TdWJqZWN0OiBSZTogW1BBVENIIHYxMiAxLzJdIEFDUEk6UkFTMjogQWRkIEFDUEkgUkFTMiBk
cml2ZXINCj4NCj5PbiBGcmksIFNlcCAxMiwgMjAyNSBhdCAxMjowNDo1N1BNICswMDAwLCBTaGlq
dSBKb3NlIHdyb3RlOg0KPj4gPldoeSBpcyB0aGlzIHJlcXVpcmVtZW50IGhlcmU/DQo+PiBUaGUg
cGh5c2ljYWwgbWVtb3J5IGFkZHJlc3MgcmFuZ2UgcmV0cmlldmVkIGhlcmUgZm9yIHRoZSBOVU1B
IGRvbWFpbg0KPj4gaXMgdXNlZCBpbiB0aGUgc3Vic2VxdWVudCBwYXRjaCAgW1BBVENIIHYxMiAy
LzJdIHJhczogbWVtOiBBZGQgbWVtb3J5DQo+PiBBQ1BJIFJBUzIgZHJpdmVyLCAxLiB0byBzZXQg
UmVxdWVzdGVkIEFkZHJlc3MgUmFuZ2UoSU5QVVQpIGZpZWxkIG9mDQo+PiBUYWJsZSA1Ljg3OiBQ
YXJhbWV0ZXIgQmxvY2sgU3RydWN0dXJlIGZvciBQQVRST0xfU0NSVUIgd2hlbiBzZW5kDQo+PiBH
RVRfUEFUUk9MX1BBUkFNRVRFUlMgY29tbWFuZCB0byB0aGUgZmlybXdhcmUsIHRvIGdldCBzY3J1
Yg0KPnBhcmFtZXRlcnMsIHJ1bm5pbmcgc3RhdHVzLCBjdXJyZW50IHNjcnViIHJhdGUgZXRjLg0K
Pj4gMi4gZm9yIHRoZSB2YWxpZGl0eSBjaGVjayBvZiB0aGUgdXNlciByZXF1ZXN0ZWQgbWVtb3J5
IGFkZHJlc3MgcmFuZ2UgdG8gc2NydWIuDQo+DQo+QWdhaW4sIHdoeSBkb2VzIGl0IGhhdmUgdG8g
YmUgKmxvd2VzdCogYW5kICpjb250aWd1b3VzKj8NCj4NCj5Zb3VyIGFuc3dlciBkb2Vzbid0IGV4
cGxhaW4gdGhhdC4NClRoaXMgaGFzIGJlZW4gYWRkZWQgYXMgc3VnZ2VzdGVkIGJ5IEpvbmF0aGFu
IGNvbnNpZGVyaW5nIHRoZSBpbnRlcmxlYXZlZCBOVU1BIG5vZGUuDQpMaW5rIHRvIHRoZSByZWxh
dGVkIGRpc2N1c3Npb24gaW4gVjExOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUw
ODIxMTAwNjU1LjAwMDAzOTQyQGh1YXdlaS5jb20vI3QNCg0KfCBub2RlIDAgfCBub2RlIDEgfCBu
b2RlIDAgfCAgIFBBIGFkZHJlc3MgbWFwLg0KQ2FuIHlvdSBnaXZlIHlvdXIgc3VnZ2VzdGlvbiB3
aGF0IHdlIHNob3VsZCBkbyBhYm91dCBpdD8NCg0KPg0KPj4gQWxzbyBpbnRlbmRlZCB0byBleHBv
c2UgdGhpcyBzdXBwb3J0ZWQgbWVtb3J5IGFkZHJlc3MgcmFuZ2UgdG8gdGhlDQo+PiB1c2Vyc3Bh
Y2UgdmlhIEVEQUMgc2NydWIgY29udHJvbCBpbnRlcmZhY2UsIHRob3VnaCBpdCBpcyBub3QgcHJl
c2VudCBub3cuDQo+DQo+V2h5PyBUbyB0aWUgb3Vyc2VsdmVzIHdpdGggZXZlbiBtb3JlIHVzZXIg
QUJJPyENCj4NCj5UaGVyZSBiZXR0ZXIgYmUgYSBnb29kIHJlYXNvbiBhbmQgbm90IGEgYmV0dGVy
IGRlc2lnbiBmb3Igd2hhdCB0aGlzIGlzIHRyeWluZyB0bw0KPmRvLg0KDQpUaGUgImFkZHJlc3Nf
cmFuZ2VfYmFzZSIgYW5kICJhZGRyZXNzX3JhbmdlX3NpemUiIHN5c2ZzIGF0dHJpYnV0ZXMNCih1
bnRpbCB0aGUgdjEzIG9mIEVEQUMgc2NydWIgaW50ZXJmYWNlLCkgd2hpY2ggd2UgY291bGQgYmUg
dXNlZCBmb3IgcHVibGlzaCB0aGlzDQpwaHlzaWNhbCBhZGRyZXNzIHJhbmdlIG9mIHRoZSBtZW1v
cnkgaW4gTlVNQSBkb21haW4gdG8gdGhlIHVzZXJzcGFjZSB3aGVuIHRoZSBkZW1hbmQgc2NydWJi
aW5nDQppcyBub3QgaW4gcHJvZ3Jlc3MsIGJ1dCAiYWRkcmVzc19yYW5nZV9iYXNlIiBoYXMgY2hh
bmdlZCB0byByZWFkIHRoZSBzdGF0dXMgb2YgIG9uLWRlbWFuZA0Kc2NydWJiaW5nIGJhc2VkIG9u
IHRoZSBmZWVkYmFjayBoZXJlLg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzRlZTM2ZDAz
YTI4OTQ2MDZhNTcxYjM3ZjQ0MGRhMzZmQGh1YXdlaS5jb20vI3QgICANCkFsc28gdG8gcHJlc2Vu
dCB0aGlzIHJlcXVpcmVtZW50IGZvciB0aGUgUkFTMiwgIHRoZXJlIHdhcyBubyBtZXRob2QgZm91
bmQgdG8gcmV0cmlldmUgdGhlDQptZW1vcnkgcGh5c2ljYWwgYWRkcmVzcyByYW5nZSB1bnRpbCBy
ZWNlbnQgdmVyc2lvbnMgYXMgaXQgaXMgbm90IHN1cHBvcnRlZCBpbiB0aGUgUkFTMi4NCg0KVXNl
IGNhc2UgZm9yIHRoZSBSQVMyIHRvIHB1Ymxpc2ggdGhlIHN1cHBvcnRlZCBQQSByYW5nZSBvZiB0
aGUgbm9kZSBtZW1vcnkgdG8gdGhlIHVzZXJzcGFjZToNClN5c3RlbXMgd2l0aCBtdWx0aXBsZSBO
VU1BIG5vZGUgZG9tYWlucyB3aXRoIHRoZSBzdXBwb3J0IGZvciB0aGUgZGVtYW5kIHNjcnViYmlu
Zw0KZXhwb3NlZCB0byB0aGUgdXNlciB2aWEgdGhlIEVEQUMgc2NydWIgaW50ZXJmYWNlIGFzIGFj
cGlfcmFzX21lbTAvc2NydWIsIGFjcGlfcmFzX21lbTEvc2NydWIsDQphY3BpX3Jhc19tZW0yL3Nj
cnViLCAuLi4gZXRjLiAgIFdoZW4gdGhlIHVzZXJzcGFjZSB0b29sIChGb3IgZS5nLiByYXNkYWVt
b24pICBvciBhbiBhZG1pbiBkZXRlY3RzDQphIGZhdWx0eSBwYWdlIG9yIGZhdWx0eSBhZGRyZXNz
LCBzeXN0ZW0gcG9saWN5IG1heSBkZWNpZGVzIHRvIHNjcnViIHRoZSBjb3JyZXNwb25kaW5nIG1l
bW9yeS4gDQpIb3dldmVyIGl0IGlzIHJlcXVpcmVkIHRvIGZpbmQgb3V0IHRoZSBFREFDIHNjcnVi
IGluc3RhbmNlIG9mICB0aGUgY29ycmVzcG9uZGluZyAgbWVtb3J5IGluIHRoZQ0KTlVNQSBkb21h
aW4sIHNldCBzY3J1YiBwYXJhbWV0ZXJzIGFuZCBpc3N1ZSB0aGUgc2NydWIgcmVxdWVzdC4NClRo
ZXJlIGFyZSB0d28gb3B0aW9ucyBwcmVzZW50LA0KKDEpIFNldCB0aGUgc2NydWIgcGFyYW1ldGVy
cyBhbmQgaXNzdWUgc2NydWIgcmVxdWVzdCBpbiBhbGwgdGhlIEVEQUMgc2NydWIgaW5zdGFuY2Vz
IHByZXNlbnQgZm9yIFJBUzIuIFRoZQ0KIHNjcnViIHJlcXVlc3Qgc2hvdWxkIGZhaWwgZm9yIHRo
ZSBpbnZhbGlkIGNhc2VzLg0KKDIpICBMb2NhdGUgdGhlIGNvcnJlc3BvbmRpbmcgRURBQyBzY3J1
YiBpbnN0YW5jZXMgZm9yIHRoZSBjb3JyZXNwb25kaW5nIE5vZGUgbWVtb3J5DQogICAgICBieSBy
ZWFkIGFuZCBjaGVjayBhZ2FpbnN0IHRoZSBQQSByYW5nZSBwdWJsaXNoZWQuDQoNCkkgdGhpbmsg
T3B0aW9uICgyKSBzZWVtcyBiZXR0ZXI/IA0KSWYgc28sIGNhbiB0aGUgRURBQyBzY3J1YiBpbnRl
cmZhY2UgIGJlIHVwZGF0ZWQgdG8gaW5jbHVkZSBhdHRyaWJ1dGVzIGZvciBwdWJsaXNoaW5nIHRo
ZSBzdXBwb3J0ZWQNClBBIHJhbmdlIGZvciB0aGUgbWVtb3J5IGRldmljZSB0byBzY3J1Yj8NCg0K
Pg0KPj4gPldoYXQgaGFwcGVucyB3aXRoIHRoZSBhdXggZGV2aWNlcyB5b3UgY3JlYXRlZCBzdWNj
ZXNzZnVsbHkgaGVyZT8gVW53aW5kPw0KPj4gUGxlYXNlIHNlZSB0aGUgcHJldmlvdXMgZGlzY3Vz
c2lvbnMgb24gdGhpcyB3ZXJlIGFib3V0IGFsbG93aW5nIHRoZQ0KPj4gc3VjY2Vzc2Z1bGx5IGNy
ZWF0ZWQgYXV4aWxpYXJ5IGRldmljZXMgdG8gZXhpc3QuDQo+PiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvMjAyNTA0MTUyMTA1MDQuR0E4NTQwOThAeWF6LWtoZmYyLmFtZC5jb20vDQo+DQo+
VGhlcmUncyBubyBkaXNjdXNzaW9uIGhlcmUuIEFuZCBub3RoaW5nIGFuc3dlcnMgdGhlIHF1ZXN0
aW9uICJ3aHkiIHRoaXMgaXMgb2sgdG8NCj5kbyB0aGlzIHdheS4NCg0KVGhpcyB3YXMgY2hhbmdl
ZCAgYmFzZWQgb24gdGhlIGZlZWRiYWNrIGZyb20gdGhlIFlhemVuIGluIHYzIG9mIHRoZSBzZXJp
ZXMsDQpDb3B5IG9mIHRoZSBZYXplbidzIGZlZWRiYWNrIGZyb20gdGhlIGFib3ZlIGxpbms6IA0K
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gKwl9DQo+ICsNCj4gKwlwY2NfZGVzY19s
aXN0ID0gKHN0cnVjdCBhY3BpX3JhczJfcGNjX2Rlc2MgKikocmFzMl90YWIgKyAxKTsNCj4gKwlm
b3IgKGkgPSAwOyBpIDwgcmFzMl90YWItPm51bV9wY2NfZGVzY3M7IGkrKywgcGNjX2Rlc2NfbGlz
dCsrKSB7DQo+ICsJCWlmIChwY2NfZGVzY19saXN0LT5mZWF0dXJlX3R5cGUgIT0gUkFTMl9GRUFU
X1RZUEVfTUVNT1JZKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJcmMgPSByYXMyX2FkZF9h
dXhfZGV2aWNlKFJBUzJfTUVNX0RFVl9JRF9OQU1FLCBwY2NfZGVzY19saXN0LT5jaGFubmVsX2lk
KTsNCj4gKwkJaWYgKHJjKQ0KPiArCQkJcmV0dXJuIHJjOw0KDQpUaGlzIHJldHVybnMgZXJyb3Ig
b24gdGhlIGZpcnN0IGZhaWx1cmUuDQoNCldoYXQgaWYgdGhlcmUgd2FzIGEgc3VjY2VzcyBiZWZv
cmU/IERvZXMgdGhhdCBhdXhfZGV2aWNlIG5lZWQgdG8gYmUgcmVtb3ZlZD8NCg0KSWYgbm90LCB0
aGVuIHdoeSByZXR1cm4gZmFpbHVyZSBhdCBhbGw/IFdoeSBub3QganVzdCB0cnkgdG8gYWRkIGFs
bCBkZXZpY2VzPyBTb21lIG1heSBmYWlsIGFuZCBzb21lIG1heSBzdWNjZWVkLg0KPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0gDQoNCldlIHRob3VnaHQgc2Vjb25kIG9wdGlvbiBpcyBhIGJl
dHRlciBiZWNhdXNlIGEgc3VjY2Vzc2Z1bGx5IGFkZGVkIGF1eCBkZXYgZm9yIGEgbWVtb3J5IGRl
dmljZSBhbmQgY29ycmVzcG9uZGluZw0KRURBQyBpbnRlcmZhY2UgY29udGludWUgZXhpc3QgYW5k
IHN1cHBvcnQgdGhlIHNjcnViL2EgbWVtb3J5IGZlYXR1cmUuIA0KV2UgZG8gbm90IG1pbmQgZG9p
bmcgc3RvcCBvbiBhIGZhaWx1cmUgYWRkaW5nIGFuIGF1eF9kZXZpY2UgYW5kIGZyZWUgcHJldmlv
dXNseSBjcmF0ZWQgYXV4IGRldmljZXMsIHRob3VnaA0KaXQgbWF5IHJlcXVpcmUgc29tZSBhZGRp
dGlvbmFsIGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBtZW1vcnkgc3BhY2UgdG8gc3RvcmUgdGhlIHN1
Y2Nlc3NmdWxseSBjcmVhdGVkIGF1eCBkZXZpY2VzDQpzbyB0aGF0IGZyZWUgdGhlbSBvbiBhIGZh
aWx1cmUgbGF0ZXIuIEhvcGUgdGhhdCBpcyBhY2NlcHRhYmxlPw0KDQpUaGFua3MsDQpTaGlqdSAg
DQoNCj4NCj4tLQ0KPlJlZ2FyZHMvR3J1c3MsDQo+ICAgIEJvcmlzLg0KPg0KPmh0dHBzOi8vcGVv
cGxlLmtlcm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQoNCg0KDQo=

