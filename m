Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9968AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBF86B00A2; Tue,  7 Jul 2026 04:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CE36B00A3; Tue,  7 Jul 2026 04:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434FC6B00A6; Tue,  7 Jul 2026 04:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C38B6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:21:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DE151C6945
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:21:35 +0000 (UTC)
X-FDA: 84961286550.11.ADD4AD9
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf31.hostedemail.com (Postfix) with ESMTP id CE3E720003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:21:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Pz4JCC5j;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf31.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qEYw/kORu+CHB2h/1PvcuGa9W8zXV/BEp8uiX+ijrc=;
	b=mbPplWt5ByPsOuwd7jYDkWNW69TO8gToNjHSBbC0hV0DKZkHkJyYJBr/lY7EZroBpDiGxb
	a4/y97scMdaMqa1HFi5tc9yLbdVmXsq+88YXrNmtuxJtdcEK5B56bTu7bAU8eEkINiuhVB
	PoZjScv9u+SL+18zkufrW6YJkJ/cxOo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Pz4JCC5j;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf31.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412493;
	b=fLz7MIvTuD0Hyv5FewuzTwfbHkL8XO9uF7BfO4MhgbQuHuEze7tKOU0xJ84osmBt/D7NYq
	jMULzEKOv3T8AkAPWVbggveMvXCay++P2bUxbA1LX3H6cJTqOyeVYznQrUQXmqp3+4sg7x
	urKS5b7HaTlxXRPbYqB4m7LT/trvafU=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=0qEYw/kORu+CHB2h/1PvcuGa9W8zXV/BEp8uiX+ijrc=;
	b=Pz4JCC5jlXSi5X4B42t+HBGZjPXcu07/0QJzKOkROww8hc0n+LYFEueKq+YzBskjWdDfC7gwn
	1H8vo4WsTs7uC2COJRcfMc7GyyM70t22qbv7XheS4lp/S98A3iFUlPsg7YpllfaEsbjXdOzLvM/
	EmvokN6FPkEekmuGMpxr08g=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvZ1x4kQfzYm4Nv;
	Tue,  7 Jul 2026 16:21:25 +0800 (CST)
Received: from TA001.hihonor.com (10.77.210.32) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 16:21:25 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA001.hihonor.com
 (10.77.210.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 16:21:24 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Tue, 7 Jul 2026 16:21:25 +0800
From: wangtao <tao.wangtao@honor.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
	<luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>,
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "baoquan.he@linux.dev"
	<baoquan.he@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
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
	<dvander@google.com>, zhangji <zhangji1@honor.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Thread-Topic: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Thread-Index: AQHdDdtOKxyL+IwP/0+o3I4bi0Jgh7ZhGu0AgACbXoA=
Date: Tue, 7 Jul 2026 08:21:24 +0000
Message-ID: <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
In-Reply-To: <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE3E720003
X-Stat-Signature: c95wpercfcsch8kuk6kgm7qf3t9r8ok8
X-Rspam-User: 
X-HE-Tag: 1783412492-67045
X-HE-Meta: U2FsdGVkX19YdgBA43T1cWmqa+RZzBs67NRj+pRKwERUEGZBXTcV30XZwPy8r126xxzJ4WQD97C4ZZqbDCLUNzk8u2MS3iJ5clVXiDyuhT1gjkI0STZ2v8kG3DYII3ijXhUaghsaI2UFPe64q/RayeJaExae3hgjRFDl7bFLVZASGJMfe4Uh4ozAeEf+Io1o0WIKhCHqXr7iHa/s99mdhpkCdaq1MTrdYjmkmKyrWEIV7A+Z5I1yeUffxS0mnzkHPbUl6YNqfCePDqKyZki2ASfVHs0j1+dS7Q7VEOoLJSBr3cJHdsq/4FcPQz4xi7pGXB9Vond78pF+WGUs+d2WsXzcKiLWytBW4ad6IeBrPfusASRiVTqAt+gX27A/x6jgzOx1GJ6YYcmQpCDx1Tk1ol6eZ/PaaJe0pjCX4hylxViVnTZ15ay9lugzipIo4+lX5mWuUlNOjJux6IEgy9x7R/oJuYzo3dAKcdIp8HW6oNvEWqz+5fqVXV3t+PdBLZV45ec031AXtcmD7ofgU8TZXe78WodxUcwu2FzPlSxeQGSo/rJmq8MfsGa57PL73vtGaSBBgp/G0/jqJQHYvSRnqJmDL4dBsuANZU4VB7nbm7gUlzgknRajFVagnXIA7wuOYEzJ+208xX3GvUzPmIWfOXrDfAYKcmwDpIS8AXVxZmk+In7nKD3+YRl+jwFmrceCtRNBG8RBKPROBrduNh76d+VpHhXcMj+tm0Xv56Lpxg0AUabA/wNTLZXJ4dnNLeoAjLjzoVapUqd4wD9Xfd7NN8gLIo++Rj10w7+jKK3cof3FYO/Y69E3vLH77MOjTiyygdyd8++VfmZTwc89poW1GgbzG8/8ohi2QlDQeTZTaq4y/pORRCR9BDNWsNChBRyqjKLFJUWU2Klc01DOAfOxrsd/esOpsX52ocJLM4L1GHGt7IYR7T4Xyxa+8fc14OAof2UWbtm50+T7P+zpCFL
 9Tbsaj/d
 xJCNz/bOgHYcGDZtaCsY/hwLLVcob5UwLvjFDVCr5dayL5wYeZZV4xua6hqDFQjSATpkX3BSQoC8nf8iulEjQr4PiK/kljtMxS5fiu6L+xq9rgvqCDml/R6rLwtDR43Isu48hZ5Rd4ZFw/SmqbqgLSQucSa/H886y39iCTgIwbSRwrYq5vt802vPfAKb50dqhto0U3I2MQNJc21usfrvHKVzysVO7aGKkh+/qDPU9e5IMCAk2F1uPzJfQSYwaXnKzewue4iuhhPAt+kd703tPIld1O96DaUamRZvxf8K5XJAEjOg2SFA/bEwyKgGq5HvRfnPkJZxWfrZWmsnVW4yLdcJ5BfrGlA9sJC8O5hVxUQTouqbJIMPpcIfuXcsX5LsRFLRTX3VjKZUNACe+RcEGi0iPbbZ3tcnEDfwXA2/nfgX8aP9XRQ2s6Hv761BHEz9R7GsuJlLcoDP0aI+CLjsjnwSyXcTFBnOThplsdgKSa4/GaG+AbGo8xdukgD7qaogjJ6HXHFFaRU9vOgogs50loSODU/mNZuefxJcWMPKAcXtA4FU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gT24gNy83LzI2IDA4OjMyLCB0YW8gd3JvdGU6DQo+ID4gSGkgYWxsLA0KPiA+DQo+ID4g
U2luY2UgdjEgd2FzIHJlbGF0aXZlbHkgY29tcGxleCBhbmQgZGlmZmljdWx0IHRvIGV4dGVuZCwg
dGhpcyB2ZXJzaW9uDQo+ID4gYWRvcHRzIGEgc2ltcGxlciBhbm9uX3ZtYSBpbXBsZW1lbnRhdGlv
biBhcHByb2FjaC4NCj4gDQo+IEkgcmVhbGx5IGhhdGUgdG8gcmVwZWF0IG15c2VsZiwgYnV0IHlv
dSBzZWVtZWQgdG8gaGF2ZSBtaXNzZWQgbXkgbWFpbiBwb2ludA0KPiBbMV0NCj4gDQpJIHNhdyBp
dCwgYW5kIEnigJl2ZSB3YWl0ZWQgZm9yIGEgd2hpbGUgYXMgd2VsbC4NCg0KSWYgdGhlcmUgYXJl
IHRlY2huaWNhbCBpc3N1ZXMsIHBsZWFzZSBwb2ludCB0aGVtIG91dCBkaXJlY3RseS4NCk9yIGlz
IHRoaXMgc2ltcGx5IGhvdyB0ZWNobmljYWwgZGlzY3Vzc2lvbnMgYXJlIHVzdWFsbHkgY29uZHVj
dGVkIGluIHRoZSBMaW51eCBjb21tdW5pdHkgb3IgdGhlIG1tIHN1YnN5c3RlbT8NCg0KVGhhbmtz
LA0KVGFvDQoNCj4gIkxvcmVuem8gaGFzIGJlZW4gaGFyZCBhdCB3b3JrIGV4cGxvcmluZyB2YXJp
b3VzIGRlc2lnbiBvcHRpb25zIChhbmQgSSdtDQo+IGFmcmFpZCBoZSBtaWdodCBiZSBvbmUgb2Yg
dGhlIDMgcGVvcGxlIG9uIHRoaXMgcGxhbmV0IHRoYXQgdW5kZXJzdGFuZA0KPiBhbm9uX3ZtYSBp
biBmdWxsIGRldGFpbCksIHNvIEkgc3VnZ2VzdCB3ZSB3YWl0IGZvciBhIHJlZGVzaWduIHByb3Bv
c2FsIGZyb20NCj4gaGltIGFuZCBzZWUgaWYgdGhhdCBpcyBkb2FibGU/Ig0KPiANCj4gWzFdIGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC83MDM3NzYyNi01MDBkLTQ2ZjItYTNmNS0NCj4gYTBk
MjkxNGNlMzY1QGtlcm5lbC5vcmcvDQo+IA0KPiAtLQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

