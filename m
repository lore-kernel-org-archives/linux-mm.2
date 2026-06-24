Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C01CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 08:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D156B008C; Wed, 24 Jun 2026 04:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE256B0092; Wed, 24 Jun 2026 04:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13496B0093; Wed, 24 Jun 2026 04:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4CD86B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:07:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2578EC159B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:07:05 +0000 (UTC)
X-FDA: 84914075610.04.3FD2CE8
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id E110B1C000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:07:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JI8c+5Jd;
	spf=pass (imf21.hostedemail.com: domain of "prvs=628d474b5=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=628d474b5=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782288423;
	b=6zJu8Cx27yJG0ldqDXZHNM99MPiT66608mdEPHdKyJNJzSW+LOEjR1UvzIoqkF3vkv93fK
	dhJiPtdLPBesjzXwfJAphhJftIkKSsvhXW+O6OwkuWXKc6KWjCVlawTxtXVqhAx5sQn7cg
	lTG/upBIl6FI82c8wBtP8osmyE5Ygx0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782288423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZR15EF6KouS6szTO561diYicLRjtT7IE5fQB79fYCw=;
	b=MvIYOCaZpmFmIrM45rTdJv/6wiRQ5O2TXV4YJ/7qIoE7hc8B/XJfAOHj+k+5UHjbd6KRDr
	sbcz6JAvAonUb34/tqh7czLXMOab2JxFxmQambcqVv1112nUYBe0P7Ks4gTuVa2/g220fi
	B6ttqq1moy28YPepRaeaRel1zhO+fe4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JI8c+5Jd;
	spf=pass (imf21.hostedemail.com: domain of "prvs=628d474b5=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=628d474b5=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1782288423; x=1813824423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nZR15EF6KouS6szTO561diYicLRjtT7IE5fQB79fYCw=;
  b=JI8c+5Jd/b3+RB0R+mijXR0Rk71Eo1fhePL3kkw8XT67Q9joJQFKlD2S
   QRQnjom7EePVQ3h/kYE7vKwtXQT3RVW83DSw4U+m7BF6rBEvr8yhbmfqX
   0+oIaEG03ByXC6L80EWTVzaGgUdkjxdv7I+88aSJW8dEPD5iMjyAy7NGV
   Ljub8qatKOMEUo7HLqVD5mX0SlIA5dqMAjypWem9YN3nZrvNPWA5JJTjA
   6VVnAM+vogXYUdHhWaRr9KIGHW1sYGjNQPR/iCYOr7hqId9LexFSzOqBj
   29OQRPjViXXAUjAXO4nkl/0VM3zzSrKkz/MEFlIfQGQ5Jq11mO1D2XSW9
   w==;
X-CSE-ConnectionGUID: g3+X2/sKSTujZO2OAIqXeg==
X-CSE-MsgGUID: PQkeQQT1QfWH330JRhKmtQ==
X-IronPort-AV: E=Sophos;i="6.24,222,1774310400"; 
   d="scan'208";a="22374892"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 08:06:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:20384]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.192:2525] with esmtp (Farcaster)
 id d632f5d8-b7fb-42c8-a271-d3c8ef86dcf4; Wed, 24 Jun 2026 08:06:58 +0000 (UTC)
X-Farcaster-Flow-ID: d632f5d8-b7fb-42c8-a271-d3c8ef86dcf4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 24 Jun 2026 08:06:58 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 24 Jun 2026 08:06:57 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <ritesh.list@gmail.com>, <willy@infradead.org>
CC: <dipiets@amazon.it>, <abuehaze@amazon.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<dipietro.salvatore@gmail.com>, <djwong@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<vbabka@suse.com>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Wed, 24 Jun 2026 08:06:36 +0000
Message-ID: <20260624080639.17100-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260527162412.19922-1-dipiets@amazon.it>
References: <20260527162412.19922-1-dipiets@amazon.it>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D041UWA003.ant.amazon.com (10.13.139.105) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E110B1C000B
X-Rspam-User: 
X-Stat-Signature: w3xw9sybeor7gbrqw5gc57gz1k6f5jrq
X-HE-Tag: 1782288422-388371
X-HE-Meta: U2FsdGVkX18QaSp2Fzbga7EI1o9js0UOvbosxNMbDUmks8PmRHiFK79s4LV40ZLxuHT7qF2Md/XQCXlp4lPMPEgb8/kIQbfNfMAdoUiF4YydgFhMarCEq7ZrybaXrDJvzw5TUj3xJSKqxJVoAAg1C829KaD9NIJq4aRfrSF9XISdn/XHSDZqyT+t+Xj3zBl38AegsbTs4REG2TIg+X452FaLcp3DxRqeTUXdNSZ5IpsbucnRktVJqw8zTyk9jAULyE0at5ody4uleJaTW9RRxtU1x8Z9wGnipTinsimyHphQ9WRb8gLo/bHaUAmBhnnY5nA7GQn7YabLCMaO5p24Gz3T77tQjX8iO4d3HKbH2QtWOauD4AKiqDOASnim/qBgXUNm49EpinwVE13kBYzbiaWqmlnzXDy8YpWzkHgVetuthuIvddVy6gLI+lCcnxSM/L97ycogEAAxJanWrafvZOg9UCWWGQ4oWw+s633lusbRAdVCiUAUMSSqGeRpPvgjUACeLoLcGgudMBjv1hGxKLj8iklfhOusiRitXRRWCGvMuuCToxUbmFk7HlTfNCnWUnuZIL9cgsqafk74XxjdsmGReXfBmQF3QydbzGJRf5qb1oazHIUyfJAcO/F/KCKbhqPiQS807R14VD/eQ7craLyKRtFgKpNBFTslfICMnPUoTh2rYWbDoM1TZVkKB/vgcumRj/IlHplP66J+iwzJe1S3m5fG0bOeyG9DmfjVINJnXOqXz2tZjsmXrClaAsBzvVbecFiAgEEUbbpIJQacs0htsI69MlNuuVDCB8lcXtX4cNEmRXxXBA6ud8nk/3IKUrppS9dMyBcyGv6J9mfjEBkm1iedxodKLcxjzdVGrsA3UYv7VLutYmvATwzLF25fqbw/y74I4sIgxkVBuU2kvxi1GfDWoyzH0kNryc0UptK/7e8wCp3bqsW7jjM3oLj698vPsddnLgCYLf2JcOR
 UGRVlOO6
 HdZBs2Hv+Yq8ZbAAD6AeJLEDagdujDJBV7LxIOWf+GZGeOVyFbx1lv18hkxH3eHJorPRAkGD1SxgmNyGnC0UqrOi1Afxt6CoM3RCwIsTRI7GHfgixZvoIFJ8TDHsmwUxacN/Hsn11ybo67U2ezq3bHnkX+6MMNuueW/7eDWqzQEqb3nGvuHsKbLXOPB41ZAlQEJHIBQTidI/qhAJcodAb4/gXlL/rsSdKT3DV0Vzs7JGYzV1CEZu8QQZynLISSCrCA1DxSnwNzUUbURxFyL4KVDCUhf4zAt1gy5lbr6sN1fRqR9hUNajEZ2a1llP3nNnF9JNTK+AKtz0AJS5pIr+c++I3ih/zW+gVQQ2XubBeQejKcbxB2exDo6J5wjVrweappuD+FJkzYgPYmJcKXoNtr1CjYT6M6sP5rSQmiLSTqbxcmWUqdyFjPl2uHisF+BZl1wVQiq9/df8YuDIHcq1Bz1pYC35Jiw9LWWA1mu11Hi9daX/8bys/Y9N3i6Fn8o/rizadzZkeqRx/6ReziZi9wZodbubImQUrMmR8y+bqdNqPBAFK085Kx/XwsfAhCkCmSpflSfey93CZs0AaHHmsddIZIYnaQgI/avwLed5fnjINDEQQDWP0rH3WrU8IMtspvuN8M5LaHSfsGAnxErFhB+9xsLrUp+4dzstl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CkhpIFJpdGVzaCwgTWF0dGhldywKCkkgd2FudGVkIHRvIGtpbmRseSBmb2xsb3cgdXAgb24gbXkg
c3VtbWFyeSBmcm9tIE1heSAyN3RoIHJlZ2FyZGluZyB0aGUgYmVzdCBwYXRoIApmb3J3YXJkIGZv
ciB0aGlzIHBhdGNoLgoKVG8gcmVjYXAsIHdlIGJlbmNobWFya2VkIGFsbCBwcm9wb3NlZCB2YXJp
YXRpb25zIGFuZCBzaGFyZWQgdGhlIHJlc3VsdHM6Cgp8IFBhdGNoICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IENoYW5nZSBMb2NhdGlvbiAgICAgICAgfCBBdmcgVFBTICAgIHwgJSB2cyBCYXNl
bGluZSB8CnwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS18LS0tLS0tLS0tLS0tfDotLS0tLS0tLS0tLS0tOnwKfCBCYXNlbGluZSAobm8gcGF0
Y2gpICAgICAgICAgICAgfCDigJQgICAgICAgICAgICAgICAgICAgICAgfCAxMDEsOTc5Ljc1IHwg
ICAgICAg4oCUICAgICAgIHwKfCB2MSAob3JpZ2luYWwsIGlvbWFwIGNhbGxlcikgICAgfCBmcy9p
b21hcC9idWZmZXJlZC1pby5jIHwgMTQxLDE5NC4yMCB8ICAgICszOC40NSUgICAgfAp8IFJpdGVz
aCdzIHN1Z2dlc3Rpb24gICAgICAgICAgICB8IG1tL2ZpbGVtYXAuYyAgICAgICAgICAgfCAxMzks
MjAwLjYxIHwgICAgKzM2LjUwJSAgICB8CnwgTWF0dGhldydzIHN1Z2dlc3Rpb24gICAgICAgICAg
IHwgbW0vZmlsZW1hcC5jICAgICAgICAgICB8IDE0Myw4NjMuODIgfCAgICArNDEuMDclICAgIHwK
fCBrY29tcGFjdGQgYmFja2dyb3VuZCAgICAgICAgICAgfCBtbS9wYWdlX2FsbG9jLmMgICAgICAg
IHwgMTM0LDI3OC40NyB8ICAgICszMS42NyUgICAgfAoKSSdkIHJlYWxseSBhcHByZWNpYXRlIGFu
eSBndWlkYW5jZSBvbiB3aGljaCBkaXJlY3Rpb24gd291bGQgYmUgYWNjZXB0YWJsZSBmb3IgYSB2
MyDigJQgCndoZXRoZXIgdGhhdCdzIHRoZSBwYWdlIGFsbG9jYXRvciBhcHByb2FjaCAoa2NvbXBh
Y3RkIGJhY2tncm91bmQpLCBvbmUgb2YgdGhlIGZpbGVtYXAuYwpmaXhlcywgb3Igc29tZXRoaW5n
IGVsc2UgZW50aXJlbHkuCgpJJ20gaGFwcHkgdG8gdGVzdCBhbnkgYWRkaXRpb25hbCB2YXJpYXRp
b25zIG9yIGRpcmVjdGlvbiB0byBtb3ZlIHRoaXMgZm9yd2FyZAoKLS0KU2FsdmF0b3JlCgoKCgoK
QU1BWk9OIERFVkVMT1BNRU5UIENFTlRFUiBJVEFMWSBTUkwsIHZpYWxlIE1vbnRlIEdyYXBwYSAz
LzUsIDIwMTI0IE1pbGFubywgSXRhbGlhLCBSZWdpc3RybyBkZWxsZSBJbXByZXNlIGRpIE1pbGFu
byBNb256YSBCcmlhbnphIExvZGkgUkVBIG4uIDI1MDQ4NTksIENhcGl0YWxlIFNvY2lhbGU6IDEw
LjAwMCBFVVIgaS52LiwgQ29kLiBGaXNjLiBlIFAuSVZBIDEwMTAwMDUwOTYxLCBTb2NpZXRhIGNv
biBTb2NpbyBVbmljbwoKCg==


