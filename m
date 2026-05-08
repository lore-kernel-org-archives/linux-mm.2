Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED11CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EBC6B017F; Fri,  8 May 2026 11:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8F26B0181; Fri,  8 May 2026 11:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0926B0182; Fri,  8 May 2026 11:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC2366B017F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:27:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91F79120180
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:27:37 +0000 (UTC)
X-FDA: 84744632154.11.0926879
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8CD2014000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:27:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lmyIPBh/";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778254055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZFhWzWKrY72M1xS0S5a9KeJY9BJfFwwm0awJVZ6bjo=;
	b=eQjl2IicaRvExAsZKjMfIoVv1H+eFhYDLA8kwI+u3CtmooivNX7/U3E+CcX9SHr8TIpAso
	6pUoYI0SbOpgrfM7yzSU4vztBxksDCO9JZ31jbamK3umhU4ZHCD4eO14YvoTYKC1E4Dp4j
	Xeg+QW145iVeLT8Gu7COE4NuyKHBulw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778254055; a=rsa-sha256;
	cv=none;
	b=q4kgV6v//ZzNoGMTqSLMOnGK3KA3eJfRiSqKaACwjvKb8zCJZoWJEjdMnE4oSf10tEwQNZ
	jqv7pP2GVORqeSanTv6EWsZLWejlFsUquSYF6hho4E7WnVpATyixEQHVfq2ixg9nhMvJSx
	R1QhB0dmt56zSrM3XMq/hCUqdl1Npac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lmyIPBh/";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59dcdf60427so2160197e87.3
        for <linux-mm@kvack.org>; Fri, 08 May 2026 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778254054; x=1778858854; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EZFhWzWKrY72M1xS0S5a9KeJY9BJfFwwm0awJVZ6bjo=;
        b=lmyIPBh/vu5WPakMGV3cMkEEBXPN5ADY0j+SrQOAasmRYYSJ80FmPK3/g4Xi4wryiv
         eym6nCc8ZqFFe3K5xjwHOmTYwZvwCq/DJvrgE/Ea2YOu5Wqee66GOKD8TtogIkS+Ysm7
         x/W3NP+gcIP2AtC758JoE5oSSNx12itemmgLlRcRymh9vAL0X3rLj36X6Gc7ZeJmSgtN
         zElp+Ru4UzyR5r7dZPnIsNfM/32SNfBbmdn+Taw29RYAFlE79fGt2BRLs4wG54OXtRpC
         x0XNQglYPWVx6MyAxE1KQmt5mqaOjiSpZMJATstfhr/0bkwD/cyz3KWXId8KxY4du2Y2
         69MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778254054; x=1778858854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EZFhWzWKrY72M1xS0S5a9KeJY9BJfFwwm0awJVZ6bjo=;
        b=RT9zJE2kRTollAUlr76SBLLzrOxwL/mIr6TxA9cfA2Ipcw58hbcsk1sm2NUUr9n7MK
         riH5vt2pXo3oORIXYgrxWcW40BkMTTm0K/6EZ2Wbplqtlz1yHXCn/bgajhaS7zqP/yBy
         eckq2fS3AO8kWtKc5v8tE1wT8Ht68lGxuk68biuUOJ96ZLdwyFkzvMI+/e+AFmIXwqMP
         78PuPGcVUVG6Dzgjxj700DHcxMZ+mEhF8uCdvyrfKv/x28jhqRSvSQiXD6GOKc129c85
         q3Yu14yHtODNaNoO06sSsACP2mmCG538RBZAga1pBHhLBLJ0vziDpRXv7H8vjZPYjkjD
         LsVQ==
X-Forwarded-Encrypted: i=1; AFNElJ8g06BLlR3l2hpb/UBR/T37GLU6OEez7NqIndcsaw1pG0Uw9MJPRERLazS/+22LQdw41e1uE3zRbQ==@kvack.org
X-Gm-Message-State: AOJu0YzBxcCo1PFHSBne1XZCUBDjhtiwq0JmwIDvfjuG5+sK2tlQDM/D
	SmtAbMNbmsS4Jb+l0gpwX7p3i6ZTi3SzQT19cdqcYabS5PCjYtoDvZsC
X-Gm-Gg: Acq92OHy9GOdrF7aHm+N6swLl9VptJF1B1XmvCpqUAd3xkIb8e2aIOvzfdd7cVHkHBe
	RDQTX/OcspSY4kHMUXkiglPr7EbAC0c0oMDsmxVrWm0AjBrTUwuwagJJtP5lRx1fY2uY/wNkl3j
	joh37u5B2ZgisE+7XPp3fPQiUTIr2MHq7HF0207/UvjjgrdzLHxpa4kEabGFLT08OEkLolTc7Dv
	JhWuPSk5lyBPpEKUTUbhL9LIYclKS0Lp+eYB0aq/ubtDMe4nNjyHW/bBHC7GvEU6kMnolh5IMvV
	oUssa0SMVsIodIve8jYPmO3F44JPNqXAObaRFsbCIw0kOZO2xOx03EM5P0H+eaeFscYtJ2e6Iau
	pFOwIMnpeh4a9m03+bxMZURlUp7S0xRacWFV60Elc67uV5GJ95xQti8PZ5y+sushUhYJF2fS6kk
	E=
X-Received: by 2002:a05:6512:61c2:10b0:5a8:8825:15fc with SMTP id 2adb3069b0e04-5a888251621mr3730986e87.3.1778254052973;
        Fri, 08 May 2026 08:27:32 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a8b3e75c31sm86458e87.18.2026.05.08.08.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 08:27:32 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 8 May 2026 17:27:31 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 2/5] mm/vmalloc: use physical page count for
 vrealloc() grow-in-place check
Message-ID: <af4A48vNI1RR_Mm-@milan>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
 <afuMvOTfj977Bex5@pc636>
 <ed1a55f5-615f-42d4-805b-5f53ae2a529c@zohomail.in>
 <afzKM3qRDI5JOycs@milan>
 <a165e1ed-60ce-4836-bc58-96b4514861b5@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a165e1ed-60ce-4836-bc58-96b4514861b5@zohomail.in>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CD2014000F
X-Rspam-User: 
X-Stat-Signature: tbu1bt1agwjdo1kurtckctwfzrdcac3h
X-HE-Tag: 1778254055-424712
X-HE-Meta: U2FsdGVkX1+tcABS54U2ZTT5LMNUc1iPcTjPfxpUjKu1/Pc1CFrhu9bmcK30dt0cyIfBskbhYDAjjeiSg4X+XxT/tqRPYY6Y+GUxFg7L2feOP9aCPBXNl0ht9NsBJzUc2nPwyHoEnqf6roHAv8SodCeLnxVR9YuW5/9IYT7SlbMqXMlXUNqV3Qss8o2mK6asT9OmeTdBqHpbr76WI+ubOtzpnMtHu+Er2bt29x1jXsOGBN2bV6IXtz/CG14IMvXm3H59xHNs4AKYBsvS6GkTAtZ98uzUul+QfmW89s/7WGWY/KouRzX8sO2mX/bO9L9eNhSq51AZyXEUW9WRbCJgmXtHz2vgZTk6x5McMGTpcD31goMx6v6OuwngqxN1s2CTLiT+xrBeeK9xgLmz+ZhXPLUtQJ8QjUlTwxnM9vP44mAChvw6V3JxbAsWwgs7q53E+Y3Gyrwzug6AwG3tYBQMzUqoKsEI9ZOP4HIVRlCzRWJkOG11D8KKvMvfrHoXXS3/JvatP2Ruw5VNUnkJtEj0RTxqU6wsYvXhf5TWigr+BeC6OshZYiEldGVSOpVZ3MrI78p0e19VgmRENId5ylNOnNfYyeL3bnbHKvSYjoDpqf5z0IcQXdL1zk/tUyZE/EPb5jUb+/uhbVoJAeE09tf65xLUqb0+XwRwQeu08RZmxY5NFgXLIxk0rZUEHlqIfyaIDFxQGGuvosm8M4pIWY6ZJ8QDK4ZIBGAp80KOXdrFfM+feMk9I7ewR/S320X6ncP+yHdziAdFqVqTJrC7RezNF0wB4PGxeBtbN9tqTluLlQLqh9dRljBwam2Vo0tyKmZXectCGJeR2jSLvSBRfnGbc1hFNfRracIjBDOUwrZJdmI37SuB4xXGVl5rjA+4KelHjBwfF0VqCX7CQIaDWViukBIqrVmCs6jHARqKltn5BRjixYKZlVQcOpT9qKPqJU5qgbsHMLvo4irJOvBZNKB
 MbeqXb5g
 TF7mMEgLvg18G/5Nn/SUYVhIenBQhxG6dXThEUdmDooRhTUBvRsG4TQ091LMkQvnjErQiMkhMG60foFsb+XpJbqmS14Jr6oPC57u9vASObP3CzefKAJ2oQdR/gJT4/Sxqu9kOaRxBkq9nQZWHtHthuVbRxG/+gu7oAFIMwJ6ZIEJCCzNWYQKEg/LidHwpjigyRGQN1arIHE/kZcXyyj/gcuRZIzQDPCI7eHVfgh78OnNUuryNxlgsagfAmd+mFW5dPBDKgjD/6j2vdzaj95IAnhA7IX25I1/a8eHczV7g3jsbJAXLO/t1+rAWE+Uhm3IHFVmKaG52skjaZ6okN+sA2vKBV5593Rz8Mj4MwRcghB9q3l6No899m0o8fmrQlsqhEbvJhq9FfFEbCTcr1UkpXQW0/xuV9grSLCx0h8mJaWN7vmyjGOE94+Uxy4onHTXnofadzGQy86A9JCl3nRQDcRJnpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 12:36:18AM +0530, Shivam Kalra wrote:
> On 07/05/26 22:51, Uladzislau Rezki wrote:
> > On Thu, May 07, 2026 at 01:13:35AM +0530, Shivam Kalra wrote:
> > > On 07/05/26 00:17, Uladzislau Rezki wrote:
> > > > Maybe we should consider Fujunjie approach and borrow his idea to shrink VA also?
> > > > In that case, we do not need to switch to vm->nr_pages? And we do not
> > > > need
> > > > 
> > > > [PATCH v12 3/5] mm/vmalloc: use physical page count in vread_iter()
> > > > 
> > > > ?
> > > > 
> > > > --
> > > > Uladzislau Rezki
> > > I didn't want to change the va in this patch series and wanted to keep
> > > it simple.
> > > If we change the va, we will also need to rebalance the rb tree.
> > > I can work on a followup patch series if VA space pressure is critical.
> > > 
> > Actually it is not critical. The idea is if we shrink VA then we do not
> > need care much about the size thus keeping vread_iter() unchanged as
> > well as [PATCH v12 2/5]? at least partly.
> > 
> > I am find with it anyway.
> > 
> > Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > 
> > --
> > Uladzislau Rezki
> 
> Thanks for the review.
> 
> There's actually one more benefit of this approach for a future
> grow-in-place optimization: since the VA reservation is kept intact
> after a shrink, a subsequent grow wouldn't need to allocate a new
> virtual address range or manipulate the vmap_area tree. It could
> allocate and map new pages directly into the existing VA range.
> So for workloads where shrinking and growing occur frequently,
> this approach lays better groundwork.
>
Fair point, so there are pros and cons.

--
Uladzislau Rezki

