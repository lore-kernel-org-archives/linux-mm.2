Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB9A60A260B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5y8yjQQ
Received: by kanga.kvack.org (Postfix)
	id 87D056B05B5; Mon,  2 Nov 2026 05:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D3C6B05B7; Mon,  2 Nov 2026 05:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6066B05B9; Mon,  2 Nov 2026 05:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 485746B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CDAB1C4590
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:46 +0000 (UTC)
X-FDA: 85389780252.08.CBE5944
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E7FF72000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5y8yjQQ;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614724;
	b=uGZ70gNjpGV4Sw1TjBmGhVzOPot0y15QxPPJy1gHcRZpx76NlSnPqBG7RoBb2MB9GeLX9D
	EK1Ca4wCBwzkyPZlKfssUFNYEhkZd7Pdy7e8SDvxtmOSTImkz6KJKB12MF8sHYToPYoiH3
	GyPqieCyVn1lGFxdtglkCpv5btjwliY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5y8yjQQ;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku4DJIFwnEffgpIG2A7qNoS3x38uJEQQ9sfHn3db+wA=;
	b=doYm8VpcZ8/oqZmlLZNgrJWimtg77/q3sTzZlDlg9S74zI4YXf/Ll2j+4PIjhAyEgCyR6j
	C2nvBFap9ucyRknCegkUytCoYtaxN+/R2pXkKkTBkRimImk8kY6LBc14wF6wlx10EGqY79
	+tUPgbAJXQBcYrRZWXoB0Wc9p5UX5js=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AC7760F48;
	Mon,  2 Nov 2026 10:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8521F00A18;
	Mon,  2 Nov 2026 10:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614724;
	bh=ku4DJIFwnEffgpIG2A7qNoS3x38uJEQQ9sfHn3db+wA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=f5y8yjQQMwerAigcvpPDGNsDB3u1CJrfFpFBH2oKsWhJLCzrK6Yz0yoypJqXxpcEi
	 A2G1fUcOg1Rx9+v5IIaKoxNojTV07wC3i5zadzm4mKoPCGOUyddsDM5QkQouNFtMEF
	 esARtz/cC4x/0jw6TJzqro0ut+e3WfhMwgCnQlx861gZ0VzJJeI0ThV/5at2E4p1r+
	 Pnh3QQiAq1j8VYEFDoaGEPfXneX1AEVZrLldIsaXqBYFZTfWaAdbwuzoUsVkX7OIDq
	 GTJXeLrxt427G/Dmb4AXUhHH3TBl39ncxNfQtW15E9Mr637tK0erxlaBRoVidCVRCC
	 zIL8uCvOQpF/w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 03/12] mm: hugetlb_vmemmap: simplify vmemmap head
 page handling
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-4-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-4-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471104.1337633.5678514723773021374.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: wuse6nz81898g4koyaxh5fii6r6r7je4
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7FF72000A
X-Rspam-User: 
X-HE-Tag: 1793614725-657888
X-HE-Meta: U2FsdGVkX1+IsZwbhJUXbF6xexxsrorCSKK9jncoXyMKXLbzONP/9AGw6YN7M3pqAJiSm88EPJtVtfqXlSkyYpp3M1H2/+4/L+sNOAxYl23w8k7dn27TmbO3urfYnpYU1IHwWvWaI2Ltvst9O7qJ7EQWpANXLyxCzmRL36AcOVOhXY+rC6B7lmFq76WxiIR4kQJ+aU+bHZNC/OoVe+LT9kMTsuP1zNlpJDNhgp7eNI++uN05DVxdlZTVsNh2bs3DCaZxHgkN3g8uDLjENL+/3m7REvAbAjOlVMQbi5CU6ybt27YWUx/bXSRAss7Ip8YEJ9hOfYKu6IhmnXFY2F1VORq9B3TdgdvW3VR0YIiJTo9srLpD/45R3+yHqxu4oIIZD7gBLv+2xvZNjkd36GA4uWcx1TQDO9k3zU0GUxkFrNPfHWUz6wxjniEbu2Yeq3cVrFJdEZQF1SfY64a7UWAtmiXST5k6RyYKUMKpHZvdmt63P8KJJNu1V+Yffbp4s/lnppXJpr2eldwGedej5H4zfh4oQIXDdEsy+QeoGDUn7LnAp/iin3Vwi8ZfQeTNNjl+wxGh0XewrZhUstOi5G50YzBElz+vL3xhURHAlvXKpA3SdZOFVU1mCo/KWXxkPm9mKTlr8QRjG1bl2ue9kj5gt/TiXL8Ew8xm5h6DVaOWgPq1TXLosPOx5SZ1VKunKQ/heOsx0FDbJbsSsF2/rGMKk1QH5RxWfw7YdBdeXlZUBRoAVKxHaCI44l8/e01hvbERsU1zzmdb5fwTItCIDMQpdZC64FtdzKQUMjS4O90xvONL4ji7GFqw1DQFGvvWlZ49fljuzRy5m513UPQtQkOvjD0/MKulWz/qCmOBlFK2xlF34H9qpFDnUezypm8ElGnvxe8kAtfpHrgV5Q1SnkSq9X22ts01IBJOhYxQSJ7juMA55DBUoiG8ZkWfO+wwtrX8iNttdyryEnQxr3VoMzM
 8qx+ucZH
 dZ1Gfqq+IErwOi4wvoekQtjvges+gDCBMqEPcvIaGwrXPes/m8+aVDPj5CipV4sNvzyATb4dM3CDJVpfN7d7bVoDr4nMgo13A4pmNHrYn7+9zOowDepTEALxpi5ERDiC3tGoGYR2k5nOh45mEd1DVXmbW824zuJovB3U9SvNyW5nFaQjR9HqZbvOngrCwtClNqT/zWuHbOKIfmU2bbRtP3ZGWU5b4zl7bClicuNaMf44a/nwjDBasvhWwOsZec9fiTYdSTtSpJv4xkikJNMyX1W2X2UNwrF9yTt4g6J9w5Ybl0vp6C0IDY7Ig7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:16 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> The new head page is already tracked on the vmemmap page list before
> remapping starts.  Passing it separately gives the remap walker two
> ways to refer to the same page and unnecessarily complicates its
> interface.
> 
> Use the page list as the single handoff mechanism for the head page,
> removing the redundant state from the walker.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


