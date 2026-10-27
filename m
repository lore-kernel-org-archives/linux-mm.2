Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA3B606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K14t68+T
Received: by kanga.kvack.org (Postfix)
	id 9ECFD6B05B3; Mon, 26 Oct 2026 22:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C47E6B05BB; Mon, 26 Oct 2026 22:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DAB66B05BC; Mon, 26 Oct 2026 22:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67CE56B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBAB6C08E8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:42:40 +0000 (UTC)
X-FDA: 85366858080.21.3864C05
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id CDD9380003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:42:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=K14t68+T;
	spf=pass (imf02.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.44 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793068959;
	b=wjCm/6n2C5XaMJOoUoWbPRyGSydwuTHqkGB4fDqi21+wndIPBRfKRcpElP18tKJKNBQJ2a
	gTbahgqpVv8RDsUbSkgI2k28CWC4btPEubJ6s6yIZMOGXLuadlLcGurlMOl/6ZvvW7V76U
	zBHoyvNFZBjdWD2NzWd6yDiY2+RCfAk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=K14t68+T;
	spf=pass (imf02.hostedemail.com: domain of axboe@kernel.dk designates 74.125.82.44 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793068959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=MY0rDyqTZorOopD/VKi5uPnIP8jN+6lIOCEVAG1sK/Wh3EuZi2PC5SX6xrlLvq8lcdZiw3
	7sh3Efdj86Z1GsfFRrxOmDa22WCg1fqOwwdwKd6t4jhnbJCBBK/TKMe6udRPTbBbLxwNfQ
	RuNqGw73JkCfRPRVmahD3flBSDRnI00=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-14fc585291cso1850455c88.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068957; x=1793673757; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=K14t68+TQAM5ZYAtoQt4R+NUizAIVlUnbujXKL3cdvLcnsov0vyEOKZlIljrv+YtI8
         L8UJbaVtOEapLNGCaN9ahVP7tMtfpHpMmJYWkjlqZ+2ix7LnO/2Yq1E4k9S5zj8DJBOO
         mHyrgYIk0U0DJ8hyMSUDnlkbc+tz2hBYZ02ayTDV/X7BihjH84/FWwffWP5k/396/cl7
         Rt4yHE05qap2V7keY1wygcLQgNwtZmj0MKJOkmmaRwROzL8BZrRlwYRPrI8RqkYwpLiN
         5UsIdatcylIpJQohTyJxOqp9WSedk3uYoRKBIknkNbsvVtl8pbXWO5zIzDh9ffQ2AfSd
         PN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068957; x=1793673757;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=x9wZNuXoMSE9S0+K3bp3T0U3QzJQFe2loiZvJ4vPYnM/js9BPME2Nqa5CXBPVwxVDb
         7Qc7xytASHfibV149r3HER0qw+se6wP9EWoLwqV3LoKfrP5/8aSfe6Nsw+GUFCZJM4no
         DTPb51uLjCm80cSFLWKSSZhI6jq2uG4VNOThPJUucTjUMBoxH0vopILrjQulLnXut39i
         6Is8DkNdDX6Df8uffWlkEhcHvcsIhOxlCkGf/YsyoqDh19E53nEQr/h/x5FM5Gk5gigG
         EagRs2gMPhXrqI8+3nH0ZBlmTjnWNUlThgjMCVHVN9yBzZa1Orjw9s5vXDXQtncY4esm
         ++HQ==
X-Forwarded-Encrypted: i=1; AKwUvByCQ4Vv0C5QzKoXZPBrFgNwprHrTgqksQpVPw4+izVVjMHSoK0rV2xViswLFKdkZGz1hDjzdzx7Jg==@kvack.org
X-Gm-Message-State: AFq9FYKd6XeVWAeZz10MexXJXvq5zX3Jr1sDAxsJQWx/xqVtGWYtFPR1
	U3JnevGLURTsTi4aDGTGOK/kCuaXX7rkaWiJ21Sjy5qUnsZBeBLc9wCGhflcogU0NnM=
X-Gm-Gg: AYBFou1EYv4GyLgH0/4nBgGVA2op5ahYgCEUITp9vVcM5nHHUU9pIIh13YlxHBI3wXK
	/arANRHwBkF8yGBUg3YFOlaFAa7Dboz/5AhZyfnx+sdfHiwN1HA/5N3SWogcK+xQLENwUz6vlLU
	gaB2NKK5Sg2hC9G4v5WMwPjlf8dgP+EcJ8aQmyn5Bl5IotCNAEn2i2/c6GeARucv8/FlKPlWYXb
	/21SKJ0Ek3uuaOb+3MkF4gIsNe4sY5fy7+S4XBZ7BQ2T0+AqRxUrq1/f+3jO6hbOY/Rza1UgQlX
	mOzjDXYGPRV/3sVyBqYBSvMcnbKh6j2h4mFzZ+mQGxuV7gM9+BfJAexON4dG30NRu6cxT4ngjYO
	J1z35gUo4J7gYnZr7WuO0j/p7BNYJurdEQ2p6MxtKhWUVDCrtR8ZqU3RSHSHg1preK3mvZWJxxg
	EU+3SN8kiiAXW0V1Z8aPSZwEhoKNCKQbNWEqo8/t+XZtCCkwFcENXs1v3UQ3YCZqEV3jeuwPWci
	XbCl5n9oPavRyC/Aaq13q/RQRC0ZyuhEaY4J7yYJfXauyDrPOTcmHZkp2b72o4jU6vzN3al6SDf
	ZaD5thMCNVP9wFKf8n2Jzg7FWBLIVlhZKIuIGKE=
X-Received: by 2002:a05:701a:ca07:b0:144:fd7c:84fe with SMTP id a92af1059eb24-19937307669mr13761314c88.35.1793068957501;
        Mon, 26 Oct 2026 19:42:37 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a249c331sm59514670c88.17.2026.10.26.19.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:42:36 -0700 (PDT)
Message-ID: <30b1cf28-61e6-4f28-8e28-79815bd87617@kernel.dk>
Date: Mon, 26 Oct 2026 20:42:35 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/10] btrfs: Don't copy encoded read data to user
 memory when canceled
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
 io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-3-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-3-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CDD9380003
X-Stat-Signature: gn9wd1jz3y1wix39mip7mgnt9trdjkqj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793068958-430631
X-HE-Meta: U2FsdGVkX19GtkEZ+NSiObTgCxap+X/7siL+NCq7AAqelSeBlU+sjTBar049Z/AYWb4iHYYSC+zZIgzcsun71YN99w0n1r977oW+WBw/Q9gKPPpXrP3J5FtT1Z1UsfhzaFP+tnLYHJDEv+R/lzBmE061wOS/3cXdTdINiuT3Cgs5rUlqQuJnh3GeQzqEPSfLmlm8C4Kmt3muv2LlxwLTKp7jGJ+bTHxOMhrkkxc1IqMgqNK5ATGZ+r98KKCX1amuxAicx/eKw2MngzfUjiNLjtyRUkxtg1KiSxLWbA8LXLJIsTCEZylrYgKKwnJJznfE1BESsFtd6sOTh/wZHdsuuB8jylH/0NEA9NWaOZqxaBX2v22jgeq1EvJ3KXZptaXjLQa0etVpqCvJRczzN6Bf+JwXj4NGswpjEczJ5zUAauTkCbNi/EsRDKGtQrZjav6YUPYRy8kXSbVJp8Xnu0WoQ+nQwBt1D6gY4Y/vJsME8H1vK3zT64PANwb0V4IJcGqFBHkBkKCh38CqLX5hjwU+Lnc3jvA6Q/Yt8i15xICo4rA5X5+TlhMtY+M2TAzI793YCHQjX5BTaX85WGpOwEaCDqecuz1Ez5LMZnzXpHXWA8ez8x4mY54OrtN1dCT7ViFcIUbfIb6ZUD687rayKM9XsYuwGYJTVDcueWbWskDol59FtuBONI4Lfo36fYWdpznFIiDt8V7L8FrV/lvCT6vc4Al0LGWFlVGVporRtEiHWqFltrI2sNF2JDvfpAw4mcANaNaBlYqIVZQKvAuohCq4zY8ZkTX7dxngRWEjE7DZBH+0lB/JqqmGZAN6hRIwiPqHqt1G2rzAXFtNh0bolMWujPt3AIsmM9NhCHPN5UCqUGQRsrf+q+5EnMGspzc5P+OBdbYZMA1onLSkLf18grqohvNGyfVmsg/zw1prMNMiscOuIG/tDIhnZT+syN44xtQq9WXVALe77EBIEDSaVe0
 mq13sW2J
 /5AgEgKOZBKHdyAWZZIBTaBddzOOFwP3tixyJHFiRuipqmtyoorYBfdxug79cvfLaaFfYGkXj4j0FvrD0FXzwe0OsJZDt59lRRRcZqbgJrysvad72Kmmof6ZzQlLNr48TxhN5uRWW9kmD1qGOFoKYrlPCw/Jfe/hXrZ6uR3zQLgfY18bj+HxL4Lu3vEer6VI9TNAaM1tkXd0UqD+8cATXdWfYgEuY7MSqLEHAh06ETj/Fqsdfpb4qanJKhk+Q8sv5phxL647dWOAJ3LTwIsSNQwyiykU56477B7MM1uaXJE4Mo0GsVPf3R25RLEfqYrEh8grcuIGIH4fLKscHkrRcgdd8pWkHK8ePYCLPvk5mHqZnUbDd6YnAy6AxRECfLug3VU4BIVPzSJj7sXwy0w6rgmjiTC/KYzhRcGQ4FjLvCxSMRx8CoHGDBw0O0oSxv6cofB3IAK54iylv9S36cDFX0riGtg+JHSAApd1I6EcOogbr6ocCnh9AJL2rLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


