Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D3BC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6DBB6B007B; Wed, 22 Jul 2026 07:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44016B0088; Wed, 22 Jul 2026 07:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A843A6B008A; Wed, 22 Jul 2026 07:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7787D6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:21:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3936A00C1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:20:59 +0000 (UTC)
X-FDA: 85016170638.24.2CE6186
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id BD5D940002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:20:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="o HtPJ45";
	spf=pass (imf07.hostedemail.com: domain of 19888972804@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=19888972804@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784719258;
	b=JWxgwl+sB2ZfBkvFT/eay+xtZumSUq9qVM5yiGu/kfj6Jtm1W0QFJB2PUUQke8EYu1iDoO
	Qv7pPeVBMXS/jSC3E92mvUtuVxHYIddZ5sGi9o2CtorytJuQyJKvG66w96bcvwSQcFRmWQ
	Mr8MQy+LQ5SgquMNcfs3VeA+FQESZ+A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="o HtPJ45";
	spf=pass (imf07.hostedemail.com: domain of 19888972804@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=19888972804@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784719258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIEMYv+UBnuEDHVdKoQV6XfFB3n1zZpx61Jgju4A+CU=;
	b=LEpQPGab1mVxG1d1Iqx3BjYvrKJ7Qg+qPgPWPnGec4nh5sme96Ks3RDqByu8qMIIK0tEeR
	gZTHrCl1uj3mdKTBdxov96GdYN5JJKzae225oSgcFTEM84U0rMt/euFX/FrmTsg+Bxn08k
	JIr/deu0AUhAVo5otFwiumEhn4so9QI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=hIEMYv+UBnuEDHVdKoQV6XfFB3n1zZpx61Jgju4A+CU=; b=o
	HtPJ45fXTIQ1fToL/miar4bkVNGNJay/MXlviRB6h81d6F/TfDvG8Pj4DftyZ57h
	xRK56JIvJzHG/xyG/KbyllJy1zUuIrdYAlObaydARHGuW1/aLS95yfQKaL7wOXwZ
	FK3n6B6zLGLa2TW356XyeTCy/E4AF/NKINKWenccek=
Received: from 19888972804$163.com ( [36.110.52.2] ) by
 ajax-webmail-wmsvr-40-126 (Coremail) ; Wed, 22 Jul 2026 19:20:20 +0800
 (CST)
X-Originating-IP: [36.110.52.2]
Date: Wed, 22 Jul 2026 19:20:20 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
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
In-Reply-To: <amCSiltZolhgtO3J@lucifer>
References: <20260722092642.1123347-1-yaojiale02@163.com>
 <amCSiltZolhgtO3J@lucifer>
X-NTES-SC: AL_Qu2TBvuatkop5iSbZOkcn08ShO49XMOyvfoi2YFTc8wEowfE3xkNRm9JP1vc4N+tFj2NugS1fzRkw9Zdf4ldtDTUVhc9iF2rcMAcpAzVsg==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <75a79b54.8930.19f898e1ed6.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:figvCgD3H8N0p2BqAGojAA--.2514W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xS582pgp3TLSQAA3q
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Stat-Signature: phqtq1wpmatfkxixmot9axbyzefk39og
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD5D940002
X-Rspam-User: 
X-HE-Tag: 1784719256-174676
X-HE-Meta: U2FsdGVkX1/0C/vRYpZL3zK43GexCCeRir3zA8dgefFmuMflyGG6Dm5ZbE1Qqcg24EAj8Ydh7ev5/ZY6dq08yot5t23ZfaJuX6Nx3hNthCLVizT6rJL4SpFIDRfmO5VFfkdwxXYJGE+V/C/8r2xZi1b1T93On/ezxtuksyo0a6+BCb4b+osm9YRI4/+EGNL1snAP72KpOhfZhXV+hL1QG+4v/gUJ4hQLnxHcXgVLYcX/Buo7W/D5KOKqegOA2c+rpOs4qC4ggUD3wb0tj//gGTJ0FN19VNCm/Eh/2Q2MCsF2L5Zo0QEdbN8f8CLtBx8Pg6fZgXO/NhP4dTc776sp9/zTnO3bP8eSDaPNIgmuC1iP+SNRyY0oYAdHoqCTcY7RLst17dg5noCZSIjTAPrJ9bA2KMzxWHWe5RJDk2G3uGgCoIZodtiTQexbLmcVIeTHI6Wr2BfvykuWjbN2SyC9KT81AtqVEv/HpxFXDX0IN9wI5pI5fW+TK9YwntQcFYsB2+JCL07pOA/74DaAc+lSdaE81QxPQykGTI1nYQf1uD7Pz1D5727tZiGguvH7dSqZf6Aojj5UH2ASjutq5fXaTPztx7HMEAMA0bceeuhDp3FXzuwnGS9dvrHmJ6hzV6Gsi8u9jRdrFxJgCNd3ed8Y+FLJREAmF+I5ZpT7LFBMm5qqDfXzJCymyE03rv3DRJHPhPsswE+sEy9TSezfD5UPnogqE70CNWr4yamjjBNMs7JeDfiRsYpLcK3PWyZfzkxiYjcUWQZ/3P7VbRvb6u4/E5RsnREBd8/2UcwVIMau6/jI7V6v4qOz042DASD3v/MugeH0VVdxWF4YBm3R2UeQ8rb5Trah7o6/UiaMRdP1Ng3znlyYwM6Xomd2pPjy2y+DsF+L8DEaxHPKxmq1cYCrW2jHTLf/iYXk2kcSSoaSWTkSWTFLhPk0m9V9Ch01hRuIlzXeU9udoi88qNODiPk
 Uxv+oJcU
 zVqH++7TCjF/250/DecX+wDSOkpjXCAe0X6Uhh1FeeCxDvSNx2V34ieEaVXs0jYHUW71UBQlkao//IRBNhW1+6eyC4hFoElpyrMJYLLzeasVjWazRFwhFGuv+QuUQuDkbKz/lbTboNUUq7gyJP+HzEolrqQOiwB9BKiNVpDufHE/aaQNMbFmTOPRebPr+TeDusW5k3bhrd2+Lwh1hZorxPDkzfSlbD40sqB+/XrZpitWKrF2xAe5cof07+mo/ck+ZQsaLw7fPSsrSykdG9y2ef8Jn4D3/YZXsFvfTPS92jU29kEj97XqSXtFx40N9FOYy4keJd0SVA6S2oVZRIOpgCw5XR/yAcO+auLqjmnj4i4l8m954DysCNlPSjW0ORnY+u7rpIFudujij87iMI3O1qhchL0qDHvwpRHiSSisc6fVxTJFu8A/KMbeIfyQf4q30qu5mPqU7nrCuz597enwGr7T+RPAObKOY2xZGIPEjiFUG4fqs0fmmmM2arXv00icR0lbUxQ+XyjEtl/PcHmCP6JhywkdFBU5VIVn5JnMO9Sp/dZl2GhAJRQ/KpP7HrPAp734gkqtNRlUvF3SgYE57DJ3YyyI1TiqiCtu+Sgo8ubECiig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cGFnZV9pZGxlX2dldF9mb2xpbygpIHNwZWN1bGF0aXZlbHkgY2FsbHMgZm9saW9fdGVzdF9scnUo
KSBiZWZvcmUKZm9saW9fdHJ5X2dldCgpLiBUaGUgZm9saW8gY2FuIGdldCBmcmVlZCBhbmQgcmVh
bGxvY2F0ZWQgdG8gYSB0YWlsIHBhZ2UKaW4gdGhlIG1lYW50aW1lLiBJbiB0aGF0IGNhc2UsIFZN
X0JVR19PTl9QR0ZMQUdTKCkgaW4KY29uc3RfZm9saW9fZmxhZ3MoKSBjYW4gYmUgdHJpZ2dlcmVk
LiBSZW1vdmUgdGhlIHNwZWN1bGF0aXZlIGNhbGwuCgpUaGlzIGlzIGEgc2libGluZy1wYXRoIGJ1
ZzogZGFtb25fZ2V0X2ZvbGlvKCkgd2FzIGNvcGllZCBmcm9tIHRoaXMKZnVuY3Rpb24gd2l0aCB0
aGUgc2FtZSBmbGF3ZWQgcGF0dGVybi4gQ29tbWl0IGQ2YjhiMDJhMjdiMwooIm1tL2RhbW9uL29w
cy1jb21tb246IGNhbGwgZm9saW9fdGVzdF9scnUoKSBhZnRlciBmb2xpb19nZXQoKSIpIGZpeGVk
CmRhbW9uX2dldF9mb2xpbygpLCBidXQgcGFnZV9pZGxlX2dldF9mb2xpbygpIHdhcyBsZWZ0IHVu
Zml4ZWQuIEtDU0FOCihzdHJpY3QgbW9kZSkgY29uZmlybXMgdGhlIGRhdGEgcmFjZSBvbiB0aGUg
Zm9saW8gZmxhZ3M6CgogIEJVRzogS0NTQU46IGRhdGEtcmFjZSBpbiAuLi4gLyBwZXJjcHVfY291
bnRlcl9hZGRfYmF0Y2gKICAgIHBhZ2VfaWRsZV9nZXRfZm9saW8rMHg3YS8weDJkMAogICAgcGFn
ZV9pZGxlX2JpdG1hcF9yZWFkKzB4YzkvMHgyMjAKClNpZ25lZC1vZmYtYnk6IEppYWxlIFlhbyA8
eWFvamlhbGUwMkAxNjMuY29tPgpSZXZpZXdlZC1ieTogTG9yZW56byBTdG9ha2VzIChBUk0pIDxs
anNAa2VybmVsLm9yZz4KLS0tCiBtbS9wYWdlX2lkbGUuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL21tL3BhZ2VfaWRs
ZS5jIGIvbW0vcGFnZV9pZGxlLmMKaW5kZXggOWM2N2NiYWMyOTY1Li5iNmMyNmEwYmEzZDUgMTAw
NjQ0Ci0tLSBhL21tL3BhZ2VfaWRsZS5jCisrKyBiL21tL3BhZ2VfaWRsZS5jCkBAIC00MCw3ICs0
MCw3IEBAIHN0YXRpYyBzdHJ1Y3QgZm9saW8gKnBhZ2VfaWRsZV9nZXRfZm9saW8odW5zaWduZWQg
bG9uZyBwZm4pCiAJCXJldHVybiBOVUxMOwogCiAJZm9saW8gPSBwYWdlX2ZvbGlvKHBhZ2UpOwot
CWlmICghZm9saW9fdGVzdF9scnUoZm9saW8pIHx8ICFmb2xpb190cnlfZ2V0KGZvbGlvKSkKKwlp
ZiAoIWZvbGlvX3RyeV9nZXQoZm9saW8pKQogCQlyZXR1cm4gTlVMTDsKIAlpZiAodW5saWtlbHko
cGFnZV9mb2xpbyhwYWdlKSAhPSBmb2xpbyB8fCAhZm9saW9fdGVzdF9scnUoZm9saW8pKSkgewog
CQlmb2xpb19wdXQoZm9saW8pOwotLSAKMi4zNC4xCgoKCgoKQXQgMjAyNi0wNy0yMiAxNzo1Njox
MywgIkxvcmVuem8gU3RvYWtlcyAoQVJNKSIgPGxqc0BrZXJuZWwub3JnPiB3cm90ZToKPk9uIFdl
ZCwgSnVsIDIyLCAyMDI2IGF0IDA1OjI2OjQyUE0gKzA4MDAsIEppYWxlIFlhbyB3cm90ZToKPj4g
cGFnZV9pZGxlX2dldF9mb2xpbygpIHNwZWN1bGF0aXZlbHkgY2FsbHMgZm9saW9fdGVzdF9scnUo
KSBiZWZvcmUKPj4gZm9saW9fdHJ5X2dldCgpLiBUaGUgZm9saW8gY2FuIGdldCBmcmVlZCBhbmQg
cmVhbGxvY2F0ZWQgdG8gYSB0YWlsIHBhZ2UKPj4gaW4gdGhlIG1lYW50aW1lLiBJbiB0aGF0IGNh
c2UsIFZNX0JVR19PTl9QR0ZMQUdTKCkgaW4KPj4gY29uc3RfZm9saW9fZmxhZ3MoKSBjYW4gYmUg
dHJpZ2dlcmVkLiBSZW1vdmUgdGhlIHNwZWN1bGF0aXZlIGNhbGwuCj4+Cj4+IEFsc28gbWFyayB0
aGUgZm9saW9fdGVzdF9scnUoKSBjaGVjayByaWdodCBhZnRlciBmb2xpb190cnlfZ2V0KCkgc3Vj
Y2Vzcwo+PiBhcyBubyBtb3JlIHVubGlrZWx5Lgo+Cj5TbGlnaHRseSBzdHJhbmdlIHdvcmRpbmcg
YnV0IG5vdCBzdXJlIHdoeSB5b3UncmUgZG9pbmcgdGhhdD8gSXQgaXMKPmdlbmVyYWxseSB1bmxp
a2VseSBhIGdpdmVuIGZvbGlvIHdpbGwgYmUgIUxSVSByaWdodD8KPgo+Pgo+PiBUaGlzIGlzIGEg
c2libGluZy1wYXRoIGJ1ZzogZGFtb25fZ2V0X2ZvbGlvKCkgd2FzIGNvcGllZCBmcm9tIHRoaXMK
Pj4gZnVuY3Rpb24gd2l0aCB0aGUgc2FtZSBmbGF3ZWQgcGF0dGVybi4gQ29tbWl0IGQ2YjhiMDJh
MjdiMwo+PiAoIm1tL2RhbW9uL29wcy1jb21tb246IGNhbGwgZm9saW9fdGVzdF9scnUoKSBhZnRl
ciBmb2xpb19nZXQoKSIpIGZpeGVkCj4+IGRhbW9uX2dldF9mb2xpbygpLCBidXQgcGFnZV9pZGxl
X2dldF9mb2xpbygpIHdhcyBsZWZ0IHVuZml4ZWQuIEtDU0FOCj4+IChzdHJpY3QgbW9kZSkgY29u
ZmlybXMgdGhlIGRhdGEgcmFjZSBvbiB0aGUgZm9saW8gZmxhZ3M6Cj4+Cj4+ICAgQlVHOiBLQ1NB
TjogZGF0YS1yYWNlIGluIC4uLiAvIHBlcmNwdV9jb3VudGVyX2FkZF9iYXRjaAo+PiAgICAgcGFn
ZV9pZGxlX2dldF9mb2xpbysweDdhLzB4MmQwCj4+ICAgICBwYWdlX2lkbGVfYml0bWFwX3JlYWQr
MHhjOS8weDIyMAo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKaWFsZSBZYW8gPHlhb2ppYWxlMDJAMTYz
LmNvbT4KPgo+WWVhaCBnZW5lcmFsbHkgdGhpcyBzZWVtcyBvYnZpb3VzbHkgY29ycmVjdCAoVE0p
LCBpZiB3ZSBjYW4ndCBiZSBzdXJlIGEKPmZvbGlvIGlzIGtlcHQgYXJvdW5kIGFueSBvdGhlciB3
YXkgdG8gdGhlIGV4dGVudCB3ZSdyZSBkb2luZwo+Zm9saW9fdHJ5X2dldCgpIHdlIHNob3VsZCBn
YXRlIGFueSBhY3R1YWwgaW50ZXJhY3Rpb25zIHdpdGggdGhlIGZvbGlvIG9uCj5zdWNjZWVkaW5n
IHRoZSBnZXQgZmlyc3QuLi4hCj4KPldpdGggdGhlIHVubGlrZWx5IHRoaW5nIGNoYW5nZWQsIExH
VE0gc286Cj4KPlJldmlld2VkLWJ5OiBMb3JlbnpvIFN0b2FrZXMgKEFSTSkgPGxqc0BrZXJuZWwu
b3JnPgo+Cj4+IC0tLQo+PiAgbW0vcGFnZV9pZGxlLmMgfCA0ICsrLS0KPj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9t
bS9wYWdlX2lkbGUuYyBiL21tL3BhZ2VfaWRsZS5jCj4+IGluZGV4IDljNjdjYmFjMjk2NS4uMjll
ZTE4ZjBlOGNlIDEwMDY0NAo+PiAtLS0gYS9tbS9wYWdlX2lkbGUuYwo+PiArKysgYi9tbS9wYWdl
X2lkbGUuYwo+PiBAQCAtNDAsOSArNDAsOSBAQCBzdGF0aWMgc3RydWN0IGZvbGlvICpwYWdlX2lk
bGVfZ2V0X2ZvbGlvKHVuc2lnbmVkIGxvbmcgcGZuKQo+PiAgCQlyZXR1cm4gTlVMTDsKPj4KPj4g
IAlmb2xpbyA9IHBhZ2VfZm9saW8ocGFnZSk7Cj4+IC0JaWYgKCFmb2xpb190ZXN0X2xydShmb2xp
bykgfHwgIWZvbGlvX3RyeV9nZXQoZm9saW8pKQo+Cj5JIGd1ZXNzIHRoaXMgd2FzIG1lYW50IGFz
IGEgcmFjZXkgY2hlY2suLi4KPgo+PiArCWlmICghZm9saW9fdHJ5X2dldChmb2xpbykpCj4+ICAJ
CXJldHVybiBOVUxMOwo+PiAtCWlmICh1bmxpa2VseShwYWdlX2ZvbGlvKHBhZ2UpICE9IGZvbGlv
IHx8ICFmb2xpb190ZXN0X2xydShmb2xpbykpKSB7Cj4+ICsJaWYgKHVubGlrZWx5KHBhZ2VfZm9s
aW8ocGFnZSkgIT0gZm9saW8pIHx8ICFmb2xpb190ZXN0X2xydShmb2xpbykpIHsKPgo+QXMgYWJv
dmUsIG5vdCBzdXJlIHdoeSB5b3UncmUgY2hhbmdpbmcgdGhpcz8gU2VlbXMgdW5yZWxhdGVkLCBJ
J2QganVzdCBrZWVwCj5pdCBhcyBpdCB3YXMuCj4KPj4gIAkJZm9saW9fcHV0KGZvbGlvKTsKPj4g
IAkJZm9saW8gPSBOVUxMOwo+PiAgCX0KPj4gLS0KPj4gMi4zNC4xCj4+Cj4KPkNoZWVycywgTG9y
ZW56bwo=

