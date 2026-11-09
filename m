Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFA2606EE9F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=MzKUDOjY
Received: by kanga.kvack.org (Postfix)
	id 8E1186B05DB; Mon,  9 Nov 2026 11:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B89C6B05DC; Mon,  9 Nov 2026 11:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE5E6B05DD; Mon,  9 Nov 2026 11:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 455456B05DB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:04:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4CE3A0746
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:04:57 +0000 (UTC)
X-FDA: 85416054234.09.BD32752
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F1B740011
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:04:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=MzKUDOjY;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240295;
	b=iAw0pxw/bP4svVkoWQuuJFfBBhKDxtJ5+KupUEdtv1U2WQnm3tn5bzxD9gMCA3e+fss/4C
	atzSz0gYfm+B8Ltrq9SVm+tg7p87uxNGI6rjHtt0xws2o0ogoq/Q0C686iTctFg1vVIt+d
	K5ZEug+yiZKS282BTo6+aGu9LlG7qMA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=MzKUDOjY;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUbKECMWpbH5Hktz2WSMdey09BNdQaJCNvxGCw4T8OU=;
	b=3x+wCCPoXU+vRKaua7Lg6VmrDz+0+YWpylNLPZVHA4h4gAuLabNOjZ5tIQ4YAu6RL5zqsF
	mITatl9SI6HWRRkLoAHjOuVJ5DFb6Fe5V8LgUU1TpKetS/K8MNbKTVSnpjBRdvrunkoDx+
	9fTXrfcBtDApRbgESP9hPIFrAqzTBMg=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4550d8ab15so152808766b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794240294; x=1794845094; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MUbKECMWpbH5Hktz2WSMdey09BNdQaJCNvxGCw4T8OU=;
        b=MzKUDOjYPSizp0Wpekn0MD8WFoFQRuxIe0zI7kghOnbeqSgq7FGKS1+X+4I/cO504x
         qAL0ck1B6CfjJfbQ6xJSeJc1+zOj8DVLltEfvQbxYgasV/USsPzAtipE6RWaX0DJbW7o
         focCCpsM67tudZFZU3plrYQNx5f++9KnOnGDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794240294; x=1794845094;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MUbKECMWpbH5Hktz2WSMdey09BNdQaJCNvxGCw4T8OU=;
        b=tOA7CKQ9UML+G8XapoMSKlQI4Eh1uHes+0wQj955qSsLy9KIphVW7bFJFO11frmbEi
         QAnPqCyBLAuISlDcJD4PR+GexyOuR8zshZVb8xiBWFxaiJeo7oateLgFdo3EDuIefq92
         pge+AXIorEA+BVS9BxmXNMD3rMSBFOZuHnTTEdJXakFm5mau0Ej6wzHlfeHS/r8sMpp0
         tfWz4s1AxrT9MqXOujp+bUa8ECwxCh4O0hXIVqEJrIWFtf82T338LZhwsGk47AC866Pg
         gwwihpKmAo5d3MWinRR+JyyPHl5/+jCsh/BJiv4JuA2Id3Eh8mlvArAAMBhh9zqLtHV5
         5EFQ==
X-Forwarded-Encrypted: i=1; AL+hErF84y+M0GlEMNObrCJmJ7RsLfatWxqZwVLm1zeMlocVqGNcY7uyNkJjo+HKaZBSBnRA/ciynNqdTw==@kvack.org
X-Gm-Message-State: APuU4Z+paLOm77npsO8NunRiz+ioqNUeCZqHec87nQK0JsSRQiZ3eSt5
	nmSjqDVSkCGDwoh2FqDC1euyc3sE0WhTXWbuImQCS6lYMPiLH2BZob5OUCzjeaQpbYwwlPQmXvy
	XhN7aa7s=
X-Gm-Gg: AYBFou0805lK4hmfdsNwwPse62g7SasKpaOmGih+MEZZJ3YYKrrhmZjsmMG9ERluhQM
	8f9SalQZhu7py1XOStLvHBJ5juu6TVjpokJdeTgJABY94vVVCYU237MS/niwbcVww8W1RW3pRjv
	FpRrocFNkyZG+Fy2PHzBrsyT9PNPucDpXKgYG75UYO4YmWjQGHVdwCfDZKi13xC3fB8mQDHcwEa
	n3wQiwqdcBMghnunVlFS033EeK6u0uk26amtMLtn3Od6sY+rNi5RRV/YUg0lM7bkf9XOpdQrdt1
	UOamUNJt6+nGc0l9QVZVwi335hjPGDsiYRo+/YaJcru1ZznjOjGlb+9w1kV8uBG7Oy4G1/7YLHN
	jzaVgwLp7ZzK3x5fp0QakmCxmiH5BKr6qTAgsWrzHu39JiV7q0KZdQOsAIgz/cZcRD2r0g/Saz0
	L8IQAFaHdjL1SBH9ojDG8E/amh0x8qRlZ8dPJOJNB/aLai9jXgTmOJXg6jG1DutdasZ+A0nZJ4A
	2VcOZaxextMY80ZUgG/T4nZP3dWtr9a8EC12hBLwoU5Qgd83fiLF6itvmtshFXPNWvsQOTJaPLT
	3F9SiM9JXzoXLUZouyn2/K8jVHQW8Mh8tuC075JvCpw8Xa1MGTEzc2ZJsbFZlH4/6Tv3XzmFdTQ
	ySxUVscZw86OitRS4QSJHuJo=
X-Received: by 2002:a17:907:1ca1:b0:c4c:b681:38b2 with SMTP id a640c23a62f3a-c4d6d4f2e14mr309760366b.19.1794240293859;
        Mon, 09 Nov 2026 08:04:53 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d68d53073sm188838566b.7.2026.11.09.08.04.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 08:04:53 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b70d5b07faso1280710a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:04:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEobgBqgIvNg1Lub+f/4ahsiMH3D/lLuglzoDdcbpUC4Ntx32/tfU1fJ5fIbd7pIvkLN93Eqx7Fig==@kvack.org
X-Received: by 2002:a17:907:7f93:b0:c4d:18e2:e66c with SMTP id
 a640c23a62f3a-c4d6d4d1cf2mr342046766b.18.1794239795407; Mon, 09 Nov 2026
 07:56:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130118.2507513-1-kas@kernel.org> <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org> <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
In-Reply-To: <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 07:56:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
X-Gm-Features: AclHuK_KlZ4s0u4OfgGD3UZtJodv62VcuanWvSl4PYVPZCnpCpWEdwdwFyjepNA
Message-ID: <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Luis Chamberlain <mcgrof@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wgr3dymstfb887ygs3gb5sjd94oe5e5y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F1B740011
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794240295-877852
X-HE-Meta: U2FsdGVkX1/tHDn+CVYc/59sTIizjz9DooCZzWIb3+8hw7avmG0Heb6GbJ+zisaZqTY/FP7RYhqDpjztJbpwjcfHVWIZDzEuLl6u+l/qE6BDCuq8A2p87JPuAwM/fk60ebrrMezWPebCcNZMUoSUMW+L8hQGhhllRuN7Zs9iLLnnsI16xUg1lI6TcSjOUjdnFO56ZjkrAPOkg0GIfpZhMvIz4s0E8VoagbDUcSzx0DsYQ0gildWJxvhsk2Z/0uLHVNWqhSQIQITIUTsBiHEkbETzCvz4/ooD6oMmNNRPpmsZOGXiP7zZLbTtldPX/0gEVuxe6PQtFUlaM2jav+Rp4Nzq/UptSb24jqqY6ZDK7REUgZYH/E/TBrza3BLvjO6FzifzxpGS+m6x2zH6pUF7sPrVMVJd20yDkLs1+/9akSEVDLhZAoq7ZwPuKjeGbL3nV9BNYVstMOznkIIyKw1bTkmtyy2GtGShpTwuSk5Od06vk+GYgCIxd6FqX1+2YYZmumVaBWlxOv6nVwRjj055RuOmoQCR+nNK5qP32e/2UWNplM1DVf33qlk3n9tjvOfnngvlXNL9XkKsduZ21ZMkDvYnWmRPD34IWUFgjbxsucbo8ksf9dzjWCilz19hbCKSwclWasOl9oNlyzBmctd84IqJGSq+735TL/VvQTZLkIuVp0MgvO6jAC5dyFmp8oDBLDnr4fFFrowAdkxen+Ro1RgQfEhrtL5bbSjSupWdFndtElFPoxRoPMUbIjuWclIfrKLV3O2bUT/niLsqn2YcaaUrzVSkZ6VpcgXXQ6K2y5kiASeq1R5xQL3G7Ak79aeAlvZslIr7tz4PgQKr62UU8qCV4q7M/t0U8/MS322UdwowtaGPMv/M+Kz3LEReLHzUmhUzFPhcIHHkOp+VCd1xGv6fv/0HzIhv9I2s9XoZQkwob2eqry3Dsk53ZxpZYWk5/uyeAv19iU3Rty/yRD1
 8x3hecEw
 g8HV3zBH5x1a7IqUXr5E567FFtCCIwOK3D6uKl/U6uQ/+A4sUeuzDm7ZK1eibGvApapozIhqztPrG5AACREFHb3jVtD13m022pp9pUmgZcDaeet/jEGszZfFiYorlk5/SSaCO8Ppv9kpEIciakSgbAJ5g5RIhuNyJ2/qW5Xet1T7QrE+SCac9LNO2XW2EkcGxP4UmMmoqwkg3LS19LM6LIEXCRn7601dmmMgDVAn9nOa+yHjjAhJpn7Hclhl1mCA+YzJ7lpNWndZ5tBqObt+eMiqGtUKb+361Ua8lkTIGiWriD5VY8n8of0SxFge+F9o4W8CpuFkGmYKOvRI1cgL5bqBnu3cfJA2rNJy++2QpT/msBqDiUTE8BEnkwI/JBFmU14rjhQgcPGSFBBSn+goGSSpRUKhKm/7IcKXo1kG/JnTuUu5V2PVo5GHsppQ1ffp9AQQSbdz9CZKU4uGNYKbIU/buyHf8BIiMYSi7mj1ZhuiyogKYvJTgTjROzpqB81EkqUfEwsOdV7O7AP9DLEjUwjFiPe4zjMUksFzkAhAoZOZDGzVbfijP9tdvY19/f42rROZHrlW4/ncVljV6hlG1Mk77hZ5f+IA+Vp0if/AdmSt04LZOISN6FZFo3vIFbJSfC7Xpc/i8izo2Rt8s+0JXqobSfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 06:43, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> Can we just rework that code first to have some clear folio freeing path, IOW
> doing this in a folio-specific helper?

I think you're making things worse rather than better.

The whole point was to hook into *one* place: the page freeing.

Trying to make it specific to one special freeing path only makes it
fragile and less obvious, and results in anybody who then uses some
other freeing model to miss the RCU thing.

It also means that suddenly nobody else can use the RCU path for their own uses.

Look at all the kmalloc RCU freeing: it's used all over the place. RCU
has basically taken over the kernel. Every single performance-critical
lock-free area of the kernel wants RCU freeing.

I think trying to corral it into some special case is the last thing
we want to do. It only makes things less potentially useful and more
fragile.

                  Linus

