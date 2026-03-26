Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE45110AB810
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECD66B0005; Thu, 26 Mar 2026 15:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4726B0089; Thu, 26 Mar 2026 15:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D014A6B008A; Thu, 26 Mar 2026 15:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0B756B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:48:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B4E21B78EA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:48:52 +0000 (UTC)
X-FDA: 84589252104.04.5590F9A
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id A0989180007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:48:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRsQcqbG;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774554530; a=rsa-sha256;
	cv=none;
	b=1eN5rNRsyKDvRl91vkEnfU2/v+ldSbOoHUG3kijNMgw2XqsJ6jx1cXIdJC8uIr2Fb3mfpY
	VjLvyhqiZb9Ty1zAd4+tVbiQ4hVe0BddsMXA179sUJj5KT191TrzePAxfvtl6OEiZya/bl
	kZLDfAxx7hpCFBtob2K2AMjjhHJ+8Qc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRsQcqbG;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774554530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Y8SN5o1ZkvY84l2Y0g1HhDr11A0odVfZb13rFexrew=;
	b=IqoxTwBQwtGpZ94ECzZAfPcAj+/8Pc6Y6AjCL4MPRHVwFiuD+rqaYsw3pHoufw2zZVixdE
	couGd/8MFg2F9dBfHg/r10vrGkdJ9bjkiSqI7ZBNNav8eOCMTbsfSNVU39MAcGW3CndOnt
	TqsIThGH0jw7uSsrGWhCwqtS+rKf/TM=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cfc5941028so246329385a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774554529; x=1775159329; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y8SN5o1ZkvY84l2Y0g1HhDr11A0odVfZb13rFexrew=;
        b=vRsQcqbGzE3f+fOnOGMitZg+NuRHCupQSsNvOuP9c1cRp9+GX3U5xgje/+pkCkXDnS
         RHbL/y6SuDaV4hXyGJU4i7HxowTGyiSM/r01LYSM5Z5L48sjiPznkxB/SXa8tBoF63Bl
         bvrfw2z7MmonXGEhjwgZdb1V5SOojCAd6H/81gxxJVCon8L1nMm/VhzTohcDT5KHsRd8
         mpf2OJHqVSKoR9TelasLXK+ZmgxvqUahr0cGonaMmfumQNftycGZsDRrUF39NFFQjqyJ
         jxys23zSItFz0Gy+AVFtrCcmb7CrdoAV3yPa6tolzeDA2q31vR0WhxGZp/FJ1Z7smK2k
         Nm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774554529; x=1775159329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Y8SN5o1ZkvY84l2Y0g1HhDr11A0odVfZb13rFexrew=;
        b=r2pt5c/qWYTsfi+2Yu0PNwTKqT6/qOH5yezkK0OUMhCQ2BsRmg6adKLklPrmOKBH45
         vtVvOYsOqKvej4wj1vwa4+n+G5w8Mbo1xZDfyqxMaryEaQT/+nyFfUWyhTCCv/v2CzGy
         wtwT1/Cb438OSRwoqjUu57nHT+BIb1d3tszld7JkTk2AvolOhGvXlSQ/uXPMKWeZb686
         30yqbfuITDcPfwOf9a3Q7DDLqeydBvryTECBfjn68rQBhz4eCwlrGgCMrpAqnMjeQkSV
         IAElKW9C2kL5UfXCrl+sWns1K3u0SFs78LBbBd6z6h/T4pT1aB5OsfK9xQ2oumEeGVIR
         QA6g==
X-Gm-Message-State: AOJu0YzPbYwfJaLy0kuRH+9MpvGDsvkc0+7Vj9U1ZP1aqKwDDM3oFAfi
	BnoRAJVbDYDz4kroPyFOs0OCfvCYsCxknQGUI52kLzS7mdsHCL2GgxaZRmMQ+YSSqEM=
X-Gm-Gg: ATEYQzwYD9nRx1zvnFUgib+K9d0+yWQsuLgPMaOHSxbaLfjiGcoeujxKqG3dr6cQSUe
	YvUUuOZDYIamFvfi7bBQbh1cnCOk4rTZDB9A7qwpfO+OyMW2SdA3dGTjE/LxyMusGT3kDlPx6iC
	QKxGugyfJh4c1fYQqOhIAfrFl5l7EN5uDWcpOw+E3XxQgCLh7sNnOQvyKWkjrbrIoV6IPqMTtkT
	jrTa1V6ol79cynvxGmfuvU9AJ8/cT4+1YQ6ZyUrzI8eRr9mP7jJZmofwosDdTSnrdYxQSn0R4sY
	04ubLvBaG0zUv4Clp+fFoLZSnSkUDaZ0rsgcWSeyZZ+QROfG/8pMeWhosi+b1rAeSFl84vSHjne
	6zNOcJ42CURGlaPPfAjNtjdBM5mzc4oMt69A23zMEgN5n+n7AzgelWoi0naWRXVlmrZe93JnaIR
	Nruqtiv2NClMMjwdlUl267
X-Received: by 2002:a05:620a:46a5:b0:8b6:1877:3689 with SMTP id af79cd13be357-8d00101300amr1194245185a.35.1774554529547;
        Thu, 26 Mar 2026 12:48:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e39fbb0sm305859085a.8.2026.03.26.12.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 12:48:49 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:48:47 -0500
From: Gregory Price <gourry@gourry.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <acWNn1sewTJhnA2f@gourry-fedora-PF4VCD3F>
References: <20260326162611.693539-1-gourry@gourry.net>
 <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
 <acV83cdc9ZfNk8Xh@gourry-fedora-PF4VCD3F>
 <bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd>
X-Stat-Signature: znpj6cw8kb8desyuyramh8qpnxnhihkx
X-Rspamd-Queue-Id: A0989180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774554530-514824
X-HE-Meta: U2FsdGVkX18qeOI+DfRy4RGh5blJLwks0e958w8DYuq0yUipZTiT+1b265s502NBtfPSvh0rPdjN8TpZCqV8Ze6M0RQHqBEOpNLkvjpXcZd2QnnkOU8cM7vgdx1CMLf33u4zDlpxiHKA2/qL0a1G+WxmTFbiQTNew91YtiOxMY82eW1ZDUFUZIj0ByenceMk3yiOQWgwFbqKFTLbF3Q1bX93QCQHZ5TZb9voydknXXtWcslGnycUjOS+o8wt+jjnwrOUYpsqmLh5QArAZGA2F9/VtODFwYmIy21UwXKFIewp+glS62JDCEbb2ycWNAYSQwOh69p9kUUYmIKOdStyU3TAoCKeFTdOEm2XHZ0MOiJBiKMFtmtl79tIPdi+S6PZobYKvR7pvKa1MpE8pgqKXpvxE+/3lm7Rj1Rvb6LoGuNmMu/5FIpJ38nxpEt35hpnlXzXsYeQdu+SnQ2w8xvsEMQcP2ezkCAxTXvlapLK7dlgM/5vRIhyNoiQk3M+yXtwGcUq3pzo6UAzkVs/D7FSPG84kgwTlNnTIiYOBhs7n/GfJ0r02ezEHUv2s77amqOI4jPgsMt8RYtJzlDcKA1vPq2R/tfovcXIY4+VrlcPNJxlKIC1DUpDVL/urxomFzN0e6Xat1bsu2jFJFYYkq8u+mw1TpnbsimQFdQ1TNk9egAleQ447zVh4LeOKu2tBGV23w/371gRFHHeaiJXqwOXSksX5+3zs73a/MSujcJPzDGdpvfk25zT6UqTkSkQSvM718TXm9CONrUdkq90DxXmfnYr9fx0LH/MuzE2Rse9ARXQVkMoSWS2MzdT4L4Hy2hJqe/tyWCkRQDKZpUcNDCq0sdveyb9oyVlswz7neNM1QPONlusDjn/QNLxHsbQ0u8Awb8ecpXdEnl5UDn8mrmqzzYeyRt/ktu2ZvlJU2IBxvdsx+iuLLoyHI09StdNGqYaqy1AENaZkHgPUvoCmPx
 DyKgp8jj
 GuLWkUOtUMYxJtOgwbCoCnUGnjXvwO0f27W7EdGcGB86K7j+I375+7UiSkiEdHgchvgSvW8Kx2PXMIL0J+QtlXyN9AkFEluNZLzPHNiDylOcOHauJ0k1VUk85s9ag1yZFeRibWNd+HIPB8p1urDS+PSeIMabdAfvkP+MkQi+9B8nkg/EwYh94VACd7q0GOZM4CCzgxiND14WUG8XOfhvXIr+EbWN4QtjVtin8yUVtoyY+IWVPDy3nhSeyqs/CvYLjVXd3yKLXH5UA6A2P79h+bprpIFejnfzt7xCsSJ7ILcRqIJ0o/TGwIgyVtczF05JPn6rqHKuEd7jycSXrMuqSDgqSLl4jUZzjroAKP6h8w1KJVB2THYt2FGk6G8W8q4j86qUASfTmeFVbVVp0fsDxogEUPf6/sIb0qFXlb+Gvh+6IDm8MDlImEHQC+gnx5R2hp2FS0YOvzV30k4QfgP/atyqBk7T9SY/v+h3NJrph5EHNutTi1En4zJib7X39Dl2ltrL/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:16:05PM +0000, Pedro Falcato wrote:
> 
> Sure, but can child - parent happen when traversing the i_mmap tree? I don't
> think so? (in mm/mmap.c)
> 	/* insert tmp into the share list, just after mpnt */
> 	vma_interval_tree_insert_after(tmp, mpnt,
> 			&mapping->i_mmap);
> 
> The function itself is somewhat straightforward - find the leftmost node at the
> right of 'prev' (our parent) and link ourselves. So an in-order traversal should
> always go parent - child. Unless there's some awful tree rotation that can
> happen and screw us in the meanwhile.
> 

hm, i think you're right, i have this inverted.

But this patch objectively fixed my issue, I no longer see this BUG(),
I don't get softlocks, and I don't get the guest corruption I was seeing
previously. It could simply be that the contention added makes the race
less likely.

Let me dig into this and just smoke test your suggestion - but I think
your patch would cause some contention issues on unmaps.

It's been difficult to generate a reproducer for this without running
hundreds of VMs, whatever race is going on here is extremely narrow.

> 
> If this is broken, then every filesystem out there using filemap_fault() and
> filemap_fault_around() has to be broken, and I hope that's not true :p
> 

Me too, but i never rule anything out.

~Gregory

