Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9D9606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X5+uycy4
Received: by kanga.kvack.org (Postfix)
	id F29C76B05BA; Thu, 29 Oct 2026 11:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F019C6B05BB; Thu, 29 Oct 2026 11:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DCE6B05C0; Thu, 29 Oct 2026 11:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40866B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:11:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FE99140431
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:10 +0000 (UTC)
X-FDA: 85376001900.06.788909A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DDAD180011
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5+uycy4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793286668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqTgnnNUxdGiYEW6DlaEOJ5z5Gde7KefjLv+VuU08fk=;
	b=Dx9OUd+DHTGB4z8MUhRRA/cLzxAtYkAMtUvvuHmVrPdb3yEpeMuzzQ3lTmfgiseTF9rGv3
	kYSc26prpkebt6pMnXKfmdn56BBFJphHEN/SesxyqDYgFDQpumTXVYrXmY3ZvMFMYCSoIz
	HxKN3ncqb9e2ZQvIHooY9sr/UeJ9d6U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5+uycy4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793286668;
	b=k+q1Mq9bc3L3ClgAG3IZ72LG+hAJrAHl3Zj9dUpmMf4dOHHC0/GnOBctiS1eKseJm1i/6U
	RdLuREEYhIlEprAUaOJHEKYzM0iAEEZIgUQPrmeYos1qNE3D/7VqzLeafzioN5+23eVYNV
	SFmHdTS8MwJO9/WkfUDg1MmCOQABrF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72DBC605CB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1B01F031E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793286667;
	bh=ZqTgnnNUxdGiYEW6DlaEOJ5z5Gde7KefjLv+VuU08fk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X5+uycy40K8tl/gLvfiZzMF1U+BC+VSnRxUxnhz6FhJqS/ennwlndEwlRsdbqUQER
	 cBSNUAtaVWdNLYPKla2hL1ddgwSq7pxoaNCsdHwfKLtAOgnsfjVfDWvwe1zn8PeUjy
	 HqxzURiLHvu1Rm/OvszEI1w/ykjLQgtiAkxIyp+1WgFoFnJlSrvkQxWKCPULGrkFoX
	 bC9FAR3UjOx3DoHXjjkDjuffC1bvftXCs0kL2kP8NOeqQ5dn7ubTrn+BwEGBAM+1hI
	 yPB1whMxyvE4eZjWtwGgM7dLA5aDXiYUrpiNCN1/s/om20pQejrD2tGGCXwnxm4Rma
	 Xyzhnlu+sUY0w==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c434376dbebso192530966b.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:11:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzTg84WlmPDqHbV5uNof40b7CbDKdN3YiDwDc/6xBlUb2r09XznlatQyzsPDtYDRd5HTEZ8/TNHdg==@kvack.org
X-Gm-Message-State: AFq9FYLBfPB53HTgubNZHRCh5YxInEcZpB5ghZ6KPCCr4/sBmkDpvoMV
	QDbtdru7eowJRtIjk5UHVxS9dGo12o0gOgpUFLkc6Syl1Zaw3h3csup6RX//ag6Zk9ciyWPaWvp
	Ox96jqOkTVl/kljE6sbQUIZGl32zALzU=
X-Received: by 2002:a17:907:6d0a:b0:c42:6632:a369 with SMTP id
 a640c23a62f3a-c49d1298d10mr274706866b.21.1793286666112; Thu, 29 Oct 2026
 08:11:06 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
 <auJkvb-Lq0M5Enkz@cmpxchg.org> <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
In-Reply-To: <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 08:10:54 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
X-Gm-Features: AclHuK9UiJ3AeOpD0_o7obusrkhCcVmC8X2efUUrguVLj8iQz-lYuV7lcHEm0Q0
Message-ID: <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on writeback
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4DDAD180011
X-Stat-Signature: 5en1m1oj6k7uxtyhakq4pdan86xmhyqc
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793286668-975533
X-HE-Meta: U2FsdGVkX1+MkrX/wAUOK3mgH1hRT1+UmkKrq34WtfuULKXYldo2OzpX159E3YyOhzfLs4ZlsWsPsAoCvekG8abd9AEn+jUL0KbaRgZNyclvDXXBbdf/gBl9kKx4Z9nhOMUwKSCs94INQA65L/oJzDCBtYoUgWSiNFP4yMMW73ZTou9bG+ZrcKgRLX4qs3zAVuOb3cw5hI7ewPtrwKJPspUgezbStL269LkcMp1dJxiOWKwR5y6QSaFntJ2kViiDWE1jVHI2ija0+jpTMMCPYDtAVZeP3ZFPjvRacyhZAbB6XIhSiBiruZBr6GkaA2zOgPPm8z7XLBVYY6H7OSRfeCa2KWEqHZMlRs+4uYrikwvy2ge7hBfK64I5AAiFjSpqKMlMU3T4Auc2NvvVXqVxY37yiFzUXkpTREotr4+GyinwM710xOImpuo33J28OVHiAEh4BWOYWR7R0sgtAIaV81+TZVynk6jJzaI+5gkg061uuWQPzHvPZXpAeBtfhMlI5jyni9SWQZdwkpgSlzn7JTw8HWr5veHg/idrwYfYefhqBSdUFtPeIiA4nl/Dx79S7MSOQ18AnLK5nYVDQV2zG3yg3MwkN4D+LWhdYplFaNc/erW/jR5YUsT0oHRA32FXwPUMAErIDrolygFhaYc0sCVtmhpCYm4AF+KgdLMwluv9yJFL5a4oW07eyKHVkC6uxanVjTIV1cu7Wfu4n3pznnJOdQiydFRKKnB62y08RQXI5eE1HC9ahDvXtF2jf7zWv8B+5aMSvvE7Szo6LnR7On+ItUU0Z/7qVmL1tArLx2NjIGE2riIAcyVVImfepi8jHgG4RiXI3Wg2bgzjgu82Eei7gR4GDOSNXeOS/sOGw9E+l7ivikW8r1YCqDd+DwJ6aIOfjd4bkJPEoXvxLGfiWfZ/0F8TY0GD4BKsFImVgXe1Kszol/rqKnQ0fV4owh3MQhElvOWwSxPjDzqKoL+
 C2MapMoy
 4D1CYMS9+Qw51syy6jot7uaPoOFkRK660oeZHwikZDgNydWqo2vLLshG28WYbkHP1HW9C/6VEnkJ1gqE39cgaZKgGuazHkU/jryxpKLwDTXPshK8SGs7PknnowBtMsKfYowrtarB/E5tMX+ajvrm+EC84rQakhuC7x3dI6xwkIV/9O/heU4yGEupgJKlLD+lb9TB9lRXAFEZY6Pc31o7sxdsX+tk/oTJcS83P/Uwgi+DYFp4UE8ggJusI4JMFmHx0ILFQ3fj0qM64Rhe27XbgkBzzt+X7HFijMSSU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 9:23=E2=80=AFPM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
>
>
> =E5=9C=A8 2026/10/29 05:10, Johannes Weiner =E5=86=99=E9=81=93:
> > On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
> >> On Wed, Oct 28, 2026 at 4:36=E2=80=AFAM Kaitao Cheng <kaitao.cheng@lin=
ux.dev> wrote:
> >>>
> >>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>>
> >>> Successful writeback calls zswap_entry_free(), which removes the entr=
y
> >>> from the LRU and decrements both the sublist and node item counts.
> >>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU wal=
ker
> >>> to decrement the node count again.
> >>
> >> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
> >> LRU_DELETED instead to simply avoid the decrement.
> >
> > It bugs me that it's the walker, not the callback, that adjusts the
> > count. That composes poorly with the normal list manipulation API.
> >
> > How about pushing the accounting into the isolation callback, which
> > can then simply use __list_lru_del()?
> >
> > The tradeoff is that more things need to be passed into the isolation
> > callback, but that seems reasonable. It does make the change noisy,
> > however, and we might want something like Kaitao's change as a
> > backportable fix first regardless.
>
> I tried three approaches.
>
> The first was "pushing the accounting into the isolation callback", as
> Johannes Weiner suggested. However, as Johannes's example below also show=
s,
> this would require extensive changes across multiple subsystems. I doubte=
d
> that such a broad change would be accepted, so I dropped this approach.
>
> The second was to add a new flag to enum lru_status, as Yosry Ahmed sugge=
sted,
> to handle cases like zswap where the callback has already decremented the
> count. However, the incorrect lru->node[nid].nr_items value in zswap is o=
nly
> an accounting issue: I could not find any code that reads this counter fo=
r
> zswap. Changing a generic interface to fix an accounting error with no
> apparent functional impact did not seem worthwhile.
>
> The third approach is the one implemented in this patch. It keeps the cha=
nges
> within zswap and fixes the accounting issue, so I think it is appropriate=
.

I honestly think it's a problem with the list_lru API, as Johannes
said, walkers compose poorly with the API. So I prefer we either take
Johannes's suggestion or add LRU_DELETED, unless there's strong
objection to both ideas.

FWIW, we don't need a minimal fix for backports, I don't think this
needs to be backported at all. As Kaitao said, I don't think the wrong
list_lru count is being used anywhere for zswap.

