Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E17ECCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B930F8E000D; Mon, 10 Nov 2025 09:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A7B8E000B; Mon, 10 Nov 2025 09:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80888E000D; Mon, 10 Nov 2025 09:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944858E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:55:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 265B71A0142
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:55:01 +0000 (UTC)
X-FDA: 84094994802.26.529CE70
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1590D20009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:54:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fSFR8jqT;
	spf=pass (imf03.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762786499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtT4O7BewVOdeU11dvM5Ug5fQnG1uIMIXCN1qCElv4g=;
	b=07j3C3u1HMSTXZ7MlsiMt14ApMsjME9d+Hax96959ySGNo/pJ6JXAnvR2Q4dIFshId/qa+
	sp9eg4niKc04eFzuyKCElmyWeVV5zXrewFFI/dnZo7oid4EsgeolKoSv+hWytQieZ4L97I
	6F+9g+YV11JDLX1xrS502EmqZzHkllE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fSFR8jqT;
	spf=pass (imf03.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762786499; a=rsa-sha256;
	cv=none;
	b=b5jodVi8b99xHkhdJqhOYAUAcHV7ZhNEeJvjmq+gWPV2WvdnDT7dF0MiYpvMKym+EmAMt6
	dNdvroTfjZtDlCw6L/GzyIIfWJqrHUpOlkwhRTLfHUlsTivRLWQkrVPwpgxvrdmllwy409
	ak7PTlD3rZEvZ6gN4gIBP+yFxoW3fd4=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b3377aaf2so865659f8f.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762786497; x=1763391297; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UtT4O7BewVOdeU11dvM5Ug5fQnG1uIMIXCN1qCElv4g=;
        b=fSFR8jqT67TySHwqTLSyObmattiPC4k0pIdVe86VohyuECoV1hYqkvwpB9S1IWfORr
         Ar4kr67iFttyJ1tiwVNzffeMTKczpiUGnTwJjGyNXkjmabLowvouFsentvcL9HO2BxgS
         jsZyzm033W3zuK4FsN+7GvFq6T4InEUJ7wDiSrSVWT6dHCh2t7dBApnbI2LtZg9aV0HD
         w5JIis13Cd26Mt1Jt4kB+MQRzhUzMQGQYZLe1Iml29WnoybxhMWvDmIh7xVB15xVUU8M
         dExhQui5XtuO9t2jzFl1LB8h6hD64LtqznO/9PGDPMS/xs09YT704rBdyzMV5hehDZux
         cQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762786497; x=1763391297;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UtT4O7BewVOdeU11dvM5Ug5fQnG1uIMIXCN1qCElv4g=;
        b=AmxRDxJSPbI4pb3Lp9RJqQpi2tw6Ly55MgMYZmPTQlDUMcAaFQYsO+oaF2u2SGL8dO
         Dc0jGRvVRMRjgpHl3ZOwnRQbLTObHbfimZvoHKHle3TAQRldKqckzKX2f2/qNQK25xcJ
         t9VDQFtXw9802Dxm9mhN4m8Nhpf9UwRJGwWNByd3T+fnHBzdTa5uju3d9GbFfR4iAnqh
         +l8SyJ9koeMPCpUhPJ9bfRnhv9N6Lcgg+Hdzx5RPBPdgpkzxHwKezNvzeXWf043AWdxY
         vNI4a2fwp3lvv4Gj/qxIByp123UHpOO8AAP5KRJwDyj2dDuAjzm55jpHMVSiVY7X153n
         daew==
X-Forwarded-Encrypted: i=1; AJvYcCUxP8zQL3HqPOEvZ4EymVvMy4/wuidXSkCXvBn1Pq9WLRE2v1/nSDpLwMvknQMmLbeb/I4sr9wPIQ==@kvack.org
X-Gm-Message-State: AOJu0Yw50HYLCMUXb8aTU0iSFm5oX9XEXm9Sww3NUmSZB9UXJ0HML4Ck
	xqa5ilpdk/u3/ecFglADrwytCi8MGrDDTdrYDttusy9srtJNBPx9mDiM
X-Gm-Gg: ASbGnct5qungQqwzJUJjyHNWzgTfbzSVhzBT9GYZsGW5ZHDW1YRHDsCRvAkbOzh7OuJ
	W5+g1v7mHPyddPDb3kqYTjl7FXJm/RzaGMsv/YT1zWgBQvCkJ2Vl9AOyXZxiY3UNhTu8CS787nH
	r53YiBPAaEQzGjes707w9TDyTpWVuXe+QETx6KmMoLiSrsZ1EJepydvPddEKBYLAODusWFiCxsL
	Pf/+4O0dTsJJIDDoqIAzZ1Y6bUV0XC9pcA0Aq9bic+I6dJUvSHeS+s6bFdEtaUtypGP+TtVmvTU
	m/qWtcBCo+Qd3dGLZGTV1MHGzQ0tUqLT4q3uLwojbFwI6kYXg8UoE3akine+twoXcuzPAx874Ux
	87ivedqJkkta3lkUsoyqZT50Ii4aDCmUgXLM/Ae1tbjrEa3oIbokZ3amEKY325OiWU9ojmpcAal
	3sT5Hfyh/yJM7bdvt6kHl6ycqIOLK9uIVSSdvjrOKqVZd5U11be3z6oATv22PKeRtNiDB0/VcoH
	vHcIy8Rxyq07iwD6WAvNmsGPCCnJVwzUJA3HnKnoyjTPn6o8w==
X-Google-Smtp-Source: AGHT+IFgYtF0Zf+P6CHYXSeBIt6XkOznTNcFaXqJDPZp+x8TaTAwDPOPyk8sB9F+rWpsk9Zy+d+pvA==
X-Received: by 2002:a05:6000:2302:b0:429:c4bb:fbc4 with SMTP id ffacd0b85a97d-42b2dc24800mr7139287f8f.25.1762786497116;
        Mon, 10 Nov 2025 06:54:57 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b316775f2sm12777750f8f.16.2025.11.10.06.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 06:54:56 -0800 (PST)
Message-ID: <69884a4d-60cb-4a66-a225-38d3a17712c6@gmail.com>
Date: Mon, 10 Nov 2025 15:54:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <9b622374-778a-4459-aca9-4eb406a58516@gmail.com>
 <aRHwv3XzI4XHcLPP@casper.infradead.org>
 <2e6153c9-1729-463a-86b5-0973b3f56ea6@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <2e6153c9-1729-463a-86b5-0973b3f56ea6@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1590D20009
X-Stat-Signature: izmwspppwicshf4pg1w3sqd7i7yrfh1s
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762786498-346836
X-HE-Meta: U2FsdGVkX1+pBO1IiFJAgt/7/F+FU636CF2fx0NsuFW+kSDRbL9V1VO8AZwXEE001H9u87O/koZhqVI4mM9t9/ciiy5dcDfhuAgKjfBJoy3i2Dgt5SSC4QppGtMLbvwBdYUmRoOy8TOULnYd6AmYPbs8yYtOAddC/BdHMNDeUOOw+wjC3JpTE9hOLSqRWAFPgobLhb//67w8Bf1HKNUMPc8/YmE/N1ZNmvIOwXdpkUDsTmn+iw+/5Nuh0y2jcCLCvdKQCg9kCE9od+qzpNFq30YH5fTgPQ5htQTRudM/g5Y6GynR9Mdn4rn3y/KjQy2sVmh3YHvFAhh6mo9ccdstZ6vz9Gp62UVGzxmvF6cZCQFwYV28HOWE2/4n1PC/DkCdGGf56z5gaBscrA8aJuKEbiPZgqaAAyJBy2crkO2DyJ2eoL4ZBGXgG2zMj1yeT9M6mg/rZ8qqd4MHTxWeQHBf+dvcficQLFz0iYZXvx92TK2hNGbk0hb+8fqtsphFTFmHCVlSsZOIGJNpyiFIBs+Rynw+2Al6oA/uDLtJT9jgShYdK1r35CY1PbR1LVfmL+c+NflFIgxb6vKNKr0WUcj2LPEVA/P9mgphzAWz145T5e1LMplNHyOuyrJ8KbS4QnWlUeOySgviMWGaSLYz5/obMPxrVL2vVEIORf5h5t3q7RddcYtlLBj0ougpnJ9fInZte/FypaW0/OGZqWa3E8VDQovF4KWzhnc9vMmI5bx5OOaOwSjPGU2EPpWZlGS7gOROFcuKzWKUx5nEqs5cDqg64vmXeDd1q1aAy9mNu8e5cbBVcZrsGO7/G+d/6am5G+OqpKSc11gZpPsuzIehNNeM5IfXMh1xTLiThy5C0G3EsaYiL3TLUR4bOFFOgo8KWfNOljM0A5mZrUY6s/npW1gCjoYaSZnOyKuMgUde2EswMbeIkc9Do1JsFJUc0UsmI5Lym3vZF+ssvtUZB9E0Fz4
 hwOvefFK
 sdctJ7iU5HOutTswLgw+0US3DfuIDFYWThL+yNi55x9KGdsehSdYr56M1zXKJ5DmmARzIQXpKSLD8BpWe2KSfkOLGoWQLZ05nOHdozHxaYaJirHnHKsA9DNt9xn/LIKIVgathMnfg9t26d3leweBu4g4Df1lR8dfXmCZK+psOMgEsYDiKEcrSnJmnn0gZKNfT/B6pbWcJjeJGgVQ/tOfACgjmS7tFo6C4a6v9TesvqU/Xhsbeq/ZBmet6FAUZUKtElXVNK9Zyye3MkHhfPaZbmxBG+NkKD+7V9p7Cm4VXtZ88aEnu3D5bra1xM+uvX33X7Xt3HvDphoLcqJI79OWHps9PTJNSgaD2zDGZ9XjBFo734f/KbF7iYT3moX2OlskI4qjBRQhxHEb3niGcSXLqcChdzwuPgt5VPccyDFEJytoAi4I4JbGX56KvZMnqfK2JBx4SzVFWRk5ls2gf3on9ws2g0a3XtdUQZvOvBQew9ss53XoTlXYPcIxCLuPRlS4s6F0tVoJVp3MbTKvnvbhg9P1Gvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 15:05, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 02:03:43PM +0000, Matthew Wilcox wrote:
>> On Mon, Nov 10, 2025 at 03:00:32PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 10.11.25 14:47, Matthew Wilcox wrote:
>>>> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>>>>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>>>>> text sections), the pages may still be dirty from recent writes. The
>>>>
>>>> That explanation derails my brain entirely.  Text isn't writable!  How
>>>> can the pages be dirty and file-backed text?
>>>
>>> Files are writable :)
>>
>> Well, if you're root ...
>>
>> -rwxr-xr-x 1 root root 158632 Jun  4 11:14 /bin/ls
>>
> 
> gcc foo.c -o foo && ./foo
> 
> Is more the issue I think

Yeah, that's my understanding as well. I guess stuff like 
package/container updates might similarly trigger it.

