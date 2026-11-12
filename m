Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F01606A326
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VqK+SIAm
Received: by kanga.kvack.org (Postfix)
	id 8D5086B05B0; Wed, 11 Nov 2026 19:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EA16B05B1; Wed, 11 Nov 2026 19:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B86B05B2; Wed, 11 Nov 2026 19:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4D36B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:16:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F5B016048F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:16:41 +0000 (UTC)
X-FDA: 85424551002.08.5F9271E
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54F051C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:16:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VqK+SIAm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794442599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFwg5Wnnu6Xe8mLPG0VsSJGBINJAyrjERL8cq1SoEgo=;
	b=lAnv1l2uBq2ou4VSFxJmS0uIHsTPeoUSf5UqoUbIjNu4A9vIn1lMKpKjgYtXk+imOZWMQu
	GgsV0ENjimZNxZvU22F1lrr3RjqagTqOCyRg6wfX39nQ5BzMyCvDc8R95ao94aWBcC6o9M
	uvP3MwCV5YH1Um3mSbFge5Ly4y/EQrM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794442599;
	b=tBKt+Wbl/7VexI315uc7mnFSojXi5GeDWjtsbYjN7j0H8VO2LETbAhufdJE2tlJDtar724
	xK3ASgrqjEKcMhSJOVFPb4wZmtfTDtG7jrBZ+RNRcF1rusqrEpYiImKk2waPC3+4I/la6v
	bJn7WKDNER9sv0VnC2c9UxwkY55ZNUA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VqK+SIAm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-54492d8a988so53731cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:16:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794442598; cv=none;
        d=google.com; s=arc-20260327;
        b=Ix2CdwSrvFpy1UUwl9JBc3R8ynpERWvgcSsRD3NV8pAA+ACH3xeHtNq72ZEGQjDnBT
         QAxRVg/MMIcaw4Dk7t5p2s3DNJUNduQAtG1V2ZoB+fqMaKB5wR+F4yipRYFiscRhZYX9
         Xap9U/hpFri2me45v96DPTgqXsdDqOX+6wp/IdzEfM0G5X6V5GSsE1logKvN5e5y/lvS
         VOGgxWVxGq2vWSyep4LdLAynFH58A5ALMwOvUKMLzI5Bu5Nm6DHKRbHJK7c6mPT5pBSx
         +4fKWqm7mguChAhSCHTofl4oHPQ6tikgkPOKrtwI4gbDRFwxcD5TAfJnNa/0FzhsKhyv
         HR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SFwg5Wnnu6Xe8mLPG0VsSJGBINJAyrjERL8cq1SoEgo=;
        fh=y1ef/yWtJv+2ckfMbWpZ07UPYucGhokxyd/D5DN8JcE=;
        b=OfEUOaaeiRiWsIckb9E1Ev7SlPPiwC+ua8vSyR1VIajqsr+i/WYVtteQKh88e27mww
         v1sJwtSiikNMH8UX+64HKu6CVwhdNSKr5m999iasI+NoLQyNX9lS/7E8L1eaZgX4MFHs
         7WsMMtHzd72hsmFForQx/8GDyAOJP7uTMhsijtK4LWiSOwdyIDMyR33HaUxRcAA/aFfe
         FgoiD1ZiNLlTzCZf1E95zV4pSCzrcM3UGvf730pnnXaPSTCa0vd8vykIHPOGY3TPSavB
         EphMV75k54cOxivzaQqETliWjlLxMgtiLFJ0nxZqxYc6UxtKQdNV1ZCbqAr9e/mMd57u
         CV8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794442598; x=1795047398; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SFwg5Wnnu6Xe8mLPG0VsSJGBINJAyrjERL8cq1SoEgo=;
        b=VqK+SIAmtsWWumDq7Ewh0MT55LP9mN7DcEzPgIww0vRV+/oVYbc/ktqHpBjW5f2now
         ptnka9wSht2Ki262eHMP+Kib9YXzcr861g4IDMAU2RihLrHGEQwRj2uZ1CLEbr1EjD7l
         0lHbN7f7ub7FB1L13GF/KusPmovL8dfEKIxuJAEvQvIER2eWOipQKtDXZTW9ywah2Fig
         wBOZE3BhHcpGLJxIJ0V1X/ALDhnen0O+hg453tSpgHS6D5j/w+Rf0vuFQ7ph8QhF0qC2
         vyyx2d0exrNHvRQvklNqM3YgTcjUWYkRgPA7YZq4DDciBW3WNjDc6z6U5ctLfOvXinR/
         pznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794442598; x=1795047398;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFwg5Wnnu6Xe8mLPG0VsSJGBINJAyrjERL8cq1SoEgo=;
        b=J67SnsYZRcKXQBuclxFdl3ka8SvAegkeXEGfNzAGYwQTlz9XyfmWpvMdlh1RgTX4eF
         aOjGy5CCelKp4j0Xq/+3ojsItBJfv8ZX85H8Npd4VT3Iu078VBmpURRjS80LpcP16YxJ
         Gw0r2HMUjOGkZL4Fqck9cavN4EdeXVT3qMBmkd0JsILg61ly6zkCXN0NfC2xDO6srLib
         uO88hL40emrRFrBdTruWwKZIJqdRIOSxIEgBXpFy/nFETsMxaakHmu5gbvBEo+qPx0GS
         crTdFOuJr3dIPjvwfkOIf9hHL7G+PrS/QUaLezslq3OGGSxoBo8B7CF4HjxcsHQCb0ke
         DYwg==
X-Forwarded-Encrypted: i=1; AL+hErFPRSaKt1crS813gFFlXm6LW/ovIRYjniaCd+Sty9r8/NiwXI9Ekzq8DV+dVnoZOjLCRZjWCjqTBQ==@kvack.org
X-Gm-Message-State: APuU4Z8L0h4tQ4aLt7kUhF3resE6i0QYkVAjZCxn/A/Ek8VkGM9X61vT
	28ktosEuK0q71ivQmg5iXUoXmoqK3RbOiMUmqpTZ5OY1oZIT24X8flIHfJ9HmoiFvGWeGT164Oh
	BMEaiDULwX9TP1CGp2o1bLR8bd+OrTWcP098Raap3
X-Gm-Gg: AYBFou3ogdKkNQMAXxtK1+odyz+Z4hSs3FXOf4wZ2h0vtEh4nUSnTMhA7ha7REfbpXC
	uNgTZw3AU+Ed/GWNKY1aCviyxV5F47A+FbeLcTYR6R2J1GrNTMfaqfrNcr96LjO1GE4uoxxf1Je
	F1HJZi2I9jRQ1JvFhZNz9cc3zxARQM3AkIlB3QFvgZrgEVlx0SbMdEnrSIb/+/C02iIo7w/37wz
	Rl5Q4DbdDJNyvFHblmyAXmB8bv80XH+FbPRPFulsnU3087JDaf0Gdl+n9zm/XFBT973uRlrHQNy
	00yQEcI+pxNMsn5jWTU96B2V2WY+F/qAQTb8/NlXEgT9UcFdMrYSCS4lrR4zcnfYnUhcthinZA1
	j5DC/KZlHNbEMTnUB3+ZyXAgioAQnl0xscopP+EkSgCnZ3WBRdrgVcEwFBGCV+Lz6LhZ4mFJtiy
	V9egR4iLZoPvj1TCBZ0sADlhE6
X-Received: by 2002:a05:622a:191a:b0:542:fc60:fe23 with SMTP id
 d75a77b69052e-5596ded2f3emr7342891cf.3.1794442597663; Wed, 11 Nov 2026
 16:16:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-5-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-5-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 00:16:26 +0000
X-Gm-Features: AclHuK9X_nBP4XE80Cus7A2PIJ2z-t5IzbqPy7J7kM6JfZcsfXvHNVWcxL1W9Bw
Message-ID: <CAJuCfpGMtHZSUhUra9rp5xGvD+L6reopCMb3qXgRSctQ7wnYFg@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] mm/vmalloc: BUG_ON() on an unaligned range in vmap_pages_range_noflush_walk()
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e198owpeg9mgrd8rjsnqbmeidr7xu38n
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54F051C0008
X-HE-Tag: 1794442599-801924
X-HE-Meta: U2FsdGVkX1+5RN96BS1otyGBpokLdblfvgYjCdImVmrX7pCbyaaqs2hd26VcBkUFz3q3AdkIg8ICo5eH7xeWgkaUqzTWDKpGx8MlPWNw9Vrdzw8f0Q24MQivA3dtqs4VS8af1NqJdXsTkVxQSHIrhM6vfT+ILJUtuOOHycH94ZTOgbOyMzJtKtp4mDpIgz34BtC7igdS3ArqpC2eb25QC9/70yQlEPvReVJ0ZvnfSIs0uarNAURgI4lN+J2dJjdcLZWl0aViiQtUODVo380gjgIDSy/YlYgBEUVvxdKvUoMSuu1UcF4+63/M4mtbS0GehWa4AhXmB0zlSi/yaXN2qfoLl4dAJjmKW+Jm/Rcc6noBhUB7jwz8lYsIp8/QAH39Y7U8CjbtfLF7MXksu/XraKR7lP9wvb49Lg8CER5ssYliV+UcK+r56fALaQzBDW4A+4Cn7tFjdoOU8hrhd/GU+4unV6RyE2rnvpEQUaDmQaXsSsOHK64Kxf+ZQC8ZLoYQPASY6YtthjUhaP4a5q8aRek+AOyd30mbIneyvwAbXuultPFBDHsfL3K8jkEEQB6IFE9TDVJYfhHNedu1IGXjcsWY1tZah0F1M7FrqEccsWQ/EnOaUZm01YRKwUR6NROzWCvY/8I11aIoxZOHWxO18uoDnFCLy0WncdXBc9jr/b2klqL4Bk/wE0UwTs1BfwOaw1x0GvjiEVFGGi6LI0o5fSQS+B2XOnQM6otRv4/lDN98ftoeu3UHNog7RmAJgLGpYGs/kopOQvqdAr+opiaBxt8OnWnVoo+scKyF+xajufU40SO8VVHaH8xE4hGzveBHarT2t2i3VB5srvLx2zmh9lIBdf/iKe8LzCj/9xcF8ZTOQehUO4GaDodWl2wk63nCsEcp6Njcq60SlXSnSHtsTBYxm6irvFYvhgpNSuqn/ljNYAdWJ3pydhotb5awiAicmXrulvpYIcj4gn7hXWo
 gompkl8L
 hXJbhcvQ9RD1QlVKKCeR7IozTGMixcjvz/zTzv+MDl9BKOSAY1xWfT7+gYsd6CIPaSqUOlsrIYUeTsi9g+TL6DaJYEhAz9ql+HjoWg8i6Je2fquWXxu9gTrTG3sP3QAuaToAoLFCa3cD3N29yTEfT4cfG+qnkAIumZMvYWhMp+9T13f/xi9hsfzmvYqv1+bELuv+vvnORYeApdBkVpjkBJxjqdVQLlAXw9cq8cakqO6Y0bLICbGYLgjztpHNgFZP17OOCH5kH9uwwQCmxx37N8Kgv5AtjXkS7zwgQAmIWTTscD7op0OlnR1AY2xrFlLEvicxMZU2k77XoNCu+/MxW4nH9SdyR1LgHWoliYmhdv+clqXcLxSnBDpvvRLyfGu3ALY9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:24=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> The pte loop of vmap_pages_pte_range() maps whole pages and stops
> only when addr lands exactly on end.  An unaligned end lets addr
> jump over it and the loop keeps mapping into whatever follows the
> range.  An unaligned start maps the page below the range with its
> first pte.  That corruption is impossible to debug afterwards, so
> bug out on addr and end at the entry of
> vmap_pages_range_noflush_walk().
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 27f2674a5556..86fbb1d2b27a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -698,6 +698,8 @@ static int vmap_pages_range_noflush_walk(unsigned lon=
g addr, unsigned long end,
>         pgtbl_mod_mask mask =3D 0;
>
>         BUG_ON(addr >=3D end);
> +       BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));

Instead of BUG_ON() here can we error out early in this function's
callers (with or without a warning)? This is a static function with
only 2 callers. vmap_pages_range_batched() uses it in a loop but I
believe if we check the original address alignment then consequent
calls are guaranteed to have aligned addresses.

> +
>         pgd =3D pgd_offset_k(addr);
>         do {
>                 next =3D pgd_addr_end(addr, end);
> --
> 2.25.1
>

