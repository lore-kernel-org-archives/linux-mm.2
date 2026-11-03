Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF32606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JSPiAl6Y
Received: by kanga.kvack.org (Postfix)
	id A01FE6B00EF; Tue,  3 Nov 2026 14:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF9A6B05B1; Tue,  3 Nov 2026 14:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F03E6B05B2; Tue,  3 Nov 2026 14:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAE66B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:38:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07D3A404A6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:38:46 +0000 (UTC)
X-FDA: 85394820252.07.AEC072B
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25FBCA0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:38:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JSPiAl6Y;
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7Nsfbgz2MsKS6ZGWF4RMYsYl2J//BDsVK2NQxPopKA=;
	b=AZzeLPiqVm+V8N/p/myteZQOTkKzin5ljSDx/bbSuXkPsWhLXaEOYh0T69W0v3RHMyHVh/
	h4MvXPTVlMvPLMG16z2nk0HcValuozctBX4Q1p4F89NW11wGgG6o/cBE+PPzVYwkb91AKk
	z/WCZbVd09B93l27My9btdmTCnBJqJM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793734724;
	b=G2HKPhn6uppr+hyZP6pVRxCgvpnHK4zUnjDPfSi2MuW6jwPjo7NfI7fIdzYJtXEQ2xatds
	5slHuTOUaSssyl07bfiQ0eX+aYQK1CV+wjeS9baGZDv1jxe6A08m1jZYMppKmceZH+9ywv
	WwxS3sWn4tnRUL1MDpbw0XEfT3puIjo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JSPiAl6Y;
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f47feb5a15so870743b6e.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:38:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793734723; cv=none;
        d=google.com; s=arc-20260327;
        b=HwaAMLWRY7C7GiEHEW9GayBd0Ljrj3hDW2CvIErmgPnSL0/1II57VJ6Cy0Qt+kRWZ3
         TO6lLznw0UMTwhPkWZVFDW8k0OMnSXUfLO90PMRscLz7uSS5quDkDbccYpk77pPF4gyw
         bywcBAAjnrrvbLLSI7T2TbKsPyhOkoFYqboKD8YC22qYLo9+sd89tj1fepSvWWFjGX1s
         6tbr1+89AhBM5IKpDjwYFaGai6xsBX2rYNXjE8ShKqh5wMUQu0Ew+4CIsna/DkvJIZnW
         K7/WFVR91qhVLg5Ch2uVSFc3nIGvLh5oKYU7Z7SCZX3pkfzxP0iHeB8ZJae7PkVcOb8s
         lBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e7Nsfbgz2MsKS6ZGWF4RMYsYl2J//BDsVK2NQxPopKA=;
        fh=4oyoX63FWr9J8tzd/1QU4zp0v1yez37Kf+RGjI+6CJU=;
        b=qSl0+4Eq1F1Q1L+3PUPzk1DH3agK72Ndrz/solnKXiSdZJSlIBPkwZ7QNYRWp+ivER
         b6T3Vt7/N56VreJcthf7pPqVMsnijQ5T27Q6c8xYrshW2FjH5NgxNOj965nzn3YFqUx3
         4ui2Sjhq8LUd5qKtrQB/CQGi8IIW9ROeAZGKUQ4Ktzrq3IN8cSGKd+vrCgeFx22eV44y
         0mVlDXGs6j2GNC4Zwc/ZYQJoAvpAv3Q/Ao7fs+W/01EO1oWADmM4X7/+5Kc1hRE4XQ5k
         jP3flKavwZnDsyFPf8kuQVk2GJ/YT8Qi5blhnu643p7N7Fe/A+q5d++TnnF0z+yJnIiS
         B54Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734723; x=1794339523; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e7Nsfbgz2MsKS6ZGWF4RMYsYl2J//BDsVK2NQxPopKA=;
        b=JSPiAl6YGgny0hyxJ1GowqU97fL9FDHhzuL5xcJLDC8ENUBno/JytWdrKSI7DsCT3+
         gfvyLponZhnUAGqDDbtQ19hCJBxL4it+lHnrhw/myrF+9FTKvkSMx/BnELHz+jh920gr
         +3huR8GXkCBDY3KfNz0JWJKJ/DBfLEif/aQtEXLSohLeVSwapHR2SNu3MfFJKsXuifur
         Sm2yh60Ie/JQEO0HQE4ngQbmbCNcXr+ahlNOj9uM2o62qdBmpqortp5hSbP+O6UESiUs
         BeXgwBcMwIiQMcuj0cvbif+dxB64+YqHtIMbfAmln1GXBFBDYokBMDA0kpTKU72mjp1w
         3rxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734723; x=1794339523;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e7Nsfbgz2MsKS6ZGWF4RMYsYl2J//BDsVK2NQxPopKA=;
        b=b+sBknkQsefB56663CNFuMjBeFnvR3HqAGx7UouRnOtWWv1HcIrBMCu4hax4xV1GMq
         8AoadP0LJfrFYOFfPtHjCvpPHLDBzRZFV5jK4MDBpNtQJODIEu++W1g6CHk1YiI2+6Wg
         ZZSC4VOBgcEbAj2pFGlEkFvqvyNgAB1EIiMwjBzrVuTb+PvQ0dlh9zzG/tECwDFlU4Ic
         nobe4Hd6VEUl7wB6qMsP56EMI6n/4KOCcROIt2Aj/XOdWAN/YqncT+npAZkF0Lprt0kw
         tVlvl/ZAEJN00/oIgGPGdQwucB+qdgzQ962aI2FLkrkBtNM/I9VNDW5LihysAkhlqEvE
         yyKw==
X-Forwarded-Encrypted: i=1; AKwUvBw7g3LWIWOovPlG0WCHyRqRUcHU9By8K0pFkJS0dO45IQrUcu7s/3UrgM6hfiSCfCSLigtM8sSc+Q==@kvack.org
X-Gm-Message-State: APuU4Z8Uwaxrsckxzi6EYwBoc27A62fue31PUqU/h6OhhBnRjhpHJ4r9
	Hr+pWOsiRYyiNy/klLx+mnHzRRhzhcysM7ZR2M0CR2M7qCC9ryBVhDYYcCM8lN2aFnshf5yWOUa
	bIWTf/4GReS3hDetBzP3HF1chJku8zI0=
X-Gm-Gg: AYBFou1uAQK7FN7+2T+nv65H6376AWKUseYXK/KoJ/oAC693KJPF47BaiieCQvMeMqc
	BIo3B8Eh4f1vQptxKi+/5oqgcHWOXDKb3uRjAlA0ptvH3o5zJllVO7Sg+EgxZpGK/TLMDj76sIE
	vyLVSJLkZZgDEZCNIfdL98Px63t/qqAdypkPkIrxSKZ7oq9OFC9rj3LLmBs9JDIXHv4WoggKxqB
	mv86i+1cVD5R/TiX+EudTor+z5gkqQXHcR6DnrOj3H99RGNTuoACB0yzrxFl6R7mmZ6YaRAvLz3
	YsAsZzWiogkvuP6h8QQkqfZYT0TuWPeG3nrYKnKEDSIV6tQATw8lxVkmqxDB+3T1ywoF0oCJzM0
	NzEbgAC9YBMAltYQ69QPS4asmwrdSIVfkmQEgW1idYgzviiDTnATjVo6i5BoBLWFDE/W3
X-Received: by 2002:a05:6808:f12:b0:4f7:d324:bc5e with SMTP id
 5614622812f47-5640de72cdfmr9400682b6e.58.1793734722850; Tue, 03 Nov 2026
 11:38:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027171753.1485-1-dennylin0707@gmail.com> <1bf7784c-49ee-4f18-b1fb-205dc064f40f@kernel.org>
In-Reply-To: <1bf7784c-49ee-4f18-b1fb-205dc064f40f@kernel.org>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 3 Nov 2026 11:38:31 -0800
X-Gm-Features: AclHuK_5l-1YFLgJ9g8HKWzH3b9QB7XYwWCMJBecbk-lPEygLtMhZDFMez7W0Qo
Message-ID: <CAGEkeHcwUEQ0tAXZ5npAhPp1OPMqkmZcNPTU1OnRuNTrwkDJMQ@mail.gmail.com>
Subject: Re: [PATCH] shmem: skip empty unmap ranges when punching holes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rxcip8rf4gqwm9bmfqcctpudj9ujd14z
X-Rspamd-Queue-Id: 25FBCA0005
X-Rspam-User: 
X-HE-Tag: 1793734723-77806
X-HE-Meta: U2FsdGVkX18+9y0tt3y4XtAOXJCdju9BTHk6zgntFpRzFui0l8XOb5/wEu90CstM/YeEtkTiKs92kgB7zvFy9bMGFFHYyBzdQs0NyKyBPkJadloadEfR6xMQXcdFTMM2SyCU+K5eOH9B5LqnFLxPlBngpx4hbiNUK5Jh1EjxmSoW990V/sw4MJsy07jF5ajj3z+wNP4uiXKZmHyu4C4AjmIvdt4bcq5Y4Ru5wSTKlhuQbv+3NIZq7BWjpYgFotScabYjcCy1RzcH7tZkTqYYPAejizpokpG5VJbvkxUl1SoeqF5tYYAf/7yfa6Owu5+2YDs1Gtko84VCtXcHYjzhRQTHDhjih/9GUX3EZkBCrYxQgCCVMaETi4mXX5dxIeIobxfDr2NjGTsF2ykdVHfyY6TzYn5W2qT3FlyOGvhP+0n70X2ILoNflqqNkzPn/FV04e1tvc5hxBEXHzB3Zi1G2iToDtCPZPDX6Sfb1wzXqgvzbruwUmuiW0ylgGXZFQttp/6uN+lhkaxxFLqbgFw0KvZBQsit6Gap1Q7Dh+BjPw0pCNAUzWS/EJ1cbAyQuQEnwuO/mko9vJ2EMbG6OelFslEVgPOMt0ePVywc73I1fdyTMl3kSUT1LBzuzvGHWttnrgjgKdvuw57KuiI07mco9iXyXT/TuIPXF3OrC+/i64pzJKCcGkmo+fPgmAQL61rN6SMAI0PL690+/qAik9RDbmX9akBU2JrX63BzWqJs9Z4Y+LkgnsylpQQL3H4SuWpCOhmN/+36FFHNkVndJ+WfoVkfjDt2MgF1ZocfDD9bRXKr25W+/GwBhepL7EyX4l2H/YGXTNu5ZslmbVsI2ytH7vrx9yHbf2nHYbiLTMIhFCE+AijQ9Bq5iQFjm+T31HfD1erzYlBXreUMPubjrWPL0q1wYYPrhgbcQHf82EZaXh7tErxCLG13yEMkt56jVT8y+l9ziTc+Ly1hUYe+60X
 hFdG/86w
 Hz3lDgzY6ox9liwIqnapW5LeThdpmP0z/6+VLUVcHaOliv/dC83G8/a4ciRayCDBwE8BWp+7mdVskv0R8czTSsxGyLEf94jwFUtZMWa1BNlPt4wyUSLARTc4Hsgi9XrCj/HAwxsbxry1a7/KqxFiJbTj17AX122qpaHYd/Sknqy6MPpZb5EgM0RYNHEp1eDCOd/GIr5zPIbmtfPhZyjeT/ysrYvLpUI8gb4zsvIs6EUz8Spr1KObUk4axl12yDDOqIwo3hHzrkjsBlDD6R9NhwKvRGFAUDkI3NcPcL0qNGs/SEgTYi/wUKhDStMaQu4yy1Rp95PcoRLnU2eIawEeB4/6eKJ9AL0GR0DQzqtZ/iNqlMDBc6Q0laePWC893rmG1nlQftp4K0qUguZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Can this be >= ?

I think we should keep > here, since unmap_end + 1 is the exclusive
end. Equality would pass a zero length to unmap_mapping_range(),
which means unmap to EOF. For example, with offset = 0 and len = 1,
both sides are zero.

Thanks,
Hungyu

