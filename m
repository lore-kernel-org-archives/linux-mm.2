Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4BFCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A57E8E0005; Thu, 25 Sep 2025 12:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D508E0001; Thu, 25 Sep 2025 12:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA3C8E0005; Thu, 25 Sep 2025 12:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7FE8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:09:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0BB086E49
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:08:59 +0000 (UTC)
X-FDA: 83928256398.08.79EEECC
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E9C6180007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:08:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gpHkty5L;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758816537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lwx7tJRH2BwQj2+dcBbdXE5rd5qpyy7rUF/2X1K6wOM=;
	b=PIYAnJ/TkJeJoGTh973zxUfavYQXkLX2T6/5N8iGgKXX0Vy+dwD5M/LeeVMUT5O1P6nY1C
	IWXoHAm4yvuIiz69fBMgR74hbxpQsQ/WWHMEMIenUoOsg6/Vi2aeswaUy1vMRlAzsRyeqp
	uCyTyJLWHKNVZ+TMi2y4A54gxb0cazo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gpHkty5L;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758816537; a=rsa-sha256;
	cv=none;
	b=VWe0jfQ6Enva+qngPvlaNBQzajc4zqKMydv7pt5m6kstCFpG1GXoNBjXpnHcAMPMq1fXcm
	pW+eze6mrP/qLwOOIOZ1OZ+PTNO/hqH0PdT0LUHKT91W9GJ7weEadJKYRHqmnzHzlDC2WT
	qSIrTS8V5So8FEg6GhfkIHGXHuwlzfA=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so2047777a12.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758816536; x=1759421336; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lwx7tJRH2BwQj2+dcBbdXE5rd5qpyy7rUF/2X1K6wOM=;
        b=gpHkty5LRgpnE3ShEewT+rjtaQKAx5JPR7gME2v+pN4L9UmU+N+AzBgCrhD0E2mqm8
         /RCrLrTZ9B9bU2K/ejraGp5tkXKmhE5wwXMJJ0Dpvi4Y0OPlCPVfkQ9zQeNLuKlq9PEt
         +MZAL97WepA+Y805IX+DyGceLBL+SLGfT7T0zL5Ia3vOuKg1ZbJavKpiz2eYr9IrO6JH
         pcG6p5Fifv9DErC7D/PPA07LtXv14WI9It6iotHqqBt7hMIDzpwv02N0oGfVEBD4a0oH
         BpZ2oYNqIHPYbzMORucUsi9LLtS6uLHtJu2gA4f74E2pCUPBvJhn5RuIdvoq1nlE4OWL
         s0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758816536; x=1759421336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lwx7tJRH2BwQj2+dcBbdXE5rd5qpyy7rUF/2X1K6wOM=;
        b=kCkWPufKeshhpyjmF+usXoIWNmtpSx918h6LoMtDnLYodRZqZ8stTRFrMjxP6rJSXJ
         vIJG81TRy8LT+Gm1601bqaTM0T1hVC6GHHF6vrzwe2+Na5Cm/+lcbyphpRloiH+tHWnF
         RA8Mc0vQSe2YdADGLmOWJNxRajY5PW7mnC1GmfQEE4ZDdif+HaOYoh0T/CqtQXkOK+Tm
         dajTbqTjOmmecfAerUl0FH9gvdcNQGOgzOpiOBMIRDuFVhi9yDUrtNSIe2Iv676lmBdr
         Tm0h2lz8CgoyN57zIvislisfDRYD8X7DtsQUr1Fy5LXLdz7mXhQHTDLxrWM1WFbw7fK1
         +tGw==
X-Forwarded-Encrypted: i=1; AJvYcCVDMk9uceOjeUfSPKgKT2smfsTbOo/zRt4fNEhvUG8QYNzBW0y8AKFw6hIEE78QUOHSle9cARaR/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx6/sUn5sahZMZv3PwKQONZ3TroLpjJ11XWsSinhv7pdG2uioSW
	a217jOn1EqgKi9kzSwCk0Fr0/9dlGeIyJp+WKhU55ukf++g6P1yJAmBYjYslm+joZ0s=
X-Gm-Gg: ASbGncvz/sR/kJuxSDZQ/8hfaanQTzAJvRLUcN0xIFTiHKAfzqgovjyo9RmTAxS82d6
	9ENHckUyShedXTX5Uv/HgfRIUwp+HXUqFy66zJvK5/Q2VOCFzF44U6nrOhme5LxaIBIjlhYfKrC
	8p3TW5xwuHOdm2O1WwoRdAfleASsu+QoNLxXNINmVGh/4jMqJR5ZuRfuXnPtPm2Yx7BWdAyxlA6
	DnhqB6LOtoltb78Gyi4afSYjHBtZKQ7fV3BdNo4YzqwjM2tSm3t53taQ/qrFr4xAtp9ZdPaRwcu
	GKxbNxDtdyrf2JaZJVZP5y9yiJ9czuz2IeX6esYGp3+NYHmhKHmyFHu5Pc5XLl8R6ZZZ2Jj/cZr
	9wbLi+SLIwaOKNfVzchh+LznAshYGT2Czwg==
X-Google-Smtp-Source: AGHT+IFC62tlvjqFU+XcU3GgHFR2n6XJpqVbmQQYk+YQUy0S/Bg7lv6RWH30baCARU+QWGfyzUC0DA==
X-Received: by 2002:a05:6402:23d4:b0:632:7c38:b9d8 with SMTP id 4fb4d7f45d1cf-6349fa930ffmr3197056a12.30.1758816535992;
        Thu, 25 Sep 2025 09:08:55 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-634a3ae3227sm1424845a12.28.2025.09.25.09.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:08:55 -0700 (PDT)
Date: Thu, 25 Sep 2025 18:08:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
Message-ID: <aNVpFn9W0jYYr9vs@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924174023.261125-1-mfo@igalia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E9C6180007
X-Stat-Signature: pd4pbwuf1fgswk8utiwfkjx4m6fsy6e7
X-HE-Tag: 1758816537-761643
X-HE-Meta: U2FsdGVkX1/Tq4HzzjNUkr6jKnG7uMh5Ovmx0L/gS4o5nsMB5B2vP02BAywbqTWTFD2+8JFJwx6eM66Bg/cqxcEqCmRMFS2qdN1cFVZAhDrNEw8oq3bwJLnhFATNconYMe2QKH5O1H+b1B+SpNDGGAqOjrb9/tQWx3VScdeEi3uqxOqLulURRw/cFbeWq8b4LH5/GjDiFruS3T2NbGltxeoziV34rLEKn6tRRwh000/ngT5OrbUpeQuu/8jLo3K5u8eUjrNUy4QVgyvj1NzTp8qQhEF8JEyszrkhuFnmHISJpVF2skXbW8Rm9jdHjFSnPdVhI5iq1GtZnfVddv+2uX7Z3ljSaYIU/ykqlbSvZo7R3bovwn71tp8OFqSbmUcg2iEDjBvq6VaG/OategUnlK171/nbY9FLZCSeSTdg8tT9NtMcT4NJEQtvKOFWZRLQLBeFo2Ou3BJhQCPwqgPJ4fxw4pC6WZ7T7REFNeLghkF+iECEllzBoeYAI7Oe9H3qZ0mDXem2GrtGqDcguTHWfmFOnYPTIfcqF2QQXXqrz/Sg86Da2yWQd6+4/rsclbRlmc65EEcnIlYqYrzbESiPLT7e2iR8thlQHeNNwh6/17u8evgkGqU5Lw1fWr4kwQR8OdEbGWG9Ri6LdkZJLjiQyUDWo2c5T8oHIHBv0eSZsBlygbsgmiflrQIoEvYeRwWG8cSHz22BtoJUz4v9Vuav6RHPRI1vLMs/2AqQEB0iFCoNZRY5kf/Ps62VINTUb+n4pkIQAEd0Pu7fNYql1TGtuy47IJpraiDjwL9qwFfq616RLzVCKN98EGXtI1NZPEGBKNNhB4PYVn2QtfTcEnmmJm1lBRh2megUEvPV4wd1JWOkgZtmQ9J5/Vy2BPHMhfGaHrm9q407tEPQba9XMBSX/uHGgXsK+XOc886prKYXhfemJcfkBrosF3lnWQ6qxtu7bfSD0wDunhIhcUGn4Cm
 7GA8ymy8
 9zPma06T2Xkn7jVTFDMosi1bhgjPHGB0BdYNETDZ7WypOqcgpQi1OtR6pj8ilHt/bEKRVUkiFEglGkuOvybqziIQkQ/pSXuo7aKGrgcvJDDQfWec/uqIBoqnO07lJAFNJW8HDxV92LejoTD7tSpOeyUlqYgJ5zxFa1vtL0sRmwx1N/4rnUoMtzmMG1TNVl7baz+AsKo0PLK1k58wu0vGH1Vjixx7QPeNu1Wcf3RQBW018YrYtc/1NFG5SCPrT/nXuMNqWzVL+Dlwdp3btcXmMWzz5E3RkNTd28j5SDPT3ZW5g64TraoGzWLftCB56fgnNEoWxBbQbDtILt6rhh8fYMV2dYbXjw/nrztVhxkczwKluvRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 24-09-25 14:40:20, Mauricio Faria de Oliveira wrote:
> Problem:
> 
> The use case of monitoring the memory usage per stack trace (or tracking
> a particular stack trace) requires uniquely identifying each stack trace.
> 
> This has to be done for every stack trace on every sample of monitoring,
> even if tracking only one stack trace (to identify it among all others).
> 
> Therefore, an approach like, for example, hashing the stack traces from
> 'show_stacks' for calculating unique identifiers can become expensive.
> 
> Solution:
> 
> Fortunately, the kernel can provide a unique identifier for stack traces
> in page_owner, which is the handle number in stackdepot.
> 
> Additionally, with that information, the stack traces themselves are not
> needed until the time when the memory usage should be associated with a
> stack trace (say, to look at a few top consumers), using handle numbers.
> 
> This eliminates hashing and reduces filtering related to stack traces in
> userspace, and reduces text emitted/copied by the kernel.

Let's see if I understand this correctly. You are suggesting trimming
down the output to effectivelly key, value pair and only resolve the key 
once per debugging session because keys do not change and you do not
need the full stack traces that maps to the key. Correct?

Could you elaborate some more on why the performance really matters here?
-- 
Michal Hocko
SUSE Labs

