Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D322C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 12:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5CC8E0048; Mon, 11 Aug 2025 08:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197368E0045; Mon, 11 Aug 2025 08:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F458E0048; Mon, 11 Aug 2025 08:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E048A8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:07:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CF4356128
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:07:18 +0000 (UTC)
X-FDA: 83764351356.17.E7F729D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06C5D1C000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:07:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754914036; a=rsa-sha256;
	cv=none;
	b=fhWliyXOFqTuGx4QhAPJpu27ck02ghKKN/u6VYjk25yBpSun86nu9DWgga5etOOKcVlxvw
	+J1v3/H0NT00ftSdclHv2je7ITh4glNLFYxNakG/ARCrr/tRxdqV+utHZbUvusu2pwWFsf
	ZJ8wjHZpjkVMKoMgaspKjoxfpE+THa4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754914036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqp4g8PBwdllV4PZWAKBQMUJmUXq0Cg5ES7vM7DO6do=;
	b=pbyhtr1ml1PPKanotSjGUCz6GOjUgKloVSuHjYRYSZCCIZu8/jdNW/d7VRnjaQCKu498NS
	cyJRfXLEQrVFqTEMv0CBKIDCSf4LvNCrcO33jML6ETVKNrotxGBCH+e0atT2xjEQ6d/AaB
	ueZ8nYAf31D7/xE4UsMnYhrSVVgroXc=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c0tcX2G8Gz6M5B5;
	Mon, 11 Aug 2025 20:05:16 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AE771402EF;
	Mon, 11 Aug 2025 20:07:11 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Aug 2025 14:07:10 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Mon, 11 Aug 2025 14:07:10 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Daniel Ferguson <danielf@os.amperecomputing.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "dferguson@amperecomputing.com"
	<dferguson@amperecomputing.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, Linuxarm
	<linuxarm@huawei.com>, "rientjes@google.com" <rientjes@google.com>,
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
Subject: RE: [PATCH v10 0/3] ACPI: Add support for ACPI RAS2 feature table
Thread-Topic: [PATCH v10 0/3] ACPI: Add support for ACPI RAS2 feature table
Thread-Index: AQHcAwinKRrxBWXHdEeoASnw0C4ZhbRY3msAgASKiRA=
Date: Mon, 11 Aug 2025 12:07:10 +0000
Message-ID: <5813d5ff1a874899bb0a972e1e761fc8@huawei.com>
References: <20250801172040.2175-1-shiju.jose@huawei.com>
 <f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com>
In-Reply-To: <f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.146.213]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06C5D1C000E
X-Stat-Signature: 7ntr35jhztmnxcgp64zqfaxhk4nr5okf
X-Rspam-User: 
X-HE-Tag: 1754914035-340195
X-HE-Meta: U2FsdGVkX1/+TefGQbNPoF91PbsOQjjqon+//Wkxh5bVi2BK9N9CLB2MgH827hATm7U26Y/HalIu+K+rEEyjdX8z0TM/IUN8eJpt8gTuQwQf3vCRdS5WyVWd+7HiOsv7dJQ6/SZBZ2vOgxT0WFUzLMw9FuFhoG78yeefwbfis2Tt7A3EUcwI3dK0UMHT38c/iwSDzJCDxDRui4Q+0Ox1n/+tdFRLRm41MFrcL2JL2kskHYX7UGjugPBniv2I8qwkKam1wHo+aPGQBTBhV44vOolYPnKDGAIHDcHoNBpO0UEsPxXrm0h4Nv2W8/On1RrpJGFEO8L3dM/CLM/2kYg575AcsOj3AuKmyXfBlHisH5EKDRH0p1AoN5uj0rzigG6iZ2HcXDN/1xX+sMVucU6xJrXEQJx5CVogPphwY1IEJaowuiaGKuqwNke4J8eU0y1rZKrJh3Y3UAhEp1MfbEwWDWer7ET/9jwydkaWY8a2je/i3EjOzGgMKP4TD0Uqem23g2s+wTZRDYNKD/3pLtIG7S8bW0/SA30GdwbpLBUst6Rw0lOWinc7i6g1TWiUYRCoe5wJO1hziRaLWW/M3ekKUwOg7lb7htUKhSY376/szBEkLfXMl+HIV8U7hIpBbcnLhcuMDLjgRIu2erp1hO3dgavlE9IrAIyT+IRzblj1YOVJUzxYOvoaOC4eSwW2cWwZmm0uQXC1yZHNlCI07Jz5UH+2RgICATxUfYtKLeRB2768vRUsZYBxcYB+jVQnEvy6wYKSy3rBrQjPIZ57wHnRerJSuZEA7+CZEfkc40c0YHvaaH6k6hw6nYNmA9nE+rGF2XrzmbZszEn1E0/zORYAnYF+A+1LT8BaeOEPs7Cfv5o6+m6dXNNwBwQUqm2ZW1IM0BA2o/Q0AuVm1b/f3EpBbin0vYlzA9pNjtI80mIsXnMK4GH9To5pB3ik961yZXYdesKxeO5SKPfVh/y5t6R
 VPfOfEpr
 yQkGTSiiReQNc4W3vz5ECNoCCuKa++gC0g6qKsa/4d/9+k+ojBkpp8OFd7ZZAPkv5TyKnZ1mIxycnQ8x8Q4Vljkl5ixE3c1ED2mnmGrLZCjbvgcYiOj6Rq0+Y3RLPbObE7RUA38TpNwQowLKFqZQEfqlxpERkogbDhyjCC2KSS6Ml1fJDH+VkXPmxbUPsaq9X7ph/TnxZdLRQ2manr1+Uur+sdcYGFAkK5Ep/paXZBZuyb9+Pjm0H85Le3tMd5iPRTX6OR/X8Rh7dSYx4ESJ8A+g78LXdPHz7BYTEwboXHr5Azt5sVcj095b/o5TyPy8gyzFTQjr1o0Armq8f0UUS3+4h1/zUhIqbrwxS+aD6TELeiJaDDlAVC0sA86hjohY7Q9zs1ETmJZyjB13VDzbn0Hk9YV1IXy5hCrIQF/1B504ujCPf51TcZFbfNYtS57hTmaJ5NTeSdhXLN4RJ7+Eak4mecaTr/6hLt5TeFrMHa3c6+7tsaqs4CzGmAo5T7uOBa5vJE5gm4NzO9Nudt79bIsneoixJbcqoFKYotZ5SdR/bHwBdp436vqX9PFWO/LSLjJZG/DXcjzmVL1vsRoYlOtKml4h+z+oWmd/ndxtZpU8MbCh+Xj75q3QyvRFvtVC+9nPPDCsBZLkUQZVvZko/wjkbJKFKzM2xgN1lbWsC3zWvoyt1ymT+NerdgjdvS0Ti18YPB0B90NN/KehA3JTVlYtlnHHc6EAwxBiacM9lHy1hQDEkP1PURFu8tccxEKm20NeUKeLQRYdtkXMUyLJsfix/9Hxky+dnACapiozeoHdzQii+kEFqjVIt1Yz2wfm1/GY79DCPUgptov5nOg13o4DpXyo9afj4vDCoLE1OfwqPPiZRCbwf0BqG18gjQojybS24LqSsvoEsCH6TaIc2Kfc2dgELuHb37e5kyP54B/BRfuSKh7igyHTjyRMTui/p7zfH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogRGFuaWVsIEZlcmd1c29uIDxkYW5p
ZWxmQG9zLmFtcGVyZWNvbXB1dGluZy5jb20+DQo+U2VudDogMDggQXVndXN0IDIwMjUgMTc6MzkN
Cj5UbzogU2hpanUgSm9zZSA8c2hpanUuam9zZUBodWF3ZWkuY29tPjsgcmFmYWVsQGtlcm5lbC5v
cmc7IGJwQGFsaWVuOC5kZTsNCj5ha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyBycHB0QGtlcm5l
bC5vcmc7DQo+ZGZlcmd1c29uQGFtcGVyZWNvbXB1dGluZy5jb207IGxpbnV4LWVkYWNAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC0NCj5hY3BpQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2su
b3JnOyBsaW51eC1kb2NAdmdlci5rZXJuZWwub3JnOw0KPnRvbnkubHVja0BpbnRlbC5jb207IGxl
bmJAa2VybmVsLm9yZzsgbGVvLmR1cmFuQGFtZC5jb207DQo+WWF6ZW4uR2hhbm5hbUBhbWQuY29t
OyBtY2hlaGFiQGtlcm5lbC5vcmcNCj5DYzogSm9uYXRoYW4gQ2FtZXJvbiA8am9uYXRoYW4uY2Ft
ZXJvbkBodWF3ZWkuY29tPjsgTGludXhhcm0NCj48bGludXhhcm1AaHVhd2VpLmNvbT47IHJpZW50
amVzQGdvb2dsZS5jb207IGppYXFpeWFuQGdvb2dsZS5jb207DQo+Sm9uLkdyaW1tQGFtZC5jb207
IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsNCj5uYW95YS5ob3JpZ3VjaGlAbmVjLmNvbTsg
amFtZXMubW9yc2VAYXJtLmNvbTsganRob3VnaHRvbkBnb29nbGUuY29tOw0KPnNvbWFzdW5kYXJh
bS5hQGhwZS5jb207IGVyZGVtYWt0YXNAZ29vZ2xlLmNvbTsgcGdvbmRhQGdvb2dsZS5jb207DQo+
ZHVlbndlbkBnb29nbGUuY29tOyBndGhlbGVuQGdvb2dsZS5jb207DQo+d3NjaHdhcnR6QGFtcGVy
ZWNvbXB1dGluZy5jb207IHdic0Bvcy5hbXBlcmVjb21wdXRpbmcuY29tOw0KPm5pZmFuLmN4bEBn
bWFpbC5jb207IHRhbnhpYW9mZWkgPHRhbnhpYW9mZWlAaHVhd2VpLmNvbT47IFplbmd0YW8gKEIp
DQo+PHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fz
c3VAaHVhd2VpLmNvbT47DQo+a2FuZ2thbmcuc2hlbkBmdXR1cmV3ZWkuY29tOyB3YW5naHVpcWlh
bmcgPHdhbmdodWlxaWFuZ0BodWF3ZWkuY29tPg0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEwIDAv
M10gQUNQSTogQWRkIHN1cHBvcnQgZm9yIEFDUEkgUkFTMiBmZWF0dXJlIHRhYmxlDQo+DQo+PiBD
aGFuZ2VzDQo+PiA9PT09PT09DQo+PiB2OSAtPiB2MTA6DQo+PiAxLiBVc2UgcGNjX2NoYW4tPnNo
bWVtIGluc3RlYWQgb2YNCj4+ICAgIGFjcGlfb3NfaW9yZW1hcChwY2NfY2hhbi0+c2htZW1fYmFz
ZV9hZGRyLC4uLikgYXMgaXQgd2FzDQo+PiAgICBhY3BpX29zX2lvcmVtYXAgaW50ZXJuYWxseSBi
eSB0aGUgUENDIGRyaXZlciB0byBwY2NfY2hhbi0+c2htZW0uDQo+Pg0KPj4gMi4gQ2hhbmdlcyBy
ZXF1aXJlZCBmb3IgdGhlIEFtcGVyZSBDb21wdXRpbmcgc3lzdGVtIHdoZXJlIHVzZXMgYSBzaW5n
bGUNCj4+ICAgIFBDQyBjaGFubmVsIGZvciBSQVMyIG1lbW9yeSBmZWF0dXJlcyBhY3Jvc3MgYWxs
IE5VTUEgZG9tYWlucy4gQmFzZWQgb24NCj50aGUNCj4+ICAgIHJlcXVpcmVtZW50cyBmcm9tIGJ5
IERhbmllbCBvbiBWOQ0KPj4gICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzU0N2VkOGZi
LWQ2YjctNGI2Yi1hMzhiLQ0KPmJmMTMyMjM5NzFiMUBvcy5hbXBlcmVjb21wdXRpbmcuY29tLw0K
Pj4gICAgYW5kIGRpc2N1c3Npb24gd2l0aCBKb25hdGhhbi4NCj4+IDIuMSBBZGQgbm9kZV90b19y
YW5nZSBsb29rdXAgZmFjaWxpdHkgdG8gbnVtYV9tZW1ibGtzLiBUaGlzIGlzIHRvIHJldHJpZXZl
DQo+dGhlIGxvd2VzdA0KPj4gICAgIHBoeXNpY2FsIGNvbnRpbnVvdXMgbWVtb3J5IHJhbmdlIG9m
IHRoZSBtZW1vcnkgYXNzb2NpYXRlZCB3aXRoIGEgTlVNQQ0KPmRvbWFpbi4NCj4+IDIuMi4gU2V0
IHJlcXVlc3RlZCBhZGRyIHJhbmdlIHRvIHRoZSBtZW1vcnkgcmVnaW9uJ3MgYmFzZSBhZGRyIGFu
ZCBzaXplDQo+PiAgICB3aGlsZSBzZW5kIFJBUzIgY21kIEdFVF9QQVRST0xfUEFSQU1FVEVSDQo+
PiAgICBpbiBmdW5jdGlvbnMgcmFzMl91cGRhdGVfcGF0cm9sX3NjcnViX3BhcmFtc19jYWNoZSgp
ICYNCj4+ICAgIHJhczJfZ2V0X3BhdHJvbF9zY3J1Yl9ydW5uaW5nKCkuDQo+PiAyLjMuIFNwbGl0
IHN0cnVjdCByYXMyX21lbV9jdHggaW50byBzdHJ1Y3QgcmFzMl9tZW1fY3R4X2hkciBhbmQgc3Ry
dWN0DQo+cmFzMl9weG1fZG9tYWluDQo+PiAgICB0byBzdXBwb3J0IGNhc2VzLCB1c2VzIGEgc2lu
Z2xlIFBDQyBjaGFubmVsIGZvciBSQVMyIHNjcnViYmVycyBhY3Jvc3MgYWxsDQo+TlVNQQ0KPj4g
ICAgZG9tYWlucyBhbmQgUENDIGNoYW5uZWwgcGVyIFJBUzIgc2NydWIgaW5zdGFuY2UuIFByb3Zp
ZGVkIEFDUEkgc3BlYw0KPmRlZmluZSBzaW5nbGUNCj4+ICAgIG1lbW9yeSBzY3J1YiBwZXIgTlVN
QSBkb21haW4uDQo+PiAyLjQuIEVEQUMgZmVhdHVyZSBzeXNmcyBmb2xkZXIgZm9yIFJBUzIgY2hh
bmdlZCBmcm9tICJhY3BpX3Jhc19tZW1YIiB0bw0KPiJhY3BpX3Jhc19tZW1faWRYIg0KPj4gICAg
YmVjYXVzZSBtZW1vcnkgc2NydWIgaW5zdGFuY2VzIGFjcm9zcyBhbGwgTlVNQSBkb21haW5zIHdv
dWxkIHByZXNlbnQNCj51bmRlcg0KPj4gICAgImFjcGlfcmFzX21lbV9pZDAiIHdoZW4gYSBzeXN0
ZW0gdXNlcyBhIHNpbmdsZSBQQ0MgY2hhbm5lbCBmb3IgUkFTMg0KPnNjcnViYmVycyBhY3Jvc3MN
Cj4+ICAgIGFsbCBOVU1BIGRvbWFpbnMgZXRjLg0KPj4gMi41LiBSZW1vdmVkIEFja2VkLWJ5OiBS
YWZhZWwgZnJvbSBwYXRjaCBbMl0sIGJlY2F1c2Ugb2YgdGhlIHNldmVyYWwgYWJvdmUNCj5jaGFu
Z2VzIGZyb20gdjkuDQo+DQo+QSkgV2UgaGF2ZSB0ZXN0ZWQgdGhlIGNoYW5nZXMgeW91IGhhdmUg
bWFkZSwgYW5kIHRoZXkgd29yay4gVGhhbmsgeW91Lg0KVGhhbmtzIGZvciB2ZXJpZnlpbmcgdGhl
IGNoYW5nZXMuDQo+DQo+QikgSW4gdGhlIGVhcmx5IGRheXMgb2YgdGhpcyBwYXRjaCBzZXJpZXMs
IGFzIHdlIGJlZ2FuIGRldmVsb3Bpbmcgb3VyIGZpcm13YXJlIHRvDQo+a2VlcCBwYWNlIHdpdGgg
eW91ciBkZXZlbG9wbWVudCBvZiB0aGlzIGRyaXZlciwgd2UgaW5kZWVkIG9ubHkgaGFkIG9uZSBQ
Q0MNCj5jaGFubmVsIHNoYXJlZCBhY3Jvc3MgYWxsIHByb3hpbWl0eSBkb21haW5zLiBTaW5jZSB0
aGVuLCB3ZSBoYXZlIGV2b2x2ZWQgb3VyDQo+ZmlybXdhcmUgdG8gaGF2ZSBhIFBDQyBjaGFubmVs
IHBlciBwcm94aW1pdHkgZG9tYWluLiBJdCBkaWRuJ3Qgc2VlbSBpbXBvcnRhbnQNCj50byBtZW50
aW9uIHRoaXMgdG8geW91IHNpbmNlIHRoZSBzdXBwb3J0aW5nIGNvZGUgd2FzIG1pbmltYWwuIEhv
d2V2ZXIsIHdpdGgNCj50aGlzIGxhdGVzdCB1cGRhdGUgKHYxMCksIGl0IGhhcyBiZWNvbWUgYXBw
YXJlbnQgdGhhdCB5b3UgaGF2ZSB0YWtlbiBleHRyYQ0KPmVmZm9ydHMgdG8gcHJlc2VydmUgdGhp
cyBhY2NvbW1vZGF0aW9uLiBTbywgbm93IEknbSBvYmxpZ2VkIHRvIHNheSB0aGF0IHdlIG5vDQo+
bG9uZ2VyIG5lZWQgdGhpcyBhY2NvbW1vZGF0aW9uLiBJZiBpdCB3b3VsZCBoZWxwIG1ha2UgdGhp
bmdzIGNsZWFuZXIsIGFuZA0KPnJlcXVpcmUgbGVzcyBleHBsYW5hdGlvbiwgd2Ugc3VwcG9ydCB0
aGUgcmVtb3ZhbCBvZiB0aGlzIGxlZ2FjeSwgbm9uLWNvbXBsaWFudA0KPmFjY29tbW9kYXRpb24u
DQpUaGFua3MgRGFuaWVsIGZvciBzaGFyaW5nIGluZm9ybWF0aW9uLiBJIHdpbGwgcmVtb3ZlIHdv
cmthcm91bmRzIHByZXZpb3VzbHkgYWRkZWQgZm9yDQpub24tY29tcGxpYW50IGNhc2UgYW5kIHdp
bGwgc2ltcGxpZnkgdGhlIGNvZGUuDQo+DQo+UmVzcGVjdGZ1bGx5LA0KPn5EYW5pZWwNCj4NCj4N
ClRoYW5rcywNClNoaWp1DQo=

