Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA75B606A83B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hE6sQFI/
Received: by kanga.kvack.org (Postfix)
	id 0B6346B05B1; Tue,  3 Nov 2026 05:48:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0677E6B05B2; Tue,  3 Nov 2026 05:48:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF516B05B3; Tue,  3 Nov 2026 05:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D30C16B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:48:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE80A120336
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:48:19 +0000 (UTC)
X-FDA: 85393483518.24.77AFA95
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC79540005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:48:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="hE6sQFI/";
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lM291bOBqtMxAhjKKdUrCs/oIbYXUxNdpMAZ1kd6/8=;
	b=4ukKTu/6UQSA2LWDZGmZgdbw4kourFn0+WqHJqItiaWa7OiPGZm7cAKzSmIREyC/exvXg9
	LDE3pVg31L1SGePCTgStfW+ggcrsMqkRxCP6NMa1C8F6Q/WiGK5sRmdLZNt9ggKEJFPFbW
	Pnx/S9xBLq5DfJ5VbY3pPsQV1eh7HH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793702898;
	b=ng8lHYnSOPefTS7tgP6V0dA7HuDGeCN4w6XNsnJTmI8nb+i+0xwizFO+4CtB0/+yypquNm
	v/5z31oUIiIFdXDDavfslWPAxF1zZlemlkXjItNyYPMvwXoeINhTRGd4/htchRHwB9Q6B7
	LPlrdLnI14h/lJXx6AlYORO49k7ttlA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="hE6sQFI/";
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso44867245e9.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793702896; x=1794307696; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lM291bOBqtMxAhjKKdUrCs/oIbYXUxNdpMAZ1kd6/8=;
        b=hE6sQFI/7WNDmoO+jRzK1OJo6OnCAmX6A8BlXvqaT+mKQbhX4RawYw7f2f/hmfBtEO
         fnTwgmC9KtfsVNPN06/zAmvLUKr4t0u2hXXknYV89e8mmAET9Gruc+WnBd/KUTDUVa9s
         wQ2wIAbF4am7eBSSkDn4t3rMdY6vgq9Kki9KaR9+jH7EHNOTe3/Ts0QtIOKgKsGqCpgt
         AyPVOjAnLFRjVvCbo79PgC2k5lgufDT0K+HLjoGqMZ8tk5gxFRdNT582OSwf1UxHjUQU
         9p9kt/OyU8fRdKNrrbRMMGaxTNij3v7vKYJKu4d1wVnRflgZmFyw8sqWnNIMMA/zce1+
         wJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793702896; x=1794307696;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lM291bOBqtMxAhjKKdUrCs/oIbYXUxNdpMAZ1kd6/8=;
        b=Jy1Fxo6OwWmsb2fWvKb+e726dLc7aV4aZBm988Y3anQcSMc6W1A0z9br2vJMe7ZD3J
         0eTPiMCfhT2hsS7D70tlr42zvkvqEIVUKWz8shWBIejR/3gJSvqX//rPiHEpKGnPr0mN
         E904uNS+b4MpHFz7dDgocjg5RCfSC6FFsUSGMOK8+RKKlgaxxY5cXhJPyJALP/c2Apto
         XYU7UJmUVxiD31EMYAa0h5x4jvUp3mBLpCpPkv0gphHSBL4Gmzw3fJXgoy6WW+XhSjRw
         wnjoiSIOCh9klQI+5rtgMi1ZIpojaOz1IcUMgRadqDh+b6mcJTcNIMdFuZv4DIvTsjsE
         bHIA==
X-Forwarded-Encrypted: i=1; AKwUvBxOPgb3G7K08mMvPxDwQ5nL7B1SpL3N4roMGwDhg9skcgHhZQRW9nj+843TkbQ4FXPIkf4HtvUH2g==@kvack.org
X-Gm-Message-State: APuU4Z8uchXWDHhxclNvdFmGuJzGlp6UuiP7IiBfSGoS5rZpF7LcpQqp
	R6aboNn7Pji1PGZBimp4zQ2rcGaVS1JYdnJ1yQES81UCN3nhzGyYa9or
X-Gm-Gg: AYBFou2oYUEjDGSAxbpQwWbYAGqXo2asBLaPlQzcj3p39YoJfmf/JqGRrOXJO3pDuiJ
	6f4NLQWyoMspA13nq8oDbWEYVP0+E9A2YZ7i6bu4kgysQeZtkDzQh/g7NANiCeEPPuLKNRLJbMl
	ILcXs4tcLGy2a3mvFIVltPGl4euVP8Li8YfT2wJVTpMyu59OF4BC+xbGcaMKNh3cS5EqFvRk021
	3U/y09mc4qYr0xmcf8NsDb9ZycerOR+5w3Jz96qYz3901xkp9uJx8JypDyYgeIf2VVW894JZBLF
	mMpz1kPFbNPyE4xRAs1DPnANKEV81N/QN1f74rzaSI0RTeD7pD3KhJOC6ymMmS99Re/RZjAKwur
	FQI+P5vRa+vxhv7xGEe61ZZBGsOHHEelM48S5jo/RRTbn3z/fDs3B70OZbPa/WyJAgzuNXdpkPs
	l5/baa9P5tdIcC5Y/598i6XMw+iglhVKJIWm//DUaASE/KmitVFpi/goyBW9zBW3/on9Wt07GC9
	8gxSmJhz4YFIyFiLyw8d/lAAtsFTj1xT07w4BHXneAvg8sCYNWeUKIPoI32BPGV2hv0xaT9B6UJ
	7KxRA8zdJtlbYisGpqUKBa8=
X-Received: by 2002:a05:600c:3d8d:b0:4a2:cbe:beac with SMTP id 5b1f17b1804b1-4ac18a89393mr273983915e9.23.1793702896409;
        Tue, 03 Nov 2026 02:48:16 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad35fdsm227323435e9.2.2026.11.03.02.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 02:48:15 -0800 (PST)
Message-ID: <1ac14e11-ea67-405d-a212-d084ba394dbd@gmail.com>
Date: Tue, 3 Nov 2026 11:48:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] selftests/mm: test a partial mremap() of hugetlb
 memory
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-2-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-2-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 768x3uxe9xypoh4a9cmqthn9rou6hgk9
X-Rspamd-Queue-Id: EC79540005
X-Rspam-User: 
X-HE-Tag: 1793702897-988407
X-HE-Meta: U2FsdGVkX19Vr33KVFzqSuUmZzFWpCHY+SVBAfH49NAzRgumy45q8TGoc0pcgjZC37Q8lz5cPzD2c4YDIizzWKRC3csQqWyRbvpIEEaQcRLRWqELnAZuVkkkJSeN6szF3u1Sm5cbDzj1cg8wSaZK+XcgSBwOFJthISjd8DguVUo7V/OQLt3ceTo5ARPQz9Fj/2lg7Kzwq+wUfw37UKsvyHbyH1GRaHYo8yXxlrMdcTX6PL7FFmRDz/7L4pl0JQkHzklzPWhcHPAWs9HEnbRWLuiDCMSw/FIK2Zj23dFTfGV8ns9rLgPgAPBBYyRwj5bTM/QzJifo3Zt9h83SvvkC6Ntaaxu6SkGaiwGD6UzzBXtWIm32UmMxav9e290lWlanGSF2hK67vYbfVAQRSv4aW+4a3sNl+EzjcRB6t2hABML5bIjiZ8q5uuMqDDfpKh9BNmqjkUXuqdwmaPwEEPA34Cgr5wUT2IxwFupvnYweq8JLULjMGsJNOBDHgCvbXMWsWHdLx8rKfTPb4JFAGUUHbeepLYqW5hrB8LpGo7VxchYextmaO8DDFyQE/6MwzN9fCg4znkFGykMXSmCb7aJ/x5rig82zrlwdJ9sgwXPaBhU3gs+BxPJSrVnWSWEIT4zgbDYeggUyK1f7vHrAJ9C7QEhGiwURtrKpafKwfS/KjK2oqJe00MfTUDym61X8XUbpI4+XKlwPB03b8v3fl4dXg9JAGbfww/DB5Y3SyNgR6YSIGrc22zVLJkhbIdLHdz+oFimGBiCFzr7PdMeTKknae9xamcmte9WktYvEeDpL+jN/uGLzQJ4uKxpABE4gUTHLe9Jdl+7r6JaVUQ7486Jb0ET/ZLW38eoTMkf3fmXlK1o4sDqaaQVPr8H8Pl/H+uaIknE8O9LDLKBiINQkELzlMfXP2r/betk2D6XGEnMUXWzM+qWSaMbr7UiBJWHlGrHMf9bQz9WjKYmny6cc8th
 86pkTbzs
 QkB5Lv8hpN3wh8OwGQFuH2l3IdabhLFxIHRAX4eO8HlulGhglyeOlqGJuuqzAa5jKTYOqLtX7K59NZf+gusNd2oRX3M+v/UgHmucVB6GzBaonDBdHBnDDjkAsRJ+ohZyLWaj44P2bXNSv332533e4rkDBRI41W3xgPeIavLVd5etSQrXO2C4qJ8h0Z0s5z/NJlGhNlqN5a8kra07VMWm0++wDwOSqjCvTnB16blTltoeNHuNntdE5QtcxUsvWGXtLseXptQCh2JGTotuTh4H+i20Zd9xUUT/Twy/lDuHMQDAYfydDl/v6Atzd25NenHVugnWuPS5aX2ax4q88egmUCj9U/d6P60Z+FPC0T31AIfrdZsnUilobCIU5b8syD8Sm8fh8aLkrfkdrZwabdJazwystuRfvCEaABT+ocGFs5cfM+MQp0HZAv35Yud3UsGLE3UdHtM0zwRERZw5XP8OfhM14FzItDQB27wDy6S0SPuaENIb0fiX3yQ28S8TztqgZL1gfQlje5SlgA3STcWHwi36zv+TnEQyxlUx33BPRKAQMDA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 12:45 AM, Josef Bacik wrote:
> hugetlb-mremap only moves whole mappings, so it did not catch the
> reservation leak of a partial move.
> 
> Map four private huge pages without touching them, move the second one,
> unmap everything, and check that the number of reserved huge pages is back
> where it was.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

