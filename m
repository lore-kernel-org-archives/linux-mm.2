Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104D9109023A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAC46B04F2; Thu, 19 Mar 2026 11:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA956B04F4; Thu, 19 Mar 2026 11:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8156B04F5; Thu, 19 Mar 2026 11:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60E076B04F2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:06:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E9761A064F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:06:06 +0000 (UTC)
X-FDA: 84563137932.22.90B343B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1EF840015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:06:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePnDEOd+;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773932764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr1n4pq26+sDotqWU+jnz41PCkyUuxFyXvmfekYnl1I=;
	b=AgZWwKmILijakLMg+Ldb5CCOmu/PSCjSYk65YXr+g1FT+D07cGHb8HsQ2l6y7woYQGb3q1
	CMQWrhTq3EMJziUIXG3/syZyQxIx/PFfTvz4Rcx62X4ipO4p9MCoKLeX9Rz7KpFNCG/0F0
	KBh92cuT76Ffw7qMG6XYVyCNhyqKXNA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePnDEOd+;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773932764; a=rsa-sha256;
	cv=none;
	b=zO3GB9xr+C/oeGHRUES5KP44pLvL6O+Bj/Gp24Flua7rS4JkCWmAOtyShSglkfyIjcAGzT
	hGd/M1fgs/kp3TZ9EStrK10WCZP/ytgvticWBS5WODKP54CiJePZv7Sg1ZUKrh295wGZsw
	1i6Wts07K6PuKIqLtTl82qJPJGQ2IMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773932763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xr1n4pq26+sDotqWU+jnz41PCkyUuxFyXvmfekYnl1I=;
	b=ePnDEOd+EEy4qFpk/SMOBT7Jr80nYEGCl3jxUk705gCT735iqmdzoR+/PW9xMYZwmzpzPQ
	0subnrW51PIsutTQjWs0naoF326fr/Q4iSqiXkMC6WUcZsrtptq7beAVW4GHE0DCp/tb/n
	hZjk7Dm+VG5WVqDd6ynBOzPxcAZEWFw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-PS9mfuncPIO4UkoMK7UntA-1; Thu,
 19 Mar 2026 11:05:59 -0400
X-MC-Unique: PS9mfuncPIO4UkoMK7UntA-1
X-Mimecast-MFC-AGG-ID: PS9mfuncPIO4UkoMK7UntA_1773932756
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D19D19560B5;
	Thu, 19 Mar 2026 15:05:56 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A4BF1800576;
	Thu, 19 Mar 2026 15:05:47 +0000 (UTC)
Date: Thu, 19 Mar 2026 23:05:43 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abwQx-P3pfyJ14ve@gmail.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
 <abpu4OMsy3Xl5QA0@gmail.com>
 <893e70b9-1ed2-419b-9079-5b397b2cec54@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <893e70b9-1ed2-419b-9079-5b397b2cec54@lucifer.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: SEFg0eo2iYK0gfnUU0Se1BHPyWskvXxh4zDk0nhvA5M_1773932756
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: D1EF840015
X-Stat-Signature: mbmqx415ouigwntw1bw7g5bw6gq84ki9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773932763-467843
X-HE-Meta: U2FsdGVkX1+tGXXlrVW0bDKdQLjiLvpa11AHgajT40cvpoTBUsXOqYXOfewBmqr+3oZKKC/TxJtS9t8ToIEW8clddF/f5lUPexPASbikraL+Vs4sWKtsseu287aZXfwVohrfoi3yIqP1E/4SMMPKDbDsXWoDNWsE4og1YbxXCmrHMk6/D0aZtg2wTcva8hOb5lt6yOU1UQ3QCsRjjOjlxGDqNHFuiDHp9NHxZ49mLJ/Z8SOaiDWqt3+yPz0u1GnLxgwhTxAbfchfZ6cSmycWso61HfwBsPrqG7M5UgNE6OhwG3qfsjQhidhF595gfAzgwMEk9CtS6JcpQnDOKlPSX4NhotP7cQQgGXtPldOQHYWJSQ9yKes97o8ySQphnWe4IuSz3oyS/DbdO63t2qbPZD8+3/tLtv++a1/DUjyo5d6en2wgAbWBeZoLcm/RUaV0YSiPxJ88/HT3Vdu2exUvCmsewy2Kg8FpbIGfUesRp9B2oIvk7mtj5VS3XMe6T8Og7+FlmHpPomUjPOJUaXs4OWXX9VFLWF6VJKy03TXzZ7jwkxv8uBT5kVKu4K6e5SglK1lgguU3U59S8EDDYfJ2Z+XplCWwvUMKCDAJeHObEAcP6wNhjvU96Pjs8uP1UxwIT8ef35h1zWpioqim4sCg9tO+dCZ35qjPXtEJFiVWmu1JishCl/J42++xdVGdnbIwgxa0lu1mRHCVCM+uhb8opksbBcDBqYuZBp71L4UplAAh+Y6X6H+XnAynBSUPBB3Qg0CRslEZ2bVfGmoVEyAPi16QYsazcFUjvrfottJRg2/iOUvtc1nnK/8AmvWDdgavWZjFjsOxeneM0kkfofiDTAG7Rr29oDrJlK47GM2lQzl1GWwO5mbKRhh2EcslCBQ4Fgf3LpHuzokOnb1jUSb9cF04NjYKpnCc7lHVTNL9XWlLCMt3OBHBNihUNEA2XMjKXlAwZI3zwgmCmXlkUkU
 43unCMBL
 mTXGfh+H9owsREK6bzRrSxzehkKpc5Mc5b6i+LyOyPEzhsh2kiVkiDs2JlgwugjxF9cI5bDSaEuHpNDtfdV6Y/0Mo30Ac4ZvxPHKQt24PXS9lO3IWN0gbV2LwEU75u7UtkcUxTKZYRJW5Ic9h5u67h4r10O1HH4JlpsOD1T21hSUPchCXIlxnvj8p36GVds7OpRV4qkYTYo+M+0f+FjJd9zAq1/a7hY1EmOEou+Xa1XH+O2qQ8m+SRUOz6nSwBCLBFcZMLcMwLuoLUflSh4iYqF8pnlJ+FJFTloLx0ux1PwQU4z4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:32:10AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 18, 2026 at 05:22:40PM +0800, Chunyu Hu wrote:
> > For question one. In guard-region test, collapse tests are for checking
> > collapse is denied when operating on guard region, not for checking
> > madvise(MADV_COLLAPSE) will fail when thp is setup to 'never with sysfs,
> 
> No, if thp is set to never, madvise(MADV_COLLAPSE) still succeeds. This is a
> source of confusion for many :)

You are right. Thanks for correcting me.

> 
> > result is same, but it's a different test. Maybe we don't have strong
> > interest to test when thp is set to 'never' in this collapse test.
> > Do you perfer we let it run when thp is setup with 'never'?
> 
> Yes because it should still function then :)

Sure. Let me send a v4 to change to thp_available().

> 
> Cheers, Lorenzo
> 


