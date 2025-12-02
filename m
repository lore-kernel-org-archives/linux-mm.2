Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573ABD116F5
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 07:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B380D6B0011; Tue,  2 Dec 2025 02:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F4B6B0012; Tue,  2 Dec 2025 02:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CA06B0022; Tue,  2 Dec 2025 02:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93A706B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:56:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D7925123A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:56:49 +0000 (UTC)
X-FDA: 84173774538.30.14D02E8
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id B4CE440009
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:56:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q3Zjo40W;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764662207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCswqFTvPnxysMNNAE72TpXQ4Qg0y3bXmBxEFvbbCKw=;
	b=TUkqFN8fFCts2akck3KdQH/lDj1DzR9+a48Gaj2gbCTekZR9I5HMYKXioBQDIezuQQEm6a
	ao9JvSn9ACgfgYhTjP2RGHbC6uru1+xugMlJWl1/lc5l5/jwRxR0edMZfq+luBYeuxseg6
	yJdzPKgB/jN4sV/sqkuO5ViEOb/cbVg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q3Zjo40W;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764662207; a=rsa-sha256;
	cv=none;
	b=gSpvzQOOC/EDKeZQO7sIhYfS9I4xhkLFFDtfQgaQftkW+qv+Xd1BV5zZlv6uqMf8mrx4pG
	t8rfVOaA/pj+bVu6xEdEQBh5Vc1sTJZoTDrh3D3PpdbEA2UMtU7HGE2//EM1CuauucbvaJ
	FwBuDFsWexrM/rxliCq7dKYZ0H+DS7o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764662202; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vCswqFTvPnxysMNNAE72TpXQ4Qg0y3bXmBxEFvbbCKw=;
	b=q3Zjo40WJKQkozRy+DImomLqrAHYtw/4psX7JfTusceOlazbjsrrKczSE+PRMWQM99KhA77xxiLudDb4ZpgAKdQOAnhgAg2PEa99+CY2yzRVnHt5xVHgOxqACrwXY1wP8Kqj1kADSC4Mz6gwm2LRg8f+0CbvVfmuLfI2vY/4Hss=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtveNUi_1764662201 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:56:41 +0800
Message-ID: <c91f8c76-ca5a-4e8c-84a4-1b91b150e202@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:56:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251201185604.210634-6-shivankg@amd.com>
 <20251201185604.210634-8-shivankg@amd.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251201185604.210634-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B4CE440009
X-Stat-Signature: 6eouctdhfbhf61b1c4hd8w6cx6gocm5o
X-Rspam-User: 
X-HE-Tag: 1764662206-27843
X-HE-Meta: U2FsdGVkX18eXK8grh6QZNgyTaTaekFa6pDNot1VvVIaYBmFNPgX0mBV6eB8fRB5l/1yjcCKZYTm2CCJqRtdeS/SI0vmoiBZVx+PjfuRTbsWQcA+NpCI0CFl0cZ1QvxKdW0NIMFA6cpdMNJr/nDkY4QQyo3p4oOHTjAFb19b9QQyApd+7AZ1FJmgtuol+dPC6e6oEm0ayBNq5iTBSU4iDF7F+qDhNUDdL1pHpdxfr5FgguPp625sJ/CBaHiPlDiBIpnHKYfN2IxlwE7WDTVy0orGjc1ArWn1lHRsPQijKKfXIzb+ckmvvtQMpIm7ncaXOZ+iu0XFBAKlhxsYzs38G48n1YWGL2Q4vywscSqNB4xyXVLFoXt/bWgB8I4JyHu4uMzweBP/VXwmSDIH2WSMfHGE1busQXqgIK5H0pXo+AabYI7u/5PClzPtQT5RXuQWiE3eOYRfsuC93g6zpuA3+ZYtjkZMsvt+odu44WBCgBfLoiIqdVNfH9IDRrTVYiFw4CteqoGKl6I4ASi/ZMVWvVKbkxOXEOQSCFffpfdaGQ0DBo0qgVk3c6CzC97CX0jZZZg1Y4+ZTPBa0rXhZFXTryRhkP8kEVpbkZyQ/xeaCx55dqfewy7D8rTx1J0qLsLquMP5vvP+Gtz+z8Ai11jAKeJZtYjkMCbfDFUcrXoBrPW8SfGTeGBL6A7t9Cqm4T2LZJlbogWEPuoHwvVjYowVoR3hTpsbK9Rh0enA7qD8fLIDRVmaZbk1Q0ITb3K2N5gTXBx/4Ab9aiAPLojtAC9wamXPOrKkmlchWkHpDAy2ERtqyvAnz3CYs307fkahe+yuc5AFoX2+7qRm/CB+FgT7/hmfMqXQSJl3PgwplSoi7iHByRHR9zolGkug6UH+m3hwe6Iq8b7L2X3iqjf5ijflGsfyr7p6Rs4W4qORMsnjl/u5twV5VQPivvEQ19vT+3U/0UJNAPN+hV82pXEqIlK
 wF09weEA
 3IEip81p2pKwV7WBA58lWd9fCGsWhnLNg+2axe/kJqZdS6Oc9z1Qvz/wxJl/f+vNlrw9KQnDlfShUYRRuFBFF1BG7K/be5CRcUKcKl+FCqOth9uRIDvFCSIXnMvYyolfgWGxc7sMCKieILFaRg6lbRhWx1EfxrBhVhjXXwz0MWurPlRIXP8SY4AVyI/7ihAbJeHbglBMAfjHps1OrKtkvc5ROMzni+uw4jj+qrxVS8UeX5pN71QwZfTPpjZycPAEvJCqKVV7eFZ4WY45Z3HmaETttmek3BYfHBX49JPCST04Tu/5S8qEjk1be4dg76xMrQa2iRRo8eib+uYAWVDNqCKZY2ib8A9L3p/kpFKBUheIJCQ0+WPdB7ptdqwt06pi2nJoyMiULXajas75Vt5P/43cXww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/2 02:56, Shivank Garg wrote:
> When collapse_file encounters dirty or writeback pages in file-backed
> mappings, it currently returns SCAN_FAIL which maps to -EINVAL. This is
> misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
> pages represent transient conditions that may resolve on retry.
> 
> Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
> states, mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace
> with a clear signal that retry may succeed after writeback completes.
> For khugepaged, this is harmless as it will naturally revisit the range
> during periodic scans after async writeback completes.
> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

