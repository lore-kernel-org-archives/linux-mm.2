Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C68CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A068E0008; Wed, 17 Sep 2025 03:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01A08E0001; Wed, 17 Sep 2025 03:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFE78E0008; Wed, 17 Sep 2025 03:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB84D8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:50:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62F22160460
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:50:01 +0000 (UTC)
X-FDA: 83897968602.16.91EEC32
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F7AC80009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:49:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0EtM1jZ8;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758095399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NQRoRgD8S2ikkOEtTruAMEMt6AIscFE/yU3xumvdBE=;
	b=OorFyuP31kOGI33baPMGjI0/W3AMKPWyGb+LHRdrB0avy4JmOEKb0qZa0GdOX7Fx5Ip1Gx
	tVLVmufhiW6j5x1oUM71Y4jan4jAVJCdoLhc+PxlWP1n0k5w538yWcKUxPzp3z7QYDsz/a
	BkoY9Iz5cz78IRfyoNNjdMnw9iqBwc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758095399; a=rsa-sha256;
	cv=none;
	b=Dz+yKWu7IUN7VwmQZ4pFS/dQXn3jDhM09Ph5z7pQTQD3kQLqssKbxdMnYYQkbGtXHxK4J1
	fU0brUvqiHTp9u4/vZZ5TAmvb8dzyUwO/lQfdP0WH02CbWDzaqp+nIpQINSqVSOsQehaMz
	uuPxprySopPbydkseDdfDl7CoAi6zv0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0EtM1jZ8;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-632adbd6050so1335662d50.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758095398; x=1758700198; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6NQRoRgD8S2ikkOEtTruAMEMt6AIscFE/yU3xumvdBE=;
        b=0EtM1jZ8qd+3pBldwMiZapu7U6rxil2g2PC2CY6A5l0JnN/Clp7bxhvIhDUi4iWkiy
         xi/n4A7Dk6Nh8BlpX+RZORk7L4nCg2B63akKDNoodd3zlhYdn1ERCRj2ZCdHiBL7kfXf
         JCkKWjZZ0EciGrGaqrcs0tqCy7BJisb+tOkkV6v1Kr2DHtXb33L+Vx34yvYu4D+mnh9h
         SzSklVF6S4zRYjWXG6qvI5o8rfP5Z0bsZOaZwFxy38+D/IXySjuVeuZnIEDemjXLpBjy
         8/wHdkiHc5X8aixIswnx0uPFKMvMMJztZVA0rU7vTkpoKvlanMVCAd9at6L9q6ZJAupc
         ahJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758095398; x=1758700198;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6NQRoRgD8S2ikkOEtTruAMEMt6AIscFE/yU3xumvdBE=;
        b=eNk7ZYhVAz5eXhrRBzhOCvnqt7hk5z5nHXAdYuWBJO0IAcL1RSxM3Jaj30vqqcZL8G
         M7sNL3UV+OYvMo2XUgJ7UFxrRXyNbI3sy863VOfToD8uWFtwyWvu6ryAJNa+M2r19xt3
         Id021zwtqvgZ9oCMZqrbEkxeniQtp4fQC3TKdSFGjWUbM0KLuv1+l/MyyloskVY75gel
         IGIXSfs+hQyZD0u76o2xDD+to1wEmcBaZ4G8rxeusz5bDLjDoqZQ+323X0gbGPWTWcdP
         a5z8LnMT8Gidj0nJGGYRrL3/sQZlXIJGrCDiprMf3zeuxhxVxNFPgCJ91ijrFfizwua6
         4sew==
X-Forwarded-Encrypted: i=1; AJvYcCX9HAZSdSYFdLqqDp5a7EEguB3jKK/vVsG7ikj0U5CR56+/CMpOYGIJZecEWfoofIJ60KzM5SN2eA==@kvack.org
X-Gm-Message-State: AOJu0Yzlytr8Vjbj60dnKcLew1yg5Clv+cFdWN2HToqBIo59MrQtGBBQ
	/Uq1/qHV06ae87p4EjtSIzFAmU40zKUILyhAirYSZtAXxbuA1w44ctyFq4H0Y8gugg==
X-Gm-Gg: ASbGncvk9CAVcONJiAJk+v+YEYYxq8biw2KPQG8YHlKuzbWhBh7fuPD0qkq2Pbt0vX1
	dfSatzcXKUbxshX46jV2mC9fH/GT+Z6kswGM9f9B3cBn6kEdgO2bf1z2gxeOIgYwVpf4XPu9Sxq
	0wyN4dCEXVaPpYzihulwd2GHczbGQs9+qN4kG2HmrQrI5HhNSob3bIukxhHSH72j0QIQniz41Qq
	iqAyGXUlyShjQ61Mxa0/1jGTb1VzzLue52l11cyq+ClA90J3NEJXA9Jtmxrh/94/Kwaq2kTLziT
	QBStAvzgMueqUKLzPf+E2TeUdvX2km91Tx6UwnjYG/C1GWImmGjf8G53CecCTHgIfU9yTiQnEa6
	/cJOatHT6SXCqIWp0GK0T4OfiXZAYG0/dq3x6syT8PVE23jAnA38HfvD+I2llNpAPkgk9vGsFtX
	nscaBADy+xziTcZw==
X-Google-Smtp-Source: AGHT+IEycN/Pi0TNMq7JJ5LbiFtMN/1DZOlF9cpk9pz+GeMZUQNxhoiqxbeuUkwh8PzyvhsApJdfTQ==
X-Received: by 2002:a05:690e:248d:b0:62c:f19f:794d with SMTP id 956f58d0204a3-633b06e8016mr715569d50.36.1758095398236;
        Wed, 17 Sep 2025 00:49:58 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f791a5d54sm45202767b3.37.2025.09.17.00.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 00:49:57 -0700 (PDT)
Date: Wed, 17 Sep 2025 00:49:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
    akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
    mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
    willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
In-Reply-To: <7eace9f6-e257-498d-ac10-ae86b5713e3a@linux.alibaba.com>
Message-ID: <1111883c-974f-e4da-a38f-bb3d337185ad@google.com>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com> <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com> <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv> <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
 <9b01a2cc-7cdb-e008-f5bc-ff9aa313621a@google.com> <6ebb5cd0-0897-4de7-9303-422d0caa18cb@linux.alibaba.com> <7eace9f6-e257-498d-ac10-ae86b5713e3a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1928573329-1758095397=:29290"
X-Rspamd-Queue-Id: 8F7AC80009
X-Stat-Signature: khnthhwawukpk6da7mez7m5z9cgspxfp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758095399-891629
X-HE-Meta: U2FsdGVkX1/Oz3W2EETPNevzf9R369lXeSZX1Bvgg0Lab0s/zoMrYT06BJhhK3n8zWKlLGgDFIofK5tFuXU98Vq/ppnVtv4iWy8hARA1HacHTwboEfesK2DHZzge6NXxRsCcBt2rKB196H/xAOChPipmmINQdh3Ndp7QXuWseZOR17bRsiygcqYi6B2lFBbX3nit6otSLeCeUNlwewNF2/n0XNIeRiqpqwjHpZwsfcqHDiFi8rnNgUj0ReAAJ5QlXQIbaQaPguWvfF3zYK2elXShZdu8toI8Y0GeFrbYtaWzADk5Ye3wqCmj2hduAEXGiiWwsFawM0lb4GgRpSMVTnNHKQpePiQAwbvUTW4hWFlMKrTkOixRgsOo6nE0QEnSZHwr3LwZQ0XmnSmkTwPCahu7Gqmx8bQvwOjZOghQQdh23hr56AeocNRQn/1kZqv1vKdVKssFsufonmdEMIAy6wKTYs6qbE+sYJ/ktSp7H1aoVuL6soW7JBSwgEq0rL1hvFlPXsU3LD7d1F7BUvC0qrbhoQi84m3bhaqfgKobWiTZtvAZofNEXtrMbTNj3+6Rk4fdwzFLGhWmilkZkSzWi8MWcGNmccJ2vQPE6qf39QCKhpUkKUeZxax+JQeunD9svCc/0cYGIQCStMf2Q2AvQ9Rj9GrMddkZd1R2CIlyO82O2SrrGVVlUYMRdK8zb/+EF3A8X9ixvTU227s1penUgyjhyMcc/2iu6xPpOGACgCY8ojRlbWnebRmuOMeWPP0YsdGo2pNAqWyjPSiu4HiZI2Uoq9BTR2+qfruElkWwn5h16qZ/mZqR9q8FcFHZdRwnkSLo1uJlIMTEdVj/MpVx49Tvy+m8th36S+G4+Z9NQe5wT6qfzvZOYDLWjemYSV4XjswlAxvgMEULX7lDHO6YZDhQsTXHStjyCEC4w5B4CnqLh6XM+pNA30D7ZCfuHr14vMyEqybHzjgiPpxIo7Z
 KuO0THm+
 O8vYoV4aBKYkkLfZcqQpusq1VVm27Ra4A90p7F5mummWanjgpe11/vtJRb55LlaIS9H9/wZaXrCL1WIvnlS9CWv8d9E35nGa0rBurvV8tf66uFJUMP1ABA9LtbZETeiOeyc55SVQaGLWu8sDOFOZnkYQs0+sakzpwszbfSDeraSj956J+Tgjoto4hv+1yF8twgC6G9TM99bROHvO5PvyUwI49XmjyLA8606gwdmTuExis0i0KkMWLD75QzDC8LNVo/+Lg3fJdj5EHthZri/lbyomPXWiOw13GclkBgrmeKI5dWGk5LG/qj9A4TZy0uU30KPNCs5MTg3ZoJLC1jUbc7geadRfSOSSd1disZGaZpaQ38I7upHd7Nlv1Aa6HcN10oESpcFj7zSuKCqvbWOBgCoP4zmT7k1HlqYIYP3L39LRy7nXfEnjAhzWXmj6PmrNhxq5F8gvghRD3ZoildAcwK9P0s9dhRTKXT/Et0TciATS3NYwPP8pU9pVFLBARHSTgp7/LrScEPQ+t3vGyMSpVAkVBB0FMctR8fgDcJTZkNgPpuaYs69ylBTykHO947uWsZrb5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1928573329-1758095397=:29290
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 17 Sep 2025, Baolin Wang wrote:
> On 2025/9/16 15:18, Baolin Wang wrote:
=2E..
> >=20
> > Additionally, I'm still struggling to understand this case where a foli=
o is
> > dirty but has a NULL mapping, but I might understand that ext3 journali=
ng
> > might do this from the comments in truncate_cleanup_folio().
> >=20
> > But I still doubt whether this case exists because the refcount check i=
n
> > is_page_cache_freeable() considers the pagecache. This means if this di=
rty
> > folio's mapping is NULL, the following check would return false. If it
> > returns true, it means that even if we release the private data here, t=
he
> > orphaned folio's refcount still doesn't meet the requirements for being
> > reclaimed. Please correct me if I missed anything.
> >=20
> > static inline int is_page_cache_freeable(struct folio *folio)
> > {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * A freeable page cac=
he folio is referenced only by the caller
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * that isolated the f=
olio, the page cache and optional filesystem
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * private data at fol=
io->private.
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return folio_ref_count(foli=
o) - folio_test_private(folio) =3D=3D
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 1 + folio_nr_pages(folio);
> > }
> >=20

Good point, yes, it's surprising that that such a folio could pass
that check and reach the code you're proposing to delete.

(Though a racing scanner of physical memory could raise the refcount
momentarily, causing the folio to look like a page cache freeable.)

>=20
> I continued to dig into the historical commits, where the private check w=
as
> introduced in 2005 by commit ce91b575332b ("orphaned pagecache memleak fi=
x"),
> as the commit message mentioned, it was to address the issue where reiser=
fs
> pagecache may be truncated while still pinned:

Yes, I had been doing the same research, coming to that same 2.6.12 commit,
one of the last to go in before the birth of git.

>=20
> "
> Chris found that with data journaling a reiserfs pagecache may be truncat=
e
> while still pinned.  The truncation removes the page->mapping, but the pa=
ge is
> still listed in the VM queues because it still has buffers.  Then during =
the
> journaling process, a buffer is marked dirty and that sets the PG_dirty
> bitflag as well (in mark_buffer_dirty). After that the page is leaked bec=
ause
> it's both dirty and without a mapping.
>=20
> So we must allow pages without mapping and dirty to reach the PagePrivate
> check.  The page->mapping will be checked again right after the PagePriva=
te
> check.
> "
>=20
> In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
> data=3Djournal") seems to be dealing with a similar issue, where the page
> becomes dirty after truncation, and provides a very useful call stack:
> truncate_complete_page()
>       cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>       do_invalidatepage()
>         ext3_invalidatepage()
>           journal_invalidatepage()
>             journal_unmap_buffer()
>               __dispose_buffer()
>                 __journal_unfile_buffer()
>                   __journal_temp_unlink_buffer()
>                     mark_buffer_dirty(); // PG_dirty set, incr. dirty pag=
es
>=20
> In this fix, we forcefully clear the page's dirty flag during truncation =
(in
> truncate_complete_page()).

But missed that one.

>=20
> However, I am still unsure how the reiserfs case is checked through
> is_page_cache_freeable() (if the pagecache is truncated, then the pagecac=
he
> refcount would be decreased). Fortunately, reiserfs was removed in 2024 b=
y
> commit fb6f20ecb121 ("reiserfs: The last commit").

I did find a single report of the "pageout: orphaned page" message
(where Andrew claims the message as his forgotten temporary debugging):

https://lore.kernel.org/all/20061002170353.GA26816@king.bitgnome.net/

From=202006 on 2.6.18: and indeed it was on reiserfs - maybe reiserfs
had some extra refcounting on these pages, which caused them to pass
the is_page_cache_freeable() check (but would they actually be freeable,
or leaked? TBH I haven't tried to work that out, nor care very much).

Where does this leave us?  I think it says that your deletion of that
block from pageout() is acceptable now, with reiserfs gone to history.

Though somehow I would prefer, like that ext3 fix, that we would just
clear dirty on such a folio (to avoid "Bad page state" later if it is
freeable), not go to pageout(), but proceed to the folio_needs_release()
block like for clean folios.

But whatever: you've persuaded me! I withdraw my objection to your patch.

Thanks,
Hugh
---1463770367-1928573329-1758095397=:29290--

