Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA786CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8EF6B00D5; Thu, 21 May 2026 11:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F9F6B00D6; Thu, 21 May 2026 11:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EFD6B00D7; Thu, 21 May 2026 11:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB1A26B00D5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:16:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B39CC1C040B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:16:15 +0000 (UTC)
X-FDA: 84791777910.08.7674610
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC9B110000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:16:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p8t/Adfs";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779376573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J01o1RM4DhFoqzfk/jOeARRHWP65H1t/fZlj1q1mraw=;
	b=qHy7Xcqv5GB6prazTnG0W2W7YpOGF1Hi02PmVclJP+uJzb5V0195BamMLftJc+Bvqdkufw
	m3mqD3X6kHobqsJoCLkcdpMfHfOz8gGKTDrcRVMvbPzMQwfR5OkW6NBsfIXqDDekay+HSD
	zqbv1wcPrQVYBnL46mJsPV1jebQXgLk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p8t/Adfs";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779376573; a=rsa-sha256;
	cv=pass;
	b=POGJmxqSd7oo4ty/fWQmZU8JihlZaUbKoMbSpOtYPH/jrgszwcAOkS5FALPhe8qp+pE7u0
	LD1qwk53h8RU1YiqAqdb/Kwk6z9cVjj+B1T6AdtlIDrVenpNMns+Qlrf1CJye5GLLOp4eY
	WVfJSuqBpPXEd2vuGX0XVSS4qwfNLoE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d864c23bdso5391cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:16:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779376573; cv=none;
        d=google.com; s=arc-20240605;
        b=SC3+NbqWivWYdc5p3Rmn9OUnXyVl4xaTXvt7Bbxb/7/UXykIWhSOZAQyM5uyCF+21e
         nYq+OOvY7bVmeVJTfKJeXVgCR0Y940YWUy/HMN6r6TYCMN/yYVCS61CUy4iFjCuVJxfQ
         smrIcR0+vCwvIy/fNZjd35krCqVmDdlPUmAsBSsDqMwrBrVCcZKxcmuV6dN8WIJWfsrY
         LlXXXpHQPTLJs4p4Y7qV4li37SBXzJvLYiHpW+CK0XtF+Uyzs1O1XTKgi88xKtpIdNWO
         +nYbJseinyeNfm8NJuW3QiW3T9vYgId65ut4kGb0B7HIYakAA9WT7Uor0lQfWD1muH3q
         I+Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J01o1RM4DhFoqzfk/jOeARRHWP65H1t/fZlj1q1mraw=;
        fh=VKZ7jXiePiNhB69CVT1PMF/nVy3LTmRDqVZpi/j0XHc=;
        b=V9QNHORqTnVlX9UsFnijykkXKD+hFv/e854N9hVajGV0Tj8wVybc9nOzR5mYWwJHtY
         gadsF3hX/GZTBPKkx350srRdQuJOENtgyXj21kOnbaqqgfp9MDDcuDeKhJt1wCzIJ/LU
         dE88yWPsHWKQrkfQ1REkcmNJHzyZgOCpKEnd1UnScJBKQhflJbczQNDeczufXJxBf5UT
         fwqpNmd+rSUtvCMIE104man0aWwRvkY6psXUsm6UBOqTHoQTgcCG4IEslNYRTmflacba
         gBW2JE7HjODO1Va3NW4qeAYqq7uDFtoTs1vQEXyZHZsKalUFmlZT9PRM6FdiJu1WSGZ8
         1Bdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779376573; x=1779981373; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J01o1RM4DhFoqzfk/jOeARRHWP65H1t/fZlj1q1mraw=;
        b=p8t/Adfs97qaSRwP0XUNcbHkm4CgnX4ykZB6XI4WgWK8HO96lAEw8csBbnDCn1cq//
         ao5eOoiSsoNuIx2QlQBfnGtLO0WB/xE6nXhpzTbXPONd0WVB9LtCMHKvezKbW4/yYWCj
         K3fP5Y8kIGB5RNsVCd7i3g+8roLRBVYW0qQCyhesbUP8yER3821+5DtWzO0AhrVWLvyN
         DkP+77S/aOIJhUNrf67YRyx26jI9Ua8Nzg+GNCx+fQp9Hm9Ha1b2IO2vGAIFaUhUeRlJ
         66PfEzbRF8odzKgJi5fqGT8baRwrfovlEf95HsC3qjEi2QsI1SXjyFeRAwekCiu6Kgmt
         VN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779376573; x=1779981373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J01o1RM4DhFoqzfk/jOeARRHWP65H1t/fZlj1q1mraw=;
        b=EPqMg4HSHw+LlUutShGBVLcvU8CJZRZxJWula/UgpXYz11N4+q5T/DixIckqvymhIK
         YTazvLkD9K3jkFefmYWzd13WfIlQgAHEt0vDIzqqKXIz4BrEL9Pyijjx02HX5Nr37fGL
         HFpp2fMRcsg6NADIA+YThEwAEL7PnoDa0pjHTRkK5/LdarweK+kzvmlxPareRHsTcneo
         2WcgYsHyCziaDd7pDbTfNQc6cHXuA2z5GCAVtQc2HIYEQZ1fxlAjc3rKgYCNcehTPaVm
         L2G3W/pjFcPbIjfx/aKBrLlCsgW8Or31NoZS19nX58jFmqVzEujv9xIuj92QmWLbK8X5
         9Hvw==
X-Forwarded-Encrypted: i=1; AFNElJ/eoVeiJqa7v7mmhGBkfJ0xfdKR+iOxVvHzN2PexeeWF0bvOEuycTp6/Aa9wdKp38hvc1mgxRalGw==@kvack.org
X-Gm-Message-State: AOJu0YwbqEwp/NO5loS4R223VkUu/CGL+vYlbNDg1/mUeDtwmhGuyRz1
	4S4+2XoayEwWOhbbqAAiiTyLva5CP7fJETyW6g/TvvGHATmoq6BNYZgROHC0b8+3W2y+UJGXiCA
	RwJ2gIUBjpv0P3v87MxJo+jzgyeZc9d1hsndLn5ww
X-Gm-Gg: Acq92OGMMyYIYffzj/mV3CuQzLffLklXkRO6M7reFY5/oYYke6eF2FES6SX97FGIvD+
	Y3f27yd28HH4hGZuewOKN8MXMwTAQJxjbuInszjFgGEMZ86qQVS/RcsnS/E2uI3u19IE4B4nPRo
	V9XizF8seoOPIqeOMq8vDUkJhc+p/oR4B5eAVpqfUUiePfrnigpdQz27v9RHGtTjpK0TsdfWgRc
	oW/B2youJ53UfHorg4uVYfhZdbkEWl6/gY4K42sXu2scSuYiRPt4Yzaie7M+ApQf4gCf8ztApT8
	F9mWgT8hSpyrDMnSewB4NFF3QP4r8dLcFZ8x6+8JHMWKfy7d
X-Received: by 2002:a05:622a:8c09:b0:510:fa1:73c5 with SMTP id
 d75a77b69052e-516c549f8a7mr9981991cf.16.1779376572049; Thu, 21 May 2026
 08:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
 <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com> <0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org>
In-Reply-To: <0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 21 May 2026 08:16:01 -0700
X-Gm-Features: AVHnY4LLZAgoRouVjFmHuQ-Myz6Ah8QkFGgjPSrwBF-4h2eNKhs2Piibqid79-A
Message-ID: <CAJuCfpHPs54_hc_U9DCxtv=xikKHJMtqCEDN_4Y5aDqKhoBDnA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AC9B110000E
X-Stat-Signature: pbuciyeyykg8g9b6m3dm9rm6qjqpsu9j
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779376573-122977
X-HE-Meta: U2FsdGVkX19BzNhRPMF6d3uR86xnCRUmPNTynbXsLbb/cqGzzFE2InaAfjQGsnj3ZrHPoqQKzRIdQgFL1Ps1XVw5pnLCREHt9VGpHFdyGTabAwU9pcNoSnVQ9U2P7NXmRRhtqVGwof0ss3TaK6z4pYB2hwo7fRMTioxIt5wuUOu3s0Yjul+US3KVHVTfpNUjtYkVAH1ao1Z+whr7T6MG6/CE4UoMQ1eTPsPUKIbv4VZMY72wSp7auzKUGc5CUkb0tKMmtrlSDmuRhHBL3ohIzt8uDXGJmdStdCG4yZ/r/MJ6I9hyK4X4xqN8uFsZgSrZCKQ+SsOYRgzlzvv31degrgurcgmqiAtUrPPGdnMN1RbP1QTdI68QmNnDFwMfYAlpH+SRos57/gTaU9sOQ4Auk/4zZRjM8RJQkON5f0b9qrVgPm+ELNnBp4PRjjDFHV4TPFwbNFCDwaOcrZQaVhnjxMzzofD/OQEVK9w89+JbPiGx916XIaYQVE1ejRlPQV0ZuWFAz1xpj30M1yAd3z7PhmTBB2dXhNo+mIYKG+jDGoNW/pT8+wPwMwInYOZ+Oih8MoslULvfXg5E0WEl1JAp5K141DI8xF1kQqfRSMuPiH73F5PQxuUDbEF0CF0A4ghoEwZ74x9vNVk1YqgUWwiXOK49gXa0p2Zr9cz7kJ/dZboh0l8vx80Zuka094noFwcbTZDG4x1f2fqwfuapocN0zNgteSPMfMVnMY6awKNgr032AnWqN2oNwxiS5XBoY4hoQtn+fHNzUlmCgyaKu88xItPwE4kDsfejIRsLZRMXk53NhBvvhdc4Ik4kRzWdE07FE2Img0eE7nB+1CzDVikQTA5eHjyCDMwmp1ppUH1/+YpXRAhjDIqitklJc3cOsVOdsL0qv43HBN/H+Umfh7EazKF66Ur3FyRC3NKRm+g65jiKjv1pvCYIVXW5dcy8IuWQWWENDsCtQpiY0LoKd+0
 9pIoYNPk
 gf+X3fgzQpGIDirdMORbLjEkziHiOY/tSKY3BBvLMAjgIhOU6HJpOgCfQtPkBOs6TkDH6XlZ3lLc74o9hJuWQwMtBheKnMKdaMWmj4B0wAu+/by5CX43s+0jHPT/zxguDjcjEpPySDtKe6OOv8EH9aNrlQmDgnWEKW8fiyrNNmFoZIESiKzuU/WJFHwlKHgh9kiUAlKtOlFpcvE2mKKDjkbmos0pUPXm0UfyUwHjx3fxz9FSbhN94DGY0yWS4FhV7SlIxhjq8Celbe9hgXv2DgsMut+wU/NygT4YtXIE6c9Rk7/Bf4mr8m4pg3ZvPWbrIku6nTjjTynVAOn6jwaUuc5xapAueyLxQBWN5t2sbjOIy3f85txns3lfQWoCvLmGIJsZgbqB/9IyBa/cHNEJ0KbkNZW8k5QS8/VoKGzZ9D3Jznj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 12:39=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/13/26 05:58, Suren Baghdasaryan wrote:
> > On Tue, May 12, 2026 at 2:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 4/26/26 08:27, Suren Baghdasaryan wrote:
> >>> Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_map=
s
> >>> similar to /proc/pid/maps to reduce contention on central mmap_lock. =
One
> >>> major difference between maps and smaps/numa_maps reading is that the
> >>> latter executes page table walk which can't be done under RCU due to =
a
> >>> possibility of sleeping. Therefore we drop RCU read lock before this =
walk
> >>> while keeping the VMA locked. After the walk we retake RCU read lock,
> >>> reset VMA iterator and proceed with the next VMA.
> >>
> >> With many small VMAs, is that overhead noticable?
> >
> > It might be but the point of this patchset (and the previous one that
> > made a similar change for /proc/pid/maps) is to reduce mmap_lock
> > contention, not to speed up the read operation, which is not a
> > performance critical part.
>
> Well, this interface has been around .. forever, so if there is a noticea=
ble
> change in performance it should be called out.

Sorry, I missed your reply. I'll see if I can adopt Paul's test for
/proc/pid/maps [1] for benchmarking smaps but I would expect similar
results as was reported in [2].

[1] https://github.com/paulmckrcu/proc-mmap_sem-test
[2] https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/

>
> > The original problem that Paul McKenney
> > described and which kicked these series of changes is that a
> > low-priority monitoring process reading /proc/pid/{maps|smaps|...} can
> > block a high-priority updates by holding the mmap_lock. You can see
> > details about this problem and the numbers Paul obtained with the
> > previous change in here:
> > https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/
>
> Yes, I know. A problem that has been around ... forever as well :)
>
> --
> Cheers,
>
> David

