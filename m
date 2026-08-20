Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8FBC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8666B00A4; Thu, 20 Aug 2026 04:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0796B00A6; Thu, 20 Aug 2026 04:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095626B00A4; Thu, 20 Aug 2026 04:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDA386B00A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C05BB1206D6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:32 +0000 (UTC)
X-FDA: 85121004024.16.B6937DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D0B0180002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i3DHjbZn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ks9IfuMNaPCSCunGbgsmYYPVdpXTwtkZPOYnvZRqNR8=;
	b=SB/61antYJFIIzMEHLLOi6lpgHDYV2WbjRucxjAsGSKUMR3pUz+iJWfS3s+JdSb2wJOzN+
	xIZ3tua51G0VDdt3dXoBS+9Al4XL9ZfuwIs2jOeL7xCsBU1ZDoKMvjcj6hTuXodspy3l9Z
	gBgxG4H5SBTpTV5M57VcAznL8FnHD0I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i3DHjbZn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215291;
	b=g9ccA4RuZseglWN6KPTlhSC6qJasJXeDVJHW4+kheLZMft/qH2gxWaJqP9t9d2wAB4AAO9
	5qAlxgYv4nbu+tIiJC7XMGoer+RTcq9iN5qwCnH9E7/y9KZgAKlfalpg7gv68w/XidGBb8
	Za95VB/bwvTD1Z2NWmKJvvRFIzJNvQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B83AC60AA9;
	Thu, 20 Aug 2026 08:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336321F00A3A;
	Thu, 20 Aug 2026 08:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215290;
	bh=Ks9IfuMNaPCSCunGbgsmYYPVdpXTwtkZPOYnvZRqNR8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=i3DHjbZnskVCnWn9XFXrqflspNOID0xnw3yzoGnE1LsfpNK39Qg6qDAVJwbwuOvz/
	 Ug/DHley0rZSz9S3mZAoobWB+67wddiSdi+zUA+undCCVOETU/P1tJrFIR5lZRstUT
	 Exr/QIE13Npj+cIdwXxlJ/k5S1QvJ+U+bRUIAlB8X53fu/W1L8D4VNp+z33U7D3cYI
	 U3Qxkzv4ieGdSs7v0oyPXsFrEQmpqQACNkDE0A7ow9pmPJR+bvEMD4Lmz13dAL+Bcl
	 rZRgdkHJdv5TMU2VUVXb1hjUsNNzWpHoKOkwLEvRF1U0v0keskznJZaUNTKHwr/+dW
	 Scqd6Pba4XtpQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-13-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-13-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.8628888160176030191.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 2D0B0180002
X-Stat-Signature: 1jjouoazkg5cr3841agq7prj3wh1j59y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787215290-624542
X-HE-Meta: U2FsdGVkX1+SKbV0ex4AxD9KWYiv0tabPWe2mZdC+x/1oVDW0ji+cicsfPeUcHFLdQ0viMDN9dHoc4YeFNFCjhhPeJypfp+7hb/VDVeDaBg4Wxb+yB5vz0/dBlV61Ff5l67Wx03f2PhBMdA/Fau2s6eTWkyzVnNB11ZPcxEw+coYGsvDQV40Az8zX7sBfyyUR0LX0syBWhiZAXF8YHV8U1YeMGXQmM0tB6l85cBxKfd/OYsL5zvCPJiE3FLTeY5dzAFstMqoj56sQhHHUlQid6cEgHms56Lrai1Xc6etLu5qcqddOXKJSP8c+yEJqTSKKzdAzQG6ZwJRMN32MBtRtxDEgOV4TDRibXLJMwlHYPqEEv9iJ8gWVpyBEeJgpSlUE/FzfKYIdxW+uS54qYVIVMTfjYV6UQODZQK8hPUOUL0qwg7C9aPU2D5ESkzn8L58gkl+Ki8p6LuKzwVJl1OKQDDuu3xvagW3PwgE6EtH8ducUFGPY/K7/3nW+2i8uKMx/DG+QJ6fFobMx9Kw6vtn3Iff2PT4CmBRUwNOXH1djkDn34kyvhVj+ARsEDfDlGoq7nYLN0qEW9kgHSDhxUVkzytdTm6DJL/EJg3gTd9x9xdqROWtGs2h7XAbeLYTeLGuv688sU70fS/RA3ylXzLQ3N7YNbWXKxorFZLZnCYvh3t4JG1YRFHMkg2JE2n9hYV8VHtnBo67QnmA5s/AVVPhY96P8IB5er9unARxcFZxT8Xe6Zqy9oj0qaItYKNlC/kcSeiJt81NXjxuU2firC/eY817lrECXVO9803tic9qor5jw+cQ1+GXJ3KR5/MMZhaHwBTiQL6RA8xzQ5LgfAmieBV5olh/JdiaWdxRjvavWDwnYeFN1mkI2dYuT3LRDTCZjQIBrUN263rbru5ph+lpb0WkOo16gagHjGi7aef4GWfGGcm8wPowOvpFGfQkUx3zBVxst/Mz8iWUeVghhoK
 0uUNLVKt
 Bgox8WKHvC3fcYLWZhYX9x4ChCpwY571zdjHu9kmpK+ZpiXTzw68XCFjhzyuoHYsOCsS+Sf/PGp4PWRqUFggjx0mdGKER25w7Dh+/eC4pqk2TZT7LxygzLDuX1+eZXNx1UzD1j6TTShpkZ0vncjMxybVlmdqyq7vw1OgfyyB8f4YdbKRLafiPYTlCGFao3ADMUesw9zlFGBFIrfFx8D9CP7Bnyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> collapse_order_mixed_sources() faults its region as order-2 folios and
> collapses them to the -c target.  Order 2 sits below the contpte threshold
> on both arm64 page-size configurations, so nothing in this suite unfolds a
> contpte source on purpose.
> 
> Let -s name the source order alongside -c.  The case then faults at that
> order, keeping order 2 when -s is absent, and the source order has to be a
> supported mTHP order below the target.  The other mTHP cases are
> unaffected: mthp_push_target_order() enables only the target order.
> 
> "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> larger mTHP.

I'd fold it into the previous patch.

-- 
Sincerely yours,
Mike.


