Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F56606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m53SLCG2
Received: by kanga.kvack.org (Postfix)
	id 3F0016B05B2; Sat, 28 Nov 2026 03:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0E86B05B3; Sat, 28 Nov 2026 03:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCD66B05B4; Sat, 28 Nov 2026 03:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2036B05B2
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:02:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EE55405EF
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:02:02 +0000 (UTC)
X-FDA: 85483784484.28.26CF66B
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id C614140012
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:02:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m53SLCG2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795852920;
	b=DSJ3/PACRKtZdaR06ZCrfTLzr+bAIrZYfnjUDHLV7WINFGnolQfwcUqU8LH3wMO8PCPpJQ
	KoTm3yO4dYoyVAgm+ahP1Stcetz/H7abgQFW6nAO7DEnlWQ5ookRsPmhhGIXm+n8SZznDA
	F6quG/WdZRHXwIhtjd5+P6h8xuhuqKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795852920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VH8TKNApaWKBTCZsoWJkfGILbIk1yohTz0ELTrOx1E=;
	b=aVZaLBz7lMIikGCXyx15J0/e+RzkF9ulFAqs/izwMGl/Bqy2eKPOQBVrQVQhDQyBh9byX7
	WGi2UxnnTr2iuo9v82+qKOChF/j4IKlBL2wfjyrPSJcQniihyZbFw1O81c7O9vDmaTpKP3
	cAb3fCo3IGKkTSSDJye0Emxf7RIWP4U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m53SLCG2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3866a784546so12257930eec.0
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795852920; x=1796457720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2VH8TKNApaWKBTCZsoWJkfGILbIk1yohTz0ELTrOx1E=;
        b=m53SLCG2+CRNuFoXF0qYdrI2nciNSLM86ZqGS/t+D42wTHLRe4JL2jWFMCA3YdFdy1
         00Zkw2sodC8pFxQBZnBwFrzop+zUf0/kWSpzQyi3vvTJTsuVbb3vE8SjObR6bXxDl7Pb
         DUCNiRHxp2JYpnbk944sIb0M1byna/XbI13m3JYre2y1aGB3Gap7xp+lQiOcb7AXDEHB
         NwDKHzKMreu4cPV2UrJdWI7+GC/CUlf0Im44gRG9KpehlNCV9IvBQC/qK7aNnrCyy5Du
         j7n/qrXIEjfB2lI14xa86hKDHaohdbcytYv+QmlKMq4jaCOusCS8ljn4KRK4AzgXKCcC
         RlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795852920; x=1796457720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2VH8TKNApaWKBTCZsoWJkfGILbIk1yohTz0ELTrOx1E=;
        b=rNW+4rnpznx6TbW7m6nceLY61xYtaXBb+8J5UV/GmOC4ZEXURWL6JEHmwEnWNd3k/Q
         lfjrNr4PVbgWFHsGV5QDvhjTFht9T4+nUnEsEFPmMyH7I9K4hznfK00mRqjA8eckHSgv
         ZLpRgThcsfahYAg7XyF/ZpCRUuTsHEjvUuk1ZCzK0BSrUx999o3fp0J3ZAOY3TAucKBM
         rWP4snsfLkTrGELDZBlBC0KQfH0mBFeEDLSwrhMAYQXDNN5msa7QFWSVdEVX0nW/q0e7
         ljgdI7CNCQ1m9QsHusIXYHEL5orHBlbajDO+hNbP6CGDox/06e+dpthfpgCGX5+/RdDm
         Zsog==
X-Gm-Message-State: APuU4Z/qh7SThbbZuRL23Z7rOf5WrAhSgpgL+VaJkJmvhuWOYntZET0I
	nrhhXlnhHEEhTXODHfMWutL2UxWi60eYTP9b596Y7jFbqWJAdqILQZry
X-Gm-Gg: AZFdTZfXIM02zVDt2SUI8mPd6gVSfYtbibYn+vkDgWLiol7yLjWHY09zrvTsKgalWkH
	MvURYUehgN5i4cAG6RTj+NxLmdrvPJzmax6YaAi7f2v8T0Q1x6n428FeC8gaPPPSSEgbmWH1dC+
	QqaouiyJpZOd3MDX1/BdROVV13HVQ5OBGchfk98WVVatbyfH0EFHIV8HKsMEKUD0V4X6H4c5ZaH
	Lut/L5rCEvzNAXsIwkWUdw6gyXNljAY449fUAClPqwwbiN7XYrgyNQwg05qebg0VWCsYUbZIWTz
	EfRyjV/Oiv7WWk7unjvWZkfTQeCxkkczsn4aDgHDgikf49dsqQc9D43DwQDm8puj5Y+PRkJOt/l
	rQNFdwPjufMT/h7e2n/DvI7CwBhGHXly2Im2XHraGXtlUBWI+m2lWiasNU0rXvj8KUckvM3NZNl
	gYweZqGINPGz/+T8PHswQB4MaofnXtq3G3pse+59MS3yifFpwcN6DgOX7j8ukwVAbdRpzhHJKe7
	emDL7B2lnGWjUrzwWOLHfIjjz+LVlIFPgd/9AQ06PsxnK9aamZ19qsjd5DATP8DhdTnmD7X0mU+
	zAICX320FDLj52lBqG1kF0+02Am+4h0WJ+PmHyJ+Hu+ysggvzPVDzVNk52XyHXvC4pqH
X-Received: by 2002:a05:7301:730c:b0:381:2114:99d0 with SMTP id 5a478bee46e88-38571415bdemr24847731eec.39.1795852919611;
        Sat, 28 Nov 2026 00:01:59 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386aaae4960sm49394859eec.18.2026.11.28.00.01.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 00:01:59 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 08/19] mm/swap: change back to use each swap device's percpu cluster
Date: Sat, 28 Nov 2026 16:01:06 +0800
Message-ID: <20261128080118.36836-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbUtpY=KD8-yMAr4zxHdv7=R=k+y4jVrQ7B5OB8KTG92xw@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <8d0a8b9726974ec0dc73d2400f817c9ebe193c47.1795439990.git.lianux.mm@gmail.com> <CACePvbUtpY=KD8-yMAr4zxHdv7=R=k+y4jVrQ7B5OB8KTG92xw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C614140012
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: yoaggjrtg94yyejyp6oixp7aphhf4mzu
X-HE-Tag: 1795852920-71228
X-HE-Meta: U2FsdGVkX19LK24rHJCVWV4AS3uploRzTmfEE7yeI5wSTyI4/NxStcYB9yQk6CZbPwJ+HJJ5S2SwZqxdv86eOfc370s1c9GykRF8E/GotcjZ/2ZsOcQKfoLDqDwmr9K+XMqD0z0f8O+LDrPpnPRrRK/sSe41iKHhqnjrIIy1ei5Ppv5Irsg3M29T7MDE+AMpxi5ZJFY/+nxMK5xFA9ISwsIFJGO68a1ZxlI9G6Q85NMeMkAVh7WDa909lttXFm3IZhY5SrGnoNo46+U6ErhT0oalc8MG4HSKe/L8KQT9AEo3s3JjyPlGWVhjJpEz05woPIiwWs48muPFupHiojLdhIdGKMKfIMQ/zSxw3W4TSYkmwIMKEzejStSYkgm4zpC26MW5P/4clCRitrf0Su4CGALmzLkaSauk54RegJqcwNOGrBLZVFfryLHp7p2VFOYw9MIXgpJAhckKgTRJ9U1mFx1hfV/da8GKLhts6HVaCJBlCGusG/NovpSHQBy2Y39nnFPKjvfVeiuA5m14NwZZNKZnjd22a9YjylyJ5e5EK0KplAIvOXRfmGtdqzZh4iw3sRI2mn6p9H6r6L1qlWwP+EP8HyuEiF3YEfYKGBQjNrWa7IsqrDkW5TIoGpxYhyqOOZ4V6zTGeebMheiQwI1KtFszCqMhO4gLTQ23kiQDmaOMqmg/0Q7ue+QBB6gu5LUynCeVf4uEV3hgRGFDqX6ZVjzWPCrfg3VMg9/VG1qYiHyp59e3E44I6heueGBencctNs5aX+0CE94YbAthGa0Gck/FalNRNDUfHLMxtAhudsgmzh0hTziNyJBUbT8Ll6mZZbOXlhfRrRk8aGFtCe00fiULZyHnfN1PB0Cp3PdaRwvFmWEuHg+LX0MsjYeQMpvxCa/ot8KZQH4+w5bVDaccjnAGPsAh8pQe/v+Tpmtkzw1AjRYFr52It+timqf5+N68IPsIpDUU5MtiuJc8M+M
 Ip5JJCR7
 tvxddcFJS1Sc5xA+b1OwhG9KiscGKhHYaN2qSHopvepcIyC8uCT81wh/5VL35dj62AwvWCnFNagaEsf7frWM+c+9M6S86wwIjSREjpmigc8zCEfV9MV8FMrSjGc9bYrJnLNMGs68s6WJRGdtRAVkrfgobQCc8qlvKP896L9m8ClZMSNrxUt9IoKAyBBuzSPaQH6VQ68XwnNJvKgDJTnfOOGG+84vwdmap/04LRXoQPesc6bxu6X6dG6VApP+7owdL4v7S4/VLhcgE9Xv7gwMdf4tV/25qtIL3wpQ07wlh3kyo/iOOhTivir2i3pTtq/73b3++7WO4lQ3/9DtDmiyI9em6tPBjvKn3tlvTm2IfkQMyd8UJeADHl0m+Qq3ZnA7aQfibD9y6xXw7iC25wj9FJSfm/zqNKJ7pNOiM+6sEE0H7kykY4ooe4WGfn91s89wmHZQHGX1ysDB4ZNI9rx84BLGZldsiMtvjgjbo8LbndTpJunrsEiV1t8qp13jGzUw/nvqsEKIRqQxlTMcw+ZIvvqaqWnsmcdUu5E5DUiCQcS/4Sx/OhHI0xpwpajZRtzEPmKJ4wUgtn0w7p2vd2CUbfz+HWCX7HrYjICq0Y0LfTPGhxwjIhhRAI8ZjM6BWQKovKdD+b155UnXb5c/e+95FXLrfIZSjDVeT9S4K2S98OVJe31/mEqcTroDkWRMkbq3KvO9O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 10:28:45 -0800 Chris Li <chrisl@kernel.org> wrote:

> Acked-by: Chris Li <chrisl@kernel.org>

Thanks, Chris. I'll carry your Acked-by in the next revision.

Lian

