Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423EECD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815BC6B0005; Tue, 12 May 2026 16:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F426B008A; Tue, 12 May 2026 16:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6675B6B008C; Tue, 12 May 2026 16:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 519DD6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:38:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F34F41205C3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:38:00 +0000 (UTC)
X-FDA: 84759929520.23.63F25D0
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D4D81C0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:37:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h/qNGxy7";
	spf=pass (imf18.hostedemail.com: domain of fmayle@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778618279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrYDI2P3+uGuMoKwTVd3FJswaOrTXSNDbhUawVFFcyM=;
	b=2PAWi4RBFgFWjO0FMfeQBSACJpNkVK9KrmCj/Vk/hxGIsoxR769PfoJYYxo5k4XA7jGAQF
	PFW/h9cqQ4IH7J62FBVI2sp8GvnLN0LOxx9zCX0VyRrzEXOIM7fk2dtrG5l1vaUrlBJIIq
	tH7KJz2cXY2S5y4csiBIAU92Y1P2DCA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h/qNGxy7";
	spf=pass (imf18.hostedemail.com: domain of fmayle@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778618279; a=rsa-sha256;
	cv=pass;
	b=d+DG7mpccOQ1WiOBJh27ZyLciPRsRCQ6uC8UfYWoQ5sZMdVSyWjYRnzmevnr+J9iaeg7cj
	VRvm0B7wACU0gWpbGK1TFH0CZBDeChJVEvi6GEbHRQ9l7iAlVrbqf9CSRvCg7BOzAytkqX
	YD9HJGbO71MxjHWvr8lVpDUDwG4aECg=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1336742714fso14c88.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:37:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778618278; cv=none;
        d=google.com; s=arc-20240605;
        b=h5vavljyVhA96JAtJqWE5v4+fMhSkpbrfXzAMzqRHvRVTDmdkU7cQWvN/HF69Xm+H5
         y5gaLHs4zC/oQR1bkB9NhEahGfqRbz2UU5MJ/PVNkZlXY5dXKQIyXMpdar11p6ld8S3e
         JBTdB3lO5UD+MmY6erR+dRuJ0hs2UBgf7LQPp/+sFDxhtrOAoS5x+aU8kjEEiGJasQp1
         dXekoHY14y+XdRkr8AkpV2UaeBZrK6kZgoTgOv8G1cN+hCloY6G51FkY1MZpsPws2JRy
         iDUg7aDmTmsYMJKWO/fstZU+WW9D6QMVRz4aSyU+lNGmlsfVMijOVOnHJH6GBvZYayn8
         dzIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OrYDI2P3+uGuMoKwTVd3FJswaOrTXSNDbhUawVFFcyM=;
        fh=fGPJ5Mjx4KMrwiWabxh2hN90FFRNsHYWUq/f5GzBUJg=;
        b=C3bmKLtHnqmGZcEYIecin8jMFo9D+wvk8S8kYiq2J2WbfRK+jqPNCC5bMe9KCFnUPu
         UsWZY2HNImioDtFpvRWx/vCixlffhJDqvO46/5+LzH8lDmWgok0dPIRtIRWH51D94GXB
         ETpWJhA3nMwpibzvF3G1407VhzYULe9khMLqlr1SI1Zmt6hyKizFIKC2hqpziuXIIBa7
         EQ1g7kIXLnTw65zATyxz7niRqyfRpVnaen9dk1t2qrpWNt16HUW0er4JalGByWaeRcKk
         vpsRpHiQOi2c1eyQ4EwSppd+t8G3liH0EJvtLu/ZPBBQD06EOPacmA378BgGRKSACGRA
         7kjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778618278; x=1779223078; darn=kvack.org;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrYDI2P3+uGuMoKwTVd3FJswaOrTXSNDbhUawVFFcyM=;
        b=h/qNGxy7Oojpzn0+nkxJRBU4URCYM6aDDeLyvGjSNQoyfh75CQmJ2srcDwqSx7ANRi
         jZ//xAZuDyCL96ckDO5y7Eedc1RslC1/hXMzYcX7D6MWXT1AYDRxaDEgnn2bCwHtkQlf
         0pZgB3UtiSnfRfNzSGiSNhd3P4D6QK6e39/KGAxm+m7WjATbriolEkVmrb3UE92oLySY
         BYLiz31Xjq50Xyyej2Now2507dUTHwFAcujGEq8yZTz9fYa5XPVWWDsPSQ0rqrjItKqO
         45aProsa5izXuAzysfGR55+5g2WhD0k7k2kr4HM2iPrEHUENek8mzoyjWBF8yDwh7tSD
         Dvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618278; x=1779223078;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OrYDI2P3+uGuMoKwTVd3FJswaOrTXSNDbhUawVFFcyM=;
        b=j1X+buymf9plBg9CNb9hjRzLMz7ayyvxLw297rU7Li2T2+rv5IIAGq3nJBvmFIUlNo
         wqGBgvDKA8XC8UbV0CBdd9ouHW+QHx6KtFHTG57/4R0wSIDVoqfd9PH/33b8Y3ByMCoW
         IrkMUynXVENhTT9GgfMi3xPMco9fCImb8QHjWVwOY5if6mkAnTB2Rjtbm12XtS4VjE/n
         Sc8d1GtUcYoNTpcHAAAwSCOlT4nYlG5/LAtHjxfz9GkfaTRZj60O8ZobSjvFly7CwKm/
         504WmJydyCJWYyb2C4pr24fIoEMXcF5LPZJJOINY9Y+H22Vw1I9Qh/gOfLqGFsApx8/k
         tYKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wRW5QOZ2ASj/6UGrn4zcq+syF1orUMgBWv0WUtaTKrDfL4lruvZjuDUJiq2IJDW584GnQaEjHFQ==@kvack.org
X-Gm-Message-State: AOJu0YxyWnfnhmsIVjJl8XV0uieQ768B/NiO/p7r54UE7Q5S5g/ytn3w
	29/pitJFFKY4mSAtZvvVSS4U8CsuZlRQMC2O/csc3qWXURzXKeSNvY+51RlrX8V3Wua/1zxUpyB
	shIbeKUwmZu5cPXS1rtUnHXQEBVLKoUYDkCYc4Lot
X-Gm-Gg: Acq92OH0Hc3lOztQTimigwWkA+jzyVO0L1GFpz9HLgUbYx2p68kvnwxegBIcpsPkSde
	KGnOjPbzbnHBgUOpYwADgW+eHIKDKQbgKOVAxgQJPjPvr1M0y68131bU1OY40jsRFIXbG1Ynwa9
	dZ22iSsvQ61dlNxFi51BxMz0uWp3Mo3jscioyVF/l9CXoZ+1sQPg4Q5ovKV6Ue94wWR3Gp7qnpI
	6L1RRhQNDccNfhYDO4Ky6H9neaOhjuK5Dspraup7C/YZju2cbKGSPdM7Ie+9oaMynx7qo7Ng1Qm
	kknz08i3usYTgqxpGskPkecV8YT4mb8ufPXmhd4OF21mXxI=
X-Received: by 2002:a05:7022:f9e:b0:133:12f0:c144 with SMTP id
 a92af1059eb24-133fb2d63d2mt154907c88.0.1778618277002; Tue, 12 May 2026
 13:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260512203154.754075-1-fmayle@google.com>
In-Reply-To: <20260512203154.754075-1-fmayle@google.com>
From: Frederick Mayle <fmayle@google.com>
Date: Tue, 12 May 2026 13:37:45 -0700
X-Gm-Features: AVHnY4LUH4csHNJ57nbLZc63OyezIngjmZ0PpZ-8t1Biar5aP4v5cPbOd5gslHg
Message-ID: <CAHCxdc4Bk2DvXB3SE09ge-xyBFQDcA0AdSN38dYUUiiqUd0b4g@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: document read_pages and simplify usage
Cc: android-mm@google.com, kernel-team@android.com, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D4D81C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: xgp6aw3o8xw1t9zkb3n4bwyat7etq83i
X-HE-Tag: 1778618278-243581
X-HE-Meta: U2FsdGVkX1+60JWyY8I6BSVabRAPmmqMaH3YkBknXkz4MirPICv5UeUrmcInYmmzkPnVSEiBMW41iV2ATuJEpaKaI0VtvNCldZR9b0PHGRhm4fj6pQWO9NwCEVBrwgNLplJJmJti5stXgjup6+00Wrzi3D6oTF24NB7u2m0AfdIQsDKJbq1CE/jPC7Bttwq0OF+3/t0DEXUqPnnLUDGo3aoblNWLcGCyPpEl5EqCCAhzrM5mETXi19TM71gcgcdRCkZ72jcsl+aFx38PCbUPCE8EukuNNJMYZzUA4OeOYIsGVQDNk+ym73ApnOyGHBz++eQajGkJ4JjcZg1KAmT0UAaZjjYYvCbVfDirRBIv1OktBNJh+FpU5RL5Zi++W2DCSGW2QMDwOjvsL17q5zzPwKntv1syKwb/01PQ037JqUBOSzcJZnIbbXb3t6g1Vz7ji7SFhE6S6dw+5gQ3N3QFZtvzc6cbVCLHJCkxY5KZ4endW4db1jBz/CGW5Legkm44S+KsqIEOcYNWAqLWibwOv9gD9wek2GSmNQEQiEu4fCeTHmZLaspxM20946rReS9IRLT84HV4r9Y7xVcgNDrgYt+MANgK+PwaIqfbg5fLYHmulfyNTTvZWqsiWuHnWArgSNw5l1Ix3bLpVB6giR06iCHCRhd6qoLzrZA03nXTy3Xgt5oZMMSvuiXBvFhj+YgBZ/D3A73mWL0fSWIY8h0XeLO9s/mCnwoLJZGELo4wmTM6SJS79Zrt4oqrQ7va42DEgvBPvBIS2lG4XK/cTbMXlQ5v2vpIkSXv81ZuKklmFtXYndLJ9Ei5r1Ly6OXbY2XbTWIung7R4uRtELPA6dIRj86iKI9oPDsLxBHaZu/M4V1FkajldlUD5eqCKoWz/mcKFTkKmQovk78DU2hlCZMVpXtJAjF3wQZX0LmOTtaHnwPlTZV6YyZNoQIysxNp0/gHYA0FEhTmmpJizrdvZqT
 uq7dTe/1
 EZUwblNLuC3jhxCIQpcW+cGqvJ95NuOifO1ty77y6N+7yLsF8aK/Cll5i3VlwceYN+WO6ZPMJdjlZ9l7d1t/ZXYp4i6CDdURABwjVx2npcZAcny29ZSB88I5GWgGmHvaBeXTJVyO+Awnxgttq/Uf1iwxB+x4nmDpVahIg9zrSDCbBY0wcFa2PJu8KOQmQSNa/QUkmfzBeYtmMR/Z2Ti8ysljqIu8eEfoD20sI3q1+b3rqPPoWXvu58SYwTghD22Sb8Vxst9STtDGIgErUM8GVZ2hsqSIQ84/oR5peD8+lkL96YW6Hil7exnVQNMj/LyFjelXDv7ducFnxzeY65uHaQ3rNYp3CRsYNC7B2mtU/VGiJFxGKiuXqGfyZexbPSx3yuZDTtXsBkRORhIdZVaxCVXRm5rsc8YScnBa4CJdAOzrqHRFCzl98dLSymX9IGsUNa3ch3sE+vMQBE94UUc1JuFCAww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a combined v2 of the following patches. Sorry that I didn't send it=
 as
such.


https://lore.kernel.org/r/20260508015402.735441-1-fmayle@google.com/
https://lore.kernel.org/r/20260501011908.3630802-1-fmayle@google.com/



On Tue, May 12, 2026 at 1:32=E2=80=AFPM Frederick Mayle <fmayle@google.com>=
 wrote:
>
> Add a kerneldoc for read_pages() to formalize an invariant and then use
> it to simplify the callers in page_cache_ra_unbounded().
>
> Frederick Mayle (2):
>   mm/readahead: add kerneldoc for read_pages
>   mm/readahead: simplify page_cache_ra_unbounded loop counter reset
>
>  mm/readahead.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
>
> base-commit: 972c53e0ec3abfc6f5fe2cb503640710fb23cf95
> --
> 2.54.0.563.g4f69b47b94-goog
>

