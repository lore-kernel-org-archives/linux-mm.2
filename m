Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2ADC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649FC6B00A3; Fri, 17 Jul 2026 15:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6215D6B00A6; Fri, 17 Jul 2026 15:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537726B00A7; Fri, 17 Jul 2026 15:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219596B00A3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:38:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82E321C00E7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:38:29 +0000 (UTC)
X-FDA: 84999280338.04.5961DD4
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C7E620005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:38:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="GxoMn/nM";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784317107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiZQbs+LeTBUPjzRfycx5zsOc9hplbGiAhbP9kI+IEQ=;
	b=zO9BgZ8aGhrDLdzM8p8rY/EB+/QHhGnWnpopbpVKdSOCI+S5JVgS457NOmLSrR8dVJnBIl
	iINfkPjLvTxzEeSxzF+AkXZHUvGbHhGN71gI4NxieDtFo8XDwNT0WItRlHPE+bYjzJEUo1
	Bw9e76RXEwPVEzyztQwlWgbbGbGXO94=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="GxoMn/nM";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784317107;
	b=7tjJm8P1zr192TJuAx0g/8l06xTobgHJp0n939mAJxebbagq0eBWhpeABxsyZLGUk1Dzeq
	cisOvIkq4iJ8ixP0K4r4SJRElSvdyP0Da4y0amlMy9O0mT03rUidMUPPgIgvsJG1EnlozC
	purQrmpLitjdDijS32Y0AKerlosH4rE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e512a9a6bso461383885a.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784317106; x=1784921906; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RiZQbs+LeTBUPjzRfycx5zsOc9hplbGiAhbP9kI+IEQ=;
        b=GxoMn/nM4VtRr4jsTFn//2OqphmZOgFAeB9MPH8v4XOP54+0EL1k40fon/1gDXQf17
         8gyJwT6D8b7GXDMpFHWXSA5P0XKJocJX4xO2IltWc89/BdZyLVIwSYtc3Y91StGhK+Ve
         xrUyJZ5ykaVzqlbfJH8wPnUF9mgtXP42NeBUb5e/Yl2opURxYbo3YaEv31Hq/tmHP5Bu
         7Dhf/AZ/myHQEXuNSl/ZU4lKx93Vv81wljWjJM96jJZdaYbgX288jlyO+JMI2yfUsYDG
         YIImCv97ARiBlijJix4NDjkIv01Hd/x1OR6JzEM61C7TW+Yn0mizIAXa3RFOT9PjQIAn
         hpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784317106; x=1784921906;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RiZQbs+LeTBUPjzRfycx5zsOc9hplbGiAhbP9kI+IEQ=;
        b=Vdg0hWA0c6AqmMXwuYrUZRFFLeCj89Ofv714ErGiTx70viO6otwUGdei9oowCswbnz
         nRUT89bG0yOR0H8OBk/FvjGPeyjkSzy1Z8NNltqbrEEhCtpEDIYD3qUjRNtXfZP/Y7Mj
         RDFcDWOrlGR4AfnqdlMbInrM5cvPcIGL8ihEQ4V5VypRSDcL5mO6he9f8LJlnctEumny
         JaVHcFHK7RwZ0dbwWmY9Qx6eephSh8kNW6xvKrWWHQnKa0hxIztXac4BcaeWKaOem6zZ
         mYUKjkz2O0+tAIeNRA67H1lmwDouB+dFjQxZE+lhmSs2TwN8LeYHQPxtbZtxdIKNUuHq
         9ABg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1OX+BBYHpiyiSjdZHEC64FW72KrBlQthn4ZfzulVIphLvuf0Qgch1IE9exuM4GZ75PNhxxaZnrw==@kvack.org
X-Gm-Message-State: AOJu0Yw4hpqjDlVbEI0zvi2HmxoqX2JdfKe8OIthKBxcJMhBZVKZqnlk
	GofPN+UEweoiKY0Jw38KZJbB1A7qKPyKt7Jtz72fyfkMAF8eURHbqbw5SO7XwHBNQXk=
X-Gm-Gg: AfdE7cnf39vay5cuGuEmW96ldyHqpGvn3N+Nz5HAUXd/MIL3+WM/VXNpe3PS5zGWXLp
	T4fzScSGsWL8GaRb0nk2sb5mzSfui/MQdurfxQN3z5LLivPmcPT1WM/uWXzeAyhFFPcI0QWG2Kf
	RHhRi9vE0b+30jmXpkq0iUuI07Yc+kadHEGYRa0qwRHwDDLmCEab8yEoykRTT5weFN/KXKZ56dO
	ukAXnDHfUcOSaGc2BUADBksk2oNdFngsYR9SxxunYwUvhWwK0VuJ/tpZBZbvV+qjOiQ8MST4gvq
	HtA9zjbL0R2HBCNXfkzxli6kZehen4XN0f2w4KjUNR4TmiB06vjrB7JsnYnc0MoRlO46ropb7q9
	7mDP0m6GWDABRvMgNfrrFh51F9+YJixEjxfl8zMZKAK60OZXqDWi/GnitEJQ+ogdoYcBLHIPRo9
	ooKq/voz1diMgTTZCXVxhbhRxmRMisk9H1d6PsWAI=
X-Received: by 2002:a05:620a:2319:20b0:92e:c117:5ed1 with SMTP id af79cd13be357-930b431cdc2mr336172685a.81.1784317106546;
        Fri, 17 Jul 2026 12:38:26 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5461ad9sm227825085a.38.2026.07.17.12.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:38:25 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 02/12] PCI: liveupdate: Track outgoing preserved PCI
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
In-Reply-To: <20260710212616.1351130-3-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-3-dmatlack@google.com>
Date: Fri, 17 Jul 2026 19:38:18 +0000
Message-Id: <178431709881.189683.11618075685237566784.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=783;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=jsqG06VtS3z0e6bZDXnLFvK+GuvHlYm90fGXP1i+Rc4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWoSv7CPVSgTbWNsDTFax6B9Q5Aiwar1MuXi8H
 x50paKyCOCJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqErwAKCRC7dyhM23N6
 3vd9D/9LK37IfAvABvCB3smI016O0dV4EVZWcpeNUJPs9CXoBkx1Bef0DMELfdieowtWX/lZleI
 xBJjyEEYD1cTVAp9Zja352m0E+GSJZFaN7w55yvbXEfHV9Wb+1/lx/ltYe85mtIx9n9fwyYlfRI
 cCjhFjcK5JKexzWd59YK+m7BMK3xRXzT6+TR9nVUvVmpnJZbQTfy1g9AtHgNhWDIWuigLUxhLgP
 tQhOMUeQYgJjt5HieCsENdL/zFDDKVpq7YGmYkYBoMq1t3efoa8nwdrIZRvKII9b4HPgkjvk23x
 b+WVxvPZyeeIuWUsI/RvHNH76AcUzjK26tUi90y5PF7JSXQFfsu6n+NJPRXALO/L+bkORobGVLy
 oJHJRNYALyLfmmtP9iaFQQpO2DXd7YAlrUqnOM/GhEnZZ0SFXYFXFT3o5Uy+iwjdSXUsGMH66rz
 F/TkgJk6p9KD0noyJ0goJF1Qor4MRSKBziJCYSxFbmcnjSBiuP71TIuHZ+uFy2qYt4rr7Wz/lIs
 JMCpUM70IwXa7+7E9bW/3jCxbYEKT4aV0r7ZLPGzC0EPMlrHJuwBmS4WaKP5Z6CWIGyr5+Kpgs5
 arq11V5kI8UaDm+rqkudultVgSV24G7f/68wOBq+Vr/HL/P30cLAjMqvZ9B5WdBK3aHWce5vLci
 t8z3cfef0fMXsQw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C7E620005
X-Stat-Signature: uni3nfjrmyyf1my6afy66q681arb5yzg
X-HE-Tag: 1784317107-44090
X-HE-Meta: U2FsdGVkX18CSHn4uIrRsMC4OiyoO4I2mNAAie9kp9RWwY5BARX/FY68UOP7fWTcLo23X8Ffsy+pPWSG0tm18q9fPqCyLrz/h1r8lunuQc9ETw8+3zmHNt2IjSf28Dd17BGIfvaPwlXA0dOjm0s6xWVYUySE2boBImYop4U+0JKEyht+ul/pB2v2gHutpaLtwuiy0TIFI8TIK5j9vIlEperAeAIdNxLquE+pfvCrgOOF7L5ChMIOHuqlCjQ15HiOgnW96WBuCsi+S/Z0u8bboTQE19lYs2afLZrxcA89DHO8uzQBupTBjILCXhJZkI8ME8cbm8QW8bhB1DWI62zghtjsfOc8vS9S7HYeWhLf2ZlX0ee1HuaYM/kD63W5v4G4vmH+ikxLMAza5MBTOLwNC1iGKUwo2LrLN+nMyC746THqhc/YCc4v9qy2d6NZrvFRVYVnlbdE9NqkAF8uM/VsFZTjvCBt6xLGuEeraQG6qLOuQkMyuWJZ5mYJhcI2D6rAUgkeNx+g2swUVIG8bakLKwEkcAKqYY0crjgv+jo6cDNRCTKxCsKyER/4wp5DyHZ1xueggDA87t3gc5exNT8ZDf5imRw8hrOr793T9JZPiWUwRouT0+cgAOO5bEijhXVmD+cY35qN36XTZEYlsZTgmGhUQ+ofpKVHow5NXN168ZxIt13oJ/mQ1Qy0ghQvfUbwS6IZRzgkWfQkfsCVdcBsHfmCOnE6RoKWMBrDE+RBSL5ekYUGWNjaWVXy1sESJTU8ef14cGDHpy6z+P7ME4iz+qAsIa+xcLajPaHRt1nwvK8+0nKVBFpsBq7UJ9PZjRZZHyrfqV61rqOSlei0o0tOm9jI4EQkim2NsaVQOe8/CmrpcZUFR6GBdSMBgWdx0fZJtx3adW47gw3FhWL6VTZdiZm5lF+uMtWmwL0KINnSCexNdn+WFLhEtv8FYvxztLWOr90MTYgNF7FgUXZMcb5
 P7IGOW0w
 GgMeSz0KIltPKhwy9AisskolDHUF/1qZgCWB6xaK7jafcMhHUD1rPtNS9sjOL1LXx/zWoRL2rCfwJ79d1qoJL2ihpLw0+3ojaS3jS7/YDYTwWxfRu3TrQduiddSNz0eBdQbz0E0D9+SH1BxBlYjgvgWLqNM1A2F18N2p2BFjFNWSWSAcp8OEJwDZBmqc15/d6GP5kEDV3rWSvWhQ6AdTVJFRCoj4+kvb/t16mhrynAOxcUaMKydGydLOdzOK5c0hP8SUhIr3fC1tI34Tcop8CKQQKGxSjiqlBF5LFKBB0ueR0Vl+QmkT8EmWOTSOTshwtHFsnOcSzX5ERFdbLwTSDz8A3jDnX0AxNJt+oJnPwTvRW1MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:05 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 899758883dd5..03075ce06ac9 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -125,6 +160,157 @@ static struct liveupdate_flb pci_liveupdate_flb = {
> [ ... skip 18 lines ... ]
> +static struct pci_dev_ser *pci_get_empty_or_append(struct pci_flb_outgoing *outgoing)
> +{
> +	struct pci_dev_ser *dev_ser, *found = NULL;
> +	struct kho_block_set_it it;
> +	int err;
> +	u32 count = 0;

Nit, please move count above err, to follow reverse-christmas-tree order 
for declarations.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

