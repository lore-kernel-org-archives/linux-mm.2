Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5FAEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BECC6B0005; Mon,  2 Mar 2026 12:28:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576606B0088; Mon,  2 Mar 2026 12:28:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F5F6B0089; Mon,  2 Mar 2026 12:28:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37A6E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:28:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDE27B73DB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:28:57 +0000 (UTC)
X-FDA: 84501808314.27.1253A17
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id B90CA40008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:28:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UjvbHYE2;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3n0b90DzB04tYV40Bc9lDxOunyy6wXi77KoBPjFJew=;
	b=q0f3jgK+LN8Gz+EutcUQ66yfxWX8qogQ+i2RJro+5qBy2otWPxWUbtVxs+qzoaBqULs/co
	ieYmUPI8AUMymlg3L8n8eXZF9UNkEYFPFAPjBZQqZMcNltg7Tm/jMOmS4mg5c8SWh+fmrO
	m8YCk0yUUOYDA4/TdYoMibuynVph0IM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772472535; a=rsa-sha256;
	cv=pass;
	b=fYDdCwD6Zwb4e2EG5eojUlf7ZmSp+rHXWRo/SNR6aNz69rqtiB/dBWkptdkInw7jHyPlAZ
	nElCcVrydY9tVt02OvAb2q0/iNQ8ocls97Vbed0TqI9G8bNfVsohDM96L4TODkyWUY/AON
	ktV0Gh/aMraPHGMPKH2O2QwoeC0qkVg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UjvbHYE2;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65f93fff5c5so26394a12.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:28:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772472534; cv=none;
        d=google.com; s=arc-20240605;
        b=BrPYDGC8VrwK3B4Zy67b0JYTVCqGdOyOB6CiOrWSjyED2x9C5tAC/rZvhpffDa+66K
         /CTD3Lg7t5/ZAiLJKGK1lQ2PfLGGiGoNo/X4OADeQAcN3/rKYXZ+cp0FrpQj2cx22uys
         4LJtnExxrFXhNb4PSfeA4UEOvODc0oZnUJI2r68T9YePJfrxuappZOBxb8N1TsZ9wAUk
         DZhjkc9g/jjl6baNpQ9PEHUChTwtaFhZbsSTnct5lOFH3xPH/O3+OXELBmsTluu1qXwY
         F+HIts0a5HOufNnBLlGA+S9VtoIfHQHUMVPzRySJ5gTCqTBGmHM10oDl3XcVfCwyLcc6
         VkXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G3n0b90DzB04tYV40Bc9lDxOunyy6wXi77KoBPjFJew=;
        fh=ChqW2OEWYgFSAzXeXf+vhvYuvRJLmMroOsm3d3S1Y5k=;
        b=V2bDQTy5KsKitE5vFiwSw0Hdh0qBLFWuXuXf9XTYR3c6xbXC+n7gVD4rxmZD2Fys1u
         lcwMf7GwaZXd/t8VwNSyxo4ypiL+LA0mHcpiQ3u/ckBzUell7JXcQ8m1AYWfCOwtAAKT
         er88bCzKBAwIP5CM2djoS5dQ3kIeDJz6nagMnTeWmk9+/FCQzJ7qk4DgbjhT72pjNol3
         +5yek6gmwNbmK37QyRkhg4VYBWcC8agixr0jjjF2E+2vIQKONZnb2Mf3pYRBjfNrCbAH
         7LbBt3lxddiTRbzWiLdahnW3Sq4XUBiEViNvYV2DGfRt9CiyRFLAfKZ3J+Ra2hTaO65L
         OAsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772472534; x=1773077334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3n0b90DzB04tYV40Bc9lDxOunyy6wXi77KoBPjFJew=;
        b=UjvbHYE2arKeyPOYlh+QorJYRB5EGESp67dwGl+6ygGycOJ5nKaFwH1VHPIY0wponc
         Cuyg9vDYzdSiDsGORaMNeFUnobOdsc+LAhQIuDj6TUM8XNAByFNuV0/RQeMAc4JFxIbl
         NFVTHGYrLWG88h5anlrJIDtFdu6e04caUzK9sgtEFktpi8N/ADqhdly42sNzn9QyAT89
         xptyLLV4N6scbE+rAbqnl+0mhBQc39mFgnLdVs4P3keAe5iITnqHekngisvsjMvxukNk
         30ORJqO0NsVEXbMtQWCaWrX/AAzX3aFufSsFNtLl/Xc1J1dLeeWVR8SsitZ2tH/cWzBn
         ZGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472534; x=1773077334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G3n0b90DzB04tYV40Bc9lDxOunyy6wXi77KoBPjFJew=;
        b=uenYGC/sru4ur+e7ILV5xu8LyMFAyGbCOGpPFFYhrMvD0TWUMj3Iav+ESpnu9K/zMH
         fw58NbdhQvKEvxuOX5B8xIPH5ES33K9KjxYDt5jWCrwippSNwn4EGn4EgftD1DC+Vb32
         +gbaQ2Um0CIJD+keIK2d+H9Qs57nJE6/p21ZWebegbWkkAt3Va+ZEyXevwJ9wilL/SYh
         Bw8zYscNoDAqv3DYaBMCqlgT5KinAH6XSiP1VIqkj5BBZO9MWqNQzf2RE6w/hS5qxGrm
         SmD/ohlznXpHLsZzKAXr4+87Vuj7FlHKmcYOI4kbRysv3g0VOFKuUgeU93me/4f0y8+j
         5r7w==
X-Forwarded-Encrypted: i=1; AJvYcCVJZnLHj6JJ15cSStaKJfvUAEZAQqTAdyfy9gjH6gx6rRSs3UzsSfeWcAyQ519QkuVYRWTwuxDOGA==@kvack.org
X-Gm-Message-State: AOJu0Yzql6sK3xz3yPalSvV5114BEd6qI9CxSnvGoYi0gWQX4gYqOZs5
	AexyQWWRbl1nS1/cWK67gq2iIv8YGz4EZRj1TgTaTMSl6VIEmjRn4gddM92ol6oUAqQQ+/hI/q9
	86UJAdcNnUoIEYAd45f852uaEbxRsbxvpE92+jS6m
X-Gm-Gg: ATEYQzwbKiSBSeZwc+fw/u4WYpcCUqMQz2W0XzI0VAXZfoUJaJlorRj5r2hk9Lgee+y
	ywxhih7xiDwjUbFov72006obBqDepOLhs9ObzObsM4rUb9SWm1/cbQWBZTJQoaSdqO47UdVKbIN
	qHF43LX4COJEpTk9JdsxeRuqZUz9dGnfHjAtChxspmzo5kO/WMBTn/GZ0g5Mdh5RRwzKi2vYwMT
	rLUXSDw9+nzNfQa7LsgTCPyHgOoZdUx7KqFmNJV++kjcZ/Vk00Px5pVK00i3jep5OdbOubU1glD
	cKJ5MlK9qkL0eK9sE9nSgE3kKZIzDnwwS+Px
X-Received: by 2002:a05:6402:f12:b0:65f:ddaf:d1c5 with SMTP id
 4fb4d7f45d1cf-66008e0a08emr235858a12.12.1772472533625; Mon, 02 Mar 2026
 09:28:53 -0800 (PST)
MIME-Version: 1.0
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
 <20260218-binder-vma-check-v2-1-60f9d695a990@google.com> <aaXGZlfAmk-DCuBW@google.com>
In-Reply-To: <aaXGZlfAmk-DCuBW@google.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 2 Mar 2026 18:28:17 +0100
X-Gm-Features: AaiRm50SZW8QPqSRhdWDXBgdsHpRSfdrfGzv3dpf9ThjwdH9bYPFTN50ijeQDLs
Message-ID: <CAG48ez2M4fj15gqyKrP7ADRUhNQZkpy9m+NSz2N=vo=PSefm0w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
To: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B90CA40008
X-Stat-Signature: e1q8xgk6fnqy4bpoxrut9z7gzgwxojf5
X-HE-Tag: 1772472535-336350
X-HE-Meta: U2FsdGVkX1/eEr1CRhBGZGTIKdHSJ82javLkh056TRvW0nDKnl2Y0VLzENSQW0mRSZ1bWwxzKbBcZJxMZ1vmRP4e6fOwmIiFirLTQPVdnxLEKxVwTUB5U+o0cjXyNJH2wfhZEofOcC8f4iGX6LNfpuwtQmzjclz5HA8cvB2GJdouQxkLOXsEGsH/ZSm3Uoco4isxZBNpt7XkZlU5IP1Bjn2L0oyzJVCjIueD3Si48ZDCNvI8KDREzmCKVR+oX389k/AdoSZB0wfjiYYsqDeF6iv5x9o4ePRiDk0UtvnOG1eEMbyKS2puSKlH1UHt6P9YUQaBZJWjdt+b8RV7kaIPDHQtneHCv39w+HFNF1MAVdY1G+/md7RwrKnzPDCuVY0YXzdrNNvyJ4nHEJ8vmVuytkgUjHBV/AWnUyCh/0vArwQaC18oYLgQVl5Ce300NyhFvFS9Ag4fjPyfnkGO9z9pLHjwnsBP/HHy40jTW46Gv+vnge4npSZus+loieHj8G2wXla+NyRV7QqZiTVZ1d0MOvQO9bWMZyMn80aNdB9ca7Wbycuv5e5IB90sFpLMDDgUlTh5PMfGWElLf8AxT31lYH6vwcpZRsCNC1CGJmkNdfb4H7w2YZT7R9kT4/nNFHkVtoitSwwHVUOVCUFFPeaFSOJ0pXtipjWlsQoGpYgoOsVqfojiZVir81JGWzjy7m3yqxrcIcDuL1USfBv5lGgarRjIyn7dsEsSBWQ9F79lDxCnhvvMaU81+4jQ1yrO+6lfsxaNCMY6AsC1A4SltauAj5D+jbqXq6rsee3gwh23frDyYMgbcsgIsSByr//LMfKG87EENoxv2JDDfsK5I7AaJqxcKi0jCTQlpHZ/KjFUHYqUh75WrtAhylcX026RmdK2MzOdtOOeeBrrKCyrUswoFJCOJrpIrAXbc9ZeToArHspB2gkqsDyoFXD1Uo786vfhEEb8seYhpLO+C2NO0sQ
 vRaLHmy6
 aMXoA3toyF0lY0DDnrz+ldjDrM9qjEOvK4IcLgg9Ji+2gE/J0Bx/oo9VuOxyyClwLkOJiFQ1pf79/dDve7DXi+H1mRvpQrCEk7IW92SlaSgezNbWIs9fB41XojsH+yRA3+JhtqIfsTgF++GeIn2Mn/6p7+xBEe5TlbAuF1OV5NAtSQg2IkdU2Q4JLyLhHv+tRmr2TPVZPHq/fdBhsoN5FrrR7T/jFJsZZG3xqweoNijHC9Qgz73/Z1cE0H99cgC18ccA7mSkNRc+66bYP9TXKabefjHoF+xtNrs1u/ffStGtLvBPBNJ9ZydaA5HEXjEbz9KFJZXBOPWMePd0QzUGQR+2LpjVpjVExqne5MQTfJiItO7Yo8gu1KjrxGpTA1k7rpfccPoaLEsqNsDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:18=E2=80=AFPM Carlos Llamas <cmllamas@google.com> =
wrote:
> On Wed, Feb 18, 2026 at 11:53:26AM +0000, Alice Ryhl wrote:
> > When installing missing pages (or zapping them), Rust Binder will look
> > up the vma in the mm by address, and then call vm_insert_page (or
> > zap_page_range_single). However, if the vma is closed and replaced with
> > a different vma at the same address, this can lead to Rust Binder
> > installing pages into the wrong vma.
> >
> > By installing the page into a writable vma, it becomes possible to writ=
e
> > to your own binder pages, which are normally read-only. Although you're
> > not supposed to be able to write to those pages, the intent behind the
> > design of Rust Binder is that even if you get that ability, it should n=
ot
> > lead to anything bad. Unfortunately, due to another bug, that is not th=
e
> > case.
>
> This all makes sense to me. What I'm missing though is why not reject
> VM_WRITE mappings all together? Is there a downside or something that
> prevents us from setting this check?

You could, and it would probably do the job (assuming that you check
for VM_MAYWRITE instead of VM_WRITE), but I think it'd be more of a
surface-level mitigation than a robust safety check - in my opinion, a
robust check should, at a minimum, confirm that the VMA being accessed
belongs to the right driver, because other drivers might do random
things you don't expect in their own VMAs. (For example, it wouldn't
protect against interaction with a driver like C binder which reads
PTEs back out of the VMA in binder_page_lookup(), makes assumptions
about what kinds of pages that yields, and writes into those pages.) A
driver should not be touching VMAs it doesn't own.

