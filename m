Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8066FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD3A6B0098; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3E46B009B; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9866B009F; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 518776B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:50:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07DEF160B91
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:50:58 +0000 (UTC)
X-FDA: 84605889396.24.C56FC54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C960C000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:50:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VwiRDeDS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZUnMNCPUch+nJ3/cZQxbUv/pjvJWtkozyvEHDR71gc=;
	b=B6JYHQx8YQFixZinxlNsAHDNIal6N6UIpkK5pEG7faX2l0axkWIRsTAzRlfLMoKKNPMTMB
	VUIq+IzsuAnY7aYzMYjq746ZBt0CJgQvhxtzBbr54WdGVl8pzFz/M8wpWXB4IY1IvGQpOS
	mXItC9OSrH09xbrjFgRPIcIiQZX8cks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950655; a=rsa-sha256;
	cv=none;
	b=a+nRx59UBGaT2ieEZsLP764BelWqhm2JWE2Z4i3QsLrbn92Ns4cgjcWjriJfCcnl0F2OFQ
	foV9Eeq8tgyJVVaqDN9TyeMKeyxFm8tifOlroo3bsvals35CHbznAuK5dAEQ/haQgMr9G9
	DucZR/Y6XpAZ9UrVkOPh+RAEPjg74m8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VwiRDeDS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774950654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ZUnMNCPUch+nJ3/cZQxbUv/pjvJWtkozyvEHDR71gc=;
	b=VwiRDeDS2EzUz+0LbsyrzX7NFAE8117TsoXT6lqkvXYlHDZvvtUnf0WcjQOG2gS3byCXzF
	BK3cDQAYuIn6vUuFEYT7GwDY9W1i6IjHFGSiPaIzSdyxvLW0oicuuXOFZEuEKL08xY6LT6
	nrVNh0V3QxWFHDFD6APO1m3bbgm1810=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-ASW_mg7jPWSV1HGMwIRB1Q-1; Tue, 31 Mar 2026 05:50:53 -0400
X-MC-Unique: ASW_mg7jPWSV1HGMwIRB1Q-1
X-Mimecast-MFC-AGG-ID: ASW_mg7jPWSV1HGMwIRB1Q_1774950653
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b24611696eso20684435ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774950653; x=1775555453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZUnMNCPUch+nJ3/cZQxbUv/pjvJWtkozyvEHDR71gc=;
        b=brxisPMn/un4HtKIf+ZMixWLLKJHaW+FZWm2Q86mByDkkVYClCs3arz01qcWy100pK
         tpXfXchQRAJqtsAyRxy1bMjUK2aOb0ZghnpXRWT0ycePG1p8ZTb1sZ0IknX1bbiYl4yY
         1UrpN+TW3LmyxKtVGLlXt9GHJrCKvYEl6kyEAixAjySnhVX2N1VZz8zoV/pRQuF5XjBT
         SZTNfWa89aXSZbrbEemTWHo8jPQuwZ27hhOn7tF5P/hQ6KzDSRz7llg1804roly3l7JW
         +S3TtHRspng1AOj26CvQ9pS4uDa5S+G1LUtJ4fMVC/YJas3NP2Z7758JQL8KYQ0Calvh
         5upQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOSY3WV8jF/OFbg5V6ah3dnI02/ZIeBZ72EH7EVht+3Hp/pIO01SH+7OxiKCmoaRf+l620Jgempg==@kvack.org
X-Gm-Message-State: AOJu0Yz4OAUUbea3mvRwzKU3AqTKqlbeaogQ+hhOsC4immkDNdCZopfZ
	NQ90gBWjjXoZm51V3XK5xOpJSz6HCGsX6tXhAyNf9zIWzqfV+Vp2smr6pOlR5QLTwho/d8cu+LD
	dCZLopLQ2DQo9hXw4mlUekbLBfw61zq+DfMWoh6QFQRNJfIxGKKRF
X-Gm-Gg: ATEYQzzsEVxkljh2M1QthGM4lfOrXPMOjBsluG1wKd32mnvXjibwARSwiKGIG7GofgQ
	fW3WDRJNKTqYMVtN1XP9s/RvUBjZCBaB2ZPWEIGD2vnTvSs1wme5lF+5+d+L+6zsdLmtHFMFcac
	XzVSWvAVzvDYovl9/voNxRWfe4EFp4tWIa1T1ILf7QdrGt5seTuVzGEMaRoEOzhpNksfHidkpUG
	zRtnWP9sLV0eUelId7uqYT7cOloDLtgfNWIX38//60bDcexqVYOfmxeQXQfvjR/Kj6tqkHUkgUA
	LMHnQSurZEPMlfh561u21AoSVvA/C83u/0VDPEkSZ90aBIyhuOuI5lW2M3WeZ/lX4xaMVa3zfAf
	HxoS7qtE2taMRw0Rvtw==
X-Received: by 2002:a17:903:32cb:b0:2b2:57f3:8d07 with SMTP id d9443c01a7336-2b257f39949mr54098045ad.7.1774950652636;
        Tue, 31 Mar 2026 02:50:52 -0700 (PDT)
X-Received: by 2002:a17:903:32cb:b0:2b2:57f3:8d07 with SMTP id d9443c01a7336-2b257f39949mr54097695ad.7.1774950652197;
        Tue, 31 Mar 2026 02:50:52 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277fb50sm103515325ad.56.2026.03.31.02.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:50:51 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:50:49 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] selftests/mm: respect build verbosity settings for
 32/64-bit targets
Message-ID: <acuY-biDCExbw3aR@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
 <20260330222932.a8c10bb3ea3e86581fcea8a0@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260330222932.a8c10bb3ea3e86581fcea8a0@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D-PiMFSUdkspFrnSsq5LEZMcoLDgBrTv-5Rn2Oe5p5c_1774950653
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8C960C000D
X-Stat-Signature: i4196s1jnj53nmsmxuuidkn3c6ycj3da
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774950655-787226
X-HE-Meta: U2FsdGVkX1/mvmICAzDiiZ9pFONQqd9WbQwi3mBQzTwvQmCI8mTlYIEoisxUaILc2GlqTcBeKEwGsPMdAWLmOUAjtGcVhI+G1GQSJTk5eVFhFGEZclE+f6OQqC8Cf8m6LSpxPlGaaCnNKfbx6Eu9wLcs86kr0+8A5fhNLYnIInjCusOW2Yeui0b4AzfrktTA2n6dRAb28SJMM1+7AOFZQ9Y7PUWX9GdJwuam6ntiK5V2J2QyNBga0AIoBf225tvI6aFTPYDOmNJt+F8YxhHdykIhx8dYwckDAtrG2B7RP2rF8Pti6YYtyWcf097xTJz/r5lC2oM/oXtqR0CUTy/a7p+mu20b231NRXZxEWNzPy0Uc0xQ2Ar1F7eMCTu0RpBIAsIAwSmSsfvkmVvO6uRqH4z1o7QBqy0WaX14PLen/pbvCdWM2jrBdyOIQbZ22SQF9LyGONMtR1Qd6MSWf1beMc34XooE9Gte98KZZZ2pUqanmFYhRNoWWyjWKx+bFo4uUjtn+8oCK94jIcgQNVH7CEIQqIX4MViO4o8TdyNogS2bQEKHo34lSOx3tF5FmjTXNd3EELQkm8gInG50IAPEEuyDPWbLdvnbZWI13r0VtvLNjB+DY/kyTlkwgjRdIIi9EhDC6QvzeR3LE/8JBrUJAq8V4C+epnl9tcmSwbkWyNxTXIOHaxWrteg09vQNqemDqyKwHO5+jfRYMV2s80CnwDZBKmwm4d4E9WOyF84YPeLH0/AKOcRN9GEn7L4Kwu0QTSGyQTGZcQoVPY7RZtMM2yqJ76oCioTUwHm33XdM8n66Js22wi3a5DTrvg4QzeeTiKMx9zVfV2c+6V0cz0HcFNukcw1q0xgxU3MKC+r3C/K5ydL1W4kg+cFLlYYH2xSy1YtcWKwLR3beFi2pvItAFmDoG1dyICDVeZnLe/ZbzllmH2hkGmMTD0qYZxTcG2JXUnDRNu98zlfnomrFykF
 cgp/WZHy
 TIEBMoEDNfzH1Tmuj8Q/z96QCJla4MLjsFN2CQ6/yoQb8EPp7bM8BopEwnFjh0OvuL9d/dMk0ueUJA37cX1GMQcypMUFybOGqjQ/6X0HjLeSPhV3Qum9r6T2rJKk/5MDClHDxlBJCuZKCY1g+vb+8PgWRaMJ/lWh1fZA3sjUCQA5PlbrxXNDBtldF7wkNjG50xW+xilXWjjcqviUZygc2o/KKEmULXvKvzfv9M6rt6VYR0Z3wXmh4po3DwDc5QNslnZsyzQoOYBwUsyN2+WFI9rBXF9wHiOtoBwV83xkCkA3QUUKU3jwCExXcsfpZy9jdpXVD9SS78Dcii4IduevPUohe19fyV+xgwx0SLM+4hq+6rz+jz2Xvad1zhPEt3kW2imFop5/Xe4YZjaZcjPxxiJJLE/v1AiNh5Rv+KhqDcxq+n5wb5qzWdGEfU0D9yorPVTGtfdrtxQM9ldPKsiZcQxO62kWN9vzHGKxw80K1Gwst61uXE/gv6nQc4qJO9KVbMoEveWSFECtsJd3MKZdEVMBJZueIs3EHEU4c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> 
> wow, thanks, do you want my credit card number?

Only if you want me to add a Funded-by: tag to the commit message. :)

> Tested-by: Andrew Morton <akpm@linux-foundation.org>

Thank you for testing!

-- 
Regards,
Li Wang


