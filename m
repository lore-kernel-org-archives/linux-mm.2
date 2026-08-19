Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC0EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C4B6B0092; Wed, 19 Aug 2026 10:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC356B0093; Wed, 19 Aug 2026 10:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB926B0095; Wed, 19 Aug 2026 10:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D777A6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:01:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E7A51C197B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:01:53 +0000 (UTC)
X-FDA: 85118182506.23.08A14D2
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37F9EC0015
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:01:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDWrjWTg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787148111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0eP8C3MD/1XTUFPJjOKDCS+YHCSoEwR1bOqUPa9ex8=;
	b=6WTGFphJS86A45damKjKXYj6aSTE7eM8/DpWGGywQHYqE9jitJBn0lVC2FbfEmZKCkI52l
	JBSNuE3KaS+ZsUr+xJJrxb0m+oLkXHTsxESfHR9oUZKJFo3/EOCOB9epxsBfLE5CAG9Lqp
	65gwtmtMBb0Fnal62usAiDLiGAAo9hY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDWrjWTg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787148111;
	b=nkhzfVhkUgMD3N778Qu+MSUNACxR05KXIn3C/HnsOBMIwLRpQy3Q4Luv6H20x0gaM49UVP
	mLF0dLOiIII9VEZ+ryHQDz2KSWALVepghgT2RGKtxAybVJ/AjlayIKIl4kJxiS133Kl6cz
	PWz6AKHihOM2X7+Gz3lFZe1YaBNGtI4=
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-74ab99038afso723033137.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787148110; cv=none;
        d=google.com; s=arc-20260327;
        b=ELhhxfpGbg7iaiNZrfbGdSNNZ1Z8oj6BUK9MkMctQLZL6MbrmEPczULDB9w2FPk/c8
         +kX1j63a/V9nsuz3m8pQIBZmALVDB6tRFKMDZTcRknFnf+afK60QE5oQKRKoQqqfhwgN
         7Pn8uiwJ+QGuxI02iCOpW96xbv4Q6PgseYbo1B5ghHJyEMjXrK1dxs4BFgJzukzC5mH8
         DUq7f6dQKv+CAb/HRVQ1b9FTyNqUiLDkHVNHIm5FhLV1ugW2zaXrmoi9ROBp7xiI2M36
         fQ3AKx0FDRnWnZb9RllrV9CqhV2WD03jP66CoxVh6SGvE4uS8hMvLUyPDrjk6OFCH1ox
         NtPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=V0eP8C3MD/1XTUFPJjOKDCS+YHCSoEwR1bOqUPa9ex8=;
        fh=GHKGhWyoALEEDXeClJI8QEa4GyT++LZBJr8xIbxgbw0=;
        b=ZwSAyNdhGGJhjjFNclaBJkuY0B9szMTs5O9m99bx4RxBsret+9BuYlp5rE7J2uydYC
         3zY8vjX3Ghq7jeDnYDrAyvJhbuF7kSrHDhH+AJqeGpQ/53g0g9CbKl9NEnHIhIBXERjc
         XjkrUB1QBSWn7+ieawPINqln5OBvZBpqhzaeuBQlzxHyZnCibJ1cxv0kbtVYj+p3iPLa
         Z7M3D724+n7E0229Q3f+3go4963VQ/s+8k3SwcbH+qLUa/7ZLpiwUoLjqs8WhTpPg+hc
         7kvVhSUdyuCu17lo357OUxkZOxkjsXlPLA4yIplubVweP7egHaOaX4/YhaOoQnTwVO02
         Qhow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787148110; x=1787752910; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0eP8C3MD/1XTUFPJjOKDCS+YHCSoEwR1bOqUPa9ex8=;
        b=HDWrjWTgVtljCWUKtKtoiwRce+cY6CiUVq4DM8SC8rtxjZ1tvZlJl0VXWRpi1ko14S
         TGQWFvOoDeNVswmirZhFjmi62W4Koj2JIh3N8dmn4nv7Vqni9Pa2uBN7qlZJ8vhwQXZk
         yaOQK7t8CJQddbcy6i9CQaFumyhuDJhjzXlfaNcIeR4OHvhLa+XNWhmFdRGH4cowMYJM
         tzaLiihswa2CKRVYpHYwendjoUPtZHCsK37JHSzdD6PEEeHzFET5tSXDiUlJ9CgspkPs
         9bYq9CiozSYQS9CW6bBL1SFk8C/9hxWhxc3IA2SzvXTvO0SVKGV4CrxedlxqgPNMZndn
         7yhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787148110; x=1787752910;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V0eP8C3MD/1XTUFPJjOKDCS+YHCSoEwR1bOqUPa9ex8=;
        b=GxTZWj8Z/zIvT7e+7E7aRQ7Xj3UqmuFIFvvx8QJzsf7j2KBWpJKXQs3SeT6WJmM+lv
         fxNVNn65ohQfXOMTDI40XFaIwH4gYlY66zgqDV9jjmT/gkq5vCqMOrokjM9+R7ha0PIN
         pbJkNTcVkPMP1z3K/nsDQbZjTtJKX9DzocmDJ0hQk1li4WjJ1nEUHNRLVMhKT48okwh/
         k3cD4ZaseSC9gbhO0EXQxuF8AU8/I936Tc6K1RFeBLY09vCsjEtyfl+iSuRYBVvVva56
         26Fasll9gO68HrNjLeDnIeeqhj1rRMprxUV152XmT2coTG0eljWW4oXVmnnHFJz66xNX
         p/fw==
X-Forwarded-Encrypted: i=1; AHgh+RqCh07XyqiIdEtlnJ8vVDQOw//4H0M0AwjHrfUF0wQaULhTw5NqfhE16s4QA1RPxwC4LTsJnWb+0A==@kvack.org
X-Gm-Message-State: AOJu0YyvN66M1mRk3HBwqedCAmfDSGkg0yzUEqNId/S0P4R4B5iTUMtj
	BaBQlOCyZqzWUf9H9UnT0pzQksiT/eqLf/Og0RKCyp/jWzGKlFHd4HRB5tXCZL20JBrdIyG10t/
	EX2E0wwgj7fbVHSzumdJD1Wsqv0WLYFo=
X-Gm-Gg: AR+sD12bum+Xz5y1CnhAXsUKunkuk/Hl/czr8YTbzwFiAgsaIAFQa07V3wb9eeM06RW
	ietL1YRXxU7NRQL4ajZ8dE7t1xNAleAyJlPucv4eXHQKf9Bu5N4PQ91gjICzx1E45jw5vyGZWS0
	hM29ndEX/Zs1tXbq/lZrq8+s3F2/a7uvyJh4GHkJA3858VaHD3N52KLiXTybWQF4FOZG3INanZZ
	XCsWb31KHIKrgeW8ka7DWbM0h59r9RfD+O8LQvNRD+TPZNA92vQOzqJAFywgvxScMowZSajKGWr
	cOxz6a5y+uhPTD6Ig0Zp2F5I21FxXbG10U8OvJK7tejk0YWVSNAIrcsEh+nEr5xBK5KcQLWZvB7
	d2ttMw2RkOZJw3QkavhEQgiNl46yA9edBuCI=
X-Received: by 2002:a05:6102:3fa3:b0:745:31e9:f3d2 with SMTP id
 ada2fe7eead31-777faba599amr1810757137.10.1787148109778; Wed, 19 Aug 2026
 07:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260818154954.805958-1-joshua.hahnjy@gmail.com> <20260819132211.366064-1-liuqiqi@kylinos.cn>
In-Reply-To: <20260819132211.366064-1-liuqiqi@kylinos.cn>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Wed, 19 Aug 2026 10:01:37 -0400
X-Gm-Features: AcwNN1Wk_zfxAEQUa55V6akVBYfQUp0TxVXvvcg1HWKP4INqIpWdP3pLw6aBH6Q
Message-ID: <CAN+CAwPJKGMEyxp_YKVG38Tebw=6yCiPF0ihH-Oj7W39t2X9TQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
To: liuqiqi@kylinos.cn
Cc: mhocko@suse.com, shakeel.butt@linux.dev, linux-mm@kvack.org, tj@kernel.org, 
	mkoutny@suse.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000003e929c065966d804"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37F9EC0015
X-Stat-Signature: ghfcmiopkyu3zmdirrikmxtkptsr7e8w
X-Rspam-User: 
X-HE-Tag: 1787148110-453980
X-HE-Meta: U2FsdGVkX19G9lOhXqy2cXffry3xKgp/tmDLegS4fWsXz6nC+BkkuofQ3cas5DvpBkgnDrN1AphpF2fnA0pWrYjqpN+YbD62hiHWpZSj5dSoUg6MAW3LjxrrBpbOjPe8hyZIzjjVFwltbcQ+EEHrl1j2LC6D8gPemhjkf/SccrZ6eLsgPbPpVJ0L/v7iskgaAQOZI9fxOQvFhs/qWDOHpb2e3OC98R12OfTd9VCZNnavspToc28QuTHZWKNSnnGMQXrj6sTh1pKBVvNh9Ev9J2OADsz/MOrXDx2wrR0cLEBksvw9hB6GjN1VZdX16h/2AmnRGI/1P/6hJnfTqUhY7tkV/gVSMSL3lMgKcxGEdNWOFZrfoifXnRsdnIggBKpfGzwRjKqJ+Fs7CxGmyyH6OwyiqXDL4hPXx/+pN3LAkvxQ/4XypAg+5yya8beB28Xsbatq9yj4BoSiFJtj8GYe+8AC6zXSI8hNJJiMLe8Uuk4KQzIRo8JRatuCejqHQOcaw2GaITLqW6ofThkWc/DD5Q0VXxYNOopLpIZnpJ6W7q3qLCph4aasYZNbeKR4uxywvr4FwXAcnOqEB7dqYY4q/ffZwvrNxhJJGgNsRq8N1tDUca626Rc3ym7GGnIUrV5lRt2D9TTtCQO7NRe+0sP1kjLs5ffzhR8AzpWWAKgTRnaEkZx8HVMERrdoFbgmR/WHvxrNQd2Duyp/oPoiWQiKMjMG5JRykOh854dQMqbqqVRYLu3GW4Ypf9WAvd5htd6SNHsr5BJYZqXjCrrpPOkyK1oZnsdlEOFhVGKsZc9uQFwa5A9H32dYlhi7Igtz4OOlHt3w83ej3xoflbKkvO7DT19KFpdk3IB8zN1J5SitJLrjBQ7xoyLuXOPq8DbsxsnLNmPJ7XoXq8FEsc7wkXgbmmsEcrgci+rETAYtvR4eyZ6Ul0jqTxuVzCwTH6DgVHxXUXcwcoXG7z7KpduXuUW
 w8q22O1Y
 +nUOTxaZiGGAAJE1bxAxcWZsjCXpjAPbtAhxZ2Q+Cgc0qu3A98xdAPL37qSerAbrYQficOMXZWmx8AI0SRqo2Qg9wp0OOmm2mTBNt6TrBJOnYyqVqfHeFbCKPup84IIxI399MvgRVZE02xnVA/q+0HOTYL+9bR0rXHJl7jFbeb08D6jXFYQyyhPH60qjaQhGEgCFGC5e9sqHK7butCtuYS/yGnBpHCkN3bun+BDC+UiqSK5Yc2gR/q3uYfLiyVk1tL3kUzYVq5nceISkJ9iByDJH10NLIqm1cfJiBwxIKEDEQv9c8mz1/dzDL/AtQmFX61KwJ0GWXs+lbgj0NqJRUC5yZ3rD1lA+loGPCfobSqQ2a5trXUwYfUmyIJlifBq5WD2D4CwXA1XaAQFVhiH4YojTcycrHEBHKZLIlXi1TULG+HLE0qz/fV1GkLWB+GE8AC19RpgkY7WqBoSoJPh0G/jyTtMvQCbmDO01D+AXXBtja3Kg+f4Eos7h1k/spbG55y00LKk50iXTCD7tPDWLkC9xNHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003e929c065966d804
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 09:22 <liuqiqi@kylinos.cn> wrote:

> From: Qiqi Liu <liuqiqi@kylinos.cn>
>
> Hi all,
>
> Thank you all for your replies. I am not very familiar with the
> community's workflow and should have reviewed the mailing list
> archives and existing implementations more carefully. I sincerely
> apologize for any inconvenience this may have caused.


Hi Qiqi,

There=E2=80=99s no need to apologize at all!

>
> My work is based on
> https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kylinos.cn/
> aiming to develop memory tiering limits for cgroups. During
> development, I referenced Joshua's v2, but failed to notice that
> v3 had already been posted when I submitted my series.
>
> I have studied Joshua's v3, and our core mechanisms are largely
> consistent. However, there are two differences:
>
> 1. Read/write per-tier interface (memory.tier): each cgroup
>    tracks its memory usage by tier (e.g., DRAM, CXL), exposed
>    via a new memory.tier control file. This file reports
>    per-tier usage and accepts per-tier high (soft limit) and
>    max (hard limit) settings. By default, these limits are
>    automatically derived from memory.high/max based on each
>    tier's capacity ratio, but manual overrides are supported,
>    allowing administrators to constrain specific tiers on a
>    per-cgroup basis.
>
>    Its advantages are:
>    - It can express allocations that fixed capacity ratios
>      cannot.
>    - Latency-sensitive tenants can be given a larger share of
>      the fast tier.
>    - High-capacity tenants can have their soft limits removed
>      for the slow tier.
>
>    Whether or not to constrain a specific tier should be a
>    decision made by the administrator on a per-cgroup basis.
>    This serves as an answer to Michal's earlier question in
>    the thread regarding "do you intend to limit memory
>    consumption on particular tier even without an external
>    pressure?"
>

While I do see the merit in exposing these limits, I think
we really need to have community consensus on the
interfaces, since they will be =E2=80=9Cpermanent=E2=80=9D. There are
simultaneous discussions going on with swap tiers
that we also need to align with as well.

>
> 2. Per-tier stock: I have implemented and tested per-tier
>    stock -- it batches atomic operations on tier counters from
>    per-page to every 32 pages. Joshua's patch (moving the stock
>    down to the page_counter level) takes a more generic
>    approach, and I believe we should continue with his
>    direction here.
>
> Memory hardware is becoming increasingly diverse (DRAM, CXL,
> and further remote tiers), and the performance gaps between
> tiers are significant. Different workloads have different
> requirements -- some demand low latency, while others need
> capacity. When the fast tier cannot accommodate the working
> sets of all workloads, it should be the administrator's
> scheduling decision to determine fast-tier allocations. I
> believe tier-aware control is a direction worth pursuing, and
> the differences above are where we can contribute.
>
> As Shakeel suggested, and given that Joshua's v3 already
> contains the core mechanism, I am dropping my current
> standalone patchset. I would like to ask if Joshua would be
> willing to collaborate with me on this, treating memory.tier
> as an extension to the patch series and proposing it as
> follow-up patches based on v3.
>

Of course, Qiqi. I am glad that there are more usecases
out there for having tiered memcg limits. It would be
quite helpful if you could share what specific usecases
you were looking for when thinking of this series.

My plan for the series was to get the transparent
mechanism merged first, and then later have some
community alignment on what folks would like to see from
the interface, and agree on what makes sense to everyone.

>
> PS: I have already subscribed to the mailing list to avoid
> such misunderstandings in the future.
>
> Best regards,
> Qiqi Liu


No worries at all Qiqi, and I=E2=80=99m glad we could align on the
direction of this work. Let=E2=80=99s continue to collaborate!
I hope you have a great day,
Joshua

--0000000000003e929c065966d804
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote gmail_quote_container"><d=
iv dir=3D"ltr" class=3D"gmail_attr">On Wed, Aug 19, 2026 at 09:22 &lt;<a hr=
ef=3D"mailto:liuqiqi@kylinos.cn">liuqiqi@kylinos.cn</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex" dir=3D"auto">From: Qiqi =
Liu &lt;<a href=3D"mailto:liuqiqi@kylinos.cn" target=3D"_blank">liuqiqi@kyl=
inos.cn</a>&gt;<br>
<br>
Hi all,<br>
<br>
Thank you all for your replies. I am not very familiar with the<br>
community&#39;s workflow and should have reviewed the mailing list<br>
archives and existing implementations more carefully. I sincerely<br>
apologize for any inconvenience this may have caused.</blockquote><div dir=
=3D"auto"><br></div><div dir=3D"auto">Hi Qiqi,</div><div dir=3D"auto"><br><=
/div><div dir=3D"auto">There=E2=80=99s no need to apologize at all!=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex" dir=3D"auto"><br>
My work is based on<br>
<a href=3D"https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kyli=
nos.cn/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/all/2=
0260528134212.240492-1-liuqiqi@kylinos.cn/</a><br>
aiming to develop memory tiering limits for cgroups. During<br>
development, I referenced Joshua&#39;s v2, but failed to notice that<br>
v3 had already been posted when I submitted my series.<br>
<br>
I have studied Joshua&#39;s v3, and our core mechanisms are largely<br>
consistent. However, there are two differences:<br>
<br>
1. Read/write per-tier interface (memory.tier): each cgroup<br>
=C2=A0 =C2=A0tracks its memory usage by tier (e.g., DRAM, CXL), exposed<br>
=C2=A0 =C2=A0via a new memory.tier control file. This file reports<br>
=C2=A0 =C2=A0per-tier usage and accepts per-tier high (soft limit) and<br>
=C2=A0 =C2=A0max (hard limit) settings. By default, these limits are<br>
=C2=A0 =C2=A0automatically derived from memory.high/max based on each<br>
=C2=A0 =C2=A0tier&#39;s capacity ratio, but manual overrides are supported,=
<br>
=C2=A0 =C2=A0allowing administrators to constrain specific tiers on a<br>
=C2=A0 =C2=A0per-cgroup basis.<br>
<br>
=C2=A0 =C2=A0Its advantages are:<br>
=C2=A0 =C2=A0- It can express allocations that fixed capacity ratios<br>
=C2=A0 =C2=A0 =C2=A0cannot.<br>
=C2=A0 =C2=A0- Latency-sensitive tenants can be given a larger share of<br>
=C2=A0 =C2=A0 =C2=A0the fast tier.<br>
=C2=A0 =C2=A0- High-capacity tenants can have their soft limits removed<br>
=C2=A0 =C2=A0 =C2=A0for the slow tier.<br>
<br>
=C2=A0 =C2=A0Whether or not to constrain a specific tier should be a<br>
=C2=A0 =C2=A0decision made by the administrator on a per-cgroup basis.<br>
=C2=A0 =C2=A0This serves as an answer to Michal&#39;s earlier question in<b=
r>
=C2=A0 =C2=A0the thread regarding &quot;do you intend to limit memory<br>
=C2=A0 =C2=A0consumption on particular tier even without an external<br>
=C2=A0 =C2=A0pressure?&quot;<br>
</blockquote><div dir=3D"auto"><br></div><div dir=3D"auto">While I do see t=
he merit in exposing these limits, I think</div><div dir=3D"auto">we really=
 need to have community consensus on the</div><div dir=3D"auto">interfaces,=
 since they will be =E2=80=9Cpermanent=E2=80=9D. There are</div><div dir=3D=
"auto">simultaneous discussions going on with swap tiers</div><div dir=3D"a=
uto">that we also need to align with as well.</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex" dir=3D"auto"><br>
2. Per-tier stock: I have implemented and tested per-tier<br>
=C2=A0 =C2=A0stock -- it batches atomic operations on tier counters from<br=
>
=C2=A0 =C2=A0per-page to every 32 pages. Joshua&#39;s patch (moving the sto=
ck<br>
=C2=A0 =C2=A0down to the page_counter level) takes a more generic<br>
=C2=A0 =C2=A0approach, and I believe we should continue with his<br>
=C2=A0 =C2=A0direction here.<br>
<br>
Memory hardware is becoming increasingly diverse (DRAM, CXL,<br>
and further remote tiers), and the performance gaps between<br>
tiers are significant. Different workloads have different<br>
requirements -- some demand low latency, while others need<br>
capacity. When the fast tier cannot accommodate the working<br>
sets of all workloads, it should be the administrator&#39;s<br>
scheduling decision to determine fast-tier allocations. I<br>
believe tier-aware control is a direction worth pursuing, and<br>
the differences above are where we can contribute.<br>
<br>
As Shakeel suggested, and given that Joshua&#39;s v3 already<br>
contains the core mechanism, I am dropping my current<br>
standalone patchset. I would like to ask if Joshua would be<br>
willing to collaborate with me on this, treating memory.tier<br>
as an extension to the patch series and proposing it as<br>
follow-up patches based on v3.<br>
</blockquote><div dir=3D"auto"><br>Of course, Qiqi. I am glad that there ar=
e more usecases</div><div dir=3D"auto">out there for having tiered memcg li=
mits. It would be</div><div dir=3D"auto">quite helpful if you could share w=
hat specific usecases</div><div dir=3D"auto">you were looking for when thin=
king of this series.</div><div dir=3D"auto"><br></div><div dir=3D"auto">My =
plan for the series was to get the transparent</div><div dir=3D"auto">mecha=
nism merged first, and then later have some</div><div dir=3D"auto">communit=
y alignment on what folks would like to see from</div><div dir=3D"auto">the=
 interface, and agree on what makes sense to everyone.</div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid =
rgb(204,204,204);padding-left:1ex" dir=3D"auto"><br>
PS: I have already subscribed to the mailing list to avoid<br>
such misunderstandings in the future.<br>
<br>
Best regards,<br>
Qiqi Liu</blockquote><div dir=3D"auto"><br></div><div dir=3D"auto">No worri=
es at all Qiqi, and I=E2=80=99m glad we could align on the</div><div dir=3D=
"auto">direction of this work. Let=E2=80=99s continue to collaborate!=C2=A0=
</div><div dir=3D"auto">I hope you have a great day,</div><div dir=3D"auto"=
>Joshua</div></div></div>

--0000000000003e929c065966d804--

