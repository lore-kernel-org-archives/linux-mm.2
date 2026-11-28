Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDFF606A329
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aYghuhji
Received: by kanga.kvack.org (Postfix)
	id C7CDA6B05B2; Sat, 28 Nov 2026 02:45:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06DF6B05B3; Sat, 28 Nov 2026 02:45:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5046B05B4; Sat, 28 Nov 2026 02:45:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 774666B05B2
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:45:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C00841C3E35
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:45:25 +0000 (UTC)
X-FDA: 85483742610.13.6D79C61
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 082B040007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:45:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aYghuhji;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795851924;
	b=5MluU1U3Tlt7Frnagl0pNH9wJeQEtbZIGjIDTXuWjCD0smo6g5to3sT7dInubKDTBdU1dF
	l+If3oq+z1bsNszMKw2wkDb9XNStmCecNtEAp72LxoWZ2VHP+rjVDA1SGrjaD+HCjohPIZ
	OqIuY8MrsmohYuWwclFjUcDAhbpXiqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795851924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvDPwRq8GAh/t3oB1kQXSCGMwADwrNJEuUFh0I6qC50=;
	b=g7wCjEfmNEejBpHRWfnSpywm4/PFYA1hwSDmZxAVQ4tCkPnVD+WmZa9VmVD+H9txF5eZO4
	iPvy8XiYNmtaMAlTTntBYw3po9+gFPVzpilL7uTPIcI1eBS3SF4lQlOPtWgHxFFlL1+k5r
	rHCZBH/rGI4FjzDDvXFKN5NG4NkYKwQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aYghuhji;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-38692f62b22so12307084eec.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795851923; x=1796456723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PvDPwRq8GAh/t3oB1kQXSCGMwADwrNJEuUFh0I6qC50=;
        b=aYghuhjiapkiV1EzaUlDoNw2TE/sryp3JNfyiBDiXXSoNLQOQIdmVXd6ZmiNtz9JXc
         Aywrfh6yfxEhrNnjXZGJpPfoOdyy0EqL5e18QAy2/9KRY0yMec6W1QK1v60kLNV6q7jQ
         TUdVVGsROS1ksVbP433j5Zs8lnnH90JywfMFv8nJJ0mnUwgrEgpIBb3jpldEiN4ELLUX
         QElhqIiBazl4OR0qBWOEms5WmG9uJ8URN6YSbpwkqJtfLePvblvHX0G8nUP8rZAlkuCe
         gmgSOPYOJMviXwrFEFXtDu/mGeUi2pLw4DdMoWztCLJWTu3K0I9OfNE3K0MG+oQWm4TJ
         WG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795851923; x=1796456723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PvDPwRq8GAh/t3oB1kQXSCGMwADwrNJEuUFh0I6qC50=;
        b=1SGEQO1gVBpTAkbus8zyO2EJjCgFiTrSmSiTSW5AKhJbSRuO5acxf7NaeBh5TARefP
         7omvBdWaiYaaKK/AgmDv2AKmEGXduiZ9xj8/JpJPOXj32d+O0AMAdO3qNN9hRrWQGbpd
         ye4QOvCix9jDNX6QYYiHTkbXJv11c+ctT3FTa7xa/cNheg2o0x//8iNGS3u0/NndceZn
         IIQxVT33/E7gz331NBRJoPhOZfPaZybBK+NZ3wzUgq34zGBuTz7S4NK5oW9/xiISAkmB
         heGIB1OEOVY64v2/G1K1rFivULFSHIvauj1dLCpSRnKWAx0hM9vxE0CEgNiCdM6EjYxq
         k/oQ==
X-Gm-Message-State: APuU4Z9Y8ofp4G7uUvlB/6iHvqSYsZDimGyFnprBIjl3CkjpWwk/yg3i
	raPQsX4di+9moCTTsRer8+EKOUDORdUD61qyCd/LToVXyDzUjoZTsrda
X-Gm-Gg: AZFdTZc3wpXlhthc/opUM8c42iTACvuCD7LuanctbKypPINrZE++bulJOVIx4yFzNWn
	O3cu+tevBc01LLLArBK+ef8KaLN23f7+otHEfpXn0Xd1XKSw7bqwFoq60YzeQdlcauiAMo5dzKh
	PskUL29xuiO+M5UAnmsg2z/HCmQHiUQUpSQtem5cKbiOQNJff0yCSEduc3JVMnYNQqiGiUXpECu
	mV/fKxh9gcHPsUnxSMB3t1mRKggWLBOOIyRjd5Y1CWyXlryY2bV919nZmcjo3zh6hp68JGLPzwE
	JsVaoSqhkJBMhAKuVilXX/mmzsuACB/5s4h8ZWc2Ooh55W6E7W09D5A5qkm/1MsLb8Koi7YkOzU
	cgtp6zA7IogNAjWI28/IWsxlpEquB5Ug5Qnf13AdRucKvNgfwiQKYgSoJmVCGKCtPnFrevUXkhM
	cm+imqy8Tfyrdh4ZkkIkblVnPezxVObXHGtD2gLwJx097qx5eF87Lf/qnlE+7U+xHt46aAJNnFU
	80jiKp+6vZNI2d3MQ+pmoCan51f7cSbciVJmx1F0tuP71538vE0uR3zdO1pD/fUmgUM2xQBQUtx
	1b3nMjRhHoYFSnSYjD74qIPWIFQqwi4CvmMuvMg8z21jlTsObZSA5IIWGmUqsjHw/iir
X-Received: by 2002:a05:7301:f02:b0:384:ce59:5e21 with SMTP id 5a478bee46e88-3856f6503d8mr25637676eec.32.1795851922626;
        Fri, 27 Nov 2026 23:45:22 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385c6830815sm72104322eec.20.2026.11.27.23.45.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 23:45:22 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 06/19] mm/swap: serialize swap publication before removing swapon mutex
Date: Sat, 28 Nov 2026 15:44:47 +0800
Message-ID: <20261128074459.34838-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbUYHBD+To2CGe9b5_zWbYVrYU6Mv-pxzhXEgB7r1DJrdg@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <030796dcb2086484f87e2250d9cf9a04fccf54ab.1795439990.git.lianux.mm@gmail.com> <CACePvbUYHBD+To2CGe9b5_zWbYVrYU6Mv-pxzhXEgB7r1DJrdg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: md673j8oxhpbyxtpuwfkgokyitmonnic
X-Rspamd-Queue-Id: 082B040007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795851923-812513
X-HE-Meta: U2FsdGVkX180tV5iA42XZuNok0n0ssLYVptgquAVTQ3tLqLguLVc8dDA5na0Z9g9g40YWbMt71BfzGAPhWLh/fTz8Qr/ES45RuJoZai5X0xbaEV4ZUVMhgNVZVQ8w4o/1C2YfuRkPKeo7WU/VGiYP71dmsn8Nyf6yHcE6+0qfocAUBjgNS+wSt3S4X5I4jGT9JlJvelude4t5xgch0hV/9GmKrXm7QVnGhD6WUwJzlqWLRuUR4iQY7dgpG17maYuOR0iZYUs5gWK3SApMXvYZ4XKl1hY+dNA2GtpgGVCurLlPiUVPr4+dOqVfDmTyny566bv1u5PvYHiNu6s2i69wA2tF5mTZJr6N134/Hc1/zGfNTku/eVwmnEB8+lT70vkqciCF8uM/O7au+hQKrQKMk73uU1R4rqLLkI6tKLVBqkBQDek1eCrCIo1EMja+Y/JGLlnyITbJubYjwfzL3/To5HRmIJKTwwqK0aKIRDQB2BXcchG2+zgFOSQ4lVIYP1eW5sVeIBiLlk6U7KRYFmF5gMEN5zi6lkELEmpN3Gl8rB3YO3B7DlSWLOe8HeT5+zXyBIEXDZww0XKevn1XJauuYqgZM4ovt6bZMLVGGSEjv52jolfBF+d702vxFt0rBGTis6ug/T7RlVPn7wz9EsLOdV1T28w6VMips8q53tGtshYDdBKewjpiS0JpIZH0hg2W2LPn+YhtmAc3QVPMpAv8MkUKej9p8BlynlJ7wm58q6pXUcfBaYFzjDZn4Z6Ni4ug/TwWOIM6pS2oolPRuqvrDg7OAUNIEiFQFa4N9LdXQesF0jw4ChF7GzJBI7i/jGjlNqohoD3D4qbOn1w3RAeHqcToTWN7E9MEHVADqqbl48wnXqWgSjJKb4xJAE/XuU0MJp7fCtNZG3vrjIibatWXMzRUgrVlTxrPhnhv2HdXVA2L39oLaurt6seJGz2nZAyidzWt5lFw4HqR79WPmC
 MKU6/sYH
 O9S3+cM6wc+nv/ssMz6VezA32y1s6zDmGS+uqF65d1TlnnUtSgaBumiStIJXZVgTOWpTqizP5oQ+/lAk3GzgaIKhv+X+BcWea9334cGIKMpzdqXiJA56R7R9L8jeJhbJENykVH8SVlbLUeqCfsO+yN570bDj04atFFVLxA+5KaD2VYYcRwW1LsUoGEGyil7ABV6FHzdKNVUCbcCnHcI7EG7fIuCFkwXHTraVp/C4uVwx1/+LrftZi6Rk1ZB4efVVeC+CvNwnKriClU6Yls1JzTwEWdkUovYMwKU7d2PPAUYVBkrrawUQ6FGtOgUH6eyTcuF7QDFwKGrbd//7AZaJI6xVk/yHUDNDbCNEXqOtnjP1LUF33dOF8m97u+l59PxBvE4PQbaPMb3G0ViLtMQGwt0Xfc8oLz0+8ynM8HEwT/5cmmQsA0HYPKGc5O4Gem2ejrP3oNKDnc5abxK/fWeKrc7Xhy880uGQ0YwaoIlHjCDxMCFeyzrGVc73t9q4A9pIt5fCjeEgTII4pyI9kMm8gquefczUBAvcSFxzXa1X9RCXsy7GjQ8juj3hlsqNABakQv1mb8ZZnQGyDvri5HcPYnyb9d7mmvfEStDzZHTm+ya+8i0Y2r4n+XPE5t0Qs+fIzZPvkyV8KHFyD25MyJQbIsNgXYkrhzgpwMOY/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 10:17:44 -0800 Chris Li <chrisl@kernel.org> wrote:

> The current commit message describes what changed. This is the most
> critical part of the locking change in this series; it deserves a
> better description of why this new locking protocol is safe to use.

Before this patch, /proc/swaps held swapon_mutex from ->start() to
->stop(). On swapon, the mutex covered publishing si->swap_file, while
swap_device_enable() separately took the write side of swapon_rwsem.

With this patch, swapon sets swap_file, resurrects si->users and makes
the device writable, in that order, in one writer section. /proc/swaps
holds the read side across the walk and skips entries with no swap_file.
On swapoff, the writer clears swap_file before the file is closed: a
reader that saw the file finishes before the writer can clear it, and
a later reader skips the entry.

That protects the proc reader, not all users or the whole teardown.
Users that don't take the rwsem still rely on the live reference;
swapoff kills it, waits for RCU and drains the references before
dismantling their state. I'll spell out those two guarantees in the
commit message.

> The function name can reflect that it is locked. Maybe
> __swap_device_enable_locked()

Great suggestion. I'll rename the helper to __swap_device_enable_locked()
in the next revision.

Thanks,
Lian

