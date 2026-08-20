Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2D4C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 17:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1B76B0095; Thu, 20 Aug 2026 13:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752186B009B; Thu, 20 Aug 2026 13:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668B26B009D; Thu, 20 Aug 2026 13:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBD66B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:31:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A948F1C0B11
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:31:21 +0000 (UTC)
X-FDA: 85122339162.13.A9BD694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CDB51100007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:31:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCCDxpSv;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787247079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjicE+rPS3y28uBHFm/mdXNkgiy6AiD+cc8tWN9zzKQ=;
	b=4jZtk9ZvQ2uXMV3wBlp5mNhJbZT+bgKconMjCcaNzJFVB7jtsBOP5l6IttUs4dktR9r8M/
	neplfCGPbIBhw/ILUzo+tcv1F9JgNVlIuGkA8V0YwdP/dGsKBYbxKg0LKbf20H1HgF+inj
	b/zZsqsXWqe9bWormLqnOtSzSlNFLDY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCCDxpSv;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787247079;
	b=NIy/fwgrcRI+MfRA/ZU2BnyHhzl2MIge2kCuxin97xLHnWzB56TU0m3m3eJwoORHuup9LE
	3Ng1h/+bQs+39UMrXIJlMdsJfbCU7GghbHj76f7oO63DgRw4N8PqmhOSAzo/Mevb9SN6Jx
	ghvb++9cxRpJ7maGugiWNLVCdNvjKl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C857240F01;
	Thu, 20 Aug 2026 17:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022931F000E9;
	Thu, 20 Aug 2026 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787247078;
	bh=RjicE+rPS3y28uBHFm/mdXNkgiy6AiD+cc8tWN9zzKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SCCDxpSvivp23EzOE1anqeLvcDunLreP1GHlzp1LfpFY+GcLHQmNpuDuVwiuxswyg
	 6pU/mDROTUz3lyhhgfJyfthTtE/Jdk00OjuHXtLkxWXefgqyCCYhw/katvP8i5AqSg
	 +vUeExiROM0WniQYhy0kPjBFH4gikpfeIrvf5rJT3PiTRfMe9k8LoW29bKjX1LqsWT
	 kTkoSnnWqiilN7zLfLSi8+28SIR70ZlE0FKP+d3z0IjNSTtPD7eIdF1/i/HuN2I09P
	 7/5/1pRM7t8Roe4qLV7UZ7HgMovkF7U4BvSEO53aWBRtTZwOCfNcCJNyH8GpBY7wNC
	 lFYbJ229M54BA==
Message-ID: <00fad295-132f-49ea-9a39-0febf0919ad5@kernel.org>
Date: Thu, 20 Aug 2026 19:31:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check stat() return value in khugepaged
 get_finfo()
To: Anshuman <anshumantewari123@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260819121426.49500-1-anshumantewari123@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260819121426.49500-1-anshumantewari123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDB51100007
X-Stat-Signature: myytfaapnfgswwh635hizk76hknhoee7
X-Rspam-User: 
X-HE-Tag: 1787247079-86687
X-HE-Meta: U2FsdGVkX1+cC72TDnLUieqQloLBTo8eD6SF6DZ6/ezboTSlffHCwNZ3iPzmVie0CNMwhS118abH4wnMYhXarrifFAE0teWMuQF/AmYhItq4VUxftMO7C+/FKECks0QmN4lO1gD1DM9imSbiA4KSA3gS/mkr8SMWQQSlLrHPoHs2dqg9vPiTNj25SWUefopdQZQKHIq8KQ35zInsGHD6D1JrHe5i/jvlKxhNNOWzqGWzOfkjB2/XNmtCZXq74q+eITXJuM2nALb41lhBONqiX9n4FofplNO014RyB0/Bf5K3RXFPNwfulP0YFFziorTI4YEBw9I3zWY8iZk+8ACRy/BsKvofGawTPd1embhUo/VXDsEu7ZQFdErsrpSJoW9PYjWEn8fLKnleTSUquUQRc9O9nzDzTq6qGj4T4KVltBIeCKoU+LJpVHWXsLBuJtRLuZBa/DrBsQ614E+Ox3tgY2qT5vGh2NeSBTzY/s3Y6keaYvMSu13dk7wTPGzUzdec9q1LBQXZRef+SgQg1j16KrKcXQiUYWZJYIIP8VIJcj95jtSBZmr7yKEun1u1ELE5GE0TXD8lsQ3ltDArB9JDhpjhRCdy+lzUK10og8YBXOzG2fV2NnQG7623ABUIMTHHbRIlsTLD2r6Ek0KOcPGpOYTxNf9KhleXwLhRJHHfsw2Mz72id0YeuxIpGFOCXeXyE+xNDaVe+V1TOdXTF4CKTsCsHnepdRd4SIhZxVjfNBPdKXZ4S9brFJOdiQOLmjAILSNIcgknHGoKiBevrf1hV21YgVrv1TYbD3Sn3xGsPGZjY53SRfQ0zTZXjbfNXIm9/6VOnhm9JVIia3hENLJyq/cFW00drYjLAkmiHc8bC61Lzou5F/C0oVOHsDJ5WCuN9Z3JVMh04X9DsT/dzLubRXM7g89y3rBPmH3Xv0AxW/AwNQBVW8f9oY3HD9C5Ui+NTEw8X9NWqJEwSPHRg7Y
 ZowEY1L9
 7nq6K/UVg5jhmjRZyydqsQxr+ef7XTk5qI+FnuG11m1QLGPadcEZSgQDYilLLfsh37TC8HGuHLcL8Yx5o6m3sEBfev75v2yJsX7E+yimshBGZu7m5ooiJBojiU8YE0i5ulnXZkaMSv2Va65uvaB/EapCD/IryYViVx1Pj/DfIvMcMf42yOATdUwO2ALj4uuZYgRuv8ALnmDfNFI7BSQlf3btDkqc5boBgrLjd1srzHAYNnn+bW0GSDnp7mg6BRasXdCkdzzt69Ss/OIol+YAJlq6a3qPnmUkuDpUit31Q828vyBMYMB2KeuIYLTlkfYiA5ZEe5JWUtFlYNdjUN0ozcqGkkIqR2k8YhHx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 14:14, Anshuman wrote:
> get_finfo() calls stat() to get metadata about the target directory,
> but never checks the return value. On failure, stat() returns -1 and
> leaves path_stat unmodified, so path_stat.st_mode may contain
> uninitialized stack data.
> 
> The code then checks S_ISDIR(path_stat.st_mode) against this
> potentially garbage value. This can produce a misleading "Not a
> directory" error when the real problem is a nonexistent or
> inaccessible path, or, in the worst case, the check could pass by
> chance on garbage data and let the function continue using an
> invalid path_stat for the rest of its logic.
> 
> Check the return value and fail with a clear error message if
> stat() fails, matching the error-handling style already used for
> statfs() and read_file() later in the same function.
> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb..2240a9b4f 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -121,7 +121,8 @@ static void get_finfo(const char *dir)
>  	char *str, *end;
>  
>  	finfo.dir = dir;
> -	stat(finfo.dir, &path_stat);
> +	if (stat(finfo.dir, &path_stat))
> +		ksft_exit_fail_perror("stat()");
>  	if (!S_ISDIR(path_stat.st_mode))
>  		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
>  	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,

From out selftests that should mostly be impossible to trigger, as
run_vmtests.sh will just create that directory.

So it's a valid improvement, but mostly irrelevant in practice

1Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

