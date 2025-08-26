Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3393CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEA76B01A9; Tue, 26 Aug 2025 16:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088866B01AA; Tue, 26 Aug 2025 16:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07B96B01AB; Tue, 26 Aug 2025 16:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2F876B01A9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:12:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84AF81402E8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:12:46 +0000 (UTC)
X-FDA: 83820006732.16.EF70233
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id B790818000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:12:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UG25B6lp;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756239164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZUUI0yFjx4Drp/i9QRBY6PhrGAJcR8oUaxxKphl128=;
	b=B4aoEA7AaZk6Kd8vpjIbyb1O3LO9oLrAH0dXAphBYEEKC7F6hxsyu04LT4VkboZSu2y9XP
	OrrQvJFPHw4b5nPFzxkFsYyxecDMOjDhsMOgafDXO/Ph2FIOOFcH8cDt9KicwjwWYtjkVc
	kA1dvacPGgcYI/7iQU72vqwzBgMkcD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756239164; a=rsa-sha256;
	cv=none;
	b=NXD3+rJTsiSi0vGLHnHVHUEwONFMaWOWeqmWEgtGQmsGN0yiiVXqhCaVk6/kKYve52yqdr
	CmOf4JcaurapeNvbL7PrVTmvavmqRiQzh8UYR5RN16qb+KKHCaPOjIayVe5azpSeiL3tiN
	ajAjeXlttAKry3bTSQN5JGNHCpZTxI4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UG25B6lp;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76e2eb6d07bso5270765b3a.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756239163; x=1756843963; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZUUI0yFjx4Drp/i9QRBY6PhrGAJcR8oUaxxKphl128=;
        b=UG25B6lp0AWNhfTr8EJ4Rtk+oTF3qfl5HYu7NO3uM0VqrusZ4Sirvsxr6d7sVTsupw
         RXZSm/iSM8cIH20ReAYcQN+nKJKf2T54JQwDwLbqvb5sUU0tH0BvJYDkw0gjQAl1H5jQ
         2MmVyB0JtVtRLsvYgQtTtKCzOVDwCEiqv9ucCTCIHh97kn6YtzBaaJKQbOuT0CDc7unz
         i2tL83xB3IlXzklWvQTwzPHXkUVoVD14x0MAyJyzIsKnu7ZBlIkqxn+8Sp0JsZvLZRk8
         EuczuYuPywrX/2BxyUyR7lHGT8Iehvr1Acq37Xrq0vNgNThfJB1PNuLpF662pPDP7j6u
         AaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756239163; x=1756843963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZUUI0yFjx4Drp/i9QRBY6PhrGAJcR8oUaxxKphl128=;
        b=AEXhTVO1CFfB2Wllu2+nFjKr6PjQKF9gckHoFq1LKli486FdQC5bLk/YLDVtAUvme6
         ifeGpqkinvtKul1Ccma/UveFiDDDIlnfade/BO2s9DxZN2CGxqByIN87JMuTlfWnWkn4
         1DL+LBE3iBB752JJNsfY2vWJrcXXGyaCLH5ViXfjsmEHY34dULX54qm8EmgeIL65gW+g
         atTDWNiPDNtCrh6r2Bn2YQh3+VM1ajcX4LcZkX+rK7OHPfu5erDezYruW9ZbwsZDsF+Y
         fPOBM4p1ttAnbUtpfZC6ttCdwaELqHgldNIXsHhxqrH/s52xixcLIjdi6B2e2m6nrX7B
         N18w==
X-Gm-Message-State: AOJu0Yzw0m35T96KxKE/0UaKbccwoBfLDnlgPBt44oFAN62MOPSHhe7l
	A246W7Rmr8xsCPIXrT25ws7t20XPb4cBmjDQSCNPqJqAoCuX3UI4pKTV
X-Gm-Gg: ASbGncuiWlvE9xUW8s/0AgtPwLjKsXPRqoLgOpOLy+7suV7QbJJOJVGeguZSAvBGdYd
	E219A11CAWSIEv6Whcc1efWIQOmPSE2jPjmTfwKwmDHbt7DRT62U8FmzzaYcOyp0x7qYblPeTi2
	6wfuFHJaPHSMcdVjfYRFTatuLS6t8xZRS7tOm3YfuF3WnPas6PAeqJfI78HylyDl1QwJdauViBV
	0v3YZ86Ho/+URfhhaBrHpkVt6yEXoHQ9RBLX7jZ3bRpyBdxvoS9G0Og1GeqQkeii5WxGVyM44kL
	NWFqv4K0taE9GmEjEo4oscwZ4+s5qlLyLI7L+gH9J2CQuGfqwIFMKxfZ9It0yaRcXqRwX73JhAH
	adaOTekfmQUspKUjKtgMoSpkg9P9nS3TWAw9p5/FTpjlFpVUrPccDzw==
X-Google-Smtp-Source: AGHT+IHfG0QyP6TwtbmIGZnRuYGpxFBNC/drydOrZo6w1M6mkbJLwel6gq+DtmZVLKNj9XvXZbR9Og==
X-Received: by 2002:a05:6a00:194e:b0:769:9f87:1dfa with SMTP id d2e1a72fcca58-7702fae1e6emr18957401b3a.23.1756239163520;
        Tue, 26 Aug 2025 13:12:43 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771f4072ac4sm3631172b3a.34.2025.08.26.13.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:12:43 -0700 (PDT)
Date: Tue, 26 Aug 2025 13:12:40 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 2/7] aoe: Stop calling page_address() in free_page()
Message-ID: <aK4VOIlc19qb6_DQ@fedora>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
 <20250826193258.902608-3-vishal.moola@gmail.com>
 <aK4NzxmGZjKvsGz8@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK4NzxmGZjKvsGz8@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B790818000D
X-Stat-Signature: ms86stfz18ud44t4otonpsx795gx6u9h
X-Rspam-User: 
X-HE-Tag: 1756239164-124176
X-HE-Meta: U2FsdGVkX195dy5MRC5dHoCMhndNYjllXyQhgX6FqmW2LkHLyPWEBKNft9vZTYFo3d8cFHVq4yKmCi7UsVMv1j9KOwU4ybIaj+WKs6+Tk6lNncauBlsik91vcXjqAK4YlLWxH7Kl8PZg4Uey1Cm2thH/8i+J0e6DuG3q8r2MTibzSF99jEN7S3ReSrWgVs/N3FDaz2Rbuv1sywhqyREDG0aqIeh6LJO4nK00AFJ94TjBtAYflwDLO9wpKPIiMBEp3P/EBOciTYfGpnmKuG6J4Wf7cR6Axs6bbYgjYNNGEfEb+LluajddhqqGonsvcxy2E1/b3+qqmovS+w8xT2KftUUXgpbWEzrFwotoTdZEN9BYRG1Q1otKj3GYHKwRJAa1mDtKr2M8Z1Ka/lMkuvFCpv6dR61+J27MXq5uzie4IylrAZWmlJkPfKDIg5tYqdwwYHJQi+QQk5/O8iT28aS2yUkbVU2kHrGuOz5N+R5+Txt86JAc0tNtc3L+GqmQ/VMHzkfLeCkZ8Lw2UVJMWgk2eTIlcA5pfECrBb97Hki83kghI2pK3YwIWyssWwE47MYSKrNqbqBbCDqPVNDP6amEh9dMnXYRs4USgwDp4aW1r34hDmto7/P5OG+KFnFoZb1vRPk8RE6P/egQ3W6KWC04p4Iw2bRR27gH3X9z0DzZDlPBwDq/OztoDV5BNS5/7/7nacfaiuOIdiSLFd0K1B4+wOTP3JNgk+AL/XlkFeZCZAETwE7PulmUhqY+lZv1zm9UKscJHlqxCkxISfzjtoS8qYKX+sF7rjYOtbbwNHlqjbHXpXt+42Oa7dCgxzzF87VbHWdhkIlRgjiWblqpth5XrXXLKrL73z85J5NRO7F/dUZzIbzsmRocK96bqIJKpNt7IRy83ok8Hvk2FBoTvyd9XQVll7JkpZPnRFAMI4WM70vp/rdJJGk+ER+uLQ2uQnCI2r4NNnXZRVkBxah0X4f
 ti6z50N/
 5OsyaXWv5nlthxFkGCtLp3u5cGec8nA3mElARCvsCa7m95sxnQ3NlWHa9llJ7RLR1ndlFKJ7AotjhLzBPKIy6su4fFBr2EO4OPfeTF+GRQ2TK6VTphBxk/LJPCD1XS82NdI5F9vtBcv9XHQxyCpc+HII2KfZU6QXjyObsDgVUxyyJspk+l4jiV1HS0GBAW+KESo9jtFZtT1GgFXp3KLrhyKYpQ4zHshlM4nsflWmrx1pt1VqTVde6OIUrHbDRSOOf8UmDs2Eos4Nu09sJkN6071Ay4bJhx8mAcGnPdnem1dYTFpZjCrIGf3bV+y6qPo+N3lB6Ez1PxVyX4mv5orVhbXLUASczyjW2SJiapgj6+tr9FGsae9FexjQDJCmU0QprhIwSwZmb9j9oJvFk6EriIY8Xsedn6Yq2JznRdvqSer+RF18nflK9znlpscLIBgSJTwFEyhCA0zDc7ljp7U4Ipn7sdelNK06utB43CqtAGjtrYGzZjkt61pxAJcOFhL5oEDJW18cFzc0CLDbS/d1G26DcR5L1FQ7l2pA5mIG5smrFt7HU0vAGMz7uBWFXg/yvTkrFPmwJOpr1D8JehnE1mqgnlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 08:41:03PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 26, 2025 at 12:32:53PM -0700, Vishal Moola (Oracle) wrote:
> > free_page() should be used when we only have a virtual address. We
> > should call __free_page() directly on our page instead.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Probably should have run ./scripts/get_maintainer.pl drivers/block/aoe/aoecmd.c
> Adding ccs.

Ah I thought I did that... seems I messed up some formatting and none of
the ccs got added :/. I'll send out a v2 later today with all the ccs
added.

> >  drivers/block/aoe/aoecmd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> > index 6298f8e271e3..a9affb7c264d 100644
> > --- a/drivers/block/aoe/aoecmd.c
> > +++ b/drivers/block/aoe/aoecmd.c
> > @@ -1761,6 +1761,6 @@ aoecmd_exit(void)
> >  	kfree(kts);
> >  	kfree(ktiowq);
> >  
> > -	free_page((unsigned long) page_address(empty_page));
> > +	__free_page(empty_page);
> >  	empty_page = NULL;
> >  }
> > -- 
> > 2.51.0
> > 
> > 

