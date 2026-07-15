Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751B4C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3275C6B008C; Tue, 14 Jul 2026 20:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8706B0092; Tue, 14 Jul 2026 20:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A20B6B0093; Tue, 14 Jul 2026 20:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDF0F6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:28:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52C98A062C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:57 +0000 (UTC)
X-FDA: 84989125914.13.EE62970
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 849AA100005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv3iHSFF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OXWiiZduWaFVZYnMUD3uONDkiNnSk/wggZx+AlWUVw=;
	b=K0qt0saP453bwjPV/FcYRqVbB6qrOvBRsz2f3Llt5pC7ZfCdIkdsnQu3OObSWt0kjfueq/
	NyVzzrb3zwzK1BqEt8M1E7dPTqt4Xb4vZ/DvNrXJjtlahDotFnkB60JFRMPz5J702uCBOe
	Fn8jbDea6TNSRWQFcViXj0EDp1FjQ0I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bv3iHSFF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075335;
	b=SAIqv2TER6bD9WsQYy4TThgWX2t31KJhs1cTxBkk85A9fxTzz2aav9v5qUiCZJTdCa1xXt
	CDsgiHWfTzaz/8d9VhmtjUG7SbzmBg6vnXYx0nzwOWlNsbJeRY7UrNwmLv6O3LSplmPvg9
	S3e6gLnOSK6NOV7UbgIY7MTTZXq1yW0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so4882268a91.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784075334; x=1784680134; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0OXWiiZduWaFVZYnMUD3uONDkiNnSk/wggZx+AlWUVw=;
        b=bv3iHSFF+hWj5067m/t4VI7CcWwxTX8OgPA5vfhbVvqePTh8jYgAIzEbjnlmWbhAIl
         7l+Tt9hxBIxsgICRP1iAhtxLBJQ3+kG+gD23Adea8YHNC86fWp6EUHHvX83Rh47n7NHS
         I4Dbfm9sE6CQI7WAZ6rY8sX6s0txUO5br+PYVz/kYveG8koxX4nZnIN+TIWZHWP3NEkb
         QEM4t7/yTD2xLPBygZo0ugwwXuZQU9Kq3A70omWq1taR3WZSvCxuXVV6mbH9nkmiaDbk
         NVhH3I5GErO85y/cmd9oZEXsNwYxE52yrLEz4FS1mtqgJQq+cPKnU+QoQ/PckDYDSY4G
         /B6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075334; x=1784680134;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0OXWiiZduWaFVZYnMUD3uONDkiNnSk/wggZx+AlWUVw=;
        b=PsTPRi7LDC21U6brmFQMwDDYEbqM8hFs7k8h4TdKyM+gmOCRNFg5F4yJnZ/xHgrL9M
         He0a/2nal+nIqXyZMsj7s7B2lVazI1k3knQXPxnZOYdcKrgIC4hV0apVmYKTKBB237VQ
         lIthNsbZ61BwlxJEyacNI85/T5/ttb5X3dr2YimBjjGpd5YtxjIftYlgpMOXcuKMcsk1
         88z+uaeUkmMmHPwXXRrVprd+hqb7z2dJIkV/bHLWCXpWH+Mn+5uhZ16LJ57SWMI2HBxY
         bhU8Gi63qqAdfDLhmuDmBA6yymkweKOivGkZJHin4LqAzUb9HCJxQjkjbuvxabP6IzZA
         ObMg==
X-Forwarded-Encrypted: i=1; AHgh+RphPO5jTYXLtBtACXmEKmF9c84FvuHsaGmVdQmpQhb6s1eJptnFeAolmo2282SSbhHE/3wGXrEuPw==@kvack.org
X-Gm-Message-State: AOJu0YxZf5CTvKE7YgxyulEhj9gY1O4w8te6NeeTLWSRgMGsBfpxW/RQ
	OL2GUj9NsS6v3uNZKasYdWP4Pm8jM34WsUjp4SglaQdh8jdEOSvslUpB
X-Gm-Gg: AfdE7cneHr/5K46B6Ztu9CVRkfWYJHhKvvK6ZVLOZCdgsc3QOY/gv1QPSQeNdLxvGNU
	LC8r5wzoohx5VoaPqhuZzFDqP12L9S78jbGVxkmiJJ9wc6v4IP7wYU7vo1RIQ+2COAZQIjK8lLe
	x5ICvPN+l2VMk02K2kJvnuHh44Jk5KwkPyy18ZpSgRYlsn3SfaMiErwxtAXPXz1xl0sHWMkb8Fa
	52O6u3w2z4CZjOJIe2QonRe6IR8Vuxk0ZYE2XXyhTM9sg8xa2pCnoZZhlTucjcO1IxTs7I2rMj2
	YfCD4r5YDP91fEt6l8POnqLXP2kQhZfQan8+XmoFotIrpv1KAVVtqF80QMbMqNALAoWcONZXucT
	IhNTWmveDdaHZH69JDrY6FGb+yyXyQjbhsnBXeK93M76Vc5kkARi4gsjZ0SAQyGS0DFXGtgKMhE
	FB6cwk+4xGMz/JN1K7
X-Received: by 2002:a17:90b:2e43:b0:36a:fcf5:64d2 with SMTP id 98e67ed59e1d1-38e17dc6ceemr4827003a91.16.1784075334195;
        Tue, 14 Jul 2026 17:28:54 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm86075098eec.18.2026.07.14.17.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 17:28:53 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/9] binfmt_misc: bpf-backed binary type handlers
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
Date: Tue, 14 Jul 2026 17:28:38 -0700
Message-Id: <178407531866.2243172.12944140194021045628.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 849AA100005
X-Stat-Signature: aiawt8amqrqg6p7odgodznof7hkcyu9z
X-HE-Tag: 1784075335-157371
X-HE-Meta: U2FsdGVkX1+xbte17ztfMM5QP4YiZUUQQH5ABfdBP/4Be4nF44u/kovI/+YfjT4dLBo9VCCt7omlvMlqxEStggnTCldlWSPJPrB/RMCwivm9rtGpOiFzNGs1TQbI52VRs1pWPC+glnmIc2B1UdBjLsU/HA9zlJO8CDdkj9+3YTGW1ZMhVY4eWIDvObn0Q9MFfBwZd4UHC19JBBT/2NdMbh1Bj/IYxBrY3dDK39U/BQVuccCuNQ2dr6lOzmbYBFiHR3kXVFpL/t2P+mEDcUSeRhaqpkoQe+9d25ETESUDlgia4bJ6Zl7SX0ERd45hp6G3qf9AgDP/RQ+XXFY8HG87zP3YkKLjLtYlsoX43Aol7QTbYbJJwzbDzFaoX8req4hokof7C4qs2G1Xax69lA7YHKlfLNxcAoZHi6w0ZP84Yp+p/+WoDZtbIIJFDdDhhzRqSbLJhqtOL+ZZF1Ky9cosHx871wv29J4iYjhdZzJ5WAoswlK35UzVpPbmOb1PDMV89jTi3FZ8PIwkI1LSnzi3xVVF/1frDr7SM72cLKrX/zbNif8BxMhFclXpccgnQvOoRb1ZoFiGtVimV9H9ZBW+2qnEUoHijk4FBJk5ai4AftGmmwy550+j05Wz3t2NCAzRhmU/JS3Tyk6FNfVh0cYmcs4kJXmglNiPMq7SneAD3nopQN2prduTqbZ7eFeTrJiRlhdivba67/Qb6pkYSaljOnEpPSiUiEvoaHb8QsIBohzlNb2DckCbiGapzFwFxmMIfAfpQDm0WkK+P8Cn28tcqbObjZl9XvXKbP/U6pOUupN/p3yN8Qfm6nVlIcmUX+zn3M92w9GNwmRWaXQPkQQ96rgzEDK/Gv0Sjk6kSb1CHp1mcVvZFYSNZQf5HpIW/eY54qMvl+10CI56sgsFKALkOiI0gX8RTiHnaCPEPtjDkXIIY68btfHHIVT3SzkjifzQOtZDryWRIYaS3l6NfqF
 J4yjOs8a
 Snqky8F6EoS1XXArkdQvmlL9rN7i65kdmUl0EfnUtRxOHX5UuBi5Runq3Y+tMx7cp3XcgeM/YejMbIcetEui521yMuJluNb1jnAo4fyP2FdOu9EFzBcRB4vCI0sfPhC//7TEptoGQqWiNhQeg/HFW6yZXQIokKUDp8wkeiSGB3R8gttP9GeZcoGh4Y5TlOibwmRNfjfctGyj8tsuXj75k0toBFMbIGtMtgVSX+4N+YBHOMILei8knv6KGyaJjc4lq7Ak455EgC1xDFyMdqf7YbBNoDe9PCmWSG1eTASEHp0wm/vn8X2rlgJ8MBtTtP3ghKbyu4Qx5t58DDSEwjsiFD2YNO+i8icSKuwcCTAc57IVVt50Ry6bvZWIQyUgL4Cox+uBZXsWhTqjrR1yYQbqV8AciU+ePTxM+5vbAlAfS4nTiiQdHKJqDrj7FLMoEandYUwVCtb0K6zui21UYGgyTmhOKAc+DFBJu75P6vBeW0L6fSPUVUayIJ6TI1o3o4gFwzb2Y5zEAR/76XuJ22I9VV6Wa94aluHO/H3A4c2r7TTVVxhlBrCzL0/Lgayztwn5ee/PB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:58:05 +0200, Christian Brauner <brauner@kernel.org> wrote:
> [...]
> 		.load = (void *)nix_load,
> 		.name = "nix",
> 	};
> 
> Farid, this should slot underneath your qemu demo from [4] with the
> program ported to struct_ops. Feel free to take it from here.

Thanks for the recent update.
Is it still "take it from here" or was this left-over from the previous
series.

I think you've done the majority of the work here with the validation of
the few selftests and mentioning the gap for shebangs.

Please let me know what you would like me to do next. I just tested
reviewing the series with b4 + AI -- pretty cool. Was a little clunky to
get it to work but overall a good experience. (I need to tinker with it
a little for NixOS vim setup etc..)

I shared this patch series at my workplace as well. 
I think there is some interest in the work.
(If you are curious as to why, I can elaborate on that as well).

I hope you are enjoying your vacation.

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

