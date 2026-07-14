Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86512C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC5B6B009B; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CB16B009E; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EBDE6B009F; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05276B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:23:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5761D1C02C9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:53 +0000 (UTC)
X-FDA: 84987298746.13.5923AE6
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 51F8B40005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpCerHKU;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOGQ3I7Kzejlffc7S9mPx4ZKKD0nbZggYmC8L5xWC1U=;
	b=ZElmmWB5Qeex/JQ778zUZktc6//rCPGxzxIqXFYHjfFYQ2yAGcND+/n2h4ILRZgtlgvt5I
	u7CZIeF6zIl+jAb4Byd+G/Y7H8oxkryWbIR0hoJKriw6Xw5LHKnLwsJzJcTNtQC6s0e1dR
	RqSNhNCvbZMQoVJz8INr096yJJ3MWyc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpCerHKU;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031831;
	b=hNRMmASKcqu1yEQQUV0bF87D27BSIZ0S338G1WzEUh+2BLwTKJspiRFWTpli4Rx/5wYoW+
	q7LCPAJVbBR2LRb/ExFnAw1Wzw+dmQ2JGhaFumCJyHYUjOCmMqFM2Me/BXmnfdtvAUl6wq
	ig7/HyAbCu8zrOxtBzz39jG+WrlF6rU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493c2c0b9a8so6532545e9.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784031830; x=1784636630; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cOGQ3I7Kzejlffc7S9mPx4ZKKD0nbZggYmC8L5xWC1U=;
        b=NpCerHKUfSuuZMuDpgmeoieDOS8HgZZk3T/RkjJjKkXPby+wCQ1wR1Y7luF6SremzZ
         ZVQetH/JTZ/K/Qaf6YdB/gfFDbjErMAcP/XUARTv2m6dqzcmSpldwqPLyZwiK0qArboX
         UF4jyJ8YK/V9IYecic4paioEscCDHyFDGmL0ri3yrCeYWArRfaUBrPKOwCfhPpP4Clja
         7Gmc3m+DpZSoh17Q3Qs39eorpN2k22KajP5O/xyS5eVJa85tTQFauKZ/yY6kMsXkbLZI
         4hBuQE/zeS/36VgVlomO78X1E+KnN7/TyJmJT4/ZaWXH+QaqVjFw/5bHV+L7T7QiOPRS
         91rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784031830; x=1784636630;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cOGQ3I7Kzejlffc7S9mPx4ZKKD0nbZggYmC8L5xWC1U=;
        b=f1BbwprWdcOUgX9doIt4Dp1mtED6YQCTUTnVTGA0tqO3HcvhldC8h+Ln6MU7yZMHQd
         Zdl72PEMp0p3F0ZL+NIykCjKOlr6Nxdp4tY8BDhZAhHL6o/AGkOIInLXF8iiABOGGunN
         tXRPrCyw6LoHKD7WtNgi2+NdTBHrbdOOq0ESocjnMUpFJxIQjP6KS2QgIhyptpckfX4x
         AUrHB50jE6jVLNQ6pRvWJqR6bCp1PKmamF4/Qxr9lhVQC0fUoKvdV4xzaDEblyekE2Jr
         zVupjBwpqUAbPtu4N0yG/yjS+r8eatZUyjnIHKduCVRiC9rYfKt/n5hIkkDl0CCyDNjm
         l8jQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2rpLjxhu+ZO9+0MOfi53COYL+b33cVIqkvz5HC+IXWCxFfYU8yI98ys96tnYkYB0g7hJ0N8h2BQ==@kvack.org
X-Gm-Message-State: AOJu0YybWMR9ZTVUMVACEqgyKikeyHhclucRGHgJGyz4SO4syeiX8YRH
	QR7AfbKv9HSaScHRozFu9vlGmM60sjrDUGvu6oxhwU0uJ7UpCP76yLY8NzGYYXTxXKY=
X-Gm-Gg: AfdE7ckeRDMuMSppY+tG2ksGtFJ2br+vUik/7S3njSObQPdBJoXBBrkY4pB+01QLYU6
	Vl9qGiNuZNT/tZTpb+s7ql0RjLDP3CLyHl9keaVMSnZKuOn9nAf1apdxjoJ6rAEgVWwdW9BVxwA
	4nHXP530Op2FnBQcAaWp8zRhBnhKVzak26QpcPlzGIxSB9oxhI2UmZGOPLZbwo5OAM3H8ek2qA5
	ToLzfjHDwCpwKBRdw16eNF4vPMdjkC1tIC8py0+uunqoVMpcF/bNexMpfswDqLqNLXPU21bgxEt
	P1i+mQxWGSKvTl/kZ1GEMo4M0jS66RfU4vjGGo1eBH0DMcJnAh4wv7X8LrH6QpgiuFNzWRuOOHx
	+XNSScgWjk672v2HlYCb6v/yqRuPq0Ymy/sJYL/r3+piCe3hjAOSh/bQx/OZxz4vbK2GQyH9xxd
	Fz/FfOcXv4H+X3znSN3HcwwhFHWg==
X-Received: by 2002:a05:600c:4ed4:b0:493:c42e:5be0 with SMTP id 5b1f17b1804b1-493f877e3demr150320655e9.0.1784031829843;
        Tue, 14 Jul 2026 05:23:49 -0700 (PDT)
Received: from localhost (109-81-95-153.rct.o2.cz. [109.81.95.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm390390775e9.2.2026.07.14.05.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:23:49 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:23:48 +0200
From: Michal Hocko <mhocko@suse.com>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alYqVPEyZ2ySrdAm@tiehlicka>
References: <ak5-qwmpXrYi5md6@linux.dev>
 <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
 <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
 <alCQ28gBclWOFF4_@tiehlicka>
 <CALC_0q93iheF=Y36SSTg-XCoKgHrhxk88LqcQkDd-O3ymMVmxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALC_0q93iheF=Y36SSTg-XCoKgHrhxk88LqcQkDd-O3ymMVmxw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51F8B40005
X-Stat-Signature: 8brwzwwuy998exrocjoj1166w9x6ztxe
X-HE-Tag: 1784031831-783871
X-HE-Meta: U2FsdGVkX1+EtfYku5PCKMrgOJcP5tdGJ/OGYcoD+Dh3gN4l6L4bM64RUPx6/PIztIJE8SU9+9IJ6kabYUDoaSqJL0k+U1l6A/OqlIrzw6PG9HdoLz3INLVg+lsSv+CPh68h/Prf6vnEL9WeRTx0fjqA3k5ZxW+WQHzg06KOyL+GhPFSzNN6X802F3TDH2vISS0+rH/NqLSvRSE05JfN0yZng4tZLiLWs1zRmgejrn7whPHW6HAQkHhWA2T7bEEPcF3x6U+rf6Z1Qvcpw+j4RNe9VvnCoUyCWupZP683uN55fvXHgQanMqUV188h/D+XKetRShWh7yNp0ljukgd9FZphO2t6UfmhW9I2MmxzIdOlRpvMd/CR/TgSdHbC1L4GUVe5s+eY9GYhXK1h6UdQnyiL1rp4qdKV3N8OG0nEyy7uAwlLqnwKv8oKOZrH8S8fwJONCrJKG9gGs165z62UNnBPwcKGF1AzrGVDll3CrFIhKIsb1rX3uWJ273Gx4SMie0kbhNW9UR/BuAYnFTu0K5ktzYWn8GygnggUSJxAnMwFmtVbgPNpKAK6OYA2kpRELjGvSx+zpU8QWEqeVIoEzhCaPgbNKA+KiRxhIIh9Xvxje91369uqS+gBtAPjH9z18Ky6yEcMSDFnBfZZCCj1lwAJgxd/9T8B86Yqn4tZ/oVq12RqngWULcPgZfdhC2Z3ftKpeZdKzoEgR0GDACk3OeQZ1180WToGy2rG04pFF5oleIIslP7Jek7gzM+1Y/IiJmrDsK7jPa/utdBahCdPrQ5xHm5hUbYK311rQQUC63dc9fY9cMffzhVsHTPWkwLRQ5doxCJasrp7RogZaSUcMUmiaoeIA5MKOLDks/mgnIiCBgN0d9F/ZtV3ffmoVNms6zyk4l+VzJoK2B1L+VvqcyS+UuiII3tsInSVmLJRP4VDsGceWfb8zc/MKAPKX7nngchNHDFd3YsOifonk5Q
 iIPBlIwK
 tQXrgJ1hia5TVgWeZaqGUMLEzHALv8Dw/fi+OPl84hh1CBg24AkRKhW7xUsREnz8z8TfBAgcZrF5E0XLv95p5KigS6EZMje2OzKqUkjSGPqodGBW72B5EqKtxDNqe7fQ4od8QeGAM6+WSNPww3fwDK3yOYNaYzFD14BYJNqCMB0FQ1OfXOehjKx1+D/euuw5awsc1GkCR0Z5Nunh29tDYIy+P9MAC5OZiBFbxDnmL5Fubtt1zFKUrVnBtwMEqDGnCAzWU33Xs+M/5aavJ4tGGlFB8OFloADnJGLizBUO2G2y8XOuiM2IfU42EigfEkMlpw1jC1ZULrZAmrhYwo7FyxQjzpGRkNnyH445AFbmrAQ/1tT0ogKjnLsTi/M6H5arxGA0KqMkK7nqd+ux4VV6bdd1eutDSurNJ+lMIC9vpcnjOmU/qqKcFpD1EQiCOcLaq12KQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-07-26 17:00:37, Richard Chang wrote:
> Hi Michal,
> 
> On Fri, Jul 10, 2026 at 2:27 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > I believe this is a wrong behavior. Freezer should be invisible from the
> > userspace POV. Your patch makes the pre-existing problem much more
> > visible. I believe we need a slightly different approach. Should we
> > try_to_freeze in well defined places in the reclaim and turn
> > user_proactive_reclaim to fatal_signal_pending?
> >
> 
> I believe your perspective is that we should avoid -EINTR during
> suspend by transparently pausing and resuming the task rather than
> aborting the system call.

Correct.

> However, this approach faces a few constraints:
> 1. fatal_signal_pending() only addresses SIGKILL, leaving us to still
> handle standard non-fatal signals, such as SIGINT/Ctrl+C, for
> userspace callers.

fatal_signal_pending takes care of all fatal signals - i.e. when tasks
doesn't really return to userspace because it dies along the way so it
doesn't realize there was a kernel internal signal ever triggered.

> 2. Calling try_to_freeze() deep within the reclaim path is complex, as
> it may hold various locks (such as RCU, page, or cgroup locks) while
> suspended.

True the placement would need to be done very carefully.

> 3. Since -EINTR is already the established return behavior in
> user_proactive_reclaim() when interrupted by signal_pending(), robust
> userspace callers should already be equipped to handle this early
> return.

This is relatively new code and a broken one I would say.

> On the other hand, the freezer timeout/suspend failure is a genuine
> bug currently impacting Android devices in the field. The proposed
> patch safely addresses this immediate issue by leveraging the
> pre-existing -EINTR exit path in user_proactive_reclaim(). Could we
> focus on the current patch and open a separate discussion for a more
> ideal, long-term design regarding freezer invisibility as a follow-up?

I am not insisting both to be addressed in the same patch. But building
more on top of a broken behavior is not healthy either.
In the current state this should be as easy as turning signal_pending
into fatal_signal_pending and try_to_freeze at the pro-active reclaim
entry point which should be safe from the freezer POV.

-- 
Michal Hocko
SUSE Labs

