Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCCFFF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A266B008C; Tue, 31 Mar 2026 03:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0316B0095; Tue, 31 Mar 2026 03:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05BD6B0096; Tue, 31 Mar 2026 03:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC9E06B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:19:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78C041B9147
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:19:14 +0000 (UTC)
X-FDA: 84605507028.10.3DB071C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44BA6C0010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:19:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QVztDZB1;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774941552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N67mJoT6zBu5iQWKt0B0XRjd20kwe4lBGYJ6EUJjjbw=;
	b=J0pRWZDEw/QLD3Lw7S45+e1HYZH9GTxBtuY2QX6bbFGsp7d8GxJczoLFsoHjiHQqn+gZFt
	or54SBEzVn4GW22Y2p5Rro+1oNlEgbsTFXKx1HAvJA56nH8YIw70lW0SPbdfNoH6GbyLxF
	TGnGTHrxi5cAjHseUSARyBlMUStG4RQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774941552; a=rsa-sha256;
	cv=none;
	b=UQE/KIuv/qa26s6KBjWrtH8YSialslnNWfC7TX7i7GunA1WD8+EkITuR+PYTQmLUM901CZ
	4QM+ONerzRlkLdh/ZCb+nj4lAjKfSwy5s39el1PDO2RWxwMLjA9o0EsrgmsIQSMj+eU7A7
	poaIdihqCXT2bU4PhWoRn30WmyL40vU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QVztDZB1;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774941551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N67mJoT6zBu5iQWKt0B0XRjd20kwe4lBGYJ6EUJjjbw=;
	b=QVztDZB17/8R6kNWeTe7poUlxbNp4Yf7B8acbMwL3sRH35i3s63NuzsnJMU0vi30wZqGIx
	jWItw6uIKLZyFzy0tWT8CXygQMW1s2RWn3mggcDLeIg4Pnq/atSX25USdx8cz1UOgRPUBQ
	WvX3/gcr2wFYvuHQRI76Gq0ECPYXabY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-9bchDeQPMVKoC04du424eg-1; Tue, 31 Mar 2026 03:19:10 -0400
X-MC-Unique: 9bchDeQPMVKoC04du424eg-1
X-Mimecast-MFC-AGG-ID: 9bchDeQPMVKoC04du424eg_1774941549
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c741f038f7cso3678909a12.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774941549; x=1775546349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N67mJoT6zBu5iQWKt0B0XRjd20kwe4lBGYJ6EUJjjbw=;
        b=qPVfvmD1lhLnwGkNUKmoDS7S8yOuLNUcof2O5RCg8IXwcH6U+uF/ZEvDvA+trpClQY
         YfLSfTvS4XVYNfi0FN7QRmUJlbXepdHSZrWor0qNjOP4rJo/oLnotF4AkFFHdTO9b3Ap
         F142FshR8nf01qRDbDaRVMWEOvA7gXoZDzclM24lm8cGOAIGbhiprCV7PV+oa01m8uGW
         Qzw5Go1nnVYqVRlF9skphMO6OTjIJY5blQ9w44DUa4IecMhkcvCb+JrT81Fa+imAQgwY
         0QcQ+OxTz49zmDY5bmop1wdToZpk18g236jzVD79T/sVT+CRQhmfL9C2OPrBc/TB4cZF
         Jl8g==
X-Forwarded-Encrypted: i=1; AJvYcCWUDcAO4y/QKSQ+SdEtLHxHWuaWWuwZtpPWP40rsmrDfHLk4uurBfxWtNikWgBq1AkB/J4uPJFAKA==@kvack.org
X-Gm-Message-State: AOJu0YwA28RILCpofWtc7ph3ZAQGOYPQw9dKAFd1d+3lnKwXW0WMZPIi
	1bWF+axQJsJrpA+iknCsnc458aOgV+yMLH5rYtrd9XGj7CB+KhHf0+CQ0HGu5ui2NVQdsK6Q/C4
	R33dYQ8iymYvXg9s7kbNU4cD6B03ce8ZGqYVpF/RSR3LUErbR2Dgi
X-Gm-Gg: ATEYQzwPf3E2gcY/+X9eYOv+GcK77Icnxd0OMc6ibPJVN6OGITeat/moWKQefFVvvqw
	gVhGSnSD2zmzdw4OQvtxuxLycG1aSjNJvF7mtAp4MhzraxT0fPwK8ns0lRQdN7EQt/Sgr/pnDE4
	Vi+qikQYh/p9veIFpw16Y6sGzYXMqsXEJ5jGtihbDBOJ5xBm56PfF/ntvdgY+FE23Rf5EVKydHR
	TBrEEDVzoHsOTsTB1fLzznss82oaPTJqvNvn35a7XYci54X16/RrZwGiF2xdjWdb7XKczE38RHE
	XZBU8xXeu1lGVLAaXeX1MQ/ULQet6rPCo6xp57txYT+FermdUDlacdPDZTbxpnAE/+TfZD0vMbf
	TqG4MeCKo8S9mrMD1pA==
X-Received: by 2002:a05:6a00:438a:b0:82c:7f08:8826 with SMTP id d2e1a72fcca58-82c95e915fdmr13708619b3a.17.1774941549206;
        Tue, 31 Mar 2026 00:19:09 -0700 (PDT)
X-Received: by 2002:a05:6a00:438a:b0:82c:7f08:8826 with SMTP id d2e1a72fcca58-82c95e915fdmr13708602b3a.17.1774941548801;
        Tue, 31 Mar 2026 00:19:08 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca849849fsm11095413b3a.26.2026.03.31.00.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:19:08 -0700 (PDT)
Date: Tue, 31 Mar 2026 15:19:05 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] selftests/lib.mk: set PWD from CURDIR to avoid wrong
 extmod path
Message-ID: <act1ae44xGmG86xT@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
 <20260331040156.119158-3-liwang@redhat.com>
 <20260330223025.4ad1cdb9b79e242f01d8b83d@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260330223025.4ad1cdb9b79e242f01d8b83d@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2vMhozIRMdCz2Mfz8upyGyXNmZjMQOy827yDxfgWfmA_1774941549
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 44BA6C0010
X-Stat-Signature: szadixe85b1zjckrmtzybsxjh7agbw4g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774941552-229477
X-HE-Meta: U2FsdGVkX19zFRW507aUZA9vmJs9yoBQXZp8WhVHN4ZcTV4yjLIvzqXpw649fUHHu153n06m4jqP/2zjyFtwbVHL0e6qT3RwxUb7dGZC/r87mz5OdHMQokMoFR/9csh97VuOrhI+gXgCoXwIQvQoCVHWZ91nZDl2PydDLt6Rinof7BP67kPuk1qG6fa+SxM7AD2b6oPOAoFgGjHdeXQ+wpmZZGLqclXAbh6KwECZhBYDfnkGfc2yzt2Dsar7hVvd/iEjzUJTOjoPyLQDrUmz/+cmawhGktXQ8F9P6iHOUrL4m15/E51i8Uip4O/Heq56ROEOA0lu4Fh+TaOrNFMoenaYBeN836fGOanYXFMirTMsPpTpokyLoBkbLASH/7mtnPUrjRm2abs3sV5S8rT/vFC2wOP+ZIE0dPYK3eC3BBSYEYlG/FHvUQM6LrArTZIVNoivJ8jEqyT8v2eMGzZrx0khW/4evb2HDe0s2EbLBqqv2mlsagqXaWzudhLGAgPvct8ZX5JbtINOcyWoohSAX6eIsWjRVkWazpTwq5TYqdWjZIcPVntOG99f4T5RbdaNjIiMw/7xDMLjDRlv0SnbQN9FTLcA6lYqee5jLUkNV0OVFYF/Z9V4zPfYhWOA/z6n2hLSPhaMUrtsTKUMtH4a9TKLq1XBP59pW2wVQORGuzsjjXA7DYWzMqkV+NxJSYyDcNR773qCRYU13Sv6rZaDKtvw6L9C48f66vvEvea+ov/WWRYWaogKu8Fe3HbspVa/KWpHy+ZxJeLCgAQnHyDL0x2z+JZpGySZ35/lYAnlekoH6Qo1TeYvMyopYkqozj2ZNXy3J/+B+g8v/4nCdejZhTUnjx76uAiQrVS23ZLd2ASRxFX7Zuxy1yXXmAmUva5Dkp0ZaJgy+csjq80JLIc5JIKUgWqkl/zCnOJrn94ZoVbkxqYu5VAPoO7UkrAXius4ADwn+m7Q3wRreycNl6I
 l6tLKC8j
 993kSHzc6840lsEg3z0v+wXXyf7ipduk2KlL2gqpRd28BLARrKVQ6R0+XsedhEoxgU9AbG9Xe8WRh5NvaQPS8Wlv8+1xBd3J+KGv7aQBeQM3zPIYHPsodYDwJhmvBtFh3NIDxk0unNaA1bgpPcW/L+k1veR1xTbvX2H9Dj7emaEHb3EvhF/1RfgMzqMgE+M8+w/HG3iRvKeHxIf+tGqzLvz8y8DGmVWFB5C70Z3U6RZ8mk2lNrFb6xSzp+Z3K8YI7n9i4Ygjae/hbZAjdvoijLy9L4B3lMg+Dw+ppQSi2gBN5yBM03W1PFitjbP2guHCqvFPXevqokGNrlo5XDf9WwsGigiw+9dvTkiqYBpqeoW2sIy5mf0M/xxv9HcczzShP001Cg93zLOVq0/J+3VQAOfNDqumf6hJcAekOAgvEcHBWfNwkvSPSxiWz7w2fOY01ErlTDiUFCaBRSEDLWXGPqqWJ2n+1apNMC7PPzT2kJk248gcfWPuu4KxNf9efoivGzMqK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 10:30:25PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 12:01:55 +0800 Li Wang <liwang@redhat.com> wrote:
> 
> > When running selftests from the kernel top-level (e.g. make kselftest-all),
> > sub-makes might still inherit the caller's PWD from the environment.
> > 
> > Some selftests use $(PWD) in recursive kbuild invocations, which can
> > then incorrectly resolve to the kernel top directory instead of the
> > current test directory.
> > 
> > In that case, kbuild may generate an external-module wrapper Makefile in
> > the wrong location, potentially clobbering the top-level Makefile and
> > causing recursive include failures ("Too many open files").
> > 
> > Export PWD := $(CURDIR) in selftests/lib.mk so $(PWD) always matches the
> > actual current selftest directory.
> > 
> > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Li Wang <liwang@redhat.com>
> 
> I couldn't clearly figure out what I was doing to cause kbuild to
> destroy my top-level Makefile.  It happened three times and it wasn't
> fun so I Stopped Doing That.  
> 
> I tried a bunch of things *without* this patch and of course, Makefile
> is still intact.  So I cannot confirm or deny, sorry.
> 
> I've switched my script so I'll henceforth be running -j100, shall keep
> an eye on things.

No problem, actually I wasn't able to reproduce it, the patch just worked
out based on your description. We can kick out it from patchset unless
someone confirm it is needed.

-- 
Regards,
Li Wang


