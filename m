Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB780CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240168E0041; Wed,  8 Oct 2025 11:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2177E8E0002; Wed,  8 Oct 2025 11:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DD78E0041; Wed,  8 Oct 2025 11:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00DC18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:46:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE6A1BA6FF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:46:39 +0000 (UTC)
X-FDA: 83975374518.09.C11E410
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF76140011
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:46:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KETgJ3Yi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759938397; a=rsa-sha256;
	cv=none;
	b=RSjgYIdZ2GgH6+VMadX8v73j6YjVIkpzIPVZS4qfpK5bDIKFWq2dB58bOLsAVaxVmipzGg
	4GTaEqrvn4r4M0N9J87PRaWTNIL6nFIuyUCpuv/6QNn4Ro4DPUOqU+ooWmixHgcxHw8Huo
	6PQ8Y+jXghUhxCQ2GNYOc5LmuBYBqc0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KETgJ3Yi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759938397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uALLMCIlyUutYsvNGQy4FW1LpvrsNjRGPi60Z2f5MyY=;
	b=3gv8+kEhaEc7SOLLG39W1VzT2HPCnKTl43lbuABGOI2rnGPp0F6UAqVZ/qs54Wv+x3fPov
	ndnGt0jSk53mbqpAfCPVsUV3OqZpdbWGm3PQb8WSbB7IEHZmpkMH8a/K7TfoiD9bLZiTUk
	9BcleUSNyWl+7CxfhggVjQWdd7qok/w=
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-9194a0241aaso310715239f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759938397; x=1760543197; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uALLMCIlyUutYsvNGQy4FW1LpvrsNjRGPi60Z2f5MyY=;
        b=KETgJ3YicMN6kUByhPwwLbWOm2T3f9UXUFD5R3lp1aLmLKYXbMtJm4N+GZt91ynIfS
         k++B+u+LJEMsk9cRxP6FDUig6SJGAdrMxmrRbqOcDgiEBrLbxWxQ48WBZZncoQnN52b1
         fMP7B4EO/nJz5bs4nEQg14LxHoeHehcM0nm/7MOn5xrYJFJqsWVnMTo0PyucN/ti3oxR
         cgNyQqPllsYtOoAeIX3WPijsz/XVCkXa/1qACcVIOpBBMpHqwFxfntPEPKaPDl1SBBzn
         wUx6Ht3z9pWMJsgYETsbENGL95jcdiqkJ331c7504r5yPs5BUIlcy5ElUvWVkb4/TD4B
         K0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938397; x=1760543197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uALLMCIlyUutYsvNGQy4FW1LpvrsNjRGPi60Z2f5MyY=;
        b=PGE6rJxL+y6woJMO51y5dx3xGemBTGQrqMcQ7sOGmG5XVyFTRVb1XJHEEJqk10JVC+
         X9jjHwxoTt0gDpzLRGRcmN/3jz3+Idru8Nwu/xHKRCxL9AUlbHVdi241nt5iJPaeBjaW
         yplnUh6HqenOdaRpevuYc2ngT949pCpbfvouJGHVBPcNk1o1H1gZItwKxVnIe8+JJ2p8
         k0mXtVlFiR9EbjjfPU2ICrlbKm/vEC6rchtXyk0U6HRYhBj1G4WV4R7zFvQmxhT23AHJ
         H17Iml2jw/QfMrEUpcS3PDrPD3Xa/PG6RYfTAfLb6PMNGAIzDm0FsFzxb6G9ApsrLhhm
         IQzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtgaVVsX7OI+e7G2EggaFdv4rozEQafdxmIUObNvXlOtuXnBge/ybR7Xo71Cs1RuXXkajewukWJg==@kvack.org
X-Gm-Message-State: AOJu0Yx1mAdKz/oe3FukedDVY1HcejJ8HCUEncr/BXG4omR0wWU9htD+
	dddzBtnCDtme+N3TPZMF4YHlMPS2IyuPCTOT+QeFoDIFOlWeNQ8rXR5haGz0bZvy5juCcduWIyB
	ZzNnZGxOSjt9ebq20mxte/QOC+lVUxv8=
X-Gm-Gg: ASbGncuucu1qvP23i7wnIGUjqvFdr20curET57lkv5kgfevKtYnWgy6zTQsApR8UR61
	pD4oZVKHAMIUOmzdlq7esKAZ8opJYJ3vUGeGHRXobtleglwH1iIP6dzK6pvH4/c4exq43rIouxm
	9hCgRVhiFd4xOUgZQtw/p8mCXsdnZJeyn+yU15YwH52HQf/rRQNaTLLUslVdE6Uv5Jgwpd3XPU3
	rlWlQelwk5xEeAVYmO2QF1t4Miw
X-Google-Smtp-Source: AGHT+IGYka6zTA7SFt5YtxUw1vvapwQ7jyiIHuZuDS5NfBTlBB/gXvXX1CBMTIglIFvrBhIAspJhAwA0nexvYHYEYgI=
X-Received: by 2002:a05:6602:26c3:b0:92d:99d5:6a00 with SMTP id
 ca18e2360f4ac-93bd1960533mr454130339f.9.1759938396522; Wed, 08 Oct 2025
 08:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251003203851.43128-1-sj@kernel.org> <20251003203851.43128-3-sj@kernel.org>
In-Reply-To: <20251003203851.43128-3-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 8 Oct 2025 08:46:25 -0700
X-Gm-Features: AS18NWB7B1gBQLMeSyYiISK3rWj8HDsB0McGNEALt0lUkrKO71NOSeQ_6dlZKw8
Message-ID: <CAKEwX=Pbg=O5MpZk9s8pCZo807ZmGn8N3WoALykbz68=ggb1mw@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm/zswap: fix typos: s/zwap/zswap/
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, cgroups@vger.kernel.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9hd9bm9uxaapeu3u4zycpjadxucdzczb
X-Rspamd-Queue-Id: BF76140011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759938397-278511
X-HE-Meta: U2FsdGVkX1/OzhE5Ud3xDRgSwglqVqIp6Q1kz7NA9/PCMO8Va+xQjigg3e1OV/oJic4HUn/Ioab/ooOPoKKt7M7zNuT4uf0K58std24+5ZWHpyw3P9z3IQsrbYSVOGVQyOwJeOEFm88km+6QUxps8+iswma6p9ilXQ0mmVEe5Btgaa4xGdc53g537Kp5+IawWWo2683AwVkqCEm9SuY3sWZXRpTfMWEsHpyKpXZwrwdyxTU+EEhcsCyk/dt048j11g7zOsprm6f5icmRpaJ9rial9kAfDoDHyiOgR9tGNWuW5LuvJ9bRfIBK7PK99Bnwhf0pLNKXM6zKtHe8RwtgGdg2iaMOWxy0Hj1nzNnpW+yIIXzM47Qs4xNbGbm8jsjZvcB+yni2wWQmTgyBGyMFpldUv4s+w1Rwoe9Lse+PCwtLWP+WW/1B/AfZk8G3nH/+5O6pQ57VlHXH2HvzL91MzjOIaW1DxBJPqlr4CF7VZnENVP3D7SirP7T8kpZ0kUVB0c+FWCi/BZ/WsB+6LmtZOgnJ7P/RLXCPDZ5sQYiMNl9S8Eq7745RGD9ImmqHfdO9MyUplPjwSe71G+Db+QBxVcbKbTPMf2EbHexzDJMGZCYe9bxeSd08p/zC0qwHaMI2CYupUGLeTnMSjSH96KQmjMYvNT2MIP0dkOVnBKOtXw9M5Bgl8NKR2t28+9pxDeewTN8SgU/16DU0M9yLSArbOkYsxk34sALPMue0zOkmtWsjNF6NBtLg30nv6WbT8dWlJjbyriulWRZIK0KzKlvLl+IYa3d3dB2r83poXMVJxcKZvRciNoiaS2d4QWlm+/LxzU4RmhND08LGX0cYCNlPYd0liH8I1qMA4B2VqXThlJPp8cqCq/WM8hQ/BpvoBNOpO0ocRBCoWBn1UuSTeOBfrHhavqqWqHgaO541b6eShRDaGZx2oHyHLgdqKptEx35kHn8dVmniRFSdHqpclFe
 YcVTjMzZ
 sBydVHP970bHpNdXySMlFwe6sKOfBEieoJUkG2ZDezgmjt+mgVtomUrND/3fzKscJ08/93iSWq9PUo5GaIR+n/b36UJS9YgZsxCo/WRbNv1ojaDfA1qAEcMOFf6DIlNwxsB2HXgmwXjYSmj5RnORVmW8IHalvAKJAFg/N6O8EAXP25wkTPPf1WtG3eOUeTIzVX1wYuPVecYJw+ly3ltHfCDLoTwsfhEuU3vUKVNej6plvuZeyVPS2+rbMQTLoAQb15bB4y83l+5SkcIFQEc2Q+t+wxPrrTwcVHVBHvtysLr/tVdkuZhtUqcbMv0uHV+C2NqcD+KvOGO3uUf5vOr2KH4O1nlInZIelm083+u4J8P/dW90EL9OucglLb61ViAub5rAIbHtM6+G1EamyZBwcVEyyFcAJ3od5ZO0C/abbA+ZyhQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 1:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> As the subject says.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

