Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F048C4452E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF64F6B0089; Wed, 21 Jan 2026 08:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6E86B008A; Wed, 21 Jan 2026 08:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3626B008C; Wed, 21 Jan 2026 08:52:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A93E6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:52:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A3D6B85BC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:52:55 +0000 (UTC)
X-FDA: 84356111910.11.C247319
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FFFE1C000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:52:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=cwJo6uHC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769003573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNPZ06gyhsAi89oTZ9bVWE4SZCuvGGleeew03mDE5gs=;
	b=DAEvPry7MqUWr9OzK7HDpTbAkqj+T/+P45MPzMbvl1jmabVvJMrCykEi3SSZ6nYDMMtAy1
	Qz3Mv8U4CUeSei+vVb9BvfFdms6xF9D2RPu4Vcu4QF7sabX0kS0yCOcOWBF5WnCRf7x764
	kH7e96+Puw30oPLdFCPSIhRdNQDBzO4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=cwJo6uHC;
	spf=none (imf20.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.65) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769003573; a=rsa-sha256;
	cv=none;
	b=Nysq08ByO1EU1JEPhetLx/StNhExL8yHXoWjmqAkGYemX4gl5gss21/MlTX6Yae56JojYg
	Ux5zshORSt1Hx/SN4MB31W9P5QwsWzlM+cZNmus92ZnA/P/kmrYl+twY9XXqs1JsyxwCpK
	Y1BQvr2v1bxHmq/pkQ+UJJdCkcNqGpY=
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b8712507269so882655366b.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1769003571; x=1769608371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNPZ06gyhsAi89oTZ9bVWE4SZCuvGGleeew03mDE5gs=;
        b=cwJo6uHCDzXN8WawRXpX7i7TAE+Q6sUvQzZNVkY1aBmfeD6WUWCReAPuMYJ0j9NTXL
         Ck8IVwffaePF6eDxH2MxfuvlgG39T4szhEPkSGuLXkXYKEc9Wn9xcBgINHw4ZPj3vbTj
         Z3f9oHdNjnSobAoWUUNg/JUy+kEqinY8PUklHqr6ybLBUG/bi+BFNFyqU2jR4HAuy8SZ
         ghlrvXEUkIOybpBS6m5wYmluDZxFl27aNi9OQjPXEStWWywEu/n0xTVe59UZuw1RWuVf
         +vhi47gih6q7kcd8O1oOdG+biYfgkRF1aUkjgt25NYK4reoptX5gbl6N1P1Ti779b4yt
         /jeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769003571; x=1769608371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HNPZ06gyhsAi89oTZ9bVWE4SZCuvGGleeew03mDE5gs=;
        b=NlbUu14WBb1i/rX0B2Zs101BKy2grEMpX3pfUxgGnxRfbfse9Qe2+ca4wIQ8nzdhRY
         hrE05h4LjHjrj+lFxazHoSncunPRH+IyrW2eV0yQeO9rJdrtNwyWXqZ1apzlsoyXKnza
         dG/SQtAbjSTyMMEDfvf5l78JBpY6bXIhfvaA7VsC3KqZCcT1ikID9ReaBMeo5wzQFzUS
         9/ooR+4YHFaYHBdmLgw6ZT3VsIjlw03e2ATEfHQTMBuLyWpDLhLC5D40m1gO98Wkx8Jl
         AdjNoMA40ZGz10k2y0kPPbZzuW6Fwu5eIDJWaKf4Zh+XwXVUTNzMIdIkTPwrQ9VJBprh
         3qEw==
X-Forwarded-Encrypted: i=1; AJvYcCUA5bTnebvqiop+z8bPYLaN43KzedddFVGKRUhV/cCgT7wfp2J4OPcQWGLL67ZPrCMqR+OvktduTg==@kvack.org
X-Gm-Message-State: AOJu0YwAIryU1Gcn2FXbLr5KLwwsb3/TS2Gh3qh/YDlEkK0VFJOlTOH+
	zezDQTtkR9+kyhcaVr1PnrwoAbIPd4hFFrVqsLktwwNTRHIGkbvkW62em2AJWtuLOQ==
X-Gm-Gg: AZuq6aInTuc44/ZZBPpQST06wDTs7zTtffSejfDOu0q2qhHQelARuvDrw+t5SZkOerl
	NaykkZ5Lx39HpjWEkdcV7ry2XjmoX3kFNCjp3rRrQQohJuTdMpOdupiaTZ7jy/SXdsPzzkz1oGB
	Pa96oixJ7IMo8qAuuIEqDpfsX50+4pHaCj3p4f/fFwuKBdjgtQhBKzeSLPl9i52sE7442LaMSYH
	eL1DK4yiQbMsC7AbDWvAz83GJL9bv8oVpD5c0pq/hhh2DUbJAjGuMxUGDU79rriQdeA/ucEm3q3
	NxD7jZBcHK9ZKapagkC0yxTwPf559TV+6LEhfjhnxVi74stcdqeSYelv+7dxsiYT/kTkuKeisIU
	pw5e7humPIHL+m7olaoC1uPRjAhsj2aHGDrsSOS1X8SX4tA2+4D9DFcXCObl2ikouQm2vyzhrsm
	O//+O2I97EfU3TnPF80KDNMdhLES2JOrChDWft7AHf1J4zTlu9GtB7b5ep1foopg2mMG6gy5+iQ
	TPnWKTMvvi6pjJ75XI3IMUfjqGmXUFgf4jCFCTwvi8KNlpfaA==
X-Received: by 2002:a17:907:3e0e:b0:b70:ac7a:2a93 with SMTP id a640c23a62f3a-b88003649eemr505557566b.43.1769003571363;
        Wed, 21 Jan 2026 05:52:51 -0800 (PST)
Received: from bou-desktop.arnhem.chello.nl (2001-1c00-3406-8400-8d28-76bd-624c-ed78.cable.dynamic.v6.ziggo.nl. [2001:1c00:3406:8400:8d28:76bd:624c:ed78])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b87f3b05154sm513246666b.44.2026.01.21.05.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:52:50 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: liam.howlett@oracle.com
Cc: akpm@linux-foundation.org,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	boudewijn@delta-utec.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v2] maple_tree: Add lockdep assertion in mas_dup_alloc()
Date: Wed, 21 Jan 2026 14:52:38 +0100
Message-ID: <20260121135238.26578-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <h54uysfjc62hxcxdnhpj4fnc3smufwiocdkzp3uiah3e2323hc@ljfkxmstxnbo>
References: <h54uysfjc62hxcxdnhpj4fnc3smufwiocdkzp3uiah3e2323hc@ljfkxmstxnbo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FFFE1C000D
X-Rspam-User: 
X-Stat-Signature: rmrygrs1535ci8cymc34qnggymzwkgsi
X-Rspamd-Server: rspam08
X-HE-Tag: 1769003572-353159
X-HE-Meta: U2FsdGVkX18/f+t/E83XedA7j72zZpOEVwIuCIiT7/vTMvpt+r2SREynR3XgrlERrNxFB77QAsUutF73WwH0K/RG8TrseBfz52dzgrSNxOLhagaHonLMGmhtjpNTa4JYB/XxZZmn7nPusvpF1LhFbqUeu1oopCG1cG6N+Jywuf2sWBo5viwb2pWvB3WHxDIhAZ25J9q+vdVBhzIv0WLFl/RZ9pesZMTVaEa5Cq09NAhTD1IjlFuWg7dZxo0UnKbHghs+2VQXgJccfthLyNO1uoGHyC3YtiCtfrRFIH/mZ1wLo3o/k3LDbNN3ek+UHsXdFBcGA/Tq/R6E1X1H9QpIlK+buoELLXkMY8se+0JksLwfYU0pPFzwxegQVnICNIQ4eZM+WwZ6oej5b+VXtmr2xeE9f0Ip38/ti8oHmdI72FnTzzFR52obk8yoMcX4u6NcOwSB9Mxhmc2P6B2yH8/S08nNP1SaGpqtIgu0ihzvBVtUQvlnh5cbXgrS3CRH/lp9PDQFhjYDMhd0poPUDIam4N6Ms8pCe8OoaiB03kftu0ts974MVWILS7fuFQ5dJZ0sgJBfAqbQzWkKk1g+FhpeNZMNPmg64FMvL5IIMiSBuFK73wGrYzMfwpoBcf1Czq8jUTQHxQ5m83WacR5ZQJd1mTuGXD/nE3WLceN9g7VnFgtFc/hswXzpDx4Y/8/ixEHFx+24d83X+JqJEyyUIgnrocU44RR+/17QCah7On5aXorPr3LrHy70Y9bU2n5vdNelUclzAIDbcBb4hpdgMsn462m1csw7PeGH9FzYDfhc/rDsWC+3oy1f9T0VwjgdxRxtdGU/lmvQ0RfOhl6Jh9nKBi+AzRQTXNTG5rgH1nGqAEwPGVOus8Qte0bf5W2pktkgBKW8xNi2AQ/irq3aJGkJu8l/g02jESZI/365FpTN00PSlHicFzeZDnO7qjgE4z7ipHqK21gzGHbnTOiCu9E
 l2NGNCBJ
 qHXhZLOQU3bLgQvzxDuSb4MVWJSoiuGxTxVA0EPcmq8QWEnIFn6YyjkyKkJv4UE+ZlrLkkPGVWJ5sgnF+vhLP77dRvSrJYt39iyksl4RPqNzd2ytTTh8PKKJmbao4REdJeaZtG8JgHvcaTJtGHwkBUj0N02fIXZ548Iyd7pYwGOZt7laPzjK7tLmhdumZj3odlUo8SnVp8YGEaRCFcNq0M6pVkA6Yt4/1rO8QSDKEchDptOcePrTr2+0z5x7Y/xWHFoA+Zw8jFvOYWbEMe0zuOpo+/dld7LGSd3jjE6gUuzb1easNNKUBXCk+iltD7GmGrT9MgTcbC0D8ih1H4/mwFSYB2/4Lju0uFmvY15gDsUCZzuQKtb8LEaL/9FSy38Mr9EOXJk2K7NMsDxNV/dWpJO6Dh+OfUJuoS7ExQOydmQCepM4aD3+oczPbU09aLZlSentCIYqG2NUCEbxDqU+93sIKPx4X9lNnjMD+pYNJnv8mzbqHsknP5x39TXQBcCCA/r+t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000024, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review! That makes sense, I overlooked this detail in v2.
We should absolutely just check in __mt_dup(),
like mtree_dup() does for actual locks.
I took a closer look at __mt_dup() and mtree_dup(),
and I saw that mtree_dup() locks both the new and old maple_tree.
So I think it also makes sense for us to assert both trees in __mt_dup(),
like this:

@@ -6379,6 +6379,9 @@ int __mt_dup(struct maple_tree *mt, struct maple_tree *new, gfp_t gfp)
 	MA_STATE(mas, mt, 0, 0);
 	MA_STATE(new_mas, new, 0, 0);
 
+	lockdep_assert(mt_write_locked(new));
+	lockdep_assert(mt_write_locked(mt));
+
 	mas_dup_build(&mas, &new_mas, gfp);
 	if (unlikely(mas_is_err(&mas))) {
 		ret = xa_err(mas.node);

Does that look good to you for v3?

> >  	/* Allocate memory for child nodes. */
> >  	type = mte_node_type(mas->node);
> >  	new_slots = ma_slots(new_node, type);
> > --
> > 2.47.3
> > 
> >
> 

Thanks,
Boudewijn

