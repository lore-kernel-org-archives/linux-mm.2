Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC92DD46601
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C656B008A; Thu, 15 Jan 2026 11:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA1D6B008C; Thu, 15 Jan 2026 11:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABCD6B0092; Thu, 15 Jan 2026 11:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29E5B6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:53:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EC8B16041C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:53:49 +0000 (UTC)
X-FDA: 84334794978.07.07720C9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12187140008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:53:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jh+3YafA;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5su/nAHmwHcmkA811BDe3v/5JJsozj0l7oyd1uJGuPg=;
	b=hD3RYsRxdnyw371TTE267JwCiJ9tzGhwUQFf5KRCAVCJMh5g1RwUe3Yo18mHEz/tx9Ricf
	6wwzoZ95U4Twti3HAg4ryhkFldo0Z6bH0SkuBrcFwQW4a5ZRsN6DJrPkqgBXI5T+WnJYe3
	y/B+xPHEnnabkjmEB6QY4Jw3hLnydMQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jh+3YafA;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768496027; a=rsa-sha256;
	cv=none;
	b=St1WcNE3x/GQxE2l02donDudjzzFBcDqHemrB4jhEz+ddMT1BTWYgH/wyfjMUqDTqRcOCk
	7fHZ1ZJoxFgn+dPdyexE0tz9aqI/MhlgqhlT/0PNgUMoOk0kIK1Wu9xuFgD8PanY1aO7AQ
	zBVY3U827Bt9PWOwuY/vaqVl6O6lmyw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768496026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5su/nAHmwHcmkA811BDe3v/5JJsozj0l7oyd1uJGuPg=;
	b=Jh+3YafArW+CCsVuXIOQ9BsYxgScd3P5Cf9sqpUa/reaECAbjn6Cuazr+bP+7xib6DlVs1
	zgtHrtjOQFFk/VWZi8htiWABCBOxv5lXnGc0k61QV9VLugFT5MgTuIOUSZk+/8ui+1eetp
	nh+DusbFQQ+OoJ24l0Ff4+6a+yGSUIw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-8DtY-H3SNfankAQj83pT9A-1; Thu, 15 Jan 2026 11:53:45 -0500
X-MC-Unique: 8DtY-H3SNfankAQj83pT9A-1
X-Mimecast-MFC-AGG-ID: 8DtY-H3SNfankAQj83pT9A_1768496024
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso11524315e9.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:53:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768496024; x=1769100824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5su/nAHmwHcmkA811BDe3v/5JJsozj0l7oyd1uJGuPg=;
        b=W6C5d537EsZ2+XxXvdaC4EbME/qHj5EnLVWjvfln1EXoYAKwC2aMG6DbqdbTHUDBOY
         NQNumD4lyPcq8f6Ujjzy7zPcc02hEzTt8hZoGu7kT0ZjOChs5Jx/0r3IFkJIjuixBEYx
         iVAWeN4i1ZA88yI08H0DPZs5Uf9+cnEUpOCR2bpUKihY1UcauiqJd+L7pgJADwyYI7l2
         BMpOu6Ia54vqO7OCqviCg3ljAmk4EUdY/0u6ZRCFtBuWmbko7Go9dp/QOij52p02H/JK
         v9FHZnXdOyVTpR13mjmuY1xnBRKQaBRffNzaZuJzSCDtxTEVMmoBo6nEam9gMGKIGo4V
         v6Og==
X-Forwarded-Encrypted: i=1; AJvYcCXw887f3hkPpqr4BhZK8rXqSUkd2c92QXXIGVNhz5cpNKDGyEFpJeRXOvTKTECaoplbbJpCgfUz5Q==@kvack.org
X-Gm-Message-State: AOJu0Yyxm2b5p4lq1RQ9TrddCbh4fMp1uEL2DxaXo4ShiC6bxvt9h7fr
	SuBxH5a7QPu3rAac0OpWybNwdAnU6A4XMoDxwTgYu9pglKyj9Q6ndRjEIc37feVQKWkiOcbmAg3
	27Bxx7ScK3bcz9E72UgQ9x85JC4I92dEOHfiJRJMCitQszDYggb1JYCUxfze9
X-Gm-Gg: AY/fxX61EoD2TeqZQ+xr5L2I/M2wUqx1wooF8g0zwbbh/K5aP3IBPUBv4O15LXsVPiu
	w70jrj6YRwI/NGjGKQqiAC9XaaV1AYmRPtATCMp6o5lX4gTZov4cOG/VpkonEZTsnw8mK7GG/id
	By8gJ9C16QiBapui6MMbTqF38FoehhovX91TmEU2vzNjYoZMJco0AdQVZDoE5eUyqXOvDCQ3B/Y
	S3kuqdKEErIiM8fCUIYgmWrnhjlrT2IGjM5R6eEsijKimVVmjyvQYZGyNWclFVNljbkNm21nZe5
	yCWNmQiUpMCZesT9fw9sthTZckZVXrBnPd8Lqh8bCgozJ0LPm8hO7vkjwvorWY4KHXojcYgR6fU
	t0ysE0KphIc5J4TJVYLhE1R5zFr9ktw==
X-Received: by 2002:a05:600c:5487:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-4801e30d482mr5165385e9.13.1768496024071;
        Thu, 15 Jan 2026 08:53:44 -0800 (PST)
X-Received: by 2002:a05:600c:5487:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-4801e30d482mr5165105e9.13.1768496023585;
        Thu, 15 Jan 2026 08:53:43 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992681esm58497f8f.11.2026.01.15.08.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:53:42 -0800 (PST)
Date: Thu, 15 Jan 2026 11:53:39 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
Message-ID: <20260115115228-mutt-send-email-mst@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
 <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
 <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
MIME-Version: 1.0
In-Reply-To: <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sb-iwNtajm1xjtk5jgki1vbzA6qpf0GKbec-e-jSk1c_1768496024
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12187140008
X-Stat-Signature: iwuuw7wshrfkbruija8o3rwtunwd6jnt
X-HE-Tag: 1768496026-112800
X-HE-Meta: U2FsdGVkX1+J9mE/Cz3t0jL2/UNXp+pG0DCfA4HDxg/j27bdqWrGCdtkE5pu2V6Tx/iVxS53Y6o6eNApcEm25RcNOdSCSckTQL2qdW1cRdFb49/E6yCcAsJkbuFJy7i19VGMVjHS5BHCu99mV8MxxdnkMBlgWXJTPO0Z6CGuGkWlW20yEc6JzDFv9+mxNZY9z0kyOrfl/Wu8N/4KuEHsmV+D6rOMIptpOYHLwl/kbWQyGQPCwO/ddn+SmW98HvwX3wCwVZTYeIA8QYlQ0lSHnVu4DAxB/o2xL9qDxjJjM6DMQYiEaVdDVXfn3iUNRNbwuwEwUsdeo44a+kcnsgeRp2hKxlg3U5sTdxlYEJrPScGEwYhik4WyRwE73SmmTCV0GqyE9zFZiFXYYiwDZoeDNuTEddbGGKiG9ZTN1Hg2WuJtvvNjGXKEoOlV9FZmXzvdhHBLetXo+i4sZ9CcB3df8t1UqjeleladRP75ELY7+O7+uoYU236mEGp2t6NAPCyieiShELBQK2Adt6OMtquiHpdqLkH6IWQRy+9DvFa1WYKjFOJfggPT1k9jSqXuqhgDnxAWRuvDRP4s/FcOWM3mC/nz3p+EN7QSBkMJfrHIpMWg15BYB3t30l4nINdbjL0B3MGyNZ0CgHU0HI/gpTTkUnjyVHAv2NprFyGYjVjOtQ7CJmuDeuXm4JaQSZyvH5XYNuFeHuSBinqMBUimMRNpFKJwltR0VlB0I/a72iRxJk6IvbJkWMALtMlIUs6y0BsURoY4b3ck/jXuUcr8ymNxSqOjr+sqOrbVvaYKZv+n6imJtrffMrNLx3q0Kd7BIwVuGFtU9a/LyTsrgOVtkq85LEeG73UHQdxR30bxunfoUr9Zxl2qyo285OnV7hjSv6Y2C98QV1sTQJTnuJd2zW5dQ57JMAVi2X8wYip6WHMPMkS24Y2QNtba0RTfjRdztHhVfNu9DqkQLTMTXRXwPue
 9WVIaSt8
 BvXnZ2CuaT+6gIueMYxWbVWeqVsnQcDPdCMk9q01siA3vKnyPqr+n39daCzzKyBwi7tfSLMRygF6UUpBhHaDGR00gCqvb0ixElTvQ6B4FtMl6givOAALaeBMLxPOWNkzlJlUpuwI0djAuVP4W9cPwMTuNnspWgkFUBIwuWWae2WiPFN2QjYO8Bp7+R1sLvqccasZlyNkxCzyAYg9/wA1tm4e00T6C7FgDXdMg10rDTX7u0STzPcxbt1qWmIjkAEyQjOgApquqmro8eH9PtCJb//FQanJD5cZ2nDUxsX8gRPz3cOkc8sBoFQzKyKuUsXSrBuUD264ABBvsGIyhXGWDtKcUKNrZYsXsUueiky2yuFBhLeMSBXynk5tildy45zLSh52glgDAqDr1O26AY03eIfVL3BkIjCAYpWBkUCOnKe2Cwq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:33:56PM +0100, David Hildenbrand (Red Hat) wrote:
> I'll note that the spec also defines a "DEVICE ID of Virtio Cpu balloon device as 47". But
> no changes really happened in the spec with that for the last two years (only the
> id is reserved).
> 
> 
> [1] https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4260001


Maybe that's a good reason to keep calling it "memory balloon".

And hey, there's also the floating, pops easily kind and maybe someone
will use those with linux in some way :)


> -- 
> Cheers
> 
> David


