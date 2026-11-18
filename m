Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBAB606A337
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=konsulko.se header.i=@konsulko.se header.a=rsa-sha256 header.s=rsa2 header.b=AtuvhMyf;
	dkim=pass header.d=konsulko.se header.i=@konsulko.se header.a=ed25519-sha256 header.s=ed2 header.b=vYcO7f3r
Received: by kanga.kvack.org (Postfix)
	id 305A36B05B2; Wed, 18 Nov 2026 09:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD5D6B05B5; Wed, 18 Nov 2026 09:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3126B05BE; Wed, 18 Nov 2026 09:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03D286B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 951691A07B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:29 +0000 (UTC)
X-FDA: 85448520738.30.88372E6
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C49B4000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=AtuvhMyf;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=vYcO7f3r
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htsl1/fGGN+PK8kCB+H1dqKretrCIe2LVjelGMma61U=;
	b=MHm7EQrWW/SlCjulkAypgKRxiYczCduuh8PyXOCsStjMDJ0o3AtAxLq9Ix1+w65sDZ3xFP
	4vfKaqS29evPFKp1AzU3JRUJNLE6XXwto6WFRLAJTEGG9+mqin4SFD5JcxdHj7Luflut45
	VIAlis2+wpX3yg67CURvOfSp5pIPqqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013308;
	b=chHcXW6ZyZiLOWXtAnhDiARRcio3OEPkWxLCNH9eAyfaQ8Wb/odxeX1yZvUZ8h1uwA8stE
	DdklX9KrLqXZXDm3fzD280ahjWpZkQjj7CmcP4pMKYrgwqKXcFac/dfqXq884MT4pR9Kia
	6BDv/ZQdJm+apt4Qp596RaqboKys21g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=AtuvhMyf;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=vYcO7f3r;
	spf=none (imf17.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795013304; x=1795618104;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=htsl1/fGGN+PK8kCB+H1dqKretrCIe2LVjelGMma61U=;
	b=AtuvhMyfZOiYIH4uHrjJkgfksbx2zZbGG3biXW2Y6/sIkHDbZv3K2A7hLZyFr90xTLB0LXZNWedyp
	 PUK1yNjhrurTP6r5PrO4lZkSsQHPaTSiNSxYbnyT50Um6fmHBimbQEavR2KGd1t9POMfIIfacWpyyW
	 iBU+oaG32/vhEyRKi7GtFAk7oSr0Vx37pHiZjyaPCPoQcqvBQrtKddHGzgYKFSFQJYdwPICmVmycEF
	 G1Fb4yKCfIza3J85vKDZdsu6Qp8ZbVCCJMOZUgiYM80yls1nmBy6Xc3EPcQuvKSwU9N0wp0xq3Y2ke
	 62eiSKPWW/II0UgwH3Y8rHW86d6Dn5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795013304; x=1795618104;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=htsl1/fGGN+PK8kCB+H1dqKretrCIe2LVjelGMma61U=;
	b=vYcO7f3rEhBhvaDX1PNXny5mpLRHqDQccdydc9sgSLYM7bvLQuqz+ULSIDLuY0RO8Tz6+Ai7jV2pb
	 n1HX7hECw==
X-HalOne-ID: 1a0a10c3-e35f-11f1-9ca0-17c427e4a17a
Received: from slottsdator.home (unknown [2a02:1406:27d:15:2438:a644:c11e:a5ef])
	by mailrelay5.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 1a0a10c3-e35f-11f1-9ca0-17c427e4a17a;
	Wed, 18 Nov 2026 14:48:23 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Jan Engelhardt <ej@inai.de>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 0/3] rust: block: add rbrd, a RAM backed block driver
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-Id: <20261118144822.3197130-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <176sn0r1-3s85-0nq0-p258-220pnspno416@vanv.qr>
References: <176sn0r1-3s85-0nq0-p258-220pnspno416@vanv.qr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j87q5kzafz311thtkuksmezto74gnwtp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C49B4000D
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795013307-426376
X-HE-Meta: U2FsdGVkX1/ejNJce1tbbpBMnu9R1V21jDH9DTLWbKvnHDwIG7BIhnBI1LEuFLLNIagvR/FlGNax+nCJF6vLycD4wem2FqlPKhveuadxWnrFb0NLraYqG5bgwJVezs30O8Hzz7LJ//WzM9FyKxVwRO90ji29u221PSf5whJbLjKFOB9PewAE4Kezeb2ZWmVW2wdqdcL7iAMkEXDh2Y7A+kkk0ygWhgr1ZZW2RA7xz0QjTragRt8A1UMlc99OZ48459qeCYTXQVjycvcagrB69zkGTaR0mN9/d9mwCBKsaFPZI5rE0BKfBhNZAmg01FTuiG30Mcu7RfosK38qJX53AJIuJ9vMk0cHpK99DzxhmNSvg8Xm066x9yZgy9gnJ1ENSMvOy0DohHh0hm8n40WrFqcBGDVb2kW7h8bDl01vfN0Mc1DFFSm+NXi7Ie/bgdwTv+yLGGDFxOu3xsM+LBwJl4kf+tQZmxd2u6HRGNWn1tZ+ZLF+d5Zjiyz/J1dIDl5rnRghmRlYdm/wB7MqodZvs6XlARS8HPLVR3vOLCFPyR5SAdt8Ll9hUO/Tp2FOygjCQhBVUdnkW9jCojygUhK/uqZomxKe0OUnP+UmfWyyGlGiTduCepuhMWZViRmxTesD6lCd3Y3Ky/XxcXKwD/FyujQIiuTUDx4YmpA8vLglTbtlCpl06M/fL91j5UG6t11FlqAHxKlOZJybLQONUljz09HQbDaM5Hs6HUzPx3/zyCEAt3JE6ABvktivuuiqSFwvHem3xRwoK8hn+Sf/zRYKKyl1xz3dId0KEKGilc4WNQoTHY/oCJt3F1ZW5PBZDsXVxNQYTM1VL5agrmmKXbV+IKGf3ta1twaCjJkjzZ/ksESqN0GF/uuP/yNHQpGXynqee1hefPDFLWbjfHduxkRyEi8XBNRB8kzShWhzknNFV+cD8m4p2AuVtJ/m/Up85fR4AyX2kKdr1WctDePV6be
 Whi+VzqT
 NrVH6DtGRrFrcfRhXXdnY2cZS7SCji3timNZ+SzCQ8Hko/ITCaDn0Ip2cBz3lqZgQF9+i2Hf2vexYHNISjJZJXYaPGh4w+4uC0pRtxiK4eUA2MrfrC1VSFfUTmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> >
> >  test                  brd    rbrd   change
> >  write, 8 threads     2004    1563    -22%
> >
> >We think this is a small price for page integrity
>
> A free 28% improvement, just by using a C driver, and a bit of 
> discipline in the program (not submitting the same page).
> Supercomputing will be all over brd if they need a ramdisk.

The posted result were for Rapberry PI/QEMU, The more cores/
computing power we get, the better rbrd actually looks, so
supercomputing should not be worried.

As an example, on a Ryzen 9, median kIOPS over 3 test runs look
this way:

test		bs	brd (24 vCPU)
				rbrd (24 vCPU)
					rbrd/brd (24 vCPU)
						brd (16 vCPU)
							rbrd (16 vCPU)
								rbrd/brd (16 vCPU)
read		4k	4661	5207	112%	4411	5251	119%
read		64k	241	265	110%	177	189	107%
write		4k	2034	2597	128%	1942	2606	134%
write		64k	111	134	122%	105	131	124%
randread	4k	3508	4690	134%	3398	4853	143%
randread	64k	229	245	107%	170	188	111%
randwrite	4k	1833	2598	142%	1773	2680	151%
randwrite	64k	108	134	125%	104	132	127%

Maybe this is what we should have posted in the cover letter in the
first place :

~Vitaly

