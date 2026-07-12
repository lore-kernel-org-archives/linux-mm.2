Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D5CC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 12:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90EB6B0005; Sun, 12 Jul 2026 08:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41B56B0088; Sun, 12 Jul 2026 08:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30A36B008A; Sun, 12 Jul 2026 08:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7006B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:39:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D26540482
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:39:22 +0000 (UTC)
X-FDA: 84980080164.11.0FF0B3B
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C88B40004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:39:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fTYrJnEQ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783859960;
	b=CPenSQagoJGIIzqBmtR2G5d3SLypRERi0D0iR/yWicQMXaeB4e6U2KEMPNuzQfrrJTbSCe
	VH3pdoyZzAHmBYZ89tYspzzX4wjTl5nrfSstjRulHKgdebppXKWF+mR1g2cdNh+qe4QE5j
	6uoz5iYFhwhSTwfjXCIYObB1feGPr/M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fTYrJnEQ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783859960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpBJeAespB/ecG7leQANvH1JBf2dPPB4qbmO+Bd4+ZY=;
	b=ceKdkwN2p9Oo4+2JDAYd+0KvUzBUQe+/xPAosr2LmS5EU5OozHqGiOPpRwThnCVzS0psQ0
	YliaJcQSyb5p7psnK+A8/LKcIa4NDdDSwSsekyJa51C4mxNicGq1YDwfx71lF1VE/VGTha
	6oi8XFCOX00oTjeAhVJ8/k5hMThvetw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c2a449c57so15488211cf.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783859959; x=1784464759; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DpBJeAespB/ecG7leQANvH1JBf2dPPB4qbmO+Bd4+ZY=;
        b=fTYrJnEQuemRwLZpyR5ScmK1V69gOo7i2sJEkdj/lbkY/Q+Qo+OgJJ8np6BA9vr8wC
         PLWTtZkwklzgEoArhpTkA8W1Vj0N2+0vksq7cOllydDZJ8xAyyak5aLqRSAb2HD8ynjF
         D0eQotCLB0nuGBeumYQF51LSetuUx9IB8jiECR4cX2vC93HI0mBnla770ElO+fWJAXkL
         E9bxftfnXXCPl3QhbOmeWAUrldW/gaHdTLRsY4xRGJoKfdyWRwagP6++cf/l2wCNrhRJ
         Jk9T2oftIzR5zjTb6rPJfgvQOqWQv1F5RMwebnBVVmsYQUInwmlqBKXmdn0n//Mlzwnd
         z4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783859959; x=1784464759;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DpBJeAespB/ecG7leQANvH1JBf2dPPB4qbmO+Bd4+ZY=;
        b=OL64SRZM8z7MqrRBQ2esZTtCw+vDyid9fe6o8hVKqJqim08iYPAC1U/YM5DLGswtGU
         X5t7rD9cWdvQNbYFEPXU93qF/l4fgsjEm1+SIuzqZOoVaJ+MxCQnu0YxkXgm2qRVFQzH
         GPd5sxULdSU2J3uuisxBV4pHT1lt03OL3U37vvJ8kOGJz9nBkw2R4FyjuD2OmqDBHcUu
         xDccDK+ur3SfflzUrWcuVP6Bf0Ti7DR9fqOhCVYhPlhz1JDyLA0HNPN4Pylfqz4/hJMm
         MGsZ3YyXbPfCX38S33McB+0DLlJGFxGDWl7rtCD8zljnpjxCp5fxTBSOPGXnY7n3rred
         033g==
X-Forwarded-Encrypted: i=1; AHgh+RoweP6GQT2tAfMF8PSalEC/fspW1VQSCx94rVtw3eGCkOle216glLzVy2acocOHlddlozXKyctAiQ==@kvack.org
X-Gm-Message-State: AOJu0YymgRU2bs4H7rHrkZ0iEBc9CBugCZC3sjOn5rjbcGvheXFZbh9J
	7sjvFhp20UnlJIJPcPw/XMoo6uCRl8CectXEMZOiSwFcsr35R39CbHQTg6nLbTJuz/w=
X-Gm-Gg: AfdE7ck/l4iWIoaiam58fvCNAcVmSkboz44WGhv/RoCjMiLU+ixGMrawbT+WV/SCzxV
	w3HOvKXrmJ6HI8b36JApsj6g1aCkerPdnHUx3j2bhtcfWM3iuG5u/z94YA7WxBCGwe1c83Lfdd7
	rukATwWUFT0JlBhzetYILY3UAepFjpP4XMkzPEm+ol9GWgd9PLmSIHRIRsWYLe9Rq87WI5yFOQj
	7zhZ9aij9GsnoWCOpY+ui+Gr3Ma1XsW2SeqVyaSASbn8UR26b0x2dSA1nOnUX61wgWWZ+iglREa
	PhZUSo2DMTphKGo6liO/n7ah7FlTeOsn4TfBeCInERsdAFjULMz7vB/1Qy2XX4+Nm68dQgmKJTt
	Tv8i5LjDhz2b6/uDdIRfo8w/eEUoe1mzEiRr28J68XNBCpCsYt5fTKkAlcywChCJ05/Cb480wHK
	00vo0/T2YLEVSkrlray3zPdKVrhxHbIeZMjfQQlO/xcRCUR+gtPdnrHVTvCpGcVOVL8bJ+
X-Received: by 2002:a05:622a:5c13:b0:51c:9b44:c59e with SMTP id d75a77b69052e-51cbf15fd9emr56444801cf.22.1783859959107;
        Sun, 12 Jul 2026 05:39:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd5bbb1e1sm102900876d6.22.2026.07.12.05.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 05:39:18 -0700 (PDT)
Date: Sun, 12 Jul 2026 08:39:13 -0400
From: Gregory Price <gourry@gourry.net>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
	balbirs@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org,
	dev.jain@arm.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
	ryan.roberts@arm.com, vbabka@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com,
	shakeel.butt@linux.dev, hannes@cmpxchg.org,
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/mempolicy: skip non-present PMDs when queueing
 folios
Message-ID: <alOK8cVLS8FYFGdE@gourry-fedora-PF4VCD3F>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
 <20260710105557.1987433-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710105557.1987433-2-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C88B40004
X-Stat-Signature: 3kydthcys5uc5y7m5kuitnj5cnpoagyg
X-HE-Tag: 1783859960-506961
X-HE-Meta: U2FsdGVkX19N4Mp22drMtIvMLJz3tofTaztIANxkVtHalX9iSmCX7aLyIlqnLd+Kroy44qtTjuR4wnUoOstNqJAxGWX6ZqTf2mDlyVgwRYCqRewnfFIRZeUcKSXTtU0VhufNP0xTBBbblNkZnGPp9IPov3U+uAKJFnDFQzV+j8OWTwywiXPCb/dQNDn/HHFWmYFJtFlnJJny/fTMn98JbRYSsGyV5GRrmmCepsCeKxoB+O1JwYgJTPwAmbZuBQF3AyABiH9YOyOtRrzYQCdxJtyy3q8xMmwkzcOhanjEHKw1hibAF3M4fjusbDobyMjMn0feWoHfFvpO+fICgQXkuCxpf1jp5ZXDdN9ADP5+5rZY/uJUGIctwG+1pyVdZGYsnvyn/2Wgk0pQoWbLtu4AbtsHeFSmGcoB7TYbuoC0sn66uflWXBSy5YvsFkS67x8KTmHs9iRy9urlu7Rg7BlKBCZz5pgw2KeazSTXIj/zkRhUEEWBWN7MD44/9ATpSVrHJLptUre7goxceiGsSQtACyQcggiGcjkeGDPrONLHO9UziH0O/KZeL1CCmIU6zay3oS3JxCdMysG+qcs65vay3LCLnM1iYWKoHRh7GicpVneDHOrz4M4NHkc4t+nFm3qffLtXKXsOphTbLZIm34emjAsMMzeOm0E673RFcykvICBIHlRZgUQQtK85MatBNXnmmC/wNRgaMwiqJQgzBjAGHGj3zsX6br34OhCyaxejVe8b1S2DCABC9kBM0+JRnQxfc0wkkqAAY+gLHjg5V5QhBfF9fuUlnqvWAxLOYM2RQJguE8lZHknf8JjazclVe+EOQM2EflO8hpglDmIiujLBDOTmtZ4IuxGdsR1ZZM6g0z3CdKx5QibDM+lzbg4VhCnASQVIGgBfG2/TRBZdJSgINOlgZt5bXUk9cl7QjLai5l0awGYdxekhhZ0GSWf5NPJ/4kNzbaLvX6Ame29zPyn
 JHs8XQ5W
 5QnYAhv+aqp0SmGJK+Lyl8Izvdg7k5cktxwyvCmypkCcC+er79V25CAy0ZNUGLzh+Qzb4fNd7IO9gn+LWCIZg3FjOWdQFlTD/Eq+yHYJWf8vpRhyDtJXQ007kNE28EBKpOajQk1reV8g+3n2z4EKKfXBYs8Jc/BnfnH+zF0EUNCa0ZgEQMvpg02jXC8QEpszSHnKxS+OtiV7wpPyyC/4E60PWwgODeFX43q5UGs6pgu8QQAy39uBh6J7qktDnnW1u5ABZDXH6anQmu8Cv6dZ7U6uMDmIvJRZYre3zdxI8lBxfKzbZ+cPZugQCKuZzmTU+V29lFacWNU7v584IxiK11XVW0WJNY/RXG18Pq01ZqFXPSwhVS6t/sZVp2WREAtukPe7ULq55U4Iln5Soe12z58bo7mUbaJapnrMCPFl/Eh1gh9h8ODNCavcq9uF368WptF935Tpr/ngXfz/GTTD3BIz+eOts6sD4YZxNzeS8dlgpkPuF2BeRdVApDmSTz7waqsibIozoGczCq9aPjIw78kChBsw6hUp9S3rgEUG9FlSp6d7bJFzy9QkPVGGH8qv/oQLx+FxypXhZPiMcgnO75FP3WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:55:21AM -0700, Usama Arif wrote:
> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for any non-present, non-none PMD
> softleaf. Passing such a PMD to pmd_folio() treats the softleaf encoding
> as a hardware PFN and can return a bogus folio pointer.
> 
> Mirror queue_folios_pte_range(): handle non-present entries before
> looking up a folio. Keep migration entries counted as failures, but skip
> other non-present PMDs such as device-private entries.
> 
> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
> folio to device memory via migrate_vma_pages(), leaving a device-private
> PMD. Userspace then calls mbind(), migrate_pages() or
> set_mempolicy_home_node() on that range.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Gregory Price <gourry@gourry.net>


