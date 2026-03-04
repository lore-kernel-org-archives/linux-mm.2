Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D19DEFCE24
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C131E6B0088; Wed,  4 Mar 2026 12:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0396B0089; Wed,  4 Mar 2026 12:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2C56B008C; Wed,  4 Mar 2026 12:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989D56B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:40:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45D1859609
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:40:28 +0000 (UTC)
X-FDA: 84509094936.24.915072A
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62DE120005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:40:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nNhTNFU0;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772646026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgpC2SAOeCJOj5g+sj2OoOXZXcoH9wp6KBcGzu497t0=;
	b=Z2g2K4rBX6XA+bnMx4QUYw5t80ASNlv5VPA0e63oOHXvvlPvuE7AgMCGg4cQ0IpLBTJJ2u
	agUE5niuZ7yNsSdT0t8TK6nwOK9kckaULEQyyXvRwDNjFxQUX9DgO8maPFgaKpjr83/b7b
	GxHGMR6z8tJFWj+M0/31Xeo9WnaAK/0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nNhTNFU0;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772646026; a=rsa-sha256;
	cv=none;
	b=jqt1aXmuCzYw3cWr8OMPofQ8y8SDv+Z/qBZsWahnWyhIAYcx6y6x9BBqTRueyY4hTTChmt
	I1VmOv0vo7DL/93UQ+jXiORaRsOoyAwuZ4AL7sSmQgdxLV8K2T3ivNdpZoDx242si0cUsx
	T6VVus0qXihEJA7VsZstDCjcF2yMWsc=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb5138df1aso686092085a.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 09:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772646025; x=1773250825; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgpC2SAOeCJOj5g+sj2OoOXZXcoH9wp6KBcGzu497t0=;
        b=nNhTNFU0NVXeIImBDc6Silp39m4uJFbD7/j2sRv/01vvFAGnhTdHSh+VF/k98Aq9M4
         0N7lf6nYwhBNbYGxsCF0A7lZ5/MtllJyGrTWr1FtUyv5fd45H/0FapNL2T23qtStLcet
         Uuza0uFGOUaCsIWqL5POGgI+eF3bSZEdTGXA6Cq+vqVaaNrxSPjoDZihS9YRk1jdwP9y
         YkzZVcywflilZfU40JobJ6CVsG3J30YhnH00CKXUIfTYlLjcs6VHS+a2Ha/rZWP1RfdD
         pQsnRihQo0C2LMR2cob/fSvFAwjDiC0qOax+eYF0hsm6KWhIYmZE2Bw0FQ7lKjF33vzt
         cWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772646025; x=1773250825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgpC2SAOeCJOj5g+sj2OoOXZXcoH9wp6KBcGzu497t0=;
        b=fb2Sv3Y7+M0oTJrN9TrR0sSyULEl52eNjwY50BG2mQaPYC3v+kzDDtIFV/UxYsNR1v
         vkb3r8s/1MjkvlBdMlQHz+BFoQEn/nVSSlnJIY8Dr/zNYASwTcHOgQD2XI980usQ9CUH
         Z0C+ueO4eP9uYvT6JgG7XgXBSgF6d7DFtf51hsqCQ7nZdepQCO5XG6zGuqII0CXhTGWl
         8SLnGF4Za1VnHBx5JWHA8WFTcz7bPGM9shF7Uog1SA2G4dzG1VYubsxswhf+jPJnDJZ/
         mNcpwWej+4pDzxV6CnxoEslK9Zi8kQVWGVXxeEt75J1VeM/Qpx1c9EP87acBhfiGxbDy
         tk9A==
X-Forwarded-Encrypted: i=1; AJvYcCUiXuG3fA2AEOVxPWUQQ5qqroOOY6mGMPZc78YVZ0YcOmQnh84AEO1fAEuCd4Ax7J8G9dsda4GXNw==@kvack.org
X-Gm-Message-State: AOJu0YxZbMZLdYjyEZBe4ZzArmelEHEBL7ot1zTJdvMlP9k2ovwSaf6/
	eCbV6ipdqrvLcf0OF43YRomy2x6BCB89bziNqgSVTRgED5c2Ipkn3l5vRB1ey0qUYRQ=
X-Gm-Gg: ATEYQzxPYpVi3+X++6bgqKyC8pmaqNK1a4pI/EvgI0wXdQxFGLXplNrFOhFJ4yO4RQA
	577zUSMopLMhqHOPlcHOSowFK6qWiStLYywCfCUFDSkbprQQ1CKFbdpjfRuEkMTRLBDt19xQD13
	IF4XgC6kPWu1H2eUNZThpSqAhFW3iVAUK/KcU7t8INsOmw1kKjAIQgwcKjnKCXbkxdm1PbH8GDJ
	qcDh0yta75fg/W1Y134bLwhom7gZjaAWo7rhLeHoHJiYEy2XW1ieGk0wYzeJ4qiO1MCPY3+dCvi
	061q+gWn7TTuRQAny/2bzKdYCXn+VFRcvCCQm9BH6VPGUYtCSwL7lV9+kkyyCFYdzHVNQWOj9yF
	cRysqC+Xrfl2UbgipTddvSp9xp380kwaHTsA1bhezQy6C8SwdEsYAqXCq9qi3LrZvxIjRw1rZDy
	l9aqMb0RxQYUT8DaD7nBschi6rY/vxYzlnB9AeDIGl1sp1nL2bOqK+9y9Ktz7ZKuYnniaRWVSBo
	2MDLRy2bA==
X-Received: by 2002:a05:620a:19a1:b0:8cb:2830:175b with SMTP id af79cd13be357-8cd5afaa850mr354601985a.65.1772646025360;
        Wed, 04 Mar 2026 09:40:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f948dsm1668520385a.30.2026.03.04.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 09:40:25 -0800 (PST)
Date: Wed, 4 Mar 2026 12:40:23 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: stable@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	Li Ying <liying3@sungrowpower.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH 6.6.y] mm/mempolicy: fix wrong mmap_read_unlock() in
 migrate_to_node()
Message-ID: <aahuh6N6zfll5EPB@gourry-fedora-PF4VCD3F>
References: <20260303101245.22290-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303101245.22290-1-david@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62DE120005
X-Stat-Signature: ekmwhqrrmzejzq8kpwmqxj6egzjecfi3
X-Rspam-User: 
X-HE-Tag: 1772646026-622356
X-HE-Meta: U2FsdGVkX18eCics3cg+eX/jsViBQ1Pd5AALl9zDSUnTJRKtum7C1plKslRR3k7TvVmUuDR7yUJKQia1LPqNhQSnYoimSJ/ngOWfHdHwCnGFG3qvnz7nAah52zd36neAwkP6Dlyqv4pwKhPKzFmrPoe6cAEqpUIk0x3jlKsKnvGWNI41s3XJIbOrz01L7igcbFmz71w4SXlav4GTdTiCnPLf+Z24baUUsX7Hk7IK6XqOrZ/1y/Cqs53lkfPoqmHHqniUiL1heGWrwl76gCPszY6f6YkBhBloNGkPcs9E1s3C/tmpXmazTgXCCbB5HF5r19O1QMzKz6UbYk3B1C5HxLrKwUXZTvsUPBDZt9SimeiyA0H3DkeS8gNVgRwUmujjOUAc+80TNHDeSJnH4eCxhcQtaqZUrOZoOfZSiR39JYUxc7k0z64EYVuu8sm8d3zcfwxVIbbZQ+uxllZFEbajmtANylTR/xfFG/fbrHIa3kt5bO8R6HSOYJ9Dmx3+a+U0WGRLlymtu+2C3UBdrBRrJqEADV9/ohy40bO9iSvwFdzfO1rHD08VNK0oN33vechtCqoXOP8UlG5SvY1Mo0c6jtwL7V2y5wFL4yG3ae3s/FEpJm1EEtEQOAYvkAqY7ZUgNz8NsFU3ekfrcnS7Jxq+AASuc21voN8AUAFj1MEZiuxFzzRlH9cFaIwu1gHEpjcDdP1imGoLWx1/I7hd535kl3y58YYWQQ3CSgZxJCOokFqL6V69kfsPwKYOzqNt7YSQTkkrADtn5qO3X92mmkp1UD9V4rqKvHSyrHEuxDG5U82Eh+f1x2EJ/kXLFIXaM3ji1nKimDAJIjRaSH2LvvlrLGpYBaaEeXovQlaATT3v5QwaZA7dTP8NQQ/XOM7DlPH1zivEuZ4nj1VvAS4xZwob89QvdQRpgKXr2sWMfj8RhUdWHhvnXX420zQ4CkyBn0mm2LLI+e5AgCVmzJB4mey
 RsgMSs3V
 78bhdtKGBsGTdd5gtNF+TmTDcRBRsZCSyHSTjVb2Uwf03uANRRsfRA0gJNArP25JHho2kBUUvF4jaYkt6dtUI5/48QSFkN6uwn51j82aRixGpQeVeix7bYCFm6F+XrXmU7jz/58TUmqlE0gTBE69PrkVcvGgC/T8gMadfKMpfRKG7O25cNm1SN7lztNfx9Ej7QBSx7d+9zZuAb0xYPFCM/tJjPx0wb+GmPxn2l6zTDu3WVbk5zBCK4ploCJ5nyLnDUw0v2uY8KKCwDQK1W+3ZHLdpGTFCGWnJ9Xqx35rW5WwEhdXJUbQmvoZ89FNA8eK7JA+tw6YFPBiTiORXclHw8wfG4MBgTJcxeceAj5030jrOyQAMVZP4An7j2zVq0kOzHgeXMLh08G1VlGgtK9y5WaMbzeZVousgOIcYlupZwfms/UREL1Wf/bTw5mDknNRazChBVGjcquml6smNOGI4Ogv3xkXwGAITxzjKO823Ahrdk7gDbbVf0d4SKuk2RweqjE/DPJ6PeBxkOD3+rCupCWPcbnpJ3V1M0bh8eEJCn0t0GgqJp2NnJrQHQTIBG24WbrW+cQtLI5VlIqCAedWGYtmsnnYvLIUyc86/1UH1R1Z91Fcm8YkoM2cgvHof0llqEKPEqMNkjN1JJZwaQ30g9MTJ0icA4yl7lUF1lr0o7C08f54GNWipB5hu3XSyk33xOvPkxeDFYtB+UKDJrXMElVS0sbfeCPiDVfw/DRS1IxYq6irXGJZNEk0SjOX90p9EvdkXBIgEsdbsdtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:12:45AM +0100, David Hildenbrand (Arm) wrote:
> The backport of commit 091c1dd2d4df ("mm/mempolicy: fix migrate_to_node()
> assuming there is at least one VMA in a MM") contains an error:
> migrate_to_node() does not lock the mmap_lock itself, that is handled by
> the caller instead.
> 
> So let's drop the wrong mmap_read_unlock(). Fortunately, this path is
> very hard to hit in practice.
> 
> Fixes: a13b2b9b0b0b ("mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM")
> Reported-by: Li Ying <liying3@sungrowpower.com>
> Closes: https://lore.kernel.org/r/aaZgUNxAyKC2IwuG@casper.infradead.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

straight forward, thanks for the quick fix

Reviewed-by: Gregory Price <gourry@gourry.net>

