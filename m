Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEE0CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2548880076; Mon, 27 Oct 2025 12:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B618000A; Mon, 27 Oct 2025 12:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1691080076; Mon, 27 Oct 2025 12:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05FD28000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:49:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0DCE129CBE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:49:20 +0000 (UTC)
X-FDA: 84044479680.08.6600926
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 36EBB1A0010
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:49:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="E1bHl/oz";
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761583758; a=rsa-sha256;
	cv=none;
	b=KB7iV5eCAaMjsfz++8y7gnneNlwalOgAg7ZUM7HM2x217xDpX9ACEVtWaNH+Aia/aBXORF
	PRS5pK3dFm89lSK7bS3eG/Ad1HVrgrNPTgJx5s6vDtJDVfd+kDkMct4Uus2vU7G2r39rmv
	n5YwlgrMPUsOylKdFCHcNqls1m1f0Sc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="E1bHl/oz";
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761583758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6RVQIT9XTJ1IexdP/0qbvavFIRX5x9dwzaipWLoAeY=;
	b=PJzyy4c/KpEcQdeMIGlBKN5zIip3p09T7ym6Kt42oRvrfoNLPi7hzn4lGONasFT95+RI8/
	Dud4YqKt1fmzVKclP0m2Fm+y2B2QBLP1fITOJ14VM1gkWeXWCu9e5BlI6utXUMPXWwXTWC
	OEIjE3BFKOh8skWOjlpvQuvM579N1uk=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c4b5a1b70so9338678a12.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761583756; x=1762188556; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S6RVQIT9XTJ1IexdP/0qbvavFIRX5x9dwzaipWLoAeY=;
        b=E1bHl/ozEiC75N1gRRvGHWSCoPAj8kp24L4/AhovDkw24fRkPzNwxgaOaRdKIodc/Y
         RlDJPj6d3p8sgm5x2GFmE24CO2c0OgdJh4cD6oTjzdcfMiNcCcXvQHWt53mZR4OMKorc
         x6U3xpyJZQsUzuDnl4uU4+dDcyyK7KSB0mSDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583756; x=1762188556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6RVQIT9XTJ1IexdP/0qbvavFIRX5x9dwzaipWLoAeY=;
        b=uAjqJfaROplZPqJ5ncAHS2O+GWjGcsqwuEnMSQfaPQ/+Wv5nsTJ0zl7/SOhKKQ3xZy
         PgY+VsXzUGtrQ4jofodmS0TQa9eop8nXv9J51Fb75RL13GxvJOF7KZ+oTkmCZuITHi86
         udMVD3SXRZZ8vwo2pn+zqPmr9ONhzEsdQH5k44uttezOwnI/1neNklD6kB5UNiNN0I6f
         8buAvx665QMQfreurbxtFDt7bbK0t77cdHDA5QwYWyhxeD6b16oNDsMD0mqtKpuS5INV
         YEljCimLlTxoUF7ZHLow06JDuF8V2feDEiZ6xETMkuHZgwUN79hDPC1cXjYP6fBweS+C
         xPjg==
X-Forwarded-Encrypted: i=1; AJvYcCXJRN4PwKdsLpvPMPDCDaLtnLilDEKjtPezLTqUhB8FtfpXIwJcUdzZJAoWFnaaXy+TMav3q1OnXQ==@kvack.org
X-Gm-Message-State: AOJu0YxoQtvo2MF2StIKd5flgohHeLf6Ki0WVWinaeB7Bqc1ls5Azqez
	G3nKRdzBPvJceuAvcq+mPBepHVOE5za4oLD3y2h9R/r6bSPZjhTXAVLIWlX5Or3X3vcEimo6vHO
	tB6oITDg=
X-Gm-Gg: ASbGnctrXxUOTTg3vqbDbQzL7RbYcTWT1dnSj0RpveGr9rEic4aySjw2vBVIeS3Rbm+
	6qduSeCLHTXCUTRrgB5I3SOeirJCG6sMN3piyWt+EMBEGElDycvcDuSslB4yi1eOa74n1+alrEy
	jmcl9MteO4thLtIzyEb2xJ5a2k8rP8S/LEg9b/WeoK4KYhhGAZMKGD4OpcYsQq173o/flvZXjEd
	qYF3nOaUXZ/2vhi+38lCxQ3pFNj6NiRqnWD5HWGbRWGACdIcVRxgwpjkLPRgCahx7iCpY0AOKsA
	NcfWuSY1qvHJvZTxvfjbQsYisXEScQhgI0Nt+FLET+Rw+jwtw/XZ+rCb2ead1Q1j+crpTw7FVwp
	EnNePWoMhiQdw3admkG8ixjnhF/1L+nklh/hlzoog64pLa/jf0TgYplbdthV3lb78eEfySd86QI
	qI42NJVs7EKTI47CuOVNE5YxR9JXw7M8el9enIeNvynhArTOO1kS8vYyFRLkOXZHVS8DK9waI=
X-Google-Smtp-Source: AGHT+IHsyVdqGshzxz6bzWfLQnA7v8gqgdL1P8SrZHw0kqBXz9yRA6aZbMIbUdcIYsGMd5CuLxVBMA==
X-Received: by 2002:a05:6402:4489:b0:63e:1841:12cf with SMTP id 4fb4d7f45d1cf-63ed84d143amr490902a12.21.1761583756068;
        Mon, 27 Oct 2025 09:49:16 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7efb818esm6493620a12.24.2025.10.27.09.49.15
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:49:15 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63bf76fc9faso8782709a12.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:49:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWtvGRGE2re7WtQnNyfrWZT/sK+xtBLjxrYyIbCRHyORtbtCZgFiXYUYW+dl9MCK2XtPAhsKqBLfg==@kvack.org
X-Received: by 2002:a05:6402:510b:b0:63c:8123:9d46 with SMTP id
 4fb4d7f45d1cf-63ed8494f82mr503142a12.11.1761583754710; Mon, 27 Oct 2025
 09:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
 <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com> <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
 <7bfd0822-5687-4ddc-9637-0cedd404c34e@redhat.com>
In-Reply-To: <7bfd0822-5687-4ddc-9637-0cedd404c34e@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 09:48:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjgm=xTvbu4zEn3kFRC8bF8XXrOdK5fZj8iNbDn5bGB2g@mail.gmail.com>
X-Gm-Features: AWmQ_bmMCF2Bswabi5m1iDRLn-PFpqrzABrPKB_X0KjtKKqdcRXd8_cg4QARfsM
Message-ID: <CAHk-=wjgm=xTvbu4zEn3kFRC8bF8XXrOdK5fZj8iNbDn5bGB2g@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kirill@shutemov.name>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Yang Shi <shy828301@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: fzkcymbt8dncy1xyazf3mk1eiytmyhk5
X-Rspamd-Queue-Id: 36EBB1A0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1761583757-297297
X-HE-Meta: U2FsdGVkX1/JbITaR1LZd7P7/W7+g/aQe3W/cHImZHvX1yVmabTOB8+WS3RRK+3h+ZImi21l+QSOQOdogcJlUvgYGg3E7k670Hd1BtCElg2NB9qFAkiQhhJoH1Es2wo8ONojbpz0rrVhzRxW7nThthCU2t4VfI1Lzk8IHgmPvUpEfl7TsEpC4m6RP55MKegQ/ea5W1HFJnO6gBThKdtSn7HIgNOSCuBF+2/2M+nIvkk7o8ZzhP7C0OWFwJLksqKLWZpm7vZgVWkHKrMV82uV0dShcSp7eRXZvTultuxRjePHo3Z33m3J6BXQqzuRgomBtE8iGlimzdsZ/43mzBKFEmXo7NbGLhU2ZmFGJk1JdlVyCLDU/nxBF6qSbrMrgLew3JD7L1Chj7Zu+TzJNTegAYqhB+wsvL4pCPbTiIUctX2WbzikFbVIfiPDJbrQ0copvlmQFdn0VCWHZiT+p4+b4D7M8cZ4P2mHn4vFmWH0KV1hKEdUHnQG/xJRIJ+4yqyhlozQVNuUZJHTUBr8WP0J68+zW+HfO631AM/Kn4V9FOkcH7DuY+8wdI0WVmKdTDfzGiYDhfI42SXxuzX1wjDLcN89shHgaM82kJxhpHlf7NU3N8Os07S0kAvpQS8Js0bdKDPCY3wEr6XmuAzusa6H6qQ4v9ysRBZQZj/eCRilLwmXTjBXAk1buvaonj9ounYA9ucyL29XfqxKTJE+3AD7jrnICBXPhyDJ01uivSrwYeSvQIB3c9u8PzrBLlrSohC9c9AoD25pGLgDQNN+LjJEyTad4zRK1pb1uF+SItcqfCnn4LB3vFOCLVYsqFuOLtX4q+MplnensHRt1ekpSqaxsixuMXlJfFwSPt5EWTjXUf0XrFdQxFVCpOAEhPgNpn+OCksBf6620MDyCVCQI/eXK1LyUhMcPq296jhSmo+jPS5ZXs4YUfC7oTTOpAdWr66K7wsTYiLAaHeWBBDt5cf
 nMDJi/FQ
 FtfCnofljhmcFXYyJm6x8XUCg+IOioQ7LVi2Q41oJK7Zd2HDR80v7D6SzUe9tEfwvAc23QkZlpdef43r/3TrW9vk+1ivoKoI3r80folP51dZZL/VoMWRGr79PEjsTuUjIPMTEUUYlOFtFBFFONjtqfAIl2OxJiikCwig6u5qzLeSK3P7cduKuocQ/QLQI6OmmXAOh6akKWJpqie8TdLCh18cIH0QiB53//DrYxTttsF1wKEFrwY/ZVbo5/WJorkWl1x/rict43ky31cPkSubwFPXoWf8Y8OKUzgrBPRZ34/bg2a/Hp8bcNsSCwJYOJiYFQUQzNrxq0aqM2XIuJM4yw57W4axHFQcZhuLo/KVYG2X1oUKQsRo2MH9pGPLeiRonc1DF4ZvRx453LA51p1pHUMp1zR5+KzUz1GDYSoCV+V2HwPXtrdAnXic0C216MpYHD936C1xHcX8uo+VRLQ+xG0XaIk4ElLJ/2Korsc5NGzYXEQcQzccGtG1C5NTaVbyT9oC7Ybqlx7mhI5rkQISgDBbEAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 at 09:06, David Hildenbrand <david@redhat.com> wrote:
>
> So I really wish that we can defer optimizing this to freeing folios
> under RCU instead.

So just to see, I dug around when we started to do the rcu-protected
folio lookup (well, it was obviously not a folio at the time).

Mainly because we actually had a lot more of those subtle
folio_try_get() users than I expected us to have,

It goes back to July 2008 (commit e286781d5f2e: "mm: speculative page
references" being the first in the series).

I do have to say that the original naming was better: we used to call
the "try_get" operation "page_cache_get_speculative()", which made it
very clear that it was doing something speculative and different from
some of our other rcu patterns, where if it's successful it's all
good.

Because even when successful, the folio in folio_try_get() is still
speculative and needs checking.

Not all of our current users seem to re-verify the source of the folio
afterwards (deferred_split_scan() makes me go "Uhh - you seem to rely
on folio_try_get() as some kind of validity check" for example).

Oh well. This is all entirely unrelated to the suggested patch, just
musings from me looking at that other code that I think is a lot more
subtle and people don't seem to have issues with.

                 Linus

