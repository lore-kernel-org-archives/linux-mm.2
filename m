Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41DC6C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143D26B007B; Mon,  3 Aug 2026 23:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F69B6B0088; Mon,  3 Aug 2026 23:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A8C6B008A; Mon,  3 Aug 2026 23:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D117E6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:53:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C4581C143F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:53:36 +0000 (UTC)
X-FDA: 85062217632.16.8006898
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id B747816000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:53:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e 0rtqeK";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tu/xdySjiy531LIhSoHRPNEwrgyiU9s5N1/53nbljNw=;
	b=dDyF4Q1ULj31PQrGcc6iY+gDqIVdC3zNGj76V1kHKnQrzvOGtPF5DxDzKki3useesn08xV
	uW/VhjwUYpXt+0P9M7T9x0K2PMivQHY4iRB07MW5U5wLiqOQI7fnDGHTh+zl2qujxeGAcI
	O0WNSy9F6blX+unPvNKvXHg2dEaKR60=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e 0rtqeK";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815614;
	b=LQ4sk4zwdD3MuvO4Q7vNgva6CjJ0TX+bdIZAbegkDc3C2mmsdBTp/ZoXI2J/eastFGiVOX
	K0dADXcxHnp0QFoB3BmeTWM+x/22zCXEH8XH/YsVEkeE9hSX/zox8flmDtmWYKQKtcxHOS
	SXi7i/Q5Ild/X4LibELEAPJOxz2kGZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=tu/xdySjiy531LIhSoHRPNEwrgyiU9s5N1/53nbljNw=; b=e
	0rtqeKWBrVUDre3KRJoldgylbjzcs8a2OM6gswxPmq14PMJgaxWgKZ458NgOpvYy
	sn0csSgzIhfEBxrBproTel6QjT8+/4p67MPGq2GXaGrgNlyuE2VJDGrUTYWX9Dmj
	v4IYfEFK+FAN/bo8EIHbpvsh7I4TKExOilMchyjFWo=
Received: from dayou5941$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-132 (Coremail) ; Tue, 4 Aug 2026 11:53:17 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date: Tue, 4 Aug 2026 11:53:17 +0800 (CST)
From: =?UTF-8?B?5p2O5L2R6bi/ICA=?= <dayou5941@163.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>
Subject: Re:Re: [PATCH] mm/memory-failure: fix refcount leak on soft-offline
 LBS folio
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2TB/Sauk0i4SOcZOkckk4Wjug8Wcexufwj34NTc8IFpA//1jklf0ZuPl3JwOywESCcujiQaTNDz9R+U7R9rb2wNaTguaYLFw5WzfHkSA==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <340e6253.3702.19fcae78125.Coremail.dayou5941@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hCgvCgD3_+kuYnFqrvYqAA--.7746W
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3g6aSWpxYi6CRQAA3T
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B747816000C
X-Stat-Signature: fbd5ooy67qbcst8zesfsh4z85ibfponn
X-Rspam-User: 
X-HE-Tag: 1785815610-640854
X-HE-Meta: U2FsdGVkX1+KWJD/hz9jymPc++fzM7ar3nEt10ue2VjL9RGjZOnhm9pw9QmjTtcC8vR39QOq7/tR7ZM50Ul9FI7Cmbwtb2WMw4lDGuLMUopl3I5O+VwvcryNv9gMiz0RSXr5kUcY4a9ZVvRLQwY9xrEbfd3HYHH1v0bmQ6y+pb16tNTqHSUcWkOcad4Fz48m5S2v/IkToUt5hes8pCr0Nx6kYYopxo1ocrO1qDaeWtvXhdoimPSLgbbsfWoh5lmvqeX1FkaINxJgD+LZaxNKVi8gm2dZLw8H0sDN2U+9D+pmgHQzcg7EHKCrpE5M+7M1s35BIkOyKXkHy0ilZcdImnb6o6qCXymuXTtwbGb366VT77Plgmkt9cjMlfdmaXZ8bWg4xr8cf5P38/SdOtoU09zqwJ0Xq8FPfeG/+oM53N4NU1V8tRi8kf4ofBqGEXD9LwauDMIzvg8GMcGTAqiVsoljjUZVJeDakVX5euSn1WoDQEdUAeEQeamJ7dzUfZCBC4N+gkdvWh2bxFxxoXfHtxsvrcPt4yPvjMKkbRA6mCy7MY/PVNlRTAgZ05/rWkH4sMgqw0lldN8ZypCc/lEIJe1MeUg5czeURLtVhSLmW+F6ws6nmgPcZRkUE7t/N4Dha/i2rjoWTRM99k9w2e02jhAiPUt9YlbUqmJkqdR1Y5xVVQDD9h3RfS2TLvU9XRvB8k5WzR1z0OH1YODtoKp82gO/9/d0TukWIKv1GuizCMAYdz3G8anFLMJtW+KZkfoq+eb1ibFeBql3T0VdLc+oQGLDdh17IEksN7lg1ghLC31ZDhUgOJK7gKdrfnzGJLpDFVlZ9OJeqvn4MV7J94L5qgGjg96fdfErl4A9wLFiNTPIabwTzxMOG8ISefBCoOARFq1BlNg4dCUAdpFXAp94hcEbXvCarC5OYA2vRdWlhP4yACPH+lM8v5Me+VokDauuWz6488pzgLlstEKaY7c
 QhGTXWv1
 2EIHTZ3lfkWbY9K3bX9rHwMZkX50VRJK7dHRT/12tAjho5sHUTUwzQTyqqCuN+Hq99YZ9Gy43SJZzn/M/8j1GWKPJDgoufbARK9NPwGJWLGvmJLC/z1yUaJN92xFb+RDhAS5thnaxQiQNxGCNHybBSh9O/zI3u7X4XoOnCdWd6lYzf5AfrIZ4qDA/PxxBawU95O5sCO5wu6u35FHLXjtcVKR00KO++rpGmagOvNLBDVwqHgcYy9DW8ebwKzCa30qcOpqdZk9gtF7DeTaE8dvQKPFUjzIX/uqlyWihnmtOlKkdNn/s/UwLfrQr3mDr/+s5z2RWv3EGjXh+ELnittEmQukJkDoBKJNuMyvgMnjvK1WmD4793ViUMDmTdDRxzDBLol5on1oA5J4WlK5+tHOyaMsK8SQy56JJhAbmlQem09wfNknOlMYL38z/B6MUS4mjlcWky0ZJO1q/5iNzqZAeKCDp2BKNTUEq0ts3Ibx41Wvt8DTEsvsJqwSyEWo/6aVMgR2rpgawdbrcixxbuy6esrn9z7YNmG8HhSqMz8zZZD1XJrM47LOvXbgTigWP/5AHAnwjLRMqqe9tUA0FfQhaI2MyBjX3NoZKZq4nw++IdSSSlOP/RF50WC0WbY4PPYGp685F9r0mGic4dJKShiwAtchFFiiHH6XtuJqNXJ97pQ646PKxtKJrmMfN8Yb9zJtqBr2s77O+kbV24Z88EtkupBVYh3bFYFpUWRYCaJVMBcPN2FWhjO8aOuz8M+fEz7VybWZHIWHR13vL5vfhjQ2w8MLaE7GpV6h3kLY2cUQbrm99tSJs1RepZHSktkzVDzfij9Iq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCgoKCgoKCkhpIEFuZHJldyzCoApUaGFua3MgZm9yIHlvdXIgcmV2aWV3LgoKCgoKCgpBdCAy
MDI2LTA4LTA0IDA2OjA2OjQ2LCAiQW5kcmV3IE1vcnRvbiIgPGFrcG1AbGludXgtZm91bmRhdGlv
bi5vcmc+IHdyb3RlOgo+T24gTW9uLCAgMyBBdWcgMjAyNiAxNDowMDowMSArMDgwMCBkYXlvdTU5
NDFAMTYzLmNvbSB3cm90ZToKPgo+PiBGcm9tOiBsaXlvdWhvbmcgPGxpeW91aG9uZ0BreWxpbm9z
LmNuPgo+PiAKPj4gc29mdF9vZmZsaW5lX2luX3VzZV9wYWdlKCkgcnVucyB3aXRoIGEgZm9saW8g
cmVmZXJlbmNlIHRha2VuIGJ5Cj4+IGdldF9od3BvaXNvbl9wYWdlKCkgKG9yIGJ5IHRoZSBjYWxs
ZXIgd2hlbiBNRl9DT1VOVF9JTkNSRUFTRUQgaXMgc2V0LAo+PiBlLmcuIG1hZHZpc2UoTUFEVl9T
T0ZUX09GRkxJTkUpKS4KPj4gCj4+IG1hZGUgc29mdC1vZmZsaW5lIHNraXAgc3BsaXR0aW5nIHdo
ZW4gbWluX29yZGVyX2Zvcl9zcGxpdCgpCj4KPlNvbWV0aGluZyB3ZW50IHdyb25nIHdpdGggdGhp
cyBwYXJhZ3JhcGg/Cj4KPj4gaXMgbm9uLXplcm8sIHNvIGxhcmdlLWJsb2NrLXNpemUgZm9saW9z
IHN0YXkgaW50YWN0LiAgVGhhdCBlYXJseQo+PiByZXR1cm4gLUVCVVNZIHBhdGggbmV2ZXIgZHJv
cHMgdGhlIHJlZmVyZW5jZS4KPgo+U28gdGhlIGVmZmVjdCBpcyB0byBsZWFrIGEgZm9saW8gcmVm
IGlmIG1pbl9vcmRlcl9mb3Jfc3BsaXQoKSByZXR1cm5zCj4wLiAgSGFzIHRoaXMgYmVlbiBrbm93
biB0byBoYXBwZW4gaW4gdGhlIHJlYWwgd29ybGQ/Cgo+CgoKVGhlIGxlYWsgaXMgaWRlbnRpZmll
ZCB2aWEgY29kZSBpbnNwZWN0aW9uLiBXZSBoYXZlbid0IHJlcHJvZHVjZWQgaXQKdW5kZXIgcmVh
bCB3b3JrbG9hZHMgeWV0LCBidXQgdGhlIGNvZGUgcGF0aCBjbGVhcmx5IG1pc3NlcyBmb2xpb19w
dXQoKQpvbiB0aGlzIGVhcmx5IHJldHVybiBwYXRoIGFuZCBjcmVhdGVzIGEgcmVmZXJlbmNlIGxl
YWsgcmlzay4KCgo+SXQgd291bGQgYmUgZ29vZCB0byB1cGRhdGUgc29mdF9vZmZsaW5lX2luX3Vz
ZV9wYWdlKCkncyBpbnRyb2R1Y3RvcnkKPmNvbW1lbnQgdG8gZGVzY3JpYmUgaXRzIGZvbGlvIHJl
ZmNvdW50IGhhbmRsaW5nLgoKPgoKCldpbGwgYWRkIGRldGFpbGVkIHJlZmNvdW50IGhhbmRsaW5n
IGNvbW1lbnRzIGluIHYyLgo+Cj5UaGFua3MsIGxndG0uCj4KPkFJIHJldmlldyBtaWdodCBoYXZl
IGZvdW5kIGEgY291cGxlIG9mIHByZS1leGlzdGluZyBpc3N1ZXMgaW4gdGhlCj5zdXJyb3VuZGlu
ZyBjb2RlLiAgRnJvbSBhIHF1aWNrIHJlYWQsIGl0IGRvZXNuJ3Qgc2VlbSBhcHByb3ByaWF0ZSB0
bwo+YWRkcmVzcyBlaXRoZXIgd2l0aGluIHRoZSBjb250ZXh0IG9mIHRoaXMgY2hhbmdlLgo+Cgo+
CWh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDgwMzA2MDAwMS44MDA2MzgtMS1k
YXlvdTU5NDFAMTYzLmNvbQoKCkkgYWdyZWUuIFRob3NlIHNlcGFyYXRlIHByZS1leGlzdGluZyBw
cm9ibGVtcyBhcmUgbm90IHRvdWNoZWQgaGVyZS4KSSB3aWxsIHNlbmQgYW4gaW5kZXBlbmRlbnQg
cGF0Y2ggbGF0ZXIgdG8gZml4IHRoZSBUT0NUT1UgcmFjZSBvZiBmb2xpby0+bWFwcGluZyBpbiBt
aW5fb3JkZXJfZm9yX3NwbGl0KCkuCgpJIHdpbGwgc2VuZCBvdXQgdjIgc29vbi4KClRoYW5rcywK
bGl5b3Vob25nIAo=

