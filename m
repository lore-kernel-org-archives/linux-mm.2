Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4129FCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CE56B0095; Tue, 23 Jun 2026 04:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DBF6B0096; Tue, 23 Jun 2026 04:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67A46B0098; Tue, 23 Jun 2026 04:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC96D6B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:44:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4587A1C4F39
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:26 +0000 (UTC)
X-FDA: 84910540932.18.E75C645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F2E2140007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DK6H1+he;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204264;
	b=tl5x3mT0jivUK6YdSlNXRkgpg8u4jmYJ7LWT/IxKSOFHikYPNqBfi6EjCk9A8cX+d0aAy1
	IlePCR5s6JP4Hu8BYfvJVvsQtEzyXoQzYb67Bh0ZAJMgvfXXB1kn9+rND6GR7XO4jnmnye
	84pZSKbad2mqO++Gr7w5SCPqIyBfdtg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V06gLYpVPdQObMIALtn+nG4jTG6QOLPlsd9Xveo2TGg=;
	b=W5c3GOdynlfEf0zmmohlu+xnxY2GPazSRkAo7RDAsfQOj5t28tWSUvUM5W6LYrIb2enoxC
	Mexc9pwvuJN5z6PuuWRN+ze5tUVH6eGZM4MXmg0jeKJlr+o870ApT3gOpoDMLSfSMOOK63
	PqnXIwB7Y5gTQ6ctYvMDnvAYVvu57xo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DK6H1+he;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 998C744381
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF341F0155D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782204263;
	bh=V06gLYpVPdQObMIALtn+nG4jTG6QOLPlsd9Xveo2TGg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DK6H1+heID3E/pUR/HqL+kQG1FPd45HfBcYd+muM2fJpu/+jWR89tId3qlRYdHPSD
	 aNYIr7BkYtkOg4usQA/eB7gk55ahHoY4xPYBPEoBUCa76knDgqG1x/uGh8K7QofxDS
	 3Wy2xUE5CL14PLsJOmxRfB3kYPGSyUSFJCpvgoB1zK4yKDvKVop7K2YFseKTuaYx/H
	 DpS13fO5wVpuw9VVCWi0mtgUmtx3ELIOvc8nCAixaboIdGT+s5fk73AEkO/Ib7Qc2j
	 mLVAaTTPHhpiQqKDnG4J9n0xrTOsr9CmprfWo2VT/HcKMq0Y6eFdzLcx8WQTSb/yWb
	 eDQiRZ98Wl1Yw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8dc87f7d68bso61663856d6.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:44:23 -0700 (PDT)
X-Gm-Message-State: AOJu0YyzT5RC5SmIrN2/C465S/6/l/aj04G51bQGMG/sYRQeEcgUa4Re
	FFCcUMM+vx1TNP9BSuEqghdKLKOgA4oLf8oNWF6DF3HSoCVI3HPPQiScjN5XmGRLwk+5x8JRCO3
	DKwKBKypC3496xAbH2R9X//JH0+gdSDg=
X-Received: by 2002:a05:620a:2813:b0:915:b852:4361 with SMTP id
 af79cd13be357-9208f92f166mr2327832385a.20.1782204262908; Tue, 23 Jun 2026
 01:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com>
In-Reply-To: <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 16:44:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xf4FoYAzGwf1w6hT2RKA0Vjr_yY2LHGzke_cP4VQh_9g@mail.gmail.com>
X-Gm-Features: AVVi8CcGK9RQyTQe6B_OzPqxpd__RZ0H_vwxCCpKUZk2XxYWrFfWHfgF1qK0Drc
Message-ID: <CAGsJ_4xf4FoYAzGwf1w6hT2RKA0Vjr_yY2LHGzke_cP4VQh_9g@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F2E2140007
X-Stat-Signature: w6xpytwjf8fo3s7jns171zpdrx5rsukc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782204264-623448
X-HE-Meta: U2FsdGVkX19T59RINRQivd/KP/6auKkaFYJ3iVGWAD/YavW5kAZi4jVqd5JTO+YRYAZkX/OSKzQoVRHpEbwX/M0yZ+eUCJCNOanitOyNxGxHqqJVuHxcyAJG2GWavpej8Xif52Lak6xQD0K+pF+jRxB6/k3wGlawt+WCeznDMaf7ke46/F9Ud/0zY4WuBHgp+p3RGbh4gGRY2F5S30MW3A991+P+nt3euaCm1irMbEUVXO2BXgkTmGC9jlFSePWyLHRfrIG2jXhkldzcJRPwzQUBjUd8Jh6nuN82wdTLDkueSTo8X5gp2rfb2s6opu0QFlZpACvty6DleOIHzyiTfMNkcEN/xCxybI3K3dsHGJvYrVcr3bMnwoaPV9gGXc7kxJOyKfhF/Yn4Fw1jeaFC1vWWvIJYPlnd6EX2Tv2C30YQBVeVWLW1a9DgxY9mlvPQLm5oJfl+Fvy0JSMHtL+Gk+pPgkBxn4UUO+Pxr8GdAcfDnTmhp6D+V3G/wZTe4Nr+7w5vxhsKfFrUtrWj3hE4YbCJResofklPvot/clnhVXbTW2PzEpLYbayN/NhxHsZUUGdj6XBdrrKOZhLgAYn+f1sacrWo6/2GVnom+TVzjbLDmVZNChi+TgMHWUWSYUJrpyqqF2I3QoKef9BCLs/znjLA24gQDDczTbQi8/P22/XzU9Zg2OUMWO2her1inbnUW2otLxxN6XBCSiE154lno2MLtehS8PeNLbOzVs5BY2oSBPf8VcrYxlHGF8T5/jBWXhDizmxhoScEbyqychVXL9LdIS3KPopcRYq41SgzJbaI/yp90f5k0lzCuf8SLqliy6U3qitUCjw6fVk7j57P81MOMEspsZJXts0CX5C8H95CS8rFQj3Vf+b95aO3nZsp/bcxatHEqc2ahfTciO8bp46g+mZv0Ah7mu115ATLWrz3jQna+JOwWT72ip9iL+wC8CLPfYMmdFyiGzfZAeq
 PneoZKgt
 03t8K8EKW8Jbyx5gmgmvqlq7aimIQr14rLRnHzYMdXm85ZkBgWCm29CX+CjwydNLpSX2bR/fdztBO/pEYlWPGGRtTYRPNG3QvRkkVpk96FZTna3zELE/bbpV37O0qvDuE82yvrInxO3Nz2fjXozHdjn3MeSeS1E8pnJPChUwc4fMUPr2W2jmIpPiIJ2oD26iq8hcfP1QKYSiyA9gC3EIVafeazksKSNLLqunKZPoY1TPz6cvTzy6VoWdNFNVv0Gzn1QY0N8D+Dl9g9xY/QPZfewjk5aDbpjEJ75838KjlXfh6Zg7gnZIGwKaPM/i8SJgZbDvXe0p45EZ84Q7hO+5Q3M9/jZJQTxqAFnG19+3RuqjZoo1xAGmnPb4b5jyuKvVTF5LPgcb+YcwNYtjqg7k5Y2t914ebzINjGGzYMbqnYEvGVog3CDixMsibJOMr6jh10bFwTB0aC4NrxHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> On PowerPC Book3S64, MMU is selected at runtime, so macros like
> PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
> swap code uses these macros to size some of its array data structures
> based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
> purpose.
> Hence this patch makes the users of SWAPFILE_CLUSTER to use this macro va=
lue at
> runtime and also modifies swap_table and swap_memcg_table which were earl=
ier
> using this macro for defining the number of table entries.
>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

