Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA69CC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA81C6B00AC; Tue, 15 Sep 2026 07:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A556A6B00B4; Tue, 15 Sep 2026 07:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945A36B00B5; Tue, 15 Sep 2026 07:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACE76B00AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:49:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBC031203EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:49:25 +0000 (UTC)
X-FDA: 85215826290.14.5FD3C52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49A288000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:49:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVgUMcUd;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472964;
	b=jGIacDlJvGDJNb+T0G+UB55RctfkPtIRkrDD30cMw8CdOiV+2kGn3OmarAnOC1HDrzNmg3
	KHYGz94qWIakZvGiKrN1tuDJ/krLLoDOBYZnWT5BvGAaq1V126hpa6je2IyYal22kji5/i
	iNLtwc42rwVd3qsyM/FxL97WC8mU60s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVgUMcUd;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472964;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGcmjxpZCTXHRxx6IkfvznZnwzxo/1rjhgD1Rv2Z/Nc=;
	b=YBXzrs6F1tA8J5J9xGj7DozlkR1JbgzzHVAFNO18rk0exMUHnxvA4AWOE5kZOzeXWbqg/B
	m2xx+75ZPbh62MvW6Zfkbmw4cDYeLzzU+S0FiLxJ+5QWXijTq6zZ2vmA/EBKDza6Sbg8DS
	fTkS0phSrZjqYxPinnkf3e4uFYKNbIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFBA06025F;
	Tue, 15 Sep 2026 11:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3511F00893;
	Tue, 15 Sep 2026 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472963;
	bh=eGcmjxpZCTXHRxx6IkfvznZnwzxo/1rjhgD1Rv2Z/Nc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CVgUMcUdzZ3HeCX7d6oqPXdbOOpGnXFMxjmYOiUrDVNMDt6KSFLhwNsMaJoGe3qW3
	 gT6age4Ix8+ho3dxOuPdVPygCOYJmPGqaSEykNHcZv6dAOxJwunKYYu4Iy6A9HEIGW
	 hcxAvgkD63Nv91Yz6yOQLgb7Ly/W9NSezfZRhRwHurpZzKr7aOf2o+Cm4PxtjClXqh
	 MW7HRD1EbMfKOn51qnYtFwoyPkyekFswcsrTqcrSWt/vX+swYhoct8jk8UjXmMMElm
	 /5HuOJJSvXEi0+me6ynfkfTCY644nEmjpK012H06rZNZan+EQsBhkzseJGuSock+gz
	 vnG+SGZD+4dDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 08/50] hexagon: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Jann Horn" <jannh@google.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-m68k@lists.linux-m68k.org, kexec@lists.infradead.org, linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org, linux-csky@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, linux-hexagon@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-fsdevel@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, bpf@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-arm-msm@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, linux-gpio@vger.kernel.org, linux-um@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, virtualization@lists.linux.dev, "Eugenio
 Perez" <eperezma@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-8-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-8-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:49:21 +0000
Message-Id: <20260915114921.AE3511F00893@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49A288000A
X-Stat-Signature: tg4x7dgppwor4psz17ma4m9foz43fphs
X-Rspam-User: 
X-HE-Tag: 1789472964-843866
X-HE-Meta: U2FsdGVkX1+OotlnziiQWuV+lEXbheXel6DyMzSyZTl2cBAMdOAF0t1lU/Q/349AdgCPSA+jlu3igk3z46rG47O68R5s7DyBkeECIHuB/BHVRIZaHuXVegYfGeuzDLef260tkocSMe1lgYNopE+vBYlfC27i/Hl2MxfEaO2894kXXX5r71D5Qm89hoq433nx/VJMIuveaDiX8Jz8qz/w/msH47+Bkp3rDJ/a3f1OcmmUOeMBch0xRu4UH3yFqpwXix4SUxjkMH1WUg3pQjoQgBSGsO4KNQ9cD91S0WDInCl6kQiIm8VeEcE35El7zkb5vOS/UAMySfX0JgOI3/F6SL/mGm0Y2L5K1mXFislaXzryQkomyTpsENwbFeW6D9zy4DQxR5C8hWxHR/mshbn6v1c7K0mwmxywBgvLGqtzjWGMFY8lpTqnStuLxxiwgVB/yfgJID4TSuHFyKjiOOi8TeFulh7Qp+r+X/5qtavhnkyTq+QgoW72I3ZyH/OVVvrYONk19LxfjHljvxEOOTFqKwafA/KBJ1AguBpfwoSX0BESld1gXquMrkr68afPgyaGk0K/Z9BsrskeCZWGOm6KLEngxjyg4QlolYZLKhXs61b+jLfJs0+zB5uwBuPnOJP0v1V+HTZM3TgXYkc9KizqnORUd1emoAU2DRgGptyVpG3noKwfPTmHrYRKu6aBEMTpcFZ+sy5viOYrxFOWIywd1uvYnnSHKutv3eGjprNoOXP7V9VjECpK5nwWUwO0MFRbGX+Do7r/izmD9rswyA+kx235vDIAFWe2Uhf3F5p2z3GFmAIONvdJRPhg7NnNlmP2ki8YWmO4ploRPDg9jmjC/Q2qlwoFfr3Y6bXq/gsC2hQkKxT49jAZx6AkumYqXM4IIcPl/bUAv98pPIChl0BJ3BGICZA9SbuodFA93aw6S2H35jr0li3r9sU0k6sj9gHya/1bJcHU0b8+9G2Q/En
 mRbys/W6
 Iwd4AWimDMukvcYzg2BD6qnD1tHygwEPybGeQMCu+LAZXHeZ6oXU9mKkLPtSeBeouDhHPZyCB3SFdF6aaQZM8o1ufPq6qceD+UAxtSGXWcyDuiR9GjTVCbPcTtr5dSTzoV2wnIxrcLvgr2O4+hU8Y3C42FWfwRKLdBYetLMcwCBv8WtgebktfmXpvmUdfmtuDAJSB3PuFISY+fFUqkRTyhUHbgTALr6Bc9lLkHmAXydooZ4rGMS853B5pt0csPxNwBOKlvTZUIaXM+OyfRly2FWi7NHZQ5ygaL8JudDEnvBWpqo3dgLhc2Jp3VmRn3peryJ2bOzJvFOt7BGLfI92Bj7ZwuLmYz4XlbSR8umHlVJ4/WnGl/J8tearpwX2skwsoYzZcquAxYLDtJ/uGoL8QUhwRrTEO60mFPghUaWRzF+jHk4CgUuZr75JwIr6avpxyXsUbA2UiM47nXVqowj4+jnQTSzKmJ38dnBENdDw2tJzBFsBzDXmRBJxc2ni3Q4kPHRhXi4UEnTDO5kk1D0aoZd5rCmCy0CsNAI/PY0WV4l8Qew9Fbn57WNT0uUmDZfwVTKOPNZGnpMVdXn83ZcvaNMN5KGlSTKmHeuTNY7Fsw54P+BeEKcnlPTfu3bH0ebLdV+yx6meigI+ajmHX8gko8xfLY5tM4ediAQ+5WwgiRNkc5e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it in do_trap0() once the system call has
> returned, before the ptrace exit stop gets to see the result.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D8


