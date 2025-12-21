Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F1BE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 22:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E9A6B0088; Sun, 21 Dec 2025 17:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6C46B0089; Sun, 21 Dec 2025 17:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4FB6B008A; Sun, 21 Dec 2025 17:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB1F16B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 17:10:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BFF1C1245
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:10:58 +0000 (UTC)
X-FDA: 84244874196.17.CD09129
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6721CC0007
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:10:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQOOjyj5;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766355056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiLm+p5h09BwQ/VgsJKq6TFAfcpGR1sZeDMEGJGH3ew=;
	b=1Bhwnu2NG0eQpsyUL3qDeH1ATxXfgEbwxgEIJe7Vs3+ljktzBWSgA/Lyr2Y5irtzhedaC7
	v7CmgTHoQ9MSqQCoSTkup7hD5Zy5xnh5t1lOwEyZuRwxEw033gfhVTwMnB+vTIKMaW9npp
	AmPhvaOCAKNjE4wJ5xPgjtf74eKqojk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQOOjyj5;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766355056; a=rsa-sha256;
	cv=none;
	b=TPf0E7//ZZh9NOrTy1++JWrP96mdJ2Cq2rBhYu8p8VFaCldTVDbW7EICREW1NXhGUlGv9K
	B+OpIQQEbVOmNHBt9bFphmRHckmIozU6+sLpnoyVHzewvmFpB8mTcnqWNg4qhMQmU4m0AH
	33WYknDbMaqM6Qb+LBx6a5gP8Os+VXc=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-477632d9326so20540095e9.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 14:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766355055; x=1766959855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiLm+p5h09BwQ/VgsJKq6TFAfcpGR1sZeDMEGJGH3ew=;
        b=GQOOjyj5LubAKABgLnpeq8FzuYoct6p0SwYkr4OSgAhiDIu86ssvQPCJiX6HrjVFuq
         77jnl1hUYCfo0o5dogKsRCmjA8R+KCOwPT+3NNRAM3zD5gY8TC8MfTQisKxy2ZgSFMws
         pO9w+cS5avqOY8tSYo01K7+mLzkUHZ3OQvvhaEsXkWVe5UcDd56nSwBaTkSjia4l/yY8
         a9mei4XtXMrtJK1s1zFpKEdqKD0BoekwpU0i3Q19NTu/zo3AF+y7rTEXydTxTdE/amKk
         ppWa3YZxUVwDfRXN43KTWG8ibpVs5NddkrmIOZaDnrEGrBlMHrnUIwciLtAxD52YxE+U
         HR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766355055; x=1766959855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QiLm+p5h09BwQ/VgsJKq6TFAfcpGR1sZeDMEGJGH3ew=;
        b=j4rC58SekOXxJar7jCP9mzHM0SlASRdlagiwvKJFCg3p3x+pIYgiEouy9AHzjDUN9v
         g3eGwIU4Pe6bamAfuGxc2U+I+Ydwq2Go3mzDszZmV2YqIQQ+iax7iQl20RmnHSnd88hr
         uT14fpYK3C83wgH2dOo2154qbg+gUvyzMA7pt3x4xDMO3aCWPxKYCA4v9l8W8TxZFDt+
         aPm6SDDFuwi4wXuYTKzTxodxGqVR5B7yieuWR3R+LzCJwSv+YJF1BDFheZ3o0OuD3GSf
         cZnu4g6o0EOTCDNMokJMz6QH4M7gvD86Pbu732Il1mGXvCtF5FgplyvX+krrTnK/9wbx
         f5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjvWAlogeu54Tjkp462FUMYCfAp4aY7Ba1zaVv3gaZlhDmsXA7ozy0XDCfRhj7nndAkG3VHlxENw==@kvack.org
X-Gm-Message-State: AOJu0YyppZRzS+MJSjnQwLSdI1F52nfbfzYVxcsj3gToldyy7pn0OCh7
	WIdCahxalHrkSgBsIXooqonMu17RTIm4QKx9amAxXBY/5wNmBF8d09zg
X-Gm-Gg: AY/fxX5MSMVw1M6GEYx8gBhT+AuE/5H/CSSgURyM28R5QKMeWhEXHBIOzF2TxSN7B4M
	lyHMB+Mt+wZKPCztdX7xhpvqrqsLi+YOaAHbWBkUAfgpmPvSEHSR5UuKUBE4MhNUNoTeKHFcgPe
	4Nzs1m4M5YB5ElrW731NGHyz8W8i/WVKI1N+gQcjDhZWdSKWBuca3QovBLOsWMTFc9JD44te0gm
	EdOlpLHcOHntoll/mhSGmQbwH6Yh0DL4lXBflmU9Cm628yMciKR/KlTxRBW5SRnwu5go0h3wXkP
	EKO9I+bd3xwBvODhH10Y8oBJjajKm1UZAji4tadh4OCh7iM1TiVcVlWjkgabJ+8vYJA+XOXNg6I
	+cdc/4X/hAdC+tLwrGvOslRdqJLPmlfsTtYHkB0WgG51kOETX9KQwF8kfeRHbgh4T+SkjdZP+TF
	+pAmaM3rcXAEd0Pwh3QxKU8c1b9pclYY2LKN6WLqPHbQnvd3fNhZQ=
X-Google-Smtp-Source: AGHT+IFVkmIWyY3VovB0ooaWN16E7YNRegYvzVsw9beruXRg/cTnWuHr1PycSjbL8hQHJMwzwF/gYg==
X-Received: by 2002:a05:600d:6405:20b0:477:7a87:48d1 with SMTP id 5b1f17b1804b1-47d216bab2fmr44553095e9.30.1766355054444;
        Sun, 21 Dec 2025 14:10:54 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2723b2bsm207509845e9.3.2025.12.21.14.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 14:10:54 -0800 (PST)
Date: Sun, 21 Dec 2025 22:10:52 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan
 <shuah@kernel.org>, Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
Message-ID: <20251221221052.3b769fc2@pumpkin>
In-Reply-To: <20251221122639.3168038-2-liwang@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-2-liwang@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6721CC0007
X-Stat-Signature: bigzhi34caqhzhseajadufcc3ews36nu
X-Rspam-User: 
X-HE-Tag: 1766355056-196246
X-HE-Meta: U2FsdGVkX19R1+bAXQ8H3qO5TXHni7s8XJpmEHwImASLDuI9QN/GnbtV719ji/qoPBFRR2MFrzjpoDjgeZAccDREWnPUKhsuNn9Ey1WLlVGzkTMnfh1IQYbU2jSDFBemWaqHgqk23rUE8fzrsRSuEugD6NeIlNKxfzML02qn7WY07hfvQLgODAGfYe1/Bnhi7/tk3nHvsPLfwOEgCaSy7Ca48XjjM3bPvTfv43CD+GdJ/U06/6O5LV4s+00PN+45VoAGi3dIuTCMd0oz3tTCT5GOdMCQMQ8gh8vEtYdskOWn6ApB1Q65J6cNm/lltK+btkI6lrA8QYKYyd4rjbSXVE6kxFyQA6QeuQoQOySNsg+aCC/UWMsCM3LtmcJ2m8eIS0toSC6E2Mfpb3QAYigj3JmBoNVOR5v3mIIVVaBWHPcaOr6G6PzWoj5KCkP5z2wY3tjY1q3uP0QkqZLulaF9DQCHYaTJWvSpXtQvKdJxs3LKTUS3nBYOBQk/3ZOVURwHr8yoB2T4/qrrUXteXQdjXwiyXMcdkJt3MOTbFuN+aAIo02bkAo6Tn2dtlrcYnIRe7IKm2S2o8bYrpxLLGthPvuLxgJ+DCgz7GBeZqBE+eXZvqYy0d4VjiG3wLeJMcrolfk+/KWMDBQ8WzXGEdV2qYKw7+N0x4+tHAQ7+o5tBNzmXzPjFkV+Jh+mn4lcu+3odN0JvE+FRi5RVMVMShOHQwDoeZMCHJDHA7qZLvsi6LXv6b5XrD1clYoUwfXIW4zP+nCKr0SBYQ1ksevcfe4VsCEhaiBf5uFmtT8tBGREToYHLGHggFoZohHmDUF86vphr/gt0DOZPSc7UoNzag4YkjboOCUMScCt3PkJXl4nKjq97FlmjQTX9/SnL29lfam0KzxeMIHGvc1sYWFIT+qRY0mvB10qIXCAElAPZXEMf7GsJjEU9Yvz3EceusmiJqtlf9pEjT6qw9Mjn1OV4VJM
 n1zTMFr4
 jeeajc3fJBVF5DcV+IG26ylT4IDg1ujHCsjw2VjYt6mmakATOMlk/MaoBmWcYItMNm/+NcyzaT/GBPeFqQvSZB3FgkbY+1yifMUkxPUeoclCXDsJRkiNPomWSuXBub6SZt2HM388TZcZCSDzaX3I4bKa1Fi8cC4dPRZ0YnOw05v0F0ZsohWAKFCOxNGLNUlUFYY4cD36220uLk4PCRkDISeEX/VEiH1xebs1W1uk5nC7JJx7E3TypuMAX31qLmpslBlWMbkJdsTtSrAWkFcFvaZlRCk/cOvS51kJiKdPUiWZSELbhtwRBW9U6pK9vOEDacDx/XMeU33rnVGp+ypLhMVxxsJv2GaqDErXz3gitF7mUujnXS5mjNKVBicTScPOVsz8ANFq+pLEPdJ5AfMEwKXaKOKdXda3eIjNygxB8YkofKMKQhbOnBsRVB1S9RTRpfDYh/MJzF3/WOp7u0BK79SC9BZHpItUaO2l2jCr9FpG7/JGXJ7SClqOtD3ZdBqBIXmHEjtG32/8GffE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 20:26:37 +0800
Li Wang <liwang@redhat.com> wrote:

> write_to_hugetlbfs currently parses the -s size argument with atoi()
> into an int. This silently accepts malformed input, cannot report overflow,
> and can truncate large sizes.

And sscanf() will just ignore invalid trailing characters.
Probably much the same as atoi() apart from a leading '-'.

Maybe you could use "%zu%c" and check the count is 1 - but I bet
some static checker won't like that.

Using strtoul() and checking the terminating character is 'reasonable',
but won't detect overflow.

	David

> 
> --- Error log ---
>  # uname -r
>  6.12.0-xxx.el10.aarch64+64k
> 
>  # ls /sys/kernel/mm/hugepages/hugepages-*
>  hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> 
>  #./charge_reserved_hugetlb.sh -cgroup-v2
>  # -----------------------------------------
>  ...
>  # nr hugepages = 10
>  # writing cgroup limit: 5368709120
>  # writing reseravation limit: 5368709120
>  ...
>  # Writing to this path: /mnt/huge/test
>  # Writing this size: -1610612736        <--------
> 
> Switch the size variable to size_t and parse -s with sscanf("%zu", ...).
> Also print the size using %zu.
> 
> This avoids incorrect behavior with large -s values and makes the utility
> more robust.
> 
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  tools/testing/selftests/mm/write_to_hugetlbfs.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> index 34c91f7e6128..ecb5f7619960 100644
> --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> @@ -68,7 +68,7 @@ int main(int argc, char **argv)
>  	int key = 0;
>  	int *ptr = NULL;
>  	int c = 0;
> -	int size = 0;
> +	size_t size = 0;
>  	char path[256] = "";
>  	enum method method = MAX_METHOD;
>  	int want_sleep = 0, private = 0;
> @@ -86,7 +86,10 @@ int main(int argc, char **argv)
>  	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
>  		switch (c) {
>  		case 's':
> -			size = atoi(optarg);
> +			if (sscanf(optarg, "%zu", &size) != 1) {
> +				perror("Invalid -s.");
> +				exit_usage();
> +			}
>  			break;
>  		case 'p':
>  			strncpy(path, optarg, sizeof(path) - 1);
> @@ -131,7 +134,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	if (size != 0) {
> -		printf("Writing this size: %d\n", size);
> +		printf("Writing this size: %zu\n", size);
>  	} else {
>  		errno = EINVAL;
>  		perror("size not found");


