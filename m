Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62EBD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8196B0089; Mon, 15 Dec 2025 22:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556306B008A; Mon, 15 Dec 2025 22:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463646B008C; Mon, 15 Dec 2025 22:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36E2B6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:31:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D78AD1DF29C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:31:26 +0000 (UTC)
X-FDA: 84223908972.21.CABB9E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B8F540005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:31:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=snbnEcpN;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765855885; a=rsa-sha256;
	cv=none;
	b=6w/Fm2x/URjWJDQ4XBwSWCr9pcue54XvaqfdRDapvcuTWk7IQG0YrTee6chHf82PlZ25mN
	AyZ+6IBAMmR04KFzaUipwYVOpP878i/SdtkNeqsn8nyvrH32EJt4v2/Kj/UkOtHyjXTEKb
	rYXcbrVw47HAq9Lq5ZwWxAznLglQjRI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=snbnEcpN;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765855885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIM7t5NtKTQjPQ4zgp6Ia1o17ScGT40g452FlHmBM3M=;
	b=0hT+3MMhmWpBnnbNbXFX77y6jo+TXapy3fFzYJtI98iC3FXzfjVNtPz1fdWvrjXXzRRc7b
	X7ixgHs5/SDvaUTVxEf8J5Jni+M17V6uZKW2mFYrVXj1jrIM1t3sMH8/1GkEQYbmnvzmpm
	X84HpfuxZShpnTScNcL0qam7c82+LxY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E8B260189;
	Tue, 16 Dec 2025 03:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAB9C4CEF5;
	Tue, 16 Dec 2025 03:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855884;
	bh=iXvhr2IUEa4I0R4J/u4Tb7HJJ+fljwtfXvj1H0mjw4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=snbnEcpNgm0qyHqSxoHCXPiB412ZtwSZhs/9020C2vvMN/zK47SnLtk2R1jNCn7zH
	 2GARMLfSLYm565W3Ap078JeIyY62kaTGh3DN0gj6xbq4g4i0L3s7ds0R47+dE2ErhI
	 G/JERPybFJY2VJYV0P/Ari27c5BKU+CKiQ1SNjMI=
Date: Mon, 15 Dec 2025 19:31:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] tools/mm/thp_swap_allocator_test: Fix small folio
 alignment
Message-Id: <20251215193123.1cd0bee80853599220a82ef1@linux-foundation.org>
In-Reply-To: <20251209031745.2723120-1-kaushlendra.kumar@intel.com>
References: <20251209031745.2723120-1-kaushlendra.kumar@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B8F540005
X-Stat-Signature: ejkpuwkgrpzp9x618itkf5d4dwz3kumn
X-HE-Tag: 1765855885-792766
X-HE-Meta: U2FsdGVkX19trH3psYtlXR1le5PBjoJfmd8EqMVQdytMo/FJSNhwALPWkSDdzUTnWi7VeoMAczvlBY7dWOnQeSn/NPcl8O0HsP6kUPpp2soQKLKOJEZNzHY4znXnnkQR6dCDAjVXbtOzTNzjhh1Mbq6PWU7QrA2Fix0GfcttldKZbugPgaDM+gQsbtnJSa6iKAgvQJ961YP2WKYstXukB1yve+hCBh+sZ0ZIzoc44a8h9KSof7YOrSCsXp8ngR6TnaFNhOgDS8hds81Fk67YfptEIwJR0Q7iESCvQEmZQgU7g154gHZjv9Y86d4dMCCyvYM4Ls+wMCkyGiKTe8uOFyRpQSou8beiNgTe3mAaUIIut3tsfmuiyEq9Wba6ipHV/iyfnUfVsE/PVFg0Li4TVQPIeUEXu+f/EDm7ov7a2LCJqzy45VgYfZOzWOzz95PWvPDU3/WgK6Blbn+s3+PPjzWMdk6jmPPNmQyi9qCMkFZ4cs+uJApvoFhSD56oiX1oUPGpVZDdQMnga4Ce3Y71dxgeRAIO0MX6RCZzY6OaSAoo3BzOoAQXLV6UqkI3enFXgeIZZQSACeQhnpSlbCXRaDic61oODx2q5TE1G8EAk/nd4BejGdf9YP+9+FinId5sk5F5O9v07IZxPCpz3ecKknvpAhWTTn6Fqp8OXB7PL5YG29X3Pcv2WXFMyk88HsqOXmlfnemPT8RUMl0ataEi7ri58nOpJ8H710a0I5pubTH5eYYuyQdnHNwaM06vIicte1SmNawM21NwkteMyjeS91JBuauRnqWkLRgLs0cEVCumen26nuoFACI/uM75sx9clbMGBHY7ykbr9jLlhU2nJ1aIOyZH7nBxKpQz/mdOgHaoet95uTkF7+gik2rsX0yWDrKoJslZZPPLcaZuIpPGh9X7eK2PbIpHZ+NqYo29Rh92QmdmQpTAhLAZE4QTNFCt08CqemPaGI3bsoEtEFA
 ve5AtgzG
 i9JcF51zegz4b7m7tVgbA0cwUj4NF1aXoecDY/rNmEbTt8O1OsupOsonFrGWwg3fEQ/B6I42a9IjF/HeOGSq+cc6cN6LkK8UYFDCPQ9001eSvdi9034z2J/S93VsXhR2XvYhjkQUT3/5uAmW6VOI1UuGXNHsOfMCH4Lk9y71yQCUIKD0gjw7gko4bHhY4BIkbF3Vb08nQDiQOR3wXGTqFIxpcNfaLWhwjJwXE9gA/RAc3jWqTDBcqODilzY4bM2y0bTZnOi7NRE3AjTjHLh2PQA2OYbrpQaB7BXy4hG02vv0s+gOIiyflA6mSWeOEuiRDjpxL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Dec 2025 08:47:45 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> Use ALIGNMENT_SMALLFOLIO instead of ALIGNMENT_MTHP when allocating
> small folios to ensure correct memory alignment for the test case.
> 
> ...
>
> --- a/tools/mm/thp_swap_allocator_test.c
> +++ b/tools/mm/thp_swap_allocator_test.c
> @@ -142,7 +142,7 @@ int main(int argc, char *argv[])
>  	}
>  
>  	if (use_small_folio) {
> -		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_MTHP);
> +		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_SMALLFOLIO);
>  		if (mem2 == NULL) {
>  			fprintf(stderr, "Failed to allocate small folios memory\n");
>  			free(mem1);

What are the worst-case userspace visible runtime effects of this change?

Thanks.


