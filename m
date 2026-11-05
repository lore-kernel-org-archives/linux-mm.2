Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D4E606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j0F53fwV
Received: by kanga.kvack.org (Postfix)
	id 18BAB6B05B3; Thu,  5 Nov 2026 04:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CE36B05B5; Thu,  5 Nov 2026 04:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BD06B05BC; Thu,  5 Nov 2026 04:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD43C6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:56:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 641DC1C4186
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:56:49 +0000 (UTC)
X-FDA: 85400611338.11.1B8CE1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B582240005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:56:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0F53fwV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmGcTmkZGclye3zFlf2LFFFXhokGH4wDq1/1wV5t+Es=;
	b=OzeaYXOJLJMYuVedsP94CHox/4tk/45dpbILrG9N9MzoZwJ/lENbhfxfJnOF7lq2Fb0gEb
	xIRWhaNRvcmrlJ5j9903lYea6m28mBzeY69ElJC5n7LlVBbIXIqDe4OuLRWeNCch4cImCy
	4ug4n4vjRmDarajDBdFHPZKh+n+3qZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872607;
	b=i6PFbaQAo+zCSOnXllE7xDrRL4wn8SvmwqZ8K+HQVfXHZ/32ieNRCM2yGZ1DoeY4+91ZQW
	jyvBoKDwlTT2cyFcFZ1Pe8fxo51nMgSW3CpVFSqdr8o2QF4/rt4rSXeEbkHEJ77ZG1dKC7
	bXuip1O8T7jMHBz55LfTsTQXTloWUx8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0F53fwV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBF0E4010F;
	Thu,  5 Nov 2026 09:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278131F000C1;
	Thu,  5 Nov 2026 09:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872606;
	bh=EmGcTmkZGclye3zFlf2LFFFXhokGH4wDq1/1wV5t+Es=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=j0F53fwVxIG1kq6Bhvs9mFnDrLRGxsvL2fUXkhsz0DWarIN8uwSUSufs9hfg1tnRU
	 IQBRyKNPvzOYt9OAMKBPap+70kvJmIfj4U6Np01TYQqQJPtylia+ubPQyeSYUmr/Du
	 sG7e6xR3xzq12kFW4t9LzWufY6oaoGQ4/tJ8foJzBbCANQL5EDfFsohrk0SYF7IXFN
	 4ZseDyJxADF0osxNiSIT8GOstt2PNCf1Dd/K8pkXBnveMAzdCy5LuW+4URnDooxaZU
	 1nxR3YnDMwp4vS+lN2Yhvs6EpTEWC3y9WsJww0XgjhhJRvfSGJ9ESw7ICuSMfd7yzT
	 t0qlOYd7hgvsQ==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
 harry@kernel.org, stable@vger.kernel.org
In-Reply-To: <20261030161046.1497894-1-gourry@gourry.net>
References: <20261030161046.1497894-1-gourry@gourry.net>
Subject: Re: [PATCH] mm/mempolicy: use one node set for interleave weights
Message-Id: <179387260380.17106.274216033383622045.b4-ty@b4>
Date: Thu, 05 Nov 2026 10:56:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: f3jmn5rb1kboe943cpxjik7mi9ctoood
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B582240005
X-HE-Tag: 1793872607-755061
X-HE-Meta: U2FsdGVkX18XNJBp5YQCoI6iW3IfQoeiUEi90NUzbPVadh2Db8nM8unBvIU1PZsxw+nkdBJo4haqmuTqJ1xiL+2K08bssowMev3ytgAiBg1rCbmpwqKNWsaMkN3wqVl3/B4bqr4kEWbO8Wyfjo3IDUD7tkHQn+gvBmoqaohU0Luek0KATtVc1yivXyAG6U+cbx+bms8iuHH7VRbqUTHe1Nfj9h3ka5D4Q8/1ZBvZ+yHL/4NkD51sEzr6pW8D7bowYxDELjd82NYcOE05f6Mii435vveOnYSDf5dw5KGIPQ7YdEBNSTCwN4G2+kfx9X3tlV+yacQcKzw5Fmcyifj6ZOrkD5gsgIZTwgQfuy/5oqc7W1BTDpGK2vOTX1y1iFt1Tk8cyaA30baaZecKgeLWk3yIKXD4xfI5BJCzD+LbN7n1nkZlfiBt0LMKJ34EI2umOGia5QhjyFJIREC27FhKTztry/ZUD9lhrwH1+ZqlhWjvPjJ7UWmvAD9frF2jUUuTQCxApnzIqRlpKOiT+HVab5ejVUsmcvqb/PFO5ovWEvBId4qfYnd3pM3LEINTFn1R9qy8RfQmy5jfE4Gb5M7txe9yTAASPoOVuNPMWc848ijsDHgDEhSCvxn7qBjIRD9CPsVzrYyw3FevgN8j49EDzcRJFF0FOvjo/RXKXt43T4AQu7mOy16yAUMIXsGwOyVQObhhnBwTuX/thh5xVygo2eW7DDqphwno2LLvo4+heGk8EgqLTpJHPfGtSPCcY2CixSN0rXLRRCR9ZUg1IQRmeaAJrOo486c+XfXTUZQoYTJFNQs52VEAM59CqOHZ1KM7KtOz7f3kGjiXccPHrhT1/YaGbJxWpczH3lwMY6z1fNgEVzNcWHrVY9Txvd+ususLHo8NPUYPskdUPRTJ/XD99bK6JWnSR/Cy7vNtH//pQnZd0rG9I72kBpK6bH3LU1BRTMLxApiEKyBnUzhJ/dS
 9NykzPFQ
 HCOhbmDHagLvHnoRAzzLBjN+E6XCEeXB4XKxBUlBZinFopf7uOax+WEv/2P60OalzjFyTC6yLrDdGExW+wrxFxOUZBRMOx4pDNHKtfwUCuHPnpyXlQTzb5OxP8xfIopQ5j+2JiHB4PpFWMqZIuReJYItcQ0cQ2UPtx2snwKeI8dS+exkvnIiIcgd1Q4oSe29HXHsATyFCMHLDGXgpDIqmR5rsvNZ+bMce9AnnPsW0XzKv8lMPu1q/lVVBWLDFAxDHfMAouMqdOTganweKFJfTDpPp76At547bhJ1I1xGzupwZBZ7A6jdS/nbiJE5+l/P1JC44c1jJWa2lzhSPOTRXvmjSL9Jac19jIi+NcDnEqPnmf9BtlMM59aA4iRHQze7Z5tFu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 12:10:46 -0400, Gregory Price (Meta) wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Switching weighted interleave back to automatic mode while memory is
> being onlined can cause a kernel divide error on x86, and a panic if
> panic_on_oops is set.
> 
> reduce_interleave_weights() scans N_MEMORY three times, but hotplug
> can cause N_MEMORY to change at runtime - and torn reads on that
> nodemask can cause a total sum of zero bandwidth.  A node that
> was hot-unplugged and then hotplugged back can then cause this
> loop to generate a div/0.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: mempolicy-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/mempolicy: use one node set for interleave weights
      https://git.kernel.org/mm/core/c/f6484ebb

-- 
Cheers,

David


