Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FBCCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 17:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AD48E0003; Sun,  9 Nov 2025 12:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BD18E0002; Sun,  9 Nov 2025 12:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A658E0003; Sun,  9 Nov 2025 12:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A31B8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:07:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C13ACC0763
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:07:48 +0000 (UTC)
X-FDA: 84091700616.04.7F804E9
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB8D6140004
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 17:07:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FUk8/9ek";
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762708066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1FNiL4lN8CLTL7WaZG1viN8SOw0TC2lym8ciARU3xw=;
	b=oo12VT3cacFhgw2Izgg+bKlmAt2ZhSL829Gd++h3654ppHRz+7bkmV0Y07gORV+NygHgHO
	vKqlTfGcAXZ/UkdpjYKHg0DmH+zybvh2c/0cXFcx8oxZ6RRbRzjHOSCINWzbvhOq/18eUL
	gKX/ODoTth8WffYWu8OB8OA/2FYHw/Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FUk8/9ek";
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762708066; a=rsa-sha256;
	cv=none;
	b=d2suYLA7Wpe6KFYclHsyP5ktcVPVQvATv1aktv8LNK9RtxLOYqenyTC1ae7yJI42eFZjo7
	y/cmsZk33BJ2vZpUHi9S1e2X0kY+lJr60eZk5KgFb6ONz5G1l12OaiK96+F2dNLQ9IJNhR
	vo9+JD7WEzI9g4h8ODvcWJgoSePa3CE=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b994baabfcfso1344657a12.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762708066; x=1763312866; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c1FNiL4lN8CLTL7WaZG1viN8SOw0TC2lym8ciARU3xw=;
        b=FUk8/9ekBkCtietljk84fm2e7rICNNT4RwXPytG2IGDjgYD5wUWJWWPpKcVsC/fahf
         BWte1KPqBWaN7SRT/z/jRqfyTrOXxucESCw6s61OYg7UejqRlwLZYVNxn/XEjfzTOZ2w
         ZMGUzxH70LmLHEiTy49yHIKw8LuxGQFSuhIkR5ri2gCQLpf/1fbnrT4RnJkXCBYvHG5L
         tiMED4kKpM/8lQz8JhZHvlqs9Zt4VdskQMf7D5JSH8IyNd4v1AkPajIPl1zh5hPkR/eo
         FdT09M/nYsWAOCu/gUhaQGkhPx20K1VB5ZvEWcnDZdy6HAs4JaViB8rxs6gTbRffBhw6
         ybTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762708066; x=1763312866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1FNiL4lN8CLTL7WaZG1viN8SOw0TC2lym8ciARU3xw=;
        b=UXq3Bmzi2IgdFVvcD/0/qDMQjxre94i8pEYUwVVIg/c6FRo9xDgsf8i9GIqmtOzQ3L
         8paV84pOMal9kygawxCGoIWEPie06EZgULWocYIKqsQN+HhgQ6VeBxTJXSoonJm1H/vj
         qPb4l6S6/T9jnC+OKHc0VYgezSfpeTR+NpBGeXE8NROcGxPh6TJnaHeacWaetrRnN7fq
         u+SokdtYCO2d7R120FiRhIaAGPcyDElAnpkXHWT2oDGhxIMho4U07BzStbm1AawXS/XA
         SR4/iLOn8Ehw7yrWxNYomGqSIummQOHoTEpdcahCH68+vEVwFBfLDxq38BVoG9/xq+G/
         vQ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3l1haOONCT92JNurhKrcMzfzBvemUte0vQNzXH73lS/FwS6dsHLim5Vxl7jW3fBqmmoxi1aRFVQ==@kvack.org
X-Gm-Message-State: AOJu0YxMcrqqC8otiKwuRLoemO3o/21CRraGdOUTL/TTwMm9GZFLGvQj
	sSrFk2mNWy4wYAzM47A2zblg1S7uf2BUyKSS06eewawxJCYymW22vgoH
X-Gm-Gg: ASbGncvy22wf1xbRs+R6mb63sw0t7RZIDqya/KYsxpKyrT/F9v0OXDHEituUr3roL8j
	imunMjxbl6Co4I/AEJJrNhG6xSGNTZ5zS41Bgf4lYTidVSp296KxIwRUa2zj17rYPzOkN3PhioE
	8eplJAimc+Cin9AwQhqIKFvmznrdjFPuXRu81To/LgEk96MCY6u/6NUsNkUn1esTqIT+gsZ+Pou
	herw6lGE1THgE/AFEfMuHB6HAhPvHNU/qQ/ffE64CN8w9NhEHZeVj8z1Eo60pKvEvnPNF6eOQmq
	tupqulWi4vZ/MZthEH+ANOjfETRWhVMjz/85DzY54TdthCeR55E4gjdSWmTHs+qG+5nnDvNSY7L
	W46nxRsxievnghgvOayxLRw5Y05ysW65Vurnr72WLYUM5wolvM6h3BMv8n5XRgpAiL9xyKrmOHg
	Y9/y4KF00SkuiLDVYZktiFBAGwr8SWA6ALOi2VPUU5hro=
X-Google-Smtp-Source: AGHT+IGaUkeabb++qUmC+bOuTrL5CUbZWgq2rW9tYf42/ySSJ2DpLXTzPR16+AhOmoYX8uvG88oLjA==
X-Received: by 2002:a17:903:fad:b0:295:9b9a:6a7f with SMTP id d9443c01a7336-297e571290cmr71731095ad.49.1762708065697;
        Sun, 09 Nov 2025 09:07:45 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c7c841sm120391455ad.72.2025.11.09.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 09:07:44 -0800 (PST)
Date: Sun, 9 Nov 2025 09:07:42 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm: Remove unnecessary __GFP_HIGHMEM in
 __p*d_alloc_one_*()
Message-ID: <aRDKXmwJeosbvU6N@fedora>
References: <20251109021817.346181-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109021817.346181-1-chenhuacai@loongson.cn>
X-Rspamd-Queue-Id: DB8D6140004
X-Stat-Signature: s8aja1wgxeia4n6ma6wfi5jtypfc8dgb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762708066-826088
X-HE-Meta: U2FsdGVkX19PXwW9OQEirUg2GOpvAxv2jA2qV9f/6LMOc6KhwQ4Yb/+rAKgCCKwc7Y/IlTp1XM/SlxgN8lt+WgrmvmTYzRIYnHUudoIo2iqdF4RgTb/hHP8gsZlPJjMpLAMueZkh2iBYo36vnuhhncxloG6NVpskqHI/3xZirmM/YUSNpQ2ov+9+xLIF4NPKcKhCouGjJBlpk11t7t0GL9pwt635PqY6UFaJjjgImtzYJGTBGuxLgMx/B3RyWG23//C9KubqtO9TuVSEcSDgITkyWDYEllBHcs0SHgHlrFnAyVjwvt+1hnhwAubqX3WRuSwB+ypalAn4ZSbR2yTa9HJ0H7vKMrmEyxemn2XoZARE7HUca2BM5mD4Z1LXAeyoiLvg5OF1PPo4byvRzuJhVnvXt9FsDk5e9pA+3sj/75BqGAKb+g+uPZYMxqHHaGUZfLboL4tB52FbJy3kO3DwUcqBO6ynNiiHTL3USviejylLPXzq1iazx/Vjxk56SO0fPy+HgzH7Lr9JvFulHKkG4cgjZnv+g2c9hLmFiP+Vsn8K+nsMtzibH3yGIcuwR+cUEuZrNCic1B7vqBJsDEZsdlP95zA2OweKEG525H0cqIxjXvi6ktu/Ra0fsqqcpk/S5Riu1LacYIYNPC3wjK/QkdBPOG4JuB0AOga2lT5Hv0In9UkpXe9jC3v0eDjMf2Qsp9Na0ukXpqnhO+yYHRvHkHuLLMapAepeDohZf/RYH5wOYtm6ZIR9LWBtDHzGVYbpDlU/QuTDrWtSnUJEgVLjOf50P8TbuKTX/ecIXnNO2267/jdUR5P3e5n24Hs8rrL2Pd+M/s2i/dIvKCLWbjvDQWQVM8hJIlDrBdUzQtw3WdkhMxheBK8nzcQ+Wc/1jIzz9lMt5FIUj4yDuWzeilCgIBmcAQFhE3ppvYBW9edHJtq+h6vzdZ0uw1K+zPc6IphHix8zXs0WgFcSHU+KosR
 EX6ZHwTe
 y9dw0Ltfrhow+iFOQVA0ZzTtkjbXPe/Mdd2os3mfDEXpxJDQVDS/ze8N2ZQx7WM3SwWUtixp+Uz6eji4vvmREPdY7N1COLe0aQGLkx+69gmionKQbccHtLjK4CLE6tMQVFvhTxmX2RPvlS7M5JdVBzboKqjYSRmO0PCf2MuO1RcTPoWk3u9Q851JtR4iPin2agNkRi95LRNghFbzcqiTM6Iwic6pKGqXe3h7/1d/wFHq8FBa/X1P+wgTAV4q31eYc3IjvhUG9LiVxTZWeej8zcg3/QfyV6LGFoGxyBsHK4POxdahX54+4rsTa9Do20ZsxkUURdvZVlTwH/FTIlD1+tsa9No0NLYRc1bI6GH8JEEWgpwtUdxLenJbkONcbEiY3gT/C9jRKSlhmJb5qoIrPix7RGxEUKca2RDdXSlW+6e250luXYn3AEjgAhteQnkt9C7rGsJUa0sgW1XxKBCPvo0Pl7LBA5KY6ODFPHkBGaogh7Vc8XviHN49NgmHIVWHv2GPIFHevcJa50SL4UxPFou+g7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 10:18:17AM +0800, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
> 
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> 
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

