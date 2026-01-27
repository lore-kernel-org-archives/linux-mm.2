Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93291D2FEDE
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED246B0005; Tue, 27 Jan 2026 15:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B646B0089; Tue, 27 Jan 2026 15:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6F56B008A; Tue, 27 Jan 2026 15:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 765996B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:21:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 214FE8B544
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:21:11 +0000 (UTC)
X-FDA: 84378863142.26.D4AB9D3
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id D8BA41A000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:21:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dq+jIiFi;
	spf=pass (imf19.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769545269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUP+BUUh/kupPGgyR6A9Wup/rhNgbndAT0lTSWXG59k=;
	b=PSZWohLFojByhkSRfs9/XkdWyDmDT7NiKO/ITABxiss7KP/aQ7VvjbkckvsYzb9pdHLpgj
	/nUJhaTubF4noL8USwnlLRMU5iCncwR0wtOAei/7liMjC94/w0CJPzn92xNl22rYICaUM3
	QFpPjvdYEw3sLgTm6qfHSu7WK2uyaHQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dq+jIiFi;
	spf=pass (imf19.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769545269; a=rsa-sha256;
	cv=none;
	b=a5W9NK8gD1sP/Mf+AUZ/gA7W5TVthcuZ0cT9+oq8L/GSU0NIRBdi4bj1gCriBZg8sc+wsC
	ObT6Ar29+uSgGxi4dYrvb6gPrDoVIIe3SYgH+SRfU8Y1gKxndLMPrHw+kjfKREKpfkfcI7
	tMgBhPBLUIcM7SJzm9VsiCFnKy9t6EY=
Message-ID: <9a2c5f29-b45c-4ff3-a8f4-51d207a82d38@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769545266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUP+BUUh/kupPGgyR6A9Wup/rhNgbndAT0lTSWXG59k=;
	b=Dq+jIiFiFSLuZJ96MCgtUz37FFhowjkA6JRgG9tjp1VHCsmGbRbyaX2Sof35A0H7AwXK5n
	a+Ku4rb5MSPNs1Gm+aKO9/eTWRKzDUqsnnOQXwB3exWZxwJt5+f+vDK2gKhcpi3iEoCvmm
	k3OP4uXSsZ2Z1MADJO8Uq0laIp7aoFc=
Date: Tue, 27 Jan 2026 12:21:03 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 08/17] mm: introduce bpf_oom_kill_process()
 bpf kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>,
 Matt Bobrowski <mattbobrowski@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>,
 bpf@vger.kernel.org
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-9-roman.gushchin@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20260127024421.494929-9-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rotrns1pdiyew9t9zpezw8rcor4ekr7f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8BA41A000A
X-HE-Tag: 1769545268-218935
X-HE-Meta: U2FsdGVkX183Y+GZHSv38JLo16FXmdf33MqnCOuB8kbPwDvRmyFMIZfT3YqNVS941o5esOqcUDeDj+icF6v6/huFviWl9u7ga0DT8vYDizk5PHFj0Da1/yhfTxdR0gQ1YkPjRRBoSyPd0gD4LFT5hCkMbtQgJyfH4Wc5b3MPlWw1JFzzSTFIDJSmA/YHBjSCNb1pIaQtEEKiHikSy09Y04RRfn5DHtJf68/aercZ0TIXisM4sdzFLQvPGO9kCBXxUcPXCNSDXIMsjpcemS+dxotiUI9vY5zo9aGDkHFUIFjdyOX5rDVxv64K+B4qnlT21sk2SkZzj10eBUjcORS+Z6lA7HhqJWr0nW0x76B7W8WmNNL+ch/dFR2t0Xqtte5zvOYcapeZ0r5VRFYTum+Tq4XlHWQd5/RObAQQ5drJ8ZK2z1RDyuTEtf59Jf7yFIoMhi/nYwAcLr7OrlyLDAp18jIuAfVQ4duXRciPN0fwGNrAWeF0YDlIrh5nfo1C89TLEiVCiIAtk9zn9LgKkFkJ6K0hVPuFLsNXoVUQ4hEGPFQPD8D7/oG62+D1mkg+wO0wPXNQ5YNlTJ2yfEQHOD8JHidt/cH4kOFMKHsKEdiWz2gZxKpvCiK3Pfe0+IxwC9y0n1teubrP1LdWiUDtySaIfy03KXg2nIVrIJmypzJDZb4IUSLoJTCz0hPc4XLPAr3rZEwpQOsVedG1ZgvgTI6D2sAkVOPtiuSZVHgHNDvKiDqtn8WToBf1TDfYg8xhztVUwfeQHjlY4idz4nUOLUK9FLfGNj0Lpxss7mBT7b6RWUj1+/TQGUIPMqkgSv1mLxhj3AiNFVa8Zetj8sjA3A3SpmKuyFRu1htg+ORsdlChXLMqfSk+2eA8d7n54k9x9nHRVJoNirnJa/OAg3NvfPAccfDhhfIlCubopB0xek5X84lBv7LACG6Z1zbu5a5ke+0M/66okYRY/y04jr6naXK
 qcEJiIvT
 DjGKvtM1ZMOmcvSinD2tYTa4xucEuqFiKA10LXop6/wAX3qj0ERAGLbZcBKsKxjhZWgB0TC/40LoOv78mPEtMome+Bj/wKL9d3yfz4zZe+lA8OmaChV7gn6aUx7BMguwsFO7++9QWJF2t4fwDXzz7EEJpNlXW8aA2C1jW09HH1h870p7HqQp0dfpCGVOAdPdr1vukkA4JLymtCeRB1fHP/gzAwHurWOgnqOQr4x0Q4UKoGbEXdNoXFBRj1TOswaSlTwc7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 6:44 PM, Roman Gushchin wrote:
> +static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)

The filter callback is registered for BPF_PROG_TYPE_STRUCT_OPS. It is 
checking if a kfunc_id is allowed for other struct_ops progs also, e.g. 
the bpf-tcp-cc struct_ops progs.


> +{
> +	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
> +	    prog->aux->attach_btf_id != bpf_oom_ops_ids[0])
> +		return -EACCES;

The 'return -EACCES' should be the cause of the "calling kernel function 
XXX is not allowed" error reported by the CI. Take a look at 
btf_kfunc_is_allowed().

Take a look at bpf_qdisc_kfunc_filter(). I suspect it should be 
something like this, untested:

         if (btf_id_set8_contains(&bpf_oom_kfuncs, kfunc_id) &&
	    prog->aux->st_ops != &bpf_oom_bpf_ops)
                 return -EACCES;

         return 0;

> +
> +static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
> +	.owner          = THIS_MODULE,
> +	.set            = &bpf_oom_kfuncs,
> +	.filter         = bpf_oom_kfunc_filter,
> +};
> +
> +static int __init bpf_oom_init(void)
> +{
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> +					&bpf_oom_kfunc_set);


