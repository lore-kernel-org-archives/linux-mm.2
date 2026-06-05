Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D19CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF3A6B0005; Fri,  5 Jun 2026 08:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0356B0088; Fri,  5 Jun 2026 08:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F486B008A; Fri,  5 Jun 2026 08:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1DA6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:38:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E509F1C2519
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:38:10 +0000 (UTC)
X-FDA: 84845811540.02.317897C
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 858621C000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:38:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=Ui7qEpxA;
	spf=pass (imf20.hostedemail.com: domain of miklos@szeredi.hu designates 74.125.82.177 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780663089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaIH6xUqz6qcuESYoZJL7a5QWsRjb8U7RVmYk0JRpxw=;
	b=XpKxsMJrw1B8XnML8R2geXVc/PJlKwwrDbv5CxQkKKbQUjUd8hN62EsN0t65Doq/c0oyzr
	nXIFpjlCca/ooDCJcPJUPmLh0vCTM0pHRz/biaCz4FDKhCJzIYc6dD20Czu0i1QYjbD3yc
	Aat9BJT5OQGvIgBD4im8lnxyqMtfgGY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780663089;
	b=hyr1hSGuseZJoQ06oIg6VEW9ULp/aXEdZMyBdWfbb/xgRkRPoZknZC9YVs9yW9bz9sNUm1
	Hwi8fcnrdBLFkNoBIFZhaKxSlOCMu1o21yEvdkuKfTfjrNsFhJ/dQzaBGdv4cBMbA5pwLn
	/NrS0foFIRFfO3DEDuKndjVhC7lZQZY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=Ui7qEpxA;
	spf=pass (imf20.hostedemail.com: domain of miklos@szeredi.hu designates 74.125.82.177 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-307631dbfedso3859127eec.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780663087; cv=none;
        d=google.com; s=arc-20240605;
        b=EJxFbDYF9gnSYrTzLrQduCpsnOR/+cumwdt5F8aBUBMGmidm1kZ9gx5270jLeQQ1np
         MeY2Y1y13Bpf4dBWqepgouO25o79x6RH74+68u/D4+b9/D9QUnB4aiultT/GRJCtXpN+
         Lbx5J9G/21ckDofgP23k8SnR3iuhI0tQoNwlmgzInbOyWgrzUSlPRN1XtF/hSQKnkYtp
         mpagMAUBLShDoxVWDyHB2yRE4EYpwe1niWT3dm9HMbJ3SPMv0VugMXNJXsSqqYQOONl0
         EG+FnE+5JciNKkfWB1/l2DIOBup9xtm4T7hXV9eX7RzfWdmgmGMyM+pMaVj7mMHIsLSJ
         kPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jaIH6xUqz6qcuESYoZJL7a5QWsRjb8U7RVmYk0JRpxw=;
        fh=yxw01p1Eb4iDWv73N+f7XRhbplzEZLA+o9y3fJfNIig=;
        b=MOJwRfjng77AAVgWegfMcMSe5f/gXd1j9xGSvpT5ERQWlBzikAYy0Ef1uPtyRU+iO5
         knqjhX39gycO5k6fnEu4aZfVJFi4SvoUoZcWsAQl6gtEW4H3e1DyXg33mcvHV1jNG2K0
         u5B07rGHJAhRzuXjXDoDOpoM9mysP6o6knatIArLBr6VOQubYNPjh7XoH7fOQEp6Rm63
         f4dxpFh0ABcapB3SVThQrEvidaeoLS/3TfKI4R6k2rdTIhvqVbaPw4w+2Am2TcAdng7u
         UtlsOxZMaDNviSQ6wHy2sBc1pP3JuhuCgtrxWXsu4XIYDuP0/iAHDNvOwS++Sko6e0w5
         a8Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1780663087; x=1781267887; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jaIH6xUqz6qcuESYoZJL7a5QWsRjb8U7RVmYk0JRpxw=;
        b=Ui7qEpxA2xqDgFeKsdxtWjeKWMUa89sr2BHHin/n7lF6uLyt2YH21PCMB/tDLF4Y+i
         9kaWz7JwfeKQR4ueJHMLIJrOVBpvfLZ+6Y/6VTTNyQUgXpmcCSm5XuC8uPShE5lHHE4I
         tkuKxEauiF3u6Txs+Uf936lsZqQ4FVMUWQt9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780663087; x=1781267887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaIH6xUqz6qcuESYoZJL7a5QWsRjb8U7RVmYk0JRpxw=;
        b=N8tZUDPuXhSjfzDAEby1AJuHSn807wysU1GMCavN8aFmt3n7vv1/54T7Df/66AeZ7p
         T9tZjDbqMpqLbgFL9/hta+0tkV3jy097rTDuwZxHnV7ZKOikROGEDQKHi7zmbVW32R4/
         5pD96ro1Pn/UMO5UTjpLMmGjoB8U6NIx9MkH2yh+p7pIN8ur4HUr4JE3e7jLPsVfWssU
         w70JD+MSaqcMvMUbAK0Y3EQOjFpK3b74VCb8HcOuU46yU6OkGfCA4/is5hm1l79fTBJY
         5UwR8Vadtneh6JyX2OQBZ1StdKsAbDOGCLaaH8S7V+UgJCS+QfPpKZJjhf/RbJk/UrNQ
         wfeA==
X-Forwarded-Encrypted: i=1; AFNElJ/qkMDgHCfepTi51nfiGO9+qKLVHx/Zqzsd5FfPcUz9+BNvdA6rkXhlQJc6U17YxUxtUIQ8A6sWkg==@kvack.org
X-Gm-Message-State: AOJu0YwNdsiJ1yi+0q9BeOJUPFdr8VdH2YwuDFrs6/KvxlHZ78H5qP2b
	lVR0RoHe/Dccy0H/tWM/dmiWWH+HLzBRN6ZF8jFthSHJ09YVLGDhy93zOR1RZdnG5bbwBio7UTR
	pnFqbveFvW76eL0nQVBHruk/ZMl/7lNo1WP5bLRk6tg==
X-Gm-Gg: Acq92OHPr3qWVTuKsWjbYuZyWzvUkNKgMXigsm7FMRhby9HMvLSUm70X0uxarqX7ZVK
	xcZHomIZoutLJ3iSFRBHhrHxwHvgEFqlkebHKdjPsMTs0eeitD/jbWloKCxdpMzs8SlNcmyCdNU
	AOUGPgrutaFnQ0PGf6dj3NsgbUXSWvvU34MPTfUu/5YLbYzyDz21Y4yB7yDUl33T+ICsTiV5Hzo
	ZAGpav0/bsYdv2ZnvVz8xZVhd6I4Kt7/KaCea+rLJNc66CJJvA5dNitfqeUv6Pb4xFXHqhpkho3
	WsZ98eX66l+0rzLWAaUkoidGKlE01ZQiYNRL4UDkKQWkEwY=
X-Received: by 2002:a05:693c:37c8:b0:304:6d18:3646 with SMTP id
 5a478bee46e88-3077aeb08e2mr1619952eec.0.1780663086996; Fri, 05 Jun 2026
 05:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260601162454.2116375-1-mszeredi@redhat.com> <20260603-fehlschlag-teamleistung-korpulent-5e0b7fa7f12c@brauner>
In-Reply-To: <20260603-fehlschlag-teamleistung-korpulent-5e0b7fa7f12c@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 5 Jun 2026 14:37:53 +0200
X-Gm-Features: AVVi8CcsjS-pOQInTF6xJp7mIhrit2P92AFENeMBRNq41bIxUZ72aQoIYL-42L4
Message-ID: <CAJfpegvuY_EcQz8fgyWk22=agPq1sboiribP780DjR4i+eqUUg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] simple xattr improvements
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 858621C000A
X-Rspam-User: 
X-Stat-Signature: 91z1hctxgjoq1irdbieq76ffoziuku5m
X-Rspamd-Server: rspam08
X-HE-Tag: 1780663088-353723
X-HE-Meta: U2FsdGVkX18JHjecuSP7qUsYj1TWMTXyVdXXVfYw4D/TDmynw7O9Pqis4urO7vZTSuhh0p5QQ3b6ePPn5b72Eh+0AAH5As96j8tNev0aAIGcIP8gR/LbRP8ftzPm4hwOEHLFvUOJyyrFLWQvspHoDJVH0bSZJrgbMgjfqclFV7r6N/AuwhLrOuolBtSiWmzBaz+U1Zi6rdXBPQq5SxWbLLaUZABDauvLsnTDQv+Wekz2sPaDghXYy85rQTERf5sq2Wmbu1q3Me9P6exAvQgNPKZk6G+Tj1sdsisvsuq1LrdfY93LNKvwPgItnXelMC8h8OLFptItJuEfsqXjH5fg1Lc2oPZE7Pep+MQ/6BcGWJSI2F109h3i/eiaJ2hhEhCO66ic0yTFWMDahoAnmAMGzp/Vf4jrgwj3WE4/GDwdapwfIsjoVgCiLdRL70991si+rKj1XHQDDka1G8U8nfDw+5MYRg5Xt+iNyZj399JU5/0yqbh//zMiUaaScHSG1DVjKXCCFVbaMCMhFaVDlvfB7Zi4TF9OfjzAxJZmIHYLUw4nv2VWMP8zZZRfJbrf24GjDIDr8VCmtuj3BUERtkLzIRvab9RO5tqZMWgTruJ+UtVOjATdPGjVs3WaMQtA0mNDAvVEJ9yQfx7JcCdnKZia1BRp3BMVuTcsP6pJ/TCdDX1dwo+bgT1TvnKsjMeTlqBpFj2c8OMuKGgFFNYFa50YfPKMJEPpm20HFKLDHp1yeoAuwv4sH1Ppt1p4pNfk3CATby4Ww6iCTERHHlnIsNuhcRLPDEZJ9vNbC0H1mhtwcEU6YdPfUbRt8PqnbBTAd6ihWFFJ+DOl2O98cvjChF+6gf022OW4+a4R8EMTDm1r5hQLtp0FqflYMAmc71p9QZcAy8/Nm9puwoC0fw1SO9OsxpEuwMivGhVd1TcWuZz6lCHAxmPf3fMFWDOW1BXErD4P0oURUZf748yFlb4mM7e
 LXcmT2zl
 99irVmFZGbdyVNV5RTaKAyb2Yphn4+Fbti06sti/veYlAHdpAxhE6Rv/7Wxh6GxZnMjgiIAHkgVX5gdFGxZZAiOBCSS9BBfdCilgyDNUbirBfgjN1Rt9SN1ShEj9jM0C7wcwHJfnUFdSIZF3JjN4Cjzgh3wFQD2JpW/ivRyIMvbybNIehopU6vITSyj2vDQn5SFXeX8AZmlEEw1enBYH31/fOJkQNHPwbw/htONoAGvknMiWoAhg7HhoaBDfLvyfv7ya4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 09:31, Christian Brauner <brauner@kernel.org> wrote:

> I've fixed a bunch of that before already but thanks for sending it
> again. Fwiw, we now also carry support for bpf xattr in the
> vfs-7.2.xattr branch. I'm still applying my kernfs fix on top.

And sashiko keeps finding bugs, so I keep resending the patchset.

One of them was a pre-existing bug with kernfs, where inode locking
isn't sufficient due to kernfs nodes being shared across super blocks.

Thanks,
Miklos

