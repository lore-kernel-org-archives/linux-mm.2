Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F812606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XDHIpDcH
Received: by kanga.kvack.org (Postfix)
	id 035206B05B1; Sun, 22 Nov 2026 12:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F275D6B05B2; Sun, 22 Nov 2026 12:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E667C6B05B3; Sun, 22 Nov 2026 12:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEF436B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:32:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C1471206F4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:32:21 +0000 (UTC)
X-FDA: 85463448882.07.9671D56
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66CDD40009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:32:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XDHIpDcH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795368739;
	b=Gk2yw6Fhk5WokrxwYTWpw9vWqMdV6Ay6ZEYWN3mjW+bQBVZnDQXbozivy2Mq0822mn+z8M
	t0rwaxBIpYUfGCB2kUMBoU2jUdCi7/j+12rgFwKrNIe24O2C6QMcWDSQLmps1BQg67GZ0s
	pnC4M4OBm841skPLFye6Gy54JgyLvD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795368739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96+Ra5zxNltRU2dUwkJA1qT54mu0P+GyudrjkcDbIs8=;
	b=Q3nzIMx2SZyXFUVuTEfeIZL/U/4KiQecmA+n4fAnYR8gjoGiZ2nFTDFMucm7HjRRC09vb2
	QUJDPVAaD669wMLMnvluJfl575tM5+LxgS60P2W3qgtTIZ6beOf1qQ1T/uZzOENRTduhKA
	gdcSSc70CcULxYlCads02TLLeB1ETCs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XDHIpDcH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3b4067446d7so397611a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795368738; x=1795973538; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=96+Ra5zxNltRU2dUwkJA1qT54mu0P+GyudrjkcDbIs8=;
        b=XDHIpDcHlFdBwO1Xy2yuXNMlpu/sv3Bjkry495tEf1uj3/YtpxR6fjjm1gL1/BIosP
         GQbRxXbwAw9hWjzLZfp55jhFZFe+zb0tDKs5JqAomqz5dSjo0X5PhruWFs4Txl+mJgtZ
         ZejaJBATtzeN3BLMBUjNZbcFN0dQq6LQMGb1u8N3v29XWG6yVkJfzslInpQVIZJRxJqH
         sQdi2x1ZPgDC6Xd2+jblUa/xaTeQOJTmZ311pzXntIzqcl3OeSG4Is8o43qnoS5NqV9G
         cUsE9/KnBOexyEGgCjwiO1GybpFx8kPGdtV7d5m93MV5kOcMYy7wcihYp69nMdGFjNN/
         juxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795368738; x=1795973538;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=96+Ra5zxNltRU2dUwkJA1qT54mu0P+GyudrjkcDbIs8=;
        b=0i2GdKzh/uiKsmLnzOg/kp5wP6oIey3wqPwdQE93+uY4Zez3MWSAn+XrNJ1f8VaNhh
         0xQDS0SLVmI7xHfth1/7SCNg+8GIZ0oayflP6vMoWw21ORViNCub88pS4B2a8PdlREOw
         eaUbztGTnusLoAs96Af+AGPSCDYzlW1s6NzTKC/JXYj0JzWeB6DcdWnv2NRyXIDncTAX
         aw+tf46IslT0CHqOgoVfCbv8YPQFu0Mqi54JKIQ4mVnjTxairCUhf/oBoBQAhAiDLANb
         8k8Qf264H0BiM/bVgxYBg5IXoST7V63D7y5TZw4YOC90BCStJ1Y7n+5VyIEPy2f5zDQ1
         IPXw==
X-Forwarded-Encrypted: i=1; AL+hErHmZWE7Ue2wcVcwzzZcFcyuwKjEH4PihdPVDRqtOe0SRR28CpDX1jZ6nwnTlQ2tvrBSWQdBUMywgQ==@kvack.org
X-Gm-Message-State: APuU4Z9C+5/BbzZKUIte5QUicmS3jSoCM9u1t6HWMYXJKckVkgqUZ8mV
	Iof76Vh9eYJQNf+tUnM3VG5ZppumOPHmcxcaZNtyKgVAKk4x69/iPmhH
X-Gm-Gg: AZFdTZdG17DUi1t99975phmNHmsjdUHCnG3J/W/qCbEirRFQ7Ea+LXl1kB6UqzWrYZ6
	6fwK7dcVPTPosRnr29zj0v1BWCb5Kg0z/GFgj13i+gE8Vl/jD/XmLGZaOzD8ba6qVkf3f5k3E0M
	fDKViE5K03WXJoIAp6KZGoHF/KF8T3wv5oKa7x4rsBRAc1890hubHhJBBeje1oYywvVnLF1CnWb
	qDQu3uaWiJV0S7HGNkgshl0psx0VALlCJpchr4Xp4y5asGIIs8fWSL0RmUnChBgTMGwfpO7mOkV
	J2ObhRmfFt/kmRReXu3/W/Ft/hlME+q39S9zOJ3CW6djGLDj/tte5PZv2m/Ta/3g7Ut5ltsvV2K
	elQ9RlA2+Pzml7+zyGlwKPzle0fKvZx5NrMQ8r7jwo7scppC4GGCqNBlmrBUCXRnQkN7U6EGUNf
	8MgHOck2GAZh2t2p6X8AxwmJIqydShWVC62D0CdiTpItHQCR9ZzGt8x6EFPJ5v3VuXjM8gxud18
	uaFDr9beQlIc0Akd+fPPDCErPqmJ1pYUqltPWReTycieuB1kJIfRrXMwfFmMUNtMpSpNs+Cc2fg
	92R32y5Yr5gohpt7wxd1MKEeWuttE/UYIfFMx8ZAmKmXa9jUgRZ85Rc3pL5Ej6filkg75ziIQ7n
	kye5SuR+3qXBPKg+rqtyrXC3GyUSTJYfOVJnUVyoqpMj1QYNC6vmbf8D/YAqzuQ==
X-Received: by 2002:a17:90b:5303:b0:3b4:41a8:7850 with SMTP id 98e67ed59e1d1-3b441a87c7bmr5492062a91.6.1795368738095;
        Sun, 22 Nov 2026 09:32:18 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578dca0sm16955781a91.2.2026.11.22.09.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 09:32:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/27] mm/damon/core: introduce damon_submit_report()
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 04:30:26 +1100
Message-Id: <179536862669.5.2109435867001229835.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org
In-Reply-To: <20261122171525.153150-1-sj@kernel.org>
References: <CANOyQmH5FX18LmMW+QwAcvOiATgUqx5VH02S5DyfTg+qPMSX+A@mail.gmail.com>
 <20261122171525.153150-1-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66CDD40009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Stat-Signature: h67shyg7w7key8rw8jy8116mw919scrg
X-HE-Tag: 1795368739-693918
X-HE-Meta: U2FsdGVkX197LTEh7V1gv2G3lJ16x8Zx/H/xj5L6gvTLB3vgvtjdu55f8qsAIMgZKNXFRuXMk4T2fdONRDYtAydld7Xk1YHmQZFpy7uVme6YMA/nuK2IhhH095e9HjKO+ve6rgCx3YTE3cNK9h1Ew9bvqQMrUWUp51h24wK2nD8PcXzKO6fiXO3Riy9cwB9zcNg+r4QL1XrjHLOB2uDOJ6+FndmCz8DwLdIQ8xFE49jZHrrJunaeQEDUs4U8PR9eXOE9Yvp5mQap/7C1b53Vq3tnr6JAKqE5jPKre9AfjSvCktYU2/OLCp0+oMtMYOKiqXsdYFUxvec1bGB/nvwRnJN6fZv/jN7WKS1nzZMdmKt/812EaZg5FizFzWwHi1Hbm2sXF+W5rVoL17MUVu9bINvKIR+kBMlkMUwq2PSQl+MKIjbXV/BCc3Dwp48g8KYSgZ3TUzeIt66KO/K5k8JPvkyjjk2qynJCS3CVttX5zbABlo2FIob6sYIytX/PEd0K4vl5wthklNCa96G7kgki9ti1oOCiVnx5m1NRNrJLPPus5rtAmTvlu6U2j9dnsM2EL3tvYkWOeqUX3DHipv/UnTJKGmD+8KKqSgaaPvvllsImGmRacQtw81T/QTdMyvmPtxgbgjPlu9K0z7Q2gcrYWDvu4BpP8uIGSg6/yciOdVOREhEP0XHcAp+PRKQkZkrJ7RFoLihUWvNtWPks+Y2sjCCGogVMgPz6HGMpXCXa2fG/OX4iJMW7idKS4a7z+aJvL4G3tawtNKDINs1FmrvX3qSGXMPWVjRuLvuF1EFVNOniWB+xAADPb3fQX7sSVa4RUvcThf/CEERGgcUb1plq+XHrZEW26pFP0VKw3q3o8wLjBKU5ZyJgyxBATRhj66i281YRtg6Ipl+nL4EccWzwON6DZbB0aMH65+YHdAfRZeXp+2XrJi8EkyILylTHrtF9nWJhLA0WjAmLtDIx7yJ
 C/mGzr2O
 YZViyY5kYfoh5wJGud6HZj/ktN9z5FqXOHEzTD9sy37zXZLEu9bBfJwi6dRNZld6c47qVnRDKYvteoylPQmCjr042luMX4ENH8mFZCunoDrB4AK4LCfK4j3SJbKjbpI4cl6alGfYKKA3mMU/pxY1ZwAwKpN8+iA09ebXyjaNxqsknOzWGIdv44Exr1Vtkg7qWKr0v9EvsnOtHDkbs/BWdRgtPs7qySt9dMbeDIOy8Cxy+iLZaDjOFUBPUaWLvCvChncNHGh8RWn4A9I7QPh7yTQN3LrxkNDP5VLhQLwpynw8bpA87ALZxMDARIt02aomVAmTLXPV0w0JDIt2HtKC8JLqcEkZFFSQUaC2pYaggKSPLAWmxu8bCrUQFBgs5vP/KmFHrlFkSufhusZ0xA1ADnYs1b855/FMS9oF8guZB+TRNcBcGzrQPbwsywAmV3KcuIXjwCD7MBGWdvo7NhARM1VcZVMOF+0TZCQXgBiQeYFIpAxU0F5E5PIuQjmHvTqXVwvyNqXQZhstoKKy8ovzXpv2NYKT4Hpd2NpIVLqtUQpYx/0zLfFprYqTEOWhJOwpoFPQQyMDAcE3w9LHknhTVaTULHp53ep2GlHQMoEotalZOdQXNPe5j7EGRKNYYwvTy2eVS5fJO/h3cv1jtu77Sf5ESPN4+doiWCAqHMujUjzUV6uJ1vaJ9n4OQXCMhN3RyiiNLIn+0xiikrPaxucUQ0Rg06t7S5hAGUyFyrm2FZCX591r0J+IDftS7LBPpZeo3rJkT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sun, 22 Nov 2026 09:15:24 -0800 SJ Park wrote:

> If you don't mind, I'd keep this as is.  What do you think?

Makes sense to me. The rest of the patch looks good :)

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

