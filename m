Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1173D46601
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B076B008A; Thu, 15 Jan 2026 12:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585A66B008C; Thu, 15 Jan 2026 12:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4884A6B0092; Thu, 15 Jan 2026 12:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0706B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:11:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D773414035B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:11:18 +0000 (UTC)
X-FDA: 84334839036.29.5E1EE58
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id B52E01C0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:11:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JK1WPdAe;
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtW1PN9Wh5au0plxSuq/Wu9X5ca7AqIGVUDcPfWsVL8=;
	b=HpC6HzaStWStTsWHMw//qgupbFL2IFYGG9frNb0oDJa8hXP3oQEofpiLPcrXRzTMZAoHRo
	Zy+oINrhGCUq9G7BBZ9Yh7luY8cBUqGBgGbFPB4au/fUM/MHkGrC7GkEN6Sy+tv6Id7uyd
	5TJRAbHUCQMajiAj53EIYn5bw7GniaU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JK1WPdAe;
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768497076; a=rsa-sha256;
	cv=pass;
	b=s0UMaMAy6wLjmLskthUSiuSY1zAErBpo/nydvNkuXT4CTOklRWpqd8RuaNWsmV4YfSIIVY
	7kgwxXkVZgxGiapP0ChuiY0HCfxWqF1FWUkUl94AJ980b7FHYLkA5Mbtm/kVdahhfRnEa0
	YJ/390Klt56GH7se4eib2U0uFLVyyBo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee730612dso81855e9.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:11:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768497075; cv=none;
        d=google.com; s=arc-20240605;
        b=Jw/1xpnaMOGI/nHhAiVk9VY1aD9NxNsIqsdDOnSn9jjxk1QpK6GEQRRNEpgdrIwBvq
         bq0ERVodHn7LJkdXkwgPsI7zipKIBeEc3ayuzG5h0Ryhm90CSV53lhKt2UJA53L028lL
         8rrT+UTklEQadUxDZB8qedr87m44lOBagD3iCA7asqwe3bQSnePaRVv9eED5tRGMC54u
         zWW00mhZr+uZytbpt7GGoJKfCkU847w1KRPpDvsNgC3Z+a08NREAyxEEJfE21PmDL1YW
         JCCb0j5or0JtkeMl43xjakRW4Y9Duf2i6yO44Nm2iux6HSKRHMtz6J4V5F4ivM5h9db3
         z6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gtW1PN9Wh5au0plxSuq/Wu9X5ca7AqIGVUDcPfWsVL8=;
        fh=VFR4q6hrdkN3KrT2zLJurAlbOUAlW+c4ydz6KGBasdk=;
        b=JPM5rXg+EBi+9B9DD9Y2icTfgsJLDLUkXi+1a9PmDV6sPXBLEika2qer5CrNXrCzYZ
         etnKm1WLTXYJ9Q4a68+Xd/bUrY6E8aKCFj7BBV1/eLeKgeSfMsYK+yzk78Wuo9/WWmSB
         xTyDqlcV51cip3ZQBLNT9cX3pZU4cWLd6wnpABVSZSOlJ2ZLqSzeD9KJxrgfInlSspfk
         xAqARoJZLGdrrnM/oZ1ayqgXalAPGyNEkjF9Jdpa6XrlOaXgUCt1hALUkbFTJQQ/gnQc
         Tlx5EkL0tijmSGbR9XB9jqvNKxpUrgaMK1yqAGuxCnKX3i+izwIxzcik1tDx2GRFWsXB
         Ysdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768497075; x=1769101875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtW1PN9Wh5au0plxSuq/Wu9X5ca7AqIGVUDcPfWsVL8=;
        b=JK1WPdAeOy5c2PqqIqcVl0Lr9kaVgJIqCRAQ9Hfk7wFczLLYjuln3ir3Ci5viV/I9H
         7mYzrQJg3/tZAMW/yv5UZnqQUGZziS01E8vV06sEj0LJS/TmlwAfeP5jRMAzG/iDMVd3
         Y8serhDF0MW/YpICuIXN1IilDEkF45RPw3YJkGhousRg9MmjNs2Vyvk2QNo8N/OINeEd
         OMVnRfRObGpf7EMeNNWZAXPEyDXoFTohEcO+fdrXV+PjP61LJWSX/WfMY4UucWou469d
         wn0heoQsU9UL6okl6dOKveR+PdMgpKCr09r6EWIAIyToxGUY20V9VJYjGJGMZBtzl9zO
         G8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497075; x=1769101875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gtW1PN9Wh5au0plxSuq/Wu9X5ca7AqIGVUDcPfWsVL8=;
        b=wSX1zFtad7Jvg4euH1njr16jbL/ytetR79ryWPLP2fpg8dpB46QdvgQWYspUH8e/F5
         8FH98s8tEPTCGvlhTzVULLYrXqyWB12Z/CA399o8kIWjaD0a4YyY8Uhvc950i21E7VPM
         oKt4yt6LxaWnHxeMgvmVmot4P9I4h8ihXa8Gr/5zu+0baoAVPLKvHFygcf5SAWmZKMQA
         2+DMhVsolgSTJwu8lS/jQuYR56QXFUl09VKWi0LnSvHT45MShpyxqx1UBVbAoqJ0U+SZ
         nmlEJj3Y7Ik3d68X6G8qWwjmBaO3tsjPvfsrcLdV7aZbTGl2ajvFnlw00D94qkSJm05H
         sEzw==
X-Forwarded-Encrypted: i=1; AJvYcCXmncMyv9oED0bUQWum7Phy9K+Kn3HHpX7UMwvOYBVejK9fvlGC0RUSYLUJ5NFsqs6VvbVd8MpQpw==@kvack.org
X-Gm-Message-State: AOJu0YzE/quMoYbNFugx1wlgWrEY84fHCNsGLRx29qmtAYd4uwcCsfxK
	PDgv9mdgJ3Tpm/0J9zKO2hPPDfzrskwDnsQKNK+GSZj/nOW6R/puV0HUqUrK2b2oA5uyT1TAzhM
	grz/9549/SuEZsXvRuC/7FEpgVCRrvK2a/lU0BCQ3
X-Gm-Gg: AY/fxX7vSdHxTxfXoN8+CExkDq5l3HBnfoOterMZjiznmws18m6Ltv29ffv+AyM4ail
	OaG6hR/3PBZOYsVZ+pcW0Bqlub+Fv/kbNSfkY6TvkcViJkimEZEwiEITTxDmicCJD2BBH66Iwxj
	JwOmaKiiSf7mdWsc3A6wboy3dXNUI87be5C9LbGavAQ1IkySvxwY3FEX+m9P+eTARm7AkoyJdYm
	TnEM2mxX77UPov930FBVkQykBxIgh7rDhLV5e2C4WrxAnczfjEVHJDOEUOP1XWR5F5BjrdfXPt8
	aJzFYia8NSXk+rXzciIbVZtUlZzE
X-Received: by 2002:a05:600c:4215:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-47f7aa340e5mr625665e9.2.1768497074739; Thu, 15 Jan 2026
 09:11:14 -0800 (PST)
MIME-Version: 1.0
References: <54CB622C-0BB0-4772-A939-162D63433A00@nvidia.com>
 <20260114144824.69960-1-boudewijn@delta-utec.com> <be8c25f3-8540-6c28-e2f1-8034118ef04a@huawei.com>
In-Reply-To: <be8c25f3-8540-6c28-e2f1-8034118ef04a@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 15 Jan 2026 09:11:02 -0800
X-Gm-Features: AZwV_QgDNJo7mv6VhsYMjgpuz4Vj2i4-OZ2NhtNuBS0jngxVVfcucRn_fLiWxzM
Message-ID: <CACw3F52D8=s_uj_jRtw1J-GjAvt4c3HNMKb2sJGUjznvyAK80A@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned
 compound pages
To: Miaohe Lin <linmiaohe@huawei.com>, ziy@nvidia.com, 
	Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	nao.horiguchi@gmail.com, osalvador@suse.de, surenb@google.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dxcpwt445orc8t1no1orzbg1658i97t1
X-Rspam-User: 
X-Rspamd-Queue-Id: B52E01C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768497076-912334
X-HE-Meta: U2FsdGVkX19FmxuoHQaMOBe831fi/0oOIScDMwsry5kjfnHzggHjCsfZlGCQullJjW06eAsqkEdPrnqilhnCrcn8t6kdC653tSeoi94OsaO90cB0xSakypqHyzNlEL5xJexDXuUDx1wuZHYf4IpP7NmLo9HcgmBambWWyOVnUsrKvGZb1OoD+8xMOxi0goUuQSw2tL+IFrccZ95PytagM/EhBHhE8oi3wFK7tMpZ7Mf4vJx+1RyA7IBMQIoMae1+Vln3C6nKPtUXasrs1qoUxNI9+IQ6lnwC3MQYTmSpV85tJjW31kn9mn2MrubwflmWG+wGbk7xrgM96ysDSam1POyptsRLiM0f+M0LRqv1Qj/UqWxU5cRtfn6WgRuJ78toopV1bh3wQPSETOcVuI3WvEw941PB4Jvl1ew50J1FxnBcIBc0nnXf1WXmqeRksWhrjxoRU2nsji2XOQkj8EDhGcNhQ2dCGylfomsUz0GsEhfrPI8bXCjyBzjt/QecJ1iQwMDD559RWtlkpYUE1qLJ9sjxxvZ2n1YyGbnb4LJMfgO2ZjHzTq9105aNcATrOTZKBRAdv7LfFQT8W4CM1RzY21wJMNCLfn7TJpuH0u2wRd8hebKkdHwbgfwQr7luOv/PI1u8tsqKh34+SK26Ga0WI3NLXIwMve5YaRc8y9g4ZyNF2HEnBzYAIu2MNOHSOzd/+ilI916rOxSCqrdrqeNy9Ws9p8EGv1LYVcA9TEtCaFhBMNB0HHASHi0JZmhDzkwJrfIYWZ9aEZevgJDViFCKsPg5uWmQauJzTzPA3kVklCR5yguEqYEuw9kFiEt2RzG6eowoN5Ar7DqcMJJCK6T29qPVAWBWSgQVagqYV19rYuh3Ij99K4fFdNneUh/75e74n+aCJoY64mG2EsaPI0Ma5G26K5j1tf6vhiJbygTh0qkN16mQKv21LT51YFvLQ16zz+MQdhm1RP0OhbXWJvP
 Q9OhsKOj
 GTKvA30mkIL8bu5M0xkdtrTqmbuWEmySvmHNQo1HciuS4QJjJjWnPl7WdyUPS54pFHODTxFc+Pev2HpdbXmkVqdAS12aMKLSLMaM6lUTrSIzBZw2PGGSsHGnIhzr6329PRmvlO0j5KmDsIox/JPSN5u3veCsELkahcWn0rM5NCwt6o5PIr7+86vTyTLSldC8RvS6vCyvp0oppY5TG81+3qU1cGX3dcgphMI9hoGLqbJeGLIOK+oPIdomPFl8wgu1XLq/PrHnw9NAX71GWrzgL8WNZAe6ovYfEyLi3nhlmlDbH2fMumdQX0lYMBc6AyODixtnhi9VjEUOpsgk8O06VGssrIaJhAPiL6TAbmmQcLiX7SootL8JU/4p0yAdNk+XkiZXAatg05rGB4TIstQKedyd27a52VZ2ZJarIJb+soO4A5t0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:55=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/1/14 22:48, Boudewijn van der Heide wrote:
> >>> free_pages_prepare() only handles poisoned order-0 pages.
> >>> In memory_failure() (hard offline), pages
> >>> are poisoned before attempting to split huge pages. If the split fail=
s,
> >>> the page remains a compound (order > 0) but is already poisoned. Howe=
ver,
> >>> Soft-offline pages are always poisoned as order-0 after migration, so
> >>> they are unaffected.
> >>>
> >>> The '!order' check causes these poisoned compound pages to skip
> >>> poison handling, leaving them in the buddy allocator.
> >>>
> >>> Worst case, a poisoned compound page could be reallocated,
> >>> potentially leading to crashes, silent data corruption,
> >>> or unwanted memory containment actions before the poison bit is detec=
ted.
> >>>
> >>> This patch removes the '&& !order' restriction. Cleanup functions in =
the
> >>> poison-handling block correctly handle non-zero order pages, making
> >>> this change safe.
> >
> >> This is not a fix. IIUC, for >0 order free pages, memory failure uses
> >> take_page_off_buddy() in a different code path.
> >>
> >
> > Thanks again for the quick response and clarification!
> >>From my understanding,
> > you correctly noted that take_page_off_buddy() handles already-free pag=
es,
> > removing them from the buddy lists and setting SetPageHWPoisonTakenOff(=
).
> > This prevents those pages from re-entering the buddy allocator.
>
> Thanks both.
>
> >
> > My concern is about in-use THP-backed compound pages:
> > 1. A compound page is in use.
> > 2. memory_failure() marks it poisoned (TestSetPageHWPoison).
> > 3. try_to_split_thp_page() fails.
> > 4. The process using the THP may be killed;
> >         the page remains compound and poisoned.
> > 5. Later, when the page is finally freed, it reaches free_pages_prepare=
();
> >         'take_page_off_buddy()' is not invoked in this path.

I agree that Boudewijn's concern is valid when try_to_split_thp_page() fail=
s.

However, I don't think the fix here really works. For a compound / THP
page, memory-failure() sets PG_HWPoison flag on the exact subpage
within the compound page. I believe the page in free_pages_prepare()
is almost going to be (if no always) the head of the compound page. So
removing "!order" won't really help unless the head of the THP page
happens to be HWPoison.

>
> Yes, this is also a problematic scenario for Hugetlb HugePage. And Jiaqi =
works on
> it now [1]. I think Jiaqi's patches might apply to THP scenario too. Add =
@Jiaqi to
> verify this.

Yep, I think my work will also help solve the concern when
try_to_split_thp_page() fails.

>
> [1]: https://lore.kernel.org/all/20260112004923.888429-1-jiaqiyan@google.=
com/
>
> Thanks.
> .

