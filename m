Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB2A607E059
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YXVg4m6Z
Received: by kanga.kvack.org (Postfix)
	id C90FA6B05B9; Fri, 13 Nov 2026 12:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40E26B05BA; Fri, 13 Nov 2026 12:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56986B05BB; Fri, 13 Nov 2026 12:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 974896B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:18:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24DC48023E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:18:37 +0000 (UTC)
X-FDA: 85430755074.04.3F629BC
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31340180010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:18:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YXVg4m6Z;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
	b=TyxVmvZ/GmIALhCbzcIezJk4DNwHH8Rovtolfpmi1DqmpFgmDypETNmqg1+qFw7fGRUqtF
	oirJAmoo421dVwS56Z7ShbQC4yXc4vuW5xgS9lXj0JZ7qr7XUZVIqFasJYxTuiWdyluz2q
	AZmvhBEwEn1/aHRNjwkvl+RrpJgHgnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590315;
	b=tIMWq3RXKBsRtAWcKzZPgm2QiYeebucWmIsIDMF66cR+gIXc2qaLAoYBx2nhe3ELIClTYW
	rif4XBRpSH9uJUAmrnhGNNR/JBaoAotWytGR1cM/2KJE0E4sZi2MIXx9byUQNSwsqiww3h
	LQmAJ64taCaNUDQUGwGTHDN3ho5KxYY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YXVg4m6Z;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b904d10882so516401b3a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590314; x=1795195114; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
        b=YXVg4m6ZMpPhED+K3lCB0QMuU2D6puj8fyont/fOrjvmmXCCLhNWB3WDn9nindYNYI
         g6dPT3eQoI0vQicUEZ0YV94Z4vQnXOEmjyHOHQ8mzroZW9st3pMJ0ZT0USHP752pPy6f
         tNt59bOeR8tk5wE/rk7WkRz7mR9HZZsBHjPsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590314; x=1795195114;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
        b=iESfEAJ/Yqnx//sO5Tg1T6FizW1+rEw6PtNx7J/+cpYEVxIm5wlEh0fvQme0ghxcr+
         BRiapyl1s/10MD6+pTemCCm90dgdI8pXc+bapyep0e8V222LXujn4MvZUjldcb1g5km8
         Kv9C0991mZsy73uEIV2Zroq4P9fk/C1+J0s+WThMHoaey0go/XhtyElZHs21Q9jhie+o
         /Dv9rHXcn9cQPAF9IQ3cAMXaVPWSgMJhE38y7E8xhILc+x5ZXPGoYhbhmcX00i8nbcjo
         18v4QEncptDwgvIcTSZ7x8pvT580yF1FSjIde2Gx4hU95PoX0jZsDq+OhtcY3+H8EiZ2
         Ierw==
X-Forwarded-Encrypted: i=1; AL+hErGi1a9OryLWnZd/GB7O6PgxoxLuOL5BDTFfV8YYPwGdeWf2b3MByYDU/2taGKtfdqTATmJn5piMRQ==@kvack.org
X-Gm-Message-State: APuU4Z/ryWQk+j1ZGxZtoD8kOaTN/gK3N4NH3nqehSUwsQFkG/KgtC0Y
	sy+cC+WnvUJMUYjUsR6CpJIJPtMUV3kQ0m83PWF3PcnMupE947kRyqWSDMELU4uiEyo=
X-Gm-Gg: AYBFou0HnLLoHgga0rWxzbtqzLipyeJMfUCrn0QkEeF5lPAj46+hDJ289vE+KOkrqqw
	wCo3REuqbqEG7F4j3gdGN7fsTkygljgnE5/99rC4blfglQxXGuLYsactpbTtyeQ51PKwUy/I1tM
	0f+rrblHT6u2w7Pq3FxABDaRptf/whwYvXk+512OyFbTtB/SLEoxgCs+2Jj2tNRRZcS7U2IPKOJ
	TuzjBpwYveeD3gdtp0Mjvl1g6CIPJEhxmt6GrVfl8Gs0h3xeTX+GDBf739um5kmWxcFO2ejcYW+
	aZ9Wn2pK8SRL4/+ApiCWYLeWenGtXhyw7o8kJT8+m+rrgkby0BjDzpxwQ2r1OXkYtOJYMO3B+E8
	az0zXvkA7w0n6aX5dforc5UDFsLUflwVlzRlgBilBaeS4SDD1gLyXY7i1GEKfS0R84UxU71tTbf
	d1EuIkfPTzaoQEHSrWBRFuBrJmP5O+qfm3EtIUItzQzBsXWlawqf15fz3MwHzNixr1PpJ8PBeSe
	dU3Hpmdl8L1dxD8DmwtNKIJoWymcXoY1qV5CebPQRZ4BgENWRbK0LNWjvtkI7AnLus/lik0qOtp
	Tt5dgbtXKvdH/PRfHg+Kdvqm6/UUJvtfKEk3EJDNC/rLMvD//h3n+b6xmdeURuq4bQRTteIZ+CV
	Lwipv1eQJvXDh8al1StYiLZuwsfaAgFJZXb5p0c2bOhVIZuQaadDY12OvT1a7TIOOk/5TfrxQIh
	6RU2BMJpExr+yiiqYCRH3Q7WMPN7TRkbq15M09qjzHEe7cXZ04IxG5WVnZvWw=
X-Received: by 2002:a05:6a00:2c89:b0:893:12e5:c07c with SMTP id d2e1a72fcca58-8beb619a61emr2835248b3a.27.1794590313819;
        Fri, 13 Nov 2026 09:18:33 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1a6dbbdsm1460009b3a.24.2026.11.13.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:18:33 -0800 (PST)
Date: Fri, 13 Nov 2026 09:18:30 -0800
From: Chris Down <chris@chrisdown.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, terrelln@fb.com, dsterba@suse.com, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev> <20261111153532.1036709-2-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113091830.c58bbfda1f249304@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: iko5einn6jrsfdnp1jmrpcrue1b4h3hq
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31340180010
X-HE-Tag: 1794590315-435979
X-HE-Meta: U2FsdGVkX18WlF67ycxXQLEois9vRjE/tX1asgss7bUBmlz4s8aFsgrzpCO0Q7YFDLcuyVzJCubpce3funhC0DlSEVLT4TNSenv4/lVzNfRjnHQ5WDxigJnvY0hwMu6WqGUmKoifHeS/Dxw6zHw5VvpWuzCpbzPkj9/dptn/Ss10v890spYw65UTHe0xfTkMa1RW6iMYiqbdQFNHxfnsnRJcuQVsj5Rn3LjnIXd4Ga8bG87RYS4Y4iJ7WvZLcKtS7CPrsYYt69gRb8KXdD63Wn3/m8L2qmeYhoGcx5+mG/keU2ZD2Q08mThr+x1v/Panq2SmdCLfRo0pCKRGmDwpjr1oQAx0ebKZ8w+WXox2cdYn9GqqoqTtPG8woVpuaXX5LWHx0GBte8ydpQ6he6OyPk+Tl8M1yjfq5Q4noX7duuXv1GLbSE2A4u250vcVhee9MMEbjqtBUTdlYvefsm7AXLamDgcaybjQ2WMudg2ZuhJZMnQBWP8qdC0tMtG3DTDUTkAMUUo60NhfEnIIWOvpYGvGHAGtX4OpM9M8I8sqVVFQvbZpMl59F73Ay9f0S3t6ZIMtd9hGYYEk8U2abCNR9/iesWUq68zEU8tSaEfHxKb/YoPAYM1L2pEE6ZPXMcxnTWCf4pK62wnTL2JQn3xu8wS0G7zkGAf3x5ctKUtKkz6+9unTycfm6dJNxF6a3fx4zE9IhikzGu7a75wWqLXEkHNbi/EFU6/rheJc0iiI3ItWk0X2/C+8PCIEuzkuXyy/kOYxmQmL1TVB8DJQenWvjA193yOT08us4D5whO7zDcErZFQXWIU0PKFQC/JG6hCYcPmJ+fmlePYz6AzPi9WspwG5rP+HYzoPAzFe1of5D6U6WorbgKSSnGdnMUc7WBuSK27T3AzbbLTphD2cJ8Mc+T6iK7h5IS7yvz+xitJjvYaYEcM5alkV5jhfAuVBVLa4N5GtwD0FPX7rKqxqZWb
 C6CpDB2Q
 HRkNEGBybWsWIjcevprO4EuxWHk0t6c30nCkqNzmG2206FxrqKr41r1CsQ74W5oK61p93PU9lMTyRSdGNfPk5x5x1tay3hVMp8+cOg7vB+Qg5X7eKqBqLRheViiiZFWDzAIDoBAlVfNrX0HoA0nXlSF2Qwd86EebH1PJfU+Acv2Sk09bmgfpq0Rs51kscACvFUKoirceOT7a+6V10rR7zqnpEEi/2ZrDSANgODu3WpH3qQJNNWVhC/x28k+bBkuukEur6E64vvbE4xQEpeC3f3bGZ+UTLDKOFEtX7wFf22MO0Jilupsn8o11Q/CVYTtvt6gnwsCZqK0cHMlMLUPNWqn2evX5mKhBk3HnLi0jTAVpwzw1WXPxT4HThDUUuKNzq5WBjzjxe44ltBTIEsq9X8Ph2KcKrji/6S+WTVxssv5qSBGeZ4p+hOCwj9BgJjnH0hNLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Usama,

Usama Arif writes:
>Use vmalloc() and vfree() directly to avoid the high-order allocation.

vmalloc() doesn't avoid high-order allocations any more. Since
a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator"), vm_area_alloc_pages() first tries the largest order that
fits, and splits the block up afterwards. So for these 383 pages it still
asks for an order-8 block first, then order 6, 5, 4, 3, 2 and 1.

What the patch does avoid is kmalloc() rounding the 1.5 MiB up to a 2 MiB
block, which is where the 516 KiB per stream comes from. Maybe say that
instead?

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

