Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9166606A33B
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=VBPyrz9v
Received: by kanga.kvack.org (Postfix)
	id 9729D6B05B2; Sun,  8 Nov 2026 09:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9469B6B05B3; Sun,  8 Nov 2026 09:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839816B05B4; Sun,  8 Nov 2026 09:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593B26B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:29:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C760B40231
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:29:11 +0000 (UTC)
X-FDA: 85412184102.15.68EC2CD
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id C088D1C0009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:29:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VBPyrz9v;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794148149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsEN2ewwq/SO7JFjgqolGnWnhAJtT+s3jJv0A19D4kM=;
	b=U6cRrx5mJWm6w86nSHPTj4EIoolZyxGIGy8UARUeTpgL8YvEmGuNbjs2js1jyO5wMcUcEV
	0/iaqtEGpOH3ynEcn+w8ZZNcpbQf8uok2T6j/dAVUrWmzVqRsl2RXEZKaz20r43uKcYXlI
	Zj1fcOiJjthCHfetikydQ+o8ifbBpEA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VBPyrz9v;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794148150;
	b=qxswF8C1V+LfWuLLF+3iaJjPFHRLQG2qnJwvw64dioEDZiSBO9bn/vi3j5Fiob/5vKpFpP
	ovH3BODs9bWgYqHUT0znCAsOVtcY79OmBA6SaMByatoBwUFkvLqE78a5JYwLUuyCv+UVHq
	+yoykR/wJeDgTb/Nq0u8XyiWQtzaEKE=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5ec3561b07dso46701e0c.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 06:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794148149; x=1794752949; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nsEN2ewwq/SO7JFjgqolGnWnhAJtT+s3jJv0A19D4kM=;
        b=VBPyrz9vC2QO3gaBmte/X6Fm4+0uf9yNWK/IcBecrUGKmnF3fGGpUyhrIM6ZszghrT
         9YqYCpgMrNcS8NZWh3wz9Nc9B4IHL6DjeOygVyn/1eZN2WJSeQF1tehAKX9v1E3JGRZM
         5mmE1MKyuVSzau2wRH+4h4evTFw8K4D8PbDI39NCQkk2+TNBf46DZ8oc8/XrLoInTM0D
         J14RZbZm5k2lsSOJFlnd0Wf7ygK3gNojiHlxCAFBrctr35nfzVGVi0WP+Ps5mq7JMaXL
         WFa+mTxVUYhgfpyg+aplNZrLhyj5szGSZVvTydcW3eWluhxjh1FPEqJMJixLmp1k9aMM
         0Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794148149; x=1794752949;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nsEN2ewwq/SO7JFjgqolGnWnhAJtT+s3jJv0A19D4kM=;
        b=SLxIFObUy3v8mhO/ejhH8IUMOBFNbO8MUYx18MtHLb9IxhCyNFIbwPV8FxhJlQ/d7J
         4J4vbIkdOb7jUo2j8ez/QFy8vJruPIep2syCkJg7NlO2Y2vdJPUqw2frTy3nWSuKoWg3
         QsmTb733wFD3M8bz5uyAMoFOwt1tnaqfru19ZAUSayY710178mqTldi/vlZeGS4X6JHK
         EDLDoHcGwLDTSv0KVuZt9zqAIuaOCetQetKdpFqEMaCFG0jDHiE4jJwmQIM8O/4PvPdY
         1qyj525otQLGvkGTa7jl0bNkFJEF7UtLPX3kA+lHwF49RZ8KLxdU+9RUROIspZgUuPGZ
         ukrA==
X-Forwarded-Encrypted: i=1; AL+hErHo7P6U7kNROCtkT6/LfVpn1Lv+2OfgjkbF67/U/CbgxW7nPZnnubV7EKc6f86GXBX4pHgbzE8ofQ==@kvack.org
X-Gm-Message-State: APuU4Z8LspV+t6Yd3Q6yWEViqgWyabOp/aBwrzdod/OHsVxsY4tmMTKz
	DvgSVVHzUADfRnsHIPitc/G8f0dP9jbRDzP03SL9F44i2RVRKhJhD3eCLDqnB5Eturk=
X-Gm-Gg: AYBFou1gpDc92qMdfGBJ/cr2h6PhfTnSpIkhKa3/Z8SS6ct69l5U234hBh2NybM/SK5
	cVYpjpuinTL10zRcCPe0nc+hWrKICiW4iK3F1IZ01bD8LjMC14wpbeN+0683ALVyU19pCG93CQg
	dKKGXp5I3J9ORfnz20upuKsWBa78TOAc73LjujfOr8QxVO3j/YSCaHG5OPnXM00VuDZI/oL+hVH
	tOKlJ9JaG6aS3+yiCl8tv8EHDVUFQdfvcCfQnVqqkQIcTcA8uuga6uYCqLSnaPwheRVEDhJ5S+c
	gaSJJS4Cza4DOFT6tDAfrUs9AhBQDs+T+Yo4nED8A1rmVklb+kijupJyLuXweVS3O7Qdn8ND/ix
	oRD0UOP+XCy6RcWVz4E7X9J6g/n5tu65ndBo9xrNQy/J9F7bLyYNsyDwjaeujoUseV7uPVl4nMA
	p7V/bpHGtgX6fUJdGFnEz9iB1C9tMaVlpzh2etPit4Nvl8pdq0YOxCPE+FYuRA2ACGt3GKL9L+g
	/G01Q6qLos+/H3FIcs93RwJd0zvyI8ZygSK+dQRizXJtQYijPmTvFZyYhV6I7EGGrs39AJEXjHj
	/e5Sn4gKIR4rdR1og+X6lsI2FBuXD638ZlU7XWQDYozk88KBMJPo3I+Q4HbB6pgxVxZx+EOLdzc
	1VqWaRHABVbVr7hARoG4LED5GFZfLU/FQVa21j5YnZ6Miyt5U
X-Received: by 2002:a05:6122:e00a:10b0:5ea:bf30:851d with SMTP id 71dfb90a1353d-5ecd1fda430mr689131e0c.16.1794148148877;
        Sun, 08 Nov 2026 06:29:08 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece6418de3sm1961786e0c.13.2026.11.08.06.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 06:29:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] kho: Don't release incoming bootmem areas when
 kho_init() fails
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chris Down <chris@chrisdown.name>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 graf@amazon.com, kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <au_vQhHAcJbkryXN@chrisdown.name>
References: <au_vQhHAcJbkryXN@chrisdown.name>
Date: Sun, 08 Nov 2026 09:29:04 -0500
Message-Id: <179414814499.358073.17024430367999674004.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=531;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=pKVjfmlu0iTkn3Mne7zQTiboAlXNWpArbsEY/CDfG+0=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8IczShqWPTsPqxG2k3B2z7SD/Zt27GlTcRXCS
 al4yUzZYCmJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCHMwAKCRC7dyhM23N6
 3rxgD/9MCj+nbRihezlRzunNe1wcq2hnBD3k0gmKVmGDeS3zwRvPDyi5f8qbhin54yxiC6zIGKS
 Yn2jL0+MWh3D673KAwTIKuLgSkLRa31KeqkgDY2NIUeUn8n1dy93a3R6SacrpULUNSSqQBOq/dy
 /MZNEyK82xSwsl+Sx/Hje/21XHQyJPsyH3sCLOoTpyN387Iob3sGAwvPfDCeyFdHkqYceUhuch0
 bVhl0fHheQIkA36lWuVETbYeXTbgULYcBy33lRmBEeXn4u1NFBXg3A4w3PPodi4WkP+kKCD+4k5
 ZhRLfJUfdpzs4vr1D8w6sACIbQtKUKocah2JuyI6+ovgxsIoqDKFrqH8oJVhAuuFSGLvYQ2wPsA
 OEU/OWtcEFLUvTn0Dw997Hdp5qpkq2ai2GgWLBicMwMDvSjNA6uGaOSfBTtyYsxNUn5LFK66m6z
 q6zKYQ4nFeit2N7SB12qa2j0n8ZK8c3LdNBHVNLh34aTCT2hEPO5W0YAYztVYpgdTBMlwTZLcaE
 QGfb5dHSyxjwyB4SKOLGd7zxItpAUtrJ3Jtmo84WFI+WJg1jYppRzuGJye0uO2/HM4o/8lYJkX4
 YiEO/nkmS4FHId5uUw6VSGMYxSw5N9dAPVcFqHmFIw4V3Mj/3VCQp10bH6t1qgUNmxYq1F3Yeny
 y962hGozq0S6EJw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: f7b6oc9c18au3bq8t3euyq4xchxgwdwe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C088D1C0009
X-HE-Tag: 1794148149-798699
X-HE-Meta: U2FsdGVkX18bcYtSv5E8lSSGD2NIiJBtZBP8LDQdaqu1ZaErG7VLiMh68rM5rFeQ8MmvPD6wYGQf+eDbmjSjXFlOg3xpRwU8qznWI03Gm3J5WphwKA1CTZNujGt3jZ19J9GPmJi5Jy22GhyVjvFmeos9I2wDe4yrBQx+YFnCDP4xY80nsjJil90gEW3S0R3z32iXbViZ1/rslbzmHj5hXxSPdTLos6XNT8Efwlp5//PCPBsG+iq34CAWi0LSONQu+ZiZeS1v+DIEtJNMU3RE43piOgq6S6+ej0J+v9UvTl4lVmm+kHH8ZIkVqx15ZU0gnYQqRbFul/lx4me6auZ4LDu+n9adWyFq9BF8BTnLYYe5QnQxdInmX0wy+dU7N+XWtaWzR5zdX77Vh1cHtwFDud7ebFr0Vgde3aGo/CKpItUhonI4BGc3iPBR++y8t62BJVxxQ0HYPlSDkV7HC8XbkL7HchCgySr9KDpRxuQIEQbpHXjuM7gcduaC6ooSPFaAfaV+J1fqLBa9Jq72y+SDl22OdmyK9oR+VAE+6yde1KyYNMVg6JBIRbj/8/R9tF1nOC8UVHQYbZ2UYhO1MkIS4UzT5LJJ1nR2ewjiyLgyYQ/OdwnCZhpdNfmm5c8kEKXjXauO0bfdYCDyA501TRNFxTAQCdoS5C8yAeJy/qPEJG9gSeghGnvDfnouRL/p8rh31oYv7zEDnPqDHyVHI9kBShsTVQWhPkBIBOd3PyaYrs3UVvaoUkithdwNaLBvPmRIpChjIUk8A5y+sR6wyOhHYlNZHusxkLFsRVYXq2ldro/A7OS5VPI0Xf+GRjW+cUBDlAENYCzxhZUHcGyFKAZzVLJwMZ2SBiFI8blSALx5qiBi5diA9jLdaPSLaJKa/v+tFvw8bWnSDz2/H3vMzqpiStieuyEr7Xsi+fdEH35qRZ2w6NLyzmqfRiS1q/xQzZoFgIbc7/rNYX/GntzX781
 S/wWO1Ha
 TkJuYh4KkQA3AvxrpkZyobOs79CED1JzgIi7zF6FgPeIbyhQP7wLr46B4Mb0Wv3Qv3UA1TBIC2AcNSflqKK4ixYuWDstw1hSco5GoR+3+FhkmUDhNQYL3Kiz+z5gdrUdjcP+j4WTp2nciRyqnSY7dmcMRrhGF/PH3uFNuji6tJ0aNeQe5/w6hzVj1JyLlwbMMoQ32P76JDChgwbaJ0fiMSS051aU+GfB0sH55C30sS6BaQRwhwe11bCft+ze2Xpr8eScQ6gpO0kBOPXwN6Xxo2sy15jQ5vJdxs7t/jirIru4mdezsxJuZ7bph7OBPya+114NZPeQSJ3TfdiFrOi/7HijQoWUR6FPH4KK420KtrwfOnNs5FqsZnq5ggMRxln4Kj7KD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 19:40:50 -0800, Chris Down <chris@chrisdown.name> wrote:
> kho_populate() adds the incoming bootmem areas without reserving
> them. memblock_free_all() then hands the remainder to the buddy
> allocator.
> 
> Unfortunately however, if kho_init() fails, err_free_bootmem
> currently frees every area with free_reserved_area(). This can free
> pages still backing early allocations or free buddy pages a second
> time.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


