Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC193C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 20:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39096B0088; Wed, 26 Aug 2026 16:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B896B008A; Wed, 26 Aug 2026 16:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B7E6B008C; Wed, 26 Aug 2026 16:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4816B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:43:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D456C40226
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:42:59 +0000 (UTC)
X-FDA: 85144594878.17.6AB4261
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id EE3B820002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:42:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bi3JQf05;
	spf=pass (imf13.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787776977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVdZ188LNtx3TZKK84+iX7t8VYh9/znoneRN86I6/xw=;
	b=XAVTtJIhYjkxl1rXNv4LWd3bC9z2Loa/a0ihERVLqolpCqj9sEOvs+Nas70dRY43Ixll1M
	4dmPD/aGWFPuegOclGSocaUo44laTixB9aBmSVr1/k8Dqly+9kYSX4Hru9mAYfm+KscEnb
	toldtOa3FTid/Dwphbe6u8RIkAlPRT4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787776977;
	b=7fi9f5COdFCYvDjDprgxhXRaZssOrGLDKBahVmtxy+rztIBdKOTJV2GZHG0UkfiejTjEDV
	0Raa13whbc2z2uPowFgTXjRVqwX/+Nw8HkIQewjEF98Q16I8uhB0uNteFvDTZpq29rjew2
	CN457oyLhc2FBcFl1s3XgMYU3SvfcwU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bi3JQf05;
	spf=pass (imf13.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d6d28aa26cso10299665ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:42:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787776977; cv=none;
        d=google.com; s=arc-20260327;
        b=SAFLXqYcBwDluocCBz6Wl+i7hRmnci9Yvncj0aL7RHvI8xPY8LZH8fdTr5WuQxUYyR
         GSTTjifjnB4qdUIandflEZ5Gc9tI6++SIK9e1iDR8cQmJBDS3EqqtIwrbD/Qptk6LAtM
         uVnvZZ/YQDLs93k/rt24dBufQElMt711xjWWoIRdO8wY5SI7rkQfJwkY6CZin1dWTqDX
         GyWoC4mQoNTCOHrChHPwMRkrkibOJPoonXpk+LxVWtKsZ9njSfAjstBNXTvaxLKvYWmr
         nqzHaDgvv0+cdVx3jeKYuPLskgpokQtYzErOqOM8cJh6tAZdeSYNJf/65uh2bV535olf
         sKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GVdZ188LNtx3TZKK84+iX7t8VYh9/znoneRN86I6/xw=;
        fh=MO+dJ0/mzINbi9zh9zQsamCo+PPo238nqrc366ljc8U=;
        b=eyRlKcgMlyqdTADo3oXLcTIQ6E2VSVnveYNM8C40JA7WKzfJVA9HpzZdn7c7Syl2l+
         7uNhdS0aOlIWuP30EBAolOlWn+nz8akxWAtfwDVVzEHMpX40DzKgO6cdU64Bk8ifZ/Ac
         dSTHu5ps5cbnVafpHta5ZndD93z3xHG+0qYOtzpLm5yyFSnvX2tK8hxYTcHBS2nxxMga
         lgr7jIctzFdowBxU3Ct6thvES/OZFQQheJXeM18sSylTmD69ZdVtx41IM9wPRHlCsYn8
         kK+cqmWR8GmfHqrmhvfOzQMprH6pwvVjg/IlJALN2IlI2GJ4e+Gs/Uj3hQra2NouGDWg
         FAAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787776977; x=1788381777; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GVdZ188LNtx3TZKK84+iX7t8VYh9/znoneRN86I6/xw=;
        b=Bi3JQf05d0dVJRmnyG0ksi41Kj3Tt6GDmS/SO2+KZZUohEfWuiuiwTcfAOutikdfjz
         sy8QvrhYoi01lxtRgxpOuWcAidAtTKV/vIIWmsj01yGABRSYbc/mpG/J5ouPES9Dr9iq
         NWykPfEpGTInCpyFcAC4ANSbSOaJ+OdUGmuQRxZsbCZh4lEwPoGBW7lUQeePrsyb3Gd+
         tBfW2v2nLNV6HJQ5sYfyqlPiXOsAAgvid4rcSryBWVvDVu+kEMRDkNIBTpNwrXp99POC
         evyYTjSYbdygwcIbdxgeU9U22Udv1K73/jbGrts8evTL2gdA6R38Ndb+2JX3JuPV3wC4
         +3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787776977; x=1788381777;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GVdZ188LNtx3TZKK84+iX7t8VYh9/znoneRN86I6/xw=;
        b=d0zRPvBpt2PPjc9vhRLCigrtWqBaAwh0iTWiYWSOqBroOGmhuNLIgdkIyPcybfDmkP
         jzpj3vEx/C08DEuRI3DME6gOMg155E0Q8nRKIzQ8ISPB1vchZeVW4hZgHfww6WRull8g
         Ff17XTQKbZlOBuCyUeMk29OlWkEhw5jse+jRF5LR5Rzj7uksnNUhfrEXom7/9gXJMMTB
         UVgxodiyHyTGA7E6fpN6OaH+QjpFxcMPflKf+vmrEHy2fmzIvN/aMenHUkwKCV+4TNCr
         5hyhJUIICKdlI/zt8gAfa0513/23/1+tVJ/6ruIramDptg2Q1cKACFNp1liOuglzpN8r
         eMbg==
X-Forwarded-Encrypted: i=1; AHgh+RoRS4G0+1xfO5T7xR4DI8m9VXQZpvAjeCsJfiBikVo0zQbYc9VYZWYM/Q+AEur+Rkc6Y8BI3aKHZA==@kvack.org
X-Gm-Message-State: AFuF++knjKraNOBC4S+CCoeuj8+4Ad04Jf3Fd4mHoOm9j/LjqOjdV+BQ
	tdZCvT8KQVtNzRWX+VsOW+f71TPHj+5RIeD1crKovwdfweEaPT84/bWMJ91E7J4DtrQKon/+JVX
	S8nGDQRX4UFPGEC1QDo75pf1Izc0k91M=
X-Gm-Gg: AR+sD11OW225k4i1YmadcnKqP/97PCSYdm4Ny7LI/+M9cL+obGepZjtbMc/RHLsCPXQ
	WDTxJkZo29VQjvlPegcpVLNWR+0umu0M49iUaWDaPZPacyI8ShkV91kt/zJxJ9t1cegVePrc0GQ
	Ydsm08fOWd4WIM+cApxyKKP6XSROlCXPzmG+S+/IB0ml2pQOJtO+AaSZsMcoeDY99bOP1F+yzhJ
	GChyMfiF7XiFd5XMUgfZvzWu4i6B/KE0GZyPgQpC74WyDyDayASA/ZOIQRxHjO51UwcrWDfWK9p
	wt86wxsb89EsBcVFCnc+lyuCI4EDPNd7YBQs/ocAsffspCeqAX/aeX3FLCW8hbNFiZ/AZYZ8cAg
	57Q==
X-Received: by 2002:a17:903:46c5:b0:2c8:f34c:82c0 with SMTP id
 d9443c01a7336-2d707a5d1b9mr183703255ad.2.1787776976607; Wed, 26 Aug 2026
 13:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260826061300.14038-1-anshumantewari123@gmail.com> <cfe22f1a-2ac9-48dc-a2c6-4369e45a852b@kernel.org>
In-Reply-To: <cfe22f1a-2ac9-48dc-a2c6-4369e45a852b@kernel.org>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Thu, 27 Aug 2026 02:12:44 +0530
X-Gm-Features: AcwNN1WRjnb4FrvbNG305N6dcYNUZlWJ5mcojcAGl8FuFaVujFN1h0WcgNdVL4A
Message-ID: <CAJqi8kLqxjX5HjxH6e7seX1Tyb6NhqFReMpCNKR7KTpaFGiszA@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE3B820002
X-Stat-Signature: dyrdgh53enjpt1591kn61s89g949obru
X-HE-Tag: 1787776977-800545
X-HE-Meta: U2FsdGVkX1/zyHYZ+McDwxg/0fP+Agef+2O4qsfa99yJvALXz93zonE0Za7FXLbHtnKD2GBwWJHsVFXrNVY30IkAX0hRCgX68PfBcepkkj1b6R1Vs06CXQGFd6853SSvNTnNtW3vhjot+QxUkZ+P4grfbVwSqiON4BQ31tC3pG9+a52IJUAS1qcMrKdYkY+BJHzz2LOFbhSA74al6flgAKA787LRd2l4KCpFs9NGQ6rvaBrgdyeG7BKfzh3etBCODSaFayrKPAxFfspp/uIEzKtLDT3lk9t20xct00BxcX52uwVeTQTR4JI4nCkWW9cu/pVy6Fcf3tssGLPDz9lCawEdRtgmceS4Js2P6zKNPInYX9C2mAu70SzIoXFJ+dZWP0csh9Z8G5Q4WJBxLD/iLYIVlCUG+/ZHRuv5u0BJuptStKvom0puB/xZtM85r1yzWFRdjhJTVbFL0VaTHIkpF0s/6WKsFBTfX09EpOMQKD/lsqKomch0iOsAcQhnvwsq5+pFNwo8EIMnU3n3DoAW5/KglekW/X/2WWty9Wb+scSqn3BIpoquLmUu45nNlmYA2MwAG0osPkhPc2r2CFqhgZki2/y5aIVfyGR4VwHwmqttytOmwcEXPDE4gvFx2G8XdNa83+ykworyHt6GgI20cXfrmZZXMcesyZzADBa/YVJEkFONC36ylWg7mXBn/cah3BjiBsAycZHMjTG2NzDy07PmMvjNIUHJP/rSJgi40yXqfEENk/fUqi4FAIFCTcUbO7vRv0gjuzLeHBXgbwTbdWQHAqFKahnGDXirAZZXpAFN0jBe3ihAVQItlzA42zIUHlCa1cZNo/EeMcC59HRXMupItgKZKy9JUrDfPzdTw3z3I0miQIw5HvKeV/rSvKcmUqm7PYeud6lz2qxAWRwQAU/zW4XlCiN0lRPUcJ95VvVfmH5cj4ttBSBpo7aKRBY1CRrxk19Hedt6GQ+krHp
 ISeYieXz
 7VKnJ5nI9hFhgBcgc4cMdRIdAk3dumpRSkoK3TEuBYTt1SEs8xG1oo3iuwJ1pf1o7JJZqgFDHV/UymAomR3jh7SipQiQe/iCE9/2N4gEicRg5PBcPIxybmWl2iNEklY264eg1ul/usqkzBGiN6pr6M5wrtKiqPR2Ky/K1tB3hfEZZikxMmdvGhYaZcWyuA8TS6gtsWIXm5nYeZjsD8Ut3tX9moBeJW3PwTrkJ/hJvAQMR30pzne2M/A69LOU3pZVXe/OK2fNWvap9kbvAwaELks6Tv0AhsOJzjurlQvcQiXXQzy2bc9QsB48Y8h+79kicaHDA7FkU9k2IOA3oa4S2pxCbgNZAjHHoFVBrh1OQL2lNpYLxECkrmL9XPoySSeH6RPe9gGZ5WI0+DPLXF7gaKSlPmLkj1EP3B1s8xKJj84vWzDhObEIm9lboTgv7ZwD79EiM5sUHUE6nOqkCebzf6+vwZyIePp72KFu10Asch04KBNGmU+SgoLMX6EfpO4wtmV6uhy9x2ijsO/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, David =E2=80=94 appreciate the ack.

Anshuman

On Wed, 26 Aug 2026 at 13:08, David Hildenbrand (Arm) <david@kernel.org> wr=
ote:
>
> On 8/26/26 08:13, Anshuman wrote:
> > is_range_mapped() uses getline() to read /proc/self/maps line by
> > line, but never frees the buffer it allocates. Every exit path
> > (parse failure, match found, or reaching EOF) returns without
> > calling free(line), leaking the buffer on each call. The function
> > is called multiple times in this test, so the leak accumulates
> > across calls.
> >
> > Free line before returning.
> >
> > Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> > ---
>
> Looks good, I don't think Fixes is needed (even though called multiple ti=
mes,
> the effective waste should not be relevant on any realistic system).
>
> Thanks!
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

