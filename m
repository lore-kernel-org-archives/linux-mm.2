Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887B2FF6E7C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968506B0088; Tue, 17 Mar 2026 17:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9198B6B008A; Tue, 17 Mar 2026 17:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807B86B008C; Tue, 17 Mar 2026 17:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6C76B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:09:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D33E31A03B6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:09:50 +0000 (UTC)
X-FDA: 84556796940.04.754B896
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA05D80011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:09:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ixeiQtMR;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773781788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ypk61QUK+VkZ22Qfx+ACOOGg999pSyWQQ0KsJZ9PPLo=;
	b=May1i7GGsqM0/aomhcJVmKB+vEssbMgTxb1qOKL0mbknyCsXTzODhAZfUjmD7ccNlZtvV7
	w8ukL878CeQVCbj7hp8yXU5cWnfMvZUJPmNZx65OidQ6d554/woX72C+1VWP7lGNE/Jo2c
	LLX5Q5Tnel2jpgrIqaBcOAEiVzPBtKs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ixeiQtMR;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773781788; a=rsa-sha256;
	cv=pass;
	b=am/eFmyl20Q1vlLzriM4eUjV38DaoiINmW7/0OTnFkHOHi+bhbVv6HaFZaB4yk1tal+C9b
	zX5J83Ol6lg4MTIgwoHZsfjaWvNlb6fCYrDNBr7MWiw4Sb95j9wtaVGoxylu+v+A4pJ2fL
	zKkmaHHbcyfzpdygAO9LxEotmTeSlas=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2c0bb213b16so85176eec.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773781787; cv=none;
        d=google.com; s=arc-20240605;
        b=W3KXcdv688LP5B3AjzQzpHfEaoiX3VxqCpNrfBd1PRGcmfqqEv8kBkvY7UBlVJ0jT4
         OrOZ91DaIKlWsz81PBHqU7v7fgVJS2TY1gx4gJRi4WJsZjI0MG1D4NToEyKxhgftBuql
         E9g5UUjg/VYYJ9MehNXxIba7ZKnozXWsjnS0if0MAXs2hGCwpNZh2qiDKPXBA+57WIi9
         4up5Qy/MWQd4W3vH9g1ozCkAMjyKKJOWXP7jmXdIiFy/ko7SPPjxuCAjen168y0w+kCm
         SfgPDeZd9oyuqlXtbCxAE3Oe+yxPkSP95gU1RkxyfU86Pjse05+oyvMkVoT8+JGb58tX
         r9jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ypk61QUK+VkZ22Qfx+ACOOGg999pSyWQQ0KsJZ9PPLo=;
        fh=2ptvLzd5JLuSg8KnGZQLLUY2vCOPl0se1hyFQrndwWs=;
        b=Su3BKnJYYEA4sWaMAPX9dzt7LlOUK3qNzhg/nl94NM9Q7u8NdN6b+X+Ry5rIlIo4/4
         m6kEgyGnh2oOtNHta0uvLjOhbaGwk8xP44aUmBWne4qm1QJbxDSAEjUtJzu2jZsCUC2I
         EZSisYZYmWAQTRB9fmNWvhX0P5LkVJFEfTAFFgsCEvPG9JTdX1K9lAZOWIL5HuITHZer
         AlVYVs320mNANC1kJJZjG+9xB+cstNFBkRqIiOT8ZI5jt9rTJBw0kXtlv4aTAarBYgc8
         l8ublOMJhOQsSIiMSUtjJJWJzc51JMrfG110UWUpp6KBFNnIkaIDokfvCQ9kKPK3X4yN
         rf5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773781787; x=1774386587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ypk61QUK+VkZ22Qfx+ACOOGg999pSyWQQ0KsJZ9PPLo=;
        b=ixeiQtMRJZhwsfBMIg5TE/Eem8vdiS+Vno88hIw0jeo3Wn8uoAtH6pmD5pSpDkt2Ue
         +UIdZQDjTPBxEhm5jXBMI745C3DwvwQtzB+nxNHRb9AP9dLeW9Cy5Bys4smLTSY2amgB
         YsbSfjlevJ7oYUuzlWjy8NaJQSuS6MPvvPW6Cz1bPLQG2p64p3e4l3ikrkP+Bwc9sf/t
         SX7enu5hwx35ZSMHg5ui+9Uhu14C1EMFeat4GLtfeFp4Am+xaOhu3JTL+/Zqz6GBCydB
         T2YbN6k+/pEBuHidtOn4D0y+SMprG14fK0/BHwmKG5ZUQXCATqV7QJCk2Ll9bPeN1H6I
         h+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773781787; x=1774386587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ypk61QUK+VkZ22Qfx+ACOOGg999pSyWQQ0KsJZ9PPLo=;
        b=CQOaegKhpQ0Eu0+L/0XkkfMgl11JMkWc2hF7/+TchaQBbkjCea1FT96D4EMcew1Y//
         TERVfmu/O3WFIqIIbLF+zhVYK2MN3cHuzxUcOkBNUQaQ8U2QY0RnuPGYuN7C714MJjtl
         hO/adJEIiNxL1Jtq2XoNpIVG3f2agRyZkNn7eNupt1vg66q/zk0NwXSo15T/8igRMIQt
         7tTmnZxdLPRvRltmf571oGDIzxLjmnC6P/bVWQAolFEx6QCUXsA/v5Yx0PaX/+YQ5VqW
         BWD3xGhRdB3tW3TKfXeP20yJCTDpW23fS62S94chT9ZJHcjPeUnkywSjWEEE2I0kBbiC
         s5ow==
X-Forwarded-Encrypted: i=1; AJvYcCWaZqpII5jLruVe/jTUeHlERl0Rzz8LEqnvkWQldovUN8vXNsD0h1qH5eaTmI8xPMMvGs3dZBM/qw==@kvack.org
X-Gm-Message-State: AOJu0YwPgeETswv5cBz7PV6I1NXTKUdPIxcKqqDMxBFJVYsY2KkbcEUx
	7SJlPjlLEYYBTeO0GDzcRbvgbbKnL6m9srstF1xSZhGtmW9KBx+p96K4WGzdtKT6fBKqFiNleKy
	q96oW0LJY6QPOjd0qWAgJsJ2WA4JYA4s=
X-Gm-Gg: ATEYQzzQ3qB67V5BT3vgZ6zWrLslIFzUoT6wp69WY6Kn7ldmsT7PNIfExdmftyUM/qS
	t4iVgzUL+o0WmmXFLMspljZhpVemvKrn2icebBAgPQb3eIaquE0/EuqfkeK8EsiJqS7tFdZKePJ
	gGvV1qKvtu+SH0AQgiCNZcIBhurzN9JiYn3CEgkUojXUSlzWmv/Et34eT8BccR3nu6/6tV31/Gq
	gtWgUvXUw6ul5Q+nucUL9kjMdHHuuLI23VJdHX5Z0y3916hdeMF6JoTWVhlZAwKtlsGNcxquzws
	E82CGRyA0HbtPuKi6M0yuzuScK3psztM2uKg7v5y
X-Received: by 2002:a05:7301:6790:b0:2c0:c5e4:605f with SMTP id
 5a478bee46e88-2c0e505d4bcmr510700eec.24.1773781787432; Tue, 17 Mar 2026
 14:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-2-kanchanapsridhar2026@gmail.com> <CAO9r8zOD4UxqCmtAS1UM9o_AzOoe_09F8+ApTC6S0kkfFPg8wQ@mail.gmail.com>
In-Reply-To: <CAO9r8zOD4UxqCmtAS1UM9o_AzOoe_09F8+ApTC6S0kkfFPg8wQ@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 17 Mar 2026 14:09:36 -0700
X-Gm-Features: AaiRm52DbB2msI1nZ9bw4Eju9MqwSfiIewNZrUXyNp6GmMEX5WER4eVTkfAO_yc
Message-ID: <CACpmpodOkgXt7sPE2yvu2R7U7dRb2tPJGRy02260x9NDEXrigQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CA05D80011
X-Stat-Signature: u3heygk55woh1fzemcwzkafmagiepya9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773781788-776256
X-HE-Meta: U2FsdGVkX19fNnXDYs4raRp9M5AkaPeYFrURxf0fqEqBtIONb0O0ZuiCSwXxi/2jq5eD+8kwuD/J+cRQAKuRVZaNTiLbQg2njT/wpNBcW4smXTQ4r4y6t2Kfj0fFv0DI5GDxu6/ANyd/ZsG0I9D3kGuJQbVRcRfWF1fkydyG0TWdoV/2seyvJnL1ZV0FoePOrqxNLWz8F0G+dFhWvbytW0hwwxpDf4KBF8VKlvZL895651JC7KzUZ2Fj1pdcPj5abF8DPLp5w0cp4/yBGH0Fc8AQXQpq45/bkP/nfycwoYymz7HRv8ht4ho8XicD+06CZ0M64siSi6HxQq8u3+AbCFMOPaA+D/Rz3X2ecP4pW2qoOBzK3BJ0RYfVptMAA2X1KLUAgQdi0m9VzLNK2Ktd+ejKR8VX7XcFupw0gD9mblWRQXr7coxAM/O2DWp9DNdMEiBqeQUMiK84oCyWhrWXWIs/JsHk4S3UbAcRUADUa8K9lvOTl2URnpPjbKAJcDudQMlB5w3UEkm8d8ik71omsif37VXCGhOAesWShTFG0myof8GSwZ3y221BYEgdXQXXRVaGNH+evFtkbOGjLMB/mWMIq+xXNuj1WX63nvZTW5ZijhOMh+2zV8EV5ya58Z+yvCbB/Mw0CA/ReUlmhvnNLIYxwNoOqUPiGcCu+5xpuJmoLZZqkxWlBv2TQtHiiWK0Nz1J4K6qrroeK07t3z73iF3Vjb1DnTSalq+MBOaSKYYFJ2hGyTCcWeNje6Cfaf5nPPnEb+hNBHIE93P+pFsDXQAmIo5TX36yplUXGzwioLdcAf5glFRhYm9GRC6fk0S1hA2j/dQtaj8Ta4N83eCM2Rq0BVVSl7w+Zzu+an9gN+hYqpmqVJE9VEbrOEdJZNVdoiUDkJzlPmwUvPm/bKUwbyPwXBfldzbjaN3w7LD3KwS13W7UVJCt4GSc57Dgh+ghmVL0ymnKLT1XqsbPAgW
 TFKpEsPm
 WoCEdNY33fY5Ag5c0hTfS+JiCMkyQAPWPDYZduuhIudHn322ob4MC4dxIdRcAkDe5JtnV0oK0k9WulPFuP9tk2RbthLbuIAA8eJHh6Sxy1gVoTM8+Uwnr/FCc65Vw5wkyqz7umYE4S2kcDRUol583KfN32qe3E2I2XZGqxelPnlcAyOEgTYP67qoXfUpPIox/MOaVrDGamRiFJuVKZnISCXzU4RXLS2QHiXUFK2/jbEkAhmAw/h3SnmLtgAra5LHXRdO6uXil6mwUPFF8KScoszJPUd02I+eKnBL8CVixop7W8iv2OMTIy07I1TQXmu14bUkmw4qePtYejX81S/A734PBau7dK3nyNqisPawoSXu1F/IRDxwTxF3YnvIe3xXPpYs9rVCw+FhIvWd4RvBo+N4kbGM8tkR/jikNPXUEh5fK81LZ0QLzS0ZvnYC4wAtjJtQeQrg4m3ND3PErBNHPua7sjpNn+9J7au5Kot22MN142GtIHnlhnVnltg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:19=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Mar 16, 2026 at 6:48=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > There are presently redundant checks on the per-CPU acomp_ctx and it's
> > "req" member in zswap_cpu_comp_dead(): redundant because they are
> > inconsistent with zswap_pool_create() handling of failure in allocating
> > the acomp_ctx, and with the expected NULL return value from the
> > acomp_request_alloc() API when it fails to allocate an acomp_req.
> >
> > Fix these by converting to them to be NULL checks.
> >
> > Add comments in zswap_cpu_comp_prepare() clarifying the expected return
> > values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Thanks Yosry!

