Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08211E92722
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 04:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685E06B0088; Mon, 29 Dec 2025 23:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6341B6B0089; Mon, 29 Dec 2025 23:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560286B008A; Mon, 29 Dec 2025 23:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 469B26B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 23:01:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF32FC75E6
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:01:52 +0000 (UTC)
X-FDA: 84274788864.28.9CA3513
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id EABC0A000C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:01:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMtpIgPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767067311; a=rsa-sha256;
	cv=none;
	b=8fs4oQVT1wZjWnaBHvl+UB7mjYp/3dwAZM01lulo1/Tv6i7KcOxGS/jpkjIk5i1xt7Efj7
	RSGxbGHkhbfOFtS4AY4DgqXNQhh8oCphA1Fhm6CkPSbcpWkIdvV8NFdhoMu7yCbzuU7kyu
	gsubevtO9YuWZgVJ3iOLobmi9fqoMy0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HMtpIgPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767067311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wh1jdyymTeALV9AMOvPpN1wNV02zTapRbpXJU8VX2gM=;
	b=me4XYlGWsGasqR/C36RNIrVKR+c8/xGjhxladCRNKm0be6cefOJysXujvu9IqwpHRayE/9
	jp8b1VHQKL6e5zIqDLw0vO5gkcbrpeZ8inivGB9V+z2JQw4M80bRgoeoFKF3BNQoIeq6dB
	SivO+lBn6ht2A4lWFvqTcX+U+zXzv74=
Date: Mon, 29 Dec 2025 20:01:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767067308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wh1jdyymTeALV9AMOvPpN1wNV02zTapRbpXJU8VX2gM=;
	b=HMtpIgPTp6+vmVC3Zw63bq/TJXIqO0pBSV/nDK5lfkbZSxCDWmJKOiXzFU/KuQGc43LtOI
	qmo9bthNashfG8yBi0zVQGQ8pOgP4VdG5ejT+MTgGLw8ANxikcTqCgcnUOYBcXKosMEPrn
	RBYjYfspdvI9HQ2hT0vvIMkCOqzfPmw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <423puqc6tesx7y6l4oqmslbby2rfjenfnw5pn5mgi63aq74jwj@jwgorel2uj3m>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia4ldikrbsj.fsf@castle.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EABC0A000C
X-Rspamd-Server: rspam03
X-Stat-Signature: a9epnh98bpe9x1hg748cwyp6ant1gg36
X-Rspam-User: 
X-HE-Tag: 1767067310-516731
X-HE-Meta: U2FsdGVkX1+Zxnou6fHN5GDHlsF9ihAKSnOcwZqPSlk6krLcAT8hPnG4hTw1iAnoWyOySqorM4QuGwWoThlIpIQQguHQFbQHHstnKlWM1fQFicNDqH+sb30GguOIcBcLweOPCj4taR2wTNvVurVkU+246plGvpsMJLg9XyxDczT+IVTlRzdtX5hly4Up4w3AiTk01e5vLoWOAk9eckgPfBOxGikNQq99S1Ytuxer87FQk4mJm6ciahmSuU0KAf+Yrg2y03iBNmaB/p8mG6lcSlFrvZA777oObpDuH4WdYMaZsWjkhNUzK3iV4wYua2NIypvOiWju6q+q2slyyAWqk97lEfS8rKg9WUdR95KED9SN6BcbdKPWrpg3ZRWE7oO0FO5D438Sl/L0bXOTo9/EP/sCRtBGUuG0wOMo3w+A3h1G7JG3loArhxIm8DLpM5DKz9ANwovM4Z8EOzA+/ufNXEDsKyGvlZaZcLu1pKUppudY+QE+pmu40pqLCgBwk7dOu6DqhYMaNl4RwGa3ysnw5PGhaA2wXXQOSNR/p2h1cVAg7oCc3vXcukt8AGzosD5bJrV0vGKTm6Bg5tIOs7JCyTev8VJMzuvGVyFOKS4xDRZo/owpPnXT2+C5e/od/J7obpvxzz/WA4mL7o7PZVZokk2QaSFhqJz19TaWJEFiwJGwwFCZDN58D52rIUn/oJcZlPsSnM5uWSqT3e2waa7PoB3887t9poZmPGgYW9hemkygj3MtzHotxXrRbmvJ49GT7jyberEWTUdeqWFhBW1dOMdaBIfNary2KEICFQnTHcPhkUjgp1w5Qi0gj3ujLBxRl42FOVLxu2sGZkPI3CAqagnPjBeDLs6XSjr0yZDzlQS4lQRUQUNxbXt0U6xmhaDVTGyjR3D/kLR7qJQuHqYGM0fiq6NZzX6uTOgSpdOJ7VG9XLAwfo6FBRJYcrIA1Q+vd7MsFixsBh8NAHGOru7
 l2AoFJyN
 fGmRGSkQS9unI8eLQ/DzO3Kqu+LKSt1JACgriEDtdJHmiMsyGDlaSFH/5ByE99M+CE6IBnJp4Dg1Yt+TINQP1xmtS+FPHlv2uAzWdBcsRsxJckatX/vH7GTbcTmvijPXkEF88moMHGDVi4VkzonIea/Niz3YoojNHcmonY7TRjTqCo1gRSeKxua42XhzW54iC1I6Yquf/uXv/zOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 01:36:12AM +0000, Roman Gushchin wrote:
> Qi Zheng <qi.zheng@linux.dev> writes:
> 
> Hey!
> 
> I ran this patchset through AI review and it found few regression (which
> can of course be false positives). When you'll have time, can you,
> please, take a look and comment on which are real and which are not?
> 
> Thank you!

Hi Roman, this is really good. I assume this is Gemini model. I see BPF
and networking folks have automated the AI review process which is
really good. I think MM should also adopt that model. Are you looking
into automating MM review bot?

thanks,
Shakeel

