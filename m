Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653F8CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 03:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04E78E0005; Mon, 29 Sep 2025 23:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4E58E0002; Mon, 29 Sep 2025 23:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A40F8E0005; Mon, 29 Sep 2025 23:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83FA48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:36:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 385AF11A64B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:36:18 +0000 (UTC)
X-FDA: 83944503636.17.6A3FD02
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59B1A140004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:36:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JCfq2SRy;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759203376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjiYVGjZFyMf+GLlKI5w1Gzz8xtYWF9Svq39Im8NiVQ=;
	b=uEpRW12GIjIwNhglsYXfDmeAe9iRwKn46WW2mfhW4kmUA9DOT/EJs0S7b1G9AXpfYFS/XR
	N76cGdouRvRkW9GyMOI6isIqf5TtOfXG9d7v5aisMpO93vwmPiCDJd8FbCxXTG3D6VgZhc
	DJuSBTtEkOI1A43h+uGRE/BQ30f/UBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759203376; a=rsa-sha256;
	cv=none;
	b=c5JIIfi1S71sbQI40py4cljB9gFhYJin8MdsSyqMoz6+TnMAz3T8MEVOpHhRqWWh36mTwr
	ceJ4lWYREjT5eodcMwMQk5KHHK912gtE8H5pjFbTbM4JFYWJzN7G6eirve3mzL/RBF/38w
	cXlpfHDDzHF8cpet7sqWAhodZL5WJS8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JCfq2SRy;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b55197907d1so4096306a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759203374; x=1759808174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjiYVGjZFyMf+GLlKI5w1Gzz8xtYWF9Svq39Im8NiVQ=;
        b=JCfq2SRym/KPSsnaRa+gEkX1HwwPi909ATVB3sf8z9cOEVREzawHs4Bd8qfEXkRTO/
         tsFZNFBHszd/QCWRDI5crhP04AldpnTtr55joJNo6rpY3JyVwWpDjVHbtBBZWqI0olAH
         KpgX+K0TuibWqtZJtSxIcBwZcstUzIoOkh0r01T41nad0umcBZW0q4jI90BUhxk7LOrt
         6kkycHgAdgaTSOh0TLduwry1dc4pqvK9O4gpdwUwCoAiZ44wtEk3U578W4Ixj9nJbjt7
         5iNS/ZgsS09DFtPL/wL33MyMHCeTxm7FVSSBNnPdkV5ejwVH13MLSuVruspyyQNEQJTM
         R33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759203374; x=1759808174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjiYVGjZFyMf+GLlKI5w1Gzz8xtYWF9Svq39Im8NiVQ=;
        b=DLQgWopnf/X4a7rAqk1Fwu+yxP4OUwn/lHEGvoKwdYXEe/gvgs5J/oN+mEzcx6kUCr
         h0JCLwHoxQF2FuiY/yC+pt1t6X7sRbLTesIBgp4AC+sG4BhShCvrcrenj/xTela87Wan
         BEXbcxylx8v6gK04fxAGe6HSBs1VTxM+j5Rj3Ps0kyIaO0/1Z+O2Z/vs2LUo5K5nD1Vi
         6eoGrW24lDt13QZs1d6kCCnxmi6NsUE6Bp5ujVuLN3L5pMEZMqcCznCBbnck7ilUAHB1
         xi12jh3w1LZxOx7B3IGMQubCevc5zWBXqNVT49tmn3BDEXD/bTZ5aIyWMdnM3N3wJHqE
         EA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1Hr+ZueeDcRHFBxgtX/uMov3e5n1/LS+bgbMlTnKyWLwtx07WgnogOzdEOfvtwct3NIPRKZ9N3w==@kvack.org
X-Gm-Message-State: AOJu0Yz9wBVtTII9CaF4pwXJt02TbhUzO0oU09dl2sLhq4YiKfphBHwX
	oHDVKq2K1cnG/jlAGwkw2tu7i+P5YSPMYlJwA9P5GiUt8mTn7riNdTGR9SyuHoFh5K4=
X-Gm-Gg: ASbGncvAj8PbHzpjuDoMArJVB8/0P432m9w//bv3M2sSXCaZk4b2tVo3KKGI73sd91W
	N4zadbyOZauncH0Lnsy5q3dOdacnFT02wWW14Qjtp3zaf4EslNz+Ln0WjDwY67J0aQ6slTRncmL
	TW3JUJMSwrnRXXHzSbYsIRSzL8Jt8YDIAap24gJ7s27WXn3PvAoph9144eEbaguqGwMt64kozL/
	xSHu1JgBr3OoKYoOYmz1phVvXfpXStBavKFqgVbUJDscq6EAVVqMiT6CTG0OkP0XPAKhO1696gC
	KJskDEpFajPVifCgj+GWFcnpbcyhb0yZxoDWYpGwA8EE+Lg3kZPZo562f6IGQD1x3+UNcyblZo1
	rbFGeEZbfuAkCRx/8GNbe730Ops0SpWYEtxHcSdrqkXvpZSACx1mBIh8IzpylE3NBov0nOCxdcT
	AdpJg=
X-Google-Smtp-Source: AGHT+IGtPjrpwn9hzdo72C30kMiytStr6NjN69QK/2wPHkyT9Vh78/jpKFZTb9lpZd599lTG666+0Q==
X-Received: by 2002:a17:902:e945:b0:27e:f018:d2fb with SMTP id d9443c01a7336-27ef018d516mr157247775ad.6.1759203373850;
        Mon, 29 Sep 2025 20:36:13 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28d195d5583sm13846485ad.117.2025.09.29.20.36.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 20:36:13 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org,
	willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Tue, 30 Sep 2025 11:36:06 +0800
Message-ID: <20250930033606.89416-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
References: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ffokzc1mj8ux9rks48rgyd1z1ho1eqhz
X-Rspamd-Queue-Id: 59B1A140004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759203375-186797
X-HE-Meta: U2FsdGVkX19deJQTqSwfky4ZxSpsrkr7B/4f1KCprw3QZNhN7f0viDGlay3drgFMJpxTmNELwQ4EMEt7UsQ90H8ZhhtsjxuExN8ZO/eq5T+aEZqknNBeugYeh0gKL+fcTLPgwIY/e6RP07+xE2rgMcZvlv3xhgHKMzrNMoCoPlNqhDHSTJANjbT1V/wpUQj9srN1Hn0iy9YFauGpBQzvGmF6sC6aN7qdJgGzZjuNPtRzL4PK4W4FQbinhbAGoHj5eRKcW0rW0SIUb1Zd++2e5AZTC4BeR90GPDWA6XQMwd1H6ayRSNYxiHhhgaiPfkJ8BcRAfTEk0shdDH+2cq/KEL1i6F1bJg2feMsd/w1ajGOnxPVH4E8aBCGEVCL0DBqWsNMUmvOaJ+0lniXWsf0AFWQO8M9ZUbqM33RGR8fflmkwT1PsB54/Mp9cEcl4SuiEMRq9xn0NdM5433/lIs11ZTQxrWn0Y95tDJ/Dc7AFjR35UGyZgQ5g63GGbuGdDA0g9ipx/JBL114e1DuC6xDstqxstwq5xsSlO4ykBMkn1tE47Y0KSCM4KFeFLhA3mh+vJIAztB3xnLKM8RhHyCq96bymc0XkKwRNMXChaE/gZ8oU1tOSE0kB5uTh+tiooHxPLvwrnghkuuYsNX430XQRZAVXAch9a/PDiQSM1mjIgmDMNfUc+LSMJ7vbLZPErv2AuOC2UTvaVYDA9cUHQ+ZM/a4kCXUe/JHbiykexBwI80oGbHGV/W1Es4FrB+jkdFe6kh77xUO+dvzx4LTyhx+1o+HwR1djzdGBh1tJHyyIUaHiIZLsr9FSpMafy3DBaxa3Lj1vp7BmvciQAeQDwdiDZPBuG2gmRdIM9kwYJ+My5LU1ycGxrLF9iu8pDKVQZewrsCRIMEy53gHeZjpLRQb3MFB7TxESlS3SP5f+g66OpjhD/1GUr4ffYK0QB90mKEcAiMI3x0Lnr+hRZOr3JL7
 xG/0OinS
 9Qode8N5IyGzrSHJqifLA0u3Nx0//LGDTvAsyrLPaJO87P5rNvgcQFbLLPjxiFuERrwQh0RPEzUcFbtBxTKSIWfU5B6hqiYtWjcqqHb0mM9ReJbUfENxnIsyv9Psz9SHrfhj8q8Hu890aQYchGmfZ0PAhMIA+i8E8KGbZwngb69lsDtYsrztfZ83JQFTLOFY7A2Tn+eG8gWReLN4ZjFvTI5WXiPTWm8oauAE6v7Jsaj1DUK1h85nIixIzU6JQaXRmDdziPXijvoUxfEfu5Jd7BbnQ1s9YzEuHxyKkD269qPmCe2YaUgpKiJ9vZfs9lYQ0ZulFmartPo2kV49jlWw49MjBZ9THi7dWVIuj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000014, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 14:19:33 -0600, alex.williamson@redhat.com wrote:

> > Hi Alex,
> > 
> > I noticed that Willy's series has been merged into the mm-stable
> > branch. Could you please let me know if this vfio optimization
> > series is also ready to be merged?
> 
> I was hoping for a shared branch here, it doesn't seem like a good idea
> to merge mm-stable into my next branch.  My current plan is to send a
> pull request without this series.  If there are no objections we
> could try for a second pull request once mm-stable is merged that would
> include just this series.

That sounds like an excellent plan!

Thanks,
Zhe

