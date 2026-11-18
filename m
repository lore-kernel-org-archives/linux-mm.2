Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA29B606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=ZPJMuf/Y
Received: by kanga.kvack.org (Postfix)
	id E7E9B6B00EF; Wed, 18 Nov 2026 11:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A1D6B05B1; Wed, 18 Nov 2026 11:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF84F6B05B3; Wed, 18 Nov 2026 11:38:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95C766B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:38:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0962A1407BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:38:23 +0000 (UTC)
X-FDA: 85448797686.20.F03B6C4
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id ED32340011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:38:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ZPJMuf/Y";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795019901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYnPwXVs5q7hiylo9HLvXwft8EbUR8+QNtfkEA01owo=;
	b=y3lsmVkV05MsM3YvOoS0a4G6mUTEKEwzoJX/zCxWNW4W9uQFk7gBywXrNVzz/mZ86sF2s0
	CImGiTYEfzukVCMrA8y1kHckeYvSZGO2ggqUYFPrKNkx7rVTJwzarw/7vV4K2qTz14YFIq
	Eyj5ozrTsX3x1oGZYQw/ZkcY4RxzRsU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ZPJMuf/Y";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795019901;
	b=l0ZsZnugdB+Cg/01Fr6NDj0zKe7Sd9Me38MtRRAok2/DG3Yo76g00RbRKWtnjlHJWE6kuI
	C3jrRkUf6sYCYhXQFxlzbxakAustr+Ic9m/mb3yej/rDJMyasEA8JSSmm7Rlg0lQJgAA2c
	B3r8zzQ/6oEkrrbz6p4mTv8/0XWLsyo=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7d2dc1ac787so387140137.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795019900; x=1795624700; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LYnPwXVs5q7hiylo9HLvXwft8EbUR8+QNtfkEA01owo=;
        b=ZPJMuf/YPCsPZxdZN0MEOoq22PTrOgkw/AyYJW0FmJg3zG04JXt8dWl98Yrmsq4+Rw
         OQradkohn1db5HgyNtCUrcZZ/c49aVEi9t0XwdzNmFxdifQ16e01o0WEL/o3t3/7S2YI
         r3rRHBb2ZuT4w/xhexy7+YudYzrUCY26mnq3TwYIvo5tCoEm5Kb3vObuTk3oqAOkrHIg
         AwOCt7iQT1xtqhTS7VBDFb9CKZMIwwlzjK6w7wJ6sy/5LXcks0gWLuNI3DVtJgw7Sna6
         Xd9jGg6r8rXiocm4vHzYURe14AKpZQ1yjfhRBOh/jf3YjW3A5GhayskivC0eXT70/fdQ
         UuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019900; x=1795624700;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYnPwXVs5q7hiylo9HLvXwft8EbUR8+QNtfkEA01owo=;
        b=ztZLAyWk/B6AwSJJRf1QAhkfsUq9+7bRSyqibyL40sabl+701d2M+CdmJLMuQIltdQ
         lmOj5ToH9llcVW/FAZiJp+/H8i6O5s/Ywgs9DaupP5ItbXzbSCcvJL2PporBX6wh2/tP
         6MX/DPH8avvEVwk87ruT4dBMnLjxWC44r7SeZmKgDGyCzeFCBCFF3bjp62AuGTfwcMzo
         sRdDymG2AEqkbFCdZtHM5BgHKO6/dFuNfBCsonPNbEWYscSe2sNby0Ef0C31aJ3HzYe/
         AbR1ZH5jBUHL3LBQF0fKN5vVj+LXJHsrq9gdoYiYYFu7/NfRZpdL812foagIVlcLNyK8
         6dbA==
X-Forwarded-Encrypted: i=1; AL+hErHxuPEuTCHPIS+BVT0MCTG9KlriY8HlT+2PNz0x02lJdipPJCKDHIH26rlqcqQZVcDj3ggqZsYCXg==@kvack.org
X-Gm-Message-State: APuU4Z/IF0ksPBUEpQvROjhd3XWx7ct+aDkXJfNhWxtF+Yhdtu9d5EWn
	s0uBmdWgGyzJFVjwuMRFswqBbKd0wfLy7g6VdYW93+ptSlWYmG0uevvzC4n4tcWE4qRKAKfT5uu
	wWheD
X-Gm-Gg: AYBFou0eceeVI9xsTfw91MpIrJQnzpwjVbTzJ4EdZ8IZ33ZrsYR9nihLTsitTxa6+Xt
	oDXvJvoFYo2LemC2l/0JrAioFasHAWDDgjc8OO4clJloRTMybO4clvIk/SxRROHVfXa9BvIvH4O
	epeoKD8mqvdBCqo2Rcl/OL5V/KWHQJn4pmtWzWab88p6Do3TzNjUutpWYaHtQa7FQzxH63fCdBI
	vW95VezpYvjKvOHD5fIJ8NL/nBq3EWwbEStrjJJn75relfoD0Lsg726Yw8Chbqb2ukbs33zKNyC
	fPG7MWrJfJm2UwjGNB1yDSo45xw6S5K5YjdUVwPBTNtIdm2mHUGsdssecQm8lJhS5X6FNWOdEme
	uOaC1+z4oETlldIZDsp6mQ8ktGrdmgVF/dgY6dWwasfN2/G/xIOWaZOoMxdVrIOpKD77Ho9yIr9
	4QuUWvtZUM+4p45vo3r7jG/glaa3hnGGBq4h6PP9eoY6T3eFdm+lVb+FARUy9ZHPFb4F5VA8LLx
	PXHKXNwB/vlRFwmzXxDhpGwTnr36hq+gA9Kf9PHscVr6r3iQ9JtQdBLhQgk/Yquxzxrkl8h78Fm
	rUc8fEig/rP6LtFch0oYqrCG1s5C9nX1qcLrmdm8NBI/Kva7tq2Kqn3s2uWHgPevJBtxbuZBCAn
	JdWktuJl2Z+4bXDVuX1VOxHwdxQZckn+n5VHUMSpkCdtOoaM=
X-Received: by 2002:a05:6102:91b:b0:7d0:9587:1b99 with SMTP id ada2fe7eead31-7d6b9ee48fcmr1231586137.0.1795019899949;
        Wed, 18 Nov 2026 08:38:19 -0800 (PST)
Received: from soleen.c.googlers.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6b9318565sm2190742137.9.2026.11.18.08.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 08:38:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] kho: expose incoming sub-blob metadata instead of
 contents
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Long Wei <longwei27@huawei.com>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 akpm@linux-foundation.org, graf@amazon.com, leitao@debian.org, 
 corbet@lwn.net, rdunlap@infradead.org, linux-mm@kvack.org, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, hewenliang4@huawei.com
In-Reply-To: <20261117092951.4017931-2-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261117092951.4017931-2-longwei27@huawei.com>
Date: Wed, 18 Nov 2026 11:38:16 -0500
Message-Id: <179501989658.250261.5046056769256366161.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2796;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=s2TgceZsirNjgZI66wNzdrJjtsGvWS0+fdcYU2Wc8h4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq/dR6HI5GpH/4iewvFIx9U9up3jTt1CD0OiBfM
 tAYaHZwb4eJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCav3UegAKCRC7dyhM23N6
 3kzeEACFJCS4M3n+dkgQTJYjctdNWWkW46rsV15OpDqGSLVsafiGK5V9DqS/YbDDUzAIL82H8ek
 ad5sQrHuBJHAawArjrrZvPvZzsjJ7BoW0DhpOcm/qpi9kWBcHFsENdJnsNI+sEKtS7RbbYWQK9j
 vUVdUL11miluOI0kgYxpgF5qaZ4UwPGOft9U1q/ZL8XoMA/wEeCWMJjAzYczqn5NlEwwa+0AB2q
 6rV9wl/qqH3k5YypOi1mJyaSbV5EkYQGGi5oaRrSDgGgUPPySAGgd2qpPcV4/nA19UkULW5+Ytn
 maeDoReb2TGTx071O1D61DRaAQroMbESBa98ybnPDi7kYDDQ8CLtcbsoJT531hV/Rb9vSyMfua0
 WYp/jw8p6CI8ckRZakilQLC6NoROctxmAW8dgqsN7qz7E8zFTylOcMwvBnWCVv/OmeVNt//PGSZ
 4pvr57QAYJHdwmcY+nTXPkmo8Ah6AewPJfQdfcObc/6kbkiKd/1d8lPhhzK25hDvF00YlLVIPNR
 9tWH7znV/vhJaE8IssOJda4n+3fjfU5Kdq/BeEciQ7PR4m3bZU3IgMli5bnUzkHVn/orX7MMm3Y
 Z7klzrAJ9WeT+Ujk7U5HYuOOt2IHqPSL3QETXW/TOkr9Z1Ev36XHxJTep93cKMnaV5yhNLmn8bY
 /EvS9/hwGM3L8Hw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED32340011
X-Stat-Signature: rbstc31jr37eta7ojizxs6fcu6bzn98w
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795019900-940012
X-HE-Meta: U2FsdGVkX18UB+qhP8/8hxhjqWbH4vH/7ZPqvl8PYrVL8t0Zv1Y53BWUrtAY2sBBJ1pKsI49M8GaFKzQJdTMQ55C9a3XC7+w4dMSaXT8WAPlbGhwgOnoqTP9leMq0tcBNVV4m/wRXFLgySvSJWmvA+Qv4KB8Z0KT1FBKgVQWgpRvPET9U49W4ZMOEhWjrFDMpmB2KA0wn6/a53/YYd3hMx3KF2II7tPsCSa8b9opCBr22E1sjEhT5XedsLsiq2U5F0ZgtxyCUg0ZgH/xmMfJHqY9iKaM+U6DOrAa9AhVFEKwedHphr0+xYs+7YPvnU24/zajWtksX8Z5kGwL2JS+9eXdDZJyC6wu+2Li60h6ArODQ7dWuqZ9uNr1HN85NOHJjAQLAdYBJHnp4zKawsA5XtmwDntg363ob2aQ7OAGWpfEUMidK1LhcLINucS+kogLIY11HukDxIiWlLOpmquEvj8VoQS39Qir6Tjv4eJyTgmyVANzVjG9XaqyIMWJPSQXe2JUBSKALiFKMMTOYFwpbAGYCqU5buB46EwQbwDsVv7h5i3UX8xh93HNobWWYAD0MP9OGaXUwloHCav5x96ZKQkbZOCz5VGcSgpXPY4Dbs+soGGFLZc74vwVBaN1vswXh1RknmE+8MukE9v+MBwdfiR6B1Ui0wYIWgWy82L+yc3aSKkw2qC6ZARSIQ+ip1av0o8nkc3IC2raeUpdHpSJUO0dJ6gs9eVI4bNSRa6JFAAXRvWZeaSOTqwaeY/D3/CIm10hNdlqxNOZqgXX5u/+ZK9KGe0CJnrin51Ii2vgPdIwqCG0k/S7FmK1mExwsyasIoiVWN5EwunlXvC7bwKNRiNlB3rSynhRPspvM++lGU7DsomzLEIJBr8eFQeEDUZ5w27lvNeI4YKlG8ILhPCJNepvLgFJghSkuyZUfo5/9qyv0ulKUkScupFIo0BAUn50clYnWClnS96pBTrWLil
 egAWjGKa
 iVUIZEcXiWACFA5jT6+rQUkoYiQu7ko3klyDgTZrMljZmdjlBKxexOBqWJrHV37EZU21+gzqAlHcPhv/bRvKpvczNp+4dNCIpOt6LjI016314HWUek7f4Go8++b4DLrNFMxEojDdiauJchUD7IcOIWhQpfH1hZQz7fobyYHKgygG1pEauqR/1QL76s6KM7FdBIkzTefvY0GVuI9ml77HxaEk8hCuDlwOeKMQn670ZgY6AB07yY3GWtavy1K2IAKqZgoVIaM8Lh5aqz2PxKhp7Xi2KAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Incoming sub-blob pages are owned by their consumers and have independent
> lifetimes.  Some consumers, such as LUO, restore and free their state in
> early_initcall, i.e. before kho_init() (fs_initcall) builds the debugfs
> view:
> 
>   early_initcall: luo_early_startup()
>                     -> kho_retrieve_subtree("LUO")
>                     -> kho_restore_free(luo_ser)   /* page is freed */
> 
>   fs_initcall:    kho_init()
>                     -> kho_in_debugfs_init()
>                          -> phys_to_virt(luo_ser_phys)
>                          -> debugfs_create_blob("LUO", ...)
> 
> debugfs therefore ends up pointing at a page that was already handed back
> to the page allocator, and reading the file triggers a use-after-free:
> 
>   # cat /sys/kernel/debug/kho/in/sub_fdts/LUO
>   ==================================================================
>   BUG: KASAN: use-after-free in _copy_to_user+0x37/0x60
>   Read of size 32 at addr ffff88810309c000 by task cat/27436
> 
>   Call Trace:
>    <TASK>
>    kasan_report+0xb9/0xf0
>    kasan_check_range+0x100/0x1b0
>    _copy_to_user+0x37/0x60
>    simple_read_from_buffer+0x77/0xd0
>    read_file_blob+0x75/0xa0
>    vfs_read+0x12d/0x520
>    ksys_read+0xc3/0x160
>    do_syscall_64+0x97/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
> 
>   The buggy address belongs to the physical page:
>   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1fd
>   pfn:0x10309c
>   flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>   page_type: f0(buddy)
>   ==================================================================
> 
> The page is already in the buddy allocator (page_type: f0(buddy),
> refcount 0), which confirms it was freed before the debugfs view was
> created.
> 
> KHO does not own these pages, so it cannot safely expose their contents at
> all.  Drop the in/sub_fdts raw blob nodes and replace them with a
> read-only in/blobs metadata file that lists the name, physical address and
> size of every incoming sub-blob.  The FDT itself is reserved by KHO and is
> still exposed as in/fdt.

I suggest we simply remove in/sub_fdts without adding in/blobs. All of 
the metadata you are proposing to expose via in/blobs is already present 
in in/fdt (and can be parsed from userspace if needed), so I do not 
think it warrants adding another kernel debugfs interface. Keeping this 
to just removing in/sub_fdts (and updating the doc) also keeps the fix 
minimal for -rc.

> 
> Fixes: 062dd306d99c ("kho: fix kho_in_debugfs_init() to handle non-FDT blobs")

This UAF has been there since in/sub_fdts was first added, so I think 
this should be: Fixes: c609c144b0e8 ("kexec: add KHO parsing support")

-- 
Pasha


