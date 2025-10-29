Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFBE6CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D5F8E0031; Tue, 28 Oct 2025 23:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464568E0015; Tue, 28 Oct 2025 23:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1FC8E0031; Tue, 28 Oct 2025 23:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28A718E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:24:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B33261A06BE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:24:14 +0000 (UTC)
X-FDA: 84049708428.12.16C42EE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id C82F81C0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:24:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XcXd34Uj;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761708253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/74EwcCNII2uB0u4CPJWojlcJa9JLtb0FVKMbO2Wykg=;
	b=FXxiIiMiyHMtvWPB5aYQ4x4rLLIgwcsURerRRz0P/QMSbk6zPWccS4zdcANO+tdTWfhmNg
	wE/SfxM+R4sXgm/MjFG81gymcG20Kxez2TWehPUQHygYeRnXSnYaq0n1L3znpqfJMoMkSC
	4rgFycgfGAeLXMEGj0Hm5Eb7t2eCxRo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XcXd34Uj;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761708253; a=rsa-sha256;
	cv=none;
	b=vuGUlX+AIMKfKEgblos/2DyCI5sdeWwB7EJ89WBELIzx3A1UN+Tc2GpE6QRywW0D1UrS9u
	V+O/V+eAb8KWzHoVVityRp5E0gaa1D2nyNUcICcGkwrgp8zx/fqI3YwDnxhA9S1riBYz8Y
	W/n2dl0FkT29c6z219XcZdOC1ySqtLc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/74EwcCNII2uB0u4CPJWojlcJa9JLtb0FVKMbO2Wykg=; b=XcXd34Uj7enu+oskIPJPOtc2sW
	+JUVmiqxAcaM83jJ33Kj00wrrLLwo9mF6yh+svt4+qcE1PgJRBuN1EjWahP1tsM29WdL0OMW4u/zI
	wtsAkFC3DMZiEmRlreDEn6/IgmA37eL1BXSnR3JtjGswJcK3NCUEauvGde4K+59f8KsJEo6T5yKwq
	t4bKDSK3qMusrrsuHwPazN+I9d3szv/tBoGXBSjlJL/knw65vXnnJOFJhIz3yUjx4i5Ghlc/+rHgG
	7zcbEOG1Ix7lCoeZLSwiWl97ry3iG7ZT6wVMc9hHzyolLyGaE7QLp2JbVftwMF2LmmAKECmJ3Nj5R
	/es8Sg3A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDwn6-0000000DcBo-2Wtj;
	Wed, 29 Oct 2025 03:24:04 +0000
Date: Wed, 29 Oct 2025 03:24:04 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 35/50] convert selinuxfs
Message-ID: <20251029032404.GQ2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-36-viro@zeniv.linux.org.uk>
 <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C82F81C0009
X-Stat-Signature: dj57ca8zoixj5koyum9ijn1389q6b1d5
X-Rspam-User: 
X-HE-Tag: 1761708252-83270
X-HE-Meta: U2FsdGVkX1+kczfFbr/0NqGVsMibQRlcggaiKiLlZdEMITNR7XQ9sl/0SZzV7QRMcr/8srMjdUSyDj8D1xt5ONXn//IL/pp/s9fjmyBImR4k9asWqBkICQsevdrKwJj8rv+ruW8kNREMXVtPoe3nxEsBsBM8E/FqGaPG50Xx+hpk25/4b4iViYflWC1qvHKElmMFhhJzJsA4naTDK9BNx6zStnGxQpiM52PLRlUDUFqj17vZl1pvmmx2/U+dCPMAj9UrKpJhOpuGV0JvfTuExmPlm101cw3bsN+QWLtYo6++Xi22kkNI81gefgtLhvMEMS8vcVCx3hs1909OAWuHa+1It2yWZSCYn6FtuFcrL7u6vDKeJNpBD9EOqUgifiieJVMZbRJvTS0fSjFRCclCSOLygAgrOcMvgZqw3v9QzLWzPKZzMTIaB2briZrSC+du7Elq6MpSB3S2AA1pmLxRAC8G+TVDjYf/b/QAxxAgN+c4wmqaf8RH4jrhFJcJ1sF/yCDFi+0bWGX7vvCs9guMItC+QPhdtoD0uzgTSSv3SmY9tuTHt9D2yExyETqj8Es6gG5AiWexChLwAUeJrz3unKe4avtq8ArZaelwnq5JOJCgXS+3FcRiL2SJsnDqi/iDb+Yz68PZbA3mUkkm8oiY4kDmxMP17Ga5U1Gx3WmhfCwzHN9ziYcT47TjZGZqv+xDTUQ8SlO+fkzv1Ft07+RtzEWbiXKv8DL0iW4R3i6wUUWd2X8TIynmJa31QAcUDKeBfSYMaHXeNlKm/62bM8m8ij8BanOu+T5SR/9oQa4anLKhk/UCVRQiAmLKeDkBUdxJltThfwzVYqQw6gzFHHU4lh+6wdOOSvUo5RiDN/lCWCnQkrIWDs4j8TGAjMSGNosKAuqQAZNQwnsgzvzPFxqxA6JDuzNN479m0Ca4EHYVrlP+X/HxzTnzS+EtLIEAC7sae5brV5otq9TxDULGRFQ
 oFxqOWXB
 CphhA8cJhEowETVczOOADFURMz9ex/k0HLqQdpb9Ph62n2XdMdjzCBGbb3VPv5DOo75GmfWoASy1z2ok0NbKehH/qs4tbaatVdgAu44BCV2jzAfpOhG0g/VFzg6ix1iozR+QQ99gwbePIXtvDSoTJ2GqlH13n5PZfrhDC80Ah8hC01oEC6vu+SXjX5/HbFkxWnj6exTCkrG2nVfFMULjlyKm4zz+CbXNBMpxaJ/GGeNZuaW5UmhSd8YQCNEKLJsPFaYd6sdzxo4LBIfuXHRT62fjlhiudiBqET8MUffiVcjbSomFgmoeta+lK+RzD8O46fQmScMucoBBZY27wEKW6TKH9tBUPv/O8p9KC03orJq43bafV+eKbFZD4dUOZGG8LP1o6s4p3q63/FrasFP7ltqnFf7AuqoMp3n/USNm+THLY3BsXqTOPDQAIEbnBRNiaYUkm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 08:02:39PM -0400, Paul Moore wrote:

> I suppose the kill_litter_super()->kill_anon_super() should probably
> be pulled out into another patch as it's not really related to the
> d_make_persistent() change,

It very much is related - anything persistent left at ->kill_sb() time
will be taken out by generic_shutdown_super().  If all pinned objects
in there are marked persistent, kill_litter_super() becomes equivalent
to kill_anon_super() for that fs.

Sure, we can switch to kill_anon_super() in a separate later patch,
but conversion to d_make_persistent() will be a hard prereq for it.
No point splitting that one line, IMO...

