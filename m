Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CEBCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 06:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1316A8E0036; Wed, 29 Oct 2025 02:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1098B8E0015; Wed, 29 Oct 2025 02:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0461C8E0036; Wed, 29 Oct 2025 02:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52D18E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:18:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FF4913B599
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:18:56 +0000 (UTC)
X-FDA: 84050148672.30.DEB8D54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC1BC40005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:18:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rk+6qLII;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761718735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNwUDE3GpjZgRRxK39FIaAoWLzOItBsyKBeQQ57qbFM=;
	b=BMqUHTQE2h1qlZ2xxRj5CFOyCiDVPZ3H56srArFZuLEhyK/PZyB38oRJFoefklI+lnogRD
	UW3PmqammVuE85Hge5PiixdgvP56E7kdrsw/O0/YCnfnDwFl44DvZdD0Za+XxtwD6WRoYo
	gCqCW0eaKApoNiV5We0GPxjc89eD138=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rk+6qLII;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761718735; a=rsa-sha256;
	cv=none;
	b=CoFkfBW8vPFg2m7+I47rNyEz1hu0x2D9d3Wrk4bYlx/wOPqOuNUlifJGQqjcJDX2fo/t7q
	lXoBLT3NKnvm/gzwNjuiVtuEmP9jLuezQQVzskeN4SNsDpf3hhrgtEPZ2yBFQ+C+HQmf2q
	5ToSCjjNLjTpyEeg9C+MPfkpiRUu5Qc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D28244AB0;
	Wed, 29 Oct 2025 06:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92541C4CEF7;
	Wed, 29 Oct 2025 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761718733;
	bh=sNwUDE3GpjZgRRxK39FIaAoWLzOItBsyKBeQQ57qbFM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Rk+6qLII7dhXKc90DR7x0yOEvODjOW/vGOClfgVuFKE3QWXEzLxdfMqDCeOj2aCQC
	 Af7tFpcn1bA5YqBuP1vrNitK3sm7hW3KrYUEiQ3uUVlPgDiReiQJI+4PU5WchW6eKG
	 /h6vzvh0y93wx4HdCp/Guuc6ZBoGwAMJ5nQwd9g2jF4j4MbCDnBXz63JsAb0YVujnH
	 RPaDTnOSvsJkgMOZTcApLHzlog5soPtmuQGsnj9HF4Ql6o+0V30MAVN0BZ3P8otsW+
	 JyjsA3LXvuXmXdm+mAmvjC3CctniwC/hpFVHFmdzVIxYrqzOgGJawmQ9zcv0wDagWd
	 vR1pv53KN6RGw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
 raven@themaw.net, miklos@szeredi.hu, neil@brown.name, linux-mm@kvack.org,
 linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org,
 rostedt@goodmis.org, gregkh@linuxfoundation.org,
 linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com,
 linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
 selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 10/50] configfs, securityfs: kill_litter_super() not
 needed
In-Reply-To: <20251028004614.393374-11-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <iNj77i-tfrdVv9HEpIj_AzJNAUOKdPKNfNsGxMAfclR7sy-qVQBLpolv7Wgpmckad9w4QJXyH36_g88ejY-xpg==@protonmail.internalid>
 <20251028004614.393374-11-viro@zeniv.linux.org.uk>
Date: Wed, 29 Oct 2025 07:18:29 +0100
Message-ID: <87v7jyfcy2.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: o1eheh6386ekperufdzp41iihbbkbibd
X-Rspamd-Queue-Id: DC1BC40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761718734-24513
X-HE-Meta: U2FsdGVkX19tPwk2rhwvnRK8Y38UGzaX1eOuuUP01fJBcxW2GZN/Xdgf26vir1fC0RKLNs5SC4vbN9pUbl1WvbZrSira8KJxMm6xYu6Brry1ZrpA9mOUDsfKHU/riApffZ7CUYiwzO9tI/9txesGttXMk2vkvvShL3zfJx9oWmcU0EaOItRpxhexgZUTBLXolmJR+lcIGo60Keupnja4/z84exJirC9bjK3Uqy9BLBMuRunv3uPWDYAvhJ8fMGbZWrI0242KklsashssToCrnsFEZ5K7F/3eaa18A04vYxz9qDgwlxDmqM1C72sK6/aXXTrVpgUnywq/89sdpSo06d5owXRUXvHpMBHa+OLDAD4VDd87lCxqKkogCgSSUKGS15A3VOf+QrgZnfUZROfm9ZUFnJtUeiwv20xI1NuZyo096mwDtUE69NiFtmgsZlSWGezUt8VE6dUXOBxEljWJC4PT2FZzi5do63Jg3mhig+MV1It86xxrhSHItYTzWQ4l6XKmnMR9PIZN2NjPe9PVv04SYgSQsHSSNYU4TJnDFuxG6zpNnjtdMmq4zduHmK8Fjg4v74cHyC9TFGf1+3RPTFzmaHiR2qXNfrg7YcqI+jXVBKmSj+0xYFwO14gChMtDehI1EqBTNb1fZjMLrtEb8NxqwGfUMFV7QgOof5rZjxi80S/Dx8HfkmpLgcmSI4rFEpzhlRmiZNAsYpLcUYPsBRPR0Corjk/qI98p/Ae264kbNPQy/LvHHK8rQ00Cx9xUbEE16+USqGYSh78rQGTvJg0mds3CjLIKgSZps1RX5LEvn+RP4VBOhwTm2QRLGb5kwx9QpPqSrNgNR7C7QlxlIa8dgRN3hOKqBV1ikCEOPXnjzazQgyHoS6RdX7TES1pbDg8E6XIJlgXzFC4BRGGwA19G3CAzsGAf4JBxJ/hlF0KOL7LpqjwmJldExB2cDpxG4woDtSvwV22k8doX8cS
 a1f5XgL4
 Xi6HpapuF/lHtQhbmPzHdVlGCFyOTJHJ6xf+2sW7EXJ/yvEL89zXKFa/nSXHYLI8RPHbT+scyCJeGM/lEoEDsLUznlRmWz41jECEGXc4JDDA1bSsVgToF73t7mjQoQUV+4zj+5WAlfMjzZW0HMAsvYTtkFKBJRTfn4317rOvbigkWqZ6pQKV30cCGuzep7DsBCI4MaNc64TETvZasStbhU2QjdETQ90u1GjyPlly1rql7sTymyIt+mKXNfsEIze3EUJy4sw03xbklpZaGIwQG3t9hOrPSTu+ajcQPv4q3Of0eYakczN395wkxEIIXq/Yjv/rnAVN1mr/Xz7IQLZ+mkoFmY/taZ/fGSE+t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Al Viro" <viro@zeniv.linux.org.uk> writes:

> These are guaranteed to be empty by the time they are shut down;
> both are single-instance and there is an internal mount maintained
> for as long as there is any contents.
>
> Both have that internal mount pinned by every object in root.
>
> In other words, kill_litter_super() boils down to kill_anon_super()
> for those.
>
> Reviewed-by: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Andreas Hindborg <a.hindborg@kernel.org> (configfs)

Best regards,
Andreas Hindborg






