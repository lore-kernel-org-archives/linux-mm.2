Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29694CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C456B0023; Fri, 28 Nov 2025 06:46:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D886B0024; Fri, 28 Nov 2025 06:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579D86B0026; Fri, 28 Nov 2025 06:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48BD16B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:46:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 101A650889
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:46:55 +0000 (UTC)
X-FDA: 84159839190.13.CA4370D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 610FE80014
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:46:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bA9T48to;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764330413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EETNcKUw604DjFqT2YPUv+NT0dLv9i+pwhMN2/YLjag=;
	b=Owp+i9wm9zsOn0jIzX/MZKV0Lpraf5A1qTltsXeV0sy9JuRnYmkPrKTbFkqOhvif1TgO8Y
	TKXo5YxMqvDVxGpqnDVRi7sYYyeNUrH1mHXLQxpMhHb5HApvaeatUjhhpqgyRJ5wZxAxvq
	rAnZpP5ecxAyroTXY3Ue/PgyMOzExgU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bA9T48to;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764330413; a=rsa-sha256;
	cv=none;
	b=ybPcLWtBw/ThsgJ+9yaLIBuxM9pHQ+VkuUic8+DLButG6BvYn8XE3T5hbhXd9sk5Ns1grC
	McM/+GcJuf4A0Fg+Ef+95LIXw4Nx/oJ82IWDrR4VQ9gBOYHEI5aILKqisV2W6F3y3ToQ58
	3eNQuvGxH6ZZOHJ/1+TJU5CpiSZ/l/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0927601FD;
	Fri, 28 Nov 2025 11:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ED8C4CEF1;
	Fri, 28 Nov 2025 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764330412;
	bh=L84MxJ1zzUsygXUlERDXWUYWDf7vHwTSwe7l3Dnez6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bA9T48to0vdh0s3/se4/RFgXFfnCL7QPT24e47eWakdYhudkN993ERKjuGVXz1pzY
	 8yxVepmOaqaVG4iIihwHLuUem4KDP7wFNG2TT/4iROhofFlporbOiPMjRQE4f5GLQP
	 t/bGWk5Qf14x3fITObCHBq6JaviiTxKXegBythv4ugK/4AAoavuYaE9MnegIwiIvOW
	 OpuF60JbDbSDYJW+4UJm5jOuAFD0PK89ZxVDv7/xjKaYcPiAJNuIxD10i7+95BRwNs
	 0+DZ2Mk7j6MvLzGpo1uq3HS3aAs98+LO3rX0t7jIaxdgAUkvWUQHBH6IBdXLLMS1wq
	 yXOw7h5cVOs0g==
Message-ID: <a11effe1-5290-4df0-9607-e0da5e9af3d4@kernel.org>
Date: Fri, 28 Nov 2025 12:46:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH 2/2] hugetlb: add __read_mostly to
 sysctl_hugetlb_shm_group
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, muchun.song@linux.dev, osalvador@suse.de,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20251121194859.265259-1-gourry@gourry.net>
 <20251121194859.265259-2-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251121194859.265259-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 610FE80014
X-Stat-Signature: btyw8mamjuuca8o36emyrmaupfh3mmft
X-Rspam-User: 
X-HE-Tag: 1764330413-188560
X-HE-Meta: U2FsdGVkX1+gZCOnKm9k8yxgahWnrFsAUp2T6gCsmpKfzttOSbSPHZySliXg/M80wRJq4h0Fe5fM5loYSIW8ss9Uvem0d1+xzOFUTQCh9BQ/yZHcnn2IzTEcjLFU9aZl/HV0pUAdRFQe6FUYOkP98z6LlLcHWtUis1PpQBC4jcL3mNJqnA6uG/WG0kkaiuX4zDcmR/3dFaTUFMR785FVXdpU+Zr+V+5NH7QC6qRgvnRB7+5g+fCa4o1KStUFRka7sOT8E7i7HtCp5sI9UMq+xhGK0ugeHWDS1JSgYwOWfoIzWg+UPTGhjvyxN2dLfzEfzz7y0xw+gvbmTxf5+IqG2gOYmJ0ooVvAmHD2rVDAGNbHIMr3rD1JIPwpP+Tvd2nAw6BjBbOeOPHjMiuiIQTzOFmqJEdgs9loQn4eiAGtH9r0uheD1ZR9qSEEZp36/xdjUIf2mQ2S5ivIt6GvG+tw1s2HbOwjGU4iIDg9qtkj0AU3ml6eMAod13Ei/89sOeqx+N3H4KjjJ8in32hS6kBLp1qvLMh4cMjo3lIOfzm4/epzr2+NPSKE9BatqQDx6B22SE9vwo14ULW73fV+d6vINVBn3G66p0W7dwro0bME4m+/0JtSyHCk6c65aC/aS1RE4weGrdzX7xGhaZ01N3GvBTLXNZWl+XTXg+sK5rhYp23lDJ0AKZ12jygyZELp+zcSL3CIt2MTCR9VkxhlG4mEtkZD6fPIZls/TpcgtkS2iTQsOy1BMtnCqoccYaHvDLaMJqzLG5YA338gNtSRSupeReaEaWMCtOzQTfJGTdeyL9en0PawkWGbjG/dvNfyWESPkCZoUZ4gW/BnkECGOG5j0M46yB/9LgUMhrCjHa9Qagp0W6JfpcH5FpDDZRwX4DCQkVRXivEc2FLfB25V30/+1Y3j6gNMa5wT/Dr7QpbU/hHZbgYqtUwRnAXY3eDYidVFM8pcc60H4uLhMeQhlX4
 2xy4JDRU
 LZiXYWftQI3C/lutMMYnxuVYc1tbMU5yA6ELQ+uQ6G7IY7gL35cpRWFsBb6gva+yilxvxmUSbUc0u9LeO3Mp96rNq3pzxG2DkdqWpxei2m4dChtZBH2ghJj90uolimxs4GOaFmU8rj3y/bRp3qj3ZVGy32INSaCYiHBL/6OmkGd/nQcGau/qELe2SXN+lEnnhPJdwMQJ0QOJ6WroiIQYG7SCL0acC5mzSb9MfW5XUVnPzP7y6DpHBIQJs7MxkofUw0taFG63CzydS1xpC4+kw8b+rpQN6Jo1t0UKdrA45ELSDF8MSPUavw6JNPvY/QJ0EBT6lSP7LliIthI98suN8PKASDaZYVOosn36MEljXwuup1VmV+KS5m6ztLo1wSBtNCf8FJCyLZXW/jve9IPGwVSBBTgKBoNSmLPsT2Jdwa3APoS3FGq9UTFA1vQO2FgrMwum0VH/gKoqherCpNYboWZZpRhhh+EPspn6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 20:48, Gregory Price wrote:
> sysctl bits are mostly-read values.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

