Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4923C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4861F6B0096; Tue,  5 Aug 2025 08:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D7B6B0098; Tue,  5 Aug 2025 08:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A516B0099; Tue,  5 Aug 2025 08:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29D5B6B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:04:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83B48114E63
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:04:55 +0000 (UTC)
X-FDA: 83742572550.01.A72FA4C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7372A40012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:04:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754395493; a=rsa-sha256;
	cv=none;
	b=hICsVPQxnHbfkrpYfADaLsbPutC5adMGiAwJesA5TYXGnwgDc1qtjXqVrKpdLwg+U6SaTS
	Lgq830X/Y1k9rRLMqJWHhBQuBBEualpcc91WGz6iI2LfRSF4Yt4xpksZ7B9kUwvmseAMNQ
	LAl76hsysqXX3ARPweL5rprP0bqMdbo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of liqiang01@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liqiang01@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754395493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2Cl/33UxBOoMvNk47wMeR8+SlfG3nWtUCvGaWh/Jkc=;
	b=2K9E+RhU41TBRGubNWnvfOiuGpPBSJ5seTF69kKBw0VI4ZaiyBxoui3spbJSVnMPRQ1d2m
	O8gB+scYPZitoHEy172Bae566Nja4AcZPn2HP7lzJzJsu3tHBHtN3+x9djW5Mqvptg1v7F
	qzmhBvBk7NsnwYT80ow/gRJr4JmtxtM=
X-UUID: 5c889e4271f411f0b29709d653e92f7d-20250805
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:e08b59db-1227-415f-9524-48b789a41595,IP:0,U
	RL:0,TC:0,Content:11,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:11
X-CID-META: VersionHash:6493067,CLOUDID:bde39b8ec4116adce4cae47d27490bca,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|102,TC:nil,Content:4|50,EDM:-3,
	IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:
	0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5c889e4271f411f0b29709d653e92f7d-20250805
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 55385721; Tue, 05 Aug 2025 20:04:38 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 71C0FE008FA2;
	Tue,  5 Aug 2025 20:04:38 +0800 (CST)
X-ns-mid: postfix-6891F356-36186845
Received: from localhost.localdomain (unknown [10.42.12.14])
	by mail.kylinos.cn (NSMail) with ESMTPA id 53D29E008FA2;
	Tue,  5 Aug 2025 20:04:36 +0800 (CST)
From: Li Qiang <liqiang01@kylinos.cn>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Subject: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for performance
Date: Tue,  5 Aug 2025 20:04:35 +0800
Message-Id: <20250805120435.1142283-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <74580442-2a9a-4055-b92d-23f5e5664878@redhat.com>
References: <74580442-2a9a-4055-b92d-23f5e5664878@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7372A40012
X-Stat-Signature: b1qjexm8ukynkffr4qzb8oaq558s1ue9
X-HE-Tag: 1754395491-358399
X-HE-Meta: U2FsdGVkX19gUVyC8/DEK2Dhk62kgYnMk0cFO2QyfqgYgoRtbfQcSwBnWlxU6EJbPpfIOJ6KwdNhCuSuKXX3qRKMMSTClH9IJ+Tu8qC6P2eACz2WoBr7Pq7lBe4pFCr0A+FNjlRnJy+xubWns5eIFuluWdEKNo9m8p1Ujfts1NPqlGz9CbpHEJMOMsnftvCiyQTW7UPqKsYeDTBsdZHdSzSlI8Rzb9HFyK8wKQYg980lhJzlzI+NnHND0AgIw6jNQSkXkgTyjdEyoaupJ+MmDlHLppyZ0kqGHZDBM9yJggfk1xN7e4CsTL349KLJ7t58kNJtL/sQlcPgT19qbfbgHMkK/4E2QEBEo4wr+FtYWcrpMx0d+BaLaalHOO51gjxN2S7OT/SlNBWKTe8ZYtDDJt1uo+dI2dwKpJWpyszJwt90oa6SfaZLsUf4tobKyRww/ffw5DRvTYUTVsFC9VIpWNheaPpQNqNdA9Z1YE/2tMe3PW7vYNP33mWsY86RnS6X1jEDVhpDkzNiQdyECSGGGQpFg1AW4VMtzRZG63nejcoxb2Zf5yee2yyldjTfwMYAI9p8ekSUD7UUd7VI3sHi+FU7yEOLygMTxbJpsUZ8Mp3YGxKZa3vNFjHWrh9LAMs7OMplIGBzmCxjG/E9WNMffjGW6ylerm+PIX8/hd6Yx2KzDvn/B0YKwp94uuGj6NynW6bgP8IlwI/wakhfBCCEGj+WcCi7WjyActfK1bMrPVPps8zsD7UJU4c7xF8Lwn1LIRluc4eDJKIZt+FoFo8bqc0Y3uMjlm8+UWTlAUWkZn97abKutSFG/qT4ehJGt1nEdQMV7p9fifl+qciX1ejizHneQXHIpx6NMDrFTHVLxoIgsX9thJ0vER3F1hTI1ZetX/rgVWNB8aaXPtSH9HPSC3VLkhduFlBP0BlhpGS/a3RSPvmVc0CxPFVyi9dVznKZo8+BqZlrSi+93XFed+K
 Lq1+RTGQ
 53JUQb+/NuTXFNjc8ewFX6zYoITtrrU5avudylmzfk6VUFV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ah, missed it after the performance numbers. As Vlastimil mentioned, I=20
would have expected a bloat-o-meter output.

>=20
> My 2 cents is that usually it may be better to understand why it is
> not inlined and address that (e.g., likely() hints or something else)
> instead of blindly putting __always_inline. The __always_inline might
> stay there for no reason after some code changes and therefore become
> a maintenance burden. Concretely, in this case, where there is a single
> caller, one can expect the compiler to really prefer to inline the
> callees.

>
> Agreed, although the compiler is sometimes hard to convince to do the=20
> right thing when dealing with rather large+complicated code in my=20
> experience.

Question 1: Will this patch increase the vmlinux size?
Reply:
	Actually, the overall vmlinux size becomes smaller on x86_64:
	[root@localhost linux_old1]# ./scripts/bloat-o-meter before.vmlinux afte=
r.vmlinux =20
	add/remove: 6/0 grow/shrink: 0/1 up/down: 4569/-4747 (-178) =20
	Function                                     old     new   delta =20
	zap_present_ptes.constprop                     -    2696   +2696 =20
	zap_pte_range                                  -    1236   +1236 =20
	zap_pmd_range.isra                             -     589    +589 =20
	__pfx_zap_pte_range                            -      16     +16 =20
	__pfx_zap_present_ptes.constprop               -      16     +16 =20
	__pfx_zap_pmd_range.isra                       -      16     +16 =20
	unmap_page_range                            5765    1018   -4747 =20
	Total: Before=3D35379786, After=3D35379608, chg -0.00% =20


Question 2: Why doesn't GCC inline these functions by default? Are there =
any side effects of forced inlining?
Reply:
	1) GCC's default parameter max-inline-insns-single imposes restrictions.=
 However, since these are leaf functions, inlining them not only improves=
 performance but also reduces code size. May we consider relaxing the max=
-inline-insns-single restriction in this case?

	2) The functions being inlined in this patch follow a single call path a=
nd are ultimately inlined into unmap_page_range. This only increases the =
size of the unmap_page_range assembly function, but since unmap_page_rang=
e itself won't be further inlined, the impact is well-contained.



Question 3: Does this inlining modification affect code maintainability?
Reply: The modified inline functions are exclusively called by unmap_page=
_range, forming a single call path. This doesn't introduce additional mai=
ntenance complexity.


Question 4: Have you performed performance testing on other platforms? Ha=
ve you tested other scenarios?
Reply:
	1) I tested the same GCC version on arm64 architecture. Even without thi=
s patch, these functions get inlined into unmap_page_range automatically.=
 This appears to be due to architecture-specific differences in GCC's max=
-inline-insns-single default values.

	2) I believe UnixBench serves as a reasonably representative server benc=
hmark. Theoretically, this patch should improve performance by reducing m=
ulti-layer function call overhead. However, I would sincerely appreciate =
your guidance on what additional tests might better demonstrate the perfo=
rmance improvements. Could you kindly suggest some specific benchmarks or=
 test scenarios I should consider?

--
Cheers,

Li Qiang

