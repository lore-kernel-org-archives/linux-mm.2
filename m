Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DDACD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4597B6B0005; Fri, 12 Jun 2026 07:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432706B0088; Fri, 12 Jun 2026 07:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347646B0092; Fri, 12 Jun 2026 07:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259486B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:39:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4863140371
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:39:05 +0000 (UTC)
X-FDA: 84871064250.22.DADFDE4
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id C0AD81A0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:39:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ik1036KJ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781264343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVXPrAHp/BWzZQhw02rB+3vghjeNf6PQdvQ4HyaXKb8=;
	b=o83fpd4+YSsoba/wOVbDkEIpgVlrk7DRahJIQ+Jh6d7Jhwwn3zFor/PYCFfkjOz6LPfyT6
	QaerG2tlhZI7i2k9c2HPp4LaNZkFR+G8t6eHw4g266XrXPLjseJMbSvmS2m4Rx/D9MY+w/
	1LJU0SIDD4Y2ULMZHWD/J6aDP2Ibt5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781264343;
	b=72GTKLXaKhjDoQCYZANv6U1kHrRP1onCAqGor/DU10xoTedXKenHnivvjfCELMwXk2A0Zv
	0Oaat1pTdJO2SVjjcUr1r6IIIVqQUcHZQXIFjRB+/LDUhN1BoDJWcMMOVfEllDrlngf56F
	nCo2wFb2ZAxuyDv2H2s2sefsro5Mdp4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ik1036KJ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8cce22e029cso25522186d6.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781264343; x=1781869143; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVXPrAHp/BWzZQhw02rB+3vghjeNf6PQdvQ4HyaXKb8=;
        b=ik1036KJIrmPWK7c9UVn0IWpXJ96LhHwfRyU8sJ/1cYbngFYDTahjgbWSrxyg8dk1u
         mO/LznuLIX3/IQ1KMuEqe0VtpwC9sMBdKOYUn/Q6AZcehbXJhJAStKs+YTD+ZNGPDBSe
         j1mL0VNHypP4WB0x4dfCNTiFiyBeODzutnA2MZ8RPXPQItOAIvY+f+Bnmg5uXrtCQ/Fh
         UIT8tshQDci09Tr/10r8giF+EtDBdHXSEncSM6P4EUMhrmfgEgwuoZ0l1zXtYOtYqlKu
         keUzzpPjLd4zCgyE3BxsfSpwdOZEP/dYYzPGHnhj5oI0y3S9jKpcD1i4mI1NgiJ6OnIm
         5eUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264343; x=1781869143;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jVXPrAHp/BWzZQhw02rB+3vghjeNf6PQdvQ4HyaXKb8=;
        b=rnj7g/b7egTjhLkweC/Gs7spklnXdLcOxJ+0wm6WaugDTte/LuwolvQC1Cvqvv2/aG
         3B7p1WA4a2o9WDrHKWurGHJfkly7FsDUXGQxsMLuBrrcDHyVhrG3R6CrfZfNug1Os5Ap
         Ycc7zR+nxg3RLJvF6/g/S8mXssgbYuizn3i7X5W8HXKZ8gaun8IS2og0KOuZmy4b4SfY
         c9oAal7xxN1rOUuZlYe1p2pF4alljCg7qFTrqAy0oZiDlHaKTTFlkT2ch8PfeWQsEKrr
         uDQ1rwoTdy8h/oylmgA+SnMGUUyeW2MMiOlF3/dqLqaXgWZroCm8CUWx8H2QSPpLwm6+
         7pUQ==
X-Forwarded-Encrypted: i=1; AFNElJ+43yyl0JlOPRR7/UyKMzlms4dsAzmUlAo92h+Q11/Va4U2YBGaL141zcFc/2PF+DA+LWBWN0xgwg==@kvack.org
X-Gm-Message-State: AOJu0YzyPCzOjeLfXIPwXkLi78CMUgvzhn1XjsG4hAl/ZbpC20OqvgZD
	gL0G5rivl3f7D9PVQNs8QhhJDIA7Uxs2ca30+6kk0uP/1hCDWgqia+uBzwwKBC5Q5agabZ1dC9p
	C8XJO
X-Gm-Gg: Acq92OH/ATNmd/Pe6T4vjWR4XP1c+P3tOLIr+3ydKngboHwTtR3AlvvVhy9uPDlfdZA
	ozHIAvhbTuax3yZQKb6lRR7fdAmU9dI+yNuHhGsGkEzZiD7rWAylKH97kDFKlYKJjjqwf+kva6H
	nWuuOnlnNzxUXS6xhZ2ikp3iq2xAFEuXUpHJkhShLGlRx9tmYTSvYzGruspNQ+sDLuVLo3y3jhU
	VVy54MnCcBI0ID2DhPocw0qsjnnjbEM8wRETZizfE69jPeh7SDfYYj7oNA6aIjHn90EdQUyIAci
	a7lmbXtQzWOR9XBpYzAu1GCeAqMgoC/wz+q2X450+xbIcbW7ZsceOpypiFOt7MAt6rps0R0DSwF
	ZMfKtUuBltZLpMfNp+QrTtAd7ky9ZzvsWJDIvI8XM0iAANhWjq9dBSzWTX746nLWfuXfVK08ORd
	338vxhY3f95AE7DsbzlzhmW64eFK7XyF7/YXea0iyXy7kj9E0N+BzJddJJz6RjSTvYVtz+4oo=
X-Received: by 2002:a05:620a:7e2:b0:915:9931:3a3e with SMTP id af79cd13be357-91619f0170dmr269313085a.27.1781264342749;
        Fri, 12 Jun 2026 04:39:02 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a073548sm182029585a.46.2026.06.12.04.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:39:02 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
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
In-Reply-To: <20260522202410.3104264-3-dmatlack@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-3-dmatlack@google.com>
Date: Fri, 12 Jun 2026 11:38:56 +0000
Message-Id: <178126433616.1046400.532221910811070690.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=SX18arNH/qTxpgMw9xFDkGTsTcvB1jVfOazjLslA7NI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqK+/U8DWh12WkUIvLfnzgjF1Th+7JSF+r0l0bC
 ujbcT2VfT+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaivv1AAKCRC7dyhM23N6
 3vNZD/0XZYuESCSVn19lFpaRZQiMEVxnc34vt0lwHhNqw9psTA8JmMZy5/0xcACkCF6DDLvnBIb
 rPj7XNZFS2EWttEzuKEWmy1wSAzAN+xBV8sv3ggddpviYBAOEYw2v2gNMD2W0nkZvmJxMEYROTz
 bd4Mk82xVHxraSEw4zTpmZiYjjTQXXWvUdUothtsU70yKAR9q7dlxiZHKm8xNM8hKggyyM09vZ6
 AjZN6fA8YA8oHuHgoc4Df3aeZLh91hm9lCKoC3R0kISiHmo96sILH7Pezp+wCiIJNib4pOK5Nwt
 Tm+wJRfpBQeRJzpD4M9wva96f+p9RJUfjfsy4L9CLjgD8KqF1dCLwjlgsh0KGjutoOOlUxHFWMs
 9wd1nVjmbaTJuk4JJF0s9e+17XKlD98vGhPSYUwaZXSXC3KRhxU9tZkUpBkPNiVKzWEBcVZCcQh
 hFVrmlTqixTLle2wMo9MpJIngoeniVvSZpmvnTUXaBGvP4pKuF/jDQTK16DI0vEe9WA6tIBqiK4
 6ZlYtNJipb/KJg7a9YHxB1jSCaO2lSsBPzs7pzkUruWpddbrUjeCGn27IflPmg5p3xf8yv6AWZ8
 R7zHIuQkdX1emMkBhhYohsL03LMG+Xk5QwOCWbAAUqTUXNyMwhtGdfvUgn8ntjx2PLYs02/yNJG
 Pf1CsA12jXbPL8g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0AD81A0009
X-Stat-Signature: w4dszbaabaoqagia3o4rwh7ktm9pttd6
X-HE-Tag: 1781264343-938206
X-HE-Meta: U2FsdGVkX1/5gKM2AK0FbIZH2Z8VVLcVwpf2udPkNZ5OTmRYHPAAQcGbA4UzXkiXNpEBM7nwcT1bH1EhVOjB3BNV8g5c12V+6+EUCnMKR2dVmfY7ZY90g7uGaivGWFQfYP5x24o41yP2k6KOY3dTZjSCd9BFxY8GSGK9mONP1nHrp3jihh9z2fzNF5cYyQTF92U4UzHm5Zg/ZYcby4j/gy0GyJTNdGSj04wTPvlP5/R3q6PrutrfN4xYEVH7hnQah7FPUriif5+cvocspbVWdHGghzcdH+Ur46Cv8nCM5VBRSRUuevll1h+in6UOwSBxDCV5wK800ubp1SFKNNwq/uYt+p97o8urTfP7ET0ZP91mjYG9ZsY2Bw9K/XleaFj0YGMPnS8JpKWj0aLtM2SjsSKC7WdvYr1t6WUIh46kcJXUA1T0jEX40m/YiFZd/VrF3Xty6qEp6gd7ksYVyTuajCVaaTrB3ips93rZVrIxHFyPgZgzkOHrWP/Zuj04Fz+I3kJjyRl4l0CPzxQCq0vTC2R2N0sodJyGU/pyqNYECdhLDGKDbsVoMWK3Q6noJmBtgGDerfyVrBWyuYcjTivLLRyEG/cnORx5CojcLD4aL0FqYtKZ7rp7Kily9DzXLTSo1q/fEEtphWOTyJCmBU0has1c6jbb25LJxwNaYT3JjgqaL8msgiR3ITCHW3oPpy/uAvA94nyjyR6tIVLUplwvQY7Pdy7GcWwABfYdVsD3rVgr5oQj4f+Ub+nCbkHbHFBjPArdn1St60doDjVj9peR0sH4z4UHvbCWUfHSKCCGqj9z2CXNPEBwEWFkDoeEIZ01RvFBkOZG3XpqscjqGyD1YGQiUixnipX+rpuIsaed1TbRImhLmkWTdfptsIKPdB4hzNYzWxOrp/NXpzHSHzUbQmVu9oEPHnNiOcMY0eMzOUe6b2R20k26W3+Hftd/bP+TlekrU83oU+XhP8DiiLy
 WfaynLBo
 qmbr0URUuEgAQPWj4OlslAv22dR30KzVeq4zx7WhLSpqgH7kJz0WPndFOWKvNgmRJozYgIb5Ep7nuc5wn0mPRDgB5G/NRc7pH8q9ilYCtn/zHxFOhHE+SVz7TK+iAItPh4SivTYOYrkkBpZ4l6PQ+iT3ndiqFY9K549hxejrdRdTnvHJyq7PU/gYFpADbti3PkS/wWxHGxjaAX3utqUqTU38tSdq5JtnCgoxTKhVrsFYcWxNOOe5GNbwNm0Hj29AM9zfBIBB5D2jGMePkHFWzA4eJXaZ1+d0VCkLlb3C0dpUBL/+6GUtpNsdYjV5DIw09Cuh0obrqVFeDYLrvUJJrPkqV5zcQtdripfGe0Z2gmz6u9Rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 20:24:00 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 737e7b9366db..065d5af822f7 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -115,6 +150,138 @@ static struct liveupdate_flb pci_liveupdate_flb = {
> [ ... skip 59 lines ... ]
> +		dev_ser->bdf = pci_dev_id(dev);
> +		dev_ser->refcount = 1;
> +
> +		dev->liveupdate.outgoing = dev_ser;
> +		return 0;
> +	}

This loop is compatible with KHO block iterators, as mentioned in the 
previous email. It should be straightforward to convert to them.

>
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index 6ebcf817fff4..85def616703d 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -23,19 +23,22 @@
> [ ... skip 16 lines ... ]
>   */
>  struct pci_dev_ser {
>  	u32 domain;
>  	u16 bdf;
> -	u16 padding;
> +	u16 refcount;

Just add refcount to the previous patch, to reduce changes to your own 
code.

Otherwise looks good

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

