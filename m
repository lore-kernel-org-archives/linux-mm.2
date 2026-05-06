Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2E4CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 19:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8576B0088; Wed,  6 May 2026 15:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769546B008A; Wed,  6 May 2026 15:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657EE6B008C; Wed,  6 May 2026 15:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 517896B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:04:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F20AA1C0C64
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:04:12 +0000 (UTC)
X-FDA: 84737920344.09.6B3FB4A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB703A0007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:04:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hQ47zWR1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778094251; a=rsa-sha256;
	cv=pass;
	b=4+cPMY1YO+9h+fO6+MFRjq8c1NUQRMVEQD9RusV8U94Uefw9qOxM6Ex/ytTnomXHBfaCu7
	NdjYxxvNjav5M3D8qFOMi9IAs7yrkP6bGSszuAl/Vuy9qMUUyj/961zSuetvO7UBLGDQ5g
	eXzAVmONmc/2fpXs6CEDABNWkENy548=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hQ47zWR1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778094251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQNhNsn7g4BSCVihon+EVLcsgsd5UZpqTryADMVDWrU=;
	b=siQcdqqAuT3ZLiIQ/lsFwHaUA4nYGr2DEut0EKtcZqUafQNYRS6u4sCh9tvE8ptXpX+E6z
	14au3MjmypHdsZOMf+gkka4WM9Axf4SPK+0SKYTpbJOJsAitWajYbZOjLKM7t5H5yvUWuK
	2FmNXAW5vGy8tE3Tld34vkFirVLgNvc=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so13354550a12.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 12:04:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778094249; cv=none;
        d=google.com; s=arc-20240605;
        b=ZDlMBKNub+Sjj96n5VuuPoqQxcg5cwvuCJph3mYXUBHRxQ3jRNA5hE8tE89ojfPPWi
         +w69YKAE0T+xCmC28gOEHJTvJWu9xFHZciXIK53TDNSWzStysP0qysX8vYyIMVhhf+sz
         Am2gkKseTvhcKG1DhJvxSPKKxBM51c7JYs9iTfFabg2ZKcqGM2vYguf5PoI7qjvwr9/r
         K+ZD588BOlNFJpqVMSGZN2IcRTkWj6gS7c6u9nfT+j687L5jItEG8fQJR5ZMx4Yx/urW
         nqdir+6+JZAS/DuZVNHziux+dFtqLGAuV8C84sIQoEmT0b2TGu5Ycjecffv0NLhp9xO0
         wfGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KQNhNsn7g4BSCVihon+EVLcsgsd5UZpqTryADMVDWrU=;
        fh=N1jWAf25Jd4BzpMzLZIlG7l752JzQHhiSg+iMUMSSdA=;
        b=Aa8TirSVZLnhTsxPiAsXalxyJfG4bZ1e2tEztGHVEoLGGRtGZWlwR3mkW+S9ikfIi6
         qYbsPRVBDpVF22ARY0IwvO7KqZWzBdiXBi2IdOsF5G9OYa1pCqlfKZ3UCArDiFf711pT
         FdT99qwIebPEDyHQYqFvibLIhj9ON8y7QIBhS4lun1WfYRgenBXaDDuNh0aF3KWeY0CZ
         d+BSLRt74lQJq1ZgNd9O8Fpm4dzH+lBzCzvP/4jVUq11+omWlS7gcHml/rNrpQlPbGj6
         IsU6DJ1kbdwIXccrb/K61cX6uxu0IbfEd2CPtn36tMAx/Di01VtfsRFI45T0s+9JUQ1X
         v7cA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778094249; x=1778699049; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQNhNsn7g4BSCVihon+EVLcsgsd5UZpqTryADMVDWrU=;
        b=hQ47zWR1yRhr9NZmdivssTU8+dYcusr1X2S9i5uHDM/PWGTj5NOuKzwk66y2N3vALJ
         01a/bufc52Ew4hkz8tYdbxCrrHW8bDUIpnQtBqR5B7j5rcPVLraUDFLgoGx6IFEj7lbk
         OPc5ZXf4AGx/zcwlAS07YefyMTg+u6J1cRZUgxuNcRYNzkfa9uDVO0Mk5Oa+PrMTXYCa
         4JTBzX9GyKyi6907qHbHk19DPNuEvUumdwFhIjgqocxL3BEyl4fovUbwCzkKGMP4Jtxw
         A6egxDl2ZDNynSfk+EpQNauZP+pVOxEFJrRw6yOWHJteGGu9I5XNKgZOcAMhuUQTb5/H
         UEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778094249; x=1778699049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KQNhNsn7g4BSCVihon+EVLcsgsd5UZpqTryADMVDWrU=;
        b=U0XMXMlr5M0tSsiFnpSZ+YTG/CQzE//Eva4IwJjiJ2VxI0FQz0H7VWv4plh2FOY2Km
         LW181heFcv/87Dz3+KEJkSNcWeUuCI11eg7Sw3FO+rjuHcJ/lUOACyY9AA42V2mGem9p
         muaO6QZz/ziPGxv1XwXjhrgEZ4Y+XBI9uK7/Jt4DIm4blDd3H3JlOCb+nkqeygkat++L
         aT9Zr98rkqnBYJtFyKRyAtADYqxOJY557e2HxbMzq6axYCdYjEHhRkC2Bsm5MRgQ59bO
         nhf2YMq785HbKlDNiKy3bWeQPwo/6wXCc4Na0FXGDx4M5YBSS6oadR47f8pGeQo5q2zW
         11WQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HXbWjMRqiZmdAJmy06QD6Lb/UqKGfLVsep46xkIKOhwYQhAm7FKBveTodhCnAP6myEpR7QMaF3w==@kvack.org
X-Gm-Message-State: AOJu0Yxyfcd+9qncoofbzqQlH2wV16G9d/wBETjhIoPpYW1UZxapiYci
	fVY1fmY8sbj8J4MZjJ2lmmTHm5YjXea4h/teyhw7txEZvdzC5P3FZo0JaKSzmkERKwWCeUi5r66
	VFP2QXK6JLiV5MEx/47oPFUBBrt/QFlI=
X-Gm-Gg: AeBDievBP+Kd/IfQ3zxowSMITIjQO1rF/ZkstSeuG7Ude5p/gta0/90jzGwfycvvLCS
	VvUOKSPV+lxypYpzoz9ILnxG2sY+YquI71Ozrm6y9v/XG9mRX72aUmjXinc2DHbOmw4rQw9xBwz
	wBbPG+tsBrUsvlclHGMEvOLeLh9QIybnZePeVCoO4dR0+oVsXAuWSimHVbgd0L2gs1Ja5JB83pk
	IJD4Yl3rIBtlo6vXwiMqC1noEyH6PBhwCAaH5hUkfomFP3t3vU2epZ4K8FEs/dDyv8gaF6h9a8Y
	251MAEAtZVsD79Jc93nPZOpP6CYQqZb3JZCIn7KmyQ6IuSkcOKOFxXNXc43QTnMwDAbT
X-Received: by 2002:aa7:da97:0:b0:67b:790e:bf12 with SMTP id
 4fb4d7f45d1cf-67d642c098cmr1683384a12.12.1778094248870; Wed, 06 May 2026
 12:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <aZ-DhWZbTnTnBh-D@fedora>
In-Reply-To: <aZ-DhWZbTnTnBh-D@fedora>
From: Vishal Moola <vishal.moola@gmail.com>
Date: Wed, 6 May 2026 20:03:57 +0100
X-Gm-Features: AVHnY4J5bXBDym-OthRcXAmbwl7VnoVd7hf0XkBnRx959Cx_DCsD3EtSnECxTCM
Message-ID: <CAOzc2pxpGLe4JXNS4kgXQGFLaLO_k1PRfpiJrciO6xO8L7A8dA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Separately allocating memdescs from struct page
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ru8rjzmh6qjxmt75zttsz4xjtkroz8aa
X-Rspam-User: 
X-Rspamd-Queue-Id: EB703A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778094250-222027
X-HE-Meta: U2FsdGVkX18B1Oq10BF5WwusSuA2K/xYD7teEp9u9Pone0b3iC4zC118hvXnh26ZgI1T6XI9ja3kL9kejCCFx5fsvZm0dJB6fdYdkt05H/Pv64k0fDC6y48nuF0P2vYz/2+q27lP8rlX/abp9lMwHL2fUAP5n45wo93sSki9VrV7zVX5h1tZGZlfwcOkzWGaYdRvb//5FOMkcE/KeR+HhZ9On2bf3PpTDYWCVGB9RmhqgKq6lb/e8kjjhwr8DiAd3UWJlf+WAv6iD06bKx2ojIzl17dIB2JN3UwyYzzMQK9Iax4Svvg1l6T0511giW2OUBr/wYg88M9GGfmtdl6lAgI2Hkwn9+ZV15iL01SD/D1MxCMIXoHlRtDQo7EZFi4ZUFherJZcaF1bzbgWj0B5eXQxtD18sJYHQnKdGGBCxCP4ldRJf98u81KIz1oSaTcO2eoEh5oNfC9Ud1YJHNkPKW/utViZncvX8k1eH/8BwjvvPwh2pPfbq/OtyJdQSkZ5ym+F5E1Ggj9N62A+KaeOPp6N3ZmgoDcoo6rckCU4WKCXpSB51jDYizASuL62EXevhMRbaBD3vLV8CE7ptlJC3KvKRC9k6Ov265voxCehWJ72/NPyGB2djcCLmTQIrjeAPZku5LcaEpZMLhis/KAG9XPT8stK2uEaNWClCZJuSZW3SjPKZyD1GipLf+HQFoUGwf1D2y8kNnekeJrVoN+OOptFDLHgIOmKJF5GorTRMAjFzXm3CK1aTnz1Cbs0963DTdtLxWcm6pxuY8v5c2fGja5wBdQi3Ti4IH+bwoBTWLErCSDeUsEJDojkWt8XvdprL1rlFCG8o7o5OaNA/XniHH66tMfCXMtEhGj1zojuDigBRHd8G5kqwP4V386OIRdgMwI9zsymW9EqHGme1XikjWqqNirT529JNrkcUt7OjVpkTKOLWkVNTeo3MdHMJsyU5Cn4WWOae7LubPIumnA
 eOZP7d57
 g35ocu9wK51ZAkTmseV4mxsDjZIkA4BiRUF9PiCPKiK1T+CXcvaGFBenvJhaqyhvKqd91wWDovJMnm1OKiuGgUszu7u8urXp9BDmk9e+RYgz73TIP8tdqh1hFkAYJ2vd8vDBYhzVSQz/0RjxPQhRiXfjP+BrM9pPv6x9PeOwrbjfN+gTwPuOEdtj5JZAeywLOadMNEKUgN1Lkq6842ueBr12G1F1TjX68hVZUymRF64Ao/LW3YJhe/Anph92UVf4OPxB/S9YMevpnrZ5KZUWl1CfTQo6T9s3xb/zJLSRGcj9jB2Sz9W5cUgtG2qOk8slAoyv6G8Y4vYb2Lc5y5hDseiw34QfJCCLpAtHMimJ5Zlc6VgUMJ/sZq7hL0mOnnAead0Dy7xJNpQiWhS/NMu8gAPyYv5okWNkQUtDrumJfekQ0KpSCwaN197ByqtkAVMH4LuVy87Gc8TO4TmQS4/nSoRcuKChDPDVP3GCYT8eOKRqrSCejyC4t5rQACeCCqyOaxOCoU7wDRyZIBwW0+zKrTnHjnyFMnd3Gw/QUNQZ54EhCq926khX0Sdt/6ayLlW8cAFMNmjHr27j2jV/6Fb/XiB7kj3xzWaZrTQ047uKDWo3Azbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 11:19=E2=80=AFPM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> As part of the overarching project to shrink struct page, we've been
> creating memdescs that currently function as wrappers around it[1].
> Until we separately allocate memdescs, we won't be able to shrink the
> page.
>
> We're getting close to being able to allocate memdescs separately from
> struct page, and I'd like to propose the topic to discuss how we want
> to go about it. We already have Matthew's PoC for ptdescs[2]. I've taken
> that on, but we're still running into issues for now...
>
> Heres a non-exhaustive list of things I'd like to discuss:
> - What memdescs to separate allocate for shrinking the page right now
> - What are the implications of separate allocations
> - Should we separately allocate one at a time, or all at once
> - How the APIs would look
> - Are there other generic fields to be cautious about (i.e. memcg)
>
> I imagine Matthew might have a broader State of the Page talk too, so
> this would be more in-depth. Possibly focused on ptdesc & slab (as the
> two we're actively looking at right now).
>
> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infra=
dead.org/

I've linked the slides to the presentation [1].

Theres a mistake in slide 4, the correct labelling of the words (to the
current page) should be as follows:

struct folio {
        memdesc_flags_t flags;          //word 1
        struct list_head lru;           //words 2+3
        struct address_space *mapping;  //word 4
        pgoff_t index;                  //word 5
        void *private;                  //word 6
        unsigned int _refcount;         //word 7 (first half)
        unsigned int _mapcount;         //word 7 (2nd half)
        struct mem_cgroup *memcg;       //word 8

        /* Below are for order-0 folios */
        unsigned int pincount;
        unsigned char order;
        unsigned long pfn;
        /* Large folios will store more information here */
};

[1] https://drive.google.com/drive/folders/1KGlxnmg-nQ64uAK8KBp8DyNYiaVbTWG=
F?usp=3Ddrive_link

