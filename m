Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16478D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CB36B0088; Fri, 19 Dec 2025 10:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767B96B0089; Fri, 19 Dec 2025 10:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6712D6B008A; Fri, 19 Dec 2025 10:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512E66B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:27:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07464B7FC8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:27:46 +0000 (UTC)
X-FDA: 84236600532.19.6819223
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25239C0017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:27:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pKdvdyer;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766158064; a=rsa-sha256;
	cv=none;
	b=vy5mEJbIh3W7XCjjZmByqfq82vyjyum1GeZnQdcXUoagjc1ZdwAenAgZ6YfBAU2RPVga3Q
	dgcoBz9mapYOKiV3WuwPrQ1VMZFvXt77jTFZbzZzmyRBdZ+MHbrsyl+xCet3VM+UDg3RVF
	QCqTHtxw+kvG/8+YG6XmVSreVombVj8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pKdvdyer;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766158064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDncrGiyCjgaDIVym4h8nDFMc3r2dgxvZ9yUDX7s8ZI=;
	b=3g68Q72hqUbK+4O9eoHH59QlD9GHixWBwVejodqFsY1Xe/UzsOS+15EfsEK2Y28Tbt51Zr
	m390I6xsjSZEfAAcbQzUODN6BBqhJHa3aATCakVfvUHdICtWVBOHT6bfgUZTgiYhiVL63S
	8v2qJ6+vW3iN8i4zp4E6jB4+mRQXNF4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1766158061;
	bh=Uhsnqls4yZ2FtTg119wqQBE9SzpCbIHrU71KeMrbDAk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pKdvdyeryGRVMBfv709CDYYmO0cuRXd2BnCxxG4w+ZSddK9HBwFqTUsEMxuTF12u5
	 CDo58VONE+RyJQ0KGtQqMoSvSz3Td9A+4trRs2+8K1Nr8eoNOKseJ9Bbxsfyt0FHeG
	 mJzd9g2aylzV55QtB81eE6ZjcWQVV+gM86qgdESR7+TjSL8JDgyWhV4LWQ1hjMpPxA
	 6QMeBLKcP0THsmy3BNAGYlWzBJ9oF8sfGN++CjXlnGoOvRI9VZkIweSUKRC9sG2ErH
	 G3Fa5qYy2qV3jIrhiI09Dn/7xgYNflu+s8wYLQbdaocxocHIe4rdFmAMu5sB2x1h9e
	 WeBeLz7yyb0Xg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id AD80E17E137B;
	Fri, 19 Dec 2025 16:27:40 +0100 (CET)
Date: Fri, 19 Dec 2025 16:27:34 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Will
 Deacon <will@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Robin Murphy <robin.murphy@arm.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Asahi Lina <lina+kernel@asahilina.net>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <20251219162734.46f3aa9d@fedora>
In-Reply-To: <20251219151434.GI31492@ziepe.ca>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
	<20251219140557.GH31492@ziepe.ca>
	<aUVje_QZvJ9rjedp@google.com>
	<20251219161153.420d1c46@fedora>
	<20251219151434.GI31492@ziepe.ca>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25239C0017
X-Stat-Signature: tjhsdbgggz8jxxrgc4dqd9mkdhqczdpq
X-Rspam-User: 
X-HE-Tag: 1766158063-597654
X-HE-Meta: U2FsdGVkX1/D3Rn7I1ZZIMumev/jAne3OmYQFVcq7W5hMtJyEhuTjZnOVmJOUCwa5vqB0vM69Pt22LVc3so6WrFCEFHaCqAo5QWaqmY6hxL2Zpf2YX13jyUmkBaEuNuN6qh1kdNAM7ow1iiulyk4P7Qbfm4yGYqqLqS5EUPcb+iGNUUedBvRiLh6pczBE913nzI5n7dK8nsWeFVRecnEEqdJAP3u5M8US6WEbQHloQCicbl22OyM5VxUcqV+8wXYusJu1+n8CWBoZprS0nfNKVPCbZ/URq8zGUpZKnlkNbtCPaNSLvG/nHRU4tKM4oE/TEqN7fU2JFrOEfcmfA/PDqHPLfLNrySOR/sWBjk0LQVXKkhageVmxyd0rW/KlGBXSLqmD2up1gTu+u3WY5Ft/nMAhn+TaCJRNqafr35USNf572Ky96YYGNoCFNRAxJyg0RacN6NPjx+z0pxJE+QX4NBVvU9To/tqik4ftZ+6m15js5tXWrPClc50v4YNgKFFMaZkHSXP/iaD8aTvI5PiF5xKuCF7+O3uP1r2uNzOlmonZol84XEmy3a8gEOS7R9Kc4dCHY7uYWZhceaLizw0syBP4zMEeBLyHOI8LZeJ6xT3ZQneuP59VzOlMvk8C5YzqMWxoc3aJKE/Iqa500zgjEKK7eXu4sWE1kvGH03Hm2r3WFj1QP1jSexbLrIp9C0lbZmdnW84xGg1hGykeYy1NYTwVbapTr4TuS+2p0jvV/sVx9TOoQvTTpNGqmtvd4fnL43UM1KEBCd/61WBd+WCcVLfE2/1/hR8C+fgVBFJfGSJcjGDYt3BHCyFkZMKmgjcEu0f1zwh2Q+MkfU41wX/VIexrJWeMrsZtfhCURB1gBHlkW+awbKPfkCJBTPCZTcLSZrv/Hg6gJPfjInn+qLuTQEq/jw8UWpBipHuOun/PET31mdEAQ93ullTciaZd/IZDI/kIbdThovt82dkgcq
 iMDnskfd
 3mxaGubqZY5N6AkIRrcPmhOds3lZHi/cAf/7h8e+qhTrb8alojvRzUPd975R9tTwlZUQOeLICQteShq0HzzrXhDqA9ChTppa0b38WnG39esP8BtmugwESw2t5MSrMq9pZmpRLpdGzK8urYh77fvXFeiqFM2V9v4hsWriY68hkaoXfLoBYYtwCAONCXb4bgyEsOZAEpeUr9uZjThTIwyhD+odcv7junsKEgbew30WkqWqud221yE5wg04HIpTIZq9p/N/8xgzmwx1E11d9KeE4HByCmcQV5QcZ+Nw7JnOpUMZNshzTI1XHThrkkdJVaFY9dwzQtEpJhwUiMe3jBJq/J68/Nqp+XBwp3NFEEEc8hP3GnjavwhX5iuQP3PxZLO2x2PEwkToIjfRuxUmU2o9bkMr70FVIamBzUjCSBF20strPCJE/7mpj/yx36n1OPlMU00M6S3mI8bQ2PkOHdcuLDCUQDTjMk8It+bobeznK2gWc8UXpq7DVtfsVBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 11:14:34 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Dec 19, 2025 at 04:11:53PM +0100, Boris Brezillon wrote:
> 
> > There's actually a confusion between TLB invalidation and L1/L2 cache
> > flush/invalidation. The things we can decide to flush/invalidate around
> > map/unmap ops are L1/L2 caches. The TLB invalidate, we don't have
> > direct control on: it happens as part of the LOCK+UNLOCK sequence, and
> > no matter what you execute (map or unmap), you have to surround it with
> > a LOCK/UNLOCK to provide support for atomic updates (GPU is blocked if
> > anything accesses the locked range while an update is on-going).  
> 
> That makes more sense, so these GPU drivers just flush the entire TLB
> every time they change it - built into the UNLOCK operation?

I don't have implementation details, so I can't really tell what
happens internally. What's sure is that LOCK takes a range, so they
might be optimizing the TLB flush to only evict entries covered by this
range, dunno.

