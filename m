Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D73C60A2608
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=HsDdDuaO
Received: by kanga.kvack.org (Postfix)
	id 473806B05B6; Wed, 18 Nov 2026 11:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423EC6B05B7; Wed, 18 Nov 2026 11:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A456B05BF; Wed, 18 Nov 2026 11:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB5186B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:00:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C5391A05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:00:14 +0000 (UTC)
X-FDA: 85448701548.05.D49F2B2
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66A28C0012
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:00:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HsDdDuaO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gN7nvCApkpNJjBBl+gdS00SQSe9taX0A7DICocon5Uk=;
	b=cKtizPnJD6acsTOtQaphzwg2LfGNeUi9/4PlcM0n6Mebr+GWU3Y9QyrREFIWbH0ft1Va2H
	p3GvQdmtSEPfX0JzOJedEsKLCiUnTFFuNX4K0ArmS330n6BQSabmumx8cXvqUCmEhNhuvz
	6YCGJuWdh4guw+AL1Jd2F7OeXi+3a0E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HsDdDuaO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017612;
	b=KYaArdXuobLnF89tYN6c4r4xp4U39s9dpDeyN64DUkKAqZyFdVDXGEIyxP+zrrcgFv2BNJ
	YoA6EYAqs3EhPDlhheJyxrkhJS1I33tEtwi+4cuSuruM3z6wJRg/zNUWWdlgPOMeZRra1n
	ihtJnQFFrgk4jVczn0YrqYBsmZUtXdk=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eac319a6c2so810815e0c.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795017611; x=1795622411; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gN7nvCApkpNJjBBl+gdS00SQSe9taX0A7DICocon5Uk=;
        b=HsDdDuaOkBgN31GHfWZAC8g0ylYkA/HhNZ1Do2xI0erIo1dzWoNtNC/cvuF5/maTmX
         BuLaqwux3FCUaKx0LCVbtquM8BvBIh3+d/9jJ8V96LB6Z3yrcn6C5LvwPC3T5lMDsUXU
         ZIKTO0tfOHiyaOP6fomV8tZdZIWbmRvcVr9WE/vZ7FN6QcOmM+iaPXKkEGFDB5hwn84o
         NjhhSp0qqEbN3AOr/3rxKbfwLFMYtc6D9Dt1fNX3rJ5+jdA9X7mPDmxn8kudWsSX6AxW
         ucpbT8nlBDzaoSlCWDm578+PJCiaPFoZ3UOiySwZh6ycynoE94OK2V/neFxkWW19OXg7
         G6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795017611; x=1795622411;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gN7nvCApkpNJjBBl+gdS00SQSe9taX0A7DICocon5Uk=;
        b=oEyGKkhUPM2coVSDMJ15hKaz8V0GAlForkM0WZfBsUSxtRrTAj1OhkHPwsXYZCu2T6
         m/nZkh3c049lia3h2/538Yvp3l5I6QWym8byhuIkSOOvSr4xd/Cp6zMKIuSEUdSqoyjm
         MmUESfiUIQxwUtZEqzgkh+Y1W1dVj3h6dmZhhX2/iK5SrSQDzSdH3Sdsli1hT4IdXxy9
         g/c6BYcgLrpX3+bbGAsbEQxXML7vo/P4+8cXNhGop8SeK6UdDkbBJUeu+MFhS8ShIGB0
         xhA08BWxVeKC68UQomA0ibDMjX/BQMqNxh/N6DSG7on23fKL6aTjqLtHwusQhsBFiFJr
         qJsg==
X-Forwarded-Encrypted: i=1; AL+hErEmj6EnRc7qIFogjK+IArRFj5yGNHyCH+L9yZ/IwP9T8WjI8GJeUnU6TRym+XVC99jyvtfFmtHXng==@kvack.org
X-Gm-Message-State: APuU4Z/pY9+B2YKNEwMmjbX9X9L1KvQGmEouO3uhRcxgtK6mffH8Mq/J
	efXzNzDpDlzSm3OyXOjb0C3zDbHHHeqfdIWRTB0UqwyzYFk614vOy/7NMffYogpHLzTrBBXErBS
	2GD9e
X-Gm-Gg: AYBFou1V1pCg1FJiTtrRda6wwGt10dtv6ojizOXj1pg9h0ahlybmlOxL/+Bf0e0mOOG
	He2B1Fk0wRpVq635Z1dhlN9+KpLlyBVQOeCLRacn0IgAAT4w18WPLh0uNJLq+Vnm5+I1EhenU1o
	AICeyN8pH3M8EQv8TCuVrGYZrErmCTC+BOnRChKfRKO2s/UeIZvlRJYmx7JWnw+gpTvolYQzkym
	9twCn13v9Z/VFVVXF/NWkjcBLwROBX+rLYPw6FkfMGsUsUjiKfbZIw1VQgixORnHPTfuEzzJ6YC
	NgZtVWJSYvSZDMlYfU2+bSQbJReO4dnuhD0IyqWJyoUWTV6eBEBpYmaYBsls+kJ7bZy/2LEiraW
	45AALBUrkr1NbkxB9zfuN613wE/OWIMbofbsTebvpUgxS7Ng0PKMVxVQd6/RLVwTBg1E6G/udIU
	EprGzimNhXgYKJfQr1+ep6L8H8xkN+Oy8xyeT5pU5YKQoACGerfNjVJvxH1WN3If0g0OP35hino
	lD99fCOnfWNXw+DpiC+mSxXgQMW7OQAjQ+HkF1qsxHPJXxCSEBKGxp73HUm8KjKpv+saCdPbtfl
	NO00eZPz768VDBCJ5F0mr1ZT9vifRaLi25bWngxDCBt0M3PtdfcEHRSJDcKfLJTn0b3syPs0x4N
	c68q/XDQ8+LGOTrUQ2cJNj1kae6a3OCqJsr4oeUv8gM/F8t5jCv+0VpzfApUfOabJt3wq
X-Received: by 2002:a05:6122:3a15:b0:5ea:389c:51e4 with SMTP id 71dfb90a1353d-5ee645faa03mr1663031e0c.2.1795017611348;
        Wed, 18 Nov 2026 08:00:11 -0800 (PST)
Received: from soleen.c.googlers.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee64ec2730sm2002506e0c.14.2026.11.18.08.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 08:00:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
 pratyush@kernel.org, graf@amazon.com, shuah@kernel.org, 
 Chen Pei <cp0613@linux.alibaba.com>
Cc: guoren@kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20261118091603.979-1-cp0613@linux.alibaba.com>
References: <20261118091603.979-1-cp0613@linux.alibaba.com>
Subject: Re: [PATCH v4 0/4] riscv: Enable kexec handover and live update
Message-Id: <179501759947.250261.1712117569683645423.b4-ty@b4>
Date: Wed, 18 Nov 2026 10:59:59 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1086;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=yx/6YU4ftdolIH+TM3tFCIqxwpFna+tV5pnuszpTgAM=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq/cuKW1Ven/TsYWcH9R9JVtNZvIr/Wrzbj9eUF
 VZnu673CJ2JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCav3LigAKCRC7dyhM23N6
 3l0zD/9GkT2xiw3xOPo4dtrl50v/Zo+28SEOr65ml35aBi52o28TK4homX8OAljUtDYygGhutpM
 WxnvBmRGuzLI5PV5A7/SV+WgkIZ52fXibj+mPS9LI2vYsbaTB7qWpXD/tPjUXOLL3sp8s0nWgA/
 xzgDZjJbri0YhMen/qMzef3v9u09p3Wn4uVIdtlK0LLcBqgYpEtW1xCFKqg8Plgdmm8VzBkMBqm
 201gts8eO1QmJ87giSN1+mgcvDTecZXC7TLBmWsfh6zueYb2h7iy18luOHRy2FcgK/fG6x6oK+/
 q5kb3mOX9vuWeOn4JfkYG9JvRemmTyttU4mvzXS7wc56lZd8ObMBpcWCRJaliTNo4Fwky6rrbSU
 ubyyFqvQGzUjfL2/Rp3rc+Cie1RnXgh0XXw4RSGXf6YrqAi8dVFfXKbWikrk5D9dqJ+2t6zEbFK
 +GHKpssJeeElG+UOr2KEGjpeWljj+Alhh73XBEVezYA9oWQYDth78nJKELwFtPq8Xcfc4Br9O1V
 Iu1DpxwaZOV4fUHtQpY9XdoUQSLklPkalqeaaIppy2vDIKY2IMWWeLNhVX7XrCsNIO3L/BO4EIS
 BjJYaBZ3qqGAfTeisqH8//T8U/uQq7h8rHx7J2zXA1bXqN+ErinqAopKFwtALn0trP8D1sYJivX
 Ntme4+UlYo8oAIg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 66A28C0012
X-Rspam-User: 
X-Stat-Signature: x35d5z785jukpwajwaifw39ybcyzkcxr
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795017612-45548
X-HE-Meta: U2FsdGVkX1+mEkS3DcObCck8eDg5yYhUgXuFMFbxVhSsyRqUbV4oMoqAiySu/s93TjOkP54PmIva3tJc7d4XRP48QoOq1U9ZpGoykr62hEH2Uu00xyJSFRvq2gGR8Qa1N10dDj0QvEmfYIJvcfFCifgj4+mP02Cv9ryMTqylomY2FqlcwJDpARiln7D7VHWZolv2d0O4E6VdrqbcCk1p9kopIZdf9ZnBSTJ45AgjHC/2X8dPiJiUpEjmWW8t6z+Z92exfvJ35BLuYI5hqtwae0fwG5VnzXN1zi+sgS3Knd1YXkA/wjoroIzi/lRliudOm0xUMtHuj1JypWhl4W8ro9UmP6DK0nAKBdjYXG+DtNNSTJAMopnei+o6wYbktASlKNlgXC1aLt0UN4CBdaPj3RTefkpclGqv9V//5YyiOmSeEXDPw4TqlAEhPvu4Hoif/obEGQTPZq5phR2+UCHXGQwxD8PtbfeecHhjaliEObLceU3v7t63VlW3W54AJcMUouiQ/x00H9fG6Y2ZiqYlC7I/oTjqvEKgC2T2TvywI5VWEr+tCa7lKIlJUTS5mwKCLRTrsO7TT1Id1x8fCHDJd5c0wHlx9xUXpnnoB9HPyfJz2WRzrhQlUG4Z3KN868ThQAofnwjlmxJEKpNjA7MrwhnEKiOxfAw/O/0ta9LpD2/UAHoEc9+OnvrodvDO7ctG4GP9nIoUC2ngvp3g6XtZSjZWDbLqAbSYN80YmVv6pOQy0IqUHPvVJfRmK8VUtZAlzqomQv4oGDFyIA26kQBO/5qBV6Xcfo9KPR6LrE415H/KRdFRv4Lkz6T9Ui35m4VH4FzEdQu080CxdUaumflir+VwX+u5//BaNtoOC03Z8/O8DHH87qwPpMlpvlC+Z+CNMyR6yNuyXKkQE3hAxCV7s9DBzR4PYmTQb1iHPZlOrCC+7rln7TR+AYIMBfpFtnWI9RPwddHh2qVTbWk1nAR
 cobBI+Mm
 2VW+8DNPC7WEU/SIYgDPOcUnGlxDCvRUhBibaGWIpAFFTEvNHu368Z5H7WweDEXN/uVm/U1QzuvSR8M/T0xefMQzKfweCY0P7T5lg3j/kbZR3dXUACrpFW8RJS/uD7m3kryI1F6jKaah6U8ATpOxFTsN+Syy4s6W+HGcAwBQhusvlMJ8CtqsGQRWEQCfuDiXs84zLGQF7x//kBMr9fnx3A0GP5F0gQ4c56mPLeGvV+FeZkQhwpXFHPfn3TYPgMDuVIWne9pW3ZyvtegkxPgyonDME88ysAdZZNA+nXK+eg43YJnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 17:15:59 +0800, Chen Pei wrote:
> riscv: Enable kexec handover and live update
> 
> Host kernel updates in the cloud should not require draining the
> machine: next to live migration to another host, replacing the kernel in
> place while preserving selected workload state ("live update") is what
> KHO/LUO were built for, and LUO's documentation names hypervisor hosts as
> its primary use case. This series closes the gap for riscv64 and
> validates it with both upstream test runners.
> 
> [...]

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=liveupdate-7.5

[1/4] riscv: Call early_ioremap_setup() before parsing the DTB
      commit: dc821c9badf7b2558e206804c2adaae28d25477d
[2/4] riscv: Add support for KHO
      commit: 48ea610913a6d6fc513d082afad04ff342120931
[3/4] selftests: kho: Add riscv support
      commit: 30c6fc85b4fb89fc867bdea413403bf169e7e194
[4/4] selftests: liveupdate: Add riscv support
      commit: 9615c5074cdccb651684e61cd8872ca8b0b30e52

Best regards,
-- 
Pasha



