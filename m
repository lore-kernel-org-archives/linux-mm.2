Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC24CF648B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 23:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6186B0027; Wed, 19 Nov 2025 18:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD306B008A; Wed, 19 Nov 2025 18:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3026B0098; Wed, 19 Nov 2025 18:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF0CE6B0027
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:18:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C87EC0602
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:18:48 +0000 (UTC)
X-FDA: 84128923536.25.8015C8A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 443628000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:18:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VQWjG8jq;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763594326;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EYaTq04pxx2em+tWLHC+QVEyZDqapxzz1bUuYhfcG8=;
	b=BhU/4ahTUKBZ2h5qoaXkxTrdAmM+gpNQJsjXGIz3ewShMwNE86BbrRxnG8YxxbxJtQnh1K
	zOq1Ry0Txb91ZUFauIhMke74uBssd9n4CQC4ZDFQMCcrupgZvoivB7M0/clRb/CYY9DH76
	PaZSbYVTRMlr86k93geCTnVdBPpSVYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763594326; a=rsa-sha256;
	cv=none;
	b=XCnX1GE2Q+l2dbC6lOfSDbWFGtbwulcgUc5WhdDuo6E30gfgqEHGj4qgN6H81GHe9D9qRf
	+bW38K+3s9u1oy1Czx0grQM+q+oP8mXhtD63e8iUoTxmy90kx13Xa1MwYyy5VfLwOOlhRI
	cu6TZCr3wOUUpHUef00jZgS2jnCoi90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VQWjG8jq;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so355056a12.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763594324; x=1764199124; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EYaTq04pxx2em+tWLHC+QVEyZDqapxzz1bUuYhfcG8=;
        b=VQWjG8jqmSBpsjeBIcWrfEA6x01uFYld8pJRzlZKrqhzb1TjSu0jeh2eNZpGi5Iexl
         pMUQN7ed6Uvthewq9FQqXIOn9cnT+Z+65MDJMe789A5XeqKSKxLIfXL/y9PBcNga9+2F
         K48us1x2ODW2O1P/SmlbOjp2koWChMCOIoHOXnK3NhG2vcwHEcX9FLNwV5HD6lCbA7+1
         IsJBldGzcbfSnO/X+mMQKGydSEHtOQu8jVbBGovG6FBu2FMva16HhUmnUCOFje7MsC3p
         +QZwPh06I4xy+LsgjTUVgORJjTeaKodB8GS/65K9ZzT2U+jy4PD8+NpALavoMZxRtJrT
         YI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763594324; x=1764199124;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9EYaTq04pxx2em+tWLHC+QVEyZDqapxzz1bUuYhfcG8=;
        b=aM6g8Y6Imzo/qMu04hYHinHKCwYj2E85sCvKTEJwMIUv7Y1CZY9fUiER5JWm7AhSfz
         cOyrgtH7ZP7iLTGTsYi37/2C1jnuASv/KxHGTWltpkDU+dQH4BLUCVKJbZb997N2/Fhq
         a+KABSZHcgdsTZJtKkVc5DyQKPxaEyboIv77iUE+mYihOB7exC2/bdYao8kdVA9TAr0+
         pG5zAaLsoAujMpVD9UKdSpQOPpRSqNoYWKWasaRKiRj8aKqIoDR0Cgk40CJ8xuqYR7XB
         gUCorkNgC/EDaavnbXVhEG6a+c12qpITuSRsxmE5wCnYCH1a1eDTbBst1rJizFoLAJRH
         r4kA==
X-Forwarded-Encrypted: i=1; AJvYcCVdcLta8cxL1D0KOYcYcbq9IiJ6dIwGAICLQCLJp7JaGDQ28qmFFZlMfIeQyd3lzXte6ryo667Dbw==@kvack.org
X-Gm-Message-State: AOJu0YzKLZr6W/LlbhsTUAI8s7Z4A8sHt3HmZvbyW8Hi8GS30EbZNj+Z
	PLASvglN5CCnrGsgg/J+91lSxauI/OCbqlz97opIuHsp63ZSn8oVDNMP
X-Gm-Gg: ASbGnctmwm3KGMXIw/ecK2hdZ23fJo9aR9ACKZSgMlrDQuS/mJTZrXRB4O0DIrykzsL
	1GTN/We7xGg4Wiw5oq5C/Oi8F/C0BNcCJQ4zTxHpTyYvinoMd+R7MFdkaJALjN3ZYuqyqosxWBQ
	bdrwKrEEUWX2eT1KvtvPK7jE5LkVW8cvah9Cp7TMz/OtiltGOIGvUFeOHgV3JK8DSdRkryCVk+a
	u1MKRKbxMawnT7T7z2WERV8pRwy7ls+lvA3JPuVZKMjl93xzAQBVr702LwRagYBL+tHzRWRtxQs
	dXZNabVh7PBPVuCXc5OchjcCLE6RlPLe4WbPdEGMHRXy7IjpGT/Ae9R1f1DIGjo/VUlcbnkbDU7
	2sAvQM8osqAL2cMjgQ9PItRRjihjgbTP4YmyRSfk3bivM7LxhSrVooOWZWKCPuj77aURH5PIsxo
	diHtmZ6S3vfoW2XA==
X-Google-Smtp-Source: AGHT+IGI0GU21OMn5soG8qAJy7MLT9UuRh/S+6lqQCxYMx0vV4klIgtWKPLqbzRYpnnPguB43plIIQ==
X-Received: by 2002:a05:6402:1472:b0:640:eea7:c95b with SMTP id 4fb4d7f45d1cf-645363c6721mr1018915a12.6.1763594324328;
        Wed, 19 Nov 2025 15:18:44 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363b62cesm682240a12.13.2025.11.19.15.18.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 15:18:43 -0800 (PST)
Date: Wed, 19 Nov 2025 23:18:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119231843.u7tvwxdoxwqzvxyq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
 <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 443628000D
X-Stat-Signature: ourzp8u8hwgwkkxmyrkn6jizmbycig31
X-HE-Tag: 1763594326-888675
X-HE-Meta: U2FsdGVkX1/Mw+Z/CTWWdMpyUNHPJEYMF3HvEjqyp07iL30hRC9bcqqn71yeP+b56QQYDXbFJXuqwIRlfkNkxwzAFuKFbvoLL//esLuUp5568QRLzD2QqJumTpkFKJZ9YuaNU9vUhLeTFX9yALCzEgcwxIe/IZfw3ZEWFovjnZmdIJgD6B24DI0w4k4vdJGK36OjdcuXE8LxDK4M5B7DWyumLf/ybzxSMYPMzyQZExLuSYZ8OmVJBltTOEanXmiR2NtYc19ucNHN6iFECS2XoXAqIVTJaVD1Msrrm+QZ1lIhM1t9R1Q7wKN+6HJhzLH12N0d2X+dplKb6cNc5upbf4/Uprs7nS5LB6gzhp05L5fWEAhB8oolBlWK0TWdlRKiZiK26mqQGfaiJ/sNsivPnFAu2qLMjFfGFDda9cfXnjmXCfqhuNFceOdNtpqBW8cfLMaNaKchLU9ijM9duDmesObShbQjPquqszUnYMrsLWVvTyjEoSrV+Ipv566k06wMQ2TJ8+eLsIRjNH8gsMHkYkIUjrjl69x0vzzfaJmlWSdoyTaZQ1gEM9hWJUg6l2uuZ2Pxp4E9AjhKT6ohdJNaIkdrRTD2YLK7+Z3mUSYKk+8I8u5VxDK3Is87snG1aTBeTmyNVunNg4pFStA1djGn4yWKSlhKOq3eVFUBhP5WgAAEuQoO9CIY/s2jE7VKboLcW57dgT8XNjuGTZco+jb3pFChGJXr/l+JWAh/z9ZOrl654ZyVDx7wDyqWxSQs9AiZbL7ArovbaZH40PHfm1eitHPGM8uiBD0U+7uUDjIIfdooQ6+dRQTFrncRxkjNScP/1Mp1Dif1KlAabBGkIHEsJeupgWXm0o3buAIrgRCjByIm0/wAIX5NoDX8+uhDpXxwsrRrJdTHDPISXliMxE9J9qDEXIViafyKE/EfunW9BgyEGnIrQUcokspiWdiLctAM+eZV59se7WAJWrbeYo0
 N4P3qPKx
 kmzYF4YRrEfNqX9m/OXJQ+7+LFj/OVjR4fPqUxmpdb8QJfqYnisOQ+gibYgiMIqAdY7FS2eOIS7+FTHNNx0/fx2cAS3iKdIBEBTSncmRRooH54YXlTb9gycnU1IQ+COF0P/hDFgizyJcE57UfA6u9reElBJ37oaIl8Tv8HkLgszjvoyGpneLsti51FW1vLQj10T+2O4nQwvP/98rskbSEUNqGbNzHk4W7CX9XR/ObPeiaN0tFF+U1sHnRgcp/9HZUsApKXkdCDMI2DQdQhEPnlTlYCJUBFcdlq91ByG8I5wyxT+PYA/GuwW4Z4xjRYn6b7vA/eaY4UCbZhkmJIV8BCjbs2fH8m0IhN1ZgjaLz1I+PNg6a2tmskfobptZMcB+U+sK1EC/mM7WwTURSmuvMYMZI/r6F9PbxO2inGNlciFVkn9SvWrNS4I3C/4kTsCptMRLC6HY029AR2p8s2dARfgtNKfY1vHBJ8t9eOhzF5GMwRTPeJod2QsCVUTZqYnzdPiVbQpi/cCrrj4t3b+YfMNQwa5YEa9huteTLY+zXBnd2Bp/mjAlm7aYecLjwryJ7wpr1bnTbO0jowDqOQN+hNJ08XvrgDdna/qVXJRtC0aPtVYOd+jkl5dJaKOQQOTd72oHJIwA2w2fc99SVrIzHNPMbXvmmQCxB1gxSqiMLK3HiB4y5NO6cuRYxryTyq9Oag4d4Lsqj611ydiPZZHSPBDJiPEjBw5RFHU0GmLCCbjODmjb/WRhkiJeWpNbvI98ZWOBV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:46:14PM +0100, David Hildenbrand (Red Hat) wrote:
>On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>> > > Given folio_test_swapcache() might have false positives,
>> > > I assume we'd need a
>> > > 
>> > > 	folio_test_swapbacked() && folio_test_swapcache(folio)
>> > > 
>> > > To detect large large shmem folios in the swapcache in all cases here.
>> > > 
>> > > Something like the following would hopefully do:
>> > > 
>> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > index 2f2a521e5d683..57aab66bedbea 100644
>> > > --- a/mm/huge_memory.c
>> > > +++ b/mm/huge_memory.c
>> > > @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>> > >           return ret;
>> > >    }
>> > >    +static bool folio_test_shmem_swapcache(struct folio *folio)
>> > > +{
>> > > +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>> > > +       /* These folios do not have folio->mapping set. */
>> > > +       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
>> > > +}
>> > > +
>> > >    bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> > >                   bool warns)
>> > >    {
>> > > @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> > >                                   "Cannot split to order-1 folio");
>> > >                   if (new_order == 1)
>> > >                           return false;
>> > > +       } else if (folio_test_shmem_swapcache(folio)) {
>> > > +               /* TODO: support shmem folios that are in the swapcache. */
>> > > +               return false;
>> > 
>> > With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>> > Can s390_wiggle_split_folio() such folios?
>> 
>> [noting that s390_wiggle_split_folio() was just one caller where I new
>> the return value differs. I suspect there might be more.]
>> 
>> I am still not clear on that one.
>> 
>> s390x obtains the folio while walking the page tables. In case it gets
>> -EBUSY it simply retries to obtain the folio from the page tables.
>> 
>> So assuming there was concurrent truncation and we returned -EBUSY, it
>> would just retry walking the page tables (trigger a fault to map a
>> folio) and retry with that one.
>> 
>> I would assume that the shmem folio in the swapcache could never have
>> worked before, and that there is no way to make progress really.
>> 
>> In other words: do we know how we can end up with a shmem folio that is
>> in the swapcache and does not have folio->mapping set?
>> 
>> Could that think still be mapped into the page tables? (I hope not, but
>> right now I am confused how that can happen )
>> 
>
>Ah, my memory comes back.
>
>vmscan triggers shmem_writeout() after unmapping the folio and after making sure that there are no unexpected folio references.
>
>shmem_writeout() will do the shmem_delete_from_page_cache() where we set folio->mapping = NULL.
>
>So anything walking the page tables (like s390x) could never find it.
>
>
>Such shmem folios really cannot get split right now until we either reclaimed them (-> freed) or until shmem_swapin_folio() re-obtained them from the swapcache to re-add them to the swapcache through shmem_add_to_page_cache().
>
>So maybe we can just make our life easy and just keep returning -EBUSY for this scenario for the time being?
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 2f2a521e5d683..5ce86882b2727 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>        if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>                return -EINVAL;
>+       /*
>+        * Folios that just got truncated cannot get split. Signal to the
>+        * caller that there was a race.
>+        *
>+        * TODO: this will also currently refuse shmem folios that are in
>+        * the swapcache.
>+        */
>+       if (!is_anon && !folio->mapping)
>+               return -EBUSY;
>+
>        if (new_order >= folio_order(folio))
>                return -EINVAL;
>@@ -3659,17 +3669,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>                gfp_t gfp;
>                mapping = folio->mapping;
>-
>-               /* Truncated ? */
>-               /*
>-                * TODO: add support for large shmem folio in swap cache.
>-                * When shmem is in swap cache, mapping is NULL and
>-                * folio_test_swapcache() is true.
>-                */
>-               if (!mapping) {
>-                       ret = -EBUSY;
>-                       goto out;
>-               }
>+               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>                min_order = mapping_min_folio_order(folio->mapping);
>                if (new_order < min_order) {
>

Thanks, will prepare a v2 with this.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

