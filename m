Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A5FC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 23:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650046B0095; Fri, 21 Aug 2026 19:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC866B009B; Fri, 21 Aug 2026 19:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6BA6B009D; Fri, 21 Aug 2026 19:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224AF6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:52:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FE79A2D8E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:52:22 +0000 (UTC)
X-FDA: 85126928124.15.41D550A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A64840007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 23:52:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klSI6zbA;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787356340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx4IpslJR1nyShq4nZXKEM9oGTMsr6c7ZmaRFKL18Jw=;
	b=jZBjG2QhmUzz48Lckr/RyyYJKx1tLoRApINCAtMfAPrN8UesGcX5ImIGPI6P+IwLUoVvJk
	2DJpBUGZdrBRvqHiIa91+Z96ZeRHDD0qTQ/kdXAccnLF1CbWrH3lFgzvr7HFQayfQsPCy0
	LllKMHO0eyM7NNsWYhJhpEYRemn0jrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787356340;
	b=XLx1LoK5Xx8/KrtAU6lzQUQFwriXAXitKAHadorYlH6ajYcHpGc9zBvsFEDS1XL+f0nKd7
	QiTnmNTSYutX75kVSuUl49hP2Iv60gZZwxdnl5bpe16c9nOwzjVbCFVDWRDoPA0kG9SOzF
	3Oil9HeSZNSWACq8ljB0NjWm3wTsCdk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klSI6zbA;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b440b97aso30315ad.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787356339; x=1787961139; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hx4IpslJR1nyShq4nZXKEM9oGTMsr6c7ZmaRFKL18Jw=;
        b=klSI6zbAnjks1eElo+/fPoUfhNBfrLwxn8HQEFbmDev5Q7uJtrcK9IMJeHUly/Gh9J
         +yGwatIYNWmNm+t4mkXvgkAWIYIQe6dBF7H20XP78Tj0Vu3uT3TPxK76N4b3g6raA7y1
         BuUB1Mi+gIrpj8e6rporfpHlLwCSCBEFjJErAwWk1Yc4g4K9PD5AmV/elj0vpA/JEz1I
         0BZyxBh4BOIG/0/37Z4iK/HCw6s74PSHr7L8VB250M3wbtO7qtu8xg7Ec1qRrqIuQ7gW
         kHwS2rnZ3DP7h7wP7vRKjsXjsqnYA26SjDkibTL+sL+JbhwZgZZMjDtjj/54QZmMGQXM
         gEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787356339; x=1787961139;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hx4IpslJR1nyShq4nZXKEM9oGTMsr6c7ZmaRFKL18Jw=;
        b=Ux2nC+Q7402ZnrOiKHqcMIyUAv4adUxgPZhH8HJ7Gv17KVoeJeMaQL5HIj75CuwQFi
         KurmM4iLY0Y2v58KAjgAeIeMK4OaVvSKmlbx7ANEf94AazJzHNkVbHMh38F3A4P18HI7
         trUXwJiS0wcU+ecEGLu2iF1FSuZwPTsGd5AFCKheNvjVq3zjPT9CEXZZ/ZWUiNnRPaOC
         7qAjI1phstyVvWryN1Oca+4NixeMmZMAzTlQTpX5hgvNtJ42kVp7+tzC41kUC13FzJoM
         1fr6tMB4IqpaOR5u/Pwu5dmIT2t7zDaxMT+6IZaoPfzXjL8WH/9s99k9te8yeIXKxuJD
         WcwQ==
X-Forwarded-Encrypted: i=1; AHgh+RpovJ7MKoMJ8MttysqbeIM8zyek7liI2oSothvD/4vc3a+24+/2hcqzihvt2LCJYKR0txZ0R6fl3g==@kvack.org
X-Gm-Message-State: AFuF++muR2zk6JEbKSa+77r6zsJcjaxw4XsaB8CQVE+M0oBgGBd8HGbv
	H/1OcZx8BI6qASPncoX3ZwjwdmCMEIIvJarfCJ7zDVEdf0TGTV/YfjRj/vMSnZdfRw==
X-Gm-Gg: AR+sD122U/nGvkGgkSRDQQcOf+fvaMLtoKI8m1v4DhujgY0vCOL0vdtfb2PfaAC/6v3
	AQltEpyaGsbKqWa5NoBCJXPmHY6bDv/tNNrT+9d0FwXQ/VBgRXnXalRz6q9A0owrY1WtJP4MCM2
	eDXjNyja7niO3ktVQ7wmh8dPfp18W5UFq4zTlbn61gphafTlUhsBxXyl99S0xKrP8aucci26GyD
	6/3pkAPCnztTxBSl8bhBb52T5wKtcoHn1aT3Py7RXE+M2Pi5qsupyIDIcMFU/HBUh2pOXQ5Q620
	cho5MzaZwLVgfBiyFCkKSNpbScXJND+1ucX34JyVNZjRkugUWIBNqOeHUOnKHoSyZQraQBwmBIy
	gx9F6SULD0TJrjxTcUZNZhHc+sC5lMxxhGt8MwkOYHBakFLupfVWSmaNiar8fi1jPgJjUWQfhzy
	zFzsUKF014V+rOXw/Ub2mKEm5e8nEgdNrw8EPOqyTlW5a6SmNexs87jCH7qT+NcQFl0FJVDCCEl
	waRp7Bgl3JHzQ8WaxMwsssitSxeBf8pzHZ+ltkrTsHPnVrstOfp9dalAKruz0KZw3bAYPc12Td3
	b7cH2fVCcLQBVKA=
X-Received: by 2002:a17:902:f54f:b0:2ca:6bf:5bac with SMTP id d9443c01a7336-2d66ffc7a41mr2536365ad.8.1787356338595;
        Fri, 21 Aug 2026 16:52:18 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:d847:d4f1:6e98:4c60] ([2a00:79e0:2eb4:9:d847:d4f1:6e98:4c60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e49b4094sm681017a91.5.2026.08.21.16.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 16:52:17 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:52:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch v2] lib: test_vmstat: add synthetic benchmark for vm
 stats
In-Reply-To: <a06d4920-a63d-d653-1ca2-41b7500f1134@google.com>
Message-ID: <6136773e-b134-070e-36fe-2951aa25b5fe@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com> <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com> <94068447-f9c5-ba84-73be-bf492277b9b3@google.com> <a06d4920-a63d-d653-1ca2-41b7500f1134@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 8df73tww1cu9aewmsewa875whsg9nxsp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A64840007
X-HE-Tag: 1787356340-81749
X-HE-Meta: U2FsdGVkX1+j5kaJ6fsQuYRXeY9I3iG5sQI232p5FQRdk87JUS3VFnPwDfxUlG4Omui3G7B3XOCWklxC8Dw1l5ZDRCJEjeO1j3AlqRIak2beXs2ItGyt8ml4RGgi2TxZonbhGCWIgJd7zfK7d8FaaUovt/HZ08KusHPJEdlk7+AuE34eSA2sXB465HOt+6syC8nHvyYUL7mfBiZL+jxyRo0lKXGhEMpqJwUDFaJAEkI/Bvo0rWQJv6LLCWy+DFmax0AUZ5mSbV6xGtQ0PXG+ULTYqh6yD8+EwoyFVIopnv7riuka4FY27z5HAW9qaMdxeX5f69yuIw/WKKACAHIy4SoHzj66/0sIP6ttQJ7XMad8IFnVb5J1i+MF3c05rpijiPkEYifWrpbTgu1hazEV6TNFUKZL20FTvWwYQdWrq/Lbw8WpT6hrP+f4pI60obrlYaAI0riGNuIXfwz4xPaxmigjKnJImrAYs3BdGBILefpCYyW7ZfcgW+g8wgicnm3wk9TG6Rmz4gkLLcO1Wtgf94ZIRKnpB5LlEPCwjnekarcAVELuYSsCJ+wigCQq6yLi57oH8yV/n1RzP2VtSEeBwkean5Ww1T/LI+WfEtqb9y5rs2b7zEt93AReCoEHWNzquFHh3i9kI9Aj5SM4+KUvTSZhBDBpG7SuKt5+Ga6kakM9KsBGvXptixkWhsi0T/avoeTIXiibqY+EBaudX74MmeQOq4IZJnGnWxK8aYHT1+pBa8/DGvem15Dn3iah8GZcJsJ3O/a3suvRLTBgrWpnSCJzLOl4tIMEG3RzlbOa4gTvHAnYpTFSorx18cBwoEcP+BOWCj2J6hkSEcdzavRNbWUJNSnj7KqnzA0N2b2E8tbdPJqGOO7jcMn7NUGZPYuPrt2JcC8v+SAQNRC0jzd/za+8uGzS6nx9UtsZ4/bbEZDqpQkLmdpwTcfW3QsMRB69vaxeTi9Rdsf1p6URBne
 3xvPhacu
 p7OqBo8M04tfhWU09UFt5ioxvQStgvh1Rr16Ux4Slo4AOUWDUwJA7H8hLJgGUwV5/gNTgFZgTnb/mX51BPBqZsDXUnbZxdSNypwLdDhmmog+1vlUPJS/Z7f3JRGtU+ihOObN42UMMO8NSA6Xlo6WCFkGIBHrcy0OopZzRQoS8G5qdoGocuR6w9GJmVtcyCWsIT98ufj3RrAeWcACQDlsdpoHU/U+jnMWOnlhTfV4G1+U87CxfGeW2iCBBhH65epuimifM5K6zsTev/C2U1bGHllfgxM1rKJ6qfWiDWtaCc2AlxK2Bz+l8PfsQg3NjENUXGYseP8z/aU0ntmOqMh+CLhCi/e0+g0rSBfjpvv/uYrcMs00mNY9TrlGXOgQs6DA3q95mGtcNvtygUTtj1t1SFMFzC4fYQKldwpqgurrWwHELbPmWOkgpBSBwJs6mljjwjGUP6pYrZky0Gerr5AXJz4cKBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026, David Rientjes wrote:

> On Sun, 2 Aug 2026, David Rientjes wrote:
> 
> > From: Christoph Lameter <cl@gentwo.org>
> > 
> > Add a synthetic benchmark that can be used to measure performance of VM
> > statistics.  This is used to analyze any improvements or regressions in
> > functions that are frequently used in hot code paths.
> > 
> > The test is run by inserting the module: modprobe test_vmstat
> > The module insertion will always fail so that it is automatically
> > unloaded; the results are in the kernel log.
> > 
> > Signed-off-by: Christoph Lameter <cl@gentwo.org>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  v2:
> >   - added bash wrapper to ksft per David
> >   - integrated into ksft
> >   - added MAINTAINERS entry per David
> >   - fixed alloc_page() error code per Usama
> > 
> >  Adding single test for now to solicit feedback before updating the other
> >  two.
> > 
> 
> Any feedback for this one?  If this one looks good then I can also apply 
> the same treatment for test_pagealloc and test_slab.
> 

Andrew, David, any thoughts on whether this one is acceptable for merge?  
If this looks structually correct and is staged for inclusion, then I'll 
do the same treatment to the other two proposed tests as well.

Thanks!

