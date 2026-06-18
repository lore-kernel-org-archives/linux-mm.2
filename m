Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C1CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 07:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EE46B0088; Thu, 18 Jun 2026 03:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920586B008A; Thu, 18 Jun 2026 03:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837566B008C; Thu, 18 Jun 2026 03:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4386B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:21:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D47F21C2DAD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:21:16 +0000 (UTC)
X-FDA: 84892187352.30.3C3111B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E85520002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:21:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HySLrnYz;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781767275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtlEMfVTH63Oa0whvIFuEXdWiCj3k8WGdr0XfDgRc4E=;
	b=BGZiL+WiptC9gPRj8nP4CkXc/OOV6dbbvQ72Qc8EIYMqDAGIIlkkrl/xbMylo6rbF/EY5t
	8e+6oQhCjyxhf2PjQb8rbao3x++twuqb/L4SnxJ16767eueDPoFIKAv02dThZHaggSaqOB
	7UhXcml2Cq1s3+P10EOMboZA3OVpjkM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HySLrnYz;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781767275;
	b=T+bgYFLfgHYkM/QIekXnwnPBOCMlwqovXKG/+WLvnYYuofeV1eA2xYie5RcvuLsZqHAQtn
	uoL6CIDl/2qzB0QtF3IVb0kiBSllqX6UFO7th7eZpowNzLMIEXe7k88P9C097fNtbKLkjL
	W1vsRWKfhwauv66tw7wR3iZ8QS3jEHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781767271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtlEMfVTH63Oa0whvIFuEXdWiCj3k8WGdr0XfDgRc4E=;
	b=HySLrnYzumRMbNCiHXgZaMm3OwZfCXXP0goIvaNtrjiv774vw6wDkQWW4+fesHYnDoI4lj
	I23WYJcgTdhtL6qSuIc+TOeVWXkAFWSqfXmy7rU34K5BnOaH11fqhnHsSNee2+AHljjXev
	B+iBecDkfQDra1ji3AzrFspfDEiOl2A=
From: Lance Yang <lance.yang@linux.dev>
To: zhen.ni@easystack.cn
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v10 3/4] tools/mm: add page_owner_filter userspace tool
Date: Thu, 18 Jun 2026 15:21:03 +0800
Message-Id: <20260618072103.92397-1-lance.yang@linux.dev>
In-Reply-To: <20260618035750.3724613-4-zhen.ni@easystack.cn>
References: <20260618035750.3724613-4-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E85520002
X-Stat-Signature: q3qc9ugomh1n3efo5rdjih7hi9yjpteg
X-Rspam-User: 
X-HE-Tag: 1781767273-240356
X-HE-Meta: U2FsdGVkX19Gycv2InwBBvhs424jZdbXl+IzloCwA0H6egc+peh/saTBxwNUDHR21PIjumhodcg4qI6b3ij8iR499P25vFvhB6O8VZJ4OpPVW58diIIWw0gfTj7R5il4qAdfXCZt2LiWMVY5JiBK9Shgk5opy2R3FvimLgURK7+kkriEfIyhCUZV6m3ZY8JhVJJsk5NpGSeHyxzRPfX8i+PZ2hEwhlMd5Gnoj9kTj/uCry8wc7EAcnGuNfocCxXLVXT5rxkyVakIlKQtkAEnFJKOinIi2ugvSi9bqlWOrNDZG2sGLHJcAW4qlVXuwzaVZeboKrBxVzn9mrG1Xqgr7EBHrRdz0gE42Y0DWwur/lMusI9u57kgjoIsEFIDZXiGZjS52N9+fHPIJbemKQRRFNGMe73o6TbXwYnHgPmNTvK9bsKj6W8glK6kC9x+xNeabVq9ERotMs1Lmgv4v0n6O67V8SvNqw4jVjKG5kUjnwkyJ0TzGIShYYzgShJtTtxaH66PuGMOVbmdr+s3/Pzn5ONvc9FDcpSkuZrErkjqLD3p7rw3Ltz10HscxcvddBf9+j5zTvtsBVX863uXIdf0+68o9bBdW8Upz1LkCjWyPv9a+jGuPImQp+b18D31QfX8SDOuDDMVw5cBIEGDRza7QgcB9VSOuDYXM+DKT4tApyHaHw10dRVBQzTZADEezrL8okf8+D31+o1O06095itnND8aRrg2lP2htQJ2IYpwXH6vR3O1oVEeLsoq852fYK8sCN+4l4QmingRhJhWS8eZgEZlge4xBzPOyZ6qVjoBPjN115iRMH/K9H2VZVoR9nF/uen6Nmo8kbpfsu/9L0auEqyaObJ3xnttn8syZ0bLUWd4KZLdnJmlaOyTW5JX//yyBqhr9pK2CLS67JHT/pbGsnHGZQUPTJqQOoMsD3RVO/AxQMVpHtIp7A/my5OCBIqdjwxZiEaCbAtjjKVmzSw
 48mPI5Wv
 mHmw8zfeA6B3F/W6KBNwP8D1RuXj0Kuok8Dzz4WjeUICUgRC/orTKVS9Uh6FHHDX37rh/QJRpXrLzvZuGEiSJXasmcZ5pxLn2ZOXPTJqADvAjcz+EicRoLdlBx4FZsozVPY5YY2T7rNmTM/jXZp4t5YFs2Xpf6PDTtV9PYBwCLBwn87WTSm/qKFPiZnCIR4kH0dGP2uLH3mMws9uBo6JEsbWjXw/ace8nsG1EUvqqawZDXflojBqDNaOd7FW7WvGqC8ez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 18, 2026 at 11:57:49AM +0800, Zhen Ni wrote:
[...]
>+	/* Read and display filtered output */
>+	ret = 0;
>+	while ((ret = read(fd, buf, sizeof(buf))) > 0) {
>+		size_t written = fwrite(buf, 1, ret, output);
>+
>+		if (written != (size_t)ret) {
>+			if (errno == EPIPE) {

Hmm ... does this work without handling SIGPIPE first?

With something like:

$ ./page_owner_filter -m handle | head

The writer can be killed by SIGPIPE before fwrite() returns EPIPE no?
so this branch would usually not be reached ...

>+				/* Pipe closed, treat as success */
>+				ret = 0;
>+				goto out;
>+			}
>+			perror("write output");
>+			ret = -1;
>+			goto out;
>+		}
>+	}
>+
>+	if (ret < 0) {
>+		perror("read page_owner");
>+		goto out;
>+	}
>+
>+	if (fflush(output)) {

fflush() can also be where the broken pipe is reported, but still treats
EPIPE as an error ...

Shouldn't we ignore/handle SIGPIPE and treat EPIPE from both fwrite()
and fflush() as succes?

Cheers, Lance

>+		perror("flush output");
>+		ret = -1;
>+	}
>+
>+out:
>+	close(fd);
>+	if (output != stdout)
>+		fclose(output);
>+	return ret < 0 ? 1 : 0;
>+}
>-- 
>2.20.1
>
>

