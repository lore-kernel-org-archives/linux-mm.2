Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1537BD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C23F6B008C; Mon,  1 Dec 2025 08:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471BD6B0092; Mon,  1 Dec 2025 08:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3611C6B0093; Mon,  1 Dec 2025 08:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 203D96B008C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:32:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2F18B6F00
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:32:40 +0000 (UTC)
X-FDA: 84170992080.21.104D005
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC4444000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:32:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=RhIFTECH;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FzePyoI/nyEJlpAkwj8VuD5xVudCKii8Wo6Cu/3xfM=;
	b=ciuvSo7oBWBm4qaC3VZR0/lG+1zlW8vdAb43uwC1MdelV+Hf7t943J01QC+nUhy8F9nVDd
	3KehH3MkcXi3RcO4LreVdmhawFbTiKtvLFkFUVdoDWQ85TrAemIWyJgN7KjHz48Zf9sgGZ
	amZJVKLlH6qsGgUUJ34lSa558YeCor8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595958; a=rsa-sha256;
	cv=none;
	b=kCUullMXzlG5wGsXTAhakQRIgPpxJqdGFjWVGp7OUrcDf/5b95jEeqpPQ+6uCqOtqyFxV/
	rC41eIRmtAlv4yNZ2ZAtNEmqZtutLbuDM/+ER8Yd0iEpK05nbjfZ1hV5VvpCTq5JSWbF1j
	NwUcFk4hwNXgwsQnFxCd7M3A7+FaF3M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=RhIFTECH;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=9FzePyoI/nyEJlpAkwj8VuD5xVudCKii8Wo6Cu/3xfM=;
	b=RhIFTECHkllpTC8U8xSfBK8AsAMbeIYBESEAWy21AoStEFUGcFzdkzAtpqPzwxfDcKSwsDd+R
	dSjw2pp4BfPhIGV7m/kWXGmEobcigWVA0U6BmLp0twds02AX8FZMRvkrPr/bdhaQKc1ewGOzegd
	jH/BfqFN45ngnLeCvhNBjcY=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dKlCL30T5zYl0Dw;
	Mon,  1 Dec 2025 21:30:38 +0800 (CST)
Received: from w004.hihonor.com (10.68.29.54) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 21:32:31 +0800
Received: from w002.hihonor.com (10.68.28.120) by w004.hihonor.com
 (10.68.29.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 21:32:21 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Mon, 1 Dec 2025 21:32:21 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao
	<tao.wangtao@honor.com>, wangzhen 00021541 <wangzhen5@honor.com>, "zhongjinji
 00025326" <zhongjinji@honor.com>, Kairui Song <ryncsn@gmail.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQ//+VEACAAImM4P//h9UAgACJZRD//5W2AAAWOtvA
Date: Mon, 1 Dec 2025 13:32:21 +0000
Message-ID: <48ba80e93270438994db78f74a7acdb9@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com>
 <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com>
 <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
 <dc8ce4f329d74a24bde62c93818df44a@honor.com>
 <CAGsJ_4w16G+AngPu48SEy1H+ZuE1AQngiY=cSfEs9V6=OUKX_Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4w16G+AngPu48SEy1H+ZuE1AQngiY=cSfEs9V6=OUKX_Q@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC4444000D
X-Stat-Signature: yerfhstr4bn3pmezabw4tjr5jcwu7tqf
X-HE-Tag: 1764595957-708339
X-HE-Meta: U2FsdGVkX1/ACv6gAlbjHCPyTjtuTCONL8/+CRDvmkRyjH88TsE33PEbdGB5FD8kvQoz5CAzqio8b6h0s+x/Edw07CzSv49ktsjiTci8PQKt4p5HVa8KhwxaXjwwmHi3D/59izN9hz4ImVx/Dsyu0ydesolXnA3tVdHGEz8est981/yL9uVRUngWVQECD5XpBK6MD7O8Wr3fHeeSpsgcs5nmNk+ExN462Hg40MlW0H0dblcW30gTQDYbFzb523pX2W3DSFy83FL+6mJYgwxEru8VEnbCpzYPEO5jfaGK/k+um6rK4KDyi30oL9cSSGTPY4zEcY1h+Az3wYdGOSXvA98uKMyVCdxDzPiQUON+9ZmsU55370RhIhtK5AcsYITJrVN1pXoO0Vx4dd3GOIdbuZl57YMMMVeS6absOjdLIdZ4BdPnOsjAzlWlzhHKSERuFlOJsM9qW66B6Fd/RZo0ECsOZkv+iGLhQpieZ718dPccG5nEMQafyOKIEW19LTgx16jOfLbNdb+Jd0fcKXtL/ZWkWDoSfLRRCSW6JYeMC/c53Qs0b5WVAcZM/0/V3kEn83uUpbMF0Ud5sTnPJrGgF1uly/yZ4XEaJPmRD6zeZqy4Z0dGVySEKfn10W2vAqqYJu3b8IvKX3hKYERDLn4j+u4PUJYU4hkUxh0tWO5qyEFjWLYU5ND3RDG+0ShmZ5/Sf74TmTtbhO7sTZ8eN5xFZe4TYIZV2zMj1MhBBAwovADlUnYczeVRbc0zbk9yzSc5XqNO3zBfRnS3JvY2Y7C5VVJadx2uuWWfRN6MPOMYEZIEVGybJzru+GZkvN0HbWGUFRDFN93oruUuXI/DzJgtjaoSkbbiHTrfJCKnSfOy7geS3mSHqaUJ5iKq+dptnCq/Y67WIWeJ2nnwpSGhyfbwiFGOWBFd+cWkPKwt/pUB0T+1h0sA6ux0q78aCUZ5uS/wwDfxf8aZrgA6DXXped7
 3ZiHmh2y
 o1aeWCm46x945CExB2x75N+tJRFItZuOHkaw+tlv8JK9Oh9nq3UBzrZlbJzgw70FQzOTWcfdq1o+pLoD9IygJZcb3aHn7QDJ+voJ6P6tykaAI8yZ8Eb83wbsA3iuZfcZH0zB1jxWQ+RrHHVHPsaF0E0NHbrHYI8hJUOpjeuPmCQb9BNNWChG3/XRfQVfXa4d8VqQXcMdRBVWHYwBPW7CrP20cRPxM0fS5KSdfLQl/HYcNxLDoVCLT+pCNc6/XYqG5KnP77erDIMAjpd5Sv3+3vNxL6dnskVMXg0gW5OVtyk5BTEhUveTwkz5Ch0nBWpXlKgLGKKfNf3EGPdSj/jNeqHRE7SRWWIFx4kGBnP7vq5pLEGmmaw7kST7oowT/2LFck7nNV+JU19VaiOBzbEKdQIiavknC9KvHn8d3Bvd22S+rZVdDncBc9zoCkwDJ/q4o6BXeeCPRDK0anjZCIxy7LHjBHDeSvrliND8JPsasqqnEr/AjivGFxmhutazRygBo4cW/8/GRrQk6BxUfAcLhOFgfz3a7U4+cKCkPXj78t2Bjy/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNClRoYW5rIHlvdSBmb3IgdGhlIGZvbGxvdy11cCBxdWVzdGlvbnMuDQoNCkl0
IHNlZW1zIHRoYXQgb3VyIG1haW4gdGVzdGJlZCAoa2VybmVsIHY2LjYvdjYuMTIgZm9yIGxhdGVz
dCBkZXZpY2VzKSwgDQpkb24ndCBoYXZlIFNXQVBQSU5FU1NfQU5PTl9PTkxZLzIwMSAtIHJlbGF0
ZWQgcGF0Y2hlcyB5ZXQuDQoNClNpbmNlIHRoZSBtYXggc3dhcHBpbmVzcyBpcyAyMDAsIHRoZXJl
IGFyZSBxdWl0ZSBzY2VuYXJpb3MgdGhhdCBmaWxlDQpwYWdlcyBhcmUgdGhlIG9ubHkgb3B0aW9u
Lg0KDQpRdW90ZSBmcm9tIGthaXJ1aSdzIHJlcGx5Og0KPiBSaWdodCwgd2UgYXJlIHNlZWluZyBz
aW1pbGFyIHByb2JsZW1zIG9uIG91ciBzZXJ2ZXIgdG9vLiBUbyB3b3JrYXJvdW5kDQo+IGl0IHdl
IGZvcmNlIGFuIGFnZSBpdGVyYXRpb24gYmVmb3JlIHJlY2xhaW1pbmcgd2hlbiBpdCBoYXBwZW5z
LCB3aGljaA0KPiBpc24ndCB0aGUgYmVzdCBjaG9pY2UuIFdoZW4gdGhlIExSVSBpcyBsb25nIGFu
ZCB0aGUgb3Bwb3NpdGUgdHlwZSBvZg0KPiB0aGUgZm9saW9zIHdlIHdhbnQgdG8gcmVjbGFpbSBp
cyBwaWxpbmcgdXAgaW4gdGhlIG9sZGVzdCBnZW4sIGEgZm9yY2VkDQo+IGFnZSB3aWxsIGhhdmUg
dG8gbW92ZSBhbGwgdGhlc2UgZm9saW9zLCB3aGljaCBsZWFkcyB0byBsb25nIHRhaWxpbmcNCj4g
aXNzdWVzLiBMZXQncyB3b3JrIG9uIGEgcmVhc29uYWJsZSBzb2x1dGlvbiBmb3IgdGhhdC4NCg0K
QWdhaW4sIHRoYW5rIHlvdSBmb3IgeW91ciBndWlkYW5jZS4gV2Ugd2lsbCBjYXJlZnVsbHkgZXZh
bHVhdGUgdGhlIA0KUGF0Y2hzZXRbMV0geW91IHJlY29tbWVuZGVkLg0KDQo+IEhpIFppY2hlbmcs
DQo+IA0KPiBPbiBNb24sIERlYyAxLCAyMDI1IGF0IDU6NTXigK9QTSB3YW5nemljaGVuZyA8d2Fu
Z3ppY2hlbmdAaG9ub3IuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEhpIEJhcnJ5LA0KPiA+DQo+
ID4gVGhhbmsgeW91IGZvciB0aGUgY29tbWVudCwgYWN0dWFsbHkgd2UgZG8ga25vdyB0aGUgY2dy
b3VwIGZpbGUuDQo+ID4NCj4gPiBXaGF0IHdlIHJlYWxseSBuZWVkIGlzIHRvICpwcm9hY3RpdmUg
YWdpbmcgMn4zIGdlbnMqIGJlZm9yZSBwcm9hY3RpdmUNCj4gcmVjbGFpbS4NCj4gPiAoZXNwZWNp
YWxseSBhZnRlciBjb2xkIGxhdW5jaGVzIHdoZW4gbm8gYW5vbiBwYWdlcyBpbiB0aGUgb2xkZXN0
IGdlbnMpDQo+ID4NCj4gPiBUaGUgcHJvYWN0aXZlIGFnaW5nIGFsc28gaGVscHMgZGlzdHJpYnV0
ZSB0aGUgYW5vbiBhbmQgZmlsZSBwYWdlcyBldmVubHkgaW4NCj4gPiBNR0xSVSBnZW5zLiBBbmQg
cmVjbGFpbWluZyB3b24ndCBmYWxsIGludG8gZmlsZSBjYWNoZXMuDQo+IA0KPiBJ4oCZbSBub3Qg
cXVpdGUgc3VyZSB3aGF0IHlvdSBtZWFuIGJ5IOKAnHJlY2xhaW1pbmcgd29u4oCZdCBmYWxsIGlu
dG8gZmlsZSBjYWNoZXMu4oCdDQo+IA0KPiBJIGFzc3VtZSB5b3UgbWVhbiB5b3UgY29uZmlndXJl
ZCBhIGhpZ2ggc3dhcHBpbmVzcyBmb3IgTUdMUlUgcHJvYWN0aXZlDQo+IHJlY2xhbWF0aW9uLCBz
byB3aGVuIGJvdGggYW5vbiBhbmQgZmlsZSBoYXZlIGZvdXIgZ2VuZXJhdGlvbnMsDQo+IGBnZXRf
dHlwZV90b19zY2FuKClgIGVmZmVjdGl2ZWx5IGFsd2F5cyByZXR1cm5zIGFub24/DQo+IA0KPiA+
DQo+ID4gPiBBbHNvIG5vdGUgdGhhdCBtZW1jZyBhbHJlYWR5IGhhcyBhbiBpbnRlcmZhY2UgZm9y
IHByb2FjdGl2ZSByZWNsYW1hdGlvbiwNCj4gPiA+IHNvIEnigJltIG5vdCBjZXJ0YWluIHdoZXRo
ZXIgeW91ciBwYXRjaHNldCBjYW4gY29leGlzdCB3aXRoIGl0IG9yIGV4dGVuZA0KPiA+ID4gaXQg
dG8gbWVldCB5b3VyIHJlcXVpcmVtZW50c+KAlHdoaWNoIHNlZW1zIHF1aXRlIGltcG9zc2libGUg
dG8gbWUNCj4gPiA+DQo+ID4gPiBtZW1vcnkucmVjbGFpbQ0KPiA+ID4gICAgICAgICBBIHdyaXRl
LW9ubHkgbmVzdGVkLWtleWVkIGZpbGUgd2hpY2ggZXhpc3RzIGZvciBhbGwgY2dyb3Vwcy4NCj4g
PiA+DQo+ID4gPiAgICAgICAgIFRoaXMgaXMgYSBzaW1wbGUgaW50ZXJmYWNlIHRvIHRyaWdnZXIg
bWVtb3J5IHJlY2xhaW0gaW4gdGhlDQo+ID4gPiAgICAgICAgIHRhcmdldCBjZ3JvdXAuDQo+ID4g
Pg0KPiA+ID4gICAgICAgICBFeGFtcGxlOjoNCj4gPiA+DQo+ID4gPiAgICAgICAgICAgZWNobyAi
MUciID4gbWVtb3J5LnJlY2xhaW0NCj4gPiA+DQo+ID4gPiAgICAgICAgIFBsZWFzZSBub3RlIHRo
YXQgdGhlIGtlcm5lbCBjYW4gb3ZlciBvciB1bmRlciByZWNsYWltIGZyb20NCj4gPiA+ICAgICAg
ICAgdGhlIHRhcmdldCBjZ3JvdXAuIElmIGxlc3MgYnl0ZXMgYXJlIHJlY2xhaW1lZCB0aGFuIHRo
ZQ0KPiA+ID4gICAgICAgICBzcGVjaWZpZWQgYW1vdW50LCAtRUFHQUlOIGlzIHJldHVybmVkLg0K
PiA+ID4NCj4gPiBUaGlzIHJlbWluZCBtZSB0aGF0IGFkZGluZyBhIGBtZW1vci5hZ2luZ2AgdW5k
ZXIgbWVtY2cgZGlyZWN0b3JpZXMNCj4gPiByYXRoZXIgdGhhbiBhZGRpbmcgbmV3IHByb2NmcyBm
aWxlcyBpcyBhbHNvIGEgZ3JlYXQgb3B0aW9uLg0KPiANCj4gSSBzdGlsbCBkb27igJl0IHVuZGVy
c3RhbmQgd2h5LiBBZ2luZyBpcyBzb21ldGhpbmcgTUdMUlUgaXRzZWxmIHNob3VsZA0KPiBoYW5k
bGU7IGNvbXBvbmVudHMgb3V0c2lkZSBNR0xSVSwgc3VjaCBhcyBjZ3JvdXAgdjIsIGRvIG5vdCBu
ZWVkIHRvIGJlDQo+IGF3YXJlIG9mIHRoaXMgY29uY2VwdCBhdCBhbGwuIEV4cG9zaW5nIGl0IHdp
bGwgbGlrZWx5IGxlYWQgdG8gYW5vdGhlcg0KPiBpbW1lZGlhdGUgTkFLLg0KPiANCj4gSW4gc2hv
cnQsIGFnaW5nIHNob3VsZCByZW1haW4gd2l0aGluIE1HTFJV4oCZcyBpbnRlcm5hbCBzY29wZS4N
Cg0KSSB3b3VsZCBsaWtlIHRvIGV4cHJlc3MgYSBkaWZmZXJlbnQgcG9pbnQgb2Ygdmlldy4gV2Ug
YXJlIHdvcmtpbmcgb24gc29tZXRoaW5nDQpJbnRlcmVzdGluZyBvbiBpdCwgd2lsbCBiZSBzaGFy
ZWQgb25jZSByZWFkeS4NCg0KPiANCj4gQnV0IGl0IHNlZW1zIHlvdSBkbyB3YW50IHNvbWUgcG9s
aWN5IGNvbnRyb2wgZm9yIHlvdXIgcHJvYWN0aXZlDQo+IHJlY2xhbWF0aW9uLCBzdWNoIGFzIGFs
d2F5cyByZWNsYWltaW5nIGFub24gcGFnZXMgb3IgcmVjbGFpbWluZyB0aGVtDQo+IG1vcmUgYWdn
cmVzc2l2ZWx5IHRoYW4gZmlsZSBwYWdlcy4gSSBhc3N1bWUgWmhvbmdrdW7igJlzIHBhdGNoIFsx
XSB3ZQ0KPiBtZW50aW9uZWQgZWFybGllciBzaG91bGQgcHJvdmlkZSBzdXBwb3J0IGZvciB0aGF0
LCBjb3JyZWN0Pw0KPiANCj4gQXMgYSB3b3JrYXJvdW5kLCB5b3UgY2FuIHNldCBgc3dhcHBpbmVz
cz1tYXhgIGZvciBgbWVtb3J5LnJlY2xhaW1gDQo+IGJlZm9yZQ0KPiB3ZSBpbnRlcm5hbGx5IGlt
cHJvdmUgdGhlIGhhbmRsaW5nIG9mIHRoZSBhZ2luZyBpc3N1ZS4gSW4gc2hvcnQsDQo+IOKAnHBy
b2FjdGl2ZSBhZ2luZ+KAnSBhbmQgc2ltaWxhciBtZWNoYW5pc21zIHNob3VsZCBiZSBoYW5kbGVk
IGF1dG9tYXRpY2FsbHkNCj4gYW5kIGludGVybmFsbHkgd2l0aGluIHRoZSBzY29wZSBvZiB0aGUg
TUdMUlUgY29kZS4NCg0KU3VyZSwgd2Ugd2lsbCBtYWtlIGEgY2FyZWZ1bCBldmFsdWF0aW9uLg0K
DQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtDQo+IG1tL2NvdmVyLjE3
NDQxNjkzMDIuZ2l0LmhlemhvbmdrdW4uaHprQGJ5dGVkYW5jZS5jb20vDQo+IA0KPiBUaGFua3MN
Cj4gQmFycnkNCg0KVGhhbmtzDQpaaWNoZW5nDQo=

