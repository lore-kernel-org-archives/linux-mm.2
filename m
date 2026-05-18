Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D06CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0346B008C; Mon, 18 May 2026 14:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77DF6B0093; Mon, 18 May 2026 14:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67136B0095; Mon, 18 May 2026 14:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95B526B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:10:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59609C3235
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:10:55 +0000 (UTC)
X-FDA: 84781331670.23.25BD28C
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3AC9316000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:10:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DSDwa8Jg;
	spf=pass (imf08.hostedemail.com: domain of jstultz@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779127853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Zh1uX+6g1iCyNuMr452Zg32sFLSdswHocLXkqvORIw=;
	b=iTgW92/sFdYzuCQs4dZtre0fUPKVAR5vUwXFRisFVvcsTjteoWAtl/ORx3fRL1/eip6NRy
	gseOUzu9igX+vbHOyvf6vfqJd5lvVpufNLEk5gT6JvmHpgTNFVHfAPbvOXygJnX/ONLjUO
	78JFk3uBjNaIxiEUEIlWc9THyDlx7ZE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DSDwa8Jg;
	spf=pass (imf08.hostedemail.com: domain of jstultz@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779127853; a=rsa-sha256;
	cv=pass;
	b=CH8VtyLlNmNBotm+FLUxHYQVLWmqxZg7UOTtDuDtoypnTGMpiAHfuSW8K5K1zN1crvXyMk
	a+wSARKO91OD+Zt9B8O8UxSRAVZPrzQAeELQv82jrc6h1XZin93f9OPu0dy0iWQRfI/qsc
	KFF432FeyTBlebSvWgJQAbT9+bD1WkM=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-132830d8281so10169565c88.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779127852; cv=none;
        d=google.com; s=arc-20240605;
        b=M5t1D6BhB9IJEYzrDvZRR7Z2AnjSFZW71puZgXEdCAHmlIIT/1ZlqjdEqa8XqBDPWV
         d0jcR1kJgneSP+wmqADySNqpABHoxLH3sJBfE8J5jtzE09zHZkms6LJ3T94reyG96t/W
         dOUOyQWyuYQS56LQHuZbS3bW0Vy7yb2kplvxKP4RQmifaB2mFzIEb6oFJ7N2tWH+ImOH
         EhnNwLF2NjBJbLABYZLHPqlK7JG9JDhLn3mPlaBS9U1aSCyo/HfMO2Dx/93lDJpMIVsg
         OO/45/di/wjN4txRfuZ5r69/aMysJgGlee967S8WWU1m3jfQAfCK1AmNVx0wORSMhaXB
         Kp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Zh1uX+6g1iCyNuMr452Zg32sFLSdswHocLXkqvORIw=;
        fh=ekb/OlCuMS0hPXvr8Iavg8uGQTKFx3NXvEZkYRCGrkc=;
        b=ipGV3ztWY+N1yg3kUsdc9LXP8mDNxGWqtyxJ/pc1mjmXhmFQ7/OU2EOblRz2qvVcWg
         DWabPcCK0K4xmmXwromQa+er40xMBQgqx3U+jTFTUrvQYKsLd8R+J9h/FjPNCk9i3Omn
         E6s2NNuWJcZlk228BAfNQBVhsHHH2y6jRC4cG+jRsLGPbKZAypdQr+VUrOQQpGyl6caF
         HOXW77NIi80emZOjq1uyWPC/jsltC2ngOvc/nXYjq1tCKdnJI00bshkVHwicICa6fJyx
         +JjS23d/bS09zqlKDV4cwzhHWf7aiTFiDA2n3QTtEBBpdqoHhulN/7hCm+gZR0radiSI
         JkQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779127852; x=1779732652; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zh1uX+6g1iCyNuMr452Zg32sFLSdswHocLXkqvORIw=;
        b=DSDwa8JgE0m9gEMI810r6i3tEK8VqivQOousBSc4cRt9/zm52kw34Td8eC22AKPo7R
         Ar0b/QvIAWkx/j1HB1vdFYdgDUVlofw969RkIp1a4DMnhXOakOaqZ3HTo8qoJql9mk6L
         N9cu4AvoFFzqld2uYBSxMOk3UYgoYzs9o8yDmpiumCakmSyVkH/ymIgG1R5ujhRutqSp
         SFjygucCzNiiOHQBUclYPHCZb/OXYDfJQnk/sjMHamSBMiYJNW/kSad+TWPSyYn3cIQJ
         AavRYoekwtMwl3ycFfhYHQkXdC5QX34MnW6vlOOMFgnMhQXXjaEG4yZth9vuRwfYTXFN
         cjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779127852; x=1779732652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Zh1uX+6g1iCyNuMr452Zg32sFLSdswHocLXkqvORIw=;
        b=Dse713TNl950uRi3HYdTHGU8MAcDZ++8091QNKYvWJ/o6F2k24rrAlh+517MN82Bli
         1ay5K4bfld8DzHNmQ2L96T4RGaHIWsKh6EFBv66ZYXAm0Faw/6DEb7X7grHtFiyfNCrV
         VsCGlZ0FQtBvrEguunsA+cXw1TPPq9txiqZEUaFaTyQHc7CQ9zRbFnxzUs/8r3lIa+ND
         6IkgoTBPINWcBAn+CKACHFAJpk108x4mH2B0INRgBhFD1as4u6cyqZPLHGFFX9yQiy4v
         tDVMKf1oYACX9OD5X0NLxulK6/gJ2BSMPW5bQCWDDd8WyW8L7Ok+hBO5qTYWTGZyug8J
         3XyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+YRsbUscW2jOsw28s1AG6uN68xtrufSkWF4vNsAAcEKyolp3bYbr89ItPw3laAB+upDkgUYd+WrA==@kvack.org
X-Gm-Message-State: AOJu0YyKkcRVq/Uknr5JEtXnuWuzj7iCjYClfF+/JArXEBinweaPfOP2
	hJEf10FovjBiuxkSujJW47EGFCCM09Utq/6ptSzno9bUpe9VJdd/h4n6Os+zaTHGp4geJDBqLy9
	X6yDlIp3raZLdJF+BYexWkm2EjcW61j0txIvPmNA=
X-Gm-Gg: Acq92OGoUbfI7rqXml9vLRXzUbAsJJFd2FoKb4lXEHG7HVev8CvVCIOpzq+PYko08P1
	oPVT0pWmb5G00gV8dtF/U9v5i8LRX3OTPaB3DjLzkidrz03zp+sUcNREhrOryUaB9V4Gd8Gb5oM
	D8Y9o38kW6Yxiq9SskSbHN/G8ymgzV5ud0Nueo9b2UnAIl5kVw8IFnUwr1lrZRVQpFZS+GPeYY8
	h+PFGcT1c8c8d4PU1cuB974ylKH1rqFmiKDCz9pZMHgs/f1lZMnkQeCfzPlrMYBbDnpA0Q0fMsD
	essiziMG1T6m6LQ8abF5o3cea+tJg+L7FrdVxcMMAW2vZVthsl1OA+LqvV1OBZbZMWhI5c69AJI
	DWbynDdxdBNDtKzNkNj66IrcRT1SPFKXcw2zcSaHQv43XzQ==
X-Received: by 2002:a05:701a:c971:b0:12f:c7c3:f5ab with SMTP id
 a92af1059eb24-13504b5c729mr7498926c88.2.1779127851270; Mon, 18 May 2026
 11:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <afXGeq1AvqFY76MY@stanley.mountain> <agsrBPXYXA2vZgj1@willie-the-truck>
In-Reply-To: <agsrBPXYXA2vZgj1@willie-the-truck>
From: John Stultz <jstultz@google.com>
Date: Mon, 18 May 2026 11:10:39 -0700
X-Gm-Features: AVHnY4JEPSawYOP6NYIZt62uD2ja2iT50yoFNPEGPnVnjR3u9oBDEzKTHYXWqs4
Message-ID: <CANDhNCrbbWf9CebcQjwiTWt_LiZ9NLUa5C84Fco1V_HumL_6bQ@mail.gmail.com>
Subject: Re: [bug report] dma-buf: heaps: Rework heap allocation hooks to
 return struct dma_buf instead of fd
To: Will Deacon <will@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc: Dan Carpenter <error27@gmail.com>, tjmercier@google.com, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AC9316000B
X-Rspam-User: 
X-Stat-Signature: i486g7uhcrms8dnrjrm9c7c4oc5fu13c
X-HE-Tag: 1779127853-121310
X-HE-Meta: U2FsdGVkX1+22307MVrHN2+WZPNUWWazMWeTLnovjEzjnILla7qdfquJoq1oep9vyARYzfHzV7MjUe5oAW82e0Qqy4ke5gMT6+ST9FAk2Thxb1PB7/OGb7PE8U7o40rA6KD9pU8O8sk/N+HYgEpRTeTtjpPJYeDC0srIB+t+/7KH3EY8Hn+dAVBzTF4Zjk86ifCwT9BsSyMPvym3YOFWLNNQhTLcJdMxM+yoYMZ+doR+9d6R52igqg3LyUwn1x8onaz67Udi6FT/gGILhN31iByB3qp6hjZuSQ3najjpnWzeao/GJx+bONxXGD0iEO+D2OQ+KASwHvRFfx2IdHziqKdD/i8Y0gsxtOhJ5DsWZAZPyQ90mJcGRgGh/hjLKiOKMuT3WbFgQ7BDuIeBTKzhc5ko+yZCUwA9Y4d6shvLXf3ZVkXaahYhc6CtSWGhzNDwz2Qg54KxJybgHsF1oeoEhxqvOqEIFH3vpP535cnDqu3X/atA8LKDfgj7b5z+Cic2LFGl2pV+R9uu9tDyLL6eA0YdWXqlP2zcovmYl4/MybQ36hJnhXaWMhvnMHyP2UuT2Q1vaVcemQbtFFepkOpTJj0/TOSCGjchx5Dh6/bfrRDxRh3bP1NkvmME4aTrKI4YX3ADNsScCRQneL4wa2wq6I42Yac4NiPU+J58SdJ0DAy0qnWGbd0KU8Jc4r3qy58Tu5H0WtNm59bRieYa7JvUSLUdnjGP6Rer58FyXFpgp8dlYE2fO18vOvVLWortJLnXGNDg80FEGE5f2Xpi/sZodD7eWozm/FytVGQJP3UJU2/E2tF9bCKlodRSdzL0Tu4iQZLEn9GrMIjEUKMuPn9ZrQp2cStGnDU4BBzWzqUo6GfYKjT40YCtt2vGS6mlpeZhbA0vIOm4PIfpYKM+Hyv8vTA0BOg0wuLuLeVIGONdY4DCticFmD625iaANQ6gqDe6DiDUYmqs6QMQ2bJJbQA
 vUFyl9kp
 B0k3A9P6zM2AP+6VL87nDlUsXS6yyMAkvPnJV/9Zine2XZ0ne52KCgHDt6Ib/e+4Ooa7XQOBAkTYwEvL07SR7do1GDnHgKlnK61n+vqGC/WNjHPTi8rbXbfMC8bTRmnT405DVoKqW9QURYPRH8Rka8W3wgV3B9SbXhjYLY77vT/RNLu7C6s09PHe12TusGA2dhjw8RGKJzbUqucVGZ3JCYh/bip0rbbIlIiZ/X4/S9Jq+Sii9FnL3yLPWCDodVf3ux1cRppJg8hEQs7pC8MNvCjQbpNKNNv+exW4GAmDNb6+qqw+vbCwQI+Tt5iSN0lU+ESZNlPO3w1fPKvlYxIJQ2D1lfBbQzsYbsiju0LAwp5DNvzcQEOl8OrgL1esxQZuCWLWF2OWshA8B2NhvZfkXR2LghW8el0HSfhXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:06=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Sat, May 02, 2026 at 12:40:10PM +0300, Dan Carpenter wrote:
> > I'm not sure exactly who to report this bug too.  Probably the mm
> > devs?
>
> [Adding John and TJ, in case they are interested / able to help]
>
> Will
>
> (original report follows)
>
> >       drivers/dma-buf/heaps/system_heap.c:499 system_heap_allocate()
> >       warn: passing positive error code 's32min-(-1),1' to 'ERR_PTR'
> >
> > drivers/dma-buf/heaps/system_heap.c
> >     459         if (cc_shared) {
> >     460                 for_each_sgtable_sg(table, sg, i) {
> >     461                         ret =3D system_heap_set_page_decrypted(=
sg_page(sg));
> >     462                         if (ret)
> >     463                                 goto free_pages;
> >
> > It kind of looks like system_heap_set_page_decrypted() can return 1.
> >
> >     464                 }
> >     465         }
> >     466
> >     467         /* create the dmabuf */
> >     468         exp_info.exp_name =3D dma_heap_get_name(heap);
> >     469         exp_info.ops =3D &system_heap_buf_ops;
> >     470         exp_info.size =3D buffer->len;
> >     471         exp_info.flags =3D fd_flags;
> >     472         exp_info.priv =3D buffer;
> >     473         dmabuf =3D dma_buf_export(&exp_info);
> >     474         if (IS_ERR(dmabuf)) {
> >     475                 ret =3D PTR_ERR(dmabuf);
> >     476                 goto free_pages;
> >     477         }
> >     478         return dmabuf;
> >     479
> >     480 free_pages:
> >     481         for_each_sgtable_sg(table, sg, i) {
> >     482                 struct page *p =3D sg_page(sg);
> >     483
> >     484                 /*
> >     485                  * Intentionally leak pages that cannot be re-e=
ncrypted
> >     486                  * to prevent shared memory from being reused.
> >     487                  */
> >     488                 if (buffer->cc_shared &&
> >     489                     system_heap_set_page_encrypted(p))
> >     490                         continue;
> >     491                 __free_pages(p, compound_order(p));
> >     492         }
> >     493         sg_free_table(table);
> >     494 free_buffer:
> >     495         list_for_each_entry_safe(page, tmp_page, &pages, lru)
> >     496                 __free_pages(page, compound_order(page));
> >     497         kfree(buffer);
> >     498
> > --> 499         return ERR_PTR(ret);
> >     500 }
> >
> > The problem is that add_to_pagemap() returns PM_END_OF_BUFFER (1)
> > which is used by pagemap_read() and nowhere else.  The call tree
> > is:
> >
> > system_heap_allocate()
> > system_heap_set_page_decrypted()
> > set_memory_decrypted()
> > realm_set_memory_decrypted()
> > __set_memory_enc_dec()
> > __change_memory_common()
> > update_range_prot()
> > walk_kernel_page_table_range_lockless()
> > walk_pgd_range()
> > pagemap_pte_hole()
> > add_to_pagemap()
> >
> > This code seems sort of old and I guess no one has reported the bug
> > so maybe it's a false positive, but it feels like it's asking for
> > problems to return the PM_END_OF_BUFFER.  There aren't any comments
> > on any of those functions above explaining what return values are
> > expected.

So, do we just need the system_heap_set_page_decrypted() to have a if
(ret > 0) special case on the return check from
set_memory_decrypted()?

Or should this get fixed at a deeper level?

thanks
-john

