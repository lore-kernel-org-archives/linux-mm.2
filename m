Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BB9C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 10:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003C26B00C2; Mon, 20 Jul 2026 06:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D076B00CB; Mon, 20 Jul 2026 06:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C756B00CC; Mon, 20 Jul 2026 06:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE3BE6B00C2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:02:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C4221C09CB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:02:47 +0000 (UTC)
X-FDA: 85008715974.28.C5FADB2
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81F811C0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:02:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EZWntXj+;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784541765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnhYXYT9siWEBxQexSgO6rt/VLpCp+EbrkmrDNNkNo4=;
	b=X5ucFusP93wvl4HzyD8houvOTDofeVhbdwFBQ2fDE8s+LRLy/Fywf6HbCqRNw5Zpf/id7K
	71X7vI6UbHIZ1In5uV/cXJ8NEElM7x8VzdyPShjJPKqRREqHw6pot1zrV+N7ZCtyZYxFQ1
	cggT8CF0OhvPeLQGOOLUxzZzRntckQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784541765;
	b=5gfZNgyqZl2xU7nF/b7yfT7U1wzU7U9Aczo04ArhLthCIsbS6cn4bX1nuvwc7ld06Eoi38
	GRnELfn+/D8956AporJdHADCIMWj+LaXW9jJEl79mZF6DqTpopXf/DzBVN+5TprwUfAaoV
	OpWuSHOiywZgauhJ3yPsy/M9hNa9+aY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EZWntXj+;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdb73f0e1so58073705ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784541764; x=1785146564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dnhYXYT9siWEBxQexSgO6rt/VLpCp+EbrkmrDNNkNo4=;
        b=EZWntXj+dj6uaCDSPecPKgoZaoz4bFQLjLuQ9J8OXwjRYt3XjkwRjdzzHqSc9zwI8E
         qThx9zgYI9lkU+o8/2/kA6/lLRzjtsE+qxq6UBFu6dDK9bvh5J5NLaXkAXC1jlGKbfsX
         qzjH/+KynR8MBEtclQSXc1MyouoTNaFKWU9hxZUSe9+NcZNQUBRjDefYrAZcHQN3izfE
         kwyhx6L9x5d2YX8ux/OhEgKDTF1tmI6qQcsyk329/fw5zwVAZ0743McMEb7piNHcwaYy
         1pUtfMRrl8mZgtPuiFJL6iKguLkBiICgT2MCYp8CfqpMnLQvlmQx+I2GMBiiLv8kcenw
         i+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784541764; x=1785146564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dnhYXYT9siWEBxQexSgO6rt/VLpCp+EbrkmrDNNkNo4=;
        b=SrE/L/dEf8PRL2+blX9py8z6FWyzrPEAWYPT+2iVLgwMKrFD4rxScQc1L8T/r3AD/S
         nr5ZoXP1ipiikXxKGOEOdBSn3jvAXYgIGl1JXG1CCDRYPvpvvZpBtJYkGEmjTrD+gyN3
         fy+aL5KClbfWrpgq6NgXHCwgBG7GYBj+oSbYYtdckTssdR3BCR3HfkuApR8+UFQSBu1h
         Ood/BHniLQ7tyEPtdHjO0phJFs+kyu8eBwmkWRKSpowGOJCzp858J9pKEi+qurQeAztU
         RuVJiyD4MGGDTYxKghxkg8TeI+7I7WmVLK5ZNpAo/vFJ0vQorgbfE7bq5s9rhZoJoPJc
         OGgg==
X-Forwarded-Encrypted: i=1; AHgh+RoZmroWTsDx9WaUPpolk1l5y/surdVpB28MUE3343rM6HezazAQEb4f9lOCpSWQ/yIyjmOqCQgORQ==@kvack.org
X-Gm-Message-State: AOJu0YwJtlMOTMz7F01cQtrv/Igi1Qd3wBrkkMRnxOLBvz6Lttr2uDLj
	vCy/OK1gp0vED8ZWPPIfErB5nLs9q0q+M9yFsXVrT0k1wdOD0PYHBbms
X-Gm-Gg: AfdE7cncy1rNLlChPagQkD6UYJuNhL1kiuhF+BVsRp1L5Y2rfPvbLlSucGiyiB2E+WC
	IAv/W/oh2TbE1HpFDfvT1qNPe2BGTXrC9yiXsz3UA4wGMLo9GIwZ8g5eqiZbIqtmraGLvyPROj3
	ITlmhMhX3My3jouZNnqJjcml+PEiStTGQtDJpxyrtDTjomzSVCEy89Q+10wUD+RELwtr1m8CvFB
	TVotmCLuX8zlHS3opvWsd9bAYu1Rqdy42Mg/26ScHoQkkZ7p2QMDrIvwmKKnHCw2Uf+ioaIAtQX
	hoIsTn0rKAen+PytcGUm14pzu4M436CFfYGAusovzr7FE/WOxMxvgJkdKgnhmvw2X8MCeIt2tN6
	AutuUKdablE7k5xU1ERjNHDbQeNqTj3SbwDcA/QJzdELAdO8xMeca+EVKFqCGEip+Jyc/trQLqU
	MHTltY7Rw87M0W78q9dBOOfj3ozutHuqd8FQrlRA==
X-Received: by 2002:a17:903:37c5:b0:2ca:1b97:70c5 with SMTP id d9443c01a7336-2cf34836750mr147318935ad.4.1784541764141;
        Mon, 20 Jul 2026 03:02:44 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3471f42csm53933185ad.61.2026.07.20.03.02.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 03:02:43 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: Lian Wang <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 1/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 18:02:32 +0800
Message-ID: <20260720100232.32500-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e01fa50e-b9a7-4c0b-ba70-6088b8d6ddfd@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F811C0007
X-Stat-Signature: ebfujrxanyqxsfhq58fc4bnfphs4ta9d
X-HE-Tag: 1784541765-363047
X-HE-Meta: U2FsdGVkX1+vKlNCC5/yHqw7dldApFDqtn91sg4oHvZY8qxLNYk47w3Wv9p8+mU1YwCYN3lOt3Cumy16AqCP8k3uhltOEz/G0dVlHswcPgbLQiR3zWKdg3x/jBQBfyU1quxhNMb8K8Mu6CzGvHrp2kvpdXPLy1YAp4T82D7zi9k0QbtOK75ghzKKnX1c2jOF7I6eMYEOPCHWHBII9d4AqltO5OKauY6eRBsGW/5Bdid1OIU6/qd/7w5BA6M5sQz44PzSpwHX5HVXkQ+JmPQOre8IKpTqSVp7YPCGOc6PbS/VSaCEsiN/xU5xeLMk2nn1Z3D+6mDf2fljnuXeSOmmBJrJX2VMoKHLc8AwuTGl8x5GMRHxMiHLQfhJx0ASfxPh/1ydNSJgtsy1acE9pbY9Me5210G4TAURqqC3QHie1/zmwRVQlZrtsD3K+JKo0MvxEt2p44nTi5s72W3kbD6UZKnSXNyT+ERqsQ5DH1YTTlrYr2oHi/9UCMyFIHCIqdrfpigM+dEuBEnm4Ed76XRNirgwBQrHhW2qX8L8Oug2/5vso4UZWHPvwE/gzBKci5opzcB0fI0IBiKzNre2Q94c7xrAILQ1i0znYoEDDPM0cGp78RXHUXJRhHKxa+rN+HFVhpOr5sWvKMLDaTMC9MgW5CAhor+R8WPw7WATrExTzyFtxv+DjK9KZsonKRMFqbg4or4T7uqpmd77splI1F4bCaWE3L+z999YcYMLM1DlRTvV/AgPYJotGg496txfk5EskoeA+/Tr3J7K59tLAx27aSo7f3su+dSxz9nRfgrOaV0UTmlUyUaGXlnZ5ykNbteA/Z9yGVEhdvAuiIrWiGcvj5JEdg6FOqAnshwK5eusKRkDKvYri3+wWO+aaTAOYlIgk2rldiGF/F/p20DEWB3ys9G1CXs/jU6XUPMrAi7OmrK20A/KBJWgI4rcamEsZ8+Xpp43pLAwFqLZ+b/tEyn
 3484Y+yQ
 XYjIFnQ0zXGaYdbqRmXEX+AZDghvOfo7YNSflddH9tDQGhMMGhbcQ+qEGH7vgUI2i3PWN5st9TCW+5M+kVdNT57GJ/U6TFRH4suZRelwXD6xzAT/IpgXBU1ik1e+Q3P+UIyQehKYvdE8IN8+DRGzguRHb8T5Fo0jetfWdzCLfwzq+Y5Nt3V+7Spi7v/UYgoKo0lvqStR7UnCQYpuN8OJJ+MH0iUgwMSXgbPUHcTmP05/h7gKXBLAv0RE6AXCUYZ94JFqLTToD5eh6v3UvbWVMq5y5+ql3xtr15Fniygh2GJFNpFq2rGhlYhtIoBI7ZQwbjXZZIUwJTTzoRIxdvEwzXPg5Pua8JW+1n6hwsNmgNtNsbCZWQYzUL0AiaGRoFGxuFJnet7nNHxQ4QzdXAvd8/hRz8XEPKSqqev89+r8L4scezpKC/R1TYp75Q4+LETLKNK8RJithMHOGEeNcmqBvfGnkDWCzs0ihtOS+/eWHqlbZnENw3RHTctpjZYBWxg3ldWWym24Wm1Jcsp/LTYaPpc75hySnI0JztP5tINHcQ+1jql+Ti/3SmYiYEPXAFslSYjWMcQOG0ZNNSIaOmV8bUrQNjtBCjTmfQYZmEDioe3L590k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 12:47:23 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 7/20/2026 6:03 AM, Lian Wang wrote:
> > Add a new DAMOS action, DAMOS_SPLIT, that splits large folios in the
> > target region down to a smaller order.  A new per-scheme field and sysfs
> > file, target_order, selects the split target: 0 for order-0 base pages,
> > or 2..HPAGE_PMD_ORDER-1 for a smaller mTHP order (order-1 is rejected at
> > store time since anonymous THPs cannot be split to order-1).
> > 
> > Unlike DAMOS_COLLAPSE which builds large folios, splitting only dismantles
> > them; it allocates nothing, copies nothing, and no THP admission policy
> > applies.  khugepaged deliberately refuses to collapse a folio to a
> > smaller order, leaving the shrink direction to callers like this one.
> > 
> > This patch adds the DAMOS_SPLIT action, the ``order`` field (placed in
> > the existing union alongside target_nid and migrate_dests), its sysfs
> > interface, and documentation.  The vaddr operations set handler is added
> > in the next patch.
> > 
> > Link: https://lore.kernel.org/20260605161422.213817-9-npache@redhat.com/
> >  ("mm/khugepaged: skip collapsing mTHP to smaller orders")

Hi Asier,

Thanks for the review.  All three points noted -- will address them
in the next revision along with feedback from David and others.

Thanks,
Lian Wang

