Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3220A606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K9DazTgq
Received: by kanga.kvack.org (Postfix)
	id 471326B05B2; Tue, 17 Nov 2026 20:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448D06B05B3; Tue, 17 Nov 2026 20:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385D96B05B9; Tue, 17 Nov 2026 20:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 157096B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:53:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7540516062E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:53:50 +0000 (UTC)
X-FDA: 85446568620.30.47A537E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6F4DC0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:53:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9DazTgq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794966828;
	b=iSb7eeOL0pg64nYT2R5NNaj/umvKHVtZlSUzC/p8bZBM6nc8BPicQNj/iJZBix4YsF35vh
	MEf0Qz4GLaEOibPY1SeqsxNYir9LNH/UEmfTDyfK67Ox1ghxerhFWPMqjcSp9+t7RHyLNu
	2RRzER88Brbb0m13Lw0k1PNtUFu2ShQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794966828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftEokabaZG7Wg3nlwTH07C9whZDOJt3FfBUJuOwVvUA=;
	b=YR8nEdmaJ2eIyWAVSOP8DlEqFe8XHmGLOKhBoZBHZCC19kM9gBPf4QknoKegi4yRJbtW47
	yjxqdnbHibr/y3NVjtxcxqi9xdEEQkfQaqRVsnBrGQ58PafM32ejwHZkz/NSUFBPCEDF36
	bE2PpAng01gtvX2dgouYzv6i+kyPFNs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9DazTgq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1190E40D78;
	Wed, 18 Nov 2026 01:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357F1F000C5;
	Wed, 18 Nov 2026 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966827;
	bh=ftEokabaZG7Wg3nlwTH07C9whZDOJt3FfBUJuOwVvUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9DazTgqbQKHgVajtXTFzbTQKVx12pPjQm+tfHT9KrXHFThADgzFOKResZyT2ZDKi
	 MS7XL0zgHSMNNDLts0JOvcdaQdpg69P4Q5Tsgm2/Vwi5DDCbL9mL+kw8w7faod1z0U
	 7AGnvNzmm11g6BXEUaARQsIL6jVGHW/mPcDhHFbENnVe1CK+5/lH1CB5jBOkhXHRz1
	 UXianG+0TiuHCri9qBivWl3l1JMd8PrWA4H4cjGi9eKuVgHcuXG6e8HnNVg10pKQlB
	 U/cll1ahEQV13mj5UPGsjAdVkrHSx8uZi/Sj/BPFi50TlKOaGVkO1uqOv7ma/L8VfP
	 hZy3vqyeQ6UPw==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 2/6] mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
Date: Tue, 17 Nov 2026 17:53:40 -0800
Message-ID: <20261118015340.96006-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-2-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6F4DC0003
X-Rspam-User:
X-Stat-Signature: dgwurqko9strthf9k75ghk6uh856qcoy
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794966828-617368
X-HE-Meta: U2FsdGVkX1/4vtxW6lNDjhjGaR0moUNoT/9YIb6bkUDYZU60xhto1Qf+jNxyZHf/Yj8OqRs2rG7TzLZbDEGBSVv0vUp08/MBi7bWbnzpE0fAeAc7mWtOaX7WLMZJHYmptvP0Gcdru8EzlwHy2FexRRai9DAYShwyicAYmu2E9w80Ct8AY3Uhn6/OV+gTJbaNMnbf/R3rgXQyNjWUG6vUwdz7ouLaC4CUhzWWbe5fpEuDnkdvTsmj42cqCV9TxWDv5laxpetfHW5aJgcCUKHExaE1eMr29Kh29X4fCt5HICoo1UXI/xiyJWz/ucHNEAa6DDe0JCuP91ed5/xX4QagFK2lqBaMBSbox/JaEyWELKf9IDeVhIGaWKpwwWcenpbYSl5Z38lOh7rtsrfbw9Bqm4/nVbH2HSAfnUvge9Xod5xhW7BQRi5Ijd6yjgsy3s25codypjyf3H692OPAsyXffBp/sHffkBuVcyl2fHISY+i8b14kxheOyLy1QFl9WfqNbdJxImRi1xv/7MwIMB6Utlua4xpXzRN+ZqQ3TNNyDMv9vaUEIKOgfl+rdzbMczca5fdOu1aPzS0ikdv6HWGX/Q/DxRrgnAfNFULtoB3vFvDfcF/yDIyscN+k+YFnO4G/GZ2GcS+eDn9+gcpWsHm9ycT/eASeXqO8o1tqTc396iSXvYWwZXNQblYAx8pcnsvhxyhvwGTr5BPsQbY3SWua7E1+5T30VlyZEGVw/jcX2gd1BIrAn6FulC3LFmySUJn+Sbp8sVeCwnNGgxcYaISZHkNIEwxiF+OtRROcwYPPznmqpmWuqgDAB0iL6zWvmYh1fJRlNibZexmhOZivYl+BZ6bZ12paE1UHAzhx9VGl50OEgufj22mh2gO7s/oLhjzgFZBIiNwOFEDYa74yhEyS9YnAEt5FC4tgzLpVUZKKIJBSxpaJ+t5xfNE72juQjLiFR5fI0OFKL+USYCgT5Vf
 9qpI0hS+
 f8r6/ntWviFU0rOrfbiGzk6docNJo9WeQuiP89BvhrMvpNhbIB1yaYOuh9j4uHe0FrsaSrbn9H3qGCN3LWoKmmywALD+A8f4mhxngjeaywThve60hxajUZreQwfS7d5qzBndDBo+3qdCGfaQ5v8riD319IiGAohMAjvDca+iT1DLEL9jGj8TQn2BuCP63CrsWWbf2RToarsv521Xfw9c1vvzj1CzOWIdHdVQdDSWAeCkcPhQo2f/AqmsZ/6oyLarAZ1aC9j9fhaiUwq7qKxUTwMy632vfY5/Hm5hdsxOQrl+RzGdxifR2ndWnns3lwfy9oL7571cPjp9Q3aNymOEdK1irFzcb2/ryAna486A0YW6ML7FzPhUILgjpDKwKMUrk5PkA6+qqc9btkO9keoyNSB/tLv8m7svh5+l0gDNuRPKzgYAGVnb7gVG0Qmph/uV/DNiVL56nfU3SV/z7kHeVNYxKPhw1gW1tCRbQkPdC1OH6jjQ8Pc8Avlmp4wV5zuXAI675mJuW+sCY8e34k5XUqSTUk8QNQO6+9XkZ7xKyTb1dfE0aWuWOBRyohQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:16 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Introduce a new DAMON sysfs interface file for exposing the newly added
> DAMOS stat, sz_ops_filter_passed_last.  The file has the same
> name as the stat and is placed under the DAMOS stats directory.  Like
> other stats files, it is updated when the stats are refreshed via
> refresh_ms or the update_schemes_stats command.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

