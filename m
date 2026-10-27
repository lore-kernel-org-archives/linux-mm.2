Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A9A606A339
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm1 header.b=UxTW6mCE;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=xZR0i/gU
Received: by kanga.kvack.org (Postfix)
	id 64CC86B05B2; Mon, 26 Oct 2026 20:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD076B05B3; Mon, 26 Oct 2026 20:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514506B05B4; Mon, 26 Oct 2026 20:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A42E6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:46:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65A101A081F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:46:30 +0000 (UTC)
X-FDA: 85366565340.02.439B767
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E6C520006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:46:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=UxTW6mCE;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="x ZR0i/g";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf03.hostedemail.com: domain of raven@themaw.net designates 103.168.172.157 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793061988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TP9+b3dz2+4Q7H6ld5iqHqm8/GcbXcvCr+9OqxIm31Y=;
	b=WEqQXVSiPhe52TqEWdnsdaLh1J5ppw5JkBiP8krtnH7e7o37akjYHSkwRghakDGk9DTXUW
	4C9jrTxsHdW6vs01q4iPtvlohHLkujwpoYFdkhtiCwZ4fnd7vW3WOPSQxZ8EQDseskle7x
	lb+3o4arzkKC8CDtWDtu7v4voCcXNWk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=UxTW6mCE;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="x ZR0i/g";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf03.hostedemail.com: domain of raven@themaw.net designates 103.168.172.157 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793061988;
	b=M1s0Yy1wBeJW0wiNeql/eolAWr4rRrPlQesyfCMe1B/kqhBx3qQ/J+sANOxv2CraV+LWqb
	DTXKYlSzKqPpXG3bHK7NeDBKA00JAvRcESHExqIVCLhZHcJNOnfm2DAptdJqafiNZ2vf4m
	yshETcYvfqwV2K+EZPo8IHJ6/L0DHBM=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9352D1400984
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:46:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 26 Oct 2026 20:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793061987;
	 x=1793148387; bh=TP9+b3dz2+4Q7H6ld5iqHqm8/GcbXcvCr+9OqxIm31Y=; b=
	UxTW6mCEmOrL9tmWKiTyP9zg4PXGlSKIcS3rjPV02pATPJi2m9tg6qzD7TRGbSjQ
	XNBj2yuiDuJUVhLnGIWg0N9kd5i2RgUCU5JzadFcjoNQUmQAF+IRe1fUvdb2PDK5
	vM0CROg4r9CiQLG5qCO3jIgDQ2rb6MsAktL6Y2p9huuiuge5juI/UwjFEKNw/yI0
	l+uVTvdfSlDtwrCTc60f/FTTnPlpoK/bDUKzAZDxuxzL18WhxKE6LoObkhr7K4kE
	Z9aFyrusk8Mj0oTqMkaHLwg7zqItTNrn9TjjgoJ25iX56cYt8cSkC9J1eYDfY2Ky
	sEFVYf88kJjbND/igq40FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793061987; x=
	1793148387; bh=TP9+b3dz2+4Q7H6ld5iqHqm8/GcbXcvCr+9OqxIm31Y=; b=x
	ZR0i/gUvbAqxRyUSV9Kgn8QJrqRByiGP5Gi0ERFiVMZUrgsd+2USmaFGTulU9uP2
	OpjqLI/DsYLlOEPpuAUgI2imoY0m6aTbkSDuftJCs2bMHN3zn7Nae4GrIDtbnlHT
	EkhGZWc2oroRCKB0dviKPn8BkPHh3JhVjtwehVl18kJZmif7l9pm4xh41IUoOE6r
	NRpCGtLVUV/hnzZ45WU1tjZgtbLQcMv95xEMqkX0df9EVD2SqVUOeHH23wiw7Ebp
	eUwBMk67W2tRgCwZrNWwCypMU2Q0VMXBggvg2NL+x7SvIL/VZmamU9CE95JTGQPO
	br1OMyhbMR3SBwpM8ixCA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793061987; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:Ub4XhHfmZ5YgwCSzTeEQHroBs/EEd4x7tWAezwqCVJMPRJk
	k18yVPjZMkAFYfKCfgNYQeRl5STMzbGNFi2n6PaEhO7BWacE9oX6H32oDnjgGfEa
	S4uAUPaLSDWXyiadhIs0gNdKGoRmukp2ltUziFjdYoLdMOGcETHTfLZzzHJho629
	PcOcd6Cld93tLBhpvlPBvtqZQ79c/6aUJSzih+hZnQ6rlYgmiMO6p2Eulfbm6N8c
	ajBllIs11TKtYeUuykdA4O1O0VElx/z9eQtSjypN+ZN6XkmomdQKeH2MxPEaGJya
	wWWIZLIv6wfE2th/JT6aJ95O5SXn9OHMQcz+wzw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:4qMMu4/ztaxOQhducCNzbeW0mL5tE72ku/wze25LTrk=:TP9+b3dz2+4Q7H6ld5iqHqm8/GcbXcvCr+9OqxIm31Y=;
X-ME-Sender: <xms:YvTfamEz77wskH6eHohuFKKJM2t9lP6I8JCeOLkIJFTD5CDTgm8Wtw>
    <xme:YvTfauRjUeoE-i3N4Ef6HBWkI7L7F4jdiChUHApslgFGkNgDEb05lmMsRShFoc-Y1
    NPU_7Xsu1rGFyW3CujYLLaBbzbKH_ugp5RoDJqfRYxqaqbLGQ>
X-ME-Received: <xmr:YvTfalOyhWTbiPkS-wG79y8dAljjvtNHp9hl2Xy_MoGRUELhr40dmdWxaM-KRetOTc16wIbybrwFyjyFhoGDnNSKweUSypc9LPzcQ7Aeeyph_5RLTy0Yt6_BO2M>
X-ME-Proxy-Cause: dmFkZTEJ5GJouwgJsfwUbfVQZ7sManMuXNYQq/oXjCFQW4jHTYsjQ4ZXBNT4Qak25Ao3Pn
    CU4aWQsUwYQNoxLqftSX7fjbq4IulVn9BPbz2AXZAF5bavY/EpL3IfiE1OwS31FQ5x+HjD
    fABqNfIkYIiP90sWSbpLjCiwih4Tu16AgHqokWCOGaxB21hUXOQWhzyp0vmOFbmLX/ojWQ
    hkLkExoeSl8f5icBMLuE1/F/W0QfEFO26C1SCQO8vLGt7TB69pA4km3uoZtnLjTv39hXK+
    QFORjWMaYV+mrD8g4+v7drAOWFGdWqEo/5is1Ck5pbO0sty7+PPHvbPtN6bFvQzDQ6+OPM
    9oRzX3XaQfyo3dtGVQSbzT+yoe5fyXONM33TUR9ZN4k/uU2gYyTLRxuO44mAbXwQi4ybWM
    02fMBrMVewYyAM7zYnsldkh1h0s/iXDISdZDApbs5f2ne5VY4Lp5XMklLIoOlauZngwSo9
    AxSd4L71/CwN0D+GxaSJSTsC4Vvr8dZHBdpTFlQJdk/dNjXeN4MAPGOPX7zMY5F3bwuSsJ
    Ca/KrUjwzRaK6XTf1jJVKr+HVV0ylTSAE79y4+TweSE7n6IDaE0+yP4gJ62faF7nbjD9+i
    ihuXrhUe1EM1f9KejIJ3N2l2DNJvDy4qNiBAes+TnK+r6IXn14auOJ/NOb9g
X-ME-Proxy: <xmx:YvTfanO3XW4oXN69GKg3lRp6pFv3YZHjb7GjxRIqjA29ar9feIAUGw>
    <xmx:YvTfanFiGyN7RfNvX_5o6tHS5xZ0QyJ3-cLF9hapL1Em0ORi0T9-cA>
    <xmx:YvTfapNHGMg3OOkvaBtlk-pMPDNuRju8ZKQFHwhTqtwpgKRzozQ3xg>
    <xmx:YvTfahvUdKvJIYQ_9ADPwao-mC-zIMxwBE-90YEHJ7tF2lv8_b7QvQ>
    <xmx:Y_Tfatdzx2UYjyTL5LgVqt1RBPRO3mW6oUw82z4c4SFFG2jJ8UMvT4FL>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 20:46:20 -0400 (EDT)
Message-ID: <5f659257d9842544d6830f9041e5ede63416d214.camel@themaw.net>
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
From: Ian Kent <raven@themaw.net>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
 Danilo Krummrich	 <dakr@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner	 <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jens
 Axboe <axboe@kernel.dk>, 	driver-core@lists.linux.dev,
 autofs@vger.kernel.org, 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Date: Tue, 27 Oct 2026 08:46:17 +0800
In-Reply-To: <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
			 <cover.1792577179.git.krystianmkaniewski@gmail.com>
		 <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
	 <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 1E6C520006
X-Stat-Signature: xrmajeydsnqqw943o5q6wepdc8taz38b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793061987-866511
X-HE-Meta: U2FsdGVkX1/9zHuiQYLU8DCeX3llGle6JI/ATNGXv6966B0d1ENhnK31n0XKrTbmi9utk/fRnEyCSjPyzCNQIu9DUrTWZRgxIcIWedVlElZI1Lpf4du4+c88ZGCf+6wI9ukOIdq7vyp9zeje/K9Z1qxWwZ6i1RZFbUPFy6XTQGv9RAq/IEhFWsfd1eTeQPf1BB+XD71jv5U5ow9fJnL7Bdeqp+5oNThh06LfaKpsUq1IBgLgSIJ7lbWbNU2/uwAn/1bs07o2ZppaBPtcclVVN8Bc849ubP8eanyUgBfR51jw60F4gi6WGyHZTfDooaiBt5WNLg3xlW3IbuNL3tlYca/n94OUDlyRFFuM1F2xBvkWigJNN3Bhr7dTlomcqAhQRx2NdAZIy4tAQJtOO6v2dFPXOgO0pfId9zWJcZI7gSnnAlgyqzzGu9CUhgkTjPrYjOYRVAnlhDqYD89PvCQSoGovOzN1fMBptDKwzuWZEytwoXT0lavCylK2ae8Vv2MCTkX6Ip98Lu1nokW/uRPFHckcrQr0c/sWRMlZPWRFfxLW0T6DL58xWM3z6+yhP/eLUVaDjCIy2aaQi3LvYM2dl7dwfFea0tWh8mO4V0ruPu663a6z9Ee/zpEg5ggLXGfThJvpxWd5rLODHHVIH0BvCiawY4zDko670mnjSso+V2eWOYrcJIV0XZtiNhMWnHrAi3gEKEI8Dx2J/UZYOumwGTlnukIKpxwZ5G6N4WVoyWTdagrw2/6B5yJCbfhXyAbl7K+XOkwaXOeDHhGNphz7vqrRCgt8iSj+J3t1dF4NDsedvX+HNx91WhQ+NHZjaJwQTGltXHbjYo5wfm7g89p5nq2FWqx9hBm+yOH7uPy96COjxcAMjhCsMZhBDp5PRIl5EL2Ddl/i9cpU6ak7Td8K037kOK3ecC8EdIGTTioI0lXu9O1EZ9rOOLqnwnBpFYI6sHPj4uyAiiOI4bJYqkR
 5V83H4GS
 Gbg1Ju+1lTrwuu6bXV4MkoekMUGkhHmcXc6MwC9bSXsI3kG6IULU86tLEl4zhp9lOEbhMbiWdS037YkpRBSLPWCmwXr5f37z2DrRuKp3yfLtBAJ61xJ60rM4xMzdHD8AShToF6vRre/I+FeJtiw3dSTJm4jPN3ZyXsgq2i7KULWpJxbt9eti3J7ZXNzpqmwhjqzz7DAZtT8WdxllgUv2WACYc+MaHKgXjUqwraSu6hiS5x+l8yaO+Eeqk2HJcCY5haU7Wiw7eBs9MUObe56tVsotc2IXTqls3R4OVVEMY+lFnUbPKdsuHCyvdYNcqCp5xclnHodD3aZkvCfCz1msEUFwwsnwXViBJ0rqTvllQy3vngVKLcqBJbvkvW0p3eurPtRrkvkI1mk+Yr3WS459CDExkppBiPF4+Sp5GuBiiX1J7XxS2Mffkeg3YCVEKhCs8UM3jO8aDp0ERGPIqXT7/135j+kARiMRhY3W9YPP0l+9cfmzf969ruwO45TTYV18I+DpfmF7MNAFgfJG0Xxh1m1w0GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 07:11 +0800, Ian Kent wrote:
> On Tue, 2026-10-27 at 06:07 +0800, Ian Kent wrote:
> > On Wed, 2026-10-21 at 14:51 +0200, Krystian Kaniewski wrote:
> > > syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
> > > &sbi->pipe_mutex. splice holds a pipe mutex while it calls the
> > > write
> > > or
> > > read handler of a kernfs file, kernfs takes of->mutex there, and
> > > a
> > > write
> > > to /sys/power/resume looks up a path that can make autofs write a
> > > request
> > > into its daemon pipe and wait for the daemon.
> > >=20
> > > Patch 1 stops holding of->mutex around the ->store() callback of
> > > regular
> > > sysfs attributes, which do not get the open file and already run
> > > concurrently for separate opens.
> > >=20
> > > Patch 2 handles the case that patch 1 leaves. A store called from
> > > splice
> > > still runs with the pipe locked. autofs no longer sends or waits
> > > for
> > > a
> > > request in that context and returns -EAGAIN instead. A new mount
> > > is
> > > refused before it is marked pending, so no other lookup sends the
> > > request
> > > in its place. This also removes a deadlock in which the spliced
> > > pipe
> > > is
> > > the autofs daemon pipe itself.
> > >=20
> > > Patch 2 changes behavior for one narrow case. A lookup from a
> > > splice
> > > callback that needs an automount fails with -EAGAIN instead of
> > > waiting.
> > >=20
> > > The series was tested in QEMU with lockdep using the original C
> > > and
> > > syz
> > > reproducers and focused splice and autofs cases. The target
> > > reports
> > > were
> > > not reproduced with the series applied, and the paired functional
> > > cases
> > > matched the unpatched baseline.
> > I can't seem to find a reproducer that reproduces the bug or maybe
> > I don't know what to expect from running the syzbot reproducer I
> > did locate.
>=20
> I think I have found the appropriate reproducer, certainly looks
> like it.
>=20
> Commit 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev
> in resume_store") looks like it's been around for a while so I
> assume the reproducer should work on 7.2.12?
>=20
> What should I expect, a hang, it doesn't.
>=20
> Also it looks to me like the reproducer is trying exploit an
> invalid request similar to what I described earlier but I can't
> test to see if my simple autofs resolution fixes it if I don't
> know what to expect from the reproducer.

Further investigation shows that the reproducer is initiating path
walks within the autofs mount it has mounted which is valid in the
sense the autofs file system will attempt to send a request over
it's pipe. These are not seen as invalid so I can't prevent them
in the way I thought I might be able to.

I can't confirm there is a deadlock, how do I do this?

A little more validation and I'll be in a position to review and
probably ack the autofs changes.

Ian
>=20
> Ian
> >=20
> > Can anyone help please.
> >=20
> > Ian
> > >=20
> > > Krystian Kaniewski (2):
> > > =C2=A0 kernfs: do not hold of->mutex across sysfs ->store()
> > > =C2=A0 autofs: do not wait for the daemon while splice holds a pipe
> > >=20
> > > =C2=A0fs/autofs/expire.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++++
> > > =C2=A0fs/autofs/root.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 28 +++++=
++++++++++++++++--
> > > =C2=A0fs/kernfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 52 +++++=
++++++++++++++++++++++---------
> > > --
> > > --
> > > --
> > > =C2=A0fs/splice.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 13 ++++++++++-
> > > =C2=A0fs/sysfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 18 =
++++++++++++++-
> > > =C2=A0include/linux/kernfs.h | 11 +++++++++
> > > =C2=A0include/linux/sched.h=C2=A0 |=C2=A0 2 ++
> > > =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 1 +
> > > =C2=A08 files changed, 109 insertions(+), 22 deletions(-)
> > >=20
> > >=20
> > > base-commit: 93f51579e7df248780214094418f205253383cc5

