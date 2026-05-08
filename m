Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685E6CD343F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 02:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774E66B00C9; Thu,  7 May 2026 22:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725E66B00CD; Thu,  7 May 2026 22:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6143F6B00CF; Thu,  7 May 2026 22:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA606B00C9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:01:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D79BA1C1487
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:01:42 +0000 (UTC)
X-FDA: 84742601244.28.7E2E92C
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id E4F0D40009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:01:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tCfJx8ir;
	spf=pass (imf07.hostedemail.com: domain of fmayle@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778205701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jsJtIabJmDpsyQAeEg05bOKsXfq/l+0TOvsDmHecoE=;
	b=5OY7cbR8j8/FEyImmAR5DLmUq5zTyeLC/kjEN8NV9j/3a/pdB28UZRfCQaaf6AzGBmAo0o
	hYbpPd8DCx4t9xxJnXMttBKjVlAEj45b/UGwB3gjT8mrg/NPY2njyXhQsC3xxDKHgcI5QF
	0zLISaevyetNxhDPFfl0lVxm5Up7DV8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778205701; a=rsa-sha256;
	cv=pass;
	b=eS5FQMOKh/PfoejpdYN73FD0UFf3bFuta1o+T5nab7FMr5MzXo7cXTHwNF9nJe7jzdj3/K
	Fsqb17NXvjNIfuZlGf9Wmnnse1yjJOeIQklBiwit+bTSXAR3HxJs7UXllMqwR81fjeo+nO
	ikK6MJ0JqGEP6k3iVxFsg+2i0qfOD9A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tCfJx8ir;
	spf=pass (imf07.hostedemail.com: domain of fmayle@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4e9697so3566c88.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 19:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778205700; cv=none;
        d=google.com; s=arc-20240605;
        b=kFjhlgJXueH6GSHVQJ7Lr6/aalttXkd030kj5D7OnJZPweKvJg/3kst4fNcsm3nyBz
         G+b6K3GwYX64XihAefD/0Sqlc/0mCcehTod6uTNmaCZjARvWzyioxeqFrAIntD+tjnNw
         1/riRg0/KyfKsGrEFLnnSBpG8GVmYQ15afaDm/QFESOTSGBBJZA1pKQ+2WXRUKsf7Eet
         Nug3nkTbL5gvp7jf603cf6zGMguT9NBtc6ghg26e/Y1+kc7qgW4FvkjsRHKZ/RG7SmV6
         h+PYsl6VD0Ry/hb6x/9aOcOhsL0DWSG8KQ1MqkzmfeqNyFK5J9/f+iI+qqxEDjrrCAyB
         j/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6jsJtIabJmDpsyQAeEg05bOKsXfq/l+0TOvsDmHecoE=;
        fh=ys7DXr2L9cDBBoPT3oH2J19rFp8wCHRLIzSTe8RNMwI=;
        b=WKj5W6EnHex6T1qHO37P+ZGw3F9ch3h8vb7UHO/YyoI1iRgePedDcoqKXItJWqeiFp
         7XNyOuzRiRCIgH5bPeMGy1AigCeuwvfdetatrXyEqkrINm+z1XO/qAQjNnt+L8fypdPZ
         VCqvyJRPsdy8w8E9R/s/yljvd6DlPyKZgbb0Sbx+MsI2L+XQkwvuVOeNGcVJ8JzC7trN
         JA7RdiTqjQSJ6EjzGbkc2nNREa7doVVillfpAZMZE9531ZLLNscJLognlbkcbZemWqqP
         VFwWR8sULSLFandi78T1veyScfuly79I5ajpSJdnjcHIQKrVgu4w5bD4gotnqfy0Uyso
         ynVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778205700; x=1778810500; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jsJtIabJmDpsyQAeEg05bOKsXfq/l+0TOvsDmHecoE=;
        b=tCfJx8ir+91tANO2pigyZNcdg2HOiRlnO88DbZkbu2pYSDYcMevuo5x5S4B6d7z9Cg
         wmXKoN7T3Vrh8RVDFsFyFPdKcBNK0eHtuRrSM1Y0IpyTU/4rKBGL4MB36POEvOmbR6V5
         K+RNYmKERz3UF461hxU0DbYFrGN6aoB2jyJ54ZLk/7KBu7U4vAB4aGdZ02kfmdMYSo5r
         pFzZjTMIbEuiXghm2lVHbwQ6BHtVnEo4yoATT2zT/R91cB0/dtSW/9kHVjYjZ7cpsSiI
         QIYrmP+YbN4YOCPVHzBapbW4piugSL+xDpu4YdfgJv3p0DdPPmsuN+MpMbzqTOHMEzk+
         3ZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778205700; x=1778810500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jsJtIabJmDpsyQAeEg05bOKsXfq/l+0TOvsDmHecoE=;
        b=miOcDxhnfJg+tz+PqFFzafMnFyy4TMA7nsImp8A3hFuI3g2GoJ9B51hvITc4RwNXfc
         IU2Wc06Zty6wkEpgh7Qp+8P7CnP5pTvdyAT5ERE6i+BkisxUFYoqUKU2Rh2VE/scCwqI
         smyHfIexAhYlruW7nuyi2n6vl0If/IZi3k1MVDViFOj3mKqNyxLjZ+O7Ma2WQDXBIs6M
         PVsTAd7+26NrIdjSxjBizWFj2ufqDdvn5BbgbHSU7r4uYXuyJjU/lK4mLysEqAS3yT64
         7BUV5fETuRxUcQKfrtH6c94gZS7uzZk0/QtevKvzZlf1xsQmk8aGscKrlAb1iv4kwY+f
         T5Mw==
X-Forwarded-Encrypted: i=1; AFNElJ+Ldp2ZnXxcdHUm65wGupyrshfuCVygpY0jBZt7E2bEa0z4Jom+EdIW01+uGvo6K2/5hxO/MxXfiA==@kvack.org
X-Gm-Message-State: AOJu0YzP2kMbxh8xDfL9vbN8I8fJvvHhk3i1ZnnTkqCwlgmfCNMkHniq
	cASrpA3rpIOWDCd0RkDN5RpLyS02eryaqSBtd2mLSXgPIMU3yEMEuOp0XwuB9SaYqu3B+BfXS8j
	n/DKOpc33QqZFh9Tp2LKF/O4EUjAmExxhikj9PKVe
X-Gm-Gg: AeBDiet5ieYMDzFUcrbQ05+PVSmbwf21dsuFiU+D5rbrKdQ4iTHaUHH3VYquGTavJbM
	wf2foaGZ7X/qBt9P09BmmJG7IxLgL5BG0Vi86Bj89N7dsrLXnQgh6v7A7nGbUDQg41A1Fjw/vj2
	/tRyctDIMoEdmJYmksN1RCaAj14HGSGq0+MCMlLYbQ6+J7XUjId5qPTDiG14e8ufKP+ZJpk+t6L
	BpfZxrrlYK7Ul4Z5HtLcperpO0euem6PkTqOY3qQYG7n9uhBGmB1M1FI7Ekvcr8L/W5Ya3Dvpfq
	RHlS0IbvA6xoVHTtdjE=
X-Received: by 2002:a05:7022:6706:b0:130:c9cc:2919 with SMTP id
 a92af1059eb24-1326f5e59aamr47946c88.19.1778205698960; Thu, 07 May 2026
 19:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260501011908.3630802-1-fmayle@google.com> <20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org>
In-Reply-To: <20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org>
From: Frederick Mayle <fmayle@google.com>
Date: Thu, 7 May 2026 19:01:27 -0700
X-Gm-Features: AVHnY4Lka4VCHovYje-DOBwkYGJx5QVAilqV-2NuomKV-25k6NdoK_k5CuukxfE
Message-ID: <CAHCxdc5Kug-o8ubLmZgeQdcFmhvAMmAtNUc95t1kx3Wjggbnvw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/readahead: simplify page_cache_ra_unbounded loop
 counter reset
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, android-mm@google.com, kernel-team@android.com, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4F0D40009
X-Stat-Signature: ij6codm6beww5a7joagi1jdwg9ejqkoy
X-Rspam-User: 
X-HE-Tag: 1778205700-643085
X-HE-Meta: U2FsdGVkX1+9i+gwkb2599dKgp/0bL4ie9yoO1T0uzLiOPKCeezXLs1RCM/T3aaiXeokcvxjSGDtcLKnRwrcdeMf0GZDjYveuccQxLtgwQohaxZxpWuTiZrd2BGJ8+9TEv3ABAtd5/BYOLhIGB2qjU7VGnqAlvGDWAJ3pYRKr3S+2BQ9ZwN7wdT9lFXanOPTVg/jNeNtbwbF7N64BgyExh+4eO1ntZ7e71D8p0QAJQFveucnh5CPD6dkea3kcigvwtVeexwsbJjide20gLbEenuSX9et+0o0aNuD2rj/RKafymriY+sSDHwP/e6PPRx5aNql1beknv5Bk/nZCsUF2S5dE9FEqCVqdJjgskWMVucFuP+3bXfDKcpi9hu36ysKY6sdOyEAquU/rklSZkIFtM/JrpA6upyQZMIyYPQh166uxnTxfZVrErYZEBPT3Jdxt2QWsfE7btc9EDMJiFyDb/Ag7vQY4AMz+c4z/8P/wm1P96PF0fe/f9gFBZuCys9FWXKGAOy4NVaWViXLNTd5qGcnQ2krUyFd2F8G6hGMiMvAcnv+1CWcTBcIwZ0+jHQGDUjO7ZwK/oxLym8694AoWQcMlv3n+DF/UV6hWVMUzJvNR95zXRyvaBr6y+g2IWctDOOOWVzrl2znQYsCMPsEdWjARx3hDMS/RmobN2qHoWKjfZvC5D8p+NkMvlqJtRTMU6cbBXnUbjvDf4jqaSKTuuW8qNe+WiFTAp065jeOkPC5TLfqI2aWrk3rTHSK/NqMT7Y1KR6eeLEZRFUcctwVd+6JNnl3t86MsQSSepCGC83HPNFtTbyr3BLo5hypz+Zya5OnOlVn8f4ZEf7BJmqGeKDHJcQWvwJHvDJUEnyd/upr2I5LCGB+KG2J782aKuoenS4Vm4wiscH3v0Gh3tG4HwR/VXDS7Q/5SGs4WcxpuKrQF9H/dciwsXv9JvawTNSDJdf6Pc5nWk1k2kPhiI7
 KI7JOXXN
 pu246jKSTQVtDJv+xnzIkVK6Kdc45MQlpQOEbxVpIcN6K6SMkOolCg6QrVC0ijBMbnAW78mqGbU12QSs2GycS4n8k1XQqq3z9CYI7wvZxNa3GvAm6SqxDDmTcARgwVwrDkDIf5yPji8gK7Dpxp8A9giOUCyEJAtEpqRoBRxu1ZZ64D9MCp1SmCoKmvy8sgqtTRKsrkEFEoMDjmviOkAeUrUX7MHMbDDmO9yqea9Bm3UV0N/zU122JP9dIE8KG+a/ayZBeXl/rkCl4M3Mu7+rRKQYGWy+zwkqXiYZlbIYSEjb4IfblN7K5HgketRaNr12ODkYS05Yn/q3hbA2vebnWFxu3rgaXDhWQzSwwHTD0/wiQXZTS0cxRsncWkNp6fMv+kzyt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 6:11=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 30 Apr 2026 18:19:07 -0700 Frederick Mayle <fmayle@google.com> wr=
ote:
>
> > Minor cleanup, no behavior change intended.
> >
> > `read_pages` ensures that `ractl->_nr_pages` is zero before it returns,
>
> So it seems, but depending upon this might be a bit fragile?
>
> It would be better to make this a more explicit/formal part of the
> read_pages() contract.  kerneldocifying read_pages() would be a
> suitable way.

I agree. I've sent the following patch to document the invariant
https://lore.kernel.org/r/20260508015402.735441-1-fmayle@google.com/

