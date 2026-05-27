Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CA8CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158806B00B8; Wed, 27 May 2026 12:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1306A6B00BB; Wed, 27 May 2026 12:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D6E6B00BE; Wed, 27 May 2026 12:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBCF16B00B8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:24:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8A9B1A069F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:24:24 +0000 (UTC)
X-FDA: 84813722448.29.80D31F4
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9142340006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:24:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=pICYmcCW;
	spf=pass (imf27.hostedemail.com: domain of "prvs=60026f1e3=dipiets@amazon.it" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=60026f1e3=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779899062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJ3ZaifqYn0VQCKdxHWWZlSnzoqGur/EM85UsJ8ZE+o=;
	b=gEdQzI5e4GlGZXJkqwEu1CTe7lxRKp2eR4+3p0/duFa63INLtr5RZag5WA91PFeCZUQKdg
	1sHT2Jscq/ad0lxh159GLf6ABlIsX8RX0g8d1g45f6W5plXaDdnyrW/16eqatbU6uQpYL7
	+aLTtdMtGo8L2Q2715DjZJFPW/Af/C8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779899062; a=rsa-sha256;
	cv=none;
	b=MaaDnGMiDJ82rXNUr6ME2CnDyTkQjwpqGK+hviG5j+0dbaU3tbo6GhnzxONnGhJSPoxC6a
	TdLtZTQn+qJPkzpplKcSVzB/xYxLXGGorLjYcCEcx0E9w8oPFvlM288kg9NFNYU5QC/fi+
	0Bhehme3fcE/FuQ3R2cg13YdgTJWVXM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=pICYmcCW;
	spf=pass (imf27.hostedemail.com: domain of "prvs=60026f1e3=dipiets@amazon.it" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=60026f1e3=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1779899062; x=1811435062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJ3ZaifqYn0VQCKdxHWWZlSnzoqGur/EM85UsJ8ZE+o=;
  b=pICYmcCWK9OD8McWZgb1CLKC37EDhPtSFoFH8qnvNNL+3MT+rwFPHaTg
   LQVT7aSw2VzcMctlyDYf/ZISi3MsHO1E6O3lXjQmyg2n/u6JV4+U1kdcE
   2JmI6fNolz8q6xRpq8i+b3WwE4hZ2zupQZfiulY+i69y9gfNIWh2J7k9H
   04HHqBO8j8vC73on3Y4V65Zcl27ajMDFVI7M0XyADkJtRmxLB90KAWqo6
   Csj5iqr2bgsVhxFDa4brzKGJUpUB28dy6x1JYuR6qLSpOZ3ET0zpAyQF5
   lmOcwwb42FeLEpQm6Wx3wCwtiaegS8PznIvBJboXG0Tk92598hXqYbh5F
   Q==;
X-CSE-ConnectionGUID: t+732PyMRH2YqSw/d+AZ2Q==
X-CSE-MsgGUID: eMCH7QL8STW+gllK7jzoxw==
X-IronPort-AV: E=Sophos;i="6.24,171,1774310400"; 
   d="scan'208";a="20078251"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:24:19 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:19651]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.91:2525] with esmtp (Farcaster)
 id a11e89ab-846e-4a3e-8685-5a080839ce6c; Wed, 27 May 2026 16:24:19 +0000 (UTC)
X-Farcaster-Flow-ID: a11e89ab-846e-4a3e-8685-5a080839ce6c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 16:24:17 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 16:24:17 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <dipiets@amazon.it>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <vbabka@suse.com>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Wed, 27 May 2026 16:24:10 +0000
Message-ID: <20260527162412.19922-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260506123326.17293-1-dipiets@amazon.it>
References: <20260506123326.17293-1-dipiets@amazon.it>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspam-User: 
X-Rspamd-Queue-Id: 9142340006
X-Stat-Signature: ghpa98byz5nbjba8tg9z6puq97ssuo9e
X-Rspamd-Server: rspam06
X-HE-Tag: 1779899062-85236
X-HE-Meta: U2FsdGVkX1/MCEW/NxMkT6AbaUIdpqiDUEntup5NTY6MCj4uQFQsxmHyn5Q5mSh8xPZ6bASJrdFubBlbSCZlJEb/vhZO3m1ir5ZF7vJIo/CFsR2/X4MvAMzaCDLC0C08Poj8Yij/hppWo4/D8HNn3F1Qzb9SQBCm/ibN/4NLOVMoGOFOsIdpCxUmJE2Mt52jgIKKOCe4d1RO6M9I9liQoPl7hpS9CbPRILP3cH0uoFI5CjITz4QDhaJ8Z/ummIU3PACvz3WhVgZatEEe6Qrjc3F9WT6JuW8Ct/DIgGY6/Nw7v+RKVQn6iq7JIR3lN0tuRzXeGzDeE2LiJiDjzaYl7ASPDVkzZ0cAcsrQGbdhd6SBGCMXIF8JsLBLTODII4C44aiOXAgv8MsmxYWn8NO7eXwDSHJ2764qSq76Z7nmEXMMHgrga+GpFdD3isi4IAlA3fD3izazG43WPfqBVJNRqQCkd7vcVrdSuxRxMXWite72rVzl2oHej90Q9nzlWrWSIBbsZD+yO40uZGlur25ZAZIP839sw1KRNMyTX3L+nOVXrm0kMgf1UthxistU3z13iVbc48ZRUAY4XjRHDCbalbKG6Yb70gEACnRa3Tk4BxlTTWoepjhnZ33JlQ2SKmUpG7E78UHphxzClsSf8DkpdaNwL4KoF7MSGX9AOJXll8NIar9aC5iA1mr/ZRu6mXG1BDC6XocgYbXVqFvlGAf7AwhF7KA8BawlOmumu46DlPmuqGRntj5f5L5KvbHvw7e8qz1aC56sDtWJYgJ42mdfyUWsUeif7mlMU7ygcwArEde2opyxiS/KTBdNnYs0Cp0Emc8QkE0tdBLwA4Tki8EvXZgGMj6EAzs0ZL618YQjW62fb1Yei1P6V73ofF98NzrnhumKP0GR9c+VzwJ318bgt1n9Mo7aEAyC5QNfAvUOvtlcp5WIJj1uZuuscOSOLZMkG6csSjyyT5xwUDdopoh
 XL1yR6fb
 yD9e63cZAXQKSNBEPmbSX6NmqxJS9cfabid7ZAiVhiyyZF/8sjdYkd5skVCqsTj5Ls0/KGKj62ioFWwJjpZkjuaDTdRxN/K6wirpOnrBNwMOxIbqpj1ZOrvjlddXL9xmv+smaBhJcR4QjnUB6lt8CcuJe6PgriDU2c60JlBy17/rOhNV7hkcaUNQsz2iXgJGjlYaBOtOiF3jb7Vnp9ZyKyI6cBgkBRpgWsNdKN7hqzXNJcQ554hW/5lmu44epPPPF1kAnGB41woRu9EO0aLjgHK/rLpkdlPnTe5J5SZQcZYTMlX18fJE3vse7Ivs3OqtkIsZ3a4UTeq3IttIosB6wzODOgTm5grJuvrd+E8dSyzoRTnaNUCM/84ZPd4ygYjwpD08li9yT3RREXxcArHESj0uYoBqgEiPDD7EbJFWAUAFsjsk0RlVgm3Hph9BVXIJNqHlRQHGOWUgKVLWjYxTKRknrIKBnEQpMEvfM5kzgCwZg+qE4nASeIAGNM2m9Y0wixrWqiRU2AK7Df6lFa9rgiyXar5990RZBJTdCYD+kA0WKgH4CARgKqgqMfvwNfkhGz4isDJdKyIHwEbtw9Cd+jgqEU9XXaaHo8yyf2CBTYkv5KbMGiWoeSKW8+yC2iStAFItSnIZ2ok5lAko5Wr5DP60Qvq7QQAEXqBCSHTXhDiUA99P7dcXQMUKMqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ClRoYW5rcyBSaXRlc2ggYW5kIE1hdHRoZXcgZm9yIHRoZSBjb250aW51ZWQgZmVlZGJhY2sgYW5k
IGd1aWRhbmNlIG9uIHRoaXMgdGhyZWFkLgpJJ2QgbGlrZSB0byBzdW1tYXJpemUgd2hlcmUgd2Ug
c3RhbmQgYW5kIGFzayBmb3IgeW91ciBpbnB1dCBvbiB0aGUgYmVzdCBwYXRoIGZvcndhcmQuCgpT
dW1tYXJ5IG9mIGFwcHJvYWNoZXMgdGVzdGVkOgpXZSd2ZSBub3cgYmVuY2htYXJrZWQgYWxsIHBy
b3Bvc2VkIHZhcmlhdGlvbnMgKHBnYmVuY2ggc2ltcGxlLXVwZGF0ZSwgMTAyNCBjbGllbnRzLCAK
OTYtdkNQVSBhcm02NCwgaHVnZV9wYWdlcz1vZmYsIFBSRUVNUFRfTk9ORSBhcHBsaWVkIFsxXSk6
Cgp8IFBhdGNoICAgICAgICAgICAgICAgICAgICAgICAgICB8IENoYW5nZSBMb2NhdGlvbiAgICAg
ICB8IEF2ZyBUUFMgICAgfCAlIHZzIEJhc2VsaW5lIHwKfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tOnw6LS0tLS0tLS0t
LS0tLTp8CnwgQmFzZWxpbmUgKG5vIHBhdGNoKSAgICAgICAgICAgIHwg4oCUICAgICAgICAgICAg
ICAgICAgICAgfCAxMDEsOTc5Ljc1IHwgICAgICAg4oCUICAgICAgIHwKfCB2MSAob3JpZ2luYWws
IGlvbWFwIGNhbGxlcikgICAgfCBmcy9pb21hcC9idWZmZXJlZC1pby5jfCAxNDEsMTk0LjIwIHwg
ICAgKzM4LjQ1JSAgICB8CnwgUml0ZXNoJ3Mgc3VnZ2VzdGlvbiAgICAgICAgICAgIHwgbW0vZmls
ZW1hcC5jICAgICAgICAgIHwgMTM5LDIwMC42MSB8ICAgICszNi41MCUgICAgfAp8IE1hdHRoZXcn
cyBzdWdnZXN0aW9uICAgICAgICAgICB8IG1tL2ZpbGVtYXAuYyAgICAgICAgICB8IDE0Myw4NjMu
ODIgfCAgICArNDEuMDclICAgIHwKfCBrY29tcGFjdGQgYmFja2dyb3VuZCAgICAgICAgICAgfCBt
bS9wYWdlX2FsbG9jLmMgICAgICAgfCAxMzQsMjc4LjQ3IHwgICAgKzMxLjY3JSAgICB8CgoKQWxs
IGFwcHJvYWNoZXMgcmVjb3ZlciBzaWduaWZpY2FudCB0aHJvdWdocHV0LiBUaGUga2NvbXBhY3Rk
IGFwcHJvYWNoIChiYWNrZ3JvdW5kIApjb21wYWN0aW9uIGFuZCByZXR1cm5pbmcgbm9wYWdlIGZv
ciBjb3N0bHkgb3JkZXJzIHdpdGggX19HRlBfTk9SRVRSWSkgYWxpZ25zIHdpdGggdGhlCmFyY2hp
dGVjdHVyYWwgZGlyZWN0aW9uIERhdmUgYW5kIENocmlzdG9waCBwcm9wb3NlZCwga2VlcGluZyBj
b21wYWN0aW9uIG91dCBvZiB0aGUgZGlyZWN0IApyZWNsYWltIHBhdGgsIGFuZCBsaXZlcyBlbnRp
cmVseSBpbiB0aGUgcGFnZSBhbGxvY2F0b3IuIAoKQmFzZWQgb24gdGhlIGRpc2N1c3Npb24sIEkg
c2VlIHR3byBwb3NzaWJsZSBkaXJlY3Rpb25zIGFuZCB3b3VsZCBhcHByZWNpYXRlIHlvdXIgZ3Vp
ZGFuY2U6CgoxLiBQYWdlIGFsbG9jYXRvciBmaXggKG1tL3BhZ2VfYWxsb2MuYyk6IFRoZSBrY29t
cGFjdGQgYmFja2dyb3VuZCBhcHByb2FjaCBhZGRyZXNzZXMgCk1hdHRoZXcncyBjb25jZXJuIHRo
YXQgZmlsZW1hcC5jIHNob3VsZG4ndCBrbm93IGFib3V0IFBBR0VfQUxMT0NfQ09TVExZX09SREVS
LCBhbmQgYWxpZ25zIAp3aXRoIERhdmUncyB2aXNpb24gb2YgcmVtb3ZpbmcgY29tcGFjdGlvbiBm
cm9tIHRoZSBkaXJlY3QgcmVjbGFpbSBwYXRoLgoKMi4gZmlsZW1hcCBmaXggKG1tL2ZpbGVtYXAu
Yyk6IEJvdGggUml0ZXNoJ3MgYW5kIE1hdHRoZXcncyBzdWdnZXN0aW9ucyBhcmUgbWluaW1hbCwg
CmJhY2twb3J0YWJsZSwgYW5kIHByZXNlcnZlIGxpZ2h0d2VpZ2h0IHJlY2xhaW0gZm9yIG5vbi1j
b3N0bHkgb3JkZXJzLiAKUml0ZXNoJ3MgdmFyaWFudCBkaWZmZXJlbnRpYXRlcyBiZXR3ZWVuIGNv
c3RseSBhbmQgbm9uLWNvc3RseSBvcmRlcnMsIHdoaWxlIE1hdHRoZXcncyAKaXMgc2ltcGxlciBh
bmQgcGVyZm9ybXMgYmVzdC4KCldvdWxkIGVpdGhlciBvZiB0aGVzZSBkaXJlY3Rpb25zIGJlIGFj
Y2VwdGFibGUgZm9yIGEgdjMsIG9yIHdvdWxkIHlvdSBwcmVmZXIgYSBkaWZmZXJlbnQgYXBwcm9h
Y2g/CgpJJ20gaGFwcHkgdG8gdGVzdCBhbnkgYWRkaXRpb25hbCB2YXJpYXRpb25zIG9yIGRpcmVj
dGlvbiB0byBtb3ZlIHRoaXMgZm9yd2FyZAoKU2FsdmF0b3JlCgoKWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2FsbC8yMDI2MDQwMzE5MTk0Mi4yMTQxMC0xLWRpcGlldHNAYW1hem9uLml0L1Qv
I204YmFlZWFmNDhhYTdhZTUzNDJjOGMyZGI4ZjRlMWMyN2UwM2MxMzY4CgoKCgpBTUFaT04gREVW
RUxPUE1FTlQgQ0VOVEVSIElUQUxZIFNSTCwgdmlhbGUgTW9udGUgR3JhcHBhIDMvNSwgMjAxMjQg
TWlsYW5vLCBJdGFsaWEsIFJlZ2lzdHJvIGRlbGxlIEltcHJlc2UgZGkgTWlsYW5vIE1vbnphIEJy
aWFuemEgTG9kaSBSRUEgbi4gMjUwNDg1OSwgQ2FwaXRhbGUgU29jaWFsZTogMTAuMDAwIEVVUiBp
LnYuLCBDb2QuIEZpc2MuIGUgUC5JVkEgMTAxMDAwNTA5NjEsIFNvY2lldGEgY29uIFNvY2lvIFVu
aWNvCgoK


