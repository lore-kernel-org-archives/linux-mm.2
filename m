Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486F5CAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE638E0007; Fri, 26 Sep 2025 20:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EB08E0001; Fri, 26 Sep 2025 20:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DF38E0007; Fri, 26 Sep 2025 20:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF458E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:07:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2478B13BC57
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:07:02 +0000 (UTC)
X-FDA: 83933089884.08.7C11CB8
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CFB7140002
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:06:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NrunUux+;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758931619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29URIb6wX4cuu5zaywUpqrFkDEdk6T+tY2Shq6upRwU=;
	b=FapMKXPXluPhcZkE4+dgb2MJNk0rpC5OTIUak+EbfNwqIM8Gx+L+VNlYT//q2GEp/TVOx2
	zIXpKR6G0rdj0wChLOCZM44m7nJG88CyrKPoQfeiSq+gSkspU0K6R2nhuL00HuFVHTl3SQ
	YK+2/itW5lDFghUqpBlebiBLpVxbkwU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NrunUux+;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758931619; a=rsa-sha256;
	cv=none;
	b=hcIvWKor7Q2tpy7pHhj2sPF9LbV7Ma8/4G6IuOXoCVyikO9Ulk87XjGTPpg8n4LcQt/7Wa
	hoFAt/zsPH9OlBVLLHZ8rRGW7hm6zsZaP+yJv6/Sl1XgZ9m80n44AJqegkZOAJ0nYJxRNr
	GQXBJty2KmoIXGWiBnvcNfR506SAa9s=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4de66881569so147031cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758931618; x=1759536418; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29URIb6wX4cuu5zaywUpqrFkDEdk6T+tY2Shq6upRwU=;
        b=NrunUux+Iw84MPSvtCyullFcg8WktsTxdpx505X2y4MpAOLJGR03ZFNSiFZROfFmaf
         mPE8QKdIxotCF9U5w+gsMrbmapQ/nxvuyvP1r8AuYiwEjiltmgrWM2Ts2Jd49HerazZS
         Op9Kjr1KvLmAJBNL4QDqy1wgnxv3OMx6+bKmqMDF9MFkEWIWG8YrJ9glpXl4+cB0TyGl
         4dFhgVoRtFx5a07p+CJAQZIuaQ0/qhUTLT/MHUzIYrj94uURKmksWoKsWGvR+sFz6csJ
         5KAdXksK6x/ExIQBAG5RYSTZqLc5yc7BgCcbk2lebpB3E26Oh5KE6ZnYkXquKWVhamps
         0+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758931618; x=1759536418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29URIb6wX4cuu5zaywUpqrFkDEdk6T+tY2Shq6upRwU=;
        b=W481VHk094bXuKVTZq5E9PStNbmnPPdi6vis0K7lx7htfeBdiadkhPJ7Ql6xQWVUhC
         LMbfmR8zWh4o4LBImpu7izy1dVEzHHIoxZKaT3wLNwewmvykYxYQVoOyA8aEadtcya6l
         00CWbd/t/3D0dSO8QY6veHt4gYT4dD5ln7lUZ5MmlLRnlAdH+sOJD3p2Y9O9KDEoYbm/
         rdGYxpZbIH6dhs8rZJB7I7XcbiKoEYGfLXYyX98Lrqg15MmkJCcWR8ALrOeA7BezsP8e
         tpSlbaJoW/GR5nZXd1hqao7iwgoRRYla+RfCquGl3ednK7awAzl7khSuAj7Jc/2MPZJa
         qRCA==
X-Forwarded-Encrypted: i=1; AJvYcCV+qSjP37w2imV3tfRfbU7BvvG6lAhQ3SULALFXJzz8T9wCu0pp7O2Q5b31XxRCnyzMPNyYHnNxmA==@kvack.org
X-Gm-Message-State: AOJu0Yy9sm+qxAe6KB4MbYgBNsVgud6VWuvttJ3n+Lc+Bbbn1ndC4GC1
	pPauO2EPY+YUjFwsIm6Cxpel4TKnN+sIegg1Arez2WiNpeRXfoRQkV2vzh4iKZuO4+xokZbFq+8
	rYH9CMU3LtWkL7c7hceeVYIMNsmNsAADykSbqpHgJ
X-Gm-Gg: ASbGnctU0/h8WQz4tx/tOxVBvx5KyL8ZZXb0A30qfjmQp+5i0apn/xiN2KUhvDuGUr9
	rVivyf26OY5d4eyirY4ZPmG27YSZxXZHfvgWK35+tUxc+Gfq/+KORKmszHh72FWZd7/8uCTayq9
	D9p4L8mtBzsjb8FRKlcnOwf+VXoYjS9yvgTrHYPhn1YoDif48/+u9IBx1n3cfvKYScZuFeghBNv
	eER0/2sKrCd
X-Google-Smtp-Source: AGHT+IFLiPgOBV8XSsUKwdgG6fhVNyESUNEXNTrbN+fpy6JAU34fytC+R1DM6IrlpNVPcOxzkPi/LyegQctKAtiDAEI=
X-Received: by 2002:a05:622a:594:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4dd1814d209mr9393231cf.8.1758931617891; Fri, 26 Sep 2025
 17:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-19-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-19-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 17:06:46 -0700
X-Gm-Features: AS18NWCLx8WOW3heEQMMsOLSgr3nS73twxKZ6ISWcyS9VFRYNVbTzAIxYGqOzSQ
Message-ID: <CAJuCfpEJ=-=NqmbZpQOGKsxfW1DQsn3_gusQxeJG8E6hVthgmQ@mail.gmail.com>
Subject: Re: [PATCH v8 19/23] maple_tree: Replace mt_free_one() with kfree()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3CFB7140002
X-Stat-Signature: xrwomozc6kpkhniutxupbrig8b5o8dn6
X-HE-Tag: 1758931619-388159
X-HE-Meta: U2FsdGVkX18+IDhCmRSvYRpf/xFmtejsZUtjlYTigwjNI3/tcCtHMLzbODO3m6Hc2X+QL3Z1lfl26SkmOT8zyOhrj7iK+orkxbrypY4/ljKAlUeGIuJMtQlHImebyjtN3P6qz32POwK4Ms9BlTNgQEhPjGc7pLe/DsvdaaQtmqYKPzUiZdEUWmwospFXiRl7Rbv84hpPOH8Wxd6nW4EYuD9rt5xUp5lI8W6RXUeAyY0HE9fMvHHtWH9bgGeEKbeura4wIO1vbDy8mBnQZmae5qov3F8tgTnQjLfSPfcPwvRjTgTPNWXDC7CL0i2EaH++hYhiM5zboqBgXkqPWfS6pHxPml/J7ek0MDEYh+TumUjF8aLxcVZI/jEusDkRaS/xZqy6+ZBPuYLDomUIqUr8/rRFYHqd4lMR1rOBiitc50dNUbP3Z1BKIzKNb7iuKyca2v9gq5lEvgDFBxxKsri0IghDHwxw1KezQQKM+0SLoasNSt7u8sEYvxW25hpX2NKE4bLriEc4mwqYehsiWaAruaJaauv0418LPQTgy/jT6Hz1mySfrLeszgif9TnSxD/WfkwZtNDY5DGtBX81PkZ3GOMo7//GO/pFttyfxCGI/WLLhVbFWrRPb+tSQ/LjOzY1Uh41LffXJ9Jgqa81T2uQ9eOeKwJsi38s6tZzCT2+pmP9PxUy9V6YIMJJCn1fruQZ54FylTOxsZ227rWjBrWPLXzCYtPkLu57JF8LEIKOFu2KBL/Zn8yjPcyooxeQMTq+t7ANyKfvbhZx5Nyd/5iia7ow5qRKfeRMjI7TGTswDJYAYzyOGocH+QfwimLLHtAyVPRgLkTWB9ttBHtF4AQALGKVAZyk3EgDsOpCX98lJ0OgBda/KbgNnCve0o1V/7M9hUkUMEEFlxXMzMPYjsgUFpJScG/gC6q6wI4tRAsduKd+cPaLlO/Ye0127ge7WUV3PdnNbjN2DvXGGLDaYRX
 D5aJ/zrn
 mDdg5t9zqCTJLL9gBjhPU8zz/SpsT48QYAqc4MkFsWXAH2ur1flb/INzQ6U3TeM4NY9GbaQp8eYDcSp4Hosl5wPhGnQJMYGEXvClkmstqLhbgwuozVor7+OdPUd212gogv8cOwdrEAkfGiOvHkQsKx+/mWXfPxte4te+mFTTclaQXnmFKc/dfLDPCM/sY6jYASLOKdwK9DfNYCI8ZlYERCbuvI1xHLzYQmx7CMJ6N76v5etNZWecdTK69bg6nEsfQk5YwJY/MWNIGf6dzDUUAkhHrKJg7lozAFAm4w03IoutlrtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: Pedro Falcato <pfalcato@suse.de>
>
> kfree() is a little shorter and works with kmem_cache_alloc'd pointers
> too. Also lets us remove one more helper.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  lib/maple_tree.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index c706e2e48f884fd156e25be2b17eb5e154774db7..0439aaacf6cb1f39d0d23af2e=
2a5af1d27ab32be 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -177,11 +177,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t si=
ze, void **nodes)
>         return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
>  }
>
> -static inline void mt_free_one(struct maple_node *node)
> -{
> -       kmem_cache_free(maple_node_cache, node);
> -}
> -
>  static inline void mt_free_bulk(size_t size, void __rcu **nodes)
>  {
>         kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
> @@ -5092,7 +5087,7 @@ static void mt_free_walk(struct rcu_head *head)
>         mt_free_bulk(node->slot_len, slots);
>
>  free_leaf:
> -       mt_free_one(node);
> +       kfree(node);
>  }
>
>  static inline void __rcu **mte_destroy_descend(struct maple_enode **enod=
e,
> @@ -5176,7 +5171,7 @@ static void mt_destroy_walk(struct maple_enode *eno=
de, struct maple_tree *mt,
>
>  free_leaf:
>         if (free)
> -               mt_free_one(node);
> +               kfree(node);
>         else
>                 mt_clear_meta(mt, node, node->type);
>  }
> @@ -5385,7 +5380,7 @@ void mas_destroy(struct ma_state *mas)
>                         mt_free_bulk(count, (void __rcu **)&node->slot[1]=
);
>                         total -=3D count;
>                 }
> -               mt_free_one(ma_mnode_ptr(node));
> +               kfree(ma_mnode_ptr(node));
>                 total--;
>         }
>
> @@ -6373,7 +6368,7 @@ static void mas_dup_free(struct ma_state *mas)
>         }
>
>         node =3D mte_to_node(mas->node);
> -       mt_free_one(node);
> +       kfree(node);
>  }
>
>  /*
>
> --
> 2.51.0
>

