Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD4CCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852146B0095; Mon, 12 Oct 2026 09:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802FA6B0096; Mon, 12 Oct 2026 09:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718596B00A0; Mon, 12 Oct 2026 09:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52ED66B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:32:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E638540DEB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:32:19 +0000 (UTC)
X-FDA: 85314063198.01.74C6B99
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D06880008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:32:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ONiuUqJE;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ebo7h2rv1x/rY0djKxZTjNeMWLNeozXbpIKqXCRxYak=;
	b=BCjyurNZn+Gn3sPfqU9SvQeRagIKGZDmAP+LxPfPKhH7v3puQSxnwmGLduz/801WOyx0uE
	VZmGyvUUz+n87VT9y2Nexw8g8eqox6KiF84aodWr/GW2Au+uUM45uC9IozMokBuYRrhusP
	i0+mz1wsWUCYHk3luXUCu8uWyamUFZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811938;
	b=kbAdNQEFvpN7JdJCEom88qr/UPHQYbS5gWkNZ9TVZVWER9o5v3QJ1TCSZZ4HCAJLszEPz6
	3okU45mCH0DrZVHaAmdMBnUdCG5kkdWUWaenOpriBZDwEOxvtrh0xG9RDjEoAx17cTPG47
	Eo35JbnuyqKGCEoZ+z9uFwsXhoZapb8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ONiuUqJE;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930c0f9c1b1so181560085a.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791811937; x=1792416737; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ebo7h2rv1x/rY0djKxZTjNeMWLNeozXbpIKqXCRxYak=;
        b=ONiuUqJEXVI+ErY9aLihc41o16ozqoPeFag/hJNrUlbCMmHyaz9f4HoyYt4Q3ZHOSW
         VMgr8m++BkfVF2wtPw1TJe+3CEF0JHJHDHfjr/8u58qqnqCcjQ06ScVM8vHn3pJiuQ7f
         xiZBJBDE3mUhe2k7XlsjRqR2O2UZP0KZfouVVNM728nhH0lPGtrn09yZnj3geQuN/a4M
         YHZ/IwbZ8JwBJmdlvNYjJ8CV11pS+0qES7UmeVZdqrcFu43cTvjVV1lCKYSUAMe1//0T
         +oMcx/RaFnQQrR/B73mH2Msk0hbBbyN2arI3DrYaDKBQGcju5F1s0cOLjQz3e+WcN/OM
         2zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791811937; x=1792416737;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ebo7h2rv1x/rY0djKxZTjNeMWLNeozXbpIKqXCRxYak=;
        b=Cv7YouCGjjCh3gH3BnKnUtaAb5u71CmQ7NjQIDToTD+KFLR1tOVvXSZEkZDSz4JIfX
         IfS4wpqdiasKtrhGWeT9Niy1T/uyZpwqFPfGziN1CbZXDsGZSzHiHbLP33ntxB+MVJ6A
         7SejOh4eKaKlfsEEubovsb7+YL6Uyke5zpsVGkmLo/fGN3ih8uwa951SmmjZFBYlX4FY
         n3AE2QmHqCwpFl2ZyaQtYTleWtCZU3/suDZpKy9CCTz4rbeFrJdtsVKrCidAjV4RyN5B
         3t2Hl7IUjJRldoYnu8DfZqQ5jMFqXSrQMcWJuGtGU+eY49KEMwzPU/8RSVbF4a3XaHQj
         Vqjg==
X-Forwarded-Encrypted: i=1; AKwUvByLFb7a78gUjXCERfkuCkMETNWFtqNi69nqslUGAkcaMZ6LD9ZsJaZE/BXePuXqcexFD2eJTXFezw==@kvack.org
X-Gm-Message-State: AFq9FYL3URdlkZV/+BnY4QOlI2kUANladTtQkhLwKA5wH4vHRDsmvIvy
	bnktU/ibNohDK6zz3JF9cBvZTneD+Qm0maIEkY9k/IAfQl7tE4wknFts1xnBbtSjChs=
X-Gm-Gg: AYBFou254h+AHreIuMBY16HfGLa0ylNQKq4HoPH6NfjBWhj6M9AZ2XV/s/AtmFAKTqm
	NF35X7OLx05KTje0OeQDoU/AC2D1OAHQlz1q88H+Rudd/Dv09km0XEhrLNIYlzceI4pcQndoq1t
	5B/ZXg64olzKkjv7cW4Sqhcne9E7AXdCGgDdRMyzhln3Bm89yOCkxlwpPoXWyml6t02mR0voXje
	SQ7Mb4q3LNRFlvESBJlziw1014abRFVYzmTEbuoKfR2GFkDbkoKBT+smlYqMwK+tm1SpxUgriK7
	gHTLuz/i0DTpbo6mlnQTfGFwieK0MKRH9X2yxmG6HgT4QhIldffbcYD7GaouAfdFN8eeCCZTQ+v
	YgM22/6pmn0k1i9D8GnwkUEmljAs3qTM7DYXxBqb3Z6q/bsuGBRM68+cfRjaPLhgyHlI/vtl8Xx
	E1JrHfw8oQBP4bQqcgfBfp0euz3M32v9vinp683RRZLvRfkixY2pTu68eWD9l8xaBl+ij1qcAIR
	ibT8HDddCycoBXcxOueqpBVxg9+yG7z1PIMCNXugCzlDAGUKKYpuIjd+OsPql04Ng==
X-Received: by 2002:a05:620a:3728:b0:93e:c12c:43f6 with SMTP id af79cd13be357-93ec12c490cmr1574730085a.67.1791811937008;
        Mon, 12 Oct 2026 06:32:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb9897647sm860981485a.27.2026.10.12.06.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 06:32:16 -0700 (PDT)
Date: Mon, 12 Oct 2026 09:32:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: albin_yang@163.com, akpm@linux-foundation.org, liam@infradead.org, 
	david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aszhNc-Lrw7BgCT0@gourry-fedora-PF4VCD3F>
References: <20261010024042.4070048-1-albin_yang@163.com>
 <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
 <aszZPq92qX3jpsNE@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszZPq92qX3jpsNE@gremlin>
X-Rspamd-Queue-Id: 1D06880008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: of46nirnhz6mduj5wi7y64w5hegzpt4p
X-HE-Tag: 1791811937-46845
X-HE-Meta: U2FsdGVkX18vMzlK15LUZngQ8wi8HjIHuXsirlxLl50SX5vJz2RyphYZwdzcAZJDSIca4fyxS+Zs2t2KKiIahiopSqHNye/agImbpCqci+/jMDaJD9k4VTESXrYoN9OFaf/V0JJfm3KSAsXxrb2dT3xAT9wiKJZW9zVlx8oW7Tnvqn7cFM2miH7RjteDb/GuNxhIKDmZepmqhtupE5O0131czxw45PDwQKSHY/gFC6sqj/ydyyzFNQHSqBwiIgCD1asvhEFvQMIJtZXFCdy8cOSafHEGDnwa8LzI5pDN27bHVQ4FXSHnoLEW0PHil6G78YK9Op8cRG2vj4Afv0QQkhVDWNJ0L75iV5hBlvKQHs2zjI6ZgFuLjsiTUZ9MoTfoG03rfNGwCCpOvN/togM42igx37xkFGWW8EkUcFA9codWQuX7K5BI23u3PzsHewVFNMkVeHo7c88ElpeC+VG4cnI2N6qbtvAqEj4mJJpMKgW5a29m170XdDdRcX9OGyWFSUL9+YhzGCAx2icUtllR4ONFEkyE/ILViKSSzh46x3siT/6hGPT8BT6LAhLSvqlCnarB/XSVkSHTwfH3a/4sxRsn2Yh5+28i8r89lGM8vmcvXp2VMt/VlPh+umWcYrw8GVSbXnZZ1Nd9MITJMK+yPwgSo7JzHC/6+2cGdm4uJH8LArKGNCr6rU8wl/vzU0c3r4Ea2Acv0w5ZcmLpzBV5AOEZ9G0j4P+p+TPyT3HiPKikrqzkXDJSKZrcOUqq//KIiQ8Q8R9+RCZubil9hT4QtAlIMmdv0M3CHP7Ie9drWQphkWAIWfihZNCmYnPLShBaAVHBy1+B1+7MkopjIwXH55XvpNLQQ+6gVX/pnU1h8Ujk+whxaH0fnkHZz7RdOkY9NIc8DPFC6R7hcUEQobWNXd968Xofl3iIRrG3SaRLmQOzitqrVxNH1so9+iknM0iFZ+y0XByJjdTjs8yvjuo
 ugZ/AqwP
 QiTEI8xeqnQszqRdX6FpA+2aUfYZGtcv2co0sj5my+7fjxJR/wextltJKtG9TJt8R7ciPS19+JEu8DudEZcIsjbDcEe6TBS7yubMEBTXoi4FPZYRqUmTDJ9nfQB5GgwtnOFQ68FU95hoaHPlq4jTH9wQjdzaEKCvgH6+GqsfsW8sTu6+Qz87FdLTBqNKArhjhS0bdBIX1uhODKjFrYw4WqeyhN7JjhTB17xfwf0WpWabE/AdcyBWqwCBPT261P0RGyJjVp8TNVGEczKS77hliP9o7kYhpGq0zXBgFKXVoTlitE3BgkTOtkHWsb0WccfaKb5/ZNDtyQspN2XYWff24zUGoayUDinbykRjpq+7DoxQ2I9LhkordDE+XegQkEVZdfdrGphdhK+difEIvKBfnzTLwiYOIUP5RPSCHy9q69QS9b5ew9u/Wz95AkHgdi90gTTePco/v/gU5yt3Gzbox+OTfikBg02C6OaJY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 01:58:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Oct 10, 2026 at 10:26:33AM -0400, Gregory Price wrote:
> > On Sat, Oct 10, 2026 at 10:40:42AM +0800, albin_yang@163.com wrote:
> >
> > This same improvement came naturally from refactoring the entire
> > function into a proper pagewalk structure:
> >
> > https://lore.kernel.org/linux-mm/20260922235830.2350770-10-gourry@gourry.net/
> >
> > this function is really nasty.
> 
> Nice!
> 
> And thank you for looking at this horror show of a function.
> 
> But yeah as Andrew said, need something for the backport, then your work can
> help eliminate the source of such things! :)
> 

Oh yeah totally reasonable, just pointing out that two separate efforts
came to the same conclusion.

~Gregory

