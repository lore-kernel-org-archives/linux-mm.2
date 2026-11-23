Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D05606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dJlBufen
Received: by kanga.kvack.org (Postfix)
	id A97FA6B05B3; Mon, 23 Nov 2026 06:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A732A6B05C2; Mon, 23 Nov 2026 06:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC616B05C3; Mon, 23 Nov 2026 06:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 831AF6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:49:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2C731C3B46
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:36 +0000 (UTC)
X-FDA: 85466213952.26.0BD592A
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFD76100002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJlBufen;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434575;
	b=zxWCerm2AC8+SqYkiflqIgqYu0Us9WRPGCdoy39+5a5BLL7kukoy0Vq2XkBhi8i1+Lfvr5
	H/CZY6RdN6U6BzJ2F5JHFSvtX35v6AukRmcWBOxFgEvhfQoRkRfWnn+juZ9xmVUMSZeZ1A
	N1CuDpHTwrtH9x7zbZhwIx+7NVeS2G0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1BeAqyMLOMCEnXc3bmxJk/CbMYm6ur+mByxDHIeAz4=;
	b=Qyx2ECRZfrCiTJ/E2oLPN3gkedqRW6d2sBvwjNAJ9SzBj1zOIj1kys2o7tbdWGQgIa6/HA
	9pa7IMkVigp4icTWwKQHNhIxDP1JF+4YC+gJzr1EnBsIdK/FHchNLl0+swROL8SN1Da1uO
	lmcdsEPYgEMG+zuZgLXNTRF3vMCqdEY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dJlBufen;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-386ab9ab619so2017203eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434574; x=1796039374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1BeAqyMLOMCEnXc3bmxJk/CbMYm6ur+mByxDHIeAz4=;
        b=dJlBufenai0ksNqPAX7KGLArt7M6W/8764nn7Tj1oaHepNnJI3U7AtR7/0USz2jVwe
         tLi/tfsqhMIP9Ewd6UgaXvZQ0hMMHSayPTb37DsID4LZUaLW+6cEJP81Xv9BtgNrVO7E
         s0qSXjNcQIDEc2s2hpJuPe6ds3F7UpygTeDiRh2wb86C06l2VYm7YyufIJ20sUnvrOzU
         hKsJCQgrSBBWWBTWFlSjYzRx5TJUWK+seTFAPLQAoG7DRGTHJzRAP3MiRyym1+HGjsd6
         sTiKmbHRzIzn0S08wIDkyfTAueFuGwpTgyL+v1lF5gJYdIMSuFDG8n7u2SZs7AttoFgP
         0cdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434574; x=1796039374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1BeAqyMLOMCEnXc3bmxJk/CbMYm6ur+mByxDHIeAz4=;
        b=oSyolOFnriEsnDUr2wEnEf8F0qRsQs6Thcj60Z84www+dGQ+j/aUCxQIr7qS1kJOkc
         dCLmeI5/pUFp5Rl3jSuuR9lLepOGCEr594oICfLcIJFQL8L89rJQVQAo6Epxw7mi0PPe
         pvQGQ3fE36mI3PW6d2zVBz0CzSYUXrsLwfIYNMkD6wgKZ5/q+ltPwKi81FE1q9o9yUPy
         0EwtnL2yRg7+keicp+ngld17it6HX/9viNP1rtHV6Y/nHKmiDaO3wWlBW+lR22KuBDK3
         7nVgdW/3clkjGLqvykp2cnjXKbD4tODNR4aXWz9IcsghueumfumQ/2bbZegmawKxFXxG
         7eKA==
X-Forwarded-Encrypted: i=1; AL+hErE+GpJFTklGpQjrnCmibjwHd0gcJSqiJyUNejF63Xm1tiPzVz4aUHcz719fBOrJd5/SrIz3m6x73Q==@kvack.org
X-Gm-Message-State: APuU4Z9mlRLAzgiNTf5a3j1R+1quh3Dn0dxMh5TwQG5HBptmk7aTjAmM
	GCYq169wLr4mXsjy4sVXLe3lW1Q6xb2yH4dlE9ZgNT6wxRBmcBnfsJK+um5I7tML/dc=
X-Gm-Gg: AZFdTZedpkgaElxK7s8fTDP+2QQJvIFgyyPpbxT1XezoNGLngj+osUaxDv8k0p9z8w6
	D24QVa5DE1gmmu7po1OL4cA7ZulVFPteP6+E4kwNsfPEM0IsbW1l+0A35AcVt2cqUzvYr/iRGhY
	PN3P8ESmvDRhlqZDhG5lm/z8dws3gkXtH7WRuxaKC7TXCFXFHfmOSiR0HbXDNe/GijrNP2f1br+
	o00cJccb13wfTyhIYsMITJ0720Wdhi6M8x2IaYFdmrEP3WcDiKJVWbMsOrJCvysobDgPOMXcuKz
	NvXJ5fSknp77cAI3ji3UhTYkMqXPsPuAzUVPwIPEt2CuW81eD8smkVuyP5leZYaV9X1ryDZL7hL
	OawmNIMFx37aM0FHqaJ6c97Y+4dX8aGF2t93Q+mEq5glbf9O9qfB44xkqa1tKDW8cVmIqgvAAyE
	pG7R3IK89L1ZxRASpq+i9PctqH2ZQoiZBR7lXRFAASfoXUw3QEmHBeRjqD4vjtjLrdFLKHOm8QQ
	dJYb1AZ8mc31l9A3AZ4XD2ihNNXKfU/5RUetIsRQCF6/nuIxQyBPqzIWpUGs0pVgtyHypE1x0ZM
	AB73DnzMV6VMbhu8n/ckixcQc7ToOTW+XwjkHrLSu8JcnQERBOYt1MoMG5oeKCLlBHh1
X-Received: by 2002:a05:693c:20c6:10b0:36a:15ee:c20e with SMTP id 5a478bee46e88-3869a150409mr8734857eec.33.1795434573583;
        Mon, 23 Nov 2026 03:49:33 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385c6830815sm31501330eec.20.2026.11.23.03.49.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:49:33 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 06/27] mm/damon/sysfs: add producers/nr_producers file
Date: Mon, 23 Nov 2026 19:49:17 +0800
Message-ID: <20261123114924.7369-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-7-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-7-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: EFD76100002
X-Stat-Signature: jqmg1ttmh9pmkp1dkreiff89ydn5dakn
X-HE-Tag: 1795434574-920018
X-HE-Meta: U2FsdGVkX19q4x8cMS6IrhiN4+nwl2Hft+Yr5DTNLe0oPOj/pzwbOMKuh5UnSQZhEIL2XcBPLW9MXSC0g/h37sDNQYb4+BkwbY6l3Cgg3e+cRc8m8L564muWe5W94fSrt76SKnSMTv3o4pwNbkGmO0kMeCxSpX/5OQdoEXpZrRfBNr60Ga2nZACfZm3eZDpxDek+/ckNjAcpTMtV7D/itUXTEBg3c+QXi4gb/A8fKb1eXzv/hqIhus6ZedE9W6iZtOhxCqKZrTGGQsxZYoVYTtfcAYnFahv+c6pdnUgjCKKcKhQ9z9R8u7hw8I6pbqSczQUpTPprlvVA2pRvUvfq3jd8nwNVQYg6iXWHBL8zu87LlB6H302ueXrkZwg0lBxsu9FePs+MZcB+ZT9jBdexgEj0Pag+6ETeIyovUojue2tNVoKgYqEO/6IdK6uT6kAo6kVgoVmVomQHxc+dW3QfFMqsZbkXsguE0k0g0IW4cjxWn1YHxuOdda8thG82fJlGgEQuT/NNZdjRpumgp1Rf0zI2y4pgDIvBAd25+9kq9EuV7+EjSCBg+eOcUEplB12dSd+Y5PeydXauzWTxGK8yzPBIwS9uEPnvtLRCD6gc340aPxp+c16IKU23J8sGwIm9aI2LivXFCw0njtN+hp18ZpwOIQnTc3eM0KYFVguRcbFR1lp7ado47of32UlnLnnnKcp/Pm5SYEAmzEYGMAdTMFkNkycGP108/XBqoVVky6wSh4MKDURC6a5XLPM6Gh9ape6a44xSvHgqM+xMIt06P2WKl2AX5VnQPGu7sfCQgA21Y8sEKyXLuSzdDouZWT1wZ92KB8HazYQggaJ/Uqr/BuUBJ1uejPRMl1poScrVdCC/2krQXS1HDmcwTFFfnv1FT/S4dxEN7dLnssMcf9MHH0+CAcjWcdGhcelLIJtCJnTTbZKpi9+dycowSSCNlYW2GkDoMeRUOlZHWo35K8E
 OWSUXhJt
 bL8Pi4proGhVO7KOM5JBza+OWyPw/ikM+nyTTWjtccmQzyC1Of/gcnivfjtCmQzl4HjvDo59FuvnbpAZ2+oW9XZR5+8DT7Y5wKFmzxyZeBYriGUObWtsKbpN/IOYYMt9gKAmwweQLEX2pf2nhbu0hzI/CNyMh8kaDmrs+v9XWW+tFRalqbKqzlE7eWRO4sqm3OCwbv592aP+zxsmqXf/TiYWqjIZnbGlhwmQbE9nq1ww4rIAB+jBZ3Wl6k9P80ohy67qXpQiC/P3ubYaF3qvjTC84LkOJOMQhVG0141eQPezvOIS8xSVxcw6nB3N1Di6EyI7Yls5wI/S112zl0TcPkhrUKvhWerItW2a54zUGFlBh5UKRqTX/XCrnAqPvbHNACqI6XCIu4do3LsWlDmONs9jn3PIHr5MIOr9CNV9lAU9arJSYbhOJ9zBuZq06RIbQGYAraXDPZJS3N9lCqhZ0CEkwCwmCnDy7h8cU+A12u9IoR6WcRDlOtTBTGps3ora2BYvXZj49dxD8QBVXN9ySOBuiexYwxWaumSbELIrY6ZClbnirdKPnJEGjabUKgqmjPrGB2V+s6wIwMMfxswfUl4hrdeC7CN8Hr7i9pBeNp7AGbXEOUDwfftE3l6TvbBiVFIacflZSofajz4rhXCQ8r1eQc8nHkgspVbqRCAwshYcwb67J+p/AjNV2SGuWJNVmF2BsVUR83ggQYlV5Vl78P4ko4lA7uCYYWqlS8F2zlFQWNCFYT4FEh2lXCIJ9XfEelLwdCaW9ZQ7FKvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:50 -0800 SJ Park <sj@kernel.org> wrote:

> Implement a new sysfs file, nr_producers, under the producers/
> directory.  The file will be used for generating directories for each
> report producer, in a manner that is similar to the nr_kdamonds file.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

