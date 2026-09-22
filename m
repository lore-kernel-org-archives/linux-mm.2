Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D8E3C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28666B00B4; Tue, 22 Sep 2026 04:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8F76B00B5; Tue, 22 Sep 2026 04:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF406B00B6; Tue, 22 Sep 2026 04:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A74886B00B4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:45:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22A928040E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:45:44 +0000 (UTC)
X-FDA: 85240765008.11.B7BCDE8
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2616B40008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:45:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=PoYMuCbD;
	spf=pass (imf17.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMkqWegiB0G0RPwXQW4iIweHXM+gp+p17tn0BymDpW4=;
	b=NcDgyXMemkNSc1o+oqJBl3h23Z1NtRbxUO73M+kF+eD9QR3DfYODJl92cSijt4gLJuZQ5/
	ttxtQzJVlURAee5zYtI3KAsXOp7yViykijDF7DUWwApyNCGLaiMkMQqo+ARd2jVpTMd+jL
	paT6gyvwv5cSX3jojYnU13qi7kDsOmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066742;
	b=7Q9xd5SE3udsVGwN59bsngowXrGbX//AsZzfg8kICeaB/HaIVU88kC+2l1+K8MgZFZSSO5
	3r6MFafRQ60GqAlSoAyhvQq1uaqJ2H8CgjkETnPmfGvpiNLuOU0rSCQKyJXgSrj2rkzlsA
	LAG/qdLTfs/LBa2OGn39Ck4dYzc5GAk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=PoYMuCbD;
	spf=pass (imf17.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 8158014C2D6;
	Tue, 22 Sep 2026 10:45:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1790066736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hMkqWegiB0G0RPwXQW4iIweHXM+gp+p17tn0BymDpW4=;
	b=PoYMuCbD9oC73v8MabIRDQ3JYH4XeiHnm5aaAnrfKac+pcFVw4u0zG7Q5mO/e9wxlyeOe1
	wPCpRD4zwp1eT+md7c3/W0aYzOGHlnT6XAd34OlyX3hv644M2SrlvG9My5h0E0JjR/haAm
	ybqfvaacyuI66Ycljs6YAwFwuRtx0CHUVbs9OxdIiRyxGfXNdfcsrWzVw19u+VGcM8FNWY
	Im0iNN6j6OH7JGsKriu7qK96ggrORz8IKbl/de/VP6+UJsZ1LQ5eAIWIK96cIou9vZpJ7X
	62BWFHiHBNxIWrUKhHUP5AY/PpCAmhqqKAFZ0q7bndsF8kef3Gww0bAYOPxKFQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 02e7d134;
	Tue, 22 Sep 2026 08:45:29 +0000 (UTC)
Date: Tue, 22 Sep 2026 17:45:14 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+de6fd6789748a8aa64a0@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	v9fs@lists.linux.dev,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in v9fs_fid_get_acl (2)
Message-ID: <arJAGlhkDJbcy2sw@codewreck.org>
References: <6aae188b.71f81b7d.15fa6d.0004.GAE@google.com>
 <20260919031451.3f47a8da8405e88fa1ab5398@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260919031451.3f47a8da8405e88fa1ab5398@linux-foundation.org>
X-Stat-Signature: rxp7kmhj8djogr4fjyx6muqp4ryow7g4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2616B40008
X-Rspamd-Server: rspam03
X-HE-Tag: 1790066739-252832
X-HE-Meta: U2FsdGVkX19AIKQgK/EXE7pAK6umEJEVkfg8pabTVfjqXvIzuvYpiACENufH7tjfDAXxsKwnYyxi2gPaIXcla7xVjzJdOpKR2Nn6bGArUB6tYGDRH5xp/I4VCsQRv9/kE4VNzF4zosfhutB9+m8rKp+I8OKVSLzBDouZiWJAKTCqRnPkh+G/XjndX4RLPeUZRsYayOB/i7VIBNZ7KMSGXHnhpddkARdzbp/21Q8jhpqhDkVPHq1/tGOxIFXQjfBiHJzz14Lua4sYRgyDXhdkqAP0rLfzA6ACqwaz1F5JKAsDIU4DLwV2pkhB9T78gv+6maf5JDhyrB/n7bjNx3jLVIlZ47Y1xMLYTfEYdrULD1hYelFlZP+hHdmRlQJuSV0EaU4ErVRAXO89Okwx9btYGfDlMy3NBsIhTGksDHJCErQD63XyvW0zVi4h9qhWkku1hpcZ0tn567Kk5/xV+F+3KVP3ppHtgFReAVR3K4+oH2SF+8zf0F7h8WRLimiH5SU0NWRf5dZJLsN+M18XUYjjp9trpuKkzZeeznlO4uW5FEijoSaQwmHLnPLBHsevvifLJEU1IBuotDReGKOlCeYiLF1rudEpNRIszHS5nTE6QIMh2rtXltKVUnV6d1FyzqJX61KX9fjjRlnjKdwX1ezWUnX0CP7TgVLTmj7mb+YEp7HKey6AHmmUrBd9V82o2Lj5sCyurwvnPb0IGic/TwCO2Gf3KSVne9e8oPs2x1TP5/7gqWYRY6GCcrAg1iQaHDnuQU5anTCXFyMJ40lbYaBCkA11m9AcHAN838myJmwcPhYFbIIPS1uyrOfBNEAf+yq4V8XdWe9SxPECjn4Z1fyiCoQdJnRm20yxe65kuNRmns20RLHWhQd+mVKtikaBf8wB8uL8RbxAFNDxBg2r4r/fsd+ocKr37iBH2rrMByG4OObiuBNYSQdpYrmLJCxmN5RUtF8BxQ99ITzZeDJiP6y
 7+pmpkTy
 GNCCRzKLiEfUphtoXnyZp3I+Pb2CkhaNHK3mT6kO8hpHAECwt9exB7m8oB4eMnZ5NWfGFUhKggZukYFZjhPS+MyfzgknGLiAYR/bX4COAihFXBfDUc+i7ZbTXuIFMVmZmrTFidMw3WnJobifFpzQi4UOLw8wWzt7wVEgTClQOq7kOAaLuAoXBPz6t1aF2TJ0J7YgfvDAGO0qAiR966kihMJ3nBE7zYlIce0OhtfMjHJ8jHACfNus78pa8E+YwV/ZlrQJVQy2ujHkEZ6hgdnsas0jSCDgY1/MbmpBjpGuhKGdpmZyJ/Xj6w0BUOZXjC+RQnU2vYvssh/0rrKS2SyvGbZYh894qQVCn8aeLYZx8z6pw9awuZUzBgs/pngmaixgjkf5XmFTfmZbW4SLvkB4mWLc3tYROUCDdfptWgh+puQY5XIl5yJv/kgu1496AgonkQcQAAaMHBoh1Vcn9Z2QLETVhIYpdxG9c2ZjL5hxiTJeVwQ8/LVC7ghRL+6QEY99gbPR2keQJaV0hUR2G1+WuREiLDGKD+77lDne/qt0ELWGLG23Sqqw15wW59EV718EtblM79e7qbfsZ1CjWemFXG44HBnxBJZCKFTaqnPIg3nHXkr5cBeCkZihrlCid/VGtynTTuJIsS/P8jQxZpWiuK02l1nAjQd7/T6PZew2sWbrveCln3+wvSeTljOOavLWVLRrn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(+Nguyen in Cc as he tried resending sloppy patches after this)

Andrew Morton wrote on Sat, Sep 19, 2026 at 03:14:51AM -0700:
> > WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.1.357/7872
> > WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x2137/0x3300 mm/page_alloc.c:5397, CPU#0: syz.1.357/7872
> 
> Thanks.  Caused by an old v9fs bug.  A fix was proposed but never merged:
> https://lists.openwall.net/linux-kernel/2024/02/02/806?utm_source=chatgpt.com

Right, we've been going in circle with this since forever, and nobody
answered Christian Schoenebeck's question[1] about what the limit should
be, and while I don't care much ultimately I sort of agree with him
(e.g. limit should be XATTR_SIZE_MAX for anything that the VFS layer
touches, but acl are converted within the 9p subsystem and could be
arbitrarily large so status quo of a KMALLOC_MAX_SIZE limit because they
could come from something else)

Andrew, if you have an opinion on whether we should cap the acl sizes
anyway, please say...

[1] https://lore.kernel.org/all/Z1n-Ue19Pa_AWVu0@codewreck.org/T/#md7c1e009696501b3b87940cb613150bdebd1db28


-- 
Dominique Martinet | Asmadeus

