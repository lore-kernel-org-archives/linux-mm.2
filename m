Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9551BC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E66E6B0365; Thu, 24 Jul 2025 19:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246CF6B0367; Thu, 24 Jul 2025 19:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C11C6B0368; Thu, 24 Jul 2025 19:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB8816B0365
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0FB2804E0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:17 +0000 (UTC)
X-FDA: 83700771714.13.2279957
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id C971C140002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=xlyTFWMK;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400235; a=rsa-sha256;
	cv=none;
	b=yC3TcTGAg+ejX5mpUqLyDuagrVkuc1EAxGFKNcPcYUlNo0M0lt5CiyuxK1Z9+jwPGPKfzo
	rlgzbtbVmaC78jyMHzB9vApOpH6S2h9WZ0LBZoPNhIiRbf2rL6KPPmWyvlqWmSh8Z8AJV+
	IdXqKd9rQIQBL64FvrOOL1DFIwfccoY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=xlyTFWMK;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAeHR6jMoeNreT1rLi4tkifNH7GwHO7F0FWeni164mI=;
	b=iapIdnrfvvLgNOnPr7xFgZaCiagPzOuzWh4Xjk2dss4EyLavfhis6ciULUyCIa+ChGs93o
	Zb0JCnSMAEe1C64E4QR9T90lR3qQRPh6E+U7BDztKpENqpCPEBGqX7S9H5Oo5xKlc1bXva
	e/5GQRSFkG9qGTpUTCzhmuIXfIbG2oM=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23fb04ea1ecso728175ad.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400234; x=1754005034; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YAeHR6jMoeNreT1rLi4tkifNH7GwHO7F0FWeni164mI=;
        b=xlyTFWMKTCI2C3QYYus7n5ajcvYawzh3eUScQ2zJDBa75nkydTYtwRoCS9nBOWkEAC
         HuHZ+zGn6mXK51XXI3v05eps8f2phtqZTLzf8FT7wstlEG4HupGSKkgc3YCnWp371Ki1
         8ttHHZAjPyzpvYmHLBInn7yJ33Eaw5JJ0Gd4PpLrm+gN+mFS1+G5qoB0DPcmyz8qlBum
         YE8J2fPfkChbhWhM/SIr7PindzD1gQXOZSLDUkxqebJPTE+3Y/Q03+tIjucuLfX88jXi
         cHk+vEbHyjPCkqCzQ2sb2lUn1PBjD2zmy06Wc9BBUPakrcJ7KBbh5+WKxHQpq9AEtkkT
         gJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400234; x=1754005034;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAeHR6jMoeNreT1rLi4tkifNH7GwHO7F0FWeni164mI=;
        b=UVaOJH7eq1Qwh903LQe5KBkeRGblQ/yHYE20Edu57yiR0HXlGz80qmaF+nIcdq1qVT
         0PEhkhCSt0jrJp1FPcuZLtVSB2nyegUE8av3UbYoSlI+JGTfeZKyEjCA5ODVyzDw2vw3
         nZs89mK2JlQT5qu7xSghe6m6jJSCn+x0SUQ2gvZUYmgkzzt6TzHWAgYj2F3i625jQ1In
         8kVj4/U4dwZ5iqm3m4hU3cYdsxvoOv/NI4aZ/kqVBUAV6ntSQQiPOFBNyAMst37XpoP5
         59iZDGs1W2YhNCOBSUcKDiSPhk8Ypokhad/JiEqbzm/ItibTIoDjlWwi49CHI/ra/hcw
         WOUw==
X-Forwarded-Encrypted: i=1; AJvYcCVqM9bTnlFyc5IDZ/qRDhH7vyNUPoSCUwUmoqJjnyqnVpFWHSxSg9fzp+HClZqE/zBCvxVHxtojUQ==@kvack.org
X-Gm-Message-State: AOJu0YxO6qMM18oF/NhXJP0zFfbZN/tjGNpBGRGjxQtX5FJbJRzk9C5K
	jnMlcuFdGAzu2VDFGWpetCNipFmkH8Pb8++CWpRVzpniOgKwSQ0X6rP8zhSNW4VcYX304Aj7j0A
	itaMy
X-Gm-Gg: ASbGncukSEhlxoiTkx4O1RdvakLvzBYdpCx0swobduvWXzeXHKGTJcCgOWlT8b9EXUd
	Ex5VYFNTQrc2exuA+bfWcyWMmb6zK9bmCI7sQPZ1GaaAYLtMYHvqUwjps613kJqALLT89skRW+4
	2ccHVdVXbWg1uosdZHoT9GoOpLbjvqulA/x8xpdnmy3u8zwAxOwMIF73drXKuemZlCmiD6xpGoW
	s8Txc5xKMiA28q1BhIzoiaix55Ju+M4qVMtK8q7zxq4fcf4RVFhyM2A3SfkKteWKa0sMIw/GVQh
	okJCTl4B8VKWm+Bok26l/brzhxlakYy0W7A3jK33Igf1ZfUTM8EDd81NwMMv6YkwATvnjSSnNSo
	05nujx47wOFu/uSiVy3oDKRGknaZ+D1+2CyQsv2T+Mog=
X-Google-Smtp-Source: AGHT+IEC6umj6Lj/bljHcGk8ktP/FZKxktXm+XIJAAVaqHXn4oZH20sfm15h9uxx49Sr7WC6JzXzDg==
X-Received: by 2002:a17:903:3c2b:b0:234:adce:3ece with SMTP id d9443c01a7336-23f9813ab07mr115991405ad.11.1753400234285;
        Thu, 24 Jul 2025 16:37:14 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:13 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:57 -0700
Subject: [PATCH 04/11] riscv: exception handlers can be software guarded
 transfers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-4-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C971C140002
X-Stat-Signature: nx1kmtr3axe71bk15msq9i9mzi477cc8
X-HE-Tag: 1753400235-438328
X-HE-Meta: U2FsdGVkX19FSAQtm0mjpHeZayyLglTow+5gqI4MRB4ZTdleZfqfetk4HcIPd3lyU8nciF2g8sXxqPubiVFtnC36ci7T32UmdxZr0CAlgjcguWw2YxqDNz0NjwD1wc6+f69CAjPnJPAQHNtQqW2bt3mCxC2f3SY2ibSNvpCQpGQ9k7ABENG1nTjLpGn7JLd+fw6LvM4AtAoqbREhOU1WNVWe5sXvO59m8pGJ/RyKvuyFkbe5oxS/tKKZ2C7q4DUlw/ygxc0Z5UAVplxluvcME48dy2H7zAed3Ovn3ZGnwkGgiXLYN/pRu9rlgvbHSXBFgCmcq9HSElrcl+QcaT9dV0bKcmSSYiL7TXNgh03E15krP5oHHRu9Zrn+f2H9cohQCMrY1wX+B0wPzvJguiGyniBHwspEuR+ieUShub5q0s6p45Aw4f9DpIwUvAOBBCHtUXEshc7qr4AexY9Vzcq1qqxQmaxm+rcrXIibFe8alg+PHbvQfpyBuOnc0yiqq54qOEWK/jDcv7smdf7gMYVkA02YHPgXnsfz57cCdd9hCraUf6WCD/syF1RQ/ApCdehAbY3g8WihBJkgnP2Dy6uV2czdn98wh8/9NUaC+kAXqd+ueWRr8402WEfiK9zbFOH2wR+qe+nH1birxcxBSasoQlMhR9Tb09NFXvD4RZJMIMvSzgB18W9XZcj/Bqppy+owuvp5egSHhHrfE3t9ao5A/YDgQRvu2z8X/fko6e8LmkROvay8U7EwVzuRgoEdlwpnxohed1m+jxsJZ3B2MggfufOdvcCvm2jnhFa00rKaxFD9KOA3ACrU9tLBWVuff3gKSEu3csgbImbQ1QUU9g4PIAIihoAMC+Kulr+g9JPC8zg7duawxtFJk7PCMZ1ov9gj9DM/0hMym2/M6NRL2NfHv3XfjcQlbkPrrO+5VjFyAY0AGJ6a2tqr4noz8+2Q1xa/3z1Bgu9c7aohK5OQWFO
 XGpL4L96
 O+S3y16bpaJCRIy6w+us7rNSSnOX8Wc76av8rSXc0MteHOJKunV68v7Gqp5+ojX57JUVfR6W77LngZg3UNOeerq8Iqc0FRnpO2PPwiQInaoX1Hs/WZXSR2Uaxt1T8c13Ec6Mxj7u8lThUhxS+oOdWQ7GyW5O9dMlQuHdmWI66ei4wMVmQEGldA3a3J3+deP3vAJbkdhMdVXZv/tgjGmgmfx2w4+nXRUEiB6wmAhDMiQl8YC/NhOl8fkLl5ltb2yv2FGIQfGCMOIQZwebLJBwBJEOmbDWyYYdn+vRmIqAW+zIbvFWwDn2dY26GErvVn8bpuovm3fRGVtIqKuhstViNgTVNRx35TUPpYQDCdrZre9WgnQw9mkTm62LuMU/fyom05thsNYxFw6B3UgvN107fXPEsceoXGy0r+6Hn14EeXHwoeVx6dyUKmyRNiWNE6BEw9a5+FeCN4R7aIQ8dshqHKAMSRQZB1UGIbKnAwhjyypAzy7i7LsAL4AF16g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exception handlers are static and loaded from readonly memory. Control
transfers can be software guarded and not requiring lpad on target.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 598e17e800ae..3f0890b9c0b9 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -224,12 +224,12 @@ SYM_CODE_START(handle_exception)
 	add t0, t1, t0
 	/* Check if exception code lies within bounds */
 	bgeu t0, t2, 3f
-	REG_L t1, 0(t0)
-2:	jalr t1
+	REG_L t2, 0(t0)
+2:	jalr t2
 	j ret_from_exception
 3:
 
-	la t1, do_trap_unknown
+	la t2, do_trap_unknown
 	j 2b
 SYM_CODE_END(handle_exception)
 ASM_NOKPROBE(handle_exception)

-- 
2.43.0


