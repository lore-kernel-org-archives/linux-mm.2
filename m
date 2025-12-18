Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFFED6D234
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BD06B00A4; Thu, 18 Dec 2025 10:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19966B00A5; Thu, 18 Dec 2025 10:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D186C6B00A6; Thu, 18 Dec 2025 10:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE9846B00A4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:28:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43DF512E5F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:28:42 +0000 (UTC)
X-FDA: 84232974084.28.328D7EE
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 32D4A20003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:28:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eY03gj8t;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766071720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn8BgWn6I/LIk4XGC0f4AkO9wXJnkOd0NBG9ThvD7us=;
	b=mU7w7i72IQU8UuZtLWLeRDjwy5llbrnA1AR7uQSVwhjsLP/H1vOS6CN3hRJLXIpXVd8KB/
	ZNfBnLzWeKpTJIBpALJU2EjHFQuZoaudX9cxBR1TpfC3qNfkOD6PQXvnv+3dMJ6YwZcJyo
	19sp0bly3RLg1xcvy1OzHH0G+rtut4o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eY03gj8t;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766071720; a=rsa-sha256;
	cv=none;
	b=pIgxe99L1YRzChEYrdhjS0f915mdQC7veQBZnF6TMfPXbFGjoEFfpW/yivaWQEaryURSWk
	uhz4N1axyOwmx/T96DVZimOCBX9aSIqvVR8/8Y5XlZCWpO5AmUw6KFBfagZpPzQnXcn4vN
	yiX03QPbcLC7TulTNC7lyu2EPQm5yZM=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8018eba13cso113663166b.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766071718; x=1766676518; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yn8BgWn6I/LIk4XGC0f4AkO9wXJnkOd0NBG9ThvD7us=;
        b=eY03gj8tSdBZJS7BDvJWOY3k9pEcBQARLqx+S0IDClYOGPA+oqDlhVy1/ThoQ/7Zxr
         rU1wrHQN/GF3jVavHDi4RNdQwW2JyHsQdK5yj0MpAf2XaDd0oTpBax/7rG/n/xKFVqxA
         FGTsERjSBzFxmhlilA+E8wByq9QPB47Bsvo+dhzkonvSWzzIBBTVfBpDeWEJBQHohB+3
         CxxLZLa9W4cIWeJWZkUmJzxEBF2M07PY/ix4lsZk7W2tDl1TWJpRyABzGZ45ctYfXFv7
         ElgCHz3hKgO3moYnUtVdO+IZG9/1r8yQ2v9VaPHCtchdEOjAKJy9z32aCHiECw2mSe3v
         AAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766071718; x=1766676518;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yn8BgWn6I/LIk4XGC0f4AkO9wXJnkOd0NBG9ThvD7us=;
        b=wDAloBBwZYSQ6zip/0Z8MH0FlRP1W87ylJhxnMvFVNDlrwX8yOu0P/VYenMMZa/4AO
         zCefkljzTrjAKSdAJ84DarGpa7fOd0GCRwNDDqCO95+WXbmh99R78KLw3izxjUcBWMUb
         r3ODnVpy/VCKvEAPs86E+faTAhxVk9C0+aoZNNpxoWaHzDEaL0TwGTaA0YJgqlMImbh2
         9l60DoY6xCOuDY7XH5cTqSnrEWK7x4SrziAfsekcOPYLXsPK1IXMs9N1troMwtsEssh8
         cYsVo5XAnzoos8vBx0NISSXN/9yyWe+UW09hUFQKzV8Jwuv6/P1dKczAjWIVwYX9kAJI
         xUEg==
X-Forwarded-Encrypted: i=1; AJvYcCXNh2u5/1QGUdqOSGLjzxdFKBWEFbECSnQDZ6E59BgkfiGaavJuJQlfLMQnLRQQftsrMgIROJYXrg==@kvack.org
X-Gm-Message-State: AOJu0YzymKoLzETujUq/VvPCuihNQk7D+NtDbHggzDOBTxzfbyHFK8D2
	qLscRWuJptLht2nKxOmy1fkOck9Uj29ri25L8m+JLqusrYFtEn5iFq8c
X-Gm-Gg: AY/fxX5Rg5q0rrFaLyvSrqzi2pmJc8RVL/a6bxM6p1f3DGbNPfLpNlXj4Qu5I8EsuGP
	gH3Q+Sibw4eNO5Er5lrMk/e0RV0eXBCrmp4zBXPDL/subAKbWaGJub1Flr7NsmRFWLImVs8PCme
	M8ZqbQ4lQvgZD4s02pT/EkpNIRaH+YgdoUclPDEUETCCGpk3OJOZVJPwzstyj2i3qDnOrt48A1w
	76u1QlqTR50JcER1stDpS0byyIdcs8m8Mttu3GTtmIDFI1cvcXg2b2Y8hL8LksqxC7sekTDdZyx
	uQvGNaAORXFqAbC3IWzL0Fd1BbEWqNxAjLhCyfTAEb5LRhGx9f4loBVkmH2Td86mx41T6NdXGXm
	cN1KQFTiunwtcjz1PpKffA9HzCUtaBW9jglCaydl6LUHgMQ/GHrgtjq3kFwr10l+w5m6FtrNa/R
	Z+zPdLXHBwvA==
X-Google-Smtp-Source: AGHT+IFB+jBENudrEg8djabfVcvhY88+PerQmmOFV0npol/NL74g9Ze9/JGTj8KVHVzSGaSpyvOlew==
X-Received: by 2002:a17:907:15d1:b0:b80:1362:c445 with SMTP id a640c23a62f3a-b801362cc01mr358488366b.61.1766071718261;
        Thu, 18 Dec 2025 07:28:38 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b80230d306fsm261778266b.19.2025.12.18.07.28.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Dec 2025 07:28:37 -0800 (PST)
Date: Thu, 18 Dec 2025 15:28:37 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <20251218152837.kbgmrjb5i6be7xow@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
 <20251215084353.nmznnnmcpcqo4ldy@master>
 <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
 <37c5dbc1-bd66-4124-987f-8983a06d576e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37c5dbc1-bd66-4124-987f-8983a06d576e@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32D4A20003
X-Stat-Signature: c9ptz6bdg349urryqqkk8t94nctcj81n
X-HE-Tag: 1766071719-328139
X-HE-Meta: U2FsdGVkX18nZnFA0VAPUnlZ+HajWTB0Zk99vjF7awkeuYK3VPx2Q4blyh4pDYsnftVaiaeOCRkBPChHr6Wl8nra0Jh/HEdA/S46AhZT0p4RGcfsWAZPJt85JZkWGlU74RSx+vBGarunPNx1P7eHWfGkfK3DhbDfrOBVB/WQB8+OQq5JeXJPGnMV9bsMedbhpmCZ38RS+dnXyRx7xBGxqtOQsOfu//KGvy72VXCEPKd77wJdOV4D25O9Gxo+3xJSP2+lgWNiwRMg5cQNWHiaOZLDf3zhxOd0ZVSzDM6/oCy//DwAZd791xMXY9NwCWZ29IceBfsyu/0KUXsN81VnIaau5OrXnMQGUL2Bc9/Y6/Sf4oWC2r0By5dkUqYp48DtXtMNhpeLiH3nmrRoayUOnj3z0M3KcTvtqJIegKQW4FRhmXjVtD/FQWcWGDd6vuzV1lYvT3vCUuTF6AYOXXvZ+GN0d1LawWf/5e2lCtLIXs+Tn1Q1VR97jvhOgF7dX7lJEisRB7LDIGZEihIYft8P6vjkPAI45jJyF4Y3zm4DGMyJsepPKWD6/RwcUcyo6jnxEYOSlApS3YiSo4zaovqpLLu2nDeoqfycXnj5p6K2afYGz6aYIKRB9LL9Mo5omS8/JkhYdUNUAvsgjQ1A+8/mTRfQeJG90ha3JNpXNLIiG8HHYHCFoyQXh7wXDL1yQ1kMY6lH96lLstf3n0O+1e15NCC/P6K3RAgjPHnt/Mw1UiG7extaTAeP41csiocvLDmth9+Tm/xMtuQhNljoiRXbWP2Ib9EsIOETWyhgjqm57Xp2XOtjxZBGq/Lso2q2P2sDq9UGxsMWQtpUUvfNZbwxvl/ZFknDfZBHbcXPG+Rv9oaVfkc+5geV87mFttGeTYsifSmUCS3+t5Rta5MCj5GluhfL54T/xpbwuF12mMm9hktYbupooCZaJfpnTJbk43BVKMKBWXxEkR3kcrZ9RvX
 iQSDBCIc
 Ues/Wdh6e3D+XxK27Xs/Zrrsi5QcAGcb3KFtH67Zd4KodfB2xBbQqpGPDAr0jBznvUjximd4tFNZ1w5s1bEcUQZvbfU97XyyPya3JqMISIgkc4GJ1XKjjhVblG9sSGAvgS1xJyFiNkWMHgheejjV/NTkMmxwuhaqjd4me0mVeZzORPtV9jpxEEQeiUdEpuwsL65ObmIBC+6H6ZrQZjeTd0fb0nJ32LBQwIRKmgAey8ZdAU0cSuc+N7/awEI5CyaK6Hgjre+NmtC60y9+hpXJX3sPJ2HFJKuT/MGIlTR8IWcAMIkjHDEmPGro61O+a9Jdtwa5ogEkv/PWRVkD66dcGrYlqY8wgyrKDSDlsiNsrGwDfSp0ZVlrb/PcBd7/JI7oerMUPhrJnyvTE6iikQ79ajKEXDkibjE1MH3zd/0wX5Fyy7MXIFaaIFXmrVrWlFD0Ni6JYJY/tRJ9rMphyK/0VuRp0Ib2mup8LCKXRy9hLwXYpKc0KvY70ueqIi7Kz8XvBpGtq0H6Svqer80Rlo6Q6oVffu/RsImM0PhDKfgY+KM8pzYgNDT2CA8T+3L+O+eqzK+uoCJNCS/Lw0o6m7RUIR9LbxRQZtcRdLAJz7A+aCmvmtwN71j2Q5TF2/BvVgvsqjPboXIEyzJqrBWTDciBA4094p6VEzfVDSVdD9KrpPJtyvnJ0fEMxsqUdTB+Bfa+JI8xNibAi3iq6dJ2TzogE2WyuhlNo8+47Vgh9wyMplPAJlX8nde2fs89Dk4AplK+Ub11PYW3TkmIEQ02CsSWbtRl3sbMEeBIsCbDxexHQAWCxXDDqJYFdke7sUD1h9llMe8TE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:58:36AM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/15/25 10:15, Barry Song wrote:
>> On Mon, Dec 15, 2025 at 4:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > 
>> > On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>> > > On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > > > 
>> > > > After splitting a large folio, it is necessary to remap the resulting
>> > > > anonymous folios.
>> > > > 
>> > > > The current implementation determines the end of the remapping process
>> > > > by counting the number of pages that have been processed.
>> > > > 
>> > > > Since the final folio in the sequence, end_folio, is already known and
>> > > > tracked, this commit refactors the remapping loop to leverage end_folio
>> > > > as the termination marker.
>> > > > 
>> > > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > > Cc: Zi Yan <ziy@nvidia.com>
>> > > > 
>> > > > ---
>> > > > v2: move folio assignment in loop
>> > > > ---
>> > > >   mm/huge_memory.c | 13 ++++---------
>> > > >   1 file changed, 4 insertions(+), 9 deletions(-)
>> > > > 
>> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > > index 40cf59301c21..fe812d9c7807 100644
>> > > > --- a/mm/huge_memory.c
>> > > > +++ b/mm/huge_memory.c
>> > > > @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>> > > >          return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>> > > >   }
>> > > > 
>> > > > -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> > > > +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>> > > >   {
>> > > 
>> > > Do we actually see an improvement in readability or performance?
>> > > The existing code feels a bit more readable to me; nr is clearly
>> > > the number of pages :-)
>> > > 
>> > 
>> > Hi, Barry,
>> > 
>> > Thanks for your review.
>> > 
>> > Currently end_folio has been used in __folio_split() and
>> > __folio_freeze_and_split_unmapped() as a termination marker. So continue to
>> > use end_folio here as a termination marker looks consistent and improves
>> > readability to me.
>> 
>> In both cases the variables are temporary, and they look fine within their
>> own self-documented contexts.
>> 
>> Now that we’re crossing two functions in the context of remap_page(), this
>> doesn’t seem to be the case, though.
>> 
>> > 
>> > But yeah, this is my personal preference. If it is not the case, I am fine to
>> > keep as it is now. :-)
>> 
>> I personally find the existing code clearer, but I’m also okay if
>> others like your new approach more.
>
>Me too. Well, the existing code could be cleaned up
>* nr -> nr_pages
>* remove i and subtract from nr_pages instead
>

Sorry for my poor taste :-)

Is this what you expect?

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1db9cfb09533..b8ee33318a60 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
+		nr_pages -= folio_nr_pages(folio);
+		if (!nr_pages)
 			break;
 		folio = folio_next(folio);
 	}

>probably more ... :)
>

Don't catch this. Sounds you have more idea on further cleanup?

Glad to hear your insight.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

