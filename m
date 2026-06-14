Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD86CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 14:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D316B0005; Sun, 14 Jun 2026 10:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21ECD6B0092; Sun, 14 Jun 2026 10:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D006B0093; Sun, 14 Jun 2026 10:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0D8A6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:10:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A936F8EADE
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 14:10:59 +0000 (UTC)
X-FDA: 84878704638.05.257DDDC
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB684A0011
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 14:10:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ao8JvxSu;
	spf=pass (imf25.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781446257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHF10+gcCY+52/p+MI0EpREqdUQuaXVQZcqVUlKnjNk=;
	b=XZ9D2eR82mX3D8aXnQbNs7nwdJBzCTtj8lLwB0esyElNnwgGhptlQ3E5uL8knhP5uYrZed
	8Knl0U4p2DAafo0GR6ClQ41UDhRw34+pXiRvPgkgC9F4HfzTK10nRukr6Ehs2GnoVgCQmE
	WyGzBRcRSXlUL1llqM46uLuLaUTL9MM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ao8JvxSu;
	spf=pass (imf25.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781446257;
	b=kxOOr0/v+icOKjmtoNn3ARGaR4p6u/vbPXGpYrjnqo+63bukIoeLqaMDJrW4dc91sSGNTq
	8FsRMgFnHqlXY/nqlCMSz9ONZUrscdXPKYelReb751cDRfTH7ItMz7cyHlEnv5hq9DCuUK
	GlFfzLa3UbapQ36E6/6cF3BYiLFTLxU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bf2d865383so81075ad.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 07:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781446257; x=1782051057; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yHF10+gcCY+52/p+MI0EpREqdUQuaXVQZcqVUlKnjNk=;
        b=ao8JvxSu7+mUM8mkWnhFOlSiflgXMBspsMPwfGBkthgJk22k/M2O+FPlcoBGLNEylE
         xaF1gDdf+8er5vDnfzxHz/Zct9k84sCoJzSOhycyf9VgOZuxWjRKPv0mm2IRV8R8Nd+X
         Wrf9AXlBqF+USrqMDKJsHfPr8pKORggOlmVaRRpOdtz4bxgsL0J3BpQNK9V/jDikwrAm
         T4Yl98x218GmzXEmBj8sBv7+CIBr/OtfPfjft43IPp1R/3w9SAqL1BNi7o+yUFcLrSAO
         oSY8WRxQwredwi2bwSRRcxcams5Xcv4QM0ABAJhUw1UOL8vEHsilgKU77ZAev5Fc9m6Z
         QL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781446257; x=1782051057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHF10+gcCY+52/p+MI0EpREqdUQuaXVQZcqVUlKnjNk=;
        b=n1blM/NCaYjmmNlMBwTtfn/ED811DT5/Y1LUpfGe5yfs0SkO1X3PMrt5hDegC3Iw6r
         4SbhRlZ39MMy4sK2ofC+Hl/SptWinOE0xY/+m289DwkpXij8v9KKV4yudd8LGd0VvnEA
         Ed9UzlGXROO/EBKZ14ikspu7bJ/FPbijhsxQF2V5MZCB0k3ZNDZtlnasKJ5C8gNwJVA0
         viL4AOTs9HK90a0bjAtZqcTz9NdVxjHxtVBRphDtiPSZQP3TksyPGsKpbs6QdkBh4/9O
         eDPm+uxnJe1HkcRJLZRbY6I7JNEqtdR/gTHAKM65dQiwC6QfaDZUnbo8zkuV1mmsrkRN
         Fukg==
X-Forwarded-Encrypted: i=1; AFNElJ83auz8sBoXoloBuztMFYGxZlJRr5G44ZDswHfUrsyDCYVC4fwU4NfWjhkG2lD9/xDA/aYDT/fuEw==@kvack.org
X-Gm-Message-State: AOJu0YzOFONhI1r8F3RYgtOqjkWohRD32mRIuESnWmBfQhEBl8O8bMXI
	OF6RBYLrQPZO0m5yItR/FvdyOGpRzrADn2LX577uzKTJtLUzAXnAAVmpgbWDk1k7JQ==
X-Gm-Gg: Acq92OHsskNmyaMBLYuwafQFQBapQ6woPWuB+XJlB7vDi9yQ4Ewujvl3dufhEsULOPM
	wjGXDzX6ILFu4PpNro3+CxAYVchuoVWD9Yj6Yu9cU+LLFqDSEMd+yujHSMxCPKaea4BS0BrTLkx
	KaPS8/qKlZrzvWaxL4WX1AQhOPWBNN3n4bOZP488NhbSIzRcCSzGQ+eVWJFFUH0wWnOzPZfB1/7
	V52Gwz8GMibmEiDa6euf/Jeqw1PXrr665QTa5WVU00T/yQkJnQcNTQQg9KfSAH5+qsCNK3E1b32
	1ti2P6LRROIffy9t9/cyBbm45fJC064Ao0BZIPuqMttLGo2BOiXIsri61JtIsJVRAgMdPciN3i4
	AV4zXioOQNPckZEgAW1OOGzJUyQJf4dRkJzI7N40ByEOCku7kIHTuv9qH3hzlU06BHGU7Qcbftn
	LNDjqMLjtx280AASHnBY/G6XFXsnMi9No+rKRPC3PGQLMpzvA9/SwX50n6rQxc9yU2b8dg2xQgY
	bob9WLX+TtA7nvD4Yy5pp916F4YvnyP/Bv49DOY7Gwn5w==
X-Received: by 2002:a17:903:2d0:b0:2c1:ee6e:be1d with SMTP id d9443c01a7336-2c665ec6cc3mr1663605ad.27.1781446256310;
        Sun, 14 Jun 2026 07:10:56 -0700 (PDT)
Received: from google.com (112.174.16.34.bc.googleusercontent.com. [34.16.174.112])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37a233f4531sm7699437a91.2.2026.06.14.07.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 07:10:55 -0700 (PDT)
Date: Sun, 14 Jun 2026 14:10:50 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Christian Brauner <christian@brauner.io>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Todd Kjos <tkjos@android.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <ai62ap9SS3KTpqeR@google.com>
References: <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
 <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
 <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
 <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
 <CAJuCfpFo_avdhpOviX7EsPqLgDJ3DfeGpth+yu1-ahfawqaSzw@mail.gmail.com>
 <2da031dd-4442-45b7-9515-72ffc60e8d8c@intel.com>
 <aixi-DxMuc0MiGeO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aixi-DxMuc0MiGeO@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB684A0011
X-Stat-Signature: sh845wsehr5xamy9y15jmkqnr1tfy117
X-Rspam-User: 
X-HE-Tag: 1781446257-172867
X-HE-Meta: U2FsdGVkX19VmK413Ymj7k85MLiUv3kUFOpiFnq+e1PCHM3fzN39ZPQsnM/I8lDgFBVxKNbm0lVVjyRUuVtbuUaCvotYu+h0p3PuRRtcRNWDpC25HC5QRIrURGkxMjg7kTmkWi1BKjxrQ1/EvNf2bblynYtY4PhhH1SOhjXw4GJ2hZTQb0cxMX4imxLCSxMO2Q8yAxpANPcjSBYmVOKiPds6aGTAR6vd6oz30VPv7OTEsfqkgqQo0vDavAMqbZVqvOBB6RuKGVWOEb3m/eYYnnTzDoNezxWgYCdEgtKOu/aSyL7gJR7nox72K3/l/TlYV6yL4H57ZU38hnR2vFqesnrEZwcYXFnhTutRhmoENov6583hCwbjCYwXPpw6T5ZgMcAt8drEpNVQ7aDFl1XH2Dtwv1VdcA8FryPdCodL108H+Wu19e5V7vCQI+tERMdgjRD/bTJ3yNAQO/1Zgbkjiczsdg9UbNUYUUKtPkW1FLmgeJVgtQcEW9XUiWe6eBwBk74tqyzS6xqsyheQdq6fzg9QlWusrg/y/w72mrqR+kOpRk9F7ErGgoNc5/RjNIacoE3I7pLW/yxDqU00yn8rL1hX1vXHrKInPkYNcKgpvzjM76mhwGQ+sfr/wjP4iSjav+1fPhHsSFjlhhAv8Aww9ci9RAli2iVty/unmxIbnq5bATDPNWu4tlBEqzXpk2K4xwt6zZYBCB7pXIrGYGUWqzWsNj5W4reiBIXub/RCgJCnspoHaq2CiUuc5zydCJ4fMWwcXhIQ+zRaci2QvKRLSDcC6Bkc6fu5EfqiMR81mf4RmMez+D2ZTLUXuOCC9ljK1X23cC+aHhQiYdw/Tk8ZOTbo5CSFm43KCje+VCFVISm58iyewirUjZd7xKZOhRtR+MBjts6sIctOFuVxq2iV7DxwkkDWrxVXGzhNdfT9nmPLARdoSNHhHlpJE91gvQU6Q3rUSk3r0SyPW5TJiyQ
 +62yO9VX
 HvMRyZ3lze9bS1m44y0LPvllx84ti6lkeJce2SAHudiCHNpOcoiAqqlFuJB5NNOL7K7/y+vSE3bMSyKLe2wC3xhssGXeiNnhMi2ix+LoF9hpV+VNlb/Ojqni/rTSqogIeUpgSe12qgPkJXVJ11/C047bgnRYzJUbnGPoAiAyMyTKoGyo7c9YkNe6REDrqSo74LsFZ+6rnoNgem38bNC+JjrIKg9tb1XhgcB4St7pV96oUJWoPQ3Xfswmh5AAH0YtBPgXeiwEmC543fQqKvR///nb5IGnLr0hm7akdNuwYgPvMA1Av+Y+ffG38fSWfm88JSkjT56DL6GHBbN1awqf5hJoUS32K4IjuvjyoqqrlcHpl5Szk99b4N/9XGPe3je8uyF7UWxscmQVbt758dQ+g2mRZFF/3VI4cGgwRMIYYpafjbMHVn8WopC0t0TU1JYDWvr0I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 07:50:16PM +0000, Alice Ryhl wrote:
> On Fri, Jun 12, 2026 at 11:47:59AM -0700, Dave Hansen wrote:
> > On 6/12/26 10:44, Suren Baghdasaryan wrote:
> > >> It's not impossible, but I do think it is irrelevant. Or at least that
> > >> the *VMA* is irrelevant in this case. binder_alloc_is_mapped()==false
> > >> means that the binder VMA is gone. It's not in the maple tree, and it's
> > >> not coming back. If a VMA is found, it's an impostor.
> > > Right, but before your change we were bailing out early. With your
> > > change we would be generating the traces and freeing the page. I think
> > > that's a functional change. Was that your intention?
> > 
> > Yeah, it was intentional.
> > 
> > I think the existing behavior is buggy. It also complicates the goal of
> > removing the mmap lock fallback. I've broken that behavior change out
> > into a separate patch. (attached here)
> 
> I think you can just:
> 
> 1. do a lock_vma_under_rcu().
> 2. if it fails, check binder_alloc_is_mapped().
> 3. if still mapped, return LRU_SKIP, otherwise behave like a failed
>    vma_lookup() does today under the mmap read lock.

Right! This is the same suggestion I sent.

...
Also, I would _prefer_ if the commit message was more accurate. The
mmap_lock fallback was there because of "compatibility", as per-vma
locking is technically behind CONFIG_PER_VMA_LOCK. This would be the
only part that IMO describes the actual reason for the change:

> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.

Cheers,
--
Carlos Llamas

