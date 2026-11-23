Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C822606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u86737xO
Received: by kanga.kvack.org (Postfix)
	id C0D426B05BC; Mon, 23 Nov 2026 07:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4AE6B05BD; Mon, 23 Nov 2026 07:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFAF16B05BF; Mon, 23 Nov 2026 07:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE0C6B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:01:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36EF0A83D3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:29 +0000 (UTC)
X-FDA: 85466243898.03.88067B8
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CB5618000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u86737xO;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435287;
	b=GlIAiY4gR6+4ZF7zrAVPUj8qZGhygu5vExot/vdPYfpPGdoWUhNhWJDxDuIYGUZNaEOnUI
	DSokCHjSmkTLtMwSWmV2SkLRgJz9GVJeUJVf1JX1bamDL7CK6jjEI1z6VonX6N4kCtqq/m
	8jFEoT9Uvinx5Ru/e6juUVFb1aCsJQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hPeBJUuX3mm7LtpJ/KyVL61wmehbfT/UZq+ryhG2LQ=;
	b=OM5AjPXZOKPPBjGf2Yj+079FU/zOK5Y2hVtmPJwRCfXayANsmlEuXOLMdTcb/urkhDVQUa
	fVsivZyljo4SNFm5gyaOMW2UJ1Ckm2TajPtLAKC3OEYng6LldfAK6LgbI2MMkTRemHqhNC
	2QQjpptW98D0rJKOrfYXcsHqt6/qTIE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u86737xO;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3866a784546so3999567eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435286; x=1796040086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4hPeBJUuX3mm7LtpJ/KyVL61wmehbfT/UZq+ryhG2LQ=;
        b=u86737xO4m/PiTqKGkugLScIIFCW2tF1QnXC6BbnyYkw6cA4DNeEheVa3CnasArp4I
         PHxkEWewSLZ6JbU+FwpRmtHeFDPZ/6NhA2qzfOquIgwLv49PTRbD8tnqHZ5Lh+xCFf2k
         kRMucqzDUJhCrj1jHiu2csKYyPxY3wOCNFzDYL9gawW3bpFCu3sK9PkRkNwuhH0mS+PO
         OF4PjmphO0Jfr/vCyiYJD4mGtBMbuqSLKoAY/bGNHxmRJi/mqU2d/OP/gSvw0M2gvXAG
         NlUjy42+tJaGalQz+qJ105djzWTrqmbYhmoP9UhM6nILBuIe9BpNU00RcgsAdAVpQb2x
         /+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435286; x=1796040086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4hPeBJUuX3mm7LtpJ/KyVL61wmehbfT/UZq+ryhG2LQ=;
        b=ud2qTwC4w/MO7dqzMhioo9n0Xc7ykxcNcgd3gIIyzmTiFt6XoHz+KOlhqt9839dajF
         EyN9V5Bb9lsyF+2sHRmj9eFfPwwoua9DcXOziugX3IQewYChjAN1iKL8PutadU7FEZIQ
         ZHk10Byt7P+ikUQLNwMwu97OkhhOjaQYgGe/KuFZw8U3fmXqBxtoXFl6ocCMjqS2JgDg
         eSH0QqtFhASCorBnOy1Ul0qpPb3FuJVL5uRAsSGYp3JmKAjukoasGa4eZWuysh0+b6nQ
         J016XUiV7wOGzLWRwqCyijiy1QAyl+B1dUfGHRxc66qhzQovlgs9L+E3gwAfydnNri4V
         re9Q==
X-Forwarded-Encrypted: i=1; AL+hErHSRyxzQxMEHYF/FXsZiBuL/VTdStHGp6dr2SqcreSM7FhS/DA3NQsVsr8pObzhx3nihj6F/TjRIQ==@kvack.org
X-Gm-Message-State: APuU4Z8RGKo4dWQt1hlC5+0FSQe2tnr6nrzdQy/D1UC1cRRcO5CQrOnY
	M6oQ1I+2vaeEzYhqxj8CLHLq5E+xIeeUfncytffVfoppLtXUrGCdfOz8
X-Gm-Gg: AZFdTZcD+cXpn/yO6JKkxSGvLPI9LmDkSDM3nmNSIkSshySzudLYO6IULoSFm2EeeIo
	DMa7NLXCRsoWagexXF4j0fbIx4q4tyhLnZR19IVip9F8jfdUWHplD3wCq0qIgjSIil3TUQLgwi7
	tBjpYhyxtBWuQ9yWw2Od4dq1Df4CnUTg4Wz/t+m9aTaRlzxA7rQWpehpw07Q5MQAgEXwHtX8Fpx
	AkeO1APBVWfCM5sKxbVnnzxMLqSHzB08FrQa3C5LoR+hwXGD1sMJqxLSbxj6jPKnNTZJxRlFR8/
	8bO78fkYNeQm7SuSV1Kyw1iBnIdt6iK7+6BLmfb/IcAp+rB7GRjLFt8Uv8ivsTE6tdChCiT22Sd
	QaETTKNfHVJ9ZwFYKlKTAzccwfzGFilcWRMp2maGysY3+73olKxBNRZYP52rUqE/TSFyhjVaxwP
	57Y9fmTTSKoGPrTrbPPLA/5kT0iZaanc6ylbefaCeYxYG/d5FBWzZSpSlXxIWsmY5Mc9TsKMDHQ
	ZBCdwaK+PnqSQz2i2JJxgTpDbWF501aMKQsUuHLUCEIoNqx7bVHE38Znia5YeynqSMRmG1uA4YX
	brDWTaZ2tg+O99iHMM0jQWNLPh05zuGO1B5u45g/Zkw/usxRN6fC5B2N0yMvdGrT1R/QftoahvT
	zXpUnecokVrC7rQ==
X-Received: by 2002:a05:7300:1c17:b0:386:a105:fa66 with SMTP id 5a478bee46e88-386a105fd17mr6612093eec.7.1795435285963;
        Mon, 23 Nov 2026 04:01:25 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385d2b93dd9sm39368063eec.24.2026.11.23.04.01.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:01:25 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Mon, 23 Nov 2026 20:01:08 +0800
Message-ID: <20261123120115.9215-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-17-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-17-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 5CB5618000F
X-Stat-Signature: 8hejpd53utmuwrh4yk14c4k59hejd5k3
X-Rspam-User:
X-HE-Tag: 1795435287-798015
X-HE-Meta: U2FsdGVkX18V0GHAHJdDgh0bE27qN5tn9HnV3ycbIjHWoLmoVTVkFmbcQP+CyOWoidVUJxLjvQaDx2NwFslwH6RYjFcSeJbhlbjY66aKNm7VaZxYGUTJYkkyp5ebUrzYidYjp1SqqIOq4lKT2sCkhoEcnSexdD+cbyrMqR4fL8RIceTgbXBVPRZGi6Yb19+MvFotqSpFZUWZLGitWsESYimIPkMuYts1P6v2vvl1BO0uZ7M0dAhyVbRwNOFtzOkrHF6jZHG5kl4LOeuJ53u4diBixvQOgmLP3K+++QkYv79/RMJKYhbqHh9LVpI2CyMyI4c60mxYiTOoTIyBroso580BInutkrHI8eJ+sOCRzUGZ6+IZ8kXT/FcnAgbpelhFSuvtvYuZRnh43cPtB4C0MaU4UxfRxdorh7JXiwRfKy/+kREebHKI0GVt/zYGeGH5PM0aRBEbXlBsAOFAce7Aax8tVZM2J1bbCBbiH7MANNNwfQoAw22LoRSIsW36voabXpTXK242orYtgwRVbbfI711QZO0+Su57LXGZ4CwUtvf7nXHNSI4MrSLAeSX1Q1snhJOIdA+pZQddQSlW1uqMm3+PwZNt0DWpc66Rb+B/DVgfBh+oIHdW3qaVog5tPdncHEmWCZVhZNroKL7YidH63Qfgz37Puw8+Z7tcRLchntTBWdo5NVhwwD5eZ1ULhhnaVeIAGCoUuaIKjhqJzoZC1btfO/jQDlSkVMcghmIgJ3yfiaKa0WqL8ezaTxGNK9U5Vut1gYfdiSXsgBN5NDbjOeAtH78nLGzvb42b4Vh2zHIBycAO2ng8xNj8alLcuP7bPQIeacPnvdSt6H+h7v1vSZv9zWAJVJ8Y6SkRvnS0ZeINj9YwNQxoEZeTa2xYoiOKMnbOVQ5ushes9I3s+oXfDeL67x9cK7oA1DRZasyMrLwstWpSYRHJgS78EdD666D5tjWPg+FZ7GnUAHVTBMZ
 YA5wF5lg
 Ttwx7X73ufXgPSRlY2CHLk1NVmki9wqRjbbmNGh8N6F5fLq7oYoVEfcBZg8VaDE7GvXaCfbtxDu3vctXR32+ue0QNP4tsKBHZFGclerVex7vudTUmU0RF/8+Ki1GHMSQV1GjuJLLllvklUKmrfT0/dgpJxT5mquFh3XqqVTWWKJTU88rNv+DaG9RXOpOzPHTo8GrCLcyNmMjeq9WLVYu+L3vMMmYWzBhpDpIpJbiRIcOVZbqg5AWz7U5ekIdO6rSJmZpOCy2VuFlD42AySgXsnAQXqXw4Vz4YnlMGL5JDx3hc+e09KyTD629pu1j1CMkhadOHgN+7DpBXyWudIafvFjeblqj0OHqnkvOh1aI2lslvjuQCAizARF1Uyw8Wi/1Ni5ZjdBxSCKRij2E0qxfeiV3S76CrRrBN3du5JRAYleLNldZPY//arfM73iYetWg/jdY/2zPOgrKI3Iekn/uZL+cREEziE3ogsadeBos+wO89+NR1hfmyLuoS7vbcgCp7PaUQF+cQb0kSDps6/7tXkUZR/w7hHXtRt4OgiR4gZZWq2e93paFMAGfEzocWGEhQJGtYZ39wUM5VJHAGWHPmYpcyjqL4kCVPssPKcCNztUZXuFSHRTxHxtHdc56C1kigImQLPfsmlqJMhg9sPRP7tZAvPNEMbtn0fnFa/ncstth/mzU7MLrWVMWSmIkQ83WkvNrCm7r9zziyn6bUmATTS4M4kIpMN5ZULD0pijcr94pVS5c1XZpBxhW4j03WBrA4a+JtDYbws5UCcYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:00 -0800 SJ Park <sj@kernel.org> wrote:

> Accept user keyword "report_made" to probe filter type file.  Set the
> damon_filter->type as REPORT_MADE for the input.  Setup
> damon_filter->report_type with the filter_report_type user input.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

