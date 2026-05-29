Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B865CD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 02:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5276B0088; Thu, 28 May 2026 22:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC926B008A; Thu, 28 May 2026 22:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2EB6B008C; Thu, 28 May 2026 22:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1746B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:20:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 456BA9963D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:20:51 +0000 (UTC)
X-FDA: 84818854302.22.97CEB99
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id 937E116000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:20:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780021249; a=rsa-sha256;
	cv=none;
	b=haR7kYxVRLqpdqZqUG6szxtRDUY8kED4FP5ZYHz0D7098rq+MaM1Sgye2RjDbWhdNy9Etd
	1i9JDHcZsDYrIcJuJ5Wg7bRJ0R00ILQJBa2yeqz3Z8VEuJ1Boe5jYHjLKxDaeLaj1PQwxu
	Rvx+n5jfiwkAV0GXf5scSNl8i7LzC9k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780021249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HgwBtAdKYE2GnGta9aukJds6LCwLi+9i8F+GLmwT/ys=;
	b=3Dyut3Mjykk63AUyJWVaWMguP/cO29GVpPVd33RVkBTFHNo2GvxY4c+X/RSub7C7tNAVm+
	YCfvqRcUdU4cPFMKNkXZ9v4qsbF1/g/cuqnrGSjq3dZQ3oD7LbH1YV4yTujaog6dniw+in
	OyVHSl4rOO+6G9+3vlLFrB0A2DY28ho=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gRRr44HZNzYl50B;
	Fri, 29 May 2026 10:19:16 +0800 (CST)
Received: from TA002.hihonor.com (10.77.230.8) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 29 May
 2026 10:20:43 +0800
Received: from TA012-1.hihonor.com (10.77.199.132) by TA002.hihonor.com
 (10.77.230.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 29 May
 2026 10:19:46 +0800
Received: from TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2]) by
 TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2%13]) with mapi id
 15.02.2562.017; Fri, 29 May 2026 10:20:38 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <baohua@kernel.org>
CC: wangtao <tao.wangtao@honor.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
	"luizcap@redhat.com" <luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn"
	<xu.xin16@zte.com.cn>, Lorenzo Stoakes <ljs@kernel.org>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com"
	<dvander@google.com>, zhangji <zhangji1@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjxgd4lPMhqtEmw5NAzzRRKBbYhaeaAgAEjsICAAATQAIABAA8AgACyWNA=
Date: Fri, 29 May 2026 02:20:38 +0000
Message-ID: <3f7112ea7bc0409885f0fb0b4d09561e@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 937E116000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 6pw3fk13ugcoy7asn35ktjyk4x7fekkt
X-HE-Tag: 1780021248-341152
X-HE-Meta: U2FsdGVkX18b3SyIPOdli4MvpsVNw2cSFQf5Gn9zvu0F+ugbYCBPQ+7quDf36aGdL99LXuCIy/LW5ZZwPmHgMB0VDq6WmGmY5iHLpQuybN5CZ1JwbvpoJoiDfpCFoDWGNVBiKlGuGM0gNY3c03GOcyji6ocd2gqBAIzKhZtNWt7IPpRf/0wHo4c8ZVHE5RrKxUiZDRl6pcrd5BnQ6Tjnf/l+qwmhpMLz8Zf0eZCFVHOffv6/bP5aeqfcY/6jXBtDR7krMQgpu5H5QXi9eDQh4Cdgpry69HwCEMfyfjUZLTjsobb7uePJZWQh2Wf/xEIZCBCcBMXn+SQKbTw/HDV3bFsOJOCDcPjBE0zBIC0TSIQ+j9qx45fcPW2XwK1mI8aS0/kcy/nf0Z6iU0qM52I3xYSZjSHXIABPzeZNIB6Uqg7ROERKdeexKsapBMsQNU5/B3R+2o+BQ4naGVXvd53R3eWnnqJp5rZXRjMzks+mDb3aH3i47fkYrrGf8pZcds8iUI5irDpbYdnJSfw+iKvGvaMzkp6TIGEgLsfnSHRaEM1BQ9qDxnwuP8ntsfjmTVei9Ha0GK/qWSNGb3wOmtSxPzvW/1BPsrWR2Zb7V4ETT7wY7U+ZMSKnYeEyKH6KUmG2P+L9bWb2Y3AaWb3zM4Meb/y9PvFUcMCLGFYcQF1jaexdpC3sURvuRSK5+g06rqr6sD48JRzI9VWTJa73hApwfAj8uT2m0QXBMCUKZ87P3M4r1nkxT6ilDV4rBJ+SgQCcpReIF2DOn3no6iYq92rXNJjjCJAq2HJgj+LsyYPmGnKvKKBHL4JBP3ruVSk353GfBdrPDdBswY4zlgxfQ30VxvHvMVnOLrHE3gUaF4Ml2j+sjUXwRjorzX39BEwVwhw5aE0bq361c1rq1Bd/t3tDjJO2Acq1G2UWhoEfr2zpMZ18p/46ZflYTdNqgoWZQ9g9+SZNUETNN0oJ2PoAZYs
 7feFCIFy
 FlU/USTwHZa7P71HNgTrADcWg4EkYrljNlCAJcMNtMYEtQwCsQ+OOcefJoECApsL6pPB6mMDsTk/qvsKmFfWTv82U5ZbfRWZAvNJNFtaUvWqFQkbs6kmjw0l14zKpZ5620Ev20FBIzemna8KwiH34f1NhYa36H822UR3q4AX1dY1uDnlHL1sBWlGBkKxsnOAGhHeTdMEguh/kqsBNB9XYq3WWSYPUix9oD2VtEaa/h/OcoHLg9ZldkrXQD5Ku3RPLlVwXtSlTAJYQwFwHxgGnjEeQBlqT9PsEUMXYHZ02dfD3qMf0AMMz5k6NrxXeyewXpbf8A5WmthlBn3C2w6sHHvVjkTzwZzbN8B4Vng84UshhXwLllCSwg4Y9vKx79WjIWMhiPdBubPYnbTzKlFAT8FNtXHc+0uqZUAhjX9kqnNFuLNfwwuXcPVzp5n7ngukKYZPdCPCCUTgG6ZeylYGXs2PGqwEmWpq/xZ5oqK6SQXnlEUeUgr8PpItlaethJqPeRy2H0qj+glK7Gu9evRKZlO5xfnXEfbFoJcVftEfAt1kOsrU+dGqNTRRUxBBV+WIEn9FwaOBqVSQNkvSMTBDBZtR9K5ZmZSecQI8JI010tizKhkmgl4HKJTlOyEDhgym6GPuXPopDwsh/fjAojIgvnkdpr+yCdBBqIODY5noWwGkBo5B0iXKKo1loDBnTlpDh8SNaB3fdpCwfF/HYa9kdhU/FzFkTpYh1Fn2kIMLqSaVQja7S7Uw3ZCepuUb+mGNmW68WJ9PvWyaqQhvTUgPigMelnRxLa9ogggbjNWGRXg/Ew4nufPXfRgXkLfy6/JWD4Hgi2kvEzYhwgkkMTHrefBsysQv9Ik9R2MYvQQb4qi7B99eSP7YrjcevzRDg/VEWde2mnxBfHmV14csSq1Mx7As7FAEI+Q1NsvK2HRNzl2eGmuC5H17c8ZpTVecMZc2xk8qi8+XhCfl/AQ18Z2vmiUvUYRIM
 w+d3rSX6
 WbFNpolgYslEXN/MCRSpwSBwQZG6ftrLmweeczXMZu/2OR94joZVwl7XfsyB2kbJROXOtAvGjXUV+Cc4c+xaiJnkpYEz/v1NiuUGO8EkxD9CoXpKBlASIoGMlA7HTGIkhe81qtfaKgQJ+hfpVhA1e51k3VKzaFmrApPDivK7Ycuq1Q/Ox/mr8AgMuIBqh+s20BdR0n1jhfy7nK3B+aEydI24q+WxjWZrMT8DxuLNhO7Hafaw21+kHMcBmrjg9ijcleTOjKYJR26sXL2czt5HINxvKKGlmkpH/nv0Gt2t99moBWP6uyOK7Ca44gAtuuTPE/WVgJNyIHuf2Tt7qWUBOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFycnkgU29uZyA8YmFv
aHVhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgTWF5IDI5LCAyMDI2IDc6MzEgQU0NCj4g
VG86IExvcmVuem8gU3RvYWtlcyA8bGpzQGtlcm5lbC5vcmc+DQo+IENjOiB3YW5ndGFvIDx0YW8u
d2FuZ3Rhb0Bob25vci5jb20+OyBjYXRhbGluLm1hcmluYXNAYXJtLmNvbTsNCj4gd2lsbEBrZXJu
ZWwub3JnOyB0Z2x4QGtlcm5lbC5vcmc7IG1pbmdvQHJlZGhhdC5jb207IGJwQGFsaWVuOC5kZTsN
Cj4gZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyB4ODZAa2VybmVsLm9yZzsgYWtwbUBsaW51
eC1mb3VuZGF0aW9uLm9yZzsNCj4gZGF2aWRAa2VybmVsLm9yZzsgd2lsbHlAaW5mcmFkZWFkLm9y
Zzsgc2pAa2VybmVsLm9yZzsga2Vlc0BrZXJuZWwub3JnOw0KPiBsdWl6Y2FwQHJlZGhhdC5jb207
IHpoYW5namlhbzJAY21zcy5jaGluYW1vYmlsZS5jb207IGthc0BrZXJuZWwub3JnOw0KPiBocGFA
enl0b3IuY29tOyBsaWFtQGluZnJhZGVhZC5vcmc7IHZiYWJrYUBrZXJuZWwub3JnOyBycHB0QGtl
cm5lbC5vcmc7DQo+IHN1cmVuYkBnb29nbGUuY29tOyBtaG9ja29Ac3VzZS5jb207IGphY2tAc3Vz
ZS5jejsgcmllbEBzdXJyaWVsLmNvbTsNCj4gaGFycnlAa2VybmVsLm9yZzsgamFubmhAZ29vZ2xl
LmNvbTsgamdnQHppZXBlLmNhOyBqaHViYmFyZEBudmlkaWEuY29tOw0KPiBwZXRlcnhAcmVkaGF0
LmNvbTsgeml5QG52aWRpYS5jb207IGJhb2xpbi53YW5nQGxpbnV4LmFsaWJhYmEuY29tOw0KPiBu
cGFjaGVAcmVkaGF0LmNvbTsgcnlhbi5yb2JlcnRzQGFybS5jb207IGRldi5qYWluQGFybS5jb207
DQo+IGxhbmNlLnlhbmdAbGludXguZGV2OyB4dS54aW4xNkB6dGUuY29tLmNuOyBjaGVuZ21pbmcu
emhvdUBsaW51eC5kZXY7DQo+IG5hby5ob3JpZ3VjaGlAZ21haWwuY29tOyBtYXR0aGV3LmJyb3N0
QGludGVsLmNvbTsNCj4gam9zaHVhLmhhaG5qeUBnbWFpbC5jb207IHJha2llLmtpbUBzay5jb207
IGJ5dW5nY2h1bEBzay5jb207DQo+IGdvdXJyeUBnb3VycnkubmV0OyB5aW5nLmh1YW5nQGxpbnV4
LmFsaWJhYmEuY29tOyBhcG9wcGxlQG52aWRpYS5jb207DQo+IHBmYWxjYXRvQHN1c2UuZGU7IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gbW1A
a3ZhY2sub3JnOyBkYW1vbkBsaXN0cy5saW51eC5kZXY7IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7
DQo+IHJ5bmNzbkBnbWFpbC5jb207IGpwYXJzYW5hQGdvb2dsZS5jb207IGR2YW5kZXJAZ29vZ2xl
LmNvbTsgemhhbmdqaQ0KPiA8emhhbmdqaTFAaG9ub3IuY29tPjsgd2FuZ3ppY2hlbmcgPHdhbmd6
aWNoZW5nQGhvbm9yLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzE1XSBtbTogaW50cm9k
dWNlIEFOT05fVk1BX0xBWlkgZm9yIGRlZmVycmVkDQo+IGFub25fdm1hIGNyZWF0aW9uDQo+IA0K
PiBPbiBUaHUsIE1heSAyOCwgMjAyNiBhdCA0OjE14oCvUE0gTG9yZW56byBTdG9ha2VzIDxsanNA
a2VybmVsLm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBPbiBUaHUsIE1heSAyOCwgMjAyNiBhdCAwNzo1
NzozMUFNICswMDAwLCB3YW5ndGFvIHdyb3RlOg0KPiA+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENI
IDAvMTVdIG1tOiBpbnRyb2R1Y2UgQU5PTl9WTUFfTEFaWSBmb3INCj4gZGVmZXJyZWQNCj4gPiA+
ID4gYW5vbl92bWEgY3JlYXRpb24NCj4gPiA+ID4NCj4gPiA+ID4gT0sgSSd2ZSBoYWQgYSBsb29r
IHRocm91Z2ggbW9yZSB0aG9yb3VnaGx5IG5vdyBhbmQ6DQo+ID4gPiA+DQo+ID4gPiA+IE5BSyBh
bmQgTkFLIGFueSBhcHByb2FjaCBsaWtlIHRoaXMuDQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+
IE5vdCBvbmx5IGlzIHRoaXMgc3RydWN0dXJhbGx5IGFsbCB3cm9uZywgaXQgZG9lcyBzb21lIGlu
c2FuZSBzdHVmZg0KPiA+ID4gPiAocGlubmluZyBWTUFzIC0gbm8pLCB0aGUgUkNVIHVzYWdlIGlz
IGhpZ2hseSBkdWJpb3VzIGFuZCBJIHN1c3BlY3QNCj4gPiA+ID4geW91J3ZlIGNvbXBsZXRlbHkg
YnJva2VuIHRoZSBhbm9uIHJtYXAgZm9yIHRoaW5ncyBsaWtlIG1pZ3JhdGlvbiwNCj4gPiA+ID4g
b3IgaGF2ZSBhdCBsZWFzdCBhZGRlZCB2ZXJ5IGR1YmlvdXMgZWRnZSBjYXNlcy4NCj4gPiA+ID4N
Cj4gPiA+ID4gWW91J3ZlIGFkZGVkIGluc2FuZSBjb21wbGV4aXR5LCBhbmQgYWxzbyBoYXZlIGZh
aWxlZCB0byBhZGQgZXZlbg0KPiA+ID4gPiBwZXJmdW5jdG9yeSB0ZXN0cywgd2hpY2ggaXMgYWxz
byB0b3RhbGx5IHVuYWNjZXB0YWJsZS4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIGltcGxlbWVudGF0
aW9uIGlzIHdyb25nLCBhbmQgdGhlIGFwcHJvYWNoIGlzIHdyb25nIC0gd2UgZG8gbm90DQo+ID4g
PiA+IHdhbnQgdG8gZXh0ZW5kIG9yIGJ1aWxkIG9uIGFub25fdm1hLiBTbyB0aGlzIGlzIHVubWVy
Z2VhYmxlLCBvciBhbnkNCj4gYXBwcm9hY2ggbGlrZSBpdC4NCj4gPiA+ID4NCj4gPiA+ID4gSSBh
bHNvLCB1bmZvcnR1bmF0ZWx5LCBzdHJvbmdseSBzdXNwZWN0IEFJIGhlcmUuIFRoZSB0dXJuIG9m
DQo+ID4gPiA+IHBocmFzZSwgYW5kIHBvb3IgY29tbWl0IG1lc3NhZ2VzLCB5b3UgZG9pbmcgdGhp
cyBvdXQgb2Ygbm93aGVyZQ0KPiA+ID4gPiB3aXRoIGFic29sdXRlbHkgbm8gcm1hcCBleHBlcmll
bmNlIGJlZm9yZSwgeW91ciB0b3RhbCBsYWNrIG9mDQo+IGNvbW11bmljYXRpb24gYmVmb3JlLg0K
PiA+ID4gPg0KPiA+ID4gPiBDbGF1ZGUgcHV0cyB0aGUgcHJvYmFiaWxpdHkgb2YgaGVhdnkgQUkg
dXNhZ2UgYXQgODUtOTAlLCBhbmQgSSdtDQo+ID4gPiA+IHByZXR0eSBjb252aW5jZWQuIEVpdGhl
ciB3YXkgaXQncyB1dHRlcmx5IHVubWVyZ2VhYmxlIGJ1dCB0aGF0IHlvdQ0KPiA+ID4gPiAobGlr
ZWx5KSB1c2VkIEFJIHRvIGdlbmVyYXRlIHRoaXMgbXVjaCB3b3JrIGZvciB1cyBtYWtlcyBtZSBh
Y3R1YWxseQ0KPiBwcmV0dHkgYW5ub3llZC4NCj4gPiA+ID4NCj4gPiA+ID4gQXMgYSByZXN1bHQs
IEkgd291bGQgc3Ryb25nbHkgc3VnZ2VzdCB5b3Ugbm8gbG9uZ2VyIHN1Ym1pdCBwYXRjaGVzDQo+
ID4gPiA+IGZvciB0aGUgcmV2ZXJzZSBtYXBwaW5nIHBhcnQgb2YgbW0sIGFzIHRoZXJlIGlzIG5v
dyBhIHJlYWwgbGFjayBvZiB0cnVzdC4NCj4gPiA+ID4NCj4gPiA+ID4gSWYgeW91IHdpc2ggdG8g
cmVidWlsZCB0aGF0LCBJIHN1Z2dlc3QgeW91IF9kaXNjdXNzXyBjb25jZXB0cyBhbmQgaWRlYXMs
DQo+IGUuZy4NCj4gPiA+ID4gc2VuZCBzdHVmZiBvbi1saXN0IHdpdGggYSBbRElTQ1VTU0lPTl0g
dGFnLCBhbmQgZW5nYWdlIHdpdGggdGhlDQo+ID4gPiA+IGNvbW11bml0eSwgYW5kIGdvIGZyb20g
dGhlcmUuDQo+ID4gPiA+DQo+ID4gPiA+IEl0J3MgYWxzbyBpbXBvcnRhbnQgdG8gc3luY2hyb25p
c2UgLSBJJ20gd29ya2luZyBvbiBhbiBhbm9uIHJtYXANCj4gPiA+ID4gcmVwbGFjZW1lbnQgdGhh
dCBJJ20gbW9yZSB0aGFuIGhhcHB5IHRvIGRpc2N1c3Mgd2l0aCB5b3Ugb3INCj4gPiA+ID4gYW55
Ym9keSBlbHNlIHdoaWNoIHNob3VsZCBhY2hpZXZlIHRoZSBzYW1lIG51bWJlcnMgaW4gYW4NCj4g
YXJjaGl0ZWN0dXJhbGx5IHNvdW5kIHdheS4NCj4gPiA+ID4NCj4gPiA+ID4gWW91IGdvaW5nIG9m
ZiBhbmQsIGluIGEgdmFjdXVtLCBnZW5lcmF0aW5nIGEgYnVuY2ggb2YgY29kZSB3aXRoIGFuDQo+
ID4gPiA+IHVuYWNjZXB0YWJsZSBhcHByb2FjaCBpcyBub3QgYSBjaXZpbCB3YXkgb2YgZW5nYWdp
bmcgbm9yIGlzIGl0IGENCj4gPiA+ID4gZ29vZCB1c2Ugb2YgeW91ciB0aW1lLCBvciBtYWludGFp
bmVyIHRpbWUgbG9va2luZyBhdCBpdC4NCj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtzLCBMb3Jlbnpv
DQo+ID4gPg0KPiA+ID4gWW91ciBlbWFpbCBpcyB2ZXJ5IHVuZnJpZW5kbHkuIEkgaG9wZSB5b3Ug
Y2FuIHBvaW50IG91dCB0aGUgc3BlY2lmaWMNCj4gPiA+IHByb2JsZW1zIHNvIHdlIGNhbiBkaXNj
dXNzIGhvdyB0byBzb2x2ZSB0aGVtLg0KPiANCj4gSGkgVGFvLA0KPiANCj4gTG9yZW56byBoYWQg
YSBkaXNjdXNzaW9uIGFib3V0IHJtYXAgaW4gWmFncmViIGhlcmU6DQo+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xpbnV4LW1tL2FlYzUzM2IyLTM3YTctNGY0NC1hMjc5LQ0KPiBjNGFhNjA0MjA2
YWNAbHVjaWZlci5sb2NhbC8NCj4gDQo+IEhlIGFsc28gc2hhcmVkIHRoZSBQb0MgY29kZSBoZXJl
Og0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9sanMv
bGludXguZ2l0L2xvZy8/aD1wcm9qZWN0Lw0KPiBjb3ctY29udGV4dA0KPiANCj4gYW5kIHRoZSBz
bGlkZXMgd2VyZSBzaGFyZWQgYXMgd2VsbC4gSW4gY2FzZSB5b3UgY2FuJ3QgZmluZCB0aGVtIG9u
IGxpbnV4LW1tIChJDQo+IGFjdHVhbGx5IGNvdWxkbid0IGZpbmQgdGhlbSBteXNlbGYpLCBJIGFt
IGF0dGFjaGluZyB0aGVtIGFnYWluIGhlcmUgLQ0KPiAic2NhbGFibGUtY293LWxzZi1sb25nZXIt
dmVyc2lvbi5wZGYiDQo+IA0KPiBBZnRlciBjb21pbmcgYmFjayBmcm9tIFphZ3JlYiwgSSBrZXB0
IHRyeWluZyB0byBmaW5kIG9uZSBvciB0d28gZnVsbCBkYXlzIHRvDQo+IHJlYWQgTG9yZW56bydz
IGNvZGUgYW5kIHNsaWRlcyBjYXJlZnVsbHkgYW5kIHdyaXRlIGEgYmxvZyBhYm91dCB0aGVtLg0K
PiBVbmZvcnR1bmF0ZWx5LCBJIGhhdmUgYmVlbiBjb21wbGV0ZWx5IGJ1c3kgd2l0aCBvdGhlciB3
b3JrLiBTaWdoLi4uIHdlDQo+IGFsd2F5cyBzZWVtIHRvIGhhdmUgdG9vIG1hbnkgbm9uLXVwc3Ry
ZWFtIHRhc2tzLg0KPiANCj4gSWYgcG9zc2libGUsIEknZCByZWFsbHkgYXBwcmVjaWF0ZSBpdCBp
ZiB5b3UgY291bGQgdGFrZSBhIGRlZXAgZGl2ZSBpbnRvIGl0IGFuZA0KPiB3cml0ZSBhIGRldGFp
bGVkIGJsb2cgcG9zdC4gSSdkIGJlIHZlcnkgZWFnZXIgdG8gcmVhZCBpdCBhbmQgYmV0dGVyIHVu
ZGVyc3RhbmQNCj4gdGhlIG92ZXJhbGwgZGVzaWduLg0KPiBPdGhlcndpc2UsIEknbGwgdHJ5IHRv
IGZpbmQgc29tZSB0aW1lIG5leHQgd2VlayBvciBsYXRlciB0byBnbyB0aHJvdWdoIGl0DQo+IG15
c2VsZi4NCj4gDQpIaSBCYXJyeSwNCg0KVGhhbmsgeW91IGZvciB5b3VyIGd1aWRhbmNlLCBpdCBp
cyB2ZXJ5IG11Y2ggYXBwcmVjaWF0ZWQuDQoNCkkgd29yayB3aXRoIFRhbyBhdCBIb25vci4gVGhl
IG1vdGl2YXRpb24gYmVoaW5kIHRoaXMgd29yayBpcyBnZW51aW5lIGFuZCBwcmFjdGljYWwuDQpU
aGUgbWVtb3J5IGNvc3QgaGFzIGluY3JlYXNlZCBzaWduaWZpY2FudGx5LCBhbmQgd2UgaGF2ZSBz
cGVudCByZWFsIGVmZm9ydCBpbnZlc3RpZ2F0aW5nDQphbmQgcHJvdG90eXBpbmcgc29sdXRpb25z
IHRvIHJlZHVjZSBpdC4NCg0KV2UncmUgaGFwcHkgdG8gam9pbiAiY29uc3RydWN0aXZlIiBkaXNj
dXNzaW9ucyBhbmQgbGVhcm4gZnJvbSB0aGUgY29tbXVuaXR5Lg0KDQpUaGFua3MsDQpaaWNoZW5n
DQoNCj4gPg0KPiA+IEkgYWxyZWFkeSBkaWQsIHlvdSd2ZSBub3QgcmVzcG9uZGVkIHRvIGFueSBv
ZiB0aGVtLCBhbmQgSSdtIHNpbXBseSBub3QNCj4gPiBzcGVuZGluZyBhbnkgbW9yZSB0aW1lIG9u
IHRoaXMuDQo+ID4NCj4gPiBUaGUgc2VyaWVzIGlzIHRvdGFsbHkgdW5tZXJnZWFibGUsIHBsZWFz
ZSBkbyBub3QgbWFrZSBmdXJ0aGVyIHJtYXANCj4gPiBzdWJtaXNzaW9ucy4NCj4gPg0KPiA+ID4N
Cj4gPiA+IEkgYW0gbm90IGdvb2QgYXQgRW5nbGlzaCBhbmQgbmVlZCB0byB1c2UgQUkgdG8gdHJh
bnNsYXRlIGNvbW1pdA0KPiA+ID4gbWVzc2FnZXMgYW5kIGNvbW1lbnRzLiBUaGlzIHJlcGx5IGVt
YWlsIGlzIGFsc28gdHJhbnNsYXRlZCB3aXRoIEFJLg0KPiA+ID4gSG93ZXZlciwgdGhlIGNvZGUg
aXMgd3JpdHRlbiBieSBtZS4gSSBkbyBub3Qga25vdyB3aGljaCBBSSB5b3UgYXJlDQo+ID4gPiBy
ZWZlcnJpbmcgdG8sIGJ1dCB0aGUgQUkgdG9vbHMgSSB1c2UgY3VycmVudGx5IGNhbm5vdCBlZmZl
Y3RpdmVseQ0KPiA+ID4gd3JpdGUga2VybmVsIGNvZGUuDQo+ID4gPg0KPiA+DQo+ID4gV2UncmUg
ZmluZSB3aXRoIHVzaW5nIEFJIGZvciBsYW5ndWFnZSwgb3IgaW4gZ2VuZXJhbCBhcyBsb25nIGFz
DQo+ID4gdGhlcmUncyBhIGNsZWFyIHVuZGVyc3RhbmRpbmcgb2Ygd2hhdCdzIGJlaW5nIHN1Ym1p
dHRlZC4NCj4gPg0KPiA+IEhvd2V2ZXIgSSdtIHZlcnkgdW5jb252aW5jZWQgdGhhdCB0aGlzIHNl
cmllcyB3YXNuJ3QgZ2VuZXJhdGVkLg0KPiA+DQo+ID4gWW91IGhhdmUgMiBwYXRjaGVzIGluIHRo
ZSBrZXJuZWwgZm9yIHRoZSBlbnRpcmV0eSBvZiAyMDI2LiBPbmUgaW4NCj4gPiBibHVldG9vdGgg
YW5kIG9uZSBpbiB0aGUgc2NoZWR1bGVyLg0KPiA+DQo+ID4gUHJpb3IgdG8gdGhhdCB5b3UgaGF2
ZSBwYXRjaGVzIGZyb20gMjAxOCBpbiBkZXZpY2UgdHJlZSBkcml2ZXJzLg0KPiA+DQo+ID4gWW91
IGhhdmUgZXhhY3RseSAwIGNvbnRyaWJ1dGlvbnMgdG8gbW0uDQo+ID4NCj4gPiBPdXQgb2Ygbm93
aGVyZSB0aGlzIHllYXIgeW91IGhhdmUgYSBiaWcgc2VyaWVzIGZvciBETUEsIHRoaXMgc2VyaWVz
DQo+ID4gZm9yIGFub25fdm1hLCBoYXZpbmcgZG9uZSBubyB3b3JrIG9yIGFueSBjb250cmlidXRp
b25zIHRvIHJtYXAsIGxldA0KPiA+IGFsb25lIG9uZSBvZiB0aGUgdHJpY2tpZXN0IGFuZCBtb3N0
IGNvbXBsaWNhdGVkIGFyZWFzIG9mIG1tLg0KPiA+DQo+ID4gWW91IGhhdmUgYSB0b3RhbCBvZiAz
OSBtYWlscyBvbiB0aGUgbGludXgtbW0gbWFpbGluZyBsaXN0Lg0KPiA+DQo+ID4gU3VkZGVubHkg
ZG9pbmcgYSBnaWFudCBiaXQgb2Ygd29yayBsaWtlIHRoaXMgdXNpbmcgY29kZSB0aGF0IGxvb2tz
DQo+ID4gZW50aXJlbHkgbGlrZSBpdCdzIEFJLWdlbmVyYXRlZCwgYW5kIHdoaWNoIGFmdGVyIGFz
c2Vzc21lbnQgYnkgQUkNCj4gPiBnaXZlcyBhbiA4NS05MCUgcHJvYmFiaWxpdHkgb2YgQUkgZ2Vu
ZXJhdGlvbiBpcyByZWFsbHkgc3VzcGljaW91cy4NCj4gPg0KPiA+IE5vdywgaWYgSSdtIG1pc3Rh
a2VuLCBhbmQgeW91IGhhdmUgYSBkaWZmZXJlbnQgbmFtZS9lbWFpbC9pZGVudGl0eSBJDQo+ID4g
bWlzc2VkIHdpdGggbWFueSBtbSBjb250cmlidXRlcyAtIEkgd2lsbCBlYXQgbXkgd29yZHMgaGVy
ZSAodGhlIHNlcmllcw0KPiA+IGlzIHN0aWxsIHVubWVyZ2VhYmxlIGVpdGhlciB3YXkgdGhvdWdo
KS4NCj4gPg0KPiA+IFNvIHNvcnJ5LCB0aGVyZSdzIHNpbXBseSBubyB0cnVzdCBhbmQgYXMgYSBt
YWludGFpbmVyIG9mIHJtYXAgYWdhaW4gSQ0KPiA+IG11c3Qgc3Ryb25nbHkgc3VnZ2VzdCB0aGF0
IHlvdSBubyBsb25nZXIgc3VibWl0IHBhdGNoZXMgZm9yIHRoaXMgcGFydA0KPiA+IG9mIHRoZSBr
ZXJuZWwuDQo+ID4NCj4gPiBJZiB5b3Ugd2lzaCB0byBidWlsZCB0cnVzdCB1cCBhZ2FpbiwgYmVn
aW4gd2l0aCBkaXNjdXNzaW9ucywgYW5kIG1heWJlDQo+ID4gdHJ5IHNvbWUgc21hbGxlciBwYXRj
aGVzIGluIG1tIHRvIGRlbW9uc3RyYXRlIHRoYXQgeW91J3JlIGdlbnVpbmVseQ0KPiA+IGFjdGlu
ZyBpbiBnb29kIGZhaXRoPw0KPiANCj4gSGkgTG9yZW56bywNCj4gDQo+IEkgdHJ1bHkgYmVsaWV2
ZSBUYW8gaXMgYWN0aW5nIHdpdGggZ29vZCBpbnRlbnRpb25zLCBhbHRob3VnaCB0aGUgd2F5IHRo
aXMgaXMNCj4gYmVpbmcgZG9uZSBpcyBxdWl0ZSBtZXNzeS4NCj4gDQo+IE1lbW9yeSBjb3N0cyBh
cmUgaW5jcmVhc2luZyBzaWduaWZpY2FudGx5IHRoZXNlIGRheXMsIGFuZCBhcyBJIHVuZGVyc3Rh
bmQgdGhlDQo+IHBhdGNoc2V0LCBoZSBpcyB0cnlpbmcgdG8gc2F2ZSBtZW1vcnkuDQo+IA0KPiBI
b3dldmVyLCBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYmVpbmcgZG9uZSBhdCB0aGUgcmlnaHQgdGlt
ZSBvciBpbiB0aGUgcmlnaHQgd2F5Lg0KPiBUaGlzIG1heSBhbHNvIGJlIGR1ZSB0byBjdWx0dXJh
bCBkaWZmZXJlbmNlcywgbGFuZ3VhZ2UgYmFycmllcnMsIGluZm9ybWF0aW9uDQo+IGdhcHMsIGFu
ZCBhIGxhY2sgb2YgZmFtaWxpYXJpdHkgd2l0aCB0aGUgbW0gY29tbXVuaXR5Lg0KPiBBcyBhIG5v
bi1uYXRpdmUgc3BlYWtlciwgSSBjYW4gc2VlIGhvdyBkaWZmaWN1bHQgdGhpcyBjYW4gc29tZXRp
bWVzIGJlLg0KPiANCj4gSSB3b3VsZCByZWFsbHkgYXNrIHlvdSB0byBnaXZlIFRhbyBtb3JlIGNo
YW5jZXMgdG8gYnVpbGQgdHJ1c3Qgc3RlcCBieSBzdGVwLg0KPiANCj4gQmVzdCBSZWdhcmRzDQo+
IEJhcnJ5DQo=

