Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE76606A336
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xh9t4AGi
Received: by kanga.kvack.org (Postfix)
	id 82B126B05B0; Sat, 28 Nov 2026 04:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBB86B05B1; Sat, 28 Nov 2026 04:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3786B05B2; Sat, 28 Nov 2026 04:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADAC6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:58:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD4541A0609
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:58:22 +0000 (UTC)
X-FDA: 85484077644.08.4B2B8AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3085B40008
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:58:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xh9t4AGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795859901;
	b=zAkgPsBi1ifHC6Cg9aO5991acKsqU6O1k468YiayAUFg8dAVBTcYJUroRITow9RqL2jWvS
	9mY6ADMNvcXxSUXPmpxBdd8tpaQAZkuQrHs2UvEpa6/kOFsioBD4YVgULuUB2eCVYHXrBK
	2dlTEZkpGeZLrKYp+Y4BePuG2pP+ks4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795859901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gypr9ixdbwpXyRQHyLVcFcYrxT1qcpmfLiBbRjpRDO8=;
	b=B7+HFxBFAJYzES5yo0czMOBdAkAM6s2S5N7wULjD3JV0/jDu7uEyRgRhjfRUL2D49n7U/w
	paLGTJQJvGi24Z1FtUURBJo3muub8yMug0FYyJLNyL40wdea5K1ckOUa3KKWPNdaMM1vbU
	HqREKYRFHh33Sktft+MavhYNiSa0I3Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xh9t4AGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id A384E60E60;
	Sat, 28 Nov 2026 09:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 65CE81F00898;
	Sat, 28 Nov 2026 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859900;
	bh=gypr9ixdbwpXyRQHyLVcFcYrxT1qcpmfLiBbRjpRDO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xh9t4AGiLURm38vb2SU1trvChHI7gbr2j2mr89kBMmMObRqPqFb31H/Df4kMoB/QE
	 DTFrZCWcUEejYMMyf6uta0gZ1r5vlFftz5vvG1cN/u5TrwQsJYlqCJQy3985JyPZXl
	 apHx6xspTchoq4W7I8KvgHK/Hyof2wsym7vgH37qxLOTL5W1cWYCIhFm2lyesYk8R9
	 Kp0flMcZ/JKT9hHiBRBpIy3ZI+RZWDyhlwPP4rXzSm7o1dCytu8uI5iSFUHRj8LFZW
	 IVo4JQQxND28kNGxFoK6c4cDpAug7siQfOYddho75iEl1+NIV9JjSbrMQzX+NeACTy
	 NmQ3tcw1clb2g==
Date: Sat, 28 Nov 2026 11:58:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awqluHWbXWeNvUeS@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
 <awqkft-e6Tbj7dbJ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awqkft-e6Tbj7dbJ@kernel.org>
X-Rspam-User:
X-Stat-Signature: p345cmqma95a738kaiymh3dmqcfmyzhd
X-Rspamd-Queue-Id: 3085B40008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795859901-690973
X-HE-Meta: U2FsdGVkX19X5GbxvkRNsRCtYdx+YHokCKa8hEPBfMr597GZ0GSOOrRU3lUQIuI3ypK/e7yu9WsOAfJ0tVk/YM4IZSBmr6vBKC1q78GhCkWYPiI4PH6dhildsE5JKACJF+GMTvaYubFnb0iAK8rkKuuaQ4ef7vVlDsXAp4v9HZHSrmAWvtslcI1JOw4KrRwwzD/EebKXBK5CYoaKq09J6v6wDyBODW0u2H8wE8mahuMBWMP9oFxMgcMEjI6yuA4h22zwlL3nasV0KkRZkCEegUK6G/l4+eYWqO/WmKuM+lEmg+6iFU0mJKwOMo4i78/LC5wm4BiMSwqymyc40HzAYF5gyAU15kJzOPU9v6aNzyazRKGLIugWtjXyqssP5C/3bgqOaBi1/U55ZYlz7+xsgKbj8vWsjuLQtVZGVCixoR/ALpJQq4c+xKjNkN/Vi9bw5MsRfzE8Y0dJWGvJfkNv3jWMgRR4PGPf8nHmb3SY/O/25Qm/ZuhvjQlvrpLE8vCoTIEZi9R6etW5lQhl+Anp+RBsTLpaZ35whc6C2nham75w4QDymfQ/j9bkGrCBaz48SJGMy9IM15pl6RswxtnEPvYqRXQtf/6ixEtoIQYkjDAJkqaxUlhoN0TI1DNlSnNgV+IArq141E3pRZmrtQhj5KEOto5+eIP8fBm6xtT7ahk/seaXpxQdp2jtyToaC7XoQM0kbKtVUAf/ek9D/2XwD+jbKzjhD8dpXEBHuU383aVTWAAtEgH0b8Gan5chufiUDII4NDqaLyOy8B40oH3EQeuJ5ctTof3gX3oPslF/rO8wfGuFzW51dfW+9M2+bc9XRQ8hvp1iKyzjuav08T8qVx+jzmeNfPBSGWpDAg8JSJP9gdLOmAcHsp0ikd2NykDxhK9EkuiKVW8lrxLSG3hGfEKPt9E9Eo7CmgmCTArShzWEtwXOLGFj/3xULb749x1Axp4kGhgnHUvWgtiWLZk
 VBjJII4m
 GLRjv7jqWF4T+/xCOIyckmBOkJJJZspS5ZW9Qsjk+0qFuj/GX4eeSfR8oqreag2wX1QhhZHGxEcJ4Kltjme15U/Dr5g/OX+I3SS7UzIUjJAl3mRJCmUHXSiaLuXVkfX2WG8m3WwgDf1AcAzQb3s+MY3kGVxYq8k37ZzaI773q5Df3gXWHCYyO4L5c+jm9VCVwm6XlSCrVIJf8PWbtqxc+baV+rRgTrVBRp2YNwY8tM4rFSwKCnhxRGNtTHBc8/865TQzj6OUwZhm+fxjsz14SwoSevf50pe+YNDccCkEhUmaiSidvwo5fNJx2xNPDEl8zRQf4PBYH9XlPeMHTmG8DTJVeznIUjbq8+S6TQXUQlpDd7/PHMg43SS16q0krzz5MZJCGIWe2wevXMJ6Tx/tA/QBgwQlBnSm5rfsppIUPnq2cELoUhugEMFX9x0AE9VeE/OyYdTxODfE7UWpap7p5WK8jKn1l50sOX+wSWS/iHKYeqpyemIdlJm+tSVOTnIDWv4BdkLTzf5zWR3KCyal2ZpY46OfIccN8SXHgqr8NL4I+QhetqppIkfUk+1DzfD0ob8PsoulLIN6k+ufjGZn4fi8qDBDyIuIQHJwdfkmG79CyZmkQsKmtQPjn5uTblu3z0EeS9cbzS8dznVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 11:53:06AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> > On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > thinking more sequencing than data structures. I.e. I have a game where
> > > I need to end up to process creation without embryonic state, and add
> > > just enough weight to kernel to support that outcome, and that leads
> > > to ~2K'ish LOC of extra kernel complexity.
> > 
> > So you don't have embryonic state? I don't like this.
> > 
> > Let's assume the following situation. Userland's PID 1 is already running.
> > Our container manager attempts to spawn yet another process into userland.
> > As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> > and then execve.
> > This creates time hole when there is process, which already runs inside
> > userland (i. e. its PID namespace and other namespaces), but runs
> > container manager's binary and have container manager's mm.
> > This invites for bugs. Other processes, which already run inside userland,
> > may somehow take advantage of this.
> > For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> > Privilege Escalation to Host Root"
> > of https://brauner.io/2019/02/12/privileged-containers.html .
> > So, here I like embryos.
> 
> We all have things that I like but let's talk about facts instead.

I mean just saying but wwanting an embryonic task state in Linux is
backwards architecturally for any possible topic.

Br, Jarkko

