Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43FBC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745E36B007B; Fri, 24 Jul 2026 12:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D356B008C; Fri, 24 Jul 2026 12:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DAA6B0092; Fri, 24 Jul 2026 12:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6C16B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:40:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4DFCA1283
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:40:17 +0000 (UTC)
X-FDA: 85024232874.11.AF24430
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id D916220007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:40:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jlQCcgyQ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784911215;
	b=nCjJMy+4t5pJTm4lac7rKG1MBv3n8gneL9MxEJk4wxz2lkRI74BpwMNh1Jw2U9ZeGWi27w
	rjVkq6DyImK8v/BFSUoMk/x3oUgc9KyAEn5hOeb6cjM8lJBEPKc7pF9rUN5pDZPhHxEGDZ
	GrZCn9MG3NHVZCit7FkQCY87Y6fzisE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jlQCcgyQ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QR0nGvYgKRecGnQysmdmyOrVg4xxkcSJ1B86xgHnGNM=;
	b=D/gQctKeaLN95Fn4HlSptzH5pIi0c62M3BtvNbytXTY9c8QYNtCft7miFbas5LkFmE4tOz
	IdSACY4NX6QRFAzCMQxL7DgqtTQ9lrMP4K39QK9Ods4br3QqLgIrQyFQLL96KAOYi+YlKu
	UOv7bpeHqMTFJ0xYWlPRll6nSl/RR2A=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so632100a91.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:40:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784911215; cv=none;
        d=google.com; s=arc-20260327;
        b=lTOgWJ6t72KlKCCl/A1YxrKDn8GxSTG81719TcQ+//65YcmSzzNo7MOnzyZSBwnhLI
         nICdFuQv2IlXOXkG7ATrU2vNRSBPg5LbGIO4QUrt6FYbzpMe9osrmTDYKuzpnV3FAdef
         e5Z/kE/vWID8qiVxb8SvVKdAOpFrQRaDfGtaQnyWE8Grcy9nyqyW3V2i84ATjWlhlGmA
         SIJ/0ZQOs2nhNYrvtR+zdWe21RS18BEnpLUZ1hw6JgaFH/NDhaRPsrWnBgUiz4pTKN6U
         ExS9uxsOprAbJ5z6OlGQDMWF/iKRyT76YJi9SkmoKbdXpgXVaaXYdrTGKKK86uDp6ufr
         j0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=QR0nGvYgKRecGnQysmdmyOrVg4xxkcSJ1B86xgHnGNM=;
        fh=Aclxl726MEgY3eZQHtFIL3G2moc4EKUFOPF9hlV5PVQ=;
        b=gngSXoGU46TN6ovKvGbqFDYxeHGDeDw9P1jDVnMfxOqT4aJFZk0wlPsIoUn9JIudp2
         ujw9hplbjkN0/2W4ASRim58XC50n54Xzebn16lEACcqNfhDxVTO1/Pj7P6n3kBzc7bPb
         sXqb3ahX0roBVvp2XTFUBTesm954zC3RHEJgPOx4cuEGKli8tzxsBjtuaqE0PBz5+gA5
         GZWney3HLg8vvevoTpBsFakbybZ0FDwcQE+4TkS+89mE6om0rKs4ANsB8PPfIoGzeMnF
         BBUjTpfofX3MhdWFb7L5oCu+NGJA/QzTDUOUjsnDOEjdVdE86SwPa0CGUyeLqtoG6Cs9
         /RDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784911215; x=1785516015; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QR0nGvYgKRecGnQysmdmyOrVg4xxkcSJ1B86xgHnGNM=;
        b=jlQCcgyQ1Uw5tvyQkHRh1U3LjgQ//ZC4Z2nOnQQb9l+k6u3PnIAwq/v622FYHJ/Ms+
         /LjE/1xuDyaNPb994xd1BlkbGquBrRhg4e01ks+Vxt1mnbzKLwbVXAeKr5H5C+q6mMFv
         8LS0orsaTG4TC09ZRmMwJBLTr5mEY7VS83JijIgLNWj8LZQIPCakqS9JA7Y1IlTxuSSB
         tu0RL9YLcW6MN9I6i9bnUWAiaYnBaIfPhhOhxWT2WxQrCrnmbKXB40oYCbjzncU4OJQV
         iti1gEDWPFyvIaxBWHBEjJiLX+G5o4DytSRz+m82LkQ55qZJrjCBlYF6IuavACXS4S4O
         ZAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784911215; x=1785516015;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QR0nGvYgKRecGnQysmdmyOrVg4xxkcSJ1B86xgHnGNM=;
        b=HWI9o+Kh+b+5lsRdZEmjnzEEdxtZwgy0ZzpUdV35302XQyc3VrAOFPb/2yg7q0u8J9
         sgzAPlSTcJ4N3UZQ55SxKNLVouUepJt6Asar+I7a/9KSAxHUMJoONpxlMCp7XMC1+ZE7
         2Y9JiNe/Al98FsWvAcTnqF/oQuo9VVEncq4vn34ER0W4CKqE4SiiT07skugopCVZhvLM
         0a51DMz6roqBsZJQpKP69B4hZZdKbOK0WKADr3bPy2qgeOWTW4y1mp4h37R9mjCQn0qM
         nbYh+gNrupZDerz5RWWSJ54kRJqOZgkbpGvEzidFB90MRF3UrNhbXMvZ/4FxCUOgJGA+
         X2uw==
X-Forwarded-Encrypted: i=1; AHgh+Rpkl3Ng7ke8YxH58AuVbSa93eKUoGMRw80/wruwIu//n6suzjB70JL4fVBuUfsAE8cvxJDFVTKRPg==@kvack.org
X-Gm-Message-State: AOJu0YznzXXkeEF0jVumhoV1fpun6EcVENmbLLMnL5RtxBZZbGfX1oZ/
	WVdd/6jfvYWAuooSaBmtQM7s9bBK/ugAlku6NviotOMUizbyj6dhCdNcdTGAPAB76iHJ5zr98t5
	NxzoDiChVDwajWtZg605JBlJpb0exxArXKg/KeYwA
X-Gm-Gg: AR+sD12Qp4O8DW9QEJ42uIc32VzMI0pfx2H8HIhPfXjdYdC3DF7SiuxpMUENK4xWi1r
	NYVijjSd6z3pziSI6d/2OYxK555rOIVjOY0MuG8UlMCvz6UkJLtEedvnjcpdnbf3obj7/zP2lsJ
	PFG333OJzC6sJGNp/osxewoengvQh4j0H22KEKf2RCAfL575Pp9S8OKuugEpheFyrN9s4QOtebq
	t0R100e4SfyQY50MJiqg0D7LWPVgE75Erv0zdPvy39AGQAiF45Bqb5ZIKe4ci4lPMGV9JWAZnW+
	jz6ax568PnvmouNgRYKtGYsSKn6y1wSphmZLQ49ZQXX/zkhv
X-Received: by 2002:a17:90b:314a:b0:38e:712a:bb38 with SMTP id
 98e67ed59e1d1-38ec65ed982mr8187972a91.24.1784911214011; Fri, 24 Jul 2026
 09:40:14 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 09:40:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 09:40:13 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260723143034.175661-6-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org> <20260723143034.175661-6-willy@infradead.org>
MIME-Version: 1.0
Date: Fri, 24 Jul 2026 09:40:13 -0700
X-Gm-Features: AUfX_mwTvn3TL_REn-pj_NwgsA3C7Q4eLFAVFbwA733yc00SoA8wGHsmRDLESEg
Message-ID: <CAEvNRgG04hWKkf8F-fq2PbRfG3WdPb9dzvJd079UEwC9AQkR=Q@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D916220007
X-Stat-Signature: 8xd7fzys3ngjngbppfwjru6h1xj4wfxk
X-Rspam-User: 
X-HE-Tag: 1784911215-820023
X-HE-Meta: U2FsdGVkX1+yDKyoJnFmRDREh+pxX8Vwua2lgE+Hwxqz3WcpT+jAy6lK+ttUHaOIaR/VytjuUCxNB2PJuNIQe5+/aMS23VceABBknSeKBT4HPI59X5I29PU4J89h/SyqCxZimwCHFDnYXSIKHK9kJaFjdHWEpMshD1nE7WUSKhE+31zgmLVuY08Og1YwsbVvepkYM4B3/VgpnYkguEaohgTqePbM7LG7RrVnQIefFiIFkHv0Tezh41W7HclBdkkEPM8qmrp7kndA+tro6e0GN/hGKGdQEfhEVw110EnTAG4lmDTN34M0fhBBCLeWoCvcUH5SAc7lYm+uPSDab9Ta57sRpwdLGuyBx3Tm/Z4ivQGMZTKI5nYssCp6jNFRAZ0FZW4se0tqrQNm3tlZ0Bw9IaZUbVeOiyclsU2He0VlFnIpnoyD3Dzvx+JIB54do1fXqAI59/3/x1aLPexIPbSxe4q2nlTmgtZ+d46D16kO56I50Zbc9EVCcLnNwp4fgZcdN35ClYZobPCcSS7zz29Xuj6rg9P1A7rgFvr8Te0UQbk1V4TDCYuYoQUfMfaM8aOW31nV8UEAjOt3QfgY55yq+20NelmH0VVnpRXBFDGTXZZdXG0mtSfZB9JOokIuNq5bxbMvcqkmWOlVpR4SkC3HA3OJVe7YiT1ZOmW+LMa1seaLey5J0lSPeYQPOpLlHrCEwwoQwZL76dJRB58BGTVYFzKrF9pJCICLSClhQYXEI110qJX/qnrwoxyC4I/y14J+gxLY1XExJofADXt3g2lT0kBYV+uC4hcHFYq2s7w2D7WEsvdrvDvQJH92yk3eaSUmbkiozpz9qVFDOqqjY2caz7kT/pAt+G8yBhOBRxThNPQOHe/h8IqO0qmr82R+A36/pB0YALnALuiCTnpnRDDheL/uchWowRVf+rLhFgm9Lj0g2mZc+JgS4q1BA0+O5/fzAW5bxZR2r8uT+ZKlmJy
 lmp9VwRT
 tFJWM7meM1VG4fHhT73GYeW/6hY+TjcemqjpEl0m1X3A65AHu56xrjqhS1Es4Y7V6FpjWIulGU1B591Q37vDNkUMNg/5OJ+QO9/fk22tCyXCH7dcsGuR2W0TAfg8X2Pmo8B4ncmW88cm9EwsQC8T1TPO3L4hPVTYASkpfxj+TFzQQvbzDeCDzXgf9CITiboPBV8U2SirEAjraVNmxwSH7BZl120Cuk4uccGtHFA+ZZ0jm1BLl0Ep9DNyx3yyxbheeveJ7g4j7mXoVA9qZpwJutNkUVtCyLTTVZZ1THdil5COvKJDYkEvbF3ngf7IpGLtaMJPJlJ1FhTU4L1+wC8NLL2LB6V0/ZgIhWFSOBtf194FQfGyaEF8qC1SdbGNyanPM7qMchzMsBtsOqACn6NWR4t8YFe2VQZ0E3n7ei6E2pPnFbvS1woeVuhlAv7zmkrx146rKRhpsQ01QOD/ijm4HiRTR2xBrZ/A5ypIVqttnOTzQRgTx6MfU9BOwEL4uOujYyl2S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Matthew Wilcox (Oracle)" <willy@infradead.org> writes:

> folio_test_hwpoison() only works on hugetlb folios today and will give
> the wrong answer for other large folios.  folio_has_hwpoisoned_page()
> works on both.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  virt/kvm/guest_memfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..94eedcc7f1a9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (IS_ERR(folio))
>  		return folio;
>
> -	if (folio_test_hwpoison(folio)) {
> +	if (folio_has_hwpoisoned_page(folio)) {
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		return ERR_PTR(-EHWPOISON);
> --
> 2.47.3

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

