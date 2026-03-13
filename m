Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E57107BCCB
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 16:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B9D6B0088; Fri, 13 Mar 2026 12:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D491A6B0089; Fri, 13 Mar 2026 12:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6B56B008A; Fri, 13 Mar 2026 12:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA8D56B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:22:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55E2C56738
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:22:50 +0000 (UTC)
X-FDA: 84541558500.19.917ECFA
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E4B01A0018
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:22:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtOkUckD;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773418968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waNi9HqZMalp9X1QHhx8NLvH4Y9lunKrP9GbZn1Q6ho=;
	b=rl/AQgouq2lo1bQvklPMDlQRP9L2G0w2l/DAKyrGXPJaFCWZgQpCwUuEnVMZXFGLqDpKIW
	PpTPtauXtwyFveNOxD8v27y6AvsFWDKQn3yc37BYKNLmGnrD/YNJew2xTlzGWPOu1qfmlu
	QwqfBt61eOhN6FeR8n2tztbnoZ9AfMA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtOkUckD;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773418968; a=rsa-sha256;
	cv=none;
	b=YBB+eRpQ9QBJXNGmfL0/Wrro1mdH7VetJZPIvTm27dybCntNFxmUcpcZARJTnALvlYZwTd
	EhZqUlvNDnMxr/zVxzVKTLuWmX6aOE7Ey4EMZ9rE3587sXk8+jIV7qxe5KOOlPZwOjD7SU
	gbM1BMMNUt4RsGHv+As1H8fQP225osw=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439a89b6fd0so2368359f8f.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773418966; x=1774023766; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=waNi9HqZMalp9X1QHhx8NLvH4Y9lunKrP9GbZn1Q6ho=;
        b=ZtOkUckD36I9E+vCA1fWR9VYAIWJ5GFg1KOIfSaYa8QQpjNYc70gKzpF4a5HQtNpTt
         WX/FahH/L/c51woy8axdOHs5Kh45pJ2MpgfBG1wBRma3lKooTtHqtEm+5j9Kfx3e1S2U
         Jfx+yyK4TxWxBtn/WlsnZhzg5Bx94zkmO7Ns7yjJc9t8tI9UPFQHCz0lZtorehKtiKim
         +BkY2jW2urgPbAy5On9yrQ/opvmZYjxQBDxWET7YaMsyHJM3xdOl8xNxUA4lolYQWr6c
         8jfpOHIROJW+l2chDJaGOoo38ShVTyRTHnMW9uQI9RdU3P97Z8D49+abq81UELmZrVj5
         y7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773418966; x=1774023766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waNi9HqZMalp9X1QHhx8NLvH4Y9lunKrP9GbZn1Q6ho=;
        b=k+SIOfxUbdRMDy8S1dPXiNbqIs6s/Z5h0BwdzIGRPdBmxYJTX5tj5IbcOybfKljceb
         LN+f8oBV0ZzOXuQx58hcyeRMVceKn2p4DOpIWJaWx6nWrNJHWldHFFd07N9/EKau+YR+
         8VFdk2wocXPbAJm93Lq/HNv/6bNqrRRF7zI7t3e7xPj9xqOUqjqNwsWwBwGYfG7jKQda
         XIVFVlEKPMGjrd92MxvK97qDcAM8Q+cUoi6FuyxT/75YFYSLJE2PXbLSkdQq0ida4j87
         ZYnC2waB2zwA60akw4CGopL1YUw6Zec0ZqG0sDm/+rpmLsGefr/OEYJ5zu/HbJttm80d
         dvCg==
X-Forwarded-Encrypted: i=1; AJvYcCW9wtZAodzUWChIlLlB3fEBzNFzeH26k/yjPbqIntKu0/vTJn8FYnfcBm7E3ogG9J+U9J/b7ebVHQ==@kvack.org
X-Gm-Message-State: AOJu0YyXHl8Mhad5BnwpQU2i8onQX1ZIL0YbJKsNgsYJFkvprI0wWct2
	OsrG6nC7b5wW92lvlx+f4KwVHU2xLe6VWMM+y7xrD0R7HIzqPCTYvueYOAoYCZ911fo=
X-Gm-Gg: ATEYQzwSZlYucxN/Jm6tQisCp8fQwE31/B/FvWTUR1tROtwpCz0CV6taKY4h2K8sBdG
	i8wrPs/DNebr6WS08g7UEVjT1oR6Q8gm7rJZyPxZ50VvQfuOtbuODUfTkh/m440FLiqHDEHIEm0
	Jor31mNOh/7req+cUZlYz/m7Ckbd5YKA+QT6Bnf709zp7SKWv2TY835cuzYlrWZetIMB5NcHbpe
	ANDtsiy9GndXoie7KT6herMHP2UumjUO2NP6DxZ2jsivdMmXCHW9PEgEtbUEOKWg/U+I9qo3Pzj
	Ji/n70rbt6etnMSt6LKPMnG5UH3oMlrKgMwdrhF7dfjK7WxhlRB4QnLWALC2thprvkAVbbM95KT
	kaTAQ09wARqYAI3XKlIt/lirjZB5DQbg+HZR/elaGXWUMb67FXV3yYcw3o2Z9xhewRfrxuhtDxm
	EO4S9ynraE8lpkkdmkxwmMsNKkdFu4a2JuBJ7/B602R/Y=
X-Received: by 2002:a05:600c:a6a8:b0:485:3a22:69b9 with SMTP id 5b1f17b1804b1-4855670c0cfmr39549385e9.29.1773418966114;
        Fri, 13 Mar 2026 09:22:46 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48557c6700fsm22255485e9.22.2026.03.13.09.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 09:22:45 -0700 (PDT)
Date: Fri, 13 Mar 2026 17:22:43 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <hwcqvplnn2knclpivgagctmcaiutyv2qprgoqmwp7suzj6fqb2@diq6grkwo33b>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kq7o72d73feieu7p"
Content-Disposition: inline
In-Reply-To: <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 3E4B01A0018
X-Stat-Signature: tpijhgajatf5rxbj5yqef6d6czqz6m1k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773418968-743552
X-HE-Meta: U2FsdGVkX19Kka8bPMqZeZD/PYS/mLMVPodxg1YIqMdYnun1oiM0HKVPGWXn4uwxs1VSHhsOlaWur+EHWOOKOLtyHj0BsonMs3gDQ9zumWsO/OXJ8zWOuAbHbrdT4xBuNUloUXoIl6mBTzr2s1pxT6XmSf9fbLEEJFBA33YswcQM0zfOxcs+MBtFbfNPAvlEMYVt6iPGfKT/X9FJHMfXmHgLe08U3tolRXENj8z9JCoorzRQuCkXaOFxRpqGELho5ncr0KjN6OvInXnWrodCCO+qW+R86ZJjh1xqACEVYnzbAvLqYfRaN67eHUOCq7Gqk7cm0kOLVHhgvNx1WHWOgj5U4Z9f/umDj/Dp+9xeGCTunGfC08kMU6HYd2EmoYVRBcCYql+NNd5chwlJzgsRWofndqeCvA4YJsBqlHMas5Y7ODguwMwZlGCew71w4oKRd42yMeE1Xe+NkmSBcu4GAigYtEdLzKvBmhzuzfYncRUlDcfMOnJnalaifAqngix1ay1rCyXlaxbFaoXcE6H3MW+v156BK+DN4jAkq+ARIJJDvNhmuByW5ID3h7IPgxcmsPnJKDXzcuvOh2K8+WpOnzGQ8os8ZR6yv/iEEtlofrKKpN+Jbo6jK7ZdAv5rxqW2QmhHCIDA84s+qlGGuSANjS8JTQ9UZNBtaZeazbgKarHhZUKeUTKKXWkNM7Ptfj6EbJgZCwxsZO3pnUaxvHFSRkIMY1CgZ/MuHFhWZlcB233XJ5klMkYTMaJQiDxoUXi0ZW2pR2LsK+t23MLUOLxRUXUCXqnnEK29BRYZ3ZSt1COyVUu9hMmHKlx6CdHe3MYNs8OyF8LTsYUXDmTrqa17zLaB9w/FiOIaQ6zntulhJpnF4XRog2+jzMn/CVYBQlcZMMU/UaSMNxc5O8VQVDaTM2ha8deCexDQwjsa23LJAEkjFIB0E0w9gxve2LvXwjDKLRKFeAtfPcW4aL4twWY
 2pUP4P5P
 DjLfqQD5642bTP+lbDGuAAmFF1Rbzbm7TV8DBOSvqjNPOSoxu+zEEKpINjE0S3//QEoxS28TQpcUc0oRTzKKBSlmAydlmZcBqo+5gzvca3nhQrsRHe3ZF0P4dJIVDuczNzj7PJZP/DUZK5c1Zs3Pkrx9m8YIanHgz7ix/L3W4HDmGTm+oXS+8XdV1On7B4nVA3g3l6flwt3oaIjTo4T5by8uGFNXpFW/QKczF7qPBm6aOxY5CDjM6BYwAgRZ7EiEoxftUyIogLGSF2pfSOQZBtMNlI9ajqj8LCNWIQqWJJygVujzRFqwUZjUbEXA8pLyw1YCDuBsESbvQuJo1PjOAosSuN505WQif8JqGC5dEJXOZXrDnzREItseMVwEiWUApgNgS0psKgax0rGEDfuivqD7axXOTzfUjNe3VnYwaPrZ2/9lSZGrseORxJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--kq7o72d73feieu7p
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
MIME-Version: 1.0

Hello Qi.

On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng <qi.zheng@linux.dev> wro=
te:
> To ensure that these non-hierarchical stats work properly, we need to
> reparent these non-hierarchical stats after reparenting LRU folios. To
> this end, this commit makes the following preparations:
>=20
> 1. implement reparent_state_local() to reparent non-hierarchical stats
> 2. make css_killed_work_fn() to be called in rcu work, and implement
>    get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>    between mod_memcg_state()/mod_memcg_lruvec_state()
>    and reparent_state_local()


css_free_rwork_fn has() already RCU deferal but we discussed some
reasons why stats reparenting cannot be done from there. IIUC something
like:

| reparent_state_local() must be already at css_killed_work_fn() because
| waiting until css_free_rwork_fn() would mean the non-hierarchical
| stats of the surrogate ancestor are outdated, e.g. underflown.
| And the waiting until css_free_rwork_fn() may still be indefinite due
| to non-folio references to the offlined memcg.

Could this be captured in the commit (if it's correct)?


> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6044,8 +6044,9 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, con=
st char *name, umode_t mode)
>   */
>  static void css_killed_work_fn(struct work_struct *work)
>  {
> -	struct cgroup_subsys_state *css =3D
> -		container_of(work, struct cgroup_subsys_state, destroy_work);
> +	struct cgroup_subsys_state *css;
> +
> +	css =3D container_of(to_rcu_work(work), struct cgroup_subsys_state, des=
troy_rwork);
> =20
>  	cgroup_lock();
> =20
> @@ -6066,8 +6067,8 @@ static void css_killed_ref_fn(struct percpu_ref *re=
f)
>  		container_of(ref, struct cgroup_subsys_state, refcnt);
> =20
>  	if (atomic_dec_and_test(&css->online_cnt)) {
> -		INIT_WORK(&css->destroy_work, css_killed_work_fn);
> -		queue_work(cgroup_offline_wq, &css->destroy_work);
> +		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
> +		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
>  	}
>  }
>

Could this be

#ifdef CONFIG_MEMCG_V1
		/* See get_non_dying_memcg_start, get_non_dying_memcg_end
		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
#else
		INIT_WORK(&css->destroy_work, css_killed_work_fn);
		queue_work(cgroup_offline_wq, &css->destroy_work);
#endif

?

IOW there's no need to make the cgroup release path even more
asynchronous without CONFIG_MEMCG_V1 (all this seems CONFIG_MEMCG_V1
specific).

(+not so beautiful css_killed_work_fn ifdefing but given there are the
variants of _start, _end)

> +#ifdef CONFIG_MEMCG_V1
> +/*
> + * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race =
with
> + * reparenting of non-hierarchical state_locals.
> + */
> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cg=
roup *memcg)

Nit: I think the idiomatic names are begin + end (in the meaning of
paired parenthesis, don't look at css_task_iter_start ;-).

--kq7o72d73feieu7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCabQ5zxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AirbAEAllLIHOekP42qBXcY9SXM
HI9aZuWe5shsjcP4rBnHz2IBAMq5mCPASHGfKEP+tb8nLIzv/PeBVFYEJSxL39zr
N9oG
=/sfd
-----END PGP SIGNATURE-----

--kq7o72d73feieu7p--

