Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A110CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398586B0088; Tue, 13 Oct 2026 07:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349456B0092; Tue, 13 Oct 2026 07:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EC86B0095; Tue, 13 Oct 2026 07:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 067F96B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:08:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7341FA893C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:08:00 +0000 (UTC)
X-FDA: 85317328320.03.0486F67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A543C180006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:07:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKImCcVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791889678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSWhydPwnGjVmQTHrIt+aT1FeNndN2ccR7i8qMmsYQ0=;
	b=u+iC5k4HCUrF1SGeWGoslJuq5ZtSdIbuEMZQDKMY6Sde105YUU9qAJ5Dpmb4/6Hv7VEe+O
	H1Fyu2/8/vTshv8dW5so/I7d25alAeV/Qyv+nj9YhfFv66WA15Xavforg+wckPeYdCKr68
	aW0tcjEvOJ2IXn4eCtkuKggkQwvAI+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKImCcVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791889678;
	b=tp6huhuKySR1kffYGsVLY1zbdLcHvhzmD2r8wCsGtyMSdinSR2ZsMvcyeNdolekj1jbCPL
	STfxx1xY79Uly/CPOrI/2qlMEvMRUxDv1UW2qnKLTFsVmMdEI0lIxnvv72rKyj+88qtMf7
	IBPMspsYdwsylnZYLto8/6YIE8wng8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE64B42DD1;
	Tue, 13 Oct 2026 11:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4321F000FF;
	Tue, 13 Oct 2026 11:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791889677;
	bh=ZSWhydPwnGjVmQTHrIt+aT1FeNndN2ccR7i8qMmsYQ0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GKImCcVX7BlExGaWDJuo0uDFcW2AhnNz/vahq2ceWio6OBpTtQnbsxSnnpNrD3aiy
	 pBQeaNbnFw6UO7Q9stppMU4fTpC7LpTQkAgNaf9j99prl7jtsqnRCPF6vevl1FmbEn
	 nNl9JPcXc/0Nv1UOxOEBfRfcvM+mtDiZCeXIiy7oh48TgH9/lKc3wbCYGeKbOVAnRn
	 tYS5LIYgVGn+ddrhW590Pybu2z9MG/LrxidGyu1QeVnHe/76cj7VoMYY3L6/Q8gcr1
	 SjFRL8c8pg6Oa5SMyhnMzUgsESw5anipxPwBjlAfWFtOijqJ3DW/PsfvqFToE0/7K8
	 80DPK2ITuNpcw==
From: Mark Brown <broonie@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Michael Reeves <michael.reeves077@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 driver-core@lists.linux.dev, maple-tree@lists.infradead.org, 
 asahi@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
References: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
Subject: Re: [PATCH v3 0/2] regmap: Fix cache lifecycle locking and
 teardown
Message-Id: <179184676097.1099724.2382944643703457917.b4-ty@b4>
Date: Tue, 13 Oct 2026 00:12:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1418; i=broonie@kernel.org;
 h=from:subject:message-id; bh=clBHz8jqLb/gHxHcd/z6kA2QuhPCp5EX6c3TGIzEMtM=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOCXLWNUw8lDtDSv3snc7g7oB7P84vYvCcLaGjX6Nw7
 CnnrjzTjlIWBjEuBlkxRZa4LO6X9SWv1/AdXNgGM4eVCWQIAxenAExkMjfD/5jbGxfd2GTAof3g
 y8HKvB0Tnz9vSLA/v8XvcEqUrpvlawGGf9olNQ8tRZqFbjse1eV7wb0x7jm/cteHRj6Pu4FL5p+
 VZAMA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: A543C180006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1o3stm85hbox4axp8ge3zoya9dfgo98e
X-HE-Tag: 1791889678-9799
X-HE-Meta: U2FsdGVkX191L7XT4YMzCCI6nWX0NCk4acbTcxag3SJUO4G2McrD9AHg1R+NinkMZOGuHznedl3ZoAobvlQqr1Mrf2SN6IL02pCtEaptHdrMgXytpa3Z10L/YSHOMlH0fTrD80bagyu88RNksRTTO3xSOvPHh2Q6ESSDOk7/eQKv9VIsTPV3OHU/gDY8R13M+MRWfgwep2hDNxRsm/D4rQ4phEhhQJcPntotRuBf2Mw/xgTOUetOcG0zk79Hfkv7ulQni38BNrdDtGRHpUoH131sLvCYKVyXxNVkvw7BARq2PknwLRLUW1KMFTmae42LX6nTS50GqM3RrBD3mkoBAghcfWBNBJ6VVN8xe4e0DjBaP886n2Rwm+IzIEJippBiuzgdkYUiTzW8L19jheK2UF2+6C9RJFEk9fi2FnmDFj7c50JFrC3JTCV9XeOKTPQ3oRrFMXTWxUw+AZ0W4piyFgnlt5faw/Lxc0kQxTFUyS8V9TEbKBLoPBWBA+Th/uZV0H8SPs9yYCh8hAnXJdw0QhAwuT3bnJCvdAPvXErmWqGB496SbBAyaeTWQJQLr35IcOfeFD8sbUoh/mmqVa3tPiouf7ih41ZaM88XsbBiMk2UEizJTltpjRAuipbaeSME49ySp5Bi90tV2aeeWHY6PBukNotfGG7S1ykbN5GFjUH8R63tjzjDZnTMNno8V/bA7ultJdt/nhEDEz8Hx5tJZ1uCKQcVFjaoMDIFmSLXyAIcVo+4hCc7Iuv92TASCq4NhtEEcR2LYLFW3I+0scEuPrXsSpss4O36vrVu2jvxz28VREJ/i4uuE73eEaM+QneMiIm36vENoXrBGHHc7z5JiDDRkYhP1Iso0BIPfPh77CZ9+9bs7eFBWazDudnKCp45BrOA4WNbdQKNqx0DC3KWySZ7/61WiklrppQF+pcXG3ToCK70Qwp1IMrHTRggc8FHzCdq/IJ6/Xemq7Lqcxf
 qekZtobo
 lfQb6TPDdj/rilnHGJ3p4OD02yVFP/IGBXcox0OcQu7NO+a0CVAS4aqZfIFYqV7DkmATMIJM0K+P0niunnTsDrSsJ2cNGW6w4CLmv5wHIogAyxr5yeuW/ojn7boHFeZLI3YaZFn2VO83QI7RUaJKMMkqDzt8W2s+ZiK1+MQ+p6g/2E6Ygr5r3Vwa7DvuDsTvT8bdX2Nu0zBoFtctqARR8jNAgDT3gEN3t4O2Ao327F2OO4cA7SPmTJIPzffFaLN1NXg5WKg8k/72tRij+z3b3Ij12rnLpOMqRJsbBClbVQR176pnesJoGAuHh8cs+Sh3/VWLw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 06 Oct 2026 18:03:14 +1100, Michael Reeves wrote:
> regmap: Fix cache lifecycle locking and teardown
> 
> Fix an "Invalid wait context" lockdep warning during Apple GPIO probe and
> correct debugfs ordering during cache teardown.
> 
> Tested on Apple M3 MacBook Air (T8122):
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-7.3

Thanks!

[1/2] regmap: Remove debugfs before cache teardown
      https://git.kernel.org/broonie/misc/c/834035934cef
[2/2] regmap: Drop map lock during cache init and exit
      https://git.kernel.org/broonie/misc/c/abff0a48b110

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark


