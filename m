Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17552104891E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5797F6B00C0; Fri, 27 Feb 2026 17:29:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5271E6B00C1; Fri, 27 Feb 2026 17:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF3C6B00C2; Fri, 27 Feb 2026 17:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 306096B00C0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:29:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBE14BC13A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:29:04 +0000 (UTC)
X-FDA: 84491678208.01.6D83D5F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 71D291C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:28:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=LN+b9pwL;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=intel.com (policy=temperror);
	spf=temperror (imf20.hostedemail.com: error in processing during lookup of dave.hansen@intel.com: DNS error) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772231342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBMN4beJJRsv19RznhrL7fXXllZzY3t1ay1kgOVRjjQ=;
	b=GrJ4gRV4sWRNAEzesQxgjZ+m25o0FJra+D5pGBGCBd92OP2+IM5flmdaqt2Zfq+llflPA4
	kpoPVbAHh+TTiTr0EBtaIPUnbA38KEkC7xUkT6U3Rx6oWGXTnkI4UPOBNpvjp0/bcri9ny
	x7AiufHSe6xWqwWXooqvXg05VVbBgv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772231342; a=rsa-sha256;
	cv=none;
	b=5OsEMfpff+Dgnz3XcLMkzdjZsebYq8JpW4wdLbMOiMiYiCdR5/zvvfbk8dxMiYylIh2QmJ
	AMUFxM/XaNq9kq0ViaoDvozyvmaybtAax48QOSqc9FE6ooXmSquamzSWUuu/jjOcf89l85
	caVMzFTcS1Io6LT4vjR8H/w2nkDnpk4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=LN+b9pwL;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=intel.com (policy=temperror);
	spf=temperror (imf20.hostedemail.com: error in processing during lookup of dave.hansen@intel.com: DNS error) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772231338; x=1803767338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WBMN4beJJRsv19RznhrL7fXXllZzY3t1ay1kgOVRjjQ=;
  b=LN+b9pwLW1MLsWk2Gjzp5kkLchzRJTCb8OG6imnCmQvUxhQOoOoWp++I
   YuWsBH4TdkSFAs7IvrwMdtjqbQnqrDl71Tq5H+sp/y01QxBmFQQBhY/ly
   xcBuZhUReYjoVwTGIcJFGmWkYQgFRB6Dl3bxHya5YeEdlv6FleFtzhx7Z
   Ow2s19SnQ6VnOzAcVUOMWK8BS7JL0eP1lhzrsAtuauoX/GEjm4iOR9NnM
   EnWUy+VKIQA95MC3PaNZRQUp73g7xDO9pn4lbuBbv2ig4WsmENeH+ggg3
   lSlHJYRY5ISlcZ7J6GRWf9gCC+SghZvQexp+DTkFjzfVnG4nGkSBU6If2
   w==;
X-CSE-ConnectionGUID: fM4czahQQyK2phvGecFJQw==
X-CSE-MsgGUID: 9ZdrklC7RrGPRuNcNB2s7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="73509526"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="73509526"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 14:24:32 -0800
X-CSE-ConnectionGUID: mZTer/1DT2+roaW76k2+zw==
X-CSE-MsgGUID: R821IA5bQviByYqPBa0UzA==
X-ExtLoop1: 1
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.111.195]) ([10.125.111.195])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 14:24:31 -0800
Message-ID: <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
Date: Fri, 27 Feb 2026 14:24:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aaH5Z5HTC5GyJ6sT@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71D291C0005
X-Stat-Signature: njedwkjxnic8i4waujy3zrerpxyzgaew
X-Rspam-User: 
X-HE-Tag: 1772231337-466566
X-HE-Meta: U2FsdGVkX1+iI8JqmuZ0noosaGthTHCAlRGrK+M484BfchUGPo5Wn4AKREx7lcHSyRoGMwe8PzGi17s8B/c3YroPbYW3UAZ152HAPJJiuHVKeYMCxQqva6trFHlOd7aox4+pn9rxuUAa5xS/Jfha1tHQgJvWMeTn+SD/c5dCvfwJhCucI17gJO49ALQWnuy9v9uZCLWS/Z6fHH9JP5jt2u4UpnnmuwGXf2zv6H9G/WQqbXbRBBhTIvpY2I+pVC5Frf+AZyc2aJCe6LTUBtypMlRRVqZYPQxD2qOD2H6yHql67Fdsm9dRBowNNpyttEAIm7BN3oxl98dSQkfACXM71kQrXxavPAErsO6QYtVd6CtRMJfky4Ovgvkm9VnQIbDHc7Gd795LJjT8e5bVsUkTeYwZyiBvIwiz04TUC0Y35IRBYwA37bgN9CRFJCFPMQ4VyIXE3Orkn86fROrIpyEqJXZ79M1VURsxtGR9M3dXQJFHUYtR/zUTQk3/bfyh3jfqWdEFoP+bfGikITkjIx+W/jYa7wJDJFRWUzMbm6Pz5CkA+Nmr3LydL6H3whirT3Nk1uWuDdEb2H3AeYImsSZwSVsML+E4JAUuON3d00TITOyATohD42JR+iIdJ8jU961xK0NItRsUFVaeDMlbvIYGcAIykr78hT+WPDphYyWIp29krgJ1bH9gHgT8AxCiTi3HY9KTDCfoxt6rgtfr27H3GJQM7AZIMj31D3M1NabAo9t+N4tGUQntw7hD5DiphbcuWc3zkQ6wDyKOLEQ2jzWyNDE4qAQURk1n0mm8NiTAshwbRiKQmohbS0HG4wx1ymHO7MjSsyfZcZCXY+gzVzTYplXDW8eZWQlUjg2klsoZplqKG0MFRI942it2JE4GMsEfkwrvWMfrKvwVi1iPMGYqvk9gJnURdvCztMpfsM4W9efeMPY/TI8u8SgAtb1YED35QMq51g/lwO3YZNFi/Wo
 uJNUC+ey
 Ko7jcS+r1eBlcv77vTeScMm/uJNRhYFeCIz9YZ8HW1Ehz9iDXWX4igbIKV2HFK/ckmQCIY7fmqH0hd13LakiirIrJhxzJwm+h1O7ZtgQsCqhenG7jIoxeUPMtwaChnwGY/ZQxt/Lopc2/ZHWjdTlcpylyg49R66t6I8n0JpCmk5jisWkJWiEMKVeqhWbedy06xRfV5bX1VTZph5tkXpSP98lprZV4tSABVqgAIo1NpQZYg3k5+AB8ms4wm4HU3KznKgEU85PW2VhwWuNWvM+/Av4Ldf6LgTfqoyZSQwxJn/bgOjng/b+o6yGq3hOjhITd2khB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 12:07, Vishal Moola (Oracle) wrote:
> Do you have any more comments for this series? If not, could you please
> take this through the x86 tree. Thanks 🙂

From a 2-second glance, this doesn't have normal comment style and isn't
using imperative voice. Quite a few "we's". Looks like it needs some
more eyeballs.

