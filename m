Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E9BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA5E6B008C; Tue,  8 Sep 2026 04:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082486B0092; Tue,  8 Sep 2026 04:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB166B0093; Tue,  8 Sep 2026 04:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8E046B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:08:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5869980452
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:08:13 +0000 (UTC)
X-FDA: 85189867266.17.7083ED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3D8C14000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:08:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g3hdzvFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788854891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex5rOv7vKl28wj0SeyBEi/wKjcPUGR+up3g3DebNUfk=;
	b=X8pzhYryB53teMlYWeoVRGJy7EYFUnEf/PFWJmyFXhKZwkCrqAm34f+KIF22QEpsRQ2/AH
	HWiuz+5un5kcXVH+yEBw4vb/4iM8MMtESbuOzuxby2vpdENMivjZU2Bb1Ji3Q9rdz9RbI8
	BwWVBi85WibDOc6K8JJ+/79eHqUqAxU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g3hdzvFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788854891;
	b=i519nS2TAamqG7Y4consjBnEo/TPU/ftmhZ54WT/rD/rHgYYA4Vf8D818l6XV6rutrUmPC
	bD+vIF7YKg6Hs9Dg3UHYQRvPY5Z1JajMoIfvXk1M2c30Gt45zwmhK9IWaqXNLuBin+iklJ
	8vUi7WKGoZWKBHf9Ae5lcLAMsZvxdvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46F2160AA2;
	Tue,  8 Sep 2026 08:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A601F00A3A;
	Tue,  8 Sep 2026 08:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788854891;
	bh=Ex5rOv7vKl28wj0SeyBEi/wKjcPUGR+up3g3DebNUfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g3hdzvFtn7mdxCrxrK3f5AngKmNRypNNY++sY86OVJO/qKmiyKU9WrgnNlJYMLjzS
	 rUezNUNpyOGzENlX2jUpX6GmHAZDPN5ZdSoA1qij8ljUxe8/2pulEIkfIy4V6g2KPq
	 sqEPAWjYgcQubNLBMwbKfeXvC/EvKPgACWv8kJC1EL011bCB4hhB1pshakHEcfbiQ+
	 g9qneAn5/Ou+5ppRRsN7fh4XVxkqVrjbqDw8crgiyEVP/y065tOOaVb2vlXQo9H3nW
	 vhdQO1X8MwvcFkcINL09UubOrvH/5hcbmV/tP8BGL8/5DrkpvdFMY/AZ5oiL9mz/lx
	 4n/aQo3AHB1VA==
Date: Tue, 8 Sep 2026 11:08:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org,
	James.Bottomley@hansenpartnership.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: fix ptrace PEEKDATA check in memfd_secret
 test
Message-ID: <ap_CY1sTymJd8zOy@kernel.org>
References: <20260908025111.34562-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908025111.34562-1-hongfu.li@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: isya5mtf8zyz6ssucsqjd88m6exzxcou
X-Rspamd-Queue-Id: C3D8C14000F
X-HE-Tag: 1788854891-527379
X-HE-Meta: U2FsdGVkX1/hDcPX5zNdFI9HmPlv0OReYpJHqaFoVqB2sIuKwe7GRqUasfk/TFQB4dQXCh253PwPuEwgM/vAHHdYgpfkzxyd/qyCHWXQnLcI5SYsStO2fQFsnLSKAcPq1Nntb/Ma8XLsj+l+Wt+kAosaOl4J9xawgb+nkDVZ74KcJrdaJpL6dSpeTlBX8FpZpJ7X9Cpn5mPhgKuBzLW7gjfAK6d01/Q1UnUxPSIJA7T0ADegAUUHNkvZpwwa2Uakexp2K3XnmxTIlwktZCJF7NjXsPjkzUdH7N74XXlt1S/QMF5hGPtlxBMU8AKJJpbmGWu6FoxfAVthMBdaLswJoRqvfXpASfNARLLHM0RVIXWZElAfPISXAJritqeNS7AV8qkBQ9ho2zllDk2+GbmXMYVWLeWWyRjT6tkxbCTbRkefcRS6W994YVn1tanJ6rZGv+mC9roZHqTTbqbcOGuKuF+wzHtGcxupKoEwiaBpbdEgMh36mB5JJ4Xp54qSDI+3Pvu2v/lZD2SiGLsNOM84C5PgijW/x5Hwa8lnqJDSL7G+Txmw1yaCfChqUbskmhcXqvQ+5yQS4P9zCGScjKgkWKulg/MKTz5p06i7JSlpcczd+Rrp+X/dooBUn1/W5B94xezeCBsGBVqTIJlkDvznJrXSAPOLKsjNPYT+8h8WAhTnGF1F4M31JnttrLX2DEM20X0hU6E7ZxVBbW9W7tyn4OX4hexd6mOpImU+lt2Ho4rkEpqByz24aVFD+78XRvDUh+glb6uAjbDcWSgcGhIEiCov0E/nNbFhgq14kQHuAGJeHHzZ0vineDzwHUnSFd97sm6VHsnu2Lx3rEbsnUfrVBOFGGXZQfTGnC7IWteWx0ngLs3Dn89KMBUDOFUqTHWHPGTh466VFPz78LLlJ5cq+zQmZuIMDkWX1QnoNDPRm4r/ksKP6EWNRgHkBIylxOyzyu69yo9TRoVwb3RUgAh
 p9WTpEaz
 W+Zh1l7CnDN+A43VMdo5nom2uoUVGCees2qQbJUqNoSXhZ/omQ4Fbn0Qz6b8xQPTKSKx3A0GsDF1mDCAZpZSFGQmJu+dTLzVzcGHAX3BoKq0uc/umxlzbZWhW9wRBR0U57eVqVHR5AKJ42HOfWEaM3TPE6SWKkBXSXSFFh32Gi2WiwoMfSIbb35dTEe8Ea7Gisd470RPt/vQi6wqgWpXbCO8WwT5u1AIoFh1CriyTlMIjYUVPftJAYIlwcYWJoqtsrj7ufiUZF0PQR7z3fQpmO3RuMS++To1ACOTxEkng/c3pOPa8pITDfTBK3JlSKfimjeguxIEwYxXgEJR6aIoyUHcxBtxd2/CnvLVkBZQhgBe+UvFs1q4MTfU8sQ3R8u6mBMbdUjVAKBPuaT6USHJxOtN0xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:51:11AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> try_ptrace() treats PTRACE_PEEKDATA return value as a boolean
> check. A successful read returns non-zero data (memory filled with
> 0x55), causing the test to incorrectly report PASS when secret memory
> protection is broken.
> 
> Check the return value against -1 instead. The test should only pass
> when PTRACE_PEEKDATA fails, which means secret memory protection works.
> 
> Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/memfd_secret.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
> index c55d84c5e613..dd08a3a1ef14 100644
> --- a/tools/testing/selftests/mm/memfd_secret.c
> +++ b/tools/testing/selftests/mm/memfd_secret.c
> @@ -145,7 +145,7 @@ static void try_ptrace(int fd, int pipefd[2])
>  		exit(KSFT_FAIL);
>  	}
>  
> -	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
> +	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
>  		exit(KSFT_PASS);
>  
>  	exit(KSFT_FAIL);
> -- 
> 2.54.0
> 
> 

-- 
Sincerely yours,
Mike.

