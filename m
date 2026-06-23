Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE7DCD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 04:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA6E6B0088; Tue, 23 Jun 2026 00:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54C16B008A; Tue, 23 Jun 2026 00:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF64E6B008C; Tue, 23 Jun 2026 00:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 997256B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:07:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E4E28D582
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:07:20 +0000 (UTC)
X-FDA: 84909842640.02.F2DFB4D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFD891C0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:07:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tmb5uj37;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782187638;
	b=luQwp2cEM12b8FrYYTKDktnEmckv85xq8V2kdvJaGnRxNBNE2GbzGX2gHqFw7hqjkVo3uC
	huRSHnDssQOmBZ4epU86ebVKRB2KGgZ0V+uNOUi+gyWpCSygBp8s1Vub5uv4mDzzT1kZcF
	f+CYCSJve4bnfxCmvom6kvbPZQ6jwdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782187638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1E/ptj+RS20Bidb80rfTzevjxywaQ+ft1dWMLD1tiK0=;
	b=hUyYRaxWJ9M5d6RHftzOhyA/8ginIomKd15QaCZejzjxPqDHENfGLVRfSx+AHY4JIrRFnT
	HNG5GwI0wIvYm6L2ZWOKbER1NdlMmnxrji8tltwVotCjbAxz6Wx25MuTR5vBNAz9YE7gB4
	0oLUtOFoXFArOuEd3h21UJPpw7Srsck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tmb5uj37;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB0321A25;
	Mon, 22 Jun 2026 21:07:11 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 407283F632;
	Mon, 22 Jun 2026 21:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782187636; bh=JO4KWmoFaB9If/+qfuYmnRSo/7s+sYdF2HGr25bcjkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tmb5uj37Jnvd6vKeYhLLgcykqbBv01QfvcC6AKXwkMa3t6PNmz2sqCk9qjtway2Mg
	 AlqvzvpjmpMW1HoSALdQ0X3yHrlX3xWJofj+AK8g1NZkC2Jr0fFNTUhPBobDaCgvOc
	 o3Rps+Cyf8UE25sl4t7tqlCEfHSZ+7htln8d9orU=
Message-ID: <711edc64-67a2-4927-be1f-b9529af39533@arm.com>
Date: Tue, 23 Jun 2026 09:37:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260622155913.280355-1-ljs@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nbj67ciux6run5sk31s77ku8g7sy33xo
X-Rspamd-Queue-Id: CFD891C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782187637-31516
X-HE-Meta: U2FsdGVkX1++ZRngSQB3LrhO7aCFbZGq+e1Xap66WdxJA26Aqzlv3CwRa+FX/JAqfTdidC2xKrSw9Z5dmjcRW0C9ioWpdMc7r3IkO6lsz+waagOxxTrAwwK8rU4XRl+JjfsZcNrBOfxJeFfXKI6NGMR+bR+moO7JE0/eLMAovJnbKLUD0bMWKWzi/a7DDpQwt9WYqP9G7kFYBlLK/WBPi2XD0fwQyLN2jNe2T3mN1of8pNyjEk5QeKFd48uw77sIyssfxPtJdNxN8lzp2RvhqFlS0be6W3vwsqzU6/qXUkjqeD0eQSb1RoWsW2e1nY24gTQlGUdm3d/jiAt9aOATK4k7g6dcnJX9NQ1GPPkEUeiKvMrBT7YK6H9ebJMyJ0rvprSFQYUwPCw1bEzJYKWW0c3+1za837eJZxdG9j1+lSIeM97I7Iv6ThN7D+Zc+66sUDd0/BFPcjrNdDbc0h9R9ldWLxLQR/1HB2B8iXXESkcJXrKxeZ4UTZB8ECarIONEJrkpsSAAbU/AC7Z148vBr13dYPP8B34TDwzdPyeVN78GkcYyhUFHrHdJ2LKtggJasXDYwd1nPlJpQJ4Kt/BFvfMqHcrxbl9JHfu5Q0jjv73hSK4nX8XIyenogvMA9heShA6PKQtcnMlGKyMfB1tpuP/VKk30Oqsm+Y497LFtliOrWgPa20IAVq6NFluZW3E3QBrCFGVyXMNbfWOjecG0FiBK2C9HAQXwuAKsidbs+fNGny17zMSAXZeHmeu+a2aWXm1WZewqy8hN7oMptIEdkkqJNmYCHd43DcCn152jYnJsSugKFgNpN4c0lfZdThId8tNNVZtp48/faTsCq/ypadJczbLLYSjQDIjLCo0RtFC52VBX5ahj5Va/dNsguOYVTRb6BWgELlmOCK+MFuKWhTIrikWpKyBBNgRQ8oDvkxOvCwfX/9IiyJ9ctuzaRYDMeI+hu6cIyQfi0T2coQn
 Lm+lvA7V
 3z3MdbZyxT6CmJ+kdXshMK+z0kAqyrVB5cBwsniwIuRlM5KkfdOLBLSA68r9TPg6CO64zGrISeMJCWCIhQkjyS7Z/HTRrQaPnvA6+FFuBUMUyetfpCuMyv9FC9uMWMUJWsb4Yxvk85m4YxjRFIvr5IMuFhH8hRbDzOpBz43huK0hF/qrrgKB2wdJx71IvUU5rrdF5ux4RYbIUjL4wQ97nFcqBQUmTeEpfp+Uf65KyJ0ZtvNrVwCKorI8U2g6CN11hB5+mapDqTrFDpq8l5sZRp9pLQg5dC1VYEhIhdeDfJ6bITg62kyFDKeeNQ1fd1AsMmZUtp++IISwM7DAUaXaqUNBkXOn5vUHZZpqYOrIGkWpYaK5xV7FpQJgHfXmKqHRHl5Tn0MA4yThgdRrQ8YocSWd4Sno2r6wrfZjx71EQV/psrdVz17ZxmEsJyNdVWC1Nu/Q+3y4EY1mrdGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/06/26 9:29 pm, Lorenzo Stoakes wrote:
> Lance has been doing excellent work reviewing rmap series and has proven
> himself to be a great member of the community in general, so add him as an
> rmap reviewer.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

True!

Acked-by: Dev Jain <dev.jain@arm.com>

>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65bd4328fe05..dd963b72c614 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17024,6 +17024,7 @@ R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Harry Yoo <harry@kernel.org>
>  R:	Jann Horn <jannh@google.com>
> +R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h


