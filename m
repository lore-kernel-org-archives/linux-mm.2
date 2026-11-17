Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C53606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G7+BydlQ
Received: by kanga.kvack.org (Postfix)
	id 5EDC46B05B5; Tue, 17 Nov 2026 05:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DA56B05B8; Tue, 17 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D646B05BB; Tue, 17 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241846B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:02:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B20921603A6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:02:23 +0000 (UTC)
X-FDA: 85444170966.05.6BC2F97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C577B1C000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:02:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G7+BydlQ;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLK3zzOfhn1NufegKdCfvj6yMMyKmfBzXnjhXdQX99w=;
	b=iYRaQptFNmNzRMWzZ/VIMp/uIS/D75iyI4MIXq0W+h5oGfNKrNpL3E+JznNm+lg4fbuYC2
	ozbQQXgls8kKtTxr02YV1AIy+VjXCNNKuQlRZw7olN7lH6qExWirpWUS7QEGhZRGHtnwXg
	5KAX4A79azqebr16d/102Wx6jwt7wkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909741;
	b=1Ls1CU5ODgBUGUGHmZwQCVh7MmUm7tsM2BFZfGOcVMLfQLYiMGdil6eG6crb/5jTePeoG6
	aitrB1uE+uUeGqoraK7RJLj2OfwZ/iihXf4XJx3qP/N+Hzq/tyeVFNtcBB60fHdMdQwCas
	ow8+CmNt2Rypxs00mnjTL2x9/hwvsd0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G7+BydlQ;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05F6045A66
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5B61F000CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909740;
	bh=cLK3zzOfhn1NufegKdCfvj6yMMyKmfBzXnjhXdQX99w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G7+BydlQPSnynYkWinkxFM4YfGrecHX+svjDGOyD/KYsHRDXWX/yW470mlX45a2e8
	 EE93m/32G0w9nLRAOVet/9y1i/ogbpDK5FRRKre+YrcjvP1qAC3IvVUcMnr2FiobYx
	 ij8CeEiC49pZiNZOx66/cQrmdXKkxYzaplG4VWIxG5jUVBw88jljyvZ/YIhNAJDYH5
	 IlJ5BEKxfO1Jvd28VDvYv93KeLWZx30GRHIEefT8QPBE09bRD0/yceHtcGMQirLLEL
	 ENwfOMnzi1o67W+f7ssd7iyx6OhzdN24bGQ9tlTbTATSGYpdFUWj+BxIdpnN2RaqsS
	 Y9SJ9BmfObtAQ==
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eafb65e169so3559381e0c.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFKyl7v6dm+6TyIvrEXloHUova1QDvM7LA7VP0s4vM9WCNJ3pxvIfnryL+G2QRjS/bTqXI4SkaLWQ==@kvack.org
X-Gm-Message-State: APuU4Z/CM7onxMiK8lT8JsH+GDbAuPOiZHdYlb2Eoo2HsSAKm4vPlBU1
	tdc981G4FbPz07XpcqycfcN+gZnOMRGAn13Vns5XIIUjyH1mjMPtjkJ3XbIxKTaA7T4PNmIWq3N
	mJlkA8aOT/AEh6mYojbV6mWz88eunXEg=
X-Received: by 2002:a05:6122:8483:b0:5ee:3f2e:714c with SMTP id
 71dfb90a1353d-5ee3f2e76b1mr2651586e0c.4.1794909740230; Tue, 17 Nov 2026
 02:02:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-2-2f845e94dd50@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 18:02:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4whmBuTeoEtKzfdYKXaBp-9Ph7+Oj6xCFUWY8en+p-q7Q@mail.gmail.com>
X-Gm-Features: Aa3M54ozWLhKg1KFQokUO3ZjKoGTiLL_NX7NP3uVe-gz0Ybf495Q6LaRkAtem0E
Message-ID: <CAGsJ_4whmBuTeoEtKzfdYKXaBp-9Ph7+Oj6xCFUWY8en+p-q7Q@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 2/5] mm/swapops: remove unused make_guard_swp_entry()
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4hrx37qtjwr688bgdp9jtzmtrggik3mp
X-Rspam-User: 
X-Rspamd-Queue-Id: C577B1C000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794909741-565878
X-HE-Meta: U2FsdGVkX19JCNeyCltqGld1he9reF8lP8H1N6VwPk3hOINQDI2/k7GmHOBO/Mq/7axHS9Pd5kOsET6D4ALxwdZgmz+v00epNjDv6AIrNroToRz2pFGj9Th8AhzVk+GsPj0dBz4qUbojyD7mSLkgzz74Ih6nKqnDtRAr5Kl/08A7nHi70DKJFQlYLWqkUEWDHa/WsTlTP2iyasQuTkQ71CYsus2p6UeVQe3O5BOrLbXOdqyNnAFMrRoMp1ZmBGikYcJ3aGau0hh/oOMt6yPzxo3atn44RSdAdw/q1/AHEYQijS/tXTrhd3Df3cz0vEaXpTiNkEeedfXhbKHfQbCnbp/UKACPL79cflLY3fXrCpsL6gQ/CCPsj693EQ381frE5z6m3AI7+0PX2t+4kiUGgGqN2H33JQop+Zt0ubEW9tpzMML19+LDGvJ9I20WTnPXqfcGgpWMQyKSsBdOdW4DbgMgKZcUanxp6dUJq+lpfstbDYV2+d9MrJ2qDVs9O+2OrC9H9cPpC70IMY9+mGCPB70uuskJPM+d9NAMycbdBtCXmSEDWzE8Fg+aUnRVwKXzn3ev4MyZdetspauisstK/GwujMugfrk8YlhsvsfN2OIhy+5/2vCZFgBNWJynd7Yy3GG8eOopzHngBgEFwumOKMeppGHKGbj7LgOCXbaU7RxAExNt9ZjGbsHRNTQl7GvSXAShs/GEgK/bvz4IrYsMq2dKJsLK/eSuDmefhiGVjn3ph6H74ovIMS+OEfQs8Zl+gNQMLV2MCaX3ycwYp//IjWJGyXgSW7a67aRzpSTGvUHOTsq0ehlwhweYnFe4oIuubasYroJQ/X1ulrYPWFfEpPx/Zo0pWpp9RZlRjH02roNDvIumnWln7WbvO2zxRb5VTrcSL8HMwxEcFaFI8ou+BIVVAivgHiMGUq5xnKJVAntKPummi2MahQNKb72j6uZ8oo3RlweeNa2s3NnVuom
 gS4+lOd/
 lIb4JUjq0Vy5ZoD9xcYeOn5i4fi5AWg6eKBWt6NJ6l73pJFAPLTcxRftMTdDOFyzYkhN1JbSWVgLbAMAdINPvCQ61ZbCqD1nN1uQQogEI0fjdMRn6GlObj1IAVwsX+zaoyPZjU7Jf30hNM62CXJFzxFEMtoZFfKnl0FCvVQbY/18iWbY3BmOxRaCuV4S84YYpG3ROorRNit+BHOv3snwsVnxUw4QXTaP91SHPEVKGeLMFjqVWFAkJBjO4lpGwOgBuiEd2KZ1Oz4hbCc2W4Vpf1JE9UabpClU7sDSVYM3dUOIPVTMiBHvGstZqScHXNpto0UsT9Wzn96lJASZA5s0PmAoUlh5x8G6Afda0moeWyB2QJP5CPMQ7LarwVAIrycU1MsSJCJlFT0VbY4vmE5eWprjfBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 3:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wro=
te:
>
> make_guard_swp_entry() has no callers.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/swapops.h | 5 -----
>  1 file changed, 5 deletions(-)
>

Reviewed-by: Barry Song <baohua@kernel.org>

