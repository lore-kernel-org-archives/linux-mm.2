Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB29EC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10676B00A1; Fri, 21 Aug 2026 13:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2066B00A2; Fri, 21 Aug 2026 13:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89526B00A3; Fri, 21 Aug 2026 13:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B53D6B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:09:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A18E1C00BC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:09:48 +0000 (UTC)
X-FDA: 85125913656.13.E7BD47A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A69F10000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:09:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBeec9c2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787332186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
	b=qoif+hq1rJigddmPPEGcQIZJdbuBoi8zngrDubcxem3hUa6I82cWKWZiC3Nn3vX+k1e3Vz
	g+fpApNCbti6zD8dUos3UbYue9s5jfPJnOi5fMzy+IavJQMlJGFS++Ub2cr/ytqXQsdsqX
	ynTowsk5htmRnVySW/78w8Uv4oPHgYY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBeec9c2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787332186;
	b=wUNNLEvTcdZLVUbasrn53qeCOt9QyvOD06BIZvLduum5Wwv8CjBB8yWyVrbrVD+iPhfYxw
	vNd7mx5KqfJjGvi6hvXeAxNyAkOHW05Ct2AM5noDGa5zKr9j6kTE5SraaaEEUVYOkuIMV9
	cUnUVa1WOKYay8jsOQQKFJHx7OMrYkM=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so1216811f8f.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:09:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787332185; cv=none;
        d=google.com; s=arc-20260327;
        b=OEc0+G2DjK/keqnZ79dcrooPHtohuI/hdQI6ef7N/OQeLQBAPrVmPDlLHjtczHjuP4
         99bvDady0rl2dXOImpvFamCgdyQ4zBMVv/QxoH3w11wOLUMqLg4HZoeMPTi2GQgdmSPu
         iQtYfUEOTqHfbAQaus6aiBfEsoumrCi/VOP2uLqrRH2QsVSvqcqQSlMU+0XCl+rcWZQn
         2ieewzVzC1ikw8THUyc3Zz/uCZblywHDiHgkQs0EPbV3cP7UhzofDGhCnfdx0EYqRwC0
         L1KM0SQ2oPbdrbONtEFQFDOkzvE+39maAjNwuWftuQEWMD/XEugZwY58X/TUOFXvlpfU
         ARKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        fh=2GQh6D88EYRxkac54Bj8Wl4hm7bc5Bz9RRGmQ2jK/S0=;
        b=n+HEcYQkSHYJ1qrjYh0iRpaFzBNL2jhzYHMMSpOCkxEMzTOwJ6j5LZ0cby+OEd/SaX
         s8xbR4c43JVqh9HX9FFOeZt9D1rlCvnzJHKfnKwKnikhdYwEezkg+7kPQl9qqED6TSXZ
         xZefVp14PZbe8+1yo9pjZohrV3dd0zeqL/g7NFA7gpPfFDg54xbI4KU/wjOiLDpB8MoX
         LirUnXTTlQovlDwRLJw99ldGB7ctZq/0fIMl9szaaWvH1k26DomC+XVyZutuokGA+f1U
         yZOPq4SP49okKPLv1to9EZp7+jkd9VXbkkNOgxt4sKwW0jehrjRZFw3N1umJR+JQes1y
         rgtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787332185; x=1787936985; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        b=fBeec9c2NMuwzJ2bLu/6yzXlW97h9EPa32p8DClBEc+a82y0AYNDJxAUZPG3wdvdaQ
         4IR1eTeFje25Exc8Fhn1J5BPv/F3bcmFjudBdEffLITzKzN019VLL9scndWPpkd+cS7d
         p49NCfRQSx2VQenufhwIvJ6CEhWsXpRhPQpRHhh4E477b9yNR84jx1DeqyKEsHCRZC87
         VEEat/4WL7edqa120qJNL8rjCmvn5VJwzOJcuBhgXjebsYz4N7qU7NdISe9170ZzXoWw
         bAcFdcMTGY0NhbD+X3yHBz2uFRE+BbaqvZQvIDpbxHQDkD6408QvIl7msGSzKbCmhy79
         XQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787332185; x=1787936985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=veZnyf/dfYhbTVP9YeELLr3c4PfKlTUdiQo55s2EN7I=;
        b=G1MLDGpK86qzmBmWIm3iSiEKx99VOw8CmiUSs//1rN0r3YrBiaI21h/IVlOBaqck/i
         O7wpo186XCb1nwDBm6GYAzzGumlW+TL+tJJRIppXvfl5tADjbvmmSaMcC3KLGWp7sgwq
         HaEayKyvJilBncd+2nZHuWF6qacY0P+J0hw/q5IKz+YoLrk+pgCJC0ClZ5RQvoLHpjPm
         78cagSjbAY6Qn9UNBDMAeAMIZRtm0SpB0ONl3NjvqTwKhA32h1afH1h2dvZZ0vgMuoZY
         s9cMfiNmzIUJC7a0lY8CLxoXU2ODLfKBmQolM3rVQQQmnNO1HX4DdJunGxgwlvmtn3Ju
         c4ug==
X-Forwarded-Encrypted: i=1; AHgh+RoybkXAJRWOeBKGtE0ZPFbW+S1cPOQd154X49uaMaYfsfjAoTkoZpUJEr0UhOnBBLBDVUlcgWK6EQ==@kvack.org
X-Gm-Message-State: AFuF++loipIqywej/ClLZ2f3lNi7ewl4rjbPOwx9tgA8X3SKXQzWy6z4
	yqC/Qy//Wud9XduVzMy+78cNi5jlb1VIm4JjQNXaBz1AIxyqlO3L03rtUkUCiEU/PYAsDpQ7y0u
	msyUiiUUgCVpDmJr1qumAcdJoYNzf5Vc=
X-Gm-Gg: AR+sD10DUeRtYIp1kk5Yj5RlK06odQ6+JBNUyPU3heW0u6HTp5tjLUq4J/fl9fBkf6M
	2NXD+BBodOxVP1MalO6kbu48Klr5IpuRvJytlALjB2Hf6NiGkC82BesKLAOo5Z4RtI5jBKychE7
	feFHbBGv+5BZglThhRTG9x/+RO7rKmUus9pXbnOc4pWfzU79iOpkJ1HtgnSUGaMu5tmQxG/K7bv
	YJtnCk+UuTPOMGVtJZBC2QjvFLA6yxuv4GMv8okLiVMKHbW3WDKRrI2/JxhgXM1EZHVUGmLoveV
	NTuuUJ0b0KJgqpeavc3382KHcZbD8xFNGrF3lbaFPQ54WSztkgJEr/tqlBfe2u5mGthVxBV/S0a
	T
X-Received: by 2002:a05:6000:1acb:b0:47f:71a6:970e with SMTP id
 ffacd0b85a97d-482c0b55d3fmr11033799f8f.2.1787332184426; Fri, 21 Aug 2026
 10:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-3-nphamcs@gmail.com> <20260820041940.443214-1-kunwu.chan@linux.dev>
In-Reply-To: <20260820041940.443214-1-kunwu.chan@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 21 Aug 2026 10:09:32 -0700
X-Gm-Features: AcwNN1Ugn_Yvgh2BA7rl2-6Ryj849JsdlpzstMFnk3QEm_uy8ugTFY1jdBeldW4
Message-ID: <CAKEwX=Mj7QVArjKVvKOKnuQoTmN1Wu=vXe4jkLshnzKoYF4XkA@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, 
	david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A69F10000E
X-Stat-Signature: zczpanukqrcmhfy46fakcff7wyhdrj63
X-Rspam-User: 
X-HE-Tag: 1787332186-891665
X-HE-Meta: U2FsdGVkX1/Phee56Rzj3/tTgqluiVuB4xqNhy0nfbJflncaXix1RcI2gM2wK4lrA10GZ1vP2nnr+foAUFGvPiitI6flVhYTD6iSh0yu7EWKDROIClIfq5DaFyY4K3IN1GqRG8mmHUmPTAr3GhTX4LICia73wD1LNJZU+B6dQClc3WLMVi4qTTeZ9bmxavhHs5QODwN/OMkr9B47EkijaEatbZ+DvuSpepzblf/zRa05RFyW8FTlExHmUWU+QPr8tnRxpdeEwm69kCSV+y1+nETz68Aemu3BvAYrh2MpEDowzJOGugdIeQXWrW2olUmFGU1p+mP5mY6bWoaYZNZhhL2ug8fXbMNw8P1+qbN0ejbTdlr0IvI0ErR2wfErtphemLnsteCwpdHo4L4itcZQfyTe/dm+UfReA8HG8dMn0fB9f/975nu5qx8ZZjY9IB38rzIN2nAP8TLe+xc2jw4r4l/RydoBBaJp6ezoh+TpWOYZ8B/+UObYOLVivLHB6nqtxACfrkbBBkeGGAbn7gWwPcLcBboaTOQfFqnP6CWuPG1DFJobeuxAAOCL3Ph/wIWBjDxBasXIa70+CcqnB9o0AtbuNDu/2L8URLTkcJsNJ7a2GajPoPvNs+KgTaKFOoEVG1klNrMqPSpepREtgibbiPHgWKRHYl7/i71Zw9RQGYSGdRkN5rJnJct/SI885q2rnYkp5L3PqTqLGndK6N0kutQZaWegDMDZ9fztiv2CY719AVaPKNiC6Rvb8iTYFiMX/eT5tLL9DO0qUSVAEhuSlwKn2A2q1F3JYP+3bh0GJpJUnPq1cOVuBXBDX7ey9umwmJ95ow3xQ+OTOuw9kyuf63/IYd+rltVs29xU9QrJDYna0ByS/+c/PGHznovwsQvDAZbuVmftpu3ORxjZrlMJlGxYViDJVumNM0A+WPvhBLRlIDLQzM1SeS55zcJ4P+L4en7k8SRCNnlDkSBEofK
 j8Qf6a2L
 mhya+/I833UDfzJ0ajqve8xXBy0OYor5lxD1OpBT6yURryYMKa9Mb5JItDBSZpGxT6JD3s65IxGzeX8+XNwkdPuJ/bO7Tm0W1lJle2EgqR6OKMTmiABYRZKOVYl8RHifQMTATfDrRc6g/xwFZmihotBLxxqyPorkqQhKimkMJ9MusN/qH442fFw7QSvlKyLsKQyJ3ENl4csPyqIHl/XZhUIlXx3mlioztHDcqkAhyTt6jJY9Iad2P4v1uNHM/J4mduFFWrnox2/AwzoUtk6wJqC6RjvWLuvqT12/iQMrJl+WDKmZMyJkF6XmQR1QSadPB2zj/I+0Lz71Lxq0GZHRpE7yutU81fC4LJ5tGK6FSDOweYmw/HDZGsy5PmTKzXVHyNcha3bV2lLD+3wq4eB1Tiu4rFR0Up4HVirN5oVfYzpb/qGgohqYPSTma/1d5XmrTxZEPnzom9XeQf/Q7y9Y+tyOydWxuuvkwSiwMIUeJEuMFMu6Xs4X2Cg7PbLNfziE6qvxoFLvtaM7tfcASP7JgvL9wVPXl0JVPQE47
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 9:21=E2=80=AFPM Kunwu Chan <kunwu.chan@gmail.com> w=
rote:
>
> On Thu,  6 Aug 2026 11:42:45 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> Hi Nhat,
> [...]
> syzbot reported a NULL dereference in the v3 series:
>
>   __vtable_get()
>     vswap_to_phys()
>       swap_entry_backend_has_flag()
>
> Seems like the underlying issue is introduced by this patch's
> `virtual_table` lifetime management.
>
> This patch adds:
>
> > @@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
> >       struct swap_cluster_info ci;
> >       unsigned int index;             /* for cluster_index() */
> >       struct rcu_head rcu;
> > +     atomic_long_t *virtual_table;   /* Backing pointers for vswap slo=
ts */
> >  };
>
> [...]
>
> while the read side does:
>
> > +static inline unsigned long __vtable_get(struct swap_cluster_info_dyna=
mic *ci_dyn,
> > +                                      unsigned int off)
> > +{
> > +     VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > +     return atomic_long_read(&ci_dyn->virtual_table[off]);
> > +}
> > +
>
> `atomic_long_read()` only makes the access atomic; it does not protect
> the lifetime of the allocation being accessed.
>
> [...]
>
> > +static inline void vswap_cluster_free_vtable(struct swap_cluster_info =
*ci)
> > +{
> > +     struct swap_cluster_info_dynamic *ci_dyn;
> > +
>
> and frees it synchronously:
>
> > +     ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, ci)=
;
> > +     kfree(ci_dyn->virtual_table);
> > +     ci_dyn->virtual_table =3D NULL;
> > +}
> > +
>
> The existing `ci->table` already has an RCU-aware lifetime: readers use
> the corresponding RCU access rules, and the storage is not freed until
> after the appropriate grace period. `virtual_table` introduced here does
> not have an equivalent lifetime rule.
>
> The syzbot crash shows that the current teardown/read-side synchronizatio=
n
> is insufficient: `__vtable_get()` can observe a torn-down
> `virtual_table` and dereference NULL.
>
> I don't think a NULL check in `__vtable_get()` alone would be the right
> fix. The NULL dereference is a symptom of the missing lifetime guarantee.
> `virtual_table` needs to remain valid for as long as a reader can reach
> and access the corresponding dynamic cluster.

Thanks for taking a look, Kunwu.

Null-check by itself is not sufficient, correct. But I think a full
dance of: rcu read section + spin_lock + checking for
CLUSTER_FLAG_DEAD should suffice. As long as cluster is valid inside
this rcu read section, we can get the lock. Once we have the lock, no
one can free the cluster under us. and as long as the
"CLUSTER_FLAG_DEAD" flag checks out under the lock, we can exit the
rcu_read_section(), and proceed with reading the vtable. I already
fixed this in (to-be-sent) v4.

Note that this is actually only required where we don't have any
reference pin. One example is the one syzbot detected phys swap device
backend flag check, because at do_swap_time() we don't actually have
any reference pins. The PTE is not locked, so swap entry can gets
released underneath us. But if we have a pin - for e.g if we own the
swap cache folio, then we don't really need this dance.

