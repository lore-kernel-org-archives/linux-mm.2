Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E8AAC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE6E6B0092; Mon, 20 Jul 2026 08:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF176B0099; Mon, 20 Jul 2026 08:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4B16B009B; Mon, 20 Jul 2026 08:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 189576B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:40:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B7A7A014E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:40:30 +0000 (UTC)
X-FDA: 85009113420.29.EC5D2FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C43A11C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:40:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecxIasuA;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gSJYyG5tqoS/xfJ/ocf6PHpv571KSG20n/AuJPymfo=;
	b=NPu9tDUbh33M/fc2M+7H/ZeHjB1BrOnZUFBop6coEbkTeclMmxHDWLzWJtIF3ja6ESoz0p
	3cI6og/q3vtJa+IDWJhUlmivLNKtb5g7MN7fE4W526PCfeqDs6PB9J1OVS/VJ4mt2HprYT
	/F45ojuEOM3IInFYi4r2ukL99JoYuvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551228;
	b=NcgUAyetD+zVhhNo2SdaXqmQ9BprS2z3Wkssm4GcbPHmxpOrXEbTiHdSXJx/V85SEs6i9N
	t/Oe98x3tJQx9fHWGlo7gYcmTXOmuqu+iaSPjvSspDI7BB2PHec/kTxIfhRqgcb9EvqBeO
	14uY7SY4PWpoGGAPvkq+tEYWB2aPK/A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecxIasuA;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FFBB60A76;
	Mon, 20 Jul 2026 12:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54A81F000E9;
	Mon, 20 Jul 2026 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551227;
	bh=6gSJYyG5tqoS/xfJ/ocf6PHpv571KSG20n/AuJPymfo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ecxIasuA0P8PpS9EavsmRZ74Bo1ipvZL31wrcSQpUaUWw8cpPGkk40TmYO+yO9DlY
	 M/msTR4My1TuHQhB3uUJGRqHQFYThOHMHJNo1Oc/2kNm5gkE8gvw1rAaDlvDgP4ILp
	 8TxD9gB7yxMUu0ge2JqO/zTc7mYK0iKRnDHXQMYMcySe0zCXVMD+5N13HD2nIgULqf
	 mY7N9+E8n5m/+e5eBzGLcuIJ/brp7rdgPRcQWOyMhKHnI1fsOw0cLSLEKPlSZ3zTOd
	 DSbo1DAhRH15t/cLxwMc79K1Fo/lqPC3FzpbJxFs1XNKwgTqB2nIg68/ZCdY3cf4j5
	 Y9eBlBJISLlBA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, stable@vger.kernel.org
In-Reply-To: <20260720-beglichen-kognitiv-organismus-5e1e55326c56@brauner>
References: <20260720-beglichen-kognitiv-organismus-5e1e55326c56@brauner>
Subject: Re: [PATCH] binfmt_misc: set have_execfd only once the interpreter
 is opened
Message-Id: <20260720-atemschutz-kaufanreiz-bezaubern-ba50b64e6eda@brauner>
Date: Mon, 20 Jul 2026 14:39:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=947; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+Cmv+ibbGaHqbmFp4DK6NU/RMqv3p9IzAGf7vvtFqoM=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGpeFzigvU9VQJeNJJWZJLdTmcBRaJNg56EYC+1uIDhtNA2MS
 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmpeFzgACgkQkcYbwGV43KJ3ZgEAjybq
 L1I5/9t8lCZCgjKwIWelalu/62YFIKz6ujfc6vIBALyCtTQh2A0vT/iAZK6JWds3c8MVq0f0Oar
 VPQj3vKoJ
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C43A11C0004
X-Stat-Signature: jyeekg9gcbni16pt4bgur3bk714qpygc
X-Rspam-User: 
X-HE-Tag: 1784551228-511625
X-HE-Meta: U2FsdGVkX1+noH3jzuYhuwRwzGzEYammo88zX+Ihq07PRq6MpvvVqDUDO3XsDEc4q2k1SbOTzAgidKekwozrZhD84osLzTx3EMIO5CixC25sUNPCD2wcNOfJrZWEOOTpS98HzzbXfcFSxrkzxP3piJlXYjTutuUVLuCdqzCh9Hey5sToW6u25UZpopRNkNNNdtg9HZfcYX+r8/UizKXNmYUkfpkzvnP8rU/LzJOxOXrulNcMqLS2yx+hXrGRaTaQRrBrxuR9CEvj3Xmzki7/n/A3gLLa6Fcdvjhmi/4VJwBLD6GUzCUet5A8Nwl/SW6sXPCeMW+3H9PglnP3uYaAJaUxGo/Ev1+iRCbLeYi6yTdZXXPOlFZCYC8Lkkm6bfVxE2l8obW9RWwkKgnnN7cW1p40+NLERY2yKJb0IdI8pyDdZnCjnyA93HWwy3SfGty8xKVn33sW6zmz1gy9c286xUUrJz7zvK86Q7jpIES9K+tg3nCSVNTURLxFlzyXyNF2ljkACXYLKz0+MYcdaHQssHhIOBjzzRKEgQXRKf7gpIbsDL+be+auTHo+GBGVg1EaHxU65ulOhjxG5AT6SgDbAPV0mV6v790H8DwOESbWwT7JE7WhjJXkEHl9P813sflQaAnO7XuBNJjHJCRUfp4WBDP+HTXBHOBfTxOT4fWMwsX1w0jJ9ktB1x2vo8auxKJCUCSpNMKprDrLnmbgELENi22V1frYfnNuwDleLzbojyVMrFqyWGh2nxrl6ExSYazJKT/ziPL+Xd6LIvhdURJ0OoG6iwnu590TqqXTDZyZ9iLCtNaRwdOMl5MgA/HDGun2Z7gorLG28I1QIt2yLETlYToHLoulpIbjzSynZZbs+HnQ90CX0aFmSRDWL9bAsb/pi+Q6zaRzEicajVFqatmryHXQaiWPisctDKkg+o9OT/gyTggXjii61Jz44T39hXCh8r5EsbJy3FMxy67y93q
 T/hpLpM/
 GasCf6VzkMZ+GUR9WLwhaLPF/BzB2sk4OheVo99YUEF9R058C5imG6gH9Ca9JyT7jPuWYAWwIqNR9P86Lxsnw3lffVd5CExlS3shYLw2sXz3NtYwB7S/XznBwtmYoi8J7aKXki1t/HcEvEGj0nVDTo8QhRf1zSN8jchcg5dxhJuPXh5LTJHggxn+04gNGam4HZzI3xUCVAzfPenKD+wtidPhsA/X2VMkLDJE7glQv0TrXDpMF1rx9jo6+YFOUkZa1qe95qQPfuAz4wbkpj0LzQoWU4yzo9ij7pgD6oDYUH5JWnxIde0tPCVS43ITHca1uTBnPsLsuVVBILh9+JT50nrJHISa59ZnlSW873sTTyB3V5M89NNeSft1WcKNk11NB6irI/Pgj9PK23BZHrYTRf8pT9WcsQK7KmMJA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 14:36:49 +0200, Christian Brauner wrote:
> binfmt_misc: set have_execfd only once the interpreter is opened

Moving this into vfs.fixes.

---

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

[1/1] binfmt_misc: set have_execfd only once the interpreter is opened
      https://git.kernel.org/vfs/vfs/c/d1e8308f6a1c


