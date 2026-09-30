Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1028FCA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EEA6B0095; Wed, 30 Sep 2026 09:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100D66B0096; Wed, 30 Sep 2026 09:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31936B0098; Wed, 30 Sep 2026 09:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDAEB6B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:40:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A2B0A0786
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:40:23 +0000 (UTC)
X-FDA: 85270537926.07.3ECA512
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E4661C0009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:40:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XKtt4/A5";
	spf=pass (imf20.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790775621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbkUDNwMgnqGHrbog0cra0S8SRCtAdGfYKEuqQ54rHU=;
	b=JevzpQz/lxcFHVGtZ0MIcsM1AkDIow0z2F8lrtFiLek9zRdrMxuuIwB/ZP3jsQcJPx92hL
	0A+/vWEYKkOL12YpyXu8byHGkGgDi9z2USZHXtmne+KR8HrTov1HLtWxevVrnY9XPQaRut
	l8fUDHY1FWYzSGgkcCewNleSXYTFX+M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XKtt4/A5";
	spf=pass (imf20.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790775621;
	b=vZWInueM23GlTWqdklDZVo9+BWX4obsQc2fKCPp1rRAdcUu00S82mWc4wsf3juudATG4cW
	DW/N+z1VvoEog3DVwz7GUH961VMim/XH+2pZ0nfXkudnBDhaV9dol/xpsBbYGKx6ILqTrw
	7g2RTITDCbLHqmdd9njq4R3+pV4rDeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68EF160252;
	Wed, 30 Sep 2026 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607161F000FF;
	Wed, 30 Sep 2026 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790775620;
	bh=zbkUDNwMgnqGHrbog0cra0S8SRCtAdGfYKEuqQ54rHU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XKtt4/A5r/NkfGSvjGsvCW5EFKALT4VUt/RHVBjfHu+gJmFaF8/SWNcnrhlmbywAS
	 ifcqRGWYrmSjygRyyrsTfwOoN2bR2RY4k37nRTO86Fe/6ZQMJmouyYQepITjzW/tLt
	 an92bB88qaT5hqoqilJyvJmu9fzkThXkvwq+yIw2k0S/X/1iXOxZ7uRrI2+wOdRlWG
	 gg5IBr0eTLWXVU78MxgA3y+//L0MbFHibkUIsEBDi1XKQOlJjPlbCAIAprCWNyzfu2
	 N4dBImdVO92xInyLowtE5Vy0a5O3aWxh1xfY0cTW7PyFmz5QQNqBm+piNDE9yfYwhg
	 ZZSNukz9/nwOQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Luis Augenstein <luis.augenstein@tngtech.com>, 
 Maximilian Huber <maximilian.huber@tngtech.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Nicolas Schier <nsc@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
In-Reply-To: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
References: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
Subject: Re: [PATCH v4 0/2] Move tool for generating initramfs cpio to
 scripts/
Message-Id: <179077560598.3184845.8880862675609960141.b4-ty@b4>
Date: Wed, 30 Sep 2026 15:40:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1195; i=nathan@kernel.org;
 h=from:subject:message-id; bh=uzHGM/3maVkIGwCJuKvC/PNaFcYXYyU6EAt9CwiwkGY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFl7BS33Hd+UGvve0kZKZXb3b+nkhL8/ZL9esLiXa6xya
 v0x49U3O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEPioy/NNPOlPA9cZP+FZm
 WdDsvrtCQplpXb/C83d5LD07//GadGVGhqs7v7rem/Z96nyOPVe/fK5Nf7Jo0d+HUju3xd+vdmE
 8H8wIAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E4661C0009
X-Stat-Signature: z6waomjwqz6a6kjuiac5n68u846ypipj
X-Rspam-User: 
X-HE-Tag: 1790775621-22581
X-HE-Meta: U2FsdGVkX1++nb8umvN7FehNqXjzCJenjySVxx6QxlhAZeOoTxJetIqIAFEHBdgCw4LyFGLP5cq6t0CkGTbQC6rGw0uxN3dWV20AqdyIJ7WrxQhvOpTmT8IsIyKmPZHQYLidE+GRleJBOLT2S+JxIi3EZ7Xn9pq/fcjLuR5dx93fVGOSk5mLqE7dXOb9CrUwVoeQjyOaXivrWB2vAYvvFeJwMkdmUja/Bd1VyMpe8S3v3INbk+/JtQre3gzOTNr72tnNAjOoH2r1VFjMOZLU82cEVhXcx5P+N9OIFsO8uxquXsz2pOXdU9wcXjYuHo0bXAP+5iIzIROGrkSOfoPmRIAYEYundvCXmdapRn5p6eaya3m+9zL2zsaejrvJ5wcBgCGZG7ZSMdPA7Cy4FgNH+l3di2hJ3XE3beoGqKA71OdkRVYgfe6/lKAdeQHB/JGhAo8hK8L2iqbc+9nMf/Zn6TpEj2HWc4oscgLPg3boRHYZ4QJqz4xWXj2lqETqC5PKgJaMvV9jVMVaE/6/qGp4CFyUiljYhOMxj9bSyUkV4MTb+ozK4sa3NufAShHfkm+Btfy2i1CeiYe33FbEO+MJWGdau7muSdDsMzFCwHIe9N9fK9hen6mHvK9BvwrJXrGKOg+utuDoJwPDLs2djj9CmQ7rKsyDr3zXOyGNgLw16ggVH7s1uv++ZbXuujjgZs7ZDUg68ykWCS76xhx22qQf2BYLoyEoqcnCrEVAG1oNRLLn2wYjPV458OKzxKr/Eur15s4Ac6m8PLqOdhJ2Q/c/3gVsgEq20H8gvQ7hjPPSQAwMdHpYu0iSxO4Pe4b3ZVMOoWvm/CBP3nExQDIkidVURY+vHqmax7t88VAPlctur/rsHonpaorlANwmPteQxZZdFm6uxNPwRHumkFNKS2bJzSjS6hC+zN6lxbPp32COfnmHwA7jnCcKNQ/l/s9y0Pl3HOstLGCuwo+zw9/spaZ
 MRvxGUzy
 f/zHa42QiLzJ4rYdU6rhcNJneo5ggvQt28P7k9oLqez+7LxunPy0tHyDVBHveCQqMRCGVrFjtFWEHFgYvJHWSl38tvCi9n/cwO3t5OdBWhwdQrnH8ximxx+/BPU2k2gmRVqZ2qSWA5gLTtjFe4JJivF5kj3rxbVZGFTQIQU/UgFikPV8VL2bM//Alo8+Jg4Zlki0vnk6atkNfSu/sJi/J0ISWgVi7U6novX81893kY7Ootl4Gs/MBjpG1mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 19:26:56 +0200, Nicolas Schier wrote:
> Move tool for generating initramfs cpio to scripts/
> 
> initramfs cpio tools had been subject of several recent discussions on
> linux-kbuild.  Let's get two minor steps forward by enabling a
> top-level target for building gen_init_cpio w/o the need of a valid
> kbuild configuration [1] and move the tools for generating the built-in
> initramfs from usr/ to scripts/ [2].
> 
> [...]

Applied to

  https://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux.git kbuild-next-unstable

Thanks!

[1/2] kbuild: Mark usr_gen_init_cpio as no-dot-config-target
      https://git.kernel.org/kbuild/c/14e2c1f5431a0
[2/2] kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/
      https://git.kernel.org/kbuild/c/33bef82263082

Please look out for regression or issue reports or other follow up
comments, as they may result in the patch/series getting dropped or
reverted. Patches applied to an "unstable" branch are accepted pending
wider testing in -next and any post-commit review; they will generally
be moved to the main branch in a week if no issues are found.

Best regards,
-- 
Cheers,
Nathan



