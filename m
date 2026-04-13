Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD6AEF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF2B6B00C1; Mon, 13 Apr 2026 15:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086B56B00C2; Mon, 13 Apr 2026 15:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEBD6B00C3; Mon, 13 Apr 2026 15:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD7D96B00C1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:41:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8E8DB76CF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:41:01 +0000 (UTC)
X-FDA: 84654550722.20.194A49F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F12C7A0006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:40:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JgZtJK/6";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JgZtJK/6";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109260; a=rsa-sha256;
	cv=none;
	b=mbKW9rZdbhiPReEf4xeIy7+uf7oLtJcoxjpn6zhQvvhufyrgYyW0R+UfDhcLpKE2WYrq7v
	3VNI0XT3w4I9MepdQX7MH4OQEANhLj3tr9BsX/qKxyQ44jzGGlrvx0Z2ztrqA7Tgo1BgXp
	2PqHAUYwmLcz4l3y5eHVoSxUgo3lRGY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHRWQYnFd4CJ6VibBfAr8l4jBh6oH0ZcbP86hq1Zndg=;
	b=8Sv9kLG75igZaLMFsk5H/xWBsUCpo+qTWpctmoowp2Qphk0TZ3s1VMhgbLG3YflCWvj1Lg
	2VBte1yxj2xe47ftRbuFq8g3rNZVUDhUxrGtyMVbtbXZ2s3UeG99Ti8j7iJIW6vMz77nia
	FgnkDf0e1fofOWzBKJA2w2fW3rptlA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FD3961843;
	Mon, 13 Apr 2026 19:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08830C2BCAF;
	Mon, 13 Apr 2026 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776109259;
	bh=3n/Uu2a1dKK5ibn+zUIP0gw654NIOknL9hOGX53p6nk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JgZtJK/6tu56BCfWrlRneew2guuh2eizHFp4Rfv23WjcuVKaTM6hJMBiXUp40FI3T
	 I7/Rf7QAkINChRQF+GmJZClTXjCLp42W88u9189PbN0l9Y90h08IMkAkqlBY6Vc/Bb
	 VaVEW2LslBew4Zsnfs/MHbn8C8oq6dqyjC3EOPYgszHug2EIzuEOex2/xo3a8yb22o
	 5CbtoZWKoHB6b8UGqZlcrvkK2OfkOynlnwm9dIPzNgXLU08/SdEjP0GmUuCAW/tb6e
	 WwrJLNL1gehBHi+IDDIJ/EsykzS3ounIQiI/FH3vyHp/M+FWSmjqlKLmK1yXuRjwh9
	 C73lJeO701WhQ==
Message-ID: <478c5700-8bf5-42b9-ad71-bbc618b36c9c@kernel.org>
Date: Mon, 13 Apr 2026 21:40:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, osalvador@suse.de,
 dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
 <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
 <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F12C7A0006
X-Stat-Signature: dkbiwmg41jipxbjok5nckund6x8w6g91
X-Rspam-User: 
X-HE-Tag: 1776109259-657382
X-HE-Meta: U2FsdGVkX1/mFJJW3BhlZua6t51FvPHE6DLDIKS7p6Rh9vmfmdYzPC9OQGnxs4OCPVpwV6gh20TLZk73DYMTM+oAteD+4P0E3KDS6g0vsuNDHCOn4k3ziw3bki/HBg1TTau5pemkOzhZ2Ct3xm78t/mzvZy91VP/OwxQhNpdf2W6fBBrS6HCapFaSnXI0tXqqOFy798godjwRBgAOUqhKoN5ryNEjKYpccpkFWzzxqhZcliswuL8RuQgG7PxwTez61BajlcREOU/RGBBj9q7AzTz3Iv6pcvzisqgkA1CvT/LjBDrPc1Wy4z/unIpP5wz8iZRJd+WmiNoLk8Paj+pyY8ESS7IpzDD3vacgYiUtpiCpZZGAOCvzwPMEd/3KCKdqLb6DjyCBk1n3vsKOaUdiohe8RwQec4lt4rZ/sSMJWvDb+JTD1kNP5Jjf7cSBTdzjTAUG/n9gjmOyXuey6EsUPtjOeji84nsBI96h07eedrVumMDHUjOd4DTX02/RKTcM58L13T8aZK2DFurEOACG5/ewi1e8yux7aMBM6P5gNeAHQTaK+QqAn57/wZwd31yqSF1vuaW+lmZeOBacpePZjy3/DWX0gK6vE6oGO4el6214DjTxRG4uNYa286ihRDnn0lCOc3OjIb3nVQduLrnn3Ep1Am5T47hO9g1vLjMMej8356oGPZfcVe6lkE3OMzIg8sITXaqLBxJddg88zQB5zHpcO6mkEO0UMI84N4XBFwK4t+1nQ/2ADGnB3x5mEAbYB7cftC4AksS7Wt/mXCiWwiHP4DrbNJEuEBdP+QTQPgEuapkuoMA2n2eo5moBwUqpXX60Xw7oO3SVpfz/eDbdjP/B9nZO3tD/Kr4rWzjzPHv3uwKYc+gCP4CaOP/QqJ9oAjO4AFjwU8yeI2IRkwTS3JYuwuIADSTbWyHSyUQGepaw6TercW9KhlFczbaCU32SAZrDPEDvDwXHJ3q40F
 euMtPEXs
 Gb+xhMImcGJ/caGANY0NNBEOosf4h7lFczRcLLrKQ2xnaq1shz36CM2yOYN0/VS7zNF8XxsbuATZMiAhB+/3hXyAFOx0D3+/mrZBi6revMg1Z9aA+iFnLmBS0WHnbNXiCaLpNUU/xLu6b0U8ZPgCNyn9hKEW74lAcLwuA1Ag8IKaOu2dPEkDzNaisSHrq1i2iv++BWvUfriJOYHPgf/z4W5Ct3cQ0F0rGxuzu/l/au3BtF0MHnNdgo6dvHd8h0t6BnCB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:38, Gregory Price wrote:
> On Mon, Apr 13, 2026 at 05:47:01PM +0200, David Hildenbrand (Arm) wrote:
>>
>> So, really only user space can try offlining the memory after requested
>> onlining succeeded.
>>
>> I don't think any udev rules do that? The usually only request to
>> online, which should be fine.
>>
> 
> In the offline case the block will cease to exist after offlin/remove
> returns, so what should happen is the race on offline just fails and
> the stale object cleans itself up on the way out after failure.
> 
> Userland temporarily sees a stale memory block but can't do anything
> with it because sync'd on hotplug lock.

Exactly.

> 
>> So if a user does that manually, good for him. We just have to make sure
>> that stuff keeps working as expected.
>>
> 
> Yeah the only catch is if a user does something dumb like
> 
>     cat block/state -> online_movable
>     echo offline > block/state
>     echo online > block/state
> 
> But like... don't do that :]

Yes :)

> 
> Udev won't ever offline-online-race like this, so it's not a real issue.
> 
>> Or am I missing a case?
>>
> 
> So yeah, I'm fairly confident this just works.
> 
>>
>> I'll note that offline_and_remove_memory() can take a long time/forever
>> to succeed. User space can abort it by sending a critical signal.
>>
>> For example, if you do
>>
>> $ echo "unplugged" > magic_device_file
>>
>> And it hangs, user space can kill the "echo" command, sending a fatal
>> signal and making offline_and_remove_memory() fail.
>>
>> The question is, if you want to do your best to revert the other offline
>> operations and try re-adding/onlining what you already offlined.
>>
>> offline_and_remove_memory() handles that much nicer internally, as it
>> tries to revert offlining, and only removes once everything was offlined.
>>
>> I think I raised it previously, but you could add a
>> offline_and_remove_memory_ranges() that consumes multiple ranges, and
>> would do this for you under a single lock_device_hotplug().
>>
> 
> I don't think this is a very large lift, just a slightly larger hotplug
> locking scope.  But then - the per-range thing in this set should just
> work, so let me know if it's worth the extra churn.

Well, you can rather cleanly undo the operation if any offlining fails.
If that's not a requirement, then no need to change it!

-- 
Cheers,

David

