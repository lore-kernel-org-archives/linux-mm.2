Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D586C61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 04:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A408B6B0088; Mon, 31 Aug 2026 00:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18296B008A; Mon, 31 Aug 2026 00:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959176B008C; Mon, 31 Aug 2026 00:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 636C16B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:52:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A839F1A044D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:52:56 +0000 (UTC)
X-FDA: 85160344752.07.323E313
Received: from mta1.migadu.com (out-87.mta1.migadu.com [95.215.58.87])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9CF3C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:52:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXdcyDXe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.87 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788151974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Z6A0KYLDKRPpdA7h24PIko/evXtONXicJvVXPTZzSA=;
	b=uayhB3B1R1hJXO8duG/1tED06GBmE5E8qad5qzLv8iYm7Iv0RlODjVY3myDnitkzx8/k/m
	oFRHqDXlP26vJkOzOjw7Yy7SymxhQrV4jEysBzvdICzipk5o9xBIX6anJhl2S/Hm5aij0+
	NvX+EC3sRB6OqbE7zcvRiAaee/BaATM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXdcyDXe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.87 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788151974;
	b=J1J39QuzWJYQsFW34iIw8mdCwkJ0VFYtQDXPiOOxkXkgwRNwy/5FO0LDtlquqdbp8aU8KK
	/R3JQdnzEEgY/YKJFtfsT/VCNLgRxyvLcq1w6DYG0OHMVqzb0Q4a6YcCla9Eyad1CDO2hA
	zQ3W7XWHlxJEIw7SviP3v2PcuEKKTkU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bmzSrjJaq3XT8jBEdtgSjOSepJY+gkPVCqgxYOBVBd8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788151969; v=1; x=1788756769;
 b=LXdcyDXejfPMX70dfSa96dlNTo5Zv0aHZXPDjeQm1a+mkQZbnbpGYe7ORNXA/PxsMYf8wmAW
 jgAZauaMJgvBG9nYO4SwEqmo25S/slmDixxJqJjtPv6NtXGD/EaoaUQsDxMLco7zEDuF6lkfaQe
 klSFlqqw9/O0Vdp6I537CxeM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1c9dc12ac8dfd3e8;
	Mon, 31 Aug 2026 04:52:49 +0000
X-Mizu-Trace-ID: 1c9dc12ac8dfd3e8
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: sarthak.sharma@arm.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	corbet@lwn.net,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	leon@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	broonie@kernel.org,
	anshuman.khandual@arm.com,
	usama.anjum@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/6] selftests/mm: make file helpers return errors
Date: Mon, 31 Aug 2026 12:52:41 +0800
Message-Id: <20260831045241.25826-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260831042101.18085-2-sarthak.sharma@arm.com>
References: <20260831042101.18085-2-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: facok1ws59onxx7b3uqe8yusef5tgf6u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9CF3C0006
X-Rspam-User: 
X-HE-Tag: 1788151972-157530
X-HE-Meta: U2FsdGVkX1/fJlMvHVDRV5xq/sr/KA/DWH+5/Z99L9oiut8O64z+gmBiyoTa5rm0ibPwl790u8ozDJ/Yhvy0Ulx0V96guiIEnghhJbdOsxXX5HZlzshpTfQFQM4fHLrxIzBYD8NC+y6skxBHJgiStJ2D7Cw/+emsnGXZhYH9MX6oAtR+4/jn/dPkYNiCQzlJkFLGr7Nc5y9N/IEEUQEM1Qt4rNG+ZccgKrfVtuRPnBpdY4EBJxQCoI9kXPbL4UQvQXv2BBNg3JVxXJSYBMMJ7MKz7OyAcC97/AsAfOOROyvY9+Gnyt2yUpoC0WWD9rYR+fWZ4vTSsbNcCQhzcrsvKBHAH9dURZ8jgizWvdRElxpiq/hUtlVzKwuy1lPItkleUC/qZC7xJZ8peWAd0+qrJo2k/V03CFBIUAPZ/ayFt479j8YfUllPkY9EgoE0ADTyisvUW2iYRmyCfVL3wmDHCAKadtOd5b/EswklX2g8lWCKo7j/TbPaZD/H5F2IdkzEBhf1BQ5rzpymkx+g7lK9aCVZu0KJ+K+Kzz7xwsKjwrWqJB5FbhmyIC3iMgSYDJxT4V5kBtsHUDjsbN6Xy7MX+mrcOrmahDqm5YMuYrQNPd64GRkyK1E3DPYgWV2iWErGqQOCWu2uX9V8GTQ+fRKF7aFFZB3WLGnbcZRExpV8WBeqb/3i11tbA4BI84+r34HW8LjjUG1a1f5ZcpFBrmqyJKorj2iHzz7CMqCO2QfeqdayhH1P2wkJgNUHrEU0RK3RbIYLcYJHb9WylwMgCucNS+rPXzJBji+qBpPWqe+ozu9v6grBJ0uNajeteEQ8lnqZIOO8tJg+v+sITLxgH2DEwANAGsIkbm8FJupUIgLvBtm97idTjXOokLrb92outLxccxsYWmkW9tnDZ4jtLBa90TYBtbp6v8gXMuMeUmYPLg//7wHrJXZfgAt/TfZ5h2KYqU9PYKjGXkpCq2DiFcE
 p5PUOByj
 vLgBDlIcVwzPBiP5GI3toEK3HZ7coCx2K81+YS2kakADc3gc6u3XsG1bxNw3c//J+jmxLG4k6+BwoO1Tc+OO/bJo/pd5T54VFXXaHzOpXeUYhI8c2CQeaA/hUe6y3bh9Tb9DislrpjGkbPpMfjX6UICuSslzaUC/KnvVEWZlYzipJmfvTZWNCdEYpvblglmTDGf+mXz/gCPI6OtYBYsfQgAj68pnYK1MFpHT0AF3p2oEnPLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Aug 31, 2026 at 09:50:56AM +0530, Sarthak Sharma wrote:
[...]
>diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>index 9a49af88702e..62f6f5b42649 100644
>--- a/tools/testing/selftests/mm/vm_util.h
>+++ b/tools/testing/selftests/mm/vm_util.h
>@@ -166,11 +166,11 @@ int unpoison_memory(unsigned long pfn);
> #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
> #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> 
>-void write_file(const char *path, const char *buf, size_t buflen);
>+int write_file(const char *path, const char *buf, size_t buflen);
> int read_file(const char *path, char *buf, size_t buflen);
>-unsigned long read_num(const char *path);
>-void write_num(const char *path, unsigned long num);
>-void write_num_ignore_einval(const char *path, unsigned long num);
>+int read_num(const char *path, unsigned long *num);
>+int write_num(const char *path, unsigned long num);
>+int write_num_ignore_einval(const char *path, unsigned long num);

Ouch ...

Looks like this conversion misses hugetlb-soft-offline.c ...

TEST_GEN_FILES += hugetlb-soft-offline

int main(int argc, char **argv)
{
...
	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
...
}

And the compiler isn't happy:

tools/testing/selftests/mm/hugetlb-soft-offline.c:199:36:
error: too few arguments to function 'read_num'
  199 |  orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
tools/lib/mm/file_utils.h:9:5: note: declared here
    9 | int read_num(const char *path, unsigned long *num);

Cheers, Lance

[...]

