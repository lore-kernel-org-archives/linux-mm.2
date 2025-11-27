Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D9BD10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504756B0024; Thu, 27 Nov 2025 00:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBF96B0026; Thu, 27 Nov 2025 00:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A416B0027; Thu, 27 Nov 2025 00:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30F366B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:06:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBF818A716
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:06:33 +0000 (UTC)
X-FDA: 84155201466.11.DDBFFC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FE35180009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:06:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUD3vwtq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764219992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guF7Lj4nWdsNU1YLYFJq5L2Aq8xT0jiis6yG4uY/Ukk=;
	b=JVhaF3K66MuxkRpHP//sUb5x4AnfctzjS3ymKTVyVgBT1k7cAMWrl4NoC0HLzmvedWEJSa
	kg+Uh6JS1B9oOImA5/0FSvqJUkbV5nysmx/zSzFqQCXWPl9WK0VMoPlkgjtagr5mrTG8PA
	MQp2sjmfetGPkSCTGym0SPZ7geQad3E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUD3vwtq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764219992; a=rsa-sha256;
	cv=none;
	b=ROwDo21W/GQAIhbMDifDAAZpE2ZwkTW+sSuokESsL04iLx/z9OZTG8qKgkVtoV2KouZ2P5
	MDHs9cJ3uEwdxkTjMJ/zWtXFC+Li1LS3GKLd/3bK9yexPcx5z3vG2qBMkQ2l2o5ZLqgdZ4
	j68ycbAq2h7FMI2x0oeOftZwRDF2Nm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7ACB160235;
	Thu, 27 Nov 2025 05:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8A2C4CEF8;
	Thu, 27 Nov 2025 05:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764219991;
	bh=9KGqhg7bfj1kYxRW5hx3J4260dqKwUVUWWB8jKANxiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bUD3vwtq7DBusOVYT88WRzd+l/tl2pENfsZwVOzSdSHlfCnTWpFbXAu6vZ/BfN+Yl
	 UtYgdlJ9Ie9rQTLqz0tyCxVyi961e4bJxwzyIWuWKTFWdLYGVeLzjbdItUCAg13aiE
	 BE6dKASgyEYwWa2dpYUCu996Fi3njrLV+lyaTqwk9Y2JnLt4IEKuVrv4h/+yao8S8E
	 pSb4p+Cvy8kaBP8Lo9ItLc0DL6Tku2JF6nBKYUehJ084XoVltVazaxVUy+FrwYmW/z
	 4yJBhzu0hHzJ9xaVXrYetVXrNW+ZVt+MW7hIeuetUsMKMpDTc0i/m8oGMFjD6y7S0y
	 glXNgVD1nCzWA==
Date: Thu, 27 Nov 2025 07:06:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] selftests/mm/uffd: initialize char variable to Null
Message-ID: <aSfcTS3xf64zLdbR@kernel.org>
References: <20251126160830.52124-1-ankitkhushwaha.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126160830.52124-1-ankitkhushwaha.linux@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FE35180009
X-Rspamd-Server: rspam11
X-Stat-Signature: s8cmphxichc5z5giiwq5ncuza6jr7s9c
X-HE-Tag: 1764219991-4964
X-HE-Meta: U2FsdGVkX1/BLKVjjGyoSKxdc17jMORskBrhFDpoqqAJTrT2cu9OqTZNupdc+ayN4m4v7YgN/AnKRHqKNFBf78rwOU/eV9BUElUHa2Fppi1XDIoucClsXhFMnoRMc7BEGU5y2yGgBbHMjZFI70QPVNe2IUMHMMQ9iRS+w0GVqwK/ANH3rV0a07UgZ1XuBq/bjaeua2m3V3+1k3sY6ETkO6OH3XyQUF8AW0druTXTZX4SZjfOOczjUA4R34mnOQD08XtsDFcoH3tRsX8Kwmf2ky7r86hJJIyCIUjC15HEiBdadU2U+9VgGHYp6Cg34IjiKpOY04iQ7tggRPUdNa6D3+iD0LYtmkIK3Eul4tanNHpyzwJijSjGubpBLSxl3qZGaakphFkCkS0IbpT9qzkCk3249wZ/pXSaXljapdOFSBO22vYXK8kXcv9YzzE6erxa/Dnr2Uh+2CGP4EhJfakyS1BK8iOoZ12xmyuujYnI+dfm2VPEzDnQW5CDOpDkS97rGSPPs85Dw6D4c4WIej78ooytmi+Homj6w8SxW7Lc6VMqX7FeTYiwRIfWC2ISsCulO33VJE0ExkcKdW5/v0Yo/m1D7mvFs5FY2T8rLDr3vsEwekyXwL+5f6LUVghYBld4Da8x7RWfquTAJNT8Vp5J4qbTgczPj8UluX+kQ5RhY8DAcRuGa0O6bIE0OCskWQ22fQvIFnyOft/eaUwO412gx5jb7Hu96rWzQieB629g+Jd8eUXiwYE1b0GsF5aSWdoi4kZcx5rgujQuhPs/ItQFeMjK2wdoEy4EUerP+lzDg1LKYTqUHyqzhbfFhZr3JorZN7H/v2a0AWQktQdPLtsr+WjGowo6qNMXSK7JOsaCzDf8najrU3Bvqo8KwimN3VSwGP6guCMhVmWg79PNXg9I2arQCfwN8TId6ucCyzZ+A0ocxAzj7ifv8tiYU3KKrUsMr5b5HlMjfFMPJizDXRF
 h6qnWhIW
 ViHjBwdMBkUNyYHJIXy930v4UMRO4yOSHI835lo6gI7aADm4z17OdvVOenE/vHxGx1Mt1oeG1wo4cMS5FePi5X7iBq3aDiSG2caLHVl3whPza2QjpKX824SaLURuARX8JvQ5cHckvVZ4I/Sy38cobt5i2YpfRghYIT+8lx6LLEBrx7keoqsbER5ub7iisq1womyFYPUTM/H5LgMbogqoYpyupheqoNj9yh3951Xudu+ZW3LdSULzA17NDN2Whxq/EnSeerqNgK9WFsDUUeDEpayxOQYTHIqusZlkUZ5U8qYb41i7gogomPT9AZjtQlvFso8yl+Wp/utn/09gLeXgJ1PgdliVLQe3DBdD1CL8ioiLA+a+UXDxYD5JfeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 09:38:30PM +0530, Ankit Khushwaha wrote:
> In "uffd-stress.c" & "uffd-unit-tests.c". address of char variable having
> garbage value (uninitialized) is passed to 'write' syscall triggers
> warning.
> 
> 	uffd-stress.c:246:39: warning: variable 'c' is uninitialized when
> 	passed  as a const pointer argument here
> 	[-Wuninitialized-const-pointer]
> 
> 	uffd-unit-tests.c:581:31: warning: variable 'c' is uninitialized
> 	when passed as a const pointer argument here
> 	[-Wuninitialized-const-pointer]
> 
> so the fix is to assign char variable to '\0' to prevent writing of
> garbage value.
> 
> Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> this warning is raised with clang version 21.1.5 (Fedora 21.1.5-1.fc43).
> ---
>  tools/testing/selftests/mm/uffd-stress.c     | 2 +-
>  tools/testing/selftests/mm/uffd-unit-tests.c | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index b51c89e1cd1a..700fbaa18d44 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -241,7 +241,7 @@ static int stress(struct uffd_args *args)
>  			return 1;
> 
>  	for (cpu = 0; cpu < gopts->nr_parallel; cpu++) {
> -		char c;
> +		char c = '\0';
>  		if (bounces & BOUNCE_POLL) {
>  			if (write(gopts->pipefd[cpu*2+1], &c, 1) != 1)
>  				err("pipefd write error");
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index f917b4c4c943..f4807242c5b2 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -543,7 +543,7 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
>  {
>  	unsigned long p;
>  	pthread_t uffd_mon;
> -	char c;
> +	char c = '\0';
>  	struct uffd_args args = { 0 };
>  	args.gopts = gopts;
> 
> @@ -759,7 +759,7 @@ static void uffd_sigbus_test_common(uffd_global_test_opts_t *gopts, bool wp)
>  	pthread_t uffd_mon;
>  	pid_t pid;
>  	int err;
> -	char c;
> +	char c = '\0';
>  	struct uffd_args args = { 0 };
>  	args.gopts = gopts;
> 
> @@ -819,7 +819,7 @@ static void uffd_events_test_common(uffd_global_test_opts_t *gopts, bool wp)
>  	pthread_t uffd_mon;
>  	pid_t pid;
>  	int err;
> -	char c;
> +	char c = '\0';
>  	struct uffd_args args = { 0 };
>  	args.gopts = gopts;
> 
> @@ -1125,7 +1125,7 @@ uffd_move_test_common(uffd_global_test_opts_t *gopts,
>  {
>  	unsigned long nr;
>  	pthread_t uffd_mon;
> -	char c;
> +	char c = '\0';
>  	unsigned long long count;
>  	struct uffd_args args = { 0 };
>  	char *orig_area_src = NULL, *orig_area_dst = NULL;
> --
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

