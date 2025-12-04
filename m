Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B585D2A54F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE156B00A4; Thu,  4 Dec 2025 17:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEEB6B00A5; Thu,  4 Dec 2025 17:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBFF6B00A7; Thu,  4 Dec 2025 17:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0696B00A4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:12:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B55051B61
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:12:17 +0000 (UTC)
X-FDA: 84183187914.19.3A04F12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A6DE40006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:12:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAzw1OUH;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6o6wb1SzKvDVPK/vKLO178hrGck2AjfeqCB0/HR958=;
	b=z5588voqAVSj89vzY6jqcvbT7cYG6UmEDtffUm7t9/aH3OcIcZcBdQ+LKDSk9quXPfwdEz
	6lcQ7mw3C+snJiaRHGAjEnzk9ncCQdRCVm+1fgGC4dDNUTybv4wOIHwTlUhV8vl+fEXTHZ
	mzWRwkMZkq5Q6m+Pk2t87/SxdOfCPgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886335; a=rsa-sha256;
	cv=none;
	b=X+AnbMiB+Sq9Gsgfewl8GoxmkcBFLlp/aLQpufpec61SL22ZY4cHxNfcJpvxZ47fG+7aHB
	jSDI8pXwQU/SJmZ3FqbyKRudkyxsEfKSlee08OWKNutrM0XWSAaWzZAqpIXn6t/LVFK7Q2
	biNjqDQbzZyBmdEoUqB9oELYo1vllKE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAzw1OUH;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD13C601ED;
	Thu,  4 Dec 2025 22:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17168C113D0;
	Thu,  4 Dec 2025 22:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764886334;
	bh=ubLwl5+CgitwUP+ApeREHrjaIt9HSqJeqF496mwgdzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IAzw1OUHYgUWBP5mdicRgkXgo68l062ZNu3AOYLPZXPFoAEtFD1fhoIwy2uRycPZY
	 96wUtdi8CnoG3eZUHlVW37tSpWW6YJl6D8dn2jqFgwB+4tDZ9jzkbADts5LgJ94LKX
	 9u5T6aFzJsO61OIQXrXQfZqjRX+qVBy1/I2z7Vxe1H/OExo7dhtAtfnEkgg69CRkGk
	 4VGCkxc6Zf/JDHGdwrUYFCpVp6pb3dBU9b5LZBoBse7FvyGmKojZRmzdvvgpvpiMpb
	 mF5For1ffogsUFSD6jGYvu7hFZWxq0+HwB5Y85vSctNh9hlsn5Ox6Mku0zKBmni9Mb
	 F1Twn2KYLcVzg==
Message-ID: <b64f1627-0627-4e4a-b547-5e54167f318e@kernel.org>
Date: Thu, 4 Dec 2025 23:12:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: Andrew Morton <akpm@linux-foundation.org>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A6DE40006
X-Stat-Signature: jcbik68boqszmymcct68xcrbiim3juim
X-Rspam-User: 
X-HE-Tag: 1764886335-438420
X-HE-Meta: U2FsdGVkX19deUit9uaJ5apLSCYsiEG4IeYO5RTHrIYh3B9yAD2jrPTCkZn0YCYCSXj0/47zuIQWzb6kuaMP7FsHSInHS12bHpotzJy5/YAh6380eV/AfclSL5Qu+BrC4DXw+PfD4XlmgV2eVRikgXG31JTeKWhRCg08jMqqO3C/gQhChU33FcOREpt0Cm/BD0HUEogdYFdRIxyCWc+EAxLNaDkiQs5szOOiHV7WifTjlNacVgZfcZ4tKxhecramZwM4MW3EK2wTDk878KxMexnbK+RjgKL5hSYVkqr8BCip1YyGu4egJYCVaY7jJApAL5dxgajUbayrS4653RTjdj3QSyHBItMIrhKALXHTMLXBcsrrv7Wf3XTJls+NSY5X9Xgx98sX5HdnSyABMH8n7GvXVZ+So6OQ1Sdx18xJwLPVRz6Nqpgp38SbpL/qjgimlSknK7oEdPj4VpCt6e7n5yU0Ws1wPf7bzt9kfSH2AsxgBghN6cVcWrI5uaRhUZY4BQUk8RJPstQn3scsN3cg/lvY/cBnBqclOJjmLChtQsOyXr2fApC1kF2gwTeeyfkkbK8cx0pZ/95SMVEmp5gb9gRLvL+jXtZTmjGcAFujYHLok4KEIoMN+Fe2vO+npZYy08VcmdNQZgcxpwTwFqQO3OsMr+YkM9zv/kXDdHI4VoGa7jsbdzGRJhrFWbkcJyW379uB4E7kn4m1FFQ0oHPDKuZFr9orMZZFsFm3O/8koyQsok088BF119waARPfUzoOUokm3hZIXjwcWDBZOk8RSIFtT+Z3LMZwLWJy0oTqGhbA3SplSjQV2juJ6DiCBBdgSP9tzYjbfhpOwWk04ZTbkonXAFx+Kee0dGS/g+bhipReyod+vRAndjBPBUk31O3IduOJj2t8Vd+d+hecRiPiUht4N6xLlJD5x6Tcd/bghdjHaRS4sXDGxRbLtCotHyvVBGN1o5uqVkEi0xB6si2
 B3XxqB0O
 J7DFx1N4H+uViODgqz6WMIIKIA8N7PvtZfCl8GitlDf1qkSjj/loDQN3Y4XSS4I4wzipEhIVonz3Y1JG8uxfpg1O47cEGs6Ar5h7OxXGRTCcGrIwS8OXASE6UeTxOz79ZPg400xriuQL+4C//BuuciFglUrCt1oDSeC8g0CgkaFi0poPbd876JaW9hka/uQ1PC6X3kfqYY37ERQPx/DN4l6JjBntyIitLlOT00CGGxZ7djkX97R6rQqZyT6Gzt71LNjvCndB7NuLvpd371DWXXlgAa1+nsBo2ffrxn9rKENZvhFCa5Atk2IHzuzS5ovGPGHalWBH4oLh5vgawG/ToFXo4LvovLc6wb7QrctoSBkWxmMUJ3uPvhCg5kmaHiZpnlp0GbmWeeqQwppM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 22:57, Andrew Morton wrote:
> On Wed,  3 Dec 2025 19:33:56 -0700 Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
>>
>> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
>> systems. git fetch-pack fails when cloning large repos and make hangs
>> or errors out of Makefile.build with Error: 139. These failures are
>> random with git clone failing after fetching 1% of the objects, and
>> make hangs while compiling random files.
>>
>> The blow is is one of the git clone failures:
>>
>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
>> Cloning into 'linux_6.19'...
>> remote: Enumerating objects: 11173575, done.
>> remote: Counting objects: 100% (785/785), done.
>> remote: Compressing objects: 100% (373/373), done.
>> remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
>> Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
>> Resolving deltas: 100% (9195212/9195212), done.
>> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
>> fatal: fetch-pack: invalid index-pack output
> 
> 39231e8d6ba7 simply shuffles ifdefs and Kconfig items, so I assume it
> exposed a pre-existing bug.
> 
> Reverting 39231e8d6ba7 will re-hide that bug.
> 
> And that isn't a bad thing.  If we re-hide the bug in 6.18.x and in
> mainline then that relieves the people who are hitting this and it
> takes the pressure off David, Mike and yourself to get the underlying
> bug fixed in a hurry.
> 
> So I think I'll queue this as a hotfix, plan to send it Linuswards in a
> couple of days.
> 
> Or Linus may choose to apply it directly or to do a local revert of
> 39231e8d6ba7.  But I don't see how a local revert will get communicated
> to the 6.18.x maintainers.
> 
> David, Linus, opinions please?

I have so far no indication that this patch here would change anything 
relevant to the problem we are seeing, all it does is changing 
MAX_FOLIO_ORDER that does not affect any logic we would really care 
about here (safety checks and snapshot_page()).

Can we please wait a bit so we have confirmation that it's not a 
leftover from the huge-zero-folio thingy or something different?

As Mike reports, he found ways to reproduce something similar even with 
39231e8d6ba7 reverted.

-- 
Cheers

David

