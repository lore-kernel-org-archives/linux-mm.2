Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F175ECA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 11:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCA86B0006; Sat, 30 Aug 2025 07:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADFE6B0008; Sat, 30 Aug 2025 07:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C4F6B000C; Sat, 30 Aug 2025 07:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8DC76B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:48:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 236E685B69
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 11:48:31 +0000 (UTC)
X-FDA: 83833251222.12.365EB1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E23E84000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 11:48:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OxBuEsTw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756554509; a=rsa-sha256;
	cv=none;
	b=BVIKdH72X6HirVjKhdgkgxbpYxKjvpKwlq8BjwBllP1j2EJDzJDAT6rd+xexZ4lTg03QyD
	ZGzBcaAVdiYx+pOlRYp0H843Sn+tt7QHAIKubzSgQTxVqfPIX2GufbQJyYzRm2WhgwRs9s
	PWk0xTMbmn7TD9KWRP4Bs9NMKT5nKSQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OxBuEsTw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756554509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaKjGFLwy+V7ecd9sJXmkoNWgd3Dh2vSUHl3RDc679g=;
	b=vi/rGtfrdO04SdxXzm3K7SwzFfGqIFCKSThWo2nsZIFbCuronHc+7X1In5R0jKzUBz6q4I
	ThI//0tLhZVix0isuy4SCd23xLaYdmrCGdVu/v4owbGZGj8Udr3HniAWaQY8uP3tJSAYT0
	9FGVxE/1HcQ+h8BjHYeWBfg5WiOyejY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756554508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KaKjGFLwy+V7ecd9sJXmkoNWgd3Dh2vSUHl3RDc679g=;
	b=OxBuEsTw/5ofpHk6RQQTW4eCcDSjhON4eFyclzZqd3gSAVmO50iH0VgggCxhLIzB+Fjw4G
	CyJUabJOcJCK+FmAaRPhO/360kLUdw2TZfK/v9M8z/8ZD4MfT2XMIDI3JiXxQtAcNs7owv
	Xm7VGCTwiJzmoSp5XGuLPer6pekHuWw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-ioG4604PPCGci9bZsgL_-g-1; Sat, 30 Aug 2025 07:48:25 -0400
X-MC-Unique: ioG4604PPCGci9bZsgL_-g-1
X-Mimecast-MFC-AGG-ID: ioG4604PPCGci9bZsgL_-g_1756554504
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b83ae1717so7532225e9.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756554504; x=1757159304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KaKjGFLwy+V7ecd9sJXmkoNWgd3Dh2vSUHl3RDc679g=;
        b=v0CPHpawjDYfBUKHFfwhrrPNhyW5mdhrromDCnrHQR1PM9YCbkJj51YTJuewry6i4N
         VpTJLqRjbsBMEeMEckZcFoXGIqmPI36Ob9zfLLCSBXTZG4DejGbR9uHABdtLVQJeBQ+M
         MfmzxPQNgXEX0hHjwHu0x18I6ZwKKsIQKLWKr4lLb968B2PcOxlMEkMdM9zP1Vk0/G4i
         RzRMQF3PITV5hDotgZRdac+f2QQxCRk56Y4oRG6C2lOun94sl/OLzqRUPi4pMJrwbVwm
         NVioIhgKKzA7uKidFrXX8jbhKuWtTXEnNdz49mK5FDr2Yf1GRVjb7eLYBlx5s8vmPQmy
         JfSA==
X-Forwarded-Encrypted: i=1; AJvYcCXjRJrK//dBtGSl3Aj6iz6oBDcy/RoZ88BEd/pErs8dd/pDfUjSGmrT2j4v+9QPWxr8dwYgTIzXrQ==@kvack.org
X-Gm-Message-State: AOJu0YwH5Z2NwVGC2krQyROn015NQpQfbuaXKzNDXNm3Tc+QJkvXxXDr
	P/EYbNTtHDGjLa5OtFySrSRvsVIEU5SZInOC0LjUlzwZnsVMLLFEbbO3xxvGMYZnhDf1pXqjHoy
	0Z3m58iET/1rEdQ9Ct96yZLlbVVv0ODfLrw/6YEAAXT9Qyupo46eQ
X-Gm-Gg: ASbGncujvh8o5c06vZR5GH3lITR+2APsNcOWvsIkTeGz9yxR3zBTKidrng+aV1yMScy
	1q+PaIc+u0ZRFhRSQHCTrulIwPKMVUScPv7cPtBPx+fzvhdQd8yBtcs0068Aun1RSTspU+JsKzb
	w2T3dFH6pmWXs5M8yJXzP2d748Duk6/fByi9TKX3kit7pWpdyvpUR1exAxNFYA+zu+U+42nRNz/
	Nn+y+jGh6AK2qOlVAxPGKWF81sRVnFVsadj9J5eCEtYixOVkbC1s8REaHt6nJ9TL9ghcS76t4+p
	DFK7n8GNOPBKA8C9x9eNg1mWWKQ+6DwslkY=
X-Received: by 2002:a05:600c:1c98:b0:459:dd16:ddde with SMTP id 5b1f17b1804b1-45b8559b660mr12175325e9.23.1756554504259;
        Sat, 30 Aug 2025 04:48:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6Nv86gUIdggy1hEBUnLjrjO0ADmTfym8Sdz/L9HHFlU6ED/awS0qFW6I6CEH8xnA1upuKWw==
X-Received: by 2002:a05:600c:1c98:b0:459:dd16:ddde with SMTP id 5b1f17b1804b1-45b8559b660mr12175215e9.23.1756554503856;
        Sat, 30 Aug 2025 04:48:23 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc496sm7074059f8f.1.2025.08.30.04.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Aug 2025 04:48:23 -0700 (PDT)
Date: Sat, 30 Aug 2025 07:48:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <20250830074747-mutt-send-email-mst@kernel.org>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com>
 <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
 <aK9Ogjn71JoOM3w3@fedora>
 <aLBthEcK1rDPQLrE@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aLBthEcK1rDPQLrE@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cfNngryrmGQTpyQ2XJafVUZuaVBeeK1zpjGF6d3H_7k_1756554504
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E23E84000D
X-Stat-Signature: xduok5huawbssoqd4tbc1963upy7qc7h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756554508-503662
X-HE-Meta: U2FsdGVkX1+UDA8tkuzkQRMHSBNOBsbZc4WwSV6BXV9ggTbWmUAYZRn7WGkNLIytvH/iY6PpVUB8wx29/GTDBGToAeA/aPXNMqI0bw+mjQJfdDYDeNXVouwnFP0nvfBsNUHFy5+ykDyCC/f5c08pfYzypor8+rjRL0ErkxVpQ+ER6RCimPvpyLi10+I7hmuIyyVnY4OleqiYBdQTfkKGqXWvUmQ0SgCLo9Z5Ha5+jPA2kvHMsy6ji7yUzV0/b6K5Lb0z8Q2JQCruvAJuj0u9VcYCEOlzi9U8Is5dJPL5eUyyeRLmNKF+C6CanPpZ78D42UeefAswvROI+zJscxuYPsdYk1hbU9m9C76j4lE6c1PorhoY6Hw6Zyf7wozIayoOUo4OoKXvIyyX6p+aItlwNRu7T2M9oM38xFLkWo4jNembpMBUQW2Apwp8uHBL7WdsX9lMnPAFzgq5wofQIC86+rEfARSfy96pwSIljBNHvFcT4jyp5omekqnudnJAcO6DRoGtfnjT/zSkjC7hSqQd4soErFEfwlHO1rPdPMf2oCn0g1ttTzg0MUYF/O6+I4TaUjSJO8iQRt85c2cmmhl+AI/mi4ZVYCMT6LckeI1w7mFDjHS5lGzgmbclTG2ZS4GxrFND4Pirn50lX/3wk6zw7Tyxrv0zomjgNfMwoR461F3XKvBXLXzD8aj3YiJvJoJmRIlmbflBdxPprQfTEyg9zHcE3dPz9przm+QnfVTEWd/RZvJeOIqH9tuNtgwLZUDcLw0yxeR6JqE/FFXhIbpP7FRh/OUA3rSwG6Ysucj2p9kVdTcfRzKCnu4AZP+s1itlrMeK4De9yDlZJBUNW0vSKkyAqexsRuicGOIbvPK0fzOf1eLjNl2fRRRqp/6DGY9c4OOzhdHS+RvD7FqddO8DuNtHzhDddHSrhwLHO11IcM37Nxo/pSoE0fIJFhTyu/M3ojvr4ODGbClqv9CmLx4
 ecZD07vy
 Vduep9WGTAAD7oMYD/D9dGK3hcWp9BCqre+Sk2UPV4k/a+vk7oPxpgKf/e6NMNQHnze6I72MVbNghGaphDObCHVG50DpwaKdvq46Y1dClhYYNbjozJyE5mYXrEDtPPmhw+gazlt4otiei1mIudz9DGYVVuicfgs3BMSFCTQsGSc0Pet3pc2onqjZWiDUrX+FUqheXOzwYPCYg5toNA6K5KLzDW5+OOz5PSDjirnXkfkguL9XxECY4cC9d5TsS9LZEFBpFzcFW0kQDbYCnifj7Hcz/n1tXAkHnXCPZP/XGtA0eD8Tg2Vj2YA5peGHJZqvmRLNIe+U7vkOOkAqWrg2hLNibmo3rHtL/homZK31SnCmpVJBOHsm7SZbgoonSfkaW356/rtYTW/ZctiFGOpZfTkpbPKpczPgQ5nE2apiSYTDkBrW7JWnwCM1JB6kebrQLb/EKs1/zKm7xvBQKs4Xob/MZ+1hC3hV23546ThYIE0si25oevoBSdGCnGCcqfHCPADMAZchuWizISy8kBTxlPsfO9Fq06GpIdNaC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:53:56PM +0100, Matthew Wilcox wrote:
> On Wed, Aug 27, 2025 at 11:29:22AM -0700, Vishal Moola (Oracle) wrote:
> > I imagine theres more of these lingering in the kernel, but theres so
> > many callers and I only looked for the ones that were calling
> > page_address() inline :(.
> 
> There's only 841 callers of free_page() and free_pages()!
> 
> It's a bit of a disease we have, to be honest,  Almost all of
> them should be using kmalloc() instead.  To pick on one at random,
> sel_read_bool() in security/selinux/selinuxfs.c is the implementation
> of read() for some file in selinux.  All it's trying to do is output two
> numbers, so it allocates an entire page of memory, prints two numbers
> to it (while being VERY CAREFUL not to overflow the buffer!) and copies
> the buffer to userspace.
> 
> It should just use kmalloc.

Why even kmalloc? Why not have a small array on stack?

>  Oh, and it should avoid leaking the buffer
> if security_get_bool_value() returns an error.


