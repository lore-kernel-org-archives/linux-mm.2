Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B3AC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737AD6B007B; Wed,  5 Aug 2026 03:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8FB6B0088; Wed,  5 Aug 2026 03:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFE06B008A; Wed,  5 Aug 2026 03:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7476B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:20:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C38A51A03D6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:20:51 +0000 (UTC)
X-FDA: 85066368702.01.101CF04
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf23.hostedemail.com (Postfix) with ESMTP id B93DA140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:20:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="U lfgU3d";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf23.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785914449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZak2V77MNsOlgmf2qFgK/EAwDgsxv7x1vBuhQoAiXo=;
	b=bVERJ43Xf9svwdEjMdkgjaShG3244ESIUn1tQVI+CupYDIaB0O1MkPS6RAfbv7+PIYix/n
	BviTCCEOj58N4t/jy9+r25L+587g/dxYVY4z2tQm2BWjejoJf18EjpzPIIIrmXM/uBW4uj
	FsTym0yv1TtAxll5rdvV02vIPuhVNHE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="U lfgU3d";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf23.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785914449;
	b=PCfTuiG/tq+19yu+4t2Y2psEiHEX8piuk1nD4QFxQ6BwkDIoWWjsI9kkjWonaFVrC1cqur
	Chp52UED0G8/0lfGLQONZCmyO9kah3jPdY60hxRS3q4vQhIow6fHdHHjpNAR8Uzzp+OoRV
	msmMramcAlZLgHhr6y8GHqZz1q6sEv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=bZak2V77MNsOlgmf2qFgK/EAwDgsxv7x1vBuhQoAiXo=; b=U
	lfgU3dOf2GrrAq4w2GjIGcpguSYZqXsTdm97jY7a8U48YF6lTyESJwdcBSvaTpuw
	AlRu+v1qGrnOOf7/XQD9RwAdXA7MVQdQOrnFk6m74jC0yC90y5b/S5SYShIx4TMF
	R4w6G5iJ0WS1QwWAJZ2Gv1e5tOEJKd8OWYAXbZ1OpE=
Received: from dayou5941$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-142 (Coremail) ; Wed, 5 Aug 2026 15:20:27 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date: Wed, 5 Aug 2026 15:20:27 +0800 (CST)
From: =?GBK?B?wO7T07roIA==?= <dayou5941@163.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
	linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>
Subject: Re:Re: [PATCH] mm/huge_memory: avoid TOCTOU race in
 min_order_for_split()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <9ac32dd4-498e-46b2-9cb4-3fa853840cfa@kernel.org>
References: <20260804035828.2684059-1-dayou5941@163.com>
 <9ac32dd4-498e-46b2-9cb4-3fa853840cfa@kernel.org>
X-NTES-SC: AL_Qu2TB/Wau0wp4SOQZOkckk4Wjug8Wcexufwj34NTc+EGpS7H/gAMdmJOL1/P4P2JEh2smwCuYilS9PtAVIxU9Pxfj9dLy3ZE4PLO8QbM3w==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <4198eece.54ca.19fd0cb87fe.Coremail.dayou5941@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jigvCgD3V8E75HJqnBAsAA--.4342W
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3ht+LWpy5Du4GwAA3y
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B93DA140004
X-Stat-Signature: pptw9hbbaw3x799y8j5m84m1p71ttqqe
X-Rspam-User: 
X-HE-Tag: 1785914448-970935
X-HE-Meta: U2FsdGVkX19VTVqMpmR24t0xychZ07rX/1GvxJzQmAJn6NS1+k6K3UjeGTC1mdESjti8ISye+7AI4QMjwr86MDI3i9HYf6Ytc0/GyZpcP55hq1KcAcFnMGpxAZmVr1a3bpZSzJJo4tEyPPcnW+Nz9Y09cjSZposMXZOT57g9LjSocwvUwFmKrfCUajfaIMk2iHN3IY5TcsjDUyyrEHQqGw/wY+NVFxG0aAfZ4gKkNO9J3BLNWneBOQEKOlgnZYFZpYsaHjJk8dsTiZ5NWJ5bX9m1X0fg398v1JvY50G3F4qDTyaszqCiqAhMGjDfLYAZKmgQN9FOaDBCFV9KaXkYqDFIyHKGaWpqYtS/IN4ltxSiKwR4mabPaFcQDvpsKPYDo3kD38ug86lj5T+r4uttqWTT4bKnUfGWLPp/m7x3kCLFY0kCHGS0kPoULXcehO4K52DJcjqTYH53pMIjJzRa4KV4QlK4sN8T4qaHqvbPzwEhpCYhQ2aQtmENlzLdt4PzxxDnRhj+5/Iu3S5gtQ6DLRpH+YpmubLWrHOknvoWaRxW1Gkjps91r1puT6GJYelgMB4jX3Ssxog/NGAqOMnpE9EOUNP/uLNDscpZNI9iACMlb9FzDbnRnFmg2G1qXIIVS6x0ALs65hIK1tP/DuKmFKyzRcCXjFr+OzguoywLZs+Wp4N3saQSKBqL/9Li8hK5QDLx3hP1BXAXWhRoDBCy8DfaSb3NkB6PqY+a/uf1GUzHeiBehn+SuHLWvS1l5MbhiNIhPGFPixbXbh+zUuPEV9p66n7yp2lyf/7Fzk4qU/V69fGpXMRKmvHAZcset4NLPGCc5qPbXAcBAV+tL7tHnQKd5XKU2tFUxwRjBOtDsL/Ve17EvqgSe48nbnf69ZoPOtD20LXikiRMkP5Xg5Gw9iTNOSDKNqBZvhrtMw0439cxzL5AY4GFtx2MIxw/RNntoEHKX0N0jToxo+sJ9Bb
 Rg59F/qR
 GM9BN0ETUes9XFOhNiYIwS989LDtF1gVUWeTJ4pZhptdAcQYQdyieKdq/Qf/mWlf6s49JE/YSxcH7BqXkUkwJHrdsfcykO/PO0Ckr/B2eWMdnEY0rXVNCCQtI5stsSxUIiUXcxbJuhOdiaO5Pv9hxskQdH2igE6PN5ZAYmahhydnKoexXxu/5/kF2xpsN0KJbeZVU8hBhsLCo/Sf0t5gt4kgkwBdaMIILlJNcs2p3O1/ScAXoYJ8qmJnkmG7C3yD1KCh7dbzgd4lVO6uCVRShEzNnMF8sWbdtoaUzvPuRXZcfE/Dgv6nucwpzQ74uvoMLAbwKekN0uVUBD+lec04Z1G8cbPEOPtdaRkkPRPY5Xjpfv2DiDBqQRUs6WCrt5yAR5jYAcF+4dJSml7AYq1KzbXEsnOIiwrvy5UTcdH2zqoSn0XdOumKJGgLV7YhChujYKbqplbUHoWS/JLi1gdC3n9r+2UnWqiMtTZRxd95lYsn1OBrAmkaDLR5pi6FeEo5ju0vIsWDOLNZblUpYpZeolG+ZROfzg7fKuGBdmMGmgpJbM8A/pDqAqij44RYFagdHLuDNG+lW0XBhYHL/mcF/aVeTZ4DokqT1z6AhArH8PGSPtgfNcKSGPkkfog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCgoKCgoKCgoKCgoKCgpBdCAyMDI2LTA4LTA0IDE4OjA0OjE1LCAiRGF2aWQgSGlsZGVuYnJh
bmQgKEFybSkiIDxkYXZpZEBrZXJuZWwub3JnPiB3cm90ZToKPk9uIDgvNC8yNiAwNTo1OCwgZGF5
b3U1OTQxQDE2My5jb20gd3JvdGU6Cj4+IEZyb206IGxpeW91aG9uZyA8bGl5b3Vob25nQGt5bGlu
b3MuY24+Cj4+IAo+PiBtaW5fb3JkZXJfZm9yX3NwbGl0KCkgcmVhZHMgZm9saW8tPm1hcHBpbmcg
dHdpY2Ugd2l0aG91dCBhbnkKPj4gc3luY2hyb25pemF0aW9uLiBDb25jdXJyZW50IHRydW5jYXRl
IG9yIGludmFsaWRhdGUgY2FuIGNsZWFyCj4+IGZvbGlvLT5tYXBwaW5nIGJldHdlZW4gdGhlIGNo
ZWNrIGFuZCBzdWJzZXF1ZW50IGZ1bmN0aW9uIGNhbGwuCj4+IEV2ZW4gd2l0aCBhIGhlbGQgZm9s
aW8gcmVmZXJlbmNlIHByZXZlbnRpbmcgdGhlIGZvbGlvIGZyb20KPj4gYmVpbmcgZnJlZWQsIGZv
bGlvLT5tYXBwaW5nIGNhbiBzdGlsbCBiZSBvdmVyd3JpdHRlbiB0byBOVUxMLiBUaGlzCj4+IFRP
Q1RPVSByYWNlIGFsbG93cyBwYXNzaW5nIGEgTlVMTCBtYXBwaW5nIGludG8gbWFwcGluZ19taW5f
Zm9saW9fb3JkZXIoKSwKPj4gd2hpY2ggbGVhZHMgdG8gYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVu
Y2UuCj4+IAo+PiBDYWNoZSBmb2xpby0+bWFwcGluZyB0byBhIGxvY2FsIHZhcmlhYmxlIHVzaW5n
IFJFQURfT05DRSgpIHRvIGd1YXJhbnRlZSBhCj4+IHNpbmdsZSBtZW1vcnkgbG9hZCBhbmQgcmVt
b3ZlIHRoZSByYWNlIHdpbmRvdy4KPgo+SW4gX19mb2xpb19zcGxpdCgpIHdlIGhvbGQgdGhlIGZv
bGlvIGxvY2ssIHNvIGNvbmN1cnJlbnQgdHJ1bmNhdGlvbiBpcyBpbXBvc3NpYmxlLgo+Cj5TbyBp
cyB0aGlzIGFib3V0IG1lbW9yeS1mYWlsdXJlLmMgPwo+Cj5XZSBzaG91bGQgcmF0aGVyIGZpeCB0
aGF0IGNvZGUgdG8gbm90IGNhbGwgbWluX29yZGVyX2Zvcl9zcGxpdCgpIHdpdGhvdXQgdGhlIGZv
bGlvIGxvY2sKCj4od2UgdGFrZSBpdCBlaXRoZXIgd2F5IGluIHRyeV90b19zcGxpdF90aHBfcGFn
ZSksIG5vPwoKClllcywgeW91J3JlIHJpZ2h0LiBUaGUgcmVhbCBpc3N1ZSBpcyBpbiBtZW1vcnkt
ZmFpbHVyZS5jIHdoZXJlIHRoZSBjYWxsZXJzCmRvIG5vdCBob2xkIHRoZSBmb2xpbyBsb2NrIHdo
ZW4gY2FsbGluZyBtaW5fb3JkZXJfZm9yX3NwbGl0KCkuIEknbGwgc2VuZCBhCnYyIHRoYXQgYWRk
cyB0aGUgZm9saW8gbG9jayBhdCB0aGUgY2FsbCBzaXRlcyBhbmQgYWxzbyBhZGRzIGEKVk1fV0FS
Tl9PTl9PTkNFX0ZPTElPKCkgaW4gbWluX29yZGVyX2Zvcl9zcGxpdCgpIHRvIGNhdGNoIGFueSBm
dXR1cmUKY2FsbGVycyB0aGF0IGRvbid0IGhvbGQgdGhlIGxvY2suIFRoYW5rcyBmb3IgdGhlIHJl
dmlldy4KCkNoZWVycywKbGl5b3Vob25nCgoK

