Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C30C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF206B007B; Wed,  5 Aug 2026 23:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6816B0092; Wed,  5 Aug 2026 23:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5186B0093; Wed,  5 Aug 2026 23:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977296B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:24:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4DDB160655
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:24:30 +0000 (UTC)
X-FDA: 85069401900.11.BFC2659
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4796F140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:24:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="O ARSO5I";
	spf=pass (imf23.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785986668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubheXKmm/hRAQBYM06zgEnkjBkgTAVDnF7ilmxHIngU=;
	b=VIw/3oBNYRJRZrJCXcFGs97cW4kwE6vIewfSdodFYmCmxfFiysGIievFCGlRHT2qt5loo2
	kFC9lsJayQp8PZjMMJjF69j2NNYCnDKFFBgeVXGY7wReMA4/mgmjBybNRm2ZMjRS0MVaT+
	KSflO2y5CG97jmNKedJ1h1I7uYDjvzg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="O ARSO5I";
	spf=pass (imf23.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785986668;
	b=FNePuyZl+0+TnvpH+Ze/n0UpUwJvGxCJGbXJN4JFoyvRsdAZ940aPa+il4bOUl+ZLpTva/
	aaGlHkeOUXdea1lnyuT5gWlLTKEy6W4ftqGiR315vumvpDcK36pbRNMXnact9M4303DRJA
	II+2S2jL66b1/o1F12Sl+C7Zv/grD0w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=ubheXKmm/hRAQBYM06zgEnkjBkgTAVDnF7ilmxHIngU=; b=O
	ARSO5IT6dVSNqrjvffp4VGHty0MRabhvs0RcNjJa1j5jUaXZVmYcVLt6+VA589N7
	iZzzJHQa+aQ1MCMXEUDXGATQ2MWPsel8H1R03v3L37BTAd8bA1hQF91G8E4DEIkG
	LZj6B9nu4U62IMM36AMQ8fhuJtjC7uazrvvl6880/A=
Received: from dayou5941$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-112 (Coremail) ; Thu, 6 Aug 2026 11:24:23 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date: Thu, 6 Aug 2026 11:24:23 +0800 (CST)
From: =?UTF-8?B?5p2O5L2R6bi/IA==?= <dayou5941@163.com>
To: jane.chu@oracle.com
Cc: linmiaohe@huawei.com, akpm@linux-foundation.org, nao.horiguchi@gmail.com,
	linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>
Subject: Re:Re: [PATCH v2] mm/memory-failure: fix refcount leak on
 soft-offline LBS folio
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <1a2536fc-afd5-4831-b5b9-6d970d29f0b4@oracle.com>
References: <20260804035356.2615408-1-dayou5941@163.com>
 <1a2536fc-afd5-4831-b5b9-6d970d29f0b4@oracle.com>
X-NTES-SC: AL_Qu2TB/WTuU4t5SGbZ+kckk4Wjug8Wcexufwj34NTc/gEvRjV0REnV1NKGX7U//iTDTieiBmqbDRhxuV3ZZN3lZyGwSepYdN5WvVMEAud0w==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <195bc5ad.2b62.19fd519c2e3.Coremail.dayou5941@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cCgvCgD3f+hn_nNqYb0sAA--.6738W
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+gdQ-mpz-melEwAA3l
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4796F140004
X-Stat-Signature: oipsk74upqpyzbpane64it9c33qu1kq7
X-HE-Tag: 1785986666-566439
X-HE-Meta: U2FsdGVkX19N2B714VNXOfnOY0xYLNLBtknmSBlJQ8PUUKS1Tr+rubxQ6yk8wBS6bz+5O1Sh69hbHwrbkYosK1L70/4WD2LiBcVw0IO8Vu9Bf08pTYktx7g65kLvo8EquQQ3rt1zzfRh09HL3PvUcT0oXrzQuB5TK3KJaJKTBgOnbRWg+6hdNVrXdXXokDOH94tRPp3Un7AXp8LMLRVUlzIbQAQfaFtMQqsqDjHytqLI+pbyfPRXsCY+wcZkNTHeuhRXiphOG0txsCvcb4f0Dsi20c/yYur0Lg+YC/DJ0YRET2PC6cYlO9voZFwIcSeFymePzJ3FZReLNJsn7+FN8Pe2g7LYJiLV/ztAqWXQDB8CqzDOfkyOH1pppx/3uajp9Qg6h2WJHfDs+pl+iPcR+qDaNzmElzhOW02hIRLyLerKeKRR04GVbeuXz2/hy6fsC0/Fi1/1WEtN2bVB71ulJdbwUVceKr+gdm39WQoFv72Nc7rQ093ZLn+HjDsjl3WkbhhXt0f7VwhMr5P6+ptwzfOOVpLpLbA6JV9SjrCMV77vviiJVjXfwMOzpPhghszo1El8E1hz6+uh4ZoDpyZBoIkka5eY/VBVr8+50bjPL/uKhxJEeOBnxnrNPcWjaizgYX+LKXhliIWo309mj3CQk9WpnBT5bFePFB88gQg/SEMCXai/J83AMbDjpCP8UQ7r3JkXlnNYNigzLgBdmZO4EA/i7AasXSaGTwY1iy0Iq+53tURsYdBHkhFo84TJctKZFwJF28yHyj+fa3JmhV3akHEiZQXU3QokoZ2SNv9qrRyX4E9y3P2vuMRpvZU/IJAugOS23TXyLdr+MyEI2XyggnmOqOayvobFflCA35s3uhBcvJdcqSrX17yX54jlt9C736PxM0JM/0M1IfLMfRrpZeLNoWbmSGnaSYbs7TKZ301ICxVjIeUw9rHSAlxhWIwq0KQkMCCbtStkZC48EcK
 jRH7iCuf
 32FmaI/gS01ZxXGuCYykgtq+y3Q6NKcAtGuUXP6lyOzCtEwxBCvTNC8DIsD0VFCZQ55oHqQWfoK3gRLbEsfBVBidcK6u3yUqUgURecomrl2CmtiC2kY93RI2vWRqZCcIjXgeoC63R+WKOJ8zMwgZaKqaYCVhdr/L2oDyPa4LXiIR8vtpR/mdoAer7q5PHzXe+W7N6afFzfCPrDvdQiamfoDMm2r71qVBJRDyXl4+PnkYgUYFtZOMII6b8GswpBmIuMLIzwwrCj8pYF+Z9mcLhcX9qRNEl+FQkr/fVc8Z1aRkHlTVCRnUzCJphuHqJUpv2Op7WNmxcZ41fvllXAZPRxv2B2YsvssfGNeXtGVujcvO054Ds3x20BwdNWI1BiWGsd8MVBzF/cmPNJ5CozexMJXsHNeX7PM+hiXq1TRxKTvcGITEManEyTThUUmDESs7niBl03KfAgZa316zLvzTsX9NdtKmn/ayADeIBETeHnyloxqB1PAOApNk5K3TGUO/USyKG1rE6ZBWK/Qixo+W+m3jyLo9nTf4Asx861wWYmm0+M+cdyi3RX4RfMQhbcL81mKSnP4OvhtgTAri13bYW/Dr8RW9oVK0kF7XPGtSy4oMtaXKR8cAw3z4pKqRITth8uvPx+lDSPXzoETY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCgoKCgoKCgoKCgoKCgpBdCAyMDI2LTA4LTA2IDA3OjMzOjA4LCBqYW5lLmNodUBvcmFjbGUu
Y29tIHdyb3RlOgo+Cj4KPk9uIDgvMy8yMDI2IDg6NTMgUE0sIGRheW91NTk0MUAxNjMuY29tIHdy
b3RlOgo+PiBGcm9tOiBsaXlvdWhvbmcgPGxpeW91aG9uZ0DigIpreWxpbm9zLuKAimNuPiBzb2Z0
X29mZmxpbmVfaW5fdXNlX3BhZ2UoKSBydW5zIAo+PiB3aXRoIGEgZm9saW8gcmVmZXJlbmNlIHRh
a2VuIGJ5IGdldF9od3BvaXNvbl9wYWdlKCkuIFNvZnQtb2ZmbGluZSBza2lwcyAKPj4gc3BsaXR0
aW5nIHdoZW4gbWluX29yZGVyX2Zvcl9zcGxpdCgpIGlzIG5vbi16ZXJvLCBzbyBsYXJnZSBmb2xp
b3Mgc3RheSAKPj4gaW50YWN0LiBUaGF0IGVhcmx5IHJldHVybgo+PiAKPj4gCj4+IEZyb206IGxp
eW91aG9uZyA8bGl5b3Vob25nQGt5bGlub3MuY24+Cj4+IAo+PiBzb2Z0X29mZmxpbmVfaW5fdXNl
X3BhZ2UoKSBydW5zIHdpdGggYSBmb2xpbyByZWZlcmVuY2UgdGFrZW4gYnkKPj4gZ2V0X2h3cG9p
c29uX3BhZ2UoKS4KPj4gCj4+IFNvZnQtb2ZmbGluZSBza2lwcyBzcGxpdHRpbmcgd2hlbiBtaW5f
b3JkZXJfZm9yX3NwbGl0KCkKPj4gaXMgbm9uLXplcm8sIHNvIGxhcmdlIGZvbGlvcyBzdGF5IGlu
dGFjdC4gVGhhdCBlYXJseQo+PiByZXR1cm4gLUVCVVNZIHBhdGggbmV2ZXIgZHJvcHMgdGhlIHJl
ZmVyZW5jZS4KPj4gCj4+IFRoZSBvdGhlciBmYWlsdXJlIHBhdGggaXMgZmluZTogdHJ5X3RvX3Nw
bGl0X3RocF9wYWdlKC4uLiwgcmVsZWFzZT10cnVlKQo+PiBwdXRzIHRoZSBwYWdlIHdoZW4gdGhl
IHNwbGl0IGl0c2VsZiBmYWlscy4gbWVtb3J5X2ZhaWx1cmUoKSBhbHNvIHB1dHMKPj4gZXhwbGlj
aXRseSBvbiBpdHMgYW5hbG9nb3VzIHVuc3BsaXQgcGF0aC4KPj4gCj4+IEhhbmRsZSB0aGUgbmV3
X29yZGVyICE9IDAgY2FzZSBzZXBhcmF0ZWx5IGFuZCBjYWxsIGZvbGlvX3B1dCgpCj4+IGJlZm9y
ZSByZXR1cm5pbmcuCj4+IAo+PiBGaXhlczogNjg5Yjg5ODY3NzZjICgibW0vbWVtb3J5LWZhaWx1
cmU6IGltcHJvdmUgbGFyZ2UgYmxvY2sgc2l6ZSBmb2xpbyBoYW5kbGluZyIpCj4+IFNpZ25lZC1v
ZmYtYnk6IGxpeW91aG9uZyA8bGl5b3Vob25nQGt5bGlub3MuY24+Cj4+IC0tLQo+PiB2MjoKPj4g
LSBBZGQgZG9jdW1lbnRhdGlvbiBmb3IgdGhlIGZvbGlvIHJlZmVyZW5jZSBjb3VudGluZyBjb252
ZW50aW9uIG9mIHNvZnRfb2ZmbGluZV9pbl91c2VfcGFnZSgpLgo+PiAtIFJlbW92ZSBNRl9DT1VO
VF9JTkNSRUFTRUQgcmVsYXRlZCBkZXNjcmlwdGlvbiBpbiBjb21taXQgbWVzc2FnZSB0byBhdm9p
ZCBtaXNsZWFkaW5nLgo+PiB2MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwODAz
MDYwMDAxLjgwMDYzOC0xLWRheW91NTk0MUAxNjMuY29tLwo+PiAKPj4gLS0tCj4+ICAgbW0vbWVt
b3J5LWZhaWx1cmUuYyB8IDE3ICsrKysrKysrKysrKysrKy0tCj4+ICAgMSBmaWxlIGNoYW5nZWQs
IDE1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvbW0v
bWVtb3J5LWZhaWx1cmUuYyBiL21tL21lbW9yeS1mYWlsdXJlLmMKPj4gaW5kZXggNTE1MDhhNTVj
NDA1Li4zYjFlNjk0NjgyMWIgMTAwNjQ0Cj4+IC0tLSBhL21tL21lbW9yeS1mYWlsdXJlLmMKPj4g
KysrIGIvbW0vbWVtb3J5LWZhaWx1cmUuYwo+PiBAQCAtMjc3Niw2ICsyNzc2LDkgQEAgRVhQT1JU
X1NZTUJPTCh1bnBvaXNvbl9tZW1vcnkpOwo+PiAgICAqIHNvZnRfb2ZmbGluZV9pbl91c2VfcGFn
ZSBoYW5kbGVzIGh1Z2V0bGItcGFnZXMgYW5kIG5vbi1odWdldGxiIHBhZ2VzLgo+PiAgICAqIElm
IHRoZSBwYWdlIGlzIGEgbm9uLWRpcnR5IHVubWFwcGVkIHBhZ2UtY2FjaGUgcGFnZSwgaXQgc2lt
cGx5IGludmFsaWRhdGVzLgo+PiAgICAqIElmIHRoZSBwYWdlIGlzIG1hcHBlZCwgaXQgbWlncmF0
ZXMgdGhlIGNvbnRlbnRzIG92ZXIuCj4+ICsgKgo+PiArICogVGhlIGZvbGlvIHJlZmNvdW50IGhh
cyBiZWVuIGluY3JlbWVudGVkIGJlZm9yZSBlbnRlcmluZyB0aGlzIGZ1bmN0aW9uLgo+PiArICog
VGhpcyBmb2xpbyByZWZlcmVuY2UgbXVzdCBiZSByZWxlYXNlZCBiZWZvcmUgdGhlIGZ1bmN0aW9u
IHJldHVybnMgb24gYWxsIHBhdGhzLgo+PiAgICAqLwo+PiAgIHN0YXRpYyBpbnQgc29mdF9vZmZs
aW5lX2luX3VzZV9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQo+PiAgIHsKPj4gQEAgLTI4MDEsOSAr
MjgwNCwxOSBAQCBzdGF0aWMgaW50IHNvZnRfb2ZmbGluZV9pbl91c2VfcGFnZShzdHJ1Y3QgcGFn
ZSAqcGFnZSkKPj4gICAJCSAqIE5PVEU6IGlmIG1pbmltaXppbmcgdGhlIG51bWJlciBvZiBzb2Z0
IG9mZmxpbmUgcGFnZXMgaXMKPj4gICAJCSAqIHByZWZlcnJlZCwgc3BsaXQgaXQgdG8gbm9uLXpl
cm8gbmV3X29yZGVyIGxpa2UgaXQgaXMgZG9uZSBpbgo+PiAgIAkJICogbWVtb3J5X2ZhaWx1cmUo
KS4KPj4gKwkJICoKPj4gKwkJICogRHJvcCB0aGUgcmVmZXJlbmNlIG9idGFpbmVkIHVwb24gZW50
cnk7Cj4+ICsJCSAqIHRyeV90b19zcGxpdF90aHBfcGFnZSguLi4sIHJlbGVhc2U9dHJ1ZSkgaGFu
ZGxlcyByZWZjb3VudGluZyBpdHNlbGYKPj4gKwkJICogd2hlbiB0aGUgc3BsaXQgZmFpbHMuCj4+
ICAgCQkgKi8KPj4gLQkJaWYgKG5ld19vcmRlciB8fCB0cnlfdG9fc3BsaXRfdGhwX3BhZ2UocGFn
ZSwgLyogbmV3X29yZGVyPSAqLyAwLAo+PiAtCQkJCQkJICAgICAgIC8qIHJlbGVhc2U9ICovIHRy
dWUpKSB7Cj4+ICsJCWlmIChuZXdfb3JkZXIpIHsKPj4gKwkJCXByX2luZm8oIiUjbHg6IG9yZGVy
LSVkIGZvbGlvIGNhbm5vdCBzb2Z0IG9mZmxpbmVcbiIsCj4+ICsJCQkJcGZuLCBuZXdfb3JkZXIp
Owo+PiArCQkJZm9saW9fcHV0KGZvbGlvKTsKPj4gKwkJCXJldHVybiAtRUJVU1k7Cj4+ICsJCX0K
Pj4gKwkJaWYgKHRyeV90b19zcGxpdF90aHBfcGFnZShwYWdlLCAvKiBuZXdfb3JkZXI9ICovIDAs
Cj4+ICsJCQkJCSAvKiByZWxlYXNlPSAqLyB0cnVlKSkgewo+PiAgIAkJCXByX2luZm8oIiUjbHg6
IHRocCBzcGxpdCBmYWlsZWRcbiIsIHBmbik7Cj4+ICAgCQkJcmV0dXJuIC1FQlVTWTsKPj4gICAJ
CX0KPj4gLS0gCj4+IDIuMjUuMQo+PiAKPgo+SXQgc2VlbXMgbWUgdGhpcyB3aWxsIGRvIC0KPgo+
LS0tIGEvbW0vbWVtb3J5LWZhaWx1cmUuYwo+KysrIGIvbW0vbWVtb3J5LWZhaWx1cmUuYwo+QEAg
LTI4MDIsOCArMjgwMiw4IEBAIHN0YXRpYyBpbnQgc29mdF9vZmZsaW5lX2luX3VzZV9wYWdlKHN0
cnVjdCBwYWdlICpwYWdlKQo+ICAgICAgICAgICAgICAgICAgKiBwcmVmZXJyZWQsIHNwbGl0IGl0
IHRvIG5vbi16ZXJvIG5ld19vcmRlciBsaWtlIGl0IGlzIAo+ZG9uZSBpbgo+ICAgICAgICAgICAg
ICAgICAgKiBtZW1vcnlfZmFpbHVyZSgpLgo+ICAgICAgICAgICAgICAgICAgKi8KPi0gICAgICAg
ICAgICAgICBpZiAobmV3X29yZGVyIHx8IHRyeV90b19zcGxpdF90aHBfcGFnZShwYWdlLCAvKiAK
Pm5ld19vcmRlcj0gKi8gMCwKPi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAvKiByZWxlYXNlPSAqLyAKPnRydWUpKSB7Cj4rICAgICAgICAgICAg
ICAgaWYgKG5ld19vcmRlciB8fCB0cnlfdG9fc3BsaXRfdGhwX3BhZ2UocGFnZSwgZmFsc2UpKSB7
Cj4rICAgICAgICAgICAgICAgICAgICAgICBwdXRfcGFnZShwYWdlKTsKPiAgICAgICAgICAgICAg
ICAgICAgICAgICBwcl9pbmZvKCIlI2x4OiB0aHAgc3BsaXQgZmFpbGVkXG4iLCBwZm4pOwo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7Cj4gICAgICAgICAgICAgICAgIH0K
PgoKPgoKCkhpIEphbmUsCgpUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uISBJJ3ZlIGVuZGVkIHVw
IGdvaW5nIHdpdGggRGF2aWQncyBtb3JlCmNvbXByZWhlbnNpdmUgcmVmYWN0b3JpbmcgcGF0Y2gs
IHdoaWNoIGFsc28gZml4ZXMgdGhlIHJlZmNvdW50IGxlYWsuClRoZSB2NCBzZXJpZXMgaGFzIGJl
ZW4gc2VudCBvdXQ6CmxpbmvvvJpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA4MDYw
MzE5NTguNjc3OTM1LTEtZGF5b3U1OTQxQDE2My5jb20vCgpUaGFua3MsCllvdWhvbmcKCg==

