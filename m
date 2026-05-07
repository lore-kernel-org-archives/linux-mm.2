Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60470CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 17:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36F56B0005; Thu,  7 May 2026 13:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F356B008A; Thu,  7 May 2026 13:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C2E6B008C; Thu,  7 May 2026 13:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 838666B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:22:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 225A8140580
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:22:01 +0000 (UTC)
X-FDA: 84741291642.18.296FA3F
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F0B114000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:21:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PhgdXOJg;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778174519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0BFdmnbQQLTsb2DZYRMYZ7jk/pd1z0d1fxF0EQZ8kI=;
	b=kp7r5SlduXy1MmlKmoccE7/k5mjuPg8UuZJSk1yt/JA45Aqaj4Jx3BW28O4uYxdP6opfwZ
	XecoDBQSD/cLD/0QzXvG9CCMER/KyIDlfVk/nsOS4EHAeMomA05qrryW9ghTcU+iSJh2Sr
	18KYKtUvSIXMvBcLS5dAliGBXYimYq0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PhgdXOJg;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778174519; a=rsa-sha256;
	cv=none;
	b=AjIID2OMIi976JJeZIFOG7gRKsmr9+QAfRbfSg6pGd5hIAcbcwnJKQ9SSiP2jMEvAHyKLL
	ejdGI2uIWIDZcVvpHHucT4fyuZJkXhuX+mADZThaxA1aCvSHXiWvkrVnZZ3s/603vD3U1V
	9R7IZMg3JVv0C0PFvVpbzzn16rCFX+k=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a74ac8b40aso1061103e87.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 10:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778174517; x=1778779317; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N0BFdmnbQQLTsb2DZYRMYZ7jk/pd1z0d1fxF0EQZ8kI=;
        b=PhgdXOJgNtGwOsMm/WvRDVoXz5rF+VzTYaNc3Opqw3wQ3COlHDIdXhmuN8WktiHgqD
         WXVeaQ5VGXg4U4fk9A5Tf9l25E36fXHAAUYSK8jUEVHEtSiATq3jUkZ61ywM/jB12a38
         DRt7SeLA9YT0DAOVZx9Q7n7Wn8SqwOA8NQaPSXr2i61Wn6b2R3Tx8KAVghTL7H2Fqznq
         dUfSSZliM4App4WNuTTJ2ymGHlYKOit59UGKUR144fEThsXK2jmePZu3xrqYn8VY2ULQ
         4TtPChV/xyeoq2bVfogxdDUkkNrlhEmrfmOhO8X+QgPPwG7kZ/7lffprYBkmCBQG2amJ
         JZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778174517; x=1778779317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N0BFdmnbQQLTsb2DZYRMYZ7jk/pd1z0d1fxF0EQZ8kI=;
        b=d2GqeA1gtUJgve1wF47PYa1bqPlvul+dRydGoTWHcIoYuprT8Ys0JPTBmY4GgyNcGF
         awzjO/XIgzZBOIQoJYIp3WhkmnZVIXr32T79W2SiEVw7wBux37odqK2W56578nCo7U4r
         QF96dQ3EVAfZ6HWhXYQgQxi5MTmQPaDbKJtFYGyuhC2tVcpZ6P8IXSsjDTC3E+b1qPyz
         DQ+wr7lduiqnOhYvAU9GLvF8CwTwPI7aFPu9zEfVghTbyp8w01jO2pBl0oKOajggbiaT
         iS/MUXHPBjGb+OKF6wWkOlt2FL/ldF6Ss5IslHYOL4eidZjAcojPfsPqEINiInT51cnq
         xUXA==
X-Forwarded-Encrypted: i=1; AFNElJ+IVEepOLNsdCLRjeqU5wxXVNOKNWqlz1jdB4IorR9WcHWY/pqB8lhtkRy+JxcElySSE3FOUgU8iw==@kvack.org
X-Gm-Message-State: AOJu0YzeRL6AMG+NUqqqlrIcMdkazXpze0U+1lemT93RBLQzgJJWscFr
	dm61z4iIP6wRDB7I1gzxIylBy14fBIZcpEW8M7wnNPmn57/ThLH/Hsf2
X-Gm-Gg: AeBDietCK1/HVSzUFCeYyNCZVITniXbD/3Gcct1fTt2crlKj26ru+dOpqZVsA7dmUmS
	s+YLKuqB0ri+0Gd1Q48/76BQd+lTEOuSp89AhfWJ/H2Yv6yjutvb/xoG1xuQ23W4sBb6Qr3TcL2
	RJaPu/XBJyDdgj7F4C149Q+wMXmas7g0S7R6lL9fqpGY53BgmhPxToeuT4wFc1E5UhuJ92Iiw0a
	1S0erCloEVrKRBKgeZh9yVNz+PiFxgb6xqCnAB+CvlU/0R7tvoS71+Uq0vkgjpw3TROVmdW6mKV
	6TSl+puulcgcIlyrX1GYyGmvPF0n8RqnPRBQ+UU5vRE5fo+SutGADdP0DG+k1b+uxFMhPNuI3FH
	djKiPQdtFR9RzWfc9ohvWkUssF9grqku0ik0nsSCpHUux/jSMXTAxzyvwTrinIkhz
X-Received: by 2002:a05:6512:3e14:b0:5a8:65c8:dd87 with SMTP id 2adb3069b0e04-5a887adcd10mr3268132e87.3.1778174516997;
        Thu, 07 May 2026 10:21:56 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a8a481a114sm84164e87.83.2026.05.07.10.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:21:56 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 7 May 2026 19:21:55 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 2/5] mm/vmalloc: use physical page count for
 vrealloc() grow-in-place check
Message-ID: <afzKM3qRDI5JOycs@milan>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
 <afuMvOTfj977Bex5@pc636>
 <ed1a55f5-615f-42d4-805b-5f53ae2a529c@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1a55f5-615f-42d4-805b-5f53ae2a529c@zohomail.in>
X-Stat-Signature: midbgqhnxfu5xwpdubcuodtt1oumtrmq
X-Rspamd-Queue-Id: 2F0B114000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778174518-923861
X-HE-Meta: U2FsdGVkX1/O2otf0+mfN5zvZPrxu4uwjCE3hNjU0r+nOoVo1HHPjHinI8nFJOOcnp+UEwbMLqjwQFVp5N9t3vqgIpYHmY5ZNkZ4ePXYE9IY9DbS2bFf64xmN4HncXc5luaUZID849e3sFjVeNRcwfOalfkwIHtlHf6AKcrAWerNHEj0hTwalnxZVySNrybOJaZrUFnlrZnjL1PFFtmdUAi97iYfhNrkxLRMWYKKnvzcZExxDYfR5G1ee7xupjoS4H5RxzthYx5bWwU4eI9n2ZnRkfkq/DUe3AJ5TYK4uwYMdWigoMZwiiYMELAhX+wyjKhr7fQ86oFJU3O5xnfVakLRZXLbAmGhZiy2R7INldcQEwaZnBmKQcDSgYgG1fN2C8Sv8AziElCh3p93BHaPodRL87luHAhcYVEDi41E251JLvGWNOOeoa/i2DUtj2U0D4Rb8/rcQk+gWlzLLA2Okm4wm1DjtnifY1Ts1JIEBmy7BBPWkinpLPUqrc5RRM47iIa7aQagge4xxZY6PA+qcJMXkkVH1EzVEZgQbBxSSwjWqyAlMZ6kS9rJQjF4tdfRf75YB01gFIVwEv9UWMjXkRfGLcF3DNS9yPssfjK5Sd6FJmni3UifcPglYRcxMEGvVCMZ09DOnFWeOWyn5boEK8LW0Bjh0IpUgNnjtwk40ZxCHh6uJmUSYAoX6sF8Y/mOqWnkKsKpqCCWEM3F+wI6blskBeMOkD9Tip7XwqKgB3z/1i0G/V61OHNqH5IAcs/5ZQbQgAbXOddXCozwUe1e+p4kYQI7hbgT+9VOzKg/USRDMDw3adBZwQTWNYWWktP7OvttUMmkT65erUO50MqN3azkNLtCp+RqvMuPo4DNaOwJh4opcjXDdX8WiPwrXrNjwQ2Q/kI/vmaGBqZnfw+fYo0DNcPm6wiTKwEZXA0WQB1Y+wNWtwIGDvGozSl2DeZmQA2qHJMx7H/TJPr6Kd5
 epm/1Vqw
 wWxwBZS4agpjxAk/0pEdNXnPH4Q0IOP1ASXJ9TIxUfDooI0sOOXGeKkDLhDVNywUIzQvni6mtTXleqEZ4NCt5V3H+6SYBZ2BS6rIdYKskyjWOxq7cjyJ7i90PoGahb3FesQZHnzZpZDm4UKHjDNhUiIqqpZAgraQoPBLT4dWKiyhOkvp1NSAs3cyR71VX/QEVDnAJ4s03jTm9wU4SgbvJhZG5BNbgH4kee/MLQKg/NzIBIPkRNvw9TQinD3WeUeeMMtTCM4+EWNj6L8YLOIKlYlfQVvVs33rOrUOFfUqcRXLYx/0DvGNMrY+r0zKHWIsKak/j0W8He8CvDndtI4nMN7MFOoJdXmCA3oHO7GwIxjj5v8i0Bz4I1w0I1RoH4iIfi24gDcEwRMRKhOEPwlNwFkRz9sgCVPkFcr8OYBwfdjy2OPOcxj5BUj1dkjYbebPIReG/7hdFm8WILSehZiz37BMWIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 01:13:35AM +0530, Shivam Kalra wrote:
> On 07/05/26 00:17, Uladzislau Rezki wrote:
> > Maybe we should consider Fujunjie approach and borrow his idea to shrink VA also?
> > In that case, we do not need to switch to vm->nr_pages? And we do not
> > need
> > 
> > [PATCH v12 3/5] mm/vmalloc: use physical page count in vread_iter()
> > 
> > ?
> > 
> > --
> > Uladzislau Rezki
> I didn't want to change the va in this patch series and wanted to keep
> it simple.
> If we change the va, we will also need to rebalance the rb tree.
> I can work on a followup patch series if VA space pressure is critical.
>
Actually it is not critical. The idea is if we shrink VA then we do not
need care much about the size thus keeping vread_iter() unchanged as
well as [PATCH v12 2/5]? at least partly.

I am find with it anyway.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

