Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12388606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d3BC2Q8e
Received: by kanga.kvack.org (Postfix)
	id 1D7536B05B0; Sun, 15 Nov 2026 22:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEBA6B05B1; Sun, 15 Nov 2026 22:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5326B05B2; Sun, 15 Nov 2026 22:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC9A26B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:30:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5078A408BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:30:38 +0000 (UTC)
X-FDA: 85439554956.25.1671D44
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74088180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:30:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d3BC2Q8e;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794799836;
	b=gASz7naqq/DysiW2GVKpiniJRJfm1nExEkxrWDGoFXkMj1Kkai2bDdfb+fkE+TkV7O/DIS
	Gdju/1M6rBKM1aDXhu9ty8Qni8NXLJQfcsJQvKB7FNP4l+Q66aJKJ+KR/AWFYJoTbY7B3p
	9XS6C9V0b/t1p2KWo5YBLTViZT3sTHU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d3BC2Q8e;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794799836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbvHpp+DKB9Zn3Fe95YeqAT/79gj7Jwj0DQknuaYym4=;
	b=rNA8ePsQFdL/R5TwKg2jyK2pfCKfBshqvtfbH6Ror81o1Wav3pTyF/o+XoYV1+adDR2NEk
	EIkLGADesQ+DZ8xNVk67b1k9Y23Wgp1Wc0uvDRgMSCVnnS9emqeDAdKacIM4uC/UBuji4n
	/93FSrwuG2h4V5pC28f8WHwqnbcswrs=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so4343019a12.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794799835; cv=none;
        d=google.com; s=arc-20260327;
        b=F2cpYChprxpQWdgzotzXEUIYaQX3pMOZur3rBaiziDjOziFaLZT+lDkI3PZSdJO7aw
         cn/Qp4KyIk/qPhTQm8pk/MmwyEigols2L6RqS4w1UPfnsWzjvheylpzdK3TWFEQ7l47X
         pAw80N/v+ZOW8leDnWRADcsyYxk4eWv8cQSBmH81sQmqG6V6Y7t1g3F2XWAPVkKk9Ue+
         mL62rZ/LIqTVKR8y1zOGH+9R7pCOq1nKnPKMM0vKUf11HnfqYdZfLp3/i/oVHupSCFMs
         Iu9zWSpQCUhNryfo25fsxmUt+9bMAb2gGAkeyfeoDCRjmQJl5lEzPNuzdXhUEmg9cx/a
         llOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EbvHpp+DKB9Zn3Fe95YeqAT/79gj7Jwj0DQknuaYym4=;
        fh=fSnpxyQFzYBuLIUxwelhy4CB2h483iJp3FJ3zS0Haxs=;
        b=U44q07fQEDtjQrvoDUGg0JbJD3dbWwljB3l9mTQ8UQ7DiOeiCYoUUzQBE0zEAGvSpj
         BNIu8O51ekNLSyTYnJ6hGwnRZHYrWLCtUzoBmG6ozkhoGKfgkL4vvZdFFlCYukSuTcaN
         KZ43ushBB5QlwKuBxruP7AK1AD+i4XXnJiRZ6IUXWC0q8619dUczXaIHVPM1+TD8tEEr
         MySGfmmVGZQ5MzPDKeNmcTJeohh1BofYp9zgjZqTlXhch9VaTxqTZJDrGFVxlufkTrsz
         BZ88iEo1I32L6tFF/iV1whi+Sre+MpGOBFYj4/NuUd3X6b2C4VpqA7vwUKldOJPeFMOm
         o6yQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794799835; x=1795404635; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EbvHpp+DKB9Zn3Fe95YeqAT/79gj7Jwj0DQknuaYym4=;
        b=d3BC2Q8exrhJo5rSySeRauRylw+YYRP18VikIr9XeF8wxKXc3fY6sX2W9xow0aXaFH
         I3RqKGQnN5BeoYOl4j8brzhbBWGg1hTKAeaF46V/ASQy4i8ODBEOB3tdjyZPGL87ns0J
         JhsJ/n/XJNeyuSIr0QD4fLRxut/UVllhzx5b1C5Tudqd//iNktKoOxX9TA0BNNpnqj0S
         uRkoV58VCC39w99616QsWqIc17KQpunMvwZENXGXjJ3mU3bB2fcRrU8BjS77mbzDf1GK
         XB121djlfw5ZAxmQFepLTgp3Rf+I8m4lu9PXN+meRw/wuTiJGES88QwpUGTkFy3cvWAX
         C8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794799835; x=1795404635;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EbvHpp+DKB9Zn3Fe95YeqAT/79gj7Jwj0DQknuaYym4=;
        b=zC58dP+0QqtdDpWig0LwBCXpZJAWhgZ2V5K7Kn92Njta9ETSVFyRZUne5HdOslaOQE
         tix2au09OK2SHpIvMNT7F7GXPZy0R9T8HUH4pUyyGUsygbOe+ChyFgZ6tRf1pglglGZI
         e5sIa4JinKAvHfo4VItdp8wPJD8RLACdsBqxUcYNkQ6TPZqxDq5SxkWkxN0UJkC4HSTu
         /yiTkU8appruYm9GE91VMHMmrIhyQbbGWn34iZy05lxy18G9T/fSJZCyDR/y6tnheth3
         o9SN7qQHh05liDf6Wz9RMDQEf/YM/bOIAoPcvTTCPIGQnL1hK58gfA6+Ja0HC0wsW1PN
         E39A==
X-Gm-Message-State: APuU4Z+3jytln3BFhQofLinoarpPYAy8TP/PbZpewtZ3ZkObLqoumGaU
	qeyjxNgAg3azl/y++lRUXIGTDzGnM8C83Z0IwHkbcmHeRyOmHo/EMQdi8XjrIGlGGoITwfwZKqm
	+HMShRxZpYc1zQFbWq+Cr+MiSsjZJqU0=
X-Gm-Gg: AYBFou3pM7jPIcGPEZJ3KIiL6z1bpO/nQlq8ut6ck+p4VvPUfcGKG2CINLBMTF8wJko
	p20qE1dHW03xMUHRu1MWX+KlMUfSvsH2rITqF/LMTdqoS37WHRvIaLEDQtvIWkTAfeKozyTRlIO
	Pn700WC9PK55VUPQv7jjbZeiw+uvyXoyrODiA91ZOMUQp0kPftCxgL0Jf8MKnRWyuocOinTnBzR
	auYSxJ1zAet5E9zrBZI33KIYD4/Gbk2XxrVqjbPe9rDl1bopeHNLcjFSl5I/lduKXyO4BOSACfs
	LUFEGFD2zkMry0cVJpFQV3fpEAsua+uAZP9CjK5W/fOCKzdc45eDiz+/E36I8Vki7/7BWQRHPJI
	1kI7uKCNdPv6RkyDzGktXRNUPNVEGecF/p+efnzxAwxzAErDF6x/Bluntrz0VZTkJ8Ve15Q==
X-Received: by 2002:a17:907:ea6:b0:c46:7ec3:fde7 with SMTP id
 a640c23a62f3a-c50963da4damr741558066b.31.1794799835006; Sun, 15 Nov 2026
 19:30:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1794666741.git.lianux.mm@gmail.com> <fbb87083afcc51fce533308d723edc55263bdf06.1794666741.git.lianux.mm@gmail.com>
In-Reply-To: <fbb87083afcc51fce533308d723edc55263bdf06.1794666741.git.lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 11:29:58 +0800
X-Gm-Features: AclHuK9SY3SoH2arw4UJU6ntA6zZEp479wBVJLO_t_nMFXkiHdyE_Stm0Vxwk-U
Message-ID: <CAMgjq7BE_i5FxYFrzSfnNsysBQ8UQzcULRo7AD985_1o27-jDg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 18/18] mm/swap: redistribute queue readers after
 membership changes
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Jihan LIN <linjh22s@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 74088180004
X-Stat-Signature: f1zdf3rogahnch433xbkw6qpqbgaeo7j
X-Rspam-User: 
X-HE-Tag: 1794799836-154310
X-HE-Meta: U2FsdGVkX1/dhU1CCvlKRVXBsDGgSzp/zLTT9Haiwwd757Yuf6OKOK6XXeZCxDTlwAwKpSa5CpnSlwKMo4CNnsv669+WTY/glQ/IuQxMVj2/6YXC/57XUlMHU79ttDtCL61fyxMQ+ZQBMI83Upvo/QCxqUsFvwdaPsj7i9+2H4EenvhflR3fV4kkP0u9iQKv31yDqd11AT8VggLcSXJ5S77+eOTkdSBc4pMvJYY/q+gqc4lKMALS9DCQX7WOP9iRGGWZtKRGazZpXJTU8IO6vChnFAr8PBju/9SGK4wazsVdX0eIS3ZBxk4zoXdNKMYc++hUZxyw/OTQLwLtsTYfdxX98GkVAKMfd8C+oPPeIxVJB8ydo3CuH8loc246zcsm/ETJRxk3a6JA8Koa6Knq35TdGxFRkMhxgF3Imf0PrRIQ9XZ6H7XoYQRLk44KBWX6HjLUScD/oJPLr7FMHM9r4Z8PEpRneZStqqWSLC2E2and0josUexZ+jvdcvdjpbhmB7ojFkfup6gDR+86vLRlMxw1H/8HGWeJ8sXSugJOmq0nDyssveCmkgtloJAZIWdO3KeZTBuspWRVXw4djyjXj4/C8XUDZfJIe3KQ5A6wNMPMQ7QDXp4ku9Kn6azmy9myAuWpYjcgEznkgqDhiFf/U3w5ln+CsyWN+7bXNyLBu3Km0lCw2pM+T7gOqdvbEuAiQaGnEATqcxHTVslZlF0TER62ldpgmCCNSQbKhpg4VJlV8FMP9FP5TcYqzISuM2/PcM5YJPTZCVjOI6AeaMhgIo7Q9ZJ8NhUAjT7KnK5y5lKk6tuVE+0lSOFCfzlAb7vc1FBXRg7NbDaLdXBXvF9//Mjslgz9L3PhlhOJ0YJV81ZivNUtYgitWZIbhdyjPCTOTtWCFG+XYdQllBMqUCEGBdgrRCsoY+R4G/hNVHqWQDNvCwswhf9KwaGN50zB03MyhJww5iSSUYs6ABmzL6P
 ltiVUg1N
 5J0pft/jQrhDPyiVQ5Hqv3uFpmxDSbE59wf5CftMOiqAbR3EirHSVKfQNU1C7rc5ax2fXZ47PbDJqfr9elnWgUf1lL10FvrrnWHRe85CiWO/z3ykoToMIKybONPX5KBhlmQsVkHoIgzvvTWi+0pZjS49y7oqI9yCytAf1qoBOIUXlEw5cu/rb74QT2PElHlJ6EI0B8wK4dsHkhK482kWTwGwMSVV7jD1FSMUJUkiMJqWRXn6hLeH04BswYp6+aG0dY/VW/XZCSh5/BNqKDbbPh5sxEvSDbVdpti1XHsK/9X3of+d7ixs7XUNAd+nTYttSvnobvgJPoQWFWFGaXvRNi5MazEZP2A6RdmKga19yNVall+ZeXolf0dNnYNNPJI8XzItebqJbqFV0Uo3/j4bmGt1BZI5tPUJeSKpUwGazNGruw/9rbmm2i/GwSCJTyG2T+MDZpvYqGmNC9ttM7Nl/5tAGLIKgN4PUjbgyo4VLC0V3QHEc5uo6nKPXd7DOriI2w4tEz5sWsy86KpB4mm79j2cR5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:53=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wr=
ote:
>
> Adding a device to an existing priority ring reuses the per-CPU reader
> storage. A ring that previously contained one device can therefore keep
> every CPU at the old common starting offset after peers are added.
> Deleting devices or rings can likewise leave offsets and quotas that
> describe the previous membership.
>
> Reset the valid per-CPU ring offsets and quotas after peer insertion and
> every nonempty deletion. Run the initialization helper under the topology
> writer, which excludes allocation walks, without allocating new reader
> storage or adding selector hot-path work.
>
> Use cpu-id modulo placement for a fresh best-effort rotation across all
> valid rings. This does not move existing slots or guarantee strict balanc=
e
> for every active CPU subset. Mask and availability transitions do not
> trigger the topology reset.
>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0c192844b121..eb2128132455 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -497,6 +497,7 @@ static int swap_queue_add(struct swap_info_struct *si=
,
>         spin_unlock(&swap_queue_update_lock);
>         memalloc_noreclaim_restore(noreclaim_flag);
>         kfree(old_ring);
> +       swap_queue_reset_readers();
>         return 0;
>
>  failed:
> @@ -569,6 +570,8 @@ static void swap_queue_del(struct swap_info_struct *s=
i)
>                         swap_queue_install_readers(NULL, 0);
>         }
>         spin_unlock(&swap_queue_update_lock);
> +       if (swap_queue_len)
> +               swap_queue_reset_readers();
>
>         kfree(old_ring);
>         kfree(old_queue);
>

Makes sense, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

