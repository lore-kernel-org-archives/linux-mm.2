Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E7CCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AC26B008C; Tue, 29 Sep 2026 17:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBACE6B0092; Tue, 29 Sep 2026 17:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA1D6B0093; Tue, 29 Sep 2026 17:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACD66B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:11:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3363BA69DB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:11:05 +0000 (UTC)
X-FDA: 85268044890.29.1377C0C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C37F2100007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:11:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKEReLvl;
	spf=pass (imf14.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790716263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0avdwGRUerzew4pppHC0Kroikq1W4RaEB726c/pnxQs=;
	b=dEY0Z0LNUhw/V4r8VzjSDIhaCLHI/fv1EqwleflvKXV3B2tuE06UhKXEv2EY+1bp2YV50j
	cR6CdxH3Y0wd2LSu3ctFend4Fu131PTbElmih5UqfwXlnwLRiPFZ3D4GR7sgU03HHUh2Sr
	kVlr+k4jSIdI36MS0BEnXX5CH+iX9Fk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790716263;
	b=scTMWzFuWbG1yW9xD8U8C73qQ5xkdMQ4VCAAePNRDeguIXFxUS5WfMumuNSTl1vztzQjq1
	yjZ/hae3G1EBx7JS7l+Fk1oRO+BO92emWR51nt9OTwKPgVGOpeaNrgmxyBhAc8J8I2JbmT
	BrqATfSnJtVV81o5RgylYd3t9RNANtI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BKEReLvl;
	spf=pass (imf14.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790716262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0avdwGRUerzew4pppHC0Kroikq1W4RaEB726c/pnxQs=;
	b=BKEReLvl79+HZLdXykWRpzMod/vL9QvFWFTBdtMIKLgpQkFb9J67FglMkPvLW4K6l6nM66
	Gbr/5O8x+uxsBBTj6B1r/YEG4HXhku9Bc7cMVJkdqYo8iJR3JOxtOdTpTGnQ0iTnVBSyQs
	wRL0jg/Khe8XiR5oL7xgcyh4/XyR1aE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-BObc1XV2Ngigpn4T02PZGA-1; Tue, 29 Sep 2026 17:11:00 -0400
X-MC-Unique: BObc1XV2Ngigpn4T02PZGA-1
X-Mimecast-MFC-AGG-ID: BObc1XV2Ngigpn4T02PZGA_1790716260
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8914aeaa16aso75957347b3.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790716260; x=1791321060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0avdwGRUerzew4pppHC0Kroikq1W4RaEB726c/pnxQs=;
        b=GKs+XqHEn7ux5d8cOt8l1D77w4KDZwP7CdwPmeCxcjPreoIZmmK1pMf4rYNXhH7J8A
         VwAjd5yOcWhdIW286MMXMtG81Ph4+lNvO18NP10p78RU9UXhAnzBt02bsXUZIVOyvVrw
         6qsvp5a54FHvZVrOi1eZxCtC3cgmSjfyIF42vqrcsr36OoJGtZC0Nd/43kNvfb+VdQTm
         Zm8ToD+ENdzARtrZmsFSXZ0CmumFYdZYeIcFam6Hkg1Re4//OS1qX/DaJO4BE7IAZvq/
         KFx6J1iVJRxkDDlqbVL+ZZpvm0yWcCxRe19Ap3hkW6uKc5Wc77a/mx+GRBxAxqltIPUk
         0Ojw==
X-Forwarded-Encrypted: i=1; AKwUvBzALCtpjQi4De32TOq0KH1SfPEDfaOhX45GtIuZDRMDwH7l4r8rgjRCUw0rfdBqvi+QVFSks155Uw==@kvack.org
X-Gm-Message-State: AFq9FYKSp5Ey016Fvd7eod11BkSpQwF7YKe0RkArBJsTLy4jta9zsmew
	YjIpRkxI0HXyOTrc88KRme9ZRtvZ7dME6NFztx9KypcEdmAHYtFV/ikqk61d86mwSqi2QNNpAKr
	mexfaawE61fLsJAiKyzcHDWUHAyFU2EzKhDsepFfow78HpiUnoYN2XXnEN7xDCmBw05aTLI01oK
	S7qFvPbZz7o7zKgU6I7FQEKSfVX96xRPWcZxxSxeCd
X-Gm-Gg: AYBFou059htiXemn/wjBiDtSWX+XoDxQGENu2XNQpwSYeVLYRhdnTARHGhL0kQdQ6lt
	CO8tSyPNzfrynHGVrtNe5ZHPeKSJwlLavP8Y4PI0nnWzuduqTV07hnn8YGHLb8Rhai9/BodHVG1
	01xrL+9Xim1chQ0u5UndAIlFbPsL9ntxOYvPjNixrDvfG/CnRbpaeTU4EBAT0uheg/teOhMFZDP
	u6vdb9OU8NJUFClK63xLe9xeiFxsRS6loihQ3d28fbpTg==
X-Received: by 2002:a53:d886:0:b0:675:5f54:9e75 with SMTP id 956f58d0204a3-67644171349mr158631d50.79.1790716259997;
        Tue, 29 Sep 2026 14:10:59 -0700 (PDT)
X-Received: by 2002:a53:d886:0:b0:675:5f54:9e75 with SMTP id
 956f58d0204a3-67644171349mr158620d50.79.1790716259511; Tue, 29 Sep 2026
 14:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260911081309.14137-1-jack@suse.cz> <20260911085142.1774803-9-jack@suse.cz>
 <CAHc6FU6YT4EzM8VDX8V0+dhfRJtSrtWxbuwht+b8HG5yzyq7Lw@mail.gmail.com> <kgxyhbgbewpch7pc3auxthhbcfelq7lgi7mxazdo5wvg2ael3b@hilsbf4622sh>
In-Reply-To: <kgxyhbgbewpch7pc3auxthhbcfelq7lgi7mxazdo5wvg2ael3b@hilsbf4622sh>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 29 Sep 2026 23:10:48 +0200
X-Gm-Features: AclHuK9UqhWpM6SAUINx6rl63wXociZVUKWztTN75qMxxHCVsEZdA2U1AApCAYM
Message-ID: <CAHc6FU5uXnjhL9SgOX06xVdTXFP7DtWikwa0bn=bEW__is9bWw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] fs: Add throttling to deferred inode reclaim
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v2PQtXSrPNvtUFr3mVj4aHBJsI9d2ZgKa8XP1ShF2eQ_1790716260
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mudupmouhz756zzoixtkbugarndx3thg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C37F2100007
X-HE-Tag: 1790716262-46306
X-HE-Meta: U2FsdGVkX1+wFLIggWr7AuESls2lvjVyLwJk+mA5jBaReb9smxnb6IUpS0qlq4mYT6bW02nc0tX/d7rPJ4W69UEs+uyRFJKWkEugZ6Bh96LKcXgIGMCNzMNAWU0VHLWo7pzL0PDdyZgjD7QSgiEI1vkRWQChDPJ7/sq9CDcAzXIgVqB0FZ3qtGI63PaRA64xtUCw7J6X5ri8TzilPWrVcd3uLuQTizKguFJOtQMelsiEoOVjhuwhKEpFhZtLBblkTAt6IId7xmBRF5NNPyQaX5/LxWbVYYBOwo4MTMB9vesXsEOX+pV6dcZfdoa10gKhH9ZAIMlhDRMfIKrZw1q5vX7+abzfGqks/uF//S9oowG+uEko8iVe0e3tAedBU0/IwKzcAMEMUY4uSwm44WfwE8lgcktBtmEZYFjipfP8PW0JxlMdhc/FPqJxfBbZ4NlhgX0uJKThOxjvLWHr4i3xio7mImjxtzUs5xcYRbBfUqBC0n7Njfmj9TocMTWVZWNXm1RpYtwwzJqgawxE/dCkbKC9JdcDdMVojUiiXVlhmw0+A6LUurPL3QqQvGRkijseBqVn0IL6dkPtD54nU7g/u9/svXz/x3jTsqYG2I5xmm0yJpQc8YESwsAEl7MZuSvdwmjtF+xtxJgbwkokyg2D/MB+ovrqdVVhVxk2ec7gXzCC96x7/pwkxWMR7JVSrDIF+9+ztf9t5GScrXkUY+H1VBu59OOs+EOlkl24d+NyL37TkNWTjxJXrdmzVyKX9m7kPcI7SRY1BLXd7+eql3b5le05w/DvdusKcjZAIgCjW+WWURO3QvMYxj2A1TsskL99w5HFYtEOA06heweC7l45RgV1qAob7UFTaIQj3f65CfnYIUIOeefJOosDfFRmOsQea0SYYT6EF519xJdyoraUarmIf8+D6lWx2jjKPMOi4ErZ5SNYmEfv9rJEV7CPUFvNE9Og7cVNmP5CWvJQxIX
 EYGQGWIz
 BDPzu49KAhSECCIioiHPVqF0vfdPWCo1Z9PW6VMGW4hrMSgxAYv4Utqpl9Z7K7tBzowboxMF8TUX3RxDj5PZtH0pw2EMZnljruozfvCfPwlrezQQnZ9gYFTIu47ELPPy6EBEt0qUdReg1R+DEJ7BWjhPGVapBIZZaJc5rrDTVII4crwVmoSgJWGce34aPB52IIRQ/aeXPIQqTQ3Lt/eQsbYiJsGiRP5LzPEAmOBhBEzmamSxmzFjvx7Y7SACzWdhG8NXC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 7:09=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> On Wed 23-09-26 23:24:48, Andreas Gruenbacher wrote:
> > On Fri, Sep 11, 2026 at 10:51=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> > > Deferring difficult inode reclaim from prune_icache_sb() to a workque=
ue
> > > removes the natural feedback loop of blocking tasks in direct reclaim
> > > until they make space for new allocations. This can result in the lis=
t
> > > of deferred inodes to grow beyond any bounds and possibly push the
> > > machine to a reclaim storm or OOM.
> > >
> > > Add a throttling mechanism slowing down tasks in
> > > mark_inode_reclaim_deferred() if the number of deferred inodes to
> > > reclaim for a superblock grows over limit. We measure average time it
> > > takes to reclaim inode on deferred list for a superblock and block ta=
sks
> > > proportionally to that.
> > >
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> ...
> > >  void mark_inode_reclaim_deferred(struct inode *inode)
> > >  {
> > > +       bool throttle =3D false;
> > > +
> > >         if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
> > >                 return;
> > >
> > >         spin_lock(&inode->i_lock);
> > > -       inode_state_set(inode, I_DEFER_RECLAIM);
> > > +       if (!(inode_state_read(inode) & I_DEFER_RECLAIM)) {
> > > +               inode_state_set(inode, I_DEFER_RECLAIM);
> > > +               throttle =3D true;
> > > +       }
> > >         spin_unlock(&inode->i_lock);
> > > +
> > > +       if (throttle)
> > > +               throttle_inode_deferred_reclaim(inode);
> >
> > I would expect the throttling to happen when too many inodes marked
> > I_DEFER_RECLAIM are evicted, but not here. In my use case [*], inodes
> > would only require deferred reclaim intermittently, while they have
> > outstanding revokes. Once there are no more outstanding revokes, those
> > inodes can just be evicted directly.
> >
> > [*] https://lore.kernel.org/linux-fsdevel/CAHc6FU4Rf9-r8m8SSb=3De0k0zyo=
FhQAdjupHMWvT6rStBshntug@mail.gmail.com/T/#t
>
> Throttling during eviction doesn't make sense - you are punishing the wro=
ng
> task (the one trying to free memory, not the one actually making that
> memory hard to reclaim).
>
> Also note that the throttling kicks in only when the queue of inodes that
> we want to reclaim but worker didn't get to them yet grows above threshol=
d.
> This means there's significant memory pressure, significant amount of
> deferred inodes, *and* workers cannot keep up. Throttling marking of inod=
es
> for deferred reclaim is the best thing I was able to come up with to
> eventually reduce the pressure on the cleanup workers. But I'm open to
> better ideas.

Alright, I guess this should work. But the change from throttling in
prune_icache_sb() to trottling in mark_inode_reclaim_deferred() should
be rationalized in the commit message of this patch.

> I understand your objection about the need for deferal being only tempora=
ry
> but let's keep that discussion to the other thread.

Maybe we can get away without it.

Thanks,
Andreas


