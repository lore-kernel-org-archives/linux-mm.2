Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5530A606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=i94a26DR
Received: by kanga.kvack.org (Postfix)
	id 348A36B05B6; Mon,  9 Nov 2026 22:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA526B05B7; Mon,  9 Nov 2026 22:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EFF76B05B8; Mon,  9 Nov 2026 22:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E56CA6B05B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:17:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53039A07B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:17:52 +0000 (UTC)
X-FDA: 85417749984.21.F8D3F05
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32A14180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:17:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=i94a26DR;
	spf=pass (imf16.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
	b=QnLO1L5C1ZooU+hBccs4HOSF63e8eLEMSTLifK+f/E5y2HW+Mnk+GdS11OELDFZ0EqTTEX
	j7Yxd+8mQIOhNoFmxyfnq0wikeLbQlHcp8jFgWX8KRdDsSi4qS0bSa9FojR5GbMOXxMXqa
	26injOuIl5bQDW86UEWH4V6En60PtOI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=i94a26DR;
	spf=pass (imf16.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794280670;
	b=ckWSK5hkgCsfXC9/cVlVB5I5i2kohRKjXN9ob2QjGIqBTIP7ETqnz2TY5Helbn2+9vZl/f
	ASRtvprD4EAgJPfv5R4St6NKKDe+18sMoABW3ERC5mGRO8q15lFpp3g6Q5dPBvxTBFoGFY
	pClriUeNTaUidfTvOUgohx5TGniX2vE=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso2405270c88.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:17:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794280669; cv=none;
        d=google.com; s=arc-20260327;
        b=dxWZT6OzYaef8EcpopYyFzvnCqdynz1wKTe47EQGyXHZS0Em+FDY1/85TnJxq5heSC
         jykqOdJALOA6yhHjNJXityRJz6+on/RU6jguPoi6QW2uYbHi6gwrePwVqnrHiV+Kz8J1
         qfm/RcaWAJk3y59aBICzkaqQ7Rwv3quDGsPvV4mQCMrcn2N4qEvvb7V/57o2l3/fjxhb
         RUssS+RlYxU08UIg4SnNt3djVdQL5c6lmx8SPZhlNiKOnlX69Uq5ZNH9Dhirg1gT3upw
         yPkhnxx2QMaWoAExKCaKHM2jfUCD8iqvs9OhrK+2ADW5iRgbV3BaOdK0nAo7ph64j9qI
         9Tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        fh=TM1h55t2nZTg58x5JGx3F7zqjs0aifs00fUPg9imL9w=;
        b=O7GjvnL9ly9xmzr+N9mHdkOKDZZuoAnGSsbLZCRMO5KDxN44M3bPppDtoOKXhXKIsT
         oi0oSIcPPvoHxnymMxrsS97Tc1scosMfOyhzmRmKC91jbxNayJBmkC9EcXzOAFT/gjb/
         qc0tbQfuPZajIR5svRVPpvohfRmM/eca77tTnWAysnKsQgJyzzbikAMWplwiYlCd7zNK
         CNvCqYkJY7qwBBnGDr7jVtFpN2lI97T7IqgMGIqbsI2eb4MaqnN0Pg5/AmKLU07+2WXH
         Gl3XIyIoBgwKwKpmaK18FyhlNpM+cn/+w9NhMc5/aviaKaWG3lQ8r1HMWaVl7NLZrnY/
         gXlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794280669; x=1794885469; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        b=i94a26DRZIPOFc83TRR55O8XXRjwcjl7124LRiOmXurVSQMDW8vk3hWgq5ABLG50FN
         jmeSLBCx9AlZt8P8aZcsLmLtkdN8nsl6eQVkfj8LO3UkGzHLcIFmHtxZAyELR74jOYI/
         x3IK/XLNTXlKUP4Hc1x76zuXa0w8S5lGb5xV96IrcQxj2Ab1N9iC+ZnxUcyXJhIgqnM/
         2RJsr+zv+sPBJwVaraXbPRJXPhukjQ+eYlWW/lFWQwdmsxji8hzvizgzgPMac5VcDqjt
         mJU9hDDkqaCQl+jHYF25zMBtx9TG1KIJoIZliNrR+FCrFgJZ8EejYq9CftvzkHKgk1Ch
         ftrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280669; x=1794885469;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        b=RjjihV6CELpG2fVAwz9k6oDFnbup+mRq9suUiA9ZJPwYvHAlH4zok18ZqZHuYv4/LD
         O6d/YzcsGXU/ehG0C9/6ukQkywxNesysWA4w27qwpfK318w5TDOlbT6LV6ouVu6/l5Gw
         tGXGGv2m6BqAK3ZE+0d1HXBRsGDKL39RqlIcTLFIWpwkV2YM6MB0nlGf+h8u+CJCnJph
         JA/KsHDI2ATziNebOxtmZYZ6k9oFJTXylYscIaDvPAPWsLX5kzLiWl4Zd1Wl+RyJnsIo
         zMDVxQZMhmDhQxOL3D6euBnR7EUE1trDvXkdUKI4arir21u3KpnpMCcHo1gE9RKUIm78
         HarA==
X-Forwarded-Encrypted: i=1; AL+hErG3M0lLz1qSQn3XOlmEECunu0kTYxgHQqx3uM7Iyokw0uYlXni3wkLVkcdOpYVoiPLbyOqrZwvBaw==@kvack.org
X-Gm-Message-State: APuU4Z+PERWiYMlCzV7Gu/8jf2NcTd7dMUOO+hXmzLq19N1y3Zi8rGn5
	t3nhIS1m6Ep0VU1d6Hvg1Js31TlHBkOdTseS4WlIdd6mYvyGsYRcPr7mY80apIJeC5YISA0vLE4
	BYfPQMScKwJQwcXm29B30Y9RppYal0Pd0puOSq/QtCQ==
X-Gm-Gg: AYBFou3WQFEl5kWYO/G1+kdFSPmqCRmOMcLK6EJCaF1p0vmeiEKoCXOSbpv6dfvuCIZ
	jncxbB6zjyZGKErqJ56t7Z3kltIJex1AuRq/+U4Mqjixlo185JEMmA3t6yR0JjwA5tVOGK8eIb4
	LMuwj3kn7oC26mDXuo9YbHHbqHaJSlK9XuAdvlzT0XcHXeNuKDUG3ZgnNKWmU5J7OCU9k2DSaWY
	UZfxoMdLIzr4g+ym+3pONjGqxYCN9VwY4yx+H6mLTeytGSZSXnCoOYav0GpOXUIw4rwzxAaGkq3
	Gfj/y8RyEAtc1SDMLGYhUCfwBNA9zpTxY0wQo5UvrkYwxY8noddmpWiEISHVtV5AuO+Mo2nvt2O
	ALjEYPYRtqe7orA79IAortiB10HJtj9wbEg9AKA==
X-Received: by 2002:a05:701b:450c:10b0:149:49c:233 with SMTP id
 a92af1059eb24-1b3b603e878mr1944541c88.27.1794280668922; Mon, 09 Nov 2026
 19:17:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
 <asy_L2s1TNcN7bOK@linux.dev> <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
In-Reply-To: <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 10 Nov 2026 11:17:37 +0800
X-Gm-Features: AclHuK8HAaIrM0LQouKy4b9klf3zI6EsjDz59qge6Fr9-5V5H_IdiVz2kr1PIPU
Message-ID: <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ztyq5my8uauzec7sg1uumjb59iq9xr5p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 32A14180003
X-HE-Tag: 1794280670-823599
X-HE-Meta: U2FsdGVkX1/YrmNzVtiJZovXojdJfu/Oeq8ljCH14gyGgQ+3FKEjqJ/cd6VR8kuWCBTYLpThZeY0h07O+GAGuURMGzEFqtP3xeWMVAFob0OGUajtx731GjgxvnTVoE/9YybqoECOSieyhcIbKcHNy9QixFJJ3zAObOXFV+ev+mADt207mr8xIlhw6EPgInbwEqYy2QnDOWraqOsWPniRomejfKFV1i0SnMIFOwAW3+9L8v83qdkQqaWL/7A1opUSwiBnpXNJ1HNu3fhbA3dxaPVxo7pV0FiDO1GxUlK/iURiALs/w/v5+MUE8oV47N2izbS/6LddQHtj7UMc97snNKp5XlJij7vJpEHPIJTk/4lK4K93lDR6Pwa7D6yqIyawcz87H+KguPdOMolERepcoqFpLv6YXxdI2jil+msocL302vrcghIKqCkQkgSUgP1OCr9IBW0kEXSo60qtB/DWUbkq1kFrkrcP0viF8Epwc46iIY3B6JGeGsuOiYIUrizvtz+4G5/55Ibuk1Lxn7V39UnWmZGX0AYn72jc9/adXgDUDdM9r7AEoq3dF34R+F7QuTx9nUrwcqrm9SyZn9VHMM0F+LMem+2mUQ6noeN8pooRdNuY7cCYj4xz5kAkQRjKil2Th6krTz/I372zzOjKQ26W/qtJJNJMSdkWEJNF5VBulYG/NaZG50L8vNotCC7f14ZYiwamLm/UmkkPemhyhHLluliwnRxnIt9EuIIv+p/4Z/kN9K336nUS7jmanbD4DMZOVRkTirsPIlDqR1UgLmZ4IzSUdoZAYyjPF2A24oyub32XweEMg8O/NXybBQBYbNq92nNBu4+9qK8UCJxQ5Ip+E5TKdOvaqK9iKBCYb9Xrb/PQ1CM2/drqtyQAyKVCB3cUg8FCBvS/2JYEx3oaY+0lImC5gLaxQT7AYkOvS8gbNsw5a77YjeJMsb9pm3v+fTL0DsdKPIuFR5bUmB4
 MkL6FeXh
 +/WW7B0BMQaaF1XvxZCqqw3NADmEYEYWnMLE0csKBJ2ZEJE716UrekoaFaFJA/vRf2TLGIx567E3ajxvGucUW3HVdSiPeACZKGAfTl879cXU36Wnki2/F/AuqJV9WM6BNgJjXQImqjyqZCVjkH8IQ93ZxF5B4buuuzBhdKlr8LplokETupHpfFfxQFIzbGq0iQZKWYKWYxFKKBfwnzLbtN+NRs+GfCUq8/cUCz0UNa9C0boWkN5v2kQfE9m9Kc2Q+A0s+xoJ7NB/NZnTa3/W+sLT9xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hi, gently pin this email.

Thanks!

