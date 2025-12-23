Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8634BE6B26D
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85346B0088; Mon, 22 Dec 2025 21:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D056B0089; Mon, 22 Dec 2025 21:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BD06B008A; Mon, 22 Dec 2025 21:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B09B86B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:05:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4944414046F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:05:13 +0000 (UTC)
X-FDA: 84249093306.23.D71CC23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87149C0003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:05:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NHw7z6Jt;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766455511; a=rsa-sha256;
	cv=none;
	b=Clu90TtGnXA7RY7R6db7d71fEaKEeuWPKWSEquBTwtDG0q1ER62MvCMOz51n72uOKONcPK
	NHx1eRK79o5kmB+AjLnzWcNNPDxcJfFWfayleMQ3dWGt5dwW0fw4De43lo+fsuYwvTOTxe
	xFfjOougxKG3mNkNN188Kbae1dLapNs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NHw7z6Jt;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766455511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRhDDqUAzG9M7vsHnwTL8OysRqHTSTUT/m6l50Fw5Vc=;
	b=ZxknWGB4yN915aJRzMu0d0QVubTIHSoief9W5aJqpxtpsSOQyQgSIS6fsOlSa8jWj4c0oU
	S6QhZPC3U2lDqy3lv3FunmV0XqByArsxnelhJcLvfxXEPD/gOfFMfe+JTZurz1+8xGKD4E
	7DO1jms4JbiHlQcNuEjgwlQxFTG7pmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9361840ACA;
	Tue, 23 Dec 2025 02:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C943C4CEF1;
	Tue, 23 Dec 2025 02:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455510;
	bh=e9e61v4L5W1hIaja58wwlVt7sMty5BKmsf5jUCpyDDg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NHw7z6Jtm0S3j/LisGOhusIOB9ZWtoB7YVtGXxeqY83Gc6054WhFtvzuGmLL3ZTbe
	 5ngHxfyZ/FU9nu0R/x+AU+XXKLHfKDkUh1XsFGcB4EkXa6iKRVh6cE5Lcj+5yinfJt
	 XL/HqBb2TkAhOIhpDiv1DBK+dVaZqKTweNqdg/jQ=
Date: Mon, 22 Dec 2025 18:05:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long
 <longman@redhat.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
Message-Id: <20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
In-Reply-To: <CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-2-liwang@redhat.com>
	<20251221221052.3b769fc2@pumpkin>
	<CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
	<20251222094828.2783d9e5@pumpkin>
	<CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 87149C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 957oqermcwnsdm8dirans9q5fkwchcmh
X-HE-Tag: 1766455511-215552
X-HE-Meta: U2FsdGVkX1/cbGXfyAR3WQvgyGo2gc4tuXjjIn0Y1zaM8caTonqYgMO7kMf9lMg1NBvQHnx0a5OJPQ4j7wfDhwqSvvLp2lGMZG18BahnT5T3IcZhlxoVtq6Qqwm+b1HrrU2maKKEhQDQxTLMdpjG9TeH1sPCLbtFw4TIeDY/0Zl7GzILcTrUCz/0jN2VkTtQ6zl2lAsSwCqTU0yIAKjZfRyPjlK5xScxZXJo44EIMivqJHUE+bPu4tU7jbobOrxYrxj8PklhlMla4NVnah8nvI4wV3zE30UtS3ZEXF1I6TdZQHMwlf4pHm5ykhZLJWpgfUNKTkzr94i46nsHcHatRP1jCQiUl2jCXInaSCP88h0KFn9EgEcQvvZ+cOgX5QZP+ZxuE0Sc/dbkv8meahpBq5kI88rh5wLxxB5OM6GIQuwLgLNUbYSgnt7OFcSxd9/pyfSg10T4OJUX1IabUhVNaGoY3kxKeW6HEMAkgcHm6M6MZMv1Hfs1iAtZStiJHWWhcBGL3LT1etnn5dgFt759xc8DDm17OMPSjMuvCGBEFkB5KZ26BDbLWp10HKtd74AROgFTMrr+qRSOAu0zCtK2De1Oh5/vihpgkcmBUTAyfj/DgUnBMnTQ/oVvtUN7UYfIJVkuemZ+jfopE0mAeMp6czZP1uwB3yTquOm0p/vMbC2fy4NDdO25d8HtwHyJUjPfVA27dITcrqB5uW5geDEQMUjaLkh6bqAyI7IyZoLpjnbq+CpQOz1OjC5LWNdl8xd6QMW86kCbnX1O5FsNm2xLGUvl9IQ0SHVaPLhfewibMduhi7BHw2sNXfeI1q1JM1mXB9+an/NOXpLQQ8dg7EqByUH1ZGAgUzQLzbdYFQ2c0vLm6AkdBUd/TQzToBMCrM3pazI33BI+/XfQC/tVcpFPYP0hTbk9mEUQOaye+FNVfYzOOfUjW5qZeE2oFNiybbG/5ADH8gu+N+xtQ1E0auQ
 +GdJewiY
 6xnQn6wnJXV21YLj0k/Am3p1O9mqlr/X/8YDa5Blybm2bJbvVKCaRKKjFbeMHSZhkr3xjm8kO1PF3SyIItLFQQq2uToAUNZiycgD5f/BYLixmjhsLHR1fk63UWJBBiY8kUlJLJmBIQcKuUsVCYRt6whRQvsPt9Cufr4cDwJLC4g43iY73ys/nWZhWMsuODwa9pxWz5G5ys2filK+lf4c7zthmQO0yMMvG28K9sIIdNEX91xo7zp0ztlKZ/6At57YqRdNNTZ+UZ3+tV42cJ769JeJ5aDVdxrn8Gn/WEfu6jC+qc45IMAmTJopmbEhMH1pK+U/LqO6bQ2EOhBkx5hXlv3g1DlBzqxTO82Lv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 18:56:49 +0800 Li Wang <liwang@redhat.com> wrote:

> > It reality scanf() is 'not the function you are lookign for'.
> >
> > IIRC the 'SUS' (used to) say that this was absolutely fine for command
> > line parsing for 'standard utilities'.
> >
> > It is best to use strtoul() and check the 'end' character is '\0'.
> 
> Hmm, that sounds like we need to go back to the patch V1 [1] method.
> But I am not sure, @Andrew Morton, do you think so?
> 
> --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> @@ -86,10 +86,17 @@ int main(int argc, char **argv)
>         while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
>                 switch (c) {
>                 case 's':
> -                       if (sscanf(optarg, "%zu", &size) != 1) {
> -                               perror("Invalid -s.");
> +                       char *end = NULL;
> +                       unsigned long tmp = strtoul(optarg, &end, 10);
> +                       if (errno || end == optarg || *end != '\0') {
> +                               perror("Invalid -s size");
>                                 exit_usage();
>                         }
> +                       if (tmp == 0) {
> +                               perror("size not found");
> +                               exit_usage();
> +                       }
> +                       size = (size_t)tmp;
>                         break;
>                 case 'p':

Geeze guys, it's just a selftest.

hp2:/usr/src/linux-6.19-rc1> grep -r scanf tools/testing/selftests | wc -l 
177

if your command line breaks the selftest, fix your command line?

