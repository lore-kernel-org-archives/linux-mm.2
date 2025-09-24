Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725B8CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 03:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67048E000B; Tue, 23 Sep 2025 23:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0B88E0001; Tue, 23 Sep 2025 23:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF6B8E000B; Tue, 23 Sep 2025 23:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 994108E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 23:19:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33CC1561AB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:19:07 +0000 (UTC)
X-FDA: 83922687534.06.12B960A
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4291040003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:19:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jkqkYM/7";
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758683945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL7CYeR7dElaAmM/uf3P4L9Zdyfei+4i0an9LllGORI=;
	b=jELa+2aiGWnMJhntSyuKSJ+4bb/l8NUeDU08UNQta18VAX1S7UbAB5Zb+EBez80cwLntee
	ZseNqYJAMdTGEiJ7Iv72OMO3bR2NyQl1nxenDpGxmmPSnUNftkGEHyVZ6NboFAmV/Y+33X
	2Yvl9Ydj0q4CNU+RRjbGT0qAjF7GCIo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jkqkYM/7";
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758683945; a=rsa-sha256;
	cv=none;
	b=8Vulu1sd2MKZ5bTensqWVKLVY6l/VaKX8ExBhkgiLHHfa3kkquT0dcUI1YWEibXlPXdNVA
	vg3LihWr0k8yCADSH2QXxkt6d/x+hqD3mFWXX2BGmvoNTjtLRf58VOFyMG7/cIrU2XOGYl
	cEOVvIlvg9LaqU/KYws1pKictqgfqYc=
Message-ID: <72d3eaf2-09ec-4c87-a680-636cc578a32d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758683943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL7CYeR7dElaAmM/uf3P4L9Zdyfei+4i0an9LllGORI=;
	b=jkqkYM/7tnMSDP+GCyt2eC7fRP6URhc6GDU+QIDsvBo9vwET5ugzHet60QjaC0HptI3nfO
	5CMi82+5Eo8zQKFYbqB0SiyKsPvEcAUNe+/wHzrb8y/n4a866UjAeLUFmB2mUnGNDYoQFK
	WggiqLXjhr9m3U/5ILnSZs6fiSmQg3U=
Date: Wed, 24 Sep 2025 11:18:52 +0800
MIME-Version: 1.0
Subject: Re: [Patch v3 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>, dev.jain@arm.com, akpm@linux-foundation.org,
 baohua@kernel.org, ryan.roberts@arm.com, david@redhat.com,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, npache@redhat.com,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-3-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250924004854.29889-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4291040003
X-Stat-Signature: ny4p1xinnysepahyhfpbu4he1jjp4k3k
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758683945-333015
X-HE-Meta: U2FsdGVkX19mSYR+MJwru733xlDA5RFxrdEl5aenKLsMoHvi5tR+sTCaBjcm2kymgYscE4kpJ6ord6mOVBhuCZvrQ0YCEWzJZiwMYJXbQLFPAUuekwzMUwUi+uUwvD+8fqvzOYhLjkl5J/H1okquKK2NILIkoK08F9U8XzIqqnU6hvbDoDaUCBuheQXa8D+zb34hJHIV7qa+SyYePfZoKYsn1sdxVgy25xLHMMUewAhzLzZ4bSoa0Fuks+iHiVszaEUIDh1lGSwSyaNcXGpatDrWZFhC75r9CfRc8CWCmj5G2z2S9CuGrOYBXcwc3S1agykFLQIvF+ZbK07ScRfyqy2SOyfprD4CDz2I+n5n2KejEgjkpGYdsDmjNkhma1yoDUFAAcZlRg76f4nkHFtBX3oWR8Sj13zM4pu3qq94IO5/E5QGmm8xy7KNcZXPsI2+ndBZq34LhbfDRGWbuUIPOM2NT8N2RE1+aLEesG4CyzBPxoSZykfkG4JzGsNSOG1ASg0tDOSWy2lq2pN67iJuI2E9utMqnJp87LP1XkuAqlN7hlbSpBsvxNuY5DDHC0Nd7rdtin9Co/ZvEvuf0dHky6kENkmo2yAOv7J4mmI+qz5QtNiAelONbnKAC2pvrmAtHYqFXOhMFJGLgwdyf1CebE8Qj/H6KEeYM9KuDkDg0zY4jWJIOkuFMlnE/JOHX3F8I1YE05z6CQN+8Rpx+rbpQ9dtTiA+4NeCgeACSXpglaNsjop/kaX6TMMMH51wHFiV46kDFGG9I+SZnqsd4vA5uWRxAgjOrzIs3CoXdgJhSeBfWniW2GxjnI6HBXd+rGNAThuJmk3czeJM9fwDRVoy+SUYi8n/z+K9+r8Z8FssYbiFLvtjomIzcPZxUUTZBJNNtVbWv+QPfDKpjoatIgNl6nUp1yg+zBCsyvWbykUJ716V4l1sTyjmI+Kxl8nNPfw9c1ZMfSgkv7mE1ewYG79
 VdAqPsTl
 jg+n3fhjBlyYDZ7JUGsIkAFPSl4Vjawz497n28TKENEgxQDioTFrJBDPU/0BlrPNU153XO03SPnr5QCZvjWcKesN2QvVvNlUfJoYp6+g3yWj54pAabVj4Ct4bYwCOYDvbpTnNJbetgz4wwOpn5kDeKN11LsIpQrnsXdtNPGT7/qcDc0HTYpskbW8ur91eSUsD5wN+joC1qJbqJ967SksswEgsDYAmYr+3snVUs9jXhXEK8wP4gNDdgXoUML8uXD7L+ocPa7oRgl274YCobfMRtgmwEKYOi1Urwp+SkJ/iJByHdT7qAJv5lBpUaL2PWTjPl1nxjsXznjMJZTV3C1h6EklDh0V9KAdg5dRNDOmnRUXoZhhAKkFRoLMJRI1CRjZFcB0zUwYF6PTELrag8slan5KKaiuGuFmykwfTcnYtNkRRFjVgpTS6k8A845/g1x/1VAKxgibW8KDuAvyKO3UwpLnG47RZKResaXpD16g8co5Kt/jxEID2nhgoBHPVBdvGmW8M7DWN93i/n1oJ4mAuyN8cZLvpe/XGAMUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 08:48, Wei Yang wrote:
> Current code is not correct to get struct khugepaged_mm_slot by
> mm_slot_entry() without checking mm_slot is !NULL.  There is no problem
> reported since slot is the first element of struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>

LGTM.
Acked-by: Lance Yang <lance.yang@linux.dev>

[..]

