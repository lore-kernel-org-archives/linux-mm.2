Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A58D46C0B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096DA6B0088; Wed, 28 Jan 2026 17:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041236B0089; Wed, 28 Jan 2026 17:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3F36B008A; Wed, 28 Jan 2026 17:41:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5F686B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:41:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65FEF1A03AA
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:05 +0000 (UTC)
X-FDA: 84382844490.15.06B78FF
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2B35C0009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LPvrcmaq;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769640063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CFBqDi2MhzlU2xHT6zZNH+VAp4IarCuH5UPdXixiT50=;
	b=xaTjMGk+ibh01+OSyldBSyMSnFwBlAeifDdZHVRbIkD6TrDodxsul+XICxM/Nf68DASUOS
	R8SDywZrYZO7xmn0jtKFCkZJM2XAIlCyoI/5M/LJPsz2/G+IO60TknnqVUQW3OfGFQxXib
	gMMV13m4Mw23IKtXwIWo48gO9/dXVus=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LPvrcmaq;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769640063; a=rsa-sha256;
	cv=none;
	b=Tay6gTaYGysKfR0K3NyxBjhUerXZo441Vo4BMf4C8AZftkBQHvSd4Et/09sqZSuG1t/1bO
	96vDzw0jxu/mwjMl1fMaw5gq6ude4Kd+dppkUH3QelmLLL52TDLtcUCSsYMTveWalrMfC2
	hnGXic2KDZ3VZyDzJeYv5CmWzowTFaE=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ae2eb49b4bso960176eec.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769640062; x=1770244862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CFBqDi2MhzlU2xHT6zZNH+VAp4IarCuH5UPdXixiT50=;
        b=LPvrcmaqftMih0AycjfsuOtcByuwUKShseROsr2r67TDdXrsBCGr7EyGrjYUwNNupU
         5U60GKmAF4kFsR1pKvzQX1QyU9/muV+jmDxW63zC/P0phE6AuMuN9uNxKUi2LgLkdxYA
         rWiP7LRkpn49793vF3vklk4oKe9NHITxS1mgEdwpSW+14UNYXYN4Yc5TVcz8XrZEne7i
         newVOCpG9E2HeJvAHZN6NiS63TQVsKKAJ+3egPi6gq2aFI5YWMrUaLAVyGdFesUO2ioQ
         cz4bAPUJa88HGlgh2owdkj5DIG9UbrughhJ1fIey8cjk5Uy7/oog5oXJk9Y70wlwga6N
         q0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769640062; x=1770244862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFBqDi2MhzlU2xHT6zZNH+VAp4IarCuH5UPdXixiT50=;
        b=OjvJpH8lbZJEMeO2J0aKZ60VVSnBbeutIBILJiVNvqERUKxE1WsEP2D7WPmBGWMHNp
         T+Ry9VLwTfb6ss7UsqxCkROoFE9jysJ5+Jvlaf/l92IDv5YQunSUbbkZc7JOysjx4QdA
         fL+fSU3xGL4HLMDM3/wJag3OHQ0oTnQ/Zfu6sRrqe8NIE96A5wUkNYb+fZrBPflIVjRC
         DKyoPEw48F3NDZnCKsuciu5VS+HUCa9CyrPIrShP5Z6S2jXuG3lWSJboaHvCt1auwcpu
         YIH/7YNXaDDtEonzZnYEp/bs0eo0xlOwemdcTQcxf03Kyyc2ef/MD4+Qf+PTFTKxwBu7
         uQHg==
X-Forwarded-Encrypted: i=1; AJvYcCVQzfO0Hs3bTWsrJp2EDVVgmnm49noSEWttDXoSCCWtbnpf+vxA9RLLRurRchWoohcSJpocoQrkYg==@kvack.org
X-Gm-Message-State: AOJu0YxVMKw1Y9cjFxgdccgLpZ4nNtm6M1eGcO9srwl5/uB0rl/AMmxk
	qBQxqxyG6AOYZBR7uXLQR9ph1zHBF8eNbgiuedkG/fVJ4XAD0yOXQCDz
X-Gm-Gg: AZuq6aI7TQIJW+Ao3M8IbHlBfdCB2BfJ7UWSGfbg5lzgPAbkk76lrnaHz9buNAuXusU
	ybsE9OgQpJXU1pQf/yAjFtNOM+O/mwcwKzoPzJftzRq4VEaQS1r2Eh2mmHnsTCp8z7ea55iAhjW
	MOqK0TkHJIK9omoj75+ILALslI84lDU4n4r9pm+gbOSgUqJxe7rdN/WwjDWUvABjlOVOEQXd4yr
	dtnK/6QUaOJkfCbcrHHIgqQ0c10/gWmgnSMZaqY25GxkH+t83IyFxQO/5zCqNltBv7h5J9RVhCQ
	UpDyhv1JLiypUSvmiLGWoMYRXve54WDyB2e1aZV0+x/F9l7vYe3QXE+2QNM4Zjiagn/8IujxbB6
	NiEIQw7ypsSA0FRxiR20nJDdZLuahLalTaxMTLw6hPlfc3Jf9M/M4ABBdMnGyG9blkIMXv5JWrS
	bn72W9LoJBV33ITI7BQeW5k8hVo61rovzzdC66HJiOOnk=
X-Received: by 2002:a05:693c:40d0:b0:2b7:2ed8:7a46 with SMTP id 5a478bee46e88-2b78d9d7658mr3597446eec.20.1769640062058;
        Wed, 28 Jan 2026 14:41:02 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm5439115eec.22.2026.01.28.14.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:41:00 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 0/3] Convert 64-bit x86/mm/pat to ptdescs
Date: Wed, 28 Jan 2026 14:40:46 -0800
Message-ID: <20260128224049.385013-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 34ryy5dqh3ykymbqanq7dfxpbepdo3ua
X-Rspamd-Queue-Id: A2B35C0009
X-Rspam-User: 
X-HE-Tag: 1769640063-351928
X-HE-Meta: U2FsdGVkX18T1ag73ilR5AGK109u1ENEZkDHP4PHT+JX02pM0YJW3TPK2b3N2fKInoxL8D+C64DdV44rgRlWiK6sZNLMOVTbREA92JTAwmO3rCKYvFXLDzYiDAGgb+WxQxs7ajRyzoB2ABWvdRnwW9uFfiBjDLL9UlLM93yzATZRubPtam3xc1E7uADIrEmVVYeYYnJqpandg5ph2+U4fFeK6SqqULdMMiSvMdeCgY4HG6PN6ZrIAIOpPcVxcSh3BDWz2f9u/uarHpjaonlrNvMDlLfsHesCtlmPzzcViBbNu4DssUWu2CpNQKSFkI+ZGgwAvzq2z48B2orx/vdAxgeQJG+lYnErrZCq6GhmtfAP8ibjkV0KyQhljsrT3GzcWPBaQlBMB5Q59TeIhlkPwoTtdi6O8IoUotZYHxbhBJSlz1P6SePHWrQgZS7ONscAKsPHMJkbF1ueYncv9HpGbqrgCpX0OZgazjgWyvRPXdgbo+uPXcDRSJyVGrIkONCBM3/Ui+F13KS0lkqfTyt6ZAMyyWfuFI6eYDk8OVrtEVg0E4jMiWvdRmZW+d/Z84C9yZt/Z6p5JG8jUK9Huc9vjjQREYVWbajc39aAWvQA/66ogMHxozLbqtsl8aDjY7Cr89pT7aERHCZbGL0FKTl7tCJW2JIx0o9rUOygdU+6O55DH6+NYpkafjJOWyej0NbmlT7PjcNFkAQJ+3SRm798bhtytwt/mrOzCBKWub/PawM+sENGjPoTALagTxoxXzWDGW7kHX6vz70XNhB38oS+c7DGRrvDN2dvLsoEd0dEv+soxwulr1UtCmfI7lwtJFhyM8KX2E4cKf39iqRSDFXLhROnsfijWcdiTJnJ9Q2DnVz5eraFtfw1cMXUbEYLUoD1Afpq44xGGP+qiVu3oohnR6Flnwg3cuSA9kfLR+mMPUVYHwpk3Ov7/AejJSccJqGj2ywtq30gqEeBqn4aIXl
 j2GIf3cD
 atSXTBGtx23OIvNkTnWuOLqLQd/JQVxFy3xe5T8BebGO1P9FcywfVuNt2gywL9YMvZPr0+yjJX4KIvEbat9QwaM5jOgpWm5X2i+u5dpJ08MMG+hGmhT7EB93De/lQLwDbrvbGlQSaVadMnBg3qziRWS3jZupSmoLx6sp9RnlENQVzj6LWCA8Kx+9kX0uu7rIgOpZnDGLsNhwJI2gdkMpw/jpS3DVbrpD6+23OB+391nZpHxvdEucIxy5y2BpcSfs6OOwqDQzecTwHSN4KTcOg+BBZj3NPQf+BwJSsDKfUmBhqNayuziG26xTeffzsgkozTI6KLi0HPr3YuckTrffojQYicZygMfqsojCA2IIp6WN+IMwYvPCBZwLAW/zkOP72WtDlOPCEDWv6lzjh617Cerav58KepaEOhqJQKgxHkQPCNdclpe8XuJydFfQRw0LCpk6CRLjYQUOBCwRQjjQI33mSP8qJ/t3NFARpQXqDwPTamHN2jXHzUJY+WLXyU6p8fPlOtCf3z+vsrQSXqQu2lcmXIYMzWrXqNUvx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86/mm/pat should be using ptdescs. One line has already been
converted to pagetable_free(), while the allocation sites use
get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

These patches convert the allocation/free sites to use ptdescs. In
the short term, this helps enable Matthew's work to allocate frozen
pagetables[1]. And in the long term, this will help us cleanly split
ptdesc allocations from struct page.

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/T/#u

------

I've also tested this on a tree that separately allocates ptdescs. That
didn't find any lingering alloc/free issues.

I've realized that the pgd_list should also be using ptdescs (for 32bit
in this file). This can be done in a different patchset since there's
other users of pgd_list that still need to be converted.

Based on current mm-new.

v2:
  - Use pagetable_alloc() in populate_pgd() - in patch 2
  - Rename subject line to specify 64-bit (i.e. 32-bit wasn't converted)
  - Added reference links to the projects mentioned in the cover letter

Vishal Moola (Oracle) (3):
  x86/mm/pat: Convert pte code to use ptdescs
  x86/mm/pat: Convert pmd code to use ptdescs
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 43 ++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

-- 
2.52.0


