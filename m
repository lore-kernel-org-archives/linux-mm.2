Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2E21061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5576B008C; Mon, 30 Mar 2026 16:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC266B0095; Mon, 30 Mar 2026 16:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C32E6B0096; Mon, 30 Mar 2026 16:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B35E6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:51:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B70C59967
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:51:59 +0000 (UTC)
X-FDA: 84603926358.26.16975F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBC75140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:51:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+0wM7zu;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774903916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24jNpsvF/f2iekt//6Khf9d6Gc97vDONJaHwgyE2rBk=;
	b=R6CRnH/ko32DsB2r/nhVvU5xVvWu2O084XJIMG0F2Ho459MGTmka6hotiWzcEvhtpsBubL
	xDnPCR3bbbRFmJewzbltGoaUgglXFwUlfEd8IKfvgeHC+bdDdpxoDM5B/134IsMDVmOQMD
	grvO7TziI+nTCqNuAlmGta9XTgdSjRw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+0wM7zu;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774903916; a=rsa-sha256;
	cv=none;
	b=pRCmE8BMC3VlN4rxCjRs+qVmGJgy8Xu1XhCgS64+ZrHwdhMPpbZgRhmhps3T2MFWSoz1lB
	IsZk7zpDp1HfiiBi5dTsK7Kobp5z+7dU+khJE1GeMKUVyj8mFdKwc6BOPWyVra0xdcGntl
	BQ4R0AfjMrZDTEVF87vLhPxY+Gkm8iU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774903916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=24jNpsvF/f2iekt//6Khf9d6Gc97vDONJaHwgyE2rBk=;
	b=E+0wM7zu74qbrAgKvv8A/jYpA93sbGFgoYZ01YVdpwlw24TvFAFmN9Vm1GYhQZzxiwrsA/
	nFD51Hnl1d/ZgwmKZpmXlsdNtRk6/4765i9BhUx/3ccQoudDN1uIPgKrrxUg1bsw6pGJDN
	EgG8aS3cMmtDrdx9ux8HGfe8qYurEeI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-FLKgX4rkPLqtH2HJrRqRXg-1; Mon, 30 Mar 2026 16:51:54 -0400
X-MC-Unique: FLKgX4rkPLqtH2HJrRqRXg-1
X-Mimecast-MFC-AGG-ID: FLKgX4rkPLqtH2HJrRqRXg_1774903914
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cfc575fa15so1417678085a.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774903914; x=1775508714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24jNpsvF/f2iekt//6Khf9d6Gc97vDONJaHwgyE2rBk=;
        b=oXCPcEeAsFSv1HF1c8rPiLVWPBOSMaTRZ24Nhr2o7JWLMbC7zI8LlnPCvV9dMZHKiq
         wxZ44IhxIx3lDO/vyFi+O0MkpkKKtR9KgBkTre0+vT69IRBMKHmvCRsk65tofMWH6rxD
         amLb3v9HpH4T43+42CZcix2gkRT/Jp5E8KmJI4KQG/ci2dOQTvmqxDqZnrAeL3UQzZnc
         vpD+ip3ccCoUX4WGO6EIWPvhXTGszk7UxqzpkQT6KLLsqDv0Tx+VRderQV294F4WYMWZ
         /hCuaPFsCUtesnjPpTcuoIhDDBsGy4PWymlwuOUCu1hobHv2ivY5pWi22VpsR+bqnKxj
         5XQA==
X-Forwarded-Encrypted: i=1; AJvYcCXwpyHEOM/8a+Ji6/doaJGB6Jg6vrUO5Wmw+pcHgv0UyQlXZhOsqQjZcccvZkpKfLpaLsr+NYi5AA==@kvack.org
X-Gm-Message-State: AOJu0YyxpnfR9OAgomzEuGFISG18fM9Uw3+XzKUVP8sxHBfaY9jxFtCu
	X2RNdm2wC2zHj3+giHlfoOYjEpFOgEDc/u3xI8+RsFUcTFYHifLFMrnCbU0i9Q3B+h3ZLYuYOvj
	uwyJGOliIzSMFyg4ACJpdqQWcIHWmRHa3ih63BL6Xg1uPdZ5bmIO7
X-Gm-Gg: ATEYQzxMIxktROkKvqrrvtCCXRaLpq4wdT2RjeAzB2jA89N/ibHxH5rKMoTrKR6TNDY
	UHaq9kG3bX+1FEPTErmxIq6aDcN7XcGS+XcB5zK8ITPXI9wig9Fx59LRmUmbrj0E5YZSjowZZXs
	cdGI7k8xlRj2SlpxNwiqptCbeSzXW35pOyrRtO2QI3jjR1y8m65HbuBPiATFwU3weOxpUyXoabA
	3OuZGDELc1Xos1YAgz5iq+iPhNU40cHMyncYNDSRbPsteH3W6fCcrDWy0WzIl2f6JI/NlyznTsQ
	tBWOcOCw16/+/7sVBJyMZ8MO2IiWaFYjT/dR4jTn2wMsCAAWtBt+tB4mCf0MNuoXaLBbXcCQtup
	kGHiB6d4Nr+CjiA==
X-Received: by 2002:a05:620a:4514:b0:8cb:5176:ef8 with SMTP id af79cd13be357-8d01c60e98emr1932212685a.8.1774903914135;
        Mon, 30 Mar 2026 13:51:54 -0700 (PDT)
X-Received: by 2002:a05:620a:4514:b0:8cb:5176:ef8 with SMTP id af79cd13be357-8d01c60e98emr1932209585a.8.1774903913627;
        Mon, 30 Mar 2026 13:51:53 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02803f2c9sm706603385a.23.2026.03.30.13.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 13:51:53 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:51:52 -0400
From: Peter Xu <peterx@redhat.com>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <acriaFqOds-wbbqm@x1.local>
References: <20260330202909.136776-1-devnexen@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260330202909.136776-1-devnexen@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pq7s4_Ry7nCFt0d-q2p8X3T7t3k_sZcqPUjJxtenWsM_1774903914
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: BBC75140003
X-Stat-Signature: jpzi447ac6segzxxkyacbzkkjzumerxq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774903916-671202
X-HE-Meta: U2FsdGVkX1+G9AOj06Nrzqwt7Bkb+H/iWnvNLxyLVVLTnxRO01dlwpNCC888YFkHlq2vsGRsR988ICtvzJ5Fopj0WGIObLIYAPG85dlYKTxWezxNF7afH/RFd/+1acsVlS72w5Wd9YVfUYjqIGfTeHbq1LJUEGdCkjCzfiioa+V+JvOFMa3B8CRvqqUhqmCcCpERwEWrgoyix+q5y0mRQLv55Gqg4PI3WRU1QPC/7RSS29JokcZvN6L7mqQC9LhcF2/GXNm3jMo9ue7zHLalDDal/AdlcFldK+2InMpP1f1fFcjXrX1AKT3NuFbTh8mzBxl4Xit4B2LOnORQ2k8LCkjhQwdyROYtx6HWagLwO4jj75oJC/4Zi/zNGZM3inUOOPm1WVpu5rSHOxSqQIog4oqnc4gBIeyGOF/0p98KHU1J5dO3K+9AXlJkggQmO1tNDliTkP94/lWVNdnX3uMFn/iFGK+4uEgeJgckT0jbQKvC7vpsH05GFV67ViKouWphSQWLkUjmYpbX5/UcI71oPXWFnua5nJMjb8sz7sV+qpsNUskwybCiLFIdEXTRC36kimxMFvs+NBXI1HuEHyu3ky8L1g5iFnfkT868ga7FsTlHrOjGr/XOHi8KR2kD8YrMgv4E/ZJRP0hOFID1kKcxGLzWXw/uyr/UqJeC7eqEdrlpLVP4JZz//IuMVkcgAOOxg/TLNcUZXOkaMJlWAa7oCTBNuBHe/U29y749VNB/DuxL0OHeRkzjjPECbwEVxkNV9b9RMP2GT/nBcAb2XdHTcH1nvi+c7TTq/eeIqvMazCBtb2vvSjjzdbbi8DsZjJ03Zpg/5Yoeb4JGCwf8b3nnlo6+rXGvevTHNpDESp6XLLgSRY1/691WSP6GbM8ATnWhIDyfjwU3rr54g7HTwNwGXEBFFZb9GoxaNVWHdbe/dkfPJD9F8MFdNH5MlfX0EZwtscAMA218WNtGFSoc1uE
 kEaLEUj2
 BR2nwt6l/WyAzbc+rlhlRn9JMwT2b1atiieD07Aqs3Nb9inPlOrGYa3En3sgG4ZsvYJrOeeZ7FdmukDOSkn3QswdxmgWWRht46eg+uOj3v/wQUTF0tktwnmBmbPeENQBHZAmJG4zQpL7tn1563aQ21aSKK/n3wOHT5SN5yIE8Y4aoab9xglhWLerX5NH5MeD312EmJbBBi5Ovt1KAoNxq38rI3ZSmwfkvlnQ6acY7PFKwgXFvIAkyjKdtBlFpjBdhNzeQd6hxDquM0Qw3Gaym3te61Jkf1qm6MP0wAJrGLCh+EFflvXJSbHWkQBgwjb7UZYA+XSrvCGHHFQebjtO5SAUgGWYSes7F8nqTMOgAaoFEWt50yfWJpjhmNYlvlmZYE8DzhydlMMgrAIMiGrGOUUj/E1UaOyupdojQzoHi7bojxdyLSFNUlLobyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 09:29:09PM +0100, David Carlier wrote:
> +struct vma_snapshot {
> +	struct inode *inode;
> +	vm_flags_t flags;

Note that I used vma_flags_t / memcpy() / memcmp(), explicitly because IIUC
we're moving towards deprecating vm_flags_t.

Please see vma_flags_to_legacy().

> +};

-- 
Peter Xu


