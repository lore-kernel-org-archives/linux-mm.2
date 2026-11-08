Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A497606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 21:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mZ1n+6gT
Received: by kanga.kvack.org (Postfix)
	id 872566B05B0; Sun,  8 Nov 2026 16:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B7B6B05B1; Sun,  8 Nov 2026 16:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C4F6B05B2; Sun,  8 Nov 2026 16:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9CB6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:33:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDF3C40508
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:32:59 +0000 (UTC)
X-FDA: 85413252078.04.464C632
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0C8E2C0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:32:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mZ1n+6gT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794173578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zV+j1o90j03z3/bSKQRAMr2OAwRnzRNXDWN23pKxKc=;
	b=Zi3wx6iXnUi99OlrpF0ooqdNZk/mgDybJrOdlQBCfozBiM7qEla0i9o995ibFPt29AfmxO
	mQjsGacfnUtAom3rst7QqCrvLPc1dO6/M0aIc9BILy5MG2uB8+d1bN2whDu4NZSQWx+JWD
	tFm2PyACXb3bey3wHUc3ROAMN2f0NUA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mZ1n+6gT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794173578;
	b=6witsl30TwmIJ/tlZWeVHxHB1ezVEk2zGABsztGClDGkr2fpx4Z9sQpD1Pi+nB9E1Zk/U8
	S7Ps1RSO7ogwMQz3mwjPRhhUu3QjPVmR+LuO1VHDVRlwfH3i/DTT2llqLdmHv45M4iKsOG
	xeyt2t91RJJbgvuvIMxejMPf4nYwqBQ=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-490d59c3edaso182169f8f.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 13:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794173576; x=1794778376; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2zV+j1o90j03z3/bSKQRAMr2OAwRnzRNXDWN23pKxKc=;
        b=mZ1n+6gTzfDcSGVSuoNPKJhS4aizaKrDNGbVkyvll9AS75zhNlwFnCJs4WszudLHsP
         TfBfUIqqN9nsMOpC8nDUHXdIDRU01G5cp8NT12Z1Y3cwGL+s/SGKjI0dNntqqnUryKnf
         P7mSRVlvuPwNfL1Enyu7w2/TyXLETVgcyNYXzLjrfz3DRmce6hjduCotQTtdsOSDio+4
         Sqlv6G+TMJY/0J1IqBN4IpqRpct3QN4ilT/1JtkQck/IJvA8tpzHHahe/ulB+0LqZDcS
         JAhxX3tTyFfxErizOZdAUwgfyPU1kB39nQqQStkFVuyq1bsu/j6QQ4uoezv4tQeq+lRp
         lKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794173576; x=1794778376;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2zV+j1o90j03z3/bSKQRAMr2OAwRnzRNXDWN23pKxKc=;
        b=bLNR26BJTZyXhckoF9ssEY9oe+6Ph6MFLOArQCcpf9S9yONQwoA7bgjeKcHzuQp+w7
         CXjFzmhFm9JovP7XV7u6gogi+JXXecdpAYMX29rj/IQvUcVNgcq+gIL6bOcDvvu5YUQy
         QwNfX9XyG5mrrbC37k9+nrQHUruAA1m+8YKZ5FH5YEqdYKmERxh12o3k9vKJ7R0u0sH5
         i78Oc/Fk9BugIOymSaSkembtQ8aEjPftHfCfJQdXot956MY/l/8k+QoayBV9sAZGUhjU
         SkB8hHQ1wu1bpnYvwUZYbMNr/bZ24ma/Re18MCYBBjOYsRlf++KazwhHHY/bGBsjJyGE
         J0Hw==
X-Forwarded-Encrypted: i=1; AL+hErGeTvfWZjzAhuNzVHKQ3gntX0jDDLcCx6M+OYo1hBpEOilR/YJypUaY4a8XMVUEFWHlWJqRP4bIvA==@kvack.org
X-Gm-Message-State: APuU4Z8H+7+ctayntMU5ltJIhjid+0dxWdLB7vfLWBZlTqKLnK90/TAq
	ZLDKtkfeOKr7L/AT5F/nrtRxRSFrZUPYBtScqdA0pdm26jIZsEp627uM
X-Gm-Gg: AYBFou3YIxykdSZBk4l2FRZMpdpZv87RtEEkzdx/oiKykCKzSiB/fPTWgNfCdP5ut1j
	vuPg4eJrNmBN0qxSSRaoSwnwi9Ngk1hlG6hzRB9atCS3rN1R45j2XaIDJvduGjAWic1hWYjXcx4
	B8hAZmosze/VzApV1XCUliF7HIE2Ap57FiDrL7TjIXFNKiqyon0FyelwqDFDD/6GACD1bumq7fF
	Rr73r5VnRVsqBoZGg9EX7sPzpiagETKaa7RV5LfbCJ9fCNlMnezt7xMiChl/tOi/wxRPZiUQ19X
	O/mRueoLi/TZDUpMdviFtCOkm6Utr22hhH5U8FbUtpPZqrn/Czbg26SoS3/YGG4jBPu5VtBxxOc
	SsdZW908qY0yq4iI0vaVRWr6Er+okZb7syJ8IRcPEb6GP/UBixIG946QXRFKPJ7U2Hy0eLllWpl
	FZkj2yq0CsDyA68R8tgd45FUvUHqxQq+pkox1DUyK7zV0Dqnc+IKKeq4zPLfsnsx+t0jkC+3rQp
	BJqmj+Ad6t0c+6QPwUcg6E6ouH7gLCGRZtWRe5lMHgtASBV5MLk08yAnEHaJ9RTnPqER271l7gj
	mhRxjpAIEeXHQjP4eUE3+lOuSsDoN3bU+pGkNuN8jAUc6so0+LT0xshpnzhlWZ7/
X-Received: by 2002:a05:6000:26c8:b0:48f:bbb5:61c2 with SMTP id ffacd0b85a97d-4958852d3b8mr5479500f8f.4.1794173576292;
        Sun, 08 Nov 2026 13:32:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597371cc4sm5861840f8f.36.2026.11.08.13.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 13:32:56 -0800 (PST)
Date: Sun, 8 Nov 2026 21:32:54 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org,
 pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com,
 ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
 rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com,
 conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com,
 seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com,
 cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com,
 apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn,
 linux-arch@vger.kernel.org, llvm@lists.linux.dev, dave@stgolabs.net,
 emil@etsalapatis.com, ihor.solodrai@linux.dev, broonie@kernel.org
Subject: Re: [PATCH v9 1/3] riscv: implement this_cpu operations
Message-ID: <20261108213254.67805ef0@pumpkin>
In-Reply-To: <20261108110406.97495-2-cuiyunhui@bytedance.com>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
	<20261108110406.97495-2-cuiyunhui@bytedance.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C8E2C0003
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: be8t7sxmgtsmnj74y81i75j7c4t5ipo1
X-HE-Tag: 1794173577-47380
X-HE-Meta: U2FsdGVkX19iKeLMG4aFDbZ/WCpd+Gtq2Vj3ODAjjw5Vu5w96/AJ5GYqfGJTOcWRtKQ+oJS34w1NtUPZYfLU1P8/xC1TRD6QvRK4nTQOHpKLK8MMtJ4/6WsHY4VC2YE7FHBpHtvboOZeW6k415NfCVQT5CAgmwqYHQ3r/okqiQiaplQMTWtiUprlLCmPnNN0fbZzlfrolP+dkCFg6z5TMZJ3vP6gzTfNKXGH73LFvHctp3r2/80iRYUY+pMNUCEJv/br245j3eKIOVcqm7sNzKbvJq097YwsSPy72QDHMxug/aoAC0yIiA9BsLAk4Thb0zPDYGs2VNyD8P9tmNlwJRo6Xm/vR9iZWvUPq+cxcDZz71AQcmqugNKLa35TKt2oPzQ6tB4z8K59MdH6TVcSRa5gWE3bLjrAzypqzwkPqot4nWXWm9E/dpt82EGSA/piu2ezIXqenWkE4ZRFGdlGPBGM3kGV/V8GteoXyxXP2/4bREMNk6OCsq3/ULcM6pWVkFwmZwMlAmmsGLRfwQd0tQJSfaEt+S41fIFg13dRMbWtMnlYR4J/NMGWr2+Y06SP7g7aSpdlB11lKh8Bw1qTAdeZREFA/CzzXzu/hGndNBzkQLtpaSzGLSnv3I0BcVtJwY4f0GcFnYcsyL4dHqKK7Qixt1EKsrQIlmWMVfABKMPjxGOpgTGT4+VZgZ382H1datgF1EZJ3lH4jFhQNg/aUhZ60kBgYQl3X/ZCdPHUfy2nOjMnQnu99Xk/dPxS0gW9NHVie4UEKti7UgwYDUEBtV81p0e0VuN3V3sAGKZ1UlsLofA8mXkw8oEhxlFev3CQnwae4rfLN7zZYOt/iqCH9BDqkWNAFLgvcqXw39+jaknyF6xIv2KiKe1zF28+puvjIref5SBufyeXQRb0ma88j7ZvYo4zaE/9zAr8DuAR2s4tTFPHkHCtkkEfFRX6iygh0npmu2tdOfTre3P/53i
 DlLQxb5h
 2NZPQP4T9CT1AAH7JaSSFu43mtbfIBAWOcZ5Ol7AtRMjhYz42DSoJlxwqtZwgtmszWL+Luqwm1gFRCTDa4WOzXvVjCs/b+qwkkLwYAXGiA/V8mBeWAfhiA3quQNDV4R3DU56CBkXq3ik6s5Iva6wb+lJ+UrgsjCUuZuBNML5P8QDw0WUXnuPQx+iNEJ5G1Reqn532MObT5/MfJ/sntEqOSOC1QQ1nGzF5H+BI3WsjBK4oquvxN0HeEZ/GlLzBW8wJcVOc/xiPwk76FBC05xAliEUZPEse4HUOlfxkn3L2FVYHagtfN5beb9tb6iKqMAzfpQnh8MMjGTtjvxIhnvN5OOAk+1u9M6uHqVEeRHBT7qMklGH2jGIVFCWz6GBGWgSBQpcrTv1MOcWXtM1YsMS+YWWzM5iyA+oElMnZ/k8wySW8T/G9sEujfQMHpqFVE9fkfC80r4Li7ydzwATyKk3iVVmtQX4CnBRsap3t0ZdwAH5+8MLy1B2pTT8tvYzTiCrWm3fGe/IMkd05MSgezFjJFDXezFQZJeNZYnivQlSjiZ7CzZlR+CxI/8Yrqh6819ZQ2zTCDxLu1+S5C/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  8 Nov 2026 19:04:04 +0800
Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> operations use generic implementations that disable local interrupts.
> 
> Implement RISC-V-specific this_cpu operations with preemption disabled
> to keep accesses on the current CPU. 

Have you looked at some of the schemes (I think arm64 has the latest,
but also s390) that do most per-cpu ops without disabling preemption.
In particular they save the pre-emption check when pre-emption
is enabled.

Basically the code tells the scheduler which register contains the
per-cpu data so that it can be 'magically' flipped during a context
switch.

David

