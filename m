Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6AA606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QQZJDCma
Received: by kanga.kvack.org (Postfix)
	id B3BFE6B05B9; Wed, 11 Nov 2026 04:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED3C6B05BA; Wed, 11 Nov 2026 04:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4A56B05BB; Wed, 11 Nov 2026 04:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61EFA6B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:10:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3456120240
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:10:19 +0000 (UTC)
X-FDA: 85422266958.05.E88C46D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2FFBE140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:10:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQZJDCma;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794388218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xH9l3vH/C4QDmuSYkhVbjVTYTvtMqxmFM17WSOqQ34E=;
	b=JGsZVr7WFxa5U+q+G/7BUHOhpmHSQ2yYABPQ9Kp0xtHaSUsICmDdn3u0Qs1FUAmY95Fm9/
	h3nTFDonIt8hw4PtHHc1fCH2oVVp99PRld6FWN1UtjaAGM86iqsXkj+koMxMFAkxWD10xu
	HG8MLKmP0aFnOa9ewfBYS5DX8JYj6kQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794388218;
	b=S4DbGD6sAoTtNa+Dg0pxIkKg/NgcIRTXq9knQ+w0Cc/jH8K6/zHV9RrD+acWOVRgXmua+y
	dygo7WgprviF0Y0myDQh8EgvFzAaXVBdTHtPQr08UmaBWTbNc7v8Ya/3xoYgA+OF14cyxV
	Ph/LEJQx2UYkkOCbwdlZu2u8MHL92/I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQZJDCma;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA71663BD2;
	Wed, 11 Nov 2026 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FE21F00A05;
	Wed, 11 Nov 2026 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794388217;
	bh=xH9l3vH/C4QDmuSYkhVbjVTYTvtMqxmFM17WSOqQ34E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QQZJDCmaKacfblRcagLi02rbg4jcCBwjp9GW5ASiJ8taKOiX+os9eVBIIXUG8CZHs
	 UP9BXvgSxs3gHLnqayo3DnLh2wb3rk/JbGvU6a2Io0b/Qu2Bd3x2ZmAk28LVJCpAk+
	 ROfQ3iEyQKObZevE0BedWNZrvGK9ayUJyuyshutw3A7iSM3s91J3IqkZRMyQDb6FVn
	 NlCjXqDr0jV4ZgvARvuY0guxenbSBTpwGYlUJhfJv1baYnkjQO1x0ZAR/uT0QPwIee
	 ETXVJTcYUe87V8Vk3RT0Nw7bfpV2NeR7mTFNYEW/olNUeI4L4wYcR9EQ718KHiEL0y
	 hRM9iGghejhlg==
Message-ID: <d43cf7bd-6a6a-4102-95cc-cb236eb49e0d@kernel.org>
Date: Wed, 11 Nov 2026 10:10:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ksm: add only_merge_zero_pages to merge only empty
 anonymous pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, corbet@lwn.net,
 link@vivo.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 odys.yuan@gmail.com, rppt@kernel.org, surenb@google.com,
 tujinjiang@huawei.com, vbabka@kernel.org, xiao.wang@vivo.com
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110074451.220524-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ag5o5mg9488zwbyk4n6jmgm3w9utet4t
X-Rspamd-Queue-Id: 2FFBE140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794388218-907755
X-HE-Meta: U2FsdGVkX1+itEERReMAtMg9LL98R1V1ySVjS76WX9MRIH9qjXwh+SXCOC/lNbxiYtQA1PFBDXISC4aIzBoBuQfTGNi7ClRfSJz4FeuRyMs7CKvW4j4rHJ/5ub6SgSDi77BQNPrZFXJXnbEtzGfbYYAo0qahAFGj9Ahhe18gw2ucB78/pex+hfbwiRr50ZPi/AC6CP3dvI3nTtAQuPWau+KUI/334ZJt93EkVI8p8KMCnx1OpmDsWKneQycpT9c8p9vkZZTGXXQGrDQD1cexA1JH/0v+zF7N8dsGh2XrbmT6CTlxtUpfq3cq8KfCEZH9uF1l2seONkqfn5hTYz5vkczBU//gxhrX6485auHI2TyXNbK/eNpTw99PVm5RytbMPqf9RotLhhoP1InilodFQU++EBDbGH5kpIkn9ii46R+YS+HurTtGNS6EBVugwkBlZBiNmk/dRoy+OyEBtik0K71QZ+lkhjFFStJP2n/5N4QAQSD99JlbEo8w86P7beCbSiB78DhtZrenfrfW3qD94UuLolmhasyqMY9ruiJrh/LScfiov+TaPvEBkC5va6pF9Sbe6UHEb7r0HqDQGb9lRiyvkHFpmBuWm8uzHrrcJL5aMZT8zk5RgbuxchT+JinAMl0MkC8A+dD0wtV9qAtLGRqDWGUBHOdGbKMZkvPica0J1Qmta48Np+XljdvTTPqwA87P0N23UmLe7yzRBSu/KrihomNPms319sXi4gPalI2gh5Dx+SqihPBHS9SZHe4ycU1SANyKrCgw9K1u+Ni9S82BhQ1cw0bxVwGt1F2LYKKADYadxbLUxkPo5tGdWM/N2fkTfQo+E10z2xYTFj4Bj18pCHRaaCDjiZmG8gdo82San8EjvQqTrMFSV9x9P40iBHHEiw8fBacgE5Oatoe8iGwR0f41aXl1yhBneMigzpGVD6gfZgN4jOuRbsx8/ywbOVczOLc/jrpJkQcYE7P
 DNHCRjRj
 sYK8F7jR5o6gHCzv0PloaLgyxFnIfoAS4bKdlnbPwHLjhWCvSTM1FV7BA0oEwbmd27ScZdzzn26lnnT6+Bp3v6O1juO+W++43ILe8Pp1trbh9JgZcZC/CWCXFHzNLjf9GgBPJBxuJ0q3NBqzXlwzlf9dD6HQ6JLH3lVQ3vJwMtrCfj8zFdBvI8h8uzhBMS8v0+LygjwV5T8W521aIm3YVuuanG6Uj0jau9Ud9AvDrOMR8a7HbjyidroxfOQ+eQPPK2qeF5UGPpxzMUvUggCEwW7BktDTbadpzGtGgNoxYk340XwZwv3WeS6rlF0B68u1798RFBVb6R/JMPphlW1OicgkWs2YnMTI7Pxdrs+7P093OBK/Abv/qHVrbykDtlVNJbZXURcLIwZfGEK1UbqMEj17j5bXowqBNADKocxu0cyy0GLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 08:44, Xu Xin (vivo) wrote:
> Add a new sysfs attribute, /sys/kernel/mm/ksm/only_merge_zero_pages,
> which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> pages with the kernel zero page and skip the stable and unstable trees
> entirely for pages that carry data.
> 
> The attribute requires use_zero_pages to be 1, and the two are kept
> consistent by symmetric constraints: it cannot be enabled while
> use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> off while it is active (-EBUSY). Both store handlers take
> ksm_thread_mutex around their check-and-set so that a concurrent write
> to the two attributes cannot leave use_zero_pages=0 and
> only_merge_zero_pages=1, a state in which ksmd would scan and checksum
> pages but never merge any. The new attribute can be changed at any time
> and is only effective for pages merged after the change.
> 
> Benefits in three aspects
> =========================
> - Memory saving:
>   On memory-constrained systems such as Android and embedded devices,
>   zero-filled anonymous pages are the largest source of duplicate
>   anonymous memory. They are produced by userspace allocators: the
>   zeroing of freshly allocated Java objects and buffers in the ART heap
>   (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
>   preallocated media buffers. Merging them with the kernel zero page
>   frees a significant amount of physical memory, which matters as DRAM
>   costs keep rising. With this enabled, we measured 100MB–300MB saving
>   tested with several popular applications on aarch64 (Android).
> 
> - CPU overhead reduction:
>   Merging only zero pages also reduces the overhead of ksmd. A page that
>   is not merged with the zero page carries data and can never be merged
>   with the zero page, so there is no point in searching the stable tree
>   or inserting it into the unstable tree for it. Skipping those tree
>   operations for data-bearing pages reduces both the CPU time and the
>   rhashtable memory footprint of ksmd, which makes zero page merging
>   practical on low-resource devices where full KSM scanning would be too
>   expensive.
> 
> - Security:
>   Finally, this shrinks the KSM side-channel attack surface: only zero
>   pages are ever merged, so the sharing status of data-bearing pages is
>   no longer observable through KSM timing side channels.
> 
> Note
> =====
> - Suitable for Android, embedded and low-memory devices, where zero-page
>   deduplication is wanted but full KSM scanning is too costly, and reduced
>   KSM side-channel exposure is desired. Many handset vendors may prefer
>   this knob, which can be used as a default fallback policy.
> 
> - Not suitable for server and virtualization workloads containing many
>   non-zero duplicate pages, where vanilla KSM provides better memory
>   savings.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> Reviewed-by: Huan Yang <link@vivo.com>
> Cc: Wang Xiao <xiao.wang@vivo.com>
> ---

See my reply to #2. I think the overall feature makes sense, but reusing all of
KSM infrastructure just to deduplicate zero-filled pages looks suboptimal.

Please investigate how we could selectively reuse some pieces to just scan +
dedulicate zero-filled pages, avoiding the whole rmap item stuff etc.

-- 
Cheers,

David

