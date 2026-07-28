Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8D9C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8676B009F; Tue, 28 Jul 2026 11:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059096B00A0; Tue, 28 Jul 2026 11:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89CC6B00A1; Tue, 28 Jul 2026 11:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDC096B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:48:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B882140402
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:48:35 +0000 (UTC)
X-FDA: 85038617790.25.968607A
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 616DF180014
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:48:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekikHVAG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785253713;
	b=pxIthF9s4ixRX+3qujp9tCq9AdYqpcURbKACa2B3xOihPGo6X/hu+9SabEG0FWdIuDfVdJ
	kDxn5K5qTVxBrw6jLeaVt9RNHXDj6EelaPQk7Tk4TnCWNzkRp4FZGQ816nWya07GAN0wbj
	sxUMI3XxYTBXARLAMbpC0pHbKejrs7Q=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekikHVAG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785253713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ekmMqEiqA8LTebT7W3nKgWOoJTnvec9dUtjjF95pMs=;
	b=Wmvu43TQfC9Nb9roJzMaTnqGslATc0fggTA3ZkBFilMTPkSvamDwrZothqacGY16kGQRj6
	q5vEsLGeZm5UtSNuf7GgEs79cnz4mOdZTyCa1sZ3mjBO/8MO5vtsD/xQeyMZFJccdoFrX7
	ubnIt+Ya+qWu/DJOlXJ/UKMd2GVF9xE=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47de0093c42so15230f8f.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785253712; cv=none;
        d=google.com; s=arc-20260327;
        b=mVFvMVesp9h+4K6kQH4xoFkIl1h3bHXf2XcyYLgEiblGTjeniuN7Mf7z6CSI+3mqS6
         O2g+1YcIVoYKQ1ZiH0zoGy9vq9M8PFsDnWkMEWX3xYzMH1nOWxPcYCfAqi80AIwxhm/M
         HnrMwrdlZQga/Q3tOeqGAlFYnfJkqGzSNR02dGHwCIxKXedjDqrP+OXfVg8X6noPZ5Ya
         pQcOcJIM9/hE3bUwzBTd194izEgW/WvysmmUk/vFO6dV7onSvdfXG/ri/QrBK9Qrz67P
         G0gyA1XMzkIvqqkaebQx+iq9Jlz6EroPM7pfYUsw422ysxvvES3Lt/0Il2LiwlGph4Us
         PMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6ekmMqEiqA8LTebT7W3nKgWOoJTnvec9dUtjjF95pMs=;
        fh=xqX1ct8N4wAPB9qVPNGt4XABlZXmTSGwq48pznVvSNg=;
        b=Itxj2Mgl9YcJiHKV+1IAWmWVSKPQLM5zij8G2n+ZB7lBpdOGk3plXXdGUIZaL1PFd1
         MAk4ZClnIY/Iqe/jVg1EZe4lyZlzXgTnPr7kHbN5KmpRJv+KTebf4g4M3F7WMYC/DIvR
         CZ+tYq4u/NUobHa0EiTvJtTo8MOc95Z/zcSIPYWaTb2O4fto9b4wcFgRkAhDz6acZEl2
         C4G3dFxlDwwW4qNkerHPI5vTpMt8ktBzviXbp8qomx+zCIOsCvStcGBmHPnG8FBgyFJP
         TMy8qkFPz0LW1MZW0BNrNTL5X5J29dLGH/1CfQqGNXK9wg39LqPMyxu5bW17kyni8wdb
         Pj9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785253712; x=1785858512; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6ekmMqEiqA8LTebT7W3nKgWOoJTnvec9dUtjjF95pMs=;
        b=ekikHVAGqyoNGvrJ6M6fPZLLv5BymWvQNneT+9m6yDl89SWE2N8isDlst9ZwFT3DX3
         5nlCyV9gULj8rN7+P1hTVZbhNt8YOP7lyORI7MkwBMJDpVQZRYHaSdZGRUxsBjXGCpHL
         NLnm0G5MX0VqimdXz45TReXogMPCYgd+ZuLXKsSHvfvG9u9YHGc1W+mp/hb/iNYySoPD
         tU3vjZcGRL4HCx02TE5x6z558+LYvVUBjaJB7Cars+UzFCwB6mMGqOagoJuVC622tZbJ
         R7Jixs7bWtikiWxnvV1gkyLVA8oXS0Fak/DCvdR6DT5f3DLz6kmmu+Z/nhwXqxaVXi2F
         b3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785253712; x=1785858512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ekmMqEiqA8LTebT7W3nKgWOoJTnvec9dUtjjF95pMs=;
        b=BTbvesq2mN1+unaMYTvlwVa3WbG5SFeauidRF8cZr8J2ZSvrB5I9ncGEWZ2s5bcstg
         wHu0nwhJvfLmH/JiZBcJhmtUfMnyh9iU9c7mtH+SmzvWvd7oX2KIzM9pRpzgaJnJ43mE
         srqc4f2kJ83Ho9dP/dI5zBvIbb0nCCMDudR+li9ffMkl3euDLzUbzGC1YgDoEcv8ccgU
         UFkj0JqMK+O0DMFdDcBFHVV5+kdbyGJy71jh0OuDNQm7sfhI1zy2hv/OjILIJx5rRVRZ
         /XhC3FbUtWLC9EQaA0vo7mm0K30+/X93XRntOPPz8Zo4X+6uz1TTuqDoyC0yBk80TVXH
         ilAQ==
X-Forwarded-Encrypted: i=1; AHgh+RoOLX+xTPL+aOPzF7V7+x/SiBVvAkfWrMxL6vcNXCv9nOPoXIGx5mjjaQAUU7e5IYUvLl5lMlhuoA==@kvack.org
X-Gm-Message-State: AOJu0Yy9nGzJJREj/xAE4j8qsqx/Qd+X4CaJ3HzmhwmSEax+78IuewfW
	atcE+7EyqD3FHTCgh6lxfFzetNW3X5fLxdcLaK3Q/VLMSF+vzdx8B01vueny5th5WOjOrnQgs2E
	MTAs8Lr+Uc5UO7jHJH+D/lT6WkkEQPb8=
X-Gm-Gg: AR+sD13fGHoF5vyVWzIxgdFZVw/o1b5UWl/T4R9x5tHKHbEa/C7+EHpN9BdC9GkGLwd
	6K9HgL4vbw3RuCPOduR6rsaPLepnY+3T9I+x+6Eittq1dQNv2ACTTV7c0dbcsXuJB0ysvy/OoB+
	EapNAmAZfP2pNSZT0znSFWpLu+FgbQf8T1E/zyiVo43+sBtzrQPHNbpl+jRuUhsXPwHjvvQyuQJ
	CV2Io5j0+gKbZVCTGsHTuK3BqpOsACyk9SG2WhlFo7lqPw5SBEr3ReKQdTax0n+6V/BIHBI9Eie
	qcsPUmTN7r/qZR6xyw==
X-Received: by 2002:a05:6000:1889:b0:475:f0d1:eb56 with SMTP id
 ffacd0b85a97d-47fb1eabd10mr3664714f8f.49.1785253711713; Tue, 28 Jul 2026
 08:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com> <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
In-Reply-To: <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Jul 2026 08:48:20 -0700
X-Gm-Features: AUfX_mzh2_blL1kmUmwix39O8J8fZHoXTWgO9ySYA2Bkw_Iy6nOxbofDDKfyqbU
Message-ID: <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 616DF180014
X-Stat-Signature: x5fs39az3qsqd6wbbmzu6tyukd1dw6qt
X-Rspam-User: 
X-HE-Tag: 1785253713-654740
X-HE-Meta: U2FsdGVkX1893vpJFR1MxhQvandNcak0O3f9NmB/uxgVa+KZ0ItUbVM+L41jypbf2TaqYmvLibrG8C+rWfIWrpl9ZdHIPmXvxdDDjfcfEFqjLO0L+fMqT3MPEIX/XZJ+xN/cN+bz7UVzQnJbH5/CSkhsIQ7YNkM6FTnZ/jOrzAYRnTOmhl4xnm0rB/aUAeDfxSD65kgPkslVnlEKegeyvSDf/BCIZzMtNJWAqTICBJrxpg8HtOT5ZTeQClcVQVr47WNClExOdMXZ/sR8kJyV2mizbYr6wIHPBXa6vyA4ZPfRWib+Y3UOxgM7zkPChmQnmHhxLAlkFjHn/4l/v2xAAOFdYBZ8EaTlyduJfErl09QwPyNv+cwVz7Lo0DS+aUHjg/wdXmfZo8buNFtD+jSex6cnQ8TUQ3EE+6xWw23loxd9BKaMwyXre5wYviqt/uBf1Yys7VNll5KCAXkiNkisR4uTivKv2u67xTV3Lx2PyB20/ypciyqPi8EUegIq1b0Qst27IWsQ4E0z501jPMdmjvxMPhhUUgmAqu2kJHIjh78TOfDCBboSxSX6pe/ul7Va7oOnDyb3Xbec03rR2cXY02U3rRM60XjXFrHT92IJ12/23ZGuNIhCIM0tLPEJBpG7an6kV+43G425U4azWp92AN+k63Bq+2/qaHuBjZB83FaIdPHQdNxhAJlJ7hsmUf2OhbP//cEFzLyrAc69gmABlTUwmNyGCAos2SAR4alalhPoilEsrLtCoc4XJI1QNftJc8r7xCFO2HBq3unWN8I6sf9xWNl2yqaMy09j0sRMrurNPVCPqCAqUczUMPJb+WWU4Uz5CYPnurURF07dI7vQkAvVYIuEqGm2GBnc/kq9UhMuwEO59/ienRJUm+GLTjkwfANu03jQMx3lSE5yXjAl3h4Uo3rbGzgP3QSrAQEfqs2AyZ3S31Ip8dOvJ0a+84+X5STcXeEcRdjeyK4RXBp
 oOcTmXVo
 o7hsMlt/10ebfYcdJbsKFatg8LsSsh2ixs/aILt0Lu8q0uajZ+tBvUIUjdivxUUv6qgAp7jQuO80VUtavFAfmdXBMUOS+/e9qpsiFtIT+rb7KMHCA2Y6ijEyhwjzJwvUW45QjGd9YmK1J17iKKz0KSiwVG4sD354tQMS+5fE7CmdmFttRffmSLmm/H1j3p4APMJSydP65YB+zq9yolF6SgCj7LdOzyMghB2C4TLWZQ8Hfwv1SBZ+d86oWPCp+UjQHpwhHbNwPAxoLWhuUe7nC4ZxCnepAo+EgI7/hpioA4LQYYNesrv+vJ8BKV96p9vBm21AfrMIady/af7B6fqZQ52pc93lhFx0jwGr3C/hpK1YWBmh+p1aZq5WmFzRIfs1gUdvB7rphyC9kINna/VWHhUCR45mjdx3/2uPCSOuWjsbJHK9P38rMg+Ze/nNIlFvzo4OZ8psKbBBNR1phHvyWCql3tylz1D5napD1fBqvQOW9u+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 5:58=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.com=
> wrote:
>
> Hi Yosry,
>
> On Mon, Jul 27, 2026 at 7:05=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > >
> > On Mon, Jul 27, 2026 at 7:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr>=
 wrote:
> > >
> > > zswap writeback decompresses an entry into a fresh swap cache folio a=
nd
> > > writes it back. The folio is cold by construction, yet it is left on =
the
> > > LRU for reclaim to find and free later, wasting a reclaim scan and ke=
eping
> > > cold memory resident longer than necessary.
> > >
> > > Allocate the folio off the LRU and drop it as soon as writeback compl=
etes:
> > > mark it PG_dropbehind so the swap dropbehind path frees it once write=
back
> > > ends. Synchronous-IO devices complete writeback in this context, so t=
here
> > > the folio is dropped inline instead.
> >
> > Why does this need to be handled in zswap? Doesn't writeback from sync
> > devices still call folio_end_writeaback() and do the dropbehind
> > handling?
>
> That's an optimization rather than a real need: since we know we are
> in a sleepable context, we can safely drop the folio from the swap
> cache here. And since we don't mark the sync folios as dropbehind,
> they never enter the list handled by the dropbehind workqueue.

It's a bit artificial, but you can try testing zswap writeback to
zram? :) Likely you'll see some small tput win there?

(TBH I have not seen sync IO swap backends other than zram though so
idk what's more realistic. We don't have pmem device available for
testing etc.)

