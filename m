Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB1DCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C5C6B008A; Thu, 25 Jun 2026 05:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECE06B009D; Thu, 25 Jun 2026 05:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE2E6B00A1; Thu, 25 Jun 2026 05:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A6A6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:11:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9F6740646
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:11:06 +0000 (UTC)
X-FDA: 84917865732.14.6D25F2C
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1474A000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:11:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JdqxJYsp;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf15.hostedemail.com: domain of "prvs=62906d379=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=62906d379=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378665;
	b=vJ0EtHfJ12hI0E03iLFASqEvyHir91eyRxCx/6f4+ih2ePBwTjBZgNIqEHn2g65u5s0yGu
	WH9zFYMXlLrLr0H/hHFP2SDImLO4BpNbxc8kzuwCPGsiUlnI4/5CftK1pF/Y7D/xIPQ0md
	L9zdwq/ABazeoDTJ8iETTkwscGrx/24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oE928MWpjpguJbmMgOw+gSkPCYeo6lVM91/zGpnGPn4=;
	b=m7QinfkBtGTu7HO/NaJ6o1Xeula7nYUGXPalSRzpySqr4uOIxj3K7zdsyyrItDx//1wOXI
	FbktOGmBFp3nbGiDGQyCXybMF99DAnEWsr/K8Upi3RXnkuGc5VOLVWe3eDqjJAy97Emq+S
	ycDKLLxiybLk11qTFnFtOQIRosNR04Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JdqxJYsp;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf15.hostedemail.com: domain of "prvs=62906d379=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=62906d379=dipiets@amazon.it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1782378664; x=1813914664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oE928MWpjpguJbmMgOw+gSkPCYeo6lVM91/zGpnGPn4=;
  b=JdqxJYspKNXeA1OD4UdLrFwIBaqNtaBf7KkMRp8E9VqonFQ7wqPf/JJz
   Kff+Qv1HBYXzV98dbH29J1Nwce7rszoB/Z767H8Uif1rkKChD4MlMZSNt
   qS5KLiW8ZlppQWuuDHl5N8BQY1T3KQ/O0Yo8pgCD++zTibTIAt/0P3cOw
   3yRBYeYR9cVVT20hG9rDTHmAdYMRfseViMBGQygNNFnQ75cI/ESSO+kLk
   la/FDDawATRAJdcNR/uy+xtPDrosVl1nDpuSyL2RAStDXSRFotu63KQWj
   3K8l4pKciYEKc8i06t51sYp2vFuzOjynxMtbw1kWIOd7pS8trYAg7U92j
   g==;
X-CSE-ConnectionGUID: BHvSDaCTQDGldW/+GkcQGw==
X-CSE-MsgGUID: T6GC85OPQZqEzuE/bVyVkw==
X-IronPort-AV: E=Sophos;i="6.24,224,1774310400"; 
   d="scan'208";a="22495960"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 09:11:00 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:9509]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.116:2525] with esmtp (Farcaster)
 id 53b71abc-ee40-4912-bc3d-4b91185244a3; Thu, 25 Jun 2026 09:10:59 +0000 (UTC)
X-Farcaster-Flow-ID: 53b71abc-ee40-4912-bc3d-4b91185244a3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 25 Jun 2026 09:10:59 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 25 Jun 2026 09:10:58 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hch@infradead.org>, <ritesh.list@gmail.com>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <david@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <ljs@kernel.org>,
	<mhocko@suse.com>, <rppt@kernel.org>, <stable@vger.kernel.org>,
	<vbabka@kernel.org>, <vbabka@suse.com>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Thu, 25 Jun 2026 09:10:37 +0000
Message-ID: <20260625091039.24501-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ajvc7fSDngyx0X5j@infradead.org>
References: <ajvc7fSDngyx0X5j@infradead.org>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1474A000A
X-Rspam-User: 
X-Stat-Signature: 631srwwpprenobe68q4gyt9j9obxsi4b
X-HE-Tag: 1782378664-814286
X-HE-Meta: U2FsdGVkX1+Q7i3xgTZ22DvrdRyveC1Bhk/9CsEF3S3MBnzdjOrP2i7dl0tq0uBiyoQ6R2JPMgOWUcOqR9qtPuJi4Cam+PnWgjImm+iU23cqxILF7bPeiqOPDtQNHsVr6EtZP9wmOuTZ5QO862uygMG7yZa/xIcT6rGhPZLtKNlyMZ0VQMuEmrjP5Wxkr2vVuOyNYlSH0FcfaECIypMy9R0clDmO84GsVvajp2QQFEESm7qYHxwnWqPK7Mcgt2kmNcLYANxTpGXkUeuJ447i5kzjOv0qAhOb4EUc8t98gE27Zua7HtTBxhqCDW6lva0t8dmU7Quwg1X0XWjs5V77+M5eKTiHZeT48xKynIi+rWP8VVsgglYh1+5rDSsCSakpMZvdjX2lF2MOjQoDiWQtXgO7ctM9uBOYmCxKXn6rdQxsqjxBGlMrTIjcwSMFi5U8Q9CBQLemnQgIdzCUNy38GpRFP1bVnXlpP4w3624+fq5edaqynuUsxkjS4A2vuKOgnBqpCM/PptSrr5FKO8fRvmiGdcWEQ9mcxzQlVoHgU8V1oneh2/WaXKoQRLeanutnQzk54sKSgXYP0zjS3VjFzG8YzsmK9oOqAQ/lr+r9E1jhyFUKq1V20S0tvQDefYJm8SH/EHGYNL8pzrngkxx670R1mPl8HFBnmkg9m2pB43omKfvexaxFRdaZf3+VCOOUE231RqKW9ukzubQgEgGzyRB4rEiwshEIXFnsltV9X5usS7GcJLtm+6gXDx7OGD/eiZJRNlFRl/EY6A6MgbVcSmYi21fb9yNvgdg2HE7KmY9ViV6ZNN12DcI7Q4kp6MwNt+MVoPhE6z/2Wtd/DdYd9gBZOFmz1FpTdusoBZttChZ6F7C07wrXzqpSeLJqIAqgqB4bNn5qMvOqp8nESc3VQnUo7rQDZ5OO4E6qnabZoe/K/n8GX01ToYU86jGPZ38qZuCz/UZUaObVHYyuk55
 q1fbBvMj
 EI2zaQyMxjfLTcSjktF/ZaSk+BE6Q8QMKUjmQz/2wzX6gQv0c+StB2X/BL0c2R7sImk3xFO7UR1X72YWc7aSMmI6RTV0XWUiTvGMXGU1DBp0bDsCU9Fa1+cTfzoFLGPOdCpPJMKhynt6NJzAGwVc2Ud2RaUMXZxEVveo6QuR4F9WYryaxhVWsB0JAy07BzAao5PgM7vMntJKltNtAEQjQ0f80mduyWAfZcJWbPOATYRis2XCZ1YO46HdOgNTUAHND3TVxlKkjtBk/T+pScrbE1LrzQCx0LR5nkHsCYpdPY0CdDalxrmnxqMHVk3c+I3ED7nmxmNLWu9GTRlqOzmpL8NRDUam+A6q2TJ8KiS5Ym+nqhH5aEj3X3BpbgTy62KbHMDrCVFC5qZxxKE4dRWKM4T2S6VM2rkRnJDUa2peszG7rYoMtSP5pJDVaw10dLNxWY33ImOvzD8sZ3Qpq9n5yReG/l14zeHAPgGhXLeVHG5/za0L3uzg/gu3VhtjDv4nVTVrImnsxp8vTZ4h4l4RNGbp3ppdAc/l3kYIjvqvh5IWRXe9B85N6zMtLxfhBCZZEvDo4thi94OpbJv2ZFzXrBMT3+BKCRUcDL+0wcgSu4Jedo8vOcuxAHiGlIhrg/tp/fklxl3xNpoEfU5hEYHzt7oqQmGacXYzQ0qfkAEoj2mGqdEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCBKdW4gMjQsIDIwMjYgYXQgMTI6MjE6MDBQTSArMDAwMCwgUml0ZXNoIEhhcmphbmkg
d3JvdGU6Cj4gU29ycnkgYWJvdXQgdGhlIGRlbGF5LiBJIGRpZCBicmluZyB0aGlzIHRvcGljIHVw
IGluIG9uZSBvZiBvdXIgaW50ZXJuYWwKPiBleHQ0IGNvbW11bml0eSBjYWxscy4gQW5kIHRvIHNo
YXJlIHNvbWUgY29udGV4dCwgTU0gY29tbXVuaXR5IHRoaW5rcyB3ZQo+IG5lZWQgYSBiZXR0ZXIg
bG9uZyB0ZXJtIGZpeCBmb3IgdGhpcyBwcm9ibGVtIHJhdGhlciB0aGFuIHBhdGNoaW5nIGNhbGwK
PiBzaXRlcyBhbmQvb3IgcGxheWluZyB0cmlja3MgbGlrZSAtIAoKVGhhbmtzIFJpdGVzaCBmb3Ig
dGhlIHVwZGF0ZSBhbmQgZm9yIGJyaW5naW5nIHRoaXMgdG8gdGhlIHdpZGVyIE1NIGNvbW11bml0
eS4gCkkgY29tcGxldGVseSB1bmRlcnN0YW5kIHRoYXQgdGhlIE1NIGNvbW11bml0eSBpcyBsb29r
aW5nIGZvciBhIHByb3BlciBsb25nLXRlcm0KZml4IHJhdGhlciB0aGFuIHNwZWNpZmljIHBhdGNo
aW5nLgoKCk9uIFdlZCwgSnVuIDI0LCAyMDI2IGF0IDEzOjM0OjAwUE0gKzAwMDAsIENocmlzdG9w
aCBIZWxsd2lnIHdyb3RlOgo+IERvIHlvdSBoYXZlIG9pbnRlcnMgdG8gdGhlIHBhdGNoZXMgZm9y
IGVhY2ggYXBwcm9hY2ggYWJvdmU/CgpZZXMg4oCUIGFsbCB0aGUgcGF0Y2hlcyBpbiB0aGUgcmVz
dWx0IHRhYmxlIGFyZSBzaGFyZWQgd2l0aGluIHRoaXMgdGhyZWFkOgoKdjEgKG9yaWdpbmFsLCBp
b21hcCBjYWxsZXIpOiBUaGUgb3JpZ2luYWwgUEFUQ0ggMS8xIGluIHRoaXMgc2VyaWVzClJpdGVz
aCdzIHN1Z2dlc3Rpb24gKG1tL2ZpbGVtYXAuYyk6IFNoYXJlZCBpbiBSaXRlc2gncyByZXBseSBv
biBNYXkgM3JkIFsxXQpNYXR0aGV3J3Mgc3VnZ2VzdGlvbiAobW0vZmlsZW1hcC5jKTogU2hhcmVk
IGluIE1hdHRoZXcncyByZXBseSBvbiBBcHJpbCA0dGggWzJdCmtjb21wYWN0ZCBiYWNrZ3JvdW5k
IChtbS9wYWdlX2FsbG9jLmMpOiBTaGFyZWQgaW4gbXkgcmVwbHkgb24gTWF5IDZ0aCBbM10KClsx
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0MDMxOTM1MzUuOTk3MC0xLWRpcGll
dHNAYW1hem9uLml0L1QvI204YzNkYTFjOWZiOWU5YzY2ZDRlOGIxODQ5ZGU4MjRiMGVjZjM3Zjll
ClsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0MDMxOTM1MzUuOTk3MC0xLWRp
cGlldHNAYW1hem9uLml0L1QvI200YjkwY2YyODBmZjBlZmNmMTc4ZGZkOGQwNjhmMWRlM2IyNjJl
MjhhClszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0MDMxOTM1MzUuOTk3MC0x
LWRpcGlldHNAYW1hem9uLml0L1QvI20yMjk3NzM1NTUzNWE0NTk5MDg0YTUxMTA0YTRkZjgwNmQ0
OWM1M2QxCgotLQpTYWx2YXRvcmUKCgoKQU1BWk9OIERFVkVMT1BNRU5UIENFTlRFUiBJVEFMWSBT
UkwsIHZpYWxlIE1vbnRlIEdyYXBwYSAzLzUsIDIwMTI0IE1pbGFubywgSXRhbGlhLCBSZWdpc3Ry
byBkZWxsZSBJbXByZXNlIGRpIE1pbGFubyBNb256YSBCcmlhbnphIExvZGkgUkVBIG4uIDI1MDQ4
NTksIENhcGl0YWxlIFNvY2lhbGU6IDEwLjAwMCBFVVIgaS52LiwgQ29kLiBGaXNjLiBlIFAuSVZB
IDEwMTAwMDUwOTYxLCBTb2NpZXRhIGNvbiBTb2NpbyBVbmljbwoKCg==


