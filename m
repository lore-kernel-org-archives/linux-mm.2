Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C78CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6267A6B0005; Sun, 17 May 2026 09:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF066B0088; Sun, 17 May 2026 09:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECAF6B008C; Sun, 17 May 2026 09:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED1F6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:33:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7580B160DBE
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:33:01 +0000 (UTC)
X-FDA: 84777002562.02.4AF8E8D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7AB741A0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nnQEAqW/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779024779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TFOcCLVTrzSGMf6OMRn7d9qROQQE6qY9dQm9d0YqOA=;
	b=e3Nbd1mUks7M2PBEVROlz3G6QJGy3wjmy8dESCmPea4ZqV5Oa6JbOfbyDStNoUH+qvktUu
	U1R0v0zPRexRy3GEWtb+GKhduktlVnPiRBEd8l5V3EW5i1l42qbUu/7lFX9nRoYjbnYNu5
	aRgtajS7eb+hoOw+khQHp2dq3fLWmeE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779024779; a=rsa-sha256;
	cv=none;
	b=fu3fnVWW77RIq0Lr9il4zbsiqa+dj59VF9my/6wYat54zSkKQDs4t3gg3W7UKOkxUrrKOn
	ZzKbtF6prW6Mz2NTA5jTFGkC6ZOgnlqH1gsgBmLrARsmNQY0IWepJpKpzqgaCMnAw+PExN
	AR6jyfmcmTeSSbzy8M9zRBzWdSqCZOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nnQEAqW/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779024776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TFOcCLVTrzSGMf6OMRn7d9qROQQE6qY9dQm9d0YqOA=;
	b=nnQEAqW/Lvrruxkg/klvjNyMzNTc5cQnk+U2V6B02n+gcyM9hGIyvLX4f4VcrBQeyA3+8m
	8WZZ/MsVvqs/2+FbZkzR2MtX9+FEAQ2gNkLivhfYc2v4WKZt5SmKmlv6qji40NBh28cRP9
	QM85UwqXIQIWdbL/DUZaQ9/s+Ujf/bQ=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com,
	baolin.wang@linux.alibaba.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: Re: (sashiko review) Re: [PATCH v4 6/9] mm: shmem: drop has_transparent_hugepage() usage
Date: Sun, 17 May 2026 21:32:39 +0800
Message-Id: <20260517133239.26416-1-lance.yang@linux.dev>
In-Reply-To: <ed33dc0f-fcde-42b3-90aa-c20290b06f49@redhat.com>
References: <ed33dc0f-fcde-42b3-90aa-c20290b06f49@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AB741A0005
X-Stat-Signature: pr19xxms1m5z7cqpuaoqu3wk4qxgip8t
X-Rspam-User: 
X-HE-Tag: 1779024779-322335
X-HE-Meta: U2FsdGVkX18LTxbyx2VoWKIOAhyVkH/2N6al/OiCe6rH77H52s0GNecdyDl5HQRVujcNxIuBuEqBFalFsWaLUL4L6FjJxUZN1LBe3d7SoRaXD4KnIymmbhgRAxkC+hFd7j/9DWXTvkcRd1dGYIKkpEybvDlbor959GgSp6n6YLsoz3D2t/7wXPBzaEUjZFr9pn9i2ObzavSfGHHQol5ON5x2nifZJ3kxfCWwj4xnGtDVhbWNIOxAKW4QXvIE7Yk39JKRDjy+rqbO8+lFFREqsZ/EOlTpARCSPyHart1lPJqmtQ9BPAeG3hb1ysYJ1bnaVonybPVoWM4aLot2MVvwuey+uXTJTRyH42nlsRAlDro2yOhziI9C/tpQkbXRmOt8/KpV25p7kUM/EbQuokaSUROSuSPAPM6WxuwxZK84pZl8BEn4vCI2eV8O9TW4o2Kxg46Vv1Y4cMTeQFmRJnGAGIpNhAxbh0HypTGTCJ2Ubvf8ZKrXychkEU0FLGiZAsBo6OSY0Ogx9ufMrDREWML3/t9wMVFUtU1QWkWBfTIKYAi5q/cvguyN9mUPTXcsSFK0IX+FB8M3Vs8Q5so38hbgPJQDLNkQ1VHore+nB2LjnqSfQL+EOb+68eKK7xVn++sXn1Je3dilU31EXihb4Sen5DpE2Tl8BRneNCs7ErTTFjaLa/pDM1txuZscO8ug5tgCCcayao1/t2yPBoD3UR514GP7ipwIvBECeP+wBMpwiiBqiHHKDRAz5wSTZAaELQGsJOQGBXIRDYsAqEX0Lm6VObCXPKiy9fOlpDBd7UDhqoCrbg/Ym+YuSjFREo0eSyEtMbnp1cci6MXu2semD6H8xbowMyT8VuZsoQtV0yfq/Eoq1JFG4Yno0AeQrCtxmxnVoAMZC1dUbktmLPiSt0PwVUgPPHZigBIhcdMeVsgMUX9SJSEMJbT+fl9oe+yDaCd7+CPIwtUscYOAzrbJNnW
 kHDIRCob
 kZUkvNVdvW6b5Mc+NFtPQFrhOrYKHiXtCKOT5gta7kHTlTwcYVjsk4+mCpsm+6CHpf+5RbB/gq5WGlB7A0w6zxP0JUiQZ+d9Cu4TnIRvROSpfjhMjrF6SdWqlKE/4VkuL7T1ELs4VsmmURC4DkvBPe5AF6h3r99ux4MW9SGS2tXzZcQ5dwuJa6C9QEL3WteJR9KSQYmPGse1LFmvYu1kYVA5ZE01m9tzwR1EMLRrUVK3ifVum51knWMctDHpFf3itItbaczPxkEIAPZfxwfJoCzsGZqnNSU2aiBaevd2JHVQOGjz/99dLSk/cSp20R+7hg05uquGt4usMFrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 06, 2026 at 02:12:41PM -0400, Luiz Capitulino wrote:
>On 2026-05-01 15:18, Luiz Capitulino wrote:
>> Shmem uses has_transparent_hugepage() in the following ways:
>> 
>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>    if the CPU supports PMD-sized pages
>> 
>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>    the code block calling has_transparent_hugepage(), the
>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>    supports PMD-sized pages
>> 
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>> in all cases, shmem can determine mTHP size support at folio allocation
>> time. Therefore, drop has_transparent_hugepage() usage while keeping the
>> CONFIG_TRANSPARENT_HUGEPAGE checks.
>> 
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/shmem.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..1948d73fb1e3 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>   	else
>>   		return -EINVAL;
>>   
>> -	if (!has_transparent_hugepage() &&
>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>   		return -EINVAL;
>>   
>> @@ -4656,8 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>>   	case Opt_huge:
>>   		ctx->huge = result.uint_32;
>>   		if (ctx->huge != SHMEM_HUGE_NEVER &&
>> -		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> -		      has_transparent_hugepage()))
>> +		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>   			goto unsupported_parameter;
>>   		ctx->seen |= SHMEM_SEEN_HUGE;
>>   		break;
>
>"""
>By dropping the has_transparent_hugepage() check, will mount -t tmpfs
>-o huge=always now succeed on hardware lacking PMD support?
>
>If so, since hugepage_init() still sets the TRANSPARENT_HUGEPAGE_UNSUPPORTED
>flag, thp_disabled_by_hw() will unconditionally block all large folio
>allocations in shmem_allowable_huge_orders().
>
>Does this create an intermediate state where the mount silently succeeds
>but no huge pages of any size can actually be allocated?
>
>I see this is resolved later in the series by commit cd27430097e8
>("mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()") and
>commit 641a20ae032f ("mm: thp: always enable mTHP support").
>"""
>
>The mount -t tmpfs -o huge=always succeeding on hardware without PMD
>support can happen in this patch, yes. But this seems very minor, the
>impact seems to be someone doing bisection, landing on this patch and
>their reproducer is depedent on mounting tmpfs with -o huge=always on
>hardware without PMD size support? I can fix it if others feel strong
>about this.
>
>> @@ -5449,7 +5448,7 @@ void __init shmem_init(void)
>>   #endif
>>   
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>> +	if (shmem_huge > SHMEM_HUGE_DENY)
>>   		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>   	else
>>   		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>
>"""
>Also, by allowing shmem_huge to be set to SHMEM_HUGE_ALWAYS on systems
>without PMD support, does this incorrectly affect shmem_getattr()?
>
>shmem_getattr() relies on shmem_huge_global_enabled(), which only checks
>the software configuration and not hardware PMD support. Consequently,
>shmem_getattr() will erroneously report stat->blksize = HPAGE_PMD_SIZE
>to userspace.
>
>Since subsequent patches in the series do not appear to update
>shmem_getattr(), could this misleading block size cause userspace tools
>to over-allocate IO buffers on hardware where PMD-sized pages are
>structurally impossible?
>"""
>
>This a real issue (albeit small one), the problem is this check in
>shmem_getattr():
>
>	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
>		stat->blksize = HPAGE_PMD_SIZE;
>
>So, we may report HPAGE_PMD_SIZE even when PMD size is not supported.
>Looks like we may over-report today as well for the
>SHMEM_HUGE_WITHIN_SIZE case? In any case, I'll fix this.

Well spotted.

@Baolin looks like shmem_getattr() might already be buggy?

shmem_huge_global_enabled() returns an order mask. For huge=always and
huge=within_size it can return THP_ORDERS_ALL_FILE_DEFAULT, which is not
PMD-only and can include smaller file mTHP orders as well ...

So shmem_getattr() treating any non-zero mask as HPAGE_PMD_SIZE looks
like an over-report?

Cheers, Lance

