Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82584CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3A28E0003; Wed,  3 Sep 2025 07:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93738E0001; Wed,  3 Sep 2025 07:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82118E0003; Wed,  3 Sep 2025 07:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 911738E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:48:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43D7313B270
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:48:49 +0000 (UTC)
X-FDA: 83847767178.13.5AD887F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8BA25180014
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:48:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVg3aRqT;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756900126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fskFHFKy8pWtY68FDaB3pDM0GOCCbDHm7LYaE+YR5M=;
	b=vTHQHwBgMd+oQqrygKdF4Nr9xgsesADvDaevrienba3jX6rCoGy74peDqGfiwul9gPT+Bb
	Vl6KtZsHVay6w7fBYI7s78zujYoRB8ugIVsup2673yNdu1yD0Lcmg0Qq1a9btWXNu0iGx9
	3bGB/SnsU1JUTyMn+aA2iBJyayej1wg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756900126; a=rsa-sha256;
	cv=none;
	b=pPLw2nayLZTDe1D6YCAc7xndRaQs4umosMExJdl/tmTq9lAFmj4HAkVH6T6KUTJfdCXWUs
	sfnPsPEHB/Oakup0qU1e0h0AmQRtkRpTQdYL3MUEfznQLyQvX7aTGmcDLRwmLAwe1hE/eQ
	+1cpfhtO4epUSvflHMrF8axYBvlCN10=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVg3aRqT;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756900125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9fskFHFKy8pWtY68FDaB3pDM0GOCCbDHm7LYaE+YR5M=;
	b=aVg3aRqTr9gU/RjGMgbgHd/YyToUh3rcxzq55ThQkeP9+8umRbpyg85VVT9mh6jxAgXBTi
	T+kUZJ6ArzbKni4qbVgS222pS9KRUGuANJXtNepmjkMWYRuqvHog35pKT8Y4Q6vMtxbuFH
	M9p3unhzY+DsnXDZ5EuPa9jrNVrDtpw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-UGeL0OkhM4KdRdR4OBxdjw-1; Wed, 03 Sep 2025 07:48:44 -0400
X-MC-Unique: UGeL0OkhM4KdRdR4OBxdjw-1
X-Mimecast-MFC-AGG-ID: UGeL0OkhM4KdRdR4OBxdjw_1756900123
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b9c1b756cso7357435e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756900123; x=1757504923;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fskFHFKy8pWtY68FDaB3pDM0GOCCbDHm7LYaE+YR5M=;
        b=aiTyOwAefvNiPyVbtfsZOqcZLNqUK2wkCkUzdohVREKJen2D0yN8mT+5URHMTsmcez
         CUKaAL9h8FkBDxs5vmza0tHSdUkSPlmYT+YDcDWfX5Hq/5LwJhgPt/V55D+AVBSFMibm
         Uf+Fe0JCCqSzuPMI9nIFUCJ9OD3W7Bz+9BXvT7VXrzrU8QoIeR7HH68K9jtpaYyHDm0p
         umNQqlM8mz05pte/ejojEf2Oos8Si8WWHFttPAj7eksoBF/OPsnh/I1L7S+OsC0po4hP
         GffCBr/eUfzunITjU2AUohmJInFPs73bpeErTm1KcHXQJs8FftSkytXmkCFn7SCz7iZ4
         gjKw==
X-Forwarded-Encrypted: i=1; AJvYcCUX8vhDZqykDsC0r+jz/hua7Z63HF0Bmts4woAerhPRMuRjTvS8MS2nmbvsUcRmLHjgXWXcNNy2Iw==@kvack.org
X-Gm-Message-State: AOJu0Yy/3ZO4nUdpB7wdH2A+l8imq7nY8k/O9rKq76NM/r5M/0VkBZgu
	gi5o/vEkrFsg3bnTactFpacSn/mUt32wTB1BXtp4KyJ0uJPRMsrxPkglHuS0wgB6tsBo/syRy9G
	nzmEQeAwj5B50eYzAwPgJYv5OhQGd5izma2xOH3ylViUF+1W1mx+g1oMKm/CX
X-Gm-Gg: ASbGnct9IRlo2HHnGt8mf3GQ91E/zTzPs2CsPo4Zv+pPbl3UJ7DF8abkV5dtdNAg9el
	Tt/GntjxvQ8h72B9huONlxQrxmGOtVCgCDOBm1PMlsfff4ne2UY6gE8qwvH7XtG5GAsyy67RJaw
	S43J7HA75A07wpwZYVIkyLhiuO/dvk1y3NLb85uKvHJBhdnLLvu7xHdbr04SABcJpWIiIqrhA60
	siKttM8MPJESDvi38M1QTxnC+qfpcfj9rThhx/E29bMWRWASV6mzo7Ltv88NbYqCEIjP1LmJd7f
	qKD0JGVCc5qG1J+e+mIditY7Ys5TA98m1+nZvPqUx8L634dVMmjm/6dJnL0DCebr4MX1A+C7wbd
	d3LtFQCN9TQAixHLk0STadT4ApfVe/8T/TP8UHVnz7uoFHL8kQeodfsBHOV00p3/vSL8=
X-Received: by 2002:a05:600c:46c8:b0:45b:80ab:3359 with SMTP id 5b1f17b1804b1-45b8549c269mr122551575e9.0.1756900123465;
        Wed, 03 Sep 2025 04:48:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu6+SjXHIDgMWn6JMwXuHWuutLrnUaZBJPg9aph34ZLiYPxnSzFrJmXI+54wBD6epzcXeeEw==
X-Received: by 2002:a05:600c:46c8:b0:45b:80ab:3359 with SMTP id 5b1f17b1804b1-45b8549c269mr122551435e9.0.1756900123019;
        Wed, 03 Sep 2025 04:48:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm52093845e9.16.2025.09.03.04.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:48:42 -0700 (PDT)
Message-ID: <e130c95a-103c-40ba-95d9-2da4303ed2fd@redhat.com>
Date: Wed, 3 Sep 2025 13:48:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm: pass number of pages to
 __folio_start_writeback()
To: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 brauner@kernel.org
Cc: willy@infradead.org, jack@suse.cz, hch@infradead.org, djwong@kernel.org,
 jlayton@kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-2-joannelkoong@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829233942.3607248-2-joannelkoong@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OooWUfSUmIiM89bGR7YKxIP4uB07vntgt1buMCBMW2c_1756900123
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BA25180014
X-Stat-Signature: qp4pg8ikbd17ane7jjyzqmdwthh4qzo6
X-Rspam-User: 
X-HE-Tag: 1756900126-866235
X-HE-Meta: U2FsdGVkX19BXa37abCAZSi3pGTqnt70OuexLjQY3Dx30p0Mi8SB0R9KNmYjeuy94uTJ9qaBQaRxy02dmAqx4oatv5P3fpBC5+NLFn4t4S7lZg0mzts4bAmrfmI/sA3+rwmBmc3Ge8eOsorH2ZsLWWxRDJCO3PdxZUiy8iFpQT66FkDVY+vVffD57XsK3GeRcH0c+keDBgj8Skdv3gQf/A30FAlHGdsckhmI02kJXAa+OySMlCPNWQHl3Y/fGhVA4gxfI1UW8eqAW8oyJ/3yUqCz5QNlaoPM96Q8km+AeApYNXLv88ChBvjJ7UHWmfEusXsyxh7H+/UWw3zDNAPMEQSwR6UEYimHwqKG6J+YdEPuFvWOPk1Ep89IT2fWbVb4QUgGAN/aQRPbgTS2i2RUArV+iDegvurE042siIxRCTYfqiPY9m9FRTfZ78z/t/6S+YBnrvfsdcuVCJYAjdwmdtKe9FkHODc7nh77ezYNco/2FogwNCXmUkjf/Y956YQMqGvp14oOEsMvNKGHOHzB9EMd4jwqb3hL9SSLlKWQg6t4CNrl090fZet1DMGmbEXosGr6U8lsOc/9bnyMUww4WdB/jerdWvXxeQCFdqu2bcJFCGi0hEfhjl9dlbZFj+qH2pipTKsa5ygM+CHYhLgodApgzEPw7ILRsmj5eVtWY+5Xhi9zQhVD/vsWEIeC58e2ReGgL/Q9A5J/Nb27KSuMCf6ss0DrO/8VNa3mo5Om1fZOClIXhEciERRU0gU9he0viCXSx4vZ8kFXpaLyLblQTqtAbtG8tSDQvq9tOFKTV+0pYYwYyVLw4sKz7wtzSVRbWlz4DMXYQkO5aExTYlo9Rj07m/o7/l6Wm6TvYAXh3HAW+Wq4svYNVrPZtnEIY0a5RTN5cHfqnD1djw87eyYx+86OrSctsatDpzJjqHW8GR0vfjHwSpNhd7Y7Haz/Nfnvo57PKQyVAXwzybgrW1I
 asrPb+On
 tvicQyv6i8lbWANaAFkQ+Gf1EGqerFUW94EUpReDEWHEuGfWtcu4EPd2NHabzS9AIFFBhBHljP8aXhspx6371BLIKEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.08.25 01:39, Joanne Koong wrote:
> Add an additional arg to __folio_start_writeback() that takes in the
> number of pages to write back.

Usually we pass something like page+nr_pages so we know the actual 
range. I assume here this is not required, because we only care about 
using the #pages for accounting purposes, right?

-- 
Cheers

David / dhildenb


