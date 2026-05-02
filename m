Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F39CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 17:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D13F6B0005; Sat,  2 May 2026 13:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481F46B008A; Sat,  2 May 2026 13:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371216B008C; Sat,  2 May 2026 13:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 252B86B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 13:47:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8E2616063E
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:47:40 +0000 (UTC)
X-FDA: 84723212280.12.02ACBC4
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68573C0009
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:47:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=H8gXbK7N;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.169 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777744058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkDlMwW9LOk9hbEeRVGqbAtiJIkcVCWyQP9FaD9Q3r4=;
	b=WfjxBJorCHYa4pYijns8GXykEi+Kq9QcbFTVImOnlmfeL3K12o3/w/0x+xRhjk5yeKF2Rg
	eaiRhpTD09zqYlMScNOFyGqEUMEXVBNSCoz4G86vwektodDjESUIzyMKXGsZOgdfzAhC0J
	YuVMKsWYcijpF0kFEigKDHWExzWS+qM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777744058; a=rsa-sha256;
	cv=none;
	b=6yXswcSsrUIQ3FwfC6kgKQ1cTO8AC8cYqXAqc1LyxpzYxYi4pNaCOeG0BaXXK61eoI88DQ
	IrdFmVXB9fv+sWr85utIxLW7Xe/CWpjBAKLIYwxqCrl6/aAwLOO1TxdKA7Tzftx8qgUEJP
	OMBTfUPeCVLCsl8r8XMhGvxP7OMpVYw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=H8gXbK7N;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.169 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39380e79936so5172111fa.2
        for <linux-mm@kvack.org>; Sat, 02 May 2026 10:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777744056; x=1778348856; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TkDlMwW9LOk9hbEeRVGqbAtiJIkcVCWyQP9FaD9Q3r4=;
        b=H8gXbK7NwAPXcQuSMj+dBUbpfBLHJcgEt4ml1O9r1wHyWqZElcJaE5rjkuMJOWZZUC
         zL7yFD0RS2xhbl60xYWE42aX2IZtRLtX2esMnPvQkf6fJj1T3+n9p8uOAcw0oUzgVLq5
         Oi1FQmPvvYMuzR+cQAFqwemRqUuGCA3CWhtyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777744056; x=1778348856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkDlMwW9LOk9hbEeRVGqbAtiJIkcVCWyQP9FaD9Q3r4=;
        b=Kjvpif+d0CaMXvYDDAHwujvysTSjpeDpdHax18y4BWKmJ/MR8CSUJm+YPTQl94G/PM
         K+CVak+miTkpRw9s8ktqx8L5LrDBTKWZFl7TCOS5o69i2VFbCVIC+2VOQ1DIZl4ZZOD7
         YYE3fU8dKhABTOvAOBvhKlNtvKWqBh1jq3CIQV5JNY/h5N9IKfn/W2KYTglkKL1E07BD
         ato+7nREL3018cRmj8CzZdazLjSPuL9saUr4LXpH3KujamfFo6c/zFLgfl7pm9ukGK8J
         6wcntAo6i+B14qRGyRa1bvNmjQdfnWtcSITm9Zdx1B9mDNcUU2UnFRDrT0JH1IQf3b8R
         Qp1w==
X-Forwarded-Encrypted: i=1; AFNElJ8O+zRB/w10Ss/k9tT2vmLA2pDfi8wk727sRCFUdLbA9qlBfVz5G73MRtp16L8ofzlPwqOG99GpFw==@kvack.org
X-Gm-Message-State: AOJu0YwB28CEhkau34jqra9pFgQ44AQ4n7SV28yOL0dvUg3ucCXPI7l5
	ipD3H52ZDpGZ06elEv9ty7v75KvdQFoz1etE2DJNhxbiVx3VVGSOjHty86SI/uWTtbZDiUSRioh
	MhNN+FM2Y9lQfzn4bslPfWLUkus3iPA1CFapGB1Q91Io3qEQFvt6x0KSXJ4mssbB/
X-Gm-Gg: AeBDiet1CmR4UdRo6EbVvNTAJPhHC9RoRVAm8Sbrhil/sSi8/Rug5gGnDhVZOPQ8mtC
	ldq4tNJwAXbq4ALcCGfSLMLHz3tOadHfVZm76Ofyzz5l/oc/VdcR/tAQaeCA+IwO0X2XpkakXIu
	iZs2WCR+Te8Twzgg5q9GGcQkss+JLXlRYX4CiYvu6v4+tAmBPmoaMsHB2VH2CzFxRvew8QUpHv4
	chli5PwB5IOd14aFiVqJudmdVmPFoVY/MdkHBf9ao/ve83S9TaU+YqBraJYYuIgANy4txsG9QDJ
	TL5c0KsVKBpDxI7YXwrC9xGyL2tCdAEBZOWnH853jR8wQl3jdIKjkdYaPZS5UR4yiVorU2H29SZ
	C4mzDlbmWJqlK6gUqbH2HZd1aqRXLKfzB1Y0gi5FVyOIQv28/Th++mz5OGcH1ALe7geYhd+GJUl
	kLqSb/wuxiB3slqawQzkWwmqbXAKH/zv9dQUJUG6OF7NOftRimhhPt4xXRifTDI73anqu+d1ExO
	rn1I6Ih0GdUzN4=
X-Received: by 2002:a05:651c:2116:b0:38e:cab9:364e with SMTP id 38308e7fff4ca-3937856beebmr11192881fa.18.1777744056082;
        Sat, 02 May 2026 10:47:36 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39361356c5csm15530841fa.36.2026.05.02.10.47.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 10:47:35 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-38ea6a5a0b3so28104651fa.3
        for <linux-mm@kvack.org>; Sat, 02 May 2026 10:47:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ80epig/jYFtVrz/eHnsBjyMwHThSGSSpHSLckpuZyENZKbOLkn9ilmqIS/QOqNamvc//Fi2J1PUA==@kvack.org
X-Received: by 2002:a17:907:a01:b0:ba0:fd75:9c58 with SMTP id
 a640c23a62f3a-bbffd6d4b73mr186122866b.32.1777743611316; Sat, 02 May 2026
 10:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260502155730.430232-1-mohamedaymanworkspace@gmail.com> <20260502102436.79d5e53038169f38e4075137@linux-foundation.org>
In-Reply-To: <20260502102436.79d5e53038169f38e4075137@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 May 2026 10:39:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgOLc3MR82p+e0fn7BPurttE8CSpBR-kxH0Bupg1moieA@mail.gmail.com>
X-Gm-Features: AVHnY4IcGEBkc77UHaABzm_uUQyDH-tCADny3A_oPDAWMmgma-dWx3tbzufKlFI
Message-ID: <CAHk-=wgOLc3MR82p+e0fn7BPurttE8CSpBR-kxH0Bupg1moieA@mail.gmail.com>
Subject: Re: [PATCH] futex: Drop CLONE_THREAD requirement for private default
 hash alloc
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mohamed Ayman <mohamedaymanworkspace@gmail.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	"open list:EXEC & BINFMT API, ELF" <linux-mm@kvack.org>, "open list:SCHEDULER" <linux-kernel@vger.kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Yiming Qian <yimingqian591@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68573C0009
X-Stat-Signature: kg3nxt8g341btuofmdbbyz5q3unb5hzr
X-Rspam-User: 
X-HE-Tag: 1777744058-773050
X-HE-Meta: U2FsdGVkX1829wHrlMFePPYJKpL2TM+d8O+CqeKE12SDRBNK141dUfgk5AJa/BgiplhacbTYCr//I5f2CTbQrMMBthtTpkYqQ8ampxg0PxnNBau0UdUUJDg8MVcxRwAPLNCMHnA/odfhivKaXpfdpZ4/SBpJRR5bb77NghjKP0t0htctdqavfgOk6xxd4l8l7H6hf62XffLb82nb1ZmpSL+1pWp4MhlrH5ltrk9zxBWC2f3MdXQpGwKxY08PFuoBF6zBgOH72EFLgzUR0Jt4u88SiSxZWP7X2ojaStZgfjNIWfv9FH3Yod6UG2GtxTQCvxphuppH7zsQGlMLsxDSekrXxJDMtqQ3z3CP/hTQXm8t4b9Y3XE6JuonpK8/+TfL09KDpRYxy2tiGuCr8l4vWAOuprz6im2XHplwEQbavIJRrFlx0jZaRk2dbivywNEhiYiQZuOjJ3ecGKAiu0QSVEBPREvXBQJjg4AzI9b1EvbrbP9pcpb0DHRObn0FdNiyKkLxA9XDYqa5fyarNcKYE6vONPDf1Yp+/zx5YIh/J+eqKdCvTmlxeuaqdC1uuGIXejZbEMNZjVyRYMF5iidB7cFINCT9DmlqUn7bZmC2OrCKDh0N6KPwJ5ED9tcbYWXHmovFzrftKAm82rII+jKCNkgvtRRI+0ke5L/D1OtsFZznXP882/KrBB8XqbDsllcRSBq45z8LzX4G2mciczL1WOROd43BtVV9qzKdYMSLkl6yyvYCDnjbyZ7oxIWRzAIM4cAJ0kn1534ceh7w79Cwhj1MioRikPyWRp3NVCm0IirI6tEnOUO5WlksoP8SBFPxTX79uFhn3uaqBpzS2nX3I9hx/d5u0w6GdVPBKpCczp8UBcf8CkcG7i5/3LQSWnbC/DvDOZ+GvDxIFzYNtY+W+t62paC9OqmYLgDMj9Zrqix1G0APmgP9DonUlKTxJCwKGGJRkLwj1HUx0699vdK
 K31rFHo1
 I2ABsdNE4UQuS9CSLYhjElWaVOxAr95LHQJeMDiv+M7MVqHOH/oevQqj/ox/STz/mEkSNo09SYtPDeIU4rF7nqK1u9pWjYvOAJUv9OMH2iV0uSpA+BvYhypvJVSPrdvCgE5JyIUR1M5TvG7mQHS4cL84G9HVZKYB8QDDn8xXIBpg6lF6Ey1oy6Nhkr0epuwfKR6uhKDw1Nv54BaftkR8MGomJoX7+rRiBHFpeLus7ZgvOeG6ogy9Vn8xm75SyxVN7Ct+B4ve1dKAtKWem2kr/pxFhrUBSzx9CuBnw2usK/46WGwwFl1GKG9MSq0657TzSNuukL+7PCuZ/OVR31hrN3YncVodboF6lciKu+kRhuGxt8NtRn39AJ/6g/CWSLER/rLtDk0pbOPTrK2442bE0fW2zw7nuQAHwbmLzBvgHX15muOKNP4DxLXQ2dEaz0TSBqOv5Wf9Iu6eNFFG9hgZayuH0XWsLekS3NMEnkihrFYMwrdRdt3RJ1gIInQirjhUQnRB04oBmylkATfGZeBfL4LkmqlLG9HV3+w/xT1vG9t96JDFGY1gSyV6vJ2u7ty7AvqPz/D0PToqx7Vr89bf+L4UeA3sRA5DV6oBBLVQMjOUqS7pmf3J0XBTjz8YSksUuegHxLX4nqaA/e8Bb1ibIpCHPrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 May 2026 at 10:24, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - I can't find a patch from Davidlohr which looks like this one - I
>   can't figure out where you got that from.
>
> - I can't find any code from Linus which would lead to the addition of
>   his Signed-off-by:.  I don't know where you got that from either.

It looks to be just a re-send from the kernel git tree (commit
ee9dce44362b: "futex: Drop CLONE_THREAD requirement for private
default hash alloc").

People who use git-send-email by mistalke often end up re-sending
other peoples patches.

And that commit came from

    https://lore.kernel.org/all/20260501194123.948643-1-dave@stgolabs.net/

except I fixed the "from an earlier CLONE_THREAD" in the commit
message to be about CLONE_VM when I applied it (as per the thread
there)

              Linus

