Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A9C7CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 17:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638E18E000A; Tue,  7 Oct 2025 13:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6108B8E0003; Tue,  7 Oct 2025 13:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D198E000A; Tue,  7 Oct 2025 13:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43DA08E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:47:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB99FB6547
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:47:24 +0000 (UTC)
X-FDA: 83972050008.28.0DCAF71
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1467110000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:47:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=n5D4QAEh;
	spf=pass (imf14.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759859243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dczTTPELd8aHcA9RSrajs/WbIkYGypdtTEu3wfq5fUQ=;
	b=CnQ2qHbMApkYi0UNJcpT2SP1yf5A8ecensNgtFHFUpE4gOjHTDRNdUOKkBbX1EzTmm6+YE
	yOteIbVWA9SKkBK9TbYAY4sS74dohIMv4BKBjiizWHXvS7B2xP6eA7zyiI1eVd/S3qHYNt
	0bVqaOZkhOIrNyVR2ovK/oF3fmDWBfM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=n5D4QAEh;
	spf=pass (imf14.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759859243; a=rsa-sha256;
	cv=none;
	b=q4m9+q+gOJ+M7fUEgz5vzq4lxjgxA4V8/s8J0zdbv4GidkeZPfeoQ2Xo1BVq5bUbnWI2A4
	9s3zRjE+Jg8fWCajQo+SyTtK8wB5A01nsZwPbv3pSZfweqgY0lf7+cKPj5TE45Hx7LeMa2
	FQ3UgR6T+3UDo342m29DIa+k2k5gmR8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1759859241;
	bh=dczTTPELd8aHcA9RSrajs/WbIkYGypdtTEu3wfq5fUQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=n5D4QAEh+NHMP475F4Zs7wCio0vFockETYLBCIlOjQw07Jzu92NvOJBktfUjab58P
	 MXM8y7kZPMjzTxBUTSteyrjZfm/MxJ4mUH0uDFSCSMwJaeNhFUNbqxedlXSIq49qe9
	 82wsfsYmmZ79ttSTWfatcEQ8eelMFaVS6QLnWFpQ=
Received: by gentwo.org (Postfix, from userid 1003)
	id C3DF4402AF; Tue, 07 Oct 2025 10:47:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C219140137;
	Tue, 07 Oct 2025 10:47:21 -0700 (PDT)
Date: Tue, 7 Oct 2025 10:47:21 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Kees Cook <kees@kernel.org>
cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
    Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
    Jann Horn <jannh@google.com>, 
    Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
    Marco Elver <elver@google.com>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
    Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, 
    Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
    Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, 
    Yafang Shao <laoar.shao@gmail.com>, 
    Tony Ambardar <tony.ambardar@gmail.com>, 
    Alexander Lobakin <aleksander.lobakin@intel.com>, 
    Jan Hendrik Farr <kernel@jfarr.cc>, 
    Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
    linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
    llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
In-Reply-To: <202510071001.11497F6708@keescook>
Message-ID: <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org>
References: <20250315025852.it.568-kees@kernel.org> <20250315031550.473587-2-kees@kernel.org> <aOR15Xb6DfolYM0z@casper.infradead.org> <202510071001.11497F6708@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1467110000C
X-Stat-Signature: a5hqar1fkyn6jspe5bdxepfmwehyuhyq
X-Rspam-User: 
X-HE-Tag: 1759859242-697116
X-HE-Meta: U2FsdGVkX1+LGRoljQDiEci6sOUGC3WGEyXyOpNkB6lRCq5+lLAxVVTM0vjCcb+GdUs42MMCENYkScM1WoWMHcO7twvlz81uhB2xV5scQupSScIcNcRhgZr/Qj0Z8SCOktAvKQdi/2cEU/JZi/ONOaKaDiMT9OA3p+k51gYiGQYMNUWdgTIlFs6N4W5RZl1kMu442X6hTS+DYfdOZy00NBjKMk/RwNyz0MlZMULFUlO790MEFpGnScBtSGGfRAe8havDz5SD0FOAW48eCIWmauwf5r1zQVIhjWfjsCx7Wp4c7SjwdEDZVsaceQqc04BUwbODwuvrna2i3MVz9/OWqilXzmk+OwkLWSbk8P7HkKYW9h/52GtNmVRPxwECXTDTuajerfg/UxPNLnW+xd1a4iZN8g4S3i1u2FwY39JlobhZf0Nw+Y4bEzTKIS3uJgdJYuOpb+WZ4VGVPvo8tm4EbzM/S3lGcwPR1UoSQVVcQSCv/iueSobQW1ja32341nG4QHoGGJsJzI1WekyDmM6p6a5L5f5kIsMcr4eKj1nU6PH2LGRpyh3Arwz1b6mwnv+brO9ZJ3JdMeG8w5NDcfLJwC01pTLMfQjHQZ+uiUFFT2NEm0MFUrkkTSBeguBhJCwd8KVxP6lvtFZeNyzyLLmQ+CeJQBSD4LSIhseuqI40unXN3RwLJyOe9HCgYg+BP3VyQIbWvbDGimJqtgNSyXvIICRWOP4ZfjGOQWNTAMXqCFaGzR955IHyX7Q/62qW8kjCMmFA876aW+IH2d78D1q/U8o7dHDH/FQmTnA0Qa20E3y3/pDVzfbBF6T3CSaGn5EUitae2SK4nOBwI/l4zCLLhiBJeIcGgZYTZZ6iNCnYM4oCzalL1qz5obNGpTjni122JrCoxJt/n+MelJjrESpvgYZFnb9h7a/dmWPizSw8RCYaprHXTnfytbklx/WPp7omBKlOxZ+5YMUwsg6ogQL
 rROHDUgO
 QRJuxZHD07l7f849uF/bIfNAZGFQgJq7g3btOPDolrDVtxuyuRP4qZQ4DOF9f7+AzGHp3ijDkjSFIVpsFr5t8vtHfecoeUsKDPuuJtXqesyLaNgum+o2aZ2992Xq/Mfm8vwfM1rdDlotEjRoL75V+dVbQBjcii3QE9rOuybkNnIkJwM/tsOYsiewX3a7+SXpg6BUPVzHxcuYnliTQSjiRsG6M+9WFDf9akMhMDCaYJhs38y2A1JmprFY8CfFScilnuWBEBTxUn6u4G0cLhbApBHFZgPJjORCOxeiDpV5YAmvOLDwJe5REe+cOu07ex+p/VStGBK/ww7rwocfGcQ6UHot/Jbjxr3q7E2VqVChu2qq7Z0gzUvDfGmzmMB6ZEu+cFBu3mDEwebAGxh0GaBK1YJgmB1nu9xHM5zOQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Oct 2025, Kees Cook wrote:

> But all of that is orthogonal to just _having_ the type info available.

iOS did go the path of creating basically one slab cache for each
"type" of kmalloc for security reasons.

See https://security.apple.com/blog/towards-the-next-generation-of-xnu-memory-safety/


