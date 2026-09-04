Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC343C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88E86B008C; Fri,  4 Sep 2026 11:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A9F6B0092; Fri,  4 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29476B0098; Fri,  4 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 884F16B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:36:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 297B71C008B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:36:30 +0000 (UTC)
X-FDA: 85176481740.12.B107A08
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57A0A4000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:36:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgbGitVF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788536188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owo9HPKkc5Wy9mPuxsDxORlEguNqRT/FIkEdbsJf07w=;
	b=YI0i6x76UQ11Zgc4hNrIB8LWSiUA71b04o3VMSSmWrRtIGF5/ihVIwIpXw3eGmdeafy2qR
	uI8z8XZfhX6wtYjvKGvRXhqXFHD7HEhEFCudgHo2Pu2OulxtqM7UFvvFaFPlsaY1pIvPdH
	9gBJO9d235Xd78r2XBDeEeYoFjY+ctQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgbGitVF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788536188;
	b=6s9GpYb7M9xWYwn1obxeyCm7lmB7/YjYBCQEtiVkxcMYJf6W3ErXNcBSyryHBs1ksyXT+V
	qwycRMjwrk07tCa+MnqFxQmQENdmvufRr3L1BSPsfdKwFO81OF3kOm9p7toUrf7LgfoRW2
	/7EsaYEMsw9SNiXOoDXoYbHKqCmqhWI=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-853c947bfefso991768b3a.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788536187; x=1789140987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=owo9HPKkc5Wy9mPuxsDxORlEguNqRT/FIkEdbsJf07w=;
        b=lgbGitVFFLiaMUvsEf3FTSc3HvnhpaUTMno9lIeDCkkT38H62alRfiilj097eTS0/a
         WAOMpKn5DFpVgSh3Pdq1RSdRvILaSqzmN3k+ueYf9Kfe7jyW/OtBigM6GeKubbi3cfeP
         D8p2xbcy7t6fu+wsaU93I6j5EF3PlYwDAYnWPT8+f7st1q4h89naVEJ2yaI27n5E4kcG
         eB03gNtp/jMxZkP2THJueCxNPi+Lq9w/qWw34HT5AF/N+B45Tr1a3LJZZ6jRk1swsZX5
         36otZVAQQXEM252ibIcohRqU2FElbu5PL1dHn/bXpgFaakJ5c8d988Df2uF+AcYw294q
         eJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536187; x=1789140987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=owo9HPKkc5Wy9mPuxsDxORlEguNqRT/FIkEdbsJf07w=;
        b=j+VcrvXpCkbkq9dCdp5jBKB1nUQq+it38SWvlcplw6X8l6EVvltbICtOnmHCZPAShd
         hRY3OPP6gRkIDRbh/KK/qMLJKDNzKfR2Ux5r+2+FliCmrmvEuhByZkDzLct9TC+YQ0Dn
         lJwOwlPEGEllbHFh+OdWrt5ODacvpQe7IJ2WSGPOmw3rYo1TCVGb7TPNRh/L/myJPQDv
         jSCL6ukXAprvB1Ji0KHpkHY001nCxu/Mq1gwwVxuBSIQEUmB19aSGvyQYUokXADvZtQ1
         Zo1lB61mA5tp3Ob3+ySxAtsFqo9vgzIiAygDmme38scRuhEQniMsVgLlurEc9fFiuSdY
         P2eg==
X-Forwarded-Encrypted: i=1; AKwUvBxYu5avz5KlYQvHa400ubIt5azBaUS2KBvhfN4J89UQ6muBbPauBzHS88ULzbSqtIYWbsNns2dlvQ==@kvack.org
X-Gm-Message-State: AFuF++nQRMFkwf9UQXEfUwP/sdkhAqI4juZaavKEYBAOfpomy3g0gamQ
	hj83NITbsrcjmb08J/nb/Ut/a47Y65fZ2E796nl6w5pcO5Nm3iJ9yi5H
X-Gm-Gg: AYBFou38xD9XWDHNaOzIk6KSzJ85suE+XHF5XTCZqekH5YPm4blHVCnoP8hWsz1g9dx
	WTp6lMt8z7vf8MTXjviPRM9OmG0NWicxcNCWhZlKSfXAofZUblQG8ldZP6unl2a3sAUfCGv//8y
	CC4IhB45L0t2KP71395wIpbMNN74lvWQM3I0WwiNnAtLRS4Uq2UsDCqCqnKpN6ANBUT2CZd+1WA
	owPkWXRVCDtcYsJetvqaXPZNyB1nwLC/fjoe9HNmSBVSU/xbFPBal1wFBM4eSC0BNO7xFwVy+jW
	Lz/5dj4Gl94n2QyBwVV2h0J0tG8qxb0YRHg5HCaiOB4/uUcuOR5d4SDR2XL5yWZ5eDsmOTbW/pK
	uv+ZWF2R6w2jKOFCvyBR0G06vkKSTpVH2OklcG87wuYCg9V939kMIz9WRPDOQ5iZ7LmUnQXVVQ/
	ugCcbKRD1Kb8EeL/z5dVUnw2TMzCWtCTdRHxTOsmVUPfgJqqn4Og5xvUjs7tVz7COf4LOl6lJ+7
	kmkQmdz+UFAwGI=
X-Received: by 2002:a05:6a00:b91:b0:829:b08f:7353 with SMTP id d2e1a72fcca58-8619ae94866mr5005293b3a.7.1788536186798;
        Fri, 04 Sep 2026 08:36:26 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:f40:906:1c06:7a81:226b:e033:d971])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152f32447sm1277202b3a.38.2026.09.04.08.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:36:26 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Fri,  4 Sep 2026 23:35:38 +0800
Message-ID: <20260904153637.9670-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904140535.64833-1-sj@kernel.org>
References: <20260904140535.64833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kfje1qfct7k9uqycj783borya4mhyk37
X-Rspamd-Queue-Id: 57A0A4000E
X-HE-Tag: 1788536188-436669
X-HE-Meta: U2FsdGVkX1/N5Gn01O6JcJqCexTzmuFjYsz2gyECkvwuxF71J3SIXxh8cI0cU4wadUubJ+Ma+hnTwa/Pi0f7x/fvcCBO+zEz15sAjEsWodfgdARUlswU9eOh5nNWez4f58HConqkJsOGZSFMjQIS7sgIvX20PpR7kEmxJT2T7sKxckw1T802XDSNW5FxCl8ypFBDe3WNDzoL0RsZszoG3qaZ79BLgNbTaYUgzNaWM86yMmFZSFRRa4Y8ntVd9u0JBKB/+ddeHTtXGu+coZcKzixeN+C95LaNV4Oz7Pouuw4b8DjT+XBmTF+yqOmqkfSs3CF2tkQuYrOuMnb4UMJ8NRfEr0njhIqW7P7lQ/xs7YQL3o1CcD4yf1QCBttxyaVw0EnDd0s8vhzrMLindJ6kvYKDKMVPxCNp1fbIs1oRSvO9n4LS6UNQFs7uyHDvDgHB+xnM+Li6DXifIN5P+iqivNd/btOHThL7ET5GUi8WJe6+RldfEH7Hk2dVQF0vFjyQ514pf96sS34tsegXpIjDzgqpRHLyW+8Up1PY4aliCFzLU//heDStIwChCrt+vncNydJNzEQf65g7JeR67K4XwaOstcfYB9VM6HKI4JRO4Do0vM0oThctypRhgb2l3JJSRuCj2IfZ/FxGfDSCooUMqMpC66PnsDKYmgqulg5LF/7ACSfU6dHxILAkMOwhdz6LU9i6kQq5XBSXlH+jffjeKYNuJp4cyIenXl9DE2xoEXtdQ+GG74UTgwn6bTRdGX3OFwrH7zU7TXPJUFEvVSJUx68lOYMBcBPnrtbfAFs4IZpekI3mMjvpgH/ElJGqTf2lksbNJgbWadkfXdIGkVfX/OFOsI3TjcBU8LN8hDBcFzDftkiJyRpV+4Iu6sJu8pL+HcVp63l/6NCSafODuP24TYgaKjEa6yRr1/msCWap/VQAr8QdWig6ia6/J0k3FYaasNWQ52RkhOVr6pj2X2M
 6TQsncaF
 +teYS73TsFeDvJDKMqxkvzDtqS/ZsYJcu244izbNEmUCueMbfKLutTi0lMgoBlakEqSwgVfaQtxSikm33k920roNuVBbst/cyR6p//WqvsWzllHhoyuU5TFyLbsfSuX/vpliNPV0aosAO8368Le2urT3fDKec65JtLQ/mGb8w4ftlaLnFG6NX5YBLWlH009JlOi3aFb5Si4XmqNMDDHws79PQEbIXu37/EVezAGau0ORUICMkChKbBnEzpgoH2woIhAfTXWNfQ2aR158csPzYerKv5NvCajDNOwHOG98WV4+fg1tpMqAf4OCDopIqeri3qjhrie3VVXFTS1lUDdISbB/n76NfGJ84NchG4krhUEKKfWVDfqdfmyB7X5qrI5APH37YgpkXa5yT+a4F/ZEsdEPnU7EnWj6QHW39u8/UOu4DmUnwdWXyybKVutiQnGH6fC3IXrhI1vFim1Wh6g9jLl2m43sy5W2veItkqMNkUIBzqa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 04 Sep 2026 07:05:35 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri,  4 Sep 2026 16:07:41 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > First, I'd like to clarify that this isn't a problem encountered by a
> > real user, it's just a scenario I came up with.
> 
> Thank you for clarifying this.
> 
> > 
> > 1. Users sample qt_exceeds periodically (e.g., every 10 minutes).
> 
> What's the purpose of this sampling?
> 
> > 
> > 2. Within this 10 minute sampling interval, the counter aggregates both
> >    the real quota exhaustions and the increments caused by esz==0.
> > 
> > 3. When users notice a high qt_exceeds value, they eventually realize
> >    (perhaps by reading the code or documentation) that it includes the
> >    counts from the esz==0 state.
> > 
> > 4. To get the actual quota exhaustion statistics, the user is now forced
> >    to perform additional testing and implement external filtering to
> >    separate the esz==0 increments from the real exceeds.
> > 
> > Even if we explicitly state in the documentation that qt_exceeds
> > includes the esz==0 counts, it still burdens the user.  The user still
> > has to figure out how to filter out the esz==0 increments externally to
> > get the signal they actually care about.
> 
> Users set the temporal goal.  They can know when the goal is achieved since
> most of the goal metrics are already exposed to user space.  Users can also
> show the current effective quotas.  I agree that can be cumbersome, but how
> problematic it is?  Also, as I asked above, why they want to do this after all?
> 
> > 
> > Honestly, I struggle to imagine any valid use case where a user would
> > actually rely on the qt_exceeds increments caused by esz==0 to make
> > decisions.
> > 
> > If the only purpose of qt_exceeds is to let users "easily notice" if the
> > quota is too small,
> 
> I agree it could be a signal to show if the quota is too small.  But the real
> purpose of qt_exceeds is, in my opinion, letting users understand how DAMOS is
> internally working now.  After all, how much quota means if it is too small or
> not?  That all depends on the real use case and complicated things including
> their SLO etc.

Thank you for your clarify.

> 
> If documentation is saying the purpose of qt_exceeds is to show if the quota is
> too small, that is what need to be updated.

I completely agree your perspective.

This is the current documentation of qt_exceeds:

    - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.

Although it state the purpose of this statistic, I think adding a
note to clarify that this stat also increase when the quota is zero (but
not unlimited) would be helpful for users.  For example:

    Usually, a quota of zero means the DAMOS scheme has an unlimited
    quota, so qt_exceeds will not increase.  However, if user sets a
    temporal quota goal, the quota is set to zero once the goal is
    [over]-achieved.  In this situation, qt_exceeds will still increase.

I can prepare a formal documentation patch based on this if you agree.

[...]

That said, it's not important for me to add explanations to the
document, but may I know why commit [2] changed the behavior which
introduced by commit [1]?

Commit [1] Behavior:

    if (quota->esz && quota->changed_sz >= quota->esz)
        s->stat.qt_exceeds++;

Commit [2] Behavior:

    if (damos_quota_is_full(quota, c->min_region_sz))
        s->stat.qt_exceeds++;

Before commit [2], qt_exceeds will only increase when quota->esz is not
zero, but after commit [2], qt_exceeds also increase even when
quota->esz is zero.  I'd love to understand the rationale behind this
change to better grasp the design evolution.

[1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
    (Fri Jan 14 14:10:20 2022 -0800)
[2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
    (Mon Apr 27 18:33:50 2026 -0700)

Best regards,
Rui Yan

