Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7230606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9I9jjzt
Received: by kanga.kvack.org (Postfix)
	id DBA4F6B0643; Thu, 12 Nov 2026 22:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B746B0647; Thu, 12 Nov 2026 22:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59196B064B; Thu, 12 Nov 2026 22:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB266B0643
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:19:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36059A71A4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:19:27 +0000 (UTC)
X-FDA: 85428640374.18.C052D74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8921AA0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:19:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9I9jjzt;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539965;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72v4ImOjPkw3MFtGjNB0Wa1avDJa1IMYb60hbfYFdbo=;
	b=JMH6DkCPtPRB+VdX3WdX8YfZUUS/suqHQ4h/W9IrSg7/UN1LFIy330dXpmbR/BvERUeWaD
	kflz5H9i9+Mv+T9pOwDaUKfRiqY0KNIMV6hQgdXXZ/bAfEy2V85cKWSFa64RZ0M8nJ+28f
	yMGxiRTMTTAzjTsncRNCTQmJCNKngPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794539965;
	b=Mkq2J1eCwOSx7gM8od7B+c9x410EvKFy+IK1/gUmYIOIYslkanjCJayT0+kBcuaPnsNzJ5
	KK0Dm3inLqspO1TujCatmuuRQET9LFWCEw/Kz83SW9ApkgGLSDHINCyfxLpqXt+dH/LBqg
	ssKxdbKGxfPd8e315VIhNrFZUcS3g/o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9I9jjzt;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFEEA458B2;
	Fri, 13 Nov 2026 03:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FD41F000C4;
	Fri, 13 Nov 2026 03:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539964;
	bh=72v4ImOjPkw3MFtGjNB0Wa1avDJa1IMYb60hbfYFdbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9I9jjzts8ylOOFpF0LgUW9bXVhdHz75JKV1pZqOPQBhhDXVCWl+nFewEmtCZL3CP
	 kZT0QVdxJG5VDW8k98bZ9ozAMUo0OhuiqkFyalTG91mIaDUekzN7v6kFzJJ2vOA99j
	 ZJre4tTxg0whQx6P+dXtHSHBsY4zXus5Lf4r+RcFBMP9YNzYYrFlI/uzrROuOTI+0s
	 5gRu+0Kha9BvYRuMW8ss15lCfGI4HgDe56ARt75Z/OQtBMB7pvoIUSbZwPaRHBEsNC
	 Q3YIFDYhCEgFv6M79tvkX/Un4qriAd/B7jbH0m4zrVfXkgka/dUioLcYrVvqqpfmvL
	 4s0R0I/sn9xzA==
Message-ID: <sashiko-outbox-212131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xionggui Chen" <evers_chen@163.com>, "David Hildenbrand" <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Shuah Khan" <shuah@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, linux-mm@kvack.org, chenxionggui@lanxincomputing.com
In-Reply-To: <20261112031811.56500-1-evers_chen@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 03:19:23 +0000
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: s5utzi4oj4mwtrb4xw5sffph97uw7mhy
X-Rspamd-Queue-Id: 8921AA0002
X-Rspam-User: 
X-HE-Tag: 1794539965-591984
X-HE-Meta: U2FsdGVkX18L715ySnm5pXktkzHhSvfd7S/Wk/qwLL/TtgZyxLj6BtUCnvpTt72rhm2q5gSSsPWj0NpH2XRqtoW20fDSR6VWpcOKY3kYhzUlGbCrYnWhIwceO49ksTsIF1UoKIOgIWAg11ZEYVzjOstj/MKTBXXbf/NCH7/0gtYheDin82uRSHj4qJ/94eVOBtSQ+DDowjoDC9tSAdv3E88Y53w/Eiw7sC9QDC0ftssEEyWxbw09QZsLCemnm+g0fpM6rwSWUrbpcICYs+GLMNuefqT5Agx6338X51wa1OGu8Ee0IvOBp2mKGXcbH+1DK4CeuHtd4i3I0l6CpOWvPJEYB0iN+AHNF7DsMMwLjt+J9rvgp3N+8mfQ+vUUgcbLqak62RirJRzL/Y7dDLkXufNLYqAUqa9Lrdnn14ITe8M4NJPg08uQFBtCtaWfcL5InKhlJHwTAEa0/VfDnbosool5uhGXemKCtdj8Ghv0AqHjKy/sczVi+BtrpXJpCP2ez4oaZqhI4E9TCWD4WceBW295PgHN/uXlAINZMbX/dP03OkfR8XmPzNkzqPjE+suODzjNZfWhbSrTJgYOwz3fkzs2Sl6RCLDSKHFGCdDThn2I5PRRsgwB+uGdNLwPI28bU+AHhBSaGHg0riitYe7L9FDvFqf1bHBEMwK2zJRQ329IZYNehP/hczPYjaszyWDgGUmPuYLTwrbUmJ31B0AmuEelcg70MaS5nBj89rVKdEWj7YLS0WyWuBu2W50CWbs8wNcCGGVk0E1Uk42Fat/NXyLbkm4XNvZh9qd6cUmc4oONFoYfffyYIomz5L72/lf/CyBc3V56Tuhn3nXsUBHqR6i/xlbuniixjYQDeomcFxhdS3ijCMsrtKDavrR60IuaN1tyImA3WZkr49eLtvIzuag314TpSP/1Pdfyf8e30/dVId++aS3yLhflN68AfuQD0ZYaD/EbZ+zmftuxwqE
 P6s1fl6H
 ur1ExgDvvhCK1MW7+cfZ52eudyKU+yAoS6ATH0XC5It5Y0H6AfwMV+22zONuiBjUfbRNan0vMTBiQgs/8ko5w5RPmirkwgTClVZIYnNEbht2t1obxP1EhO/IVibFVVeTQlJ3Ao5Xu+PIMeIbPVl58QGwBG/N/XYemElbJS4m3H0KNMRt5RM7LU6P35SflJmiwF/aMLsfSTp73KutkBXVt59i20y6cKj/yuSxcOMi67GWQAWjrGY0pmT7TK22GPSNl1qknqOMDOAd0VikzCgjyv32oyhAwJNAFItoVvnyb3DqlWvDmHLT9AH1w8eouCnvVOOq7A2zrDBjjbANH6lUE2ZwdJ0pDwmwKbqSShCpmkE/w7lVzE6qXcegsCXOQTU0B/LyH7nTftVPeHeV4ZV+FPN6hXPj1iD0DHCTWLIjxJozM+AlGwrd/Qg7n+Bi2NnUDbiR0SJcjHEB0u82bhzOS3lmMxvPD3WtoGKpFQebl4qX3oDvpd0ufl2t/E0gGrboERS5waknfBlZFBFM85iB9tfMB/zYMzY15ZSCzu9tuJAIfPi2CTg8owwfGwwKw2ZFPgZAtcG8kpSM6qGBhkQRQ6GaZxXNXF1bzdE2/gHBjvifUDWzy6FCQqeq5Wg9OCwsjumntjtmi4TmpaWACibDPXlxflB8e7d5FJXXzbq32iYPjkyRlZef0pQDGp6yAI8KSzD68
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests/mm: custom /proc/self/maps parser in
  mapping_is_readable()
- [Low] selftests/mm: missing Fixes trailer for test_prot_write()
  failure
--

commit 3592bfa7e9663819c643afaf7d6c337f6b102d15
Author: Xionggui Chen <chenxionggui@lanxincomputing.com>

> selftests/mm: Handle implicit read permissions in madv_populate
>
> The madv_populate selftest assumes that a mapping created with
> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
> with EINVAL.
>
> However, some architectures, including RISC-V, may implicitly grant
> read permission to PROT_WRITE mappings. On such architectures,
> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
>
> Check the actual VMA permissions through /proc/self/maps and adjust
> the expected result accordingly.
>
> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
> with EINVAL for mappings without read permission.
>
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
> tests, while the updated test passes all 17 tests.
>
> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>

[Severity: Low]
Should this commit include a Fixes: tag for the test it fixes?

  Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRIT=
E)")

> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/s=
elftests/mm/madv_populate.c
> index 7fce5d0b622be..818f99ee20041 100644
> --- a/tools/testing/selftests/mm/madv_populate.c
> +++ b/tools/testing/selftests/mm/madv_populate.c
> @@ -69,10 +69,38 @@ static void test_prot_read(void)
>  	munmap(addr, SIZE);
>  }
> =20
> +static int mapping_is_readable(void *addr)
> +{
> +	FILE *maps;
> +	char line[256];
> +	unsigned long start, end;
> +	char perms[5];
> +	int readable =3D -1;
> +
> +	maps =3D fopen("/proc/self/maps", "r");
> +	if (!maps)
> +		return -1;
> +
> +	while (fgets(line, sizeof(line), maps)) {
> +		if (sscanf(line, "%lx-%lx %4s",
> +			   &start, &end, perms) !=3D 3)
> +			continue;
> +
> +		if (start <=3D (unsigned long)addr &&
> +		    (unsigned long)addr < end) {
> +			readable =3D perms[0] =3D=3D 'r';
> +			break;
> +		}
> +	}
> +
> +	fclose(maps);
> +	return readable;
> +}

[Severity: Low]
Could mapping_is_readable() reuse the shared VMA helpers in vm_util.h
instead of open-coding a /proc/self/maps parser?

madv_populate.c already includes vm_util.h and links against vm_util.c,
which provide open_self_procmap(), find_vma_procmap(), and close_procmap()
(exposing PROCMAP_QUERY_VMA_READABLE in procmap.query.vma_flags) as well as
check_vmflag(addr, "rd").  Reusing those avoids duplicating VMA lookup logic
and avoids line truncation on mappings with paths longer than 256 bytes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112031811.5650=
0-1-evers_chen@163.com?part=3D1

