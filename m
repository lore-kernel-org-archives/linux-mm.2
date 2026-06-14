Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28204CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 13:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C206B0005; Sun, 14 Jun 2026 09:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D3C6B008A; Sun, 14 Jun 2026 09:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BB16B008C; Sun, 14 Jun 2026 09:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 234566B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:57:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C430AC2385
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:57:47 +0000 (UTC)
X-FDA: 84878671374.29.2CFBF11
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCA50160007
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:57:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ARU9UBzj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781445465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLWNaUJaCrsl1zSP87x78jJvGSQywThTy/hKOOZov1I=;
	b=5k/STCovKx9S56Nqj4tMrj8vqFrqq7SabAXoOTxC5nEVqNMnRJ4JMdapEKRy4In9Jmv85p
	4bM66y8+FAFxcEAZZ9JyCG8XkbTo6WlwNe/IaDNi39U6ekCnBBucdGtkJA6EIxo6FQonVK
	3DH8HrbX+VVZxQ9IpcAbd6ixHRgle4E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ARU9UBzj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781445465;
	b=uALu1HhIHjq3KBxbsoDodqW5NJGDDyuf1XfeT9S9Gg+8pkcqar/wjo+XidkDxkGEI7I0/d
	TI1izfUm1vWkfuWkKFqbkCffSUM2EP/NORwS3qmrcvPKB7s076J88PRsHOi6XSjnZSuqCC
	dYuUurtF/2H65u+2yBK3TJ+iPNoseS8=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-91587626a3eso289901385a.2
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781445465; x=1782050265; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLWNaUJaCrsl1zSP87x78jJvGSQywThTy/hKOOZov1I=;
        b=ARU9UBzjez2KODFsZgEhOZdBnihLsnO2TVXK/hRk9KgxiKwMLZvmy2PWVm0GODcPYi
         knESoxTBIGGCHhVO6LYykPmYrlMBeUbrHKl7zv5twvsQV0DQfnhYp5cy3g6CvQ9wrQBE
         fMb1W6V7hf3Kc0KchdftNlGsBndkRwpjvd4Mv25UIS5Z5OmZyrjWlLZZ0y7MmvCMsSFK
         xCscCnUG2ET+mw8zXkJBkTWaQFF+aHXq+OjR2iERCNWHTKs577LSBiKzg4fE0haKRJUV
         W3FwqPItGJaMQ4jmOtfLtzHhcJ7cJ92bfH17VV7x97h6Y24Nha/xNrPcc9ND6gxRFnwU
         //wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781445465; x=1782050265;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oLWNaUJaCrsl1zSP87x78jJvGSQywThTy/hKOOZov1I=;
        b=D313eVIAFlQ/QH47qKUewFzP2w0fUpjHtNYKVLQMEOOM+p3jCgwPrENEziBgFMqJvz
         t+8/12M1lwepaPoh1H6/cCMHLHvFAgaFemrldSpiSjPOTjQtUm9KQOkoa63b+uKdd6fC
         D4ehtUyfohoIYUD1T5GdZFuETbPJ+gg+jdKefGU1GjaigFZ5AET1JVNvBoUKAeYa+9S6
         Uo0RHjlBgt9iHXafpWMkwSJf+BCkUqsCKY8UtRPff+w6rEv2cYt7z2JBHL7nmDL+nYIr
         OeX0V7quADYRcWqZ/MX46N2FfYDYMuZ/tA/QH1MUx5pe4GPkMc8S4IjZHkRVL0MLwFsZ
         OTqg==
X-Forwarded-Encrypted: i=1; AFNElJ/oF9tE9M3GVUq029ywYmDMdq30+mC6DsrFk44x2SfGUXK7HTVkRsFePveaS41eZWUlbQoCKILXwg==@kvack.org
X-Gm-Message-State: AOJu0Yx8sJSTWLzDbAAAE8aYgR2YJonAf/hamfyqlrqrBH54w8y7/lZc
	moMnZeYUuV7Ggwumix8k7k1/hnq9WzgrsqywDDHZh0Sj021j7rVV2e6gx8C49czaImU=
X-Gm-Gg: Acq92OF/gT0yE/tFKNP7ZP1ykaaH9cZuGBeJmBSfUJF8I6EFXwRM5DoOwiyD3Sx1D7z
	AgwPnYucfbpxLJu7ZS2iK/zzLREZMmChTEtWXm/42tInVA3FGBmCkYwmOX1Yp5uXiWsjSNDhNqJ
	LC7DJgx4HAHIArzyXDOYdtY9qiNjspChxEkbyaGaKG6+womhfNyvUgE+6qkEilFDEyhcxBvsN2x
	eivtmrM7Cw03/qtAbrxjdyJSl8B9hpWoydv1Cldqx+f7zbYwHpk+xVihG0VCnXy1EUTQrZ0fTbi
	3FYQIGVOua1Qi0j8Cdgakgjsej4rkNhyRRvYZjBojtOCAwfAJJVpzhbqsaTaZ+o+paWpnCoVgI9
	Z+9jOLIED6yC8BxWHkRDj3ypK0HSd9sHQafScZpTKc6GjnzQ8u8HZFz5FrcyxUt5IYNYTROAVfH
	DIu0Fz5qwwX8PvITK9JkJLqWOFEQKea+CKdgN8Q40UZe5qU9k0c/nZhEw1IaLe
X-Received: by 2002:a05:620a:2894:b0:915:cf88:1e3e with SMTP id af79cd13be357-9161bd3bcccmr1479704685a.41.1781445464857;
        Sun, 14 Jun 2026 06:57:44 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619ed7f16sm753609385a.1.2026.06.14.06.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 06:57:44 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
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
In-Reply-To: <20260522202410.3104264-6-dmatlack@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-6-dmatlack@google.com>
Date: Sun, 14 Jun 2026 13:57:40 +0000
Message-Id: <178144546090.1266136.8524338598480624580.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1009;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=irEWipl5ns1PQEI0PQ7c6jRmzsY6W3c0XtAe+hBan18=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqLrNWjYliGNG1cbbcQyjqFHpsESyctol2Ow44V
 DNNc7IHDFWJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCai6zVgAKCRC7dyhM23N6
 3kjiD/sG69As1zhiS1Jh7oTEbv0MuNGQBkOQh5lHVUPS0gj+oBdU0SL1qDkUsD/9tAvcLQXxhY4
 /QEBcSzMRn2+VM2nH5sCYgMn00iu1wLRgHbnApGT8gEYefLC6tqiTimjXxxYEZXpQz9ApF3QtQ7
 uQ7fuxVwij6aGg2dzzTM5o+j0r7I05Zok88+cCVU2rlO6EuoInjgmjv65Xe6oq+Ds1zxZqhOecx
 ot6V9j27xklbNWnMVwGIEJdBHXJhF7LIartFve0H3o0TexujPaYa6bopI9KtSCGp9zJTyA0pQpK
 gNj34151bnveyddJ8hiUhPtMTv79KN5ncUVS5aJfGxPn/aFWbtqxiiOp0eU2mnJqh/6wNrM8cQ/
 NUoxJmWLdWzpvK3xaAUQMjvhqW56TPer7DfuxcsKhmOK0edcg9c8QgScp5vl6gu85NR4OeFHf1B
 kKZPXsYx8Wp75O5nb7T0vLt0ObMjKLsM03C/GOUWMQVcDp44U7NhXWs++LiuSgyzxtbuoRturS1
 ao58aoq9qHw1Gk4BTfu8Cxz4xPVAEIaydrmMgiamFRw3PAZUYr1WUIZUIQbwfaGlWx4ERcVXuLY
 aXr04c4Tx1rxrNZMN32g400K0heMVZ+AZvJQ7vrmDVSnc3QEXEoOT45iZ03sYksa0HWdCPAbLBt
 te2BUIp8i7sqexA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCA50160007
X-Stat-Signature: bcew8dzqas5k6bchu4h34hb8q6rghhs4
X-HE-Tag: 1781445465-596632
X-HE-Meta: U2FsdGVkX1+ik5mZpSAOzxJDKD51KRRePoeii8jiAVOFvEbjLdZjjUOPTj2jqbU3h5bWhBCOPsMFRmSC8Ru4/lOVsQgzSVnC2QxkdlbcDzCtinc8YOOGNV5iMonZRYmeBmlMhWqMQxR7H1UMXHlVLKOdKDirrdujf3ucEXxunaX4n2oviVO8JMgqU05ed0KXjtLE6Zza5RSc6mO4bPgKHI3YMErNw0THFV74WAzjUOzFHXdNEBl7CJFi3RdMyeqIm0jnFsOZ3rFyUrzgiuGaT0B6ujb5BuPTXQTAEL20F6fmDsQSo0csEbkeWOIC3GiUBkT7eke8qoTVeBcW5MK+ucFQ4V33XBjGhHE1s+AyyfIcBsok7p8PWIlSF37YU+H+avv9ObBQOJqdklNSFq6t9OgiW2GPT3JwbBYfg1wlGDTQnOARIaAOZmx6UGUnyTCEZlnalpGuvbYvQXQcMlGfy4Ifk6Uk33ZwjbZtXjqWK/eqvSctrBFE8R86zTWSAUm2dp0IxlIOHSYMCUWtONxQCwO0IyLCNCXmBLWcb6NMSAoLAn/aPbi79or1sOruyGXz89PGEEJy4nr8orHH/5aG5YCnGmomP3Cm8O6wbks58JOpRcaH5oX3GZ2qGV2vDwiL2B8C4fjjnlUJOvqEEL+QSoW94leEKh/7oM1SalF3iVIvMxOhA5VET0cmu0/0zOfpOiViqbbOBxQT6bv0miMYxPSxqG0IyKltPm3+AowJ3vMiLUHR75zaQbCARuEPOrTMiQ83sVuPPUOn4NkM6b/2taKtG1Uzay0ATR7VcIKrGmYGobONafrhFwynPM1llCZez6GbxwxFhGTZ1HF1SjoH34HaeY164f8ICBmcRjgZSJGQfFSF3SUjCu9qpz5cX3vYyeK/4TTtzJD/S7wG37fWvoQD49VcToXARKVNOnJTmKXrDr97/XaOCdRQb1Rx5aZHvjUSOHzrW/tJ4MQaxnv
 fvVDV/k6
 81A0fHT//Gwqd6rSXDTy6w5uC880UyFfnV+IWFdiwVIahKoW1x9hhmOMU/+HHsUUayBlbe5QuevuKk4n3GDmJzlL5AI2aLI3zqg4C05n8UJiHyJeCvBh15oECqBXPDL5dg+wIIgdcijDbwDge5hk3QzUlaqhfW1V44nne4n24jXbNnnyN+KZ5wuOMi3vJnulPxIuu1jK9gklEbrgmDi5QkuX+a3tuFunnlyPBwDAeNCW7E5aed2Clgw0yes822VVc4O+hxBHkiLPMfwz3zjlPXID07fhuGoUphUJtiMZ3HZjeOu7ZILYR4FpVymcUOg0ByJka1lQC7zkRi3NX9CJ3FC0keOMx+30/FRppiK6YXBTElzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 20:24:03 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 4f2ec6ffdd16..2421bc218916 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -103,7 +118,7 @@
>  /**
>   * struct pci_liveupdate_global - Global state for PCI Live Update support
>   * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
> - *         FLBs, and the references to them in struct pci_dev.
> + *         FLBs and references to them in struct pci_dev.

This change does not belong to this patch.

> @@ -396,6 +411,72 @@ static void pci_liveupdate_flb_put_incoming(void)
>  	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
>  }
>  
> +bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
> +				      int pass)

This function requires a header comment; it is public and not self-descriptive.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

