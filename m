Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9D4D5B86B
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D257B6B0088; Mon, 15 Dec 2025 15:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7D16B0089; Mon, 15 Dec 2025 15:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B946B008A; Mon, 15 Dec 2025 15:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7356B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:46:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43C1EC0373
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:46:32 +0000 (UTC)
X-FDA: 84222888624.16.D5E2BF3
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 220111C000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:46:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=G4CJc3EU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765831590; a=rsa-sha256;
	cv=none;
	b=4Dts7+/ioFuTsiUXO4PV7dqT4wcn0ljwzRnWclAxBmNO7H57BuhksSUhFwR65b5gWq6kDi
	GMHyFI8ar7nJ0p9mywq3yPOwfBRhh+4kW/z4f8UBt3J0p066pm0cw+Q2sX1XrbwwoXTPlb
	bg/76598ecXzjeY78HzoXd9jpMjwHmg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=G4CJc3EU;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/5OmwgaCDghH9Y+B9p9dsz0t3uJjAxYmjjcZ3Iaws4=;
	b=SOcZ+D7OJfo5j+SBUaxGR7G+9L2RHvmJGgrxKFKnftkfP1v7Tl7WJ6kfHBCfcWSB6P8lQQ
	/STR/HXOclEzODlfcGhWDE+3RUAXMxVvRjbPz1fjSpVFqvtf94RNGwouUfeKPSuOd9qzvG
	mS5BIwDD1ZVl3A6XH6r2mVptlOymeww=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88a379ca088so13799266d6.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765831589; x=1766436389; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/5OmwgaCDghH9Y+B9p9dsz0t3uJjAxYmjjcZ3Iaws4=;
        b=G4CJc3EUkAQmkCGNijE0pzxej+UB9pHPZ1Q9MoHPRnwWhAhQaVWwcPUUso1JRIESAP
         iTJJmBL65ms4jYB9S4ZSJutlFU4EHyILruEEu6k26PXav7VV/Y3RdhIJS6y8cAUQot6E
         BGB17yEQBPCv+Yg49YSuE/bizAzvV3k30b1o0xfwFpMIn2hkd9BlSRkc2vFuJsXY7v4r
         zCmwLN61ovesamLLT1fBhW9srmvltrf5mvGO6G9c2ZIh7z6zeCt85xt6ifPEJDaNGlfY
         qG0PR6xcK1slYWhoSi3/6/s3IGVaxIEl6DbFbQoFXgQ88ieLi0LfzWEkq2Gr/g8+2dk0
         fYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765831589; x=1766436389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/5OmwgaCDghH9Y+B9p9dsz0t3uJjAxYmjjcZ3Iaws4=;
        b=nHFP2w2pR54eHhUB1/RDqOps0CnJY7+5YVCE1RowURLw/pFTmTrNzrzGMzDBq9AesA
         hdpU0Wx6/w8mP4dkshxOKpvaCiC2M2Uj757EWhlK2bSlUKKsnCJt0z3ToRVc5miF25ib
         z5/Z8DJoek1E//QgaIUy2XFbZDqI8tMrqYSr59DIRAqTLV6MVycdS4JYK7heYSy5kFLs
         3FZ9LOR242Y6gZyiSw4YqlUrf+QzITcxrFMeYgpAhiSOvcdh8Egwgi3J3uSjdTo9Je+p
         RRZk51frtwJFKNv1RsjaY6O5Aq/xPLX4dtd239GU0A0tvI04v3zEC3+5YRiuHDQj+sqe
         W2dA==
X-Forwarded-Encrypted: i=1; AJvYcCXaP3LSvJ/vjERMbfGz5jyc/GXuN8UGlVIZw8aRqoBoS3GmTVF7zi8pDWN5SHrVfOs0zsqIeS/fuA==@kvack.org
X-Gm-Message-State: AOJu0YyXsn756mMAcF3xB6eBIlErjF2We2b3py3l8w9AA1lXCqkE8OqA
	bb9MaSIukHgyrQJCYjj5mDVvSRJCNN4z7s9PbimYJ3FnZRO+Ct8ruBLQRiL6nh/OzLs=
X-Gm-Gg: AY/fxX7Ve3BdqYMA9tMk4xWoVIt2EHbb1jbcG5tjo1SZrG8qekpY/90iwVOgjNsQ2JE
	xkbM+8LzxpnOf3nPjBCBc4qaoxZ0caJlbE72Sr1a7OHwVsYb930UL3vo5EOUycxlQXS7T6vGR2Z
	g6RuItYV60kWDzerqkCY6kOuKopYkjEhqALvUd6ASwZCZtBkZftAyc6eVIvhkbb27WO9OyqVUk4
	OIKEe3rFpz+5Ft2KFQiuYsQOS0nR8Rqi7RbiVYFNmn+xNGYchJ+PquXRMC6K6CbeQkjA69ZkBKh
	p3oYOMoKGzV06QM1gAgbfSOmbvKerdt2Zdu3KQQJT0WsKBk49hDMeZdzqQBVdDp2tfwSiikBTlc
	e9smdiLQXWdx64J/xm+6TqEqXkcdC3WWShcFlGAtwGtSA2+FzaSfXgoXeB6F7SF+7PnM8M4EV/S
	zyA3x65qGokA==
X-Google-Smtp-Source: AGHT+IEECaGepI8b2WL9DLllMIh/MG6dmTXrWRWKDLKwFMYbp3fGB5X/Ym5XHJbEgAFZKvqnX0dTkA==
X-Received: by 2002:a05:6214:4906:b0:88a:2f0f:c173 with SMTP id 6a1803df08f44-88a2f0fc33emr107185346d6.68.1765831588949;
        Mon, 15 Dec 2025 12:46:28 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88993b41dc9sm59677586d6.9.2025.12.15.12.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:46:28 -0800 (PST)
Date: Mon, 15 Dec 2025 15:46:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in
 try_charge_memcg
Message-ID: <20251215204624.GE905277@cmpxchg.org>
References: <20251215145419.3097-1-kdipendra88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215145419.3097-1-kdipendra88@gmail.com>
X-Rspamd-Queue-Id: 220111C000F
X-Rspamd-Server: rspam03
X-Stat-Signature: txmqjkp1krsdwr7zsfb48ag5y7cin4ik
X-Rspam-User: 
X-HE-Tag: 1765831589-280885
X-HE-Meta: U2FsdGVkX18TLfh/tBcZQRktFHGdqZzTTdCPEeKFP4FbQYNSlHYvdzr7UqBV48UxXjVgWe/2srCvevLgSk3FYwQwauYHJSjXO4B6RDuvPE0tOD2Wr5zAFucJskkcW47Ycw5w1cFCfETbUp4UNidFABYM7/CBPkoKadL9h4xdgS7WivYjgOWoycK52s5DUbWf7/lm1gXb04TlffTyQaCkqgxOIC3v5jDNbpoyuysPdlC7uol3v/VR8+W/GSWFWd2blpPKNmMuLhELeUmdPIwtpGOf5gLEzt1ug7uPrDDzBT5ILQqKZlU5s9OrfOFcqyQqFgG6Bb4fUSu+t2a0QcQi92rGvEnaxCe5xpKKL2BIFToevUoaG7fEHZCNLuLl8wK6dqwrNN5YmlTDWfNPkjG5tL7cH8xIqkyGXqXpASFq+u+Dlve4oUSws2kVHOzuCHCWeIRfekEFM4hDXyd5DFCJDmHyyLoC04X7xde0UEeigQk/lMDcmUtHLKzNL1MdpZzo0sOytuUHeBkq+RP7DvILvJGWNpfdbrGYwFX099e4tHMpzmIWDPeZVx1AMFxKoqWTNGzOynklg5WcGjlw6gw8C/GcmYXTDILrkK6NBYSYmyfJV48Rqt2/nMutNwwo9XLj4BUZGFPtb5ttV0dO2ybA6945792h6mdagGielumWMFOk6F1JEVBozf44hbJ3pZ+MSRldiG1EHNuMIjrh3uedpmLyI1i0aiMB5bWnF5z6ep2MnZ0ToTxJvunu2sTKkrtTtmscGEZ/FRy3ieJsaGM0zL6qmUcMxhf+isOdRcSKKGl0lOR6DJ9NLYC22F7aqM/1rVVmEBE1drDpTv3/wbpP1vctoNFNaEQt5yMfKE+8u3VV+R8hpfGO2f8OMYedmgJo20rLXQNXhVc7GX9P2aFiOjVLPOeWNQqILBhCXR9G+f1CaRVnY6qGakig77F99Wt+1c3HQGGDdZa0plP1lEd
 qe1PsAtQ
 Cj/PqHp4JmEkdQW4iCfEkYAcamnXjPXhVux5zkxJJ8gmtzQ9elyb/E01fQdZ77iyTXRaiNwTO71BM01QZQ9kDKJkTSCiMiEWAQmwckwPXawsy5tWF6DAq/sYXx9NF3hXaEBLd2kGjK8My+H04pRIiMqIjW0oiWRIHMXiY/eIwGK7zwrR2/n288EuhwQZTgFChsN2yvnfKNUD+UrvOJ9SJS+p959OFkah+OKTpAFOxANQyomYkkOTxtx9dbTWNLyOO6hLaZLma8l5jbACfPezIFVifiwUfSDzfDKOQLiR423YQKcJOOcOG5t3K44o6uTaXbg6vYLXLLMHcHSe9OxBR2kjygq4w/9yFnb2h5Xddt6H4VV+TpDnm09hpKkOa+oXRCXgPPbgHZ0209EXcByNvaeoP1wuvzo8Jqy4UE9+lAAiUo4dHv0/QZXcevLt0ZufMdPNM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 02:54:19PM +0000, Dipendra Khadka wrote:
> In try_charge_memcg(), reorder the retry logic checks to follow the
> early-exit pattern by testing for dying task before decrementing the
> retry counter:
> 
> Before:
>     if (nr_retries--)
>         goto retry;
>     
>     if (passed_oom && task_is_dying())
>         goto nomem;
> 
> After:
>     if (passed_oom && task_is_dying())
>         goto nomem;
>     
>     if (nr_retries--)
>         goto retry;
> 
> This makes the control flow more obvious: check exit conditions first,
> then decide whether to retry. When current task is dying (e.g., has
> received SIGKILL or is exiting), we should exit immediately rather than
> consuming a retry count first.
> 
> No functional change for the common case where task is not dying.

It's definitely a functional change, not just code clarification.

The oom kill resets nr_retries. This means that currently, even an OOM
victim is going to retry a full set of reclaims, even if they are
hopeless. After your patch, it'll retry for other reasons but can bail
much earlier as well. Check the other conditions.

The dying task / OOM victim allocation path is tricky and it tends to
fail us in the rarest and most difficult to debug scenarios. There
should be a good reason to change it.

