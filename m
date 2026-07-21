Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C36AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472186B008A; Tue, 21 Jul 2026 07:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A066B008C; Tue, 21 Jul 2026 07:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360426B0092; Tue, 21 Jul 2026 07:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04FE56B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:47:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F4EAC0107
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:47:37 +0000 (UTC)
X-FDA: 85012608954.29.8605FC9
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6B8CB1C0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:47:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="dOHR/BBN";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784634455;
	b=Gotp/1twRVtndXJSkIjYrosKatknJg9/hjrC8JVW+78i8GHWVKxq4DI5556SdQkKFpmBnx
	zj8RelvCnfrvGDRqgnGf9DBuh6bFGhsaIU848nwQMxm1yr9vMD1NM6wwykAy/Ln0Ec4j7l
	Yz5Ca1BW1hIKl9DidFKf7laLeh6Graw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="dOHR/BBN";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784634455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoIW5uJnX3Jm2AAYIiYFvjSsneOztfm3z4wi+PXAoGw=;
	b=AShiwICDCV9DC4xfBk+veL8AturN25lsV4yGUGmj9akEG57OCk6uc4LEtXIadXZ3zQc/54
	8/ATyN1bOI0I2sZMWbWkYM7bkEiaOzM6kAG1WzKBDe1Eu8zycDwZtczcyp1vZpWLZCQVWO
	1Ecb3Ar40E5DNSTaIGVzlA5Xit3kFao=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8f23e851626so119581456d6.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784634454; x=1785239254; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YoIW5uJnX3Jm2AAYIiYFvjSsneOztfm3z4wi+PXAoGw=;
        b=dOHR/BBNbb0m9K5H/9BSXc5hg4DWyyi0/rY/S8/dWmJBg9/NTOk7imqmkjW8A60MY8
         yiPRp4OqrOndhPt5gw6aFjVWJhTPG8FH7yGaCLbokFKdwZftds7CbWtmKYtdzFgPgxFL
         AQhSzDs0PW44HQNgzjyeHwFLZ8d1PSQ5tXxBMQ4Xq2cw8sj4ACfuZWjLjhK3YezgT8Or
         bKRnqAXckD7BNYnaiBJ2KwjFuxqK3YFPUJxwn7e8U2dZ5tI6NRN8aFthSp5ESx4Ko+u3
         pZFGpGlvgDo7vAtu3fvDFfRBWjwEBJyTEqpuru4Mf6KkGreX2FM+KF6/KRgpiwduBJfS
         8IMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784634454; x=1785239254;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YoIW5uJnX3Jm2AAYIiYFvjSsneOztfm3z4wi+PXAoGw=;
        b=M16MeOdsgEw0vTJjZFOUHlhXQ29l5tWqXyeWdpL2vlJyCIkWwE5aC3XeXYATe3GtVE
         7LyM9wHwiPB7rdJFf9Js8y6oMxg1Oyz+onbIjFEs1A9tUWj7tpGlCGKAIMH7H/umlvm9
         8wgUvlVtwSjM/E9xw4+J2AwJZGeayMXzy0VPVmhZ5pSoi3j4BDhh71qigBqizpwCFqPx
         h5CWGbzsX2iyPYaiLJlYPzY9ncqYJoUprftP22aZE0kJotfVW7xUyabJ23GJswRYjuKY
         uDoesIHSabz0iQysU9YDNk2wa3aKnEcg0MyhU8GCG8JVnoG/h0xwzIuE+pPiZX9Z6mGP
         lMqQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYAyY2ph7H0YNlJjeRJmmZ5PZV9MjX6EYeQtl0S6i0AuK1La/VeUXcxk8HyLyY6WHCekbYKmhiBw==@kvack.org
X-Gm-Message-State: AOJu0Yy1rQjK2WU1d5bl2Lx4RlU7pajb4VKlx/pUedfsOYMZOdI7ka5J
	PEcF+qAuusPJm/vt8IWtGvFXC9czhRqjPapfGuJpD8vnN//NVvtihD+by8zxXXm1oHo=
X-Gm-Gg: AR+sD10y6cT12nWl5E8mecAHU2YSZZYgmFZe0fYsx30UY13s4GC3dpHEZXrrY7fe3ZI
	Rg+QLMpwTUUVZv+8dTWL+X3jRdPnEyk2oxJP6qR8oS6Kl5YAWdsOFK7u/LdKhYcwaLwFUXYwlew
	wnCH7Nl7/DOchqZu9PqKmR7bi1nOu1R9EGa3oIZpbNNX+IfPxULXRICar58sj3qRbHY9deM2djy
	+eCmgnrBnzYmhyCikqxNgkw1dU4xbRORbUa+o1ICWqYPpeLDAO3ICyHTV77iF3FSk0DMu+IGVoy
	97uyGl2vmDTcBe+GpklAm0g+0zRFbvEcA7ukqSn4ccqyCQxMHJSNPzpDF+x24XjVz2f+6Z7NaE/
	YyeZyES+9TSl4ZLIwtIM20gCkCk+Q1sdyfZH0F7zskBSPY5XJv+08j6CO/ql6m9RP77LwfDMvvv
	FJ
X-Received: by 2002:a05:6214:3a8c:b0:907:7635:44c with SMTP id 6a1803df08f44-9077850a1demr207255106d6.63.1784634454505;
        Tue, 21 Jul 2026 04:47:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9077853f481sm118204966d6.2.2026.07.21.04.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 04:47:33 -0700 (PDT)
Date: Tue, 21 Jul 2026 07:47:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios
 directly
Message-ID: <al9cUqWH-72HUAG_@cmpxchg.org>
References: <20260718093723.153324-1-alex@ghiti.fr>
 <20260718093723.153324-2-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718093723.153324-2-alex@ghiti.fr>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B8CB1C0004
X-Stat-Signature: 6ugtgmuer5rugdijs5ceojbyqz6nuazm
X-Rspam-User: 
X-HE-Tag: 1784634455-39370
X-HE-Meta: U2FsdGVkX1+DiYoPK3vBHRjwyC5OOSp6a4HEmo18Ov1ELZDeO54n9S6FlMQo4i98oMEPmFYjNjN0qIA9HSCCzCiRr5c7ManrGhbRHqLw+zGI4HmHBpkcfe+KM2pypB0S1HONhT8Mz+vMePUWB67IrecRot+RIeqvU9Lxq4+xjYjNremARwVty9LxtCsnB2c3BUeaA8fRxaMnxcmbF7cm20pDffPEV/rEcCNmhGcDMlindTcWx50s/0s52MpN0AYaLnC9mYZafGoGMKxA951UhDjY/N89d2kyqLUzyGY7rLaZukJEzuI1umu+mt+QG5O59aiGk4j2aG1KpboTUsPc71m0sKR+1cF5UHijYudqhsQSRDR8HZJMKORb+8yneQ34ehR6JLZ5g/NcYKcY/HZkGjPIfnU/iCkru6ftGlnXaX+YUX4HN75HhVMXkrvSBUXSUdPsiGHBKrj6+XMKASpWJ3JAQqf4NFF4YRNkVofaP77aPPnRZdoIVyVHi3QflSvnoX+JI3uuW3mv25SSk5sEdfOnOOovX6GS63I53DdMw3+W8Gr6ggqtxJ8AyEO4L4O4K/uGZxbMlnCjyhX5kzOtPAEc2Sddlom63Ho2TjdUhOqzwO80PIRooMnz3KvW6dk3xHWIYAsKSER5q2BkOtN1SaHEurBtT3Y/xvgVAEWqCxOTcBIRfE0lWXK/Nkbq+My6HzuGCOZLyQwA870GlCtQsDqO6QiorL/cdVIZaUinG2wOalPSl5To97qqAKiIZ5zdAMrcd4RDMWHalLGn8lgZiutf2m+nE66dj0l7qtqdUPjy7AGB7TUuqQRhfOfV64CGRT7iGLjf5XNqrJAn2pJI9iOYBqK6v21R3iOKvShxw9YMhsE3V4Lo1KrezXsNyDs1K+fe8aQHv3VM63Xq3lVROmYF1aEFZyKaBEdTVpgnHtY7jAVcfZXCXynUnsDXKW6OYcsvEEtOKICRqywNxCJ
 0O+Xjf1a
 Al9cAnAS+dX9UUwuuClOmBpNzLBqxBrHxSYya7ekhAX+6TYfL+ElZguy9jKWIOMIVRwbW0VhLrGSlSVLhL2S92TGQMw7+cTa1T9xMWvNuNn3Trop5GqMP5LTfQu4mL4Ij19fBsO7KvWdPYig7yfMSIQzOT149B1QBOwQVrP4kcxWkQx8uREcII8o6DxKLXGNSgbfUlrTNw3F2jhAnk1Ge0u2edx+nR9lvz8CWySozT3mHN17ppNjCyf3RCHvkt3+zNSLpwoovbr6SLCEp67cIajPjbP0b2q5Odbpil+PqpN2Bh8DEuHaZm8xNO2zW4burHbg0aWLeNflO4o3r7/yYjM+q3UsqCu/7Amw8MAJuG8nseck+ZoeMY9BFDWSvn1Y+4KqMhz/1VVlvxzgaTw4f9IsSbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 11:36:39AM +0200, Alexandre Ghiti wrote:
> @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  /*********************************
>  * writeback code
>  **********************************/
> +static void zswap_writeback_free_folio(struct folio *folio)
> +{
> +	folio_lock(folio);
> +
> +	/* The folio was allocated off the LRU and nothing re-adds it here. */
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> +
> +	/*
> +	 * Gate remove_mapping() on folio_test_swapcache(): a racing swapin may
> +	 * have freed the swap slot (folio_free_swap()) and dropped the folio from
> +	 * the cache, and remove_mapping() must not run on a non-swapcache folio
> +	 * (it would trip __remove_mapping()'s mapping == folio_mapping() check).
> +	 */
> +	if (folio_test_swapcache(folio) &&
> +	    remove_mapping(swap_address_space(folio->swap), folio))
> +		goto out;
> +
> +	/* Raced: the folio is now owned by the swapin; put it back on the LRU. */
> +	folio_add_lru(folio);
> +out:
> +	folio_unlock(folio);
> +	folio_put(folio);
> +}

Is this actually zswap-specific or should it be just swap code?

Both this function and the dropbehind queue in the next patch seem
like they could be reused if we wanted to make the generic swapout
path do dropbehind as well.

It looks odd in the next patch to have a generic swapcache &&
dropbehind check and then call zswap code.

