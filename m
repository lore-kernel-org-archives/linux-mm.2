Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B157CF58C9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02E96B0024; Wed, 19 Nov 2025 13:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2F06B00BC; Wed, 19 Nov 2025 13:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA24A6B00BD; Wed, 19 Nov 2025 13:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3CC86B0024
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF6AA13B491
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:24:29 +0000 (UTC)
X-FDA: 84128181858.24.A32F5E8
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id AEB3A140008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:24:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Mesl2tdk;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763576667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXp2uUfyAn7qQSV84bcf4nMWFAwyWFqJON+TttJbAcU=;
	b=I2YAJIDRd/119oIacnDb+8mLbSZo1jcwJLeAgPN2XHyIhbP+d9Hp2QrYUrLKv67IzvQpC/
	5vUEA2FLsMBgIE9i9914TnQxRTkEkDuDbwOP2J2Eckb+yDenWRcMubBBz+Rvw/SP94gWrM
	qp5GLa2E9H3G6VY1zusvb3T5OpeZYeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763576667; a=rsa-sha256;
	cv=none;
	b=O6GwsAjFeQCaB3S0nD10Lew40vsRn6FdmxU+gSBH5BChWrxiVtk5eZBI8B/1N6nhguWkRS
	LtlQc3VletN5kse8rjJzprtCEDgGC7urHIKTSGx6gg1TRQ+l1wTUyM4m75ZT0p+ZmktpBu
	t8BQ/XxVj4W4U2gkCKY+g7TtG9gh0T0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Mesl2tdk;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so2776063a12.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763576666; x=1764181466; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXp2uUfyAn7qQSV84bcf4nMWFAwyWFqJON+TttJbAcU=;
        b=Mesl2tdktkTNx/Up3yFYDV4DLape4/Dty5dICfyTxbt40C0XCdSdRhzrFHIEi2e32l
         I6P9+X2k6Ev0Tmego/BLzF5Sn1oiwE+m8Hu95Ep7cU2v9aXcNLW9/jcum7c2PtMM+dAR
         TYHNExjHqZ2f9hEd4Dvwp+CJi96CRtOrSqoECr6CCU6fJ+wp5ZcDSGLPVv+8qA6i4BVe
         HhRqreXJLvVRWQHyAFB1unqKPLKxasXm25/KSHzmlMi5ArFeY+J++c6i3PfLaEOdr46i
         u4+LXc/uE6zV1o6tKC56xenpZWtEw4oiAIgHAN/7KSjKinhn43peI0H4DkiE8B3SxlDP
         9bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763576666; x=1764181466;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wXp2uUfyAn7qQSV84bcf4nMWFAwyWFqJON+TttJbAcU=;
        b=ssUezXwsjlV8I+xc7au0ZLYigEqU83oRH3sJOTd5pmryACfrPusBEaN/6/Oxy4Q7I8
         FF0HFX954yzRillN0Z61b6IZMkbaTK5POjfpXfG3sfoFPrDfxc6qgG4qtBzNzbHSuRc7
         3DYIINlK4tx/2xmBV1d4OYFN2sv89qRnOVUaR1t8VVAgR6aMMD2i8xMl9bXlba7tIj6Q
         CQ//W6GUdHcabAv+IidowmtVxKq2ANPmfiZcbGM/UVHhDdSy4BGXn0XIIJKJxmqx5/Am
         zdoanBZR4S7VdTvuSgVTK1T9bSFEOG5OwMq+ss5ku+RonPCkVZGf0TCoknghMPvZvMR+
         5KbA==
X-Forwarded-Encrypted: i=1; AJvYcCVTXI8Q1ND7Hlb8iqTnUllTmSof+tTOYXhceZsehk1Ny64y/CEZKJMDzkk4BM/V62ZaVQashegSfw==@kvack.org
X-Gm-Message-State: AOJu0YxCVa+Vj9kwxjuuMs/ng6YUbDGBc3k0oftnMf2MmS0/hXsQqejP
	GJJKNFmldy+yzI0Euu9JWD3ml25hvTib5MupX1ARLA8LXJqu98ZI4va0iB0yOoVJCGs=
X-Gm-Gg: ASbGncttEOd1Vfd9r8W/oMtURojln+BXqy1QW6fMChzT+nNKJ8wXWJ1wbAa7G4uFhfW
	rRAP6WbXG5D5md1qhStqHP8Dfj10wzaH5dE7TP/7qykx81A/CxbwI2Fj79yuShKDyu5GieH0B43
	q0CIuf3h7Ibl+XaYun46DLApa/L0D6wIVyUOa0zNXIiiW6Qc/tqiCR8W1p4zXTzIJ77y4Mk7JXW
	+YtjdgxqQ8Ua0qZR9WSMPVX+wOAunaknanrHCV99rxYgDsvyzHzouZSA0j/T4nh0IdBlyUkLjMM
	RmzEWktnAxjng0I26BW6YiYHWTYuwe/6+QcZJ6p1282zjLKAEWiBGeoM+nDUP7ZQ0P03Ou6laWi
	guOf4cnQia0DiroDmWZwbP0LGP3X56EoP7ktiord+fXt3YvGAU7jKnThPoS3aN+buTuouvZjsuQ
	3oASxsB7lpdtlJWhKIM/1pQGgt0cT0eX0=
X-Google-Smtp-Source: AGHT+IHFWcpqhe+aEp30Ksls0LghzQFo1sGYaD1WHh6eJAE08Lx/+/aqM6jp4/gMRRi4U1LtQQLFuQ==
X-Received: by 2002:a05:6402:5247:b0:643:129f:9d8e with SMTP id 4fb4d7f45d1cf-645363e41d7mr312140a12.8.1763576665944;
        Wed, 19 Nov 2025 10:24:25 -0800 (PST)
Received: from [10.101.2.140] ([93.122.165.106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363b66e5sm169342a12.14.2025.11.19.10.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 10:24:25 -0800 (PST)
Message-ID: <b0102b82-9ae8-4e01-ba27-44b78b710fca@linaro.org>
Date: Wed, 19 Nov 2025 20:24:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, linux-arch@vger.kernel.org,
 tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119131534.392277e3@gandalf.local.home>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <20251119131534.392277e3@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEB3A140008
X-Stat-Signature: ga3s4tn6btntxw1ti4m84em8qcy651sx
X-Rspam-User: 
X-HE-Tag: 1763576667-163336
X-HE-Meta: U2FsdGVkX1/O3jx+KMpeOg9TBGKpoguACkauTwU/zylnZE2TikbrmK5fv0PwZlPaHa1WpPfzhhzVhYYZf7+jixuczGpsGUHEBoVVuYYv0bwEVgWSB7htm9XWCjx7F1O1O0A/PD3A6CwZ6S2bA4U3JZxt4c8L2Cl3YwZ9UfVswepu4BGJP3WmUWsE8EbZWt8/eX1qJuR9sMFPSDnOHzJpGc8JpMiXAGl8Cxlwf+7JcdX9vYIwG6/CN642fB1j7kVyrUEdc9T/xQ/a9yyeeB3sU+HKwyK60NyopUaTNcMCsScZMSwcd5jIWEIMUdgsueJobKCBUVZmRQwVsaFV3VKeOu9pxcxy50bkbIz1En+hGMz/5MXQ+P59nwvk/dh4XcSifT+g1/7lJjB7Qjm1scjsWbQlgLQh2Mku8L+m64b0MMnJnrOTC8qG0pxaC/bYb2a7f/1AFaHwSgC/PR6USNj8+Z5WfB4nOSmDg+bce9J3hATUv37pzwVcr3Ts6MdbJXnqwGGLg2zenAsZ4ZOpnnJc/RbfIRt+gIoyoqYFKOA2eIEaU1GQHhg9FBZ5CYk7NofX4fXks/9bBdj97rVVx7Gh0F2wYI+XjRw2a44xGXLBB0FZleFCK64WnhlA0FXklqGeJWi7uVXVrm+A0OzCJLrV5zqiFtU7OvSezy8rPCuru0y3Slxb2yv6j4H1G9p3kLbDhB21Glxj3+Lp0VGRtUW6ZimtbTEdcrANnE9NKKz7K3fE7COpDJ9oJS7H1kDvHt7kYxppD4p2HZfUjDU0or617iKgFAKnQgduJLpyJirptM4g5PqC40NYCJD9zsfewaet+iSNpCPIeelKApH0BDRTvp9bJzwxqUaq8v/kIWs7rnMKbxwDG/YcEJAzW8dtpL1NJUaruYkEGV1nCoBpqhAYfjR1kqPng3CxRf4CZGyDUfpdWywGrJg32Wx3Ew7i+Nils+yhr0Pth9oUC1DS945
 ANvkjZKJ
 oX5PalnVNXCXN+NLFiGZn4o1eZ25/R7/GN1kusdfdzksMH4JXoPzAf08S0CezFAHPVKqqxIVuIoP1VBwmcxWdSu4JmHe21Xa8xNFp9oxnDVwxvkQXF7fd27Rzu4atNYIniHX0jWmIfg0mK6UTctF5xll+RcAOROLzvHpigbdb2VppdOUQFnMxUrtI/qksT7dqSZtxk6ou6Hrl8V0tLctMN7A+aa3v30EUK2VNQc8pTiVcfYRWkT6SM5kzAVXF46rVbVBIBBL5rv6EIoOoN2gsaoFEN2miIYfOx17U16+iTl2CQnBcN+gUqBFtU2rgh8hecMJabDg86pc0Vc1ADTaThzO4A/M6H/4c37DKiwuOqzHQ1G2HXpySp9uZkkrSK3SZ5RXHd9T4j2h7Frj5ZDdwG1Uqv0qnVlibYomAZhmCPfUjpD4e1tLSceEh1Z82ytXhtP1hjHRCRUoVrVmG1cVDvAzPvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Steven,

On 11/19/25 20:15, Steven Rostedt wrote:
> On Wed, 19 Nov 2025 17:44:01 +0200
> Eugen Hristev <eugen.hristev@linaro.org> wrote:
> 
>> Once you have all the files simply use `cat` to put them all together,
>> in the order of the indexes.
>> For my kernel config and setup, here is my cat command : (you can use a script
>> or something, I haven't done that so far):
> 
> Interesting.  Hmm, it seems this could be used with the persistent ring
> buffer code as well. But if the firmware does not keep the memory around on
> reboot (where the buffer would be reloaded), you could mark the persistent
> ring buffer's memory to be inspected.

I was kinda hoping I could get a chance to talk to you about this.

I managed to mark the trace buffer for inspection. By using the cmd line
argument to have it preallocated, it was very easy to just mark it for
inspection and dump it on a crash, as a dedicated meminspect region.

> 
> The persistent ring buffer creates a single allocation to hold all per-cpu
> memory in a single region. That is, because on a crash and reboot, it
> expects that memory to be at the same location and does a verification
> check to see if it contains a valid buffer. If it does, it will recreate it
> for view in the instance directory of choice.
> 
> Now if this same range is marked for inspection, you could then download
> the entire contents of the persistent ring buffer after a crash. It would
> be trivial to update trace-cmd's restore functionality to rebuild a
> trace.dat file from it. It would require saving the event formats of the
> running kernel before the crash, but that's not hard to do.

The problem is that all the meta-data is not allocated inside the
preallocated buffer. The meta-data is kmalloced all around the code. I
mean the structs that hold the information on what's in the buffer. You
know what I mean.
And all these kmalloced things, turn out to be in order of hundreds just
on a kernel boot, which I tested. This is not feasible for the
meminspect table, as it would get overcrowded very easily.
I thought of perhaps trying to kmalloc all of them in a dedicated cache,
but I haven't progressed on that. Another idea would be to try to
recreate the meta, but I have not found a way to do it yet.>
> That is, by using the persistent ring buffer code with the meminspect, if
> the firmware doesn't save the memory across reboots but allows you to dump
> it to disk, you can enable tracing within the persistent ring buffer, on
> crash, extract the buffer, and then use trace-cmd to rebuild a trace.dat
> file that you can now inspect, and see the trace that lead up to the crash.
I used 'crash' tool with trace plugin and I am able to see all the trace
contents, but, with the limitation above. (To achieve this, I dumped a
huge area to include it, so , not feasible for my goal )

> 
> Now I don't have any hardware that uses this feature (not that I know of),
> but if others find this useful, I would most definitely help them implement
> it.

We could have some drivers pass the inspection table and then store it
in ramoops e.g., tapping into pstore. This idea has been going around,
but I have not had the chance to write a pstore thing yet.

So , I was stuck, and I was hoping to talk to you, either by email or
maybe at Plumbers in Tokyo where I have a talk about meminspect.

Thanks for looking into it,
Eugen

> 
> -- Steve


