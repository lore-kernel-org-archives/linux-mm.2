Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA53CFD372
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 02:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AB16B0032; Mon, 24 Nov 2025 21:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B486B008A; Mon, 24 Nov 2025 21:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A386B0032; Mon, 24 Nov 2025 21:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAC306B007B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:20:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BE6DBA901
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:20:53 +0000 (UTC)
X-FDA: 84147526386.05.BA33C25
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id 734B818000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:20:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hLuuwsW1;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764037251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shOPXkiAy+c6gaLyf7tLpirEDVlJR4ursOWE364FB9s=;
	b=arpgwI+mJGNY+ecrx8+IaUheYFNY+gSAwWZTR647FOt9KcVezixzH6RJiNJ6ieAyAMZJ4a
	FqiFp8dB8Tj7y0VtcK/p+vAO5QxHUEEPVuGCTVcYq0hd7FVtRh7JeUgR4TTyzSALb0DJEw
	zhZTV2DFrd0RKCLFenPW1q5gmSRqlcg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hLuuwsW1;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764037251; a=rsa-sha256;
	cv=none;
	b=nKquV/sZLNtJ5DzOFh1pliWpPP9Qo5z6/Fxwds8efTY2SxgU9f0MU0H24Mpp+oUl/vgHDS
	zx4k/2LwsWNfxCco5IXOvdEBb2IARiY7+Sh2MKUjNP6dvgF5RmVplIVbNabXjSjqLE+hfH
	N3DUfaq0cdw6SgDRs751NI9FegbxVgM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764037247; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=shOPXkiAy+c6gaLyf7tLpirEDVlJR4ursOWE364FB9s=;
	b=hLuuwsW1lUqIhnDJmCHYScW2+XT6OUoAqmlzu/UeNE38gl3cYL6aXu5+hNprQ7gNJHJgGWrfbqHWOy1o25INjVjfHaxsnc7hPngJUhq9GRR/IuApzFaS1V1KacZEIrx9luqaEK1gkzWAw9ZLAdYhYdwzOc+pYt1MTcr1HyIJd6o=
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtLRoYE_1764037246 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 10:20:46 +0800
Message-ID: <8f1c8ac4-208b-4a7d-8a57-721201c29f02@linux.alibaba.com>
Date: Tue, 25 Nov 2025 10:20:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
To: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>
References: <20251121152246.1023918-1-bfoster@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251121152246.1023918-1-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 734B818000C
X-Stat-Signature: 8gidr84t8dycrr4px9izdpq4s93ftb9g
X-Rspam-User: 
X-HE-Tag: 1764037250-318324
X-HE-Meta: U2FsdGVkX19IhS3NXXfGZVCU1mmSzGosGP8uNTHLUqOFMMeVQ3mOeR9d1Wo5mEmjOAn07TVY1pGT7ao+oWAqOyc+OzaFY+6ZnXRU7aILRKZ1bI02jdv5Fxtg5rr4FCdoYkV+HsBKDNgGaJiqZIR9sd4oE+Ge5yHJI/Sc8J7aWPzLBlqbCOxf2MuVRmDHX4ebNAnOvDP+di/ud5WCwU+XOVJvbuITI0ehQxHY8NrNAq6VInPj357vXRm882c3wZ6Cy05hWlxfdYpCFSSUGQ32cTTgPX1JOcUKlxn9fmHWdj39qOg0MnJcMJQz2lKlsl5/OEWcBUT3VQsUMxC/XnjSdyv/AOd1mLzAkbKD8B745XQUdpe5mydmYq3o2LH6ZnAPARdcP5GtDHmYpXJ8sZACki6hpaYSZTUFao2Znl+kxQM+hVRSHz9UifYm4h3x1dxHY4kjJ+9uLv6TsZ9rORzy04O6F7j8uuhwlYWQUFjocbFMBmzXN6K5pZ4uAL5sU2ZOyMpOqtHfbw8cF9xgv496umXq7rHmSZ2Ul2rYYxUTlNKkWMcP52eae3uSZnV75KU/z6HrdmKcGgevOUzk1got1giM0oqR9vEd8QWusyPsd1xufdZfUbrd2AG4tnmRiEmKaPQh95Hjli6AWq27Q6rE3MpC57rfCOGGpQB+V0Z987ArF2w1cxISDkEGSslNnir3vh1ktwDzHZ5ZgTWI0lpV2iAIpSzwpk8+pYhfrhRPIbEHTIcjnA/l9jkd3ETFOh05xFhkq36Kq4MbUJxYR73GOfK6OIL+GB2p7EY88MiZDyfIzvAaDgaW1VNlyg17LXLLJTzd6c83i136HOY++DzRqmZ7thjSLOi/nIYkc4cvljzzvQk78gKyAmuHget80vMfB0RkTPg8QCLxCe8jkHp0+2ed92mBJB3zaWJrOzSoqfL4aZT+JpapurOTuStP/OkZ+eVMrl+ph17ZUeJnofE
 0KvVdkik
 ot2wcm6GgitmXLF2H6rWXkakRy4yutC5hn1WywbdqoTM0lC0HjnJ4tOARiVdaoOq2ZhxqsGlGqgylox/YOQnI35y95Ch7bHhD3LQ9De6AJLFI0rbf8fsP7ZAJZiFmzNxeM3UypkAXo5DJlQEqvrS/aCReEmCHf3jhyWeizm8O5E/hMi1dutzzNQyGBJQMLp/RpAGP3G5yrfr3GOurFoY8Mh4qMcdjMTaFPBsVD2VlnoNr5UGSA8PbveLB3aHSpHJt2mHRBkD7xnjLESwOR8KIl7LfP11gsYTMOvi9VHYzSVBgM6AtncrDUP/1BQQTclb/bfiyGEBgEUChy6YNMTCrMQYv30mL6iAxLo/wZeKtf7BhBuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/21 23:22, Brian Foster wrote:
> Hi all,
> 
> Apologies for the quicker than expected respin here, but during
> discussion with Baolin on v2 it became apparent that I factored the
> first two patches in an unnecessarily confusing way, and I wanted to get
> that resolved more quickly. Otherwise there are a few smaller changes
> here that I think are incremental improvements.
> 
> Baolin, I left off the R-b tag from v2 just out of caution and how I
> reworked the first two patches. The end result is mostly similar, but
> I'd appreciate a quick look before adding that back. Otherwise most of
> the functionality here should be the same as v2.
> 
> Thoughts, reviews, flames appreciated.

Overall LGTM. And I tried to do some tmpfs read/write tests, and I 
didn't notice any obvious regressions. Anyway, let's wait and see if 
Hugh has any input. Thanks for your work.

> v3:
> - Reorder changes in patches 1-2 to factor out existing logic first.
> - Use local scope variable in shmem_writeout() fallocend block.
> - Tweak combined zeroing logic in shmem_writeout().
> - Clean up commit logs.
> v2: https://lore.kernel.org/linux-mm/20251112162522.412295-1-bfoster@redhat.com/
> - Rework to zero uptodate post-eof folios on writeout and full range
>    from EOF on size extension.
> - Misc. cleanups: variable renames (pos -> end), code relocation,
>    comment cleanups/removal.
> - Update commit log to call out POSIX requirement.
> v1: https://lore.kernel.org/linux-mm/20250625184930.269727-1-bfoster@redhat.com/
> 
> Brian Foster (3):
>    tmpfs: factor out folio zeroing logic at writeout time
>    tmpfs: zero post-eof folio ranges on swapout
>    tmpfs: zero post-eof ranges on file extension
> 
>   mm/shmem.c | 135 ++++++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 114 insertions(+), 21 deletions(-)
> 


