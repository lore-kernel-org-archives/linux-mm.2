Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13EF606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=juETeZkL
Received: by kanga.kvack.org (Postfix)
	id 08DA06B05B2; Mon, 23 Nov 2026 06:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EFC6B05C0; Mon, 23 Nov 2026 06:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47D56B05C1; Mon, 23 Nov 2026 06:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C471C6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:53:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5714CA8505
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:53:43 +0000 (UTC)
X-FDA: 85466224326.13.CAE72AB
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81B7AC0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:53:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=juETeZkL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of dingf3ng@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434821;
	b=U/ilItztxmGvFX8ovER9zDPLy66j50LaXJbzlRqCoX/tDZSaWBNjQchfHZfrG1/0H/69x+
	sm0eQMRIIS3bTBVXOw+aU6PUuOp2wnbUonG6Pgi6MyOdcOEQeBuTRsRlN4YrXsAhrFYTRM
	vFazgYA3KSw2TXnHRCNMBR/dZGihuoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4SOrJVAyBEuX0Eflnl6S7Zqf9uLbdiqpI9zpNTKq70=;
	b=qpMBnLAyLxbw6rshJaI15dYuej66cPxfDo7vYd6bJ3q8h8nGbjZRTRPaLs2Gcta7LIMzew
	Ov2YWovFh3dWywjG+PTQKgbgDEc/aK5W4yPo6UiRBSOXWJarz9grzfPBGsj1zaFgntulWq
	7LHkfxwtQ/DzZnqjLjxBvc2NpBGJEmc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=juETeZkL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of dingf3ng@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b3ada81853so3556075c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434820; x=1796039620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P4SOrJVAyBEuX0Eflnl6S7Zqf9uLbdiqpI9zpNTKq70=;
        b=juETeZkL9vH8NyEeTMrXT8F/XY7uy1QaKG9VWs2gZ8mqovyc1Yj8qUni0Dn7y6wIDN
         h8sNFYZxLMCOPsry4Pae5O9k13TaQQ89O96U7HEFuSGdluj46vQO/MZxzIexzW1rvAa/
         PA87XFFQBRyoddLhS7VA8xXbOTn81XfZstGEgHsBEGVkCg+1NcCqfyAEPm/BTOwd5l1A
         m+tDxjSnrueJ4iax6d0iIxyGb1YDxwEctzJ8yNrz9KwQWkudURWQH29MEihXAH577Gv4
         QybKiNqRyU27NrnidkkuM+qr41fzlMP9NJ5WbKfCQsGpV6mxsczNRXrH3syNgu7ek/rh
         yvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434820; x=1796039620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P4SOrJVAyBEuX0Eflnl6S7Zqf9uLbdiqpI9zpNTKq70=;
        b=JxhsXs2C6B1wLvieQxJcwprdmhne+uIcxcKyRvBj1fJV7SEOG23yyzhOLjcLWqfAOh
         lR17hcGfMUP3SP/9FPciteB6MGECSFlsFmzzr+gO+BO291czWmfRU1QQq9EUX/MUzVGI
         y71K/Ly3j26s0uNRTX1in15ZJ87HBaxxI3GLC53HtXWzJvW1jT+T6+rAIuw2HtH6L1Ga
         8nhmnZLdmgdATVHzYiwyRE496N9ShUYMzjb861zGLx1WaEi1zYIzuPEId1mMiGvwRCW/
         tu+5SGe4Wu7vJLodDdUOh3pawUwgVxoSw/BwUR4FJDo5bace0nPaHtz25YbHcKKMKw5J
         Pqjg==
X-Forwarded-Encrypted: i=1; AL+hErHDOIK1Sa1UvjJAUkmfr1Qx8XgsvN0A53oXr2475KBbdqEXtLdAQaIf7mop1XYhqTZ/mRm09y2Ukg==@kvack.org
X-Gm-Message-State: APuU4Z8z5R1KCjDrzJ/MQAjd8yv7IzCj7r83URbtmOepbRYSTpf9Gai1
	AmDAyfeH26ROnaMnxcO9AN3DHlS5yxgMz5AF+vBOtIYb88PPduiD9yFJ
X-Gm-Gg: AZFdTZdNjYpMcLKP0aBMaa9U9g35JK/LZoN+afLejPqc5juzf7Id+rfShMkrJUY6T2c
	OcgSZUT+bg2iLOWQHUIhq2iL2SWHUlHc7uU6nNY5qkFTYkO0eKRL09MvhS2e/2oTk7+AnSo+VWJ
	nf4ZGyEKXHzOmWts413i77F/yYjEgSEEu6Sb2P9eO9btN1XgJcUwRuFZRal++3Avr5FQIBSLIm6
	Dh52HHAg6crfBO/gIZTZB1GJil4LwVIw1G9j6CLdgnkbX8g0HL3S63IlGocc2JxdaKoHn4Vo+xD
	Nh4o/zPPE/nTA88NoGFK8ZXxe2gCoN/gOuYdnA22+3deq4jLQpYne93hy6xthka26U575wR+e7H
	aRsfHW9bX6qwjSJlhuCG1WM3tkgu2/DcmBbFCJVkbVs3N64Hh7QKe88m4Q+9DC8QBeRamr7BJYc
	EuLJq7v/PVtVwyVns3MiUBy1JG53RQsdb5dDep52lDczgXXecJ98pa7FqHjA33CMIwiQba5aohe
	OeDm2ibxfdXPuFf3vRfSaSTKcfQTrTYhCG9kcrQreD7asWbdA9MAAdG681mKbsdxEDoXdezYGHU
	vHd79CB+9H2xY8lPMeo+HSnaE1wKvW4LTCxQrC9b3mlz8FDkr4exxhpQf/+ITRMfZi2t8H4=
X-Received: by 2002:a05:7022:698b:b0:168:3243:c91a with SMTP id a92af1059eb24-1b556865248mr15615178c88.13.1795434820178;
        Mon, 23 Nov 2026 03:53:40 -0800 (PST)
Received: from localhost.localdomain ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm32434394c88.7.2026.11.23.03.53.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:53:39 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Brian Foster <bfoster@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
Date: Mon, 23 Nov 2026 19:53:35 +0800
Message-ID: <20261123115335.17293-1-dingf3ng@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c0c81eee-31a5-73e3-f113-deb1cd8a0b61@google.com>
References: <20251121152246.1023918-1-bfoster@redhat.com> <20261121152706.34523-1-dingf3ng@gmail.com> <c0c81eee-31a5-73e3-f113-deb1cd8a0b61@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81B7AC0005
X-Stat-Signature: q9pwysi86z6acp75rrjb19p3n3cjx9rh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795434821-745115
X-HE-Meta: U2FsdGVkX1/0h+hox+txqXxLal6qMNGZvU+kofSA0tIDb2/e0EdeOgI7BhahhqU/rcGAFSXKdAUdHbl3g1J2LpnTV4ZIA/ZTYgoKfImnR89Oz3pj+yaLBbwAigqpHC6E4TWovwRKCfM2hItuuaJw0GSfpl9uhaQmWiC98PKJYL5KnzkpCRIEkLaZH0wS7Dvxwd5r4kaP/a3A83cUr4xehFKN4jlf85bcQZpHXZcYeXGv2IOtwIzIcz7KeaXE+PI0f3TlNgWzTHP0KDSHiO5qKALaYuThCn81tMrP/ULOCMI3DRudWT2FIhIhbKJDQEFRJMciZFOeTIGhH3wOIBy2YXqMqgH4mMmbw0+RRHxXq0mlfQzpOjWBw1Zq/PqadsQiQHjCvGfZiGeMOrikYKczoo+K6tsp2I+FLfX1/ibPxOc5KlkQpkfOxkCzfUUYf9i775UjUq9cyObJWn258VoQAMNAUScIulv8/BhY+gfqPsOoQN4ssKtV1PnIJCsGsi7JEn3GdVSTyBIpMKLnA4fKDxFy4Ue7IfOupyDnoyL+nOQqPPbPKS+J4oC9lzlbxj6rRCAFO1gqHiu4PvAK9yzK7PzXWkXwiMNxLfaRi7sx7GGu3iqhxJXy0IlbBkOHEJQ+qj7tvNEQBabJLWRb0KKFxHTp4bO0fWMaQ0Hld23Febla16QosH3HAUxYX7lf+QKdief5TZvk8l3TprgcYEorv39s7A7j5TfoaDSuTGS7JmY2OsV6+wLJ73eakyqo0v5ok5NgfUC3rQ6HoNv9/wEwwsoPU6uPVS0WjdbPiJrTNnDctAp06U7v0wS3k3PoSNXo4Kk+qBM7dchydBqLf2yxRaiACkeQvIpXDTaNHCj45k90Tl4CzMx1L0aHqW44p3jVrvQZkv1bAfv1wZgsv0ubiVSfk0MmgV/DErSpL1fvQQVYxk4ihQaXCQqrvhCPHEQ8ue1wAyfd4tzdHrqLXsb
 32JiGm+P
 7rXHuAe2WuuHtViKy6Pv9nQGhej6VPRvZ68JUb9c0SCC+TGZCTGUPVqKJA8+TVo8QvV/a4yk6SsOeNp7AHYZrpvwSMx4SrTh3ep7tQhKrcwQcxLVCkdziQyzQb0yy052BIudy8SsopvZxIGdeNm7iZQ5D3/0BfnsQ6EZfPVtjZPQFRpUd23WQTcGxjdb7nUg+ZoXFOPm5CWuWyagwgfQHXJ2er7nHCVxFiPf7k6ppmFZuQx/9csXKlHlixjfc09W156HYKpsBTFwwCexORtVr2wbJApPd8m6vZ/8T6U4qw4vWxsHxsUIPj0fV05a1Vyyr1oeGfghtptsRsHe6IW/9gCuooB54fWH8BrJMnbdbYNG8v/zsFp+JeEtpl6Oy4n8vD7wtWW5xmsa7Crm3ZsOcxuQu8f41yVb5Y4fRJkh5ianFSBual1+5FQKnz3HHRZNdCfxrPBIlJyicJ6Z3J0wt/bSDRtRqSvh6s40YzQse4ZnkRPcRlajaDDELxJeXdyKBxMKtnMUBlpSgcKVxGSK1tsNYfBc26dcE4nT4jelvCDXX3JXfnknALs2219Q9QHP+gxT0FQpR7ySh3PUUSsd0MlhBijEr3E60/lzr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hugh,

Thanks, that's very helpful. I won't just rebase it.

Rereading v3 against current mainline: on the fallocate path the new
folios are still !uptodate when shmem_zero_eof() runs, so it skips them
rather than zeroing them. It does still look up and lock every folio in
the extended range, so a large fallocate pays for a second pass over it.

Here is a smaller direction. A store past EOF through a mapping can only
land in the folio that straddles EOF, since shmem may PMD-map that folio
across i_size. The stored bytes leave that folio in two ways: a split,
where pages up to fallocend survive as separate folios, or swapout. If
we zero beyond i_size at both points (v3 2/3 for swapout, plus
__folio_freeze_split_file() for the split), the extending paths only
have to zero the tail of the EOF folio when it is resident. That costs
the same however large the extension is.

I tested it on 7.4-rc3 under qemu (arm64, zram swap, huge=always and
huge=never). Each test stores a byte at offsets 200 and 1MiB of a
100-byte file through a shared mapping, then optionally splits the
folio or pages it out with MADV_PAGEOUT, then extends the file with
ftruncate, pwrite or fallocate. Zeroing only the EOF folio's tail still
exposes the stored bytes after a split with a KEEP_SIZE fallocate, and
after swapout. With the split and swapout zeroing added, all 30 cases
read zero, the same as v3.

Does that match what you had in mind, or would you rather I wait until
you've had time to dig out your idea?

Thanks,
Ding Feng

