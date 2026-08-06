Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D392C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586C06B0093; Thu,  6 Aug 2026 03:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537CD6B0095; Thu,  6 Aug 2026 03:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E5D6B0096; Thu,  6 Aug 2026 03:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEB66B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:35:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F3451606B7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:35:00 +0000 (UTC)
X-FDA: 85070033160.08.9264411
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55183C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:34:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e cakaw1";
	spf=pass (imf28.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z10tA57nH14/OYA9ILI/KgFB2OkvvIxMoTAV1B3MhkA=;
	b=vR2n7yxd0o88zbgSoMRcFnTUC9AxALtgRlDfKj8MbJ0VRjmUdo5DAeit1oYioNDs5xVJWt
	1jV79HhbVIsmCFJl/Fy3z9rA2Fy16GGnRgUkGe1Fsmyrk+csx+2V26hD88ZcSo4HJLeNxd
	1oG+2jDEm2WnD0PtgQA/QULF2kxC0vo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786001698;
	b=v0+vtX/pbfksvVWqv+tdaMH1P7ag02xQ0NC6Lpb7dKLmbJk0L+zTh9bB16vtaPNoNyCB7D
	UjXgNhnUkKa2O5tQoPBMPz4jRGlLe5QWaEqBDgLr7vhLCX4PpjOcpBE2iEY4xAqnewyAG3
	YOYFVgSJ3NiN79iOun0VWLSer0DtSi8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e cakaw1";
	spf=pass (imf28.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=z10tA57nH14/OYA9ILI/KgFB2OkvvIxMoTAV1B3MhkA=; b=e
	cakaw1vrkKee4fJy+8oLciJsxQ450NOU4S5URAneF2jaefR/QbOizoZcxz5jC5Xh
	khw1pMw5Rqqj+9oRVXqtszqItjOTMjajPGreJBuaGtNB3qXyhJVrjw1ku4CL9Ic3
	8lDS6ZX8+SS5syij3H9DgcPz7Ua9olAGm5RUaCFH8s=
Received: from dayou5941$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-103 (Coremail) ; Thu, 6 Aug 2026 15:34:43 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date: Thu, 6 Aug 2026 15:34:43 +0800 (CST)
From: =?GBK?B?wO7T07roIA==?= <dayou5941@163.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	linux-mm@kvack.org, "Li Youhong" <liyouhong@kylinos.cn>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>
Subject: Re:Re: [PATCH] mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
 min_order_for_split()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <anQqEfCEbWmm5vX8@lucifer>
References: <20260806032116.681060-1-dayou5941@163.com>
 <anQqEfCEbWmm5vX8@lucifer>
X-NTES-SC: AL_Qu2TBPybvk4j5SCcbekckk4Wjug8Wcexufwj34NTc+wEuyn3/xkYXHtzD2H/7MC0JgGgtB62fCdfxP9AQZFYGzez9M8chiNV9j3+NqqVlw==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <17316ab0.5714.19fd5fef275.Coremail.dayou5941@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:ZygvCgD3FykUOXRqEREtAA--.14100W
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3hQLuWp0ORRxUAAA3q
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55183C0002
X-Rspam-User: 
X-Stat-Signature: tyo4f1ceznnp4cqdyr8wguy9ae1nnzrj
X-HE-Tag: 1786001696-440806
X-HE-Meta: U2FsdGVkX1+LG/nGfuUlqV9v2GqT2bZAooej+l9r7s9KgQZibyNdYSAyBAiFw8/uTKD3O1oele6RIKiGe4M3ZfO7H7k2sen3ORbFmFk+7z4VU/53onZ51Dcm/ZBgwaw+n+3+zeixaxjDo9jleWEh3Sq0K1ccFDkA/VW6YrDf4IZrvpAIhlJWwMC0jxRHhxe6jiw/Ir3FaDAX7Spmg4DZnQd0B3p01gxEsfD7ftm+97m6C1fGY2ev63GxUpYCBhNAzuvGevTXiU5saF66TFpXhdU0jO/c1rGwyWs27HHOoPTPlrB8VXFnQdhMw4291/9VEzjj7Vm68Qdwq+msq4e0C4NaJHw2UeEkZNOmOz5DvNI4IHZtKdUNZx2aiPXoSkC887GlZU3WH/ABp3aW9r8BgqzgWQsUxZoK8OukbuY4X9CDFj129U+LNCAUV66Pv5+d6WBWkNe7efnAYaUyW+QU1MAXnfPvdCXedwpUZIULlIou/U8UMLSJsdwQA+XO/k1gmNnBPgGOPBiOFqQF5ycrGWXwazMxpwtA9xutBmRCLhpMe04xL8virmuLivqhHUBzcDZkkxYQgSNA1H3UyxUk0/tMSO1yoqvn76yXh6UiKItmQ642RQ+cUHDD7iBSzVQW1C2PRIBUnBIQ4HEJFIm3DXhTW1Tr995ACGZ031m4SxprzL9FZ+4/KCAmt1syCFoQe0whki61PdE8/biGcWwjzSWlQLO4idO2mPVGFdGdNROi9aFDODZGg4bbxcLUjL++fwcUcoKHjec3i1+7L91eFOj/mMdleoQ+9X8AWsaJ/V697QoTku/+jajYt3C9JxCQYenP9C/dAXoHBq1z3LD7z/D0cHR05LCfQiTaPcU2GGzPf3CrmjNICR3aM68IzpE69YAa75Ed7lUELQznls4xthrydh74z5MZwoyrNr/0JtaCOGEXl/S8aFPa28KIMbo3Uz7d1VUIrId6A56HpeQ
 0D8QStd2
 iDR94XIxdHCKxw+QLsA/X3X4qyDLFJB5ZJ3xXpLEOoQHHmZg30sMoVy9NRcAMfj3NStCtTk5Khinv2SDCcSHLiGpOdoTtBD17xOj2YKyYh/NJpyLFod6DzM3+fyvMNAhiyUHxF9Ggku8J9QTK7h+tLq82Vte3kpqlriPFCb4TCOk1/xd8RS3vyU+B+Sb8zokCiS7C6oR+IErZX1INlAlzG9L7LLLlRn2p/FpeX9wkOXV3ZUfn1lYMbXuaKplI9yHbptMQZstnlF+XA08L6efFIAy2hGW2uceYHG+pW7uxhiWEgdSC/I63TcE+ZKDHc+1OLaes5jX7a/hVyYFn0EJF9PdUI2W3zlwQOQ04KLWo8/5EHEb44RhUECRyltQriDKILRJXdSk0S8fmBycoF8tLf9wWjiBLDcYioXCzdRvib5lbTIpVMKhO3l95oTKq4vGhEfnKwuY7hGVEcSUcX8/dCVkBWeL0v9bdNDkosHmnIaEYUvNcmJjbpa+aDZGxWsz0OfaruJUoV3BknK4sBAI3ZWWWbfKqy0mLNpD8h709VDSWShTrZk9YDZnWAVYJ0NRAHWyHFt89w5HZfUnABFduuU1gqGS3o8DbWndDKAkPcOiwubc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCgoKCgoKCgoKCgoKCgpBdCAyMDI2LTA4LTA2IDE0OjMyOjQxLCAiTG9yZW56byBTdG9ha2Vz
IChBUk0pIiA8bGpzQGtlcm5lbC5vcmc+IHdyb3RlOgo+U2lnaC4gTkFLLgo+Cj5UaGlzIHdpbGwg
dHJpZ2dlciBpbW1lZGlhdGVseS4KPgo+WW91J3JlIHNlbmRpbmcgdGhpcyBzZXBhcmF0ZSBmcm9t
IHRoZSBmaXggdGhhdCBtYWtlcyB0aGlzIG1ha2UgYW55IHNlbnNlLAo+YW5kIEkgbGl0ZXJhbGx5
IHRvbGQgeW91IHRvIHNlbmQgaXQgYXMgYSBzaW5nbGUgcGF0Y2guCj4KPlBsZWFzZSBkbyB3aGF0
IG1haW50YWluZXJzIHRlbGwgeW91IHRvIGRvLgo+Cj5JJ20gcHJldHR5IGNvbnZpbmNlZCB5b3Un
cmUganVzdCBkb2luZyB1bmFja25vd2xlZGdlZCBBSSBzbG9wcGluZyBoZXJlCj5iZWNhdXNlIHlv
dSBkb24ndCBzZWVtIHRvIGhhdmUgYW55IHVuZGVyc3RhbmRpbmcgb2YgdGhlIGJhc2ljcy4KPgo+
QWdhaW4gaW5jbGluZWQgdG8ganVzdCBkbyB0aGUgcGF0Y2ggbXlzZWxmIG9uIHRoYXQgYmFzaXMu
Li4hCgo+CgoKCkhpIExvcmVuem8sClRoYW5rIHlvdSBmb3IgeW91ciBmZWVkYmFjaywgYW5kIEkg
YXBvbG9naXplIGZvciB0aGF0LgpZb3UgYXJlIHJpZ2h0IKGqIEkgbWF5IGhhdmUgbWlzdW5kZXJz
dG9vZCB3aGF0IHlvdSBtZWFudCBieSAic2VwYXJhdGUgcGF0Y2guIiBJIHRob3VnaHQgeW91IHdh
bnRlZCBpdCBzZW50IGFzIGFuIGluZGVwZW5kZW50IHBhdGNoLCBidXQgeW91IGNsZWFybHkgbWVh
bnQgYXMgcGFydCBvZiB0aGUgc2FtZSBzZXJpZXMsIHBsYWNlZCBhZnRlciB0aGUgZml4IHBhdGNo
IHRoYXQgbWFrZXMgdGhlIHdhcm5pbmcgbWVhbmluZ2Z1bC4KSSdsbCByZXNlbmQgdGhlIGZ1bGwg
c2VyaWVzIGFzIGEgc2luZ2xlIHBhdGNoc2V0ICh2NSAxLzIgKyAyLzIpOgoKUGF0Y2ggMTogbW0v
bWVtb3J5LWZhaWx1cmU6IGZpeCBmb2xpbyByZWZjb3VudCBsZWFrIGFuZCBsb2NraW5nIGluCnNv
ZnQvaGFyZCBvZmZsaW5lClBhdGNoIDI6IG1tL2h1Z2VfbWVtb3J5OiBhZGQgVk1fV0FSTl9PTl9P
TkNFX0ZPTElPKCkgaW4KbWluX29yZGVyX2Zvcl9zcGxpdCgpCgpUaGUgc2Vjb25kIHBhdGNoIGRl
cGVuZHMgb24gdGhlIGZpcnN0LCBzbyB0aGV5IG11c3QgZ28gdG9nZXRoZXIgYXMKeW91IG9yaWdp
bmFsbHkgcmVxdWVzdGVkLgpJJ2xsIHNlbmQgdGhpcyBvdXQgYnkgdG9tb3Jyb3cgYXMgeW91IGFz
a2VkLiBNeSBhcG9sb2dpZXMgZm9yIHRoZQpub2lzZSBhbmQgdGhlIHdhc3RlZCByZXZpZXcgdGlt
ZS4KClRoYW5rcywKWW91aG9uZwoKPk9uIFRodSwgQXVnIDA2LCAyMDI2IGF0IDExOjIxOjE2QU0g
KzA4MDAsIGRheW91NTk0MUAxNjMuY29tIHdyb3RlOgo+PiBGcm9tOiBMaSBZb3Vob25nIDxsaXlv
dWhvbmdAa3lsaW5vcy5jbj4KPj4KPj4gbWluX29yZGVyX2Zvcl9zcGxpdCgpIGV4cGVjdHMgdG8g
YmUgY2FsbGVkIHdpdGggdGhlIGZvbGlvIGxvY2tlZCwKPj4gYnV0IGRvZXMgbm90IGVuZm9yY2Ug
dGhpcyBpdHNlbGYuIEFkZCBhIFZNX1dBUk5fT05fT05DRV9GT0xJTygpCj4+IGNoZWNrIHRvIHZh
bGlkYXRlIHRoaXMgYXNzdW1wdGlvbiBhbmQgZG9jdW1lbnQgdGhlIGxvY2tpbmcgcmVxdWlyZW1l
bnQuCj4+Cj4+IFN1Z2dlc3RlZC1ieTogTG9yZW56byBTdG9ha2VzIDxsb3JlbnpvLnN0b2FrZXNA
b3JhY2xlLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogTGkgWW91aG9uZyA8bGl5b3Vob25nQGt5bGlu
b3MuY24+Cj4+IC0tLQo+PiAgbW0vaHVnZV9tZW1vcnkuYyB8IDIgKysKPj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL21tL2h1Z2VfbWVtb3J5LmMg
Yi9tbS9odWdlX21lbW9yeS5jCj4+IGluZGV4IDU4Y2FiZTZhZjMzZC4uZTNmMTZkYWRjMWQ0IDEw
MDY0NAo+PiAtLS0gYS9tbS9odWdlX21lbW9yeS5jCj4+ICsrKyBiL21tL2h1Z2VfbWVtb3J5LmMK
Pj4gQEAgLTQzMDAsNiArNDMwMCw4IEBAIGludCBmb2xpb19zcGxpdChzdHJ1Y3QgZm9saW8gKmZv
bGlvLCB1bnNpZ25lZCBpbnQgbmV3X29yZGVyLAo+PiAgICovCj4+ICB1bnNpZ25lZCBpbnQgbWlu
X29yZGVyX2Zvcl9zcGxpdChzdHJ1Y3QgZm9saW8gKmZvbGlvKQo+PiAgewo+PiArCVZNX1dBUk5f
T05fT05DRV9GT0xJTyghZm9saW9fdGVzdF9sb2NrZWQoZm9saW8pLCBmb2xpbyk7Cj4+ICsKPj4g
IAlpZiAoZm9saW9fdGVzdF9hbm9uKGZvbGlvKSkKPj4gIAkJcmV0dXJuIDA7Cj4+Cj4+IC0tCj4+
IDIuMjUuMQo+Pgo+Cj4tLQo+Q2hlZXJzLCBMb3JlbnpvCg==

