Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9509F606A88C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UznS1fS4
Received: by kanga.kvack.org (Postfix)
	id A72A66B05B6; Thu, 12 Nov 2026 07:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49B26B05B7; Thu, 12 Nov 2026 07:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960286B05BA; Thu, 12 Nov 2026 07:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7267B6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:09:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 998FFA0584
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:09:38 +0000 (UTC)
X-FDA: 85426347636.22.66DD025
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id BCFB380005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:09:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UznS1fS4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485376;
	b=TvWB8BgPBUpK4REl7iJdxOrMHs0jn5aS0D5RIRE4zXAWzZpX7dLH8DnnJKBkgkpsjitf+N
	ydNAMTKcGA13n2B+Lr+RYyIdL+eOfgn5XTiafc/SYhCDjMekK817npuqhh/2XPQUvL4Bgt
	mxDzl5Jj7l4xGUDNWpILUhYkJtiilmo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVXFtg5uv6jmT0ohsABv7mNA4IYkbP/bTmshktkMt3c=;
	b=AwU8z0wg6B2e6PRbbNP2G2k4F2w3o4aNrx05zxj5aOz5vl/zBLbXqTnmbCSeYChJ6THGEU
	AHSd4lQDox6h19wcI2lJ4SAdMBUyuDEAm4PTxKaSrvc3Qbhh4ZpdszkWXn0ta9Z0k2XgFz
	msezeTbE2RVgw726XMa3FMO0XOYEF9g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UznS1fS4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-49412eb1474so2532328f8f.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794485375; x=1795090175; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yVXFtg5uv6jmT0ohsABv7mNA4IYkbP/bTmshktkMt3c=;
        b=UznS1fS4ml0uZ06FYfsit5kFoyTyDY+2NMxj1uh4uSiiX18U6rA18CKvwridgWtwfQ
         NjfQNX3i0AJ8Ma2pygcYAgblup2j+0fVFBqcmpy2hLIngBDxUv5O9iPikCySNZ3lp/Px
         8l4ruTAWlC3BABo5O6dMMWo3flV9XtHT/allTFiYdHlbsoYYouzXh3N61iBtaIRaDUvM
         2I7+8ljVSLIQj8E1RLTTeJuIa+PeGR3no4RQ1dTYrn+SBHVwlWro6RfyUEBO2CLtAcQg
         nZbRMt8YbKdnAJ+yQ8QmABlQRKZXy4b3zhGRG7JqXa64oV1hE3x+J1l6KkH76LJjVCCn
         oKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794485375; x=1795090175;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVXFtg5uv6jmT0ohsABv7mNA4IYkbP/bTmshktkMt3c=;
        b=JG1UjZBhzMT98k1jyPdLtmAfzjkwpV9pnoPH5adWX16qVG9vS2Mji1JwwJ+T1kArl8
         3pDlVqfiE6nLsF/ueORhVx1PdVIflQf3vajiGXWM5dPBwM3aMREWs7p892gz3fNcutaP
         Jgka7OjSHb9gMPEVOTi4SquKWnAKVXutv0AlAX/uiEpdgT0843sp9Im/3KLhIztdwI5O
         kFXzu8sj9GxjK7EbXQ/iStaPwJGFRQDXMUeMGdHPGRODm2lRvlgSLpVXX3km82U5dZ6s
         1gNgGc5gsL/PeDvYd5lRcGWMaCgdxQf/MypOLo6bEAeYrq9bD/RK7ZzG6D0wTaA9vzJD
         dvVw==
X-Forwarded-Encrypted: i=1; AL+hErHqNV4uNLNiL2llepie5cFm8tAQEjWssDLaSlCYkeacZaTHHY2q+hPqA+BvkYrj7l6tUoSYY8Eekw==@kvack.org
X-Gm-Message-State: APuU4Z9KzlseEKcA5eaB1R7C0cEgLMLMLcAVIr/5ZH6/IIvF073nmw/l
	LsymYf6dy7VrlsPhaKDbK0S4eXQ7jxXvxaKrlgHC89YfTP+QUpxUKxeb
X-Gm-Gg: AYBFou1smqgXIvbJCAQ2hIpYPyhyAEHn8Yz9kE706KrDdqGgdqm/FXZ1dcYV++MxiFB
	XdKmre3h8g89Sswf8jpHHXg3FQ3J4oXLxm+dBrxpTvHHCRPEP2ISG9QfOEFW6l2yXkNhaqz0RI1
	8tJt0DODbipvkllGJMAtnlpXlNYI0lUza7L/lkSdcaFERRV/Qh/pInSbSb9oz26NwO9f0BfiqZF
	5o1G1TcxCVALO8aDTHrgbw/KRCJgg3NzxW2dYxSQFGqWThl3vdc3NTQbNh0XWH2CO2CwifDv2DU
	m1w1ZeD/6yFadnp0qPqSKiDVv9cy8/eGo0YtIzGcuxt86hLJmOe3uu67tvabm5gK4m8i17sEgEI
	rIEd+Ryqo3/TOyUBM1Ktv9WnmlOs04jb36o1oX8s5XDMJYj43+oMuPj0K2vR88Jgzq+cpsyIrwk
	wzp4MdbM5ycBYkjPNmsyk4AIMm+nHzLnTIBEGutvcDFxTjwTgho9Fb+dJJSOCPJGEt0ptzhE86r
	/86AtJHykbkgroxImNE8SSX4W7y12EV6N16ImdDEqrpFKDQbvutNg1LSQgCatdffouCcOdwfrJh
	VfxTIl9YFz/PV6IJdqssLI0X9O0BNCrq6Dif5JaX2smBrRRZeYIJyBafnDcN59zgvA==
X-Received: by 2002:a05:6000:288b:b0:48e:2a04:4ea3 with SMTP id ffacd0b85a97d-499c3aaa3ecmr10258629f8f.8.1794485375130;
        Thu, 12 Nov 2026 04:09:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49895f4e6ffsm15149402f8f.16.2026.11.12.04.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:09:34 -0800 (PST)
Date: Thu, 12 Nov 2026 12:09:28 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 oleg@redhat.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
 ihor.solodrai@linux.dev, bjorn@kernel.org, pulehui@huawei.com,
 puranjay@kernel.org, broonie@kernel.org, dave@stgolabs.net,
 jszhang@kernel.org, tglx@kernel.org, conor.dooley@microchip.com,
 thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
 rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com,
 debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
 menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
 wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com,
 arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v10 5/9] riscv: implement preemptible this_cpu
 add_return operations
Message-ID: <20261112120928.24145d44@pumpkin>
In-Reply-To: <20261112104149.38589-6-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
	<20261112104149.38589-6-cuiyunhui@bytedance.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BCFB380005
X-Rspamd-Server: rspam12
X-Stat-Signature: cwopgmwoxr8r7yqqzx3npr1wkhkukhdr
X-Rspam-User:
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794485376-269787
X-HE-Meta: U2FsdGVkX1822Z4WRCNp04zd4RKAhY6GnujYMSE2uF2iuebMTqdFnM/fhiKrk5WI0HgKZ4nZiU2Vyw/2EwiS1EgrSzjWzmY5bys6Tkklf/7s7WpjdTlh9L8AaaIAgoZLEk1dpViWTRzAR3SsDVXcxXBmwq6iVCJO4llcm4iYQ9/0/r9VSHjvgkmgKf62En+i+lBGEq/F3xHOlk2kbdekio34R6CQ+u1RQwSDy1Q76hxip25aodr6kh0+W8TpuSSbAnq7XZVPwn3ecN8oxo8B1PzXHizP81dyJg/Byer+2xrQTubUQzDLu6IfLHRj/g0TWcUAB0Q1nFa7Kt5JKA78ddeywrZUpVENEKVTXYkB06fLuoj/Ou9h1XOso2xazCcIsx8yfzRXAcAq8u+FEMtyC7Yr00jKgIwVvfV5SXiHN7rDyz8TKGMC3p4rSh8aepkSaSo1er9N4qNNnouXoD7xB24OMPVXsZdFCd9fei9gAaqgp8hpu9j0601g0Q6jRTPKrDPLR0Ww2Egb0hIRRWjRqbcszBDJQA46plSl1MCxAY7+1jHEDICQaZtxgc2mu9C57fOIwfM8iAAFoBd7ZY4GeltDW1x0fmZSdjK/LAJHOhwzNSLAIuEOzhAbbibArMug2YyUin8pPXSYQk3hMdbmZOdSkykLiLTG70ipqjSCcyENBfZ17TFW+mEBkQDsqBgd08auTLk4X1U6d/FgXOSzQNtUHAVrB52R+4BeexlihKEUzXs8q4DiLmC/XuAk1WPiIczCkqS0+t0CAPQneW+IFfDJQYL1sZQrVf+VNXBMaPaSg28b3542qMEI4jXhFikuMHzOtDnyq1zy4vRuLuDR1CTWQPe7ZZcrMLSfPltD0I9pcTC1oYd0RAxjmVe5RK6uhc4d97JM0o1znUL6Pk6ISczRwTB98vorIJri35SGbgjDZqdlmcsu//BiaKOtXqVTnX6zb+ZfiiQjah+6XGb
 SEDwzt2N
 YmCPwb+570CI8N/5f19/2wjOLbERvlf+5YzNdVtbtjqEYu8QnxuMokYZ9+4Bc3XdXJBKxxby2b04F4sucpwWFdZhClPgxGFj6lItP7rPXk/k+DMqo2fSGvU0NeNTovvRg9s5W6/bZuQXKyTV5ek8dk/SBEvN3ElqIo2vu4ZRA78fErrwsjgcxo8rBLGikRPLyX7kojXjh7BwGWrXEUU0LmfYTkePDPb2DZWGW/4KrPBseS0bVyalIhiXymqUtQ0z9kJAGNf2XtYec1TGoxdm+z7HNJcT3nvN1n4jra9OczIqD/MPJB2grEynAavULnZxJNojCUX44Bk4G4btMQcxbLoQuNlisxs9rss71C9k/uwiw6E/YzmCWZ8aGCJd7EvGqPS+dLQZpYsasY/3m7E/8jvP5criQkJzYgvNJAtQSp2gEh+JsUIWLQ3JO9rPSLJ1mZpe2o9YicpdApaG+a/XR5RC5gG6MTN6V4rxm1CH8Dm0C5vGEfmNhZ/rOsInT90SXBEj18D9pW7evv0twRd4H8RfttQsN/dP3fl1yLtb+vQgv2odT2XahYMIyYJRn0xMYrXWTXG+H/WPWovz9p/TkZQzey64ahe2DBsa9xZY4etmbRwEMGAC2u3v6hVSZBFOQheth1ZD62vLowITqUplo7PS+VT38VZyxi6nmg+HFnU3sChSvW9RPinlrKVjmpF8pxygpl4USc2crVpJsOOlttFj9TSYCFVr1xGdD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:41:45 +0800
Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> Apply the recoverable per-CPU address handling to add-return operations.
> 
> Native-width AMOs return the old value, so derive the new value required
> by the percpu API from the operand. Use Zabha for subword operations when
> available, or a masked LR/SC sequence that returns the updated field.

I can't help feeling that some of this code is the same as that for
normal atomic accesses.
Can they me merged?

David

