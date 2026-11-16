Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CF9606A8B3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xC2qOUCY
Received: by kanga.kvack.org (Postfix)
	id D22116B00EF; Mon, 16 Nov 2026 02:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2856B05B2; Mon, 16 Nov 2026 02:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1C26B05B3; Mon, 16 Nov 2026 02:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81AA86B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:45:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7F5C8050D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:45:52 +0000 (UTC)
X-FDA: 85440198144.20.10E9FDC
Received: from mail-pi2-f9.google.com (mail-pi2-f9.google.com [74.125.227.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id 12E3D40003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:45:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xC2qOUCY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794815151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmgK2rZQB0Zps7NPdGicEsUeC+FDAzmra5NHyyX5KYA=;
	b=fqj6h7iOaNWLuwXuk9Lrh7z8QtIxjC//whEX2IAE7O8PFyS2MyKOlfAF9oe7uMGpncAaoY
	QqkkX0r0QNLcFqWo0vtxRDFak/22tO0jvbpMrFzsryD12Tvd5UV9B0ngp3ubg4D+q61zYr
	+vRSHgrq1pbfi8IYXCFPxNGcKBa4eqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794815151;
	b=gNa3Kv3FfO8E42t73HTp6QrkpZbdFXQSrYQFZDbtXguCJ11Rx6tRUsKtqwwPD0je+2LEsc
	6WDLIDXSbZTwTeERGXM+TzUdeZ4PHJAfJIfzM2wQltmYcFqRNwoayyLYed18C+cqmQv6DT
	5k6UpwKi8REGWL0qqz4q9UfgWHkJTY0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xC2qOUCY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pi2-f9.google.com with SMTP id 41be03b00d2f7-cdd9779aac8so728776a12.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794815150; x=1795419950; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zmgK2rZQB0Zps7NPdGicEsUeC+FDAzmra5NHyyX5KYA=;
        b=xC2qOUCY7y6qCEVhs3yybjs3CfSWxdxh0U11EF4AodlMTRfEW7ROHQeyQ/tHc93VFG
         wWE3TLQmBX5tQ0As1TateOCpwH2KleXIhseffu3NsQCY7YBOIctUgXcZL+z1j7rds3ci
         l0kbGsSapisfPfXZ50DB1OwHRWcvGltnNqqnOQXdHl4KS9hRMLxPW5cOhxzQbsSAIRVV
         +tYcEiRHCnyrZWpf85fxYr2xhi/Wr6TOzm/sxCzI003x3HrhxBWGL/FcRR0AQQ3PL6vc
         sHU4W/3U0fMu3qpTlUU8UGtMGNvuKaMLrHo5CoWEcLi/e76MmAwub7z+tdEah5AqOsGv
         XxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794815150; x=1795419950;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zmgK2rZQB0Zps7NPdGicEsUeC+FDAzmra5NHyyX5KYA=;
        b=GYQcpGg88/NyxVuOThZXcfZbiucTqdmavCbAT4+/X0Ss3KCDXDWGOcOxmrJsFN/YVz
         xGfih71JvGlY6j618QEAoqynDk3w4k5HjVdH9YHSgzBH0tT7ZuSi3JqENbe4zUVwYl9y
         DQuOMmOBfKYY4Ysvn61YuKveL07ta1gRT/j0ytYgVXOQhtleLMrtlbXRsqSA2cWCh1TQ
         U3dz459S6Bdw+gYMLsDPo2cPTrC8g+lYc/lj/HsMObGw9KSFi1ekdh7vrIl2N+Gw7sqA
         BNg5wTydFeqTF/0H0uTc7uoh+NkE/QM4c8olgOeO9NxUsyhoOtUnOQKvu+/AuOXNFajl
         R1PA==
X-Forwarded-Encrypted: i=1; AL+hErGnb9zsAGerc02TfC5hxJ2v5SgRY7Cbh5KodEv2d4H8AwgvUyd77MXa8bCUjDFWrTAGuPEi225wrA==@kvack.org
X-Gm-Message-State: APuU4Z+LzckGQMf1qdIbybL43d0lBChTuPrl2ZxBc0UeeJ6f5eI8tZ8C
	h28w3uSCL3JN4CopZkuQr0DI49TG1N6WU+JuC92DMbofKvLlPCWv5JK2
X-Gm-Gg: AYBFou2joaiYC14bkDOzyocAdLdiSOVJe099mQx57k+97TYjBJE69UiWbTs1MzcsHIv
	rI/w5EOWz5TA7nofTjWA5VZ71M3kgAAg4QN2aZaw7Llbq8D9TydtKvT/MNZckVzhKFha5ASJYd6
	tJhsBc8iI8O+L6e6EHlms8J1Lp9YO1vnnHAq7HVuSoTgoPMIElbPmywhKeCOdO2IdYaRA191I67
	8zYfAUGwcQy7XnE7a0DfzMSyYy12rs5bIgJ3GTerI6AKjntVd84mXEuwgjjXx5dkH8m64j7nz87
	BtfXNbWrbXdubDq4JQnoioNcqRfy/HoRpHVlGrZhM3CNW8e1BNE4IOrVr555Q/KkMLK7v0kwWqF
	bkPzQYqhMfdehAXF58O7XMlt5MZCHqvYkln+QHudULw5xCeWhZQjZaCvVNdHHGbB9rztJgPopXR
	SJHgBxnn/LQPkmDtLSEES98ebbTOCKKLGK+P+8xT/lJJd/8ToNGqEcuU0erBTfirRIqfFv/EL4F
	InzJOzE6K6zqYFol1arwWbXNCRGfwC6N5fIzcz6DIP+jyhDivkJl1dlwGFWbPgFTUgYpDYQautW
	BHV63xzOOSOGBimkhZxjJ4VFpbjpfMybtd91bBt4t4Uh9nD7bDPyik0vrQzl/AHU+nDMm3xDOA9
	hFe+pJL2LMF/qfdgLrnCm+WMzEuCqaK2rdx9pvLb9L1mLodu1AtSK+Dhw64JnvJ8=
X-Received: by 2002:a05:6a00:181b:b0:8a0:7677:c8c9 with SMTP id d2e1a72fcca58-8beb7c21179mr8733834b3a.51.1794815149534;
        Sun, 15 Nov 2026 23:45:49 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1a6dbd9sm3244287b3a.27.2026.11.15.23.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 23:45:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 14/27] mm/damon/paddr: support REPORT_MADE type
 probe filter
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 16 Nov 2026 18:43:36 +1100
Message-Id: <179481501691.2405628.8067144236288202449.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev
In-Reply-To: <20261115202849.99134-15-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-15-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: yn9h83u98agt1zdy9b6hnsqnrhnm9rap
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12E3D40003
X-HE-Tag: 1794815150-854125
X-HE-Meta: U2FsdGVkX18nusuyTSUQ3pklwyBSQxSE//cEK+YpZZL9cyCBj1cOh8lzKUEFCi9h4DWyWhLfMwKmOU2Q9lzTGioTQJsS/XimeGN7QlXcrDOM7rnuKQymH0DtSym9It32Kq//k1JGRNaV7UPPdp1ajsVFc/vAyH/o0aR31CDpcLpZtz3+FW6f25MBoHuXoaZ2Nj6LqrabkcTAXlkweGqLYSJuq+oIpfBRpLpLIJFwL1xqgbORC23oFgNAsSD2tSxgUTlF2PZzCgdipabhhxLwt1dp1yjKzBjQqTtka6plLUxddrxMVxh7EesjPGJ6u/Jvr835eWA0oUN8t1FCO5VN0IC1Q3HSZh9EPkDki442PTtiw4h70oQCdRPZIWFXNxOnqScgEbOz9QcLQ3rtumLEsftmLfxpO7lA7YCt0E2pfSlOwlOFjZtSh93AK3Ina4BzSXHe7L/Eeip+uJaeM2sJY+vQAOJsPb950B8G+iYA4QOkf8rF8+gEbrZm3LI3sLridzQPpdvvJQnB8s+dyEiu3Vi+0qBe1mUw+dtdQdyJUFUwlX5nIa7CjLC734+7H+QHE623QRxh04k8htj+2s2ZHcJ+1iHvRBgFhAIyHh9dP9I6uuENjfKP6lLaBQF4n7pWw6hGH8Q5X8ySa51VxMn5GclHlpprxBpVymQ9kIrpAuDv5X7N3jnDi59+isSqkIthCobN4I6kZlZR79YxpZralXMqb+yIrLcjjLciI1d5cbEKNgFXXt2qCT4tr9XXx30u5z5gxZnmZf7D1x6VJBcxmp+RwDFYLZnqwXEo8itp1Af90YAOqRsjyovAL9cCRi8hsyDhlUl3Nd5YMhtbLSy06uGESUDoMseqKzu3dGbwakqfvzvggEt/PPhd+Gc9m8Gw4Ecr3tvcAWoadm5O0+AQFlVwHH5+N8NTG+WjvXhfHDZhTsHKhxptTGUIoZqSOP9Q4WKpEQaHjCej2o9SIDO
 TkbagkJT
 xWmADXc5FkOPLf41an0KHw9UxUiJ+kA0wDG0LVm2L+9HwepmMUsbpSqFe/pKs9gBs3UaKXmMvx2S8BrDZyAOZWwEy7Tqe/vW5VCdJbVohO2xnwnS/1W3ZG7hhMCe0c/hFgM2wLtyUObS2skw3iZLOW8fqTs9GypzrPrM1LX9LhoxAGs5kzyDXxuEq6rmg9e0He13xUeJyE65RRAPEzIFZ3Q68Ra8SK5PbNyge5LUgi31xMMSYbsq3YgzvLthWL8iPQj+bP3VyCdfBdxu2mEBanp2pPYmBQ2VSLv/sFOCP1nRkQKQk85OOgv3KjsGeJEVh5C3CvC2qYLm92xlPhGKnGMFBbuVgMGPmmXEQBUaxqQDmeuGnF7LsyuP2V4n7dq3N9EtVV5E0rjZs332YrkSw98M1sJEBgQt5hSAWRrHHImgxhREiPvinN/RoPTjQJZ5ui7ad5StzW4urIPPU0Jh0NKJLisSBfymBqRS/mfkv+dPAzPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sun, 15 Nov 2026 12:28:32 -0800 SJ Park wrote:

> +	case DAMON_FILTER_TYPE_REPORT_MADE:
> +		addr_range.start = pa;
> +		addr_range.end = pa + 1;
> +		matched = damon_report_exist(filter->report_type, &addr_range,
> +				jiffies -
> +				usecs_to_jiffies(ctx->attrs.sample_interval));

Since the window is counted in jiffies and rounded up, how many samples
see a given report depends on HZ.  With the default 5 ms sampling
interval, the window is 2 jiffies at HZ=250, i.e. 8 to 12 ms, so a
report is usually seen by two consecutive samples.  At HZ=1000 the
window is 5 jiffies, but kdamond_usleep() sleeps via
schedule_timeout_idle() there, and samples end up about 6 ms apart, so
a report made right after a sample can fall out of the window before
the next one.

With the queue indexing fixed, user reports submitted every 50 or
250 ms and covering the whole physical address range were counted
about 2.0 times each on an x86_64 guest at HZ=250, and about 0.84
times at HZ=1000.

Is this approximation intended?  If each report is meant to be counted
once, maybe we could keep a per-context report sequence cursor and
check only the reports enqueued since the previous probe run.  A quick
local hack of that counted each report once on both HZ values.  If
reports are rather meant to stay valid for a while, like a user saying
a range is hot, a validity period separate from the sampling interval
might fit better.

Thanks,
Aveline Noir

