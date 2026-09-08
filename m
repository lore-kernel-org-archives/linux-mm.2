Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD07CC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48CB6B008A; Tue,  8 Sep 2026 07:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20C46B008C; Tue,  8 Sep 2026 07:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EEF6B0092; Tue,  8 Sep 2026 07:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98B006B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:48:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 874B11A059E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:48:08 +0000 (UTC)
X-FDA: 85190421456.17.69345DF
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD0701A0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:48:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGR7JmGc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGR7JmGc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868086;
	b=cm+4EfWH5h/0369dq2oPD6hYcWVvFDkZjdsLH5vuDKfqKJCFMaZkTvAvl0AP3TK4tTEoiI
	aTpl1tJZzjK6oZ4034KBy5Ed+oQydSGsXD7cPBEK9yf2rFLmJQIA4YDsNhE3oje4pRh506
	cp5A/KNR9gHzPuD1RFMEp1XbtrF2usU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBTbkbKWNVRl47tMAjR1GYFqBM0RP6XFGBtroaym4bw=;
	b=zPuBqJpmMxhAWd9cVnrBwEdHtprriW6Pb0n8LnmjHWVW85T2ReaUfl+LxSgScr01qBW7/x
	HXAUaZmvzpcHP3Lfw+s3Lsy3/XjhR33WVRGYoOZ03P/SzcTOFi7v9eU7nkES9uqzP+fIkQ
	4lRaRePLZEYoQJWmGTWciny6fTDyqrg=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso3261217f8f.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 04:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788868085; x=1789472885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBTbkbKWNVRl47tMAjR1GYFqBM0RP6XFGBtroaym4bw=;
        b=rGR7JmGcoMbdF7L0nm0P7+nGg2x0XieuW9DLZHURtwscLyQ3A2SgQzH/IRWZqIHz7H
         WyRGQQKxt329SWw6pjX8ClU9IGGqt+hb9QYr6u89caCy8I0wkr/X5+z88lyQAZvMDxNH
         HgU6tDdQ9DtQlAO4aChpwqBc7uDjwOvPzjMe5LMU33doTz7sRK+SZnvFPd08GZxjelkG
         o1Wh/TfNPdA3/jKOkR3edXHLxl8Y3MspnoPSz6w6ld66Z4U7XW3kcILqKDP566IaHrdw
         IaczfVfFVjuYERbJ4kmsvDtHs5rvOi582uWYT4nDwy9CqDewIWn5hxtnbX81VnxHFvYF
         fmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788868085; x=1789472885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBTbkbKWNVRl47tMAjR1GYFqBM0RP6XFGBtroaym4bw=;
        b=iu7yl9WFgT2R+DvFkk/qc6oeNHrB/Du2XxEX0CYa1ckJxkGT+gGOnTzuPUyBQLgY/u
         GLDJ2ClX8fJbrfHuf2Sf282lK1VpV1bDEdKmi5Hi1Ko7/EcjzpL0KpYnchuS2zefL+Pl
         008d3MjDXH0BbwQndjlMtTxqREyXtWwGmLt89OlnMfgxEYGYZ6fjaj1nlK92SAR2rbon
         MvMlc0IoaFd6g2xMyNtZ/q6l4EygBfoi17WFXIw6ft+NaM6JItIxO65M7GsPTaf1As7f
         gwcUb0TKdG+K5K98ol+nrRFCHcMBo2k6NMP8FCDR6pYUzH/iiosuPSTaq4ToFxE45pfg
         OVUA==
X-Forwarded-Encrypted: i=1; AKwUvBxPvZGJZOi36DEGuuIl1s1KtP7dORq8YXzn0sHlKyzjkQUZPnRZXXt837FHt8V7SCqB3lMIBTxi5Q==@kvack.org
X-Gm-Message-State: AFuF++l6u871N5gm61JNYcJhkneezFz7ytSDYpvDKaL4m+RZtPooT2jk
	p5AGmSA70OMhtCTclX/eg7x1a8lEUyyAv20L6k5BTc1Ag4iV+Klavt3K
X-Gm-Gg: AYBFou0BOLhIfigriXUwuQcz7fW6FhH/jVWOIMBuPiUO2pFpsm5JUYBglcTMbGf1d9I
	GaohR/6klqgR0SiNTGenc82UwX4bK0tMv0OFAWwtAtjFFc5X4UL43gAAi0RduxUNcMgU04dA2Dp
	G7+NZm/ul6XTxsxx0QmQtQ11rgafr6cC/UhZ5X5ZFyQ55SMRzTsM9glCSwbL+PiIscl+drmDqmR
	Rzy6pt+DB1xRCEceUA398AE/Vg/7raZDuwudn11ovwQhjkNzPnayQYMAwWk93APpk3ydEF3X/fo
	JM0AaOjpc+b3aUTyYZxeUHa4RVtGOMseJFwRUg2VnjS4hWb8G5x+M7Ihj2AyfoZ8A4jKdS/4c4O
	GP4F0ozsQj1fg/3KUnT/udJCqdFOY0BsNEvlpz241z04uBOKqzOWw4rlGD0fyLPl1xFEpp9Gxnp
	U6MWPPN/wamk2202D9Zbp7VaGVdLges0uTnV6bTbzc/rafGFW8E3JF0sZT8ymNyJ8Msxd1ybE9c
	Q==
X-Received: by 2002:a05:600c:b95:b0:49d:174e:2a1e with SMTP id 5b1f17b1804b1-49d174e2a5fmr67747665e9.19.1788868084791;
        Tue, 08 Sep 2026 04:48:04 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d04fe7f9dsm288511555e9.0.2026.09.08.04.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 04:48:04 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: memxor@gmail.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v5 4/7] bpf: Allow reads through trusted-or-null BTF pointers
Date: Tue,  8 Sep 2026 14:47:36 +0300
Message-ID: <20260908114736.5342-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <DL9V0Y6BPZSY.3J1EXVDXSHRFO@gmail.com>
References: <DL9V0Y6BPZSY.3J1EXVDXSHRFO@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BD0701A0003
X-Stat-Signature: t7giie4admbthhc35k4ew6ws3oaaxo33
X-Rspamd-Server: rspam01
X-HE-Tag: 1788868086-246576
X-HE-Meta: U2FsdGVkX18SUwWIgSgU80kdpjO1q4VpDBqMZ7lvpzJ7U1QBakScmWnHBHjUPFUzDiT8YKMqOdQ0u7eRIQffA5YSiuLCt2MDc/bE9oddTjQKwhsNMxsk5UvBGdHjEGjjOkzcKJle45chLayf2Dpb8XX7VwzKITOQOYgXitfdt8NEYVI1y7/k8/ekb8tKJ1xcELq89OOGrKZa2gv+kty9vo+j6ufF0eFUwyjqnBPO7dlwL3+f1lD/AF+R+d9ZINolPoq35DpUu+q31mc5xJszvNn08NcNZIY4QysRZsrXXxBbtlAFWd2c1po4blyuKj0d0mN4EHIQFQ9eAuIVqRn2/Xw7rl9SLzmGr7eiQaoxclkv+UAOvyeRtfkJBWKFzxXUtbV+wR1bNPjJXLtF/LgO88vpiA+I09gLhE1WxDFq/KWKR7WC0D6M9BBVpLgb+Xiterc7Jtj00mVG3OaeFhHsVWThGhT0hxPl179uHggz2BwuposmigfmK1dVefpCEX9S3Whm3aoSATVohsz0nbZ6Xj+wEuw61oR+9yVD8KfTU0/gPXnG/cc13hyHB39qRCtghr+t86uVNyT2eqS4miFF9FQr5phSw6fR74bFi1kmOeF90bMo+eLOsgBwuovGzlNeDPL9RPlNTC5CWREGPa2Zc5le5tk4FvzCXCmhsr2xQH7ArZwPmM7S5EqXlmbuLYeLvXGuALjsmtv5tpVc/HMVZRoqWj/n88KhRVyjY8tfWRkbxNgHNaQX9EnefpF2JzUjsZMgv/t16t4mReiZnxNQaY7iEwDpH2DdC4WNP6uY+HibTst3o5AUDRcVyjDGOsvJYEWTdeuxcDXaLLuif/OmJIIVXuSdDDmxrtcOvnHszzFZdImg0G4o24mwOVdf2TRdXRJ/UMK6aEamDvl6v3IfPAZhkwsY7Dhddh4/kMcG2eMYbvQRA92WIDmCS/Ecrj2fL7IzL1bZROdgSe4Xwpg
 Dx/KwYXw
 lZKZLBNSSa5ykO17Bu524WpQa2AmXMtKtoohTxj45z3MWOhiNEC8mflQZ2T3uQlIyLh+WrNEqI4mxFXBnpC/EnasrEFJdQFx+hJw7p+XJc8sXxu6/S/16dEN1YTMkJiCyGg3RbP8Ev7wq2QbgUpEBidDFs2eygzMfXpa3So5axdc/0BmUb9tACsB5GCUOLMtGM0V76+aZp2Qudi4ul4LdpKSml1RP0BIjBhYyX62zMZUxpTTSNoBZSdHv4wCNPbVy9OB3DOm1ySToMdZ+GtM0nz6iemIYK30Hb0vNCiHnGBK0OLpMxjHGm7vkT8dXNPRIh4qHoMNHNA5xsHKK+HNrqvz/07jIi6nd6+x+GSXOtjo3F3ul/wB2T6c0Hk980MzidB37KYuHhIej0LX/s2LQyCQsDLdw2z4WUVAN+gaYub2Z1IHd2PQF0Yz+YwQnPhF6MJfenfThZsK+fJ9D/Ra4OGB2wFLWE/FagoZp/o5wyDFLcIGnbLDbB+yFeW/0eyZfgEoQm28yhoXmhNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review!

> We tried doing this before in
> https://lore.kernel.org/bpf/20241104171959.2938862-2-memxor@gmail.com and it
> got reverted, it broke all sorts of things and made everything more complex.

Out of curiosity, what were the main issues caused by that change?

> I would drop this hack and just fix the program. Given your earlier change to
> annotate the field correctly, I am puzzled why you added this, and there isn't
> any description anywhere explaining why.

Initially, in v1, I only marked linux_binprm->mm as trusted-or-null in [1] where 
I also needed to update a test. But I got an AI review comment in [2] that this
change breaks the BPF load-compatibility guarantee documented in 
Documentation/bpf/bpf_design_QA.rst.

For this reason, I took a simpler approach in [3] where Andrii commented in [4]
that we might want to look into having verifier still allow to dereference
trusted ptr-or-null into untrusted ptr_to_btf_id to help with smooth transitions
like this or just marked linux_binprm->mm as trusted-or-null (ignoring the issue
about breaking the BPF load-compatibility guarantee).

So I tried the more "risky" approach first. This was the full story behind this 
change.

To summarise: are you ok with removing this patch (and the next one with the tests)
and fall back to something like [1]?

[1] https://lore.kernel.org/bpf/20260811112154.94053-1-tasos.papagiannnis@gmail.com/T/#m295ed4ae8a717ac4cdf536585f150590faa2c40c
[2] https://lore.kernel.org/bpf/20260811112154.94053-1-tasos.papagiannnis@gmail.com/T/#mc0865ac61ab3ffb1acb720e42b35ea65469442b5
[3] https://lore.kernel.org/bpf/20260820131801.68759-1-tasos.papagiannnis@gmail.com/
[4] https://lore.kernel.org/bpf/20260820131801.68759-1-tasos.papagiannnis@gmail.com/T/#mf5cd6a81c2e8231999ed2e4b991e060cfc4ca7d9

Thanks,
Anastasios

