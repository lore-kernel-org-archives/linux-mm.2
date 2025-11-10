Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A47CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635D68E0007; Mon, 10 Nov 2025 05:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D1C8E0002; Mon, 10 Nov 2025 05:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5498B8E0007; Mon, 10 Nov 2025 05:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 433B78E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:33:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E102BC0C0D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:33:22 +0000 (UTC)
X-FDA: 84094335444.06.1CF087B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E0B1C000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:33:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4JOMTZp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762770801; a=rsa-sha256;
	cv=none;
	b=wxJFi0F4NyNDEGPMxpeRp3m2OAVPgSrc2YU0AAmjLcBc2LM/BVDqO4MZFbo7kIDsS42QQ6
	k+ry3qvI6QzcIqDicl5Hjw6ZLcfTAhMEYVH82gHJhgVqP3s10QJKac/LrxyNRAV2n3vaxX
	Zmag+rY/29X8rzSkVNBuhfCEuicWA0g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J4JOMTZp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762770801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYngT3P0x8BeTeoq5JfLyRYHdqrmCoWdHOiiCCLVumA=;
	b=nOIiR7zNioVB5Rh+L1eHZmE4xKLT0InvyteWN7CBVhHKWLsz1y7gtqcmNUVg2lu35ZeUC3
	IP3xwQ3TPTMeelzGGzxEYSCAs0TUhcVTDnrxJGJFhkutTODNJBnW8UEVG5K1wVy+/tly9f
	b970hjspAQ8/HsWYF+gAYgu0RaYJA6U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D19EC435D3;
	Mon, 10 Nov 2025 10:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E38C4CEFB;
	Mon, 10 Nov 2025 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762770799;
	bh=XGdAZQMoYX6Us3MCpLM/NxmAUfTsARkCljiFE1chCCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J4JOMTZpT9f7JobhPkEEVtMbrvMHN/QmyRT6CkgFjCdJG5tsJTSz8geO6tHzfz4MZ
	 GOtCv9QmePCfHi7gUxydKyaNAHExL86jJuMscDVKgAWHZ7EJQr57EVkxmdLu75Y+fa
	 0e1xo+JMgJNAA5omFi7cogT0zgMR1tsoDvsDgs7KZw1EhYLo4SQ8Go6krZUCmuxhX+
	 TlUwbp/UOOC/EQHwOjQ9q8LN4U6NTRoMDnhC0LYEYxbZTExqiiDH/Y7wbBEyqMfYlr
	 r1v9Pp87oj1/1F+lROk+yyvElmJFs/KQ/dMSJPduQqa1ttaRNf6qVKNo4lb44QhkeA
	 ibjK5TaviSRAQ==
Date: Mon, 10 Nov 2025 12:33:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <aRG_Z7p1jwEUsRy5@kernel.org>
References: <20251108161829.25105-1-ankitkhushwaha.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108161829.25105-1-ankitkhushwaha.linux@gmail.com>
X-Rspamd-Queue-Id: 2E0B1C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: nx36hp5rizfctc1r9mb973u556xiqcy1
X-Rspam-User: 
X-HE-Tag: 1762770800-400646
X-HE-Meta: U2FsdGVkX1/os8YgKZOmufhRePNH95GpAlDWBqdKTLdCaSqqt6eDDjBcJRPU0px/T7AUm/4NmE7W3TrT7TwpEWAoIT8jlP6JNkZk3IZcyg+PKhwqSXrBhPrVVfyaqMOpcSp5XcjlSJg+AihlHhMkqyot7XaC/U5n6W0Zblt7i1dNoRoarnflXUKczX22st0Ys/zorv/lMxFGnDcvJ4vEVcZ4vTlkfjKi9GcH9gOwePYLXlcTVe3fREpL5amZZLan8r49jT2jF3IzSqgQOughJWOUhqvzkRI2/eoYwjbVHorEFHaSIAV7SIEGuLuYkPS3n5A+xGX8FUkRKm4NS6botj1m3aXFwkPIXGBOUgjOqN39jtLceySiGe5utx41yYyL5vknrVvUY9n3U5UqRrTHT8jhJJ2cXa4jkwxcyzPSDXNYo4AuYsjh0PlaP0M80WKF11tUqFRmhTthF+4MV24XDqEf5IkEWtcUk3Ukahnt5QwgKmRFFzRvBIaCkwXwfr9jOxdHNfPHjVM19Dsbo7Ls67aWq5ork3lpg+eDKFpbyK2+cTHq65B4gtPUyhPScL47z/g+XXWWdjN0M6zoBiWrHT8wI4PrSD1KNXtJ4W7aT5EJkqLqeOQsBtMn89E5qbJa6StVn3da9C7Z2JmZCWc07UH1lZeCyXCci8jrmA45ZbzjQ41YJPkvgC3xLGPgyh2dWFTbG2I8eaJpj6YmR0dB8o/JbuCcKyJcmUGImWmlh1Z4QQhtu8Asdd6YZTqpxRcwjkQUVMhQESJAP95uRpYyTDPwhGpxWwgD50q4fgvDzqoDH0YQqUFIxszVgu5pTEKhxu8iuPp/EWT4K8gQA72cZLbOcCDZwClT8G9s4ZtTN3n2G4tvohorzydclHKWdKk+/4zqyeoA4+TiykltSQ5VQz0LdXJ8HZ2kGViRvzaFY0JI1QAK/wVWUaYMORlfc5x1Fa1Tf0KkwTe6Gn8Gc/f
 oLjUWXIQ
 /5NLm8Sy/C4fC6cM7NxKdHNClx67c3K0JRhrIn+JxkZKzMcNS11ygtbp5axH+r49qScRw1rEDpUpMfP+BslZR1ywz/Frp15ds5rX8pI3ZwJK5lF+Pvjt2D+W3su4tIPFFecU21h/1x4MOWdo1CG6baXkmFdBQgW2jfj8u9Eao/0czAT5l8EfH5W0R2CoHGT1LOMCatjdvBS3TOV4EsIWgJ+9Lzg4Ku4yHMHWcz9hIbc2ya7CSAlAD28IBUO1wjQKRyomp4CrqpG3HgjVeZYRTLWe5i8Ij4LJOv2QgYu2V+ZDFEE7GrqF2aIBlHttIwOqUjFGfdqu++fp9ntQ0PL9HEg3/omo1dw7S8XKbHJ5PjKq1v1C8Duer2l5o2MjEF9whepTGYW++k4Hoem/6fSl34R30VoRaSK0IRWTd3pJQ0EDcPpA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 08, 2025 at 09:48:29PM +0530, Ankit Khushwaha wrote:
> Pointer arthemitic with 'void * addr' and 'ulong dest_alignment'
> triggers following warning:
> 
> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> false [-Wtautological-compare]
>  1035 |                 if (addr + c.dest_alignment < addr) {
>       |                                             ^
> 
> this warning is raised from clang version 20.1.8 (Fedora 20.1.8-4.fc42).
> 
> use 'void *tmp_addr' to do the pointer arthemitic.
> 
> Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
> ---
> Changelog:
> v2:
> - use 'void *tmp_addr' for pointer arthemitic instead of typecasting
> 'addr' to 'unsigned long long' as suggested by Andrew.
> 
> v1: https://lore.kernel.org/linux-kselftest/20251106104917.39890-1-ankitkhushwaha.linux@gmail.com/
> ---
>  tools/testing/selftests/mm/mremap_test.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index a95c0663a011..308576437228 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -994,7 +994,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
>  static long long remap_region(struct config c, unsigned int threshold_mb,
>  			      char *rand_addr)
>  {
> -	void *addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
> +	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
>  	unsigned long long t, d;
>  	struct timespec t_start = {0, 0}, t_end = {0, 0};
>  	long long  start_ns, end_ns, align_mask, ret, offset;
> @@ -1032,7 +1032,8 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
>  	/* Don't destroy existing mappings unless expected to overlap */
>  	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
>  		/* Check for unsigned overflow */
> -		if (addr + c.dest_alignment < addr) {
> +		tmp_addr = addr + c.dest_alignment;

Nit: tmp_addr can be declared here.

Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +		if (tmp_addr < addr) {
>  			ksft_print_msg("Couldn't find a valid region to remap to\n");
>  			ret = -1;
>  			goto clean_up_src;
> --
> 2.51.1
> 

-- 
Sincerely yours,
Mike.

