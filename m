Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D94CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203796B0005; Fri,  1 May 2026 10:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA7F6B008A; Fri,  1 May 2026 10:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0F26B008C; Fri,  1 May 2026 10:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39D16B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:17:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B7B7123589
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:42:34 +0000 (UTC)
X-FDA: 84718965828.09.3CCBDA2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58EF01C000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:42:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XnSbi2bc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777642952; a=rsa-sha256;
	cv=pass;
	b=YLqP80MV4MQhvY5P6l1DtcXNPqxbuP1DgcnsP6AuOlqEf+mWSMoVsOGWBsK68ehQLW/qjZ
	HJ2TpIEu2uVyhMzZLcqtwz1mh8WMf/uvVucJwnKjmA8Kji8GMXCY1RJg78fo98WSO39oug
	PAdHkqp0hpDvUBDirR+8YQSJlkj1GNU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XnSbi2bc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777642952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSwDs4IODrQC7D3GuTnZravigu9zrkmXFt0co3vc4fo=;
	b=nBfx1Lzg8toFnd1GlbpwjaAhOtyUfOYVcU+pKYuHjsGdXrWtQGtI2Na4fw+Et2r1M6jLXJ
	bXVcEDoYApKYwPcLxlhbwSJy1ZVj4ajKjAOnFdI7S+0EDcmHN+WQ6lOPUaXSkCcNLdGwFA
	L++ilggaX+bpYkZM8Svfw9Y1jNvlmY8=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48374014a77so22548725e9.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 06:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777642950; cv=none;
        d=google.com; s=arc-20240605;
        b=j6+3xIDVqKJ62+F4mGAlPJ1DJX1k8V0ZP7cQb7+mcOf683/1JmG5oBJmm51xDgkLU4
         O+HjVFuWncebHRQ8SUIhNQ197cIjuO4nyN1TSIT7Dc1f4hLU6cene8nD2oQ7MWBa5vSY
         xXA0xBIJMQpydTpTk73q9V8R6IkVNR4emWjvE23/413CzKGnABcJ/LKlRcmc8QkNggkx
         9pzf9hVUS1rokD/I+wrE5iNxd2DnYMXmAigFJt8mFHmbImnlWzyOWS7sqp97bkgtcmxx
         Wso2cXhkdBlGFeu8zum2LllgzPiOn+bOs8Mux6HoFWA8uBeH4jJiHVdYsTKf+hyzzqjX
         hccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PSwDs4IODrQC7D3GuTnZravigu9zrkmXFt0co3vc4fo=;
        fh=m2lOl2srddfk9gklX/0hhGicL2+ox1uTXI9H9dn/QS0=;
        b=JbxiOrgZgEsNWs6tPcsq7Z2BX4c7qQrWOnJLQEq+9miOUVre8b7MV3lZENPRheAdM7
         55KNme5nbznQDbhFkErfp2HdUm1yRwz1TMTfx7/rLdXmKt1nxFXS2T/iSlpm4U80sTWw
         rCg37c1lDBPor8i4iMKwJoDLXjZLDYa7z9Iu5mjl4oI+qy4gJqUYiDPFuk+aWkY8Sg+H
         5l1sH5BrsJS37vsmpYkrQ4OpR56QjNnQrWtMdMnX/1kS9msDW45EgUp+H5eLxWYFcVvK
         J3fdw6WGmZZ3uoXh69L6NaLzlIlfGhSlUcgYUyxvBC6sdJiXH8oMjoyHuFS6FEf4l+v3
         hm3g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777642950; x=1778247750; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSwDs4IODrQC7D3GuTnZravigu9zrkmXFt0co3vc4fo=;
        b=XnSbi2bcp0S+6oXxFuSX2Q8X//bCW97rdSe64d+EnokozKJ+B76mVabmXyOKMA7myx
         7Cxn6BIfsX8eyD9CZsC4LaVdfFqYuyZTRk2TxO/VtE+Tiqm5E71j91LZYnW63AnsF4cy
         GYYuYZVxZzK63CGFYEMUEECfZorBlWoddulu39/g3m4IBaFZn03BuW6lvpV1b1dAgl8d
         7Kj3li46CIGE6En4XJ5oXtsn007JMPPbJifl6jwOCn074xnlfxXm7sxI1lPpMbxIqrHg
         6ZcK+AQpUb2jtK7NIBI2T3V8VYKJ5O7QJMWv1dJnY8vRlbx1SGK92LdriUL8DF74jw71
         ERQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777642950; x=1778247750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PSwDs4IODrQC7D3GuTnZravigu9zrkmXFt0co3vc4fo=;
        b=bZbsutBHlOTu++tJXyNrOPHpb9l/7CKcUFCe9FXXWjP7i6KMpgSyxHCpept74GR3w7
         Jfc2I2soYciDVeXTfFZ6DlK6NCv7N1v2Gv33f2DFdy8cFpDXaD0SxZAJJkKLRMTxLhp0
         OZUW8V/Yy5yjhbiftqLQ7iD/x0mjHgQWKNPJ3rkO71OrMqX9COcXW/JgM1bf5g9zFT1P
         Tcf8O1hIH7lbxZcVJs/tkOZRdcOhE///If4ohRFqrBW/gk+sCpTlxa75DOCc2H6tkYp/
         vMhS4ecKiggdBqIawcLZP95IImlAehSQOiozAwoQJ1lq5RhYBRYAnYP1Vcfv+TRZlYrY
         tchg==
X-Forwarded-Encrypted: i=1; AFNElJ/mAjbrLj/QfgsAj+W/8DyHWpiVdKsqKC6dZUQbA+w9QOF2NOaaNx7eY7j0rx8RGrRycjq0EQdCRQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1Gs3e16fYqTq59IIMOmKpTkxX5AqcTcLC8fe99d8HxY3cST7X
	cK25GF+oawqPMVH5Hqu7n4h+HOtu/G1g7LRbL+DwS1xam5y+YopSHvBpOy022Yddo4jInmnFJdy
	Nv5vDXHM5d3VxsrBCzImW8FnpM1eD3jo=
X-Gm-Gg: AeBDieud4S7B8KcNp9Ur+frab7UvVNOaCHtIMIpc41EJmHesBSU3vJMcAiHpnGddQNP
	/WrbPqjrXV5xXu1mblxKfI1PY9CX8jspkjqwgX5tBQsVuIGUYJsQk8gdb7d7ORxrWqPtfo6YQTj
	Ki8eNLV3orOmostjmAD6C7iUpXMt/fDO1Q9QlVvqVXQQraVx1+gmDCWxDwCxQMzJkUuKcFlV6iV
	m7wLFX8twb7dCvbKED/WlYL5Y9Dt/KqdWVpMvJa2AQN0/GB+NoD/ZiBvA2tJ7TWIwJhtHE6sE7m
	7VSyZ1dTRIBNJbgdyVbM/SPxzC8gh56EWcYBHzBeTQ972OLl5wzakgrJcosQhspK5A==
X-Received: by 2002:a05:600c:470b:b0:48a:6315:da26 with SMTP id
 5b1f17b1804b1-48a8eba3a20mr47321765e9.26.1777642950197; Fri, 01 May 2026
 06:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
 <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
 <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
 <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com> <CAMgjq7BZpU5K1xHyFiqpsjeFe6CZUouGY_gOGMwbkM2Duq-vGg@mail.gmail.com>
In-Reply-To: <CAMgjq7BZpU5K1xHyFiqpsjeFe6CZUouGY_gOGMwbkM2Duq-vGg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 1 May 2026 14:42:17 +0100
X-Gm-Features: AVHnY4IotFE7AB5jv9yFrevYlVwuS810ESNP8MQdhCBVqE2Ni9WDWtp9VtEH_ac
Message-ID: <CAKEwX=Mg8AWVoiKZixokg4NCOn2-aamtRAaNO4_GGU_h+mbpkQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org, 
	Alistair Popple <apopple@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <bhe@redhat.com>, Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3tb37efh5hgnmxiex7bnzkywhhmzjed7
X-Rspam-User: 
X-Rspamd-Queue-Id: 58EF01C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777642952-777013
X-HE-Meta: U2FsdGVkX19MkrN4WpOIpsgbx+nYc2RM0Hz5cbwHODo4AowU8Xm5tWxe+3qBgyfhnhUn1vwd0ZxO79BXzkBx0C+SDEy0mAjbLQrm5UcJBtuGYG9mjBwpQ5AZBlwNETGLA3rNkCb2RjNFi+BNewM0KL4iQYrkUdxM5L7dLeKAzcRUIl/LVJJBshY1NWtTpNCqvIeP+6Gll9YQJLfnJMOdB/7Le7beSmBwsGVWYMgsuWN5NZtCcXKXp0DT/ORmRBV9d3e1O76oJ05vqqKG/Na1tJkt8DSl3Vu5Cw4rY172qHiXUq8EkArBErzh1Zrc/x/LMxt1fWPOnDiJMyKdDhhvDrBez5IOYhFGg4WaX7yR3kUBr7Ov7Gu/rkoBJOSopSjN7GMg8xpgouyz++ybkIk1d2ednHJLZHnF/HUKFTWncZUTR0csS8wi74W3GeBwB3n1HPUQxcV2qUCoXFlByPJo0hv/TJ+WfVIfdUxPy099vEvrRtzvnWBesNp/Bn4zYbKVQ1LJMRxC7rwZBcHTbgL1ypT3U9bSBmlchf4A4QZUOKch/JdgQttAh5GiCbTTRjgo9MUClG7P5/Mp4PIoSN+cH3ZV1KXBQysy3QiczMYW+g0VCrwhN99AI3/34PE/yT76ypuWzyqPuGUqOaUK0V564v8Yonr0tG3vhUZ3L5zUYxWOZTuHG28QWNf0lvv1sZd6WNID/Y++VzlpQvcxqQqOIYCuj5cR/wIAGt/ykeuCahp3Wbwb0/H4A+6CSG6RSMFnHUoK2eblqIezIryhZSCBA11q4BJU42+gnxKc33f6kCQV6xgyjJQBhYWqxdW4zeZIVt5jHryXGaIfaBtAbk5J4p2wd5ht0J2DDrwcWcu/JStIloTuk/hQYgR0j7YvoRUp6U1kDE7vKzg0JwpHHpiVqvU2KWhUKhLzFb8NawduVQeLN3K5xZ5CA06DtYKiI3RK/bOyLKu2MxAeRTqcULi
 OM2f/Lep
 adK+i2qFzv2ZnMkLGcpkHUYha4pDnYiAzhUIclOQjWUl2h0vEAsbjN//bs4xIo0qbH2TalJzEz60YRsYgfnXopENNOFxZMPh8Tiyg895efYtFWRv+BlDXk9FUX6W8AaQLG9YXKEXR0q+U+4w+zf/thf9jp/p5uGoaJsDH0rM9yCMbgTT+IddsRJdMiLwHwHjCzW++y5uwrtaxJ2MXjeotroLwjtUW+TMjpWde4hpmjpTRuRYqicfEqBlnLKUf6CPQzkrWKJL22xnw/4kwS4SGWFuy/EmbJwBMLGDdr9PGka7UhZReh0FOUM70QMEVxwRZ0LOFDj4kMjxsExgE4p3EWWGBZCwqnx3vfsE5KkBjaiXwBh5Srbb8i5DJGOqx1L2dF45ASLZJv6WyBUhTyIoH1rYWIqrirdGmvCBRc5AX2zGJdcAD1hYPCDlyIXG6+FlMPF2WdANZ8gIl5hEryzSh10taBw8vZw+CUSUIkaip9MCz6KOKLFkFIX7uM2WzzpYRLtfHbRgYnW/RzGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 7:46=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Apr 28, 2026 at 2:23=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Fri, Apr 24, 2026 at 12:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote
> > > > Why >16 bytes? Do we need anything extra other than the reverse
> > > > mapping? Also why do we need a double lookup?
> > >
> > > You will have to store at least the following info: memcg (2 bytes),
> > > shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
> > > bytes, since you have to address a full virtual swap space). And some
> > > type info is also needed. Part of them can be shrinked but still,
> > > scientifically, merging two layers into one is considered a kind of
> > > optimization.
> > >
> > > You need lookup the virtual layer, then the lower layer for many
> > > decision making, is was discussed before to introduce more cache bit
> > > or things like that and I think that is getting over complex, reminds
> > > me of the slot cache or HAS_CACHE thing...:
> > > https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8=
fcyzVOKE14-O+Dw@mail.gmail.com/
> >
> > I think that's where the disconnect is. You are considering these two
> > separate layers, each with its own metadata. The metadata should only
> > live in one place.
> >
> > If we only have swap tables in the virtual swap layer (with the
> > metadata), backends do not have to carry the metadata. In this case,
> > backends should only have a reverse mapping (if needed), and some
> > internal data structure (e.g. bitmaps) to track usage.
>
> Ah, you are right. This is currently an intermediate state, that
> problem might be gone if we unified everything.

What do you mean here?

>
> > This is difficult to achieve if the virtual swap layer is optional,
> > because then the metadata can live in different places. This is why I
>
> But that's not difficult to achieve at all with an optional layer, and
> actually will be achieved naturally without any design change with the
> RFC I posted. Swap count / cgroup / shadow all stay in the top layer,
> lower layer is "reverse map" only (the undone part though, it will
> require to move the cluster cache from global to device level, which
> is also required for YoungJun's tier or any functional tiering to
> work, we may run into more and more detail issue like this).
>
> Might even be easier that way, it's pretty close to the unified states I =
think.

I feel like you're moving towards the other direction, no? Seems like
you are unifying swap metadata, which is good (vswap will also want to
do this), but the problem is, the lower layer will have to allocate
memory for these metadata too...

Say vswap is optional and runtime enabled. How do you structure a
physical swap device's metadata? Some of the slots might be directly
mapped to PTEs, some might back vswap slots. These two cases require a
two completely different set of metadata: the former needs reference
count, swap cache, swap cgroup etc., whereas the latter only needs
reverse mapping...

I don't think we should mix vswap and non vswap slots in the same
type/address space.

