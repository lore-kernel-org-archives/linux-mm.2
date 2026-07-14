Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93321C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 03:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C806B0088; Mon, 13 Jul 2026 23:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CCAB6B008A; Mon, 13 Jul 2026 23:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5BB6B008C; Mon, 13 Jul 2026 23:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37B756B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:00:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0C08A0276
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:00:33 +0000 (UTC)
X-FDA: 84985879146.12.7BFF32F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id A65D740005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:00:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWuFUOhZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783998032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4XC4Tt2Er5SVTqQ4QRZas9ffsbGhNq4gF6E+smuGPU=;
	b=ATwbrBX41rF6iC8RuXsQVmUdCW9Wjo+vetRj9zl/w5Ymu9g8e8VfzgoypejOzrFLL9/IpB
	2ZOLetJ5MdxbkxWR1X4yBe91dSWy9eHbk1j8HF0Cbs2S2LgtIIdCtbyya3LlX3fyAA4Xet
	Q/skaYqg0kUzaM9A35XEaZE15OMA8Tw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWuFUOhZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783998032;
	b=gvFnUsuxNRTW9YmgwRAlrgqmN1x1TekHSyySdflHNR0qv9Oq0XDX7vOtdxSC7QUHbaxLQi
	Xj51jw1geuaQpvXSYuIKmlvPAmmooNb3j7twl8WhFDL4e6gDRFW2occiM6q15b7Aya48pS
	4MD5cGX+2IyOt/1pMlmtA1Mbr5VP46g=
Message-ID: <e60ca749-ddeb-46f1-baf8-01db8a2df1b9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783998028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u4XC4Tt2Er5SVTqQ4QRZas9ffsbGhNq4gF6E+smuGPU=;
	b=SWuFUOhZ2qAjtWWzx8WPyPnFFagUYtKh3FmiI2Eo4/FG8MdhayLP+WXKB1zAuW1Q6eGqQK
	0iVHmFzsQNm0SAPBgDarv8HbpIHA8q5h3T0c9SRpswbEuNvcmu4SNtHBhLsZgFNhXAXSAo
	rWUWU/ho9C6k7xPsFvGg7knT0IW+gWs=
Date: Tue, 14 Jul 2026 11:00:19 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org,
 mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/cgroup: fix missing TAP output in
 test_hugetlb_memcg
To: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org
References: <20260714021511.1063700-1-husong@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260714021511.1063700-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A65D740005
X-Stat-Signature: wc5pmf1jdoiwasd4rbqbnq6dm1sbkccj
X-Rspam-User: 
X-HE-Tag: 1783998031-937659
X-HE-Meta: U2FsdGVkX1+y7VF4jfPuVvVaEnKEyOQawje6ayzM1Svt3RjM4OWaWoRgoXqD1+0KGIJdqAhlBUCZptH4KOVWqQDcJZikB6SbNzGEPLFedzc98Pn9Eh5exB7VKSMh35xzBvxkX/VzMowy71HrHXB3JQprVUPdtkhGDyjM7mBn0h0U2fnPD9W/jdY/xc9bXcb/ZQ31xBlJxitrbGhIGdkoKVdKYbPFN/rrjRcmNutGTkQYuF62LDw3/0oxCiSG/elqDGyqBUz3qjcVIuLmGiDP8Us6Fc6/PJW/qthBu/Tavjt8zDmYSrnYqtjrRDhlx7Irh5tfsHZYvbl5WLzti/N3rqikuKk81Gdudcwlly3O1zeqrjNWyzPO1O8Wg1EEz9HaKPJDbbb57JhdCq1bjRMI7xXCYnBLI1EiniLAIImrAM3hr7kxj5Q7cKMpv2Vw+/EU8nY/EWUn1GmxzUhiRCBNAAHT6m6Begflfgi5/wjLI3ymA511YLSJgvb9gaOotNkLkssVxX+KQM/ePMXjSxzDNlWlbNytLXIKadUoRl1t2/GZXjAhuxD5BrN3jw+ROWsIJxtohu2PyGz9LDAJCK9Qc/XPZQgybtJkrhqN0EjmjWXjkiiR0SmlARU3/Znv0sM6CEmprg/vEfDwRbLPl7epqSxTVgCErjq0554LEIk+qt6qcCupRrlZ9inxNsSlkxnj96eajY5Z6rmD/24zR+CX1Z/nqH7PZH/B9PtEHrkWTZ1w4nrOwVk3hJbQ6aR46/+EoM7Fx25Z0JMuqglsdFP1vIZavRYMb5MjnxRxe5/AsbA5c+4XJrCEU0L0ckM4Yh7a2uOeM1G4UUq6ZweYFDQaz5S2OiS1RcQ+WobvZXKooOwrNjjp1lpvGWexYdrAlo1XXYk1EWlNQp7bUszTy1dGkxmSk/QpXDsl9iFHYIj0h2BosLsXf2hiyp/hev7iffD82HAVDo1a7wcCDE8xlKx
 ZFjT8O6l
 Z0Y/DQ41jIARz0bPb8KxFcN6DfOPI6x/nFfM8pgfKpFbXL5mkjFCJQ5YvSSSL/6v/PATzS8oVUg8lkJB15kwv7aH0MfHsc2Dp2BrSNg+cr6HXnXk4dItZupZdKGZZ9ZUX/zfAaRtY1Cs92QsOBTHEes5bpFcj2ASxznlE9ll/lL71sdjivAPufvhD/72sHWGUP6T/UMEBKjWMK7YXwUlEc/3Q176sC7YvTgZ9zDnrpgyMN15VAwmTFG5nwijXWp7m31piEhQmCDqxrHkhaWngHmurhTm2K9lk4e+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/14 10:15, Song Hu 写道:
> main() in test_hugetlb_memcg never calls ksft_print_header(),
> ksft_set_plan(), or ksft_finished(), so its output has no TAP plan and is
> not valid TAP, unlike the sibling test_memcontrol and test_kmem tests.
> Add the header/plan/finished calls following the same pattern.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> index b627d84358b1..8c5aced813b6 100644
> --- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> +++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> @@ -199,7 +199,10 @@ static int test_hugetlb_memcg(char *root)
>  int main(int argc, char **argv)
>  {
>  	char root[PATH_MAX];
> -	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
> +	int has_memory_hugetlb_acc;
> +
> +	ksft_print_header();
> +	ksft_set_plan(1);
>  
>  	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
>  	if (has_memory_hugetlb_acc < 0)
> @@ -211,7 +214,7 @@ int main(int argc, char **argv)
>  	if (get_hugepage_size() != 2048) {
>  		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
>  		ksft_test_result_skip("test_hugetlb_memcg\n");
> -		return ret;
> +		ksft_finished();
>  	}
>  
>  	if (cg_find_unified_root(root, sizeof(root), NULL))
> @@ -233,10 +236,9 @@ int main(int argc, char **argv)
>  		ksft_test_result_skip("test_hugetlb_memcg\n");
>  		break;
>  	default:
> -		ret = EXIT_FAILURE;
>  		ksft_test_result_fail("test_hugetlb_memcg\n");
>  		break;
>  	}
>  
> -	return ret;
> +	ksft_finished();
>  }

This one looks good to me — it mirrors the test_memcontrol/test_kmem
pattern and the exit-code semantics are preserved.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

