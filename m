Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97A8D58CB1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 06:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDD46B0089; Mon, 23 Mar 2026 02:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5846B008A; Mon, 23 Mar 2026 02:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4137B6B008C; Mon, 23 Mar 2026 02:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34D466B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:30:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C41531A0A19
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:30:44 +0000 (UTC)
X-FDA: 84576354408.21.C4D3B98
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id E16C6180011
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:30:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c84Ha6Z+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774247442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfshNWm4BMQcDqyrgiNfOarm7/9PI1bREMk24l92OB0=;
	b=2u+f4bQWBhTZhGoF+j0BkCN/Oz1CZ3hkTTDA2OEFT6cpqXUdyo4hTMW0lYhU5nJCi932zU
	UwwtWZCO4ZZbJjCzT4eeL+tqin1C1Ohy6+/imcN9FRhThFUrbOHcIAusiEKvTRNoW6dDyj
	di3igkctU4r+zqAXyiVSJH8MNUJ5MPs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774247442; a=rsa-sha256;
	cv=pass;
	b=aMldn0q5phEFi/WfvWEQ6tEiGkzVoGvTQNkPHAWsdhFMHGc9kKEncmUPHvnHw/Djge1rFh
	tMLsYd1yBHw8nXHP7+9/77/bMqTPH8pLsrtN9cJejIKhxmY+SDwhiS/+SqeEKnB4qK3gQ2
	gFiy3Uqh2SHP4FxT2004FjTG12n4NQw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c84Ha6Z+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4648447e29bso611139b6e.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774247442; cv=none;
        d=google.com; s=arc-20240605;
        b=B1tk1KQfYex60uJdnXXhjtuzX77BSzSrnIFKz6L6RVQlL2yen3h+LfOzcG0Nf6tp30
         mm4HfSi+QVmnMOWlJxVDdQs+b4YqfUKemMRX6dyc4KTvPZG3CHCxJMxrVZ0pJ13bOUCi
         HqdFeqOfKTQivk8iF8SXyBHZ09m8w0+pfy3o6MroTQ3B86VQjHToEbmzh4oJWMQm9pPl
         PG/Ejj7ud8pJdVG31hnA2NAWZUDHDem5KsiIy6imruwtvHm//hkGNAORpcO9BsE1qMJA
         +BIyrwB/vWh9hSDnoW9y2khyLVkEnccJbGO+bfdKQlDWgxarJf4z0PBxDnOFNYYnwQ4J
         7tig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dfshNWm4BMQcDqyrgiNfOarm7/9PI1bREMk24l92OB0=;
        fh=eqV7ql3OHdMYm83doEAzb7joZkZz5MQB9Jy6jAsowHw=;
        b=BzG4tZYkt/Crc2qPyO4rN+vW68dIlAc3oTTdELu3AIJfGZio9PhgUGHlf8JEUICmRB
         uA0KaIBG0ZsBeB4BrpJr3+Db9m4DVef+BQOqM52aWhr+9fRoYs3mY/FAeU6KQY+bK3VW
         yAG8AgLtxDxLa1GOBE3TuIVfSDjsp+Nlu8P8hBSjJhTvpDV6z5Ba7XmitRRrn8PjwPgJ
         FoY+AyBvCbR9tnzUmZHh9w/4qZDkruHe+wujItV06jKG+zBDsPbwWo5QHxgq8J5uF9EP
         8cw9mroIZjUPVuL+/ANMGJ76GL1n2zvLMFR0ceUjCNz7lOUNDUeAFREK5jimAMd6CyHG
         A/vA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774247442; x=1774852242; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dfshNWm4BMQcDqyrgiNfOarm7/9PI1bREMk24l92OB0=;
        b=c84Ha6Z+6rDvHA+5Vo/2cF01NBqbKi6pma43TDYW0yJX5P6yXxndvFFFALdMx02/IN
         u7MJCPd6F5iRI2MWWYth+RYWH6WCAxIAqXOcPmbzskfs2wmCybSoK2SYqZBgzDJELblq
         lZbULL0mzCqQtp5cYkXxWgAL+M+WrzVXjgaUwqSzl9ncYWmMFCAnnlV0cJMoDkEXHLKQ
         /j8jEDm6qpxTmzxvxQ3QwQYsrgj5xPc0CiaTF4egh7jGwOLbf/Z0AAmZkPhjWc8e67cR
         P6wVHgLzMododuyDf32478nbLohRPHsT97DSgbMdU7o1JTjvd7bBKrcdVcXbkIH6+pXM
         DZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774247442; x=1774852242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfshNWm4BMQcDqyrgiNfOarm7/9PI1bREMk24l92OB0=;
        b=jLhEZDS4q8d+EAxhLQwumN1/oiGswsSOzfe37AFnxhUKZUTFAjado1Caz0PVC2BJIv
         qoFDxUUxtUmmkSSA7yBWpqhBKWKqgINtWRnvVP5DS8SreGXSC5YQ9TrR1mMrNuxMX5+5
         z2z8+yu4ZG0hEHVm+8BFP4sVlNkygiwLh3h7CsrEy90Ogy/8EdUnHlP8jkuk4JirSIIp
         SLkWZcE0azhR888wNQObTvlN2oNgiNJqypk5F3MEBYFLBxTSUrdxyqz4DSvFmcG/Uw68
         LykN3BiUm4GpMC+O2q0g6eWG01anZy8z1L+aza5gDk3mGtfVDq5HMHz3twA882vOeJ+R
         xKHQ==
X-Gm-Message-State: AOJu0YycZvaxBJCm0m3fvn6BLKQcb655A+SihLFCX1bvIwyCpt2gkwE2
	PpFZZ2mtQV/3D6ClN1fDjo5h1KyfG1wIWcuWFGTxiNgt8FAJM4d/q9H7w+HPIAyUydu3omNRFUD
	Xjzy+ZGqHa8icH6lPD/jtPrgYiYLq9cE=
X-Gm-Gg: ATEYQzxyfIYzA7SftuIaBu9LdWNbEe0JiLH5gSUn5J+WklqSaramflcXsEK3pJeXR9/
	sLP5owbsVkRfwTIPwKtZJ0lvZ/dfIs9OiJttaBB9zSrsAYvo/BFY6kZp+teZz63Qr909yFrMYtW
	Hj503fCaW4U3s99KqdFUw0qBmN5l4QwndtoM08U3jLBQ79x3me34S7u9G7Tph2+IGHjCw2myQAB
	ahbTHqhMv+55zH9nYnJkWxSr4AJAVqAW0s8r0VRuNkMSyTRtOhHUxf84PsXbwXxN7Yzn7id5gTB
	lcJfa0+9lCTZdIY68wlQykdcQJRQo2qRT/0tJA==
X-Received: by 2002:a05:6808:1809:b0:468:6a2:897 with SMTP id
 5614622812f47-46806a20c3emr3495836b6e.6.1774247441821; Sun, 22 Mar 2026
 23:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260323062846.6262-1-devnexen@gmail.com>
In-Reply-To: <20260323062846.6262-1-devnexen@gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Mon, 23 Mar 2026 06:30:31 +0000
X-Gm-Features: AaiRm52tAxaSOuJ5g96MWiVIIk_1mC1zx6LC4Lw7UjxEOO1Z_m9bJRyDOiEVO3k
Message-ID: <CA+XhMqx-SvSs3J0ZkOXtZ2h=pGNHK1NM=pYYhG-WRn5wVn0zyw@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online()
 error path
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E16C6180011
X-Stat-Signature: 455njrkqo66umkx5u1whc5acb1jshwje
X-Rspam-User: 
X-HE-Tag: 1774247442-343365
X-HE-Meta: U2FsdGVkX18N4JR/4Y8otZ3oD3/lUyB1U4cXI3uA5w9FAkNZiXL+YN5yyihL9FmgScWrhnyasISPvlVX5fJ+H81isBOGZTGLjXgsLi9p9XaMix4x6Dv4nR92Y2hCeipVmZmm4Oe6i2ChtlsbbBIHdd5BUB6pkpKG1FyCe0f6gRy8H25sHGW2WCfLTNbgGR6hG2Lew0N9a/Daw2wqthyO/VQyf07VrSBAo128SPnZzf6aVIeXkTG49oUCWWvtHt9GVvD+B0J5VJrz0cLXHaJgbU3XUHW7wLJkCDiFffXvAytzdiXQxDp5uTSmRSIuqDrENrDdJirlweHBHrMRYDVG4+97yO59r0J3j2m0xGaVXyjqV5uc9MorBGR47ugRKpkFXuA9ui8UNWRlcgoMXE1BVAHqPVJjrAZEn9WgpOXD9YyQ2LlS7b+hOk0ZpDOCAw9bwlcPnIR4inYD+pu/hqvhKZq/y6YNFKcXKSFd2OjkXPrNYJltFdKrP7fr5VUrPPrx3diJk7KZMbnwP9vTNerzefO6D53jJuz1vvtXey/6lo3HV0HBgFzOqN8tYvRnPE/ii/5oxM4Q/qiH5Ut79WVW+n7G103gYI28reqvap4uu59iVeLR52MTWJzz8UvNiwExvkUjBKNJKyyCXGapMOwsAOrYrha3CPzOqklbgfivuqXsY5z+7t5urTE8uPfBETmflAuX9vF1XtirLwj9UQFO8ndMSetftxaRN4oujDqpfNcS8DwIbXR0i0C4mhMNRNRinAMVjkpPSG9NPZEcv6YEiP+AIu3o10l0+bzDGtmIO0RLl5Za2H/JSlOToOWi1+LC25BVlRTzyz5yz24ELSJWA5BvM9Mg4cIKYzv6nQpzx0VL2ESTj26my122olSK686gFtaEiv9gA1lxaShRmdt+Rt/3fBRyu/K7JpgqsViJeaY/ONnnRJWJJFJK5Gk+UukWnQ36hSTolfmYe8C6Bmn
 +3gI0IOM
 qQxXJehld8J/hU7vHxfsfXa/jHdqbAw8Sdk7Wkqujc1ZKEIaV86nfcxywyqMvV5+Y6hlaGhWSKFkp8shNPZuMT1Et64KtcDfgGMbyFiTsBUJrDnymnmHncSIKVb44xjRjlBAANgm5FsJAOu++kKamF68r3sC2Z/wAUl3t2RdzFbyrVRA8D/wCo+Fl9OAsCS3LoHAFQKLb6WLjVcukOoqXpuAi0DTidkOQKn08RVm0IFk/alYzh6ZPeO6ZFQQjFyw6Jbb8H/F+zWtLnTraULzrZpYTmSIyoJCwyqB7A9/88JKQ+m7w2ZO5o/pJu8IptB0h6paKsOZyBYXcyjs703dM5WaTrnyATOICrxdKVU8GojgD79N/pVyJMTEIAFxrvaWSLJzc9JhzQRugUR+mUTUNALP0UXRPtu+AS+NN/2JA+xHHJsn2c+4bVj9zav5A312OTnSGl7s6nyLnuY1HttW+4GXr4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

please ignore I resent to the same subject

On Mon, 23 Mar 2026 at 06:28, David Carlier <devnexen@gmail.com> wrote:
>
> When obj_cgroup_alloc() fails partway through the NUMA node loop in
> mem_cgroup_css_online(), the free_objcg error path drops the extra
> reference held by pn->orig_objcg but never kills the initial percpu_ref
> from obj_cgroup_alloc() stored in pn->objcg.
>
> Since css_offline is never called when css_online fails,
> memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> normally drops this initial reference never executes. The obj_cgroup and
> its per-cpu ref allocations are leaked.
>
> Clear pn->objcg via rcu_replace_pointer() and add the missing
> percpu_ref_kill() in the error path, matching the normal teardown
> sequence in memcg_reparent_objcgs().
>
> Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
> pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
> through the node loop in mem_cgroup_alloc().
>
> Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..e361f42464ef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3936,6 +3936,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
>
>         for_each_node(node) {
>                 struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
> +               if (!pn)
> +                       continue;
>
>                 obj_cgroup_put(pn->orig_objcg);
>                 free_mem_cgroup_per_node_info(pn);
> @@ -4137,8 +4139,12 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  free_objcg:
>         for_each_node(nid) {
>                 struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> +               objcg = rcu_replace_pointer(pn->objcg, NULL, true);
> +
> +               if (objcg)
> +                       percpu_ref_kill(&objcg->refcnt);
>
> -               if (pn && pn->orig_objcg) {
> +               if (pn->orig_objcg) {
>                         obj_cgroup_put(pn->orig_objcg);
>                         /*
>                          * Reset pn->orig_objcg to NULL to prevent
> --
> 2.53.0
>

