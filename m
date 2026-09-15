Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F6CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DC26B008C; Tue, 15 Sep 2026 10:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE726B0092; Tue, 15 Sep 2026 10:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE026B0096; Tue, 15 Sep 2026 10:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2526B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:49:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5A43C046B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:49:19 +0000 (UTC)
X-FDA: 85216279638.10.990E791
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC8C618000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:49:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YwTt1Am1;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789483757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtxVeAruzSzBSt8uXIvYAlTRCQtPNr3FqdWRr27iP+4=;
	b=dZ/0VUPGwcLzAcHXJXYKjSl48st62TkuH2/MNtfDCb4qNLpAt/q17r6xu/f5CZAhkU8bJy
	DjKUYhKfy9E9WIaIlcrdIQfImtCTWb8bdZxiE4Ujl8jWTt65z/WfiYZYPUwsy0P8opbLwa
	UU0IXRUURMP6EJoBzWc2pB5sceJopfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789483757;
	b=JGt3VK3llHt/gGXPe7u86+gIOYM258B5YDA/BZHcgw4iNdwpHUSwcyeP5VGaSxJCyMmXG1
	L9OT3YDZFyPrArXO8glJ4mLRMaxqi0RdYcxtmc/l1BHirW7B2vv98aqO6+ZgQ0bpluSZUe
	4G535ROT2r+tLhupRelYum/JbGkR16U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YwTt1Am1;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a98604f6b4so4959526a12.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789483756; x=1790088556; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NtxVeAruzSzBSt8uXIvYAlTRCQtPNr3FqdWRr27iP+4=;
        b=YwTt1Am1aQnaJVeeFP6/Zb6pGAGFYWVrEh0vqEXCp+mQq4QxxczN85vn8JxHCuSjXB
         7CvRClyjN4vzrlfySMx2+03FKsSTI8iIMdsgFKEna+RQLDmXMxzXKeDGOTw3AgY+cE44
         nBoZQd1JvjJl6ms5ofHv4mL41OwDuaK9BCoibxryG5A5BBzeQQUM6yLQN0RHXlIES4NT
         Nu3gIA1ZD1b5Qjvw1tUcR7bosPF/obMm0En6Vv9+FDbtyWpQnbQKN2Q8phap7Gq2scec
         YPxYgJXjtdlKA6S5wmld2PQ1BL9jTpshV6wIxxn91bLYnPvWJUEGUFR/bUW+qFP3npiQ
         20/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789483756; x=1790088556;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NtxVeAruzSzBSt8uXIvYAlTRCQtPNr3FqdWRr27iP+4=;
        b=YaIVsBx2RpLpjEVYBcCGQvpRZ/Fi2BvlVQdoFpDdL6IHGBHEBIE2HvIM/0iEPX/kYg
         gYqBzMJmL26aUveF5zSvZ4OXIFwU/qzMY3etV7FkC44KTl5Rxut6tyYljPdgDC4dDskg
         7wjati5yBrGnsnqdz8LlWzl+dUJOVpDL+78Rp6XeiVzeZk/RtnQjOaQsCMk6/SE9ISNk
         YVbj3mFOTXKmgjDQXC8LtslMYm1b4KyrwVQIf8hJtuVAURfXBb6djy0H9bYhv2E1rTPD
         lYkCLuH5JCilEIXFsjwI8ZgcURoA6Pxt3977T4aAEAzXT90Kln1Ql7bUKqR6v1TWXg+x
         MGfw==
X-Forwarded-Encrypted: i=1; AKwUvBykJAzHzV7SCucfwRv/KmfWAItMSHA33JGZNd5PFCshBXngvzh50kdZqu4P0lV4TxjfoeC9tcu80A==@kvack.org
X-Gm-Message-State: AFuF++nDh88BLQTtGojat9E3OuFDHvahz8gzxRvhGofSSsI4Z7o90Gue
	bMcw2plzcCH5047dchCLnzoHY+FsJsPPZzGKGwxutkuX8BdlkzjdAsYb
X-Gm-Gg: AYBFou0OgpyVA1Cw5kloD0y2uvp43Rk60+C7mqn/aeiDss0TjsmUSPZdeRPIDzZqiUU
	z0eGmbMFkoRe6SuWjpSVAHVT6chJicMIxuB+0cuB+A9KPZ1coRIK6ERW0j+NUT8UPWfmijnntjT
	Q8BnH+81MAhPx/BfGZGRe74s7B1dOyuInT19bToNXlGfg601GpI8zdeg4QZf+puNi3AMwM+wOgh
	xDffe1dBE58OeWyKuzhNzZR6unjKqcxxF3lTYtvTXq2DhuJMTfZCMWUfqwDE4F+Kk2hp0Cm4Op6
	MNScb4nUbFZpRU5PTwtAXZ1Tg/hXqaxtE5fLIUoHJb1046v7i4FNVv141oZ3FD8vCcCBf+vTHjR
	RCONZseX4lkYIANeeeW74d15mCgOkcR7z7a0T2wFKB+MtFAwv3cKq8H3b6q8uCXlUK6AxwEyXfb
	ZKOogHCLSmtr2Jhs7odJmu20kj1Hh1yk434W7eJQ==
X-Received: by 2002:a05:6402:a510:20b0:6aa:80c:e67f with SMTP id 4fb4d7f45d1cf-6aa080ce811mr1509941a12.39.1789483756171;
        Tue, 15 Sep 2026 07:49:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9d0ef7228sm4345063a12.9.2026.09.15.07.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 07:49:15 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 15 Sep 2026 16:49:12 +0200
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Shaobo Huang <huangshaobo3@xiaomi.com>
Cc: Shaobo Huang <huangshaobo3@xiaomi.com>, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, akpm@linux-foundation.org,
	david@kernel.org, kees@kernel.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH v2] fork: reset pointer tag of vmapped thread stack
 before vfree
Message-ID: <aqla6CyhEPihIznP@milan>
References: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
 <20260914093300.100495-1-huangshaobo3@xiaomi.com>
 <aqfBDEkiRmlb0WWZ@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqfBDEkiRmlb0WWZ@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC8C618000D
X-Stat-Signature: xq6ymo14s84wmrse4ys81rctjx7bibfi
X-Rspam-User: 
X-HE-Tag: 1789483757-490986
X-HE-Meta: U2FsdGVkX18KnMNmnLQEI68cVRUcO7e2oqftinYN9jzzAHiVuP2wa6qPhrVbfD1R3ID1fEXfKW+mBUtrWbqH1bYJL1uBct6adDrhq9a8n+lgoniaGu7cgIyo4xndJKP4MLxYdDuQsui/IR9kNd+CiqhMpstnbU+ehKsafjv+YAwG4XHt5q+OQBk5cR6RU6jREGaSS6Ct9UZjTPf9KsGcsyL3KDUhFmUmWm/Hyi8KhzgSz5s/j7cFSN6Tq2sQvSiUsZBP8jvUHg/rlYO8zhKxX36OYZOWv8K7cZlUhG8rKNBy8+PVaTzMffj0zlkqMeVm2yuv8PzjjglzVk2UvjIXu4w23jQJWBUo8aG1BA4uwqDavgXLMXEJs9UiWI1gWvP0aURJNcBw6bTEJtnnAkLQvndxdPmOQ7J8cEJ62opNJpdC7JRgDD/E74NSS2uFOc8EM61vmOxlQunUTzztqZ+9Vml9GHmwftKGN8236ARVqiux1hd9vdZzFBuK6lvq5zjCVw1oVb+wDw0JZjwEwNsTpqbqWH2l8D3c5qQoPcgXp/hUniOBSU0lqMaZGgQdByioWtNf2/4e8th50EI2rWH8tSqZAUeEykqE+iZ+acVGWJWZGCji70WPZ21GdCM/i4HXpG6WWtX5mBNAUdbD2ELYIpGSRtN2vETiFm8gBML4rt7u9HP9snkhXLGhf+S7AFoXdKba8dRztHAd4m2SGX0NQldWF3IoF3SDoWfoYRN/zDE+HRKB/ZGsF6JBuqcZZ0VO5LuRU9ldehw5CnyYL6kxEZCPztqc/3AZH5LPKqi6o3OZcDzZ/XzB1ZGJPsrE3JRxW34qBhPveSV2+AMhEixGKwjehRZpzVnXDb3PRmIbU3vY5fapiKfaXV7FKn4bMb/nsBD3YZwo4DsvIc+9q9lK5R4rYaqDzu5qRczWOZzxs1FbS34ffszrr37ev62q9Bqt/q8+0bzL/r9Xsq+idE4
 pzKo5feh
 6gjBQ/Pfn2Ln78xE2DiLtgCkfFaMQCFeUj51Rwu23sfAXo2dnz4AgDbxwRURQFhwcjlTKQC8y+U+s0UfK/oFkOIvsoAHT2FSWtcxSEy1Fk5k2WtIKzJOYjhxXOuCNKQlBHiuJm7VxSPSwti9XSu4nFe8XXr/AXWQ3aGlzcBz0T+0siVb3KEt0XxSqunmvkc+wAeQ2MbGONF/SSya399df/g/NwzuFngehDYbqy+RMy83fNmYz0evPNwaLsw8E2OHYp5d+EkSgeQkIoOpHJNvWxN1jNLN7FgRNqbkP+3hmEXE1Qz/XIdF9FfOSygY/JBZ+SB86YNkgvdYd5ALuHufPBMQj4EwjTAOWgEQzRyjqBt7rGG0OjuxxO+dOVkmsseB2vrwBmu/qvmoZ5jraMq4npKSHP9GOlxOgOgysLuJm1mpvo13S40uErleGRaN+q9m49EOHfiahJb3PPfbeLkFaQ2epah5AGyCkUMxKG6ZH9mng/iDZgmgc8Y87FeaciWQkdS3kJeQECpn8x15myE4he73aVq8cQIb+SbQaGHM5zXxwBkwFGm3NWBpXZmkhrah6uYO1Plste+0E4GpzzcnzQuBVuuT752oBlej8o0qnq817/vg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:44:26AM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc Ulad for vmalloc stuff.
> 
> Please don't send a v2 in-reply-to a v1 or any other email.
> 
> Send the patch entirely separately.
> 
> I really need to write a bot to say this :)...
> 
> On Mon, Sep 14, 2026 at 05:33:00PM +0800, Shaobo Huang wrote:
> > thread_stack_free_rcu() frees the vmalloc'd thread stack via
> > vfree(vm_area->addr).  In RCU callback context, vfree() routes to
> > vfree_atomic(), which calls llist_add((struct llist_node *)addr, ...)
> > and writes 8 bytes to the base of the region being freed.
> >
> > With KASAN_SW_TAGS, vm_area->addr carries a random tag.  If
> > kasan_unpoison_task_stack_below() has rewritten the shadow covering
> > [base, sp] to KASAN_TAG_KERNEL (0xff) -- which it does on every CPU
> > resume for the current task's stack -- the llist_add store checks
> > shadow[base] (0xff) against the pointer tag (random) and reports an
> > invalid-access, although writing to the base of a stack queued for
> > deferred free is legitimate.
> >
> > Reset the pointer tag to KASAN_TAG_KERNEL before vfree() so that
> > kasan_check_range() short-circuits the check, the same way the task
> > accesses its own stack at runtime via sp.  The vmalloc lookup is safe:
> > __find_vmap_area() resets the tag before comparing against va_start.
> >
> > Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return() for KASAN")
> > Cc: stable@vger.kernel.org
> > Assisted-by: zhipuai:glm-5.2
> 
> Thanks for adding this!
> 
> New convention is to say:
> 
> 	Assisted-by: LLM
> 
> Rather than to list the agent.
> 
> See https://docs.kernel.org/process/coding-assistants.html
> 
> > Signed-off-by: Shaobo Huang <huangshaobo3@xiaomi.com>
> 
> Looks reasonable to me so, with nits addressed:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> But I would like Ulad's input on this from vmalloc side.
> 
Makes sense to me even though we do it in the __find_vmap_area()
but we also use an "addr" in other paths.

LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

