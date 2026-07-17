Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA49C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 23:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06816B009B; Fri, 17 Jul 2026 19:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE936B00EB; Fri, 17 Jul 2026 19:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4D16B00EC; Fri, 17 Jul 2026 19:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD7DD6B009B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:30:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A3AE1602F4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:30:43 +0000 (UTC)
X-FDA: 84999865566.27.C0F7DA0
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DF5DA000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:30:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Te3JCDOx;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784331041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEzgM2Gr2GnhjRTo4YiC2+4P5iEfgV4/tsxVcY/iHLk=;
	b=B+RXGqvXUHU5jhZYJla/6v0snNeO3BGtu9EBH8F3BgzM62/r5tBlU1i68G2Gsi4bQejLsh
	/BLJb+YXTlyb8lIHGR311lov3pz0SJ5RYgD9oxkUXjPAFBLZ0RURiJsgvtfUxd6LwdTK7w
	fGF+7sr5u91Kxtbnu2MxpSU3pkekptM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Te3JCDOx;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784331041;
	b=EfoFFaT4hxuFMHqS0P7V4ZR0y4twkC7/OwfzwjwlewKjK9EuprnDWbe/ZjyJoBpa9CxUzy
	67jJxl4MfgbBra/DXTY4B363ppPpzm3FMEpTWy+VpGNPiz4SJU71kHYonFhWmpQGjlptZU
	4blO73D/BtCcV0tksstqeQJRxVEtbMw=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f186025973so90644036d6.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784331040; x=1784935840; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PEzgM2Gr2GnhjRTo4YiC2+4P5iEfgV4/tsxVcY/iHLk=;
        b=Te3JCDOxQvmMHqtO8z2BCMC1Adu7A3epl48DoVRy2ckmAWoYXs+FmV+gAuUcshMF5N
         DMPyxEHWSRFneatU1vuGjAjeiPS92RooWNl4Ahtg075l8uPLgvDFmMQWNAfvPxkDhZZl
         GAFPLOgRJ01kMf2JF1jZiHNIfaBLfBqN6b/P95ldXLz+BWScgjLsGltkaC+RF1zdLjhn
         KLD0vtElsmG3PJLsmyTedfYJJivrJLq6wd1NdkuPBOiZl5xpF6Sz1S6DrtDrd0VuZG4x
         jinX7vxot+FpGMBOdEq03rAe8bKLuNckHHpVInHx67klLsPjzPTrzFnOxqHAxeYC2VEN
         FtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784331040; x=1784935840;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PEzgM2Gr2GnhjRTo4YiC2+4P5iEfgV4/tsxVcY/iHLk=;
        b=Yj7Ax2kwKsuX1Pu4tEDPxCLyXFZo71sKKhILlqWO5QxGr5zagIA8r7t2YcLdwQ3ybv
         JBDcIT95tqlyAxxtXUBdbWVcldzrpJCKr/fn8TdTLLznYYxRRWWga0EwE2qkbp64gbr+
         QQCaEt/4gL7RqG1lIvvuJ/tvyNpbPvP00rq0JSTjAN8g5L0Wbzu1EO/uf8aVBtCd2UgP
         yqta8BSvcxjdUKOLHjeDhH2WQeSWG93iACxtTI+EXSQYW6wZrgTNSZKeeg2DKQDmS6Fn
         uuV+F2kigIEnBQg/vFoqO2PH2HcydTAryw3JFq6+hO26WR/ah+7UzwSQ9x6eRRUzTcjd
         9uBw==
X-Forwarded-Encrypted: i=1; AHgh+RrgKPMxgKGoO26T2JyFJGz9lUJS3vtoKwUz6l8JhLjCgpedZN5U+tBp+yMv++blLg3wfOIoo17+2A==@kvack.org
X-Gm-Message-State: AOJu0Yy8O6ARKryN31fIwLv1M4URIF1leOmMXXH9My7Ci9vnsDdbxmM0
	iCKbfpRQdMQ+Aqvz0gqliC8pc6i613it1Jon1iIG3DuE9LmMsvkq2qGP9J4j/r0L1RY=
X-Gm-Gg: AfdE7cmHY3NIKytgozwJPuJ/1X4cVF708US1OwjUzGNusE+SPBLk2vJmZ8JQZEvr1by
	LkvO7ZmoYvLarF9af6NTCWXOQJ3HgvnDPozExKuPpDItrvcv+jme9mD9j6UOBAxSJK+81VrQhWE
	c6i7FluR/3yfxaw+oWPmyNRdsMvQXMYCUFA4rwvpdQtLh/XJKIusstA3vp1QfJnJE9hSTb1vcPn
	89n0eQ9IbzABbMlnTQZoRTGfDrQj9OoShT+Tz5XWlSnRZw/ZLUEyn0khvPWQHWSNPVxtYVI5VNL
	fhP19Vgj54KYBJSfFxHLCl8Cg+hFnWs4FxBElqGjFLJjlOQyQOfGDu+DhamVCUgF+5LnMgZ2BQ9
	y++dJ00vKDV/CwOibdthd/+OEsA5O9GMMNK/oJ17B9HUC6nfd8kQ0cQcA8FGp5j1s0Y4wwkZnr1
	p8SUOhNxT7Va1mL1y6Re8A63oiUeowXdGCEf60ySII1Ef5upenUg==
X-Received: by 2002:a05:6214:4807:b0:8e9:f5de:d619 with SMTP id 6a1803df08f44-907784da90fmr56797966d6.56.1784331040363;
        Fri, 17 Jul 2026 16:30:40 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9077871f766sm28579206d6.46.2026.07.17.16.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:30:39 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 10/12] PCI: liveupdate: Freeze preservation status
 during shutdown
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
In-Reply-To: <20260710212616.1351130-11-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-11-dmatlack@google.com>
Date: Fri, 17 Jul 2026 23:30:37 +0000
Message-Id: <178433103736.189683.14104484157018816623.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=678;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=cwll5ojRGw0w+GA5kxbSjj8gBXVrPV2vP/bR+u3qu5k=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWrseW7SPwOTtm1kzcWpOdZF2Wwm/mTro1PbnO
 BhI22jAjkGJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalq7HgAKCRC7dyhM23N6
 3iBJD/wJ+nRxR75OuWW3wtpYMQDKol4uxhjUSJYUOuyvweRovjjuACyx9p6/PrONMDh1yR3KCBd
 XKIIq4cIDra0zdFAnB70v+teL+vUXwgXL4FsjqfeMNQ8RDk6BuWEogaq9ED/vIKwmxiIuZ9Idel
 XXiHuXwwUCZZVKAJPpJ5JHzLLjUAH/Eii8tu6ckH1GUH2ePTX/r1nnhchIWg4HGnouD8HC7tVME
 K0whSSIfgfycSAHtG5cYny6ngWHUdXYOI2Q3a97FmnB+RKa4g9Ag+Llm6iMKYom4/9o2j9qUZ11
 d0WDFsVH9gW3GqSqnetsBL5L/c7OnEl/RIqGUM0zlYiUb727YtIfoXn9DpV6Z8+yNtrOm9iPgS5
 Ie6dckeuYoLHiVGduirWtSb250rhL9ozPyICTcqrg1woQo+jDQN++SUWm468PrJgf9qtar65lrs
 RQfzXAbY+3/3hrHs2GRzm7GMouU5Txb/7bvq5xX/5eX1vUtgr3A3WPkrfJke6e3Ik7ku9IObEJY
 NWG7xDzQqedcXzxVUkEpCq6BuJbQNJho9WV2Mj4Wlq0Zo2Wp/VywDc3HycJz3PTw83AIiyHw0s3
 qdw0MrqzDnG/Dyk4El1d7ow5KVN/N+v7DmdRb7U8qmLDILyi/hHxAefi4xjmVoU0+trUeBFOWHH
 2SrfN1XBYQ3BnJw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: q8kjd3rdhbokqwjb3d85c7wz4qks8dab
X-Rspamd-Queue-Id: 2DF5DA000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784331041-99577
X-HE-Meta: U2FsdGVkX1+QATERZk8w8lm65pglxw8dG7e+BbA3axqLsllYRmo9n7LePuvOPwUBYHysoiHZ09GzeB0Wcw3uJVRzkH2JZkYCqjIht4ZjBw2rIZdqDL7/FBsQRoMSWebT2oE5ScLFjtNVP/ErEvCBwBrNVjoN3Rws+y6pBxEskV8B3u1RuB/JEh6Fq1xzuOKvoticfoEnwDi+QGZlnVy5/Fs6oXWxJt5ydgEM3SXN6GirWtIgEMZKLvPmF1nHsAVt4AcLdL/xfkadM7iBo6O5HODBAiZyR89n7YK6sy7FL4pq9LHPrsU03SvwhrBFOu7YTkSyJmKON/KheS9GaPoh/ciUwxqespcaKDNsnktDBTLgtk5Vrb9LRqOf19Upuit/UIsAPP1y1qMvgL4I+5PcP9c3yqzNhMnVss7I5RYsXRNK5vJvkcCivUXY/XCX5Ck785jwqi19O9EbnMY65aEtx7QQcK3b39HKDEDpI+UtzrxvuLhBjmLLdgzYMny2dUEFEJhfzvI4TpZRVgXYZixMM48+13jEPqabGYo0JEQU5Ch93f8adyb0mGvqLr90p2aoEc3cbxLMp1nxoHKqb2nV3n/fZ28tGUMuwN0aYy5L/z8+P4Ox+GTHN8n5t9iBG4G57bWEvD3Gx+VXIMaEz0L2QAfd/kYCfzQelTbF86PxhGCD5XpWjpV9hhIP8HGwV9cu51F++XFVMr+KTFhOGPGVdMEZ9sBODTKvd0gLKavyV+ABuovf3OpktxXuzDWI+2bd/W+32BPTTtvWPM77E4tGY/IZ6r0pTHqp8p41nL72fJD+MyUigpABwuxULmQ4EibpUI7FgX92fZ7XxExUpVxrvOhhUYzekFKmTUqPsctgMxGSliD8uKP57w1y5YmYKQBai5lJlCRh540ycV4jAEch1ByMmTxDf9AlgGvBaEgkp6avejTPigvllBb/PqInM00rwaoKsUlnI9P9qMa7wLy
 jCzG9vyg
 c6bbXsa8c6eWplw+5juuFDrHYwxUmdod6i5ECmMsg9Gyg6HNb2ebngtNw+ZSS4ZUMaDDjQKa9l4iqYE3Pv+xuPB61sAzPY1bIeupXGxIMH2RdLATzp1rM9LdlZaKP/1GUkdPXF9Sc3+aNVULRhmrDGsos4XuYx09KtZzJY6aYv2PETUIg8g3FYpXXszlcRXKlNivw1wS6eS7tNIzMCJEBb4rbBYO5dml7F16LFIV46iVIqBZAHoLXwN3Tub1227mdV5xPfUP12E/kV05Jd/GkTJ0MzeZTz0lS3RO/Oo4jACoTBZaTWmrw6QBpUoFFzByacUz9fjJohIKi5kOISqND22rSaUiKE600UZQcNH4EVmwSi0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:13 +0000, David Matlack <dmatlack@google.com> wrote:
> Freeze a device's outgoing preservation status (preserved or not
> preserved) during shutdown. This enables the PCI core and drivers to
> safely make decisions based on the device's preservation status during
> shutdown.
> 
> Note that pci_liveupdate_freeze() is triggered by the PCI core rather
> than from drivers participating in Live Update so that all devices can
> have their status frozen (i.e. prevent non-preserved devices from
> getting preserved late).
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

