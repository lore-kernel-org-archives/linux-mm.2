Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36561CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B8B6B00D5; Thu, 25 Jun 2026 06:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC766B00D6; Thu, 25 Jun 2026 06:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC0F6B00D7; Thu, 25 Jun 2026 06:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2D906B00D5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:27:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 531701C612D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:27:25 +0000 (UTC)
X-FDA: 84918058050.21.1840ED3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96A1F16000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:27:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1hf2puJ;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782383243;
	b=os+dzkgkG9K0MQhsDj5LhH/1wkLNj/2m8QOOO8O6WiQvyLaGxmpClG3TJXafqdlXNuyeh+
	/HUlTOnTHhbeKKWz5Y+9gywzY65OjXr4pXWzGSDacZJNFANphxmWugLv4rEG6J5JLp1X0n
	91hH7Ovfo115yyO0LoieeqBQKusIBvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782383243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnSQ1dgW5Ou8V5en4dctWAxSYqdJB9ThwBmw1FHtFR0=;
	b=3pK7J/FGM6t/7s9t2OMA2H+O3UyHKKe9uDwHgcQ4gzBDbFKIj41RU1O69B1NK+VaP0I0ED
	HNvW8meZgsZDWQwqElmYQowBuqfgPn7kjK3+1ZA0vwFFyUtSXJEO4Uxm/C2VZidh0x1akQ
	8/N++He7B1wgVcuOZjtQUFrkjZ1oYh4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1hf2puJ;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C636443989;
	Thu, 25 Jun 2026 10:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B641F000E9;
	Thu, 25 Jun 2026 10:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782383242;
	bh=VnSQ1dgW5Ou8V5en4dctWAxSYqdJB9ThwBmw1FHtFR0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=J1hf2puJOp1XKYhxby2JzJwKIZgJaMgzj5fX2gJn24EPhPp+7jJaBvyZb2XfOVMah
	 VhRHLNTtGQd5wCRg0FrXtZHSPZPXKgbXUi+EtqgyRjX2dmplyM/YH/uWBlF8LDfDzw
	 6mYRSDFVgk22jyplgdTRty/6hrqKYq0pldFufCQUxCkE+I7giyidli9EkW0OBNjfAo
	 xgw5rt5DEkKwjYfHmhYgmPIeJ78GN2Fv8enPGhvOjMunwU5BU7qDmMv5688Io+hUo3
	 2h3gaBUVjgy+O9EOX0Ys6H6bOy0YOrjC2XcPwYdTpwsg8O/zOAeMVwTXgQJcuI27au
	 Vow3zTC7fT69w==
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <kees@kernel.org>, Alan Urmancheev <alan.urman@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20260623052322.74711-1-alan.urman@gmail.com>
References: <20260623052322.74711-1-alan.urman@gmail.com>
Subject: Re: [PATCH] exec: fix off-by-one in binfmt max rewrite depth
 comment
Message-Id: <20260625-speichel-oktober-schellen-56132930eeeb@brauner>
Date: Thu, 25 Jun 2026 12:27:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=891; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2VCEOH6iY81GPX8FSncQ8y7SrV+iXm4kICvQUMqnnOk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZMnX8Pp6zXHmurVtvR8RF1toPBSoy2ofPer1luvbjx
 P4/jvP1OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaS2c7wz+Ldxh9/V569cnvF
 fatlp0zrD8xQm9j8Pn4Fz9JHZyTMGGsZGS7ahv17cbvl5boAu+QDEll8WnsyWZlXdnuyHtb7MGu
 vIBsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96A1F16000A
X-Rspam-User: 
X-Stat-Signature: t4mo61pz8ombwccj6rymxku7aoweutok
X-HE-Tag: 1782383243-763426
X-HE-Meta: U2FsdGVkX18qdYQJQkVtF6MJKJ47jyHNuYCeehthFZf0BH7+m8h6pfAhCKMWo55GbPUvLB5evX250lJtSkwGrCpdE1GsxkSvukk5lB/G5d58NPCw6Yknzk1WkR/wcTZ+9Tuoxdjqk8OvAgfVrQd1z+H8CK1kaVvGksX+UL40fe/eMKqJh8isiypi94HRs+LqKPPIQwFC5YTC0ACrvDyZDbCOj4eg+1GlB3sk/VN5A1/fiC9c4F66EGXqh9vF0SWO0NRlXQgXIo5oL2KAHI3m5GOfSAPTX8cVMdZjOCGf1OT8yn2/IXygy4Ke6poheOj5RXPHRWt/pglXyC6KlRAFvCWeuOZKWgTgMszBRV+F9di22+n48Ee19FY60B8rUQko00IZHFOvqdnFt9wv5fiUygm8OoHavlM8j0Nv46gN7EiVRPU1lufeceRxYwLsVgekLua9HpsXMqT/csVjJcMEslr2qEmDM1Eps+egouzWpsU2ECvVTuXqiVgZHlk/jGuxi9mkHY+N0wih/S0vGE7g1Lzlg8DoNwFWo5YrXQf6TqprGOQCacxpo7qGacL796SlZ3hpKQ6vsUtViACoDqsYq7y3r1jjpqnqnVxRCnt5mQybaD8zN83X8RQumNdNEpztlL1wqdL0pvQwkNDuqn9dt4Msb0nnVGRzmS3DjLAujEeOrRf4yWE43IBQTMMDwacrYtADyOonFUGBeOzmNvq9PMcZ1yaXZGtJH1x2OgC4OtSE+AOzYn++KmS++l6QqH4It9yPMNU/E08jWML0UAL9AGmHPBEUXRm8zVDY0LX1legiD0p1qI4flk1isz1ztExM3VdsuMybMeo273crARoIg+rOu37bt92gnc/rDfn938E0+kEWGug4KCUXNbQBdyyGe5TJDjGEQ0dssUzPZopkrFCSFR9SUw4JWuXKIGl9s8R9uay9JfY6qsFvsP3gl7Und7X4oDXCoLwRe0zUYEI
 COur7YOP
 hQmqxAoS54LdEhcG62i0MjwRo8W8bwzskaDzs/5Jra71Gx9MlrkKn8iEhgf0wgn3VlTgXaNF0R7cOj6rUE9fKczAN0WDI7ADhLEUN/CFwqNoh31kZWhyuoQv0TgdaTSFaqSsL/fMvn6ahv32TN9m4k6br3tgPvWzx49659FQ8aOKb5AiN1t9mcla02o+VkV9A5oRFKFrbUO/5wmGx1z0VK8Y1xK7EMHlaDyhAviX/JFYyAmEcfoxni7Tet111riGZc714Li5I2s4AuJSd4mhdG5dZt8247zYTTxbd/zvsRqR8di/ApHuS4/3pnLOqyvAAeINwCTWdQzNJ3Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 01:23:22 -0400, Alan Urmancheev wrote:
> exec: fix off-by-one in binfmt max rewrite depth comment

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] exec: fix off-by-one in binfmt max rewrite depth comment
      https://git.kernel.org/vfs/vfs/c/3146aada8527


