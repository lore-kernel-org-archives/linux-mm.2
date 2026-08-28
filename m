Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD4EC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16DD6B008C; Fri, 28 Aug 2026 19:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC80A6B0092; Fri, 28 Aug 2026 19:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FFD6B0095; Fri, 28 Aug 2026 19:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90DF26B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:36:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E249E1205C3
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:36:42 +0000 (UTC)
X-FDA: 85152290244.15.723A240
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26611100004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:36:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h5NZbfIR;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787960201;
	b=tvtoLEVV08aqX0+bsWT8K7gxJDgQ5IxbU+mcc2Ugo6xxjfIEN5oUQMKA6eMp/q9/uQmupK
	Zd88p5s/D4THT1SnHG6Z/gv3QUz61Gy8qKwar0eaixhaCbQnurPqn0wgOpblNp8P2hqfvM
	b7ZCkZD8bwFtTKgOXv3jyqKsPvz6UFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787960201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFxRXbHadEiDMSxjFvFaLGe1M/LzTu9WqCxKEuyRP8s=;
	b=SkfHv3EXV25QDbHmxo9Yqvl0Zu5BZz+GJuI3jPg9WkcddSOTR7ROfE7thPmt/rYfVpvpsL
	5on6Ns/fCLHhI6DEGbiYwwoSs0UYZDqTyXg2JhYolI71aGC3K6HGjmm9JHQdXlX+J5jCao
	FRiSPA7D3jCCNau9SLWZB1oyJ9SChFs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h5NZbfIR;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cede6375caso42885ad.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787960200; x=1788565000; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFxRXbHadEiDMSxjFvFaLGe1M/LzTu9WqCxKEuyRP8s=;
        b=h5NZbfIRK9Dwe1JV8WCPNi6m4yvRpCwGISgZ7ebmjXa4zpcHba64lw7vtASGNfkAfz
         HQOvdw7p4BMbAgD2A7orel00bodJIu0HC50kiiueqt0utjBl/DhfwKAhyrRrvEcyQbwz
         gqx+PzDvppyVO8AyhURQR8HqunavWAkPWXDWReLPKAswJFqhboz0M5sZEkSZjh+hU7Zy
         jRTRmA4l4MVptVq9zz2GiZM7fSdBrn0HkypL8SBnsCU+D5gYNb/MoNF5GZTPJbC/hCaq
         49UCgtrdCa33BBbwtb+TEh/m3kg/LtuARILrY92cdfokXlx+7zQIRx9FWfhxza97G4jo
         WD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787960200; x=1788565000;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vFxRXbHadEiDMSxjFvFaLGe1M/LzTu9WqCxKEuyRP8s=;
        b=HskBdKOyMEH0rsMDjY6ObLgpQMuGvz/ebqnoVo8Cu3COHM9AgzAwrFQ0DjwwmBd3BV
         Cep6D8HjPS+FO4Fh6zAiK+YRvOLcXs7TuwX/av53oIgsYMiAUzVhTj2V/vVO6FKrVTCD
         Ak5nSoUBnJseH0lhvtrP5G8wDT4a93LAd8jtFa/ZzJ5OoAHyyVC+cVivpjY5sa1yX94g
         KMHwVI9b1EYyJj40oivRH/WvdbeoYHWFNr84sYC36Tly5C1lq+tmVbY8BIkusMxP+OeW
         thJ6np7cQF1OfWNXqtS/gUBMGAr81jzuAzrwX72SF8FuI/Xt954OZ5Z81lar18if1gVj
         Vu7g==
X-Forwarded-Encrypted: i=1; AKwUvBxfFbMxF2kxNdoioHf0stZGmO8Vpz6+m9liX0q5x7kK4f869u4No0GZd3phypVJYr7EhALje1OReg==@kvack.org
X-Gm-Message-State: AFuF++lJna8NirWej67QPc97kwTcKem5Kz51BoEXVReBY5nOV9TA527J
	6/WWrURXS7kW3aWdhbARGmssExg96E3vTVxVX94P2DaN5A8EXBYJkAXOJLCqnYkTLg==
X-Gm-Gg: AYBFou0279XVl0hhOvcx9m0GMwtSTxsvwHtXtwwO1K/bWDmf9fKcV3+3bw3q3IUxqLu
	7A6sWdiDOZA3PAhfNiIPA2RWkaYml5jkLueDUlMzcct5vJXRia66j++IsE9dDT+Z6Ydt77p+miu
	nthfe2yqr8SPz4u0kGy0kmFCac9GnqshqBm0sgZakpzarV2j/vtt4JL4kvEGU4/WwhiDFsucFhl
	BB5sju5w0AW7T59BzeG8ThPzgLgfDPdXdWc9xHhFfXZv8R1XBuRIpCpweiVH0U3hgJYbLpWK/v1
	ADkQ3LCejOGS6iZF7tV87HJqlROaVOx0rPcJPa37vpAj37MEu4E+XbKFmZd6OjW8lEELbv8ZmyR
	DqokFUVS1TjO8AcFqX1NSxoVuC55a5KwYqaho+uDtsLU/0i2gu3NfbNGTuIR2OwtSX9ovnWL/eD
	yUvYit3J6qjc1P1y4oaYVvZtv5oyv2lUtNCBAc+5r0UUtEMKO3eI6TLFaO+Aq0zC8zfelmNMX1h
	BDxLIPfc5QZLX/LEBLWemnkuOz4tWbZx2oN0uEUTssMDylmuwALvumqhHeLauplalwkNTrpAorX
	TGsl1diuBJ3EApQ=
X-Received: by 2002:a17:903:2c0f:b0:2d6:3c22:994e with SMTP id d9443c01a7336-2d8dfc511c6mr2515655ad.11.1787960197959;
        Fri, 28 Aug 2026 16:36:37 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:201d:c4fa:f5f8:451f] ([2a00:79e0:2eb4:9:201d:c4fa:f5f8:451f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f3312676sm1072389a12.12.2026.08.28.16.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 16:36:37 -0700 (PDT)
Date: Fri, 28 Aug 2026 16:36:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
    William Roche <william.roche@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>, 
    linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org, 
    harry.yoo@oracle.com, willy@infradead.org, osalvador@suse.de, 
    jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
    tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
    akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
    duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
    surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Subject: Linux MM Alignment Session on hwpoison (was: Re: [PATCH v6 0/5] Only
 free healthy pages in high-order has_hwpoisoned folio)
In-Reply-To: <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
Message-ID: <8f023b9f-53d0-0eb8-6f75-65957761cf40@google.com>
References: <20260705180714.3708947-1-jiaqiyan@google.com> <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org> <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com> <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org> <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
 <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26611100004
X-Stat-Signature: 651o7q5goqbq7i58cd3r9uscjp7yh4sp
X-HE-Tag: 1787960201-636666
X-HE-Meta: U2FsdGVkX181MiX7z6DxpsL6LaORPIkrudT5OCFkZ29QJk2SYRthtcvjUZqj+K+Bo6ekpZSwACXJVAe3Ro1NVEosqH/7zDz4+ogzNQXPRoZWo7bthsS/viDPFF6imHzTqyF+Jo9KOojglYaYOvgbOsa35ABP5KVNNxuVYlj7WIjDn9wv048M9mhFRHf5xlbuu2gmyDKDs4cXEWPXzfg36V6wJKviqQBLLvMwtlAdBj0OV0OSa45yUaNOkH4NZ3jY5LRZ/P7qkzgPQRPyCJoKiKuz6ZpSxp7fj3Wjcr5LmVl+8J9azrl9CS8tcL5HbgqbrAFjqYf76jmri/zfn1Qoa+tXEv8jqGB39/jNplYB9DRVZAWexizGp4OsUe+T8ctzMfqr82xEKVEjTimHM1BTMlvB5kYjALRj+oC0UkZdEd3i7bZeSPsfM/GNrASXxezbtC6EB4hOtKdoqpY7+T8mWTdEjlicjaPlHbeNfbkji/I6oLXUlsHzBJe8hMim89w1wGgPogcg+lozLaVgBVXbM1cOiJnuUV+Tftofw6YDm2XH5ROFRuEQlDAdbkSqU2D9NWH1E4bRltmiVP3PxE+iyEnQaEF4/AMEDqr2Isbf57bgScUcTLhUVO2Y/voXjiNLlWRRdPT2IAOI/ZkhyAI0pOYMJbZIseVBPba+j5KCvYQpyIe4WxL7Khtu0wOfyo/o2oN6/59T4rByD8Er6up+073YtBMEw+UCiIoIPjfI0NN4g9HVkCgD/mAMK1fhIdN6dzjg3VXo9FHNW+4Vh3+RWrP8Dyp03g+/eKN71EOGBomh+Jat8S9CQXT7NJ7EB7jUSvSwgNs0f3PJWEfD1UJ3GEQz4cNt3MQr8vbqXVsiPnJa/+R7eoK4lFL0NNFkJzbklpSLbV0lhRxtayUfvTBe7NlGAPm5dabB+J5Js4wgHZNaGqj/g3yxTiMPiRfjqMMTfhUf4M7vzTigkQdZCFq
 /6qlQk6C
 +J8GLr6XeRFaAFzFXWIPFtjxL3CKxBkARUEcFFYQdLVD6gzjkNyEt9CSrrk2IhcT6kGBiaHt3PRl6RTHwGaKtA4DoHol9CiDg6OdEZH5nQRvmUEtvjxJGjG+NDTKHSqefzqoOOdEXCUT+tpRmD4asPW4nPFyHiuMhEQ8zaLg5QyHg15pN4Jz1ZJwoCLnBsdIV6jbSmPP6Z4qqOsJPH/ZbKdJvWuYg6A7bDlFwKcpeeguEoSy7uBytAOJvScPCtKD9UxB1LfM1YNuRE9fdpSOjbqj+blr+QJq9ZIp06ogukW/XsqoUbn+TgXFpZNIH8NXecWNOcFe3BBAa5yPIlC8K+qS+AXRH+rYBhgx1fy4QqGFvXRkOM8nJlswPFiA09ZTCntm8x5E8CapHxJVJD5gaBYCzST3Pt/IB9LC5w2UsXS6kShPobiBhASHRgW6jCRs5AvrlV7tlZQK3QE0QjD9GppmiycFxVT1+cYtPrPsMwOciIpaJQlHJ/yvkGSfWdR2B/wsvgozqDnsyNN8fJ1vckLL3ntXkTqUoeuimTwsErerAeQAhWXtuMmU1jbOqk+BBcKfd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following up on this thread and the suggestion from Matthew (thank you!), 
I think it would be useful to have a hwpoison requirements and roadmap 
discussion on how its support is currently integrated into the core MM, 
get an understanding of what the areas to improve are, and get a sense of 
future work in this area that people are planning.

This particular patch series is addressing an area of interest to Google, 
but it's also quite clear from the thread that there are multiple areas to 
improve for hwpoison in the core MM and it wouldn't hurt to get more 
insight into what dependencies users have on it.

I'd propose this for discussion in one of our upcoming Linux MM Alignment 
Sessions: Wednesday, September 16 9-10am PDT (UTC-7).

No specific agenda other than to gather core MM developers with hwpoison 
developers and discuss:
 - where validation should live, esp with regard to the page allocator, or
   strict invariants in the page allocator
   + implications for the fastpath
 - handling for folios of arbitary orders
 - handling partial folio poisoning and split failures
 - race conditions between memory_failure() and concurrent
   alloc/free/compaction
 - soft offline for pages in the pcp lists

We might even want to be bold and discuss a holistic design overhaul if 
it's warranted.

I'll invite those on this email thread and anybody else is welcome to 
attend as well, the announcement email goes out two days ahead of time to 
linux-mm@kvack.org.

If the time just doesn't work for somebody who needs to attend, please 
reach out to me separately and we can discuss other times.


On Tue, 28 Jul 2026, Vlastimil Babka (SUSE) wrote:

> On 7/27/26 16:20, David Hildenbrand (Arm) wrote:
> > On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
> >> On 7/17/26 15:06, William Roche wrote:
> >>> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
> >>>>
> >>>> I still don't like the complexity of this, in particular, as we have different
> >>>> mechanisms in the page allocator already to try handling this,
> >>>>
> >>>> We also do have cases where we set the hwpoison bit, while a page is just about
> >>>> to get allocated from the buddy. So before we take it off the buddy, we might
> >>>> just hand out the page.
> >>>>
> >>>> check_new_pages() seems to check for PageHWPoison() and make us not hand out
> >>>> such pages. It's guarded by "check_pages" but it seems to do exactly what we are
> >>>> looking for, now?
> >>>
> >>>
> >>> Just adding a comment about this aspect:
> >>> The check_new_pages() mechanism used by the __rmqueue functions should
> >>> filter these pages out, but this has been disabled by default in 2023
> >>> with:
> >>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> >>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >>>
> >>> So it would need to be enabled back, taking some of the performance hit.
> >>> (and I personally think that it has to be done)
> >> 
> >> Would it truly fix the issue, or rather there would still be a race window
> >> left where we check that there's no hwpoison flag in the re-enabled check,
> >> and only then someone sets it?
> > 
> > Why are we checking PageHWPoison at all then in check_new_page()?
> 
> We check all kinds of unexpected state, when that's enable. PageHWPoison
> could have been considered unexpected too, when the checks were made more
> and more optional (first by Mel and then me).
> 
> But indeed it seems the PageHWPoison check is supposed to be load-bearing
> (hi, Lorenzo!). It's intentionally handled before bad_page() (with a taint)
> in check_new_page_bad(). Commits 2a7684a23e9c and f4c18e6f7b5b are also a hint.
> 
> > I think we created a mess.
> 
> Yes, the PageHWPoison handling was made part of debugging sanity check and
> then not recognized properly as load-bearing later.
> 
> > The PageHWPoison check is not just a "nice to have" sanity check for kernel bugs.
> > 
> > So it should never have been optimized out that way before reworking the bigger
> > picture.
> 
> Sorry!
> 
> >> 
> >> Also, can the hardware actually detect a problem with a page that nobody
> >> accesses? I guess if yes, it's only in some corner cases.
> > 
> > Yes, quite frequently I think.
> > 
> >> 
> >> So I'm wary about penalizing the allocator paths again.
> > 
> > I get the feeling that we don't have a proper plan on how to handle HWPoisoned
> > pages. We should take a step back and discuss how we actually want to handle
> > them instead of optimizing here and there and creating more of a mess.
> 
> Fully agree on having a proper plan, because I got the feeling it's been a
> whack-a-mole approach for years. If we then decide to put the check back
> (and live with the residual race window), it should be handled completely
> separately from check_new_page().
> 
> 

