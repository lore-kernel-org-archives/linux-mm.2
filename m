Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241C1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72666B009B; Wed,  8 Jul 2026 05:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22D06B009D; Wed,  8 Jul 2026 05:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECA96B00A0; Wed,  8 Jul 2026 05:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A12C86B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:14:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15A9516927E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:14:23 +0000 (UTC)
X-FDA: 84965048406.10.9A7754A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D924180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:14:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDfjEVLN;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783502061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXXHqKxP6hZn4M2zHTw2/0ZaLNmtz5Sx6sgLJ6b0uwI=;
	b=zEBVuJIofpvXKUZkEcvlSrR7p2NxWHeFlqMdL7z7B5VT/wwG77051JpVX6Rw33TxHmfwqQ
	4MltwDZWgdhG+lRP0GBJ1KiOjoTsIeuGj7mg4buzSTI/qPYZF40XZb5XA0HMmwAw+eY2QN
	BMfQ7/Z7S8caZ1JX9p8O8lghmIg6Lxo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDfjEVLN;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783502061;
	b=ASu7Vtw0n/u0PqwhYZQluJgSp2m+2nnstj4ZDEnUs37xIGUQVGjltAahJz4zzb9bO86Puj
	SrFO2q4Vw1D2VIyISR/Wcp2gtKHCDZzZCxW8hbvrHdgJ3X26c398pwnA3v6yTP1NK0O3ME
	3ucp51ValCITgtBtjNNzd2ipi55VbNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3BED6001A;
	Wed,  8 Jul 2026 09:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511C11F000E9;
	Wed,  8 Jul 2026 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502060;
	bh=AXXHqKxP6hZn4M2zHTw2/0ZaLNmtz5Sx6sgLJ6b0uwI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SDfjEVLNuk28Tl68PJynCZdX2Kqgk26eXL56PM60LwXTOto0CWSTAjFNmFJ1ICrYq
	 vqKrIquj1RTSThYPAkkuZKFMEJJILzNSscRunJ+pgIFSSh08YkyGtgsH+nZaKdzukn
	 iMDAjHrz9fsaEewNzgyTNI9QMu4QTS+qbl27g0QQgeEfdyLidSY4tBRWjVFvII4m6L
	 Mg/MUO6Uw6puC7rRRegBzohlNiUOQs2CdfsxP6+YUfd7hMmehUFo1qX1cTgCMUcWIL
	 wqzswdBa2dXxFUhqGkvLSZImHcXAPEpFi5jpruDOtR2AEu7JW3YD54smjQflkIk7t1
	 p8lCaVreY3Ppg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <DJSPBVXTF02G.3SKLB9EO89GPT@gmail.com>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
 <DJSPBVXTF02G.3SKLB9EO89GPT@gmail.com>
Date: Wed, 08 Jul 2026 11:14:09 +0200
Message-Id: <20260708-welken-dystopie-ertrugen-56a3b5f7ab66@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2372; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nQTJehsrNjH/qX4EOyzAlTO+RBHcG/yjYW9gYuuUFIA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5iTy+4ej3eN+rzKsRBx4ms/YfnOB6fLmtKfum3MBTZ
 v/k56+f1VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARdy1Ght8F4v9ZvLd8PqCw
 cTPv7+My2zQPTK7c/yLBYM7VFfW/Jr1iZPh6ZUP0oay2dbVyE06brmj+s+j8sXc2qYsnh76+F7G
 2WJ8LAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7iiw134i6eaiuzkybidi6ebo5pbwp4ob
X-Rspamd-Queue-Id: 4D924180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783502061-765321
X-HE-Meta: U2FsdGVkX1+slS+hTwChXcgIflwDhU5eGfvfvCcm+xFwMuflNG77Kdc/FNHjVu738X1ztVawuwGolJW0UnxuL6x2yOsGx3uAlhwPq5UNQxach5qbBgk6St9VGQcVuWyn3w7UI30yGf6M4qkxdYprHRWFr4Zd0YdjSqV7Q1GxeN7DYbIsOHl/CdARzMNwhapmt7z7OoPlpVO9NzVhwBCjC2oTCR52k6JFGKGr45dxO8uHxTiNMdN/jApWdvFMlBl9IGy7hvOjUNhRIbnOS+Grj38GAuPx/aRCU5Y2vRkq7DFUvLSIc41CUasxZz+I4M2lPinaATzBZvviAPh6zTOREZzOEuaHDTg24vV5J5aJhEMwJ3n/IoH5+pc0pYW72jW0lqdpauuGmvozDQuWN2C2vhIprge7zRQkgGPSSNhK0TipoZ6Q4den9CymTUnNNQxOEFO47t5PZPzItrrDpE3jVCq/yYcoFLJMv0aRKV+3c3eu3KUmTlvjelxv5P6k471woQK7JpLKLSaQ4RdkjM8e+m1Ochz2O2sc8cVz2n4oYmueh3Lm+CmdYVcvEtRGSwFFeDirBvcEqpMFdsCyQQhgRlxPRCb1w2nxLSmdlCPqAToaivkj5t4VS8rGk2oaVU1NSefKiDqjYPfYIX5S7xczC7jh7/Kxxcl2JS1N80u9znR9MMTrBFbx5ddSpX1+/Zhc4LgWYaluIa6thnluomv8aMacXxVayA/JZ8Csx6M2dZ/O7S2ykZncv8LhWasO15/fMGPIDH5Lq29XQg3X75itE+LKl4CvZGnUCu13UH11zI7j99ik0lq6FhRUUDvQMVKXGm4SHUbszc6FoZaIlq9JCE8FhQKEnr7MqH2vBExvwjT0LElQfh1LoRgAcXq3PLmerODTs1Nzx6l3ZfhHk1i1uUTUqxbPw5r0fZVbMxM9vMa5MEovWSULjFShPlF+ni8IOqMkHOPvxoT/A5uGQpz
 tzEoe7kB
 EsEWp/HSB6XSywT5IvqE+qoARClHg7HHd36KWc2q476DIxCkqqQUVNPCq661LwJ8D4pRnXwxhyZKU4ivjMPXr0CNFPm1UXWPt6syVaXGsWEzzYZzFDZNNBKdnLz9HCdI2X+p8otVg6IwKCfAPIAIyJlufp400LrDANe0njjAJ5/gu1+RfQ/3HiIM+2LEbBbq/k3uPGESlkO7U/XAgJhCfh4F0FEZ/bkyOn4U+r20Qn2f9XoqnnNOzNT1E8atxIM+ZZ4gyFXHhyzRPcWcXAggMlYK6RoUaGEQBHaUPfIpyCzhkvZMgGvntcq4meHGToDU0x+NWfELHPLTxMVo9dccW6UUdFzHXL3EoRZT6rYhcFvq5/5/I2DTuc+/Bo5YK3cD1S232sxQ2x0J4I39Hu9pTyej8adydMnBK0FZhGhOJ5O5/tLuvbexN+xnG9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 15:44 -0700, Farid Zakaria wrote:
> On Tue Jul 7, 2026 at 12:45 PM PDT, Christian Brauner wrote:
> > On 2026-07-07 13:34 +0200, Christian Brauner wrote:
> >> On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
> >> > On Mon, Jul 6, 2026 at 9:01 AM Christian Brauner <brauner@kernel.org> wrote:
> >> > 
> >> > > Ignoring the blatant bpf abuse here I think this is quite workable. So
> >> > > this can be turned into an actual design and patch imho...
> >> > 
> >> > Glad to see you think this proposal is in the right direction.
> >> > Just for my edification, when you say "balatant bpf abuse", you mean
> >> > how it abuses the socket bpf type?
> >> > If so, do you have any guidance on a new type or should I just take a
> >> > stab at it.
> >
> > I drafted a POC for you that should be closer to how this should look
> > like with the bpf people in Cc. I'll let you lead from now on. I just
> > wanted to help you out and illustrate a more viable direction. Might be
> > that the bpf people want it done differentely. Let's see.
> 
> Cool. I just saw the POC.
> (I'm trying out aerc to view the patch series. I will also try b4, I've
> never set it up before)
> I will rework my qemu demo to use the struct_ops and go through my own
> testing to see it work.
> 
> That looks very similar to what I was researching with an LLM. I was
> just going over the idea of struct_ops bpf (a new concept to me) and
> using traditional bpftool load, a new bpf program type and kfuncs.
> 
> You put out a surprising amount of polished code -- thank you.

I would not call this polished and it also lacks any tests... I've not
given the locking much thought and maybe there's easy wins on the table
I haven't been considering.

> I would have had to lean on an LLM (heavily) and from the patches I've
> put up so far they still have quite the gap to cover in terms of polish.

This isn't my first bpf ride in both kernel and userspace.

> What does "take it from here" mean in practicality?

Bring it over the finish line so I can merge it into my tree. :)
If the bpf people have no comments or worries than we're done. If they
want changes I'd appreciate if you could make them and slap you
Co-developed-by onto the whole thing as necessary.

Also, please ensure that this works for all the cases you're
considering.


