Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8282C606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B5L+yqKA
Received: by kanga.kvack.org (Postfix)
	id 8EE306B05C2; Mon, 23 Nov 2026 06:52:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F706B05C3; Mon, 23 Nov 2026 06:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4886B05C4; Mon, 23 Nov 2026 06:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57B036B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:52:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBDEF1C4162
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:51:59 +0000 (UTC)
X-FDA: 85466219958.25.A007755
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E6F340007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:51:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B5L+yqKA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434718;
	b=X/Khsh5yQuWTMbo1bzSlJ7PgKXICq9FktquXXtKIpnfSLfpuwBlPbCQeSCtMTwzq+Yti40
	9g8Cj4MKcacgfUadeK0j4AC0sD0UmhDMn5qpIBGilggYN6N/w/PS+ohMJrkKFz5jgBgtyG
	lVGhXzEdpFgdonqR39mGIZ8JpMHRMD8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaXx6tWMUnSdOgVVvL4AQK9EM1ThSqCe7/d3jCCTlLo=;
	b=AftdKe3laZsy4GBwn8Pa3VktnRZAMlW0RwGaLWqqY3gBIl5ABVXmCxirw8KuNeWzDJHpff
	LZT6AZaZ4rbGHBC9HCxG18KCN7Rm5of8zEtYbvuXNrWC5rWVwczRRd/6XNL6XArlx/KYJk
	4nD3rARcs9Yt0fFeYIGiblI2wxhP6Nw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B5L+yqKA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3863db981d4so4224275eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434717; x=1796039517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BaXx6tWMUnSdOgVVvL4AQK9EM1ThSqCe7/d3jCCTlLo=;
        b=B5L+yqKAYrk5l8rqc+YRSdT5lX9822QPEVCndzK2HTNJp7rYGXH+jQeG/HaW09BXwn
         kDOr3tCvb2HSiAdqmERABqcH6NvAIihgx/pnRwdkevVyJ2+ke531PzPBtc4dA1FZdsY4
         2tejblapcqrjMCCVNEwvPvBblP1MaR53aHAURLZt3BgJ1sfMgygo2D5uzpj3vV0ockHa
         z+9fGv+k0583EAdRxA9lM90xIFf9NeasfwcI/rIf42AvrCzfCtnLG7n1bgFI+o870oI9
         FW54NioqNVAshVrmBTbg30IW6Gs47oc+RtAKR7AYBZJ+qY95ziMjkKwIif4E0OliAmda
         BSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434717; x=1796039517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BaXx6tWMUnSdOgVVvL4AQK9EM1ThSqCe7/d3jCCTlLo=;
        b=2Q+sgZba8jNg+QMt9m5NaWkQT6iQaXRjtGQuVLXwOuGBR2B0yXxR+cmnEEdHWDgYTa
         kqzJ0UcFq/OjQ5+BcZ3UEc/KqI0ok8LKm4YHRXD44JUF4aKtFsEaGggFQjq5FUuJ0CAP
         zEF5bmZERBX1qCdVMX66VcmSCJjLPwD0nBhhF2T3PohGIOkALZFNyGtrRFUhv8s9VxA/
         stchuNrgNb14JAZ1iV0NDLUoMZ4AwC9PKRZ/bx3CliLndKblCPMoXc/bKv3dHb9Yx2Dh
         S3FiC9UYoYdnRld3Z2icimVhjkz8oTUtWLBzuyQdT7HFtlWbEtHi1Z+s1XmZbKjRkXrG
         XdiQ==
X-Forwarded-Encrypted: i=1; AL+hErHY1BLMkEL3M++Nvrz1cOfUetBSzyf9hiUafJ/2OUUqYybUTdqmADa4UCuT/28jlHJsLKjK14MLcQ==@kvack.org
X-Gm-Message-State: APuU4Z9PWGHYpbFZy7AMgvinyWTstOpUjzQLOengD7+WlKlHDMN4PNyR
	KbWukMhZUIbLqPjJzWhWPyiK8Kj8WwqWnzGpK5TtrUtF6thNet5fxI1g
X-Gm-Gg: AZFdTZdkoVb1A/zqjWsqIuHv8BZQIpNBrjTRcoYzyJlNjgHCex+LaqmcFrzW1nxR39T
	Mwi7p71OS3CzxnZuKNVlt95+HfzDmVGVuCU+tqGowwDQkx1Xs938LbH9xMeLzF3KFZ58xZyRATQ
	fZ1pDVXKA6pP7PRPkK4fDUcdFiWjCN9L1Z5uPgoV+gEVtb+Sd6BVfScsN5HA1oBZBUN8EzhXi+f
	icwJqzuhath+7a22PiqOx3Z9EYAI2aUqb90ucMoYo7XnKorEC3LzPX9M0Oxm7sqYeGeYwo0Kk8R
	uszk6UYMVG6xFjxSmEvjgF9EIEtZlRPs1idfvkTgMnAb9WAYhMI+jQvDeD0k77IkX0gViMf+Tlu
	48Tt6m5dwBRGkq3ZIy2Ca0MzNBqIdg7UflY3LgvkmosW9nD5yAijLhDf23n12Jq+46KENaFJikZ
	NOgulUm3PiG+31GJ61jEb8tdz3VrDe4wzUUtYfWP0fIET72OQhmphqT/hgYALiNptURhdBq/Mtd
	ZJi7GiyZxLrhH8XjzbE5Jona7ye+KSp1xUaqQprpzXUsc8c1LwJUbderXNfd3sMMGnq6xP3M1r2
	CHUSrp3dEK32k2AHn4AHKpmqipMtsAaBWeq7sQosq1Q/wFcttJnbPvPUWHsCNf8/CdEu
X-Received: by 2002:a05:693c:638d:20b0:375:c862:31c with SMTP id 5a478bee46e88-38571816d35mr11427131eec.40.1795434716798;
        Mon, 23 Nov 2026 03:51:56 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aa203267sm11941276eec.0.2026.11.23.03.51.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:51:56 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 07/27] mm/damon/sysfs: implement report producer directory
Date: Mon, 23 Nov 2026 19:51:40 +0800
Message-ID: <20261123115147.8221-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-8-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-8-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hb4zyow19nn78rmnn9m3y7bteqm9cigz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E6F340007
X-HE-Tag: 1795434717-150926
X-HE-Meta: U2FsdGVkX19mk1VSKmTJxS03nWZaHXfC/ZyB7LiWMRWYARVRL5gWs/yKlWtw2n+Zktr0bU1uhDI0iy9jB8oXEyLB9zwhZzfjP11FGh8J73s/EOUGs6yrVQ1q/sIMxQbJ68Nei23QNCGkCVl9fax08+LYjj3/U7Hb67JLI4hqanycCj7GQ8GB6minTwgKFHQ2zIA9abVowvU7y3JamlvwQupj1ga3hJ1YOSXc0ilcb7E/Jgf3xHJAjoQcrK+mfTGHggc2fvd9aEyjXqvZfHuEzT67cQ7gInHIViR1jEmjxPBNnAXgV1F0vzftupZ4BE5ENoj0a+aZxgMMP5zf1wzU5Ke67gwNv9Lfn8oR4Cy2CuI1HRmQqd+PJav2ZpmmuL4ppyFgmShmNBxvF9h+tQxnoXFVt4F3F/vrhsnkxIOUDp/i5b19w3BlqtMUYR4322D9nK3lKIOJVmz3rY8616bRwsucAXjTU07US+VnaxPgDTgLILBtoAeXzBq4osq4UO84+CHO59sVjnh04UajSTaqjwcfJ26in4B+PMj7E6oFaHnTWeeMtw89rPfeCGfl9lL+uN5HdDPHU1CvsNW6zMeGAq9iUgDITGugM5jgBFa/JoLyLl1wfLTLmBosod1MIaN2xhdC/QXVnAsAY5Gt9uTkIXJ2/adno16Awr3xHPKr34AejwNHlCNlKAaRrQJYLMjP+tEwgmSszwNUx6hKoVkhTcz+UFO93rm31uw13j3rmtkLN0oAqHrouyvH+r0ol2MCKwFZchyoNP7lCe/+6OTNMOYjQfqDHk7FB7dqPuFi6svgNVw9HkmpmnpV91YLcpxX/JDoBycAe4JwjWy3DdAoVBSn6fKLF6K6759jeHVhcfaJrOHNKR4ZiByJd8HzXWLve7tE6Blf8CAtm16dbKqnpepaPRBp9su6P3vnZf6TVUc2D+vQE1DRxBpMNNmQ4nEbU2QfbaSjKYEMRsNJUDe
 /BsnThzn
 Zi1itjNsJOGrR5cnx4L2zJMW1Cq1B4MCRHsqWpAiT/0AoqObKgD/IVG5tdaULr12VJQyHpjfwgz9rlac1ABIaIcDSEOzeIs8uoRY9mGL4rqoYDgE9hWrTqaY0mZK+BQtxh5M9XockHupKxsEP1TjrYMD2IQ70OCWQU+lYIGfTF1NRYLBYFD738VCUBHrk/4aKfwQ2+Pmsb3eJWHCXUs5/71BMH07lsm0bin1SkJic7AiXzBasSEk5OuVlHPs3h9p5cO3NfovYHF9qJ20yZxalPP9dIuanI637Dr4k9BiML9CwF2WipnfLDKdTjJV7jvNBgUnS7etuRP4rYoUNOSQru33R176ZdbtqwSfB90XoIAtbGDOGR4N/DYLvcbq5r2UaINqwu/Zors5PWyRsDwuUKCttJmCMr6JiXvK2UZIt6yAHxg2nBV7SXA0EDC1No2VoeuRnQO8W13E8vkzIGml2BAbwAP2V9LZoBSgcJ1IagidqT2m4AKwZ4P8aWDIobPZkyDXYt30yBxh29CgTpckaOu4DQ2ak2eD51QjJNMcte0KZr4F1Bxk4IzD4211zd+KlZx8iEt1cZxtzyKg2JdKoOeKTLdZvpxoQW3Sn/me2Luc50SnJeWtvUK0Z4uvfHup8u0zgEhIN7pYSURgXUvc2H1rJkaK959Wo2JsfPF+4+80r/EBU/qHCD6F4aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:51 -0800 SJ Park <sj@kernel.org> wrote:

> Implement a sysfs directory for each report producer.  Create and remove
> the directories for reports/producers/nr_producers file writes.  It is a
> placeholder for sysfs files that will be used for controlling each
> report producer.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

