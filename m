Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69FFCD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCD86B02CC; Fri,  8 May 2026 20:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286896B02CD; Fri,  8 May 2026 20:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C076B02CE; Fri,  8 May 2026 20:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2C16B02CC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:27:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8C85402B0
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:27:12 +0000 (UTC)
X-FDA: 84745991904.02.4296457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 024B680003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:27:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aeUcwwza;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778286431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LCt+f2138+Ht881h2AoxWlnfSxPFv9SYoG5Mk2VV5Y=;
	b=3nlX9p0mg7D760oq7pAFvgQ7X6Ks4XsRviFxccqdiXxh8wtBYzUXYZ2v+cM1Gmso+P8zEg
	fVfrT/HP6ePH5RruyGlIj1jwd4RgOciCFfJ8nr090heDEzTPraHwxL9ovSkJf3LMcIvFnc
	vTUkYlgT4lOsVwciiC5qThaB+RfbmLQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aeUcwwza;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778286431; a=rsa-sha256;
	cv=none;
	b=B8KCX9LA7sHFO8qR3t/V9P/OPNQZJbXNTgd0aSTy13et9jrbOQuMrCzqiBn/A201KF2GT5
	JZwFu0R0PrRfsAV0AdvdS46EfJOlYhV2S7FglDXZKRaMd/8IwAnmXd24kOKqo7oGDDkBXm
	tmDofVskFPNFz/mvUnXmDND835LuG0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E50740466;
	Sat,  9 May 2026 00:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA182C2BCB0;
	Sat,  9 May 2026 00:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778286430;
	bh=lj3t25AO1UbejZmNeBe4s7I6xyl0HcaIjRZuR0VYWs0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aeUcwwzaQp757OmoDqNGM1DvbsMLz6VsqPp5kPpcGDbRkZKBP9h4S2H2VJU/7PGwp
	 AZYq/0JU5WiAX6svT8nc1ThXbSTKkufmHP4tTnGMd9oBCbI1gzmv6jdAbE/UoBMEgC
	 VX/AbACV9xfxcU4nXcyjqY+pwGSWJQ9gnQmWM9ww=
Date: Fri, 8 May 2026 17:27:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, Danilo
 Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260508172709.b7a0eea77f64d14bb5dd5af6@linux-foundation.org>
In-Reply-To: <67c914cc-be1d-4aa2-a6d6-dc26e0d53316@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
	<67c914cc-be1d-4aa2-a6d6-dc26e0d53316@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 024B680003
X-Rspam-User: 
X-Stat-Signature: gjhaq96461s7n9iqgkq57i88oku548es
X-HE-Tag: 1778286430-209432
X-HE-Meta: U2FsdGVkX1/Ab6Z8ddfTPTrj0VyrKRG+/1be0tGO2/IPuq5/UGbvV64Lpg2XueNTNEFBVJza99+27OArWFZnBSqxcLUigQVQSTJZqepDAFStzzqPShIdQkd10hkrRn5tY9WFt4rdfgUj4KR8dJsB7Cq++2rwpm5CUxdC44VTTRON7qWZl9MnXmJW0k7zxS8NwpP9nduVBNSNPQNFvY8+lRgrbPUOpEtVtmfjryPSv1km2O6EbWMx0WJGzrCmSyzMRkGssuTyE+8djqEn/bHIH69oQWGP2PQs+efPK/71fUWXIhHqWf7EMSoQIqzZEjpQdHLAASwQEk3cd85HgGIV/VtOD9wVNQwCLHPLBHjWq8CL5qg26EsezgRdSPejEQaPpK44XceS9Y87pIQ4l7IZQFxawQ7acYRB3wuXrBLwVvUXxCly0mwNQUMBgFC/Qx5oaLBMiTfXgHKfgpS882zap+TslwelGMRTLiM9KNBARESYdcSuiXPktBiN2bdJ+nEPvcRoDjNhVnTCsjCeGEjYYoqc6ic0nhgOKDTpA0+mDCcHC4yCJxtwZasWZCbZ83Am/whBmbNWM679SqF8aKysYfib6mIcPVFIxsXZeDrFn19Pp1sTpq7Tphq9PKz034LaVtKku0/vYkJhgxJoWA1rn80aRu58DpEmNHfdsZMPepkEbmrFopmMcDmB2DA2WHcGRm6eaNyBONAIq3c14da3OZNLJO+/EAHV3WGGTZ2Q2CahhmOlz/rn3mnOYX5VNKBS2AZOS9756+pM+npvWIvUevyn/YJEJoWKJztc3oewtCqfq9ZHbYl94gfH63qBMuoHBforgmaVXGd00KO3YwG+aEomQbBIrbDCFXJi9yIgV4lUATI4Qpetmx578M1dIR2zKqt9jaFtL/fDpEqL6Ueo4vVYtwTobW5vYGDjvr6U3QaCqZw7QXUGehy4AwkxaDm7v2Xgc97PfvjiPcmlJR1
 wA613AkK
 cdQLpqboOG+LnFTivP8wMOuGOfJQU4++TtmZcfsek9vmItsdwf9s/oDOmh3E2Ai4qCITHpu5/lTSQuYG4gFt3VRYfo/zV2+GrAegj+0tv4WIWYjxsrvTOwYCnzaB+ZNUTnzERzHIsxDm8FGbpOCUoz2yjHq44Ah5bIYPJ590d5JRCUor4oYq51NNBEIkexKJyWIzFB9Glx9d/pB+FYruUSzQs74Nnue0aHxupzQhl6LZe3mESqEU4FxMih5B3E3dhFVboJ0AyHr5eYS9qdcntOxCo9qj2U1J0USvh7mZO991gdNKaO4vW1ybN7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 May 2026 21:12:15 +0530 Shivam Kalra <shivamkalra98@zohomail.in> wrote:

> > base-commit: 4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
> > change-id: 20260302-vmalloc-shrink-04b2fa688a14
> > 
> > Best regards,
> Gentle thread bump. Let me know if you have any feedback.

It's been a while - I suggest a resend.

For some reason AI review couldn't apply v12
(https://sashiko.dev/#/patchset/20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in)
- perhaps it'll work next time.


