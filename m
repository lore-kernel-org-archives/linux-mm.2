Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1650CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA098E0032; Wed, 12 Nov 2025 20:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E008E002F; Wed, 12 Nov 2025 20:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961D68E0032; Wed, 12 Nov 2025 20:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 730C48E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 379D389898
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:28 +0000 (UTC)
X-FDA: 84103896576.28.FD16CED
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0472AC0012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="e/+peyOR";
	spf=pass (imf22.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnUrJZR22oRvK4b9Hq0rnS55dGa+J0g2wL6xk4xR6+s=;
	b=5aN+y36gV0ath0l4mXtD95MuYu2TE4C0H5g+rBj2s2nxSUbuQt7IfhyxNPI8kcm9UkVMU0
	62CEk803mI6iknB8aIR3nxwbezT4nmP1WHA/0laSznJ3NVYiRSzrhS1hbuYXutyZCJ9Nb+
	UMzqk1gC69Wo66copAkhugXUEi8wjqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998446; a=rsa-sha256;
	cv=none;
	b=e8iz1nPscDOk5HmKWvWDgsmyYvErkJLvjXnCx121OKBoA62KsV19kpgifc7csg4HvbndTZ
	dUwAtNa/Q9KA3Ii9HuEIEToNUgUAj7zMsA7OKtZCWcMg7FcuLs92phhzuUMJZOKC5x1Wsp
	YtuCSv0YpcafUuSPK06YJdKm1Zg8jOo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="e/+peyOR";
	spf=pass (imf22.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ba599137cf7so268205a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998445; x=1763603245; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnUrJZR22oRvK4b9Hq0rnS55dGa+J0g2wL6xk4xR6+s=;
        b=e/+peyORFR3N5ETZCk1zDzJ0LIE+NR7CXw5JtxxPwlcte1x7v/2s6Oj0N8U1DPWbU1
         Y+kdjlltqrcf2Sm+/wxG+9KyLlCP3Z6BIwMnPnJiJ9HwY4k1+c4cD4E3dKifftL7Z2Io
         SS8HOW/n6lTcNrjoCe3f3QqBTrAb500GKsqPbBpxNQ+FsqKytfVfCZKri//n0mj5OTBc
         mIp/sBFpwXg2bsIpXvExT4ItqgdUPH372DHy9Hvh4Kb3owODE5Ad0eZhzbnEVd2r58m4
         ENZVN3JyAybkAbAkQRG8CNkvCpOYvKvV1s2cn0orP+LM8r/TuLrRK7VfY3dr0sYVNBuO
         leTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998445; x=1763603245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mnUrJZR22oRvK4b9Hq0rnS55dGa+J0g2wL6xk4xR6+s=;
        b=mgxwhJZcjDmSx1NIrLcVIQRJ2IdaN4NvuXlLZ9XH8WdSumV5858mYxjtgVDzvuU5XO
         lm8Q7tLaGPotQkfzAWWpuMDaMrs9B7zVyBDGsykKa737bNFjL0qq/Qpm925N586vq2R/
         OUe7ILjCDP0L2tRhf9I4U5HKY8BhG5LD+KrKttJ2sgEzenF85VNTUciYDV4KgDvIWvoG
         JN8irvC6wsvNdvAqKbz5BtmRmAB18BFg1iA55NqdjjR615JfNMszztUlPy2kCQ/Vuga6
         JORRQTESm5y0dWRxOdOHRctopYfGZeA44B77RCNdkwoESBUVmLf87elvppIcXS2A4ka1
         aK7w==
X-Forwarded-Encrypted: i=1; AJvYcCWmbBjSChpSDjzV3Sm8fUHj6dh0Xc5K1pfmmGcB0r6AacIc4L9HvZRzfsukxxNJ4I9Py//TcSAXOA==@kvack.org
X-Gm-Message-State: AOJu0YxLQQUdL6rRhnlVDUo+meaPW73VM4/pFFkQuBziQZ29aQkBOb6R
	G3MXEM4dCEQDdmChwvNbAz5YmTslq6cxAQffg8LAlyR61uB9oN6DtnNKH/W4+ZFWL9E=
X-Gm-Gg: ASbGncudO//AwTZ084jzTLhNBAwNXIQldigTTEgc1gjtkH27xzeOyyHG3b5ASIBIOKf
	SjJFYaQ3Dyurs4ORTWRSvk305kTm31TVPQWa9aDDlLlTimbb0hU/Mr9G6U/5r8azA2Or9Hq6fQY
	KyEwy3MafXfkJvm5iYMGQ6itFInJZT5A5A/W5jWrMo0BkAYgUrYwJGsIHUbzMYbbM2NumWE6SuA
	HFEoL6uJlMg00CGd857PlAqKSC6R0YreD1QCYg185vGxc3EfbwKU4ausR2fIVeKRglzGAQvn4HS
	I3A4E6a6oDc1IMnq/VxEmzj/J6iLys5MEzsJYLJZZPhJ01EKreQ9aXj+ndLNyNhzxfjOgRMFSdH
	1Oz0+YR7IMXPbDN11VqvVjkm8Z6pAaPF0OnImW3XMG5OnnQZguh03xRNMJLHi8wKKIpFyhGlHMq
	jtGyiEi1jxU/s2y9ojj5lskg==
X-Google-Smtp-Source: AGHT+IFqAfqeVcZ22DpgtEmtnZ9MrEayC7yLg/9qX8OddaBkDjNDdLzIDATV5Jsr3mCugzkW5GzqeA==
X-Received: by 2002:a17:902:f54e:b0:28b:4ca5:d522 with SMTP id d9443c01a7336-2984ede9839mr68599425ad.39.1762998444849;
        Wed, 12 Nov 2025 17:47:24 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:24 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 17/22] riscv: alternative: Allow calls with alternate link registers
Date: Wed, 12 Nov 2025 17:45:30 -0800
Message-ID: <20251113014656.2605447-18-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0472AC0012
X-Stat-Signature: 7bpbag9od7ej511jc835q969wchwax55
X-Rspam-User: 
X-HE-Tag: 1762998445-175569
X-HE-Meta: U2FsdGVkX19Df3FHh2MyE7WPVsBHSfStoboTu0kP4C7ynCkm0o+mWyHrm1WxC6uTRDhFysCNMwtaqGf0RLJSfKoOPemcTgk82eAj6FaB6AZuBPzj/4YbbMQ/1n1xQHoRQS7CTefJ7Et9O+K8c+FvLvl9t+HeNWsqxXSgHkNQkl3L6Wj82mi8p8enHf0a21JjmxbsjlTShmzgKtzwPub9nr9vgpVVYNKpVzonHaWdHyuzItx5W0ABmRLt86G4itDULG1Z1wcNi5Rj2h7ZcXdjfx0nw2RlPqCCQ61aDFu5Xi2WAM7bLZid7T9mE/ap3w67RN3hP8LtNPD1102tNPvHwNBE+kY0xSN2sCS4Jay2xEDkMQU4bL+bu0Q396HXQQizsKNLlvjmwsgV0ULjlOcxTGzBEfZSAOSWxkXZY2ZCk7LgXewvo5l2xz2NoUghWKAqYwVKAxDtMyJO8JqzWk6Qh3MBLMWoRNsfKXkkpijzzOQkcMdpcg+IueFVP9O1Fri9u6+m8g0fwY8hiUql05EB4NLimfZCVZC4Cee11pJwmrECA6uY4J3Ea3RDhIbbOhRy8yi1EqwD7H2ph2ekyEzBnxnnaRAC9nulQnwBzX4iGpX97en794Bg3h85hNPmpNzS+rgrWc8OjgV66GRvLSBGnEB5XMISqtuk5FxDrqfG7WPQ95PGBi8QgzSV4F3L8LV7Rb8o1OdAn0EKkbiN3gkCZbnOhWbkpP8D3p6tzAZuQSwr5F8A73sfyBQ0NeNCGOyCD7XqiWX8E6pjonM2aDsk2pp44Aqgsj4d1p0YHa6248RLo3PdDm8m1JAzaVGBnMaT557BDEa/aYwuO62mjFNyWjJoSpzYZiZ2gnp8MbcT84L8BZbxGAZzYas/jHf2+a5WO8wY0iiT9prTT5zpuUtFHU5WPqJf7EIRNVcASmlU1elL1C/WTvPFRCMUg0ie7x8WGFeJUtkN66PRPHOE2wT
 HmgGlDuW
 ckd7bxipplRexvtkN2Co3d6Lj261qrt1gFyZp3dtJyf3g44CmpJe59ONLsvR9X2kvAGf4LMSXqe4lxplpmp2ENya4EQsf1a32AagOJ7OqXOgCYss1lW08ATsxjPux27ulPmZG2TKx5n2YsoFnYiAxDdrztu/xcWOOW7uYYvqEQo5UycpTtzRgxTrrVRB86yX7r0tHITHvZDKwR8Yar5p6CPjBWFDwxnCBIVvo9vBx9OgE3Vd/m3xV5r1O2eyIGDHOn33zVRrsKR99UkJ4J8Ri/LNh0JWHvS6OIi3wLSebBKqPLVE38a51pXm2lMaGwn7D3xk0Intq1IxEmuuCNDj5+8CktQ8n9QpOHe2ykeyg6NXli2MuELtdeTsGqS9Tl9RQ/C3EFH3pa/nEOHLad8yqMxpJyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alternative assembly code may wish to use an alternate link register to
minimize the number of clobbered registers. Apply the offset fix to all
jalr (not jr) instructions, i.e. where rd is not x0.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/kernel/alternative.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 7642704c7f18..e3eb2585faea 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -126,8 +126,8 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 			if (!riscv_insn_is_jalr(insn2))
 				continue;
 
-			/* if instruction pair is a call, it will use the ra register */
-			if (RV_EXTRACT_RD_REG(insn) != 1)
+			/* if instruction pair is a call, it will save a link register */
+			if (RV_EXTRACT_RD_REG(insn) == 0)
 				continue;
 
 			riscv_alternative_fix_auipc_jalr(alt_ptr + i * sizeof(u32),
-- 
2.47.2


