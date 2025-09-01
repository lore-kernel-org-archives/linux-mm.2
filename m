Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A78CA0FE8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 03:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E30B6B000E; Sun, 31 Aug 2025 23:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493A86B0010; Sun, 31 Aug 2025 23:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9746B0011; Sun, 31 Aug 2025 23:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F456B000E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:23:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0D221605FB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:23:25 +0000 (UTC)
X-FDA: 83839235970.17.299A2BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32A771C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:23:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I9GO/v7q";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756697004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipdn/k5KKtIK2UsZRZqqTotFC+oE3Re4lnNlAiu8yjc=;
	b=K9HmeCNxU9LEfEHAfJIFAxhSksB8Lyul2GTtIS+XY0rrP9pXNxcQh5b0g89+lNUSQkFmUK
	IZRberMHFCor+DG3sqMbTYjdsrLUQgrAo1M1fOpDqUR1dwSxT/d3ZpDlh0R+j/jbMwE+Ps
	PM86Tt4bbVDDrEseGZlA68bLImo5Iuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756697004; a=rsa-sha256;
	cv=none;
	b=ojJrmeJ+OOj5diCg97ZV96sVOOtoE4QIP48suMyuGevD7lgi/Kd53iJobBFjXiKeZRE4cZ
	cfeI6InBF3S/I9fwaMFDNd7W8TZUgqmv84eHxRhXPnBEK0CAG0O+0/LhIP5GyGLfahjKZq
	fx8GE35OdH1bi5v4rbV9yPaqWqmduJs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I9GO/v7q";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D202F4411E;
	Mon,  1 Sep 2025 03:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB19C4CEF0;
	Mon,  1 Sep 2025 03:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756697002;
	bh=fngCTpBktvMlnOH/kmob1ywSjzcBkSH81GSBXM+3GzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9GO/v7qN0lQQ9EIgVCZClneDNLVNQnGn3E2AK7AIkDbkzQjnnfbp2dKmXy+aHVfD
	 DmYweSXNlTOmqQo504w/fWuoJho5wS38ojAv/J6xq4OgG9bsfnBD4WhV/bheM+3s39
	 DBtZAPlj5J2Svvz8KjLq0FMOk2XwYfgT2j6aoLjoEIel9yajLQqRmC0K6wYdpXjmSG
	 DZ5NzSkJuIAdQIjb2f8OSSi70YiH7tmRVJo9uQmSF7r0V+IL+4wEoeWjsLfcvc2PaO
	 kFOgc2/CGJL/I1LvmfZ4M6ePdb0xOQxKrsIRTfkE43AwtWLPtCJ45FUjXx1OqtiAuF
	 wCq/i0023SouA==
From: SeongJae Park <sj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Sun, 31 Aug 2025 20:23:20 -0700
Message-Id: <20250901032320.59995-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250830172022.1927448-1-kaushlendra.kumar@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32A771C0006
X-Stat-Signature: d6gnbenoobpxt93ey91a7pm7pbfbcic5
X-HE-Tag: 1756697003-504200
X-HE-Meta: U2FsdGVkX19it8Hj1oiMIUQoGVNMwUBAeRyNcwHGfQqZ0A0aZ1lZhJtFC+6+ZsvpTHp+zHMtCJKgXCRmXQs7Lly9bWTD+lhyQCh9dUvBipe2CrPR6hNlyvM1iV/ukaOxw1wt65Lqvnkx6KQr35YMqAPBj8KMjcmbaOYo+8Ml364uq0LHCrJra6YZ2K1XRS8Kq3/BpnOMI0fEyHjDLRZfYvPGQck3YDKamWE0Xw5/gyrdIATu2pftZoAd0bMSc6F1Lel7qeM0l0xYAc6pFy3vdNXf3AL02y3Wmn+QjPQ00HL5eacnDJWWpT2TSxIIQz+As8qpMogC1OoHyUQWvbbfXsXFZG0yJoBj74tJnZlDEoHfNBqJa7CcvhiZIPZpL4aucPTe1pa8FBSn4RlUiQJqYgsCfE73l6KpdazuA3ixJcVBENNMNa2yaSW80OBfQZ/XUfh8o6fDISgCbqkJYnzxWfXQ4x9XwCEYAs67/XBC4wxch57Fc6aCmR3sNyoyIRkHQI8rvjlpxy9ctwhuVJzmCiaVJz0akaR1mdkulsVWWjeibmALD/VXWO2Zo+XUetF1vI0fKSeQ+/5cdPTNoc8j6PKH6VsQuJtJONmjlTjkHLXQoWPhGmx2DCcFwp7U9z9rydjHIuZ36fUSAim/31D5SW6jaC3j73kxhr2BAcL0yfSPBmyAk/9HrxKzZ7RR04cXPZj7SGM4BvPrv6V7BRHsSAtzxgME9ia0Bve73QQrtX1KVa7BFXDgKUadEIrgAygqGvUOIVw3Dbv2Cc5s2Qt4FxtqTAwZ9cthuJuU12ud+H1X++sdUMfGX8ktLil7G2EB9MIItiNlsaShYcJ9Rh5uBik9BXNALbbPVBBh0koJ0PG4e2/uLNkeddZgg1iGcUtvtOaZ9u2vmF3+j5DZRF2wzL/rymoZCC1y4w5nF4+5eAdfH7GSRgJvuunh1g7OgiFWXDds7MWFmLnJQjZ8d9O
 OwZA7Ma+
 rFE7Z0IQ6Cd8JD6qLJQ2vTNAoICvjgiysVba7+qyEVwQYO1wOVc7yVuQ/z/rI9syWm7mosxeTIaB2cf+/Bb8K/u9mXfz26M1qibX5RCU9xD4KcGcfsadDPwh4Ex1hhDo/NUBy1EcaxWF0cNliiCcsif5S/y9AK9Xd7NMzYeycS3He74vEofMRUH1Wapc35M8dpQOTVMgNoYDX/xz8AWlRu6Hz8WlXjL5Xt0SAZNCkroGBJIO6pbYPdnchxhQnPmtOslZpQNivKPUbjwKb/azkCJNJJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 Aug 2025 22:50:22 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> The current code incorrectly accesses buffer[strlen(buffer)], which
> points to the null terminator ('\0') at the end of the string. This is
> technically out-of-bounds access since valid string content ends at
> index strlen(buffer)-1.
> 
> Fix by:
> 1. Declaring strlen() result variable at function scope
> 2. Adding bounds check (len > 0) to handle empty strings
> 3. Using buffer[len-1] to correctly access the last character before
>    the null terminator
> 
> v2: Move variable declaration to function scope to avoid mixing
>     declarations with statements (feedback from reviewer)

Thank you for making this change.  But, it is conventional to put the above
changelog on the comment section (after '---' line).

[1] https://docs.kernel.org/process/submitting-patches.html#the-canonical-patch-format

> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---
>  tools/mm/slabinfo.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 1433eff99feb..d2e5b4e232b1 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -155,6 +155,8 @@ static void usage(void)
>  
>  static unsigned long read_obj(const char *name)
>  {
> +	size_t len;
> +

I think the above blank line is not really needed.

>  	FILE *f = fopen(name, "r");
>  
>  	if (!f) {
> @@ -165,8 +167,10 @@ static unsigned long read_obj(const char *name)
>  		if (!fgets(buffer, sizeof(buffer), f))
>  			buffer[0] = 0;
>  		fclose(f);
> -		if (buffer[strlen(buffer)] == '\n')
> -			buffer[strlen(buffer)] = 0;
> +		len = strlen(buffer);
> +

The above balnk line seems not needed to me.

> +		if (len > 0 && buffer[len - 1] == '\n')
> +			buffer[len - 1] = 0;
>  	}
>  	return strlen(buffer);
>  }
> -- 
> 2.34.1

