Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CE0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 23:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68756B0005; Sun, 28 Jun 2026 19:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FCB6B0088; Sun, 28 Jun 2026 19:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957AB6B008A; Sun, 28 Jun 2026 19:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68F1D6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:38:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0CCD120474
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:38:13 +0000 (UTC)
X-FDA: 84930937266.24.6C1A941
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BAC4A0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:38:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=REJHlv+t;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782689891;
	b=6ZfSy+SDTNXRe6wqvB+Odc4tV5DmWSf9adHOUenqoAEMrw6Uz5QhXjsvyenlu9UkJPXQV4
	uyQydUpZMIQP3fc9yZCqAAdu55RuqpWuzo1AxowDf/amJzchn1WPRjRj3U7M4kEM9By6B6
	pOGZNTGtCZC2+SM+aZC8LsAvi14PvHM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782689891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaNAzch66AgrefKnZPr7UqSbfd5kNS5KLyJJQedJZ/g=;
	b=RazIaawXaa6RJmnyRpxVeeDqs/pVIVIjIuVk7BaKg+Xh7usJdcS/GP2PC4GSjFGkytFfVx
	enWKYOg4DMOsCltg/u4YhD9UPVCm+0M2FaUaQRKf5YDAvL8FBmDXB2mhGA4M4fcGxQ6mSj
	PF1WHfXb3LidhvqB5qz7N8wNdgt6C3Y=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=REJHlv+t;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-519ed52bcc6so234901cf.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:38:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782689891; cv=none;
        d=google.com; s=arc-20260327;
        b=HfcmdANCZrdOXjdBSCjAKcOecsMoX6QJg0etoAbNjDrvx4M3+5y1PZgyxjB5asZmN8
         7yKSB7WikUkfNYMYKC93+aWs/BcU3VYLR/ltIz9Rrq0bHBOyc2p60yR7IKChpX11Oe4G
         dXR173gaRfNLpJWe+/pgnxLkPNQ9iwVkbmbph/sTbdi4Pz3aoa+SKUOO3nJbK8IH4zBc
         LiEIjGaVUpVzJSZi4WRip5olVunz+gMf+drY3YOp1Ugm5anqOEdMymmHAzaYJqFNfAvj
         +9MPusCIHUt8Y0Xiq0KWq8rKKadoJX8ZAWbm/kh2fCTpaO/H+gyDSXvzCkTHTTuwUkQt
         YkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZaNAzch66AgrefKnZPr7UqSbfd5kNS5KLyJJQedJZ/g=;
        fh=ufI/YD5rTy02sGBXahzvwguB89wiAw4W36qlG7eZwfw=;
        b=l+lG2RLMGRAdOOx2RB1QxQCvTQzj00FNrV4LG2PZZdCDOF/jdOmxg5Te80H8YEIAk+
         73iiFixaL7Fjcm6N22xr3gtOdmJ6wK3/7+K5hADbh18X1iIycj9Lp3XATtKWmj/Diz3u
         6cBKRt19m9LVB6L1twVY2/6nwB900IX5Ecgebkw64xBM6i+FcVFyJ3Fg7eIjzEM3M7lh
         zxWNROLvctuYTTH8zbiW6Jez3ndMOLOJoH+amLy7GrxDneTFEOVw6/Hm8yQZlqhRE4Qv
         QDi0rmf/okyA5fZ1u1qiY5xLz+cqFeOsTG9+1xAOOoAWD6pu+obe9xaxjT15SPUR00dI
         +7XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782689891; x=1783294691; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZaNAzch66AgrefKnZPr7UqSbfd5kNS5KLyJJQedJZ/g=;
        b=REJHlv+tiY1fl+eZDXlrB9/Fwdm6VmCclgb7g2GWIk4PDi9ihOYSQKZXs25RIrQtME
         WlltqGnxX6B4toxKSMUahRjM+imBF3Knwd4KHwiv0MutIfixa8dTLLRe0JOB64b3sqon
         bKQOpwAMPYP4s/+UJCmNTAxxKTQu/mSVkm6Eb+tojbfjgXndsthXjhbStshSakCebIX+
         IaAz25GG2tki9f+O+l56FGLtqjsnNmZKmQ2rKwlmzenTAH0EnCSY/NJJ9FKHwFNDQxjw
         o6VQnhDGQvF7BGZ3PnqGrlwE/Oh68fB4um1I/7j0Qn7kJ0JNNhuG5Mjpa/OXy0uAQqjd
         qGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782689891; x=1783294691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZaNAzch66AgrefKnZPr7UqSbfd5kNS5KLyJJQedJZ/g=;
        b=NZ3RBYtr7n8ZvQlCRcspg3qZa41NappK+3iY1WQX6mMwqxUUO3LetW+5KPf0VKai4T
         97LyFRMOfGphM1A49BWsijxfAzpNGxlKCUhUmsGHBn846I+jMlgsyynOoULmeFPkUsZD
         RyehyiTIPqdPPOxWKljF0ZIh9brRe6LVUr8u4A5M/DUZK506hsVoNSxokC/K1xdhcbH2
         4AFCglmVVplvhQrH/ozpYXEr6cpYXiQ65ZHXCekcm5f+yUvw+P7M4MGGn7WZG4rQQv29
         +kkxU4n1VwYVPTZhPdZQZJGRCZDTr0D5UXJid5NevFuBBPRS7fJHNxcF66g8qvcCVDkC
         QR8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/2PBFTfkwkZtcyy6JGGOQKps641fBe699ShNFS/GC+kzvot0Uydq2Rh4ZqHBGoQayAYKK3C9E18A==@kvack.org
X-Gm-Message-State: AOJu0Yz81fuBAf+2usgbln8ZbkUA96Vxt0SYDumoiafjSyLB41OpowW/
	lCtPz7Rtf/C5vLcEPsezn4K2NrEY8cMfMrWteA/7LWXZQ8UXHxeQGOK8UGvJcPrVRZgcXdBPT+r
	9MmEihepMgcLTkJqcR0X2S9OvaMKdsuKvUyqs95fc
X-Gm-Gg: AfdE7cn6dZQimYLaq8VvYZoaUTabwESGTXjYgJPs7OCAv3p10g4ljztTt9v/S1MkTv7
	c/7t51KS+jVwLr2vyN/r5VhaUabqle1jEx5ZouDKX7J8sJCoDM+LW8dJC1EQVkYoORLrwcdVNKx
	W9OLONoUijgX9vunls6+71OlLwFtsEAsR35rOiVS3LDElwhIKdbhW4r5+9ZKnMtuxyyO3QQNgp3
	ReBmF92a+8ANNpNXyOWQ5ge6NzPa3o58tRaUwoaWQ40ldrxp1Naih3xWn8ZdjhwoFENA08=
X-Received: by 2002:a05:622a:1f9a:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-51a8f65a1f8mr16797811cf.4.1782689890204; Sun, 28 Jun 2026
 16:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org> <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org> <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev> <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
In-Reply-To: <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 28 Jun 2026 16:37:58 -0700
X-Gm-Features: AVVi8CcHz29mUWBtDZ7w1koJuJeYJvDgDUspMoTVmLuyP7CWPjJJJDnQOqQ4Vdo
Message-ID: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8xx4px7pazo1666jbxb8m5gftzuu8yi8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BAC4A0003
X-HE-Tag: 1782689891-834513
X-HE-Meta: U2FsdGVkX19M3Zo/ciS5c2/vbrWGj1H7AWDBPwaPWtMPyOdGOzMFqqWLuTuIkevdhVmiFMu619vRvWeUYCvsZLMbV8X6oZisp7CCfy3rvgdrHKczQkWKfX3h/7CRJqtED+i/wAioYsuV89R+pw97adWmTGzxN4q3lWZy/NCBrh3Izx26mZ8oBF50HecySFT/mfg1ZXg8SirCUZWsk0XsAbZ8mx8J0IN/VhND4+m76Bp1yPlQIU7ZJYGPHeCAmHYvbGCvU2QsT0C5h9B9A75SJdE5Dyuo0+bFxqI3sE8so6IqDCVEdkWU1+EJ+pgjGwnMwft1gzApGNz24mp6NLltWGsykWKMvkiSmJ27lNHleUl7e6NRVa2MqONrau8q28qnUz7P7XM5TpZ/SoWlgCIye4U1fMwG8g30JV+5c9AVgi7FXYl8Bi/OBXXZ6JuwpsP6kzIFdNyzEGpNfHZjFhnk6XZEJbWFgGpLhYD6QDfyVIhpIo77V77W8C9NIBH95mONwuFO05Rz4R+4aXG3lljHE+Gm7DMC9U4VduYXD3P1AE2ZoHqiWUVaU11q9XI561OZolWGoaOTVe8lgN6epppzDq55+1L7p36ds6pKc4chQYaKnXTy/ce9nLeQkULU7EqB05WGHhgkhieDsmmtkrgkI2uWN+C+kpXje8ZMyg6/WzatNKzswpVt9xna7SLYd6GJYiKW9vfy+LRh6vaJWdV9ZFkjCt6/dD0vp1eH0lQQCFJ68VVaNJdbULd5kUMs1T4KH96pNGwxAjsuApYZkGShh+baHUy+GPVMICzB8ayXu28OcHLdZaGikOTjwHjRTgFGHVs2PyT/I1RUALqK9fVSj2ciBMSSSZHcJEvz590jLZ46cUm+5PEXCOcLDCJYnk40Ys97EOvYQZ8j8i93vsS4H77ZmAw4u/hTPQXHL6UeTu6eE5hsSFC0t3t3vGlyGb9UjzshH5sWGqll9nt1Y9g
 L9xgz87m
 Jm26VcZcaddsr10KVU51N0tvUx7QVbEugqx1ecjvrrzG0oIuZcFpMWSQ2p6aMHrQTPFcEwy2BgcnIYlRb2zbSANwJhFLa/VMTgkqy1rL0FyBjced/CsJ34zT3rQLoGa4xJZQy8EsFkCE/Uhbm8ZaUwFeTGtCJwLAcRXUfhAl9A+044RH7yUTWp/T5Y+ccy3vEM15BW77bnrfn2bFNFwQjQKKLZ2uDDmi50WVJGk9hS863Yhg2+jjZfmSptMiKUETe+J/xswiWc+jV7LSHO2P0y8/oGwuZAwrGabWgxvudFld03ZWdnk/u/B8TbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 2:22=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/28/26 4:47 PM, Vlastimil Babka (SUSE) wrote:
> > On 6/28/26 5:23 AM, Shakeel Butt wrote:
> >> On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
> >>> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrot=
e:
> >>> [...]
> >>>>>>> Fix it structurally by removing cycles of every shape: serve the =
array
> >>>>>>> from a cache strictly larger than the one it describes whenever i=
t would
> >>>>>>> otherwise come from the same or a smaller cache.  Every reference=
 edge
> >>>>>>> then points from a smaller to a larger cache (here kmalloc-1k's a=
rray
> >>>>>>> moves to kmalloc-2k), so the relation is a DAG and cannot contain=
 a cycle.
> >>>>>>
> >>>>>> This will fix the problem.
> >>>>>>
> >>>>>> But this will waste memory as we need smaller obj_exts array
> >>>>>> as the size gets larger.
> >>>>>>
> >>>>>> We should probably create a new kmalloc type to avoid cycles inste=
ad?
> >>>>>> (needed only when memory profiling is enabled, though)
> >>>>>>
> >>>>>> That would also prevent recursion even further.
> >>>>>
> >>>>> Yes but I assume that would add kmem caches even for users not usin=
g memory
> >>>>> profiling. Anyways, I think that is a separate discussion. Am I und=
erstanding
> >>>>> correctly that you don't have any concerns with this approach?
> >>>>
> >>>> Umm, the memory waste is a concern?
> >>>>
> >>>> Minimally I'd now want to only do that size bumping when allocation
> >>>> profiling is enabled. Ideally that means both configured in and not =
booted
> >>>> with "never".
> >>>>
> >>>> We probably should have done that already in 280ea9c3154b2. Because =
AFAIU
> >>>> memcg-only obj_exts array don't have this issue (or maybe they do ha=
ve the
> >>>> [1] issue? Harry?). But if memcg-only should keep avoiding the same =
size
> >>>> bucket, it can keep what it was doing and only memalloc profiling wo=
uld do
> >>>> the strictly larger thing.
> >>>
> >>> memcg should not have this issue as normal kmalloc caches do not serv=
e memcg
> >>> charged objects.
> >>
> >> I am wrong here as I went back and see d8df600b67d7.
>
> I was confused too :)
>
> > (8dafa9f5900c upstream)
> >
> >>>
> >>> So here we can do dedicated caches as Harry suggested or make this si=
ze bumping
> >>> very specialized as Vlastimil suggested. What do we want long term? O=
rthogonally
> >
> > Maybe long term we make kmem_buckets unconditional and use that.
> >
> >>> we do want this fix to be backported easily to older stable kernels. =
I will see
> >>> how does this narrowed down size bumping looks like.
> >>>
> >>
> >> BTW I think we need something like the following, right?
> >>
> >>      if (mem_alloc_profiling_enabled()) {
> >>              if (obj_exts_cache->object_size <=3D s->object_size)
> >>                      return s->object_size + 1;
> >>      } else {
> >>              if (obj_exts_cache->object_size =3D=3D s->object_size)
> >>                      return s->object_size + 1;
> >>      }
>
> We should not add mem_alloc_profiling_enabled() check because,
> then we're not fixing this issue on SLUB_TINY, when the caller specifies
> __GFP_RECLAIMABLE|__GFP_ACCOUNT without memory allocation profiling.
>
> `if (!is_kmalloc_normal(s))` check already bails out when it doesn't
> need to bump the size.
>
> So Shakeel's original code will work fine.
>
> We're only pessimizing memory allocation profiling and
> SLUB_TINY && MEMCG users, but (as Vlastimil suggests off-list)
> it wouldn't make much sense to enable MEMCG on memory restricted systems
> anyway. (IIRC even raspberry pis don't enable the memory controller by
> default...)
>
> I think it's okay to fix the bug first, but we need to address
> the memory wastage issue sooner or later if companies (Meta and
> Google I guess?) are deploying kernels with memory allocation profiling
> on in production systems.

Sorry for the delay folks. I just got a chance to read through this thread.

I think adding a new KMALLOC_TYPE would be the cleanest way to fix
this recursion problem once and for all. This size bumping and the
special case of SLUB_TINY are quite confusing. We could define that
new KMALLOC_TYPE only if memory allocation profiling or SLUB_TINY are
enabled to avoid new caches when not needed. Does not seem too complex
but maybe I'm missing something? WDYT?

If it is more complex than I imaging then I'm fine with Shakeel's
approach as a temporary fix.

>
> Perhaps it's worth adding a comment like this, though:
>
> /*
>  * Only bump the size when the object (not the obj_exts array) is
>  * allocated from KMALLOC_NORMAL, either by memory allocation profiling
>  * or memcg on SLUB_TINY with __GFP_RECLAIMABLE|__GFP_ACCOUNT.
>  * Otherwise, obj_exts allocations cannot form a cycle between
>  * kmalloc caches.
>  */
> if (!is_kmalloc_normal(s))
>         return sz;
>
> Thanks!
>
> --
> Cheers,
> Harry / Hyeonggon

