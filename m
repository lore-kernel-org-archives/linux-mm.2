Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA54EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E896B0089; Mon,  2 Mar 2026 15:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4E26B008A; Mon,  2 Mar 2026 15:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BEC6B0092; Mon,  2 Mar 2026 15:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00E876B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:10:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2854160325
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:10:48 +0000 (UTC)
X-FDA: 84502216176.21.6FEC473
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id A840C40003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:10:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Iq/YzcuR";
	spf=pass (imf11.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772482246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OD2UnYjHhMASICcTnuoxYljVdg0QIE7xY6Cey5he4Rc=;
	b=lluaRClHJNA1J5fV2SRYbFO08LokzpkgUA7x9CMKF6J061rCsxqYKyAVEtxSpLhCwB20Wi
	NSgEmUpHJWA6zvFxhHyM/WyF8lmtWkIfkbxf7Wlgq0M14ceEwzv+jkomPE+8T9lFORI2xL
	fItKFXzcslXVngSMPfBhhyCsPdRRpro=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Iq/YzcuR";
	spf=pass (imf11.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772482246; a=rsa-sha256;
	cv=none;
	b=vawNEzsIHatsK94EIwyFHuZh535IyAt5SuHvnlPxrXr6qssq0mJ0ObxgEu5TeddV3qP/z1
	iMM7d3q75P8d+dcD5bA1iOxYiKwpjlQxEtR4yDPYhBDVRu5Q+6acaEGwOXR4t3fjoFgcpO
	uGwmmprJ2dmHwtbpMOJNkZEFZfFPO1U=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65faaa8b807so8816241a12.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 12:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772482245; x=1773087045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OD2UnYjHhMASICcTnuoxYljVdg0QIE7xY6Cey5he4Rc=;
        b=Iq/YzcuRqLCEHOa0FITEvXsdUc9O1hNPlVG7Z20dHCIh/XJc2/fISG+9TZvgFL0ZXC
         rk8Hyr/Dya/JyOyGH3XVlEZIrU5jbSmFNcXUpf8JsLfH+5aQJjlwIrgDxuuPGWGlj4ey
         B8iLzfmdsfKKZpU8q9A+2Hr7cBdaFgUFGvVoIwS5x4HeKznNNb0hC1VMSXdzqk4ckUQ7
         1/P50d/pqWzzoiE01iB28dqAdGuaU4R/htWcyBOZNy5HbhHmWjoCk+JFUiBbi2Qx9MfS
         RxVlQz8hq/MOfhrFO/joMy9DtQ+wa/00Os9KbGBZqb8THleGVWktQpooTgaHImislGO0
         hOPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772482245; x=1773087045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OD2UnYjHhMASICcTnuoxYljVdg0QIE7xY6Cey5he4Rc=;
        b=FIImZEURk1MJbp/aRq8jkKHgWGpfdq86b6QNB34BQ7PmgbI+V9zwRKKvIHH7h73ctq
         s43ptP5JuBeKk/IP3LwiJ0hF+khdSJBAmYfbqd4ouEy3ZJsJhD4AcDwnTPXlxkKAXaFA
         z3kWIxvJvZDpZunr89WUvEK6NUDHMVpOD2cTgag1Zl0FFVJFLvV17SUxwXEONt2fApDu
         SFWNj5V+y62PDP+Fv5qxNR9LeJRwS1MhL3v12p1ZGHeuoZuGFl7FJzinVC1UOX+B9LDs
         CKrAdA/4Oi/s1FvN+OPByPWFluWVP83LHlQORFRHBFJmwoDiFpAQLg4FUP4JurCVv2U4
         3AmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqQsXetest8IVfqgPjkupaJHteHX8ziCGrXYzafuWHluHIfgYSs/zdpfeZoNKfOjjKONdFkMUbDg==@kvack.org
X-Gm-Message-State: AOJu0Yx+a1Hdnf5w6Y/rO/xdI05cyFusMACexmWl6IJzDwycML02kZXy
	kuyNZ/2VTzAW6wZTxp1IMcZYNH4PNmohBknqORuwlunW3q2/LXASDPxH
X-Gm-Gg: ATEYQzwYyYfou1m9HKxSoAl5W0PaWwpTMTCVuLjWW/ViMgUfLKSPj5gbPZfRsnkdPtC
	TcjUkbkllkfPcl9OF6hXZqZnezQj78OEJSrUo01qxp4uyG/Py+Xb1end2Fg0BgUmHUcYOf8FM2V
	Ryz9Yt6gXkDbx+9Dbb0mJwQukMaRlhkyMyEuLViZd9lYh1U5qaxvG1t9uOk15+EnTc4ezpciUU5
	nnK0Iwx37LI0CXNBZF2aMm4cnsLbvUnFxsOJxoYJFImUqQ6LUIdf3opET75tCjiqCKpeviEjiVV
	5IVrr6sfvj/LnM1IkIwpomrlqcEn0KRQpk9x73YOAyg1908SEpuVuwTTL7YzixJJKVrN5QlR1k7
	4rxOg1S/FJbqzIOam0E7qfyIir5tUDsL20wtq4puiwbu0+uKdDy+OWlJz5xK8iRBH+EExN7EcNT
	ZVsliIuy5aawqG1Z18NbTWGpA/
X-Received: by 2002:a05:6402:2355:b0:65c:2af1:b7c1 with SMTP id 4fb4d7f45d1cf-65fde2cfe05mr8198554a12.28.1772482245029;
        Mon, 02 Mar 2026 12:10:45 -0800 (PST)
Received: from ArchLinux ([89.105.203.98])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65fabd36367sm3835944a12.5.2026.03.02.12.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 12:10:44 -0800 (PST)
From: Alexey Suchkov <aleks.koyf@gmail.com>
X-Google-Original-From: Alexey Suchkov <dywoq.contact@gmail.com>
To: joshua.hahnjy@gmail.com
Cc: akpm@linux-foundation.org,
	aleks.koyf@gmail.com,
	dywoq.contact@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon,  2 Mar 2026 23:09:49 +0300
Message-ID: <20260302201026.39952-1-dywoq.contact@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302194836.2932150-1-joshua.hahnjy@gmail.com>
References: <20260302194836.2932150-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A840C40003
X-Stat-Signature: z8jahtxikkwi8bkzed7ok3gs6559h4xo
X-Rspam-User: 
X-HE-Tag: 1772482246-984416
X-HE-Meta: U2FsdGVkX1/wYUb/OF+/aNPllP1PT70hRRrqZqnHDnUw3MHf0e8vJMG+9X5wsK/Xz0gkcs8ASEfkD9umwtuI9jeJe9yBjy6oA5MOpnZ8H+TSdHCm9mGvvgq7Eod9PITKBcW/cK92P+h4ZLDKMRRLZkt68FJ7V9gLBtkmMWJwW1K4Tq4zh6uHiDQOV/sQZnsBhoerXkxWWDqkebPPexYwsSuiFIqgo6Dy8cOYykj7h3KfGNaUW609t+axHMfzNW6kFqe/aiyZwfcIG3hPNg8S4ymQTQzFuGXOxwuqotwj5SRza0FePtJoyhXvPo5bzVe+dJmxY56QRKKrkLlZGGZNrrINRK1XBB1CpsZ7yX/KPyCcIFTAQSKs0uUIpUYLQ4oNdiHVzVhZnVgpSDWfwWCm4tJN/t0oX/doM7fT6yNyJ5wQVyKuo2jnD/SMCP1u3s2QhY3MWz2plPm77zZgOJF7juD/hELSsdRSmQYxE5sGF6CbqPiuLi59a04PvLl/OUAf26b5zrZpKuVsko2r+f6P9iadtVU2pjvrA9vpk0kndR/WvMWz0FHrhkL9/eaeus3r8+nu7ZSY68l9Y+/ZjAI5xFDF+0aTH1AHcmDyxglhkTsbBOKfgbJ4rIuTc0dbbfnddHVudjcU5++ULmJT56015qZe2AABlVWdgp0KWt7iFWdFXfOiMerOMwLCNT8hd/5P2luIJ2d6G+PZEZvU92Nr7VdnUjo+cxIlXLVq2s+pUQiNWbnPs3Um5otK319E5ddfDngI9buLHQa67pg/yWskXa6rz15FqGDFt2hctoYuzDsTZgHCc6ccET7KhFmv9VMQFznv5fvCuzq3rVS19r0wcxWKutlCtI0NAtbrQZJB6rSz8vKPbq7EiN+TgeXLx22iOPru+rlVxmN+KW3C69sNHx92E/Vph+SfIrv3++6J71d+EG/By0Iv0E7X0cLwE9btpt0QNJ/zeT4IoQXusNJ
 XokHKheu
 eZ9hGvgjywJN/+juvLPKQEstNj+OJoHl3m52iVR+wBhZaUm2U4fRtnQtXOp99XGWit/tOA2iYynQG9o4ELJhCSYlJXXxA76N9RHi+zJuxuSYYYfF6IpCASmJI3C7FP30w3IZrVge6ocSdXCM6u/M5b7g/l5AVXnvfQgO4/RNrOnopw5JGXTNyNjm/gK2NjTolq0PESFF9GwdrHSxf3nZV3Uu6++0YZMu4C1eY/b0VdTSS6yqx8woxmpKH8J/kZlIhFkjQGfMpaUdgzZRprN6mdDcgZg+1MKSZ5xuHU3CXy8SgjaRAxSrS4Bg8P0TydntILG+z9dSRHxIp7Z/QOp8lDwCk1BF4TSTWxok7EKdhJTXkrzLyNADUVGYECPJlFeNt9YnItqBxnbzCCdMkBoCbFcyYs3zvTdjRFGrQfjyOTHe81GZc/YrpYQ6qVAATzW6gVFmI0tVWC0nmtP5lCXAQZ9Czof5y44L70B2Vvync8EWx2kGaXkABKajjFO/NmnwLPz6Ds8EyP/iJGWl4ukKmq0KwllKLtQYgl3Khd5SU3LKE7/2BS00zN+tuOjz36syETfaZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Alexey, I hope you're doing well!
> 
> Unfortunately I think that this patch is still unneeded. The variable seq is
> used in two places, raw_seqcount_try_begin and read_seqcount_retry, and nowhere
> else in the function. Both are guarded by if (gup_flags & FOLL_PIN).
>
> raw_seqcount_try_begin is a macro that sets the value of seq.
> read_seqcount_retry is a macro that indeed reads the value of seq, but at
> that point seq has already been initialized by raw_seqcount_try_begin.

> So I am having a hard time seeing where it would ever be used in an
> uninitialized context. The compiler should be smart enough to expand the
> macro, see that the writer and consumer are under the same if conditions,
> and realize that it is always initialized before being used.
>
> I'm curious to know if the compilation warning above is theoretical, or
> if you've actually it it during compilation.
>
> Let me know what you think. Have a great day!
> Joshua

Hi Joshua,

Thanks for your review. I did see this warning in practice with GCC 15.2.1 and "make -j$(nproc) W=2":

In function ‘gup_fast’, 
	inlined from ‘gup_fast_fallback’ at mm/gup.c:3202:14: 
mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized] 
3165 | 		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) { 
     | 									  ^ 
mm/gup.c: In function ‘gup_fast_fallback’: 
mm/gup.c:3134:18: note: ‘seq’ was declared here 
3134 | unsigned seq; 
     |		^~~

