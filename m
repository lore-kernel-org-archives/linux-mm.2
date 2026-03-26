Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95750106F319
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36056B012E; Thu, 26 Mar 2026 06:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE65F6B0130; Thu, 26 Mar 2026 06:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBFE6B0131; Thu, 26 Mar 2026 06:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3ED6B012E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:09:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45777C3A05
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:09:58 +0000 (UTC)
X-FDA: 84587793276.09.19F3305
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DAAE20008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:09:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eYbRTcwI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogjEQq2VYSOsESjGtyxpwStVgkt3cuZadmSPRkR3BfE=;
	b=njbU2N3HRCxGP5exC8zmTEMnkBEDngJBHos4sYMTJS8oX4MqN2qog5XXJs+sAgTbjTLI76
	nsTCg35P4n+SGJ7wGUVejx8h3qQsS15rok9yx3KQLXTuGOOHw6kGIG/ILYrsy12vgvk9Fu
	403ZdEZrjFyTFk4wgS3QMec2Gi3uaI0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eYbRTcwI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519796; a=rsa-sha256;
	cv=none;
	b=pHdNO7LxI1Dm7bERIDQBesPaMViqpBoofJnDu808F7GRPmyQdj6Qmo7NGuzRZeBWNSdhpE
	CmIInIg1VGkOrVwiMaOVrL+ggns8v0eoiP1Hen5J5IJjArXY7Sx98URpgrGShavO0AgFg8
	+PvSDwUEHZt36HqhooC7qM6LVN3Ph9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A72843455;
	Thu, 26 Mar 2026 10:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5993DC2BC87;
	Thu, 26 Mar 2026 10:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774519795;
	bh=bfTVXIxid39d9WY787XJgcPJVsqFhm0xqVS0OyBmK5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eYbRTcwIMdlJm2VfJCE0MxYPQF0m37+rtLiLZnYmcHZxmqKv2H6UoKi0g0CgCpVIa
	 lacFzaXsf2ZdllCEFnHzxANXrJKDv28DZ9UIZJJOYY64pzmA2WiqMSEdyA2gq1U6MH
	 7108UsieDd1ZXcxnXCuvgoN1clr+vGkXsXD0ARP/nPhgLni1Nt3KFXRLTKKVYlS8cf
	 lhAygMF+bDTmgL5uhIQXezRL3+wByGQwcIvxmUWK9fhRcIHo3Hqt4yQpEGVfVZYe2W
	 tJZfeWs0bJfYik2drnGI1ytzXrxdYjldEMftpUkWFYmhWMfmrI3pG4hh87akG1oXyZ
	 COug4Kh7MNKuw==
Message-ID: <f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org>
Date: Thu, 26 Mar 2026 11:09:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: vmstat: make refresh interval take effect
 immediately
To: Yang Yingliang <yangyingliang@huawei.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, liushixin2@huawei.com,
 hucool.lihua@huawei.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260326075546.3357901-1-yangyingliang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260326075546.3357901-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6DAAE20008
X-Stat-Signature: 11ecb5khwciiwzts6qb7t4md7wb5fjqg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774519796-200144
X-HE-Meta: U2FsdGVkX18B0JT+dX7uxzl987qFlIh+rvE11Q9oxYJXApeD6kxCAo6ykys/V8mWaVLfWThAkYjLCDWhWjKHhxhWY/oLNnoS2Spm5RGEFOiQVr586YW1PY1nYb9wYDMDjnPKzcKXuSzba52wyk4coTj/lcGJAm/iYrQr/4DjjDYjPGQX0ePUnsz70ZoC+5GSXdpHZdxI9gpOsBk6pSzCEm3BrI+9Y9KNKH3ODd5rqdp4an3KIDFKDaBLolmv6JNW4EOTRCrOT0sPO2K+vWJ0D2YjQwbuD16vI1NVPVaFL2r/HDxxg+HPvqV0no8EevvNMJP9lOhSkYn5q9ExvtEUa+YUD6Jh5J57l5tAfUDSVtL+D9cE1CQ9kdd2QmqIq9pyDzKn7ukXusOWKuWJfLPAr2hqYbjfaDWcn5S1x8RKPt7B/3Bed9JgjJryPuC+W7L2gDH9udEwwK2ajk2aZNYZyb4ETiCOpBM6eV2Wj3He4yT/CD8OfruxwVV+oaySihLOEMCnkGg1c288inpaAko0OKLkYjIWAB8q10b8U6j4yZIkDaDGKctCWjuji3rKprGUWcz3QN+C1fbTervtl8vOROtnO+jWcm9mGy5T/INLENd1BVNtVhHYBHYVvaQP0oah7VckpupWVxWDnE7qy0iNxDiL4S/iwgg1WbZ2iPQJGtNlUe72bvglFpVfp+6I7WY5KttImRbHaFBVuuzIw8QWx+8cHki4UhUk0+Ra10jnuuJV+pl78UJ1RT/7U96g0DY2RIWl8wGKQnoY7wdwN21ITRzhOtUtFEUSApod20IlaX2EI5TS61+JFy5rHIHkMae4s5SEVveBhQAoA9gng8QFNhnQaV0iOyrZUkYfg0zqoK7QIHm/qzeI1uQ/92CIYuKK8EOLn4QE+C2rkuwmvMuNxIYdnRZmJN3KTarHpBDA7iajx9305sH0EoW8AZP+JF4pj111jE+gpgAyjIiRKS+
 JCaE6uhD
 buHbe+bQSrwkEhPPQfWdE4X6MSjfKWfy2xXLQAmnPQMPMrzlO6WeTXEAYybSGMbXYY/F31Pt9WR9f3qRdLL6oIgMnEActETTXkWbOuzEmnIZorWfI0Fsf70NDgB6r/EyWApkoIC1jTvj6gKcoNixBkj1igEU6zmPK579H2ouXMLZ+9rWMgZ/nKJyLDz6XbaU2CUYHDhrC/DsVH5lKUhrstn4Wy+wWOdrgQXjh7uawxqnPa9nsRrGR5JKfxRjrWTb2P7YQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 08:55, Yang Yingliang wrote:
> The refresh workqueue is re-queued after last timer is triggered, so when
> the refresh interval is set, it doesn't take effect immediately.
> 
> It leads a problem like this: if current interval is 8640000s (100 days),
> and we want changing it to 1s, the new interval can't take effect until
> 100 days later.

Well, yes. But, the default is set to HZ. If you set the default to
100days you are probably doing something very wrong in the first place?

What's the use case that warrants the complexity? Even when set to, say,
30s, waiting 30s is not that bad.

Would we maybe just want to set an upper limit to which we clamp? That
would be a lot simpler.

-- 
Cheers,

David

