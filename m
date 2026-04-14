Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041FFF9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1936B0088; Tue, 14 Apr 2026 19:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692216B0089; Tue, 14 Apr 2026 19:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF206B0092; Tue, 14 Apr 2026 19:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1C76B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:21:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA24DE36ED
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:21:47 +0000 (UTC)
X-FDA: 84658735854.25.A2B5236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CF71C0007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:21:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzrFWux8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776208906; a=rsa-sha256;
	cv=none;
	b=HPQmL9Pe60I2vJHOKR5nZ7KuUaNDJUY4TowkmPzBftGDa3wBScVkILxiRsenMG+lAmqUUJ
	cs+IAjjriErztoZGlSLgwPddIBetzon/oL1H6HiXsAcOovFiONhJRptx0u+WXT9LF+xuGZ
	7kimH0RvJxT3940DYtM6kpED72mdVF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776208906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9z2GrTB9XjHImS8vobySB91FdevqsHBKprMoeLVmro=;
	b=SVNLjXwCQbuLX1AAQiSghGaZfXlavatjB83Yic4M6Hn7NhhIfo4vYPDkYm31Xz+D9J1lRa
	RTW4vVT+ExQf5LZplXAc6sUnD6Pzaf74KUJ9n57qv+y5dvgu5SHJwYmz0iBmOx+y0acG5B
	4oMM9bn3aeBWeXKL/S/JGIsJol47JiQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzrFWux8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40F1143CB9;
	Tue, 14 Apr 2026 23:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BF9C19425;
	Tue, 14 Apr 2026 23:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776208905;
	bh=yBEF1CTj/r3UoLSD5Bnk3vGkbeG10Wf0bCAiGqbjEX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzrFWux8nf/PwhKRWNRD7bYnMw6ccJDIwxfGXqKtRW/Z/bspGQcnkHE3Tct7GoUpV
	 pBbWjBkZimd0i1IAgjQw/7qTaWbT5IjwC65rWCxRYPsQFrY/kmVloxPWPeyPgy7ENu
	 CYDDJIC61mABK5uh1unvxRkkj3GldVF9oubkfYMch5Lne2I7sFJIDMt1yAnNYmI4/6
	 hwD54f5WgyvSGj7VLdYjRUOBXcNcGFgkSjYblGF6LK91ZNr635e5a4cAwLVCfch5Gd
	 0Narx0sQbRgsiXaXDCr/oZ6hgM+DKVIoOMH7Xnhs0M4ZBZzFiWJmC6nT3GDvWLWTwq
	 9z4HJ+BMLoWsg==
From: SeongJae Park <sj@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] MAINTAINERS: drop include/linux/kho/abi/ from KHO
Date: Tue, 14 Apr 2026 16:21:36 -0700
Message-ID: <20260414232137.97202-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414121752.1912847-3-pratyush@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4CF71C0007
X-Stat-Signature: wuswjfjp6np6y4eshxh9q1tgty3mkujb
X-HE-Tag: 1776208906-622568
X-HE-Meta: U2FsdGVkX1+RLMvO4eL4VGrV1Uv4QP3D94AmAcRZfTEakjd71BMcZT+UT41oln+J4Tc4MZn25mbC2VwRbZyi/wiE6/xKJ1FB6JSan6NHI55s3+Ct4peDFCGxgK3KNkPEfDgBfgrTWPEZ7IxhkMzxSiXFnbwI8lbf6Z7+O5LqKL3zUfy3w5tDZ9oRv1AUZDIHYIpqxGSb7EQX3CvnZVUJLUavhwziNZ4/kvpSjaO1/GfGJchp2oeHStfDyRxLDRL/jxg1qnnq11B27GdDIA5gD90vTM22l931YjOv6NKBD/s2CX3Lq26uFrJtWZJyuC2pP7tRIR7B/LOZbPMyA1MyWINY6ZfmkARNIm94nRGTZOGHXybEaM+vloAycldEez24KE0AmINjmtQMHOqqqh2NPpZea/VDGiKeNEc0pUthLdfXaUU2lFkyRgljMaaeRhpcsWT/iUH1yEcZWdpegc+1K3QICtWFnfjX64OIqpIlnUKBhPd7ObHRUgc2rzIFD2IN+sHdD/SHmQEiQ+0hD19c5UR65mTTOX3AE1hb8Hhrzl3NRv7xDAYDAoomtbuyx9GPcwpzMfyh9waCZ51AMhLCz/YkBLRy0sj2RBMYmljfvGTs3RaoN9goeZAgFj+5BQZlqOJZgyjOHYEG4Q8mxHeArJnm7i3lHuxFi6c2ZdA67oyFEL68tKU7GoP3hWDmrl42RAyW8n6PcfMRAPFMIeIx1EN7PU+oFRff0Q1DmkQZa2r0xcbsVNHncVAHEyGIKjXTeCW8MQdLrEkY7jogDQ+RXZ56+pSkzFZAk2/08ETAYvvCVyn9dABTjOqtt5U5E07RQxOq8DYtpmkduEdlVM8FTJHR/TddpDU0UncixOKZpJg/2psZS2hWmxoOhbyvDNm+amMXnJeuE0wPRz9tk5Hl0xjrrcJ8tn7xOSRVot0dEHZIlvo/SZpVDKZfqCMqKoN9YQfmjaGPHKj+W38nVQr
 wThcfvqO
 raS/tdfLkgRiXnFMtbyxYpQ0yYKKdP9pmIaqGQKMwBi37mNdzNFBgf0aJcQepy/YgxJtsUWJLTmfvfMg6UrIHyZCp1g3ZVywVOiX/448cGlfzuhZgRS5G4ZeU5Nro2kyEJjDs2peTbXlEbD8RwLag27qRgxCwtDSoFO2DB15+O9pM9XTfOtuJcXaUz/hrO/FzGJtinRMt+KuQcBn8raH91mIvjB9nJPejDWYZHcoASMpVP2W5TGcI3/+8uMgd+XCzaZ/y3YLrJWv5Azs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 12:17:19 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO entry already includes include/linux/kho. Listing its
> subdirectory is redundant.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

