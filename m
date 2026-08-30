Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE74C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA626B0088; Sun, 30 Aug 2026 04:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9842B6B008A; Sun, 30 Aug 2026 04:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8259B6B008C; Sun, 30 Aug 2026 04:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5287B6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:57:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0B1E16027B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:57:33 +0000 (UTC)
X-FDA: 85157332386.15.CC69C37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEA8A140003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:57:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqxJpBEt;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788080251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=029+faS5ZzWsov4hpcUm5x/4rseKLpq/BvplkVhE40Q=;
	b=kC2zm1XUIGTGtwr5cAetQZpoklLBO4+i4zOWwl13njW/NdQFXwnVIpMewTIW6ut94rmilB
	3GnwgUh1G3otw2gUgazrrFvPNFy8ZCi+33UZhGuOzJuoBkc+ZSso9GHzgt2VpRhjMabExf
	5YRquclNW4IN0yeLL1oYFhNSH4ubnr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788080251;
	b=u+OG2Sb5/WbayVlC1TVAXu52cvcy1cEZQft+r52elhZv8BUI8NLykkoeR+pu2eWRTkg9fD
	/GzWY+gZt37NuA1DR8KFcSV6t7r5FjFfNK2OWrt8wVk0rURx6thLJa3C0EKV1SU6H+fYax
	qC+DNFonH+YzTJwtnrikCArTVthn6Nk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqxJpBEt;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D69F600C8
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE131F0155A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788080251;
	bh=029+faS5ZzWsov4hpcUm5x/4rseKLpq/BvplkVhE40Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oqxJpBEt3n/PrGLolRfZZ7q7RTLGVwOKqEZrxdigyJmNaxBaixGYhIkZxi2c5aHwD
	 zunXvrJiXLvdfJs1+0b3rPl0Y12AJ6soo/nCjQKUUc1BAfJfxfp9TUJdt6hnaVQ5Xv
	 EOylIyrS38eh5Fzk+dcH48n0ojGUMd2gnf020FT3U/1Gcnp3OqcRsb6YSMxUiPJQDF
	 8CefjlqcToWNeNbAvueJxf/Hsb0MyCeMlYp437F6XPwy4Crs8HHWbPfdJdUMQclMCk
	 CPhTPBIGDk+KRETf7XulrJk+h2d4YVk2vmGBwsCXP8eRAnUKt7aRL6YxuvwEqPA/JQ
	 9/X7BSHxiyo4g==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9384cb251fbso114143385a.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:57:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpMoYT9KKGC3iFvDMccaHXrahMpRTtzSnPsUZuQCMxZs5hjXLqR62M0ULQI37KzNI5Ol+7Gmr9Q6g==@kvack.org
X-Gm-Message-State: AFuF++ndCJ1lDtIdoPqOx73efCX7GX7JfYzp7qQYzRjs2ItEygkuKj8D
	SzwDrnfuyPXMQncuyRQiMbvCIQDlVZD34uuqLsi4PQNwiqsJtvP67/2NiK+Z/gt0Y68FfQOtaCj
	iPcrLSn1CJzUBPS1Tq0D8uSYCWyQhW8g=
X-Received: by 2002:a05:620a:5d83:b0:92f:279:5953 with SMTP id
 af79cd13be357-939138ae01emr1707149385a.27.1788080250323; Sun, 30 Aug 2026
 01:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu> <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
 <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
In-Reply-To: <6672b30b-427f-45ed-a172-4c47a63d2c7c@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 16:57:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
X-Gm-Features: AcwNN1UV9cGDBED4rxscU4sOzbiEGy-p9iJ4uD11AMCMxh60PQMZXIFRTunlV-4
Message-ID: <CAGsJ_4y8tAh8A8pfi5TJEtPq-JMPjrLX4gCLvesmPNYuZdWCCA@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion infrastructure
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEA8A140003
X-Stat-Signature: 3nyuxdg7ynozq1uao77kykni3sga4ony
X-HE-Tag: 1788080251-551736
X-HE-Meta: U2FsdGVkX19JNQvmv0h18JclnOs/aUJY2fNIqdKpqsZF9abTBf99u9fps9u6Mb0AkZzTX7uTCpLKkuYxD3aM2nv2ZaGoq6FMF55/6BWhdQhv0JsVBjoEcvaxqHJFr1zBVv8ISaqPh4o96U9QxLy6N9PtHucuPBw1llZ2p5U4dVXnqmuWWGeH52AzQLeg1SRhi/8xsN9Wd+/Wx0XDq/w4Y0h8iUsHeXl4Uz34sk48f143YcM+Csj6aIHiN3wPK46vYe0osFMGRcCmsaLhiST7VKPWPP1ZCzZPYNIuUzhYgcScbwCf50SUQQ+SdHQmw+gYcTsf9ZjbPGTxOTke74xL6rEZGccuKGPvGtRvWnzizSJyVx/OFnA39vB8Lo0HvaBU1uNk0Y+QxJQWbzjKw7fUOIPaUQMCZkcruR/9xKz7DCJ/6QN7Bsh1VLUdaKsxKI5b7J+YPHzF+3VhOmMoJpwoDeV1BLGefCblegc13mAKUCgx4MR9tb8lR76tgPcAmoo6AsArV+TIzvioZk2AyhYe1jQaaVdR4lgQAtt+reU0+21QnSXieZhBDzd7Xd14VsIbqwNBTyz8Y9PUIRlCftk4UkOMdtfNrQnJRGFFSsOA8zMvtwV9v4ZuzibElOPywqG6259fUcU6i0n96DfDz3eFovHjFi9vutCYjPd+EjroG8V6A8KvgtjDVz6RhQmOnSf9ViAU1aZVY7zt4uFMKxQ5E3sdKMgb4+eZgDMLLMkV0EGzr+RLLcexGT5n16UjAetAt55B1UjUrBgj3k04WjkK375Mc0ooEr37nbhunk88OX9zWwJrDJPnvzeKQdNcOKROM6MYNFoDUpom8DjlomrdJKSuGsE0mSCuGYamHDpmt+JnKXOl3jKqyxkhWiZouUC/4u7o8RdCwCxkJGxlcxITMKz5nOImGKXYN/bPsKMGJu0V8nau2GsbKA7OEg/a86MGZ7NJZQwL0TpIExFRcEi
 fx3a2GFh
 CBT3qWSQaHOu7cPA8U/vmdtAYuG5ODbBTBNus0N9IdLpV7KMTl3eiiV15QKnnYxj0dVM3ZlboGEldshTakS/1wAakj0iS6HVF6pT83CY3CtPG5vBLu6AqSC9XQTILCa3naTyOsvGsdvp0M/1j51e6w3pUIAcIDwYcgEZOQ5DD/l/Kbn2ourCC7pKZBLIXPS/UzEvb7Nz5BQhaNFCiHUE/mrjSVvTqdq3MH7G05z4lHHiQ43zxFNGft85l7LGtAcpESMfq5g3r+zNxgGpf/NZxVw+O09WMOu3U/gdNyBobJXoIfGZ35qAoJcXS/BW/k8GyEqBu+G/fY8U5n40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 11:26=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> =
wrote:
>
> On 8/16/26 7:11 AM, Barry Song wrote:
> > Hi Tal,
> >
> > Thanks very much for the patch. I=E2=80=99m just a bit confused that
> > folio_end_dropbehind() only requires in_task(), and nothing more.
> >
> > void folio_end_dropbehind(struct folio *folio)
> > {
> >          if (!folio_test_dropbehind(folio))
> >                  return;
> >
> >          /*
> >           * Hitting !in_task() should not happen off RWF_DONTCACHE writ=
eback,
> >           * but can happen if normal writeback just happens to find dir=
ty folios
> >           * that were created as part of uncached writeback, and that w=
riteback
> >           * would otherwise not need non-IRQ handling. Just skip the
> >           * invalidation in that case.
> >           */
> >          if (in_task() && folio_trylock(folio)) {
> >                  filemap_end_dropbehind(folio);
> >                  folio_unlock(folio);
> >          }
> > }
> >
> > But we=E2=80=99re applying a much stricter check with bio_in_atomic():
> >
> > +static inline bool bio_in_atomic(void)
> > +{
> > +     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> > +           return true;
> > +     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> > +           return true;
> > +      return !preemptible();
> > +}
> >
> > I feel like something may be missing either in
> > folio_end_dropbehind() itself or somewhere in the
> > filesystem/block-device path.
> >
> > Do you know why they don=E2=80=99t match each other?
> >
> > Best Regards
> > Barry
> >
>
> Hi Barry,
>
> Apologies for the delay.
>
> As far as I can tell, the in_task() in folio_end_dropbehind() wasn't mean=
t
> to be a generic test for if it's safe to sleep, but rather filtered out t=
he
> known unsafe case of buffer_head writeback completing from IRQ context.
> In contrast, the bio_in_atomic() check needs to be stricter since the bi_=
end_io()
> callbacks could sleep or the callers could be holding locks, RCU, etc.
>
> I see there's some more discussion about this at [1], but I suspect there=
 are
> other instances that are (incorrectly) using in_task() as a proxy for bei=
ng able
> to sleep (like f2fs_read_end_io(), but I haven't looked too closely at it=
).
>
> Additionally, it probably only makes sense to use bio_in_atomic() when th=
ere's
> some deferral path, since with CONFIG_PREEMPT_COUNT=3Dn, it'll always ret=
urn true.

Tal, thanks very much for your reply and the kind clarification. It
seems you're right, and I think we should also use `bio_in_atomic()` in
`folio_end_dropbehind()`.

On the other hand, as I mentioned in another thread[1], I really feel that
`bio_in_atomic()` has nothing to do with `bio` at all; it's really a
scheduler thing. We may want to move it to the scheduler layer and
discuss it there.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xxDpeaPv9Uh_1qsuXsMLkx+J0X=3D2V=
6342idLFO5jkTBw@mail.gmail.com/

Best Regards
Barry

