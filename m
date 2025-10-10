Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E588CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 06:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A2B8E0007; Fri, 10 Oct 2025 02:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6406E8E0002; Fri, 10 Oct 2025 02:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555CF8E0007; Fri, 10 Oct 2025 02:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8A58E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:07:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D316883F02
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:07:17 +0000 (UTC)
X-FDA: 83981172114.01.547A391
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9AC6640014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:07:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ivy9RZH2;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf01.hostedemail.com: domain of "prvs=371de6772=acsjakub@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=371de6772=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760076435; a=rsa-sha256;
	cv=none;
	b=WgXwP6oROfgOwzWzIACQ89UNKDvAmf/RVkiUQMA3hPnWJXieHLwyynY9Hmy7I5StH0kRls
	N2HaQTF4M+lh7aEXI+yrSLL/M929l7LBYEoicH2d9/+BfjaOrdKGrXK7gMARrIUfV5k09Z
	3QHVQEc4g4VSNpcY37ltuNEvbT2xBHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ivy9RZH2;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf01.hostedemail.com: domain of "prvs=371de6772=acsjakub@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=371de6772=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760076435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJdYbEdswEL2qtCJ2STUf7ntn6Iq6i8d56dp1sDUz3Q=;
	b=b+/FP8slvkouFdzxKXbMJv8XSOeuE94itfVF9I+4grT06ouiqZ2lYpaXSho9M6dYI06k1P
	/lEwKoeCMAlqf4DgztxcBBK3gZsxdgtFtS7wIPVceBZ9RjiQrdeCfLIci9cvL/fZpfoISu
	APvNVvUYI8vqMd4k4LNV9U83DgX5tX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1760076435; x=1791612435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=WJdYbEdswEL2qtCJ2STUf7ntn6Iq6i8d56dp1sDUz3Q=;
  b=ivy9RZH2srAKXKhggr1xe6Jv0yaaO2BUIcZG6+MGIyWOLGJbVD/dTi5l
   TWY6+8BSgEUSusdzgUXfR5MQguV692yWz6UESafBjmog4SmZphTSUikDo
   qzLUt49+Fn/WzvLpoelm2lALTrR2KA212MBSZEQ+SGp7UfnaXJboLr2KE
   VxrjtPNtYsGmTK3+9OzcLBC4nw8hxYdIEBpVLzMOkCDGiMYoTZCydkPBo
   u91IH+a5+eafzkAwJrSVlO6QNgotIiGyOYWVKZSUbvztlY1Tw2H+S/xdr
   wDmlw1r5ezrkEDIRkoH7zuSTVe94yo/+dzScqKY+y5QMVyRZ0uG1MA75T
   Q==;
X-CSE-ConnectionGUID: +GroEsTKQluxlXnMqrVBhA==
X-CSE-MsgGUID: mAboILn4T3iTSWY6Z0Jzvg==
X-IronPort-AV: E=Sophos;i="6.19,218,1754956800"; 
   d="scan'208";a="4447007"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 06:07:12 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:42599]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.171:2525] with esmtp (Farcaster)
 id bd58cc9d-fc6e-4c2e-8deb-efc1ee480171; Fri, 10 Oct 2025 06:07:12 +0000 (UTC)
X-Farcaster-Flow-ID: bd58cc9d-fc6e-4c2e-8deb-efc1ee480171
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 10 Oct 2025 06:07:12 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 10 Oct 2025
 06:07:10 +0000
Date: Fri, 10 Oct 2025 06:07:08 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, kernel test robot
	<lkp@intel.com>, <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda
	<ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value
 `VM_READ` in crate `bindings`
Message-ID: <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <202510100127.yuqhg8uo-lkp@intel.com>
 <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: base64
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AC6640014
X-Stat-Signature: rophyaxw5fmb1k9gfhnm7z38u91mdadd
X-HE-Tag: 1760076435-726273
X-HE-Meta: U2FsdGVkX18AoIfxKQd5Q0g4BquRxJbizgvk9jU1x1oSTG+7lf2fMv6AbVhtBYPOCExrpJ5R/6as7qaSZi095kC3dKh2FXqmopkMM6iXVH+3+d7SbvlA6bgTd07HPe0aDky7UsVjcDLhO5EP7SDW8c31NHw2R3DFOwLdL41PR5cbB2I+3bpGuhnAAHGPXuZRk92Wvv9tB/5p8weGbJmazuJlEbpdeMmMCsIy2z0LIVFoMROdjDU1kO8xKhJUn5tk0n0unPdJlm0brO0Cohe2TnNov+6oQefc70NswkVVm+rWQTMWR8i3tnq3zoa02TEx/73iLyIylBLIGTttUjycXJk4v8kWOffMpNhE5i+1PnDUGHXyAcE+72kw5X9H4wmgomQPGB7kd45FWsj01dzOaawdMxsjid7FvEQNBlDfab8Ki87lGIQ9sqxWwyhYrQkPYzfdcmUO0LlwG9CzcVTRqgMbpQ2zrPTsk8ugzfeW8SkBkjsmQJf7lRtTqiDU8eCKBJQDM1sotuljevEPArOef1wU90FgZ+IOLun8JZGch46/AVEls1aICIXq1TrSrYvyN5Jonqwx3GekjaSJwKwXymOsPdU+TJzZhVAaa29stVUEI7FcaaIydEz55bYBCa4rvgsw17+K0cp0kx1lpqtCFkvKAG0Ftk6QYL+Z6HkrxV8mxGRkg2Pp4EPBzVOsoDxEhcAYrAaBF+ZWWQ0wFn4TNAv1FO4X6L9o18F2kE/VaR193H3TcnJ93o/kaX2AciEgx1R/WLmFmf6qQl2KA2YiEpP+rCUEN28vWiIjH/MHiqbQcrdGrUI+o/OncP1iIixlrJtpnV2nn8SAXut1PiSbPBdgL11wPuM6QAy5Mp2qBenUjVvAvlKO+RsGzyx0jcaWLP035G0yRt66ifImwRp2M/e/Tb6XybExYzPcnkNyJ3tvB1VtH5GRSvRClGKrirSM6kip5RKV1UHNkRn/MPT
 BT/9mx1l
 Dp24HdG3NvyHB0hGLnxDIWLVsDlRYuaFFxtJiN08/inJ6G99qzL2HWHIDczrscaw+CFgzxNWWmlAgKiJljX8NCaBTbt95Stf4OME/cBJtV3SDe0qFGDhDg9fc0GRTrtaMXJue7olCcOCn112Pa810ejnx8tF+Pdadmt28Y/wLO+53fwGbeJa8USMQjt1xsqmqvVhGpp1LgQ1NIGQtsryx9A0rWnXa5YszFf5G+AmONK6kKveNXY3PBp72Av2MuKR55dLRGeO+Q08hntI8f85LY6Tjiy3dzwbP0W/5NfFIirr13Yde7WxnGRojv3IMivliJrxe+chCw2fzInZWPtaEZcmyLuQsqRTqTZcmZPYVKdkjKFgFXD3oI+onvkIT5R9fxft8kLoSJ42QmKCntAh8KHDPqCAYYsGkfn9VJpNh8V0p0VYDYGUs0vq9EcaVCP7Wwc+s51TcMOxm1nnKn6vC3KMk4ZGjT7/SB3iHC9kg7A5RUr20V9c33FzBBdEFzwyGbP+FD2OJ3w2rJQHMvfD0BlEjBZNH/nUi6Cgf1StRk+rX+Rlyo+0xJnfbbPVTv/j4cBZYN/ib2xjfnjU1qcrvfmKKacQDqncHJ1LL12hskTzbtX7348NAnIAg4TgKqEsrvl7obqdn1rijrG95EkxD5pnfBuPRGj2gJu2M8vPi2hqE92YS2X/kQ7dDyZIang94OJqJvC0EepCZnEK7AtOVDn/8wfa/4jPyA+ShoCLq4WAqX197WPRDC383BA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCBPY3QgMDksIDIwMjUgYXQgMDg6MTQ6MDFQTSArMDIwMCwgTWlndWVsIE9qZWRhIHdy
b3RlOgo+IE9uIFRodSwgT2N0IDksIDIwMjUgYXQgODowNeKAr1BNIEFuZHJldyBNb3J0b24gPGFr
cG1AbGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+ID4KPiA+IEFsaWNlLCBNaWd1ZWwsIHBs
ZWFzZSByZW1pbmQgd2hhdCB0byBkbyBhYm91dCB0aGlzPwo+IAo+IFdlIGNhbiBlaXRoZXIgZGVm
aW5lIGhlbHBlciBjb25zdGFudHMgaW4KPiBgcnVzdC9iaW5kaW5ncy9iaW5kaW5nc19oZWxwZXIu
aGAgZm9yIHRoZSBvbmVzIHRoYXQgdGhlIFJ1c3Qgc2lkZSBpcwo+IGFscmVhZHkgdXNpbmcgKGxp
a2UgbGFzdCB0aW1lKSBvciB1c2UgYGVudW1gcyBvbiB0aGUgQyBoZWFkZXIuCgpGV0lXIEFsaWNl
IHN1Z2dlc3RlZCB0aGUgZW51bSB2ZXJzaW9uIGFuZCB3ZSBkaXNjdXNzZWQgYWRqdXN0bWVudCB0
byB0aGUKcGF0Y2ggaW4gdGhyZWFkIFsxXS4gSSB3YXMgZ29pbmcgdG8gc2VuZCBuZXcgdmVyc2lv
biBvZiB0aGUgcGF0Y2ggYXMKc29vbiBhcyBJIGZpZ3VyZSBvdXQgaG93IHRvIHRlc3QgZm9yIHRo
ZSBpc3N1ZSBwb2ludGVkIG91dCBieSBEZXJyaWNrIGluClsyXS4KClBsZWFzZSBsZXQgbWUga25v
dyBpZiB0aGF0IGlzIGRlc2lyZWQgb3Igd2hldGhlciB5b3UncmUgdGFraW5nIGNhcmUgb2YKaXQg
aGVyZS4gQW5kL29yIGhvdyBlbHNlIEkgY2FuIGhlbHAuCgoKWzFdOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvMjAyNTEwMDgxMjU0MjcuNjg3MzUtMS1hY3NqYWt1YkBhbWF6b24uZGUvClsy
XTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUxMDA3MTcwMTU2LkdRMTU4NzkxNUBm
cm9nc2Zyb2dzZnJvZ3MvCgpUaGFua3MsCkpha3ViCgoKCkFtYXpvbiBXZWIgU2VydmljZXMgRGV2
ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIuIDEzCjEwMjQzIEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIKRWluZ2V0cmFnZW4g
YW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJl
cmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3Cg==


