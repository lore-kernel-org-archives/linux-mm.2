Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA416CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC136B0005; Wed, 10 Jun 2026 12:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B32B6B0088; Wed, 10 Jun 2026 12:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B906B0095; Wed, 10 Jun 2026 12:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAECC6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:43:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59EE5A0211
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:43:41 +0000 (UTC)
X-FDA: 84864574242.21.4CDEEEC
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2B01D4000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:43:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Qdt8hOVK;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781109819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6i02pwHwWBJz0bYCliXn0Muz4Zv1nNp47/hW+WRQ6k=;
	b=ClG8xYDPK96mbhYc4aqzfugKjOsZZoR4sqpMNyZKn1X5F4YRlZrWOpbglnDSDakjgwe5X0
	eatIfzATIn9K2tJ/DD4nqOCvs5L78LegVnPqUHClsfJqMwu2rIdG90voYJJEXkWFIN44wC
	g/NcRXEpyvlcW06jpKX0dvZWsx6PDA0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Qdt8hOVK;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781109819;
	b=kILNjZ2XawxFFiQFp5cee3j4eQl7lFMS+qhdpSnWywGuCUm/2Vdzya1ZaCdhxhM3dkZQcy
	Cq0DqbxqBqpgyXa2gqy05aFKVhz/zW/tUPGSbgayt3JMUE9oJ4imGedjx34lgty/0xuhKw
	us0hgS1WF+vVPWKD00ScNNDq+xsGs2M=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ce9df31840so52881616d6.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781109818; x=1781714618; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E6i02pwHwWBJz0bYCliXn0Muz4Zv1nNp47/hW+WRQ6k=;
        b=Qdt8hOVKsg4iIlxonXsxgqdx4BsAxsDohbFecC7bGkKL6l325zk+QwssoYL3W9hOqG
         0Mi0TluFWA5yqutHU7c17SBdey2ytZqcJq50xDXV9yPN5HKKUVcoZDUqGFtyrmmc56ny
         Ig6rJAuFT5GWLTQUqXinLtC09GxL0uCm/Gi0+sc+VMJ/OZ4U4DhFBTZ3Gs1U4+XaaOE0
         2tO3PpdOYu48WPjrjmZguamgBXU4Tz0RHaMIbqACg3ANw13fyDgTaKXZHNTdnThX8mrG
         7FW3nReybgvese4CnW2LlX7TBLwoFyfXYd43F8MxtvZcX2H/WfxVvFqA+tZFW2wFmAYw
         qpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781109818; x=1781714618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6i02pwHwWBJz0bYCliXn0Muz4Zv1nNp47/hW+WRQ6k=;
        b=aCMOHpIB+2igP86juaA7y0shRbHGpD3QHraQ+jLTY7DQNBY2zZ5x8ytqHDYxbEl3/a
         uaQFEGMH2XTIR2Ys7jPRJNlqLXpzyZCTA7P24tb2gnxqljlfIr/yqVulg05s+OudgRFs
         Yjy9w20kylP5VrA0XIxgWm5GZ4EVWJA2omFUaTRtQiMK2uULlikAdcejTEVpitRgyk1b
         OZwYV39NhO10Teq2olqDSWFZ2PbtfeIeuP1fZ/IztfP1RsgubBDgeGdr8yw4Y34mtXQ/
         ogPK5VHj/0XLGY+vBgmmFt1ikB+6CKJSOY3g7J5xWc+SUYNvCcSKYI65NwC2TBX6t/y2
         U2VQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Ad5o+Hkjfi+O5EQ2941gQfC6XDKOZjUXi8k8O4b+MeX7O9rPsrLI82xmyaIcU+I+Cr3b/ejcv4Q==@kvack.org
X-Gm-Message-State: AOJu0YzW3kxxXiCR2ZikjFINlo7WEe/sNkrMNf593GIRIU/lvUw7AFv/
	ntHOq1xJt+xvjzQj6m5RJlfPVbQ+lLJCeNHkeRoooGwCyVddguhz14gyCrzvH1a/yRs=
X-Gm-Gg: Acq92OE8XGsTfKMwk86OSyEIpDJEBCLA4unN4Iv7kP3yhiz+lI3pYa7Vb5jM0XZP5N8
	QtbNitBsQcc9gUTADxMqMcHXH0QD5PXOYPLgNBWtLLLKtR0MFqkE/e0gO1SS89xGRylGKy24Ca+
	nHP5nk9KME8AOgA/O9mI1jW4XqEKXCg5yob3cAhE0QjAFYOcYm+HC25xY9i0fbRFMNrJ34O1h/2
	YFHAdNGG/3Y6cdOJQM3808A+QiKETgN3RBank2Mpfq/XHHA7Jm4oaiSW9D6aCN7QJHmtAnZnt5F
	tbAYQBtRDfPIDYE3JO3qYqWkCj/1ruUCkjHMS+ANZUVHasQsmthn5x4jvkQDPAU1YxF2YnAFTxq
	oIU/C6M3CkuEp3wwqscCA3CBZprterUxo/FTVJA26H6vEM+WSPAW2wL0AIr9AlsuGef2gZqjcDV
	omjklrrmYVU1IZ2YRAFx+bzJfireLJhmBC
X-Received: by 2002:ad4:5be5:0:b0:8cc:2a92:48f2 with SMTP id 6a1803df08f44-8cee625246bmr434460006d6.39.1781109818092;
        Wed, 10 Jun 2026 09:43:38 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd055181sm237170586d6.30.2026.06.10.09.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 09:43:37 -0700 (PDT)
Date: Wed, 10 Jun 2026 12:43:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/8] mm: merge writeout into pageout
Message-ID: <aimUOAFQ0x8nm2oX@cmpxchg.org>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-3-hch@lst.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B01D4000A
X-Stat-Signature: arst36ufjcp3asu9dbio61rmur6mixny
X-Rspam-User: 
X-HE-Tag: 1781109818-392925
X-HE-Meta: U2FsdGVkX183xq3OITRy9TUrSygL7HHd7BO12e4oZ3/dHVtUBRA1+bUW9kpyiSNYV+/E+RqWB14Apn6OYaXMMfnc74uaA3jcRz6iXSzkDr8ujmvyH8HHQhEoSnq4gSkO0Pot8mczhmKA9iSX5NenHuXcolqwW1C4w+6z4Y03LzsYoSi/+2iHT9F5PDx8o9a8n0AmNF3K9oLD8wEmpZGeIWIIfjnBFnicrMfcAZJpH0a+Z6ss9VLM/6sq6suHIKRswMN7vwcvgrSE3H7Wp7vk9Q7lniFFCXrtUIvN3n4Hdmo8RRqK/3paDPeFnCQQtcJhAEonBI2My54HeKIR75GfQ33pvhcFGlRlqvM60JYBheyot7j2Zn3zjhstheTCFhhFySjRT2ECxo2iyjsyF1i4vmz6G9eWqF7eXM24Pv9NWA23mRPP78Vm8HHLvmepSgJKTppSGoeXgl/J0IGlTydulQWToPNWwtdbp7kGAEAS7FB+J27tR3xh/ZzN92gKmbdEdt4atPOtUT8ANXiI4pkBh8fUGp8CwtTD7Ou4+9cotG8LKDLtY/3LeXlwV7E+xcHaUfy4D3gjMur0tqqGTAGh3Fmw2B34HpJ5aBSXDfJuF7elrHCkv1YGH2rPpsj8F6oKHS9UGDcXSawARcq/mYTfTDB2PJkINS30SkmDzy9KLWFfTsqZnFYax7lJsJkR9KNJCf8IdzzWxA/CuEtuHOLrMz8L1zFEFhOMDo+JnRg+mULRSmCtj6UZcvDBo/UsAdXlVAYL7K2oIoSPNuHGcHgqXwEn90ddJTm/COZDr0dgPWKFUw3R/ioExL8dbd2K4RTCldqQGXhq2/P8+BNjatV4dB5GEKnUwl5OfNceMFqMII8HUVpZJ9GiEtxONhN/wq2Ae9EmtAw1XGlqwkHNhY7bfwvvbmsTGlQ5Se29/pfdeLV9l0K9BMmfMixgs+hMeHJi3WyFE6CaadOPPSoiaYI
 /w21cZfT
 ROVeNIQUknzdnq+wsDfoUEAYtK+V4zPjijHeBf14vyhOgzSJ0CDFHe9EKSUkQwWKAXFLpV/X3Dbtic2pxbI0sSUOnBXp4vEQZtiiQ6jA8qxLB2UYkOpXoWQ4/F7d3aoSDSK7mO11LekWhF7Fs87Su1VmR6L4lwTs2UvyryFrTWCtTlorS8R4rYWcnm1UkqOlJxWaVxx4X/w+jOA7zXsjIg/aIo3U9MOeVT7sJ64Lvh9CqZr3IacvdkMX9DemS9kObgxCtUGwRfVBmBzP+uBLzi46NYQHyEyfuZfTbYXiCRQlkV4TDXQwEuRUm0rmzipMc1wP3HiTvQIJJUSldRBi5sUKPUFIRGlBpaLF6NUCRDH/Ku0R5L4fRfRpAatrapCHl1cT/pIRpOYGtv/GlPelzZ42yJc0V0YfofY1vI74/7sjMTUr3nw8N7m2syvb+pmqmCPYNR694Zke2B5Tfx9E54csg05OXMJs7PQhrVfwvdtjK2Hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:34:28PM +0200, Christoph Hellwig wrote:
> writeout is only called from pageout, and a straight flow at the end, so
> merge the two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

LGTM for 7.2 inclusion.

