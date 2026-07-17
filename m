Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2FEC44520
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 22:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935AB6B00D3; Fri, 17 Jul 2026 18:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BB66B00D7; Fri, 17 Jul 2026 18:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB156B00E0; Fri, 17 Jul 2026 18:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 485D16B00D3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:02:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7275A028C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:02:42 +0000 (UTC)
X-FDA: 84999643764.28.F961AF4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC81D140011
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:02:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQTXxWN8;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784325760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlCwb+1ZnQlT8KXH+VzgKgpVkzFEV+OYr4Ev43BkCgI=;
	b=mycOgkBwVyitxzDfgR87L/12oRP6LVO3jA9lGmkC5j1SHR+xSVqWw4NF6bqn/C3YnBHhtx
	VbcvOtgQfdqG44pxjb2SAtyejoT+q5mTNUGc9bw+qqEbpMLs9rP7OqoWEEkgiV5YXxb+F3
	o22ES1EUe+5BnPmQTWovArjVg6xf73o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQTXxWN8;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784325760;
	b=BTTiKH447zBGm+syzRlT5glEKS0RuIHBOAIpw0apJdWwthke6sE6mPnqeCG+Q/CTdEt8/z
	toE9wWkhz06A2orNI8QCQUevqlj2VhlbRhZ0RtuaX5RA7kBPFZZjqSLkWP4g77UiZ7HlVf
	Hb/J1BbC5RwHg50Id6rA7axQGWQySdA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c5382806fso41960641cf.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784325760; x=1784930560; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HlCwb+1ZnQlT8KXH+VzgKgpVkzFEV+OYr4Ev43BkCgI=;
        b=WQTXxWN8BgT8qinY/kmkhMIWmY0YUqk/e1KrCCzVgO6IphYhUIAummxMbw8Gi0Ci6X
         FNEXhoBEW768XrAulx2fRwB8T7sSaSR+nQ5OswgdB92Zi9PFx6w6wJ1Y4nv4B8zwqUQQ
         eBbGq8kNpTrPpLZg3HaemvzBLjg6b1RlRyrb5duKabV7Z5MMg/qqEP6ClTl9bJnYQb/c
         WImQP5sl8kPkDHuUzzgbsafNleYUtqFxKlsO6gmZja47JCAQ4fXjTBP/xm5EzKZxvmsr
         NHrCcK71MoxsvdUSfw4OtXx/Q4i76DSg3jgnaaLZwr8QOsA1+1fqLWlFJfZAmtbf/x4m
         N+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784325760; x=1784930560;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HlCwb+1ZnQlT8KXH+VzgKgpVkzFEV+OYr4Ev43BkCgI=;
        b=XQPOwBts9NeCfVGO2UAjcpY79r6U36hTbco4sQ3t/Zsp+4SPPz6NWbLL6YW75CTAAL
         T59eETVpJUzZ6Qzc2ag+sLNGXtOsWKGxvjFHPLbc02rhZOoGFwNL7C+oilhLpkBrr8q9
         FboG+GomM143rj0Mqx1WRFBeafx66q+rOV4OPHUunknb3AC5JbISuZopdTLEqS6uz7QA
         3FHbQm1eYxb220sTJac+9lXPBofQoV/wANppattsCbm/Hl0qW5vBuJkzrLB2gzA30v8+
         HMUs1mDfPVKgfoFpCXpAJv2bI0XioS3QPq3weStZnnemZ9V8wxc4cf7xvrp95cjH60EX
         XI2w==
X-Forwarded-Encrypted: i=1; AHgh+RrJD+E7kH30u9EnuXJLSQG5ef0EenCN8JpJrWRI3MPJ+g9yG4wrxTEMBQ9uI7A7VTL+9U76x72LBA==@kvack.org
X-Gm-Message-State: AOJu0Yy3w0JNNQjVUtL00ceDcIwkQ9zLRMtagO1lvGKMBhnjseC1XLd1
	Cm+xuFnCoqIjW/Zfunro3XWk0SwGuguWL/CQrXo2TQODju8pQNkhxTjl5X10EDxJRhc=
X-Gm-Gg: AfdE7cnINsyFj7WnRLj+V6yYOZD3bq2knFGLyqsy6RcDhKuIq3lTWa9yLgfDFKyZnEW
	xWHqoDpyYlLeX8jExKIry05uVMAwXP0Ak3NF3Ap5W0rk4JopTGIMnMPjegyEGe2EF1JVcyXcAdZ
	UTKwoPthVTX+gPavjYouQv+YD1YTs/W0kQym1N1JRAY4U7Qy+3RTnHqJ3Co/VG0fkgPoKjAHBUX
	ieb66ZGRNBNlJtBeEqt2XhcBn0hZjgYlZLe0BRbXQK1+bpQA6yzBF7rJt+QDH1suY2ELP5mU366
	y+tlwF9WW/L6U6cdF3Yo1JepJrQ8D2Q2MASN1J33q3ten15ivhKLZof6MiVb4qF8gO/C+i1QWB5
	8CAGn9n3gP+0+vxIQNZgHVSqb5GOa/O8+F6XSbzIT9rPIOheJeondKIkLBxpYiey7S0IhgNDa9c
	uxNEMb9HwEQ7ChpBEBYVg5DlByDi0GnmpQJx5XQj4=
X-Received: by 2002:ac8:5f06:0:b0:519:51af:febd with SMTP id d75a77b69052e-5213f668ee9mr42987041cf.46.1784325759954;
        Fri, 17 Jul 2026 15:02:39 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214f016aa5sm21849151cf.17.2026.07.17.15.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:02:39 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 07/12] PCI: Refactor matching logic for
 pci_dev_acs_ops
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-8-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-8-dmatlack@google.com>
Date: Fri, 17 Jul 2026 22:02:35 +0000
Message-Id: <178432575544.189683.9290455764634301119.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=586;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=LxcbZe7BgnncPWKoPk5gxZGS/pQMdASC0LgCixjRw3Q=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWqZ+Wxzq3jD2mMABNI1669A+3RszfBn3ErJXV
 Y50TeZzWEGJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqmfgAKCRC7dyhM23N6
 3sVSEACDLPUH2+MHEoWyXAsDxYRkVARIRC+B2caZvvSgXaiLKmKi7pEnnql+8FPdsbwKkqRf9Jo
 dQ2qaVmpxf3l7ARpfkVXvpF8obibHQVOtxBKAkqoFNEHzWZzOBT2vYoywdcdcaiRGpZ8X12q8Tl
 TZ6s50Ini0rYTCvZ6zZ0zyslIqeoYN/w21C1mnmLJA5l/oSdh8oF+nocO9jyy1UkYfclKEmsVfS
 aASn9AyStUUOLNMQvuee3N/W+Er5iAx44Oxg/HGGBmN+ofL/MrxdUAodAIg6NbpN0q5+5fKvDvD
 3KJcKOTnhHwhzxV3DvLnf1mAjYQ/jx4J4sTJYd8zPRCFQzvZ6IDSdiVzymUbhQvcVC66zvWuSgM
 zuzoedeSeAq72CoyoWiZ8xLA3hfJyhDVh4pzPcDA46ZJ0AgW7nAoqHiYNPJVCbtB2qPsQSNgU4G
 1APtHXn0r5wICS6gPX7ZNcb7gNjnMcy6DZnrtpb/EgW7mEZr3zXxyuTeJrA6i3CogY5HCwl3avb
 k6g3LAvAnL5AhxIdAkfMb/JyCoo7fbWVvu3QdRJZoo4BTMU36Y41oNHHfuKo4IvKo+GpHaqe6jl
 t0fLRciM4UeB0Huvqd6ER6xDzWL/FjnnKjzHSJX4hp19xMTADl+jaeSlOdLUWzkPxqF+6X+8KBF
 zC29UAmi2lxznvA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC81D140011
X-Stat-Signature: rurohmu5jwqbky11apd7365cb67dahat
X-HE-Tag: 1784325760-993842
X-HE-Meta: U2FsdGVkX19xqJIv8s57iFrfnYeeDxO45HSgJqhh7iSxK+VNdx3JoSYkuY4rjgePhPcEoTBG4oS5DVfNA8e0pRkrKmuFeDu4gfXcalKeUfHodN/5X7ylk5mO9W+pjok3cQdpT7SYFLFbtSHSbBH7sAmoYyLVNY4Oj5ZPiLlqWLPrgJbWiXgtxuNK2TfpEUOc5vBcDlIyoaH7gIi7z5wJyLD8H3iMgvCA7dwCDLGyFR8vmc0gPYKzxpdaQt0sFuGeLUM0zzLqHBRPq92AUELGQX2qCuwb/+tgqpuRj+4bnwxJ+8IhxIBJhMTe23wB1b/rO8/iT/n58UTz32CzfhjmVD3Gvp7QzfCBE09NVPuuXpQDHurMS9D6+3dDA35nbHH44Lzp9j9WA9M723CF/9xg8L2fRzJwy/aYrTetxYTQJS0SMt/aHYMd9DRLcrnid4wpUcUcGz1/8B765svhO59gmNrAuZx/j2q3ThNp+PpFCKnumUnkjDbR9pJ96gF6e0uHJ6bNN/cjAFt6eExsSymX83FZU4Ovnxn0oYz6efC/XIHDU3SWZ1fdnkje6/RYbU7pWwSeYpliMVUz95MZII4tm7dUGgc253lzewTsX1nlvY/sgTRZsHMI1Z3p7XQ/O9lG5wqhGwJ5UPAE9NF84cp49PcQuupW7Vo2LDR1106DJWn78hRZOZcZqaPATQtvfOuCa2Q0BmMVd6mVdohhVGqNJAwa3ongsomGax4Sqf2F5/hqc3AOS0uRJkn9dqbXJvsW+h4/wesiwYAdkWLYY6fUx1YiWSi3nrEa9yRVjPe62YQsve/0wgyc2N+odWa8m1FnWycCoEEhxDCf1FvpckZZJKdCPF4LuQdSeO24lJAyM4HKv1ChcIHHEud1irhkRsqELOnmglrTYGopBJlNWONG5UZeS4aBObU9vheLjE9j28koRBYrwS1EniKp9iJMpke5Sz+Yvq4Q57Uc7Q8tWYu
 KcuLu01T
 UzWJtY5PaHfTcycQODo52CHovIxs4Y2+5HMaVRDqtYT3TTC5f7afJ2/nP1frGpKzvD7fmmHHZ75KdySUwcxaCcqAVcflcWgLnrNLxNioccz4A14Ub773JJiO0qSfE0ef5TRDZ8gHROunzU72DS4sphplgpJHxcHVlVCUqvfVvdpysM6XbxavwnTPiRhoHuwLREQ05dZPJ8mJ9zmN9w4xeGWxgjhqhyHMiucUUvnPCyOm9CBNaC0YLz7XVeTk1OgOSaLGemc1iDQTI/8KFgWDLt4zfglgaPzmFm3GVq6REvMtMIjZyTe8V/ZFyPth7bkjPZzAFPQYW0XX8E5g9AYNiGSkYnwWwlUFwFuiMh5qpNc6mhVOQva35QG7V5blHEh0snp6bTWJit2kgBFz7TmWdU0/AtRSEBaCjsatn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:10 +0000, David Matlack <dmatlack@google.com> wrote:
> Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> the loop and device matching into its own routine. This eliminates some
> duplicate code between pci_dev_specific_enable_acs() and
> pci_dev_specific_disable_acs_redir(), and will also be used in a
> subsequent commit to check if a device requires device-specific
> enable_acs() during a Live Update.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

