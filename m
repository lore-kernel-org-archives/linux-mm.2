Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A3FCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345EB6B0005; Wed, 13 May 2026 03:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6A76B008A; Wed, 13 May 2026 03:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5236B008C; Wed, 13 May 2026 03:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD616B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:40:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A4B01C0656
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:40:00 +0000 (UTC)
X-FDA: 84761597760.10.8C856BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E26C012000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:39:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vr2iM/6n";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778657998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/y9HYVhTKXJ6HzgHramPlrNMHQHI1b26txP9Q/bkz3Q=;
	b=IdqtMGLlc/SeNdCtbJ1mOFNn6EIlenbMLkif1ShZshm4A6KkTBvEI6z3qCywryXrcGUOF7
	yr+rflEQDgzKMDIoTQitjEc5faomEsDrIu+tlH4hlgWruTwEkZgkpTEs3Mc4bryP+xEir4
	7HVlnmUblyNcZ8sjyh6aGb95yycr15U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vr2iM/6n";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778657998; a=rsa-sha256;
	cv=none;
	b=8f6LcR1xlsMSm+1+2jD3mGUmF6JKQt5YTqNTH56JKusbNpjlo3BEVCJsIUzS5QNnyiuAIM
	z/yKEriiyloB/cMuOfdaMgnvFtjYnsJF27aU24qnkcmQdnXYc1KXRKUwEVY2Rvht5reUD0
	EMHJ9KnNea133i281+TH7mE8bQfAkG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3998560139;
	Wed, 13 May 2026 07:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B474C2BCC6;
	Wed, 13 May 2026 07:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778657997;
	bh=IoMzcxa3sQuNWbRoYH6zZml0fZrcVAoPzGkXIPNlJEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vr2iM/6nX7JbyPyoq5XKeype3OGHyJtV+KQ187Fo6SL7mgco1ZwXRRb2z1aOSr31O
	 8mKDyrPwKyk5Na3J9wAwaNUV8vVnTkrrp8wpUFOPQKRCRAFWWmQdIHlQomz2Yzpaw6
	 HLx7nt84vK+4Y4nLlnLoqumTgUcecMcuT5hyVtU0ay3CfSLhp0zcz7IduEdmZmrDfH
	 Z3nKZl7cp9xCmP0ibzGMWyd6rY3AarEKD6ublZ//ebpe9YMgQexTi99XjiEZHprNtD
	 u/bp+kYTSOOzAvJnP7uQbIWW3E9GnBpm8lAtporwQlwpcBSJchoDMtTlR06cy4Uq1R
	 rEtpTVpXx306Q==
Message-ID: <0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org>
Date: Wed, 13 May 2026 09:39:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com,
 richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260426062718.1238437-1-surenb@google.com>
 <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
 <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E26C012000B
X-Rspam-User: 
X-Stat-Signature: qgcke7u39d6a5ac8arcehzsxfhnoqc15
X-HE-Tag: 1778657998-41206
X-HE-Meta: U2FsdGVkX18HDjz2z56aIH4LxbFRtsjSfxUTOzvtxscXsXKDaN/GN0F1Xegp/Ppal5uWXdqTMYOjs3L7wEv21NKidIJbyR/3U1MlMZPi/NZjNzQ777K4kneLy/UFZldIvqJ8fbJ3JV8ypoFMoc5DWAIO9lNH6ic83qxYqJkWMq3/UVFTcykjKBzNsl6y5WezQxZnaIxYYLXm7BvuNnnU6V3EKFJy7u9H8nPYAQ6uRLmzyatQQE+3xsMSJ0nWbPOR/U+6rYiF6UlZfPAwtSv9dCn9LEfYwl67OIKWL1b+dgfhZgQm2ISCqTRY+3MRwAfe6TaidcDV+fEDCZbqdXaj5tH2PnPHAaqn0foGnP9gsbCC6k9X1ru1t48y9HnSqkQYbIxv244F4B5BLL3u7B5qQCdKk/PegCd9Zv2RcJIDIQ1z2+hLmU7RvJxb6I5o5AWGEC2i78Iy6OLjWbcEoXLsAwzj+u4L5Wv7l+Aqzl0SQzwsBl5ZZh6+sADKuxAwAJCVjTex3IBv7AeCEpE75Eg3IvoazlFDj3v81UredVnjveWivcuddB8XygXMyA+qjqGRr7RUhNBMjatpZ3nKifgRNmewiLQ4KV452YMNp4lYPbGM+lthEpSiOdjP4HT73TS/c/oUjc6SsStQjCcagYCiBtgjcxqV1LQaJqBAdGrD6x+iy1Is0ZmXP2x83V6DdepiF/XHF5UHuwMCFxEdZvoFtHgRsEpDmEFAnNn0FZTN1HgbWRNeofPhd5vefvE2gSDxiwdpbTveq+MVqNgb1gZvjOtpVzlYcVFJRd8EwVRTDIlpcLzYzTtmd8gOEy/RHK24SmPmEZ6HM/K/58br+9zwiBkIuJpEO/ppj07yO2yvtSli0P4yuWUpkte3lQ0GiOWBw6jx6XjJSoh0YLQfDmjECpRb40CJnJ37l90fcn4R42Z10X4J9P7fi9ojFLbJh9HZHNYE1awGKQxx11jSv4m
 ilwRowgX
 eglUPHLoDhemIbnz4urKqzZqcGX2ao+Z7Gg1PiNUPwfTAwmIrs4SgP47MYDkCulHH0S5V/VPyd02ymmS/vVdHn0Nh/X2rNR6ojq7KvPDWjN/ATiFRLHQUC/wjy/iIg2lKVSkfI0C2WnlbGBnnJIDDH6cDg6BzMXdFXBz81aDDTEKQiBqdoiszANjD7SwNrPi1Ug14Pc8gP9IQ+mGdJ9JnWEZT8wNl/CYbSmovK9MrCs4LdJiQ+uJL1yyRhAE8vlcXAK0wNaoLe/MQhQs0ChGS2N51z/lf4wpwFrOsn7mS+4Cs2lIwa0WWLaSVK20o9T4vC4szHIBVbF0A9eqi7He9ggJpMoO9eNrlNSP9pSrLpYQeeVf6cPvsE0vDoiKOZNIUHnZDn1SRbmtY4ukagRbvPXTMD4/tHG/U+3/oeIr3m4izmY749bl3fOH0JPl8zOokPtE/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 05:58, Suren Baghdasaryan wrote:
> On Tue, May 12, 2026 at 2:28 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/26/26 08:27, Suren Baghdasaryan wrote:
>>> Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
>>> similar to /proc/pid/maps to reduce contention on central mmap_lock. One
>>> major difference between maps and smaps/numa_maps reading is that the
>>> latter executes page table walk which can't be done under RCU due to a
>>> possibility of sleeping. Therefore we drop RCU read lock before this walk
>>> while keeping the VMA locked. After the walk we retake RCU read lock,
>>> reset VMA iterator and proceed with the next VMA.
>>
>> With many small VMAs, is that overhead noticable?
> 
> It might be but the point of this patchset (and the previous one that
> made a similar change for /proc/pid/maps) is to reduce mmap_lock
> contention, not to speed up the read operation, which is not a
> performance critical part.

Well, this interface has been around .. forever, so if there is a noticeable
change in performance it should be called out.

> The original problem that Paul McKenney
> described and which kicked these series of changes is that a
> low-priority monitoring process reading /proc/pid/{maps|smaps|...} can
> block a high-priority updates by holding the mmap_lock. You can see
> details about this problem and the numbers Paul obtained with the
> previous change in here:
> https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/

Yes, I know. A problem that has been around ... forever as well :)

-- 
Cheers,

David

