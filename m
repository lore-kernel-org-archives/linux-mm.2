Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2438ECDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 16:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC18A6B00BB; Thu, 25 Jun 2026 12:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99166B00BC; Thu, 25 Jun 2026 12:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87246B00BD; Thu, 25 Jun 2026 12:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A93506B00BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:39:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DDC0C09C4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:39:54 +0000 (UTC)
X-FDA: 84918996708.26.5CE5585
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D4CD80008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:39:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iilwFDfn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782405592;
	b=kyn25xhTcSXKcHDb+93e11bWi1rsblmbigIIsmzWJDganLp73tZ80K+X6J0l5C4vokp3mj
	aIdC/zL3QMI8YtEb7Y8+82RG7+/rKnhfAGUyYi3fYlOy4Qn+CK4+yGcg5pPMx1nkOuQhze
	s5E72qzX9/2S2TUaF+C4aLVYh9wxcg8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782405592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om44/un4X7gR8LEdF/8afBXQ9SCkGmWgSkZBjmUY6f4=;
	b=trwk0x7KvBr+vpFkhuGU+svFx4EllAAALxM+kaWb1KuebaV/ZDTOMj2rxNOQ4ZfLJLgoxt
	CzoAfeFsThT4GwNnj5IUO80lA/4y+GJV1NDbY5I9toihGbvTHHOBvaqp3IonmFfCd8W9FH
	Kp60ElG8T0boyPidZwKiMc1GDFB7apk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iilwFDfn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-46cbf263113so1974537f8f.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782405591; cv=none;
        d=google.com; s=arc-20260327;
        b=LMB0rYoQoqgs29u4cXXUFigy+A3i/EI+7u6juUEZ6LD5YIcj/EmmD5gwe3Vvli9f5+
         GmTYkue4MHvhqjdGru+4uKKQZXALq11MPXmqXeFdw8iui/niHkko09MSonooNjMyS75l
         3jhvmPA+v+VLR1c7GM/8NN+3yApaMypPvVfwIyWn4IdsZeZpQGdw5IuzmgvRx6Jrjry9
         ORoRjWb8R8WzLFmXcaFPiVnCULy+yfKgEqiPfjfHWp06SRyW8EEXo7sI7kVIKaIBtZmL
         urHeCtZh7BbfC78HKMOHWamtlPanL9BOWGSK0xP68iRxD/+kMtjd0GOxKGYmMwP6B485
         iu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=om44/un4X7gR8LEdF/8afBXQ9SCkGmWgSkZBjmUY6f4=;
        fh=98PUK8Z+f3sSJp7Hg68gQ/Nl31RyQIrCcqtnaEWWkEk=;
        b=jRnhZHu7zXmTsjqW8kQcOtTHqw9YyXTwBulLe+JZWgOC2IQy75lRIzYlnlPHD5uA5T
         ZP94UjFDrs+3SFfn8hJSQ+Mf2fBEAitYVLpcW+TR37HjinR56pzoVGExCpz+CsHcAHid
         1zfLin0NIb/sZ2lUw2KCI5PSLubP45cn1C/Mi90Lhb2/p/f9pxkzgY4yQYxwWIchqu5r
         5gHEfX8fR9W7wRv8s/KGHDuFRQkbBBseB2GtTq36N7kqWV6HIjrPy/SXsmanH92pX6vd
         WCcc4Re+uOEgUZ1iq8Cm4wMiCopMumW/NK68OXgWpPV5zGLUhKXZs5EsXTxwOUVW+5gO
         EqVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782405591; x=1783010391; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=om44/un4X7gR8LEdF/8afBXQ9SCkGmWgSkZBjmUY6f4=;
        b=iilwFDfnxpKIbA9/ap7wsIwAWT48iC/piSZXQ4/rDB8wtV4EKjwSOtMocRfia+nimQ
         FiBRUNBKAPnT/TdNMPxuUcKiGo6iHKinsbNoyRAqvuvb4fpkuprwv8A6tToIKkxa5ZzE
         M+Q+In4pWOGBufz+iRpQCx73cSX+gVoSO/TSwHMouFZLmaiX12OZGrO67sEsrnUIx8fm
         lLijDjbcfFa/xWb8hVRghWeUE9sp64Iu9O2+8cVjt4P9nPD7Ks3fFVeFaz4cD+dryRvz
         Y/lRnHLtpsiAum0h4mGon25PZ06nebLj51hrU4jfGvIcCJDQ9YFIlldnGrplPzqDKbbQ
         bW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782405591; x=1783010391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=om44/un4X7gR8LEdF/8afBXQ9SCkGmWgSkZBjmUY6f4=;
        b=m/GtNCb+QZUSoq+N2O0lVi8h2d0ubnq5AZdID++3+gH5RjpLjqn0Lm3yMRxEbOzYaS
         d2C3VAt+IhqFu1C40FD7BUl5CNt1OsLi+V6P14C8Ye64Qqoo6mst+p/UVk3uIXx5JP+H
         VwEKpOHyDXVWKPQjB6p5lYUSroCl6nHYAszvrJ+q9et5Ow5tdpoXD70I1ntGzwP9FTSV
         HelyGnv6iOHVOdlOyp9vzelS/cv0r7b1FtZ7SNnNcM+eUQ4Ikzijf/2CBrZsLTTdiq0V
         CfAh+HO+B6gdh7anrRVWAznMHIhI8fPbW6IHhZ7tbCUnDxNC0ifVb3o0zafKIvtqxHSx
         yoVg==
X-Forwarded-Encrypted: i=1; AHgh+RqrnvvlQgTX8IXbRTicLNFU10uZLV6QLhLT2vw56jKn+NMrCT9R23DSip77VxWNPaM0MaNY9WJ0TQ==@kvack.org
X-Gm-Message-State: AOJu0YxE5/JoQCk8TVInX9Lq4pjbIpQurTbneMlpv9WqM64Jlu1/co72
	KvT3QRuibUaAxI75dad6OEslZ9duH+4M/dtHBa0itOuBFnn0uCrfGA6TWNFNOsfcaq39VGEYdFn
	CGLswjakC9PlbTbxNdjWxFwR64d9vMeY=
X-Gm-Gg: AfdE7ck/+hhiwndB3MbR5YMKPlhFa8GbRcXIv1178dX/y1SIyhr/VYZfd/kN0qGly83
	sqoWcXgadx8AAi+q2aqZFAQB1wbDZOVZwv6MytmS5IcR4AHv/epPI1G5sW4czIOgIdflLQhc1bX
	TqCH1wCX2b1vE6rztvSbVkVRoApHj+sizVHtm/Xa6TjutB6t/pLgLTimiHt5aEInHrBTuRF9MmG
	ViM8FUqiIxU3MU5J6GQEc1cxotZs8KLNAMvJ1Z87l5fgnHV6lzqD/w2/AM7dcyq38nl5AqSmfWM
	VtntkqglXsI3gcOgLYqbpvbnj2ZS
X-Received: by 2002:a05:6000:5c6:b0:46e:765d:78aa with SMTP id
 ffacd0b85a97d-46e765d7e1dmr1673937f8f.2.1782405590672; Thu, 25 Jun 2026
 09:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr> <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 25 Jun 2026 09:39:39 -0700
X-Gm-Features: AVVi8CdSpZj0pyK8kl2IMfovt5NIB2l5dmrkirClMBDJOdPSR5LdM8Ue4OUgOL8
Message-ID: <CAKEwX=Oew86XUYYT49MWo27DnbEpZCnPn7+Kc-uQvavHBpf9XQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	yosry@kernel.org, chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D4CD80008
X-Stat-Signature: 4dnrgdnj8njp5qa4nady11inohj163tc
X-HE-Tag: 1782405592-711819
X-HE-Meta: U2FsdGVkX1/pUyhZxfgBGZ4Sh8EDLqNCD5Udpw+v4b4hhsQCT9TC2d0+9ozeEEmh/HkgnnQWwLG13tjIqOcbDMK1KmD6KJBkyQaIY+Bn1VCB4cGmTgHceZH2XsHDkEONqM3SNa0zhb/K8qZrzJ5tmbTWPULSraF75/HSAjRVxRv70iry2IEeVx6177dn5xwIGILpoUAaPU1MobfzKWnM5kMf/8T6CM/6TqBT/IWsUgwuoXj+EzlIlvTeP/lp/K/vf/voNXtRbrWvIEHkvWeSO1o65qn14tvwhtaDBB6/mbXCTDxlHi7ZLuaYM56RTqV59V8h9VbF/O7KDdBMi/ugFdKX86ZTrZAIJkH7Ew89sWxlr0qsXEmd2JCg/h4L+g47mooaW4/CFB+4txb8OWD+Z0zY7hrV0QCtA5yBlEu5iiFNeu6JOSqLU6VlQjsOc86OpY/Psw/BgzpoJeJ1HREtDvQfw6XJILYbuNcgekpnWFoJlLoH8uRYi8Crxi6j1j1FMQjihk+xTj60qTZ5kEMqr2n99vd00PBcBF7SFddaknWXQGB5pQlCcBwXhM0Ui932kan9CDROqoPNohCOSxMit1PB3KOQT4199+nVrHBv1DAbvID1+LjQAVFeEA37Atcjh09G+ZtrgrWtdkTXWxKwALpIp7uBqPE+aVqmmjwd9xqAQsB7gdBTx9IarIFSBzbh1tXsnIwlnuhuQMiWEKCqvgcZcTnERwsYkqusOAzwdJxeQowKSY+kdR+64e0ULxRzNoGYPkCiV1sQRKdeLltiNk79A7b72s/SDLNEVodEHg2utPMlCJPgNADxYvZapCOtSI7NxHa+eK1Cm7Fwh58BnEWHMB2ZRcbGX0LKa5D6vj8oTiNZbaWQ3vxxzmk/QKwisqBNdu1cTeU/TzYDq6PwscEvdbpAhwyHBUkfQTvA5dTFyJRsiYDo9f9mDRTIjCgQ1hQ5XNY+mMv2OkleK/W
 VHateh00
 eMsfWorY8cZUbP5Zt2KVeM3W5eaXs0Y5RJ538MMBR1VLjePdO2irqEGePKsYCJjeBL7a8Fd3xkqaJU7mbgLHP/I0m+FnS0+3zeW6McvrJ2vaX8JrSIfz48Cv7XfDdHpXKpc1WhRdMzIPYJAC7AQTI/utvcj8I1rrcJPZ2y5LOL0g+n06MJG0FrTls9NKg6m/vzh+haUANEYaaSZ+HCCWIR46xvxL4Mc9gEgvw5QtiiSnATfF4br34BxlrhYnMqxfKsu6Xxb9PqvC3Hb6FLzZl0TcB8aX6ifg62A9a5xGWXlySJ5vZZyXUWUP+6G6zgAIvaf7SJKLvg3QjgbrPpuO82gvWpoaXu9FPlsf2PJJAYQUXFnyua3mKuumeOUWTR+ZLbGxRy06P0FnA0rhcsVXoi4tRJ9nKbXrL2oOXlBywHS+5eDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 12:24=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> Basically, I have been seeing the same issue recently. If the
> readahead swap entries are also in zswap, we end up doing the
> decompression during one page fault, but then need another page fault
> to fetch the page from the swap cache and install the mapping. In that
> case, readahead may not be beneficial.

You're playing with zswap? Nice :)

It does feel like we're leaving some obvious wins on the table with
zswap here, so any ideas are much appreciated :)

>
> On the other hand, if the readahead swap entries are not in zswap, the
> situation is different.
>
> For example, suppose we fault on the swap entry for address 1 MB and
> readahead brings in the entry for 1 MB + 4 KB. If both entries are in
> zswap, readahead does not seem like a good trade-off. However, if the
> 1 MB + 4 KB entry is not in zswap and would otherwise require storage
> I/O, then readahead can be beneficial.

Yeah I can see the edge case you and Yosry brought up here. As we move
towards supporting multiple swap backends in the same system, that can
certainly happen. I'm hoping that locality will bail us out - pages
close together in virtual address space hopefully have similar
lifetime, access temperature, compressibility, and will go to the same
swap backend, etc. - but who knows :)

What if we still follow the readahead logic, but at each slot in the
readahead window, we check if the entry is owned by zswap or is of a
sync-io devices, in which case we skip the readahead...?

That way, we will still submit the IO work, but spare the ones that
require synchronous decompression work, which might affect latency...?

>
> So I implemented a rather ugly fault_around-like mechanism in
> do_swap_page(). At least with page-cluster =3D=3D 1, I am seeing a
> performance improvement, as the readahead folios can be mapped
> directly and do not require a second page fault.

Hmm so what your proposal buys us is, if we're already doing readahead
(synchronously), might as well install the pages in the window into
the page tables? :)

Could you explain to me how does this improve performance? If the
pages are needed, we are transferring some work from future page
faults to the current page fault. If the pages are not needed, then we
are just wasting cycles right?

>
> It is admittedly quite ugly and is only meant as a proof of concept :-)

Dw, arguably it's easier to reason about with everything open-coded ;)

