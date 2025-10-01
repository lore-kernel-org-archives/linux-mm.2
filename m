Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3122CCCD182
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD8C8E0008; Wed,  1 Oct 2025 11:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A54A8E0002; Wed,  1 Oct 2025 11:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB218E0008; Wed,  1 Oct 2025 11:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5048E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:55:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 146611173F9
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:55:29 +0000 (UTC)
X-FDA: 83949995178.06.8845964
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A36AC0005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:55:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWWFxMzz;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759334127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lU3Gy/BQ6qxCUFWfpwnTAmYAtNG3wW0MiedBiSGq4AU=;
	b=mi17PydOYS9T5bieAG9mMzRchRtnlY4C2fnStlOPV9wMh8+b/qFGIzpxXNeqXxiwsT30qw
	vj/4qAfng2Raca3XDUUMIfsJcCgvmTHcUnrt4YgKuozCdwHKRDGSgy8ZReteo0UZlTkvnK
	MwFEsTWosuX7V0xrUnLQTLRs/oMllz4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWWFxMzz;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759334127; a=rsa-sha256;
	cv=none;
	b=B4J3jzOG7hpA8+1ptedTnLJonTtq6yV+M2Bb1/uYMRJfQPXm0cvLTNjBJYwWdu0IRY6EcI
	hYkjyEP7XfXnfhHy8zwXOtUddxyN9vKG/WO2gPfZT9nZ5ZBJuLmjZ5mNnd4TXHpBGxXzW5
	tkSNYnC2n1baVuqMs6cuZ6tjjtvh8ng=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-635c9db8a16so111303d50.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 08:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759334126; x=1759938926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lU3Gy/BQ6qxCUFWfpwnTAmYAtNG3wW0MiedBiSGq4AU=;
        b=DWWFxMzzbEtZUKPj2tjWLEcU6aO9r4GOsRev1hYi/+spg6nuKmkK/TinAZ6OfwGIiJ
         UFWrAR62tuomr/s8M0XKYllNUMIbm4seuFCT4x86YxJ8UwDshKXF2cE46syKSp7GUV/n
         FDZON3F/OJ0lZ6M8673r3TsL3rUwk04RmGR7xhWdun/zsHaoek51gBbGGO9jnZhlDHL6
         8UGSCErzpxGg1GaSi0iBm6NDhtvInumNiaDFv/+ReA3KfKGIK5bYLD7wLjRzHdSZjQJq
         K8SpARqy5cOe4/ekb4VoQ4QgfmVSM0XuxS9N1/o0q7+3wi1K9e2gulDB6qvDjT0Qldmy
         n4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334126; x=1759938926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lU3Gy/BQ6qxCUFWfpwnTAmYAtNG3wW0MiedBiSGq4AU=;
        b=ISyAkfbfNRQHRHWEwhJS6pC879ddt8hFXyhoSFYqmRU0EQeca/3j9vv05ead5U+YvK
         //NE/ypFXX0QJulAkKwSjuNv3ZvGUXK2lo5dpLLk/sXqqtwMxxovaOTH78hV1a1iNdmZ
         leTQeILDhOvLMINb5tK8aGONbfkR7GuEXTq7UIus1KUUdeUa4o0Exh9vthri7nQUNY6S
         YZineDsz9E0g19pDCj30K/0e6Th5MKMQj0mkHX5JfqtND70DSraApYnIl6/9Totju01f
         7r++9k7PxbNE4HyOtfzYTTJbiiKXqqF6cjWKwkkZnfaqedIl7COdkXdr5/if70dpzVFQ
         dTpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNLKve4J+Cg/+D/PnJiXBFp7zgx4MHesqc3ug99/OZHqChHJzpwuQc3n3AlHXdPgz8y4T9W5C+aA==@kvack.org
X-Gm-Message-State: AOJu0YyYSpX3RcICpwFd1aBogNmAWiWtL0GvZkYP1K7dW3jv7TC+paFz
	CYo8atrCsuFD5jalpCxRCzpQ9QZonwF1I8QcGx9R74WDqjJpQSJ2nD49
X-Gm-Gg: ASbGncsw+yVoHAFWMu4U1WztTCDKwb4w4rlkbheVT4sOWfjSIvfSEx09HrFU7ddRgdQ
	+hhK7ZsHagXuFc0NAD0ZGNltSb/VuuHXPSJ53QOUk7bm4jt8wHqhAEPwVhjnTyEMaF2Z/mIR6m4
	EMWXcinhbybtAteTZgLkIeRIAOPkeyrSwG5OPesdpTW2f4Ndq+fwuKtU8sc5LmTQ4wce84iCieA
	WITJWW/u5SOzHdefYpJ+my+CW3bBK32c/Wd/Ja/W30HDqWFMXfnseWmbeAlWjaOSDuEt7tPGqUi
	w1ghMuMVnLolQ0J1NHaX5F8XO18KwitFuBkIr817vx7qIWVjfrlcFV6zsxyrigSIYmoyXgMFq6b
	jRdv4BT6ujOrMkPYXlgbmEFjF7qySmN46phTFjiv/9BJxL0OCYbFMotrZ330EfH0/MmyQk9eZGK
	kX
X-Google-Smtp-Source: AGHT+IGcvMSSDnIn1p0y9m8Zo+GqEbnRb8m2pFQ6BPHXmax+C4usDzFi2whoNJCFfyq5n7RDBATVKQ==
X-Received: by 2002:a05:690e:587:b0:629:e2b6:1302 with SMTP id 956f58d0204a3-63b6fea76bdmr4202238d50.17.1759334126258;
        Wed, 01 Oct 2025 08:55:26 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63b717fc8e3sm926585d50.4.2025.10.01.08.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 08:55:25 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>,
	oe-lkp@lists.linux.dev,
	lkp@intel.com,
	Chris Mason <clm@fb.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Wed,  1 Oct 2025 08:55:23 -0700
Message-ID: <20251001155523.2470826-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <689e36d4-d828-42c5-9e57-ba663adc9ea9@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A36AC0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9px933514ep7bgbf55xkd6xahqffau4r
X-HE-Tag: 1759334127-964058
X-HE-Meta: U2FsdGVkX1/NGmyDQgdSYMHFS3Bsg3/1ba7ZEuBH82kOTOECggr4BA5KgrQ3IyZyZB4XndWlC4BvGV+tx3JteYmn230GgUElwvyfI8OzPZlDhutg7uakvW5VuXf14bnEMmp2YuGOWa0Q9DuKpEq1xMPQOJLFIGBwew0E9Ci6PLJ01qK5Nk79SyCYcT/BOUyfj7m0AOGaWk+kld2BxvmhVHNzzGFQhjnqPnk1FRu91krq5U6gFotHDXqj4lVRS5aJJAtihE7PtxdnKjc5FZC5XoyVuClwTOk83ct47gJgmCcWwJUwlF9z8SZ2/qWb68EhLMKPYBYl5gAzeXrsuF7FNcm4KOAC5KoLy7cwtc6vFgNYzPwNze4ccri8YOA2mn5uTN9CElB8+QX9vJ0r0DA0/UHiRrXOA2KBtqiXEBJJKdthQ5e2B6n0jh0wL+1s3eCHe+Hxepu2EFUGftSLazenvDOW8NCLy5SlULhSvMWnTZe/3A2/eyG9iP0VbWXSGg4nPRj4Rt1o19ZjAUUXz0nL+NC7bz1X2NYIgMCowZPMNoIQRb0pL1IHBD+N2k7EKje1A7zm97j/SYuprM6rfQaqhbqlkvFOkcmKQq4YZZ9Ucu0g+b5hbe0NA/UIOgwC1msNf0H7AoN8B/cYVuIxTqlIEJr6KyUYVT9SWbUp9+gUkO+JsOlz/Flx3S3d5Djh76QQI4fmmE1ZRqextUnk+M4iKVe/kp4n52GFhOAsBzTsjAUiLziQd/Hi+6yusgZAiJUDnFgAogZgjiBXNLi/ITQIwF2YUz+HAbNn82rW+2yS6tDSna10GYdJgpCIBc8wm5aE9gsRvyJqBHgdaYqQ1XuKjTS3pqoW6oVmX9fPten5AVCRHWtSaEw0dR9Z0yLVvm9gsDjlq1csXcFd7EYMv2njVZ9R7xJM9knjrwpUMjESBhPF7RFkmZcpYayRHoUFR4zS1pdsbcD/cMRODtt1lm/
 gv4qiYaH
 IqwUgKCS1LnN8ZNPjkA0+8o0dh1eWBPHQQYnoDP/5tj8Q2ZfKJBcfOh6gTRAS5hYv6MRkpNerM1KEdRJLGFr67QrF3MgzKDKj9wFI/0rNBF206v6fCd58IqNh9bJ5f6uWG1rGq5PyB9EXjL1dipIJCjhFlnxMMH5AcEng2hfTq9nl5F7DuADQOaHQ7q3xXwuFOJnuZRv1cM7ev3bh3OC5a/O7h64MWLiitnYp07N8sABFHoYUdLMUJZJCRvciXnjeE4DBDxlKKvdg1XpWk2C9ruVQitNjSAfoT1PkkA2x+utNMBztW90b19DbN1GYc8r0DXQ4YZxaHPBKovsy40hkLWenANRiBHM54/gdoqnbphkB13JLjbXae8Z2pcvH3sA5K2F974M1Qbea/MKICQr67UkpbC6YdE7sMwG+lxmJQF8KhiPLfwwTljPg0OYM/3fQBYKAGdTL3m0sdDMbSFg9XDBLQuL2tOujTBckQ3N/+pyfUYSPgXYki6zie7g1xmgeUH7Dqh4WmwguuFRTNvJAVn1niw45ns2e1MlWV4RbCV/ZaiO2/CJtVInDiM6VVfEAITdlvw7p3m52s3I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

Thank you for your feedback!

On Wed, 1 Oct 2025 12:04:50 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 9/29/25 5:17 PM, Joshua Hahn wrote:
> > On Sun, 28 Sep 2025 13:17:37 +0800 kernel test robot <oliver.sang@intel.com> wrote:
> > 
> > Hello Kernel Test Robot,
> > 
> >> Hello,
> >>
> >> kernel test robot noticed "WARNING:bad_unlock_balance_detected" on:

[...snip...]

> >> [  414.880298][ T7549] WARNING: bad unlock balance detected!
> >> [  414.881071][ T7549] 6.17.0-rc6-00147-g7e86100bfb0d #1 Not tainted
> >> [  414.881924][ T7549] -------------------------------------
> >> [  414.882695][ T7549] date/7549 is trying to release lock (&pcp->lock) at:
> >> [ 414.883649][ T7549] free_frozen_page_commit+0x425/0x9d0 
> >> [  414.884764][ T7549] but there are no more locks to release!
> >> [  414.885539][ T7549]
> >> [  414.885539][ T7549] other info that might help us debug this:
> >> [  414.886704][ T7549] 2 locks held by date/7549:
> >> [ 414.887353][ T7549] #0: ffff888104f29940 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap (include/linux/seqlock.h:431 include/linux/mmap_lock.h:88 include/linux/mmap_lock.h:398 mm/mmap.c:1288) 
> >> [ 414.888591][ T7549] #1: ffff8883ae40e858 (&pcp->lock){+.+.}-{3:3}, at: free_frozen_page_commit+0x46a/0x9d0 
> > 
> > So based on this, it seems like I must have overlooked a pretty important
> > consideration here. When I unlock the pcp, it allows both the zone and pcp
> > lock to be picked up by another task (pcp lock less likely), but it also
> > means that this process can be migrated to a different CPU, where it will
> > be trying to unlock & acquire a completely different pcp.
> 
> Yes.
> 
> > For me the most simple solution looks to be migrate_disable() and
> > migrate_enable() in the function to ensure that this task is bound to the
> > CPU it originally started runing on.
> > 
> > I'm not sure how this will affect performance, but I think in terms of
> 
> It is somewhat expensive, I'd rather avoid if possible.
> 
> > desired behavior it does seem like this is the correct way to do it.
> 
> I'd rather detect this happened (new pcp doesn't match old pcp after a
> relock) and either give up (should be rare enough hopefully so won't
> cause much imbalance) or recalculate how much to free on the other cpu
> and continue there (probably subtract how much we already did so we
> don't end up unlucky flushing all kinds of cpus "forever").

I think this idea makes sense. Since I am dropping patch 2/4, the remaining
call sites here will be in decay_pcp_high and free_frozen_page_commit.
Here, I think it makes sense to just give up when it realizes it's on a
different CPU. If the new CPU should have pages flushed, then it will be
flushed by either the next call to free_frozen_page_commit (like in
free_unref_folios) or in the case of __free_frozen_pages, it doesn't really
make sense to flush a pcp that isn't related to the current caller.

One concern that I do have is that now it is possible to flush less pages
than the current behavior, since before it was guaranteed that the
specified number of pages will have been flushed. But like you suggested,
hopefully this is rare enough that we don't see it happen. FWIW, I have
not seen this happen before during my testing, the first time I saw it
was in the kernel test robot report, so hopefully it's not very likely.

Thank you for the idea Vlastimil. I'll make these changes in v3!
I hope you have a great day!
Joshua

