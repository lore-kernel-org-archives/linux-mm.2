Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6365BCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83CEB6B0093; Fri, 22 May 2026 18:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC926B0095; Fri, 22 May 2026 18:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712656B0096; Fri, 22 May 2026 18:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60F4A6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:36:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B7E092359
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:36:06 +0000 (UTC)
X-FDA: 84796515132.20.4B104C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4984140003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:36:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ca4lWeai;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779489364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PNxfF9jKpfZGGMxsEt7WH5XIcLdvrpSkBTx0xbDwF8=;
	b=LQ6pXJNg/O7KoH5m3NhvXvypGSRnWDUwf9Q0aLJWP2MAhye5gse94/GTZqq5iZqjMlQp21
	IM41AmqDEmQ+xfuUSHDQyoCaLrDABJRPaCnOx1+fg4HlFa6BHO+W5i2aTtll+Z1xFCodiP
	0uSv2FoyX/5TGh+6R9KPMXXUcc6U4x0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ca4lWeai;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779489364; a=rsa-sha256;
	cv=none;
	b=P7c3a8kSTwXqCe+4GRXVPzm0O80Y5EH+6hnYViPE3TluG5GuFEekeZPwrvlIxl+/kWvGsx
	y7pC9FCLmOZws9nWhsIrKhAqHD1enibr8iKdatM61n/1SKg6lZkZcdVNDmHESDFmMPIYAH
	Zc+l5T8D9kOaaqqMAztu+Si36JYr198=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E13C40A7E;
	Fri, 22 May 2026 22:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91241F000E9;
	Fri, 22 May 2026 22:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779489363;
	bh=+PNxfF9jKpfZGGMxsEt7WH5XIcLdvrpSkBTx0xbDwF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ca4lWeaiFVQqYFY0CHniFD5sZ1snWeeIaHVRbRaeXgqZvx0z3ySbFKkkMvQdRpkBv
	 upMWESNCLnk9qzFFB6Bxuf02YzZKDmjKoQpUA+JLvpfcUre0NFwzIk8ezY3VCiG8Ki
	 2XVQZkPKueBzf1UEifzZejgBgWw1Yk3pyqBePUW9LqD5P6VYQmdt4x0X2sraWN4t21
	 Ldm/FTtlLe0FtGM4W7ok1Drz2/a6Qy6dpU0H3jVcUEXYFOsi4yDrNyRcgFBcbEtJ0R
	 hLaraigHu8YDFO0QEcbjkphADGUSo+kMBM1Qo5Sgyz/Pkn93jScSKKps79uJe02mQ7
	 wpBIf4T6vpFlQ==
Message-ID: <db4b46c4-823d-4756-a439-058199a9116e@kernel.org>
Date: Sat, 23 May 2026 00:35:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
 <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
 <20260508092341.GP3126523@noisy.programming.kicks-ass.net>
 <32fc4c35-acdb-4202-8369-ac0fe00c5b86@kernel.org>
 <20260521173549.d5aa510a710b4d77c3f7afeb@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260521173549.d5aa510a710b4d77c3f7afeb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4984140003
X-Stat-Signature: wdtygmfymogzao537pof47ws7sj1ygfj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779489364-415685
X-HE-Meta: U2FsdGVkX1+8FI6xtaezAM31HPNw6dc20RQg+tWQ6H2a5akuoHQNJmEwfxwDbokZXOJ3bF40FnLMSDI5Xjt3fMUB/7AG+1XYz89TPkKhbg+WhfsiFAq8bSFwjqnlQXocOF5TeelwYLsb4dS73oPEhsnxDbsZ7Vz2M06YJaxCxneSHzEe0wHPUCMmLqxuvr25tA/akAj+5DQme7rIZanjK73S++9C+ptLqg6j8LkP/c8xhn3M12xu7xeZOnFV4iucrW5ylHl7mpooAChjybfMo57PmGjWveZjPphwvewBzJnReJ3eg3sN0zsA2zpIHx0/sW/JtkMb+XeqOMe5C7XdBuvTBskaBuc7p5wR+kMwvNET85IRc8JwOVJ2rwlfgbszXOtpD0PiY28oS+AkaAG40ZEcq/6TnptNoEBX94g0YMdP7Bpb5tPnimxvYj6V5HKs5PPFR7tnUU/JgMAxsSpIENz0Jzjzt/sFHW24CaOtpaZIF7mHqliwJ2iKKMAuxslMWc/L0yycuuxBZSbbW6IWELQV7CQYRctDUr7xiGSik+FtqHEENyDe57yW9eidFA99pilq4yYp72CC5NZZCm9enWCd4cUFYPLKwHb60yIi634X1zRpikuhk8bpU7J/tPYhFLUtUM+d4IpbRqh/LkFWgFr86bZ89fv7B8POJ2RKtex52rKrSJe8BnQtqskP5aUfZP0DZsdpgeHq+jXRNE5q0C69WnQzY29v8YI3enQfWLPM3LBon7xlSmXiSZzfcH+Y7Hs4jnKlsWDM3obzO2jpTC2E2S/4WWRjfpTbEXR5kUlMP5Z22ciPy7ezt/JlfkRHjdlz1O1Ujzx5jjUzgLBUPuWq6WJtUdMwgVrNkN+vB2s4i+v9TdZ21xd4BkSgm0ZxIUL9QLULxy9R+2qamh1Po3XcOGj7j+loID+1QUBQJ8aG7+bRGzbupaLbZiwoPo4tfEgVAvfe9BTRBqKvJjf
 jxyg/9Dw
 nxElKelz4q+TSlg8QRN72t8ts5CjyKA31jcC4jLF8D9EV/nNJQ8lPfIMOX3L08joxyTgb4IRzMC/gFb+iBECtPtsgqJvm3w04LLFqDCdlUPhku9oF6icEfqVYHJUm8KKFRTOL2U0QCzJa2fbb34nmNFIzSAK/WwPXIqqcVpEvi4MzoOoisC0rxhXVNE0puCEcBzvzb+C4Oi374tG174V/IH6pie0nA50iftwhGpgAQqrmd0eNBNzHsDfZvJX717831ufh5kDGg984XxtStMir6qxl36l2p9ivIlWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 02:35, Andrew Morton wrote:
> On Fri, 8 May 2026 12:51:31 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>>
>>> I'm thinking this should go in rather more urgent, yes?
>>
>> Yes, please :)
> 
> I'm not seeing this in linux-next so I (re) queued it in mm.git's
> mm-hotfixes-unstble queue, for a 7.1-rcX merge.

Thanks. Dave is aware and didn't get to it yet.

So I'll let him speak up if he wants to let this sit a bit longer here.

-- 
Cheers,

David

