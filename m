Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9F1C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB1A6B0093; Wed, 19 Aug 2026 12:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BE06B0098; Wed, 19 Aug 2026 12:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A2D6B009B; Wed, 19 Aug 2026 12:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC966B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:46:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85B99A3201
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:46:33 +0000 (UTC)
X-FDA: 85118597466.09.428A027
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 944D7140009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:46:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVwl9UL0;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787157991;
	b=GK5TOAPO5KfhfYWLDh6osPEvAxsdip8vkNsPnbEdGDnnqwxuo+XpGHEzz7NX8a+YXwGMP5
	4q8bfzcmYHAdCAvKtepaz5rVtAYLHNl+PI44GuoNc93S0/rrsSplvLeomOTeqy+YPRfD9f
	Uvbl1O0PI/vsFk71gTVPrGwef5Kwuok=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVwl9UL0;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787157991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
	b=sY3qHXhlcylvZ74ZhRR4w8R/C/v0c6b0fffnj/dkhrSO2nBhkZREhbMBpIX8QEZFOfTDLm
	yTXOni9GsHBpuFkk2AVIohz34UyHJwFUJzgOUbBy+hdOIAgLIfUJkz4s7feXxy1ArPA4/l
	gD49Te7zO5VZEGoL5CeicwKRGPsqrFM=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47de0093c42so1144249f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787157990; cv=none;
        d=google.com; s=arc-20260327;
        b=AsGnteVSQjJ2dPKMc5Oz6D4pI5VSl9b2JE3KB/rMWny5F3u8ElDMW+UY0rvkDgAekr
         yQQur4KU5hx+FKIaKJ7PgbxfXwy+8+6xLsDIfM9juUzlO7m5JD4r0WsTk+PQcwY/ETnr
         HEB5skdj5VTgi1kGdFnhZr1ebP6nvL2iQNFv2UhrNQZ6sl6dD9aHlFXjcMUQY5L0Byjo
         +czAtehJHUhWYaPS08A5V2Y+C0FurDLqwJ194/s3VUf/28YG3ifOUiaJjhAwGD+g72hz
         ssMXiiWNZrZs5Sm/dgMGANiGtdNUrOXwNFPf5LQH5H2nTL9uboJTmBPD5eqNZPEOHVkj
         X0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        fh=o7D0MlVgI91L2h8lnUl+B1zULuQssKQoICSwlmECtOQ=;
        b=omWaDwCJVsDTj+C9ejcf2PgeQcevjvm7opBLYrgOj1nnh24E6G+R0AxfPxo4qOF8Vv
         4MPLp+OHmAw9qsvBDSUpHEOQ1SavXqihatAvHba0PoRv37aqKV9eXwgoQuDdGhTkNOxD
         FZsSdw16AvmHS9YWCbz4LgdAY3xufEP+FjgBbGfw3rqOeMPLYMDyWbjXkovYqRQLYmih
         seLA8TgIbiRgZzSdyh+5GYpCqwDzi6oBDsW2SLmGdJvOa5z6B+eWUw013MaqlLu56E2R
         WXYtmYtRhZBdAWn9SkvApamLB+OchOY+nxOQxJz/TxIVylo8nEllQhXFayt3v7ms8i/v
         jL8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787157990; x=1787762790; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        b=IVwl9UL0SXrKMejT3UzIGEKDbQLZzvbmtCsstTQS6MLakDOzq8yhtxToPBA8fXc4Ds
         khoiMn3k/yAM410PyIs/1tPqbyewviAAxukmQf6noI/BXe6v0U1tjB7x909lpbOE2iab
         ANOaeh3uuTPQ9KyhpN3VE8o5kZbB70/8XRzbKyj60YU8q3YQDLNzF82cJhdh7DOF0b49
         AyHbFmkoWQUXyCdCPp7Dvuav0LyT/5TTZq/62n9BBdKJaO+RjQ/B/UEKQld459H80i4h
         hWC3NwoAOwM0DCb5Su/LKbz7o91BS74QOU6Oj3GQ9jc793nGAcWaBt1rsTTmOupwVmZE
         URsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787157990; x=1787762790;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KGaMY+nZBc9mwPhVBSJIQVYoXkNeMf257X9LmQBSnFU=;
        b=ItUUGzg5F7A4QgtQX40Dj6+KXy2GjNvH+m2lDHdo7JymfY/kyCwhYZYyk+yS/3Bsx6
         lds5ti27EgE5WZAWXTCcNM6QAjPyNKsAEUOwnullkndwOP1JGmUpOWE9wBwzIG50FJcU
         G9ZdBLQhX0U3aQts/h4DWeY0pye79uzAHmQD7CWOBC6Q5TBo4V3G79nIo6zxJEU9cwYS
         MKGnGrguE8NHYsP3vQHtcLSq5VLJHFZVy9oEuNwZj459UkQVStvsWtSlooZsupCtZ47s
         aO56ZfI0F0vy6LtBRyef9YkcyrzzkmtrBsAb8skOL3InWTYrLP3+Di5qQKMn6Z2cO6Bj
         n1Cw==
X-Forwarded-Encrypted: i=1; AHgh+RpFOmy7mJ3CDEJ2dril1EEKsPb8VSBKD9gydINDnNlpIt6njf63E7lMJZNT9TxxUSfaMLoNqVZ44Q==@kvack.org
X-Gm-Message-State: AFuF++k8vb9J2j90y1c5IfCEzIANahm29GeMxFXNdzaAXMaG+7E5ETA8
	Z+j74yQrA3gQsDpNXvq5ZrFDRJDUip2MkZkzK8umbA0MkK2XgXwOgRZ//biwjJiCn+jUQfqkrMZ
	eERGUgYlL0mzAbrolIFN7xYG0cpBu0Zw=
X-Gm-Gg: AR+sD10SBfgBzBZpnRiToZZxZL4ICjoPed3G4zUINSfajILkbP9YJDpQyGfgl4faTx/
	W60Ng2mzxG/7/W1ObcWlMAAj5JE3o+tWD4FcxHwxdRdxnZnspSNyNmERpcaLpEYi2rEDgdL+DT0
	mwD9nu772StTxV61VlzhqdHfDsmnBbrOgUF+1ONsRQ9K1/zM6JprzqjDyM5wwYgNqIu4wr1ifze
	trUUEJNnlDRQ9maoIsxVkNVCS9VZxUIlN3UZGFILEy5gQBA0wVTDjwv+0vinZSlPTpWhY3ohDn2
	KGpfU/R5/zgMAZfTyUbJvMu1tRSpN1D8iPTf4MwvDEufRrKZlG1OyHEkSOjGpQKBcjJa0LmJ6Of
	U
X-Received: by 2002:a05:6000:25f3:b0:47f:8ac0:ccb4 with SMTP id
 ffacd0b85a97d-482b1e9df5fmr12803729f8f.10.1787157989811; Wed, 19 Aug 2026
 09:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-2-nphamcs@gmail.com>
 <anX-ga41DMNWF6-2@cmpxchg.org> <CAKEwX=MmqyWdqfrp8kxeuucNFhU2e6Hk2TdANUGhNFHhvtSPwg@mail.gmail.com>
In-Reply-To: <CAKEwX=MmqyWdqfrp8kxeuucNFhU2e6Hk2TdANUGhNFHhvtSPwg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 19 Aug 2026 09:46:17 -0700
X-Gm-Features: AcwNN1VW1IFOK11rd1UcYSUArFyDXGImTjTFPjh0sY0B1rB0YRzMpSnPt4Jbiig
Message-ID: <CAKEwX=PjvsAOv8rvp+mz_aPqDLm6iRy6URRW2EMFvFrgD2HEgA@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 944D7140009
X-Stat-Signature: cyf868be1hst58d99u6kbxk69e4ohnd9
X-HE-Tag: 1787157991-896256
X-HE-Meta: U2FsdGVkX19cXO5W7wG+MCXhumW5Eu10HA5eJkkKmw5NgHqtFfcXbkmBzEyBH3oaVqEzRAb7KR2GPlwLLxu8sxjrSDh7NLyls4aJOBwMNptbMRDGFBLz7xHbqOEGEK5GQcRnoemDrua2T1sNdov6cFGFFMc06nThMAL1qU8EJIq8BAvAUa9gCRUHMc0L4xqZxNWKLRrZy48sWYMpGC9xEUCIbeaqCpCKCR3lZf74jcGF7Mauq2Hd12zf52tefjv7jYgwr/Xx2pACjaSmvxzJyvgdTJDsjxkEa+jB23nJUg46MeEZimM0LwwI3I6n+lhO+lSLMnmf3wzL3pdkM14FKxhtA+uIbsFULq5D4p1VfcsKulO1g03wVES3ltyOmjMiQIG8e0ZD3xcz4L8BVfsuJpAT1HEUd/bSCM3cDkip14lhyOXzXcjou0308REtAsjc8BF43z9R334Oep1wsMNsghPIx/yTV5Z98zAv/uvVd/e2tcKmR2sBDIOk9swZaFuTtRsFV7/hcTKiTtFR/q0gfz2tuCoQuK33txJ9SBmKh96CnYzAePifaovQjA6psGP8i9gyTOtvlI09ETk05cbIR2H3QVAACnQ9RaQyqFmiW+OMcjcp46ldJKHBXLjB7iVha+VM7lAwf84geHWmjGpOckL9+6svkr25Yfu3tAlgK0+hM/wk2uNWN44lccZKBbty7c+oIovzwnCyuW9HPWjeaB5sB+CHwiqBLSzo/3KHvXJovb0TCBXXhCDfz/sEAeES4rgqYLgQ6kpWF22HQHxtDE8Yo9az20ID60Nl6yHQqW7Fg839E9gYHMVc6epVIDqEBowfKcp5Y2q8783DYYQKSOTNJkJXP/1gSOgWQTue0lu4TIlCz0h8b9vQz9zZpeeW6z+BFRD3te5SSoP0z23aYlLnOU4rNo6wZD6rKt3+sxy4Z/CGFlljigTKb+f2c+B5hM1VwW+IbCM1cj/J9fz
 qvrsZQ7J
 QU/acuxQyJx0FT62Ra/LKLxodpxQJUAi/47fwY0XntGpx6tPH7tj7AqSj9zOzFAtLTpLXB14CEBsGbxUdErhIOCHbxSg+sUVG+h2WpNUbOim9UwV9B6huHpkgr86Hf9gaOcYxEC+RhY5REwq4st5+a7AIeP8gBCnUw589lCYcyOQTAx9KXfQrJvZuoqH0zIqVflEuVsoG/2Gldj22IsaNjR/0ykaseUrKAD+TftNGW2WfB8peOkGsPbrgdvt7SPhZHC9ZxKoD03zXtzHW1VJWCLUOZZnfyMesw13HjGL08OFlue95C9dZdeH2Q2ibl5GUpLY4ez9oISwe2oew+AAp5iuGDq3ObnTKr61VcKwdpyE1IoNK2JQiYQNbpaj5YhRFu0PFSx9OjJRTdlbNloTeRH2qn/ue+e1jvTZvSqjx1Ybhv/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> >
> > Can you make this a pure allocation function - vswap_alloc_cluster()
> > or something - that links it to &si->free_clusters, then jump back and
> > use the existing alloc_swap_scan_list() sites?
>
> That name was vestigial from Kairui's RFC, but yeah I agree
> vswap_alloc_cluster sounds better.
>
> Regarding the linkage of the newly allocated cluster to the free list
> - I'm a bit hesitant to introduce new surface for these clusters,
> mostly because I'm afraid I might mess up the handling of these
> clusters (when I unlink them from the free list), but I can give it a
> shot.
>
> >
> > There is a new_cluster: label upstream you could use for the retry.

Actually, I stared at it a bit more. I don't think we should jump to
new_cluster here - it's not what physical swap allocator does in the
first place (we never do any backward jump to retry).

So basically, this is the old code:

new_cluster:
if (discard)
    alloc_swap_scan_list(free list);  /* not taken by vswap */

if (alloc_swap_scan_list(nonfull)) return;

/*
 * Added by me. vswap (almost) always succeeds here
 */
if (alloc_swap_scan_dynamic()) return;

/*
 * not taken by vswap, because we succeeds above
 * and free list is always empty.
 */
if (not discard)
    alloc_swap_scan_list(free list);

/* if free list scan fail, keep going */

etc. etc.

The new code becomes:

new_cluster:
if (discard)
    alloc_swap_scan_list(free list) /* still not taken by vswap */

if (alloc_swap_scan_list(nonfull)) return;

/* vswap puts new cluster into free list, then falls through */
if (si is vswap)
    vswap_cluster_alloc();

/* vswap now scans free list to get the cluster it just allocated */
if (not discard)
    alloc_swap_scan_list(free list)

/* if free list scan fail, keep going */

This works, but I'm not sure if putting the new cluster on free list
buy us much other than more lock contention points (we need si->lock
to scan free list) :/

I'll just rename alloc_swap_scan_dynamic to vswap_cluster_alloc(), for now?

