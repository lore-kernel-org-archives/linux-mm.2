Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667D8FCC04D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFAB6B009D; Fri,  6 Mar 2026 12:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D1D6B00AA; Fri,  6 Mar 2026 12:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968D96B00AB; Fri,  6 Mar 2026 12:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 836346B009D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:26:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2630F1B857D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:26:15 +0000 (UTC)
X-FDA: 84516316710.01.D7CEB02
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D23A20008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:26:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hGltMrki;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXoAF9tL3+VPI6JSYFWUnj4K6k5UECUl0E2snUE63/0=;
	b=bBPRdou/ZqvUuyJi4Fytp6IWDdjC2qCeU/dLDRDUHpyDHBpO15qpU+v2GxZr14R+CpIty2
	I+bwsOxI6tSKuSAoe1V7iqZynxMvXS604T72JNX3DGjKRl5zZCicVcJ8BUgwiKVrovH5EK
	gy9GR0ew8Hd/D4L3e7ukMCbIWBdYQ70=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hGltMrki;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772817973; a=rsa-sha256;
	cv=pass;
	b=ZIyshbEsvV+u0xag8F7vsoH81zbWEaRNFKpD9yTJsh2FtN7UnI50COjy7lDFDs9DGRJjNU
	BFmXYUxELuxxnG8fDY8scjsEcBld2RhSgo0eL9iUnOacsF7E4vw0eE8g8eSpx2z8JVYuCk
	2EMzCsFlTmZ3cZWY8MOcpyHsdRRQYcY=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852a8482fcso4051905e9.3
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 09:26:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772817971; cv=none;
        d=google.com; s=arc-20240605;
        b=Ua9qQf1t75TwQJiusOfDnO3e1m4MxjJPSyxIyL+1JX8+1hLLbbqHOXVOvweEDMUO/T
         POXnYYypcSebLlvNkIR48WW30Wp+RdmgMEZNGr82rCnM5eKFbWBU30AuMB6jGHgMkBKy
         lH68oS6itdcHUl+Z65KBWzg3jgw5cS2IrgHmCpkqVO9vApikq8Y7xp51d4XEOB4koCjg
         ncCKbUM/UI1jZnReTs14t4wixyJA5Y2CG82px9IVBjncIB4uq32bXQmMaVSDlRPFfoAR
         2SXQBVFVgv+KVsCIe2O2y9fUBHfi0hi4jNZhwpr333WhOf1dMCtv5PQZjb7jlQd20woJ
         yzLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OXoAF9tL3+VPI6JSYFWUnj4K6k5UECUl0E2snUE63/0=;
        fh=JHdlwSuW2icCzau4iRXAQEagH9WCrJj+K2oTVVW4nW0=;
        b=MgMnqLVfBE9S6W+3gKLEtz0dWH+cANJ8d4DhUy8cpiJjaMhi8nYnmravGtaeXpqvdx
         4+saT+Y8nm7347eVsOWZPJPM2Q6q/2Crsu87rWIuc9+vCw+FYlwwWSWS1AoGJpTBaeML
         BXUv7MXR1zxYRgAf4MueGCFzWaeulhb8Ejjrplr2gVJcGicjIPeNOqk2F8A3mSzfs/9Y
         LpqFoiP21eyLW9QmR5uD7LMAbOJetBpPB62mB3LPsD4Gz7SJFgPUmtf9Nmj22V+sqvFw
         Hj2gKO9Wql8T40b3/oLwqDrNHbVkptJ6ytRmZSDIBG43b79lzvuzgAMkXd5W7P3344aV
         PsDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772817971; x=1773422771; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXoAF9tL3+VPI6JSYFWUnj4K6k5UECUl0E2snUE63/0=;
        b=hGltMrkiTNf2L6NTaCyfBVBXvod4W9GdsZyo5+SwFZKV+PQVHKVYkxFRymBm6y1lbY
         6ZlbT5vFZmElRetAne2ot8G4lpLpuGv851OXBOLN6m2vLWCU9eXCYYdgxnVI4oWexQuk
         iF+R16aYoEmR6w/ltpQprTPWQR31Dq4kgnOFpkerGxJzOI8ifmywmrzJlYQhWx4DGOab
         MuLpGpnaiOgaMKJRdhSKOc7t+QYCJKaJqKHQbxqqj/ZBzCRljA/LDDiRSV0OLkJ7UE80
         uceDm1IsOJmZmzOjVOUhy3U2A2dosV3h0niNcpFL2QbTQxEjwW13maxCFm6nhBAqHida
         4/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772817971; x=1773422771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OXoAF9tL3+VPI6JSYFWUnj4K6k5UECUl0E2snUE63/0=;
        b=laNiBuCWAuezPpgbLepHrKZ32NB17C0TD6qqoOXRixgaeMQcg3G37CAOtBZdyX+aiF
         z1xu8uCWhoVssbQ7IhPlnyg4rd4Rk+jIL/xwhy5HgnMBWoGg1dfaK4x5NAPZnBRPSC1D
         /9WP1EBH/miG6O1mM+vV2vtO/AtyGjNCbE3pMPgPr8YaXhK7LfjJW8sBG01zvHaFLP0z
         2JCku3Nfzc791v12z3koFLs5EcNm9bTjQVPKw6mE9PP+Cq1QcRd4YlmFsc01ttrf4v7p
         SLh11ahtCgtXqsfYleahp0IC7XMov9/riSFbNsADK56KDnpjNls/4gNznYqJAZPkEnkn
         3tyA==
X-Forwarded-Encrypted: i=1; AJvYcCU6YCwFUmSxwGxlF5ialaTeKUhj4gPOR2HaJhj9ZiBQZ076SEct6chQSOzD4NDrNq5oGZ13VON3IA==@kvack.org
X-Gm-Message-State: AOJu0YytspkXjqIPZ4s6tv3IXgYSb6p7uSOhMYlusr3ouwnijnbbYUY7
	srqYGOMI42+IBgBtvsG2MjdQKcSRx2fJy1UzOkjansNEbDIx7096siwzGTWNGx7hb1EbqlS1oB8
	O8lN6Q34rW57QGenVau8uqKawJOFTQLo=
X-Gm-Gg: ATEYQzyDu+VMLt79odrGlJ73BHeYYhKIDL7EYgRFyso+i5SWLrLoUyx/fr2VwluTQvT
	Nk4gOuleNxBw6lzui5J7rOM4ahwsrJZdlfEaNEmXmqcgR45xwd7p7JdyeWwyr4mOSytSuoi/6Ef
	KjTA8y5C0Q+dMCPUFsatOQ+nFLLNB/yLLwL8CCkITbr8Cm9CzzVOFhuvRpEYOx9rz2S6fyX93Sr
	6Y4APDpOZX2erzrAfYuN8eZBkX6GbRLMzFFVbwrqbMnEPhn4U2PrvRiyTPuSpEovF0o03cMv34t
	DH1C/WpU8Fa8XzfZYShP8SF+YW/PqvzwLOrDbIE=
X-Received: by 2002:a05:600c:c10d:b0:485:2af3:3f8e with SMTP id
 5b1f17b1804b1-4852af340a8mr13583385e9.4.1772817971296; Fri, 06 Mar 2026
 09:26:11 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org> <aaHaSRXNLJNLwvKh@linux.dev> <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
In-Reply-To: <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Mar 2026 09:25:58 -0800
X-Gm-Features: AaiRm51eCjedDtTz6YDXhmWxW7R-HQUcg1jCCrAnYkoBaA_IeWwuyEDe1W-AYNg
Message-ID: <CAKEwX=NKLXmW7SkOs+gdbQuv+=hFLrBt-Xm2LS6sRT-2z0iAsA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Kairui Song <ryncsn@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2D23A20008
X-Stat-Signature: ue57g7pugrgqbzbk1hzic4okaxc7ao9g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772817972-824737
X-HE-Meta: U2FsdGVkX18Jx7uMsJCIM5HSDvbILGWE7p0XRewjn0N0cKuRTe1mDEqkOlJf4hwbcWytmfhHSemRupJwwezxxW4t7b76KEFrYokPw8U3URFMbIGIFCBZnqSsnEP2LiZm9MSpyn6BUDWLX6yXbuOW5xRoSZTTnywoNleyHyfT6fL53mry6FAt1w+2yJNWDyHHVs2tHYNzIHzDXIIMbBikghGZjGyrOLjpXSoXoXCR0iWZISc5a9Bk9DMV+BBM1aALpLSgf/vTAEYvNhtJ+SbbRqjkLM8ilVUF0Ur5HplFvnIJUkAJzcP0tYRlb3UimhsqyC30C/X6bmRp6QBgJSVlkAbK/c0LbeBn+Wa5ISwGuYDmzFf1TWaBu5G+Bfd71Bh2RRRgPepb7YzdRCV0zu09P3PmAvnKqgpLnD5Ht7x+jo5xsxaRbjbOpRByoyJkVEM9fYmOMTEGnT7+w4IokTKwzwxmoBNqRLwi4npYCC8UTthHDt9u/vy+eRdl4HU4gc/ynb92i6HnN/HLmxVUi75fvcN4q3CIU3Qd717NoViYVfotJynuboGn2KIKU+ovt17yUeYrSi8+DmeUCPB1lLyuWfbjheBGVvQIz+dPl1ClqXhpoly5dSO/0W2Suzuq3wDX+FUcZ3bK9oNZzpcBYV8uBh16jMANUvFqpxIb5kdMfUjYZDqUQ9+Nejx4rsnEaXo/15Rh4WdQztvNiPe7oXR5Jaw4jQepRbkCAYG3phgeV9o4uz0aN/jW9ZEP8DK1v1Yvtkyk4K/Hb7yhErNv+H6B02UJAyFUNEVCT3oYeOlbbhCu1F0+1loo4OOLTUEkvdCXosnoQuqgMHKB1k9Qkcs1mcuEoGoVAf4prud0gk8oa4NhtHAJNRuvmfb9aXDNUIuc4Uf38eb3P20ngqG4NwvdHIQ2Bi1o9WNpdhzveDDDqq0RPHE8vJua7IIXKAVA5dzKBEd77+Js3ZP/n0U/7Zp
 qIZOYAbL
 O5jRfSdvNX181HyB46iw7s0m76eDZZOfzVg+2Ouy+PzivrSDtxHDk9vz0vQZ351Nz7ZrN6DC6Nj5ed7xmkRLQSxehAh+QbKsuBBHH41c9mZIHwEXzgO1cuE0OBm+zpXWxcxG9mtUfVJeFCUok7uAune2tVZZ9yrPeOIEQ9+jPn1/BmbouGT8Hw7iAQu3bZ2hdOvjZOCQwMTw1GGh6tGUrZI5xEyZZbfcuATbTJ8Ec3duqsaBw7H9bwlQSArxWuPhoApIDCjGHMsTWwawCQzepAe7X3zfA+PeEkR7oMnPH8qoKvcw0MRr8EiExsP07s9SLrbeKKcXtWbF9stbCxYTg8+3+wO+p02BWgklij9/oHCWHws3UgPeQ3pzfWew2da5S6NItDpkNlOZyndE0LgfSZCXDJT47xcomvIlpwsH5CMMXF2jKd2HGw9opyAB8Vu5FcB+0KRPvyeCPYmwC56UA5/fAOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 5:32=E2=80=AFPM Axel Rasmussen <axelrasmussen@google=
.com> wrote:
>
> On Fri, Feb 27, 2026 at 9:56=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> >
> > On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
> > > On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > > > MGLRU has been introduced in the mainline for years, but we still h=
ave two LRUs
> > > > today. There are many reasons MGLRU is still not the only LRU imple=
mentation in
> > > > the kernel.
> > >
> > > To my mind, the biggest problem with MGLRU is that Google dumped it o=
n us
> > > and ran away.  Commit 44958000bada claimed that it was now maintained=
 and
> > > added three people as maintainers.  In the six months since that comm=
it,
> > > none of those three people have any commits in mm/!  This is a shamef=
ul
> > > state of affairs.
> > >
> > > I say rip it out.
> >
> > I have very similar concerns. Though rather than ripping it out, I woul=
d like
> > we put efforts in unifying the two reclaim mechanism (traditional & MGL=
RU) over
> > improving MGLRU.
>
> Shakeel, I think this is a great idea. If you have any ideas around
> low hanging fruit here, please share. I'm planning to invest much more
> time here going forward, so I'd be happy to turn some ideas into
> patches. :)

Not Shakeel, but I did play a bit with MGLRU in experimentations :) We
see some slight positive signals in certain cases, and instability in
others.

Regarding unification - do you feel like active/inactive LRU can also
benefit from MGLRU's aging mechanism? The page table walk, bloom
filter, potentially the lookaround heuristics? That's one huge
difference between these two algorithms, and tackling this difference
can go a long way towards the unification effort.

Somewhat related to that, I think it would also be nice to have some
counters to track how much work is spent on this page table walking
step for MGLRU. Right now with active/inactive LRU, we can look at the
various reclaim pg* stats (pgsteal, pgscan, etc.), both at the host
and at the cgroup levels, to understand the reclaim dynamics of the
current workload: where its spinning its wheel on, what is the reclaim
efficiency (for e.g, pgscan rate / pgsteal rate is a nice proxy
metric), etc. With MGLRU, the page table walk is a bit of a black box
here to me. Can we have some measures of the effort spend here, for
the sake of understanding and diagnostics when problems crop up?
Otherwise, we can only study the overall CPU cycles/PSI, without
knowing the exact source of the regression.

Or maybe there is already such counter, and the documentation is just missi=
ng:

https://docs.kernel.org/admin-guide/mm/multigen_lru.html

