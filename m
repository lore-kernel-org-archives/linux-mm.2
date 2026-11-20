Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5AF606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JllosG2Y
Received: by kanga.kvack.org (Postfix)
	id 3B7986B00EF; Fri, 20 Nov 2026 08:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367EC6B05B0; Fri, 20 Nov 2026 08:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DA06B05BD; Fri, 20 Nov 2026 08:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 071B66B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:54:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D2FC120D59
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:54:01 +0000 (UTC)
X-FDA: 85455641082.13.A5433B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF7C340004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:53:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JllosG2Y;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182840;
	b=nODMl7KVEPP2ihxnSCfP5y0Obi6zPm9hA7F+JZvA0vVqCmrMCKalJrTsmLMP2BoAL72Txq
	uucULYZkU9El+mllTu4bvo4gVayJGZInJ25/ZD5qIpHUf/vy+Ygo/FdMxjXRkJN2UyuHVW
	lapYtBlsLHtNHISzADCEvM0KfLo0QH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpFcKmLeWcNlIWO+vriHC7zRosbcBxousCh6WYeygvs=;
	b=LWnPmqAhjMmmULmRtux2zEjmbgZ/h9ruzAZMiqLFTi7v8nIie6NHbWwL6zzXCH+tHPezvO
	JXTrPO8uoZ69YhzF/5qnzE7q4gwI+xYIydzYwrT+16l7cluSpjFpMdIjqKdA68uTXmsg9v
	UUYu2eNNBUIWnklWe6RievRaHpmPHGg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JllosG2Y;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A047B61F7B;
	Fri, 20 Nov 2026 13:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BA41F000C0;
	Fri, 20 Nov 2026 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182838;
	bh=DpFcKmLeWcNlIWO+vriHC7zRosbcBxousCh6WYeygvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JllosG2YopKKAggV+8nxkQItQJgwyK/SH23r7EujPAu9LLeAmE5OsTlP0qwfs1qzs
	 egAqrAFrmET3vEhD6NZPH2L6aV4tacL188jjX0xkuze0uwvbqPNO7c8M2iAgoYcYeq
	 H7ZEaOmrlD1opoFLdFwf15pg8kb+10eV8lpeF4uADYK1q19wUkmB5rJV8qiDux/Yn4
	 hpATfff7Vkp2NHocWtfz7ojkZJZQUjOJAxL6Slx19OLLSKx4ze1EP2GCq5qfyELXpm
	 I4Wp/Gk8JPX+/i43x3SGowq73hPjNZ8FKxqVB3mHDINzvTM6yLGWHdPtvfDCy1nhcC
	 vqb5JvCLcxk4Q==
Date: Fri, 20 Nov 2026 14:53:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>, 
	"Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>, 
	kees@kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	paul@paul-moore.com, jmorris@namei.org, shuah@kernel.org, alexjlzheng@tencent.com, 
	jannh@google.com, jaime.saguillo@gmail.com, elver@google.com, blbllhy@gmail.com, 
	bvanassche@acm.org, pjw@kernel.org, broonie@kernel.org, debug@rivosinc.com, 
	tglx@kernel.org, aleksey.oladko@virtuozzo.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
Message-ID: <20261120-bankverbindung-bisher-dorfleben-62a38cf1cc74@brauner>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com>
 <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
 <avHfxe++P4WLUQxf@hallyn.com>
 <80ff9aea-3a5c-4c92-b713-99c249564008@huawei.com>
 <CACmP8UK=b4Hkivzf77BJ-S_CR94+AgpNs_EfQ4i=CHL3+=0Y6Q@mail.gmail.com>
 <1772fffa-b938-4fa7-bd47-ff7c03552efa@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1772fffa-b938-4fa7-bd47-ff7c03552efa@huawei.com>
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF7C340004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: zyyw33fkgznribna7a6wxx6spaa1uirc
X-HE-Tag: 1795182839-383954
X-HE-Meta: U2FsdGVkX182LP2Smvoh8E6VOrcC1IIfPiquvkhKfz1S2UAxJXKS57JYyun6paMjw9p6D4ymP5MvhVZbXgLDvYc2ekJgVUKT1J6PSnAgj8UF4oqHEkomDnEyJK1hXz+HLJrwekxB8rv2Y4wc5DoyRGLji1V0dB4OqXXR3HtF/i+93YYMScLC+bhQwcdIx3mPNkvE/TOlmEYDbKTPAIg0LyggdxI1GObBF0Og4Pfls4iCQSzrrBa/tsTyzGSky8EH2AFTJSSlaIHMdasSIqU1bYtUvw8zRI5NAGLJ2ioO7bvBUcN6KZeyxdFA/ODlH4d8YWVPWBjAgN1n43iAkdM7ZRbNK9hmFgr78CClaS+/v7ryL7tq7t3d4mBbJvJdRaEmOdEcre7AFBNh/vOMfah6oZLTN76DrqwqvlzKqWhfVDNCOginNQDShEfEqGKMiVMgGHWNCMOYHbgqOAt0FZv4h1pdpJ+17iaWDNDMdvb7GP+KTyrwyi3R1vav8YP1TihMngwA0D57XiX3fCgm7/6Ob3hw5KCKLXuK3dncxlYcXF+T+JBpwYwpaDxNvqKtCwJ5e5yPzse0g2dF+/ofYRZ0JyfWvpmwIBCGH/tXLBmxfy5t34rbdSybSPdU9qITeVttKmbpL+eI/4tOrS5kZtPTijCePCloApb3WsGX+06XnBYrOYaAfka64F4FkcyuS2AalASMZD6ih9s48OELK6Q6u0O0RspYFEwdPvLSR4kiYQJehofIlhQZse3YxLMViGsdBP3iz6R4yk41koHInLAKqI645MLWPdnKbKZq6nSrgsuUP1n370n4bLAX3FBW3xiO7yomhC41kMh6r6ftGW0TjT7XZFJXImBEsIGADRlJJ9zfp8drftmxr59tLkbr6CAfUakA+jpSVNt9qPUeqhc2SwrydLTsU9R7a87emHih8Dfq5FYJey7UcATzPBUsz1yJUK4u8CHbDW12ljNs4+A
 JrjPLxJN
 wrf76iDD4mV4v5J+g9tqITKWfLCc/VT3dv2AvshVWBOq1BSDS9ngj9E2y+C+E9LdX1abrj2Qnt2AlnRmoxA6xd3Kxaww63+tX+JeuAgWRGNvwMrwzjFF6L3SvtjuIZTe5YO2O/tphHXhgijh6+8rYRgC9Ok1vjKWJigaUsFtzFPAoZtRRGGyyKXVXt6Rt3vL+cR0jpFktTW9ifDVY3he2EkRhbKdSJyGvM5VsluJPpHd5tBiHJtWu2ay9YbIMyRRr0+v0FS+OvBUKw3kQWvZQgQ8ogehkfXRNyRsNndbbqlnO+QLamcnqLtL3sCyU4dYFoO2P7WpNCrozMZqOfJD91ncYPEbbdQEFT8ZaSubx1cMIxLSs6WBoT+6iHwfubbxR2N+rAqN1t0x/RPh8f0j8d4xXBxmIgrU7NVHHwcnzInjIYsTMEGwHcEgvvk3lDlsyaAeRx+apUtbqh4C8kVmlb9IZpuTWsEB9YYBNG+rshHdtBu4rYVPALK5PY8AhG49m7IVyuIFdyBRp8li4ZgXWOU6pB+64MbmzriwmzZo/58CTX5nOCNUHUFXH0YRjgOjp+/xGEVvIVW9OrG23cWHhuLQ1KkYZSWcY79aNLH5emRQHVpMoPaiKhbzrFjhxakcr3kTyGrutZZ7nsUvtepf141jKkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:15:17AM +0800, Jinjie Ruan wrote:
> Do I need to resubmit RFC v3 based on your suggestion and address the
> sashiko review issues besides sighand?
> 
> Or wait for the results of new discussions?

The signal_struct part has to go. I think this is also what Serge's
question was getting it. And imho it's the real problem in this series.

The caps a task has are described by its struct cred and the whole
kernel relies on a cred being a complete, immutable snapshot of that.
With a pending drop in signal_struct that isn't true anymore.
Anything that stashes creds and uses them later, override_creds(),
io_uring personalities, file->f_cred, LSM hooks, sees a bounding set
the task doesn't actually have.

And every place that looks at the bounding set has to remember to fold
in the signal_struct mask. Any place that forgets is a bypass. That's an
entirely new bug class. So not going to happen, sorry.

