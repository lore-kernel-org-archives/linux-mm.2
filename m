Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB6B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNiLRKhg
Received: by kanga.kvack.org (Postfix)
	id DA8F06B05B5; Mon, 23 Nov 2026 06:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AF36B05B6; Mon, 23 Nov 2026 06:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97006B05B9; Mon, 23 Nov 2026 06:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0D006B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:10:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 516CF80829
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:10:27 +0000 (UTC)
X-FDA: 85466115294.24.5DAE311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8185FC0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:10:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNiLRKhg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795432225;
	b=25Ru69jqcvcUF3OrimqBbth27zLeu9DPCc/P6qwukuCqrjimiw2VKkw9kcLrKrD5kcCp2a
	6o28DpSUCIiHbFQLgqZHqZgZwDpJZAl5cGSG0oVQr7P+swHeooSOruKlKKCxrjUtWNli7+
	cCrfpB/p+IsS08eBTtbxH0g/9n4w5wk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795432225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flWDZ0WVYrcCzYvgql2By/t92QQCD+UIxAgzzj+gmqc=;
	b=b8dchAS631OjIqnHiVYcEIvGK7x86qLeUhUdjlpuHz1nwj111edjhX6B1IJg89y1ZWWbYo
	g5D74YfPKse/wn5cdgX15vzmXL6vrGCpF8Tbumqe0nTKelC/qRH3ZFbkuR/U0aPEnMw2OR
	IosEOSJ0DcRbf5lZb/yUD1jt9Ee/OI0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNiLRKhg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67112447B4;
	Mon, 23 Nov 2026 11:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EAA1F000D1;
	Mon, 23 Nov 2026 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432224;
	bh=flWDZ0WVYrcCzYvgql2By/t92QQCD+UIxAgzzj+gmqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VNiLRKhg/s8fUbvUbgXUpTi4aO3InN6M2ExDDK0FqhNT0LPNwRnUdloYCnGMWQDsg
	 2z3/kxh01SWaTdPny/+NTmhbrzX3+dzxd8HhS16Oa7AtPrM0IXG66pXMS4cou0aXAs
	 PpUrT5BtGvCBOUZj9aC8WaDqxlgghB3ySGFIlhHlPq0GM4qQwofnWiQ1o6niuzqEgs
	 ZBP0yaC0tyW0rkuZJz6NGyo3112oYgfw1w5vSOJUv7asgRSyWrXPILSBvPtR01UkmE
	 qxzYHIR+Bl5CMhpVOZUJCp5lZyu6LiejdVXJwInK4OnUomYkPEOa6NlhcyXNtppN0E
	 /wPwluPfug4AA==
Message-ID: <b161e961-eef4-408d-944c-eb352d3088fb@kernel.org>
Date: Mon, 23 Nov 2026 12:10:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: Report page_owner_sort output errors
Content-Language: en-US
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, ziy@nvidia.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
References: <20261120062146.98518-1-zhujun2@cmss.chinamobile.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261120062146.98518-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8185FC0006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: frcznhfgrarw7hezmogjnxcyk6q71ny4
X-HE-Tag: 1795432225-177517
X-HE-Meta: U2FsdGVkX18y33UoZEAzsTsl4UHHUkvzBwnBkh6E3UOUwDzleWMP1lCoBe2r/WSAZWmXsIhfwQdHvsswXOJGFOqqAGrZFM/TbVovezBG81KQUyGJ2P7IGacDtFcI+t/DVF6qN13lgXN9xGggU3v5CMTtcZOY3wAao3EyQidMLTFvUMU2LlRR1VTLOnwio5ZNhMcigAn5MsZpRG1dMfP3R0VQQljnL8SWWf+iCkpZPLise+He8uMT1rju8ai+aj9z/IvQiXiPZzwPgSuWXrjgh8sDmSHn5jtih0Z7bYu4fsr65kZbzeH5AUc96i0tguzwoIvOMalR7ySR4Cu4gC3JzzM2/YKbLq6r9mcHZ92L08HZgNPx0vKpQrBjFlPkE/l7N2kRKJ4eRPegw1oOe4VuruezsifMizt8dq8JMfm8yGTc0Vgxasnk1StlxrR0exsDKFaUonIxzaog/dSVsSDfWYyaWIIYRR1H2WYHPo+l++HJxJH+WBO1jORxTcALCVn4ejLscuS3Ele8kqdg9U1P6Ik1xlgKFlvIyacMVnWpV7gdNcpGnsRQ7gT0qN2CHsZPuGIkjGi5eO4/tdpD9sD1Rea7IfBJ/s+S5J4+p6cek8T0aVmTkdzB8a6yyJ6k5XOEdElnNmLBNCukkkY5scpb2XraInf3Om5W2/Wah3UskIeCK3jV1mczh6BIujtr7WjQrocoKKW7a121toiMbRzPxulnGP3mWf62mzomoG99ddZSH2By93b1DaodpsSvPaR6JgXgQsl9Usi5olG1Kq9mym1TK35LrC2Gq0lKoSHpoNAWztd9id7/EhOJPZ46DvNqNP3PQ2+wpEFldJM1NcWH6V6KZSqUudccE48tImrA+Ib7jeSPq1R94Yev3Xyc5uexEy85gldiVscg9NvoIOJ4gx/Drnv0TEWtZ6MotwsprQJQ8AV4FOLzqAvQplhJRFIAXVexfsvf9YLtrQn00NT
 qgypH0dF
 6CItF0I++G/LEbruonaDJ/pFonEtQBO4yWYXlr29ciK96UNXh4JNUGbnfp6rXZrR8fPb9yMdeiCSLZPkI2FHx6bXBTe9gWQ+A7XtmWgVRjP7p6po1FMjW38RvaAi5xEIp4uMg2A/TMt999XbijyZKPbJYMQqTvNvnZP8HAap4OQKqbtl80GbaBf4NKxskX8Ku9alj/DGCyJhBnrNrLMLriNY8Pr2PCj5J/GQrubufohWt2KvxQySmMDihKCreznvJcFwhInpV1mujqeXRwstw1+s5V+ZTuFzzvNXJRPtuzS5yE9pUDY3EMnY8fNmOlsFRHo5nzYy5lsZoAOSpsQbNj9VxYGd0lMQjYwxlfpuCUHAnP6/4xWPKFTd0OcEc0pSFJaXul9jKO5qB72p3QFCnmLmZwY5ktWOhK926t9+91mIrAWQDqIEtVgXNX8RICWZzk9oe1bMynQIVm5YgEv9a8vQ24BgZsfZHmRXqt3dnUIaA7izB2nF2WFsawgqbU7S01uo061RKU5QeIg321dwsnTZFP7mi9j4HYsQoYuXWXcS/lGJGM8eNTNcKbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 07:21, Zhu Jun wrote:
> page_owner_sort does not check its output stream for errors and relies
> on process exit to flush buffered data. For example, writing a small
> result to /dev/full returns success even though no output is saved.
> 
> Check for earlier stream errors and explicitly close the output before
> reporting success, so errors flushing the final buffer also produce a
> failing exit status.
> 
> Fixes: 48c96a368579 ("mm/page_owner: keep track of page owners")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Applied to page_alloc/for-next, thanks!

> ---
>  tools/mm/page_owner_sort.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index 48c403d3de4f..13166199ef0d 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -1024,6 +1024,11 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> +	if (ferror(fout) || fclose(fout)) {
> +		perror("write output");
> +		exit(1);
> +	}
> +
>  out_free:
>  	if (ext_buf)
>  		free(ext_buf);
> 
> 


