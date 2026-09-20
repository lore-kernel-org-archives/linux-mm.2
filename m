Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D667C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 21:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1AA6B00E1; Sun, 20 Sep 2026 17:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492E96B00E2; Sun, 20 Sep 2026 17:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381FD6B00E3; Sun, 20 Sep 2026 17:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDFF6B00E1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:49:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05226160506
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:49:46 +0000 (UTC)
X-FDA: 85235483214.09.132F942
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2392B180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:49:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvFGheVa;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789940985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NBZKYQ5+644W7iKg6cKXd/Toi8ijTijHQiwjqEQzlA=;
	b=G7SIF/b6ePTgGt/vNktwkepBBt57M03fhtczNzvLapj4qQg8G3wtfzFD/zEn8roGO+flDC
	udZNeitKBset6bXL2/2n5zo4in2BRJuoZYS6lkNOq/ThbSGVNhJnh1f5BmRU1kkLoLvOWF
	269PKCdLISYJi32JcsMKzJmG5xVDtuk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvFGheVa;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789940985;
	b=j7FdLwHwGM257NCm47BWKwXyIt6q4fcHdPdhMCdOBhPpqvaqJI+MCY45YHUcjI07jrvp7G
	EPZT5vC3XVYTNVLRCWMllhAvHhmTCIENkEttNkRnQTTkHRfJ0k4iqo8vUtcu0KYSTbzdEj
	ItEs5xs60fcJYuc+vcfeM1bHcYsze0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4135260FA4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93711F0089F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789940983;
	bh=6NBZKYQ5+644W7iKg6cKXd/Toi8ijTijHQiwjqEQzlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BvFGheValM+LdW9CE4n0ucdO7Xmq/Kzen73R6jTieE4npSIIKj/9LcuTJCc6RNpFx
	 Nw+8X2Ztqj7pouxLbg+WAldwnBl/7BoKiu9Vwr2M1LvYzrMPF/M/yMMEE9rVtwaCi/
	 UlfA6Zs0JlhdJInf+M1DMUqUrGEk8MGPbSFKnXC/z0AjpQVaSPu6KMvKJtsODlfa/o
	 I1FotYC8kIhXNYvglA9iKxPst0qsVoBSL0Y9Ovb43eflDmYNipm5ZouEmMlNWtvJII
	 NXefU3r3lTJaTJke6YkzRrNYagbl+teUE8aaX1IPm9nL+PdXTteCHc6WkKue59XiqH
	 4nwXOnhqnjWIw==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a2a8c29c4so261486585a.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:49:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz8d4Ctd2xrzVLJHP+Vlen4Zv63TpKc8I8BMQ3Dz8hanz/zIUAy+JeUVzBZghEUKy8m3Bn6BdUPwg==@kvack.org
X-Gm-Message-State: AFuF++nyAq1EzZQlc8KQgV5RJFgHQa5LH6XukjYZCHHpNY3Zd9WGFGvW
	KaKT4AITrgmI09L9v3GQh7vNUU8jTDsXTXQqsBmv/+DiafunVMNE13qKbUzVRFYfJdcnvkvn35w
	UNAZAAKjXU+ng2pz8buM8BwGVvLgDmUc=
X-Received: by 2002:a05:620a:880d:b0:939:8ecf:6025 with SMTP id
 af79cd13be357-93bf552d221mr744743585a.20.1789940983277; Sun, 20 Sep 2026
 14:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
 <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com> <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
 <20260920143816.39827-1-zippermonkey@icloud.com>
In-Reply-To: <20260920143816.39827-1-zippermonkey@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 05:49:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yhHw=AAaBTeaj4dk7Hbmprs_30VZ+cSodB4Z1vDZJGZw@mail.gmail.com>
X-Gm-Features: AcwNN1WP_FveN4o5OYDbzdKXOMdJEkJ1ZIgn4EAzu0QuygPwT-XH39cssd_fBB8
Message-ID: <CAGsJ_4yhHw=AAaBTeaj4dk7Hbmprs_30VZ+cSodB4Z1vDZJGZw@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] mm/vmscan: introduce folio_activate_locked() helper
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Kairui Song <kasong@tencent.com>, 
	Zhang Peng <bruzzhang@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2392B180002
X-Stat-Signature: 7pzkjysrtci5f65s3h89nf6mfw757xdj
X-Rspam-User: 
X-HE-Tag: 1789940985-228655
X-HE-Meta: U2FsdGVkX1/brv42GDzFB9gO28Yll3TqOTQk4ddAaY4RhCY2isF2M6MJpjvvQXHWkIPUDSOltxl/EoSSbzAAVNmA1aCp+kr3HtbcE8qrJq5rVV9cO/Auyt+bkNLpF0XYtBZtdmgOz91+jdfjfQ5n8+c+kWMKuZmFaN2hSl/uYLpgi9D8YE86A2hlMPk66NLM3VgNt15iC2Xl8LOegSyZSYufWUrHde3PYIuh9hNZz3rC9Xkv93DcprSBAtRXY8FuHRNynscx0xeQv7C6qZCD0QVTCqzzKiPtRaFFDz9QDEvumgpGO8aZL/t7c3bdz7184EILXLcPBdZ+AGF8w4YSjwKQ5fEQEYs+kGsWzJz0SyVO2Hu/VH39n51icIf9T6maKpLPSY+kBDE+rSe2lFOObkiAE+L1r2lkycI2W2Ym0YRUnzHECFyiZeNtVmslPmBRWngsylyXo/sFsuVAbmGEGBg+3l1TM0IoG2VExQ9iT16TkcO/WQk6XCIK/DXCLeOwAbLXF9bB/eaqmru9NBaPSjrYImPuZuySyjaQv54PFJON2rjXLbR2ux7XGFFBeqvTdLKccxmBPPfklXEBy4ukL3J9M7dtqzdR5rm/pIeaXfhyxu8RqHgdKFIUisX3Ee5bsqFQ7R7F+Zs6c1b0+6MTS/QxpwVwrG9v4QlmOby+ocMzJN+SYr00YU1kPo4cDjvcMB6g8PEV/HGhSVsFg4oKTwySs/73dcC5hexwphl6t1JKTy40HX+H3/db7+fGU45DBvf2mvFPse5eQuaf785hUm5fdxzplQhKLFdZLsI0zbmlF2izVGyFYG1TlmGLA8ZC1parLyVtgl2FMQe9Jm3N/ZkLOeQYNkQgYMOxkBtXMC3Cp/LyrO9FgbWxnS5KLJVgZ9qhLnqaOcH9F7bJXbAYBoZwk0UJhF8Mk1RxiiajeRfGts3EkES3w7gm3AQDmIWc7LLymKG0gJUfXvNbLDp
 O+UEp8aN
 zsxeM5synmG7LLEC6WUTUDbSpjxW11It/Wmg7EZXJ7pJjjzfMP4Y0zPFlW5BV3AfYesAoOOaD3OqXrRpBuQq6IIsS2palqwmorb9fjA8ACyJTODz4HtkLRLXIIqJ/rW4c50+TIbstM4elFBZ/jflO878wEnmlBIvWbcVORSXPwO0Vyf1OOpBaWjvK+g0YFJEhARSsJhdr6XulqXM2V9AngCoLpU5RBGdvo0RJwcLjrBOrsugvFHWlaYtZrs1LfBojK/JWxqw9BMpLjFLfijsViMi4kF72ncQTGUQbB0lP9npRPwU9Nevn1GE9gDChS/MCagxpDYwaXxh7k8VIBpOHDKFGz3W3pVjAKz/LLJ2LXoLqa8WjuL8APhFYr9aaDlzxvS8e9LzIvYcMsZb7itrjsT+4sX4aWFMI/qtPoDqsE8ht5qrbueP+j0k8JCGIcBt7BrwDmnvbilA/LG6b1rk3rxxvtyZLTv6n51u9EH8u0tlJvswGolSIHrS41bDZo0LYu6OXs08I0101J6zPbQb6KyJud2EDrQ1Z7dhPF68kd/Mcl0CTbl0d+eEy+vxsmOR1XQ+fBeP/IDhwOw37WrARvx0DYOf4ou6YQkRcokoSKakz0aWpaUOkogTXt96A/NxwNN0D1KGhUxktMaZeEHmEQxi7srztlqlEr10IB2SkNqUeS3WO2YhBaVXACptwTedQz75IVlAhZXJPZNMSpGFcwJZEE7l0iWMjIKb+nSV2Dzr3DajJbbvYoxOj3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 10:38=E2=80=AFPM Zhang Peng <zippermonkey@icloud.co=
m> wrote:
>
> On Mon, Aug 10, 2026 at 4:36 PM Barry Song <baohua@kernel.org> wrote:
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks for the review!
>
> > > + * Prepare a locked folio to be kept active rather than reclaimed.
> > > + * Reclaims its swap slot if it will not be swapped, then marks it
> >
> > I'm not quite sure whether this should be "if". Because, it seems
> > to always be true up to this point. BTW, if we really want to use
> > "if", shouldn't we use it to check whether swap is full?
>
> You're right, the wording was misleading: the condition that actually
> guards folio_free_swap() is the swapcache/swap-full/mlocked test right
> below it, not anything about whether the folio "will be swapped".
>
> Rather than try to restate that in prose, I dropped the paragraph and
> left a single line, since the code below is already explicit:
>
>         /* Activate an isolated, locked folio and account the activation.=
 */
>         static void folio_activate_locked(struct folio *folio,
>                         struct reclaim_stat *stat)
>
> One thing I should flag, since it is not just a comment change: the
> VM_BUG_ON_FOLIO(folio_test_active(folio)) that used to sit at the
> activate_locked label is now a VM_WARN_ON_ONCE_FOLIO(), so a caller
> that gets this wrong is reported rather than taking the machine down.
> Both are CONFIG_DEBUG_VM-only, and no non-debug behaviour changes, but
> it is a deliberate change rather than a pure move, and the changelog
> now says so.
>
> I kept your Reviewed-by on that basis - please let me know if you'd
> rather I dropped it, or if you'd prefer the BUG_ON left alone.
>
> This patch is now part of a smaller cleanup-only series, see my reply
> on 5/5.
>
> Thanks
> Zhang Peng
>
> From nobody Sun Sep 20 00:00:00 2026
> From: Zhang Peng <zippermonkey@icloud.com>
> To: Barry Song <baohua@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>,
>         David Hildenbrand <david@kernel.org>,
>         Lorenzo Stoakes <ljs@kernel.org>,
>         Vlastimil Babka <vbabka@kernel.org>,
>         Mike Rapoport <rppt@kernel.org>,
>         Suren Baghdasaryan <surenb@google.com>,
>         Michal Hocko <mhocko@suse.com>,
>         Michal Hocko <mhocko@kernel.org>,
>         Johannes Weiner <hannes@cmpxchg.org>,
>         Shakeel Butt <shakeel.butt@linux.dev>,
>         Axel Rasmussen <axelrasmussen@google.com>,
>         Yuanchu Xie <yuanchu@google.com>,
>         Wei Xu <weixugc@google.com>,
>         Qi Zheng <qi.zheng@linux.dev>,
>         "Liam R. Howlett" <liam@infradead.org>,
>         Kairui Song <kasong@tencent.com>,
>         Zhang Peng <bruzzhang@tencent.com>,
>         linux-mm@kvack.org,
>         linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v5 2/5] mm/vmscan: extract folio_free() from shrink_f=
olio_list()
> Date: Sun, 20 Sep 2026 14:14:37 +0800
> References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
>  <20260720-batch-tlb-flush-v5-2-db943a0d0d6b@icloud.com>
>  <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gmail.com>
> In-Reply-To: <CAGsJ_4ykbJKVqEv6uGNKZaQhtV1UxxV-MWt7D1jx6SpdMN+cqA@mail.gm=
ail.com>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> On Fri, Aug 14, 2026 at 5:40 AM Barry Song <baohua@kernel.org> wrote:
> >
> > Could we avoid hiding the activate semantics inside
> > folio_try_reclaim_free()? It makes the logic harder to read and
> > can be confusing.
> >
> > Could we pull this out so that the three possible outcomes are
> > explicit?
> >
> > 1. activate
> > 2. keep
> > 3. free
> [...]

Also, Peng, I'm struggling to follow what you're saying. Could you
please reply directly to the comments where I asked the questions?

Please don't collect comments from so many different patches in one
place and reply to them all together. This makes it very difficult to
keep the context and causes a lot of unnecessary back-and-forth.

Best Regards
Barry

