Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D216606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 03:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mfSBNeKD
Received: by kanga.kvack.org (Postfix)
	id 58DDC6B05B0; Sat, 24 Oct 2026 23:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EDB6B05B1; Sat, 24 Oct 2026 23:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D726B05B2; Sat, 24 Oct 2026 23:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1953D6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 23:51:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E56F9C04F2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:51:43 +0000 (UTC)
X-FDA: 85359774486.17.6AF14ED
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0766F80003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:51:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mfSBNeKD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792900302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ktEcxrd0rxQ82zCOkrAw+tUGIyRtq9WOivmEZ+MVZQ=;
	b=3Bkq9JP7DxnYzz3kBSBPrDDCB1irP5ycvlhxeBLBlWUOfi6sn4qI1xVa4dTpFFy6QzaPn/
	MqVXo4kPIWnag+GycLwOwv0tO/KcHNuotNuYcjuLpE5Un+fQIyMDlJpxZMMiWELYl2ZKT/
	rlZ7VWbZKXiLRPz6LhEo/kzwHRRTEew=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mfSBNeKD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792900302;
	b=OIdgq8h6NmgUyHdr+FNlmOPrKFvFG1yegX9hEyLV4AAyCfwVXy8UDWo9LAg/l2uX6GHvb9
	NM12w3UvZhl+B7IBVXszGoJn240nCRVe+mBmgjQ8n8Q9pN+dahWBH9JLWvTDji1qa8FbiV
	rnpnlxQLKhzKptme0NK8IZOG7qe3LI4=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67a2efec15cso1920144d50.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 20:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792900301; cv=none;
        d=google.com; s=arc-20260327;
        b=WrEnW+YUzM2OJEijiD484wuPt4idNefNPxvrvctonvrvCi4o40Y54Ejnw6IaZqFlgz
         DykHc9L0Q11RL+gZJzT3M7yLFN7kF5yDzMJ92OahkRp8Z2BLe9i/Fifo58Vo6M9VNBNk
         PjKGMl6hBmOgNHK/vYTsUzUFoFEZNnmXzRTVBUWaoNbBkeF2Qhollll6mVStsSEECVZO
         QCgfrHJtrIBFKTcA0pSjuYEMmzsKq6yhSlXVNSiiTISzXydK9OgeZ3YVXxOn3EGQzfaQ
         AW4pIVZvobHIz1DIxqngo41CHvadz2V4GkHpV/ZlN/Aen/7xburIVHQgfqaEj2sdKbYq
         aCPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0ktEcxrd0rxQ82zCOkrAw+tUGIyRtq9WOivmEZ+MVZQ=;
        fh=vLJ7fkN/uVtxt+KHdw+0PDyhEdMUZZtSPOKddX3PHE4=;
        b=mahQFg89/9n6Mc9svVKFj/J0l1hXHKcxMrlxyuuZqbIzeLQFdFtPf8CT6DYLjsE31H
         yUmR6VKAE+Mm+ojWJfPt25YBZEVZEj9LrlxeK5+UpNnqlGZ4fhBMnmWQv3aevnsSKaxT
         2xpR9zHDq9VVkKolAz4ejnr8KZ0RuNlUAA7ziDoiySuPzC106FvvZLG5SMyqDISb07g3
         Y98v/0xkJZJOMJv1VjwuTs4DuqHDVo4eIDdG4V4M/+OuI6IEZZ/CvLYMDoJK1bZeUCZw
         lLw8Oy+682PcTY3YAlrvw51zbmQXWv7f0nLQEiI6U00fS7dwdooScnxLEtZmB7UdO7Yr
         cNtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792900301; x=1793505101; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0ktEcxrd0rxQ82zCOkrAw+tUGIyRtq9WOivmEZ+MVZQ=;
        b=mfSBNeKDEi67tkZgjWJ+K71ufyRgPFWDk83k22MBqyVhmftWXHwtM7cq0E7ED7p1p0
         9e4vX+5z0zMzgybad9IiMtHIg+uYujYHUcImSMb6XJaEM/RjDVx+c73f03F7oIkMJ4Nd
         BoWd9xWQeWMMLB32ZzAiA6Rc+pkbBYW7T2g/FI4J175NQrzRLRL8v6mTXwgIRuPRqnmD
         QkxOTmJVxVSjViC8bL0sVB5wNv4ePKA5ByoaIsDP7P5xfex8Rq9j7v8Apo3l6nsQduYc
         y+G3c3x/9Yi+ZHILaDCqczBDBFByeZAUeY+oC2Duu87T8jPYTncoK9vImuhBvMVz7Bt/
         Zn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792900301; x=1793505101;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ktEcxrd0rxQ82zCOkrAw+tUGIyRtq9WOivmEZ+MVZQ=;
        b=sNj69Nsxw4qrEfvFCXx9ZZ5dXnK+jqVHR3gWpqLjWIM3F/aQkA7naUOU8FpIbvbAmK
         Iqn1JC/FCeUVsWNcCh2l3OBDTw+a5jve85XN+thaV7Xj4wIWYZEgS+oxd13WHh7eeIZm
         No/xdjt3Zs82PLmKqRk9FYaMttHQl1GNjkwsPBZPG8D1g1n+Z0iLP7oVla2cTCNJiz29
         Ply/De2KRFwMNma8FuRKsYaj81AtlAcqKyfbvkJibJHGx8TvbafFEdCPhjHCg6XLJnpS
         ERxGDVd7htFcjTSXTzGBZo37R2Gm5Ujupy11JPp7nN4/DbNq5AqiKjB5yr8l6zJbVEUf
         PqDw==
X-Forwarded-Encrypted: i=1; AKwUvBwjNieg+LkjBjEKo2EhRSQI5ci9684JdzVZ0bFL+v6qfYwkdAic4HQbTiyIgr3kxPa3HS4v2tDRQw==@kvack.org
X-Gm-Message-State: AFq9FYKZWfChqegRkX0Te47TXAiFNrpBsMuPa/WvHQFHwAKJkKtoRmK0
	2fJu5H9GFC2jUZB0ntSqQ8rI/RMErclwbD5kRYKZ5R/xSdl1TIZNQrotx9kF0ZppS/ROqro4n3d
	H6lmefIHX2hf3hddKXIji/kjyI7cAkDgiXpki
X-Gm-Gg: AYBFou1REgM1byDEV0WIaK/FCJ5wexBz9Zj1+z4SIymwkOnoeyU28GM2li3eagRtt/R
	ThMoDQgAkD7yh6xkENKfauAd1nExGhazkZ4oc5O1XJUDLQL/yUOaLpL1lDHHC58quH6K5dwFic/
	kacKfkRvimFJuDBZh8TYHmGpT21rJhQMeAPmTMLzzvAWb7OuFDqqAmch9OKGewT45HNiRXmOx9l
	eOnSndXI0r+lC02kHOml9GacD1hFls5ezxFcf7DiODzugeG3QN0a9EP5Cp/SkNZ4amARjLLo2D6
	RIyBVB9Rl/4NbxRgZ5QcEZlIH4ZVvVAf6O0vIQubyT2N+RCpNntkdHgsCSOd6WNGzWBN9WLsu7V
	RkLCwdJV5JMjwDHIVTptdEnlLZeJpRCAKpEkARn3E54R193vbhjUVhqZti9W7oxBdo/0=
X-Received: by 2002:a05:690e:264e:b0:679:a89d:d23d with SMTP id
 956f58d0204a3-67a454899ccmr1742173d50.11.1792900301105; Sat, 24 Oct 2026
 20:51:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023023226.29783-1-laoar.shao@gmail.com> <atrUeGPZgoSACpOR@casper.infradead.org>
 <DMCA1N4UNM7G.3JBXJHJE6CQ7V@nvidia.com>
In-Reply-To: <DMCA1N4UNM7G.3JBXJHJE6CQ7V@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 25 Oct 2026 11:51:04 +0800
X-Gm-Features: AclHuK_Mj9pJTZ_IDWc_6GHl5eLkbPgK87Fy1jS2ZkYy_F6es3UdO-AeiTgnHnA
Message-ID: <CALOAHbBGBjPdC7gbs4DMy5guNKjtVY4vNM7=trLKC_4M3XAbaQ@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: snapshot the source nid before the misplaced migration
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, david@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0766F80003
X-Stat-Signature: utce9xxp9qgtacs86kyxc4bpfrhdz7cg
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792900301-782754
X-HE-Meta: U2FsdGVkX18SyULJRLTUOt+nwvRV/SYPuOkdPiiLiUopW/+OYCxUzyCuYAAtV8hsSmSzf0FVJJ/W5eFyYr43fE+zvidbDPgp9gWN2EP7Y1DMYwej7Yqe8y4Iq/Sd131XQXTkwym2lCvp31nffUyubBy1hvIxkEMQYUO47MfWOnqPXWe5+apxMGJHPWowTBykGJA6N00KoOyYVIvwvBCyZ6A3R4H/qUMlI+6MaBP94OObFJaWNKN4OrOzbGYfbJtCnb3mG0WgwE5MRYcoWmWE3mboRLi/XbHP3miRFnmhw88fq5DiaZv5EsjcCRR509X501TxQGwuJk8JGMm90QSy5lPq7FTCu/iUgdOvP7kXyPzNAMYGggMKlWYmQpBBNMOH4UwBGPQ1TlECWQMHLIDS+VJN7JjBjkjUw+TwgKiu4sHpfTwtR/ZkRntIykUt7vdCe6CQPoVQWI7w8/1O4+PLftoWocUvLau9Yymn7QYMcITKPndZv2j1CUTtQHPF4zP6WZfQ91fiRqnNjEXwONQn9UbPhwVLy75Cog1zKC1hdVivCK/z0t8HYsSW6VMUjKevP1rscpE55hgCcKRSWmvC3ZJb9J3dIIjju2NqykNOyc0lNz3OTysaBmgZihVHi3xw/6G8fwrkbV77kF+l3ZOUotYt1GpZaquG1p4PoABf1bL+mcIUvKG0owHGfIfhj6WqXnsIDZDBrML30Ztk/7otGq1Zlv5A9ooiGemVeEeURtHQpaejHQ6T2PkQSLxuRsXJ7nA2bYvHHA9yw3EZmTkT60qHr8XKmgfElqBTUz+/RLNyumjyl7Iods2HQVj7AKoCVH5Dyye2gZp72l4/vyOwsK3T/hf7qC5hxSp4RIqCB+ys0Lr4ktBStTyhuVEZAS69cZk/bGZLMnF1ZdllntxbUnoE8dQmXYvXgc5n4TgUeh1ahNrLW/l+4fVlVkC+DY3usYDS3kGH41RLRSNMWwQ
 vP+SO85H
 m0ljNehehASE+hYarYucSWbIG37QakY74kQcXUQ2ikAq1qiszON1VvXUJd06LKRINkIJUnJC+fInC/4m+URIpyrMds7JKN/ap4u06YeX7gp0H/5qsxzRWEl01dfSKuVUpTV8xgKbdPErhJ+7ArCnx4aBzLplB9mzKrs7flHboLD+V+zzebVmdeOqpPW86fTyQxhpsoBhaG9zr71urgpclpqBqmwy/TKfPfJlJy2GEpRlZyQCeGAA1VwOcgz/+YcFk5kbYT6ttpBSbkWsJtM2fw6Qiz5ToOHcGDr6DZ5MUga8yUtyF2FrKZwW3vfQ685f15V7390rx9ww2QEGiiJf3eG8MsURrJ8o8LOnQywgn3MKomX2NECGznqImlRYyBoWMnL0tWReddOvDLSHtxwI8P9gE1g1d/XDa4GFRVsIvaQWVP99DP0WJJRgDJ33i6JlqfKqJGUhetA/WzwYOwmE/W03Tot8AL72EcIZQmUYdzt7E8hAYxo8pELuEQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:11=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Oct 22, 2026 at 11:28 PM EDT, Matthew Wilcox wrote:
> > On Fri, Oct 23, 2026 at 10:32:26AM +0800, Yafang Shao wrote:
> >> A successful migration frees the source folio, so the folio_nid() read
> >> in the promotion counter update can pick up a reallocated page's nid.
> >> Snapshot the nid before the migration, next to the memcg snapshot the
> >> function already takes.
> >
> > I don't understand how a node ID can change even after the folio has
> > been freed.  I don't think this patch is wrong, but I don't think
>
> I agree with you in the current code base.
>
> > there's actually a bug here that's being fixed.
>
> Strictly speaking, it can be seen as a benign UAF. It works, because
>
> 1. folio->flags happens to be the same as page->flags,
> 2. folio/page nid is stored in the ->flags and never changed.
>
> In memdesc world, after a folio is freed, I assume folio->flags would be
> zeroed since struct folio is freed and calling folio_nid() on a freed
> folio would give a bogus result (yeah, it can be mitigated by not
> zeroing node field and each node has its own struct folio pool, but that
> makes folio_nid() implementation dependent).
>
> IMHO, this patch is still worth getting in.

Thanks for the careful review. I will refine the commit message
and send a new version.

--=20
Regards
Yafang

