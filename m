Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080BECDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC866B00B9; Thu, 25 Jun 2026 16:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D8E6B00BA; Thu, 25 Jun 2026 16:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DA76B00BB; Thu, 25 Jun 2026 16:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4CC6B00B9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:54:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD75F402CA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:54:35 +0000 (UTC)
X-FDA: 84919638510.29.9FCFA98
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id D7C3280008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:54:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d3MAc0nw;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782420873;
	b=jV/HjfEmEax4r7uDIoqCoTbEmu+pY88xoT6I0gDXn/PpsLpm9CwGxczkXV0j2j4PLAhXlq
	EEzA/F/JSMRVz6pvY6FltepcwZqkaHzELeg2w4D54A66UuRluGYZi1Wh0fXieuwcORhGAF
	xnnlx5S65gzPNp+XPAjUoA170fX/FlY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782420873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kivhVnPZ6lJoS6jUUi/vo4yujgjjrudAeAkrAqxP6ro=;
	b=2GnijWaarvmkw0jJSCdyVcQIP25nQAH4hNckrsJJFZ/GYJqniv+04nOkMyU7nMqCwMzT6D
	c62YpOTxWAESELrycdDt/wnkbibeNVhAOB1fR22K3AUvKfrwM3PztetdbqX2QD1+n13ACi
	TI16wN8p0gMsuAIo47iKx/8lm4IGIIY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d3MAc0nw;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-9225cc6fbb8so29478885a.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:54:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782420873; cv=none;
        d=google.com; s=arc-20260327;
        b=O7QJWs2PvXkDc0CoyifeNI9bmyNOJpUknohKRC19eyeyCCRWnmR++QZiXIjTMHWuHh
         r9hZTFRc8O/RrngbjUFeAA47Bpq0DXttHk1b5sRuRwCq9jX1AxktQQIURHDbEchr7IHy
         yx0wyOjaby+CkB8YYXbabDsj6fGRLsF5NlVsC4DcuxmWdVe1MECzqc8fotSIzzkySv7z
         asxh5CnfoRUqFNqS0StKGVJTlU38ydVVZlmkEd6OThfkcm+qTynysAfTIGdnQm1Ue02q
         yaurrDtChmEIYv8KtTTrdP+AqXgArbPR7r8Dn+KH+0QMK8FOg9D3+VzyNx8BhAqC9Lhy
         BXVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kivhVnPZ6lJoS6jUUi/vo4yujgjjrudAeAkrAqxP6ro=;
        fh=RrHIEKhKb9tZzLiF5WUdAxWmfD40NhwRznQyPrphLJg=;
        b=fjFI1BnH5kaROWf6cHKeOEc3zfq8cLdZLXTxfm+lwxS4JNpnlmT4X2sw/i9UrdeFwd
         M63UUsDexIevLpvvikjGUiZt+/E5cNPBi01butarSHyM9NO+CGyG3FtBXBTcRrXkKiJz
         9iCkg7GIVHGsw9fyQHAqC7NYPmRGAkg1zEjPmlUdlNF3i1/tb0r24HksOWsKeRaYVzA5
         CPnuU4TIflVnkYsr2aTICIighuOoXUStfIH9KuUgxUa8n/CdrcQjyd3Mup1pZx1NwyS/
         kdv8nSjYriEFcAuzkor1LACVB44jrE1eLkVEO8H80Z0vOQUUdPx5eXfxculkBQfHbvLw
         tgDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782420873; x=1783025673; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kivhVnPZ6lJoS6jUUi/vo4yujgjjrudAeAkrAqxP6ro=;
        b=d3MAc0nwPAwuy21PzH9kwvXjQ+rPDPE+gd8D4Z4N1fPw7wCPfOLxr2kCI8vSW/TMxx
         pFdD5PiaxCGNv3W0R3tVhtLXmlL3/9kOCYK05LdJ6m8C2Gj0/X/Z7bGcJHhTBe42ZMib
         N/EZ6zFqvyCuHXGpVWoh/oIfotaqDQSFiVlYDA3y6aoC9tlrcGCj0V2OGiOrlqmi3+J6
         Fu4e1bg9tGbDW8Hx90OM4gJuUNbcOHN9Mync6ipAzRHNejc7XA8/RLRniYEt+mtX3KVZ
         Ei9efIK5iw2MMhhGMgJd2zRsOuiDvKu+p8aP0dz+RyZHhlRw3KVQCOESEFsQWtPbkUE7
         nQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782420873; x=1783025673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kivhVnPZ6lJoS6jUUi/vo4yujgjjrudAeAkrAqxP6ro=;
        b=mkYXN7xOWqt8eHg2KWGFIR/rkIMiJ5DbmXanEdT5Djn6YQJr1q22bed2FlzfJCE1P1
         NCpWWyiLprx7yg+ShCK6ICjwaCSuCrPGrS57INuKaCWcnCdRf6SI9xW7M8FDvc2PmZh6
         gVOmc+zTYO44p9qfkgjDZa2jIMtzzEbsFHxNhtmqo2FztFaoy4q3e96mxWGNb1qAK0AS
         67Tfvp4GwJ43I6526fGtu075/DzcGk570itWaiPMc31gAEK/YTJPh63T30RRH06IAKdM
         j6cGcAgscfb8JRD+4wbwBeDodjDToOHiBn3swjrJKtaeJlFFk5wQjwVgIji7dLJNIhIY
         hIsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8hbIo6gjqopf4kwK+Ls67picPXrB9YXS6QNcRufimhBVw8UNeMfWWrYQJIN/yV36QZiCmc4a9vSA==@kvack.org
X-Gm-Message-State: AOJu0Ywr4r84rVfUOsL2nmWMcjQA2fimnvMxTdTBO10UFjX69qjZ397o
	PrDvW7GVi/UgRXf5rNlOkvKJMGV8j32hCZ6kOAljnzrCmlUqsgJ2b8Oee6oKiG/ej/tDN9a018R
	3OiPkQgpfMuvN/sZNXk4/JSME5H5S3Cc=
X-Gm-Gg: AfdE7cn2c6th4MKeeyG9nm0pb4JYn49IAEw56vSktmDVaNeqQeJ4QD/4uyVskZBekOL
	aEvT1Wo254S4AVC563cjoTd1reFarO71WCD5QukK/ClO5k29P10sS9JiK8Kc/WGxs1LHq1Au0CJ
	N4QV12wBd/EYirNNoZvlhAsQ1u8MeYVgh51KhTEJKtKr2fE8VExMUwG2FaQUNPc4K9Eix3FmGAg
	/N4kbpZQqZuaA9WUG+ajsivNEXWTYdfzZZFyQzdvQ/DIZmFny1rEHJNtVRKcglrIHrOKE63N1dF
	s6uNwXiCeKEltOtV+vcJrUld9qKwyERE8yHOkA==
X-Received: by 2002:a05:620a:6488:b0:915:8c48:497c with SMTP id
 af79cd13be357-9293d1b2aaemr645972085a.28.1782420872492; Thu, 25 Jun 2026
 13:54:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260622192114.1147198-1-willy@infradead.org> <20260624065818.49975-1-21cnbao@gmail.com>
 <aj1GnMERF_j54sFA@casper.infradead.org>
In-Reply-To: <aj1GnMERF_j54sFA@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Jun 2026 04:54:20 +0800
X-Gm-Features: AVVi8CdriE_v47589Jc9sDFoCpF5Kol7NPi_O35NSMSCh5QSUWtro8gax0Opfeo
Message-ID: <CAGsJ_4ytP7HBN25oEvPEFx_E9+uK7UZzsiEpFw-_t-s+VGJx4w@mail.gmail.com>
Subject: Re: [RFC PATCH] filemap: Remove file pinning during fault handling
To: Matthew Wilcox <willy@infradead.org>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a33jsmhmaz1x5jrgaac5gy7egh6qn7et
X-Rspamd-Queue-Id: D7C3280008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782420873-390243
X-HE-Meta: U2FsdGVkX182Ofz4B4ISgfTJchwYogBW2vKaw4lCcJ9wTkE1nJ2O1l+7HrAm8/xB17MuHdEDyV3nHeoYaQlofF+Pz6dGtfiuzKlPzUzkbT9B2HArMuePQkTT2+vc7niroTowtTZhITCmOM0Ako0LfXw6fuGPzcv1xTsp3D8Ma1NFvF3ndLN/7dymh+myhKSWMbx7sriffqEUjMtCXHKyIXBLnd2HIoTm1CiEH4BUy8Gb9YO4hI2ZsIN8PqAl6njQ4vS2bJog7BnAlPAz0HO/Dk+JuP9SsRwayWslPJlUslWNb5Am/sobeecTEYFy+8Y1Y2IVssvebVUncRpwHjphKvNm8sjElBacpZuYZFI6GUUW37sHxuxeksXFFojWx8g7mPi8RJVCRd1Ja3DSFrwr9Ho3K2+vCO7USw4C4FafK9kUqB522ddEgjvP7LX3/ykKp8fRlMmWtbns0w8kAhw3/H0bxwpPQz7stJnMMv0a2ss5wHRmGoYYgOzvonIhzp/nOZJbAoXqC7R70wnW0hbtgGSYfZj3ylzQ6juErvpvYPbyzJixJMYNOcbo87olGOynqSFNSJ/rKjX5XgcfI61HOd4uzYcQfBPyOdl53TqXWMtvnoi+ggPin4IDa7ybUyENY3mtkkfTdrl6ZKuYj4kc9mZirT/ugOfgi7ky4z/GKZ1hscuNVsq/jQNRkLPBP6Brnm0mIZ1Vupt+79QzzWulDygOkuulALJIr1sBUKzKIGD0GQyAzbxmuPxRRqp+m00TmpfecR1hBsX/ul1CC6ML5u33tWh0FdAhkzeuS8v50LiEk7KQD33CBuvbyKSOgRNiih4B+iTc8sts4WwvAsZWKgueHibaxE572y/bXgtqdFho4zYa7qk07R07T/TjdJdoU9U6mfGKTTq3I+oqmPZYFYsfLaP/8j40RS1ri144Q1ssR+AeGAfeoIe4BPVXOmVWTxqNNkNLS4UZm1m4Qmo
 xA+1g4wr
 ++/lR5pL8HIrwvlAPUANYjBZZdftDa23yZ4qLtml5dKveaoQWjsTjkguuuiTpqZcBehNEDnznI4mAqGxZWroKPPSqVDy4W5L8bRQm96ARwJqPmbfHOY/IfkTUPeCWX01jgvC1Tfjk+HkxmYUh0L04hstqtmQgU+di5xV84CFfetAsKg7DeuOn8pc4ASKCN38lu5GCJPU1qlVbkmsHO2ZW/JXN/N1Qmo5SYeQY7Kt7IhpDIFN7wrqL60FZIASXoDU5LlLmt0HlpRj1c72Z2KGtyz98IP5yhE/RhDVRHUouvbgHeNTuDwcEhEp5GHk4f40DWwsHYhSsknbQor2bMfeZF4nsFF2tjHrD9Gqz4gCmnxF+MzaOrxeCUPw6J/bxcjweiQlOWN1LjraimDKAEh9bbgYZqvC7HsAta1uDlImk6VLHrf+zGItaLfrB80Hj7HfW3srHW90SLZIQBw+I5ehTCMYuHW0UT6bnqvzKHrGMqS018J8c5Gx6DTo6n62MzUhIHgz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:17=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Wed, Jun 24, 2026 at 02:58:18PM +0800, Barry Song wrote:
> > > Now that faults are protected by a per-VMA lock instead of a process-=
wide
> > > mmap lock, it is far less important to avoid holding the fault lock w=
hile
> >
> > We could have fallen back to the mmap_lock from the very beginning in
> > do_page_fault(). And for GUP fault-in, we have always used the
> > mmap_lock so far.
>
> Your own data showed that this wasn't the point of contention on the
> mmap_sem, that it was the fallbacks that was causing the mmap_lock to be
> contended.

Right, if the first PF holds the VMA lock, we don't want a retrying
PF to fall back to taking mmap_lock.

However, with your approach, the first PF may now perform I/O while
holding mmap_lock. Previously, at least, we didn't perform I/O under
mmap_lock.

>
> > > This should result in improved lock contention, although it is possib=
le
> > > that some workloads will find themselves contending on the VMA locks
> > > due to them being held for longer.
> >
> > Hongru reported that 82 of the top 200 Android applications in the
> > China market call fork() in heavily multi-threaded processes[1]. It
> > would be good to take existing applications into account, please.
>
> No.  Collect numbers that show it's a problem.  I'm not interested in
> theoretical problems.

The earlier report already included a clear call stack showing the
problem[1], yet it keeps being ignored.

I don't think I'm able to convince you anymore, so I'm giving up.

There have been many occasions where you've used very harsh words
toward me, and I never once asked for an apology. Yet the one time I
praised your contribution, you asked me for an apology.

Honestly, I'm tired of this situation. I don't see much fairness
here, nor much kindness.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xC5LdhuoWV1=3DtK-RZ5rkjc8aOKOkm=
b1L_8BG_3gtJhDg@mail.gmail.com/

Best Regards
Barry

