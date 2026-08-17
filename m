Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC15C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 00:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A248F6B08C8; Sun, 16 Aug 2026 20:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5596B08C9; Sun, 16 Aug 2026 20:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CDD6B08CA; Sun, 16 Aug 2026 20:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAC36B08C8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:28:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5F86160607
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:28:41 +0000 (UTC)
X-FDA: 85108875642.10.19F623D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id EE9DE40004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:28:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMb5ECdo;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786926519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZazXSOY/m3892DihJiOWbg+m06h3GKDSJedsq/1CQg=;
	b=cGPkN5qdE3p53wbYKeGlMAy6fSpO7PpeOsw/ZGirjxqTY/XbC8eml6u5lACaWzgGYKw8sL
	5GdDo0YorYMW2wWK53UFVdpQWzcvPRGUcw90BbAygH2J7sF9J+kpTH83kQKdk+5PqD2Ouw
	ZFUVByIL2l3K1WJtEcRmL14R0jB9YD4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMb5ECdo;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786926520;
	b=zI9UfI09Rnam315wycrMujJhpVU10nQg4UPoaChnwLiUT6G0Y+pSpQdFrh35JLtF9hcC5n
	FTBFGsAan1dFqr0VRVmuPbvSVw4VijG1spsgcEodrz/t/2imXIftyP5UNvQvoNtvA3c+az
	2oEnLh07w0uYLezPIBGGXguYE7S2Hbo=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4994d67d260so96325e9.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 17:28:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786926518; cv=none;
        d=google.com; s=arc-20260327;
        b=Rb4Fd5KKrzdlPW1Dhx9L5giPBT+Ly5kW3dcWiFGRYNgS7b3xuS+LdkdapQn4NjnQ0X
         l4efwuTiRjs00/iC2q38vblb6XX7JKEBJzn4wRyJhyDkC8cdipBQV9CDbofUJ4qUlL3Q
         RRG2rLFCQFWxJbg2Ci0Z872CFr/dy0mA6aaA2fNB9yspTuVpwBQbeCiVO+icGJd0Hnga
         jeZnK+pPCs/RiE1GyykbPl0akW2/4A7ln4pv4bWJJfGA2NzzZthWQVfhDlUISdmYp3v5
         jjIJmq/4RIcOsxSwrhUrEBwuejulLb8KrKwhIrD8vJ4DgV92N8xjx+Wo2ghdOk5Nxkyf
         yrbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IZazXSOY/m3892DihJiOWbg+m06h3GKDSJedsq/1CQg=;
        fh=bZbeXodZAwGW10WtDCSwNzphnD6m9YqryJo5QZNdjRQ=;
        b=Pz/ykuV30ap6NcY4/uiOpTDTj3CXSMOyfhKLJp+DuaNvwMDHLFCKbEDUNtiDSnD8yp
         oK/MMh5HiryM4K8VN8aVXSitqbTg0RpDpbCs54rTV4opcvyFW5vcyOtJw4hGXsJiLmdZ
         DtYNM62BYWw+Q44ce8TJuemXBtUW2dHyRSEcbNV5xlLz5KVYWNd8fL/NnEaIw/IZ7T7P
         hsc2O66tEZT4q9fxrdysRc0zAWc34deB2M+7CZskOA3D52H5lh9xahmwaBqtrDuyL3rF
         s8celt07euTfLc/FbPF6lV+YJmhABcPzwkygKWIsLFbsSJrCJDhegO7i2RXBmYjopMtI
         gVbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786926518; x=1787531318; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IZazXSOY/m3892DihJiOWbg+m06h3GKDSJedsq/1CQg=;
        b=BMb5ECdoEBS5OC5OWdHdzhQZi8rNZc+d8vHQyxAeAzi6GjTY877zZkHmTGUnktkou3
         F02R6jdBMRoQ3LOf39zqSOBAGHO5WtGEl+xFELj7Who7patKTpl5FpIGPpKsDnF5DJBT
         hLarcgvk2KDTL7AWFYuCCfuziZB5YUZTPdzNJQt4eT1ithw/KlzCoXvp82CK1DkmGo70
         Udry7TJPNXHF2/nyrYKCdGtDojqw1qHsRKAMbV/K8QNiCXupOBk2YqTCwkzZ7OujPIOf
         TWFkQKako6Cl0b3k8dTL/1jUyFmFmHtvMOaNHOBYbhPoCm7GW3siyLCWYDZuBmgsB/oJ
         SDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786926518; x=1787531318;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZazXSOY/m3892DihJiOWbg+m06h3GKDSJedsq/1CQg=;
        b=KvmmBH3MQ+83UQM0dFvd8b+QQ6OwFKv7NqieVDLOAPc9PmuOYOsAF0irSRzfNuNoIQ
         ZKIWkn9GlTbg9MM0SdyzAx+Xmb5Z4zPQTAlSZkTjAOuvwL99HeSJ9YwhQuL5d0Do+m5M
         ajK0S2otaBZDWURkmGqYLyMQjrvGaRClcalWeZkudIM03Tb+DZpICRSqIqdfK3mXqZ2T
         NFoRiOYLYyJww0onlT4gow1XzqO0tMdU6CftfQ9tk84az4SDNtHb0nTKOpsEFHxus3uC
         aDv9aVuTvfpr/gO2Z3z2POG3aMr0WMAOPG/821Fte55c5NxW4sH1KntAfNKJV0w09ovq
         tRiQ==
X-Forwarded-Encrypted: i=1; AHgh+RqRvgD1FUNbQ1w0wmRqsjXsfobWOGDNzb+GhX3TE/+Ib1IfQwqGaw6sCNNpQRkY46AtDtdtr6GLMQ==@kvack.org
X-Gm-Message-State: AOJu0YzwnHRm0U7/HxsggERwty3yDd9iS0CgmkLqH/zGt5yQ3+ia7BBJ
	tZDtUYzH8qLcN5uL17WvsF2DRUDSF7k83N1xZeGAnrdT8fZhVjjNPt1PgyGQrg/FT1/gsM1YGGq
	k6o+LFcMokhfrvcXz31aMGyJJoYaTYxgTUHW29DR/
X-Gm-Gg: AR+sD12MR+VUvpLVBmL7D9AZ8xNGMiqtCkLXJLAo0HqZbY93wx3KL0UhJ7uhQgGUcvH
	4nSP5rNlSmr9hquFiQMy258PI7uI2U8o+rzH2r+efshgSFZjbwU5AFJFj9zDeadNHk1rGPeygun
	rziltx4btAVjBJ8rAXEJksk3sgnOzL0haHJVt+y7lp5WhWTQi4YrEEzNRxMBQ5nlyEr05p+IE8m
	KYalAWcM90X1mEMEKfn4pIL3tEGJ8I9mCybaYqSnpGLZST8nC8EJP3/Y6w0YYX+8/HwZuXj6MK/
	D+7gi9TsCh7BZytA+dQehmnLRweC+y1n6rOz94tfqccR0uG899uR+XQM0py76na67vQ5ewWlgKU
	g3Q==
X-Received: by 2002:a05:600c:1503:b0:495:4593:616c with SMTP id
 5b1f17b1804b1-4999a6b0fe0mr162475e9.1.1786926518144; Sun, 16 Aug 2026
 17:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-2-jiaqiyan@google.com>
 <amQzjkVKYBw4vf9t@casper.infradead.org>
In-Reply-To: <amQzjkVKYBw4vf9t@casper.infradead.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 16 Aug 2026 17:28:26 -0700
X-Gm-Features: AcwNN1XpGbgQz8bGoR7DDrOWrywZCAg1FhBgjyflbj2DRcYwsYwobW8fTYEg2Ks
Message-ID: <CACw3F50W=YsdrgamCTy5WUVwTYJ7a5HX6MBhQCnNoOkySLi2YQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm/page_alloc: introduce __free_prepared_contig_range()
 with fpi_t
To: Matthew Wilcox <willy@infradead.org>
Cc: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org, 
	osalvador@kernel.org, harry.yoo@oracle.com, osalvador@suse.de, 
	jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
	david@kernel.org, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x8w5rz7nfgzbietnq8a1yapyh3e7z8mi
X-Rspamd-Queue-Id: EE9DE40004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786926519-469767
X-HE-Meta: U2FsdGVkX18HTq2pcn2VDZVu34Hz9kn+tljiwPHw7Dwk1v4NwoXWiZ0G8cp12cvKEAuAVt6sgHkldeKbh3umGGZmlE/Gm8PruQv692ffIBas9GxnXMLRkJJhvObEVPTtGWtKqC22tYowOLbkutAFXbgj3EgTFq9tm7SMd6KJ7Q0qdfHbRGdTbxZucMkJEB/u1GyJ+Huf+ObkLiEqZ0zSTHIrf9e4nC0B6BjX/yx/1UfkhImnVC9uGibr4MHD1ce4cGCovmQ5cepSVMJV7DyXKIdEIrsyFhpug4t5yAiyGb5TAXJC9SNKuscFJdgFU2t/pCoF2J8RYhqdrIqNml2esFmd4O1HjsXLuIrV5Qe1n1Q2x4B2FKt/K8/XyJFTDeXqjGvUSMPMTgTmt8glXhYrMsJJ+9LetHTKLL3yKmAbCV0ihz0C2p/jsbP1hnN4mhxKJPuF43x7W/KPUvyINljV8LwcW1kwWCF0vlLcQGMVcTDAuvGVULiTH2yJHoZ2w2KXgWothSX3cLPjcnD6JgVRCLtLvhXbpOImRp8STWLwCow3/6G34a4rSiW/7cdfQDhPtgRfvOxaeBLhSvxNdPxJYf8I5vTRz1eCiSlhTn/fBWfhMBO2q2v1IVtz1UJRMBRrn0tt+ACfnWyfaDAz+BCWQGWJmwf9pqjAERtoyJlPirCnRg0nhiQDU99mMXm6IgYxbFHiy+JhOuv1ELvkJUSA79Do1q0t/2RaRliH0UGzP5KN6p8byJyFXPpL97bd4xUvr1tPAe/2OQE+09jMPiyV1rJyWxK3qBW76ISNTX1j7Gf9lVZlSQy6ik1GOfNDSlyZ5LZ/glMHqK/X3UmhXxbRzECP9GZEBVZTFeUn91CzDg4sh0q2js9BDfpvXITaJQRzjvr0KBc7LwH3doH6bZtV5dY997Kd8fUIkc4YcuXcbxxzQUYQAxYQ+2ypnfdsbi4ew3pjoxd1zq7jic296//
 rs+q8xPb
 S7O8mW2iP3JKcrZVGK5qJ4r4OPoL0189LofTcrAOxDXwk4msXWcaxel/4nAwl1iA8mCi6z0fIiUz3Dxfe7YtujrbThfRq/WGI6LrUiYA2WoL7c6Jh8XiP8MgyfNMGKmle9eZ5Qa4JrtPvaCRcELgMyoVZWjE8mU+WS78lxGZN9FswAoUMPKa6+4XxjS25Iz3GhD67gfGVmjUzr+JAe/SQmfv3YLye8Us0IP1bxpvZGQDNSlucWwAT+C2xzcnq6HQxlzo05OlWYmXf4wrE3/1NdHCRn9Ofbcnwqx3FjP9+ykWOhMsc5ih68K4X9eWxvLWJhhGTsHBdaz+9AEMX0k1bxCGDb7NkOwHM03PqhJObzLEcnq1NqIPk4gJZpwidwaUOKZGHt+KwszUH+lzPeEH48h6vtR9LOkGdRBuexwYN1tJSJLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 8:55=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sun, Jul 05, 2026 at 06:07:10PM +0000, Jiaqi Yan wrote:
> > Rename the core logic to __free_prepared_contig_range() to accept
> > an fpi_t argument. It bitwise ORs with the required FPI_PREPARED
> > flag.
>
> There are only three callers of free_prepared_contig_range(), all
> in the same function.  It would seem like less effort to just
> modify free_prepared_contig_range() to take an fpi_t than
> introduce this wrapper.

Sure, I can merge __free_prepared_contig_range() into
free_prepared_contig_range() and just update the callers to pass
FPI_NONE.

