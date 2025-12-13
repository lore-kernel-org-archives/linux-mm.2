Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A285D59F75
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 07:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8006B0005; Sat, 13 Dec 2025 02:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A687D6B0007; Sat, 13 Dec 2025 02:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958256B0008; Sat, 13 Dec 2025 02:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1746B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 02:10:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20A1D14034B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:10:42 +0000 (UTC)
X-FDA: 84213575124.25.4371B0A
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09E3980007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:10:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=t7O7dxj2;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=435b9112b=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=435b9112b=graf@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765609840; a=rsa-sha256;
	cv=none;
	b=IYFA4pQ+Qr8VXOxO4oE3283LGiGzv0QtbC9VjuS6+JxpWDwnWEVs7/Wk5pd7vN7JJ6KEWj
	J0y9eTYsQdfsq2JfcS6/48mGHYYR1nt7pbeuKDdq3I+J1d5JU/PD+zd9S4SZG+2xqZ2/wH
	7IoVyDIuDxklukekFdy4lkk+YqRpOBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=t7O7dxj2;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=435b9112b=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=435b9112b=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765609840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9fJXDtXoVKnzhNQS1ylDA8uNXeuK84gVZGRdlqfvSA=;
	b=eieJJk614bRQTJD3PmkR0PirzAlIdZhYgc7AgYvuHyBNqHOQdqZK3VD08X62MqqCfctsTN
	qrkebMPjUSqIQQI2Oc/RztxMuGEmwCqlAXYLDDJ31fWhnq+W1l5zYXNZ3DK71dZHUfzKpW
	z2dis8NH7pDPWkzlO17Gr5BTEN9wAJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1765609840; x=1797145840;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o9fJXDtXoVKnzhNQS1ylDA8uNXeuK84gVZGRdlqfvSA=;
  b=t7O7dxj2EokmKdIScqLd+U9NdBTKoYRseqXvM+U1d1bXLiQAmo8SOqyN
   wrFsAUlQ40IMaOcmMys3sASkcFceahvbRn5rNL7CHHX/vp4O5ahq1B0s6
   6o8Std0hZu9rVAXz2UaRqDibn1zCdEErTicqOnhqCTkz6M/tenLE535mL
   RufU8uak3joP4B2jsgdYpgkMT4Gic63p8NxjPu5CHRtu8UTojRX2nqu+z
   Kypo3wcbRBZnYiFV0MXARlEI4i4AfMCqqK/MKBg8e149Ut78syJHbErsw
   gO8U1jLMHxitTdVgIa2f4sfuw16gU02pfdFl8hCVRqJpOu2YCWdnzniK7
   A==;
X-CSE-ConnectionGUID: IArTKZvNTse5aI0KzG9AZQ==
X-CSE-MsgGUID: kwnkf6iXRHa0M3DtExxWHQ==
X-IronPort-AV: E=Sophos;i="6.21,145,1763424000"; 
   d="scan'208";a="8795544"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2025 07:10:36 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:26686]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.45.135:2525] with esmtp (Farcaster)
 id 0748e64d-5e43-4bf2-9d47-0b42a67cdd9d; Sat, 13 Dec 2025 07:10:36 +0000 (UTC)
X-Farcaster-Flow-ID: 0748e64d-5e43-4bf2-9d47-0b42a67cdd9d
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Sat, 13 Dec 2025 07:10:36 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Sat, 13 Dec 2025
 07:10:27 +0000
Message-ID: <e4d1c333-7e22-47ee-81a0-2efc4ca6b17c@amazon.com>
Date: Sat, 13 Dec 2025 16:10:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] liveupdate: list all file handler versions in vmlinux
 section
To: Pratyush Yadav <pratyush@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	"Pasha Tatashin" <pasha.tatashin@soleen.com>, Mike Rapoport
	<rppt@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Samiullah
 Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, David
 Rientjes <rientjes@google.com>, Jason Miu <jasonmiu@google.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <kexec@lists.infradead.org>
References: <20251211042624.175517-1-pratyush@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20251211042624.175517-1-pratyush@kernel.org>
X-Originating-IP: [172.19.99.218]
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 09E3980007
X-Stat-Signature: yg9ang8jihbj481cdtqqpfdncr7zy74y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765609839-434257
X-HE-Meta: U2FsdGVkX1/E8/+P0sUdbJPrhI7tq6SZNY2h7C7r/KgRBn06qGpFlR0Tmx20oEgn1tjAGybIfHVmz0oL8hnvXhc4FlOzzuhPRoWv9jvuzx8Nhs48PBocI+3WuMW4sFNaHN4PKHmqC8BJFpeTEuqf+Bm1Gvb/9v82Ijau2BHUqNyKUNSwkdWDe7CgurN+MhfKZMrCRXzDHwhgZWq40vvjqo9JG+bY9ozyy05qAu3KWMEHase6o1mAehQf9wlwNxRsn1NboSqnhYRbyB+Bs5hE/clhXyY5GEJ9MBUB9453A1qZz+VRsit/JdS0EFa9uyxIm8BXtnQf5N5XKLM855dIrzAuKfyEu6nWeFACSeYEH2PpclnCrH4AlWOmfBt7XK7EBi3u3WYJpjaq3K5F9GPQBaZ4nZsSOfLNfKDwRuoImL0NEgsItdcOxRBGNv8BibvrwT9cUfK43ZOCMhPwV4PLnG2DyQADmKrpHO35ZIh37U5j2bcwA6aoZ16SM4etyXHKnycGjCdoPJWYBDJGMXqQjudPdY6n55AX4eZo4M9IxU9hJcaQnoHgH3CVUBg3QuBqXV1k0mwy1/88XFLs55xTzxv3OKap1bfbxeXmd8XKceCEBnsfq8IHO4OT6JRgdh0K/PqlJ6oUlo/9C2gKAK52op/4y/1E3uE+b4S/cL4p+HzuMk9WyC6SmT0o6bGAMF5TKacajPJe1oDk3hSNT1aPrl1GLPetWKUVXwBHSAqS60EfHOc+MYeuk8RfDgoH+bljyl8w6En7GRL1eIDtbv+qNhw63iCgd2s8TowJp083SBsT18mFcqjdhIaYeSAPX1Jkv3kIWB+7JIVtU8nuc08rzw/yt7e+eBiw+LQtXK3gCQyG+CY4hAM+yKBhN88y5U19E8oKPiVPsPvMU9kmBGKE2uG3xFsOQcY9X+HZQhAHUKVOdZ1QWW0NFxsVLNi6Pc9KG1a8HRBIexoDQlVfno3
 jQb6wNlU
 9ErEgpdQ/zBTke7qEFBSZIVQ+s2HwFjgPyDMRFQs5e9ZBOb1cMqFNAzMtkHYkszaH0ZdYn9V8aSH3xyclAWA8llmNWS8x9TWcAqv0f6jDYjVHlwUyWxYvthALqXQeWcQakDcSNeGzU481akomAe9Qfb/FXRBCzXnSsqBlz7c4HJymKLQE+fleoZuX/3KGYkM4DdxWbYX0fof8a2dLVugZIQY2fz1CZiO9+5cAdQ5gqHojiWIDgmv7ooY+wpQIut7wf4msSY92LgJeLD/FGqzsHXK9SbTndcbfjkZlyNiFhZ3lBydruRAtYAfSVmZiQxTCP3Ho/DMiJ5kKWhzlc6f3D7itsVN08McDr/49Vtx7qOEWS3fsY3ZMJs1wxF7d+M/Ke6wvN7+soQO/5IyWqANp3UPa9u0DnoQffUVV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgUHJhdHl1c2gsCgpPbiAxMC4xMi4yNSAyMDoyNiwgUHJhdHl1c2ggWWFkYXYgd3JvdGU6Cj4g
QXMgbGl2ZSB1cGRhdGUgZXZvbHZlcywgdGhlcmUgd2lsbCBiZSBhIG5lZWQgdG8gdXBkYXRlIHRo
ZSBzZXJpYWxpemF0aW9uCj4gZm9ybWF0cyBmb3IgdGhlIGRpZmZlcmVudCBmaWxlIHR5cGVzLiBU
aGlzIGNvdWxkIGJlIGZvciBhZGRpbmcgbmV3Cj4gZmVhdHVyZXMsIGZvciBzdXBwb3J0aW5nIGEg
Y2hhbmdlIGluIGJlaGF2aW91ciwgb3IgdG8gZml4IGJ1Z3MuCj4KPiBJZiB0aGUgY3VycmVudCBr
ZXJuZWwgZG9lcyBub3QgdW5kZXJzdGFuZCB0aGUgc2FtZSBzZXQgb2YgdmVyc2lvbnMgYXMKPiB0
aGUgbmV4dCBrZXJuZWwsIGxpdmUgdXBkYXRlIHdpbGwgaW5ldml0YWJseSBmYWlsLiBUaGUgbmV4
dCBrZXJuZWwgd2lsbAo+IGJlIHVuYWJsZSB0byB1bmRlcnN0YW5kIHRoZSBoYW5kZWQgb3ZlciBk
YXRhIGFuZCB3aWxsIGJlIHVuYWJsZSB0bwo+IHJlc3RvcmUgbWVtb3J5LCBkZXZpY2VzLCBJT01N
VSBwYWdlIHRhYmxlcywgZXRjLgo+Cj4gTGlzdCB0aGUgc2V0IG9mIHZlcnNpb25zIHRoZSBrZXJu
ZWwgdW5kZXJzdGFuZHMgaW4gYSBzZWN0aW9uIGluIHZtbGludXguCj4gVGhpcyBjYW4gdGhlbiBi
ZSB1c2VkIGJ5IHVzZXJzcGFjZSB0b29saW5nIHRvIG1ha2Ugc3VyZSB0aGUgc2V0IG9mIGZpbGUK
PiBkZXNjcmlwdG9ycyBpdCB1c2VzIGhhdmUgdGhlIHNhbWUgdmVyc2lvbiBiZXR3ZWVuIGJvdGgg
a2VybmVscy4gSWYgdGhlcmUKPiBpcyBhIG1pc21hdGNoLCB0aGUgdG9vbGluZyBjYW4gY2F0Y2gg
dGhpcyBlYXJseSBhbmQgYWJvcnQgbGl2ZSB1cGRhdGUKPiBiZWZvcmUgaXQgaXMgdG9vIGxhdGUu
Cj4KPiBUaGUgdmVyc2lvbnMgYXJlIGxpc3RlZCBpbiBhIHNlY3Rpb24gY2FsbGVkICIubGl2ZXVw
ZGF0ZV92ZXJzaW9ucyIuIFRoZQo+IHNlY3Rpb24gaGFzIGEgaGVhZGVyIHRoYXQgY29udGFpbnMg
YSBtYWdpYyBudW1iZXIgYW5kIHRoZSB2ZXJzaW9uIG9mIHRoZQo+IGRhdGEgZm9ybWF0LiBUaGUg
bGlzdCBvZiB2ZXJzaW9uIHN0cmluZ3MgZGlyZWN0bHkgZm9sbG93IHRoaXMgaGVhZGVyLgo+IE9u
bHkgdGhlIHZlcnNpb24gc3RyaW5ncyBhcmUgbGlzdGVkLCBhbmQgaXQgaXMgdXAgdG8gdXNlcnNw
YWNlIHRvIG1hcAo+IHRoZW0gdG8gZmlsZSBkZXNjcmlwdG9yIHR5cGVzLgo+Cj4gVGhlIGZvcm1h
dCBvZiB0aGUgc2VjdGlvbiBoYXMgdGhlIHNhbWUgQUJJIHJ1bGVzIGFzIHRoZSByZXN0IG9mIExV
TyBBQkkuCj4KPiBJbnRyb2R1Y2UgYSBMSVZFVVBEQVRFX0ZJTEVfSEFORExFUiBtYWNybyB0aGF0
IG1ha2VzIGl0IGVhc3kgdG8gZGVmaW5lIGEKPiBmaWxlIGhhbmRsZXIgd2hpbGUgYWxzbyBhZGRp
bmcgaXRzIHZlcnNpb24gc3RyaW5nIHRvIHRoZSByaWdodCBzZWN0aW9uLgo+Cj4gU2lnbmVkLW9m
Zi1ieTogUHJhdHl1c2ggWWFkYXYgPHByYXR5dXNoQGtlcm5lbC5vcmc+CgoKVG8gc3VwcG9ydCBt
dWx0aS12ZXJzaW9uIHByZXNlcnZhdGlvbiBhbmQgcmVzdW1lLCBob3cgYWJvdXQgeW91IGFkZCBh
IAoicHJvZmlsZSIgaGludCB0byB0aGUgaGFuZGxlcnM/IFRoZW4geW91IGNhbiB0YWcgdGhlIGhh
bmRsZXJzIHdpdGggCiJjdXJyZW50IiBhbmQgYSAicHJldmlvdXMiLiBZb3UgdGhlbiBleHBvc2Ug
b25lIHNlY3Rpb24gdGFibGUgd2l0aCAKc3VwcG9ydGVkIHZlcnNpb25zIHBlciBwcm9maWxlLiBB
bmQgdGhhdCBtZWFucyB5b3UgY2FuIGZyb20gdXNlciBzcGFjZSAKc2VsZWN0IHRoZSBsb2NhbCBw
cm9maWxlIHRvIHNlcmlhbGl6ZSBhbmQgbWF0Y2ggdGhhdCBhZ2FpbnN0IHRoZSB0YXJnZXQgCnBy
b2ZpbGUgb2YgdGhlIHRhcmdldCBzeXN0ZW0uCgpJdCBhbHNvIGFsbG93cyB5b3UgdG8gc3VwcG9y
dCBtb3JlICJwcm9maWxlcyIsIHN1Y2ggYXMgZWxhYm9yYXRlIApkb3duc3RyZWFtIHZlcnNpb24g
Y29tYmluYXRpb25zLCB0aGF0IHVwc3RyZWFtIHdpbGwgbm90IGhhdmUgdG8gY2FyZSBhYm91dC4K
CgpBbGV4CgoKCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFu
eSBHbWJIClRhbWFyYS1EYW56LVN0ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVmdHNmdWVocnVu
ZzogQ2hyaXN0b2YgSGVsbG1pcywgQW5kcmVhcyBTdGllZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNn
ZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0
LUlEOiBERSAzNjUgNTM4IDU5Nwo=


