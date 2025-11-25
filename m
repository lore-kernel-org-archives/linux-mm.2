Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C08D0E6EE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE2D6B0008; Tue, 25 Nov 2025 09:24:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6256B000A; Tue, 25 Nov 2025 09:24:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12BF6B0026; Tue, 25 Nov 2025 09:24:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 930CB6B0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:24:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08708138C02
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:24:07 +0000 (UTC)
X-FDA: 84149348934.08.ABA8B0A
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7863214000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:24:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VjiMAbFS;
	spf=pass (imf26.hostedemail.com: domain of "prvs=417c28214=ilstam@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=417c28214=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764080644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWweU0CVEIjFMYrFnn46GWAADSVAe9a+oYcnDo3cVKg=;
	b=KjMaIe+tT28ofrQ2sCYMvPJ2j2KA2VlDI0evl27D0RYSFVYUi0ALmLWfyD4EYDOC7JnmZP
	SEDKdiuUyl75xdy0hZ822RQdlKs4A6AG3IFvUepaoiDNJSCDJnAM2IVFm3WK5/JSAXt71/
	rNggkaj/PrqIy7XuA1G1EPEwNQdgUBI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VjiMAbFS;
	spf=pass (imf26.hostedemail.com: domain of "prvs=417c28214=ilstam@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=417c28214=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764080644; a=rsa-sha256;
	cv=none;
	b=TbGVmd2vAV1Xso3TIaVz8jaRj5PuzXqfOVRxsuAOvckeGazJ/fOkavzB5sDuH/QTMMxbSo
	d2jduqd543cBlXYfQGNF6QaJGNtpbJFQrcYVKlc4GlwOnlheN/vEE8klegIjTncJFtf8kc
	1ax5WNgJvkBlkM7JQy1v8A8IpWDLF18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764080644; x=1795616644;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=LWweU0CVEIjFMYrFnn46GWAADSVAe9a+oYcnDo3cVKg=;
  b=VjiMAbFSVpc4PEhjuDEI9XzLp4QoDWZHDxSo2CcOIfEWhsZ3LdQ3wYWY
   g8ospN97K2p33AJDFO30vpdsdojcHUCqCw87Qh21r/bZiAPCrw8g/4qXJ
   Q2iJe6oZ1WhyMK2abS+KFJg5OUoZN6uHysX/uKQUEYKdvqcmFcxE2y2xS
   LZYERY/h2u+bmQwCvTjTLIpvPcE8TAF4VnK2AEqElj3fA578xPMRwGvep
   vj4g65gFsixCscLCoQtM6jhJxCI7qnyZcff1vMva1SbPvVKQh6adtDM/Q
   ebAqk/GhrczkZzW4ewKf2W1K+HpQSp/JH96CHYXrol/6cOjD5VFpf7E6N
   Q==;
X-CSE-ConnectionGUID: 7V608C6CQDKB4s6ZWbIGqg==
X-CSE-MsgGUID: bToIC8U7RiKSj3K28pvU+Q==
X-IronPort-AV: E=Sophos;i="6.20,225,1758585600"; 
   d="scan'208";a="5667712"
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Topic: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 14:23:46 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:6211]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.211:2525] with esmtp (Farcaster)
 id 5b879075-fbb8-40da-be9b-5206b43e0059; Tue, 25 Nov 2025 14:23:46 +0000 (UTC)
X-Farcaster-Flow-ID: 5b879075-fbb8-40da-be9b-5206b43e0059
Received: from EX19D018EUA003.ant.amazon.com (10.252.50.163) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 25 Nov 2025 14:23:39 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA003.ant.amazon.com (10.252.50.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 25 Nov 2025 14:23:38 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.2562.029; Tue, 25 Nov 2025 14:23:38 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "david@kernel.org"
	<david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"bhe@redhat.com" <bhe@redhat.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Thread-Index: AQHcXXPvH1LA4deF/EiE1v+Bldr5grUCN+QAgAAFBoCAADzNAIAAeugAgAAzyACAAAfmAIAAQqoA
Date: Tue, 25 Nov 2025 14:23:38 +0000
Message-ID: <265028eb24f60ce45725d7887e93f76a3e86f897.camel@amazon.co.uk>
References: <20251124165349.3377826-1-ilstam@amazon.com>
	 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
	 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
	 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
	 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
	 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
	 <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
	 <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
	 <b9f8623fb383ef21bb47e6c9716c2c389581d12d.camel@amazon.co.uk>
	 <aSWDvPVZRTCCfRpV@smile.fi.intel.com>
In-Reply-To: <aSWDvPVZRTCCfRpV@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.106.83.27]
Content-Type: text/plain; charset="utf-8"
Content-ID: <53B8AABC12F9B9488973B75DC5976B8F@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7863214000F
X-Stat-Signature: 15q7izht8mgdy3nkeh833tddn9iaipb5
X-Rspam-User: 
X-HE-Tag: 1764080644-983975
X-HE-Meta: U2FsdGVkX1+DsAqJLHspSVRgUS0Z7AMuKoZEbFeg+31wextTaP67BGRRb52lDtb7DTdtrUtgWInpKm7FalD3PLAdxIivxQCvARLROAjBg8VPvhjljy0xUsZtRieLLg677TRN65OVOGirkMQeLnYSCR69RAttfUCXzOOjBdG4fBq6DyrMqwuEqA2k1e2ofervkgfqB+xY/lzrDyw14sqsaJj7GPVH/hy+4QmNj9k9R7FTRNjYTqRV2jw7C2zIRrabBBeahD4sGjEWwdHd5m/BKmSTz5Px+g+3eHFZKV87KDy3mlQI0c5VDg6XVaK+/1JaHVyCE66sA+RnrBlJuchIIZAhFRhLfgO0VUeC5j3ZpSbYq4YVFt/zPPmC2YqEKuQxK2E6K0Y2B9vvdmRhWZ58NuJzuG1SwXMz1tyhv12WsgYBrXxvKlqGrK68d+u6q1XPvzwJlRNvv3aDiUymjCfZBo99PTMHale/fjB8EkDIevrG4qA9m2vdLo2YgZjdDQ4U6uB9NaUw4YS4/SicdMwv5wWqI9hERYwWaCTY3gE1DCTvI7/rdGbRZbNEGXwRmulcNfwO23trRgpmVPh3GAsBUtFQyQQpdXlRKs1wD21vgXSuT8Gy3kCkstlFJhL2rS2vmcvZv8hUZOi4yZ0l8XPl2UJUzzcwBW7nbcoBjeUMi/Ug408mJG2WPNtWmUzbZFeLn0jBUdC/CoPYPXUEuDsY32QdyzzQUgiBa3J0moer1R3jDbnlXtF+t72b+QOIeFko94GqksGxnKwSHsyPzoGGews1SdeCOIWumJjOrSR7X18obok1WXluNSti0wjw6qDVzXBWrTU3XbndAdVf22lSKD3NS723wA1LSAvKdKG47Q48HHAFitSA6HElsuG/rRlIQm7cNI5iqbEBNCTzy2GzJWANcT/ffbuYZaFSGqgp13QyW3Uz7YhBY6FNgW3Pw4F8gRNJg1RspXE5aXTRR7b
 8tOd0bW2
 +acn3tNdp0ohRAjCK4EOsg2HNeotBoUTceNISaWeCsI5wTMLFtBVIBcVjeGaadxp0Pry8u8Y+ZxJOPDkoQLe7utllot1lDe870mjwKxjw6jhi+Y18zam9RGRh56jwqo+KcZBOgGPyJ1HEds8nNnf7bcJ5HfYnak+Jjz7UB1dE3QhMZBbd6ZqniPih5rMccgLSs3luGuxFKvVWcVN1mweDZKW3U1qBg1nU36p+izSgQoaXX1KoFdxW/w5hAXkvPgI5+8pw4LH2oKcckPXB/w20wTtUqhhuoHLHBpyvRE8vMQmYyH1DWQWWahwdhrq62E+oU54cx09nMI0dgQCUPfHvX/7C9nsayGZ27QK0a2KLGshojuYdC87pPXMx7kOurT3VBue/qohIovXFG2Sh/b9JStTuEYYftrC1lQ62tJjwNBlB0UVsCC83Cppauqgj7SwAvVVGE9rlY0NNlEttmhum/CCc9NF62/CVUIJLn1qHiC2a0dPSAwar7qDcXDjFwpnvoGfzTz6WiBPHBZPT7dQBCPxebxRTy3mk+N5qD/UfEJW/9goZknypnWmgdbaQZBrGUuJ07OCoEbFaRnB8UC+DDjQbukqem6EHR3I1FVGy0eGXJyz5wAALVKPDKUKgLF7084zbEE0sVAoW4s0cuQBuYc0dpfmb05r0nWcRpc3CzFjot8eUVuJiq3QyJaJoR+FtK6/+vCAi0PPtd//OyHZJoAQMlTXJLjOf/QvKBFusLOpFqUx89th/9lBZdyj+GwFMb5Firbp15qq8KWXgp14x/Gwgzhxv74lqzGLxFyPRAOjsEhr4hPfvOIojss9Bt42OB9tjmgNsSeGPwoh/fR49HczMuSEsgYjCIbhkYxRaLLKfFBSomEXjhiPIcqlVVw4UCgjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI1LTExLTI1IGF0IDEyOjIzICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IFRoYW5rcyBmb3IgZWxhYm9yYXRpb24uDQo+IA0KPiBQbGVh
c2Ugc3VtbWFyaXNlIHRoaXMsIGFkZCB0aGUgcGVyZm9ybWFuY2UgdGVzdCByZXN1bHRzIGFuZCBz
ZW5kIGEgdjIuDQo+IFNlZW1zIG9rYXkgdG8gbWUuDQoNCkhvdyBkb2VzIHRoaXMgbG9vaz8NCg0K
Tm8gY29kZSBjaGFuZ2UsIGJ1dCBoYXBweSB0byBzZW5kIGEgdjIgaWYgdGhhdCBtYWtlcyB0aGlu
Z3MgZWFzaWVyIGZvciBtZXJnaW5nLg0KDQpSZWluc3RhdGUgInJlc291cmNlOiBhdm9pZCB1bm5l
Y2Vzc2FyeSBsb29rdXBzIGluIGZpbmRfbmV4dF9pb21lbV9yZXMoKSINCg0KQ29tbWl0IDk3NTIz
YTRlZGI3YiAoImtlcm5lbC9yZXNvdXJjZTogcmVtb3ZlIGZpcnN0X2x2bCAvIHNpYmxpbmdzX29u
bHkNCmxvZ2ljIikgcmVtb3ZlZCBhbiBvcHRpbWl6YXRpb24gaW50cm9kdWNlZCBieSBjb21taXQg
NzU2Mzk4NzUwZTExDQooInJlc291cmNlOiBhdm9pZCB1bm5lY2Vzc2FyeSBsb29rdXBzIGluIGZp
bmRfbmV4dF9pb21lbV9yZXMoKSIpLiBUaGF0DQp3YXMgbm90IGNhbGxlZCBvdXQgaW4gdGhlIG1l
c3NhZ2Ugb2YgdGhlIGZpcnN0IGNvbW1pdCBleHBsaWNpdGx5IHNvIGl0J3MNCm5vdCBlbnRpcmVs
eSBjbGVhciB3aGV0aGVyIHJlbW92aW5nIHRoZSBvcHRpbWl6YXRpb24gaGFwcGVuZWQNCmluYWR2
ZXJ0ZW50bHkgb3Igbm90Lg0KDQpBcyB0aGUgb3JpZ2luYWwgY29tbWl0IG1lc3NhZ2Ugb2YgdGhl
IG9wdGltaXphdGlvbiBleHBsYWlucyB0aGVyZSBpcyBubw0KcG9pbnQgY29uc2lkZXJpbmcgdGhl
IGNoaWxkcmVuIG9mIGEgc3VidHJlZSBpbiBmaW5kX25leHRfaW9tZW1fcmVzKCkgaWYNCnRoZSB0
b3AgbGV2ZWwgcmFuZ2UgZG9lcyBub3QgbWF0Y2guDQoNClJlaW5zdGF0aW5nIHRoZSBvcHRpbWl6
YXRpb24gcmVzdWx0cyBpbiBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMgaW4NCnN5c3RlbXMgd2hl
cmUgL3Byb2MvaW9tZW0gaXMgfjVrIGxpbmVzIGxvbmcuIENhbGxpbmcgbW1hcCgpIG9uIC9kZXYv
bWVtDQppbiBzdWNoIHBsYXRmb3JtcyB0YWtlcyA3MDAtMTUwMM68cyB3aXRob3V0IHRoZSBvcHRp
bWlzYXRpb24gYW5kIDEwLTUwzrxzDQp3aXRoIHRoZSBvcHRpbWlzYXRpb24uDQoNCk5vdGUgdGhh
dCBldmVuIHRob3VnaCBjb21taXQgOTc1MjNhNGVkYjdiIHJlbW92ZWQgdGhlICdzaWJsaW5nX29u
bHknDQpwYXJhbWV0ZXIgZnJvbSBuZXh0X3Jlc291cmNlKCksIG5ld2VyIGtlcm5lbHMgaGF2ZSBi
YXNpY2FsbHkgcmVpbnN0YXRlZA0KaXQgdW5kZXIgdGhlIG5hbWUgJ3NraXBfY2hpbGRyZW4nLg0K
DQpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTExMjQxNjUzNDkuMzM3Nzgy
Ni0xLWlsc3RhbUBhbWF6b24uY29tL1QvI3UNCkZpeGVzOiA5NzUyM2E0ZWRiN2IgKCJrZXJuZWwv
cmVzb3VyY2U6IHJlbW92ZSBmaXJzdF9sdmwgLyBzaWJsaW5nc19vbmx5IGxvZ2ljIikNClNpZ25l
ZC1vZmYtYnk6IElsaWFzIFN0YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4NCkFja2VkLWJ5OiBE
YXZpZCBIaWxkZW5icmFuZCAoUmVkIEhhdCkgPGRhdmlkQGtlcm5lbC5vcmc+DQoNCg0KDQoNCg0K

