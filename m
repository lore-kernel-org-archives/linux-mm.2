Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6799CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BA88E0016; Wed, 24 Sep 2025 21:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B735F8E0001; Wed, 24 Sep 2025 21:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88E28E0016; Wed, 24 Sep 2025 21:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 954D18E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:02:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 159E61DCBA8
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:02:04 +0000 (UTC)
X-FDA: 83925970968.14.EB21DE3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B33112000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:02:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhhuSSxV;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758762122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UT/fz7W2Q59V6JjyRJ9jtQEWf+zMESy3JFVBEjGnVz0=;
	b=ysAjBh2KRGSkmiGDxWom2ri4c4FZhus6DQ1YLvJQKpG+AM0q/XxzuN1wvbVz/PQr/WIwRe
	nHLshjeYjqmpLelibt9yOJhHVYmWPqJS22fNI1LN/YYkiSucRuw6T+zzKhHDKh15RCXR+0
	NYVk7np79/F4Dl7k7PIr3Qv6dB3P4dw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758762122; a=rsa-sha256;
	cv=none;
	b=yYvCJRtQOmaEkt7VZ0CkSCHxSBqPJg4IciCjFsRvpaXqdAIj6kZOemSS2dED344Wh6EnuN
	aI3dOYNN/DI2u0MtUiPsVNjy877sfs0S1I6uEjke//coDDCNzIk19YG79aRM5LVUKFfbdO
	xcKpR1PpUkWuxYbd5dluT8qc++dn4ds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhhuSSxV;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b2fcfef5600so64680266b.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758762120; x=1759366920; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UT/fz7W2Q59V6JjyRJ9jtQEWf+zMESy3JFVBEjGnVz0=;
        b=nhhuSSxV/DhPty4ezgGDZlLNxmNVrGxm2DP00nFJouK6Gkj1WA4NNKyI7xil1523e4
         OhZbb7yCla51MyUIBOGbCPvJpVeXvuT4qOIFvM7S/2xa/X8he8z06KpXrx2yc+QT/ymS
         LvtEvj3Fqo4aHbKCR5MS8DnZSAhfzjNID4aoJcif2Tgrwf2wgZXb+CXhD5a2bxE0jN5i
         t1BcjyRMuM9tHJqkm/yWKDK4Vl8vFcM9edBGRjXexeYde5fDCbjs65KtTMTh5kaLAUro
         YnCgcugE7kUhIebmqYOWR6H9h70WJyJn7fpAHA0SIY/yoI2fg9qqqEOxuohyJbDZq9l8
         xNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758762120; x=1759366920;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UT/fz7W2Q59V6JjyRJ9jtQEWf+zMESy3JFVBEjGnVz0=;
        b=J7giF7M4VMD8Q7UVJ5lPZtNw3Q7MVaDSoyrNkxL/oi8AbYiF7ooPmIpaN12xvxmNJg
         hU9eMXNTG+6AAFYEN3ZFFLHigt3jw8I+omBK/cneHC1ss3mqrZ6V2KSJZoKNJwSO61u7
         J7CpcX1iV+VIlS2JvUMeTK4GshfePIA2h6sA04HlkhS3aRZvPDmTZ99OhVPmLfne+PYJ
         +Cc7a7gf2LUmHNm4aKqcxOy6cxutuMfxKYYrLweJfE01ZJDvdc1QvbfBv9Uc3cn6H1/L
         1A6eiCTtDTSrcJAGYFIsDTah46Vsw1C010S3RXYQIaL2D9q7pB98zEmTdc0a6OiHPXyc
         uk9w==
X-Forwarded-Encrypted: i=1; AJvYcCXhILw7GepQhsC1YAB5rdfAitG5olq06r4S9jf9jNMuTZbg+AjUoAneRu7MH+t8j/wTGnHEHFQKFg==@kvack.org
X-Gm-Message-State: AOJu0YxozeBgpFrmnRVv8xBicF55kiEac9MB01uZQTZ/Vd48blEte7hs
	mdY7h1M3RwGWVTndzD4F/4OW1auJgSd/TFxlE+KQ57gHN4rAz3/QumQQ
X-Gm-Gg: ASbGnctjktC/s5TEqWpSSXGu+rbP3Vjc7f0onbj01RwBKL3EY/SmtDGWsOkoEuHRgp6
	yKECyKQkuMiU3qFX55Oby0iiUasl98wzgrjG3X4MATQdvX9ZicD4Es/GSfpbvv+dkyosGxsM5P8
	iAwZJ15Y4cQt7s4p8zDIBA7YYP2vvo/8Ou6kaNo/WWUnik1vQUTe2YGiUfaBmEPZ5Hbn+Xnl9+4
	EkhJUI9EgNJ66FsqGarYz4KcphYU1xE/9zFpdqLPAF/MQsbBbOGqFwr/oze1CBgPVNXgIJL5F2U
	bVzTszHbRfj7xeQ8BUI49avr7+dofYYDu3y8oBAFKebakpvenuLSpzNa3YHBfMXMHxgsdnMtkf7
	GFI6o+CKP8KVwh6zwifr/ZA==
X-Google-Smtp-Source: AGHT+IGSwVZwfkijJ82DMmOlzOe1J4ZJJFXvzKoeU/M4Yrgt15c2Zwukdh41qG56Hw5/4H7YE2VnSw==
X-Received: by 2002:a17:907:e895:b0:b24:6e6:7117 with SMTP id a640c23a62f3a-b34ba93a185mr185900466b.32.1758762120190;
        Wed, 24 Sep 2025 18:02:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353e5d155asm53519466b.6.2025.09.24.18.01.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Sep 2025 18:01:59 -0700 (PDT)
Date: Thu, 25 Sep 2025 01:01:59 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
Message-ID: <20250925010159.psdey3tir2wvlnoi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250923140058.2020023-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 0B33112000B
X-Stat-Signature: 1u8p5qp4xeoyxtfh1p7gcekhe9c68h1a
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758762121-279575
X-HE-Meta: U2FsdGVkX1/1CylQGQnOlPO6+FxNALgP9ijE4Qhi01QeN+SynAhx+9OmPAKCrmT01+kCdkPqr/tpEuyrebzhlObKOumGex0SIlVR351MqA5zDU6RPGr2LfyTbQ5FsCjekaJatRfXg9pF+TNn2G0uD6OH01OqzYNXIqy0+dPiGgJlx2DBLPSsfUmE3teF40Ejd8ThYv/0Zv6VAHWfauuG4ho7PaJGNvidgL8cPOllvt+IY5X9hcd/V48vpYDXXBWTVJcME3gVbO6APQdbJpEV0O3weFX0xzUNM5mVYo0dOsVD3lcR4u7En15+8o6i5jG18h1H+Yp03iFpD+m1gS21kHByyIvrBuFBPAAeFombWKp/8eCF/2deWuCaYXtZ9qdXovrqYP3a7UwnANh5iDTW2ZaHD7UZ4K7PMBfEMQHgP8W7AOrlU8h1cHpMXY9+Im83jfgugxH9BQf4OlKtaWzZOM0JAQM6ojUDW+yD6BBKZP0IFck3m7WqmKg+vr4hNCWItYRbW75pcekUE4LJQuz2svNYPBXCTCgp+s+SbkSxFLgFK31bQhUdbr2QNXv6QLDVM7gXY0scxwGZtz6NZxyvVCsn1dnLU7774xvNV7EZDBSQuvyvgpt10UOip2/emy4DHXAqGo3gaCSdCa2+VZnSht9y3Dk/mqqPst7Etr5OIGFqgMRMK4OZ/wKTifIbD2M0nz5z4RgKl9NPSSyJibtUUyskY4nQx2qcqJKrqa004O7tgv/Qh+LIQiC90jn2sJxSBO1YWfbgxZpRO1D+LamTyQwPTHFhvXXiG8IN0vp2cslz0R2C5ukrNvzYWrzfYtznL7AjlLLjiRoY7rUvGIh8NxjDzW7HXJXUNQ1myQeFlHGkEWG/4/N5+M+VLyMwPxuNCbcK8bYydzyX5ophQD9jyZ+hL8AUPL/yimPjrOmSFhD3ZgkIBHIUg1yYLUHTIKmWAP4CESPei07vZ8XJmcb
 BKu6nrXo
 UQDJf6yPt/rgbAstbUdF52A2jKGcAuHxrZRLJMPD8Up9GaCGtL5IgtGo1qTNa9G/U3UayT/pcpMNjS9RtjdS0clDhR/uS/Nch9s9VrpmQKJ5uRfKB3qEb/Ndncfrftv9cFqlgDbcJsIP0QUjnMc+BXyqwyhQwX7iMDKlhlPekHqHlVXpzFuuYtBGFWsTJAk324wEijI0u/VsC1xnrT8BIOIz+/OIZEmv5UNkLKvNxWYt1YjfZZ19DRmcfrLreOP1tnj6EGT+kER1Qpm5Xwl8ejD1Gnic1Cex3UWVpSDusIMZGTCZ8V81Bu2bOawWyT5itR15K2F3/9Z4LmcjjFRsfnHR3fhVokjEOU3blFJzkfqewG1qBjoJmUbiCBboJ4x9LLFM5qqWS573UlreS7p1vfhiTSaWZPtwEZ1ADszRLaUr9E0dptots1bxbYlyP2XVZUcTYdEnHrlUOLTjqq7tsxrkQKhX/FVmrMF5+V2m81oadNyz/f2+cQzajMuahJ6gw1C5QgPuukIL0TuwOkJhyGcAxzk0jKY7L5nZqPyME6K74vo+0TNGZgbvNzlOkJvMjYkOYeg/1lnu+W37HFYrIulDx+otQ2X1r8VQ9MEd4ShisbjtJywEvh+i51Xrqym5PHj69sI0PXFquL+85PC7YVDZt1Z5RIBznlmv+XI0fxZ4bXJVqHjFThGob554f4nnQMsMwFqK52f7ec6rBZaM2rS3R4QS6lgoYKHwRllnAx3AjJeNlEqeWU+PjHFIjI2e8jlHEt6Ud+vWBydB2ypVvPw+ZbftDmGPRHlJu41fb93d8IKG09/bl9zBcNc+Oxq2KWZUfS9whju0KjvD9L4xhE5i+zjwZ3vso4LO4ZAVF6PGlGEKbxn5SwshT9wehUZlNLNSpskr6UXYkdqxqwRz7mjBrA+WBZfpQRnns
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 04:00:58PM +0200, David Hildenbrand wrote:
>In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
>we converted folio_page() into a static inline function. However
>briefly afterwards in commit a847b17009ec ("mm: constify highmem related
>functions for improved const-correctness") we had to add some nasty
>const-away casting to make the compiler happy when checking const
>correctness.
>
>So let's just convert it back to a simple macro so the compiler can
>check const correctness properly. There is the alternative of
>using a _Generic() similar to page_folio(), but there is not a lot of
>benefit compared to just using a simple macro.
>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>Cc: Vlastimil Babka <vbabka@suse.cz>
>Cc: Mike Rapoport <rppt@kernel.org>
>Cc: Suren Baghdasaryan <surenb@google.com>
>Cc: Michal Hocko <mhocko@suse.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

