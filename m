Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD262C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24016B008C; Wed, 16 Sep 2026 11:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3EE6B0092; Wed, 16 Sep 2026 11:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2EB6B0093; Wed, 16 Sep 2026 11:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9361F6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:30:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14E178077F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:30:21 +0000 (UTC)
X-FDA: 85220011842.07.3B392C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 52CF31C0013
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:30:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCWEXLU7;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zwm/p1nyzNJMkp1pYGg0loyufpT3OLyoisEPtQ8zWEg=;
	b=CUpRlXl8Vg/h0RBXsT3QjdiOE8W8VO2DbZQ/kF1PtyQvSkhJn6TbFFhlfudrwSPXrbKKg5
	i+IJmPSgu0mup/Vrn68ecsQJ4ab0Y7W/jyAP5WfLefszwAuGUPBWY02o+7iEePoU0ofa2P
	5BUwzc4bWCxEACP04OErAkjAHeg1eyU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCWEXLU7;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572619;
	b=a8YQ/IvHdCAE/LL+MQ8+Gv+T93/rZjWu/4aGv5QEjrIcUQFYUjdKG4L6M7mmiM7N4+JZzh
	XqJmGBnlMZaHnDC1FH7eJlndQpZWGlJeHSBtFbfIf9hDUBL+2IqCqVMsHVEoZ+1VayOX0H
	ReMME5hCzlcub7Pv61WHkIBajacDp3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C843E60234;
	Wed, 16 Sep 2026 15:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3968E1F000FF;
	Wed, 16 Sep 2026 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572618;
	bh=Zwm/p1nyzNJMkp1pYGg0loyufpT3OLyoisEPtQ8zWEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YCWEXLU7Ho0eK2dCD4wWUTu+jg+3YfdTNXIS7vLT6hWD4fZbBsgoVrqAKTI5EXN4j
	 4EIHOueKpzwfKorjR+heQNQjUQVfiJAHmosWvRpe2h/CLxK+4CjSQiQD5xx5YAyPkG
	 R3HMcMOuvpgTFJO0XaBD23b6CQVqkyKKDS7SDRtJ0VSdAZKgvqlZaDpGcfvLtRvcn2
	 Z4nhpIBsvK4LNJGmgvTRLybBOKOHb3L5K0DF9vGrqSn5UYuFkSrroZrB9GZRKWPSGs
	 c3fogHHH2EFC9HvHkDdy3rRARFlCLlrrq2a8PCXOxucrmi+jL1ZzJRyCQ/aPX9i4/A
	 kRzAlsI2vt/+A==
Message-ID: <b1f2a146-1a61-42bd-98c5-fc4380b6ae49@kernel.org>
Date: Wed, 16 Sep 2026 17:30:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: init page sizes early in
 pagemap_ioctl test
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134405.84448-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908134405.84448-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5ejmmrgfr53mdob5mbr59nobacesq3ut
X-Rspamd-Queue-Id: 52CF31C0013
X-Rspamd-Server: rspam07
X-HE-Tag: 1789572619-781104
X-HE-Meta: U2FsdGVkX19ZzjKxmi0XJCI79mtakEtkziniQ1g+KXjUdFYPf2JnfDxBtq8g5OKxrv8HYC5WAy9rsr60FsgGVymsabbgY7woizQJ1iCwvhAVNH+ihX8FRazabjOz6VrzKWDlmtrY/2mDHfJCFyc+boq+MczIAmh/JEINCGOK+JHcRBp+MrqAQNWJuVjH83MZxGTRx79nO+gvSVWHZgT7282dfamOCDe2+1uKMimJ4PKLxeErk0S7tAc9QeiKiN2/52U76rzFOME3tG4ntOtoSAa4H+wUm/1lseLCMJYN8vB27Q2vnTmis5VTgUYt9hra+Lr7G+DZCB6tzbT8H7cwZmA4MB6bt7xg6VnUr6LOuT3Z1gYUsSvO99YCqT7GFaJO9UnEyh379JD2kFxBm6IqsODfSB0k6aLK/s2Oe8vYMnsmTklZsvedhTKvqMP+UtHO1I4T642p1XTfXg7w0jX5xNpEwXJ8Fw6lBEKgMrXMb1f0A5K0uGMhzxUUzCzwl86gStDUBooYUfGi8RVfSEe+OqMQy4AK0lSB+5tVzT9kJ7z0bD+/VgYI8bPpEj0epvXaHEkSLJ5se74ygP5d3V0et3YnAHFe3G2Kxog/Xh+jqRAwkeDhq0ZRlUwynPRnKIFFuTGHuti/gLH4ukGHNTtYPkTbayWiwdYQEKvF6WtAnLb25cjBkX7kM9eX1sCkIdhNJjUNhVhH6P+fMZXuYXopRXTYcpOFNiS8amwajka5YTfL5YBW4WdpqhGt6EihYOzLRB23TmufuKiPslEJ5/UpAFucIvFrajfVjBVx+iiQukF3GdiktVFub6+HMXUOGsgjuVpJiBmJdJOhrZ7YmTEf1he0FF1WqV1jY9772H3PHTkVzLlCwOss9iUP/27G3KFWXPu3eTzsvugOOAtnaR5g6WdIcqp9DRGruRF3g6cwe14DSWYOIZsitm5HqvHd5o60o0Os4UfTfDe3y0Pneio
 BsWsJCl2
 8Ple/p2SyF1vI5DIZz/gw0RT/ylghQ+O7nk3JBsgV/TXpHl5kvNcwnHjMDYSqhTZLZHYrrgU+EZW/U64UMKOhgUsh+ak5KL1yIjxtvBDg6zL/aRVW6hv/pzbRPuu3EXaq9EePZcZFsF/MveO94qpwNOtWRKpMslWQ9Pv07EK3Hnmwi1L++bAVNpRJWGoqLSqTgWrm+5tAKdK+2vi2PZcSDc4j7y9CLP3+Rq0aqZl4YdabGueTQ4xUf4t+Ji639ZhFMw/Kkv8JW+fIk97sI/2QA0Cg15PzFRedDTaO3Rl+6zneoUoEy9RjFNOSx+tzL2syV28lHy9qkjBO3Pne8zllCuDNS0hf/lqLQ9RRTFoX/6cq60M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 15:44, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> Initialize page_size and hpage_size before calling init_uffd(),
> hugetlb_setup_default(), etc.  That won't fix anything, but it is safer and
> saner to get these globals set up before doing other things.
> 
> While at it, drop the page_size parameter of transact_test(), which is
> actually unnecessary.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 1a87b7483316..d9a4fb782ecf 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
>  	return NULL;
>  }
>  
> -static void transact_test(int page_size)
> +static void transact_test(void)
>  {
>  	unsigned int i, count, extra_pages;
>  	unsigned int c;
> @@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	ksft_print_header();
>  
> +	page_size = getpagesize();
> +	hpage_size = read_pmd_pagesize();
> +
>  	if (init_uffd())
>  		ksft_exit_skip("Failed to initialize userfaultfd\n");
>  
> @@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	ksft_set_plan(119);
>  
> -	page_size = getpagesize();
> -	hpage_size = read_pmd_pagesize();
> -
We have some other code rework that part, so I expect some conflicts for whoever
goes in first.

Why not

initialize them right when defining the variables, marking them const?

-- 
Cheers,

David

