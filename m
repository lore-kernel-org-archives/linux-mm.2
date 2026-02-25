Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947E9FD45F7
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3C36B0088; Wed, 25 Feb 2026 16:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D436D6B0089; Wed, 25 Feb 2026 16:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F5C6B008A; Wed, 25 Feb 2026 16:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B294A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:30:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B81A1C7C6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:30:38 +0000 (UTC)
X-FDA: 84484273356.12.836B022
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 701E140010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:30:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DymfepJT;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772055036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIx7xpJAKG3rp50w4mFIwemSrU7r7VFTxWlJH0AP6ys=;
	b=Yz50csOkBl3S/VGuvQevogTHbbi5Y4UXEfK7W+n/h5SjHOlOmwYzb6S70hlpjv83ACmT/z
	WR8vGao3YPfE3Yo0dEJY9xHZLTpSpyXBn2p/arH+qrc20mWVqYjEgjagJI9jW13MXQjPIf
	cmKZXURLDJcFX1WTZb8gBxYhYkUOBFI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DymfepJT;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772055036; a=rsa-sha256;
	cv=none;
	b=eCv8d7eEggIcAXP1t01Sl1+BbnEcQl4sNfwHUO9DrzrXocNhyAsUrBlxh7B/IT8iYJVnLp
	aMB7u/0nVl08sQUGaTCiUwH3B++22emqtnOL9BW55nGyeuZPs+PXyk0W259f3wlkerA/9M
	3k4WX4rsSSoCMQpOHDdKlX3XMMdwPus=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44E5E4450F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF79C2BCB5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772055035;
	bh=ZIx7xpJAKG3rp50w4mFIwemSrU7r7VFTxWlJH0AP6ys=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DymfepJTjK8poj8lWQ+xL4D8miMOtIPuQXAxE9EVm8p9zZ2vLH5g/QX06FbCvUlmc
	 34zQSBs6UCSCvQ8yERxgd2t3UojVJ0aIJSHAwNXL1mmDLKDDv0cBkYvxkunJosITKY
	 2fFp8Vr7rqikgCtlvb57ZgA8RxUnJGDDNkAqFP7QgDGcXk0vYFQvfuvx2pvEw3RCum
	 b0A47AeGrWxihck4oV2F+Qjk/9BV3IkWBn+pu+74hYknKLe8PJ6XsmNweS2fnxnD+F
	 ROk0dSG1BGR7VNMg6rXO8X44wb4DKBQFnehUmCuSNnI9ZznWwFVDF2+6QJSTURO2rH
	 2FBBT4bE7i6nw==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7986e0553b0so1004247b3.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:30:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVnaPS2WXtR9TDZazidwHqDCrFW4yskUzs3A2AOOT6rsn1Adsmr2Jam1sm/p5PzIOE+9JJbdTTo/w==@kvack.org
X-Gm-Message-State: AOJu0Yw5Py+0bhLrwQ6CFc9eEMIn41cwHDG+afZexgioav+S9cDmzkU7
	rqx+MxEBG/XvzCRNSfqF3B2WCjfF6ze+Altf907SZf4D5ZlnlYOo9DXOrUmotejhBL+Ppqt6iSj
	Tox+ep++MFzM+YwfKcxwwzeeV+/bAgJEQooISOjCO9A==
X-Received: by 2002:a53:ac82:0:b0:649:ae70:a19 with SMTP id
 956f58d0204a3-64cb7c6774dmr55381d50.55.1772055034234; Wed, 25 Feb 2026
 13:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
In-Reply-To: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 25 Feb 2026 13:30:23 -0800
X-Gmail-Original-Message-ID: <CACePvbWD_==Un_WQ5yrWRQPW3NYXGGJcrR+1xzJ5==OUeyZOyw@mail.gmail.com>
X-Gm-Features: AaiRm53JD5mYZwCyRFdtabuI7KdUPzXguselTUuNlrQqrScpwNfu5W5ykbSO4eY
Message-ID: <CACePvbWD_==Un_WQ5yrWRQPW3NYXGGJcrR+1xzJ5==OUeyZOyw@mail.gmail.com>
Subject: Re: [PATCH] mm: Remove stray references to struct pagevec
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7sw8muk7nof8k467jazr15ohn96kmw43
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 701E140010
X-HE-Tag: 1772055036-409540
X-HE-Meta: U2FsdGVkX1+ZmYpZW+zz3SWmnGH6az0jWtU6HsLBRxzoFDnnkua6QNBBLSP+nVq3jzlBS+Nvf1vC+rZGtchvj4EVYbmv0dfw95kI7YQXnLkERjz0fzIBvd1X6MjaDsW0YSvoOIJnxdKV16qEon9P2im2iwC+zLJvpPdd1+FBzes0QP1ac8IvRk1gpit/jDkoEFCvcKgMz7I9FY0TNFWiPrGUMCVa7eEFB5NsBsJp5ZmG7wYY6wMZGhQMjLcmaM5HHYWjImOMJaNrRAHI1pr5bf8nipfijUjtTz3jq3VNhJO4RAiimXR3PIp0hWiiOff4+IEKwXc1Y8c1Wonwzs84An+EdP4yets8tohGXrEDyTD2REpkb9vGH42uGh7yTehl7zHsGlrI8fRWQuVWfAwjQcDazUwIcYAZ04edBQ3xU5wu+bYxTfBa04kO4oeCVM6PdKG4Y8lS0UTCFM0Ivhp3wh4QCiN26hg+wqsMu1hQgACTgNmoonOW7QG5Nv1KAIludC94twGfs7IG1h3fvAP0rw4NuAsZxjpFX2GeZnqkH7PPPPf/RL5oxjHnjd2EcD+VDS2+MbXMb8CX0ETaQmEdTCb9thyXs/ECtl9nrcR5UZjABdVOW5vSxDM+R1yfIOdP91gi2ZIcdu8JHKeR9xI+KNz+qwzXRXiPVm2AerUJ9KVnrat33M/KNCSBppdMYulfjrUUicYc3wQM2vUFqevxHDFdGjVaSklXYb0ectqGtp6dyl5aqaXr64M7IenBjly/adsdt5ggJLRgA+C0JyO+OceP2okq9qbJybn2iWLVB/XKplnD+leAGb+NVdfRI/kSXRYDtoX44OYywIyuu615N97GGziiDpTVEXiz8iRS4stTIo2nOXy+KxjZSeYM3SO3RhSL0+fz5mgtbxO0/oSeWQHHFQSvpm4MrNyXtpzPv7bhSKTn17JTb++26+HGe2xAeSLtGsw8ZOn69zwsxU8
 FHK+VbTm
 qVmQN7MKgbHQinyVzQyWZIvnBj3zwJKJ015mf77Bmt9RBWM9zUtAwQIay8YlVFHWAOXJBNZbBurdxOIma2SCdArTA9xCCuF6JR7QChpo6pwoeD1KEKZz7xY97ZSJJ8MLQlyAzOEqor4ykUENbqsm1PAoRqIlf5TfrJPMpah0tGnisCZLBsNjeooySL/zJZuX99/swO1V63sbF+aNYhTOH8LokMSWi5vCUxfyaGo/5aK8nBfa+itLTF1A8E3IP44+5BgAN52Yi6AR2o1YiUBE92TRFr8NHYC4PGu9TDT9WK9MzkOBWg/MJORd/+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for doing this.

On Wed, Feb 25, 2026 at 9:57=E2=80=AFAM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove remaining forward declarations and change
> __folio_batch_release()'s declaration to match its definition.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

