Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1521E606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WneWTr+K
Received: by kanga.kvack.org (Postfix)
	id 183E36B05B6; Fri, 13 Nov 2026 15:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BCB6B05B7; Fri, 13 Nov 2026 15:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04AAB6B05B8; Fri, 13 Nov 2026 15:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE8256B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:43:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4255C02EE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:43:01 +0000 (UTC)
X-FDA: 85431270162.23.A1F9965
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id D015C1C0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:42:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WneWTr+K;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UYRjKetNPMdOuEAL+DzBuZJ1WB5Vji040ubXNb6Aek=;
	b=03Ees5sP85Y/xJNpbtxFwTo7VRw0GyDpOrJ7BQwrPNjE3tkH/Y0cmzhBrKM0mmw1DlvQis
	uuMTid60m2YhI/d6Z0yoR4izwkCID/lXKlhkvPteImrAZhYd9gQEeNa6OVEq3PqiBRlvoc
	gMOSJm+vzuY3kzbdk/8CcIEzQb/aQ+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602579;
	b=49SOttnpkezQ91gXrYh3ATuNcdE7Cr/djLHUKwAIQdNvaCXEbZnHEL0pyZFHvUcnzFeqM1
	/72M/LsgZ5IUJDHTJ0Z84yZi/ewzvVXvaLcoOaM3+NHufSbcQ/BnkOTG1eLZGbuZPGObNC
	f5X+RJLYC4zi3YBsL/22kigjaVL/zVc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WneWTr+K;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-536717a4d83so20587271cf.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794602579; x=1795207379; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1UYRjKetNPMdOuEAL+DzBuZJ1WB5Vji040ubXNb6Aek=;
        b=WneWTr+Kc3Pw0Yzh6OEq3XuKMLiTn/ZYs/gtAg9sSk+4Ht+gHizjGTpdgu4UEPvsJi
         tkMbetge9kNZkBhJJ/cuUm00+4lyI8xhxYLgrCO5mSp7E2aMCMOBNdFlYanvxZk1nW62
         vu5cHDm34U3qonPVvad3R07hv3kCjI2DzHSevzxznAvvS5wzpEp+fD/7qnvdsuiel/zc
         iRvpA8iYXl+s7YSDulxl/RHr7ZjVljDSS+6UFGGlLswxGwVvwSU5akcMwGko8VP/zvFb
         D0qER3U3/A0MiX66it+P6I8Yv+MElOyQP70TBBI3VBiJfIn9MW+RHXH8y7aT3LIJ+k1d
         fZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794602579; x=1795207379;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1UYRjKetNPMdOuEAL+DzBuZJ1WB5Vji040ubXNb6Aek=;
        b=qdHPSba1AkHmYGX31EKpM/Il5ByCu/2bXQYbkdSbKEZJQv0mj7K3IAftv4iGM6ORmj
         l8KTUECBpFEIQjYIGhkdh0u/WARkSISKx1K80qogvTdaG0Ox5+rLuTdOKEJeiUwb58sR
         D0fjjmZ4xh3ra65q3/vJgYzJIvRxeSy0L7VlbjYop376vbSz8T1QdF5LhLIn2t8MlFFE
         YGOh/7QhDkzFIynQhN8cSLdaoUEpy4tRjtes3U4Vj7/JMZ5sEw22OoghiXlBDVRf9ZD6
         E/XI4cozYLnK9212A+VdIcRZ37Iuj/CLXW626tfS1mcA4906pDeFplT1mEwdBzOErk85
         FVjQ==
X-Forwarded-Encrypted: i=1; AL+hErHchZ+CZh7uiarpBfUPgYLiHys+rYRVm9N9MyNOCO8MBKxbsSREpT0FMIcekxTL/g3R/lpYDlW39w==@kvack.org
X-Gm-Message-State: APuU4Z/kQbdpwkdvCNv7SS1cHP+20A+LprmzNnYGuVMfTL9yEs1Tr366
	o6UyiQDUiFdCGUtWSKSNLQ/vbbNNdB6ekg45JYFVILPDCs2LZaQoRJAMhwncvxLadWI=
X-Gm-Gg: AYBFou0b4PG567Djxk1yqX96dFbJedr4VcJovKC8S69sjT1G2woTHx6zaOHst9ngM1o
	VIaMRsOQBSER44ilJRLunzZWbU9kVbpd3h5SEmNuERPNNQ/KuL/reZQpQaaKG14WNz2SG1VP1M5
	We2XnZV3D76aQ0yUZ8Yi/vfQ6i4tQzrsgf5i41gdDdSwORvvw1tCjv3lxPKuaQZWfGOrLCkrZKd
	w3zulwlNjOgybSNXhadV8KqC3Pae/LX1dF2JsYYBx7w94j6bw8Mp2Hvo0zJxvSxc1BjPAw2Hmcg
	Eni3xCsQYOzpzUsz07QozhxcjLuxHU8as/woQHDRFXuX4m2U86c2a1IF7ILg7Fnkvti0ij4tdKm
	OsvjvKTC+eFaWhosCskRu72lHoS2DpGwhgw3LYVv8hPbJK0KY6QHYD2PNFypbOn61fvwXqABBBa
	wFeYppGX/6OpEpgTZOGRp+PNX8Xv7BojN9PgIxoFe1TXdH8HQab1WEhGlFmUscJwar3OPRqcRKf
	D+tFpLXvVpoL6oo+v27IWe2NQeZ/zC/G69Niy9MeJOhArDLDItWs2zlPEfEqV6MbFTn9x4w0IKm
	qT1qSMF2GPxThuDpcFGP1KqSyTjlXBZhtZu8K8Qzx8pGw1cnlU7W5St9pZpgrT8RJoIoHTAdUR8
	ittbMgfw=
X-Received: by 2002:a05:622a:a882:b0:54d:72fe:f3b0 with SMTP id d75a77b69052e-55ac8b983e7mr58211941cf.48.1794602579094;
        Fri, 13 Nov 2026 12:42:59 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55c3b7a4adbsm3582051cf.19.2026.11.13.12.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:42:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, jgg@ziepe.ca, 
 leon@kernel.org, akpm@linux-foundation.org, kas@kernel.org, 
 dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
In-Reply-To: <69e27ce5-8378-489a-ad8e-37c364cf63c5@kernel.org>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <69e27ce5-8378-489a-ad8e-37c364cf63c5@kernel.org>
Date: Fri, 13 Nov 2026 15:42:58 -0500
Message-Id: <179460257810.482102.3687220421358656606.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: g7kojajyo78cnso9kwcqbnqqr1qjpuc1
X-Rspamd-Queue-Id: D015C1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794602579-485192
X-HE-Meta: U2FsdGVkX1+wswv+WslwuqOF+LKvgLaW+mtrfE78yriYBUyWUmvB7EPiwYgsY8TPX56KsXkkJVaBOpv1a006pwfHXpOm/XZUlZRRSjkjfcZ7UReld84HO2YVriTMfm1iJMe3Nb2Ps1/VwLqmh6Zxi90tmnG66hYVfm8N0WBHXjECtXKStBcChmFbhICMJJ00co6MDDIg4tHTZcTcQIoERtRxqRfNmMfPxNwhHBvdk0b7H1/lsrp6F9a//Vd55y5yNgD+hH7Y6UdRz8avwkplxGtvM4HgdqxznCeGS+kjTnXkgYE5HVUU/BNemYzTPSHpyBZdOk5hbvcsMgdLwtbNq3Bc8f1Lp1a8w+nc6Ss5dqwXtHZtmmqaH+qnJhIWZYh0EOTykEVEDerQuJcHerC0S9On4MC2VnUYpxyMjKniw70PMN9fPoLf24rjW1xhsmpcmGqF9or6ogoWIh/9j6kZWJYRlkuV9SRQR7RWdHYUYh4wq7r4X78TyCp/w22rTSmYiP+GK295cXaDYetu4Rv1e7HKbUZqXGkgaK+g5bIy8q605h5s5NVCXV9HYgOHeoyqGSrPqi//ewah0dQC4EhSsaetC9/fQcX+v3IuTah4TTugX6h4EaT3dzppw/vEk63IbvJPyIwbS6d/05v9yFCVBDzBBzFaGHX3CMcaGvGx3MV0SiCAf/0hGWjOPTqwaUU9/t/3X9soYgeJ/hLoFVUf1EVmBKDHImz1adTOxh2fRZ27ZiBj5DuJ23sxBqXVfShq1Sh5iMygEtJeB/RTG9ZEiJ62hpTUs2D753P0EINs7QgE/B+GsU08eu69klpjOpT60s7bx62eUrOSEB69+9xOoW3ZJsnvrVEl2CFNxKhBtQgi6bsPKhK4fguktp5o+9lMmxflUohDE3Cg/MhLbsfzXloeYvHELBxFwnhsoW5aI01/7EtjJN+4l/8KE7z8XDYCZeINw0IiSvc9s/eabKw
 kxfsLpe+
 wr4pkrv2q4seNiDo+N+zvKED9xKPB0Lp08zpxFKAVgDSgTQQ9wt1xnN8rqh9dNsTbz6Q6I833bh2YEFqmHBv/sjE+R6fvnsAQKehaLa7ibMLy2bj2rboIn1DmuJnXtPC/iGIfdom2b67S5ElaDzYtaiD2f+fv6KAfx40Q/BJGU2KMnGcQLsc5xxPwnX3TBxjHFpubVs5TowKL6u9HSsvLX8TruSAm2O4u9war7XXWeNwAbNcBSLLQqZ6SW712aPv24P1oNyso/TCrQSrXKNVaX3Y2NB2jWhjpPrABJRamVYbcw+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 21:03 +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 20:55, Gregory Price (Meta) wrote:
> Cool, so I can drop
> 
> 	e27dc0754e3f4 mm/hmm: refuse shadow stack vmas in hmm_range_fault()
> 
> :)
> 

Haven't seen that one :], i suppose *yoink*

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> 
> I used the comment:
> 
> +        * Shadow stack VMAs must not be written, and there is no particular
> +        * reason to allow read access to shadow stacks from devices, so just
> +        * disallow it entirely.
> +        *
> 

Seems reasonable, maybe addresses Jason's request for additional
context.

-- 
~Gregory


