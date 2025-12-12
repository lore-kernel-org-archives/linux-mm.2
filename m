Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9FCD43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BA46B0006; Thu, 11 Dec 2025 22:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63076B0007; Thu, 11 Dec 2025 22:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79386B0008; Thu, 11 Dec 2025 22:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A44956B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:56:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C06058CF9
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:56:54 +0000 (UTC)
X-FDA: 84209457948.18.4BCCBA1
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 672E11C0002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:56:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nx6UNRgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765511812; a=rsa-sha256;
	cv=none;
	b=enkYfc0v03BU8VJB9sU8nm3CQuBkWW1DtIXy3a+grF76efnRm/aZXWqpBg9+/1UtmWQ2YA
	TpysQm8wlqRoOoEpTNpbbtc9HnXH3oPGTH4aYuopHRGMRkRB1BxP2dflFaxPPSgAWaaW26
	eSELkfwC39hDSx3fH+UgxOmdh/DAQOs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nx6UNRgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765511812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xeFWRCGQLVfdTlq5pXNNJICaPMuBvs9CA3bbYx0xV40=;
	b=1EL2aXCxuLp/+NXiNKYOBfBVV1//Q06m4T29/xJ+qCPsRTl9KtIEjkCblZd6I0xKbb0k+s
	nT9zW8dDaaUxHAga8rlZW9LSthEMVmqz30rHY54evoag2vuND6u5ECAFngGvOIdtcq3zl5
	bRYJTnfSqicuNX6cPAAdhvl2SkXHFIM=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78a835353e4so8740177b3.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765511811; x=1766116611; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xeFWRCGQLVfdTlq5pXNNJICaPMuBvs9CA3bbYx0xV40=;
        b=Nx6UNRgl+KS9z5NroHrtz62u2XwFCm21JweutjCuX7Q3hJbMRfj5yIMPFOSDhwG9pV
         d8rOHsf5ohiLGew4N0hwc4UsRtjc9uAkdatnYIqHZOltTBTh+IeWghG3Vj32i7TnoX53
         6ih251F74/Xsqi9Q95ku2sz7OF1VKOKa+EHgQSb8H+ZZc5GEG3mKyAD3oT4/hj85i7Ou
         DltiZT98188uhPEH48mWAIeEa/5s5NDyvl4FbVXVcRO9ZjuXGrBeyZd8LyQtIChSe2BR
         4gq/02yxrleFYYJ5apwAOTSdY0E/qkQ1/FcSFdd9KKfUxf2uIKcgN9mPFeh1Pl2LwuRI
         CgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765511811; x=1766116611;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xeFWRCGQLVfdTlq5pXNNJICaPMuBvs9CA3bbYx0xV40=;
        b=BXYnYgVuzihIpi6xc8kidOcGYxkhwDQrvNQ1VkUHUEs0hffVMseMJuOlbTWyXmJ/mC
         SXh9zIDzCWukzNxmhxHB3XcwdO3pNwNG5Pa6GmuejQwd6QA2BxY7kAcb2dQzhi2XjSw2
         MJ1L+n8qzguIIsqPN/8qAoRIMQziRt68a3rp9RzFQELEDZ8yCNyg0VnAD+n2ZXN71AgW
         crddnYZ1OivNQrZ73jAFqiabbBzi/2sVJCnmMBOkBNGSHGekFaF6wgWoNWLMWGc0XfPp
         nUP/gyd/M/DlHu4Lbbgay8OZWmq5fhp5EqBvQUTQzZGa3eKt+ZusbvKxlgA7Z/sV7uKq
         nCfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXikqQurx5u3L1LWlaO0WasTvnBYxYsCLwJffVmdVXYokFvNXDpZ5Sf+lhSAtBoOzG1zE1Vk5f/iA==@kvack.org
X-Gm-Message-State: AOJu0YyZouMhfL9kGSLaGZzPuy/yTvJzgtH/wd8+SEOC4R7XT9Y8jJZm
	BEssveyWVPb1CIpHXossmvSeuoj5tMZmljLiL5wLBjQ2NYx8FrvSBtBDPp4iHD7k1w==
X-Gm-Gg: AY/fxX5i+s8vXGuLzaguFcd4oJfw98VDtMqo5/py/lqCodxiQvHEYwalRzOPyps+ijp
	DKoK7xZWf4iEeRQyl6a5+CY6Hha0VQMJTrd9s31gHqSqGzTbhO1MwW4AOqi3/6I6pp1LYK/ie47
	XS4fqHfaIWbbWPDC4XNsH4+er4veW4iWQtfqN7+Ll+i3msYLs49HJVM8M7LQWu+9nJlrurq9ZIK
	9jAbUnkD7Ha3wAoqaxXoCC107kB/NVHsT/cvZn3je82jIv/PKD9xL/GYWPzGMH/UCE/a9ShBuuS
	qo5g4UDsaNlUdNzL72EFIQRdnto3S5jeGNiSYdXVP94xI+c/jIsGkxEcfe3lDSJ5YpoMsoIf/Kh
	+yckutztlrgVqDsWwLuwwQU3uCdKm3s6bAtv0eelgl2ww/by58RQWe/Efp6aDXG7LwONpZjs1rw
	p90xYfm45Lg7z0Et91jYhTt+zxO/XuQ14tZLXvdc76hfKaR3iB6PAR7qkvcnR/xudC8ywMhZA=
X-Google-Smtp-Source: AGHT+IE/UYWvWx/nJFV7pIAxmMrHkR+lE0t2mrgPpTbjSQpL/ST9/mf7gIbX2nmyWaYnzBbvDqZ7/g==
X-Received: by 2002:a05:690c:61ca:b0:789:4f19:7fb3 with SMTP id 00721157ae682-78e66ea6d0bmr7619027b3.68.1765511811239;
        Thu, 11 Dec 2025 19:56:51 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e6a40fc41sm864367b3.29.2025.12.11.19.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 19:56:49 -0800 (PST)
Date: Thu, 11 Dec 2025 19:56:38 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: 6.19 tmpfs __d_lookup() lockup
Message-ID: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 672E11C0002
X-Stat-Signature: 4akawn59g59yuzok7zigng94c5meyyrp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765511812-398290
X-HE-Meta: U2FsdGVkX18X6mJK4i4Hkr7RSIJ/msDhrVZGiPkJ74mVjP2GsxoGu9CAL/KX2Sb/L7Q3viffg/L8MuMnEPqM3C00VKCIEKJForkwmNB8EjrBTpejWCu+D4ybYQYtPQ/Rwz1kUwwyY5JovMDs/FbSaPH3l3Zj/aRYXcI4XC5nZcyg9gF2XrUrsHd6PwrC1zX/cdS+5GqlyeGvQuuMGxufoSuoMZ29LpGBW36chrGIlI+0C54/Nb5NniPzmly7HTnJmneTa1pn4P0SQF95fvv8bsTButYLuh1MzksTuWR0JHtaS7f2I9OPkj4a+Rhb6yZ5KqQnkEVSH0Tb1dPl7Sr+my4SCMTZ0B+/NFjfpnYX4ZkJ+PZUO/AA+0FVTqBqSN+AzxeWPF2wltcCH+KwL5QLG84jRr214rW88zro2S8mR5sZfOaESL+lQCqkMVO3fyQfbblmWzxs2Sey+pN9lNW7yDcdOiyzWMc2HdKaafqIL5+b0fctMRdBkBv6MEHiD/1EhCmbo7vHExxWB/byB+NwXtMGQ50edXcaRTjk/Q89p/6e42VArmn0cq1yprzvM7jVAwtT7qh/ei+4rWrpZegdIVINkIKnWD6fwTHZghDY5OKWH7xrQ9tCC2pZWK86c2iMIpkN6rpFn58XTjxCL9NiIqdQEruRieRnc2bMrBaj5TL/1783ZHZOHqPVPWhQdLAcF0UoWcKiSO6Dd9J67ql+YmoDPaDUV0xntW4OLBDUYY5pS5OfIdyW7ZlMzOlDBdLynh9Yhf3Tme1JbVT1EOq8jmATyquSi/8xZI/tWyJuAtxK/vAEbtR0L3zXHDo2/GZG6t8uGdn8jH52oEmsTz7MNB5ANn3/6s0mEiOdpR/YrP/gnTIF7uoJFDV7hwWob/Ew2Wo7LfHVcnYANlDGvBvHdXKJjq3Tj5zpjXVIgIbfPpiVxCspT1ziT+8uvGIC/zjfP2KbhprCn2HA3R4dnqO
 /+uGlO/7
 10/Ww/PCC+PKcIZ2zlUbuAJHPD/LyTiFLlvWkGDuBGiSP2a+dUCK9u809JHOne57aYCf15s/70SCuRfLLMjscF/Q9dU2TlCOHBwbdPyPhGe2fBlx1vpjLOO3hF/zs5DRTxkfSiMwPOWt7DN8CaXCYEXUs/2946zAeBiETa4hT5rP3LnQx954x+ihy6xNBSDM3oyiPtqls5fl3HL7hExXRsvhMI5NJmv+ZAYO+qwUPEA274/cWqiZ7QVxAsAikrZmbjNgyukDMjZXhm+mjonLFBTlEzYQ93YSYA842gWBRy7q0UokY5fSlopRhNhyGHRzbGvbCctb0CVQHc1CmI+50fy1RhHsE0HguTo1NoMasetzXTI/38MyKXicPL44Pw7QF4jMdXG13wZhtj3wtDkQUvqG46A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Al,

Though good for ordinary usage, your persistency mods for 6.19 cause
tmpfs to lockup in __d_lookup() during several fsstressing xfstests:
fairly reliably in generic/269, generic/476, generic/650, generic/750,
less reliably in generic/013, generic/585.  Typical dmesg below.
I have not spotted what's wrong: better hand over to you.

Of course, 2313598222f9 ("convert ramfs and tmpfs") (of Feb 26 2024!)
comes out as the first failing commit, no surprise there.

I did try inserting a BUG_ON(node == node->next) on line 2438 of
fs/dcache.c, just after __d_lookup's hlist_bl_for_each_entry_rcu(),
and that BUG was immediately hit (but, for all I know, perhaps that's
an unreliable asserition, perhaps it's acceptable for a race to result
in a momentary node == node->next there).

I did try hacking on xfstests common/rc, to allow ramfs where tmpfs
is enabled (and _df_device() then needs $DF_PROG -a to show ramfs).
I did not get a lockup or crash from any of them on ramfs (and 476 and
750 actually passed).  I don't draw any conclusion from that, maybe
ramfs just does not support some of the options which help fsstress
to generate the issue; but it might be useful background info.

Hoping you can soon guess what's gone wrong,
or ask for more info, thanks,
Hugh

[   54.354788] run fstests generic/269 at 2025-12-10 19:40:16
[  114.660512] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  114.670705] rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-7): P3185
[  114.681006] rcu: 	(detected by 6, t=15007 jiffies, g=3377, q=6940 ncpus=8)
[  114.691346] task:fsstress        state:R  running task     stack:0     pid:3185  tgid:3185  ppid:3059   task_flags:0x400140 flags:0x00080003
[  114.702226] Call Trace:
[  114.712908]  <TASK>
[  114.723528]  __schedule+0x67c/0x6c5
[  114.734245]  ? __d_lookup_rcu+0x7a/0x9c
[  114.744921]  ? irqentry_exit+0x27/0x35
[  114.755547]  ? sysvec_apic_timer_interrupt+0xa8/0xae
[  114.766300]  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
[  114.776953]  ? __d_lookup+0x37/0xad
[  114.787357]  ? __d_lookup+0x2f/0xad
[  114.797700]  ? d_lookup+0x2b/0x42
[  114.807970]  ? lookup_dcache+0x1f/0x60
[  114.818265]  ? lookup_one_qstr_excl+0x1a/0xbe
[  114.828525]  ? do_renameat2+0x1d1/0x3e4
[  114.838808]  ? getname_flags+0x4b/0x17a
[  114.849093]  ? __do_sys_rename+0x36/0x3e
[  114.859363]  ? __x64_sys_rename+0x11/0x13
[  114.869634]  ? x64_sys_call+0x34d/0xe2c
[  114.879797]  ? do_syscall_64+0x53/0x123
[  114.889820]  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  114.899748]  </TASK>

