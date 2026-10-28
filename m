Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62556606A334
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O9n3Tg8G
Received: by kanga.kvack.org (Postfix)
	id 6FE9F6B05B6; Wed, 28 Oct 2026 11:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF306B05B7; Wed, 28 Oct 2026 11:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577576B05B8; Wed, 28 Oct 2026 11:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6066B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:40:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D2781A0167
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:40:09 +0000 (UTC)
X-FDA: 85372446138.19.A8C3789
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E3C116000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:40:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O9n3Tg8G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
	b=cBujkbPY5rDqcoov2gLXdrvjccqgKEzho/rdWfZX9eYKSvnth4OusTwvoyOKtbmD9C5FRL
	fkjzRwpxdkvQWggjfmYgYS6I/fjoKpos0KMdjThyA4QE9X7Zh+EpugnphgOySDrYYYAuYz
	L06i630MqD7sBjtoaGe7M3HOuB/qZlA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O9n3Tg8G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793202007;
	b=MaWWm+vjXk0gXIgVsj5AHrpMLUzxhjEOoSTuGQzjgkh/jpizetUxeqY/932YAUCyrakcP6
	Bt1J6XhTaQsF5z1UbW0e7880cvLF/T+G1D9tZpgKogr8JPkg+i/lW5aXvPJpAnKx99G0Kr
	69qdvsyyKrxSja61wb+c7YccfK+mb6A=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so1549533a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793202006; cv=none;
        d=google.com; s=arc-20260327;
        b=G6Qp5FQSyQEu63BPGcVdA+hEl0gzWxZm86dTrZMIZ0Rh6vyXh+y0qm3zTeztgpprFG
         28sQV+iozIAOh7mDjB++TOkcF1KOt8rcoom+6Y1MiyjdL8tzpkX257NY+en8YQKWHA+v
         U1phnVBE+uBSKLjcDmbn3p9sGIArWYv5gi7A5Jq9QlkWiQg0VnH1gizZ0q2XG6IBbDE/
         iN0RBXirHueV9TvIkwvkrqjx7rsxbA/HO0HCV6dgoG/wC4B/GhBEhsOgZ5uLihd2aPtO
         VhlNkdGc5+B9M+AUIb7kPAXd8DmXGkPf52smNEq/JIcFFTySo6YziUX19bl0U2rnMFPY
         mjVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        fh=06QBCY0eQqDG0hDBs/+cpbfIqfLckUpwvft99s3m074=;
        b=kNuEVTvV5F8khREQTjvz37ZTw7q1EIKYMISsGOivemJxHQgAvHJgD3GCy0ybDnKszH
         mohEei1QMohq0XogRg3aDc4xw1biUMeGG55bFVABcUk6Qde6hlg2tvOrMLP1xF7jCpw3
         R65zRPmEpOWUqQ7tMdwGgeKRmDJt47gSdeF+xrEr4VCseXGM838cSyYoWgky2Lo8JlB7
         06H6m9dBlkGj/y64eCjQEA8JySVALcz836YiP3TH4OlJay/GlZ5SuoFDM3OJvzBNmd6a
         HXTcCmEsvRyUa1ht9qS50/xuonyxrLeFfBwnMIdzS+EZIhpMaL8BC2sQ93t7g3c5PyMV
         F3CQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793202006; x=1793806806; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        b=O9n3Tg8GXuFiLggfsYklQe68C4HUJKsYsm0Oztv65KVY3OL6ek/HQDvAW4KQREvWiQ
         oZ7FOa+tmQuoyDb3EGxPnVeCO/Lyj7zJlNCp0WLBbi3xNwCvcNpZ3B6PL01eiJ9GsGLV
         HDDehcDJooT7u6TjlBVS0gMxC3QcmrAVbI0WAvdTxahSWGALYpd5JvFF+DTZB4H570zM
         JrzcUDaH/CpEU94HnYLR63U2RwvaCI801ZT6Okyb4lTOwpSbk1RKiQLttA1bn7RLLfQG
         gnctEdJB9XtPog0JAdhufmgAVoYia0KrlhMcqVI3FenT9PdS0GKaV+bDNI3U/XMsoVo3
         gnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202006; x=1793806806;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0L3UJe+6XjER+KzlgRD/7xotzxSyGvuQzLO/yjOCn+Q=;
        b=EdLFREWKhIpUQq/7F8tAKnA8VIbFyjvIVLES1tno9w7b5YOnWphHD+arbfy/vY2xk8
         lXyvWLAONEp88m1nkKYZ/JHcRwe/vwbpvB35TIcCMzSjTXAiuHYVdAdMF4TKP/4fF6nL
         Ra0RV6IDqYsQxGvpNuZdM5rAJje8nVEeyEzV6sEfbzFlAPuIQplh8rzeRGTMDvYlNZMI
         oSec4hmFXE9LlbSnGmt5e5o3QkOHawOsysJeMq/2VVFwTCz/ur4CuplzqINFP3h8Ilqh
         BrCFSx0ZoUy7qLBAlNPMpCQzE2FKbVgkugGA01nP3cUQmokuBjirYxFjdOTrkic43nYS
         xYRg==
X-Forwarded-Encrypted: i=1; AKwUvBxLsZ7ED7Fl5A+csgfUxImuX0apTMhsoBg7PHQJ/+wbTjWLB+KXeg9ev92kSgODfThAeLAjDykZiA==@kvack.org
X-Gm-Message-State: AFq9FYJycgXNN1g6eiqgNucdyBoOJHdrfzecCrGXoxg6eBV7HCr7n2LY
	4IG6jqUz5d0hlTvYga3bJQHGswoMnXNR8/2SpuxIQh086fBtzeXBwUIW7V51NSiwKE/yq3FwqQi
	8sgOs0Vbq3ij7p/Yf/Hi7XFiMeVxYzNLvPmfOTxAC
X-Gm-Gg: AYBFou3uJCIJ+MqgRgeZYyyDlQKb8tqi1zj+ldSz41qEfGDAcxHDtQxSCMkCqKhO+QI
	w4kP5DNv6uwc659+dkTOs4q6u9/cFhoFudjGqFFNq4vMxQhS1GWAiyQQECcQrFn5cE+pBA1GYjj
	1Ao0WXrPcWLPQ3Kp1ktrwI5OPSXzOtQ4g1cMhtEEKnAudSdmc1V2Bba9WAKlQIzE6aPTCVbKnwz
	xJrFcRW3hCoHu8SNNwYd3su26IKi8V1C44/SdjsINFZ/yxf8nf3VbvUr5m1wijY77qb74+iZFk8
	1ONsQz/VKKlKgPIIPY3kEqydLYs3TlfWYMSF44eBQAvFSQTc4mqZgx/V1Fc+4jpjGtFCpQKo7dQ
	n0wvUGnMLLo0b5pGneutejjtTI7+PQHI4d7PF0LwmpeJbMJgp8BvS36C4Re6FyT/I3w==
X-Received: by 2002:a17:906:9f86:b0:c41:960c:8c62 with SMTP id
 a640c23a62f3a-c49bdfecbf3mr243566066b.30.1793202005586; Wed, 28 Oct 2026
 08:40:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-11-kevinloughlin@google.com> <20261027052057-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261027052057-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:39:50 -0700
X-Gm-Features: AclHuK_MLzRdQo76ylDi6PC5wwAQyJcXzBectQ_iPw892kOlvxApU7OSZmy7jAE
Message-ID: <CAGdbjmJjBp4WPqkWs0KNLpH2ve+Q+y26yOg1PO4TJHwKfu1uZw@mail.gmail.com>
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E3C116000D
X-Stat-Signature: bpyzrpmafzf7kupnp6wkw3bfjqrbdawi
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202007-881809
X-HE-Meta: U2FsdGVkX19CrWa1vkOJ93GoVRXVF0ANMhYJ9w4CfvJDgFYH4yJzPYVwScE7fzgqSSVN3xMAVcBHNnWJmFIrVLcz40hVeikQX06wd+BtulDkJv0SLdg6UKIIkLEIGhUzEHgXixqX7OOFoREdYKcIcAAf9z0daAw2//j+dBkMpf2YuidGADHwavAfZ7JJiliIcv9SVk+sLBca/T/1FpoV8ZSTX5m/nECBKkQhuzSvBUetm+Smdil/7vOBGwn/VJMp7pFg9L5GMy/cixgOQfeGMzhGRstaOsJz+rWzLuMvrSAsiw1A6o3WKPilDzNL7mZ6cjpd76s3l6ygBWx7CMiphxzPtgUaNPgsE1spApJfQp2UdsKsCgs5jPLrPTitIEhivzeHdvYSWnrIAszgSC3uW8UslYh5Jy7SVxeG40sRWb4ydVppWDZgDCorOxKR6YNCIjKUHUew1YCl6Wc461gTk2C19aXmEwRg2AoTdmGvvtGqWWR0ZW+Fp2NsJcYrzZifhGDma3W4uvEMLnNSsnHcZcBikG54iY8nk7dU6uDY0Pb8bXDPLqRqcVfD9UaH3JHn08su4lGtwIzQsrFE4ZJFEA+gekrNvf7VwkSyZQAptG5DtEDY3DDB1M4ASekU5+2GgYZUQdbAM7alX6+LjmTbrhMKVTfnNaC2wgs456I4YK+34/9GFLVy18rTK7rVadPdT1UiwH2tQjygbOeaTrGbHoo5CaQsQaVdnvCrq9c8P5QCDZFjJ0w4lfjMANU70rphgTAsLz93+kGPT6GrfrH78jJQxQ32xqELQm0bD/6L8lLn1y5prXiRjuBTHJIHc5+uZBSsQ0DNmbeibbqtnFMqnAjqwKaS19VkJuRMYgUOcT9oMWTr2yUhD182Ws96qucEZytpvlyUMJDN1N3D4GKv6ouAu0Dbk9qZhrCfxilgFCUdZitqR3zlvCuPWXXci3mlP8WeenLiS8Mt+ARMY2H
 WDjAtZoq
 7dScW9BxUpLIOKyBmAEe9emhjKZHa63Fd/q0O3Dj0Ncoj35sh1STvc3WuiejIrbtkE4oLzElDPuMv2nvssMEBSLfTzgn0V6dmO/+rc0tXCp+W6eP3nluaP56cxKbdxKz/hkJxqITmi16E4TQFuA7P9Chr5Z721Zg0307CDqHB2HBOrfp6oyYvcyPVggoyzk8gixSIHdoqDcWcujzQEPMIuSEsy/Xx0uaPMv5Lki5nQ8wFHj0KStAIUpzSAsDn43q31PJpm3J4JemaZEHbIFEl7tOzfBTsSB9UtfzhizieU3tm2oufD6C/PWR6Nu3CghHHhTdQBR2LdxGd8EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 2:35=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Oct 27, 2026 at 02:56:13AM +0000, Kevin Loughlin wrote:
> > In confidential computing guests requiring page state transitions,
> > unaccepted memory tracking operates at the EFI unaccepted memory unit
> > granularity (typically 2MB / order 9 on x86). Inflating the balloon
> > with 4KB pages would prevent unaccepting the backing 2MB unit.
> >
> > Inflate balloon pages at unaccepted_memory_order() when
> > virtballoon_cc_needs_state_transition() is true, while retaining
> > order-0 allocations for non-CoCo guests and CoCo guests that do not
> > use unaccepted memory transitions. When a higher-order balloon page
> > spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
> > transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>
> I'm not too happy that this rides on the legacy PFN thing
> which is after all limited to 44 bit addresses.
>
> And given it is passing around 2MB chunks, then one 16 byte descriptor
> covering all of 2MB would actually be more efficient than 512 4-byte
> PFNs.

Agreed. I debated initially doing this in a single descriptor but was
trying to avoid also needing VMM changes.

Regardless, after reading yours and David's comments, I honestly think
it's better to just drop the legacy inflate/deflate and only include
the free page reporting functionality if we end up adding some form of
CoCo ballooning support. Beyond being inefficient-at-best here and
potentially making fragmentation worse as you noted in another
comment, the legacy inflate/deflate path is the biggest source of
bloat in the mm/ side of changes for this series.

> > ---
> >  drivers/virtio/virtio_balloon.c | 87 ++++++++++++++++++++++++++-------
> >  include/linux/balloon.h         |  1 +
> >  mm/balloon.c                    | 67 +++++++++++++++++++------
> >  3 files changed, 121 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ba=
lloon.c
> > index 11f74848fdc4..d162c162b496 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -182,6 +182,13 @@ static void balloon_ack(struct virtqueue *vq)
> >       wake_up(&vb->acked);
> >  }
> >
> > +static inline bool virtballoon_cc_needs_state_transition(void)
> > +{
> > +     return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) &&
> > +            cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
> > +            has_unaccepted_memory();
> > +}
> > +
> >  static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >  {
> >       struct scatterlist sg;
>
>
> Put all this, and preferred order, etc etc in kernel core somewhere,
> and expose some sensible APIs that devices can use.

Good call, will do.

