Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB114CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96816B0005; Wed,  6 May 2026 08:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E461B6B0088; Wed,  6 May 2026 08:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34A86B008A; Wed,  6 May 2026 08:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF9006B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:34:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38C111C03C8
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:34:10 +0000 (UTC)
X-FDA: 84736937460.08.D5EBD59
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10DA38000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:34:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=VFcUtX1o;
	spf=pass (imf30.hostedemail.com: domain of "prvs=579c1bc2a=dipiets@amazon.it" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=579c1bc2a=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778070848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/5kufV2plp3HwPkO+4lStch1YgUSQRacJ+gaSCrLxU=;
	b=OdoaFxOatMXcnKpCZRpEWzU9H1ul8XskQN6fuVVrnY5pdATMk+0sOgQRV+5eHDeA8YQ2UX
	VC8n+cVuRvSrQe2rEZVfAfVxRU4tYNfx0iVehDUWOwD7gsCHftrwDgx51TOT/Bb4lj4PLg
	CYRSyj2M5nhKhKH2ImAlHO6IJ5EJCgY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=VFcUtX1o;
	spf=pass (imf30.hostedemail.com: domain of "prvs=579c1bc2a=dipiets@amazon.it" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=579c1bc2a=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778070848; a=rsa-sha256;
	cv=none;
	b=lK91uLmmil2FDuqZp0MRl95yXC8XlGCQIN8AKpi8eYavFfMmmbRI11OGSEudtJVdLfTYOz
	elW/JWRLMUY0B97Ytj9H20l0da4s/x5WwJepR0cfv0ndx4qutrT5+H0rux/mnlWyRC7Vvm
	YA9D4pPlwPyb5FwYdP33vTs/daA/Pn0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1778070848; x=1809606848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h/5kufV2plp3HwPkO+4lStch1YgUSQRacJ+gaSCrLxU=;
  b=VFcUtX1ouu2vg6uAQJQNT+4kJ2yP0s6X8uEykHh2Vzeb7YNFYJF7SrqW
   EZD5eSiD72HROBplbh33y7HoC80smTnVX6xYFbTFeRL5BoU4eow8X0qhR
   1Q59gOsI5g5oUccVcZgE3Qv/WBolm2oi64VvqQmlkxwaHSStCp5gMpdVS
   6uXvjhjhXVwfrUNjh3qiQUA0pIzwrgGFnM1dDcEK+Qao/TZbmUEA5G4/T
   LhufWmOL9sAYq8IoUXSrJVdJW5n0quC/ucE7wwA3t4n2oeiecwsgDNZG+
   B8ZxQFc54Koz3hLZiYkRFb9xbArKD/1bAzDKJSRkCzqDN5pUE5DQHhCwJ
   w==;
X-CSE-ConnectionGUID: ddMf54vISQuDF+tIVZgPrg==
X-CSE-MsgGUID: E6X8bLUXT82YBcfM5C04vA==
X-IronPort-AV: E=Sophos;i="6.23,219,1770595200"; 
   d="scan'208";a="18769960"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 12:33:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:22494]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.153:2525] with esmtp (Farcaster)
 id a1329851-5807-47c2-84ec-22c078ca4c8e; Wed, 6 May 2026 12:33:55 +0000 (UTC)
X-Farcaster-Flow-ID: a1329851-5807-47c2-84ec-22c078ca4c8e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 6 May 2026 12:33:54 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 6 May 2026
 12:33:54 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <vbabka@suse.com>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Wed, 6 May 2026 12:33:18 +0000
Message-ID: <20260506123326.17293-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <afc3xFgKogxF5Lbq@casper.infradead.org>
References: <afc3xFgKogxF5Lbq@casper.infradead.org>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Stat-Signature: 7c8dkxcwh78rq9he1s36z88p9fi8nka3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10DA38000F
X-Rspam-User: 
X-HE-Tag: 1778070847-627631
X-HE-Meta: U2FsdGVkX19QRzuIf/HMvI4/lo/y2tp665EwNhWhAkJjkcwgkGd2caCC0wQpvRKIt+Y+F3OiIY3mQjkaM5KT12UOP82E96MHAP2T1XQKF4MyxSaYYMOlxGrVVg199iHkIY1ntTXgUgbLW+eySR7MQahtkOSqqaCiWgvTsCt/XdOb/pX49GZsZdkVdM6rmxUpKLDpX5a4+olr2UNxjf9A8aOtLjuuHBkX8WnBwAvMrefFTynPQERrAhaktz6mKrGCg2bd/x9dqP7zp42y+OTgdqPYNBiFxUEiwJcPojlU30aJW1rmc/vdJ2YAPWXGa4cvojQU19E/0V8LH7m7lUgcw93OkGJIlyWtlpEXEtxdkE9pEHLSGRw4AXRfYr100UB5Msj+J+PsSGceFGjcpTUQO59s10zCHPY/O9+LiKUUZqviijHjuHE8XqTxEFs21EVTL6IDb+03EawJ0pXMwfdnwjB1apKyH+WfrbgNuCbcCrwN3sotRvhuWV/8zfjZ1iZ+mq76QIBCXROrSuNNzQDjBL1xeCT7cOuUpCn+Cf5n7MNT9fikuNIVq1FGkVyBXi8sp24G36Gf9jWQ9SWt+znuePc+Eo3fCkm9WgQtQlJCWcll4cWI9xABRvEKhe2ZCWaOauJnU5/7kghZfh0GX4CMrolS5QpPaBAr1tyvZffjvHvJpaYWS1K0HcuAwd3zWc4WykZgAOPYRO1FCgENd5uEUIa4MASY6ibMgL//6u7Ov+2hssNTvQQi/JxOzHt7UuEe+OSvSCRVRiRJMuTF5dpnNA/n0zjc1MhtPsKTCmOsQUjq/+NlSKeltvfDXTZaXEZ10X47J6BZXcwwGFE4N02zzcHodYJA3AYCcIZVC47alcifllPKh/VDfLeDmmA9eppAt8zmJVH3uOMNLIq3/IqSgfKeb8DXYdkDIYK+nfGG1HdWYSTJzIkp5It+cWr3I3mmobxBG8RKjQVVfUJNmgZ
 k4tIkArU
 DH54HIJq2/V04XwNhSv7AndtYjC86mZ8dAIgeaLCSco4mEM33hpTXb31sMbkakhj/QMKl3srGtu15A7rjLyB+zEzuJt0O/iJWQ2rNrN0JrZbG3+EdnKKbXM0ZCw9MI/Mnejlj2qHmNNls5zRmNFfmyeTP3o+S/R9zaQ/lhFif06IUmRuSaCwExf+bY6zxdY8hHWsnFunGjciU7UTZ01FwUwd+kd3UUFyya24guNIKSEExaZfcgz7ZzJO/FBv0lHqHJm0/nZvpbHUq0LddbkGNCtvyy20X+HSI+STDIFqolMlq10HWZXh0rIAiKP5XqnhXmy8jmCKUM4lVO2kDAp99S5ugpqav7oKbQcqQzkDBxWXSgrQj4DFCWKfjh20EF5VtBX4XuBwxqEKxqgfrlomZMU7fxU6DFs/zmzro1ftVe3/aOZs6cYtZI4UNl/mI1Ig/NGrGQc2Q4QDVmk0JgM3GH5Ab5TbPrvQLOhm2gwTtEe9QoyUVtjMbz2NgXT/OviiOKalLrYcXiTzBEdfZTIBy+gNQ0XBxvWOg+YQQUK2x51gYa6iAtqGNGY0NO3Trkp7MJbYar9v1fcCzd1M9nqkkz7sh5Sc4GZa0z3Hv6P6vQg+CazMoDJWVzp/8y8NPbk69N2chC+j7umpWYvqrzL5VkokxT8VUT9Cu+jGJg5G2NU9u8qQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ck9uIDUvMDMvMjYgMDU6NTIsIFJpdGVzaCBIYXJqYW5pIHdyb3RlOgo+IEFsc28gYXMgcGVyIHRo
ZSBkb2N1bWVudGF0aW9uIFsxXSwgaHVnZV9wYWdlcz10cnkgb3B0aW9uIGlzIHRoZSBkZWZhdWx0
Cj4gc2V0dGluZy4gU28gSSBhbSBhc3N1bWluZyBpbiBwcm9kdWN0aW9uIHdlIGF0IGxlYXN0IHdv
bid0IHN1ZmZlciBmcm9tCj4gdGhpcyBtZW1vcnkgZnJhZ21lbnRhdGlvbiwgY29ycmVjdD8KClll
cywgaHVnZV9wYWdlcz10cnkgaXMgdGhlIGRlZmF1bHQgb3B0aW9uLCBidXQgd2l0aG91dCBwcmUt
YWxsb2NhdGluZyB0aGUKZW50aXJlIHNoYXJlZF9idWZmZXIgc2l6ZSBpbiBtZW1vcnkgdmlhICJ2
bS5ucl9odWdlcGFnZXMiIOKAlCB3aGljaCBpcyBub3QKZG9uZSBhdXRvbWF0aWNhbGx5IOKAlCBo
dWdlIHBhZ2VzIHdpbGwgbm90IGJlIHVzZWQgYW5kIHRoZSBzeXN0ZW0gZmFsbHMgaW50bwp0aGUg
aHVnZV9wYWdlcz1vZmYgY2F0ZWdvcnkuIEV2ZW4gd2l0aCBhIHBhcnRpYWwgcHJlLWFsbG9jYXRp
b24sIFBvc3RncmVTUUwKd2lsbCBub3QgYmUgYWJsZSB0byB1c2UgaHVnZXBhZ2VzLgoKCk9uIDUv
MDMvMjYgMTE6NTUsIE1hdHRoZXcgV2lsY294IHdyb3RlOgo+IG9yIHdlIG5lZWQgbW9yZSB1bmRl
cnN0YW5kYWJsZSBHRlAgZmxhZ3MuICBPciB0aGUgcGFnZSBhbGxvY2F0b3IgY291bGQKPiB1c2Ug
dGhlIF9fR0ZQX05PUkVUUlkgZmxhZyB0byBzYXkgIm9oIHdlbGwsIHRoaXMgYWxsb2NhdGlvbiBo
YXMgYSBmYWxsYmFjaywKPiBJJ2xsIGtpY2sga2NvbXBhY3RkIHRvIHRyeSB0byBjb21wYWN0IHNv
bWUgbW9yZSBtZW1vcnksIGJ1dCBJJ2xsIGZhaWwKPiB0aGUgYWxsb2NhdGlvbiIuCgpXZSBhbHNv
IHRlc3RlZCBraWNraW5nIG9mZiBrY29tcGFjdGQgaW4gdGhlIGJhY2tncm91bmQgd2hlbiBfX0dG
UF9OT1JFVFJZIGlzCnBhc3NlZCwgcmV0dXJuaW5nICJub3BhZ2UiIHRvIGF2b2lkIGJsb2NraW5n
IHRoZSBmb2xpbyBhbGxvY2F0aW9uIHJlcXVlc3QuIApIZXJlIGlzIHRoZSBwYXRjaCB0ZXN0ZWQg
YXMgdGhlIG90aGVyIHdpdGggUFJFRU1QVF9OT05FIHBhdGNoIFsxXToKCgpkaWZmIC0tZ2l0IGEv
bW0vcGFnZV9hbGxvYy5jIGIvbW0vcGFnZV9hbGxvYy5jCmluZGV4IDY1ZTIwNTExMTU1My4uZDRm
MzIyOTEwOTkyIDEwMDY0NAotLS0gYS9tbS9wYWdlX2FsbG9jLmMKKysrIGIvbW0vcGFnZV9hbGxv
Yy5jCkBAIC00ODE4LDYgKzQ4MTgsMjYgQEAgX19hbGxvY19wYWdlc19zbG93cGF0aChnZnBfdCBn
ZnBfbWFzaywgdW5zaWduZWQgaW50IG9yZGVyLAogCWlmIChjdXJyZW50LT5mbGFncyAmIFBGX01F
TUFMTE9DKQogCQlnb3RvIG5vcGFnZTsKIAorCS8qCisJICogQ29zdGx5IGFsbG9jYXRpb25zIHdp
dGggX19HRlBfTk9SRVRSWSBhcmUgb3Bwb3J0dW5pc3RpYyAtIERvbid0CisJICogc3RhbGwgb24g
ZGlyZWN0IGNvbXBhY3Rpb24gb3IgcmVjbGFpbTsgaW5zdGVhZCwga2ljaworCSAqIGtjb21wYWN0
ZCBvbiB0aGUgcHJlZmVycmVkIG5vZGUgc28gbGFyZ2UgcGFnZXMgbWF5IGJlY29tZQorCSAqIGF2
YWlsYWJsZSBmb3IgZnV0dXJlIGFsbG9jYXRpb25zIGFuZCBsZXQgdGhlIGNhbGxlciBmYWxsIGJh
Y2sgbm93LgorCSAqCisJICogRGlyZWN0IGNvbXBhY3Rpb24gaXMgd2F5IHRvbyBjb3N0bHkgZm9y
IGhvdCBhbGxvY2F0aW9uIHBhdGhzIG9uCisJICogbGFyZ2Ugc3lzdGVtczogZWFjaCBhdHRlbXB0
IGNhbGxzIGRyYWluX2FsbF9wYWdlcygpIHdoaWNoIElQSXMKKwkgKiBldmVyeSBDUFUuICBPbmx5
IHdha2Uga2NvbXBhY3RkIG9uIHRoZSBsb2NhbCBub2RlIHRvIGF2b2lkCisJICogY3Jvc3MtTlVN
QSBpbnRlcmZlcmVuY2Ugd2l0aCB1bnJlbGF0ZWQgd29ya2xvYWRzLgorCSAqLworCWlmIChjb3N0
bHlfb3JkZXIgJiYgKGdmcF9tYXNrICYgX19HRlBfTk9SRVRSWSkpIHsKKwkJc3RydWN0IHpvbmUg
KnByZWZlcnJlZF96b25lID0gYWMtPnByZWZlcnJlZF96b25lcmVmLT56b25lOworCisJCWlmIChw
cmVmZXJyZWRfem9uZSkKKwkJCXdha2V1cF9rY29tcGFjdGQocHJlZmVycmVkX3pvbmUtPnpvbmVf
cGdkYXQsIG9yZGVyLAorCQkJCQkgYWMtPmhpZ2hlc3Rfem9uZWlkeCk7CisJCWdvdG8gbm9wYWdl
OworCX0KKwogCS8qIFRyeSBkaXJlY3QgcmVjbGFpbSBhbmQgdGhlbiBhbGxvY2F0aW5nICovCiAJ
aWYgKCFjb21wYWN0X2ZpcnN0KSB7CiAJCXBhZ2UgPSBfX2FsbG9jX3BhZ2VzX2RpcmVjdF9yZWNs
YWltKGdmcF9tYXNrLCBvcmRlciwgYWxsb2NfZmxhZ3MsCgoKCkhlcmUgYXJlIHRoZSByZXN1bHRz
IHdlIGNvbGxlY3RlZCAoa2NvbXBhY3RkIGJhY2tncm91bmQpOgoKfCBQYXRjaCAgICAgICAgICAg
ICAgICB8ICAgIFJ1biAxICAgfCAgICBSdW4gMiAgIHwgICAgUnVuIDMgICB8ICAgQXZlcmFnZSAg
IHwgJSB2cyBCYXNlbGluZSB8CnwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tOnwt
LS0tLS0tLS0tLTp8LS0tLS0tLS0tLS06fC0tLS0tLS0tLS0tLTp8Oi0tLS0tLS0tLS0tLS06fAp8
IEJhc2VsaW5lICAgICAgICAgICAgIHwgMTA3LDA2NC42MSB8ICA5NywwNDMuODYgfCAxMDEsODMw
Ljc4IHwgMTAxLDk3OS43NSAgfCAgICAgICDigJQgICAgICAgfAp8IFByb3Bvc2VkIHBhdGNoICAg
ICAgIHwgMTQ2LDAxMi4yMyB8IDEzNiwzOTIuMzYgfCAxNDEsMTc4LjAwIHwgMTQxLDE5NC4yMCAg
fCAgICArMzguNDUlICAgIHwKfCBSaXRlc2gncyBzdWdnZXN0aW9uICB8IDE0Nyw0ODEuNTAgfCAx
MzMsMDY5LjAzIHwgMTM3LDA1MS4zMCB8IDEzOSwyMDAuNjEgIHwgICAgKzM2LjUwJSAgICB8Cnwg
TWF0dGhldydzIHN1Z2dlc3Rpb24gfCAxNDUsNjUzLjkxIHwgMTQ0LDE2OS4yNCB8IDE0MSw3Njgu
MzEgfCAxNDMsODYzLjgyICB8ICAgICs0MS4wNyUgICAgfAp8IGtjb21wYWN0ZCBiYWNrZ3JvdW5k
IHwgMTQ2LDc2MC43NSB8IDEyOCwwOTQuOTIgfCAxMjcsOTc5Ljc0IHwgMTM0LDI3OC40NyAgfCAg
ICArMzEuNjclICAgIHwKCiAgClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0
MDMxOTE5NDIuMjE0MTAtMS1kaXBpZXRzQGFtYXpvbi5pdC9ULyNtOGJhZWVhZjQ4YWE3YWU1MzQy
YzhjMmRiOGY0ZTFjMjdlMDNjMTM2OAoKCgoKCkFNQVpPTiBERVZFTE9QTUVOVCBDRU5URVIgSVRB
TFkgU1JMLCB2aWFsZSBNb250ZSBHcmFwcGEgMy81LCAyMDEyNCBNaWxhbm8sIEl0YWxpYSwgUmVn
aXN0cm8gZGVsbGUgSW1wcmVzZSBkaSBNaWxhbm8gTW9uemEgQnJpYW56YSBMb2RpIFJFQSBuLiAy
NTA0ODU5LCBDYXBpdGFsZSBTb2NpYWxlOiAxMC4wMDAgRVVSIGkudi4sIENvZC4gRmlzYy4gZSBQ
LklWQSAxMDEwMDA1MDk2MSwgU29jaWV0YSBjb24gU29jaW8gVW5pY28KCgo=


