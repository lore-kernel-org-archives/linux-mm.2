Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE80E95389
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273D56B008A; Wed,  4 Feb 2026 06:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221956B0092; Wed,  4 Feb 2026 06:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133856B0093; Wed,  4 Feb 2026 06:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3A556B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:41:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3325514011D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:41:11 +0000 (UTC)
X-FDA: 84406583142.23.0D40307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 525B218000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:41:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYijZFp5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BljmRcoktCD2qt7ZkaeXoXsgqVC32NpeTphtPRxPFZ4=;
	b=Hy2sWZpGBxv0LQnoYX1eWJq1sbGPwj8eq+RIZzv0WWW4v3jQYdBT5FbV7kO9ATz1g30EY7
	KjfFanbnRsFT/q9ddVw0e/+qUiL/O1Cxio7D7JrmYDyzRABifNt1r8/Xsfqq3tiapRekA1
	MKieObYeGbcSOtFzzgzg/PSlyh7S38g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dYijZFp5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205269; a=rsa-sha256;
	cv=none;
	b=2YRTW+GCy5veIdXECqcFBvn4zdENRdPIlm0ljnAeWbqdpvbpivpcp0dZzjQWK1sOzh8oN7
	wil/gB41ZrVraIh4KAVMjccBHa1B9q00o09Qk818B6BCIDBUdKEIz6kqxe9//XEUedPn0J
	8nBdFVUKUYo6nM3Na1WISoa6kRbAPZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 469E741B6A;
	Wed,  4 Feb 2026 11:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C45AC4CEF7;
	Wed,  4 Feb 2026 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770205268;
	bh=A12v0h7gMT1Qyej/56bALNdRGCh0xkzjGTJrpw8FuF0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dYijZFp5vq6p3R6IoMNvHfswhtqI+ZHoRTUUoKz8ewJoYDbV68E/VhQpd85TzO96q
	 eTL9WZXgnN531UmBratkg9/NF7LphyE/g7k1JVU2cXL7tr/HE6f5DFIkP2QmxP4Azv
	 NKUVN6NqIj0/rzSWjz8HsaKUDcf4rD18M7exutXrIj3gQQqxfWQU+Q84Yq7GCHTCI8
	 csoGHCjOcjLyzhvImAaOrhHuyslANIzyxmH3APBmA2CI0mekRmeyYtOekL2fvH2fbq
	 pw8VPEoNSrKmCRLSYStmRaJCqa9H0fqwcz0cVbB/HV5bzw8PbH3ylIrEyqDAsCXHjQ
	 d9VyQhS19Gybw==
Message-ID: <f3fa9edc-370c-4087-a201-6419185a0e72@kernel.org>
Date: Wed, 4 Feb 2026 12:41:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fs: hugetlb: simplify remove_inode_hugepages() return
 type
To: Jiaqi Yan <jiaqiyan@google.com>, jane.chu@oracle.com,
 muchun.song@linux.dev
Cc: osalvador@suse.de, william.roche@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260202233617.2350734-1-jiaqiyan@google.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202233617.2350734-1-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3stey4q8t61nfj67qf31wx53iwbsc3fb
X-Rspamd-Queue-Id: 525B218000D
X-Rspam-User: 
X-HE-Tag: 1770205269-423482
X-HE-Meta: U2FsdGVkX19I+yKKFyDRF9oGvuEFqcbP4O8pK6rdJ3BrTDINAbYiUWJPtdrr7deB+lfaqDF2Sf2xycNCun7IUOlqHu9bSy/DpgoepKkjmR11aU/y1Ajc5zbfXmfRGC04Wq/RQEh8lLeu5aFFr+MlZgfJ0H4XmzpQsaTSF2k0O/K29a4L1vDMhTYN/f2yvUVlzySo7V+9oDMRw2h2p41/0lk+iw5uxADw0etEta99xHGmN2mDebkRQWJjNFRuZMXfuI6U+vVnhKmOs9rbX8uAPcBIFrvk4yCkg2VzGrfVTMZCRZeh3tERxloLn3LY3+ut0nb+RRUfH2iFVD/zVkqv1KrgjGi2Ywmz5Z0OtxsF1BUepIoflQYXQCZc0po4Ll2ghW1KaRZdeQJ9nTaBtbnHX5A3llysAh1GmYO/w3abhoTs3UyVi81WJvlJLcJWeztqvJYTk0K4AaU8Kdm+M4jm69adXrH4+wvqoo1dqyajMFZAxs52RbfpokzAXYtu1+nmgCJycKOKOvd7m/zgVTes4ykqJUerB1QLW/HKniCj7/y4wxXInwcfEC/0b/iiLUc/ZSowm98n7QxHc2kT4jYMdWXryCctSYcyNfefhBJD0Mbg7CSGs1J5NqBKRKd4bckw2T81u7lunAJ1d9WJgHkNn5c7Magz4WKyI3mBYHuNhu/bt7K6wZ3xrT/nKroHF37zfd4nj9x1jnfYJX3TbOS1jLoyFcJ1quPTQ4pH4dWnUpMZOcgOKCBiIOkOfZORyeKQecHlv1Uw3VBEnmO6eJSi1OePm++OKCF0a91oo8x47ADg8HDgIhjRpqrDQyK/a/gI9p7E/e5MPrSMbwUBOxne+7qrgZkqGrUu/qQhsWGoeE+d4BuCEnYUukzktB+9uTAwzs3GpngIIpMec2cJRBBDwmnkZjpX0TEtNbXZzJnHPw0mK0HOE5kzhgZub8Z/i48J9WoCKBrXddcnvdWsJzZ
 Ouuuccez
 hlmoOmbTVZqB1Kk3zdy/rf0gZ1sVrJFocMq+I7mkDrWUiCyRRUoZD3+lr4E8TwSZ7hm2jwe+AIK3uILsJ1bsl9t060SvRzeKLJ0PxCI96F5eoIJb3ytGNEPcWpHV2kp+RmKyX2G52iW0KBsBAXmFSdcFcGPmY6m9wf9VrX6fMA4Q0i355ZB5Cw6sxZYpCChd7byFp2GF44jxkZkm0Pl+LyWwsSylE3kA3md1DHVCI/ig/Hp8swbbd589CDfRlat2Djky06CxL1L4SWKhbnMQh0VhRTur4oF2/WzpiJIBKVbPsjN8Gomm4CXzs1QXAFUYXOBG/O41kjtglou9+acHfL/QS+1lsrJcILIUUXoXLBDphyvU2/feCJ53ZgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 00:36, Jiaqi Yan wrote:
> When remove_inode_hugepages is introduced in
> commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
> it used to return a boolean to indicate if it bailed out due to race with
> page faults. However, since the race is already solved by [1],
> remove_inode_hugepages() doesn't have any path to return false anymore.
> 
> Simplify remove_inode_hugepages() return type to void, remove the
> unnecessary ret variable, and adjust the call site in
> remove_inode_hugepages(). No functional change in this commit.
> 
> [1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>   fs/hugetlbfs/inode.c | 18 +++++++-----------
>   1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 3b4c152c5c73a..83d71cea7e384 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -515,13 +515,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>    * Called with hugetlb fault mutex held.
>    * Returns true if page was actually removed, false otherwise.
>    */
> -static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
> -					struct address_space *mapping,
> -					struct folio *folio, pgoff_t index,
> -					bool truncate_op)
> +static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
> +				      struct address_space *mapping,
> +				      struct folio *folio, pgoff_t index,
> +				      bool truncate_op)

While you are touching this, this would look better with two-tab 
alignment on second parameter line.

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

