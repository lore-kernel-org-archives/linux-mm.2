Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01224C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 21:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CAF6B008A; Tue,  8 Sep 2026 17:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6256B008C; Tue,  8 Sep 2026 17:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E456B0092; Tue,  8 Sep 2026 17:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE766B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:34:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB986407EC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:34:20 +0000 (UTC)
X-FDA: 85191898680.28.82D10FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DD63580007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:34:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFzo8BRD;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788903259;
	b=t4dcwUMsoPcXlgPbW4V7Onm4N6mmRGevKAZUlmvMLUtEIkQ+RDsp6nRJXnI9YWljKbw6Dl
	C3FG72Skh3KE3S4UjqdA9ELSbUUXQJjA0YHsRCzhkIsXMD8OGyrOOHAuOWyI23lfZbw/fT
	Vajt3zDyO6rz4OLprjGLDlTX3hPWsNo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFzo8BRD;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788903259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtOJUKKq1jpadgFWEDaPhCFzpzv9SFpwe1VXJg3VB0M=;
	b=T/pTPftmuUyIcWgal9LmaosnIwhOLWiI9l0QfgPXj0pH9OWv/cR60ozh219uvpNIH8wbnI
	+T+q6IktbCtxvldgEq83jBAZYNeZ9h/knhQUozbrCyVQ3zVida+oFPCDEF8Y9YqfzXFTzY
	a0fNVLf1Te9MtKZQdPIdfwAlOECpg14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C84B044540;
	Tue,  8 Sep 2026 21:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D25B1F00A3D;
	Tue,  8 Sep 2026 21:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788903257;
	bh=GtOJUKKq1jpadgFWEDaPhCFzpzv9SFpwe1VXJg3VB0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFzo8BRDbgtNiX+dR3OcDuWLER8t72A9JcFS0olSyJR6CBEcK0yLqR+hB88pZL6/i
	 +UYhGNhKHNyvZB1xRib7IUCA/ym7/+horiqEonjhIJgQ/tJalPgEu6EXlbzQr+coPL
	 e1YfXX1EqhBCGiIxAXqpgMu6Pb/swGZQvYw4nmlMkQZczJkj0dLQkjHvk9Tnbpy1GJ
	 UIicFM/I03TNJXg7W+7gfy/eZLWo1MywwzriL54h9+3pyK03npOCfeReRuwk9exgmF
	 fzvDeaWZQiUxa19yMHidrpO3tJtmvjdy1I4Yzo2wIcQNZsFAsy/JjeHTwj4SMXD31h
	 Z4+EHG66YaNwA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 906FE198003A;
	Tue,  8 Sep 2026 17:34:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 08 Sep 2026 17:34:14 -0400
X-ME-Sender: <xms:Un-gapFhB61ADkoccmhw5zm3p4L_-s0gB7LN30qyJbomNicHe_cW5Q>
    <xme:Un-gavDcwOJrFBXjr0l9ZobFutjRQJGWLcVJQMfUiyoBt3qE3WMRLfAp--Nck0wXp
    nUvvwLve7fDxhaAR-1eFujtdfg_xeP350twh9Sq8It4odAYP0Ra1CrW>
X-ME-Received: <xmr:Un-gamMZ1c5IzQpPpSGXsw383LIVg6OhQXIy4ZWSKhikfdO7hMPJkpD7bW4>
X-ME-Proxy-Cause: dmFkZTFzOLvDypeviElLWOuzJgTrjQKb2l067aPxJf+6YK6KiDCLqa/rTRQ8/WwYVcIAku
    BIqGuq5zN2G8/NEnmldE7QhtDwVEldJdgjTrBf1xzQ/16VTQVQleGitKJ60xXK19fSeF+z
    hccMeomwHSVgp5FuA7vNQIIbZInDXfyOrlXCbtPyZog+XbW/Ig05+azXCR4lassCChfm9X
    f3I0SW/NRHWzmqxX8y7cQRLObB04isVipRyfkuwy9HFXjZbOnYzPvRiDENMBw4svEUJkna
    QO902UB3k5TIGQq2HL+A7pk0VJDbGSiMPbKds126VhPC25WfX460vT2nXa25M4xcJbAfH2
    FIANWinp/UUzAZK5wQy+sUiaMHVvoTNcUkuhMXUxZ4/UqSjS/ozIWInevk3vMMAflOq5iu
    RdkpW80h1DggVoHGTukKCRonQPGHUVSBxhCY663KmePpSZ1dLHOibMQEyMLyehzMotgwlw
    D8SFHPHbpTShehmaQ/Ceg3zkTXXB0mFiUmG7GmAgTBICeLnJ+mTbc2HKKKBlnXThJi8vxt
    YmNkHGczK7N7/pp+qrJqumc5Na+ykqNsRfSp1F15MMU6ajXj9lIztD74FCw3+oWpVSreop
    DqmkjYI8B/43ktuBE7/Jx5r+sMp11Qbqklo7104vlX2VaAHhqPjCB+q0/iHg
X-ME-Proxy: <xmx:Un-gavGSnym1vVk21acKtxemQTjXHz05a_LuwK-cz8irYvPyYaF9dQ>
    <xmx:Un-gaiSgdJ0a4mSbE2mzi02WlFf4JZYOGp5ze04iN2mt2WnG4X9RFQ>
    <xmx:Un-gaq2S_bIQtHBqtkYFxGP9Grv9lWKfGJdBTN9JCNChIIJAVDGQcg>
    <xmx:Un-gat4FVzjedHcbzMxh90GiCnxo9prb0-glfobOJgdr6IKDwPe5PA>
    <xmx:Un-gahc0Q7_251V2quE8Ln8nIdWTysNGIYrb0eiRIuscT1MyJf5_WE2b>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 17:34:09 -0400 (EDT)
Date: Tue, 8 Sep 2026 22:34:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 16/19] selftests/mm: add khugepaged race harness
Message-ID: <aqB-ycE8MlVwZJ7I@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-17-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908125105.1510704-17-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD63580007
X-Stat-Signature: 46x9yw96y88gsyxigcdnr596p7ctw851
X-HE-Tag: 1788903258-420233
X-HE-Meta: U2FsdGVkX19vfKEoKCpiegz2W8PZ39r2uwB77uD7Lemd6B8yy8DFmwYc6CheXhmgNn1whgSR/YU88/3SJZu2XOq57oKLcujmPJDuY6bbaLIeokPozoR9/QT5tqqXeQvB0BQqp6WOpPVqo+DjEYBjy7ED1IhsXQ0yrtWYcuzIWqZVstE6K192VX3bQFTDTfLWK0wTeiaTH7ed8g9xPiaOhEMKiINT3HqCXkRZXnGC2QKe7fVQJyq6p0Kj5s6d0nCZsuOsr3l9iTXXLHm3PY3FTq9rDFxp/PhcJOFwm4XgHBj71RCBJoIrjHg8dVxB1y3HScwUZoJqriaS70YzGqQG/OOgbqYmXCqD75Q3i6IpPp1XiDZlI34VX9/G7iRd+xSYm3mvqeco4vPQCrz/PMg52x4/Gbn58ZxQkh7SR4J0CNLoqxd2lOiQ8YqpaX+OWoll/K1EJNm2QCNxcwHKYMJjjIJ8mn98Kg/BJQ2Y2UfgqCFeMGIlQpUM8ABue0URX/SlSzAfdtTu5EJ7iB/mMPz2XZkImwNlh62WSWZnLOPwqF04fO/sirt9p6pFlw0Pnc+xUogEiyuWQCAvLxTcA645adM5yPz9d8zRvUFwnJ+3QEvy9V90COKy7rxomZpeC9/q/o/vVv7ZpjSFHGOdnxEbEIonRlfmb6AQzbZzRsg9i6JXeqLyFP2SXnb2ApBDqNkWGgGHg1O/bmp8dlczIohIOIJ5ufdB1GdqOw1ML1NwtDU53pgUdelsrJpDIFT7tWA8a6DAcL61O9MW1wPSIhacPSqpcfyIhS61WxxBOXGVMSoNV5zVbNRzWwbkPAFJmkBPgoyR3Zx3YUejrqBsMGs/OhIuE4vE0EAC+74zcq3CgPsvKewwI9dxy7ZKYfGfbYhe6R8Levhd/lemtb1q4eP4QhvDAKomD1rjNCGblMI5Hrfbjc95TkiTpBRlAVYyI5jMITokOTfswtGwXMxx66q
 ar2Uy+vX
 B3xysLG6wKWeTgW7zSkPXXh3W4zdlXSEbRo+rhB04O5VimgnMQm1wNr7HPHCJqN/ZZG9URNhAwrN3ZH/gMrKcZ5Nr5AQIL9kcjw5Y/VWfLdG4zJFr4/X7g1n2oZPz6HJM5DCHWKh3KiwnpQAIx7Rq8PdIlT6Io8TQvDrWhZNtpi3ExmKwNvTfm/HXssoraoXhEdzR6PbuPGZIOC76MTY9ZGvzxLek4vJrf/vx2RryvbaZlTP7eNzvuMy6SmgGXVfieeYRZ7ol+24Kg7QWIWtIxbpBKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 01:51:02PM +0100, Kiryl Shutsemau wrote:
> +static void *mremapper_fn(void *arg)
> +{
> +	unsigned int seed = (unsigned long)arg;
> +
> +	while (!stop) {
> +		void *p;
> +
> +		p = mremap(mremap_area, hpage_pmd_size, hpage_pmd_size,
> +			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_scratch);
> +		if (p == MAP_FAILED)
> +			ksft_exit_fail_perror("mremap() away");
> +		for (int i = 0; i < 8; i++)
> +			mremap_scratch[(rand_r(&seed) %
> +				(hpage_pmd_size / page_size)) * page_size] = 1;
> +		p = mremap(mremap_scratch, hpage_pmd_size, hpage_pmd_size,
> +			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
> +		if (p == MAP_FAILED)
> +			ksft_exit_fail_perror("mremap() back");
> +		usleep(rand_r(&seed) % 2000);
> +	}
> +	return NULL;
> +}

Sashiko pointed out that mremap() freed scratch area and it has to be
re-reserved for next cycle.

Here's fixup:

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index c3478b5123e2..ccfe655b3ddd 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -209,6 +209,11 @@ static void *mremapper_fn(void *arg)
 			  MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
 		if (p == MAP_FAILED)
 			ksft_exit_fail_perror("mremap() back");
+		/* The move back unmapped the scratch address: claim it again */
+		if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+			-1, 0) != (void *)mremap_scratch)
+			ksft_exit_fail_perror("mmap() mremap scratch");
 		usleep(rand_r(&seed) % 2000);
 	}
 	return NULL;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

