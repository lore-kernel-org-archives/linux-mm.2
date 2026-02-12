Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE3FECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388476B0005; Wed, 11 Feb 2026 20:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336086B0089; Wed, 11 Feb 2026 20:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217CD6B008A; Wed, 11 Feb 2026 20:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10A756B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:50:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98E0B1606F5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:50:51 +0000 (UTC)
X-FDA: 84434125902.16.5AE40A2
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5BF240005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:50:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AS0EEafQ;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770861049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11XDPX1CFFR/qoWiw0KVIqoBf6Mj8ZzwRjar1RNGzlQ=;
	b=AN1QesxJhVEQb+tAosCZVJtwAGnbueoeUBvQ9Icexj4jsidCe/tE67RwXLFWYIK9Re3WGM
	XyCpHPv8puzH+4b1SXflk9p78sEMeiNip/e3WHkD/9RS6m9BI9Ao70bWF1PP2UwgkWePgl
	/f0rf36ABhfJR3/BX29hLGbw8kTPW2A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AS0EEafQ;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770861049; a=rsa-sha256;
	cv=none;
	b=5+FLgB3JmFi4TYtawbmkFiqe4dFtC1v/duTkcCfgVMaymF1A2ibhjMU/+z9GldQwDGjVOE
	5BLFYeV4yzkWOLukmxEi7QtKrq6P3dIxcF8RfYjYetdzob2CHjJecd//p8guNvw629Zo48
	poJ8rDz+lgv5dN55iNgN57X4Ga2BLzY=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-823081bb15fso2984571b3a.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770861048; x=1771465848; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=11XDPX1CFFR/qoWiw0KVIqoBf6Mj8ZzwRjar1RNGzlQ=;
        b=AS0EEafQLIJVpTZV4xzF0DVMxcjh6mM0yNXrsRzKuunFAtfnxq/tvJGPOoMYYZy3Mu
         HIsif0B/X3PBWmyS3hR+hW6+2wDd01QkTlBeydXjOxSLgetkLz+0m86ALuv/8UFsD8dy
         OKkP1xAMz+NYrWJTdooJ5p24uLVY8AQm9f38I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770861048; x=1771465848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11XDPX1CFFR/qoWiw0KVIqoBf6Mj8ZzwRjar1RNGzlQ=;
        b=rl2OYcyO7JrRkzTz9oS7eKI6NzaTmLFHfdPhkGwxuT/9qGQDpPcHSVKtHZMpVBlci1
         xELvtjg2q7T3YRO59EGGdpJIgLznf50LwdtUJxd9136BYiqk268hlpXVhXmd/AgSFxSa
         OHbPVwGY/GRxzbFWv88PvivYQwivP08N+kj7iYo/O/aXhA/hU2Lr5eskLMAUaaoYH0Vt
         PUkLoKUXv060D+2SUHhGCfHdaiCE+EuM9FMnancPt0qVNN9RF+O7GFwPcC7zvkZhWCA4
         m2PCbua8lfJKMroCqlwnSx53KiGGPbap/s1YpmwQR18wm5wbp4AYyOtYK0C2iwMCB9Fc
         tk9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/k74mB0BHSvUYhROkdcX7gP9FtB1NjFd/c29kQiAL/fYSZHd2xIw4xfUWiqyNOhXK6ZksR/SyvA==@kvack.org
X-Gm-Message-State: AOJu0Yw+KXUeXeyrR7udSu6vFHAknuGQyvW2M0wP1+KFtWZUPdLmqwcp
	xwav02UYyVTHADkAIZjsVX8e/PZqc3TsDseGDxET2Ytb5q9cMSUyvyCb0dIxWH65ug==
X-Gm-Gg: AZuq6aIjifLkLDWbcYx3o3Jz0tg5aixpZLiBLq0Whr3Cdufy/smn+EQpIfZBO+qdbzZ
	2btoOmYvPRiDjtPHX4/xXoRYBaNwP1bphT11LxQLSpQ8Nay/0kXjx5Jwl1O/eOenyRyVPGsf+5l
	WjipLNUY6dW1/u+H/jhdeNYJ2TQXdJvhTacoFuewDsJyn+VP1ceyZmElmwfNJY63UjtnE8Mg9ZK
	wOc+dowSrZCtArZqlSezzLec4Hc1swu3ieDGMKcPZ9u8NnLDmYLMtN9T6RdeRGhe/JvMx1jyM3U
	Jn6JpDf2YFMvuCq2iI8mMbhME8fy98J0T2ZG1trdehqYw7qM5HRAyVvnGLnr6fL2C2MenUJMx9/
	8LPJlKIDkWcviPlTcU7XCOs6ZgwguZ0Eqv1ex4l+mTf0OhNnuYK0atiSjlGV5w4G8cO2ke97JaP
	HifJQLUiHCr131rBU4y9jMPV+CouEfnPxK+zGMxKzORlryCnrWUmupE3NKUPjH8w==
X-Received: by 2002:a05:6a00:f9a:b0:7e8:4471:ae74 with SMTP id d2e1a72fcca58-824b05b5bfcmr1064692b3a.64.1770861048620;
        Wed, 11 Feb 2026 17:50:48 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e366f85sm3277085b3a.5.2026.02.11.17.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 17:50:48 -0800 (PST)
Date: Thu, 12 Feb 2026 10:50:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <qk555c45mchdhz2ivjrrva73gja2d7uny4tu7qx2f6c5rhanhu@llk5m5gilog4>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B5BF240005
X-Rspamd-Server: rspam07
X-Stat-Signature: pazc7p44s3pyfoo17bgrcz3wak1us9pb
X-HE-Tag: 1770861049-481739
X-HE-Meta: U2FsdGVkX198ixwe82b9Ufn/NSz/s2SIliEjkOs/DOyD0DuRfafAcdq+i9gIIwuG7VcXkaeSlE4JljORkL6CXMXVsLjjpqbW+MhJjNitwH3gIbDDEIwClHCoTowuTO8iIfjoU+yDRr2SiAItHnswofcOz6DdUXSR14KXT9+/qLIV4wJ6ZmhsIQ5Y44fG2BMiVjxg9Pyz0m5yvP/yOvQd6IopDUqAw7VqwVAYjfvLeheN0UsL0XWkooY7swFZ17q+AAOjzQBBI8HED7B1vrzMSSDIzfHMpgXed1uptRmLMbaVM0pxt0xVHyAW8vMEYDlK7g4FuddEaGohp4kCezI9nifvLJr3YJV9dEDJ0E7hEIb7iAPrJYF7F33eNCZzLAZasaaE5t+mHyy7YhKlUifGBMZ3zmpRxqaMMh9qzJDTQzVkXD3Bzzne5Rf8VjAjNS1Ln03Gper2eT9984EKFVr9GP0y+IllYN9TgUoWWWP/2KZVahGRMhkYGHSkd2c/eKV/HPr0mzLxjhMyLyEsiJsVHRQ/g/O9KiKPHaiezZfbpSMmrdblAMPLlxBokpTEPxiYlBdfYAEGl9TU/FrYu260B7psKAAUANP8mBi29vikF06DXap6FjPji/Adem48yXJojRlxCmz70mtdBXUjMn89h768g4PbR6scEAQQ/GswTxyTrbWJ6KzUAK26OxgKYaM03kd0IeoRfKNTU8EnnJrXrA21E2xGGccsUzUAsobz+Zx+MBE53fPU+RZL+OQK4rzQWp50AQ9kzGz0okrfrMOUHhEzd/NZGvMW9EWJ1s9kPM2vs5svjD5QzWlYiALdTcSXeL43NZnIXfTLv6C4GsICokcQj5BzITc1aSTbTKEluqOPiOUV2HSgaeVtuNTw/8ry7XnUZvYrFB6ryx+DypGqr28YNp4a7zRhiro80op4N5eVRcHas5weWRsEBSQMNPQj8PUi60k8Vzb6hRVb2d3
 35YATAf8
 n9Y43CCWv4saQmC35XIjO80y7PTTun+ObnkjT9IQW1fLBVBNNzECDxMoskob01JOq8G4VoBAFGdy4oug/P4XUhHIVY04ospdjEcnHt4kOuu85fh3YMdHgekk9d6xSXuugSp8tdDgFGGtElcyMOr23m2e8MW7IVkDURIrYn6vggI/1yGTKNBmiBMkmtq56SH+q1i5+sO778MeEgbijUm+O+POR5+h4f6ONb5opQEIseXgDbSbLAfo1gN4lWRzJCm1xq0OQoDVcR7WrKdtoPhZvn5XpRb7ovuENnesfj+pB1wG57XC/eViEabEUBkZwpacNi2r9WboRAoofo6KhUMR3D8iPbO7892sDN42hxpdeVPeSFvrgO+g7JWJqptTwkuo/6N2XVwZ9QGSYkpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/11 10:50), David Hildenbrand (Arm) wrote:
> > 
> > v1->v2: Actually pass "cc" to hpage_collapse_test_exit_or_disable()
> > 
> >   mm/khugepaged.c | 22 +++++++++++++++-------
> >   1 file changed, 15 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index eff9e3061925..d32a5ad27097 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> >   	return atomic_read(&mm->mm_users) == 0;
> >   }
> > -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> > +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> > +						struct collapse_control *cc)
> 
> Two-tab indent, please.

I initially had it like

@@ -393,7 +393,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 }
 
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
-						struct collapse_control *cc)
+						      struct collapse_control *cc)
 {

but wasn't sure about the 80-col breakage.  Is that what you meant by
two-tab indent?

[..]
> Do we also have to enlighten the kthread_should_stop() check in
> khugepaged_do_scan() to check kthread_freezable_should_stop() instead?

Most likely yes, will do in v3.

