Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2311606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VmglFaZb
Received: by kanga.kvack.org (Postfix)
	id CF9186B0B97; Fri, 23 Oct 2026 11:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0976B0B98; Fri, 23 Oct 2026 11:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE73A6B0B99; Fri, 23 Oct 2026 11:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86F5F6B0B97
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:58:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0A7D120184
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:58:26 +0000 (UTC)
X-FDA: 85354348212.07.410525D
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id DFF6D40004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:58:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VmglFaZb;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792771104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oR8WsW0STYE/yZ/T3jtIUfWqW3IPmySlmYoCN5YBLrk=;
	b=uKQdA6Eug7I7stjX4DzYglxpISkVwiVyO6Q4dkOZw2nj1v+sEnIKJFowHHOYZ27nHoUrKB
	Q3ZBbvyYAfbKyhcexVkPAHdmxIVykk0rN+QxiYTd619SsxDXPqVgjMNSQSvV3i/QaxPpMD
	NSPfqemBOqvjep9BZ48+tbBgGypaXh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792771104;
	b=bfDQ9XHz/CmiSQXdZaOdlZUFLR2yLqaQ5v7uONJp6rvxgI6NiR2VwLwNLY0ivsrMB08Dxv
	OHrlj7vgWBOQLu5nZM2RhpkP+Mvhl7Ls2DTX0J96jbKW2E7JDlfCzgQBRmWy4MzXueV9MF
	Yq0mZyH34+rKGkRZ7MgFjZtC1mx09Pg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VmglFaZb;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd8ca57ef64so65825a12.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792771104; x=1793375904; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oR8WsW0STYE/yZ/T3jtIUfWqW3IPmySlmYoCN5YBLrk=;
        b=VmglFaZbDOsf8V/813HXxCu9g9PN+h5FyK0bB7jMQGd0I/3jbNfNuDM2x/K83KUAtp
         PwXKSLtqTK1FnqQTTrgW0v6rcy3GAJoSt6Juuvg63gYE9zvJSso8goLWJX8d7Zp6o+uP
         d0PMQoUpfyZ98bSicqWJu8LBk1d9fY6jBXykMGih+SwwU3xkgmTVzz5/QebqKvFbkNyJ
         fj9WkYk3/5Kr6cLPt5aXLZQ3atRg0ZLqevmHIN3jD+XPajcba0FtT+PUsCXeNFeXKDuC
         pSKQvTj+Ke3oavuG1cMJB19ZZZEsUGWHheF6qPspkz9k2mU/fsFZT4OB9Y/7hnUypNpd
         bipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792771104; x=1793375904;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oR8WsW0STYE/yZ/T3jtIUfWqW3IPmySlmYoCN5YBLrk=;
        b=0XMlCKc5jmAz6UR7YAARYQFaALHjonRaIzbVgKMXiWpHhLxLysgd50r/3grB3xW9yD
         qlvCq8EqiFfcn7g1xF93vSE+AVcLHH3Kd60TP1JFA1ULEkRtz9vwqcN1qprZE/iZppg2
         ik57KYOcNxIHrigQ+sN4t/0kbOW/vOIlIKK3INSBXaiy5X3Rp14lwbC+6g7/GNwhkJ5H
         ATzo75CVKm663YIrF8i+L7CEQ0J68NdRW0ZSO3Ay+4sHuG2JXqmB2vSwUGFHYHi3XZKv
         vV3cUBq5D3VfWE+cpgvpBvcFedu+FT/yVwN29Dj3comfi0zPZn09i/SZkbPtqt3DmdJS
         Y97g==
X-Forwarded-Encrypted: i=1; AKwUvBwqdv6c1FFBV5u2phk7uQYhe9kMvDrXZsavwvG732z7jGA+DaPPR7H5560frfD4nQIaT8uJjXc3JA==@kvack.org
X-Gm-Message-State: AFq9FYIc1bwMcgHfzHXzRkdG9MA76Q3+1pu1esu2ic/6poS+l8T/uh3q
	dR4x84BPz/DT8WeU/v/uZtij0yW1zcSITpFVE0y+56y0B2KppGcIIEql
X-Gm-Gg: AYBFou2cdOg658hNF6Mp7YAhdLxzqWTODUmGABWHC2gabgUgv16ZtcNJpY3zDoabH37
	1G2Z5SGlsZWZgcMi2zTdDERUvZD4VkcKGJ0wvVe8zWPOT7slDeGwY9Zx5nJzC6nLFY3S0utWCla
	ctRn/pUp85ovPOTs5OAQqw0XxDmGLnFh2cLzr5rwF6gYYWER5mp6FrBxvq3/wHS3y1MRnaCqV9Z
	vTLdVr1ujc3gMONwjMhwPBma635/1kyubxwr18p9qdE+iMqukyI/hqTo6WzxrL+n93OC0eRRMAM
	hz66SU9AFQjVRAfmxkSJ2x7Tguso4yrMsyfbzMDffFzeLsAhHFxb7Cd91RKsX+jc1rgbnv1a4c1
	QvovO5kZ/cWFMYfyJIvbSbbPdDsJ9Y9HOzIFaHWvul9GdnKQEezIXOw3MnmDeIz56BnVQqmg+ST
	MNzJQmEbxzVPoznFww2WHoqupuXRNX4XzyoLyNXIBcX4xiNLieAarzbSNuG6sn7JUHurAiXdrOV
	eahTM13zp5Au66KX23q60295q9/eGlZEKML9G6QvGHp7rGKhW82deBml0YzeX4BQbi5cQ2bbEfu
	Zx42SDXwL13Z25BunSQ2QbAy08ZuEnbT3uEHsHnhplTGKQNOPphl+R1kyk2b
X-Received: by 2002:a17:90b:3e48:b0:3ab:8288:b8ce with SMTP id 98e67ed59e1d1-3adce7398c5mr1635912a91.24.1792771103440;
        Fri, 23 Oct 2026 08:58:23 -0700 (PDT)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3addd84b1basm707058a91.14.2026.10.23.08.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 08:58:23 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Oct 2026 15:58:22 +0000
Message-Id: <DMCCBEPCIWH0.2JEDKE64WPJRQ@gmail.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "zhen.ni" <zhen.ni@easystack.cn>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <martin.lau@linux.dev>, <song@kernel.org>, <yonghong.song@linux.dev>,
 <jolsa@kernel.org>, <emil@etsalapatis.com>, <ihor.solodrai@linux.dev>,
 <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <shuah@kernel.org>
In-Reply-To: <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn> <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com> <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFF6D40004
X-Stat-Signature: 4sk6jagt7ejy6w7fc1nbuios3dbdrw79
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792771104-992717
X-HE-Meta: U2FsdGVkX1/uz7lSVFJuPfTIzSXibsHd5O9CYNHnL7P9jbvH4+bdpzetGQeoWo9vDhARivGXXAaQWzdSf48yAYtx22oDywRkjM5VSuX7j5La9K0MUZqUEYseDN/BSUw2LQWa7oKJ0Bxy9Gvbz6P5z6qHwuJBGHmY2Cc4QzwfBctyKfii3J75FqM4Od0hzT9gs29wpaairsP4i9k/FlcmxARtb8gbq5C6tqCDrBoqGN+ovAgfgFq3M/kQxfNUjPBxzaQ0xlv5w3rgNoKOmB+tJPcTtSlBwtYYxjVIa8boTKCPz2W3r6GCnO9eSHAOs3wlmuWvrU9MCJVi8G3bk3D5LSoFa88PfbREm9ZYpnDeZOJVo5MrOQ0bP75UbQUHHukDDjMpTM03phyI6Ib0mgxR4zACewAzf07qKIRVTDn/ADr6NcPpw7b4culf2KGTmDDM/ZesFxNpX80lEWXlMSVUvq6GZsr9Kl91HFCoC56+QYFek1GkbGI84cCyezuALSiwShdum+cAZYw+ic+sQCJM193Abyrw43JWlnqpcljlsj4rObxCXCUKW+9MER4Dp1k3OgOGFhT2IhITxEhzam2/DaWxdARbfVRBxfgfwcmCgCr9ro4Hv6ycJbz9z6No29JFbWmpJdXl7kW0VrEE8leMpv4Zo1MY7YhTcT29u62FzSkQVkFJpKrjWPhGgQTD4PT3oXNkp2AZMjHCQskYbt5AtR3Xelc+WNP8UT5C1YZunR3irXDK4+K66uzdJHgNYjhvy4LEDrpnIfLdfBuTKDTjwGcdqxP3R4UtsDumapFzRmuWEzGQE3UMvQum4+PXFwj35cYdRIQQrEzxGF51m+mGTlQeJLHqf3U9ak/h1hpaRvS4NIHsBMrHLkWsHI+XTB0k2FI8aAjEMwnSIlC19xsBq0Ua6/Xuzvgw0pBEuOXrEmwWA3qOuv8rd4+JDkTP0NcequVNUQSd9wm2W5S3CMk
 X8rz6B7T
 ZHg5pYuF0ZziPxTBbomuP3Vscmjm1FrcbaCwB6nteYtRpBtUAXlE4GQoWEzcBmObvOHCMg62Tbs/acNzNv+JkZbFYDAt99p1+K13Ujysy8pQbe3OuxfI+WlcEwpugIv+c2OUsfq1SZLTRhDTVR6OPPbsNwUex9mqT5bQ4trwDzjotLcDwhsl551mwL8B38WUXnweR8x9pqUp1KSiUGjizY4WVT/Ry8MoHLZ3ZnIt+LQfDvWI1eBuRlcyeIAWrb8WCMurK+5uTLkktCgZqxL8l4cNrSD7Xxzbdtm1sLWNcPs/FBv3jI14XSSqaKxiT/Zfl3ULSNfONIx6YD67tesftbGXIknA0FB0YJ43GHJAlNzOfzAu2h5KqluWp4ETEe48cK7RW3rOSaE3vDgj+Rot6DP4b9OvEspyaGZPhm8XO52obXHYNmKe3klNRS6llHXNmNAYQO29cSxy2svsABYx4+Erw2FIJq/6ocbU/+/uTRNfI4zrSj3rl6VYgViTPNgLq1yn04kWG4aDxYfKdy2M2iu+JZh2q0sGyKrP/hijaIBibP6HD6I3DKJYZBM5VkkNmFauDClQn5tVKFtvjjpNTgXh8yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 07:51 AM zhen.ni <zhen.ni@easystack.cn> wrote:

tldr: it's still nack

> underlying iteration logic. This shape is also what Documentation/bpf/
> bpf_iterators.rst prescribes:
>
> When adding a new BPF iterator program, it is expected that similar
> functionality will be added as open-coded iterator for maximum
> flexibility.

It says what to do when an iterator is added. It doesn't say that
one is needed.
Iterators are for kernel data structures that a prog cannot walk
on its own: tasks, cgroups, kmem_caches.
pfn is a number. bpf_for() is the iterator.

> 1. What range to scan. Where do ctx->start and ctx->nr come from? No
> in-tree iterator context provides them, and a prog cannot derive them:
> min_low_pfn..max_pfn, memblock holes, and offline sections are all
> kernel state. The loop bounds alone require either another kfunc or a
> kernel-side walk — which is exactly what the iter target already is.

From user space. It's a syscall prog, like scan_open_coded() in your
patch 7. Its ctx is what user space passes in ctx_in.
/proc/zoneinfo has start_pfn and spanned for every zone.
In holes and offline sections pfn_to_online_page() returns NULL
and bpf_page_owner_read() returns -ENOENT.

> 2. What makes a page eligible. The alignment test in the sketch is the
> only part the kernel agrees is expressible in a prog. Everything before
> it reads state a prog doesn’t have a handle to: pfn_valid() over
> MAX_ORDER_NR_PAGES areas, pfn_to_online_page() under get_online_mems(),
> skip_buddy_pages(), the PAGE_EXT_OWNER / PAGE_EXT_OWNER_ALLOCATED flags
> in page_ext, and taking the record snapshot inside the RCU window so the
> checked value and the reported value are the same copy.

bpf_page_owner_read() in the diff does all of that:
pfn_to_online_page(), page_ext_get(), PAGE_EXT_OWNER_ALLOCATED check
and the copy of the record before page_ext_put().
PAGE_EXT_OWNER is set together with PAGE_EXT_OWNER_ALLOCATED and it's
never cleared. No need to check both.
__reset_page_owner() clears PAGE_EXT_OWNER_ALLOCATED, so
skip_buddy_pages() and MAX_ORDER_NR_PAGES steps only make the walk
faster. They don't change what is eligible.

> 3. The walk is deliberately lockless, so exposing struct page to the
> prog is not safe. The pfn validity check and the page_ext dereference
> must happen under the same kernel-controlled RCU window. Otherwise the

The prog doesn't see struct page or page_ext. It passes a pfn and gets
a copy of the record. The lookup, the check and the copy are in one RCU
section inside the kfunc. offline_page_ext() does synchronize_rcu()
before freeing page_ext.
page_ext_from_phys() does the same lookup from any context.

> 4. One record doesn’t give the prog the useful data. The record holds
> only opaque handle/free_handle tokens; stack-depot resolution exists
> solely in the kernel. The memcg is neither in the record nor trivially
> reachable — the path is built by cgroup_path() walking the kernfs parent
> chain. The NUMA node comes from page_owner_get_nid(), which bypasses
> page_to_nid()’s poison check. And so on.

The handle is the key to filter and aggregate by.
page_owner_stacks/show_stacks_handles maps handles to stacks.
Same for memcg. bpf_page_cgroup_ino() in the diff returns the id.
st_ino of the cgroup directory is that id.

