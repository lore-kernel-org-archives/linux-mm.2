Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7E9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6093B6B00BC; Mon, 29 Jun 2026 08:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BAC16B00BD; Mon, 29 Jun 2026 08:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482816B00C0; Mon, 29 Jun 2026 08:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 265EE6B00BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:43:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAF63C31BF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:43:33 +0000 (UTC)
X-FDA: 84932916306.05.6D42C37
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id A05C41C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:43:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Of2KUBHf;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782737011;
	b=7AuaJ2+6F+GSUHWUv3K0UEd/04LuUo+az3MB0piXfldR+DZPuF4wguzukeJR/X8zCN0ief
	pfXHyRUWNGJLcmimqkuD3cjh02PHrwEusQi/XNcT1OKt/gwBCnGmL8JZ/G97S+ro8lcvId
	8jH5j+o6JZNo2nvguNTzQNbKQFEyWuc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782737011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7QqOx7L0yRT5lYn1aBp2HBANrTGQYy6nWxkVXuVCPs=;
	b=41miWxVUmV85nHRRtgjtR8JzETU499VdoMvHLRF+BV+Zsu72UjuIueUISkCT/Ass9PCdsM
	2PmzRDWDC9DQa2gNqhbD53zlbKIgLe91vlnz3Rj2oqSfXodB8HXyMIkgzbqYgJBuxQ6oEe
	9qT/NYfai/SXovGXRArqq59wNFKq/48=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Of2KUBHf;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-519e7faecf1so51066751cf.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782737011; x=1783341811; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7QqOx7L0yRT5lYn1aBp2HBANrTGQYy6nWxkVXuVCPs=;
        b=Of2KUBHf5gVj5Tv81YQwZo27JaGvqLnw93OBso4+g1Qy1+0p/nxPNyM41sWg2ZqpIG
         OxDU9B8HfxsDQCrAWKIWIz30+xBJidJKxGBYIrrNjei+M30jWN7QdxWMi8bB3W7mW+XW
         inU0b2BBbWcYEKRz26Dex7gvZZm4GEttj8mvHkYzDPdxVZ4dw6f3XqJvpUBQk6VfHxmR
         XAiPNWNrN0/uT2tOlo2LHZiLXuIlpTyLXh11UFNWQVt14fg9GFSOezdKBI0662ldltED
         6I7NfJJYCM1IqLFSUeLfs51ghSA6XTlyqys6plBIWSyzZ8mIbFl4XwEF1rrhv/nFhJfV
         MEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782737011; x=1783341811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7QqOx7L0yRT5lYn1aBp2HBANrTGQYy6nWxkVXuVCPs=;
        b=UU1zhIzlb1WZojyblJRNnLYOfK+td0un5I+quPsM64/pahj/8Pz+ea22/7Uup5BEpH
         oXH/kuhsZKZ3SBJYkUSNt/nWjXCpxMtjxy6dAtGucp+I5aovfj+WliuSEd5Mjlam7O9p
         tDhs3EEioMawWqiTwGbF1F0edYti0m2ikSDxRAsVQve9zFJyH/Yfl6aIFawYdWi2UkDa
         11zkgKNihPMx9AmA55Sd/30FeLn5XnbHfvOoN8U2Z+adHEqu+avjm72GfQqpLwLY4+R8
         JcHSiNOEFF1wHjgjAL1dvkFl+nN6pBnUK1QK1JhFnkAp13BC/UvbPLwF47RV1XaFHxmR
         R0IA==
X-Forwarded-Encrypted: i=1; AFNElJ96JVYvE2Z0oBXiyO3tEhCx1ZOiAYfAKbhZI91i2U6jrSmc75seEUTyw3h6N8pWCF1cyUUX21mAXg==@kvack.org
X-Gm-Message-State: AOJu0YxMdGm7I4+IwWK5BS5IjlBFMS7fkNvFahV70pnjSNaXeycUk+E3
	jtkdecaIe7cLDEu9JCEPWL+U1cV2NwSjoC85fKM1zcdGeFxjpttXHM+/QTyebNMAxLg=
X-Gm-Gg: AfdE7cm0B6A4PgvDJfEZ8+IrsTMsy0HcUosubigYU+UMazn9RLLpbDSuEQCbikDpseS
	5vAsiGB6ylZTh1cwOkuIN/JFycP/OYuNxk2w67JZgm9QynE3pS0/5eQbFmpoQt3/DiCyEkCRVac
	Fas8R17OEHp8+Z43+5FJIuqjftE0IQ+M9aVLrzh6qKN/2ACkAGlgTjZDnutC+0v4QD495pMxCeG
	StdfSsq6Tt1bIB+h99HsSDzCh1U8BviWoD8yg6OyLa3BMwZGIjeiFWoXomz5ShYIVzWOS8yEHM3
	plsszg/Ikg6WNOxeuyiL6Z3RI5VFrD1yAGaWULuer0lrQwM7XnLc8J/dozg6KTmUW02KUedCc+R
	o+mz2e8Mix9U4zs1Nmy7hDpe1e9sQiSEqKdHU0GplLETLQtYlvM/mChpDYZQt2VErhB1bnVXbZS
	9Skq5nKbuD7p8=
X-Received: by 2002:a05:622a:48d:b0:517:6665:2a9a with SMTP id d75a77b69052e-51a727ee736mr224276821cf.50.1782737010340;
        Mon, 29 Jun 2026 05:43:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7ef1fe40sm304784856d6.4.2026.06.29.05.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:43:29 -0700 (PDT)
Date: Mon, 29 Jun 2026 08:43:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN
 logic
Message-ID: <akJocCUM4HEOegWW@cmpxchg.org>
References: <def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: gf7zz33jjheo7qgcqjui4pchzahrgkr4
X-Rspamd-Queue-Id: A05C41C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782737011-320561
X-HE-Meta: U2FsdGVkX18YjUFtKiWpRAco1wbCijo/Jr9y9Z18BEta+LwayWQRDtMPhApAr7luIA6EiaqI7kkKk0DytKtbByDY9FSwzeZf7n8uxvTJBjMYhQu3vLrBAzQFwsqEUJpZJq8mFVapjScba1OtcGxWTvaYtdM8ea31QE8K9FzjIeox5dOLICNA41nSwThkGklbDC5rnVYZlfXjrdp68lE1xc9s444pazeHbbfdyZO6Q1fagB0Ad4ApSCtcan/NHCbAOnEqc5qBMziqQUt6gXarIXX4Ayzh26IMtoMeLVzYrCLhBVINOJmIqZZoeHWFc0M4GGBsxtWGPrF8Lxpf1/HgJEyC1SRTNCWY0fiL1qCpbC9+CMI03y9DxPqJs3P3Tjd8dl9/XOPBxReVf/2QXgkm/2N4UzDB9oiG741t95HRLGghwfS3ycdrT4gGfJcT6r4gXkiEfyi/M87POC+ZP7E6TLDG/lQpCfOULg+YbXcJ+w+zCIMp2ihoksQHU9sm3qvN5SjEPKD7fp26SKR9lXHYv1fELaffhFtFfgtnn31daj8/4Cz+WzGtLwG0uLdTtbqZH8H10weCQg1QpyY+Yc5qN5th/F/wXRzw/55wTndmsUKTQZLAc6tOAuctb61wJRYRb7uu6XnB5TH3gfvLqhDTXS1U1PM8VLUGtwgVpmJ58Yz+pWoDD5nAl1SUcX4zWbThZu01osKSX393LX+rrVpebeNaR4uzWIQK/MvgyK0X53PROj92bZZ/53r/Qj6c4wUPcCD8vLZvqOATkBkAxJVVQjYIdYvgnUWlJGURI95sfD7WhOOYnrKzjWpEz/aIs/l7+Oro/xUc9qWQ+luTy+tHelgHU93q7BK6LSNijm3qtenbMoMbBvoXFF5nNwlGnqBroA+JZMB3tdqMv8w3NqzA3y8fUES2V16sItimLaNWJF9c+DcBiHEyOzm5GfcFrJ06h1y24IkzVAPEBgIh/Vd
 6Fxi/Jlf
 l+zapshRtsDm/iAhVsTrSU0gLc8wPBx9T/b6kzQzqXyKzRAVkcdK1tjXfoXG1xhkuknAO1ovh4vaNR7Aji4ZL4RRZqcNkEM1oSGsKVNcFDUVEsGRaz7P/p49f4rQ6/CztbwERCVpzpXI8Uffiwy+MNitjgUUeOy4VmcsXs7FO29ijyaT1NJmSdkeuSrhE7TJ9puKVV6kpOS9JNJCM/8SfazWsBIHO7d7MIJb3xXyJeELSOCA+FapPAscgZiFRJsRWzkkHUHoaUWfckvhoCc2qLguadQvxIl/iRk2cAW2OPJ6G7zBvhtlsk6E6l5W5mbQeu+9Iq43EX8TEoeKRbw1mE+qMuP6bMux21WzUyhQwRGsggn41G9Q3In0stDPMGvwvk2ARRAT0urLRHtKHV23F38iGcjzOLcF6Ahj2krMX2TnP2vdfiqiMCfvcNQrGZolMcLh2ZdiwmfmYYkaIK8DeseAOFcrIZOIjK88j7GPPiSLNweuko/st3A+lxVEEXvIBamzW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 04:04:06PM +0800, Baolin Wang wrote:
> folio_check_references() will return FOLIOREF_RECLAIM_CLEAN for referenced
> file folios, indicating that we can proceed to reclaim clean file folios
> or keep them if they are dirty file folios. However, after commit 6b0dfabb3555
> ("fs: Remove aops->writepage"), we no longer attempt to write back filesystem
> folios through reclaim. Instead, we always activate dirty file folios and wakeup
> the flush workers to write them back. As a result, the FOLIOREF_RECLAIM_CLEAN
> logic is now redundant: for dirty file folios, we will no longer reach the
> 'references == FOLIOREF_RECLAIM_CLEAN' branch in shrink_folio_list().
> 
> Additionally, lazyfree folios are also placed on the file LRU list, but if a
> lazyfree folio becomes dirty, try_to_unmap() will fail and thus prevent reclaim
> of the re-dirtied lazyfree folios.
> 
> Therefore, we can drop the FOLIOREF_RECLAIM_CLEAN-related logic.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Good catch and nice cleanup :)

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

