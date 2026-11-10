Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D156606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoirN5tp
Received: by kanga.kvack.org (Postfix)
	id CBF576B05BD; Tue, 10 Nov 2026 15:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42296B05BE; Tue, 10 Nov 2026 15:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F876B05BF; Tue, 10 Nov 2026 15:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9F36B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BB7880110
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:49 +0000 (UTC)
X-FDA: 85420418538.03.1389393
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7E4AE40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoirN5tp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344207;
	b=NU2t3djrPYN57xlf0vrTVjiwxXV3uxLVZrF9hGEwj3WA9j5aKI8rblM/G5Wp9yslZ8XxvC
	LYiKw4Tumu3l+PsPlogXiztjkt5X1qC1EmutnHFDthboqaDSHw4mEO0KriO0e4zB6jOdCk
	nJLAUO9w42GoP3AOCXRYXxNDrCEz2H8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAcf+yyA21S2XT8Um77RYKdpvm0YZwMn43VtiugNEqE=;
	b=ermGilaGNpcgxd5Fn07xy4qExJjxdKDuC/m6WytnuUyAb4yA0REvBRizh9D9ml/s1pKSVw
	8WqnB+B7W37ZXr6mNUqkjYof08RwZsGGhU2wGxgBCfxtwXsNnQejAyVfl3IZnrTFyRd6IF
	n//dCVWTIxXUj6YjQ3rH2LdPqDKpWVI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoirN5tp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA347436EF;
	Tue, 10 Nov 2026 20:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E801F0089F;
	Tue, 10 Nov 2026 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344206;
	bh=TAcf+yyA21S2XT8Um77RYKdpvm0YZwMn43VtiugNEqE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VoirN5tpPfc8oPPneLdbCOOUSO24a4ksUAR5+qhprY6tsLLxfRDX6pR9FHGUFkAEs
	 obI2Broo5XFS1BL+WddDd9nodNpQP+3M5BRXSE2KDl+Ocm9DcNk8jvYp4k6M0iZb3E
	 MMCAIqzfqCFlQda0AWWkk6trPk0P02HP+HSw25XeMrZCC0ZAL8QAlckAWVBmy27V1I
	 wl6YSaRpD38043bd5At19+Ye/VMnHW5H05XKePcGLosNYBEgllwOyIn6voBFkrZstJ
	 8sWzxChZQT6ygKh+cmuHnzicr70+bG0KSH0djT77ZuOK2uvXcfLvBclhIApN2g9+kI
	 QGLVVOcYWtGBg==
Message-ID: <sashiko-outbox-207748@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/15] mm/mglru: Restrict eviction accounting to
 eligible zones
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261110202025.25736-12-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-12-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:43 +0000
X-Rspamd-Queue-Id: 7E4AE40003
X-Rspamd-Server: rspam12
X-Stat-Signature: ohkm1qu3zxf7qwogn1r16ca9hb6z5f9o
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794344207-635342
X-HE-Meta: U2FsdGVkX19J6bdfKuVH5buTF2kwNctWRZ7PjUatnDP+iEIw1gJojWsM/Tn9T4cvFmVuwGdGhDXecaNJxwMLQJP0tFHPZx4CNDcqFdkYJV46+b0h7XgkybXm8nUfYCPFROUo0TszhKpAut3Enq6sbK5W8pSv4CouLqQ8gIT0+RkeSNLc94Ms6n/jdiWZMfWb1UFhV7ZhIJeBPhoO0njI/phb6Fi7w3AYIEPRrnrpN4S8bUXyCYCbOW5WCYJQNsoU24PZ7QOecMJgZe9p5PFPijqbv0kHQkNaW/IfH2stQHnNfScjxHeygd/lrYEnsUtq9JcPwr1wnVetsmF0JWeuYlmXkx0IS9t8U3bW1LKV18Bdv1ec+ITddMJ5LeH5ba5xw0IE/kswYL48EPR/KcyB/ohF8L8T6gDm4Ew/RgLZblJpdLyGauteVIWHdi1OtXdLqyAyoCw3QRMd1Zxv76Fpu3NVE+ga/a7GNaWly88LdKdaJrEk6Q6t7OGTM+jpgGpl1qvdbunry1tjos9EunWpuh4Mjqc5lUGyl2+/+fHdVKrLhhBUvPzNS2tLYr9OBesxHi+cqlhvYSkSiaGz5Nb/PA/1j/kLPntho7yttyCVY2QYQsVXE9aF0AZCMbgspHCx+jqenGY6HxiuRrd5NlmTPNPDXilNVqT55DTVGYlezAMZ9iRe4/D0gF3AZClFfsfAwmUWk/RZ0+C5SqM6W0r57DkPULumC6aTpTeOic5BAk9jbBKbSNWt0nHMYIaAbLPnMdKhNo08BeQ/KOR/16QRWsEhqKjK76m1BNiiX7um8J1MD/rvbSPYrvanZq0x51brgUAAU2RwSMhQQ37Bc7cYrg2k4fNp1XCoeRiidAunV6pcNNuts0qf4NL51G0SqxSQNtzYzOoPINInB/LDFjnoM1IiSXtUpt3eI5Vbbs0dG2ffWlzS7JxoMT3k4x5q/XhmfCvEsIDBP4MpQ6JsbXc
 cKW4j+jZ
 VXpwZPWE2o/vuBjLYTjiDDtlqIYjRh5HBCOSM5ydJDPI//CZtrzf1ZnJmn7Fji03/25GhMIfXlr7YSsH5DnN4mYWGO05dUdjnHRJsBWUrjZwznSHNxr3H3HVd0lelU4t88jK8jEy99G7rKIOkK3RZeSQvr26tY/VNjJfQBB6wZy3UhswHk1cqH/F3Abw1s3z7k3x41wcpZNY4Fr4tIRng4OmEKl7SI711VwOXUSH9MXEm9YHzMlOAmJOJVyG1/joyH7yR5DTU8ruHehqyOlLdzdHe6dfwQb9AmVH9gbiT5H266Y+/3KNPAMOpZv8feVoOijhYtQ4y5nT3dXGlH/QY4urDvnOoZE/K0xL2e/Q4M2MQDpYrOgOCUJkew0OnfFK32NopC5P/JqnniELfHlmdUPA0sJtzVlztE+gKEfFEEnREyH/3A5OR8DXPmBkPjFuwjYxXcmbRWzuHfVCR1zyqwwVR6P+/oVrNa3MecCjXKmpbmX7WP/mvmzm9x+SeBKdYVBSCVIFyGatiKxwySn3WqHgqvUSwXCu5v4+a7XfxTOkRSOt2A3crgX6KIezB8sJXwiiHl3s5EJqamhUQzP+PfcvmVlZPPRNOAuwSqUy3frAuQ72Fo0A9QEBCfkrbBGM29ncc6OzNFeYI1vEL6hqwh3WRKfOL4rdXTIck020LroQvcq4Yw2/h/uphTPIEeBYQKIHHJfHgG2G6HIKZpSdqQkbgr7PWwAaKkBhtB+3we63IoIR6ZfLgrcmntYw71n3GQ19JCZQSihnkKoOIbOT3CPI5W4jB3g5TZgATLxwyn1sX6LkshVIjrhlwX+gUkSUZK4Eotgol0HVdmZNYXdPTNxAzdBoC+N4aaL6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/mglru: undeclared identifier sc in lruvec_evictable_size()
  breaks build
--

commit bd1d7f7120c80acf045074ac097e502f51cacdb1
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Restrict eviction accounting to eligible zones

This commit adds a max_zone parameter to lruvec_gen_size() so that
lruvec_evictable_size() and lru_gen_imbalanced() only sum pages from
zones up to sc->reclaim_idx.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8014a90e4bc29..bfc9789a999ac 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4220,7 +4220,7 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, int swappiness,
> =20
>  	for_each_evictable_type(type, swappiness) {
>  		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> -			nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
> +			nr[type] +=3D lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>  	}
>  }

[Severity: High]
Does this break the build when CONFIG_LRU_GEN is enabled because sc is not
a parameter or local variable of lruvec_evictable_size()?

A later patch in the series, commit "mm/mglru: Avoid scan anon while
swapcache is low for GFP_NOIO allocation", adds struct scan_control *sc to
lruvec_evictable_size() and updates its callers (lruvec_is_sizable(),
lru_gen_prepare_scan() and run_eviction()), leaving this commit and the
intermediate commits unbuildable during bisection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D11

