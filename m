Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A496C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E5A6B0088; Fri, 10 Jul 2026 01:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F506B008A; Fri, 10 Jul 2026 01:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9926B008C; Fri, 10 Jul 2026 01:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD60F6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:43:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D1968D797
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:43:30 +0000 (UTC)
X-FDA: 84971774580.06.4FB53DF
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F1AD40004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:43:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RO8tojpw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783662207;
	b=4+N1lpkR0etwpDH4VM1Yojvt15cIYrgEuWNE0Wvwnr1dN5E7yHOeC7DUzj5hVxcvoTftBO
	eN1TKv1K8EM/A+4y3PLzMHvWK/qhOOCzM3Buxz3CQMoKMUDNdW9GaFpf0Wm5KMI8ZvHJ7Q
	t0vYWypEXV7hSdKxsjgIk9Y3Qap7sBw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RO8tojpw;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783662207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9Re/KEsDNt2sGvpo1jBpc9Dd0Ptp7s8KPI1kfDwE2A=;
	b=NJobxrlqDCt5dsc1mUPb8eXYWOHueJhhBI+ykiR5e5jqg8tvBwdov7UDXQOGQ7XRv9qcJz
	iRaR1goxoZRHyXffUQ0QBqbr8og9b1tM9IftGziFxKWma6G2v2aDz/rPpNhVJg2CfqO2jM
	v5KOulzcHnHaKW2zCEu8m7DBaUHVAXM=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b0115b9e17so500486e87.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 22:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783662206; cv=none;
        d=google.com; s=arc-20260327;
        b=Oi2WAwEPOp8hFmHLx3WXxLUy6/JBC6zWPGEWEYqXj7YNxhSlckAQ8i1yjg4lbkhdxX
         dFioLaqBbS3ONJcwpca2r20P338jqdM1eREQtPTz8qZWoPgUmrqi3onj+Kq8KMGY8f5Q
         aocDu5JQ9AaT2hPTFY0vbl6cOVdzalDDgE9dPrhUzowO1AhZGh2bEIsVJEAiqtDRADYv
         dtYihbbU9STFQyhMDzAIRfkmaYZ0X2/nvvMEv5WZH1IgIKev3rjS8sTvwDirw+QgxsoT
         JQXqUg8tEyAuVWxFRevq0H6cnxwxGhrBGuc5mopmfdTiaRKeCXYmyTJRAmKcReOiy4gI
         xJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+9Re/KEsDNt2sGvpo1jBpc9Dd0Ptp7s8KPI1kfDwE2A=;
        fh=WAuh/FfC2SrgmxYsHWuYEmLLonavj/1+UEoRAfZH8Hc=;
        b=blJJtswdA+Ha4AhXAMwwBJwDGfLGvKpv5wuh3hxwoeUZzchCFbR60P3o76SE54Xs6j
         gkwc6SHVfk6mgzBNL8MRZVNyCC59RxIr9jrfgE9iQts7Qjf9gUXqMsV9sDjv4mqrzskD
         EI/2jLFAZtTnCjZXnsgBoeG27jPs+0Dlhf+aNrmU7EZlpcuIhXu34hdqKlirBP9NaNhD
         WrT3DkJahAsLB9AQwI3PXoX4O/SbAci+y+PRlew/sjy5hXvunvXj/yDFLPx63X1BafTh
         erdjgBEFD10yXn0UOBM/oQZJIOyBBY2qjXThg28fnfwMFf80ngO1Dq4Ib6UKF3//Fvn6
         zfCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783662206; x=1784267006; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+9Re/KEsDNt2sGvpo1jBpc9Dd0Ptp7s8KPI1kfDwE2A=;
        b=RO8tojpw2Z1yt8+8BMsz0rIOby750YHYC7hpsa8SYXhDAij58otVjL7Maf6wWEae//
         zBdVDU89SCdxKDeR2A6JLYItdkHaTXqCjMSu0X+6mRcMLnjdFYe3JGBY6k762heiB/SE
         ICM2CdHSuvAZaGkvksojhzrsBR/SbaZQ8ypoN/P+UXvc2eiSvQAGDTxq5NZoOTr65Q2j
         eK29NAiLlCL7LUCN1Z7GNVcrTVrLTYGnT3WPyri6JA3HaEMPx4dR+KdrE66LcoiWQmCs
         /tVd3kyiA1533ByCtKiZpjI0G+lI3UD+/buFWd/Ngx6X7EttiudVYyLcil6+YDMyHWHG
         h3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783662206; x=1784267006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+9Re/KEsDNt2sGvpo1jBpc9Dd0Ptp7s8KPI1kfDwE2A=;
        b=sdsqjY+yBniL6Hi+k1QRtKzmV365Uj682kXthDSOOlx/SoUZGdGc++gMfVLhD9AnHL
         LdG6yv8Iu3C2WsbGvsQMorOpPpsx4jOPKLA80PguTbvoYcYOJSf6Wt5wsNuW2Vl/TZ9P
         kNDHVoMt+Gl3cFCs+xUq8R/HYWdyfPGMsejEzDq4UOMn8GnYr5712pCT6UbRhPUcuAVC
         GqOhF6X4VhnqdkQdtqlrqz6VlHP4dxEClkOiGEr0XJdvvZE3Vb7JKPlLvUTDXT1R4ZBf
         x+9Tb2NRrpx4wlT4ZVZO8r+wBs7cuwnZfbHkNmJfBNZSwlgPXbWvhRyZlB6HaF/Tu7AT
         i1YQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTRFKLcx1M1NvZcy7b2r0+d/49bEwiC696X3Du5/M41n82DNeuqqGxzBMi7JEosSYb35y4CPuqGA==@kvack.org
X-Gm-Message-State: AOJu0Yw2Qy8fvrPlhAk+xjpZ1arZmeZ/nj0d+m0OOMnMlrEQthN24XBJ
	hpJhCeqo6KYxvVm1n9MrbByN4No92+/sAP5f7RfW0cqSOXNrlnyCTQ9TFfR0ycytQOb5+wjPFCf
	waZCdGcdSAEFyNUMDFtUGyWgYaaiPYY8=
X-Gm-Gg: AfdE7cnIQAm+4pGE3lFsaduqBB5klpBBh5fqNGRcE2UzuMy2FaWl8JAsFJLZX3WIw0E
	3lqJMO5wnWAYFFl34H+tAFbp0iQ4wEm12tCcym5xt8B4LfIUNUxTpd0Rlr1idQoynCvR4+H4KI3
	OiCRtDgLmpe1AyNQMUUB5hp9n9RqGEy50nrTIABVWYutttcCEYbHH07a1nkmdLFAyBTvj0829U1
	6lc0yYSCszSKe01d1fVgHNgbRZ2wl1B6x5sSeib6keLQB2XN1iPrWrt8Go0350z6+8zbrfsuSFp
	YNbHCgg=
X-Received: by 2002:a05:6512:641c:b0:5ae:ba7a:1789 with SMTP id
 2adb3069b0e04-5b011464f5emr2122074e87.13.1783662205315; Thu, 09 Jul 2026
 22:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-3-willy@infradead.org>
 <CANFS6bYc5uSSYWvwJZ4BgjzF0_bO9rkcFNvX2vVHnzWDi3kpuw@mail.gmail.com>
 <CANFS6bZZN6455QLhPE=yYi5fAHMt+MuqumtW6BCg__pESLiLaQ@mail.gmail.com> <CAKYAXd8qPHHNrDkJ29NwR7NrOj7Ny05vRPKzjUPckC870ULeRA@mail.gmail.com>
In-Reply-To: <CAKYAXd8qPHHNrDkJ29NwR7NrOj7Ny05vRPKzjUPckC870ULeRA@mail.gmail.com>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Fri, 10 Jul 2026 14:43:13 +0900
X-Gm-Features: AUfX_mzwF_1VKVPfeVlM4SLysK1qhzKRkOCuoUWfDc1HQMXWox3yF9t2IeaLpaI
Message-ID: <CANFS6bZZjBx5GQxu+ZYVYAL5T5mG1ZRtMo9TEqEYC2FfNbdCpA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, usama.arif@linux.dev, 
	lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5F1AD40004
X-Rspam-User: 
X-Stat-Signature: uhmobhfaohrnf8kkmo7f734th18usp6p
X-Rspamd-Server: rspam03
X-HE-Tag: 1783662207-143126
X-HE-Meta: U2FsdGVkX183XPJHpx9HZxuOERoqcDh6LdWA49o2QWO67sQEdFxBRNqNaks3IyYemGSW5X7PkU29vLVFrsP/dU44waxaeJ+PdwtbU3t1plTTSnDqSKKg+H1wtWf19XDvbN24z62yv7VqiKimZ/jO6VZ7DdhP+5C0kULzh6xvF/4v4Z/pJBKGI02yEKEQm9c94FSe9fr1mcA8E7BZIhnbKTPsS0gLzztLUN0dNY+4NS3OS2SJkdhjUzRVCkn+FNaQXwl3m+cklN5WZWEYhtLcobRr9KW6B7nRgGg0ReQx3OxZjSldC+sbrSZHHCUa+ONFWE9vxryIb0glPgzQHO9QTcyXJ7KI5y/4884OMIxVJdXqlv+8KJh02Lp0ycbxWHLdpvzXyTEfK2dkp0Bd02WeFEJ/v96RcW1O8zms1hRNsVbcKHDRRYA2uepWhDWwS4NnhKL5vRFdUjpT89XMOfMbFjOUwVnLmfEfZPOVb74Rn2Ize1Xdoegknt3b7VyTgqjcGniCrX1ARkNxT5G/U8Nx/7XO0RQzwmPj04VK8cmer8k+Ig0uoDaFUsspYQq/ldOEdwGPLiW354mIioDRqe6m+eFZp8FDizrPV+1/vExgkcqA9Q5SiVIl4Apuk5WpOJLwnoAz0sAht6N9X9rjrVBw+6ZENdc/ypzjGA9aMaEPwLUt+NDchOZMne17lvAQv9vMdbHeWOrHvoZL1ITMit8S5K7rtKvfl6I+B3UHXiyQzyWGmOaWQw/SlDpNqMCRLvQC21KC/Ge8SRPYHLWiERFgYqyMGXwNPxuGZdepyW4sPdx51YeOLb9g9H2HqLFLQQ9Pvo94JcL0ydl852mQendffpymebZu149zsgUb7i5Xthuc4b6oc6XX5snkpNIzTkE59qU3r9Bo8vrSnyYbs4vjMtRupnNqkKN5x4h7DE8Il/sweAQelILaBcYRy+pWQb6W3uLratPSSeM7AqvtH/K
 5N0qs4wE
 3bJbHE6NOcMKeKCBhb2TDLDcLDy2tJKD3x/VNuRV0OuFjBkHfbG6zURL17NYPTHNmp9jmPBiNOJh82CHquLUYpnukenkelBdJCb8/dHh3Ua9+6tUgTCqm7VIkkEgHuurvN4raCCAXr9/uFwvTrzhQ+hPcEkCmczr8kRju4fiagmh4J8JVYSj1wvDDkEXH21igZjHhfVyF/PSrOKHY/LWyT+CCJspQE1GuCPfunW1dXnOttoPlxDrmaZdD/LKBCTFjeeAWE8WDJM2o5TGOqC7R5Yp/vDyIYyDDotNh7eSvNxA2RAjVw7ax+oVc/3vmHkActklh6BnzOH/NeRKMGKB4kJdfp7aUPPuPbEgY3rDeHGhscBLd92cPA3Id44VCPwWZ8wkFfYZMFfGHFBLDHgVYCzDGbSCQk8aUj8BtMmV/J/VzU13e9Mp4sdsRTd7W60y4vWKgq4w64iER1/8b2AnGfU8CXsiPFViDPKwg/gcCPI74F5s/PVEIPvL/6qroTzkwKYwe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 7=EC=9B=94 10=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 8:28, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> > > > diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> > > > index c904858dff3d..b279f38636d6 100644
> > > > --- a/fs/ntfs/compress.c
> > > > +++ b/fs/ntfs/compress.c
> > > > @@ -105,13 +105,14 @@ void free_compression_buffers(void)
> > > >  static inline void handle_bounds_compressed_page(struct page *page=
,
> > > >                 const loff_t i_size, const s64 initialized_size)
> > > >  {
> > > > -       if ((page->__folio_index >=3D (initialized_size >> PAGE_SHI=
FT)) &&
> > > > -                       (initialized_size < i_size)) {
> > > > +       loff_t pos =3D page_offset(page);
> > > > +
> > > > +       if ((pos >=3D initialized_size) && (initialized_size < i_si=
ze)) {
> > >
> > > I think the following change would address the review comments for
> > > this patch and patch 3/6.
> > >
> >
> > Would you mind if I continue working on this series?
> > I would fix the above if-condition and add Co-developed-by for my chang=
es.
> >
> > Please let me know if that's okay with you.
> Could you please provide the updated ntfs patches so I can apply them
> to the ntfs tree?

Okay, I will send those patches.

> Thanks.



--=20
Thanks,
Hyunchul

