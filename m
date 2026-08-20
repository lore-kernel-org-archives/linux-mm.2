Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7543C5DF8C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893046B0095; Thu, 20 Aug 2026 00:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844156B0098; Thu, 20 Aug 2026 00:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732A56B009B; Thu, 20 Aug 2026 00:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43B086B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:21:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A46DA1C19DB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:21:11 +0000 (UTC)
X-FDA: 85120347942.02.6E21170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id CBD921C0002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:21:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VliQkWsM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787199669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34TzclDonaRBC/uFBFwYDupP16pmzizlO9UWq1m3bXE=;
	b=E0hDyZ/cNHMElbezXi+nAg/sKePuhwmq6hK05ltKp+FTOOxsMYKnfcysd8SscYqma1pRgC
	f/0S13cB8bNybw00ZRK0b2LLRdu2sNqX8h/zhBN5qM/hotEmkA3lbz7GLrrZs4gCqGaaPs
	hMCs4HabgJpYUH8XSCVknzqmx9K5+gE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VliQkWsM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787199669;
	b=79NU0n7xDdhxqmmw3eblOxvJJoUXJ0kQg3m2Gy9gjoGEF3Cta7rfh51N3dPCJArRNawoIe
	vGxpbBzQgCSTlUC04I8LfPKYdVsp0+J1Z2V40cAo9rROfRUGJGDImJHAs4/KkfujgsuHNa
	GiP8p4aUJpQCF1yJrX7cafB/oBoaaIQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so20533125ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787199668; x=1787804468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34TzclDonaRBC/uFBFwYDupP16pmzizlO9UWq1m3bXE=;
        b=VliQkWsM4XJFNbD2s9BYus8x1ky5Br/wKOlxRC2nrmPwbrsuNpmBuD23WOuu7j8d55
         wyJEP5KhE8dSNEw91/szkb84HdNkUB/JO1KgoBxGXW9zey2/Hy3QjCUBui1shQOj/P1W
         AcGl49gao0qWSzd+69wBHoLjftceKjiigAplonNf9u2Q4gngncHMu4bHmEMsBJvEZxaz
         QZQQ3yIJausWZcaJSpry8JsS1DdrmFUILCKSucHX/98Du3VIzxFS1d46nuvBJX6jMDth
         1CKVjthMsgDUzMsZW4tW9RDXKXgb1uJx/Wn2w64NpqRkZJoo14O3HLzkaWqBhUcTNT4B
         eihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787199668; x=1787804468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=34TzclDonaRBC/uFBFwYDupP16pmzizlO9UWq1m3bXE=;
        b=dZBCvZS5BscA3BoDl3kFaYSddYqefXbQRGfa+hKfPLWqKDakh02VHYcIG9pMb5C03k
         cqkMjlhkAwCeXgNvsigrGplarY1Huok2qQK0KCRZXvnJatLfzoLLO948Dj8s1Nbf40hF
         pXsd5U30BmnLAwEjyR+3XqR54MSIOoZaYdP+NUTivBB2Tz1zg4XCaH9+iqNVwPhQVwh/
         /df/LmbOdCmvT5zD5ppCMJxu44Z5qfDgAE+DYlHBsP1RTHJ8DfEmYkmTCkANMxa5W+qR
         mDXSy1lPrbhu7z+tKWVIOGsW1E19GnucBVzSfJmm3tq0bNKZZadB7gZrdQfCmcUwXZm9
         S7tw==
X-Forwarded-Encrypted: i=1; AHgh+RrGKcBvkoZTc1V7IMzVlwt6g/6KkLy2fo+//JYe8doHe0xYR3JkiG4uTmTOtR1ajfe2FNlpXPwkvw==@kvack.org
X-Gm-Message-State: AFuF++mfSrxIf/UiBgVVr5X6FxqY6RaoIF/VCEkCxpP0kfOGmxzw4aKB
	BIynGass8KXrjaldRQU8C2vUhEoZelVCvA0FdCYJCIojR93+XxRb3UH3
X-Gm-Gg: AR+sD10BBy9wFLk6Ah5z1ROWnfueIkmIJtCViCvQSF64xiedP6S8A5uN+NzwVWb/P32
	rMkHWuLZ5TOzOZn80bYM1LOlEdjNF+puEhkAHzdPgOp0+5Jz0u428n/ciOsJlDTidRRUb4mYlNP
	h/BXZEEgIiIlMs61qKWeBqs5QfjmlNyJpeBGucZHOLHQr5hsFFivhoLbMBg4AHy7NOPAvhVrN6X
	Q8t1vZzXHAh7E5k4kkehl5C/0eeUium6bUY+KZmcxtkKj3g71N8ZZ/jfS/LwfdR1ULwoFFu0hdV
	1yjjWxROmxkw+tjMcSyRDhOgFnXkvnyRZDSKv2ezsKnljcLk1aZ1szXRmkNO23ULTBGZgPGUeCu
	QFXk9n6c+7oyQTFXYcuh15YeRlRRdpDmI+8xvN2I+WEKlAb4HjatT6ua5NgEs2Tb/b33gmNL3TY
	2ilMyXYlvuMjbt2tHEcGOcT0g6iclAhRvcN1oX55hrqZxhTiaEb5TR+mUco428zM8wiJ7LWe4Lc
	huaWWI=
X-Received: by 2002:a17:90b:1e49:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-39580f6c037mr16864194a91.10.1787199667842;
        Wed, 19 Aug 2026 21:21:07 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395a9e1d336sm349605a91.1.2026.08.19.21.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 21:21:07 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
Date: Thu, 20 Aug 2026 12:19:38 +0800
Message-ID: <20260820041940.443214-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806184254.3790858-3-nphamcs@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBD921C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 3szycuzakmz63gjfoms64ppqbkxsc9uf
X-HE-Tag: 1787199669-178598
X-HE-Meta: U2FsdGVkX19fl1ylamRzh1dsyG0gP2AYNr4WM7F4qcflv6YdYq+DsQkHz2Y1bPgVUQ4bDw5v1G93f4x93RDdcg+TAqBmf02vBgX981/o5/xzPNG5MihoMGXMv9CXCc2rsoN2HLkfHwP63WWblw1E+3GosPFcZfuhqLmH0LdaweSzeVf0A2jk2Gs/6OG0gHspbN7z7Q8TC6NpJGdACxypdFhED3rMg7WhCaopiCK/8MEAUcc+9qaHnSq/zdtDpqTb87iA0buaM39/W4RROxTYaFB37SxzK1TDtRE0WjAklef061Q9zV8ETWtCRInGUx0Su3jHIxc1jWlgnIH8mykJqb7ywao2oFm5bNruxjJ6J7UZP/0A7oyNn+ZcxhYYwxwfQCOO6Obvh6wywx0u2OJN75qBiJb4RdLXFxwcQoNQHvfsw3BUuIzH0aUsrHbfDeyMLUbLn9GO287rKamIiAZ7JOXuNBTWEJ+uOqERbwnzAJ4Uk48PxtLqNyLFJKO0Ecs5WzhXhT7+h8vCYIOOusVBiWFe4UTqLvVqHt0thN6ka11C/t9+Xa8a/7RHQeyk0x/1GKuYM00uumPhL6RQbolZ3MUbeJ0iLss4UzAaP3cDk9qRmihXeM+YJQXeWTYEtkDz3EXnPLCuOuCXMjJ3Om5B9/AWuCrqlqqxvZ7lAqKmasfsYny700M5XPaOpsSG3Zyu8qDL6sAUo83+LYyj2MYHjD/D52LptPr6HObR7sykGynNkRo6EGRZFOfWgNI7J4yQcMulCaVaJEZkArkYOzG2lDk7iBF4Pf6kIuBbSrOKaeHp0YPgeica7EqE1mfeKcpnrZIdIVNcbY/UTNO02QZpuvoDRYPxtVSsvQR0aa80yKEBNLKHHCje+2NszrqhKtnKG8whfyKN0LXqm549CKElhaeoEpQcVxLhevWKCbkEXzk7Gt+aN+U7TGfJNrbXo4ddYcwiK3G8zWwX1NNn9Xv
 6mdBiqQs
 8mut6zm/uVyYr30i9WIZ1z50DQ0uYKXZkrS1UlkWCXkgvHNq413ayc5RSRCyF6Auph0J2CcR6+kxy4yg/jJY+F5sf9W8OrxhX1ADjbz98VBnWIU/PgjrnpLnKefZEkz40qfjmZ3j1I1RY0m4qdi4wsILk1UaRB0OfQQNRwk0qe6Gg0KAioDzmpBCE+whSUVP9TuwzbbP0vxRGL8NGPvho6/2euc9jrUqeZpMlNIglToTRwQHLvE9l4M2O+Uvhy1j8gLNm7/lN45AsM5VbcVA0TxHnKeEwzk3DckRYot5ihAnSpHwS4i8G4UNW7mJ2UzDrIjMw55fYwyVyzxwzfA3lLKv+1lrgfLchr3GAsEKoWO5qEKFopVJCZWtq9tQuM3p4ir1Nyxvhq8NZ4tX6vO//pWy4Sb/bda82+LH/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 11:42:45 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

Hi Nhat,
[...]
syzbot reported a NULL dereference in the v3 series:

  __vtable_get()
    vswap_to_phys()
      swap_entry_backend_has_flag()

Seems like the underlying issue is introduced by this patch's
`virtual_table` lifetime management.

This patch adds:

> @@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
>       struct swap_cluster_info ci;
>       unsigned int index;             /* for cluster_index() */
>       struct rcu_head rcu;
> +     atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
>  };

[...]

while the read side does:

> +static inline unsigned long __vtable_get(struct swap_cluster_info_dynamic *ci_dyn,
> +                                      unsigned int off)
> +{
> +     VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
> +     return atomic_long_read(&ci_dyn->virtual_table[off]);
> +}
> +

`atomic_long_read()` only makes the access atomic; it does not protect
the lifetime of the allocation being accessed.

[...]

> +static inline void vswap_cluster_free_vtable(struct swap_cluster_info *ci)
> +{
> +     struct swap_cluster_info_dynamic *ci_dyn;
> +

and frees it synchronously:

> +     ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
> +     kfree(ci_dyn->virtual_table);
> +     ci_dyn->virtual_table = NULL;
> +}
> +

The existing `ci->table` already has an RCU-aware lifetime: readers use
the corresponding RCU access rules, and the storage is not freed until
after the appropriate grace period. `virtual_table` introduced here does
not have an equivalent lifetime rule.

The syzbot crash shows that the current teardown/read-side synchronization
is insufficient: `__vtable_get()` can observe a torn-down
`virtual_table` and dereference NULL.

I don't think a NULL check in `__vtable_get()` alone would be the right
fix. The NULL dereference is a symptom of the missing lifetime guarantee.
`virtual_table` needs to remain valid for as long as a reader can reach
and access the corresponding dynamic cluster.

It probably makes sense to make `virtual_table` follow the same lifetime
scheme as the existing cluster table, or otherwise tie its freeing to the
lifetime of `swap_cluster_info_dynamic`.

[...]


Thanks,
KunWu

