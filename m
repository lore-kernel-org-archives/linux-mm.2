Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7057FCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F89A6B0005; Wed, 10 Jun 2026 04:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9B76B0088; Wed, 10 Jun 2026 04:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897F96B008A; Wed, 10 Jun 2026 04:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77B306B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:23:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 598B39269B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:23:22 +0000 (UTC)
X-FDA: 84863313444.07.6C65342
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69F85A0006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:23:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eEVX9qSp;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781079800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQ6rVmHZAbMgF/zkjs+bnm+j5nIq8bjUQyfEZeFsfHU=;
	b=v2+OBoRIV0up6GRYbgyFzl7ugpyC4Hf0sxC9CNve1ThR2QlBwiwJau++GpD0Gx6TmHoD2o
	CyU1NYpDkD+4UD+f5/teIYWBiMo/0KThF1MIMyBVzAxP9+zlB2C1sEDI3a1x9q6yTeneqx
	QQewVai6cMIaLVdl7PKvt+PAG6GtuJ0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eEVX9qSp;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781079800;
	b=VTH808kz2mnW+io6QFk4NTbd/I7eYXwirL4/PR1+iX3dh08V0idnYlV0VJJs4XRs9X6CIf
	VMnqAyppQzJbwWDyw1SaDAH0WkDTlaBTwySrHptATVDTXJr8aD0Vj/hSA2IZqDFqOxVXe7
	IbdjXUHIaUbXQk4C/OBvIewOOVV5K7U=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso54971255e9.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781079799; x=1781684599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQ6rVmHZAbMgF/zkjs+bnm+j5nIq8bjUQyfEZeFsfHU=;
        b=eEVX9qSpuraLaQly7/DwEyom8V0wyOS74oxlEoDUwA/66UgDk42O3AP/T7bl848biB
         CVm9s1BdXmY8UVIPFd7ttkLE/gL2iSd0GgQaY1sFlZ82xVVqhPrf9uAxwJy+n6G92BeG
         zn/M7kDEdih/6LxrJFCnJuiu7ozN3vVZnN646iE+MuKbnDTvBWTgyvgHz3t0/8Aj2SNh
         ATyDdoIO5nGjh73uUryodmlaw0BgMnMIdvRDJvRqLncca2ixEKqHwojpVVA41/V6nlZr
         aQ1ID8bIP40AtlPR4N1Qqd/MCwNmooArjkt7uT3X9M5rI1vuWGuHz0KglGWQQhnhuKhf
         Ie9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781079799; x=1781684599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQ6rVmHZAbMgF/zkjs+bnm+j5nIq8bjUQyfEZeFsfHU=;
        b=Q+lieLdNnTUwwtgJIUX62GNG+1GMrHohLnRDIaCw5N8qo3o3dFNLoxA0UewAJ3enoI
         f9X2RUtxs9CcpnW8wJmE1JrL/+CZWkQ5wADEdhSzH7m60x3U3J7ILTaaZ7tRUCLR+4d0
         HB/SuzrBecu7oE3InBpbPTzsYwp+dClEYLvBjIjfNxf2+pR7kgbveTw0nar7ivi6EsDC
         Jde8EUX6eWUXdtzB8cjz9jdrW3rdkzkdTX/xjRHbvA6Y8TyzSjNNdlwHaR+Qi8gJ71V6
         aM4k371tkOPWroSYOK8dQK2ChR6Asww27wFFZV07IcW1YGK9tSutbCIeCkCl5P/bbLAt
         vzpw==
X-Forwarded-Encrypted: i=1; AFNElJ9F5lZkKh2MDC+A3+MaEGqyir6y3cCJnSwuPuxzgF6VuU7Ms1YmTxhP+t0epxKu4MkOX0M/zSOjVw==@kvack.org
X-Gm-Message-State: AOJu0YzWNzFxkwKAfaP0/sswJI+w6HCXARsiTOG58r36lSnMj3GVrAyd
	6+h1FX2wc18M+UpugEFtvjq8MK/mf7u2OCS1LgVqdrN+rk6U+4Bfx06h
X-Gm-Gg: Acq92OHCsRuVMSAgSsNU7S8nhGBgTPkZWk45+0dNdy68eaFyCRsDwEOgJfxkmSbmeOE
	g1Atx7Sg6+pRcUzoYXY641i4nBgS7MH92UXkOPoWnMPIm7bzU/3Y3C733O0dFbluTIwp4iN6Q+I
	ndZyR+Yr2S9mnBq/EUyDSQT/Z0oKgKNf6GGry5y7wpACEiy8RAWCs5f15LR/P5e3sAZ1g+EhkNH
	cPv/s6rNWoovd8XxUPnZ+f7axVoGtpx6YL5IeiR1LRzbeqRZmZNGEcSqivGkkjgKxznpxggY3SG
	/z26wfJPOCrvwMxZHjf1iHOFZDyFmR0+fFpZvBMgm9ak3Z5E9KVcHdn1UnEBGh+H1l2My2wzfi5
	ktWg6oqkUpYnCr3DMtzqtCd2/yV1+PVQcwzyTnC76s71idHrY/jT0zIDTrsVWJdEIKHNkMRNEyx
	EtG6JlOBBG1ZvlWwqpnTI+aQ+JuubiIwQ0ik46ZjHFZUVs+HTzekCA9twjbWOTDKTRwlhXGeX7u
	GiUDsvCUXeDXXimTa5wp0wnPQiht5f/8kY+5XHdmEj6
X-Received: by 2002:a05:600c:620d:b0:48f:e249:4094 with SMTP id 5b1f17b1804b1-490c25fa907mr347359715e9.18.1781079798508;
        Wed, 10 Jun 2026 01:23:18 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc0f8sm540427225e9.8.2026.06.10.01.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 01:23:17 -0700 (PDT)
Date: Wed, 10 Jun 2026 09:23:16 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
Message-ID: <aike9DgWxRIdlmWz@fedora>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608210618.3437216-6-willy@infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 69F85A0006
X-Stat-Signature: wphcg4ry7xwhtf8ojurefu73w149axsy
X-Rspam-User: 
X-HE-Tag: 1781079800-489249
X-HE-Meta: U2FsdGVkX1+XTkpMwniYVIWP6vUDswMLR9i+5q3SOdX6yALzFA/1wIwH9qjNUwYLJiBm97q7X0f1ypd2CK7D6xfgDY1LPBRaFWQxYICdEH5O6mYOySlzBZXj7xzy6Jqu/O7MTsK9Zo/j0nvb+yrTOAlIP7tVLM95DVtYz1b/Dqe2rKStVPEP0rI0W+mhGUQkEtNfp9mEoPjEK9VPx1dAWG2JUwY4+/4QTq69vXv6bTEZuzBioRG3VeCdAK5/UqpcJEit3s+xCpUwxpW8jSScSVgvJni4tPWcWvE/OgzZNfoDHR4lyGfsssMULZwwXJ7x2N0/sOHYhtW2Sr/VsQxJ+SKwzvpPUf1oj/UWWIdw1gG8bPA7DVwwY++7pxRXO0Egf2bcvOSU/rqOAlbJAnJDi515MQDUNDNaFLjsA9j/WBUacbq6YO7MEUHtu45zJhqmmY+d7W/r0ZIafAsU/1tSLATuqZG64MCMZ16Xrx3vhqIgCUGePbQ/qYnM+C7UZe/pJLqYDNTSPJweNgb4mmGnIeSRWL/EUyI4IPWDxwN5qaoHsdQp6PiN6JItXt4QC2gwwVq9VfBBPkx+yVhfzvPleYOHTQ/yIOQoHZnu18VVs5hzJj+XsH5qX/ruvrgNmUEMzzsRNi3iPG1z21HbyqaJnQZXqsgwVcj5+SzR4PeYnAbV1Agq9QH7gV08Q9YSnWP9xu/wtGif9HODAUzhq1DuRNYCHm5Thbpat5DDv1aldcpPxS8J5I+gwAdjbv+Bw/QChpQZ6dZ6epVHx8clju0oqxjJtHi2Z8mn6djJ9vDyZANlOZAvjg+EX1qTO0LkCZt/oh3bUDWVvGEauD6EtLcsqgDcaAMXBBKuIxtHVuBED481Fh5skoI+rGbLhTxWK8JBLhTZ2YjLplCtab08eG+qno28HUC8fEljeAga8CKwHCaXTRE0cU1D/dzePaJOpzU6MxWJVqS9DS9d4tSurzx
 5T9dhSbK
 WFL5uF/ZsUV2ALy/0suQ66D2FzIAhaYbcoKdhNPpP5EOWzW/BQwuFtfaQ0vMpVfye2uhQWiuY7etlblWpZW01JGCUzZb+7pF5BKf+Jnq/oMUoflUTTE0qgvTFL2moh05LuQJm2Im425eYpjgwaDdny2ig6y6pFQa8iyINjLY/MX22y0zkpnQrBFQS8FtrtLxMK63iwnq2ZqcdyVYyvCc3DM5uJf6VAEVO7qk5KQYUcJsXtMdDkvLgjBP9Mbg6LtRQvWEjIURtprhxMec6snRVqKXPcmYsUOdMHAubVpjg5rG/voz6x/z7YzEiJnhbXbCkoX0odyoGVZ9aQHBWbkpOwrMxj/k9re/7SeQLCwvA57PNBeaXgrYtfYtdh1zwNlNJB69rxXz5OnUDd6Qteg3KAxVLT5RQM0tTNIucwFQ98HRtsjjR4w7FhqjMItQ0+Hz/wPFVqbuNq2NsfvRGeQhF7kBbEL7ocPG5u5ZdybIvQeNC2Z3k2xmF04Kwzggjul9gKkoT9BQerKHPVnqsf6O3HwLC6kjSZGnma5bADWoCRp8vMTU+l2BJEd5sXGS6LIgn9H6YB1VmyIwEYsdUpmMD6dWIsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:06:15PM +0100, Matthew Wilcox (Oracle) wrote:
> Pages don't have indexes, folios have indexes.  Just delete it.  This
> script is going to become increasingly barren unless somebody steps up
> to maintain it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ye Liu <liuye@kylinos.cn>

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

