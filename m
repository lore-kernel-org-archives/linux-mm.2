Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4EBFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE096B0088; Wed, 29 Apr 2026 06:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094E56B008A; Wed, 29 Apr 2026 06:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED8E6B008C; Wed, 29 Apr 2026 06:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF5706B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:33:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8408E1C0070
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:33:06 +0000 (UTC)
X-FDA: 84711230772.09.B44D6A4
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 93BC04000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:33:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pmn0CoBM;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsOPwXrH/NRDkB8GeQFymGAe4gDJjLZ8FQiVmg2qTZI=;
	b=j3LIug+7Eh3XWUTekyRWH5Zq+0jh4OQwXyGh3/1I/0m6TWGFZerPtvEv+92l6Bd9xHKamH
	A1mwjXtJEnGAlYBh71R+fGshIWxgYS/whiW2aJSGoVubViCQ89qM2DtDjrEXAW3Hu/a+oo
	o23EYLOKcKnou3LF/CF076fLLNwcnlg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pmn0CoBM;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458784; a=rsa-sha256;
	cv=none;
	b=qbl93+u4MU7WG6qgspsnrbioROyZ9rB1R0hPtVAvcHNzIRTk5ubXkCfgJV6O4q9Ny257iC
	Pfa5ULPyXWtcAo8rXOGrKCc5rEG8U9FpXyp+YcFy2sgsXuzMErU7h3++VKHQM474/i5i9l
	WZuNS+7xCzK//t2pvN+n2bGfD7tVqjY=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso95904835e9.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777458783; x=1778063583; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsOPwXrH/NRDkB8GeQFymGAe4gDJjLZ8FQiVmg2qTZI=;
        b=Pmn0CoBMrH5xQ5XExwLhFsLTJOeurRiA5aniL4xon09OKjea+Rx+GIR9LQBuSUHFOS
         PgyNGp5MUzpbJvV9f1Iz2+VmnlJ2Ogl1jr/GEdsoNKr+ejmIhoIIq7CeEupYQhVjrObc
         tO2odguNnCgerNoKPZUsv4lYkR6WT9fEK2Q6Xkvd/K1xwv0peWj3S7Bfd3mwVSeCgHkz
         ajsgZt48fJc3QMJNfIyAXkR0EB1zPvJWXl0NPCG+oNiYJk3gbRUsULkexRNu89hyr2c6
         DT5ZqHlJ0v5hlI5vSXa8c1fIgyEc+p3TfHokpK4XWGyUjEuI1pp3B24cCS3l1bdvQOaL
         hDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777458783; x=1778063583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lsOPwXrH/NRDkB8GeQFymGAe4gDJjLZ8FQiVmg2qTZI=;
        b=C2JhHpgb6EniCywjo1y2VjXCDf11cKDaoLy747p7WYHAO6rl1BI80PVzgESsr1h6ty
         ZLOIxLjjSYASZigkNRIKCgf/JKrQnOwSphfJsp8Y/nHDA4AYyXUUWbS7pcRVtRdQbsxs
         1/ogMn+5n2Zwz2HT01sNpO3Q/mojYS9IBUogjhirRhSsomtLrpHnzvBLKLBzvdd/o8oy
         bHfksCa48ZBnnGrmS1F3ygMQBRfIp5I6TT4vlZYMvhnXB7CAC9nPeIGwJOyRq7/0BmlM
         78A3lLs4Z2amqaxV9NVw1oDxCyIpvqnxQ0l/4Itml9NxIOguG4sxh3EqreV+hVWbewnO
         gl7g==
X-Forwarded-Encrypted: i=1; AFNElJ83GXCYES3fSPqmKGIeMvmI4i0gsrsqvuZccz0SSL6lvl6fF905xDMon/F2863itx9tHCkIgcp7WA==@kvack.org
X-Gm-Message-State: AOJu0Yy2l0looKQ2SceJBXS03Nt4WiYOpGnYXy/EtmN7/GCxau/Dzfvk
	wFQbmSo51BQvTcbmRZte3iojS2RuGV1SggKaYa8wlWuCr0cMs6tTrv1pbj4TCY8uskA=
X-Gm-Gg: AeBDietcmpuRhq+JWsZsi/X3Rk7i6r9QvfVB1mUtsPhefFvPz7ftGQi5bW+b05g8TG4
	FeUPREnCAVJ3feLBCOufkgBVegHZFxTcLVg9ZiOe1LNJKuirCUfGyFew2rmnLJ0H0RbdprLyICn
	9KFbyTIcVkZ4oZq9oaFOtKSboPh4WEvVmNLDbhnb/4i1YAEj2Sbjo3LLcXyWmVMIZZyFbbs83yv
	nctPrT737oe9J7ouVzfWu9zERpPsXD4CJNINKlbq6wrXa2S7QCBh5p7ThaXRHe5TkvEGfhRuTT5
	PeWswliMc0y3H+zxy/IeCF6cBD+3LeT0cd3LgzfR6qjOWzHBGLsvcMsSWGgqx62NDY0Da8eko4U
	R36R+sW+RpcvkrahlMs/g+IQmdNAFfCyMBobSk3n+7cnzICUdzAin6QPdjcegKbd8bGJttGvp6U
	K/BpCn5JcAmt8AD7C+uWw3rmkR+gxmlZpFP7u1n03N2Ok/VZw=
X-Received: by 2002:a05:600c:19d3:b0:488:904b:f31 with SMTP id 5b1f17b1804b1-48a77b240aamr106838355e9.22.1777458782854;
        Wed, 29 Apr 2026 03:33:02 -0700 (PDT)
Received: from localhost (109-81-86-177.rct.o2.cz. [109.81.86.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c5d2919sm43817595e9.15.2026.04.29.03.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 03:33:02 -0700 (PDT)
Date: Wed, 29 Apr 2026 12:33:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	timmurray@google.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afHeXY-yeTwmURWh@tiehlicka>
References: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 93BC04000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 6pcfozj76x5xn3a1r5dor13m8s1bauxf
X-HE-Tag: 1777458784-960667
X-HE-Meta: U2FsdGVkX18RTldlEt/Xn1nXuU1/dO3ysGTp9LGEK2T1YJlA85xL2R10pNaIh6AJFos0JIHpBAentf4hdwl2Pv7tyCgf/27Vb9W6+aNpcBHFOOjFoWJE1nY/NhgYyCv3jVO31t4x+BW/FfI5hoTsUC9R/go2A3ToX6YzuKvjz0wX0H8TnPNie/7nhmHDaBLc9UCHbW1+UyLpzlUbKZtFhoRQkAmacyCoj/c+XNkXjcTPEely4msSnzYR3XQFKY4NUx3rD6KDd9mskkwoGIIaU8czgFQ1HSOL9u5QdjU5kk+JL/LEJIATXvOZb0rESlbVFmdHV+UyMt+7quD+dg/qfIUx8gnoSZahWtqVD7c4Xm/FvAxU5rKCervED3sn52ngvDdlLlGUeBdHLtiDdt7qqhoE89FsYxw3CENL6BWMZzY2y8XyqYWDmGW+gfy25xbb4QZLuSm3SaZ5Cbdys/WjZCvMB/Aif5OZ7vB5bRchGe2J46DR09DPwszeavMjmYp+yEcHia1hjtCaV2yBOW9Og1ZheoAHaOannDXFkFmBQZk6PrfpacndGOebYsfGLHf7jtRcSO2tPd6p5b05sMhycoeOmOv50DdxiwbjpDcv0O9158sdG087to3bUbzXQC4NFfD6m4vT/qo0YHxALV0JAkiLsqrQqoKgWlzOovZ6QKOw5sP6KZbDaAiiPRORH7jMVHfmAiL7q4y6RxXIVz0KOtalQfnvglx0nhAEEkfd2uSEMEAY3XV54rlEtzSCc0gmxGZJObZ2WmAYOD4t7qHaqzjWM2fqosNzTYDx+iZSTyaSerNDv4sG6ak2uRjdoxIKJjICJY7nKa1sxePqqbKAvx2r90LcZ/raObR+jvQKTOiUtQ1Zs67pNqpNBRZ13/9w+BUQ44e4ceNrtlFpq8uA0DpwghSRfNitpGaehQ1h2g20KJ1nuNdvaBqy2nO52Rr6Xt1dara/A2GoemfwKde
 r7nRXg1d
 +KU8rUMaINLc5PPKuIz/HDD7VuapBsYa1gvAX3Wr1mF7pzZi55eqvCOAFbDGOMUuC6/fKUEpFXIlrljKbxA2W0lNkwlAxGn9GB1Z1MslhFFDuwQ+Bpq4GuxEqWyjn+Rros5X3IalkJFu3JRo8uvoYcIVIQ5BypWCMy25B9U0lb/qDs2L4W6K8uoZytfMbMcc4Erxkd5tZ+0gsrUvDSpOBNKNmSMMwOZTGypTcAy4dBOX9ILKFx/2cH42Bg0O0aIWOqPdgxS2APLXIFoY8Q0CmWFfXO2ZX2bOk7S4/G7B2zcgkRTDn8IE78mwtMBr1dyAwTB0/RgkAwoDjTbj5i7oe5tyc6kHGLBJhDMhtkpKgUHH0VpneOPskf9Gq273FjxMku+dpFW04R8GT8ARTUK51U229cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-04-26 11:09:55, David Hildenbrand wrote:
> Unrelated stupid question: would things be clearer if we could rename
> MMF_UNSTABLE to MMF_OOM_REAPING once figure out whether aborting fork() still
> really needs it?

While the oom is the only current kernel user of MMF_UNSTABLE (in a
sense it sets the flag) the flag should denote that any page faults are
reliable because it might fault in a fresh memory and user would lose
the previous content without knowing that. Not sure MMF_OOM_REAPING
would reflect that reality better.
-- 
Michal Hocko
SUSE Labs

