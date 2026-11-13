Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541FF606D457
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pWAoMQcW
Received: by kanga.kvack.org (Postfix)
	id 412586B05BD; Fri, 13 Nov 2026 11:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3276B05BE; Fri, 13 Nov 2026 11:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF836B05BF; Fri, 13 Nov 2026 11:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10A836B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:23:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F9C314033A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:23:33 +0000 (UTC)
X-FDA: 85430616306.18.4516CC0
Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFF684000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:23:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pWAoMQcW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794587011;
	b=qtkjGwfR7Wq1NtGM1Yp/wYRSy4/MVBgDtGjAyZy1FymEa6oDwrBCAPG8nJJzVu91K2dWTj
	vrksPGg2JMgUYReYzIWmLmyOK5ZaYT1AZuYdfff8JJvSGTfPT3rldvt0+eHCoAXl0oerYh
	oJ8/e7soB1mwUv6nkFkmmSelyluNlho=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794587011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ygUWNK83rRYJwfnw1ofgc/sFSy5XCn9E0wwTw0flfM=;
	b=0gVuPjxoEDxUtdG14SGJC2qFzCGwvN9bqULZBc4UqIDbLn+QsZ585ck6Lvl8VmGcSkbJip
	7fb3azq/ocZEnoUf+/jCBWn2jmirDn44oaRYba2MF0aXcCM2kyUfkddZDeJeaCEmexfpZj
	e2PDuMOqblLH5W4YzgKCCJnxz5hN9Gc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pWAoMQcW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FxqEzZWLExR1Wu/Gy7LgJUR+WCtvd+WWmj9g5Dp272w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794587006; v=1; x=1795191806;
 b=pWAoMQcWlltsGQzjWMX9FqtylHtl62bcbMyVRrzPGdV+ToSIUkpXlb7l2w1LWlov2DexAeAr
 e+aowXcCY/7kLAi7Ueg3WCGQ97ReYsrr5IHwS3vETC0JKLnwsPCEU++WhfLec0LP34b4e5uy4qq
 Qz2oXEpFczKD59eGkdEs8L7c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 80e629e5a87ae717;
	Fri, 13 Nov 2026 16:23:26 +0000
X-Mizu-Trace-ID: 80e629e5a87ae717
X-Migadu-Flow: FLOW_OUT
Message-ID: <a74c04ad-a130-4b28-94f1-e94071ce4e0f@linux.dev>
Date: Sat, 14 Nov 2026 00:23:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: add page_owner_filter to .gitignore
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zhen Ni
 <zhen.ni@easystack.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109110139.216653-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261109110139.216653-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFF684000A
X-Rspamd-Server: rspam12
X-Stat-Signature: nx3q5fnaxr1i1e4cq7iwsigz8bpoeoz1
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794587009-445979
X-HE-Meta: U2FsdGVkX1/oL9XvcHzqvnT+0f7HQDhjgBDMg+r7+IsTaj/zXHiw9P805IOEFmpXRggzrIiCdF6fwGueAsGTXzsyfgfLrx2hwdrTsjojzdAzWVVpxKV6xOqaKxBMcsiOZoqLvOiVjUvM3vsFwtvRjI5ui9wyQn+D0KB0tIIR5mO80BZPSQ0pGGCRAG/+oowzgNd7yybSTHnhI66aho4mfC0KkBNtcFW7V2Ie+KfnY/fui64Zi9acJgK2g+8YfLRv9IEFzIbqO+luR7Rt6aV9sgLb3M9iW3UslQNzUfXzrpTQMJWoAHiIutnGCeajMh95HevzGfHRigN8qt2a7YJBA8HPftGTtgVK/YSLNih66IhRwTG77gScX5S22pe6LtZ0SfqJmQ3W6SIEu67SiXD6wnDoYQtU21er88fKV58yGevunE4NQn+d+c575YnqjH6vbmvgv1RNxD/JpO+2ytWSgS2eyIGqq4WeNrMKr5INug8ln75MUv3Gk+rhg+ugTE7QYtxboe+/yKCmqlehZMDvei3qfCj3cuAkuLdBZCUrl0PcaVNYpUxGOfY3sDgpyIuu7cyJn8Qq3LnihElAoAiW//PY6OS++HOYh4/SIKrwGF9Zh+rRD3Fg0bZP2ms0OvDZIPb247kTTiDDhD0wldLFIGKSqaBYvBBoWS+TxCgmXNLgzTwFoJCvbITOVM5niBTaPevTEbIxkspKCvD4y3jdzjHSoq75TRnZhPaJeklXeIhrgt9s9IfVC1yP/mOyKnTTiyInSDlbhTAvm3p4F2sDSvJGO2oo0gKNc5/5xpFrqs8bL+KTPd0/ALOuiCwfKMbrDoFCm9RZ3ULzLE2xe/Fwhvc8qi/v5wBv65ZtacJOylaztDPNmDEL3JKdfiTTwh1wIHjM1hFA3oksLgvGpr6oiwAWfqImdb37xTwIw08YZ/+bb9Z9tRc5juxa+k4aApl6WztdOqF/iMuLaFd1QeQ
 BPOJNAH+
 ypKDHuPecTFXb0W4os4U9p41Jq5j2ygPRYewAZ26mlJ7xeVnQYLAC5AeInhMuL+Vdddbq+chUIZqTPW88neIVruvI3v6UdXNNUdxXv/DvBe2JyOEL8eJCoFSGG0de2VJu8GPqT8MiBHYYhM83k0pXDyvL/YsiPdUkUsnNgyraNi+BSpxolpEuwyfc1wDLQHKMABF92Tl+qhwRsVsWdz468rwmvWovviWHKpiufac+WG7z2oclSccfW9AcRGtuD0PQfOrhEmuoKHWMtFcn41UkccR6aCXqVgFPWYkNUTIDHW4+BeU1GTNKb6DThLwufSJEGNeY1kpamtdNhUJjv7qyan8dga8YULiAy3vXNXj9+C7kyq9r0YFOg/NMAGZGTX0BgvB2FKMf6vLbq+9TEfkqvCiVbKYOaDeezIhDPf5g8xeuw9XkdFdAQWLSKwD9byteLTmQzLH0ic/C/DPPupa1kSaAz6EhRalpUNFCoETyDPWurINHH6TM6fTZ/6czkBAOdQWyUOTNKH3ZvWRbVZiFunzJl79f4207CpYWtk+/ULh99wW1Dmy8Hb7+BLhuDnX8K95U+XbK9S/5YZiAulVrjid5Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 7:01 PM, Sarthak Sharma wrote:
> Add the missing page_owner_filter to .gitignore in
> tools/mm.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/mm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index b4ac68a08e1a..2d08f713b664 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -2,6 +2,7 @@
>  slabinfo
>  page-types
>  page_owner_sort
> +page_owner_filter
>  thp_swap_allocator_test
>  gup_bench
>  memory-failure/hwpoison-panic

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>

Thanks,
Zenghui

