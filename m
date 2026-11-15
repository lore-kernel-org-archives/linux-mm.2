Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452E2606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lg2tJ8Zf
Received: by kanga.kvack.org (Postfix)
	id 682896B05B3; Sun, 15 Nov 2026 07:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A2B6B05B4; Sun, 15 Nov 2026 07:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597A76B05B5; Sun, 15 Nov 2026 07:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35F986B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:27:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38B68806F8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:27:49 +0000 (UTC)
X-FDA: 85437279858.05.BBD30C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9382A100005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:27:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lg2tJ8Zf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794745667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAPUreepg71t27uA19huNdBMN8SZC5pl+gBBNOjrEpE=;
	b=OER8ZCu4/gzM+Zq7HyMSjWarGc2GFLPHRcAI2DWr6oqQVWinEsGACHUIFQpOBjZLPBeRJf
	X/Vqfe4NwME4NX+hmSijWQktfH0aaduxS4znz7pjSxUOROYjWvXCk+Ff/kXy+HGjcot+64
	ttgAvIWPwkJ8jtA6xZ9TmUsu8lovHRE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lg2tJ8Zf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794745667;
	b=Ubfj+gU8meADsxaHkBck3//y7Oa5TySgiYUBctPc3jQsuJ0JAiSz+vXmfKVo8bftbCnqZR
	8RAbdnGDpD4RRHHr51wFndUdR5xDUEaR9FOM7zMiWnnWjg6a3YqwfdBAOyFynztGVM5HnH
	2i2+kqk7DaqgaDe+KEzdTeJmF2GIOrk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1488D60D9D;
	Sun, 15 Nov 2026 12:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E8E1F000C4;
	Sun, 15 Nov 2026 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794745666;
	bh=UAPUreepg71t27uA19huNdBMN8SZC5pl+gBBNOjrEpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lg2tJ8ZfrKmdiIKH0xpR57qGsXXfv2F5ghS97GTxNPBYY8aqMOGx2U30AnaIf0OtU
	 BwGhDNlCMBUsrfabSbufGfLT3OaR1RYjS9nwKVDAWL8J6AdVpnXLSgwdCGgl2bKeHP
	 VgjCDvrJZoBkLyNSrBbJDQlRKdaGGexyelqo55KgE7EzB9xk4jwa8rwl79TQccZyvz
	 RmmlZGwya6TYgMfbALzKyzOkSeGtq+99zbwJcdGmtM/laJI+bxnQD+irqZdTHdrtQ3
	 0/6lM2cuN6kAuj4g3ho77thhIa6vswDZPy9tONnIb9v3gpmpvoP3zqyMcal8rxA3qM
	 R3BmAszLUtkkg==
Date: Sun, 15 Nov 2026 12:27:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ivan Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: use PFN_PHYS() in phys_mem_access_prot()
Message-ID: <avmlN3K0CYl2yDP-@lucifer>
References: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9382A100005
X-Stat-Signature: bt1mscwgdowupea497z1xy8ajff6coue
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794745667-948251
X-HE-Meta: U2FsdGVkX19L9BFXTf5jBpCVY7F0E3+ofci9rjginN+OLPFaL9sUqHs3Dcb4ZVLKloIhjipF07+x8khyCGWyPdhI8bdxCC+wl7Hj2Lgr5fsgTBIX+sh8i9Rzjqa87eetn7yHpZhEZB7OXGDSmDO4alwWgH2DR1e+dgPpwJaRVyX3tR0fysu0bURtjUbCG5c1Bss6/4xB0raeIvsVXK/4NirK3MzbchYLmNDDeIMDQA4QOG8gcW9A0/BIQJXxT2qnrcy8qrA7q4iVq7vIeYPx2uwLFNy0ZjAHOSkpOSFLfvZONliMZZNEPiIbrzq2eFislXFFAXYupTN51zV256mChB7Tfwe6D/sNHKEj/h2eV8im+ZStyCQOSrIeCcD7heis9WKk1yQtSX/xMK15C2GcenHWr+tjePY+Z+wJYR1q4/uDtI/Mb20rquvFk+BSbuxffhCXf69nJ5anmaG5pQUvJdQtm/pmnZnZSNVflIEO2CMstphu+RjP2skWnKo16KSkTjdB2l1UrNXOpzzz7kTuF4MyIloWwHDBLsOUHweb7zNh4ZJSYEGj6/wIye2B7J6lBxift2GOh/PTEyfPUPy3ysvplXYzdCom2PmyeZ/PEkKjSuGevemwjGpXBczWzRxqHM/geEEGBwGdgSGJKefpUEOHR6nCji/PeWWk2IMP24SnYI1kd8AvM4jCEq/DICyMJcIxPiwg7a1+VO4x3lO+z+no9aw1CYaFyhrmHhfQIXSCbSNncqJ0cCpol61cPqgDGzNIcjF4ztXqL5FXIUQhlH+ksv2GS03MTrpgb9rxFgUsebMJHPKLTmIwaios9J9JS7i5fIa2AbBJV9rUST0bxMGjwqIC2pqZKk8wFrlk5rc6QXPMVtpM/PiZ9y/VGD4N/O2Hymw5AXVCIeNTg5HZPHmzHT7BA7uGWb8sYVW3i9J5FqKrPrn49fDEHehSlcYWIx0NDbhDWL4t8IlXzhf
 nAEsH8ty
 ryG9/qt8N0Ro4OnAsFPzZe5oMqDlXohocg9j7JYEKuYAWvtM4UFRe2Ji8UGUBTD0cIDIrRxvz8Vj9oNIUT1pEIuO7tpacm4qk6VEBY58E4nYBSgB8vM6u6ACgkWo/Et+rc1VTw4UR+c+K6vYuqTgbLLleeBI1Y/7iTdYWZEKuNmqy2gg4VDR7vfvPcbJKCaBYjSW0j+O+ocWSc2lp+8qxKBoGGTSifbGGKfGUtMxS/LGl9NA7daLDbSmp2QHb2kYE/576fvE6TXzuhlsFKKu234r5GT5r9T4S2q1I/4oj3NXOyFM9ho4oKp2o7SuPsLWkYNVMtgGHSBTbO6mczQQTjxK8wmt7oUCpTnYmJHrbb7UiAsV/UmmkUMM0qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 04:38:12PM -0300, Ivan Ezequiel Rodriguez wrote:
> From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
>
> phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.
> The shift is evaluated as unsigned long, so on a 32-bit kernel with
> CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
> uncached_access() compares it with __pa(high_memory).
>
> mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
> accepted and then left cacheable. PFN_PHYS() casts before the shift.
>
> On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
> O_DSYNC used the boot CCA. The same mapping with O_DSYNC was uncached.
> With PFN_PHYS() both are uncached.
>
> Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/char-mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7..53ce0034a4c1 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  				     unsigned long size, pgprot_t vma_prot)
>  {
>  #ifdef pgprot_noncached
> -	phys_addr_t offset = pfn << PAGE_SHIFT;
> +	phys_addr_t offset = PFN_PHYS(pfn);
>
>  	if (uncached_access(file, offset))
>  		return pgprot_noncached(vma_prot);
> --
> 2.43.0
>

--
Cheers, Lorenzo

