Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93303C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F696B00AA; Wed,  2 Sep 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FA66B00AB; Wed,  2 Sep 2026 10:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C176B00AD; Wed,  2 Sep 2026 10:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17BA86B00AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:36:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95A02160229
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:35:59 +0000 (UTC)
X-FDA: 85169071638.06.83323FF
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3250180005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:35:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVZZsbF9;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hr6y/ERn9mwLYkItat9vlE3A943++Ow9sTB6oJwTNEA=;
	b=28fAIILGrsdwW42brU+3sMf47qGQOP+jHikcDCSfvCW64YxFOZzrguB8i11iQ6C7WmtZ8I
	7QheF9Yb/PUot5IMkpMG23z00UWvpAR3O+jDmGHtv+Uvw423Dm7pFFJLaMfaETiEo9CP8I
	YV+cmwNSjAqhGu+ZHt5qB3JXyXGOh4U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359757;
	b=0xzi5y5Gdo/hgp4fpU/qeZQOAoaP8jsKBMuUobpZQp+2cxb3q/OKFjDmu8BAHk10R/lbFl
	QGeHI0rkmOp6SP4zK3mrIG/b5IpOKPxk8UfHxyJ4r7c+rChOqSC4m86wrxnCA0F9gGfzQ6
	qMtJR92Sqrxc4qETxE5TL6HhxUrBfCA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVZZsbF9;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-851cbd64814so433982b3a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788359756; x=1788964556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hr6y/ERn9mwLYkItat9vlE3A943++Ow9sTB6oJwTNEA=;
        b=rVZZsbF994GnJ1CSmNS3S+pPbVvbuIJXeWMtbw7abvVPd6lxqLJ3qRoVIpb7WZUrsF
         WT4m3zT2R7FkxabuoBoY4otLNK8TfhQbndtt7yxE+asU52J2t2ijlBynuJ1cKk27GJWN
         8gQBPCY13gUwr/hbfSGrmGXDJCVOPifqyncfZNTiW50VH+lve/ZZ6vzRLXbN7ewgKNJS
         DGgyYPU88Kji5u479b4D8T7Es9p1Ynbo93x7XKAfZZyb8bXTaZwIZldPSbTA16f8DtEq
         Bx76SUdDFyU7ZiSrgT5noLjsuzgYpgu0ms+T+X5mcsU4gpMTh+Osy30Thl+7oasxbptW
         wpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788359756; x=1788964556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hr6y/ERn9mwLYkItat9vlE3A943++Ow9sTB6oJwTNEA=;
        b=PsN2jvYtEX8elZCDFCJmQSbBHmJ0yrzTSjxfS3LGK1hGs0CxG27p0ob5uSn2fVyuj7
         sD3porgpFNXfgxCNOw8T9QyEydU5M0SD0ufdTz3s1K7kZRDQitjH/AaDdh5B+hiTwxFE
         eDu8NREUuWmJzuyJSXvXhDsQZtb4tjUmY9m08itNR2Z3tuw+rwYn+C3vGmKalS20XAoR
         vGCe1vkQgWIJmnAdDj1TGFB8EzYxDFV7JpmRCcR1xIkfWOsPYBAyH9Lr79kLa+JRRPvk
         OQZcp0w0viloNHxfvHVMkgaAANEJd5NmMkYJv39hpw8u5044IP4ZKP0fWljO16/IyCVU
         72aA==
X-Forwarded-Encrypted: i=1; AKwUvByTSUegQPmDX9iZD58q5LTk8zr+D4um8QDEx3QzirDVEuH4zehvb7VmLtSgfQBOS2luvpKh7tKq1w==@kvack.org
X-Gm-Message-State: AFuF++ntpAFm/Z2nqBy793fOZ8STAax3krX5+igctFivc03CGZFibTyM
	6B6yEC22gPvs5Llx3lrLRTF6SQGHWrk3GG7AvdYjL0Clm9dkDj05NoEe
X-Gm-Gg: AYBFou0O06wcpltF+fEJERig1ciEjul0ZPMWvLrxhF3Nw/TsO2VQnOU7Iwo2D2AxGjT
	Gf2qG8FJd505PfQFaOHcUz1V76k578RYYjAba/Mo17K8F/DQL5zRLp9Hcb8HC/QuIQ0u97i8+Bj
	e0MmQG0IwphkjtVcEeUbRzsjSBiE24T2V5RwJFoaC0wl4OYkxdaXmnHA4xhzl70ROxy8dGf1zQf
	a8dbuGs5lqoEvDoA7ASO/k93vBCElIyJTUXpFJaOt7XkcWplQOW2j3lZoRUcqk9CrVP8QSYTIbf
	kVq7geBw9WiWJwQyOKDS3xt1Emj9O7J8mU1scM4iBYkeWNqak2Z5p47KGgb5Gt6l8AkiIrmLZtb
	p2g3luqYTHyWWwnGArZZYSmfntaAlnsQQ3bSezAciwUkC4cMHbd2406+50/BjMC86GXaRD97gRe
	BHlwMp52t5PtmXoX5so9/RZ01ZifrVQszRvZ37wzKwR1070aqvxY3Sy3N5Y/Vi+bw+wsUWMskDi
	Yhc6FYnp2Id8TFm
X-Received: by 2002:a05:6a00:1c9e:b0:857:73e2:9104 with SMTP id d2e1a72fcca58-85ed94bb41amr7949304b3a.20.1788359756325;
        Wed, 02 Sep 2026 07:35:56 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm1560348b3a.4.2026.09.02.07.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 07:35:55 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: allow esz to be set to zero
Date: Wed,  2 Sep 2026 22:35:20 +0800
Message-ID: <20260902143605.6785-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902141349.86896-1-sj@kernel.org>
References: <20260902141349.86896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3250180005
X-Stat-Signature: dq1rwot5po7g3gbibaj71pwk83ma14yn
X-HE-Tag: 1788359757-621708
X-HE-Meta: U2FsdGVkX1/eAYkYRXPUj0XZHoeL2IToJApzUne7ZN2s/M9nxXWdUhd3ixXz46wcABgDc9FTWOsjF4E/N99KSSL7sqSqwrBTrSDn9HWG+N47H5jWvSLqjE0p9KIxtHuh3AffDvo+x5NxOFOH8iOOr1hqwz/afYNe3JTDWXBUkFFa2b3+mQ2em17yTIVRNmeM5/uiCHwL7Q9s+C5efhBDwbF7yG9/5cjJxLTMjG1kBKXac3bkuY2Jk4WL3v3FbmYzK79VWUx6UCMjQnZaq+6jN7sqGitNywy+MbLZYM3CmTlP4TX5rmP7noNY8i/KMPQfvYK6xKrGCBzzsxIHtQTiiJLcK8vAZ+WYpiQmLxtUOBtgp+65Hh8f6Wp7xEJNmvKZthmMxXxIwWHXeFzLtesbu0pJzE0Buyg9N9ZwbrFUVr+uSBmQ4vADZUkeIC+MBMbiT1smCU713kYeJZmzfQJYSTopCEu1gq2RPzKOQtJFUnziP5nVOrhd5nrxoH1YbDEKLij26wcX55rMWz/AuQP2YN+JFrZRHOQy9GyN+FgvFOk+PVarZJWg786LEX/myV9krr5rS+mI5e8DqkQswdMDAdJD8qfHctKa0VI6S8ERUF6I83YRCGfCW+jjPS8Is0VMhR2WapJQjDd/URm+KHVrM7GsGKDSz3Zl1apLH3o/ewr7YLtZRL6ogtvqdnwdA4OaxNP5Jmi886dUFqSCJNk2CTh7z7goi1lhyRhVunA9G8bBoob7AeJQwXZDxrJa3Mjj8dCXaBOQZOy0swfGL79kWU62D4IvHy6PmecHmWYgWgwz1j8bcUovuNZuTkp4GD3nK/UWujBrcADu91UxJaWSqSFoIVJcE7O8tV4idgbweXWdmi5jgjHEEdDxhhYEFzlnyGJSZ7o/iGVjkv/V62aUEcBhr2xtLTJNqc4fWqGIE/fmW6IxkCKwQI4igEuYzkIBQAKXnZf9XnS7t41qTON
 h4yk/M2w
 jSSgpvwKLPShyxcH77L9VelTa8b+1mpG94WnZEwGHQgHH0NsZznxQYNZkLTGAglNzFk2cZTOAeyTdRk6gPJn2f1ZyTXrH2RZ0rgVZ/mgtLr/sC8HBF89Im0DxdKF1mMoKvepo2O+qOHlA/Afueh3LfSpVu+pHxu39R7tk4yJA10HudmSWTmlUoT1k8BEq6jjgFRMPmRCiNXUaaiY1a0VFSYoI6gafKY7KmMWOIMjojMn1XxsWxBcNtwxrQg11KxPdK60s6kEQVlUfZ9ExkxiCb0X+j9fDL/drvvLTIC/0BNUTeKnOiBj4tc6NUfBzlMKM4uXvhqEKg9KfZPzEfa1mF3p+JKHwGHuiiMaCPWjqUm+AVLq9uNZAdFQDaehvBPANBEEdPXRCsGgUJ4mFsIuTmYGs7ratS0h4cc5n9YpmyyAR5Ttgb8WkPyaTNBQ51c+d7U9+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 07:13:48 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 16:20:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > When the temporal quota goal tuner determines that the goal has been
> > achieved (score >= 10000), it sets esz_bp to zero so that the effective
> > quota (esz) becomes zero.  However, damos_set_effective_quota() clamps
> > the quota to min_region_sz, preventing the quota from ever reaching
> > zero.
> 
> Where in the code it is clamped to min_region_sz, when?  And what user issue
> this can cause?

In damos_set_effective_quota(), when quota->ms is set.

'''
	if (quota->ms) {
		if (quota->total_charged_ns)
			throughput = mult_frac(quota->total_charged_sz,
					1000000, quota->total_charged_ns);
		else
			throughput = PAGE_SIZE * 1024;
		esz = min(throughput * quota->ms, esz);
		esz = max(ctx->min_region_sz, esz); /* <- HERE */
	}
'''

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which states that if the goal has
already been [over-]achieved, the quota will be set to 0.

Original documentation:

    - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
    fast as possible, using maximum allowed quota, but only for a temporal short
    time.  When the quota is under-achieved, this algorithm keeps tuning quota to
    a maximum allowed one.  Once the quota is [over]-achieved, this sets the
    quota zero.  Useful for deterministic control required environments.

Best regards,
Rui Yan

