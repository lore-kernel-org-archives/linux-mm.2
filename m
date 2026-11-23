Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966D0606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BSKQ5ffE
Received: by kanga.kvack.org (Postfix)
	id AF8506B05C3; Mon, 23 Nov 2026 12:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCC26B05C4; Mon, 23 Nov 2026 12:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD776B05C5; Mon, 23 Nov 2026 12:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9C06B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14BCD16096D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:17 +0000 (UTC)
X-FDA: 85467090114.23.D54563A
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FA5D100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BSKQ5ffE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455435;
	b=o/0U2DnapofT32mZAAf5Avd98M/On/4z7b+vz3/qW4sXixqgzVE9VWhUt1qJd8tbrmVHDl
	iWkgdThEY27fkRJTP3uMCBnc9x+QjoVlk9oTrpzMmyzz9FBGkURHEtvYJicmWcZYFOmiR8
	i/sEoZd/Bwoz3hks6RqC4OjxcZoXVWw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om/YY5kZeKIylMMbicCgla2f6oKdp4uIwLCHt/pWIM0=;
	b=Vs/IhgxjglzGBOgZRpIlmohqpBCtLcU749SdUGkzMhZQ0PhJScRqAcTT3rBjl47agZwc2b
	0Lr3OiS3lt55vViCw0WjRo7bov7QLXEu4zevD3Zm0ZgAR2vBm1N9GQ5gFUJfMjxbOsWl/w
	5gRT3hEdf7loPoB4hJymFZyuU6M2VWk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BSKQ5ffE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1376010eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455434; x=1796060234; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=om/YY5kZeKIylMMbicCgla2f6oKdp4uIwLCHt/pWIM0=;
        b=BSKQ5ffEaJlABCTwpLtJJPzmC/1/sFh9FjwdyKOtwDDBSBLD0hUjr5DuaH6WrhAIWQ
         rZ8nVjRFwEgGbP2lx1Xg5cfs2uwXJuUQL6zLbpuVlGZg41o4FPRRDUx0z8TNW/RfPkXT
         2gdSDqzl9M0J3u1+q15syIM3yaum1f0ir2nUFnchweYgy+KKhcsxR+nGN/QM7oR6Zinv
         tC/4CkU1YMAaBH2DkmWZ7qsgfJGsrBm2A4TqwvskCr6WbQzMPBgWiv3ufNpsiplU8e/+
         qN0GT7FNhv9bkAvbKEszluvoOo2c0/3WD+uY9m0EcFTXVud2sKmKqXl9PWrgUaXzps7s
         LaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455434; x=1796060234;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=om/YY5kZeKIylMMbicCgla2f6oKdp4uIwLCHt/pWIM0=;
        b=aqOKr+Pp0P7cU0PZKxbBFuQ6PTeApADi89ZK5Tc7nTt3kMB9TRk2Hfwh4h+MDNOO2S
         /o67KJynNex1zIrIwmATaXK/UIUy4p2YG81nPfmjJLRahRBuz2wZw2MhTa+GODy5/HoR
         DHkpvy1SyMhZOpdYojNfPBsb/os/N7np+C877LT3PyPXXcxCXUq3PkTjPSXiBjK1NabO
         LGmbk/Y5ViIKdLfeklps37hsZVR7mNEO3zBKvnbYrhRyeZLCCDDvy+j1wVhBoz665ZMi
         7NxsfvRAZ5egZjsBXTXWXaBxjq+Kp+jAmLVSGPslA15NCe7MWtop6Fb5W6EkxIiny11O
         bfxA==
X-Forwarded-Encrypted: i=1; AL+hErGzMmvOAOxoQo5na01udNQsy9EnNDL/9s8L1QbNI6ZroKwVq4BiofxJOTRPu/REi+glQ61FroC5oQ==@kvack.org
X-Gm-Message-State: APuU4Z/3t/1AKcwe29gEjwOIVl3DKuZ9ugL6+cVha2tIXXCjfgRBSYCs
	N+mGyESjwnlHBpMSohf46iuR8QXnCP3oyWDDByN55KkFlbqYjN95gt57
X-Gm-Gg: AZFdTZckCNWKKbGvNhuZm57lwszQ/3VHJsoo7kaesRAPtwJQP6yM8OhYMhHK3Hcv9n3
	YQGeTKtO2cITQmy9TVRD+vG5g1vhPOgi02dPXhMU2IpX9gzpwLrzO/dySt0X2xDBmVDgq0LELvT
	zaK3NMeD2BRDkZCfyb4jn4x/Gitwq46+sBAc5hCXXC32mO14TlXo6jghoXLpY9e3RANlTE1KWus
	twXhz8DIGxcggQtvCRQ0v+wLNnmXcYa6wBt9NUAWevumVsw8aruSnILN/CHSZHvyHzrpX4xgcjx
	vftRdz5uYOyDOsHQA7kxtS5oOospH8EcUEsWV4i5HEo3GnY/vZLJQ7jbDuLNUa/khZmkgpQ8WRn
	Ywkkgf+BoY6J9tM3PgMiQEs3jb87m9TWH3J8qZql4QZfHmVMAaHlsZtIRCVVMr1HwFeno1isGr8
	i1IZEgvsIoApJyEDQ5P3RllOLjB+XwhscDnfCIRqsTevvJryNUTVBm5gH+p0j8DfXlR8zmOl5Mt
	5fMvfD6mU2PJ5akYKZrGiGUuL2UV0pjljphVGo0caufkVC0e4dvJZ0sxweaDi+DCVSuFDkMZY0O
	vZtgHoybl0U4AJV1vTT3ctvVUZhoFfvaVV1/Cllb4JwMdBhk7UpdUynKUcP3E3PYE3gHiCoHxqS
	TLqks5jPeOMn7KBXxkUv2UHPBWoM/pFEQJkBNY0MbYCjKjH2eMV2TQLiG/SKxjA==
X-Received: by 2002:a05:7300:2202:b0:36a:1e9e:ae61 with SMTP id 5a478bee46e88-3857170afa1mr18197276eec.38.1795455433928;
        Mon, 23 Nov 2026 09:37:13 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe
 filter
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 04:00:26 +1100
Message-Id: <179545322647.4.683470932650691650.b4-reply@b4>
To: Lian Wang <lianux.mm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev, 
 SJ Park <sj@kernel.org>
In-Reply-To: <20261123120009.9120-1-lianux.mm@gmail.com>
References: <sashiko-outbox-227387@kernel.org>
 <20261121211922.131352-1-sj@kernel.org>
 <20261123120009.9120-1-lianux.mm@gmail.com>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 3FA5D100008
X-Stat-Signature: 71dgefsetcwntjmjnffzc9zbb8tronsk
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795455435-647379
X-HE-Meta: U2FsdGVkX19mOKGEQZewlJCO7WauG1fuIuHZaEp2GFF9848o6kMXohzV3haHrNPXFGV1KWwuZljeTY8mSdillbcInZew96OdRxwmoFi+fCb9vzOSMFV8GaxOtni7b/pdb62c1gmwZBbR2ES6UsdZx6DRlPXicbhVwwwqontjoVGQuk7VUilvrvzL9o3eDYHOkyQfZq2uAiSyT7TblEh3mZ75MsAJFCC0v5Mz47Fh9SrNMr8qFPg/cf7P4DNYu03YFedCa3d9+QAqQA/j9WK9DccJozawJY3xFThklDjucQEUC1+d4rkXOWtggbMln97Vl88+nY4gcqq5RjMSHdj/njGvmNwEu+422ykBX1OYhZeJlZ5V1nqF6IiE/BT0o6gM7sNJr9QSVW0BUuf1q20Awz2WaZNN8B49rfMpr++6WzseQntQAChzmde2prhTzODFvoNQdRxxFH64oiYeDoINFB5hKJq68whiQTpzax9TOK29MEj7JeBjNpBFiD0YJ4u7229C9CcwlJsbzTSA3Ce/lC3qK70Zc0cDOaiBlwSIeny7NFGvpUgYLKA4+bvqTFTg49MWF0WqNWn2fd/DmzvqnOfS8w+RmhxwZpv6npZfk1j/VuXJ2wiFQNTfo/Oyu6VKNJDcNrvFrKzj3jzbob6jqatBwO9z33yNm3yv7Ba5HRvlQjqb+Zl5DPBV9JrGEtiscNqH0Mqff/qb2CC24dwVJMc5GwKeVSCFj/A9DBO2PYwusY+u3xWgbMVFWktwbgGu2avngB7qpM8nkfVZgrnUzMKAbUl1Nrg1bVcCvo5NTVOJRgwWfjXmY24A8jGF2z6pObBy3SLK73WDtFjB5/MuB86iVcPSh9lMsZuojQ+IVfGQ62elSI4bEaE/SXBO8jH7kfZO8LOxlgb5kVwyDxHnTrb7Nzev4uaFl3tod68J3i1HZmEZMMISZwttb+ewGBVV6xlGGCSw7HSmqcdmK+M
 z2kgt4HE
 qS9EM6h4npJRA7agYvGaFg482TE9R7BR8YSaW8+TrM/a02QpKCT+RqQ9wYp30QFqkXj98StqOEguA7H09MOntuEnqOj/2ByJihBn8OsgfKe0hEFGnNgaSyBPgKFCrrmms2HzaQaqfI08w7tzWyEkQ4ErKIAE+QgAAwdznQHM5xNjli1UH4r3vn5nkwD4o+iHcP1+qP4vEvGll403KJdXqVpdF3eaa+OCvYNYsOTH63Ks+0hhp+scT0ZOyuflaOWaAGUv188Ebu/OZQiWeKrrCYDEqMQqMlujWGZw6qnbpZvte0a//kH1zYaxNJQUFjg+Lr9uSyi2jweEkRooD7kUq9Fcv3iau5rQOgOf3Rzmv5fbnGdjEUMSJI8960SoYieT1286cb2lq/qG2kAkU7Dz2z7S7lKCrSCjgRdfUmwTTt4z3jAR0tunds/MNC84L0++TSI6EDeACHXqsa1236C4Ej1xzbQ8ijW3NPedZ6kQZXpbgVNJZzdzBLiJmPPDMUxx9q6ol9RAHDRXQkGpoX/84XKy1D1K7mnARVrlyWtIuz83XtYvVDGiMN5vK/2Sgfw9xaJxBKVT9+j4r204Gsdch9CSchKTSCsIUgai/EdADzVrPqnT5alvQhCgsw0fa8tWpZ4gcFcaaRG1PqcowaPqx2407pqUvSG6MKWhpvcVkQa4BRVRY3k0x5CY720bFcd9+fhblsyZwZ9FqBVSec2/tFQcYSxGYQYt9d77bsjqRYRPx2gUD3MXQXWhT+HQJwA3iKh5i7SkHpbsQ73e2XMJnXwvYIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lian and SJ,

On Mon, 23 Nov 2026 20:00:02 +0800 Lian Wang wrote:

>  		addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
> -		addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);
> +		addr_range.end = addr_range.start + 1;

With this conversion, each paddr context looks up reports in its own
addr_unit. Producers submit to one global queue, so two contexts with
different addr_unit values can interpret the same report as referring
to different physical ranges.

Could we define a common address unit for reports and document it for
addr_start and addr_end?

Thanks,
Aveline Noir

