Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C14F0181A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 09:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5216B0005; Fri,  6 Mar 2026 04:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752B56B0089; Fri,  6 Mar 2026 04:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634AE6B008A; Fri,  6 Mar 2026 04:45:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9DD6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 04:45:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0603C590D7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:45:25 +0000 (UTC)
X-FDA: 84515155410.09.A57B262
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0C7BC8001E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:45:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mvb5w6cU;
	spf=pass (imf30.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772790323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
	b=fQUkJglgYrgms8XLQQ9pNodFoLMCAUoAU7cDxcaWXY9Cehb3rb96uzz1CsfCI31QpfVmjR
	Jp1rxWKuKq3EIzxopDgs29C93Kg96exOLCIOrxYE/k9IriMouPQS80YNdG5CNfrTLdU8FM
	lObFkc0TrFhcOToDVRMgEz5yLlNANqw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mvb5w6cU;
	spf=pass (imf30.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772790323; a=rsa-sha256;
	cv=none;
	b=cNaIXDl5MDf7IhiikSXjA7TVMMgLhyQUiclS3wcR69HR3jBecEC7hGfav1ao+qQz5VnTiT
	Lb+oZNV0cUXLQnp6gzn3KEj3q3x8vH5KT+OXN9099efjVQzLf11xKCNvevhRLCtjJb6nmT
	hpwRBEkMh9S78B6SOWBrye0Wwq47pY4=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-829781b2b01so1703554b3a.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 01:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772790322; x=1773395122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
        b=mvb5w6cUeUM03x4KiE1orfCllbJXjZ09oTBlHe3rIkYs20f2Q16qDDyINt/PG/BeSb
         nPUKCqHMeou3Qqx6aK+SAkFTTJCdhTZ4MEmOWQBytItO7zGLoL+X9c7sZEPIQ5dqVyP2
         4OvztfIShfLtU0aufhQb20Kbbb8CbCNYz//z1hScF5Elzphts7OQqLm4d95ZQz6GfV7B
         6Rp0T6TIYqXEqRvl9xnM8JQsZsP65BuTrPaxq2vIMXwqp7Q/wB5uwh8Z7PGfyHLftHlo
         zYj4UB4BuSSRHVKzn4h0n7zVrQbAJFIwBDRxPAXvnO7z2RBxnSNF0NCU+gzfO2cVd+UU
         /4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772790322; x=1773395122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wS1qxKCchhjtDwRNXR6jv/SqzMa5hcVlBO3c/OsKvrQ=;
        b=lz6Kk0nQTeSIDrSHP1c3iv/CBH1gMGz+Qk+l4W5tDEiybl9/xf2upX4lsR9/BtrtVr
         F0FDs8SBoJqvGh/gwoM7jGcMCNz+s6IwZBVX+VYQ2u0xqF29U+J5DKAJwymAOKIRIdDk
         DYUunLQGjOYn5GUOpe12csj0Wn5QJV/j0QzokCd+lR+zYS/wlMIzmnZJy/Md7bbhVCo/
         d7XHigioyFA3B9HcQj71Drop0etzYsbaekyDhBDcSj9P6e6Cv7E8QGcsB7etJ7APRphN
         SbKIbekq+4xW6JfyQDjr7yCJJCi4jLkv3y2w81vTFYJk24aQ5GDLpQUyJRlsJYsCc6m0
         QXuA==
X-Forwarded-Encrypted: i=1; AJvYcCWdkQFV5UDY+fXkNUD9Z74nUrVRlfLCBuDcii2MepjP2ylNTXDhqD6PGVcxGflV9RaypByGqLQdiQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0cH41e50qcUM+Gk4I+0ZVNnSg1EEVa4ATF/htElCNnv9VEZfd
	ujQ/HwTQ8oSG8ZUvcX/d7gA/2V1XadVylQYs1hjIV0/FI4uIUYcpSE2T
X-Gm-Gg: ATEYQzyxHcwCgKZOcILJ0u/zrF3BjGIC9bHEdj7q/KSPr6oK0BS+eDjsnbEq4QD5Mdj
	OuaH91vj80cN9I6cmbF3XircAoGwUtjbUog3dynREKdoAqwJhegKH5KrbIoUpxejWkLybvzp3XG
	gsaofiIdq3CcpsiNrZwMlcGGinfx+N93nejNQiLEsJKWbQBhZP0inDNPPlCqDGEe1EtdEiDl/v0
	EmCFzh4Eg/pmIZGxVTPvnbaVli1wVQ2mjvXHvH8CmXA/ALzttvFZApR9oxh6c9sCAL2Zt4LiOKd
	OWWudqnrL7vbhR2pBSHLgqlkGBX6dZD/H7V7JHygA+5FDUp4RIvOTVBCvSLt8rsNUXSHnBF5eNT
	iukl+EnDd9trBWAwxYVOj0l5D1XnlW1z6Z2WWOVDsgnnu9xkmv8TAkXGBTFZWjG7KPiFnngQQc3
	UjRIEzZ+bHlK6HqGdAvE4R0HWVFW+s/C49TTqNgLSQE2nr
X-Received: by 2002:a05:6a21:a43:b0:393:c4d:be50 with SMTP id adf61e73a8af0-39858fda4a6mr1885603637.16.1772790321826;
        Fri, 06 Mar 2026 01:45:21 -0800 (PST)
Received: from localhost.localdomain ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0cb598sm1080738a12.13.2026.03.06.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 01:45:21 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <jiakaiPeanut@gmail.com>
To: ethan.w.s.graham@gmail.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy.shevchenko@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	glider@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: Question about "stateless or low-state functions" in KFuzzTest doc
Date: Fri,  6 Mar 2026 17:44:58 +0800
Message-Id: <20260306094459.973-1-jiakaiPeanut@gmail.com>
X-Mailer: git-send-email 2.35.1.windows.2
In-Reply-To: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0C7BC8001E
X-Rspamd-Server: rspam07
X-Stat-Signature: a3mbtgo3gzdms9343uxogn9r4qqfrq97
X-Rspam-User: 
X-HE-Tag: 1772790322-18921
X-HE-Meta: U2FsdGVkX1++D1LUffAckqrCaFckPvy575Bqo9vtRUYpj6OmUC8pci0qnHqCuNczMP1OVKuNkg3DV0t76PeM/SntfC+d604Aq9qWRvjRONRp4kQc/tfU1LUAFBC3U3DFO+MGZjI4AlNVWRJ5asTihrXihIQeDlqBnaxLavx784bvqmEObb6DukCx8wpZ9vCAn5ast4I01/Uw3fLqbA6saQZOiiherdUebLTNmSYHOqiSIQ406YbWUjzFcpRzLqwfoATax4IQTOSxC+SlTiOEsWOX/ubs6ZKWkNdz0btNCD71bgFaz9+qSBYF6oQICssp7oRChDhCPC3yLB9SYaSFJwPZl99+ze62gpO2OU8cfmQ0aOtJ8pFvXgLdhk2tKxwKo37Kq8hQqTc5LopF3/jZ94W69JipJyXNwo42fqhQyQmRCmDaXj0J6DFUs1Wt3bU9H2DxkDn7wSl1ccElUwtj4ay/TVWrmKrq25EkX7FjmHCEnXf/BBDP8FihmO8PL1aWyHlpEncIy6qmbtoVuGRgbQPhCdrbmd5siRE21v2oSnBIrMy87Pm/olbBhjiWvh29OM8oT2YHzi3pKxBTqS0lVSgrhXd8GoJYA318NNknwtGZb7TAMexkWfwlq8t0w39H/pjJHigSy07kffFsShMpfLIy04knGAt8Im0SJmYoElce2FIRXmv5TcbQ5ol4/wfiBiOaSaFc07yXtQXiW+lV0uvwvAQtH/x6wg+Tt/2IxzFMkGIBDUdGZfeVkCo2r5TbX8vn+C/s0xsEBZtT+dzn1JYDVHxc45Ftmtw3tk9C5grxXnZLEuRjjTsbRbvv34SWQkinqRAFnkWxFjyx8HaiPitU7O68VOBHXAxEHlkRVVemE2by6jXoFaUNpidzjU1oDiOf8HDjBL0sJYlZrDGbUr8/fTP/fAb519hB6zcJB5l2JTaj+jlndUBnYFfGseX7my93A9ywNr1Ulphdkn9
 sILvpXm3
 hSGlExDQScWuHuoTSwTQWREL+a9A5pKGCdTl93a6nSvz59Ojp+mFgaJ94OFLnNC3XjVCc4bOAiEnY1NgJuCDBVs8SZQk1P7XRuTgaWH7/24LdzygQKBX0LA2DTkDJwExOH9Vd8lnjAZdIArTMLAyLR1jq2BY+Tt2CQM87BkPsTn8Y0XoEOJDw9Mn3QVQV+bMoRoEx+icCuWW2AkkKLs++KSIXH64qSbMlN6HdcL/a5dM3r3G8KYeUPlUxTf1A7p9PTONXGGkZeN9jfHtGEwQzYd7tlO3yphISeadhtJ+IYzDUPryRyPQ8RHA4wwlHmqBFr2JBQx2hcUJRaufMw88FoHbjhHWuc3J12/Py2Kb2rAifzQg53Kn9pWwild+GNBp84/BRZ71VPCSOq0/ikEtCJ7as49gHt/39Znac8VG4BNx5HJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan and all,=0D
=0D
I've been reading the KFuzzTest documentation patch (v4 3/6) with great =0D
interest. I have some questions about the scope and applicability of this =
=0D
framework that I'd like to discuss with the community.=0D
=0D
The documentation states:=0D
> It is intended for testing stateless or low-state functions that are =0D
> difficult to reach from the system call interface, such as routines =0D
> involved in file format parsing or complex data transformations.=0D
=0D
I'm trying to better understand what qualifies as a "stateless or =0D
low-state function" in the kernel context. How do we define or identify =0D
whether a kernel function is stateless or low-state?=0D
=0D
Also, I'm curious - what proportion of kernel functions would we =0D
estimate falls into this category?=0D
=0D
Any insights would be greatly appreciated!=0D
=0D
Thanks,=0D
Jiakai=

