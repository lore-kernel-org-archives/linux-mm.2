Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE30C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5B56B0093; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102EB6B0095; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49676B0096; Tue, 14 Jul 2026 20:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD476B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:28:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25E7640559
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:59 +0000 (UTC)
X-FDA: 84989125998.18.2360F70
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5124240006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J18+ptKY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075337;
	b=KdUnEOHVWmdHLOG+IRXDFK0r68JyFPy/F5ii3untQIGrx2Lth6MkvMeFIhYuUAsIj3Bpz5
	4evjZoSZk9FRXvUCx+Ht/9gFfu6LHF22Kdf+haRDDLQVP/UXT6OFAlgbq15dnSffsPkKrb
	og4XPv1WwG2jxpYEY9tRzFfNP6s6fSA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J18+ptKY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6EUyZKF6G67Gt1NStk+455yKefIcrRIfkjtGEXNiGs=;
	b=xTxX5t0uUJtGpAejScJx3G6xgsCGOEfE+zyTcJXSjwyD7USWkqb+ERQYj80YKgKKt+b513
	XnwRHLlLCpnZr68MzJxcVol3gGchJzm65e+NV7lSN0/GW5hdaPDBoYPMuuMxzOsJZWl3vX
	K5+tTaXD1dtr51eTL0KqXm8aJbhbisM=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e041ea211so2223466a91.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784075336; x=1784680136; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q6EUyZKF6G67Gt1NStk+455yKefIcrRIfkjtGEXNiGs=;
        b=J18+ptKYUR+eXnucLU0X8iYveawWJU036LV+hEeXbXXcJIztnhvIejqcxEf/Rx2SJ8
         qGMt1u1o5+g/Y7YV+XoWB8mdoJf902T2GODC2CoXcMxKmaPL5K/UIRwx3YXKFjRDJ4qD
         Ev2Nya9iSDExI4WH/bm3XvZzQnQw4ipRGJuVsj/phJjwZt65zF3ZmnWqN6WrVfbY3koS
         zCr9dGC8BYfQa5cHIchswiyN3qY26q/LBSqExjMqof9tQq5YuQq7W9ksNcX7XE9bxpqC
         Zz9FtjABZWDWsMsL1/wd0ZbHBzeE1fGgy4VO43jP28rBqzhQ9JYFk2EXubfusjz+fM+x
         Uk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075336; x=1784680136;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6EUyZKF6G67Gt1NStk+455yKefIcrRIfkjtGEXNiGs=;
        b=CyaS+C61ZodGAjwro6skUEQcKZ7WPdk7C05OJw8ge8/peExKi0OVo93Fvqc6Wgrqoj
         F0Lg+vBbxohF7L9gkRrSR5zEQoko2sigriICx95zW075d+slkgUa8PSb+XuDpW64ual0
         Iq+uPP55HDG/b2+fIz+AKx4ezzhJZnWPgsNz80FfwT7tZbbvcPite6alAYVbQw527onm
         eVXeWWlQqelbkKqQLcViCO6Lr5LKdAT0twUldBdQdXn7IgdNR8xZgUCsIJkdOkxAuRKX
         4iwgQf7txQm8y/+HZt1ZE2KrLKqdpJEWhabO/1wVFEuerpJOFHSg7MnECTDoJnXR2SnR
         6hrw==
X-Forwarded-Encrypted: i=1; AHgh+RokgOKhDgqdakuPsK6BQU1LZqUCo/6RqRFl+zsNUqxY3BLH5Ij/CCBh8shZOYp+9pYf3aI0c0QnWg==@kvack.org
X-Gm-Message-State: AOJu0YxCNB2unkTfM7IoYpUi7X0m2VDxX7NeXgjWocdB59IG73r2EOU8
	+fZ6I524Y+0q7EUP/7I2j3l0h+iWro0PMWq3iEWAOjNCa7PgZbROpRvH
X-Gm-Gg: AfdE7clLW8K0GhAYq+LZj1T+PiIIhR7t8o4r/IhRmefJ/UzjwtqjAjqnpSpwuCF2WS5
	SB7XrMxAi6VG5W1sFxZxW340CLnUNWpPwLa7VkLPs37W6GPEGqRkoxZo5OiA2pCN1OGwcKkCn/t
	fmsQDcI3nfHVVOUPY3tKpxRcIAI6yZS6CIuUdBFUWmhiEf3QTw8Lo5lUnkyBnOohP1PNd+zkIua
	0QkjSEPeCBnwsTtgKBTUIIXVSfSMEmja1ZVZ40zngGIyw8+lFyRhLJkvkYvZRLF1yOOfrA6ASey
	JZQdJviSb+Wuvy/AnK52rG0eDHIJ8GdVKLx/TOSANgJF7Sf3Itw7Ahu6pep9qT5JTSFI1463+v2
	yoNZGikP/Gqz8clp+QFCLphZTFN12hYt9pR79k8IbSBJmAh5ux11d5/MeA2sfZns9wb88SLV2AP
	w5LBm5hwtpfFXLEvyh
X-Received: by 2002:a17:90b:2544:b0:37f:9ce1:736b with SMTP id 98e67ed59e1d1-38e1af37168mr4216164a91.33.1784075336213;
        Tue, 14 Jul 2026 17:28:56 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm86075098eec.18.2026.07.14.17.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 17:28:55 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 4/9] binfmt_misc: wire up bpf-backed 'B' entries
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-4-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <20260714-work-bpf-binfmt_misc-v2-4-57b7529c002c@kernel.org>
Date: Tue, 14 Jul 2026 17:28:38 -0700
Message-Id: <178407531871.2243172.18093804936760543620.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 5124240006
X-Rspam-User: 
X-Stat-Signature: 94c74bpeuk86y55tr47hoeipygztzox9
X-Rspamd-Server: rspam03
X-HE-Tag: 1784075337-368759
X-HE-Meta: U2FsdGVkX18r6uChJK3Dc44cD93TRW7md3FcVeNSNIBDkmGBbVXP1sykcTNk+pTzKpqvsau9pMaEI+1UnrMDDIaj9bPCOR/3Fh7KDgpiY+SdagmMLnbFlQRLeoOC4gugXz87rUKDWXPKW8J4cSuc3aq/eWkbvxInISBiyk381CooFJVYbLc37lzCc4AhwUPaf+pk1yj0vjSeqN+oiQEp+C9seyX3XvBIKmk2IUzjZLjsdzDoVdre3b4U9o4OcIdez0ySQV4R2r0V7BPhyNBMiUXp11PPAqy8u68tfyjqMPiOJi94HhMMCvCd2QEK5SAdL4mHlbjban3D71H12IsxtvyCRYml2KPIsRZZg7+bTVQ3CIuGEmznhz3cR3+/Nc8AV19G3oaTp72rj9yP/AY1s+LsOVn5XQA0sV1qmAqlan2iHg9Vpbi1VNjBfbc4KJoNerX1Q5hy+4AYusV25uh4uqTd3Kc6omAdPJdvchzW1NjG20C3OWJwKcUY/5Ea+zqiZc5Hx3AsXJtHuyoPc9F3GV+zxdC040w2Db+0a5Bu0bmhpG2q85jriBd8RJ0wg+gypwqm+wVOKqPzWUCANH1iKsGtlQrQJyw1+EW7lgDbG/liIqLl+tgktJ2SS4FEvHsH64mZiL+UIjXmA5VswSLZE4uwN28DqrZuLJggwF6TmVphwEFZS22hin+WKxmV3hSSN/9MFNS4eWui97M7r8sGsi3ETXZfn/EfifxJ8ASmACcu2XS92d7/yJRRa8cMlDEMxbCbG7KFt3FXIdzHMS1BfZuo06/IBX2FmxrnQ7hRKZ+flGc93KFbPXs6BERn2tOvM2HnwdUEbs8C2gWo3697rJZNB1PIaND4SgN1r1KZmTmNPdxGrslPCfN1yvrJzkKsMCsA+zn+4VKJL5DS9lS2fvBnOo8cB2xh/5hM6xOY2p0wRBXXNtQTPxJiT4mWv1Uy/+dv17pBnI5h41naNjH
 xHwW46fM
 pn3kQOT48l5fWRHlKaUZNNfovfQadOQAzjl75zo8PB+Y4HuuzE7c82rVZs64o8FbM0cKKb0o7dyMQwSBWK3CaypDIpx/BNY2tXz8LmX2yyxGVMMYl/+AhxCm0ze8/hlBmgBvNZxYQ/lsXiZlbb6OMudjJPW6+lP+UsV2cT02JnQdIzlgAuW7Vqu5JaRB4MFmI0RcIMN/BF5O0DkgyG7KOctrV74z2pBLf/myrK3jnWY0K4on9vV5JwvaPlRIcmXcmcdbneGM0kKRFH6ND2z1tqnWzDo5CIrhDiPgoEJHIPQxfst4C4HMiNyHYu/Dmb8zMldsv5LVv+qY9oXR/iYbMYRSy06N+H8sAITDQSz/wIskyTVH5af6jnDOpEnQuuedRnc0NsKL/up9bydslWsNI6sS64hRXCUeb5mHRTsMqWBJGagPEyRxxMlsmepimkA+Y9JoBwVLImhzbVIoouWFKn2PrXTLJ4LkKteXMfxu0prciCt0OcP/gAuxXyWH36TFlq7wdNmtRP6Ffk3wWYvyIM+CnDxxtxHRQJWtzypvCKOURpZcCfysXlsF0L/ykYmGSVpq6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:58:09 +0200, Christian Brauner <brauner@kernel.org> wrote:
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index f7264b136..a8f641c4e 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -226,12 +240,51 @@ static struct binfmt_misc *current_binfmt_misc(void)
> [ ... skip 34 lines ... ]
> +	/* Selecting an interpreter is part of the contract. */
> +	if (!bprm->bpf_interp)
> +		return ERR_PTR(-ENOEXEC);
> +
> +	return bprm->bpf_interp;
> +}

The "contract" says that if the BPF program returns 0, it must take
ownership of selecting the interpreter. However the bpf_interp can be
NULL here and therefore is indistinguishable from the refuse to handle
case.

We might want to treat 0-without-interp as a hard -ENOEXEC-to-caller.

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

