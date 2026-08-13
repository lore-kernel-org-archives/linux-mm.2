Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3639DC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A366B04D2; Thu, 13 Aug 2026 08:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260546B04D3; Thu, 13 Aug 2026 08:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176246B04D4; Thu, 13 Aug 2026 08:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2C406B04D2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:18:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3851C40135
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:10 +0000 (UTC)
X-FDA: 85096148340.25.4AD7402
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5B664000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6nPRXqt;
	spf=pass (imf04.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qUHFWUDQz/MEraJh+J1O/f5gfgcsCAk1KSe7ywJpi8=;
	b=DVan3oZad9grX3OtXYKJm3Fyd9NE4O3ag1SSN6V9XdSgyuP9yKQ5HNGZI8Y7RX67JMm421
	fCdz0UeKgw69SzXrNLmLDwbwcAVoCCr8TouBKpNGSfN5MKgkbbqifq+uZFPqPJxt2xcdsy
	/blpmED1qM/qGG/OmzpOXuCEVJfcjbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623488;
	b=E5qeuj7J6hRgOO6km1CNMqurvMvT4TTpmmhSV7jSc5830qKPB3gR/04jUQp8OOhphktNtH
	DWThM9z+HItm5IlzOsW3QM0Y6KOWX7A5cCW2vKJPtGOYXXRcF3ZgPg22vGHuaLp9zC3kPa
	vrSM+ZFQ3XnKB3TVMeNIc9HUkd3P7W8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6nPRXqt;
	spf=pass (imf04.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786623487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qUHFWUDQz/MEraJh+J1O/f5gfgcsCAk1KSe7ywJpi8=;
	b=C6nPRXqthNeIX6G2wjfQVKswwhhI+s3HFbmoUUEi5fUciZAusKIbXPwL409YzyMxyE6PgA
	h/PyWiyPFUNgB37HSaIuMbNgHbwgn7akr/RIG4wrfNNUHtxDOve+MXXcGhG1FsuKv8Wbtz
	JjDirlwNhpSUhX6Q21j9pECSGt6TWN0=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-leEwgD7jM9G6lZVDa-CUgw-1; Thu, 13 Aug 2026 08:18:06 -0400
X-MC-Unique: leEwgD7jM9G6lZVDa-CUgw-1
X-Mimecast-MFC-AGG-ID: leEwgD7jM9G6lZVDa-CUgw_1786623485
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-75116a48926so1448501137.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786623485; x=1787228285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5qUHFWUDQz/MEraJh+J1O/f5gfgcsCAk1KSe7ywJpi8=;
        b=bYfbg7+joz3TiGfuL3ObYTy8CcvxkO6i2BmrgXrFdrsntKpK+/vLbu2NQWH7DgZT1c
         l57mePEMtI25OrWGtuSU6H3XmwJ0VckAT6oGDwLchhhw7MxfWlcLuxZZzqL4+OXmTgv/
         sSbhJ3fYcXM8/AM3nZoUNX6FlYHYJesyOQ+rGNr5PROXVy8bbqWBSrbWMjMatmDs1oq9
         rci0yzm12PcxGCDXRR44WK05W5Tg47un8KJ1KkH31baR4N6h5CtBC/BU3L7fyZfST/Tw
         WLvHKjlZWEshmx92c7fn5dRyJEkJnYeW/jbaGXdQCLLgOiFaQL+sqMNWgiNmRObNrxgQ
         K+0g==
X-Forwarded-Encrypted: i=1; AHgh+RpnCnU2dqMdW57lAdIBhkxNlRvy7XPiCC4dwjx5T7siNM9R4866x3U6vJBVNrD5aoztX3XmPI6ZhA==@kvack.org
X-Gm-Message-State: AOJu0YxPOwD70iVmHtHdhYF17M9SUfzDqocqtgXOCgNl+cjcQjLlxEbQ
	7pxM6GFBmz2CCTfD6jlTNofLq4YSS0QdOx/yQrzW/M6C/dZmu2J2YA7adzO9t8uT83XUnv4g+IG
	bDsLHbTVUtk1SMhpTSpYEquILwDAaxfhJyaLEUPqck9mpRwFKTdJb7fkYt9ZpWLpZ5ALlCOnLEL
	rmt4CCwRUQvuuZEQEwaeuBoZBXPRA=
X-Gm-Gg: AR+sD11dRcoPzRC1fvNOF+4Bwe63Ez3vxdBJ8g8DP2kFR7rEB6x9R3r+uWHHjruMxja
	j9or4SlBg62pJTu6YRD6puEu02LSLsywe9C5x/bBR5veK+LDmRi3fXzI84QrRSI1RsmjYXB3usL
	XPYW1JApeJAUaelCfWc9GDOZUPtebgziOrI1ViL6kYLluHRzoyQHXke7E=
X-Received: by 2002:a05:6102:8008:b0:76a:fc18:29c8 with SMTP id ada2fe7eead31-76db668464amr1600885137.8.1786623485457;
        Thu, 13 Aug 2026 05:18:05 -0700 (PDT)
X-Received: by 2002:a05:6102:8008:b0:76a:fc18:29c8 with SMTP id
 ada2fe7eead31-76db668464amr1600872137.8.1786623485092; Thu, 13 Aug 2026
 05:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260810-remove-wait-on-page-writeback-v3-1-dd7531704f26@columbia.edu>
 <20260813112028.3989422-1-amarkuze@redhat.com> <709df647-3af1-4d9d-a99b-c36c9ee69ac0@columbia.edu>
In-Reply-To: <709df647-3af1-4d9d-a99b-c36c9ee69ac0@columbia.edu>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 13 Aug 2026 15:17:53 +0300
X-Gm-Features: AUfX_myXKkVLHvulRQVmMzyUu_qv7exV-qvoatfjLDFlQ5VLwI46XH_QXFBtWxY
Message-ID: <CAO8a2SiJsmNxdj3E_3EhjSYvacn_XCh=RCwhNF29GF79=L5Pfw@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ceph: convert writeback path to folios
To: Tal Zussman <tz2294@columbia.edu>
Cc: idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qJTKEsz69nyvjNB8yy7rgZML1PXXHSg_-stRLlvyexI_1786623485
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7cz7reso1xn4twfxmqyabuk1yn8pksy3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5B664000D
X-HE-Tag: 1786623487-390878
X-HE-Meta: U2FsdGVkX1+Ob2birr4DkpQWYTfMjw4a/+9rKmPrx8xIZTmuyVdR+JL0C4j6zbsqLj0B4YfcSUEkM1o50+LrTnufyRn3IGTGv/1lESY0eJZc9yPQhzNsif9+NV1UkU31kF6rKo/CShVmJSfImmA9SNO/dP/INbjjMt2c7hb1CQ/Tku1fmmmJRLlhy1fLVRiEAnIYiRX4oKAxZzrKj75F8W2kaHBBo/TehWbrdLPVr9gaYXoia5v5/PFOz2YG5FrM+sYl0qRiq0wXA8hwEV52v0wzbqlrtAkfnTyRfxF5KQ2kgFh3pjQ5Ehv2/USf/ci2HSFxXZ+Jw6lTCVyMXoiT4z9M0qoy/xFY+TweXbZld1cnXXgZyHuv2NqE/M6IH4sMohw2g2wrCaGHNli7wJz8cn+XOp/LA90JrhquuGdBEtauBo/nDg9Ie3jUy43vwQRPJ20eOpye6YR+Fztlv66FrOh89BD4m8U1ezYE/HSX64IJLDla4A9kJejIF5fjVfm0G5jchRumCcz3K0iQjhIX9D/PNfTnh/filztYxxQBWC+po9i53vp7AtpYsuBRdbBgy+e7WYvE0kb9YkQJ/nnegdf1qlfIi+uxp696akOVunp3bs2DTqT6ghiLrwBw4S0N0gS7hExseZuNkXry+l+VNre+ffMhYMXuKn+kKccJJhhseKyypvo+FyL5d+y3Q0IFkKaGE7KT2Mk5tkkr+FcE1UjU6fCW5w/LxQR0F9sN3X0WymRbdlWqRc9uGDPmQBJHYk8uRzvbqi6zhU/v/s+7O5ft7XARQJCok5VazL5AXbBEF7OjdBqeuC4JvygQ89wi0Du1+PFz17+YFSJrMJgt2uu8Ae7ItBhpDK10P5TWzOeoMupOOG1DuHjtGAnLJMx1izknPAmJSPhk52THinPp7TUuI8VKVmFJlPfhuuCYqBUPDw4iI2wuPFuyWNj4Rd6doqp3bvJMrS0Czc+ZS48
 3vhZ40FT
 7Qw7e9GrbhPP0BX09xChn3NjwkQfIfRfHP2Y9gy+31Tlu1C2lC7dzWV8Y9mE7r6uIMrJjIQ1LEutBn802qW5Y6OdWH3ZXQwem5aI8zOF7YFOEI2jleXjL9Vx5s/DSsYGYhfVX35NRdeyZdK7UQiH3ryehhzx8fFHRDNObFgfJr+bg6x4qfkRERyoAOTv57M8Nh7hd5IDTFYbtZ0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yes, its best to separate any mm/ work from ceph when submitting a
ceph centric patchset.
These fall under different maintainers' purview. The one exception is
when a core API changes, requiring a tree-wide change that also
updates the users. So any mm/ changes shouldnt be a subset incide a
ceph centric patchset.

On Thu, Aug 13, 2026 at 2:51=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> [adding the mm maintainers back to CC]
>
> On 8/13/26 7:20 AM, Alex Markuze wrote:
> > Hi Tal,
> >
> > Patches 5 and 8 remove wait_on_page_writeback(), thp_size() and
> > thp_order() from mm/, but those helpers are still used by f2fs,
> > mm/filemap.c, and mm/folio-compat.c =E2=80=94 removing them would break=
 those
> > users.
> >
> > Could you split this into two series? The ceph-only conversion (patches
> > 1-4, 6-7, 9-12) can go through the ceph tree once we drop those two
> > patches. The mm/ helper removal is a separate effort that needs to
> > coordinate with f2fs and the mm maintainers after all other users are
> > converted.
> >
>
> If this is the preferred approach, I'm happy to split it up this way, but
> to clarify:
>
>  - This series removes the definitions and exports in mm/folio-compat.c
>  - The mm/filemap.c use of thp_order is a local variable, not a call to t=
he
>    function
>  - And I don't see any f2fs users of any of these... it looks like f2fs
>    defines a folio-based wrapper with a similar name to
>    wait_on_page_writeback(), but doesn't actually use it directly.
>
> Given that all users should be removed and the relevant mm maintainers ha=
ve
> provided Acks for the two mm patches, I think this could all go in togeth=
er
> safely and avoid delaying this an extra cycle.
>
> Let me know what you prefer.
>
> Thanks!
>
> Tal
>


