Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E43DC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 23:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2736B0088; Sun, 13 Sep 2026 19:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C8D6B008C; Sun, 13 Sep 2026 19:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D186B0092; Sun, 13 Sep 2026 19:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB79E6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:13:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A06A040A67
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:13:28 +0000 (UTC)
X-FDA: 85210292496.30.933C5F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D55DA1C0002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:13:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zYcVK2v9;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789341207;
	b=4kQoO/8YbAofw8bQQauBVKJKYEPadkMOyftJ14d8oKKSIOLCX9lW0hWHVHIcpUUNO9HJcM
	xVNAjQ8jmTg44c2zlTWNUjQxuqw+IB3sP+8JzSBtwMW73lJiWi9INpYBX6hObTsIKFVYI5
	zynbzwOH2xZw6Q8AbPfRVWAwS4rmGUA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zYcVK2v9;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789341207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATWZYkl6gXglOV8R8lb8BXtXhjp6jIzf5yrr28mOYNs=;
	b=Ag/kjzAY5aCrLHm004OS4b3g66EE5GeGdLCbL2h5ijhlpsD6XW0nCM/sH4oyVf4YZdyv7x
	hcPFwQkUH/Q1Tg9zCcMW/joX2oDUwrSUVexmuXLGE4rB+Mx2fv5OZkz4zrLwNZkY8723a+
	oawmr/mrVzwn7DURM9jvi8caUlg2wsI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC22444A33;
	Sun, 13 Sep 2026 23:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7137E1F000FF;
	Sun, 13 Sep 2026 23:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789341205;
	bh=ATWZYkl6gXglOV8R8lb8BXtXhjp6jIzf5yrr28mOYNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zYcVK2v9RI+Wmrk1Pu/ODVTZVKmwrwtmA10ni+A8Df4mUkVqiqiHgZ17gT8F0Yk/e
	 8KrNTD5UxXB/Eu3m3D9iDZNRpciGWIfhP25vAmNkLOIjZjL+U5jw/9/Hgo/5iu0TPx
	 7VNRpXIZ9/204VZVozy6ul97EjIYHuLym7P8C5mA=
Date: Sun, 13 Sep 2026 16:13:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Yury Norov <yury.norov@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <liam@infradead.org>, Chris Li <sparse@chrisli.org>,
 Alice Ryhl <aliceryhl@google.com>, Andrew Ballance
 <andrewjballance@gmail.com>, linux-sparse@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH 1/3] compiler.h: add ASSERT_STATIC_STORAGE()
Message-Id: <20260913161324.8879b42314924d8264447f45@linux-foundation.org>
In-Reply-To: <aqXSkthkUVJNu2FD@yury>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
	<20260911221444.1523311-2-ynorov@nvidia.com>
	<20260911225749.8727d23eb76b93141f08e574@linux-foundation.org>
	<aqXSkthkUVJNu2FD@yury>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D55DA1C0002
X-Stat-Signature: 9wh9nammc1ot13rqrbb9ahpzt9bfhuqs
X-HE-Tag: 1789341206-80793
X-HE-Meta: U2FsdGVkX1/DdSywJrqn9ydwiFFT+8T1oNdvhREGXkCsqQXBLBuOrC7BlynIW4W1ThGV1z8WkHSJq3sBNHv7wLM6/oJgF6t86T8/W4q/wPS5qM4RLSHb6TEwilwoaz5jyeBpeNKjRVn36Ds7z9q8OydQX2gSz45faUyZLcY48cAJO2ky6oKdEgnh0FPNmT6UBJe5DL1P38mMaui9ugbn6kXxEhCGHJamRYA1f/rZ8ptgLG8dr1eYks6EjsmmPfN6elZ7esIHiZV31da8rYZGpcD7Xj4TYKyhjUK6q9mLFRjU2Bw/AaFlE0SoF028sUIjZvKwm41FEuaaDT5p6sFvp8f/9wQ5/4aKP1p4JNykQSGq3MhcNgi8hcVymZDboOM/56a2X0to6hfGWhHca5WhlVJohw64+PQCz6/GR2VPnjRNRki+6cO/sTq9cTows/huXwLA9Bi3TPVyZ/Eq8bUltZH6ODcPNX0zv/Qd0awZVNPSl8p28JmJ/X9GpvKN82/j9TSqqclIghiXEnG74C23kJuwGye1noUjpJf0R67ZC7kdFnAb7aC/A7Rwpin1YQNPrtqkx3axrluyCqk1osixFLz+rql1iwo3uuJqLrDLc/2NxByZSRZazDySQJiE+pzUgyyY14RufGX6Q0KGEHcuVW+ZvSlKAojmSdwXWHHfagxfCbhv0MdW7Qt7zMrvZ333C3x7U2GWFxPwYHW0r78//AeWz0XT4tanVRJvwLVF37tLqLKqMND8CxZ5XL8KXL094R0A5SXS96i6N2hXRI/Twr7L38p+rWB3Cia8jA4+88NXff8knX+O9PkU4kXlZs7JR46QCU3N05m4+HXCGy81uYp1fEYEtVa/EMJOdWJDemTgYNhyIXDU9SykjvPWTULSbpVTBYp6tEX+kAN34Y0N0VigJTOJ5LS5Q1AiYyKRf3+nB7uOTCizGpS37VuxNJPA0R6b3mxTsNvhL6UM6nX
 O+CfeiON
 aOudRq3tGzam3iAa7qjoaGqaygCV71yNbTUb+C7YrZp3yeZhl0lO4GzCIKJDnxSy71wO/a4vGz/5USQ7DVe0cyU9uo2stenmFsG02e7opgYRbDdddog9bxuQCMC5qcgUxbZFCOSznbzkOYSe3eX3LjWL2l+N5WfCC+ggRUEi133myqTc/xINaWRIsVQVLHw8BoBuT/W81p3A9YWrp+3kNBbIgK5sgxydiKMkKAasnRig+Pr3UM3Q4dP5wflTjnxYfNHpm3pYPLsujWwdFPGsycy4++STfRUKbaU9mtSPPLgsyBkEbht0QqS06HZx6ioeLHPr3sjLUmSp0rtGdFL/ZBSlotMN/tTrQhR+FS+BzMIbDPoCXcRg9cx/EA9wDa6aXfPaoHMN4sNbqROjInvoawHJxFYVN8kdytVUClkSmeVQXAceCzCFbLsDpR+LkhUPeb98UOgdli+ds8nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 18:31:03 -0400 Yury Norov <ynorov@nvidia.com> wrote:

> > 
> > Thanks, I'll queue it.
> > 
> > Sashiko wants the same treatment for a few other macros:
> > 	https://sashiko.dev/#/patchset/20260911221444.1523311-1-ynorov@nvidia.com
> 
> Below is the list of candidates that my AI finds relevant:
> 
> [long list]
> 
> I planned to submit this hardening for them per the relevant subsystems
> after at least landing the ASSERT_STATIC_STORAGE() in -next.
> 
> If you're OK to move that material through your tree all in one,
> I can prepare it as a single series.

People often do this by sending patches into various maintainers.  It
can be pretty exhausting and unreliable - maintainer attentiveness
levels vary a lot.


Such a series is applying one concept in many places.  It's justifiable
to do this in a single series.


It gets me shouted at, but my preferred approach is to take all of it
into mm.git while ensuring that maintainers are cc'ed.  Results are
among:

i)   maintainer says ack.  Great, I keep the patch and upstream it

ii)  maintainer merges it.  Great, I drop the mm.git copy when the
     conflict is reported in linux-next.

iii) maintainer says nothing.  Oh well, I upstream it and hope for the
     best.

     iiiA): maintainer later shouts at me.  Oh well, I did
            my best, read your darn email.

So yes, send everything to everyone and I'll do this.

