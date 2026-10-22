Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A76606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=L68KFl/s
Received: by kanga.kvack.org (Postfix)
	id 2CAED6B0948; Thu, 22 Oct 2026 10:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2076B094A; Thu, 22 Oct 2026 10:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF8E6B094B; Thu, 22 Oct 2026 10:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E32266B0948
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:02:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CBE540129
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:02:26 +0000 (UTC)
X-FDA: 85350427092.02.E8DA047
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 439131C0011
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:02:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="L68KFl/s";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nI0a4ft3AKrVHH4EyHbLl5cpGzeZJh7lCRd+MnM1tIw=;
	b=ftVO+bUsBUHU+xsrfNr9DEoQdVBvWD3fuBKjd2/QSCWbIm1NMm3sDd9LOqGVaOeQXL4fqi
	C8rBUdhmn8KjbbaYMlhLToTAjWYVxPGeCe3pMlyr+mVdvaPde5YzEn+L3a5siza/d4HjJo
	nXsEz77Krbsh9mPj9giD520DtLtkMaU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="L68KFl/s";
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677744;
	b=DeZkqZtm+2c6mUDtLaPgTlWJkzj7LJuy1uU03rtcY3fo6JetGxGhbSu4hrr0Gyfl0B5fQH
	ZduV2IqnODITrQxRXpehAue3Iq5aklREJbtlTwzhVwuLyXMLuryu4/PQBUrg3e/2lJVy6Z
	HrFVog0s618VMURVNUfc8uaea3SzJco=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f1e5d7450so179434485a.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792677743; x=1793282543; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nI0a4ft3AKrVHH4EyHbLl5cpGzeZJh7lCRd+MnM1tIw=;
        b=L68KFl/sXzgjvaFDsBDY99eWgXpyp3Va56MGur+1iIOnj3pFAoKZUXWH31AEO+EbX7
         mSmVwxLe7zn0uQ2PwCfrAcVZmZVlJ4feqLv8zb6sAU4rCRHQshNTOWmp8GrR9ihUVpdL
         y/3Bs4dZRmZteUApxDOWFKT5gafLB7zZcuGn7HaUpmC71asUpMEa8wmjBQ8zMEF4YFkt
         haiQgDfQG4ubh7DCBb2Nj1k/9WJ8tFVthMCEai7swaKuDXdk9PW/ZCQYYGhaenV/Hrhq
         jIFKbnzXrSI54SV93ovCgDNJ/ulFu/0xEQ7zQhfdWPADXZd4MvqIKEwPtjxdoavwU4af
         TuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677743; x=1793282543;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nI0a4ft3AKrVHH4EyHbLl5cpGzeZJh7lCRd+MnM1tIw=;
        b=0OcRGEaJyZTp5sW7IjytEBuosLzL1Am8FFTfLBXc0MwAZXd6sBJm8yQVlUgCYRasML
         rhSKs+DCJDSEiiUsofXzEHIhCCMyL4T5BLNnQtwg2ALoNYoT5r5zONx/+wderBFIr1e/
         qTr0QUSK9BeEiaLmSmLu2E2mbQu7U9m/V7jBs+hH9elA9o6gK/K1tpJXL7jO2OAkF/PO
         YMWnGKs48ICk/ucuIu+VcooMQoImHv4viGksDKv0NZ8S4fntvhqZdr36BfxOCXYJ48FG
         TpYPghnw3J4Id1dpgpPRZqSEzOAtu8xoFZ6NGwodKx7e3A83QAZiFl7h1Tn/zM/689KS
         Thag==
X-Gm-Message-State: AFq9FYKHvj+GYkh4U0RvEKEh0/GIhTBlos0a1bxulHEP2fMQt0yPxMcI
	runQoL+J7rZawM8iBvxI+NlGmDNXS9SBvcv/whE6XJTHSQIQ6rPEE2X+Dy934UphtU0=
X-Gm-Gg: AYBFou2ZRIgW7B+5E7xgw8zlMLZbwOG2+F+Q+aozBCkQzYZQqkt4hcec7iLmcRgoix7
	+CWhjBsemUZP8Fxes8n2Lz8hqxSLEXukwjRo5BM7eMlNnRQgOCBr8jTKlR7wALHb0Iy0rNIkauK
	nzPnr19vdAEomvH2+Om36UveTFIYpsEutpoYwtGtbjXaaxw+HXnvaFLIgiB3hsH5WvglY7Ff4jm
	Ej8lSfCit94AGN3il0XtrTYFXbfV9v1a8DFPd4syKRn75Mtx29RdoeQ3oXSztnXI2FX1tIoghWW
	MESF3/UIly5Ijm+lPb+QGR20nqzXinTpMlGYUaAA+Rd+W0NE7DihIfsOYg15s9Sosz0/krey09T
	H5vkdvdoxZPwyP9EHfjyJ3FMfh23s5NMhpAe6GiMtrLenEwllQtjkS7g2O3FX5GM4wknbiqivLI
	PeFDAeoKs3cfdiih+xU62/tmzVeksdhxlWSOJvIjFryz1urgUzWC138YqJfQqZPOJwgLLDM55Rk
	CIHfpiOhWGUpnmmHhbPLcODIiuyyAEbn6otE/df3gz5xpXCEEHz2dNuSktQwVjZE6TJzol/mRK8
	Sa5mIm0KNW/fnJQJxer+Z/8bzd25FRvllMj+
X-Received: by 2002:a05:620a:400a:b0:93f:175a:f4ce with SMTP id af79cd13be357-93f57f7f30fmr941477185a.80.1792677743141;
        Thu, 22 Oct 2026 07:02:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e068e3sm517528185a.32.2026.10.22.07.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:02:21 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:02:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Enze Li <lienze@kylinos.cn>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, muchun.song@linux.dev,
	osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/hugetlb: drop unused mm parameter from
 unmap_ref_private()
Message-ID: <atoXbKzJP-jFnbNa@gourry-fedora-PF4VCD3F>
References: <20261021061901.376104-1-lienze@kylinos.cn>
 <atjO4rhSYGJjaWCC@gourry-fedora-PF4VCD3F>
 <ca400732-79c7-48b3-85f6-a5374d80e58f@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca400732-79c7-48b3-85f6-a5374d80e58f@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 439131C0011
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5fc148n3f9yqwbxqrnskru7fbtxfcgxc
X-HE-Tag: 1792677744-743742
X-HE-Meta: U2FsdGVkX1+AKG+wVrkBE1qu6L6KUrQm/PAFRfDEeku6fcJrkGK7YuBgn2w29nRouSoNkstIORoZXCbxGcPDkcXR0aqfGILLZHRSs6zFxyXLoaeHEzU1oLd04R6m3hdFizDqFHh4L/XrdgDJUBX6YywS4m4riES4vKdXMIdNXQdFxd1wuE2m42ihSF6Hiew5qFB+kH8505wyQlRilDhX6WLX8FMGtujAuQ+wTfZ7qNBOAk7CYKg//Uu6lw+MRzUNi+NC7xZ1hz1x/DuW6yGLKUG4aD/aWqrzda2Im6kWmJERzL+h8/lcE1yFNm/IaLq7uvmANaFuXUFYXg7dhPHlY03i7WiCqzVC49SYTijFRP5kvQMdLDnPrq7D3YVyq+Ox4BfFWuOJHgzVyXCsy12n/l3lbIFZ5foFNnvS50zqhvyoB03VDGcAGYOwMysay9zRxs0qWOzpXPRnYSX4kIPpLWWJxtW6yn2nVRwsZ6O1F+wZaPsIa1bshSewBk58ndBN1CBJCeEDZJb4D6gFsDOKQmBPpn+bAGvWljGvBzCUBuhGWCXALekxZmtpxn9WdEgsYx2U38BKqSed1FnL661cBwNXTXVvGtOOkOljQaInHg+oSZ0SC09gQKizMuJvmCNiIUKxtnzyQ3H3m9SPKKtwWVeJ1L1fx3Y/nKrRt1oOtou5eofBnbWrj9xIO2psgWjVef5jxBIOFs/8z+zPhUQI9rb9MtIM/QCjm1YRLhC4PrEAm70lyFdOFmZEXRCdN/tVm6WZjpJ5Xy7y4PwukCPSsgF8SP1/YiWUY1qAn12UX+ahJ8fcIiHk7dQ0ajam+aCGtY8ITYXmssd1QaW+zt0tkfj+ZSUFRr5XDrGMgZX+OkLyQmlyVi++cWYMgX9U6qO2AO2kN9oNOzSkNl67ttVZ5mnkWBnxWdDsIEL+EFb8gK9VyY1SD4nx+hhVT5rfeCuodR5lWCha3tIPlFzWK4T
 aI7QNX8L
 6/hl3s3PPpdExTF8Esx2gNpciVnu7FOqAe+fYsrsZj92cXfK5EHqk8uaf0E3umeLYN7P6hFBrCyrHRceAW2nZFKr8PXy6mKkx7LrqUcbAHoS87Lc9/F6RUbDILVGu7jsZm1DBmSvwNqm5GcHv8PA+fpu9JLb1+BYkhqUjGL2sLwIOQS8/472CNvYN1Fr57ppiDSFafvsXWs5/4RG5P4lJBzLr31KbYMBFyKDNJtHFJrfb+MuotB9YP1WXH+SgWcFf7JrZ7gm5zcEYu/+RaQ7xakG06kI7gbI8TriUwV8ek7A4asj6y2wjvDvbswQkaLrg1BfXN3gDU0efSJA81zhnPrJZ3FVAIXTso8F/Au7qPLeYcBUFIsv4MyrD8xdQxpjOLhSK5pC+PnC5vQeD+0cNAP2KQPknd4CRu8KwKQrrJF+zqRoiDLL/kuDPQ+EShqMQRJwlmL4seGaK20KqBssxl+e+vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 02:59:46PM +0800, Enze Li wrote:
> Thank you, Gregory!
> 
> I noticed this was sent off-list, so looping the list back in for
> record.
> 
> Thanks,
> Enze
> 
> On 10/21/26 10:41 PM, Gregory Price wrote:
> > On Wed, Oct 21, 2026 at 02:19:01PM +0800, Enze Li wrote:
> >> The mm parameter has never been used since the helper was introduced in
> >> commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
> >> called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and drop
> >> it at the sole call site.
> >>
> >> Signed-off-by: Enze Li <lienze@kylinos.cn>
> > 
> > Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 

Yes sorry, I was working on tooling last night and hit the wrong macros
apparently.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


