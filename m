Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E78CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792B56B0005; Mon, 12 Jan 2026 15:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740E36B0088; Mon, 12 Jan 2026 15:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F156B0089; Mon, 12 Jan 2026 15:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBFB6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:43:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC3171AEFDD
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:43:15 +0000 (UTC)
X-FDA: 84324486750.09.1A38727
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id E2A76180009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:43:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUE+BLii;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768250593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Wn+2Bz1XnwnLY98RFma90b13qbfeCs0rC99BF5gEU8=;
	b=gqxfqOYJ2izqMqvepgNvR1SKBgLmej+SZlT0L+QeWPAztFNzOuXA9LYZvrwmyX319U8g+8
	O31645UQE765Sax+Of7jh88eDo5F889QYuo6O9KQpeortfcvWPMFGJdICwSatKKPxyZyWV
	dnCpbD55DZAu5vXcCE3bSN32BmUL3dM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUE+BLii;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768250593; a=rsa-sha256;
	cv=none;
	b=YAIcS2gGCBeXw0TQ9uiJFLmFpMX4jI7HbJtbcvnV2mBMQm4F+a9GpUuVCt4+5JO1fiX5fT
	gE2Fss5DCmLBWYNcw3YkHg8BiSl2eWOS0ZfRqcFrNMCvDd1r5Cf/UAN3TLIcKpXl2NuV9e
	NMGCAU88E12P2DFizI8o+LwdRBHepJc=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a35a00502so64978316d6.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768250593; x=1768855393; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Wn+2Bz1XnwnLY98RFma90b13qbfeCs0rC99BF5gEU8=;
        b=RUE+BLiiiP50wi5e/SmBmHcnl5EoxCaE/ukpbqTLfiEZKLSsR4xHIZ3tneQeLT6Lpl
         1tBRvYUSTc6n4Glaq/lh0btkMnISi6l+qqfmp5Ettzcrw6GdJhJ9T9ymYqHrgspJUjWO
         kPF+2hqPN/mK/PFekFORdrHyNIpjyUF5ckK1Jbkrjb9LLW/WxqSGtXOttlbQzs4YwTCa
         OnyrqZPFhr0/NOv4W4lKR0wxMtdQ1nFxuq6y0Yjn8H4X7asr0Wtz9gfAMD7Jj8fA1HRw
         m6cD5vK6MHRGwE+1l+30TZvbtrE0ZHTLnmJbFtXLspMsKu8rB+ssizwqlD7KMWAXjm+1
         XSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768250593; x=1768855393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Wn+2Bz1XnwnLY98RFma90b13qbfeCs0rC99BF5gEU8=;
        b=gGgUXuCNcg/zv119FrKRp3BeP2AuV3Dg0v7Hvp+SoHKwfdth5NrNwuD+aHkxtGFGu0
         qPs9aNShGRo40rr6vjZ++cYZ6c5jE2NCLnou9vR3q6feGbPxYUM0kLKrpCHoMfS9dQVM
         VUVxQ9uj2RwG1os2L4gV0fQixzyLVvtE/jLPjqgbg9ktKU4jNechiUHD9XZ4LCaq2S2t
         McRSh27aynGAQ9o+aiNkElCqvjCpH6emxhva+XZDbvDPzet1DDM+BIBYxAW1x4w4/Tkj
         nBazL00J2VFu3KMa0ZMOVhrChI2xKOVmrTUfisbu6UBp67LbefZT7dF/rMEv9LSl21y/
         03ug==
X-Forwarded-Encrypted: i=1; AJvYcCWLLj49prkt7Ebp+XGf6Rql4EwuceeJCZy0J2E9TNvJTQzykHwva60YO2Md0WpyGe4gghWbBGQ/Ng==@kvack.org
X-Gm-Message-State: AOJu0YyRbm0OKAtl2Bs5YQP6+Fxdn2lJ1HKTlL6ZzNfYiXke4hl/ImaB
	VMBHkVX92S2b1/iH6Gxq8MuGO6MuLQjFCnUWk+61F8WaYQDw8ntXqt/ff3CEloboXvURJZPu1TA
	r13M6TosYigs1vy+ZI6sG5/KJdLLEFnA=
X-Gm-Gg: AY/fxX5D3X8krhV+L9j+yf7IvZkoJrpRRfj7GSnV6wUpnTPk7x/Y1RCur1Csro+VBRP
	N99s9R5tTnQQPYGwnqB8HVZFVtHsk7/LZL2HupljpwlcD/u/nqt72lfrx6sHc0p7cnUSjiqp6/Q
	pNq6EG6DquI/y8uKmYvugmHFXKTbCi3bWUfUyAyIuVPhSsyf0Za6E4pD1OgVFPdZq22Fod+MyjF
	gqqDnO+UCukNxKVkAYDK2aptS9TXslUx6noPAKb89m8oXkn76+WBmZmiK0wXzseL/tTsg==
X-Google-Smtp-Source: AGHT+IExUdgRj/l+2ZKhV/eGPO3L8kyW2OQay5HeroRpTVftTdhLkG565qIV2TBfcRl4dcGmY/btmAf6im980bfWRog=
X-Received: by 2002:a05:6214:570a:b0:890:eff:c135 with SMTP id
 6a1803df08f44-890841e462amr296018626d6.4.1768250592943; Mon, 12 Jan 2026
 12:43:12 -0800 (PST)
MIME-Version: 1.0
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com> <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
 <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
In-Reply-To: <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 12 Jan 2026 12:43:02 -0800
X-Gm-Features: AZwV_QgLt0LDqG4AYy4MxQx2i1PR--V5T3xK6lVVqNwOZj9F6Pm2LmfKAKM6_-0
Message-ID: <CAJnrk1YSp10MCagMGiLw87p9UHbU83Ovnyz5z52NGDxV=My9bw@mail.gmail.com>
Subject: Re: __folio_end_writeback() lockdep issue
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Bernd Schubert <bernd@bsbernd.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Horst Birthelmer <hbirthelmer@ddn.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, hdanton@sina.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7e15k3nzup9nxsxwdmz53y7wjq5y8fcj
X-Rspam-User: 
X-Rspamd-Queue-Id: E2A76180009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768250593-795521
X-HE-Meta: U2FsdGVkX1+yMqVh71OO6THI/4H4xdZtj7RaxqiykOqD2MYeK08wbhS/x8GYeK7Jet2ncaOvqR6M7HpLMH64IiXac+UGctIFbvzY2UiC7Qf12EsMfwaYOciw32wqB6pEie3Jq55182O+ft8PWpRsTCIY5HviYkJijRIENo0x3u0ueAvTAQkJ5lVrjB9z4FOMQZ6kI+Ko6H8LPVOAYCPEdmw53RhUEai3nq+DRtHQCffl+w3dPXkKrXLrvaeBBanSDgWtKklAkXBphA+uu+wr9d7F80W8ugaOMqctZfs1kMaI7uWCA6g1ygum0vD6S29WSydokHPpuY0olS5C5HEKw0bCSme1hOLUFqAE+ndNs8J/hWuKBMC/zf3rvP4Pcsl1O9j0PXgb72jD8n/J80UpNhzb04avC8BkCKEyf79XTGfFUAEQRG3l98SYUo4CfpYw6nmhGm+MXKnS4Xg0plxAe8zEBpnMEwipoYpEIy9iAao69HF/V1UjkLEeKKTqvR+o2pn2ju91p0X8+2TY2eLBEvs3EVDAx1JCuG1S6F+zG4Yx8PH192aMH3EeahCNuAJfN8vCBiLwP3P8fZ/7WLPXXEb/pSF834fkfbx6D97Pj9RvOY64SwLuGs6CLMzeHmxyrMgKvwD3J+1KwWVqZrvxSWhKOLeJVpRdGHT6uJcZPGZ+J+xdzJ3wPO7YmI3jVcFgqRXdskRPq72Oyj4rYlgqLW2JRL5MHGeT1AWAL87/Wb/OLghEZRXS3sGsZo+VesTRmcPf63nz3g0Kn5wYiMj1uK6wkOSqVEsiP6QB8qeq9U6NPsgA16QLAf4ZBha1O5Kgj6tNK//pEx5dEY4k+0Ju6kxsVxGCBpnuX1/u72F1om1L+0a4/XtFQ1s5MLKhhK8HzmQGl9bXVpkr6DUeF7QiybAKZo0oSTWIXG4HhhDk+dvxCtcm9+Nnr0vdxfKVURIwD48y1J5BveNXJmNvKf3
 ULvvF6Xt
 h06Mk6qHyeILWRkLPUMSk27YCSGTA7f0BQq3kQdacHotvWk92EuSy/aG+w+smJeXTyWY7ny4eVrr/POuAFyL3o8AyEgKEhVYw/SRKkCpEdpd3YLH6i/jZEVUqHgVghzA2/fGIGPhoPy8eU+28GB4jgrHSMGCXpG44NWDBjwrJ5tI1lvheqpQZ46u042NvwT7wqM/4ucssd4Qp4gfw7vUF4Pi7XORD/gqhwaZu1kbMMvYTehSnGF1lWj9Y+TN+nSalZ3QFtdRw9GqBv0faDBZlpIOV8i+J3eqsbcSK2qH2ZGuGiANCWdQICnZh9IIppTkpA3pgL5b7UMnfj1hkUt0iSsracZ+yKIwtinNpWfEwcEknfCQVTmqD2tPx5V6N8cpkCCUrz3nUZvu3w99IiDxXfW4GefAih5pisC8K+0ImQmxE80kUF9QSeuopwpDZBaKFnihvIsHK0+uXGe/05YB9vDA+0q8GiOTsLTuW4cL5iHDcivkUAEBeM4zPBcYoMaxmGVfvpWVznSAbA3YuWOdTOVOzVt3vBnljXLeHQvqujsjVuXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 5:06=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 10-01-26 16:30:28, Matthew Wilcox wrote:
> > On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
> > > [  872.499480]  Possible interrupt unsafe locking scenario:
> > > [  872.499480]
> > > [  872.500326]        CPU0                    CPU1
> > > [  872.500906]        ----                    ----
> > > [  872.501464]   lock(&p->sequence);
> > > [  872.501923]                                local_irq_disable();
> > > [  872.502615]                                lock(&xa->xa_lock#4);
> > > [  872.503327]                                lock(&p->sequence);
> > > [  872.504116]   <Interrupt>
> > > [  872.504513]     lock(&xa->xa_lock#4);
> > >
> > >
> > > Which is introduced by commit 2841808f35ee for all file systems.
> > > The should be rather generic - I shouldn't be the only one seeing
> > > it?
> >
> > Oh wow, 2841808f35ee has a very confusing commit message.  It implies
> > that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
> > means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
> > all filesystems do use this code path and therefore the flag can be
> > removed.  And that matches the code change.
> >
> > So you should be able to reproduce this problem with commit 494d2f50888=
3
> > as well?
> >
> > That tells me that this is something fuse-specific.  Other filesystems
> > aren't seeing this.  Wonder why ...
> >
> > __wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
> > that spot since 2015 or earlier.
> >
> > The sequence lock itself is taken inside fprop_new_period() called from
> > writeout_period() which has been there since 2012, so that's not it.
> >
> > Looking at fprop_new_period() is more interesting.  Commit a91befde3503
> > removed an earlier call to local_irq_save().  It was then replaced with
> > preempt_disable() in 9458e0a78c45 but maybe removing it was just
> > erroneous?
> >
> > Anyway, that was 2022, so it doesn't answer "why is this only showing u=
p
> > now and only for fuse?"  But maybe replacing the preempt-disable with
> > irq-disable in fprop_new_period() is the right solution, regardless.
>
> So I don't have a great explanation why it is showing up only now and onl=
y
> for FUSE. It seems the fprop code is unsafe wrt interrupts because
> fprop_new_period() grabs
>
>         write_seqcount_begin(&p->sequence);
>
> and if IO completion interrupt on this CPU comes while p->sequence is odd=
,
> the call to
>
>         read_seqcount_begin(&p->sequence);
>
> in __folio_end_writeback() -> __wb_writeout_add() -> wb_domain_writeout_a=
dd()
> -> __fprop_add_percpu_max() -> fprop_fraction_percpu() will loop
> indefinitely. *However* this isn't in fact possible because
> fprop_new_period() is only called from a timer code and thus in softirq
> context and thus IO completion softirq cannot really preempt it.
>
> But for the same reason I don't think what lockdep complains about is
> really possible because xa_lock gets only used from IO completion softirq=
 as
> well. Or can we really acquire it from some hard irq context? Based on
> lockdep report at least lockdep things IO completion runs in hardirq
> context but then I don't see why we're not seeing complaints like this al=
l
> the time and even deadlocks I've described above. I guess I'll have to do
> some experimentation to refresh how these things behave these days...

I looked into this briefly when there was a syzbot report about this
in october [1]. The stack trace is a little different but I think it's
pretty much the exact same scenario.

I came to the same conclusion Jan came to. Copying over my notes from
October: "I don't think this is a real deadlock. My understanding of
it is that the other thread where the timer is running that is calling
fprop_new_period() could only try grabbing the xa_array lock in a
hardware interrupt handler since it disables preemption and is already
running in softirq context which means it can't get interrupted by
another softirq or scheduled out and the hardware interrupt handling
code in the drivers don't access the page cache directly."

It's unclear to me why it's only complaining about this for FUSE.

This seemed like a false positive scenario to me, but I also think the
patches Hilf tried out in [1] seemed reasonable.

Thanks,
Joanne

[1] https://lore.kernel.org/all/68e583e1.a00a0220.298cc0.0485.GAE@google.co=
m/

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

