Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE95BC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C128B6B00AD; Fri, 31 Jul 2026 03:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B758B6B00AF; Fri, 31 Jul 2026 03:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63776B00B0; Fri, 31 Jul 2026 03:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8286B00AD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:11:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F19B2A15AA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:11:38 +0000 (UTC)
X-FDA: 85048201476.21.425D63E
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id C67E3C0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:11:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sCb/Y3ef";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785481897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebw5ehCYj61s8AMpmY777eNYKEp6k+U7a6tepkq/has=;
	b=B2cAyHLER8swLx20sJDgc7AlkPXCEaJ1uLQ1oxG4n5f1H+Z/tSZ3dpp8p8N72l/Q58XgTj
	1jwGUU1q4hpmfe55BY0S8ZQG+249DqXo/amORAInFId/zYSKQvTScgsR4bPDCelPpWw44J
	6thh4FRCQ8QWy9E8IDbiE37QZoSrAxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785481897;
	b=a+9kS/6B5+ALfB8GBBa2qSBxWbKLdL+U9yLYChHCkp7kGug+91Hym0iYhn0gBaGbRxd+HK
	85CMLKUnGO7luE6W907A6zJwiuESbaIORV3JCUkM93NVL1UOldEDe4uD+Yh7YyCUqhum+n
	dsH7rA7C01T3C/SGJ+UKrDESvkm7Df8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sCb/Y3ef";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785481889; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ebw5ehCYj61s8AMpmY777eNYKEp6k+U7a6tepkq/has=;
	b=sCb/Y3efYJcfWwlaAwj36VbGrp4xatRVyHwWEgcFml5Ox1CvCqT8c36NNQiWZH538XkUJJjZsBLQAWkRCrU74OA4mwnoz8xEzsQWeHvmlhpguvFe7a1kCuiXQPkk2wrZJbdO9DyiTE53nMwLGDlIRjEFpXKgQrGwxx8pE/Dk4v8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X87HH0d_1785481886;
Received: from 30.221.147.207(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X87HH0d_1785481886 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Jul 2026 15:11:27 +0800
Message-ID: <85784f76-aa92-4b0c-bda6-d4c3fd190ee0@linux.alibaba.com>
Date: Fri, 31 Jul 2026 15:11:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm: shmem: reject page-aligned fallocate end
 overflow
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-mm@kvack.org
Cc: hughd@google.com, akpm@linux-foundation.org, vega@nebusec.ai
References: <1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C67E3C0006
X-Stat-Signature: zjtg6popds6dip7gapew4qt8keru81kj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785481895-858544
X-HE-Meta: U2FsdGVkX1/2Bd0RlpuhT4vB0IhegQEq1uCKF4ihLMsMkvuKdiF0j4WCdfK30LXT3EqRAu3WAJNlhnmyNgfssuZKbgTQZszqd/gpP9d97zqE+GFxJDagFYT5LWsaDHDVtBK8/e+7M76dnC8hxxdFcAwj4j3Rk27VXVprba/fWrZjSl3a1yCdYBGcs7A1QquK2VSWuljv4XY9ajaAeg6WGChusnv45ec9FiNhJum7M08XXUDCLELypcWIOm7xYJS0vIOkkgxa7YkS1ZLbBfAxp0WP05fccp5QoMpCrIYId8oJz6e5TKVWoEIdKCiIO8o+Ki5aCuSCK7HHSzLcFzAa6ntgmfXGdlL5AuwEtulpKd1vPsMD8UdR22twkWb+y3umnq5EpkcW4IKtyJyMxZgMw4Uo+3xtGTvmrCnlQZAZzu75s/w9452p/evKTRpO6jGcl5tdzDw6dermBj7vdrnRS2S7Ep3gWSjcWbmdl30MqSsM7o/OVcA9pJyU675GM6zgR01gaFJHCYwhDgkI3XpkmI6Xlz0wFEnBdAu8ASd0ossYEglDEXKgd1O9BeWcSWmYXnBL7APAJrc76hwxcnATlvbLup+R7THlQu6BQU4JJHhLx8ziDGA7MxjsABWW6+rzmKr5528ufHoSnHHr37SHJmlsGgh1Y58Z48djwt29+WPJtPJAcsrNlgNG+Br4vJyCj4POKc3i8KmbQOkHOUd/s9bolDkk78giIDgAhVV6WviTJyU8yllCMarnc66QSOOGMcLm9OHdQqeqdYT3h9nX/EKR3WVgomw1f8O2N/h43BcgjowSxZ2ZhqaWrql0+cXg0DI5du51p+Ch1RTTzGboUMnKiIr/HjlK3JxGF+sIeoJn2oLOx5vncv9490/tjM6uJ5P7B9hOZjB4OJH2rbrkVyhK+D+Mch3ii+kfSDqy+gbxFCxuwGFNtN8GSDP4ol/Ba//m2n+C5/72OLCvBF3
 Q81o/ShK
 hEF8DK3+9fmpyPJj08lL3/rerwkvdISgY0tIpNPr2PBVawGJage9aE/DO4WblGwc4sU/KUeGITD/WU2E/vjQEG8vwF3GtbDo0qgxNkfmMVeOadhf+CPjLQgCUNZl8rFFotc8usVJ9yz6Uvsnf0fdaksOObvhQ28O49WrKRwjvBLJ7fotKctYEdUHuvcSzIM0XvsXDMFXePfkgZbIzYKz8WFnD8UyfySsdP7L3LC+JXL+rP/vQtw1dv5zsDdHvWrorVCJPSGIcFwvxJLKVHuI4UTRrvrG3LrDKrAZb24tskfpJrp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/31/26 11:22 AM, Zhiling Zou wrote:
> shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> then rounds that end offset up to a page boundary before entering the
> preallocation loop.
> 
> For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
> len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
> the signed loff_t used for the rounded end calculation. If that wrapped
> value is then converted into a page index, shmem_fallocate() can enter
> the folio allocation loop with an invalid range.
> 
> Use check_add_overflow() when calculating the page-aligned end, and fail
> before entering the allocation loop if the rounded end cannot be
> represented.
> 
> Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
> Reported-by: Vega <vega@nebusec.ai>
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

