Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E70B8CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FB58E0022; Tue, 21 Oct 2025 06:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506D18E001F; Tue, 21 Oct 2025 06:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CB58E0022; Tue, 21 Oct 2025 06:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31CAA8E001F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:16:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCE90482CD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:16:55 +0000 (UTC)
X-FDA: 84021717990.26.410F116
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4EA5B160010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:16:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Q303rShP;
	spf=pass (imf08.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761041813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MDXwoEIFINszKm73LVpBYFxmKJH+hoRSLKsyiU5mp4=;
	b=2MFaHUfXKYt9CbH9700Wjq4JcPzALkeevAU0nfrPKYNoWsP/lVTsEIf8q/KTANHNm2kC2F
	/qAqDahzdaAGjBiLSF0oL5O/44u8dzeK51l/bulifN58XJpzjIK4Wzotu2b7Q47dERL/Zu
	er6BS8HkY3ufBR0/RVj6Tqk+s4NkJws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Q303rShP;
	spf=pass (imf08.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761041813; a=rsa-sha256;
	cv=none;
	b=K9ZQJs2euz6kd++mtITp0mFJFuUB3Wy5UY+mScuQYUgfdQYZjPLV5WaguuhoxznGHTQdlA
	89po8Ea2DvIQG+i/k6rRLRufoo2BS2bFUQvW+TO+CPGOhe0O46E1N4+R8+v4wFAfLMM7SU
	AXsZjnUQydYqhdsHJhs6vvVRgwOf7nI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761041813; x=1792577813;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=8MDXwoEIFINszKm73LVpBYFxmKJH+hoRSLKsyiU5mp4=;
  b=Q303rShP95Hyeez8/4IG/EXcYDVL1EYEfbxiMjUHaub82yYos5Dtj/aW
   k+JmAzC+PVj2e3W1XJV6BgpXQwExyfeJvPWwAQrupxiv10naYksqRybeH
   ST375m7yXnUOC9bHvhmxp8yiK1TWvJbg27yoVYJn3wwL1YwYrPkfWLlyG
   JRiH+1M6I9sS5VZKAnism+F4LAceXfDN4ce+KUbjZNogBkoqMUMKfX8OY
   8jBpbZAjKpUvsyaYqejeo7aJpqqVqUZhDYcmTfTURmrTK/ZCAQiFAmwup
   vGgs++weFmVrC/GS7EuK3n6x5gZJ5DdcXrDm+tjlt3tTpdAAKdI4xSxl6
   w==;
X-CSE-ConnectionGUID: t3cCI8X3TtayPGBVW0wUyg==
X-CSE-MsgGUID: KEzN1gffTHWZaf9BIhzJBg==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3947772"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:16:43 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:30186]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.17.8:2525] with esmtp (Farcaster)
 id faaeaca1-ecac-4e7b-891e-ed40e4b2799d; Tue, 21 Oct 2025 10:16:43 +0000 (UTC)
X-Farcaster-Flow-ID: faaeaca1-ecac-4e7b-891e-ed40e4b2799d
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 10:16:35 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 10:16:26 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <nagy@khwaternagy.com>, Jens Axboe
	<axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
	<idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
	<chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Anna
 Schumaker" <anna@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, Damien Le Moal
	<dlemoal@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 6.1 0/8] Backporting CVE-2025-38073 fix patch
In-Reply-To: <2025102111-stoppage-clergyman-f425@gregkh> (Greg KH's message of
	"Tue, 21 Oct 2025 09:43:45 +0200")
References: <20251021070353.96705-2-mngyadam@amazon.de>
	<2025102128-agent-handheld-30a6@gregkh>
	<lrkyqms5klnri.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<2025102111-stoppage-clergyman-f425@gregkh>
Date: Tue, 21 Oct 2025 12:16:22 +0200
Message-ID: <lrkyqikg8lfux.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 4EA5B160010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: oj6uwx4hyhofxaxuo14ph86adaskhb66
X-HE-Tag: 1761041813-377905
X-HE-Meta: U2FsdGVkX1+eXvqllpxWEN/R6nNSHMDOxMfF8kQVm+LAtj1zY3eG62vJfK2nD2cU5QUL/pjH/Eh2EBfyqYp8Uj2jht6wjTBtzzqeVrUI2Lyw8Ms3E2zBbgyKtvld1kTZgO3qXLD2D94hcHZl6U/nFQcXnSSEewc5/K6yT+xAFpLk5pWg/mFwjCx/q8RTJRditUW/8nVwfBjPyRw456Ev1ZGa7xrD9dUwuIhwq1ubXsRPtCKKhSZPlf0OD3M7yKaq8BkghR1Xv5IpBqSOJXfgZnGYbMwEkG7wWIMdtcBHeDNILOd6uGCweXzcUV3RJFxeiQk0hylQYUBAfMJ7jHRvZt60v2l64zLK0AlhYL1GRyvgcyChZCQ2RYJy+vM1WpAIdIbDMM33ejBQXlUmYjTfUpW+F/dQH8mWsXUKb33BT+JubYjSepTiaXiIgsfyG+PY+haMgLsC/I91gspVt3tt0S9RJ32543DENXCCUm++NHSqCDJ1oLi/wU+GZimA34YciAT0dabfa+9rtrczGAyMpROwSCK29gHtGSzAyDsRCO5O6WlerXIwtzfQQ/OpIq3sNtAQdttMSp0/LAKquG2kSWJXkJkijs7BVAU3DBpONJQ7FoTXTOdJxTP9xiXbyxq893a5mHuKT5lu8fKILqs3WdSFwj1NP3V5OIRM+ixhcGFW47982heNt87MuSaXcNTsp3aUSczSa9+vdkOGMIFvBK2VEK+kHUnbmOd5TaapPQV1LJBrKJmtXKBnJmUbbJy8UL1+uVs5pB5RxK3CyicOfOdozUHSbH9ilHKRKii4seKk5MiudaVVmbZpBDPkl08sGJzYzwUF8JcuRErcWoYlk+eSp5owl4m1uKg7LTq59siIdeJgWDZt/lO6EiLqxCEhlS3/UqkUYqdNed7AR2pVCY4jFstBnPhp3Q296qziDJlATFTs8WyOcLMK0CQ1oDSJHILUlXDCuBthMF2Ifkh
 UkKhS4tA
 QbAZFouVvso9ovr6Jumh4Q15Aui1vMwEjLQOIplVX+m06EhwiiIXaswj9PjhFUtcOr/gRE4aWDMXECdYb4UXcm3cGKCVKifP9ZLLLQQxcrA1MA7eyr4p+HxCvMsaHeX6ekqn6RyD+bBzwLRJ5wUVJPvQ1ovekqpbFu5yaxbLjO8lsHmBbORahHGmKdDMwYpu/A4T9S8urqF0QfC2JjAopoG/94aqQ9i6pH9ttyjvrhLowZTRQxGyDQNKh1XHYfz3/fN11m06oASIracFFcL3RuPG+P31xlQ8suroZgdcYzCvJUVhe/7NHIT2Gm3fsLMn4S7i/e2hE+FsdhlyAB+kv1o28oXcZYNwdyXmGZ4xx/bR3eePVVM/e0MeOMnbVQSj4eCFzoKdSwVOqKyxarhYheQWX5YIIIllGte+rpCD2dH42POAPNDZxcLA+JaJoGbODWc2NhXkBkqkVu4jMc+axniKL0FNxZORbeIPagOZbRHRepjezAF8hqw4vTzmAU7IOzPIAg+1ixMlfAIsqVETtHIrAV+p1iIh1fQFcTEDJFVsonS9eMtdTkTs5xMQniphR/wFgA4IJ9tAo9TULURfi4dljyr5Ehl7AX5Slnp4wo1CndP2BhayveZHtvR4IwXYvcJ0U6sAJoYrZqznjG58+MuIBH3U1VonjGf+1v98IG/WIUSCFRUtPOtapEeVU6elztxsbKts/NCecdms=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

R3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyaXRlczoKCj4gT24gVHVlLCBP
Y3QgMjEsIDIwMjUgYXQgMDk6MjU6MzdBTSArMDIwMCwgTWFobW91ZCBOYWd5IEFkYW0gd3JvdGU6
Cj4+IEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiB3cml0ZXM6Cj4+Cj4+ID4K
Pj4gPgo+PiA+IE9uIFR1ZSwgT2N0IDIxLCAyMDI1IGF0IDA5OjAzOjM1QU0gKzAyMDAsIE1haG1v
dWQgQWRhbSB3cm90ZToKPj4gPj4gVGhpcyBzZXJpZXMgYWltcyB0byBmaXggdGhlIENWRS0yMDI1
LTM4MDczIGZvciA2LjEgTFRTLgo+PiA+Cj4+ID4gVGhhdCdzIG5vdCBnb2luZyB0byB3b3JrIHVu
dGlsIHRoZXJlIGlzIGEgZml4IGluIHRoZSA2LjYueSB0cmVlIGZpcnN0Lgo+PiA+IFlvdSBhbGwg
a25vdyB0aGlzIHF1aXRlIHdlbGwgOigKPj4gPgo+PiA+IFBsZWFzZSB3b3JrIG9uIHRoYXQgdHJl
ZSBmaXJzdCwgYW5kIHRoZW4gbW92ZSB0byBvbGRlciBvbmVzLgo+PiA+Cj4+Cj4+IFl1cCwgSSd2
ZSBhbHJlYWR5IHNlbnQgYSBzZXJpZXMgZm9yIDYuNiB5ZXN0ZXJkYXk6Cj4+IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3N0YWJsZS8yMDI1MTAyMDEyMjU0MS43MjI3LTEtbW5neWFkYW1AYW1hem9u
LmRlLwo+Cj4gQWgsIHRvdGFsbHkgbWlzc2VkIHRoYXQgYXMgaXQgd2FzICJqdXN0IiBhIHNpbmds
ZSBiYWNrcG9ydCwgbXkgZmF1bHQuCj4KCjYuNiBoYWQgYWxsIHRoZSByZXF1aXJlZCBkZXBlbmRl
bmNpZXMgYWxyZWFkeSBzbyBpdCB3YXMgZm9ydHVuYXRlbHkgYQpzaW1wbGVyIHNlcmllcyA6KS4g
SSdsbCBtYWtlIHN1cmUgdG8gcmVmZXJlbmNlIHRoZSBvdGhlciBzZXJpZXMgaW4gdGhlCmZ1dHVy
ZSBhcyB3ZWxsLgoKPiBUaGFua3MgZm9yIHRoaXMsIEknbGwgcmV2aWV3IHRoaXMgd2hlbiBJIGdl
dCBhIGNoYW5jZS4gIEhvdyB3YXMgdGhpcwo+IHRlc3RlZD8KClRoaXMgd2FzIHRlc3RlZCBieSBv
dXIgaW50ZXJuYWwgdGVzdGluZyBvdmVyIHZhcmlvdXMgRUMyIGluc3RhbmNlcwooeDg2XzY0ICYg
QVJNKS4gT3VyIHRlc3RpbmcgaW5jbHVkZXMgcnVubmluZyBrc2VsZnRlc3RzLCBmc3Rlc3RzLCBM
VFAKc3VpdGVzLgoKSWYgdGhlcmUgYXJlIHNwZWNpZmljIHRlc3RzIHlvdeKAmWQgbGlrZSBtZSB0
byBydW4gb3IgcmVzdWx0cyB0byBwcm92aWRlLApwbGVhc2UgbGV0IG1lIGtub3cuCgpUaGFua3Ms
Ck1OQWRhbQoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55
IEdtYkgKVGFtYXJhLURhbnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5n
OiBDaHJpc3RpYW4gU2NobGFlZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0
ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4
IDU5Nwo=


