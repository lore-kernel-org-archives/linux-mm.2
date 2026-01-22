Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD451D6CFA6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2F46B036B; Thu, 22 Jan 2026 17:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0808F6B036C; Thu, 22 Jan 2026 17:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4866B036D; Thu, 22 Jan 2026 17:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAA416B036B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:18:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FF111A23B4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:18:46 +0000 (UTC)
X-FDA: 84361015452.21.B5D92B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B047CC0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:18:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K06xaslL;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769120324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7nFy+bbosc/INmBF1MjmVJsyyI+qQrCi6Pu3NPmn3c=;
	b=3/dDbVjPN2r00eL/UK9+PIrd+zaMrTzG0EmRFVjIMn3HQLCXoSEM803V+ufvTWTd+4irWG
	KCdH70LGW2IYw/xIZg4j1KXj87d9oAiJ8PGqLK/idZGScWgIcKCK+3o9+YyzJC9VqIFeaR
	V8dXZRdRI5mgzKbzYHi6OiqM0wvRBJo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K06xaslL;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769120324; a=rsa-sha256;
	cv=none;
	b=VZuNn5UjTZcuBhdpGamnD21+T3Z31yhvwW8diyrigcK+hJ8wg/Dp/5U/N+4gHqzDic3F+7
	odkFsjlmchho2mnlQ6Vj2UiKrQUR9EUaeiwg5kO1rIrvIPVpZzmM7bfJPuNXTqRaejTmGH
	N5l8G4JR95gitTo8mheyyl7NZZ3Pi9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3D984086A;
	Thu, 22 Jan 2026 22:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06016C116C6;
	Thu, 22 Jan 2026 22:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769120323;
	bh=NchGakzlqe0Kol+7RMYnpk/2+zt7yGePeDcQjpO3zeE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K06xaslLMZ3tUNafsq2B+75IXysAVeG5Q2P1gRWSeA0di4iVJ94M8zhmjJl1SRuLQ
	 5Doau9Ij3V/RfnXuBkKc/7xFflVc0nH8rvdkiAPLARjJ9l3MNJScEsoxcELaWcCKT5
	 TH2jNb+23VTMiwvglqAOgoxtOatrvu5ut4s/ffIkUZc6mVgphmjvg/IuKxm/BvUGDB
	 4hTYbM3g6DgFanvvrpiZzzUhqDXAFllkSgWTPqHUYBwbhJxHQy5PqM5d3e1Sgd5/NZ
	 oaauEbMAOZzIwCwRu25+OLaWaY+NW5PgRECiFiH9gQn8psz+JBXMh1d8VfZ36cLbdM
	 dF9V2E7nAyEpA==
Message-ID: <fe1ecb39-abbc-452c-b3a3-61d63ca32244@kernel.org>
Date: Thu, 22 Jan 2026 23:18:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] selftests/mm: check that FORCE_READ() succeeded
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-6-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260122170224.4056513-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B047CC0002
X-Stat-Signature: yfa4atcxuagtopdmq9c39sm7swckuu1a
X-Rspam-User: 
X-HE-Tag: 1769120324-78871
X-HE-Meta: U2FsdGVkX18kzjttPxkp7jbLc688ij7BCUitCD6ubXNOrxHACBz+NB7Vaj2DyULxIuhO4sy5X/fyuwZFq8mBFlK4VWkbBAV6CnSavu9yLG43h92cUerJIPcLoXIayDWw1J0WMCxFps7Fq8rIAwj8eE9IpceSWgdet/e3QVJ+8SvKa1rtBAa+ilFRGx0obKi7JPd1IIsnGNF1rzQLHz1la1xmKqECHmnP22lxb+9VJgLa3FXs8qgXNuKQf8vGL54DzzAcUZ01AjJlequBojh/Dn0Tvedra2OJB6ZCZounX+YA8X5Qun+ACCRpqqmP+voVtd7aIkj38BcN+vphDKgUHZXOFlvA0q+g+eydCLzyUjZvc7thbWHRDGNMildzc/loxYLnaKwpOVyCa9Hw0Ucm+S/Kkm3TJTeXt0D7Qy1fW55xHsmnmIMqc4fFx2/cKjqPFl1LA+D5ZxVjFUJiLJuKPpVXJhDYrYXnegqUKi2s57HlIqT9aqmUwkd96TTJKmh1GxClwGSBHz6V0YsQgNel2+wNLEshI9kMKEXmDNFhFJK4abQhdzn7Eptqn2XKNJwiTELfegUd2fVL12tP5Ng3ShpRXv4tLMcXRjEdMO6WBdusS4iASo8pDStkQNXOacmMc3l2wFwsj1lmwU54HvDMIBtf4+wCsds3XR+WQRIaSDoz3280St0h3OxH0q3z8ewob2/gjA12b4+TisR22ITLTUZ3r3oIViRW5T21Cib8+0CHEk82mM1w6R6VZMSyOCLKm1jcst8xo/RrZx6IzX/iQeXaKZiG3pOzkCWdkdIIrjdNUEhz68W2NvRL9f7xNhlQaZEgowZMlfL7vC7hx1Hjf3u9g0rY/KBVmzYlauiSAn4zD8XhrqloIC99Kgldink2NnPvEKfZHWJotoNVmakVcgo0RoXIE3XUYaKfbAnOFBaqOUHEa6F9cuZVfxT84lV2JgY1nasIxR0wgnRTwCT
 FdmlUeeX
 /02xESZ7qZwWrs/QzvjZKTRSbpjpZ6VgncsdkeoXnBn4WuSKSMZ+sGN+puQ7DeoXYeOu1TpnpberItQiCVmfEKgnu0ekiOtYlzRuPugb0aJIE2qUTmzXHbAmJ7lOSE+x7keZRaQbguuCSwYl8cEvtpxVy2wEFnSqP0qgd1078YXqTryKXmXxKaDfHzXC+tfc29WVh4UxTZOpygq3BIiw8BdtK3ytbC3AzV/fYsdN6J3mo/5mPgSZbHTVwzUX+/fLscNBD80jk9fy7VcWgUjVWDToZPo2HyA+TDameJdqvtGPRZjYt3g54A+ZMuNl4x3ZnsIR/DEyxUxHtgExmfWyqrh9+pk8pGzaKCQCKoStoIwolePo7cbzckex+OEDd4LJPlM5M3UO+C0JFCKc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 18:02, Kevin Brodsky wrote:
> Many cow tests rely on FORCE_READ() to populate pages. Introduce a
> helper to make sure that the pages are actually populated, and fail
> otherwise.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   tools/testing/selftests/mm/cow.c | 43 ++++++++++++++++++++++++--------
>   1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 83b3563be26b..d9c69c04b67d 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr, size_t size)
>   	return true;
>   }
>   
> +static bool populate_page_checked(char *addr)
> +{
> +	bool ret;
> +
> +	FORCE_READ(*addr);
> +	ret = pagemap_is_populated(pagemap_fd, addr);
> +	if (!ret)
> +		ksft_print_msg("Failed to populate page\n");
> +
> +	return ret;
> +}

LGTM.

On second thought, this primarily catches if someone breaks FORCE_READ() 
... which hopefully doesn't happen that often? ;)

Because if the read succeeded, surely there must be something in the 
page tables.

-- 
Cheers

David

