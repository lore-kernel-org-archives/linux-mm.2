Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB03104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203886B0089; Wed, 11 Mar 2026 06:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B6B6B008A; Wed, 11 Mar 2026 06:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CEA6B008C; Wed, 11 Mar 2026 06:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAD3D6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:53:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FDCD1607C2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:53:06 +0000 (UTC)
X-FDA: 84533469972.28.71F2F5C
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9280940005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:53:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwGYAGbP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773226384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTw5419sO+ZQt/ZQu5o3TXcHUiN5SVxEL8bwcCKa16Y=;
	b=lSJBj1KDLkBLpyWgQIIBp97WGeSJT2JJyIy6xLJ4AYhGYVCMVxOvX8BWQgOcz8CkQ1wAx9
	2gltGv6eGJnx6necgzjA6eup7uxY4l5JhHD7uBr5IMWcjTGA2g2OHXv8JtUY8n5KAt3lJr
	HQwzAW+wmqtCVrqQnkCZM7skfQwDxyg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773226384; a=rsa-sha256;
	cv=pass;
	b=NiOXMmLcStI87gQx3CSaK2Yq3fBGTyOwN2Y1Yj1hTw7zf4/qmAAVAjN9Ecu2s7BLPeWBRN
	sOwEbtQHr7dZ3X7psPGKzscuLrqtIjyZ8sqOlsdCvdMmnRMvnS7Zib5AOiS97voZM1nN/C
	n7wuXasVisfJkUQ/9P2prDmJSjcvADI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwGYAGbP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2be1ab1fa7dso1106739eec.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:53:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773226383; cv=none;
        d=google.com; s=arc-20240605;
        b=NUyWCz1OwnsF27/A4nAykpsytr0BF0eGsKocns7s9pMM0NAMI66JKHp9mw4TgPmCNf
         6/KmOMfoqRtyubhs0WuEfmL8W0UVlGISN2QyyiLZGtxLxXRGfyM6stKSoBLc0HhM/SXu
         1bNcXG1m+iaXV78SAbr1w2evTGh8kf0+ym7GI+4PnsnFbZ7JBrtHBRZFfoqZUZfROXg0
         yKf0v2DTntH0KgBAHAR6cK7QyIGavgAij5DamfkuSDqtb1mNKr32wbHMw134fXMwFk3R
         PVgR4Mmdc0YMHa/Bexdq9diBO+nfur1UrNk2zdJFf6AUVbthFVYKRD1GofICllYNQDz8
         GHdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gTw5419sO+ZQt/ZQu5o3TXcHUiN5SVxEL8bwcCKa16Y=;
        fh=G5FzFcazQJ31xyN3ZaK8AbXSko6yUAzC1z1J7p/D5D4=;
        b=apqfD7DpK8f1eyBb/edmAGWawFCCHDg9nuSRjviYQT+lGDvHVQ7vEvWHTbnSYfzhrB
         w+LvTSKInU05Bm6L2sTGqJtt950AQiA1JiuQHKM1oMeROHDS1zxS9SY6m9wrWtTF5REq
         VRrVePzDFKSjDO6ix/lm8MMyYKiuGrDCdym+1WuDjXvv6inANFdu6wrZ77O88hBpMxeg
         F4JA5IcftHAivVKrbm8ZgfhQWrO1YQvyUVpR0EIB6sIjCLuk9FE2Rx7wdYoUvAsUcdyS
         uZRsn7ru7N4nxC0Y0cEXMs3ZrzjA8XcfR02ZLbpbo8pCKCpGBZ70Y+4llLRbQF6ye5se
         jRkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773226383; x=1773831183; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gTw5419sO+ZQt/ZQu5o3TXcHUiN5SVxEL8bwcCKa16Y=;
        b=KwGYAGbPFMNfO6D1Mbkk6dRpU+6L8JlhHuZvbBANMPSmaaq5YCRliwuH6HGykb3nt/
         F1DsJTwX6ZIey8u/9cSLPi+AHzccrplpgPmw4KQNelwf9nI/LOccduL5KtOB4A6prIWv
         1X6VILPRtHQOIm3xVSKtFKZt8auOZyjIYK8GMSa2lJ7Wab7cxiNQPA33t1IpazBh9wrq
         6U114p5MWUu8hC9Dinh09jr+8EADvWWniXJSoH9jYAEfmoxL9I900dklL3mZ8faW0eV5
         Kq2V5IjMoDfL0bRsxOjgu/STr6RBpY5tc6MtFe/E2zdTdjYvl4ceQZwJPIRXKqDZGKmU
         PqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773226383; x=1773831183;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTw5419sO+ZQt/ZQu5o3TXcHUiN5SVxEL8bwcCKa16Y=;
        b=VSJYahRBWMOsAV3uyTUQjXI7N/Yr5EvtgEL44jRGfDA2nplA4vT5Fjt9Vm+WzyUW/P
         AONNk1vYksMoTR3g7K3DXKL+27QWeQwfO6Fztg1kSjDMM+3qTEaOewfqK9LXNPi7kV40
         4DIDsqt4Wv1F1veR4oEIsamD/jqyl9apKigz8cI8uQ7E1TE8sZtmsXOzW3Dg6cb7UV4X
         pxmD9TC3Y/P6PoM4umYCRxj0RDBthcYjpEqqX9FeLuHTMd34PimhD4A9rz1qP6XVxlLJ
         pE8M5PlytFYEiTmRhfUI2TPeeIRvzv78xqZdOAn1UYT2CIdc664q2FbjrkIpX1S4LcPa
         uaJw==
X-Forwarded-Encrypted: i=1; AJvYcCU7OaemStRosynZce/CkRbnqYoGqzNyUpsJRiseZt+P6YeaKRW74o+mVvKZeZIFIZ67Xa9hELSSyA==@kvack.org
X-Gm-Message-State: AOJu0YwHVBF7luTfrTKszPObcCNfUjAooGJJyNEdHBQxx/VFXivG63XJ
	zijfOoE3MhYaZQAIWYmiYl4PrH1ZRQKH7KToAj7slBye2PUN44DSCAYOVQ3NqQEvvphsvcng5Ia
	vsGqlXulA0aMJDCLz1xekc37qt22M2aE=
X-Gm-Gg: ATEYQzyxnpCCFKdejj3QKqQn31v95GG1TpqLd3I66rfmBfW2vJLwplZAhSbwpL4ffO+
	gY7t1xBak17o9Kre8yao0tObi53x+Oo/lyCePEFAwQJ52/SoZUn8F8eO3i2WSQorJxMzjd1HSLb
	aIb3iLGQoaiwXW6Mn+ZRGNNsQfb3/ltqddTGGrfXqwmRPlXJDAN/gOnl+tZR1PnyBwb+3YWeqNE
	oRxvKsXRPcWeHfmU/HFLssgym7clx5PxzU3jsF+rmPMSYSmfIgFNa2MMeXR+cKcdNk805mtrOM+
	g4mxX45vZrKSjGfb30BzGMjACLlZVN69SCkyaK+GEQ==
X-Received: by 2002:a05:7301:1292:b0:2be:c4a:d31b with SMTP id
 5a478bee46e88-2be8a2fb45fmr903381eec.18.1773226382898; Wed, 11 Mar 2026
 03:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com> <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
In-Reply-To: <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Date: Wed, 11 Mar 2026 18:54:26 +0800
X-Gm-Features: AaiRm50xoqHIgHtMNuCnYEMaVNP__SmFrpCyLTigX-k2JUIeVxgHaApqFn99lXE
Message-ID: <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash calculation
To: jane.chu@oracle.com
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	SeongJae Park <sj@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: hquic8ay7m9egq7mjjnur1fg9dzbh4yj
X-Rspamd-Queue-Id: 9280940005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773226384-322741
X-HE-Meta: U2FsdGVkX1/NRiCinJujxAbm1I6UG9n6pF3FORZpi9wBqL/EDzMrY2IVeOmoHzIilIt3Yswh7pEPeF4HhdTgppN00lPOBMeBrTuPdkIrPmUwDxaJxugHxb9VsnKTU97oXSNEdqcwKX/VbvN7oIlse4p4P2BF9qeV5TPb/oSrZrH7BxlML47Z/ge5bEbPZ/FXKk1/C6AQATPU+leiINGEy2goluB3Z+ZitKpAF8VnVFsGk+YgiUBX29bWgprOJZ2NDV1jL2TYr9Rt4xLwfqMFW/2aDfPok2vTp4Ned/h0zKjnIXNPQ4dvv2jPuBaKUZO0VlnLYhOhHpJgHhSNDjEGldKivhHPbnZpb9D9kjcq9SVhlpobCQ/MtgGATwUCiv5mwUfZtBElDjhuzrZCll/mulJmEc/dhsfQiNWJIW7by1lXFvdMH5opho81O4X4h7Ncp2uLIN8po831CIl6P2s9vnd5BeQax07Wuu9eKDP9M7O+cq63s2Y/GTha9/9ojcqoZm7sYv0xzg2ugL73L/I9UT2SkSYL5LRPc6fGKNw8F90cI9OQNYiu5HWobjOaH5cpnMdlv6tYG7zSfMLKJX5RB3nsdtAw9/+DVs58Pb0OMRii6xS7fABiBm0DDFUrC18TyDLEBURQskaK+EqXkM9U2A/nCSW5imWoVzG5bvOL1Weq83+X01Aa1awVlR2siqB8++oIyVKyCdOexrhknHm7ABg4ZnDhB/Uov4+WAzd91HW9AymmNmL62TyJfPmicuktWjZvMA/4vdFISFn5m59xufvePSFkMcPRiboZHhAu9s+WHcXFNrz7J3UTlMFrpB2OHa2TW3ehQ56u4zvTn+t9lCz2BNJ1loeag7BVUkUEijBQdlVznGu5D9awlY5nsGMAmz/Xikts/hxwQAy+ktBQ6aXzhLXezyxZumojSXPcepJbPhTGH9NLbW+KbhGIUK4yEUDVSJgEsABtYxkPiYL
 xzEiSVtL
 mfKwrHEYEfpYC5RyDiNcvubv6bwc7A2njfvCW7kI95j7rRaFUAN25ZbEQa8RGeVNJeMJp9X9N8/qGD/Cb3Hb8+l+Af1M2NNOkGDQVxvaFiUftqm06kXGTAWG/jYEog2jObJ5pdnnQjfTG+NeCnGSM+U7l3FCtgvZu44u68n5bTVWyyIwMS8lne08g0X/87XWwn9JFPu1TKOOrhresqOCWntI3BTZclTeR0globBba0aOmg77DIFL6wTGnTaAnKfx/vcTc0rhUAqlv4idqdpbzvBtsKCMUOYv6lDY1svXLjF+J9RBSwWivJoRVSuJhH/5z86HQFDW/pKiL0Ri1tAeOAO7X99HTV8/fx27bTFXjIsmT0YmT3aMC0AR7/Pu8+uto32EGFLm30VW5CMW4Nrws6Ndjc4Qlb39D6dMhaZ9E5XijaHA18cXjipARNwDiz5SwW954ddQFeNTJmI1IIuOa0EKgvNxFRsplCb7PR8X4L1HNo1HdVknRTJYG4sQwFmx+AntMQwz62utQRp46efGFiRw9ieYAJb/iJQ9q0XyHXrPzXldh3dbtr4gdlHMt2470pG0310n0NmKRl6VVy3YBuNrdi3rVvxZD5k2n5Kj8Xpb+LxlUkghjrksUDrBld1jARZn/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:47:07PM -0700, jane.chu@oracle.com wrote:
> Just wondering whether making the shift explicit here instead of
> introducing another hugetlb helper might be sufficient?
>
>      idx >>= huge_page_order(hstate_vma(vma));

That would work for hugetlb VMAs since both (address - vm_start) and
vm_pgoff are guaranteed to be huge page aligned. However, David
suggested introducing hugetlb_linear_page_index() to provide a cleaner
API that mirrors linear_page_index(), so I kept this approach.

Thanks for the review!

