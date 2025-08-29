Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F8C8CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67998E0002; Fri, 29 Aug 2025 18:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E468E0001; Fri, 29 Aug 2025 18:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DF78E0002; Fri, 29 Aug 2025 18:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECE98E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:56:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55A2A5BC77
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:56:38 +0000 (UTC)
X-FDA: 83831306076.10.3C26D38
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E7BF180006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:56:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cyBkuDzg;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756508196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moy+v062wTa6PMGyjHux9KlOsyFyasxsckZuNnnWIm0=;
	b=dSw5KHdvIPLJPpbwJJpZ6I65PUrAjysgTTwAK4Eg2u2ahWp2QAvWo8Lnd4fP6uSP5uXtOz
	bFdLiagSHXdq8ZdOvhKsIkxUDJXbquvlXRiZH//KAYzYebNX4Wy+1FUiUsv5YZ4fHSXhqb
	U5/EY4NejvKK+Ms1KyuCAzU86Q8nglI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756508196; a=rsa-sha256;
	cv=none;
	b=MdDPm0AMXkBgUK7LjtKLqXzatiAiBsV/i9uBMvBtaOu7h2PZA1HIlMDkmgEB0tJ/2fTqKw
	4JzDKvL7tHo2FQ+0drncO7l5F7uAGzuSpxSyRReX9F67gsvrieHrcZhzxTp4ayNSI24y4O
	Myh3+GWznLjFhOs1UIbOpu1tOZ4ebbw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cyBkuDzg;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7722d6cc437so1113036b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756508195; x=1757112995; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=moy+v062wTa6PMGyjHux9KlOsyFyasxsckZuNnnWIm0=;
        b=cyBkuDzgayGtUylSFGMf6IxrQtD5afaKrOznNTDI7K+K6tybVrFW4aUX8qAfLVeHKJ
         Veise0YTJJ6lPqsm4Pkp6G71phBf9QYDZv04ppWkmjo4sIXu3c5cd5WNtQkGz6/zntUP
         GEFkF/6s8t1zPJ5j6+Y9tZzL7Eb0Sl/XQx2rqaQg8xcIkIC+c4Cc2jMM8PB1sSZsfaHN
         1fG/lu/nA5nGm8R5gwj8d+PZgzyyYaGK+Ne6MdY/g5/fF4e3CjJSi7H7RFgs4TSJzbnP
         1O+9McxXecakfVmbIAslDK2iL01bghPuR9DDTUJ4PSpMpWZSdE3xNYzWWbfzl8tfM89y
         TdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756508195; x=1757112995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moy+v062wTa6PMGyjHux9KlOsyFyasxsckZuNnnWIm0=;
        b=MnGenXqGUfUtA33g4ro0HhmQgJ7lt20od3VIBYfoKALN2dffrCh/KE5iHHgsG7NJ4w
         ygEBq8KGvVklA4XW6QHKG1qDfmcxUttY46ZX0F1Pfz3NXc8Lw7fO7Fs9zASWz5GDr3YE
         R7IDy6hKoZLNW8tp/9t3yxMq3hjyzB72aD+w7txLhFpCP401iBhrxbNAricJfHNYuJwT
         R7m1kBhn0ylKYVygpE0DuTPWYDD2WNMxAqlskClIADxIKbOYnH38/ZBbF/HTnpZ2LvV9
         ySHvTgVdZf6lGdmjVKuOSnlO+jn487xoBLsxcmeQkuJ3TqHZ//hWiqwbGK4yIZbHqo13
         MMyg==
X-Forwarded-Encrypted: i=1; AJvYcCWLv7Omv+kNOQIfBkBDEPUSZEk3Rt0R5YiPccmWtlR9UsVkGgn8HbVYZ0LIyUxN25nLBkOe372wcA==@kvack.org
X-Gm-Message-State: AOJu0YxZ8YPSsFbhY8STP/rNgltcJolkbnSWw2bzRNRyzigxSzU/UM+g
	L7mFLIt6ghY7H7w2UvqD5SlRGGQO+clRAseM3kXW0y3mVLmHB6K9pVRD
X-Gm-Gg: ASbGncsY5NvpYYk5dCDRdex37t5Lb5ugHDrvABaA4FqmxU0yh5nbf9IaKr81hsMNDyV
	Dc+OJsiKvPlr18mWksFo0Ngc7WAcqMW8AgkboIhPmRVlMtd9w+TwZ1KpSf3GANPLAxIMciopLNj
	u4OANDYUk7KUVCMdicgQSJgt1ksGFBglUk2gARtcLfoUe1Qg62xCtMgX7cV8Hmp79pYRqZ47BsJ
	yBvCck8RRq8z1GvYJMvJW6E+wATVbswhzfQ9XQNkRiOMr3BHChnzg7WEu33yJi7gGkqyefl/x+O
	XQNhOE5Sv5gTsSYo61bzIbKz1ZXjOBJYCaYxgQRxFlI6YfNzNa1wERZgpaPxahR/grRCy7jV9i+
	OiCgwMdA4e/a7O7ywSpEzgOiJULSsPFTgB2N6uHT2QZ+QqpR2mDhZjRp0+8PdR/dK
X-Google-Smtp-Source: AGHT+IHX87XDPNTiE0CXbUrwygn+u5VjX14aKgc0q9EfZb/nWd1682f2jDIgn80m50UlWboVrtal9g==
X-Received: by 2002:a05:6a00:85a4:b0:770:580d:87fe with SMTP id d2e1a72fcca58-7723c445dbbmr914071b3a.7.1756508195163;
        Fri, 29 Aug 2025 15:56:35 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a2aaeb9sm3312343b3a.29.2025.08.29.15.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 15:56:34 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:56:31 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 03/12] include/mmzone.h: add `const` to lots of pointer
 parameters
Message-ID: <aLIwH38S7A9h78iY@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-4-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-4-max.kellermann@ionos.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E7BF180006
X-Stat-Signature: edm6tquno8zwnk5ydumqu1bkt16kk9sp
X-HE-Tag: 1756508196-387953
X-HE-Meta: U2FsdGVkX1/4shqCkzxIv6UC9CUoCZTwkfOmALY5DthBdlRCmiv+3Uc87xhMtxZOuIR9hdaXNhj1A91SZm+Qd9adyazKefTnh7lSGTeJhQniVwXL3N7Om0kevivYycAKTacu2VgjzAltdfhZJhUC4MA/Ztk2pyI6hFCp3AdwgGqiFvxnNQFGMUv+xZN2KWykZrU5QmmECbGHT0sja+CQOhyO0CenLkuiToR0sSL5N5Svi6Ezwa3ZokySxn6WLFKno+hcK4V7xxoe5jc9xcHKx5P2VTXXlGKb7HehmGcZkbKqPm0qtPIK0Kx/heq6c+gS0vFWTKYcDIEouoUPz7xDj2DtZ5uDz486gZHMh5CkAEY+P4OE0lIeCfRL6Cm0MzU9QX/4bueJEUjkHnqzzG1A/Nb2mIyUGaL/qXQ3+ngcDpKc2TgVVvDS0bdxwrMdHYBceGnh83wyARVIRBGPT/dhAVZiY9Kp6p1fq17cItAobKvDy8RgS0bDqgQm/X+0/eYGJT5L+XlUxxvX/AnIEJ7iA42RjvKO81E/tTe+ikMtyZCOkAj2i5AuIwzqhdTP191wq4MOIDXL1QpeEwvBgHWzyq/n0Uwjt+ITQalHal/KMmgHwHk6ioMC1Lfktb3wjbhUzTFMJ6sd5XR+TAT+TBxftYRnGy/mwLuOzzwxroeRNoe/LuPZZPNTin8D+7XWzpTeMKDwxI3F/qC/5NfUJI+OjFJL+lF02XlemsNKSVGUpsiV7gIvUT4KAzF4Rdlg3UcZ9mU0wxDNoe84Xw40srAfkbX7sdfazdDmUPk1WnN85Wd0AVbVlCm24bxbTVOGPtwPybmfHAgDXnZfIvwIeRkjFjGUGeD40OkE+6c5Nsgr1zRshla3T0mZy3brh1GNJ/s6oIyHsvYIbiTuk07bdx63eyx9Q0XN/XuYaaMMXRLuzSh40msdScJeiW8o7XXzAN3KKKXMEuIv69LIQjXXnU/
 e1CaQjCH
 WSl8BN9gGWNFPunPG8UAbYsinnck5HdtmBIhnZpx3JU7wUT2aYPkij+lc2xmToIxrFT/UZbhHw505IurrWbMnPlW78nHla6QM1nCQzU4Jy/eoXCUKyW2c8fz1m7/JKEQS4ix5wvYOieGRxKzPnTfxcv+ojF19fJkIbqzJHMiAU5kUTdAAJXZxWZvpoeWFfM16CkZbS5USpnczOhxuIVVRd4sgxPhozLdMgOMDpIGb2t6AyRhMYR+AXHovbQGYIJEaYVTJ8UB+bS3CpLwX6fcV8699N1c4EJREYFJmIpqTpZEnwkZNweNak5xPJTJscQnNyZwMsONw1WRJKeXAmVwXZKzCQCwVPDhKNbwPCBr5sv1Z6T8SjorRAF0LTuh4rq/wPMQoS2ZPSu+qx2Ouu0MFsBGx+xaDb8t9q9mYKT+Gtz/CaH1+5yt12FtsuwhpoGZWyKeCOahXN2Dm7R6IP0YWPgAOfmWlpsc9yQR1IPWpR/YcxJpCSh5UMAk9BVyZok0Xjwbqmwetr36EsfQ46A5hbk2kNa5CSGlXNu8a7QUt213sH1+4k/RpmOxBEDMBRrHM6RJ7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:50PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

