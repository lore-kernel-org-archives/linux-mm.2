Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4933606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=aSP8IXuQ
Received: by kanga.kvack.org (Postfix)
	id A03006B09F2; Thu, 22 Oct 2026 18:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DAE56B09F4; Thu, 22 Oct 2026 18:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918916B09F5; Thu, 22 Oct 2026 18:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6876B09F2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:05:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D95AE1A030E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:05:25 +0000 (UTC)
X-FDA: 85351644210.14.91C9120
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19FE32000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:05:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aSP8IXuQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3oojaagsKCHsrtrddmcqZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--suseendranb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3oojaagsKCHsrtrddmcqZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--suseendranb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
	b=jGUgwu3IA7NlWcMrXHTQSv6ioEVSaIkEBrkFGdqdAjQK2Kq2X0CekhXoX0IOPxt3YjcUsk
	Tf46dM8yBGCX9peMbwbYWPFC45XSyCcPK0xJshuCw9rPcSoW8Dlmgsy4EZnsOKh2KleDnB
	92ABVpNuXHA5j7fjMUgZasHd/0l5KAM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aSP8IXuQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3oojaagsKCHsrtrddmcqZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--suseendranb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3oojaagsKCHsrtrddmcqZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--suseendranb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706724;
	b=FdA/gJE5teCtFWXHzPpQsSo3vSCKtDcYTUo9GGY1stAT3OTcKfMo7nY8u7/DFx5BWPv5kv
	wwnlq0bgfUsklQQpEgLZIZzBhf0kuRl0UFW+WOHw2MOFVLFntUd2inM8pbYdO+Cie0tzh5
	NhO7/IJ5Im9RI9mEFLLBEgtLerWx5lo=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd6969473a4so152636a12.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792706723; x=1793311523; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
        b=aSP8IXuQ4KqfIwJFlK0qGSZ3U4yoy1p+dT1hPw9nZYqiitYDr8Rx2Q4A1U3saS2typ
         DEW76qcWVCvSj8OswHOFuVj+KRcck0xPJAxDNeOtlcN8CTA7RJ8L2zAVAkcTtbr1YGKZ
         HCsKVMd4L46KNIPr8vW024fvuqVMv3piwbl4Df0h/O1wejm1FK6kaoaBDeAOUPC7/0PW
         0j/TD0AHKNYtn85Jn7xX1JYiu12R6ODDvFioNauTv/JTmAgJzMjntD93h5AxiAuVicpI
         yIlWQSqqGEAXYkqKH1KnIe7ChfPSw7c2HaavhgY8LUC2v2QfniEW0/zSkwJuBoJC9Ueo
         iEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792706723; x=1793311523;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1/BUQdhYtXycx0vnNfE9NP3iNYT1zXH+kKAKzMrdrV0=;
        b=Es0Q71aA3Cf889vC+o+FKV2OGKsitWEClFz8wJdl8Pzgv6/PGVfDsHTRpXFMNvC/x9
         UQbEUJN7w6xLxNp9iPXmDo0PxccPemOgaNsnljKyPklBv6vdyIhvERTPqR/drhZyArs4
         9gEcBeWsQ1t4sLseK/Nbq1p6uIawV21VVI/qf79DowixqY6kKGCaL96zfD8EaQDDyPuz
         bWFpQjX/kT/wZtuWEYA9QmOZyT6or4V9AXM/5/kodG93iuP3dO2a4cPCrssjf74r7MPY
         K0noH1BRkvc6n8DJLFmcTgrmalLOFZ9brDa6ICasHTAT/JYGL+n48F0fPSqg6HvH9feK
         H7lA==
X-Forwarded-Encrypted: i=1; AKwUvBxyX1BcsvoU8RxZNsLoFjoN6nQ0d1R0NorEqR24ydkR/VuZCsR0gIzBQRPByToXdK8MsKTBKO9YPg==@kvack.org
X-Gm-Message-State: AFq9FYLpHEbtKG+CWron0bmPV5Klji6SMOc9SwowNO3/GR2TeSBEQVpB
	XWMLw7WvDQCTNKfK5afyUeG3uJkWSyHfmVnAQu4BGMm2mXwlNR1jsDJ0Vv+RHuB09SuJKktdlSs
	YCZfji938S1YjP2MvXE9v1HEc1Q==
X-Received: from pfblr27.prod.google.com ([2002:a05:6a00:739b:b0:88d:74fb:fa56])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:748b:b0:3e2:7030:9080 with SMTP id adf61e73a8af0-3e36945eec6mr190250637.47.1792706722405;
 Thu, 22 Oct 2026 15:05:22 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:05:16 +0000
In-Reply-To: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
 <20261022183319.163484-1-suseendranb@google.com> <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022220516.383697-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 19FE32000B
X-Stat-Signature: 9txq4txd97xfqfiwskedasjxnt1eqdnn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792706723-188950
X-HE-Meta: U2FsdGVkX1/OI/nvmhocK7f/v4kBmnHgj/KA4BxZ2yQzwGM8kZqAShSIAgJD/3UrtACHZZ98BmN+oQ+QNJcF9dDe/cmpF4TJ6pouOmoB9GNyns9VUXiekgbSN6l5cwp+bQeFj9gAsTzzv0WljmlO6ONbgbWTpL6XWQDNZjPYhoqZrXKI9eZoiqw8b54suI0imctT2lW99GhNlFvvgc2y+XdvcwA3dnhosP9e0uI8LWKLVK74Nh+aRhQiuwhLRi5Aezms0xC5agbLjVJLUzCeu4Esp28uUFMxW3Oqad0ka3mXOL8VI7CLM1jWO3kNUMRDIKpZMdKnFZvF2vqERLjAXDLjUimkzx1aEhqM0VBKXESGOFEk9ZA966niBaTSVsZYp1BPWWlKUMa5bZEU9RPhqSUSkohJ+uErZ0MbDeOhaBcVJO5uu/IOgEAK8j01TBx/XTjv9kl/9ZyuFG2A/E/OoxsrGbi4TbC58D0RwR3gkYEz2RvjX9wST6sPY0gUs6lMun1cJnOZD+h2TGGwmMu+SFe3KHc1xlGK15Sy5W3gzUBN5zbObm1k+fAuHnGzQwiWbwIvJ9TX5BW+RruGHIhnx1Myv1iOT29DfYQIY2FXpfmt8gWRzjndsxk83vw6CpPMQFYWPdplYIBMV1oDKQaPvcnuXazdNexT1azHFZxndHjmWTAjzaJIR9JI5Qhsp/7/mOuhr6kUohlifagE4Azi6IWjcM9Yntyh4SGZr48H5uKWj6bv89Ga3cfvU2/jSJhtHPjqvlJ7ms8cd7a3Rmmy/KrqXAlCtWb8uYWVJsFZyE9mgiFarG08dx0F2mJk2q1qZbdfT14Vs5OyAez6iYsPB/QNQf4wvGN6fwx65RmJOKz5aFV2niqP1Z0xATWk4YP3inSWeEHePQTk2Cnik9bAn/xWMOt6Gtf/gUIUYxR7fXv08iR/r5fpMRsoplWFiQGn4Epv/FBudYs2RCxQtnz
 xEmMc5Th
 UXZaV3ZfmGX+rY1k1ImeSOEBf0MduproKj/pitWurHYQdDihQNgiMqAPyiy7Me0d9uOBv0aP8AC0qia6u7zvpKVzB0xXBEhk0uO6YjJxoNVGQv0xG78QrIUtBYbuyM0CtXxz2hT26MzrJjQkR47Uimy++qxR1/vI+kUO2AAigESrx8BEeslpTGlqHkrMkRiI2+ts51SPzXBJT7xJ4+j2+zokfiR7FW8EylLGcYjeZ975g0CAI9meVUMl3v6sodkLTe6WIBByCxKaG4uuDxqSrsp9NngXBXqQQNd+Pde82satU/6P2TpWTvhaqYR8jadSdBBaPNuBlZ8Us+PnznZfzGMviQ/mrW4hKIUPx5grn1NA54V4iaPNIgyX35iEtTgkmoMJWHZVfZTfhrVhO1raf6NUtoXiYFpnHx7BaThQjgL4mWyyXpezhSiuUbPa+X2kizwMQwt98+sjs5IWnpAh3rgD4kf2X3iszOTHwGBOsb1t8I0kD46BLzFXXZyzdeblQg2JNxx6FWFIGH3G/zfYdwNxqMKillfQEZ2ijY1HPNZ+JrVFoQai103kUTmsUNpcoXiW/6MQZTGR/x4lULePrYZhdZW1Qzdt+ZCULPj87KCVKwWvXnPtGQ+q/CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 12:15:51PM -0700, Yosry Ahmed wrote:
> On Thu, Oct 22, 2026 at 11:33 AM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
[...]
> > Since dlen is only valid when !comp_ret, we could normalize comp_ret
> > first when !comp_ret and then just check 'if (comp_ret)':
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >          */
> >         comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> >         dlen = acomp_ctx->req->dlen;
> > +       if (!comp_ret) {
> > +               if (dlen == PAGE_SIZE)
> > +                       comp_ret = -ENOSPC;
> > +               else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> > +                       comp_ret = -EINVAL;
> > +       }
> >
> >         /*
> >          * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> >          * save the content as is without a compression, to keep the LRU order
> >          * of writebacks.  If writeback is disabled, reject the page since it
> >          * only adds metadata overhead.  swap_writeout() will put the page back
> >          * to the active LRU list in the case.
> >          */
> > -       if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> > +       if (comp_ret) {
> >                 rcu_read_lock();
> >                 if (!mem_cgroup_zswap_writeback_enabled(
> >                                         folio_memcg(page_folio(page)))) {
> >                         rcu_read_unlock();
> > -                       comp_ret = comp_ret ? comp_ret : -EINVAL;
> >                         goto unlock;
> >                 }
> >
> > Does this look good to you?
>
> Yes. I assume this is completely independent from patch 1, so we can
> tell Herbert to pick up patch 1 and send this separately?

Yes, this change is completely independent from patch 1. Herbert can
pick up patch 1 as-is.
I will address the latest Sashiko finding on patch 2 and send the updated
patch as a standalone change separately.

