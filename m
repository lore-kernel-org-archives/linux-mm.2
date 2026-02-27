Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756E8104891D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 23:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4136B00A1; Fri, 27 Feb 2026 18:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB9C6B00A3; Fri, 27 Feb 2026 18:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D82F6B00A4; Fri, 27 Feb 2026 18:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2CB6B00A1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:32:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA8C95A859
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:32:58 +0000 (UTC)
X-FDA: 84491839236.25.791E973
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83EDAC000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:32:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=TLjWE51+;
	spf=pass (imf10.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772235176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/eLIE3ND8oKfgZ51wtjS+hjmkhRyVh6yadLObJYXaA=;
	b=NaGQSQBn4Jd1McD4INL+OS+7TerCCELh4+rC4d2YlWE9SoY+06sTEgqIWvHMsy2RtAg8Tu
	eCzkKYor254HYXBHvAm7EzhF4DK2ZhFkJJFRQRjWvWEAgAmzafSY6j5C6CZZfpr6y16h9i
	U+uTxTT57X+7JXQfNTw60VYk1pJNifQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=TLjWE51+;
	spf=pass (imf10.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.42 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772235176; a=rsa-sha256;
	cv=pass;
	b=EOFk3cdGILu++p4C9yDBxD9vGcrhHU3k4DVHjm96zKEAxLxHi5tAQUDM2kvHnf/dp+It4n
	3CeKGTqWjAD7vEkJxEO6q6heC6d7q+ba428KNi6TT0wm6L5z01cCzhJFf88lsXre70H2vO
	vMhNptrkKpoqWyR1ve4CEDYAEpsFKYM=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65bf2f59d64so3454215a12.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:32:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772235175; cv=none;
        d=google.com; s=arc-20240605;
        b=lYNi7z4NgLiVZd8kPo0R5yjcLQs1EsbsaN91ydphx9YktHmekvgH1ykUZe7XLFyo4L
         udncucjLH7x1T6hD6Dl86TXXKU/as7trR83i04ScK+74SS6afXantvn8xbzq2nO+zXjc
         I4+1aVjb1rGckUbiAckRFQZN6C/rmoZ3S2AAsbaFH4Ui80Uh0gPWVPZ/GZMvmy2eFh/N
         Clsj7BFwbJO9aGDmGS1OmGU+wAp8avGIwpM3ADulh0HND+rrN00ojdIG4ZVjTvpZwWHi
         ZEwYi2YPUaZngYtJTGr8Do5NzdEQ6/NNUHfLH/bsKvicc7sK53OybBHPZRnpdAC0ozMZ
         248g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e/eLIE3ND8oKfgZ51wtjS+hjmkhRyVh6yadLObJYXaA=;
        fh=e/ImoaayVqeFlFJwfCsk2qxJCzY+/9UXqg4At2a8lhw=;
        b=eZZl7PDqTpImBRejDBVxr30HCuYRTYA8O1sVh9zHnTgnByNcCqUeACTiOzDe3es+mF
         fABTsE7a4fjhhyckLuxkS0OCTt4Kni6shjcgYG1VuPxlqIdmR3PGB6jVW+tRO1odk6i7
         PyvvXJDOV03/iVVtHw9rNKbS6Llhhqh5cYtIMq/3oqEVQDPyXs2nf7Y/JrslquteX+6G
         k2ux+8AXzhbeWL4UzKKbhJt+Y5ju1hyucDUpeS4vk9mJlmoW91XGaBrdvnC3u6wr/qWg
         X1Gyg4v6RGpqhfUC4+rFYJEn0d69JafvnBmcjPuGihJXVxzafqiLj8lp5R2OIYQGsnke
         8a5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1772235175; x=1772839975; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/eLIE3ND8oKfgZ51wtjS+hjmkhRyVh6yadLObJYXaA=;
        b=TLjWE51+ahre+mqnzFRHHH5y91u7EZ4HMvXFbnDRqkTVYvJS/ODDqYNpjDNRmiphqj
         nicY3k3USttEkQSRFymOUFHh0iJ1qFYAKAD6tJSL+gEKuearpDD9IJ9PDob/2xsTMh9H
         hP8PQAvU39AgWdZnExKNyLQ7BsIMrj7nteq21VgI/KyEOOKjamzUdCx1oTvlUrdMeFfy
         0agsD9tbyCuFd5Pvck9Wr/EZK+3InNXXgLRKzSWDZxmcRUY+hmbaabRowhnHWs8FA550
         +jgQqKugG55Qdc8lj0iSPgNixSCotgOK+835ip1etRxW/pUBOnTFcxjvujfrrxSDBMMM
         wT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235175; x=1772839975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e/eLIE3ND8oKfgZ51wtjS+hjmkhRyVh6yadLObJYXaA=;
        b=klKTY5qo4VYYrhwuJ1VwImPSu1Bot+WyWaoNc0oMvqr/drfnXJ3CIfMvBlhoDE+E8R
         D/ntaAZfRVrQvE6NKxPF72JIltxTbn22ruFP6LlMiL3gS4dkXbpciFJl4sqDHBtfbPL5
         Ixbr/c2ShBUIZVkhRTvzLYHE+5rKhVf3ETFN0/857gd/qwtAsUsb1/HMPE83OQIbZYSS
         e/BbYIqrhWh6Y9S3Q3+OwH3HJq98ks8wlQhrFSyrJDi21sirmZl2uHd9BpyiNAJ2Gkph
         EqNL7H73IBMqy9sWyz0Es5+d3BaU5htmkuvIkw69XzgDobqRXgCKUK7enzbD+I7HdPtx
         KmTg==
X-Forwarded-Encrypted: i=1; AJvYcCUNonNjXZPxLiOod6vsGRjkvJ2n+f8TMGnyFmEcbpB+MifPNh6/QKr5pcKHPdXHf6XXQamSUBrXfw==@kvack.org
X-Gm-Message-State: AOJu0YwUIw9+Wf0S7QgZUhrvKBCn4zbI/WPf99Xeeqeyh8zxgg1kSp0g
	KsJJNxo6B9EjFnJR5sp+86DnM/G7IcdjwinTb0PAR0nnPSLwjw9inwHh+ZuVcmuS4KwxzVYN8P/
	EyUxskNTQi1aLyLkftXdA/W2nr4BtPXkEJ7FhaOTlLw==
X-Gm-Gg: ATEYQzykGj1zT5fPczZa5w+8FtUUE7aUzRCVaUlAOEtXj4DD6a/JammkXR3HlY4OOpm
	cNXzIgYLxQRAkidX3zOs50j6G1AmMUViuR4kybCs+4gE6HxGkJh5NEensoXKfbV8TvoUpGgrE01
	vWGFDRvYT4cCUkf9SppQ3MOWUFsaisfb+r1OUelFuoelzCBm0nAnHdUIiWpi4l1fSHNM8gQgfut
	F0JPt1fAHoLTs4lWvXn0m72QMskkIBD813XPdX6AXdYqsDgtNy3ArO5eF1vEcnxSskurU3zsWP3
	gC3TtucxjN9GIPVzSw==
X-Received: by 2002:a05:6402:3810:b0:65f:a47f:6e98 with SMTP id
 4fb4d7f45d1cf-65fddcf17a2mr2834242a12.27.1772235174690; Fri, 27 Feb 2026
 15:32:54 -0800 (PST)
MIME-Version: 1.0
References: <CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com>
 <CB5EF1C4-6285-4EEC-ABD0-A8870E7241E8@nvidia.com> <D4BD80F5-6CA2-42E1-B826-92EACD77A3F3@nvidia.com>
 <CAKNNEtwZzt3xWh_b1pn4X4FG+cq6FLOP5rR4+G=WUsjHsJRjaA@mail.gmail.com> <2EECA9B4-E1F0-42FF-9E61-3E4AC4B4DC13@nvidia.com>
In-Reply-To: <2EECA9B4-E1F0-42FF-9E61-3E4AC4B4DC13@nvidia.com>
From: Bas van Dijk <bas@dfinity.org>
Date: Sat, 28 Feb 2026 00:32:43 +0100
X-Gm-Features: AaiRm52i5X9PI75r_CXw7oqvsR4nJ7O2YOcRO4y6Kt2G9VuPp0acJ2VcRalSCjk
Message-ID: <CAKNNEtziooemhq3Yb8OpOjg4N0bV+Kc+1in0P7L1i_NBWS-q=A@mail.gmail.com>
Subject: Re: [External Sender] [REGRESSION] madvise(MADV_REMOVE) corrupts
 pages in THP-backed MAP_SHARED memfd (bisected to 7460b470a131)
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, regressions@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Eero Kelly <eero.kelly@dfinity.org>, 
	Andrew Battat <andrew.battat@dfinity.org>, 
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 83EDAC000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 7zry9f5qzfhiqc4ei6uohgk1w5daokda
X-Rspam-User: 
X-HE-Tag: 1772235176-180220
X-HE-Meta: U2FsdGVkX1/EAfkXmVttTAdQ4kgleVU9YATHVaBPCfEnYUBupItmr19eLT1XQym2YSs4igHzA9mCND8tLz0oxjd0qps4DQ5PkCncDi/Ghlu6UINpDW+l7aga/3ZRMeIOvERHnuvh+Tylloe0huvNSxwd8V33Wp2x3X/88x/ZZ7r6n67ZVwmKZ9+8VYbW4oqTJm75JOkONP+7wXo6NFEh1+poCRbZTkJ+FHOqQsEPnUDGmcf/UtUDNJ3FAOIsXWLWE6J4CY0fQJ8A+qzvzdowGeq7grRRTXIhoQded5k+/OQotx4Qo7SxePy5iREKndWjOzkElApnQnXk2axwZyGgbVN5yGjoLkqxMaAIittfXG+9rDSRWVmkP/p9u15t2RIaZw8NuY611Ss4T2N2AFhhEUoT7kt5Yg9v5yxO5N9280oR+QPHOO7AZVODK9YelLpmiEY5TJ66XNJAgKgWwaP5VMTT/+OyB5jYP6xwx1CKj5dzA1UyAnIWdeNpkQJVPgM7fqjHRlE/QOeWT9BLWXUrVe04+m/mqjiC7NPTpwrLYWmkkxNE1zMErdoefyAuZAC3cvLvaXw7x4UGBIgwGiAo9zKHLBwFRLJnM0zjiwBFDx+HbJXypoaxsHj04USkK0yKkRW9R32MNdKIRtFLDp+yn+aX1hFcqMgAeHWBw1uk925ykXHQ+zPu9eedL4w5fxVAG3lkPp52W9XvUKSLWvZvhXzHPaOPLVRdY5BH5jxBRfurMsnT2nW+LhcPR4sLXwk5Clcwn7UZmSiqLLjZ4LY5+iRY57lA9j+RxG5p40CNIfLxwq65GXe2a7nS2g+hYl16qp8KSuTc1IpHqoycWGla6XPfOXR5AQYHfS47jSk0B1lqp0DFRnFyAMqgV4GPifsm///5tzASwrQ0cQEhTVrA6yCgELOnYpDEbp+C9DXTckxuhbbtAWbwcd1x1CIx70kANP2wkpZ//0IWBHCrC0j
 JYdnZjDm
 lYT7yTyBxMC50AfG2iCFes9ZR6rGTUpepUgK1zK7mXITnzbow3NpTBHF8QnRdim90a8V/AscAKzA2noTR3/9KMljNn8AkDklJrRtMNyZtTIttZPLa1n+9YyTLaTmvCVQGgayGS1cMpYV+Im/8re1d50+2h6/2e+Qr2Wu4DoXueQDaokfd+cxlzspz+fKlIb13rzamZeky+Ef0LGU1houS2y+EZ80+SL5REloqos+th1NDIeWCgNtAWby1n4q72K9o7RaPq7ZSe40gZrvnmtAFh6QudITnn7yiB6kANDamtBZKIaDU7fRIsuzCNcvRaCWoqrL8+COlCP7JLEJa/FLMQnlnlhzd5owIZb4Fm5GRMdiC2XcIudwISpPs9sLpozAZuS6pLpNMNaFyk6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 8:29=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 26 Feb 2026, at 16:16, Bas van Dijk wrote:
>
> > On Thu, Feb 26, 2026 at 10:06=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 26 Feb 2026, at 15:49, Zi Yan wrote:
> >>
> >>> On 26 Feb 2026, at 15:34, Bas van Dijk wrote:
> >>>
> >>>> #regzbot introduced: 7460b470a131f985a70302a322617121efdd7caa
> >>>>
> >>>> Hey folks,
> >>>>
> >>>> We discovered madvise(MADV_REMOVE) on a 4KiB range within a
> >>>> huge-page-backed MAP_SHARED memfd region corrupts nearby pages.
> >>>>
> >>>> Using the reproducible test in
> >>>> https://github.com/dfinity/thp-madv-remove-test this was bisected to=
 the
> >>>> first bad commit:
> >>>>
> >>>> commit 7460b470a131f985a70302a322617121efdd7caa
> >>>> Author: Zi Yan <ziy@nvidia.com>
> >>>> Date:   Fri Mar 7 12:40:00 2025 -0500
> >>>>
> >>>>     mm/truncate: use folio_split() in truncate operation
> >>>>
> >>>> v7.0-rc1 still has the regression.
> >>>>
> >>>> The repo mentioned above explains how to reproduce the regression an=
d
> >>>> contains the necessary logs of failed runs on 7460b470a131 and v7.0-=
rc1, as
> >>>> well as a successful run on its parent 4b94c18d1519.
> >>>
> >>> Thanks for the report. I will look into it.
> >>
> >> Can you also share your kernel config file? I just ran the reproducer =
and
> >> could not trigger the corruption.
> >
> > Sure, I just ran `nix build
> > .#linux_6_14_first_bad_7460b470a131.configfile -o kernel.config` which
> > produced:
> >
> > https://github.com/dfinity/thp-madv-remove-test/blob/master/kernel.conf=
ig
>
> Hi Bas,
>
> Can you try the patch below?

The test passes twice with the patch manually applied to the latest
master (4d349ee5c778). Thank you!

I had trouble applying the patch using `git am` to 7460b470a131 or
7.0-rc1 but this is the first time I've used `git am`, so I might have
done something wrong.

> I was able to use your app to reproduce the issue after change my shmem T=
HP config from never to always.

Yes I had to write "advise" to
/sys/kernel/mm/transparent_hugepage/shmem_enabled since it's set to
"never" by default in NixOS. See:
https://github.com/dfinity/thp-madv-remove-test/blob/d859609820113c69023848=
452bdba8b619d78a8a/flake.nix#L93

It would be great if the patch could be backported to 6.17 used in
Ubuntu 24.04 LTS since that's what we use for the Internet Computer
and where our tests first started crashing.

Cheers,

Bas

