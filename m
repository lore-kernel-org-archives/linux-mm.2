Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB3E606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hYGedghM
Received: by kanga.kvack.org (Postfix)
	id 46E6E6B05B0; Mon, 26 Oct 2026 11:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4250D6B05B1; Mon, 26 Oct 2026 11:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E336B05B4; Mon, 26 Oct 2026 11:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 050DC6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:34:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D3AB1C3C0F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:34:18 +0000 (UTC)
X-FDA: 85365173796.16.9B07B68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EAC320006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:34:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYGedghM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793028856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enXAkrWKOg+OnmNqIxb5MDjoHdnjUwcVFg3yFO3gsOw=;
	b=mUjh8HUvqez/+qGILOpQVwXgs8YirxPs11jZwWd+ppRxQYG4VFt8H8+a9N5t4/8VDF48lt
	bu3uAfWTMHk2fnzgYTG1XL5S17oGcR55R6jWntVYra1aAvXjZ/zo+nj7D1xcNWlSFZ159b
	fAvnWx/vVxQrtoMyZYCaYP76063AN5Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYGedghM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793028856;
	b=bLp5eZRVq7ZcgkK7iyMY7S+m6Ex2HvS+Z8+DhZzufN+CrDSwuxoc13t/Xdyjn1tfilL4qw
	OenM6P+38ic26Y4yNd5j4OqEvptpNCDNoWJFytdal2+E9E08XakX7xVWl10wkS+k0tn9Hf
	6hWzzA1dhXr4BInAe1Q/QuSVJIB3Zos=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E64601FB;
	Mon, 26 Oct 2026 15:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A0B1F01828;
	Mon, 26 Oct 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793028855;
	bh=enXAkrWKOg+OnmNqIxb5MDjoHdnjUwcVFg3yFO3gsOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hYGedghMubVMClDJg8UjWJMPTv1naRWZLHo697LqQ1NjJFFIW3A8z6OiuPm5amsZK
	 817PrEtBwLXo2grKB3+JJOXabGO+zkyV8rqrnzu+GUiWa5EXeMU+HSJeOpqbRGbTuj
	 mxwEQfmskRo7b0x/jML5dWtyFpr6ot32rvD80UbE+Efxr1B2/cwsjfYgY8I0LP0C+N
	 C3DXm1HeJOokgfAgsMo6II1fKAfvoTievNq+9Z7q1Gj9Ols22ZaCpg5oSrBrMXEAjY
	 w5fvPfLODiXzNcoK9k6c1tpxQj3QfQElWrco5vXv2FXo8OwCGzdk5wikjtYD9EW8S5
	 arbgWnx6hwdrA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 34BFA198003A;
	Mon, 26 Oct 2026 11:34:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 26 Oct 2026 11:34:12 -0400
X-ME-Sender: <xms:8nLfasmfM_A-8C6FdWnJR4MHx7n7Fo7vyQTnWJp3zKtP3nYBEhxX1w>
    <xme:8nLfavzl_xCYhIJLLpgJh-8VYiGaAi7HY0RQXA9j6TC9hHjdekDNQyRy-8eY8JFFd
    Ff4pCUEW-dzMzcC3YPZ7H1T5eDJsdlcfhGStKqYRdyNE16t6fNCTWYu>
X-ME-Received: <xmr:8nLfajKUovqMB16oEA__sc1etkZHnuNI6tVhz8wdpB7mtQixETQS5gGollY>
X-ME-Proxy-Cause: dmFkZTFChFXNPhfha3/sK9OQCU8ZlQFCIc2lL//QxSk/v80tP++TpcUbd8oBI/UC2hCcQi
    dysjiuRL+Umb1+5MgKTxHJCkcRB06cFautIOspS/IbW++kG8/nt8ByYqmCqa61kOqjjIkZ
    5B1b7xPTLC8gMOzABjCI1erXXuf49nuLg074PCjSRrrp9+Oq7WC3QUM0ucvNkrWxZrrCG5
    MVs6FZFG0Aaw+DL35JWwRyN0VG4Fp22qKOZ53y3IQDxZIkjTk8a1YbfdrS4W5R/sbrBkRC
    UBedcz1USRKX28DOANmsb5RQXnQUKOL0yrp2AoqRpq0xZ+5hUhJdrd4k3LnrmS7tNTH2jF
    +hrceKOpzCT+YgvEo6Tidp/DIQQXN+eysGfT3Nunq9RrOxcrzaKuoL24LSxJcWMRTCQ7JB
    GbyChTM3CE2oDN4OuBozGAgz0BtZ/66gj/UKJZn5e/XsKdnswLwtpoCwCrum5WoWiMT0vK
    I1CHxlqCouIb6mBk7vYnOSlrtbnJaDjNzT8MT0NGEhwnzpFTSWbHMyMNDxXDshV6DKo36T
    m3GWcwxg4sHSxn6V1+ADIZM9hb++0XNTk1dIRJNH7sonrxwjvO1m5o5RnDM06kMMYbQQg5
    P3GMfvvNuuOZPzbclJKODWSzYrt4rBUgQCMlvQYsuLNJ6//cwaoVT9IQP4/w
X-ME-Proxy: <xmx:8nLfaiIWUjTM3Uzj9zDV0cUQxWekHdcdUFfzUe5i-gXZ4cohLZetaQ>
    <xmx:8nLfaiVL9ri3TDtKf021iCV3YxqSv_NYyxWJ5WffayAlEiPBGXaBbQ>
    <xmx:8nLfaqBOxmM8eyw4vmNZCC_6I-16pxlgLBJXgS9Ni0JZDC-FCKbeNg>
    <xmx:8nLfalFghDFHw7Ivc7lOozgqdNDSlBAYOgJnKh_WFhEr_IPCMToVWg>
    <xmx:8nLfamf3M2UKMwUNzKOTyHsHgSG9tI6zGNoyZOnoRhh_O5poW5mpXUsU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 11:34:10 -0400 (EDT)
Date: Mon, 26 Oct 2026 15:34:08 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>, willy@infradead.org, jack@suse.cz
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Message-ID: <at9xXRhD2xZhszEj@thinkstation>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025164619.89992-1-dennylin0707@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1EAC320006
X-Stat-Signature: qjszhsaymfgn3rthgh4qih7fg5tmimq8
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793028855-571098
X-HE-Meta: U2FsdGVkX1/ERH0xR98q8PSdNBQbFTb4l+570AdmEHshB/SrU5D7sbYsnfcjEhWeqWJgnKiXgSVc9bP95nscDW8HVJEcEY1Z4GVi2qq5VR6aY61GbiFoz7TZcrt3UIxDNtaqSKuF8DxkzpKeOG7T9ftFMWP9/IHAJJbEYskTIpX7Cc2AVS8Gsmk/kEfoxn4ErYhZZ3fdMRAqGxfoP+1F7qKH228za+/cZ1AaXTUQov7Bp7uA+MHcZ0byb7oQIYE0SwvWOC/vAF9TIJjxdZ1NDEgKhDMc0RZih1SaYc6yDlsCR4klTagV0SfSwji4gW4qo/n0niivE5+63Z48wt9exq2DeL6N0fWA5mtkugSxgn2W2eGolue3ltosDKeFrfJ3hDKD/xMRrcVS8PSxKRVJfBR0Nc63cf41X09luM4zt1t6InJ1CfGLiiBG2lt4/5pG1o6H8qDuR+zam+bdVdhhoeRa7nNyr/BRZBqRaFLRP+6HPrP2DPPd9+nB+3LBPXDB0+HzrUMKMcHcYwX9aXEk0INiziylKdilYJ0h43HtaTKx4m0d956esEz2dzCqXi6kmSWnvx4weu1D0Jyk5wWplzHAPJcNgwGOZSCpZTA3Y4Hr5Pu8c6Jert6IBCzH2MfiX9RLslsqPExXAoNP0m6zSnWfAZVDCer/myLQwBOtcFNQIiQJ9H1bJ4blxHiTB6DFkFqGbyMbZCMzULkyq7t2IVOcLppe3lYDpdTqebpNP6wDvXdqwVeeKXJL7PqJKCk78G98Tq1NBygxFuZp8MKVW/UU7Eo8Nlk1+3CXVCHa+/Dm26D1yxtMTBpj/i2qnpAqlXMpJrbwd2OhP0yYzlYS13yt8SlHYUYmX8RFEUiTb+YruMWvwRQw+wAmj2nVps+bIbxe1xjacNumkGjPvQjKOwCifsPDAi+sgHiobOSM29QFArzuQOUrf2pWQfd30niByOH8eImrjffOK8rTGxj
 WdD6vfAv
 ZK2mMDLvTwqUPXkbiBrvvrQA3VQO7/Ky+OrwzCbQRUaMM/Mm1a6gLD7Bpdh95fJJnuEJ4ljo9of6j4zFnyveQIu6T/WacLJVaxpGBOkeB6yhd/b8HKmSIsgf0aoj7SSrsomCHtUyR1fCmfqPcnEwu2h/iPdESUtskN4XhGyriiOhnv5lamtfQ85pRG3w4M4bH1tztx8LptV8NUQDh+UwkkaRJVbdwUkoLzIGS/2MNHLTKkKQARMWaInTpE5PgpUlheJh3rlAIoC3NZHEBoPvhKZAziSu0pP0i0nRemRz5xIJNumHEeKedCooUvVL70aarV0JmwURuMXqg2pqx/MtlY9a85Aq8idPTIS4QzcxsczfQhq4e2guVb6hZxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 04:46:19PM +0000, Hungyu Lin wrote:
> shmem_write_end() advances i_size to pos + copied even when copied is
> zero. A buffered write past EOF can therefore extend a tmpfs file
> without writing any data.

+ willy, jack, fsdevel.

This doesn't seem to be tmpfs-specific, right? I see the same with ext4.

simple_write_end() and generic_write_end() check pos + copied the same
way, so filesystems that use them through generic_perform_write() are
affected too.

It makes me think maybe generic_perform_write() is the right place to
fix it. Hm?

> Moving prefaulting to the slow write path makes this easy to reproduce:
> a one-byte pwrite() at offset 4096 into an empty memfd, with an unreadable
> source buffer, fails with EFAULT but leaves the file size at 4096.
> generic_perform_write() calls ->write_end() with copied == 0 before
> trying to fault in the source buffer.
>
> Only extend i_size when data was copied. Leave the existing folio
> handling unchanged so successful writes, retries and preallocated
> pages retain their current behavior.
>
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d97fc32e7c94..55287c370c73 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3487,7 +3487,7 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
>  {
>  	struct inode *inode = mapping->host;
>
> -	if (pos + copied > inode->i_size)
> +	if (copied && pos + copied > inode->i_size)
>  		i_size_write(inode, pos + copied);
>
>  	if (!folio_test_uptodate(folio)) {
> -- 
> 2.43.0
>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

