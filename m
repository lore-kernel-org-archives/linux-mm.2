Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B173CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4068E0007; Tue,  7 Oct 2025 19:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64D48E0005; Tue,  7 Oct 2025 19:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AA18E0007; Tue,  7 Oct 2025 19:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 940398E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:52:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 274F7160347
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:52:59 +0000 (UTC)
X-FDA: 83972971278.24.9C118F7
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58AF8100007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:52:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U/VLxffN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759881177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kS74sY1O+BpSAvJrceTnPc0y9keMpb6Ghrsoi+xe+ks=;
	b=HGo+fi24uFLnTbzpv648ycyb5p3JfR+wiciwSqUleJ/QZN2CCrbPWcTgm3nPegzPgI7Bha
	jiZnJTOMTkJdxC6tCIqLhOmiQXb3+HjgyGutwS5kfG2KYolceGUSwQnxSf8H9zyZYHUl8S
	bj2GatYU/FbuJgdH11qrNCpBzqKy8VM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759881177; a=rsa-sha256;
	cv=none;
	b=ryb13VbzFyXTkOTWPm5Q3tpkRHdSsB02rYrsVmJa9LI5p+4S6XpHuZ5tX7gshL5J/YVu/t
	8E24PcVgndX10fpAO8hv2M61pIh8coEeOxgbyG+3D4EPUo0WIlTIH3hcoyu4l1ykcxqMf4
	i5sxkEF27PW1if8WBNTT4lXgM1f7CUM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U/VLxffN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-42d857dcf92so27584805ab.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759881176; x=1760485976; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kS74sY1O+BpSAvJrceTnPc0y9keMpb6Ghrsoi+xe+ks=;
        b=U/VLxffNGeNsPt5KK8Thmos8QsblS5t57rPYwi+azr9jm7mmk440YFsskue0U9ja/8
         8HecjjlGrjQA+t5XWqMgyl3C5m8PRLx/naczvy4/Zqf9vXztmwTwA+9Un5dPPFYXz6wR
         8qD0FI2vToS6zV1/BQ+yW/K+K0nHGaWy69gql3g3xJDAEvEDNg8PWTNXYu2ZhPzD8TBB
         gSRHsi1UHYW5PgxHd818SkEk9cL7gdzBLtFjJrbe2CfwbR7sC7Cvg1fgL1SfoVxndlK1
         zmBqH3iIskrZUbsdm2XMX3qnhMSRLAupgKbTKMBDGM3lNZU9TQVNNTf7EGbznNgO88Pk
         2HMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759881176; x=1760485976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kS74sY1O+BpSAvJrceTnPc0y9keMpb6Ghrsoi+xe+ks=;
        b=kT6LDMD5ZEKNtfhAipyG4kdfsIXOmDoe6BzbHfyguI+rwAQ8U6q0G/pQwXeSK9nDak
         VMUNpH2uRbTjKJcliTJb5PIiucqezIIzuzuRt7ObrOMXR2RAQf2iCdOSZJ+An3MNUbYb
         8jC6OzeTW1kCAFPWAoyEiRw0sqGDYAasxh+mwsglqf0Bg/nCVNE6eDk0Xefh+04+gs5+
         N1hHG53+pxGPKmZa/Ebi5AWXV/zTnXvnHEBhvWKc5gn38hMlJjEfTm23qFjjRcMof73B
         l4ivAQVkm0DiwV0JgAO97euosUvBJtIy/SE5Neuq5E7ITTsWSemQ0cuoRvaCG1rLB6VG
         60fw==
X-Gm-Message-State: AOJu0YxSITQ2EQIrUrKDka6gDM9YCK0D7KkcpAVNnfNDn4XbhGiEKDRY
	uD42qJBqHmDg50NmDbVtWkX3+pLnkxA5mi0wjMsxwOpwSZi58wpEobmA/WOib2DYnVrPKwHLLoa
	k9pYtlmMuk+7iHrEwNxJacKWt8V4eU4L3lOeu
X-Gm-Gg: ASbGncs+JQnfI3eeY5ci8RBOmNt4sORgElIKOHDvPkhfjTxL42MRvnfumeqq7NI3Y1M
	DvaAVy1GwXd40cxfbJCEUoZK/K+FSGkZ0FyXBtE6E1uLC8FZSS1aZ2ZNp0S/Jyk3s59i9ZNog+D
	69hmxZ0Er0YyMEZM4XzBmpQrXQwaGHHDt44Kq5wvDu4S+zQI259Q9bxZIkvbIqM4al0qKFsUQPs
	afHbaWmHtIOm3mlEJrV4MWkAHq27FUOUoWV0+7CdQMDfHE=
X-Google-Smtp-Source: AGHT+IGhorzk2+W/xTGL2848aOlY3Nx+slQICiBj8FIH8pICQTD8gFOQKQ61znfWdK6mZ45eCBiZxnfzCGeIUtkRXco=
X-Received: by 2002:a05:6e02:1a8f:b0:427:b642:235 with SMTP id
 e9e14a558f8ab-42f87374f3bmr12991435ab.10.1759881176249; Tue, 07 Oct 2025
 16:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Oct 2025 16:52:43 -0700
X-Gm-Features: AS18NWAzI3OkoEtAtDpIuyhsnz4mBz4te4CIYqMQaeNGgBOGQrrb52ocbOBCeHw
Message-ID: <CAKEwX=PisWyb-Gt=n7ZBPNTNjbRNM5F5j4LE4NoRgTUB+2ZV-w@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 58AF8100007
X-Rspamd-Server: rspam02
X-Stat-Signature: 3r1ig587fgqf4r8yr557tyodnuqdkef7
X-HE-Tag: 1759881177-129930
X-HE-Meta: U2FsdGVkX1/QuqNbXgbDuVlTaS8p6QyoX0/DsbA4Y8o2QN/D2yPs/7BOS6mVXRU7y7SnKlRoWtCo5Kb7VIbZbE78kRG9jJiQ8vg4KzdeKY6ak6l0KxqyX1Fg9pnOPv+qUMn7FOQ3F/NB+au6RkVvbTb1lhGeoNGEKpxXm8+3RxNCHQPnqiW9n3/gn+Enhvlz2jGTJTz8UHr//tADINMuNiXjvwMdrbELixiVsbDVjNowNmHBuOsVo/Tb57wZ0hfNyjbJbeBladvT3MB/OxnFClYcWM2hy+epmLeYfjRiE6ANsX4K1FKkC4xXgihsoeGPEepYa9t2dVe1v2rB4fY0MWRn+18aEPHRmhWMfVcOjJb7dZjhQS0IXAnFqRbm1Ml2BG2Yk6Sa7H7jkUcgzGYkt6m8ycewAJm+Nz6N2n9qh208tDZfVwgaIhbV55EbtnTSes1JyZR5jTuIga37rVk1ESMg1Ya+KTPGWfcSCMUZDevQu+sABdtz57mnlCXBAtBlxClvme32/hsQeMv0oN2ONOrBCzAONHwTEkhq3ZUllJc/SOFskO3x4IzvYRcH9c6lmGbg/IbmlLOExlPKV/Q2z/wwhJe4HcJFsiI2OyAHuv5fVUcg4q1XzVjoSNkpAUocmhRE7uNDJtsBC4S31Ixt1bQQF6Jm7873yQsB1o/xkpnfShr/LMwgD+pn7PBA5QBP/p2qkEyH9MbzCvfiMxiAYx5kQG0fUrvMMd6p6l+o6YgRHkYp0DoBFjfkTdtzuIgl3m9dxXxhwtNXRb0w1s1DPacjmpyuckh2Qv86Pmd9JCKkuZVWNo+aK5NZ2a6eGGSwMKOI99rkKbdGEZuUfLw9hT8b4xDUrotNYuFYyEiylmovf09Y8HHLtglXUADC9EZgb51KCxpBLwGjuKkAeum755E3sqFPLPWcu2yxU9CK1FKVDKcie+yuzJMOuueaHTvSncUVfljpFDHgVnbEV0o
 QRrqPwq6
 eaM/dkqxGIevIi96IxPipYlBNX8JQ7T0zC04MCZi5vIAC8S9LH9uTa32N7Zvd7/YZP0NNfLWp5yps90bJMU4L7Hn4AYEjVaHowtRVJnBro+xevMk7+CLF4Fo3DCATefYTb5BrczWIeH8K0BkgBpL02GALUBXMSQHhLXGi6MOOuygqVAcRnnJzrcjMjqRHZWF46Zc7zRHgy9Tp/7m+mN+uYzSjbcAD9X/c03IJE1bgUeQUxWio+uWiVm+3mOcoa2WFtqmioqXpp3qYfdlsJUnalrDuCMIgj0kr5ed5VYoShfLGhJXIww0J1UO/jlCFGQXJQZ5vO8b+hrlDkittAF/OUSS6uZy+5JpadYq9JVhC/DBN7BulHX7Dr5ueKt3MtAbfAcZekFX644dFJ06xEhQV51iIvBYbQQeY+aO7UOxN9MrsSDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
> fast path"), swap allocation is protected by a local lock, which means
> we can't do any sleeping calls during allocation.
>
> However, the discard routine is not taken well care of. When the swap
> allocator failed to find any usable cluster, it would look at the
> pending discard cluster and try to issue some blocking discards. It may
> not necessarily sleep, but the cond_resched at the bio layer indicates
> this is wrong when combined with a local lock. And the bio GFP flag used
> for discard bio is also wrong (not atomic).
>
> It's arguable whether this synchronous discard is helpful at all. In
> most cases, the async discard is good enough. And the swap allocator is
> doing very differently at organizing the clusters since the recent
> change, so it is very rare to see discard clusters piling up.
>
> So far, no issues have been observed or reported with typical SSD setups
> under months of high pressure. This issue was found during my code
> review. But by hacking the kernel a bit: adding a mdelay(100) in the
> async discard path, this issue will be observable with WARNING triggered
> by the wrong GFP and cond_resched in the bio layer.
>
> So let's fix this issue in a safe way: remove the synchronous discard in
> the swap allocation path. And when order 0 is failing with all cluster
> list drained on all swap devices, try to do a discard following the swap
> device priority list. If any discards released some cluster, try the
> allocation again. This way, we can still avoid OOM due to swap failure
> if the hardware is very slow and memory pressure is extremely high.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast pa=
th")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Seems reasonable to me.

Acked-by: Nhat Pham <nphamcs@gmail.com>

