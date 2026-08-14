Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3240C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 14:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83D46B0310; Fri, 14 Aug 2026 10:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62C46B06C0; Fri, 14 Aug 2026 10:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98D36B06C1; Fri, 14 Aug 2026 10:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80E26B0310
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:10:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D91DA14A5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:10:40 +0000 (UTC)
X-FDA: 85100060640.07.8A2E2DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9581E4000F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:10:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZhG/Qnns";
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786716638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wbh+GzwLRDj8K6sa4FaLievOQOmn4W4a+vnrgcHiZ+8=;
	b=200XI3VyI5IzEPntj1X3hG4XKO48gd1OFdyJ6C1uCzUDH2pG2E8mtNqPF0+jaDQzthy6lG
	ciXcMIz+Db6XmEflT8hyuDA/zmYV1IWh14a935873Fxfzxt23SiUqnn5lnkBjS2Hh66scj
	eReQpXFwnjxPOZHykgkGLWsHYHTSZms=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZhG/Qnns";
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786716638;
	b=np8a3tPfxeDORhV1btj0sBPrmM5lGQO8wnQAX+5dua+yQG2hbPFSzmdt6yGh2ZmJgWn7Vc
	dKlRgE/BU/cvCDNd0E5VmHdKGeElXc28OaPdAWYm0NxQQqcUzBkx7dHFYUJyhz/d4vFc1c
	3FFAlTbfZNMv4IH8Bb2pSp9ndh8G8MQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA8960A59;
	Fri, 14 Aug 2026 14:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7F1F000E9;
	Fri, 14 Aug 2026 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786716637;
	bh=Wbh+GzwLRDj8K6sa4FaLievOQOmn4W4a+vnrgcHiZ+8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZhG/QnnswWAQ8Kb14R80WrGND45IGsu7pq9K3Zs6upUv1ewBLaIalY9bF9lHRwqs1
	 o3il654JMBsdt82inwc+47Wf1d2YGzsDSlqpOSn3EkbRtBuTaJQT63DVPzJpocAAVy
	 JeNpgzRDLx4N+jiN3aczRZ1KeLlcQSqVXlVQeR35syUYLRhCuFrEbYQ47JjNjzrmKR
	 snmY0MCaUo4Hj5AGg0dGEAlAftnDOW5rddY13lMgxP0DPXjgMdnUCpzldC6fY8H6L9
	 rKTDqdOoXu9FDVnpkwsdFcJoF1/uZiJXImnygWHkiX0xChVIY+/8NACnIT9B2U3DPJ
	 SLyf4jkJ6GmoA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  graf@amazon.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH] liveupdate: use scoped_guard for mutex in session
 operations
In-Reply-To: <20260814095506.631274-1-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Fri, 14 Aug 2026 17:55:06 +0800")
References: <20260814095506.631274-1-duanchenghao@kylinos.cn>
Date: Fri, 14 Aug 2026 16:10:34 +0200
Message-ID: <2vxzzeyo23ol.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9581E4000F
X-Stat-Signature: 9b1fs3jdt9hkjm63z8iyshdgof9n954t
X-Rspam-User: 
X-HE-Tag: 1786716638-531794
X-HE-Meta: U2FsdGVkX1+0LfmKtF4Sw44JJYLiP1Tcs9xJYr7AdILnsbTWIcve2YvvYxc8VMcdvu68ax2w5fW0buj/B19jFfP/gCELHRgJvNX0uKonkzMBYqA71G992BlFleFmX1DwEuPR91JqsmxSQ0AokRcQz4SECSl4Je+XPea6cUKv7PI0TkZr8txqY2hMUI+Ukd7puWHcMHNKipoWRGCfmLtp/WsB1T3B6BypwxKBdIYLlez4E0FK84VmX+cwFbisp7dwR+PZseeNzqO+YbQ1MvpSgBc7YvZUJqOTfawRibIvk5tMX7t58EaykYmfunMsNTfmez4h7qPTUj0XgIk7Nqk2nYGfND2dkHdKwrCkZp2sqnAvop0RDEkqOVW57sTrqOIdNWWJGpWj7y3bZHxDGHewHvq+DX0CXUqZEPfHnk8ZVF21lA6UQ33Ab4O2dCGXi7Hud1lLWTkPmZ77olD+veYJdbpGR7udqdRYr7wK5qz0zbc9cCm0FwRpGWO0hMeCGU6vI42HAMNP5Yh3Sh+1XwxDMdbwyJeEIKVVkyKNDVIOODpZY3owOwJfWxiQcUKtNFmc0qyrSBy2mOENCx1S2cJl722fvoIb9tIlDwuT3H5+/7uJAQMjOY9Lz+l9HwkjfGMe2d2RB8o5m05MDVyiq02xsojwhL/SkUrXOtsPHckqybQFCnVoPFwewLi0mRYEKjCXk6pBrHJAitb8+0hJsSzx2JqQYD2jfVJIDZukOZhztTkNAkv7xwety+FwW7DpTsyNmnqMAFPKG9o2dww8kQzs4RiPMjwbxLhq6dqn44Vnwxi6vcrCllu9r5dHSunoWYUJDuahkTZLDp0+s9/scY5+qMWxSUYaXWcbgEaGbua5/zvAtwjtjdy0IbzLRmlOqEd3bCe2UUwWLIOrtRZrkdR4AmHWg3/C7eHAr/Le0zNBtRcmJH/Mflx3qENT5OJQNZOmHa/tuJ6o1YQdrZAbnG1
 NJM5PUlj
 9mB/uiqxUrkzOcw4Z2v6REH8UWiomOkh+FqXsyjdeuw2x/I0Z3vn6ILdFlkC4Zd/FiMSEV+0Y5aRh41rQGTTMS5c9O8GQ2cc7hlx3uJ+XmpR675U1ZPiVZwirqG5R1wIx++oYUw/JGeglrJ3M9N2VfJgZc4hf99aZckuy7QrWXsGq7jvMQj5EEMXlSt63KS3cm01mk4aCcGy3xu8KhEA6VNer9pP8cUnNAZ8JIifc1ptpQQJL7cY1s9DPEuV1ZO1fb8xY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14 2026, Chenghao Duan wrote:

> Replace manually paired mutex_lock/unlock with scoped_guard to align
> with the coding style of the rest of the codebase and simplify locking
> paths.

No. This is done explicitly because we don't want to mix gotos with the
automatic cleanup-style locking. I don't think we should change this.

[...]

-- 
Regards,
Pratyush Yadav

