Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68799FEC0F1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 18:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CB46B0005; Tue, 24 Mar 2026 14:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D7E6B0088; Tue, 24 Mar 2026 14:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6635B6B008A; Tue, 24 Mar 2026 14:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 537FC6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:40:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06205C1AB4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:40:25 +0000 (UTC)
X-FDA: 84581822010.27.A95C6CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36391160006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:40:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kFJ89+fG;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774377623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bm2DQa2GYTi5I47Nls1Oejd0BDJQh/8LxOGBSDEDVs0=;
	b=7LUWcI8v9HOv0xqYZSmns7nhTHmKhzYnYUFBuyXAXIYESBFF/PLOMfrgGubHTOgtBrx+RR
	8aZIHZknlEEPReHto2og63udBrVusZAnKjnpJDIJopKBmJ4a8EjFXgdGyPa+5DYlMFb2ki
	TbD3uD5dsrMaUBBhBCSbblmmccSkCKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774377623; a=rsa-sha256;
	cv=none;
	b=k87tgMTCHvkemGjK5U3T6LDQ1CsEkDd/MEUeO93yf9PWVqilrJBslihyFynR48649os2eX
	ToH5jgQcu5pyi00O0e6KodTy+iBAHtGval/Az+1LPk3j0grQH2xDd3vZzrBkYCZRki5iGZ
	1PHIDtYA/881R1qQHSldtlC8s6Vd7oo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kFJ89+fG;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 835F7600AC;
	Tue, 24 Mar 2026 18:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC37C19424;
	Tue, 24 Mar 2026 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774377622;
	bh=tk4vAe/SlzWEtNRNQzn2PzYDvQaUHgUhyhyKZV0bgyU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kFJ89+fGi05G95oqfCS3SFBdCraoKecI2LmebckW2CMBtIBEpEv/vnVZp+8Aexalt
	 FH/xCH4cHAQR7D275Eqk/AhR2uBZLPZwAlcEaRvHLYgKwG/I13FRM5v4MfrEn9P1Cm
	 wftS+yoeWmj/+eZNR/MwYcDnWBK5PyLMG21Kfe1g=
Date: Tue, 24 Mar 2026 11:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 linux-kselftest@vger.kernel.org, rppt@kernel.org, jack@suse.cz,
 shuah@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, dmatlack@google.com,
 pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
Message-Id: <20260324114021.f5546d2de5b6a2b0490f63cf@linux-foundation.org>
In-Reply-To: <20260324-langzeitfolgen-altgedienten-ccef17d19349@brauner>
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
	<20260321175808.57942-2-pasha.tatashin@soleen.com>
	<CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
	<20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner>
	<CA+CK2bC6S7pFCYR0XS1ZPxw9HKjWgxy=0DkszYNjMUi735o_1Q@mail.gmail.com>
	<20260324-langzeitfolgen-altgedienten-ccef17d19349@brauner>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 36391160006
X-Stat-Signature: qjufx586pjmw53j3mrt6nchnc3g1xk47
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774377623-697703
X-HE-Meta: U2FsdGVkX19kMCHuS83tpT+LN0nUZSn/eZHR7x3eztCcW6Vc/Lo/JyliPME+34qJveToltj4favqOiNNZeEv3r/RGGFS31JA48CtSp1A5SQAxQD2sLs7X0xjcH1L6lyySc7UayPP2ZSDr9nmERelGTYthsNEyx84fXzxciEkVJNzvsWvoryat+onibKZ+V+geCd9c1OGe6KWPd47OwlKPLaaV+jZEJYMzqKAoTddTDKVXu8ieyjuMzPB8xWraXBCk+appMKxTgWCHp4nfnVKDI0jdGhSZrHF/6wk/HoUhTkrgFg5ODxmUykdaCpy5GLBQfK6EmFQcOM6pfvN19oGxJTxsQI8yiSh/yh3eclX7/fe0ZLIApi/I4JHxR10x8w5symlTPJ4CSmXjYFcbrC6Wx4cNmip7a33vwcyVEThdbVASy0+FQz079NfwgZuMt05XbArjJSLzkeIV4z+SvelpL/tYkb9kIdFCTw3Buy9BwTE8b9lo9XRb+x9AGnRnWQP/zGMpx7Hm79vug9U+w06hM4hqVpCRnR/glX8x3FYgip9WnW3pMtZEtbH+AQLN9k9VcM25DogpC3yU7Rin5mFGbwGYC3OT9lBjptjR8SqI8oOAw6J5Wy9V2ohh9dS1rq5W2WcQEozoGRxLsXUK4C60pVpqMWWmhxNtjkQXyufK0iEEnP10Wfo7RWlhkWPOpsTEbT2aRYY44YT8EZ+fETBkgR6z+wkffYUYu76aLFTEmChznCE3oooZ6kLIZ0oX+wJ/0miHy8Zg6AMdfNsdRZuJ5TQNji4Z3g8krgPHm3UhO7srzW6cr/M5GPothenhKEiqDvS9O1NdT455mrm+xsZ+EL+WaI+jhDdvlFSUbrXssYCUCnsTul/8jz73zQHWy1e40zWXxVmtfcRzjDqaBMVQcmzY3HrUg8kmgNzV21WkfKiGRsJmc2m8xgcFdJk9XJ16M5kRgrnvFkxXZUjH9G
 A2LTW/YQ
 VeyvdZdpO1dKawySq1FPjOwBKQ/ccGzfycWCcO5AFUcVlAvm6ifqSG8hgEvMTNaLrdpzolHuY0WHPQT1V0tTuZFS2zcZLV2Agki4U2N4oQbGWOXeE9iHN5SY82m2Sm+gGSwjuQ/2hRBVR2teWvLF9hb4kNue2dZXWODByB/gQYK0R1XL0TET7GoN0iA6//CjxuK8f42q7+DtGpd8BkgVGOUD/wDM2XaloMq0i3WlgVrN4QlTpHmEa5J2uPiNqb3nyz2COmSnrodoP46rBJ54p4TYgvKvY3ofvGIU9fzLZTHQq2w1/0Fe9PQZ8oq2AIiZma0PNTII2b0UPrzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 09:51:34 +0100 Christian Brauner <brauner@kernel.org> wrote:

> > > So, I'm not happy about I_LUO_MANAGED. I don't think we need driver
> > > specific stuff in struct inode and not in i_state. Track this in the
> > > driver please. I don't want this precedent and I'd rather have you get

Well dang, I just merged v2 but Christian wasn't cc'ed.

> > I am planning to use an xarray in the next version.

That's what v2 did, and I_LUO_MANAGED has gone away.

Christian, does v2 look OK?  It's at
https://lkml.kernel.org/r/20260323203145.148057-1-pasha.tatashin@soleen.com



