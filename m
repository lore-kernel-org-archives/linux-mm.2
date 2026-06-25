Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC266CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7176B0093; Thu, 25 Jun 2026 04:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DB46B0095; Thu, 25 Jun 2026 04:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBA86B0096; Thu, 25 Jun 2026 04:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D72A6B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:59:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F66514063B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:59:24 +0000 (UTC)
X-FDA: 84917836248.09.D8B7EA0
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9625040002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:59:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rIWImfn1;
	spf=pass (imf17.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782377962;
	b=xElibgOzvqChg4ccvsKfh4jfjhXD5L77OkHhUcHpxG3/MRdEQW9jDmHm8sOklKZ4nNOEjT
	OdkVJFRh9D9UNn6qe1xXFLehEvl4YoKRpT/UpJlDT5blMNrEIDzTjD8XcM0OaB2sUqsNQX
	CG9zoJhXjmY7KV65goK6Fe7dOcvFAdw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayDPNFOFXpj+MdeVK53rLbaYH55hRDE9sJZFXFRNc5g=;
	b=6ifFEJJzr7T7WiL0/9qZE6CuUrp3xjZr+8U1hwfqPU8b9drZfZHMXbSHvLnYSt/RR/U27d
	xUY9boXZ8JGhlKSwBgIyTh87WFf7LgXooDzQEsIjKQQnwuqymioGZpthjzZbTfxhBDQpYq
	49JAC1hQG0m3mTK0U4iAUGw4Sy4niEo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rIWImfn1;
	spf=pass (imf17.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-80a8c249e2dso3048527b3.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377961; cv=none;
        d=google.com; s=arc-20260327;
        b=a+zj6jFdAHY4mrQYA5SA0/I/JyA+2vOFHU43DmAdnlZLusnL8woyuKjnVqgvds5l2R
         5bAVeKA0XYeFZHS/PDb4+roxvwEY+Z0XGLtzlqNc3wDcWXSLzJlCCzI9Tu9c3NgNIQRU
         bLdM/R/Vkg2w7sWmp9qhN2W//HyHAUHi38bYRpnO8KC6RiUQh6BO6B0QFkYciXxv+HO/
         L9N9vM8DemVaQGb3aU0v+176AUlUJKgJ1mOOR1MTBP0m8ibFO4w6SdRapGmKjzF6TMxX
         xwyjGNxvubeeVydrlITb+GjZ9tHfT8cE8Kks1rO5WuouD0kpn95sYKJ9fNppkczD7In9
         lrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=ayDPNFOFXpj+MdeVK53rLbaYH55hRDE9sJZFXFRNc5g=;
        fh=lU8voJ3Cr46ei+nRu6xDNfnlGZ7rEcu+dkMmiFY+QOc=;
        b=G/A3u+Zb5YCxZk7GOlLl+eMd14eknewQ9IU51hFW370Ox/owyYoseE0oEcPm7C91nw
         UGi/gk4zKGsG/tzyMt32RhhHQEEEUlsYHuIOzERshRIJ/OXOnUWkLT3EvLOapKOW1IWB
         6DSMoXNON2kUNcI+c5VIDd2xIIV9ZPXwyVh0f2rg3ILe0bCCSM+E1tptVZ5AVG0ccRTu
         GAKA3ZUpSytSDtEEpHQv1j9P/YDrbhRaEmM255OOkJ4wzaodqZsKcQi1JoKeoam/MQQE
         tZRlj1+a9ulVcnE6Q+2g/eUR25SG44DPngc2B70x/QTh+YDdWbi55DPJ88wXst3rjRxp
         /GHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377961; x=1782982761; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ayDPNFOFXpj+MdeVK53rLbaYH55hRDE9sJZFXFRNc5g=;
        b=rIWImfn1tGX5m66I4jXEW5dRgw0xawpKWonNkwCgx4Kwxsgncu8xr75zbXOR7TBV5S
         5SANbOe1Su/2WiZbO11l9hbzDntqTQfCdrutFjRk97VwksfJMdrYqWPQGdpy9KlcxOCb
         o2tmEZyaGBjE41Q0sJjBR+tw//CqQVpV6Juj0zCm3wf8kikUl3k7jyTWfF3Sh2RzVFAm
         F4cSNurZzG6IuiowmpOcbthUjn94O32BFtSCmBT8YrJdVUVYTR+9SP0EVw396coWWJNT
         KjuOhWo+Fpv3L2MbF+dykLwXllURCs6SfhKF2WrIl6YR1t5APG3Yqw/SycuYL0zjkJR2
         yLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377961; x=1782982761;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayDPNFOFXpj+MdeVK53rLbaYH55hRDE9sJZFXFRNc5g=;
        b=S53fLu6NGze6xFWGGCBNeehwLyhvsUsBf7K4SAHVXz3eBnpj0z767H6Wv3Gt8x0v8Z
         HX8rvt9Ky821yxTAWun2CiGUgISgrHVTaNUSHzDQ+TAQ39hvD+sH1tpC/L3ZznZh47oE
         TmYRQtnUyXisGtRQpPZ7sIJEos1wDk6XjUZF6mmin7ae3rxYjxlpODJ/7U5I89WgOqEo
         EABAu4dUoqx5hNVuGo41rTwhRd51X+xcohi78QnxosHZBHcJGQ+AjZcrAUxkFt+qdM1h
         cpc7XK9smoNmHlPXfW2s+/+rjesaIEhterf0o2jpl4QJjPhR1JiL0ir8lqF3OdrT+eDS
         BYAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr7xIxz80wNY2f1X2eRK/Xc0B80DbSKd+Qc6kUfXSVdCdVN5+OF6EHc+kaqiidsaRQgYar+0Z9XxA==@kvack.org
X-Gm-Message-State: AOJu0Yy9XaVcOR/uNSH94kuVizLCKT4Yw2bgse/Pr0jzOtLq0BuVShuR
	PPYx/931z6Rmqm32aHvceoPxKvbbhU8R3plqLhVA4LBxD5lTdBECfocbUHZ9iVinzRxpp30r7n5
	OmnSiIAhj/Bwj5IbCOsnDPodL/+gvTF0=
X-Gm-Gg: AfdE7clDJAZIfMKbSip6RPo9kJetW0GAQ54bTSJyTsGhofY9bnFrywVI86E1uJSaFlp
	g1EyLS6pFqZ7FnDtS8nbQPIOWBDjrILogJOSsMD1Gr1brOLUUNJD+qrkyjCZrtJJGEIqdaEfqQw
	CVFl0tvCVjI02Edzi63vQhkLH04fwlIkbuBQPamQPYTa7nsNr0+HoUHMPi7ni3t2JZqaIgyZgYh
	Al5wKVgSDd0ez9Pvq7M4jRa2jXTvwNvK+h3hSyBTv+xl4/iWDgwUvXtOcKth+aj3d24OpOacA==
X-Received: by 2002:a05:690c:2704:b0:7ff:1d08:f0c with SMTP id
 00721157ae682-80a69ca0a0dmr15520557b3.8.1782377961489; Thu, 25 Jun 2026
 01:59:21 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 25 Jun 2026 01:59:20 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 25 Jun 2026 01:59:20 -0700
In-Reply-To: <20260625002752.96325-1-sj@kernel.org>
References: <20260625002752.96325-1-sj@kernel.org>
MIME-Version: 1.0
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Date: Thu, 25 Jun 2026 01:59:20 -0700
X-Gm-Features: AVVi8CeZVxZNreEFB2OgBmQNU7k2b8APFm4PSSOX7AkzrTqdOzpyInmyouNwIQs
Message-ID: <CAMuQ4bVEuQY1T=i2pFQCa4CwJHRVn7_PDTofB4nPMHdSU=KkFA@mail.gmail.com>
Subject: Re: [PATCH] tools/writeback: parse help before importing drgn
To: SeongJae Park <sj@kernel.org>
Cc: willy@infradead.org, jack@suse.cz, shikemeng@huaweicloud.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sfbk114bwrfpaq4ps57accw5tm31wf68
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9625040002
X-HE-Tag: 1782377962-731719
X-HE-Meta: U2FsdGVkX1/I/es3G0b+wEBpCbHSJHwmLw1sNglwa1X/vfQS3Am4R5clM1qajgkqkuS8B7Ztaa8gwdfjULLmViIq1BB5OzilRTmH6t9KppPkhjVopPB7IR5XR/vUmxeRmnkpwixeEsmTQ148ZooPkrzXINk2YRs/L4Nk24JrYvw7OVqgif5//Ak3l2lSRQd3c1/N2zx3VE9x7OauGZd+jnuVTBFPPu3WJXIgw5QqN9RWC/mHKpdLTdIMQPNrdzgVrznwoUFq8HRvCAw6RZiJJAJTiL+8qutkPzOyaZL4GQpzMJa48mKcTz3Nl4U41tWEyChTBrNo6g2tW78f9pvf+PV2FqVuoyTa6SpDxERNe/LAFqpwfBfkDWsz7GXSxVTTY75M8qL8AAbBdGdpneIb4wXWJNCZrNXTXxIp3ay3WaOfkBPE/rxu3bTygMkb6hdf0uHpwOb//AF6nlSvZ+RYe9jAcvrrn+mzkvVriuIf+S07k7lMDK7f5wsUBd1mfXpZ/WIoq8g3xJ3eRatyuWiXOzl3H+PpjDgAM8i9NqO5X5Y0POQUg446XUilrVSEL/TidjZXf6Pou2Nk4i0b28EQ1ThGPrsXUjLZWxeWAQjvL7U2qJnLcxK2RtG8S4xeLnSr5xaufOGTnQYOoaGE9yRHtMdQB6L56BEWpkYAnmJ5lIHymwzZhMvUsw+IcL323HCvKwZVjBIhu0T8vC8OgQiVHDPd9PoETnUB7nCXuh02vPZDRrQ9QvIBGNFEe7B5ID0aa+vlHkGMRXeul1oIOzDgdwJfymKH3WJTSTnOM/N6SWUP94cIpmMQf0pL9tXgBUBbUAL8N7ApwdHuYzodah2CDCUYzSg7qZiqfmE89dp6pHngC0OY55KR3TFfilU+ialRpoRnJTwWaXk2uDb5w4PorLY9nc/uBIQdbNVE4AykiZWadv4vRZjP3Asr6+wRZ7cuyvOqEBNJmwmmfbT57D9
 0E7M8q0e
 6XROjBst5+lSXKR+C2jdc3byDKlzKbPYkbsb+f5oyTUJd/N+JLR+ORmPf76QanOMA/xrkSSzk8CJQKm2jsuWyMgYqvjAuR61YABZhES1TXqrFMN4EH82X2If2FVZK1D1Lh27KGWi30XfypMxhjs+4rV1lg3dU+2jhbAMEKEQOnHw8hBiZT0HfuvacvZSLYNHQkjOM87qcfOndn0Z73KO8yMKWTedyd1vFWBurOIxi1UR/uSyBK3Oyac4VByhLGiK21xxw4eomjXKeHlIuk3lKDXdHfnWbqa4sVaYFxBW9O1SkJr+krtekBtaMg5dZXyHPYInSa2nEJvRlxVBaIiXk+mqxSQQPdl4DRv+Dg0AgujIUqMROXbbdKSWpkiUJ9NnhNFR36M6KQ1tH6ugvvvMvnibJDd2Ri+UTAbbBul2aN4B/0lxkXG9c5N1I8dnryE79AFMVAlh4PXVvQ7DlFaKLi2hEhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

You're right; the normal invocation path is through the drgn launcher,
so the no-drgn case I described is too narrow to justify the patch as
written.

Please drop this patch.

Thanks,
Yousef


On Wed, 24 Jun 2026 17:27:52 -0700, SeongJae Park <sj@kernel.org> wrote:
> On Wed, 24 Jun 2026 14:35:14 +0200 Yousef Alhouseen <alhouseenyousef@gmail.com> wrote:
>
> > wb_monitor.py imports drgn before argparse can handle "-h". That makes
> > help fail on systems where drgn is not installed, even though the script
> > does not need drgn to print usage text.
>
> But... How do you execute the drgn script on systems not having drgn? I tried
> to mimic the situation and reproduce the issue you are saying about, but what I
> get is like below:
>
> $ sudo mv /usr/bin/drgn /usr/bin/drgn.bak
> $ drgn tools/writeback/wb_monitor.py
> -bash: /usr/bin/drgn: No such file or directory
> $ python tools/writeback/wb_monitor.py
> Traceback (most recent call last):
> File "/home/lkhack/linux/tools/writeback/wb_monitor.py", line 44, in <module>
> bdi_list = prog['bdi_list']
> ^^^^
> NameError: name 'prog' is not defined
>
> Thanks,
> SJ
>
> [...]

