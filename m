Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F611039892
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA96D6B00D4; Fri, 27 Feb 2026 15:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82276B00D6; Fri, 27 Feb 2026 15:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955FC6B00D8; Fri, 27 Feb 2026 15:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 804F36B00D4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:07:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05E76C2BDE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:07:10 +0000 (UTC)
X-FDA: 84491320620.02.81F0E56
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A7A3100009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:07:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5J2lOY1;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772222828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjSuOZ+2Hbog2cPlQd+doqzqpzgxwzZPQF2OTOGrX78=;
	b=xIjNS0IDSsZw6cfJ/P/mulvRhzlEJffiUhns484YTusX2YdLhqTn/Lq2c/HJI1533P+7SO
	wWSYNWwXz0L1CXS3WmJybnBoMTWzv5fYBZbzNj7GOcu4fcx77F+paBuRg4omsXzL3wv5y6
	gFNtTs2nyWBqkoRxPTxriiupv3RsG2s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a5J2lOY1;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772222828; a=rsa-sha256;
	cv=none;
	b=kYjst6xSBS3MHOIM3qI1YkuNH9JPAAF14H8cbY1vtlVDOxO4CXTzCvb4TwGH3QYnXFc6B/
	ABFtL1u+69yCENP1QU44Ad5AQupTVS79Su02yPG/mgE6jR2+myII1H6mFeRhl5TfYRoJ/U
	E4WyuTwSq6JVNSLyOU+VTMi4OHrq9/A=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1271195d2a7so1453580c88.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772222827; x=1772827627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PjSuOZ+2Hbog2cPlQd+doqzqpzgxwzZPQF2OTOGrX78=;
        b=a5J2lOY1KzjKssrP7UYU/sVHHu4fX8C5R9H8RDuYlZjxQ06nSEJnTSlIWQb2UT3JoB
         kpQ5EXHxFFUY2YvQCMmI3/nZk2lGjhKa+JvXV1aXlBo/XHX0feej7Q7Ks/REh+sF2JQv
         /W11NJln1rJ6P9i/zEDAsbpBYYmyxWqZAHUHmaKFe9oTc+hSHbS1ShWNV22LIUDMj4bN
         NmOOfWkEdo5X8zsVBN7xrDVG7Acl+ABNifvMZHB757rd6du/AWQh80Rmq/W3bd/5dVuc
         SdhWVTiicD/dgWImoXUFY3HzgB1gtWxK2AbQ8bBSu8sQQVDrNqLBvSTYPy15jB/Pm0We
         IJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772222827; x=1772827627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjSuOZ+2Hbog2cPlQd+doqzqpzgxwzZPQF2OTOGrX78=;
        b=WVH2hWyEk8cYUAxPapeRwySAzmT9W6aZ3tMuO+p0jqHS3mmrp1Po7Gb5uItDtx5MMJ
         6nouYTIA1qNzWbpjXrKtISDshEzVq9nnAjfO/1yv5mOjTOr/zXgFup4q+SwKTeYhV50s
         EDbdwSKgqFIrmlPKWE6ul487Xx73oPVs50mjUv1Nysknf5wJk34B9eSgFzhTExY88M/o
         dk1tLNjAXKAzaG7MWBrRceAWoTmzW1Tip05lpUKDCwjx01gxfowCorudYRnBNT4/iKb4
         3al3FmAfHVVs76ZelecTMdtXLxjKC704tlqEOM0Tpib3zF036ym2ou6WM95AHqGHzEpY
         L5MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf9BcdpwR2IsQ/KBYmoqKTUiK0wW+ffk81XbnE6iRqhuG+6SNAlxKy+Kx6l0y/8+u6On8z6PvLxw==@kvack.org
X-Gm-Message-State: AOJu0YxmCTI7Y/HzZiW0bqAniDxU7Gp+uDFVNaq57KihRdgi0A5bWOUo
	OTAjt7FRFzPDP37qi7TqcidNCDEt1xzZyTAHLPdVr0iOZCNNaOeO41fR
X-Gm-Gg: ATEYQzy5L9YYs+odkhHA0chAaZxS0/ae4lzhuxYzL1mk5ZJ6CpioAceB5g7+B2U9lyB
	STX+aySr2sBM6uRErczienFqGUyBzuNg1GSiamprNDrOcB2aRptbEUyAxn6LuiEV4hJAX10KKJr
	ubCZqFkQKQ+r3IjV5X7Jwb9XN8VQ1hPn/u+jZQF/hEA4w+ukjo0YEfOiKXAOz3WV6GDSZC5YKuZ
	1BnyWYE5IcN7vE6xSHnDjjAHDRrzJ47fjKP9StzpvpZbQSn1jcUxQJ8FynprXk91HQBZI5cjXw3
	7aiSOO6uf521jf5TkElYpibCfoezAbfZj/M9SKmG2Py1ENi4Uag6HCoddkCtxipBqFEe5M2XIFg
	ZrqbgBNGantjYf4g6rYmxer4xkqt7JptxJuTM/QEFKkxVYGysmaQRRpU3fNPzqZGoF/LlLayuFZ
	NZFYbQI/2Fd4uf4CnKzQwLHlzRpNBupxYKudORAktj5GCCYb13KVvDTxx0Gd/yJKC1HvYCDK+X1
	DpE0n38zmcbc7M=
X-Received: by 2002:a05:7022:b8f:b0:123:3bba:fc4c with SMTP id a92af1059eb24-1278fd2e6c6mr1713684c88.38.1772222826690;
        Fri, 27 Feb 2026 12:07:06 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899df36asm5492002c88.4.2026.02.27.12.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 12:07:05 -0800 (PST)
Date: Fri, 27 Feb 2026 12:07:03 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Message-ID: <aaH5Z5HTC5GyJ6sT@fedora>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A7A3100009
X-Stat-Signature: cgn164fas5cc94hsygor9qg7rborxtm9
X-Rspam-User: 
X-HE-Tag: 1772222827-565407
X-HE-Meta: U2FsdGVkX19gw2r3p01mWsCDkkrmcH9lMZy8Bmk91Wthk7lsyGq8WqhLeelXAPIFntR+JqA5vu58rGfP3R2l3Cgt0aqmu4QGaeZSZp1sk2w/00BXvhI5MQxlPAaUzAOtkMIoNuX3sFKtoEe/WBAObZ+L2L/7+LoGtmwQXfEQnfVcpZ/FllSKgJihgSXQtUy4OjkMUTMeve150nLYKxKOhUYnM3tjF9uZySJWjdEdan1quIZZS8PGtb+PPMBtA/UyfSbfvUcNK1aDxIx39iFr1OcKHzuIR29bE60E4DGhyf+v7BPFMTMlXgyYNJO8LdDJpFp4wK7WzRUAiGoAWsj/1iISoYY/C58x8F7SKi10m1UCG4vBokh8B3Z5ek3TkHgl2MAh/cLoZfBTzsqE4rQe4LaxEAFQKSDGs4reTadUeFD4/qsE3uvmxGJBDPuX8+0GlOryKP1B8P0E7FyfngM376Aru3T/bHvqYIYFHntHyMYyy/9atpq9BtYuNhVQ7kD9doXfL+IAgbJqpeZ6zM5hAD7M2WoRJecsHe3AgxVPWe7h15uy3PRXGWqP+Y520vYHEiplyqye4ZJX5Nz/d1+/spn/0GtYF7AfSRkebZ5CLJZv/NrDqNfsYcikDHRvmL61O2RlR57QkfzhfRBuTVff940Ps2JtBDtVBcOs1+M5PGXSrgWnXw3S6ECp5E1vTXwJWPmn/UpMCb5mD3SM/hJSgDaTJ5AcSoZ/VOaX2X+h/hHxstf5OLrDL9BfWi8dM8Xs1S2aojmbSPMxcCvo7Hbq7rydd665s8ur7ODnRuok50DFZv4n6lZ/Se22JaqQ95LMHmRohpjhAdppRSfb/fbnb+1Z9RfrRNVhjwuNAhwFzuM3I+OhtFa+VjOMB/hWYYu+yDn0XFKP5/Z+x0EuF5jXBlbst4/JdhabOFwEa2xTShTtoJ0o/0izADaBIOJ3reOwubs84w/SdQ/eYp2dYMs
 W7lB7roi
 FQZI46LHrJRjEFCzIOQbKxaIOu/Mv2/+RupnXgsoLW6dT6pcrRa2AaI4Qig0dRMVpvlK0EpBMWnWY/tSAh3gAY2yb/Sv/lLTI1VGCTyzAdJ3SZVR559WcRl4VVOifYan0ECTo4T5uAqZrbUsuNw9yXte5oUptLz/gpGzKh7jPZG3s5KXaPGxeyQvWPX2OTEE10bJUUlmoLEvTMG8rgcgq83pbMQcHptlEm0a/RjgLbwdfjuydbSFjxeTkCQ7JnZ0t84oRm45lqfxAu1WOBjY4/tRFVb2Dw1kyx6Plu2d0KvxQQTGdb9RK79a99RlpeksdLaDLGNFTo8E+PRg4b0tbWcHHvm/cQoebMNbGtrS39XVACakIoDCywqhMMk6I/+GroJV8fqZaG8vlPzc3C8uKUUs2AnBQ2CFHO6rz8G7XNYdiIBoNshKntpfXpgrruqK4Akt7nEMulU19IULRzSFah3n6II01RR9nHBisFRTiAKyrCWANdSg1MrKEznqns9wnolx+RbpmH6m1LTltXUDUn/vU+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 06:03:50PM -0800, Vishal Moola (Oracle) wrote:
> set_memory.c has a call to pagetable_free(), while the allocation sites
> use get_free_pages(). This causes issues separately allocating ptdescs
> from struct page.
> 
> It turns out that we can just use the appropriate generic pagetable
> apis for allocation/freeing. This helps simplify and standardize the
> code.
> 
> In the short term, this helps enable Matthew's work to allocate frozen
> pagetables[1]. And in the long term, this will help us cleanly split
> ptdesc allocations from struct page[2].
> 
> [1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/
> 
> ------
>
> Based on current mm-new.

Hi Dave,

Do you have any more comments for this series? If not, could you please
take this through the x86 tree. Thanks :)

> v6:
>   - Drop the renaming of *page* functions
>   - Use existing page table api instead of creating new apis
>   - Split the pmd and populate_pgd() changes into separate patches
>   - Reword the cover letter to describe the new approach
> 
> v5 link: 
> https://lore.kernel.org/all/20260211195233.368497-1-vishal.moola@gmail.com/
> 
> Vishal Moola (Oracle) (4):
>   x86/mm/pat: Convert pte code to use page table apis
>   x86/mm/pat: Convert pmd code to use page table apis
>   x86/mm/pat: Convert populate_pgd() to use page table apis
>   x86/mm/pat: Convert split_large_page() to use ptdescs
> 
>  arch/x86/mm/pat/set_memory.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> -- 
> 2.53.0
> 

