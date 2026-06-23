Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAF5CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691826B0088; Tue, 23 Jun 2026 02:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668F46B008A; Tue, 23 Jun 2026 02:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A61D6B008C; Tue, 23 Jun 2026 02:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31BCC6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:24:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 999B3403E8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:24:26 +0000 (UTC)
X-FDA: 84910188132.19.0A05B87
Received: from mail-m82155.xmail.ntesmail.com (mail-m82155.xmail.ntesmail.com [156.224.82.155])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8FA7A80003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:24:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.155 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782195864;
	b=EzyKcroCfEglcY97Zt82h1NvyEK3DrNbX+QlCMm4peXftEvhl7yy24lgu+AixxSXkUvPwF
	F1OaQo1aWY5LuVjQcAKjIIqOAfHSetc5ibqsa/dqyNqL1Gi7VSZJLWf2NubYT2sRWfMWCq
	7kPytFDC38e4hSiYDIpnoQNaR46W+3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782195864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXZ+m0J7mLJlcZTcCfhAFmRBVRmZaP74+AwuC+iH42g=;
	b=k44Ac4k9ADl+KWb7CSZE/QFxsNK7PKbJTKAcThT9eqUxbj8saZ2JJcG1T4cxL1jM+Wluvr
	vmMn7WrWtV/HJA3GbqGwa2XcXX4mH8KdL8Cvrl2yxQAP6ELzixRyUtD6K4ezwJcGO+r6Q7
	XGGqG5Ti8yG8606pbBA2eZv2N24DFQ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.155 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bc5a41bf;
	Tue, 23 Jun 2026 14:24:16 +0800 (GMT+08:00)
Message-ID: <b5b68a98-a947-4135-9ac7-22a9db11d99f@easystack.cn>
Date: Tue, 23 Jun 2026 14:24:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/4] tools/mm: add page_owner_filter userspace tool
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260618035750.3724613-4-zhen.ni@easystack.cn>
 <20260618072103.92397-1-lance.yang@linux.dev>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260618072103.92397-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ef326a2fc0229kunm09b7638324d840
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZH0lDVhhLGkxNT0JJGU4ZSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: 8FA7A80003
X-Stat-Signature: zzhekntmxdf84fdjuoeir1q1auragnf6
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782195862-631347
X-HE-Meta: U2FsdGVkX18Cg5QuFZheLaqGs6ZZrXr8wJwj5sBznpyCVYIkks0jdC+wPq5r0dtF0l3lXl2YI5LqFozTW6HlEo2YCXNnqooyITa3W79L6+M8iGIiyQ+aMMZvDe7iTApZCuD+zkw8bBiFiPxVc2Xs7hirHP+VD+SVu4eBe39ckpBvMNKdJK80x+6N/0fVpkFRfLcBSMe1qqwSpIEsRBO1sWjlsEWi78ZfG4qMbFg81Xy1U0/5f2XM6ncVgGC+LQwdtCJiBwCuXUeFabfX+X5Op1Y8DkzQiF70SKkg3/qDqcAfADbJdX/LsRKTEnO+o658nBWVbCo7bmtUbNPvbwEwBV1vwZHiGbfxi7FJRTZaUGwpYYJRUhI1RR99yQWuIVZr8XBXFPmm/Ga0ccLLJKrE/qrfnFyeKfVBkc5BPen8FcCQ19ShVdayRtV8AyzK1H/KUFNeAzgqVEted/nRcT4o94y4Wb1o+qtTjvcO1FshnyMcUWEkw7wMrGRrHeweZ4wFKFOGmoDZjbZdb+W+8oS/Vdl5kE5V5dpbKiQtjG605H/qyTFRIKHUbwFflW65TAGQ0JNOy39aQE/ScfioAL2k7EJXiVZJHIVR2mavfGC8+UWRoEcazd/L2NqmhPS9sVkC6B0R+HEfO9rZnSMQrmVtwi04bLqEB8sfC2fs5eSZJcE/ctnTnxHkltvkSA7ksMJstvFVj9Brm9i/tDVgcuTZSJJ+Gz2lyvlPplYvcr/2wyXw8cAT2FNrn1iD+Fts2Gf0Kp6HAonYxiXmKBmYShDr4nVlqP0P5Xf0R4jb6VMvecLJMzh730W8NeSAIYzuxlVIpswtqRYbJf9FPzhqtgcq5uT+jV8hPAfwfVP7G5Pvl0Ble32i/cwiUs8ffgVF6gtG6Kys/21A/UuiejtWCk4kFlMIHfyrlKHqkAZyHNa/srNkPgIsROeKBytXVbGfWVDDwykF7c7hD32PT0TH7b7
 zQZkCt1m
 xtWOwWmp2GOzrUl0/TI1hNgR6rVSMWRkuPRLJ/XEdKpNU1c/EAT4m+QFYDU7lZJPSrPv2OEsChWs5yW8umS1MxN9nxN9TDZMBu8pxMCOqWutjyKtdLvmMKeIcqJIRDp6hTD+Sljzjom4B0KOImsuZcDeGi+SSlcqOfp+Cdv6sCbkWRQyi963M+adig44kgqR8YzSjuHuAPRqRQsjB+4t0SVZgnFBmmdYRFYt2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/18 15:21, Lance Yang 写道:
> 
> On Thu, Jun 18, 2026 at 11:57:49AM +0800, Zhen Ni wrote:
> [...]
>> +	/* Read and display filtered output */
>> +	ret = 0;
>> +	while ((ret = read(fd, buf, sizeof(buf))) > 0) {
>> +		size_t written = fwrite(buf, 1, ret, output);
>> +
>> +		if (written != (size_t)ret) {
>> +			if (errno == EPIPE) {
> 
> Hmm ... does this work without handling SIGPIPE first?
> 
> With something like:
> 
> $ ./page_owner_filter -m handle | head
> 
> The writer can be killed by SIGPIPE before fwrite() returns EPIPE no?
> so this branch would usually not be reached ...
> 
>> +				/* Pipe closed, treat as success */
>> +				ret = 0;
>> +				goto out;
>> +			}
>> +			perror("write output");
>> +			ret = -1;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (ret < 0) {
>> +		perror("read page_owner");
>> +		goto out;
>> +	}
>> +
>> +	if (fflush(output)) {
> 
> fflush() can also be where the broken pipe is reported, but still treats
> EPIPE as an error ...
> 
> Shouldn't we ignore/handle SIGPIPE and treat EPIPE from both fwrite()
> and fflush() as succes?
> 
> Cheers, Lance
> 
>> +		perror("flush output");
>> +		ret = -1;
>> +	}
>> +
>> +out:
>> +	close(fd);
>> +	if (output != stdout)
>> +		fclose(output);
>> +	return ret < 0 ? 1 : 0;
>> +}
>> -- 
>> 2.20.1
>>
>>
> 
> 

Thanks for the review.

The SIGPIPE handling was indeed incomplete. Without ignoring SIGPIPE first,
the process gets killed before fwrite() or fflush() can return EPIPE, so 
that
error branch would never be reached.

I've fixed this in v11 by:
1. Adding signal(SIGPIPE, SIG_IGN) at the start of main()
2. Handling EPIPE from both fwrite() and fflush() as success

The fix ensures that when the output pipe is closed (e.g., `| head`), 
the program
exits cleanly instead of being terminated by SIGPIPE.

Thanks,
Zhen


