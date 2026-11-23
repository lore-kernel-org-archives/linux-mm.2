Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2D2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XvrhYRAE
Received: by kanga.kvack.org (Postfix)
	id 1D3026B05B0; Sun, 22 Nov 2026 22:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB4C6B05B1; Sun, 22 Nov 2026 22:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A086B05BB; Sun, 22 Nov 2026 22:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3B556B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:13:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59CB6A8453
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:13:50 +0000 (UTC)
X-FDA: 85464914220.13.22C7BD2
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37FACC0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:13:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XvrhYRAE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403628;
	b=pL+bFSJje98PbFP30T9QiIPQnHmJrXKlrqyXBJPxFopk38aZOJjIIjYxctK+GSontAqH0J
	4gphM3typ7OjAk374tXsAP+Y61Xg12AgRMvoIPAJ2nZ3JgTE2La79d17xrfzSRTrZA20lg
	ipf8y/xzTUHLubyf6Ik97P6T77C6Qrc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U18C2QTlD6mJ2V8xCyohK38ZhFleFWE9EQ0CHhe9nr0=;
	b=iHDyJSgkgvgEHx7jAIg75k6+H9+kxjHI1upgYdLKfMtlRNycRlg/2C4l2oiX1inYjiP4qW
	iRipd748dVXtPQ9HOLzfkQqtyI4Y8K0RNyOB0WQOoEvReIqsLUz6DHOxxe9jAXuB344tjW
	Q7jMd414yJKMJk0N/Sx0zbw2CDlAcN4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XvrhYRAE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DC+Hvmg4wtHuuxLSzB6tnYTd241eZJs+uGq5EvrA63A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795403625; v=1; x=1796008425;
 b=XvrhYRAEn1py/XepGUc6Cj5P0xtD4dPnh1JRrauOGsOXq40oOojQzMG0a/LIKTNzdp2TcCxE
 MVN9+8ieyBXXNwwSwaiXz6nRF8kWGjYvbaweZ2rIEn5+Kr9l5ECqy62cRtnp6WZtIlMLB4qz11A
 59xeU5LeXhUWxPKgUdvlMJgQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8cfdf9be3d9a39e9;
	Mon, 23 Nov 2026 03:13:45 +0000
X-Mizu-Trace-ID: 8cfdf9be3d9a39e9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 07/19] hugetlb_vmemmap: Allow architectures to make HVO
 enablement boot-time only
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-8-jthoughton@google.com>
Date: Mon, 23 Nov 2026 11:13:27 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <FF5ED811-50D1-4B90-A72C-4606E51C9FD5@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-8-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37FACC0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: edd4cn7ih9sn8486rk7fbudxajqb73sh
X-Rspam-User:
X-HE-Tag: 1795403627-716694
X-HE-Meta: U2FsdGVkX1+ztfiL9hsZDlBVvWwTDIkLvHHqveXJkJ7ePpOPnPwXMzsDzTJYU9rknvSDaXHfp7BRozSauKo0Z+WLv6ARTq0Ti9vYMuhlajqnxPIJiaScXSmWtp6Y2EHAuWhivfAsaERxH427pcNvq+OSPVAL95vS65bP90NYjtdOMd6jT4k0Efz3H5ZpDtPeusphdmVw7FRDG9radW29KrjUGqVklq73atXLKitu5okVRge5Skdx+BqinSERd8JMQG/brdnUMGxR7ro2DiJSxtm1THWxGVl+f7+biK9mHY0iqMTFJiUIGYoWnJCdPW2yjY/tuXnPXZUg0SeX6fcTtc4yz7c7/CUSHD+B+A7YMz0lCXKEeni1t420Bcl6CNZ2ZVOnOan0AeEIVOr6bFA4+dWnFU+dpC/r4anYEvW9IkQHntw/xPq7wrXyIqTCxkrtS2Q6TbXqaMyUmkWWRxX+PfDBOUeFt9GzNlw+ep8JBdQBGXdeIKBVLyDRJ4Cl+esMCfIQKfmLPOmpoctkewPG9eOrrPMH87XIcEIJX+M+a121kJ1Fuq5uwfQSv1bYhMc7TVRgskpu0pAMJv+dmv+9umBatz98nGY8E5i78izIhezfDh4iSr7lkYnls84HSMIgq4ErpcMz7ht5bzsGhc37tIaOBUIFDQUpCUYUZ2MQ7+jHSvo56u9AoUosMzVMP4xmmrml8/4t6sPxY4NtXnqhOnopEeqdv9HpFZFb7MDWzLKKIalaZO4HXCXYuxulEDiH3zOAl2rCXm1EVHPazD11PfYyusbclQ5/lPtZTfNqVRDJXtcUkV4UhuF9b8GQZRWxde2G3cLEymd23rqYOiAV4Bwplv7dFJP9DykYEe2CAZ2R08pKLt7K0Bukiwhi1uw58JtrbG/H8MUoJdhr935DVbZbspG4earNTdq/+MIdC1PDieSy1fu3u/xoMcl9ZO6pPccJVD3aklZBcNt/CZe
 Li5ZSNen
 Tu0ln7xqSlhvEoI3ST1PpwxWJ4frHS/ctf0IoHpPUF218c21YQ/N4xKS7/Dyzp0pXBYixyvVzkLt0bhC7PhGgx5Z3LHoGdYiEV4vxHrG37slzmMSg/Iedywi3B39yRYeo1WZHE1sYg0Wq0ZdBI3Jfp4pOmn1pcVSaj+Wv8LLYez6MNDCUJzEbBX1FO4Z19sB03J5LGZ4To19fRccdYJqcWFGVFl23L3Sw2unZ8o5JknDtZ+CUz7JvqSTpY2lUNYTLv4tpPYhmQupXrbOWnaH7eqE0X1VAf/KtowyGrrKY/riw53cWRUJgCrdlh31+TA00pqS3MZg6WJZA77bMjqtP7CO33TKIl3jrSYoNecYAhQ/Mn1G/rdN04TNHkP8QgoHAcH+2WWYQmXsi1mRt99p1WpBVRwQiMaZgLLuba27G5tNWCDnzOqO3jUTcNbvDd6aYiZ+dpUuUFfBcjo4YJvdgHUSeNSE3PY+ESb14Aw7+2pxAmAhiHquGh+H46mW/4bJ8OJ9+Ul9bWupVYq2XNGTy5IjS6H0/vYKMivvvx+7TmFcsSfVZAI+n8MbuyuhekVI4UfkU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote:
> 
> Architectures may need to configure the system at boot depending on
> whether HVO is enabled. For example, arm64 needs all CPUs to support
> hardware updates of the access flag to safely update the vmemmap in
> place, and may want to refuse to online CPUs that lack it, but only if
> HVO may be used.
> 
> Such configuration is only valid if HVO cannot be enabled later at
> runtime through the vm.hugetlb_optimize_vmemmap sysctl.
> 
> Add CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO for architectures
> to select. When selected, the vm.hugetlb_optimize_vmemmap sysctl is
> read-only, so HVO can only be enabled or disabled with the
> hugetlb_free_vmemmap= kernel command line parameter.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


