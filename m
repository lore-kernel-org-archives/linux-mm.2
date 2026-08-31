Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1E3C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9732D6B0092; Mon, 31 Aug 2026 07:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9238E6B0099; Mon, 31 Aug 2026 07:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BAB6B009B; Mon, 31 Aug 2026 07:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBC06B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:28:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D73BDA3C10
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:28:47 +0000 (UTC)
X-FDA: 85161342294.03.20D40F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 507AC20006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:28:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SB3scY7d;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gqj2K9+wp90YvEKZMSvL1LZpZwjNHSzCNuGCNxMefXo=;
	b=JplhLnZa7e0mc+gGSA9i7rNng3/npWy/rLqO2TcUIrLrg6jR2pkRd7N0CraOug4jA1rGSP
	3ws4Cme5LWh3HU7ukNPeSjvF1C+fwmOYq1PjyoiHxxSzANBHCAABIgAqUVgfXToC2UHYff
	bANbByhpVhi/PR09RgCKjHejdP1Yjvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175726;
	b=viaA03RCE4QAsFeICCQ6XWUCq05RaEYl/Fu7gl8nr43HvwvSrDKkk1GtMRVY3v2DC93ODx
	LcDeU1EUE18Nb5S8exF3fv8YmadMaRkt1DPmuBw5fbByHz1i7v38xnKiuLCHTK6kG6EHIG
	VaYjmmuIgz3RVbL2Ok+A1RXxx2JaHhA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SB3scY7d;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7ABC960218;
	Mon, 31 Aug 2026 11:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151F1F000E9;
	Mon, 31 Aug 2026 11:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788175725;
	bh=Gqj2K9+wp90YvEKZMSvL1LZpZwjNHSzCNuGCNxMefXo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SB3scY7d63d/eJqv4Mh0utENg6FNoyxZgIZfYT9wskjSLb93/ewvpTUimcqX/GycD
	 ea0MQ6BpzM0/16qegjhq+AUZrlZpEHHkiArnotvBjmtwdKodlaMy+08y3hHkQIK6AC
	 kAbh/Rl8Kbbr3alcBNFvuwg7AztwQLn0+63qIN6qn0nB0HRxIEV6moLayEbXbib4m9
	 wcds6YEC6MT4RzN0hGJlZgWRNfthKz7niDrcjOISOnnRkNo4A7wP2kMVd8VRT6RJC4
	 iSDkFFPBdt7alnLg0sK3x/QULuPoYlRtjTIkKJcPOMir+/q1BUfoP+kPGj0atA8DXv
	 am0ubi84jP7eg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] kho: Convert error handling to immediate return
 pattern
From: Mike Rapoport <rppt@kernel.org>
To: LongWei27 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, hewenliang4@huawei.com
In-Reply-To: <20260824024448.550552-1-longwei27@huawei.com>
References: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
 <20260824024448.550552-1-longwei27@huawei.com>
Date: Mon, 31 Aug 2026 14:28:39 +0300
Message-Id: <178817571946.3691424.3757525664520719609.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 507AC20006
X-Stat-Signature: ezrstat3yx3u9izzya8pai3gmt94h57i
X-HE-Tag: 1788175726-626459
X-HE-Meta: U2FsdGVkX1/WmJuzxsJr4eU0d3arMvI/xJsNG745UY/NfFN81kswSsyIhKd98iMxDPxPtCA6YExVPbCZ/+w/18okjf+yZ9Tf/Q6owkfW9CKrqi48mfzysuTKrAmjzrgYec1Iueg5Gl0q4gOA46jDca2knT+Mhm6iCrlH8K46uPKVrjcz5toOuYRj7ClhkHQA6Ngyn3LARzBQw4dNW303dRf50qn7AFJD+kQbd2tpXiMLKc7LRzN4crItDFWKSeZtq3OoWQ+LzZOHFkXZS6oRqecd58qQ1AgLr/1Er/8HQ5I20m1b4hBMX8cq+ck66xZf/mvR/DuWLQsNmMT4N8+El5tSGitOdIj/LmadxjdRnReCoXVLDrAM8L+QYUuh4PSAsVxl6sxIefz220Ebf0e9IhRwIAvHaXWTyC9nZNLKPyfkAAB7s4Q1EVWm/xeEMwlqxsN1GrLqC/aFZ5R9nzZ4NfEZeXerCXhAI0ub50tT+Hc7RszPH1ECqrUmBZXOHKa3ADbTM+JDU7HhYoaY4PFu7bK1ar4TQatrrHT/X1Edr8m4p1ddtPt1NVdKvyQcK2ZY/gXqXQvGBNqsMJekMciyG1ynOCJfG1VuMrUxTbRXGYYRseB//lISBUjTEJDR7fvcO+5hRkdAbCzjShh3W+CUrk1bYPHJucP9bffS2H1KpVidCzt9fAZx5wg/um43zoD/7vubrE4xGcZJBp1zzQRIOlH6K0vUtM8BHePLev3n+eHiFVGnd9dg4oNd5tx/5cbgSaixNQbaWEIf92+UGOXbuHk4QBgygc5asKnDr210sQy8UiPriruof4MEjfZxKxmaTNsVaQN0ArcOIOdvS30fML+dZv3v6nzML14JiuSUx9gPQMMOPqPKIaaNOrVnmUmXAtWxPdDQULLawV6/J7tHZVkfMdee/KA47F0E+HpbKbIa0xJmcfOw50Xz22Fw7EHubvnw9vGy0nm0a64BUM7
 LuGiNCzj
 8gXRYaRthPwmt/gpwVbD7R07NyXiIOaTCiOar7/RreGe0ZI93MXAoVBMzS6gXKyK/ug+e8rCfxZc2WfG50r5IKR6vPTSG4QclV4uIw8gG5Hl5bg1Jmhpjqz5Z4Fr2ancNVPqy4xWYBqwis7RIBGzfrED+giepgS7QctIe9TT2BeO3A52I8QSp5FGZhUK9RzAlcFGgWsLy93aZlj5uEs+p5j02OK1ZhfTmjR8QbpDK7x2cL8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,


> Replace the chained error accumulation (err |= func()) with immediate
> per-step error checking and early return in kho_out_fdt_setup().
> 
> Two problems with the current approach:
> 1. It continues executing FDT operations even after a failure, which
>    is pointless and potentially unsafe on an invalid FDT context.

Did you actually see failures here or was it an LLM suggesting that they
may happen?

> 2. Bitwise OR of multiple negative error codes produces a result that
>    may not represent any actual error, making debugging misleading.
> 
> Early return fails fast and preserves the original error code for
> accurate diagnosis.

The caller does not care about the exact error value, so the diagnosis
statement is moot at best.
Moreover, libfdt does not return Linux error values.

-- 
Sincerely yours,
Mike.


