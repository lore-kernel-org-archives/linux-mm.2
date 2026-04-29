Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F7DFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EDD6B0088; Wed, 29 Apr 2026 10:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7061C6B008A; Wed, 29 Apr 2026 10:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648CD6B008C; Wed, 29 Apr 2026 10:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 525F76B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:56:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02B6D1A02E4
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:56:56 +0000 (UTC)
X-FDA: 84711895674.16.6EB1430
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 483C21A0015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:56:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aFmOTWUC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777474615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV5ezDpfAzaj+HhnmXIFAIrHyvrm6mpa0CGHaWLzs9o=;
	b=GQ36KL4DlrusUOjNIyTGzklTcsvsdtV0Pavd6xbOtZzNVYv54y8Sey36HGXk7xpOmLnaY7
	XgA8qeM6CTD4kRam2Qiery2DMwSBzgO5uGu8ytlANdHfz8vXAmuf7+b6oB+Vx5c3TOZAc6
	Eh/cbpkQZUFgos8AtPshb3JFBmcqBhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777474615; a=rsa-sha256;
	cv=none;
	b=Lb+5cHa7IrtrL5fxq6pBASGP4eVXXqEllP5vC5PQ1fw7k9HhNqjUNVZl4V8nqmvyUklhHy
	6AryrsD85JhG6AXVknwZFK5yd+YsXeurlNYKyrPsQPI3m0UIRYqp9fK6Kr6QU+p18wEKZ7
	pqjU72INOByYqHugeqof7fSI+qewz1g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aFmOTWUC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1346024D;
	Wed, 29 Apr 2026 14:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A78C19425;
	Wed, 29 Apr 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474614;
	bh=O+4e7sz9Xcv4F2XUvuUxUbUs3ZS/nCd2chQb2PuT9Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFmOTWUCMYaO+P/jLi9PbVuQQj38Tx18wZNxwKEH57iZMOnJBCWRifAjdYjXZeCtP
	 eeRyFvOQ8T/5hQYertXDk2/Iv2By4abwxg+AZdRZe/jKNVYF+xsMjTFW4JtZoV+ba0
	 Qb7PgbUwN43cXD7vIXCJcikaxLwxBtJjV2FsgIwzgUvjqSwpw4lYnWKqeRlGOZ/i3R
	 JgqjIH8YQo2ixTLZIzNtFhoX70PYCJIi35mdYilkH2qlWdW7SVAxW+LyM5H2bp56JF
	 MIdwUsGgUD7LXJojE6rBD6FanBw3TWOQjMsyfli50WO50J+7vtgxiVje8f2Ka5OuaK
	 8vokQBK+MukXA==
From: SeongJae Park <sj@kernel.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist support
Date: Wed, 29 Apr 2026 07:56:44 -0700
Message-ID: <20260429145645.80675-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f09a287b-87e9-4701-afe0-929363937fd8@easystack.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 483C21A0015
X-Stat-Signature: go8jcqx87rawej7f93dtkriwq45qjpx3
X-Rspam-User: 
X-HE-Tag: 1777474615-534176
X-HE-Meta: U2FsdGVkX18TIOWrWoutIZeC/U1wfwX4VPNHzkqYfR7m9ob4julq5p8CIqD9UBS4CMizhw+CNIAvhEPfNS5RlJNYoTiEYQIbdl0UGPMD58vJGTYAs71vVxN4MVbb5bRuTafWs43yXNFesZ0Vm4K30EJkRqdeZTn5cvtSsfU0vNwuU35cFeZWWVmrx4w4POt6R5Qu39lSvEmz5nWDxdwXKfYTEkHLJNX2WvkFhEFr0lAvLK+xI9PWu3TpjS7SlSpr7cWcHCDS24Wx1HHwvlA9wcLX/c2HtmqSejlqiJ+4q3RfirxlWQeQCO2GcYTAAQQ+bSbJ+29vna+OT8AxXkaKANe7pD+rKTHbHRkcWIqUZwgEDxswbIkASqSBkUaO1kk9KY1bn7mc3Onk9kXjOINxxyjj8zLRfaJs1P9PlEe0tpS9Sus6aWfenuTve7OJSRJbDKuvZ6OAe+NzQ8lA+PN1A0aBll8xuTNr2ChdYfO9MCxpYCYtdSpTwJD+YORMM2Ik5Sr6hlYa9PiSabsHr2SBUfbrIpoecE68VjsTT32LtaZ/H5P6naIi/hEQ/rddq7MMK8yZqGEOxep55cFNMXVndZC/90eAX/rJofafzDgwHqcwSI5JpC8A/HshlJhA6TmNfzsv1BeOgfi8YSgAOIgl+SgAiQXbjtVHAO6ukL6J1o1XXKIfmN/YdSCywJ/S7TvFjJVRIh1V+t0HXn5bcvETC6U3vHi/qnd9ZIWeZmrUi2gLNYXAd+5WyN44QyjahmZzKKs+o+ZR3ZLihFt83R0wfgwtjMgnAC3JCIU7ldx8gyzisHdu+Lze++yYuNr2+G0nwNzDx7YgbvUs3G3a0yw4ZEYd9U6nmMl4rB35BDfxSTNU/4N++GNfYMehodLpK5LKCHjPFESwBD8ReIHXHw+Y/FQeU3JypIzRMNmSqrtG5qvYNjMHxRHLEKGVJNxO1ZNJwsxea+M4dIPR362uWQI
 NaWjH5Bf
 DHoP/1OD4qzapMIlmup11HlhL9TSkP0S0qvEEvuSIyk/T3N3rwfMQViuOrZS5V1muLQH/zp7G1Mn5Clmj7bXY79NUPg4GUxhd9ngKqqGJnebBpPTN9IcFPRgKeTUhKfDHBErwScUIOQpm1H7S4dc5Zt2M4Ukwx6YPQzds/xaWDML4itJyy16niCRkay4qiuPuFWc5rYwh2FmkBoRC+q/ynAcul2Na9aOqh68ay7jcXZ/7z1LG8zSjavZopY6Ccr7wNqUCiiCQLz8IB8oOMddc84bgotSrEfMbl3C9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 17:03:56 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:

> 
> 
> 在 2026/4/29 09:28, SeongJae Park 写道:
> > On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
[...]
> >> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> >>   	struct page_ext *page_ext;
> >>   	struct page_owner *page_owner;
> >>   	depot_stack_handle_t handle;
> >> +	nodemask_t mask;
> >>   
> >>   	if (!static_branch_unlikely(&page_owner_inited))
> >>   		return -EINVAL;
> >> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> >>   	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
> >>   		pfn++;
> >>   
> >> +	mask = owner_filter.nid_mask;
> >> +
> > 
> > READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
> > using READ_ONCE()?
> > 
> The reason is that `owner_filter.nid_mask` is a nodemask_t, which is a
> 128-byte structure. READ_ONCE() only supports types up to 8 bytes and 
> will trigger a compile-time assertion failure for larger structures.
> 
> This was actually an issue in v2 - the AI review tool (sashiko.dev) and
> Andrew both caught the compilation error with READ_ONCE/WRITE_ONCE on
> nodemask_t, so v3 removed them.

Thank you for kindly sharing the context.  Now I understand why READ_ONCE()
cannot be used.  But, is plain load/store safe enough for nodemask_t?
Shouldn't it still be protected against races?

[...]
> >> +static ssize_t nid_filter_write(struct file *file,
> >> +				 const char __user *buf,
> >> +				 size_t count, loff_t *ppos)
> >> +{
> >> +	char *kbuf;
> >> +	nodemask_t mask;
> >> +	int ret;
> >> +	int val;
> >> +
> >> +	/*
> >> +	 * Limit input size to handle worst-case nodelist (all nodes).
> >> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> >> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
> >> +	 */
> >> +	if (count > (100 + 6 * MAX_NUMNODES))
> >> +		return -EINVAL;
> >> +
> >> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> >> +	if (!kbuf)
> >> +		return -ENOMEM;
> >> +
> >> +	if (copy_from_user(kbuf, buf, count)) {
> >> +		ret = -EFAULT;
> >> +		goto out_free;
> >> +	}
> >> +	kbuf[count] = '\0';
> >> +
> >> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
> >> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
> >> +		nodes_clear(mask);
> >> +	else if (nodelist_parse(kbuf, mask)) {
> >> +		ret = -EINVAL;
> >> +		goto out_free;
> >> +	}
> > 
> > Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
> > reused?
> > 
> Yes, empty input (echo > nid) works because nodelist_parse() handles it
> correctly. However, nodelist_parse() - which is implemented via
> bitmap_parselist() - cannot handle "-1" as it's not a valid range format
> and would return an error. The explicit "-1" check is necessary to 
> support `echo "-1" > nid` without returning an error.
> 
> So the "-1" check handles a case that nodelist_parse() cannot handle.

Thank you for kindly explaining the reason.  But, do we really need to support
"-1" input?  Couldn't we just redefine the interface?

[...]
> >> +	debugfs_create_file("nid", 0600, filter_dir, NULL,
> >> +			    &nid_filter_fops);
> > 
> > Why don't you use 'page_owner_' prefix like other fops, for consistency?
> > 
> For consistency with the other file_operations
> in this module (page_owner_fops, page_owner_threshold_fops,
> page_owner_print_mode_fops), I'll rename nid_filter_fops to
> page_owner_nid_filter_fops.
> 
> I'll incorporate these improvements in the next version.

Thank you for kindly accepting my humble suggestions.

> 
> Thanks for the detailed review!

Thank you for sharing this nice work, too!


Thanks,
SJ

[...]

