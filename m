Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD6CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C7A6B009D; Tue, 11 Aug 2026 14:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C636B00A1; Tue, 11 Aug 2026 14:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB476B00A3; Tue, 11 Aug 2026 14:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17CF16B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:50:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A38E5401E5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:50:34 +0000 (UTC)
X-FDA: 85089879588.29.BB53C11
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id B17F8160003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:50:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Is/bll7u";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786474232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D51mJpyz428idoK2nRe/fA0RUL86RM6cJFboL6lWHWM=;
	b=xfn4da8x/VjVScZ8EA/t0YtVzTAEjrGBSRV1wMVE7+yEP6eB5uHD8NpgzD5w/ggljOmGhe
	6QaMRzqMXunwp84kH+d8LaTIPj0ky7sPoztpC2WSbty/Qvksp9h9ixbEljpNJbrV9X2E63
	uw0yVOG3DzPFb1FVSZLmcQ97SziuxQA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Is/bll7u";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786474232;
	b=evCGC5vJC4cAv2oZHIC/YioDqF29PrD+BNoF99da9059i1cDmyayJMEXR4mM8lFnQG6Akv
	sythcjoQQd5VCQ6cRV/a8g3rqhNV2rSogIHccarq87+VsP3f8lc8Wn7f1TwhBWsPo7k2xY
	twsnBCrh/z0ROOmuKzBf95ZpKQcpeQw=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66077ebd1d3so32430d50.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:50:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786474232; cv=none;
        d=google.com; s=arc-20260327;
        b=YXpRRJahoPfggmLGQToRK07c2dBA7y7cSL3kCBt5XHPVz08gaALMXWuQkzCP+6wN88
         QlVp6VuWmCPIpvS5fRJpiytHdYLxFOLrRerfFnYyIVea2cb7RVKYV9FKogwBcLtai0ST
         uw4yiRbrCHlm9P8xrQ6sCVlKzS4mpPAoFJeAgXsxJsVoZaqxjxM6PJABJ6ML9PGZmpza
         nhcCRC9RO8va6L597fu324BKvMk7kgRmwfe3xc1xpr/KRoCHfHHoDhJntmRQ5bcfU2/1
         RO4CNSRl+A0M0lLUHZ0C/gZ3UYSRf66S9ebVDNBv1Ly2TriQ3ok/BPTOTSCkP0pcgycx
         dbDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=D51mJpyz428idoK2nRe/fA0RUL86RM6cJFboL6lWHWM=;
        fh=F5Dbq4DIuJxp7kAjEfEOvqW6NQdpd6it+jg+t3UV4k4=;
        b=AU3rXfb/59TUypF/5HxgpRk9Rf/fx1Z31NhWdFTxVAETRGtv6baKMa6ZuCPLRfwzeV
         qaWAePQamWjQksVSas957iuYZjbpaX5GAG0mNZ6A5DqC/aqZUwP+XikFY9/PGXoNxBz7
         dItygZgPcImiAM5dC0dhU13Ni4HJgEPqV6xr56oCEBhRNYmjy/6mgnMMLlG8g/aVY95j
         qDlxV9dbx5YhKy9seSjjGJbbrDMqaw0T2rRby11I2m4qc3imfloo9UumwAsUHnzZ7aNx
         Ij9QEEFs49q70zK6OZK9BJtqxuDMKAEN+SlUfbpA3oUbioTb5Ee7at6h9bQzomqMFoBe
         bFog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786474232; x=1787079032; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D51mJpyz428idoK2nRe/fA0RUL86RM6cJFboL6lWHWM=;
        b=Is/bll7uj0/oJiQDQwVJBoLsqFj0R+6aQAuCui1C5iw4fXND35KtrFADoi0sIQpLd9
         h3XmgS3wS6btCPPFc64CqRuhDwQDXiYKvEm2hw7M12Py7O8KpHnszHKOvyUSOdked02Z
         kA8T4iMSlYOetYvDmmPCKkW05mWtReXohzGHjKb/ZyniWnkzGICJU0gejzVFKgLpNwhb
         tIMw0cxxjjIBocMjxfMV4tVXr74nZI7uptkqkENIags8N/sOyWCbcxpg0BFfM1YRU74a
         qS6/5aPR17j87bSkM1/az1TpTYZvYElBIFl2B/oI8ie7sKh9BGE3eeN015adtul/Oq97
         arsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786474232; x=1787079032;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D51mJpyz428idoK2nRe/fA0RUL86RM6cJFboL6lWHWM=;
        b=oag9PKGCpcx0l5fETWMcuca3Cn1MA8ATFhw8i7dR442QDhNfqpiuoB+K2aUuE2IpXX
         PkcWufpVtKWiOi44QYtrqGr6ckG/xxebO0NN11u7AazviitRoZmo2JgEEARwcu822N7Z
         N4tv7I5Q/MgwKPh3MrgKoNCX1XLyFHfCOWJ6FNS5eySeMdxLTb1pVzs3a3/vezNcDhLh
         6ceupm/7OPhLqXuqYeKYo4fpDZTIPhFa0tZsSVmp4F3s5rUMiCY8c6Ir3QgwL+O/Z0Ab
         vhOYsq3k6nboQ6vZuMw9VOxRIlE1nEQ3etLboqg2EdDxaBMyKu0tYDQWiZclNlojQhju
         mLzQ==
X-Forwarded-Encrypted: i=1; AHgh+RrjMyWHgcmvb4c6YUes2Cbix56bk9omh2ooPPZxJeYQGxp/sNvuVwaQh0AJp2pbbeMLwfqOXd4d7w==@kvack.org
X-Gm-Message-State: AOJu0YzxK/v6LVwMBxpES1IYcVMyBz83MgRxIFEYgHzBJjmGBd+Hy5i9
	jqbBN6suO6Ti6o+GMogDGMsdBopsPNtzyBoeFMkbNc+fwQT83ZWVG+csCAp0HE+L7+kFPjdA2Gg
	NkMhOnyZDpAJvQvwu7t47wh5t2RBnIBg=
X-Gm-Gg: AR+sD13eKELjvT66Nntp6yuRHpQUVe84CdtW9PaZMd4a1ZI45JJ/4RHnq8nuIjC9nAJ
	zcHz5gZUV7uTeajwWd/V5Jfhdtzqu4uRi9h8u0sC9TvOxDYkV1TUGxOrPrBqqveqRn+C6T/znI1
	3swBvdf1f5jHIyG420bgj1DCi+IXYIqrqakSvUSsGDtL/i6mmRsj50j/fwJ0Pt7LO6kq3yEN5Om
	AsJH6vqHeBbfRbiDuLgu7pg5LuFo+1XikiHI1ZKnewJRe4cjDIsA9/jEAkucoo3hj773V3plmIb
	0MbqEHNIegpRIocFYHJZnatfd8z64KUPVyyvlPKC+422p3w=
X-Received: by 2002:a05:690e:140c:b0:668:6e10:f2a2 with SMTP id
 956f58d0204a3-66b22ca2ec0mr3067399d50.1.1786474231571; Tue, 11 Aug 2026
 11:50:31 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 11:50:30 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 11:50:30 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260811073332.1351893-1-sh_def@163.com>
References: <20260811073332.1351893-1-sh_def@163.com>
MIME-Version: 1.0
Date: Tue, 11 Aug 2026 11:50:30 -0700
X-Gm-Features: AUfX_myZtx69obOXn-V6mj23KtGWjAnWLsIUINM0nsuY_mNQQsXMZbtsmqMiySY
Message-ID: <CAPAsAGyEsYfH7oHgctHRQF=7yiteCZKov8EU8rmeg_h8DAkRqg@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix quarantine_size accounting during cache removal
To: Hui Su <sh_def@163.com>
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B17F8160003
X-Stat-Signature: 3ay3u6efy67dyxwrabowzbo7yo4u1ysm
X-Rspam-User: 
X-HE-Tag: 1786474232-619487
X-HE-Meta: U2FsdGVkX1/3ljNkFzB14Ncb4jaciNASQaeutroXPxgJNS5rJkmHdSIMkEp7ezQgAupB0KXauSoOO4vFHs9cMghepltLW07M9X9/dxT8a/iYjnAnK1O0WRJhlLAjEoau+o7UGiwgkiU7K9eguPz8gBajphNFwioDoQEo2s/+Die8bTU2QPObfDdy3vJm2k6AKZxut+J7oR1zaCwoVUcbOxXaOM2DxXcuBwXPGGndvmTqUQgGApu/LXqcgOToQKnYRkppsVyv1//DdusI1HxBz/2mQwLlijfes72IiQSGWQ7UKW86/eiW0OPQzKqjVdrP9eWSb8Z3qjtnjT1wr3gad+1KCm0qF5q8Eh4jMCrtmtLhlvTnDFTq0dGSB3kXqCS/DmTIs8t+xveptOhdtdxX3DLuavoWbJneHWoiw5tOVK7hkIXpW6nvXfqJKUaN/VqXTOJKDXBMxi9FlM4Dn8z3ETAetT5TlqA6H73DbuuWlqNUfl9uU/5PP28XmxgeRWZ3Y6p5KFq7yaA9HtYPmSao6WM2yG3PAhk3IIwniXmRiH6Qvc0kT3p1bTIDjXMvp/a4hqjYEOXB95rDKCpGpkVafgv+Vc5j4dPOM5OGDOcM6lyb8lV7RJpiIfb+/Du/GiXlwQQs7fNAxDex67adpOF3SaSyY6pF89E72gp/LyCwLT51kK7y5Z1kODfd5zwJu6ITvOkYO2jRZ0Ua/N9a8aKxvPat4oKoeUBKXg3iuxYXzp0gxGNcUJUl4TMNsgEBoT0zONiGKTdangrmRKKsJ+2d14P87yIKQWyOpgivo+JMxvIBD+30VK7GLHEIaSplDHvfQ7TJocyA8ioWfHtcow/pA9k1XM3/90McPctXl0qg1ZSz92iuesUqTlQVv7MOZnOOgYaLzXPt6UP8NPCUNYhAF0mkwgaTg32c5XkhoavKpbYjp4XGIuR9IiSDebhrq33Ue9Fj+WLnuWWVaJdpVJR
 v2Sy1URo
 /M2F+MOaD/DuNuMp9fzXb7fM+WQfEh8beEKWt64ADj//KoM+MxqjxS3hLPyJyyg5ZUeEPjGAJzSEu0/mlF0ighStnoXLp2r8N1q99jgKXLFMnr+Onr4t5x5bm4fTvZUnCMmdKZ28JMvKkOX+SDj2+c4lTp5HkZRReOa/wQWoxI+qRu2iRtCcxDyu5FmYHH4RHw0A/RuUCd/bK90yZ0z409b0h9DAVZx/CI5sb7XpnwQla5TbKnHIM739oAH2Q+dtJfg/IDFdorZM6FeQr4ko6eOpw8rv/1Bba+Ts5m1B/FNA24g9MEu83UjW+idmVwjlwdePzjwLapMZFXSai2vSeqagMSE0mhanSC++Z0OBG26Xyw4cYb0xAqD81xSeZynsAQhhMae55w0AgvTDa4nDZMNGxN2ZhJAP2foVgDmdWIHNeKnGVMO7y8ByQuQz2iZeeWCLkAI58qXIiWwQjz6RYYH/YRpeMUs7ecJ9C1hwZvbhbYv/LbDlfZOq7Re8jlIo9+1MJxYb6+prMhcG1Nm0I/b7L1Oho966IBWNIg74pPb+izUkDeM4EjZACWJa4r78SmQZXc9OJPgSMrysxhsSrOFRwhy+cUTox9jEVy+OXznIxLEefLZJ1hDMymoM3vVifOsZj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hui Su <sh_def@163.com> writes:

> quarantine_size tracks the total number of bytes stored in
> global_quarantine[]. It is incremented when per-CPU quarantine objects
> are moved into the global quarantine and decremented when a global
> batch is evicted by kasan_quarantine_reduce().
>
> kasan_quarantine_remove_cache() also removes objects from the global
> quarantine. qlist_move_cache() rebuilds the source batch and updates
> its .bytes field, but quarantine_size is not adjusted accordingly.
>
> As a result, quarantine_size remains over-counted by the size of the
> removed objects. The stale accounting accumulates across cache removals.
> Once the inflated value exceeds quarantine_max_size,
> kasan_quarantine_reduce() can evict a batch even though the actual
> number of bytes in global_quarantine[] is still below
> quarantine_max_size, shortening the quarantine window.
>
> Fix the accounting by recording each batch's size before
> qlist_move_cache() and subtracting the number of bytes actually removed
> from quarantine_size while holding quarantine_lock.
>
> A KUnit reproducer used during testing observed the over-count grow by
> 4698864 bytes after one kasan_quarantine_remove_cache() call with the
> fix reverted. With this change applied, the over-count did not grow.
>
> Fixes: 64abdcb24351 ("kasan: eliminate long stalls during quarantine reduction")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def%40163.com
> Signed-off-by: Hui Su <sh_def@163.com>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

