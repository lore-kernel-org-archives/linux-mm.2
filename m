Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A16BC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7EE6B0088; Mon,  3 Aug 2026 12:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7588D6B009B; Mon,  3 Aug 2026 12:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EF66B00A2; Mon,  3 Aug 2026 12:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4EB6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:53:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D16D9A21AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:53:57 +0000 (UTC)
X-FDA: 85060555314.11.558AA6B
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE4D6180009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:53:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ewzfty8w;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785776036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9IfHCJ55TIpuuGVduSHBR4SUqDeJcna8GIDAX/jjGU=;
	b=O8xjVrGS1mYETFoBGOWEv/P9JgYI2FHo0ZDRD4oOYUTXDycZHw1EHqihoMP3pOmScXZUq9
	utt3Jmge35RqVMgppF5ERBZL00cfoIab6t0DdPI0cZ6oduKJC5lxwqOmMefFMRVBsLgFLY
	PakmTrF1QdQrmV9U/zUIzvKLILLBe8I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ewzfty8w;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785776036;
	b=cUhJdfDWK9lcEtvpO8934QhLExvO8fSnRMJ/HkAPPoBwFzH2fonDtEtI8l/pXNWW6CMKMF
	gTm4ZDfguqzS2/BGSRuf06PhD6YjZFbxPrINou/X3y11mGY3H0Y9WAiadTLFf2hfOEdTYg
	m27g3KEbM1nVZ/xzBN0TUHkOaWteTCc=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f29ec73064so23822976d6.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785776034; x=1786380834; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z9IfHCJ55TIpuuGVduSHBR4SUqDeJcna8GIDAX/jjGU=;
        b=ewzfty8wfjXV2QUOJQztgK3oNYOZsSQfW6kJTANMDmJkARAZYjO8r+5ol66XK6VqwG
         avDszX8f6SYxfM11dY3uDRxWjCE9aSItJMmJWiwH6+I6BOovs8isoz3DW46iYmJBUX4w
         i4AfCI0K1gjizEPq9/3tEEZiRoC6aVVsDALDaEkVMtlQykeDWQHiaviwt+vMEbrdYOND
         pmawrbgD+HG7T4uBLupFwMemgFpZmsIPZvcPYxAlIAOS6U7bOnLT92mS9SPTiwMPSbWP
         O9k0YYJHZ8Dbild5ut3Jx9c5BFeawJ14XufKgJv807XaHZFCRzSeBwlvaIAPlzOpX/4r
         upNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785776034; x=1786380834;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z9IfHCJ55TIpuuGVduSHBR4SUqDeJcna8GIDAX/jjGU=;
        b=mGk4DU9CNCaME8WD7lyyKByvSySpgrb3fVrOhfvHaTemhyHKDfG6SkrjAwQMA8+tK+
         56/hXa58AMO/fd2JA8FYz5QI6jV67nt8PeZ2vEfHDPHkcVGL3De+O6LswJUSINjKydc0
         gK3mEhD4uL/s0zn0VjmdkhIPy3pz2QFaf3OL9O8arfRS8I9H7EGA2Q3yf+i+LzyJe0A1
         qwghLPsALvnWRsmTQ2DP7YTgN2o1q6aV66oskczwl4y79pzDMZoBo0Z8rlVZxvGNHyax
         5czIpzTDXUdOWwng7ipTv9D7SksV/KV+K87PdheTdWsm5yx7M7tTLGT/c1fYekMwCC0p
         0TiQ==
X-Forwarded-Encrypted: i=1; AHgh+RqgP2kY9e4PDcj9vEmWWLQnyfZ0TCL0XJfvQP7tS+0R0J51fIxnZW6l0Z7SJZoTDDu5jzeMpaP5bA==@kvack.org
X-Gm-Message-State: AOJu0YzCuiLMvjWIM1Fyls0YGAeJ0PUI4Z8TP+zEDMFV1KzazR+HXwzD
	J5ejObDhcKT/kSSnrhqDYd1KDRdEp0Uuv2IwydSxEJ7t+jILNyMiv+VcLTaAkYXO9cg=
X-Gm-Gg: AR+sD10fnuTRg7sD8vW7EcLpk47Tsd1ECaQIouBeeP1GUs0+mNuyFvbrUcfQGFnwY0K
	rJcVbjDBxVn4knRrInpsKLJv+JoAumdWEOa+2ZwQH11VNpTmnU1Wme5k7ZaEn47L6mTDwwKaeIk
	S/+V1QC+8AvzHbGkg6TfwAzLHvM3JJrN/U5Zl/QKU+a7a/3+BjBiQyAqt9YHGp91xNMqcswTYNI
	8rueLUAbpzCGIXmewUbjxRWRBcRWWtHr8j9XlCCVaRGSiXRu1jArMfXr9GS8VJ3ys5u7I5Jja9v
	Cg45l32qPzlq+hY8Y8t/K6pEFvZ+ZHNVVH09DoGoc36++cAzIBBIctlDGs53vAsPV/5a0CxdFHW
	zlY568zdvJLIeIm7AyHChs+F2NCEhIvLnGAbzNsmjcncx43ebKxpRC8fDNUlwFp41xZjNsvmTRp
	F8Hoo2sedJqaoejiv8BnFzO3yR/GdLPasyPLiEcCbXgWSDy5vb5BXKGzMLRwg=
X-Received: by 2002:a05:6214:5548:b0:8f0:d59d:78d2 with SMTP id 6a1803df08f44-9084956313dmr242376206d6.5.1785776034484;
        Mon, 03 Aug 2026 09:53:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435b6948sm79412756d6.27.2026.08.03.09.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 09:53:53 -0700 (PDT)
Date: Mon, 3 Aug 2026 12:53:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Message-ID: <anDHoYNn0lPc34cK@cmpxchg.org>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <anCuGbQ_-pTajAed@cmpxchg.org>
 <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
X-Rspamd-Queue-Id: BE4D6180009
X-Rspam-User: 
X-Stat-Signature: qsqrb1wbzatqdb1pnrzpabeg6uyx4n4n
X-Rspamd-Server: rspam04
X-HE-Tag: 1785776035-34498
X-HE-Meta: U2FsdGVkX19YLhSOSPAKoxPyd7Ksi4Mi8B6cpW+0mNhCxNzzIWce8zfJjsL5gI8OU0YGqUNPzSI2ljPhz/i+lZ33Z+TminQ9SWiZPLjtzXNg3I008JaNln0BAgJo3Wkhnj0d7xCzqD+S59DqcFVW3/hk8wZZzechzP8A/sBMGUV+jgURPv5yyKS1OjwbY1QfmVXOLlj+OgqumO1AMCEoFJ5k7xVT4yQtl/+wGUTzamdgwt55mWUx0IDVQh938LM6lA6h/RbHZj0Mh0es3i4XlIcSuMIDLEUZ61WAV9/KLI/IW5JAB5vnVnIAJ210hnHizxNXobmqdQSM4xJDYioImTgGI4Og2cU4181IlUYmFm456D0K9ORfpDiG9UIZZPKA7pfSLsApnnJ1FN62XwKjn30zd/oJ+JHa6zewN7XvOa0UQ8q8quzCIqAzFMnGkqKmIgI14QYsFQWlu+QybgZO1P0QCUmqHzHdTUlcaBFfRW4j2Zdy4w1iIRkv+0vnR/aOq1eJeKMT5tNrMYpcFHKkJnew9yKSVRmQ1+SLbbjSzRprgeQTGXTaQ9fUE+fA/OnVISfx3fkJl6rxBFmBfX3Bh3BWh4DR/2RiPG74sOhMXB/zUusb5XZsr/B3ScpxdRgMBcDGsBOZzdQvhL1ha7hj747zBnKBUnezNpBJXyVdLVU3MVWarmAfjQfQ9lZhg8qG62Ru8IubFDtAS8/e8YN6tD/F2zvvfwBUgSpOYymP9PpPwuezZthnbQIfkyrbt607C7xjZh427HtYwoOddhWIS212WeodenwTJ6CsRYvTwXuSrtQOEiZRAvoDVPcodgOIHOjE3dFE8O5C1k6vNn/bTRyTkUlN5OyAPr7ALPTHx90pMlFatMusD24nxGNQqwqGS3nMOtv7tT74osDs4ZoCKKItYnK99hZRBsWidmbxWrJsJmUr1Ewggah6AVcTgRXU97yRsZPLDr2ynkvQHEm
 qNbToGSZ
 nal7ZT86dqo/w0JVv3qlgDNlV1EL57EcJ2rSNmiMpUfkOEB/Bm1Z112M5OY3Cl7NvihVxcHzbPN9v44iG0IGRGX0pPQNJ99rNgpDSR5H2RMZOR7rRg4RO5Ucftv4LdSqjQxaceauGLkJCuLiq6cF0AvRGIMDW656Z0fSFf88aBbMzlJAMaEIwGEvl4Ee5lrhnePkg80D3TghlEw7GpkQiO3bNZtzzACmDHuUy3D78jPj4cGAvnXh+bdX0tT8oXvEoqI2JK5UABVFb1+tlOl0EkiZLl1j7DNJJW+8tV0D8md+oTeRyGf1DDZwdv3pfr4xgZ1N/P+rdL6QJf0j35JCXGdCHp493r0zULtiqkNnQbB7pDSkyr/NisyOSkFuBOHwdHmcaz4FE1fGFX7euvFF3p66ie0xK/LdYUmAMoIzjO2KeUeXp/M0qNuGvnK+MWjGwGizPG6F9X50+B308fYwH4ac623ioEmisMb+Eew4kpH813JE8s/TVk7hzEUX/HJpENowIc7KvhvykHmRGMXekQQN453WGnY6Liv0vXx+wgpby6THKc9dj/2clOrlg2yZubgHENjBy7pGleKAjmpG/tG0VoKW8l6miBcidqIZbJ8Mlls/D/XK9OGyhvPxoHl83x9q4/20hgUyX8KQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:34:35AM -0400, Zi Yan wrote:
> On Mon Aug 3, 2026 at 11:04 AM EDT, Johannes Weiner wrote:
> > On Fri, Jul 31, 2026 at 10:13:24PM -0400, Zi Yan wrote:
> >> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
> >> Replace it with zpdesc->zspage->first_zpdesc == zpdesc. The check,
> >> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
> >> should be negligible.
> >> 
> >> It prepares for a future commit that remove PG_private.
> >> 
> >> No functional change intended.
> >> 
> >> Assisted-by: Claude:claude-opus-4-8
> >> Assisted-by: Codex:gpt-5
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> To: Minchan Kim <minchan@kernel.org>
> >> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> >> To: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> ---
> >>  mm/zpdesc.h   |  2 +-
> >>  mm/zsmalloc.c | 15 +++------------
> >>  2 files changed, 4 insertions(+), 13 deletions(-)
> >> 
> >> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
> >> index b8258dc78548d..4fd81c2e80769 100644
> >> --- a/mm/zpdesc.h
> >> +++ b/mm/zpdesc.h
> >> @@ -26,8 +26,8 @@
> >>   * with memcg_data.
> >>   *
> >>   * Page flags used:
> >> - * * PG_private identifies the first component page.
> >>   * * PG_locked is used by page migration code.
> >> + * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
> >>   */
> >>  struct zpdesc {
> >>  	unsigned long flags;
> >> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> >> index 8204b76f78308..e8ef227624efa 100644
> >> --- a/mm/zsmalloc.c
> >> +++ b/mm/zsmalloc.c
> >> @@ -290,11 +290,6 @@ struct zs_pool {
> >>  	atomic_t compaction_in_progress;
> >>  };
> >>  
> >> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> >> -{
> >> -	SetPagePrivate(zpdesc_page(zpdesc));
> >> -}
> >> -
> >>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
> >>  {
> >>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
> >> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigned long obj)
> >>  
> >>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
> >>  {
> >> -	return PagePrivate(zpdesc_page(zpdesc));
> >> +	return zpdesc->zspage->first_zpdesc == zpdesc;
> >>  }
> >
> > There are two checks: get_first_zpdesc() and obj_allocated().
> >
> > static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
> > {
> > 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
> >
> > 	VM_BUG_ON_PAGE(is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
> > 	return first_zpdesc;
> > }
> >
> > If you expand the helper, this seems kind of pointless now:
> >
> > 	first_zpdesc = zspage->first_zpdesc;
> > 	VM_BUG_ON_PAGE(first_zpdesc != first_zpdesc->zspage->first_zpdesc, ...);
> >
> > Mayyybe it could make sense to assert first_zpdesc->zspage !=
> > zspage. But that's a separate issue that the previous check didn't
> 
> Usama has the same comment about this.
> 
> > necessarily catch. And might not be worth checking, considering how
> > trivial create_page_chain() is.
> >
> > In any case, it doesn't seem worth keeping the check as-is.
> >
> > And with one caller remaining, you could delete the helper and inline
> > that expression into the check in obj_allocated(). What it does now is
> > self-explanatory; it doesn't need another name like that PagePrivate()
> > check before did.
> 
> How about the version below? Basically, I made is_first_zpdesc() more
> straightforward for backpointer checking and first_zpdesc checking.
> 
> 1. get_first_zpdesc() needs the backpointer check; the first_zpdesc check is
> meaningless, since the assignment is done above.
> 
> 2. obj_allocated() needs the first_zpdesc check; the backpointer check
> is meaningless, since the zspage is from get_zspage().

Personally, I'm not a fan of "super predicates" where individual
conditions are only useful for only some of the callsites. They tend
to become obstacles to understanding the code and lead to subtle bugs
when developers misunderstand context requirements.

IMO it's better to just precisely express what each callsite
needs. Only factor a common helper if it's actually the same.

