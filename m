Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B629606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UXX4K5Fv
Received: by kanga.kvack.org (Postfix)
	id 1DFC16B05B5; Mon, 23 Nov 2026 03:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BAC6B05B6; Mon, 23 Nov 2026 03:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07ACA6B05B7; Mon, 23 Nov 2026 03:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D669A6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:12:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B36C316077D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:12:30 +0000 (UTC)
X-FDA: 85465666860.17.D705756
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id D83FE1C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:12:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UXX4K5Fv;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421549;
	b=SRRrhszwQai4QoC+RruZLm2AzWLU1/9rlBDqf/gRVTg7mg7Es735ZDdJ+2iNFAF2dUL03v
	6XdkTn0SCaE3UylmFPV5T/xYxHcMx3fNVsFecCgHgeeG2XeGgrwOmAFyPfho6Bw3CQOBQK
	0PgM57jpJqU2IliEx316NLLf0Uj5OF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2szI1ZqQtgYM2qe1Z1F3aOmh0lr8LS1pFbMyBrHQw58=;
	b=xofLjRrMRO08diOLt3EixO8uNVeEDzhlFFV7sEmqjPyI2ROWTZn4G23nyNLGMLTO1RI8oo
	wK0nf7eOQRtiEDpV3Qvdm2dR4gkBchpQdaNHF7Ejku53q0pyWYFukl6mF7gtbfNxsEdAHJ
	ezzTCYF31rmSdvA+LmaW9l2QRvlWa7M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UXX4K5Fv;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-949680e6d82so361618885a.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795421548; x=1796026348; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2szI1ZqQtgYM2qe1Z1F3aOmh0lr8LS1pFbMyBrHQw58=;
        b=UXX4K5FvuzHoZwony+FJpEf5hHrXddBj1QO9CbGwy1OixK7cKc1m1ixyCRxoEzFPwt
         8yFwoCrGe9ufoFN/ux/v/Q4mUh+RL58rO8BWA+iVAYzTpWfGYpgFWZQwiRcenHMgF0LE
         61dhAxsu6yT2Ua1NdzM9m4nbzEiz2nkWiHaB5shBUxjz2JJ1FatJ5AiRzCq9JXB6xwzH
         aDSPmUN8zXB66t7qYA/f+J/5ERYpu3VgsY+2J8Cl4rTxnRkQw2lc4s39CTsrviqyo0K0
         bTp7RuljcLIF/hoEklVbtMTeD3tevih/ODfKIHD7buLG4JRvPHDIoYBbequXj7p2AibW
         GvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795421548; x=1796026348;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2szI1ZqQtgYM2qe1Z1F3aOmh0lr8LS1pFbMyBrHQw58=;
        b=A8wUnY0qRi+v6FNcxFaGsB0+HGfh9SYCwQ8lsxXs4AI21m+osnEUqCgZWskWyHS+zD
         mfQ4QcKcycrZFrVNcpNsmejckEj6SuX78C2GfGyjyBM3K365lTixGuSdUm0JFNPusbPf
         11s5Qt+xWT+XFw2V7dqHgDQaFhMaejJ9okIXxdOHSxd/EUzSiHS9wPkM+ZKN9CBpJQ7Q
         nTZ6cA5EprkeWnaGtwo/HtSgjJQMXYzGnQQnCRipA3Z+Xis6PNaIdq5ekZ9eDdelxrS2
         /XglXb8rj012ZsWyLfSFSjq1Ch83huzGVqoX68ziOzKO/XWOAHUQNDDl+Is2eY2HNtbZ
         GMoQ==
X-Forwarded-Encrypted: i=1; AL+hErHONupjt/bQi3pBXW0xsN4WI62No48DudpFeiC5VsZnm+9WerJRxclUb1dsGkRS6gmj6GzORAEpfQ==@kvack.org
X-Gm-Message-State: APuU4Z9lnEQx8VMz1kQ/gh4JUoFmMvWBUM8t4+Aa2rfUjw9AqjGc7nG3
	kCSwYAR83Fz12GbYojHb0734/sK8TwAP8xcK4WIx4Klfn/sLnlJUxW1Hff6yjtVn1Gk=
X-Gm-Gg: AZFdTZfx6MfsyeDfeUknzRHLd0uf0BoOTM29ghB/GToZ6LKxvQ+cM43TAV9mG6tZeIq
	YkL8CpYuDTgCBFQ+4i0mpaA+4t8Z/dBccdLBhbI+JMjsrnJHUMCE48P6bjypR2aleY7o/hoAcKU
	Qe3tmjV1hxjLB7FdYn2fDjpJuN6MtLr3FjnNyA9yh9rH1e5kG96NRJkzI71GOchBYFqI/bzZlfV
	In9d6PIK9ApESEFWI2TBKcgFBQmu99kvONmd43O2DarZpJFN6qWDye7O2kfkT6OQc8j5LyL5W9x
	8CT4p4THpI6m6wVUofqCm8b51iQ13nhCzg9+z5Hdhq81102JrOLDwjtm49ORVJIyxMBG+4nZnwj
	On/52k7NDV0X54PJSfVYEf1udmbgUMdjOeG8ua0d0F/gj15VqBseCegzibITEBlc0I7gzxI6Nfz
	4hfWQzqCKuA11/0+fKc6xhKNVulxntm7ltM88T3OiY3KRwakrMo3BfiwhZyFlNpoKe+zAoE3e+G
	MNQLKamMXZp3p1KYxX2FKWjoiwcO2ceRrb3SR0/beA4gKPaY4g5x5BNvyOvMgL1c4aEzH44sacJ
	Z2kYa00BAXUgnRrnu4vbJEss6D6n6RU8QBL404fzUXBy9amsGYuli1RkCEq/tCVmto7ry/0/Tse
	6T6FNnY8=
X-Received: by 2002:a05:620a:2956:b0:949:70ec:7e76 with SMTP id af79cd13be357-949ba80f78dmr1737529485a.1.1795421547930;
        Mon, 23 Nov 2026 00:12:27 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb41a341sm752293485a.37.2026.11.23.00.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:12:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Barry Song <baohua@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <CAGsJ_4yEeORJw8dQEH0U-JjWih3+3ZVx=1Va5F_9qsVbPzCLvQ@mail.gmail.com>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
 <179537313704.412063.6683001223228002260.b4-reply@b4>
 <CAGsJ_4yEeORJw8dQEH0U-JjWih3+3ZVx=1Va5F_9qsVbPzCLvQ@mail.gmail.com>
Date: Mon, 23 Nov 2026 03:12:26 -0500
Message-Id: <179542154647.412063.5153407036844671374.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D83FE1C0008
X-Rspam-User:
X-Stat-Signature: aoshq4bjsibtgci8f4ecrascj1z3oq1m
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795421548-935346
X-HE-Meta: U2FsdGVkX1+sJekcRjQ3TSAMo/f5W7GMJQRiHzk2kKXaEx3ZrkwGpFqHwATiZtuplHEezvD4n6CvaDzkUvM8j0dHK/d4PNYyq+8auvNP+hcEC7fqFghJyrwyaLhjl/LD95kgwOEgjctWUyCSY280i3KBczhrQBJ6kYHVuixDEuwV77LhcagcJasOuORMBRLHa68n05hV3HJWPmoFv2f5CfGOHnIf0fzKqz/WMFCoXUv8rhMhWfPGPPl0+IJUyG/pqMGJflosmKB7HmgWxZktQKdrAwIDQ9YyHReqSbhN9mbMEo5ktfRPzKP7LHizrvmig6Ja7cRuMc1qeZ271Hi6gVEc7nyGZAKmIYY+hbGy19BTkN0f798JNaw5omZUt1TvNBiDelo/TuBUiSs2HvMV0OU/h1ykYjPTDT3YX2ZeojolWEUXhxSR1a9VV1iV8TZpiHg1l+eV77jDZmLjM4zTloHO5XGUn1BD/LcohBxK95G/d9pJt8tcBOZ65Do+m847BuI+Y3wJ1loBIYF3Nv7amZQozAtAoWKLO4pjdy7ypS2AoJpCMefcAw3xuBK3ZYDcsIWy6AT1twnSc1u1iDk/UH1mRR/a7QIbCQ7Rv5htFieOFNM4vT673Uxynd2hf7OoNbEww2hgKvX13ATDg1j0cpw/yOIkojBmVoQ1wR1x1thviroWIpMM+7C993Vk4ukWvGUxy/wGHOQmdi/zW8R6rdve5Jdbd6b7nxUwS+s6aig4uviUYjurw6MZ83ZPeI/SG6ikRTK3OfP8l9MYlKYwedPOROMGzq5ImRCZhdvijrB8eWlhijIpArkhuTWFLNaadQrCYA2jy0AOm2kAiWil5Eiz6R4wPG6PS3ZRmWFkQPDdjqx+y+vpvn5wPoIE5FQhNy90wp//y/a4VcVH5xJtJv+Y5JryEbF4lQHrbmCW8DSrVNffG0+x+dU96Ync1ohZPDu7WWy1e4fQZy09qMu
 Ve23otpw
 qBOwqQIiruOY6XOsE6QkqBJgc6E8/3fgN1yQ0mMyJ0hBxs/R9hGZ5gXqq6R48DCCN+hnGoCC3Djx3Q6l+KCgi+r58ZDb2gn0kqgtBs7Of4KWGyQcofzPRg8p/j9VAHBRUuw/l3424lZ3faYIg9MP18tcvKPHBJsC0jQY7GM9S5tAJ8W+/+Hh2l7/buwTDqEDpbkTO6EjVwIqUuoOVgyAWU6glj646jiO57/Lgm5bD/aDtSa7OQAeoU8+Mdv7jM9Ue/VnM55HpXMSaz5LUt3b/4mgpN1KYsBojsXy4bUH5W1IE+k/e+/xfNRwkq8zwElwrW6IfPFd8IhUvkv/qBkSNrd6c1XDQHxqMC5FRv39hdrqIbzzJSdjUZBbzw5OocfcM6SeXGbISSCF3KyOi+F3DgFhUXcRARn08qqshgAPTVXW5CrOud8H1EU3LH4HE+RzCOPHdHA7JiwoOQ06WUnCybSbHy6J/NTnzEg4IqTbKE4lx2NqUGX+0tU56IcjbV7nqzMWhGWGE9N6egQ/26mrqgPcDpOJCvxNYmvBi2UTH8a4332l9Uuo9LifA+UIihnV/hGIlbYHPLWhrseOnropAg6LVmLvtlK6PfsQAIfXYV5ItaMh+I5wMs2RfzEw19UMQCUgqU7gmQEWDecE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-23 09:14 +0800, Barry Song wrote:
> On Mon, Nov 23, 2026 at 2:46 AM Gregory Price (Meta) <gourry@gourry.net> wrote:
> > Reproduced the hang determnistically.
> > Base deadlocked.
> > With patch 1: -ENOMEM (safe)
> 
> Hi Gregory,
> 
> Just curious how those -ENOMEM failures occur. With GFP_NOFS, we
> should still be able to reclaim anonymous folios (except in
> SWAP_OPS_F_REQUIRE_NOFS cases) and clean page cache folios, right?
> 

Ah this is a little dumb, but i set memory.max=0 to force charge
failures.  The -ENOMEM is basically expected in this scenario.

Not really something you have to address.

-- 
~Gregory


