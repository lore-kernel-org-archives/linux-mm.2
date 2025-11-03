Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09915CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641868E00B0; Mon,  3 Nov 2025 12:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6190C8E0057; Mon,  3 Nov 2025 12:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F2A8E00B0; Mon,  3 Nov 2025 12:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4273D8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:06:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1099912A81B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:06:58 +0000 (UTC)
X-FDA: 84069925716.10.31E9218
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7AB6CC000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:06:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4+lnzu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189616; a=rsa-sha256;
	cv=none;
	b=lFMvmDWmjE7laV0UzbNwG2zll9/vdHamQWEgvzRDO7wNjRDBYp2SSNsn9xGwJQlZki/vmi
	wYqVsjlKWPysGkoNsKwLS4H7xY8hpEkRpsHh5K0zYzItkUKqcTAYCMI8XOeWXfHO1m2n8m
	1BhZIz6PwlNfzt7GInPsGJzUOlSZRpI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4+lnzu5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXNNUe+HScAzzMROGJgFOXzKFw2iBITtUWw5Cz5Tocc=;
	b=oomVkJVatzBedZiCjkf8aAprUzaWQpsV4DkOiGIGQmbemfTueQrwXe4YlCHo8xWEzj6b2j
	GYAfdrun42SXsDUUQfcXwUPy8Dhc7gqKngAyJzcJXLDyZH6RAU4dR0E2mG+SWFYVci+3le
	vs+iLOKjxhdj/btvlMrULWrHqoU1MzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00ADD6013B;
	Mon,  3 Nov 2025 17:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C467FC4CEE7;
	Mon,  3 Nov 2025 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189615;
	bh=bxGv/8/30qv9u6TosV/pnkBKN6DycBFjoEKn0mWZGvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i4+lnzu5Ya5JTr+gMtuKgI3KcEKOs8Zg5LFHRxkNFe97CmgErRepFnpthZ7VPHPZK
	 2SYqnfKc5MZBmgOzcSKVWGQHokUSYKt7/GttWha6O54fMv9HveEaCc782JWxWayoxS
	 Ri5MLs9gK+capqsorK+qPGJW98lyLWbXJ4Ea9l7AQqxiOqIZwr6WuzGVT31LwFCVWK
	 IEIl0g7jFG7MH2Tiv/q/5ZQv3k7bGPTtvlUpwu1e9vdKycW2Q6nLaFLnIu6QblX8tk
	 +zuFLal8spd0/hcauQRwAMS25orwvc6FgRcQVo43Z4IgYqYprZ7kAvVFuh1cq5jO7f
	 DzMpRTJr2vioQ==
Message-ID: <b4598fbe-8c4d-4a92-9e8e-836feeba2f15@kernel.org>
Date: Mon, 3 Nov 2025 18:06:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ksm: replace function unmerge_ksm_pages with
 break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-4-pedrodemargomes@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251031174625.127417-4-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AB6CC000C
X-Stat-Signature: 6azf9ie3xdxae681m6za8dmgktckj1xr
X-HE-Tag: 1762189616-120520
X-HE-Meta: U2FsdGVkX1+HFJLEjB0OeDG+EOCjrUcfN1NWkOXktSSdPQiLb26w1XbpDpdcZVvmZ4Sc7YKfvmKpc/npws71S2tZs8VmlD4r9XY9qKT79GIf0DNQqXI2ABsBTVQyDJaDprNBBc2jakN6NngMHwZVmU1HFTy3sEVu8TpHU7dJKqS12CpP8vWV3HUb86SLnF7XoXyiG3ODo9c8bhGf/XXjEwfB/JyH0eDnyPfl26ko1Rg2sqlt6tVX4Cq6H2Q2f93FQHIjTepM9pmrtADtcV8NMyk3Xughnl7nOo7QafOWDEXv6E+gWQsoFX2Vx7W8q25cRbdTvha1JED6H6Mh+G3TFm3/bKzKo2aLb1D8d/a57XTWHDXeGKTYBCoWsGrjUfwWO8Xqmy/2j0Q2HocYYfZRZXp9I5Y/HViod0bVzKPHMabMed2raZUAAi/9HGTUIubZ3o6GYcTdxWFYwVlx5P5hbDq5NhM73OS70258QXerK6UFzEEPNZO4u3T8EWSpQbXYAt1LApwz++TRu3iMI7KupwP6mVF2EkJ7OIYvPauUkpqllE9MdckeID9O+iHRE/uvirKUwOFHMQ1jyIQO3pF1qQ6OsTo2NDWm7/qnS3GgJjKamwiVCAF09OgkyWC5q3QNq6Y9bUaV+tolnmgOx166hM3Hd9xtAua4n2wVYN0YyC/PjbfndoDnwkIOAl3p5dMyMGSkmxH5IpVV5jMqVbpZVOwI3SXwflJegx69BAeYdU7EHFjujo6QKaQcmKZcrX3fNQ764qN52o2cfAoyCCMejdzhZvzW84NOz+ps+hDlTrWDoWnFPlbfQY2bq7E8zPuHU6cEjSrSoCSuf1so8TDuw7iGerG1tPuPKSmyx5zOZHer8L9JQgbe1f+/iV2QJ7qqxahxePqlYIqPZUulHd5KyCer4nbRFuwZ0VR3BEb7BZsyFezp0d1cxt9cwHgT0v/EpjROXEiUTCdzT4b5SwW
 MJ+Ry+2L
 dVUyC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
> Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
> an address range. So replace it with break_ksm().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

