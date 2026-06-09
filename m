Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FBDCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E913D6B009D; Tue,  9 Jun 2026 05:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41D16B00A0; Tue,  9 Jun 2026 05:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30E46B00A2; Tue,  9 Jun 2026 05:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C224E6B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:52:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 708851C2573
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:52:31 +0000 (UTC)
X-FDA: 84859909302.17.9604F20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81C9140006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:52:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdJ8oAhD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780998749;
	b=fpbuY+rKojgtRr6o8PqC+O9kOmG5FApTqZ5/is3VqBViRBEqmJ8I8HvGzNEOaqhlunz+oX
	uQqYvA7QX1nMThGdp+Lj1p+WmhKU42nxu8zB6p3rfFNAMDRXTWUsRnkg/qwz9c0pvZlb/Y
	DK7OWDd1mc4P7wFAiV2MbapJoDEcwRw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdJ8oAhD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780998749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5so1zQzA3lUehIl+R5tarTFJddQnlpvCs0HLxFL+tjw=;
	b=qW1QyQXyzRXPMeJ/DCweJBKiC/HuLesc9XOz6d8rrkLcViLBonifyyfoowRyVUx3rlKzpj
	Taj0krHJGgUBSZsNuzCEFb1HOrnJy8tUrc6Jn/Wj7XR1umJ/i0titxGWsykVMXoqo4BsG8
	Nq9N9X3su3dTyTn9CKQDLnITfIcnDg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 447C44003B;
	Tue,  9 Jun 2026 09:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2671F00893;
	Tue,  9 Jun 2026 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780998748;
	bh=5so1zQzA3lUehIl+R5tarTFJddQnlpvCs0HLxFL+tjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EdJ8oAhDB4jlPL/ZT5bVbmQ4zOqZLB12oMWuGtKw+P8SplpmGHTGwEO0fcqSLNmfD
	 yCBR2segffkcKQRFslMscamXUNBoAaa0orR82Hcj5S4BtvPQCy2aLkwO0zR6kbSdim
	 IMP7XPNy7zmoS39snomGHxew7hNHYaP8KDBx9M03nh73yc/zDlLXfJYt7acD1WB2WD
	 HpWgrQfhC/t6ajYRTsHB+wvNjNPn9dAoWgBkVCr8Oz59MfHWtZO/GDzppWXdmUoZEE
	 9YwQkkV0tv3FH7f8+ryiiWrun2Hih6kJ95ueGldYFy/y0nHO7ByioCA8wVnxqUKXE7
	 7/x9XMEGUDXQg==
Message-ID: <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
Date: Tue, 9 Jun 2026 11:52:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] mm/memory_hotplug: export
 mhp_get_default_online_type
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-4-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605211911.2160954-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81C9140006
X-Rspam-User: 
X-Stat-Signature: xxj1dwdgeog9t93gpj9wjqjzrudqo47w
X-HE-Tag: 1780998749-66740
X-HE-Meta: U2FsdGVkX193DM6C/6X9nmXz0HyYwGB4wWC0jT0yDqF6MgAgyMMgsNgjz8YfRFQWlNVe+F87INzp/cvINW01f1G0crkGQ82ZYmaJfrhQLEG+YguWgeCS/uCcuXad2JxJEHbT9YH0Xjh0lGa4fG15lehCwiTy+l1h5dGcKzd5focgtGLuLygAc3B9Kmml/AJSV/Cjfp9T/9STChop8gX6DuqlQs4OsZlDxS+N2zmtpdRmIhtbW7TwHmLSVcnAYBa3auAggAy0cq1Xw7ifTcBLe9xxYwPTZEn6lRDNGFR0zgRsu5O1+Xp8225j61xh/PtdgnkoQDFuGoIIPDzqOUCntxKzEB6JnJOA54hiDv/2bgTaEuVornqVBpvn5KuofhsQC77f3dAm4SwdNFf463lUkjjjXW3dolVVTkaFJ8JGiRCJDTNZ7S1Cwsz2LEGeWI115jfxiKsu9uqvCYSqX5Zo03jtNBK79GHodJ2Aek1USmpjpP0aGJ1ivE2/0t75M91jMuKFTNOtPANs9w7Ted1BGYypsj2t1AUxWFSW+DLkb6Y+dNplEjsMk8KacvjRD1Q4gBfYv0QjnGxGnCpyr9yf9jkk2r42DyPA0FN4vrdzTYWVpLukjhbmv9OJEi4hUfyapoaZ9cRe7RjGcgWo7vTMT8CuFLakuZT4WwO1e9fJijieknCWkbEXLEhuDN7PsymcXiZUBQy9wGAx0z1WFzEqP/ol14R2g1EN/TWBTwzVtTdRm3ALd4bv4H5W42i1HPJ/4zepk4m7uh8rKuYHrHf8c/c8BbnsHLCH5refOMuoq4l6vRZMUQJmtKpSdM4LVuJuCHgwlUndVrptcggJC9E+jWrCuOgNoFZdqdca3OYPNN3aSkv6thQAJd7eOdSp59T3NGNfmKtsfb3rUQ6u5TYMfOvZVEC+yA+qaLG8YOmKyWjrEoKotzzPJJgs7DEfRaoPxWAMNU3vdVJKn6/pJZC
 G6jOFWuD
 mscshpLmckrSaBZL8nqTDsA00ZKir5H4t86sWS7MzVbi8fuP1Kjj3rOKmcrZkG4EMyCU6UFbag4LVENkZembXVuRnyTFAQc41DFZmTx8euqzMZw75FzKOv+S62lSxUuNnQ0hRzPT89VTIt+syfGjBJA24utaJYW5BnXgLGOjEBbp7rfRvyqc7bPiA5AlgkigsRcuF5B058x3j/tpp4BhICJU98rvyEg6dJtc/9eYf+GoUWjc5mt4yxCA8dKhTF2mliMTqCQ0UVfgId1MNnyc07DfG8+l2VN7FMo3BR5HiRSeFVPOnP9oHimPODteAPRRQ0yZRcPV1f1JrINU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 23:19, Gregory Price wrote:
> Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> and the mhp_get_default_online_type function for hotplug use cases.
> 
> Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> the same driver code, and chose the dax_kmem path as the default driver
> path - making it difficult to require hotplug as a predicate to building
> the overall driver (it may break other non-hotplug use-cases).
> 
> Export mhp_get_default_online_type function to allow these drivers to
> build when hotplug is disabled and still use the DAX use case.
> 
> In the built-out case we simply return MMOP_OFFLINE as it's

Ah, you mean without CONFIG_MEMORY_HOTPLUG

> non-destructive.  The internal function can never return -1 either,
> so we choose this to allow for defining the function with 'enum mmop'.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

