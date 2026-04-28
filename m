Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E0BFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552B56B0088; Tue, 28 Apr 2026 04:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCE96B008C; Tue, 28 Apr 2026 04:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBE86B0092; Tue, 28 Apr 2026 04:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 274C36B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:04:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8BB6404AA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:04:37 +0000 (UTC)
X-FDA: 84707227794.03.B03BAE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3977340003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:04:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XppfAnHz;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777363476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrUGJpgULI863dIwiwLky5llXkDBpDdAraUXNsE63yg=;
	b=GVXFGI8ViM+j8lf6SF//Ghnfjt89LxwBFxno0B3Gm6S/mrOLZxFdGDlCZV0+iUqDuuFxbi
	Ivrtq5ron32p1UU/Yo3TeBdx7nltYUfLkH07sIWoUqUAWxtiOc7BQeStdz+PaxQ+8mE9YT
	q4fQuS3ig4AUu0uXchTizKenP/RKlKQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XppfAnHz;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777363476; a=rsa-sha256;
	cv=none;
	b=aLRucon4X1U7s0TSDLqsCTbyjBOUzQrQsf3/O4HQUU7XoCspMpxUOUKirARdJwerRVXLUb
	iToJLSBPtDLXc+Pj+JTMwA75+250ZnQBaDx2elOXOFndPFAatgGuiX30AAmzdhgBM3lOBE
	rJNOq91F3cgU4Nn5fJ60P/+Dd/zbNyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 574A36014C;
	Tue, 28 Apr 2026 08:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4168C2BCAF;
	Tue, 28 Apr 2026 08:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777363475;
	bh=NtmIbjTbL8hS7vDBEGYOIeztzGgTPC9MZsx2eECcozo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XppfAnHz8MngFNTO2myVmeJ9/Oj2+/bCYRyj4mB900QrbG+dlkM5fWAW8Fg13lzUj
	 PFpSAXHkl5PUM9jVWjIVQ/MnIrvHJQUo3zhAj8FPw370qIkBr6xC017NzJoYajllmH
	 LXefxywCZ+Gsuff+chuFLBSjkY4RokZ8ARycGMnSz5pfHkvFz5zIRpIUHxVFJtmp9q
	 nb/hEpovJGyhAXWSQp8/gaVDZYE+nkvnV2pJlZHBnIt04rz4A2tQ8jsGorQgQc1lw2
	 /oyaMaQkDXhkcv8A4mh0Ws8wysE3wRfGaE8BL1nraNFpdSGhH/JckeHzO78cYx0Ta9
	 x56ZMyQqzSYUg==
Message-ID: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
Date: Tue, 28 Apr 2026 10:04:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: handle partial write in
 file_setup_area()
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260428062322.20417-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428062322.20417-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3977340003
X-Rspam-User: 
X-Stat-Signature: 4xhnf7az8uagrocq4jrdy178dk614rue
X-HE-Tag: 1777363476-228981
X-HE-Meta: U2FsdGVkX18EWCNzfHONZxRejp2Nyb3aO/rVM6DlBhFzJAw1grn9Lj8VzKJfqADpMtUhbI9WeKPUf7RjyVEc/e7gIw1kDRfaBhZQ2x9RSJAfmhuL4qCp9S1SVizlyS9e3fyEYPnM5CzSDjNwb57PXma+G44/na99Hf0BUCkv53AcIUnSXvRJn9wAgmqJyJmKd0YHFB77kvBRbOAp9S/aq/LTfxEL7bX0H/4B56euXD0cMABETObJWr2+AcHhc7FqbKx+xf044qeysqYGAPhQpSEKPA5ulL+UKVZwC0ChegVBkJBpeS25y+4DFTgOJfh659DOnakOt9Ck0SbObT/3mIHEmJ3sn01rfXOV/Qf2PBPNfMP3yV4/IHlQEX/LM4ET3dM1z29J+adrLefdHfuiYdVo/9OcaE1O+vQrhKZ9Q1bZbvaQ4j+OWZp+/PU5ji8fyIcUKtb5pDphu9i1LrwAc3QegfZXkrJArB/cwnL6J46AA/+gabcmVD17+Wi6h7q3Yn0TRgSdZTNauktibHKDOMRFWza+K8+PzI0jvGTM0uM5bZsUAHPYXkSONtoYLfj+WYsUoSL/uYXRDFm7MFoaDcFh6UzxmXOYmyoBSQij+QRKlS5NwDpbyjw/wnKk2DiMCUzMYmX9PykraITyvQnJ0bBmeYmkU0I71r+Le8nhvK/skltc8LiEL+om2QXbFNz3LRB1fyh3zvXfRR7kFEE2xer0gPWZVOe8j1R/bu/QnoEcbL3GcdrQdKaNwxQN2MohqKjCVx3ALI91QC180zbAgGxXY4pt7Lj5gwVADaELejykPQcL9Pqvknk29N0p9bif9VxWQA7gpq2thi1N8JDbKkx7u0l9lW8O70maWtxaP+bDnM8nPTQlMag7Wsat0/XnOaH9EV7I2gUQt7pMRZZR9PSHcUOEd+KjEJgbGqqjkfoHuSU1z4xfW301eiaU3Z1SiFCkzOh8z9Lx0N5fPq+
 LZtD/ZfM
 vpDfngYVwP5R4RfueKMf71AZ14iqw4JBJze+Y57WqrB1zYeKn59CynGagN8ilFFOXMj9L4hnoMcYoQSjLf5HLRyLoFXqK0FhQUyuaOw718wLsKJGR2odpefCa51ITI93wVIki9L/vrdXC0q39TLy+vLbvJeSz4IZOyBKkNC3/HQWYZ/o+G4e3YUcYaWhP+Vb9Y/B3KWsMg28RE9aLSKYqxFLyeJEpD1Lu8hRWFIn0vd4mP7PajbYSr944b2HRfrtfhDFkd/54twjmcLSvwT/wQ0iGwgH4VISvD3YwaXHvmytdRCAENGFvQ1weNEDQ2h5uuYwQ7bZPX0pNLy7k/uDdtk7Uph1K0jWCH84GNFRe/67vVFkn7vqD6V27U2iJMria6FSjm7Vm5XN8n+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 08:23, Vineet Agarwal wrote:
> file_setup_area() writes initialized test data into the backing
> file used for collapse testing, but it ignores the return value
> from write().
> 
> If write() fails or completes only partially, the test continues
> with incomplete file contents, which can lead to incorrect test
> results and make failures harder to diagnose.
> 
> Handle partial writes by retrying until all data is written and
> abort the test if write() fails.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..c13f06758750 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -369,7 +369,9 @@ static void *file_setup_area(int nr_hpages)
>  	int fd;
>  	void *p;
>  	unsigned long size;
> -
> +	size_t remaining;
> +	ssize_t ret;
> +	char *buf;
>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>  	printf("Creating %s for collapse%s...", finfo.path,
>  	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
> @@ -383,7 +385,19 @@ static void *file_setup_area(int nr_hpages)
>  	size = nr_hpages * hpage_pmd_size;
>  	p = alloc_mapping(nr_hpages);
>  	fill_memory(p, 0, size);
> -	write(fd, p, size);
> +	remaining = size;
> +	buf = p;
> +
> +	while (remaining > 0) {
> +		ret = write(fd, buf, remaining);
> +		if (ret <= 0) {
> +			close(fd);
> +			munmap(p, size);
> +			ksft_exit_fail_msg("write() failed while preparing test file\n");
> +		}
> +		buf += ret;
> +		remaining -= ret;
> +	}

Why are we even using write() instead of just mapping the fd and writing to that
area?

diff --git a/tools/testing/selftests/mm/khugepaged.c
b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..a77f753ccf38 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -381,9 +381,10 @@ static void *file_setup_area(int nr_hpages)
        }

        size = nr_hpages * hpage_pmd_size;
-       p = alloc_mapping(nr_hpages);
+       p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+       if (p != BASE_ADDR)
+               ksft_exit_fail_msg("mmap() failed while preparing test file\n");
        fill_memory(p, 0, size);
-       write(fd, p, size);
        close(fd);
        munmap(p, size);
        success("OK");


-- 
Cheers,

David

