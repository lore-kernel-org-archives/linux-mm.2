Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A24ACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DEA78E000A; Wed,  3 Sep 2025 15:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6258E0001; Wed,  3 Sep 2025 15:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3048E000A; Wed,  3 Sep 2025 15:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF4C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:07:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A497BBA95
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:07:32 +0000 (UTC)
X-FDA: 83848872744.03.637CC90
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67B811A0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:07:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evfqPTth;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756926450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM0aeiZIkcT3/JK5wnVRf+4pQ6jjEjQhssy7NYZx4b0=;
	b=CRONaTULDoU2SuDiE1ceEai532TFZAB73BP3xQLl/5TANWT7bn9uDjo58HObiDYLICidiI
	7KWeOpMqv2u9qJFtfkpA2XtJ36dHQ95GYT2DK2V3VPkV24RV5haWCSBFMRpzoPU8I1PyLp
	kpU8FJcD278tkebCeHyxcXBh1du74d8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evfqPTth;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756926450; a=rsa-sha256;
	cv=none;
	b=A286T4sRbr1VIS4Eo8rbJIYRkULq11RgH1NCvvW2uggt7xzkoZZJq4KIWXvW/4l4Mwq9fC
	cjpyw2NhbGkg3yTnZoWSshKyjSg95DE2WORsqqr+AP/NozWXEKYeJDsERn5ZWUrdwnNygH
	uyhbG8VQaH8jhGKD6fVnE9zR4ayY5dc=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-772301f8ae2so241951b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 12:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756926449; x=1757531249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aM0aeiZIkcT3/JK5wnVRf+4pQ6jjEjQhssy7NYZx4b0=;
        b=evfqPTthHu4SBiyJhVpIBKNCvg3vLXOC1CdPJPmEM8VXIa/iB7kpXl9kPlP8oHO6qt
         m4lac8zVDH0CnB70Eq3RtH6bBFh4jpVQEcY1kdpvQ5J+4PCliZvMexOcPlXAWyt6rAzt
         aFHECjo09rvt+0Ck3NBMDlGpScW/DBC+YPR5t75s+oiJxaXh3gyQQSENDzG9DyuYkmqk
         Ito0jo3zwirY7uoG5fUzO1iD7m2Nof91FrBkT2Zut6bgk6yZk216xXbYDZJwzaOEvAxA
         SuK9MsAll7hfE8dJ9fRtU3omy6omT/C1HSpfAISpg8NyiH1XBbN4dQ7DNmHBd92IFyJm
         KQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756926449; x=1757531249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aM0aeiZIkcT3/JK5wnVRf+4pQ6jjEjQhssy7NYZx4b0=;
        b=NQgH53EgwIJOdKZbhl4DKfR6/Uig9MOzrhEUBEjuKCc0is6PczEj/lpXOlGx10r0TR
         0Bd88dO35lGK8WMBfCsQRbjJahujeegGnllmhOmoF9jhs8hTpBiQFFwxeZziPzgBY+RZ
         Bbp8hS80byNdzLaUyiGxLN4Hy7tgR81SymDIm/ZNOt/rH3csaUgJ92UOn0djA9GdqvXp
         cCCvL0UfS/WNYkloVCtXwyFWsrhej0Y5lt1jWUp9VgbNeWvWx1hBpl6+9d9wb8rnwxek
         K3I8WTA8Vy83dt/xzVmqo+r00tj2pTaS2prS2h9KvrXTmZLZZ95Or3Dj7/Y/O4kl43Oc
         Lv9g==
X-Forwarded-Encrypted: i=1; AJvYcCVHILU09S3ZSwK8RoZcYt9utyBEtglkuS2Tsb1TU6ucnT8vqBrg9W5irAsWZABhMBt/spsSG9LhJw==@kvack.org
X-Gm-Message-State: AOJu0YxZHVCcFJy2Suup61YpNUwyoZkhXB2JpWnJwEXlU86lMtLBM+Xd
	edVfw9bnr3Hv4CPEEJgfAPTr/bxEBRuWYPawclfv1LJRntfM/bLQ/6t6
X-Gm-Gg: ASbGncsR9lC8dJY8dCbnXR5HQSFBjV0tA0grQkckGQMmLRj/sdv5WwXX+1s53UsFP4J
	IQ6Z/1CyllzWFI9OUTnmuEkaQYxrqTwQMIhYvbMYTub5JzpcN8NS2rYpvc0hqDmRtr4kvRzVuFD
	asx0vBdCkbrbAzFoLC65/rG4ip79A3YjaYIfAQdNh3dc6p4tVVb3AvzdmFQRRFki+n/oiiuqTtD
	i7xYD7oNeGtlZZUr+OxKk3SZ+AXB6rndPtLvLGaEGfVuPgoQHqURCf5J5YQIn5CwdS12e0Z9Luu
	e+LmDgtn3VAwemoXyK3WhRGB5PIU//M6ONBtKCZUywYNyJHSsuZcfsmiE5DyKCegENzExkYC8i/
	gkZUAOphuunFTOdInNS6ZGK1y2d83NQjQZfl50CE7n58IAQUD4kTkXQ==
X-Google-Smtp-Source: AGHT+IF3PZcDzJgM+Qa0itDatQhUE2OrKdM2FUfn+GzDqem/KPFoVlGTPH5AcAzb4I9yuLN4w0QvaA==
X-Received: by 2002:a05:6a00:1397:b0:772:63ba:13b with SMTP id d2e1a72fcca58-77263ba0301mr9960703b3a.30.1756926449152;
        Wed, 03 Sep 2025 12:07:29 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a26a0b3sm17592340b3a.10.2025.09.03.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 12:07:28 -0700 (PDT)
Date: Wed, 3 Sep 2025 12:07:25 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling  before printing
Message-ID: <aLiR7Rc24sUeun0i@fedora>
References: <cover.1756897825.git.pyyjason@gmail.com>
 <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67B811A0009
X-Stat-Signature: 38ft7qer3bor3zwncjg73fgesuypdnsg
X-Rspam-User: 
X-HE-Tag: 1756926450-470236
X-HE-Meta: U2FsdGVkX1+K9yI3boztibK9YhNr+YRBfTDrbjvmeECPl49Qx56UVH6rcjg2chFfegUudClWXYUsEUMbMiaObbClrvDwToXsK6ElXpALjoXdXwB5NSmLmUA9RdVMiJILTARnoQ9VdM8TvSxkAlixicU09JyFb9Rtmtk2gXv6NUKlupbBdRyhkwi2L2tDFTKUer0rv6fABCj9BADh4FbxkeBe6A1tOCVtkenbuzqapkeljbgdG72aqUNDjdushmN9NbBTOI8Pkm2Yh6iwPsIEfyiwX9SXCKib1cIBKFVctDORWmDGzlLGsp+L9b5i5diHOQP1UJRZ313JmRSTIuUJ5B2aV0VSlcBHe2W04z/3eZOImGh+Zcmv1aX0olGT4+R127Ea49NPdv1Red+NZ+GBfOYNjne9CL+pAHdSAONSg7KpnMpaFWcTFTum0duC6R8eUCmOlN+YdXfD9psl/9AXiCBXQ5wc8pwI42V3V0lecPb00xlNquq2OccJ6RrayoVrP26hy+7dVCRV59WRB31F4dpVe67I2Kl/oB3/cHV6xRc4bRuRP5lEDeEEcenRgdlqa3aiFBOt5rFzq/1jNxRYYm+KhQfJIe4PZxSQYImNb2Zv15IplbcKJ18QTJsUqjfE/EaAG9UCHZX+vXeKW5dPjJ6F7UZGlOcX7Z8Xf/Uz+pxk0BA4yZmtSZvooaY14HsV95PUjD/lCI0YdtcUMClfYrEEzlqIDlpcVzr+wl+IoS+6YYbwNLW4CjSz2GwBrm2N1uQUm0VQHymmRB3z7Zs4DO2rmXSnpLqgrG8g9vSL40wWSYNGrevEJSHDpnW6PSu9XdG0xL8zi2Qyo9OyNkdgroTpWQqKy/fDmjIs6R1A/HRLjQcns9i+FBZnjAhzEljkagev0K4xlc8TZpMH9LrKmzks9oHzFqeQrYuuzT2cLNUcTlSA/hEZNyXKIAy67KY85ekiVw0icachmCsJUP5
 IjuZ1YkO
 xkWHzRSx2byFdurtT8eTNlH+9ED0ZR+gR1G+i4s+YVZl0RHlq5/69H1JGLk5sQ4bL3cRm6T0Y07dZWEIbOCMLWnplqK9OPLK+ADyFEejjZDd/Fe0FsQxF53YFM7mQaCwsQnmk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:16:13AM -0700, Yueyang Pan wrote:
> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

