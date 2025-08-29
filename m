Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4CD2CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C088E000D; Fri, 29 Aug 2025 10:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124228E0001; Fri, 29 Aug 2025 10:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012098E000D; Fri, 29 Aug 2025 10:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA8DB8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:31:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914541A05F3
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:31:01 +0000 (UTC)
X-FDA: 83830031922.17.53303BF
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf04.hostedemail.com (Postfix) with ESMTP id 163374000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:30:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=DhnczZyH;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf04.hostedemail.com: domain of "prvs=329bb9716=suschako@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=329bb9716=suschako@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756477859; a=rsa-sha256;
	cv=none;
	b=1dthS7MMHiOYcK/W0Q0zXAqUYc8SIgQ8bgaWbkX64WloKlN5wTk3byZbBupniQI0F1CfLM
	fyig3sURDt7xh6KhnTHE/IY32giKkXFiHe5ifTyHHd0kHasrgHGsN5IAd7mWaEUz+BiFUK
	M7o/eubgtmhzyJVu0cvxBuG0QvZTWtA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=DhnczZyH;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf04.hostedemail.com: domain of "prvs=329bb9716=suschako@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=329bb9716=suschako@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756477859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xbY4RHTEVj+znLNZefTeOlKmdX2iYI7Yd3FVTEuylUI=;
	b=HbvN+fqoyybZ/IZRLcB4pZphmClvKECIq52ecj7Auxw2Ggw7rlls16nfKS/lF9RAe+w5kz
	fo6RN3MajdaMaVcoDdcqPq1IT7A9C/AQVHnZ7xkiIGsnPERjA2qrYUlff+hEQRMQfDwA4n
	7SVupslStmsca6xsMfoqk1Jv45XpkPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1756477859; x=1788013859;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xbY4RHTEVj+znLNZefTeOlKmdX2iYI7Yd3FVTEuylUI=;
  b=DhnczZyHdMXi1QvJ7QQ8NtAOGc9yWlf0r5CuYg0kb1A9h+4jy/4yhLLO
   LEQ3YFof1hr/DbPjujMjU+yLvlsks2iiokLvKz446/FQijY3USpRXAd8g
   Cy7bUd0u55HRyPzyCXAzyKTPNmJGANv84++1PWGZmnEI13moIkde5Kq4U
   w4aEoqCH/TG6qEGjLVkz4zHvsfZfrTtmNaZzq17AX8/9jmrHKj/wjhwhr
   D7LKeIM1HCjt+qn/xVYHCJJ3AuK65H2e+3pAU/sPhCjLpYaSoCTI1lCDp
   eFU/ccD8W8jlnTfPlu7hlOJTq7x23YfqpPxWhOdPgCtQ9+GGdcRVHagr/
   w==;
X-CSE-ConnectionGUID: 1UrY0Qi8SRKK5NHZD0uK/g==
X-CSE-MsgGUID: GXER2AUmTuqZF9lAja7TSQ==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1265293"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 14:30:49 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:13169]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id ad16dc39-b7aa-49c3-93f0-4bc10b1a8a66; Fri, 29 Aug 2025 14:30:49 +0000 (UTC)
X-Farcaster-Flow-ID: ad16dc39-b7aa-49c3-93f0-4bc10b1a8a66
Received: from EX19D024EUA004.ant.amazon.com (10.252.50.30) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Fri, 29 Aug 2025 14:30:47 +0000
Received: from EX19D024EUA004.ant.amazon.com (10.252.50.30) by
 EX19D024EUA004.ant.amazon.com (10.252.50.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Fri, 29 Aug 2025 14:30:46 +0000
Received: from EX19D024EUA004.ant.amazon.com ([fe80::4608:828c:c80b:ca72]) by
 EX19D024EUA004.ant.amazon.com ([fe80::4608:828c:c80b:ca72%3]) with mapi id
 15.02.2562.017; Fri, 29 Aug 2025 14:30:46 +0000
From: "Uschakow, Stanislav" <suschako@amazon.de>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "trix@redhat.com" <trix@redhat.com>, "ndesaulniers@google.com"
	<ndesaulniers@google.com>, "nathan@kernel.org" <nathan@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "mike.kravetz@oracle.com"
	<mike.kravetz@oracle.com>, "jannh@google.com" <jannh@google.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "osalvador@suse.de" <osalvador@suse.de>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "jannh@google.com" <jannh@google.com>
Subject: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Thread-Topic: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Thread-Index: AQHcGOKArPRLx5Gss0qhHb9N9ZVPlw==
Date: Fri, 29 Aug 2025 14:30:46 +0000
Message-ID: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.213.27]
Content-Type: text/plain; charset="iso-8859-7"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 163374000A
X-Stat-Signature: puqp981szz8j7mx5cxe7q7d9pydpagce
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756477858-173314
X-HE-Meta: U2FsdGVkX1+QdjyfIZr3tyyiApjz3cIoAgCsv19bcRgN5KB65cSl/joSVaQun4NFXvMIi0vTWwQaGF7Oio/DY4Z2gdiajYfJHgy/nSnL84+UaS/p5cfrMUmEDHUe4AMPxJqI3IBM1i/hHStwFgQIKvv4Ii+2GKGHiXPObybpSQmi0GxaCi5oFBLK65ZWkm5JUVJpidMEe1DPI2U49ZK23d5iplBvsaiFE/Z+77okWhXuYKUbI+ckWkUime3+mDN/llU+PO/cM6p8m6aMt/kRXc2WHlONeYNGOrdZ9rUn76s/J5ZAKXeIg5PSEUYf8sLukU/LT/c8CJ7tEB0iPAeQHwy5ZydVxJT2t26BMPTO9icc/rFaCFpXwloee20LlihS856jmckJ0UwutHFfz1oQ46awfCM5lmYAVCTIjDwCs7Z8lQKnOWGEJrV2fXD8cUfqxiI+Z02CAPlG3sUSlDmB8QFCsnqMksNw0B6bbxEvdey46n0D1z5XdjpsEnu/5YwCX8RnHft5y3LUGWFddX6jA3hiAr28sNgKEjIr1Ja7hmTbTmKEcIZrEttHsmooxtsl74N6D6N9apw5oAvIAe8Cw7B110e39S5qpAv4Lc6UBbTNikNz1DfNxN5HQ0HPRcoc7jQQhwG6ulE8/rD/ydRiiyh1J7zCemH/E9k1+Bt9z1mOfSeSlPKYYt9unqEV3cKKjWuIGs6+zpH8ZeZtMoDgmxhgvT0M31uid5vEN378IJ48YkudPn8PqCAJNujUN7o5NU06inZxD7ADbK3JXiyv8Cmz2ATCBJXxWxtt8tSjsSJ2uyhXB9Lu2ERyVrEuNEPb46W5oQRgEI++1gYyesS5ovrPh1tHzLRZj29m36B37rqgIty9uTySpJAyBlRqaHSVXeWnpz5f3g/Wv/QRKnAf7WCILT4jSWfjgOVLuDLTjx1iwI6yihHF9Hmx2nzwkRuW199F9bwqaQAGmo2VCze
 EpfzbH6D
 sLqiPj5gxPMFX6F6dse2JAYWv8Q0LgKM9mBxN/LWI8G0Fy4tKhZz48zx1CjrsiwMzI/yl5bEQHAspLqO+d6o95UHqksl8Jt9eGIuW93cF7SikkCz1xZhxa8nBVZ57jlMEuuuPfQYw+OOdcv8S4rovPgAlDpHmyvXoT35lWZlDaKbElNJDvJwYKYXdXw3xACz9KTb8zVnxNy6FFbtbbBcSCUxo2wpecAomK9D9DSaCctiD9unJXOGfeEn8LQuNCd1CZ6h9oe3yxoQiiKBRKrMa25KF+myJqi45YPo+jnD45u2p7WLef3d5IwUzc5oytCkMeC0djom5/OnLEWwDIkYxNT25K5lcV8hryP824cVEJZC3bo77ravbFG5jpX/rDAs6A1XJTKKI4JrW3Mqm0UF/eQNzS4aMmLQlS7NkJem4wHCI+/u7LiwsxOlOPkVgzeaOcZ4uJmth3Q93kNzhY90b4I287ukqe5Qwx5qzp3YbLvT9JUjRqNg6lMSo4t62Am5AKXpgj4uF8giDpn+W7wL6dljaTx5wlv9RO3w7H+dvA/yBA54PQRuMtTms0nxOucRPSpVU2oJtwTKCaUtffBjVbhrwYHNuFdL++gNlixYCREvQaDS3w5WwYbRwEjrcMtD/pF3s71cvkOlwDdUDOLisAiHnE5z2WIKZoJdGB4G2L47z5B/oABTeOgpvBU5D3ona7LkuF/hwIsn08ri81DYbhz9E6cD25PybDctw5w8+QwcW36Fc5H4zLAKsSLfdiSwYQJFM4kxIr3aWg6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGVsbG8uCgpXZSBoYXZlIG9ic2VydmVkIGEgaHVnZSBsYXRlbmN5IGluY3JlYXNloHVzaW5nIGBm
b3JrKClgIGFmdGVyoGluZ2VzdGluZyB0aGUgQ1ZFLTIwMjUtMzgwODUgZml4oHdoaWNoIGxlYWRz
IHRvIHRoZaBjb21taXSgYDEwMTNhZjRmNTg1ZjogbW0vaHVnZXRsYjogZml4IGh1Z2VfcG1kX3Vu
c2hhcmUoKSB2cyBHVVAtZmFzdCByYWNlYC4gT24gbGFyZ2UgbWFjaGluZXMgd2l0aCAxLjVUQiBv
ZiBtZW1vcnkgd2l0aCAxOTYgY29yZXMsIHdlIGlkZW50aWZpZWQgbW1hcHBpbmegb2agMS4yVEIg
b2Ygc2hhcmVkIG1lbW9yeSBhbmQgZm9ya2luZyBpdHNlbGYgZG96ZW5zIG9yoGh1bmRyZWRzIG9m
IHRpbWVzIHdlIHNlZSBhIGluY3JlYXNlIG9mIGV4ZWN1dGlvbiB0aW1lcyBvZiBhIGZhY3RvciBv
ZiA0LiBUaGUgcmVwcm9kdWNlciBpcyBhdCB0aGUgZW5kIG9mIHRoZSBlbWFpbC4KCkNvbXBhcmlu
ZyB0aGUgYSBrZXJuZWwgd2l0aG91dCB0aGlzIHBhdGNoIHdpdGggYSBrZXJuZWwgd2l0aCB0aGlz
IHBhdGNoIGFwcGxpZWQgd2hlbiBzcGF3bmluZyAxMDAwIGNoaWxkcmVuIHdlIHNlZSB0aG9zZSBl
eGVjdXRpb24gdGltZXM6CgoKUGF0Y2hlZCBrZXJuZWw6oAokoHRpbWUgbWFrZSBzdHJlc3MKLi4u
CnJlYWygIKAgMG0xMS4yNzVzCnVzZXKgIKAgMG0wLjE3N3MKc3lzoCCgIKAwbTIzLjkwNXMKCk9y
aWdpbmFsIGtlcm5lbCA6oAoKJKB0aW1lIG1ha2Ugc3RyZXNzCi4uLnJlYWygIKAgMG0yLjQ3NXMK
dXNlcqAgoCAwbTEuMzk4cwpzeXOgIKAgoDBtMi41MDFzCgoKVGhlIHBhdGNoIGluIHF1ZXN0aW9u
OqBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUv
bGludXguZ2l0L2NvbW1pdC8/aWQ9MTAxM2FmNGY1ODVmY2NjNGQzZTVjNTgyNGQxNzRkZTIyNTdm
N2Q2ZAoKCk15IG9ic2VydmF0aW9uL2Fzc3VtcHRpb24gaXM6CgplYWNoIGNoaWxkIHRvdWNoZXMg
MTAwoHJhbmRvbSBwYWdlcyBhbmQgZGVzcGF3bnMKb24gZWFjaCBkZXNwYXduIGBodWdlX3BtZF91
bnNoYXJlKClgIGlzIGNhbGxlZAplYWNoIGNhbGwgdG8gYGh1Z2VfcG1kX3Vuc2hhcmUoKWAgc3lu
Y3Job25pemVzIGFsbCB0aHJlYWRzIHVzaW5nIGB0bGJfcmVtb3ZlX3RhYmxlX3N5bmNfb25lKClg
IGxlYWRpbmcgdG8gdGhlIHJlZ3Jlc3Npb24KCgoKSSdtIGhhcHB5IHRvIHByb3ZpZGUgbW9yZSBp
bmZvcm1hdGlvbi4KCgoKClRoYW5rIHlvdQpTdGFuaXNsYXYgVXNjaGFrb3cKCgoKCgoKCgo9PT0g
UmVwcm9kdWNlciA9PT0KClNldHVwOgoKCiMhL2Jpbi9iYXNoCmVjaG8gIlNldHRpbmcgdXAgaHVn
ZXBhZ2VzIGZvciByZXByb2R1Y3Rpb24uLi4iCgojIGh1Z2VwYWdlcyAoMS4yVEIgLyAyTUIgPSA2
MTQ0MDAgcGFnZXMpClJFUVVJUkVEX1BBR0VTPTYxNDQwMAoKIyBDaGVjayBjdXJyZW50IGh1Z2Vw
YWdlIGFsbG9jYXRpb24KQ1VSUkVOVF9QQUdFUz0kKGNhdCAvcHJvYy9zeXMvdm0vbnJfaHVnZXBh
Z2VzKQplY2hvICJDdXJyZW50IGh1Z2VwYWdlczogJENVUlJFTlRfUEFHRVMiCgppZiBbICIkQ1VS
UkVOVF9QQUdFUyIgLWx0ICIkUkVRVUlSRURfUEFHRVMiIF07IHRoZW4KoCCgIGVjaG8gIkFsbG9j
YXRpbmcgJFJFUVVJUkVEX1BBR0VTIGh1Z2VwYWdlcy4uLiIKoCCgIGVjaG8gJFJFUVVJUkVEX1BB
R0VTIHwgc3VkbyB0ZWUgL3Byb2Mvc3lzL3ZtL25yX2h1Z2VwYWdlcwoKoCCgIEFMTE9DQVRFRD0k
KGNhdCAvcHJvYy9zeXMvdm0vbnJfaHVnZXBhZ2VzKQqgIKAgZWNobyAiQWxsb2NhdGVkIGh1Z2Vw
YWdlczogJEFMTE9DQVRFRCIKoCCgoAqgIKAgaWYgWyAiJEFMTE9DQVRFRCIgLWx0ICIkUkVRVUlS
RURfUEFHRVMiIF07IHRoZW4KoCCgIKAgoCBlY2hvICJXYXJuaW5nOiBDb3VsZCBub3QgYWxsb2Nh
dGUgYWxsIHJlcXVpcmVkIGh1Z2VwYWdlcyIKoCCgIKAgoCBlY2hvICJBdmFpbGFibGU6ICRBTExP
Q0FURUQsIFJlcXVpcmVkOiAkUkVRVUlSRURfUEFHRVMiCqAgoCBmaQpmaQoKZWNobyBuZXZlciB8
IHN1ZG8gdGVlIC9zeXMva2VybmVsL21tL3RyYW5zcGFyZW50X2h1Z2VwYWdlL2VuYWJsZWQKCmVj
aG8gLWUgIlxuSHVnZXBhZ2UgaW5mb3JtYXRpb246IgpjYXQgL3Byb2MvbWVtaW5mbyB8IGdyZXAg
LWkgaHVnZQoKZWNobyAtZSAiXG5TZXR1cCBjb21wbGV0ZS4gWW91IGNhbiBub3cgcnVuIHRoZSBy
ZXByb2R1Y3Rpb24gdGVzdC4iCgoKCk1ha2VmaWxlOgoKCkNYWCA9IGdjYwpDWFhGTEFHUyA9IC1P
MiAtV2FsbApUQVJHRVQgPSBodWdlcGFnZV9yZXBybwpTT1VSQ0UgPSBodWdlcGFnZV9yZXByby5j
CgokKFRBUkdFVCk6ICQoU09VUkNFKQqgIKAgJChDWFgpICQoQ1hYRkxBR1MpIC1vICQoVEFSR0VU
KSAkKFNPVVJDRSkKCmNsZWFuOgqgIKAgcm0gLWYgJChUQVJHRVQpCgpzZXR1cDoKoCCgIGNobW9k
ICt4IHNldHVwX2h1Z2VwYWdlcy5zaAqgIKAgLi9zZXR1cF9odWdlcGFnZXMuc2gKCnRlc3Q6ICQo
VEFSR0VUKQqgIKAgLi8kKFRBUkdFVCkgMjAgMwoKc3RyZXNzOiAkKFRBUkdFVCkKoCCgIC4vJChU
QVJHRVQpIDEwMDAgMQoKLlBIT05ZOiBjbGVhbiBzZXR1cCB0ZXN0IHN0cmVzcwoKCgpodWdlcGFn
ZV9yZXByby5jOgoKCiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8c3lzL3dhaXQuaD4K
I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdHJpbmcu
aD4KI2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CgojZGVmaW5lIEhVR0VQQUdF
X1NJWkUgKDIgKiAxMDI0ICogMTAyNCkgLy8gMk1CCiNkZWZpbmUgVE9UQUxfU0laRSAoMTIwMFVM
TCAqIDEwMjQgKiAxMDI0ICogMTAyNCkgLy8gMS4yVEIKI2RlZmluZSBOVU1fSFVHRVBBR0VTIChU
T1RBTF9TSVpFIC8gSFVHRVBBR0VfU0laRSkKCnZvaWQqIGNyZWF0ZV9odWdlcGFnZV9tYXBwaW5n
KCkgewqgIKAgdm9pZCogYWRkciA9IG1tYXAoTlVMTCwgVE9UQUxfU0laRSwgUFJPVF9SRUFEIHwg
UFJPVF9XUklURSwKoCCgIKAgoCCgIKAgoCCgIKAgoCCgIE1BUF9TSEFSRUQgfCBNQVBfQU5PTllN
T1VTIHwgTUFQX0hVR0VUTEIsIC0xLCAwKTsKoCCgIGlmIChhZGRyID09IE1BUF9GQUlMRUQpIHsK
oCCgIKAgoCBwZXJyb3IoIm1tYXAgaHVnZXBhZ2VzIGZhaWxlZCIpOwqgIKAgoCCgIGV4aXQoMSk7
CqAgoCB9CqAgoCByZXR1cm4gYWRkcjsKfQoKdm9pZCB0b3VjaF9yYW5kb21fcGFnZXModm9pZCog
YWRkciwgaW50IG51bV90b3VjaGVzKSB7CqAgoCBjaGFyKiBiYXNlID0gKGNoYXIqKWFkZHI7CqAg
oCBmb3IgKGludCBpID0gMDsgaSA8IG51bV90b3VjaGVzOyArK2kpIHsKoCCgIKAgoCBzaXplX3Qg
b2Zmc2V0ID0gKHJhbmQoKSAlIE5VTV9IVUdFUEFHRVMpICogSFVHRVBBR0VfU0laRTsKoCCgIKAg
oCB2b2xhdGlsZSBjaGFyIHZhbCA9IGJhc2Vbb2Zmc2V0XTsKoCCgIKAgoCAodm9pZCl2YWw7CqAg
oCB9Cn0KCnZvaWQgY2hpbGRfcHJvY2Vzcyh2b2lkKiBzaGFyZWRfbWVtLCBpbnQgY2hpbGRfaWQp
IHsKoCCgIHN0cnVjdCB0aW1lc3BlYyBzdGFydCwgZW5kOwqgIKAgY2xvY2tfZ2V0dGltZShDTE9D
S19NT05PVE9OSUMsICZzdGFydCk7CqAgoKAKoCCgIHRvdWNoX3JhbmRvbV9wYWdlcyhzaGFyZWRf
bWVtLCAxMDApOwqgIKCgCqAgoCBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJmVuZCk7
CqAgoCBsb25nIGR1cmF0aW9uID0gKGVuZC50dl9zZWMgLSBzdGFydC50dl9zZWMpICogMTAwMDAw
MCAroAqgIKAgoCCgIKAgoCCgIKAgoCCgKGVuZC50dl9uc2VjIC0gc3RhcnQudHZfbnNlYykgLyAx
MDAwOwqgIKCgCqAgoCBwcmludGYoIkNoaWxkICVkIGNvbXBsZXRlZCBpbiAlbGQg7HNcbiIsIGNo
aWxkX2lkLCBkdXJhdGlvbik7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyKiBhcmd2W10pIHsK
oCCgIGludCBudW1fcHJvY2Vzc2VzID0gYXJnYyA+IDEgPyBhdG9pKGFyZ3ZbMV0pIDogNTA7CqAg
oCBpbnQgaXRlcmF0aW9ucyA9IGFyZ2MgPiAyID8gYXRvaShhcmd2WzJdKSA6IDU7CqAgoKAKoCCg
IHByaW50ZigiQ3JlYXRpbmcgJWxsdUdCIGh1Z2VwYWdlIG1hcHBpbmcuLi5cbiIsIFRPVEFMX1NJ
WkUgLyAoMTAyNCoxMDI0KjEwMjQpKTsKoCCgIHZvaWQqIHNoYXJlZF9tZW0gPSBjcmVhdGVfaHVn
ZXBhZ2VfbWFwcGluZygpOwqgIKCgCqAgoCBmb3IgKGludCBpdGVyID0gMDsgaXRlciA8IGl0ZXJh
dGlvbnM7ICsraXRlcikgewqgIKAgoCCgIHByaW50ZigiXG5JdGVyYXRpb24gJWQ6IEZvcmtpbmcg
JWQgcHJvY2Vzc2VzXG4iLCBpdGVyICsgMSwgbnVtX3Byb2Nlc3Nlcyk7CqAgoCCgIKCgCqAgoCCg
IKAgcGlkX3QgY2hpbGRyZW5bbnVtX3Byb2Nlc3Nlc107CqAgoCCgIKAgc3RydWN0IHRpbWVzcGVj
IGl0ZXJfc3RhcnQsIGl0ZXJfZW5kOwqgIKAgoCCgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RP
TklDLCAmaXRlcl9zdGFydCk7CqAgoCCgIKCgCqAgoCCgIKAgZm9yIChpbnQgaSA9IDA7IGkgPCBu
dW1fcHJvY2Vzc2VzOyArK2kpIHsKoCCgIKAgoCCgIKAgcGlkX3QgcGlkID0gZm9yaygpOwqgIKAg
oCCgIKAgoCBpZiAocGlkID09IDApIHsKoCCgIKAgoCCgIKAgoCCgIGNoaWxkX3Byb2Nlc3Moc2hh
cmVkX21lbSwgaSk7CqAgoCCgIKAgoCCgIKAgoCBleGl0KDApOwqgIKAgoCCgIKAgoCB9IGVsc2Ug
aWYgKHBpZCA+IDApIHsKoCCgIKAgoCCgIKAgoCCgIGNoaWxkcmVuW2ldID0gcGlkOwqgIKAgoCCg
IKAgoCB9CqAgoCCgIKAgfQqgIKAgoCCgoAqgIKAgoCCgIGZvciAoaW50IGkgPSAwOyBpIDwgbnVt
X3Byb2Nlc3NlczsgKytpKSB7CqAgoCCgIKAgoCCgIHdhaXRwaWQoY2hpbGRyZW5baV0sIE5VTEws
IDApOwqgIKAgoCCgIH0KoCCgIKAgoKAKoCCgIKAgoCBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9U
T05JQywgJml0ZXJfZW5kKTsKoCCgIKAgoCBsb25nIGl0ZXJfZHVyYXRpb24gPSAoaXRlcl9lbmQu
dHZfc2VjIC0gaXRlcl9zdGFydC50dl9zZWMpICogMTAwMCAroAqgIKAgoCCgIKAgoCCgIKAgoCCg
IKAgoCCgIKAgKGl0ZXJfZW5kLnR2X25zZWMgLSBpdGVyX3N0YXJ0LnR2X25zZWMpIC8gMTAwMDAw
MDsKoCCgIKAgoCBwcmludGYoIkl0ZXJhdGlvbiBjb21wbGV0ZWQgaW4gJWxkIG1zXG4iLCBpdGVy
X2R1cmF0aW9uKTsKoCCgIH0KoCCgoAqgIKAgbXVubWFwKHNoYXJlZF9tZW0sIFRPVEFMX1NJWkUp
OwqgIKAgcmV0dXJuIDA7Cn0KCgoKCkFtYXpvbiBXZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2Vu
dGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpHZXNjaGFl
ZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJh
Z2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6
OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


