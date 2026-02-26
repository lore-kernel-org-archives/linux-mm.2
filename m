Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D5AFD460E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A111B6B0089; Wed, 25 Feb 2026 22:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994506B008A; Wed, 25 Feb 2026 22:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A04D6B00A7; Wed, 25 Feb 2026 22:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71F2D6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:35:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2088F13BAC8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:35:05 +0000 (UTC)
X-FDA: 84485191770.25.01BE251
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 384F040005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:35:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=io5zTj+W;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyaVGnjfNzlE1ptyk6n5dAoHe2pTLjJWHR99F+D6o8Y=;
	b=oMreLkJwXu+CDVVpOe7hmb93Rz4OuXemSTx10DYTexa3QiNa6COuhpu9up80ru2NAWgnm2
	phzEbhWAafbBc3f6V2/bfsXEyPwLQmcUqN5speFpmR+RlJagDcuoRW0Q0oJEIa5TIpbA/M
	LtryzakFv1ebcFYtsWXqGqMPyfyRhtY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076903; a=rsa-sha256;
	cv=none;
	b=xDaWA7pdoWObXmRRggu+SMBUx3bhgc3MEEsi97sXfyWwjnsjK0X2TNr9TjwDeMFJbIGHZV
	829KGRGSoJmxXdGyOAMNnAqkzxnHzYCPYXH6eG/yMYyeCXFbL/tDfuH6LBmMcuMF2NdZLc
	C4L26E7g/cKQ1/17KoAl717WUqcnabo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=io5zTj+W;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-827336c0994so468056b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772076902; x=1772681702; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IyaVGnjfNzlE1ptyk6n5dAoHe2pTLjJWHR99F+D6o8Y=;
        b=io5zTj+W6x3FczV9JXogER7OjjBeOc54ACIpUaX708J3jYNuz7zoP+G2yQ9KcGlB1C
         SsEve7k1DjY+My7EaCX81o9OcGYagH8GH6FtoJ9TKqQb2SrUhEqak7lWwdYYsURKBi51
         F6gENdlXh3Zu3vdFApHICZd5/g9yfWaQc9vPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772076902; x=1772681702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IyaVGnjfNzlE1ptyk6n5dAoHe2pTLjJWHR99F+D6o8Y=;
        b=tpmkn+1p9JAU880hgYjX4RgHeM86h37Od5HYeK7oB/7WWe0UsnIrQ40k1gOGUkBSqW
         1y10Pb15BF58JXlhQPEKwNouJ8en4m5RPAwLaj7Tw4j74uroq/zWlOUDqQKE2SYO2wPO
         Zd0faQv2uIBMjgYh+esPw5N+Pxmgf7D1agPFSe+f1MiiL51C/VLrhbnJWPnunL8UcE/C
         cRikbpKQobOvQgJYWH12bUyMWlmECiL6WoWyKbVcWNjv9TIEejKDTzLC0HRIZxTW5K3Z
         NWxMFxf9vCg9b/mUbPsPbCYbf21o5Pyl8FaH1g9AKcSMsjR3+OKkCJr4esVP9ResMl87
         Lk0w==
X-Forwarded-Encrypted: i=1; AJvYcCVe1X/0r/vxrNVcNzt+dsnJH/P5jncL66RMF4hrOTiZsgCa/NFqTaPH6E6RXpy1kCZ6/um2mPFBKg==@kvack.org
X-Gm-Message-State: AOJu0Yw4t0Mop5Ya6SRDIh1msjn95G0cd+3whUxpBubGcGhDfz6t1kM0
	FDjs0nourLiA2dlppnjCFPUiSi9m34LKZqd+ATpyyeTIy6WqKn+uxNhsaoy1FT26SQXWT/ln4sQ
	5VEY=
X-Gm-Gg: ATEYQzzJElBbOqiTqseZrreH+H+WYp/tKW1ni76ZL04iLKcNbQIwzbOPn58xx4RsY6L
	MboIpFMNQtXOEMbWSn/oTw6gOgLaN4g/hIIWFlzzgWLpzgAZbb+nXUuW+ZCrQcrbry7nzs2USrL
	j7OkA33jDbzGNBMK5i9ghKrTeRnZLHzAZrdwX8dO50Ko5hfA1euGp5jsTkNF4GeVm/tLglalqLL
	896uQa3y9ubwGUDjTVrnQD/mcC7BBnfp3/IXr5EYcDIRi+3BxgL5K8cmpkAlycvrmnNj6hQ823Y
	bTCzeetCm8Re0YCuidrCPl8dtYbQNduiMDGGKhfbYerWtONNGSihN8qR/woXw0X67Uom4NQmmDM
	Ak3hEbyNbKxJ6C6bmYYZ9qRojAiP7x03tC0LUfXYuEKlTazQICxJsSoCfkw+IgxHszag3MqPQhs
	PdI7gzzZB7o/EDpSY+kBL+HjAlhVK7ypTsdH+0oRb//qdXAqLjYKCGp5A9Zz2zfihDpWvfklX0w
	A==
X-Received: by 2002:a05:6a20:3ca0:b0:375:4503:ef0e with SMTP id adf61e73a8af0-395b1d2376bmr1303951637.14.1772076901993;
        Wed, 25 Feb 2026 19:35:01 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:f7cc:c9c1:b4d7:b50d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa801849sm431165a12.20.2026.02.25.19.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 19:35:01 -0800 (PST)
Date: Thu, 26 Feb 2026 12:34:58 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, Richard Chang <richardycc@google.com>, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] zram: rename writeback_compressed device attr
Message-ID: <5mpns2z54isunnwyoembp5xuip6jzcivzlxdomrohtlooedqfu@ymznfhwglrsd>
References: <20260226025429.1042083-1-senozhatsky@chromium.org>
 <20260225190329.8f76b847d391c71d58988234@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225190329.8f76b847d391c71d58988234@linux-foundation.org>
X-Rspamd-Queue-Id: 384F040005
X-Stat-Signature: iuzpdkk739pghnx9czizowdgd7n9jp67
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772076903-771108
X-HE-Meta: U2FsdGVkX1+KOCO5MEqYfFArZRBQYMFxL1q+u/mn4pXs6StIJ3it+InUZ/Y+V41TmeKSv/UQWT1pLzV6iyArdGNPA6M1ubc4+MlY13tMfqaEdrmtbHPJ4EuXwhN+pUfuzawl0q5QxT8usn1FcIEX1/RT84yHEQ3G/BxpvWNK5nXnhytol5uhVWvlXKP+traFJgToyuw+6H99RBvvzmExJjkSGWqEsFpaju7ftHqvqGe+oLWX0aHJ9zUvKKK9Fpq/316a33lsGSPaYuaM0If/M4cKwjoV0874x0A3ZfBlgAr8vsMI+wLWlw3luBUgE1VymRyoxOLk7+ohtMMl/Z+aTE6+C4r3Oe64EFPCEMPP9t+D1JgF6aSd0jY03Ol3AE+KYfniVRCD/6iZnLY9+Bu8xDCrwgjvZsrUwXJal+pVKGoQ71dDGuiVVdctLabZlxgTJk6bvmzdANRyMO+/G24Pu8z/mj21zgcpDIjMcQPvomt4WO1OD6eHE7dR1JdL6cdfVzo0zsmM7yDQqkDLY9X43ZuehK/uRvMOQWgrfYRPOQ9K3oGMze2Sy4LEbDBLIBzcn/joM4dUaJZcQwJMe9CcrQD3BlsPjrCY3MM2fgHdaUJqkUqPmYUgVvmdIIWwitsXL2QzWcJvZRPCIWEI8DObF3jiqtcZN8Bybfs1Nv3Y+s7+YyCg2z2Km66UqhwxP1snJd5nyP4gGEQ9/wqX95wa3MBCvP98PHu+PAxU80d/Qn4uJZhXqrVW6DNgoWZHVSa/sTZ9FasSBzM5QHGlCrlGoBKzjjvVgz76OvyHTLxlZ/m0JnFk9VWH+DMScTznXbljXrzqabBgeWHvpCSX+Xa29YZ1pBlykNvxtJqMOt07PiVN/xaUlJ0oC/ITQDU8GXll4W9772WjJiqRnc/mC0lzOJ/xeQBsfRfLDu3rCC5xdwzhIeUqTMGScL7u4cZ7sKXwkn8nBKDyB+DmNpHez1W
 yk/+EWDq
 svcuYybm5w/v78+4p+fHzA4PXH8vxa9yVqeHatkAVpR+1sCGhK6r8dUNoWoq2IVeRTHLjWTLYbuzXF8lpvdRJi4OJvHc/f7oVp+rguWQR+P2vdGPTAYEUXuZ9kQUly6UZ+5ZivTZArX3AaGw4eJjrowMkpKdjxfkgu5y2FKI2rZHpbISCGnQ2KoM4eSKdKZBowDhcICdnFAZsDGmTd6rLELeIKkSBIVCgjp6ZKWUYOu93om4KW12VMUuKBpmGprCXFc03M1QMZbE57nuk5rJKdvq+EnlVk8a66DBXqvlg78K3ucQ+KLYmKNTWMv9DD6ZrRm5iIwRFy7VbJ77xKiqchVPoMixFcboA/VrEIGwL079dHIuS92K776ZOR8211NV8LbWJ1m1QDnVhMfFnq9iozrKljg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/25 19:03), Andrew Morton wrote:
> Fair enough.  I'll add
> 
> Fixes: 4c1d61389e8e ("zram: introduce writeback_compressed device attribute")
> 
> and shall queue it as a hotfix.

Sounds good, thanks.

