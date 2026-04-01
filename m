Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC051076387
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEAA6B0005; Wed,  1 Apr 2026 13:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668CA6B0088; Wed,  1 Apr 2026 13:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530EA6B0089; Wed,  1 Apr 2026 13:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA7A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:11:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DE7D52D60
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:11:21 +0000 (UTC)
X-FDA: 84610627962.26.708072A
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7F972A0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:11:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLFpeS9V;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqZuiU/Uwawkq6HgVlP6yMHEQIxXC9LO0ktZ8u6/saY=;
	b=Fw33OXaBriFrmN6FQDQEBn9Uv1X1FFFo7kMHsIqlaWR3O/aGJw3ba402pknGTkrr4ylcUE
	o0n9zFOLUfTatzi1A33m6zprmcUXGjVwXlrjqy+Kv3VvvxEvL489qy0q4NvIm3g+SuRP4X
	78tDWYGcXWKOVBR+ipIK3UhXuaM4aDs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MLFpeS9V;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063479; a=rsa-sha256;
	cv=none;
	b=ewDuELKV62oEKYF4abtoXcYaRa6HoIpanjyxdvray7/Z7Vm1TlUDBG8i7dqjbbdLdzqW2m
	s/PJAOwK0CqZTBO2qdj5QX+Fy7bm+6dpgslkKa2sSH/w/dRIVo9xJ9uhu7Gyc8Av+d+mhL
	J5BbcdBLe274OGnEdASeZar3UX4yZJE=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b4520f6b32so63862eec.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 10:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775063478; x=1775668278; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cqZuiU/Uwawkq6HgVlP6yMHEQIxXC9LO0ktZ8u6/saY=;
        b=MLFpeS9Vnq8vrofCc8Qzu70syVi560nFm7YX/XYWkBwOgQMqtu8vpZt8SBh92ruT6g
         /UhXSFieLxUZeSHbd4fDZBp0/Noz/ECZwD9L0hac8vklR6xi2i63eLHSGf+k48Ymkbcr
         vkUS9B7KekVbO4DAVplaGtns619BCpj1ozl6RXBFlvxfcB6jMBOISmorqi7t7Ph8U5+q
         ywYbPg6UizK4eVsoMi6I1ILvX4uNkrfSamM4EX/7dkPHToEsqKkJr1J6KORcTwmlAT3x
         zdf8Z7SO0v2Zy/pLGgxkV24aIrgGXObLqxs5lSBJlccISyMnGxvGDSB0sp/m88iHOOVt
         ltOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775063478; x=1775668278;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqZuiU/Uwawkq6HgVlP6yMHEQIxXC9LO0ktZ8u6/saY=;
        b=o/MmQuxc8eWNrr1dFjatKtAlfWnMFViQvq9PgJG5eb+4hleYcwQ3JnVORObol0iXjP
         9CMx8xDeXALgen/mzpyOkNDkmyfTvMdDVFRvR8z/ZLvY9z9uC+nKoZugWhQVL6KY1Uhw
         FCVAGIrGgj919tje78yXJkyvaKdyRRdwuRLZw+PRuxcKQpHJIefktMGy2GfKtYHXeFYh
         0PW/fGI0D6A/szaz1kgGjs5tB+t3Yr+/H0UGwV+wFu9hYvDYGtLsj4+DVWdMqkPL4S68
         iCM0rNqWcpDkzl/xfGdlL+Y50ZmZ40YWaDrsE2gSITsKJf20qnDVo2+iYMrIrhZuXFI1
         kUcg==
X-Forwarded-Encrypted: i=1; AJvYcCV/iVwP7KOZ++p0ALczabedvxA/b9CkUbELjNE9hseeMJ7kG87+FsGlJ6KffGFbJevVYjbjXPZEzg==@kvack.org
X-Gm-Message-State: AOJu0YzvlibhzWVL2zpfg2F+B/UOB0yUGwPMKPAguHd1rd/I/o6nxypt
	H+Ltf50cH0bG3gbMRgiObYS7nwQNcojOEjMpnXtiUpvF82gYRqYQSnsa
X-Gm-Gg: ATEYQzxNQ6MRrru1R4ZaCxlGseDrhi+wp8JikDItcbuFlfuxqNRT5nA/xJaOgtM9qAN
	UK9HN73R99mPPvha4QUz33qedm+YjVHcVYzrftfybCBMraFH0XspInXaCDFBaJvONhU9cbKCnZ4
	Q2zRANC3/zd/XNWuvVrJ0J+5W6DwLlN9n+nC15Dd2IBGiQIq/pB7FsUMObIzzfrt1oXbecIqZ8j
	qVld5jaYmFa/xIx/y7HtSfmjexakZhfWjmo4SaA+Dnce91mnGloDFRadlony6chEgfuo5Dfi4Uq
	Bk5WsLgsVIZuOS4Lwlina5XIDnx/U1/mLziWKhmaU/6U8VY9BUPHPIwZoEDkZ5T3aIbHKkP7rtL
	k6bbG264v1EgCVpdXhyOCYuMNwbPQvZ2/TV5goZ2IuQIkj+Ce9GAXZH5GaJuOjK3qfbHLEhdQya
	/UMuFc8ZFi50+tOf3g33rhRW+XKmDEF808SDEc
X-Received: by 2002:a05:7300:aa8c:b0:2c1:23d:c728 with SMTP id 5a478bee46e88-2c9333bca76mr2295783eec.31.1775063478040;
        Wed, 01 Apr 2026 10:11:18 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90::c63a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca792f3f3dsm250190eec.8.2026.04.01.10.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 10:11:17 -0700 (PDT)
Date: Wed, 1 Apr 2026 10:11:14 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: cleanup flag vars in
 alloc_pages_bulk_noprof()
Message-ID: <ac1Rsmwl2pm8QV_Q@fedora>
References: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
 <CAJuCfpE0zdEn7gguY0vkXpT2y4+Y6oniTyT90C-1KpXS4L_vEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE0zdEn7gguY0vkXpT2y4+Y6oniTyT90C-1KpXS4L_vEQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 697jjop1zq4c6o64x551xr8xoxpz87s6
X-Rspamd-Queue-Id: 7F972A0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775063479-305333
X-HE-Meta: U2FsdGVkX19CfN8iSNhwHVktIATUY6Ne42IkNrBXwxXvbtGRWto1ojmKTqTNqQXNjT+hKhwzCy3vE6pYwaWEgJYqDEND0i+Vi5yYnvIq4GKU0AvOpDiqp9+2SppcxMCccFWbCBL7C0Qhgzx7kO0A8TBKQVOhwWl3xY93VfKLJEL7FMWg/IRCePaF16A32hXbjC8ePHrYYBTavOzeOBFpRVW+xOD3U9X/vnzF7FsuEcp9dy7UMmi42I8Hg/iFO5x7fRopS46yFM2Y31pR8kgQ/arRXUVLxTH4TWLTQLONS/JID+4R3JZxrUUNE1R5qIrIqn9Gdi/dlP+ID3qTESh6rhfQbWdzXaujx6Ifm15RHQvWFF7M5orRmhIntEWXiW6OxDrCIK2ZiRyZvMK0zLK/Y2kT8n3CsHmYj1cfXZ0U5RCt8rE2g0Kij0BnbhO+bfnEgW2N+OG6ktKkME7LaHikt/XZ8gQkth8y5gQCvjmwz1vjBDpKIbk7gCj4KEPe6SY+VL1wwwzi70rMcq5GbSdxdaIQb/m00ogSptJ0Qf3eN3DNxTQD7zx2zoCy+VYvTB0enm0awK0LY5Ri6H/+aQD9iqlpq4mymClr46fJedVVm3wpE1F2206FbDAKDBceWTI6vLjlgEt37SUa5CEeGEd+tczuu0L5IV1YZBmfdYOh9upvooeJKG52ClYVi8vZ/6jjgSMb9VX03shiRSxqhFgB3UX1BfVDD3f99a6I8nlNfVJ269fE3x0pRms61ofTnugMKqqi7qZmOtzrN+fyfdf1+65ZdjIv6OHfl54uKZLxxheJeKlDTMy9Wo/UrlahW0DtQi1qJrxIQYPwEJQc3THp3KKQ8Q2GrInVEiZTCaCAqiNzDHuxtZKcSHqNAMzFgvQ5W1nx9ztSs+1kPCjL4jId45RQiEJol4lkO4X/lkDxmciA+37MZxDBo0YH82imTOUcTBSLi00RNFiLiBIva5l
 Rr2UVJXY
 n55GZ0jQORqWsk1TZ2fmQwrKg6lZOvizgFYHErMz1izYxTN2P2QikigzdyPXFscrQXpTd8NMePsK1V1BnQt5YKGPaLVbphaUBlDlk39tG0TXs5ab2ouzT80KmSKiEFNcpMbgLoxllzJstjyygyH3XejM09SbdfNxHq8jRvqB2pw51wEo36ZykRrVbSOnqvY2TAcUwoqg58r7c2kcv3A1zq16pECNyY5WCd7krXzH5x564Tlbz9EU/RdsnTVZEWq2bRqLPuWrZxhD3z69laJl8eKZChwIMc4iqUyKn3zVpaEgLehHw0J4qV3d+uPkbTAfaqfTHSQf6PPx5TcsIRzm5KTp3dmJTWfYYbYigwjezjk83h73wa/PIrYxwKb5srFyubHyhF5pigkDQiEvO3ulF84f7AsG6I9Ul+GPEWPTmYl4+TpGXvEvJKxvzNZ64C+Y/72mGzXtlYtAoFpAu1hsLlKYGyG8jAE3Ks5mX/hcXrtc/5QFsLNOpLm0bJdfkSMjyMbbFgROE8qnFZZdXq3H+Of8POGY661Fypr85JQIgXLxvek7FRAvhwwtcj4FP/5lY9IUqSw/yqDodnUPU9lkqJhwxfqhE44s6PNc5jcioTTY96prlgLw5oxd5Xx+enQhOnqBODWIMVhjVAWH8fOiPQ3Yh0jc/0ye3PBouFGa7cW5kgqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 09:10:11AM -0700, Suren Baghdasaryan wrote:
> On Tue, Mar 31, 2026 at 3:52 AM Brendan Jackman <jackmanb@google.com> wrote:
> >
> > These two variables are redundant, squash them to align
> > alloc_pages_bulk_noprof() with the style used in
> > alloc_frozen_pages_nolock_noprof().
> 
> Indeed. I'm not sure why this was needed even in the original patch
> (387ba26fb1cb) that introduced this function. It carefully preserves
> the original gfp even though its value either gets overwritten later
> (prepare_alloc_pages succeeds) or is unused (prepare_alloc_pages
> fails)...

I did some digging and wasn't able to find any reason myself. It should
be fine without it.

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

> >
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

