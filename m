Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B896BE9D812
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 20:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1DB6B0005; Sun,  5 Apr 2026 16:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53286B0088; Sun,  5 Apr 2026 16:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68826B0089; Sun,  5 Apr 2026 16:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0FC46B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 16:21:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60E32B3AF6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 20:21:01 +0000 (UTC)
X-FDA: 84625621122.22.D166472
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B916E4000B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 20:20:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C7mL6Zq3;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775420459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esAOhrYsBJl4/B+9cIQnNRfmu31OzJ0rintMp1np0FU=;
	b=8PpIP/9GKCn8Ydq3iPKrSSfuFm/TD13H82EKoIxO9QBjo4at2ytwBfSSVkOEqMQUQe9Yit
	SU5MrTOkY/cM1sbavnr9WwbpeS4of9VH3o1Q9EAL+HtpE+6n9nEXsK3Q+mZ5JJYuYC0/f2
	6cyBPrCKERrEueqNFsnJ2DD4b5belZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775420459; a=rsa-sha256;
	cv=none;
	b=tTmDd64u+mHpk9MstyU3hlv3T866X3qofUsBrMMKFyJGySO1O2ZL33ZmtFmrxi+B6HJE0D
	IKcpNzMpEbQ3Ai36ns82vzBf9JCfOC7wAGvtqzgiwh24ZiW2GiXGb9zH8Zn+1dfG3y5WNg
	NgLjy4QCi0v5BGVDP6UxztvdJvjej5g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C7mL6Zq3;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7019A42E36;
	Sun,  5 Apr 2026 20:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA2EC116C6;
	Sun,  5 Apr 2026 20:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775420458;
	bh=rocj01UV7BIqAUTcND10h4o/563Z1X6DhrT6J4DgXzE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C7mL6Zq3D8NjVhvUHH4xW6YUJTJq+Kt/xW9f/ZvzxSM1s3HbZ3Zwsd0PQjaM5zpLq
	 PaWy9pOvBRSOwWd3f9cSexpZozXNoDyk2ucDP0bnXxFEqmnABJoA1u5AVNqO4Qy1lY
	 z9a9ngqvdZXG92K0E6/C084DZ0cdUmlu4C72jlQ4=
Date: Sun, 5 Apr 2026 13:20:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: CaoRuichuang <create0818@163.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH] selftests: mm: capture write_hugetlb_memory.sh exit
 status
Message-Id: <20260405132057.c1ae7267911c5657cd5a3fe9@linux-foundation.org>
In-Reply-To: <20260405194623.84218-1-create0818@163.com>
References: <20260405194623.84218-1-create0818@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: e7ya66kxhqq1kok5419zis16sxbc1e6d
X-Rspamd-Queue-Id: B916E4000B
X-Rspam-User: 
X-HE-Tag: 1775420459-827451
X-HE-Meta: U2FsdGVkX1/A7dSGs0dDjbaymluFDYvhDyLrZyf/0U/BpFr0/Hbj2qiTXM4WBbZik+YpGTQSD6heZzpLEC9IJE9O3Z8aqUuFNAoLqVH2xjL0y0HudzIiX8YtfE57vJE/KRRjVIDGmE8a6HhNmGr4bFwSkbf1H20Lf5n2IX5JTfzux/rsRflONVbZx+LPgkW72/nV0HuB+zqbGfQC5BnnJ4/DWN/CjSUCipEubd6HAOzNz1kSPIL7ZqBKggc40YZjnRQ29yXrmoumkPoP+t8vIup6iWR36fODShtJ/+GQ12t4asW2t6rF61+wN0iLTb1rh0TFbp5bwev0151NLQWImZmzBapYRjpvCO5L3WMWcAIRKzmBfGg+jeBBOPeDYmKOH6ruony1kcugIMdfrCsN0oY4RXGXdQAlhsRNewvQkJmCCtnYkkTAijZ9c37sfskOg+CaY5I11IjLEXtYUTSL5RY5WX/mapvrsVpg/KD4P2zMbjaGHkfPcZiV58Z1ZC+fo9WZYdDxDXirzcAHORAAoY+Q30RPWBJZpq6g5G4mu5BYd8/ANQl0F2YFqzUw1x1t3C/NuoYzlh+sbzNnglVDoElvOuHPrLe8j8diLSVpDlYcUfzYhjglpOpt23j7e4JtKadPVg+fePuSpc6r5IUFt2flQ927pDEVupnbSNLxUvFJtdBC8XOto2MJPXZ09H3Z6SAlNnmnCNwaF9ZzaTjqnv7vlnyiGaCByLAgk67Idz7Bu6NFQqt1DZIwl1as+lRULJUOYcxs7qjpf90n2ZDni3XgQ66o6XSIaf+HzSTK9cT81swUq0R9elIIha2CrYkVZTuo9AOuU92fqcDhjhKFx4KK3Tm3Du3SdIGKTD0NSe/yXyjvElb8xw6YqN4v4My1QqTO10aCKKo3FxuftjwDVoEj5eYqbLsSzzlCo+RCRam5E7MNJ/ws843Q/oK2Pg6aqkw2eah4Er8KrNoqTRH
 JU/P1Wsn
 GZM4s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Apr 2026 03:46:23 +0800 CaoRuichuang <create0818@163.com> wrote:

Please word-wrap your emails!

I fixed it.

> charge_reserved_hugetlb.sh backgrounds write_hugetlb_memory.sh and
> immediately stores $?  in write_result.

Yes.

> That only records whether the background job was started successfully,
> not whether write_hugetlb_memory.sh itself later failed.  As a result,
> the test can miss reservation failure and OOM-kill outcomes that are
> inferred from the writer exit status.

Seems that way.

> Redirect the writer output straight to the temporary log file and wait
> for the background process before inspecting write_result, so the test
> records the actual exit status.

Looks good to me.

It appears that this code is from 2020.

Question is, will this change break the selftests because it discovers
previously undiscovered failures!

> index 447769657..2f52ad7c8 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -193,9 +193,9 @@ function write_hugetlbfs_and_get_usage() {
>      [[ "$private" == "-r" ]] && [[ "$expect_failure" != 1 ]]; then
>  
>      bash write_hugetlb_memory.sh "$size" "$populate" "$write" \
> -      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" 2>&1 | tee $output &
> +      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" \
> +      >"$output" 2>&1 &
>  
> -    local write_result=$?
>      local write_pid=$!
>  
>      until grep -q -i "DONE" $output; do
> @@ -223,6 +223,8 @@ function write_hugetlbfs_and_get_usage() {
>        sleep 0.5
>      fi
>  
> +    wait "$write_pid"
> +    local write_result=$?
>      echo write_result is $write_result
>    else
>      bash write_hugetlb_memory.sh "$size" "$populate" "$write" \

Do we actually need to play these backgrounding games?  We run
write_hugetlb_memory.sh then synchronously wait for it, polling its
output.  Why don't we simply run write_hugetlb_memory.sh synchronously?
Do away with that grep loop and the replaying of
write_hugetlb_memory.sh's output.

The 29750f71a9b4c changelog doesn't explain why it's done this way. 
Maybe Mina recalls?


Thanks, I'll set this aside for consideration after -rc1.  I expect a
cc:stable will be wanted.


