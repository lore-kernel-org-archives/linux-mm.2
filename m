Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823F5C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7256B0098; Mon, 31 Aug 2026 10:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631F26B009B; Mon, 31 Aug 2026 10:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBE66B00A3; Mon, 31 Aug 2026 10:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 220F36B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:30:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93D64C0152
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:30:49 +0000 (UTC)
X-FDA: 85161801018.08.CE47AEE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A7EFB2000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:30:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=aX0qCXYR;
	spf=pass (imf31.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.172 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186647;
	b=hjFRf1F5a84p9mEaoFtW1NcPTHwZePFQkG9MTRxs3CbotFuJrEFWWebkc7j+Ygn9pyPxb6
	U4iKahGBe4Ee833gjTq7DN1o6voqcnHqw6KNM7KRtQ5k1xCS3qGkJ7KpFYQIujNI0vDt5z
	5ofFoAnm/tUuqkVbZj3SVZURyGlubl4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=aX0qCXYR;
	spf=pass (imf31.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.172 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxM2GgazObY4pny7CjicJsoYJzAciykbqLiuPBKukrM=;
	b=vo+YmQMHHUI2ByNSZMVXs6xfRu6UsBWouVZ7nztD1s2C63kP8QwM8NbHKnIQMB7YmIAEin
	Yut6Dh38gyIUFWog/iSQV7YSvblWV03Ru2l/lgjZzbTyOBhbRIt24H24g74trE2UFNrb6g
	e85eXgNUcr24UUdmw0fsrRB18Af5mBQ=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5276d598b96so27565161cf.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1788186647; x=1788791447; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fxM2GgazObY4pny7CjicJsoYJzAciykbqLiuPBKukrM=;
        b=aX0qCXYRqgXLgHfJxZcjZUkS/rHhCjVLLb4htJgmP12qItkUM1YnwuH2PPhXtwdX6+
         Rt0jrbHmuYG4SbO9V3JS87GW+qscmKATQzRTNOZ7oWl5UyJ9Wp9YWnXhbq0Oev5UZGOW
         45LlYE74H0IiN5VfC861jnnzbi7suxlGI0N2s4457mlmnjXmsVgOSJjCvIyjSI9R0rvA
         3z3MUVwx74nvF7RYQ3fi2mZR9okNGf7N8QBSJpg7zsUy9uIKC3rFBjm8iAoDB+FIDTXd
         s8ZSMjcXyrxmzdtQXXiIrJ3WYgW23Q6D7IeyZb6cth+X/rwGYg8IElwf5HsFS3HK2e+z
         DyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788186647; x=1788791447;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fxM2GgazObY4pny7CjicJsoYJzAciykbqLiuPBKukrM=;
        b=YvPQxw6zXhcGrLauBs+tQUzBlAEeoPIh+oPxrwcMnknee/qeGYMrOMP+95ttjrWmvw
         C4JH7WmceMEQDqrz3jYbPX+YpbwtHqXtwrCdwgbXPKDrRxJHWuXBh6L5oQzvsWcP20fs
         ejrPixUKsN4kIp4gogNxGFN7V46x1e6/R1I72xVwysIYbEoUXob3/dGiROK/lUfguwNH
         3vWiBE19AX+CVsi+ASFLZh4Nsl+Ib6pTOjv6ITFOUy0HSRsJAnGRciyLBZGSN6eaqssp
         s6Mnz9Kfio/8MUJbMB2foh7cHl6A0SsN/wDeHte4Cr4udKqvuivYN9ZiqIiiSbKO0w4a
         K6zQ==
X-Forwarded-Encrypted: i=1; AHgh+RpGY5mXdGL782v0XKhf2D+H6NzNAxZfLDIsyPu92zoCrzygZGgVce7Rk09voWxWW3It4ETf/KwqKA==@kvack.org
X-Gm-Message-State: AFuF++kl8VSJLxik/Bfne1z6FkQXnvB/TCWMQV76hAmqklA5Nfix71TW
	etoO/Dya6BXpIgnKNeOMgbexCmm/ujJsCE8jZnv0mBsgF5atkjgY97ok3LBXV7m1MQ==
X-Gm-Gg: AR+sD10AOqDP0H80PYQ28Px98sXXH0dl+2K0w2VKeDnUHLtiVRhn1aRPZ2RhkG9Uyzx
	KKeb4yoqmJxaf/UCemkAXTFk8QbJ1jeYl7J4x04n+VmgvJvWvgvhPw8NHINphgofl8ceQAv19bk
	yMFUpz2OAQaMaqf4HxDIYKvi87b0BCeyPK1eOHFJz8rXUGEg+GmscgUUPThBYOAMJyQyarFdJ74
	kmc/N68XQ8+QtWD4aXR//PQhY/8tvwbjSamOqLfH9RsoJ/36IqY+fkd0XVIMBwgBc6lpPzbMbAL
	jS+mcr3s+sclJ7Ev7SDlXktEK1F5ywGtsHfx1Lz6Mjt93no6MWTpZKgUH6A/GrmvvicROi2bHgo
	/LYUnOIQ1L496AY0A8L+ZjbRa/dbibR4BCpocr6ngrbHugA2K9TbvI/2/6GjgyeLv4e+wnTLL00
	RKBZBPso+XikC59NTMkSPIERDBv43adhsDQQi/j+pCJr3mYRDwYyq5WRYpzX9J6CLAApOAbv7al
	J7p21a/yXmChOGYJQ==
X-Received: by 2002:a05:622a:2598:b0:51c:1532:ae93 with SMTP id d75a77b69052e-53021cb99c7mr18496681cf.26.1788186646408;
        Mon, 31 Aug 2026 07:30:46 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4515130sm85355856d6.39.2026.08.31.07.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 07:30:45 -0700 (PDT)
Date: Mon, 31 Aug 2026 10:30:43 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Oliver Neukum <oneukum@suse.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Chas Williams <3chas3@gmail.com>,
	Duncan Sands <duncan.sands@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johan Hovold <johan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	accessrunner-general@lists.sourceforge.net,
	linux-atm-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] USB: usbfs: replace __get_free_page() with kmalloc()
Message-ID: <8cbe558e-7f53-4ce4-be8e-52fdba9105d4@rowland.harvard.edu>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <20260830-usb-v1-1-aa349c302246@kernel.org>
 <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea165ff8-cda2-4fed-9354-1d14ac2d87ca@suse.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7EFB2000A
X-Stat-Signature: 7d1bakk9wit589nxheg9rtrnmdxczns6
X-Rspam-User: 
X-HE-Tag: 1788186647-463580
X-HE-Meta: U2FsdGVkX18k/07P7eUcrqwuQOOWSuOr6G99byrEttaMK125u49uUfgQ0RQgTghngkAvVPwxLmMj6TXGsG5qmYe0/QQPh4PEzaoPPwagoiUiS2Lfvj1inqCx9AQG5ClmHGu7CpGH+u+AhyWlTKUBx2iH/KS155lZypZimUcN0CZJBKBL219WRs4vBTP3/ga1SWhZCJ4MOf4Emv9MBnbLwOvXGwCQdGNabNcBloUXUBN6x7nVI/hqQ62DEkp/RG2SqhX4PAJJxltClYJQEx6bFTX8vWLDsRepB6NwnbNvGRj2V2/kF/Xn+5OWj7OTYOB6hxuvXzAVfr56c11pNz2SnaF9jmT9EAAtmxVy6PPfSWOXup0k5L149sSZK0SvVvG2yVNvw9H1ojuHj04WISnmojUdPhQ6jcLltzbWM9Xxs51z+lDdV27e18h3b02rsVUEcfrtKNpy5D5Aks9uPOiV5sVcAsH6mr+PpvHP015F7f2dcTLHzfdFNx4y2PPEzRHLsAeWWd33bIXtWLfEUSpV65xbgX/r5aVcf3dSscyvmYzkWRAi+JFICuLet/3YVN0hkTjK9KaJO6im4YKSNVTP+wbLoWjnbx+Zf0Ura2UieStfI+1jFmFyD8HrFA2hU+rBZXV/iG3eJ8X86NtSoPnd0BoTZeAYmsffn+Hn8ln410c6zcmg7r0ybcoPhO3S8zwdzximOrX3Lx3jIhtK6BZZCsp8/fB4KXv1v2IMCYgK3AHj/rd1ezy6Pjucm7qZSeM7MTD/kbkwG16aSRSKyHv3U+sEBPEkygQD8Fn0UuJPN/vZi312PTqesE6gXVzTr0okb+v/y23uqecMtE1QZwTfmsGf6uViQcR88YBx1Nye9QsXWIoFQTY/Oyo7c6Ny6Av3H/PEpsQYR3B5HcbWJRmRF57kjYwuf8ux91SnGBxJXubhZJ4U82+KIpwgaKaD2o/fUu7vu6sjY3xe9/awzRp
 4i4AN/aO
 Qf8CRJxlPEwc+BxCmEIHzQO9jM/LpLqL8+bc0Lr/TxQNg5r70FOXt2u0Lqkdiq1SvvEw7i0DkzOx2XtLnvNuTD3hd1BtZ03MJCBO6E8xGTQlB8Ybapn1U0W4qSDp3u+SSMXvnO8bZjj26CTd5kS6bUEvJr8ZdN8iMxxxnrqD52WWVDcfYQOs6ngMdSWcF6m9QRWfirWl+cF1WT2L8RmPd19jSpAse72TDaiqedMq8G3IHz0/qi4A6i1bPJX+zktnCT3S3Ghd7uy91hTK/lM9QErdMgmkY21azu70I40bwj5WwuwjBzGD8U7ok6Cc/VjNAzq/UaUW7lBrr2YZTbrnNHazBNiIxrhFSDC7f7n2sYwk1sHch6/RV1gjQYlhjWDoRFfef503O+oT8+heup75bc9ZVkFPaUH4vrddjtXQS0Sg3I314XawdZxvN7qa4TtaJsu4KtI4hZf7wVeFu3UvfmWiLFp8Aki8HKuxiBGjz5UvrPAkr5YMs5AFNyB+wMMRVQ4wKsdmyHpVAxGnmqeCklt6QdEA+UsPhKfDX3NJomnlkepY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:27:07PM +0200, Oliver Neukum wrote:
> On 30.08.26 10:10, Mike Rapoport (Microsoft) wrote:
> > do_proc_control() allocates a temporary buffer for the data stage of a
> > control transfer issued from userspace.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> 
> You are breaking the calculation. A page has a size of exactly
> PAGE_SIZE. A kmalloced object of PAGE_SIZE is larger. That is
> a bad idea.

By "the calculation", are you referring to the 
usbfs_increase_memory_usage() call in do_proc_control()?

The overhead in kmalloc allocations doesn't really matter for this 
purpose -- it can be considered a rounding error.  Besides, we don't 
know how big the overhead is, so we can't account for it.  You can see 
that in the same call, we don't try to account for the overhead involved 
in usb_alloc_urb() or kmalloc_obj() either.

I'd say there's nothing wrong with this patch.

Alan Stern

