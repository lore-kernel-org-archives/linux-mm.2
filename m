Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD71F3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81906B0088; Tue, 24 Feb 2026 10:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EC26B0089; Tue, 24 Feb 2026 10:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27EC6B008A; Tue, 24 Feb 2026 10:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB046B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:38:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DB4E564D6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:38:08 +0000 (UTC)
X-FDA: 84479756256.05.09FA40F
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11F7214000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:38:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RxUdlFfv;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.193 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d3HoreSzqInLLmkALJG0kLsfv4b9J4eqo5ttaXel6U=;
	b=ZedwJfhgl1I5xDPsu88rHrziNt4D/+TCwpA1iNjJrmmOtQgIE1NqQqm93ZMF3kSz00yx7N
	fN9uOHqhJHqiLRMzUk0iXbCQndGvbSkcX2cbbuY5uvqFtJThWFytz+FYa7psGEulO2MN60
	TLegNF2SZM6eeSA1w1CPR6iilKfNFqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947486; a=rsa-sha256;
	cv=none;
	b=UiEvUh5aryTfT1exhlf3wTV+A1wh4vxN/lQMP49yb+F9A0lG7JWTnjK9H5EF+ZPr2tL0EY
	aWpXudVp/Oynv4pWA1yzHMbyqStKmnA/lSdteHinI1byHyNo+sGAiuEoCxVePJrRy4mssS
	amL6Xd07BGsGJLir05fCGO0GzwyR1tY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RxUdlFfv;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.193 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-385cfc572f1so44615471fa.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771947484; x=1772552284; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1d3HoreSzqInLLmkALJG0kLsfv4b9J4eqo5ttaXel6U=;
        b=RxUdlFfvkxZpLtIwqGhB+UHHeYO3TF20rwv/R5aAKVxd4RESnzrAJbfgU3QpOygOx6
         sL6PEPHW9GCMxQ8eH6ukP/E/9ZQ3HgnnCgE/ZIplZOusLhCEM6Svj4jYUzQhBiRYqzAK
         1rUuRmDNCHtAFO/7iTxoOS5TjaWCSHF/PO4RLT9VVjfqr6AfcEmzFojjRj8Ov7sGyNp1
         Vb6bzjeEqG1FWMqkIEwTU3E3qljollieP36ORxoC7W7exiZzBXDxmblbt1l/Ep0s6WgE
         d8mRYhnba9X5Q7tf6iFpNODQwS3Hwq3KetJw+fXRIvw1Hui7tXSpN74RevcIB3ECKzUW
         WyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947484; x=1772552284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1d3HoreSzqInLLmkALJG0kLsfv4b9J4eqo5ttaXel6U=;
        b=tvQ3o2jXZCqFNNBMNKSjO7RGz7hmYO9EqONpjGhmk01Y7GoQDG2wCzz6cFIa40mqnn
         KNEIhvKqEgUYQkpyh33VNt4liyza/jp3V6Wl19hDUHs42Xfi4JrdwnAUCJV5zezz8KsM
         aMWzPQe3yeUfK5Yvp5SuK5b7+Oi6EGxu6iNBs57kCGoQAErZkdpAxdRqcBhbkTEhwXCI
         LMiQMEWGJgmCV5qFJ+7OrnendiUdXb1YRlfjd9fjuUW8Xc/iLmLjmH0q19N0G5htgEe7
         K4WlCQ2dj5c5lCjeQCNgBa7Qgrd650ze3EWUDG1bxDlYst65zt6OW3IQNGKwoXaYIb7n
         GveA==
X-Forwarded-Encrypted: i=1; AJvYcCUNL/efRo09A80HeYyKq8CT6wJkGrP6Li66ceRoL5zzNndjgNXNr3YvLE/joYs7k+J+KkqKnYlvSQ==@kvack.org
X-Gm-Message-State: AOJu0YxOfqkbXuq5atHS6wjvBlk2HBTewIij3ifYd21DqFw12s8qweYO
	JV1QAS+UJRzlW0CuSrp8pfiDfnlKMDiPmz9qgQfTbNNTB1wG9Frz/+/5
X-Gm-Gg: ATEYQzytDQXfTG/x1hAdXsGX0bfcw62xqmuuuhv47xBudSjI+I63aZi+BdeuW733Hv/
	o+im1rrKEvmJ+yQuuL/XWEiqbkEGA5GmTTBAlFxZdUiQkhPImzsSpyHwxDGTPc5lrforBsjI/HA
	bgBjKP5NBSLEHcppB2O6PxZg4yGX+NONiIYTWPzzLr3WFV3IJhLy65s1+C7Of2j+dnu842M4HLX
	aokVjJY1s85T843g9Ip/F6weN0qTU+ETr0P71VVic31JIBEK5yn646K6rwN10spUaCYfKkKg0qZ
	mr6MXO5OHwwAEudYzLh9g4UlzjoG8rWKQPg8/Me5wfsSuvFCukHI+jTUb3l0lTsqJicnY5M+v+r
	lVT8uDrjQJ1ZiunXyHjUoesmj0pNVITzTUiKKb+SeGhNRLyRZAGAjjxM2lIcSVwt4b4glWzQxeH
	okwvIyrHKF19Wzwa6epTArYf1ctvLwLCDbsCcSAN6T0KAPItKuzy/8
X-Received: by 2002:a05:651c:324e:b0:385:fbff:ab2f with SMTP id 38308e7fff4ca-389a5d4ec51mr35490151fa.17.1771947483965;
        Tue, 24 Feb 2026 07:38:03 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7a71271sm23396621fa.31.2026.02.24.07.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:38:03 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 16:38:01 +0100
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3F2cghZpqBi1Mk@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2YDD_l5JN78DJC@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: 1m9k13n8wiumhde8dxpzpmcssf5ckcyf
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11F7214000D
X-HE-Tag: 1771947485-740495
X-HE-Meta: U2FsdGVkX1/VHZx3lCC8eurHMU9kcA81S4LWAm631DsSOn1LVGJvoF4qUW+bC6m+RW0hq3DLvn6psNjPbgjIIntriwVUIf6ZeZJZHsnyf8EoI1mmK8z5ZjZP6x9pMohu2fMfR8IBFTz3HcVnwtK+Nogw8yFAmEi/AedGWokWyGMQLzchjhQLhcYlZHhF+pVQnUmPdzM6XotbpkM06TpLBf5qPrH0/v6uaJuc05LoqCaF2KRhBZGtAiuZLgGIlbT7S7VkQ0n/QST93aT16brFt5cT3nQu0IG9JhuziN6dMfdGtRlmFaGeB9RtUSd4+NAm+6LMfiAt1TOc+zKQil/TvTggWFQ9l/youYCNSdajnrVjAxT59vrK4PxyRxqAHlscNZ7Jdr2q0LzhuZvABCeW6d0yl/EEFC6+JuLGcQGw8XnCY1qegDWYAAn1GSwd9fWYJo6/Er5xfdsJJ0ZRPUPb5jrLbf7homso8Ha8NGkg49/LB+eSAKeg4wm7BsrTI44G8mJjWSXwpAwmMQwUIeGkTPxUnaLmbneGLbo13NQvGA8VFMOoKEfCiwpS7OZffIaeIz0zEH4oQXjtIktEJIzAv+ONJuxfMsWoBHesPyGv1ym5JPILAHwSd5/r8qxPWlTCeye3//2+eEUvypAGqZr1nmbCY4/LmBYs0ejDMh/11NhDC6o6CAbBzYsUvzMIZnCT84seefqAbb1j8qObkpFjcjWNvDuQrObjaa8Q02BLmq5IAOu0YV5f9KxkD/cIXYgJ49tdxhtyw0IbW2vqvlDrIwKAy6SRmTrhh3eqgZhcXoyUDv+YdexVwcfTPgSxLTFilD+WiV5NIvOUcF68cgqpQIlS7ZkxrYewWe53ztMXyUorAgEuRmEVqqVfU3aAPgGD3zbnF3nqFrfyY/IQp9zSgQR67UvV1jCEP39SP+tAmla801h7zcMDPES+mXkeqqf8YcSvbx1yPtJUPxVmyUI
 Kk+R9SJ3
 IsUUvIuYU/jwWc4UXIEv9Qe7Jzy5d24aJl4LZdWPKpMFZkVEzhzSUdSFwNuB6Ho6zGDmZr5TztcY94afZ0+SLtO9yNEYFhKEpZUdn1LOYoZdNZz7oCi/ZbVsmgPPnyY8rZoZzUowDvIV/ST5noiZknQgfhQFCMxr2svE5e5339z3n8wGL2VQmOkAd5rkz2Fk8MWkeTqmDA93odhIIqflC5Pv/fwYAhaRhxCvzLXpSkgQcIjZObDccFD+OPCPH5gs/jpkOvfGQ/ResM8dbcnhg/Uy+f9caHJb0oNk8v+Leh3+3V2AvQE6dvn56ACeD1AZ9AmgJOMZP+0XqwCVKcuHDJrDxq37R8E/csAa/5AvUph+kNnj7kPb1doftd9KAFn/3vgvz7EXGBwxQ49rmHhkTNVJFh3iyGVagmg64pu2MPmoL6ABKm8BWUifPMAFWtXjhczYMG2JA0H7EpEI/jviAuh8NyVBiso6LYXIIxowgwnIVDtas6z481ADEUDI77Ju5uJhLcBk5nXEIhPv1+beT561UnY/vDXAjNQOMyzME4xir3TA2cGYVKPOTWuKCanotoE1Tf2kaimcvyKkaT4Pb7w550lCI2k3WBG61e5JEnjgaMbdpXCG3PyIgmab9L3XenJ5/If6Mt+DHDYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> > On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > > 
> > > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > > flags.
> > > > > > 
> > > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > > 
> > > > > My only skepticism about this comes from the line in the
> > > > > vmalloc_node_range() doc: 
> > > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > > 
> > > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > > doc is wrong please?
> > > > 
> > > > This statement was added by Michal Hocko in the commit 
> > > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > > 
> > > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > > supported. While pages that back the allocation can be easily made aware
> > > of this failure mode there are page table allocations which are
> > > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > > change that (as we have learned several time over years).
> > > 
> > > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > > want to trigger the OOM killer (which would kill some innocent task and 
> > > > wouldn't solve the out of memory condition at all), so I think that 
> > > > __GFP_RETRY_MAYFAIL is appropriate.
> > > 
> > > Understood. But as said the very page table allocation could be the
> > > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > > unfortunately as well. vmalloc has just recently gained support of
> > > GFP_NOWAIT allocation mode, though. This will make the allocation
> > > failure much more likely though so I am not entirely sure this is a
> > > proper solution for your problem.
> > >
> > Yes, the page-table manipulation entries are hard-coded and it looks
> > like it is the last path which is not wired properly with gfp-flags.
> > 
> > Since we grow PTEs and never release it might not be a big issue for
> > the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.
> 
> One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> allocations as those could be achieved by scoped allocation context.
> This could cause pre-mature failure after the whole bunch of memory has
> already been allocated for the backing pages but considering that page
> table allocations should be more and more rare over system runtime it
> might be just a reasonable workaround. WDYT?
>
As far as i understand, Mikulas uses __GFP_RETRY_MAYFAIL with vmalloc
for some time already. I have not seen any reports about that a PTE/xxx
alloc path triggers OOM killer thus i tend to say that it is not easy
to trigger.

I do not have a strong opinion about workaround you noted. Maybe Mikulas
can switch to NOWAIT flag instead.

--
Uladzislau Rezki

