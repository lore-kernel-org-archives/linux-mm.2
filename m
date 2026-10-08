Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581C6CA6004
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D72A6B008A; Wed,  7 Oct 2026 22:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1889F6B008C; Wed,  7 Oct 2026 22:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050D86B0092; Wed,  7 Oct 2026 22:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D02036B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:27:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45D83C03F3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:27:57 +0000 (UTC)
X-FDA: 85297873794.16.FB7BEF0
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DCEA40002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:27:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gop/k4U7";
	spf=pass (imf01.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791426475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrXlWfL0sTc52Kvx+LtccQ+F2NsmCMYUwJ2EU4o8Vus=;
	b=BwYC1/FjItYb1QqUy3SOvPMf5WnlQSUk1fBCDlfE815iSEfZHPq9dsVDPLWIfmx++0sNb8
	3fEiaLLi6kqzDRtB6llKM6H9Qx+LNxoQnTwkzh2OHfS1qx0LiLFAuavatw0yB+zR4XZPZQ
	2uwb4wzzr4Iki7+2vrN6kIKrwblybDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791426475;
	b=robsCdoeektS6NiRyPcVm94wlqHYxw9ciOZqT/lMGEXvWgezFvbzeRSlyDbkM3n5qIx1vZ
	oYScuL0Ci3KANL5dNnkq3SXj2vSeBxVQc6DHgS11OitI4l52xE1H8lmlO2AKOAFxtbYXF7
	NWXx/b4SUdzZ7KXlu2d+AFQ9YZk4n1w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gop/k4U7";
	spf=pass (imf01.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3282db206d3so29791eec.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 19:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791426474; x=1792031274; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XrXlWfL0sTc52Kvx+LtccQ+F2NsmCMYUwJ2EU4o8Vus=;
        b=Gop/k4U79Gg1+pYOyk7fAo3n/MqIZdtjIWB2dm7NVDbo4XxHPboqaHIPARS1YoBX6j
         8JPwRZ24nmj9D6VRvFP+rfvjYdPlS0bnuOarb7X9aRXXivGeSfTwS5rVhcGDM5qPe9hA
         SifGehr+g9rYMvyVhNvm02wiuwgU8rMzVFsm8nDHQT010+sBUKyNGrZs9v5VGj8pXLlh
         i0Ss94VvYQb7quj1wpkfIMma7S2admaUBmRgnhLgIOxDXW2qoPDyOEa9sHbkxqwn5/wU
         Z2NR7ipga3qKNwIqnBhXhUSnNInyIjkzY45hKYDAl9THVoVybfVp1DB7c54a+CYlmbND
         F4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791426474; x=1792031274;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XrXlWfL0sTc52Kvx+LtccQ+F2NsmCMYUwJ2EU4o8Vus=;
        b=z+0i9yzO1rLcHAmYkMt7Xllvz4gKtAUeWlUR1cFkMZiUpIxGuGSgz/L9zclK9seFti
         4zf4RPgADwsnQWE/KABCOmspBCi6ecMhI06BdYo7zhph4T93bsOEg1xEuG2rj/tLGHfy
         1Yyv7+S/4HmsIyaoocjEz7yFiE81CkiL/S0fVvixTjGfRwupWQrf8rkdLuKqO4Tzy5Se
         UrMI3Spm0VENl6H/R+Hapk/0woi+ES8X2ZopZap1ZCChP0cn/VBvyKC8XdRS+jF2sbus
         qF51jH3IF776lOzy839iah5qdNAhGMYq4+Jnfc32ToX/pyuqvL1CrhVmmtfJcb9DUvn9
         lPeg==
X-Forwarded-Encrypted: i=1; AKwUvByhdlIKe7igazqtbglqWcxpj8CnfbGzckNZxWiazc/0X1ZVvGcn8IgImsu/NfBZCNWij5czdXrTLw==@kvack.org
X-Gm-Message-State: AFuF++m64uApSp170KsifCurUWVFkJVNSFdg16j8CEkS4XnTHS3x0SwV
	epvcTcSehGC6nSnzSXxQDXLI311g803H6sELsBpjhRLx9QXbQbsdlqKS
X-Gm-Gg: AYBFou3c+wfpzVSvk2nXDoL+5jArb3bVLZnwGSDCyJ04kwnIeX+rUnMXb0ySSFBT9RG
	+9xfoHCj00qxLP5TbjC1nRa/bwi2Tpdc1miqlofr284aP4X5O7+y6r5acDPVqMb6K5dcRcwbJvz
	3TrDkuckEq8VINHDVfJwoR7my7V4lCQjlQWpT3ipj+ld2K8nHEduo0m7RxWArqKNiac5lBaN2Q3
	hvbNO5eV8bx31JtWXjQQSIAiHCs/glpe2ttMMLCdy/PwINo99cW/bOsNiQkzHJoCvFOAxQGgkfj
	YFoxcxTk6CSclRPGkO+ODMwNfcJnXRFY/foWqVIqccTTdKwKd44Ybty+vEytlZqkMeYtxzTMNH2
	vp5zknOaAkt/DC5Q8rgtCryPQ9jaFgnaEIsp32A9UCkXRoBNiCMxtQn+IYUdKqnFqhXiC3jjdjb
	DAipemT2tH7D1uFgvGU2K6ULTXMn0GJUgvfvhNeXMQHpIiw7c9wGhtmNdbBso49V4IIgpvOfn1
X-Received: by 2002:a05:701b:271b:b0:143:2984:6518 with SMTP id a92af1059eb24-16209760e7emr4246517c88.39.1791426473966;
        Wed, 07 Oct 2026 19:27:53 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16166121f74sm9367598c88.5.2026.10.07.19.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 19:27:53 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: walk runs of consecutive pages in do_pages_stat_array()
Date: Thu,  8 Oct 2026 10:27:48 +0800
Message-ID: <20261008022748.3349345-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87v77ggu14.fsf@DESKTOP-5N7EMDA>
References: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com> <20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com> <87v77ggu14.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6DCEA40002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1f6jqwt69dyprgk5c7oqgsfezud6973h
X-HE-Tag: 1791426475-855496
X-HE-Meta: U2FsdGVkX19bfMtCluV1QPsCahnKK5jQ1pSv2KAOA1p1M5sPEXV/krn5L7jJ7NgbYOg5Cil7IetsQOZLXGpuyP469ndcFi2Rmz5gOyMGTsu4nk5TT9UFoyYJ0g3wTlLLqlScVLQRAKVIi01L6RXyQR3LYSzYwAH1tTMwdWyJ6kLy/6bQANVSSFAN0wN/lCNuYgNNOx4hE6wjmaPQVxzbic0TrK3l4i2vGWRBJsapzFejgYRrtb3odkA3FLSHcgNbcKznogmbThKrG1F9VrIRxNk11fY2ai8aaUOpD7orVcNnv76UZsj5FO2+xsqe35ZKF7Gf1xPEEtPBf9Ry82EgXeZpSrlSWrV6maxvG7NH7rwHjWlbEuO5PBG//P1s0qAZDxG2gPLZMEG6schBnb4fU7ki6xSimmVRk23s8oQbu+6gnEGr7SgG8FINQn09MYSp7Rmuh4SuGSjGNrB2X/HEtjVS803kd+xIjFcAHrw/RU5iuv1BP4jUwgIHRPB4ZnwJQNrILQWltlVXV5BAHW+i1SgnTACVhY/nEHp5I2WQ1Esxud8P0ILpYVHYcvtiCZJE9G1bydSArraJVCZ9zO6tpUmv57rFWLZtQir8poDdZIT0TC7DQzx/tC7RK5nceeFbDebJriJqCRDJxAydSVHmClFYxPTjZdrqTIQlKL99gW1+yfzesIpKmalaHd0ZrQpoUoAPBbFxwWjQyhzOE5rxQdUyFizvXjvAkpZ7G8FtSZfVGG27ElMMSx35F5Nm41mvHzK6YF8bxHeWaB1sT7NTSXERuqWZHRJmCW4WnV3zOOyaqVmgRmfqgxspKBCQC+MU2Ddqhbwr7aSb9ih9m+yVEhUZNAPVKzbV6445l7mllKX5QOpArREegyA3I16E76MP8eNJeNd2z2JzOdrxuLP9znE/K/3oTU9nh5oNFCOrdqMHwMuLTpkcEbYcbI+RziHRithDS3cTar8xJcAfKp/
 74FtpJlz
 VuImrY9gASPiF0k1nZFkFjDBddLRJHU2+Yf1dH/uXGzrkrm8nzU8MKK0hXFTBwVvQgFDZh0EOkWV62CYsr6iigm3uMG8p7xhWM/yrT8qmuuPnRRb86JFThEfeXcuUWV8qBdak3bG48MDzQOkIwkiAe3tUV20tnhL7ZCDjhlopx2HGspdB+sBfn949pKrR7DTzBeEJd7Db8rk0FuVIEnjB55CcrDhBljDPHqLYxuCXwVwMdxqyTPWwYLeVVwkUqcPM7nBM9OxckDeooYN51az38Y1nvMQNcJD2SXW2LNsu3mKrfWBgBCn6ulNp6Y7O91q2VuJiCUWltPGodLr8uLidLw4nFKSyKdnjn2sFbni1hJCpSyOjnYxCd3WLPKkDUqkf0iPEa5URJsnFXZdoyuRhTB3mFEfcr3oarKig6f1+3B47zmYKO8pVKJN+YmGe3YTcLNAzGymNc3QQN8YDequOW8hZKLJmX+xt/+8jARPR59ZLHvQkj0K8uZXwEQ64vGmKssMD5xouy2AixQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ying, David,

On Mon, 05 Oct 2026 21:24:07 +0800, Huang, Ying wrote:
> As pointed out by David, nanosecond-level optimization for a not-so-hot
> path isn't very attractive.  I understand the target of your
> optimization is not the performance of a single page but that of a large
> number of pages (such as 16 GiB).  So, please describe more clearly why
> your change is necessary, for example, by providing the performance
> improvement of querying 16 GiB memory.

Right, the target is large buffers, which also answers David's question
about the need. Mooncake, the KV-cache store used for Kimi serving,
calls move_pages() with a NULL node list on every 4K page of the
buffers it registers for RDMA, to find which NUMA node each one lives
on. Its issue tracker reports 216 ms for a 4 GiB buffer, and it
registers hundreds of GiB per instance, so this query alone takes
seconds of every startup.

Time to query every page of a populated buffer, with the two v2
patches applied, median of 5 runs:

                       before      after      change
  1 GiB,  4K pages     27.3 ms     3.2 ms     -88%
  4 GiB,  4K pages     109.5 ms    13.0 ms    -88%
  16 GiB, 4K pages     486.1 ms    52.3 ms    -89%
  1 GiB,  THP          23.5 ms     0.5 ms     -98%
  4 GiB,  THP          95.0 ms     2.1 ms     -98%
  16 GiB, THP          381.0 ms    9.1 ms     -98%

> Additionally, the raw performance number depends on the system under
> test.  Please provide a little more information about your testing
> system, for example, the CPU architecture, generation, physical core
> count, etc.  For comparison, the performance improvement percentage
> would also be helpful.

The host is a 2-socket AMD EPYC 9654 (Zen 4, 96 cores per socket). The
test runs in a KVM guest on 7.3-rc5 with 16 vCPUs pinned to one host
NUMA node and 32 GiB of memory, split into two guest NUMA nodes. The
test program is bound to CPU 0, and the before and after kernels were
measured back to back in the same guest.

Thanks,
Qiliang

