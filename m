Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0342010F92EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB546B0096; Tue, 31 Mar 2026 15:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2736B0099; Tue, 31 Mar 2026 15:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6107B6B009B; Tue, 31 Mar 2026 15:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F97B6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:23:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FD468B536
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:42 +0000 (UTC)
X-FDA: 84607332684.25.E8338F3
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3A598000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ZYCfXx3+;
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ZYCfXx3+;
	spf=pass (imf02.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774985020; a=rsa-sha256;
	cv=pass;
	b=fyqFNjF6q20cyxwF461QWq+Io9wwTAH86Xh5GiqTpZhQGk251YYULgVBl0JFir5upt0odC
	qKddXTxClVHVzzraWmLq5lsFqExPDXHnSuulLis4tGX4XaqvXOM2YXyjDSpLv1oe+elSyz
	YFuJDZoJ3WAPtWqGIdpXXA0DZezR4ng=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBDxXYjZajrxzzN2zbsP/0cce6TF0J86eDUuZG2QDlw=;
	b=VTpYLk0fYI9jKPC5rsdNybgo777OlOR4/1i50Rw2Uj3m/F68SX4wxTuNp8v0ZsVkogoN0a
	Y2BQHmb4oMlZ9wYWsMMQBFR9+cap9vfNYIKSmOsOHHa7Na6oC211wWp01kSEspBV/bF2IQ
	pnav157X9txvjLoc00TwncNQm70XMPI=
ARC-Seal: i=1; a=rsa-sha256; t=1774984998; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=aX9oOwmj9AEHTHiRlLGZIN2zFmMLJj3vcIaXbjnApQDc82Q+bQ+0/lcmhOdLGM6ek0RWScXRUxePS6UgsLjfR2IQ59dcioqO2hS5UUwASdZY/X12m3ya6Waen8CwLrcbUCHeN5sj90UzrgHbRaTGRJl0zDvMvwjuIwNiUl2vpIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774984998; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yBDxXYjZajrxzzN2zbsP/0cce6TF0J86eDUuZG2QDlw=; 
	b=XBSn/9Ha/06SUjmIY5K81SwK4VG7IbtltcBEHpAGeADAKlQxW4cppbP/RcLkQ+9UkMs2KeDEA7Eg8gxFNde1/A8p/nrhChAeBp7/4EgDaEIld3gSJ/PpoaWfNeAmSRV7qMkAJmMhj94MZrE85E3tKCUn/srRfnlgmvkyukPn+bg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774984998;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yBDxXYjZajrxzzN2zbsP/0cce6TF0J86eDUuZG2QDlw=;
	b=ZYCfXx3+fwgO8RIJafF1FEBEu1zWstO+x6cq7TPXOhBSLTkNkHUwWJeKMMnGAnvv
	uOrUZDQcW2A9uwxB/j+FDhFQjzJbbVjmJAL+Oku1Ru7dM0UF9Yc9PuS7w9BoW/W7axe
	OWhoVIHqgryeGczQYBS8Ip2LM0qLDdfgmCzB37ZI=
Received: by mx.zoho.in with SMTPS id 1774984996747280.013428865071;
	Wed, 1 Apr 2026 00:53:16 +0530 (IST)
Message-ID: <e6587458-a81c-4d85-922e-ba7e0a5aad25@zohomail.in>
Date: Wed, 1 Apr 2026 00:53:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danilo Krummrich <dakr@kernel.org>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
 <acou2CsZOUQPx5nW@google.com> <acpsKv-GmaYj2Bmx@milan>
 <f6f04017-3dcc-49af-b875-05a9ed4f4dfc@zohomail.in> <acwJe5yhAt1M7RfJ@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <acwJe5yhAt1M7RfJ@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3A598000E
X-Stat-Signature: 9m71p1wisufkeuo1n3piznu3iudze36b
X-Rspam-User: 
X-HE-Tag: 1774985019-49818
X-HE-Meta: U2FsdGVkX1/ATSWx4CVdjm/d9B8mzD75YD2vkBu3n316PaDl653La/ask4PoUP8RTa1mNe37wkCfPjsstHPiOIJwfM6crsN8j1UBO/pF/YFFTh0KoEBd5w3pmq/DZUb5IwGPnqXKQND8dgxITZFJJHah2oiUNfaRTr6v/xY4WIkQ2axr6pHSZshHGdZBbbv6V+wnmavCMtdbipx9iaBpMu+D9ppfaGfcYCOJES7qdjLE0sgjQ2pIKSJZT3kWFCaDaWkpuaMO6yZBm9T0RCpFKgwOVm5+ePfYtUss3iywOVdQ/c3oJa27kjZR4jZd1x1boILTDbzMtCl+0asgLyPhjUvbF974XuylR8U96dlO6Q0oXXHlP427aWnU0qYQPlOAWdNFueigKbbhW4fQm2PKG7i//kv/dOdlca5q2QxNMYZWseUWdYE6/cApLBgBezreHpFIfhK8uIH/mteGfZX+3HZElMlUas0W4g/O9l9YxHh1jTH+5Yc0u0VvHrNbHG4hF0O4p7Pyu0s3383EXdt+dIDbuEIr3VG8z3m+XX1gbOZIfKKCAo7LRb51YJ2FCXlvOCKc2oC3YkoWj/dCLDPzXWQlXwwzXLxKqaQPta+9d/tfgtQ3ii8yatT2ZlguUqvjCXqZGgtDaZw2E69XFIlbLCb6QgjcTKmgV6x+kT+WJSA9MPxOPSCVCAYNCNn/sqRAFp7OyIYlBzE/cGf3L0M+TDtef9pdra96Q7SHwqHHCBz5C0EbDv1lBqRTPDyoqj5Yy7qgplCX+ok3zTiwyWa7mE3NtPON+qLLqK/J7acQSfE/C47bLyMPUXXcSzaCoBayOt31S8YXu140ifc3YXd+NTbPPEqfexTJaY7YUD1sLjH/iPVc6oUTPhUOL6mgpuE7U5lV2M1wv4h05Req/tUHdPF6vj39TnT7vOE/PF+fSWoUKSkKO0/Sa0sxZlZDuM0+iK+Y3YsfvppW7+Nqpqs
 qgwekl5Y
 g1T/tlgrB+VtNHxdB8zOpN5hmRPqEXh9IlZFmuGzBkGPLFHWOJctRM9LFcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/03/26 23:20, Uladzislau Rezki wrote:
> I have added some comments. Please have a look. Do we need those
> READ_ONCE()/WRITE_ONCE()?
> 
> --
> Uladzislau Rezki
You're right, the spinlock makes these redundant. I'll drop
patch 4/6 and the WRITE_ONCE in patch 5/6 for v9.

Thanks
Shivam

