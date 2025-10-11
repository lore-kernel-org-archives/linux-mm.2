Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A59B9CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 07:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEB38E0016; Sat, 11 Oct 2025 03:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86838E000E; Sat, 11 Oct 2025 03:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3328E0016; Sat, 11 Oct 2025 03:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB2978E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:53:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7215EC0594
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:53:01 +0000 (UTC)
X-FDA: 83985067362.21.FB63897
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6FBF8A0007
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 07:52:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s1GDIUYc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760169179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWvortduSgLOuSJJ/U0S60TCcSUgKMFRvqEyQv7retc=;
	b=ZDXx/kFiMgtghDXguuyMQirLXuCKbeRtrTYI5HWaSkLuMvJuVkkHJximQ3wEndLswlC/V/
	IfsEcL9RJ5S9V1Vu0LZ+hI3Sv2ykmyGJgqkXXCC5ZT7OJOIMyERIw7jkJ6CwePHwiIPIv5
	S7/lR80t/i/FLuM7aYkk8QM0gHZaOWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760169179; a=rsa-sha256;
	cv=none;
	b=JPaP/3hyxn4oBJIdEG4Qfz7erhGDIgl3FGCU4GSlebdfImzqCnwud3t2uyagqhn1R6zM3k
	WjjO6Bl1F5LBqDkxJ1MSfwhHIXkB4Dc8BfpZWbF3Parb6bmw+zOdQn/Ia+G2YTTTxWpKMj
	ye0U651xZxYFGO3KrRft3X4SACsyb9Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s1GDIUYc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCWJthDA5VngcKKlz+jbtHU4x/8Yjk03icSVR+xWk9Wn5Y1F+V7Je8yZnimZ6CTQyiFZ5EVDB8HK1Q==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760169177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWvortduSgLOuSJJ/U0S60TCcSUgKMFRvqEyQv7retc=;
	b=s1GDIUYcSJD025Z4DgPZ+gCEOY+1XKhKbk32XKpXBObCLdjOxf9Ocm1r7I5Hxensa+EcPm
	LJwjaHH9hsic7n6UbSsbELvXAQjFuxohdoiSnh4F+6twXNzOPA6WGIqzb1HxLu5SBtka2l
	YnduG0Jie8ura31TVT2cImq2wACrVGU=
X-Gm-Message-State: AOJu0YzO0Fw5P7q0D5PDuej2Yr5dE28nDBO/SkglEXI9iRsXfjsuuoYt
	XXH2FG+IufyPVl4XcBeMUp4AGFirkQezUbHBHUCUl3t3vyPJRujMpRjH9TKvze/NDKWyoHrEQP8
	lSNOQVsXoeS1vIHw10jqZNmcabY7u1bI=
X-Google-Smtp-Source: AGHT+IEL6m6ytVdwMmFOmFWKjL3kcfzvMyZdNcU/AX8xGP/3bnSV/FhnIWrS8KRjUUXicdKxpouZcuEji+pMNJPmlHg=
X-Received: by 2002:a05:6214:4004:b0:766:ab7c:3e89 with SMTP id
 6a1803df08f44-87b2efc373amr198459456d6.64.1760169173408; Sat, 11 Oct 2025
 00:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com> <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
In-Reply-To: <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sat, 11 Oct 2025 15:52:16 +0800
X-Gmail-Original-Message-ID: <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
X-Gm-Features: AS18NWDBvflbwRJ04Gw6IWuF9bLxakSMQiCM_NYehBhsrI7LnFT20xyrjWwbYmM
Message-ID: <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory failures
To: linmiaohe@huawei.com
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Longlong Xia <xialonglong@kylinos.cn>, Lance Yang <lance.yang@linux.dev>, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: u5585nba3pkcxn3yrwsjit1etpq7rgee
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FBF8A0007
X-HE-Tag: 1760169179-709395
X-HE-Meta: U2FsdGVkX1/BB3gvXmlU1le1NuyjKnjD2fKowiBxV3Czdp6tjiHGD0uzwt5EPKtHiNHZoU6ce6puLjJTBsHOnieWbcWNRqgmUc8ZD2UhkWNvfWvDe0/ZnJE+Y/qdAFmNObIrt2kg4LzVUTzBqHHJmGYaNS6y7BhxJFWtBpq3S5FFCN6bkLVAsqFWKHLPxui88cp1UaFjGaMQzwTIR1cHtWDpqdcebGh+1MFIaFtKDC2BQGweDIT3BkSQHU0891TwzhL1TUOJntWSdz1wmStq62oLp213+soV8VIFur6jCf1yMmGXUl8NEulX9hCe/tzLLC6xTcdWeEkXrwBBhM+L3GQ1AF36Nw0eHOHU81xnllXE5SwtH8OgmB3YWCWKQ8752uE2ByyCD1DiJGOWaTPqdyBFU1QXNTDw0g40Qy3hlRRa7p8VbF9UNaaQwLA/kn9G+J2qG/4+GW9l/WxZ4kfrg12ZSjq4qUTdWQspIzwIKRhcXlba2zM0Q+Ch+bscZoDTK7DMMBYu6jXQb2L7MwiaxgVxkdswCf2U9gmaSgPj/LL1tmhTb1k2+ZT545VYKUTfqSGPWrIBbrsQeuD8OJYilE7wBFoFUUj07cUsgwzYtv2LtGUdRAoO33A1vRzUe4zDSTnMSi6s3rpJ3MQnEIAua0313tk0oNhIprOj7up0HqlMrB+Y3TG83fGce+yQ7P3DpdiVOAQB2zhtV7X/WHrsPgKDvg4I1hmpT2ouVtKBmEX8upHsTDsijVyH1riAJbtTJ8GasEtW0/yQkyZpbEcTodtHeR+jkG14cZU7m32ikwsHzTb6+oLXd4L5SMYyq6IZhHgOUoJudBkt/XnDazoeUhjcFIC0mxY6aWeGICD5yJ9KZLn4XdDXFJm4xk8MgttS8JGblpu8kun5zGLTIbM4Q+Fxg7ruGopojpvB48xspCdOCdriY2NaUj+WIOpJc5N5iVv3P1cSwJZMJJXakoG
 tW9SvMyB
 BIMSiJM/yCKWE612mBeMFEYw+jrtWU8FKNXQW0E/t/2tWwedWDNCnerS0DMUiSow87phwS/zjXykvu2VMYXW7aUfpQQvQuxqcJ1Epj8Gfs9/VVuPV8wKtjhZVysTSug1g6kDUJ7Khfps9zBGsirsGAvxhMZ3jlgZ9fHERCOokGFU5orXZUP85ZpvdjsI41bdOFRaczgwWCrf3f8PyREFkxJKNKfQDP7gtHxvgUVwjsglV+PE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

@Miaohe

I'd like to raise a concern about a potential hardware failure :)

My tests show that if the shared zeropage (or huge zeropage) gets marked
with HWpoison, the kernel continues to install it for new mappings.
Surprisingly, it does not kill the accessing process ...

The concern is, once the page is no longer zero-filled due to the hardware
failure, what will happen? Would this lead to silent data corruption for
applications that expect to read zeros?

Thanks,
Lance

