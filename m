Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44850C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62EF6B00FD; Mon, 17 Aug 2026 12:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13356B00FE; Mon, 17 Aug 2026 12:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D294C6B00FF; Mon, 17 Aug 2026 12:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A05D56B00FD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:40:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D5A11C1C25
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:40:23 +0000 (UTC)
X-FDA: 85111324326.30.1AE29B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F7674000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:40:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDOTH9QO;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786984821;
	b=4rsWIMha6iS7bhr1ZCOwNNN6BO75rt8eNNBDUd4kiHY2Irv6xYQ/g5/2Xe3n0ORsVFqqEf
	xlToBLORtPs5fLsbHHWSO/QnhjCLEsWE5IU+A2aurXykzt9fqsmWaJaLtQMv6J8gRhOweX
	Fyq7J2+vCl9GfN8u8qSYC3/zxjHaLi0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cDOTH9QO;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jT6S4YpgQH38JdW1g0o3Z2pQ+/PX/2D+lf/1VEYoUM=;
	b=ucpxCL8n1Eq6tgtNe1m2g9Xif3uo4UIfBFogGtjxG6r5t+0FbeLDsTW/cgHz8cjNl94CBO
	RhJixnVRntLr+fwC02o4fN94tWbPsT9aoM8DguFGWE9chtu7aSVkcpdIZ8NMbhd/otlJfl
	OrEiWpIDjgkEgPq0bmg3fqjNjp89Gl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0A4C601E9;
	Mon, 17 Aug 2026 16:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB001F00A3D;
	Mon, 17 Aug 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786984820;
	bh=0jT6S4YpgQH38JdW1g0o3Z2pQ+/PX/2D+lf/1VEYoUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cDOTH9QOP614hNdU2RzYQKCefqWgx4OS8MfOUYsoBt9GFSmPkuy1Y41Z3NBnfEg4Z
	 j1JPK1rUG+dUR39kkDskXbp3DfbW6GMesGUpeUmClpdeHrz0qGgKP5um+Oi/Q76Yae
	 0ClklYuvV1wXKhqhFcs+Am4ZCLHrkdgU7y7vmYdRuqgcp6zxIhFhvdIaohDKMvY1/n
	 +Xvk0jf6apulJTeyJV+2oehd9tfUXhibM2lZrG+IA+Bno2CZtHfxsV4RQe9TAIYKb+
	 i08W2vLBg3+wHtnz01DcqXPJnpVZ37pqpqYIZRGjnos0Cww8aILf9zgIM/9Kwv+WgO
	 gRlI+vaXeQIhg==
Date: Mon, 17 Aug 2026 17:40:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, rppt@kernel.org, sarthak.sharma@arm.com, 
	linux-mm@kvack.org, shuah@kernel.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Message-ID: <aoM5S9kq3aPEiMT3@lucifer>
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-2-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815080716.3596514-2-husong@kylinos.cn>
X-Rspamd-Queue-Id: 6F7674000A
X-Rspam-User: 
X-Stat-Signature: ggouf4i9397qc4yhftw3otz4nhiiyptd
X-Rspamd-Server: rspam06
X-HE-Tag: 1786984821-226438
X-HE-Meta: U2FsdGVkX19+4XnQ4/1MvTaW8nsP9h1DeSBP6Cx4eZp09Wc41or8R1vGwYQNZs3+/lK11uPRijgSBfcY3fnQ6b2DSb0z7GHIn786PqUDwhN3POOVuGx5oB1zHVOcG/dI7xYELC2PR6PcIbY36ZyqEPEB75xHvxFjN+AQDUsuSoXPVrhpQXLGG4COBx7egihCqgUyvJGgJd6ppjHH9k7s1hkKyG8fPPrVGY3lE4QphvPPbGwpUUnooPbRl6KP684+l3FKJieXYyD0NNli/fZCG+X0J/AhXNV/K+I4SOqkmO5tWunvTEXcn7fa2DZLjv9jclhUTi9GLekdxEc9l9BlwsZYBXvBMrey7Hb+4TZjkFq7WukACuk3M2kJd/kuPoNg7ARpCNPiSPYsx2EUlmN3NmLAf46mbGElj5VU9PrsketWxQyNmOPJpueRm4ddAEQffepocHSN8B4vXSLrV65bBH8p7LMmOqS6xFLGl81DpOVD/i/N3EeD27TWTIcXP9tA2mtaGQdcHXu2nO1hftWdo/KARroRvMdoptqjxNW0a+BPCLnrqV0d7g2t4C7saRfjTU8nlYRWTHS+3YB7Oq2lv/J/KHg0oQll0xT04tRkZdtQd+cFDWX+TlZfnEsqQD9n2hznjcJFZ3prq2SyX60EmIhXzx1hvREEQXzqw86yGY4SP8SOx10CbsiSQ+z9tAqUcsoQdVLwf52KQfizLNRhMhUovRIbqTSlMjF2iLcqqNMfBm1hZfDi4EiJOV6xzBHMoGbi8IgQo5lgxeYlfn7RrrW+SlA+r1Czblsk4o6wxIQHS+iaDYsqqfTKNvSogfUkFCNuCWmW9uhScDObYSC8dywpLxpk8VAvYkpIVROsB2P7Q+5WXgzsm69D7BZISbN68Ra7acwP8dbJNc5ZNaLtGEeOOIMzc7ffoiAU+sTCVvPNW8kxqbz/n9pRZLqkdpKI+YjeojBp2OJQlHWupmd
 abR2miAe
 F4AFp1EBAxbIoHhds86FtzxAELPOszbYFHNyWkdZCPNvgYf8qw8MoRfcEONTipmVaBb2s3Tx+6X8TXKONdskBuk1NL3tOnhpwMQJy3Z3gdgymG1IVzMBVMarYe2iR5D1pV8uOj7x+ukpIp1nnNlIAIXCztbsw0Dy+5JTrvmD1z02aVmO8wCmr7oBoEl2WimT9BAgGn334ZXso2FWFIKp6ssnKmGwsStKwpqjFK8w8UqFJaJAWRoYoHFlKwFmNQb3hlmNxMkKbBP5YscncmZkS+/SRVlheFXiYC3X//4X/JDr2QLjpfTLi48H8Kg5fSBkZNyGCIGSg9QFeYRZlbB8ThGC3cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 04:07:14PM +0800, Song Hu wrote:
> uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
> output is not valid KTAP.  Add the header, like the sibling uffd tests
> (uffd-stress, uffd-unit-tests).
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Song Hu <husong@kylinos.cn>

This all seems to be yet another way of saying 'somebody didn't use the
kselftest harness and so things went wrong' :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index c973d6722720..572c2516e874 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -347,6 +347,8 @@ int main(int argc, char **argv)
>  	struct thp_settings settings;
>  	int i, j, plan = 0;
>
> +	ksft_print_header();
> +
>  	hugepage_save_settings(true, true);
>
>  	check_uffd_wp_feature_supported();
> --
> 2.43.0
>

--
Cheers, Lorenzo

