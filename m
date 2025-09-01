Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7568CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DD38E001A; Mon,  1 Sep 2025 04:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175068E0002; Mon,  1 Sep 2025 04:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B23D8E001A; Mon,  1 Sep 2025 04:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEE018E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:29:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99B771606F8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:29:15 +0000 (UTC)
X-FDA: 83840006670.20.05D176A
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7E2120004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:29:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="b kStn7t";
	spf=pass (imf13.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiQGrPDGIQy2w2GoqtOwTVJzYrsAW1FwxDcYA3G+Lw8=;
	b=oTCFGFpovwup3KZlCfd3YF0dP2QooWMazkoCy2JgYzK1B5rYQMY01B80f65eUpa5L0uyYc
	99HsAeQt2QbhJ0Pwg5WdRrLhXwgqtvDhoe9x1BIZwhYSOAXp06rF5VY3bMDUTtcxNaCM39
	iB6UM0//wRD/PZf3CwiNasOFCKpL8jY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715353; a=rsa-sha256;
	cv=none;
	b=kpf8dTMN0dWfEdClpszHE/io3AO4CdPas/kxrHYfD1Db9NQJWU6wZudlkMmhgkm3NmzJNn
	/ZmemLvgwpxkPOOggbnJhhjzT+VotRSYkT1ydN1CDYpuHFXJ0mFHV6tdt6mO5jSqo3MbGP
	8md+3qKehLtoB9Lwh42WwOOhAH5NFlU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="b kStn7t";
	spf=pass (imf13.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=j5PJ2+yjz1EmUPb6Z1UJJ6UB8vR7LqQz1AQRzce8lPU=; b=b
	kStn7t/V8eq/iZd9uruH9IJ86zUK1m5DmyvuNvD0/UCPpRGXYqpVjs/QpEit2QFg
	6I+HubjY3j0rzOOszSjTm5GfkX8c3OvfWPInRgBJ+t7v2MOY5JLcNzxTslWl3XU5
	QxhVyvSj+kBPPpsv6LH7+Uqiuhbgb0HfUmMJxStwgU=
Received: from yangshiguang1011$163.com ( [1.202.162.48] ) by
 ajax-webmail-wmsvr-40-108 (Coremail) ; Mon, 1 Sep 2025 16:29:02 +0800 (CST)
X-Originating-IP: [1.202.162.48]
Date: Mon, 1 Sep 2025 16:29:02 +0800 (CST)
From: yangshiguang  <yangshiguang1011@163.com>
To: "Vlastimil Babka" <vbabka@suse.cz>
Cc: "David Rientjes" <rientjes@google.com>, harry.yoo@oracle.com,
	akpm@linux-foundation.org, cl@gentwo.org, roman.gushchin@linux.dev,
	glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
Subject: Re:Re: [PATCH v4] mm: slub: avoid wake up kswapd in
 set_track_prepare
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20250519(9504565a)
 Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <7f30ddd1-c6f7-4b2b-a2b9-875844092e28@suse.cz>
References: <20250830020946.1767573-1-yangshiguang1011@163.com>
 <c8f6933e-f733-4f86-c09d-8028ad862f33@google.com>
 <7f30ddd1-c6f7-4b2b-a2b9-875844092e28@suse.cz>
X-NTES-SC: AL_Qu2eBPuauksv5CKfZOkfmUgRj+k6WsK3s/sn3oNfP5B+jCLp+zE7R3NTB2LO79CDEC6NnQiHawJv0ehAb5dHTZwLRzc2zXorPS8GrhfNFYzcXQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <11922bd5.7fae.1990464d9c8.Coremail.yangshiguang1011@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bCgvCgD33xlOWbVoDEAmAA--.2284W
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/xtbBMRG75Wi1Tx-TjAAEso
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7E2120004
X-Stat-Signature: zx3shaifu6rrbadcyeogt8k6ztaok45i
X-Rspam-User: 
X-HE-Tag: 1756715352-996931
X-HE-Meta: U2FsdGVkX18kema7Ipds+lQtHl3a1sHSpKtorhz5vBjWb8GAev3YOMWbbbf4Fcrlwcj67Z56VA/SANn0FA5I+R6nCdCw9F5tSlHJ3YgpHmNwgxKmZ/LrLtt1m+2Yjd6tByI1NTvCqj8fxyAm07/jBtZ8jdCWaMVhojTuTPNZVNKgy7keN9CvTeWAnMttP7HBfnFVIYRyQiNd8q3glslQbUtiAuwuT6oJJxlHkZnOmvj8hcvk3CL+6KS2yHZnIetGCqcKr7iUeuvELaVoOSxBLuDpa1oHPGP8y6auqWwvjWni6EjnzbnGpZtTHH/HeUQd2la1EmMF26cDRJTfOgg8U/ZfDqe20kOu41ckkb0A4AjOKkoTxSl9swCnNECVzD0b5MLOKjvzsd9cokj8L22UmdFtJzKWBVVzLOoMG4Nbm/HrYpUrcQvGBvlrpVfyCPbVGNkdZ6e8g8U0uyNY/GiRf5mjH/1ljRw1HY9rQzZDJCUZcIX5mAxewJZTH6bHZxZXVkKJ49RXd9bEAKMLqVqfJ5F2TehMOJyI/Y7KX9ZREBsfoqaDU1holZXFHq6obSK38ZPhJ9tHFxQZmmoBVMbS6CjS7puvxo+0j5SOe5+SLlvlcJHv5O5KueeZzYb/xxZFQAHYZBgqU8FYmgNf91gtRkFRvdWWODe2iezI7XTEC7AqCoSOIshKMT2UeNDw5hdc8B5Q/p5ooXfb5FtrsW0thr6VYUcfjmDMVk3wPcQ8a2AzD+d8QQqGTjSyNozbj8MRB5V63zTlBQ7aedsgvVCrCpbnI6u/Ey3a9olW5Aumb/MzB3LGQutlP+7SS5vRjcXkWOWp6V/nxeNNp6gm1DF9LYZP0AiqhBk69IKrOMyRhc8Cv+Kh4KhD73TmFrQUjlboGeiFol3k+rMIYJbRpe+KlHvm0ac7cziTJjawnV7FnTqmkNslgibuSBDZ0li2YEdi+FJeshvGaryXCNep3It
 1YyCFdxK
 w9EMLpytI2ZOpO71ThobQ0DrKNuZ+GtDsrH61LFrhBACCm87lPMOpvw9uWVBBzAoNpSFFZ1ARnEDWNmTHXFV/GzaZwSRFNhSPL+sCr8RpHv2W6iyWg6NOFtp/9V8EEfYaZlh/R79df2fk39fctbK5oO5/sXTcr5GgQeH8VPIbiDHndRDe/P9xsuOOGy/xpvC5FvQd1DbgHnxqcdhSmtJs1M0WUtxH/xl6CmHr+uPxhtJ5uiAv7B3JFIUfA7w27ztKJzEz5pl8W6p8zzE5MJAz82p97lklQuUuf8pINzlQ+hLBAFkab7Vkm1fh4Cu164CTX8s88+ccKARk11KPb9qyj5wsaQHh11YlCu0CW1ADrHgD261uiLF5TpwhM25mcHVMD+MjPatfO0mXhhcwWVfWvBElPjYPT3/GBvl3vQAsP1J4lKpymS4qAuqixRx5+rAlhL0UBNbRs+EQPkzZmJcDkM9Cl7Apoex9et9mJjqGvdUlCZx6Je0pS+kfAYQde4SkaI7Vwcmlunm5bcg+0G3lN/1Q9n76UmNNGd5lwZrNx+ejQKNo6SFnAu64DOBnhfutIXaX0wh7Ulzun/aOZKhjmOjW8hZt0t8PBTs13ocvpIx+QeUR/fiHX56KQZZHUd0fu+Fe6SGPlI8Jo5bCUxe9I+lMqhlHof+eDwMN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgpBdCAyMDI1LTA5LTAxIDE2OjE1OjA0LCAiVmxhc3RpbWlsIEJhYmthIiA8dmJhYmthQHN1c2Uu
Y3o+IHdyb3RlOgo+T24gOS8xLzI1IDA5OjUwLCBEYXZpZCBSaWVudGplcyB3cm90ZToKPj4gT24g
U2F0LCAzMCBBdWcgMjAyNSwgeWFuZ3NoaWd1YW5nMTAxMUAxNjMuY29tIHdyb3RlOgo+PiAKPj4+
IEZyb206IHlhbmdzaGlndWFuZyA8eWFuZ3NoaWd1YW5nQHhpYW9taS5jb20+Cj4+PiAKPj4+IEZy
b206IHlhbmdzaGlndWFuZyA8eWFuZ3NoaWd1YW5nQHhpYW9taS5jb20+Cj4+PiAKPj4gCj4+IER1
cGxpY2F0ZSBsaW5lcy4KPj4gCj4+PiBzZXRfdHJhY2tfcHJlcGFyZSgpIGNhbiBpbmN1ciBsb2Nr
IHJlY3Vyc2lvbi4KPj4+IFRoZSBpc3N1ZSBpcyB0aGF0IGl0IGlzIGNhbGxlZCBmcm9tIGhydGlt
ZXJfc3RhcnRfcmFuZ2VfbnMKPj4+IGhvbGRpbmcgdGhlIHBlcl9jcHUoaHJ0aW1lcl9iYXNlcylb
bl0ubG9jaywgYnV0IHdoZW4gZW5hYmxlZAo+Pj4gQ09ORklHX0RFQlVHX09CSkVDVFNfVElNRVJT
LCBtYXkgd2FrZSB1cCBrc3dhcGQgaW4gc2V0X3RyYWNrX3ByZXBhcmUsCj4+PiBhbmQgdHJ5IHRv
IGhvbGQgdGhlIHBlcl9jcHUoaHJ0aW1lcl9iYXNlcylbbl0ubG9jay4KPj4+IAo+Pj4gQXZvaWQg
ZGVhZGxvY2sgY2F1c2VkIGJ5IGltcGxpY2l0bHkgd2FraW5nIHVwIGtzd2FwZCBieQo+Pj4gcGFz
c2luZyBpbiBhbGxvY2F0aW9uIGZsYWdzLiBBbmQgdGhlIHNsYWIgY2FsbGVyIGNvbnRleHQgaGFz
Cj4+PiBwcmVlbXB0aW9uIGRpc2FibGVkLCBzbyBfX0dGUF9LU1dBUERfUkVDTEFJTSBtdXN0IG5v
dCBhcHBlYXIgaW4gZ2ZwX2ZsYWdzLgo+Pj4gCj4+IAo+PiBUaGlzIG1lbnRpb25zIF9fR0ZQX0tT
V0FQRF9SRUNMQUlNLCBidXQgdGhlIHBhdGNoIGFjdHVhbGx5IG1hc2tzIG9mZiAKPj4gX19HRlBf
RElSRUNUX1JFQ0xBSU0gd2hpY2ggd291bGQgYmUgYSBoZWF2aWVyd2VpZ2h0IG9wZXJhdGlvbi4g
IERpc2FibGluZyAKPj4gZGlyZWN0IHJlY2xhaW0gZG9lcyBub3QgbmVjZXNzYXJpbHkgaW1wbHkg
dGhhdCBrc3dhcGQgd2lsbCBiZSBkaXNhYmxlZCBhcyAKPj4gd2VsbC4KPgo+WWVhaCBJIHRoaW5r
IHRoZSBjaGFuZ2Vsb2cgc2hvdWxkIHNheSBfX0dGUF9ESVJFQ1RfUkVDTEFJTS4KPgo+PiBBcmUg
eW91IG1lYW5pbmcgdG8gY2xlYXIgX19HRlBfUkVDTEFJTSBpbiBzZXRfdHJhY2tfcHJlcGFyZSgp
Pwo+Cj5ObyBiZWNhdXNlIGlmIHRoZSBjb250ZXh0IGNvbnRleHQgKGUuZy4gdGhlIGhydGltZXJz
KSBjYW4ndCBzdXBwb3J0Cj5fX0dGUF9LU1dBUERfUkVDTEFJTSBpdCB3b24ndCBoYXZlIGl0IGlu
IGdmcF9mbGFncyBhbmQgd2Ugbm93IHBhc3MgdGhlbSB0bwoKPnNldF90cmFja19wcmVwYXJlKCkg
c28gaXQgYWxyZWFkeSB3b24ndCBiZSB0aGVyZS4KCgpTcnkuIFNob3VsZCBiZSBfX0dGUF9ESVJF
Q1RfUkVDTEFJTS4gSSB3aWxsIHJlc2VuZCB0aGUgcGF0Y2gu

