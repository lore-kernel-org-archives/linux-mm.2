Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A240CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723EA6B000C; Thu, 28 Aug 2025 02:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3A96B000E; Thu, 28 Aug 2025 02:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9CB6B0010; Thu, 28 Aug 2025 02:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABCD6B000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:45:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF0ED8530D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:45:49 +0000 (UTC)
X-FDA: 83825230818.20.F466F92
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2E1A40004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:45:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MTYG4UT9;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756363548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knemHQZ23pxIDABlkjX6mLqLtGGVNS33kJ89XWuOpd0=;
	b=EwambfCb67GuSpQGDaKtbR8+GXpFb/T/UaDDPba6pxanHeetxUBvZcBAPrGWEvYrTMTOTX
	WhPBq7EG9lI+EeH+ASbVxeCNu9h8JpRjSiF0scCD4pu4JcVFmnO+t+5ok2ezfMhrpDpBi+
	M4cGrPTf5LLUSmesVXKLOLk9xTh1tTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756363548; a=rsa-sha256;
	cv=none;
	b=RfCl/Iy4EAHjA20657HVvUEjUK1upMxxuB5aDlBGGdyf/5w8db4AASfMAC1a0gV+4lTqqH
	zaL5txU3it63hrzn+6ey/6qyi/hzhI26rkCmVIO3uABz8/ex3ZAtZKbzsc1plVOnlG/UdE
	58Mz6Lgh2JhYfKnZqJC4zJvCilQEkm0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MTYG4UT9;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b49f7aaf5so2869305e9.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756363546; x=1756968346; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=knemHQZ23pxIDABlkjX6mLqLtGGVNS33kJ89XWuOpd0=;
        b=MTYG4UT9OEwXGwZNT+CS6GxjJhYBKHtZAoE46kA4KVzfzTsnmGxwgTUEUNh4eRBSSr
         Kf8bCSFLBsCqjXQNtKs8xSrtHsv8phoxh3RMA1TRlhrzo9WgtrfKuMSH10GIhGYAB4NA
         AIl3YY/DT/EVb2JgIxhy6sV08yzdgvWaWb7fwEm3Ky58Pf7Ap635Gg94NmMEbg6z0K4O
         cpLer7lD6uoaDsXWlJkvGlFxl6vsjUSBcvwoHQx2tTh2QilwbauUcTdk04WdKHQgXCbF
         TxXFj4/V0DzWuNztdTkdtz6m6E3fTU8MiDAbvkv47oDCBJC+z0T9uNoJVg6xMJOZ8xVw
         iq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756363546; x=1756968346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knemHQZ23pxIDABlkjX6mLqLtGGVNS33kJ89XWuOpd0=;
        b=pPxk1ozKjfT5h4osiIk5eWRC6hvvN5UeRhlqt4kYWgLsckXCcKkW7U6gnnU54wsROl
         IDYZPrn0MrPAcU5kuad5wGenZkfPfTKHtibtrQUI9WVDAiAOdsY4b9O2XBY8/drtQc7P
         F+vcL8U4ZfQP6e9hvlwxLUUhHrNNzdGpmjeg38mofqe6HqhNKNxQvU47z7STIzBrjiue
         fT+zr2aMgQ/jUH09ec7UVOQ6ZOQcK2EyBO2P2FfcspB2BfwlBKs/uaxDf+7Wm3lOL9jP
         KerYXgS8hlsD+weO+0skOtDJl4zNsAgcH15bjYsBf7tOSLm5+L+MGQocSdI/sBIEhP/B
         Utrg==
X-Forwarded-Encrypted: i=1; AJvYcCUBxGcGzYDV3ICI18NH8IiveHdt/M5RDZQ5Hk1Rh0MBSKnKOriijdTmDexlb/HL9og7/RBN66tX5A==@kvack.org
X-Gm-Message-State: AOJu0Yx0ap5dwgu7AH2xxIjRdteawkd8P+ykG9uEWuJ+V1fO9gL/gVkF
	3Lvhat5jRvOTTOBipzj4LUqNT8BtyLlIeQZqhof9rQeu9oPYZAO/3mioKR/30jv0dDU=
X-Gm-Gg: ASbGnctjLtuzRaDClUM6KHd0q6YDg+faovyGRBnpAUNeztkstoRxU9uw6t51TT6toS4
	jCVRzXCa91Ge6GuGz3ev+0XcFZBlWIGLG7DGXrsmQtPAea57PaCylgjp4VUTFE8zEfANLNiCrJv
	272z0NcfyhNJzy2CLZGAK2lvBFJQvnhgh/sgIqQSbu9/RCV4rvRsnGtLhBC+FjhKMcDgWNlubno
	81GdPcFTsdMiesijWEQ/3VrwPaxZddn2+JTYCvKs/iKlHNZ5vpjS5TOC31YFjzvefK3fhocwpN+
	OCeAx8LfwSZJw8bm7qNftYFduj6aOfUeaceStth4EKEqQjh4pauR5Qt+CiXihbCBGhZDUP1GmUL
	MCxSV4pFC794HGRRWSdx9jdFGX2uHxZ9HRV3EsOtkDE6jvA==
X-Google-Smtp-Source: AGHT+IEzVCb/sPwnrBnjP7P0WHlUWm3cB4aF8du8T7+csVrDJeE5Tu9GjnX3DSLGMIT4YnlpckMapw==
X-Received: by 2002:a05:600c:3b8b:b0:45b:7951:92a2 with SMTP id 5b1f17b1804b1-45b795195c9mr9624715e9.18.1756363546098;
        Wed, 27 Aug 2025 23:45:46 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b66c39f72sm49159435e9.2.2025.08.27.23.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 23:45:45 -0700 (PDT)
Date: Thu, 28 Aug 2025 08:45:44 +0200
From: Michal Hocko <mhocko@suse.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
Message-ID: <aK_7GKJ4BWjye4tZ@tiehlicka>
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2E1A40004
X-Stat-Signature: 9edd3a9dwcho6rz474us7qatn91ursmr
X-HE-Tag: 1756363547-326995
X-HE-Meta: U2FsdGVkX18ayoiuafaK3JDDhZKvwc9WCg/ORpYT8cWjf8qK1EGrSM+a7kgEU8+DI3LAQLcfQ+5jYW+M8XSIUz4Dgqh4ZoxcMJk0xZcBCjDu7tigzVW4vrhKra16/+OVoyC0uJRyWwBiqZLpamiCtvmlqJKtSAd98zxUaDDRfHCN1GgX3+ctsTPYnzb8+sAmGWdLQloNk/IRiOAHDLZd9BG/Q3u0YQ65cErv7UZsNmypxFVNiZmuYhICefJKWXfXSQLu/gnalsufKJPdFEAXHyoDqAIGHFV9nFK0d762B8effhrSfJvroDRAjuZ1vLwuJROrVOZXrZk6yEs2qkoBTVCdYXHLmv1XdODg2j6geOU4V0toqVl4/n11d2r/P/xONNw4w6WCUUbPZBizGGZKAsfAzyucMQlIHdt8o+dMndnmThpCp4yyEBsI63BUzvuJjTcuPKy3QuyV54ZnHKtCcka7ucCYQgWKFV2a8ykNhS//fs7TJJJjeUmgn7mKA5x5cmHNJQsFkIKwkhmV4T8NbdZ/ZxVq5G47q+ryGkXJSo/IBCdjRSfi2fus3KO9J4xtAewfHORh6+g1CKCq+8vTKqu9eeKxxvDqRhPndOyrFpK31Z6VX4Nn3fEBrzs9PviFlgf+yaS7RZHnZ/wcErVEU7MNp5jtJN/Nqfc1rD25UdMjHuYImV34Z3mx+49KHaZn6LkojAgXA3Y4LEECqNwxidmpNf44skASPOaWWLify6kauW2pfBG1csoA2kiSxsri77y1HZS+SOkUjapgKfKHTXNwIUmvBt2PXhjecIFzfeMF8ch8F4JBB+iGP5LpKp5Rv8x7OxhnzRagGM2CltlDwO8YXwFJq9ioIRWfUL6zg9lc/vUcgoMQHPixkw+snadU9pYRDc/I2zxpcpiLM1jBh3D3qFbi5oXpwnqC/wWlW2wBiNDDKI0uBKv9Fkh8TlNw5nZS12R3ulLLkpmP1p0
 u6VW8FXE
 /sJ//YCbANbEXpOIYK4nQNX6fPROKKAHg+vIVZKrxl4txuW79ZEecmPUgmN9qk/vV0UMqqoriIenWUGCJZXURFSNEeiUlgfuLrZ4dIbjMtGdlpdROxBLhPUmyo1GHDy39N6uoCAGTJUKrNMQCTNgXKTRiyT9oOLaLosFvr58YVVaujU7fSLmogswHL0j3oBgArUX/uuMkUaiJ6Pf3bsNnbyj+Z1mRwMteGOI3JAKcCck1HgvcdFImN/D/zdAZRKmPuC0XEquy/A+RURzbcVqJu1CBOPOrQCW6jgzoUk/vQ8kNoMpKEzV49K+InILbRlm+B6lD0dvlGx32TZzfk2CF1www2pkXdyy8aeac6gazTXn8lKdJNhLN2Y5lNRgNh950XkBk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 28-08-25 11:06:02, Weilin Tong wrote:
> When min_free_kbytes is user-configured, increasing system memory via memory
> hotplug may trigger multiple recalculations of min_free_kbytes. This results
> in excessive warning messages flooding the kernel log if several memory blocks
> are added in a short period.
> 
> Sample dmesg output before optimization:
> ...
> [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
> ...
> 
> Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
> preventing large volumes of repeated log entries and improving log readability.

pr_warn_once seems too aggressive as we could miss useful events. On the
other hand I agree that repeating the same message for each memory block
onlining is not really helpful. Would it make sense to only pr_warn when
new_min_free_kbytes differs from the previous one we have warned for?

> 
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67..774723150e5b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6412,7 +6412,7 @@ void calculate_min_free_kbytes(void)
>  	if (new_min_free_kbytes > user_min_free_kbytes)
>  		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
>  	else
> -		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
> +		pr_warn_once("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
>  				new_min_free_kbytes, user_min_free_kbytes);
>  
>  }
> -- 
> 2.43.7

-- 
Michal Hocko
SUSE Labs

