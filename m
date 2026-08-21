Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4653C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1CD6B0095; Fri, 21 Aug 2026 12:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A97A6B009B; Fri, 21 Aug 2026 12:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7970C6B009D; Fri, 21 Aug 2026 12:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 498676B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:18:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF4361201CC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:18:48 +0000 (UTC)
X-FDA: 85125785136.23.8D62377
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EABCD140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:18:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwnzrW1h;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787329127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bK5Z1U/LtfHGrR9XRRCoM6YDapABh0PULQPjbOEEkig=;
	b=YBQ1zZIoLN42KXQIMRtb6ksMMnBTqAU69dTasxWrQwRib+EE1MvOh9lDc2YSuIlWAefWwC
	9D7z2h5T8itexC55aaPfWTb/+zuHJPodTS5La6BITjQZfzTkEjBx2EnkHefC2XkAzitCv5
	/16C7+X3cvqV2qkk+6FynXuU9/WbYHQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwnzrW1h;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787329127;
	b=Y6xIYNzmaDb3O3MfBwobHclzkyrmpwHfEXoJvoS+uz2yR6+gOi00r2zoG9OS8e9J4Th+IA
	vjL0Qw54+PM/BAJN9QdSZjzY0zJWNJOErG032ZvsPGGrgW5C8MZF97RSn1HumrbbGdFxnu
	eBGPkRzwktJ+jmJwYKaoUzz0c5T8oPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE7B542A11;
	Fri, 21 Aug 2026 16:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A99F1F00AC4;
	Fri, 21 Aug 2026 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787329125;
	bh=bK5Z1U/LtfHGrR9XRRCoM6YDapABh0PULQPjbOEEkig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fwnzrW1hvWd7+dYVdCO0D24yMeJ8pAz2tbo9J8BJrTHPO07gILIZdtDp11i9HKbAn
	 8lWd0+arD3ka6gGt/VRMEeMx8Z5IL2ZtVfU59rzjyFmejicGc3aOL9qP9w+ci8eXCG
	 fbT/CoYwcWKK1b3xuNgOl9ZI9M+h+oMUNOHQ+2kSbxAg3Dsplclea6S73VJjtC7y9x
	 OEI893e+vt2s6T4UdpdyU8nLFpTk7zuxlkfDyOhr96TWy+qp4BYqu7r8nOupCJXchP
	 N4XJGOmrKMaYlmPbG46/VYVIMQR3ahO51ep9whI8CwCjIS0ctxc87jJaa7Yrur7xjx
	 AEzxwQpfBy8jg==
Message-ID: <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org>
Date: Fri, 21 Aug 2026 18:18:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in
 parse_test_type()
To: Anshuman Tewari <anshumantewari123@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821114416.12255-1-anshumantewari123@gmail.com>
 <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org>
 <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EABCD140009
X-Stat-Signature: 78ip4mzffz8xp5qenwnokzuq7tofsbhf
X-Rspam-User: 
X-HE-Tag: 1787329126-339339
X-HE-Meta: U2FsdGVkX1+YBryas++qdUrVdmTBHyA+SYGkf1afdYaelgY2XZaxuFWRfmozLbi9SWo/WE5JHjrtd9N7fbGqNZPRia1H0xsCam/gDbg84CGxciMjix+tTHO+fd9h2c73YEUqoeucUNsE3v3PJE5V7XWW9SymMNVfV3919RfRjimCkkZU90XKKsSEx4psb1X7NboHoNp8PrQXs9UOoTpNww8oS0nmYcZCRczImbuMgLv26gAUEqRfhrGaHxZheKMX+Me+fSOJU/TiebuZgocI7X7D4zL96Nl/0QIwjKTZZSZxoF5ktbxvh0jW4R6yw/mWXEGC1iHBqjpu4dgMBzOMarmSrSFJClwLLvQdvUnL7MvMIKf+HzOOORVVUfKQBmKNJxIciv7IUtrotPeKhdecnwPA9jwXCtwO+Ejli2R68NpwdNnD0zEH0Zeh7/DnzumlV30IKrZ06gWEkrRWNStGu9B3Vk34z9oWHj+vI7nrO3gDIOgPCV/azwQz9/SeS7nm+ipTY2czeWDRymmcyYOKaFlFQv9WIO3pWUwtXAZpFyOaQTmnf1XuBGojeWELvorIumistOGT5/QMw9hAHnOGJx0h7jixZ+4tMS2ZtaFezbjBwphKFGndCCCmz2RC8wMGVSbq6Fv2p8Xdox9nrEz5U6yKUK1XIzVvL/RYVVpEPhEhwhEwF6+sFdcU+8KyF7Z/j5CYOdAQLZD3zu7M5YLRYJ3W2x6UK6JYVDOWjmP0mRCh7T41BrdSuKPlwknZelLOtOE6dJlK5kisAsP8Aexh6INplIl+ujHAKY9rqdkhD6htflaN+ZE+fHAYkmwcHZaECkttERodjx/dX6BIq2C8MS8tX0p3Sc33CCnf5RyIsLBnanQHzL+D3tfTUFmW7oY5W+1cTyXXjsOPABjnNQjmdCm7JFKnmlQT855AjOJr+efnm1fvJbgwulEsMmyOBx/8XazQHu9Wf5M0XnD2Lyy
 cpEjLu7l
 Ea9igUbcS5DYdkIgsNWbPHW28XmkBVFq6eo87/KI4BnM3XA7gMhvkop/X3NdQZ/PhQjaOVTho0MGL2r/zorRwIYMZm8i682Vm3dQLxJByUkMw3rmKr8iVxGAJfOJNV1n0iifSwPbDa3ACoF04Smi5sKFG+9z/DXY9N/KiA5VUOY+cq7cEcJlQjXGgGjcALVZlUHvvpDvL11axi9axpEwOZx1EJvjfV/YBKy1xB5ZNCO73fyY3OdU6epSkik1RpYR4JlVcsJe/s58/cLyw+1n4es349YaWWQuyu7fuOP0jb170xob9ldynl2+qjlSRIM5mdgDBrVDKmQs0sl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 18:09, Anshuman Tewari wrote:
> Thanks David, agreed — strdup() is overkill here for a single-use
> parse, and dropping it is the right call.
> 
> One small consideration on the approach: working on argv[0] in place
> means strsep() will overwrite the : separator with '\0', so the
> original string (e.g. "khugepaged:anon") ends up truncated after
> parsing. Nothing today reads argv[0] again afterward, so it's safe as
> things stand, but it does mean correctness quietly depends on that
> staying true — a future change that logs argv[0], re-parses it, or
> echoes it back in an error/usage message would get the mutated version
> instead of what the user actually typed.
> 
> If we'd rather not rely on that invariant, an alternative that still
> avoids strdup()/free() entirely: copy the type argument into a small
> fixed-size stack buffer (with a bounds check against its length first)
> and run strsep() on that copy instead of on argv[0] directly. Same
> benefit as your version — no allocation, nothing to free, no
> NULL-check needed — but argv[0] itself stays untouched.
> 
> Happy to write this up as a v2 if it seems worthwhile, or if you think
> relying on "nothing downstream needs argv[0]" is fine as-is, I'm okay
> going with your version too. Your call.

I don't think we have to worry about other such argv[0] users. If they ever
appear, basic testing would reveal them.

-- 
Cheers,

David

