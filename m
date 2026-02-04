Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC44EA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674C86B0089; Wed,  4 Feb 2026 16:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622D86B0092; Wed,  4 Feb 2026 16:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521656B0093; Wed,  4 Feb 2026 16:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40B526B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:50:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC6A5C183D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:50:01 +0000 (UTC)
X-FDA: 84408117402.11.669F031
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3A7D160007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:49:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c1TYBedo;
	spf=pass (imf08.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvR97cfDbmlAb/2fCQuPdIEdyXhi7/+syfUR6jYsaCY=;
	b=dTPfFfRIF7I7CV/e0pdJ1kUTVGOH4oT1bsCmIKXfFuZkLa9x0YEbUPO2D8UFTQr/GuWP0/
	l+SkmNR/uKNuIrhfPyaZzulufCfpTKnPDqVzqJ2YGtj0XUiz0oUjc5JYLqzeGwS+BmgPpq
	INpJUBScl4DZR15FMK8YqwNRLIb3+DQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c1TYBedo;
	spf=pass (imf08.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770241800; a=rsa-sha256;
	cv=pass;
	b=kN7+C8xUvv3/PcUyZxh7ozUIKtawaGHKphzQwB6sjBh3Zg/JXrE6TNgGvBgGxsCdnPsUqj
	B7OoSDaAbslsMBAAfmTgiBy7ZgqapYn3OAPo4j3b8Ezu9t0H+iHlQwlYJKAG2Q8olzXqsx
	fJVBrZANst1n7vAWZokAq0l6CG5Exuc=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48318d08ec2so3895e9.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 13:49:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770241798; cv=none;
        d=google.com; s=arc-20240605;
        b=OPAn8MpYGwfYbxwuIwetemPZtG18lJiadkVCD6mBHRZ/inl6JzwccFOyEkg6bLXnQ+
         5wRrrnUXm9guQikTiV+4jnbjTk5eVCZzLkP9wts3WAUfbY0RolxrqOS8LLoRDAxvWKGL
         5Xq8bJ2OqsN6S1UIfJZlQ+WOmKyZHsWcopGkSrB1FgS74DcCGoG/6g2dCmCkN0XNV1fE
         siRRO7/Kdq+Bt+nbDzxoEbwFxaQPlofZ5u/2d0rfY9/bvfEVY2O4Vbg22YU5YrCMzEpx
         C5hfFTgXreQMbZBDF9L7+oKoT6Hxql2iuoFTkHjWRqew5FKdXI8isUVZSbMuACnVVcR8
         aXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VvR97cfDbmlAb/2fCQuPdIEdyXhi7/+syfUR6jYsaCY=;
        fh=NRgj/tPH0jEE1z/mQEyoJIMHM10UZqNoqKSynSshiWI=;
        b=ip2sAzqaqOWNAxRst98vUEwD938JySw9xGU/ohWzwV4FrffVLhUvHwMjNCJRstoU+h
         j26DWjq4UM1N7IwPE6gI11VCf6EkYTkX9VZgaP4pDKGo6fbhmKNk9wGLKn5mqAznUsbW
         3YHc/nZ45Ha0oMWHCD1xqm4DtMeRuCd+xvivNCgtEV46zVauVQbSFikGA+O24WdynCGx
         em0N9Sish24IVc5pyVpTgJ0VqIHnizgEoB4/kSHF8AgE7B1c24PV+FIhZ38vKJ7IWyDW
         7Chsvo7D2CnWSy43Ln+jHOvXIZXM7q/0LAExuj81ruIB9+tKfyDem3Wd5BUDUxADpmUm
         yTaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770241798; x=1770846598; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VvR97cfDbmlAb/2fCQuPdIEdyXhi7/+syfUR6jYsaCY=;
        b=c1TYBedoiyvPZh9nyBarddCnFp4TmKqcoriMRTpPzzbe5cRlyp6JIPsuMgrSHq3tGh
         +nezqmn2yex66yeIadOT7tpYbu46SNpxRkHxTNV5wfH/x4uevv/SNdwJcLDbeb1qDPNy
         EX+575BPPtwrAA2S25uLTvatws9K0kOuxkY4itHvEpIdh8HQjICVrGIdd2uLSeNvarZu
         HLdmMk41qH8gdb8mQdYXxnhMXQIk/sUTk9jkVrjISjooKuIeeUhsduBFWufh29/DYrsk
         XoFHprQysxKEpZVqDmahfh3zPMfx704Pq23e4v7huQBJseG2U/2WZxQexjV6AnJ0uIle
         Zxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770241798; x=1770846598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VvR97cfDbmlAb/2fCQuPdIEdyXhi7/+syfUR6jYsaCY=;
        b=n7G2JDgZPgS4Q++gjVlsvU687a1Vs6RFboVtupwZLT+UYiTDSMS6UH9kyC+NR+cC8o
         VftMUcdIXFsYE7jI/C9wBa9VA1D/A7FiY4m/5FSo4/Hs3kaIxkaYMslQYJE5uf+Y10lu
         GvbJsT9NK5xWUgh4enkRy7vEHK8lLPFfyDCe0YjR1xIN/YLaQLY7VBPGjQTET/KAbNs2
         wxM3LIgO4Eus70WjZ28oOznWg2fX8vve15etmu+i4FFZRoQKvZNcPMG5MGd9t9VTrNVJ
         s2Np/BIgFMgwRJn0ykriUm7odeohhjH43wvSoYti0JXn9GahPQoHEKVZOKJsBYQePJd7
         KNLg==
X-Forwarded-Encrypted: i=1; AJvYcCXY66EJZ9HtzY9QdHzw1yl5vYcPtHCHzZbw/zzNnwYQBMKXGb7IhYhIRAY+U2ObJAwe+W8b2NJi+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw2Mj8d/qu1jKk5mrgQU/RKtXLnMtkmK0F1zNOaDpLxIW8iAQwF
	ipvSR9jk63XmP4Uf5T/Rcsqu6v0yEXtTR6W222pJuNYwVzQ2d+42E3ctbninTRYtbIyLTuN+Prs
	trUg13wtZjlj6rS32R1ys93Nu63AfC+IVraXoWrqV
X-Gm-Gg: AZuq6aJXSEkN67oqaMXZ9s75XPNMl+2Q9plGQ1B3TzzcHCNJedf0i4UAmHynHBmIdtN
	gfLkw1CKqT0PafHpi8P3iLol90NVLbtcBgn+PP9zJapxYKeekELCB6cwsF/+sifUKInD4JFlmyI
	eA6+kVbPkipCHTcLLvnCxyI8x0mpDh+FYBEcKCOJ0+9vNBtr5yo/GlJtaqCH5bAdJU0h4NDOZdn
	4CwppNapQ0srtIRVY/I9EZ5pxpwQizlBHtSYI1sCMWwh1cYawjxWrq0P+CFQGApEpTUBDTt3gFs
	5LDpwp1CPG6/ryOODZzxTYU1iQ==
X-Received: by 2002:a05:600c:3513:b0:477:86fd:fb48 with SMTP id
 5b1f17b1804b1-48318bb9c82mr44705e9.9.1770241797958; Wed, 04 Feb 2026 13:49:57
 -0800 (PST)
MIME-Version: 1.0
References: <20260202233617.2350734-1-jiaqiyan@google.com> <f3fa9edc-370c-4087-a201-6419185a0e72@kernel.org>
In-Reply-To: <f3fa9edc-370c-4087-a201-6419185a0e72@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 4 Feb 2026 13:49:46 -0800
X-Gm-Features: AZwV_QjCg2w41azSeonKv_XLVdPmGWVf6wIpcjJ2FfMNtDjIRNS0JOhJmzG1db8
Message-ID: <CACw3F53e8afd4RmMXaQ2RZCP-e=r+2ZmGYJc1qTZXZ+amU+zdQ@mail.gmail.com>
Subject: Re: [PATCH v1] fs: hugetlb: simplify remove_inode_hugepages() return type
To: "David Hildenbrand (arm)" <david@kernel.org>, jane.chu@oracle.com, muchun.song@linux.dev
Cc: osalvador@suse.de, william.roche@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oozyfwg7caeynrk68cz8z8qw59kahoaw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E3A7D160007
X-HE-Tag: 1770241799-847410
X-HE-Meta: U2FsdGVkX1/T2D8rfmgZ/I1T1fE9BO3jnhENnuxXeES9ofIsnB5KC3E/bBmfOrU1q+bpcUlvDVnFHQ/oDhQdu2BWIYFSZRutoaYO9VpF3gvmAqc02Ep1J+Abaq+KxgRsvRh6h6KbdtQsjyiibnbEccV13P0tF3euHvxzyXxqURt7jkqRLkqzTTYnHSZY+Sk7e2Sa5XhNSWkVQNa4Im2f6DcfmPL0fEQebTXSbNifRlYmyGcCjQM2LpnFS617NN3CFCHAE/e7NZUZtoDAW6ApHsgRHBT5KxK5YBPm1tjpgwBIeLBv0rH58oUT/A8enj7foI6aZKBc59fJBMFS27v4ZOIbUxp4Ik8EAwGfGRC3fuTMonxK8kWQVZNMzWr9X3614lEQyFo83/3roN0dyK+WihMsNUi/2TqYnIPIu3fmuRYTlcooRQCz+jGLKTJZEMV65SCNYMziQ/IsSjHHXMi3kW1leuQIyGOsn3JulDtRYDrGYWDGMJ9H5G/IRsieBCgH+M8uxuRtOr7uczc9h3PGCZ7ZamVFkKRRRBf/VLWt8ftupfgo2xTU8u+e0p1ymPCEtl6VdF5ENb25SwmVBM2ihfax82T0sKUT63/CR3ZFDiaF/Je+XW9wCDvomn/QrH0EstigzmfNOln/Uo/D1yF93rloWHyUmH7O83K+czOeQD3KqfSsbXrxvdNcUmOmbtZop1VuAyCkc2psg/LByZiiXOQ3rDeYdxwfNhvcLxC5PSdeDM8CafiUZ2ZGsmEOLwO8u08dkC67hyTzbm1+1kgLAv0KUw5AqnqeimCW+K+vIkO0DhbzM5YNu/jhZZhiDglg88YSD6l0yJl5A0mi7QPIk6K5KEuCmVkDsltyxzdMmqUVqoH7BVnAi5GtOyvK8FpTGs78wwg232o2ZBM0q2IDA57J+FjfeNsy8YfMK0I8VlNrEbx/dsqE9dS0GstewFtbdFoME+NvwHAI7f57fQd
 sjJAs023
 44Uoi2ogG9JJQ8S5hjiUGLL3rbCZP/ioH8ZI+gWjZUipeX7TrFPmE+2iQHM5LLjUNT565lghSTBGspvrX29Q+xgCQGOim8/tp4MdduwEI9T0+le5uAA111H/97WvsLoNhGABKnCJJMCZrgbSbLk/mbLTxfhJBJG5FeKMCSlIpDVEuB54R5BtTSpKAklNociDXeZmbqWVb0dhcKYSXzj+TzqnBeEmnAI4GIYCL7ZF+u5b1gQ6E8J0EkrSzGzCgjjZIYQ4LsL4OhvtjRB9hFqI+jCzLEC8ZX00HCIJE4UWCFEVQKkOdu/QqoixJskTLAZZgl8bvZxuHWij0OFK2kDGTjH2M8qdw8OvCY05/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your reviews, Jane, Muchun, and David

On Wed, Feb 4, 2026 at 3:41=E2=80=AFAM David Hildenbrand (arm) <david@kerne=
l.org> wrote:
>
> On 2/3/26 00:36, Jiaqi Yan wrote:
> > When remove_inode_hugepages is introduced in
> > commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remo=
ve single file folio")
> > it used to return a boolean to indicate if it bailed out due to race wi=
th
> > page faults. However, since the race is already solved by [1],
> > remove_inode_hugepages() doesn't have any path to return false anymore.
> >
> > Simplify remove_inode_hugepages() return type to void, remove the
> > unnecessary ret variable, and adjust the call site in
> > remove_inode_hugepages(). No functional change in this commit.
> >
> > [1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@or=
acle.com
> >
> > Suggested-by: Jane Chu <jane.chu@oracle.com>
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >   fs/hugetlbfs/inode.c | 18 +++++++-----------
> >   1 file changed, 7 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index 3b4c152c5c73a..83d71cea7e384 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -515,13 +515,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root=
, pgoff_t start, pgoff_t end,
> >    * Called with hugetlb fault mutex held.
> >    * Returns true if page was actually removed, false otherwise.
> >    */
> > -static bool remove_inode_single_folio(struct hstate *h, struct inode *=
inode,
> > -                                     struct address_space *mapping,
> > -                                     struct folio *folio, pgoff_t inde=
x,
> > -                                     bool truncate_op)
> > +static void remove_inode_single_folio(struct hstate *h, struct inode *=
inode,
> > +                                   struct address_space *mapping,
> > +                                   struct folio *folio, pgoff_t index,
> > +                                   bool truncate_op)
>
> While you are touching this, this would look better with two-tab
> alignment on second parameter line.

For sure, it is adjusted in v2:
https://lore.kernel.org/linux-mm/20260204214741.3161520-1-jiaqiyan@google.c=
om

>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

