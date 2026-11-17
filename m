Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05089606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FoixdnlM
Received: by kanga.kvack.org (Postfix)
	id 26CDC6B05BD; Tue, 17 Nov 2026 05:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DB56B05BE; Tue, 17 Nov 2026 05:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134706B05BF; Tue, 17 Nov 2026 05:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E29C26B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:03:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75C4CA036B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:44 +0000 (UTC)
X-FDA: 85444174368.21.A0BF9EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 988B01C0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoixdnlM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909822;
	b=TAwqvmuC9g1O88KmAdLNy4/jGj0teE3y7+VTTeZ4iqaaIJsV8Rk3aQDhm+M0WPgejCG8Vt
	tvy+NRV6q9JKtTeJhTLytxIscO9aCl5hmF+p7mgnZbiQpJQCzmJdl7ez1s8IGC0jlBNRfd
	+aHIvCigBE2F39gbRjxL8oPwCOB3nCM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FoixdnlM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4SJkbbryGX39GBfapc5j9+NJLpHzq2qrYadOREFzZ0=;
	b=qFWn70FybfA61roG4nWGImJ3meE4hYg2fvYmig/MGRlmStOUR23sXow/9x45z0gm49no4N
	ihd/QqxvcI5v6b/5MP9jPEascgogvcECDET7oxyS5e1lzuP5vABoya9jwhJL9emI5oWwDx
	dKB3STj9767JE/RcPByW1EgqMjALWnU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06319628E1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F3F1F000CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909821;
	bh=G4SJkbbryGX39GBfapc5j9+NJLpHzq2qrYadOREFzZ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FoixdnlM0ZDr7xmOe8IbRBHfnx4iTwawdza9bJR+U7S5uVnvt6/H4spWS3kMqQKGi
	 NfyTg4rxZayvCMUtsApRYHL2po5n8/eFKG/1Rtlh2105YgNEs43lGupcgSejLltmUj
	 r4z1caK75fCmr/z/52UDA2+FDgutzbCu3IkVtWIn5uczA0oDARLlDvD+rK/ZjjIyGj
	 k0cKzE42AY9wHL/p3taekgVhjyX30pXm5UYH0Rk4OL+YNt3VJyBhZHDLBlhSWJpR61
	 ILVZhLYlGQfqYkp3hisULgVRJnP5iIp3Afl4kNuFnrDJ5UPbEfxjz2dNLkmHsCzX8b
	 qVCq3hSYeK0mw==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eaaa9b1591so4709671e0c.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:03:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGXt7a2kyow9jME7o6g7A27yvl4QeCjmcrHltGjKTq9zO/uE4w9sW7QMWEq5+B58fpFtbIPH0+aag==@kvack.org
X-Gm-Message-State: APuU4Z9IDRmgDH/5h/miN1Pf4FzjxaX45TWY/herJb12TIqo7ciXOsf6
	47GmNYUvFUhy6/gup/QxPrUOnw40Q3cV7VUZ1HA9UnBk8gibTpxiyQEXvqHXYLT5b7oxv5nNvUK
	1jF6pg2BcbkAJ9XIoCuSKbKnh7eYFjUk=
X-Received: by 2002:a05:6122:3382:b0:5e9:176f:a548 with SMTP id
 71dfb90a1353d-5ee344ee205mr5276040e0c.0.1794909821090; Tue, 17 Nov 2026
 02:03:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 18:03:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xpXzdWxp_B2kNXZmKCfE_PcgTr5adkLG==jEZ7+y+ZDg@mail.gmail.com>
X-Gm-Features: Aa3M54oSKLyjB7hd6iK-xbU9SbU3gd8PIMBq2jzZeTHI_Fj_ONDhoTV0tNIHTEY
Message-ID: <CAGsJ_4xpXzdWxp_B2kNXZmKCfE_PcgTr5adkLG==jEZ7+y+ZDg@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 3/5] mm/swap: remove unused folio_to_swp_tb()
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
X-Stat-Signature: 8m8jii8pw9axb44xzafafg7psysscikk
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 988B01C0004
X-HE-Tag: 1794909822-115857
X-HE-Meta: U2FsdGVkX1/7BS+5/ZKs4HKokHxvr0+6TIe4ZKxsqSVvhHjA4zQkDIEyJ/31ex/SR7mR3G+tpHQporGMn/LPkq3jkt12N5qEOfjlybK//AOx2zT68E8ZzPZb6+CmA9/7kH54vnRwxGOeMRYyz081dpHR9eRzKE+PA9SEmZzhuB9uHoEHnvqVu0BLO+79TqDy087agmSXbVeMknMViJXf4PWjOCoyvIm9Z/yxUaDINgumojGUhi4FivgUSHh6oCSgF+AqQw8viUBtF1+WFHptxwLY21PXjoKQj4XlNieBjrXgNWQ7qTYXkuet9e8xgCrUHoqCdPGfKmq/wbD9eIdX62j9QTwmbM/HX3Yhp2PHeE6i8EHPHWXSY3cDAjqUwZomKNmDuZJKlFmK4kcPAoBt3AZcVUHAhj6mWpMPwec3IjIT5JcZfEkEfFv7NiWUH5TeNBsZh1tLMQE2GobR/MuY0q/Mt2CCmPAFVmTnJW9UHOgxlflWLqzMgW22VW1eRuwUSwcBtFNoIl+wiPwEvSnZUxG5sVvRnzEsiGB5TPTahdXXFEtZMgU8Y2z15Npp3TbNvpWPJwWEUa0dSFp3RrpZNFGauet20pxvJmUqJM3ihbsJmoCB12EwGohNKsgTp8a6vTZMqkl4pe1pX3MhaY0Ikj8VH8318KZs71QxidunQQFlhpvEcZGl7EVY0p2t0Gg12/giXsdKgNAynrlCDGCSsSF5cBTklobJW0coyfiMawVvSrGC16z+HS/yOTc1qxktuYn7u/iWcy5bq3l2ZB9M91lpYRyCgNkE+WmydnZIwM5Cn5f0PgskKz27LVQMCvTXac0d0lUg0w+1yN/9UMXwCsjpavZphsnjaFw6g8TdWE0eqlKAowLnmauw/EmVk0uE/xe7LWCpS+78aiaieDkNp/M4HutEaCFaNjlmSvKUc6HXOIDf5emAzPsM7g5xYXhtWIDfAmiV/P2a8+w9sbu
 IeUgsKs0
 kL1ACHLke7gy0fwAn3qSP72FCFDaL+cOE7Po+Ts5afv80FGbL9nIidarK6e1EaKsxrvWBYqAMZF0ZD6dEJ8HylTed9nUhM1g1gj9QqpUbrKmHDPvjvnunaC7LA2nyTrtHFNkNpK7vH++lB/iI5O9PaSK6u77x9ok4lKusMWjGoLegGEAronUIZAl6bXaWIecYoGkjQFe0zd49EKs2mp38WNi5dcGq6Tvgo7TaHwY4Gvc8n6UZkTvADqa2GNr+YLTPryCe4NPL88vua7ZpYIFJ5FkET2r32XS43i5F1mkc7MFReLWJSAqRUh8MeXBF87JeJsoYeEUII+3GYwOhhNUML2ean3wlYgtFlS4s64MCijxj+4N6A+qpp5kJMwuvG8GAKJrXUNMq0k1QdfrimzYqtRWSlw==
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
> Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
> swap table to track the swap count").
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

