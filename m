Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB23FC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 19:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCF56B0088; Sun, 13 Sep 2026 15:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5746B008C; Sun, 13 Sep 2026 15:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9736B0092; Sun, 13 Sep 2026 15:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0857D6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE9BA160A58
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:26:30 +0000 (UTC)
X-FDA: 85209720540.12.48AA8E8
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf31.hostedemail.com (Postfix) with ESMTP id EF40820005
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:26:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OHjTVdFh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789327589;
	b=OrnArQU6qx6NTyQcetoDWelJA2eLDx0OsKbP0xBvpOWO5bY2Kt9YjaH2EQkW1y7coVe6xu
	IeSyz3Gqne1UiDANMmVkyFrM49uBN78TIIGNc6hriT5dzqG3jGX3FsqxSQwc5qeW6JQs1P
	InQ8Dvs5K38nDSqRkp6UCbDaZxt7AOw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OHjTVdFh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789327589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3bm4p3XYFyhf+gjUNcp2hdrx1XIlgahhu2l/35xw9w=;
	b=b1Ne/fyzQceVLlmVm770oWViewtyB6raFU57IRKJA8a2OPiwSrFrCmSitPjMFTAuGvlKog
	NEz4ery+1naI+lIzOJrR/upTv6Y+FEtBEkON4r4sDgKTAmYlAqXBHcOKv/gBXqmMWnl5WP
	rPOOuQp8jX6dRu08tMKU10H3SQupF8M=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-5306706e89dso169081cf.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789327588; cv=none;
        d=google.com; s=arc-20260327;
        b=Lcm0Unv38SNXF+tPZVk1rtjLrLX2aSCNaRlftmFeYdd2Gl5QeiAiysHp+2Jpsidy7e
         NsS50pkXapW0rzK1hjEAQeG8GRZ2F5LXekmLzSsd9oVK2nijnUugXjWge/gDPQSyuNWG
         J94+O9opd5MnAtwwCrhKBoe9qpBcWgtisnoz3FI176dL7yex4Nxy/u6een2TRIS/G6Y8
         lBeAeiTKZc2PzvAZ1zfKZ3Q+66StYjJxGH9Pibed0ZO2J4ofqL7TeR2JPoZ+IqlFZFeu
         LHpH7ipi7TM6fPqbnB3QqdlHWoQCEO2WPuOB+5PBuoSNSOJk/kvkuAg6tWQxa2xggysh
         opcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O3bm4p3XYFyhf+gjUNcp2hdrx1XIlgahhu2l/35xw9w=;
        fh=9bfa1gfJsrPOI4jqXRYNR3UgUe+2RTDtVQwv401qBlo=;
        b=ghBD8tnpXhshlq/wXBcxRazQugXwi3jraeo28qebhUnrsdTZzAq+lLAd9cL8WYkrFj
         +p0iKJZPF8Xe35z3riAILMTCdSV09X6JvapVtbKzau21HAkkvOa3WyWPKDss34GKYkYP
         zPK+K3V2GjHEnvhNi1sZZDMm7PNKvK6COMV5mz6Mlq0PzHEDP/H12RrsaZCSbqcGixNB
         SAbbtIZ6oS8ASOXBDEfdGx6Xj/OfsDTPcNpHZdVPmnkEPAzsZTaOd0U7IjjosTyxY9Aj
         jR/QBVh5ovEhPHW1FD+Nk4PBoRo4+gC5Ou5hZ1WRiWMlSw4XEeZtd4R3ZiCrX+Dg38nG
         6i6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789327588; x=1789932388; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O3bm4p3XYFyhf+gjUNcp2hdrx1XIlgahhu2l/35xw9w=;
        b=OHjTVdFhIo5IGOB1cSNnwlh3arBJZR4bTZ9iZUuREYw/v1Ly6zk0x+1KSsciDwzwlL
         cDdzmnpCcXw71hAwAbk7M2gaKBTTIHoAxIlf8vfg88RnkWzPO6qY3J9hcfLiP4JlFuiX
         cjgWKOH+Fplali/hUwyPUK991k+o/btiO2C6KN1Zf/Ok56BN16wgCGIDJN1nX8bGQhA+
         kixZPOsVw9UmlPW8wlRcyS5rdvyW9sGUB21XKqQOaAuFwJ3R/BAnJhzwYcH5ZXHYDbTo
         Aa7tqaq60+IAKr6KUc2yVMKcCdiEjN98hTOP//M53n5bFlggGVkhD6Vr4k9P5oD1rcpN
         J5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327588; x=1789932388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O3bm4p3XYFyhf+gjUNcp2hdrx1XIlgahhu2l/35xw9w=;
        b=oNqUk43RjwRwLQnzSFrFIfyMs9LljDvCI3R8OJm7LC8eTwn16VcFQdCbdOLkfqkvIb
         LScF7xXWLufpYzEVjSX3ZEMDbMX7uHtWSAiAi+CO48j2v+mTnPja1NopeM/9wetJBm14
         Xt8d2Nznd+ItECsbwcrBMpPGQgW1dVJzd2GhHxduJMeVHEo9XN1WcyYUxZWZW+KNIRzV
         9IniJ93BQSRBldyFZaUVc7uTMEZTS1qcZ4mIzra0J6YfeONtTcfmrTvGxvAJVRYlxr9P
         7/RREte6HEe/QzHz204Hvq/0jpXH0WuKUEQJ3MzL3PIEKkbaE93ViDpshbGDO/elXr8n
         jl9g==
X-Forwarded-Encrypted: i=1; AKwUvBz7aXUZomB0ltry4DOResLjxVk3Qnkdj+Ys7zgiUDDAoHdfAKXE/wMud76EzrvsNIIQFHGheX3+AA==@kvack.org
X-Gm-Message-State: AFuF++muVsGenofM84EBuHmlUCic4YVnTXdtyOpuiyr3kPs8YVbuzyw1
	j4+oJzHTeqoiLrtr4Orl3m+XssPQrjI0fTvlFhAMa5obd1nWU+XaBGXDsaFdWczCkN4w30lLuzj
	pqrmbPfVouNiD6IsEg85pNT8B4/mFxA1ZsPVKqQ8y
X-Gm-Gg: AYBFou1zjn9sW0Us9suISuKqyIaEOIRcihSc2nHHrsQrPwsy08hdP81IooecoVV4QbX
	Gc17C3KhoGDU4g/ElELgXuiTSd4Wux9DxsFTatkrY6gR+YjGisjU/Kh4Kepg1+TcwTnD4KjzTPj
	x8TuvuAJaWtOGELanLfwTfBIUvJf3YDbSK4yR+wPgJHx+GGkVbGjmUUboz74SdzIdzcbcSI9QoS
	HDmX3rCUbSwyE7kcdY/uIpO6A9dls9fUvINJUcZVtP87q9wOudhecUlGx8pE6eI5Pk/g6EZmMtp
	on8evkfdEaMg17tTbpw/gLcPFa3hkNn7I0xMchxsiRK5V6CtGFgb6LyKCDEAION9
X-Received: by 2002:ac8:7fc7:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-530f8b121dbmr9139921cf.10.1789327587349; Sun, 13 Sep 2026
 12:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com> <20260912002436.0605a85b912eb8ae406cecf0@linux-foundation.org>
In-Reply-To: <20260912002436.0605a85b912eb8ae406cecf0@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 13 Sep 2026 12:26:16 -0700
X-Gm-Features: AcwNN1VI8o7qgtAf7FpFyYAf_QiJM539hgJGQoLRqGdhk0b6X3b8GUp7lNPBUcA
Message-ID: <CAJuCfpHW24Vh2RSr7qwzV0jmWz7oirrG2F4JPCuBnnk0x09NyA@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] read proc/pid/smaps_rollup under per-vma lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF40820005
X-Stat-Signature: mh1itb5dqe797zw6pm4jhmcet1yh1i7c
X-Rspam-User: 
X-HE-Tag: 1789327588-109451
X-HE-Meta: U2FsdGVkX190AolRevkTiIkjwKspjawxYLrn0eBVagqAIEawTT5eklp06HvtVhEu4tzqOiUtlAoj6Y893qRhWCEiBuGSIrdIg1ST7hzcldumtzKjWJgiPCTNlMsT/JejfTNZIthkW/NZcjoEeIy6xUiS1iy6rn1nrBSReKqb2mBL6lQIY45pJJS4KrpQ/cWdvtp4yEK29aoByZSwpOgRy9kuBEmreXVBaEKvJMPnSUMvp6dfvZwSDe/853HqXonTrCKW1FOSBOXhIE7rGBwrozrQeQ99kPqDg5RsLlTTRWWJYYU2rsfpLkdrn0jWKmWe5I6kbB1EeFJZVkBqyhhEd/8ywy9EM8+FxSOvr1+Q5yYT2RBNmhQggZm3a3qKT7lDn+pnu1EnEE6boQ22+gBMWtD2vgS67A8c5hseX3DKgMoTr/fyFHXhOiC0l0Ig/+sDFFnamHHZe4Hs6h/6pIq+6J2vEiPtoMOXLvwhDdsLMTKOiCnjCbLa6KRAuAnuUFEgPx/SYzhG4XXqjSFspXwiz3w/r1gks0BBvCOX3qIV9IWLsFOzRTqhfg62y6rPgvRuDbxb9g1dEA+R4Qy9ZkceyH4mm2QL+21Y2/5m7ovNp5NjAovYm2hp5opfk+sKKjdkrU1CBzbpvaoXrgZojokuC0myFEFP6GJ/BHZrCeW4e+rM5OLBO3N3AUbOwRtPujm20pFT1g4hosUyoE76BnkHQZEvQw2EOnHHDdiBq9f9L4hp9RDD7tZVQXA894pzTOJpWAZWp/hOeOvJi0z+x67/YLkkgBKn8FKnWDa7KMz+JPk8XKbV2lLFdgBcJq45xVWbKNHAYRcc9E58JNNRZGqD9+sBAUjoklzlcYMQfNT3cwttRnPd9uHI+LrrPfVbxxoqpzmBvzCPTJHQ11sMAdKG3GStvrH/ElvNnU6SJAZs1VLA97qZEuBQQKVq9GZxBPscJZyiTdWD3HbGyoBOL1p
 eKcvMdYt
 0l30riTgnQo/bRxfVjVIHFb8LujXepk295JIBRxEExWA5JacXcrMm5zqcY3M5q9FVvQEGLdPSEiZOiU/+VXO81i2VL+ShjnBcyjjYN5B0kOXjQCwWHBdX2AGf5yf9ZM/sXn5seI5N3xFLSAYFJiD6xy3u++75n66WkJv41FuFEfkygYSrbPBX0hvH/91uH1lc+4GGW2YSRrV7hABWxhrylsh/8S2Bmyo9x5RFUuEWCq81fmEHy4Epf2SoMnd6Y4UkwOojcBKNxUbPNcE4DlNzetJ+VTfnPG/WfUehlIJgamdEoZqJ4C46GZI3rBiV+fg2saiNJSBbqCWkw5OecGf686VP5Ii3Kfsx5hxJBWqvxwrYRwazbXA9ev3rcYQJtsxx/4PZ+FXwQQwhRfQoXqXYIgGXELE6GblHWeJ9D7U2DpMtKA+n8boH819kWPmPf/DSQLlyERDGKM6ydRsHk9l54mBHsAmWrhPudFR+JMmvHo76xI38LWKvjwYQyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 12:24=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 11 Sep 2026 12:41:38 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > proc/pid/smaps_rollup can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > required to safely traverse the VMA tree and VMA lock stabilizes the
> > VMA being processed and the pagetable walk.
> > Note that we have to keep the logic to drop mmap_lock on contention
> > because even when using per-VMA locks we might have to fall back to
> > holding the mmap_lock.
>
> Nice.  Queued, thanks.
>
> The speedups described in [6/7] are significant, although I don't know
> how representative Paul's tests are.  Probably not very.
>
> So I don't know how much improvement our users will be seeing from
> these changes?
>
> And I don't know how much usage smaps_rollup gets in the real world?
>
>
> As I've no doubt you know, Sashiko is saying things.  About these
> patches and about the current code.  Its pre-existing
> clear_soft_dirty_pmd() driveby find looks significant.
>
>         https://sashiko.dev/#/patchset/20260911194145.1781926-1-surenb@go=
ogle.com

Thanks! I'll investigate the preexisting ones and will try to fix the
ones that look real.

