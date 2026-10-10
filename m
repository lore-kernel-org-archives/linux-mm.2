Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8A4CA9EBD
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC246B008A; Fri,  9 Oct 2026 22:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176336B008C; Fri,  9 Oct 2026 22:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E9B6B0095; Fri,  9 Oct 2026 22:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5A316B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:52:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E5571406EA
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:52:17 +0000 (UTC)
X-FDA: 85305192714.30.39F786A
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1587320006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:52:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l1ILKL4V;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791600735;
	b=PD/kCzcPMMYuU4WApYI2+LdDZmF9jcA9jQRtbrcl8gK/4F016Okol+b9HLxIyUASiAH5Pb
	ZuqFzZaG9qan71wBu2rMpJ+6ZKtUx47cGYzLuUAlbYiXCd8DwzJdveCH4X4ZWerU0V1rlq
	iSnWI2Gk4f1XDto4sXcGNj0dnWKFT4U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l1ILKL4V;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791600735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0595wVaFUUBehfybfH1h36ypnOiaSDIUhYoXUHtY3vo=;
	b=gTjAewDewOpp4GkzfaZ45nigqBJHbyZ2XDXpLUjlEGPh5keESrvAXdNdaTimHZUe5aHfER
	1QgYf1Dc02sjdlDTinUfRmTDy7LSzdn8UQdkHX6X+3NKeZfZ7t10cfZDxfHVvXfyI2VP0D
	dPtw9bFAvgkGw4gFWZOyi+GcexFrk0Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Of7eU/2uhuH8fTBu2EbBNNco2y0sl8TVLaAxigTFBOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791600732; v=1; x=1792205532;
 b=l1ILKL4V1+78XpJYRyI9djITz8TFqp7XVlwK8qsXSP5l9P2uZc4Hvb12LLUCPUb/i/5HUrPo
 6fZkc5A61bsfzrPmzzYaUf677HGAzsZ3++GXT1ZV7h1sm3jGQCRuGnVOFC+zmghpVxiBBbpi1H1
 XKaKGo3W8LBiPBe6V6ZsJQTM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 81d9745e4f43412c;
	Sat, 10 Oct 2026 02:52:12 +0000
X-Mizu-Trace-ID: 81d9745e4f43412c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2] mm/hugetlb: move hugetlb_sysfs_initialized into
 hugetlb_register_all_nodes()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261009142010.552614-1-lienze@kylinos.cn>
Date: Sat, 10 Oct 2026 10:51:56 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 enze.li@gmx.com
Content-Transfer-Encoding: 7bit
Message-Id: <6BA27CB5-66A9-44A0-A419-001859EFDE38@linux.dev>
References: <20261009142010.552614-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1587320006
X-Rspam-User: 
X-Stat-Signature: griyejd98p4x7ec8jfsqdku9octgubjh
X-HE-Tag: 1791600734-709177
X-HE-Meta: U2FsdGVkX1+SL6aDM6t6I73+CslTroDmjBwmOi0IkHJTid7l0/x4d+CTr0v2FyeDWQUpfo9hgPCJhR4wWVMWBMkUQinNy5lxZO7BoFhvit71dQWajPFohUYwMlNlvm8t960pgc0C/PeoUA/oFJC5SXYxOMoH7Dr8aTJ1ubwFIMiq3yFci4woZ+gpixfz2s64RgGqDDsvpjEDowa7SpLJCev132p0c9gZVcflcwhrtMi46cZn0Pob5SJgUI32pCckpXHD1iCeJD/726Wq467pL/pvK18YdKM0vBlVZB66Kfay0KCgvyTh8N65aBDTVr+PPGdsR/EQa4CIMkcoFHc3Ot5O6ac1ANZuyIZFCl4hgLI//3mGofVmsAGx7SA2zy3IhFuBX0NnJRec7g1c2UVylrkgiA5oUo9Qx5K0DXebfUWCMaQ3iXAyBMgoc71p1Zl2cPH+pTj27GCARTfcavsMdwHXWzKf+z6aofN4pvqKOud9ZoPIJwwPZ2MSjLFBcOdZM0vDC7sP1K85jqSAZ/s4tgGxBUyB3sc5QYePFde2sNyb2JLdZVRhsQE+5bGNF3uEGW8bLdLjcyUXQD53RqhHW/dWLa5bgCndD5CgPsaQF88D71MdDbQ8kbIQE+T9iS0NHZ+pv8ACc2I6pbkOL4+41+5wsqTm1mBkYZW/RD0qtAJJMCA2YggzEoUD9HWMUtSKlXvh7NK2XdHDSb2tbz4kPlfXnFk8RiZr0nMyGzc6ERYJ0tTgJ0wwVhm2v9NEBC6wXMTgnGpn0nZHz+go2/PXgXB0+u9nc9UtM6Lsh5axN9MWWfO3a2YYRaCcj+0GjPFMDcKdwdj9Z3fC/LtOWGo/tpNFoBfLYHBXBVJ7/dCoW3twMe9iSO/2p0nXy5IuIXMhvM0bLS1ueLFr2tOMqULRSffHLijSRXRnqtX7kTEPhr6dKuURowTRrJHyJIKT1l357hBBDfp2JNaJqljCTtO
 4Lsw4z3M
 JXxiKRbaTi5ySMn3J3NeopNoFJoY49ZKSP7/xIG7CPYS+z3VpKedIYeGT+rpK2jApqyuE1EPxA3du4cgxxLLAAKjji2OutReBW9Hy+DzSvQ5JtKAvFL39/OM+u4MNLjJSga5AX+ARiBcsx13kSZjyjfpLAhb3mYjJp13uBvYQYfvVNpx202bHdImVHfqKRM2RPmOnroqqekZEK1G7BmMZ9xCeUhDEnMZltDJIjtOA5JZcxos+PeCgYsAELytx0WZMGof2KUxAS3luQQBxMHEOt+l4p4TUN+y8ECyxTRa/FSMZAccCwpJvIXKUUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 9, 2026, at 22:20, Enze Li <lienze@kylinos.cn> wrote:
> 
> hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
> assignment with an #ifdef CONFIG_NUMA block, while the following
> hugetlb_register_all_nodes() call is left unguarded and relies on the empty
> !CONFIG_NUMA stub.
> 
> Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
> before it registers the online nodes, so the #ifdef in hugetlb_sysfs_init()
> can go away.  Keep the !CONFIG_NUMA stub, so the call site is unconditional
> in both configurations.
> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


