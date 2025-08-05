Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1116DC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 23:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945586B009D; Tue,  5 Aug 2025 19:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6C56B009F; Tue,  5 Aug 2025 19:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E53E6B00A0; Tue,  5 Aug 2025 19:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4836B009D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:26:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6878C0298
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:26:37 +0000 (UTC)
X-FDA: 83744290434.16.B62F40A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F186AC0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:26:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlDK1A+R;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754436396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eu1HoDcIMmqz13xDctCg8QO9XvYBfzGyOl1z/kKRFQc=;
	b=jr+rxuKEWyAY01GXLgKJhLmw7VMrv+sOUyo1gOMgyvTPpqCQ0DQt7gQ9Vzja15BLwDofcz
	PYjn6j8sO6sHfssQ+YW6YB9i4RAHrfdvczX+xPYq24qknArWdo8bfQHZg9I8BolM3P/oQb
	01i6oEnSf7tgWSYgOkizlvyEb8MQF1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754436396; a=rsa-sha256;
	cv=none;
	b=XIkPW2uuTpldKEcu8u1dToePxyF9mNs6xmJF4YsQ9W1PjTMgqvAYyA/ZNXiVyhglqhPke4
	3Is+Nq0v8XY4yhr81NsM566Q4LM9x8DM0NsucMp95MchY9Zzg8xdMUA6d6/Qdq5UBMtNzM
	Pfzd2pcUqSPbN1tgRyoFSMqAQQGxcgI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlDK1A+R;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1334E601D5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9DFC4CEF0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754436394;
	bh=uZ9KSLAM22NmuVTPlZSaN9HdVrPy8DkN7MfM40PX2Co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OlDK1A+R4jKs1AEnPUuAnkCz6mBdmi6d/oVC5d53DEphsPj5YuXIk+R8ZlESgi3PU
	 KZMryGGzNmHY68QU2nnD37JWivzwcfhg5eJeEq5Xq0p+mVl2YGXojoJlS77mHo32Dj
	 QIr97TzvnC0CWBruAQ026knmrCj5Fw4ePebI8OhKwY8RmAjvXxbSi+YYR8I2xpBEAo
	 GpVMgpbYGOdErhkK8oP5yEhvMfkovNI10HUTjhF1730CJr1lDVyQh+3JreZEaNQOal
	 AtNQqMRkP+Fvc9qsnLjbUZp+IJfC23UAhjy3AqHo0p1aPoI5taWrHro+rtZMRFXD+k
	 3wN8mfFNJBwYQ==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-459d5ab32d1so38065e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 16:26:34 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy77HlNLE3LHWlifxdHoHjQY8GuvTRcdZeA62E+GqeSEPCtDO9z
	V1tUNm5YdQnvjNFqozUobGigtxXiCrY9IUNnRGoQKuI+sUo+GFDLHoYqleY2tAqXA0wbhTQcRYf
	s2UixoUPcv6ldeh4O8XHgz7Bq0FHxIC7haC5WMCKh
X-Google-Smtp-Source: AGHT+IHANGKeWbwtq2oqxC2twxXrxdNSmni6nCnon5N+Tvdfg1aAQwnRcUtS338ORFG92LnvvcEk0nkVjtsXc2pfMlk=
X-Received: by 2002:a05:600c:5494:b0:453:79c3:91d6 with SMTP id
 5b1f17b1804b1-459e74ac34amr252325e9.1.1754436381085; Tue, 05 Aug 2025
 16:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com>
In-Reply-To: <20250804172439.2331-1-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 5 Aug 2025 16:26:09 -0700
X-Gmail-Original-Message-ID: <CAF8kJuO-kVXb39AU-gFVYG8VOjfdVind5J28KUpeXHHPA4UYXg@mail.gmail.com>
X-Gm-Features: Ac12FXznNun7ApAQ49rWYq0WNDNOJnAAwm5wdO8vxNdnPZsqi2jr3nYvcCbtD6o
Message-ID: <CAF8kJuO-kVXb39AU-gFVYG8VOjfdVind5J28KUpeXHHPA4UYXg@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm, swap: improve cluster scan strategy
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F186AC0005
X-Stat-Signature: pgzfsix7zp4qdzb56fnegu1m1g8w9mwt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754436395-298960
X-HE-Meta: U2FsdGVkX18xV/s5n0M+kB6eSFrCqPwqk9t9LonD9GUd4hkWyChRakw+5TSbqpsd0XqVDUUXfsq1UY9N/GCAQb9I7PU9J9EWYNwFn24VKXrA7HcFOXbNdKydTu3nGCzLyAjB3Rwy1cjyNTDL0usT2pXXahFFk8f69HkusqLt3Wa5jjh6fBCQjv/gu+ZKevpdHk4kEFc7RdtaEeoA3+5MWgH2egvM1/ywf+OXlwwt0wXyUhZmi5z9+ZvKu2HNqC8hutcBw8567eX5H0785kzk4qPRTE9cHnqV0DsujPBDlp8nmpMo/b9x1aApEL+nbMhNrMKNyE0JWr3ByT8Yr/eke7G8TMhGJ6whjhXmqiHwaHJmbf0J7MSxxJtd9Y8dr3KWQ4WRaJaUZo2zHY9xfnidLm0KAY9hh0VPhFDp8bpB38I4TfDGF/h9MEelNcnPghJEszkMe4VhUOqBMXvrcIdU8RpWzg4e/zOiSovpc+Lgj+e4mCVvff7qsMo2fLrwbT11wqvxiF80pnszPzAxTWons2E9CnbJm0Kmcf4weiQpVUt3iwzRzyH2dBlHky7MxTJqqYlQHEtdRhSTR/bu9Q8M980R4yrqcrDplO14V6VLoe19gLXRykyhDVyZ4UtsLKtcqPNjGtsI6eSTSA2c+8l3hXfNsZGZFk8gmJUBhEBabwCTmNfcELFjZEFw64MNSoeVL4KeweworJZyS7Lqi9weHRauSvvxZTDtbzbb1XMeVasqODDNxDcAUlXo9VXnt5933wQVZpg3z4yDVCxHiFqQRaQAT1/Q0QT3oMwybaLYKf0hP4BUQ2nOFbdc35SkdlSw7gkEQ7EoLKFiC8NXRAieuxa9B0YZc/mCDY0wAFlgPaNFbrxGGunO4TEH1U9AHK0mlldNSgZkimcPJVQAYIlcgBYa/t7VZpLM6UGmKb9Zt4dJ6b+kbg4fouXMU1zLyzxjp7CfUTYkyFxREGDfxPk
 iUV+XM06
 TJp2l0/SqzmAYf0qDGXL7vqQPdzdcZLxfTpX7GrxiLiBelUHHLzp2yxqbvLuI72NYWZoK/Pw+5SuP+0+i91gZzDs8G5p4Ua4JgStsmpP6NInPSsdn0RwDV4kPytQtfNjLXRr9iARtQJb8Oqko+cujr1uGDbuLHueFWkaX0YMvuPdDa8kVmC9/6rhm9DCHBjFvMOkKVewO//J+KEc2ah1bwxvTWHkmb3dZUB7fJiu68ztSdclKkKEI4NrEguR88dh8oarH8bGsuOjxj4cGXI7hNBBXtOQ5e6qGI8Vl32gvWnaivyAgpi1EEgZtLezRGLaive/IxLSMfKpqReY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 10:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> This series improves the large allocation performance and reduces
> the failure rate. Some design of the cluster alloactor was later
> found to be improvable after thorough testing.

Nit: If you have a next version of this series, please include a bit
of detail on how you get the improvement to kick off the discussion.
Right now the cover letter just said I have some cool changes and here
is the number. e.g. limit the fragment list search to the first
cluster.

>
> For example, build kernel test with make -j96 and 10G ZRAM with 64kB
> mTHP enabled shows better performance and a lower failure rate:
>
> Before: sys time: 10230.22s  64kB/swpout: 1793044  64kB/swpout_fallback: =
17653
> After:  sys time: 5538.3s    64kB/swpout: 1813133  64kB/swpout_fallback: =
0
>
> System time is cut in half, and the failure rate drops to zero. Larger
> allocations in a hybrid workload also showed a major improvement:

That is a big improvement. Congrats.

>
> 512kB swap failure rate:
> Before: swpout:11971  swpout_fallback:2218
> After:  swpout:14606  swpout_fallback:4
>
> 2M swap failure rate:
> Before: swpout:12     swpout_fallback:1578
> After:  swpout:1253   swpout_fallback:15

The number looks very good.

Chris



Chris

