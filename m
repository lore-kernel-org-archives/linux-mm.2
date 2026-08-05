Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121E0C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 05:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C576B008A; Wed,  5 Aug 2026 01:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963F56B0092; Wed,  5 Aug 2026 01:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3DD6B0093; Wed,  5 Aug 2026 01:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639AA6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:09:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B2CB8035A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:09:36 +0000 (UTC)
X-FDA: 85066037952.23.8731C47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94B1D40009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:09:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNXJqqex;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785906574;
	b=aUAyXbPV1uQBzFMAHUal9U7QQDz2ixI9UUO7OBz0QLikCww1HQYma1iOVo8gJR5y7hZMg1
	9QsPcDEUqBupC5ANmO7mva026sd5tw5YdnkvqP/Jv401U5Ehv+aU5yPGw7ldlNd92sf7ZC
	1NZTdPjz0zKpQ+8fWmeIQwMDK3W5mYU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNXJqqex;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785906574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGRN8B+oiUCwhIdRFiVGgA/4Mhd/w+5DlIvFXXgPh1s=;
	b=q98m8dn2V6tf7Va2MGmaNYOrS3rTnGMf5SgpMbOC641Q3TCOvsfBMVLg6eQa01jAM9lqnl
	uWURCNCJtvTbZNYxNI5Bkm0b8ZFhK43vLiXDXWpd7qnU0xEabFdmpf4lqwiR9mc/hJ5aDI
	rDNH/IMzubdxAnbkprJr2sIYL0SjR9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0584860A78
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF81F00ADF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785906573;
	bh=JGRN8B+oiUCwhIdRFiVGgA/4Mhd/w+5DlIvFXXgPh1s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SNXJqqexNJinynfIbC8K7UQzWxa+JvBZb9PQeMWbniaKr7dXoR5HdO+YO+6bPqBzk
	 6ytHCYPCSceCRMgO6GjwylzyvEQ5JZmTvxO5DqeuS8y/QQXMXlGo6b3cEndUYix56N
	 nG/1uUTnOkdWoAjEsjYA5KFOFzT/FFDHe2bSNCJnuETuoLF5h92KJwyjYQTpIgjetl
	 aElb0QWJUzAM04W5D6toZD+BCrseFsQQ9aiI4jK02FiZjejUghGIMIEcZ9APRlNStq
	 S2qADAno9zEMzBwUXbqYaKhvwPlqpmywSSnAFRLSyVIgte4JB39ahIMc9eJcFPCkbj
	 389fCMbUxd9RA==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso3794126d6.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 22:09:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrP6Hh0K1VIcXgPli/l7BRQbCx3iv8d0FDuGPdl21VkzrVTERGTBawRjWFyawYF/BR9flzhLVCWEw==@kvack.org
X-Gm-Message-State: AOJu0Yx4EZrLYHMbJp8s/FdOpHFWqurCmlhvjpsCqb/6cJu3gfyOTJ+S
	T6oSd90YIWKzJgmWKJ4tz3oCVa1gNkYq4tgr2vqIZ0BPnJWgDnC5q1rIxoOFcq3EKuTABWkKekH
	D4RoFskZGSeFXggAgXgJ4fbDlnPxszFc=
X-Received: by 2002:a05:6214:440d:b0:8ef:cfa:2a36 with SMTP id
 6a1803df08f44-908811af213mr55170076d6.9.1785906572908; Tue, 04 Aug 2026
 22:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260805005545.66112-1-baohua@kernel.org> <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com> <anKaU6VStrW8zaQo@google.com>
In-Reply-To: <anKaU6VStrW8zaQo@google.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 17:09:22 +1200
X-Gmail-Original-Message-ID: <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
X-Gm-Features: AUfX_mxOiqacDMh38a-x68O65S7dwQIaPq8KY8IbJO5yLG69FFifh7gqv84CHnc
Message-ID: <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, 
	ryncsn@gmail.com, yosry.ahmed@linux.dev, surenb@google.com, 
	Dongdong Zhang <zhangdongdong5@xiaomi.com>, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 94B1D40009
X-Stat-Signature: 9zmrsgzo1qkgppommn9htx4wp387exmo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785906574-729645
X-HE-Meta: U2FsdGVkX1+FrVARbhkUqusJ1wvfo2tBZkoBEalWJnnToSE2dwOX/z6SxlYutwtOqhX81sMAgPbfVGJg3G6kMYPc0n5uoun56L4lYEqTRl7Q/LhRpjfb1yrJ7M5AfpVF4ugjrV1R8XEmGsnUC5BTEYt+Jm8YVSUcFWX8xCzJnPpn0ATRKrKA3v8ILONULvEFWuTMEWgQslII4yXDKPmtrd3EfcNh0KNgO25P/M68rjpiIcBFiHqGfBwGmMOb5DaIrv18PKM/SJUQrmBSa0AfhJ1D5RCX7j1osCEawmafsvpk9zeh0QnF/PBsonuiN002wYC1le3vQV2f2ZC3ZxXU5kp+t8WxyIG0ogX3fHusnGn/p+qVDUr4ykW+aGhGPFsKhqcFFd780+jDrOei26R5CtkUuZla2d5ySpSlPd8Dzng1eX+2FmDmSIeM2xhE3Bd34u2N0zdwqcFBV8S1GKtEM+IHRNy6KGiNC2L+GcgoyLuDAmIVTrYxxPkZdb0c7if3+MNobtEz84R3vsXDBWhYx++WDSlCgRrmyJia0ibgm4od7iksJH2eKUCc3VI4gVfbDMJHLGD58Ejr2qNQPlOIW9Of2Ozw4eyfEdP2+jFOoukfvTvgnlb5awUV43TYMHyJLPmA67PY28fWBYmhsx02U584wqYa8ptPLjQw9jpu9y46dRK8WoWhhls9H2zU+DaGhRnIJUtS/T9as6NAiZp3HOGZxUn14GbYebaudvTVnXanwsgggFmfXf4GByavKYB8zsr5EUb9amlXOVEKrKpovzdm3A0nbBwodtSQ8zfn6M9q19pDU6WeE0DvFWwP75HEwrclYBUNQvSjJtwD1wW1Z29XN4T/DdWuS7Ievv3FrBizBtx2vu3QUpJODBQYaIGDH0XbTAHoj5s/cmZZepTaC4C6F5iEdL33I8yvw3EfUzkVYqGMtKTx5YgJNVBMOeZD6iDir1+ecEvioggNWNH
 WkqAKX4/
 KcWnNFS/7nRMxiNKZw8sek2hTWJ5SlnwKhitTDIwf9P+BcScHI7IN18wr2A4k1/htLzXlywtwV6GT2FSBj7eizUZh/2NhTu3rnV8+eSPijOa1npX6Pl0qUQ7mQnbqLbBgEtBbtFdUd2bmxrmA/pCPRCsnVoS1trqTU9b9MnKheg9PD22Ql+lzYkOMdqjR7dsr8/K38/Vvh7wZzmGNt6Sh1f48dq0La1Xt2q8YpEL6UwruomaVah27CBcNCB7D/ef+lez4A5B7COdhw9VRfczIGofGLyG9qq71WELopkuvHdtbwcqQcq1PZf13QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 2:09=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Cc-ing Suleiman
>
> On (26/08/05 09:57), Barry Song wrote:
> > > On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> > > > Since commit 2efa9e9eb4db ("zram: permit preemption with active
> > > > compression stream"), a major Android regression has been reported.
> > > >
> > > > The reason is that compression/decompression is now sleepable and
> > > > preemptible. This means a stream may be migrated to another CPU or
> > > > be preempted while holding the stream mutex. As a result, high
> > > > priority UI threads may get stuck waiting for the mutex during swap=
-in.
> > > [..]
> > > > We add an async flag (currently false for almost all backends) to
> > > > indicate whether a backend is asynchronous. For synchronous
> > > > backends, we use preempt_disable() in the !PREEMPT_RT case. A
> > >
> > > I wonder what does that report say.  Is that what I think it is
> > > (we discussed something RT related privately recently)?
> >
> > This report shows that the zram mutex has become the top lock
> > contributing to UI frame drops, even surpassing mmap_lock, which we
> > are also addressing in multiple threads. :-)
>
> Any chance you can share more details?  Are there perhaps RT tasks
> in the mix, priority inversion, starvations and so on?  Can proxy
> execution address any of those (if it has relevance to the report
> you are looking at)?

Hi Sergey,

talked with our engineers reporting the issue. i believe it is all
about priority inversion.
proxy execution wont resolve it as we have a sleepable zs-malloc
within the mutex.
 i believe i need v2 to release the mutex before doing the 2nd stage
zs_malloc with
direct reclaim.

proxy execution could only defer the preemption for the compression
and decompression, it wont address the potential long sleep of
zs-malloc. we should not do sleepable zs-malloc
within the mutex.

i will send v2 with more details.

Best Regards
Barry

