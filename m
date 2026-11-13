Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238FF606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JuSPFC9i
Received: by kanga.kvack.org (Postfix)
	id 322106B05CE; Fri, 13 Nov 2026 14:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1876B05CF; Fri, 13 Nov 2026 14:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA0A6B05D5; Fri, 13 Nov 2026 14:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E238B6B05CE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:07:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A143C0299
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:07:17 +0000 (UTC)
X-FDA: 85431028914.08.C50F315
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A453120010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:07:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuSPFC9i;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwMv7grpEl555CCZBDSZF02gA46Jw5m995wi0i9ijNs=;
	b=MCv9jlZyPBNJ7QnRmP9l+KF7hLaQjz6z9SXzT2MbFxBr4nIFVSUPeE4DaM6XJOOtaVlG6P
	nagoA5jLHQeoRFqdI3kU5Q8yY85jUfDkMrl29gbXRCCjm/ELqmS3Yav2JuwE3Bii2TDpMB
	jM/wEJL3Eou5EBrIS4FaA2Fv49JG1OY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596835;
	b=nOCmtyn09uNxW6VWhNLweEonaFASMCDjdv8GEkvHSmvsDo8V/0pzMb8dlpTIcdA9D+8M1Y
	B59LCGHNTEFZV8sve7fCwULQ5D4ktqb0J2cH2Cw1ns3gmpH2jBhqgpN5G7YQqxehJv2bYy
	Fu2XEEM73vmvt8EP7rdIhtgM007AYF0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuSPFC9i;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF18D42E05;
	Fri, 13 Nov 2026 19:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCA91F000C5;
	Fri, 13 Nov 2026 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596834;
	bh=zwMv7grpEl555CCZBDSZF02gA46Jw5m995wi0i9ijNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JuSPFC9iBr4JxGPim3WHrcQvErXvQ0HB+snWJGflClJaEn5XYFofSYwO9bQT0GlgN
	 iXg+DZWYXosSVrE7zSI+5ICFj/uUBCYi0NkV7XPIS0FuJyqRDvk/IcIIbG3P4XQ7N/
	 3SkQDFNL26xcUIis+L8UuMmhBQcwlgH3B4+uCmsYcRY505wLyXG2fNqfVJJFNd1tL6
	 tBYyFB6lkLv2KTYD9LD0dO8ITmKLSztLkXRMSSd7Axf0jxqeeHav+nB5k/OUuTMwtr
	 qVMVb6Bzc6PCfmrZHY2EvUapqwuqBC06ATe1IzQrhjvXT9kCBhHewB61yPfrVOKXAw
	 cc+817SmPGPGw==
Message-ID: <769b927c-30a2-4044-b6a1-f3716dd29350@kernel.org>
Date: Fri, 13 Nov 2026 20:07:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: extract helper functions for scan cycle
 cleanup
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org
References: <20261112125754.176930-1-xu.xin@linux.dev>
 <20261112125928.177598-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112125928.177598-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A453120010
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nxog53ct7ja6ngrg38bcpmrg9u6wsj6c
X-Rspam-User: 
X-HE-Tag: 1794596835-212001
X-HE-Meta: U2FsdGVkX180emDbZ7tWI4ECqsYCjTBBh6xSk2kQqhOec/A5DeV/0AfzuIZkVXFFPTmiaqnAxvSurhZX1ma8T/zLXAUubVKnfyNpGJE2wMhC9FbwGtFb5QrPuzTpqJiSStZQxXOo+1mzWY40HpUD/pey+TMu0sb5f9290VC0g26fOcpfaX+zLavJyyuWDoWrEB+9kzqOl68BSvC7tVtQgHYUOQT+T5RMBTOvr9qIOJLGwUL7n/gcFlPf/0d35UOny5Z7XUZmnLMEstqEMhkDPs9F4rgMTHrAnYdhPdJNaUAzXkrcNS5vCLJryjYQE5Ndn9i2grs9D43mBKG8a/Plv+HRQSCchsvcxvXdBEox/LdXwWzkVQSlzBuurHL/weE8FnndbVoP8g4QVftoY9QLnt2hCjeKVeokWLZ9a7mlusasD8YVL8MBcXzzCbzlrvo5yzogtHS11M1Iw2JBsz8KcBSldADA4vLmaxL1m9YZzup2HMib381qbFMClE0lrtv3/vXJ26Qt5MyuJ/SXfnfszBoQaoJzYhVLJNBoWbKQOfjCNRUuqrXPxkod47Wt4rUyWLo2No8Y6YnTqDwwMk58KKDOn4n58SEp2HrE5TIVVHMtTuVYz0/l32zBWASZytf5K6yUbTHSSCepBLcBBMrcCZTa8iKvWLAvjGqejLsOUsysfL35myCPVz+ON9D8AhZp7F8JoUcWChMATUqsPOrWVQRQiAkZkWnCxdlTZv5mdg7gjNKpH+d6klDobzPBPGBnylK7za0EA9f9vKh4MwFGVeCsLsVCxjvNN1wNLkz/ZR03X8rGXzW4XdDl75Y5A9ZVTDEB+XPF016Tk80s/tfO1SCIIBmPCas3tuVEYSlFl3S34DJV5h5Ci9WokkT/slOuK0O/ml7OfbPjRpex29TqRdpmi6t/NYGSMwKyXeqJ7POq/ZOf/w9Ynj2UduEA9v/wc+Oyd9+ymOuAxZHH5Rk
 Hewe2N+R
 N2NrDC4bJ84bo1m5sdEzlKDxeep2UiwnhqGw821yF2QTnMysQF5mIK2tm/AKLsIsT/XtNW5SNPqw40FFsw52OBvfTPpr2XaEBGTVLJ/Opg3HiixmndffuxPI6LxaPHRopAEbS5dZu4wIUlnKXNqYWG/sBbjfTbMT4czX6ltW2fAqXErzyWPJWnHXiTToYfYm3xpjN6yS12LEJ4WMbJ5hXNcwDYG+f4MdSDLAD9DyBEKpo7ktC8tK+0ZlcZClY9VATeEkxfTCT+P8qaIh+BvLGSC2Z2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 13:59, Xu Xin (vivo) wrote:
> Since scan_get_next_rmap_item() is getting too large, extract two new
> helper functions, ksm_prune_migrate_nodes() and ksm_reset_unstable_trees(),
> to reduce indentation levels, isolate local variables, and improve the
> readability of the main scan loop.
> 
> No functional change intended.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

