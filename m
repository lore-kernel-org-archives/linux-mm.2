Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A74606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ID8lSjpQ
Received: by kanga.kvack.org (Postfix)
	id F3EC06B05BC; Mon, 26 Oct 2026 11:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2646B05BD; Mon, 26 Oct 2026 11:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD6F6B05BE; Mon, 26 Oct 2026 11:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE4D86B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:52:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03BB1C06C6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:52:26 +0000 (UTC)
X-FDA: 85365219534.16.4EB4ECD
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E69AC0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:52:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ID8lSjpQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793029945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaQMEbNe6iILjWkN+oLQ9JFAOPWDJQN9tfc/T2bNOlo=;
	b=eqtP35bl4T52OCZLnfvBHJfukqS6zRA7TrMnA1OmUNujVp0xufaFol8ZTyU/ZoZrdMBYVj
	mXG60ZM57rCNyXguEWyPwua+/ZAg+k3iwrppquroKutoBHQYvXID/Mun1ivu2dTPORIKo6
	xqc2CWBsAI4IvPPqeJFhus6f0/G1qKw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ID8lSjpQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793029945;
	b=mkFvr8gm8AiR17Tvuy3CD7Ne7eFHwKKqi5/lYf165zJr+xeWTGlwW1n5DSN7DtArWJVRLl
	f9yDlGjLtncWjfh+jAQGF031/tvaz+w0BgQT1nqYfnN7PqauEABQLoeYXwhTT8g1MtwIiQ
	uXhWWzjuVVCHaUdjXeiw4Uv7uiJum5E=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-3ae1dca6bc0so736928a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793029944; x=1793634744; darn=kvack.org;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VaQMEbNe6iILjWkN+oLQ9JFAOPWDJQN9tfc/T2bNOlo=;
        b=ID8lSjpQ+EpQreaAlNT4ihTR+YXyJ/fp4bqTn1GAxIiFRWM0ybvf/8WFR15tpasfpc
         p//PzuWNNOkyHIrlGbJ2xWdBkrQNOdd0BPlQWRuQ2oIFbviQLYCTxFceEfp5qt771grA
         99tkkXr/+Ku0+e2v/K2qYpB6Ygp0iMM6rl0CRNFDOoApEaDr/G30Etpooj9k2knsZSeS
         k4QSEvtzURpHMYIRTNzx2esoen0L9EeFaaTY08IyolFzW5uQth50ZMbFGuKz9PCYTkM9
         8fLGUhzRweMIEpWOK7OCSZyLZ/z3hmYP7NsN8642prEoZyFuIgeEVYtgEitGCaaY/vMy
         XEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793029944; x=1793634744;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VaQMEbNe6iILjWkN+oLQ9JFAOPWDJQN9tfc/T2bNOlo=;
        b=UAIdKEdLD5y2KaVdPwV+ZEXa6I66wlU9jEk1h9Gkx3LL+uhAf3u4iOsiW+HLC9ryK0
         LtaXCJ486tr46no5Hh4N2FdXLhQmDkRAwuoAED8kT2vQKyScukLAryII4RuYm3p9TXer
         KDc/GSV8lXtYcXUEF86jmWpBuDCRr+duI+B23uKY/bq5j6OB7OoYeFss5hEUV1/E3lV0
         PJmoWX4rqJhmnOKV35vvL+nw1wzz0/LAkw4n5ZPXExX4ZsAbL+Ziq/AidOth8jiClijP
         nPY7QP+wI/PPpCxtAzQbBJzEhH18ic8epEJKz0CbaH1e7Qp/3aTZOvvqRaWpVoogqp9V
         9eBw==
X-Forwarded-Encrypted: i=1; AKwUvBwimEZFdd0woQw//J9BjK/C21QwRTq6HznD9G8CejyNJE/jGg+pH2eXL/ABwiIjiZKJa8fWh0ntwQ==@kvack.org
X-Gm-Message-State: AFq9FYL25O/tNl+D8rwa3QE1Ak4prZR/Oi4EZ27HjXJGvWgK4yFCqpAw
	VHVEcM/6uvOErHLkbFrt6Zs5KXCprYsoc/asTsGihFPZiazPABIO100U
X-Gm-Gg: AYBFou0vio5JStIK4VkcvVBNo4xe8sjaWvvoEkhpmbiapmccvU4LeoEYrizILGwdBXC
	9Xg3qSVYI1jSKifSRAQk07OW3D7btREAaTvpskZ6EhmbjtAjLcsQH6zSrK/rOtDqPS371Jtm5WN
	qQyMiXiOHe5v73LBSAK8jpxuWQRaVV00zh1EMJKucjc1UWD/SdqKJvXNNqHG55+PgW2jlaY/SgG
	yEwd6ejafBC59AQmg8z3HpivKbJJZPjWDFCY/PDqMuZFBIQFx236Y/kJGYbwm5gK1YX9uJaA0iU
	j+XNPROGpPkHrE4zb8MFe2U8j3s07pbZdsvxKL99OxPhkTi7Aq9DiYETQNPjD0SeKNIMxMQsBzb
	q3NBUb7waCgKbbrUpWFqzpVVgT1SX8Aifv7MBdUHk653EtpdjCU4BGOUOZYLGVXJFOqwBrRhgs7
	1npgsZi2lxQtRFygsgFz2FNB9wovWzxlwMUK2OYZgpPAldQVBbwD3ymH6HWyM+LK3lNs+NZo6Vx
	y3eV4T/oqsW6TpdzL5RZNiEjn0upa3S6M56oD/ftwz4H2peQb5bHeiVvM0gxbvuO+JIMHrBy4uB
	/21L/VbCVMfxaAE23o9ffxUG238DDk21FPHAQT00uXEpFcQ4FQFOtg==
X-Received: by 2002:a17:90b:55ce:b0:3a8:185:cf40 with SMTP id 98e67ed59e1d1-3adead57ccdmr6255798a91.10.1793029943804;
        Mon, 26 Oct 2026 08:52:23 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40427782sm48676a91.4.2026.10.26.08.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:52:23 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Docs/admin-guide/mm/damon/start: fix grammar
In-Reply-To: <20261026142927.149910-1-sj@kernel.org>
References: <b0d8d0ceda82e303262c0f61324fe8a84fd9f745.camel@mailbox.org>
 <20261026142927.149910-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 02:50:54 +1100
Message-ID: <179302985413.2.2084375678408090049.damon-docs-reply-01-start@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E69AC0004
X-Stat-Signature: ybdyzwgzucwnaqks6qpbwqn3z3axdu47
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793029945-316886
X-HE-Meta: U2FsdGVkX198DUysqi9yccoKX67/78JpxibS2qYjUHKH0CLW7Kg20NkcBmZXYdhkOke166ls1Ut0k8IL8K4z3GqxRfnPc3nvKvFcbYaYOERh2vzg5Y7PeuFuxpyqU5hLhFnHXiF55I6eKsqg0m1h0NYS0xzQAcpi97Rbs24wtAKqNOAbkjZeygVRXlaM20bIhC3BjWbeY1Su/S14snb/+CHAfUAj5MxivJI+Xhrc3id7MQU2aUmCnG5BsTSqhq+RWTvzyQGpige9L7Eu7O8FrUYSBCWVCv/tKFEztJ4nU1xqFRcPedzZd7sCzUvwiPQOi0anQGhPI0ekrNacsEtmFb4XPQHMWnDCJzHpFmrZ3D/IWfDWEyBUvybwpayZjSpY+sr146HYh+nN9ygbJvFmUrclwjdprLBi5kOsRFgGUlpPmcRd3svSBDkfPsYA/yNFKga9vqcgthic02FUKHXf1YSCsb/Y7YbAmkh/8izfmyyTjVCg9wTxrB0qQRSn6TKe8LLalFNjlftjCqfOrVdOaSjWAyDOO2BzVfn51n3PJOrEmqAJ99nF6HGW34/NNR0p5vMMAOh+saYVlLeflXt6vauSKyzoCQNgr27sYtkmTkh1fLQ50YAmZsa3Kif/gM5kSK/p6D9MKGTqGm/K+zmUtlvSJWkN0CEZZC7s7vZ/NgQEHnEaTqFlWQLxwdqvNwNf4PgtInRVOyaeUTYYIuIst3PmALNClquF2VN4Jqgfy8xTrpotzwlyk8QPuDxJo5ImjWDQeyMIUa4pX+zC8oNuyDTy0ChiNqA31jrk8C1K9F+ymRetvn9oTL+lXOvi8PdB6mK3v3Hoag5fKwT7Y6HmEVokohxrv7rKXBstBGLNdSO1giXMoEcrPIML5brwsDlU3MHimKnw355ACU3z/vepWoQt/U38q3mhXc4Ahv6WPf9FikFY0hk8rlGZKQbX4CSJDdBMNfsHNNDh0FrwN/1
 o1xAslNd
 PSB+MMIvJ+UUpePh80XprQO1fE3GYhRmeqTyPh2nOuFYuyI7hhtA5UBn2zMkr5QpXfXiR44dJxgBswhSJpv5o2lVkmcK2SRk/Th6KbHX5RA4YgYJF3fqY1lNgOHgsua5b1PeqYiIe6qtCfq8IL9E5mM7VyDIy1Xmtm9dG/v/NzEUe9bOcD8snw7OAAB+0YUOTt0i1I8dJYVT9r2ASEwuC/PgS3f4b/lPvDf59cpTvkoOajhZ6h5TiqEZj5MSYcEkxdtORU8wQDHHRB5psRS16lFI2I498Eenb6lCEHhmiA6VvFmhpKyjUB1rgYfao6Uk+zrToyHRawkWfhH/guKDN20eLY5a8eDIABbwUwdjh5eP5qX2h5eaKkZO1wLl80JkIwMTSjHmTvnPFdLu+5IDMH5D+gx9xOGdeVD9+3V+Qf6juFc/P/2em9dURzC1HTYq/U75U/nueGsMrn6xa5gDrXgLM9rsyLAjccATC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ and Manuel,

On Mon, 26 Oct 2026 07:29:26 -0700, SJ Park wrote:

> My intention was saying DAMO is commanding DAMON to monitor the process.
> So I find Aveline's version is slightly better.

Agreed. Both "start" and "make" depend on "asks DAMO to", so I'd keep
"make" here.

> Looks good.  Unless Aveline objects or do this by themselves with
> revisioning, I will add this change when I apply this patch to
> damon/next.

Those two fixes look good to me too. Please include them when
applying, SJ. Thank you both for reviewing.

Thanks,
Aveline Noir

