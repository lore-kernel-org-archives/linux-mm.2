Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3D2606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jfq5ob//
Received: by kanga.kvack.org (Postfix)
	id 0B12E6B08F1; Thu, 22 Oct 2026 05:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088166B08F2; Thu, 22 Oct 2026 05:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08B06B08F3; Thu, 22 Oct 2026 05:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCF0F6B08F1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:57:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61A691607FB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:57:40 +0000 (UTC)
X-FDA: 85349810280.20.98B135A
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	by imf03.hostedemail.com (Postfix) with ESMTP id B67E02000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:57:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jfq5ob//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su0kxsaFnNvjoRtYbofrvseaIgbmxyoofBQNCPb7Pn8=;
	b=6c6Xbh/HqMKAUqYNS7EoImaPwZ4Qa1pm54tQfwIA0tmfYpIa2vnm+HYkn40rA9cVOo7Uag
	8FtBuxKbg8PpD8hYMlZIpdtY1w34KqYKotbOXN1saM+ZRMhxgzklmTql7JnYdUZy7B3izE
	yfaOKVTSEUfHZm7MVXtuwGsF/cmXTdE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jfq5ob//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663058;
	b=wywzk/BqyvZFWvU4D4YgZNFW6ARCWc5sVDw7aLJ+vRkl64ddGSaK3UM4sFdWGUvZQ4VzWp
	ky5CfcggC5I/zSqiIKj89TZZm5FgEMhx6yQvxh/Zv+wpwd3256HFiqSuhyBoE+LZhZosEe
	8p98VXgijhh7zNQxGksEr8Z7IOUtHNs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9e4WbqCUI/2DEZ2f29OfqwHYvgamdHtvS2zLpcL1H4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792663053; v=1; x=1793267853;
 b=jfq5ob//lKe8mnDwkDU3CXUJhLQSW/skqKreLuS+fpiGmRIuxHz8nibBcMCOVd2FrGIe8OkI
 fMR82BXJV3uVg5KKffBwj+hNQnSY3dUv4B15DMZJVJpuRLGbAgq3cC3NORD9aO5O6xzWc35/9R1
 FkJ/fYXE80WGzP8tI+/bKdMs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6e7ca210cf23f8e6;
	Thu, 22 Oct 2026 09:57:33 +0000
X-Mizu-Trace-ID: 6e7ca210cf23f8e6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 2/5] mm: hugetlb: group CMA pool and reservation state
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ff8e96b68fc725981bdcd65c1c6e3cff2c0798a4.1792651104.git.zhengqi.arch@bytedance.com>
Date: Thu, 22 Oct 2026 17:57:16 +0800
Cc: david@kernel.org,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <C1CB437F-A2C4-4804-87C6-325C6FFD87EF@linux.dev>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <ff8e96b68fc725981bdcd65c1c6e3cff2c0798a4.1792651104.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B67E02000A
X-Stat-Signature: ajzixc9whmim4sr4ac1dbjynaixseusb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792663056-53096
X-HE-Meta: U2FsdGVkX1+ZQnulj/+2VAaCC5LSXIflbZGoqilz6Pwv7QEw7v8ctc4DnBTandMwWkxgOcY9ik/dQNOU3a8E3zI/9OF0/jp+BFjSysXHsgrXb3B/9Xtf+xt+NaxAQfML8xQUp87oyFC/VzkCCQGBYSBYdLCAiv/luV82TlcDln28Njq2zIK+DhxLmg7+xyaltXLRuJQG7kwvPEb1IlNz1KW9ZKgqu6Bkvz0fxeV/nxGF6XjbK9iPwvICIR5j9WtWkve/gUTmFgfc2ro93SMXXJqZfpMEF+CwsnnVmVQRAxmCTV/hT6Yf17T294gRZCPDNh2GLjOfjEZCIGXlJJjEBLaWzudRsFPY0hsJx6CRBSg5fYHHqyLlUJ4WYG0QW4yCNf85Ot6SGwqhXu2aAvnMnflxgHCL773wma/k4IjOpuZbrO5j4P6d6i78PwPHduuouYWuPsvai2hxDfDyL4Hkjr/P5HxIVwReGfJFjxevBTcH117Opj0ydBChlXrlcv19tQXCcC3c/9KjUqZsL8QPgHydCpf+dmak8WeEmB/mmoQK9gN5OG33DMtNgQzwyZn9NSiq68qMsWkPCsOt/1Kd4EiJEHri8eCpCXrXtGOKZuz1IytROaZGK/VUP3GTdtWzb/NQ/uYCfx5vZ7yEHN8z+uHiZrmCML9dyPR3j2//9n8L8KEwC50+b09Q1Z5f1TQg401VcdLfMS9xibLEes65pgenqvScgW8QYMnz0lsSgNKzioyelSDDcwlqLdTr4Q0c55lIH2JnKqZDYHybV34kRAmhAWuoOYJGHjIe9TMVo4AiAZs79Pwnvt122xJwdONVAqQB8ONlnJx43WcLFNtO9rqkXpl1hEwc/a7/KTDMVE7Vqnz4AaDnRj+RegXct2L+q9n85nlqsBe0yiylvxJWCoxH9/WjbS5YEF6j4FkDlBCx/5uxkxJu1/OU0icnn2ZFkz5q4Mqa0KQ9zVlLgoM
 zAWgiERv
 upvi+cNs8y9CC2VM17KcS+dDDmn2rw+oDtegSVCy/Yo91RDzPw6MZTgS6QqJXCqszMgUmd2CeDzj3e98h33JFPwmc5UWA128AZwk29G/80WP8UaBWLron78o36u2oHnazTCG/xhxORaszO8jQAeM0voLgU3+NJd+2nFhEpTGtnJPj69V+AZPjjSp4ASi9Z5hfRxg6Nsb4oP00jupoRjb2qLDJiHOLeFyUVndQO6M6HHWEN9fjd83SFWjewYi1hfYSqyI7uZ5epOcZQqKvDyh+aWU4/iE5QAofkyckbR1XC58VKb5ijttODxtyuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 15:31, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The HugeTLB CMA areas, total size, per-node sizes and percentages are
> stored in separate singleton variables. Group the runtime areas and
> size into a pool, and the temporary reservation inputs into a separate
> configuration structure.
> 
> Keep one instance of each structure and preserve the existing parsing,
> reservation and allocation behavior. This separates the mechanical state
> conversion from adding support for multiple page orders.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

THanks.


