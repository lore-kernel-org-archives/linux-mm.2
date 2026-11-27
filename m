Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF61606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bg/S1xKe
Received: by kanga.kvack.org (Postfix)
	id 3FDA06B05B0; Fri, 27 Nov 2026 00:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D57B6B05B1; Fri, 27 Nov 2026 00:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB5E6B05B2; Fri, 27 Nov 2026 00:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 090936B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:46:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 770131201E6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:46:57 +0000 (UTC)
X-FDA: 85479815274.09.B2E6134
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4409E180003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:46:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bg/S1xKe";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795758415;
	b=edDe+YLiJohADCDNnDHd/iralcCsIxWY7Z+Vkh/xUA88o9+yJDtcrQmsYwBiSfcsNqpEjO
	RR7EjT30Rb+IDAe0MYi4mJT3lgUrItyVWOfXIL/yj7boxwEezNlBMopi9uVVhYtPhb8X5l
	0EBNkh6ww1eJfeZ32znIa2VtDE92ONg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795758415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgr6yYu/bEkmWQcZMvll0LChD2e6ydySMbSI4Jx3qok=;
	b=fQGt1fHBkD3FR1ToXP8EVZBTgFJH2K7yOv3FDe4DJ5O7MS2KW+8swmBIiWiKbF2oQv3CL2
	zEVH/12P7z1ncud1zjmZ245y5qVBeVZncmfJhvqeZGVlErQQzix/4UsK0+LInR9hDRocas
	2yUYKEt2q5/sYLG3F8Nfn9XqEcZ0EYU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bg/S1xKe";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7vNbjUCz8mvZXTBuqZ+Jkr5tNyMEIFqA+f11SfeE4zk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795758412; v=1; x=1796363212;
 b=Bg/S1xKe1jMvgVhVbYFum6hCqVhy8Y6y0KxHCJNRmb1qlpwtu7xGUWxX+kQ5hhpkQatcMXVA
 u2LG4uUMPjk6CkJZLee69AS3GuwroL0ze32UAWvF7OhMhOlBw8m6BFFN6HfziBsxjEuXbUY8emS
 74dahaxFVzZp0hkOutl7tSXI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b8fa1ace7f61a211;
	Fri, 27 Nov 2026 05:46:51 +0000
X-Mizu-Trace-ID: b8fa1ace7f61a211
X-Migadu-Flow: FLOW_OUT
Message-ID: <0f466933-27d6-4d2d-99db-8cdb3cf2c78c@linux.dev>
Date: Fri, 27 Nov 2026 13:46:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/27] mm/damon/core: introduce
 DAMON_FILTER_TYPE_REPORT_MADE
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-13-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-13-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: rnbh3z9f4qxsgxrhmwfuyywe6k9f6sr6
X-Rspamd-Queue-Id: 4409E180003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795758415-740575
X-HE-Meta: U2FsdGVkX1+1GIgmOSiMVj28jF5ozEoVROtUAlqDTT7rP6ThR720k2ouqT/0sybe2xtKqHo5b4chCPMHVR4+cm9+z09MI8JWDNX0JpQ7KmaYOa5PPG7CQxDfA1I83p7XgXkRjG0n6UBOJl34YvHFWfNKWNIWBHd8cS6RDk791wV6QiqFU0NJ01c9VKEL1qVhoATbwSJ1/w3VYVQjnDimzJyduLB3MgVpAq7BWTu21FlwURVFrC2jwT9CBaG/ZyTUSJpyitW6RFJQXK29Uyf3GGnZ0dpvvtacIivaI+kuzWXvXw9aSCtRnXAl7u+blTeYGCpOSKo0ZenN9PKeK6jUwLOBblrlZiYtUKZ2PYJfcR8aO18h4ICsmZsjIfoZgkSbZfd6VSs979xlUUCFE8WLRYDkxN71OnswcChWwzpbXxvRsjyEUJmnkHtgMufQMW5CKmLL6pSKWybrSB7H79BS23B+KPPYbyJsnuFqiSy1f9GNsI37vJirrdAgrUtJECdukoYRtqKCJff+6yLEhfs6sURhO3+0BOKpuGoPozHUBStB4mwROucLKa2F1SEhxhKBh6QlLmUNBj8OERCLy+h56T1Fx75dEHQJYzMYJpxw0fGJ1GdnL1E7KykMaFh2GyBRXFyD7Ly2k8y5+XWsTobwVYoyPWgsa/ubJQRJBUrJf7VS/3nDHwZg8b8s8MSB9eHH6G/NIPaR80Q3Tl+50MY5I+KpXt6eYponQpCKebVb8cXNGuwdEGxLRfQrzbS7klYj9CXY/tKf1d01IPw3SfLYTzgbHsmNWj18bkeMDFLVAJY16mQ965PuKxksUUnZIONvjTgYSC84bSeK7YRtGuARyXm9C68nGq5rdHmk+ZkJs3ntnHtNKRPhT1+wgcSM/hFhtX25deNWROSiD5eJBQHiEKgjYC88CWJ98f8H6HvVrEWsX2c1D6S2QR1lqgIQeWnvbRZxLMn4/g58QxQrx6v
 ILZbHJLL
 8QaxwniUW6HXz4Qzm6XzCE+YKRuKDwbq7x0fQsNPgOzqM5ij2M9yDCgsGSUh9wdIwYp20bXkwHRAov3tDJqgaGuiDA2GIk/g3YVDHU8hRI2MagMQQmMOiuF3mtjjOFI37Plv3b3kn4Wch34KfyfPs5ny3HriKjw20BEIjIxK6uBRC62Uap1yZ+PtJ1LV0fr8tIn7amKNyDDES/Rjt8UaT/rjaInsHymCmkirxm0gy3HVZzwPYIW1llhFzib2oG4Ir4h66CziABqN1tB71QnHhUTYRkN0WTAgOHCEboOGty2+3fNMC+5pH2ObX6TpvhVB8EBUgqDrw4Zg57A/bhvrOW4NBkvVHL1MoAkuW1xHu5kn7AVH7PgYJ0ETT8PEZjwu5UkFy0ev25wHUx+CEUlxA5jUZCxPFuPKvGtNmfdiHyLtw6fFn6pMWifW9DU7F3HfLFAVBuOBM9ijZtFkugMRs+GItQdgwwJJpk/YepsueTBfR0PeqnzKJOpd15o3QbJKDapOBowBuuyX0zsdDZ1uKXEF8yTqLmLB9RQxXlyosjZZavzYwntAK/odQumKB7CFtQIAP4L78zzyEFK3Ojemy8fDcUyn+/t2EYnNzd06fBICr6M6GuiwjWmhBV6t35HjrKTzp8Qcj5o/djlkFWq5Kscwwwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Extend DAMON probe filter for the existence of data attribute reports
> for the probing memory.  Define a new filter type, REPORT_MADE, for the
> purpose.  Add a union argument for specifying the type of the reports
> for the filter.  Update the new argument for the new type when new
> filter parameters of the type are committed.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

