Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF090CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 20:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BDB6B0005; Sat, 20 Jun 2026 16:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DAD6B008A; Sat, 20 Jun 2026 16:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B706B008C; Sat, 20 Jun 2026 16:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6126B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:02:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C5E01C49CA
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 20:02:16 +0000 (UTC)
X-FDA: 84901362672.02.00DDFC5
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AEEC40015
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 20:02:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OVKPEovp;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=zokeefe@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781985734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzoHwH23bsGueFkRH6QEwDArOwCSFYWZ1LidPxcYibc=;
	b=IG9nQNv0mkyyRAs8G2P++oAybVgFEs6d0pAxOUmJtGQc1hndlySXg8E/FsKXOnB5Khr0sM
	Pz1YevIqevHEgfJu9oxu/BIWN3hksfBbjGdLUw+Y3lC1C+sHfP10yMv9n1JYxO7Aft3Nmq
	HnB3R5C8rzPGe93ceFi/qbuC/xADAAg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781985734;
	b=NdEpJ763Ijh5WWoBdhPolpeaeDDOa+0YIOmA5kDDokLdDQFj954XQ1/f/4TriORvOkEgQJ
	n31DJ7TLW/5BAT16NcOttYF8vK7RdCDWp69FUrDeJohvwDenH3UKeIG/XQJmQNXX98cpi7
	pQp92DBAMkiORGciP1XoCwp8OsmapT4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OVKPEovp;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=zokeefe@google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765331535so362841cf.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781985734; cv=none;
        d=google.com; s=arc-20260327;
        b=YEarPdMQD75hR7e9VcwqvHqE4mpuBOgqNqAxD4FNENB6mCH/v7Z+UMvE/dg8iGLJFX
         KxIz5BIYNwQxgc9ctP/IFwZxFLJWsvMt/I3iYa3ahF/lAAsLNqDtj6kmJFkZqjjLZULd
         V6pVp53sD1VgDk4j/A5XjHZNRIhY9YY34Bewmdr7ELpHvSREgqCvVclth0CoNHleuO8z
         kxd1dkRE11IqM1DS7DpBq/iejnsav64hQEK51WqCg0kecw2rnEGzxRONKRKodRgAW20K
         Z6veAFwo/H3ZEgEt3ubSmNtpwdBlpgUUeHWyQCXHUQYyAl+gh22uoPNYbc7+BZpGYC4M
         9VGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FzoHwH23bsGueFkRH6QEwDArOwCSFYWZ1LidPxcYibc=;
        fh=P9WNO067BOO/z0n3WDu8YdLAYp+tgcC6WbfYd7MZwpg=;
        b=dQlZGMP8+N+qpgAX/hr+n8X2ZyMWkuUIJfpx63lo6k2lhVACWYcIY4GbNOeLxqrAEv
         MC9EFX3JBHCecDjrNFjh+gxXL/XTpb9kzs45cP+mzGzEE8ScjCY7E4m7q8MT43scmQpg
         y8U9nF8Az0iJugZnQJXzFyWiMLO08ReloLfjk4Khe5vxnBe0WQsURLhwRbo3fX2Xi0Jl
         4S6Z8fJTuTuKXIvg8xB4B+4FzfEotIZeGW60K+p0+pDl7m6AH9fZqYRZ7H2KVbsPZDQf
         60ZUxyYMLhj4KUG9PTRuxkdi2KxI8ytWBHjgbTzy5I5b5kOjOgm6zoEBNfMh5TpVzrnV
         /q+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781985734; x=1782590534; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FzoHwH23bsGueFkRH6QEwDArOwCSFYWZ1LidPxcYibc=;
        b=OVKPEovp1XXwNdOhuIYWIv9f9qT2ZjTYCvU0aVVso2qu8fJG4Ut7VtEbJWlqzGe4pO
         4795VCUbUir6zs+4u6pS2NzZ7M2/5kbZQ7ASjRpa86tBEKrWFi7lPgmAneW5eLVAvnnu
         SlKAyNXR+0abnn0v2KbwvAwUXINDMxtYGGp05nGUrUrZ9WVhytwX8IHZTE5T8qRnugK3
         ivLYkTs3D3kQylamPvtdbJJPsImTo3HQpEFhw3a1p1WBbsGjEps3qvSyPzAQPSCXADwk
         s9B47fh5OGe2x57yL85cca6Q0fFEc8kNwn+r19eiOdffzy6q8vq8d+4y70EMsRTl9yC1
         3trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781985734; x=1782590534;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FzoHwH23bsGueFkRH6QEwDArOwCSFYWZ1LidPxcYibc=;
        b=rinJW9QKYlKYDXIp4+4umjfxHZPiPNWgtEYMOUGKVID66pcHDz/rCw6SiPrD4h0QUS
         RbC+Pn45xpglQBr0D8bTe09Dkpwz4ufXEUerDcNp75z9LrMn//sDdusNttemeZ9QVrZz
         eieKWVcY3/y41p61DEpOd8tMzOoeVH6QXYrnatwx6vm1nt3dLNzIFRPfQCp7HMzytLK2
         biH/29t5mWfOBkrYF+VVs7+iojaMDPampTy/3+NyzOF2YAL5mqT3swiKi1bW2zke6ySW
         +HO+++BR6pSVPvo/CyDSpnte3brGKvRCuchyMoZ3k4pw/SXwk1r+MXfMYo+z8h7dfPis
         mSzg==
X-Forwarded-Encrypted: i=1; AFNElJ902RlVojqHGSvlH8EUfEOSH+AYKiDJly6F0jWlDW1wE3SxjdEsAbjI8UL13fnZgP03i9TQDyCzWQ==@kvack.org
X-Gm-Message-State: AOJu0YzkxfYwLSRHPMsmx2ykjz5fIK66lD44XCIyJBXXPEvT0aX0nJFw
	aA07avcbv5D99mOvVe4yE2/V5zTMkjuEKQPMWKXXA65oo7netJIObkUaZlz0pF8VrqukRXQiLVK
	uWDD9Sutl7CKG65Hidstdcn4Oj0otezLTDk1mdrBF
X-Gm-Gg: AfdE7cmQq1XratTciULFG05sQu7AOdnqjzSfgP4Fm3Xjl/j5NA5Onk2m9/CHDGZLh59
	QREGqFAG3bn8uhVsJ1Lcddwj5ON4AYo3pRwDlvxLeKjG0tS/UTxcw6GAgdSA1HxxaElWoUofk3L
	c9Sv2jxanltyJB7wTIkYrXvgphbduAfqCGpg1kyqHIgqMoyRYdFxvLTnNyTz15Tknph98XM9Aj4
	8kxowqJ99jUVpn3ZmLWjWU9l8lDx4laMMsif9Y3ByPU88D17sUMze5GBi+lDaHNF62B8t4WW2wv
	vzyhaEGHydLtwIJY7FBXXxxWEQLz
X-Received: by 2002:a05:622a:349:b0:514:b17e:86f3 with SMTP id
 d75a77b69052e-519e48c8e1amr16090461cf.12.1781985733070; Sat, 20 Jun 2026
 13:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13> <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <A886B02F-537E-421F-997A-26001F91295A@zytor.com>
In-Reply-To: <A886B02F-537E-421F-997A-26001F91295A@zytor.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Sat, 20 Jun 2026 13:01:36 -0700
X-Gm-Features: AVVi8Cf1hdAYEW-4EuMd4CjRccTKswkM4YKyFkMS_qsrX7T9ydIAuaQwHY8PudE
Message-ID: <CAAa6QmQ41BXNvixLZc6BCQ_2L0AkU-1Ce4V4n=pGDiTJpS+z8w@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	David Stevens <stevensd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9AEEC40015
X-Stat-Signature: 55wu6r53s9fmch5ndwfsho8npec5mzkn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781985734-844007
X-HE-Meta: U2FsdGVkX197N7hyIssY9Fw2moI8vGYmZrPXM3NzI1zHqIhlKuVoclke0fTR98yKegfg5ae+mN7qoheRsYrbhG2VA/ogimResJWLtaKXOngHZHfBDLxcVUC5aPj7xqlTCjy65OYgVkTANzWf21bIughSJvumizfK8yHBiywD6Hbxx71hVsVIn+f5omzdNhpFlTbblUe808VnrODz6Kk0RWV9hJIGwapBRMKdfOqLbJdIMwJSR+RnmZ/isBAiQXEa5y6MUzYeqQotbPTT163ZxRGjrCCxjdYSxpQVs4KSh+imanErJ3ocRsDIYGwx1IkkSsOnCCb9O1tMxuogMAB+PsyMO8I/DRYnK7qCwhQkbfEM+C+OdWL3E/uKh140HknlLuXVCaS1RV4oTBKnlnBHFt+zXo3rcYYFS50R8rhxpYnbekW9YFYiRcO50Pvb6P/KRj1hv/L6qy6Kh7tRy1KcIGdsRJ4bFK3x9S/MwhZRMGI7UpW34ee33YxLQ6sy+SohsmDSX9QN8vwy4JoeHsb4710C1/rgxNnfSTiwiJwbr5xifR1dd/vu8QDD9tjc1Ie+7tTl5MSyGHmNLxl+49ZA0+jfm+OIx/yotJh/8fs3s+/paKCZafptCEwVd9hSlwvQvLdeX9Y9zCRionETCFUHZxM7djSxlzwuIqTSJ6TcPRdYgaUAlhSSPA6DMJc94oIAQ7TviUw/BZ9o++iVKppex736xWmqzlbu3EYKa//gMVqY8qiMHva4uEWNIs8w2bdDmEx1XQP1dDh3HeHbrM1kbVYzUS15o5eiTBK9A8mhQo1kiGAvkc+SdvNFnaR+MmmBojouyeOK08B2tuTGg1w/AImhXjtneKf4Umcu2SMInZIXOKT0BjiYFBnENWUE5TSvihcTyM2xwyfdGq9iX/C42iiqBgowTdNHsGxFyzJQavdX7+OgIsiUT6CaM5DOa8WvEUA4UZIU8SXUQB7E768
 5LT9fXat
 y4vfggI+ud4+G/x2Nqd+9hGTOjLYRKLaUbmtpjaQDF1RQ9yEAHjNlHLvAgyTQlxB5vtcInp/f+KBEQ59iBsJGqeLQA1sqZJSlmjpzU4pSEyM2+81r3vVGDzKovGmRqYZG7Gkzrwm7RS2h38ubMZcNN1Au6x5TyWZdusCHpQ2I7RbwLr8xhDfDCVy3yVvZ/ilRB37FyteUEu+/qlvjmm6uC4+QQ8GVj8ojyRL6z9qX7a7W4f4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Hans,

> 1 PiB for a fleet only makes sense in the context of the size of that fleet.

Of course! But that _is_ a real fleet, not a hypothetical one -- and I
don't see too many news articles about hyperscalers downsizing :)

> But it's more than that.
>
> You WILL slow down the general case by this stuff, and so how much actual gain does this imply? What is the mark needed to even get to a break-even point?

You're absolutely right! Per Thomas' earlier comment, performance
analysis is due. This is a chicken-before-the-egg problem: we can't
get the data until we have a PoC to work with. We are looking to
engage with upstream early in the project, to determine what a PoC
ought to look like. It benefits no one to invest time and money doing
the reverse. I'd be more than delighted to get these numbers, once we
have a feasible (if conditional) path forward.

> To be honest, this and the multikernel proposal are the worst motivated massive changes for no demonstrated value I have seen in a very, very long time.

;) Glad I get to be memorable!

Appreciate your thoughts, and have a great weekend,
Zach

