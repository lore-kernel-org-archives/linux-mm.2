Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE2FCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DA58E0026; Mon, 15 Sep 2025 11:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DDC8E0001; Mon, 15 Sep 2025 11:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CE08E0026; Mon, 15 Sep 2025 11:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3E48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:13:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30D751DF687
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:13:21 +0000 (UTC)
X-FDA: 83891828202.06.22F09E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 362ED40012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:13:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhwZwxtF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757949199; a=rsa-sha256;
	cv=none;
	b=uKqPdoHBY+I55vBNXqapf+4uMbN2keLLfUI2fYIPTJv285ALLoaLaNqEtA0sSza4eNF3/W
	lr5gY+0IJZaJ11kkFvxWpf410xafcOA9hFZl7x/lh1bObATYbte/CDTxMer/XMvkBwBrmX
	82RcNN01+Q49ILVVm4fAgsawNbIEWvs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhwZwxtF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757949199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tqspy+zxghoH9AEqLBR01JK/+sGxvV8Fm2AfYajFYQ=;
	b=i8D4vudcN1Xj1i2Rrqg3Fb2cL5p/RzrQWZsBL7buFZBUsY2MaiefItXlILaFpOHg9s9/rU
	nRniq8Xsx6//r8RQE1eq8SZF6DqRAutYo2dE9xMk6Tg5XDcBMF864kYVCnVLw4YfyTIFFu
	IK/vrD9ril6exwwOINzuZ2Wcs8CRKdQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D42E6024D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2654CC4CEF7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757949198;
	bh=4tqspy+zxghoH9AEqLBR01JK/+sGxvV8Fm2AfYajFYQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qhwZwxtFG99I4HuOc9/gir08cjNWDb5oWB5n8BfWmHfWXZrzV1vK1SWMQFySAP6s8
	 pMQgsu/XE0yoH6vOiQ0fFdFJQoWAI17kT0etc7lDFCc91ie5QP1UYaMBffcZNkVe6+
	 FGz+ukjaOnXE9q0+QNxmJRt3CVSFk4E4MGJpeYJWeThU/5/0yZj/SEj513qXintgki
	 bCMNszemlohpo0C8SrZBWK08VSkRMLD4N7QjPduKVoMLYBgxdebXEWGFMeYBJaK4fj
	 mYDiqDhAzPlMXpwfF1ydo9RDcidpsFYQbcBVyFOx9hp0CAx7a2l3b9HybiAwgJMm0w
	 zQoz0zDBxf7LQ==
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45f2fa8a1adso6547595e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:13:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWVy1RbnLLEvEiHJ7avbigIznVQGYN/BAapyLhN0F3G6Ju5lIFcihXVACEvGASMqEtgDPg7wfNmsA==@kvack.org
X-Gm-Message-State: AOJu0Yy6fR4SiJ37ejKI7oitP4LaI5ZsCVphww1I+6XjNbTp9Z3T3j+m
	vn7jzq2lWNqBvUIptl/a3zDrT+Y5W+J7ejAq4t1W1mDtpq1Pd0mmROKprQ7dqr2BHf0opZeTS21
	PqQlbqYay/sTkPURDTTt76YDn4ejeDc7LWc7p51xfdA==
X-Google-Smtp-Source: AGHT+IHqXikrKj3R1unfVF0Oom/4HxX10YUkGmaBfaJ/zLF4kX4I9Q4yKQIYPoL0/4ybR6mCzHug7iWwAVwTcqUPDWw=
X-Received: by 2002:adf:ed4f:0:b0:3eb:ad27:9802 with SMTP id
 ffacd0b85a97d-3ebad27a2cdmr1518888f8f.2.1757949196960; Mon, 15 Sep 2025
 08:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-10-ryncsn@gmail.com>
 <0cb2bc82-1957-4efe-8c85-8558743dcf80@linux.alibaba.com> <CAMgjq7Bc6r2=BcAPCeVPcVJ_hP8bXTs_pya2fWg8ZL-vTG9SAg@mail.gmail.com>
In-Reply-To: <CAMgjq7Bc6r2=BcAPCeVPcVJ_hP8bXTs_pya2fWg8ZL-vTG9SAg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 15 Sep 2025 08:13:05 -0700
X-Gmail-Original-Message-ID: <CACePvbVLg_zL+m-w-qd=eAjbEBN+m2nx03SACudMKL1tWTrA6g@mail.gmail.com>
X-Gm-Features: AS18NWBRjhDOA6SChxr0CoCQ6NbdGNNklsW3v3PUACmNf72TDbUOcGxjudg9H_8
Message-ID: <CACePvbVLg_zL+m-w-qd=eAjbEBN+m2nx03SACudMKL1tWTrA6g@mail.gmail.com>
Subject: Re: [PATCH v3 09/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 362ED40012
X-Stat-Signature: qk1aii5prp3qt8jihkup1w4o45poh96b
X-Rspam-User: 
X-HE-Tag: 1757949199-27714
X-HE-Meta: U2FsdGVkX18JjeGJwoRAdztFg2G4FKtxzbX1NM2Jd92xE7KXOLpyvvQWQnEE5eYI4m0fMK9mocEl7FLGAsmKkLFbP6owW6oN9rG4poYGMb92KIv7aYk5fQlQpYTFdBVkLLa5uukORSri+l0K+OTnb36v0vXGLfsN0cb/WSBTvIx9NDoc9kfBrPF0zv8ZNMWcmFcPvP/67d98qeMMSwt+131Kb/7qAEelbkv5DpNINTCSSWtemrXR4TU5UHeddr/nwjTJPuX3LFR1nXAkCyIQ0sAXWKwoJ+PbDdya7geG/wV9Py3WH4RcQNw/OQ6hHxKjXTqwc5OT72lHXT4tajrfbs2qTEcnGLLtD3yogndMG/fKa/9SVFgYyDtvKvoTO3FMpKicfKE8NG46Q7//beHuv5yhQ9L+uWcJn9N09DdH7+GcFM+pHNXyNhZbCPgrrXyhLeZ0HrLxJfuZ3HagcKdO3CxySRkQRRM5BRXQHDcLvv0DlfFEQOsJDA21yW4GLLheJylQEFz/kpzXGr6EJXFisAngHVt5A0fnGCpodRE+8XztieqKC4HxD3x87+VI4DTY4aei5t90S4P2nzJKXppHHVruybx/cXgsAz9UOWdSYsv17gxX+p9dvEdKm9A8xmzNiyrry1yO6fykJ8ZXRNCd50mPV0Edben+K8eoLUmrSMCE/7yZuvSLbOQ8ihZ5+uJYA0VFTtiYqHq5I00UgFB84yj5hZuPD/h7a4GSA2EqCxuIYm3FwEjQcUY5Kzs8Z1CPzUqsvHGmk2LrjUZliFiJd6xoON0jHjI7O0+7C9c9T7xnzpv82HrwfNS1WiZfG1oEIGAaRqH7uyDaQ6hzJ1BAf+HCPH9XuCDZaY1RdxAt41XvY9o6ATqDhx6q4/o9LavKMBHShP12PKptFT5bjcs191eT3iYDXkbMQzvm9dEFl/Dnvuy2iRSn+e3fZMrUlRt3XzksrtUr/jZzt78W9oV
 LZvPpYRx
 ubiQX39wIW6j281yIIxk6tPynj8xVDd3WwZarmocFlAWlXgtElluzx04eYZZNtZAK2ibENQzyEhW60YUPXAFuUCPXlxXZKx5uIfJGhyqqvz5pNzECqt1FG9vvvAuaEYoVtXSwKblmkZDdlVKXoMlzQvssWn/GxQ9EJjpNl0BesLh58nGpNDsj9vFmyVsM8p8j34mK3AWFLqZ4eNmb45xLOYp5lRyJOctOy/RkB4olxzZNNfdxoBSHLKwwRFKV4QRw2/5rbxbC5C78iYFHsvk//se/g9Vv+DsPL5UcQAAVEGhR6vE6Aj20UsT4eQz13qQxRhRIy4Z8jJFveXY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 5:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
> >
> > Again, there are still some issues with the patch split. The swapcache
> > related APIs replacement should be placed in Patch 8, otherwise there
> > will be buidling errors after applying Patch 8.
> >
> > With this issue fixed:
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >
>
> Hi Baolin
>
> Yeah you are right, I need to move these few changes to patch 8.
>
> BTW I also found that the WARN_ON and irq unlock needs following fix,
> the stats update need to be done with irq disabled:

I will skip this patch and wait for your new fixed patch then.

Chris

