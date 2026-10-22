Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B46606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=sshaKQJu
Received: by kanga.kvack.org (Postfix)
	id E1D046B085B; Wed, 21 Oct 2026 22:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3E36B085C; Wed, 21 Oct 2026 22:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C9A6B085D; Wed, 21 Oct 2026 22:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6A3A6B085B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:57:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B75F1406B1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:57:33 +0000 (UTC)
X-FDA: 85348751586.14.68216B2
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 400051C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:57:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sshaKQJu;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbCDllRU5wYbKPFOhnGrl1xB/avA24qTnso9VdtaQCs=;
	b=12EqtoM2iyHsBktRcJvsoudPPtVIjlDrZkctCB4ZU/MiK3NcDcdAzIg83RbWP4BnVkTBvC
	W9Er+JTMDYLY6KJfPVgN4Ct3Xor4tbdExEx/vYBluj0FgsQfpN1L9Ttwlnfu42UxKtXBlR
	Zq7BzrKMKIBSSeVnZ+Ces8ktqftRjMI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sshaKQJu;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637851;
	b=kyFWWIJ+Xrxnfi5WiNrqbi4hZtpW3mr8+b+aZKNyThCxjgWQULUa4eBFPIzVCgdMUzz06g
	5zMLwaRz6M2J+URAjiHQm2BdKEarngv3D1w9v0hp9c3nPIfpEG7Ut6hdCT7Uz8WbeSAvld
	DW0KinFjygGk2TyyB9iVoD8YZZMkLpQ=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f1cf92c9eso140981085a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792637850; x=1793242650; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jbCDllRU5wYbKPFOhnGrl1xB/avA24qTnso9VdtaQCs=;
        b=sshaKQJumPFSaXbMXhetmuU6KIhKEOV2zMmOdRW4NVRjA5YJ7Y8rwbLoKYJkUaNQYO
         2yXDJ7x+6bPxEaURbAdPON0INy9/S+jqC3DMi2nHsNLbyr/IWpHSgaanarQZYKEboWxn
         Efj3RjAf+XECpdSqgeDSOpGmGKYv1rwBcGK5npDsyGlKbqV8CxWHIBR892xnZwjR4v7B
         1LlorXT9Li3D11OgawFkfFnJIZz0dvIX36Vsxw7AVoN3kP3ZIcuql3fwNhW1CY5iBw90
         8fjVZf4Hpgi5+I2g4b+qQX8zbjEo1Kx7a+Xuh8CjTUQj8inWKbkFQE50eH+JRxSCCqA1
         hihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637850; x=1793242650;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jbCDllRU5wYbKPFOhnGrl1xB/avA24qTnso9VdtaQCs=;
        b=0JGR/+bEM4m/qbp0BHrgzqPbftA2nhE5VoeIaHKu9x3p78z/9LUJEz9FTfP/CaTqNQ
         zsERNUKuzPUQnThlBPiBKsLUylLKQWVsfT2PRm59BV7O8V8deE/On58Zpu4k2Z0s8Uwr
         tQoHnBEPaRCsYIc43kAa371VyQafGq81IqoCnifkW4P0IN71oiRxpW1OB+Xdra8bq/a8
         PjNgEU7381TZiYAKxe++cvmeRa7Rgzyke0GDZvgjDnNzmq4iedtPLkYgJ/btG4dpwFps
         /1LOVz2H9TtOzbLMMxUH7+W4IH04dQAmPr3QBfvKI0tUN+n2WtBw0634lpxEYWIhnPRR
         FMDA==
X-Forwarded-Encrypted: i=1; AKwUvBxgg2yCV8sFQsIrhX8f8Mk+FpFi52fxLOHxxk5FNG3veGWJ+X3z7uBKfCkgsMIXRtXhY92bbJOHCw==@kvack.org
X-Gm-Message-State: AFq9FYKwMZ87na9649XXWhNKhmyq9M0u7OiEG72RUcX5Y6YHHvxwENzt
	Kdic9OOME1iI7U4kFW5bm91+1S7brGrtChBm43GnCfeIGfjbWMcc9QIbnWDKRifZco0=
X-Gm-Gg: AYBFou3jXsoxJIwvnoz/z8LX5A38sSVifDFUt2CbTbj8bZjnfOBAbWLytxbxp09jBsg
	wyTEe2f9ENjOFDXxn0BEnLQzZBg/PlOcgFVZAAi8taDZPYvnwxlFGQ7n1uOfnC6kR42UNqOiRPw
	gr1jt3wDiFcDTr5aYHGwWqJs+lQCKJw3cpsvFurNNS9L8LwN1lAF4R5jqaJLcB410QKqlNmfYon
	f9hf8QE8HQtJLD5mSsIKb0ny6GghHy02X1mmvR874mviDNrQMO2eMeoZqKmtuqhm6vtpOEgDpPX
	2ltnYQkuku32w7KtUIaKwClkWR5WQwujrlTcvPXUbeQEaISCCbBk59HLMFRPdyS9Ww3ekKh5HF1
	f/OLHKsMfFm+QCNsBzj8MkaZSqy9JUtY/V1d+dr/EE1wGMwj9z09uOAVmK1uagbHgDdiQ7RCTXk
	cnHHYI3a3JB+XJsiFg78CcB07hMaa5i5BUFLnk8OXyu6nDdkpM5bbobCdRY4UerXOvZPzeMU3vq
	sSUewbly4ds8iet+natx+EjbLWolosDJruM7t7NqBiqr0vJ6cUAabk4IcGV8klhRuabW5BwJtxF
	jSbBUXvybF6ZAg8NmTrQbyjunc8=
X-Received: by 2002:a05:620a:2415:10b0:93f:5cc0:5978 with SMTP id af79cd13be357-93f5cc05b2cmr353949485a.37.1792637850409;
        Wed, 21 Oct 2026 19:57:30 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e30610sm406637385a.43.2026.10.21.19.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:57:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH bpf-next 3/9] uprobes/x86: Finish an unoptimization
 which failed half-way
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, 
 mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, 
 liam@infradead.org, ljs@kernel.org, surenb@google.com, david@kernel.org, 
 vbabka@kernel.org, jannh@google.com, hughd@google.com, kees@kernel.org, 
 mingo@redhat.com, tglx@kernel.org, x86@kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261022015712.1297331-4-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-4-alexei.starovoitov@gmail.com>
Date: Wed, 21 Oct 2026 22:57:26 -0400
Message-Id: <179263784614.2549665.557126403507804820.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 400051C0003
X-Stat-Signature: 5zdshfppdjzy8mxj63bj1bkktw8ffifk
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792637851-697938
X-HE-Meta: U2FsdGVkX18J7GmeC2YM5mtiBu/RlZch+6i30aUhFw1AN/7elrr3nfUFacy7AQ/kiA9/BluV5ZdSKgO2OoGMdpvQEuI8Sgvzt83/RZVCeJFYO5FSc8FlddiouaO2YYkMMH21zw49XjTeV13AyGKwjxMj145HBf1NVheFzboAnZ5EoiWKoyeBdRXmZXyQVyvOIBFs5g/ws0Se/hSZETKTqmbMxqM25wOBFhrroV2FoA2o1GcUnK45BnAL8q2CeCCdgkQNtSbCEA84XgP2MZVYt7qD201WriwOtvyYn8CbfVSiChu54NvtAVYC0q5yEzx0i26NcC4xppMAIO4fy9hcIvef7VC3eZ78oWMZy++4oTDlmmE1yaM3QV42zxbHP+3lldIjT1VGm0W8qCfWSjNyMGR3GxXB9vmjefIUhkO9Ya535v4A2IO7sPAPLRbIJwgGQSBqcVePTdJlhTkgcmH3i4uhyxouyGPZrp+W8aA7UL/PFDl2FJuXNSAEKN/nBQ3Sso2OlABDmB0+7xvAjJK7yaF8ioPKJIEZTEkgBjsOmVngYbYfp9vTz0kR3cwmHPv3pwwzgCe9T6m6BH+eyD9cmz0a/wenv5BS+8Vtn+8mNItFASRZITCLs4MvMSE31TmqY2cEIlys0QxYLwuU6Zduda4Om3OLc/mlN1m1ltfRvAfxd/tBn5jpz+NQXVFySyYO4xuC/uQUAilT9YLTOld0P9Vb95v3zuyI8wuWmYJRrS8bax3zmT8R33YpHXfAaj6aGi3IB4EYH03vSlE4C9YZMxtIxhsa0WVBqM3QJ0ZRvJaBSOFiGSmylfmVMt8V0/+KwsaZdS9BhW/NZrKWu+KU2L7fIHN16pEfLK5B2nHE1CB0GIfQtXn7tIhpphNQ3oTaFAbTgWf/Sz8mP+9ixDycr+zU35/+yCZp2zYb4xwvd1725bjdFMmhXS3miBROnVk1ZzgVGjyk+WPswkwecNI
 2847jRMw
 GpklHYht1w1A5fS+dIK5nHB7gwMysYmtWhe1gyybJhLNXQ0tTB6/J7WQlAOTnf/RYr25s4OKLweZi49NlEv+4QWgmi7eyWDA6nssfbeYkMM/yAa6JDvFGxl/wUyM6AcyqX5aLz99Tq1OUkwpX8Fw5OBqtyp+W1tlhE7n6u6C8UHt14+34uljpKc9N7/87z0NVZdIK/qyC1GasGRCHpQA3mBOshJnl0vWUQYMIt1Xoc2+a/H54G+0jSqbgb5OjQRxXnNUTHyC+4ESRABqwWF6qd2/kZCcxWzYKVb3d1nCVP0eWpD0FC5uL2Ao12dr9rIdKg0c7dVLAW3v7g27VA83LjytbRU7zEcW+hJWEMcYZL8Da/3uVMOdx6HOO0T1z09lfCeh7v4uKfOokQO7m48uOWOwakyyeGVOUWxur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 01:57 +0000, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> int3_update_unoptimize() restores optimized nop10 in three writes:
> 
>   48 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%rsp; call tramp
>   cc 8d 64 24 80 e8 d0 d1 d2 d3    1. trap new entries
>   cc 2e 0f 1f 84 e8 d0 d1 d2 d3    2. restore bytes 1..4
>   66 2e 0f 1f 84 e8 d0 d1 d2 d3    3. restore byte 0
> 
> uprobe_write() can fail with -ENOMEM, or with -EINTR when the task is being
> killed. When the 2nd write fails the result of the 1st one stays. Byte 0 is
> a breakpoint and it works. But the next set_orig_insn() doesn't find lea in
> byte 0, takes it for a plain breakpoint and restores one byte:
> 
>   66 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%sp; call tramp
> 
> Nothing recognizes these bytes anymore. The process keeps the call into
> uprobe trampoline, which can be unmapped already.
> 
> Teach is_optimized() to recognize the half-way state, and let the 1st write
> of int3_update_unoptimize() skip what is already done.
> 
> The failure wasn't reproduced, but the state can be made by hand. Attach to
> nop10, call it to get it optimized, write 0xcc over byte 0, detach.
> 
> "uprobes: Don't sleep on mmap_lock under dup_mmap_sem" needs this. There
> fork() removes the breakpoint from its mm. When fork() is killed in
> the middle register_for_each_vma() removes it for the second time.
> 
> Fixes: 554ba38456da ("uprobes/x86: Move optimized uprobe from nop5 to nop10")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

This was a nice read.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

