Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6976BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C608A8E000E; Tue,  2 Sep 2025 06:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10BE8E0001; Tue,  2 Sep 2025 06:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFC18E000E; Tue,  2 Sep 2025 06:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 976308E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:07:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40BB75CE79
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:07:14 +0000 (UTC)
X-FDA: 83843882388.23.B3D222B
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72C221C0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:07:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BLq+bQBZ;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756807632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrAOpTnL363G+6BC29hgzUSrK5gRlkPfx59tzKZpZe8=;
	b=ogejljEinjcb5nGS657jxZ+AT2G6YNhfRTIzjhWtiA7/hq+sLLCmZIL+hyB85oUR1Zq8dz
	TsIEt2Tu6qP9RiAlZ9GTSw6fEtS6cZqBlkOcPCEXDWWPHsOS8lbwysSijLn9t53r7rIkRr
	WxEE1gjd9z3D6c3H18mut8oUtc91yD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756807632; a=rsa-sha256;
	cv=none;
	b=lCFvqkLMPKsHblcoCi5cbgLlBYZiqe1d6gGzuWGoDDU56GXfy0GSbDBRxCwqgrxYBRHZDX
	NY20GrTQy25XlTQblh6cf0UzcN2o8qftVVYG8qxOULoY5b9un/K/QMoTu+zq5xdwxX+78X
	+TJnFD0rrTODBcTZ01njusAmo0dThsg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BLq+bQBZ;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-53b174ca9bdso3710392e0c.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756807631; x=1757412431; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrAOpTnL363G+6BC29hgzUSrK5gRlkPfx59tzKZpZe8=;
        b=BLq+bQBZRlGqZ3OrziiETdb2xCeYYw+NME5J6NSqOdFzmFSIiyt6sOAzb9rZPdI2Eh
         vSMsW1WEmQM+EzRWfZHqQyGFi7OglDM59Wp2+/XJxytBLZgm3AGaiR73GvCZLxYRqxo5
         ZxgiiRBNNFBG8/MYRfEMvb6C7goYiK+iIaj/UrF1CJBjDUxfnj7sLR1KMsqlc6tGwjng
         mW9HRSeCSUqpw6MMyc7QjdXb6GWrcvyAh9mMrc9GWShqjoIUQ2DfyxQA/qbkWVuN+nQh
         0iq7GImWCcl8H6SKrJ/OsdYAuDF/ukU19VnawnN4r1YwG0kE6AHqPrD5kokioIcKb9Qh
         Va6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756807631; x=1757412431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrAOpTnL363G+6BC29hgzUSrK5gRlkPfx59tzKZpZe8=;
        b=f2CC0rVK4rsxQMM7hzyTKYBRXIqoR5CLrgWwiGmJZEAblxBUnZaLshjQ5QU98AMfT3
         THDJ/NThAv0f0gixAjs68jlUV2V5VQccBuV4c6KlotfxrDZdaZiI6NElBtilL2MZ2+K8
         bUl642StMm9FSSI0N90HT5nOwIB+OiFs4yIatGrTwmDa7P4przvPdF+LWZ3gCEsd3lp6
         zzqCfM5HjupQBGIT9v9O/4PyptcAUHrrppzLsRz+oeYppR5n5a88z1RWtScCZ/gHSdbl
         cgXDLakLTx10RjAsfR+M7DNSOKRAnFggzZsgHEIpyAodWi+8R/31Pqls6aAXH4wP5nwK
         B5DQ==
X-Gm-Message-State: AOJu0YyCWxSimZY+1/A8w4wCcP3bhSwZHapZtZ7pS8SwnSsLE1xzfwOv
	sgnpqR5lX78shwL0Faq27pKmhkmbDpySuvaPkqqhigC9dd76ndJcmaZpIaAW/C/qtI4ypMSzx64
	uvYPXn1VBxjR9pxtL3Z8FzpGtiUysnzA=
X-Gm-Gg: ASbGncsf8aB3dFUmDMw2EcILhjwMvuAgTTbn4mdYaBerfAXQWxymOwU3JV/V4NwPOAi
	U15MXoPfUKgyvCoItKWWAajfOf4FKwCqwexy2npcWGPGDBCLbgMijSp65O/xKyIJ7XtEbY+ljVa
	dn10WJ8Fw1yBMSTIOaAaL4DXctAlQNRLgA4JE6WD2FpZVQth56QILOhOU9Hq20gTees/w8FwFzJ
	5w8Y91fA9Fg86Pa0g==
X-Google-Smtp-Source: AGHT+IFj6WTlzVmDMSvbDwsIF7zaKqomYaay4LaA2X4TYZ0wC13TBbd0pTml2AKOE5bBGAAX9jk0YV9AyGMxwXWAdtQ=
X-Received: by 2002:a05:6122:459b:b0:544:79bd:f937 with SMTP id
 71dfb90a1353d-544a032697cmr3707407e0c.15.1756807631529; Tue, 02 Sep 2025
 03:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-8-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 18:06:59 +0800
X-Gm-Features: Ac12FXzr_QuDNQ1ketQVI0L0O2e5pn7ImaHsrDqHTF4iWbuQt0_ufzEsJP1Vm7g
Message-ID: <CAGsJ_4xNydZqSx7GJ9GfUGaSVERZ2Nj82D5eefMN_Q-OUjnoyw@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72C221C0006
X-Stat-Signature: uhd8j1w34aeyto1376e84i9uwrasnreu
X-HE-Tag: 1756807632-890057
X-HE-Meta: U2FsdGVkX1+3RQDaxqA35WnFgWwWUFZMQX7NIo4iOeshlkfxW1+X89sIYljfZumLsKQ3kjg3zSl7AkR7pcqNDXzTnMvBhCmV3Zth8ljeynYF2wem2mtryAb67e8+NJLdSWCBRGcqFcFWmhWFbmwdO2OZm3sGq3Ey6P7CIKaoXZBsZtxpgh1aJ4pO2H6k1YMw2enGd7h7N2yDprl8TcE3taCiYa9ZOXSq6vn+tLYhRH5iYOIKfkjFhvt8FPI7zAyznFIe7r77A3GSXAW1HgwlD0CNNiTu2AHZUwyjZyyqG9eRfqCxy89dOTm/fg35NafJErswC+GIhwXsEtA+l/qE8OuJ+yB1Gi6PVG7vMKnhMOQ73e3igVaWkqbx9orcSOskr8jBvy79V+GWozeKf71ikJoVebjaksXWndw2RqTjSaiI7EDcjP0Fh4SIlzfl05KXoQlnNHiFO3L+7avdAgTYF/zcpWGGnAA8vWQhf+a833PpzDZqcxZsTMJlLqWU9UaU8DCNub9utZVUAPiAj5MIX6SFsPYtiEGiE7ZKp4emUkf+Yk/8r8MaRtbg6O3pVyZg8dQwsSWMSiqxOzQB9qEcrvig3COWqkTc+zQGOqiV7ICKb33UeVNY/SmBivhEDfMrGpek5dAYNTxaznUWzc9fQneSVwKkKhGo1Y3mfojsCRPMHHkTlcxWGi8o1ZsMUfNhEt7SKchy6IFsyzxU3IFvdWa2LG95U9Lp3Ebcz/XCzQwbMlvpTno7YT2SVguxemVFWkE6xrHxNj85vjsm5ASz/JJtG5EePTrBegrGa9u/vcHWa4bkmVwybsF8ZhzrVxCBJgAoISZPVlgVRWd9wtMe4ay4XTDGF0FHIo8kr9F43ZFg+qw5mhQ5UKxHkBdAkYuFnHLNpUP7Zv6etOzmM8FzIPve4L1uRkhqXcdKAi7gB64CR2kbX1A4fmnGphahJC5ewjBi6bOkqgHNkoe8a00
 0TPbQN4G
 vjbJPlBkkp4L8nItAhkQdT3CvXgkxkAB1+yu+Cxvb7WVvRRI/znu5/W/fgjp2arxlRvqqwm1wtPdnhbnAcN0J9WkKpL+yN0r5snb2WrP0R6eDChPFrMobw+t9YHPvoC98R5r0Df9Zb2tlGmCY4yfCgyolW75J3FoYrkZwXmcBDnc8LIUVThppEx00U9hQ6SM+9H7emAO7CCcKTpgj5nd8C7tCtnC2S+Xz4qIajFAvt5iII2EHfMwXUSzly0CQe2n1xhL5gLW2ShC1aRsSjNowT/So31RLKBXSfPLfFeUA+HxXuWs9AOaC14LQ8kOS/hKkJu3sqhHENdZ6oGd4W14Jn9XhH24Ze18thdANqnlkjmN2iN/S+bg3IpFOVVxTvv+Kd04mjZZifQacPwhztmUcgiEmGtyyjoMsfus0+bAvWnfg/k5ZXCVpdhG/sAUXhsC9YIIg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cluster setup will try to shuffle the clusters on initialization.
> It was helpful to avoid contention for the swap cache space. The cluster
> size (2M) was much smaller than each swap cache space (64M), so shuffling
> the cluster means the allocator will try to allocate swap slots that are
> in different swap cache spaces for each CPU, reducing the chance of two
> CPUs using the same swap cache space, and hence reducing the contention.
>
> Now, swap cache is managed by swap clusters, this shuffle is pointless.
> Just remove it, and clean up related macros.
>
> This should also improve the HDD swap performance as shuffling IO is a
> bad idea for HDD, and now the shuffling is gone.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.co=
m
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

