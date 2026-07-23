Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE52C4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE9D6B009F; Wed, 22 Jul 2026 22:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FCE6B00A0; Wed, 22 Jul 2026 22:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B64B6B00A2; Wed, 22 Jul 2026 22:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2D596B009F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:29:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 743D5A0BE5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:45 +0000 (UTC)
X-FDA: 85018460730.13.A4BF142
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3ECA5160006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="E L/3AOt";
	spf=pass (imf08.hostedemail.com: domain of 19888972804@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=19888972804@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784773783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J44v/p2JPcRHwmOKeJbeUVW9BYIOBsgxt3mCkTqNxog=;
	b=cfVt6k2Q8sYroYZVk6eT7o5wVGv9xnkwCu5r90vrXkHIPB2uzinUGXh52lrNU+bo9kL5Kk
	35VVY+w2LWhDDiWeknoXqq51AQQd4TE1rsAyhW54Q5mZ7jCvFZQsQVvrd4FNckI9/MTinz
	qt1VBXmW0ULkBcxjrZGk5zlvVVTvbkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784773783;
	b=atjIwRXsf01nor4yYeb6VdoXExh6lwsxXDIRVKEipRKKb71KDQfRPqoeUsGEnaQIKKo63y
	EC3Y/GUqnTDW6Wx7QBiPX0qRcUYS0GY+6De0tSiOmvbg5aw1VIALaEfVHBSV1HtqZd1zLQ
	Isi7ovnAePzyyB0ai20g0mG+jqFwFbY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="E L/3AOt";
	spf=pass (imf08.hostedemail.com: domain of 19888972804@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=19888972804@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=J44v/p2JPcRHwmOKeJbeUVW9BYIOBsgxt3mCkTqNxog=; b=E
	L/3AOtBbYyj66p1kVZK6v4PgwqUza23bu9PuLfUzuaII4iDIzPYLziQU9ajrQP6t
	2T8w4r598F0uFdVEShLL0FtzS70YV46aDrqwVjGiMpfRE1LYsvpUmCRRwAWsxGIb
	gmGiurVkTLe0fxD7hYc1qMhUp87dPNxvdA15ZKNBM8=
Received: from 19888972804$163.com ( [117.133.52.106] ) by
 ajax-webmail-wmsvr-40-113 (Coremail) ; Thu, 23 Jul 2026 10:29:05 +0800
 (CST)
X-Originating-IP: [117.133.52.106]
Date: Thu, 23 Jul 2026 10:29:05 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "SJ Park" <sj@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] mm/page_idle: call folio_test_lru() after
 folio_get()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260723004250.96509-1-sj@kernel.org>
References: <20260723004250.96509-1-sj@kernel.org>
X-NTES-SC: AL_Qu2TBvucvE8v4yCcYekdm0kTgus9XsezvfQk3YBXc/sEvyLv4goGf3l+DEH37MKTAjmtjgabcztt7OFzb699xZSbR2Azdeb9Vt4NR/ZWRQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <1476763.2025.19f8cce199c.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cSgvCgD330hxfGFqHmgjAA--.2211W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhEuaGphfHFgIAAA3f
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Queue-Id: 3ECA5160006
X-Stat-Signature: h81gf4x61orosexxeagb1h5bf7a1xncm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784773780-32767
X-HE-Meta: U2FsdGVkX18aEI3B2gL1MxuNJBDjVBOffEB1UuB8yAovQfdmC6L7tuO5U8DyddIZTOL4x59jO1gZlSIbmyLCVxCrbs0dHARNzMEV9yXwDnMDUAMHArNqFAjr64m3mbHJ0vkeRDObwcU6FW4j59Jg/LEeg2TBscDE9cQQW4ePmW83d4jbtcI7+XICZEPcsViimsKI9BEbVB1mvXybvasgxFzopnlkx8NLaKnO3iMPwyU6LoKOnZ0qoho/r57N/7lhKx+bqVfH99W5BhRKqRZZBJKahiVhv/YcXDnDiPS0fRIEYOK0V0GhfN7GPyOalLzESgOO2wGpSTsdBW6uQwzu7jDvb6ipWvZhdc5yAmHSSnMiikRfEJGZ0eyZg0XXzLJ0QeESY24MNlq6jB84rkjVA71Xbslc2Wq4cXLFGOMguV2gQ7qG4scKssFJzNstVKDiTacfnaZddzG2roPAqnu3qmxH3cA5sNpprpVb2LzH/hXgpwuNvfAPGgVuk+sPxboRZPHWOklj82lSOiKflJG/cTg68JzbSYCQov2r8p2KxsWhJ2V4447sUvXyyZJo8FXHK3uHVIQxtTX947+lYlJ7dffY5hKUvc2uH6Kn20CIr3ykgbZmWjME3sG7yo+Z50vgONU4eGOHhKG6YYtE+Jf2i9/mcmLCwCheHjDnPZkErVIdhtvP4+aXWztqe3Gwj5uCYrmo0KxdyOfOnvTnrWlWblLfm9rM+NB+7cUy6RqI8er7d2/R8qMZ6Y2p7HzNIvGAYPpxy333E5FdayS7RcGzxgSnrUq7xFBHXfJ07O+Q6th23CPBrDwH0GkgQgTjfxaD13NLjrLExhTp7PDMCCUODlTupR9tKh13rXBrZbdnAjYp2D9DPlDM5PgYYb6iM4Ryd+w6fzMSImRCUsQJCTutbxckhS/zxF2ZABPp6q88wE517ZD8i/amLGVF6G8TrgN3UKfGmN3vJX9luyxzWkP
 ifq2EEgD
 P0T3T6x7iemP0j4joF5nlRQ/72XzLiTAxdvKu8EOFNeGXLxRRhl6Qh8+JeNwCfWQmTwcT1+iWLybiPP8M6b+BjkpD5hl4wyU15647xqrRgTIhyalgDVgvOOw+81LvmIzinaXnCckwJMVGpj789wZTKkW+RXwzJPCL0vsEmqRyvIdH3Tu5vyj6UYEOfrIP0YzoaoOjzskFM2Anpnq0DGGSb5+JeBtsH0HiTOHKwlPi0W2vWSc0bs5/CwSG6BK7qEGYTf7BnutmX4d6vsEHuv78UwCyoCB8lnw0eCgRAfFCmsHY9hfLsUcJPI/ikkMuy4hB52/mmcn3SfMNeDhohlThxofU/NufrtbPyzzcc3wogXWoyWtBASuCndnwp3f0TEjmBr6035aiDeJoRsmLjVa5zXrU6ldE2mvUNrRdhMk6w9OfpaXTCqxCITGJMQo6vnG0tQZseNcfFz458UMxtcfFLC1pAXd9GMUKbXz/mGmK/AxFC/+tcZTkMJ2P76OQf1pqm4oktziZ0AMQ00skzEeZ8v6aGbZSwHDFSUKNS1PrfISXQj286xuAIBO8WEvVKMtC00HCow+Xsj1JLbQndIWOVofkKEXSmmGzCt7HLGoxANLp3wT4ldTChW3vMxEEZSURtoq1iptMGBCx1ThkJWtruN/3ACTT1B9k1Xq+qT2C8tfY3tjoix89zmwrfzydjVB8MKZbDFcdWIiyEAfX9HraRIG0Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgpIaSBTSiwKVGhhbmtzIGZvciB5b3VyIHJldmlldy4gSSBkaWQgdGFrZSBjb21taXQgZDZiOGIw
MmEyN2IzIGFzIGEgcmVmZXJlbmNlLgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy8yMDI2
MDUyNTE2MjI1Ni44MzE3LTEtc2pAa2VybmVsLm9yZwoKVGhhbmtzCkppYWxlCgoKCgoKCgoKCgpB
dCAyMDI2LTA3LTIzIDA4OjQyOjQ5LCAiU0ogUGFyayIgPHNqQGtlcm5lbC5vcmc+IHdyb3RlOgo+
T24gV2VkLCAyMiBKdWwgMjAyNiAxMzo1MDowNSArMDEwMCAiTG9yZW56byBTdG9ha2VzIChBUk0p
IiA8bGpzQGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4+IE5vb29vbyA6KSB0aGlzIGlzIG5vdCBob3cg
eW91IHNlbmQgcGF0Y2hlcy4KPj4gCj4+IEFsc28geW91IHNob3VsZCBfcmVwbHlfIHRvIHJldmll
dyBjb21tZW50cywgbm90IGp1c3Qgc2VuZCBhbm90aGVyIHBhdGNoIHdpdGggbm8KPj4gcmVwbHku
IENvbW1zIGlzIGtpbmcuCj4+IAo+PiBBbHNvIC0gZG9uJ3QgcmVzcGluIHNvIHF1aWNrLiBXYWl0
IGEgZGF5Lgo+PiAKPj4gVGhlbiBzZW5kIGEgdjIsIE5PVCBpbiByZXBseSB0byBhbnl0aGluZy4K
Pj4gCj4+IFJlYWxseSBiZXN0IHdheSBpcyB0byB1c2UgYjQsIGRvY3MgYXQKPj4gaHR0cHM6Ly9i
NC5kb2NzLmtlcm5lbC5vcmcvZW4vbGF0ZXN0L2NvbnRyaWJ1dG9yL3ByZXAuaHRtbCBhbmQgZXRj
Lgo+PiAKPj4gQnV0IHlvdSBjYW4gYWxzbyBkbyBzb21ldGhpbmcgbGlrZToKPj4gCj4+IGdpdCBm
b3JtYXQtcGF0Y2ggLXYyIEhFQUR+MQo+PiBzY3JpcHRzL2NoZWNrcGF0Y2gucGwgPHBhdGNoIGZp
bGVuYW1lPgo+PiBzY3JpcHRzL2dldF9tYWludGFpbmVyLnBsIDxwYXRjaCBmaWxlbmFtZT4KPj4g
Z2l0IHNlbmQtZW1haWwgLS10bz0iKGFuZHJldykiIC0tY2M9IjxsaXN0IGZyb20gZ2V0IG1haW50
YWluZXJzPiIgPHBhdGNoIGZpbGVuYW1lPgo+PiAKPj4gCj4+IE9uIFdlZCwgSnVsIDIyLCAyMDI2
IGF0IDA3OjIwOjIwUE0gKzA4MDAsIGppYWxlIHlhbyB3cm90ZToKPj4gPiBwYWdlX2lkbGVfZ2V0
X2ZvbGlvKCkgc3BlY3VsYXRpdmVseSBjYWxscyBmb2xpb190ZXN0X2xydSgpIGJlZm9yZQo+PiA+
IGZvbGlvX3RyeV9nZXQoKS4gVGhlIGZvbGlvIGNhbiBnZXQgZnJlZWQgYW5kIHJlYWxsb2NhdGVk
IHRvIGEgdGFpbCBwYWdlCj4+ID4gaW4gdGhlIG1lYW50aW1lLiBJbiB0aGF0IGNhc2UsIFZNX0JV
R19PTl9QR0ZMQUdTKCkgaW4KPj4gPiBjb25zdF9mb2xpb19mbGFncygpIGNhbiBiZSB0cmlnZ2Vy
ZWQuIFJlbW92ZSB0aGUgc3BlY3VsYXRpdmUgY2FsbC4KPj4gPgo+PiA+IFRoaXMgaXMgYSBzaWJs
aW5nLXBhdGggYnVnOiBkYW1vbl9nZXRfZm9saW8oKSB3YXMgY29waWVkIGZyb20gdGhpcwo+PiA+
IGZ1bmN0aW9uIHdpdGggdGhlIHNhbWUgZmxhd2VkIHBhdHRlcm4uIENvbW1pdCBkNmI4YjAyYTI3
YjMKPj4gPiAoIm1tL2RhbW9uL29wcy1jb21tb246IGNhbGwgZm9saW9fdGVzdF9scnUoKSBhZnRl
ciBmb2xpb19nZXQoKSIpIGZpeGVkCj4+ID4gZGFtb25fZ2V0X2ZvbGlvKCksIGJ1dCBwYWdlX2lk
bGVfZ2V0X2ZvbGlvKCkgd2FzIGxlZnQgdW5maXhlZC4KPgo+SSB3YXMgYWN0dWFsbHkgdGhpbmtp
bmcgSSBzaG91bGQgYWxzbyBkbyB0aGlzLCBidXQgSSB3YXMgYWdhaW4gZmFpbGVkIGF0Cj5tYW5h
Z2luZyBteSBtZW1vcnkuICBUaGFuayB5b3UgZm9yIGRvaW5nIHRoaXMsIEppYWxlIQo+Cj4+ID4g
S0NTQU4KPj4gPiAoc3RyaWN0IG1vZGUpIGNvbmZpcm1zIHRoZSBkYXRhIHJhY2Ugb24gdGhlIGZv
bGlvIGZsYWdzOgo+PiA+Cj4+ID4gICBCVUc6IEtDU0FOOiBkYXRhLXJhY2UgaW4gLi4uIC8gcGVy
Y3B1X2NvdW50ZXJfYWRkX2JhdGNoCj4+ID4gICAgIHBhZ2VfaWRsZV9nZXRfZm9saW8rMHg3YS8w
eDJkMAo+PiA+ICAgICBwYWdlX2lkbGVfYml0bWFwX3JlYWQrMHhjOS8weDIyMAo+PiA+Cj4+ID4g
U2lnbmVkLW9mZi1ieTogSmlhbGUgWWFvIDx5YW9qaWFsZTAyQDE2My5jb20+Cj4+ID4gUmV2aWV3
ZWQtYnk6IExvcmVuem8gU3RvYWtlcyAoQVJNKSA8bGpzQGtlcm5lbC5vcmc+Cj4KPj4gCj4+IHRo
aXMgc2hvdWxkIHJlYWxseSBiZSBiYWNrcG9ydGVkLCBzbyBnb29kIHRvIGZpbmQgdGhlIHJpZ2h0
IGNvbW1pdCB0byB1c2UgYXMgYSBGaXhlczogaGVyZS4KPj4gCj4+IEFsc28gdGhlbiBhZGQgQ2M6
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBzbyBpdCBnZXRzIHNlbmQgZm9yIGJhY2twb3J0aW5n
Lgo+PiAKPj4gQnV0IF9wbGVhc2VfIHdhaXQgYSBkYXkgYmVmb3JlIHNlbmRpbmcgdGhlIHYyIDop
Cj4+IAo+PiA+IC0tLQo+PiAKPj4gQWxzbyBpbiB0aGUgdjIgcHV0IGEgbGlzdCBvZiBjaGFuZ2Vz
IGhlcmUgKHdpbGwgbm90IGJlIGluY2x1ZGVkIGluIGNvbW1pdCBtc2cpCj4+IHdpdGggbGlua3Mg
dG8gcHJldmlvdXMgdmVyc2lvbnMgb24gbG9yZS4KPgo+QXNzdW1pbmcgYWxsIHRoZSBhYm92ZSBu
aWNlIHN1Z2dlc3Rpb25zIGZyb20gTG9yZW56byBhcmUgYWNjZXB0ZWQsCj4KPlJldmlld2VkLWJ5
OiBTSiBQYXJrIDxzakBrZXJuZWwub3JnPgo+Cj4KPlRoYW5rcywKPlNKCj4KPlsuLi5dCg==

