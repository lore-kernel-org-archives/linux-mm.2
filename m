Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A67C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 23:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FCA6B007B; Fri, 17 Jul 2026 19:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FDB6B00EA; Fri, 17 Jul 2026 19:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67BF6B00EB; Fri, 17 Jul 2026 19:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB37D6B00E9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:29:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3205FA0274
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:29:53 +0000 (UTC)
X-FDA: 84999863466.04.27B25A0
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 273F0A000E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:29:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LCDMQFuX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784330991;
	b=Bw7aC8LMU4bdlFGRf1Z4WVzA8pTY+xH2CQn7rPRTfcXmnFAqs6Hp5iF8A+mt8EK7AV+x/K
	8XzxF1V+aPSzbaz2WqJFvjjYMq1XK3v9QkTK5slX7boGI5LPxv5ikF2DKOKbey99XM+FoA
	VObYrko9m7AFHWV7D8CgPGZ2kF/K1Aw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LCDMQFuX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784330991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uFYFSRoCsiTT7zcdwujRzQUpLdsx92sk9iYHDH24xs=;
	b=KJPmiMvRmsikL20BBGDuaHyr1hG/IWnbrepacNf9r6fpyRysbqix5AmH7syvvQsTyyppi5
	W8VX/vytXZalBiWdadpBDlq3Db1hsb0DJ5dBIhpVfy4LAGdP/y/eRDTyl7wH0M2THmU20Y
	7aHQz+QJ6XMeMBhu1WCLkU66ZdH6g/4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f29ec73064so78743436d6.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784330990; x=1784935790; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1uFYFSRoCsiTT7zcdwujRzQUpLdsx92sk9iYHDH24xs=;
        b=LCDMQFuXip1V27dFeZewEME0mvVG7azWvb/IL+0QHH0eBC5iT+2UrP30f8XjFeUFs+
         G75z+HXDCso0qAD4oaUEq5CkH0tjlp2VTB7GgUNkpkRZxZ7ysmcR2q4T61nvrNPNT+Fo
         h8CUfJ/M5aoz+BQzxOoOibzGjr9oYYpqZxtfrngoSoA0QRMyk4KPCFmCqhrcbnoiIEbX
         UW6T1loYaBlSWopyHFt8gAT4U+27YBb789bislltG4SRH+gSJEvRVpQHQMb1kk/ngVVq
         /Xmp1iRpHUW6jQwAFMqgv+C8erYe721KgYfWvneOB/ZJFG9+IFjeE+zJSvdfiE/f+FLa
         SP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784330990; x=1784935790;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uFYFSRoCsiTT7zcdwujRzQUpLdsx92sk9iYHDH24xs=;
        b=crJpUpKDeZS9lLk0NnwLZDL7+sO5ICJkfNRkBmMbscaP6FviwNWgrWtnaGHP2+fYoH
         pP8JqnBZG3IbB5FHzXJ4eal+yV92r/kofF1eBW2Vga+K7EFtbPhE6kdXllG5yhxSzQpA
         yEPzun6Gbsxfg7iop338Hgtx/dwlNmfAQb5T0d92VSINv+6oxMLSnNhO3n8kJlU6j2py
         kYkA0mffm5sFLF48RyvJZqS45+PY8+RIUvHXJZGj9vz7D9ngikA5SI+w3TGnr0ETXpE3
         O1TwuPaAZy2Oh3avuV4NGVS8HiSk4NYIpmHKe9iau7pvksJMq+xwfhvlxPWL7aWy8rrz
         Iucg==
X-Forwarded-Encrypted: i=1; AHgh+Rrja7O1xOID4APdgHSCYaAwCfGfrQYbiUIO7OAvXoIGZuiwjnpf2kFknWNfjuJp2CHUROU1NJOZFg==@kvack.org
X-Gm-Message-State: AOJu0YwmPnvBA4tEi7H0Jcfa0Zps/eYi2dbSR9XUSmq/GsYVEn9JGPGA
	wnfDE8UGBAS1OI9RANQeTLo4T4Ih9Z2owTu5VXbmLjvLYXTSC6yVmKca0Nmjwab+Hxs=
X-Gm-Gg: AfdE7cmo8tJkNLD4YYfaha9r/BNHXj2ZK0XkaTspo426FKyU+1XeR6rQwzpf/8H2rUI
	OQ4O+ouJaJXoyoOeiwZp7KpXG44j2qLin+0X1COU4mx3AW5J9X9t6MehYq0A9A0J8cjUffLlcVn
	cGfnL7fN498D+yIazFgbGpWyFBKkqlInmuVvaCnLzz2WuveQbSIe2WtEMcSmfHZ5AEMQgl1EP5T
	aCf7Xtxe63h+NxF7gmKQlx4FY0jPY7hZ0beRHBIs28+SOkVgnI/mIVU7dVZ9ypc5pOykGODRwWC
	voxiFCk+zxtUHd3/t8cn+k3T/d/dylZQExDuapU81bR8TPmftUYBt37Yl1GdbDwjYOVDAgB46FA
	IxNJAfuNZ89CKpN7qk2Z7W02miJcW7cjAQ2vyzr33vPSH2VQhNCBO10+Pq6L4Onoe5gE5XU0uCe
	LCBxO/zGlIolyZiqTRPO4JP1NoPVD+kC8uuI0NSNbMwaYXQmtcvw==
X-Received: by 2002:a05:6214:5c49:b0:8fb:81c5:7997 with SMTP id 6a1803df08f44-9077850e2c1mr54008216d6.31.1784330990189;
        Fri, 17 Jul 2026 16:29:50 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907787298b9sm28260406d6.48.2026.07.17.16.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:29:49 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding
 Enable on preserved bridges
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
In-Reply-To: <20260710212616.1351130-10-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-10-dmatlack@google.com>
Date: Fri, 17 Jul 2026 23:29:45 +0000
Message-Id: <178433098576.189683.2364970585754668266.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=888;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=6J2VFoOheObNIbZ6/cGmHoej1PdGKGdAP4cvYQKgG9k=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWrrshWLAQfvPS4hCFjntJqjX0KdHUleGb+svS
 eNoqDsCDGKJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalq67AAKCRC7dyhM23N6
 3n6BD/93+EXV7xpXf2NVyjjavXthNzeAZsOjnEaI/9CTjGZpZezuLCaFWFkZbkDaJEae3J38p4g
 juh65pYyMlwdowYBLYitqy4Ier6vbyyxoTsXaj3h/5m7FYus2rP1L70rvxqIWUKVDa7ae4mcHP8
 jx4t1Y7WnDY7cDIIBbDBOVWz/TUe4B/nhCyh923/V+f3mvMwSMrkjpeg0snqGfcXX1/MgSHzSXx
 JxlP4a0WAMxKCYZJErzZ2J4BDcRpMPVf0Wogx/PmJlJ44HAR0obpH/l7e/l8mlIfJyTBnC0BOcd
 CRxdwB4gQwt8tYXq6ojekcZQGo5tkLGjVU/FRP9nzKbGUoIwwajPcQw2k9Wy0QrUHOHr0YepxNa
 PDOxIex+hWFFkDdyz0K+A6aSa1S8Wbkc78gHQcx++rNOheuVA4I1tNb2mW0+CmOfdK2W+Xq7qzU
 8H4RB21Ijq3rJnHjvcfH9Y7rNyN0XbXdraIJKmVcg3iQiykYkN033FyDlHK3Xxs7+VkXpfehQU7
 HVwPoEC6LyiXUZuPvqNPlP9IBcUFEKJtHRGZQvO84eyZvv0IyG2a4olE3gptNO3xeHXM5rLoij7
 +UQOk3YJ0MWvmomRHmA6P0cgqW7ejMNyEJU2GfTch92NagNbGdNLnxWPd3YVdcov/hPE9GI6NTE
 y4FR9mOBy865agA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 273F0A000E
X-Rspam-User: 
X-Stat-Signature: b8gftne6rftzpu9xeoc953jd5qhu1ney
X-Rspamd-Server: rspam03
X-HE-Tag: 1784330991-92588
X-HE-Meta: U2FsdGVkX180JXDOMvwyYk4eB23LzwFHB1z9cukFAOxhndwvlASOk53Ro75Lkjj6U1XWo8Fy7NMBiNYLzcNnq5g9ITtzq+lEAqutJIabUxhZ1dMRzE3RiuU/GjPnFl6hB+sgGb8rsmnY8LgWEg2ZgCoLhI+7y5JAt5SMjoeYMYWD0B7J7WcpKLH5ATOe4OoKwsfAY6IYAgpU5BtpmIfssNvUShm1RcElwYh52RG4DK3dbNdR8wUVacXYbAyQBgCCU2aiHWbyTeGNzDmuX1JZd0P1MAuXrnb0bbGGKCZy1YljKfBsaSVzLqBZvFpU/tkR8hezAB3at6IJXFAWviMomfzdW1XaC4LBqpXdC+e1IuqF+twSnT9hQyuN+TtEo7RmpM8yIVQ3GqYC+PhME0lQCTmjEPA/McUAuQzHkYXSe2n+s+vBTxWSit8x+pZFCP8rJ/2Nu7OybnSgTVOf+EowmRfEiFlyZJzJHVRE+pEFIAJgD0lo2aPtYaGItRgubS9jA1ITcKy/QrxR76g/Uqn3p++74LONRFc4+YIqdbEv30oi20L1Sypg7fOlIkoYSPCx/lmyt1iaP6PHnYNYlyU4TmEIPuHYF0fCJXDNHhH5VMv/Ro6A0od1OlYvzCgsoaillFwHAZTrry9Sny/0PdpdPueWR8hU4MKJbn31HkXCHUyA8u3EgSM/PsJ8LnC69DuBTYgmL3zdU3RzdQY6Lql0aKOPaZUu9oES69wKs0Y4x8KrPPEABnPI4Qx3MTMq4FiCBZm/iSeEaEXKl8PdYbc0sur+d1M360ifxWl+4MVhGb3vxJu4QbFJZZjGLTmq2Ec0Y0vV8MqtHmT7TX54A0TAg1NQJQSl5jCIyF+YmYnKkpdnril3J0Y9MLry/rGu77GRET22LHYkNf1zVsc23S4/CH9YMgNWarxtujVsA7NYdFhPivwhg2aZRSSwzPI8rQB8npZOuTAOV7DhyiM5+8L
 Q1jQz5Au
 hgO+wJe8cB5uRUy82Bskhxeas4MCUxZ2usPTDSEkdOdDBd+Hh3CXXe1sIhEJk1xN1JbDYUo4NoL4ZalSiJWBJddY5J/SS/XdO+1EKvToARY9V9+7Uiviao8VzoUTs/i9LlukKK5J4UwRahXtUK9KQM3IgvPXWdtrXCwMr4V9mgFfBuuk36FiEsysjVVHSH+3cNmlGrVR0SC6K/3fd3VjtEGRodWMFZJcgSrcnK6DB/ZtfRhP1IBEgCze5Tw/rQf4sLfSho41cpc+bmFlxPXaN5lL9XiwS8R1YMtB966m7ijMIneODrsvCfFlvPWPIn3i2y/Fl7CheoPwENx+fiEFWeovekk0Zo9fAl/d96Yqtl+ylyNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:12 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a95bfe5eff77..74a11e520f0d 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -816,6 +820,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> +{
> +	u16 val;
> +
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->liveupdate.incoming)
> +		return -EINVAL;
> +
> +	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> +	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);

unsigned int    ari_enabled:1;

Sashiko asks a valid question, what protects other bits in this word 
during modication?  At a very list a comment is needed.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

