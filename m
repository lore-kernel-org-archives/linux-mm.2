Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF34FC9EFF
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 15:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8890F6B0093; Sat,  7 Mar 2026 10:06:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840396B0096; Sat,  7 Mar 2026 10:06:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769796B0098; Sat,  7 Mar 2026 10:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6462A6B0093
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:06:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F03868C141
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:06:39 +0000 (UTC)
X-FDA: 84519593718.15.A189242
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id EC34980017
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:06:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=LmDZEKOL;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772895998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vniHmaRS69kiLoJ/X9VdQYIKz4FqmiLzwp1u/frI9oU=;
	b=iFY52MjKjgoHJ8NZ9E/BNLbXbfYQdQxfUsGe00DQD+/srX716jLQYi/I1FhX9wkCdVwcsw
	u2FoXcF1FEz77Bsdjw+0YbIChrzaugGpD9+emEWvKFO8NnTN7xgMjQ++Ml5UuFx5Gf1kuE
	rdO2550xr3nGdlNnUxG0wd8cibpDfmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772895998; a=rsa-sha256;
	cv=none;
	b=h9z2F5zv7oRlHTkfNJjXyereAzKes/eKkC5PNufwAtjFKZbpdeqJUUFnKRqKpQ65q4ed4l
	7lw8BznUoirNhGM3g8/ohwdZzePrcCSCcpnZU5UDmW9fBc0UT8H5+dXuGZdXmGhR8w2iZ4
	+fjmsj2vzoktZlEcFutQdZMYKROoPQ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=LmDZEKOL;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3598581ed7bso2751911a91.2
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 07:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772895997; x=1773500797; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vniHmaRS69kiLoJ/X9VdQYIKz4FqmiLzwp1u/frI9oU=;
        b=LmDZEKOL/5cxDp5hKC/BKsyyHFcrYJeSORi5sEqUd9w9ow6wJNb3HgOaNeQyhJ/B9r
         XT7xtqwSnQGUaP+uvpz39YfazLkhBPzT4pdOrT83Ay+D4W8qJK+RMUafAvMI8B5LIuYp
         G+Rt0u36cQAT2QWYy4hGlJaHBqFyEmaYSQtX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772895997; x=1773500797;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vniHmaRS69kiLoJ/X9VdQYIKz4FqmiLzwp1u/frI9oU=;
        b=l+Yx6BUM/oUBaWoECUeuSBIieY1hiRrY7F4Yj+z6rULDTzOR6PPdS+YrEI46vlLTBP
         B8rM5/UpBAcMrMOhvhUqLtR7D//JLk9fgIHxeraXrGwk5wbrvn4Tc9dHR3JzRB0b7HAu
         2DLZFykq0BB6h+moTVt6HhB2/TfeL9asz+bLsPDs9jJQpsXnGZgXAjgJjtVlHqHJpzXK
         AiFRNGTSc3fzlxkgKRfyQI4A9FWtr/akL5/SsEPYiZyqrgnkt87wQnybejI/DASJQ61S
         65Yc8rowXuG2On05MZmtLv7OKZUUjzcepEa9nDUZpxUfH/kLgxeuMuvkTFQ2KtZKEpad
         qgjg==
X-Forwarded-Encrypted: i=1; AJvYcCUYvqd/+eHxiIT9MGJp5qMy25l9BhE7FHqz3alnELLxWsN0zkYHtPpKbV4LwkDcm7zBLZh+OiSGew==@kvack.org
X-Gm-Message-State: AOJu0Yye8Je6aNRvhzWU/1BBl0l+OASMNjv5/HTdpf44q90qKkL1WAsO
	4ctK3zQv4yNqhfMuZGoJaLlJ+hOkeQRymQJrBaVW7HB4gxYFDb+zrnFF+hdbDt8dlHM=
X-Gm-Gg: ATEYQzwA4Bksz4O2jXPim5V/h65VgHC88zemhsIvRPdLlbjQkxcjZQageS1wTNglRKH
	rvtgPF31oPk4f21BwxNt8wsWDngmmed751DojrfyvBxO+PqEUdUZ3NJjys6FTAYrtb2jhh6FkKw
	By+1qQptNoWtN7BwP1SLQ7psoi1z2jYrbHppJakzW5MYfneicADxiPc2s0AFLEVDBtCk6TQl4m5
	KIgv/KJE/dZH9YU9UV4lUqKMxF3X8dW01BfERhGprJlcPKsr2hrbUQsYZL2WNM7MyPGSDtX57yb
	0Ek4qo51bsbmoU1TPhWxOQVD0+acJWGo8W/gY+HCbFliGMf9qL03Xw5WaxsfMM2cImdyJaXRWGC
	CyKBpC2hrA0jkq183Spruaa28ViL8/LR30Fw90alt+bYEIG83+Z5mKittIEUbQ52YPjo5J+AKzn
	y3rE/1KKviI0aJNv+q7FQ=
X-Received: by 2002:a17:90b:1dd2:b0:359:8f7e:d34a with SMTP id 98e67ed59e1d1-359be28ebf5mr4875862a91.9.1772895996718;
        Sat, 07 Mar 2026 07:06:36 -0800 (PST)
Received: from localhost ([149.28.151.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2de7932sm10129197a91.10.2026.03.07.07.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 07:06:36 -0800 (PST)
Date: Sat, 7 Mar 2026 23:06:25 +0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-ID: <aaw-8SNI6FK14yxu@chrisdown.name>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
 <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
 <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
 <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
 <20260303174226.1b9079ccd60164fe0b28a3e1@linux-foundation.org>
 <c4d29d08-50c3-46f8-a9ad-95f3ce552734@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c4d29d08-50c3-46f8-a9ad-95f3ce552734@lucifer.local>
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC34980017
X-Stat-Signature: nk5i8hmp66xd6iy7y6rftq7c5z537jza
X-Rspam-User: 
X-HE-Tag: 1772895997-467856
X-HE-Meta: U2FsdGVkX18uGtFeoVyJuL5k6QuJiLrh27xVi2VEy3tTiq4o87WKGZPbMHucL6hd8rHppZoxtW89XDWxXaRcnp3QWcfLLo+qwqfZuj5N4zKzoO+sCMeDMSyp3EXnCGsiivcouniS3wlu8TGOLXkrovQeiDume2t7Q3TOfB3BUSZz+Ay/1XPcU/Vw+8hNtdbd5BC+IwtoVQi/WG93HrjdBbs1NOj2gGYnRWb2NH4AAMr/GdGFVJUuOLdoignrmjKy3UdptIcBXi0/rmzp5VHvAhWoza+gMR4mujSAYmAyyA6Gt3dBqIEf21LbUMDYx1Yp3bW3J6zsCCqGe3Ys8m/BTy/z73nldqF4OKQwisBOTMXvFsFXiuNy7fNBPXVhlGf+U7N7lepkCxZMQ53NGvImv+um/4E2IZ4QF2jC72yVlvATRfZ2HII2x2rNBpXuyYiQdiPZYUgcq1G8DWVVJA2r7NOiWWXUliSBws1m7RmAFf62+FRb0prXLS7X+YihGNMSo3cTFVyrSGoX2m1GpeiCP9R6n71cNYmNt3r1137y+Vy6lOnGftFmc2WbGz4r+4gG+Unmcp1kInXJWK9Q4dgUAkppSrG01HD/3lWmdzDZ0B9Vw9jA1GHdmCUn7f01Izy5kigxxJPwKZaeOsql+23C5PqsxcrVNc/cJs4l8itk+F2yoFfpE9ygg94Uz9waF32DhfEjE9A8laMlY9LElkKB3jhWvmjDyu8bomGxirsOTph6p4bUgaFI4P4G4Hbph/Pcq/+MmcC69IYpUTClA7Kl30wcTFMCO6Ebn1Sbb+K0+fuHw1HE7tZJ7rWdlt1PFvLuBmm0qHCzlFqaDMX2Cf6wce996CA6DUoBTJy6dhzwY3ctJvPMY7pL0OGjDOq6u/q6gVL3aAEXMUsIz+2UmCbUrFBT/oG6lLyze4IiwmnfSRGVqmcjGdze83l63qiQb13CVcmZGX5YrLNkoZYrzy3
 n7DkISjX
 Qs7p/oqpPkD4FuSrNSjcmJRmBSim3zAjqIHDuAWtn2A9NDoHm5tAiBjKWO81HwmLsQ9F86MReSQ8jDLM+mSDjc+JkeiKKlsbRyqvKmg5EO7UXwNTxCpSJPspaEQBHuI3X7IwDhWJylTTL6ybCgkkHN4GCa3xacvzb0VRuwCKFrnfPYfYymn+MvCPCxyd/rEfmRbH5tqKKA/bN5LdWTjVqBwMLekFq8Ezn8cp4I/nInKWqBwvAF5tJS3z5miUz2I3AJYEfXKSsV3oyTEFEIQ0BXf92hDJRh9jZezGFbWe9B1ocOBZxR02XpvocylJ9T3iZpLPxUcuKF67ekj5ZXHmdgysHSU2xijbBw5bK1sqJNwr2pMyTj2O75kxDJCt/E1uwsZRIORV+fOxmVgifd640XGpSTbISYn1+7y3t/rVX7HOuP9/mi45uA5n3TQndAt+mSWwt0xW7OkJPlfL8OhOzcQI73fd/jD99/0wpZO818Ssq/s4hwv7RzAUUf4e6A7+yTpywcYTUNo41wZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks folks for sorting this one out, and my apologies for not being more 
responsive. I'm in south eastern China in a remote area until tomorrow and 
don't have internet in any form most of the time. The end results looks good to 
me.

For context, the reason I originally split it into two patches even though the 
second supercedes the first was to make sure Fixes: can match up to the right 
offending commits. But it is true that it may not be important.

As for the threading, clearly I haven't been using git format-email enough. :-) 
And my apologies for neglecting to cc folks from get_maintainers.

The end result looks good to me.

