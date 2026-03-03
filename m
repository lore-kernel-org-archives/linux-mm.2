Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DD5EDA687
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E6C6B0089; Tue,  3 Mar 2026 10:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15EC6B008A; Tue,  3 Mar 2026 10:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935F66B0092; Tue,  3 Mar 2026 10:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 836CE6B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:23:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3343214024A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:23:41 +0000 (UTC)
X-FDA: 84505121442.08.75D9C2E
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 400051C0008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:23:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BmXwiHNO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIHHMa2z4DUfmfcEzutr+tGhOCrJS86irFkaV0WK1+Q=;
	b=AfqpCzjnXrMuSg+wXlLQIHZ+VvylWPSivfkUyvkO7nUMPMQHnoXxdLVy5mwqATpfiCc45c
	z3/YtZ88pCFh2/zLS1nvtt+TbhO5oUOPyCCv6YswCyCMIq6VBd9jqS9ow1qGBq1FCY6FmY
	QepYS5SMKn0D4T01XZEVrVVXpQPTJec=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772551419; a=rsa-sha256;
	cv=pass;
	b=lFKzTM+YeU0rcejOsLdxA9xbwBIoFF0eHMiOpKGkx3Yu274vU4AyftVi4nyJ/OrCcP0vUZ
	3onzL34+92WDcugXCma3BxvENZpG0yA0bovv2p5KL2QcmnGmr0/MHlOS3fSPJUAQ5EwPC/
	Iuq2ERLzV1CsVGiGeBMKf9glNOPhdYQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BmXwiHNO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-126ea4b77adso7393970c88.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 07:23:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772551418; cv=none;
        d=google.com; s=arc-20240605;
        b=iJrEGUGmAqzPY6sEJCWv0cpHnyXK8eNdPXBDj4S2Z/s9zyWvbiLAPuDJoKHkDnqrrH
         0t3w3YjRfw8ivgIUTVfTrGjMqAkQGfxXGuCMIil5tlG67lbX6H7TOXTVvZGyjgOt4gCO
         +pVVDY4JIR0sA+XqB3Cz9wp5wtEHtrv2bT7DJy95Z+wVga7QobL1ZQO9lfaQx1sjVme5
         4mDaN81r173SVQ6Ox849PB3Z1tiJfH3kuECBwcizIl0xY2CuWytNBLVSdT3MHB4w+K3P
         hg3D7Dezu0Up+IG4/tUrlgwwMOT/4NHlsVXHFHkfld9rtA2C/UTcGTwHNBj6JrP91sCS
         hd/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PIHHMa2z4DUfmfcEzutr+tGhOCrJS86irFkaV0WK1+Q=;
        fh=RQeU0BgqbRBCETZYP0LxCEJsvxPYGoV7g+VMLuAigSc=;
        b=aUCL3Oy2RcOVN7gHdULnQxFL5Ptp2lukJewrjRqAgfo+IyqMpL2pVypGcqTm1vy9Gb
         xveLc9cPtz9Z+FFo0V619e1ifx89zpPF2v7zvaJmXSdr86GbFXr2eK1Q2OcDGtsJuy6w
         qkbe9h8dblyBvTvDylHnxcolexXek3bJXTYbYS8vKLqzEsF9jywsiuu6YBrFABHH83Cz
         v9R5HTRs59vjoZo3o40QKH1RwFVTyJ21a0wLXMQ65gh0shExnYyZeHYudMFhKIOiCXti
         /r0OWqu62hW7oK87jDhqCBoLWdPywiAzYr+As5GxtVUy4ly7i5AlNHKsbidl10H6Dipq
         EF+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772551418; x=1773156218; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PIHHMa2z4DUfmfcEzutr+tGhOCrJS86irFkaV0WK1+Q=;
        b=BmXwiHNO6spf8PCCY/ANY3fiIEtR9NHcDnPcBTXqudb2DHh9Ze+/WKX8V+jPjUXoHd
         S7hsMdhrc9g4tKrHEhnhgX3oPqrgq5lYAJ29I23VnWOkBh/j35vZUtS7gl4sRzmS22Aw
         xjOV3NXMme0UpJPgZn7p0Dz5Bzdmhukn5mis5z/KlETNt3phRdegx50fERdIgiMZC4H+
         Bu4opOsLEezviXPtSc7Ly+d5eWP+zi6XGjyTsSQzC8lX3T69cX66hLAioYXuXgFB9EnL
         ZNasroeYKPpSzbzaIYBeRfkne6dxgJNc+TJMyaZklJSm4OQ5txGKSba4kZ3eAGHvg1xB
         a3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772551418; x=1773156218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIHHMa2z4DUfmfcEzutr+tGhOCrJS86irFkaV0WK1+Q=;
        b=PUkoxHEZl31ZY5AoPmVNCsw0IAR2TP4qwM0LTej0M5g/o12qRMCDqJeU5R5USo4fXY
         twgzCSvVJDVM9CCuXbboSJIaQOfX6I9IlF4kk9a+6HtAt1GmZ988TXK1tzTlvh3JHxEF
         EftlDsRBJpGAIf++yAr/EuV7oE42Od2NSbZVD0QgnyKQeeOTXKGda8ndpeh5TVvNK1U0
         4pDVSomRYe3DxhAZ1iXEoEoEf5W4KxzNFfgoFMMzZuU+GDtAcOq67SNpwt4qzJNldyS/
         Q1yXrXBitCojrqtel7JWxg/d54hqrPduJcQ1pj/jO7mDAEaUpLFGChWBSVbRwDeosoMH
         f1sw==
X-Forwarded-Encrypted: i=1; AJvYcCVxYAsEya6cf5dqXB/X1NwZZDZudG93wdzN8mJrPqecftbpHq5gJO+Qjg9Q/jvH+VdeklFIWJbm5Q==@kvack.org
X-Gm-Message-State: AOJu0YwVLSMf+xFMUA8xsQZUK/4IfCLwXc1DrDipiJ22RNlaefU0aL5V
	P+m0fnHK1JWZF08wbsgaKT5/A7qA8NRJ3NzkpqHG6FYY+dhG+9BlSMSm5/bx0ng9cyPBdTjc3zf
	5PQgAe1Kur4HMS/ziKGlAdCoVHdyOUfFGnGAp/448+joxcltGxW0PZs63
X-Gm-Gg: ATEYQzyrlRTvDlnlMHcuc/IwlM9Jyrg9NJXWsbzkaIP5Dvbp1z6x0F9gIjrl5TLd1PR
	cLOXGO44BsTYku7yCoZAWk9dKDREmfcJTyFf3/kwgyroX6BZ3JMJJkFgW3e60wESUDDuNLGKMb8
	Hz3OjNIto/uFQQgfwfeSZq3USeKxlzw+rbjIxJxo0hT8b1obx3ukLrgNJzT/V8mkScOSMzETJhY
	DsbJHvG84slSv8IK16ZhWsroBNzjK6lWycBoGTWI8433J7IXWCmKkiPEM/1XDhC4JYlF6XvdJ1V
	BM6OLtneB1rpguUz9yH4q5+DYwoVhaeimT4eR2A=
X-Received: by 2002:a05:7022:4581:b0:127:867f:2449 with SMTP id
 a92af1059eb24-1278fb68797mr5039051c88.1.1772551417377; Tue, 03 Mar 2026
 07:23:37 -0800 (PST)
MIME-Version: 1.0
References: <20260225203639.3159463-1-elver@google.com> <CAG_fn=WAwHUpoay2kY6rkEZQGYxoDGVJYf5B59Y80ht7++Lmqw@mail.gmail.com>
In-Reply-To: <CAG_fn=WAwHUpoay2kY6rkEZQGYxoDGVJYf5B59Y80ht7++Lmqw@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 3 Mar 2026 16:22:59 +0100
X-Gm-Features: AaiRm52TnSdEwOc95PvpVa-fbDTzQ1yxTDERFj9HFe2UexnD_a7PDTE86NyKr14
Message-ID: <CANpmjNNfz9TQcnZWkTXEAzVNdUAAYfBv0-FB-e7oV5PCfsYR5Q@mail.gmail.com>
Subject: Re: [PATCH] kfence: add kfence.fault parameter
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-mm@kvack.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 400051C0008
X-Stat-Signature: zap7mdhp9we17iudtgsw8ri7sjy5zmd8
X-Rspam-User: 
X-HE-Tag: 1772551419-316175
X-HE-Meta: U2FsdGVkX1+OUtZrDNnthdEfjovsQaU9v9in5Wjp5poCGtKc+JPVYlr6kb3DztsYbBkv+ubm2uG1nab39wgPpUnaXlG1X7zaTr+qf587deG26Mfqz6val+jNFlGsJ0ouZgSW8zpah/C5v1DsXLMzPpySTP/h+6yQzXXl7Sn+6W9jL/YNmYpCz36SM4QjqxtTNFiFMglDcpOO939Zx9IdDmlkRBZqp2pn1DV77OBamA6IeCMs5ngj5kHLvVU9cGyyfNVOR6czosXxxYf753NJWagrw6QQxGRRZvgv+pTnItAR8Yti3oZkyFMJxM2HvMKRJLJ9p52qRw4A6N0TiwZqB1Gp3oSn8t/Aea45SIUX/q2vNnr2+M2A3HWpuq2XHnf6D0pN6/rtcy+iTmMWMod394J0anZqu23Bnn0Ei9ViQIl9VubH3aHDDFNSmSyQsIpNrcyI1bmAgNOndRHTo8PNCLAdIQEzZ/8JsoM7mSRLkUelRNDFgGh2j4cuyxs6NNu/pCpXuoqjKOS4J3GnsBm2Yl6141yeXbHNt6ycGdt8l+x+CE3sf2yxGQxEi3Hl0XO0RyYaGkCvOIR/lrc95i3m6KSmaHbb/fY8DCzlTtjoIUesQkO0OA9iC3UTmiiQL3ldE6Y0JXH+Kd6bfo6eSYfS59rrIEOxNLhxFnzpmrAHfhpOt4xXk+li6GHWqIiyQ34IS/NwEtLtqQ03Ng38G+kZyinhMqh5lY+9sUTaZI33IZTzVboFoWoyGpVSRqHAVCetNQecvUgnRRdFa5zxATFqBid3qdgbUJZCNscMALjYwQOKp6coAscTuZ3DVoAjeuB9WOs1fIUNIr/N+k1VAceYjzMEZXRn3B8sC0h6ahYRd6oUIIN8ndvU1aTle6oz8SMN3rla9SIp0XsERSKV5F2qKeKfjmiJQyrhaTk3OhmbVbudTj1JmSVZ6t0ugcBnNiuZYEHJDwI6GOtAidOnF9J
 5mRsDvHR
 +RGyzx8D0V9tbJ8FL4SHGJA1wKO8uwMYLQW3Jzmvk2e7LTxBAEDpf7EifYQ2XkJQTjMiitXw/kipcshksXZNK6oZCWLtnNIi3hc4RW260+mW39JUayPkaI1tA50hFm8SQJF/xDH0r+AlT0pCkCxlqEir5hOyI5+8eStgmKep+pKgycoBdGC4qI5VXTDoA5R6USHFYYxF6afI7AGOeKKrnMx3YSryFT1IaBhLO5ScreF5Nx5Pu7LMQLZDglALSSLBt0vaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 at 12:20, Alexander Potapenko <glider@google.com> wrote:
>
> > @@ -830,7 +835,8 @@ static void kfence_check_all_canary(void)
> >  static int kfence_check_canary_callback(struct notifier_block *nb,
> >                                         unsigned long reason, void *arg)
> >  {
> > -       kfence_check_all_canary();
> > +       if (READ_ONCE(kfence_enabled))
> > +               kfence_check_all_canary();
>
> By the way, should we also check for kfence_enabled when reporting errors?

Not sure, I think it might be redundant - I don't see a way we should
get to the reporting path if KFENCE is disabled. And if there
currently is a way to get there, we should check kfence_enabled before
(such as in this panic notifier now).

> > @@ -1307,12 +1314,14 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
> >         if (to_report) {
> >                 raw_spin_lock_irqsave(&to_report->lock, flags);
> >                 to_report->unprotected_page = unprotected_page;
> > -               kfence_report_error(addr, is_write, regs, to_report, error_type);
> > +               fault = kfence_report_error(addr, is_write, regs, to_report, error_type);
> >                 raw_spin_unlock_irqrestore(&to_report->lock, flags);
> >         } else {
> >                 /* This may be a UAF or OOB access, but we can't be sure. */
> > -               kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
> > +               fault = kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
> >         }
> >
> > +       kfence_handle_fault(fault);
> > +
> >         return kfence_unprotect(addr); /* Unprotect and let access proceed. */
>
> If kfence_handle_fault() oopses, kfence_unprotect() will never be
> called, is that the desired behavior?

It is - consider multiple kernel threads running into the same OOB or
UAF. We should oops them all, otherwise this change is almost no
benefit.

> >         /* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
> >         if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
> > -               return;
> > +               return KFENCE_FAULT_NONE;
>
> We explicitly don't panic here; guess it should be fine...

Yes - it's a KFENCE bug if we get here, the WARN is fine.

