Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4930DC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCF86B0088; Fri, 25 Sep 2026 00:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E706B008A; Fri, 25 Sep 2026 00:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475096B008C; Fri, 25 Sep 2026 00:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD6B6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:37:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92E4D160547
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:37:39 +0000 (UTC)
X-FDA: 85251026238.22.55DD6B3
Received: from mail-pz2-f18.google.com (mail-pz2-f18.google.com [74.125.228.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4C81120006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:37:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f71fzweO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.18 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790311057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+A2Ge7yyIYJgtfX/fpz/xgx25zdYkH52+JvJO6nACg=;
	b=A5xmF9PV08aqHkiditwss9SgTrsh7k5bui+FEHCizpgMXHnYCKLZ8+MdO1hgYsC+zBrEsS
	0EgxKHFbBn6uxNvVN/Fp+a+nfvYp4WPUP29/9scwpM9iCPcTj1Y6i7pEVyPMg2470fFM6A
	5PJbfByc/ehCFxMxybH3frO4MfQmwEc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f71fzweO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.18 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790311057;
	b=sz0MgCgsylTadubYA5S0kQKHgXkkBdQz7DjRcWlXdw7RXdvPdWEG00Q5ANpivPG4ogLVzz
	hxvw4yKoQfVskhHgH2BUyKv7GtQZrlxrHXAUA487o+7QW8YuMGy/QO9pJ6rJ9UpVsQUMnq
	Eo42EwIFU5ZmcGW0671SWYROunKt2fM=
Received: by mail-pz2-f18.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso291590a12.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790311056; x=1790915856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G+A2Ge7yyIYJgtfX/fpz/xgx25zdYkH52+JvJO6nACg=;
        b=f71fzweOwbYtdjHXzYac6MH8BfFI6Cv14SLu9gWRYSMGDgKy/jMLHr1LJD3+Cl0Ou/
         vu9EjQ8O2zCEbpHfxrhzUpg5fCCmkLka0lf1/ajP8rQX2c7TdpkWp4f7aq/H87zRATiu
         oJr+T8Qfkp12PzsJ7qeui+LSSWAqFOJt1zHuZsfzuWQSQPR9SzW8nNbStjEj6iAOGAlU
         +R/KsjAvg0V9jy6e1jVHOXQSWveWdXfEaVsm64yPuPaga8+2PIySPgEJ5T9NeoDf3nF9
         TCTZdihOrCpUWk2qIMjFBln+mrGiFV066U1CQjGXSqe2UFwwymsZhIbw1f1kBxSnGwAs
         Oobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790311056; x=1790915856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G+A2Ge7yyIYJgtfX/fpz/xgx25zdYkH52+JvJO6nACg=;
        b=XRW2YgMVjEUoV106EkgeW1SaarWT4hnz8MUKViU9vUKWOeE+uIVGttO97tr9fP0sRD
         SxxBOf98uwFBtd9VNntceVymuz9lRokR6ZpKX9scCCeSVbxXUletowJrsqkMXVvu8nWI
         iQujE/aCmwM0sHKbCSi3GAUAepYHSeeOtHX8ZB0R8wns1Osc/FlxPIPtBRx1zQmWnOBh
         um4Sv0ksM7cNIifeBtCSiHUzpRO2hpldWmmCd06LzemcGeO8mOa68izHWSJSWU7J7/mE
         pimHzG8XpTMNiWdzOQ6tFD2dgTrCscIoN9Soo2U3ktOKoYdRBSUqkHpPT1PKX9iD2GS/
         gsfw==
X-Forwarded-Encrypted: i=1; AKwUvBwPhoPXr2SRNdtpK3zHtExW0Vh+8lq3wfIa71qtcSCFq3vsR5DDqZ3oPfg5VTmypZdmTLRrUZoIQQ==@kvack.org
X-Gm-Message-State: AFuF++mpKQO/8WN6LEhdrsCsMyaChVfPSuC4aESNb0pQXMulXW1ZBDYh
	e7nsU9G723d1SzlPg9kVVbB7E4OM1GXX8FBp/9bbtcVbDHHCFRrfJDo=
X-Gm-Gg: AYBFou14f/PcZVKbPTWWj9FB79GAyf3X1mSWyf6LFI1B9v73SAye57bTljbX+2p6Ygj
	PcLZkP/+Z5M1t66eL6bfUpOzrMvGvmJEqCPSBCS0Xzv5sXPSDUPecabG3gxbH9Zw8EKCFR2gCDt
	sSx5AqUK+XMQ3au5MLof+WgPYLtGf7FFeSDnISgpbn6qyupOFVTuC8eSqUnuII8qjqyXSGfMWcg
	JVYuizXSDps2t1Ig2ns4Vykhq4MfGD9p8IAoNcA97/e4EiAH9BM/Y5XI4NItT2mf4cUxlfEXY8W
	hUPPtwp+Ml4TgpdGRA/uRQl4OAgt38e4qIcZhfz/OLdH5p2Ix5Yolq5f80GhY46DnwCqalorA1t
	6f1+/ys7iHb35Mfv9orpeHK4hNzUcvtTaS7LqQUo4DIJFBJubV4slACTsiTjqhJYDsCe2j0DVmA
	DJtuXAIg8IxZoIPZwRhc4WoBPfm4Y6KJ9NIO5Ss9s1/AuNS0d7lV2xOvaUu+ZxL4HccoiIdepJp
	WSYUqatqPi7ErimlSETm7vU
X-Received: by 2002:a17:90b:3e82:b0:39e:6c68:c779 with SMTP id 98e67ed59e1d1-3a098e054bemr4230964a91.47.1790311056420;
        Thu, 24 Sep 2026 21:37:36 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9357f64sm2006727a91.3.2026.09.24.21.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:37:36 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Fri, 25 Sep 2026 13:37:29 +0900
Message-ID: <20260925043729.2362287-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arO0a3CU_idyVsqQ@thinkstation>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com> <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com> <arO0a3CU_idyVsqQ@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4C81120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: r1rk1sne5hwk6bqdzhjtmbnzn58ah567
X-HE-Tag: 1790311057-434970
X-HE-Meta: U2FsdGVkX1/Ew8e6FpnI9n8451HdaU9WkORXB9SMRu7on6+DEMFKDaeEzSBBIM+rIdMCPlnErykMMbVj+5zhrLrfwmZnj801+N01tiwZHorcoFhU7z/J+l+Q4A85a7azcxtCHTxGYIyxup/kr7fO4ZfkSyGDptlW2x7W5XYFwWy//783qm6g3gFZMXiQz/dGadmZ9Y3Z7+FzZ4krW/RxmL5pSy799YSMj2Ro6iQBZ7lAj/xg935ufZ3zLtNbeNSaIv+2uvQS8EW8Cre8nX/F0X6KoGUJyvw7No2QcRj1ciGzJkZ8ASvudJjl3Lnzup/R1vybLpJsvYgZbcBD5fWuqyLSaJfqSXNqEaq9t8o8Jtle2lAjXdCjAxnE4Rhn5y7RXGrEgsUzitKs7UZ6sOiI0ExQgHBa+rtjGrxyjmJOaDTd4nwjX3QqWweapbqXvPzHCVQFO7/PTeH1719U7T6efoOOeNqKv8ztRUDw3REbjXPyRYAjSF7MhpGteWlfUZNObINZYQPz7H1o7cqNfRwF5PgXnmNIXjD1s0mqc+izMsxuFPobgYfxk1xW4Kx6dnI4xg7JbrPhfeA84jZr4DwxgIhGtakRwn9VYot39ogVQieEPBO4kbuOpyh/O1ycNk/ZY8qA44HpNQ5ODet4pjYbvAez42uqcz29Yw6dPy84+ep3AuzJ8gnVqz2kpKp+0AXHlQT60Oifr8Fp8N1+aGNXI8a2Vn4U63ImVB6ouVew6PXxmhfkYU86OEz8Tk/NaTujb2T+qUmWpyBXieBgAi2gGiHwtNeeBFgYXpGaN5pI3YS7Dg5oHgK//z0jMRPF3Wv+ufKiwa8B5PdWz8RSkn+i2KPCqo7HDIjGvr/YAXFsQgPJpSsuULSfZSLvBuaKMxZCa4/OBx1uLjZDfP2GI8noaAevBqK5/p15PU1g1U2xC0PMJEoff3k9y9oFZ4A816Ebp0dwpYTv+VOpBOEQE6s
 /3pdmZJQ
 8BsqvabkxHwmoRxLI1SYq8z/pQ7V6zZMrjoAJ+xp9AD7sLctZCVF2sXPrKWsgtaWEI5vA+SVm4WEyz22T7CVelBwMOT8CU5xkIvbu2L3CXsSB29sHTbBjPhDoJaCxgsUSWnbzbC66IkJ8UVJqotmMTVDOupdsAOxrFChfB13daN1NXJdxBt3LEnNDcQ60itbpvykqfnYbA+UxeyOs/fEiUcBawqMeKKA9vmhLIvgYZqVJrPgBQ+Ghp04MFz5tMQPgVengVpr/uq6dNhqLm7anRwlMOZGB0FdIA73bA4vfxPIBcRb2fCJEQUSAan5XlM8RPzXxT5VE6NgxTySqbjJzOWKe+ez3N1lLP1PqgNwY2SW1pAsT1PGm/Eh+kVqvVF44s0cqyQsnsu0YZgijw+cnPL5HM1zyMNaq4WtzP6DZPbxm7m8vaIFSHU7TbEN+zTzgCHvE5Ser8c1SU6ytOfYODMMNO3NLYsSc06hnTCp4tfXqN7oXg5G7j7Utv6KZxikNZBUwreGK0Amz1KaWv0T16l+4zWD9UzdUY7Lh60ah1Z/bUzFaogWDpZojGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:18:30PM +0100, Kiryl Shutsemau wrote:
> Putting it in the 'else' is wrong. Clear uffd on the source
> unconditionally and re-arm based on the target VMA:
>
> 	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
> 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
> 	if (userfaultfd_rwp(dst_vma))
> 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
>
> That is what move_pages_huge_pmd() does with clear_uffd_wp_pmd() before
> its own re-arm, and it is the logically correct way to do this: the
> source's state is gone, the destination decides.

Done in v2:
https://lore.kernel.org/all/20260925042907.2330519-1-donggeunyoo.kernel@gmail.com/

Thanks,
Donggeun

