Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0B5E88D94
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 09:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECE46B0005; Sat,  4 Apr 2026 05:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E176B0089; Sat,  4 Apr 2026 05:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B39E6B008A; Sat,  4 Apr 2026 05:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1B56B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 05:11:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DE7AC29FD
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:11:25 +0000 (UTC)
X-FDA: 84620304930.19.76064B3
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 36FEB1A0007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:11:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hATXEiHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775293883; a=rsa-sha256;
	cv=none;
	b=mDhx8kIg1Z/LB82WGyky6d12EY5N+4y6uHV4lIW90+V+D1A4ZGKJJZQKLrWjnA6LxRblkX
	LAfdccnS+kO42Fsw5vOo3l5ANX5u9PM4UxdeWK13uPUN4XGvD8prZPyitAWfuMjKdGE66R
	AN+oKuBgBZ0V2anK/ig/ckQvi4TfU7o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hATXEiHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775293883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mKCgOtEX6fdxiOnTa/jmRynhm9AIpzYWnO4gPE67L4=;
	b=7KgBkutwZu63bpnzkoWIjVPsS17h3sW4TiyOMNOT7oSzw7Amp5qFXnERLB7nVcHw8gD4bg
	K8yg35ti7s6CISadw7GmvW9Sa9DY8HLZf5A/gPem3S0al1ulw7NGC1d5+tsqf0keH1TZw3
	6v8nRkJqayy7+I7gfmSyAPX5vAN/CFQ=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso1757992a91.1
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775293882; x=1775898682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mKCgOtEX6fdxiOnTa/jmRynhm9AIpzYWnO4gPE67L4=;
        b=hATXEiHRRlxoRdjLDhacxL7qEiLfUaLPKOX7DS159sJ+sZziB0Z0SZZBWxvS2CP+5W
         7oLCdjzSuMfFB6dQW1RO1Ie9Pq3GGe1iADUl8veUit+fHwzSVZ9RveCrKrqiYZ35MD6t
         aDFoB5IhP73KqHmng+BKEPp63TDX+KG6158O2HQ4q33eD8eWlp8CCWO3EGYqMY6sw/1o
         NoTrpoPrhqY/iE7DkRLkPhl3tOXBnkz4uup6eZ92ed/AXLWznQAFKic7o0EVvUqGS98C
         1J25nzDWA1r3BUs1UWRoRYlO78QtY+LahMPbfUEirKunQoh5xo6yN1M68CjI32eRV1n2
         Gsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775293882; x=1775898682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/mKCgOtEX6fdxiOnTa/jmRynhm9AIpzYWnO4gPE67L4=;
        b=eUIFUeo2C3OcLNdMpUDklmy0V4gsxBTRSO8/7ad4tyNiSthwtS+kn0qwPPGPxjBRPk
         afl1j5E8Japi0gESaKJ9mMUTmFadkuRDKemB1yrfgY8ZVmCcXDI6p4Xd9DhK37uhVya6
         G/EnVLE5KDjaPB/ZSN+RNTwlcIJcW89sYpJJhVqj+Vww9vqRX5lXzQ08oZ6b3a8rhNnH
         J6Yu0CF3P52Ri/kqxGLAgsLu6zsgJ4mQRbZOhEYWwmovdX/5ti8AK+Rc8ve6kctQYSiq
         GvpiMBmvmA8ViFl95NT08OmPV3J8djYvhZRSMcOtsQX0PINKptgN/c5PVOHbFgJcLMoo
         A6xA==
X-Forwarded-Encrypted: i=1; AJvYcCWUZXiFrUC/EvrmDBRYeJprevivc7eK6I4nadHyNtt5S/UswX19ccA1XIkdBegPTdrvja0Eu/wgSw==@kvack.org
X-Gm-Message-State: AOJu0YxeMthyyPRdk7TQXS+DJ26vH+yp387H0xiVHPLAa4YbdB8a9OXi
	OG27iwhDBuj/M1oktxzqR7Nh5/AAWJqBoFmi+dsf4tnOTeUUc6d07R09
X-Gm-Gg: AeBDiev28YVQJjKhSJj/oN5qkV6HvsHTc+JBZD38Vo11TMkgwlYUBMuP3ubHP6VFQX3
	h9IR0O2ADgv4EGvHOqY/04Ugjckx0iwiAX4XKHwef+Ukd6Nt9e8j8eGQ0AvMb8aomg91rNpMbdN
	yKCpuiiiPymMjW9cPcCP5Qm2jBGJ4inJxjJob8UNGB5AS2eKJv+A+5NPXzz19/pdLkbx5S7lUba
	Od5qdL6QGll63UvMRvG3obsfossmg6kwkPeEPeJUF2ACggEW+vxydrO3rgc5i1F2t+Xg60wNZhS
	brgqctm2DoHmje1j1QquZmgYRJd++T9i8yl20Vy0a4MGsTjZ3Zl5ZprWdp9RZC7Bg5JLdJjqd7d
	HfBV6MnzW3wyPgxpN1o1qTTwXxmqIm7z1BbkR2pbXFDOnSGDUbX2ELKn4nAs8UFJsPGXnZazNfk
	jOMizaf2iYv8Mmorp4uUZl1stCry7pIOvKN8PuanJDOWsgaY9d7L8=
X-Received: by 2002:a17:90b:6cd:b0:35d:9560:3f09 with SMTP id 98e67ed59e1d1-35de69a5c3fmr4674889a91.24.1775293882050;
        Sat, 04 Apr 2026 02:11:22 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35e34f9sm7710233a91.1.2026.04.04.02.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 02:11:21 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat,  4 Apr 2026 17:11:22 +0800
Message-ID: <20260404091122.6255-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403161906.65008-1-sj@kernel.org>
References: <20260403161906.65008-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36FEB1A0007
X-Stat-Signature: 11zdns87zpnyk18a6fdipk5zf1u4zonc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775293883-267487
X-HE-Meta: U2FsdGVkX183wJXuLzX0wqjAem0BghhbjOhA0OvRc7lnS7rpY0xEdKxv5f0GyrW06CGEqC137LXtH4U1KCrjhhJyr9r1mRt+EYZST5TbrQaiYjX8d7P0Y45WviNQhxnva/OXy9SJNNtN2WV5c1RdFJ4768z5TOaLwc0yE9H79DsT+3if4OsEeBQaCQ6CJotFNrjRTJwNU7ANiUdcpKwr3hGNAfmeu07dStFbwHw9TQXchqyjO0+t2oZgIQX0D98xMI9Wi7xRNnsVx/iqLNlU5Wt5NRp+mNzZX8e5/6bsPULGZxSY5gvNzQnI+dOM+M0Coqmj+V49buFJrdw8hW9lM/MNdD3WG0VJqGnFS7ZBzy0PwbqzyJxSYPJQ0LViA+cJFfKC8PNt0USnCPq/IJVIO1awpk4NuFXKxZYOwvmUdXJtanQj/X/L5VIkGqh1QbHevtqQVsqL4GzRehWManzKVT3uRdOGi+7i7zqe8V+oSu/iJ4KWr9nlKxktD9rPFKWzhF9Ftm5EbqX6h5+7CCK0XbF1qsc9g3yJyAoQJBTfxaQrBBE6BeeFtWcizD9lcun3De9iyjA1PYOX1Nme8247xNk3qFS5b9Q41nmvkZtJe4u4TObCeeguNnfVoMmLc/wPXtqtWQ2YRj7+/iXkrNHjGcXybxw5mQniWOniQYGBT8ySD4npZc7NKW2gnSYdqcU2ZjoGoE8GqES2Y4QUb1HznedWtqytgyzBLpUSjqQbAEGkx+6aJ61QZwm1SOCjsx6DWH1i5fXe/MQPGXnPdIMKyRrzW92f8a3rdK0MWD/NQEUxlAUoXNj73wpiS+4ps0gzZ/Z+BAdOzkLtacdOYQravG6ndnePpgoJOqr73m4V1yzwWrGqcmfm0Hc0pKpfAd/hD2w4zEhY5psbSxAtV3IxD6pfbtrlGrLc4JSYvLRJTygr5alBWKrAVYRceQdmEKm02SQGCs/oo1j1Tr4XW+H
 LHwa/nzV
 1T8dnhnwHKf5z4E3xXjjmjLnmAExf+a3uoh7xA5hc8WcmTsPAnkAXx16d7WU36S3Pv3tjJoHnEcERj9aMi6BkUwYIeepfRZzOEiFwPKGNwuMqLCY+b7Hu6mXNvHFvmY6vU/8kvxp98aWC2iRS/6E7IF3Zd+fhHKr5sZI13WZuMqGY+BF8EIPD1qstupI6sMS5a6OZz12GuPT8qKmglYVXmVKXXn2kjYpFSGEBsdo39B65O1YLQhrq0dcPNovex1mNruGyh95bqQc6I5uOMfxhc6R48pICEwY14Z31ATqPf3Wjgx+XTyZCsiGmO4C34aeqyoRAYbbXodp672KwdOVn+vVLKEIC7jE93Gp0JfUaDXXBaEwsVoeJwiYs5Ohxlrfw3eFl4QxBhw8G4xp0hVzMcByxWfRbY25C+amjoUxLW4vZQEOlIFyV0CFenIqz/X+TDjZPVOUnLaeUTRz9HTnMsfgmsMdZazW7EXetBiWXRuJkuMn1VSqdUcl7BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Fri,  3 Apr 2026 09:19:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> As Quanmin also asked, clarifying the unexpected termination would be nice.

I will clarify "unexpected termination" in v4's commit message:

    "Unexpectedly" here means the kdamond terminates without the user
    requesting it (e.g., not by wrtting "N" to 'enabled').

> I remember I suggested adding stable@, but only if you think it deserve.  I'm
> now not very sure if this deserves Cc-ing stable@.  As I mentioned before,

I think this deserves Cc stable@ because:
- The issue can be triggered by accidental user misconfiguration
- It causes kdamond termination and hard to recover/restart. Once
  triggered, kdamond remains in an unusable state, and I have not found
  a way to recover/restart it through the sysfs interface without a
  system reboot.
- The fix is small and low-risk
- It improves user experience on stable kernels

But I'm open to dropping it if you think otherwise.

> there are multiple patches to review in parallel (you are also having such
> multiple patches in the queue).  Please don't expect I will follow full
> contexts especially when a single person posting multiple patches in parallel
> every day or two, and bear in mind with me.
> 
> Sorry about the limited bandwidth from my side.  You could also simply slow
> down your pace, though.

I will try to adjust my pace. I've also noticed that the quality of my
recent replies/patches hasn't been ideal, and I will try to be less
rushed in the future. Thank you for your understanding and suggestion.

> For stable@ Cc-ing patches, more clearly describing the user impact would be
> nice, and helpful for judging if it deserves that.  Could you please elaborate?

I will add a "User Impact" section in v4's commit message:

    User Impact
    ===========
    Currently, if a user commit an invalid 'addr_unit', kdamond may
    terminate abruptly. Once terminated, it cannot be easily restarted
    via sysfs, pontentially requiring a system reboot to restore DAMON
    functionality. This patch prevent such termination by validating
    parameters (addr_unit and min_region_sz) early.

Best regards,
Rui Yan

