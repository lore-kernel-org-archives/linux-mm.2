Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E57D49225
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 13:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856116B0005; Fri, 12 Dec 2025 08:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DF26B0006; Fri, 12 Dec 2025 08:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CE26B0007; Fri, 12 Dec 2025 08:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605B56B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:02:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED90DC0152
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:02:48 +0000 (UTC)
X-FDA: 84210833616.05.A71D104
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id F29D020004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:02:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QbXvNBKi;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765544567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+rorvaCpkrXjldTveJt4G+UEEpEjCpbPUS2YfhhEgE=;
	b=xDA+dw0WVs1Bwjnkfe7xxB6hkgConcBLuZQQQfKNO7kzlgcbm3EppA3CG6EX/4kxWTZTPt
	Mpszo0jG6eylRHscA9FUIJHLglfL9bawTiNJ7Enphfyfzrbz/R2WYJC/DkoeSqRE4v5gEh
	Rx9gn1W8N5doItfwa6l/maT5zJZDA0c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QbXvNBKi;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765544567; a=rsa-sha256;
	cv=none;
	b=Y1487Qz9xoAZ5+UyYWfpAdYLBHxWDxnzRMOkbGymqVj3neZa4ukstV6XlPfbxrpodkHzHc
	0Y8UUy6UOIsFRtLCOWfkgjgHAZuj2DsnO/PRxkzgQkyeZBLPssEzH+4KLw6bf9NNdIimZh
	sSOZAet4ZZWOpAO+xY5Rif3Re3wliwY=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-477563e28a3so9330595e9.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765544565; x=1766149365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+rorvaCpkrXjldTveJt4G+UEEpEjCpbPUS2YfhhEgE=;
        b=QbXvNBKiufCOvPxDeI5Vlu9+F5BiZRrW39YxB2oweGH/cHLl1r4RhpgnKwcid1vjfE
         hqQ6bA9Z29LWHe9DFmJlzSXLjd7cRjtFc6OUfCJ1pbVc3xriP8cqUjr4EGw16cHE0Ojg
         OQFdSG7iTeX6SuW4DtlNi8g47L5RIDvPbb18MGS8c7yMrV2dPoSb/m3JSiQr2tQ+U33R
         j2fvnor4XEDyW/AwPCCL3KEHHWZ07kP/2VzyCEtEdnVpQB5hxSkTMojTHggz8o0yO05G
         ASbP3ZMYk+DRAofRtKLDqL8L3kGug1yvI7/LjFcDLgznu9djFrHBDiTiQfTNw34gi+eZ
         NbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765544565; x=1766149365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c+rorvaCpkrXjldTveJt4G+UEEpEjCpbPUS2YfhhEgE=;
        b=eVC9Y5emqqsOWdb0LHzO23WfB1UZ1Vg3EmCzK3biZJgngYf+Ep92a9mJZGyK61GKFN
         nfdh8GY31iq2b4Rc607W2Rl4uk3oc6+MeJFOQ/4mDS/p0PKT1iHV2xT3W5DTx8sPYBWW
         XNcniIgWFTUz30IbE7FCPt7YTR8vc8y5F0LReydskLEIov1K1DTVw3si6cQRK4cuAkkJ
         JtHoGrKhGJWbGV/Vw6ZYv10FNNdvrp43ABl8JQmywU0rUaMDxYxFOyXmTcY3SoFWwY3H
         Nkt4GUnswf1+NA+tV3PzBawN+/UN23wIFybQ6KNIicWcZw2U0oVcI+DO1b8ScNAl3MJP
         HVGg==
X-Forwarded-Encrypted: i=1; AJvYcCVWex6AgpgluRFNun0KPCibYdT0lrHfVHgsuFL/tI/nRChO3xpSTQkYIMuLURQterIerjCT9LUl/A==@kvack.org
X-Gm-Message-State: AOJu0YzdPLXIBh53wrMLqCaA/6kBdELrcpgo/ecNnPML6mt56hxmZaDc
	wQRjLdw6ZzjgymShomIipyagEgQcAUinycGqixOMw4O6lRroEYkIgXnt
X-Gm-Gg: AY/fxX5zwyNl9v77jCYzDm+vG9j2fW5owUGW8MWVjYlKQSRjfKHC/u0t32yG6gfKacQ
	jjZyybMF5HsMthZiOb4cLXNrZ99X9MBbJ3jQbjT/9NWsQO/L4hkl6bRcfKDTVlnyZiLhA2cLrjc
	jWjJIpmdGOl85oC+5ryOQ9IqgQOibC3CqYDVhRWGrTH/SUOcW8DeoYM5V75RusRBPRMh0Zja2Sp
	UM1bZ/rwRiOw+SUo95nStwGmCnL5xm/o6xqCuvzrK36pjXK5n1ncEyfL/RVUzNiz7L5OUcL08zu
	T/GZ9te18kHXGQFdwvYKtFCMnAG3n9BwB3Ox0Aei2AjCWuRCBgc0u4cX+/P941eO7dCvbWR+luG
	Lyl7mqBG9m3ib38u13Sj4h0Lnlrp4tgglaR+BwPIROYKVZifdiVTgrIvvKVEhVuaN6klguRLSI2
	IHCu3I5Gkktf7CzzTP+/raA2pBnwvudDbC0fdVxR+O02sLVmPNS3w4cNy3ynRHjoA=
X-Google-Smtp-Source: AGHT+IGPkpidwmTBkjM2H92tIpLg2lbV7W/zkC+iA9hYvJ7UaBJBAEgFvqpcFgTWUMsdXPM9OkkCIQ==
X-Received: by 2002:a05:600c:4e91:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-47a8f2c2f62mr21854405e9.13.1765544565230;
        Fri, 12 Dec 2025 05:02:45 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f70509bsm11976135e9.6.2025.12.12.05.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 05:02:44 -0800 (PST)
Date: Fri, 12 Dec 2025 13:02:43 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 oliver.sang@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251212130243.03538bc3@pumpkin>
In-Reply-To: <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205184342.2cfcc73e@pumpkin>
	<4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
	<20251205213449.12bf4819@pumpkin>
	<d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
	<e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
	<7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
	<ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
	<CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F29D020004
X-Stat-Signature: qzixe8idrpxeho5zsqepjg7uid3mxyt8
X-HE-Tag: 1765544566-894594
X-HE-Meta: U2FsdGVkX19Nyk5b+g336pK6bLU8OQSV1v2yJPzgV9K63cBFYqeTmXQ3Qn/cbF3ItUNQvAQ+czi3Zi3M1ZOVRH7TpVi77oJ0iAUuxAuiWHGHSrKvpznvhQ0GNt+wf2e70Exw+IdqVMJnpQChBfHYpFAEcB/ytMK4J+r2GjVgzLrHX1Sv18nRUuFe7J6HIC30Eywdp+MyLOl7GrHfyC8PGjzRD4PlWrKFyxC5PU0KLPBMpEHaFD2zAv/eJEReWTgq+B7nGHUU3Detc0xH2a7/FX09XkSWpDpSXgbLA5l2+jiHibAdrmWdwRhIJ4PV7y6WxPs6jE5VxNso3f0i2tYcG2wbpumeHK99YXCkg7dmz9/nFi5LxVvOVPhTwxChGhl0mb/LDpL/sbGleNTmCJHz0S6knzyUjLDyig8jRs3KNKQ/YWXWULEEt8nzruqAKI+KrOz5U7Y4cS177O0mj/tkdQaZFVuRaCeebnOpt1GW2OAX1uM0bfkj5jnMiNoyljDM7od+gAwZu3+wgS5Cmdj8CnJWWu0XuWyoeu4P5EUlJaKgoxeVshrEizIFaBj/J2AtQQzIpQ/XI4WchSav3FWIrpmqdCeZSic+3jdCzwzUy2lct8NSz8uHOj4++4tJnfr1pdUWF1JuKxpARK7S0MKNB2pM1vK63VYxLLyf60wmNZvU7Qjcz0sfpUAbAEfAJ2P0ajUi6fskQuJ76lr0MArE5+YLi67qa8X2PtUQ2M5KEzjXHO40RvwEihtfkUeqBdf3oDJzGmNHPUG/YucflXrekyAP0gzjtlIo5slz9/Ctvi1kTlVNFGUsGHfAGO18H+97SugOCLLh5ISony+Mu559DuGCJQ2Qz7rqE1gcoRY8VZWHeLZRlFRd6HpVyL26r0FbBnJlsqcrPlzIoJsQdkkpHiRhMFJVoKdyfuggn5eEaFZxsfDKAs53o+UYKa+jJXXeJPNxv6esicw2u4TBHkf
 lNWlngSU
 EC3O7ysEPlqvmDh9mJSOs9TDoCdHZOyM8iVFIYoHq1vHa63WgeAyZtEtud3u1b35nJKYroEJYjkodLfbFbdZ24N7fZwwrONv3Oha1bQOWOhJrEwS6mwvkXKD87jVUFHOzDXWZhyZn2aaj9/tvnpXUo/2ipYB0KgseZIZlm+Enhhz33Gr7y14HLquWc/6GG7LtZjrwGY5tYz2J0jwMBuGD0mKE5wxxO0xI8OX82TcW5Fu8uMPLv9DWvMlL3PuE3+wmrErt3SythPDbC/9uL3PHQLy+tILiEmVz8YVGQdZLc74SIDoHDyljXxsy1fjexcN6lof9Gj0u+O8BWJ+C1rGSsyX5+3x1zZHKkSaUA5LRHc3ykXO6+IwKeKk+XXoTgrv8b7ab7f0yNo7SDpZtnJQOk6+6CCm5BK+2/0Glv0bnDQe+odfQY3ZhMreBlQ6G5btsO9UYQSBfsqFQtpBQSeQTQSJ3U1anoVzZ6kUbnHXeoKMDpE9fL32VaFYuwQcmFGNWYDNvRVS1SMO0ZOf/Xxqq7JfW5kbzq330wkI9jzoxBHR69HypbiFylvmbHMzyYt2z3KwnqLUFNRs/keFTf5TulzDiSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 13:24:57 +0100
Mateusz Guzik <mjguzik@gmail.com> wrote:

> So I had a look where the timing difference is coming from and I think
> I have the answer: init_ipc_ns does not have a guaranteed cacheline
> placement and things get moved around with the patch.
> 
> On my kernels (nm vmlinux-newbits | sort -nk 1 | less)
> 
> before:
> ffffffff839ffb60 T init_ipc_ns
> ffffffff83a00020 t event_exit__msgrcv
> 
> after:
> ffffffff839ffbc0 T init_ipc_ns
> ffffffff83a00080 t event_exit__msgrcv
> 
> This is the pervasive problem of vars from all .o files placed
> adjacent to each other, meaning changes in one .o file result in
> offsets changing in other files and then you get performance
> fluctuations as not-explicitly-padded variables share (or no longer
> share) cachelines.

Those look like text symbols, not data ones.
But moving code about can make the same sort of changes.

> I brought this up a year ago elsewhere:
> https://gcc.gnu.org/pipermail/gcc/2024-October/245004.html

My guess is that all the extra padding increases the cache footprint
of the code and that causes other cache lines to displaced and then
needing to be re-read from memory.
So while a specific benchmark may improve, overall system performance
goes down.

Excessive loop unrolling has the same effect.

	David

> 
> maybe i should pick it up again and see it through
> 
> as for the thing at hand, someone(tm) will want to make sure the
> namespace is cacheline aligned and possibly pad its own internals
> afterwards. Personally I can't be bothered.


