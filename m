Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8A0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5DA6B00A0; Tue,  7 Jul 2026 07:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8760A6B00A1; Tue,  7 Jul 2026 07:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FDC6B00A2; Tue,  7 Jul 2026 07:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA3B6B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:08:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEBB61203F4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:27 +0000 (UTC)
X-FDA: 84961707054.19.F4984D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D9B012000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4ROI35J;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783422505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dk96b/I3wsJF+jNGoexw3eefcHnup28pG3QDLNzVHEE=;
	b=x+vnc55cpyPO43d3N/jNlZsIfKPooE+LYmoGOaqeO7zyCdnsHIfxQ3ckTfUkpJUO6PT6Q+
	W1OHkY5dhbtsRI06dg1xoKWYcWxmfHVfDxlGOf2Pye/04ZPKen0/SSQ+n7WINwrtuBqp/n
	oB8qNeycYqSJYg3GxvwLA/7JYdhvmMU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4ROI35J;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783422505;
	b=wlvMVA8We5zagdJOBEgOlrY+53vGDqq0sBDP4qKO1vUg2deIbKZOI50NB7GFS/kxmkPrFE
	WUOldzQNM4hDjrCmautGkFv8cEXURaYHylQEPWJF85gGNV/czXyKd8w3imzvjLRVDpYsE2
	2ie6dR2pcHonPCeSHs5rQd7EAjPYNzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D14C401CA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E423F1F00A3A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783422504;
	bh=Dk96b/I3wsJF+jNGoexw3eefcHnup28pG3QDLNzVHEE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m4ROI35J0wOQazaIjxM4Sk+fJivp2OGzJixk4Vp+G26bHDOBGcQc5S0LRy7pmwiyX
	 aXmllAPgTq0wGzCCagT1Y7OYJ2a2izNtQnFv/q6VlHcZGahAyc8TsrS2xQWFKc28Ks
	 JUPHHlrWKB6E5UTJAnq9/PKytwRO4kacVgbogcjHoJvPhVEWA6UAx2AaRaD7JqSP/s
	 +PY9KiqK0H6AeIxrQWVLOtIiRw3abWnQ3usSelF0D+5WU0IgTIOw7U4mMwskbshH/2
	 sr/7HHC3N5o91uDkVT6QdEZMB+x9Ar0U+XLpsIgOnBKamIDp6JZb38O9Uanbf5L4CR
	 X4480j4eK4HKg==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c2cce930cso43206421cf.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 04:08:24 -0700 (PDT)
X-Gm-Message-State: AOJu0YztdU1ybjSm++jY4yZw5VvI9o4oIxT0R2Az9U/azbBaFhtQZli9
	lYegryUzz7s9mj+OmL3t5AynmQ+Y48Q0TcVe6OybY7UZeIh27qhN3bwicr0VjTUylWgyKLpjUmf
	L6G6ACjg8Yf1Ipsu2/kn+r1/UnY/sy5Q=
X-Received: by 2002:a05:620a:2629:b0:92e:5444:9274 with SMTP id
 af79cd13be357-92ebb571b03mr518535985a.30.1783422504300; Tue, 07 Jul 2026
 04:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260701235955.36126-1-baohua@kernel.org> <20260701235955.36126-3-baohua@kernel.org>
 <3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org>
In-Reply-To: <3a185a5d-2f2c-4e9d-9cd9-8bdb236dfc5c@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Jul 2026 19:08:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zGBK7ndTyFnzdzw0tuwaQwbCChVBdkC4E1YBE0NwVHcg@mail.gmail.com>
X-Gm-Features: AVVi8Cc5af3cgXAyx-CYU-csdAhwAVD3iMjoaFrXDwmVboib6XdZxLv1lUXSb1Q
Message-ID: <CAGsJ_4zGBK7ndTyFnzdzw0tuwaQwbCChVBdkC4E1YBE0NwVHcg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org, 
	jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9B012000A
X-Stat-Signature: orasx81tcqccdq1kjqep7odmrwfqgrye
X-HE-Tag: 1783422505-878364
X-HE-Meta: U2FsdGVkX1+xSUXpAUDm7UHSM90E3N7vt1WX+0/axhhGBr9sHuUMkzzXflsXRGny/0YaJcqAYkUuMRr0oALSsPLffDXsxUDlc6b7aL5uotG13etqwTAEY4oPJNKp4ttabOoxGSkdCkCa0/tjtzKzXOvrQHUya/VM/Utnbn2DJZmu/PVHVMzjpQ0MAUr2A/jclVfretMlc/xieeMENBgHvJRtcHg/W6b0UN0FPL14XNAgAvZxdgpYWK3hmGWwbWGRjkS9/z5HGJ4wkG+GPHsRONhLrl5h7hnjL1eWJopUIjtKlbg5Vik2Touj7glSRWKGc8MXXn8dc8nXLbISj+4+1L/y4WQldVwNUCXCfv/7b2sOJV6NlV9P30wuUI/mmEav21RZp9da1rZ7K201YsgLMtU/ZsthbFdBz8IwrkoEJ++kx60U+f32vVIIoBmKsiYqpDkYLQ8Mo1VI5D/34HKQZUJHMI6RxK8jW8m2eLbO0oJ9qgDKGSmocLJESI+wg4X9975TzJAYCvU0hZNF9En5K6kk3PKKGG1A73oP8yIqkmaXQvCypYJ+H7fSlmjEjTgeIJTU4VpnIuog5cmmhL467u9YxTKtum3VolXJjf6r8xjdZ4MrYcOCRCCQlMxi4UKhaNfBwjVzkz9z8YDxsqlU5Vl6JVQU8lvCYLfs7D1bLLt7CkCC/GLosyvaBE4IsRGGsXNpO0UQxWSqS9hdBtD8NVh97TeUrSytA0gdebmXBSKKIHHvGa2dEqFGBAMZ5t3iTF41Y9cUhjXLK/CSZmi+4pTcJSRImcqVW0IM1CLvdo460KKFEoZqVoy3o3oiQO/Ftw1JsPqIN1j5sRSHRnsmTsQs5xkWVVsqepbjzsYO4Lzwly1Q7aED5y9tiG3o0rBkSBF15Yoqg55QWCu/8vqY/UjpmerwKKCjMcr8Rjg0l6b31USAZg71BpoeMOHNVQdnSVRF19cOT0NQrPeBsui
 NNvzEVzS
 N0DwOguG/lKm09RLxd4NQjAPYx7jNisgBaE0cI7KPTznhJiG+yELrBA6I/RVJ7m/rTWKDiQSrfxnNU9Ght1ZtcnSzcIzLzPlsGIktuJanH07nYd6LM1WSOImfb/uD43qPzKxsa3FHD67k+W5GmNNmUtZ7WzL/V4lRDBvFhgxsqseRVd2revaJxpr+u5WBoO5COzQwTPSi6hjCFjkuiZL6qCrbZilxs4pBLWGeRqarsyGHhjE50Kc7woY8+tv6xtPxBSH/SVp+hpqt5CkTAudRfjWrxTiGtu04jZFcCyWJmnB+piOtPZP9GDXcwhc4knfANGfxxunkhSN2+/c6BT4S6TUrsQpFXYXMhFPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 4:14=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > The "we just allocated them without exposing them to the swapcache"
> > case no longer exists, as Kairui has routed synchronous I/O through
> > the swapcache as well in his series "unify swapin use swap cache and
> > cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> > in this path, since at least two references are held (base ref plus
> > swapcache). Remove the folio_ref_count()=3D=3D1 check and update the
> > comment accordingly.
>
> Sashiko points out two minor things (one flagged as medium, lol, sure sur=
e).
>
> Here, you can clarify that folio_ref_count()=3D=3D1 is true for freshly a=
llocated
> pages (due to the KSM check) in which case exclusive=3Dtrue already.

Hi Andrew,

I saw that you've queued this in mm-new. Thanks very much for that!

Would you mind adding the following sentences to the end of the changelog?

The ksm_might_need_to_copy() check may allocate a fresh folio with
folio_ref_count() =3D=3D 1. Along that path, exclusive has already been
set to true, so the folio can still be reused correctly.

Best Regards
Barry

