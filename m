Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE77B606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm2 header.b=pTf3P/b0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=2gJWjarR
Received: by kanga.kvack.org (Postfix)
	id 7B78D6B00EF; Tue,  3 Nov 2026 20:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768816B05B1; Tue,  3 Nov 2026 20:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657926B05B2; Tue,  3 Nov 2026 20:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AED26B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 302FBA0616
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:35:11 +0000 (UTC)
X-FDA: 85395718422.18.3E0D43C
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1205140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:35:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm2 header.b="pTf3P/b0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="2 gJWjar";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf26.hostedemail.com: domain of raven@themaw.net designates 202.12.124.145 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793756109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrCeA0Hqd3kzPVtOoYwsmHRxx4PIWhKMqYln/tuojws=;
	b=aVwVDJrc2NMwevFjzFyyWxGo2kpB3EmkwFqKKJhthdyBKE+COId7wkTmViuDSXP+ISHwHR
	G6rrr8wgWq/4SKkspOmBBc00ZwhPI7VahiR2d7heH/s6S3lSlrxTN4qAJsCuo6jTkodzo3
	nBDnmnSYUZiivD8KJHEPYLhQjd7gE4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793756109;
	b=D/lL/C7sdUYJjJ61VsRb5HRES9WvXMD9OM2y4YZ0buiYwCNk+LBq5+5gUyVaUwLU9GJ7Z4
	DFxYFHQniMjy9Qx2cFEgfCab6feYRs4IFcaZezx8tUm8v4qD+mHEHjanqGh+uWaq5zuwv6
	lH7KNZpwgX1zAt89jwCZzvp+drEguhE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm2 header.b="pTf3P/b0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="2 gJWjar";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf26.hostedemail.com: domain of raven@themaw.net designates 202.12.124.145 as permitted sender) smtp.mailfrom=raven@themaw.net
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 2F7F01D001C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:35:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 03 Nov 2026 20:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793756105;
	 x=1793842505; bh=nrCeA0Hqd3kzPVtOoYwsmHRxx4PIWhKMqYln/tuojws=; b=
	pTf3P/b0NVeUia3wP4piQmr+iXUMn5apqHAoRi5qdpHeGXoAuWaiYn7/Gtm55OjL
	KKMyTSVA/IDMH7fuXspg84fZVCevce32KQh20ZQY7uDPPBVGE7PtqBNp6jPT4CQ/
	ZhT1MbixOOJQSEYFp3sv0kdcq8tIpc/xm3QwFy/Pbix76hVv+XrlCy4kzBPlVDeZ
	VUCPglmyUXP3NhHZL2rnFYfBWriit+r7uKHIa0sYbD0CdrXomeDBCu7z3B+LVp4n
	FKiHOh7966GeV2bK3KEFMPzGET7WhlwSXNv8VFYTzCjrdv4YkAqzMaOs88Zr8uCh
	QqORpgQZzV2M+q515r1a1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793756105; x=
	1793842505; bh=nrCeA0Hqd3kzPVtOoYwsmHRxx4PIWhKMqYln/tuojws=; b=2
	gJWjarRGHJlRgxMFKcfin7DfF+EJoIRFnG4Qt3WtEkqBPGxsQLr446yzS6nYGjjP
	ChnhleRifJbhwhCRbKWp//wWh/cADyzjkHhHV05jshyhmC9Zl29pDnBROSnw3ue7
	lspGwsipjdx2cQ2ZRro3WB+ZhZb04i/Vzf7o0gzjBqlgPGtnFXv1m9sexah0GnxR
	psAUbbXbXuOkFYB9UCaJMDh04rubD3o202nYpdOLgzxuTf2OCDbDtB2ly11e9X8C
	iv+1eckMHAkffmU8lR2cmf4JJ882Pz9fGeMCjvp97zE3Y4Cqji2QqWD/JrLLgrIF
	OaWyxAxWFNoMt8GI+4Dog==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793756105; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:jh3NSSAnZejbCPw+WaAQ4sIVImtS/3dUQU+iTtFxrEszwvZ
	2PA1IAHBmKs0UyiKHV0p31mg0XGF+RHLlrpybGCJjNHq4/UnL9NhMYEzV3ve3cty
	vYSmhJK2bwGiZZgvD9jneAo4L04zlH6L7OSInLozymGXbswyUnC3yGaGOP3BDjvq
	YuP3cFDfEznjYYHS4C5wItYZ8ZcKXVIWDf+HIxuUqNN63xelKVmSxY4e+Ah5k8xH
	vid8900ClaWBe9fBeTq274GS8BykzJk+PonZyb+l3Ib2tIIlKcuNa9wcNzhttc9O
	izeq8xFg4Y/nUV/4xLulthHUPsK17TpYwa1smQA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:JZSYRBJ4XfKKK2c2F966LsA3L7y0qeazKA9dPaqM5cM=:nrCeA0Hqd3kzPVtOoYwsmHRxx4PIWhKMqYln/tuojws=;
X-ME-Sender: <xms:yIvqak8aW8vPP1wYuTZ66-FXE9JchOqUoOVVSM7tlJZ7mdGpH_TJeA>
    <xme:yIvqajqLJEcFCWNrUyX1bDL7F5xyR17ghCWEvdnIgaHcjM9XdivA3OfavbyD8VgS4
    liFw17oQwZ1opRAwYIIkkxl0rNIzqAarNIf1w9ov_Q-o9Hoxw>
X-ME-Received: <xmr:yIvqavG1DHcwBbAdaiwmEThm9aL97Wp6aB6SWZEsAOSj50H8iQR6FluRryywLJL5kEfkPNEApMBaq-O6446Z7zyqDvVFxmEteWqTE5dzu5bq8KjDLo0BpMqHPQ>
X-ME-Proxy-Cause: dmFkZTF+04G1PZLn5pVjkUdTZfXjvyvZ6+U8BNsX6Uz8TcRc7Dni9tGiF8trMZFnpdP36Y
    WHAL+f0oLMU/tIJzmPRU9AUycwgLXwKMpwM7jFAgggPAZBT7SEinY49CDSHBLUZ0duPrOG
    60Hk2CxBQTEF+b0uas6CmNxLaF48T9Cxtd/9VessSqrDrlRugMRTU/njgW67f7ND2p8MqW
    Y09NMG7WMw4H7Y7p2mmxSdp63XKWcwPK3ck3UWp5AtX4jqct0L7pzOwPioj1oIlihAD5La
    KoEOFT8xunxLYwDO6gFh7KnaKyay3ISiJl7StpuFQnbKzeT/4G4nyRUAtSrsRJYR1MGLTA
    +rE6/UCqkXrEj7q8MXO4i/llTiKfX6vggR3eEuXWNwmtNHSJwIYkf9YScRro0S5cdaeSQ0
    bhIV6u+hjNbe1NXBJZW3XsdgEgerqBBB+vGM5nrWDQd895tmhXzgVKVhsyLbrU7WBqF869
    SUuKaGeXkpVuh2JTVKgapzKlNAOyeXhT18ChFXraqrpsVje9DaWMGs7qG/+FCRMvxFzNiw
    5zABJu8ivCSKjcYzjYLzhgicApQpftUvcizSU7TCplIlaRJ+GQUlJkR9y8cIsaNV/IpHmu
    20S9LU4MNblqdmiYRMA9KfjqlE5IyOOQbG8Bw+K4F20VV2CcQ+czVzf6bTTg
X-ME-Proxy: <xmx:yIvqark1wviiPfMu8HYNEWnOToeqrhsKrOXTFBE99yWAUi3eRgCiQQ>
    <xmx:yIvqaj8K4HXatZ_JQ0Tckbw1w6GV4_ToSJ8zZPEbihmhQDZn8GJ4ng>
    <xmx:yIvqaknOfgp_nNrncPU6STsGJR_9-dHlKgaR71KrKP3nGpbNFrVfSQ>
    <xmx:yIvqapmz6xFiMTnO8t9nGJXF-bbdQGteWI51Dd5So6kaCp-56EJ68w>
    <xmx:yYvqahZMBV8w9xZ8JtI64350QsWdvRuMHUA1Tghdr8XHsDRzO5N_Li-L>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 20:34:58 -0500 (EST)
Message-ID: <6ca657f75453ddf7ccf3acd608cb1794f2c937d4.camel@themaw.net>
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
Date: Wed, 04 Nov 2026 09:34:55 +0800
In-Reply-To: <5f659257d9842544d6830f9041e5ede63416d214.camel@themaw.net>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
				 <cover.1792577179.git.krystianmkaniewski@gmail.com>
			 <dc65c28e408d6b64d4b13b7ad30e5fe70ddaa441.camel@themaw.net>
		 <4f56c93a9fc5fee152364974773df0a319c84af9.camel@themaw.net>
	 <5f659257d9842544d6830f9041e5ede63416d214.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: fu1g91oujd7z7yfo3sd3ai6jn6zrgobb
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1205140003
X-HE-Tag: 1793756108-800709
X-HE-Meta: U2FsdGVkX1+fkSbOyxjwR0U66I0xCu9ZLh/7ERIY0Fn94bN3MVxtrkgdgiCwcBSGDCRce9bdovkjb4CW4seG9+AG708xI9T19af17kjheO1GBWBgx1NK3I4YJYuptXYzwj9JQxdzEFtWP/V44609L8IB/mW0qpii42zwX5J7BvilkNkWsbIcq/2pJZzQVHrUUziriyuXRusguGYArZVgBPwQCuXmY8J7hDrQiSUhmjkv77K6yQr9gIhWG5S2phL98ZqhRGEa08Q8MjYeVDBoEYOMCxJ3I8PUwI1Pes2bJXPuO08KgjMDf+UCRVjkDWkESmMV9M71pHsCsTkxDLHfGKJRgPYhA73VqhypoW+Dh9ULXDoLcwrjeSTyzfYetMxBngiUMDOTB1aaJvPODqpTR71noOPpGWzEWyiqHhrazEnZYv3C8xH6WunNXD2xsnzV34u4IeM7Lbe8tiMhHQTq9HBSU6Mur1fJJs45XtscGwjL6teVjdsixzBhFXBJraoEiVhPgY5VBgn5yEcOpixPxka/YTdNYpDAJwfmHPfVz649M+DlK7W06beZZlRX8lHlTjaobXCGMytanGvUM1aaD5gZORuTkqvkRyjVJZdQZpQfE/RtllhZBoIlsozBO7KI5ENj6nCiuwmwNcSMXWYTcj5zH2BjPjz2NpACB2a6Y9PiZ9ut2HrxVEzpI9CDS7cp6OqdTt/ZDMqPIM5eOn6KgcVP1Q7yOnY/pDjO100hQxrNLKJvxMK2U//zmBDVh2hAj8BopebejO02XFZlAb47LC4k2f9wuhBsf+BjzztJbCRQiqQqHfe/KYkcmdkEKIzA11f1Qsyw4gonqao688vHMy6sENBuuKgi2oPVwX8hXke3uzvQiGYTsj2VcV3rz27m6vj6KdMPOxyYB3KT6gT/rwbe2zvpY/J9cXEjk5MYIu9dXCyULjp/XnEFLmMlDaeYuqjuPv/xMK7N25SuW9V
 Qw5fkkbu
 6ToH5YbDSiRl2avmtL/VZk9mKrVjX4BDNf9ko/W6SaDF0IZ+YM2fFcff38iroAG76fv8CgunvrdaycKxvvh4U8tWNByR7zBm3kGy9AwUY8aHOhP9naawKdvxTHkrAW3NqaZDXyQCO6MWdJ1Rt73nOCEU0uoYKgUAzPpMA444M6Kx/RPibGPF8qNPy839fnito56lm2zdMTOY5I2bd6eH0QtYQjihyLI8hUWSAIMu0jFDX/EOrEh4pZth9eSRQ4UmhDja3e3xQWdOe/T72T+lVzFKqcHDpTnf5bja42lApriQPZsKAEgNTDjbY5DObqRXAjDhqO4opSIHJUojLx/QBVMFIAGrDysVPcTRbJlZyf+SsLKasz8MBulcZd9j5aADxQ/rwcUERY6Bzj+wDsSakJ3LklU6XfjylC1RDxvnylHu4TNuO/k3Qb70tCM/CkUuUPVNC6tAva1CSrQlbZ35K6d9+KpbpAWz4qHT9C8cPNrf1xPVbKQOjWMmV96aONThnfyZ5L49u5YDPBgQtXZ0OZfr+jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 08:46 +0800, Ian Kent wrote:
> On Tue, 2026-10-27 at 07:11 +0800, Ian Kent wrote:
> > On Tue, 2026-10-27 at 06:07 +0800, Ian Kent wrote:
> > > On Wed, 2026-10-21 at 14:51 +0200, Krystian Kaniewski wrote:
> > > > syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
> > > > &sbi->pipe_mutex. splice holds a pipe mutex while it calls the
> > > > write
> > > > or
> > > > read handler of a kernfs file, kernfs takes of->mutex there,
> > > > and
> > > > a
> > > > write
> > > > to /sys/power/resume looks up a path that can make autofs write
> > > > a
> > > > request
> > > > into its daemon pipe and wait for the daemon.
> > > >=20
> > > > Patch 1 stops holding of->mutex around the ->store() callback
> > > > of
> > > > regular
> > > > sysfs attributes, which do not get the open file and already
> > > > run
> > > > concurrently for separate opens.
> > > >=20
> > > > Patch 2 handles the case that patch 1 leaves. A store called
> > > > from
> > > > splice
> > > > still runs with the pipe locked. autofs no longer sends or
> > > > waits
> > > > for
> > > > a
> > > > request in that context and returns -EAGAIN instead. A new
> > > > mount
> > > > is
> > > > refused before it is marked pending, so no other lookup sends
> > > > the
> > > > request
> > > > in its place. This also removes a deadlock in which the spliced
> > > > pipe
> > > > is
> > > > the autofs daemon pipe itself.
> > > >=20
> > > > Patch 2 changes behavior for one narrow case. A lookup from a
> > > > splice
> > > > callback that needs an automount fails with -EAGAIN instead of
> > > > waiting.
> > > >=20
> > > > The series was tested in QEMU with lockdep using the original C
> > > > and
> > > > syz
> > > > reproducers and focused splice and autofs cases. The target
> > > > reports
> > > > were
> > > > not reproduced with the series applied, and the paired
> > > > functional
> > > > cases
> > > > matched the unpatched baseline.
> > > I can't seem to find a reproducer that reproduces the bug or
> > > maybe
> > > I don't know what to expect from running the syzbot reproducer I
> > > did locate.
> >=20
> > I think I have found the appropriate reproducer, certainly looks
> > like it.
> >=20
> > Commit 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev
> > in resume_store") looks like it's been around for a while so I
> > assume the reproducer should work on 7.2.12?
> >=20
> > What should I expect, a hang, it doesn't.
> >=20
> > Also it looks to me like the reproducer is trying exploit an
> > invalid request similar to what I described earlier but I can't
> > test to see if my simple autofs resolution fixes it if I don't
> > know what to expect from the reproducer.
>=20
> Further investigation shows that the reproducer is initiating path
> walks within the autofs mount it has mounted which is valid in the
> sense the autofs file system will attempt to send a request over
> it's pipe. These are not seen as invalid so I can't prevent them
> in the way I thought I might be able to.
>=20
> I can't confirm there is a deadlock, how do I do this?
>=20
> A little more validation and I'll be in a position to review and
> probably ack the autofs changes.

Sorry for taking so long getting back but I'm struggling with a
few time critical tasks (including this one).

I haven't looked as far as I wanted to yet but I have looked at
the autofs patch again mainly because it occurred to me that the
EAGAIN return might be a bit of a problem.

The expiration of automounts has always handled EAGAIN returns
even though that handling has changed over the years. So this
amounts to little more than deferring an expire which is fine.

But mount requests have never handled EAGAIN and I'm pretty
sure this return will result in an unexpected mount fail being
returned to the requester in user space. OTOH this deadlock
case should not occur very often and neither should the case
where an automount has expired (so the mount has gone away and
hence a path walk initiated) but the automount daemon has not
yet finalised the expire by notifying the kernel.

Also I still think the scenario where this occurs is something
that will not happen in normal use and would most likely only
only occur for nefarious purposes. For these reasons it's a
little bit of an open question whether the autofs changes are OK.

Updating user space is of course possible but significantly
difficult due to the number of distributions that would/may
need to update the daemon.

Another option is to handle these EAGAIN returns for NFY_MOUNT
requests in the autofs fs itself by re-queuing the mount
request. In fact I already had a patch series to do something
very similar to handle stale request entries after a "kill -9"
followed immediately by an autofs startup. Sadly I got side
tracked by overthinking what was happening and reworked the
patch series considerably and had not tested it at all. I'm
pretty sure that a recent contributed autofs patch will fix
what lead me to this diversion and it will take a while to
recover the original series (or re-write it).

Ian
>=20
> Ian
> >=20
> > Ian
> > >=20
> > > Can anyone help please.
> > >=20
> > > Ian
> > > >=20
> > > > Krystian Kaniewski (2):
> > > > =C2=A0 kernfs: do not hold of->mutex across sysfs ->store()
> > > > =C2=A0 autofs: do not wait for the daemon while splice holds a pipe
> > > >=20
> > > > =C2=A0fs/autofs/expire.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +++++
> > > > =C2=A0fs/autofs/root.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 28 +++=
++++++++++++++++++--
> > > > =C2=A0fs/kernfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 52 +++=
++++++++++++++++++++++++-------
> > > > --
> > > > --
> > > > --
> > > > --
> > > > =C2=A0fs/splice.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 13 ++++++++++-
> > > > =C2=A0fs/sysfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1=
8 ++++++++++++++-
> > > > =C2=A0include/linux/kernfs.h | 11 +++++++++
> > > > =C2=A0include/linux/sched.h=C2=A0 |=C2=A0 2 ++
> > > > =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 1 +
> > > > =C2=A08 files changed, 109 insertions(+), 22 deletions(-)
> > > >=20
> > > >=20
> > > > base-commit: 93f51579e7df248780214094418f205253383cc5

