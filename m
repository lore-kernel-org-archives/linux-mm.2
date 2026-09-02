Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D8FC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CDA6B0088; Wed,  2 Sep 2026 16:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCB96B008A; Wed,  2 Sep 2026 16:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBF96B008C; Wed,  2 Sep 2026 16:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 505B66B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:42:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D28E040320
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:42:03 +0000 (UTC)
X-FDA: 85169994126.25.B315712
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id E60B9180004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:42:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p/CzL+ld";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788381721;
	b=6ms4AjG8ntYieDiOvfUMElBzeSnd2ownXw4qu1fPvxYsdyDGQjK2hzj75Y1SIAjclChJgy
	J49jvB+/lUGXMsckudvy4QmEbZKvnBvlJofxjSXogMZb+YS8k3dfMMHTjI+t52vxrsJoIS
	qGinRINn7UOTt1DBEKCYYWFkOnq46ac=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p/CzL+ld";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788381721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVhIXvpFzVpDu/8jrbjniSLr8dV9PsbTGwAGD6Kvgqc=;
	b=4+ecnibtwBrlBiJljLWaTAVB35qWqHQOgFgNsj7dDyXZCcCJk7nGOKvKdIESzyss7zzsEP
	c6rBhqoe4u4l1UvpXdnwvpK3IYPTK40Em8z3p+5mIQ9rm4BotvZUOJbOGvEyXPUHLUTjfn
	NSE59KtqUnQljSmw0y+kPLXiwnx0+JA=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c25366c9b42so178336466b.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 13:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788381720; cv=none;
        d=google.com; s=arc-20260327;
        b=UrdNCG3wdOGuaVuRwqjEl10cNLMQcMh++DuMr+IxIy7Z8P4LLJr++jh84kaAXa/C3z
         7lJeGmMkXCQnHcf/sOwIkWaIOJ4zzncq7kxLyGdW4TQ5wIhsvZu38+rHufzT6YSs+wGs
         IXB+TrwGddF8sfn4vb8PsQlRbjdcaIKfAyhDH1bx825t9S3Pcqgu2amx7gRTcDZ6ZOWI
         ZU0sZpxvhAhEeSbJXXoMqKWvxwdKdyRZxjQTO29zbzC+rdHqamelOF61ZpOhpuVFFeSk
         Qi0YGemskikKeNPh8mrdfOh+iQt1mNBWZ/HWRU5OMxHkBsiXUtAzECBn1xQdlC37JU76
         Dwvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LVhIXvpFzVpDu/8jrbjniSLr8dV9PsbTGwAGD6Kvgqc=;
        fh=olz8CFq+g6McJS+byTWI1jICcOLdBi3cKL5vZKBm9kY=;
        b=PSG7fjf8G/xFQfYUf4b3lfnFYAGAXNvRwTukz3umfowzKMYnwgpt0Q1Jye51194fjy
         iSJqbXTfYnOcAJLCGMnnPGGM16WIJWYSgo3bI9NhgFkTPONWviYsPlck3TIDDNKtmVyR
         BzvP9MCh2FGad99i0P/vRggZFFXfwZ5vVsFztPcxgPCZ/gl0XBcEVATPQ+SONvifvD4z
         6qCnBJ76KFFg4xxUZXWJlUIZyVm4m/bz7kgjkLgQi3dOfhveRBAR03+Iz69Z4wHVs2qp
         FYo7GcXGo1wg2aRJlQU5+ENcKy3oCiyuTBGTf3aZx0se91wkCu9H4Hv5L0lfOtsIfZj5
         3MAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788381720; x=1788986520; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LVhIXvpFzVpDu/8jrbjniSLr8dV9PsbTGwAGD6Kvgqc=;
        b=p/CzL+ldFH/YQoDrWR49pDrPcq40RaaJeBNmw42az/lytsCC4naEveqwGZJG5jA/Pv
         PxiST+yJABnpNL38VbLc+QHmik8N6gi+xeS4ujezXjtmaC5THMQQFskDFD1tR9htZIt6
         XcBncSmLKrhtlgtya//OwenjIE+6nUoP0JQSYxjeizfdP8jiytdR5L0EKCZk4RIjOjJI
         HD1t1a3Cd1RcKqshODzfiKCH35bfWJlR1TLZXxJugwBbq++BecmRij1nyUQlk+HYzzxH
         QwqtrwTO5V7vgqAMDSr7qIEHi5/pEXpcs9EOVpXrC1VM1d9ALcgnaRucmSTESV2qIbvh
         p/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788381720; x=1788986520;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LVhIXvpFzVpDu/8jrbjniSLr8dV9PsbTGwAGD6Kvgqc=;
        b=GcgR8FX+FLB9seiZOLhRAVQ0fifdvbKqzDQAQuwDUBW8eGahYxlEKebbq2ptP1ElzX
         f6u4cHjskXBc0eFWrBm88ufDyx3zTKf7Ye4oAyZyRTw8VRY3v7RSarrkUzpASBCGbNvA
         jXandXEDsipbJHAd79kUz61+3LiBbGyAwl+jw0Qx/kAf/MefGxrMj8qOlUg9gFQHybKu
         corULUSRJCWanwm6b1HvNESfxqoabx5CP769DGtZhH43EgkFhG232XRFkB9RAg0cIcw8
         N5ClsWjuzXUuSrQ81v/JpOoLypmvMPcc5BcI+RrAi4faTfyv2xFLB7Cixj4HExg8GY/Y
         WS2Q==
X-Forwarded-Encrypted: i=1; AKwUvBxrVwemVogwn+aSqePJT9bGJUzJN/KfFl8MZvaP8cxoAaQiPj4KMKjjzRin88WtFizLIpp8d0Dr0w==@kvack.org
X-Gm-Message-State: AFuF++k+NAUENIiGf9lK9aaWukZbawXmRoT1zt5vdBKnvlj3TQDUDBjw
	UiLTS3HRSzAGy4zBEFtnY9tAaPXeYwr8NrWIvWbUSaKEACTbaoncULW0R23ehZKGW6o5SzS5wHL
	ciZdUz4yXW0sQJyiuqnSuLc/qiwGmBmiFpmqd49/0
X-Gm-Gg: AYBFou0848tVAD1dAJQ1n8072kWizqOtbTxmq0GitFO/dFbFAPn2RQ3OFMr1jBvcudv
	1ty8++WBMaz/VGcObvLtiDxkJmljprt+lNOxf/IZECA2XUXjHLpwTiBIo+sV+ewuAyS6pcWaqPG
	BlOT8x3ZBcK0ks/ZZEf4U3BPnWphZzxkul67TtazmgEM/Mp50vAHZRFpqt3AFAs7cBQJ4dVD98A
	WdjEU9B6UIy+lt2iW3nWo5vp51tdgbvnNsaRBAlOE0G0ICfRQphbD+dGGzbaXmosat0bd5gI02l
	Tyl1lh4ZwmV4jidPuDu8Kx65upEmO9+eJAki3MTNXjiCFFQ5fXCqGZbq1plizOenlCBzoSranUt
	Xbj1h4DTMkKUSlKfmHEEyQVCmUEcjKqkNi3cI/EF2MD5PFp6W/vQO0zICMHqUXSWpupAoOQHQ9Q
	Ltts35pnMfcFVU
X-Received: by 2002:a17:907:c78a:b0:c25:541e:be7d with SMTP id
 a640c23a62f3a-c25d55b8807mr567367566b.18.1788381719836; Wed, 02 Sep 2026
 13:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260828094703.11081-1-lance.yang@linux.dev> <20260829052606.49470-1-lance.yang@linux.dev>
 <CADrL8HW3=n8VqW+7YSb2kyhkHidNKGy32+2s7A0OfF+oYoAifg@mail.gmail.com> <apf5xBqj5560JlMD@thinkstation>
In-Reply-To: <apf5xBqj5560JlMD@thinkstation>
From: James Houghton <jthoughton@google.com>
Date: Wed, 2 Sep 2026 13:41:22 -0700
X-Gm-Features: AcwNN1XNWP54Rwi-EWw78kODWTxBfe6WSk0GmMqznEozoElZj8yD1pyZq6NZGNw
Message-ID: <CADrL8HXg-Ybh9Lqgo08VSCtyD=8byMOZZJqEDgdr_+=p_KwYaA@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, 
	shy828301@gmail.com, zokeefe@google.com, hughd@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: f9tfeosjeimyo6imodtw14bsr41poh8o
X-Rspamd-Queue-Id: E60B9180004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788381721-555069
X-HE-Meta: U2FsdGVkX1/60VrnLj415scRJV2TKCSgolWKjr0UJhkN7U09ReIrmr+ZPu1Ndyg9gkrZ7x3fxIDTDsNzkBZw6bMwU8zMd+pUJDiMeiJsaaqwiskigvC5I5v+sEj7lf8FMLdCzHDnOAzb+UCpp7dgDcntfj4GTRw0Dc+x165uCYzaPSWOvBVFyPm2wuTsKTutHxbQ7zyyEneyyGCdJMJpMSav6mUXOc2Zfb3SsFN0e8Fe8HBSE6I2WBdaXGk4IvVJrVepV+ek7GkJpvkD6pyS3Ul8HqWJHVk/Ovaw82tqehd0VPwN2CuhaXIvhdzjQYnC3rkUdjoRWHoiB+uXvwM/x4lirwJqhiPWLlW6yui6EGnQ+wAAjHFvaLpBpkya68JfckSnEvNebhdYOcdmGUZD9UA6yCbC/sVzpgaVuLFT9bu3Ct7fwoKp5y6fxKXWhqWkytkUp/VXTT9BWYDm6EoaT3qNEzdCeI59Ls5qBMCJJ/WqDJVTLt1w8SKjFybs0t7Wvory0pw4Fu0ocTmN1LvEAKULemckRRzy7Lym00kPEpVSxc42+MR4t/x7o11X11UPrMQWi6b3WZFQBP/c0aK/1bHiu6R5k4cBb72Q2nLqtTqG9JMs6PW3xW+zShMJar7LFuFAbHQ0bdLVABzTuEfP8G0Qcp7zTt/prPvbmw5zn68/98nxfOoDnG+p71/lljpaAfDl+t0YbUeCpDANB7SQZCVSqH/CRInDMc9yPQFjKQI/+B2MPucZ7zvDuc+id7QAC6o7amf7mtdMMysY23PYskzjX0VCbAjsKYrnsGvA8J1G8tBcBdzcwWBpznx5fYJLlTr2pTNMLfrRWh1Azw57UU8hVhXAJYDAACJFYwiaIWmEMb/izqQkT0h+FgKL+z5+KM8UN3FR2Zz0K+ko1Z2K0QMRP6qUPyEQ4GqgIwQyY30leDPpz1bMTtVjqmrKFkXyONS1O1bUO24A6hv1u7y
 giZ6nven
 lG+U3ZbrA9w64rcpsK+cda8en46VR1COblkswoNS+M9DzCEKdzG4vwHWYjWi0ZJghMATF4vhH4tvhOPuXIUaJgCxmpDb8xf2GLGVHd/R+YobC+PoRPRsVBW/NA/lMImx6MuKwBxkg0s7VeWV8U7BYHh5zV8s2Pasttxq6+5fKbt3r80OGLw4AJuv7JTdFh+JijbikXO2E9XyubPKUbiNc/9I0ssbFV08pjrZb97ENRkHnWp1KAGBqI4/t8sSir8i5WLoYlnH3inhywJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 3:27=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wro=
te:
> On Mon, Aug 31, 2026 at 09:51:33AM -0700, James Houghton wrote:
> > WRT the semantics of process_madvise(MADV_COLLAPSE) and normal
> > madvise(MADV_COLLAPSE), I think it makes sense to always disallow
> > collapsing of UFFD-minor VMAs, whether MADV_COLLAPSE comes from our
> > own process or another. UFFD-minor faults are intended to be resolved
> > only with UFFDIO_CONTINUE, and until someone asks for it, I don't
> > really see a need to make MADV_COLLAPSE actually work to resolve minor
> > faults. I don't think userspace can *rely* on MADV_COLLAPSE resolving
> > minor faults either.
>
> It is safer to go with stricter policy: reject always. We can always
> relax it later if there is a use-case and reasoning about the interface
> is solid. We don't have it yet.

Thanks, Kiryl. Sounds like there is still value in this patch then.

Unless Lance disagrees, I'm happy to send a v3 with the same diff but
a rewritten changelog (and no cc:stable) reflecting that this isn't
actually currently an issue. And I'll include the uffd selftest change
as a separate patch.

