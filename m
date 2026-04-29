Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88864FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 01:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46F56B00C3; Tue, 28 Apr 2026 21:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6F56B00C4; Tue, 28 Apr 2026 21:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D886B00C5; Tue, 28 Apr 2026 21:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FBCD6B00C3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:28:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27A271C0BC2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:28:14 +0000 (UTC)
X-FDA: 84709857708.03.750FF33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8FC00C0003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:28:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvMszETl;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777426092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyIvIefmx6kNYim6Fbjf9Q+3CP2IL0Bd6D48Ee1qRvQ=;
	b=MBjLPoLdm0ggyc0cO+eWCMeCDNyrc692iI3GWUQZ3j99gPLZBavfa55kXx6UeGkYDV166k
	S6i9w67EEw0zcTH1xaK+lB8rpRcwur+yp1UxWDEYhrkCl8H7BHgsQel4iVOtI4F/qjjlG/
	PDBt/wkBjUsn1opcauiPAl+uu6s/SS0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvMszETl;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777426092; a=rsa-sha256;
	cv=none;
	b=GQMEYHzrMY0PzLSR3qetUibGodR8olLHSYeTVXg4hz1ir7e9dA/Tx8k6X+rdapdhHsGA2u
	JyuX15wHwQHYqPo6h5RO57vCQMZQ8VbElXz3SkjyoPGI/raGgFXyh7mzUVpWAA5RDmT0QL
	+Gf1AehL0bYoRozPjDrdJC9XruF3DYs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E908C6015B;
	Wed, 29 Apr 2026 01:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9FFC2BCB7;
	Wed, 29 Apr 2026 01:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777426091;
	bh=hPmW3aRW/dS3Mxdu7xWuh9u96u1FK7Av/9Ub98It8dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvMszETlUwA4QkD/70hzdFhRtsxr89zs9j36DsdTApcyDEUxVoDPL614p1Tql/nbO
	 2BstWktSObWkLKyFzon8hqjSSEvXfnSxBS6cnhZQpKaQdnzS4DbO9L88zNFNhTvuzs
	 BicQ61w6PFUxss7S7hE+n1Z52udiTv+UR0VtuCYM1PD0WDz5j+AO9HoMZf2e5Xsxr2
	 Vx/m6lirxrkxcnpiHOO7/izhA56dPbvSkOkgHrtC2+9/jTV6H2wbIaPqhOjeXUU6gm
	 LKsXiZQ9ZBakjYcc7S7p5HQXmiC4C29vJ20AqXZ4keboX2kOAip/jF2AnzG/5cxGMa
	 WwTBg7TNWKMsQ==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
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
Date: Tue, 28 Apr 2026 18:28:07 -0700
Message-ID: <20260429012808.88831-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428071112.1420380-4-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FC00C0003
X-Stat-Signature: ycm3rp5zcrr4inganxkxmge3d641n93p
X-HE-Tag: 1777426092-161149
X-HE-Meta: U2FsdGVkX1+E8go+e0RM0NSCvVozTDnZX2R/+kc1S/yI+zaQzZZqhQ79sVuzszzkWzHmZ2DXutCpxpFjPE2ptgD7hB9XdV2P+g4WHpdpPRQlrHQFvPefVFXFVxy3jpEg6ic7+u6VefX/YbdOznhKFrFIxdqNUsi3p6eggPewiSqTMvlUwBwapwQlh41fhrdAGly89gw1iXbD//iRrUHAIYa17hfxcUo4PQcVj4fUzgzdV88Bwyt2hAwkSKGBoCVzjT6oEz0Ga1Rpjel2n4i2TkH4xX8asii0JYaNy/tWjLm6y+/Oni8X1aNw2IGlZIH1v6mp1gKSX9fEa4ccaCye2x/QXYYtWXbKTSUPygfoMaBhcFmGuW+WCBf/YUSp8KBHXbxmCkXGJ8DKTUhi9rdSk9oUI+WqU79oluktxH/wKuYcVgTn8xhM3j/fyu5mzaeH/hkqKbvUdPAje1f3pnqFvku7UkQJYqejuAJXLInD+l7AEyZfre+aME0QG+s/5OibmIBbsizPRzd1QkeFgdmWwpVRbK1HkHs4kTa/DiRPn74/LlK8uqk4ZAPg6bB0z/eK64b70im8arC0VNcYGE5VpkVfP5tqXzkzm21bRNv2EEIZNw0mGvfZzX4xA+j2ljNYRZBvlFzI0jB2tXjAPniiq+RzmCZHV58OpEAuFNj7MOV8Nbv/GHnr4b9HSfwCSt60EfE26lSoqMJ9LlwtQBbeDfY6hv7WA1kEdI/t891WnKtQYMRNLlgRiCw6ggVkP9q+ERRcda0y54VfryHGPNaEP2+9BtzNbEvwaJQ/6hvp9SgfVaV84kADIt8QN8Pt4S75nqO2jC4VLBfHPhAsB685Ef4PyS15Q6u+cXl7XDj1mlE16EFyDErG+ueL/BAHZ8D5r5zin6cogd3GcueR9Ii0CsYtAPMuM3/tonlB72JFT6iRFWylYBvu4PsEbK1Dpad4PVwucd57xW5c8Ujp1cg
 8q0qOalW
 tZUZ1WrWtjmsZKhoMVu+zYcubZ7KHl0H5O59dHoYqA+CrNuVfW9YUX1sS8Oc7vvYZyvjXyWq9bIu8mKyp3tmBQlquYzpapAW3rDGTBLIxKZDiQq+2qdywpMVx+SwUNmZHMFeKgLBS0S5+6Si5SnErtiV86cd4t1m01fBnPaK27HL8T15oQ6livXd11/zGkje8E8/zmpT5q8TLpXYbFODrzumWanz77jvGbXIYOK0DfKbG5/aRjt3BO7mAu66C207cvj2IA3+766ILeGVuoCHOp3wsmaFnKczZaiyogPa/bHV+kN+K5d2GNjHCO+0+qVUhKu2O3ihT1cbFVwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add NUMA node filtering functionality to page_owner to allow
> filtering pages by specific NUMA node(s) using nodelist format.
> 
> The filter allows users to focus on pages from specific NUMA nodes,
> which is useful for NUMA-aware memory allocation analysis and debugging.
> 
> Supported input formats:
> - Single node: echo "2" > nid
> - Multiple nodes: echo "0,2,3" > nid
> - Node range: echo "0-3" > nid
> - Mixed format: echo "0,2-4,7" > nid
> - Disable filter: echo "-1" > nid
> 
> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
> Link: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/

Seems the above two links are for v1 and v2 of this patch.  I think putting
those with the context at commentary area [1] could be useful.

> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
[...]
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 6d87b6948cfa..e674a374669a 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	struct page_ext *page_ext;
>  	struct page_owner *page_owner;
>  	depot_stack_handle_t handle;
> +	nodemask_t mask;
>  
>  	if (!static_branch_unlikely(&page_owner_inited))
>  		return -EINVAL;
> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>  		pfn++;
>  
> +	mask = owner_filter.nid_mask;
> +

READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
using READ_ONCE()?

>  	/* Find an allocated page */
>  	for (; pfn < max_pfn; pfn++) {
>  		/*
> @@ -730,6 +733,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		if (unlikely(!page_ext))
>  			continue;
>  
> +		/* NUMA node filter using bitmask */
> +		if (!nodes_empty(mask)) {
> +			int nid = page_to_nid(page);
> +
> +			if (!node_isset(nid, mask))
> +				goto ext_put_continue;
> +		}
> +
>  		/*
>  		 * Some pages could be missed by concurrent allocation or free,
>  		 * because we don't hold the zone lock.
> @@ -1009,6 +1020,75 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>  			&page_owner_print_mode_get,
>  			&page_owner_print_mode_set, "%lld");
>  
> +static ssize_t nid_filter_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	nodemask_t mask;
> +	int ret;
> +	int val;
> +
> +	/*
> +	 * Limit input size to handle worst-case nodelist (all nodes).
> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
> +	 */
> +	if (count > (100 + 6 * MAX_NUMNODES))
> +		return -EINVAL;
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(kbuf, buf, count)) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +	kbuf[count] = '\0';
> +
> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
> +		nodes_clear(mask);
> +	else if (nodelist_parse(kbuf, mask)) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}

Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
reused?

> +
> +	owner_filter.nid_mask = mask;
> +	ret = count;
> +
> +out_free:
> +	kfree(kbuf);
> +	return ret;
> +}
> +
> +static int nid_filter_show(struct seq_file *m, void *v)
> +{
> +	nodemask_t mask = owner_filter.nid_mask;
> +
> +	if (nodes_empty(mask))
> +		seq_puts(m, "-1\n");
> +	else
> +		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));
> +
> +	return 0;
> +}
> +
> +static int nid_filter_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, nid_filter_show, NULL);
> +}
> +
> +static const struct file_operations nid_filter_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= nid_filter_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.write		= nid_filter_write,
> +	.release	= single_release,
> +};
> +
>  
>  static int __init pageowner_init(void)
>  {
> @@ -1024,6 +1104,8 @@ static int __init pageowner_init(void)
>  	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>  	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
>  			    &page_owner_print_mode_fops);
> +	debugfs_create_file("nid", 0600, filter_dir, NULL,
> +			    &nid_filter_fops);

Why don't you use 'page_owner_' prefix like other fops, for consistency?

>  
>  	dir = debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
> -- 
> 2.20.1

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

