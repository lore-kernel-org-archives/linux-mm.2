Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC766CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB836B0093; Wed, 10 Jun 2026 06:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C3A6B0095; Wed, 10 Jun 2026 06:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2B46B0096; Wed, 10 Jun 2026 06:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286AA6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:46:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDFA31408E5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:46:38 +0000 (UTC)
X-FDA: 84863674476.24.9DD7491
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id D1DC64000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:46:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8h8xmRF;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781088396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrt0LCXtCGxG4r1DSnamedxnwcAsXfmO6rDbEUTJaIk=;
	b=3938V5upfxnhnH5oUcmUQkNCOLkBbmj8wpaEwgmAsYGtAqCUDlB3lR+mR+15kV8doidYyL
	gpPZfmzf1fajeZAqqB90THISQvBlLn6WFlh1N8QxDJfJujS8otAT0Z/3H8yq/aaLhgkuNQ
	+IQITkWgAKofn7/5N46GwqD5dr+JOGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781088396;
	b=buE9ctMGaLz3xCoBhSextO3pnjjX8fMS60CxRbOkhP6Gi8yDUYx+jP7KyybVT95J1xz6Rr
	qPvgLFAFtpVxcWuAdmdi8/w1UtYBuix0Q9GaNZoGqFkoKOYya50rwHhSnI718IuP8dDS9n
	vefkWH1ZlvS8WXt8v8xBZntmXqbK5Vk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J8h8xmRF;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so27037055e9.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781088395; x=1781693195; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xrt0LCXtCGxG4r1DSnamedxnwcAsXfmO6rDbEUTJaIk=;
        b=J8h8xmRF+Af3YE22dGuFApwQ4cv6tH3Z2/OrGZPJsCvYpkibCdiMO+jOLvry81HqzJ
         DvUSOWZ4TyMLUk5yG8U510FpCBMxPk1oBM5uUElxjQtEfiryhJsVAutVUBQO9c4Z8Xwi
         IrgrnH6EgCZjqk0DR+3bZxZXKhJFFqCfJmUsyWuOztkh6FVndd34G72f48udn/IxwJFi
         zXsnEan8SbjVuwSBm6BGhOnR6dRnRyavBwtFUID9NgkiDvycvmTjz9pFzvY/ZV9SvQ6O
         sY+AYgpvV2oAvzztP3PojWY9hRV2AahUAvl3J5PS0rOFvMeL+9gkt5ADzHl9uTr6wC5o
         WjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781088395; x=1781693195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xrt0LCXtCGxG4r1DSnamedxnwcAsXfmO6rDbEUTJaIk=;
        b=LZRXnbbUPS36pT4gW/7WgSR+zeiSgqmIfHw8/i7qSD4hcQEelSNeoYPvilOSks28jo
         J35ApMib2BrdRC/0Me5Vvl4L0pACmRCSLMeFivUrNdXyQGCeYEDBBEe98D5L1xO9o/0w
         eUoxmjDOqHTRAfO8HNyE6Gu3PSFVB4HZxHHzvs4+Uq0QJfl8Bdxs7eKMeEHAG1lpO2Br
         AbYHd4961yy88v8YnD3IiX3JoGHWUkFQ0+tDmWG+Cvh76hV9iEhg2p6LYgEh8BWjbhG6
         qmt1KR35xj8QzoRum07ZWB9PmYUNQj0IIVrIq3JRmPJupkMOv/+qRbxxkouJDXMXFP/e
         wPCA==
X-Forwarded-Encrypted: i=1; AFNElJ9iM7g3ja1s4Q6rEd45WkfNJa1rMV8WQHbG9wmeynXaKztpsKEPC+bcImXcOqrK76EiQvAfHkONPQ==@kvack.org
X-Gm-Message-State: AOJu0YwxUwVp9PhNEvWP217gbjtPQNL//wCIr2T0EAsxfBwTP9M35HEi
	AtwJaaVC5zI4N0ValPhctGE8x7ZJu+BXTJhH0vT54gXkK3QrpcsWYktZYZ2f1LUS
X-Gm-Gg: Acq92OGxVfnbWRhzN6CINi784RHsL4Y7USb7/BZyHxKUz6Ev0JNIlV2XMSRTo7gxKSD
	is4FiOKLaAHqsLuSZ3ejyzLY91SmQbQD2y8kUyr4cQOfxIWID1cNLvBhJKsAT+Ya/gMk1JuXSse
	HTZ38YHOV7g2uHBnIgX7OT35+KG3dqa8NPA4iHcrYUUsmiZN+6s+a8t6FMCPtfp6fEGo1lt36DA
	ahvE6ASVZB9ff20AHGzLC2PbSLSqqUFgM/UDBbBb7BmDn+BeafC3spAWpZdH7Ft555YDEaHH5WB
	OlgEmELf7LbYce+MfmhmAnIswDoZtDGcWJljteJ6SDN5mS9/NM8dZhxPTvF4xY8RukNSurZzEAg
	7oUhjGcaGzym8//b6VIxOS4abtux93QgnDOcLSVdg8/HjPurRz465APLo3Mx/7oui2H7OsogCo2
	t8Yn/wp9obSOK5gmEjdkoXP6RRfZcCzZJer5OvscI8+oj5DN+paU7xPCQo3Wx4wHIgunuwAgSIa
	hejN2xr7FWKSf9n+tGOuNQ/lAal+JTezCRZZ1/L17lS
X-Received: by 2002:a05:600c:c493:b0:490:bb3e:30c2 with SMTP id 5b1f17b1804b1-490c25f1682mr418534705e9.18.1781088395188;
        Wed, 10 Jun 2026 03:46:35 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc391aaasm641985295e9.1.2026.06.10.03.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 03:46:34 -0700 (PDT)
Date: Wed, 10 Jun 2026 11:46:32 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: chenyichong <chenyichong@uniontech.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/page_owner_sort: free per-record allocations
Message-ID: <ailAiIKTNSDHkUl6@fedora>
References: <D7AC1314C01DD894+20260610021109.132538-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7AC1314C01DD894+20260610021109.132538-1-chenyichong@uniontech.com>
X-Rspamd-Queue-Id: D1DC64000F
X-Rspam-User: 
X-Stat-Signature: fgseoxmsszekb6mkca5hw634ai3zkpdm
X-Rspamd-Server: rspam08
X-HE-Tag: 1781088396-563575
X-HE-Meta: U2FsdGVkX1/HWh4wY7tdTbvKHJ2HYdWQxn2NDK+ynJSk5Y+1OBratRPvArVn0ov2cTPSXpkQTxhlOMQZw0LMreYFS08vval+E1HgE23jLqlPr6f/XdRnpxoiTRN9QEw19jA8sy80R4lDn8swdcVUzNLdm4BKDBwmPL2NOnwHXYNo1RwSw6ydAtH0lF/B4SWG271mPbdY22Kw7RzryygLN6BRzOCpRc7yd81+IeenA99lKhVP/+4ylBSehbU8MJNESNfCiXM8A2aYWSe1sAO/vFiVBWtp+1h2w6hLCJkrl/2yu/XMGGtvuGYVL1pQesyGrKXW4iw6iJxUvAkV38/kCBahDmVp34scrxA6UW5fj0IwXPCZxXAiB2VyZKnEDbcKP79NzDFof0+8JEJe+KsIooYpUEvo8rouIJ6BfnVsMkCZyuW1xP6iySYO6thFVgYGFWCBWvhwBCZ8kbg+j1Y0vywOHeFjrTUNeMYOe2/xHyoY9fYnHgRK7X+k7+wpD1CLwC1bNELwvJSGgPNEFxFxhuJOMXzTwC1Ay8JODYjtvi4LUWCuKpSK01brJQWIQG9mIj6j7b1V4JfRf8HGBCtFqzX0VOrDXz5zSo6YJ1EnEz4szfF4+dtCuuCUvDb8y3G8x4Gtr8EiaZcMgQxsqMf9RCBKVDpHvOoaZNS+JvqK7Bo3A7Hst4ZD31mnQFpYgvGyB9hIOZLZ2/5KHgVjPJ1K8JVXR+hx2qEAk4r0rEXS+hVfbI0h0PPOb2+uwSMlQZYfgG263OHBR9W0drh7fBBCUe6X06BqN10bg/lTkl8MJrlvI73UVFjDKzIZENiyQElMmuhsKIycHwCp0R8nY9naqCYatLEOfUdPU93oq1C9Yf+t358WPP1JHFo0EdlSGN5YceSr1gMq9MJJyN4DfOLtCXQgdHvMybXN4frquITdRFDX7q4zSr99x8PilzjcYr28iUkNXQGzUQKX3qwNKab
 Oj53U2gT
 uyO3/volGXPOyZSShdLK7BUH3d71w+qNwPFyUOr1Y8SJu8F2UeRpsR+O8T6PXLBr7AXiM5HmeVMJ6rPI7p+wQwi/s8Ur33/wNbvCxAODg8HuOW9JSLsxFlbW+6TiKe2NlSpsdtw/vf0mtigLC6XO/9jYMDIF2y9dVKPwACiFYHmbiET0wWPr9NNpCU1ti645fBqaJNYNQCgRP6En4IPcCdoX47Gyg9SFbdVg2GucjkGFnZSHbLCe4apAz9O2Mdo1ITABh3hXNdIWbdHumr6WIwBSu7sayX9Ax7m/pDLIwQs/ibB0PD/eix41NtrEKtZ4Zx8ePQ1pBPfs8wsnzJypirr1Ez+Xsxv+aO9sa+oXclQwJpn+5ca44hDkHB0cM+M2zyGze39BBCAG4cQp9R1/CRssDTxR6LE66UNbG9csnR9g/zvsVatV8lPFWa+ZEB7PdsxF3KLZZ09q62Zr1azWcHLpYjKNFcq8S0NiYAVmW1jyMJR6NfolPkMQ+O+FNRmHHdMdrM4Y8lGO0kOV5NSczFuOX1nO3nO59ebGpfggDj5u0fr7Odc2ZWWXK/XGtVoPSHT7qg5lDBFaGEYeUnvdJXfdg6on7ZxwFFwnMEvErtjlAI/buaHQqTZz6Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 10:11:08AM +0800, chenyichong wrote:
> add_list() allocates a command name and text buffer for every page owner record.  The cleanup path only frees the outer list array, leaving both allocations for every retained record behind until process exit.
> 
> Records discarded while culling also lose their allocation references when the list is compacted.  Free those records as they are merged, track the compacted list size, and release the remaining per-record allocations on exit.  Also handle allocation failures in get_comm() and unwind the command name if allocating the text buffer fails.

Please take a look at the process[1]. Aka wrap commit messages at ~75
characters.

Running scripts/checkpatch.pl should catch this for you.

> Signed-off-by: chenyichong <chenyichong@uniontech.com>

Also I hope chenyichong is your name :). I'm not that familiar with
chinese names, and the lowercase one-word makes it easy to mistake as an
alias (we don't allow aliases). I'm used to seeing
"[First Name] [Surname]."

> ---
>  tools/mm/page_owner_sort.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index e6954909401c..67a7fc6d9de2 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -372,6 +372,9 @@ static char *get_comm(char *buf)
>  {
>  	char *comm_str = malloc(TASK_COMM_LEN);
>  
> +	if (!comm_str)
> +		return NULL;
> +
>  	memset(comm_str, 0, TASK_COMM_LEN);
>  
>  	search_pattern(&comm_pattern, comm_str, buf);
> @@ -386,6 +389,12 @@ static char *get_comm(char *buf)
>  	return comm_str;
>  }
>  
> +static void free_block_list(struct block_list *block)
> +{
> +	free(block->comm);
> +	free(block->txt);
> +}
> +
>  static int get_arg_type(const char *arg)
>  {
>  	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
> @@ -480,9 +489,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
>  	list[list_size].pid = get_pid(buf);
>  	list[list_size].tgid = get_tgid(buf);
>  	list[list_size].comm = get_comm(buf);
> +	if (!list[list_size].comm) {
> +		fprintf(stderr, "Out of memory\n");
> +		return false;
> +	}
>  	list[list_size].txt = malloc(len+1);
>  	if (!list[list_size].txt) {
>  		fprintf(stderr, "Out of memory\n");
> +		free(list[list_size].comm);
> +		list[list_size].comm = NULL;
>  		return false;

Returning false here sends us back to the error handling path in main()
where you end up calling your free_block_list() anyway. So we don't need
this here, right?

>  	}
>  	memcpy(list[list_size].txt, buf, len);
> @@ -841,8 +856,10 @@ int main(int argc, char **argv)
>  		} else {
>  			list[count-1].num += list[i].num;
>  			list[count-1].page_num += list[i].page_num;
> +			free_block_list(&list[i]);
>  		}
>  	}
> +	list_size = count;
>  
>  	qsort(list, count, sizeof(list[0]), compare_sort_condition);
>  
> @@ -876,8 +893,11 @@ int main(int argc, char **argv)
>  		free(ext_buf);
>  	if (buf)
>  		free(buf);
> -	if (list)
> +	if (list) {
> +		for (i = 0; i < list_size; i++)
> +			free_block_list(&list[i]);
>  		free(list);
> +	}
>  out_ts:
>  	regfree(&ts_nsec_pattern);
>  out_comm:

[1] https://docs.kernel.org/process/submitting-patches.html

